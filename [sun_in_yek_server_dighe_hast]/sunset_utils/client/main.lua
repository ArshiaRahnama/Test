-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
World = 0
SUN.SendAssAlarm = false
SUN.World, SUN.world = 0, 0
Citizen.CreateThread(function()
	local OBJ = nil
    while OBJ == nil do
		TriggerEvent('esx:getSharedObject', function(obj) OBJ = obj end)
		Citizen.Wait(50)
	end

	while OBJ.GetPlayerData().job == nil or OBJ.GetPlayerData().gang == nil do
		Citizen.Wait(50)
	end

	ESX = OBJ

	ESX.PlayerData = ESX.GetPlayerData()
	SUN.serverTest = GetConvarInt('serverTest', 0) == 1
	ESX.SetPlayerState('gang', ESX.PlayerData.gang.name ~= 'nogang' and ESX.PlayerData.gang.name or nil)
	ESX.SetPlayerState('job', ESX.PlayerData.job.name ~= 'nojob' and ESX.PlayerData.job.name or nil)
	ESX.SetPlayerState('rawId', ESX.GetPlayerData().rawid)
	ESX.SetPlayerState('name2', ESX.GetPlayerData().name2)
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
	ESX.SetPlayerState('job', ESX.PlayerData.job.name ~= 'nojob' and ESX.PlayerData.job.name or nil)
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
	ESX.SetPlayerState('gang', ESX.PlayerData.gang.name ~= 'nogang' and ESX.PlayerData.gang.name or nil)
end)

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(_)
	World = _
	SUN.World = _
	SUN.world = _
	ESX.PlayerData.World = _
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	SUN.identifier = xPlayer.identifier
	if SUN.admin == nil then
		SUN.admin = xPlayer.permission_level ~= 0
	end
	SUN.permission = xPlayer.permission_level
end)

local hasLicense = false
Citizen.CreateThreadNow(function()
	local lastInWater = nil
	SUN.src = GetPlayerServerId(PlayerId())
	local unarmed = `weapon_unarmed`
	SetFlashLightKeepOnWhileMoving(true)
	SUN.unarmed = unarmed
    while true do
		SUN.PlayerPedId = PlayerPedId()
		SUN.ped = SUN.PlayerPedId
		SUN.PlayerId = PlayerId()
		SUN.PlayerCoords = GetEntityCoords(SUN.PlayerPedId)
		SUN.PlayerIsInVehicle = IsPedInAnyVehicle(SUN.PlayerPedId)
		SUN.isPlayerInVehicle = SUN.PlayerIsInVehicle
		SUN.VehiclePlayerIsIn = GetVehiclePedIsIn(SUN.PlayerPedId, false)
		SUN.vehiclePlayerIsIn = SUN.VehiclePlayerIsIn
		SUN.vehicleClass = GetVehicleClass(SUN.vehiclePlayerIsIn) or 0
		SUN.PlayerIsDriver = GetPedInVehicleSeat(SUN.VehiclePlayerIsIn, -1) == SUN.PlayerPedId
		SUN.IsPlayerShooting = IsPedShooting(SUN.PlayerPedId)
		SUN.CurrentWeaponModel = GetSelectedPedWeapon(SUN.PlayerPedId)
		SUN.isArmed = SUN.CurrentWeaponModel ~= unarmed
		SUN.isFirstPerson = GetFollowPedCamViewMode() == 4
		if IsUsingKeyboard() == false then
			--if not SUN.SendAssAlarm then
			--	SUN.SendAssAlarm = true
				--TriggerServerEvent("sc:adminalarm",'Using aim assist')
			--end
			SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
		end
		if lastInWater ~= SUN.isPlayerInWater then 
			lastInWater = SUN.isPlayerInWater
			LocalPlayer.state.isPlayerInWater = SUN.isPlayerInWater
		end
		Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(0)
		if SUN.CurrentWeaponModel ~= -1569615261 then
        	SetPlayerLockon(PlayerId(), false)
        else
        	SetPlayerLockon(PlayerId(), true)
		end
	end
end)

