

ESX.RegisterUsableItem('lockpick', function(source)
    TriggerClientEvent('esx_inventoryhud:closeHud', source)
    Wait(500)
    TriggerClientEvent('esx_lockpick:startlockpick', source)
end)

RegisterNetEvent('esx_lockpick:unlockVehicleWithAlarm')
AddEventHandler('esx_lockpick:unlockVehicleWithAlarm', function(vehicleNetId)





    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local ped = GetPlayerPed(source)

    if DoesEntityExist(vehicle) and ped and ped ~= 0
        and #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) <= 6.0 then
        SetVehicleDoorsLocked(vehicle, 1)
        TriggerClientEvent('esx:showNotification', source, "Dar mashin baz shod.")

        SetVehicleAlarm(vehicle, true)

        TriggerClientEvent('esx_lockpick:startVehicleAlarm', -1, NetworkGetNetworkIdFromEntity(vehicle), 30000)

        local xPlayer = ESX.GetPlayerFromId(source)
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        TriggerEvent('DiscordBot:ToDiscord', 'lockpick', 'VehicleLockpickLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..(xPlayer and xPlayer.identifier or '?')..' ]\n[ Vehicle : '..tostring(model)..' | Plate: '..tostring(plate)..' ]\n[ Method : Lockpick (alarm triggered) ]\n```', 'user', true, source, false)
    else
        TriggerClientEvent('esx:showNotification', source, "Vasile naghlie yaft nashod.")
    end
end)

RegisterNetEvent('esx_lockpick:removeitem')
AddEventHandler('esx_lockpick:removeitem', function()
    local Src = source
    local xPlayer = ESX.GetPlayerFromId(Src)
    xPlayer.removeInventoryItem('lockpick', 1)
end)