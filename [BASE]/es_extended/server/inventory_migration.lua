--[[
    One-time migration: old essentialmode addon_inventory (gang armories) and
    owned_properties (property storage) -> ox_inventory stashes.

    Safe to run every resource start: it only creates a stash entry in the
    `ox_inventory` table if one doesn't already exist for that owner/name,
    so it never overwrites data a second time.
]]

local function stashExists(owner, name)
    local row = MySQL.scalar.await('SELECT 1 FROM ox_inventory WHERE owner = ? AND name = ?', { owner, name })
    return row ~= nil
end

local function createOxStash(owner, name, items)
    -- ox_inventory's own `data` format: { {slot=1, name=..., count=...}, ... }
    local slot = 0
    local data = {}

    for _, it in ipairs(items) do
        if it.count and it.count > 0 then
            slot = slot + 1
            data[slot] = { slot = slot, name = it.name, count = it.count }
        end
    end

    MySQL.insert('INSERT INTO ox_inventory (owner, name, data) VALUES (?, ?, ?)', {
        owner, name, json.encode(data)
    })
end

CreateThread(function()
    -- es_extended now intentionally starts BEFORE ox_inventory (so ox_inventory's
    -- own bridge can grab our getSharedObject export). That means we have to wait
    -- for ox_inventory to actually be up before we can call its RegisterStash export.
    while GetResourceState('ox_inventory') ~= 'started' do
        Wait(250)
    end

    Wait(1000) -- let ox_inventory finish creating its own `ox_inventory` table

    -- ===== Gang armories (addon_inventory_items where inventory_name = 'gang_*') =====
    local gangRows = MySQL.query.await(
        "SELECT inventory_name, name, count FROM addon_inventory_items WHERE inventory_name LIKE 'gang\\_%'", {}
    )

    if gangRows and #gangRows > 0 then
        local byGang = {}
        for _, row in ipairs(gangRows) do
            byGang[row.inventory_name] = byGang[row.inventory_name] or {}
            table.insert(byGang[row.inventory_name], { name = row.name, count = row.count })
        end

        for gangAccount, items in pairs(byGang) do
            local stashName = gangAccount -- e.g. 'gang_a'
            if not stashExists(false, stashName) then
                createOxStash(false, stashName, items)
                print(('[inventory_migration] Migrated gang armory "%s" into ox_inventory.'):format(gangAccount))
            end

            exports.ox_inventory:RegisterStash(stashName, 'Gang Armory', 50, 200000, false)
        end
    end

    -- Always register a stash for every gang, even ones with no armory items yet
    local allGangAccounts = MySQL.query.await("SELECT name, label FROM addon_inventory WHERE name LIKE 'gang\\_%'", {})
    if allGangAccounts then
        for _, acc in ipairs(allGangAccounts) do
            exports.ox_inventory:RegisterStash(acc.name, acc.label or acc.name, 50, 200000, false)
        end
    end

    -- ===== Owned properties (addon_inventory_items where inventory_name = 'property', keyed by owner identifier) =====
    local owners = MySQL.query.await('SELECT DISTINCT owner FROM addon_inventory_items WHERE inventory_name = ?', { 'property' }) or {}
    local ownersFromProps = MySQL.query.await('SELECT DISTINCT owner FROM owned_properties WHERE owner IS NOT NULL', {}) or {}
    local seen = {}
    for _, r in ipairs(owners) do seen[r.owner] = true end
    for _, r in ipairs(ownersFromProps) do seen[r.owner] = true end

    for identifier in pairs(seen) do
        local stashName = 'property_' .. identifier

        if not stashExists(identifier, stashName) then
            local items = MySQL.query.await(
                'SELECT name, count FROM addon_inventory_items WHERE inventory_name = ? AND owner = ?',
                { 'property', identifier }
            ) or {}

            createOxStash(identifier, stashName, items)
            print(('[inventory_migration] Migrated property storage (owner %s) into ox_inventory.'):format(identifier))
        end

        exports.ox_inventory:RegisterStash(stashName, 'Property Storage', 40, 100000, identifier)
    end

    print('^2[inventory_migration] Gang & property stashes ready in ox_inventory.^0')
end)