local StartTime, OSServerTime
Citizen.CreateThread(function()
    while not ESX do Citizen.Wait(50) end
    ESX.TriggerServerCallback('sunset_utils:getOSTime', function(osTime)
        OSServerTime = osTime
        StartTime = GetGameTimer()
		Wait(1000)
		SUN.serverTimeReady = true
    end)
	ESX.TriggerServerCallback('sunset_utils:getFighLicense', function(has)
        hasLicense = has
    end)
	ESX.RegisterCommand('mark', function(src, args)
		local x, y = tonumber(args[1]), tonumber(args[2])
		if x and y then
			SetNewWaypoint(x + .0, y + .0)
		end
	end, {help = 'Mark X Y', args = {{name = 'X', help = 'X'}, {name = 'Y', help = 'Y'}}})
end)

RegisterNetEvent('sunset_utils:hasLicense',function(value)
	hasLicense = value
end)

RegisterNetEvent('reloadrich',function(_,time)
	OSServerTime = time
	StartTime = GetGameTimer()
end)

--main disable action
Citizen.CreateThread(function()
	SetPlayerCanUseCover(PlayerId(), false)
    while true do
        Citizen.Wait(0)
		DisableControlAction(1, 140, true)
		DisableControlAction(1, 44, true)
    end
end)

-- function GetServerOSTime()
--     if not OSServerTime then return nil end
-- 	return OSServerTime + math.floor((GetGameTimer() - StartTime)/1000)
-- end
local resourceList = {}
function GetServerOSTime()
    if OSServerTime == nil or StartTime == nil or not SUN.serverTimeReady then Citizen.Wait(100) end
	while StartTime == nil do
		Wait(100)
		StartTime = GetGameTimer()
	end
	-- if resourceList == {} then
	-- 	for i = 0, GetNumResources(), 1 do
	-- 		local resource_name = GetResourceByFindIndex(i)
	-- 		if resource_name and GetResourceState(resource_name) == "started" then
	-- 			resourceList[resource_name] = true
	-- 		end
	-- 	end
	-- end
	-- local resource = GetInvokingResource()
	-- if resource ~= nil and not resourceList[resource] then return nil end
	return OSServerTime + math.floor((GetGameTimer() - StartTime)/1000)
end

function alarm(Reason)
    TriggerServerEvent("sc:adminalarm",Reason)
end

function alarm2(Reason)
    TriggerServerEvent("suncore:alarm2",Reason)
end

--all client
	

local holdingRight = false
AddEventHandler("onKeyDown", function(key)
	if key == "mouse_right" then
		holdingRight = true
		SUN.isAiming = true
	elseif key == "mouse_left" or key == "r" then
		if not holdingRight then
			DisableControlAction(2, 263, true) -- R attack
			DisableControlAction(2, 257, true) -- Left click mouse attack
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
		end
	end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "mouse_right" then
		holdingRight = false
		SUN.isAiming = false
	end
end)

local crouched = false
local lastPress = 0
local isPressing = false
local crouchDisable = false
AddEventHandler('crouch:disable', function(state)
	crouchDisable = state
end)

AddEventHandler("onKeyDown", function(key)
	if key == "lcontrol" and ESX.GetPlayerData()['IsDead'] ~= 1 and not crouchDisable then
        DisableControlAction(0,36,true)
        isPressing = true
        disableAction()

		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedJumping(ped) and not IsPedFalling(ped) and ESX.GetPlayerData()['IsDead'] ~= 1 then

            
            RequestAnimSet( "move_ped_crouched" )

            while not HasAnimSetLoaded("move_ped_crouched") do 
                Citizen.Wait(100)
            end 

            if crouched then 
                crouched = false 
                ResetPedMovementClipset(ped, 0)
            elseif crouched == false then
                crouched = true 
                SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
            end

		end
    end
end)

AddEventHandler("onKeyUP", function(key)
    if key == "lcontrol" and isPressing then
        isPressing = false
	end
end)

function disableAction()
    Citizen.CreateThread(function()
        while isPressing do
            Citizen.Wait(5)
            DisableControlAction(0,36,true)
        end
    end)
end

AddEventHandler('enterVehicle',function(veh,isDriver)
	if isDriver then
		SetPlayerCanDoDriveBy(PlayerId(), false)
	end
end)

AddEventHandler('exitVehicle',function(veh,isDriver)
	SetPlayerCanDoDriveBy(PlayerId(), true)
end)

