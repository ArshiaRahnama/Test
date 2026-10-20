--[[ ===========================================================================
    Unique_inventory | server/gang_store.lua

    Why this exists (live crash reported from the server console):
        inventory_main.lua:54  attempt to index a nil value (local 'inventory')
        inventory_main.lua:57  attempt to index a nil value (local 'store')
        inventory_main.lua:480 / 481  same, in gangs:addToInventory

    A gang's chest lives in two shared stores named "gang_<name>":
      * esx_addoninventory  -> standard items   (tables addon_inventory / addon_inventory_items)
      * esx_datastore       -> weapons          (tables datastore / datastore_data)
    Both resources only load the stores that already have a row in
    `addon_inventory` / `datastore` when they start. The seed database ships a
    handful of gang rows (and only `gang_a` in `datastore`), and a gang created
    later from the gang panel never gets a row - so getSharedInventory /
    getSharedDataStore answer nil and everything that touched them crashed.

    EnsureGangStores(gangName) -> inventory, store
      * returns the live stores when they exist
      * otherwise creates the missing DB rows (so it survives a restart), asks
        the two resources to create the in-memory store (their own `addGang`
        events), re-attaches anything already saved in the DB, and returns it
      * returns nil, nil only if the gang name is unusable
=========================================================================== ]]

local function getInventory(name)
    local inv
    TriggerEvent('esx_addoninventory:getSharedInventory', name, function(i) inv = i end)
    return inv
end

local function getStore(name)
    local st
    TriggerEvent('esx_datastore:getSharedDataStore', name, function(s) st = s end)
    return st
end

-- storeName (optional): the chest of ONE specific armory when a gang owns several
-- ('gang_<name>' for the first armory, 'gang_<name>_<key>' for the others)
function EnsureGangStores(gangName, storeName)
    if type(gangName) ~= 'string' or gangName == '' then return nil, nil end
    local name = (type(storeName) == 'string' and storeName ~= '') and string.lower(storeName) or ('gang_' .. string.lower(gangName))

    local inventory = getInventory(name)
    local store = getStore(name)

    if not inventory then
        MySQL.Sync.execute("INSERT IGNORE INTO addon_inventory (name, label, shared) VALUES (@n, 'gang', 1)", { ['@n'] = name })
        TriggerEvent('esx_addoninventory:addGang', name)
        inventory = getInventory(name)
        if inventory then
            -- rows that were already saved for this gang must not be lost / duplicated
            local rows = MySQL.Sync.fetchAll('SELECT name, count FROM addon_inventory_items WHERE inventory_name = @n', { ['@n'] = name }) or {}
            for _, r in ipairs(rows) do
                inventory.items[#inventory.items + 1] = {
                    name = r.name,
                    count = tonumber(r.count) or 0,
                    label = GetCachedItemLabel and GetCachedItemLabel(r.name) or r.name,
                }
            end
        end
    end

    if not store then
        MySQL.Sync.execute("INSERT IGNORE INTO datastore (name, label, shared) VALUES (@n, 'gang', 1)", { ['@n'] = name })
        -- unique key is (name, owner) and owner is NULL here, so MySQL will not dedupe: check first
        local existing = MySQL.Sync.fetchScalar('SELECT data FROM datastore_data WHERE name = @n AND owner IS NULL LIMIT 1', { ['@n'] = name })
        if existing == nil then
            MySQL.Sync.execute("INSERT INTO datastore_data (name, owner, data) VALUES (@n, NULL, '{}')", { ['@n'] = name })
        end
        TriggerEvent('esx_datastore:addGang', name)
        store = getStore(name)
        if store and type(existing) == 'string' and existing ~= '' then
            local ok, decoded = pcall(json.decode, existing)
            if ok and type(decoded) == 'table' then
                for k, v in pairs(decoded) do store.data[k] = v end
            end
        end
    end

    return inventory, store
end

-------------------------------------------------------------------------
-- EXPORTS: put things straight into a gang's armory chest (used by
-- Unique_ALLGangs' Territory capture reward). storeName is optional; by
-- default the gang's first armory ("gang_<n>").
--   exports['Unique_inventory']:AddGangArmoryItem(gangName, itemName, count [, storeName])
--   exports['Unique_inventory']:AddGangArmoryWeapon(gangName, weaponName, count [, storeName])
-- Both return true on success, or false + a reason. Neither ever throws.
-------------------------------------------------------------------------
exports('AddGangArmoryItem', function(gangName, itemName, count, storeName)
    count = math.floor(tonumber(count) or 0)
    if type(itemName) ~= 'string' or itemName == '' or count <= 0 then return false, 'bad item/count' end
    local ok, inventory = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not inventory then return false, 'gang store unavailable' end
    inventory.addItem(itemName, count)
    return true
end)

