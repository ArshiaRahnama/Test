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
end)

local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local DefaultCar = nil
nearAnyGarage = nil

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
	ESX.Game.SetVehicleProperties(globlalvehicle, myCar)
	oldCar = nil
end)

RegisterNetEvent('esx_lscustom:cancelInstallMod')
AddEventHandler('esx_lscustom:cancelInstallMod', function(vehicle)
	ESX.Game.SetVehicleProperties(vehicle, myCar)
end)

RegisterNetEvent('esx_lscustom:setvehdef')
AddEventHandler('esx_lscustom:setvehdef', function(prop)
	if myCar ~= {} or myCar ~= nil and prop and prop.plate then
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
	table.insert(elements,{label = 'Primary Color',value = 'primary'})
	table.insert(elements,{label = 'Secondary Color',value = 'secondary'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'C', {title = 'LS CUSTOM', align = 'top-left', elements = elements},
	function(data, menu)
		local value = data.current.value
		local elements = {}
		table.insert(elements,{label = 'Default',value = 'de'})
		table.insert(elements,{label = 'Select Color ($'.. price .. ')',value = 'select'})
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'CC', {title = 'LS CUSTOM', align = 'top-left', elements = elements},
			function(data2, menu2)
			if data2.current.value == 'de' then
				if value == 'primary' then
					ClearVehicleCustomPrimaryColour(globlalvehicle)
				elseif value == 'secondary' then
					ClearVehicleCustomSecondaryColour(globlalvehicle)
				end
				pr = {}
				pr.color1 = 64
				pr.color2 = 0
				ESX.Game.SetVehicleProperties(globlalvehicle, pr)
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
					TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar,true)
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
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), menuName, {title = menuTitle, align = 'top-left', elements = elems},
	function(data, menu)
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
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar)
							InstanMod(vehicle)
						elseif v.modType == 11 or v.modType == 12 or v.modType == 13 or v.modType == 15 or v.modType == 16 then
							price = math.floor(vehiclePrice * v.price[data.current.modNum + 1] / 100)
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar)
							InstanMod(vehicle)
						else
							price = math.floor(vehiclePrice * v.price / 100)
							TriggerServerEvent('esx_lscustom:buyMod', price, myCar.plate,myCar)
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
	end, function(data, menu)
		menu.close()
		lsMenuIsShowed = false
		TriggerEvent('esx_lscustom:cancelInstallMod', vehicle)
		SetVehicleDoorsShut(vehicle, false)
		if parent == nil  then
			myCar = {}
		end
	end, function(data, menu)
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
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'neonColor' then
			if data.modNum[1] == 0 and data.modNum[2] == 0 and data.modNum[3] == 0 then
				props['neonEnabled'] = { false, false, false, false }
			else
				props['neonEnabled'] = { true, true, true, true }
			end
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		elseif data.modType == 'tyreSmokeColor' then
			props['modSmokeEnabled'] = true
			ESX.Game.SetVehicleProperties(vehicle, props)
			props = {}
		end
		props[data.modType] = data.modNum
		ESX.Game.SetVehicleProperties(vehicle, props)
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
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then
					table.insert(elements, {label = " " ..  _U('by_default'), modType = k, modNum = {0, 0, 0}})
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local num = myCar[v.modType]
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = num})
 				else
					table.insert(elements, {label = " " .. _U('by_default'), modType = k, modNum = -1})
				end
				if v.modType == 14 then
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
				elseif v.modType == 'plateIndex' then
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
				elseif v.modType == 22 then
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
				elseif v.modType == 'neonColor' or v.modType == 'tyreSmokeColor' then
					local neons = GetNeons()
					price = math.floor(vehiclePrice * v.price / 100)
					for i=1, #neons, 1 do
						table.insert(elements, {
							label = '<span style="color:rgb(' .. neons[i].r .. ',' .. neons[i].g .. ',' .. neons[i].b .. ');">' .. neons[i].label .. ' - <span style="color:green;">$' .. price .. '</span>',
							modType = k,
							modNum = { neons[i].r, neons[i].g, neons[i].b }
						})
					end
				elseif v.modType == 'color1' or v.modType == 'color2' or v.modType == 'pearlescentColor' or v.modType == 'wheelColor' then
					local colors = GetColors(data.color)
					for j = 1, #colors, 1 do
						local _label = ''
						price = math.floor(vehiclePrice * v.price / 100)
						_label = colors[j].label .. ' - <span style="color:green;">$' .. price .. ' </span>'
						table.insert(elements, {label = _label, modType = k, modNum = colors[j].index})
					end
				elseif v.modType == 'windowTint' then
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
				elseif v.modType == 23 then
					local props = {}
					props['wheels'] = v.wheelType
					ESX.Game.SetVehicleProperties(vehicle, props)
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
					local modCount = GetNumVehicleMods(vehicle, v.modType)
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
				elseif v.modType == 17 then
					local _label = ''
					if currentMods[k] then
						_label = 'Turbo - <span style="color:cornflowerblue;">'.. _U('installed') ..'</span>'
					else
						_label = 'Turbo - <span style="color:green;">$' .. math.floor(vehiclePrice * v.price[1] / 100) .. ' </span>'
					end
					table.insert(elements, {label = _label, modType = k, modNum = true})
				else
					local modCount = GetNumVehicleMods(vehicle, v.modType)
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
				if data.value == 'primaryRespray' or data.value == 'secondaryRespray' or data.value == 'pearlescentRespray' or data.value == 'modFrontWheelsColor' then
					for i=1, #Config.Colors, 1 do
						if data.value == 'primaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color1', color = Config.Colors[i].value})
						elseif data.value == 'secondaryRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'color2', color = Config.Colors[i].value})
						elseif data.value == 'pearlescentRespray' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'pearlescentColor', color = Config.Colors[i].value})
						elseif data.value == 'modFrontWheelsColor' then
							table.insert(elements, {label = Config.Colors[i].label, value = 'wheelColor', color = Config.Colors[i].value})
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
	if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' and PlayerData.job.grade >= 7 then
		if NearAnyGarage(coords) then
			globlalvehicle = ESX.Game.GetVehicleInDirection(4)
			if globlalvehicle == 0 then
				globlalvehicle = GetVehiclePedIsIn(playerPed, false)
			end
			if globlalvehicle == 0 then
				ESX.ShowNotification('Shoma Be Hich Mashini Eshare Nemikonid')
				return
			end
			myCar = ESX.Game.GetVehicleProperties(globlalvehicle)
			ESX.TriggerServerCallback('esx_lscustom:IsRequstedVehicle', function(bool)
				if bool then
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
					ESX.ShowNotification('Hich Kas Baray Upgrade In Mashin Darkhast Sabt Nakarde Ast')
				end
			end, ESX.Math.Trim(myCar.plate))
		else
			ESX.ShowNotification('Shoma Faqat Dar Parking Mechanici Mitonid Custom Konid')
		end
	else
		ESX.ShowNotification('Shoma Nemitunid Az In Command Estefade Konid')
	end
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

