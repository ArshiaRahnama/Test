if Config.Dispatch then
    return
end

function DispatchAlertServer(src, xPlayer, property, type)
    -- type:
    --   'start'
    --   'success'
    --   'failed'
    
    if not property then
        return
    end
    
    local coords = nil
    if property.type == 'mlo' then
        coords = vector3(property.metadata.menu.x, property.metadata.menu.y, property.metadata.menu.z)
    else
        coords = vector3(property.metadata.enter.x, property.metadata.enter.y, property.metadata.enter.z)
    end

    if not coords then
        return
    end

    TriggerClientEvent('vms_housing:cl:dispatchAlert', -1, tostring(property.id), coords, type)
end