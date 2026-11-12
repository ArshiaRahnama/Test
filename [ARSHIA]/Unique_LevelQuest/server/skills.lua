-- ================================================================= --
-- Activity skills (Unique-style): progress per action, "finished" at 100%,
-- finished skill => shorter work timers. Progress is cached in memory and
-- written behind (every 30s, on leave, on resource stop) so a busy job tick
-- never costs a DB write.
-- Exports:
--   AddSkillProgress(source, skill, action)      -> true if accepted
--   IsSkillFinished(source, skill)               -> bool
-- ================================================================= --

local Cache, Dirty, Loading, IdentOf = {}, {}, {}, {} -- Cache[identifier] = { [skill] = {percent, finished} }

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
            TriggerClientEvent('hud:achievementToast', src, def.label .. (def.weapon and ' mastered' or ' Skill — 100%'),
                (def.weapon and '+%s Coin • weapon mastered' or '+%s Coin • faster work'):format(Config.SkillFinishCoin or 0))
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

-- The triggers are server-side events fired by esx_jobs/our bridges inside the
-- player's own call chain, so the ambient `source` is theirs (same assumption
-- server/bridges.lua already relies on). They are NOT registered as net events.
for trigger, map in pairs(Config.SkillTriggers) do
    AddEventHandler(trigger, function(explicitSource)
        local src = explicitSource or source
        if src then AddSkillProgress(src, map[1], map[2]) end
    end)
end

-- warm the cache on join
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
            local item = { key = key, label = def.label, job = def.job, weapon = def.weapon or false, percent = e and e.percent or 0, finished = e and e.finished or false }
            if def.weapon then
                item.weaponName = def.weaponName
                item.mk2 = def.weaponName:find('_MK2$') ~= nil
                if GetWeaponSkinTint then item.skin = GetWeaponSkinTint(id, def.weaponName, item.finished) end
            end
            out[#out + 1] = item
        end
        table.sort(out, function(a, b) if a.percent ~= b.percent then return a.percent > b.percent end return a.label < b.label end)
        cb(out)
    end)
end

ESX.RegisterServerCallback('HUD_Menu:GetActivitySkills', function(source, cb)
    GetActivitySkillList(source, cb)
end)


-- ================= weapon skills: kills =================
-- esx:onPlayerDeath is fired by the VICTIM's client (essentialmode death.lua) with
-- killerServerId + deathCause (weapon hash). It's client-reported, so everything is
-- re-checked here before any credit is given.
local function normHash(h)
    h = tonumber(h)
    if not h then return nil end
    h = math.tointeger(math.floor(h))
    return h and (h & 0xFFFFFFFF) or nil
end

local weaponByHash = {}
for key, def in pairs(Config.Skills) do
    if def.weapon and def.weaponName then
        weaponByHash[normHash(GetHashKey(def.weaponName))] = key
    end
end

local pairAt = {} -- "killer:victim" -> os.time()

AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    if type(data) ~= 'table' or data.killedByPlayer ~= true then return end
    local killer = tonumber(data.killerServerId)
    if not killer or not victim or killer == victim then return end

    local skill = weaponByHash[normHash(data.deathCause) or 0]
    if not skill then return end

    local xK, xV = ESX.GetPlayerFromId(killer), ESX.GetPlayerFromId(victim)
    if not xK or not xV or xK.identifier == xV.identifier then return end

    local key = xK.identifier .. ':' .. xV.identifier
    local now = os.time()
    if pairAt[key] and now - pairAt[key] < (Config.WeaponSkillPairCooldown or 600) then return end

    -- the victim's own client says "I died": confirm on the server a moment later
    -- (OneSync only; without it GetPlayerPed is 0 and only the pair cooldown protects us)
    SetTimeout(1000, function()
        local ped = GetPlayerPed(victim)
        if ped and ped ~= 0 and GetEntityHealth(ped) > 0 then return end
        if pairAt[key] and os.time() - pairAt[key] < (Config.WeaponSkillPairCooldown or 600) then return end
        pairAt[key] = os.time()
        AddSkillProgress(killer, skill, 'kill')
    end)
end)

CreateThread(function() -- keep the pair table from growing forever
    while true do
        Wait(600000)
        local now, ttl = os.time(), (Config.WeaponSkillPairCooldown or 600)
        for k, t in pairs(pairAt) do if now - t >= ttl then pairAt[k] = nil end end
    end
end)

exports('IsWeaponSkillFinished', function(src, weaponName)
    local key = tostring(weaponName):gsub('^WEAPON_', ''):lower() .. '_skill'
    local id = IdentOf[tonumber(src)] or identOf(tonumber(src))
    local t = id and Cache[id]
    return t and t[key] and t[key].finished or false
end)


-- Unique's weapon factory rule: you may craft a weapon when you mastered ITS skill.
-- Weapons that have no skill at all (melee, anything not in Config.WeaponSkillList)
-- are never blocked, so a gate can't lock a recipe nobody can ever earn.
exports('HasWeaponAccess', function(src, weaponName)
    local key = tostring(weaponName):gsub('^WEAPON_', ''):lower() .. '_skill'
    local def = Config.Skills[key]
    if not def or not def.weapon then return true end
    local id = IdentOf[tonumber(src)] or identOf(tonumber(src))
    local t = id and Cache[id]
    if id and not t then load(id, function() end) end -- not loaded yet: start loading, answer "no" this once
    return (t and t[key] and t[key].finished) or false
end)

-- after a resource restart nobody's skills are cached: warm everyone who is online
CreateThread(function()
    Wait(3000)
    for _, p in ipairs(GetPlayers()) do
        local id = identOf(tonumber(p))
        if id then load(id, function() end) end
    end
end)
