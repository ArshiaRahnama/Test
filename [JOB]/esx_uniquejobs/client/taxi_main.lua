
local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead, CurrentActionData = false, false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg
local blipstaxi               = {}

ESX = nil
local hasAlreadyJoined        = false
carblip = 0
local PlayerData = {}
local hash = Config_taxi.hash
local vehicleHash = Config_taxi.vehicleHash
local ped = nil
local taxiBlip = false
local globalTaxi = nil
local customer = nil
local onTour = false
local driveFinish = nil
local onWayBack = false

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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

-- Vehicles added live via esx_society's /addcarjob command (job = taxi) get merged
-- into the static AuthorizedVehicles/AuthorizedHelis catalog, and their livery
-- (captured at add-time) is always re-applied on spawn so it never changes.
local CustomVehicleLiveries  = {}
local InjectedVehicleEntries = {}
local InjectedHeliEntries    = {}

local function removeInjected_taxi(list, injected)
	for _, entry in ipairs(injected) do
		for i = #list, 1, -1 do
			if list[i] == entry then
				table.remove(list, i)
			end
		end
	end
end

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(10) end

	local function mergeCustomVehicles()
		ESX.TriggerServerCallback('esx_society:getCustomVehicles', function(list)
			removeInjected_taxi(Config_taxi.AuthorizedVehicles.Shared, InjectedVehicleEntries)
			removeInjected_taxi(Config_taxi.AuthorizedHelis.Shared, InjectedHeliEntries)
			InjectedVehicleEntries = {}
			InjectedHeliEntries    = {}
			CustomVehicleLiveries  = {}

			local taxiCustom = list and list['taxi']
			if not taxiCustom then return end

			for _, v in ipairs(taxiCustom) do
				local entry = {label = v.label, model = v.model}

				if v.is_heli == 1 then
					table.insert(Config_taxi.AuthorizedHelis.Shared, entry)
					table.insert(InjectedHeliEntries, entry)
				else
					table.insert(Config_taxi.AuthorizedVehicles.Shared, entry)
					table.insert(InjectedVehicleEntries, entry)
				end

				CustomVehicleLiveries[v.model] = tonumber(v.livery) or 0
			end
		end)
	end

	mergeCustomVehicles()

	RegisterNetEvent('society:customVehiclesUpdated')
	AddEventHandler('society:customVehiclesUpdated', mergeCustomVehicles)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
end)

function SetVehicleMaxMods_taxi(vehicle)
	local props = {
		modEngine       = 10,
		modBrakes       = 10,
		color1       	= 126,
		windowTint		= 1,

		color2       	= 73,
		modTransmission = 10,
		modSuspension   = 10,
		modArmor        = 10,
		modTurbo        = true,
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function DrawSub_taxi(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt_taxi(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(1)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

function GetRandomWalkingNPC_taxi()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission_taxi()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end

function StartTaxiJob_taxi()
	ShowLoadingPromt_taxi(_U('taking_service'), 5000, 3)
	ClearCurrentMission_taxi()

	OnJob = true
end

function StopTaxiJob_taxi()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission_taxi()
	OnJob = false
	DrawSub_taxi(_U('mission_complete'), 5000)
end

function OpenCloakroom_taxi()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
		local elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = _U('wear_work'),    value = 'wear_work'}
		}

		for k, v in pairs(check) do

            if v.status == true then
                table.insert(elements, {
                    label = 'Lebas Division',
					diviname = v.name,
					value = 'division_lebas',

                })
            end

        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
		{
			title    = _U('cloakroom_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'division_lebas' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					local job =  ESX.PlayerData.job.name
					ESX.TriggerServerCallback('esx_society:getUniformsDivision', function(SkinMale, SkinFemale)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end
					end, data.current.diviname, job)

				end)
			end

			if data.current.value == 'wear_citizen' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			elseif data.current.value == 'wear_work' then
				local job =  ESX.PlayerData.job.name
				local grade =  ESX.PlayerData.job.grade
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
					else
						TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
					end
				end, grade, job)
				end)
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'cloakroom'
			CurrentActionMsg  = _U('cloakroom_prompt')
			CurrentActionData = {}
		end)
	end)
end

function OpenVehicleSpawnerMenu_taxi(station, partNum)
	local Vehicles = Config_taxi.AuthorizedVehicles.Shared
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = ESX.GetPlayerData().job.grade
	local job = ESX.GetPlayerData().job.name
	local steamhex = ESX.GetPlayerData().identifier
	ESX.TriggerServerCallback('esx_society:getVehicles', function(authorizedVehicle)

		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil

			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getVehiclesdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_taxi.AuthorizedVehicles.Shared
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_taxi.AuthorizedVehicles.Shared
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = _U('spawn_veh'),
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Vehicle Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Mashin be moafaghiat hazf shod'}
													})
												end, "TX" .. plate[1])
												menu.close()

												Wait(1000)
												spawnvehicles_taxi(data, plate, vehicle)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnvehicles_taxi(data, plate, vehicle)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Mashin Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "TX" .. plate[1])
								end
							end
							requestPlate()
						else
							ESX.ShowNotification(_U('vehicle_out'))
						end
					end

				end, function(data, menu)
					menu.close()

					CurrentAction     = 'menu_vehicle_spawner'
					CurrentActionMsg  = _U('vehicle_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, steamhex)
	end, grade, job)
end

