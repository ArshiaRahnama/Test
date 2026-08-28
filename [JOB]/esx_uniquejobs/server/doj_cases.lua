-- ============================================================
-- DOJ Case Files (expanded, persistent)
-- Replaces the old in-memory single-suspect case system that
-- used to live in doj_manager.lua. Cases now:
--   - persist across restarts (doj_cases + 3 related tables)
--   - support multiple suspects, not just one
--   - track charges filed against the case, pulled straight
--     from the (now persistent, judge-editable) law codebook
--   - separate notes from evidence entries
--   - richer status: open / investigating / trial / closed / dismissed
--   - keep referral-to-another-department from before
-- Requires law_and_cases.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }

local function isDoj(jobname)
	return DOJ_JOBS[jobname] == true
end

local STATUS_LABELS = {
	open = 'Baz',
	investigating = 'Dar Hale Tahghigh',
	trial = 'Dar Hale Mohakeme',
	closed = 'Baste Shode',
	dismissed = 'Rad Shode',
}

local PRIORITY_LABELS = {
	low = 'Paeen',
	medium = 'Motevaset',
	high = 'Bala',
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

-- ============================================================
-- List / detail
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCases', function(source, cb, filterStatus, searchSuspect)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	if searchSuspect and searchSuspect ~= '' then
		MySQL.Async.fetchAll(
			'SELECT DISTINCT c.id, c.title, c.status, c.priority, c.lead_officer_name, c.referred_to, c.created_at FROM doj_cases c ' ..
			'JOIN doj_case_suspects s ON s.case_id = c.id WHERE s.name LIKE @name ORDER BY c.id DESC LIMIT 30',
			{ ['@name'] = '%' .. searchSuspect .. '%' },
			function(rows) cb(rows) end
		)
		return
	end

	if filterStatus and filterStatus ~= '' then
		MySQL.Async.fetchAll('SELECT id, title, status, priority, lead_officer_name, referred_to, created_at FROM doj_cases WHERE status = @status ORDER BY id DESC LIMIT 30', {
			['@status'] = filterStatus,
		}, function(rows) cb(rows) end)
		return
	end

	MySQL.Async.fetchAll('SELECT id, title, status, priority, lead_officer_name, referred_to, created_at FROM doj_cases ORDER BY id DESC LIMIT 30', {}, function(rows)
		cb(rows)
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCaseDetail', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT * FROM doj_cases WHERE id = @id', { ['@id'] = caseId }, function(caseRows)
		local case = caseRows[1]
		if not case then cb(nil) return end

		MySQL.Async.fetchAll('SELECT id, name FROM doj_case_suspects WHERE case_id = @id ORDER BY id', { ['@id'] = caseId }, function(suspects)
			MySQL.Async.fetchAll('SELECT note_type, text, by_name, timestamp FROM doj_case_notes WHERE case_id = @id ORDER BY timestamp DESC', { ['@id'] = caseId }, function(notes)
				MySQL.Async.fetchAll('SELECT id, law_code, law_title, fine, jail_minutes FROM doj_case_charges WHERE case_id = @id ORDER BY id', { ['@id'] = caseId }, function(charges)
					local totalFine, totalJail = 0, 0
					for _, charge in ipairs(charges) do
						totalFine = totalFine + charge.fine
						totalJail = totalJail + charge.jail_minutes
					end

					cb({
						id = case.id,
						title = case.title,
						status = case.status,
						statusLabel = STATUS_LABELS[case.status] or case.status,
						priority = case.priority,
						ageMinutes = math.floor((os.time() - case.created_at) / 60),
						openedByName = case.opened_by_name,
						openedByJob = case.opened_by_job,
						leadOfficerName = case.lead_officer_name,
						referredTo = case.referred_to,
						suspects = suspects,
						notes = notes,
						charges = charges,
						totalFine = totalFine,
						totalJail = totalJail,
					})
				end)
			end)
		end)
	end)
end)

-- ============================================================
-- Create / mutate
-- ============================================================

RegisterServerEvent('esx_uniquejobs:dojOpenCase')
AddEventHandler('esx_uniquejobs:dojOpenCase', function(title, priority, suspectQuery)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not title or title == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Onvan-e Parvande Khali Ast')
		return
	end

	if not PRIORITY_LABELS[priority] then priority = 'medium' end

	local now = os.time()

	MySQL.Async.insert(
		'INSERT INTO doj_cases (title, status, priority, opened_by_name, opened_by_job, lead_officer_name, created_at, updated_at) VALUES (@title, @status, @priority, @by, @byjob, @lead, @ts, @ts)',
		{
			['@title'] = title,
			['@status'] = 'open',
			['@priority'] = priority,
			['@by'] = xPlayer.name,
			['@byjob'] = string.upper(xPlayer.job.name),
			['@lead'] = xPlayer.name,
			['@ts'] = now,
		},
		function(caseId)
			TriggerClientEvent('esx:showNotification', source, '~g~Parvande #' .. caseId .. ' Baz Shod')

			if suspectQuery and suspectQuery ~= '' then
				resolveIdentifier(suspectQuery, function(identifier, name)
					if not name then return end
					MySQL.Async.execute('INSERT INTO doj_case_suspects (case_id, identifier, name, added_by, timestamp) VALUES (@cid, @id, @name, @by, @ts)', {
						['@cid'] = caseId, ['@id'] = identifier, ['@name'] = name, ['@by'] = xPlayer.name, ['@ts'] = now,
					})
				end)
			end
		end
	)
end)

