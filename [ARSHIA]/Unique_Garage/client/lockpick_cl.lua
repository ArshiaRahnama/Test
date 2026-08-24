

function getClosestVehicle(coords)
    local vehicles = ESX.Game.GetVehiclesInArea(coords, 5.0)
    local closestVehicle, closestDistance = nil, 1000

    for _, vehicle in ipairs(vehicles) do
        local distance = #(coords - GetEntityCoords(vehicle))
        if distance < closestDistance then
            closestVehicle, closestDistance = vehicle, distance
        end
    end

    return closestVehicle
end

RegisterNetEvent('esx_lockpick:startlockpick')
AddEventHandler('esx_lockpick:startlockpick', function()
    Citizen.Wait(1000)

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = getClosestVehicle(coords)

    if vehicle == nil or vehicle == 0 then
        SafeNotify("Vasile naghlie dar nazdiki shoma yaft nashod.")
        return
    end

    local doorStatus = GetVehicleDoorLockStatus(vehicle)
    if doorStatus == 1 then
        SafeNotify("Darbe mashin baz ast.")
        return
    end

    RequestAnimDict("anim@heists@prison_heiststation@cop_reactions")
    while not HasAnimDictLoaded("anim@heists@prison_heiststation@cop_reactions") do
        Citizen.Wait(10)
    end

    TaskPlayAnim(playerPed, "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    local success = lib.skillCheck(
        {'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'},
        {'w', 'a', 's', 'd'}
    )

    ClearPedTasks(playerPed)

    if success then
        SafeNotify("Mini-game movaffaghiat amiz bood! Darbe mashin baz shod.")
        TriggerServerEvent('esx_lockpick:unlockVehicleWithAlarm', NetworkGetNetworkIdFromEntity(vehicle))
    else
        local Random = math.random(0, 2)
        SafeNotify("Mini-game movaffagh nashod! Darbe mashin baz nashod.")
        if Random == 2 then
            TriggerServerEvent('esx_lockpick:removeitem')
        end
    end

    RemoveAnimDict("anim@heists@prison_heiststation@cop_reactions")
end)

RegisterNetEvent('esx_lockpick:startVehicleAlarm')
AddEventHandler('esx_lockpick:startVehicleAlarm', function(vehicleNetId, duration)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleAlarm(vehicle, true)

        Citizen.CreateThread(function()
            local endTime = GetGameTimer() + duration
            while GetGameTimer() < endTime do
                StartVehicleAlarm(vehicle)
                Citizen.Wait(2000)
            end
            SetVehicleAlarm(vehicle, false)
        end)
    end
end)