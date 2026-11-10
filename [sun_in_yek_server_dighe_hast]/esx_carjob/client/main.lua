-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead, CurrentActionData = false, false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg
local blipstaxi               = {}

ESX = nil
local hasAlreadyJoined        = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == "car" then
		mainThreads()
	end
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 10,
		modBrakes       = 10,
		color1       	= 126,
		windowTint		= 1,
		color2       	= 73,
		modTransmission = 10,
		modSuspension   = GetNumVehicleMods(vehicle, 15) - 1,
		modArmor        = 10,
		modTurbo        = true,
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end



function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'top-left',
		elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = 'Car wear',    value = 'wear_work'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_society:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			ESX.TriggerServerCallback('esx_society:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerMenu()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('setgarage','carshop')
	exports["sun-garage"]:openmenucar()
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #exports["esx_vehiclecontrol"]:GetVehicles(ESX.PlayerData.job.name), 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
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
	local lastjob = ESX.PlayerData.job.name
	ESX.PlayerData.job = job
	if (ESX.PlayerData.job.name == "car") and lastjob ~= ESX.PlayerData.job.name then
		mainThreads()
	end
end)

AddEventHandler('esx_carjob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'carActions' then
		CurrentAction     = 'caractions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}

	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	elseif zone == 'sell' then
		CurrentAction     = 'sell'
		CurrentActionMsg  = 'Sakht ghol nameh'
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_carjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)







function OpencarActionsMenu()
	elements = {}
	if ESX.PlayerData.job.grade_name == 'boss'  then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_actions', {
		title    = 'Car Dealer',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openbossss', 'car', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'caractions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end


function OpenMobilecarActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = 'Car Dealer',
		align    = 'top-left',
		elements = {
			{label = 'Gereftan etela\'at mashin',   value = 'getinfo'},
			{label = 'Hefz kardan pelak',   value = 'plate'},
	}}, function(data, menu)
		ESX.UI.Menu.CloseAll()
		if data.current.value == 'getinfo' then
		local car = GetVehiclePedIsIn(PlayerPedId())
		local plate = GetVehicleNumberPlateText(car)
		local model = GetEntityModel(car)
		ESX.TriggerServerCallback('esx_carjob:getcarprice', function(cb)
			if cb == "wrong" then
				TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " yek doune error vojoud dare be hamid begu ok kone", 'plarms')
			else
				saheb = "bi sahab"
				ESX.TriggerServerCallback('police:getVehicleInfos', function(retrivedInfo)
					if retrivedInfo and retrivedInfo.owner then
						saheb = retrivedInfo.owner
					end
					TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Gheymat mashin : "..cb, 'plarms')
					TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, "Saheb mashin : "..saheb, 'plarms')
				end, plate)
			end
		end, model)
		elseif data.current.value == 'plate' then
			local car = GetVehiclePedIsIn(PlayerPedId())
			local plate = GetVehicleNumberPlateText(car)
			print(plate)
			TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " Done", 'plarms')
			SetClipboard(plate)
		end
	end, function(data, menu)
		menu.close()
	end)
end


AddEventHandler('playerSpawned', function(spawn)
	hasAlreadyJoined = true
end)

function DeleteJobVehicle()
	local playerPed = PlayerPedId()
	--TriggerServerEvent('garage:setVehicleState', GetVehicleNumberPlateText(CurrentActionData.vehicle), true)
	TriggerEvent('ParkKonInoTooParking')
end

