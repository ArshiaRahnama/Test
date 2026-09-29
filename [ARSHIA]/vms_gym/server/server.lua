local statistics = {}
-- Offers made by an employee wait here until the customer answers.
local pendingOffers = {}

-- Saves a player's statistics and frees their slot.
-- (QB's 'playerDropped' passes a reason string, ESX's 'esx:playerDropped'
-- passes the player id - handle both.)
local function OnPlayerLeft(playerId)
    local id = tonumber(playerId) or source
    if not id then return end
    savePlayerStatistics(id)
    statistics[id] = nil
    pendingOffers[id] = nil
end

-- Customer payment helpers: cash first, then bank for the remainder.
local function GetTotalMoney(xPlayer)
    if Config.Core == "ESX" then
        return (xPlayer.getAccount('money').money or 0) + (xPlayer.getAccount('bank').money or 0)
    elseif Config.Core == "QB-Core" then
        return (xPlayer.PlayerData.money['cash'] or 0) + (xPlayer.PlayerData.money['bank'] or 0)
    end
    return 0
end

local function RemoveMoneySmart(xPlayer, amount)
    if Config.Core == "ESX" then
        local cash = xPlayer.getAccount('money').money or 0
        if cash >= amount then
            xPlayer.removeAccountMoney('money', amount)
        else
            if cash > 0 then xPlayer.removeAccountMoney('money', cash) end
            xPlayer.removeAccountMoney('bank', amount - cash)
        end
    elseif Config.Core == "QB-Core" then
        local cash = xPlayer.PlayerData.money['cash'] or 0
        if cash >= amount then
            xPlayer.Functions.RemoveMoney('cash', amount)
        else
            if cash > 0 then xPlayer.Functions.RemoveMoney('cash', cash) end
            xPlayer.Functions.RemoveMoney('bank', amount - cash)
        end
    end
end

-- The client sends the price/duration, so only accept offers that really
-- exist in Config.Gyms (stops free / negative-price memberships).
local function IsValidMembershipOffer(membershipName, days, price)
    for _, gym in pairs(Config.Gyms) do
        if gym.requiredMembership == membershipName and gym.memberships then
            for _, m in ipairs(gym.memberships) do
                if m.days == days and m.price == price then
                    return gym
                end
            end
        end
    end
    return nil
end

local function GetJobName(xPlayer)
    if not xPlayer then return nil end
    if Config.Core == "ESX" then return xPlayer.job and xPlayer.job.name end
    if Config.Core == "QB-Core" then return xPlayer.PlayerData.job and xPlayer.PlayerData.job.name end
end

-- Splits the money of a sold membership: a cut goes to the DOJ society,
-- the rest to the seller's job (employee sale) or the gym owner job (NPC sale).
local function DistributeMembershipMoney(price, gym, xSeller)
    local rest = price
    local society = Config.MembershipSociety
    if society and society.Enabled and society.Job and (society.Percent or 0) > 0 then
        local cut = math.floor(price * society.Percent / 100)
        if cut > 0 then
            AddMoneyToSociety(cut, society.Job)
            rest = price - cut
        end
    end
    local ownerJob = GetJobName(xSeller) or (gym and gym.ownerJob)
    if ownerJob and rest > 0 then
        AddMoneyToSociety(rest, ownerJob)
    end
end

