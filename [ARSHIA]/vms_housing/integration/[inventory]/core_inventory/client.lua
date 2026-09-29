if Config.Inventory ~= 'core_inventory' then
    return
end

function OpenStorage(metadata)
    TriggerServerEvent('core_inventory:server:openInventory', metadata.id, 'stash')
end