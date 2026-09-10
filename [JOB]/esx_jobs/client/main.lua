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

local PlayerData = {}
local menuIsShowed = false
local hintIsShowed = false
local hasAlreadyEnteredMarker = false
local Blips = {}
local JobBlips = {}
local firstLocationBlip = {}
local isInMarker = false
local isInPublicMarker = false
local playerjob = nil
local hintToDisplay = "no hint to display"
local onDuty = true
local spawner = 0
local myPlate = {}

local vehicleObjInCaseofDrop = nil
local vehicleInCaseofDrop = nil
local near = {active = false}
local vehicleMaxHealth = nil

local jobsplate = {
	["fisherman"] = "F",
	["fueler"] = "U",
	["lumberjack"] = "L",
	["slaughterer"] = "S",
	["tailor"] = "T"
}

-- ESX.GetPlayerData().rawid was a Sunset-only custom field. GetPlayerServerId
-- is a plain native, always available, and gives the same thing we actually
-- needed here: a short, unique-per-player number for the work-vehicle plate.
local function GetPlateSuffix()
	return tostring(GetPlayerServerId(PlayerId()))
end


ESX = nil

Citizen.CreateThread(function()
	DecorRegister("JobCenter",2)
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	----
	for jobKey,jobValues in pairs(Config.Jobs) do
		for zoneKey,zoneValues in pairs(jobValues.Zones) do

			if zoneValues.Blip and zoneKey == 'CloakRoom' then
				local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
				SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
				SetBlipDisplay (blip, 4)
				SetBlipScale   (blip, 1.2)
				SetBlipCategory(blip, 3)
				SetBlipColour  (blip, jobValues.BlipInfos.Color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(zoneValues.Name)
				EndTextCommandSetBlipName(blip)
				firstLocationBlip[jobKey] = blip
			else
				local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
				SetBlipSprite  (blip, 9)
				SetBlipDisplay (blip, 5)
				SetBlipScale   (blip, 0.1)
				SetBlipCategory(blip, 3)
				SetBlipColour  (blip, jobValues.BlipInfos.Color)
				SetBlipAsShortRange(blip, true)
			end
		end
	end
	refreshBlips()
end)

-- RegisterNetEvent('esx:inJob')
-- AddEventHandler('esx:inJob', function(name)
--     if (name == 'fisherman' or name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor') then
--         playerjob = name
-- 		--myPlate = {} -- loosing vehicle caution in case player changes job.
-- 		spawner = 0
--     else
--         playerjob = nil
--     end
-- 	deleteBlips()
-- 	refreshBlips()
-- end)

RegisterNetEvent('esx:inJob')
AddEventHandler('esx:inJob', function(name)
    if (name == 'fisherman' or name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor') then
        playerjob = name
		--myPlate = {} -- loosing vehicle caution in case player changes job.
		spawner = 0
    else
        playerjob = nil
    end
	deleteBlips()
	refreshBlips()
	SetResourceKvp('lastJob',name)
	hintIsShowed = false
end)

RegisterNetEvent('esx:SetVarOnDuty')
AddEventHandler('esx:SetVarOnDuty',function(name,duty)
	if name == 'fisherman' or name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor' then
		--onDuty = duty
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	--PlayerData = xPlayer
	--refreshBlips()
end)


function OpenMenu(job)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		elements = {
			{label = _U('job_wear'),     value = 'job_wear'},
			{label = _U('citizen_wear'), value = 'citizen_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'job_wear' then
			-- the admin uniform editor only updates Config server-side (it's
			-- a different Lua VM than the client's), so this has to ask the
			-- server for the current work_wear every time rather than
			-- reading this client's own local, never-updated config.lua copy
			ESX.TriggerServerCallback('esx_jobs:getActiveUniform', function(workWear)
				if not workWear then return end
				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, workWear.male)
					else
						TriggerEvent('skinchanger:loadClothes', skin, workWear.female)
					end
				end)
			end, job)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

exports('getLastJob',function()
	return GetResourceKvpString('lastJob')
end)

exports('openMenu',OpenMenu)

AddEventHandler('esx_jobs:action', function(job, zone)
	menuIsShowed = true
	if not zone then return end
	if zone.Type == "cloakroom" then
		OpenMenu(playerjob)
	elseif zone.Type == "work" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			TriggerServerEvent('esx_jobs:startWork', playerjob, zone.k)
		end
	elseif zone.Type == "vehspawner" then
		local spawnPoint = nil
		local vehicle = nil

		for k,v in pairs(Config.Jobs) do
			if playerjob == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehspawnpt" and w.Spawner == zone.Spawner then
						spawnPoint = w
						spawner = w.Spawner
					end
				end

				for m,x in pairs(v.Vehicles) do
					if x.Spawner == zone.Spawner then
						vehicle = x
					end
				end
			end
		end

		if ESX.Game.IsSpawnPointClear(spawnPoint.Pos, 5.0) then
			spawnVehicle(spawnPoint, vehicle, zone.Caution)
		else
			ESX.ShowNotification(_U('spawn_blocked'))
		end

	elseif zone.Type == "vehdelete" then
		local looping = true

		for k,v in pairs(Config.Jobs) do
			if playerjob == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehdelete" and w.Spawner == zone.Spawner then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then

							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")
							local driverPed = GetPedInVehicleSeat(vehicle, -1)

							if playerPed == driverPed then

								if jobsplate[playerjob] .. GetPlateSuffix() == plate then

									TriggerServerEvent('esx_jobs:cautionss', "give_back", 0, 0, 0)
									ESX.Game.DeleteVehicle(vehicle)
									if w.Teleport ~= 0 then
										ESX.Game.Teleport(playerPed, w.Teleport)
									end

									for m=#myPlate, 1, -1 do
										if myPlate[m] == plate then
											table.remove(myPlate, m)
										end
									end

									if vehicleObjInCaseofDrop and vehicleObjInCaseofDrop.HasCaution then
										vehicleInCaseofDrop = nil
										vehicleObjInCaseofDrop = nil
										vehicleMaxHealth = nil
									end

									break
								end

							else
								ESX.ShowNotification(_U('not_your_vehicle'))
							end

						end

						looping = false
						break
					end

					if looping == false then
						break
					end
				end
			end
			if looping == false then
				break
			end
		end
	elseif zone.Type == "delivery" then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		hintToDisplay = "no hint to display"
		hintIsShowed = false
		TriggerServerEvent('esx_jobs:startWork', playerjob, zone.k)
	end
	--nextStep(zone.GPS)
end)

function nextStep(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
		ESX.ShowNotification(_U('next_point'))
	end
end

AddEventHandler('esx_jobs:hasExitedMarker', function(zone)
	TriggerServerEvent('esx_jobs:stopWork')
	hintToDisplay = "no hint to display"
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

--[[RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	onDuty = false
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
end)]]

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local zones = {}
	local blipInfo = {}

	if playerjob ~= nil then
		for jobKey,jobValues in pairs(Config.Jobs) do

			if jobKey == playerjob then
				for zoneKey,zoneValues in pairs(jobValues.Zones) do

					if zoneValues.Blip and zoneKey ~= 'CloakRoom' then
						local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
						SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
						SetBlipDisplay (blip, 4)
						SetBlipScale   (blip, 1.2)
						SetBlipCategory(blip, 3)
						SetBlipColour  (blip, jobValues.BlipInfos.Color)
						SetBlipAsShortRange(blip, true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(zoneValues.Name)
						EndTextCommandSetBlipName(blip)
						table.insert(JobBlips, blip)
					end
				end
			end
		end
	end
end

-- ESX.getVehicleFromPlate was a Sunset-only custom function; stock ESX only
-- gives you ESX.Game.GetVehicles(), so loop through those and match plates.
local function GetVehicleFromPlate(plate)
	for _, vehicle in pairs(ESX.Game.GetVehicles()) do
		if DoesEntityExist(vehicle) then
			local vehPlate = string.gsub(GetVehicleNumberPlateText(vehicle), " ", "")
			if vehPlate == plate then
				return vehicle
			end
		end
	end
	return nil
end

function spawnVehicle(spawnPoint, vehicle, vehicleCaution)
	if not GetVehicleFromPlate(jobsplate[playerjob] .. GetPlateSuffix()) then
		hintToDisplay = 'no hint to display'
		hintIsShowed = false
		TriggerServerEvent('esx_jobs:cautionss', 'take', vehicleCaution, spawnPoint, vehicle)
		Spawn(spawnPoint, vehicle)
	else
		ESX.ShowNotification('Shoma ghablan yek mashin gereftid!')
	end
end

function Spawn(spawnPoint, vehicle)
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)
		DecorSetBool(spawnedVehicle,"JobCenter",true)
		-- if vehicle.Trailer ~= "none" then
		-- 	ESX.Game.SpawnVehicle(vehicle.Trailer, spawnPoint.Pos, spawnPoint.Heading, function(trailer)
		-- 		AttachVehicleToTrailer(spawnedVehicle, trailer, 1.1)
		-- 	end)
		-- end

		-- save & set plate
		local plate = jobsplate[playerjob] .. GetPlateSuffix()
		TriggerEvent("jobcarlock:setplate",plate)
		SetVehicleNumberPlateText(spawnedVehicle, plate)
		table.insert(myPlate, plate)
		plate = string.gsub(plate, " ", "")
          
		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
		if vehicle.HasCaution then
			vehicleInCaseofDrop = spawnedVehicle
			vehicleObjInCaseofDrop = vehicle
			vehicleMaxHealth = GetVehicleEngineHealth(spawnedVehicle)
		end
		TriggerEvent('esx:createvehiclekey')
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			SetVehicleFuelLevel(spawnedVehicle, 100.0)
		end)
	end)
end

-- Show top left hint
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if hintIsShowed then
			ESX.ShowHelpNotification(hintToDisplay)
		else
			Citizen.Wait(500)
		end
	end
end)

-- Draw a marker at the cloakroom, regardless of on/off duty (this used to be
-- handled by ESX.RegisterPoint, which this server doesn't have)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local zones = {}
		for k,v in pairs(Config.Jobs) do
			if playerjob == k then
				zones = v.Zones
			end
		end
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(zones) do
			if v.Type == "cloakroom" then
				if Vdist(coords, v.Pos.x, v.Pos.y, v.Pos.z) < Config.DrawDistance then
					DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z+0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 42, 255, 0, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Display markers (only if on duty and the player's job ones)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if near.active then
			DrawMarker(near.marker, near.coords.x, near.coords.y, near.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, near.size.x, near.size.y, near.size.z, near.color.r, near.color.g, near.color.b, 100, false, true, 2, false, false, false, false)
		else
			Citizen.Wait(500)
		end
	end
end)

function NearAny()
	
	local zones = {}

	if playerjob ~= nil then
		for k,v in pairs(Config.Jobs) do
			if playerjob == k then
				zones = v.Zones
			end
		end

		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(zones) do
			if onDuty and v.Type ~= "cloakroom" then
				if (v.Marker ~= -1 and Vdist(coords, v.Pos.x, v.Pos.y, v.Pos.z) < Config.DrawDistance) then
					near = {active = true, coords = vector3(v.Pos.x, v.Pos.y, v.Pos.z), marker = v.Marker, size = v.Size, color = v.Color}
					return
				end
			end
		end
	end

    near = {active = false}
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if playerjob then
			NearAny()
		end
    end
end)

-- Activate menu when player is inside marker
local zoneInfo = {active = false}

-- native key poll instead of relying on some other resource firing a
-- custom 'KeyDown:e' event -- this always works, no external dependency
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 38) then -- INPUT_CONTEXT (E)
			if zoneInfo.active then
				TriggerEvent('esx_jobs:action', zoneInfo.job, zoneInfo.zone)
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(500)

		if playerjob ~= nil and playerjob ~= 'nojob' then
			local zones = nil
			local job = nil

			for k,v in pairs(Config.Jobs) do
				if playerjob == k then
					job = v
					zones = v.Zones
				end
			end

			if zones ~= nil then
				local coords      = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone        = nil
				local lastZone    = nil

				for k,v in pairs(zones) do
					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
						isInMarker  = true
						currentZone = k
						v.k = k
						zone        = v
						break
					else
						isInMarker  = false
					end
				end

				if onDuty or (zone and zone.Type == "cloakroom") then
					zoneInfo.job = job
					zoneInfo.zone = zone or nil
					zoneInfo.active = true
				else
					zoneInfo.active = false
					ESX.UI.Menu.CloseAll()
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom") and zone.Type ~= "vehdelete" then
						hintToDisplay = zone.Hint
						hintIsShowed = true
					elseif zone.Type == "vehdelete" and onDuty then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local driverPed = GetPedInVehicleSeat(vehicle, -1)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then
										hintToDisplay = zone.Hint
										break
									end
								end

							else
								hintToDisplay = _U('not_your_vehicle')
							end
						else
							hintToDisplay = _U('in_vehicle')
						end
						hintIsShowed = true
					elseif onDuty and zone.Spawner ~= spawner then
						hintToDisplay = _U('wrong_point')
						hintIsShowed = true
					else
						if not isInPublicMarker then
							hintToDisplay = "no hint to display"
							hintIsShowed = false
						end
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('esx_jobs:hasExitedMarker', zone)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	-- Slaughterer
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")

	-- Tailor
	RequestIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
end)
RegisterNetEvent('startJob')
AddEventHandler('startJob',function(name)
    if firstLocationBlip[name] then
        SetNewWaypoint(GetBlipCoords(firstLocationBlip[name]).xy)
        SetBlipAsShortRange(firstLocationBlip[name],false)
        ESX.ShowNotification('~y~پوشیدن لباس:~s~ به این مکان بروید (پین شده در نقشه)، سپس لباس شغل خود را بپوشید')
    else
		for k , v in pairs(firstLocationBlip) do
			SetBlipAsShortRange(v,true)
		end
    end
end)
-- ===== Job Center (merged in from esx_joblisting) =====
local jobCenterMenuIsShowed = false
local jobCenterHasEnteredMarker = false
local isInJobCenterMarker = false

