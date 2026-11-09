-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local OnJob = false
local CurrentCustomerBlip, DestinationBlip, LastZone, CurrentAction, CurrentActionMsg
local TimeLeave = 60
local taxivehicle = {}

local JobStarted, firstOne, OutOfVehicle, MissionLocation, TaxiPed = false, false, false, {}, nil
local carblip = 0


local marketList = {
    {type = 1, label = 'A.H'},

    {type = 2, label = 'Mechanic', value = 'mechanic1'},
    {type = 2, label = 'DarooKhane', value = 'medic1'},

    {type = 2, label = 'Caffe 1', value = 'cafe01'},
    {type = 2, label = 'Caffe 2', value = 'cafe02'},
    {type = 2, label = 'Caffe 3', value = 'cafe03'},
    {type = 2, label = 'Caffe 4', value = 'cafe04'},
    {type = 2, label = 'Caffe 5', value = 'cafe05'},
    {type = 2, label = 'Caffe 6', value = 'cafe06'},
    {type = 2, label = 'Caffe 7', value = 'cafe07'},

	{type = 2, label = 'Ahangari 1', value = 'ahangari1'},
	{type = 2, label = 'Ahangari 2', value = 'ahangari2'},
	{type = 2, label = 'Ahangari 3', value = 'ahangari3'},
	{type = 2, label = 'Ahangari 4', value = 'ahangari4'},
	{type = 2, label = 'Ahangari 5', value = 'ahangari5'},
	{type = 2, label = 'Ahangari 6', value = 'ahangari6'},
	{type = 2, label = 'Ahangari 7', value = 'ahangari7'},
}
function stopTaxiJob()
	if JobStarted then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) and LevelLocation == 'back_to_station' then
			local c1 = vector2(Shared.taxi.zones.startTaxiJob[1].spawnPoint.x, Shared.taxi.zones.startTaxiJob[1].spawnPoint.y)
			local c2 = vector2(MissionLocation['start_loc'].coords.x, MissionLocation['start_loc'].coords.y)
			local c3 = vector2(MissionLocation['end_loc'].coords.x, MissionLocation['end_loc'].coords.y)
			local StationToPed = #(c1 - c2)
			local PedToEndLocation = #(c2 - c3)
			local EndToStation = #(c3 - c1)
			local MoneyGived = math.floor(StationToPed+PedToEndLocation+EndToStation)* exports['sunset_utils']:getSkillTime('taxi_skill', 'finish_req_taxi')
			ESX.TriggerServerEvent('taxi:giveMoneyForEndingJob', math.floor(MoneyGived))
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			TaskLeaveVehicle(playerPed, vehicle,  0)
			JobStarted = false
			TriggerEvent("mythic_progbar:client:cancel")
			ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'your_job_has_ended'))
			ESX.ShowAdvancedNotification(_U(Shared.taxi.Locale, 'ai_job'), _U(Shared.taxi.Locale, 'manager'), _U(Shared.taxi.Locale, 'prchs_job', tostring(math.floor(MoneyGived))), 'CHAR_TAXI', 9, false, false, 210)
			DrawSub(_U(Shared.taxi.Locale, 'mission_complete'), 5000)
		else
			ESX.UI.Menu.CloseAll()

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'verify_cancelling', {
				title    = 'Cancel Job',
				align    = 'top-left',
				elements = {
					{label = _U(Shared.taxi.Locale, 'yes_cancel'), value = 'yes'},
					{label = _U(Shared.taxi.Locale, 'no_cancel'), value = 'no'},
				}
			}, function(data, menu)
				if data.current.value == 'yes' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent("mythic_progbar:client:cancel")
					ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'your_job_canceled'))
				elseif data.current.value == 'no' then
					ESX.UI.Menu.CloseAll()
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end
end

local function ClearCurrentMission()
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

