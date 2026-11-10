-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX                             = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }


eventcoords = {}
nextzonecoords = {}
nextzonecoordsstart = false
spawncoords = {}
spawncoords2 = {}
ploots = {}
playerscount = 0
starttimer = 0
blip = nil
playerdroped = false
inevent = false
plane = nil
cam = nil
markerradius = 1500.0
inmarker = false
loots = {}
canpickup = false
pickupid = nil
ingulag = false
blood = 3
canpickup2 = false
pickupid2 = nil
ncz = false
Citizen.CreateThread(function()
SetEntityCollision(GetPlayerPed(-1), true, true)
while ESX == nil do
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  Citizen.Wait(0)
end
end)

RegisterNetEvent('br:join')
AddEventHandler('br:join',function(crds,count)
	TriggerEvent('holster:active',true)
	eventcoords = crds
	local radius = 1500 + 500
	local rand = math.random(1,2)
	if rand == 1 then
		spawncoords = vector3(eventcoords.x + radius,eventcoords.y,eventcoords.z)
		spawncoords2 = vector3(eventcoords.x - radius,eventcoords.y,eventcoords.z)
	else
		spawncoords = vector3(eventcoords.x ,eventcoords.y + radius ,eventcoords.z)
		spawncoords2 = vector3(eventcoords.x ,eventcoords.y - radius,eventcoords.z)
	end
	ped = PlayerPedId()
	if rand == 1 then
		ESX.SetEntityCoords(ped,config.lobbycoords)
	else
		ESX.SetEntityCoords(ped,config.lobbycoords2)
	end
	TriggerEvent('es_admin:freezePlayer', true)
	Wait(1000)
	TriggerEvent('es_admin:freezePlayer', false)
	TriggerEvent('br:inbr',true)
	RemoveAllPedWeapons(ped, 1)
	TriggerEvent('esx_inventoryhud:br',true)
	inevent = true
	playerscount = count
	showplayercount()
	blip = AddBlipForRadius(eventcoords.x, eventcoords.y, eventcoords.z, 1500.0)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 4)
	SetBlipAlpha(blip, 100)
	SetBlipAsShortRange(blip, true)
	showmarker()
	showmarker2()
	createdrop()
end)

RegisterNetEvent('br:updateloot')
AddEventHandler('br:updateloot',function(k)
		loots[k].used = true
		DeleteEntity(loots[k].entity)
end)

RegisterNetEvent('br:revive')
AddEventHandler('br:revive',function(gl)
							ped = PlayerPedId()
							local ccrds = GetEntityCoords(PlayerPedId())
							ESX.SetEntityCoordsNoOffset(ped, ccrds.x, ccrds.y, ccrds.z, false, false, false, true)
							NetworkResurrectLocalPlayer(ccrds.x, ccrds.y,ccrds.z, 20, true, false)
							SetPlayerInvincible(ped, false)							
							ESX.SetPedArmour(ped, 0)						
							ClearPedBloodDamage(ped)
							local ccrds = GetEntityCoords(PlayerPedId())
							local crds = vector3(ccrds.x,ccrds.y,ccrds.z)
							if gl then 
								crds = vector3(3079,-4770.64,7)
								ESX.SetEntityCoords(PlayerPedId(), crds)
							else
								ESX.SetEntityCoords(PlayerPedId(), crds)
							end
							ESX.UI.Menu.CloseAll()
							TriggerEvent('esx_status:setss', 'hunger', 1000000)
							TriggerEvent('esx_status:setss', 'thirst', 1000000)	
							Wait(3000)
							ESX.SetEntityHealth(ped, GetEntityMaxHealth(ped))
end)


RegisterNetEvent('br:waitgulag')
AddEventHandler('br:waitgulag',function(k)
		TriggerEvent('InteractSound_CL:PlayOnOne', 'gulag', 0.9)
		ingulag = true
		local tarc = vector3(3071.13,-4743,8.0)
		ESX.SetEntityCoords(PlayerPedId(),tarc)
		Wait(1000)
		RemoveAllPedWeapons(PlayerPedId(), 1)
		ncz = true
		nczthread()
	--	TriggerEvent('esx:addWeapon', "WEAPON_HEAVYPISTOL", 250)
end)

