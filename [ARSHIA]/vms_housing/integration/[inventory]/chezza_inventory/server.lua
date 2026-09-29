if Config.Inventory ~= 'inventory' then
    return
end

function RegisterStorage(metadata)
    -- This resource does not require stash registration.
end

function RegisterUsableItem(name, cb)
    Core.RegisterUsableItem(name, function(src, itemName)
        cb(src, itemName)
    end)
end

function GetItem(src, xPlayer, name, data, search)
    -- Chezza Inventory does not have metadata.
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['inventory']:AddItemToPlayer(src, name, count, nil, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['inventory']:RemoveItemFromPlayer(src, name, count)
end