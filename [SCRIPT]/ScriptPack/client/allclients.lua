local scenarios = {
    'WORLD_VEHICLE_ATTRACTOR',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_BICYCLE_BMX',
    'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
    'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
    'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
    'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
    'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
    'WORLD_VEHICLE_BICYCLE_ROAD',
    'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
    'WORLD_VEHICLE_BIKER',
    'WORLD_VEHICLE_BOAT_IDLE',
    'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BROKEN_DOWN',
    'WORLD_VEHICLE_BUSINESSMEN',
    'WORLD_VEHICLE_HELI_LIFEGUARD',
    'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
    'WORLD_VEHICLE_CONSTRUCTION_SOLO',
    'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
    'WORLD_VEHICLE_DRIVE_SOLO',
    'WORLD_VEHICLE_FIRE_TRUCK',
    'WORLD_VEHICLE_EMPTY',
    'WORLD_VEHICLE_MARIACHI',
    'WORLD_VEHICLE_MECHANIC',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_PARK_PARALLEL',
    'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
    'WORLD_VEHICLE_PASSENGER_EXIT',
    'WORLD_VEHICLE_POLICE_BIKE',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_POLICE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_QUARRY',
    'WORLD_VEHICLE_SALTON',
    'WORLD_VEHICLE_SALTON_DIRT_BIKE',
    'WORLD_VEHICLE_SECURITY_CAR',
    'WORLD_VEHICLE_STREETRACE',
    'WORLD_VEHICLE_TOURBUS',
    'WORLD_VEHICLE_TOURIST',
    'WORLD_VEHICLE_TANDL',
    'WORLD_VEHICLE_TRACTOR',
    'WORLD_VEHICLE_TRACTOR_BEACH',
    'WORLD_VEHICLE_TRUCK_LOGS',
    'WORLD_VEHICLE_TRUCKS_TRAILERS',
    'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
}
local crouched = false
local passengerDriveBy = true
Citizen.CreateThread(function()
	for i, v in pairs(scenarios) do
		SetScenarioTypeEnabled(v, false)
	end
    local playerPed = PlayerPedId()
    local sleep = 1
	while true do
		playerPed = PlayerPedId()
        InvalidateIdleCam()
        N_0x9e4cfff989258472()
        N_0x4757f00bc6323cfe(-1553120962, 0.0)

		SetVehicleDensityMultiplierThisFrame(0.0)
		SetPedDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
		SetGarbageTrucks(false)
		SetRandomBoats(false)
		RemovePeskyVehicles(playerPed, 3000.0)
		DisablePlayerVehicleRewards(playerPed)
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		local x,y,z = table.unpack(GetEntityCoords(playerPed))
		ClearAreaOfCops(x,y,z, 400.0)
        SetCanAttackFriendly(playerPed, true, false)
		NetworkSetFriendlyFireOption(true)
		ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
		RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0)
		DisableVehicleDistantlights(true)
		SetPedPopulationBudget(0)
		SetVehiclePopulationBudget(0)
		SetRandomEventFlag(false)
		Citizen.Wait(sleep)
	end
end)
function RemovePeskyVehicles(playerPed, range)
    local pos = GetEntityCoords(playerPed)
    RemoveVehiclesFromGeneratorsInArea(pos.x - range, pos.y - range, pos.z - range, pos.x + range, pos.y + range, pos.z + range);
