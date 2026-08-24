

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
local FrontHandCuffed 		  = false
local hasAlreadyJoined        = false
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false
local Busy = false
local BackupX = nil
local BackupY = nil
local showit = false
local ASTimer = 0
local callsign = nil
local Draging 				  = false
local dragiss                 = false

local set                       = false
local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsHandcuffed              = false
local IsDragged                 = false
local CopPed                    = 0
local allBlip                   = {}
local Data                      = {}
local blipGangs                 = {}
local blipsGangs                = {}
local dragiss                 = false

local DragStatus              = {}
DragStatus.IsDragged          = false

ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().gang == nil do
		Citizen.Wait(10)
	end
end)

AddEventHandler('police:gargbygang', function(drrragss)
  dragiss = drrragss
end)

AddEventHandler('esx:onPlayerDeath', function()
    IsDragged = false
    TriggerEvent('gangprop:removeHandcuffFull')
end)

AddEventHandler('playerSpawned', function()
    IsDragged = false
    TriggerEvent('gangprop:removeHandcuffFull')
end)

function OpenCloakroomMenu()

  local elements = {
    {label = _U('citizen_wear'), value = 'citizen_wear'},
    {label = 'Lebas Gang', value = 'gang_wear'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)
      menu.close()

      ESX.TriggerServerCallback('esx_skin:getGangSkin', function(skin, gangSkin)
        if data.current.value == 'citizen_wear' then
            TriggerEvent('skinchanger:loadSkin', skin)
            TriggerEvent('esx:restoreLoadout')
        elseif data.current.value == 'gang_wear' then
          if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, gangSkin.skin_male)
          else
            TriggerEvent('skinchanger:loadClothes', skin, gangSkin.skin_female)
          end
        end
      end)
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
)

end

function OpenArmoryMenu(station)
  local station = station

   local elements = {
    {label = 'Inventory Gang', value = 'property_inventory'},
    {label = 'Armor | Price: $' ..Data.price ,  value = 'get_armor'},
    {label = 'Armor Makhfi | Price: $' ..Data.price + 2000 ,  value = 'get_armor_Makhfi'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'armory',
  {
    title    = _U('armory'),
    align    = 'top-left',
    elements = elements,
  },
  function(data, menu)

  if data.current.value == "property_inventory" then
	if PlayerData.gang.grade >= 1 then
      menu.close()
      OpenGangInventoryMenu(station)
    else
      ESX.ShowNotification("~h~Shoma Ejaze Dastresi Be Armory Nadarid")
    end
  elseif data.current.value == 'get_armor_Makhfi' then

    if PlayerData.gang.grade >= Data.vest_access then
      local ped = GetPlayerPed(-1)
      local armor = GetPedArmour(ped)

      if armor >= Data.bulletproof then
        ESX.ShowNotification("~g~Armor shoma por ast nemitavanid dobare armor kharidari konid!")
      else
        TriggerServerEvent("gangprop:setArmorMakhfi", source)
      end
    else
        ESX.ShowNotification("~h~Shoma Ejaze Gereftan Armor Nadarid")

    end

  elseif data.current.value == 'get_armor' then
	if PlayerData.gang.grade >= Data.vest_access then
		local ped = GetPlayerPed(-1)
		local armor = GetPedArmour(ped)

		if armor >= Data.bulletproof then
		  ESX.ShowNotification("~g~Armor shoma por ast nemitavanid dobare armor kharidari konid!")
		else
		  TriggerServerEvent("gangprop:setArmor", source)
		end
	else
      ESX.ShowNotification("~h~Shoma Ejaze Gereftan Armor Nadarid")
    end
  end

  end,
  function(data, menu)

    menu.close()

    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = _U('open_armory')
    CurrentActionData = {station = station}
  end)

end

function OpenGangInventoryMenu(station)
  local playerdata = ESX.GetPlayerData()
  local gname      = playerdata.gang.name

  exports.ox_inventory:openInventory('stash', 'gang_' .. string.lower(gname))

end

carry = {
	Requested = false,
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

function ListOwnedCarsMenu()
	local elements = {}

	table.insert(elements, {label = '| Pelak | Esm Mashin |'})
  local grank = PlayerData.gang.grade
  local gname = PlayerData.gang.name
	ESX.TriggerServerCallback('gangprop:getCars', function(ownedCars)
    ESX.TriggerServerCallback('gangs:GetPermData', function(vycars)
      if #ownedCars == 0 then
        ESX.ShowNotification(_U('garage_nocars'))
      else
        for _,v in pairs(ownedCars) do
          if not vycars then
            return
          end

          local mmodel = v.vehicle.model
          local classnumber = GetVehicleClassFromName(mmodel)
          if classnumber ~= 14 and classnumber ~= 15 and classnumber ~= 16 then
            for _,v2 in ipairs(vycars) do
              local hashVehicule = v.vehicle.model
              local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
              local vehLabel     = GetLabelText(aheadVehName)
              plate3        = v.plate
              if v2.name == aheadVehName and v2.state == true and v2.plate == plate3 then
                local vehicleName  = aheadVehName
                local plate2        = v.plate
                labelvehicle = '| '..plate2..' | '..vehLabel..' |'
                table.insert(elements, {label = labelvehicle, value = v})
              end
            end
          end

        end
      end

        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
          title    = 'Gang Parking',
          align    = 'top-left',
          elements = elements
        }, function(data, menu)
          if data.current.value then
            menu.close()
            Citizen.Wait(math.random(10,3000))
            Citizen.Wait(math.random(25,500))
            ESX.TriggerServerCallback('gangprop:carAvalible', function(avalibele)
              if avalibele then
                if data.current.value.stored then
                  TriggerServerEvent('esx_advancedgarage:setVehicleState', data.current.value.plate, false)
                  DeleteVehicle(localVeh)
                  localVeh = nil
                  ClearFocus()
                  RenderScriptCams(false, false, 0, true, false)
                  DestroyCam(camera, false)
                  SpawnVehicle(data.current.value.vehicle, data.current.value.plate, data.current.value.damage, data.current.value.engine)
                else
                  ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
                end
              else
                ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
              end
            end, data.current.value.plate)
          else
            ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
          end
        end, function(data, menu)
          menu.close()
        end, function(data, menu)




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if data.current.value then

            local shokol = GetClosestVehicle(Data.vehspawn.x,  Data.vehspawn.y,  Data.vehspawn.z,  3.0,  0,  71)
            if not DoesEntityExist(shokol) then
              SetCamCoord(camera, Data.vehspawn.x + 3.0, Data.vehspawn.y + 5.0, Data.vehspawn.z+ 4.0)
              SetCamActive(camera, true)
              PointCamAtCoord(camera, Data.vehspawn.x, Data.vehspawn.y, Data.vehspawn.z)
              RenderScriptCams(true, true, 1000, true, false)

                ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
                local vehicle = data.current.value.vehicle
                  if not localVeh then
                    ESX.Game.SpawnLocalVehicle(vehicle.model, Data.vehspawn, Data.vehspawn.a, function(callback_vehicle)
                      ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)

                      if data.current.value.damage ~= "" then
                        setDamages(callback_vehicle, data.current.value.damage)
                      end
                      if localVeh then
                        DeleteVehicle(callback_vehicle)
                      else
                        localVeh = callback_vehicle
                        vehicle.plate = data.current.value.plate

                        SetVehRadioStation(callback_vehicle, "OFF")

                        Citizen.CreateThread(function()
                          while DoesEntityExist(callback_vehicle) and localVeh == callback_vehicle and DoesCamExist(camera) do
                            Citizen.Wait(0)
                            local vehhh = json.decode(data.current.value.damage)
                            local enginheltss = 0
                            local bodyhelss = 0
                            local fuelhealthss = 0
                            local dataaa = {}

                            if vehhh then
                                for kk, vv in pairs(vehhh) do
                                    dataaa[kk] = vv

                                    if kk == "engine_health" then
                                        enginheltss = tostring(math.floor(vv))
                                    elseif kk == "body_health" then
                                        bodyhelss = tostring(math.floor(vv))
                                    elseif kk == "fuel_health" then
                                      fuelhealthss = tostring(math.floor(vv))
                                    end
                                end
                            end

                            local enginheltss = tonumber(enginheltss) or 0

                            local fuelhealthss = tonumber(fuelhealthss) or 0

                            enginheltss = enginheltss / 10

                            fuelhealthss = fuelhealthss
                            local Engini = ""
                            if data.current.value.engine then
                              Engini = "Engine: ~g~Darad"
                            else
                              Engini = "Engine: ~r~Nadarad"
                            end

                            local vehpos = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 0.0, 2.0)
                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5), 'Benzin : '.. ESX.Math.Round(fuelhealthss) .. '%', 1.5)

                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75), 'Salamate Motor : ' .. math.floor(enginheltss) .. '%', 1.5)
                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1.0), Engini, 1.5)
                            if not data.current.value.stored then
                              ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1.25), '~r~Impound', 1.5)
                            end

                          end
                          DeleteVehicle(localVeh)
                        end)
                      end
                    end)
                  end
                end, data.current.value.plate)

            else
              ESX.ShowNotification('Mahale Spawm Mashin Por Ast!!')
            end
          end
        end, function()




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if camera then
            ClearFocus()
            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(camera, false)
            camera = nil
          end
        end)
    end, gname, grank, 'car', plate)
	end)