function OpenheliSpawnerMenu_taxi()
	local vehicles = Config_taxi.AuthorizedHelis.Shared
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = ESX.PlayerData.job.grade
	local job = ESX.PlayerData.job.name
	ESX.TriggerServerCallback('esx_society:getHelis', function(authorizedVehicle)
		ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
			dvisionName = nil
			for k,v in pairs(getdivision) do
				if v.status and v.job == job then


					dvisionName = v.name
				end
			end
			ESX.TriggerServerCallback('esx_society:getHelisdivision', function(authorizedVehicledivision)


				local found = false

				if authorizedVehicle ~= nil then
					local Vehicles = Config_taxi.AuthorizedHelis.Shared
					for i = 1, #Vehicles, 1 do
					local found = false


					if authorizedVehicle ~= nil then
						for _,sharedVeh in ipairs(authorizedVehicle) do
							if found then break end
								if sharedVeh.model == Vehicles[i].model and sharedVeh.status == true then
									table.insert(elements, {label = Vehicles[i].label, model = Vehicles[i].model})
									found = true


								end
							end

						end
					end

				end

				if authorizedVehicledivision then
					table.insert(elements, {label = '------ Division ------', model = nil})
					local nnname = nil
					local Vehicles2 = Config_taxi.AuthorizedHelis.Shared
					for i = 1, #Vehicles2, 1 do
						nnname = nil
						for t,vehs in pairs(authorizedVehicledivision) do
							for k,v in pairs(elements) do
								if vehs.status and Vehicles2[i].model == vehs.model then
									if v.model == vehs.model then
										nnname = nil
										break
									else
										nnname = vehs.model
									end
								end
							end
							if nnname then

								table.insert(elements, {label = Vehicles2[i].label, model = Vehicles2[i].model})
								break
							end
						end
					end
				end
				while elements == nil do Wait(1) end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
				{
					title    = 'heli menu',
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Heli Plate', {'Plate (6 characters)'}, {max = 6})
								if plate and plate[1] then
									plate[1] = string.upper(plate[1])

									ESX.TriggerServerCallback('checkPlateInServer', function(plateExists)
										if plateExists then

											local alert = lib.alertDialog({
												header = 'Az In Plake Qablan Estefadeh Shode',
												content = 'Aya Mikhahid Hazf Shavad?',
												centered = true,
												cancel = true
											})
											if alert == 'confirm' then
												ESX.TriggerServerCallback('deletevehiclejob', function(plate)
													TriggerEvent('chat:addMessage', {
														args = {'^1SYSTEM', 'Heli be moafaghiat hazf shod'}
													})
												end, "TX" .. plate[1])
												menu.close()

												Wait(1000)
												spawnheliss_taxi(data, plate, vehicle)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnheliss_taxi(data, plate, vehicle)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Heli Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "TX" .. plate[1])
								end
							end

							requestPlate()
						else
							ESX.ShowNotification(_U('heli_out'))
						end
					end

				end, function(data, menu)
					menu.close()

					CurrentAction     = 'menu_heli_spawner'
					CurrentActionMsg  = _U('heli_spawner')
					CurrentActionData = {station = station, partNum = partNum}

				end)
			end, dvisionName, job)
		end, ESX.PlayerData.identifier)
	end, grade, job)
end

function spawnheliss_taxi(data, plate, vehicle)
	plate[1] = string.upper(plate[1])

	ESX.Game.SpawnVehicleJobs(data.current.model, Config_taxi.Zones.HeliSpawnPoint.Pos, Config_taxi.Zones.HeliSpawnPoint.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'taxi', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_taxi(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_taxi(vehicle, 1)
				SetVehicleLivery(vehicle, 4)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_taxi(vehicle, 1)
				SetVehicleLivery(vehicle, 4)
			else
				SetVehicleMaxMods_taxi(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_taxi.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 4)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 4)

			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_taxi(vehicle)
			SetVehicleNumberPlateText(vehicle, "TX" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

            TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "TX" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 TX'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

function spawnvehicles_taxi(data, plate, vehicle)
	plate[1] = string.upper(plate[1])
	ESX.Game.SpawnVehicleJobs(data.current.model, Config_taxi.Zones.VehicleSpawnPoint.Pos, Config_taxi.Zones.VehicleSpawnPoint.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'taxi', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})
			local playerPed = PlayerPedId()
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleMaxMods_taxi(vehicle)
			SetVehicleNumberPlateText(vehicle, "TX" ..plate[1] )
			local vehicleextra = Config_taxi.AuthorizedVehicles.Shared

			for k,v in pairs(vehicleextra) do
				if v.model == data.current.model and v.Extra then
					for name,value in pairs(v.Extra) do

						SetVehicleExtra(vehicle, tonumber(name), tonumber(value))
					end
				end
			end

			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleLivery(vehicle, 4)

			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end
			SetVehicleExtra(vehicle, 1, 1)

			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Mashin Ba Plake^2 '..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
			})

		end
	end)

end

function DeleteJobVehicle_taxi()
	local plate = GetVehicleNumberPlateText(CurrentActionData.vehicle)
	ESX.Game.DeleteVehicleJobs(CurrentActionData.vehicle)
end