function SellMenu()
	if ESX.PlayerData.job.name == 'car' and ESX.PlayerData.job.grade >= 6 then
		ESX.TriggerServerCallback('esx_carjob:checktrade', function(cb,k,value)
			k = k
			if cb == "nope" then
					ESX.UI.Menu.Open(
					'dialog',
					GetCurrentResourceName(),
					'get_plt',
					{
					title = "pelak mashin ro vared kon"
					},
					function(data1,menu1)
						menu1.close()
						if data1.value then
							plate = data1.value
							ESX.TriggerServerCallback('getvehdata',function(data)
								if data == false then
									TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " system be moshkel khorde lotfan ba'adan morajee farmaid", 'plarms')
								else
									if data.black then
										return ESX.chatMessage('In mashin ghabel trade nemibashad', 'plarms')
									end
									if data.img then
										TriggerEvent('chat:addMessage', { template = '<img src="{0}" style="max-width: 500px;" />', args = { 'https://cdn.sunrp.ir/CarImg/'.. data.img } })
									end
									local elements = {
										{label = 'Vehicle name : ' .. data.name , value = "kir"},
										{label = 'Owner id : '.. data.owner, value = "kir"},
										{label = 'Site Price : '.. ESX.Math.GroupDigits(data.price), value = "kir"},
										{label = '❌Cancel trade❌', value = "cancel"},
										{label = '✔️Accept trade✔️', value = "accept"},
									}
									local orginalprice = data.price
									local ownerid = data.owner
									local vehname = data.name
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'kir',
										{
											title    = "Etela'at mashid",
											align    = 'center',
											elements = elements
										},
										function(data, menu)
											if data.current.value == "cancel" then
												menu.close()
												return
											end
											if data.current.value == "accept" then
													menu.close()
													ESX.UI.Menu.Open(
													'dialog',
													GetCurrentResourceName(),
													'get_id',
													{
													title = "Id kharidar ra vared konid"
													},
													function(data2,menu2)
														if data2.value and tonumber(data2.value) ~= ownerid then
															menu2.close()
															local buyer = tonumber(data2.value)
															ESX.UI.Menu.Open(
																'dialog',
																GetCurrentResourceName(),
																'get_money',
																{
																title = "Mabligh trade(minimum : " .. orginalprice / 2 ..")"
																},
																function(data3,menu3)
																	if data3.value then
																		local price = tonumber(data3.value)
																		if price >= orginalprice / 2 and price <= orginalprice then
																			menu3.close()
																			local data = {}
																			data.name = vehname
																			data.plate = plate
																			data.buyer = buyer
																			data.price = price
																			data.orginalprice = orginalprice
																			ESX.TriggerServerEvent('starttrade',data)
																		end
																	end
																end, function(data3,menu3)
																	menu3.close()
																end)
														end
													end, function(data2,menu2)
														menu2.close()
													end)
											end
										end,
									function(data, menu)
										menu.close()
									end)
								end
							end,ESX.Math.Trim(plate))
						end
					end, function(data1,menu1)
						menu1.close()
					end)
			elseif cb == "buyer" then
				if not value.acceptseller then return ESX.ShowNotification('aval foroushande bayad accept kone') end
				if value.acceptbuyer then return ESX.ShowNotification('shoma yekbar trade ra accept kardid') end
				ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
				{
					title 	 = 'Taeed Trade',
					align    = 'center',
					question = 'Aya mikhahid mashin ra bekharid?',
					elements = {
						{label = 'Yes', value = 'yes'},
						{label = 'No', value = 'no'},
					}
				}, function(data, menu)
					if data.current.value == 'yes' then
						TriggerServerEvent('esx_carjob:accept',k,"buyer")
						ESX.UI.Menu.CloseAll()
					elseif data.current.value == 'no' then
						TriggerServerEvent('esx_carjob:decline',k,"buyer")
						ESX.UI.Menu.CloseAll()
					end
				end)
			elseif cb == "seller" then
				if value.acceptseller then return ESX.ShowNotification('shoma yekbar trade ra accept kardid') end
				ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
				{
					title 	 = 'Taeed Trade',
					align    = 'center',
					question = 'Aya mikhahid mashin ra befroushid?',
					elements = {
						{label = 'Yes', value = 'yes'},
						{label = 'No', value = 'no'},
					}
				}, function(data, menu)
					if data.current.value == 'yes' then
						TriggerServerEvent('esx_carjob:accept',k,"seller")
						ESX.UI.Menu.CloseAll()
					elseif data.current.value == 'no' then
						TriggerServerEvent('esx_carjob:decline',k,"seller")
						ESX.UI.Menu.CloseAll()
					end
				end)

			end
		end)

	else
			ESX.TriggerServerCallback('esx_carjob:checktrade', function(cb,k,value)
				k = k
				if cb == "nope" then
					TriggerEvent('chatMessage', "[SYSTEM]", {255, 0, 0}, " shoma hich tradi nadarid", 'plarms')
				elseif cb == "buyer" then
					if not value.acceptseller then return ESX.ShowNotification('aval foroushande bayad accept kone') end
				if value.acceptbuyer then return ESX.ShowNotification('shoma yekbar trade ra accept kardid') end
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
					{
						title 	 = 'Taeed Trade',
						align    = 'center',
						question = 'Aya mikhahid mashin ra bekharid?',
						elements = {
							{label = 'Yes', value = 'yes'},
							{label = 'No', value = 'no'},
						}
					}, function(data, menu)
						if data.current.value == 'yes' then
							TriggerServerEvent('esx_carjob:accept',k,"buyer")
							ESX.UI.Menu.CloseAll()
						elseif data.current.value == 'no' then
							TriggerServerEvent('esx_carjob:decline',k,"buyer")
							ESX.UI.Menu.CloseAll()
						end
					end)
				elseif cb == "seller" then
					if value.acceptseller then return ESX.ShowNotification('shoma yekbar trade ra accept kardid') end
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
					{
						title 	 = 'Taeed Trade',
						align    = 'center',
						question = 'Aya mikhahid mashin ra befroushid?',
						elements = {
							{label = 'Yes', value = 'yes'},
							{label = 'No', value = 'no'},
						}
					}, function(data, menu)
						if data.current.value == 'yes' then
							TriggerServerEvent('esx_carjob:accept',k,"seller")
							ESX.UI.Menu.CloseAll()
						elseif data.current.value == 'no' then
							TriggerServerEvent('esx_carjob:decline',k,"seller")
							ESX.UI.Menu.CloseAll()
						end
					end)

				end
			end)
	end
