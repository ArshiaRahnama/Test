-- ============================================================
-- DOJ Manager (shared across marshal/judge/cia/cid/fbi/doa)
-- Powers the /doj menu: online roster, shared case files, and
-- the marshal/judge warrant request/approval system.
-- Cases and warrants are session-scoped (like the rob/panic
-- queues elsewhere in this resource) -- they're active
-- operational state, not a permanent audit log.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }

local function isDoj(jobname)
	return DOJ_JOBS[jobname] == true
end

local function canApproveWarrant(xPlayer)
	if xPlayer.job.name == 'judge' then return true end
	if xPlayer.job.name == 'marshal' and xPlayer.job.grade >= 18 then return true end
	return false
end

-- Resolves a search query to identifier + display name -- numeric query
-- that matches an online player id wins, otherwise treated as a
-- (partial) character name search. Shared by cases, warrants, and any
-- other DOJ feature that needs to look someone up.
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
-- Online DOJ roster
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:dojGetRoster', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	local roster = {}
	for _, playerId in pairs(ESX.GetPlayers()) do
		local xTarget = ESX.GetPlayerFromId(playerId)
		if xTarget and isDoj(xTarget.job.name) and xTarget.source ~= source then
			roster[#roster + 1] = { id = playerId, name = xTarget.name, job = string.upper(xTarget.job.name), gradeLabel = xTarget.job.grade_label }
		end
	end
	cb(roster)
end)

-- ============================================================
-- Case files
-- ============================================================

local caseCounter = 0
local cases = {} -- cases[id] = { id, title, suspectIdentifier, suspectName, openedByName, openedByJob, notes = {text, byName}[], status, referredTo }

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCases', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	local list = {}
	for id, case in pairs(cases) do
		if case.status == 'open' then
			list[#list + 1] = {
				id = id, title = case.title, suspectName = case.suspectName,
				openedByName = case.openedByName, openedByJob = case.openedByJob,
				noteCount = #case.notes, referredTo = case.referredTo,
			}
		end
	end
	table.sort(list, function(a, b) return a.id > b.id end)
	cb(list)
end)

