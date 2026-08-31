

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
local HasAlreadyEnteredMarkerb = false
local LastZone                = nil
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local OnJob                   = false
local CurrentlyTowedVehicle   = nil
local Blips                   = {}
local blipsMechanic           = {}
local hasAlreadyJoined        = false
local NPCOnJob                = false
local NPCTargetTowable        = nil
local NPCTargetTowableZone    = nil
local NPCHasSpawnedTowable    = false
local NPCLastCancel           = GetGameTimer() - 5 * 60000
local NPCHasBeenNextToTowable = false
local NPCTargetDeleterZone    = false
local IsDead                  = false
local IsBusy                  = false

ESX                           = nil

function SetVehicleMaxMods_mechanic(vehicle)
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

function SetVehicleMaxMods2_mechanic(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 1,
		modArmor		= 5,
		modTransmission = 2,
		modSuspension   = 4,
		color1          = 0,
		color2          = 0,
		modTurbo        = true,
	}


	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

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

-- Vehicles added live via esx_society's /addcarjob command (job = mechanic) get merged
-- into the static AuthorizedVehicles catalog, and their livery (captured at add-time)
-- is always re-applied on spawn so it never changes.
local CustomVehicleLiveries  = {}
local InjectedVehicleEntries = {}
local InjectedHeliEntries    = {}

local function removeInjected_mechanic(list, injected)
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
			removeInjected_mechanic(Config_mechanic.AuthorizedVehicles.Shared, InjectedVehicleEntries)
			removeInjected_mechanic(Config_mechanic.AuthorizedVehicles.Sharedheli, InjectedHeliEntries)
			InjectedVehicleEntries = {}
			InjectedHeliEntries    = {}
			CustomVehicleLiveries  = {}

			local custom = list and list['mechanic']
			if not custom then return end

			for _, v in ipairs(custom) do
				local entry = {label = v.label, model = v.model}

				if v.is_heli == 1 then
					table.insert(Config_mechanic.AuthorizedVehicles.Sharedheli, entry)
					table.insert(InjectedHeliEntries, entry)
				else
					table.insert(Config_mechanic.AuthorizedVehicles.Shared, entry)
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

function OpenheliSpawnerMenu_mechanic(station)
	local vehicles = Config_mechanic.Zones.MechanicActions.Helicopters
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
					local Vehicles = Config_mechanic.AuthorizedVehicles.Sharedheli
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
					local Vehicles2 = Config_mechanic.AuthorizedVehicles.Sharedheli
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
												end, "MC" .. plate[1])
												menu.close()

												Wait(1000)
												spawnheliss_mechanic(data, plate, vehicle, station, partNum)

											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Cancel Shod'}
												})

											end
										else
											if #plate[1] == 6 then
												menu.close()

												spawnheliss_mechanic(data, plate, vehicle, station, partNum)
											else
												TriggerEvent('chat:addMessage', {
													args = {'^1SYSTEM', 'Plake Heli Bayad 6 Character Bashad'}
												})
												requestPlate()
											end
										end
									end, "MC" .. plate[1])
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

function spawnheliss_mechanic(data, plate, vehicle, station, partNum)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_mechanic.Zones.VehicleDeleter2
	local vehicle = GetClosestVehicle(Config_mechanic.Zones.VehicleDeleter2.Pos.x, Config_mechanic.Zones.VehicleDeleter2.Pos.y, Config_mechanic.Zones.VehicleDeleter2.Pos.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, Config_mechanic.Zones.VehicleDeleter2.Pos, Config_mechanic.Zones.VehicleDeleter2.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'mechanic', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_mechanic(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
				SetVehicleLivery(vehicle, 3)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
				SetVehicleLivery(vehicle, 3)
			else
				SetVehicleMaxMods_mechanic(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_mechanic.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 3)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 3)

			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_mechanic(vehicle)
			SetVehicleNumberPlateText(vehicle, "MC" ..plate[1] )

      local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

      TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "MC" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 MC'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

function OpenMechanicActionsMenu_mechanic(partNum)
  local vehicles = Config_mechanic.Zones.MechanicActions
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
          local Vehicles = Config_mechanic.AuthorizedVehicles.Shared
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
          local Vehicles2 = Config_mechanic.AuthorizedVehicles.Shared
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
                        end, "MC" .. plate[1])
                        menu.close()

                        Wait(1000)
                        spawnvehicles_mechanic(data, plate, vehicle)

                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Cancel Shod'}
                        })

                      end
                    else
                      if #plate[1] == 6 then
                        menu.close()

                        spawnvehicles_mechanic(data, plate, vehicle)
                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Plake Mashin Bayad 6 Character Bashad'}
                        })
                        requestPlate()
                      end
                    end
                  end, "MC" .. plate[1])
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


        end)
      end, dvisionName, job)
    end, steamhex)
  end, grade, job)
