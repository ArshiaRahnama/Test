if Config.Inventory ~= 'core_inventory' then
    return
end

function RegisterStorage(metadata)
    -- This resource does not require stash registration.
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
        local items = exports['core_inventory']:getInventory(src)
        for k, v in pairs(items) do
            if v.name == name and v.info and v.info.keySerialNumber == data.keySerialNumber then
                return v
            end
        end
    end
end

function AddItem(src, xPlayer, name, count, metadata)
    exports['core_inventory']:addItem(src, name, count, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['core_inventory']:removeItem(src, name, count)
end