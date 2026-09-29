if Config.Inventory ~= 'qb-inventory' then
    return
end

function RegisterStorage(metadata)
    local slots = tonumber(metadata.slots)
    local weight = tonumber(metadata.weight)
    
    if not slots or not weight then
        return
    end

    exports['qb-inventory']:CreateInventory(metadata.id, {
        label = 'Storage',
        slots = slots,
        weight = weight,
    })
end

RegisterNetEvent('vms_housing:qb-inventory:openStorage', function(id)
    local src = source

    if not id or not string.find(id, "house_storage") then
        return
    end

    exports['qb-inventory']:OpenInventory(src, id)
end)

function RegisterUsableItem(name, cb)
    Core.Functions.CreateUseableItem(name, function(src, item)
        cb(src, item.name, {metadata = item.info})
    end)
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        local items = exports['qb-inventory']:GetItemsByName(src, name)
        for k, v in pairs(items) do
            if v.info and v.info.keySerialNumber == data.keySerialNumber then
                return v
            end
        end
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['qb-inventory']:AddItem(src, name, count, false, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['qb-inventory']:RemoveItem(src, name, count)
end