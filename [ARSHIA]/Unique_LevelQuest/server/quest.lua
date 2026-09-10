-- ================================================================= --
-- Quest system (was QuestSystem)
-- ================================================================= --
-- FIXES (historical):
--  1) GenerateQuests used to do `for i=1,6 do ... until not usedQuestIds[questid]`
--     with NO cap on retries. If a job's quest pool had fewer than 6
--     entries, every slot after the pool was exhausted retried
--     forever and hung that coroutine. Superseded below (see next
--     point) rather than just capped, since the whole pre-assignment
--     step this bug lived in no longer exists.
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
--
-- ACCEPT / CANCEL: quests used to be auto-assigned — GenerateQuests
-- picked Config.QuestsPerDay random ones from the pool at the start
-- of each day and that was the whole selection, no player input. Now
-- GenerateQuests just resets the day (empties the active list) and
-- the day's Config.QuestsPerDay offered quests are shown in the Quests
-- tab; the player accepts up to Config.MaxActiveQuests of them at once
-- (QuestSystem:AcceptQuest) and can cancel an unfinished one to free
-- that slot for a different quest (QuestSystem:CancelQuest). A quest
-- only tracks progress once accepted — the trigger handlers below
-- already only bump progress for ids present in playerquests, which
-- happens to be exactly "accepted" now, so no change was needed there.
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

-- Shared by AcceptQuest/CancelQuest: which pool (job-specific or
-- default) applies to a given saved quests row.
local function poolFor(playerquests)
    if playerquests["Job"] then
        return Config.JobQuests[playerquests["Job"]]
    end
    return Config.DefaultQuest
end

-- Is this quest id one of today's offered ones? (see "Offered" in
-- GenerateQuests above)
local function isOffered(playerquests, questId)
    local offered = playerquests["Offered"]
    if not offered then return false end
    local numId = tonumber(questId)
    for i = 1, #offered do
        if tonumber(offered[i]) == numId then return true end
    end
    return false
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
        else
            -- One-time backfill: a row saved before the "Offered" list
            -- existed (today's random 6, added instead of showing the
            -- whole pool) would otherwise show an empty Quests tab
            -- until tomorrow's natural reset. Same-day, so this only
            -- fills in Offered — it doesn't touch any already-accepted
            -- quest's progress.
            local ok, decoded = pcall(json.decode, result[1].quests)
            if ok and type(decoded) == 'table' and decoded["Offered"] == nil then
                GenerateQuests(xPlayer, xPlayer.identifier, decoded)
            end
        end
    end)
end)

function GenerateQuests(xPlayer, identifier, existingQuests)
    local job = nil
    for jobname, _ in pairs(Config.JobQuests) do
        if xPlayer.job.name == jobname or xPlayer.job.name == ('off' .. jobname) then
            job = jobname
            break
        end
    end

    local pool = job and Config.JobQuests[job] or Config.DefaultQuest
    -- existingQuests is only passed by the same-day "Offered" backfill
    -- above — reuse it (keeping any already-accepted progress) instead
    -- of wiping the day, like the normal new-day path below does.
    local quests = existingQuests or {}
    if job then quests["Job"] = job end
    -- No pre-picked active quests anymore — the full pool shows up in
    -- the Quests tab and the player accepts which ones they want (see
    -- QuestSystem:AcceptQuest below).

    -- "Offered" = today's random draw of Config.QuestsPerDay quest ids
    -- from the pool — shown in the Quests tab instead of the WHOLE
    -- pool (which for some jobs/the default pool can be dozens of
    -- entries, way more than fits nicely on one screen). Re-rolled
    -- once per day on the date-change check above. The player still
    -- accepts/cancels individually among just these, same as before.
    if pool and #pool > 0 then
        local offerCount = math.min(Config.QuestsPerDay or 6, #pool)
        local usedIndexes = {}
        local offered = {}
        for i = 1, offerCount do
            local idx, attempts = nil, 0
            repeat
                idx = math.random(1, #pool)
                attempts = attempts + 1
            until not usedIndexes[idx] or attempts > 50
            usedIndexes[idx] = true
            table.insert(offered, idx)
        end
        quests["Offered"] = offered
    end

    MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@quests']     = json.encode(quests)
    })
end

