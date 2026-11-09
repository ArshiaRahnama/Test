-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local DefaultCar = nil
nearAnyGarage = nil
local nearGarageKey = 0
local targetGang = nil
local garages = {
	{ vec(1230.8, 2720.9, 38.01, 25), 'Sandy'},	-- mc sandy
	{ vec(1336.8, -760.22, 67.12, 20), 'MC2'},	-- mc 2
	{ vec(629.51, 609.71, 129.02, 35), 'MC1'},	-- mc 1
	{ vec(136.43, -3032.7, 7.04, 20), 'TUNE'}, 	-- tune
	{ vec(-83.83, -1998.8, 18.02, 10), 'CarDealer'}, -- car dealer
	{ vec(-1232.54, -2267.62, 13.94, 50), 'Air Port'}, -- air port
	{ vec(-940.28, -1471.48, -0.47, 25), 'Ghayegh'}, -- Ghayegh	
}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	ESX.TriggerServerCallback('esx_lscustom:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local oldCar
function InstanMod(vehicle)
	oldCar = myCar
	myCar = ESX.Game.GetVehicleProperties(vehicle)
end

local globlalvehicle = 0
RegisterNetEvent('esx_lscustom:DontInstallMod')
AddEventHandler('esx_lscustom:DontInstallMod', function()
	myCar = oldCar
	ESX.Game.SetVehicleProperties(globlalvehicle, myCar, nil, nil, targetGang)
	oldCar = nil
end)


RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function(vehicle)
	ESX.Game.SetVehicleProperties(vehicle, myCar, nil, nil, targetGang)
end)

