--[[ sun-inventory — bag (worn backpack) storage. ]]

local function bagKey(bagId)
    return 'bag_' .. tostring(bagId)
end

-- Confirms the player actually has this bag (item named 'kif_<bagId>') before
-- letting them touch its storage.
local function ownsBag(xPlayer, bagId)
    local item = xPlayer.getInventoryItem('kif_' .. tostring(bagId))
    return item ~= nil and item.count > 0
end

ESX.RegisterServerCallback('inventory-bag:getInventory', function(source, cb, bagId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ownsBag(xPlayer, bagId) then return cb({ items = {}, weapons = {} }) end
    cb(Inventory.Get(bagKey(bagId)))
end)

RegisterServerEvent('inventory-bag:updateSlot')
AddEventHandler('inventory-bag:updateSlot', function(bagId, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ownsBag(xPlayer, bagId) then return end
    -- Reordering only; nothing authoritative to change with a flat items[] model.
end)

-- Player -> bag
RegisterServerEvent('inventory-bag:put')
AddEventHandler('inventory-bag:put', function(bagId, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ownsBag(xPlayer, bagId) then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end
        local playerItem = xPlayer.getInventoryItem(data.name)
        if not playerItem or playerItem.count < count then return end

        local bag = Inventory.Get(bagKey(bagId))
        xPlayer.removeInventoryItem(data.name, count)
        local found = false
        for _, v in ipairs(bag.items) do
            if v.name == data.name then
                v.count = v.count + count
                found = true
                break
            end
        end
        if not found then
            bag.items[#bag.items + 1] = { name = data.name, count = count }
        end
        Inventory.Save(bagKey(bagId), bag)
    end)
end)

-- Note: the client (modules/bag/client/main.lua) just Wait(500)s and then
-- checks data.data.droppedTo on its OWN copy of the table (set by the
-- drag-drop UI itself) before calling the move handler, so this doesn't
-- need to answer back — it only needs to move the item server-side within
-- that window.
-- Bag -> player
RegisterServerEvent('inventory-bag:get')
AddEventHandler('inventory-bag:get', function(bagId, data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ownsBag(xPlayer, bagId) then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end

        local bag = Inventory.Get(bagKey(bagId))
        for i, v in ipairs(bag.items) do
            if v.name == data.name and v.count >= count then
                if not xPlayer.canCarryItem(data.name, count) then
                    xPlayer.showNotification('You cannot carry that much weight.')
                    return
                end
                v.count = v.count - count
                if v.count <= 0 then table.remove(bag.items, i) end
                xPlayer.addInventoryItem(data.name, count)
                Inventory.Save(bagKey(bagId), bag)
                return
            end
        end
    end)
end)
