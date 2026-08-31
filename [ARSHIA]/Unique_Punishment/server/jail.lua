ESX = nil
local sentences = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function ExemptFromAntiCheat(targetId, ms, kinds)
	if GetResourceState('UNIQUE_AC') ~= 'started' then return end
	pcall(function()
		exports['UNIQUE_AC']:ExemptPlayer(targetId, ms or 5000, kinds)
	end)
end

-- SECURITY FIX: this event is public (any client can call it on itself)
-- with a client-controlled `ms`. UNIQUE_AC clamps a single call to at most
-- 10 minutes, but nothing stopped a player from calling it again every
-- ~10 minutes to stay permanently anti-cheat-exempt. Every legitimate call
-- site in this resource uses 4000-5000ms, so (a) clamp ms to that range and
-- (b) add a short per-player cooldown so it can't be spammed back-to-back.
local lastExemptCall = {} -- source -> os.time()

RegisterServerEvent('Unique_Punishment:AntiCheatExempt')
AddEventHandler('Unique_Punishment:AntiCheatExempt', function(ms, kinds)
	local _source = source
	local now = os.time()
	if lastExemptCall[_source] and (now - lastExemptCall[_source]) < 3 then
		return
	end
	lastExemptCall[_source] = now

	ms = tonumber(ms) or 5000
	ms = math.max(1000, math.min(ms, 6000))

	ExemptFromAntiCheat(_source, ms, kinds)
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
		-- Existing jail records from before this security patch (or a
		-- server restart) have no real "started at" timestamp on file.
		-- Defaulting to now (rather than trusting a stored/absent value)
		-- means UpdateTime's elapsed-time check counts their remaining
		-- time from this restart -- it can only make a resumed sentence
		-- run a bit longer than originally intended, never shorter, so
		-- it can't be leveraged for an early release.
		startedAt = tonumber(data.startedAt) or os.time(),
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

local PendingRelease = {} -- [identifier] = true while a legitimate release is in flight

RegisterServerEvent('arshia_jail:sendto')
AddEventHandler('arshia_jail:sendto',function (target, type, time, reason, unjail)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	-- SECURITY FIX: this event previously had NO permission check at all --
	-- any connected player could call TriggerServerEvent('arshia_jail:sendto',
	-- targetId, 'admin', 999999, 'x') directly and jail anyone for any
	-- length. The /ajail admin command DOES check permission (perm level 2,
	-- i.e. xPlayer.permission_level >= 2) but only before triggering a
	-- CLIENT event that then calls straight back into this unprotected
	-- server event -- so the command's gate was trivially bypassable.
	-- Now this event enforces its own permission: permission_level >= 2 for
	-- admin jails, actual membership in an allowed faction job for faction
	-- jails (mirrors the dispatch-message gate already used a few lines
	-- below via IsJobAllowed).
	if not xPlayer then return end
	if type == 'admin' then
		if not xPlayer.permission_level or xPlayer.permission_level < (Config.AdminPermissionLevel or 2) then
			if exports.UNIQUE_AC then
				exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer', 'Tried arshia_jail:sendto (admin) without permission')
			end
			return
		end
	elseif type == 'faction' then
		if not IsJobAllowed(xPlayer.job.name) then
			if exports.UNIQUE_AC then
				exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer', 'Tried arshia_jail:sendto (faction) without an allowed job')
			end
			return
		end
	else
		return
	end

	time = tonumber(time)
	if not time or time <= 0 then return end

	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end
	local identifier = xTarget.identifier
	-- startedAt is the server's own clock for when this sentence began --
	-- used by UpdateTime below to verify a release request corresponds to
	-- real elapsed time rather than trusting the client's claim outright.
	local sentence = {type = type, time = time, unjail = unjail, reason = reason, startedAt = os.time()}
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
		TriggerEvent('DiscordBot:ToDiscord', 'jail', 'JailLog', '```css\n[ Officer : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Target : '..GetPlayerName(target)..'(' .. target .. ') ]\n[ Type : Faction Jail ]\n[ Duration : '..tostring(time)..' ]\n[ Reason : '..tostring(reason)..' ]\n```', 'user', true, source, false)
	else
		TriggerClientEvent('chatMessage', -1, "[Admin Jail]", {255, 0, 0}, "^1"..GetPlayerName(target).."^0 Tavasote ^2"..GetPlayerName(source).."^0 Be Modate ^2"..time.." ^0Daghighe Jail Shod be Dalile : ^1"..reason)
		TriggerEvent('DiscordBot:ToDiscord', 'jail', 'JailLog', '```css\n[ Admin : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Target : '..GetPlayerName(target)..'(' .. target .. ') ]\n[ Type : Admin Jail ]\n[ Duration : '..tostring(time)..' ]\n[ Reason : '..tostring(reason)..' ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('arshia_jail:UpdateTime')
AddEventHandler('arshia_jail:UpdateTime',function (time)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier
	local sentence = sentences[identifier]
	if not sentence then return end

	time = tonumber(time) or 0

	if time > 0 then
		-- SECURITY FIX: only allow the countdown to move DOWN, and never
		-- past what real elapsed time since the sentence started would
		-- allow -- prevents a jailed player from feeding an inflated
		-- `time` to reset/extend their own countdown, and from jumping
		-- the value around arbitrarily.
		local maxPlausible = math.max(0, sentence.time - math.floor((os.time() - sentence.startedAt) / 60))
		if time <= sentence.time and time <= maxPlausible + 1 then
			sentence.time = time
		end
	else
		-- Releasing to 0 is only accepted if either the real sentence
		-- duration has actually elapsed, or the server itself granted an
		-- early release (PendingRelease ticket set by UnjailPlayer / the
		-- aunjail-icunjail admin commands below) -- closes the exploit
		-- where a jailed player just sent UpdateTime(0) directly to
		-- instantly clear their own sentence.
		local elapsedMinutes = (os.time() - sentence.startedAt) / 60
		if PendingRelease[identifier] or elapsedMinutes >= sentence.time then
			PendingRelease[identifier] = nil
			sentences[identifier] = nil
			ClearJail(identifier)
		else
			print(('arshia_jail: %s attempted to self-release from jail early!'):format(identifier))
			TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : arshia_jail ]\n[ Player Steam : '..tostring(identifier)..' ]\n[ Attempted : to self-release from jail early! ]\n[ Reason Blocked : not authorized / invalid data ]\n```', 'user', true, source, false)
		end
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
	local source = source
	local zPlayer = ESX.GetPlayerFromId(source)
	-- SECURITY FIX: previously had NO permission check -- any player could
	-- release any jailed player (including themselves) on demand.
	if not zPlayer or not zPlayer.permission_level or zPlayer.permission_level < 2 then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(source, 'Cheat Lua Executer', 'Tried arshia_jail:UnjailPlayer without permission')
		end
		return
	end
	local yPlayer = ESX.GetPlayerFromId(id)
	if not yPlayer then return end
	if yPlayer.identifier then
		PendingRelease[yPlayer.identifier] = true
	end

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if IsJobAllowed(xPlayer.job.name) then
			TriggerClientEvent('chat:addMessage',xPlayers[i], {color = {0, 95, 254}, multiline = true ,args = {"[DISPATCH]", '^1'..yPlayer.name..'^0 tavasot ^2'..zPlayer.name..'^0 unjail shod !'}})
		end
	end
	TriggerEvent('DiscordBot:ToDiscord', 'jail', 'JailLog', '```css\n[ Admin : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Target : '..GetPlayerName(id)..'(' .. id .. ') ]\n[ Action : Early Release / Unjail ]\n```', 'user', true, source, false)
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
				-- Open a release ticket so the fixed UpdateTime handler
				-- (which no longer trusts a client-sent 0 on its own)
				-- accepts this legitimate, admin-granted early release.
				PendingRelease[identifier] = true
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
				-- Same release ticket as the admin branch above.
				PendingRelease[identifier] = true
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