function OpenTaxiActionsMenu_taxi()
	local elements = {}

	if Config_taxi.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBosscarysMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function PlayerBlingMenu_taxi()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_taxi(3)
	local elements = {}
	table.insert(elements, {label = "ID"  , value = " " })
	local playerId22 = GetPlayerServerId(PlayerId())
	local names = nil

	for _, player in ipairs(nearbyPlayers) do
		local playerPed = GetPlayerPed(GetPlayerFromServerId(player.id))
		local health = GetEntityHealth(playerPed)
		if player.id ~= playerId22 and health ~= 0 then

            table.insert(elements, { label = "Player ID : " .. " [" .. player.id .. "]", value = player.id })

		end
	end

	Citizen.Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bling_player',
		{
			title = "Bling Player ID",
			align = 'center-left',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= " " then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 2.0 then
					ESX.ShowNotification("No players nearby!")
				else

					local playerid = data.current.value

                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                        title = 'Qeymat'
                    }, function(data2, menu2)
                        local amount = tonumber(data2.value)
                        if amount == nil then

                        else
                            menu2.close()
                            if closestPlayer == -1 or closestDistance > 2.0 then
                                ESX.ShowNotification("No players nearby!")
                            else
                                TriggerServerEvent("esx_taxijob:blingrequest", playerid, GetPlayerServerId(PlayerId()), amount)

                            end
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)

					stopActiveMarker_taxi()




				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_taxi()
			Wait(5)

			local targetPlayer = GetPlayerPed(GetPlayerFromServerId(data.current.value))
			activeMarkerThread = true

			local playerId22 = GetPlayerServerId(PlayerId())

			while activeMarkerThread and tttrp do
				if DoesEntityExist(targetPlayer) then
					local coords = GetEntityCoords(targetPlayer)
					if data.current.value ~= " " then


						DrawMarker(23, coords.x, coords.y, coords.z-1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 0, 255, 0, 100, false, true, 2, nil, nil, false)

						if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 322) then
							tttrp = false
						end
					else

					end
				else
					stopActiveMarker_taxi()
				end
				Wait(0)
			end

		end,function()

		end
	)
end

RegisterNetEvent('esx_taxijob:OpenMenuDialog')
AddEventHandler('esx_taxijob:OpenMenuDialog', function(player, target, amount)

    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_bling',
        {
            title 	 = 'Qgabz Taxi',
            align    = 'center',
            question = "Aya Shoma Qhabz ("..amount.."$) Ra Ghabol Darid ?",
            elements = {
                {label = 'Bale', value = 'yes'},
                {label = 'Kheir', value = 'no'},
            },
        },
        function(data, menu)
            if data.current.value == 'yes' then
                TriggerServerEvent('esx_billing:send2Bill2', target, player, 'society_taxi', 'Taxi', amount)
                TriggerServerEvent("esx_taxijob:ChatMessage",target, player, true)

                ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'no' then

                TriggerServerEvent("esx_taxijob:ChatMessage",target, player, false)
                menu.close()

            end
        end
    )
end)

function getNearbyPlayers_taxi(radius)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)

        if distance <= radius then
            table.insert(players, {
                id = GetPlayerServerId(playerId),
                name = GetPlayerName(playerId)
            })
        end
    end

    return players
end

local activeMarkerTarget = nil
function stopActiveMarker_taxi()
    if activeMarkerThread then
        activeMarkerThread = nil
    end
end

function OpenMobileTaxiActionsMenu_taxi()
	ESX.TriggerServerCallback('esx_taxijob:list', function(tedad)
		local elements = {}
		local isdivision = false

		ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
			local playerjob =  ESX.GetPlayerData().job.name
			for k, v in pairs(check) do
				if v.job == playerjob then
					if #check >= 1 then

						isdivision = true
						break
					end
				end
			end


			elements = {
				{label = 'Request List ('..tedad..')',   value = 'requests'},
				{label = _U('billing'),   value = 'billing'},
				{label = 'Dastmal Keshidan',   value = 'clean_vehicle'},


			}


			if isdivision then
				table.insert(elements, {label = _U('extra_division'), value = 'extra_division'})
			end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
			title    = 'Taxi',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'billing' then
				PlayerBlingMenu_taxi()
			elseif data.current.value == 'clean_vehicle' then

				local playerPed = GetPlayerPed(-1)
				local vehicle   = ESX.Game.GetVehicleInDirection()
				local coords    = GetEntityCoords(playerPed)

				if IsPedSittingInAnyVehicle(playerPed) then
					ESX.ShowNotification(_U('inside_vehicle'))
					return
				end

				if DoesEntityExist(vehicle) then
					IsBusy = true
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
					Citizen.CreateThread(function()
						Citizen.Wait(10000)

						SetVehicleDirtLevel(vehicle, 0)
						ClearPedTasksImmediately(playerPed)

						ESX.ShowNotification(_U('vehicle_cleaned'))
						IsBusy = false
					end)
				else
					ESX.ShowNotification(_U('no_vehicle_nearby'))
				end

				elseif data.current.value == 'requests' then
					OpenReqsList_taxi()
			elseif data.current.value == 'start_job' then
				if OnJob then
					StopTaxiJob_taxi()
				else
					if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then
						local playerPed = PlayerPedId()
						local vehicle   = GetVehiclePedIsIn(playerPed, false)

						if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
							if tonumber(ESX.PlayerData.job.grade) >= 3 then
								StartTaxiJob_taxi()
							else
								if IsInAuthorizedVehicle_taxi() then
									StartTaxiJob_taxi()
								else
									ESX.ShowNotification(_U('must_in_taxi'))
								end
							end
						else
							if tonumber(ESX.PlayerData.job.grade) >= 3 then
								ESX.ShowNotification(_U('must_in_vehicle'))
							else
								ESX.ShowNotification(_U('must_in_taxi'))
							end
						end
					end
				end
			elseif data.current.value == 'extra_division' then

				OpendivisionsMenu_taxi()



			end
		end, function(data, menu)
			menu.close()
		end)
		end)
	end)
