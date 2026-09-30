-- FIX: used exports.esx_vehicleshop:GeneratePlate() - a resource that
-- doesn't exist anywhere in this codebase (replaced by Unique_vehicleshop,
-- which never got that export), so this errored and aborted the handler.
-- The 'esx_giveownedcar:setVehicle' event and 'esx_vehicleshop:isPlateTaken'
-- callback used below also had no listener anywhere (same root cause);
-- both now have real handlers in server/vehicleshop_bridge_sv.lua.
local function GenerateRandomPlateFallback()
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local plate = ""
	for i = 1, 8 do
		local idx = math.random(1, #chars)
		plate = plate .. chars:sub(idx, idx)
	end
	return plate
end

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

			local newPlate     = GenerateRandomPlateFallback()
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			vehicleProps.plate = newPlate
			TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID, vehicleType)
			ESX.Game.DeleteVehicle(vehicle)
			if type ~= 'console' then
				SafeNotify(string.format('Vehicle ~y~%s ~s~with plate number ~y~ %s ~s~has been park into ~g~%s~s~\'s garage', model, newPlate, playerName))
			else
				local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end
		end
	end)

	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			SafeNotify(string.format('~r~Modele Mahsin Peyda Nashod ~y~%s', model))
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
						SafeNotify(string.format('Vehicle ~y~%s ~s~with plate number ~y~ %s ~s~has been park into ~g~%s~s~\'s garage', model, newPlate, playerName))
					else
						local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
						TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
					end
				end
			end)
		else
			carExist = true
			if type ~= 'console' then
				SafeNotify('~r~In Plak Vojood Darad!!')
			else
				local msg = ('ERROR: this plate is already been used on another vehicle')
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end
		end
	end, generatedPlate)

	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			SafeNotify(string.format('~r~Modele Mahsin Peyda Nashod ~y~%s', model))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
		end
	end
end)
