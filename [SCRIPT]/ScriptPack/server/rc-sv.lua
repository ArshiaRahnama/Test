ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- /removecar lives in Unique_Garage/server/removecar_sv.lua (duplicate removed)

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