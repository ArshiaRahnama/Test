ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

RegisterServerEvent('esx_vehicleshop:RemoveCar2')
AddEventHandler("esx_vehicleshop:RemoveCar2", function()

RemoveOwnedVehicle()

end)

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end


	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
end)

RegisterCommand('forceloadvehicles', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.permission_level >= 10 then
		Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
		local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

		for i=1, #vehicles, 1 do
			local vehicle = vehicles[i]

			for j=1, #Categories, 1 do
				if Categories[j].name == vehicle.category then
					vehicle.categoryLabel = Categories[j].label
					break
				end
			end

			table.insert(Vehicles, vehicle)
		end


		TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
		TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
	end
end, false)

RegisterServerEvent('esx_vehicleshop:setVehicle2Owned')
AddEventHandler('esx_vehicleshop:setVehicle2Owned', function (vehicleProps, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local found = false

	for i = 1, #Vehicles, 1 do
        if GetHashKey(Vehicles[i].model) == vehicleProps.model then
            vehicleData = Vehicles[i]
			found = true
            break
        end
    end

	if found and xPlayer.canAfford(vehicleData.price) then
		xPlayer.payAny(vehicleData.price)
		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, job, type, stored, engine, fuel, body) VALUES (@owner, @plate, @vehicle, @job, @type, @stored, @engine, @fuel, @body)',
		{
			['@owner']   = society or xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@job']	 = society and 'gang' or '',
			['@type']    = 'car',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))
			if society == nil then
				TriggerEvent('DiscordBot:ToDiscord', 'buycar', "Buy Car", "```css\nVehicle Buy\nPlayer : " .. xPlayer.name .. "\nVehicle Name : "..vehicleData.name.."\nPrice : $"..vehicleData.price.."\nPlate : "..vehicleProps.plate.."```", 'user', true, _source, false)
			else
				TriggerEvent('DiscordBot:ToDiscord', 'buycar', "Buy Car", "```css\nVehicle Buy\nPlayer : " .. xPlayer.name .. "\nVehicle Name : "..vehicleData.name.."\nPrice : $"..vehicleData.price.."\nPlate : "..vehicleProps.plate.."\nBaraye Gang : "..society.."```", 'user', true, _source, false)
			end
		end)
	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		Wait(500)

	end

end)

AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId-server', function (playerId, vehicleProps)

	local xPlayer = ESX.GetPlayerFromId(playerId)

	if true then



		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, steamowned, plate, vehicle, type, job, stored, engine, fuel, body) VALUES (@owner, @steamowned, @plate, @vehicle, @type, @job, @stored, @engine, @fuel, @body)',
		{
			['@owner']   = xPlayer.identifier,
			['@steamowned']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@type']    = 'car',
			['@job']     = '',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))

		end)

	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		Wait(500)

	end

end)

AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId-server-gang', function (gangName, vehicleProps)

	if true then



		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, job, type, stored, engine, fuel, body) VALUES (@owner, @plate, @vehicle, @job, @type, @stored, @engine, @fuel, @body)',
		{
			['@owner']   = gangName,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@job'] = 'gang',
			['@type']    = 'car',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
		end)

	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		Wait(500)

	end

end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedscaryPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedscaryPlayerId', function (playerId, vehicleProps)
	local _source = source

	local xPlayerS = ESX.GetPlayerFromId(_source)
	if not GetPlayerName(playerId) then return end
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayerS.permission_level >= 8 then

		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, steamowned, plate, vehicle, type, job, stored, engine, fuel, body) VALUES (@owner, @steamowned, @plate, @vehicle, @type, @job, @stored, @engine, @fuel, @body)',
		{
			['@owner']   = xPlayer.identifier,
			['@steamowned']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@type']    = 'car',
			['@job']     = '',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		}, function (rowsChanged)
			if rowsChanged and rowsChanged > 0 then
				TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
			else
				TriggerClientEvent('esx:showNotification', _source, 'Error: this plate ('..vehicleProps.plate..') is already registered to a vehicle. Nothing was added.')
			end
		end)

	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		Wait(500)

	end

end)

RegisterServerEvent('esx_vehicleshop:setVehicleGang')
AddEventHandler('esx_vehicleshop:setVehicleGang', function (gangName, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayerS = ESX.GetPlayerFromId(_source)

	if xPlayerS.permission_level >= 10 then
		MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, job, type, stored, engine, fuel, body) VALUES (@owner, @plate, @vehicle, @job, @type, @stored, @engine, @fuel, @body)',
		{
			['@owner']   = gangName,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@job']	 = 'gang',
			['@type']    = 'car',
			['@stored']  = 1,
			['@engine']  = 1000,
			['@fuel']    = 100,
			['@body']    = 1000,
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs_gang', vehicleProps.plate))

		end)
	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		print(('esx_vehicleshop: %s attempted to inject vehicle!'):format(xPlayer.identifier))
	end

end)

