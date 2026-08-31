-- ================================================================= --
-- Quest system (was QuestSystem)
-- ================================================================= --
-- FIXES:
--  1) GenerateQuests used to do `for i=1,6 do ... until not usedQuestIds[questid]`
--     with NO cap on retries. If a job's quest pool has fewer than 6
--     entries (several do, after trimming out unmapped quests — see
--     config.lua), every slot after the pool is exhausted retries
--     forever and hangs that coroutine. Now capped to pool size, with
--     a hard retry ceiling as a second safety net.
--  2) Every quest trigger was a raw RegisterServerEvent with no rate
--     limit, so a player could script-spam TriggerServerEvent(trigger)
--     to instantly farm a full day's worth of quest rewards without
--     doing anything. A short per-player-per-trigger cooldown is now
--     enforced.
--  3) Rewards used to go through 'XP_System:AddXP' (a network event,
--     see xp.lua) and a client round-trip to the now-removed insecure
--     'Coin-System:AddCoinCL'. Both are now granted directly, server
--     side: GrantXP() and GrantCoin() are plain Lua calls (xp.lua and
--     coin.lua, both in this same resource now).
-- ================================================================= --

local TRIGGER_COOLDOWN = 2 -- seconds; blocks raw event-spam farming
local lastTriggerAt = {} -- [source..":"..trigger] = os.time()

local function onCooldown(source, trigger)
    local key = source .. ":" .. trigger
    local now = os.time()
    if lastTriggerAt[key] and (now - lastTriggerAt[key]) < TRIGGER_COOLDOWN then
        return true
    end
    lastTriggerAt[key] = now
    return false
end

local function grantQuestReward(xPlayer, quest)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest Completed !", "success", quest.name)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "You Got " .. quest.XP .. " XP And " .. quest.coin .. " Coins", "success", "Quest Rewards")
    TriggerClientEvent('hud:achievementToast', xPlayer.source, quest.name, ("+%s XP  •  +%s Coin"):format(quest.XP, quest.coin))

    GrantXP(xPlayer.source, quest.XP, nil)

    if quest.coin and quest.coin > 0 then
        local ok = GrantCoin(xPlayer.source, quest.coin)
        if ok == false then
            print(('[Unique_LevelQuest] GrantCoin refused reward for %s (%s coin)'):format(xPlayer.identifier, tostring(quest.coin)))
        end
    end
end

RegisterServerEvent("QuestSystem:InitializePlayer")
AddEventHandler("QuestSystem:InitializePlayer", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result[1] then
            MySQL.Async.execute('INSERT INTO quest (identifier, date, quests) VALUES (@identifier, @date, @quests)', {
                ['@identifier'] = xPlayer.identifier,
                ['@date']       = os.date("%Y/%m/%d"),
                ['@quests']     = "{}"
            })
            GenerateQuests(xPlayer, xPlayer.identifier)
        elseif result[1].date ~= os.date("%Y/%m/%d") then
            MySQL.Async.execute('UPDATE quest SET quests = @quests, date = @date WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier,
                ['@date']       = os.date("%Y/%m/%d"),
                ['@quests']     = "{}"
            })
            GenerateQuests(xPlayer, xPlayer.identifier)
        end
    end)
end)

function GenerateQuests(xPlayer, identifier)
    local job = nil
    for jobname, _ in pairs(Config.JobQuests) do
        if xPlayer.job.name == jobname or xPlayer.job.name == ('off' .. jobname) then
            job = jobname
            break
        end
    end

    local pool = job and Config.JobQuests[job] or Config.DefaultQuest
    local quests = {}
    if job then quests["Job"] = job end

    if pool and #pool > 0 then
        local usedQuestIds = {}
        local questCount = math.min(Config.QuestsPerDay or 6, #pool)
        for i = 1, questCount do
            local questid, attempts = nil, 0
            repeat
                questid = math.random(1, #pool)
                attempts = attempts + 1
            until not usedQuestIds[questid] or attempts > 50
            usedQuestIds[questid] = true
            quests[tostring(questid)] = 0
        end
    end

    Citizen.Wait(100)
    MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@quests']     = json.encode(quests)
    })
end

for id, quest in ipairs(Config.DefaultQuest) do
    RegisterServerEvent(quest.trigger)
    AddEventHandler(quest.trigger, function()
        local _source = source
        if onCooldown(_source, quest.trigger) then return end

        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return end
        if xPlayer.job.name ~= 'nojob' then return end

        MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if not result[1] then return end
            local playerquests = json.decode(result[1].quests)
            if not playerquests[tostring(id)] then return end
            if playerquests[tostring(id)] >= quest.requiredTrigger then return end

            playerquests[tostring(id)] = playerquests[tostring(id)] + 1
            if playerquests[tostring(id)] == quest.requiredTrigger then
                grantQuestReward(xPlayer, quest)
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest : " .. playerquests[tostring(id)] .. "/" .. quest.requiredTrigger, "success", quest.name)
            end

            MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier,
                ['@quests']     = json.encode(playerquests)
            })
        end)
    end)
end

for job, quests in pairs(Config.JobQuests) do
    for id, quest in ipairs(quests) do
        RegisterServerEvent(quest.trigger)
        AddEventHandler(quest.trigger, function()
            local _source = source
            if onCooldown(_source, quest.trigger) then return end

            local xPlayer = ESX.GetPlayerFromId(_source)
            if not xPlayer then return end
            if xPlayer.job.name ~= job then return end

            MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            }, function(result)
                if not result[1] then return end
                local playerquests = json.decode(result[1].quests)
                if playerquests["Job"] ~= job then return end
                if not playerquests[tostring(id)] then return end
                if playerquests[tostring(id)] >= quest.requiredTrigger then return end

                playerquests[tostring(id)] = playerquests[tostring(id)] + 1
                if playerquests[tostring(id)] == quest.requiredTrigger then
                    grantQuestReward(xPlayer, quest)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest : " .. playerquests[tostring(id)] .. "/" .. quest.requiredTrigger, "success", quest.name)
                end

                MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@quests']     = json.encode(playerquests)
                })
            end)
        end)
    end
end

AddEventHandler('playerDropped', function()
    local _source = source
    for key in pairs(lastTriggerAt) do
        if key:sub(1, #tostring(_source) + 1) == (_source .. ":") then
            lastTriggerAt[key] = nil
        end
    end
end)
