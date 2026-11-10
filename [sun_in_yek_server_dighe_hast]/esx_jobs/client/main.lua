-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

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
local JobBlips = {}
local firstLocationBlip = {}
local isInMarker = false
local playerjob = nil
local hintToDisplay = "no hint to display"
local onDuty = true
local myPlate = {}

local vehicleObjInCaseofDrop = nil
local vehicleInCaseofDrop = nil
local near = {active = false}
local vehicleMaxHealth = nil
local workingProgress = false
local workSessionId = 0


AddEventHandler('KeyDown:lmenu', function()
	if workingProgress and lib.progressActive() then
		ESX.ShowNotification(_U('wait_progress'))
	end
end)

local jobSkills = {
	['fueler'] = { key = 'palayeshgah_skill', key2 = { OilFarm = 'farm_petrol', OilRefinement = 'farm_petrol_raffin', OilMix = 'farm_essence' } },
	['lumberjack'] = { key = 'chobbori_skill', key2 = { Wood = 'farm_wood', CuttedWood = 'farm_cutted_wood', Planks = 'farm_packaged_plank' } },
	['slaughterer'] = { key = 'ghasab_skill', key2 = { AliveChicken = 'farm_alive_chicken', SlaughterHouse = 'farm_slaughtered_chicken', Packaging = 'farm_packaged_chicken' } },
	['tailor'] = { key = 'clothe_skill', key2 = { Wool = 'farm_wool', Fabric = 'farm_fabric', Clothe = 'farm_clothe' } },
}

local jobsplate = {
	["fueler"] = "U",
	["lumberjack"] = "L",
	["slaughterer"] = "S",
	["tailor"] = "T"
}


ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	for k,v in pairs(Config.Jobs) do
		for k2,v2 in pairs(v.Zones) do
			if v2.Type == "cloakroom" then
				ESX.RegisterPoint(vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z),2,{
					Color = {R = 42,G = 255,B = 0,A = 255},
					DrawDistance = 20,
					Radius = 0.5,
					Type = 27
				},{
					Notification = nil,
					DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu job',
					DrawTextRadius = 4,
					DrawTextCoords = vector3(v2.Pos.x, v2.Pos.y, v2.Pos.z + 1),
					Key = 'e',
					CB = function()
						OpenMenu(k)
					end,
				},{
					In = nil,
					Out = ESX.UI.Menu.CloseAll
				})	
			end
		end
	end
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
    if (name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor') then
        playerjob = name
		--myPlate = {} -- loosing vehicle caution in case player changes job.
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
	if name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor' then
		--onDuty = duty
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	--PlayerData = xPlayer
	--refreshBlips()
end)

-- function OpenMenu(job)
-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
-- 	{
-- 		title    = _U('cloakroom'),
-- 		elements = {
-- 			{label = _U('job_wear'),     value = 'job_wear'},
-- 			{label = _U('citizen_wear'), value = 'citizen_wear'}
-- 		}
-- 	}, function(data, menu)
-- 		if data.current.value == 'citizen_wear' then
-- 			local clothe = GetResourceKvpString('citizenWear')
-- 			if clothe then
-- 				clothe = json.decode(clothe)
-- 				TriggerEvent('skinchanger:loadSkin', clothe,function()
-- 					TriggerEvent('skinchanger:getSkin', function(skin)
-- 						TriggerServerEvent('esx_skin:save', skin)
-- 					end)
-- 				end)
-- 				SetResourceKvp('citizenWear',nil)
-- 			end
-- 		elseif data.current.value == 'job_wear' then
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				local clothe = GetResourceKvpString('citizenWear')
-- 				if not clothe then
-- 					local data = json.encode(skin)
-- 					SetResourceKvp('citizenWear',data)
-- 				end
-- 			end)
-- 			local data = exports['sunset_helper']:getJobsClothe()
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				if skin.sex == 0 then
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male)
-- 				else
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female)
-- 				end
-- 				TriggerEvent('skinchanger:getSkin', function(skin)
-- 					TriggerServerEvent('esx_skin:save', skin)
-- 				end)
-- 			end)
-- 		end
-- 		menu.close()
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

