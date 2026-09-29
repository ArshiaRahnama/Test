if Config.Inventory ~= 'ox_inventory' then
    return
end

function OpenStorage(metadata)
    exports.ox_inventory:openInventory('stash', {id = metadata.id})
end