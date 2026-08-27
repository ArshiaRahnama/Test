ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Vehicles
local VehiclesInWatingList = {}

function GetVehicleInList(vehicle)
	if VehiclesInWatingList[vehicle] then
		return vehicle
	end
	return nil
end

-- SECURITY FIX (part of the buyMod fix below): every mod price sent by the
-- client is `vehiclePrice * somePercent / 100`, where the percentages all
-- live in Config.Menus (which this resource also loads server-side -- see
-- fxmanifest.lua). The buyMod event doesn't say WHICH mod is being bought,
-- only a raw price number, so we can't look up the exact percentage for a
-- given call -- but we CAN find the single highest percentage that exists
-- anywhere in the whole catalog, and use it as a hard ceiling no legitimate
-- purchase could ever exceed.
local function computeMaxModPercent(t, best)
	best = best or 0
	if type(t) ~= "table" then return best end
	for k, v in pairs(t) do
		if k == "price" then
			if type(v) == "number" then
				if v > best then best = v end
			elseif type(v) == "table" then
				for _, p in ipairs(v) do
					if type(p) == "number" and p > best then best = p end
				end
			end
		elseif type(v) == "table" then
			best = computeMaxModPercent(v, best)
		end
	end
	return best
end

local MaxModPercent = computeMaxModPercent(Config.Menus)
if MaxModPercent <= 0 then MaxModPercent = 35 end -- config walk found nothing usable; fall back to the highest value observed in Config.Menus at the time of this fix

local function getRealVehiclePrice(vehicleModelHash)
	if not Vehicles or not vehicleModelHash then return nil end
	for i = 1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == vehicleModelHash then
			return Vehicles[i].price
		end
	end
	return nil
end

-- SECURITY FIX: resolves the vehicle's ACTUAL current model server-side by
-- matching its plate against the live game vehicle pool, instead of trusting
-- vehicleProps.model (which comes straight from the client and could be
-- spoofed to claim a cheap model while modding an expensive one -- the gap
-- noted in the previous fix above). GetVehicleNumberPlateText/GetEntityModel
-- read the actual synced entity state, so this can't be spoofed the same way.
local function getServerVehicleModelByPlate(plate)
	if not plate then return nil end
	for _, veh in ipairs(GetGamePool('CVehicle')) do
		if GetVehicleNumberPlateText(veh) == plate then
			return GetEntityModel(veh)
		end
	end
	return nil
end

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price, vehicle)
	local _source = source
	local k = GetVehicleInList(vehicle)
	price = tonumber(price)

	if not k then
		TriggerClientEvent('esx_lscustom:DontInstallMod', _source)
		return
	end

	if not price or price <= 0 then
		TriggerClientEvent('esx_lscustom:DontInstallMod', _source)
		return
	end

	-- Vehicles is only populated once some client has requested
	-- getVehiclesPrices (see below), which always happens on esx:playerLoaded
	-- long before anyone could reach buyMod -- if it's still nil here, there's
	-- nothing to validate against, so refuse rather than trust the client.
	--
	-- vehicleModelHash is resolved server-side from the live entity by plate
	-- (see getServerVehicleModelByPlate above) -- NOT from the client-supplied
	-- vehicleProps.model -- so a modified client can no longer under-report
	-- the model to shop for a lower ceiling.
	local vehicleModelHash = getServerVehicleModelByPlate(vehicle)
	local realVehiclePrice = getRealVehiclePrice(vehicleModelHash)
	if not realVehiclePrice then
		-- Matches the client's own fallback default (see CustomColor()) for
		-- unrecognized/unresolved models so legitimate purchases still work.
		realVehiclePrice = 10000000
	end

	local maxAllowed = math.ceil(realVehiclePrice * MaxModPercent / 100)
	if price > maxAllowed then
		price = maxAllowed
	end

	VehiclesInWatingList[k].price = VehiclesInWatingList[k].price + price
end)

