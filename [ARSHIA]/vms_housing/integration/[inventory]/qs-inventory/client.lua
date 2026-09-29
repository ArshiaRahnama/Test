if Config.Inventory ~= 'qs-inventory' then
    return
end

function OpenStorage(metadata)
    local id = metadata.id
    local formattedId = string.gsub(id, "-", "_")

    TriggerServerEvent("inventory:server:OpenInventory", "stash", formattedId, {
        maxweight = metadata.weight,
        slots = metadata.slots
    })
    TriggerEvent("inventory:client:SetCurrentStash", formattedId)
end