end

function SpawnVehicle(vehicle, plate, damages, Engini)
  local shokol = GetClosestVehicle(Data.vehspawn.x,  Data.vehspawn.y,  Data.vehspawn.z,  3.0,  0,  71)
  if not DoesEntityExist(shokol) then


    ESX.Game.SpawnVehicle(vehicle.model, {
      x = Data.vehspawn.x,
      y = Data.vehspawn.y,
      z = Data.vehspawn.z + 1
    }, Data.vehspawn.a, function(callback_vehicle)
      ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
      SetVehRadioStation(callback_vehicle, "OFF")
      TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
      setDamages(callback_vehicle, damages)

      Wait(50)

      local engineHealth = GetVehicleEngineHealth(callback_vehicle)
      local healthPercent = math.floor((engineHealth / 1000) * 100)
      vehicleLabel = GetDisplayNameFromVehicleModel(vehicle.model)
      vehnname = GetLabelText(vehicleLabel)

      TriggerServerEvent('gangs:vehlogs', vehnname, vehicle.plate, 'veh', 'spawn', healthPercent, Engini)
    end)



  else
    ESX.ShowNotification('Mahale Spawn mashin ro Khali konid')
  end
end

function SpawnHeli(vehicle, plate)
  local shokol2 = GetClosestVehicle(Data.helispawn.x, Data.helispawn.y, Data.helispawn.z, 3.0, 0, 71)
  if not DoesEntityExist(shokol2) then
    ESX.Game.SpawnVehicle(vehicle.model, {
      x = Data.helispawn.x,
      y = Data.helispawn.y,
      z = Data.helispawn.z + 1
    }, Data.helispawn.a, function(callback_vehicle)
      ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
      SetVehRadioStation(callback_vehicle, "OFF")
      TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
      Wait(50)

      local engineHealth = GetVehicleEngineHealth(callback_vehicle)
      local healthPercent = math.floor((engineHealth / 1000) * 100)

      vehicleLabel = GetDisplayNameFromVehicleModel(vehicle.model)
      vehnname = GetLabelText(vehicleLabel)

      TriggerServerEvent('gangs:vehlogs', vehnname, vehicle.plate, 'heli', 'spawn', healthPercent)
    end)

    TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
  else
    ESX.ShowNotification('~h~~y~Mahale Spawn Heli Ro Khali konid')
  end
end

function ListOwnedAircraftsMenu()
	local elements = {}

	table.insert(elements, {label = '| Pelak | Esm Heli |'})
  local grank = PlayerData.gang.grade
  local gname = PlayerData.gang.name
	ESX.TriggerServerCallback('gangprop:getCars', function(ownedCars)
    ESX.TriggerServerCallback('gangs:GetPermData', function(vycars)
      if #ownedCars == 0 then
        ESX.ShowNotification(_U('garage_nocars'))
      else
        for _,v in pairs(ownedCars) do
          if not vycars then
            return
          end
          local mmodel = v.vehicle.model
          local plate = v.vehicle.plate
          local classnumber = GetVehicleClassFromName(mmodel)
          if classnumber ~= 14 and classnumber == 15 and classnumber ~= 16 then
            for _,v2 in ipairs(vycars) do
              local hashVehicule = v.vehicle.model
              local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
              local vehLabel     =GetLabelText(aheadVehName)
              plate3        = v.plate
              if v2.name == aheadVehName and v2.state == true and v2.plate == plate3 then
                local vehicleName  = aheadVehName
                local plate        = v.plate
                labelvehicle = '| '..plate..' | '..vehLabel..' |'
                table.insert(elements, {label = labelvehicle, value = v})
              end
            end
          end

        end
      end

        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_Heli', {
          title    = 'Heli List',
          align    = 'top-left',
          elements = elements
        }, function(data, menu)
          if data.current.value then
            menu.close()
            Citizen.Wait(math.random(0,1000))
            ESX.TriggerServerCallback('gangprop:carAvalible', function(avalibele)
              if avalibele then
                if data.current.value.stored then
                  DeleteVehicle(localVeh)
                  localVeh = nil
                  ClearFocus()
                  RenderScriptCams(false, false, 0, true, false)
                  DestroyCam(camera, false)
                  SpawnHeli(data.current.value.vehicle, data.current.value.plate, data.current.value.damage)
                else
                  ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
                end
              else
                ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
              end
            end, data.current.value.plate)
          else
            ESX.ShowNotification('~r~In Mashin Dar Impound Ast!')
          end
        end, function(data, menu)
          menu.close()
        end, function(data, menu)




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if data.current.value then

            local shokol = GetClosestVehicle(Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z,  3.0,  0,  71)
            if not DoesEntityExist(shokol) then
              SetCamCoord(camera, Data.helispawn.x + 3.0, Data.helispawn.y + 5.0, Data.helispawn.z+ 4.0)
              SetCamActive(camera, true)
              PointCamAtCoord(camera, Data.helispawn.x, Data.helispawn.y, Data.helispawn.z)
              RenderScriptCams(true, true, 1000, true, false)


                ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
                local vehicle = data.current.value.vehicle
                  if not localVeh then
                    ESX.Game.SpawnLocalVehicle(vehicle.model, Data.helispawn, Data.helispawn.a, function(callback_vehicle)

                      if localVeh then
                        DeleteVehicle(callback_vehicle)
                      else
                        localVeh = callback_vehicle
                        vehicle.plate = data.current.value.plate

                        SetVehRadioStation(callback_vehicle, "OFF")

                        Citizen.CreateThread(function()
                          while DoesEntityExist(callback_vehicle) and localVeh == callback_vehicle and DoesCamExist(camera) do
                            Citizen.Wait(0)
                            local vehhh = json.decode(data.current.value.damage)
                            local enginheltss = 0
                            local bodyhelss = 0
                            local fuelhealthss = 0
                            local dataaa = {}

                            if vehhh then
                                for kk, vv in pairs(vehhh) do
                                    dataaa[kk] = vv

                                    if kk == "engine_health" then
                                        enginheltss = tostring(math.floor(vv))
                                    elseif kk == "body_health" then
                                        bodyhelss = tostring(math.floor(vv))
                                    elseif kk == "fuel_health" then
                                      fuelhealthss = tostring(math.floor(vv))
                                    end
                                end
                            end

                            local enginheltss = tonumber(enginheltss) or 0

                            local fuelhealthss = tonumber(fuelhealthss) or 0


                            enginheltss = enginheltss / 10

                            fuelhealthss = fuelhealthss

                            local vehpos = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 0.0, 2.0)
                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5), 'Benzin : '.. ESX.Math.Round(fuelhealthss) .. '%', 1.5)

                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75), 'Salamate Motor : ' .. math.floor(enginheltss) .. '%', 1.5)
                            if not data.current.value.stored then
                              ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1.0), '~r~Impound', 1.5)
                            end

                          end
                          DeleteVehicle(localVeh)
                        end)
                      end
                    end)
                  end
                end, data.current.value.plate)

            else
              ESX.ShowNotification('Mahale Spawm Mashin Por Ast!!')
            end
          end
        end, function()




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if camera then
            ClearFocus()
            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(camera, false)
            camera = nil
          end
        end)
    end, gname, grank, 'heli',plate)
	end)
end

