-- ================================================================= --
-- Activity skills (sun-style): progress per action, "finished" at 100%,
-- finished skill => shorter work timers. Progress is cached in memory and
-- written behind (every 30s, on leave, on resource stop) so a busy job tick
-- never costs a DB write.
-- Exports:
--   AddSkillProgress(source, skill, action)      -> true if accepted
--   IsSkillFinished(source, skill)               -> bool
--   GetSkillTimeFor(source, job, baseMs)         -> baseMs, or reduced when that job's skill is finished
-- ================================================================= --

local Cache, Dirty, Loading, IdentOf = {}, {}, {}, {} -- Cache[identifier] = { [skill] = {percent, finished} }

local jobToSkill = {}
for key, def in pairs(Config.Skills) do if def.job then jobToSkill[def.job] = key end end

local function load(identifier, cb)
    if Cache[identifier] then return cb(Cache[identifier]) end
    if Loading[identifier] then table.insert(Loading[identifier], cb) return end
    Loading[identifier] = { cb }
    MySQL.Async.fetchAll('SELECT skill, percent, finished FROM player_skills WHERE identifier = @i', { ['@i'] = identifier }, function(rows)
        local t = {}
        for _, r in ipairs(rows or {}) do
            t[r.skill] = { percent = tonumber(r.percent) or 0, finished = (tonumber(r.finished) or 0) == 1 }
        end
        Cache[identifier] = t
        local waiting = Loading[identifier]; Loading[identifier] = nil
        for _, f in ipairs(waiting or {}) do f(t) end
    end)
end

local function flush(identifier)
    local t, dirty = Cache[identifier], Dirty[identifier]
    if not t or not dirty then return end
    Dirty[identifier] = nil
    for skill in pairs(dirty) do
        local e = t[skill]
        if e then
            MySQL.Async.execute([[INSERT INTO player_skills (identifier, skill, percent, finished) VALUES (@i, @s, @p, @f)
                ON DUPLICATE KEY UPDATE percent = @p, finished = @f]],
                { ['@i'] = identifier, ['@s'] = skill, ['@p'] = e.percent, ['@f'] = e.finished and 1 or 0 })
        end
    end
end

CreateThread(function()
    while true do
        Wait(30000)
        for identifier in pairs(Dirty) do flush(identifier) end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local id = IdentOf[src]
    IdentOf[src] = nil
    if id then flush(id); Cache[id] = nil end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for identifier in pairs(Dirty) do flush(identifier) end
end)

local function identOf(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    IdentOf[src] = xPlayer.identifier
    return xPlayer.identifier, xPlayer
end

function AddSkillProgress(src, skill, action)
    src = tonumber(src)
    local def = Config.Skills[skill]
    local inc = def and def.addType and def.addType[action]
    if not src or not inc then return false end
    local identifier, xPlayer = identOf(src)
    if not identifier then return false end

    load(identifier, function(t)
        local e = t[skill]
        if not e then e = { percent = 0, finished = false }; t[skill] = e end
        if e.finished then return end

        e.percent = math.min(100, e.percent + inc)
        Dirty[identifier] = Dirty[identifier] or {}
        Dirty[identifier][skill] = true

        local justFinished = e.percent >= 100
        if justFinished then
            e.finished = true
            if Config.SkillFinishCoin and Config.SkillFinishCoin > 0 then GrantCoin(src, Config.SkillFinishCoin) end
            TriggerClientEvent('hud:achievementToast', src, def.label .. ' Skill — 100%', ('+%s Coin • faster work'):format(Config.SkillFinishCoin or 0))
            TriggerEvent('Unique_LevelQuest:skillFinished', src, skill)
            flush(identifier)
        end
        TriggerClientEvent('Unique_LevelQuest:skillUp', src, skill, def.label, e.percent, e.finished)
    end)
    return true
end
exports('AddSkillProgress', AddSkillProgress)

exports('IsSkillFinished', function(src, skill)
    local id = IdentOf[tonumber(src)] or identOf(tonumber(src))
    local t = id and Cache[id]
    return t and t[skill] and t[skill].finished or false
end)

exports('GetSkillTimeFor', function(src, job, baseMs)
    local skill = jobToSkill[job]
    local id = skill and (IdentOf[tonumber(src)] or identOf(tonumber(src)))
    local t = id and Cache[id]
    if t and t[skill] and t[skill].finished then
        return math.floor(baseMs * (Config.SkillFinishedTimeFactor or 1.0))
    end
    return baseMs
end)

-- The triggers are server-side events fired by esx_jobs/our bridges inside the
-- player's own call chain, so the ambient `source` is theirs (same assumption
-- server/bridges.lua already relies on). They are NOT registered as net events.
for trigger, map in pairs(Config.SkillTriggers) do
    AddEventHandler(trigger, function(explicitSource)
        local src = explicitSource or source
        if src then AddSkillProgress(src, map[1], map[2]) end
    end)
end

-- warm the cache on join so GetSkillTimeFor is synchronous-safe
AddEventHandler('esx:playerLoaded', function(src)
    local id = identOf(src)
    if id then load(id, function() end) end
end)

function GetActivitySkillList(src, cb)
    local id = identOf(src)
    if not id then return cb({}) end
    load(id, function(t)
        local out = {}
        for key, def in pairs(Config.Skills) do
            local e = t[key]
            out[#out + 1] = { key = key, label = def.label, job = def.job, percent = e and e.percent or 0, finished = e and e.finished or false }
        end
        table.sort(out, function(a, b) if a.percent ~= b.percent then return a.percent > b.percent end return a.label < b.label end)
        cb(out)
    end)
end

ESX.RegisterServerCallback('HUD_Menu:GetActivitySkills', function(source, cb)
    GetActivitySkillList(source, cb)
end)
