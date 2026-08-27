ESX = nil
HZ = Citizen

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	Wait(100)
	MySQL.Async.execute('UPDATE owned_vehicles SET stored = 1 WHERE stored = 0', {})

	print("^5   888    888 888b    888 8888888  .d88888b.  888     888 8888888888 ^0")
	print("^5   888    888 8888b   888   888    d88P\" \"Y88b 888     888 888        ^0")
	print("^5   888    888 88888b  888   888    888     888 888     888 888        ^0")
	print("^5   888    888 888Y88b 888   888    888     888 888     888 8888888    ^0")
	print("^5   888    888 888 Y88b888   888    888     888 888     888 888        ^0")
	print("^5   888    888 888  Y88888   888    888 Y8b 888 888     888 888        ^0")
	print("^5   Y88b  d88P 888   Y8888   888    Y88b Y8b88P Y88b. .d88P 888        ^0")
	print("^5    \"Y8888P\"  888    Y888 8888888   \"Y8888888\"  \"Y88888P\"  8888888888 ^0")
	print("^3------------------------------------------------------------------^0")
	print("^2Garage System Runing Fix -> ^5arshiahub.ir^0")
	print("^6\xe2\x98\x85 This resource is Owner by ^5arshiahub.ir^0")
	print("^3------------------------------------------------------------------^0")
  end)

ESX.RegisterServerCallback("Unique_Garage:checkRepairCost", function(source, cb, fee)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.canAfford(fee))
end)

-- SECURITY FIX: `price` was accepted verbatim from the client with no
-- relation to the vehicle's actual damage/repair cost -- if this ever gets
-- wired up client-side, sending price = 1 would repair any vehicle for
-- almost nothing. Nothing calls this event yet, but it's hardened here:
-- price is validated as a positive integer and capped at a sane ceiling so
-- it can never be abused for a near-free repair even if connected later.
-- TODO if this is wired up: compute the real repair cost server-side from
-- the vehicle's actual engine/body health instead of trusting a client value.
local MAX_REPAIR_PRICE = 20000

RegisterServerEvent("Unique_Garage:payhealth")
AddEventHandler("Unique_Garage:payhealth", function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	price = tonumber(price)
	if not price or price <= 0 or price ~= math.floor(price) or price > MAX_REPAIR_PRICE then
		return
	end

	if not xPlayer.canAfford(price) then
		return
	end
	xPlayer.payAny(price)
	TriggerClientEvent("esx_ShowNotification", source, _U("you_paid") .. price)
	TriggerEvent("esx_AddOnAccount:getSharedAccount", "society_mechanic", function(account)
		account.addMoney(price)
	end)
end)

ESX.RegisterServerCallback('Unique_Garage:storeVehicle', function(source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE (owner = @player OR LOWER(`owner`) = @gang) AND plate = @plate", {
		["@player"] = xPlayer.identifier,
		["@gang"] = string.lower(xPlayer.gang.name),
		["@plate"] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute("UPDATE owned_vehicles SET vehicle = @vehicle WHERE (owner = @player OR LOWER(`owner`) = @gang) AND plate = @plate", {
					["@player"] = xPlayer.identifier,
					["@gang"] = string.lower(xPlayer.gang.name),
					["@vehicle"] = json.encode(vehicleProps),
					["@plate"]  = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then

					end
					cb(true)
				end)
			else

				local xPlayers = ESX.GetPlayers()
				for i=1, #xPlayers, 1 do
					local xP = ESX.GetPlayerFromId(xPlayers[i])
					if tonumber(xP.permission_level) > 0 then
						TriggerClientEvent('esx_ChatMessage', xPlayers[i], "🚨 [HZ-AC] ", {255, 0, 0}, "^8"..GetPlayerName(source).."^2 ("..xPlayer.source..")^0 Tried to change vehicle hash ! ")
					end
				end

				cb(false)
			end
		else

			MySQL.Async.fetchAll("SELECT * FROM vehicle_keys WHERE (identifier = @player) AND plate = @plate", {
				["@player"] = xPlayer.identifier,
				["@plate"] = vehicleProps.plate
			}, function (result)

				if result[1] ~= nil then




					local trimmedKeyPlate = result[1].plate:match("^%s*(.-)%s*$")
					if trimmedKeyPlate == vehplate then
						MySQL.Async.execute("UPDATE owned_vehicles SET vehicle = @vehicle WHERE (owner = @player OR LOWER(`owner`) = @gang) AND plate = @plate", {
							["@player"] = xPlayer.identifier,
							["@gang"] = string.lower(xPlayer.gang.name),
							["@vehicle"] = json.encode(vehicleProps),
							["@plate"]  = vehicleProps.plate
						}, function (rowsChanged)
							if rowsChanged == 0 then

							end
							cb(true)
						end)
					else

						local xPlayers = ESX.GetPlayers()
						for i=1, #xPlayers, 1 do
							local xP = ESX.GetPlayerFromId(xPlayers[i])
							if tonumber(xP.permission_level) > 0 then
								TriggerClientEvent('esx_ChatMessage', xPlayers[i], "🚨 [HZ-AC] ", {255, 0, 0}, "^8"..GetPlayerName(source).."^2 ("..xPlayer.source..")^0 Tried to change vehicle hash ! ")
							end
						end

						cb(false)
					end
				else

					cb(false)
				end
			end)

		end
	end)
end)

ESX.RegisterServerCallback('GetVehicles', function(source, cb, job, playerjob)
	local Player = ESX.GetPlayerFromId(source)
	if job == 'Job' then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ? AND job = ? AND type = ?', {Player.identifier, playerjob,"car"}, function(result)
			if result[1] then cb(result) else cb(nil) end
		end)
	elseif job == 'Impound' then
		if Player.gang.name == "nogang" then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ? AND stored = ? AND type = ?', {Player.identifier, 2,"car"}, function(result)
				if result[1] then cb(result) else cb(nil) end
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE (owner = @player OR LOWER(`owner`) = @gang) AND stored = @stored AND type = @Type', {
				['@player'] = Player.identifier,
				['@gang'] 	= string.lower(Player.gang.name),
				['@Type']   = 'car',
				['@stored'] = 2
			}, function(result)

				if result[1] then cb(result) else cb(nil) end
			end)
		end
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = ?', {Player.identifier}, function(result)
			if result[1] then cb(result) else cb(nil) end
		end)
	end