end

function spawnvehicles_mechanic(data, plate, vehicle)
	plate[1] = string.upper(plate[1])
	local vehicles = Config_mechanic.Zones.MechanicActions
	local vehicle = GetClosestVehicle(Config_mechanic.Zones.VehicleDeleter.Pos.x, Config_mechanic.Zones.VehicleDeleter.Pos.y, Config_mechanic.Zones.VehicleDeleter.Pos.z, 3.0, 0, 71)
	ESX.Game.SpawnVehicleJobs(data.current.model, Config_mechanic.Zones.VehicleDeleter.Pos, Config_mechanic.Zones.VehicleDeleter.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'mechanic', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_mechanic(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
				SetVehicleLivery(vehicle, 3)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_mechanic(vehicle, 1)
				SetVehicleLivery(vehicle, 3)
			else
				SetVehicleMaxMods_mechanic(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_mechanic.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 3)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 3)

			if CustomVehicleLiveries[data.current.model] then
				SetVehicleLivery(vehicle, CustomVehicleLiveries[data.current.model])
			end
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(500)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_mechanic(vehicle)
			SetVehicleNumberPlateText(vehicle, "MC" ..plate[1] )

      local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

      TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "MC" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Mashin Ba Plake^2 MC'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
			})

		end
	end)

end

function OpenCloakroomMenu_mechanic()
  ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)

    local elements = {
      {label = _U('work_wear'),      value = 'cloakroom'},
      {label = _U('civ_wear'),       value = 'cloakroom2'},
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


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'mechanic_actions',
      {
        title    = _U('mechanic'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        if data.current.value == 'cloakroom' then
          menu.close()
      local job =  PlayerData.job.name
      local grade =  PlayerData.job.grade
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

      if data.current.value == 'cloakroom2' then
        menu.close()
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

            TriggerEvent('skinchanger:loadSkin', skin)

        end)
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

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mechanic_cloark_menu'
      CurrentActionMsg  = _U('open_cloark')
      CurrentActionData = {}
    end)
  end)
end

