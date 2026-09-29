if Config.Dispatch ~= 'tk_dispatch' then
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

    exports.tk_dispatch:addCall({
        title = 'Burglary',
        code = '459',
        priority = 'Priority 1',
        coords = coords,
        showLocation = true,
        showGender = false,
        playSound = true,
        blip = {
            sprite = 480,
            color = 1,
            scale = 1.0,
        },
        jobs = Config.Alarm.AlarmJobs
    })
end