function SpawnBoat(vehicle, plate)
  local shokol2 = GetClosestVehicle(Data.boatspawn.x, Data.boatspawn.y, Data.boatspawn.z, 3.0, 0, 71)

  if not DoesEntityExist(shokol2) then
    ESX.Game.SpawnVehicle(vehicle.model, {
      x = Data.boatspawn.x,
      y = Data.boatspawn.y,
      z = Data.boatspawn.z + 1
    }, Data.boatspawn.a, function(callback_vehicle)
      ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
      SetVehRadioStation(callback_vehicle, "OFF")
      TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
      Wait(50)

      local vehicleLabel = GetDisplayNameFromVehicleModel(vehicle.model)
      local vehnname = GetLabelText(vehicleLabel)
      local engineHealth = GetVehicleEngineHealth(callback_vehicle)
      local healthPercent = math.floor((engineHealth / 1000) * 100)

      TriggerServerEvent('gangs:vehlogs', vehnname, vehicle.plate, 'boat', 'spawn', healthPercent)
    end)

    TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
  else
    ESX.ShowNotification('~h~~y~Mahale Spawn Boat Ro Khali konid')
  end
end

function ListOwnedBoatsMenu()

  local elements = {}

  table.insert(elements, {label = '| Pelak | Esm Boat |'})
  local grank = PlayerData.gang.grade
  local gname = PlayerData.gang.name
  ESX.TriggerServerCallback('gangprop:getCars', function(ownedCars)
    ESX.TriggerServerCallback('gangs:GetPermData', function(vycars)
      if #ownedCars == 0 then
        ESX.ShowNotification(_U('garage_nocars'))
      else
        for _,v in pairs(ownedCars) do
          if not vycars then
            return
          end
          local mmodel = v.vehicle.model
          local plate = v.vehicle.plate
          local classnumber = GetVehicleClassFromName(mmodel)
          if classnumber == 14 then
            for _,v2 in ipairs(vycars) do
              local hashVehicule = v.vehicle.model
              local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
              local vehLabel     =GetLabelText(aheadVehName)
              plate3        = v.plate
              if v2.name == aheadVehName and v2.state == true and v2.plate == plate3 then
                local vehicleName  = aheadVehName
                local plate        = v.plate
                labelvehicle = '| '..plate..' | '..vehLabel..' |'
                table.insert(elements, {label = labelvehicle, value = v})
              end
            end
          end

        end
      end

        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_Boat', {
          title    = 'Boat List',
          align    = 'top-left',
          elements = elements
        }, function(data, menu)
          if data.current.value then
            menu.close()
            Citizen.Wait(math.random(0,1000))
            ESX.TriggerServerCallback('gangprop:carAvalible', function(avalibele)
              if avalibele then
                if data.current.value.stored then
                  DeleteVehicle(localVeh)
                  localVeh = nil
                  ClearFocus()
                  RenderScriptCams(false, false, 0, true, false)
                  DestroyCam(camera, false)
                  SpawnBoat(data.current.value.vehicle, data.current.value.plate, data.current.value.damage)
                else
                  ESX.ShowNotification('~r~In boat Dar Impound Ast!')
                end
              else
                ESX.ShowNotification('~r~In boat Dar Impound Ast!')
              end
            end, data.current.value.plate)
          else
            ESX.ShowNotification('~r~In boat Dar Impound Ast!')
          end
        end, function(data, menu)
          menu.close()
        end, function(data, menu)




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if data.current.value then

            local shokol = GetClosestVehicle(Data.boatspawn.x,  Data.boatspawn.y,  Data.boatspawn.z,  3.0,  0,  71)
            if not DoesEntityExist(shokol) then
              SetCamCoord(camera, Data.boatspawn.x + 3.0, Data.boatspawn.y + 5.0, Data.boatspawn.z+ 4.0)
              SetCamActive(camera, true)
              PointCamAtCoord(camera, Data.boatspawn.x, Data.boatspawn.y, Data.boatspawn.z)
              RenderScriptCams(true, true, 1000, true, false)


                ESX.TriggerServerCallback('esx_advancedgarage:GetVehiclePropsFromPlate', function(vehicle)
                local vehicle = data.current.value.vehicle
                  if not localVeh then
                    ESX.Game.SpawnLocalVehicle(vehicle.model, Data.boatspawn, Data.boatspawn.a, function(callback_vehicle)

                      if localVeh then
                        DeleteVehicle(callback_vehicle)
                      else
                        localVeh = callback_vehicle
                        vehicle.plate = data.current.value.plate

                        SetVehRadioStation(callback_vehicle, "OFF")

                        Citizen.CreateThread(function()
                          while DoesEntityExist(callback_vehicle) and localVeh == callback_vehicle and DoesCamExist(camera) do
                            Citizen.Wait(0)
                            local vehhh = json.decode(data.current.value.damage)
                            local enginheltss = 0
                            local bodyhelss = 0
                            local fuelhealthss = 0
                            local dataaa = {}

                            if vehhh then
                                for kk, vv in pairs(vehhh) do
                                    dataaa[kk] = vv

                                    if kk == "engine_health" then
                                        enginheltss = tostring(math.floor(vv))
                                    elseif kk == "body_health" then
                                        bodyhelss = tostring(math.floor(vv))
                                    elseif kk == "fuel_health" then
                                      fuelhealthss = tostring(math.floor(vv))
                                    end
                                end
                            end

                            local enginheltss = tonumber(enginheltss) or 0

                            local fuelhealthss = tonumber(fuelhealthss) or 0


                            enginheltss = enginheltss / 10

                            fuelhealthss = fuelhealthss

                            local vehpos = GetOffsetFromEntityInWorldCoords(callback_vehicle, 0.0, 0.0, 2.0)
                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.5), 'Benzin : '.. ESX.Math.Round(fuelhealthss) .. '%', 1.5)

                            ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 0.75), 'Salamate Motor : ' .. math.floor(enginheltss) .. '%', 1.5)
                            if not data.current.value.stored then
                              ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z - 1.0), '~r~Impound', 1.5)
                            end

                          end
                          DeleteVehicle(localVeh)
                        end)
                      end
                    end)
                  end
                end, data.current.value.plate)

            else
              ESX.ShowNotification('Mahale Spawm boat Por Ast!!')
            end
          end
        end, function()




          if localVeh then
            DeleteVehicle(localVeh)
            localVeh = nil
          end
          if camera then
            ClearFocus()
            RenderScriptCams(false, false, 0, true, false)
            DestroyCam(camera, false)
            camera = nil
          end
        end)
    end, gname, grank, 'boat',plate)
  end)
end

