if Config.Inventory ~= 'codem-inventory' then
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

end

function AddItem(src, xPlayer, name, count, metadata)
    exports['codem-inventory']:AddItem(src, name, count, nil, metadata)
end

function RemoveItem(src, xPlayer, name, count)
    exports['codem-inventory']:RemoveItem(src, name, count)
end