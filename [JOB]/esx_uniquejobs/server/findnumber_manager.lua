-- ============================================================
-- Unified Phone Number Lookup
-- Replaces findnumber_cid / findnumber_mt / findnumber_marshal /
-- findnumber_police with a single /findnumber command.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Union of every DOJ + Law Enforcement job (mirrors the broadest
-- of the old per-job checks, which was police's own)
local RESPONDER_JOBS = {
	police = true, sheriff = true, mt = true,
	cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

local function doFindNumber(source, rawNumber)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma Dastresi Kafi Nadarid!" } })
		return
	end

	if not rawNumber or rawNumber == '' then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat Shomare chizi vared nakardid!" } })
		return
	end

	if string.len(rawNumber) ~= 10 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shomare bayad 11 raghami bashad!" } })
		return
	end

	local number = tonumber(rawNumber)
	if not number then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0Shoma dar ghesmat Shomare vaghat mitavanid adad vared konid!" } })
		return
	end

	MySQL.Async.fetchAll('SELECT playerName FROM users WHERE phone=@number', {
		['@number'] = number,
	}, function(data)
		if data[1] then
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', " ^0 In Shomare be naame ^3" .. string.gsub(data[1].playerName, "_", " ") .. " ^0Ast!" } })
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', "^0 In shomare vojoud nadarad" } })
		end
	end)
end

RegisterCommand('findnumber', function(source, args)
	doFindNumber(source, args[1])
end, false)

-- Lets other menus (e.g. the FBI/CIA /agent menu) trigger the exact same
-- lookup without the player having to type the command.
RegisterServerEvent('esx_uniquejobs:menuFindNumber')
AddEventHandler('esx_uniquejobs:menuFindNumber', function(number)
	doFindNumber(source, number)
end)