end

function IsInAuthorizedVehicle_taxi()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #exports["ScriptPack"]:GetVehicles(ESX.PlayerData.job.name), 1 do
		if vehModel == GetHashKey(Config_taxi.AuthorizedVehicles[i].model) then
			return true
		elseif
			vehModel == GetHashKey(Config_taxi.AuthorizedHelis[i].model) then
			return true
		end
	end

	return false
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

AddEventHandler('esx_taxijob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'HeliSpawner' then
		CurrentAction     = 'heli_spawner'
		CurrentActionMsg  = _U('spawner_prompt_Heli')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'HeliDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_heli'
			CurrentActionMsg  = _U('store_heli')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}

	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}


	elseif zone == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end

end)

AddEventHandler('esx_taxijob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAGGElEQVR4XsWWW2gd1xWGv7Vn5pyRj47ut8iOYlmyWxw1KSZN4riOW6eFuCYldaBtIL1Ag4NNmt5ICORCaNKXlF6oCy0hpSoJKW4bp7Sk6YNb01RuLq4d0pQ0kWQrshVJ1uX46HJ0zpy5rCKfQYgjCUs4kA+GtTd786+ftW8jqsqHibB6TLZn2zeq09ZTWAIWCxACoTI1E+6v+eSpXwHRqkVZPcmqlBzCApLQ8dk3IWVKMQlYcHG81OODNmD6D7d9VQrTSbwsH73lFKePtvOxXSfn48U+Xpb58fl5gPmgl6DiR19PZN4+G7iODY4liIAACqiCHyp+AFvb7ML3uot1QP5yDUim292RtIqfU6Lr8wFVDVV8AsPKRDAxzYkKm2kj5sSFuUT3+v2FXkDXakD6f+7c1NGS7Ml0Pkah6jq8mhvwUy7Cyijg5Aoks6/hTp+k7vRjDJ73dmw8WHxlJRM2y5Nsb3GPDuzsZURbGMsUmRkoUPByCMrKCG7SobJiO01X7OKq6utoe3XX34BaoLDaCljj3faTcu3j3z3T+iADwzNYEmKIWcGAIAtqqkKAxZa2Sja/tY+59/7y48aveQ8A4Woq4Fa3bj7Q1/EgwWRAZ52NMTYCWAZEwIhBUEQgUiVQ8IpKvqj4kVJCyGRCRrb+hvap+gPAo0DuUhWQfx2q29u+t/vPmarbCLwII7qQTEQRLbUtBJ2PAkZARBADqkLBV/I+BGrhpoSN577FWz3P3XbTvRMvAlpuwC4crv5jwtK9RAFSu46+G8cRwESxQ+K2gESAgCiIASHuA8YCBdSUohdCKGCF0H6iGc3MgrEphvKi+6Wp24HABioSjuxFARGobyJ5OMXEiGHW6iLR0EmifhPJDddj3CoqtuwEZSkCc73/RAvTeEOvU5w8gz/Zj2TfoLFFibZvQrI5EOFiPqgAZmzApTINKKgPiW20ffkXtPXfA9Ysmf5/kHn/T0z8e5rpCS5JVQNUN1ayfn2a+qvT2JWboOOXMPg0ms6C2IAAWTc2ACPeupdbm5yb8XNQczOM90DOB0uoa01Ttz5FZ6IL3Ctg9DUIg7Lto2DZ0HIDFEbAz4AaiBRyxZJe9U7kQg84KYbH/JeJESANXPXwXdWffvzu1p+x5VE4/ST4EyAOoEAI6WsAhdx/AYulhJDqAgRm/hPPEVAfnAboeAB6v88jTw/f98SzU8eAwbgC5IGRg3vsW3E7YewYzJwF4wAhikJURGqvBO8ouAFIxBI0gqgPEp9B86+ASSAIEEHhbEnX7eTgnrFbn3iW5+K82EAA+M2V+d2EeRj9K/izIBYgJZGwCO4Gzm/uRQOwDEsI41PSfPZ+xJsBKwFo6dOwpJvezMU84Md5sSmRCM51uacGbUKvHWEjAKIelXaGJqePyopjzFTdx6Ef/gDbjo3FKEoQKN+8/yEqRt8jf67IaNDBnF9FZFwERRGspMM20+XC64nym9AMhSE1G7fjbb0bCQsISi6vFCdPMPzuUwR9AcmOKQ7cew+WZcq3IGEYMZeb4p13sjjmU4TX7Cfdtp0oDAFBbZfk/37N0MALAKbcAKaY4yPeuwy3t2J8MAKDIxDVd1Lz8Ts599vb8Wameen532GspRWIQmXPHV8k0BquvPP3TOSgsRmiCFRAHWh9420Gi7nl34JaBen7O7UWRMD740AQ7yEf8nW78TIeN+7+PCIsOYaqMJHxqKtpJ++D+DA5ARsawEmASqzv1Cz7FjRpbt951tUAOcAHdNEUC7C5NAJo7Dws03CAFMxlkdSRZmCMxaq8ejKuVwSqIJfzA61LmyIgBoxZfgmYmQazKLGumHitRso0ZVkD0aE/FI7UrYv2WUYXjo0ihNhEatA1GBEUIxEWAcKCHhHCVMG8AETlda0ENn3hrm+/6Zh47RBCtXn+mZ/sAXzWjnPHV77zkiXBgl6gFkee+em1wBlgdnEF8sCF5moLI7KwlSIMwABwgbVT21htMNjleheAfPkShEBh/PzQccexdxBT9IPjQAYYZ+3o2OjQ8cQiPb+kVwBCliENXA3sAm6Zj3E/zaq4fD07HmwEmuKYXsUFcDl6Hz7/B1RGfEbPim/bAAAAAElFTkSuQmCC',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config_taxi.Zones.Blip.Pos.x, Config_taxi.Zones.Blip.Pos.y, Config_taxi.Zones.Blip.Pos.z)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep, currentZone = false, true
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil

			for k,v in pairs(Config_taxi.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)






				if v.Type ~= -1 and distance < Config_taxi.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
					if v.Type == 24 and v.Isheli then
						if distance <= v.Size.x+2 and distance <= v.Size.y+2 and distance <= v.Size.z+2 then
							isInMarker, currentZone = true, k
						end
					else
						if distance < v.Size.x then
							isInMarker, currentZone = true, k
						end
					end
				end


			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('esx_taxijob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_taxijob:hasExitedMarker', LastZone)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function OpenArmoryMenu_taxi(station)


	  local elements = {

		{label = _U('remove_object'),  value = 'get_stock'},
		{label = _U('deposit_object'), value = 'put_stock'}
	  }

	  if ESX.GetPlayerData().job.grade >= 10 then
		table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
	  end

	  ESX.UI.Menu.CloseAll()

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory',
		{
		  title    = _U('armory'),
		  align    = 'bottom-right',
		  elements = elements,
		},
		function(data, menu)


		  if data.current.value == 'put_stock' then
			OpenPutStocksMenu_taxi()
		  end

		  if data.current.value == 'get_stock' then
			OpenGetStocksMenu_taxi()
		  end

		  if data.current.value == 'buy_items' then
			OpenBuyItemsMenu_taxi()
		  end

		end,
		function(data, menu)

		  menu.close()

		  CurrentAction     = 'menu_armory'
		  CurrentActionMsg  = _U('open_armory')
		  CurrentActionData = {station = station}
		end
	)
