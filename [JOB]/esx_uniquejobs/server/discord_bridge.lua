-- ============================================================
-- Discord bridge: /doj + /law + /cad  <->  Unique_Phone's Discord app
--
--   * search-warrant events -> court-docket (judges) + department #warrants
--   * court hearings -> #court-docket + a heads-up to everyone involved
--     who is online (+ reminders 10 min before and at the start)
--   * CAD wanted-level changes / panic -> every LE department's #dispatch
--   * with an APPROVED search warrant an officer can export a suspect's
--     Discord messages as case evidence (chain of custody applies: the
--     export becomes an 'evidence' note on the case)
--
-- Everything talks to the phone through its exports, guarded so that a
-- stopped/missing phone resource never breaks the justice system.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

DiscordBridge = {}

local function C() return Config_discordbridge end

local function phoneUp()
	return C() and GetResourceState(C().Resource) == 'started'
end

local function phone(fnName, ...)
	if not phoneUp() then return nil end
	local args = { ... }
	local ok, res = pcall(function() return exports[C().Resource][fnName](exports[C().Resource], table.unpack(args)) end)
	if not ok then
		print(('[esx_uniquejobs] Discord bridge: %s failed: %s'):format(fnName, tostring(res)))
		return nil
	end
	return res
end

local function post(job, channel, text, label) return phone('DiscordPostToJob', job, channel, text, label) end
local function notifyIdentifiers(list, text, kind) return phone('DiscordNotifyIdentifiers', list, text, kind) end
local function notifyJobs(list, text, kind) return phone('DiscordNotifyJobs', list, text, kind) end

local function clock(ts) return os.date('%H:%M', ts) end
local function stamp(ts) return os.date('%Y-%m-%d %H:%M', ts) end

