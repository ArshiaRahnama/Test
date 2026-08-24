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
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local LastEntity              = nil
local Blips                   = {}

local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

local inputox1                = nil
local inputox2                = nil
local inputox3                = nil
local inputox4                = nil

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

function SetVehicleMaxMods_weazel(vehicle)
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

function SetVehicleMaxMods2_weazel(vehicle)
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

function SetVehicleMaxMods3_weazel(vehicle)
	local props = {
		modEngine       = 5,
		modBrakes		= 5,
		windowTint		= 1,
		modArmor		= 5,
		modTransmission = 2,
		color1 			= 0,
		color2		 	= 0,
		pearlescentColor = 0,
		modSuspension   = 4,
		modTurbo        = true,
	}


	ESX.Game.SetVehicleProperties(vehicle, props)
	SetVehicleDirtLevel(vehicle, 0.0)
end

RegisterNetEvent("esx_weazel:notify")
AddEventHandler("esx_weazel:notify",function(message)

  if IsJobTrue_weazel() and PlayerData.job.grade >= 1 then
    TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[Weazel News]", message}})
  end

end)

Citizen.CreateThread(function()

    local blipMarker = Config_weazel.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weazel News")
    EndTextCommandSetBlipName(blipCoord)

end)

function IsJobTrue_weazel()
    if PlayerData ~= nil then
        local IsJobTrue_weazel = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then
            IsJobTrue_weazel = true
        end
        return IsJobTrue_weazel
    end
end

function IsGradeBoss_weazel()
    if PlayerData ~= nil then
        local IsGradeBoss_weazel = false
        if PlayerData.job.grade_name == 'boss' then
            IsGradeBoss_weazel = true
        end
        return IsGradeBoss_weazel
    end
end

function cleanPlayer_weazel(playerPed)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function setClipset_weazel(playerPed, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(1)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function setUniform_weazel(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)
	local job =  PlayerData.job.name
	local grade =  PlayerData.job.grade
	ESX.TriggerServerCallback('esx_society:getUniforms', function(SkinMale, SkinFemale)
    if skin.sex == 0 then
        TriggerEvent('skinchanger:loadClothes', skin, SkinMale)
    else
        TriggerEvent('skinchanger:loadClothes', skin, SkinFemale)
    end
	end, grade, job)
  end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function OpenCloakroomMenu_weazel()
  ESX.TriggerServerCallback('esx_society:divisionsPlayer', function(check)
    local playerPed = GetPlayerPed(-1)

    local elements = {
      { label = "Lebas Shakhsi",     value = 'citizen_wear'},
    }

    table.insert(elements, {label = "Lebas Kar", value = PlayerData.job.grade_name ..  "_outfit"})

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

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cloakroom',
      {
        title    = "Komod Lebas",
        align    = 'top-left',
        elements = elements,
      },
        function(data, menu)

          isBarman = false
          cleanPlayer_weazel(playerPed)

          if data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
              TriggerEvent('skinchanger:loadSkin', skin)

            end)

          end

          if data.current.value ==  PlayerData.job.grade_name ..  "_outfit" then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
              TriggerEvent('skinchanger:loadSkin', skin)
              setUniform_weazel(data.current.value, playerPed)
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

          CurrentAction     = 'menu_cloakroom'
          CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
          CurrentActionData = {}

        end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
        CurrentActionData = {}
      end
    )
  end)
end

function OpenVehicleSpawnerMenu_weazel(station, partNum)
  local vehicles = Config_weazel.Zones.Vehicles
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
          local Vehicles = Config_weazel.AuthorizedVehicles.Shared
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
          local Vehicles2 = Config_weazel.AuthorizedVehicles.Shared
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
          title    = 'vehicle',
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
                        end, "WZ" .. plate[1])
                        menu.close()

                        Wait(1000)
                        spawnvehicles_weazel(data, plate, vehicle)

                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Cancel Shod'}
                        })

                      end
                    else
                      if #plate[1] == 6 then
                        menu.close()

                        spawnvehicles_weazel(data, plate, vehicle)
                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Plake Mashin Bayad 6 Character Bashad'}
                        })
                        requestPlate()
                      end
                    end
                  end, "WZ" .. plate[1])
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

function spawnvehicles_weazel(data, plate, vehicle)
	plate[1] = string.upper(plate[1])

	ESX.Game.SpawnVehicleJobs(data.current.model, Config_weazel.Zones.Vehicles.SpawnPoint, Config_weazel.Zones.Vehicles.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'weazel', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_weazel(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_weazel(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_weazel(vehicle, 1)
				SetVehicleLivery(vehicle, 5)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_weazel(vehicle, 1)
				SetVehicleLivery(vehicle, 5)
			else
				SetVehicleMaxMods_weazel(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_weazel.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 5)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 5)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(2000)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_weazel(vehicle)
			SetVehicleNumberPlateText(vehicle, "WZ" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

         TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "WZ" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Mashin Ba Plake^2 WZ'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Mashin Na Movafaq'}
			})

		end
	end)

