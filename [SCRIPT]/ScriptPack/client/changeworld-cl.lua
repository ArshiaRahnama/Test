--[[
    Change World System - Final Merged Version (client)
    Pairs with changeworld-sv.lua
]]

-- NOTE: old ESX build (on essentialmode) - must use the event, not exports.
local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

-- ============================================================
-- BASIC EVENT HANDLERS
-- ============================================================

RegisterNetEvent('cw:notify')
AddEventHandler('cw:notify', function(message)
    ESX.ShowNotification(message)
end)

RegisterNetEvent('cw:teleport')
AddEventHandler('cw:teleport', function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, true)
end)

RegisterNetEvent('cw:setArmor')
AddEventHandler('cw:setArmor', function(amount)
    local ped = PlayerPedId()
    TriggerEvent('esx_status:set', 'armor', amount)
    AddArmourToPed(ped, amount)
    ESX.ShowNotification("Armor Shoma Por Shod!")
end)

RegisterNetEvent('cw:setMaxAmmo')
AddEventHandler('cw:setMaxAmmo', function(amount)
    local ped = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(ped)
    if weaponHash ~= `WEAPON_UNARMED` then
        AddAmmoToPed(ped, weaponHash, amount)
        ESX.ShowNotification("Tedad Tir Be Maximom Afzayesh Yaft!")
    else
        ESX.ShowNotification("Shoma Hich Aslahe Darid!")
    end
end)

RegisterNetEvent('cw:doSpawnVehicle')
AddEventHandler('cw:doSpawnVehicle', function(vehicleName)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    ESX.Game.SpawnVehicle(vehicleName, coords, GetEntityHeading(ped), function(vehicle)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
    end)
end)

RegisterNetEvent('cw:doDeleteVehicle')
AddEventHandler('cw:doDeleteVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        ESX.Game.DeleteVehicle(vehicle)
    else
        ESX.ShowNotification("Shoma Dar Hich Mashini Nistid.")
    end
end)

RegisterNetEvent('cw:doTpWaypoint')
AddEventHandler('cw:doTpWaypoint', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        ped = GetVehiclePedIsUsing(ped)
    end

    local waypoint = GetFirstBlipInfoId(8)
    if not DoesBlipExist(waypoint) then
        ESX.ShowNotification("Markeri Baraye Teleport Shodan Vojoud Nadarad!")
        return
    end

    local target = GetBlipInfoIdCoord(waypoint)
    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(ped, target.x, target.y, height + 0.0)
        local found, z = GetGroundZFor_3dCoord(target.x, target.y, height + 0.0)
        if found then
            SetPedCoordsKeepVehicle(ped, target.x, target.y, z)
            break
        end
        Wait(1)
    end
    ESX.ShowNotification("Shoma Be Marker Rooye Map Teleport Shodid!")
end)

-- ============================================================
-- E-KEY LOCK (prevents vehicle entry / interactions while in a world)
-- ============================================================

local eKeyDisabled = false

RegisterNetEvent('cw:disableEKey')
AddEventHandler('cw:disableEKey', function()
    eKeyDisabled = true
end)

RegisterNetEvent('cw:enableEKey')
AddEventHandler('cw:enableEKey', function()
    eKeyDisabled = false
end)

CreateThread(function()
    while true do
        Wait(0)
        if eKeyDisabled then
            DisableControlAction(0, 38, true)  -- E
            DisableControlAction(0, 289, true) -- vehicle enter/exit alt
        end
    end
end)

-- ============================================================
-- IN-WORLD MENU (F11)
-- ============================================================

local function openSelfOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_self', {
        title = "Self Options",
        align = 'top-left',
        elements = {
            { label = "Revive",       value = 'revive' },
            { label = "Full Armor",   value = 'armor' },
            { label = "Max Ammo",     value = 'ammo' },
        }
    }, function(data, menu)
        if data.current.value == 'revive' then
            TriggerServerEvent('cw:revive')
        elseif data.current.value == 'armor' then
            TriggerServerEvent('cw:armor')
        elseif data.current.value == 'ammo' then
            TriggerServerEvent('cw:maxAmmo')
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openVehicleOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_vehicle', {
        title = "Vehicle Options",
        align = 'top-left',
        elements = {
            { label = "Spawn Vehicle",  value = 'spawn' },
            { label = "Delete Vehicle", value = 'delete' },
        }
    }, function(data, menu)
        if data.current.value == 'spawn' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'cw_vehicle_name', {
                title = "Enter Vehicle Name"
            }, function(data2, menu2)
                TriggerServerEvent('cw:spawnVehicle', data2.value)
                menu2.close()
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif data.current.value == 'delete' then
            TriggerServerEvent('cw:deleteVehicle')
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openTeleportOptions()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_teleport', {
        title = "Teleport Options",
        align = 'top-left',
        elements = {
            { label = "Teleport To Waypoint", value = 'waypoint' },
        }
    }, function(data, menu)
        if data.current.value == 'waypoint' then
            TriggerServerEvent('cw:tpWaypoint')
        end
    end, function(data, menu)
        menu.close()
    end)
end

local function openMainMenu()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cw_main', {
        title = "Change World Menu",
        align = 'top-left',
        elements = {
            { label = "Self Options",     value = 'self' },
            { label = "Vehicle Options",  value = 'vehicle' },
            { label = "Teleport Options", value = 'teleport' },
        }
    }, function(data, menu)
        if data.current.value == 'self' then
            openSelfOptions()
        elseif data.current.value == 'vehicle' then
            openVehicleOptions()
        elseif data.current.value == 'teleport' then
            openTeleportOptions()
        end
    end, function(data, menu)
        menu.close()
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 56) then -- F11
            ESX.TriggerServerCallback('cw:menuAccess', function(hasAccess)
                if hasAccess then
                    openMainMenu()
                end
            end)
        end
    end
end)