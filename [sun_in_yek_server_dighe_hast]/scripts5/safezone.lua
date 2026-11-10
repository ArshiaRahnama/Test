-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local World = 0
RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world)
	World = world
end)

local inzone = 0
local Disable = false
local noJob = true
local hornActiveJob = {
    wash = true,
    resturan = true,
    carbimeh = true,
}
local freeWeaponJob = {
    fbi = true,
    sheriff = true,
}

ESX = exports['essentialmode']:getObject()

Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1000)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
    if ESX.militaryJobs2[ESX.PlayerData.job.name] then
        Disable = true
    end
    noJob = ESX.PlayerData.job.name == 'nojob' or ESX.PlayerData.job.name:find('off') or hornActiveJob[ESX.PlayerData.job.name]
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	if not ESX.militaryJobs2[ESX.PlayerData.job.name] then
        Disable = false
    else
        Disable = true
    end
    noJob = ESX.PlayerData.job.name == 'nojob' or ESX.PlayerData.job.name:find('off') or hornActiveJob[ESX.PlayerData.job.name]
end)



local zones = {
    -- jobs
    { coords = vec(1360.1, -737.9, 67.21),      radius = 70,    disableSpeedLimit = true, worlds = {0} }, -- MC 1
    { coords = vec(693.4, 568.61, 130.46),      radius = 210,   disableSpeedLimit = false,worlds = {0,90} }, -- MC 2 new
    { coords = vec(1227.91, 2718.15, 38.01),    radius = 45,    disableSpeedLimit = false,worlds = {0} }, -- MC sandy
    { coords = vec(-800.24, -1334.5, 5.0),      radius = 60,    disableSpeedLimit = true, worlds = {0} }, -- TX 2
    { coords = vec(2544.91, -384.8, 92.99),     radius = 120,   disableSpeedLimit = true, worlds = {0} }, -- Fbi new
    { coords = vec(-1870.18, -351.58, 49.22),   radius = 65,    disableSpeedLimit = true, worlds = {0} }, -- MD 2
    { coords = vec(2955.26, 2787.55, 41.43),    radius = 150,   disableSpeedLimit = true, worlds = {0} }, -- minery madan
    { coords = vec(633.11, 3.17, 82.8),         radius = 60,    disableSpeedLimit = true, worlds = {0} }, -- Pd 2
    { coords = vec(-1085.82, -842.61, 4.88),    radius = 70,    disableSpeedLimit = true, worlds = {0} }, -- Pd 5
    { coords = vec(-2064.58, 3138.13, 32.81),   radius = 400,   disableSpeedLimit = true, worlds = {0} }, -- Army

    { coords = vec(-1569.75, 5037.81, 49.56),   radius = 70,    disableSpeedLimit = true, worlds = {0} }, -- PaintBall2
    { coords = vec(-1601, 5151.06, 18.04),      radius = 65,    mute = true, worlds = {0,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30} }, -- PaintBall
    { coords = vec(-3451.93, -3464.14, 466.37), radius = 100,   mute = true }, -- Prison cs 
    { coords = vec(1690.8, 2591.14, 45.97),     radius = 140,   disableSpeedLimit = true, worlds = {0} }, -- prison markazi
    { coords = vec(-122.18, -2022.66, 18.66),   radius = 150,   disableSpeedLimit = true, worlds = {0} }, -- Car Dealer

    -- { coords = vec(187.24, 1162.65, 225.59),    radius = 100,   disableSpeedLimit = true, worlds = {0} }, -- mozayede

    { coords = vec(-1216.78, -1544.5, 4.7),     radius = 100,   disableSpeedLimit = true, worlds = {0} }, -- gym
    { coords = vec(3537.97, 3716.57, 36.46),    radius = 150,   disableSpeedLimit = true, worlds = {0} }, -- opium

    { coords = vec(756.25, -724.83, 28.07),     radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- caffe 03
    { coords = vec(70.94, -1571.35, 29.6),      radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- caffe 04

    { coords = vec(-209.55, -1317.77, 30.89),   radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- ahangari 3
    { coords = vec(1144.04, -778.28, 57.53),    radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- ahangari 4
    { coords = vec(477.24, -1319.95, 29.21),    radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- ahangari 5
    { coords = vec(-1148.21, -2000.89, 13.18),  radius = 30,    disableSpeedLimit = true, worlds = {0} }, -- ahangari 6

    { coords = vec(3895.1, -4703.86, 4.42),     radius = 26,    disableSpeedLimit = true, worlds = {0} }, -- jazire 1
    { coords = vec(5580.52, -5219.09, 14.48),   radius = 26,    disableSpeedLimit = true, worlds = {0} }, -- jazire 2
    { coords = vec(4890.35, -5736.57, 26.35),   radius = 26,    disableSpeedLimit = true, worlds = {0} }, -- jazire 3
    { coords = vec(5478.76, -5847.96, 20.55),   radius = 26,    disableSpeedLimit = true, worlds = {0} }, -- jazire 4
    { coords = vec(5008.28, -5759.91, 16.27),   radius = 60,    disableSpeedLimit = true, worlds = {0} }, -- jazire 5
    { coords = vec(1277.01, -3301.62, 5.9),     radius = 150,   disableSpeedLimit = true, worlds = {0} }, -- jazire exit

    { coords = vec(-1638.19, 192.43, 61.22),    radius = 80,    disableSpeedLimit = true, worlds = {0} }, -- AH 7

    -- robs
    { coords = vec(198.26, 173.83, 105.36),     radius = 180,   disableSpeedLimit = true, worlds = {0} }, -- bank markazi
    { coords = vec(-1090.48, -267.73, 37.74),   radius = 80,    disableSpeedLimit = true, worlds = {0} }, -- bime
    { coords = vec(817.46, -2053.6, 29.36),     radius = 150,   disableSpeedLimit = true, worlds = {0} }, -- flat
    { coords = vec(-1105.8, 4921.74, 216.66),   radius = 100,   disableSpeedLimit = true, worlds = {0} }, -- cargo

    { coords = vec(-132.29, 1047.1, 229.41),    radius = 350,   disableSpeedLimit = true, worlds = {0} }, -- ezafe shahr

    { coords = vec(-1502.32, -2387.7, 13.21),   radius = 300,   disableSpeedLimit = true, worlds = {0} }, -- Airport
    { coords = vec(-1459.35, -3182.17, 13.94),  radius = 700,   disableSpeedLimit = true, worlds = {0} }, -- Airport

    { coords = vec(-500.43, -246.09, 35.74),    radius = 220,   disableSpeedLimit = true, worlds = {0} }, -- Fbi justic - ahangari 1 - caffe 01
    { coords = vec(143.42, -822.04, 30.98),     radius = 500,   disableSpeedLimit = true, worlds = {0} }, -- vasate shahr - Parking jobcenter - justice2 - caffe 02
    { coords = vec(383.77, -1615.32, 29.29),    radius = 100,   disableSpeedLimit = true, worlds = {0} }, -- TX 1
    { coords = vec(1035.54, -1544.18, 28.0),    radius = 300,   disableSpeedLimit = true, worlds = {0} }, -- minery - MD 1
    { coords = vec(-1348.55, -720.19, 24.94),   radius = 200,   disableSpeedLimit = true, worlds = {0} }, -- maze - caffe 05
    { coords = vec(1753.49, 3777.06, 33.94),    radius = 200,   disableSpeedLimit = true, worlds = {0} }, -- farm - Administrative - SH sandy
    { coords = vec(-113.21, 6405.91, 31.46),    radius = 700,   disableSpeedLimit = true, worlds = {0} }, -- farm - paleto ah - caffe 06 - TX 3 - md paleto

    { coords = vec(-606.51, 5134.66, 115.46),   radius = 300,   disableSpeedLimit = true, worlds = {0} }, -- shekar

}



Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for k = 1 , #zones , 1 do
            local distance = #(coords - zones[k].coords)
            if distance < zones[k].radius and inzone == 0 and (not zones[k].worlds or ESX.TableContainsValue(zones[k].worlds, World)) then
                inzone = k
                ESX.SetPlayerData('inNCZ',true)
                if zones[k].mute then
                    TriggerEvent('pma-voice:mutePlayer',true)
                end
            elseif inzone == k and (distance > zones[k].radius or not (not zones[k].worlds or ESX.TableContainsValue(zones[k].worlds, World))) then
                endzone()
                ESX.SetPlayerData('inNCZ',false)
                if zones[k].mute then
                    TriggerEvent('pma-voice:mutePlayer',false)
                end
                SetHornEnabled(GetVehiclePedIsIn(ped, false),true)
            end
            Wait(10)
        end

        Wait(1000)
    end
end)

local active = true
AddEventHandler('safezone:active', function(state)
    active = state
end)

Citizen.CreateThread(function()
    local tazer = `WEAPON_STUNGUN`
    local petrol = `WEAPON_PETROLCAN`
    while true do
        if inzone ~= 0 then
            Wait(1)
            if (not Disable or (not freeWeaponJob[ESX.PlayerData.job.name] and GetSelectedPedWeapon(PlayerPedId()) ~= tazer)) and GetSelectedPedWeapon(PlayerPedId()) ~= petrol and not LocalPlayer.state.globalInBox and active then
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                if not (Disable and IsPedInAnyHeli(PlayerPedId())) then
                    DisableControlAction(0, 25, true) -- Right click
                end
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, 170, true) -- Melee Attack 1
                DisableControlAction(0, 69, true) -- Melee Attack 1
                DisableControlAction(0, 70, true)
                DisableControlAction(0, 92, true)
                if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") and GetSelectedPedWeapon(PlayerPedId()) ~= `OBJECT` then
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
                    --ESX.Alert("No No!", "Shoma nemitavanid dar inja az aslahe estefade konid", 5000, 'error')
                end
            end
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 10.0 and not IsPedInAnyHeli(PlayerPedId()) and not (zones[inzone] and zones[inzone].disableSpeedLimit) then
                if inzone ~= 0 then
                    exports['esx_vehiclecontrol']:setVehicleTempSpeed('safezone', 10.0)
                    --SetHornEnabled(GetVehiclePedIsIn(PlayerPedId()),false)
                end
            end
            if GetVehiclePedIsIn(PlayerPedId()) ~= 0 and noJob then
                SetHornEnabled(GetVehiclePedIsIn(PlayerPedId()),false)
            end
        else
            Wait(1000)
        end
    end
end)

function endzone()
    inzone = 0 
    --TriggerEvent('dpemote:enable',true)
    Wait(1000)
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
        maxSpeed = GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId()),"CHandlingData","fInitialDriveMaxFlatVel")
        exports['esx_vehiclecontrol']:setVehicleTempSpeed('safezone', nil)
    end
end