--no r key
local isAiming = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5) -- A Short Daily of 5 MS
		if isAiming then
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		else
			Citizen.Wait(500)
		end
		if GetPedStealthMovement(SUN.ped) then
			SetPedStealthMovement(SUN.ped, false, 'DEFAULT_ACTION')
		end
	end
end)

function checkArmed()
	isAiming = IsPedArmed(PlayerPedId(), 4)
	SetTimeout(500, checkArmed)
end
checkArmed()


local pickupList = {
	"PICKUP_AMMO_BULLET_MP",
	"PICKUP_AMMO_FIREWORK",
	"PICKUP_AMMO_FLAREGUN",
	"PICKUP_AMMO_GRENADELAUNCHER",
	"PICKUP_AMMO_GRENADELAUNCHER_MP",
	"PICKUP_AMMO_HOMINGLAUNCHER",
	"PICKUP_AMMO_MG",
	"PICKUP_AMMO_MINIGUN",
	"PICKUP_AMMO_MISSILE_MP",
	"PICKUP_AMMO_PISTOL",
	"PICKUP_AMMO_RIFLE",
	"PICKUP_AMMO_RPG",
	"PICKUP_AMMO_SHOTGUN",
	"PICKUP_AMMO_SMG",
	"PICKUP_AMMO_SNIPER",
	"PICKUP_ARMOUR_STANDARD",
	"PICKUP_CAMERA",
	"PICKUP_CUSTOM_SCRIPT",
	"PICKUP_GANG_ATTACK_MONEY",
	"PICKUP_HEALTH_SNACK",
	"PICKUP_HEALTH_STANDARD",
	"PICKUP_MONEY_CASE",
	"PICKUP_MONEY_DEP_BAG",
	"PICKUP_MONEY_MED_BAG",
	"PICKUP_MONEY_PAPER_BAG",
	"PICKUP_MONEY_PURSE",
	"PICKUP_MONEY_SECURITY_CASE",
	"PICKUP_MONEY_VARIABLE",
	"PICKUP_MONEY_WALLET",
	"PICKUP_PARACHUTE",
	"PICKUP_PORTABLE_CRATE_FIXED_INCAR",
	"PICKUP_PORTABLE_CRATE_UNFIXED",
	"PICKUP_PORTABLE_CRATE_UNFIXED_INCAR",
	"PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL",
	"PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW",
	"PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE",
	"PICKUP_PORTABLE_PACKAGE",
	"PICKUP_SUBMARINE",
	"PICKUP_VEHICLE_ARMOUR_STANDARD",
	"PICKUP_VEHICLE_CUSTOM_SCRIPT",
	"PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW",
	"PICKUP_VEHICLE_HEALTH_STANDARD",
	"PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW",
	"PICKUP_VEHICLE_MONEY_VARIABLE",
	"PICKUP_VEHICLE_WEAPON_APPISTOL",
	"PICKUP_VEHICLE_WEAPON_ASSAULTSMG",
	"PICKUP_VEHICLE_WEAPON_COMBATPISTOL",
	"PICKUP_VEHICLE_WEAPON_GRENADE",
	"PICKUP_VEHICLE_WEAPON_MICROSMG",
	"PICKUP_VEHICLE_WEAPON_MOLOTOV",
	"PICKUP_VEHICLE_WEAPON_PISTOL",
	"PICKUP_VEHICLE_WEAPON_PISTOL50",
	"PICKUP_VEHICLE_WEAPON_SAWNOFF",
	"PICKUP_VEHICLE_WEAPON_SMG",
	"PICKUP_VEHICLE_WEAPON_SMOKEGRENADE",
	"PICKUP_VEHICLE_WEAPON_STICKYBOMB",
	"PICKUP_WEAPON_ADVANCEDRIFLE",
	"PICKUP_WEAPON_APPISTOL",
	"PICKUP_WEAPON_ASSAULTRIFLE",
	"PICKUP_WEAPON_ASSAULTSHOTGUN",
	"PICKUP_WEAPON_ASSAULTSMG",
	"PICKUP_WEAPON_AUTOSHOTGUN",
	"PICKUP_WEAPON_BAT",
	"PICKUP_WEAPON_BATTLEAXE",
	"PICKUP_WEAPON_BOTTLE",
	"PICKUP_WEAPON_BULLPUPRIFLE",
	"PICKUP_WEAPON_BULLPUPSHOTGUN",
	"PICKUP_WEAPON_CARBINERIFLE",
	"PICKUP_WEAPON_COMBATMG",
	"PICKUP_WEAPON_COMBATPDW",
	"PICKUP_WEAPON_COMBATPISTOL",
	"PICKUP_WEAPON_COMPACTLAUNCHER",
	"PICKUP_WEAPON_COMPACTRIFLE",
	"PICKUP_WEAPON_CROWBAR",
	"PICKUP_WEAPON_DAGGER",
	"PICKUP_WEAPON_DBSHOTGUN",
	"PICKUP_WEAPON_FIREWORK",
	"PICKUP_WEAPON_FLAREGUN",
	"PICKUP_WEAPON_FLASHLIGHT",
	"PICKUP_WEAPON_GRENADE",
	"PICKUP_WEAPON_GRENADELAUNCHER",
	"PICKUP_WEAPON_GUSENBERG",
	"PICKUP_WEAPON_GOLFCLUB",
	"PICKUP_WEAPON_HAMMER",
	"PICKUP_WEAPON_HATCHET",
	"PICKUP_WEAPON_HEAVYPISTOL",
	"PICKUP_WEAPON_HEAVYSHOTGUN",
	"PICKUP_WEAPON_HEAVYSNIPER",
	"PICKUP_WEAPON_HOMINGLAUNCHER",
	"PICKUP_WEAPON_KNIFE",
	"PICKUP_WEAPON_KNUCKLE",
	"PICKUP_WEAPON_MACHETE",
	"PICKUP_WEAPON_MACHINEPISTOL",
	"PICKUP_WEAPON_MARKSMANPISTOL",
	"PICKUP_WEAPON_MARKSMANRIFLE",
	"PICKUP_WEAPON_MG",
	"PICKUP_WEAPON_MICROSMG",
	"PICKUP_WEAPON_MINIGUN",
	"PICKUP_WEAPON_MINISMG",
	"PICKUP_WEAPON_MOLOTOV",
	"PICKUP_WEAPON_MUSKET",
	"PICKUP_WEAPON_NIGHTSTICK",
	"PICKUP_WEAPON_PETROLCAN",
	"PICKUP_WEAPON_PIPEBOMB",
	"PICKUP_WEAPON_PISTOL",
	"PICKUP_WEAPON_PISTOL50",
	"PICKUP_WEAPON_POOLCUE",
	"PICKUP_WEAPON_PROXMINE",
	"PICKUP_WEAPON_PUMPSHOTGUN",
	"PICKUP_WEAPON_RAILGUN",
	"PICKUP_WEAPON_REVOLVER",
	"PICKUP_WEAPON_RPG",
	"PICKUP_WEAPON_SAWNOFFSHOTGUN",
	"PICKUP_WEAPON_SMG",
	"PICKUP_WEAPON_SMOKEGRENADE",
	"PICKUP_WEAPON_SNIPERRIFLE",
	"PICKUP_WEAPON_SNSPISTOL",
	"PICKUP_WEAPON_SPECIALCARBINE",
	"PICKUP_WEAPON_STICKYBOMB",
	"PICKUP_WEAPON_STUNGUN",
	"PICKUP_WEAPON_SWITCHBLADE",
	"PICKUP_WEAPON_VINTAGEPISTOL",
	"PICKUP_WEAPON_WRENCH",
	"PICKUP_WEAPON_RAYCARBINE",
	"PICKUP_AMMO_FIREWORK_MP"
}