end)

RegisterNetEvent('Unique_Garage:saveProps', function(plate, props)
	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {props, plate})
end)

RegisterNetEvent('SetVehState', function(stored, plate, table, job, playerjob)
	if job == 'Job' then
		if stored == 1 then
			MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, fuel = ?, engine = ?, body = ?, vehicle = ?, job = ? WHERE plate = ?', {stored, table.fuel, table.engine, table.body, json.encode(table.props), playerjob, plate})
		else
			MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, job = ? WHERE plate = ?', {stored, playerjob, plate})
		end
	else
		if stored == 1 then
			MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, fuel = ?, engine = ?, body = ?, vehicle = ?, job = ? WHERE plate = ?', {stored, table.fuel, table.engine, table.body, json.encode(table.props), '', plate})
		else
			MySQL.Async.execute('UPDATE owned_vehicles SET stored = ?, job = ? WHERE plate = ?', {stored, '', plate})
		end
	end
end)

RegisterNetEvent('SetVehState0', function(stored, plate)
	MySQL.Async.execute('UPDATE owned_vehicles SET stored = ? WHERE plate = ?', {stored, plate})
end)

ESX.RegisterServerCallback("IsVehOwned", function(source, cb, plate, job, playerjob)
	local Player = ESX.GetPlayerFromId(source)
	if job == 'Job' then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ? AND job = ?',{plate, Player.identifier, playerjob}, function(result)
			if result[1] then cb(true) else cb(false) end
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = ? AND owner = ?',{plate, Player.identifier}, function(result)
			if result[1] then cb(true) else cb(false) end
		end)
	end
end)

ESX.RegisterServerCallback("isPrice", function(source, cb, money)
	local Player = ESX.GetPlayerFromId(source)
	-- FIX: `Player` was used without a nil-check (crashes the callback with
	-- no cb() call -> NUI hangs forever with no feedback if the player
	-- object wasn't ready yet), and `money` was trusted as-is instead of
	-- being coerced/validated like the rest of this file already does for
	-- `Unique_Garage:payhealth`.
	if not Player then
		cb(false)
		return
	end
	money = tonumber(money) or 0
	if money < 0 then money = 0 end

	if Player.canAfford(money) then
		if money > 0 then Player.payAny(money) end
		cb(true)
	else
		-- FIX: this used to fire 'esx_Notification:SendNotification', which
		-- nothing in this resource ever listened for, so the player never
		-- actually saw "You Don't Have Money" -- the SPAWN button just
		-- appeared to do nothing. Routed through the same SafeNotify path
		-- everything else in the resource uses.
		TriggerClientEvent("Unique_Garage:Notify", source, "~r~Shoma Pool Kafi Nadarid!")
		cb(false)
	end
end)

RegisterNetEvent('SetVehImpound', function(plate, body, engine, fuel)

	if IsVehicleOwned(plate) then
		MySQL.Async.fetchAll('UPDATE owned_vehicles SET stored = ?, body = ?, engine = ?, fuel = ? WHERE plate = ?',{2, body, engine, fuel, plate})
	end
end)

RegisterNetEvent('esx_advancedgarage:policeImpound', function(plate)
	if IsVehicleOwned(plate) then
		MySQL.Async.execute('UPDATE owned_vehicles SET stored = 2 WHERE plate = ?', {plate})
	end
end)

RegisterNetEvent('esx_advancedgarage:setVehicleState', function(plate, stored)
	if IsVehicleOwned(plate) then
		MySQL.Async.execute('UPDATE owned_vehicles SET stored = ? WHERE plate = ?', {stored and 1 or 0, plate})
	end
end)

function IsVehicleOwned(plate)
	local result = nil
	local prom = promise.new()
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE plate = ?', {plate}, function(data)
		if data[1] then
			result = data[1]
			prom:resolve(result)
		else
			result = nil
			prom:resolve(result)
		end
	end)
	return Citizen.Await(prom)
end