function OpenStockMenu_mechanic()

  local elements = {
    {label = _U('deposit_stock'),  value = 'put_stock'},
    {label = _U('withdraw_stock'), value = 'get_stock'}
  }

  if ESX.GetPlayerData().job.grade >= 10 then
    table.insert(elements, {label = _U('buy_items'), value = 'buy_items'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mechanic_actions',
    {
      title    = _U('mechanic'),
      align    = 'top-left',
      elements = elements
    },
    function(data, menu)


      if data.current.value == 'put_stock' then
        OpenPutStocksMenu_mechanic()
      end

      if data.current.value == 'get_stock' then
        OpenGetStocksMenu_mechanic()
      end

      if data.current.value == 'buy_items' then
        OpenBuyItemsMenu_mechanic()
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mechanic_stock_menu'
      CurrentActionMsg  = _U('open_stock')
      CurrentActionData = {}
    end
  )
end

function OpenBuyItemsMenu_mechanic()

	ESX.TriggerServerCallback('esx_mechanicjob:getStockItems', function(Iitems)

		local elements = {}

		for i=1, #Config_mechanic.AuthorizedItems, 1 do

		local Iitem = Config_mechanic.AuthorizedItems[i]
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
			ESX.TriggerServerCallback('esx_mechanicjob:buy', function(hasEnoughMoney)

				if hasEnoughMoney then
					ESX.TriggerServerCallback('esx_mechanic:buyArmoryItem', function()
						OpenBuyItemsMenu_mechanic(station)

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

function OpenBossActionsMenu_mechanic()


  if Config_mechanic.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
    table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
  end

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'mechanic_actions',
    {
      title    = _U('mechanic'),
      align    = 'top-left',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'boss_actions' then
        TriggerEvent('esx_society:openBosscarysMenu', 'mechanic', function(data, menu)
          menu.close()
        end)
      end

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'mechanic_boss_menu'
      CurrentActionMsg  = _U('open_boss')
      CurrentActionData = {}

    end
  )
end

function PlayerBlingMenu_mechanic()
	ESX.UI.Menu.CloseAll()
	dataplayer = {}
	local elements = {}
	local nearbyPlayers = getNearbyPlayers_mechanic(3)
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
		'default', GetCurrentResourceName(), 'bling_player_mc',
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
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification("No players nearby!")
                            else
                                TriggerServerEvent("esx_mechanicjob:blingrequest", playerid, GetPlayerServerId(PlayerId()), amount)

                            end
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)

					stopActiveMarker_mechanic()




				end


		end



		end, function(data, menu)
			menu.close()


		end, function(data, menu)
			local tttrp = true
			stopActiveMarker_mechanic()
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
					stopActiveMarker_mechanic()
				end
				Wait(0)
			end

		end,function()

		end
	)
end

RegisterNetEvent('esx_mechanicjob:OpenMenuDialog')
AddEventHandler('esx_mechanicjob:OpenMenuDialog', function(player, target, amount)

    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_bling',
        {
            title 	 = 'Qgabz Mechanic',
            align    = 'center',
            question = "Aya Shoma Qhabz ("..amount.."$) Ra Ghabol Darid ?",
            elements = {
                {label = 'Bale', value = 'yes'},
                {label = 'Kheir', value = 'no'},
            },
        },
        function(data, menu)
            if data.current.value == 'yes' then
                TriggerServerEvent('esx_billing:send2Bill2', target, player, 'society_mechanic', _U('mechanic'), amount)
                TriggerServerEvent("esx_mechanicjob:ChatMessage",target, player, true)

                ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'no' then

                TriggerServerEvent("esx_mechanicjob:ChatMessage",target, player, false)
                menu.close()

            end
        end
    )
end)

function getNearbyPlayers_mechanic(radius)
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
function stopActiveMarker_mechanic()
    if activeMarkerThread then
        activeMarkerThread = nil
    end
end

function OpenMobileMechanicActionsMenu_mechanic()
ESX.TriggerServerCallback('esx_mechanicjob:list', function(tedad)
  ESX.UI.Menu.CloseAll()
  ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
    local elements = {}

    elements = {
      {label = 'Request List ('..tedad..')',   value = 'requests'},
      {label = _U('billing'),       value = 'billing'},

      {label = _U('repair'),        value = 'fix_vehicle'},
      {label = _U('clean'),         value = 'clean_vehicle'},
      {label = "Flip",         value = 'flip_vehicle'},
      {label = _U('imp_veh'),       value = 'del_vehicle'},
      {label = "Flatbed",      value = 'dep_vehicle'},



    }

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

		if isdivision then
			table.insert(elements, {label = _U('extra_division'), value = 'extra_division'})
		end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'mobile_mechanic_actions',
      {
        title    = _U('mechanic'),
        align    = 'top-left',
        elements = elements
      },
    function(data, menu)
        if IsBusy then return end

        if data.current.value == 'billing' then
          local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
          if closestPlayer == -1 or closestDistance <= 2.0 then
            PlayerBlingMenu_mechanic()
          else
            ESX.ShowNotification(_U('no_players_nearby'))
          end

        end

        if data.current.value == 'extra_division' then

          OpendivisionsMenu_mechanic()

        end

        if data.current.value == 'hijack_vehicle' then

      local playerPed = GetPlayerPed(-1)
        local vehicle   = ESX.Game.GetVehicleInDirection()
        local coords    = GetEntityCoords(playerPed)

        if IsPedSittingInAnyVehicle(playerPed) then
          ESX.ShowNotification(_U('inside_vehicle'))
          return
        end

        if DoesEntityExist(vehicle) then

          IsBusy = true
          TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
          SetVehicleAlarm(vehicle, 1)
          StartVehicleAlarm(vehicle)
          SetVehicleAlarmTimeLeft(vehicle, 40000)
          TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
          TriggerEvent("mythic_progbar:client:progress", {
            name = "hijack_vehicle",
            duration = 30000,
            label = "Dar Hal LockPick Kardan Mashin",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
            }
          }, function(status)
            if not status then

            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ClearPedTasksImmediately(playerPed)

            ESX.ShowNotification(_U('vehicle_unlocked'))
            IsBusy = false
            TriggerEvent('esx_customItems:checkVehicleStatus', false)
            elseif status then
            IsBusy = false
            ClearPedTasksImmediately(playerPed)
            TriggerEvent('esx_customItems:checkVehicleStatus', false)
            end
          end)

        else
          ESX.ShowNotification(_U('no_vehicle_nearby'))
        end
    elseif data.current.value == 'flip_vehicle' then


      local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle ~= 0 then
        NetworkRequestControlOfEntity(vehicle)
        while not NetworkHasControlOfEntity(vehicle) do
          Citizen.Wait(100)
        end
        SetVehicleOnGroundProperly(vehicle)
      else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Hich mashini nazdik shoma nist!"}})
      end

    elseif data.current.value == 'requests' then
      OpenReqsList_mechanic()

    elseif data.current.value == 'fix_vehicle' then

      local playerPed = GetPlayerPed(-1)
        local vehicle   = ESX.Game.GetVehicleInDirection()
        local coords    = GetEntityCoords(playerPed)

        if IsPedSittingInAnyVehicle(playerPed) then
          ESX.ShowNotification(_U('inside_vehicle'))
          return
        end

      if DoesEntityExist(vehicle) then

        IsBusy = true
        TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
        TriggerEvent("mythic_progbar:client:progress", {
          name = "repair_vehicle",
          duration = 10000,
          label = "Dar Hal Tamir Kardan Mashin",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
          },
          animation = {
          animDict = "amb@prop_human_bum_bin@idle_a",
          anim = "idle_a",
          },
          prop = {
            model = "prop_cs_wrench",
          }
        }, function(status)
          if not status then
            if GetVehicleEngineHealth(vehicle) <= 400 then
              TriggerEvent("esx_mechanicjob:Repaire")
            end
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            ESX.ShowNotification(_U('vehicle_repaired'))
            IsBusy = false
            TriggerEvent('esx_customItems:checkVehicleStatus', false)

          elseif status then
          IsBusy = false
          TriggerEvent('esx_customItems:checkVehicleStatus', false)
          end
        end)


      else
        ESX.ShowNotification(_U('no_vehicle_nearby'))
      end

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
          TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
          TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
          TriggerEvent("mythic_progbar:client:progress", {
            name = "clean_vehicle",
            duration = 10000,
            label = "Dar Hal Tamiz Kardan Mashin",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
            },
          }, function(status)
            if not status then

            SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasksImmediately(playerPed)


            ESX.ShowNotification(_U('vehicle_cleaned'))
            IsBusy = false
            TriggerEvent('esx_customItems:checkVehicleStatus', false)

            elseif status then
            ClearPedTasksImmediately(playerPed)
            IsBusy = false
            TriggerEvent('esx_customItems:checkVehicleStatus', false)
            end
          end)

        else
          ESX.ShowNotification(_U('no_vehicle_nearby'))
        end
      elseif data.current.value == 'dep_vehicle' then
      menu.close()
            local playerped = GetPlayerPed(-1)
            local vehicle = 0
            local towmodel = GetHashKey('flatbed')
            local vehicles = {}
            local de = 0
            for k , v in pairs(ESX.Game.GetVehicles()) do
              if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(v)) <= 20 then
                if IsVehicleModel(v, towmodel) then
                  vehicle = v
                else
                  if IsEntityAttachedToAnyVehicle(v) then
                    de = v
                  elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(v)) <= 10 then
                    table.insert(vehicles,{label = GetDisplayNameFromVehicleModel(GetEntityModel(v)) .. ' (' .. GetVehicleNumberPlateText(v) ..')',vehicle = v})
                  end
                end
              end
            end
            if vehicle and de == 0 then
              function AttachVeh(targetVehicle)
                if RequestControl(targetVehicle) and RequestControl(vehicle) then
                  AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                else
                  ESX.ShowNotification('Yek moshkel dar attach kardan be vojoud amade')
                end
              end
        local elements = {}

      for k , v in pairs(vehicles) do
        table.insert(elements, {label = v.label, value = "yes" , VEH  = v.vehicle })

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'plate_lists', {

        title    = "Plak Ha",
        align    = 'bottom-right',
        elements = elements
      }, function(data2, menu2)





        if data2.current.value == 'yes' then
          AttachVeh(data2.current.VEH)
          menu2.close()

        end
        end, function(data2, menu2)
          menu2.close()
        end)

        end

            elseif de ~= 0 then
              if RequestControl(de) and RequestControl(vehicle) then
                AttachEntityToEntity(de, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                DetachEntity(de, true, true)
              else
                ESX.ShowNotification('Yek moshkel dar detach kardan be vojoud amade')
              end
            end

        elseif data.current.value == 'del_vehicle' then

          local ped = GetPlayerPed(-1)

        if DoesEntityExist(ped) and not IsEntityDead(ped) then
        local pos = GetEntityCoords( ped )

        if IsPedSittingInAnyVehicle(ped) then
          local vehicle = GetVehiclePedIsIn( ped, false )

          if GetPedInVehicleSeat(vehicle, -1) == ped then

            isBusy = true
            TriggerEvent("mythic_progbar:client:progress", {
              name = "impound_vehicle2",
              duration = 30000,
              label = "Toghif kardan mashin",
              useWhileDead = false,
              canCancel = true,
              controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
              },
            }, function(status)
              if not status then
                Wait(2000)
                ESX.ShowNotification(_U('vehicle_impounded'))
                ESX.Game.DeleteVehicle(vehicle)
                DeleteEntity(vehicle)
                TriggerEvent("esx_mechanicjob:Impond")
                IsBusy = false
              elseif status then
                ClearPedTasksImmediately(playerPed)
                IsBusy = false
              end
            end)

          else
          ESX.ShowNotification(_U('must_seat_driver'))
          end
        else

          local vehicle = ESX.Game.GetVehicleInDirection()

          if DoesEntityExist(vehicle) then

            IsBusy = true
            TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            TriggerEvent('esx_customItems:checkVehicleDistance', vehicle)
            TriggerEvent("mythic_progbar:client:progress", {
              name = "impound_vehicle",
              duration = 30000,
              label = "Impound kardan mashin",
              useWhileDead = false,
              canCancel = true,
              controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
              },
            }, function(status)
              if not status then
                ESX.ShowNotification(_U('vehicle_impounded'))
                ESX.Game.DeleteVehicle(vehicle)
                IsBusy = false
                TriggerEvent('esx_customItems:checkVehicleStatus', false)
                TriggerEvent("esx_mechanicjob:Impond")
              elseif status then
                ClearPedTasksImmediately(playerPed)
                IsBusy = false
                TriggerEvent('esx_customItems:checkVehicleStatus', false)
              end
            end)

          else
          ESX.ShowNotification(_U('must_near'))
          end
        end
      end
    end

        if data.current.value == 'object_spawner' then
      local playerPed = PlayerPedId()

      if IsPedSittingInAnyVehicle(playerPed) then
        ESX.ShowNotification(_U('inside_vehicle'))
        return
      end

          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions',
            {
              title    = _U('objects'),
              align    = 'top-left',
              elements = {
                {label = _U('roadcone'),     value = 'prop_roadcone02a'},
                {label = _U('toolbox'), value = 'prop_toolchest_01'},
              },
            },
            function(data2, menu2)

              local model     = data2.current.value
              local coords    = GetEntityCoords(playerPed)
              local forward   = GetEntityForwardVector(playerPed)
              local x, y, z   = table.unpack(coords + forward * 1.0)

              if model == 'prop_roadcone02a' then
                z = z - 1.0
              elseif model == 'prop_toolchest_01' then
                z = z - 1.0
              end

              ESX.Game.SpawnObject(model, {
                x = x,
                y = y,
                z = z
              }, function(obj)
                SetEntityHeading(obj, GetEntityHeading(playerPed))
                PlaceObjectOnGroundProperly(obj)
              end)

            end,
            function(data2, menu2)
              menu2.close()
            end
          )

        end

      end,
    function(data, menu)
      menu.close()
    end
    )
    end)
  end)
