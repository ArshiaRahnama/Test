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

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local DragStatus              = {}
DragStatus.IsDragged          = false
dragiss                       = false
local hasAlreadyJoined        = false
local blipsCops               = {}
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function SetVehicleMaxMods_fbi(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 2,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		plateIndex      = 1,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function TeleportFadeEffect_fbi(entity, coords)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(1)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function cleanPlayer_fbi(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform_fbi(job, playerPed)
	 TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			if Config_fbi.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config_fbi.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		elseif tonumber(skin.sex) == 1 then
			if Config_fbi.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config_fbi.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
			if job == 'swat_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomMenu_fbi()
	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}
		local nname = {}
		local playerPed = PlayerPedId()
		local grade = PlayerData.job.grade_name
		local dvisname
		local elements = {
			{label = "Lebas Kar", value = 'work_wear'},
			{ label = _U('citizen_wear'), value = 'citizen_wear' },

			{label = 'Vest', value = 'wmenu'}
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


		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			align    = 'left',
			elements = elements
		}, function(data, menu)

			cleanPlayer_fbi(playerPed)

			if data.current.value == 'citizen_wear' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if data.current.value == 'work_wear' then
				local job =  PlayerData.job.name
				local gradenum =  PlayerData.job.grade




				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)

						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end

					end,gradenum, job)

				end)


			end
			if data.current.value == 'wmenu' then

				SetPedArmour(playerPed, 100)



















			end

			if data.current.value == 'division_lebas' then

				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					local job =  PlayerData.job.name
					ESX.TriggerServerCallback('esx_society:getUniformsDivision', function(SkinMale, SkinFemale)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
						else
							TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
						end
					end, data.current.diviname, job)

				end)
			end

		end, function(data, menu)
			menu.close()
			CurrentAction     = 'menu_cloakroom'
			CurrentActionMsg  = _U('open_cloackroom')
			CurrentActionData = {}
		end)
	end)
end

function OpenArmoryMenu_fbi(station)

	if Config_fbi.EnableArmoryManagement then

		local elements = {
			{label = _U('get_weapon'),     value = 'get_weapon'},
			{label = _U('put_weapon'),     value = 'put_weapon'},
			{label = _U('remove_object'),  value = 'get_stock'},
			{label = _U('deposit_object'), value = 'put_stock'}
		}

		if PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = _U('buy_weapons'), value = 'buy_weapons'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'get_weapon' then
				OpenGetWeaponMenu_fbi()
			elseif data.current.value == 'put_weapon' then
				OpenPutWeaponMenu_fbi()
			elseif data.current.value == 'buy_weapons' then
				OpenBuyWeaponsMenu_fbi(station)
			elseif data.current.value == 'put_stock' then
				OpenPutStocksMenu_fbi()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu_fbi()
			end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)

	else

		local elements = {}

		for i=1, #Config_fbi.fbiStations[station].AuthorizedWeapons, 1 do
			local weapon = Config_fbi.fbiStations[station].AuthorizedWeapons[i]
			table.insert(elements, {
				label = ESX.GetWeaponLabel(weapon.name),
				value = weapon.name
			})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local weapon = data.current.value
			TriggerServerEvent('esx_fbi_job:giveWeapon', weapon, 1000)
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = _U('open_armory')
			CurrentActionData = {station = station}
		end)

	end

end

function OpenVehicleSpawnerMenu_fbi(station, partNum)
	local vehicles = Config_fbi.fbiStations[station].Vehicles
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
	local steamhex = PlayerData.identifier
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
					local Vehicles = Config_fbi.AuthorizedVehicles.Shared
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
					local Vehicles2 = Config_fbi.AuthorizedVehicles.Shared
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
					title    = _U('vehicle_menu'),
					align    = 'left',
					elements = elements
				}, function(data, menu)
					menu.close()

					local model   = data.current.model

					if model then
						if not DoesEntityExist(vehicle) then

							local playerPed = PlayerPedId()

							local function requestPlate()
								local plate = lib.inputDialog('Enter Vehicle Plate', {'Plate (5 characters)'}, {max = 6})
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
												end, "FBI" .. plate[1])
												menu.close()
												local texture2 = lib.alertDialog({
													header = 'FBI Texture',
													content = 'Aya Mikhahid Ba Texture Spawn Shavad?',
													centered = true,
													cancel = true
												})
												if texture2 == 'confirm' then
													Wait(1000)
													spawnvehicles_fbi(data, plate, vehicle, station, partNum, true)
												else
													Wait(1000)
													spawnvehicles_fbi(data, plate, vehicle, station, partNum, false)
												end

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 5 then
												menu.close()

												local texture = lib.alertDialog({
													header = 'FBI Texture',
													content = 'Aya Mikhahid Ba Texture Spawn Shavad?',
													centered = true,
													cancel = true
												})
												if texture == 'confirm' then
													spawnvehicles_fbi(data, plate, vehicle, station, partNum, true)
												else
													spawnvehicles_fbi(data, plate, vehicle, station, partNum, false)
												end


											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Mashin Bayad 5 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "FBI" .. plate[1])
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