RegisterNetEvent('br:waitgulag2')
AddEventHandler('br:waitgulag2',function()
		TriggerEvent('InteractSound_CL:PlayOnOne', 'gulag', 0.9)
		ingulag = true
		local tarc = vector3(3071.13,-4743,8.0)
		ESX.SetEntityCoords(PlayerPedId(),tarc)
		FristPersonView()
		Wait(1000)
		RemoveAllPedWeapons(PlayerPedId(), 1)		
		TriggerEvent('br:ingulag',true)
		TriggerEvent('es_admin:freezePlayer', true)
		Wait(4000)
		TriggerEvent('es_admin:freezePlayer', false)
		gunth()
		ncz = false
end)

RegisterNetEvent('br:waitgulag3')
AddEventHandler('br:waitgulag3',function()
		TriggerEvent('InteractSound_CL:PlayOnOne', 'gulag', 0.9)
		ingulag = true
		local tarc = vector3(3086.88,-4799,8.0)
		ESX.SetEntityCoords(PlayerPedId(),tarc)
		FristPersonView()
		Wait(1000)
		RemoveAllPedWeapons(PlayerPedId(), 1)
		TriggerEvent('br:ingulag',true)
		TriggerEvent('es_admin:freezePlayer', true)
		Wait(3000)
		TriggerEvent('es_admin:freezePlayer', false)
		gunth()
		ncz = false
end)

function gunth()
	Citizen.CreateThread(function()
		while not HasPedGotWeapon(PlayerPedId(),GetHashKey("WEAPON_HEAVYPISTOL")) do
			TriggerEvent('esx:addWeapon', "WEAPON_HEAVYPISTOL", 250)
		end
	end)
end
RegisterNetEvent('br:leavemeg')
AddEventHandler('br:leavemeg',function()
		deletedrop()	
		RemoveBlip(blip)
		ingulag = false
		inevent = false
		TriggerEvent('br:ingulag',false)
		TriggerEvent('br:inbr',false)
		inmarker = false
		inzone = false
		eventcoords = {}
		nextzonecoords = {}
		nextzonecoordsstart = false
		spawncoords = {}
		spawncoords2 = {}
		
		playerscount = 0
		starttimer = 0
		blip = nil
		playerdroped = false
		plane = nil
		cam = nil
		markerradius = 1500.0
		canpickup = false
		pickupid = nil
		canpickup2 = false
		pickupid2 = nil
		Wait(1000)
		local formattedCoords = {
			x = 244.21,
			y = -819.41,
			z = 30.1
		}
		
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(PlayerPedId(), formattedCoords, 206.36)		
		
		RemoveAllPedWeapons(PlayerPedId(), 1)
		Wait(1000)
		TriggerEvent("esx:restoreLoadout")
		TriggerEvent('esx_inventoryhud:br',false)
		SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
end)


function deletedrop()
	Citizen.CreateThread(function()
		for k , v in ipairs(loots) do
				DeleteEntity(v.entity)
		end
		for k , v in ipairs(ploots) do
				DeleteEntity(v.entity)
		end
		ploots = {}
		loots = {}
	end)
end

RegisterNetEvent('br:backwar')
AddEventHandler('br:backwar',function()
	Wait(2000)
	RemoveAllPedWeapons(PlayerPedId(), 1)
	ingulag = false
	local tarr = vector3(eventcoords.x,eventcoords.y,800)
	ESX.SetEntityCoords(PlayerPedId(),tarr)
	TriggerEvent('esx:addWeapon', "WEAPON_SNSPISTOL", 250)
end)