end

function OpenGetStocksMenu_mechanic()
  ESX.TriggerServerCallback('esx_mechanicjob:getStockItems', function(items)

		local grade = PlayerData.job.grade
		local job = PlayerData.job.name
		ESX.TriggerServerCallback('esx_society:getItems', function(authorizedItems)
		local elements = {}


		for i = 1, #items, 1 do
			local found = false
			if authorizedItems ~= nil then
				for _,sharedItems in ipairs(authorizedItems) do
					if found then break end
						if sharedItems.name == items[i].name and sharedItems.status == true then
							table.insert(
								elements,
								{label = "x" .. items[i].count .. " " .. items[i].label, value = items[i].name}
							)
							found = true
						end
					end
				end
			end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('mechanic_stock'),
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_mechanicjob:getStockItem', itemName, count)

              Citizen.Wait(1000)
              OpenGetStocksMenu_mechanic()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
    function(data, menu)
		menu.close()
    end)

end, grade, job)
  end)

end

RequestControl = function(object)
	NetworkRequestControlOfEntity(object)
	local timeout = 4000
	while timeout > 0 and not NetworkHasControlOfEntity(object) do
		Wait(100)
		timeout = timeout - 100
	end
	return NetworkHasControlOfEntity(object)
end

function OpenPutStocksMenu_mechanic()