function spawnvehicles_fbi(data, plate, vehicle, station, partNum, texchar)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_fbi.fbiStations[station].Vehicles
	local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoints.x, vehicles[partNum].SpawnPoints.y, vehicles[partNum].SpawnPoints.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoints, vehicles[partNum].SpawnPoints.heading, function(vehicle)
		if vehicle then

			local playerPed = PlayerPedId()

			local Vehicles2 = Config_fbi.AuthorizedVehicles.Shared
			if texchar then
				for _, vehicle2 in ipairs(Vehicles2) do
					if vehicle2.Extra and vehicle2.model == data.current.model then
						for extraName, extraValue in pairs(vehicle2.Extra) do
							SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
						end
					end
				end
			else
				for _, vehicle2 in ipairs(Vehicles2) do
					if vehicle2.Extra and vehicle2.model == data.current.model then
						for extraName, extraValue in pairs(vehicle2.Extra) do
							SetVehicleExtra(vehicle, tonumber(extraName), 1)
						end
					end
				end
			end

			if texchar then
				SetVehicleLivery(vehicle, 6)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 6)
			else
				SetVehicleLivery(vehicle, 7)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 7)
			end

			SetVehicleMaxMods_fbi(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleRadioEnabled(vehicle, false)
			SetVehicleFuelLevel(vehicle, 100.0)

			SetVehicleNumberPlateText(vehicle, "FBI" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Mashin Ba Plake^2 FBI'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
			})

		end
	end)

end

function OpenheliSpawnerMenu_fbi(station, partNum)
	local vehicles = Config_fbi.fbiStations[station].Heli
	ESX.UI.Menu.CloseAll()

	local elements = {}
	local elements2 = {}

	local grade = PlayerData.job.grade
	local job = PlayerData.job.name
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
					local Vehicles = Config_fbi.AuthorizedVehicles.Sharedheli
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
					local Vehicles2 = Config_fbi.AuthorizedVehicles.Sharedheli
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
								local plate = lib.inputDialog('Enter Heli Plate', {'Plate (5 characters)'}, {max = 6})
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
												end, "FBI" .. plate[1])
												menu.close()

												local texture = lib.alertDialog({
													header = 'FBI Texture',
													content = 'Aya Mikhahid Ba Texture Spawn Shavad?',
													centered = true,
													cancel = true
												})
												if texture == 'confirm' then
													spawnheliss_fbi(data, plate, vehicle, station, partNum, true)
												else
													spawnheliss_fbi(data, plate, vehicle, station, partNum, false)
												end


											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 5 then
												menu.close()

												local texture2 = lib.alertDialog({
													header = 'FBI Texture',
													content = 'Aya Mikhahid Ba Texture Spawn Shavad?',
													centered = true,
													cancel = true
												})
												if texture2 == 'confirm' then
													spawnheliss_fbi(data, plate, vehicle, station, partNum, true)
												else
													spawnheliss_fbi(data, plate, vehicle, station, partNum, false)
												end
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Heli Bayad 5 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "FBI" .. plate[1])
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
		end, PlayerData.identifier)
	end, grade, job)
end

