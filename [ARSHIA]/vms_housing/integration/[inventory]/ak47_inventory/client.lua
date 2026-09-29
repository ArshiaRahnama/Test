if Config.Inventory ~= 'ak47_inventory' then
    return
end

function OpenStorage(metadata)
    exports['ak47_inventory']:OpenInventory(metadata.id)
end