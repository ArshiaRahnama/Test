-- ============================================================
-- Court Docket (feature #4)
-- Any DOJ member can put an open case on the docket (schedule a
-- hearing); only the judge job can record the final verdict.
-- A verdict automatically closes the underlying dept_cases case.
-- Requires dept_features_ext.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
local function isDoj(jobname) return DOJ_JOBS[jobname] == true end
local function isJudge(jobname) return jobname == 'judge' end

local DOCKET_STATUS_LABELS = {
	scheduled = 'Zamanbandi Shode',
	held = 'Bargozar Shode',
	rescheduled = 'Taghire Zaman Dade Shode',
	cancelled = 'Laghv Shode',
}

local VERDICT_LABELS = {
	guilty = 'Mojrem',
	not_guilty = 'Bi-Gonah',
	plea_deal = 'Tavafogh (Plea Deal)',
}

-- ============================================================
-- List / detail
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetDocket', function(source, cb, filterStatus)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	local sql = 'SELECT d.id, d.case_id, c.title AS case_title, d.scheduled_at, d.status, d.verdict, d.verdict_notes, d.verdict_by_name '
		.. 'FROM dept_case_docket d JOIN dept_cases c ON c.id = d.case_id '

	local params = {}
	if filterStatus and filterStatus ~= '' then
		sql = sql .. 'WHERE d.status = @status '
		params['@status'] = filterStatus
	end
	sql = sql .. 'ORDER BY d.scheduled_at ASC LIMIT 40'

	MySQL.Async.fetchAll(sql, params, function(rows)
		for _, row in ipairs(rows) do
			row.statusLabel = DOCKET_STATUS_LABELS[row.status] or row.status
			row.verdictLabel = row.verdict and VERDICT_LABELS[row.verdict] or nil
		end
		cb(rows)
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCaseDocket', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT * FROM dept_case_docket WHERE case_id = @id ORDER BY scheduled_at DESC', { ['@id'] = caseId }, function(rows)
		for _, row in ipairs(rows) do
			row.statusLabel = DOCKET_STATUS_LABELS[row.status] or row.status
			row.verdictLabel = row.verdict and VERDICT_LABELS[row.verdict] or nil
		end
		cb(rows)
	end)
end)

-- ============================================================
-- Mutate
-- ============================================================

local function scheduleHearing(caseId, minutesFromNow, createdByName, cb)
	local now = os.time()
	local scheduledAt = now + (minutesFromNow * 60)

	MySQL.Async.insert(
		'INSERT INTO dept_case_docket (case_id, scheduled_at, status, created_by_name, created_at, updated_at) VALUES (@cid, @sched, @status, @by, @ts, @ts)',
		{ ['@cid'] = caseId, ['@sched'] = scheduledAt, ['@status'] = 'scheduled', ['@by'] = createdByName, ['@ts'] = now },
		function(docketId)
			LogCaseEvent(caseId, 'docket', 'Jalase-ye Dadgah Baraye ' .. minutesFromNow .. ' Daghighe Digar Zamanbandi Shod', createdByName)

			-- Notify online DOJ so a judge knows to show up
			local xPlayers = ESX.GetPlayers()
			for i = 1, #xPlayers do
				local xTarget = ESX.GetPlayerFromId(xPlayers[i])
				if xTarget and isDoj(xTarget.job.name) then
					TriggerClientEvent('chatMessage', xTarget.source, "[ DADGAH ]", {90, 30, 160},
						"^7Parvande #" .. caseId .. " Baraye ^3" .. minutesFromNow .. " Daghighe Digar^7 Dar Dadgah Zamanbandi Shod")
				end
			end

			if cb then cb(docketId) end
		end
	)
end

RegisterServerEvent('esx_uniquejobs:dojScheduleHearing')
AddEventHandler('esx_uniquejobs:dojScheduleHearing', function(caseId, minutesFromNow)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	minutesFromNow = tonumber(minutesFromNow)
	if not minutesFromNow or minutesFromNow <= 0 then
		TriggerClientEvent('esx:showNotification', source, '~r~Zaman-e Namotabar')
		return
	end

	scheduleHearing(caseId, minutesFromNow, xPlayer.name, function(docketId)
		TriggerClientEvent('esx:showNotification', source, '~g~Jalase-ye Dadgah Zamanbandi Shod (#' .. docketId .. ')')
	end)
end)

-- ============================================================
-- External export: same as 'esx_uniquejobs:dojScheduleHearing'
-- above, but callable without a DOJ-job player as the triggering
-- source -- e.g. Unique_AllRobs auto-scheduling a hearing for a
-- heavy robbery (bank/Life Invader) the moment a unit engages.
-- exports['esx_uniquejobs']:ScheduleExternalHearing(caseId, minutesFromNow, createdByName, cb)
-- ============================================================
exports('ScheduleExternalHearing', function(caseId, minutesFromNow, createdByName, cb)
	minutesFromNow = tonumber(minutesFromNow)
	if not caseId or not minutesFromNow or minutesFromNow <= 0 then
		if cb then cb(nil) end
		return
	end
	scheduleHearing(caseId, minutesFromNow, createdByName or 'Sisteme Dispatch', cb)
end)

