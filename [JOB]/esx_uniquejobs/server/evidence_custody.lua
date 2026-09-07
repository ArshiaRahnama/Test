-- ============================================================
-- Evidence Chain of Custody (extension of feature #5)
-- Every evidence entry (dept_case_notes row with note_type='evidence')
-- gets its own hand-off log: when it moves from one department/officer
-- to another (e.g. CID refers a case to CIA and physically hands over
-- the evidence), that transfer is logged with who/whom/when/why.
-- The very first "collected by X" link isn't a stored row -- it's
-- synthesized from the evidence note itself (same trick used for the
-- case timeline's "opened" entry), so nothing about how evidence is
-- currently logged (server/doj_cases.lua) needs to change.
-- Every transfer also gets pushed into the case's unified timeline
-- (feature #5) via LogCaseEvent, defined in server/case_timeline.lua.
-- Requires dept_features_ext.sql AND rap_sheet_and_custody_ext.sql.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
local function isDoj(jobname) return DOJ_JOBS[jobname] == true end

-- ============================================================
-- List evidence items for a case
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCaseEvidence', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll(
		"SELECT id, text, by_name, timestamp FROM dept_case_notes WHERE case_id = @id AND note_type = 'evidence' ORDER BY timestamp DESC",
		{ ['@id'] = caseId },
		function(rows) cb(rows) end
	)
end)

-- ============================================================
-- Full custody chain for one evidence item
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetEvidenceCustody', function(source, cb, noteId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll("SELECT id, case_id, text, by_name, timestamp FROM dept_case_notes WHERE id = @id AND note_type = 'evidence'", { ['@id'] = noteId }, function(noteRows)
		local note = noteRows[1]
		if not note then cb(nil) return end

		MySQL.Async.fetchAll('SELECT from_name, from_job, to_name, to_job, reason, timestamp FROM dept_evidence_custody WHERE note_id = @id ORDER BY timestamp ASC', { ['@id'] = noteId }, function(transfers)
			local chain = {
				{
					text = 'Jam-avari Shod Tavasote ' .. note.by_name,
					byName = note.by_name,
					timestamp = note.timestamp,
				},
			}
			for _, t in ipairs(transfers) do
				chain[#chain + 1] = {
					text = t.from_name .. ' (' .. string.upper(t.from_job) .. ') -> ' .. t.to_name .. ' (' .. string.upper(t.to_job) .. ')' .. (t.reason ~= '' and (' -- ' .. t.reason) or ''),
					byName = t.from_name,
					timestamp = t.timestamp,
				}
			end

			cb({ note = note, chain = chain })
		end)
	end)
end)

-- ============================================================
-- Transfer custody
-- ============================================================

RegisterServerEvent('esx_uniquejobs:dojTransferEvidence')
AddEventHandler('esx_uniquejobs:dojTransferEvidence', function(noteId, toName, toJob, reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not toName or toName == '' or not DOJ_JOBS[toJob] then
		TriggerClientEvent('esx:showNotification', source, '~r~Gerande Ya Department Namotabar')
		return
	end

	MySQL.Async.fetchAll("SELECT case_id, text FROM dept_case_notes WHERE id = @id AND note_type = 'evidence'", { ['@id'] = noteId }, function(rows)
		local note = rows[1]
		if not note then
			TriggerClientEvent('esx:showNotification', source, '~r~Madrak Peida Nashod')
			return
		end

		local now = os.time()
		MySQL.Async.execute(
			'INSERT INTO dept_evidence_custody (note_id, case_id, from_name, from_job, to_name, to_job, reason, timestamp) VALUES (@nid, @cid, @fname, @fjob, @tname, @tjob, @reason, @ts)',
			{
				['@nid'] = noteId, ['@cid'] = note.case_id,
				['@fname'] = xPlayer.name, ['@fjob'] = xPlayer.job.name,
				['@tname'] = toName, ['@tjob'] = toJob,
				['@reason'] = reason or '', ['@ts'] = now,
			},
			function()
				LogCaseEvent(
					note.case_id,
					'evidence_transfer',
					'Madrak "' .. note.text .. '" Az ' .. xPlayer.name .. ' (' .. string.upper(xPlayer.job.name) .. ') Be '
						.. toName .. ' (' .. string.upper(toJob) .. ') Montaghel Shod' .. (reason and reason ~= '' and (' -- ' .. reason) or ''),
					xPlayer.name
				)
				TriggerClientEvent('esx:showNotification', source, '~g~Enteghal-e Madrak Sabt Shod')
			end
		)
	end)
end)