-- Same weapon bookkeeping as the in-game "put weapon" handler (gangs:addToInventory):
-- one entry per weapon name, stacked with `count`.
exports('AddGangArmoryWeapon', function(gangName, weaponName, count, storeName)
    count = math.floor(tonumber(count) or 0)
    if type(weaponName) ~= 'string' or weaponName == '' or count <= 0 then return false, 'bad weapon/count' end
    local ok, _, store = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not store then return false, 'gang store unavailable' end
    local upper = string.upper(weaponName)
    local weapons = store.get('weapons') or {}
    local found = false
    for i = 1, #weapons do
        if string.upper(weapons[i].name) == upper then
            weapons[i].count = (tonumber(weapons[i].count or weapons[i].ammo) or 0) + count
            weapons[i].ammo = nil
            found = true
            break
        end
    end
    if not found then table.insert(weapons, { name = upper, count = count }) end
    store.set('weapons', weapons)
    return true
end)

-- How many of an item the gang armory holds (0 when the store/item is missing).
--   exports['Unique_inventory']:GetGangArmoryItemCount(gangName, itemName [, storeName])
exports('GetGangArmoryItemCount', function(gangName, itemName, storeName)
    if type(itemName) ~= 'string' or itemName == '' then return 0 end
    local ok, inventory = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not inventory then return 0 end
    local item = inventory.getItem(itemName)
    return item and tonumber(item.count) or 0
end)

-- Take items out of the armory. All-or-nothing: returns false (and removes nothing)
-- when the armory doesn't hold enough.
--   exports['Unique_inventory']:RemoveGangArmoryItem(gangName, itemName, count [, storeName])
exports('RemoveGangArmoryItem', function(gangName, itemName, count, storeName)
    count = math.floor(tonumber(count) or 0)
    if type(itemName) ~= 'string' or itemName == '' or count <= 0 then return false end
    local ok, inventory = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not inventory then return false end
    local item = inventory.getItem(itemName)
    if not item or (tonumber(item.count) or 0) < count then return false end
    inventory.removeItem(itemName, count)
    return true
end)

-- Take weapons out of the gang armory (used by the gun shop stock and zone armory).
--   exports['Unique_inventory']:RemoveGangArmoryWeapon(gangName, weaponName, count [, storeName])
-- All-or-nothing: returns false and removes nothing when the armory holds fewer.
exports('RemoveGangArmoryWeapon', function(gangName, weaponName, count, storeName)
    count = math.floor(tonumber(count) or 0)
    if type(weaponName) ~= 'string' or weaponName == '' or count <= 0 then return false end
    local ok, _, store = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not store then return false end
    local upper = string.upper(weaponName)
    local weapons = store.get('weapons') or {}
    for i = 1, #weapons do
        if string.upper(weapons[i].name) == upper then
            local have = tonumber(weapons[i].count or weapons[i].ammo) or 0
            if have < count then return false end
            weapons[i].count = have - count
            weapons[i].ammo = nil
            if weapons[i].count <= 0 then table.remove(weapons, i) end
            store.set('weapons', weapons)
            return true
        end
    end
    return false
end)

-- Full list of a gang armory (for the zone armory screen).
--   exports['Unique_inventory']:GetGangArmoryContents(gangName [, storeName])
--   -> { items = { {name, count}, ... }, weapons = { {name, count}, ... } }
exports('GetGangArmoryContents', function(gangName, storeName)
    local out = { items = {}, weapons = {} }
    local ok, inventory, store = pcall(EnsureGangStores, gangName, storeName)
    if not ok or not inventory then return out end
    for _, it in ipairs(inventory.items or {}) do
        if (tonumber(it.count) or 0) > 0 then out.items[#out.items + 1] = { name = it.name, count = tonumber(it.count) } end
    end
    local weapons = (store and store.get('weapons')) or {}
    for _, w in ipairs(weapons) do
        local n = tonumber(w.count or w.ammo) or 0
        if n > 0 then out.weapons[#out.weapons + 1] = { name = string.upper(w.name), count = n } end
    end
    return out
end)