end
Citizen.CreateThread(function()
	local sleep = 5
	local playerPed
	local id
	while true do
		Wait(sleep)
		playerPed = PlayerPedId()
		id = PlayerId()
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(id, false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(id, true)
			else
				SetPlayerCanDoDriveBy(id, false)
			end
		end
	end
end)
local isAiming = false
Citizen.CreateThread(function()
    local sleep = 5
    while true do
        sleep = 5
        Citizen.Wait(sleep)
        if isAiming then
            DisableControlAction(0, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 44, true)
            DisableControlAction(1, 142, true)
        else
            sleep = 500
            Citizen.Wait(sleep)
        end
    end
end)
function checkArmed()
    local sleep = 500
    isAiming = IsPedArmed(PlayerPedId(), 4)
    SetTimeout(sleep, checkArmed)
end
checkArmed()
local holdingRight = false
AddEventHandler("onKeyDown", function(key)
    if key == "mouse_right" then
        holdingRight = true
    elseif key == "mouse_left" or key == "r" then
        if not holdingRight then
            DisableControlAction(2, 263, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
        end
    end
end)
AddEventHandler("onKeyUP",function(key)
    if key == "mouse_right" then
        holdingRight = false
    end
end)
Citizen.CreateThread( function()
    local sleep = 5

    while true do
        sleep = 5
        Citizen.Wait(sleep)
		local ped = PlayerPedId()
        if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
            DisableControlAction( 0, 36, true )
            if ( not IsPauseMenuActive() ) then
                if ( IsDisabledControlJustPressed( 0, 36 ) ) then
                    RequestAnimSet( "move_ped_crouched" )
                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
                        sleep = 100
                        Citizen.Wait( sleep )
                    end
                    if ( crouched == true ) then
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                        crouched = true
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
end)

Citizen.CreateThread(function()
    while true do
      InvalidateIdleCam()
      N_0x9e4cfff989258472()
      Wait(10000)
    end
end)

local sound = true
RegisterCommand("hs", function()
    if sound == true then
        sound = false
        ESX.ShowNotification("~r~Hit Sound Disabled!")
    elseif sound == false then
        sound = true
        ESX.ShowNotification("~g~Hit Sound Enabled!")
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
            if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(attacker)) then
                if GetPlayerServerId(PlayerId()) ~= GetPlayerServerId(GetPlayerByEntityID(victim)) then
                    if sound == true then
                        TriggerEvent('InteractSound_CL:PlayOnOne', 'hit', 0.30)
                    end
                end
            end
        end
    end
end)

function GetPlayerByEntityID(id)
    for i=0,255 do
        if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
    end
    return nil
end

local vehWeapons = {
	0x1D073A89,
	0x83BF0278,
	0x5FC3C11,
}

local hasBeenInPoliceVehicle = false
local alreadyHaveWeapon = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if(IsPedInAnyPoliceVehicle(PlayerPedId())) then
			if(not hasBeenInPoliceVehicle) then
				hasBeenInPoliceVehicle = true
			end
		else
			if(hasBeenInPoliceVehicle) then
				for i,k in pairs(vehWeapons) do
					if(not alreadyHaveWeapon[i]) then
						TriggerServerEvent("PoliceVehicleWeaponDeleter:askDropWeapon",k)
					end
				end
				hasBeenInPoliceVehicle = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if(not IsPedInAnyVehicle(PlayerPedId())) then
			for i=1,#vehWeapons do
				if(HasPedGotWeapon(PlayerPedId(), vehWeapons[i], false)==1) then
					alreadyHaveWeapon[i] = true
				else
					alreadyHaveWeapon[i] = false
				end
			end
		end
		Citizen.Wait(5000)
	end

end)

RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
	RemoveWeaponFromPed(PlayerPedId(), wea)
end)