function ShowJobCenterMenu()
	ESX.TriggerServerCallback('esx_jobs:getJobsList', function(jobs)
		local elements = {}

		for i=1, #jobs, 1 do
			table.insert(elements, {
				label = jobs[i].label,
				job   = jobs[i].job
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_center', {
			title    = _U('job_center'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_jobs:setJob', data.current.job)
			ESX.ShowNotification(_U('new_job'))
			jobCenterMenuIsShowed = false
			menu.close()
		end, function(data, menu)
			jobCenterMenuIsShowed = false
			menu.close()
		end)
	end)
end

-- Marker + blip + keypress for the job center, independent of the player's
-- current job/duty (so it works even when Config.Jobs zones are hidden)
Citizen.CreateThread(function()
	local jc = Config.JobCenter
	local blip = AddBlipForCoord(jc.Pos.x, jc.Pos.y, jc.Pos.z)
	SetBlipSprite (blip, 498)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 60)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(_U('job_center'))
	EndTextCommandSetBlipName(blip)

	while true do
		Citizen.Wait(1)

		local coords = GetEntityCoords(PlayerPedId())
		local distance = GetDistanceBetweenCoords(coords, jc.Pos.x, jc.Pos.y, jc.Pos.z, true)
		isInJobCenterMarker = false

		if distance < jc.DrawDistance then
			DrawMarker(jc.MarkerType, jc.Pos.x, jc.Pos.y, jc.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, jc.Size.x, jc.Size.y, jc.Size.z, jc.MarkerColor.r, jc.MarkerColor.g, jc.MarkerColor.b, 100, false, true, 2, false, false, false, false)
		end

		if distance < (jc.Size.x / 2) then
			isInJobCenterMarker = true
			ESX.ShowHelpNotification(_U('access_job_center'))
		end

		if not isInJobCenterMarker and jobCenterHasEnteredMarker then
			jobCenterHasEnteredMarker = false
			ESX.UI.Menu.CloseAll()
			jobCenterMenuIsShowed = false
		elseif isInJobCenterMarker then
			jobCenterHasEnteredMarker = true
		end

		if isInJobCenterMarker and IsControlJustReleased(0, 38) and not jobCenterMenuIsShowed then
			jobCenterMenuIsShowed = true
			ESX.UI.Menu.CloseAll()
			ShowJobCenterMenu()
		end
	end
end)

-- ===== Admin uniform-editor pads (ox_target) =====
-- One pad next to each job's cloakroom. Admins (permission_level >= 15,
-- checked again server-side -- this client-side zone is just where the
-- prompt shows up, not the actual security boundary) get two options:
-- open the real skin-editor menu to save a new labeled version, or browse
-- the job's saved-uniform history to re-apply or delete an old one.
local function ShowUniformHistoryMenu(job)
	ESX.TriggerServerCallback('esx_jobs:getUniformHistory', function(data)
		if not data then return end

		local options = {}
		for _, gender in ipairs({'male', 'female'}) do
			local g = data[gender]
			if #g.history == 0 then
				table.insert(options, {
					title = ('%s -- no saved versions yet'):format(gender),
					disabled = true
				})
			else
				for i=1, #g.history, 1 do
					local entry = g.history[i]
					local isActive = (entry.id == g.active_id)
					table.insert(options, {
						title = ('[%s] %s%s'):format(gender, entry.label, isActive and ' -- ACTIVE' or ''),
						description = ('Saved %s'):format(entry.savedAt or '?'),
						icon = isActive and 'fas fa-star' or 'fas fa-shirt',
						disabled = isActive, -- already active, nothing to "apply"
						onSelect = function()
							TriggerServerEvent('esx_jobs:adminApplyUniformHistory', job, gender, entry.id)
						end
					})
					table.insert(options, {
						title = ('Delete "%s" [%s]'):format(entry.label, gender),
						icon = 'fas fa-trash',
						iconColor = '#ff4444',
						onSelect = function()
							TriggerServerEvent('esx_jobs:adminDeleteUniformHistory', job, gender, entry.id)
						end
					})
				end
			end
		end

		lib.registerContext({
			id = 'esx_jobs_uniform_history',
			title = (Config.JobLabels[job] or job) .. ' uniform history',
			options = options
		})
		lib.showContext('esx_jobs_uniform_history')
	end, job)
