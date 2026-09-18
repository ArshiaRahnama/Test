ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastAlarmTime  = {}
local washingPlayers = {} -- [source] = { locIndex = n, startTime = os.time() }

-- Pays the leftover cut into the society accounts of whichever configured
-- gov jobs currently have "wash money" enabled from their esx_society boss
-- menu (jobs.washmoney = 'true'). Jobs sharing an account (e.g. police/
-- sheriff/mt -> society_law) are paid once, split across unique accounts.
-- If no eligible job has the toggle on, the cut simply isn't paid to anyone.
local function depositGovernmentCut(amount)
    if amount <= 0 then return end

    local jobNames = ConfigWashMoney.GovernmentJobs
    if not jobNames or #jobNames == 0 then return end

    local placeholders = {}
    for i = 1, #jobNames do placeholders[i] = '?' end

    MySQL.Async.fetchAll('SELECT name, washmoney FROM jobs WHERE name IN (' .. table.concat(placeholders, ', ') .. ')', jobNames, function(rows)
        if not rows then return end

        local enabledJobs = {}
        for _, row in ipairs(rows) do
            if row.washmoney == 'true' then
                enabledJobs[#enabledJobs + 1] = row.name
            end
        end

        if #enabledJobs == 0 then return end -- nobody opted in: cut goes uncollected

        local accounts    = {}
        local accountList = {}

        for _, jobName in ipairs(enabledJobs) do
            TriggerEvent('esx_society:getSociety', jobName, function(society)
                if society and not accounts[society.account] then
                    accounts[society.account] = true
                    accountList[#accountList + 1] = society.account
                end
            end)
        end

        if #accountList == 0 then return end

        local share = math.floor(amount / #accountList)
        if share <= 0 then return end

        for _, accountName in ipairs(accountList) do
            TriggerEvent('esx_addonaccount:getSharedAccount', accountName, function(account)
                account.addMoney(share)
            end)
        end
    end)
end

local function isJobBlacklisted(jobName)
    return ConfigWashMoney.BlackListedJobs[jobName] == true
end

local function countOnDutyCops()
    local cops = 0
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and (xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff') then
            cops = cops + 1
        end
    end

    return cops
end

local function alertPolice(loc)
    local now = os.time()

    if lastAlarmTime[loc.Name] and (now - lastAlarmTime[loc.Name]) < ConfigWashMoney.AlarmCooldown then
        return
    end
    lastAlarmTime[loc.Name] = now

    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer then
            local job = xPlayer.job.name
            if job == 'police' or job == 'sheriff' or job == 'fbi' or job == 'cia' then
                TriggerClientEvent('unique_washmoney:setBlip', xPlayers[i], loc.Pos)
                TriggerClientEvent('esx:showNotification', xPlayers[i], ("Alarm Pool Shoyi %s Be Seda Dar Omad !"):format(loc.Name))
            end
        end
    end
end

RegisterServerEvent('unique_washmoney:startProcess')
AddEventHandler('unique_washmoney:startProcess', function(locIndex)
    local source = source
    local loc = ConfigWashMoney.Locations[locIndex]

    if not loc then return end
    if washingPlayers[source] then return end -- already mid-process, ignore duplicate/spammed requests

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if isJobBlacklisted(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', source, "Shoma Tavanayi Shostane Pool Ra Nadarid !", 'error')
        return
    end

    if GetPlayerRoutingBucket(source) ~= 0 then
        TriggerClientEvent('esx:showNotification', source, "Shoma Dar World Asli Nistid !", 'error')
        return
    end

    if countOnDutyCops() < ConfigWashMoney.PoliceNeededToWash then
        TriggerClientEvent('esx:showNotification', source, ("Tedad Police&Sheriff OnDuty Bayad Bishtar Az %d Nafar Bashad!"):format(ConfigWashMoney.PoliceNeededToWash))
        return
    end

    local blackMoneyItem  = xPlayer.getInventoryItem('blackmoney')
    local blackMoneyCount = blackMoneyItem and blackMoneyItem.count or 0

    if blackMoneyCount < loc.BlackMoney then
        TriggerClientEvent('esx:showNotification', source, "Shoma Be Andaze Niyaz Dirty Money Nadarid !", 'error')
        return
    end

    xPlayer.removeInventoryItem('blackmoney', loc.BlackMoney)

    washingPlayers[source] = {
        locIndex  = locIndex,
        startTime = os.time(),
    }

    TriggerClientEvent('unique_washmoney:beginProcess', source, loc.Name, ConfigWashMoney.ProcessDuration)
    alertPolice(loc)
end)

RegisterServerEvent('unique_washmoney:cancelProcess')
AddEventHandler('unique_washmoney:cancelProcess', function()
    local source = source
    local state = washingPlayers[source]
    if not state then return end

    washingPlayers[source] = nil

    local loc = ConfigWashMoney.Locations[state.locIndex]
    if loc then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addInventoryItem('blackmoney', loc.BlackMoney) -- refund since the wash never completed
        end
    end
end)

RegisterServerEvent('unique_washmoney:finishProcess')
AddEventHandler('unique_washmoney:finishProcess', function()
    local source = source
    local state = washingPlayers[source]
    if not state then return end -- no server-tracked process for this player: ignore

    washingPlayers[source] = nil

    local loc = ConfigWashMoney.Locations[state.locIndex]
    if not loc then return end

    -- sanity check against the server's own clock, not the client's report
    if (os.time() - state.startTime) < math.floor(ConfigWashMoney.ProcessDuration / 1000) - 2 then
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local percent = math.random(loc.PayoutPercent[1], loc.PayoutPercent[2])
    local payout  = math.floor(loc.BlackMoney * percent / 100)
    local govCut  = loc.BlackMoney - payout

    xPlayer.addMoney(payout)
    TriggerClientEvent('esx:showNotification', source, "Shoma Be Meghdar " .. payout .. " Shost o Sho Kardid !", 'success')

    depositGovernmentCut(govCut)
end)

AddEventHandler('playerDropped', function()
    washingPlayers[source] = nil
end)