local function StartTaxiJob()
	ShowLoadingPromt(_U(Shared.taxi.Locale, 'taking_service'), 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

local function canCourier()
	local near = false
	local coords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(Shared.taxi.config.acceptPeykCoords) do
		if #(coords - v.xyz) < v.w then
			near = true
			break
		end
	end
	return near
end
local function openrequst(id)
	ESX.TriggerServerCallback('taxi:getlist', function(data)
		ems = data
		elements = {}
		emoji = "❌"
		if ems[id].accept then
			emoji = "✔️"
		end
		local source = ems[id].source
		table.insert(elements,{label = "Id : ".. ems[id].source,value = "no"})
		table.insert(elements,{label = ('Type : %s'):format(ems[id].data.type == 1 and 'Mashin' or ems[id].data.type == 2 and 'Motor' or ems[id].data.type == 3 and 'Helicopter'), value = "no"})
		table.insert(elements,{label = ('Peyk : %s'):format(ems[id].data.courier and '✔️' or '❌'), value = "no"})
		table.insert(elements,{label = "Accept status : ".. emoji,value = "no"})
		if ems[id].accept then
			table.insert(elements,{label = "Accepted by : ".. ems[id].acceptername,value = "no"})
		else
			if not ems[id].data.courier or exports['sun-society']:doesHavePerm('peyk') then
				table.insert(elements,{label = "Accept",value = "accept"})
			end
		end
		if ems[id].acceptersource == GetPlayerServerId(PlayerId()) then
			table.insert(elements,{label = "Decline",value = "decline"})
			table.insert(elements,{label = ems[id].data.courier and "Cancel" or 'Finish',value = "finish"})
			if ems[id].data.courier and ESX.Game.doesPlayerExist(source) then
				local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(source))))
				if distance < 5 then
					table.insert(elements,{label = 'Tahvil baste',value = 'giveCourier'})
				end
			end
		end
		table.insert(elements,{label = "Pin location",value = "pin"})
		table.insert(elements,{label = "Call",value = "call"})
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list2', {
			title    = 'Request list',
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value == "accept" then
				if not ems[id].data.courier or canCourier() then
					TriggerServerEvent('taxi:accept',id)
					openrequst(id)
				else
					ESX.chatMessage('Baraye accept in darkhast bayad dar nazdiki markaz posti bashid', 'job')
				end
			elseif data2.current.value == "decline" then
				TriggerServerEvent('taxi:decline',id)
				openrequst(id)
			elseif data2.current.value == "finish" then
				TriggerServerEvent('taxi:finish',id)
				menu2.close()
			elseif data2.current.value == "pin" then
				ESX.TriggerServerCallback('getplayercoords', function(coords)
					if coords ~= nil then
						SetNewWaypoint(coords.x,coords.y)
						SetNewWaypoint(coords.x,coords.y)
					end
				end,source)
			elseif data2.current.value == "call" then
				--TriggerEvent('gcphone:autoCall',ems[id].number)
				exports['sun-phone']:Call({number = ems[id].number,name = ems[id].number})
			elseif data2.current.value == 'giveCourier' then
				menu2.close()
				exports['sun-animmenu']:PlayEmote('pointdown', true, true)
				ESX.TriggerServerEvent('taxi:taxiGiveCourier', source)
				TriggerServerEvent('taxi:finish', id)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

function openTaxiRequest(type)
	ESX.TriggerServerCallback('taxi:getlist', function(data)
		local _data = {}
		for k, v in pairs(data) do
			if type == 1 and (not v.data.courier and (v.data.type == 1 or v.data.type == 2)) or (type == 2 and v.data.type == 3 and not v.data.courier) or (type == 3 and v.data.courier) then
				_data[k] = v
			end
		end
		ems = _data
		if not next(ems) then
			ESX.ShowNotification('Hich darkhasti vojoud nadarad')
		else
			elements = {}
			for k , v in pairs(ems) do
				if v and v.source and v.show then
					emoji = "❌"
					if v.accept then
						emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
					end
					table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .. " | Distance : ".. ESX.Math.Round(#(GetEntityCoords(PlayerPedId()) - v.coords)),value = k})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = 'Request list',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu)
				menu.close()
				local id = tonumber(data2.current.value)
				openrequst(id)
			end, function(data2, menu)
				menu.close()
			end)
		end
	end)
end

RegisterNetEvent('taxi:addtaxiblip',function(id,coords,name)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(2000)
	carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,5)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Taxi officer')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(1000)
		ESX.TriggerServerCallback('getplayercoords', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip, coords.x, coords.y, coords.z)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
		ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', '/taxi to open request menu', 'CHAR_TAXI', 7)
	end
end)