end


function OpenBuyItemsMenu_taxi()

	ESX.TriggerServerCallback('esx_taxijob:getStockItems', function(Iitems)

		local elements = {}

		for i=1, #Config_taxi.AuthorizedItems, 1 do

		local Iitem = Config_taxi.AuthorizedItems[i]
		local count  = 0

		for i=1, #Iitems, 1 do
			if Iitems[i].name == Iitem.name then
			count = Iitems[i].count
			break
			end
		end

		table.insert(elements, {label = 'x' .. count .. ' ' .. Iitem.label .. ' $' .. Iitem.price, value = Iitem.name, price = Iitem.price})

		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_buy_Iitems',
		{
			title    = _U('buy_item_menu'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)
			local tedad = lib.inputDialog('Enter Buy Iitem', {'Tedad Iitem (1 , 99)'}, {max = 2})
			if not tedad then return end
			cuntt = json.encode(tedad)
			ESX.TriggerServerCallback('esx_taxijob:buy', function(hasEnoughMoney)

				if hasEnoughMoney then
					ESX.TriggerServerCallback('esx_taxi:buyArmoryItem', function()
						OpenBuyItemsMenu_taxi(station)

						local steamHex = ESX.GetPlayerData().identifier

						TriggerServerEvent('logBuyItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, math.floor(tonumber(tedad[1])), data.current.price * math.floor(tonumber(tedad[1])))
					end, data.current.value, false, math.floor(tonumber(tedad[1])))

				end

			end, data.current.price *  math.floor(tonumber(tedad[1])))

		end,
		function(data, menu)
			menu.close()

		end
		)

	end)
end

function GetDivisionName_taxi(getdivision, job)
    for _, division in ipairs(getdivision) do
        if division.status and division.job == job then
            return division.name
        end
    end
    return nil
end

function OpenGetStocksMenu_taxi()
    local grade = ESX.PlayerData.job.grade
    local job = ESX.PlayerData.job.name

    ESX.TriggerServerCallback("esx_taxijob:getStockItems", function(items)
        ESX.TriggerServerCallback('esx_society:GetDivisionsPlayer', function(getdivision)
            local dvisionName = GetDivisionName_taxi(getdivision, job)

            ESX.TriggerServerCallback('esx_society:getDivisionItems', function(authorizedItems)

                if type(authorizedItems) ~= "table" then
                    authorizedItems = {}
                end

                ESX.TriggerServerCallback('esx_society:getItems', function(jobGradeItems)
                    local elements = {}

                    for _, item in ipairs(items) do
                        for _, sharedItem in ipairs(jobGradeItems) do
                            if sharedItem.name == item.name and sharedItem.status == true then
                                table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                break
                            end
                        end
                    end

                    for _, item in ipairs(items) do
                        for _, divisionItem in ipairs(authorizedItems) do
                            if divisionItem.name == item.name and divisionItem.status == true then

                                local alreadyAdded = false
                                for _, element in ipairs(elements) do
                                    if element.value == item.name then
                                        alreadyAdded = true
                                        break
                                    end
                                end

                                if not alreadyAdded then
                                    table.insert(elements, {label = "x" .. item.count .. " " .. item.label, value = item.name})
                                end
                                break
                            end
                        end
                    end

                    if #elements == 0 then
                        table.insert(elements, {label = "Not Items", value = nil})
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
                        title = _U('police_stock'),
                        align = 'left',
                        elements = elements
                    }, function(data, menu)
                        if data.current.value == nil then
                            return
                        end

                        local itemName = data.current.value

                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                            title = _U('quantity')
                        }, function(data2, menu2)
                            local count = tonumber(data2.value)

                            if count == nil then
                                ESX.ShowNotification(_U('quantity_invalid'))
                            else
                                menu2.close()
                                menu.close()

                                TriggerServerEvent('esx_taxijob:getStockItem', itemName, count)

								local steamHex = ESX.GetPlayerData().identifier


								TriggerServerEvent('logGetItem', ESX.GetPlayerData().name, GetPlayerServerId(PlayerId()), steamHex, data.current.label, count)

                                Citizen.Wait(300)
                                OpenGetStocksMenu_taxi()
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    end, function(data, menu)
                        menu.close()

                    end)
                end, grade, job)
            end, dvisionName, job)
        end, ESX.PlayerData.identifier)
    end)
