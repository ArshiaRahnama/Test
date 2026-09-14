-- ============================================================
-- Officer Performance Review (feature #7)
-- One profile per officer combining:
--   - arrest/charge counts (criminal_records, keyed by officer_identifier)
--   - Internal Affairs history filed against them (cad's doj_ia_reports,
--     keyed by target_identifier -- same database, just read from here,
--     cad/server/crimescene.lua still owns writing to that table)
--   - their rank among all officers by arrest count (the same data the
--     CAD leaderboard uses, just re-expressed as "you are #N of M")
-- Viewable by any DOJ or Law Enforcement member (e.g. CIA/FBI/judge
-- doing a review, or a supervisor checking their own squad).
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
local LE_JOBS = { police = true, sheriff = true, mt = true }
local function canView(jobname) return DOJ_JOBS[jobname] or LE_JOBS[jobname] end

local IA_STATUS_LABELS = {
	open = 'Baz',
	reviewing = 'Dar Hale Barresi',
	cleared = 'Takhie Shode',
	disciplined = 'Tanbih Shode',
}

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

ESX.RegisterServerCallback('esx_uniquejobs:dojGetOfficerProfile', function(source, cb, query)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not canView(xPlayer.job.name) then cb(nil) return end

	if not query or query == '' then cb(nil) return end

	resolveIdentifier(query, function(identifier, name)
		if not identifier then cb(nil) return end

		MySQL.Async.fetchAll([[
			SELECT
				SUM(CASE WHEN type = 'arrest' THEN 1 ELSE 0 END) AS arrests,
				SUM(CASE WHEN type = 'charge' THEN 1 ELSE 0 END) AS charges
			FROM criminal_records
			WHERE officer_identifier = @id
		]], { ['@id'] = identifier }, function(countRows)
			local arrests = (countRows[1] and countRows[1].arrests) or 0
			local charges = (countRows[1] and countRows[1].charges) or 0

			MySQL.Async.fetchAll([[
				SELECT COUNT(*) + 1 AS rank FROM (
					SELECT officer_identifier, COUNT(*) AS c
					FROM criminal_records
					WHERE type = 'arrest'
					GROUP BY officer_identifier
					HAVING c > @mine
				) t
			]], { ['@mine'] = arrests }, function(rankRows)
				local rank = (rankRows[1] and rankRows[1].rank) or 1

				MySQL.Async.fetchAll([[
					SELECT COUNT(DISTINCT officer_identifier) AS total
					FROM criminal_records
					WHERE type = 'arrest'
				]], {}, function(totalRows)
					local totalOfficers = (totalRows[1] and totalRows[1].total) or 0

					-- Internal Affairs history (table owned by cad/server/crimescene.lua)
					MySQL.Async.fetchAll(
						'SELECT category, status, description, created_at FROM doj_ia_reports WHERE target_identifier = @id ORDER BY created_at DESC LIMIT 10',
						{ ['@id'] = identifier },
						function(iaRows)
							iaRows = iaRows or {}
							local iaCounts = { open = 0, reviewing = 0, cleared = 0, disciplined = 0 }
							for _, row in ipairs(iaRows) do
								row.statusLabel = IA_STATUS_LABELS[row.status] or row.status
								if iaCounts[row.status] ~= nil then
									iaCounts[row.status] = iaCounts[row.status] + 1
								end
							end

							cb({
								name = name,
								arrests = arrests,
								charges = charges,
								rank = rank,
								totalOfficers = totalOfficers,
								iaCounts = iaCounts,
								iaHistory = iaRows,
							})
						end
					)
				end)
			end)
		end)
	end)
end)
