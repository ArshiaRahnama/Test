if Config.Inventory ~= 'inventory' then
    return
end

function OpenStorage(metadata)
    TriggerEvent('inventory:openInventory', {
        type = 'stash',
        id = (metadata.id):gsub('-', '_'),
        title = 'Storage',
        weight = metadata.weight,
        delay = 0,
        save = true
    })
end