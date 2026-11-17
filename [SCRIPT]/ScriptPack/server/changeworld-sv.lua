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

local FLAG_NAMES = { 'menu', 'vehicle', 'tp', 'revive', 'weapon', 'armor', 'peds', 'skins' }
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
        return { id = id, label = st.label, gang_access = false, gangs = {}, players = {}, flags = st.flags or {}, expire = 0, spawn = st.spawn, static = true }
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
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- Tables created by an earlier version do not have the spawn column yet.
    local col = MySQL.query.await("SHOW COLUMNS FROM `unique_worlds` LIKE 'spawn'")
    if not col or #col == 0 then
        MySQL.query.await('ALTER TABLE `unique_worlds` ADD COLUMN `spawn` longtext DEFAULT NULL')
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
        }
    end
    ready = true
end

MySQL.ready(loadWorlds)

-- ---------------------------------------------------------------- access

local function canEnter(src, worldId)
    local w = worlds[worldId]
    if not w then return false, 'not_found' end
    if isAdmin(src) then return true end
    if isExpired(w) then return false, 'expired' end

    local xp = getPlayer(src)
    if not xp then return false, 'no_player' end
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
---@return boolean ok, string? reason
local function SetWorld(src, worldId, opts)
    opts = opts or {}
    src = tonumber(src)
    worldId = toWorldId(worldId)
    if not src or not worldId or not GetPlayerName(src) then return false, 'invalid' end
    if worldId < 0 or worldId > CWConfig.MaxWorldId then return false, 'range' end

    local current = GetPlayerRoutingBucket(src)
    if current == worldId then return false, 'same' end
    if worldId ~= 0 and not worlds[worldId] and not opts.force then return false, 'not_found' end

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
        TriggerClientEvent('unique_cw:client:entered', src, worldId, effectiveFlags(w), w and w.spawn or nil, w and w.label or nil)
    end

    -- Keeps Unique_Hud (and anything else listening) in sync.
    TriggerClientEvent('esx:changeworld', src, worldId)
    TriggerEvent('unique_cw:worldChanged', src, worldId, current)

    log(('%s: world %d -> %d'):format(playerLabel(src), current, worldId))
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
    table.sort(ids)

    for _, id in ipairs(ids) do
        local w = worlds[id]
        local allowed = canEnter(src, id)
        if admin or allowed then
            local entry = {
                id = id,
                label = w.label,
                expire = w.expire,
                expired = isExpired(w),
                canEnter = allowed and true or false,
            }
            if admin then
                entry.gang_access = w.gang_access
                entry.gangs = w.gangs
                entry.players = w.players
                entry.flags = effectiveFlags(w)
                entry.spawn = w.spawn
            end
            out[#out + 1] = entry
        end
    end
    return { admin = admin, worlds = out, current = GetPlayerRoutingBucket(src) }
end)

lib.callback.register('unique_cw:join', function(src, id)
    id = toWorldId(id)
    if not id or id == 0 then return false, 'invalid' end
    local ok, why = canEnter(src, id)
    if not ok then return false, why end
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

adminCallback('label', function(src, id, text)
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

adminCallback('player', function(src, id, who, add)
    local w = worlds[toWorldId(id)]
    if not w then return false, 'not_found' end
    local identifier = resolveIdentifier(who)
    if not identifier then return false, 'invalid' end
    if add then
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
adminCallback('spawn', function(src, id, clear)
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
    local ok, why = SetWorld(target, id, { force = true })
    return ok, why
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
    if not rec or not effectiveFlags(getWorld(rec.world)).skins then return {} end
    return skinNames(rec.world)
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
        return SetWorld(target, S.world, { force = true, ret = S.hub })
    end

    -- Streamer brings a player back from the streamer world to the entrance.
    local function streamerReturn(src, target)
        if not isStreamer(src) then return false, 'not_streamer' end
        target = tonumber(target)
        if not target or not GetPlayerName(target) then return false, 'not_found' end
        if GetPlayerRoutingBucket(target) ~= S.world then return false, 'not_found' end
        return SetWorld(target, 0)
    end

    lib.callback.register('unique_cw:stSend', function(src, target) return streamerSend(src, target) end)
    lib.callback.register('unique_cw:stReturn', function(src, target) return streamerReturn(src, target) end)

    local STREAMER_TEXT = {
        not_streamer = 'You do not have access to this command.',
        not_found = 'Player not found.',
        too_far = 'The player must be near the entrance.',
        same = 'Already in that world.',
    }

    -- /cw           -> menu (enter, send nearby players, bring players back)
    -- /cw <id>      -> send that player straight away
    RegisterCommand('cw', function(source, args)
        if source == 0 then return end
        if not getPlayer(source) then return end

        if args[1] then
            local ok, why = streamerSend(source, args[1])
            if not ok then return tell(source, STREAMER_TEXT[why] or 'Could not change world.', 'error') end
            if tonumber(args[1]) ~= source then tell(source, ('Player %s entered world %d.'):format(args[1], S.world), 'success') end
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
            return tell(source, ('You are not in world %d.'):format(S.world), 'error')
        end
        SetWorld(source, 0)
    end, false)
end

-- ---------------------------------------------------------------- expiry sweep

CreateThread(function()
    while true do
        Wait(60 * 1000)
        for src, rec in pairs(inWorld) do
            local w = worlds[rec.world]
            if w and isExpired(w) and not isAdmin(src) then
                TriggerClientEvent('unique_cw:client:notify', src, 'This world has expired.', 'error')
                SetWorld(src, 0)
            end
        end
    end
end)
