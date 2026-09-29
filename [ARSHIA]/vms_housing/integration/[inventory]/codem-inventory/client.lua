if Config.Inventory ~= 'codem-inventory' then
    return
end

function OpenStorage(metadata)
    TriggerServerEvent('codem-inventory:server:openstash', metadata.id, metadata.slots, metadata.weight, 'Storage')
end