RegisterServerEvent('esx_uniquejobs:dojRescheduleHearing')
AddEventHandler('esx_uniquejobs:dojRescheduleHearing', function(docketId, minutesFromNow)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	minutesFromNow = tonumber(minutesFromNow)
	if not minutesFromNow or minutesFromNow <= 0 then return end

	local now = os.time()
	local scheduledAt = now + (minutesFromNow * 60)

	MySQL.Async.fetchAll('SELECT case_id FROM dept_case_docket WHERE id = @id', { ['@id'] = docketId }, function(rows)
		local docket = rows[1]
		if not docket then return end

		MySQL.Async.execute('UPDATE dept_case_docket SET scheduled_at = @sched, status = @status, updated_at = @ts WHERE id = @id', {
			['@id'] = docketId, ['@sched'] = scheduledAt, ['@status'] = 'rescheduled', ['@ts'] = now,
		}, function()
			LogCaseEvent(docket.case_id, 'docket', 'Jalase-ye Dadgah Taghire Zaman Dad (' .. minutesFromNow .. ' Daghighe Digar)', xPlayer.name)
			TriggerClientEvent('esx:showNotification', source, '~g~Zaman-e Jalase Taghir Kard')
		end)
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojCancelHearing')
AddEventHandler('esx_uniquejobs:dojCancelHearing', function(docketId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	MySQL.Async.fetchAll('SELECT case_id FROM dept_case_docket WHERE id = @id', { ['@id'] = docketId }, function(rows)
		local docket = rows[1]
		if not docket then return end

		MySQL.Async.execute('UPDATE dept_case_docket SET status = @status, updated_at = @ts WHERE id = @id', {
			['@id'] = docketId, ['@status'] = 'cancelled', ['@ts'] = os.time(),
		}, function()
			LogCaseEvent(docket.case_id, 'docket', 'Jalase-ye Dadgah Laghv Shod', xPlayer.name)
			TriggerClientEvent('esx:showNotification', source, '~g~Jalase Laghv Shod')
		end)
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojRecordVerdict')
AddEventHandler('esx_uniquejobs:dojRecordVerdict', function(docketId, verdict, notes)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isJudge(xPlayer.job.name) then
		TriggerClientEvent('esx:showNotification', source, '~r~Faghat Ghazi Mitavanad Hokm Sader Konad')
		return
	end

	if not VERDICT_LABELS[verdict] then
		TriggerClientEvent('esx:showNotification', source, '~r~Hokm-e Namotabar')
		return
	end

	local now = os.time()
	MySQL.Async.fetchAll('SELECT case_id FROM dept_case_docket WHERE id = @id', { ['@id'] = docketId }, function(rows)
		local docket = rows[1]
		if not docket then return end

		MySQL.Async.execute(
			'UPDATE dept_case_docket SET status = @status, verdict = @verdict, verdict_notes = @notes, verdict_by_name = @by, verdict_at = @ts, updated_at = @ts WHERE id = @id',
			{ ['@id'] = docketId, ['@status'] = 'held', ['@verdict'] = verdict, ['@notes'] = notes or '', ['@by'] = xPlayer.name, ['@ts'] = now },
			function()
				LogCaseEvent(docket.case_id, 'verdict', 'Hokm-e Nahaee: ' .. VERDICT_LABELS[verdict] .. (notes and notes ~= '' and (' -- ' .. notes) or ''), xPlayer.name)

				-- Verdict is final -- close the underlying case
				MySQL.Async.execute('UPDATE dept_cases SET status = @status, updated_at = @ts WHERE id = @id', {
					['@id'] = docket.case_id, ['@status'] = 'closed', ['@ts'] = now,
				})

				TriggerClientEvent('esx:showNotification', source, '~g~Hokm Sabt Shod: ' .. VERDICT_LABELS[verdict])

				local xPlayers = ESX.GetPlayers()
				for i = 1, #xPlayers do
					local xTarget = ESX.GetPlayerFromId(xPlayers[i])
					if xTarget and isDoj(xTarget.job.name) then
						TriggerClientEvent('chatMessage', xTarget.source, "[ DADGAH ]", {90, 30, 160},
							"^7Ghazi ^3" .. xPlayer.name .. "^7 Baraye Parvande #" .. docket.case_id .. " Hokm Dad: ^3" .. VERDICT_LABELS[verdict])
					end
				end
			end
		)
	end)
end)