RegisterNetEvent('br:end')
AddEventHandler('br:end',function()
	Wait(1000)
	RemoveBlip(blip)
	deletedrop()
	ingulag = false
		inevent = false
		TriggerEvent('br:ingulag',false)
		TriggerEvent('br:inbr',false)
		inmarker = false
		inzone = false
		eventcoords = {}
		nextzonecoords = {}
		nextzonecoordsstart = false
		spawncoords = {}
		spawncoords2 = {}
		ploots = {}
		playerscount = 0
		starttimer = 0
		blip = nil
		playerdroped = false
		plane = nil
		cam = nil
		markerradius = 1500.0
		loots = {}
		canpickup = false
		pickupid = nil
		canpickup2 = false
		pickupid2 = nil
		Wait(5000)
		RemoveAllPedWeapons(PlayerPedId(), 1)
		Wait(1000)
		TriggerEvent("esx:restoreLoadout")
		TriggerEvent("esx:restoreLoadout")
		TriggerEvent('esx_inventoryhud:br',false)
		SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
		TriggerEvent('holster:active',true)
end)



function createdrop()
	ESX.TriggerServerCallback("br:getlootsdata",function(data)
		loots = data
		Citizen.CreateThread(function()
			while inevent do
				for k , v in ipairs(loots) do
					local targetcoords = v.coords
					distane = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),targetcoords,false)
					if distane < 200 then
						if not v.created and v.used == false then
							v.created = true
							CreatePickUp(k)
						end
					end
					Wait(1)
				end
			Wait(100)
			end
		end)
		
		checkpickup()
		checkpickup2()
	end)
end

RegisterNetEvent('br:createploot')
AddEventHandler('br:createploot',function(data)
	if inevent then
		table.insert(ploots,data)
		for k , v in ipairs(ploots) do
			if data.id == v.id then
				CreatePickUp2(k)
			end
		end
	end
end)

function CreatePickUp(key)
	Citizen.CreateThread(function()
    local coordZ = 0
    local height = 300.0
	local pickup = CreateObject(GetHashKey("prop_box_ammo03a"), loots[key].coords, false, true, true)
		SetEntityInvincible(pickup, true)
        SetEntityLodDist(pickup, 2000)
        ActivatePhysics(pickup)
    local foundGround = false
	local coord = loots[key].coords
    repeat
        Wait(1)
		ESX.SetEntityCoords(pickup, coord.x, coord.y, height)
        foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
        coordZ = z + 1
        height = height - 1.0
    until foundGround or height < -100

    if not foundGround then
        coordZ = coord.z
    end
	ESX.SetEntityCoords(pickup, coord.x, coord.y, coordZ)
	loots[key].coords = vector3(loots[key].coords.x,loots[key].coords.y,coordZ)
	loots[key].entity = pickup
	PlaceObjectOnGroundProperly(pickup)
	FreezeEntityPosition(pickup,true)
	--[[blip = AddBlipForCoord(coord.x, coord.y, coordZ)
        SetBlipSprite(blip, 50)
        SetBlipRouteColour(blip, 2)]]
	end)
end

function CreatePickUp2(key)
	Citizen.CreateThread(function()
	coord =  ploots[key].coords
	local pickup = CreateObject(GetHashKey("prop_box_ammo06a"), ploots[key].coords, false, true, true)
	SetEntityInvincible(pickup, true)
    SetEntityLodDist(pickup, 2000)
    ActivatePhysics(pickup)
	ESX.SetEntityCoords(pickup, coord)
	ploots[key].entity = pickup
	PlaceObjectOnGroundProperly(pickup)
	FreezeEntityPosition(pickup,true)
	end)
end