RegisterServerEvent('esx_uniquejobs:dojAddSuspect')
AddEventHandler('esx_uniquejobs:dojAddSuspect', function(caseId, suspectQuery)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not suspectQuery or suspectQuery == '' then return end

	resolveIdentifier(suspectQuery, function(identifier, name)
		if not name then
			TriggerClientEvent('esx:showNotification', source, '~r~Bazikon Peida Nashod')
			return
		end

		MySQL.Async.execute('INSERT INTO doj_case_suspects (case_id, identifier, name, added_by, timestamp) VALUES (@cid, @id, @name, @by, @ts)', {
			['@cid'] = caseId, ['@id'] = identifier, ['@name'] = name, ['@by'] = xPlayer.name, ['@ts'] = os.time(),
		}, function()
			TriggerClientEvent('esx:showNotification', source, '~g~' .. name .. ' Be Parvande Ezafe Shod')
		end)
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojAddCaseNote')
AddEventHandler('esx_uniquejobs:dojAddCaseNote', function(caseId, noteType, text)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not text or text == '' then return end

	MySQL.Async.execute('INSERT INTO doj_case_notes (case_id, note_type, text, by_name, timestamp) VALUES (@cid, @type, @text, @by, @ts)', {
		['@cid'] = caseId, ['@type'] = noteType or 'note', ['@text'] = text, ['@by'] = xPlayer.name, ['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Ezafe Shod Be Parvande #' .. caseId)
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojAddCharge')
AddEventHandler('esx_uniquejobs:dojAddCharge', function(caseId, lawId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	MySQL.Async.fetchAll('SELECT code, title, fine, jail_minutes FROM law_codebook WHERE id = @id', { ['@id'] = lawId }, function(rows)
		local law = rows[1]
		if not law then
			TriggerClientEvent('esx:showNotification', source, '~r~Ghanoon Peida Nashod')
			return
		end

		-- Snapshot the law's current fine/jail at time of charging, so a
		-- later edit to the codebook doesn't rewrite history on old cases
		MySQL.Async.execute('INSERT INTO doj_case_charges (case_id, law_code, law_title, fine, jail_minutes, added_by, timestamp) VALUES (@cid, @code, @title, @fine, @jail, @by, @ts)', {
			['@cid'] = caseId, ['@code'] = law.code, ['@title'] = law.title,
			['@fine'] = law.fine, ['@jail'] = law.jail_minutes, ['@by'] = xPlayer.name, ['@ts'] = os.time(),
		}, function()
			TriggerClientEvent('esx:showNotification', source, '~g~Etteham "' .. law.title .. '" Be Parvande Ezafe Shod')
		end)
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojSetCaseStatus')
AddEventHandler('esx_uniquejobs:dojSetCaseStatus', function(caseId, status)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not STATUS_LABELS[status] then return end

	MySQL.Async.execute('UPDATE doj_cases SET status = @status, updated_at = @ts WHERE id = @id', {
		['@id'] = caseId, ['@status'] = status, ['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Vaziat-e Parvande #' .. caseId .. ' Be "' .. STATUS_LABELS[status] .. '" Taghir Kard')
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojSetCasePriority')
AddEventHandler('esx_uniquejobs:dojSetCasePriority', function(caseId, priority)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not PRIORITY_LABELS[priority] then return end

	MySQL.Async.execute('UPDATE doj_cases SET priority = @priority, updated_at = @ts WHERE id = @id', {
		['@id'] = caseId, ['@priority'] = priority, ['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Ahamiyat-e Parvande #' .. caseId .. ' Be "' .. PRIORITY_LABELS[priority] .. '" Taghir Kard')
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojAssignLead')
AddEventHandler('esx_uniquejobs:dojAssignLead', function(caseId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	MySQL.Async.execute('UPDATE doj_cases SET lead_officer_name = @name, updated_at = @ts WHERE id = @id', {
		['@id'] = caseId, ['@name'] = xPlayer.name, ['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Shoma Massol-e Parvande #' .. caseId .. ' Shodid')
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojReferCase')
AddEventHandler('esx_uniquejobs:dojReferCase', function(caseId, targetJob)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not targetJob or not DOJ_JOBS[targetJob] then return end

	MySQL.Async.fetchAll('SELECT title FROM doj_cases WHERE id = @id', { ['@id'] = caseId }, function(rows)
		local case = rows[1]
		if not case then return end

		MySQL.Async.execute('UPDATE doj_cases SET referred_to = @job, updated_at = @ts WHERE id = @id', {
			['@id'] = caseId, ['@job'] = string.upper(targetJob), ['@ts'] = os.time(),
		}, function()
			local xPlayers = ESX.GetPlayers()
			for i = 1, #xPlayers do
				local xTarget = ESX.GetPlayerFromId(xPlayers[i])
				if xTarget and xTarget.job.name == targetJob then
					TriggerClientEvent('chatMessage', xTarget.source, "[ DOJ ]", {90, 30, 160},
						"^7Parvande #" .. caseId .. " (" .. case.title .. ") Az Taraf ^3" .. xPlayer.name .. "^7 Be Shoma Erja Shod")
				end
			end
			TriggerClientEvent('esx:showNotification', source, '~g~Parvande Be ' .. string.upper(targetJob) .. ' Erja Shod')
		end)
	end)
end)
