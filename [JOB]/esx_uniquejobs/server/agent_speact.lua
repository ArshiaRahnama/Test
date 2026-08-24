-- ============================================================
-- Unified Agent (FBI + CIA) Interrogation / Spectate Manager
-- Replaces the near-identical fbi_speact_sv.lua / cia_speact_sv.lua
-- and their suffixed commands:
--   fow_fbi / fow_cia   -> /fow  (also reachable from /agent menu)
--   fcw_fbi / fcw_cia   -> /fcw  (also reachable from /agent menu)
--   fw_fbi  / fw_cia    -> /fw   (also reachable from /agent menu)
--   fbimsg  / ciamsg    -> /agentmsg (also reachable from /agent menu)
-- Each department (fbi/cia) gets its own interrogation room and
-- spectate slot, but through one shared command set. Every action
-- is written as a plain function so both the typed slash command
-- AND the /agent ox_lib menu (client/agent_speact.lua) can trigger
-- the exact same logic.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local AGENT_JOBS = { fbi = true, cia = true }

local function isAgent(jobname)
	return AGENT_JOBS[jobname] == true
end

ESX.RegisterServerCallback('esx_uniquejobs:checkAgentJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer and isAgent(xPlayer.job.name) and xPlayer.job.name or false)
end)

ESX.RegisterServerCallback('esx_uniquejobs:getAgentRank', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer and xPlayer.job.grade or 0)
end)

ESX.RegisterServerCallback('getOnlinePlayersByJob', function(source, cb, job)
	local players = {}
	for _, playerId in pairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(playerId)
		if xPlayer and xPlayer.job.name == job then
			table.insert(players, { id = playerId, name = xPlayer.name })
		end
	end
	cb(players)
end)

