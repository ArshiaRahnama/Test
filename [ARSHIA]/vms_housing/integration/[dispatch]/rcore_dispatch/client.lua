if Config.Dispatch ~= 'rcore_dispatch' then
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

    TriggerServerEvent('rcore_dispatch:server:sendAlert', {
        code = '459',
        default_priority = 'high',
        coords = coords,
        job = Config.Alarm.AlarmJobs,
        text = TRANSLATE('notify.lockpick:alarm_' .. type),
        type = 'alerts',
        -- blip_time = 5,
        -- image = 'url_to_image.jpg',
        -- custom_sound = 'url_to_sound.mp3',
        blip = {
            sprite = 480,
            colour = 1,
            scale = 1.0,
            text = 'Burglary',
            flashes = false,
            radius = 20.0,
        }
    })
end