function RemoveWeaponDrops()
    local player = PlayerId()
	for _, pickup in pairs(pickupList) do
		N_0x616093ec6b139dd9(player, GetHashKey(pickup), false)
	end
end

Citizen.CreateThread(function()     
    RemoveWeaponDrops()
end)
--
local citydisable = false

Citizen.CreateThread(function()
	local whiteCoords = {
        vec(1159.35, -319.83, 69.95, 30),    -- shop kenare casino
        vec(1137.07, -981.79, 46.41, 20),    -- shop kenare mechanici
        vec(-712.0, -917.96, 19.21, 25),     -- shope kenare weazel
        vec(-53.3, -1757.12, 29.44, 25),     -- shope grove
        vec(32.25, -1349.79, 29.33, 25),     -- shop 1
        vec(314.25, -279.1, 54.17, 20),      -- mini 1
        vec(-351.78, -51.8, 49.04, 20),      -- mini 2
		vec(-1211.88, -333.19, 37.78, 20),   -- mini 4
        vec(-1485.2, -375.23, 40.16, 18),    -- shop kenare bime
        vec(378.08, 329.81, 103.57, 15),     -- shop bank markazi
        vec(-1219.58, -909.94, 12.33, 15),   -- mini shop 1
		vec(-1132.29, -1357.35, 5.03, 23),   -- mini javaheri
		vec(-1541.67, -417.04, 35.64, 23),   -- mini javaheri
    }
	exports('inWhiteListCoords', function()
		for k , v in pairs(whiteCoords) do
			local dist = ESX.GetDistance(SUN.PlayerCoords, v.xyz)
			if dist <= v.w then
				return true
			end
		end
	end)
	local wait = 1000
	local radius = 2200
	local unarmed = `weapon_unarmed`
	local whitelist = {
		[`weapon_ball`] = true,
		[`weapon_snowball`] = true,
	}
	local taze = `weapon_stungun`
	local headDisabled = false
	waitForLoad(1000)

	AddEventHandler('onSelectWeapon', function(_, _, _, oldWeapon)
		if SUN.World ~= 0 and not exports['sun-robbery']:doesInRob() then return end
		if oldWeapon ~= unarmed and not ESX.meleeWeapons[oldWeapon] then return end
		local disable = true
		SetTimeout(2000, function()
			disable = false
		end)
		while disable do
			Wait(0)
			disableFiring()
		end
	end)

	while true do
		local distance = ESX.GetDistance(SUN.PlayerCoords,vector3(-206.87,-1248.82,37.18))
		SUN.inBlackListCoords = not exports['sun-jobs']:notBlackListCoords()
		if distance < radius and SUN.World == 0 then
			local notwhite = true
			local hassilencer = false
			local melee = false
			if not ESX.militaryJobs2[ESX.PlayerData.job.name] then
				for k , v in pairs(whiteCoords) do
					local dist = ESX.GetDistance(SUN.PlayerCoords,v.xyz)
					if dist <= v.w then
						notwhite = false
					end
					local weapon = GetSelectedPedWeapon(PlayerPedId())
					local comp = ESX.GetWeaponComponent(ESX.GetWeaponName(weapon),'suppressor')
					if comp then
						if HasPedGotWeaponComponent(PlayerPedId(),weapon,comp.hash) then
							hassilencer = true
						end
					end
					if ESX.meleeWeapons[weapon] then
						melee = true
					end
					if notwhite and not melee and not (hasLicense and (IsPedInAnyVehicle(PlayerPedId()) or hassilencer)) and ESX.serverNum ~= 2 then
						if not citydisable then
							citydisable = true
							Citizen.CreateThread(function()
								while citydisable and SUN.World == 0 do
									Citizen.Wait(0)
									if SUN.CurrentWeaponModel ~= unarmed and not whitelist[SUN.CurrentWeaponModel] and not dummyThreadState then
										disableFiring()
									end
								end
								citydisable = false
							end)
						end
					else
						citydisable = false
					end
				end
			else
				citydisable = false
			end
		else
			citydisable = false
		end

		if ESX.PlayerData and ESX.headDisable[ESX.PlayerData.job.name] and exports['sun-jobs']:notBlackListCoords() then
			headDisabled = true
			SetPedSuffersCriticalHits(SUN.ped, false)
		elseif headDisabled then
			headDisabled = false
			SetPedSuffersCriticalHits(SUN.ped, true)
		end
		Citizen.Wait(wait)
	end
end)