local uncuffcd = false
function OpenGangActionsMenu()
  ESX.UI.Menu.CloseAll()



  local elements = {
    {label = "Cuff",        value = 'handcuff'},
    {label = "UnCuff",              value = 'uncuff'},
    {label = "Darg",            value = 'drag'},
    {label = "Put In Vehicle",  value = 'put_in_vehicle'},
    {label = "Out The Vehicle", value = 'out_the_vehicle'},
  }

  if Data.search then table.insert(elements, {label = 'Search', value = 'search_player'}) end




  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'citizen_interaction',
  {
    title    = "Gang Menu",
    align    = 'top-left',
    elements = elements
  },
  function(data2, menu2)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local player, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 3.0 then

      	if data2.current.value == 'handcuff' and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then

        playerPed = PlayerPedId()
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        local target, distance = ESX.Game.GetClosestPlayer()
        playerheading = GetEntityHeading(PlayerPedId())
        playerlocation = GetEntityForwardVector(PlayerPedId())
        playerCoords = GetEntityCoords(PlayerPedId())
        local target_id = GetPlayerServerId(target)
        if distance <= 2.0 then

          if not IsPedSittingInAnyVehicle(GetPlayerPed(target)) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
            ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
              if not Cuff then

                if not IsInjure or not IsDead then
                  if IsEntityPlayingAnim(GetPlayerPed(target), "missminuteman_1ig_2","handsup_enter", 3) then
                  TriggerServerEvent('esx:requestarrestpd', target_id, playerheading, playerCoords, playerlocation, false)

                  ESX.TriggerServerCallback('3dme:getIcName', function(PlayerName)
                    if PlayerName ~= nil then
                      local text = '* ' .. PlayerName .. ' Be Fard Dastbadn Mizane *'
                      TriggerServerEvent('3dme:shareDisplay', text, false)
                    end
                    end)

                  else
                    ESX.ShowNotification("~r~Dast Fard Bala Nist!")
                  end
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

		elseif data2.current.value == 'uncuff' and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then

      playerPed = PlayerPedId()
      SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
      local target, distance = ESX.Game.GetClosestPlayer()
      playerheading = GetEntityHeading(PlayerPedId())
      playerlocation = GetEntityForwardVector(PlayerPedId())
      playerCoords = GetEntityCoords(PlayerPedId())
      local target_id = GetPlayerServerId(target)
      if distance <= 2.0 then
        if IsEntityPlayingAnim(GetPlayerPed(player), "mp_arresting","idle", 3) then
          TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
          ESX.TriggerServerCallback('3dme:getIcName', function(PlayerName)

            if PlayerName ~= nil then
              local text = '* ' .. PlayerName .. ' Dastband Fard Ro Baz Mikone *'

              TriggerServerEvent('3dme:shareDisplay', text, false)
            end
          end)
        else
          ESX.ShowNotification("~r~Dast Fard dast Band Naze shode ")
        end
      else
        ESX.ShowNotification('Shakhsi nazdik shoma nist')
      end

		elseif data2.current.value == 'drag' and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then

      local target, distance = ESX.Game.GetClosestPlayer()
      if distance <= 2.0 then


        TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
      else
        ESX.ShowNotification('Shakhsi nazdik shoma nist')
      end

		elseif data2.current.value == 'put_in_vehicle' and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then

      if dragiss then
        TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))

        ESX.TriggerServerCallback('3dme:getIcName', function(PlayerName)

          if PlayerName ~= nil then
            local text = '* ' .. PlayerName .. ' Fard Ro Dakhel Mashin Mizare *'

            TriggerServerEvent('3dme:shareDisplay', text, false)
          end
        end)

      elseif IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then

        local targetSrc = GetPlayerServerId(closestPlayer)
        TriggerServerEvent('carry:respone',false)
        TriggerServerEvent('citizen:stopcarry', targetSrc)
        TriggerEvent('carry:cascel', false)

        ClearPedSecondaryTask(PlayerPedId())

        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent('policejob:putInVehiclecarry', GetPlayerServerId(closestPlayer))

        ESX.TriggerServerCallback('3dme:getIcName', function(PlayerName)

          if PlayerName ~= nil then
            local text = '* ' .. PlayerName .. ' Fard Ro Dakhel Mashin Mizare *'

            TriggerServerEvent('3dme:shareDisplay', text, false)
          end
        end)

      else

        ESX.ShowNotification('~h~~r~Playeri Scort Nakardin!')
      end

    elseif data2.current.value == 'out_the_vehicle' then
      local target, distance = ESX.Game.GetClosestPlayer()
							ESX.TriggerServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(Cuff, IsInjure, IsDead)
								if Cuff then
									TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))

								elseif IsDead then
									TriggerServerEvent('policejob:OutVehiclecarry', GetPlayerServerId(closestPlayer))

								end
							end, GetPlayerServerId(target))
      elseif data2.current.value == "search_player" and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			if Data.search then
				ESX.TriggerServerCallback("esx_ambulancejob:isDead", function(IsDead, Injure)
					if IsEntityPlayingAnim(GetPlayerPed(player), "missminuteman_1ig_2","handsup_enter", 3) or IsDead == true or Injure == true then
						OpenBodySearchMenu(player)
						ESX.TriggerServerCallback('3dme:getIcName', function(PlayerName)
							if PlayerName ~= nil then
								local text = '* ' .. PlayerName .. ' Fard Ro Search Mikone *'
								TriggerServerEvent('3dme:shareDisplay', text, false)
							end
						end)
						TriggerServerEvent('gangprop:messagex', GetPlayerServerId(player), 'Yek Frad Dar Hale ~y~Gashtan~s~ Shoma Ast')
					else
						ESX.ShowNotification("~r~Dast Fard Bala Nist!")
					end
				end, GetPlayerServerId(player))
			else
				ESX.ShowNotification('Gang Shoma Ghabeliyat Search Nadarad')
			end
		elseif data2.current.value == "manage_user" and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			if PlayerData.gang.grade >= Data.invite_access  then
					TriggerEvent('gangs:openInviteF5', PlayerData.gang.name, function(data, menu)
					  menu.close()
					  CurrentAction     = 'menu_boss_actions'
					  CurrentActionMsg  = _U('open_bossmenu')
					  CurrentActionData = {}
					 end)
				else
					ESX.ShowNotification('Rank Shoma Ejaze Invite Member Nadarad')
				end
			end
		elseif data2.current.value == 'lockpick' and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then

		local playerPed = GetPlayerPed(-1)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification('~r~Shoma Svar Mashin Nemitonid In Karo Anjam Dahid!')
				return
			end

		if DoesEntityExist(vehicle) then

				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
				SetVehicleAlarm(vehicle, 1)
				StartVehicleAlarm(vehicle)
				SetVehicleAlarmTimeLeft(vehicle, 35000)
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

					ESX.ShowNotification('~g~Dar Mashin Baz Shod')
					IsBusy = false
					TriggerEvent('esx_customItems:checkVehicleStatus', false)
					elseif status then
					IsBusy = false
					ClearPedTasksImmediately(playerPed)
					TriggerEvent('esx_customItems:checkVehicleStatus', false)
					end
				end)

			else
				ESX.ShowNotification('~r~Mashin Nazdik Shoma Nist')
			end
    else
      ESX.ShowNotification('Hich Playeri Nazdik Shoma Nist')
    end

  end,
  function(data2, menu2)
    menu2.close()
  end)
end

function OpenBodySearchMenu(player)

    ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)

        local elements = {}


        TriggerServerEvent("gangprop:notifySearch", GetPlayerServerId(player))
        table.insert(elements, {label = "----- Cash -----", value = nil})
        table.insert(elements, {
          label = 'Pul: $' .. ESX.Math.GroupDigits(data.money),

          value = nil,


        })


        table.insert(elements, {label = '--- Weapons ---', value = nil})
        for i = 1, #data.loadout, 1 do
          local inventoryweapon = data.loadout[i].name
            if inventoryweapon ~= "WEAPON_MINIGUN" and inventoryweapon ~= "WEAPON_SNIPERRIFLE" and inventoryweapon ~= "WEAPON_NIGHTSTICK" and inventoryweapon ~= "WEAPON_STUNGUN" and inventoryweapon ~= "WEAPON_BZGAS" then
                table.insert(elements, {
                    label = _U('confiscate') .. ESX.GetWeaponLabel(data.loadout[i].name),
                    value = data.loadout[i].name,
                    itemType = 'item_weapon',
                    amount = data.loadout[i].ammo
                })
            end
        end

        table.insert(elements, {label = _U('inventory_label'), value = nil})
        for i = 1, #data.inventory, 1 do
          local inventoryitem = data.inventory[i].name
            if data.inventory[i].count > 0 and inventoryitem ~= "hifi" and inventoryitem ~= "customcoupon" then
                table.insert(elements, {
                    label = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
                    value = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount = data.inventory[i].count
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
            title = _U('search'),
            align    = 'top-left',
            elements = elements
        }, function(data, menu)

            local itemType = data.current.itemType
            local itemName = data.current.value
			local amount = data.current.amount

			if itemType == 'item_standard' or itemType == 'item_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Search', {
				title = "Tedad Ra Vared Konid!"
				}, function(data, menu2)

				local amounts = tonumber(data.value)
				if amounts == nil then
					ESX.ShowNotification("Lotfan Yek Adad Vared Konid")
				else
					local coords = GetEntityCoords(GetPlayerPed(-1))
					local coords2 = GetEntityCoords(GetPlayerPed(player))
					if math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z)) < 3 then
						local amounts = tonumber(data.value)
						TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amounts)
						OpenBodySearchMenu(player)
						menu2.close()
					else
						ESX.ShowNotification("~r~Kasi Nazdik Shoma Nist!")
						ESX.UI.Menu.CloseAll()
						menu2.close()
					end
				end

			end, function(data, menu2)
					menu2.close()
				end)
			else

				local coords = GetEntityCoords(GetPlayerPed(-1))
				local coords2 = GetEntityCoords(GetPlayerPed(player))
					if math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z)) < 3 then
						local amounts = tonumber(data.value)
						TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, data.current.amount)
						OpenBodySearchMenu(player)
					else
						ESX.ShowNotification("~r~Kasi Nazdik Shoma Nist!")
						ESX.UI.Menu.CloseAll()
					end
				end


        end, function(data, menu)
            menu.close()
            ESX.UI.Menu.CloseAll()
        end)

    end, GetPlayerServerId(player))

end

