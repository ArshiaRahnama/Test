-- ============================================================
-- Case Timeline (feature #5)
-- Instead of notes/evidence/charges/status living in separate,
-- disconnected lists inside a case, this gives one chronological
-- feed of everything that ever happened on a dept_cases case.
--
-- Doesn't touch server/doj_cases.lua at all -- it just attaches a
-- SECOND handler to the same events that file already registers
-- (FiveM calls every handler bound to an event, so both run), and
-- logs a one-line summary of each into dept_case_events. The case's
-- own "opened" moment isn't logged as an event (dojOpenCase only
-- gets a caseId back asynchronously from the DB insert, too late
-- for this second handler to see), so GetCaseTimeline synthesizes
-- that first entry straight from the dept_cases row itself.
-- Requires dept_features_ext.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
local function isDoj(jobname) return DOJ_JOBS[jobname] == true end

-- Exposed globally so court_docket.lua (and anything else) can log into
-- the same timeline without duplicating this insert.
function LogCaseEvent(caseId, eventType, text, byName)
	if not caseId then return end
	MySQL.Async.execute(
		'INSERT INTO dept_case_events (case_id, event_type, text, by_name, timestamp) VALUES (@cid, @type, @text, @by, @ts)',
		{ ['@cid'] = caseId, ['@type'] = eventType, ['@text'] = text, ['@by'] = byName or 'Namoshakhas', ['@ts'] = os.time() }
	)
end

AddEventHandler('esx_uniquejobs:dojAddSuspect', function(caseId, suspectQuery)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	LogCaseEvent(caseId, 'suspect_added', 'Jostoju Baraye Mozanne: "' .. tostring(suspectQuery) .. '"', xPlayer.name)
end)

AddEventHandler('esx_uniquejobs:dojAddCaseNote', function(caseId, noteType, text)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) or not text or text == '' then return end
	LogCaseEvent(caseId, noteType == 'evidence' and 'evidence' or 'note', text, xPlayer.name)
end)

AddEventHandler('esx_uniquejobs:dojAddCharge', function(caseId, lawId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	MySQL.Async.fetchAll('SELECT code, title FROM law_codebook WHERE id = @id', { ['@id'] = lawId }, function(rows)
		local law = rows[1]
		if not law then return end
		LogCaseEvent(caseId, 'charge', 'Etteham Ezafe Shod: ' .. law.code .. ' -- ' .. law.title, xPlayer.name)
	end)
end)

AddEventHandler('esx_uniquejobs:dojSetCaseStatus', function(caseId, status)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	LogCaseEvent(caseId, 'status', 'Vaziat-e Parvande Be "' .. tostring(status) .. '" Taghir Kard', xPlayer.name)
end)

AddEventHandler('esx_uniquejobs:dojSetCasePriority', function(caseId, priority)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	LogCaseEvent(caseId, 'priority', 'Ahamiyat Be "' .. tostring(priority) .. '" Taghir Kard', xPlayer.name)
end)

AddEventHandler('esx_uniquejobs:dojAssignLead', function(caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	LogCaseEvent(caseId, 'lead', xPlayer.name .. ' Massol-e Parvande Shod', xPlayer.name)
end)

AddEventHandler('esx_uniquejobs:dojReferCase', function(caseId, targetJob)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end
	LogCaseEvent(caseId, 'referred', 'Parvande Be ' .. string.upper(tostring(targetJob)) .. ' Erja Shod', xPlayer.name)
end)

-- ============================================================
-- Aggregator
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCaseTimeline', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT title, opened_by_name, created_at FROM dept_cases WHERE id = @id', { ['@id'] = caseId }, function(caseRows)
		local case = caseRows[1]
		if not case then cb(nil) return end

		MySQL.Async.fetchAll('SELECT event_type, text, by_name, timestamp FROM dept_case_events WHERE case_id = @id ORDER BY timestamp ASC', { ['@id'] = caseId }, function(events)
			local timeline = {
				{
					eventType = 'opened',
					text = 'Parvande "' .. case.title .. '" Baz Shod',
					byName = case.opened_by_name,
					timestamp = case.created_at,
				},
			}

			for _, e in ipairs(events) do
				timeline[#timeline + 1] = { eventType = e.event_type, text = e.text, byName = e.by_name, timestamp = e.timestamp }
			end

			-- newest first
			table.sort(timeline, function(a, b) return a.timestamp > b.timestamp end)
			cb(timeline)
		end)
	end)
end)