-- function OpenMenu(job)
-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
-- 	{
-- 		title    = _U('cloakroom'),
-- 		elements = {
-- 			{label = _U('job_wear'),     value = 'job_wear'},
-- 			{label = _U('citizen_wear'), value = 'citizen_wear'}
-- 		}
-- 	}, function(data, menu)
-- 		if data.current.value == 'citizen_wear' then
-- 			local clothe = GetResourceKvpString('citizenWear')
-- 			if clothe and clothe ~= '' then
-- 				clothe = json.decode(clothe)
-- 				TriggerEvent('skinchanger:loadSkin', clothe,function()
-- 					TriggerEvent('skinchanger:getSkin', function(skin)
-- 						TriggerServerEvent('esx_skin:save', skin)
-- 					end)
-- 				end)
-- 				SetResourceKvp('citizenWear','')
-- 			end
-- 		elseif data.current.value == 'job_wear' then
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				local clothe = GetResourceKvpString('citizenWear')
-- 				if not clothe or clothe == '' then
-- 					local data = json.encode(skin)
-- 					SetResourceKvp('citizenWear',data)
-- 				end
-- 			end)
-- 			local data = exports['sunset_helper']:getJobsClothe()
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				if skin.sex == 0 then
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male)
-- 				else
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female)
-- 				end
-- 				TriggerEvent('skinchanger:getSkin', function(skin)
-- 					TriggerServerEvent('esx_skin:save', skin)
-- 				end)
-- 			end)
-- 		end
-- 		menu.close()
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

-- function OpenMenu(job)
-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
-- 	{
-- 		title    = _U('cloakroom'),
-- 		elements = {
-- 			{label = _U('job_wear'),     value = 'job_wear'},
-- 			{label = _U('citizen_wear'), value = 'citizen_wear'}
-- 		}
-- 	}, function(data, menu)
-- 		if data.current.value == 'citizen_wear' then
-- 			local clothe = GetResourceKvpString('citizenWear')
-- 			if clothe and clothe ~= '' and exports['sunset_helper']:getJob() ~= 'nojob' then
-- 				clothe = json.decode(clothe)
-- 				TriggerEvent('skinchanger:getSkin', function(skin)
-- 					if skin.sex == 0 then
-- 						TriggerEvent('skinchanger:loadClothes', skin, clothe)
-- 					else
-- 						TriggerEvent('skinchanger:loadClothes', skin, clothe)
-- 					end
-- 					Citizen.Wait(2000)
-- 					TriggerEvent('skinchanger:getSkin', function(skin)
-- 						TriggerServerEvent('esx_skin:save', skin)
-- 					end)
-- 				end)
-- 				-- TriggerEvent('skinchanger:loadSkin', clothe,function()
-- 				-- 	TriggerEvent('skinchanger:getSkin', function(skin)
-- 				-- 		TriggerServerEvent('esx_skin:save', skin)
-- 				-- 	end)
-- 				-- end)
-- 				SetResourceKvp('citizenWear','')
-- 			end
-- 		elseif data.current.value == 'job_wear' then
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				local clothe = GetResourceKvpString('citizenWear')
-- 				if not clothe or clothe == '' or exports['sunset_helper']:getJob() == 'nojob' then
-- 					local data = json.encode(skin)
-- 					SetResourceKvp('citizenWear',data)
-- 				end
-- 			end)
-- 			local data = exports['sunset_helper']:getJobsClothe()
-- 			TriggerEvent('skinchanger:getSkin', function(skin)
-- 				if skin.sex == 0 then
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male)
-- 				else
-- 					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female)
-- 				end
-- 				Citizen.Wait(2000)
-- 				TriggerEvent('skinchanger:getSkin', function(skin)
-- 					TriggerServerEvent('esx_skin:save', skin)
-- 				end)
-- 			end)
-- 		end
-- 		menu.close()
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end


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
			local clothe = GetResourceKvpString('citizenWear')
			if clothe and clothe ~= '' and exports['sunset_helper']:getJob() ~= 'nojob' then
				clothe = json.decode(clothe)
				local data = exports['sunset_helper']:getJobsClothe()
				TriggerEvent('skinchanger:getSkin', function(skin)
					if skin.sex == 0 then
						exports['sunset_clothe']:removeStuffJob(data[job].skin_male)
					else
						exports['sunset_clothe']:removeStuffJob(data[job].skin_female)
					end
					Citizen.Wait(500)
					exports['sunset_clothe']:loadPack(clothe)
				end)
				SetResourceKvp('citizenWear','')
			end
		elseif data.current.value == 'job_wear' then
			local clothe = GetResourceKvpString('citizenWear')
			if not clothe or clothe == '' or exports['sunset_helper']:getJob() == 'nojob' then
				SetResourceKvp('citizenWear',json.encode(exports['sunset_clothe']:getUsed()))
			end
			local data = exports['sunset_helper']:getJobsClothe()
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_male,true)
				else
					TriggerEvent('skinchanger:loadClothes', skin, data[job].skin_female,true)
				end
			end)
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

