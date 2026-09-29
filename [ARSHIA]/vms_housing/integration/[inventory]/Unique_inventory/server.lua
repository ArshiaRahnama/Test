-- VMS Housing - Unique_inventory integration (ArshiaRahnama/Test server)
if Config.Inventory ~= 'Unique_inventory' then return end

function RegisterStorage(metadata)
    -- Unique_inventory uses ESX stashes internally, no extra registration
end

function RegisterUsableItem(name, cb)
    Core.RegisterUsableItem(name, function(src, itemName)
        local xPlayer = Core.GetPlayerFromId(src)
        cb(src, xPlayer, itemName)
    end)
end

function GetItem(src, xPlayer, name, data, search)
    if not xPlayer then return nil end
    local item = xPlayer.getInventoryItem(name)
    if search == 'count' then return item and item.count or 0 end
    return item
end

function AddItem(src, xPlayer, name, count, metadata)
    if xPlayer then xPlayer.addInventoryItem(name, count) end
end

function RemoveItem(src, xPlayer, name, count)
    if xPlayer then xPlayer.removeInventoryItem(name, count) end
end