RegisterNetEvent('taxi:deleteblip')
AddEventHandler('taxi:deleteblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

RegisterCommand('taxi',function()
	ESX.TriggerServerCallback('taxi:getMeRequest',function(id,v)
		if id == nil then
			ESX.ShowNotification('Shoma hich darkhast taxi ersal nakardid')
		else
			elements = {}
			emoji = "❌"
			if v.accept then
				--emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
				emoji = "✔️"
			end
			table.insert(elements,{label = "Request id : ".. id .. " | Accept : ".. emoji, value = ''})

			if v.accept then
				table.insert(elements,{label = "Accepted by : ".. v.acceptername,value = "no"})
				table.insert(elements,{label = "Call",value = "call"})
			else
				table.insert(elements,{label = "Cancel request",value = "cancel"})
			end
			if v.data.courier then
				for k, v in pairs(marketList) do
					table.insert(elements, v)
				end
				-- table.insert(elements,{label = "Auction house",value = "ah"})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = 'Request list',
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if data.current.value == "call" then
					--TriggerEvent('gcphone:autoCall',v.accepternumber)
					exports['sun-phone']:Call({number = v.accepternumber,name = v.accepternumber})
				elseif data.current.value == "cancel" then
					ESX.TriggerServerCallback('taxi:remove',function(data)
						menu.close()
					end)
				elseif data.current.type then
					if data.current.type == 1 then
						TriggerServerEvent('ah:open', true)
					else
						TriggerServerEvent('customShop:open', true, data.current.value)
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end)
end, false)

RegisterNetEvent('taxi:openAdmin',function()
	ESX.TriggerServerCallback('taxi:getlist', function(data)
		ems = data
		if not next(ems) then
			ESX.ShowNotification('Hich darkhasti vojoud nadarad')
		else
			elements = {}
			for k , v in pairs(ems) do
				emoji = "❌"
				if v.accept then
					emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
				end
				table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji,value = k})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = 'Request list',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu)
				menu.close()
				local id = tonumber(data2.current.value)
				openrequst(id)
			end, function(data2, menu)
				menu.close()
			end)
		end
	end)
