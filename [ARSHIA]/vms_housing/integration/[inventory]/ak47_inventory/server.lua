if Config.Inventory ~= 'ak47_inventory' then
    return
end

function RegisterStorage(metadata)
    local slots = tonumber(metadata.slots)
    local weight = tonumber(metadata.weight)
    
    if not slots or not weight then
        return
    end

    exports['ak47_inventory']:CreateInventory(metadata.id, {
        label = 'Storage',
        maxWeight = weight,
        slots = slots,
        type = 'stash',
    })
end

function RegisterUsableItem(name, cb)
    if Config.Core == "ESX" then
        Core.RegisterUsableItem(name, function(src, itemName, itemData)
            cb(src, itemName, { metadata = itemData.info })
        end)
    elseif Config.Core == "QB-Core" then
        Core.Functions.CreateUseableItem(name, function(src, item)
            cb(src, item.name, { metadata = item.info })
        end)
    end
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        return exports['ak47_inventory']:GetAmount(src, name, data, true)
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['ak47_inventory']:AddItem(src, name, count, nil, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['ak47_inventory']:RemoveItem(src, name, count)
end