

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)



RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(message)
    ESX.ShowNotification(message)
end)



RegisterNetEvent('spawnVehicle')
AddEventHandler('spawnVehicle', function(vehicleName)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    ESX.Game.SpawnVehicle(vehicleName, coords, GetEntityHeading(playerPed), function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    end)
end)

RegisterNetEvent('deleteVehicle')
AddEventHandler('deleteVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        ESX.Game.DeleteVehicle(vehicle)
    else
        ESX.ShowNotification("Shoma Dar Hich Mashini Nistid.")
    end
end)

RegisterNetEvent('teleportPlayer')
AddEventHandler('teleportPlayer', function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
end)

RegisterNetEvent('gpstools:tpwaypointt')
AddEventHandler('gpstools:tpwaypointt', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        playerPed = GetVehiclePedIsUsing(playerPed)
    end

    local waypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(waypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(playerPed, waypointCoords.x, waypointCoords.y, height + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, height + 0.0)
            if foundGround then
                SetPedCoordsKeepVehicle(playerPed, waypointCoords.x, waypointCoords.y, zPos)
                break
            end
            Citizen.Wait(1)
        end

        ESX.ShowNotification("Shoma Be Marker Rojaye Map Teleport Shodid!")
    else
        ESX.ShowNotification("Markeri Baraye Teleport Shodan Vojoud Nadarad!")
    end
end)

RegisterNetEvent('setArmorToFull')
AddEventHandler('setArmorToFull', function()
    local ped = PlayerPedId()
    local armor = 100

    TriggerEvent('esx_status:set', 'armor', armor)

    AddArmourToPed(ped, armor)
end)

RegisterNetEvent('menu:openMainMenu')
AddEventHandler('menu:openMainMenu', function()
    local elements = {
        {label = "Self Options", value = 'self_options'},
        {label = "Vehicle Options", value = 'vehicle_options'},
        {label = "Weapon Options", value = 'weapon_options'},
        {label = "Teleport Options", value = 'teleport_options'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
        title    = "Main Menu",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)

        if data.current.value == 'self_options' then
            showSelfOptions()
        elseif data.current.value == 'vehicle_options' then
            showVehicleOptions()
        elseif data.current.value == 'weapon_options' then
            showWeaponOptions()
        elseif data.current.value == 'teleport_options' then
            showTeleportOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end, false)

function showSelfOptions()
    local elements = {
        {label = "Revive", value = 'revme'},
        {label = "Armor", value = 'armorme'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'self_options_menu', {
        title    = "Self Options",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'revme' then
            ExecuteCommand("revme")
        elseif data.current.value == 'armorme' then
            ExecuteCommand("armorme")
        end
    end, function(data, menu)
        menu.close()
    end)
end

function showVehicleOptions()
    local elements = {
        {label = "Spawn Vehicle", value = 'spawn_vehicle'},
        {label = "Delete Vehicle", value = 'delete_vehicle'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_options_menu', {
        title    = "Vehicle Options",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'spawn_vehicle' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vehicle_name_input', {
                title = "Enter Vehicle Name"
            }, function(data2, menu2)
                local vehicleName = data2.value
                ExecuteCommand("spawn " .. vehicleName)
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'delete_vehicle' then
            ExecuteCommand("dveh")
        end
    end, function(data, menu)
        menu.close()
    end)
end

function showWeaponOptions()
    local elements = {
        {label = "Give Weapon", value = 'give_weapon'},
        {label = "Remove Weapon", value = 'remove_weapon'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_options_menu', {
        title    = "Weapon Options",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'give_weapon' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'weapon_name_input', {
                title = "Enter Weapon Name"
            }, function(data2, menu2)
                local weaponName = data2.value
                ExecuteCommand("giveweapon " .. weaponName)
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'remove_weapon' then
            ExecuteCommand("removewp")
        end
    end, function(data, menu)
        menu.close()
    end)
end

function showTeleportOptions()
    local elements = {
        {label = "Teleport to Waypoint", value = 'teleport_waypoint'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'teleport_options_menu', {
        title    = "Teleport Options",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'teleport_waypoint' then
            ExecuteCommand("ctp")
        end
    end, function(data, menu)
        menu.close()
    end)
end

function showWeaponOptions()
    local elements = {
        {label = "Get Max Ammo", value = 'cgetmaxammo'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_options_menu', {
        title    = "Weapon Options",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'cgetmaxammo' then
            ExecuteCommand("cgetmaxammo")
        end
    end, function(data, menu)
        menu.close()
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 56) then
            ExecuteCommand("openmenu")
        end
    end
end)

RegisterNetEvent('setMaxAmmo')
AddEventHandler('setMaxAmmo', function()
    local playerPed = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(playerPed)

    if weaponHash ~= `WEAPON_UNARMED` then
        AddAmmoToPed(playerPed, weaponHash, 250)
        ESX.ShowNotification("Tedad Tir Be Maximom Afzayesh Yaft!")
    else
        ESX.ShowNotification("Shoma Hich Aslahe Darid!")
    end
end)