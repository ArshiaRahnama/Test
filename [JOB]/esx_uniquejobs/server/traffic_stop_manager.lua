-- ============================================================
-- Traffic Stop Log (feature #9)
-- A lightweight log for routine stops that don't need a full
-- Booking (no jail/fine issued through this) -- just enough to
-- keep for stats (feeds officer activity, doesn't touch
-- criminal_records/dept_cases at all). Citizen can be a name-only
-- entry (identifier optional) since not every stop involves
-- pulling up someone's full ID.
-- Requires dept_features_ext.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local LE_JOBS = { police = true, sheriff = true, mt = true }
local function isLe(jobname) return LE_JOBS[jobname] == true end

local OUTCOME_LABELS = {
	warning = 'Ekhtar',
	citation = 'Jarime',
	search = 'Bazresi',
	escalated = 'Ershad Be Dastgiri',
}

local function resolveIdentifier(query, cb)
	if not query or query == '' then cb(nil, nil) return end
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
			cb(nil, query) -- fall back to whatever the officer typed as a plain name
		end
	end)
end

RegisterServerEvent('esx_uniquejobs:logTrafficStop')
AddEventHandler('esx_uniquejobs:logTrafficStop', function(citizenQuery, reason, outcome, notes, location, plate)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isLe(xPlayer.job.name) then return end

	if not reason or reason == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Lotfan Dalil-e Tavaghof Ra Vared Konid')
		return
	end
	if not OUTCOME_LABELS[outcome] then outcome = 'warning' end
	if plate == '' then plate = nil end

	resolveIdentifier(citizenQuery, function(identifier, name)
		MySQL.Async.execute(
			'INSERT INTO dept_traffic_stops (officer_identifier, officer_name, officer_job, citizen_identifier, citizen_name, plate, reason, outcome, notes, location, timestamp) '
			.. 'VALUES (@oid, @oname, @ojob, @cid, @cname, @plate, @reason, @outcome, @notes, @loc, @ts)',
			{
				['@oid'] = xPlayer.identifier, ['@oname'] = xPlayer.name, ['@ojob'] = xPlayer.job.name,
				['@cid'] = identifier, ['@cname'] = name or citizenQuery or 'Namoshakhas', ['@plate'] = plate,
				['@reason'] = reason, ['@outcome'] = outcome, ['@notes'] = notes or '', ['@loc'] = location or nil, ['@ts'] = os.time(),
			},
			function()
				TriggerClientEvent('esx:showNotification', source, '~g~Tavaghof Sabt Shod (' .. OUTCOME_LABELS[outcome] .. ')')
			end
		)
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:getTrafficStops', function(source, cb, onlyMine)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isLe(xPlayer.job.name) then cb(nil) return end

	local sql = 'SELECT * FROM dept_traffic_stops '
	local params = {}
	if onlyMine then
		sql = sql .. 'WHERE officer_identifier = @id '
		params['@id'] = xPlayer.identifier
	end
	sql = sql .. 'ORDER BY timestamp DESC LIMIT 30'

	MySQL.Async.fetchAll(sql, params, function(rows)
		for _, row in ipairs(rows) do
			row.outcomeLabel = OUTCOME_LABELS[row.outcome] or row.outcome
		end
		cb(rows)
	end)
end)
