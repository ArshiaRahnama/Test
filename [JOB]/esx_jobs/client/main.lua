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

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	for jobKey,jobValues in pairs(Config.Jobs) do
		for zoneKey,zoneValues in pairs(jobValues.Zones) do

			if zoneValues.Blip and zoneKey == 'CloakRoom' then
				local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
				SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
				SetBlipDisplay (blip, 4)
				SetBlipScale(blip, 0.7)
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
				SetBlipScale(blip, 0.7)
				SetBlipCategory(blip, 3)
				SetBlipColour  (blip, jobValues.BlipInfos.Color)
				SetBlipAsShortRange(blip, true)
			end
		end
	end
	refreshBlips()
end)

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
						SetBlipScale(blip, 0.7)
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

RegisterNetEvent('esx:inJob')
AddEventHandler('esx:inJob', function(name)
    if (name == 'fisherman' or name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor') then
        playerjob = name

		spawner = 0
    else
        playerjob = nil
    end
	deleteBlips()
	refreshBlips()
end)

RegisterNetEvent('esx:SetVarOnDuty')
AddEventHandler('esx:SetVarOnDuty',function(name,duty)
	if name == 'fisherman' or name == 'fueler' or name == 'lumberjack' or name == 'slaughterer'  or name == 'tailor' then

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)


end)

function OpenMenu(job)
	ESX.UI.Menu.CloseAll()
	local lebasmenu

	if job.JobName == 'fueler' then
		lebasmenu = Config.Uniforms_Fueler
	elseif job.JobName == 'lumberjack' then
		lebasmenu = Config.Uniforms_Lumberjack
	elseif job.JobName == 'slaughterer' then
		lebasmenu = Config.Uniforms_Slaughterer
	elseif job.JobName == 'tailor' then
		lebasmenu = Config.Uniforms_Tailor
	end

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
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then

					TriggerEvent('skinchanger:loadClothes', skin, lebasmenu['work_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, lebasmenu['work_wear'].male)
				end
				menu.close()
			end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

exports('openMenu',OpenMenu)

AddEventHandler('esx_jobs:action', function(job, zone)

	menuIsShowed = true
	if not zone then return end
	if zone.Type == "cloakroom" then
		OpenMenu(job)
	elseif zone.Type == "work" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			TriggerServerEvent('esx_jobs:starServerTestprpWork', zone.Item)
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

    for k, v in pairs(Config.Jobs) do
        if playerjob == k then
            for l, w in pairs(v.Zones) do
                if w.Type == "vehdelete" and w.Spawner == zone.Spawner then
                    local playerPed = PlayerPedId()

                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local plate = "UNKNOWN"
                    local driverPed = nil

                    if vehicle and vehicle ~= 0 then
                        plate = GetVehicleNumberPlateText(vehicle)
                        plate = string.gsub(plate, " ", "")
                        driverPed = GetPedInVehicleSeat(vehicle, -1)
                    end

                    if not vehicle or vehicle == 0 or not driverPed or playerPed == driverPed then

                        TriggerServerEvent('esx_jobs:cascaryution', "give_back", giveBack, 0, 0)
                        TriggerServerEvent('esx_jobs:addVehicle', nil)

                        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
                            ESX.Game.DeleteVehicle(vehicle)
                            if DoesEntityExist(vehicle) then
                                DeleteEntity(vehicle)
                            else
                            end
                        else
                        end

                        if w.Teleport ~= 0 then
                            ESX.Game.Teleport(playerPed, w.Teleport)
                        end

                        for i, v in ipairs(myPlate) do
                            if v == plate then
                                table.remove(myPlate, i)
                                break
                            end
                        end

                        if vehicleObjInCaseofDrop and vehicleObjInCaseofDrop.HasCaution then
                            vehicleInCaseofDrop = nil
                            vehicleObjInCaseofDrop = nil
                            vehicleMaxHealth = nil
                        end
                    else
                        ESX.ShowNotification(_U('not_your_vehicle'))
                    end

                    looping = false
                    break
                end

                if not looping then break end
            end
        end
        if not looping then break end
    end

	elseif zone.Type == "delivery" then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		hintToDisplay = "no hint to display"
		hintIsShowed = false
		TriggerServerEvent('esx_jobs:starServerTestprpWork', zone.Item)
	end

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
	TriggerServerEvent('esx_jobs:stoServerTestprpWork')
	hintToDisplay = "no hint to display"
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

GetPlate = function(vehicle)
    if vehicle == 0 then return end
    return ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
end

getVehicleFromPlate = function(plate)
	if plate then
		local vehicles = ESX.Game.GetVehicles()
		for k , v in pairs(vehicles) do
			local _ = GetPlate(v)
			if _ == plate then
				return v
			end
		end
	else
		return nil
	end
end

function spawnVehicle(spawnPoint, vehicle, vehicleCaution)
	if not getVehicleFromPlate(jobsplate[playerjob]) then
		hintToDisplay = 'no hint to display'
		hintIsShowed = false
		TriggerServerEvent('esx_jobs:cascaryution', 'take', vehicleCaution, spawnPoint, vehicle)
		Spawn(spawnPoint, vehicle)
	else
		ESX.ShowNotification('Shoma ghablan yek mashin gereftid!')
	end
end

function Spawn(spawnPoint, vehicle)
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)
		DecorSetBool(spawnedVehicle,"JobCenter",true)









		table.insert(myPlate, plate)


		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)

		if vehicle.HasCaution then
			vehicleInCaseofDrop = spawnedVehicle
			vehicleObjInCaseofDrop = vehicle
			vehicleMaxHealth = GetVehicleEngineHealth(spawnedVehicle)
		end
		local NetID = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(-1)))
		TriggerServerEvent('esx_jobs:addVehicle', NetID)
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)), 100.0)
		end)
	end )
end

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
					DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z+0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0,  1.0,  1.0, 42, 255, 0, 100, false, true, 2, false, false, false, false)
				end
			end
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

local zoneInfo = {active = false}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

	end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "e" then
		if zoneInfo.active then
			if zoneInfo then
				TriggerEvent('esx_jobs:action', zoneInfo.job, zoneInfo.zone)
			end
		end
	end
end)

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

	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")


	RequestIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
end)

RegisterNetEvent("startJob")
AddEventHandler("startJob",function(name)

    if firstLocationBlip[name] then
        SetNewWaypoint(GetBlipCoords(firstLocationBlip[name]).xy)
        SetBlipAsShortRange(firstLocationBlip[name],false)
		ESX.ShowNotification("Be Mahal ~p~Pin~w~ Shode Beravid Sepas Lebas Shoghl Khod Ra Beposhid!")





    else
		for k , v in pairs(firstLocationBlip) do
			SetNewWaypoint(GetEntityCoords(GetPlayerPed(-1)))
			SetBlipAsShortRange(v,true)
		end
    end
end)