RegisterNetEvent('esx_lscustom:setvehdef')
AddEventHandler('esx_lscustom:setvehdef', function(prop)
	if myCar and myCar.plate and prop and prop.plate then
		if myCar.plate == prop.plate then
			myCar = {}
			ESX.UI.Menu.CloseAll()
		end
	end
end)
local orginal = {}
function CustomColor()
	local elements = {}
	local vehiclePrice = 10000000
	for i=1, #Vehicles, 1 do
		if GetEntityModel(globlalvehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end
	if vehiclePrice == 1000000000 then 
		vehiclePrice = 10000000
	end
	price = math.floor(vehiclePrice * 0.32 / 100)
	table.insert(elements,{label = 'Primary color',value = 'primary'})
	table.insert(elements,{label = 'Secondary color',value = 'secondary'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'C',
	{
		title    = 'LS CUSTOM',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local value = data.current.value
		local elements = {}
		table.insert(elements,{label = 'Default',value = 'de'})
		table.insert(elements,{label = 'Select color ($'.. price .. ')',value = 'select'})
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CC',
		{
			title    = 'LS CUSTOM',
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value == 'de' then
				if value == 'primary' then
					ClearVehicleCustomPrimaryColour(globlalvehicle)
				elseif value == 'secondary' then
					ClearVehicleCustomSecondaryColour(globlalvehicle)
				end
				pr = {}
				pr.color1 = 64
				pr.color2 = 0
				ESX.Game.SetVehicleProperties(globlalvehicle, pr, nil, nil, targetGang)
				myCar = ESX.Game.GetVehicleProperties(globlalvehicle)	
			elseif data2.current.value == 'select' then
				ESX.UI.Menu.CloseAll()
				local r1 , g1 , b1 = GetVehicleCustomPrimaryColour(globlalvehicle)
				local r2 , g2 , b2 = GetVehicleCustomSecondaryColour(globlalvehicle)
				orginal.r1 = r1
				orginal.g1 = g1
				orginal.b1 = b1
				orginal.r2 = r2
				orginal.g2 = g2
				orginal.b2 = b2
				Wait(300)
				local r3 , g3 , b3 
				if value == 'primary' then
					r3 , g3 , b3 = r1 , g1 , b1
				elseif value == 'secondary' then
					r3 , g3 , b3 = r2 , g2 , b2
				end
				TriggerEvent('colorPicker:pick',r3 , g3 , b3,true,function(r, g, b)
					if value == 'primary' then
						SetVehicleCustomPrimaryColour(globlalvehicle,r,g,b)
					elseif value == 'secondary' then
						SetVehicleCustomSecondaryColour(globlalvehicle,r,g,b)
					end
					myCar = ESX.Game.GetVehicleProperties(globlalvehicle)	
				end,function()
					myCar = ESX.Game.GetVehicleProperties(globlalvehicle)	
					TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar,'rgb')
				end,function()
					if value == 'primary' then
						SetVehicleCustomPrimaryColour(globlalvehicle,r1,g1,b1)
					elseif value == 'secondary' then
						SetVehicleCustomSecondaryColour(globlalvehicle,r2,g2,b2)
					end
					myCar = ESX.Game.GetVehicleProperties(globlalvehicle)	
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu) 
		menu.close()
	end)
end
function OpenLSMenu(elems, menuName, menuTitle, parent, vehicle)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName,
	{
		title    = menuTitle,
		align    = 'top-left',
		elements = elems
	}, function(data, menu)
		local isRimMod, found = false, false
		if GetVehiclePedIsIn(PlayerPedId()) ~= globlalvehicle then return end
		if data.current.modType == "modFrontWheels" then
			isRimMod = true
		end
		if data.current.value == 'cc' then
			CustomColor()
		else
			for k,v in pairs(Config.Menus) do

				if k == data.current.modType or isRimMod then

					if data.current.label == _U('by_default') or string.match(data.current.label, _U('installed')) then
						ESX.ShowNotification(_U('already_own', data.current.label))
					else
						local vehiclePrice = 10000000

						for i=1, #Vehicles, 1 do
							if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
								vehiclePrice = Vehicles[i].price
								break
							end
						end

						if vehiclePrice == 1000000000 then 
							vehiclePrice = 10000000
						end
						
						if isRimMod then
							price = math.floor(vehiclePrice * data.current.price / 100)
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar,data.current.modType)
							InstanMod(vehicle)
						elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
							price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 100)
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar,data.current.modType)
							InstanMod(vehicle)
						-- elseif v.modType == 17 then
						-- 	price = math.floor(vehiclePrice * v.price[1] / 100)
						-- 	TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate)
						-- 	InstanMod(vehicle)
						else
							price = math.floor(vehiclePrice * v.price / 100)
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar,data.current.modType)
							InstanMod(vehicle)
						end
					end
					
					menu.close()
					found = true
					break
				end

			end
			if not found then
				GetAction(data.current, vehicle)
			end
		end

	end, function(data, menu) -- on cancel
		menu.close()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
		if parent == nil  then
			myCar = {}
		end
	end, function(data, menu) -- on change
		UpdateMods(data.current, vehicle)
	end, function()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
	end)
end

function UpdateMods(data, vehicle)
	if data.modType then
		local props = {}
		
		if data.wheelType then
			props['wheels'] = data.wheelType
			ESX.Game.SetVehicleProperties(vehicle, props, nil, nil, targetGang)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props, nil, nil, targetGang)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props, nil, nil, targetGang)
			props = {}
		elseif data.modType == 'dashboardColor' then
			SetVehicleDashboardColor(vehicle, data.modNum)
			return
		elseif data.modType == 'interiorColor' then
			SetVehicleInteriorColor(vehicle, data.modNum)
			return
		end

		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props, nil, nil, targetGang)
	end
end