function spawnheliss_fbi(data, plate, vehicle, station, partNum, texchur)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_fbi.fbiStations[station].Heli
	local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoints.x, vehicles[partNum].SpawnPoints.y, vehicles[partNum].SpawnPoints.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, vehicles[partNum].SpawnPoints, vehicles[partNum].SpawnPoints.heading, function(vehicle)
		if vehicle then

			local playerPed = PlayerPedId()


			local Vehicles2 = Config_fbi.AuthorizedVehicles.Shared

			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end


			if texchur then
				SetVehicleLivery(vehicle, 6)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 6)
			else
				SetVehicleLivery(vehicle, 7)
				Citizen.Wait(500)
				SetVehicleLivery(vehicle, 7)
			end


			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_fbi(vehicle)
			SetVehicleNumberPlateText(vehicle, "FBI" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()





			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 FBI'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

function OpenfbiActionsMenu_fbi()
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
		local elements ={}
		local isdivision = false
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
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},
			{label = _U('object_spawner'),		value = 'object_spawner'}
		}

		if isdivision then
			table.insert(elements, {label = 'Extra Division', value = 'extra_division'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fbi_actions', {
			title    = _U('fbi_actions'),
			align    = 'left',
			elements = elements

		}, function(data, menu)

			if data.current.value == 'citizen_interaction' then
				local elements = {
					{label = _U('id_card'),			value = 'identity_card'},
					{label = _U('search'),			value = 'body_search'},
					{label = _U('handcuff'),		value = 'handcuff'},
					{label = _U('uncuff'),		value = 'uncuff'},
					{label = _U('drag'),			value = 'drag'},
					{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
					{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
					{label = _U('fine'),			value = 'fine'},
					{label = _U('unpaid_bills'),	value = 'unpaid_bills'}
				}

				if Config_fbi.EnableLicenses then
					table.insert(elements, {
						label = _U('license_check'),
						value = 'license'
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
					title    = _U('citizen_interaction'),
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						local action = data2.current.value

						if action == 'identity_card' then
							OpenIdentityCardMenu_fbi(closestPlayer)
						elseif action == 'body_search' then
							if IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
								local text = 'Shoro Be Gashtane Fard Mikone '
								TriggerServerEvent('3dme:shareDisplay', text, true)
								OpenBodySearchMenu(closestPlayer)
							elseif not IsPedSittingInAnyVehicle(GetPlayerPed(closestPlayer)) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
								ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)

									local text = 'Shoro Be Gashtane Fard Mikone '
									TriggerServerEvent('3dme:shareDisplay', text, true)
									OpenBodySearchMenu(closestPlayer)

								end, GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Shoma Ejaze Search Nadarid!')
							end
						elseif action == 'handcuff' then

							playerPed = PlayerPedId()
							SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
							local target, distance = ESX.Game.GetClosestPlayer()
							playerheading = GetEntityHeading(playerPed)
							playerlocation = GetEntityForwardVector(PlayerPedId())
							playerCoords = GetEntityCoords(PlayerPedId())
							local target_id = GetPlayerServerId(target)
							if distance <= 2.0 then
								if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
									ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
										if not Cuff then

											if not IsInjure or not IsDead then
												TriggerServerEvent('esx:requestarrestpd', target_id, playerheading, playerCoords, playerlocation, false)


											else
												ESX.ShowNotification("~y~Shoma Nemitavanid Player Zakhmi Ra Cuff Konid")
											end
										else
											ESX.ShowNotification("~y~Shoma Nemitavanid Kasi Ra Ke Cuff Boode Ast Cuff Konid")
										end
									end, GetPlayerServerId(target))
								else
									ESX.ShowNotification('~r~Shoma Nemitavanid Kasi Ke Dar Mashin Ast Ra Cuff Konid!')
								end
							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end

						elseif action == 'uncuff' then

							playerPed = PlayerPedId()
							SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
							local target, distance = ESX.Game.GetClosestPlayer()
							playerheading = GetEntityHeading(playerPed)
							playerlocation = GetEntityForwardVector(PlayerPedId())
							playerCoords = GetEntityCoords(PlayerPedId())
							local target_id = GetPlayerServerId(target)
							if distance <= 2.0 then
								TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)

							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end

						elseif action == 'drag' then
							local target, distance = ESX.Game.GetClosestPlayer()
							if distance <= 2.0 then


								TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Shakhsi nazdik shoma nist')
							end
						elseif action == 'put_in_vehicle' then
							if dragiss then
								TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
							elseif IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then

								local targetSrc = GetPlayerServerId(closestPlayer)
								TriggerServerEvent('carry:respone',false)
								TriggerServerEvent('citizen:stopcarry', targetSrc)
								TriggerEvent('carry:cascel', false)

								ClearPedSecondaryTask(PlayerPedId())

								DetachEntity(PlayerPedId(), true, false)
								TriggerServerEvent('policejob:putInVehiclecarry', GetPlayerServerId(closestPlayer))
							else

								ESX.ShowNotification('~h~~r~Playeri Scort Nakardin!')
							end
						elseif action == 'out_the_vehicle' then
							local target, distance = ESX.Game.GetClosestPlayer()
								ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
								if Cuff then
									TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
								elseif IsDead then
									TriggerServerEvent('policejob:OutVehiclecarry', GetPlayerServerId(closestPlayer))
								end
							end, GetPlayerServerId(target))
						elseif action == 'fine' then
							OpenFineMenu_fbi(closestPlayer)
						elseif action == 'license' then
							ShowPlayerLicense_fbi(closestPlayer)
						elseif action == 'unpaid_bills' then
							OpenUnpaidBillsMenu_fbi(closestPlayer)
						end

					else
						ESX.ShowNotification(_U('no_players_nearby'))
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'vehicle_interaction' then
				local elements  = {}
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local vehicle   = ESX.Game.GetVehicleInDirection()

				if DoesEntityExist(vehicle) then
					table.insert(elements, {label = _U('vehicle_info'),	value = 'vehicle_infos'})
					table.insert(elements, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
					table.insert(elements, {label = _U('impound'),		value = 'impound'})
				end

				table.insert(elements, {label = _U('search_database'), value = 'search_database'})

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
					title    = _U('vehicle_interaction'),
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					coords  = GetEntityCoords(playerPed)
					vehicle = ESX.Game.GetVehicleInDirection()
					action  = data2.current.value

					if action == 'search_database' then
						LookupVehicle_fbi()
					elseif DoesEntityExist(vehicle) then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						if action == 'vehicle_infos' then
							OpenVehicleInfosMenu_fbi(vehicleData)

						elseif action == 'hijack_vehicle' then
							if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
								Citizen.Wait(20000)
								ClearPedTasksImmediately(playerPed)

								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ESX.ShowNotification(_U('vehicle_unlocked'))
							end
						elseif action == 'impound' then


							if CurrentTask.Busy then
								return
							end

							ESX.ShowHelpNotification(_U('impound_prompt'))

							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

							CurrentTask.Busy = true
							CurrentTask.Task = ESX.SetTimeout(10000, function()
								ClearPedTasks(playerPed)
								ImpoundVehicle_fbi(vehicle)
								Citizen.Wait(100)
							end)


							Citizen.CreateThread(function()
								while CurrentTask.Busy do
									Citizen.Wait(1000)

									vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
									if not DoesEntityExist(vehicle) and CurrentTask.Busy then
										ESX.ShowNotification(_U('impound_canceled_moved'))
										ESX.ClearTimeout(CurrentTask.Task)
										ClearPedTasks(playerPed)
										CurrentTask.Busy = false
										break
									end
								end
							end)
						end
					else
						ESX.ShowNotification(_U('no_vehicles_nearby'))
					end

				end, function(data2, menu2)
					menu2.close()
				end
				)

			elseif data.current.value == 'object_spawner' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
					title    = _U('traffic_interaction'),
					align    = 'top-left',
					elements = {
						{label = _U('cone'),		value = 'prop_roadcone02a'},
						{label = _U('barrier'),		value = 'prop_barrier_work05'},
						{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
						{label = _U('box'),			value = 'prop_boxpile_07d'}
					}
				}, function(data2, menu2)
					local model     = data2.current.value
					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local forward   = GetEntityForwardVector(playerPed)
					local x, y, z   = table.unpack(coords + forward * 1.0)

					if model == 'prop_roadcone02a' then
						z = z - 2.0
					end

					ESX.Game.SpawnObject(model, {
						x = x,
						y = y,
						z = z
					}, function(obj)
						SetEntityheading(obj, GetEntityHeading(playerPed))
						PlaceObjectOnGroundProperly(obj)
					end)

				end, function(data2, menu2)
					menu2.close()
				end)

			elseif data.current.value == 'extra_division' then
				OpendivisionsMenu_fbi()
			end

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenIdentityCardMenu_fbi(player)

	ESX.TriggerServerCallback('esx_fbi_job:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil

		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config_fbi.EnableESXIdentity then

			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end

		end

		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}

		if Config_fbi.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end

		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end

		if data.licenses ~= nil then

			table.insert(elements, {label = _U('license_label'), value = nil})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end

		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))