local lastMessage = 0
local AlreadyCalledMechanic = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if nearAnyGarage then
			SetTextComponentFormat("STRING")
			if AlreadyCalledMechanic then
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Payan Kar Mashin")
			else
				AddTextComponentString("~INPUT_MP_TEXT_CHAT_TEAM~ Darkhast Mechanic")
			end
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		else
			Citizen.Wait(1000)
		end
	end
end)

function requestMechanicAction()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local plate = GetVehicleNumberPlateText(vehicle)
    DefaultCar = ESX.Game.GetVehicleProperties(vehicle)

    ESX.UI.Menu.CloseAll()

    if GetPedInVehicleSeat(vehicle, -1) == playerPed then
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
        ESX.TriggerServerCallback('CarLock:haskey', function(owner)
            if owner then
                ESX.TriggerServerCallback('esx_lscustom:checkStatus', function(ordered)
                    if not ordered then
                        AlreadyCalledMechanic = true
                        FreezeEntityPosition(vehicle, true)

                        if GetGameTimer() - lastMessage > 1000 * 60 * 5 then

                            TriggerServerEvent('esx_lscustom:NotifyMechanics', plate, coords)

                            TriggerServerEvent('esx_phone:send', 'mechanic', 'سلام، من به یک مکانیک نیاز دارم. در گاراژ مکانیکی منتظرم.', coords, coords)
							TriggerServerEvent('esx_lscustom:NotifyMechanicsChat', plate, coords)
                            TriggerServerEvent('esx_lscustom:PlaySound')
                            lastMessage = GetGameTimer()
                        end

                        TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, true, DefaultCar)
                        ESX.TriggerServerCallback('esx_lscustom:getDefaultCar', function(prop)
                            ESX.Game.SetVehicleProperties(vehicle, prop or {})
                        end, DefaultCar.plate)
                    else
                        ESX.TriggerServerCallback('esx_lscustom:PriceOfBill', function(price)
                            if price > 0 then
                                checkpay()
                                local elements = {}
                                local tokencount = 0
                                local PlayerData = ESX.GetPlayerData()

                                for i=1, #PlayerData.inventory do
                                    if PlayerData.inventory[i].name == 'customcoupon' then
                                        tokencount = PlayerData.inventory[i].count
                                    end
                                end

                                if tokencount > 0 then
                                    elements = {
                                        {label = 'Cash', value = 'cash'},
                                        {label = 'Bank', value = 'bank'},
                                        {label = 'Coupon', value = 'coupon'},
                                        {label = 'Cancel', value = 'cancel'}
                                    }
                                else
                                    elements = {
                                        {label = 'Cash', value = 'cash'},
                                        {label = 'Bank', value = 'bank'},
                                        {label = 'Cancel', value = 'cancel'}
                                    }
                                end

                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'Aks_For_Pay',
                                {
                                    title   = 'پرداخت هزینه',
                                    align   = 'center',
                                    question = 'هزینه ماشین شما $'..ESX.Math.GroupDigits(price)..' شده است. روش پرداخت را انتخاب کنید:',
                                    elements = elements
                                }, function(data, menu)
                                    if data.current.value == 'cash' then
                                        ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
                                            if success then
                                                paySuccess(vehicle)
                                                ESX.ShowNotification('ممنون از انتخاب شما! مبلغ پرداختی: ~r~$'..price)
                                                AlreadyCalledMechanic = false
                                            else
                                                ESX.ShowNotification('موجودی نقدی شما کافی نیست!')
                                            end
                                        end, DefaultCar.plate, false)

                                    elseif data.current.value == 'bank' then
                                        ESX.TriggerServerCallback('esx_lscustom:PayVehicleOrders', function(success)
                                            if success then
                                                paySuccess(vehicle)
                                                ESX.ShowNotification('ممنون از انتخاب شما! مبلغ پرداختی: ~r~$'..price)
                                                AlreadyCalledMechanic = false
                                            else
                                                ESX.ShowNotification('موجودی حساب بانکی شما کافی نیست!')
                                            end
                                        end, DefaultCar.plate, 2)

                                    elseif data.current.value == 'coupon' then
                                        TriggerServerEvent('esx_lscustom:Removecustomcoupon', DefaultCar.plate)
                                        paySuccess(vehicle)
                                        ESX.ShowNotification('پرداخت با کوپن انجام شد! ماشین شما کاستوم شد.')
                                        AlreadyCalledMechanic = false

                                    elseif data.current.value == 'cancel' then
                                        menu.close()
                                        AlreadyCalledMechanic = false
                                    end
                                end)
                            else
                                AlreadyCalledMechanic = false
                                FreezeEntityPosition(vehicle, false)
                                TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
                                DefaultCar = nil
                            end
                        end, DefaultCar.plate)
                    end
                end, plate)
            else
                ESX.ShowNotification("~r~شما صاحب این ماشین نیستید!")
                DefaultCar = nil
            end
        end, ESX.Math.Trim(DefaultCar.plate))
    else
        ESX.ShowNotification("~r~شما راننده ماشین نیستید!")
    end
end

RegisterNetEvent('esx_lscustom:Sound')
AddEventHandler('esx_lscustom:Sound', function()
	ESX.ShowAdvancedNotification("Phone", "New Message", "New Message From ~y~Mechanici", "CHAR_CHAT_CALL", 1)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	Citizen.Wait(300)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
	Citizen.Wait(300)
	PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)

end)

function paySuccess(vehicle)
	ESX.UI.Menu.CloseAll()
	AlreadyCalledMechanic = false
	local newcar = ESX.Game.GetVehicleProperties(vehicle)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	Wait(1000)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	Wait(1000)
	TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', newcar)
	FreezeEntityPosition(vehicle, false)
	TriggerServerEvent('esx_lscustom:VehiclesInWatingList', DefaultCar.plate, false)
	DefaultCar = nil
end

function NearAnyGarage(coords)
	if GetDistanceBetweenCoords(coords, -322.835, -134.060, 39.017, true) < 15 or GetDistanceBetweenCoords(coords, -317.243, -115.608, 39.015, true) < 15 then
		return true
	else
		return false
	end
end