end

function OpenPutStocksMenu_taxi()

	ESX.TriggerServerCallback('esx_taxijob:getPlayerInventory', function(inventory)

	  local elements = {}

	  for i=1, #inventory.items, 1 do

		local item = inventory.items[i]

		if item.count > 0 then
		  table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
		end

	  end

	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
		  title    = _U('inventory'),
		  align    = 'bottom-right',
		  elements = elements
		},
		function(data, menu)

		  local itemName = data.current.value

		  ESX.UI.Menu.Open(
			'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
			  title = _U('quantity')
			},
			function(data2, menu2)

			  local count = tonumber(data2.value)

			  if count == nil then
				ESX.ShowNotification(_U('quantity_invalid'))
			  else
				menu2.close()
				menu.close()
				TriggerServerEvent('esx_taxijob:putStockItems', itemName, count)

				Citizen.Wait(300)
				OpenPutStocksMenu_taxi()
			  end

			end,
			function(data2, menu2)
			  menu2.close()
			end
		  )

		end,
		function(data, menu)
		  menu.close()
		end
	  )

	end)

  end


Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub_taxi(_U('drive_search_pass'), 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(1)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC_taxi()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification(_U('customer_found'))
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification(_U('arrive_dest'))

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)

								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									ESX.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 100, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = Config_taxi.JobLocations[GetRandomIntInRange(1, #Config_taxi.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < Config_taxi.MinimumDistance do
								Citizen.Wait(1)

								targetCoords = Config_taxi.JobLocations[GetRandomIntInRange(1, #Config_taxi.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2])))
							else
								msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 100, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification(_U('close_to_client'))
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub_taxi(_U('return_to_veh'), 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if CurrentAction and not IsDead then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				if CurrentAction == 'taxi_actions_menu' then

					TriggerEvent('esx_society:openBosscarysMenu', 'taxi', function(data, menu)
						menu.close()
					end)
				elseif CurrentAction == 'cloakroom' then
					OpenCloakroom_taxi()
				elseif CurrentAction == 'menu_armory' then

					OpenArmoryMenu_taxi(CurrentActionData.station)
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu_taxi()
				elseif CurrentAction == 'heli_spawner' then
					OpenheliSpawnerMenu_taxi()
				elseif CurrentAction == 'delete_vehicle' then
					DeleteJobVehicle_taxi()

				elseif CurrentAction == 'delete_heli' then
					DeleteJobVehicle_taxi()
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, 167) and IsInputDisabled(0) and Config_taxi.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			OpenMobileTaxiActionsMenu_taxi()
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)



	hasAlreadyJoined = true
end)

RegisterNetEvent('esx_taxijob:openreqs')
AddEventHandler('esx_taxijob:openreqs', function(source)
	OpenReqsList_taxi()
end)

RegisterNetEvent('esx_taxijob:acceptreq')
AddEventHandler('esx_taxijob:acceptreq', function(loc)
	SetNewWaypoint(loc)
end)

RegisterNetEvent('esx_taxijob:addblip')
AddEventHandler('esx_taxijob:addblip', function(id, coords)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(1)
	carblip = AddBlipForCoord(coords)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,5)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Taxi Officer')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(1)
		ESX.TriggerServerCallback('esx_taxijob:getcoord', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip,coords)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
	end
end)

RegisterNetEvent('esx_taxijob:delblip')
AddEventHandler('esx_taxijob:delblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

function OpenReqsList_taxi()
	ESX.TriggerServerCallback('esx_taxijob:getReqs', function(reqs)

	local elements = {}
	for i=1, #reqs, 1 do

		table.insert(elements, {
			label = "Request Id : "..reqs[i].reqid.." | Accept : "..reqs[i].status.." | Distance : ".. ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),reqs[i].coord)),
			icname = reqs[i].name,
			reqid = reqs[i].reqid,
			text = reqs[i].reason,
			status = reqs[i].status,
			phone = reqs[i].phone,
			id = reqs[i].id,
			coord = reqs[i].coord,
			accept = reqs[i].accept,
		})
	end


 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_lists', {

		title    = "Requests",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		local elements = {}
		local reqid = data.current.reqid
		local id = data.current.id
		ESX.TriggerServerCallback('esx_taxijob:acceptername', function(acceptername, accepterID)
		ESX.TriggerServerCallback('esx_taxijob:icname', function(name)
		table.insert(elements,{label = "Id : ".. data.current.reqid ,value = "nil"})

		table.insert(elements,{label = "Accept status : "..data.current.status ,value = "nil"})


			if data.current.accept == "open" then
				table.insert(elements,{label = "Accept", value = "yes"})
				table.insert(elements,{label = "Request by : "..data.current.icname.." ("..data.current.id..")", value = "nil"})
			else

				table.insert(elements,{label = "Accepted by : ".. acceptername.." ("..accepterID..")", value = "nil"})
				table.insert(elements,{label = "Request by : "..data.current.icname.." ("..data.current.id..")", value = "nil"})
			end

			if acceptername == name then
				table.insert(elements,{label = "Decline",value = "decline"})
				table.insert(elements,{label = "Finish",value = "finish"})
			end

		table.insert(elements,{label = "Pin location",value = "loc"})
		table.insert(elements,{label = "Call",value = "call"})
		table.insert(elements,{label = "Matn Payam",value = "matn"})


 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_list', {

				title    = "Request",
				align    = 'bottom-right',
				elements = elements
				}, function(data2, menu2)

				menu2.close()
 				if data2.current.value == 'yes' then
					TriggerServerEvent('esx_taxijob:areqs', data.current.reqid)
					menu.close()
				elseif data2.current.value == 'call' then
					TriggerEvent('Unique_Phone:Cleant:CallNumberr', data.current.id)
					ESX.UI.Menu.CloseAll()
				elseif data2.current.value == 'finish' then
					TriggerServerEvent("esx_taxijob:creqs", data.current.reqid)
					TriggerEvent("Quest-System:TaxiFinish")
					local accepter = GetPlayerServerId(PlayerId())
					menu.close()
				elseif data2.current.value == 'decline' then
					TriggerServerEvent("esx_taxijob:decline", data.current.reqid)
					menu.close()
				elseif data2.current.value == 'matn' then
					TriggerServerEvent("esx_taxijob:chat", data.current.text)
					menu.close()
				elseif data2.current.value == 'loc' then
					local Ped = GetPlayerPed(GetPlayerFromServerId(id))
					local coords = GetEntityCoords(Ped)

					SetNewWaypoint(coords)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
			end)
			end, reqid)
 		end, function(data, menu)
			menu.close()

		end)

	end)