function GetAction(data, vehicle)
	local elements  = {}
	local menuName  = ''
	local menuTitle = ''
	local parent    = nil

	local playerPed = PlayerPedId()
	local currentMods = ESX.Game.GetVehicleProperties(vehicle)
	if data.value == 'modSpeakers' or
		data.value == 'modTrunk' or
		data.value == 'modHydrolic' or
		data.value == 'modEngineBlock' or
		data.value == 'modAirFilter' or
		data.value == 'modStruts' or
		data.value == 'modTank' then
		SetVehicleDoorOpen(vehicle, 4, false)
		SetVehicleDoorOpen(vehicle, 5, false)
	elseif data.value == 'modDoorSpeaker' then
		SetVehicleDoorOpen(vehicle, 0, false)
		SetVehicleDoorOpen(vehicle, 1, false)
		SetVehicleDoorOpen(vehicle, 2, false)
		SetVehicleDoorOpen(vehicle, 3, false)
	else
		SetVehicleDoorsShut(vehicle, false)
	end

	local vehiclePrice = 10000000

	for i=1, #Vehicles, 1 do
		if GetEntityModel(vehicle) == GetHashKey(Vehicles[i].model) then
			vehiclePrice = Vehicles[i].price
			break
		end
	end
	if vehiclePrice == 1000000000 then 
		vehiclePrice = 10000000
	end
	for k,v in pairs(Config.Menus) do

		if data.value == k then

			menuName  = k
			menuTitle = v.label
			parent    = v.parent

			if v.modType then
				
				if v.modType == 22 then
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = false})
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- disable neon
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end

				if v.modType == 14 then -- HORNS
					for j = 0, 51, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetHornName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetHornName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 'plateIndex' then -- PLATES
					for j = 0, 4, 1 do
						local _label = ''
						if j == currentMods.plateIndex then
							_label = GetPlatesName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetPlatesName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 22 then -- NEON
					--[[local _label = ''
					if currentMods.modXenon then
						_label = _U('neon') .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						price = math.floor(vehiclePrice * v.price / 100)
						_label = _U('neon') .. ' - <span style="color:green;">$' .. price .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})]]
					local xl = GetXenon()
					for i=0, 12, 1 do
						price = math.floor(vehiclePrice * v.price / 100)
						if GetVehicleXenonLightsColor(vehicle) == i then
							table.insert(elements, {
								label = xl[i] .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>',
								modType = k,
								modNum = i
							})
						else
							table.insert(elements, {
								label = xl[i] .. ' - <span style="color:green;">$' .. price .. '</span>',
								modType = k,
								modNum = i
							})
						end
					end
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then -- NEON & SMOKE COLOR
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 100)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' or v.modType == 'dashboardColor' or v.modType == 'interiorColor' then -- RESPRAYS & DASHBOARD/INTERIOR
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(vehiclePrice * v.price / 100)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then -- WINDOWS TINT
					for j = 1, 5, 1 do
						local _label = ''
						if j == currentMods.modHorns then
							_label = GetWindowName(j) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price / 100)
							_label = GetWindowName(j) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
					end
				elseif v.modType == 23 then -- WHEELS RIM & TYPE
					local props = {}

					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props, nil, nil, targetGang)

					local modCount = GetNumVehicleMods(vehicle, v.modType)
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods.modFrontWheels then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = 'modFrontWheels', modNum = j, wheelType = v.wheelType, price = v.price})
						end
					end
				elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- UPGRADES
					for j = 0, modCount, 1 do
						local _label = ''
						if j == currentMods[k] then
							_label = _U('level', j+1) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
						else
							price = math.floor(vehiclePrice * v.price[j+1] / 100)
							_label = _U('level', j+1) .. ' - <span style="color:green;">$' .. price .. ' </span>'
						end
						table.insert(elements, {label = _label, modType = k, modNum = j})
						if j == modCount-1 then
							break
						end
					end
				elseif v.modType == 17 then -- TURBO
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor(vehiclePrice * v.price[1] / 100) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType) -- BODYPARTS
					for j = 0, modCount, 1 do
						local modName = GetModTextLabel(vehicle, v.modType, j)
						if modName then
							local _label = ''
							if j == currentMods[k] then
								_label = GetLabelText(modName) .. ' - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
							else
								price = math.floor(vehiclePrice * v.price / 100)
								_label = GetLabelText(modName) .. ' - <span style="color:green;">$' .. price .. ' </span>'
							end
							table.insert(elements, {label = _label, modType = k, modNum = j})
						end
					end
				end
			else
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' or data.value == 'dashboardColor' or data.value == 'interiorColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
						elseif data.value == 'dashboardColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'dashColor', color = Config.Colors[i].value})
						elseif data.value == 'interiorColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'intColor', color = Config.Colors[i].value})
						end
					end
				else
					for l,w in pairs(v) do
						if l ~= 'label' and l ~= 'parent' then
							table.insert(elements, {label = w, value = l})
						end
					end
				end
			end
			break
		end
	end

	table.sort(elements, function(a, b)
		return a.label < b.label
	end)

	OpenLSMenu(elements, menuName, menuTitle, parent, vehicle)
