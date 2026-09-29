if Config.Inventory ~= 'origen_inventory' then
    return
end

function OpenStorage(metadata)
    exports['origen_inventory']:openInventory('stash', metadata.id)
end