--[[function SetPickUpz(key)
	Citizen.CreateThread(function()
    local coordZ = 0
    local height = 300.0
	local pickup = loots[key].entity
    local foundGround = false
	local coord = loots[key].coords
    repeat
        Wait(1)
		SetEntityCoords(pickup, coord.x, coord.y, height)
        foundGround, z = GetGroundZFor_3dCoord(coord.x, coord.y, height)
        coordZ = z + 1
        height = height - 1.0
    until foundGround or height < -100

    if not foundGround then
        coordZ = coord.z
    end
	SetEntityCoords(pickup, coord.x, coord.y, coordZ)
	loots[key].coords = vector3(loots[key].coords.x,loots[key].coords.y,coordZ)
	loots[key].entity = pickup
	PlaceObjectOnGroundProperly(pickup)
	--FreezeEntityPosition(pickup,true)
	    blip = AddBlipForCoord(coord.x, coord.y, coordZ)
        SetBlipSprite(blip, 50)
        SetBlipRouteColour(blip, 2)
	end)
end]]

function SetPickUpz(key)
	Citizen.CreateThread(function()
    local coordZ = 0
    local height = 300.0
	local pickup = loots[key].entity
	if GetEntityCoords(PlayerPedId()).z ~= GetEntityCoords(pickup).z then
	local crds = vector3(GetEntityCoords(pickup).x,GetEntityCoords(pickup).y,GetEntityCoords(PlayerPedId()).z)
	ESX.SetEntityCoords(pickup,crds)
	end
	end)
end

--[[function checkpickup()
	Citizen.CreateThread(function()
		while inevent do
			Wait(10)
			for k , v in ipairs(loots) do
				Wait(10)
				local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(v.entity))
				local crds = GetEntityCoords(v.entity)
				if v.used == false then
				if dist < 6 and dist > 2 then
					Draw3DText(crds.x,crds.y,crds.z - 1, v.weapon:gsub("WEAPON_",""),4, 0.1, 0.1)
				elseif dist < 2 then
					ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ jahat loot kardan box")
					Draw3DText(crds.x,crds.y,crds.z - 1, v.weapon:gsub("WEAPON_",""),4, 0.1, 0.1)
					if IsControlJustReleased(1, 51)  then
						TriggerServerEvent('br:useloot',k)
						GiveWeaponToPed(PlayerPedId(),GetHashKey(v.weapon),250,false,false)
					end
				end
				end
			end
		end
	end)
end]]

function checkpickup()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1)
			local closeloot = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_box_ammo03a'), false)
			if DoesEntityExist(closeloot) then
				for k , v in ipairs(loots) do
					if v.entity == closeloot then
						if not v.used then					
							local crds = GetEntityCoords(closeloot)
							local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),crds,false)
								if v.used == false then								
									if dist < 10 and dist > 2 then
										--SetPickUpz(k)
										Draw3DText(crds.x,crds.y,crds.z - 1, v.weapon:gsub("WEAPON_",""),4, 0.1, 0.1)
										if v.armor then
											Draw3DText(crds.x,crds.y,crds.z , 'ARMOR '.. v.armor,4, 0.1, 0.1)
										elseif v.heal then
										Draw3DText(crds.x,crds.y,crds.z , 'BANDAE',4, 0.1, 0.1)
										end
										canpickup = false	
										DrawMarker(0, crds.x, crds.y, crds.z + 2, 0, 0, 0, 0, 0, 0, 1.0, 1.0,1.0, 255, 0, 0, 100, 1, 0, 0, 1)
									elseif dist < 2 then
										ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ jahat loot kardan box")
										Draw3DText(crds.x,crds.y,crds.z - 1, v.weapon:gsub("WEAPON_",""),4, 0.1, 0.1)
										if v.armor then
											Draw3DText(crds.x,crds.y,crds.z , 'ARMOR '.. v.armor,4, 0.1, 0.1)
										elseif v.heal then
										Draw3DText(crds.x,crds.y,crds.z , 'BANDAE',4, 0.1, 0.1)
										end
										DrawMarker(0, crds.x, crds.y, crds.z + 2, 0, 0, 0, 0, 0, 0, 1.0, 1.0,1.0, 255, 0, 0, 100, 1, 0, 0, 1)
										canpickup = true
										pickupid = k	
									end
								end
						end
					end
				end
			else
				canpickup = false
			end
		end
	end)
end

