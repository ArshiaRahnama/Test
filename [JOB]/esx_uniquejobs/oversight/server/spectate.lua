-- ============================================================
-- Job Watch (oversight) -- server side of spectate
-- Same idea as server/agent_speact.lua's spectate (a job-gated
-- start event that hands the client its target), but with the
-- pieces that one never had: target eligibility, cooldown, live
-- target coords for streaming, auto-stop when the target leaves
-- or the time limit is hit, and a persistent audit trail
-- (oversight_spectate_log + Discord) of who watched whom.
-- ============================================================

local Cfg = Config_oversight

local Sessions = {}   -- Sessions[spectatorSrc] = { target, targetIdentifier, startedAt, logId, lastStart, warned }

function Ov.IsSpectating(spectatorSrc, targetSrc)
	local s = Sessions[spectatorSrc]
	return s ~= nil and (targetSrc == nil or s.target == targetSrc)
end

local function targetCoords(targetSrc)
	local ped = GetPlayerPed(targetSrc)
	if not ped or ped == 0 then return nil end
	local c = GetEntityCoords(ped)
	return { x = c.x, y = c.y, z = c.z }
end

-- what the on-screen panel / info menu shows
local function buildInfo(xTarget)
	local row = Ov.BuildWorkerRow(xTarget) or {
		id = xTarget.source, name = xTarget.name, job = xTarget.job.name, jobLabel = xTarget.job.label or xTarget.job.name,
		grade = xTarget.job.grade_label, state = 'idle', shiftMin = 0, items = 0, income = 0, sales = 0, flags = 0,
	}

	local watchedNames = {}
	for _, w in pairs(Cfg.Watched) do
		for _, item in ipairs(w.items) do watchedNames[item] = true end
	end
	local items = {}
	for _, item in ipairs(xTarget.inventory or {}) do
		if item.count and item.count > 0 and (Cfg.Spectate.ShowFullInventory or watchedNames[item.name]) then
			items[#items + 1] = { label = item.label, count = item.count }
		end
	end
	row.inventory = items
	row.cash = xTarget.getMoney and xTarget.getMoney() or nil
	return row
end

local function closeLog(session, reason)
	if session.logId then
		MySQL.Async.execute('UPDATE oversight_spectate_log SET ended_at = @e, reason = @r WHERE id = @id', {
			['@e'] = os.time(), ['@r'] = reason, ['@id'] = session.logId,
		})
	end
end

-- ends a session server-side; forced = also tell the spectator's client
local function endSession(src, reason, forced)
	local session = Sessions[src]
	if not session then return end
	Sessions[src] = nil
	closeLog(session, reason)

	local xPlayer = ESX.GetPlayerFromId(src)
	Ov.Log(xPlayer, 'SPECTATE END (' .. reason .. ')',
		'[ Target : ' .. tostring(session.targetName) .. ' ]\n[ Duration : ' .. Ov.FormatRemaining(os.time() - session.startedAt) .. ' ]\n')

	if forced then
		TriggerClientEvent('esx_uniquejobs:oversight:spectateForceEnd', src, reason)
	end
end

RegisterServerEvent('esx_uniquejobs:oversight:spectateStart')
AddEventHandler('esx_uniquejobs:oversight:spectateStart', function(targetId)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'spectate')
	if not ok then return end

	targetId = tonumber(targetId)
	if not targetId or targetId == src then return end

	local prev = Sessions[src]
	-- switching target inside a session is allowed; a fresh start is rate limited
	if not prev and Ov.Throttle(src, 'spectate', Cfg.Spectate.CooldownSeconds) then return end

	-- zone gate: only checked on a FRESH start, never on a mid-session
	-- target switch (by then the officer's own ped is parked wherever the
	-- spectate loop last put it -- near the target, not the zone -- so
	-- re-checking here would fail every switch even for a legit session).
	if not prev and Cfg.Spectate.RequireZone.Enabled then
		local ped = GetPlayerPed(src)
		local coords = (ped and ped ~= 0) and GetEntityCoords(ped) or nil
		local zone = Cfg.Spectate.RequireZone
		if not coords or #(coords - zone.Coords) > zone.Radius then
			Ov.Notify(src, '~r~Baraye Nezarat Bayad Dakhel-e Mahdoode-ye DOJ Bashid')
			return
		end
	end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		Ov.Notify(src, '~r~Bazikon Peida Nashod')
		return
	end

	if not Cfg.Spectate.CanSpectateOversight and Ov.GetRole(xTarget) then
		Ov.Notify(src, '~r~Nezarat Bar Ghazi/Marshal Mojaz Nist')
		return
	end

	if not Ov.IsOversightTarget(xTarget) then
		Ov.Notify(src, '~r~In Bazikon Karegar-e Faal (Ya Hoshdar-Shode) Nist')
		return
	end

	local coords = targetCoords(targetId)
	if not coords then
		Ov.Notify(src, '~r~Makan-e Bazikon Dar Dastres Nist')
		return
	end

	if prev then
		closeLog(prev, 'switched')
	end

	local now = os.time()
	local session = {
		target = targetId, targetIdentifier = xTarget.identifier, targetName = xTarget.name,
		startedAt = prev and prev.startedAt or now,   -- the time limit covers the whole session
		warned = prev and prev.warned or false,
	}
	Sessions[src] = session

	local row = Ov.BuildWorkerRow(xTarget)
	MySQL.Async.insert('INSERT INTO oversight_spectate_log (spectator_identifier, spectator_name, spectator_job, target_identifier, target_name, target_job, started_at) VALUES (@si, @sn, @sj, @ti, @tn, @tj, @t)', {
		['@si'] = xPlayer.identifier, ['@sn'] = xPlayer.name, ['@sj'] = xPlayer.job.name,
		['@ti'] = xTarget.identifier, ['@tn'] = xTarget.name, ['@tj'] = row and row.job or xTarget.job.name, ['@t'] = now,
	}, function(id)
		-- the session may have moved on (stopped / switched) before the insert returned
		if Sessions[src] == session then
			session.logId = id
		elseif id then
			MySQL.Async.execute('UPDATE oversight_spectate_log SET ended_at = @e, reason = @r WHERE id = @id', { ['@e'] = os.time(), ['@r'] = 'switched', ['@id'] = id })
		end
	end)

	Ov.Log(xPlayer, 'SPECTATE START', '[ Target : ' .. xTarget.name .. ' (' .. targetId .. ') ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n[ Job : ' .. tostring(row and row.job or xTarget.job.name) .. ' ]\n')

	if Cfg.Spectate.NotifyTarget then
		Ov.Notify(targetId, '~y~Shoma Tavassot-e Farmandari Dar Hal-e Nezarat Hastid')
	end

	TriggerClientEvent('esx_uniquejobs:oversight:spectateBegin', src, targetId, coords, buildInfo(xTarget), Cfg.Spectate.MaxMinutes)
end)