AddEventHandler('esx_jobs:offMe',function()
	local clothe = GetResourceKvpString('citizenWear')
	if clothe and clothe ~= '' and exports['sunset_helper']:getJob() ~= 'nojob' then
		clothe = json.decode(clothe)
		local data = exports['sunset_helper']:getJobsClothe()
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				exports['sunset_clothe']:removeStuffJob(data[exports['sunset_helper']:getJob()].skin_male)
			else
				exports['sunset_clothe']:removeStuffJob(data[exports['sunset_helper']:getJob()].skin_female)
			end
			Citizen.Wait(500)
			exports['sunset_clothe']:loadPack(clothe)
		end)
		SetResourceKvp('citizenWear','')
	end
end)

function getItemCount(itemName)
	for _, v in pairs(ESX.GetPlayerData().inventory) do
		if v.name == itemName then
			return v.count
		end
	end
	return 0
end

function canStartWork(zone)
	local item = zone.Item[1]
	if item.requires ~= "nothing" then
		if getItemCount(item.requires) < item.remove then
			ESX.ShowNotification(_U('not_enough', item.requires_name))
			return false
		end
	end
	if getItemCount(item.db_name) + item.add > item.max then
		ESX.ShowNotification(_U('max_limit', item.name))
		return false
	end
	return true
end

function startWorkProgress(job, zone)
	if workingProgress then return end
	workingProgress = true
	workSessionId = workSessionId + 1
	local mySession = workSessionId
	Citizen.CreateThread(function()
		while workingProgress and workSessionId == mySession do
			if not canStartWork(zone) then
				workingProgress = false
				menuIsShowed = false
				TriggerServerEvent('esx_jobs:stopWork')
				break
			end
			local time = zone.Item[1].time
			if jobSkills[job] and jobSkills[job].key2[zone.k] then
				local skillTime = exports['sunset_utils']:getSkillTime(jobSkills[job].key, jobSkills[job].key2[zone.k])
				if skillTime then
					time = skillTime
				end
			end
			if lib.progressActive() then
				lib.cancelProgress()
			end
			ESX.progressCircle(time, false, false)
		end
	end)
end

AddEventHandler('esx_jobs:action', function(job, zone)
	if not zone then return end
	menuIsShowed = true
	if zone.Type == "cloakroom" then
		--OpenMenu()
	elseif zone.Type == "work" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			if not workingProgress and canStartWork(zone) then
				ESX.TriggerServerEvent('esx_jobs:startWork', playerjob, zone.k)
				startWorkProgress(playerjob, zone)
			else
				menuIsShowed = false
			end
		end
	elseif zone.Type == "vehspawner" then
		local spawnPoint = nil
		local vehicle = nil

		for k,v in pairs(Config.Jobs) do
			if playerjob == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehspawnpt" and w.Spawner == zone.Spawner then
						spawnPoint = w
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

								--for i=1, #myPlate, 1 do
									if jobsplate[playerjob] .. ESX.GetPlayerData().rawid == plate then

										--local vehicleHealth = GetVehicleEngineHealth(vehicleInCaseofDrop)
										--local giveBack = ESX.Math.Round(vehicleHealth / vehicleMaxHealth, 2)

										ESX.TriggerServerEvent('miniJobs:cautionss', "give_back", giveBack, 0, 0)
										--DeleteVehicle(GetVehiclePedIsIn(playerPed, false))
										ESX.Game.DeleteVehicle(vehicle)

										table.remove(myPlate, i)

										if vehicleObjInCaseofDrop.HasCaution then
											vehicleInCaseofDrop = nil
											vehicleObjInCaseofDrop = nil
											vehicleMaxHealth = nil
										end

										break
									end
								--end

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
	end
end)