AddEventHandler('KeyDown:mouse_left',function()
	if (citydisable or gangKey) and not ESX.unarmedWeapons[GetSelectedPedWeapon(PlayerPedId())]  and not dummyThreadState then
		ESX.Alert('','تیر اندازی در این منطقه ممنوع است',5000,'warning')
	end
end)

-- Disable stealth kills
RemoveStealthKill(`ACT_stealth_kill_a`)
RemoveStealthKill(`ACT_stealth_kill_b`)
RemoveStealthKill(`ACT_stealth_kill_c`)
RemoveStealthKill(`ACT_stealth_kill_d`)
RemoveStealthKill(`ACT_stealth_kill_a_gardener`)
RemoveStealthKill(`ACT_stealth_kill_weapon`)

function NET(eventName, func)
	RegisterNetEvent(eventName)
	AddEventHandler(eventName, func)
end
NET('record', function()
	StartRecording(1)
end)

NET('crecord', function()
	StopRecordingAndDiscardClip()
end)

NET('srecord', function()
	StopRecordingAndSaveClip()
end)

NET('editor', function()
	ActivateRockstarEditor()
end)

NET('oeditor', function()
	NetworkSessionLeaveSinglePlayer()
	ActivateRockstarEditor()
end)

RegisterCommand('srecord',function()
	TriggerEvent('record')
end)