function OpenGetStocksMenu(gang)
local gang = gang

 ESX.TriggerServerCallback('gangs:getStockItems', function(items)

  local elements = {}

  table.insert(elements, {label = items.dirty_money .. "$ Pool Kasif", value = items.dirty_money})

  for i=1, #items, 1 do
    table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
  end

   ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'stocks_menu',
    {
      title    = _U('gang_stock'),
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
            ESX.ShowNotification(_U('quantity_invalid'))
          else
            menu2.close()
            menu.close()
            TriggerServerEvent('gangs:getStockItem', gang, itemName, count)
            OpenGetStocksMenu(gang)
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

 end, gang)

end

function OpenPutStocksMenu(station)
local gang = station

 ESX.TriggerServerCallback('gangprop:getPlayerInventory', function(inventory)

   local elements = {}

   table.insert(elements, {label = inventory.dirty_money .. "$ Pool Kasif", type = 'item_dirty_money', value = inventory.dirty_money})

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

            TriggerServerEvent('gangs:putStockItems', gang, itemName, count)
            OpenPutStocksMenu(station)
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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  local WWaiTT = true
  if PlayerData.gang.name ~= 'nogang' then
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
      if data ~= nil then
        Data.gang_name    = data.gang_name
        Data.blip         = json.decode(data.blip)
        blipManager(Data.blip)

        Data.armory         = json.decode(data.armory)
        Data.locker         = json.decode(data.locker)
        Data.boss           = json.decode(data.boss)
        Data.vehicles       = json.decode(data.vehicles)
        Data.veh            = json.decode(data.veh)
        Data.vehdel         = json.decode(data.vehdel)
        Data.vehspawn       = json.decode(data.vehspawn)
        Data.vehprop        = json.decode(data.vehprop)
        Data.heli           = json.decode(data.heli)
        Data.helidel        = json.decode(data.helidel)
        Data.helispawn      = json.decode(data.helispawn)
        Data.boat           = json.decode(data.boat)
        Data.boatdel        = json.decode(data.boatdel)
        Data.boatspawn      = json.decode(data.boatspawn)
        Data.search         = data.search
        Data.lockpick       = data.lockpick
        Data.bulletproof    = data.bulletproof
        Data.price          = data.price
        Data.garage_access  = data.garage_access
        Data.heli_access    = data.heli_access
        Data.boat_access    = data.boat_access
        Data.armory_access  = data.armory_access
        Data.vest_access    = data.vest_access
        Data.invite_access  = data.invite_access
        Data.gps            = data.gps
        Data.gps_color      = data.gps_color
        Data.blip_sprite    = data.blip_sprite
        Data.blip_color     = data.blip_color
		ESX.SetPlayerData('CanGangLog', data.logpower)
		ESX.SetPlayerData('CanGangVIP', data.vip)
      else
        ESX.ShowNotification('Gang Shoma Disable Shode Ast Lotfan Be Staff Morajee Konid!')
      end
      WWaiTT = false
    end, PlayerData.gang.name)
  end
  Citizen.CreateThread(function()
    while WWaiTT do
      Citizen.Wait(1)
    end
    while PlayerData.gang.name ~= 'nogang' and Data.gang_name do
      Citizen.Wait(1)
      if IsControlJustReleased(0, Keys['F5']) then

		if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			OpenGangActionsMenu()
		end

      end
    end
  end)


  TriggerServerEvent('gangprop:forceBlip')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
  PlayerData.gang = gang
  Data = {}
  TriggerServerEvent('gangprop:forceBlip')
  local WWaiTT = true
  if PlayerData.gang.name ~= 'nogang' then
    ESX.TriggerServerCallback('gangs:getGangData', function(data)
      if data ~= nil then
        Data.blip         = json.decode(data.blip)
        blipManager(Data.blip)

        Data.gang_name      = data.gang_name
        Data.armory         = json.decode(data.armory)
        Data.locker         = json.decode(data.locker)
        Data.boss           = json.decode(data.boss)
        Data.vehicles       = json.decode(data.vehicles)
        Data.veh            = json.decode(data.veh)
        Data.vehdel         = json.decode(data.vehdel)
        Data.vehspawn       = json.decode(data.vehspawn)
        Data.vehprop        = json.decode(data.vehprop)
        Data.heli           = json.decode(data.heli)
        Data.helidel        = json.decode(data.helidel)
        Data.helispawn      = json.decode(data.helispawn)
        Data.boat           = json.decode(data.boat)
        Data.boatdel        = json.decode(data.boatdel)
        Data.boatspawn      = json.decode(data.boatspawn)
        Data.search         = data.search
        Data.lockpick       = data.lockpick
        Data.bulletproof    = data.bulletproof
        Data.price   	      = data.price
        Data.garage_access  = data.garage_access
        Data.heli_access    = data.heli_access
        Data.boat_access    = data.boat_access
        Data.armory_access  = data.armory_access
        Data.vest_access    = data.vest_access
        Data.invite_access  = data.invite_access
        Data.gps            = data.gps
        Data.gps_color      = data.gps_color
        Data.blip_sprite    = data.blip_sprite
        Data.blip_color     = data.blip_color
		ESX.SetPlayerData('CanGangLog', data.logpower)
		ESX.SetPlayerData('CanGangVIP', data.vip)
      else
        ESX.ShowNotification('~h~~r~Gang Shoma Disable Shode Ast Lotfan Be Staff Morajee Konid!')
      end
      WWaiTT = false
    end, PlayerData.gang.name)
  else
    for _, blip in pairs(allBlip) do
      RemoveBlip(blip)
    end
    allBlip = {}
  end
  Citizen.CreateThread(function()
    while WWaiTT do
      Citizen.Wait(1)
    end
    while PlayerData.gang.name ~= 'nogang' and Data.gang_name do
      Citizen.Wait(1)
      if IsControlJustReleased(0, Keys['F5']) then

		if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			OpenGangActionsMenu()
		end

      end
    end
  end)
end)

function blipManager(blip, name, icon)
  local Name = name or 'Gang'
  local Icon = icon or 674
  for _, blip in pairs(allBlip) do
    RemoveBlip(blip)
  end
  allBlip = {}
  local blipCoord = AddBlipForCoord(blip.x, blip.y)
  table.insert(allBlip, blipCoord)
  SetBlipSprite (blipCoord, Icon)
  SetBlipDisplay(blipCoord, 4)
  SetBlipScale(blipCoord, 0.7)
  SetBlipColour (blipCoord, 76)
  SetBlipAsShortRange(blipCoord, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(Name)
  EndTextCommandSetBlipName(blipCoord)
end

AddEventHandler('gangprop:hasEnteredMarker', function(station, part)

if part == 'Cloakroom' then
  CurrentAction     = 'menu_cloakroom'
  CurrentActionMsg  = _U('open_cloackroom')
  CurrentActionData = {station = station}
end

if part == 'Armory' then
  CurrentAction     = 'menu_armory'
  CurrentActionMsg  = _U('open_armory')
  CurrentActionData = {station = station}
end

if part == 'VehicleSpawner' then
  CurrentAction     = 'menu_vehicle_spawner'
  CurrentActionMsg  = _U('vehicle_spawner')
  CurrentActionData = {station = station}
end

if part == 'HeliSpawner' then
  CurrentAction     = 'menu_heli_spawner'
  CurrentActionMsg  = '~INPUT_CONTEXT~ Baraye Bardashte Heli'
  CurrentActionData = {station = station}
end

if part == 'BoatSpawner' then
  CurrentAction     = 'menu_boat_spawner'
  CurrentActionMsg  = '~INPUT_CONTEXT~ Baraye Bardashte Boat'
  CurrentActionData = {station = station}
end

if part == 'VehicleDeleter' then

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('store_vehicle')
      CurrentActionData = {vehicle = vehicle, station = station}
    end

  end
 end

 if part == 'HeliDeleter' then

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = '~INPUT_CONTEXT~ Baraye Gozashtan Heli'
      CurrentActionData = {vehicle = vehicle, station = station}
    end
  end
end

if part == 'BoatDeleter' then

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsPedInAnyVehicle(playerPed,  false) then

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) then
      CurrentAction     = 'delete_vehicle'
      CurrentActionMsg  = _U('store_vehicle')
      CurrentActionData = {vehicle = vehicle, station = station}
    end
  end
end

 if part == 'BossActions' then
  CurrentAction     = 'menu_boss_actions'
  CurrentActionMsg  = _U('open_bossmenu')
  CurrentActionData = {station = station}
end
end)

AddEventHandler('gangprop:hasExitedMarker', function(station, part)
ESX.UI.Menu.CloseAll()
CurrentAction = nil
end)

RegisterNetEvent('gangprop:handcuffx')
AddEventHandler('gangprop:handcuffx', function()

IsHandcuffed    = not IsHandcuffed
local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Wait(100)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)



RegisterNetEvent('gangprop:removeHandcuff')
AddEventHandler('gangprop:removeHandcuff', function()
	IsHandcuffed = false
end)

