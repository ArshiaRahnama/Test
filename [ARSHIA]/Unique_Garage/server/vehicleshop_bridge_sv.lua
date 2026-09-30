-- FIX: this whole file is new. /addcar, /addcargang, ChangeCarPlate and
-- RemoveCar (client/addcar_cl.lua) - plus the esx_giveownedcar remote flow
-- (client/removecar_cl.lua) - all TriggerServerEvent a set of
-- 'esx_vehicleshop:*' / 'esx_giveownedcar:*' events that used to be handled
-- by the old esx_vehicleshop resource. That resource doesn't exist anywhere
-- in this codebase anymore (replaced by Unique_vehicleshop), so none of
-- these events had ANY listener - every one of these admin features was a
-- complete no-op: the client-side vehicle got customized/deleted, an admin
-- saw a "success" Discord log, but nothing was ever actually written to the
-- database, so the target player never really owned the car.
--
-- These handlers write to the same `owned_vehicles` table, in the same
-- shape (owner/plate/vehicle/type/stored), that Unique_vehicleshop's own
-- purchase flow uses (see Unique_vehicleshop/shared/server.lua,
-- registerPurchasedVehicle) - and hand over the same 'vehicle_keys'
-- inventory item that Unique_Garage's own lock system
-- (server/carlock_sv.lua) expects, so a car given this way behaves exactly
-- like one bought normally: it shows up in the owner's garage, and they can
-- lock/unlock/retrieve it the normal way.
--
-- Every handler re-checks admin permission (permission_level >= 10) itself,
-- server-side, rather than trusting that only the /addcar-family commands
-- ever trigger them - RegisterServerEvent handlers are reachable by anyone
-- who fires the event name directly, chat command or not.

local function isAdmin(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer ~= nil and (xPlayer.permission_level or 0) >= 10
end

-- Used by addDonationCar (admin gives a car to a specific player).
RegisterServerEvent('esx_vehicleshop:setVehicleOwnedscaryPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedscaryPlayerId', function(newOwner, vehicleProps)
	local src = source
	if not isAdmin(src) then return end

	local xTarget = ESX.GetPlayerFromId(tonumber(newOwner))
	if not xTarget then return end
	if type(vehicleProps) ~= 'table' or type(vehicleProps.plate) ~= 'string' or vehicleProps.plate == '' then return end

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, 1)', {
		['@owner']   = xTarget.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type']    = 'car',
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			xTarget.addInventoryItem('vehicle_keys', 1, nil, { plate = vehicleProps.plate, label = 'Keys: ' .. vehicleProps.plate })
			TriggerClientEvent('esx:showNotification', xTarget.source, 'Yek Mashin Az Taraf Admin Be Shoma Dade Shod!', 'success')
		else
			TriggerClientEvent('esx:showNotification', src, '~r~Sabt Dar Database Movafagh Nabood (Plak Tekrari?)', 'error')
		end
	end)
end)

-- Used by addGangCar (admin gives a car to a gang).
RegisterServerEvent('esx_vehicleshop:setVehicleGang')
AddEventHandler('esx_vehicleshop:setVehicleGang', function(gangName, vehicleProps)
	local src = source
	if not isAdmin(src) then return end
	if type(gangName) ~= 'string' or gangName == '' then return end
	if type(vehicleProps) ~= 'table' or type(vehicleProps.plate) ~= 'string' or vehicleProps.plate == '' then return end
	if ESX.DoesGangExist and not ESX.DoesGangExist(gangName, 1) then return end

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, 1)', {
		['@owner']   = gangName,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type']    = 'car',
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			TriggerClientEvent('esx:showNotification', src, 'Mashin Be Gang ~y~' .. gangName .. ' ~s~Eshafe Shod!', 'success')
		else
			TriggerClientEvent('esx:showNotification', src, '~r~Sabt Dar Database Movafagh Nabood (Plak Tekrari?)', 'error')
		end
	end)
end)

-- Used by ChangeCarPlate.
RegisterServerEvent('esx_vehicleshop:ChangeVehiclePlate')
AddEventHandler('esx_vehicleshop:ChangeVehiclePlate', function(vehicleProps, oldPlate)
	local src = source
	if not isAdmin(src) then return end
	if type(vehicleProps) ~= 'table' or type(vehicleProps.plate) ~= 'string' or vehicleProps.plate == '' then return end
	if type(oldPlate) ~= 'string' or oldPlate == '' then return end

	MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newPlate, vehicle = @vehicle WHERE plate = @oldPlate', {
		['@newPlate'] = vehicleProps.plate,
		['@vehicle']  = json.encode(vehicleProps),
		['@oldPlate'] = oldPlate,
	}, function(rowsChanged)
		if not rowsChanged or rowsChanged == 0 then
			TriggerClientEvent('esx:showNotification', src, '~r~In Mashin Dar Database Peyda Nashod', 'error')
		end
	end)
end)

-- Used by RemoveCar.
RegisterServerEvent('esx_vehicleshop:DeleteVehicle')
AddEventHandler('esx_vehicleshop:DeleteVehicle', function(plate)
	local src = source
	if not isAdmin(src) then return end
	if type(plate) ~= 'string' or plate == '' then return end

	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate,
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			TriggerClientEvent('esx:showNotification', src, 'Mashin ~y~' .. plate .. ' ~s~Az Database Hazf Shod', 'success')
		else
			TriggerClientEvent('esx:showNotification', src, '~r~In Mashin Dar Database Peyda Nashod', 'error')
		end
	end)
end)

-- Used by removecar_cl.lua before spawning a plate the admin typed by hand.
ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	if type(plate) ~= 'string' or plate == '' then cb(true) return end
	MySQL.Async.fetchScalar('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate,
	}, function(result)
		cb(result ~= nil)
	end)
end)

-- Used by esx_giveownedcar:spawnVehicle / spawnVehiclePlate (removecar_cl.lua).
RegisterServerEvent('esx_giveownedcar:setVehicle')
AddEventHandler('esx_giveownedcar:setVehicle', function(vehicleProps, playerID, vehicleType)
	local src = source
	if not isAdmin(src) then return end

	local xTarget = ESX.GetPlayerFromId(tonumber(playerID))
	if not xTarget then return end
	if type(vehicleProps) ~= 'table' or type(vehicleProps.plate) ~= 'string' or vehicleProps.plate == '' then return end

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (@owner, @plate, @vehicle, @type, 1)', {
		['@owner']   = xTarget.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@type']    = vehicleType or 'car',
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			xTarget.addInventoryItem('vehicle_keys', 1, nil, { plate = vehicleProps.plate, label = 'Keys: ' .. vehicleProps.plate })
			TriggerClientEvent('esx:showNotification', xTarget.source, 'Yek Mashin Az Taraf Admin Be Shoma Dade Shod!', 'success')
		else
			TriggerClientEvent('esx:showNotification', src, '~r~Sabt Dar Database Movafagh Nabood (Plak Tekrari?)', 'error')
		end
	end)
end)

RegisterServerEvent('esx_giveownedcar:printToConsole')
AddEventHandler('esx_giveownedcar:printToConsole', function(msg)
	if not isAdmin(source) then return end
	print(('^3[Unique_Garage:giveownedcar]^7 %s'):format(tostring(msg)))
end)