local function leJobList()
	local out = {}
	for j in pairs(LeJobSet or {}) do out[#out + 1] = j end
	table.sort(out)
	return out
end

-- chat + ESX notification for people who are in the city right now
local function tellPlayer(xPlayer, label, text)
	TriggerClientEvent('chatMessage', xPlayer.source, label, { 90, 30, 160 }, text)
end

-- ============================================================
-- Warrants
-- ============================================================

function DiscordBridge.WarrantEvent(kind, w, actor)
	if not phoneUp() then return end
	local C_ = C()
	local typeLabel = w.warrantType == 'search' and 'search' or 'arrest'
	local text

	if kind == 'requested' then
		text = ('**New %s warrant request #%d**\nTarget: **%s**\nRequested by: %s (%s)\nReason: %s'):format(typeLabel, w.id, w.targetName, w.requestedByName, w.requestedByJob, w.reason)
		post(C_.Court.job, C_.Court.channel, text, 'Warrants')
		notifyJobs({ C_.Court.job, 'marshal' }, ('New %s warrant request #%d for %s'):format(typeLabel, w.id, w.targetName), 'warn')
		return
	elseif kind == 'approved' then
		text = ('**Warrant #%d APPROVED** (%s)\nTarget: **%s**\nIssued by: %s\nRequested by: %s (%s)\nValid for %d minutes.'):format(
			w.id, typeLabel, w.targetName, actor.name, w.requestedByName, w.requestedByJob, C_.WarrantTTLMinutes or 180)
	elseif kind == 'denied' then
		text = ('**Warrant #%d denied** (%s) for %s — by %s'):format(w.id, typeLabel, w.targetName, actor.name)
	elseif kind == 'revoked' then
		text = ('**Warrant #%d REVOKED** (%s) for %s — by %s'):format(w.id, typeLabel, w.targetName, actor.name)
	else
		return
	end

	post(C_.Court.job, C_.Court.channel, text, 'Warrants')
	for _, extra in ipairs(C_.CourtAlsoPost or {}) do post(extra, C_.Court.channel, text, 'Warrants') end
	-- the requesting department sees the outcome in its own #warrants
	local reqJob = string.lower(w.requestedByJob or '')
	if reqJob ~= '' and reqJob ~= C_.Court.job then post(reqJob, C_.WarrantChannel, text, 'Warrants') end

	if w.requestedBySource then
		local requester = ESX.GetPlayerFromId(w.requestedBySource)
		if requester and requester.name == w.requestedByName then
			notifyIdentifiers({ requester.identifier }, ('Warrant #%d: %s'):format(w.id, kind), kind == 'approved' and 'success' or 'warn')
		end
	end
end

-- ============================================================
-- Court hearings
-- ============================================================

local function loadCase(caseId, cb)
	MySQL.Async.fetchAll('SELECT id, title, opened_by_name, lead_officer_name FROM dept_cases WHERE id = @id', { ['@id'] = caseId }, function(rows)
		local case = rows[1]
		if not case then cb(nil) return end
		MySQL.Async.fetchAll('SELECT identifier, name FROM dept_case_suspects WHERE case_id = @id', { ['@id'] = caseId }, function(suspects)
			cb(case, suspects or {})
		end)
	end)
end

local function playersByName(names)
	local wanted, out = {}, {}
	for _, n in ipairs(names) do if n and n ~= '' then wanted[n] = true end end
	for _, pid in ipairs(ESX.GetPlayers()) do
		local p = ESX.GetPlayerFromId(pid)
		if p and wanted[p.name] then out[#out + 1] = p end
	end
	return out
end

local function relative(ts)
	local diff = ts - os.time()
	if diff <= 0 then return 'now' end
	if diff < 3600 then return ('in %d min'):format(math.ceil(diff / 60)) end
	return ('in %dh %02dm'):format(math.floor(diff / 3600), math.floor((diff % 3600) / 60))
end

-- kind: scheduled | rescheduled | cancelled | verdict | reminder | start
function DiscordBridge.HearingEvent(kind, docketId, caseId, scheduledAt, byName, verdictLabel, notes)
	if not phoneUp() then return end
	loadCase(caseId, function(case, suspects)
		if not case then return end
		local C_ = C()
		local names, identifiers = {}, {}
		for _, s in ipairs(suspects) do
			names[#names + 1] = s.name
			if s.identifier then identifiers[#identifiers + 1] = s.identifier end
		end
		local defendants = #names > 0 and table.concat(names, ', ') or 'unknown'
		local head = ('Case #%d "%s"'):format(case.id, case.title)
		local text, short

		if kind == 'scheduled' or kind == 'rescheduled' then
			local verb = kind == 'scheduled' and 'scheduled' or 'RESCHEDULED'
			text = ('**Hearing %s** — %s\nTime: **%s** (%s)\nDefendant(s): %s\nLead officer: %s\nSet by: %s'):format(
				verb, head, clock(scheduledAt), relative(scheduledAt), defendants, case.lead_officer_name or '-', byName or '-')
			short = ('Court hearing %s: case #%d at %s (%s)'):format(verb:lower(), case.id, clock(scheduledAt), relative(scheduledAt))
		elseif kind == 'reminder' then
			text = ('**Hearing starts %s** — %s\nTime: **%s**\nDefendant(s): %s\nLead officer: %s'):format(relative(scheduledAt), head, clock(scheduledAt), defendants, case.lead_officer_name or '-')
			short = ('Court hearing for case #%d starts %s (%s)'):format(case.id, relative(scheduledAt), clock(scheduledAt))
		elseif kind == 'start' then
			text = ('**Hearing is starting NOW** — %s\nDefendant(s): %s\nLead officer: %s'):format(head, defendants, case.lead_officer_name or '-')
			short = ('Court hearing for case #%d is starting now'):format(case.id)
		elseif kind == 'cancelled' then
			text = ('**Hearing cancelled** — %s\nCancelled by: %s'):format(head, byName or '-')
			short = ('Court hearing for case #%d was cancelled'):format(case.id)
		elseif kind == 'verdict' then
			text = ('**Verdict recorded** — %s\nDefendant(s): %s\nVerdict: **%s**%s\nJudge: %s'):format(
				head, defendants, verdictLabel or '-', (notes and notes ~= '') and ('\nNotes: ' .. notes) or '', byName or '-')
			short = ('Verdict for case #%d: %s'):format(case.id, verdictLabel or '-')
		else
			return
		end

		-- 1) the judges' channel
		post(C_.Court.job, C_.Court.channel, text, 'Court')
		for _, extra in ipairs(C_.CourtAlsoPost or {}) do post(extra, C_.Court.channel, text, 'Court') end

		-- 2) everybody involved who is online right now
		notifyIdentifiers(identifiers, short, kind == 'cancelled' and 'warn' or 'info')
		local officers = playersByName({ case.opened_by_name, case.lead_officer_name })
		local officerIds = {}
		for _, p in ipairs(officers) do officerIds[#officerIds + 1] = p.identifier end
		notifyIdentifiers(officerIds, short, 'info')
		notifyJobs(C_.HearingNotifyJobs or {}, short, 'info')

		-- chat line too: the phone might be in a pocket and the toast missed
		local sent = {}
		local function chat(p) if p and not sent[p.source] then sent[p.source] = true; tellPlayer(p, '[ COURT ]', '^7' .. short) end end
		for _, p in ipairs(officers) do chat(p) end
		for _, id in ipairs(identifiers) do chat(ESX.GetPlayerFromIdentifier(id)) end
		for _, job in ipairs(C_.HearingNotifyJobs or {}) do
			for _, pid in ipairs(ESX.GetPlayers()) do
				local p = ESX.GetPlayerFromId(pid)
				if p and p.job.name == job then chat(p) end
			end
		end
	end)
end

-- reminder loop: 10 minutes before + at the start of each hearing
local reminded = {}
CreateThread(function()
	Wait(20000)
	while true do
		local C_ = C()
		if C_ and phoneUp() then
			local now = os.time()
			local pre = (C_.ReminderMinutesBefore or 10) * 60
			MySQL.Async.fetchAll([[SELECT id, case_id, scheduled_at FROM dept_case_docket
				WHERE status IN ('scheduled','rescheduled') AND scheduled_at BETWEEN @lo AND @hi]], {
				['@lo'] = now - 120, ['@hi'] = now + pre,
			}, function(rows)
				for _, d in ipairs(rows or {}) do
					local key = d.id .. ':' .. d.scheduled_at
					local state = reminded[key] or {}
					local left = d.scheduled_at - now
					if left > 0 and left <= pre and not state.pre and (C_.ReminderMinutesBefore or 0) > 0 then
						state.pre = true
						DiscordBridge.HearingEvent('reminder', d.id, d.case_id, d.scheduled_at)
					elseif left <= 0 and not state.now and C_.RemindStart ~= false then
						state.now = true
						DiscordBridge.HearingEvent('start', d.id, d.case_id, d.scheduled_at)
					end
					reminded[key] = state
				end
			end)
		end
		Wait(30000)
	end
end)

-- ============================================================
-- CAD feed
-- ============================================================

function DiscordBridge.CadWanted(src, newStatus, steam)
	if not phoneUp() or not steam then return end
	MySQL.Async.fetchScalar('SELECT playerName FROM users WHERE identifier = @i', { ['@i'] = steam }, function(name)
		local officer = GetPlayerName(src) or 'CAD'
		local status = tostring(newStatus)
		local text
		if status == 'standard' then
			text = ('**Wanted status cleared** — %s (by %s)'):format(name or 'unknown', officer)
		else
			text = ('**WANTED** — %s is now flagged: **%s** (by %s)'):format(name or 'unknown', status, officer)
		end
		for _, job in ipairs(leJobList()) do post(job, C().DispatchChannel, text, 'CAD') end
	end)
end

function DiscordBridge.Panic(xPlayer, isDistress, requestId)
	if not phoneUp() then return end
	local text
	if isDistress then
		text = ('**PANIC — officer in danger** — %s (%s) | request #%d | respond with /resp %d'):format(xPlayer.name, string.upper(xPlayer.job.name), requestId, requestId)
	else
		text = ('**Backup requested** — %s (%s) | request #%d | respond with /resp %d'):format(xPlayer.name, string.upper(xPlayer.job.name), requestId, requestId)
	end
	for _, job in ipairs(leJobList()) do post(job, C().DispatchChannel, text, 'CAD') end
end

-- ============================================================
-- Evidence export (needs an approved SEARCH warrant)
-- ============================================================

local exportCooldown = {}

local function isDojJob(name) return DojJobSet and DojJobSet[name] == true end

ESX.RegisterServerCallback('esx_uniquejobs:discordGetWarrants', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not C().ExportJobs[xPlayer.job.name] then cb(nil) return end
	cb(DojWarrantAPI.ListActiveSearchFor(xPlayer))
end)

ESX.RegisterServerCallback('esx_uniquejobs:discordGetCases', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not C().ExportJobs[xPlayer.job.name] then cb(nil) return end
	local sql, params
	if isDojJob(xPlayer.job.name) then
		sql = "SELECT id, title FROM dept_cases WHERE status <> 'closed' ORDER BY id DESC LIMIT 25"
		params = {}
	else
		sql = "SELECT id, title FROM dept_cases WHERE status <> 'closed' AND (opened_by_name = @n OR lead_officer_name = @n) ORDER BY id DESC LIMIT 25"
		params = { ['@n'] = xPlayer.name }
	end
	MySQL.Async.fetchAll(sql, params, function(rows) cb(rows or {}) end)
end)

local function caseAllowed(xPlayer, case)
	return isDojJob(xPlayer.job.name) or case.opened_by_name == xPlayer.name or case.lead_officer_name == xPlayer.name
end

-- warrantId, caseId (nil/0 = open a new case for this suspect)
ESX.RegisterServerCallback('esx_uniquejobs:discordExport', function(source, cb, warrantId, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not C().ExportJobs[xPlayer.job.name] then cb({ ok = false, error = 'NO_ACCESS' }) return end
	if not phoneUp() then cb({ ok = false, error = 'PHONE_OFFLINE' }) return end

	local last = exportCooldown[source] or 0
	if os.time() - last < (C().ExportCooldownSeconds or 20) then cb({ ok = false, error = 'COOLDOWN' }) return end

	local w = DojWarrantAPI.Get(warrantId)
	if not DojWarrantAPI.IsUsable(w) then cb({ ok = false, error = 'WARRANT_INVALID' }) return end
	if not (w.requestedByName == xPlayer.name or isDojJob(xPlayer.job.name)) then cb({ ok = false, error = 'NOT_YOURS' }) return end
	if (w.exportCount or 0) >= (C().MaxExportsPerWarrant or 2) then cb({ ok = false, error = 'LIMIT' }) return end

	exportCooldown[source] = os.time()

	local function run(finalCaseId)
		local res = phone('DiscordExportEvidence', source, w.targetIdentifier, { warrantRef = 'W' .. w.id, caseRef = 'C' .. finalCaseId })
		if not res or not res.ok then cb({ ok = false, error = 'EXPORT_FAILED' }) return end
		DojWarrantAPI.Consume(w.id)

		local summary = ('[Discord export] Warrant #%d - %s: %d message(s) from %d server(s), last %d day(s)%s. Checksum %s.'):format(
			w.id, w.targetName, res.total, #res.servers, res.days or 0, res.truncated and ' (truncated)' or '', res.checksum)

		local now = os.time()
		MySQL.Async.insert('INSERT INTO dept_case_notes (case_id, note_type, text, by_name, timestamp) VALUES (@cid, @type, @text, @by, @ts)', {
			['@cid'] = finalCaseId, ['@type'] = 'evidence', ['@text'] = summary, ['@by'] = xPlayer.name, ['@ts'] = now,
		}, function(noteId)
			local payload = json.encode({ servers = res.servers, messages = res.messages, truncated = res.truncated, days = res.days })
			MySQL.Async.insert([[INSERT INTO dept_discord_evidence
				(case_id, note_id, warrant_id, suspect_identifier, suspect_name, exported_by_identifier, exported_by_name, exported_by_job,
				 msg_count, server_count, checksum, payload, exported_at)
				VALUES (@cid, @nid, @wid, @sid, @sname, @bid, @bname, @bjob, @mc, @sc, @ck, @pl, @ts)]], {
				['@cid'] = finalCaseId, ['@nid'] = noteId, ['@wid'] = w.id, ['@sid'] = w.targetIdentifier, ['@sname'] = w.targetName,
				['@bid'] = xPlayer.identifier, ['@bname'] = xPlayer.name, ['@bjob'] = string.upper(xPlayer.job.name),
				['@mc'] = res.total, ['@sc'] = #res.servers, ['@ck'] = res.checksum, ['@pl'] = payload, ['@ts'] = now,
			}, function(evidenceId)
				LogCaseEvent(finalCaseId, 'evidence', summary, xPlayer.name)
				-- transparency (no content): the department and the judges can see THAT an export happened
				local line = ('Discord evidence export under warrant #%d — %d message(s) for case #%d, by %s (%s).'):format(w.id, res.total, finalCaseId, xPlayer.name, string.upper(xPlayer.job.name))
				post(C().Court.job, C().Court.channel, '**' .. line .. '**', 'Warrants')
				post(xPlayer.job.name, C().WarrantChannel, '**' .. line .. '**', 'Warrants')
				cb({ ok = true, evidenceId = evidenceId, caseId = finalCaseId, total = res.total, servers = #res.servers, truncated = res.truncated, empty = res.empty })
			end)
		end)
	end

	caseId = tonumber(caseId)
	if caseId and caseId > 0 then
		MySQL.Async.fetchAll('SELECT id, status, opened_by_name, lead_officer_name FROM dept_cases WHERE id = @id', { ['@id'] = caseId }, function(rows)
			local case = rows[1]
			if not case or case.status == 'closed' or not caseAllowed(xPlayer, case) then cb({ ok = false, error = 'CASE_INVALID' }) exportCooldown[source] = nil return end
			MySQL.Async.fetchScalar('SELECT COUNT(*) FROM dept_case_suspects WHERE case_id = @c AND identifier = @i', { ['@c'] = caseId, ['@i'] = w.targetIdentifier }, function(n)
				if (n or 0) == 0 then
					MySQL.Async.execute('INSERT INTO dept_case_suspects (case_id, identifier, name, added_by, timestamp) VALUES (@c, @i, @n, @by, @ts)', {
						['@c'] = caseId, ['@i'] = w.targetIdentifier, ['@n'] = w.targetName, ['@by'] = xPlayer.name, ['@ts'] = os.time(),
					})
				end
				run(caseId)
			end)
		end)
	else
		CreateExternalCase({
			title = 'Discord evidence - ' .. w.targetName,
			priority = 'medium',
			openedByName = xPlayer.name,
			openedByJob = xPlayer.job.name,
			suspects = { { identifier = w.targetIdentifier, name = w.targetName } },
		}, function(newCaseId)
			if not newCaseId then cb({ ok = false, error = 'CASE_INVALID' }) exportCooldown[source] = nil return end
			run(newCaseId)
		end)
	end
end)

local function canReadEvidence(xPlayer, row)
	return isDojJob(xPlayer.job.name) or row.exported_by_identifier == xPlayer.identifier
end

ESX.RegisterServerCallback('esx_uniquejobs:discordGetEvidenceList', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not tonumber(caseId) then cb(nil) return end
	MySQL.Async.fetchAll([[SELECT id, warrant_id, suspect_name, exported_by_name, exported_by_job, exported_by_identifier, msg_count, server_count, checksum, exported_at
		FROM dept_discord_evidence WHERE case_id = @c ORDER BY id DESC]], { ['@c'] = tonumber(caseId) }, function(rows)
		local out = {}
		for _, r in ipairs(rows or {}) do
			if canReadEvidence(xPlayer, r) then
				r.exported_by_identifier = nil
				r.exportedLabel = stamp(r.exported_at)
				out[#out + 1] = r
			end
		end
		cb(out)
	end)
end)

local PAGE = 12
ESX.RegisterServerCallback('esx_uniquejobs:discordGetEvidenceMessages', function(source, cb, evidenceId, page)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not tonumber(evidenceId) then cb(nil) return end
	MySQL.Async.fetchAll('SELECT exported_by_identifier, suspect_name, checksum, payload FROM dept_discord_evidence WHERE id = @id', { ['@id'] = tonumber(evidenceId) }, function(rows)
		local row = rows[1]
		if not row or not canReadEvidence(xPlayer, row) then cb(nil) return end
		local ok, data = pcall(json.decode, row.payload)
		if not ok or type(data) ~= 'table' then cb(nil) return end

		local all = data.messages or {}
		page = math.max(1, tonumber(page) or 1)
		local pages = math.max(1, math.ceil(#all / PAGE))
		if page > pages then page = pages end
		local slice = {}
		for i = (page - 1) * PAGE + 1, math.min(#all, page * PAGE) do
			local m = all[i]
			slice[#slice + 1] = { server = m.server, channel = m.channel, text = m.text, at = stamp(m.at) }
		end
		local servers = {}
		for _, s in ipairs(data.servers or {}) do servers[#servers + 1] = s.name .. (s.nickname and (' (as ' .. s.nickname .. ')') or '') end
		cb({ suspect = row.suspect_name, checksum = row.checksum, page = page, pages = pages, total = #all, truncated = data.truncated, servers = servers, messages = slice })
	end)
end)