RegisterNetEvent('gangprop:removeHandcuffFull')
AddEventHandler('gangprop:removeHandcuffFull', function()

  local playerPed = PlayerPedId()

  IsHandcuffed = false

  ClearPedSecondaryTask(playerPed)
  SetEnableHandcuffs(playerPed, false)
  DisablePlayerFiring(playerPed, false)
  SetPedCanPlayGestureAnims(playerPed, true)

  TriggerEvent("gangprop:removeHandcuff")
end)

RegisterNetEvent('gangprop:getarrestedx')
AddEventHandler('gangprop:getarrestedx', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)

  local function DisableControl2()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl2()
		end)
	end
  DisableControl2()

	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	IsHandcuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)

  Citizen.Wait(3000)


	DisableControl2 = function() return nil end

end)

RegisterNetEvent('gangprop:doarrestedx')
AddEventHandler('gangprop:doarrestedx', function()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
  local function DisableControl2()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl2()
		end)
	end
  DisableControl2()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)

  Citizen.Wait(3000)


	DisableControl2 = function() return nil end

end)

RegisterNetEvent("gangprop:startAnim")
AddEventHandler("gangprop:startAnim", function(player)
    Citizen.CreateThread(function()
    	if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        RequestAnimDict("random@arrests")
        while not HasAnimDictLoaded( "random@arrests") do
            Citizen.Wait(1)
        end
        TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
    end
    end)
end)

RegisterNetEvent("gangprop:stopAnim")
AddEventHandler("gangprop:stopAnim", function(player)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        ClearPedTasks(GetPlayerPed(-1))
    end)
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
			Citizen.Wait(1)
		end
	end
end

Citizen.CreateThread(function()
	  local playerPed
	  local targetPed
		while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()
			if IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(CopPed))
				if not IsPedSittingInAnyVehicle(targetPed) then

          AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					IsDragged = false
					DetachEntity(playerPed, true, false)
				end

				else
					DetachEntity(playerPed, true, false)
				end
			else
			Citizen.Wait(1)
		end
	end
end)

RegisterNetEvent('gangprop:putInVehiclex')
AddEventHandler('gangprop:putInVehiclex', function(vehicle)
    if not NetworkDoesNetworkIdExist(vehicle) then return end
    local veh = NetworkGetEntityFromNetworkId(vehicle)
    local ped = PlayerPedId()

    if IsVehicleSeatFree(veh, 1) then

        TaskWarpPedIntoVehicle(ped, veh, 1)
        TriggerEvent('RV_HuD:chageStatus', true)

    elseif IsVehicleSeatFree(veh, 2) then

        TaskWarpPedIntoVehicle(ped, veh, 2)
        TriggerEvent('RV_HuD:chageStatus', true)
	end
end)

RegisterNetEvent('gangprop:putInVehiclex')
AddEventHandler('gangprop:putInVehiclex', function()

local playerPed = GetPlayerPed(-1)
local coords    = GetEntityCoords(playerPed)

 if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

   local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

   if DoesEntityExist(vehicle) then

    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = nil

     for i=maxSeats - 1, 0, -1 do
      if IsVehicleSeatFree(vehicle,  i) then
        freeSeat = i
        break
      end
    end

     if freeSeat ~= nil then
      TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      TriggerEvent('RV_HuD:chageStatus', true)
    end

   end

 end

end)

RegisterNetEvent('gangprop:OutVehiclex')
AddEventHandler('gangprop:OutVehiclex', function(t)
local ped = GetPlayerPed(t)

plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
local xnew = plyPos.x+2
local ynew = plyPos.y+2
TriggerEvent('RV_HuD:chageStatus', false)
 SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)

Citizen.CreateThread(function()
while true do

  Wait(1)

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)
  if Data.locker ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.locker.x,  Data.locker.y,  Data.locker.z,  true) < PropConfig.DrawDistance then
      DrawMarker(21, Data.locker.x,  Data.locker.y,  Data.locker.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8,0.8,0.8, 0, 0, 255, 100, true, true, 2, true, false, false, false)
    end
  end

  if Data.armory ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.armory.x,  Data.armory.y,  Data.armory.z,  true) < PropConfig.DrawDistance then
      DrawMarker(42, Data.armory.x,  Data.armory.y,  Data.armory.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8,0.8,0.8, 150, 200, 150, 100, true, true, 2, true, false, false, false)
    end
  end

  if Data.veh ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.veh.x,  Data.veh.y,  Data.veh.z,  true) < PropConfig.DrawDistance then
      DrawMarker(36, Data.veh.x,  Data.veh.y,  Data.veh.z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PropConfig.MarkerSize.x, PropConfig.MarkerSize.y, PropConfig.MarkerSize.z, PropConfig.MarkerColorVeh.r, PropConfig.MarkerColorVeh.g, PropConfig.MarkerColorVeh.b, 100, false, true, 2, true, false, false, false)
    end
  end

  if Data.vehdel ~= nil then
    if GetDistanceBetweenCoords(coords,   Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z,  true) < PropConfig.DrawDistance then
      DrawMarker(24, Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z+0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, PropConfig.MarkerSize.x+0.5, PropConfig.MarkerSize.y+0.5, PropConfig.MarkerSize.z+0.5, PropConfig.MarkerColorVehDel.r, PropConfig.MarkerColorVehDel.g, PropConfig.MarkerColorVehDel.b, 100, false, true, 2, true, false, false, false)
    end
  end

  if Data.heli ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.heli.x,  Data.heli.y,  Data.heli.z,  true) < PropConfig.DrawDistance then
      DrawMarker(34, Data.heli.x,  Data.heli.y,  Data.heli.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8,0.8,0.8, 0, 255, 0, 100, true, true, 2, true, false, false, false)
    end
  end

  if Data.helidel ~= nil then
    if GetDistanceBetweenCoords(coords,   Data.helidel.x,  Data.helidel.y,  Data.helidel.z,  true) < PropConfig.DrawDistance then
      DrawMarker(34, Data.helidel.x,  Data.helidel.y,  Data.helidel.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0,3.0,2.5, 255, 0, 0, 100, true, true, 2, false, false, false, false)
    end
  end

  if Data.boat ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.boat.x,  Data.boat.y,  Data.boat.z,  true) < PropConfig.DrawDistance then
      DrawMarker(35, Data.boat.x,  Data.boat.y,  Data.boat.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8,0.8,0.8, 0, 255, 0, 100, true, true, 2, true, false, false, false)
    end
  end

  if Data.boatdel ~= nil then
    if GetDistanceBetweenCoords(coords,   Data.boatdel.x,  Data.boatdel.y,  Data.boatdel.z,  true) < PropConfig.DrawDistance then
      DrawMarker(35, Data.boatdel.x,  Data.boatdel.y,  Data.boatdel.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0,3.0,2.5, 255, 0, 0, 100, true, true, 2, false, false, false, false)
    end
  end

  if Data.boss ~= nil then
    if GetDistanceBetweenCoords(coords,  Data.boss.x,  Data.boss.y,  Data.boss.z,  true) < PropConfig.DrawDistance then
      DrawMarker(31, Data.boss.x,  Data.boss.y,  Data.boss.z+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8,0.8,0.8, 255, 255, 255, 100, true, true, 2, true, false, false, false)
    end
  end

end
end)

