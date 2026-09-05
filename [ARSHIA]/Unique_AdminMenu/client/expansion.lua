-- ============================================================================
-- EXPANSION PACK - client side. Mirrors server/expansion.lua.
-- ============================================================================

-- ---------------------------------------------------------------- PLAYER ---

RegisterNetEvent('Unique_AdminMenu:ApplySetHealth')
AddEventHandler('Unique_AdminMenu:ApplySetHealth', function(pct)
    local ped = PlayerPedId()
    SetEntityHealth(ped, math.floor(GetEntityMaxHealth(ped) * (pct / 100)))
    drawNotification(("~b~An admin set your health to %s%%"):format(pct))
end)

RegisterNetEvent('Unique_AdminMenu:ApplySetArmor')
AddEventHandler('Unique_AdminMenu:ApplySetArmor', function(pct)
    SetPedArmour(PlayerPedId(), math.floor(100 * (pct / 100)))
    drawNotification(("~b~An admin set your armor to %s%%"):format(pct))
end)

-- SetEnableHandcuffs is the standard native FiveM police/cuff scripts use:
-- it locks out normal movement/combat controls and plays the cuffed-idle
-- animation on its own, so we don't need to juggle scenarios/anim dicts.
local Cuffed = false
RegisterNetEvent('Unique_AdminMenu:ApplyCuff')
AddEventHandler('Unique_AdminMenu:ApplyCuff', function()
    Cuffed = not Cuffed
    local ped = PlayerPedId()
    SetEnableHandcuffs(ped, Cuffed)
    if Cuffed then
        ClearPedTasksImmediately(ped)
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        drawNotification("~r~You have been cuffed by an admin")
    else
        drawNotification("~b~You have been uncuffed by an admin")
    end
end)

RegisterNetEvent('Unique_AdminMenu:ShowScreenshot')
AddEventHandler('Unique_AdminMenu:ShowScreenshot', function(dataUri, targetName)
    SendNUIMessage({ type = 'screenshot', data = dataUri, name = targetName })
    SetNuiFocus(true, true)
    InAdminNui = true
end)

