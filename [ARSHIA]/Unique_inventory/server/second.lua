-- ============================================================================
-- Unique_inventory | server/second.lua   (STAGE 2: "second inventory" + trunk)
--
-- Generic key-based stash store behind Unique_inventory:getSecond, plus the
-- vehicle trunk / glove box on top of it. Stashes live in table unique_stash.
-- Items and weapons are MOVED between the player (essentialmode) and a stash,
-- never copied, and every move is validated here, not on the client.
-- Later modules (bag / public / job) plug in with UniqueStash.register(prefix, ...).
-- ============================================================================

local UNIQUE = UNIQUE

local DEFAULT_TRUNK_KG, MAX_TRUNK_KG = 60.0, 1000.0

-- --------------------------------------------------------------------------
-- persistence
-- --------------------------------------------------------------------------

-- tables used to be called sun_*; keep the data when they are renamed
local function migrateTable(old, new)
    local ok, err = pcall(function()
        local function exists(n)
            return (MySQL.Sync.fetchScalar(
                'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = @t',
                { ['@t'] = n }) or 0) > 0
        end
        if exists(old) and not exists(new) then
            MySQL.Sync.execute('RENAME TABLE `' .. old .. '` TO `' .. new .. '`')
            print(('^2[Unique_inventory]^0 table %s renamed to %s (data kept)'):format(old, new))
        end
    end)
    if not ok then print(('^1[Unique_inventory]^0 table migration %s -> %s failed: %s'):format(old, new, tostring(err))) end
end

MySQL.ready(function()
    migrateTable('sun_stash', 'unique_stash')
    MySQL.Async.execute([[CREATE TABLE IF NOT EXISTS `unique_stash` (
        `skey` varchar(128) NOT NULL,
        `data` longtext NOT NULL,
        PRIMARY KEY (`skey`)
    )]], {})
end)

local stashes, saving = {}, {}

local function loadStash(key)
    if stashes[key] then return stashes[key] end
    local okDb, raw = pcall(function()
        return MySQL.Sync.fetchScalar('SELECT data FROM unique_stash WHERE skey = @k', { ['@k'] = key })
    end)
    if not okDb then
        print(('^1[Unique_inventory]^0 cannot read unique_stash (%s) - treating %s as empty'):format(tostring(raw), key))
        raw = nil
    end
    local okJson, data = pcall(function() return raw and json.decode(raw) or {} end)
    if not okJson or type(data) ~= 'table' then data = {} end
    local st = {
        items = type(data.items) == 'table' and data.items or {},
        weapons = type(data.weapons) == 'table' and data.weapons or {},
        slots = type(data.slots) == 'table' and data.slots or {},
    }
    stashes[key] = st
    return st
end

local function saveNow(key)
    local st = stashes[key]
    if not st then return end
    MySQL.Async.execute(
        'INSERT INTO unique_stash (skey, data) VALUES (@k, @d) ON DUPLICATE KEY UPDATE data = @d',
        { ['@k'] = key, ['@d'] = json.encode({ items = st.items, weapons = st.weapons, slots = st.slots }) }
    )
end

local function touch(key)
    if saving[key] then return end
    saving[key] = true
    SetTimeout(1500, function()
        saving[key] = nil
        saveNow(key)
    end)
end

-- --------------------------------------------------------------------------
-- stash operations
-- --------------------------------------------------------------------------
local function itemCount(st, name)
    for _, it in ipairs(st.items) do
        if it.name == name then return it.count end
    end
    return 0
end

