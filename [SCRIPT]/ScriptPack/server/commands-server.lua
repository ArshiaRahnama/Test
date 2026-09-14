ESX = nil;
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('es:addGroupCommand', 'info', 'user', function(source, args, user)
	if args[1] and GetPlayerPing(tonumber(args[1]))then
		TriggerClientEvent('chatMessage', source, "^8Ping ^0: ^0".. GetPlayerPing(tonumber(args[1])))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "ID Vared Nakardid Ya Dar Server Nist")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Admin Nisti Ke XD.")
end, {help = "Get Ping", params = {{name = "id", help = "ID"}}})

TriggerEvent('es:addGroupCommand', 'id', 'user', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "Your Id :", {255, 0, 0}, source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Admin Nisti Ke XD.")
end, {help = "Get Your ID"})

TriggerEvent('es:addAdminCommand', 'name', 1, function(source, args, user)
	if args[1] and GetPlayerName(tonumber(args[1]))then
		TriggerClientEvent('chatMessage', source, "^8Steam Name ^0: ^0".. GetPlayerName(tonumber(args[1])))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "ID Vared Nakardid Ya Dar Server Nist")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Admin Nisti Ke XD.")
end, {help = "Get Player Steam Name", params = {{name = "id", help = "ID"}}})

TriggerEvent('es:addAdminCommand', 'dva', 9, function(source, args, user)
	TriggerClientEvent("esx:delallscaryveh", -1)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Admin Nisti Ke XD.")
end, {help = "Delete All Veh", })

ESX.RegisterServerCallback('esx:GetAdminsInfo', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}
	local admins = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local status = xPlayer.get('aduty')
		if tonumber(xPlayer.permission_level) >= 1 then
		if status then
			its = "On-Duty"
		else
			its = "Off-Duty"
		end
			admins = admins + 1
		table.insert(players, {
			source      = xPlayer.source,
			name        = tostring(GetPlayerName(xPlayers[i])),
			perm        = tonumber(xPlayer.permission_level),
			status 		= its
		})
	end
	end
	cb(players, admins)
end)

TriggerEvent('es:addAdminCommand', 'setperm', 9, function(source, args, user)
	local tPlayerId = args[1]
    local pLevel = tonumber(args[2])
	local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(tPlayerId)

	if xPlayer.permission_level > tPlayer.permission_level and xPlayer.permission_level > tonumber(args[2]) then
		if tonumber(args[2]) <= 100 then
			tPlayer.Setperm(pLevel)
			TriggerClientEvent('chat:addMessage', tPlayerId, {color = {0, 255, 0}, args = {'[SYSTEM]', 'Level Shoma Tavasot '..GetPlayerName(source)..'('..source..') Be ' .. pLevel .. ' Taghir Yaft'}})
			TriggerClientEvent('chat:addMessage', source, {color = {0, 255, 0}, args = {'[SYSTEM]', 'Shoma Level '..GetPlayerName(tPlayerId)..'('..tPlayerId..') Ra Be ' .. pLevel .. ' Taghir Dadid'}})
			TriggerEvent('DiscordBot:ToDiscord', 'gp', 'GivePermLog', '```css\n[ Admin Name : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Admin Steam : '..GetPlayerIdentifier(source)..' ]\n[ Admin Permission : '..xPlayer.permission_level..' ]\n[ Gived Permission : ' .. pLevel .. ' ]\n[ Player Name : '..GetPlayerName(tPlayerId)..'(' .. tPlayerId .. ') ]\n[ Player Steam : '..GetPlayerIdentifier(tPlayerId).. ' ]\n[ Last Player Permission : '..tPlayer.permission_level..' ]\n```' , 'user', true, source, false)
		else
		    TriggerClientEvent('chat:addMessage', source, {color = {0, 255, 0},args = {'[SYSTEM]', 'Shoma Rank Balaye 7 Nemitonid Be Kasi Bedid'}})
		end
		TriggerClientEvent('chat:addMessage', source, {color = {0, 255, 0},args = {'[SYSTEM]', 'Shoma Rank Bala Tar Az Khod Ra Nemitonid Taghir Dahid!!'}})
	end

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Dastresi Nadari Ke xD.")
end, {help = "Set User Permission", params = {{name = "id", help = "Target Palyer ID "}, {name = "permission level", help = "Permission Level [Number]"}}})

TriggerEvent('es:addAdminCommand', 'vsetperm', 10, function(source, args, user)
	local tPlayerId = args[1]
    local pLevel = tonumber(args[2])
	local tPlayer = ESX.GetPlayerFromId(tPlayerId)

	tPlayer.Setperm(pLevel)
	TriggerClientEvent('chat:addMessage', tPlayerId, {color = {0, 255, 0}, args = {'[SYSTEM]', 'Level Shoma Tavasot Consol Be ' .. pLevel .. ' Taghir Yaft'}})
	print('Shoma Level '..GetPlayerName(tPlayerId)..'('..args[1]..') Ra Be ' .. args[2] .. ' Taghir Dadid')
	TriggerEvent('DiscordBot:ToDiscord', 'gp', 'GivePermLog', '```css\n[ Admin Name : Consol ]\n[ Admin Steam : N/A ]\n[ Admin Permission : N/A ]\n[ Gived Permission : ' .. pLevel .. ' ]\n[ Player Name : '..GetPlayerName(tPlayerId)..'(' .. tPlayerId .. ') ]\n[ Player Steam : '..GetPlayerIdentifier(tPlayerId).. ' ]\n[ Last Player Permission : '..tPlayer.permission_level..' ]\n```' , 'user', true, source, false)

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Dastresi Nadari Ke xD.")
end, {help = "Set User Permission", params = {{name = "id", help = "Target Palyer ID "}, {name = "permission level", help = "Permission Level [Number]"}}})