function checkpickup2()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1)
			local closeloot = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('prop_box_ammo06a'), false)
			if DoesEntityExist(closeloot) then
				for k , v in ipairs(ploots) do
					if v.entity == closeloot then					
							local crds = GetEntityCoords(closeloot)
							local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),crds,false)							
									if dist < 10 and dist > 2 then
										canpickup2 = false	
										DrawMarker(0, crds.x, crds.y, crds.z + 2, 0, 0, 0, 0, 0, 0, 1.0, 1.0,1.0, 255, 0, 0, 100, 1, 0, 0, 1)
									elseif dist < 2 then
										ESX.ShowHelpNotification("Dokme ~INPUT_CONTEXT~ jahat loot kardan box")
										DrawMarker(0, crds.x, crds.y, crds.z + 2, 0, 0, 0, 0, 0, 0, 1.0, 1.0,1.0, 255, 0, 0, 100, 1, 0, 0, 1)
										canpickup2 = true
										pickupid2 = k	
									end
					end
				end
			else
				canpickup2 = false
			end
		end
	end)
end

AddEventHandler('onKeyUP',function(key)
	if key == "e" then
		if canpickup then
			pickupdata = loots[pickupid]
			if pickupdata.used == false then
				TriggerEvent('esx:addWeapon', pickupdata.weapon, 250)
				if pickupdata.armor then
					
					ESX.SetPedArmour(PlayerPedId(),GetPedArmour(PlayerPedId()) + pickupdata.armor)
					ESX.ShowNotification('Shoma yek armor '.. pickupdata.armor ..' poushidid')				
				elseif pickupdata.heal then
					ESX.SetEntityHealth(PlayerPedId(),200)
					ESX.ShowNotification('Shoma yek bandage estefade kardid')
				end
				TriggerServerEvent('br:useloot',pickupid)
					PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
					local dictname = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@"
					RequestAnimDict(dictname)
						if not HasAnimDictLoaded(dictname) then
							RequestAnimDict(dictname) 
							while not HasAnimDictLoaded(dictname) do 
								Citizen.Wait(1)
							end
						end
					TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', 'plant_floor', 8.0, -8,3750, 2, 0, 0, 0, 0)
					Citizen.Wait(850)
					Citizen.Wait(1000)
					ClearPedTasks(GetPlayerPed(-1))
			end
		end		
		if canpickup2 then
			ESX.TriggerServerCallback("br:getplootsdata",function(pickupdata)
					TriggerEvent('esx_inventoryhud:openBoxInventory',pickupdata,pickupid2)
			end,pickupid2)
		end				
	end
end)

RegisterNetEvent('br:updatepcount')
AddEventHandler('br:updatepcount',function(count)
	playerscount = count
end)

RegisterNetEvent('br:start')
AddEventHandler('br:start',function(time)
	starttimer = time
	timer()
	Citizen.CreateThread(function()
		while true do
			Wait(0)
				if starttimer ~= 0 then
					Draw('Start at : '.. starttimer.. 's',255,0,0,0.01,0.4)
				else
					
					break
				end
		end
		TriggerEvent('medic:revive', true, nil, true)
		Wait(1000)
		startdropplayer()
	end)
	Citizen.CreateThread(function()
		while inevent do
			Wait(0)
			Draw('Blood : '.. blood,255,0,0,0.01,0.3)
			DisableControlAction(0, Keys["F5"])
			DisableControlAction(0, Keys["F6"])
		end
	end)
end)

RegisterNetEvent('br:updateblood')
AddEventHandler('br:updateblood',function(ct)
	blood = ct
end)

RegisterNetEvent('br:updatemarker')
AddEventHandler('br:updatemarker',function(nxtrds)
	local startzone = true
	Citizen.SetTimeout(120000,function()
		startzone = false
	end)
	Citizen.CreateThread(function()
		while markerradius > nxtrds do
				Wait(100)
				markerradius = markerradius - 0.2
		end
	end)
	--
	nextzonecoords = vector3(eventcoords.x,eventcoords.y,eventcoords.z)
	nextzonecoordsrds = tonumber(tostring(nxtrds) .. ".0")
	nextzonecoordsstart = true
end)

