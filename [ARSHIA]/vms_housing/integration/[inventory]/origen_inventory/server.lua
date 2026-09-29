if Config.Inventory ~= 'origen_inventory' then
    return
end

function RegisterStorage(metadata)
    local slots = tonumber(metadata.slots)
    local weight = tonumber(metadata.weight)
    
    if not slots or not weight then
        return
    end

    exports['origen_inventory']:registerStash(metadata.id, 'Storage', slots, weight)
end

function RegisterUsableItem(name, cb)
    exports['origen_inventory']:CreateUseableItem(name, function(src, item)
        cb(src, item.name, {metadata = item.metadata})
    end)
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        return exports['origen_inventory']:getItem(src, name, { keySerialNumber = data.keySerialNumber }, true)
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['origen_inventory']:AddItem(src, name, count, nil, nil, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['origen_inventory']:RemoveItem(src, name, count)
end