end

-- Prevent Free Tunning Bug
function threadcontrol()
	Citizen.CreateThread(function()
		while lsMenuIsShowed do
			Citizen.Wait(10)
				DisableControlAction(2, 288, true)
				DisableControlAction(2, 289, true)
				DisableControlAction(2, 170, true)
				DisableControlAction(2, 167, true)
				DisableControlAction(2, 168, true)
				DisableControlAction(2, 23, true)
		end
	end)
end

RegisterCommand('custom', function()
	local playerPed = GetPlayerPed(-1)
	local coords   = GetEntityCoords(playerPed)
	if ESX.UI.Menu.OpenCount() > 0 then
		ESX.ShowNotification('Yek menu baze :| aval oun ro beband')
		return
	end
	ESX.TriggerServerCallback('esx_society:getJobPerm',function(perm)
		if perm and PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' and perm[tostring(PlayerData.job.grade)] and perm[tostring(PlayerData.job.grade)].vehicleCustom then
			if NearAnyGarage(coords) then
				globlalvehicle = ESX.Game.GetVehicleInDirection(4)
				if globlalvehicle == 0 then
					globlalvehicle = GetVehiclePedIsIn(playerPed, false)
				end
				if globlalvehicle == 0 then
					ESX.ShowNotification('Shoma Be Hich mashini Eshare nemikonid')
					return
				end
	
				myCar = ESX.Game.GetVehicleProperties(globlalvehicle)
				ESX.TriggerServerCallback('esx_lscustom:IsRequstedVehicle', function(bool, vehicleData)
					if bool then
						targetGang = vehicleData.gang
						NetworkRequestControlOfEntity(globlalvehicle)
	
						while not NetworkHasControlOfEntity(globlalvehicle) do
							Wait(100)
						end
	
						ESX.UI.Menu.CloseAll()
						GetAction({value = 'main'}, globlalvehicle)
						Citizen.CreateThread(function()
							while true do
								if GetVehiclePedIsIn(PlayerPedId()) ~= globlalvehicle then
									ESX.UI.Menu.CloseAll()
									TriggerEvent('showpicker',false)
									break
								end
								Wait(100)
							end
						end)
						lsMenuIsShowed = true
						threadcontrol()
					else
						ESX.ShowNotification('Hick Kas baraye Upgrade in mashin Darkhast Sabt nakarde ast')	
					end
				end, ESX.Math.Trim(myCar.plate))
			else
				ESX.ShowNotification('Shoma faqat dar Parking Mechanici mitonid Custom konid')			
			end
		else
			ESX.ShowNotification('Shoma nemitonid az in command estefade konid')
		end
	end)
end, false)
local inpay = false

function checkpay()
	Citizen.CreateThread(function()
		while ESX.UI.Menu.IsOpen('question',GetCurrentResourceName(),'Aks_For_Pay') do
			Wait(10)
			if GetVehiclePedIsIn(PlayerPedId()) == 0 then
				ESX.UI.Menu.CloseAll()
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed)

		if DoesEntityExist(vehicle) then 
			nearAnyGarage = NearAnyGarage(coords, GetVehicleClass(vehicle))
		else
			 nearAnyGarage = false
	    end
         
	end
end)

AddEventHandler("onKeyDown", function(key)
	if not nearAnyGarage then
		return
	end
	if key == "y" and ESX.GetPlayerData()['IsDead'] ~= 1 then
		requestMechanicAction()
	end
end)

local notificationSpam = false
local AlreadyCalledMechanic = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if nearAnyGarage then
			SetTextComponentFormat("STRING")
			if AlreadyCalledMechanic then
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Payane Kare Mashin")
			else
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Darkhaste Mechanic")
			end
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		else
			Citizen.Wait(1000)
		end
	end
