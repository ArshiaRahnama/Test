-- FIX: this file used exports.esx_vehicleshop:GeneratePlate() and
-- 'esx_vehicleshop:setVehicleOwnedscaryPlayerId' / 'setVehicleGang' /
-- 'ChangeVehiclePlate' / 'DeleteVehicle' - a resource that doesn't exist
-- anywhere in this codebase (replaced by Unique_vehicleshop, which never
-- got any of these). The exports call errored outright (aborting the whole
-- handler before anything else ran), and even where a plate was given
-- manually, the server events had no listener - so /addcar, /addcargang,
-- ChangeCarPlate and RemoveCar were all complete no-ops. The four server
-- events now have real handlers in server/vehicleshop_bridge_sv.lua; this
-- file just needs its own working plate generator.
local function GenerateRandomPlateFallback()
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local plate = ""
	for i = 1, 8 do
		local idx = math.random(1, #chars)
		plate = plate .. chars:sub(idx, idx)
	end
	return plate
end

RegisterNetEvent('addDonationCar')
AddEventHandler('addDonationCar', function(newOwner, plate, admin)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle == 0 then
		SafeNotify('~r~Shoma Bayad Dakhele Mashin Bashid Ta Bekhahid Be Player Bedid!')
		return
	end


	SetVehicleEngineHealth(vehicle, 1000.0)
	SetVehicleBodyHealth(vehicle, 1000.0)
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleEngineOn(vehicle, true, true, false)
	local VehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local AdminName = GetPlayerName(GetPlayerFromServerId(tonumber(admin)))
	local PlayerName = GetPlayerName(GetPlayerFromServerId(tonumber(newOwner)))
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = GenerateRandomPlateFallback()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:setVehicleOwnedscaryPlayerId', newOwner, vehicleProps)

	if newPlate == plate then
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For User\n[ Admin : " .. AdminName .. " | Player : " .. PlayerName .. "("..newOwner..") | Vehicle Name : "..VehName.." | Plate : "..newPlate.." ] \n```",'user', source, true, false)
	else
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For User\n[ Admin : " .. AdminName .. " | Player : " .. PlayerName .. "("..newOwner..") | Vehicle Name : "..VehName.." | Plate : Random ] \n```",'user', source, true, false)
	end

	TriggerServerEvent("CarLock:ToggleKey", true, newPlate)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate)
end)

RegisterNetEvent('ChangeCarPlate')
AddEventHandler('ChangeCarPlate', function(newPlate)
	local entity = ESX.Game.GetVehicleInDirection(Customize.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(), false)
	end
	if entity == 0 then
		return
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(entity)
	local oldPlate = vehicleProps.plate
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(entity, newPlate)
	local namevehicle = GetMakeNameFromVehicleModel(GetEntityModel(entity))
	TriggerServerEvent('esx_vehicleshop:ChangeVehiclePlate', vehicleProps, oldPlate)
	TriggerServerEvent("CarLock:ToggleKey", true, newPlate)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate)
end)

RegisterNetEvent('RemoveCar')
AddEventHandler('RemoveCar', function()
	local entity = ESX.Game.GetVehicleInDirection(Customize.TargetDistance)
	if entity == 0 then
		entity = GetVehiclePedIsIn(PlayerPedId(), false)
	end
	if entity == 0 then
		return
	end
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(entity))

	TriggerServerEvent('esx_vehicleshop:DeleteVehicle', oldPlate)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate)
end)

RegisterNetEvent('addGangCar')
AddEventHandler('addGangCar', function(newOwner, plate, admin)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle == 0 then
		SafeNotify('~r~Shoma Bayad Dakhele Mashin Bashid!')
		return
	end
	SetVehicleEngineHealth(vehicle, 1000.0)
	SetVehicleBodyHealth(vehicle, 1000.0)
	SetVehicleFixed(vehicle)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleEngineOn(vehicle, true, true, false)
	local VehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local AdminName = GetPlayerName(GetPlayerFromServerId(tonumber(admin)))
	local oldPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	local newPlate
	if plate then
		newPlate = plate
	else
		newPlate = GenerateRandomPlateFallback()
	end
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	vehicleProps.plate = newPlate
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehicleshop:setVehicleGang', newOwner, vehicleProps )
	if newPlate == plate then
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For Gang\n[ Admin : " .. AdminName .. " | Gang : "..newOwner.." | Vehicle Name : "..VehName.." | Plate : "..newPlate.." ]\n```",'user', source, true, false)
	else
		TriggerServerEvent('DiscordBot:ToDiscord', 'addcar', "AddCar By Admin", "```css\nAdd Car By Admin For Gang\n[ Admin : " .. AdminName .. " | Gang : "..newOwner.." | Vehicle Name : "..VehName.." | Plate : Random ]\n```",'user', source, true, false)
	end
	TriggerServerEvent("CarLock:ToggleKey", true, newPlate)
	TriggerServerEvent("CarLock:ToggleKey", false, oldPlate)
end)