function timer()
	Citizen.CreateThread(function()
		while starttimer ~= 0 do
			Wait(1000)
			starttimer = starttimer - 1
		end
	end)
end

function showplayercount()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1)
			Draw('Alive Player : '.. playerscount,255,0,0,0.01,0.5)
		end
	end)
end

function startdropplayer()
		model = GetHashKey('titan')
		RequestModel(model)
        while not HasModelLoaded(model) do
			Wait(1000)
        end
		local coordssp = vector3(eventcoords.x,eventcoords.y,eventcoords.z)
		plane = CreateVehicle(model, spawncoords.x,spawncoords.y,1000.0, 10, false, true)
		while not DoesEntityExist(plane) do
			plane = CreateVehicle(model, spawncoords.x,spawncoords.y,1000.0, 10, false, true)
		end
		makeEntityFaceEntity(coordssp,plane)
		SetEntityDynamic(plane, true)
        ActivatePhysics(plane)
        SetVehicleForwardSpeed(plane, 100.0)
        SetHeliBladesFullSpeed(plane)
        SetVehicleEngineOn(plane, true, true, false)
        ControlLandingGear(plane, 3)
        OpenBombBayDoors(plane)
        SetEntityProofs(plane, true, false, true, false, false, false, false, false)
		pilot = CreatePedInsideVehicle(plane, 1, GetHashKey("mp_m_freemode_01"), -1, false, true)
        SetBlockingOfNonTemporaryEvents(pilot, true)
        --SetPedRandomComponentVariation(pilot, false)
        SetPedKeepTask(pilot, true)
        SetPlaneMinHeightAboveTerrain(plane, 50)
		TaskVehicleDriveToCoord(pilot, plane, vector3(spawncoords2.x, spawncoords2.y, 1000), 2500.0*3.6, 500,  GetHashKey("titan"), 16777216, 1.0, 1)
		ClearPedTasksImmediately(PlayerPedId())
		FreezeEntityPosition(GetPlayerPed(-1),true)
		Wait(1000)
		exports.suncore:SetPlayerVisible(false)
		ClearPedTasksImmediately(PlayerPedId())
		SetEntityCollision(GetPlayerPed(-1), false, false)
		AttachEntityToEntity(GetPlayerPed(-1), plane, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
		while not IsEntityAttached(PlayerPedId()) do
			AttachEntityToEntity(GetPlayerPed(-1), plane, 0, 5, 0, 7.0, 0, 0, 0, true, true, false, true, 0, false)	
		end
		playerdroped = true
		camplane()		
end

function camplane()
	Citizen.CreateThread(function()
		inzone = false
		while playerdroped do
			Wait(0)	
			local coordssp = vector3(eventcoords.x,eventcoords.y,eventcoords.z)
			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coordssp) < 1500 then
				ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat jump', true, true, 1000)	
				inzone = true
			if IsControlJustReleased(1, 51)  then
				FreezeEntityPosition(GetPlayerPed(-1),false)
				DetachEntity(PlayerPedId(), true, true)
				local planecoords = GetEntityCoords(PlayerPedId())
				SetEntityCollision(GetPlayerPed(-1), true, true)
				exports.suncore:SetPlayerVisible(true)
				ESX.SetEntityCoords(PlayerPedId(),planecoords.x,planecoords.y,planecoords.z - 20)
				RemoveAllPedWeapons(PlayerPedId(), 1)
				GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776, 1, 0)
				TriggerEvent('esx:addWeapon', "WEAPON_SNSPISTOL", 250)
				TriggerEvent('xcontrol',false)
				SetTimeout(120000,function()
					TriggerEvent('xcontrol',true)
					DeleteVehicle(plane)
				end)
				playerdroped = false
				checkinmarker()
			end
			else
				if inzone then
					DetachEntity(PlayerPedId(), true, true)
					local planecoords = GetEntityCoords(PlayerPedId())
					SetEntityCollision(GetPlayerPed(-1), true, true)
					exports.suncore:SetPlayerVisible(true)
					ESX.SetEntityCoords(PlayerPedId(),planecoords.x,planecoords.y,planecoords.z - 20)
					GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776, 1, 0)
					TriggerEvent('xcontrol',false)
					SetTimeout(120000,function()
						TriggerEvent('xcontrol',true)
						DeleteVehicle(plane)
					end)
					playerdroped = false
					checkinmarker()
				end
			end
		end
	end)