end

function OpenHelicopterMenu_weazel()

  local vehicles = Config_weazel.AuthorizedVehicles.Sharedheli
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
          local Vehicles = Config_weazel.AuthorizedVehicles.Sharedheli
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
          local Vehicles2 = Config_weazel.AuthorizedVehicles.Sharedheli
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
                        end, "WZ" .. plate[1])
                        menu.close()

                        Wait(1000)
                        spawnheliss_weazel(data, plate, vehicle)

                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Cancel Shod'}
                        })

                      end
                    else
                      if #plate[1] == 6 then
                        menu.close()

                        spawnheliss_weazel(data, plate, vehicle)
                      else
                        TriggerEvent('chat:addMessage', {
                          args = {'^1SYSTEM', 'Plake Heli Bayad 6 Character Bashad'}
                        })
                        requestPlate()
                      end
                    end
                  end, "WZ" .. plate[1])
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

function spawnheliss_weazel(data, plate, vehicle)
	plate[1] = string.upper(plate[1])

	ESX.Game.SpawnVehicleJobs(data.current.model, Config_weazel.Zones.Helicopters.SpawnPoint, Config_weazel.Zones.Helicopters.Heading, function(vehicle)
		if vehicle then
			TriggerServerEvent('esx_society:logAction', 'weazel', 'Vehicle Spawned', {
				{["name"] = "Player", ["value"] = ESX.PlayerData.name or GetPlayerName(PlayerId()), ["inline"] = false},
				{["name"] = "Vehicle", ["value"] = data.current.model, ["inline"] = false},
			})

			local playerPed = PlayerPedId()
			if data.current.model == "insurgent2" or data.current.model == "riot2" or data.current.model == "riot" or data.current.model == "fbi2" or data.current.model == "fbi" then
				SetVehicleMaxMods2_weazel(vehicle)
			elseif data.current.model == "polschafter3" then
				SetVehicleMaxMods_weazel(vehicle, 1)
			elseif data.current.model == "polchar" or data.current.model == "poltah" or data.current.model == "poltaurus" or data.current.model == "polvic" then
				SetVehicleMaxMods_weazel(vehicle, 1)
				SetVehicleLivery(vehicle, 5)
			elseif data.current.model == "polraptor" then
				SetVehicleMaxMods_weazel(vehicle, 1)
				SetVehicleLivery(vehicle, 5)
			else
				SetVehicleMaxMods_weazel(vehicle, callsign, -1)
			end

			local Vehicles2 = Config_weazel.AuthorizedVehicles.Shared
			for _, vehicle2 in ipairs(Vehicles2) do
				if vehicle2.Extra and vehicle2.model == data.current.model then
					for extraName, extraValue in pairs(vehicle2.Extra) do
						SetVehicleExtra(vehicle, tonumber(extraName), tonumber(extraValue))
					end
				end
			end



			SetVehicleLivery(vehicle, 5)
			Citizen.Wait(500)
			SetVehicleLivery(vehicle, 5)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			Citizen.Wait(2000)
			SetVehicleFuelLevel(vehicle, 100.0)
			SetVehicleMaxMods_weazel(vehicle)
			SetVehicleNumberPlateText(vehicle, "WZ" ..plate[1] )

			local playerIdentifier = ESX.GetPlayerData().identifier
			local vehicleModel = GetEntityModel(vehicle)
			local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel))
			local playerPed = PlayerPedId()
			local xPlayer = ESX.GetPlayerData()

            TriggerServerEvent('logVehicleSpawn', xPlayer.name, GetPlayerServerId(PlayerId()), playerIdentifier, vehicleLabel, "WZ" .. plate[1], true)



			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Heli Ba Plake^2 WZ'..plate[1]..' ^0Spawn Shod'}
			})
		else
			TriggerEvent('chat:addMessage', {
				args = {'^1SYSTEM', 'Spawn Heli Na Movafaq'}
			})

		end
	end)

end

AddEventHandler('esx_weazel:hasEnteredMarker', function(zone)

    if zone == 'BossActions' and IsGradeBoss_weazel() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid jahat modiriat shoghl"
      CurrentActionData = {}
    elseif zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid komod baz she"
      CurrentActionData = {}
    elseif zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
        CurrentActionData = {}
    elseif zone == 'VehicleDeleters' or zone == 'VehicleDeleters2' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro bezanid ta vasile naghlie park she"
        CurrentActionData = {vehicle = vehicle}
      end

    elseif zone == "Helicopters" then
      CurrentAction     = 'spawn_helicopter'
      CurrentActionMsg  = "Dokme ~INPUT_CONTEXT~ ro feshar bedid ta garage baz she"
      CurrentActionData = {}
    end

end)

