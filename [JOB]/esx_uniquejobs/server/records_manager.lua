-- ============================================================
-- Criminal Background Check
-- Powers the /agent menu's "Criminal Background Check" option.
-- Requires the criminal_records table (see criminal_records.sql
-- in this resource's root) to be imported once.
--
-- LogCriminalRecord(...) is a global function -- cid_main.lua's
-- existing CidBillingWebhook/CidJailWebhook handlers call it
-- alongside their Discord webhook so every arrest and charge is
-- also logged here, without duplicating any of that logic.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Union of every DOJ + Law Enforcement job
local RESPONDER_JOBS = {
	police = true, sheriff = true, mt = true,
	cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

function LogCriminalRecord(targetIdentifier, recordType, reason, officerName, officerIdentifier, jailTime)
	if not targetIdentifier then return end

	MySQL.Async.execute(
		'INSERT INTO criminal_records (identifier, type, reason, officer_name, officer_identifier, jail_time, timestamp) VALUES (@identifier, @type, @reason, @officer_name, @officer_identifier, @jail_time, @timestamp)',
		{
			['@identifier'] = targetIdentifier,
			['@type'] = recordType,
			['@reason'] = reason or 'Na Moshakhas',
			['@officer_name'] = officerName,
			['@officer_identifier'] = officerIdentifier,
			['@jail_time'] = jailTime,
			['@timestamp'] = os.time(),
		}
	)

	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CriminalRecordLog', '```css\n[ Officer : '..tostring(officerName)..' ('..tostring(officerIdentifier)..') ]\n[ Target Steam : '..tostring(targetIdentifier)..' ]\n[ Type : '..tostring(recordType)..' ]\n[ Reason : '..tostring(reason)..' ]\n[ Jail Time : '..tostring(jailTime)..' ]\n```', 'user', true, nil, false)
end

-- Resolves a search query to an identifier + display name: a numeric
-- query that matches a currently-online player id wins; otherwise it's
-- treated as a (partial) character name search.
local function resolveIdentifier(query, cb)
	local asId = tonumber(query)
	if asId then
		local xTarget = ESX.GetPlayerFromId(asId)
		if xTarget then
			cb(xTarget.identifier, xTarget.name)
			return
		end
	end

	MySQL.Async.fetchAll('SELECT identifier, playerName FROM users WHERE playerName LIKE @name LIMIT 1', {
		['@name'] = '%' .. query .. '%',
	}, function(result)
		if result[1] then
			cb(result[1].identifier, result[1].playerName)
		else
			cb(nil, nil)
		end
	end)
end

RegisterServerEvent('esx_uniquejobs:menuGetCriminalRecord')
AddEventHandler('esx_uniquejobs:menuGetCriminalRecord', function(query)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then return end

	if not query or query == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Lotfan ID Ya Esm Vared Konid')
		return
	end

	resolveIdentifier(query, function(identifier, name)
		if not identifier then
			TriggerClientEvent('esx_uniquejobs:criminalRecordResult', source, nil, query)
			return
		end

		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CriminalRecordLog', '```css\n[ Officer : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Action : Background Check Search ]\n[ Query : '..tostring(query)..' ]\n[ Matched : '..tostring(name)..' ]\n```', 'user', true, source, false)

		MySQL.Async.fetchAll('SELECT type, reason, officer_name, jail_time, timestamp FROM criminal_records WHERE identifier = @identifier ORDER BY timestamp DESC LIMIT 15', {
			['@identifier'] = identifier,
		}, function(records)
			MySQL.Async.fetchAll('SELECT label, amount FROM billing WHERE identifier = @identifier', {
				['@identifier'] = identifier,
			}, function(bills)
				local totalUnpaid = 0
				for _, b in ipairs(bills) do
					totalUnpaid = totalUnpaid + (b.amount or 0)
				end

				TriggerClientEvent('esx_uniquejobs:criminalRecordResult', source, {
					name = name,
					records = records,
					unpaidCount = #bills,
					unpaidTotal = totalUnpaid,
				})
			end)
		end)
	end)
end)