AddEventHandler('esx_jobs:hasExitedMarker', function(zone)
	workingProgress = false
	if lib.progressActive() then
		lib.cancelProgress()
	end
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

function spawnVehicle(spawnPoint, vehicle, vehicleCaution)
	if not ESX.getVehicleFromPlate(jobsplate[playerjob] .. ESX.GetPlayerData().rawid) then
		hintToDisplay = 'no hint to display'
		hintIsShowed = false
		ESX.TriggerServerEvent('miniJobs:cautionss', 'take', vehicleCaution, spawnPoint, vehicle)
		Spawn(spawnPoint, vehicle)
	else
		ESX.ShowNotification('Shoma ghablan yek mashin gereftid!')
	end
end

function Spawn(spawnPoint, vehicle)
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)
		ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(spawnedVehicle), 'JobCenter', true, jobsplate[playerjob] .. ESX.GetPlayerData().rawid)
		-- if vehicle.Trailer ~= "none" then
		-- 	ESX.Game.SpawnVehicle(vehicle.Trailer, spawnPoint.Pos, spawnPoint.Heading, function(trailer)
		-- 		AttachVehicleToTrailer(spawnedVehicle, trailer, 1.1)
		-- 	end)
		-- end

		-- save & set plate
		--local plate = 'WORK' .. math.random(100, 900)
		local plate = jobsplate[playerjob] .. ESX.GetPlayerData().rawid
		TriggerEvent("jobcarlock:setplate",plate)
		ESX.SetVehicleNumberPlateText(spawnedVehicle, plate)
		table.insert(myPlate, plate)
		plate = string.gsub(plate, " ", "")
          
		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
		ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(spawnedVehicle), 'ownerLevel', ESX.GetPlayerData().SelfLevel)
		if vehicle.HasCaution then
			vehicleInCaseofDrop = spawnedVehicle
			vehicleObjInCaseofDrop = vehicle
			vehicleMaxHealth = GetVehicleEngineHealth(spawnedVehicle)
		end
		TriggerEvent('esx:createvehiclekey')
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			ESX.setVehicleFuel(spawnedVehicle, 100.0)
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
				if v.Marker ~= -1 and Vdist(coords, v.Pos.x, v.Pos.y, v.Pos.z) < (v.Size.w or Config.DrawDistance) then
					near = {active = true, coords = vector3(v.Pos.x, v.Pos.y, v.Pos.z - 1), marker = v.Marker, size = v.Size, color = v.Color}
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

AddEventHandler('KeyDown:e',function()
	if not ESX.inRealWorld() then return end
	if workingProgress then return end
	if zoneInfo.active then
		if zoneInfo then
			TriggerEvent('esx_jobs:action', zoneInfo.job, zoneInfo.zone)
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
					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x / 2 then
						isInMarker  = true
						currentZone = k
						v.k = k
						zone        = v
						break
					else
						isInMarker  = false
					end
				end

				if zone and (onDuty or zone.Type == "cloakroom") then
					zoneInfo.job = job
					zoneInfo.zone = zone
					zoneInfo.active = true
				else
					zoneInfo.active = false
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if onDuty and zone.Type ~= "vehdelete" and zone.Type ~= "cloakroom" then
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
					else
						hintToDisplay = "no hint to display"
						hintIsShowed = false
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
local tOut = 0
AddEventHandler('startJob',function(name)
    if firstLocationBlip[name] then
        SetNewWaypoint(GetBlipCoords(firstLocationBlip[name]).xy)
        SetBlipAsShortRange(firstLocationBlip[name],false)
        exports.sunset_helper:LoadNotif({title = 'پوشیدن لباس', text = "به این مکان بروید (پین شده در نقشه)، سپس لباس شغل خود را بپوشید", picture = Config.Jobs[name].pic})
		ESX.ClearTimeout(tOut)
		tOut = ESX.SetTimeout(15000,function()
			exports.sunset_helper:UnLoadNotif()
		end)
    else
		for k , v in pairs(firstLocationBlip) do
			SetBlipAsShortRange(v,true)
		end
    end
end)