end

RegisterNetEvent('esx_taxijob:callTaxi')
AddEventHandler('esx_taxijob:callTaxi', function(coords)
	if customer then
		ESX.ShowHelpNotification('Yek Taxi Dar Hal Omadan Be Samt Shoma Ast!')
	else
		customer = coords

		playerPed = GetPlayerPed(-1)
		myCoords = GetEntityCoords(playerPed)
		local heading
		for k,v in pairs(Config_taxi.SpawnPoints) do
			v = vector4(v.x, v.y, v.z, v.h)
			spawnDistance = GetDistanceBetweenCoords(myCoords, v)
			if oldDistance then
				if spawnDistance < oldDistance then
					oldDistance = spawnDistance
					realSpawnPoint = vector3(v.x, v.y, v.z)
					heading = v.w
				else
					oldDistance = oldDistance
				end
			else
				oldDistance = spawnDistance
				realSpawnPoint = vector3(v.x, v.y, v.z)
				heading = v.w
			end
		end
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Wait(50)
		end
		while not HasModelLoaded(vehicleHash) do
			RequestModel(vehicleHash)
			Wait(50)
		end
		if ped == nil then
			ped =  CreatePed(4, hash, realSpawnPoint.x, realSpawnPoint.y, realSpawnPoint.z + 2, 0.0, true, true)
			SetEntityInvincible(ped, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
		end
		if DoesEntityExist(globalTaxi) then
			ESX.Game.DeleteVehicleJobs(globalTaxi)
		end
		print(heading)
		ESX.Game.SpawnVehicle(vehicleHash, realSpawnPoint, heading, function(callback_vehicle)
			SetEntityHeading(callback_vehicle, heading)
			TaskWarpPedIntoVehicle(ped, callback_vehicle, -1)
			SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)

			taxiBlip = true
			globalTaxi = callback_vehicle
			SetEntityAsMissionEntity(globalTaxi, true, true)
			drive_taxi(customer.x, customer.y, customer.z, false, 'start')
		end)
	end
end)

