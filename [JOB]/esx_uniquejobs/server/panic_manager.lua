-- ============================================================
-- Unified Panic / Backup Manager
-- Replaces /pc_police /bc_police /resp_police /cresp_police and
-- /pc_marshal /bc_marshal /resp_marshal /cresp_marshal with one
-- shared system: /pc /bc /resp /cresp -- visible to every DOJ +
-- Law Enforcement job (cid/cia/marshal/fbi/judge/doa/police/sheriff/mt),
-- not just whichever job sent it.
--
-- Alerts and accepts both play a radio-style sound to every online
-- responder (not distance-limited -- this is a dispatch channel, not
-- a physical noise). Accepting works whether or not you're in a unit;
-- if you are, your unit's callsign is shown to everyone so unit-mates
-- immediately recognize their own unit is responding.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Union of every DOJ + Law Enforcement job (matches shared/departments.lua's
-- 'doj' and 'le' groups)
local RESPONDER_JOBS = {
	police = true, sheriff = true, mt = true,
	cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

local panicCount = 0
local panicReqs = {}   -- panicReqs[id] = { x, y, sourceId, name }
local sentReq = {}     -- per-source cooldown

local function playForResponders(exceptSource, soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and xTarget.source ~= exceptSource and isResponder(xTarget.job.name) then
			TriggerClientEvent('InteractSound_CL:PlayOnOne', xTarget.source, soundFile, soundVolume)
		end
	end
end

RegisterServerEvent('esx_uniquejobs:sendPanic')
AddEventHandler('esx_uniquejobs:sendPanic', function(x, y, isDistress)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then return end

	if sentReq[source] then
		TriggerClientEvent('esx:showNotification', source, '~r~Darkhast Backup/Panic Shoma Rooye Cooldown Ast.')
		return
	end

	panicCount = panicCount + 1
	local id = panicCount
	local name = GetPlayerName(source)

	panicReqs[id] = { x = x, y = y, sourceId = source, name = name }

	sentReq[source] = true
	SetTimeout(60000, function() sentReq[source] = nil end)

	local jobLabel = string.upper(xPlayer.job.name)

	if isDistress then
		TriggerClientEvent('chatMessage', source, "[ DISPATCH (" .. jobLabel .. ") ]", {50, 150, 200},
			"^7Shoma Dar Halat ^1Panic ^7Qarar Gereftid -> ^8/resp " .. id)
	else
		TriggerClientEvent('chatMessage', source, "[ DISPATCH (" .. jobLabel .. ") ]", {50, 150, 200},
			"^7Shoma Darkhast ^1Backup ^7Dadid -> ^8/resp " .. id)
	end

	-- 'panic.ogg' is a real siren/alarm tone -- 'pager.ogg' is a dispatch
	-- pager beep, more fitting for a routine backup call
	local soundFile = isDistress and 'panic' or 'pager'
	local soundVolume = isDistress and 0.6 or 0.4

	playForResponders(source, soundFile, soundVolume)

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and xTarget.source ~= source and isResponder(xTarget.job.name) then
			local msg = isDistress
				and ("^7Afsar ^2" .. name .. "^7 Az Vahede ^7Morede ^1Hamle ^7Gharar Gerefte Ast -> ^8/resp " .. id)
				or ("^7Afsar ^2" .. name .. "^7 Az Vahede ^7Darkhast ^1Backup ^7Darad -> ^8/resp " .. id)

			TriggerClientEvent('chatMessage', xTarget.source, "[ DISPATCH (" .. jobLabel .. ") ]", {50, 150, 200}, msg)
		end
	end
end)

RegisterCommand('resp', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, '~r~Shoma Dastresi Kafi Nadarid!')
		return
	end

	local id = tonumber(args[1])
	local req = id and panicReqs[id]
	if not req then
		TriggerClientEvent('esx:showNotification', source, '~r~ID Morede Nazar Yaft Nashod!')
		return
	end

	TriggerClientEvent('esx_uniquejobs:markPanicLocation', source, req.x, req.y, req.sourceId)
	TriggerClientEvent('chatMessage', source, "[ DISPATCH ]", {31, 0, 173}, "Panic Mark Shod Jahat Cancel Kardan ^2/cresp")

	-- Being in a unit is NOT required to accept -- but if the accepting
	-- officer belongs to one, show its callsign so unit-mates instantly
	-- recognize their own unit is on the call.
	local callsign = GetPlayerUnitCallsign and GetPlayerUnitCallsign(xPlayer.identifier) or nil
	local unitTag = callsign and (" ^3[" .. callsign .. "]^0") or ""

	playForResponders(nil, 'notification', 0.5)

	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and isResponder(xTarget.job.name) then
			TriggerClientEvent('chatMessage', xTarget.source, "[ DISPATCH ]", {31, 0, 173},
				"^2" .. xPlayer.name .. unitTag .. " ^7Darkhast Panic ^8ID: " .. id .. " ^2Ra Accept Kard!")
		end
	end
end, false)