AddEventHandler('esx_weazel:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

Citizen.CreateThread(function()
    while true do

        Wait(1)
        if IsJobTrue_weazel() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config_weazel.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config_weazel.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, true, true, 2, true, false, false, false)
                end
            end

        end

    end
end)

Citizen.CreateThread(function()
    while true do

        Wait(1)
        if IsJobTrue_weazel() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config_weazel.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_weazel:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_weazel:hasExitedMarker', LastZone)
            end

        end

    end
end)

Citizen.CreateThread(function()
  while true do

    Citizen.Wait(1)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue_weazel() then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu_weazel()
        elseif CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu_weazel()
        elseif CurrentAction == 'spawn_helicopter' then
          OpenHelicopterMenu_weazel()
        elseif CurrentAction == 'delete_vehicle' then

            ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

        elseif CurrentAction == 'remove_entity' then
					ESX.Game.DeleteObject(CurrentActionData.entity)
        elseif CurrentAction == 'menu_boss_actions' and IsGradeBoss_weazel() then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('esx_society:openBosscarysMenu', 'weazel', function(data, menu)
            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}
          end, {wash = false})
        end

        CurrentAction = nil

      end

    end

    if IsControlJustReleased(0, Keys['F6']) and IsJobTrue_weazel() then
       ObjectSpawner_weazel()
    end

  end
end)

AddEventHandler('esx_weazel:hasEnteredEntityZone', function(entity)

    local playerPed = PlayerPedId()

    if IsJobTrue_weazel() and not IsPedInAnyVehicle(playerPed, false) then
      CurrentAction     = 'remove_entity'
      CurrentActionMsg  = 'press ~INPUT_CONTEXT~ to delete the object'
      CurrentActionData = {entity = entity}
    end

end)

  AddEventHandler('esx_weazel:hasExitedEntityZone', function(entity)

    if CurrentAction == 'remove_entity' then
      CurrentAction = nil
    end

  end)


Citizen.CreateThread(function()

    local trackedEntities = {
      'prop_studio_light_01',
      'prop_studio_light_02',
      'prop_studio_light_03',
      'prop_scrim_02',
      'prop_tv_cam_02',
      'prop_kino_light_03',
      'prop_tv_stand_01',
      'prop_generator_01a',
      'prop_dolly_01',
      'prop_dolly_02',
      'xm_prop_base_tripod_lampb'
    }

    while true do

      Citizen.Wait(1000)

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
        TriggerEvent('esx_weazel:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

      else

      if LastEntity ~= nil then
        TriggerEvent('esx_weazel:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

      end

    end
end)

function ObjectSpawner_weazel()
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
			{label = 'object spawner',	value = 'object_spawner2'},
			{label = 'Tabligh Menu',	value = 'tabligh_menu'},

		}

		if isdivision then
			table.insert(elements, {label = 'Extera Division', value = 'extra_division'})
		end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'object_spawner',
      {
        title    = "Weazel Action Menu",
        align    = 'left',
        elements = elements
      }, function(data2, menu2)

        if data2.current.value == 'object_spawner2' then
          ObjectSpawnerWeazel_weazel()
        end

        if data2.current.value == 'extra_division' then
          OpendivisionsMenu_weazel()
        end

        if data2.current.value == 'tabligh_menu' then
          OpenTablighMenu_weazel()
        end

      end, function(data2, menu2)
        menu2.close()
    end)
  end)
end

function OpendivisionsMenu_weazel()
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
      OpendivisionsMenu_weazel()
    end, selectedDivision)

      end, function(data, menu)

          menu.close()
      end)
  end)
end

function ObjectSpawnerWeazel_weazel()
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'object_spawner',
    {
      title    = "Vasayel film bardari",
      align    = 'top-left',
      elements = {
        {label = "Light 1",		value = 'prop_studio_light_01'},
        {label = "Light 2",		value = 'prop_studio_light_02'},
        {label = "Light 3",		value = 'prop_studio_light_03'},
        {label = "Light spliter", value = 'prop_kino_light_03'},
        {label = "Light stand", value = 'xm_prop_base_tripod_lampb'},
        {label = "Crane Stand 1", value = 'prop_dolly_01'},
        {label = "Crane Stand 2", value = 'prop_dolly_02'},
        {label = "Genrator", value = 'prop_generator_01a'},
        {label = "Board",		value = 'prop_scrim_02'},
        {label = "Camera Stand",		value = 'prop_tv_cam_02'},
        {label = "TV Stand",	value = 'prop_tv_stand_01'}
      }
    }, function(data2, menu2)
      local model     = data2.current.value
      local playerPed = PlayerPedId()
      local coords    = GetEntityCoords(playerPed)
      local forward   = GetEntityForwardVector(playerPed)
      local x, y, z   = table.unpack(coords + forward * 1.0)

      ESX.Game.SpawnObject(model, {
        x = x,
        y = y,
        z = z
      }, function(obj)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
      end)

	end, function(data2, menu2)
		menu2.close()
    ObjectSpawner_weazel()
	end)