RegisterServerEvent('esx_vehicleshop:sellVehicle')
AddEventHandler('esx_vehicleshop:sellVehicle', function (vehicle)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id = result[1].id

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})
	end)
end)

RegisterServerEvent('esx_vehicleshop:addToList')
AddEventHandler('esx_vehicleshop:addToList', function(target, model, plate)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
	local dateNow = os.date('%Y-%m-%d %H:%M')

	if xPlayer.job.name ~= 'cardealer' then
		print(('esx_vehicleshop: %s attempted to add a sold vehicle to list!'):format(xPlayer.identifier))
		return
	end

	MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
		['@client'] = xTarget.getName(),
		['@model'] = model,
		['@plate'] = plate,
		['@soldby'] = xPlayer.getName(),
		['@date'] = dateNow
	})
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function (source, cb)

	MySQL.Async.fetchAll('SELECT * FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:rentVehicle')
AddEventHandler('esx_vehicleshop:rentVehicle', function (vehicle, plate, playerName, basePrice, rentPrice, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicle
	}, function (result)
		local id    = result[1].id
		local price = result[1].price
		local owner = xPlayer.identifier

		MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
			['@id'] = id
		})

		MySQL.Async.execute('INSERT INTO rented_vehicles (vehicle, plate, player_name, base_price, rent_price, owner) VALUES (@vehicle, @plate, @player_name, @base_price, @rent_price, @owner)',
		{
			['@vehicle']     = vehicle,
			['@plate']       = plate,
			['@player_name'] = playerName,
			['@base_price']  = basePrice,
			['@rent_price']  = rentPrice,
			['@owner']       = owner
		})
	end)
end)

RegisterServerEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function (itemName, count)

end)

RegisterServerEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function (itemName, count)

end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function (source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	cb(xPlayer.canAfford(vehicleData.price))
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicleSociety', function (source, cb, society, vehicleModel)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function (account)
		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicleData.model,
				['@price']   = vehicleData.price
			}, function(rowsChanged)
				cb(true)
			end)

		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function (source, cb)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name  = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)

RegisterServerEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function (result)

		if result[1] then
			local id    = result[1].id
			local price = ESX.Math.Round(result[1].price * 0.75)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_sold_for', vehicleModel, ESX.Math.GroupDigits(price)))
		else

			print(('esx_vehicleshop: %s attempted selling an invalid vehicle!'):format(GetPlayerIdentifiers(_source)[1]))
		end

	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getRentedVehicles', function (source, cb)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles ORDER BY player_name ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name       = result[i].vehicle,
				plate      = result[i].plate,
				playerName = result[i].player_name
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:giveBackVehicle', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] ~= nil then
			local vehicle   = result[1].vehicle
			local basePrice = result[1].base_price

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)', {
				['@vehicle'] = vehicle,
				['@price']   = basePrice
			})

			MySQL.Async.execute('DELETE FROM rented_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})

			RemoveOwnedVehicle(plate)
			cb(true)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function (source, cb, plate, model, name)
	local resellPrice = 0


	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		cb(false)

	else

		local xPlayer = ESX.GetPlayerFromId(source)
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = plate
		}, function (result)
			if result[1] then
				local vehicle = json.decode(result[1].vehicle)

				if vehicle.model == model then
					if vehicle.plate == plate then
						xPlayer.addMoney(resellPrice)
						RemoveOwnedVehicle(plate)
						TriggerEvent('DiscordBot:ToDiscord', 'sellcar', "Sell Car", "```css\nVehicle Sell\nPlayer : " .. xPlayer.name .. "\nVehicle Name : "..name.."\nPrice : $"..resellPrice.."\nPlate : "..plate.."```", 'user', true, _source, false)
						cb(true)
					else
						cb(false)

					end
				else
					cb(false)

				end
			else
				cb(false)
			end
		end)

	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function (source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function (source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function (result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_vehicleshop: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM rented_vehicles', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)


			if xPlayer ~= nil then
				xPlayer.removeBank(result[i].rent_price)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rental', ESX.Math.GroupDigits(result[i].rent_price)))
			else
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier',
				{
					['@bank']       = result[i].rent_price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(result[i].rent_price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 00, PayRent)