local function addItem(st, name, count)
    for _, it in ipairs(st.items) do
        if it.name == name then it.count = it.count + count return end
    end
    st.items[#st.items + 1] = { name = name, count = count }
end

local function removeItem(st, name, count)
    for i, it in ipairs(st.items) do
        if it.name == name then
            if it.count < count then return false end
            it.count = it.count - count
            if it.count <= 0 then table.remove(st.items, i) end
            return true
        end
    end
    return false
end

local function findStashWeapon(st, serial)
    if type(serial) ~= 'string' then return nil end
    for i, w in ipairs(st.weapons) do
        if w.serial == serial then return w, i end
    end
end

local function stashWeight(st)
    local total = 0.0
    for _, it in ipairs(st.items) do total = total + ESX.getItemWeight(it.name) * it.count end
    for _, w in ipairs(st.weapons) do total = total + ESX.getWeaponWeight(w.name) end
    return total
end

-- --------------------------------------------------------------------------
-- providers: who may open which key.  provider = { authorize = function(src, key) -> bool }
-- --------------------------------------------------------------------------
UniqueStash = { providers = {} }
function UniqueStash.register(prefix, provider) UniqueStash.providers[prefix] = provider end

local subscribers = {}   -- [key] = { [src] = true }

local function subscribe(key, src)
    subscribers[key] = subscribers[key] or {}
    subscribers[key][src] = true
end

local function broadcast(key, except)
    for id in pairs(subscribers[key] or {}) do
        if GetPlayerPing(id) > 0 then
            TriggerClientEvent('Unique_inventory:changed', id)
        else
            subscribers[key][id] = nil
        end
    end
end

RegisterNetEvent('Unique_inventory:unsubscribe', function()
    local src = source
    for _, set in pairs(subscribers) do set[src] = nil end
end)
AddEventHandler('playerDropped', function()
    local src = source
    for _, set in pairs(subscribers) do set[src] = nil end
end)

local function authorize(src, key)
    if type(key) ~= 'string' or #key > 128 then return false end
    for prefix, provider in pairs(UniqueStash.providers) do
        if key:sub(1, #prefix) == prefix then
            return provider.authorize(src, key) and true or false
        end
    end
    return false
end

-- --------------------------------------------------------------------------
-- Unique_inventory:getSecond(key, mode, weaponName)   (what the UI shows)
-- --------------------------------------------------------------------------
local function weaponEntry(w)
    return {
        name = w.name, count = 1, ammo = w.ammo or 0,
        components = w.components or {}, tintIndex = w.tintIndex,
        metadata = { serial = w.serial, components = w.components or {} },
    }
end

RegisterServerCallbackSafe('Unique_inventory:getSecond', function(source, cb, key, mode, weaponName)
    if not authorize(source, key) then
        return cb(mode == 'groups' and {} or (mode == 'instances' and {} or { items = {}, weight = 0, tabCounts = { items = 0, guns = 0 } }))
    end
    subscribe(key, source)
    local st = loadStash(key)

    if mode == 'groups' then
        local order, idx = {}, {}
        for _, w in ipairs(st.weapons) do
            if not idx[w.name] then idx[w.name] = { name = w.name, count = 0 } order[#order + 1] = idx[w.name] end
            idx[w.name].count = idx[w.name].count + 1
        end
        return cb(order)
    elseif mode == 'instances' then
        local out = {}
        for _, w in ipairs(st.weapons) do
            if w.name == weaponName then out[#out + 1] = weaponEntry(w) end
        end
        return cb(out)
    end

    local items, total, guns, seen = {}, 0, 0, {}
    for _, it in ipairs(st.items) do
        items[#items + 1] = { name = it.name, count = it.count }
        total = total + it.count
    end
    for _, w in ipairs(st.weapons) do
        if not seen[w.name] then seen[w.name] = true guns = guns + 1 end
    end
    if mode == 'flat' then
        local all = {}
        for _, it in ipairs(items) do all[#all + 1] = it end
        for _, w in ipairs(st.weapons) do all[#all + 1] = weaponEntry(w) end
        return cb(all)
    end
    cb({ items = items, weight = stashWeight(st), tabCounts = { items = total, guns = guns } })
end)

-- --------------------------------------------------------------------------
-- moving things between a player and a stash
-- --------------------------------------------------------------------------
local function hasInfoRows(xp, name)
    for _, row in ipairs(xp.inventory or {}) do
        if row.name == name and row.info then return true end
    end
    return false
end

local function clampMax(w)
    w = tonumber(w)
    if not w or w <= 0 then return DEFAULT_TRUNK_KG end
    return math.min(w, MAX_TRUNK_KG)
end

-- returns true when it moved something
function UniqueStash.put(src, key, data, maxWeight)
    local xp = UNIQUE.player(src)
    if not xp or type(data) ~= 'table' or type(data.name) ~= 'string' then return false end
    local st = loadStash(key)
    local maxW = clampMax(maxWeight)
    local meta = type(data.metadata) == 'table' and data.metadata or {}

    if UNIQUE.isWeaponName(data.name) then
        local w = UNIQUE.findWeapon(xp, meta.serial, data.name)
        if not w then return false end
        if stashWeight(st) + ESX.getWeaponWeight(w.name) > maxW + 1e-6 then
            UNIQUE.notify(src, 'فضای مخزن پر شده است')
            return false
        end
        local ammo, comps = tonumber(w.ammo) or 0, w.components or {}
        xp.removeWeapon(w.name, ammo, w.serial)
        TriggerClientEvent('core:removeWeapon', src, w.name, w.serial)
        local slots = UNIQUE.loadSlots(xp)
        UNIQUE.forgetSerial(slots, w.serial)
        UNIQUE.markDirty(xp)
        st.weapons[#st.weapons + 1] = { name = w.name, ammo = ammo, serial = w.serial, components = comps, tintIndex = w.tintIndex }
    else
        local item = xp.getInventoryItem(data.name)
        if not item or item.canRemove == false then return false end
        if hasInfoRows(xp, data.name) then
            UNIQUE.notify(src, 'این آیتم (مثل کلید ماشین) قابل ذخیره در این مخزن نیست')
            return false
        end
        local count = UNIQUE.validCount(data.count, item.count)
        if not count then return false end
        if stashWeight(st) + ESX.getItemWeight(data.name) * count > maxW + 1e-6 then
            UNIQUE.notify(src, 'فضای مخزن پر شده است')
            return false
        end
        xp.removeInventoryItem(data.name, count)
        addItem(st, data.name, count)
    end

    touch(key)
    UNIQUE.saveSoon(src)
    TriggerClientEvent('esx:updateInventory', src)
    broadcast(key)
    return true
end

function UniqueStash.take(src, key, data)
    local xp = UNIQUE.player(src)
    if not xp or type(data) ~= 'table' or type(data.name) ~= 'string' then return false end
    local st = loadStash(key)
    local meta = type(data.metadata) == 'table' and data.metadata or {}

    if UNIQUE.isWeaponName(data.name) then
        local w = findStashWeapon(st, meta.serial)
        if not w or w.name ~= data.name then return false end
        if not xp.canCarryItem(w.name, 1) then
            UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست')
            return false
        end
        local hadBefore = xp.countWeapon and xp.countWeapon(w.name) or 0
        local _, i = findStashWeapon(st, w.serial)
        table.remove(st.weapons, i)
        xp.addWeapon(w.name, tonumber(w.ammo) or 0, w.serial)
        if hadBefore == 0 then
            for _, c in ipairs(w.components or {}) do xp.addWeaponComponent(w.name, c) end
        end
    else
        local have = itemCount(st, data.name)
        local count = UNIQUE.validCount(data.count, have)
        if not count then return false end
        if not xp.canCarryItem(data.name, count) then
            UNIQUE.notify(src, 'ظرفیت حمل شما کافی نیست')
            return false
        end
        local limit = tonumber(ESX.Items and ESX.Items[data.name] and ESX.Items[data.name].limit)
        local cur = xp.getInventoryItem(data.name)
        if limit and limit > 0 and cur and (cur.count or 0) + count > limit then
            UNIQUE.notify(src, 'بیشتر از این نمی‌توانید حمل کنید')
            return false
        end
        if not removeItem(st, data.name, count) then return false end
        xp.addInventoryItem(data.name, count)
    end

    touch(key)
    UNIQUE.saveSoon(src)
    TriggerClientEvent('esx:updateInventory', src)
    broadcast(key)
    return true
end

function UniqueStash.setSlot(src, key, data)
    if type(data) ~= 'table' or type(data.name) ~= 'string' then return end
    local idx = tonumber(data.droppedTo)
    if not idx or idx % 1 ~= 0 or idx < 1 or idx > 500 then return end
    local st = loadStash(key)
    for k, v in pairs(st.slots) do
        if v == data.name then st.slots[k] = nil end
    end
    st.slots[tostring(idx)] = data.name
    touch(key)
    broadcast(key)
end

-- --------------------------------------------------------------------------
-- vehicle trunk / glove box
-- --------------------------------------------------------------------------
local function normPlate(p)
    return (tostring(p or ''):gsub('^%s+', ''):gsub('%s+$', '')):upper()
end

local function trunkKey(plate, gloveBox)
    plate = normPlate(plate)
    if plate == '' or #plate > 16 then return nil end
    return (gloveBox and 'trunk:glove-box:' or 'trunk:') .. plate
end

-- the player must be standing next to a vehicle that carries this plate
-- (turn off with `set unique_inv_trunk_check 0` if you use non-networked vehicles)
local function nearPlate(src, plate)
    if GetConvarInt('unique_inv_trunk_check', GetConvarInt('sun_inv_trunk_check', 1)) == 0 then return true end
    local ped = GetPlayerPed(src)
    if ped == 0 then return false end
    local me = GetEntityCoords(ped)
    for _, veh in ipairs(GetAllVehicles()) do
        if #(GetEntityCoords(veh) - me) <= 15.0 and normPlate(GetVehicleNumberPlateText(veh)) == plate then
            return true
        end
    end
    return false
end

UniqueStash.register('trunk:', {
    authorize = function(src, key)
        local plate = key:match('^trunk:glove%-box:(.+)$') or key:match('^trunk:(.+)$')
        return plate ~= nil and nearPlate(src, normPlate(plate))
    end,
})

RegisterServerCallbackSafe('inventory-trunk:getVehicleTrunk', function(source, cb, plate, gloveBox)
    local key = trunkKey(plate, gloveBox)
    if not key or not authorize(source, key) then return cb({ items = {}, weapons = {}, slots = {} }) end
    local st = loadStash(key)
    local weapons = {}
    for _, w in ipairs(st.weapons) do weapons[#weapons + 1] = weaponEntry(w) end
    local items = {}
    for _, it in ipairs(st.items) do items[#items + 1] = { name = it.name, count = it.count } end
    cb({ items = items, weapons = weapons, slots = st.slots, weight = stashWeight(st) })
end)

RegisterNetEvent('inventory-trunk:put', function(plate, data, maxWeight)
    local src = source
    if UNIQUE.limited(src, 'trunkput', 300) then return end
    local key = trunkKey(plate, type(data) == 'table' and data.gloveBox)
    if not key or not authorize(src, key) then return end
    UniqueStash.put(src, key, data, maxWeight)
end)

RegisterNetEvent('inventory-trunk:get', function(plate, data)
    local src = source
    if UNIQUE.limited(src, 'trunkget', 300) then return end
    local key = trunkKey(plate, type(data) == 'table' and data.gloveBox)
    if not key or not authorize(src, key) then return end
    UniqueStash.take(src, key, data)
end)

RegisterNetEvent('inventory-trunk:updateSlot', function(plate, data)
    local src = source
    if UNIQUE.limited(src, 'trunkslot', 150) then return end
    local key = trunkKey(plate, type(data) == 'table' and data.gloveBox)
    if not key or not authorize(src, key) then return end
    UniqueStash.setSlot(src, key, data)
end)

-- the garage asks whether a dashboard is locked; this server has no per-vehicle lock metadata yet
RegisterServerCallbackSafe('parking:getVehicleMetadataWithKey', function(source, cb) cb(false) end)

-- weight of a vehicle's trunk (used by exports['Unique_inventory']:getVehicleWeight)
RegisterServerCallbackSafe('inventory-trunk:getWeight', function(source, cb, plate)
    local key = trunkKey(plate, false)
    if not key then return cb(0) end
    cb(stashWeight(loadStash(key)))
end)

-- standard items stored in a vehicle's trunk, for other resources (e.g. the K9 drug search in esx_uniquejobs)
--   exports['Unique_inventory']:GetTrunkItems(plate)  ->  { {name=..., count=...}, ... }
exports('GetTrunkItems', function(plate)
    local key = trunkKey(plate, false)
    if not key then return {} end
    local out = {}
    for _, it in ipairs(loadStash(key).items) do out[#out + 1] = { name = it.name, count = it.count } end
    return out
end)