RegisterServerEvent('esx_uniquejobs:oversight:spectateStop')
AddEventHandler('esx_uniquejobs:oversight:spectateStop', function()
	endSession(source, 'stopped', false)
end)

-- follow loop: the client asks where its target is so it can keep the
-- target streamed in (OneSync only syncs peds near you)
ESX.RegisterServerCallback('esx_uniquejobs:oversight:spectateCoords', function(source, cb)
	local session = Sessions[source]
	if not session then cb(nil) return end
	cb(targetCoords(session.target))
end)

-- fresh HUD/info data
ESX.RegisterServerCallback('esx_uniquejobs:oversight:spectateInfo', function(source, cb)
	local session = Sessions[source]
	if not session then cb(nil) return end
	local xTarget = ESX.GetPlayerFromId(session.target)
	if not xTarget then cb(nil) return end
	cb(buildInfo(xTarget))
end)

-- Roster of eligible targets in the order the LEFT/RIGHT cycle uses
ESX.RegisterServerCallback('esx_uniquejobs:oversight:spectateList', function(source, cb)
	if not Ov.Can(source, 'spectate') then cb(nil) return end
	local ids = {}
	for _, row in ipairs(Ov.GetRoster()) do
		if row.id ~= source then ids[#ids + 1] = row.id end
	end
	cb(ids)
end)

-- guard rails: time limit, lost role, vanished target
CreateThread(function()
	while true do
		Wait(5000)
		local now = os.time()
		local limit = Cfg.Spectate.MaxMinutes * 60
		for src, session in pairs(Sessions) do
			local ok = Ov.Can(src, 'spectate')
			if not ok then
				endSession(src, 'role_lost', true)
			elseif not ESX.GetPlayerFromId(session.target) then
				endSession(src, 'target_left', true)
			elseif now - session.startedAt >= limit then
				endSession(src, 'timeout', true)
			elseif not session.warned and limit - (now - session.startedAt) <= 60 then
				session.warned = true
				Ov.Notify(src, '~y~Nezarat Ta 1 Daghighe-ye Digar Payan Miyabad')
			end
		end
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
	if Sessions[src] then endSession(src, 'spectator_left', false) end
end)
