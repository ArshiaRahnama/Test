--[[
    sun-inventory — admin panel backend.
    Assumes the standard essentialmode `users` table with a JSON
    `inventory` column for the OFFLINE lookup case.
]]

local function isAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin')
end

-- ONLINE target: live-edit their real inventory directly (no separate
-- storage table needed).
ESX.RegisterServerCallback('inventory:admin:getInventory', function(source, cb, target)
    if not isAdmin(source) then return cb({ items = {}, weapons = {} }) end
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xTarget then return cb({ items = {}, weapons = {} }) end
    cb({ items = xTarget.inventory, weapons = xTarget.loadout })
end)

RegisterServerEvent('inventory:admin:put') -- admin -> target
AddEventHandler('inventory:admin:put', function(target, data)
    local source = source
    if not isAdmin(source) then return end
    local xAdmin = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xAdmin or not xTarget then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end
        local adminItem = xAdmin.getInventoryItem(data.name)
        if not adminItem or adminItem.count < count then return end
        if not xTarget.canCarryItem(data.name, count) then return end

        xAdmin.removeInventoryItem(data.name, count)
        xTarget.addInventoryItem(data.name, count)
    end)
end)

RegisterServerEvent('inventory:admin:get') -- target -> admin
AddEventHandler('inventory:admin:get', function(target, data)
    local source = source
    if not isAdmin(source) then return end
    local xAdmin = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(target))
    if not xAdmin or not xTarget then return end

    Inventory.withLock(source, function()
        local count = tonumber(data.count) or 1
        if count <= 0 then return end
        local targetItem = xTarget.getInventoryItem(data.name)
        if not targetItem or targetItem.count < count then return end
        if not xAdmin.canCarryItem(data.name, count) then return end

        xTarget.removeInventoryItem(data.name, count)
        xAdmin.addInventoryItem(data.name, count)
    end)
end)

-- OFFLINE target: identifier is expected to be their license/identifier string.
-- Read-only by design (no offline write path here) since editing an
-- offline player's row directly races with them logging back in mid-edit.
ESX.RegisterServerCallback('inventory:getOfflinePlayerInventory', function(source, cb, identifier)
    if not isAdmin(source) then return cb({ items = {}, weapons = {} }) end
    local result = MySQL.Sync.fetchAll('SELECT inventory FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier })
    if result[1] and result[1].inventory then
        cb({ items = json.decode(result[1].inventory) or {}, weapons = {} })
    else
        cb({ items = {}, weapons = {} })
    end
end)