-- Used by the /agent menu to show a live list of other online FBI/CIA agents
ESX.RegisterServerCallback('esx_uniquejobs:getOnlineAgents', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then cb(nil) return end

	local dept = xPlayer.job.name
	local agents = {}
	for _, playerId in pairs(ESX.GetPlayers()) do
		local xTarget = ESX.GetPlayerFromId(playerId)
		if xTarget and xTarget.job.name == dept and xTarget.source ~= source then
			agents[#agents + 1] = { id = playerId, name = xTarget.name, gradeLabel = xTarget.job.grade_label }
		end
	end
	cb(agents)
end)

-- ============================================================
-- Spectate
-- ============================================================

local spectating = {} -- spectating[agentSource] = targetId

RegisterServerEvent('esx_uniquejobs:agentStartSpectate')
AddEventHandler('esx_uniquejobs:agentStartSpectate', function(targetId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then return end

	local target = ESX.GetPlayerFromId(targetId)
	if not target then return end

	spectating[source] = targetId

	TriggerClientEvent('esx_uniquejobs:agentSpectate', source, targetId, target.inventory, target.loadout, target.money,
		target.bank, target.name, target.job.name, target.job.grade_label, target.job.grade,
		target.gang.name, target.gang.grade_label, target.gang.grade)
end)

RegisterServerEvent('esx_uniquejobs:agentStopSpectate')
AddEventHandler('esx_uniquejobs:agentStopSpectate', function()
	spectating[source] = nil
end)

local function doAgentMsg(source, message)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, "❌ Shoma FBI Ya CIA Nistid!")
		return
	end

	local spectateTarget = spectating[source]
	if not spectateTarget then
		TriggerClientEvent('esx:showNotification', source, "❌ Shoma Spectate Nemikonid!")
		return
	end

	if not message or message == "" then
		TriggerClientEvent('esx:showNotification', source, "❌ Payam Khali Nemitavanad Bashad")
		return
	end

	local targetPlayer = ESX.GetPlayerFromId(spectateTarget)
	if not targetPlayer then
		TriggerClientEvent('esx:showNotification', source, "❌ Target Peida Nashod!")
		return
	end

	TriggerClientEvent('esx_uniquejobs:agentChatMessage', spectateTarget, xPlayer.name, message)
	TriggerClientEvent('esx:showNotification', source, "✅ Payam Baraye " .. spectateTarget .. " Ersal Shod")
end

RegisterCommand('agentmsg', function(source, args)
	doAgentMsg(source, table.concat(args, " "))
end, false)

RegisterServerEvent('esx_uniquejobs:menuAgentMsg')
AddEventHandler('esx_uniquejobs:menuAgentMsg', function(message)
	doAgentMsg(source, message)
end)

-- ============================================================
-- Interrogation chat room -- one active room per department
-- (fbi, cia) so an FBI room and a CIA room never collide
-- ============================================================

local chatroom = {} -- chatroom[dept] = { agentSource, targetSource, targetName }

local function doOpenRoom(source, targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, "~r~Shoma Dast Resi Nadarid!")
		return
	end

	if not targetId then
		TriggerClientEvent('esx:showNotification', source, "~r~lotfan id vared konid")
		return
	end

	local dept = xPlayer.job.name
	if chatroom[dept] then
		TriggerClientEvent('esx:showNotification', source, "~r~Shoma Yek Chat Rom Baz Darid!")
		return
	end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		TriggerClientEvent('esx:showNotification', source, "~r~Player Online Nist")
		return
	end

	chatroom[dept] = { agentSource = source, targetSource = xTarget.source, targetName = xTarget.name }

	TriggerClientEvent('esx:showNotification', xTarget.source, "Yek Chat Room Baraye Shoma Az Taraf ~r~" .. string.upper(dept) .. "~w~ Baz Shod")
	TriggerClientEvent('esx:showNotification', source, "Shoma Yek Chat Room Ba ~g~" .. xTarget.name .. "~w~ Baz Kardid")
	TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^5Chat Room: ', 'Baraye Chat Az Command ^2/fw ^0 Ya Menu-ye ^2/agent ^0 Estefade Konid' } })
end

RegisterCommand('fow', function(source, args)
	doOpenRoom(source, args[1])
end, false)

RegisterServerEvent('esx_uniquejobs:menuOpenRoom')
AddEventHandler('esx_uniquejobs:menuOpenRoom', function(targetId)
	doOpenRoom(source, targetId)
end)

local function doCloseRoom(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, "~r~Shoma Dast Resi Nadarid!")
		return
	end

	local dept = xPlayer.job.name
	local room = chatroom[dept]
	if not room then
		TriggerClientEvent('esx:showNotification', source, "~r~Shoma Chat Room Baz Nadarid!!!")
		return
	end

	chatroom[dept] = nil

	local xTarget = ESX.GetPlayerFromId(room.targetSource)
	if xTarget then
		TriggerClientEvent('esx:showNotification', xTarget.source, "~r~Chat Room Shoma Ba ~g~" .. room.targetName .. "~w~ Baste Shod")
	end
end

RegisterCommand('fcw', function(source)
	doCloseRoom(source)
end, false)

RegisterServerEvent('esx_uniquejobs:menuCloseRoom')
AddEventHandler('esx_uniquejobs:menuCloseRoom', function()
	doCloseRoom(source)
end)

local function doRoomMessage(source, message)
	for _, room in pairs(chatroom) do
		if source == room.agentSource then
			TriggerClientEvent('esx_uniquejobs:agentChatMessage', room.targetSource, nil, message, true)
			TriggerClientEvent('esx_uniquejobs:agentChatMessage', room.agentSource, nil, message, true)
			return
		elseif source == room.targetSource then
			TriggerClientEvent('esx_uniquejobs:agentChatMessage', room.agentSource, room.targetName, message, false)
			TriggerClientEvent('esx_uniquejobs:agentChatMessage', room.targetSource, room.targetName, message, false)
			return
		end
	end

	TriggerClientEvent('esx:showNotification', source, "~r~Shoma Chat Room Baz Nadarid!")
end

RegisterCommand('fw', function(source, args)
	doRoomMessage(source, table.concat(args, " "))
end, false)

RegisterServerEvent('esx_uniquejobs:menuRoomMessage')
AddEventHandler('esx_uniquejobs:menuRoomMessage', function(message)
	doRoomMessage(source, message)
end)

-- Lets the /agent menu show whether the invoking agent currently has an
-- open room, and with whom, without needing them to remember.
ESX.RegisterServerCallback('esx_uniquejobs:getAgentRoomState', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isAgent(xPlayer.job.name) then cb(nil) return end

	local room = chatroom[xPlayer.job.name]
	cb(room and { targetName = room.targetName } or nil)
end)
