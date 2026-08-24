-- ============================================================
-- Unified Robbery Alert Manager
-- Replaces the old separate police/marshal Robbs tables and
-- /acceptrob_police [code] /acceptrob_marshal [code] commands
-- with one shared queue and a single /acceptrob menu.
--
-- Also fixes a dangling wire: [ARSHIA]/Unique_AllRobs/server.lua
-- (SetAlarmPolice) fires the event 'Unit:RobAlarm' with no job
-- suffix, but the old handlers only listened for
-- 'Unit:RobAlarm_police' / 'Unit:RobAlarm_marshal' -- so no rob
-- ever actually reached the accept queue. This file listens for
-- the real event name, plus the old suffixed ones for safety.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Robs = {}
local RobCounter = 0

-- Anyone who should see/accept dispatched robbery alerts.
-- Mirrors the union of the old IsPoliceForUnit + IsMarshalForUnit checks.
local RESPONDER_JOBS = { police = true, sheriff = true, mt = true, fbi = true, marshal = true }

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

local function createRob(name)
	if not name then return end

	RobCounter = RobCounter + 1
	local code = RobCounter

	Robs[code] = {
		code = code,
		name = name,
		accepted = false,
		acceptedBy = nil,
		acceptedByJob = nil,
		createdAt = os.time(),
	}

	TriggerClientEvent('esx_uniquejobs:robAlert', -1, name)

	SetTimeout(10 * 60000, function()
		Robs[code] = nil
	end)

	return code
end

RegisterNetEvent('Unit:RobAlarm')
AddEventHandler('Unit:RobAlarm', function(name)
	createRob(name)
end)

-- Back-compat, in case anything still fires the old suffixed events
RegisterNetEvent('Unit:RobAlarm_police')
AddEventHandler('Unit:RobAlarm_police', function(name)
	createRob(name)
end)

RegisterNetEvent('Unit:RobAlarm_marshal')
AddEventHandler('Unit:RobAlarm_marshal', function(name)
	createRob(name)
end)

-- ============================================================
-- Menu data / accept
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:getActiveRobs', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then cb(nil) return end

	local list = {}
	for code, rob in pairs(Robs) do
		if not rob.accepted then
			list[#list + 1] = { code = code, name = rob.name, secondsAgo = os.time() - rob.createdAt }
		end
	end
	table.sort(list, function(a, b) return a.code < b.code end)

	cb(list)
end)

RegisterServerEvent('esx_uniquejobs:acceptRob')
AddEventHandler('esx_uniquejobs:acceptRob', function(code)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not code then return end

	if not isResponder(xPlayer.job.name) then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Shoma Dastresi Kafi Baraye Estefade AzIn Dastor Ra Nadarid")
		return
	end

	local rob = Robs[code]
	if not rob then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "Rob Baraye Accept Ba In Code Vojod Nadarad")
		return
	end

	if rob.accepted then
		TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, "In Rob Ghablan Accept Shode Ast")
		return
	end

	rob.accepted = true
	rob.acceptedBy = xPlayer.identifier
	rob.acceptedByJob = xPlayer.job.name

	TriggerClientEvent('esx_uniquejobs:robAccepted', -1, rob.name, string.gsub(xPlayer.name, "_", " "), string.upper(xPlayer.job.name))
end)

-- ============================================================
-- Back-compat exports: some other resources may still call
-- exports.esx_uniquejobs:CheckRob_police(code) / CheckRob_marshal(code)
-- ============================================================

local function checkRob(code)
	return Robs[code] ~= nil and Robs[code].accepted or false
end

exports('CheckRob_police', checkRob)
exports('CheckRob_marshal', checkRob)