ESX.TriggerServerCallback('esx_mechanicjob:getPlayerInventory', function(inventory)

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
        align    = 'top-left',
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
              ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              TriggerServerEvent('esx_mechanicjob:putStockItems', itemName, count)

              Citizen.Wait(1000)
              OpenPutStocksMenu_mechanic()
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

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function()
  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    local crochete = math.random(100)
    local alarm    = math.random(100)

    if DoesEntityExist(vehicle) then
      if alarm <= 33 then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
      end
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        if crochete <= 66 then
          SetVehicleDoorsLocked(vehicle, 1)
          SetVehicleDoorsLockedForAllPlayers(vehicle, false)
          ClearPedTasksImmediately(playerPed)
          ESX.ShowNotification(_U('veh_unlocked'))
        else
          ESX.ShowNotification(_U('hijack_failed'))
          ClearPedTasksImmediately(playerPed)
        end
      end)
    end

  end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function()
  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(10000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('body_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function()
  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
      vehicle = GetVehiclePedIsIn(playerPed, false)
    else
      vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
      TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
      Citizen.CreateThread(function()
        Citizen.Wait(20000)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        ClearPedTasksImmediately(playerPed)
        ESX.ShowNotification(_U('veh_repaired'))
      end)
    end
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job



end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)

  if zone == 'MechanicActions' or zone == 'MechanicActions2' then
    CurrentAction     = 'mechanic_actions_menu'
    CurrentActionMsg  = _U('open_actions')
    CurrentActionData = zone
    if zone == 'MechanicActions' then
        CurrentActionData = 1
    elseif zone == 'MechanicActions2' then
        CurrentActionData = 2
    end

  elseif zone == 'Helicopters' or zone == 'Helicopters2' then
    CurrentAction     = 'heli_actions2_menu'
    CurrentActionMsg  = _U('open_actions_heli')




  elseif zone == 'MechanicCloark' or zone == 'MechanicCloark2' then
    CurrentAction     = 'mechanic_cloark_menu'
    CurrentActionMsg  = _U('open_cloark')
	  CurrentActionData = {}

  elseif zone == 'MechanicStock' or zone == 'MechanicStock2' then
    CurrentAction     = 'mechanic_stock_menu'
    CurrentActionMsg  = _U('open_stock')
	  CurrentActionData = {}

  elseif zone == 'VehicleDeleter' or zone == 'VehicleDeleter2' then

    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then

      local vehicle = GetVehiclePedIsIn(ped)

      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('veh_stored')
      CurrentActionData = {vehicle = vehicle}

    end

  elseif zone == "GasCan" or zone == "GasCan2" then
    CurrentAction     = 'request_gascan'
    CurrentActionMsg  = "Baraye Daryaft Benzin ~INPUT_CONTEXT~ Ra Feshar Dahid"
    CurrentActionData = {}

  elseif zone == "BossActions" then
    CurrentAction     = 'mechanic_boss_menu'
    CurrentActionMsg  = _U('open_boss')
    CurrentActionData = {}
  end

end)


AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
  CurrentAction = nil
  CurrentActionData = nil
  ESX.UI.Menu.CloseAll()
end)


AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)

  local playerPed = PlayerPedId()

  if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) and not CurrentAction then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = _U('press_remove_obj')
    CurrentActionData = {entity = entity}
  end

end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
  local specialContact = {
    name       = _U('mechanic'),
    number     = 'mechanic',
    base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA4BJREFUWIXtll9oU3cUx7/nJA02aSSlFouWMnXVB0ejU3wcRteHjv1puoc9rA978cUi2IqgRYWIZkMwrahUGfgkFMEZUdg6C+u21z1o3fbgqigVi7NzUtNcmsac40Npltz7S3rvUHzxQODec87vfD+/e0/O/QFv7Q0beV3QeXqmgV74/7H7fZJvuLwv8q/Xeux1gUrNBpN/nmtavdaqDqBK8VT2RDyV2VHmF1lvLERSBtCVynzYmcp+A9WqT9kcVKX4gHUehF0CEVY+1jYTTIwvt7YSIQnCTvsSUYz6gX5uDt7MP7KOKuQAgxmqQ+neUA+I1B1AiXi5X6ZAvKrabirmVYFwAMRT2RMg7F9SyKspvk73hfrtbkMPyIhA5FVqi0iBiEZMMQdAui/8E4GPv0oAJkpc6Q3+6goAAGpWBxNQmTLFmgL3jSJNgQdGv4pMts2EKm7ICJB/aG0xNdz74VEk13UYCx1/twPR8JjDT8wttyLZtkoAxSb8ZDCz0gdfKxWkFURf2v9qTYH7SK7rQIDn0P3nA0ehixvfwZwE0X9vBE/mW8piohhl1WH18UQBhYnre8N/L8b8xQvlx4ACbB4NnzaeRYDnKm0EALCMLXy84hwuTCXL/ExoB1E7qcK/8NCLIq5HcTT0i6u8TYbXUM1cAyyveVq8Xls7XhYrvY/4n3gC8C+dsmAzL1YUiyfWxvHzsy/w/dNd+KjhW2yvv/RfXr7x9QDcmo1he2RBiCCI1Q8jVj9szPNixVfgz+UiIGyDSrcoRu2J16d3I6e1VYvNSQjXpnucAcEPUOkGYZs/l4uUhowt/3kqu1UIv9n90fAY9jT3YBlbRvFTD4fw++wHjhiTRL/bG75t0jI2ITcHb5om4Xgmhv57xpGOg3d/NIqryOR7z+r+MC6qBJB/ZB2t9Om1D5lFm843G/3E3HI7Yh1xDRAfzLQr5EClBf/HBHK462TG2J0OABXeyWDPZ8VqxmBWYscpyghwtTd4EKpDTjCZdCNmzFM9k+4LHXIFACJN94Z6FiFEpKDQw9HndWsEuhnADVMhAUaYJBp9XrcGQKJ4qFE9k+6r2+MG3k5N8VQ22TVglbX2ZwOzX2VvNKr91zmY6S7N6zqZicVT2WNLyVSehESaBhxnOALfMeYX+K/S2yv7wmMAlvwyuR7FxQUyf0fgc/jztfkJr7XeGgC8BJJgWNV8ImT+AAAAAElFTkSuQmCC'
  }
  TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