RegisterCommand('srrecord',function()
	TriggerEvent('srecord')
end)

RegisterCommand('sd',function()
	TriggerEvent('editor')
end)

-- local trafficLights = {
-- 	`v_traffic_lights`,
-- 	`prop_trafficlight`,
-- 	`prop_traffic_lightset_01`,
--     `prop_traffic_03b`,
-- 	`prop_traffic_03a`,
-- 	`prop_traffic_02b`,
-- 	`prop_traffic_02a`,
-- 	`prop_traffic_01d`,
-- 	`prop_traffic_01b`,
-- 	`prop_traffic_01a`,
-- 	`prop_traffic_01`,
-- 	`prop_streetlight_01b`,
-- 	`prop_streetlight_01`,
-- 	`prop_sign_road_03g`,
-- 	`prop_news_disp_01a`,
-- 	`prop_news_disp_02a`,
-- 	`prop_parknmeter_02`,
-- 	`prop_parknmeter_01`,
-- 	`prop_fire_hydrant_2`,
-- } 

-- Citizen.CreateThread(function()
-- 	while true do
-- 		local coords = SUN.PlayerCoords
-- 		for k, v in pairs(trafficLights) do
-- 			local entity = GetClosestObjectOfType(coords, 20.0, v, 0, 0, 0)
-- 			if entity ~= 0 then
-- 				FreezeEntityPosition(entity, true)
-- 			end
-- 		end
-- 		Citizen.Wait(2000)
-- 	end
-- end)

local disableControlActionList = {}

CreateThread(function()
	while true do
		Wait(3)
		for k, v in pairs(disableControlActionList) do
			DisableControlAction(0, k)
		end
	end
end)

function disableControlAction(k, state)
	disableControlActionList[k] = state
end
exports('disableControlAction', disableControlAction)

exports('GetServerOSTime', function()
	if GetServerOSTime == nil then return end
	local status, result = pcall(GetServerOSTime)
	if not status then return end
	return result
end)


exports('getVar',function(index)
	return SUN[index]
end)	

local noCollisionActive = false
local deadPlayerIds = {}

CreateThread(function()
	waitForLoad(10000)
	while true do
		if noCollisionActive or SUN.inBlackListCoords then
			local list = {}
			for _, id in ipairs(GetActivePlayers()) do
				if id ~= SUN.PlayerId and ESX.GetPlayerState(GetPlayerServerId(id), 'isDead') then
					list[#list + 1] = id
				end
			end
			deadPlayerIds = list
			Wait(3000)
		else
			deadPlayerIds = {}
			Wait(10000)
		end
	end
end)

CreateThread(function()
	waitForLoad(10000)
	while true do
		if (noCollisionActive or SUN.inBlackListCoords) and #deadPlayerIds > 0 then
			active = true
			for _, id in ipairs(deadPlayerIds) do
				local otherPlayerPed = GetPlayerPed(id)
				SetEntityNoCollisionEntity(SUN.ped, otherPlayerPed, true)
				SetEntityNoCollisionEntity(otherPlayerPed, SUN.ped, true)
			end
			Wait(0)
		else
			Wait(1000)
		end
	end
end)

AddEventHandler('noCollisionState', function(state)
	noCollisionActive = state
end)