if Config.Inventory ~= 'ps-inventory' then
    return
end

function OpenStorage(metadata)
    TriggerServerEvent('ps-inventory:server:OpenInventory', 'stash', metadata.id, { maxweight = metadata.weight, slots = metadata.slots })
    TriggerEvent('ps-inventory:client:SetCurrentStash', metadata.id)
end