Citizen.CreateThread(function()
  for i,v in ipairs(Config_mechanic.Blips) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite (blip, 643)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('mechanic'))
    EndTextCommandSetBlipName(blip)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then

      local coords, letSleep = GetEntityCoords(PlayerPedId()), true

      for k,v in pairs(Config_mechanic.Zones) do

        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_mechanic.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, true, false, false, false)
          letSleep = false
        end
      end


      if letSleep then
			Citizen.Wait(500)
      end

    else
		Citizen.Wait(500)
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then
      local coords      = GetEntityCoords(PlayerPedId())
      local isInMarker  = false
      local currentZone = nil
      for k,v in pairs(Config_mechanic.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker  = true
          currentZone = k

        end
      end
      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone                = currentZone
        TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
      end
      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
      end
    end
  end
end)


Citizen.CreateThread(function()

  local trackedEntities = {
      'prop_roadcone02a',
      'prop_toolchest_01'
  }

  while true do

    Citizen.Wait(1000)

    if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        local closestDistance = -1
        local closestEntity   = nil

        for i=1, #trackedEntities, 1 do

          local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

          if DoesEntityExist(object) then

            local objCoords = GetEntityCoords(object)
            local distance  = GetDistanceBetweenCoords(coords.x,  coords.y,  coords.z,  objCoords.x,  objCoords.y,  objCoords.z,  true)

            if closestDistance == -1 or closestDistance > distance then
              closestDistance = distance
              closestEntity   = object
            end

          end

        end

        if closestDistance ~= -1 and closestDistance <= 3.0 then

          if LastEntity ~= closestEntity then
            TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
            LastEntity = closestEntity
          end

        else

          if LastEntity ~= nil then
            TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
            LastEntity = nil
          end

        end
    end

  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        if CurrentAction ~= nil then

          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)

          if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then

            if CurrentAction == 'mechanic_actions_menu' then
              OpenMechanicActionsMenu_mechanic(CurrentActionData)
            elseif CurrentAction == 'heli_actions2_menu' then
              OpenheliSpawnerMenu_mechanic(CurrentActionData)
            elseif CurrentAction == 'mechanic_cloark_menu' then
              OpenCloakroomMenu_mechanic()
            elseif CurrentAction == 'mechanic_stock_menu' then
              OpenStockMenu_mechanic()
            elseif CurrentAction == 'mechanic_boss_menu' then
              TriggerEvent('esx_society:openBosscarysMenu', 'mechanic', function(data, menu)
						  CurrentAction     = 'mechanic_boss_menu'
						  CurrentActionMsg  = _U('open_boss')
						  CurrentActionData = {}
					  end, { wash = false })

            elseif CurrentAction == 'delete_vehicle' then

              local model = GetEntityModel(CurrentActionData.vehicle)


					local vehicleModel = GetEntityModel(CurrentActionData.vehicle)
					local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
					local plate = GetVehicleNumberPlateText(CurrentActionData.vehicle)
					local playerIdentifier = ESX.GetPlayerData().identifier
					local playerPed = PlayerPedId()
                    local xPlayer = ESX.GetPlayerData()
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

				TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, plate, false)




            elseif CurrentAction == 'remove_entity' then
              ESX.Game.DeleteObject(CurrentActionData.entity)
            elseif CurrentAction == 'request_gascan' then
              TriggerServerEvent('esx_mechanicjob:buypetrol')
            end

            CurrentAction = nil
          end

        else
          Citizen.Wait(1)
        end

  end
end)

AddEventHandler("onKeyDown", function(key)
	if key == "f6" and (PlayerData.job and PlayerData.job.name == "mechanic") and ESX.GetPlayerData()['IsDead'] ~= 1 then
		OpenMobileMechanicActionsMenu_mechanic()
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
  isDead = false
  hasAlreadyJoined = true
end)

