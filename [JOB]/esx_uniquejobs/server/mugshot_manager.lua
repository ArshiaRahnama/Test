-- ============================================================
-- Mugshot -- rebuilt feature. The previous copy of this system
-- (referenced in this resource's old markdown docs) was dead code:
-- no dept_mugshots table ever existed, and neither law_menu.lua nor
-- fxmanifest.lua ever actually wired it in. This is a fresh
-- implementation, standalone from -- but read by -- the existing
-- Rap Sheet (records_manager.lua's esx_uniquejobs:menuGetCriminalRecord),
-- which now shows the latest photo inline instead of duplicating a
-- second identity card.
--
-- Every photo is stored as its own row (dept_mugshots), so there's a
-- real per-citizen photo history, not just one overwritten column.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local LE_JOBS = { police = true, sheriff = true, mt = true }
local function isLe(jobname) return LE_JOBS[jobname] == true end

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
			cb(nil, query) -- name-only citizen, no ESX identifier on file
		end
	end)
end

-- ============================================================
-- Save a newly taken/uploaded photo
-- ============================================================

RegisterServerEvent('esx_uniquejobs:saveMugshot')
AddEventHandler('esx_uniquejobs:saveMugshot', function(citizenQuery, photoUrl)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isLe(xPlayer.job.name) then return end

	if not photoUrl or photoUrl == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~URL-e Aks Nadarim')
		return
	end

	resolveIdentifier(citizenQuery, function(identifier, name)
		MySQL.Async.execute(
			'INSERT INTO dept_mugshots (identifier, citizen_name, photo_url, taken_by_name, taken_by_job, timestamp) '
			.. 'VALUES (@identifier, @cname, @url, @tname, @tjob, @ts)',
			{
				['@identifier'] = identifier,
				['@cname'] = name or citizenQuery or 'Namoshakhas',
				['@url'] = photoUrl,
				['@tname'] = xPlayer.name,
				['@tjob'] = xPlayer.job.name,
				['@ts'] = os.time(),
			},
			function()
				TriggerClientEvent('esx:showNotification', source, '~g~Mugshot Sabt Shod')
			end
		)
	end)
end)

-- ============================================================
-- Photo history (for the "Tarikhche-ye Aks-ha" menu, image
-- thumbnails per row)
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:getMugshotHistory', function(source, cb, query)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isLe(xPlayer.job.name) then cb(nil) return end

	resolveIdentifier(query, function(identifier, name)
		if not identifier and not name then cb({}, query) return end

		local sql, params
		if identifier then
			sql = 'SELECT photo_url, taken_by_name, timestamp FROM dept_mugshots WHERE identifier = @identifier ORDER BY timestamp DESC LIMIT 20'
			params = { ['@identifier'] = identifier }
		else
			sql = 'SELECT photo_url, taken_by_name, timestamp FROM dept_mugshots WHERE citizen_name = @name ORDER BY timestamp DESC LIMIT 20'
			params = { ['@name'] = name }
		end

		MySQL.Async.fetchAll(sql, params, function(rows)
			cb(rows or {}, nil)
		end)
	end)
end)

-- Read-only export so records_manager.lua's Rap Sheet can pull the
-- latest photo for a resolved identifier without duplicating this
-- table's query logic.
function GetLatestMugshot(identifier, cb)
	if not identifier then cb(nil) return end
	MySQL.Async.fetchAll('SELECT photo_url, taken_by_name, timestamp FROM dept_mugshots WHERE identifier = @identifier ORDER BY timestamp DESC LIMIT 1', {
		['@identifier'] = identifier,
	}, function(rows)
		cb(rows[1])
	end)
end
exports('GetLatestMugshot', GetLatestMugshot)
