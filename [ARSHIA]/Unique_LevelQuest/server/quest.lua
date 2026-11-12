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

math.randomseed(os.time()) -- server Lua is NOT seeded by default: every restart replayed the same "random" daily offers

local TRIGGER_COOLDOWN = 2 -- seconds; flood guard for server-fired (TriggerEvent) triggers
local lastTriggerAt = {} -- [source..":"..trigger] = os.time()

-- Only these triggers are ever fired by a CLIENT (TriggerServerEvent):
--   *:onduty / quest-cafe-onduty:<job>  -> client/bridges.lua (paycheck tick, ~15 min)
--   *:acceptreq                         -> client/bridges.lua (responder accepted a request)
--   quest-cafe:bill                     -> uniquecafejobs/client/functions.lua
-- Everything else is fired server-side by esx_jobs / esx_drugs / uniquecafejobs /
-- our own bridges and must NOT be reachable from the network at all - it used to be
-- RegisterServerEvent for every single trigger, so any client could just loop
-- TriggerServerEvent('quest-police:cuff') every 2s and finish the day's quests.
-- Returns the minimum seconds between two accepted calls, or nil when the trigger
-- must stay server-only.
local function networkCooldown(trigger)
    if trigger:find(':onduty$') or trigger:find('^quest%-cafe%-onduty:') then
        return 14 * 60 -- paycheck interval is 15 min; same slack skill-track:tick uses
    elseif trigger:find(':acceptreq$') then
        return 20
    elseif trigger == 'quest-cafe:bill' then
        return 15
    end
    return nil
end

local function onCooldown(source, trigger, seconds)
    local key = source .. ":" .. trigger
    local now = os.time()
    if lastTriggerAt[key] and (now - lastTriggerAt[key]) < (seconds or TRIGGER_COOLDOWN) then
        return true
    end
    lastTriggerAt[key] = now
    return false
end

-- Every handler below does read-modify-write on the player's single `quest` row.
-- Two events landing in the same tick (e.g. Onduty + Onduty Veteran share one
-- trigger, or a trigger firing while the player presses Accept) both read the same
-- old JSON and the second write wiped the first one's progress. withRow() queues
-- work per identifier so they run strictly one after another.
--   fn(row, done)   row = the DB row or nil
--   done(newJson, afterFn)   newJson == nil -> nothing to save; afterFn runs after the write
local rowQueue = {}
local function withRow(identifier, fn)
    if rowQueue[identifier] then
        table.insert(rowQueue[identifier], fn)
        return
    end
    rowQueue[identifier] = {}

    local function run(f)
        MySQL.Async.fetchAll('SELECT * FROM quest WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            local finished = false
            local function next_()
                if finished then return end
                finished = true
                local nextFn = rowQueue[identifier] and table.remove(rowQueue[identifier], 1)
                if nextFn then run(nextFn) else rowQueue[identifier] = nil end
            end
            local ok, err = pcall(f, result and result[1], function(newJson, afterFn)
                if newJson then
                    MySQL.Async.execute('UPDATE quest SET quests = @quests WHERE identifier = @identifier', {
                        ['@identifier'] = identifier,
                        ['@quests']     = newJson,
                    }, function()
                        if afterFn then afterFn() end
                        next_()
                    end)
                else
                    if afterFn then afterFn() end
                    next_()
                end
            end)
            if not ok then
                print(('[Unique_LevelQuest] quest row handler error: %s'):format(tostring(err)))
                next_()
            end
        end)
    end
    run(fn)
end

local function grantQuestReward(xPlayer, quest)
    local xp   = quest.XP or 0
    local coin = quest.coin or 0

    TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest Completed !", "success", quest.name)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "You Got " .. xp .. " XP And " .. coin .. " Coins", "success", "Quest Rewards")
    TriggerClientEvent('hud:achievementToast', xPlayer.source, quest.name, ("+%s XP  •  +%s Coin"):format(xp, coin))

    GrantXP(xPlayer.source, xp, nil)

    if coin > 0 then
        local ok = GrantCoin(xPlayer.source, coin)
        if ok == false then
            print(('[Unique_LevelQuest] GrantCoin refused reward for %s (%s coin)'):format(xPlayer.identifier, tostring(coin)))
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

    withRow(xPlayer.identifier, function(row, done)
        if not row then return done(nil) end
        local ok, playerquests = pcall(json.decode, row.quests)
        if not ok or type(playerquests) ~= 'table' then return done(nil) end

        local pool = poolFor(playerquests)
        local questDef = pool and pool[tonumber(questId)]
        if not questDef then return done(nil) end -- id doesn't exist in this player's current pool
        if not isOffered(playerquests, questId) then return done(nil) end -- not one of today's offered quests
        if playerquests[questId] ~= nil then return done(nil) end -- already accepted (active or done)

        -- Cap: only quests still IN PROGRESS count against the slot limit, so
        -- finishing one frees a slot for another right away.
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
            return done(nil, function() TriggerClientEvent('QuestSystem:RefreshQuests', _source) end)
        end

        playerquests[questId] = 0
        -- refresh only AFTER the write landed, so the client re-read never sees the old row
        done(json.encode(playerquests), function()
            TriggerClientEvent('QuestSystem:RefreshQuests', _source)
        end)
    end)