end

function showmarker()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1)
			local coords = vector3(eventcoords.x,eventcoords.y,eventcoords.z)
			distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coords)
			if distance > markerradius then
				DrawMarker(28, coords, 0, 0, 0, 0, 0, 0, markerradius, markerradius, markerradius, 255, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)
				inmarker = false
			else
				DrawMarker(28, coords, 0, 0, 0, 0, 0, 0, markerradius, markerradius, markerradius, 255, 255, 255, 150, 0, 0, 0, 0, 0, 0, 0)
				inmarker = true
			end
		end
	end)
end

function showmarker2()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1)
			if nextzonecoordsstart then
			local coords = vector3(nextzonecoords.x,nextzonecoords.y,nextzonecoords.z)
			distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coords)
			if distance > nextzonecoordsrds then
				DrawMarker(28, coords, 0, 0, 0, 0, 0, 0, nextzonecoordsrds, nextzonecoordsrds, nextzonecoordsrds, 255, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)
			else
				DrawMarker(28, coords, 0, 0, 0, 0, 0, 0, nextzonecoordsrds, nextzonecoordsrds, nextzonecoordsrds, 255, 255, 255, 150, 0, 0, 0, 0, 0, 0, 0)
			end
			end
		end
	end)
end

function checkinmarker()
	Citizen.CreateThread(function()
		while inevent do
			Wait(1000)
			if not inmarker and not ingulag then
				local health = GetEntityHealth(PlayerPedId()) - 1
				ESX.SetEntityHealth(PlayerPedId(),health)				
			end
			RestorePlayerStamina(PlayerId(), 1.0)
			if not HasPedGotWeapon(PlayerPedId(),0xFBAB5776) then
				GiveDelayedWeaponToPed(PlayerPedId(),0xFBAB5776, 1, 0)
			end
			SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
		end
	end)
end

function makeEntityFaceEntity(crds, entity)
    local p2 = crds
    local p1 = GetEntityCoords(entity, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity, heading)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end

Draw = function(text,r,g,b,x,y)
	SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
	SetTextColour( r,g,b, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function FristPersonView()
	Citizen.CreateThread(function()
		while ingulag do
			Wait(0)
            DisableControlAction(0, 0, true)
			SetFollowPedCamViewMode(4)
			DisableControlAction(0, 22, true)
			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_HEAVYPISTOL"), true)
		end
		SetFollowPedCamViewMode(2)
	end)
end

function RespawnPed(ped, coords, heading)
	ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ESX.SetEntityHealth(ped, 200)
	ESX.SetPedArmour(ped, 0)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_status:setss', 'hunger', 1000000)
	TriggerEvent('esx_status:setss', 'thirst', 1000000)
	TriggerServerEvent('medic:setDeathState', false,false)
end

local canrevive = false


RegisterNetEvent('br:reviveth')
AddEventHandler('br:reviveth',function()
	canrevive = true
	Citizen.CreateThread(function()
			local coords = GetEntityCoords(PlayerPedId())
			SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, true)
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
			SetPlayerInvincible(PlayerPedId(), false)
			SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
		while canrevive do
			Wait(1)
			text = 'press [E] to heal your self'       
			DrawGenericTextThisFrame()
			ESX.SetEntityHealth(PlayerPedId(), 150)			
			exports['suncore']:canRagdoll(true, 1000)
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)			
			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end
	end)
end)

RegisterNetEvent('br:disablerevifexit')
AddEventHandler('br:disablerevifexit',function()
	canrevive = false
end)


