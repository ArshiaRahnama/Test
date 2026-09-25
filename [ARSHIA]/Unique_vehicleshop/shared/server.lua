------------------------------------------------------------------------------------
-- Unique_vehicleshop - hardened backend build (based on Debux_vehicleshop)
-- Changes vs the original:
--  1) Price is no longer trusted from the client; the server looks up the real
--     price from Config.Vehicles itself. (The original trusted the client's
--     price variable, so anyone could buy a car for free/cheap by editing it.)
--  2) The purchased shop (shopId) is also validated server-side against
--     Config.vehicleshop, instead of blindly trusting the client's sellectcar table.
--  3) Every shop has a Config.vehicleshop[id].minRank; if the player's
--     permission_level is below it, the purchase is rejected (useful for staff/test shops).
--  4) SQL queries are parameterized (instead of string concat) to prevent SQL Injection.
--  5) Uses oxmysql (installed on this server), not mysql-async.
------------------------------------------------------------------------------------

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

-- Build the real price/category lookup once, so we don't loop through all of Config.Vehicles every time
local VehiclePriceByModel   = {}
local VehicleCategoryByModel = {}

CreateThread(function()
	for category, vehicles in pairs(Config.Vehicles) do
		for _, v in pairs(vehicles) do
			VehiclePriceByModel[v.name]    = v.price
			VehicleCategoryByModel[v.name] = category
		end
	end
end)

local function categoryAllowedForShop(shop, category)
	for _, c in ipairs(shop.categories or {}) do
		if c == category then return true end
	end
	return false
end

local function log(msg)
	print(('^3[Unique_vehicleshop]^7 %s'):format(msg))
end

RegisterNetEvent('Unique_vehicleshop:buyvehicle', function(props, modelName, shopId)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer == nil then return end

	-- 1) The shop must actually exist in the server config
	local shop = Config.vehicleshop[shopId]
	if not shop then
		log(('%s tried to buy with an invalid shopId (%s)'):format(xPlayer.identifier, tostring(shopId)))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- 2) The player's rank/permission level must meet this shop's minimum rank (Config.vehicleshop[id].minRank)
	local permission_level = xPlayer.permission_level or 0
	if permission_level < (shop.minRank or 0) then
		log(('%s (permission_level %s) tried to buy at shop %s without enough rank'):format(xPlayer.identifier, tostring(permission_level), tostring(shopId)))
		TriggerClientEvent('esx:showNotification', src, Config.lang.noperm, 'error')
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- 3) The vehicle model must be in this shop's own price list (e.g. the boat shop shouldn't be able to sell cars)
	local price = VehiclePriceByModel[modelName]
	local category = VehicleCategoryByModel[modelName]
	if not price or not categoryAllowedForShop(shop, category) then
		log(('%s tried to buy an invalid model / one outside this shop\'s category (%s)'):format(xPlayer.identifier, tostring(modelName)))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- 4) The vehicle data (color/model/etc.) must be a valid table
	if type(props) ~= 'table' or type(props.plate) ~= 'string' or props.plate == '' then
		log(('%s sent invalid vehicle data'):format(xPlayer.identifier))
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	-- 5) Money check and deduction is fully server-side, using the real config price (not whatever the client sent)
	if xPlayer.getMoney() < price then
		TriggerClientEvent('esx:showNotification', src, Config.lang.nomoney, 'error')
		TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		return
	end

	xPlayer.removeMoney(price)

	-- 6) Safe (parameterized) insert into owned_vehicles - matches your database table structure exactly
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
		['@owner']   = xPlayer.identifier,
		['@plate']   = props.plate,
		['@vehicle'] = json.encode(props),
		['@type']    = shop.type or 'car',
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			-- Hand over the actual key item so Unique_Garage's lock system
			-- (carlock_sv.lua / parkmeter_sv.lua) recognizes this plate as owned
			-- and lets the player lock/unlock it later. Same convention used
			-- everywhere else: a 'vehicle_keys' item carrying info.plate.
			xPlayer.addInventoryItem('vehicle_keys', 1, nil, { plate = props.plate, label = 'Keys: ' .. props.plate })
			TriggerClientEvent('esx:showNotification', src, Config.lang.buyvehicle, 'success')
		else
			-- If the database insert fails, refund the player so they don't lose money
			xPlayer.addMoney(price)
			TriggerClientEvent('esx:showNotification', src, 'Failed to register vehicle, amount refunded', 'error')
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		end
	end)
end)
