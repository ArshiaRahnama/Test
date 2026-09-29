if Config.Dispatch ~= 'lb-tablet' then
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
        coords = vector2(property.metadata.menu.x, property.metadata.menu.y)
    else
        coords = vector2(property.metadata.enter.x, property.metadata.enter.y)
    end

    if not coords then
        return
    end

    local dispatchId = exports["lb-tablet"]:AddDispatch({
        priority = 'high',
        code = '459',
        title = 'Burglary',
        description = TRANSLATE('notify.lockpick:alarm_' .. type),
        location = {
            location = property.address,
            coords = coords,
        },
        time = (20 * 1000),
        job = 'police',
    })
end