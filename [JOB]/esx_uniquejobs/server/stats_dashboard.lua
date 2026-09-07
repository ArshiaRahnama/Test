-- ============================================================
-- Statistics Dashboard (feature #6)
-- Crimes by charge type, arrests-over-time trend (last 14 days),
-- and most-active officers. Pulls from tables that already exist
-- (dept_case_charges, criminal_records) -- no schema changes
-- needed for this one. Rendered as ASCII/unicode bar charts inside
-- the /doj menu (client/stats_dashboard_menu.lua) so it works with
-- zero extra NUI/HTML plumbing.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
local LE_JOBS = { police = true, sheriff = true, mt = true }
local function canView(jobname) return DOJ_JOBS[jobname] or LE_JOBS[jobname] end

ESX.RegisterServerCallback('esx_uniquejobs:dojGetStats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not canView(xPlayer.job.name) then cb(nil) return end

	-- 1) Crimes by charge type (top 10, all time)
	MySQL.Async.fetchAll([[
		SELECT law_title AS label, COUNT(*) AS count
		FROM dept_case_charges
		GROUP BY law_title
		ORDER BY count DESC
		LIMIT 10
	]], {}, function(byType)
		-- 2) Arrests per day, last 14 days
		local since = os.time() - (14 * 86400)
		MySQL.Async.fetchAll([[
			SELECT FLOOR(timestamp / 86400) * 86400 AS day, COUNT(*) AS count
			FROM criminal_records
			WHERE type = 'arrest' AND timestamp >= @since
			GROUP BY day
			ORDER BY day ASC
		]], { ['@since'] = since }, function(byDay)
			-- 3) Most active officers (by arrest count, all time)
			MySQL.Async.fetchAll([[
				SELECT officer_name AS label, COUNT(*) AS count
				FROM criminal_records
				WHERE type = 'arrest' AND officer_name IS NOT NULL
				GROUP BY officer_name
				ORDER BY count DESC
				LIMIT 10
			]], {}, function(byOfficer)
				cb({
					crimesByType = byType or {},
					arrestsByDay = byDay or {},
					topOfficers = byOfficer or {},
				})
			end)
		end)
	end)
end)
