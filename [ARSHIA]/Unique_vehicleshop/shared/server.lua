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
-- BUGFIX (same root cause as rent_server.lua's earlier crash): the loop
-- below only runs once it's scheduled on a later tick, not the instant
-- CreateThread is called - so anything at this file's own top level that
-- runs before that (like the ESX.RegisterServerCallback further down) could
-- still see ESX as nil. Try a synchronous fetch first - essentialmode is a
-- hard dependency, so it's already running and its esx:getSharedObject
-- handler already registered by the time this file loads, meaning this
-- resolves immediately, in the same tick, before anything below runs. The
-- CreateThread loop stays as a fallback only, in case that assumption is
-- ever wrong.
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
if not ESX then
	CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Wait(0)
		end
	end)
end

-- Build the real price/category/currency lookup once, so we don't loop through all of Config.Vehicles every time
local VehiclePriceByModel   = {}
local VehicleCategoryByModel = {}
local VehicleCurrencyByModel = {} -- 'cash' (default) or 'coin' - see Config.Vehicles["exclusive"]

CreateThread(function()
	for category, vehicles in pairs(Config.Vehicles) do
		for _, v in pairs(vehicles) do
			VehiclePriceByModel[v.name]    = v.price
			VehicleCategoryByModel[v.name] = category
			VehicleCurrencyByModel[v.name] = v.currency or 'cash'
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

-- Shared final step for every purchase: registers the vehicle in
-- owned_vehicles (already `stored` - every purchase goes straight to a
-- garage now, nothing is physically spawned at the shop) and hands over its
-- key item. `owner` is the buyer's own identifier, unless `toGang` was true
-- AND they're actually in a gang server-side (xPlayer.gang.name checked here,
-- never trusted from the client), in which case it's their gang's name
-- instead - Unique_Garage/CarLock (server.lua / carlock_sv.lua) already
-- recognize either form via "(owner = @player OR LOWER(owner) = @gang)", so
-- nothing there needs to change for this to just work.
--
-- `onFail` is called (not returned - MySQL.Async.execute's callback is
-- async, so a plain return value here would never reach the caller) if the
-- DB insert itself fails, so each currency branch below can refund exactly
-- what it actually took.
local function registerPurchasedVehicle(xPlayer, src, props, shop, toGang, onFail)
	local owner = xPlayer.identifier
	local deliveredToGang = toGang and xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang'
	if deliveredToGang then
		owner = xPlayer.gang.name
	end

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, @stored)', {
		['@owner']   = owner,
		['@plate']   = props.plate,
		['@vehicle'] = json.encode(props),
		['@type']    = shop.type or 'car',
		['@stored']  = 1,
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			-- Hand over the actual key item so Unique_Garage's lock system
			-- (carlock_sv.lua / parkmeter_sv.lua) recognizes this plate as owned
			-- and lets the player lock/unlock it later. Same convention used
			-- everywhere else: a 'vehicle_keys' item carrying info.plate.
			xPlayer.addInventoryItem('vehicle_keys', 1, nil, { plate = props.plate, label = 'Keys: ' .. props.plate })
			TriggerClientEvent('esx:showNotification', src, deliveredToGang and Config.lang.deliveredGang or Config.lang.deliveredPersonal, 'success')
			-- Nothing was ever spawned client-side - this just deletes the
			-- showroom preview and puts the player back at the shop coord
			-- (same handler used for every other failure/cleanup path).
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		else
			onFail()
		end
	end)
end

-- Lets the client know whether to even ask "personal or gang?" - and, if so,
-- what to call the gang option. Read-only, no side effects; the actual
-- gang used at purchase time is re-checked server-side again regardless
-- (see registerPurchasedVehicle above), so there's nothing to trust here
-- beyond what to show in the dialog.
ESX.RegisterServerCallback('Unique_vehicleshop:getGangName', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'nogang' then
		cb(xPlayer.gang.name)
	else
		cb(nil)
	end
end)

RegisterNetEvent('Unique_vehicleshop:buyvehicle', function(props, modelName, shopId, toGang)
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
	local currency = VehicleCurrencyByModel[modelName] or 'cash'
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

	-- Every purchase goes straight into a garage now (see
	-- registerPurchasedVehicle) instead of being physically spawned at the
	-- shop. Config.DeliveryFee still applies for the boat/heli/plane shops on
	-- top of the vehicle's own price (0 for the car shop, which never had one).
	local deliveryFee = Config.DeliveryFee[shop.type] or 0

	-- 5) Money/Coin check and deduction is fully server-side, using the real config price (not whatever the client sent)
	-- Cash checks below use canAfford()/payAny() (cash + bank combined, drawing
	-- from cash first and covering any shortfall from bank), not the plain
	-- money field/removeMoney() - so a purchase still goes through even if the
	-- player is short on hand cash, as long as their bank covers the rest.
	if currency == 'coin' then
		-- The delivery fee is still real cash even for a Coin-priced vehicle -
		-- checked up front so a Coin deduction below never happens only for the
		-- cash part to then fail.
		if deliveryFee > 0 and not xPlayer.canAfford(deliveryFee) then
			TriggerClientEvent('esx:showNotification', src, Config.lang.nomoney, 'error')
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
			return
		end

		-- Atomic: the WHERE clause re-checks the balance at the moment of the
		-- write, so two rapid purchase attempts can't both pass an earlier
		-- separate check and overdraw the same Coin balance.
		MySQL.Async.execute('UPDATE users SET coin = coin - @price WHERE identifier = @identifier AND coin >= @price', {
			['@price']      = price,
			['@identifier'] = xPlayer.identifier,
		}, function(rowsChanged)
			if not rowsChanged or rowsChanged == 0 then
				TriggerClientEvent('esx:showNotification', src, Config.lang.nocoin, 'error')
				TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
				return
			end

			-- Unique_LevelQuest owns the Coin HUD display; this just tells it
			-- to re-read the users.coin column we just updated (same event it
			-- uses internally after its own AddCoin/RemoveCoin).
			TriggerEvent('Coin-System:LoadCoin2', src)

			if deliveryFee > 0 then
				xPlayer.payAny(deliveryFee)
			end

			registerPurchasedVehicle(xPlayer, src, props, shop, toGang, function()
				-- DB insert failed - refund exactly what this branch took.
				-- (The cash portion is refunded as plain cash rather than
				-- split back across cash/bank exactly as it was paid - a
				-- fine trade-off for what should be a rare failure path.)
				MySQL.Async.execute('UPDATE users SET coin = coin + @price WHERE identifier = @identifier', {
					['@price'] = price, ['@identifier'] = xPlayer.identifier,
				})
				TriggerEvent('Coin-System:LoadCoin2', src)
				if deliveryFee > 0 then xPlayer.addMoney(deliveryFee) end
				TriggerClientEvent('esx:showNotification', src, 'Failed to register vehicle, amount refunded', 'error')
				TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
			end)
		end)
	else
		local total = price + deliveryFee
		if not xPlayer.canAfford(total) then
			TriggerClientEvent('esx:showNotification', src, Config.lang.nomoney, 'error')
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
			return
		end

		xPlayer.payAny(total)

		registerPurchasedVehicle(xPlayer, src, props, shop, toGang, function()
			-- Same trade-off noted above: refunded as plain cash.
			xPlayer.addMoney(total)
			TriggerClientEvent('esx:showNotification', src, 'Failed to register vehicle, amount refunded', 'error')
			TriggerClientEvent('Unique_vehicleshop:deletevehicle', src)
		end)
	end
end)