Citizen.CreateThread(function()

 while true do

  Wait(1)

  if PlayerData.gang ~= nil then
    local playerPed      = GetPlayerPed(-1)
    local coords         = GetEntityCoords(playerPed)
    local isInMarker     = false
    local currentStation = nil
    local currentPart    = nil

    if Data.locker ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.locker.x,  Data.locker.y,  Data.locker.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'Cloakroom'
      end
    end

    if Data.armory ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.armory.x,  Data.armory.y,  Data.armory.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'Armory'
      end
    end

    if Data.veh ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.veh.x,  Data.veh.y,  Data.veh.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleSpawner'
      end
    end

    if Data.vehspawn ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.vehspawn.x,  Data.vehspawn.y,  Data.vehspawn.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleSpawnPoint'
      end
    end

    if Data.vehdel ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.vehdel.x,  Data.vehdel.y,  Data.vehdel.z+0.15,  true) < 4.0 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'VehicleDeleter'
      end
    end

    if Data.heli ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.heli.x,  Data.heli.y,  Data.heli.z,  true) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'HeliSpawner'
      end
    end

    if Data.helispawn ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.helispawn.x,  Data.helispawn.y,  Data.helispawn.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'HeliSpawnPoint'
      end
    end

    if Data.helidel ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.helidel.x,  Data.helidel.y,  Data.helidel.z+0.15,  true) < 3.0 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'HeliDeleter'

      end
    end

    if Data.boat ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.boat.x,  Data.boat.y,  Data.boat.z,  true) < 1.5 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'BoatSpawner'

      end
    end

    if Data.boatspawn ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.boatspawn.x,  Data.boatspawn.y,  Data.boatspawn.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'BoatSpawnPoint'
      end
    end

    if Data.boatdel ~= nil then
      if GetDistanceBetweenCoords(coords,  Data.boatdel.x,  Data.boatdel.y,  Data.boatdel.z+0.15,  true) < 3.0 then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'BoatDeleter'
        ESX.ShowHelpNotification(' ~INPUT_CONTEXT~ Baraye Park Boat')
      end
    end

    if Data.boss ~= nil and PlayerData.gang ~= nil then
      if GetDistanceBetweenCoords(coords,   Data.boss.x,  Data.boss.y,  Data.boss.z,  true) < PropConfig.MarkerSize.x then
        isInMarker     = true
        currentStation = Data.gang_name
        currentPart    = 'BossActions'
      end
    end

    local hasExited = false

    if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart)) then
      if
        (LastStation ~= nil and LastPart ~= nil) and
        (LastStation ~= currentStation or LastPart ~= currentPart)
      then
        TriggerEvent('gangprop:hasExitedMarker', LastStation, LastPart)
        hasExited = true
      end
      HasAlreadyEnteredMarker = true
      LastStation             = currentStation
      LastPart                = currentPart

      TriggerEvent('gangprop:hasEnteredMarker', currentStation, currentPart)
    end

    if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

      HasAlreadyEnteredMarker = false

      TriggerEvent('gangprop:hasExitedMarker', LastStation, LastPart)
    end
  end
 end
end)

Citizen.CreateThread(function()
while true do

   Citizen.Wait(1)

   if CurrentAction ~= nil then
	ESX.ShowHelpNotification(CurrentActionMsg)
      if IsControlPressed(0,  Keys['E']) and PlayerData.gang ~= nil and PlayerData.gang.name == CurrentActionData.station and (GetGameTimer() - GUI.Time) > 150 then
        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        elseif CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        elseif CurrentAction == 'menu_vehicle_spawner' then

				  ListOwnedCarsMenu()
	    elseif CurrentAction == 'menu_heli_spawner' then

				ListOwnedAircraftsMenu()

    elseif CurrentAction == 'menu_boat_spawner' then
			if PlayerData.gang.grade >= Data.boat_access then
				ListOwnedBoatsMenu()
			else
				ESX.ShowNotification('Rank Shoma Ejaze Baz Kardan Garage Boat Ra Nadarad!')
			end
        elseif CurrentAction == 'delete_vehicle' then
          StoreOwnedCarsMenu()
        elseif CurrentAction == 'menu_boss_actions' then
          ESX.UI.Menu.CloseAll()
          TriggerEvent('gangs:openBossMenu', CurrentActionData.station, function(data, menu)
          menu.close()
          CurrentAction     = 'menu_boss_actions'
          CurrentActionMsg  = _U('open_bossmenu')
          CurrentActionData = {}
          end)
		end
        CurrentAction = nil
        GUI.Time      = GetGameTimer()
      end
    end
  end
end)

function StoreOwnedCarsMenu()
	local playerPed      = GetPlayerPed(-1)
  	local coords       = GetEntityCoords(playerPed)
  	local vehicle      = CurrentActionData.vehicle
  	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
  	local engineHealth = GetVehicleEngineHealth(vehicle)
  	local healthPercent = (engineHealth / 1000) * 100
  	local plate        = vehicleProps.plate
  	local vehicleModel = vehicleProps.model
    local engines      = false

    ESX.TriggerServerCallback('gangprop:getCars', function(datas)
      for k,v in pairs(datas) do
        if v.plate == plate then
          engines = v.damage
        end
      end
    end)
    Wait(20)
  	ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
    	if valid then
      		if engineHealth < 990 then
        		local apprasial = math.floor((1000 - engineHealth) / 1000 * 1000 * 5)
        		reparation(apprasial, vehicle, vehicleProps)
      		else
        		putaway(vehicle, vehicleProps)
      		end
      		Wait(50)

      		local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)
      		local vehicleLabel = GetLabelText(vehicleName)

      		TriggerServerEvent('gangs:vehlogs', vehicleLabel, vehicleProps.plate, 'veh', 'delete', healthPercent, engines)

    	else
      		ESX.Game.DeleteVehicle(vehicle)
    	end
  	end, vehicleProps)
end

function reparation(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Park kardane mashin va Pardakhte ($"..math.ceil(tonumber(apprasial)/2)..")", value = 'yes'},
		{label = "Tamas Ba mechanic", value = 'no'},
		{label = 'Park Kardan', value = 'Fuck'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title    = "Mashine shoma Zarbe Khorde",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_advancedgarage:mechaniclive', function(count)
				if count >= 1 then
					ESX.ShowNotification("~r~Mechanic Dar Shahr Hozoor Dard Nemitavinid Mashin Ro Salem Dar Parking Bezarid!")
				else

				ESX.TriggerServerCallback('esx_advancedgarage:checkRepairCost', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_advancedgarage:payhealth', math.ceil(tonumber(apprasial)/2))
						TriggerEvent('es_admin:repair')
						putaway(vehicle, vehicleProps)
					else
						ESX.ShowNotification('Shoma Poole Kafi nadarid')
					end
				end, math.ceil(tonumber(apprasial)))
			end
		end)

		elseif data.current.value == 'no' then
			ESX.ShowNotification('Be Mechanici Beravid!')
		elseif data.current.value == 'Fuck' then
			putaway(vehicle,vehicleProps)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function putaway(vehicle, vehicleProps)
	local ped     = GetPlayerPed(-1)
  local coords  = GetEntityCoords(ped)
	if GetPedInVehicleSeat(vehicle, -1) == ped then
    local damages  = GetVehicleDamages(vehicle)
    ESX.Game.DeleteVehicle(vehicle)
    TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true, json.encode(damages))
    ESX.ShowNotification('Mashin dar Garage Park shod')
	else
		TriggerEvent('chat:addMessage', {
		color = { 255, 0, 0},
		multiline = true,
		args = {"[SYSTEM]", "^0Shoma baraye estefade az in dastor bayad ranande bashid!"}
		})
	end
end





RegisterNetEvent("setArmorHandler")
AddEventHandler("setArmorHandler",function()
  local ped = GetPlayerPed(-1)
  SetPedArmour(ped, Data.bulletproof)

  TriggerEvent('skinchanger:getSkin', function(skin)
    if skin.sex == 0 then
      local clothesSkin = {
        ['bproof_1'] = 43,  ['bproof_2'] = 0,
      }
      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    elseif skin.sex == 1 then
      local clothesSkin = {
        ['bproof_1'] = 37,  ['bproof_2'] = 0,
      }
      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end
  end)

end)

RegisterNetEvent("setArmorHandlerMakhfi")
AddEventHandler("setArmorHandlerMakhfi",function()
  local ped = GetPlayerPed(-1)
  SetPedArmour(ped, Data.bulletproof)

end)

function createBlip(id,color)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		SetBlipColour(blip, color)
		SetBlipNameToPlayerName(blip, id)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)

		table.insert(blipsGangs, blip)
	end
end

RegisterNetEvent('gangprop:updateBlip')
AddEventHandler('gangprop:updateBlip', function()

	blipsGangs = {}
  Wait(20000)

	if ESX.GetPlayerData().gang.name ~= 'nogang' then
		ESX.TriggerServerCallback('gangprop:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if Data.gps and Data.gps == 1 then
				if players[i].gang.name == PlayerData.gang.name then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id,Data.gps_color)
					end
				end
			end
			end
		end)
	end

end)

function setDamages(car, damages)
	damages = json.decode(damages)
	for i = 0, GetVehicleNumberOfWheels(car) do
        if damages['burst_tires'] then
            if damages['burst_tires'][i] then
                SetVehicleTyreBurst(car, damages['burst_tires'][i], true, 1000.0)
            end
        end
	end

	for i = 0, 7 do
        if damages['damaged_windows'] then
            if damages['damaged_windows'][i] then
                SmashVehicleWindow(car, damages['damaged_windows'][i])
            end
        end
	end

	for i = 0, GetNumberOfVehicleDoors(car) do
        if damages['broken_doors'] then
			if damages['broken_doors'][i] then
                SetVehicleDoorBroken(car, damages['broken_doors'][i], true)
            end
        end
	end

    if damages['body_health'] then
        SetVehicleBodyHealth(car, damages['body_health'])
    end
    if damages['engine_health'] then
      SetVehicleEngineHealth(car, damages['engine_health'])
    end
    if damages['fuel_health'] then
      SetVehicleFuelLevel(car, damages['fuel_health'])
    end
