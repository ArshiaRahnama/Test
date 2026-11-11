-- ============================================================================
-- Unique_inventory | server/main.lua  (STAGE 1)
-- Core inventory on top of Unique RP's essentialmode:
--   weapon/maket slots, reserved (hotbar) slots, drop, give, carry weight,
--   item table for the UI.
-- Items, weights and money stay authoritative in essentialmode (xPlayer.*);
-- this file never keeps its own copy of what a player owns.
-- STAGE 2: trunk / bag / public / job inventories.  STAGE 3: trade / admin / search.
-- ============================================================================

ESX = nil
local function freshESX()
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    return ESX
end
freshESX()
CreateThread(function() while ESX == nil do Wait(200) freshESX() end end)

local function notify(src, msg) TriggerClientEvent('esx:showNotification', src, msg) end
local function player(src) return ESX and ESX.GetPlayerFromId(src) or nil end

-- --------------------------------------------------------------------------
-- tiny per-source rate limit (anti spam / race dupes)
-- --------------------------------------------------------------------------
local lastAction = {}
local function limited(src, key, ms)
    local k, now = key .. ':' .. src, GetGameTimer()
    if lastAction[k] and now - lastAction[k] < ms then return true end
    lastAction[k] = now
    return false
end
AddEventHandler('playerDropped', function()
    local s = source
    for k in pairs(lastAction) do
        if k:sub(-#tostring(s) - 1) == ':' .. s then lastAction[k] = nil end
    end
end)

-- --------------------------------------------------------------------------
-- slot store: which weapon (by serial) sits in which weapon/maket slot, plus
-- the client's reserved (hotbar) slots. Pure placement data, persisted in
-- sun_inv_slots. Ownership is always re-checked against xPlayer.loadout.
-- --------------------------------------------------------------------------
local NORMAL_SLOTS, MAKET_SLOTS = 3, 2
local store, idBySource = {}, {}

MySQL.ready(function()
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `sun_inv_slots` (
        `identifier` varchar(64) NOT NULL,
        `data` longtext NOT NULL,
        PRIMARY KEY (`identifier`)
    )]], {})
end)

local function intKeys(t)
    local out = {}
    for k, v in pairs(type(t) == 'table' and t or {}) do
        local n = tonumber(k)
        if n and type(v) == 'table' then out[n] = v end
    end
    return out
end

local function loadSlots(xp)
    local id = xp.identifier
    idBySource[xp.source] = id
    if store[id] then return store[id] end
    local okDb, raw = pcall(function()
        return MySQL.Sync.fetchScalar('SELECT data FROM sun_inv_slots WHERE identifier = @i', { ['@i'] = id })
    end)
    if not okDb then
        print(('^1[Unique_inventory]^0 could not read sun_inv_slots (%s) - using empty slots'):format(tostring(raw)))
        raw = nil
    end
    local okJson, data = pcall(function() return raw and json.decode(raw) or {} end)
    if not okJson or type(data) ~= 'table' then data = {} end
    store[id] = {
        normal = intKeys(data.normal),
        maket = intKeys(data.maket),
        reserved = intKeys(data.reserved),
        dirty = false,
    }
    return store[id]
end

local saving = {}
local function markDirty(xp)
    local id = xp.identifier
    local s = store[id]
    if not s then return end
    s.dirty = true
    if saving[id] then return end
    saving[id] = true
    SetTimeout(2000, function()
        saving[id] = nil
        local cur = store[id]
        if not cur or not cur.dirty then return end
        cur.dirty = false
        MySQL.Async.execute(
            'INSERT INTO sun_inv_slots (identifier, data) VALUES (@i, @d) ON DUPLICATE KEY UPDATE data = @d',
            { ['@i'] = id, ['@d'] = json.encode({ normal = cur.normal, maket = cur.maket, reserved = cur.reserved }) }
        )
    end)
end

