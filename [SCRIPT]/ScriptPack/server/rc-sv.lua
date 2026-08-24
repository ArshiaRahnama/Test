ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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
				TriggerClientEvent('esx:showNotification', source, _U('del_car', plate))
			elseif result == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('del_car_error', plate))
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

Locales['en'] = {
['gived_car'] = 'Vehicle ~y~%s ~s~with plate number ~y~ %s ~s~has been park into ~g~%s~s~\'s garage',
['received_car'] = 'Plak Mashin:  ~y~%s',
['del_car'] = 'Mashin Ba Plak ~y~%s ~s~ Hazf Shod',
['del_car_error'] = '~r~Mashin Ba Plak ~y~%s~r~ Peyda Nashod!!!',
['unknown_car'] = '~r~Modele Mahsin Peyda Nashod ~y~%s',
['plate_already_have'] = '~r~In Plak Vojood Darad!!',

}