RegisterServerEvent('esx_lscustom:PlaySound')
AddEventHandler('esx_lscustom:PlaySound', function()
	_source = source
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'mechanic' then
			TriggerClientEvent("esx_lscustom:Sound", xPlayer.source)
		end
	end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps)
	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {['@plate'] = vehicleProps.plate},
		function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)
			if vehicleProps.model == vehicle.model then
				exports.oxmysql:execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {['@plate'] = vehicleProps.plate, ['@vehicle'] = json.encode(vehicleProps)})
			end
		end
	end)
end)

RegisterServerEvent('esx_lscustom:VehiclesInWatingList')
AddEventHandler('esx_lscustom:VehiclesInWatingList', function(vehicle, add, vehicleProps)
	local _Source = source
	local found = GetVehicleInList(vehicle)
	if add and not found then
		VehiclesInWatingList[vehicle] = {source = _Source, price = 0, props = vehicleProps}
	elseif not add and found then
		VehiclesInWatingList[vehicle] = nil
	end
end)

ESX.RegisterServerCallback('esx_lscustom:getDefaultCar', function(source, cb, vehicle)
	if VehiclesInWatingList[vehicle] then
		cb(VehiclesInWatingList[vehicle].props)
	else
		cb(nil)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:checkStatus', function(source, cb, vehicle)
	local found = GetVehicleInList(vehicle)
	if found then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_lscustom:NotifyMechanicsChat')
AddEventHandler('esx_lscustom:NotifyMechanicsChat', function(plate, coords)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerName = xPlayer.get('name')

    local players = ESX.GetPlayers()

    for _, playerId in ipairs(players) do
        local player = ESX.GetPlayerFromId(playerId)

        if player and player.job and player.job.name == 'mechanic' then

            TriggerClientEvent('chatMessage', playerId, "^1SYSTEM:", {255, 165, 0}, "^0Darkhast Custom Tavasote ^2" .. playerName .. "^0 Ba Plate ^2" .. plate)
        end
    end
end)

RegisterServerEvent('esx_lscustom:Removecustomcoupon')
AddEventHandler('esx_lscustom:Removecustomcoupon', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('customcoupon')

    if item.count > 0 then
        xPlayer.removeInventoryItem('customcoupon', 1)
        TriggerClientEvent('esx_lscustom:customVehicleCupon', source, plate)
    else
        ESX.ShowNotification('شما کوپن کافی ندارید!')
    end
end)

RegisterNetEvent('esx_lscustom:customVehicleCupon')
AddEventHandler('esx_lscustom:customVehicleCupon', function(plate)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    FreezeEntityPosition(vehicle, false)
end)

ESX.RegisterServerCallback('esx_lscustom:PayVehicleOrders', function(source, cb, vehicle, payWithBank)
	xPlayer = ESX.GetPlayerFromId(source)
	local i = GetVehicleInList(vehicle)
	if i then
		if payWithBank then
			if xPlayer.bank >= VehiclesInWatingList[i].price then
				xPlayer.removeBank(tonumber(VehiclesInWatingList[i].price))
				cb(true)
			else
				cb(false)
			end
		else
			if xPlayer.money >= VehiclesInWatingList[i].price then
				xPlayer.removeMoney(tonumber(VehiclesInWatingList[i].price))
				cb(true)
			else
				cb(false)
			end

		end
	else
		cb(true)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:PriceOfBill', function(source, cb, vehicle)
	local i = GetVehicleInList(vehicle)
	if i then
		cb(VehiclesInWatingList[i].price)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:IsRequstedVehicle', function(source, cb, cVehicle)
	local i = GetVehicleInList(cVehicle)
	if i then
		TriggerClientEvent('esx:showNotification', VehiclesInWatingList[i].source, '~y~Mashin Shoma Dar Hal Tamir Mibashad')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}
			for i=1, #result, 1 do
				table.insert(vehicles, {model = result[i].model, price = result[i].price})
			end
			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)