AddEventHandler('playerDropped', function()
    local src = source
    local id = idBySource[src]
    idBySource[src] = nil
    local s = id and store[id]
    if s then
        if s.dirty then
            s.dirty = false
            MySQL.Async.execute(
                'INSERT INTO sun_inv_slots (identifier, data) VALUES (@i, @d) ON DUPLICATE KEY UPDATE data = @d',
                { ['@i'] = id, ['@d'] = json.encode({ normal = s.normal, maket = s.maket, reserved = s.reserved }) }
            )
        end
        store[id] = nil
    end
end)

-- --------------------------------------------------------------------------
-- helpers over xPlayer.loadout / inventory
-- --------------------------------------------------------------------------
local function findWeapon(xp, serial, name)
    if type(serial) ~= 'string' then return nil end
    for _, w in ipairs(xp.loadout or {}) do
        if w.serial == serial and (not name or tostring(w.name):upper() == tostring(name):upper()) then
            return w
        end
    end
end

local function forgetSerial(s, serial)
    for _, kind in ipairs({ 'normal', 'maket' }) do
        for i, v in pairs(s[kind]) do
            if v.serial == serial then s[kind][i] = nil end
        end
    end
    for i, v in pairs(s.reserved) do
        if v.serial == serial then s.reserved[i] = nil end
    end
end

local function isWeaponName(name)
    local l = tostring(name or ''):lower()
    return l:find('weapon_', 1, true) ~= nil or l:find('gadget_', 1, true) ~= nil
end

-- --------------------------------------------------------------------------
-- callbacks
-- --------------------------------------------------------------------------
RegisterServerCallbackSafe('Unique_inventory:getItems', function(source, cb)
    local esx = freshESX()
    local out = {}
    for name, it in pairs(esx.Items or {}) do
        out[name] = {
            name = name,
            label = it.label or name,
            weight = esx.getItemWeight(name),
            limit = it.limit or -1,
            rare = it.rare or false,
            canRemove = it.canRemove ~= false,
        }
    end
    cb(out)
end)

RegisterServerCallbackSafe('inventory:getSlots', function(source, cb)
    local empty = { maxWeight = (Config and Config.DefaultMaxWeight) or 24, normal = {}, maket = {}, reserved = {}, loadout = {} }
    local ok, res = pcall(function()
        local xp = player(source)
        if not xp then return empty end
        local s = loadSlots(xp)
        -- drop placements of weapons the player no longer owns
        local changed = false
        for _, kind in ipairs({ 'normal', 'maket' }) do
            for i, v in pairs(s[kind]) do
                if not findWeapon(xp, v.serial, v.name) then s[kind][i] = nil changed = true end
            end
        end
        if changed then markDirty(xp) end
        return {
            maxWeight = xp.getMaxWeight(),
            normal = s.normal,
            maket = s.maket,
            reserved = s.reserved,
            loadout = xp.loadout or {},
        }
    end)
    if not ok then
        print(('^1[Unique_inventory]^0 inventory:getSlots failed: %s'):format(tostring(res)))
        res = empty
    end
    cb(res)
end)

RegisterServerCallbackSafe('inventory:howMuchCanCarry', function(source, cb, name)
    local xp = player(source)
    if not xp or type(name) ~= 'string' then return cb(0) end
    if isWeaponName(name) then
        return cb(xp.canCarryItem(name, 1) and 1 or 0)
    end
    local w = ESX.getItemWeight(name)
    if not w or w <= 0 then return cb(9999) end
    local free = xp.getMaxWeight() - xp.getUsedWeight()
    cb(math.max(0, math.floor(free / w)))
end)


-- --------------------------------------------------------------------------
-- STAGE 1 placeholders: callbacks the client AWAITS (Citizen.Await). Without a
-- handler they would never answer and the inventory would hang forever, e.g. as
-- soon as the player owns a "kif" (bag) item. Real versions come in stage 2/3.
-- --------------------------------------------------------------------------
RegisterServerCallbackSafe('bag:getBagTypes', function(source, cb) cb({}) end)
RegisterServerCallbackSafe('bag:getBagType', function(source, cb) cb(nil) end)
RegisterServerCallbackSafe('esx:checkemsstatus', function(source, cb) cb(false, false) end)
RegisterServerCallbackSafe('citizen:cuffstatus', function(source, cb) cb(false, nil, false) end)