end

local function SpawnUniformEditorPed(job, jobData)
	local cloak = jobData.Zones and jobData.Zones.CloakRoom
	if not cloak then return end

	local override = Config.UniformEditorPadOverride and Config.UniformEditorPadOverride[job]
	local padPos = override
		and {x = override.x, y = override.y, z = override.z}
		or {x = cloak.Pos.x + 1.0, y = cloak.Pos.y, z = cloak.Pos.z - 1.0}
	local padHeading = (override and override.heading) or 0.0
	local model = GetHashKey('a_m_y_business_01')

	Citizen.CreateThread(function()
		RequestModel(model)
		local timeout = 0
		while not HasModelLoaded(model) and timeout < 500 do
			Citizen.Wait(10)
			timeout = timeout + 1
		end
		if not HasModelLoaded(model) then return end

		-- snap to actual ground level -- a manually-reported or guessed Z
		-- can easily end up slightly off and leave the ped floating/sunken.
		-- Request collision first, otherwise GetGroundZFor_3dCoord can just
		-- silently fail if this spot isn't streamed in yet.
		RequestCollisionAtCoord(padPos.x, padPos.y, padPos.z)
		local groundTimeout = 0
		local foundGround, groundZ = false, padPos.z
		while not foundGround and groundTimeout < 50 do
			foundGround, groundZ = GetGroundZFor_3dCoord(padPos.x, padPos.y, padPos.z + 5.0, false)
			if not foundGround then
				Citizen.Wait(10)
				groundTimeout = groundTimeout + 1
			end
		end
		if foundGround then
			padPos.z = groundZ
		end

		local ped = CreatePed(4, model, padPos.x, padPos.y, padPos.z, padHeading, false, false)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		FreezeEntityPosition(ped, true)
		SetEntityAsMissionEntity(ped, true, true)
		TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
		SetModelAsNoLongerNeeded(model)

		exports.ox_target:addLocalEntity(ped, {
			{
				label = 'Save new ' .. (Config.JobLabels[job] or job) .. ' uniform (admin)',
				icon = 'fas fa-tshirt',
				onSelect = function()
					TriggerEvent('esx_skin:openMenu', function(_, menu)
						menu.close()
						TriggerEvent('skinchanger:getSkin', function(skin)
							local input = lib.inputDialog(('Save %s uniform'):format(Config.JobLabels[job] or job), {
								{type = 'input', label = 'Name for this version', required = true, default = 'Version'}
							})
							if not input or not input[1] then return end
							TriggerServerEvent('esx_jobs:adminSaveUniform', job, skin, input[1])
						end)
					end)
				end
			},
			{
				label = 'Manage ' .. (Config.JobLabels[job] or job) .. ' uniform history (admin)',
				icon = 'fas fa-clock-rotate-left',
				onSelect = function()
					ShowUniformHistoryMenu(job)
				end
			}
		})
	end)
end

Citizen.CreateThread(function()
	for job, jobData in pairs(Config.Jobs) do
		SpawnUniformEditorPed(job, jobData)
	end

	-- miner isn't part of Config.Jobs (it's a standalone system, not the
	-- Zone-based cloakroom setup), but it has its own locker room at
	-- Config.Miner.ClackLoc -- reuse the same pad function there too
	SpawnUniformEditorPed('miner', {
		Zones = {
			CloakRoom = {
				Pos = {x = Config.Miner.ClackLoc.x, y = Config.Miner.ClackLoc.y, z = Config.Miner.ClackLoc.z}
			}
		}
	})
end)