end)

RegisterServerEvent("QuestSystem:CancelQuest")
AddEventHandler("QuestSystem:CancelQuest", function(questId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end
    questId = tostring(tonumber(questId))
    if questId == "nil" then return end

    withRow(xPlayer.identifier, function(row, done)
        if not row then return done(nil) end
        local ok, playerquests = pcall(json.decode, row.quests)
        if not ok or type(playerquests) ~= 'table' then return done(nil) end
        if playerquests[questId] == nil then return done(nil) end -- wasn't accepted, nothing to cancel

        -- Can't cancel a finished quest - it'd let someone quietly wipe a
        -- completed quest instead of it just sitting there marked done.
        local pool = poolFor(playerquests)
        local questDef = pool and pool[tonumber(questId)]
        local req = questDef and questDef.requiredTrigger or 1
        if (tonumber(playerquests[questId]) or 0) >= req then return done(nil) end

        playerquests[questId] = nil
        done(json.encode(playerquests), function()
            TriggerClientEvent('QuestSystem:RefreshQuests', _source)
        end)
    end)
end)

-- ONE dispatcher per distinct trigger name. Before, every pool entry registered
-- its own handler for its trigger; several pools share a trigger (all 21 cafe/
-- holding jobs share quest-cafe:craft / :bill / :advertise ..., and the holding
-- jobs have "Onduty" + "Onduty Veteran" on the same trigger) and each handler
-- burned the per-trigger cooldown BEFORE checking the player's job - so the
-- first handler to run (whatever job it belonged to) set the cooldown and the
-- handler that actually matched the player was then rejected. Those quests could
-- only progress by luck of iteration order. Now: match the player's pool first,
-- apply the cooldown once, progress every matching entry in a single DB write.
local byTrigger = {} -- trigger -> { { job = <string|nil>, id = n, quest = q }, ... }
local function addEntry(job, id, quest)
    local list = byTrigger[quest.trigger]
    if not list then list = {}; byTrigger[quest.trigger] = list end
    list[#list + 1] = { job = job, id = id, quest = quest }
end
for id, quest in ipairs(Config.DefaultQuest) do addEntry(nil, id, quest) end
for job, quests in pairs(Config.JobQuests) do
    for id, quest in ipairs(quests) do addEntry(job, id, quest) end
end

for trigger, entries in pairs(byTrigger) do
    local netCooldown = networkCooldown(trigger)
    if netCooldown then RegisterServerEvent(trigger) end

    AddEventHandler(trigger, function(explicitSource)
        -- explicitSource is only trusted for server-only triggers (a bridge fired
        -- from a RegisterCommand has no reliable global `source`, see
        -- server/bridges.lua). For client-reachable ones it would let a cheater
        -- credit progress to somebody else, so the real `source` is always used.
        local _source = (not netCooldown and explicitSource) or source
        if not _source then return end

        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer or not xPlayer.job then return end
        local jobName = xPlayer.job.name

        local matched = {}
        for _, e in ipairs(entries) do
            if (e.job == nil and jobName == 'nojob') or (e.job ~= nil and e.job == jobName) then
                matched[#matched + 1] = e
            end
        end
        if #matched == 0 then return end

        if onCooldown(_source, trigger, netCooldown) then return end

        withRow(xPlayer.identifier, function(row, done)
            if not row then return done(nil) end
            local ok, playerquests = pcall(json.decode, row.quests)
            if not ok or type(playerquests) ~= 'table' then return done(nil) end

            local changed = false
            for _, e in ipairs(matched) do
                local idStr = tostring(e.id)
                local poolOk = (e.job == nil and playerquests["Job"] == nil) or (e.job ~= nil and playerquests["Job"] == e.job)
                local cur = tonumber(playerquests[idStr])
                if poolOk and cur and cur < e.quest.requiredTrigger then
                    cur = cur + 1
                    playerquests[idStr] = cur
                    changed = true
                    if cur == e.quest.requiredTrigger then
                        grantQuestReward(xPlayer, e.quest)
                    else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Quest : " .. cur .. "/" .. e.quest.requiredTrigger, "success", e.quest.name)
                    end
                end
            end

            if changed then done(json.encode(playerquests)) else done(nil) end
        end)
    end)
end

AddEventHandler('playerDropped', function()
    local _source = source
    for key in pairs(lastTriggerAt) do
        if key:sub(1, #tostring(_source) + 1) == (_source .. ":") then
            lastTriggerAt[key] = nil
        end
    end
end)