end)

function requestMechanicAction()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(GetPlayerPed(-1))
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local plate = GetVehicleNumberPlateText(vehicle)
	DefaultCar = ESX.Game.GetVehicleProperties(vehicle)
	ESX.UI.Menu.CloseAll()
	if GetPedInVehicleSeat(vehicle, -1) == playerPed then
		ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'inCustom', true)
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		if exports['sunset_utils']:canAccessToVehicle(vehicle) then
			ESX.TriggerServerCallback('esx_lscustom:checkStatus', function(ordered)
	
				if not ordered then
					AlreadyCalledMechanic = true
					FreezeEntityPosition(vehicle, true)
					if not notificationSpam then
						notificationSpam = true
						SetTimeout(60000, function()
							notificationSpam = false
						end)
						local label = garages[nearGarageKey][2]
						if label then
							ESX.TriggerServerEvent('custom:sendNotification', label)
						end
					end
					TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, true, DefaultCar)
					-- ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
					-- 	ESX.Game.SetVehicleProperties(vehicle, prop or {})
					-- end, DefaultCar.plate)
					ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
						local oldprop = ESX.Game.GetVehicleProperties(vehicle)
						local newprop = {}
						for k , v in pairs(prop or {}) do
							if string.lower(type(v)) ~= 'table' then
								if v ~= oldprop[k] then
									newprop[k] = v
								end
							end
						end
						ESX.Game.SetVehicleProperties(vehicle, newprop or {}, nil, nil, targetGang)
					end, DefaultCar.plate)	
				elseif ordered then
					ESX.TriggerServerCallback('esx_lscustom:PriceOfBill', function(price)
						if price > 0 then
							checkpay()
							local elements = {}
							local tokencount = 0
							local PlayerData = ESX.GetPlayerData()
							for i=1, #PlayerData.inventory do
								if PlayerData.inventory[i].name == 'customtoken' then
									tokencount = PlayerData.inventory[i].count
								end
							end
							local owner = nil
							local p = promise.new()
							ESX.TriggerServerCallback('carlock:getVehicleOwner',function(cb)
								p:resolve(cb)
							end,DefaultCar.plate)
							owner = Citizen.Await(p)
							if tokencount > 0 and (owner and (owner == ESX.GetPlayerData().identifier or owner == ESX.GetPlayerData().gang.name)) then
								elements = {
									{label = 'Naghd', value = 'cash'},
									{label = 'Cart', value = 'bank'},
									{label = 'Coupon', value = 'coupon'},
									{label = 'Enseraf', value = 'cancel'}
								}
							else
								elements = {
									{label = 'Naghd', value = 'cash'},
									{label = 'Cart', value = 'bank'},
									{label = 'Enseraf', value = 'cancel'}
								}
							end
							ESX.UI.Menu.CloseAll()
							ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Pay',
							{
								title 	 = 'Pardakht Hazine',
								align    = 'center',
								question = 'Hazine Mashin shoma $'..ESX.Math.GroupDigits(price) .. ' shode ast, Az kodam ravesh mikhahid in pool ra pardakht konid?',
								elements = elements
							}, function(data, menu)
								if data.current.value == 'cash' then
									ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
										if success then
											paySuccess(vehicle)
											orginal = {}
											ESX.ShowNotification('Mablaghe Pardakhti: ~r~$'..price)	
											AlreadyCalledMechanic = false
										else
											ESX.ShowNotification('Shoma Be andaze Kafi pool naghd nadarid')
										end
									end, DefaultCar.plate, 1)
								elseif data.current.value == 'bank' then
									ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
										if success then
											paySuccess(vehicle)
											orginal = {}
											ESX.ShowNotification('Mablaghe Pardakhti: ~r~$'..price)	
											AlreadyCalledMechanic = false
										else
											ESX.ShowNotification('Mojodie Hesabe Shoma Kafi nemibashad')										
										end
									end, DefaultCar.plate, 2)
								elseif data.current.value == 'coupon' then
									ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
										if success then
											paySuccess(vehicle,true)
											orginal = {}
											ESX.ShowNotification('Mablaghe Pardakhti: ~r~$'..price)	
											AlreadyCalledMechanic = false
										else
											ESX.ShowNotification('Mojodie Hesabe Shoma Kafi nemibashad')										
										end
									end, DefaultCar.plate, 3)
								elseif data.current.value == 'cancel' then
										local vhh = GetVehiclePedIsIn(PlayerPedId(), false)
										local vhhdata = ESX.Game.GetVehicleProperties(vhh)
										NetworkRequestControlOfEntity(vhh)

										while not NetworkHasControlOfEntity(vhh) do
											Wait(100)
										end

										ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
											TriggerServerEvent('esx_lscustom:VehiclesInWatingList', vhhdata.plate, false)
											ESX.Game.SetVehicleProperties(vehicle, prop or {}, nil, nil, targetGang)
											FreezeEntityPosition(vehicle, false)
											ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'inCustom', false)
											DefaultCar = nil
											menu.close()
											AlreadyCalledMechanic = false
											TriggerServerEvent("esx_lscustom:setdef",prop, ESX.Game.GetPlayersToSend(150))
											if GetIsVehiclePrimaryColourCustom(vehicle) then
												SetVehicleCustomPrimaryColour(vehicle,orginal.r1,orginal.g1,orginal.b1)
											end
											if GetIsVehicleSecondaryColourCustom(vehicle) then
												SetVehicleCustomSecondaryColour(vehicle,orginal.r2,orginal.g2,orginal.b2)
											end
										end, vhhdata.plate)																										
								end
							end
							)
						else
							AlreadyCalledMechanic = false
							FreezeEntityPosition(vehicle, false)
							ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'inCustom', false)
							TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
							DefaultCar = nil
						end
					end, DefaultCar.plate)
				end

			end, plate)
		else
			ESX.ShowNotification("~r~Shoma saheb in mashin nistid!")
			DefaultCar = nil
		end
	else
		ESX.ShowNotification("~h~~r~Shoma ranande mashin nistid!")
	end