end

function IsAllowedVehicle_weazel(table, val)
	for i = 1, #table do
		if table[i] == val then
			return true
		end
	end
	return false
end

function OpenTablighMenu_weazel()
  ESX.UI.Menu.CloseAll()
  local elements = {}

  elements = {
    {label = "Send Tabligh",		value = 'send_tabligh'},
    {label = "Setting Tabligh",		value = 'setting_tabligh'},
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Open_Tabligh_Menu',
    {
      title    = "Manage Tabligh",
      align    = 'left',
      elements = elements
    }, function(data2, menu2)
      local model = data2.current.value
      if model == 'send_tabligh' then
        OpenSendTabligh_weazel()
      elseif model == 'setting_tabligh' then

        OpenTabligh_weazel()

      end
    end, function(data2, menu2)
      menu2.close()
      ObjectSpawner_weazel()
	end)
end

function OpenSendTabligh_weazel()

  ESX.UI.Menu.CloseAll()
  local elements = {}

  elements = {
    {label = "Tabligh",		value = 'tabligh'},
    {label = "Tabligh Timer",		value = 'Tabligh_Timer'},
  }

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Open_Tabligh_Menu',
    {
      title    = "Manage Tabligh",
      align    = 'left',
      elements = elements
    }, function(data2, menu2)
      local model = data2.current.value
      if model == 'tabligh' then
        ::relog::
        inputox1 = lib.inputDialog('Send Tabligh', {'Matn Tabligh'})
        if inputox1[1] ~= "" then
          print(inputox1[1])
          ExecuteCommand("news "..inputox1[1])
        else
          inputox1 = nil
          goto relog
        end
      elseif model == 'Tabligh_Timer' then
        ::relog2::
        inputox2 = lib.inputDialog('Send Tabligh', {'Matn Tabligh', 'Time (Daghige)', 'Tedad Tekrar'})
        if inputox2[1] ~= "" and inputox2[2] ~= "" and inputox2[3] ~= "" and tonumber(inputox2[2]) and tonumber(inputox2[3]) then
          ExecuteCommand('newstime '..inputox2[3].." "..inputox2[2].." "..inputox2[1])
        else
          inputox2 = nil
          goto relog2
        end
      end
    end, function(data2, menu2)
      menu2.close()
      OpenTablighMenu_weazel()
	end)
end

function OpenTabligh_weazel()
  local elements = {}
  ESX.TriggerServerCallback('esx_weazeljob:GetIdTabligh', function(data)
    if data then
      for k,v in pairs(data) do
        table.insert(elements, {
          label = "["..v.idt.."] | "..v.name,
          id    = v.idt,
          name  = v.name,
          msg   = v.message
        })
      end

      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Tabligh_Menu',
        {
          title    = "Tabligh Menu",
          align    = 'left',
          elements = elements
        }, function(data, menu)
          local model = data.current
          MenuOX_weazel(model.id, model.msg, model.name)

          lib.showMenu('quest_menu')


        end, function(data, menu)
          menu.close()
          OpenTablighMenu_weazel()
      end)

    else
      TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[Weazel News]", "Tablighi Vojod Nadarad!!!"}})
    end
  end)
end

local inputox = nil
function MenuOX_weazel(id, msg, name)

  lib.registerMenu({
    id = 'quest_menu',
    title = 'Quest Invitation',
    position = 'top-right',
    options = {
        {label = '✅ Accept', value = 'accept'},
        {label = '❌ Decline', value = 'decline'},
        {label = 'ℹ️ View Info', value = 'view_info'}
    }
  }, function(selected, scrollIndex, args)
    if selected == 1 then
      ExecuteCommand("ad "..id.." accept")
      Citizen.Wait(100)
      lib.hideMenu()
      OpenTabligh_weazel()
    elseif selected == 2 then
      ::relog::
      inputox = lib.inputDialog('Cancel Tabligh', {'Dalil'})
      if inputox[1] ~= "" then
        ExecuteCommand("ad "..id.." decline "..inputox[1])
        Citizen.Wait(100)
        lib.hideMenu()
        OpenTabligh_weazel()
      else
        inputox = nil
        goto relog
      end
    elseif selected == 3 then
      TriggerEvent('chat:addMessage', {color = {255, 0, 0}, multiline = true ,args = {"[Weazel News]", "^2"..name.." ("..id..") :^0 "..msg}})
      Citizen.Wait(100)
      lib.hideMenu()
      OpenTabligh_weazel()
    end
  end)

  ESX.UI.Menu.CloseAll()
  Wait(100)

end