function IsAllowedVehicle_mechanic(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end

local vehicleclass =
{
    [0] = "Compact",
    [1] = "Sedan",
    [2] = "SUV",
    [3] = "Coupe",
    [4] = "Muscle",
    [5] = "Sport Classic",
    [6] = "Sport",
    [7] = "Super",
    [8] = "Motorcycle",
    [9] = "Off-Road",
    [10] = "Industrial",
    [11] = "Utility",
    [12] = "Vans",
    [13] = "Cycle",
    [14] = "Boat",
    [15] = "Helicopter",
    [16] = "Plane",
    [17] = "Service",
    [18] = "Emergency",
    [19] = "Military",
    [20] = "Commercial",
    [21] = "Train"
}

RegisterCommand('getclass', function(source, args)
  local ped = PlayerPedId()

  if IsPedInAnyVehicle(ped) then
    local vehicle = GetVehiclePedIsIn(ped)
    local model = GetEntityModel(vehicle)
    local display = GetDisplayNameFromVehicleModel(model)
    local class = GetVehicleClass(vehicle)

    ESX.ShowNotification("Vehicle class: ~o~" .. vehicleclass[class] .. ", ~w~Name: ~g~" .. display)
  else
    local vehicle = ESX.Game.GetVehicleInDirection(4)

    if vehicle and DoesEntityExist(vehicle) then
      local class = GetVehicleClass(vehicle)
      local model = GetEntityModel(vehicle)
      local display = GetDisplayNameFromVehicleModel(model)

      ESX.ShowNotification("Vehicle class: ~o~" .. vehicleclass[class] .. ", ~w~Name: ~g~" .. display)
    else
      ESX.ShowNotification("~h~Shoma be hich mashini negah nemikonid!")
    end

  end

end)


RegisterNetEvent('esx_mechanicjob:openreqs')
AddEventHandler('esx_mechanicjob:openreqs', function(source)
	OpenReqsList_mechanic()
end)

RegisterNetEvent('esx_mechanicjob:acceptreq')
AddEventHandler('esx_mechanicjob:acceptreq', function(loc)
	SetNewWaypoint(loc)
end)

RegisterNetEvent('esx_mechanicjob:addblip')
AddEventHandler('esx_mechanicjob:addblip', function(id, coords)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(1)
	carblip = AddBlipForCoord(coords)
	SetBlipSprite(carblip, 402)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,46)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Mechanic')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(1)
		ESX.TriggerServerCallback('esx_mechanicjob:getcoord', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip,coords)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
	end
end)

RegisterNetEvent('esx_mechanicjob:delblip')
AddEventHandler('esx_mechanicjob:delblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)

function OpenReqsList_mechanic()
	ESX.TriggerServerCallback('esx_mechanicjob:getReqs', function(reqs)

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
		local id = data.current.reqid
		ESX.TriggerServerCallback('esx_mechanicjob:acceptername', function(acceptername, accepterID)
		ESX.TriggerServerCallback('esx_mechanicjob:icname', function(name)
		table.insert(elements,{label = "RequestId : ".. data.current.reqid ,value = "nil"})

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
		table.insert(elements,{label = "Call", value = "call"})
		table.insert(elements,{label = "Khandan Payam",value = "matn"})


 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reqs_list', {

				title    = "Request",
				align    = 'bottom-right',
				elements = elements
				}, function(data2, menu2)

				menu2.close()
 				if data2.current.value == 'yes' then
					TriggerServerEvent('esx_mechanicjob:areqs', data.current.reqid)
					menu.close()
				elseif data2.current.value == 'call' then
          TriggerEvent('Unique_Phone:Cleant:CallNumberr', data.current.id)
					ESX.UI.Menu.CloseAll()
				elseif data2.current.value == 'finish' then
					TriggerServerEvent("esx_mechanicjob:creqs", data.current.reqid)
					ESX.UI.Menu.CloseAll()
				elseif data2.current.value == 'decline' then
					TriggerServerEvent("esx_mechanicjob:decline", data.current.reqid)

				elseif data2.current.value == 'matn' then
					TriggerServerEvent("esx_mechanicjob:chat", data.current.text)

				elseif data2.current.value == 'loc' then
					local Ped = GetPlayerPed(GetPlayerFromServerId(data.current.id))
					local coords = GetEntityCoords(Ped)
					SetNewWaypoint(coords)

				end
			end, function(data2, menu2)
				menu2.close()
			end)
			end)
			end, id)
 		end, function(data, menu)
			menu.close()

		end)

	end)
end

function OpendivisionsMenu_mechanic()
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
      OpendivisionsMenu_mechanic()
    end, selectedDivision)

      end, function(data, menu)

          menu.close()
      end)
  end)
end

