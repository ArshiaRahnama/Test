-- ============================================================
-- Mugshot (feature #8)
-- One photo per citizen identifier, attached during booking (or
-- any time from the citizen's profile). The client captures the
-- image with screenshot-basic when it's installed and uploads it,
-- passing the resulting URL here; if screenshot-basic isn't
-- installed the client instead asks for a photo URL directly, so
-- this server side doesn't care which path produced photoUrl.
-- Requires dept_features_ext.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RESPONDER_JOBS = {
	police = true, sheriff = true, mt = true,
	cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}
local function isResponder(jobname) return RESPONDER_JOBS[jobname] == true end

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

RegisterServerEvent('esx_uniquejobs:dojSaveMugshot')
AddEventHandler('esx_uniquejobs:dojSaveMugshot', function(query, photoUrl)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then return end

	if not photoUrl or photoUrl == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Aks Namotabar')
		return
	end

	-- Defense in depth: the client already blocks a hand-typed
	-- non-link (like a pasted screenshot/base64 blob mistaken for a
	-- URL), but never trust the client alone. `data:image/...;base64,`
	-- IS legitimate here -- that's exactly what MugShotBase64
	-- (client/mugshot_menu.lua) sends -- so only reject values that are
	-- neither a real link nor a real base64 image data URI.
	if not (photoUrl:find('^https?://') or photoUrl:find('^data:image/[^;]+;base64,')) then
		TriggerClientEvent('esx:showNotification', source, '~r~Format-e Aks Namotabar (Na Link, Na Base64-ye Vaghei)')
		return
	end

	resolveIdentifier(query, function(identifier, name)
		if not identifier then
			TriggerClientEvent('esx:showNotification', source, '~r~Shahrvand Peida Nashod')
			return
		end

		MySQL.Async.execute(
			'REPLACE INTO dept_mugshots (identifier, name, photo_url, taken_by_name, timestamp) VALUES (@id, @name, @photo, @by, @ts)',
			{ ['@id'] = identifier, ['@name'] = name, ['@photo'] = photoUrl, ['@by'] = xPlayer.name, ['@ts'] = os.time() },
			function()
				TriggerClientEvent('esx:showNotification', source, '~g~Mugshot Baraye ' .. name .. ' Sabt Shod')
			end
		)
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:dojGetMugshot', function(source, cb, query)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then cb(nil) return end

	resolveIdentifier(query, function(identifier, name)
		if not identifier then cb(nil) return end

		MySQL.Async.fetchAll('SELECT * FROM dept_mugshots WHERE identifier = @id', { ['@id'] = identifier }, function(rows)
			cb(rows[1] or { identifier = identifier, name = name, photo_url = nil })
		end)
	end)
end)

-- ============================================================
-- Rap Sheet (extension of feature #8)
-- A printable-style identity card: pulls physical description from
-- `users` (esx_identity columns, already used elsewhere in this
-- resource -- see server/cia_main.lua and server/fbi_main.lua),
-- the mugshot photo from dept_mugshots, the citizen's last known
-- location from their most recent traffic stop, a summary of their
-- /doj criminal record (criminal_records), AND a cross-reference
-- into CAD's own case/booking tables (doj_cases, doj_case_suspects,
-- doj_criminal_records) -- read-only, cad/server/crimescene.lua
-- still owns writing to those.
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetRapSheet', function(source, cb, query)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then cb(nil) return end

	resolveIdentifier(query, function(identifier, name)
		if not identifier then cb(nil) return end

		MySQL.Async.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @id', { ['@id'] = identifier }, function(userRows)
			local user = userRows[1] or {}

			MySQL.Async.fetchAll('SELECT photo_url FROM dept_mugshots WHERE identifier = @id', { ['@id'] = identifier }, function(photoRows)
				local photoUrl = photoRows[1] and photoRows[1].photo_url or nil

				MySQL.Async.fetchAll(
					'SELECT location, timestamp FROM dept_traffic_stops WHERE citizen_identifier = @id AND location IS NOT NULL ORDER BY timestamp DESC LIMIT 1',
					{ ['@id'] = identifier },
					function(locRows)
						local lastLocation = locRows[1] and locRows[1].location or nil
						local lastLocationAt = locRows[1] and locRows[1].timestamp or nil

						MySQL.Async.fetchAll([[
							SELECT
								SUM(CASE WHEN type = 'arrest' THEN 1 ELSE 0 END) AS arrests,
								SUM(CASE WHEN type = 'charge' THEN 1 ELSE 0 END) AS charges
							FROM criminal_records WHERE identifier = @id
						]], { ['@id'] = identifier }, function(countRows)
							local arrests = (countRows[1] and countRows[1].arrests) or 0
							local charges = (countRows[1] and countRows[1].charges) or 0

							MySQL.Async.fetchAll(
								'SELECT type, reason, officer_name, jail_time, timestamp FROM criminal_records WHERE identifier = @id ORDER BY timestamp DESC LIMIT 10',
								{ ['@id'] = identifier },
								function(recordRows)
									-- Cross-reference CAD (cad/server/crimescene.lua's own
									-- tables) so the Rap Sheet is genuinely complete: open
									-- investigations naming this person as suspect/accomplice,
									-- plus CAD's own booking log.
									MySQL.Async.fetchAll([[
										SELECT DISTINCT c.id, c.rob_name, c.rob_family, c.status, c.created_at
										FROM doj_cases c
										LEFT JOIN doj_case_suspects s ON s.case_id = c.id
										WHERE c.suspect_identifier = @id OR s.suspect_identifier = @id
										ORDER BY c.created_at DESC
										LIMIT 5
									]], { ['@id'] = identifier }, function(cadCases)
										MySQL.Async.fetchAll(
											'SELECT charges, fine, jail_minutes, booked_by_name, created_at FROM doj_criminal_records WHERE suspect_identifier = @id ORDER BY created_at DESC LIMIT 5',
											{ ['@id'] = identifier },
											function(cadRecords)
												cb({
													identifier = identifier,
													name = name,
													firstname = user.firstname,
													lastname = user.lastname,
													sex = user.sex,
													dateofbirth = user.dateofbirth,
													height = user.height,
													photoUrl = photoUrl,
													lastLocation = lastLocation,
													lastLocationAt = lastLocationAt,
													arrests = arrests,
													charges = charges,
													records = recordRows or {},
													cadCases = cadCases or {},
													cadRecords = cadRecords or {},
												})
											end
										)
									end)
								end
							)
						end)
					end
				)
			end)
		end)
	end)
end)
