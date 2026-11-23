-- ScriptPack / change world (server)
-- Exports: exports.ScriptPack:SetWorld(src, world, opts) / GetWorld(src) / CanEnter(src, world)
-- Worlds are routing buckets. World 0 is the real world. Every action is validated here;
-- clients can never set their own bucket.

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(200)
    end
end)

local worlds = {}   -- [id] = { id, label, gang_access, gangs = {}, players = {}, flags = {}, expire }
local inWorld = {}  -- [src] = { world, identifier, ret = {x, y, z, h} }
local ready = false

local FLAG_NAMES = { 'menu', 'vehicle', 'tp', 'revive', 'weapon', 'armor', 'peds', 'skins', 'extras', 'host' }
local webhook = GetConvar('unique_changeworld_webhook', '')

-- ---------------------------------------------------------------- helpers

local function getPlayer(src)
    if not ESX or not src then return nil end
    local ok, xp = pcall(ESX.GetPlayerFromId, src)
    if ok then return xp end
    return nil
end

local function isAdmin(src)
    local xp = getPlayer(src)
    return xp ~= nil and (tonumber(xp.permission_level) or 0) >= CWConfig.AdminPermission
end

local function isOwner(src, w)
    local xp = getPlayer(src)
    return xp ~= nil and w ~= nil and w.owner ~= nil and w.owner == xp.identifier
end

local function toWorldId(v)
    local n = tonumber(v)
    if not n then return nil end
    return math.tointeger(n)
end

local function decode(str, default)
    if type(str) ~= 'string' or str == '' then return default end
    local ok, value = pcall(json.decode, str)
    if ok and type(value) == 'table' then return value end
    return default
end

local function listHas(list, value)
    for i = 1, #list do
        if list[i] == value then return true end
    end
    return false
end

local function listRemove(list, value)
    for i = #list, 1, -1 do
        if list[i] == value then table.remove(list, i) end
    end
end

