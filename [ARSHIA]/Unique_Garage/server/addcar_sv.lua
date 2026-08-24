
local ncz = false

RegisterCommand('addcar', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.permission_level < 10 then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
		return
	end

	if args[1] then
		local newOwner = tonumber(args[1])
		local plate = args[2]

		if newOwner then
			TriggerClientEvent('addDonationCar', source, newOwner, plate, source)
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Lotfan Id Vared Konid!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Lotfan Id Vared Konid!")
	end
end, false)

RegisterCommand('addcargang', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.permission_level < 10 then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma ^1Admin ^0nistid!")
		return
	end

	if args[1] and ESX.DoesGangExist(args[1], 1) then
		local plate = args[2]
		TriggerClientEvent('addGangCar', source, args[1], plate, source)
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Esm Gang Ro Dorost Vared Konid!")
	end
end, false)

RegisterCommand('ncz', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.permission_level < 9 then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Shoma ^8Admin ^0Nistid!")
		return
	end

	ncz = not ncz
	TriggerClientEvent('esx:ncz', -1, ncz)
	if ncz then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "NCZ Enabled!")
		TriggerClientEvent("chat:addMessage", -1, { template = '<div style="padding: 0.5vw; margin: 0.7vw; background-color: rgba(205, 216, 100, 0.6); border-radius: 3px;"><i class="fa fa-newspaper-o"></i> SafeMode:<br> Halat SafeMode Faal Shod!</div>', args = {"Console", ""}})
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "NCZ Disabled!")
		TriggerClientEvent("chat:addMessage", -1, { template = '<div style="padding: 0.5vw; margin: 0.7vw; background-color: rgba(205, 216, 100, 0.6); border-radius: 3px;"><i class="fa fa-newspaper-o"></i> SafeMode:<br> Halat SafeMode GheyreFaal Shod!</div>', args = {"Console", ""}})
	end
end, false)
