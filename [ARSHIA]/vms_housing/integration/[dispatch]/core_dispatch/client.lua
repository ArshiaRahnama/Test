if Config.Dispatch ~= 'core_dispatch' then
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

    TriggerServerEvent("core_dispatch:addCall", 
        "459",                                        --- @code string code of the call (like 10-19)
        "Burglary",                                   --- @message string message in the notification
        { {icon = "fa-venus-mars", info = "male"} },  --- @info table of type {icon= string, info= string }
        {coords.x, coords.y, coords.z},               --- @coords number,number,number coords where the notification is trigger
        'police',                                     --- @job string job who will receive the notification (one at a time)
        5000,                                         --- @time number time duration of the notification in ms
        480,                                          --- @spritenumber Sprite that will be use on the minimap to 
        1,                                            --- @colornumber color use for the blip
        false                                         --- @priority boolean define if the call is priority or not
    )
end