local requestedIpl = {"h4_islandairstrip", "h4_islandairstrip_props", "h4_islandx_mansion", "h4_islandx_mansion_props", "h4_islandx_props", "h4_islandxdock", "h4_islandxdock_props", "h4_islandxdock_props_2", "h4_islandxtower", "h4_islandx_maindock", "h4_islandx_maindock_props", "h4_islandx_maindock_props_2", "h4_IslandX_Mansion_Vault", "h4_islandairstrip_propsb", "h4_beach", "h4_beach_props", "h4_beach_bar_props", "h4_islandx_barrack_props", "h4_islandx_checkpoint", "h4_islandx_checkpoint_props", "h4_islandx_Mansion_Office", "h4_islandx_Mansion_LockUp_01", "h4_islandx_Mansion_LockUp_02", "h4_islandx_Mansion_LockUp_03", "h4_islandairstrip_hangar_props", "h4_IslandX_Mansion_B", "h4_islandairstrip_doorsclosed", "h4_Underwater_Gate_Closed", "h4_mansion_gate_closed", "h4_aa_guns", "h4_IslandX_Mansion_GuardFence", "h4_IslandX_Mansion_Entrance_Fence", "h4_IslandX_Mansion_B_Side_Fence", "h4_IslandX_Mansion_Lights", "h4_islandxcanal_props", "h4_beach_props_party", "h4_islandX_Terrain_props_06_a", "h4_islandX_Terrain_props_06_b", "h4_islandX_Terrain_props_06_c", "h4_islandX_Terrain_props_05_a", "h4_islandX_Terrain_props_05_b", "h4_islandX_Terrain_props_05_c", "h4_islandX_Terrain_props_05_d", "h4_islandX_Terrain_props_05_e", "h4_islandX_Terrain_props_05_f", "H4_islandx_terrain_01", "H4_islandx_terrain_02", "H4_islandx_terrain_03", "H4_islandx_terrain_04", "H4_islandx_terrain_05", "H4_islandx_terrain_06", "h4_ne_ipl_00", "h4_ne_ipl_01", "h4_ne_ipl_02", "h4_ne_ipl_03", "h4_ne_ipl_04", "h4_ne_ipl_05", "h4_ne_ipl_06", "h4_ne_ipl_07", "h4_ne_ipl_08", "h4_ne_ipl_09", "h4_nw_ipl_00", "h4_nw_ipl_01", "h4_nw_ipl_02", "h4_nw_ipl_03", "h4_nw_ipl_04", "h4_nw_ipl_05", "h4_nw_ipl_06", "h4_nw_ipl_07", "h4_nw_ipl_08", "h4_nw_ipl_09", "h4_se_ipl_00", "h4_se_ipl_01", "h4_se_ipl_02", "h4_se_ipl_03", "h4_se_ipl_04", "h4_se_ipl_05", "h4_se_ipl_06", "h4_se_ipl_07", "h4_se_ipl_08", "h4_se_ipl_09", "h4_sw_ipl_00", "h4_sw_ipl_01", "h4_sw_ipl_02", "h4_sw_ipl_03", "h4_sw_ipl_04", "h4_sw_ipl_05", "h4_sw_ipl_06", "h4_sw_ipl_07", "h4_sw_ipl_08", "h4_sw_ipl_09", "h4_islandx_mansion", "h4_islandxtower_veg", "h4_islandx_sea_mines", "h4_islandx", "h4_islandx_barrack_hatch", "h4_islandxdock_water_hatch", "h4_beach_party"}

CreateThread(function()
    for i = #requestedIpl, 1, -1 do
        RequestIpl(requestedIpl[i])
        requestedIpl[i] = nil
    end
    requestedIpl = nil
end)

CreateThread(function()
    while true do
        SetRadarAsExteriorThisFrame()
        SetRadarAsInteriorThisFrame(`h4_fake_islandx`, vec(4700.0, -5145.0), 0, 0)
        Wait(1)
    end
end)

CreateThread(function()
    Wait(2500)
    local islandLoaded = false
    local islandCoords = vector3(4840.571, -5174.425, 2.0)
    SetDeepOceanScaler(0.1)
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        if #(pCoords - islandCoords) < 2000.0 then
            if not islandLoaded then
                islandLoaded = true
                Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 1)
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 1)
				SetScenarioGroupEnabled('Heist_Island_Peds', 1)

				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 1, 1)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', 0, 1)

            end
        else
            if islandLoaded then
                islandLoaded = false
                Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 0)
				Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 0)
				SetScenarioGroupEnabled('Heist_Island_Peds', 0)

				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 0, 0)
				SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', 1, 0)

            end
        end
        Wait(5000)
    end
end)