ESX.RegisterServerCallback('esx_uniquejobs:dojGetCaseDetail', function(source, cb, caseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end
	cb(cases[caseId])
end)

RegisterServerEvent('esx_uniquejobs:dojOpenCase')
AddEventHandler('esx_uniquejobs:dojOpenCase', function(title, suspectQuery)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not title or title == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Onvan-e Parvande Khali Ast')
		return
	end

	local function create(suspectIdentifier, suspectName)
		caseCounter = caseCounter + 1
		cases[caseCounter] = {
			id = caseCounter,
			title = title,
			suspectIdentifier = suspectIdentifier,
			suspectName = suspectName or 'Na Moshakhas',
			openedByName = xPlayer.name,
			openedByJob = string.upper(xPlayer.job.name),
			notes = {},
			status = 'open',
			referredTo = nil,
		}
		TriggerClientEvent('esx:showNotification', source, '~g~Parvande #' .. caseCounter .. ' Baz Shod')
	end

	if suspectQuery and suspectQuery ~= '' then
		resolveIdentifier(suspectQuery, function(identifier, name)
			create(identifier, name)
		end)
	else
		create(nil, nil)
	end
end)

RegisterServerEvent('esx_uniquejobs:dojAddCaseNote')
AddEventHandler('esx_uniquejobs:dojAddCaseNote', function(caseId, note)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	local case = cases[caseId]
	if not case then
		TriggerClientEvent('esx:showNotification', source, '~r~Parvande Peida Nashod')
		return
	end

	if not note or note == '' then return end

	case.notes[#case.notes + 1] = { text = note, byName = xPlayer.name }
	TriggerClientEvent('esx:showNotification', source, '~g~Yaddasht Be Parvande #' .. caseId .. ' Ezafe Shod')
end)

RegisterServerEvent('esx_uniquejobs:dojCloseCase')
AddEventHandler('esx_uniquejobs:dojCloseCase', function(caseId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	local case = cases[caseId]
	if not case then return end

	case.status = 'closed'
	TriggerClientEvent('esx:showNotification', source, '~g~Parvande #' .. caseId .. ' Baste Shod')
end)

RegisterServerEvent('esx_uniquejobs:dojReferCase')
AddEventHandler('esx_uniquejobs:dojReferCase', function(caseId, targetJob)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	local case = cases[caseId]
	if not case or not targetJob or not DOJ_JOBS[targetJob] then return end

	case.referredTo = string.upper(targetJob)

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

-- ============================================================
-- Marshal/Judge warrant requests
-- ============================================================

local warrantCounter = 0
local warrants = {} -- warrants[id] = { id, warrantType, targetIdentifier, targetName, reason, requestedByName, requestedByJob, status }

ESX.RegisterServerCallback('esx_uniquejobs:dojGetWarrants', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then cb(nil) return end

	local pending, active = {}, {}
	for id, w in pairs(warrants) do
		if w.status == 'pending' then
			pending[#pending + 1] = w
		elseif w.status == 'approved' then
			active[#active + 1] = w
		end
	end
	table.sort(pending, function(a, b) return a.id > b.id end)
	table.sort(active, function(a, b) return a.id > b.id end)

	cb({ pending = pending, active = active, canApprove = canApproveWarrant(xPlayer) })
end)

RegisterServerEvent('esx_uniquejobs:dojRequestWarrant')
AddEventHandler('esx_uniquejobs:dojRequestWarrant', function(warrantType, targetQuery, reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isDoj(xPlayer.job.name) then return end

	if not targetQuery or targetQuery == '' or not reason or reason == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Hadaf Va Dalil Ra Vared Konid')
		return
	end

	resolveIdentifier(targetQuery, function(identifier, name)
		if not identifier then
			TriggerClientEvent('esx:showNotification', source, '~r~Hadaf Peida Nashod')
			return
		end

		warrantCounter = warrantCounter + 1
		warrants[warrantCounter] = {
			id = warrantCounter,
			warrantType = warrantType,
			targetIdentifier = identifier,
			targetName = name,
			reason = reason,
			requestedBySource = source,
			requestedByName = xPlayer.name,
			requestedByJob = string.upper(xPlayer.job.name),
			status = 'pending',
		}

		TriggerClientEvent('esx:showNotification', source, '~g~Darkhast-e Hokm #' .. warrantCounter .. ' Ersal Shod')

		local xPlayers = ESX.GetPlayers()
		for i = 1, #xPlayers do
			local xTarget = ESX.GetPlayerFromId(xPlayers[i])
			if xTarget and canApproveWarrant(xTarget) then
				TriggerClientEvent('chatMessage', xTarget.source, "[ DOJ ]", {90, 30, 160},
					"^7Darkhast-e Hokm-e Jadid #" .. warrantCounter .. " Az ^3" .. xPlayer.name .. "^7 -- Baraye Barresi /doj Ra Bezanid")
			end
		end
	end)
end)

RegisterServerEvent('esx_uniquejobs:dojDecideWarrant')
AddEventHandler('esx_uniquejobs:dojDecideWarrant', function(warrantId, decision)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not canApproveWarrant(xPlayer) then
		TriggerClientEvent('esx:showNotification', source, '~r~Shoma Dastresi Kafi Nadarid')
		return
	end

	local w = warrants[warrantId]
	if not w or w.status ~= 'pending' then return end

	if decision == 'approve' then
		w.status = 'approved'
		local typeLabel = w.warrantType == 'search' and 'Bazresi' or 'Dastgiri'

		if w.requestedBySource then
			TriggerClientEvent('esx:showNotification', w.requestedBySource, '~g~Hokm-e Darkhasti-e Shoma Tayid Shod!')
		end

		local xPlayers = ESX.GetPlayers()
		for i = 1, #xPlayers do
			local xTarget = ESX.GetPlayerFromId(xPlayers[i])
			if xTarget and isDoj(xTarget.job.name) then
				TriggerClientEvent('chatMessage', xTarget.source, "[ DOJ ]", {90, 30, 160},
					"^2Hokm-e " .. typeLabel .. " Baraye ^3" .. w.targetName .. "^2 Tavasote ^3" .. xPlayer.name .. "^2 Sader Shod!")
			end
		end
	else
		w.status = 'denied'
		if w.requestedBySource then
			TriggerClientEvent('esx:showNotification', w.requestedBySource, '~r~Hokm-e Darkhasti-e Shoma Rad Shod')
		end
	end
end)

RegisterServerEvent('esx_uniquejobs:dojRevokeWarrant')
AddEventHandler('esx_uniquejobs:dojRevokeWarrant', function(warrantId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not canApproveWarrant(xPlayer) then return end

	local w = warrants[warrantId]
	if not w then return end

	w.status = 'revoked'
	TriggerClientEvent('esx:showNotification', source, '~g~Hokm #' .. warrantId .. ' Bateel Shod')
end)