RegisterNetEvent('esx_taxijob:setTaxiBlip')
AddEventHandler('esx_taxijob:setTaxiBlip', function(coords)
	if CarBlip then
		RemoveBlip(CarBlip)
		CarBlip = nil
	elseif not onWayBack then
		CarBlip = AddBlipForCoord(coords)
		SetBlipSprite(CarBlip , 56)
		SetBlipScale(CarBlip, 0.7)
		SetBlipColour(CarBlip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('TAXI')
		EndTextCommandSetBlipName(CarBlip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(450)
		if taxiBlip then
			coords = GetEntityCoords(ped)
			TriggerEvent('esx_taxijob:setTaxiBlip', coords)
		end
	end
end)

RegisterNetEvent('esx_taxijob:killTaxiBlip')
AddEventHandler('esx_taxijob:killTaxiBlip', function()
	RemoveBlip(CarBlip)
end)

RegisterNetEvent('esx_taxijob:cancelTaxi')
AddEventHandler('esx_taxijob:cancelTaxi', function(message)
	atTarget_taxi(message)
end)

Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	while true do
		Citizen.Wait(1)
		inCar = false
		if customer ~= nil then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			if vehicle == globalTaxi then
				inCar = true
				local waypoint = GetFirstBlipInfoId(8)
				if not DoesBlipExist(waypoint) and not onTour then
					ESX.ShowHelpNotification('Lotfan Maghsad Ra Moshakhas Konid!')
					Citizen.Wait(2000)
				else
					tx, ty, tz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector()))

					if GetDistanceBetweenCoords(45.45, 2088.04, 151.72, tx, ty, tz) >= 5600.0 then
						ESX.ShowHelpNotification('Onja Nemitonam Beram Ye jaye dige ro entekhab kon!')
					else
						if not onTour then
							if not targetX then
								targetX = tx
								targetY = ty
								targetZ = tz
							end
							drive_taxi(tx, ty, tz, false, false)
							onTour = true
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	while true do
		Citizen.Wait(1)
		if customer ~= nil then
			myCoords = GetEntityCoords(playerPed)
			taxiCoords = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			if vehicle == globalTaxi then
				route = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z)
				if GetDistanceBetweenCoords(myCoords, targetX, targetY, targetZ) < 20 then
					atTarget_taxi()
				end
			end
			if customer ~= nil then
				local distanceMeTaxi = GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true)
				if distanceMeTaxi <= 9.0 then
					if not parkingDone then
						parking_taxi(customer.x, customer.y, customer.z)
						TriggerEvent('esx:showNotification', 'Taxi Resid Be Location Shoma!')
					end
					if GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true) <= 8.0 then
						taxiArrived = true
					end
					if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true) >= 8.0 then
						taxiArrived = false
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	while true do
		Citizen.Wait(1)
		if customer ~= nil then
			if taxiArrived and not inCar and not onWayBack then
				myCoords = GetEntityCoords(playerPed)
				taxiCoords = GetEntityCoords(ped)
				ESX.ShowHelpNotification('Dokme ~INPUT_ARREST~ Baraye Savar Taxi Shodan')
				if IsControlJustReleased(0, Keys['F']) and GetLastInputMethod(2) then
					TaskEnterVehicle(GetPlayerPed(-1), globalTaxi, 1000, math.random(0,2), 2.0, 1, 0)
					Wait(1000)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), globalTaxi, math.random(0,2))
				end
			end
		end
	end
end)

function atTarget_taxi(cancel)
	cancelTaxi = false
	if cancel then
		playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= globalTaxi or globalTaxi == nil then
			TriggerEvent('esx:showNotification', 'Taxi Shoma Cancel Shod')
			cancelTaxi = true
		else
			TriggerEvent('esx:showNotification', 'Shoma Digar Felan Nemitavanid Darkhast Taxi Dahid!')
			return
		end
	end
	if not cancelTaxi then
		ESX.ShowHelpNotification('Be Maghsad Residid!')
		route2 = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, targetX, targetY, targetZ)
		price = math.ceil((route2/1000) * Config_taxi.Price)
		TriggerServerEvent('esx_taxijob:pay', price)
		TaskLeaveVehicle(GetPlayerPed(-1), globalTaxi, 1)
		Citizen.Wait(5000)
	end
	onWayBack = true
	customer = nil
	targetX = nil
	taxiBlip = nil
	RemoveBlip(CarBlip)
	parkingDone = false
	taxiArrived = false
	onTour = false
	onWayBack = false
	drive_taxi(912.14, -178.69, 73.84, true, 'end')
	ped = nil
	globalTaxi = nil
end

function parking_taxi(x, y ,z)

	StartVehicleHorn(globalTaxi, 3000, 0, false)
	parkingDone = true
end

function drive_taxi(x, y , z, delete, status)
	if status == 'start' then
		Citizen.Wait(math.random(1000,2000))
		ESX.ShowNotification('Ranande Taxi Dar Rah Ast.')
	elseif status == 'end' then
		ESX.ShowNotification('Tashakor Az Etemad Shoma. Khoda Negahdar.')
	end
	TaskVehicleDriveToCoordLongrange(ped, globalTaxi, x, y, z, Config_taxi.Speed, Config_taxi.DriveMode, 8.0)
	SetVehicleMaxSpeed(globalTaxi, 30.0)
	if delete then
		Citizen.Wait(15000)
		DeletePed(ped)
		ESX.Game.DeleteVehicleJobs(globalTaxi)
	end
end

function OpendivisionsMenu_taxi()
    ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}
		local jobplayer = ESX.GetPlayerData().job.name

        for k, v in pairs(check) do
			print( v.job)
			if v.job == jobplayer then
				if v.status then
					table.insert(elements, {
						name = v.name,
						label = v.label.." | [<font color=Lime>✅</font>]",
						status = v.status,
					})
				else
					table.insert(elements, {
						name = v.name,
						label = v.label.. " | [<font color=red>❌</font>]",
						status = v.status,
					})
				end
			end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Divisions', {
            title = 'Divisions',
            align = 'left',
            elements = elements
        }, function(data, menu)

            local selectedDivision = data.current.name
            local dvisionlabel = data.current.label

            ESX.TriggerServerCallback('esx_society:swichdivision', function(success)
				OpendivisionsMenu_taxi()
			end, selectedDivision)

        end, function(data, menu)

            menu.close()
        end)
    end)
end