local function AddPlayerMembership(identifier, membershipName, membershipTime, cb)
	MySQL.Async.insert('INSERT INTO gym_memberships (owner, name, time) VALUES (@owner, @name, @time)', {["@owner"] = identifier, ["@name"] = membershipName, ["@time"] = membershipTime}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end
local function RemovePlayerMembership(identifier, membershipName, cb)
	MySQL.Async.execute('DELETE FROM gym_memberships WHERE owner = @owner AND name = @name', {["@owner"] = identifier, ["@name"] = membershipName}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

local function GetPlayerMemberships(identifier, cb)
	MySQL.Async.fetchAll('SELECT * FROM gym_memberships WHERE owner = @owner', {['@owner'] = identifier}, function(result)
		if cb then
			cb(result)
		end
	end)
end

-- Buying again while a membership is still active extends it instead of
-- creating a duplicate row.
local function GrantMembership(identifier, membershipName, days, cb)
    local now = os.time()
    local add = days * 86400
    MySQL.Async.fetchAll('SELECT time FROM gym_memberships WHERE owner = @owner AND name = @name', {
        ['@owner'] = identifier, ['@name'] = membershipName
    }, function(rows)
        if rows and rows[1] then
            local base = math.max(tonumber(rows[1].time) or now, now)
            MySQL.Async.execute('UPDATE gym_memberships SET time = @time WHERE owner = @owner AND name = @name', {
                ['@time'] = base + add, ['@owner'] = identifier, ['@name'] = membershipName
            }, function() if cb then cb(true) end end)
        else
            AddPlayerMembership(identifier, membershipName, now + add, cb)
        end
    end)
end

if Config.Core == "ESX" then
    ESX = Config.CoreExport()

    AddEventHandler(Config.PlayerLoadedServer, function(playerId, xPlayer, isNew)
        local playerId = playerId
        xPlayer = xPlayer or ESX.GetPlayerFromId(playerId)
        if not xPlayer then return end
        MySQL.Async.fetchAll('SELECT statistics FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result and result[1] and result[1].statistics then
                statistics[playerId] = {
                    identifier = xPlayer.identifier,
                    stats = json.decode(result[1].statistics)
                }
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            else
                statistics[playerId] = {
                    identifier = xPlayer.identifier,
                    stats = {}
                }
                if Config.StatisticsMenu['strenght'] then
                    statistics[playerId].stats['strenght'] = 0.0
                end
                if Config.StatisticsMenu['condition'] then
                    statistics[playerId].stats['condition'] = 0.0
                end
                if Config.StatisticsMenu['shooting'] then
                    statistics[playerId].stats['shooting'] = 0.0
                end
                if Config.StatisticsMenu['driving'] then
                    statistics[playerId].stats['driving'] = 0.0
                end
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            end
        end)
        if Config.EnableMemberships then
            Citizen.Wait(2000)
            GetPlayerMemberships(xPlayer.identifier, function(callback)
                TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
            end)
        end
    end)

    AddEventHandler(Config.PlayerLogoutServer, function(playerId)
        OnPlayerLeft(playerId)
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    RegisterNetEvent(Config.PlayerLoadedServer, function()
        local playerId = source
        local Player = QBCore.Functions.GetPlayer(playerId)
        MySQL.Async.fetchAll('SELECT statistics FROM players WHERE citizenid = @citizenid', {
            ['@citizenid'] = Player.PlayerData.citizenid
        }, function(result)
            if result and result[1] and result[1].statistics then
                statistics[playerId] = {
                    identifier = Player.PlayerData.citizenid,
                    stats = json.decode(result[1].statistics)
                }
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            else
                statistics[playerId] = {
                    identifier = Player.PlayerData.citizenid,
                    stats = {}
                }
                if Config.StatisticsMenu['strenght'] then
                    statistics[playerId].stats['strenght'] = 0.0
                end
                if Config.StatisticsMenu['condition'] then
                    statistics[playerId].stats['condition'] = 0.0
                end
                if Config.StatisticsMenu['shooting'] then
                    statistics[playerId].stats['shooting'] = 0.0
                end
                if Config.StatisticsMenu['driving'] then
                    statistics[playerId].stats['driving'] = 0.0
                end
                TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
            end
        end)
        if Config.EnableMemberships then
            Citizen.Wait(2000)
            GetPlayerMemberships(Player.PlayerData.citizenid, function(callback)
                TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
            end)
        end
    end)

    AddEventHandler(Config.PlayerLogoutServer, function(playerId)
        OnPlayerLeft(playerId)
    end)
else
    Citizen.CreateThread(function()
        while true do
            print(('^8[WARNING] ^7- You missconfigure Config.Core: ^1"%s"^7, available: ^2"ESX"^7 / ^2"QB-Core"^7'):format(Config.Core))
            Citizen.Wait(7500)
        end
    end)
end

MySQL.ready(function()
    if Config.AutoExecuteQuery then
        if Config.Core == "ESX" then
            MySQL.Async.execute('ALTER TABLE users ADD COLUMN IF NOT EXISTS statistics LONGTEXT DEFAULT NULL')
        elseif Config.Core == "QB-Core" then
            MySQL.Async.execute('ALTER TABLE players ADD COLUMN IF NOT EXISTS statistics LONGTEXT DEFAULT NULL')
        end
        if Config.EnableMemberships then
            MySQL.Async.execute([[
                CREATE TABLE IF NOT EXISTS `gym_memberships` (
                    `owner` varchar(70) DEFAULT NULL,
                    `name` varchar(80) DEFAULT NULL,
                    `time` int(11) DEFAULT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
            ]])
        end
    end
end)

RegisterNetEvent('vms_gym:sv:restartPlayer', function()
    local playerId = source
    if Config.Core == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            MySQL.Async.fetchAll('SELECT statistics FROM users WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(result)
                if result and result[1] and result[1].statistics then
                    statistics[playerId] = {
                        identifier = xPlayer.identifier,
                        stats = json.decode(result[1].statistics)
                    }
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                else
                    statistics[playerId] = {
                        identifier = xPlayer.identifier,
                        stats = {}
                    }
                    if Config.StatisticsMenu['strenght'] then
                        statistics[playerId].stats['strenght'] = 0.0
                    end
                    if Config.StatisticsMenu['condition'] then
                        statistics[playerId].stats['condition'] = 0.0
                    end
                    if Config.StatisticsMenu['shooting'] then
                        statistics[playerId].stats['shooting'] = 0.0
                    end
                    if Config.StatisticsMenu['driving'] then
                        statistics[playerId].stats['driving'] = 0.0
                    end
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                end
            end)
            if Config.EnableMemberships then
                GetPlayerMemberships(xPlayer.identifier, function(callback)
                    TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
                end)
            end
        end
    elseif Config.Core == "QB-Core" then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            MySQL.Async.fetchAll('SELECT statistics FROM players WHERE citizenid = @citizenid', {
                ['@citizenid'] = Player.PlayerData.citizenid
            }, function(result)
                if result and result[1] and result[1].statistics then
                    statistics[playerId] = {
                        identifier = Player.PlayerData.citizenid,
                        stats = json.decode(result[1].statistics)
                    }
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                else
                    statistics[playerId] = {
                        identifier = Player.PlayerData.citizenid,
                        stats = {}
                    }
                    if Config.StatisticsMenu['strenght'] then
                        statistics[playerId].stats['strenght'] = 0.0
                    end
                    if Config.StatisticsMenu['condition'] then
                        statistics[playerId].stats['condition'] = 0.0
                    end
                    if Config.StatisticsMenu['shooting'] then
                        statistics[playerId].stats['shooting'] = 0.0
                    end
                    if Config.StatisticsMenu['driving'] then
                        statistics[playerId].stats['driving'] = 0.0
                    end
                    TriggerClientEvent('vms_gym:cl:updateStatistic', playerId, statistics[playerId].stats)
                end
            end)
            if Config.EnableMemberships then
                GetPlayerMemberships(Player.PlayerData.citizenid, function(callback)
                    TriggerClientEvent('vms_gym:cl:getMemberships', playerId, callback)
                end)
            end
        end
    end
end)

RegisterNetEvent('vms_gym:sv:getMemberships', function()
    if not Config.EnableMemberships then return end
    local src = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    local xPlayerIdentifier = Config.Core == "ESX" and xPlayer.identifier or Config.Core == "QB-Core" and xPlayer.PlayerData.citizenid
    if xPlayer and xPlayerIdentifier then
        GetPlayerMemberships(xPlayerIdentifier, function(playerMemberships)
            TriggerClientEvent('vms_gym:cl:getMemberships', src, playerMemberships)
        end)
    end
end)

RegisterNetEvent('vms_gym:sv:setTaken', function(gymId, pointId, boolean)
    TriggerClientEvent('vms_gym:cl:setTaken', -1, gymId, pointId, boolean)
end)

RegisterNetEvent('vms_gym:sv:sendRequestOfMembership', function(playerId, membershipName, days, price)
    if not Config.EnableMemberships then return end
    local src = source
    playerId, days, price = tonumber(playerId), tonumber(days), tonumber(price)
    if not playerId or not days or not price then return end
    local gym = IsValidMembershipOffer(membershipName, days, price)
    if not gym then return end
    local xSeller = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    local xTarget = Config.Core == "ESX" and ESX.GetPlayerFromId(playerId) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(playerId)
    if not xSeller or not xTarget then return end
    if gym.ownerJob and GetJobName(xSeller) ~= gym.ownerJob then return end
    pendingOffers[playerId] = {seller = src, name = membershipName, days = days, price = price, expires = os.time() + 120}
    TriggerClientEvent('vms_gym:cl:sendRequestOfMembership', playerId, src, membershipName, days, price)
end)

RegisterNetEvent('vms_gym:sv:acceptMembership', function(sellerId, membershipName, days, price)
    if not Config.EnableMemberships then return end
    local src = source
    days = tonumber(days)
    price = tonumber(price)
    sellerId = tonumber(sellerId)
    if not days or not price then return end
    local gym = IsValidMembershipOffer(membershipName, days, price)
    if not gym then return end

    -- Employee sale: the offer must really exist. Otherwise it is a direct (NPC) purchase.
    if sellerId then
        local offer = pendingOffers[src]
        if not offer or offer.seller ~= sellerId or offer.name ~= membershipName or offer.days ~= days or offer.price ~= price or offer.expires < os.time() then
            return
        end
        pendingOffers[src] = nil
    elseif gym.ownerJob and not gym.membershipPed then
        return -- job-run gyms only sell through their employees (unless they have a membershipPed)
    end

    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    local xSeller = sellerId and (Config.Core == "ESX" and ESX.GetPlayerFromId(sellerId) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(sellerId)) or nil
    if not xPlayer then return end

    local title = Config.Translate[Config.Language]['notify.title.gym']
    if GetTotalMoney(xPlayer) < price then
        TriggerClientEvent('vms_gym:notification', src, title, Config.Translate[Config.Language]['no_money_for_membership'], 4000, "fa-solid fa-dumbbell", 'error')
        if sellerId then
            TriggerClientEvent('vms_gym:notification', sellerId, title, Config.Translate[Config.Language]['customer_did_not_buy'], 4000, "fa-solid fa-dumbbell", 'error')
        end
        return
    end

    local identifier = Config.Core == "ESX" and xPlayer.identifier or xPlayer.PlayerData.citizenid
    RemoveMoneySmart(xPlayer, price)
    GrantMembership(identifier, membershipName, days, function(done)
        if not done then return end
        GetPlayerMemberships(identifier, function(playerMemberships)
            TriggerClientEvent('vms_gym:cl:getMemberships', src, playerMemberships)
        end)
        TriggerClientEvent('vms_gym:notification', src, title, Config.Translate[Config.Language]['bought_membership'], 4000, "fa-solid fa-dumbbell", 'success')
        DistributeMembershipMoney(price, gym, xSeller)
        if sellerId then
            TriggerClientEvent('vms_gym:notification', sellerId, title, Config.Translate[Config.Language]['selled_membership'], 4000, "fa-solid fa-dumbbell", 'success')
        end
    end)
end)

-- "Check my membership" option on the NPC.
RegisterNetEvent('vms_gym:sv:checkMembership', function(membershipName)
    local src = source
    local xPlayer = Config.Core == "ESX" and ESX.GetPlayerFromId(src) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayer(src)
    if not xPlayer or type(membershipName) ~= 'string' then return end
    local identifier = Config.Core == "ESX" and xPlayer.identifier or xPlayer.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT time FROM gym_memberships WHERE owner = @owner AND name = @name', {
        ['@owner'] = identifier, ['@name'] = membershipName
    }, function(rows)
        local left = rows and rows[1] and ((tonumber(rows[1].time) or 0) - os.time()) or 0
        local title = Config.Translate[Config.Language]['notify.title.gym']
        if left > 0 then
            local d = math.floor(left / 86400)
            local h = math.floor((left % 86400) / 3600)
            TriggerClientEvent('vms_gym:notification', src, title, Config.Translate[Config.Language]['membership_status']:format(d, h), 5000, "fa-solid fa-dumbbell", 'info')
        else
            TriggerClientEvent('vms_gym:notification', src, title, Config.Translate[Config.Language]['membership_status_none'], 4000, "fa-solid fa-dumbbell", 'error')
        end
    end)
end)

RegisterNetEvent('vms_gym:sv:rejectMembership', function(sellerId)
    local src = source
    sellerId = tonumber(sellerId)
    local offer = pendingOffers[src]
    if not sellerId or not offer or offer.seller ~= sellerId then return end
    pendingOffers[src] = nil
    TriggerClientEvent('vms_gym:notification', sellerId, Config.Translate[Config.Language]['notify.title.gym'], Config.Translate[Config.Language]['customer_did_not_buy'], 4000, "fa-solid fa-dumbbell", 'error')
end)

local validStats = {strenght = true, condition = true, shooting = true, driving = true}

RegisterNetEvent('vms_gym:sv:addValue', function(name, value)
    local src = source
    value = tonumber(value)
    if not statistics[src] or not validStats[name] or not value or value <= 0 or value > 1.0 then return end
    if statistics[src].stats then
        if not statistics[src].stats[name] then
            statistics[src].stats[name] = 0.0
        end
        if Config.SendNotificationWhenSkillIncrase and statistics[src].stats[name] < 100.0 then
            TriggerClientEvent('vms_gym:notification', src, 
                Config.Translate[Config.Language]['notify.title.'..name], 
                Config.Translate[Config.Language]['incrase_'..name]:format(value..'%'), 
                3000, 
                name == "strenght" and "fa-solid fa-dumbbell" or name == "condition" and "fa-solid fa-lungs" or name == "shooting" and "fa-solid fa-gun" or name == "driving" and "fa-solid fa-car", 
                'info'
            )
        end
        statistics[src].stats[name] = statistics[src].stats[name] + value
        if statistics[src].stats[name] > 100.0 then
            statistics[src].stats[name] = 100.0
        end
        TriggerClientEvent('vms_gym:cl:updateStatistic', src, statistics[src].stats)
    end
end)

RegisterNetEvent('vms_gym:sv:removeValue', function(name, value)
    local src = source
    value = tonumber(value)
    if not statistics[src] or not validStats[name] or not value or value <= 0 or value > 5.0 then return end
    if statistics[src].stats then
        if not statistics[src].stats[name] then
            statistics[src].stats[name] = 0.0
        end
        if Config.SendNotificationWhenSkillDecrease and statistics[src].stats[name] > 0.0 then
            TriggerClientEvent('vms_gym:notification', src, 
                Config.Translate[Config.Language]['notify.title.'..name], 
                Config.Translate[Config.Language]['decrease_'..name]:format(value..'%'), 
                3000, 
                name == "strenght" and "fa-solid fa-dumbbell" or name == "condition" and "fa-solid fa-lungs" or name == "shooting" and "fa-solid fa-gun" or name == "driving" and "fa-solid fa-car", 
                'info'
            )
        end
        statistics[src].stats[name] = statistics[src].stats[name] - value
        if statistics[src].stats[name] < 0.0 then
            statistics[src].stats[name] = 0.0
        end
        TriggerClientEvent('vms_gym:cl:updateStatistic', src, statistics[src].stats)
    end
end)

savePlayerStatistics = function(playerId)
    if statistics[playerId] then
        if Config.Core == "ESX" then
            MySQL.Async.execute('UPDATE users SET statistics = @statistics WHERE identifier = @identifier', {
                ['@statistics'] = json.encode(statistics[playerId].stats),
                ['@identifier'] = statistics[playerId].identifier
            })
        elseif Config.Core == "QB-Core" then
            MySQL.Async.execute('UPDATE players SET statistics = @statistics WHERE citizenid = @citizenid', {
                ['@statistics'] = json.encode(statistics[playerId].stats),
                ['@citizenid'] = statistics[playerId].identifier
            })
        end
    end
end

function StartSave()
    CreateThread(function()
        while true do
            Wait(Config.SavingTimeout)
            local players = {}
            if Config.Core == "ESX" then
                if ESX.GetExtendedPlayers then
                    for _, xPlayer in ipairs(ESX.GetExtendedPlayers()) do
                        players[#players + 1] = xPlayer.source
                    end
                else
                    players = ESX.GetPlayers() -- this server's core returns a list of player ids
                end
            elseif Config.Core == "QB-Core" then
                players = QBCore.Functions.GetPlayers()
            end
            for i = 1, #players do
                savePlayerStatistics(players[i])
            end
        end
    end)
end

StartSave()

if Config.EnableMemberships then
    function CheckMemberships(d, h, m)
        MySQL.Async.fetchAll('SELECT time as timestamp, name, owner FROM gym_memberships', {}, function(result)
            local nowTime = os.time()
            for i=1, #result, 1 do
                local aboTime = result[i].timestamp
                if aboTime <= nowTime then
                    MySQL.Async.execute('DELETE FROM gym_memberships WHERE owner = @owner AND name = @name AND time = @time', {
                        ['@owner'] = result[i].owner,
                        ['@name'] = result[i].name,
                        ['@time'] = aboTime,
                    })
                    local player = Config.Core == "ESX" and ESX.GetPlayerFromIdentifier(result[i].owner) or Config.Core == "QB-Core" and QBCore.Functions.GetPlayerByCitizenId(result[i].owner)
                    local target = player and (Config.Core == "ESX" and player.source or player.PlayerData.source)
                    if target then
                        GetPlayerMemberships(result[i].owner, function(playerMemberships)
                            TriggerClientEvent('vms_gym:cl:getMemberships', target, playerMemberships)
                        end)
                    end
                end
            end
        end)
    end
    

    -- The 'cron' resource isn't installed on this server, so expire
    -- memberships with our own timer instead of TriggerEvent('cron:runAt').
    CreateThread(function()
        Wait(30 * 1000)
        while true do
            CheckMemberships()
            Wait(10 * 60 * 1000)
        end
    end)
end
