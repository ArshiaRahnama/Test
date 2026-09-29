if Config.Dispatch ~= 'qs-dispatch' then
    return
end

function DispatchAlertClient(property, type)
    local coords = nil
    if property.type == 'mlo' then
        coords = vector3(property.metadata.menu.x, property.metadata.menu.y, property.metadata.menu.z)
    else
        coords = vector3(property.metadata.enter.x, property.metadata.enter.y, property.metadata.enter.z)
    end

    if not coords then
        return
    end

    TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
        job = Config.Alarm.AlarmJobs,
        callLocation = coords,
        callCode = {code = '459', snippet = 'Burglary'},
        message = TRANSLATE('notify.lockpick:alarm_' .. type),
        flashes = false,
        blip = {
            sprite = 480,
            scale = 1.0,
            colour = 1,
            flashes = true,
            text = 'Burglary',
            time = (20 * 1000),
        },
    })
end