

RegisterCommand('removecar', function(source, args)
		local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level >= 10 then
            if xPlayer.get("aduty") then
		if args[1] == nil then
			TriggerClientEvent('esx:showNotification', source, '~r~Baraye Hazf Mashin Plak Ro Varek Konid!!')
		else
			local plate = args[1]
			if #args > 1 then
				for i=2, #args do
					plate = plate.." "..args[i]
				end
			end
			plate = string.upper(plate)

			local result = MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})
			if result == 1 then
				TriggerClientEvent('esx:showNotification', source, string.format('Mashin Ba Plak ~y~%s ~s~ Hazf Shod', plate))
			elseif result == 0 then
				TriggerClientEvent('esx:showNotification', source, string.format('~r~Mashin Ba Plak ~y~%s~r~ Peyda Nashod!!!', plate))
			end
		end
	else
		TriggerClientEvent(
			"chatMessage",
			source,
			"[SYSTEM]",
			{255, 0, 0},
			" ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
		)
	end
else
	TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
end
end)

RegisterServerEvent('esx_giveownedcar:printToConsole')
AddEventHandler('esx_giveownedcar:printToConsole', function(msg)
	print(msg)
end)

RegisterCommand('givecar', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.permission_level < 10 then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
		return
	end

	local targetId = tonumber(args[1])
	local model = args[2]

	if not targetId or not model then
		TriggerClientEvent('esx:showNotification', source, '~r~Estefade: /givecar [id] [model]')
		return
	end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		TriggerClientEvent('esx:showNotification', source, '~r~Player Peyda Nashod!')
		return
	end

	local playerName = GetPlayerName(targetId)
	TriggerClientEvent('esx_giveownedcar:spawnVehicle', source, targetId, model, playerName, 'command', 'car')
end, false)

RegisterServerEvent('esx_giveownedcar:setVehicle')
AddEventHandler('esx_giveownedcar:setVehicle', function(vehicleProps, playerID, vehicleType)
	local xTarget = ESX.GetPlayerFromId(playerID)
	if not xTarget then
		TriggerClientEvent('esx:showNotification', source, '~r~Player Peyda Nashod!')
		return
	end
	if not vehicleProps or not vehicleProps.plate then
		return
	end

	MySQL.Async.execute('INSERT IGNORE INTO owned_vehicles (owner, plate, vehicle, type, job, stored, engine, fuel, body) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
		xTarget.identifier,
		vehicleProps.plate,
		json.encode(vehicleProps),
		vehicleType or 'car',
		'',
		1,
		1000,
		100,
		1000,
	}, function(rowsChanged)
		if rowsChanged and rowsChanged > 0 then
			TriggerClientEvent('esx:showNotification', source, string.format('Mashin Ba Plak ~y~%s ~s~Sabt Shod', vehicleProps.plate))
		else
			TriggerClientEvent('esx:showNotification', source, string.format('~r~In Plak (~y~%s~r~) Ghablan Sabt Shode!', vehicleProps.plate))
		end
	end)
end)

