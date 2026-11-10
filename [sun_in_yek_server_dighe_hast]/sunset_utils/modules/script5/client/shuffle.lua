-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local disableShuffle = true
local inVehicle = false
local bigmap = false

AddEventHandler('enterVehicle',function(vehicle,iD)
	if not inVehicle then
        inVehicle = true
        CreateThread(function()
            while inVehicle do
                Wait(10)
                if SUN.isPlayerInVehicle and disableShuffle then
                    SetPedConfigFlag(SUN.ped, 184, true)
                    local vehicle = SUN.vehiclePlayerIsIn
                    if GetPedInVehicleSeat(vehicle, 0) == SUN.ped then
                        if GetIsTaskActive(SUN.ped, 165) then
                            SetPedIntoVehicle(SUN.ped, vehicle, 0)
                        end
                        if GetPedInVehicleSeat(vehicle, -1) == 0 then
                            ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ Jahat Neshastan Dar Sandali Ranande')
                            if IsControlPressed(0, 38) and (exports['sunset_utils']:canAccessToVehicle(vehicle) or exports['esx_vehiclecontrol']:HaveAccess(vehicle)) and not (GetEntityRoll(vehicle) > 45.0 or GetEntityRoll(vehicle) < -45.0) then
                                disableShuffle = false
                                SetPedConfigFlag(SUN.ped, 184, false)
                                Wait(5000)
                                disableShuffle = true
                                SetPedConfigFlag(SUN.ped, 184, true)
                            end
                        end
                    else
                        Wait(500)
                    end
                else
                    Wait(500)
                end
            end
        end)

        Citizen.CreateThread(function()
            while inVehicle do
                Citizen.Wait(0)
                local speed = GetEntitySpeed(SUN.ped)
                local kmh = speed * 3.6;
                if kmh > 100 then
                    if bigmap then
                        SetRadarZoomLevelThisFrame(600 + kmh)
                    else
                        SetRadarZoomLevelThisFrame(50 + kmh)
                    end
                end
            end
        end)
        -- Citizen.CreateThread(function()
        --     while inVehicle do
        --         Wait(0)
        --         DisablePlayerVehicleRewards(SUN.PlayerId)
        --     end
        -- end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        DisablePlayerVehicleRewards(SUN.PlayerId)
    end
end)

AddEventHandler('exitVehicle',function(vehicle,iD)
    inVehicle = false
end)


local handsupState = false
local canHandup = true

AddEventHandler('handappstate',function(state)
    canHandup = state
end)

local handupDict = 'missfra1mcs_2_crew_react'
AddEventHandler('onKeyDown', function(key)
    if key == 'space' and (IsControlPressed(0, 25) or IsControlPressed(0, 24)) and canHandup then
        canHandup = false
        Wait(4000)
        canHandup = true
    end
    if key == "x" and ESX.GetPlayerData()['IsDead'] ~= 1 and canHandup and not ESX.GetPlayerData()['isSitting'] and not LocalPlayer.state['noAnim'] then
        ESX.Streaming.RequestAnimDict(handupDict)
		SetCurrentPedWeapon(SUN.ped, SUN.unarmed, true)
        if not handsupState then
            if ESX.isEmoteMenuActive() then
                TaskPlayAnim(SUN.ped, handupDict, "handsup_standing_base", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsupState = true
                Citizen.CreateThread(function()
                    while handsupState do
                        Wait(0)
                        if IsEntityPlayingAnim(SUN.ped, handupDict,"handsup_standing_base", 3) then
                            DisableControlAction(0, 37, true)
                            DisableControlAction(0, 25, true)
                            DisablePlayerFiring(SUN.ped, true)
                        end
                        if handsupState and (IsPedInAnyVehicle(SUN.ped, false) or not IsEntityPlayingAnim(SUN.ped, handupDict, "handsup_standing_base", 3)) then
                            handsupState = false
                            StopEntityAnim(SUN.ped, 'handsup_standing_base', handupDict, -4.0)
                        end
                    end
                end)
            end
        else
            handsupState = false
            ClearPedTasks(SUN.ped)
        end
    end
end)

exports('getHandupState', function()
    return handsupState
end)

AddEventHandler('KeyDown:z',function()
    if bigmap then
        bigmap = false
        ESX.notification('inform', '!نقشه کوچک فعال شد')
    else
        bigmap = true
        ESX.notification('inform', '!نقشه بزرگ فعال شد')
    end
    if bigmap then
        -- Citizen.CreateThread(function()
        --     while bigmap do
        --         Citizen.Wait(0)
                SetBigmapActive(true,false)
        --     end
        -- end)
    else
        SetBigmapActive(false,false)
    end
end)



local HUD_ELEMENTS = {
    HUD = { id = 0, hidden = false },
   HUD_WANTED_STARS = { id = 1, hidden = true },
   HUD_WEAPON_ICON = { id = 2, hidden = true },
   HUD_CASH = { id = 3, hidden = true },
   HUD_MP_CASH = { id = 4, hidden = true },
   HUD_MP_MESSAGE = { id = 5, hidden = true },
   HUD_VEHICLE_NAME = { id = 6, hidden = true },
   HUD_AREA_NAME = { id = 7, hidden = true },
   HUD_VEHICLE_CLASS = { id = 8, hidden = true },
   --HUD_STREET_NAME = { id = 9, hidden = true },
   HUD_FLOATING_HELP_TEXT_1 = { id = 11, hidden = false },
   HUD_FLOATING_HELP_TEXT_2 = { id = 12, hidden = false },
   HUD_CASH_CHANGE = { id = 13, hidden = true },
   --HUD_RETICLE = { id = 14, hidden = FALSE },
   HUD_SUBTITLE_TEXT = { id = 15, hidden = false },
  -- HUD_RADIO_STATIONS = { id = 16, hidden = true },
   HUD_SAVING_GAME = { id = 17, hidden = false },
   HUD_GAME_STREAM = { id = 18, hidden = false },
   HUD_WEAPON_WHEEL = { id = 19, hidden = false },
   HUD_WEAPON_WHEEL_STATS = { id = 20, hidden = true },
   MAX_HUD_COMPONENTS = { id = 21, hidden = false },
   MAX_HUD_WEAPONS = { id = 22, hidden = false },
   MAX_SCRIPTED_HUD_COMPONENTS = { id = 141, hidden = false }
}

local HUD_HIDE_RADAR_ON_FOOT = true

Citizen.CreateThread(function()
   for key, val in pairs(HUD_ELEMENTS) do
       if val.hidden then
           HideHudComponentThisFrame(val.id)
       else
           ShowHudComponentThisFrame(val.id)
       end
   end
end)