end)
local cd = false
RegisterNetEvent('taxi:AccessToStartJob')
AddEventHandler('taxi:AccessToStartJob', function()
	if cd then return end
	cd = true
	SetTimeout(3000, function()
		cd = false
	end)
	local canstart = false
	if GetResourceKvpInt('taxibot') == nil then
		canstart = true
	else
		if (exports['sunset_utils']:GetServerOSTime() - GetResourceKvpInt('taxibot')) > jobConfig.config.taxiJobCooldown then
			canstart = true
			SetResourceKvpInt('taxibot', exports['sunset_utils']:GetServerOSTime())
		end
	end
	if not canstart then return ESX.ShowNotification('Job dar cooldown ast') end
	if not ESX.Game.IsSpawnPointClear(Shared.taxi.zones.startTaxiJob[1].spawnPoint.xyz, 5.0) then
		ESX.ShowNotification(_U(Shared.taxi.Locale, 'spawnPoint_blocked'))
		return
	end
	if JobStarted then return end
	local RandomPed = GetHashKey(Shared.taxi.TaxiJobPeds[math.random(#Shared.taxi.TaxiJobPeds)])

	RequestModel(RandomPed)
	while not HasModelLoaded(RandomPed) do
		Wait(500)
	end

	MissionLocation = Shared.taxi.JobLocations[math.random(#Shared.taxi.JobLocations)]
	LevelLocation = 'start_loc'
	local missionCoords = MissionLocation[LevelLocation]?.coords
	TaxiPed = CreatePed(2, RandomPed, missionCoords.x, missionCoords.y, missionCoords.z, MissionLocation[LevelLocation].heading, false, false)
	ESX.Game.SpawnVehicle('karinss', Shared.taxi.zones.startTaxiJob[1].spawnPoint.xyz, Shared.taxi.zones.startTaxiJob[1].spawnPoint.w, function(vehicle)
		exports["esx_vehiclecontrol"]:SetDecor(vehicle,"TX",true)
		local playerPed = PlayerPedId()
		SetPedIntoVehicle(playerPed, vehicle, -1)
		setVehicleMaxMods(vehicle, "TAXI"..GetPlayerServerId(PlayerId()))
		taxivehicle[1] = vehicle
		BlipsDelivery = AddBlipForCoord(missionCoords.x, missionCoords.y, missionCoords.z)
		SetBlipRoute(BlipsDelivery, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
		EndTextCommandSetBlipName(BlipsDelivery)
		local PedToEndLocation = #(vector2(MissionLocation['start_loc'].coords.x, MissionLocation['start_loc'].coords.y) - vector2(MissionLocation['end_loc'].coords.x, MissionLocation['end_loc'].coords.y))
		local TimerStp = math.floor(PedToEndLocation*Shared.taxi.TimeGenerator)
		SetEntityAsMissionEntity(TaxiPed)
		SetBlockingOfNonTemporaryEvents(TaxiPed, true)
		Wait(2000)
    	FreezeEntityPosition(TaxiPed, true)
		SetEntityInvincible(TaxiPed, true)
		ESX.setVehicleFuel(vehicle, 100.0)
		exports['mythic_progbar']:Progress({
			name = "waiting_for_taxi",
			duration = TimerStp,
			label = _U(Shared.taxi.Locale, 'your_time'),
			useWhileDead = true,
			canCancel = true,
			controlDisables = {},
		}, function(cancelled)
			if cancelled then
				if LevelLocation == 'end_loc' then
					FreezeEntityPosition(TaxiPed, false)
					FreezeEntityPosition(taxivehicle[1], true)
					TaskLeaveVehicle(TaxiPed, taxivehicle[1], 0)
					Wait(4000)
					DeleteEntity(TaxiPed)
					FreezeEntityPosition(taxivehicle[1], false)
				end

				if DoesBlipExist(BlipsDelivery) then
					RemoveBlip(BlipsDelivery)
				end

				JobStarted = false
				firstOne = false
				OutOfVehicle = false
				MissionLocation = {}
				LevelLocation = nil
				TaxiPed = nil
				LastDamage = 1000
				TimeLeave = 60
				if DoesEntityExist(taxivehicle[1]) then
					ESX.Game.DeleteVehicle(taxivehicle[1])
				end
				Wait(2000)
				OutOfVehicle = false
			end
		end)
		JobStarted = true

		Citizen.CreateThread(function()
			while ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' do
				Citizen.Wait(1)
				if JobStarted then
					local IsInVehicle = IsPedInAnyVehicle(PlayerPedId(), true)

					if IsInVehicle then
						local vehicle = GetVehiclePedIsUsing(PlayerPedId())
						if vehicle ~= taxivehicle[1] then
							OutOfVehicle = true
						else
							if firstOne then
								TimeLeave = 60
								firstOne = false
								OutOfVehicle = false
								DrawSub(_U(Shared.taxi.Locale, 'start_again_job'), 5000)
								if LevelLocation ~= 'back_to_station' then
									BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
									SetBlipRoute(BlipsDelivery, true)
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
									EndTextCommandSetBlipName(BlipsDelivery)
								else
									BlipsDelivery = AddBlipForCoord(Shared.taxi.zones.stopTaxiJob[1].x, Shared.taxi.zones.stopTaxiJob[1].y, Shared.taxi.zones.stopTaxiJob[1].z)
									SetBlipRoute(BlipsDelivery, true)
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
									EndTextCommandSetBlipName(BlipsDelivery)
								end
							end
						end
					else
						OutOfVehicle = true
					end
				else
					break
				end

				if TimeLeave <= 0 or (ESX.GetPlayerData().IsInjure and firstOne) then
					TriggerEvent("mythic_progbar:client:cancel")
					ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'your_job_canceled'))
				end

				if OutOfVehicle then
					Citizen.Wait(1000)
					TimeLeave = TimeLeave-1
					ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'time_to_canceled', TimeLeave), false, true, 1000)
					if BlipsDelivery ~= nil then
						RemoveBlip(BlipsDelivery)
						firstOne = true
						BlipsDelivery = nil
					end
				end
			end
		end)
		Citizen.CreateThread(function()
			while JobStarted do
				Citizen.Wait(1)
				if MissionLocation and not firstOne then
					if MissionLocation[LevelLocation] and MissionLocation[LevelLocation].coords then
						local coords = GetEntityCoords(PlayerPedId())
						local distance = #(coords - MissionLocation[LevelLocation].coords)

						if IsPedInAnyVehicle(PlayerPedId(), true) then
							local dVeh = #(GetEntityCoords(taxivehicle[1]) - MissionLocation[LevelLocation].coords)
							if dVeh < 5 and LevelLocation == 'start_loc' then
								if AreAnyVehicleSeatsFree(taxivehicle[1]) then
									ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'waiting_for_ped'), false, true, 3000)
									FreezeEntityPosition(TaxiPed, false)
									FreezeEntityPosition(taxivehicle[1], true)
									TaskEnterVehicle(TaxiPed, taxivehicle[1], 5000, 0, 1.0, 1, 0)
									Wait(5000)
									FreezeEntityPosition(taxivehicle[1], false)
									FreezeEntityPosition(TaxiPed, true)
									LevelLocation = 'end_loc'
									DrawSub(_U(Shared.taxi.Locale, 'goto_endloc'), 5000)
									RemoveBlip(BlipsDelivery)
									BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x ,MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
									SetBlipRoute(BlipsDelivery, true)
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
									EndTextCommandSetBlipName(BlipsDelivery)
								else
									ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'no_have_seat'))
								end
							elseif dVeh < 5 and LevelLocation == 'end_loc' then
								if IsPedInAnyVehicle(TaxiPed, true) then
									ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'waiting_for_getout'))
									FreezeEntityPosition(TaxiPed, false)
									FreezeEntityPosition(taxivehicle[1], true)
									TaskLeaveVehicle(TaxiPed, taxivehicle[1], 0)
									Wait(4000)
									DeleteEntity(TaxiPed)
									FreezeEntityPosition(taxivehicle[1], false)
									TaxiPed = {}
									LevelLocation = 'back_to_station'
									DrawSub(_U(Shared.taxi.Locale, 'goto_station'), 5000)
									RemoveBlip(BlipsDelivery)
									BlipsDelivery = AddBlipForCoord(Shared.taxi.zones.stopTaxiJob[1].x, Shared.taxi.zones.stopTaxiJob[1].y, Shared.taxi.zones.stopTaxiJob[1].z)
									SetBlipRoute(BlipsDelivery, true)
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
									EndTextCommandSetBlipName(BlipsDelivery)
								end
							end
						end

						if MissionLocation[LevelLocation] and MissionLocation[LevelLocation].coords and distance then
							if distance <= 50 then
								DrawMarker(1, MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 204, 204, 0, 100, false, false, 2, true, nil, nil, false)
							end
						end
					end
				end
			end
		end)

		Citizen.CreateThread(function()
			while JobStarted do
				Citizen.Wait(5000)
				if JobStarted and IsPedInAnyVehicle(PlayerPedId(), true) then
					local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					local plate = GetVehicleNumberPlateText(currentVehicle)
					if plate:gsub(" ", "") ~= "TAXI"..GetPlayerServerId(PlayerId()) then
						RemoveBlip(BlipsDelivery)
						LevelLocation = 'start_loc'
						local coords = GetEntityCoords(TaxiPed)
						MissionLocation[LevelLocation].coords = coords
						BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
						SetBlipRoute(BlipsDelivery, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
						EndTextCommandSetBlipName(BlipsDelivery)
						ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'back_to_ped'))
					end
				end
			end
		end)

		Citizen.CreateThread(function()
			while JobStarted do
				Citizen.Wait(1000)
				if JobStarted and not firstOne and LevelLocation == 'end_loc' then
					if IsPedInAnyVehicle(TaxiPed, true) then
						local currentVehicle = GetVehiclePedIsUsing(TaxiPed)
						local plate = GetVehicleNumberPlateText(currentVehicle)
						if plate:gsub(" ", "") ~= "TAXI"..GetPlayerServerId(PlayerId()) then
							RemoveBlip(BlipsDelivery)
							LevelLocation = 'start_loc'
							local coords = GetEntityCoords(TaxiPed)
							MissionLocation[LevelLocation].coords = coords
							BlipsDelivery = AddBlipForCoord(MissionLocation[LevelLocation].coords.x, MissionLocation[LevelLocation].coords.y, MissionLocation[LevelLocation].coords.z)
							SetBlipRoute(BlipsDelivery, true)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentSubstringPlayerName(_U(Shared.taxi.Locale, 'blip_delivery'))
							EndTextCommandSetBlipName(BlipsDelivery)
							ESX.ShowHelpNotification(_U(Shared.taxi.Locale, 'back_to_ped'))
						end
					end
				end
			end
		end)
	end)
