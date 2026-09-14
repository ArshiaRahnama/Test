ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

TriggerEvent('chat:addSuggestion', '/removecar', 'Hazf Mashin Az Database', {
	{ name="Plak", help="Plak Ro Hatman Vared Konid!" }
})

RegisterNetEvent('esx_giveownedcar:spawnVehicle')
AddEventHandler('esx_giveownedcar:spawnVehicle', function(playerID, model, playerName, type, vehicleType)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local carExist  = false

	ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle)
		if DoesEntityExist(vehicle) then
			carExist = true
			SetEntityVisible(vehicle, false, false)
			SetEntityCollision(vehicle, false)

			local newPlate     = exports.esx_vehicleshop:GeneratePlate()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
			TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID, vehicleType)
			ESX.Game.DeleteVehicle(vehicle)
			if type ~= 'console' then
				ESX.ShowNotification(_U('gived_car', model, newPlate, playerName))
			else
				local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end
		end
	end)

	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car', model))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
		end
	end
end)

RegisterNetEvent('esx_giveownedcar:spawnVehiclePlate')
AddEventHandler('esx_giveownedcar:spawnVehiclePlate', function(playerID, model, plate, playerName, type, vehicleType)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local generatedPlate = string.upper(plate)
	local carExist  = false

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
		if not isPlateTaken then
			ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle)
				if DoesEntityExist(vehicle) then
					carExist = true
					SetEntityVisible(vehicle, false, false)
					SetEntityCollision(vehicle, false)

					local newPlate     = string.upper(plate)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					vehicleProps.plate = newPlate
					TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID, vehicleType)
					ESX.Game.DeleteVehicle(vehicle)
					if type ~= 'console' then
						ESX.ShowNotification(_U('gived_car',  model, newPlate, playerName))
					else
						local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
						TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
					end
				end
			end)
		else
			carExist = true
			if type ~= 'console' then
				ESX.ShowNotification(_U('plate_already_have'))
			else
				local msg = ('ERROR: this plate is already been used on another vehicle')
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end
		end
	end, generatedPlate)

	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car', model))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
		end
	end
end)

Locales['en'] = {
['gived_car'] = 'Vehicle ~y~%s ~s~with plate number ~y~ %s ~s~has been park into ~g~%s~s~\'s garage',
['received_car'] = 'Plak Mashin:  ~y~%s',
['del_car'] = 'Mashin Ba Plak ~y~%s ~s~ Hazf Shod',
['del_car_error'] = '~r~Mashin Ba Plak ~y~%s~r~ Peyda Nashod!!!',
['unknown_car'] = '~r~Modele Mahsin Peyda Nashod ~y~%s',
['plate_already_have'] = '~r~In Plak Vojood Darad!!',

}