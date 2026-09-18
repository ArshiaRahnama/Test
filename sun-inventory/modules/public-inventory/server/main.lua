--[[
    sun-inventory — public/shared named stash storage.

    This is a generic keyed stash other resources open via the
    `exports.sun-inventory:openInventory(name, owner, label, searchKey)`
    export (see modules/public-inventory/client/main.lua). Because any
    resource on the server can call that export with any `name`, this
    module has no way to know what access rule SHOULD apply to a given
    stash name (a drug-lab table? a shared house chest? a robbery loot
    bag?) — that permission decision belongs to whichever resource opens
    it client-side. This module only guarantees the stash itself is
    consistent (no lost/duped items) once opened.
]]

local function publicKey(name)
    return 'public_' .. tostring(name)
end

ESX.RegisterServerCallback('inventory-public:getInventory', function(source, cb, name, owner)
    cb(Inventory.Get(publicKey(name)))
end)

RegisterServerEvent('inventory-public:updateSlot')
AddEventHandler('inventory-public:updateSlot', function(name, data)
    -- Reordering only; nothing authoritative to change with a flat items[] model.
end)

RegisterServerEvent('inventory-public:put')
AddEventHandler('inventory-public:put', function(name, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end
        local playerItem = xPlayer.getInventoryItem(data.name)
        if not playerItem or playerItem.count < count then return end

        local inv = Inventory.Get(publicKey(name))
        xPlayer.removeInventoryItem(data.name, count)
        local found = false
        for _, v in ipairs(inv.items) do
            if v.name == data.name then
                v.count = v.count + count
                found = true
                break
            end
        end
        if not found then
            inv.items[#inv.items + 1] = { name = data.name, count = count }
        end
        Inventory.Save(publicKey(name), inv)
    end)
end)

RegisterServerEvent('inventory-public:get')
AddEventHandler('inventory-public:get', function(name, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end

        local inv = Inventory.Get(publicKey(name))
        for i, v in ipairs(inv.items) do
            if v.name == data.name and v.count >= count then
                if not xPlayer.canCarryItem(data.name, count) then
                    xPlayer.showNotification('You cannot carry that much weight.')
                    return
                end
                v.count = v.count - count
                if v.count <= 0 then table.remove(inv.items, i) end
                xPlayer.addInventoryItem(data.name, count)
                Inventory.Save(publicKey(name), inv)
                return
            end
        end
    end)
end)