end)

RegisterNetEvent('taxi:acceptq',function(id)
	local elements = {
		{label = 'Bale', value = true},
		{label = 'Kheyr', value = false},
	}
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
	{
		title 	 = 'Darkhast jadid!',
		align    = 'center',
		question = 'Aya mayel be ghabul kardan darkhast hastid?',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
			TriggerServerEvent('taxi:accept',id,mugshotStr)
			ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
		else
			ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
		end
	end)
	Citizen.SetTimeout(10000,function()
		if ESX.UI.Menu.IsOpen('question',GetCurrentResourceName(),'a' .. id) then
			ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
			ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
		end
	end)
end)

local drawInD = false

RegisterNetEvent('taxi:acceptKarde',function()
	if not drawInD then
		drawInD = true
		reqid = 0
		Citizen.CreateThread(function()
			while drawInD do
				Citizen.Wait(0)
				ESX.ShowMissionText('~y~Request in progress('.. reqid ..')')
			end
		end)
		Citizen.CreateThread(function()
			while drawInD do
				local bedeBezanim = false
				ESX.TriggerServerCallback('taxi:getlist', function(data)
					ems = data
					for k , v in pairs(ems) do
						if v.acceptersource and v.acceptersource == GetPlayerServerId(PlayerId()) then
							bedeBezanim = true
							reqid = v.source
						end
					end
					if not bedeBezanim then
						drawInD = false
					end
				end)
				Citizen.Wait(10000)
			end
		end)
	end
end)

