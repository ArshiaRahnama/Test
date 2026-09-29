if Config.Inventory ~= 'qb-inventory' then
    return
end

function OpenStorage(metadata)
    TriggerServerEvent('vms_housing:qb-inventory:openStorage', metadata.id, {
        maxweight = metadata.weight,
        slots = metadata.slots
    })
end