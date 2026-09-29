if Config.Inventory ~= 'ox_inventory' then
    return
end

function RegisterStorage(metadata)
    local slots = tonumber(metadata.slots)
    local weight = tonumber(metadata.weight)
    
    if not slots or not weight then
        return
    end

    exports['ox_inventory']:RegisterStash(metadata.id, 'Storage', slots, weight)
end

function RegisterUsableItem(name, cb)
    if Config.Core == "ESX" then
        Core.RegisterUsableItem(name, function(src, itemName, itemData)
            cb(src, itemName, { metadata = itemData.metadata })
        end)
    elseif Config.Core == "QB-Core" then
        Core.Functions.CreateUseableItem(name, function(src, item)
            cb(src, item.name, { metadata = item.metadata })
        end)
    end
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        return exports['ox_inventory']:GetItem(src, name, {keySerialNumber = data.keySerialNumber}, true)
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['ox_inventory']:AddItem(src, name, count, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['ox_inventory']:RemoveItem(src, name, count)
end