end


function paySuccess(vehicle,customtoken)
	ESX.UI.Menu.CloseAll()
	AlreadyCalledMechanic = false
	local newcar = ESX.Game.GetVehicleProperties(vehicle)
	if customtoken then
		newcar.modTurbo = true
	end
	ESX.TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	Wait(1000)
	ESX.TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	Wait(1000)
	ESX.TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	--ESX.Game.SetVehicleProperties(vehicle, newcar)	
	FreezeEntityPosition(vehicle, false)
	ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'inCustom', false)
	TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
	DefaultCar = nil
	Wait(1000)
	ESX.UI.Menu.CloseAll()
end

function NearAnyGarage(coords)
	-- if GetDistanceBetweenCoords(coords, -362.94, -92.23, 38.66, true) < 10 or GetDistanceBetweenCoords(coords, 1230.8,2720.9,38.01, true) < 25 or GetDistanceBetweenCoords(coords, 1222.64,2733.96,36.83, true) < 13 or GetDistanceBetweenCoords(coords, 1336.8,-760.22,67.12 , true) < 20 or GetDistanceBetweenCoords(coords, -339.44, -99.57, 38.66, true) < 12 or GetDistanceBetweenCoords(coords, -319.94, -107.54, 38.66, true) < 10 or GetDistanceBetweenCoords(coords, -328.88, -131.54, 38.66, true) < 20 or GetDistanceBetweenCoords(coords, 1175.15, 2639.22, 37.75, true) < 15 or GetDistanceBetweenCoords(coords, -1667.72,-886.63,8.65, true) < 7 or GetDistanceBetweenCoords(coords, 635.51,604.62,129.04, true) < 55 then
	-- 	return true
	-- else
	-- 	return false
	-- end
	for k, v in pairs(garages) do
		if ESX.GetDistance(coords,v[1].xyz) < v[1].w then
			nearGarageKey = k
			return true
		end
	end
end