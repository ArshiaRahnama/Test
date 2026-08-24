ESX = nil
local price ={}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		ESX.TriggerServerCallback('GetMahiPrice', function(data)
			price = data
		end)
	end
end)

local blips = {
  {title="Froush Mahi va Gusht", colour=26, id=317, x=-1037.97, y=-1397.11, z=5.5531},
}

local grab = nil
local PlayerProps = {}
local inv = nil
local fishing = false

local grabitems = {
  [1] = { name = 'mahigoli', limit = 100 },
  [2] = { name = 'ghezelala', limit = 100 },
  [3] = { name = 'hamoor', limit = 100 },
  [4] = { name = 'salomon', limit = 100 },
  [5] = { name = 'meygoo', limit = 100 },
  [6] = { name = 'jolbak', limit = 100 },
}

RegisterNetEvent('fishing:start')
AddEventHandler('fishing:start', function()
  if not fishing then

    local coords = GetEntityCoords(GetPlayerPed(-1))

    local inwater , waterheight = GetWaterHeight(
		ESX.Math.Round(coords.x, 1),
    	ESX.Math.Round(coords.y, 1),
    	ESX.Math.Round(coords.z, 1)
    )

    if inwater == 1 and IsPedSwimmingUnderWater(GetPlayerPed(-1)) == false and IsPedSwimming(GetPlayerPed(-1)) == false and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
      fishing = true
      local r = math.random(1,6)
      local inventory = ESX.GetPlayerData().inventory
      local DesiredItem = grabitems[r].name
      local all = 0
      for i=1, #inventory, 1 do

        if inventory[i].name == DesiredItem then
            all = inventory[i].count
        end

      end

      if all >= grabitems[r].limit then
        ESX.ShowNotification('Gholab Gir kard! Yebar dige emtahan kon! Shayadam jaye khali nadari ?')
        fishing = false
        return
      end

      local ChekSkills = exports['Unique_Skills']:CheckSkill('Fishing')
        local duration = 0
        if ChekSkills == 100 then
            duration = math.random(10000, 15000)
        else
            duration = math.random(20000, 30000)
        end

        TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_STAND_FISHING', looped2, true)
        TriggerEvent("mythic_progbar:client:progress", {
            name = "fishing",
            duration = duration,
            label = "Dar hale Mahi Giri",
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
              fishing = false
              removeFishingRod()
              ClearPedTasksImmediately(GetPlayerPed(-1))
              TriggerServerEvent('fishing:done', r)

            elseif status then
                removeFishingRod()
                fishing = false
                ClearPedTasksImmediately(GetPlayerPed(-1))

            end
        end)

    else
      ESX.ShowNotification('Gholabe shoma az inja be ab nemirese!')
    end

  end
end)

function removeFishingRod()
    for k , v in pairs(ESX.Game.GetObjects()) do
        if DoesEntityExist(v) then
            local model = GetEntityModel(v)
            if model == `prop_fishing_rod_01` or model == `prop_fishing_rod_02` then
                ESX.Game.DeleteObject(v)
            end
        end
    end
end
local menuOpen = false

AddEventHandler("onKeyDown", function(key)
    if key == "e" and ESX.GetPlayerData()['IsDead'] ~= 1 then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local inwater , waterheight = GetWaterHeight(
			ESX.Math.Round(coords.x, 1),
			ESX.Math.Round(coords.y, 1),
			ESX.Math.Round(coords.z, 1)
		)
		if inwater == 1 and IsPedSwimmingUnderWater(GetPlayerPed(-1)) == false and IsPedSwimming(GetPlayerPed(-1)) == false and IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
			Mahigiri()
		end



	end
end)

function Mahigiri()
	ESX.TriggerServerCallback('fishing:haveItem', function(ihave)
		if ihave then
			TriggerEvent("fishing:start")
		end
	end)
end

function OpenFishShop()
	menuOpen = true
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        for c,d in ipairs(price) do
            if v.name == d.name then
                if d.price and v.count > 0 then
                    table.insert(elements, {
                        label = (v.name..' - <span style="color:green;">'..ESX.Math.GroupDigits(d.price)..'</span>'),
                        name = v.name,
                        price = d.price,

                        type = 'slider',
                        value = 1,
                        min = 1,
                        max = v.count
                    })
                end
            end
        end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fish_shop', {
		title    = "Kharidar Mahi",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
        TriggerServerEvent('esx_fishing:sellfish', data.current.name, data.current.value, data.current.price)
		ESX.UI.Menu.CloseAll()
        OpenFishShop()
	end, function(data, menu)
		menu.close()
		menuOpen = false
    end, function()
    end,
    function()
        menuOpen = false
		ESX.UI.Menu.CloseAll()
    end)
end

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
end)
