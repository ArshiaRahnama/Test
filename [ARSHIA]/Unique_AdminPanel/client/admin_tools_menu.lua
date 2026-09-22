-- The WarMenu drawing code that used to live here (Select Target, Player
-- Tools, Vehicle/World/Server tools ...) moved to client/menuv_ui.lua, which
-- builds the same menus with MenuV. What's left in this file are the client
-- "Apply*" handlers that the server triggers (freeze, heal, spawn vehicle, ...).

SelectedTargetId = nil
SavedLocationsCache = {}

RegisterNetEvent('Unique_AdminPanel:ApplySlay')
AddEventHandler('Unique_AdminPanel:ApplySlay', function()
    SetEntityHealth(PlayerPedId(), 0)
    drawNotification("~r~You were killed by an admin")
end)

RegisterNetEvent('Unique_AdminPanel:MenuNotify')
AddEventHandler('Unique_AdminPanel:MenuNotify', function(msg)
    drawNotification(msg)
end)

RegisterNetEvent('Unique_AdminPanel:ApplyFreeze')
AddEventHandler('Unique_AdminPanel:ApplyFreeze', function(frozen)
    FreezeEntityPosition(PlayerPedId(), frozen)
    drawNotification(frozen and "~b~You have been frozen by an admin" or "~r~You have been unfrozen")
end)

RegisterNetEvent('Unique_AdminPanel:ApplyHeal')
AddEventHandler('Unique_AdminPanel:ApplyHeal', function()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    drawNotification("~b~You have been healed by an admin")
end)

RegisterNetEvent('Unique_AdminPanel:ApplyRevive')
AddEventHandler('Unique_AdminPanel:ApplyRevive', function()
    FullRevive()
    drawNotification("~b~You have been revived by an admin")
end)

RegisterNetEvent('Unique_AdminPanel:ApplySpawnVehicle')
AddEventHandler('Unique_AdminPanel:ApplySpawnVehicle', function(model, plate)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        Citizen.Wait(10)
        tries = tries + 1
    end
    if not HasModelLoaded(hash) then
        drawNotification("~r~Unknown vehicle model: " .. model)
        return
    end
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleNumberPlateText(veh, plate)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
end)

RegisterNetEvent('Unique_AdminPanel:ApplyVehicleAction')
AddEventHandler('Unique_AdminPanel:ApplyVehicleAction', function(action)
    if action == 'deletenearest' then
        local coords = GetEntityCoords(PlayerPedId())
        local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
        if veh and veh ~= 0 and GetPedInVehicleSeat(veh, -1) == 0 then
            DeleteEntity(veh)
            drawNotification("~b~Nearest empty vehicle deleted")
        else
            drawNotification("~r~No empty vehicle nearby")
        end
        return
    end

    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        drawNotification("~r~You are not in a vehicle")
        return
    end
    local veh = GetVehiclePedIsIn(ped, false)
    if action == 'fix' then
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(veh, true, true, false)
        drawNotification("~b~Vehicle repaired")
    elseif action == 'clean' then
        SetVehicleDirtLevel(veh, 0.0)
        WashDecalsFromVehicle(veh, 1.0)
        drawNotification("~b~Vehicle cleaned")
    end
end)

RegisterNetEvent('Unique_AdminPanel:ApplyImpound')
AddEventHandler('Unique_AdminPanel:ApplyImpound', function(reason, adminName)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(vehicle)
        local internalName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local label = GetLabelText(internalName)
        local modelLabel = (label ~= 'NULL' and label ~= '') and label or internalName

        DeleteEntity(vehicle)
        TriggerServerEvent('Unique_AdminPanel:ImpoundRecorded', plate, modelLabel, reason, adminName)
    end
    drawNotification("~b~Your vehicle has been impounded by an admin" .. (reason and (" - " .. reason) or ""))
end)

RegisterNetEvent('Unique_AdminPanel:ApplyWeather')
AddEventHandler('Unique_AdminPanel:ApplyWeather', function(weatherName)
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(weatherName, 5.0)
    drawNotification("~b~Weather set to " .. weatherName)
end)

RegisterNetEvent('Unique_AdminPanel:ApplyTime')
AddEventHandler('Unique_AdminPanel:ApplyTime', function(hour, minute)
    NetworkOverrideClockTime(tonumber(hour), tonumber(minute), 0)
end)

RegisterNetEvent('Unique_AdminPanel:ApplyTeleportCoords')
AddEventHandler('Unique_AdminPanel:ApplyTeleportCoords', function(x, y, z)
    DoScreenFadeOut(300)
    Citizen.Wait(300)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
    Citizen.Wait(300)
    DoScreenFadeIn(300)
    drawNotification("~b~Teleported")
end)

RegisterNetEvent('Unique_AdminPanel:WarpIntoVehicle')
AddEventHandler('Unique_AdminPanel:WarpIntoVehicle', function(netId, seat)
    local timeout = GetGameTimer() + 3000
    while not NetworkDoesNetworkIdExist(netId) and GetGameTimer() < timeout do Wait(50) end
    if not NetworkDoesNetworkIdExist(netId) then return end
    local veh = NetToVeh(netId)
    if veh and veh ~= 0 and DoesEntityExist(veh) then
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, seat or -2)
    end
end)
