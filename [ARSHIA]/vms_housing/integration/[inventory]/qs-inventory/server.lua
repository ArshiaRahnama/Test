if Config.Inventory ~= 'qs-inventory' then
    return
end

function RegisterStorage(metadata)
    -- This resource does not require stash registration.
end

function RegisterUsableItem(name, cb)
    exports['qs-inventory']:CreateUsableItem(name, function(src, item)
        cb(src, item.name, {metadata = item.info})
    end)
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        local items = exports['qs-inventory']:GetInventory(src)
        for k, v in pairs(items) do
            if v.name == name and v.info and v.info.keySerialNumber == data.keySerialNumber then
                return v
            end
        end
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['qs-inventory']:AddItem(src, name, count, false, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['qs-inventory']:RemoveItem(src, name, count)
end