CreateThread(function()
	repeat Wait(50) until playerLoaded
	local requestData = {}
	local p, p2
	while not lib do Wait(100) end
	lib.registerMenu({
		id = 'taxiRequestData',
		title = 'Taxi',
		canClose = false,
		options = {
			{label = 'Type', values = {'Mashin', 'Motor', 'Helicopter'}, close = false},
			{label = 'Peyk', checked = false},
			{label = 'Taeed'},
			{label = 'Laghv'},
		},
		onSideScroll = function(selected, scrollIndex, args)
			requestData.type = scrollIndex
		end,
		onCheck = function(selected, checked, args)
			requestData.courier = checked
		end,
	}, function(selected, scrollIndex, args)
		if selected == 3 then
			if requestData.courier then
				p2 = promise.new()
				-- TriggerServerEvent('ah:open', true)
				local elements = {}
				for k, v in pairs(marketList) do
					v.args = v
					table.insert(elements, v)
				end
				table.insert(elements, {label = 'Taeed', args = {type = -1}})
				lib.registerMenu({
					id = 'taxiRequestData2',
					title = 'Taxi',
					options = elements,
					onClose = function()
						p2:resolve()
					end,
				}, function(selected, scrollIndex, args)
					if args.type == 1 then
						TriggerServerEvent('ah:open', true)
					elseif args.type == 2 then
						TriggerServerEvent('customShop:open', true, args.value)
					elseif args.type == -1 then
						--
						p2:resolve()
					end
				end)
				lib.showMenu('taxiRequestData2')
				Citizen.Await(p2)
			end
			p:resolve(requestData)
		else
			p:resolve()
		end
	end)
	AddEventHandler('ah:onClose', function()
		if requestData.courier then
			-- p2:resolve()
			lib.showMenu('taxiRequestData2')
		end
	end)
	ESX.RegisterClientCallback('taxi:getRequestData', function(cb)
		requestData = {
			type  = 1,
		}
		p = promise.new()
		exports['sun-phone']:close()
		Wait(1000)
		lib.showMenu('taxiRequestData')
		cb(Citizen.Await(p))
		ESX.chatMessage('Jahat modiriat darkhast az ^1/taxi^0 estefade konid', 'plarms')
		requestData = {}
	end)
end)

function taxiGiveCourier()
	ESX.selectPlayerMenu(function(src)
		if not IsPedInAnyVehicle(PlayerPedId()) then
			exports['sun-animmenu']:PlayEmote('pointdown', true, true)
			ESX.TriggerServerEvent('taxi:taxiGiveCourier', src)
		else
			ESX.chatMessage('Baraye anjam in kar az mashin piade shid', 'plarms')
		end
	end, 2.5)
end