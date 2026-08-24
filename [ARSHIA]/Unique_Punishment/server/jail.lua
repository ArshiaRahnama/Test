ESX = nil
local sentences = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function ExemptFromAntiCheat(targetId, ms, kinds)
	if GetResourceState('UNIQUE_AC') ~= 'started' then return end
	pcall(function()
		exports['UNIQUE_AC']:ExemptPlayer(targetId, ms or 5000, kinds)
	end)
end

RegisterServerEvent('Unique_Punishment:AntiCheatExempt')
AddEventHandler('Unique_Punishment:AntiCheatExempt', function(ms, kinds)
	ExemptFromAntiCheat(source, ms, kinds)
end)

local function DecodeJailData(raw, identifier)
	if not raw or raw == '' or raw == '0' then return nil end

	local ok, data = pcall(json.decode, raw)
	if not ok or not data or not data.time or tonumber(data.time) <= 0 then return nil end

	return {
		type = data.type or 'admin',
		time = tonumber(data.time),
		unjail = data.unjail or Config.AdminJail.unjail,
		reason = data.reason or 'N/A',
	}
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT identifier, jail FROM users WHERE jail IS NOT NULL AND jail != \'\' AND jail != \'0\'')

	for i=1, #result, 1 do
		local sentence = DecodeJailData(result[i].jail, result[i].identifier)
		if sentence then
			sentences[result[i].identifier] = sentence
		end
	end
end)

local function IsJobAllowed(jobname)
	for _, job in pairs(Config.AllowedJobs) do
		if jobname == job.name then
			return true
		end
	end
	return false
end

local function PersistJail(identifier, sentence)
	MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@data']       = json.encode(sentence),
	})
end

local function ClearJail(identifier)
	MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@data']       = '0',
	})
end

RegisterServerEvent('arshia_jail:sendto')
AddEventHandler('arshia_jail:sendto',function (target, type, time, reason, unjail)
	local source = source
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local identifier = xTarget.identifier
	local sentence = {type = type, time = time, unjail = unjail, reason = reason}
	sentences[identifier] = sentence
	PersistJail(identifier, sentence)
	ExemptFromAntiCheat(target, 12000, { teleport = true, speed = true, invisibility = true })
	TriggerClientEvent('arshia_jail:SentencePlayer', target, type, time, unjail, false)
	local yPlayer = ESX.GetPlayerFromId(target)
	if type == 'faction' then
		local yPlayer = ESX.GetPlayerFromId(target)
		local zPlayer = ESX.GetPlayerFromId(source)

		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if IsJobAllowed(xPlayer.job.name) then
				TriggerClientEvent('chat:addMessage',xPlayers[i], {color = {0, 95, 254}, multiline = true ,args = {"[DISPATCH]", '^1'..yPlayer.name..'^0 tavasot ^2'..zPlayer.name..'^0 zendani shod be modat ^3'..tostring(time)..'^0 mah be dalile: ^3'..reason}})
			end
		end
	else
		TriggerClientEvent('chatMessage', -1, "[Admin Jail]", {255, 0, 0}, "^1"..GetPlayerName(target).."^0 Tavasote ^2"..GetPlayerName(source).."^0 Be Modate ^2"..time.." ^0Daghighe Jail Shod be Dalile : ^1"..reason)
	end
end)

RegisterServerEvent('arshia_jail:UpdateTime')
AddEventHandler('arshia_jail:UpdateTime',function (time)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier
	if time > 0 then
		if sentences[identifier] then
			sentences[identifier].time = time
		end
	else
		sentences[identifier] = nil
		ClearJail(identifier)
	end
end)

ESX.RegisterServerCallback('arshia_jail:retriveJail', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if id then
		if ESX.GetPlayerFromId(id) then
			cb(sentences[ESX.GetPlayerFromId(id).identifier])
		else
			cb(nil)
		end
	else
		cb(sentences[xPlayer.identifier])
	end
end)

RegisterServerEvent("arshia_jail:UnjailPlayer")
AddEventHandler("arshia_jail:UnjailPlayer", function(id)
	local zPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local yPlayer = ESX.GetPlayerFromId(id)
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if IsJobAllowed(xPlayer.job.name) then
			TriggerClientEvent('chat:addMessage',xPlayers[i], {color = {0, 95, 254}, multiline = true ,args = {"[DISPATCH]", '^1'..yPlayer.name..'^0 tavasot ^2'..zPlayer.name..'^0 unjail shod !'}})
		end
	end
    ExemptFromAntiCheat(id, 5000, { teleport = true, speed = true })
    TriggerClientEvent("arshia_jail:UnjailPlayer", id)
end)