AddEventHandler('onKeyUP',function(key)
	if key == 'e' then
		if canrevive then
			if ESX.progressCircle(3000, false, true) then
					canrevive = false
					ped = PlayerPedId()
					local ccrds = GetEntityCoords(PlayerPedId())
					ESX.SetEntityCoordsNoOffset(ped, ccrds.x, ccrds.y, ccrds.z, false, false, false, true)
					NetworkResurrectLocalPlayer(ccrds.x, ccrds.y,ccrds.z, 20, true, false)
					SetPlayerInvincible(ped, false)							
					ESX.SetPedArmour(ped, 0)						
					ClearPedBloodDamage(ped)
					local ccrds = GetEntityCoords(PlayerPedId())
					local crds = vector3(ccrds.x,ccrds.y,1000)
					ESX.SetEntityCoords(PlayerPedId(), crds)
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_status:setss', 'hunger', 1000000)
					TriggerEvent('esx_status:setss', 'thirst', 1000000)	
					Wait(3000)
					ESX.SetEntityHealth(ped, GetEntityMaxHealth(ped))			
					TriggerEvent('esx:addWeapon', "WEAPON_SNSPISTOL", 250)		
			end
		end
	end
end)

weapons = {
    'WEAPON_GUSENBERG' ,
    'WEAPON_MSCHINEPISTOL' ,
    'WEAPON_PISTOL',
    'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SMG',
    'WEAPON_SMG_MK2',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_ASSAULTRIFLE_MK2',
    'WEAPON_CARBINERIFLE',
    'WEAPON_CARBINERIFLE_MK2',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_BULLPUPRIFLE_MK2',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_COMBATPDW',
    'WEAPON_ASSAULTSMG',
}

function DropLoot()
	local allweapons = {}
	local coords = GetEntityCoords(PlayerPedId())
	for k , v in ipairs(weapons) do
		if HasPedGotWeapon(PlayerPedId(),GetHashKey(v)) then
			local ammo = GetAmmoInPedWeapon(PlayerPedId(),GetHashKey(v))
			RemoveWeaponFromPed(PlayerPedId(),GetHashKey(v))
			table.insert(allweapons,{name = v , ammo = ammo})
		end
	end
	local crdss = vector3(coords.x,coords.y - 4,coords.z)
	TriggerServerEvent('br:createdeadpickup',crdss,allweapons)
end

RegisterNetEvent('br:droploot')
AddEventHandler('br:droploot',function()
	DropLoot()
end)


RegisterNetEvent('br:pkilled')
AddEventHandler('br:pkilled',function(killername,killedname,wname,head)
	if inevent  then
	SendNUIMessage({
		type = 'addKill',
		killer = killername,
		weapon = wname,
		killed = killedname,
		headshot = head
	  })
	end
end)

AddEventHandler('event',function(state)
	inevent = state
end)

-- AddEventHandler('gameEventTriggered', function(name, args)
--     if name == 'CEventNetworkEntityDamage' then
--         local victim = args[1]
--         local attacker = args[2]
--         if GetEntityType(attacker) == 1 and GetEntityType(victim) == 1 then
--             if GetPlayerServerId(PlayerId()) == GetPlayerServerId(GetPlayerByEntityID(attacker)) then
--                 if GetPlayerServerId(PlayerId()) ~= GetPlayerServerId(GetPlayerByEntityID(victim)) then
--                     TriggerEvent('InteractSound_CL:PlayOnOne', 'hit', 0.35)
--                 end
--             end

--         end
--     end
-- end)

function GetPlayerByEntityID(id)
	for i=0,255 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end

function nczthread()
	Citizen.CreateThread(function()
		while ncz do 
			Wait(0)
				DisableControlAction(0, Keys['R'], true)
				DisableControlAction(0, 24, true) -- Attack
				DisableControlAction(0, 257, true) -- Attack 2
				DisableControlAction(0, 25, true) -- Right click
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 263, true) -- Melee Attack 1
		end
	end)
end