end

AddEventHandler('gangprop:GetVehicleDamages', function(cb, vehicle)
	cb(GetVehicleDamages(vehicle))
end)

function GetVehicleDamages(vehicle)
	local damages 	   = {['damaged_windows'] = {}, ['burst_tires'] = {}, ['broken_doors'] = {}, ['body_health'] = GetVehicleBodyHealth(vehicle), ['engine_health'] = GetVehicleEngineHealth(vehicle), ['fuel_health'] = GetVehicleFuelLevel(vehicle)}
	for i = 0, GetVehicleNumberOfWheels(vehicle) do
		if IsVehicleTyreBurst(vehicle, i, false) then table.insert(damages['burst_tires'], i) end
	end
	for i = 0, 7 do
		if not IsVehicleWindowIntact(vehicle, i) then table.insert(damages['damaged_windows'], i) end
	end
	for i = 0, GetNumberOfVehicleDoors(vehicle) do
		if IsVehicleDoorDamaged(vehicle, i) then table.insert(damages['broken_doors'], i) end
	end

	return damages
end

Citizen.CreateThread(function()
  while ESX == nil do Citizen.Wait(2500) end
  LoadBlips()
end)

function LoadBlips()
    ESX.TriggerServerCallback('esx_best:getBlips', function(data)
        for k, v in pairs(data) do
          local tempData = json.decode(v.blip)
          local blipCoord = AddBlipForRadius(tempData.x, tempData.y, tempData.z, 50.0)
          SetBlipHighDetail(blipCoord, true)
          SetBlipColour(blipCoord, 44)
          SetBlipAlpha(blipCoord, 100)
          SetBlipAsShortRange(blipCoord, true)
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString('Gang')
          EndTextCommandSetBlipName(blipCoord)
        end
    end)
end

RegisterNetEvent('gangprop:getarrested')
AddEventHandler('gangprop:getarrested', function(playerheading, playercoords, playerlocation, faction, front)
	playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	ESX.UI.Menu.CloseAll()
    ESX.SetPlayerData('isSentenced', true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	if front then
		FrontHandCuffed = true
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)
	else
		SetEntityHeading(PlayerPedId(), playerheading)
	end
	Citizen.Wait(250)
	if not front then
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
		TriggerEvent('disableXDuringAnimation')
		TriggerEvent('esx_policejob:handcuff')
		TriggerEvent('seatbelt:offandOnL', true)

	else
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, 6000 , 2, 0, 0, 0, 0)
	end
	if not front then
		Citizen.Wait(3760)
	else
		Citizen.Wait(6000)
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end
	IsHandcuffed = true
	TriggerCuffCitizen()
	TriggerServerEvent('gangprop:SetCuffStatus', faction)

	if not front then

		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)

	end
	TriggerEvent('skinchanger:getSkin', function(skin)
		if tonumber(skin.sex) == 0 then
			SetPedComponentVariation(playerPed,7,47,0,0)
		else
			SetPedComponentVariation(playerPed,7,25,0,0)
		end
	end)
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('gangprop:doarrested')
AddEventHandler('gangprop:doarrested', function(front)
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	Citizen.Wait(250)
	if not front then
		loadanimdict('mp_arrest_paired')
		TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	else
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,6000, 2, 0, 0, 0, 0)
	end
	Citizen.Wait(3000)


	DisableControl = function() return nil end


end)

RegisterNetEvent('gangprop:getuncuffed')
AddEventHandler('gangprop:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	TriggerEvent('esx_policejob:unrestrain')
	TriggerEvent('seatbelt:offandOnL', false)
	SetEntityCoords(PlayerPedId(), x, y, z)
	if not FrontHandCuffed then
		SetEntityHeading(PlayerPedId(), playerheading)

	else
		SetEntityHeading(PlayerPedId(), playerheading - 180.0)

	end
	Citizen.Wait(250)
	if not FrontHandCuffed then
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
		IsHandcuffed = false

	else
		loadanimdict('anim@move_m@prisoner_cuffed')
		TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8,-1, 2, 0, 0, 0, 0)
		IsHandcuffed = false

	end
	Citizen.Wait(5500)
	IsHandcuffed = false

	DragStatus.IsDragged = false
	DetachEntity(playerPed, true, false)
	TriggerServerEvent('gangprop:SetCuffStatus', false)
	IsHandcuffed = false
	ClearPedTasks(PlayerPedId())
	SetPedComponentVariation(PlayerPedId(),7,0,0,0)
	ESX.SetPlayerData('isSentenced', false)


end)

RegisterNetEvent('gangprop:douncuffing')
AddEventHandler('gangprop:douncuffing', function()
	ClearPedTasks(PlayerPedId())
	local Idies = ESX.Game.GetPlayersServerIdInArea(GetEntityCoords(PlayerPedId()), 5.0)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'uncuff', 1.0)
	local function DisableControl()
		SetTimeout(0, function()
			DisableAllControlActions(0)
			DisableControl()
		end)
	end
	DisableControl()
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
	Draging = false

	DisableControl = function() return nil end
end)

function TriggerCuffCitizen()
	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(1)
			local playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))


				if not IsPedSittingInAnyVehicle(targetPed) then

					AttachEntityToEntity(playerPed, targetPed, 11816, -0.06, 0.65, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		end
	end)


	Citizen.CreateThread(function()
		while IsHandcuffed do
			Citizen.Wait(2)

			DisableControlAction(2, Keys['~'], true)
			DisableControlAction(2, Keys['X'], true)
			DisableControlAction(2, Keys['ESC'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F2'], true)
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
			DisableControlAction(0, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F5'], true)
			DisableControlAction(2, Keys['F8'], true)
			DisableControlAction(2, Keys['H'], true)
			DisableControlAction(2, Keys['M'], true)
			DisableControlAction(2, Keys['V'], true)
			DisableControlAction(2, Keys['P'], true)
			DisableControlAction(2, Keys['L'], true)
			DisableControlAction(2, 59, true)
			DisableControlAction(2, Keys['LEFTCTRL'], true)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, 59, true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true)
			DisableControlAction(27, 75, true)
			DisableControlAction(0, 107, true)
			DisableControlAction(0, 108, true)
			DisableControlAction(0, 109, true)
			DisableControlAction(0, 110, true)
			DisableControlAction(0, 111, true)
			DisableControlAction(0, 112, true)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
			end
			if IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) then
			else
				loadanimdict('mp_arresting')
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
			end
		end
	end)

end

RegisterNetEvent('gangprop:drag')
AddEventHandler('gangprop:drag', function(copID)
	if not IsHandcuffed then
		return
	end
	if DragStatus.CopId then
		TriggerServerEvent('gangprop:lastDragger', DragStatus.CopId)
	end
	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)


end)

RegisterNetEvent('gangprop:lastDragger')
AddEventHandler('gangprop:lastDragger', function()
	Draging = false
end)

RegisterNetEvent('gangprop:draging')
AddEventHandler('gangprop:draging', function(copID)
	Draging = not Draging
	if Draging then
		loadanimdict('switch@trevor@escorted_out')
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		Citizen.CreateThread(function()
			while Draging do
				Wait(0)
				DisableControlAction(2, Keys['LEFTSHIFT'], true)
				DisableControlAction(2, Keys['SPACE'], true)
				DisableControlAction(0, Keys['LEFTSHIFT'], true)
				DisableControlAction(0, Keys['SPACE'], true)
				DisableControlAction(0, Keys['K'], true)
				DisableControlAction(0, Keys['x'], true)
				if IsEntityPlayingAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 3) then

				else
					TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
				end
			end
		end)
		dragiss = true
	else
		Wait(300)
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent('gangprop:putInVehicle')
AddEventHandler('gangprop:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then

		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
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
				TriggerEvent("RV_HuD:chageStatus", true)
				TriggerEvent('autobelt')
				DragStatus.IsDragged = false
			end

		end

	end
end)

RegisterNetEvent('gangprop:OutVehicle')
AddEventHandler('gangprop:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not (IsPedSittingInAnyVehicle(playerPed) and IsHandcuffed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	SetTimeout(1000, function()
		if FrontHandCuffed then
			loadanimdict('anim@move_m@prisoner_cuffed')
			TaskPlayAnim(PlayerPedId(), 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		else
			loadanimdict('mp_arresting')
			TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		end
	end)
end)