TriggerEvent('es:addAdminCommand', 'ajail', 2, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = tonumber(args[1])
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Nist !")
		return
	end
	local identifier = xTarget.identifier
	local time =  tonumber(args[2])
	if not time then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Time Ra Dorost Vared Konid !")
		return
	end
	local reason = table.concat(args, " ", 3)
	TriggerClientEvent("arshia_jail:JailPlayer", source, target, 'admin', time, reason, Config.AdminJail.unjail)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, {help = 'Admin Jail', params = {{name = 'playerId', help = 'Player ID'},{name = 'time', help = 'Time'},{name = 'reason', help = 'Reason'}}})

TriggerEvent('es:addAdminCommand', 'ajailoffline', 3, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromIdentifier(args[1])
	local identifier = args[1]
	if xPlayer then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Ast !")
		return
	end
	local time =  tonumber(args[2])
	if not time then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Time Ra Dorost Vared Konid !")
		return
	end
	local reason = table.concat(args, " ", 3)
	MySQL.Async.fetchAll(
		"SELECT * FROM users WHERE identifier = @identifier",
		{["@identifier"] = args[1]},
		function(data)
			if data[1] then
				local sentence = {type = 'admin', time = time, unjail = Config.AdminJail.unjail, reason = reason}
				sentences[identifier] = sentence
				PersistJail(identifier, sentence)
				TriggerClientEvent('chatMessage', -1, "[Admin Jail]", {255, 0, 0}, "^1"..data[1].playerName:gsub("_", " ").."^0 Tavasote ^2"..GetPlayerName(source).."^0 Be Modate ^2"..time.." ^0Daghighe Jail Shod be Dalile : ^1"..reason)
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1[ Jail System ] ', 'Steamhex Vared Shode Eshtebah Ast.' } })
			end
		end
	)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, {help = 'Admin Jail Offline', params = {{name = 'steamhex', help = 'SteamHEX'},{name = 'time', help = 'Time'},{name = 'reason', help = 'Reason'}}})

TriggerEvent('es:addAdminCommand', 'aunjail', 5, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = tonumber(args[1])
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Nist !")
		return
	end
	local identifier = xTarget.identifier
	if sentences[identifier] then
		if sentences[identifier].time > 0 then
			if sentences[identifier].type == 'admin' then
				ExemptFromAntiCheat(target, 5000, { teleport = true, speed = true })
				TriggerClientEvent("arshia_jail:UnjailPlayer", target)
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player Unjail Shod.")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Fard Dar jaile Admin Nist.")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, {help = 'Admin Unjail', params = {{name = 'playerId', help = 'Player ID'}}})

TriggerEvent('es:addAdminCommand', 'icunjail', 8, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = tonumber(args[1])
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Playere Morede Nazar Online Nist !")
		return
	end
	local identifier = xTarget.identifier
	if sentences[identifier] then
		if sentences[identifier].time > 0 then
			if sentences[identifier].type == 'faction' then
				ExemptFromAntiCheat(target, 5000, { teleport = true, speed = true })
				TriggerClientEvent("arshia_jail:UnjailPlayer", target)
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Player Unjail Shod.")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Fard Dar jaile Faction Nist.")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Id Eshtebah Ast.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, {help = 'Faction Unjail', params = {{name = 'playerId', help = 'Player ID'}}})

TriggerEvent('es:addAdminCommand', 'getjail', 2, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local target = tonumber(args[1])
	local identifier
	if not target then
		identifier = args[1]
	else
		local xTarget = ESX.GetPlayerFromId(target)
		identifier = xTarget and xTarget.identifier
	end
	if sentences[identifier] then
		TriggerClientEvent('chatMessage', source, "[Jail System]", {255, 0, 0}, "Time : ^2"..sentences[identifier].time.."^0, Type : ^3"..sentences[identifier].type.."^0, Reason : ^3"..sentences[identifier].reason)
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "Fard Jail Nist.")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1[ System ] : ', 'Shoma Dastresi Kafi Nadarid.' } })
end, {help = 'Get Jail', params = {{name = 'playerId', help = 'Player ID'}}})

AddEventHandler('playerDropped', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier
	 if sentences[identifier] then
		PersistJail(identifier, sentences[identifier])
	 end
end)

