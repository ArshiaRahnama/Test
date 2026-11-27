-- ============================================================================
-- Unique_inventory | server/weapons.lua
-- Weapon lifetime, keyed by the weapon's SERIAL (so it survives dropping, giving,
-- trunks and armories without touching essentialmode's loadout format):
--   * expiry   : a weapon expires WeaponLife.expireDays after the system first sees it
--   * wear     : the client reports shots, health = 100 - shots * 100 / maxShots
--   * cleaning : the cleaner item resets the shots of the weapon in the player's hand
-- Table unique_weapon_meta(serial, shots, expire_ts) - expire_ts 0 means "never".
-- ============================================================================

local WL = WeaponLife
local UNIQUE = UNIQUE

MySQL.ready(function()
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `unique_weapon_meta` (
        `serial` varchar(64) NOT NULL,
        `shots` int NOT NULL DEFAULT 0,
        `expire_ts` bigint NOT NULL DEFAULT 0,
        PRIMARY KEY (`serial`)
    )]], {})
end)

local meta = {}       -- [serial] = { shots = n, expireTS = unix | nil, dirty = bool }
local flushing = false

local function flushSoon()
    if flushing then return end
    flushing = true
    SetTimeout(2000, function()
        flushing = false
        for serial, m in pairs(meta) do
            if m.dirty then
                m.dirty = false
                MySQL.Async.execute(
                    'INSERT INTO unique_weapon_meta (serial, shots, expire_ts) VALUES (@s, @h, @e) ON DUPLICATE KEY UPDATE shots = @h, expire_ts = @e',
                    { ['@s'] = serial, ['@h'] = m.shots, ['@e'] = m.expireTS or 0 })
            end
        end
    end)
end