-- --------------------------------------------------------------------------
-- slot events
-- --------------------------------------------------------------------------
RegisterNetEvent('inventory:setSlot', function(kind, slot, serial, name)
    local src = source
    local xp = player(src)
    if not xp then return end
    if kind ~= 'normal' and kind ~= 'maket' then return end
    slot = tonumber(slot)
    local max = kind == 'normal' and NORMAL_SLOTS or MAKET_SLOTS
    if not slot or slot % 1 ~= 0 or slot < 1 or slot > max then return end
    if type(name) ~= 'string' or not findWeapon(xp, serial, name) then return end
    -- maket weapons (shared/weapon-slots.lua) fit ONLY the maket slots, and the maket slots take nothing else
    local isMaket = IsMaketWeapon and IsMaketWeapon(name) or false
    if (kind == 'normal' and isMaket) or (kind == 'maket' and not isMaket) then
        return notify(src, kind == 'normal' and 'ماکت فقط داخل اسلات «ماکت» قرار می‌گیرد' or 'فقط ماکت داخل این اسلات قرار می‌گیرد')
    end
    local s = loadSlots(xp)
    forgetSerial(s, serial)
    s[kind][slot] = { name = name, serial = serial }
    markDirty(xp)
end)

RegisterNetEvent('inventory:removeSlot', function(kind, serial)
    local xp = player(source)
    if not xp or (kind ~= 'normal' and kind ~= 'maket') or type(serial) ~= 'string' then return end
    local s = loadSlots(xp)
    for i, v in pairs(s[kind]) do
        if v.serial == serial then s[kind][i] = nil end
    end
    markDirty(xp)
end)

RegisterNetEvent('inventory:swapWeaponSlot', function(a, b)
    local xp = player(source)
    a, b = tonumber(a), tonumber(b)
    if not xp or not a or not b or a == b then return end
    if a % 1 ~= 0 or b % 1 ~= 0 or a < 1 or b < 1 or a > NORMAL_SLOTS or b > NORMAL_SLOTS then return end
    local s = loadSlots(xp)
    s.normal[a], s.normal[b] = s.normal[b], s.normal[a]
    markDirty(xp)
end)

