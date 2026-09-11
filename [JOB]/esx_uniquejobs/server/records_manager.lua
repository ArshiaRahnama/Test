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
--
-- Also exported (see bottom of file) so OTHER resources (e.g. esx_drugs'
-- evidence-collection flow) can log a record without a full arrest/booking
-- ever happening through this resource's own menus.
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

-- ============================================================
-- External export: same function as above, for other resources
-- (e.g. Unique_AllRobs on a successful/charged robbery, or esx_drugs'
-- evidence-collection flow) to log a real entry -- this also
-- automatically feeds officer_performance.lua's arrest/charge counts
-- when officerIdentifier is set, with no extra wiring needed there.
-- exports['esx_uniquejobs']:LogCriminalRecord(targetIdentifier, recordType, reason, officerName, officerIdentifier, jailTime)
-- ============================================================
exports('LogCriminalRecord', LogCriminalRecord)

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

				-- FEATURE ADDED (Rap Sheet): also pull DOJ bookings logged
				-- through the CAD/Crime Scene panel (doj_criminal_records -
				-- a separate table from criminal_records above, populated by
				-- cad/server/crimescene.lua's booking flow) and this
				-- person's last known location (their most recent /law or
				-- radar traffic stop) -- both now genuinely delivered here,
				-- unlike the old dead-code Mugshot menu that only promised
				-- them.
				MySQL.Async.fetchAll('SELECT charges, fine, jail_minutes, booked_by_name, created_at FROM doj_criminal_records WHERE suspect_identifier = @identifier ORDER BY created_at DESC LIMIT 15', {
					['@identifier'] = identifier,
				}, function(bookings)
					MySQL.Async.fetchAll('SELECT location, timestamp FROM dept_traffic_stops WHERE citizen_identifier = @identifier AND location IS NOT NULL ORDER BY timestamp DESC LIMIT 1', {
						['@identifier'] = identifier,
					}, function(lastStop)
						-- FEATURE ADDED (Mugshot, rebuilt): identity card fields
						-- (same users columns cia_main.lua/fbi_main.lua already
						-- use) + the latest photo from server/mugshot_manager.lua
						-- (dept_mugshots), so the Rap Sheet is now a genuine ID
						-- card+photo+full history in one place, in both /doj and
						-- /law, instead of a separate half-wired Mugshot menu.
						MySQL.Async.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier LIMIT 1', {
							['@identifier'] = identifier,
						}, function(identity)
							GetLatestMugshot(identifier, function(mugshot)
								TriggerClientEvent('esx_uniquejobs:criminalRecordResult', source, {
									name = name,
									records = records,
									bookings = bookings,
									unpaidCount = #bills,
									unpaidTotal = totalUnpaid,
									lastKnownLocation = lastStop[1] and lastStop[1].location or nil,
									lastKnownTimestamp = lastStop[1] and lastStop[1].timestamp or nil,
									sex = identity[1] and identity[1].sex or nil,
									dob = identity[1] and identity[1].dateofbirth or nil,
									height = identity[1] and identity[1].height or nil,
									mugshotUrl = mugshot and mugshot.photo_url or nil,
									mugshotTakenBy = mugshot and mugshot.taken_by_name or nil,
									mugshotTimestamp = mugshot and mugshot.timestamp or nil,
								})
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end)