-- load the rows of serials we have not seen yet, then create rows for brand-new weapons.
-- entries = { { serial = 'LAW-...', name = 'WEAPON_X' }, ... }; a new weapon lives WeaponLife.DaysFor(name) days
local function ensure(entries)
    local missing, names = {}, {}
    for _, e in ipairs(entries) do
        if e.serial and not meta[e.serial] and names[e.serial] == nil then
            missing[#missing + 1] = e.serial
            names[e.serial] = e.name or false
        end
    end
    if #missing == 0 then return end

    local params, marks = {}, {}
    for i, s in ipairs(missing) do
        params['@s' .. i] = s
        marks[#marks + 1] = '@s' .. i
    end
    local ok, rows = pcall(function()
        return MySQL.Sync.fetchAll('SELECT serial, shots, expire_ts FROM unique_weapon_meta WHERE serial IN (' .. table.concat(marks, ',') .. ')', params)
    end)
    if ok and type(rows) == 'table' then
        for _, r in ipairs(rows) do
            local e = tonumber(r.expire_ts) or 0
            meta[r.serial] = { shots = tonumber(r.shots) or 0, expireTS = e > 0 and e or nil }
        end
    elseif not ok then
        print(('^1[Unique_inventory]^0 cannot read unique_weapon_meta: %s'):format(tostring(rows)))
    end

    local now = os.time()
    for _, s in ipairs(missing) do
        if not meta[s] then
            local days = (not WL.NoExpire(s)) and WL.DaysFor(names[s] or '') or nil
            meta[s] = {
                shots = 0,
                expireTS = days and (now + days * 86400) or nil,
                dirty = true,
            }
            flushSoon()
        end
    end
end

local function ensureLoadout(xp)
    local entries = {}
    for _, w in ipairs(xp.loadout or {}) do
        if type(w.serial) == 'string' and w.serial ~= '' then entries[#entries + 1] = { serial = w.serial, name = w.name } end
    end
    ensure(entries)
end

local function metaOf(w)
    if not w or not w.serial then return nil end
    if not meta[w.serial] then ensure({ { serial = w.serial, name = w.name } }) end
    return meta[w.serial]
end

-- ---------------------------------------------------------------------------
-- used by main.lua (getSlots) and second.lua (trunk list)
-- ---------------------------------------------------------------------------
function UNIQUE.weaponMeta(serial, name)
    if type(serial) ~= 'string' then return nil end
    if not meta[serial] then ensure({ { serial = serial, name = name } }) end
    return meta[serial]
end

-- Give a weapon with a chosen lifetime. days = nil/false -> permanent.
--   exports['Unique_inventory']:CreateWeapon(source, 'WEAPON_PISTOL', ammo, 30)
-- returns the new serial (nil if the player is gone)
function UNIQUE.createWeapon(src, name, ammo, days)
    local xp = UNIQUE.player(src)
    if not xp or type(name) ~= 'string' then return nil end
    local serial = ESX.GenerateWeaponSerial()
    local expire = nil
    if type(days) == 'number' and days > 0 then expire = os.time() + math.floor(days * 86400) end
    meta[serial] = { shots = 0, expireTS = expire, dirty = true }
    flushSoon()
    xp.addWeapon(name, tonumber(ammo) or 0, serial)
    UNIQUE.saveSoon(src)
    return serial
end
exports('CreateWeapon', function(src, name, ammo, days) return UNIQUE.createWeapon(src, name, ammo, days) end)

-- the player's loadout with metadata = { serial, shots, expireTS } on every weapon
function UNIQUE.decorateLoadout(xp)
    ensureLoadout(xp)
    local out = {}
    for _, w in ipairs(xp.loadout or {}) do
        local copy = {}
        for k, v in pairs(w) do copy[k] = v end
        local m = w.serial and meta[w.serial]
        copy.metadata = { serial = w.serial, shots = m and m.shots or 0, expireTS = m and m.expireTS or nil }
        out[#out + 1] = copy
    end
    return out
end

-- ---------------------------------------------------------------------------
-- moving a weapon between players WITHOUT changing its lifetime or wear
-- (for auction houses, marketplaces, escrow, trades ...). The weapon keeps its serial, so the
-- days it has left and its health follow it. Never re-create a sold weapon with addWeapon(name, ammo):
-- that is a NEW weapon with a fresh clock.
--
--   local w = exports['Unique_inventory']:TakeWeapon(sellerSrc, serial)      -- removes it from the seller, returns a table
--   ... keep `w` while the item is listed ...
--   local ok, reason = exports['Unique_inventory']:GiveWeapon(buyerSrc, w)   -- same serial, same days left
--   exports['Unique_inventory']:TransferWeapon(fromSrc, toSrc, serial)       -- both steps at once
--   exports['Unique_inventory']:GetWeaponInfo(serial)                        -- { shots, health, expireTS, daysLeft }
-- ---------------------------------------------------------------------------
local function expired(m)
    return m and m.expireTS and m.expireTS <= os.time()
end

function UNIQUE.weaponInfo(serial, name)
    local m = UNIQUE.weaponMeta(serial, name)
    if not m then return nil end
    local max = WL.MaxShots(name or '')
    return {
        shots = m.shots,
        health = math.max(0, math.floor((100 - m.shots * 100 / max) * 10 + 0.5) / 10),
        expireTS = m.expireTS,
        daysLeft = m.expireTS and math.max(0, (m.expireTS - os.time()) / 86400) or nil,   -- nil = permanent
        permanent = m.expireTS == nil,
    }
end
exports('GetWeaponInfo', function(serial, name) return UNIQUE.weaponInfo(serial, name) end)

function UNIQUE.takeWeapon(src, serial)
    local xp = UNIQUE.player(src)
    local w = xp and type(serial) == 'string' and UNIQUE.findWeapon(xp, serial)
    local m = metaOf(w)
    if not w or not m then return nil end
    local data = {
        serial = w.serial, name = w.name, label = w.label, ammo = tonumber(w.ammo) or 0,
        components = w.components or {}, tintIndex = w.tintIndex,
        shots = m.shots, expireTS = m.expireTS,
    }
    xp.removeWeapon(w.name, data.ammo, w.serial)
    TriggerClientEvent('core:removeWeapon', src, w.name, w.serial)
    UNIQUE.forgetSerial(UNIQUE.loadSlots(xp), w.serial)
    UNIQUE.markDirty(xp)
    UNIQUE.saveSoon(src)
    return data
end
exports('TakeWeapon', function(src, serial) return UNIQUE.takeWeapon(src, serial) end)

-- returns true, or false + 'noplayer' | 'badweapon' | 'expired' | 'cannotcarry'
function UNIQUE.giveWeapon(src, data)
    local xp = UNIQUE.player(src)
    if not xp then return false, 'noplayer' end
    if type(data) ~= 'table' or type(data.serial) ~= 'string' or type(data.name) ~= 'string' then return false, 'badweapon' end

    -- the lifetime follows the serial; if the row is gone (restart, cleanup) rebuild it from the data we were handed
    local m = meta[data.serial]
    if not m then
        ensure({ { serial = data.serial, name = data.name } })
        m = meta[data.serial]
        if m and data.shots ~= nil then m.shots = tonumber(data.shots) or m.shots end
        if m and data.expireTS ~= nil then m.expireTS = tonumber(data.expireTS) or nil end
        if m then m.dirty = true flushSoon() end
    end
    if expired(m) then return false, 'expired' end
    if not xp.canCarryItem(data.name, 1) then return false, 'cannotcarry' end

    local hadBefore = xp.countWeapon and xp.countWeapon(data.name) or 0
    xp.addWeapon(data.name, tonumber(data.ammo) or 0, data.serial)
    if hadBefore == 0 then
        for _, c in ipairs(data.components or {}) do xp.addWeaponComponent(data.name, c) end
    end
    TriggerClientEvent('esx:updateInventory', src)
    UNIQUE.saveSoon(src)
    return true
end
exports('GiveWeapon', function(src, data) return UNIQUE.giveWeapon(src, data) end)

function UNIQUE.transferWeapon(fromSrc, toSrc, serial)
    local from, to = UNIQUE.player(fromSrc), UNIQUE.player(toSrc)
    if not from or not to or fromSrc == toSrc then return false, 'noplayer' end
    local w = UNIQUE.findWeapon(from, serial)
    if not w then return false, 'badweapon' end
    local m = metaOf(w)
    if expired(m) then return false, 'expired' end
    if not to.canCarryItem(w.name, 1) then return false, 'cannotcarry' end
    local data = UNIQUE.takeWeapon(fromSrc, serial)
    if not data then return false, 'badweapon' end
    local ok, reason = UNIQUE.giveWeapon(toSrc, data)
    if not ok then UNIQUE.giveWeapon(fromSrc, data) return false, reason end   -- put it back
    return true
end
exports('TransferWeapon', function(fromSrc, toSrc, serial) return UNIQUE.transferWeapon(fromSrc, toSrc, serial) end)

-- ---------------------------------------------------------------------------
-- wear: the client counts shots and reports them in small batches
-- ---------------------------------------------------------------------------
RegisterNetEvent('Unique_inventory:weaponShots', function(serial, n)
    local src = source
    local xp = UNIQUE.player(src)
    if not xp or type(serial) ~= 'string' then return end
    n = tonumber(n)
    if not n or n % 1 ~= 0 or n < 1 or n > 60 then return end
    if UNIQUE.limited(src, 'wshots' .. serial, 400) then return end

    local w = UNIQUE.findWeapon(xp, serial)
    local m = metaOf(w)
    if not m then return end

    local max = WL.MaxShots(w.name)
    local before = m.shots
    m.shots = math.min(max, m.shots + n)
    m.dirty = true
    flushSoon()
    TriggerClientEvent('Unique_inventory:weaponMeta', src, serial, m.shots, m.expireTS)
    if before < max and m.shots >= max then
        UNIQUE.notify(src, ('اسلحه %s خراب شد (۰٪). با «%s» تمیزش کن'):format(tostring(w.label or w.name), WL.cleaner.label))
    end
end)

-- ---------------------------------------------------------------------------
-- cleaning
-- ---------------------------------------------------------------------------
RegisterNetEvent('Unique_inventory:cleanWeapon', function(serial)
    local src = source
    local xp = UNIQUE.player(src)
    if not xp or type(serial) ~= 'string' then return end
    if UNIQUE.limited(src, 'wclean', 1500) then return end

    local w = UNIQUE.findWeapon(xp, serial)
    local m = metaOf(w)
    if not m then return end
    if m.shots <= 0 then return UNIQUE.notify(src, 'این اسلحه تمیز است') end

    local item = xp.getInventoryItem(WL.cleaner.item)
    if not item or (item.count or 0) < 1 then
        return UNIQUE.notify(src, ('«%s» ندارید'):format(WL.cleaner.label))
    end
    xp.removeInventoryItem(WL.cleaner.item, 1)
    m.shots = 0
    m.dirty = true
    flushSoon()
    TriggerClientEvent('Unique_inventory:weaponMeta', src, serial, 0, m.expireTS)
    TriggerClientEvent('esx:updateInventory', src)
    UNIQUE.notify(src, ('اسلحه %s تمیز شد (۱۰۰٪)'):format(tostring(w.label or w.name)))
    UNIQUE.saveSoon(src)
end)

-- the cleaner item: created in the items table once, and "use" tells the client to start cleaning
local function registerCleaner()
    local ok = pcall(function()
        exports['essentialmode']:RegisterItem(WL.cleaner.item, WL.cleaner.label, WL.cleaner.weight)
        exports['essentialmode']:RegisterUsableItemRelay(WL.cleaner.item)
    end)
    return ok
end

CreateThread(function()
    for _ = 1, 30 do
        if GetResourceState('essentialmode') == 'started' and registerCleaner() then return end
        Wait(1000)
    end
    print('^1[Unique_inventory]^0 could not register the gun cleaner item (essentialmode not ready)')
end)
AddEventHandler('onResourceStart', function(res)
    if res == 'essentialmode' then SetTimeout(3000, registerCleaner) end
end)

AddEventHandler('essentialmode:relayUsableItem:' .. GetCurrentResourceName(), function(name, src)
    if name == WL.cleaner.item then TriggerClientEvent('Unique_inventory:useCleaner', src) end
end)

-- ---------------------------------------------------------------------------
-- expiry sweep
-- ---------------------------------------------------------------------------
local function expire(xp, id, w, m)
    local ammo = tonumber(w.ammo) or 0
    xp.removeWeapon(w.name, ammo, w.serial)
    TriggerClientEvent('core:removeWeapon', id, w.name, w.serial)
    local slots = UNIQUE.loadSlots(xp)
    UNIQUE.forgetSerial(slots, w.serial)
    UNIQUE.markDirty(xp)
    meta[w.serial] = nil
    MySQL.Async.execute('DELETE FROM unique_weapon_meta WHERE serial = @s', { ['@s'] = w.serial })
    UNIQUE.notify(id, ('اسلحه %s منقضی شد و از بین رفت'):format(tostring(w.label or w.name)))
    UNIQUE.saveSoon(id)
    print(('^3[Unique_inventory]^0 weapon %s (%s) of player %s expired and was removed'):format(w.name, w.serial, tostring(xp.identifier)))
end

local function sweep()
    local now = os.time()
    for _, sid in ipairs(GetPlayers()) do
        local id = tonumber(sid)
        local xp = id and UNIQUE.player(id)
        if xp then
            ensureLoadout(xp)
            for _, w in ipairs(xp.loadout or {}) do
                local m = w.serial and meta[w.serial]
                if m and m.expireTS and m.expireTS <= now and WL.deleteExpired then
                    expire(xp, id, w, m)
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(WL.sweepSeconds * 1000)
        pcall(sweep)
    end
end)

-- the clock of weapons a player already owns starts when they log in after this update
AddEventHandler('esx:playerLoaded', function(src)
    SetTimeout(4000, function()
        local xp = UNIQUE.player(src)
        if xp then ensureLoadout(xp) end
    end)
end)

-- console: uniqueinv_weapons <server id> [serial shots <n> | serial expire <hours>]   (testing)
RegisterCommand('uniqueinv_weapons', function(source, args)
    if source ~= 0 then return end
    local id = tonumber(args[1])
    local xp = id and UNIQUE.player(id)
    if not xp then print('usage: uniqueinv_weapons <server id> [<serial> shots <n> | <serial> expire <hours> | <serial> permanent]') return end
    ensureLoadout(xp)
    if args[2] and args[3] then
        local m = meta[args[2]]
        if not m then print('no such serial on that player') return end
        local v = tonumber(args[4]) or 0
        if args[3] == 'shots' then m.shots = math.max(0, math.floor(v)) end
        if args[3] == 'expire' then m.expireTS = os.time() + math.floor(v * 3600) end
        if args[3] == 'permanent' then m.expireTS = nil end
        m.dirty = true flushSoon()
        TriggerClientEvent('Unique_inventory:weaponMeta', id, args[2], m.shots, m.expireTS)
    end
    for _, w in ipairs(xp.loadout or {}) do
        local m = w.serial and meta[w.serial]
        if m then
            local health = 100 - m.shots * 100 / WL.MaxShots(w.name)
            local left = m.expireTS and ('%.1f h left'):format((m.expireTS - os.time()) / 3600) or 'never expires'
            print(('  %-22s %-18s health %5.1f%%  shots %d/%d  %s'):format(w.name, w.serial, math.max(0, health), m.shots, WL.MaxShots(w.name), left))
        end
    end
end, true)