-- A created world (database) or a config-only world (CWConfig.StaticWorlds).
local function getWorld(id)
    local w = worlds[id]
    if w then return w end
    local st = CWConfig.StaticWorlds and CWConfig.StaticWorlds[id]
    if st then
        local access = st.access or {}
        local gangs = {}
        for _, g in ipairs(access.gangs or {}) do gangs[#gangs + 1] = tostring(g):lower() end
        return {
            id = id, label = st.label, gang_access = #gangs > 0, gangs = gangs,
            players = access.identifiers or {}, flags = st.flags or {}, expire = 0,
            spawn = st.spawn, skins = st.skins, entrance = st.entrance, static = true,
        }
    end
    return nil
end

local function isExpired(w)
    return w.expire ~= nil and w.expire > 0 and os.time() >= w.expire
end

local function effectiveFlags(w)
    local out = {}
    for _, name in ipairs(FLAG_NAMES) do
        local v = w and w.flags and w.flags[name]
        if v == nil then v = CWConfig.DefaultFlags[name] end
        out[name] = v and true or false
    end
    return out
end

local function clean(text)
    return (tostring(text or ''):gsub('[`@]', ''))
end

local function log(text)
    if webhook == '' then return end
    PerformHttpRequest(webhook, function() end, 'POST',
        json.encode({ username = 'ChangeWorld', content = '```' .. clean(text) .. '```' }),
        { ['Content-Type'] = 'application/json' })
end

local function playerLabel(src)
    return ('%s [%s]'):format(clean(GetPlayerName(src) or 'unknown'), tostring(src))
end

-- ---------------------------------------------------------------- database

local function saveWorld(w)
    MySQL.update(
        'UPDATE unique_worlds SET label = ?, gang_access = ?, gangs = ?, players = ?, flags = ?, expire = ?, spawn = ? WHERE id = ?',
        { w.label, w.gang_access and 1 or 0, json.encode(w.gangs), json.encode(w.players), json.encode(w.flags), w.expire,
          w.spawn and json.encode(w.spawn) or nil, w.id }
    )
end

local function loadWorlds()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `unique_worlds` (
          `id` int(11) NOT NULL,
          `label` varchar(64) DEFAULT NULL,
          `gang_access` tinyint(1) NOT NULL DEFAULT 0,
          `gangs` longtext NOT NULL,
          `players` longtext NOT NULL,
          `flags` longtext NOT NULL,
          `expire` bigint(20) NOT NULL DEFAULT 0,
          `spawn` longtext DEFAULT NULL,
          `owner` varchar(80) DEFAULT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Tables created by an earlier version do not have the spawn column yet.
    local col = MySQL.query.await("SHOW COLUMNS FROM `unique_worlds` LIKE 'spawn'")
    if not col or #col == 0 then
        MySQL.query.await('ALTER TABLE `unique_worlds` ADD COLUMN `spawn` longtext DEFAULT NULL')
    end

    local ownerCol = MySQL.query.await("SHOW COLUMNS FROM `unique_worlds` LIKE 'owner'")
    if not ownerCol or #ownerCol == 0 then
        MySQL.query.await('ALTER TABLE `unique_worlds` ADD COLUMN `owner` varchar(80) DEFAULT NULL')
    end

    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `unique_world_skins` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `world` int(11) NOT NULL,
          `name` varchar(64) NOT NULL,
          `skin` longtext NOT NULL,
          PRIMARY KEY (`id`),
          UNIQUE KEY `world_name` (`world`, `name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    local rows = MySQL.query.await('SELECT * FROM unique_worlds') or {}
    worlds = {}
    for _, r in ipairs(rows) do
        worlds[r.id] = {
            id = r.id,
            label = r.label,
            gang_access = (r.gang_access == 1 or r.gang_access == true),
            gangs = decode(r.gangs, {}),
            players = decode(r.players, {}),
            flags = decode(r.flags, {}),
            expire = tonumber(r.expire) or 0,
            spawn = decode(r.spawn, nil),
            owner = r.owner,
        }
    end
    ready = true
end

MySQL.ready(loadWorlds)

-- ---------------------------------------------------------------- access

local function canEnter(src, worldId)
    local w = getWorld(worldId)
    if not w then return false, 'not_found' end
    if isAdmin(src) then return true end
    if isExpired(w) then return false, 'expired' end

    local xp = getPlayer(src)
    if not xp then return false, 'no_player' end
    if w.owner and w.owner == xp.identifier then return true end
    if listHas(w.players, xp.identifier) then return true end
    if w.gang_access and type(xp.gang) == 'table' and xp.gang.name and listHas(w.gangs, xp.gang.name) then
        return true
    end
    return false, 'no_access'
end

-- ---------------------------------------------------------------- core

---Move a player to a world (0 = real world).
---opts.force  : allow world ids that were never created (admin tools / other scripts)
---opts.silent : no notification on the client when leaving
---opts.ret    : {x, y, z, h} return position to use instead of the position the player left from
---opts.by     : server id of the person who moved the player (only used for the log)
---@return boolean ok, string? reason
local function SetWorld(src, worldId, opts)
    opts = opts or {}
    src = tonumber(src)
    worldId = toWorldId(worldId)
    if not src or not worldId or not GetPlayerName(src) then return false, 'invalid' end
    if worldId < 0 or worldId > CWConfig.MaxWorldId then return false, 'range' end

    local current = GetPlayerRoutingBucket(src)
    if current == worldId then return false, 'same' end
    if worldId ~= 0 and not getWorld(worldId) and not opts.force then return false, 'not_found' end

    local ped = GetPlayerPed(src)
    local xp = getPlayer(src)

    if worldId ~= 0 then
        local rec = inWorld[src]
        if not rec then
            local ret = CWConfig.ReturnFallback
            if ped and ped ~= 0 then
                local c = GetEntityCoords(ped)
                ret = { x = c.x, y = c.y, z = c.z, h = GetEntityHeading(ped) }
            end
            rec = { identifier = xp and xp.identifier or nil, ret = opts.ret or ret }
            inWorld[src] = rec
        end
        rec.world = worldId
    end

    SetPlayerRoutingBucket(src, worldId)
    if ped and ped ~= 0 then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh and veh ~= 0 then SetEntityRoutingBucket(veh, worldId) end
    end
    if worldId ~= 0 then
        SetRoutingBucketPopulationEnabled(worldId, CWConfig.PopulationInWorlds and true or false)
    end

    Player(src).state:set('world', worldId, true)

    if worldId == 0 then
        local rec = inWorld[src]
        inWorld[src] = nil
        TriggerClientEvent('unique_cw:client:left', src, (rec and rec.ret) or CWConfig.ReturnFallback, opts.silent and true or false)
    else
        local w = getWorld(worldId)
        TriggerClientEvent('unique_cw:client:entered', src, worldId, effectiveFlags(w), w and w.spawn or nil, w and w.label or nil, w and w.expire or 0)
    end

    -- Keeps Unique_Hud (and anything else listening) in sync.
    TriggerClientEvent('esx:changeworld', src, worldId)
    TriggerEvent('unique_cw:worldChanged', src, worldId, current)

    local by = tonumber(opts.by)
    if by and by ~= src and GetPlayerName(by) then
        log(('%s: world %d -> %d (by %s)'):format(playerLabel(src), current, worldId, playerLabel(by)))
    else
        log(('%s: world %d -> %d'):format(playerLabel(src), current, worldId))
    end
    return true
end

local function GetWorld(src)
    src = tonumber(src)
    if not src or not GetPlayerName(src) then return nil end
    return GetPlayerRoutingBucket(src)
end

local function CanEnter(src, worldId)
    return canEnter(src, toWorldId(worldId))
end

exports('SetWorld', SetWorld)
exports('GetWorld', GetWorld)
exports('CanEnter', CanEnter)

AddEventHandler('playerDropped', function()
    local src = source
    local rec = inWorld[src]
    if not rec then return end
    inWorld[src] = nil

    -- essentialmode saves the live ped position on disconnect, which would be the event location.
    -- Write the real-world return position afterwards so the player never logs back in inside a world map.
    if rec.identifier and rec.ret then
        local payload = json.encode({
            x = tonumber(('%.2f'):format(rec.ret.x)),
            y = tonumber(('%.2f'):format(rec.ret.y)),
            z = tonumber(('%.2f'):format(rec.ret.z)),
            h = tonumber(('%.1f'):format(rec.ret.h or 0.0)),
        })
        SetTimeout(2500, function()
            MySQL.update('UPDATE users SET `position` = ? WHERE `identifier` = ?', { payload, rec.identifier })
        end)
    end
end)

-- ---------------------------------------------------------------- player callbacks

lib.callback.register('unique_cw:list', function(src)
    if not ready then return { admin = false, worlds = {} } end
    local admin = isAdmin(src)
    local out = {}
    local ids = {}
    for id in pairs(worlds) do ids[#ids + 1] = id end
    for id, st in pairs(CWConfig.StaticWorlds or {}) do
        if not worlds[id] and st.access then ids[#ids + 1] = id end   -- config worlds with an access list
    end
    table.sort(ids)

    for _, id in ipairs(ids) do
        local w = getWorld(id)
        local allowed = canEnter(src, id)
        local owner = isOwner(src, w)
        if admin or allowed or owner then
            local entry = {
                id = id,
                label = w.label,
                expire = w.expire,
                expired = isExpired(w),
                canEnter = allowed and true or false,
                owner = owner,
                static = w.static and true or nil,
            }
            if (admin or owner) and not w.static then
                entry.players = w.players
                entry.spawn = w.spawn
            end
            if admin then
                entry.gang_access = w.gang_access
                entry.gangs = w.gangs
                entry.flags = effectiveFlags(w)
            end
            out[#out + 1] = entry
        end
    end
    local cfg = CWConfig.Entrance
    local gate = nil
    if cfg and cfg.enabled then gate = cfg.nearGang and 'gang' or (cfg.place and 'place') or nil end
    return { admin = admin, worlds = out, current = GetPlayerRoutingBucket(src), gate = gate }
end)

-- ---------------------------------------------------------------- who may enter, and from where
-- (CWConfig.Entrance for every world, `entrance` of a config world on top). Admins are never stopped.

local function distanceTo(src, point)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    local c = GetEntityCoords(ped)
    local dx, dy, dz = c.x - point.x, c.y - point.y, c.z - point.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function gangOf(xp)
    local gang = xp and type(xp.gang) == 'table' and xp.gang.name
    if not gang or gang == '' or gang == 'nogang' then return nil end
    return tostring(gang):lower()
end

-- the boss point of the player's gang (gangs_data.boss = JSON { x, y, z })
local function gangBossPoint(xp)
    local gang = gangOf(xp)
    if not gang then return nil, 'no_gang' end
    local raw = MySQL.scalar.await('SELECT boss FROM gangs_data WHERE gang_name = ? LIMIT 1', { gang })
    local point = decode(raw, nil)
    if not point or not tonumber(point.x) or not tonumber(point.y) or not tonumber(point.z) then return nil, 'no_boss' end
    return { x = tonumber(point.x), y = tonumber(point.y), z = tonumber(point.z) }
end

local function hasEntries(list)
    return type(list) == 'table' and #list > 0
end

-- WHO: is this player on the list of people who may use the command?
local function listedForEntry(xp, allowed)
    if not (allowed and (hasEntries(allowed.identifiers) or hasEntries(allowed.gangs) or hasEntries(allowed.groups))) then
        return true   -- no list = everybody
    end
    if hasEntries(allowed.identifiers) and listHas(allowed.identifiers, xp.identifier) then return true end
    if hasEntries(allowed.gangs) then
        local gang = gangOf(xp)
        if gang then
            for _, g in ipairs(allowed.gangs) do
                if tostring(g):lower() == gang then return true end
            end
        end
    end
    if hasEntries(allowed.groups) then
        local group = MySQL.scalar.await('SELECT `group` FROM users WHERE identifier = ?', { xp.identifier })
        if group ~= nil and listHas(allowed.groups, group) then return true end
    end
    return false
end

-- `entrance` of one config world: a fixed point, or the boss point of the player's gang.
local function nearWorldEntrance(src, w)
    local e = w and w.entrance
    if not e then return true end

    local point = e
    if e.gangBoss then
        local xp = getPlayer(src)
        point = gangBossPoint(xp)
        if not point then return false end
    end
    local d = distanceTo(src, point)
    return d ~= nil and d <= (e.radius or 40.0)
end

---@return boolean ok, string? reason
local function entryCheck(src, w)
    if isAdmin(src) then return true end

    local cfg = CWConfig.Entrance
    if cfg and cfg.enabled and not (cfg.ownersExempt and isOwner(src, w)) then
        local xp = getPlayer(src)
        if not xp then return false, 'no_player' end

        if not listedForEntry(xp, cfg.allowed) then return false, 'not_allowed' end

        if cfg.place then
            local d = distanceTo(src, cfg.place)
            if not d or d > (cfg.place.radius or 15.0) then return false, 'too_far_place' end
        end

        if cfg.nearGang then
            local point, why = gangBossPoint(xp)
            if not point then return false, why end
            local d = distanceTo(src, point)
            if not d or d > (cfg.gangRadius or 40.0) then return false, 'too_far_gang' end
        end
    end

    if not nearWorldEntrance(src, w) then return false, 'too_far_entrance' end
    return true
end

lib.callback.register('unique_cw:join', function(src, id)
    id = toWorldId(id)
    if not id or id == 0 then return false, 'invalid' end
    local ok, why = canEnter(src, id)
    if not ok then return false, why end
    local ok2, why2 = entryCheck(src, getWorld(id))
    if not ok2 then return false, why2 end
    return SetWorld(src, id)
end)

lib.callback.register('unique_cw:leave', function(src)
    if GetPlayerRoutingBucket(src) == 0 then return false, 'same' end
    return SetWorld(src, 0)
end)

-- Does the world the player is in allow this tool? (menu, vehicle, tp, revive, weapon, armor, peds)
lib.callback.register('unique_cw:can', function(src, feature)
    local rec = inWorld[src]
    if not rec then return false end
    local flags = effectiveFlags(getWorld(rec.world))
    return flags[feature] == true
end)

lib.callback.register('unique_cw:revive', function(src)
    local rec = inWorld[src]
    if not rec or not effectiveFlags(getWorld(rec.world)).revive then return false end
    TriggerClientEvent('esx_ambulancejob:revivex', src)
    return true
end)

-- ---------------------------------------------------------------- admin callbacks

local function adminCallback(name, fn)
    lib.callback.register('unique_cw:' .. name, function(src, ...)
        if not ready then return false, 'not_ready' end
        if not isAdmin(src) then return false, 'no_permission' end
        return fn(src, ...)
    end)
end

-- Admins, or the buyer of that very world.
local function ownerCallback(name, fn)
    lib.callback.register('unique_cw:' .. name, function(src, id, ...)
        if not ready then return false, 'not_ready' end
        local w = worlds[toWorldId(id)]
        if not w then return false, 'not_found' end
        if not (isAdmin(src) or isOwner(src, w)) then return false, 'no_permission' end
        return fn(src, id, ...)
    end)
end

local function resolveIdentifier(who)
    local n = tonumber(who)
    if n then
        if GetPlayerName(n) then
            local xp = getPlayer(n)
            if xp and xp.identifier then return xp.identifier end
        end
        return nil
    end
    if type(who) == 'string' and #who >= 5 and #who <= 80 and not who:find('[%s`\'"]') then
        return who
    end
    return nil
end

adminCallback('create', function(src, id)
    id = toWorldId(id)
    if not id or id < CWConfig.MinWorldId or id > CWConfig.MaxWorldId then return false, 'range' end
    if worlds[id] then return false, 'exists' end

    local w = { id = id, label = nil, gang_access = false, gangs = {}, players = {}, flags = {}, expire = 0 }
    MySQL.insert.await(
        'INSERT INTO unique_worlds (id, label, gang_access, gangs, players, flags, expire) VALUES (?, ?, 0, ?, ?, ?, 0)',
        { id, nil, '[]', '[]', '[]' }
    )
    worlds[id] = w
    log(('%s created world %d'):format(playerLabel(src), id))
    return true
end)

adminCallback('delete', function(src, id)
    id = toWorldId(id)
    if not id or not worlds[id] then return false, 'not_found' end

    for target, rec in pairs(inWorld) do
        if rec.world == id then SetWorld(target, 0) end
    end
    MySQL.update.await('DELETE FROM unique_worlds WHERE id = ?', { id })
    MySQL.update.await('DELETE FROM unique_world_skins WHERE world = ?', { id })
    worlds[id] = nil
    log(('%s deleted world %d'):format(playerLabel(src), id))
    return true
end)

ownerCallback('label', function(src, id, text)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    text = type(text) == 'string' and text:sub(1, 64) or nil
    if text == '' then text = nil end
    w.label = text
    saveWorld(w)
    return true
end)

adminCallback('gangAccess', function(src, id, state)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    w.gang_access = state and true or false
    saveWorld(w)
    log(('%s set gang access of world %d to %s'):format(playerLabel(src), w.id, tostring(w.gang_access)))
    return true
end)

adminCallback('gang', function(src, id, gang, add)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    if type(gang) ~= 'string' or gang == '' or #gang > 50 then return false, 'invalid' end
    gang = gang:lower()
    if add then
        if not listHas(w.gangs, gang) then w.gangs[#w.gangs + 1] = gang end
    else
        listRemove(w.gangs, gang)
    end
    saveWorld(w)
    log(('%s %s gang %s on world %d'):format(playerLabel(src), add and 'added' or 'removed', gang, w.id))
    return true
end)

ownerCallback('player', function(src, id, who, add)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    local identifier = resolveIdentifier(who)
    if not identifier then return false, 'invalid' end
    if add then
        local cap = CWConfig.Shop and CWConfig.Shop.maxPlayers
        if cap and not isAdmin(src) and not listHas(w.players, identifier) and #w.players >= cap then
            return false, 'limit'
        end
        if not listHas(w.players, identifier) then w.players[#w.players + 1] = identifier end
    else
        listRemove(w.players, identifier)
    end
    saveWorld(w)
    log(('%s %s player %s on world %d'):format(playerLabel(src), add and 'added' or 'removed', identifier, w.id))
    return true
end)

adminCallback('expire', function(src, id, days)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    days = tonumber(days)
    if not days or days < 0 or days > 3650 then return false, 'invalid' end
    w.expire = days == 0 and 0 or (os.time() + math.floor(days * 86400))
    saveWorld(w)
    log(('%s set expire of world %d to %s days'):format(playerLabel(src), w.id, tostring(days)))
    return true
end)

adminCallback('flag', function(src, id, name, value)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    if not listHas(FLAG_NAMES, name) then return false, 'invalid' end
    w.flags[name] = value and true or false
    saveWorld(w)
    -- Push the new flags to everyone currently inside.
    for target, rec in pairs(inWorld) do
        if rec.world == w.id then
            TriggerClientEvent('unique_cw:client:flags', target, effectiveFlags(w))
        end
    end
    return true
end)

-- Admin: use the position you are standing on as the spawn point of the world (clear = remove it).
ownerCallback('spawn', function(src, id, clear)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    if clear then
        w.spawn = nil
    else
        local ped = GetPlayerPed(src)
        if not ped or ped == 0 then return false, 'invalid' end
        local c = GetEntityCoords(ped)
        w.spawn = {
            x = tonumber(('%.2f'):format(c.x)), y = tonumber(('%.2f'):format(c.y)), z = tonumber(('%.2f'):format(c.z)),
            h = tonumber(('%.1f'):format(GetEntityHeading(ped))),
        }
    end
    saveWorld(w)
    log(('%s %s the spawn of world %d'):format(playerLabel(src), clear and 'cleared' or 'set', w.id))
    return true
end)

-- Admin: send an online player (or yourself) into a world.
adminCallback('send', function(src, target, id)
    target = tonumber(target)
    id = toWorldId(id)
    if not target or not GetPlayerName(target) then return false, 'invalid' end
    if not id or id < 0 then return false, 'invalid' end
    local ok, why = SetWorld(target, id, { force = true, by = src })
    return ok, why
end)



local hostRecord

-- ---------------------------------------------------------------- host tools (events)
-- Revive / heal / armor / freeze / kick, bring everybody, announcements and a countdown for the people in the
-- world. Allowed: admins, the owner of a rented world and - in the streamer world - the streamer group.
-- The world's `host` tool can switch it off.

local lastHostMessage = {}   -- [src] = os.time() of the last announcement / countdown (anti spam)

local function streamerHost(src, rec)
    local S = CWConfig.Streamer
    if not (S and S.enabled and rec.world == S.world) then return false end
    local xp = getPlayer(src)
    if not xp then return false end
    return MySQL.scalar.await('SELECT `group` FROM users WHERE identifier = ?', { xp.identifier }) == S.group
end

hostRecord = function(src)
    local rec = inWorld[src]
    if not rec then return nil end
    if not effectiveFlags(getWorld(rec.world)).host then return nil end
    if isAdmin(src) or isOwner(src, worlds[rec.world]) or streamerHost(src, rec) then return rec end
    return nil
end

local function worldMembers(world)
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        id = tonumber(id)
        if id and GetPlayerRoutingBucket(id) == world then out[#out + 1] = id end
    end
    return out
end

lib.callback.register('unique_cw:hostInfo', function(src)
    return hostRecord(src) ~= nil
end)

local PER_PLAYER = {
    revive = true, heal = true, armor = true, freeze = true, unfreeze = true, kick = true,
}

lib.callback.register('unique_cw:host', function(src, action, arg)
    local rec = hostRecord(src)
    if not rec then return false, 'no_permission' end
    if type(action) ~= 'string' then return false, 'invalid' end

    local members = worldMembers(rec.world)

    if PER_PLAYER[action] then
        local target = tonumber(arg)
        if not target or not GetPlayerName(target) or GetPlayerRoutingBucket(target) ~= rec.world then return false, 'not_found' end
        if action == 'kick' then
            if target == src then return false, 'invalid' end
            local ok, why = SetWorld(target, 0, { by = src })
            return ok, why
        end
        if action == 'revive' then TriggerClientEvent('esx_ambulancejob:revivex', target)
        elseif action == 'heal' then TriggerClientEvent('unique_cw:client:heal', target)
        elseif action == 'armor' then TriggerClientEvent('unique_cw:client:armor', target)
        elseif action == 'freeze' then TriggerClientEvent('unique_cw:client:freeze', target, true)
        elseif action == 'unfreeze' then TriggerClientEvent('unique_cw:client:freeze', target, false) end
        log(('%s: %s %s'):format(playerLabel(src), action, playerLabel(target)))
        return true
    end

    if action == 'revive_all' then
        for _, id in ipairs(members) do TriggerClientEvent('esx_ambulancejob:revivex', id) end
    elseif action == 'heal_all' then
        for _, id in ipairs(members) do TriggerClientEvent('unique_cw:client:heal', id) end
    elseif action == 'armor_all' then
        for _, id in ipairs(members) do TriggerClientEvent('unique_cw:client:armor', id) end
    elseif action == 'freeze_all' or action == 'unfreeze_all' then
        for _, id in ipairs(members) do
            if id ~= src then TriggerClientEvent('unique_cw:client:freeze', id, action == 'freeze_all') end
        end
    elseif action == 'bring_all' then
        local ped = GetPlayerPed(src)
        if not ped or ped == 0 then return false, 'invalid' end
        local c = GetEntityCoords(ped)
        for _, id in ipairs(members) do
            if id ~= src then TriggerClientEvent('unique_cw:client:teleport', id, { x = c.x, y = c.y, z = c.z }) end
        end
    elseif action == 'announce' or action == 'countdown' then
        local now = os.time()
        if lastHostMessage[src] and now - lastHostMessage[src] < 3 then return false, 'busy' end
        if action == 'announce' then
            local text = type(arg) == 'string' and arg:gsub('%c', ' '):gsub('^%s+', ''):gsub('%s+$', '') or ''
            text = tostring(text):sub(1, 120)
            if text == '' then return false, 'invalid' end
            for _, id in ipairs(members) do TriggerClientEvent('unique_cw:client:announce', id, text, clean(GetPlayerName(src))) end
        else
            local seconds = math.floor(tonumber(arg) or 0)
            if seconds < 3 or seconds > 10 then return false, 'invalid' end
            for _, id in ipairs(members) do TriggerClientEvent('unique_cw:client:countdown', id, seconds) end
        end
        lastHostMessage[src] = now
    else
        return false, 'invalid'
    end

    log(('%s: %s in world %d'):format(playerLabel(src), action, rec.world))
    return true
end)

AddEventHandler('playerDropped', function()
    lastHostMessage[source] = nil
end)

-- ---------------------------------------------------------------- in-world teleport tools

local function sameWorldTarget(src, target)
    local rec = inWorld[src]
    if not rec then return nil end
    target = tonumber(target)
    if not target or target == src or not GetPlayerName(target) then return nil end
    if GetPlayerRoutingBucket(target) ~= rec.world then return nil end
    return target, rec
end

-- People in the same world (for the go to / bring menus). Second value: may this player bring others?
lib.callback.register('unique_cw:members', function(src)
    local rec = inWorld[src]
    if not rec then return {}, false end
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        id = tonumber(id)
        if id and id ~= src and GetPlayerRoutingBucket(id) == rec.world then
            out[#out + 1] = { id = id, name = clean(GetPlayerName(id)) }
        end
    end
    return out, (isAdmin(src) or isOwner(src, worlds[rec.world])) and true or false, hostRecord(src) ~= nil
end)

-- Go to a player of the same world (needs the world's "tp" tool).
lib.callback.register('unique_cw:goto', function(src, target)
    local rec = inWorld[src]
    if not rec or not effectiveFlags(getWorld(rec.world)).tp then return false, 'no_permission' end
    local t = sameWorldTarget(src, target)
    if not t then return false, 'not_found' end
    local c = GetEntityCoords(GetPlayerPed(t))
    TriggerClientEvent('unique_cw:client:teleport', src, { x = c.x, y = c.y, z = c.z })
    return true
end)

-- Bring a player of the same world to you. Only admins and the owner of the world may do this.
lib.callback.register('unique_cw:bring', function(src, target)
    local rec = inWorld[src]
    if not rec or not effectiveFlags(getWorld(rec.world)).tp then return false, 'no_permission' end
    if not (isAdmin(src) or isOwner(src, worlds[rec.world])) then return false, 'no_permission' end
    local t = sameWorldTarget(src, target)
    if not t then return false, 'not_found' end
    local c = GetEntityCoords(GetPlayerPed(src))
    TriggerClientEvent('unique_cw:client:teleport', t, { x = c.x, y = c.y, z = c.z })
    return true
end)

-- ---------------------------------------------------------------- world skins (saved outfits)

local function skinNames(worldId)
    local rows = MySQL.query.await('SELECT name FROM unique_world_skins WHERE world = ? ORDER BY name', { worldId }) or {}
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = r.name end
    return out
end

lib.callback.register('unique_cw:skinNames', function(src)
    local rec = inWorld[src]
    local w = rec and getWorld(rec.world)
    if not w or not effectiveFlags(w).skins then return {} end
    local out = {}
    for _, name in ipairs(skinNames(rec.world)) do
        out[#out + 1] = { name = name, label = (w.skins and w.skins[name]) or name }
    end
    return out
end)

lib.callback.register('unique_cw:skinGet', function(src, name)
    local rec = inWorld[src]
    if not rec or type(name) ~= 'string' or #name > 64 then return nil end
    if not effectiveFlags(getWorld(rec.world)).skins then return nil end
    return decode(MySQL.scalar.await('SELECT skin FROM unique_world_skins WHERE world = ? AND name = ?', { rec.world, name }), nil)
end)

-- Admin, while standing inside the world: store the current outfit under a name.
adminCallback('skinSave', function(src, name, skin)
    local rec = inWorld[src]
    if not rec or not getWorld(rec.world) then return false, 'not_found' end
    if type(name) ~= 'string' or type(skin) ~= 'table' then return false, 'invalid' end
    name = name:gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 64)
    if name == '' then return false, 'invalid' end
    local encoded = json.encode(skin)
    if #encoded > 30000 then return false, 'invalid' end
    MySQL.query.await(
        'INSERT INTO unique_world_skins (world, name, skin) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE skin = VALUES(skin)',
        { rec.world, name, encoded }
    )
    log(('%s saved skin "%s" in world %d'):format(playerLabel(src), name, rec.world))
    return true
end)

adminCallback('skinList', function(src, id)
    id = toWorldId(id)
    if not id or not getWorld(id) then return false, 'not_found' end
    return true, skinNames(id)
end)

adminCallback('skinDelete', function(src, id, name)
    id = toWorldId(id)
    if not id or not worlds[id] or type(name) ~= 'string' then return false, 'not_found' end
    MySQL.update.await('DELETE FROM unique_world_skins WHERE world = ? AND name = ?', { id, name })
    return true
end)


-- ---------------------------------------------------------------- world shop (buy / renew)

local buying = {}

local function nearShop(src)
    local S = CWConfig.Shop
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local c = GetEntityCoords(ped)
    local dx, dy, dz = c.x - S.coords.x, c.y - S.coords.y, c.z - S.coords.z
    return math.sqrt(dx * dx + dy * dy + dz * dz) <= (S.radius or 2.0) + 3.0
end

local function ownedCount(identifier)
    local n = 0
    for _, w in pairs(worlds) do
        if w.owner == identifier then n = n + 1 end
    end
    return n
end

local function nextFreeId(S)
    for id = S.idMin, S.idMax do
        if not worlds[id] and not (CWConfig.StaticWorlds and CWConfig.StaticWorlds[id]) then return id end
    end
    return nil
end

local function persistPlayer(xp)
    if ESX and ESX.SavePlayer then pcall(ESX.SavePlayer, xp, function() end) end
end

local function validDays(S, days)
    days = tonumber(days)
    days = days and math.tointeger(days)
    if not days or days < S.minDays or days > S.maxDays then return nil end
    return days
end

lib.callback.register('unique_cw:shopBuy', function(src, days)
    local S = CWConfig.Shop
    if not S or not S.enabled or not ready then return false, 'not_ready' end
    if buying[src] then return false, 'busy' end
    buying[src] = true

    local ok, a, b = pcall(function()
        if not nearShop(src) then return false, 'too_far_shop' end
        days = validDays(S, days)
        if not days then return false, 'invalid' end

        local xp = getPlayer(src)
        if not xp then return false, 'no_player' end
        if ownedCount(xp.identifier) >= S.maxOwned then return false, 'limit' end

        local price = days * S.pricePerDay
        if not xp.canAfford(price) then return false, 'no_money' end
        local id = nextFreeId(S)
        if not id then return false, 'full' end

        if not xp.payAny(price) then return false, 'no_money' end
        local w = {
            id = id, label = nil, gang_access = false, gangs = {}, players = {}, flags = {},
            expire = os.time() + days * 86400, owner = xp.identifier,
        }
        local inserted = pcall(MySQL.insert.await,
            'INSERT INTO unique_worlds (id, label, gang_access, gangs, players, flags, expire, owner) VALUES (?, NULL, 0, ?, ?, ?, ?, ?)',
            { id, '[]', '[]', '[]', w.expire, w.owner })
        if not inserted then
            xp.addMoney(price)   -- could not store the world: give the money back
            return false, 'invalid'
        end
        worlds[id] = w
        persistPlayer(xp)
        log(('%s bought world %d for %d days (%d)'):format(playerLabel(src), id, days, price))
        return true, id
    end)

    buying[src] = nil
    if not ok then return false, 'invalid' end
    return a, b
end)

lib.callback.register('unique_cw:shopRenew', function(src, id, days)
    local S = CWConfig.Shop
    if not S or not S.enabled or not ready then return false, 'not_ready' end
    if buying[src] then return false, 'busy' end
    buying[src] = true

    local ok, a, b = pcall(function()
        if not nearShop(src) then return false, 'too_far_shop' end
        days = validDays(S, days)
        if not days then return false, 'invalid' end

        local w = worlds[toWorldId(id)]
        if not w then return false, 'not_found' end
        if not isOwner(src, w) then return false, 'no_permission' end

        local base = math.max(w.expire or 0, os.time())
        local newExpire = base + days * 86400
        if newExpire - os.time() > S.maxDays * 86400 then return false, 'limit' end

        local xp = getPlayer(src)
        local price = days * S.pricePerDay
        if not xp or not xp.canAfford(price) then return false, 'no_money' end
        if not xp.payAny(price) then return false, 'no_money' end

        w.expire = newExpire
        saveWorld(w)
        persistPlayer(xp)
        log(('%s renewed world %d by %d days (%d)'):format(playerLabel(src), w.id, days, price))
        return true
    end)

    buying[src] = nil
    if not ok then return false, 'invalid' end
    return a, b
end)

-- ---------------------------------------------------------------- streamer entrance (/cw, /bw)

local function tell(src, text, kind)
    TriggerClientEvent('unique_cw:client:notify', src, text, kind)
end

if CWConfig.Streamer and CWConfig.Streamer.enabled then
    local S = CWConfig.Streamer

    local function isStreamer(src)
        local xp = getPlayer(src)
        if not xp then return false end
        local group = MySQL.scalar.await('SELECT `group` FROM users WHERE identifier = ?', { xp.identifier })
        return group == S.group
    end

    local function nearHub(target)
        local c = GetEntityCoords(GetPlayerPed(target))
        local dx, dy, dz = c.x - S.hub.x, c.y - S.hub.y, c.z - S.hub.z
        return math.sqrt(dx * dx + dy * dy + dz * dz) <= S.radius
    end

    -- Streamer sends a player (or themselves) into the streamer world from the entrance.
    local function streamerSend(src, target)
        if not isStreamer(src) then return false, 'not_streamer' end
        target = tonumber(target) or src
        if not GetPlayerName(target) or not getPlayer(target) then return false, 'not_found' end
        if not nearHub(target) then return false, 'too_far' end
        return SetWorld(target, S.world, { force = true, ret = S.hub, by = src })
    end

    -- Streamer brings a player back from the streamer world to the entrance.
    local function streamerReturn(src, target)
        if not isStreamer(src) then return false, 'not_streamer' end
        target = tonumber(target)
        if not target or not GetPlayerName(target) then return false, 'not_found' end
        if GetPlayerRoutingBucket(target) ~= S.world then return false, 'not_found' end
        return SetWorld(target, 0, { by = src })
    end

    lib.callback.register('unique_cw:stSend', function(src, target) return streamerSend(src, target) end)
    lib.callback.register('unique_cw:stReturn', function(src, target) return streamerReturn(src, target) end)

    local STREAMER_TEXT = {
        not_streamer = 'Shoma Dastresi Be In Komand Ra Nadarid!',
        not_found = 'Bazikon Mored Nazar Peyda Nashod!',
        too_far = 'Bazikon Mored Nazar Nazdik Be Noghteye Vared Shodan Nist!',
        same = 'Taghiri Anjam Nashod.',
    }

    -- /cw           -> menu (enter, send nearby players, bring players back)
    -- /cw <id>      -> send that player straight away
    RegisterCommand('cw', function(source, args)
        if source == 0 then return end
        if not getPlayer(source) then return end

        if args[1] then
            local ok, why = streamerSend(source, args[1])
            if not ok then return tell(source, STREAMER_TEXT[why] or 'Taghiri Anjam Nashod.', 'error') end
            if tonumber(args[1]) ~= source then tell(source, ('Bazikon ID %s Be World %d Vared Shod!'):format(args[1], S.world), 'success') end
            return
        end

        if not isStreamer(source) then return tell(source, STREAMER_TEXT.not_streamer, 'error') end

        local nearby, inside = {}, {}
        for _, id in ipairs(GetPlayers()) do
            id = tonumber(id)
            if id and getPlayer(id) then
                if GetPlayerRoutingBucket(id) == S.world then
                    if id ~= source then inside[#inside + 1] = { id = id, name = clean(GetPlayerName(id)) } end
                elseif id ~= source and nearHub(id) then
                    nearby[#nearby + 1] = { id = id, name = clean(GetPlayerName(id)) }
                end
            end
        end
        TriggerClientEvent('unique_cw:client:streamerMenu', source, {
            world = S.world,
            me = source,
            inWorld = GetPlayerRoutingBucket(source) == S.world,
            nearby = nearby,
            inside = inside,
        })
    end, false)

    RegisterCommand('bw', function(source)
        if source == 0 then return end
        if GetPlayerRoutingBucket(source) ~= S.world then
            return tell(source, ('Shoma Dar World %d Nistid!'):format(S.world), 'error')
        end
        SetWorld(source, 0)
    end, false)
end

-- ---------------------------------------------------------------- /changeworldrange (/cwr)

do
    local R = CWConfig.Range or { maxRange = 100.0, groups = {} }

    local function rangeAllowed(src)
        if isAdmin(src) then return true end
        if not R.groups or #R.groups == 0 then return false end
        local xp = getPlayer(src)
        if not xp then return false end
        local group = MySQL.scalar.await('SELECT `group` FROM users WHERE identifier = ?', { xp.identifier })
        return group ~= nil and listHas(R.groups, group)
    end

    local function rangeCommand(source, args)
        if source == 0 then return end
        if not getPlayer(source) then return end
        if not rangeAllowed(source) then return tell(source, 'Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid!', 'error') end

        local range, world = tonumber(args[1]), toWorldId(args[2])
        if not range or not world then return tell(source, 'Estefade: /changeworldrange [range] [world]', 'error') end
        if range < 0 or range > R.maxRange then
            return tell(source, ('Range Nemitavanad Bishtar Az %d Bashad!'):format(R.maxRange), 'error')
        end
        if world < 0 or world > CWConfig.MaxWorldId then return tell(source, 'Shomare World Dar Mahdude Nist.', 'error') end

        local me = GetEntityCoords(GetPlayerPed(source))
        local moved = 0
        for _, id in ipairs(GetPlayers()) do
            id = tonumber(id)
            if id and getPlayer(id) and GetPlayerRoutingBucket(id) ~= world then
                local c = GetEntityCoords(GetPlayerPed(id))
                local dx, dy, dz = c.x - me.x, c.y - me.y, c.z - me.z
                if math.sqrt(dx * dx + dy * dy + dz * dz) <= range + 10.0 then
                    if SetWorld(id, world, { force = true, silent = true, by = source }) then moved = moved + 1 end
                end
            end
        end
        log(('%s moved %d player(s) within %d m to world %d'):format(playerLabel(source), moved, range, world))
        tell(source, ('%d Nafar Be World %d Montaghel Shod'):format(moved, world), 'success')
    end

    RegisterCommand('changeworldrange', rangeCommand, false)
    RegisterCommand('cwr', rangeCommand, false)
end

-- ---------------------------------------------------------------- /getworld

RegisterCommand('getworld', function(source, args)
    if source == 0 then
        local id = tonumber(args[1])
        if id and GetPlayerName(id) then print(('ID: %d World: %d'):format(id, GetPlayerRoutingBucket(id))) end
        return
    end
    if not isAdmin(source) then
        return TriggerClientEvent('unique_cw:client:notify', source, 'Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid!', 'error')
    end
    local id = tonumber(args[1]) or source
    if not GetPlayerName(id) then
        return TriggerClientEvent('unique_cw:client:notify', source, 'Bazikon Mored Nazar Peyda Nashod!', 'error')
    end
    TriggerClientEvent('unique_cw:client:notify', source, ('ID %d Dar World %d Ast.'):format(id, GetPlayerRoutingBucket(id)), 'inform')
end, false)

-- ---------------------------------------------------------------- expiry sweep

CreateThread(function()
    while true do
        Wait(60 * 1000)
        for src, rec in pairs(inWorld) do
            local w = worlds[rec.world]
            if w and isExpired(w) and not isAdmin(src) then
                TriggerClientEvent('unique_cw:client:notify', src, 'Zaman In World Tamam Shode Ast.', 'error')
                SetWorld(src, 0)
            end
        end
    end
end)