-- BUG FIX: the Quests tab only ever re-rolled Offered on first join or
-- a new calendar day, keyed by whatever job pool applied at THAT
-- moment (playerquests["Job"], read by poolFor() above). Changing jobs
-- mid-day (e.g. nojob -> a Config.JobQuests job like cid, or one job
-- to another) never re-ran GenerateQuests, so the tab kept showing
-- the OLD job's (or the default drug/mining pool's) offered quests
-- for the rest of the day, completely unrelated to the job actually
-- being worked. essentialmode's xPlayer.setJob fires this with the
-- real player source passed explicitly (self.source, not the ambient
-- global) — see player.lua — so it's safe to read directly here.
AddEventHandler('esx:setJob', function(playerSource, job)
    local xPlayer = ESX.GetPlayerFromId(playerSource)
    if not xPlayer or not job then return end

    local newJobKey = nil
    for jobname in pairs(Config.JobQuests) do
        if job.name == jobname or job.name == ('off' .. jobname) then
            newJobKey = jobname
            break
        end
    end

    MySQL.Async.fetchAll('SELECT quests FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result[1] then return end
        local ok, decoded = pcall(json.decode, result[1].quests)
        if not ok or type(decoded) ~= 'table' then return end

        -- decoded["Job"] is nil when the default (non-job) pool applied.
        if decoded["Job"] == newJobKey then return end -- same pool already, nothing to do

        -- Pool actually changed -- re-roll today's Offered quests for
        -- the new one. Same reset GenerateQuests already does for a
        -- new day; there's no sensible way to keep progress toward a
        -- pool the player can no longer act in after switching jobs.
        GenerateQuests(xPlayer, xPlayer.identifier)
        TriggerClientEvent('QuestSystem:RefreshQuests', playerSource)
    end)
end)

RegisterServerEvent("QuestSystem:AcceptQuest")
AddEventHandler("QuestSystem:AcceptQuest", function(questId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    questId = tostring(tonumber(questId)) -- normalize; also rejects non-numeric junk
    if questId == "nil" then return end

    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result[1] then return end
        local playerquests = json.decode(result[1].quests)
        local pool = poolFor(playerquests)
        local questDef = pool and pool[tonumber(questId)]
        if not questDef then return end -- id doesn't exist in this player's current pool
        if not isOffered(playerquests, questId) then return end -- not one of today's 6 offered quests

        if playerquests[questId] ~= nil then return end -- already accepted (active or done)

        -- Cap: only quests still IN PROGRESS count against the daily
        -- slot limit, so finishing one frees a slot for another right
        -- away instead of waiting for the next day.
        local activeCount = 0
        for k, v in pairs(playerquests) do
            if k ~= "Job" and k ~= "Offered" then
                local kDef = pool[tonumber(k)]
                local req = kDef and kDef.requiredTrigger or 1
                if (tonumber(v) or 0) < req then
                    activeCount = activeCount + 1
                end
            end
        end
        if activeCount >= (Config.MaxActiveQuests or 1) then
            TriggerClientEvent('esx:showNotification', _source, "Quest slots full", "error", "Finish or cancel your current quest first.")
            return
        end

        playerquests[questId] = 0
        MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@quests']     = json.encode(playerquests)
        })
        TriggerClientEvent('QuestSystem:RefreshQuests', _source)
    end)
end)

RegisterServerEvent("QuestSystem:CancelQuest")
AddEventHandler("QuestSystem:CancelQuest", function(questId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    questId = tostring(tonumber(questId))
    if questId == "nil" then return end

    MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if not result[1] then return end
        local playerquests = json.decode(result[1].quests)
        if playerquests[questId] == nil then return end -- wasn't accepted, nothing to cancel

        -- Can't cancel a finished quest — no reason to, and it'd let
        -- someone quietly wipe a completed quest instead of it just
        -- sitting there marked done.
        local pool = poolFor(playerquests)
        local questDef = pool and pool[tonumber(questId)]
        local req = questDef and questDef.requiredTrigger or 1
        if (tonumber(playerquests[questId]) or 0) >= req then return end

        playerquests[questId] = nil
        MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
            ['@quests']     = json.encode(playerquests)
        })
        TriggerClientEvent('QuestSystem:RefreshQuests', _source)
    end)
end)

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
        -- explicitSource: most bridges TriggerEvent() this trigger from
        -- within a real network-dispatched chain, where the ambient
        -- global `source` is already correct on its own (kept as the
        -- fallback below for those, and for direct TriggerServerEvent
        -- calls from the client, like the Onduty/acceptreq triggers).
        -- But a trigger that ultimately traces back to a RegisterCommand
        -- (e.g. Weazel's /cam -> quest-weazel:broadcast) has NO reliable
        -- global `source` at all -- same bug class as the Unique_Punishment
        -- /cs command fix -- so those bridges pass the real source
        -- explicitly instead, and it's preferred here when present.
        AddEventHandler(quest.trigger, function(explicitSource)
            local _source = explicitSource or source
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