RegisterNetEvent('inventory:setReservedSlot', function(tbl)
    local xp = player(source)
    if not xp or type(tbl) ~= 'table' then return end
    local clean, n = {}, 0
    for k, v in pairs(tbl) do
        local idx = tonumber(k)
        if idx and idx % 1 == 0 and idx >= 1 and idx <= 200 and type(v) == 'table'
            and type(v.name) == 'string' and #v.name <= 64 then
            n = n + 1
            if n > 100 then break end
            clean[idx] = {
                name = v.name,
                serial = (type(v.serial) == 'string' and #v.serial <= 64) and v.serial or nil,
            }
        end
    end
    local s = loadSlots(xp)
    s.reserved = clean
    markDirty(xp)
end)

-- --------------------------------------------------------------------------
-- drop
-- --------------------------------------------------------------------------
local function validCount(c, max)
    c = tonumber(c)
    if not c or c % 1 ~= 0 or c < 1 then return nil end
    if max and c > max then return nil end
    return c
end

RegisterNetEvent('core:dropItem', function(itemType, name, count, serial)
    local src = source
    if limited(src, 'drop', 700) then return end
    local xp = player(src)
    if not xp then return end

    if itemType == 'item_standard' then
        if type(name) ~= 'string' then return end
        local item = xp.getInventoryItem(name)
        if not item or (item.count or 0) < 1 then return end
        if item.canRemove == false then return notify(src, 'این آیتم قابل دراپ نیست') end
        count = validCount(count, item.count)
        if not count then return end
        local label = item.label or name
        xp.removeInventoryItem(name, count)
        ESX.CreatePickup('item_standard', name, count, label, src)

    elseif itemType == 'item_weapon' then
        local w = findWeapon(xp, serial, name)
        if not w then return end
        local ammo = tonumber(w.ammo) or 0
        local label = w.label or ESX.GetWeaponLabel(w.name)
        xp.removeWeapon(w.name, ammo, w.serial)
        ESX.CreatePickup('item_weapon', w.name, { ammo = ammo, components = w.components, serial = w.serial }, label, src)
        TriggerClientEvent('core:removeWeapon', src, w.name, w.serial)
        local s = loadSlots(xp)
        forgetSerial(s, w.serial)
        markDirty(xp)

    else
        return notify(src, 'دراپ پول هنوز پشتیبانی نمی‌شود')
    end

    TriggerClientEvent('esx:updateInventory', src)
end)

-- --------------------------------------------------------------------------
-- give (player -> nearby player)
-- --------------------------------------------------------------------------
local GIVE_DISTANCE = 5.0

RegisterNetEvent('core:giveItem', function(target, itemType, name, count, serial)
    local src = source
    if limited(src, 'give', 700) then return end
    target = tonumber(target)
    if not target or target == src then return end
    local xp, xt = player(src), player(target)
    if not xp or not xt then return end

    local a, b = GetPlayerPed(src), GetPlayerPed(target)
    if a == 0 or b == 0 or #(GetEntityCoords(a) - GetEntityCoords(b)) > GIVE_DISTANCE then
        return notify(src, 'بازیکن به اندازه کافی نزدیک نیست')
    end
    if Player(target).state.canGive == false then
        return notify(src, 'این فرد دریافت آیتم را غیرفعال کرده')
    end

    if itemType == 'item_standard' then
        if type(name) ~= 'string' then return end
        local item = xp.getInventoryItem(name)
        if not item or item.canRemove == false then return end
        count = validCount(count, item.count)
        if not count then return end
        if not xt.canCarryItem(name, count) then
            return notify(src, 'ظرفیت حمل طرف مقابل کافی نیست')
        end
        local limit = tonumber(item.limit)
        if limit and limit > 0 and (xt.getInventoryItem(name).count or 0) + count > limit then
            return notify(src, 'طرف مقابل بیشتر از این نمی‌تواند حمل کند')
        end
        xp.removeInventoryItem(name, count)
        xt.addInventoryItem(name, count)

    elseif itemType == 'item_weapon' then
        local w = findWeapon(xp, serial, name)
        if not w then return end
        if not xt.canCarryItem(w.name, 1) then
            return notify(src, 'ظرفیت حمل طرف مقابل کافی نیست')
        end
        local hadBefore = xt.countWeapon and xt.countWeapon(w.name) or 0
        local ammo, comps = tonumber(w.ammo) or 0, w.components or {}
        xp.removeWeapon(w.name, ammo, w.serial)
        TriggerClientEvent('core:removeWeapon', src, w.name, w.serial)
        local s = loadSlots(xp)
        forgetSerial(s, w.serial)
        markDirty(xp)
        xt.addWeapon(w.name, ammo, w.serial)
        -- components are attached by weapon name; safe only when the target had no copy yet
        if hadBefore == 0 then
            for _, c in ipairs(comps) do xt.addWeaponComponent(w.name, c) end
        end

    elseif itemType == 'item_money' then
        count = validCount(count, tonumber(xp.money) or 0)
        if not count then return end
        xp.removeMoney(count)
        xt.addMoney(count)

    else
        return
    end

    TriggerClientEvent('esx:updateInventory', src)
    TriggerClientEvent('esx:updateInventory', target)
end)


-- --------------------------------------------------------------------------
-- shared helpers for server/second.lua (stash / trunk) and the later modules
-- --------------------------------------------------------------------------
SUN = {
    player = player, notify = notify, limited = limited, validCount = validCount,
    findWeapon = findWeapon, forgetSerial = forgetSerial, isWeaponName = isWeaponName,
    loadSlots = loadSlots, markDirty = markDirty,
}