end

  function OpenBodySearchMenu(player)

	  ESX.TriggerServerCallback('esx_fbi_job:getOtherPlayerData', function(data)

		  local elements = {}

		  table.insert(elements, {label = _U('guns_label'), value = nil})
		  for i = 1, #data.weapons, 1 do
			  local fbisearchweapon = data.weapons[i].name
			  if fbisearchweapon ~= "WEAPON_MINIGUN" and fbisearchweapon ~= "WEAPON_SNIPERRIFLE"then
				  table.insert(elements, {
					  label    = _U('confiscate_weapon', ESX.GetWeaponLabel(fbisearchweapon), data.weapons[i].ammo),
					  value    = fbisearchweapon,
					  itemType = 'item_weapon',
					  amount   = data.weapons[i].ammo
				  })
			  end
		  end

		  table.insert(elements, {label = _U('inventory_label'), value = nil})
		  for i = 1, #data.inventory, 1 do
			  local fbisearchitem = data.inventory[i].name
			  if data.inventory[i].count > 0 and fbisearchitem ~= "hifi" and fbisearchitem ~= "customcoupon" then
				  table.insert(elements, {
					  label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					  value    = fbisearchitem,
					  itemType = 'item_standard',
					  amount   = data.inventory[i].count
				  })
			  end
		  end


		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		  {
			  title    = _U('search'),
			  align    = 'top-right',
			  elements = elements,
		  },
		  function(data, menu)

			  local itemType = data.current.itemType
			  local itemName = data.current.value
			  local amount   = data.current.amount

			  if data.current.value ~= nil then
				  TriggerServerEvent('esx_fbi_job:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				  OpenBodySearchMenu(player)
			  end

		  end, function(data, menu)
			  menu.close()
		  end)

	  end, GetPlayerServerId(player))

  end

