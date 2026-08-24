ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	ParkAirs()
end)

function ParkAirs()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = false AND type = @type', {
		['@type'] = 'heli'
	}, function (rowsChanged)
		if rowsChanged > 0 then
			print(('esx_heli: %s air(s) have been stored!'):format(rowsChanged))
		end
	end)
end

ESX.RegisterServerCallback('esx_heli:buyAir', function(source, cb, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price   = getPriceFromModel(vehicleProps.model)


	if price == 0 then
		print(('esx_heli: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.canAfford(price) then
			xPlayer.payAny(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`) VALUES (@owner, @plate, @vehicle, @type, @stored)', {
				['@owner']   = xPlayer.identifier,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@type']    = 'heli',
				['@stored']  = true
			}, function(rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

RegisterServerEvent('esx_heli:takeOutVehicle')
AddEventHandler('esx_heli:takeOutVehicle', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = false,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_heli: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

ESX.RegisterServerCallback('esx_heli:storeVehicle', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE owner = @owner AND plate = @plate', {
		['@stored'] = true,
		['@owner']  = xPlayer.identifier,
		['@plate']  = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_heli: %s attempted to store an air they don\'t own!'):format(xPlayer.identifier))
		end

		cb(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('esx_heli:getGarage', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND type = @type AND `stored` = @stored', {
		['@owner']  = xPlayer.identifier,
		['@type']   = 'heli',
		['@stored'] = true
	}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, result[i].vehicle)
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_heli:buyAirLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canAfford(Config.LicensePrice) then
		xPlayer.payAny(Config.LicensePrice)

		TriggerEvent('esx_license:addLicense', source, 'aircraft', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

function getPriceFromModel(model)
	for k,v in ipairs(Config.Vehicles) do
		if GetHashKey(v.model) == model then
			return v.price
		end
	end

	return 0
end