RegisterNetEvent('Unique_AdminMenu:ApplyGivenVehicle')
AddEventHandler('Unique_AdminMenu:ApplyGivenVehicle', function(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 200 do
        Citizen.Wait(10)
        tries = tries + 1
    end
    if not HasModelLoaded(hash) then
        drawNotification("~r~An admin tried to give you a vehicle, but the model failed to load: " .. model)
        return
    end
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetModelAsNoLongerNeeded(hash)
    drawNotification("~b~An admin gave you a vehicle")
end)

RegisterNetEvent('Unique_AdminMenu:PlayAnnounceSound')
AddEventHandler('Unique_AdminMenu:PlayAnnounceSound', function()
    PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", true)
end)

-- Existing handler in admin_tools_menu.lua only knows fix/clean/deletenearest;
-- this adds the two new nearby-vehicle actions the expansion pack introduces.
RegisterNetEvent('Unique_AdminMenu:ApplyVehicleAction')
AddEventHandler('Unique_AdminMenu:ApplyVehicleAction', function(action)
    if action ~= 'lock' and action ~= 'maxupgrade' then return end

    local coords = GetEntityCoords(PlayerPedId())
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
    if not veh or veh == 0 then
        drawNotification("~r~No vehicle nearby")
        return
    end

    if action == 'lock' then
        local locked = GetVehicleDoorLockStatus(veh) == 2
        SetVehicleDoorsLocked(veh, locked and 1 or 2)
        drawNotification(locked and "~b~Vehicle unlocked" or "~b~Vehicle locked")
    elseif action == 'maxupgrade' then
        SetVehicleModKit(veh, 0)
        for modType = 0, 49 do
            local count = GetNumVehicleMods(veh, modType)
            if count > 0 then SetVehicleMod(veh, modType, count - 1, false) end
        end
        ToggleVehicleMod(veh, 18, true) -- turbo
        SetVehicleWheelType(veh, 7)
        drawNotification("~b~Vehicle fully upgraded")
    end
end)

-- --------------------------------------------------------------- VEHICLE LIST ---

-- A literal server-wide vehicle list would mean scanning every streamed
-- entity on every client and shipping it all to one admin - expensive and
-- laggy. Scanning the local game pool (GetGamePool) is the standard FiveM
-- technique and covers everything actually streamed in around the admin,
-- which is what you'd act on anyway.
function OpenVehicleList()
    local myCoords = GetEntityCoords(PlayerPedId())
    local vehicles = {}
    for _, veh in ipairs(GetGamePool('CVehicle')) do
        if DoesEntityExist(veh) then
            local coords = GetEntityCoords(veh)
            vehicles[#vehicles + 1] = {
                netId = NetworkGetNetworkIdFromEntity(veh),
                model = GetDisplayNameFromVehicleModel(GetEntityModel(veh)),
                plate = GetVehicleNumberPlateText(veh),
                distance = math.floor(#(myCoords - coords)),
                occupied = GetPedInVehicleSeat(veh, -1) ~= 0,
            }
        end
    end
    table.sort(vehicles, function(a, b) return a.distance < b.distance end)

    local topList = {}
    for i = 1, math.min(#vehicles, 40) do topList[i] = vehicles[i] end

    SendNUIMessage({ type = 'vehiclelist', data = topList })
    SetNuiFocus(true, true)
    InAdminNui = true
end

RegisterNUICallback('vehicleListAction', function(payload, cb)
    local netId = tonumber(payload.netId)
    local veh = netId and NetworkGetEntityFromNetworkId(netId)
    if veh and veh ~= 0 and DoesEntityExist(veh) then
        if payload.action == 'teleport' then
            local coords = GetEntityCoords(veh)
            DoScreenFadeOut(200)
            Citizen.Wait(200)
            SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 1.0, false, false, false, true)
            Citizen.Wait(200)
            DoScreenFadeIn(200)
            drawNotification("~b~Teleported to vehicle")
        elseif payload.action == 'delete' then
            DeleteEntity(veh)
            drawNotification("~b~Vehicle deleted")
        end
    else
        drawNotification("~r~That vehicle no longer exists")
    end
    InAdminNui = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- --------------------------------------------------------------- ONLINE / DASHBOARD ---

function OpenOnlinePlayersPanel()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetOnlinePlayers', function(list)
        SendNUIMessage({ type = 'onlineplayers', data = list })
        SetNuiFocus(true, true)
        InAdminNui = true
    end)
end

function OpenNewPlayersPanel()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetNewPlayers', function(list)
        SendNUIMessage({ type = 'onlineplayers', data = { list = list, title = 'New Players' } })
        SetNuiFocus(true, true)
        InAdminNui = true
    end)
end

function OpenDashboardPanel()
    ESX.TriggerServerCallback('Unique_AdminMenu:GetDashboard', function(data)
        if not data then
            drawNotification("~r~Could not load the dashboard")
            return
        end
        SendNUIMessage({ type = 'dashboard', data = data })
        SetNuiFocus(true, true)
        InAdminNui = true
    end)
end

-- ----------------------------------------------------------------- WORLD ---

local TimeFrozen = false
local FrozenHour, FrozenMinute = 12, 0

RegisterNetEvent('Unique_AdminMenu:ApplyFreezeTime')
AddEventHandler('Unique_AdminMenu:ApplyFreezeTime', function(state)
    TimeFrozen = state
    if state then
        FrozenHour, FrozenMinute = GetClockHours(), GetClockMinutes()
    else
        NetworkClearClockTimeOverride()
    end
    drawNotification(state and "~b~Server time has been frozen" or "~b~Server time has resumed")
end)

Citizen.CreateThread(function()
    while true do
        if TimeFrozen then
            NetworkOverrideClockTime(FrozenHour, FrozenMinute, 0)
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

local TrafficLevel = 'normal'
local DensityByLevel = { off = 0.0, low = 0.3, normal = 1.0, high = 2.5 }

RegisterNetEvent('Unique_AdminMenu:ApplyTrafficDensity')
AddEventHandler('Unique_AdminMenu:ApplyTrafficDensity', function(level)
    TrafficLevel = level
    drawNotification("~b~Traffic density set to " .. level)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if TrafficLevel ~= 'normal' then
            local mult = DensityByLevel[TrafficLevel] or 1.0
            SetVehicleDensityMultiplierThisFrame(mult)
            SetPedDensityMultiplierThisFrame(mult)
            SetRandomVehicleDensityMultiplierThisFrame(mult)
            SetParkedVehicleDensityMultiplierThisFrame(mult)
            SetScenarioPedDensityMultiplierThisFrame(mult, mult)
        end
    end
end)

-- ---------------------------------------------------------- LAUNCH ---

RegisterNetEvent('Unique_AdminMenu:ApplyLaunch')
AddEventHandler('Unique_AdminMenu:ApplyLaunch', function()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
    SetEntityVelocity(ped, 0.0, 0.0, 15.0)
    drawNotification("~r~An admin launched you into the air!")
end)

-- ------------------------------------------------------------ GET IN ---
-- Warps the ADMIN into the nearest vehicle's driver seat, kicking out an
-- NPC driver if there is one (never a real player).

function GetIntoNearestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestVehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, 0, 70)

    if not closestVehicle or closestVehicle == 0 then
        drawNotification("~r~No vehicle nearby.")
        return
    end

    local driverPed = GetPedInVehicleSeat(closestVehicle, -1)
    if driverPed ~= 0 and driverPed ~= playerPed then
        if IsPedAPlayer(driverPed) then
            drawNotification("~r~The driver's seat is taken by a player.")
            return
        end
        TaskLeaveVehicle(driverPed, closestVehicle, 0)
        Citizen.Wait(1500)
    end

    TaskWarpPedIntoVehicle(playerPed, closestVehicle, -1)
end

-- --------------------------------------------------------- SET LIVERY ---

function SetCurrentVehicleLivery(livery)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then
        drawNotification("~r~You're not in a vehicle.")
        return
    end
    SetVehicleLivery(vehicle, livery)
    TriggerServerEvent('Unique_AdminMenu:LogClientAction', "set-livery", ("plate: %s | livery: %s"):format(GetVehicleNumberPlateText(vehicle), livery))
end

-- ------------------------------------------------ JAIL / CS PERMISSION ---
-- The server already validated btn_jail/btn_cs (Unique_AdminMenu:RequestJail
-- /RequestCS in server/admin_tools.lua) before sending this back - we still
-- have to be the ones to actually fire arshia_jail:sendto /
-- esx_communityGGservice:sendToCommunityService ourselves, since those
-- events read `source` as "whoever's client triggered this", and only a
-- genuine client->server trigger sets that correctly.

RegisterNetEvent('Unique_AdminMenu:ProceedJail')
AddEventHandler('Unique_AdminMenu:ProceedJail', function(targetId, minutes, reason)
    TriggerServerEvent('arshia_jail:sendto', targetId, 'admin', minutes, reason)
end)

RegisterNetEvent('Unique_AdminMenu:ProceedCS')
AddEventHandler('Unique_AdminMenu:ProceedCS', function(targetId, count, reason)
    TriggerServerEvent('esx_communityGGservice:sendToCommunityService', targetId, count, reason)
end)