function OpenFineMenu_fbi(player)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3}
		}
	}, function(data, menu)
		OpenFineCategoryMenu_fbi(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)

end

function OpenFineCategoryMenu_fbi(player, category)

	if Config_fbi.EnablePoliceFine then

		ESX.TriggerServerCallback('esx_fbi_job:getFineList', function(fines)

			local elements = {}

			for i=1, #fines, 1 do
				table.insert(elements, {
					label     = fines[i].label .. ' <span style="color: green;">$' .. fines[i].amount .. '</span>',
					value     = fines[i].id,
					amount    = fines[i].amount,
					fineLabel = fines[i].label
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
				title    = _U('fine'),
				align    = 'top-left',
				elements = elements,
			}, function(data, menu)

				local label  = data.current.fineLabel
				local amount = data.current.amount

				menu.close()

				if Config_fbi.EnablePlayerManagement then
					TriggerServerEvent('esx_billing:send2Bill', GetPlayerServerId(player), 'society_fbi', _U('fine_total', label), amount)
					TriggerEvent("Quest-System:Billing")
				else
					TriggerServerEvent('esx_billing:send2Bill', GetPlayerServerId(player), '', _U('fine_total', label), amount)
					TriggerEvent("Quest-System:Billing")
				end

				ESX.SetTimeout(300, function()
					OpenFineCategoryMenu_fbi(player, category)
				end)

			end, function(data, menu)
				menu.close()
			end)

		end, category)

	end

end

function LookupVehicle_fbi()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_fbi_job:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense_fbi(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('esx_fbi_job:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end

		if Config_fbi.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_fbi_job:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense_fbi(player)
			end)
		end,
		function(data, menu)
			menu.close()
		end
		)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu_fbi(player)

	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu_fbi(vehicleData)

	ESX.TriggerServerCallback('esx_fbi_job:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)

	end, vehicleData.plate)

end

