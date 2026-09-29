if Config.Inventory ~= 'ps-inventory' then
    return
end

function RegisterStorage(metadata)
    -- This resource does not require stash registration.
end

function RegisterUsableItem(name, cb)
    Core.Functions.CreateUseableItem(name, function(src, item)
        cb(src, item.name, { metadata = item.info })
    end)
end

function GetItem(src, xPlayer, name, data, search)
    if search == 'key' then
        local items = exports['ps-inventory']:GetItemsByName(src, name)
        for k, v in pairs(items) do
            if v.info and v.info.keySerialNumber == data.keySerialNumber then
                return v
            end
        end
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['ps-inventory']:AddItem(src, name, count, nil, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['ps-inventory']:RemoveItem(src, name, count)
end