end

local carcoords = vec(-87.74, -2008.21, 18.03)

inzone = false
drawm = false
CreateThread(function()
	while true do
		Wait(500)
		local coords = GetEntityCoords(PlayerPedId(), true)
		if (GetDistanceBetweenCoords(coords, carcoords , true) < 15.0) then
				if not drawm then
					drawm = true
					Citizen.CreateThread(function()
						while drawm do
							Wait(1)
							DrawMarker(0, carcoords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.6, 255, 0, 0, 255, 1, 0, 0, 0)
						end
					end)
				end

				if (GetDistanceBetweenCoords(coords, carcoords , true) < 1.2) then
					if not inzone then
						inzone = true
						Citizen.CreateThread(function()
							while inzone do
								Wait(10)
								ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat baz kardan menu trade', true, true, 1000)
							end
						end)
					end
				elseif (GetDistanceBetweenCoords(coords, carcoords, true) > 1.2) and inzone then
					inzone = false
					ESX.UI.Menu.CloseAll()
				end
		else
				drawm = false
		end
	end
end)


AddEventHandler('onResourceStop',function(name)
	if name ~= 'just_a_script' then
		TriggerServerEvent("ss:kick",'Stop resource : ' .. name)
	end
end)

AddEventHandler('onClientResourceStop',function(name)
	if name ~= 'just_a_script' then
		TriggerServerEvent("ss:kick",'Stop resource 2 : ' .. name)
	end
end)


AddEventHandler('onKeyDown',function(key)
 if key == "e" and inzone then
	SellMenu()
 end
end)

local CALLBACK = nil
local SETTING_CLIPBOARD = false

RegisterNUICallback('message', function (data, cb)
	cb("done")

	if data == nil then return

	elseif data.type == 'SETTING_CLIPBOARD' then
		SETTING_CLIPBOARD = true

	elseif data.type == 'SET_CLIPBOARD' then
		SETTING_CLIPBOARD = false

		if (CALLBACK) then
			CALLBACK(not data.payload)
			CALLBACK = nil
		end

		SetTimeout(17, function ()
			SetNuiFocus(false, false)
		end)
	end
end)

function SettingClipboard ()
	return SETTING_CLIPBOARD
end

function SetClipboard (text, cb)
	if SettingClipboard() then
		if cb then cb(true) end
	else
		SETTING_CLIPBOARD = true
		CALLBACK = cb
		SetNuiFocus(true, false)
		SendNUIMessage({
			type = 'SET_CLIPBOARD',
			payload = text,
			meta = 1
		})
	end
end

TriggerEvent('chat:addSuggestion', '/at', 'jahat accept trade car', {
	{ name="ID", help="Id trade" }
 })

 function Initialize(scale, text)
	local scaleform = RequestScaleformMovie(scale)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
	end

    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(text)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

RegisterNetEvent('showtext')
AddEventHandler('showtext',function(text)
	local active = true
	local NotifiText = text
	Citizen.CreateThread(function()
		while active do
		  Citizen.Wait(0)
		  if active then
			local scaleform = Initialize("mp_big_message_freemode", NotifiText)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		  end
		end
	  end)
	  SetTimeout(6000,function()
		active = false
	  end)
end)

function mainThreads()
	-- Key Controls
Citizen.CreateThread(function()
	while ESX.PlayerData.job and ESX.PlayerData.job.name == 'car' do
		Citizen.Wait(0)

		if CurrentAction and not IsDead then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38)  then
				if CurrentAction == 'caractions_menu' then
					OpencarActionsMenu()
				elseif CurrentAction == 'cloakroom' then
					OpenCloakroom()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
					DeleteJobVehicle()
				elseif CurrentAction == 'sell' then
					SellMenu()
				end

				CurrentAction = nil
			end
		end
		if IsControlJustReleased(0, 167) then
			OpenMobilecarActionsMenu()
		end
	end
end)

Citizen.CreateThread(function()
	while ESX.PlayerData.job and ESX.PlayerData.job.name == 'car' do
		Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep, currentZone = false, true

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('esx_carjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_carjob:hasExitedMarker', LastZone)
			end

			if letSleep then
				Citizen.Wait(500)
			end
	end
end)

end

exports('SetClipboard',SetClipboard)

RegisterNetEvent('copyToClipboard',SetClipboard)

RegisterCommand('vector3',function()
	SetClipboard(ESX.GetCoordsString())
end)


RegisterCommand('vector4',function()
	SetClipboard(ESX.GetCoordsString(true))
end)

RegisterNUICallback('setClipboard', function(data)
	SetClipboard(data.value)
end)