function OpenGetWeaponMenu_fbi()

	ESX.TriggerServerCallback('esx_fbi_job:getArmoryWeapons', function(weapons)


			local grade = PlayerData.job.grade
			local job = PlayerData.job.name
            ESX.TriggerServerCallback('esx_society:getWeapons', function(authorizedWeapons)
			local elements = {}
			for i=1, #weapons, 1 do
				local found = false
				if weapons[i].count > 0 then
					if authorizedWeapons ~= nil then
						for _,sharedWeapons in ipairs(authorizedWeapons) do
							if found then break end
							if sharedWeapons.model == weapons[i].name and sharedWeapons.status == true then
								wname = ESX.GetWeaponLabel(weapons[i].name)
								table.insert(elements, {label = "x " .. weapons[i].count .. " " ..wname, value = weapons[i].name})
								found = true
							end
						end
					end
				end
			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('esx_fbi_job:removeArmoryWeapon', function()
				OpenGetWeaponMenu_fbi()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end, grade, job)
	end)
end

function OpenPutWeaponMenu_fbi()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('esx_fbi_job:addArmoryWeapon', function()
			OpenPutWeaponMenu_fbi()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu_fbi(station)

	ESX.TriggerServerCallback('esx_fbi_job:getArmoryWeapons', function(weapons)

		local elements = {}

		for i=1, #Config_fbi.fbiStations[station].AuthorizedWeapons, 1 do
			local weapon = Config_fbi.fbiStations[station].AuthorizedWeapons[i]
			local count  = 0

			for i=1, #weapons, 1 do
				if weapons[i].name == weapon.name then
					count = weapons[i].count
					break
				end
			end

			table.insert(elements, {
				label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. ESX.Math.GroupDigits(weapon.price),
				value = weapon.name,
				price = weapon.price
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons',
		{
			title    = _U('buy_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.TriggerServerCallback('esx_fbi_job:buy', function(hasEnoughMoney)
				if hasEnoughMoney then
					ESX.TriggerServerCallback('esx_fbi_job:addArmoryWeapon', function()
						OpenBuyWeaponsMenu_fbi(station)
					end, data.current.value, false)
				else
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end, data.current.price)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenGetStocksMenu_fbi()

	ESX.TriggerServerCallback('esx_fbi_job:getStockItems', function(items)

		local grade = PlayerData.job.grade
		local job = PlayerData.job.name
		ESX.TriggerServerCallback('esx_society:getItems', function(authorizedItems)
		local elements = {}
		local IsSwat = ESX.GetPlayerData()["IsSwat"]

		for i = 1, #items, 1 do
			local found = false
			if authorizedItems ~= nil then
				for _,sharedItems in ipairs(authorizedItems) do
					if found then break end
						if sharedItems.name == items[i].name and sharedItems.status == true then
							if items[i].name == "eclip" then
								if IsSwat then
									table.insert(
										elements,
										{label = "x" .. items[i].count .. " " .. items[i].label, value = items[i].name}
									)
									found = true
								end
							else
								table.insert(
									elements,
									{label = "x" .. items[i].count .. " " .. items[i].label, value = items[i].name}
								)
								found = true
							end
						end
					end
				end
			end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('fbi_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

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
					TriggerServerEvent('esx_fbi_job:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu_fbi()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end, grade, job)
	end)

end

function OpenPutStocksMenu_fbi()

	ESX.TriggerServerCallback('esx_fbi_job:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count, type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_fbi_job:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu_fbi()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenElevator_fbi(station, partNum)

	local elements = {
		{ label = _U('elevator_top'), value = 'elevator_top' },
		{ label = _U('elevator_down'), value = 'elevator_down' },
		{ label = _U('elevator_parking'), value = 'elevator_parking' }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'elevator', {
		title    = _U('elevator'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'elevator_top' then
			TeleportFadeEffect_fbi(PlayerPedId(), Config_fbi.fbiStations[station].Elevator[partNum].Top)
		end

		if data.current.value == 'elevator_down' then
			TeleportFadeEffect_fbi(PlayerPedId(), Config_fbi.fbiStations[station].Elevator[partNum].Down)
		end

		if data.current.value == 'elevator_parking' then
			TeleportFadeEffect_fbi(PlayerPedId(), Config_fbi.fbiStations[station].Elevator[partNum].Parking_heli)
		end
		menu.close()

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_elevator'
		CurrentActionMsg  = _U('open_elevator')
		CurrentActionData = {}
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('esx_fbi_job:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_fbi'),
		number     = 'fbi',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if type(PlayerData.job.name) == 'string' and PlayerData.job.name == 'fbi' and PlayerData.job.name == dispatchNumber then

		if Config_fbi.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

  RegisterNetEvent('esx_fbi_job:removeHandcuff')
  AddEventHandler('esx_fbi_job:removeHandcuff', function()
	IsHandcuffed = false
  end)

  RegisterNetEvent('esx_fbi_job:removeHandcuffFull')
  AddEventHandler('esx_fbi_job:removeHandcuffFull', function()

	  local playerPed = PlayerPedId()

	  IsHandcuffed = false

	  if Config_fbi.EnableHandcuffTimer and HandcuffTimer.Active then
		  ESX.ClearTimeout(HandcuffTimer.Task)
	  end

	  ClearPedSecondaryTask(playerPed)
	  SetEnableHandcuffs(playerPed, false)
	  DisablePlayerFiring(playerPed, false)
	  SetPedCanPlayGestureAnims(playerPed, true)


	  TriggerEvent("esx_fbi_job:removeHandcuff")
  end)

AddEventHandler('esx_fbi_job:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}

	elseif part == 'Armory' then

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}

	elseif part == 'VehicleSpawner' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	elseif part == 'HeliSpawner' then

		CurrentAction     = 'menu_heli_spawner'
		CurrentActionMsg  = _U('heli_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end

		end

	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}

	elseif part == 'Elevator' then

		CurrentAction     = 'menu_elevator'
		CurrentActionMsg  = _U('open_elevator')
		CurrentActionData = {station = station, partNum = partNum}

	end

end)

AddEventHandler('esx_fbi_job:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx_fbi_job:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'fbi' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_fbi_job:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_fbi_job:getarrested')
AddEventHandler('esx_fbi_job:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityheading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict_fbi('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	loadanimdict_fbi('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	TriggerServerEvent("esx_fbi_job:soundplay", "cuff", 0.5)

end)

RegisterNetEvent('esx_fbi_job:doarrested')
AddEventHandler('esx_fbi_job:doarrested', function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	Citizen.Wait(250)
	loadanimdict_fbi('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	TriggerServerEvent("esx_fbi_job:soundplay", "cuff", 0.5)
	Citizen.Wait(3000)

end)

RegisterNetEvent('esx_fbi_job:douncuffing')
AddEventHandler('esx_fbi_job:douncuffing', function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadanimdict_fbi('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	DragStatus.IsDragged = false
	TriggerServerEvent("esx_fbi_job:soundplay", "cuff", 0.5)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))

end)

RegisterNetEvent('esx_fbi_job:getuncuffed')
AddEventHandler('esx_fbi_job:getuncuffed', function(playerheading, playercoords, playerlocation)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	TriggerServerEvent('esx_uniquejobs:AntiCheatExempt', 5000, { teleport = true, speed = true })
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityheading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict_fbi('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	DragStatus.IsDragged = false
	TriggerServerEvent("esx_fbi_job:soundplay", "cuff", 0.5)
	Citizen.Wait(5500)
	IsHandcuffed = false
	ClearPedTasks(GetPlayerPed(-1))

end)

RegisterNetEvent('esx_fbi_job:drag')
AddEventHandler('esx_fbi_job:drag', function(copID)
	if not IsHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
	Citizen.Wait(1)
		if IsHandcuffed then
			playerPed = PlayerPedId()
			TriggerEvent("citizen:getCarry", function(carry)
				if DragStatus.IsDragged then
					targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

					if not IsPedSittingInAnyVehicle(targetPed) then
						AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					else
						DragStatus.IsDragged = false
						DetachEntity(playerPed, true, false)
					end
				elseif not carry then
					DetachEntity(playerPed, true, false)
				end
			end)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent("esx_fbi_job:putInVehicle")
AddEventHandler("esx_fbi_job:putInVehicle", function(vehicle)
        if IsHandcuffed then
            if not NetworkDoesNetworkIdExist(vehicle) then
                return
            end
            local veh = NetworkGetEntityFromNetworkId(vehicle)
            local ped = PlayerPedId()

            if IsVehicleSeatFree(veh, 1) then
                TaskWarpPedIntoVehicle(ped, veh, 1)
                TriggerEvent("Unique_Scripts_HuD:changeStatus", true)
            elseif IsVehicleSeatFree(veh, 2) then
                TaskWarpPedIntoVehicle(ped, veh, 2)
                TriggerEvent("Unique_Scripts_HuD:changeStatus", true)
            end
        end
    end )

  RegisterNetEvent('esx_fbi_job:putInVehicle')
  AddEventHandler('esx_fbi_job:putInVehicle', function()
	  local playerPed = PlayerPedId()
	  local coords    = GetEntityCoords(playerPed)

	  if not IsHandcuffed then
		  return
	  end

	  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		  local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		  if DoesEntityExist(vehicle) then

			  local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			  local freeSeat = nil

			  for i=maxSeats - 1, 0, -1 do
				  if IsVehicleSeatFree(vehicle, i) then
					  freeSeat = i
					  break
				  end
			  end

			  if freeSeat ~= nil then
				  TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				  DragStatus.IsDragged = false
			  end

		  end

	  end
  end)

RegisterNetEvent('esx_fbi_job:OutVehicle')
AddEventHandler('esx_fbi_job:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)


  Citizen.CreateThread(function()
	  while true do
		  Citizen.Wait(1)
		  if IsHandcuffed then

			DisableControlAction(2, 2, true)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['~'], true)
			DisableControlAction(2, Keys['X'], true)
			DisableControlAction(2, Keys['ESC'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['ENTER'], true)
			DisableControlAction(2, Keys['LEFTSHIFT'], true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TOP'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['SPACE'], true)
			DisableControlAction(2, Keys['Q'], true)
			DisableControlAction(0, Keys['E'], true)
			DisableControlAction(0, Keys['PAGEUP'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['F'], true)
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F8'], true)
			DisableControlAction(2, Keys['H'], true)
			DisableControlAction(2, Keys['M'], true)
			DisableControlAction(2, Keys['V'], true)
			DisableControlAction(2, Keys['P'], true)
			DisableControlAction(2, 59, true)
			DisableControlAction(2, Keys['LEFTCTRL'], true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 19, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
			DisableControlAction(0, 27, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 24,  true)
			DisableControlAction(0, 92,  true)
			DisableControlAction(0, 75,  true)
			SetPlayerCanDoDriveBy(player, false)
			DisablePlayerFiring(player, true)
		  if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 1) then
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1,
                             49, 0.0, false, false, false)
            end

        else
            Citizen.Wait(500)
        end
	  end
  end)

Citizen.CreateThread(function()

	for k,v in pairs(Config_fbi.fbiStations) do
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name == 'fbi' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config_fbi.fbiStations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Heli, 1 do
					if GetDistanceBetweenCoords(coords, v.Heli[i].Spawner.x, v.Heli[i].Spawner.y, v.Heli[i].Spawner.z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Heli[i].Spawner.x, v.Heli[i].Spawner.y, v.Heli[i].Spawner.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerDeletersColor.r, Config_fbi.MarkerDeletersColor.g, Config_fbi.MarkerDeletersColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				if Config_fbi.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config_fbi.DrawDistance then
							DrawMarker(Config_fbi.MarkerType, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end
				end

				for i=1, #v.Elevator, 1 do
					if GetDistanceBetweenCoords(coords, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end

					if GetDistanceBetweenCoords(coords, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end

					if GetDistanceBetweenCoords(coords, v.Elevator[i].Parking_heli.x, v.Elevator[i].Parking_heli.y, v.Elevator[i].Parking_heli.z, true) < Config_fbi.DrawDistance then
						DrawMarker(Config_fbi.MarkerType, v.Elevator[i].Parking_heli.x, v.Elevator[i].Parking_heli.y, v.Elevator[i].Parking_heli.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config_fbi.MarkerSize.x, Config_fbi.MarkerSize.y, Config_fbi.MarkerSize.z, Config_fbi.MarkerColor.r, Config_fbi.MarkerColor.g, Config_fbi.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

			end

		else
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(10)

		if PlayerData.job ~= nil and PlayerData.job.name == 'fbi' then

			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil

			for k,v in pairs(Config_fbi.fbiStations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Cloakroom'
						currentPartNum = i
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end

				for i=1, #v.Vehicles, 1 do
					if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleSpawner'
						currentPartNum = i
					end
				end

				for i=1, #v.Heli, 1 do
					if GetDistanceBetweenCoords(coords, v.Heli[i].Spawner.x, v.Heli[i].Spawner.y, v.Heli[i].Spawner.z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'HeliSpawner'
						currentPartNum = i
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					if GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'VehicleDeleter'
						currentPartNum = i
					end
				end

				if Config_fbi.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config_fbi.MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'BossActions'
							currentPartNum = i
						end
					end
				end

				for i=1, #v.Elevator, 1 do
					if GetDistanceBetweenCoords(coords, v.Elevator[i].Top.x, v.Elevator[i].Top.y, v.Elevator[i].Top.z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Elevator'
						currentPartNum = i
					end

					if GetDistanceBetweenCoords(coords, v.Elevator[i].Down.x, v.Elevator[i].Down.y, v.Elevator[i].Down.z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Elevator'
						currentPartNum = i
					end

					if GetDistanceBetweenCoords(coords, v.Elevator[i].Parking_heli.x, v.Elevator[i].Parking_heli.y, v.Elevator[i].Parking_heli.z, true) < Config_fbi.MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Elevator'
						currentPartNum = i
					end
				end

			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_fbi_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_fbi_job:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_fbi_job:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

		else
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_fbi_job:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_fbi_job:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'fbi' then

				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu_fbi()

				elseif CurrentAction == 'menu_armory' then
					if Config_fbi.MaxInService == -1 then
						OpenArmoryMenu_fbi(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu_fbi(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end

				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu_fbi(CurrentActionData.station, CurrentActionData.partNum)
				elseif CurrentAction == 'menu_heli_spawner' then
					OpenheliSpawnerMenu_fbi(CurrentActionData.station, CurrentActionData.partNum)

				elseif CurrentAction == 'delete_vehicle' then

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBosscarysMenu', 'fbi', function(data, menu)
						menu.close()
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false })

				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)

				elseif CurrentAction == 'menu_elevator' then
					OpenElevator_fbi(CurrentActionData.station, CurrentActionData.partNum)
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'fbi' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'fbi_actions') then
			if Config_fbi.MaxInService == -1 then
				OpenfbiActionsMenu_fbi()
			elseif playerInService then
				OpenfbiActionsMenu_fbi()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())

			CurrentTask.Busy = false
		end
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_fbi_job:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_fbi_job:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_fbi_job:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'fbi')

		if Config_fbi.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'fbi')
		end

		if Config_fbi.EnableHandcuffTimer and HandcuffTimer.Active then
			ESX.ClearTimeout(HandcuffTimer.Task)
		end
	end
end)

function StartHandcuffTimer_fbi()
	if Config_fbi.EnableHandcuffTimer and HandcuffTimer.Active then
		ESX.ClearTimeout(HandcuffTimer.Task)
	end

	HandcuffTimer.Active = true

	HandcuffTimer.Task = ESX.SetTimeout(Config_fbi.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_fbi_job:unrestrain')
		HandcuffTimer.Active = false
	end)
end

function loadanimdict_fbi(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
	end
end

function ImpoundVehicle_fbi(vehicle)

	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end

AddEventHandler('police:gargbygang', function(drrragss)
	dragiss = drrragss
end)

function OpendivisionsMenu_fbi()
    ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
        local elements = {}

        for k, v in pairs(check) do
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

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Divisions', {
            title = 'Divisions',
            align = 'left',
            elements = elements
        }, function(data, menu)

            local selectedDivision = data.current.name
            local dvisionlabel = data.current.label

            ESX.TriggerServerCallback('esx_society:swichdivision', function(success)
				OpendivisionsMenu_fbi()
			end, selectedDivision)

        end, function(data, menu)
            menu.close()
			OpenfbiActionsMenu_fbi()
        end)
    end)
end
