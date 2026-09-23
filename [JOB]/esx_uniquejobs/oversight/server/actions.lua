-- ============================================================
-- Job Watch (oversight) -- server actions
-- Every menu action lands here. Each handler re-checks the
-- caller's role SERVER-side (Ov.Can) and clamps every number a
-- client sends -- the menu is only a UI, never the security
-- boundary (same rule as esx_jobs' uniform editor).
-- ============================================================

local Cfg = Config_oversight

local function jobLabel(jobKey)
	return (Cfg.Watched[jobKey] and Cfg.Watched[jobKey].label) or tostring(jobKey)
end

-- which watched job a target is "in": their job, or what they last worked
local function targetJob(xTarget)
	if Cfg.Watched[xTarget.job.name] then return xTarget.job.name end
	local w = Ov.Workers[xTarget.source]
	if w then return w.job end
	return xTarget.job.name
end

local function getTarget(src, targetId)
	local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
	if not xTarget then
		Ov.Notify(src, '~r~Bazikon Peida Nashod')
		return nil
	end
	return xTarget
end

function Ov.AddOffence(identifier, name, jobKey, kind, reason, amount, xOfficer)
	MySQL.Async.execute('INSERT INTO oversight_offences (identifier, name, job, kind, reason, amount, by_name, by_job, created_at) VALUES (@i, @n, @j, @k, @r, @a, @bn, @bj, @t)', {
		['@i'] = identifier, ['@n'] = name, ['@j'] = jobKey, ['@k'] = kind, ['@r'] = reason,
		['@a'] = amount, ['@bn'] = xOfficer and xOfficer.name or 'System',
		['@bj'] = xOfficer and xOfficer.job.name or 'system', ['@t'] = os.time(),
	})
end

-- ------------------------------------------------------------
-- Roster / worker file / inspection
-- ------------------------------------------------------------
ESX.RegisterServerCallback('esx_uniquejobs:oversight:getRole', function(source, cb)
	local ok, xPlayer, role, roleName = Ov.Can(source, nil)
	if not ok then cb(nil) return end
	cb({ role = roleName, perms = role.perms, maxFine = role.maxFine, maxSuspendHours = role.maxSuspendHours })
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getRoster', function(source, cb)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end
	cb(Ov.GetRoster())
end)

local function buildFile(xTarget, cb)
	local jobKey = targetJob(xTarget)
	local row = Ov.BuildWorkerRow(xTarget)
	local permits = {}
	for _, j in ipairs(Cfg.JobOrder) do
		if Cfg.Watched[j].permit or Ov.HasPermit(xTarget.identifier, j) then
			permits[#permits + 1] = { job = j, label = jobLabel(j), has = Ov.HasPermit(xTarget.identifier, j) }
		end
	end
	local suspension = Ov.ActiveSuspension(xTarget.identifier, jobKey)

	local from = os.date('%Y-%m-%d', os.time() - 7 * 86400)
	Ov.QueryAll({
		{ key = 'offences', sql = 'SELECT kind, reason, amount, by_name, created_at FROM oversight_offences WHERE identifier = @i ORDER BY id DESC LIMIT 15', params = { ['@i'] = xTarget.identifier } },
		{ key = 'stats', sql = 'SELECT job, SUM(items) items, SUM(income) income, SUM(seconds) seconds FROM oversight_stats WHERE identifier = @i AND day >= @d GROUP BY job', params = { ['@i'] = xTarget.identifier, ['@d'] = from } },
	}, function(r)
		cb({
			id = xTarget.source, name = xTarget.name, identifier = xTarget.identifier,
			job = jobKey, jobLabel = jobLabel(jobKey), grade = xTarget.job.grade_label,
			row = row, permits = permits,
			suspension = suspension and { reason = suspension.reason, left = Ov.FormatRemaining(suspension.expires - os.time()), job = suspension.job } or nil,
			offences = r.offences, stats7d = r.stats,
		})
	end)
end

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getWorkerFile', function(source, cb, targetId)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end
	local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
	if not xTarget then cb(nil) return end
	buildFile(xTarget, cb)
end)

-- On-foot inspection: must be close (unless already spectating them)
ESX.RegisterServerCallback('esx_uniquejobs:oversight:inspect', function(source, cb, targetId)
	local ok, xPlayer = Ov.Can(source, 'inspect')
	if not ok then cb(nil, 'Dast Resi Nadarid') return end
	local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
	if not xTarget then cb(nil, 'Bazikon Peida Nashod') return end
	if xTarget.source == source then cb(nil, 'Nemitavanid Khodetan Ra Bazresi Konid') return end

	local spectating = Ov.IsSpectating and Ov.IsSpectating(source, xTarget.source)
	if not spectating then
		local a, b = GetPlayerPed(source), GetPlayerPed(xTarget.source)
		if not a or a == 0 or not b or b == 0 or #(GetEntityCoords(a) - GetEntityCoords(b)) > Cfg.Inspect.Distance then
			cb(nil, 'Bayad Nazdik-e Karegar Bashid (' .. math.floor(Cfg.Inspect.Distance) .. 'm)')
			return
		end
	end

	-- job-related items across ALL watched jobs (a miner can be carrying fish)
	local watchedItems, thresholds = {}, {}
	for jobKey, w in pairs(Cfg.Watched) do
		for _, item in ipairs(w.items) do watchedItems[item] = true end
		for item, limit in pairs(w.stockpile or {}) do thresholds[item] = limit end
	end
	local items = {}
	for _, item in ipairs(xTarget.inventory or {}) do
		if item.count and item.count > 0 and watchedItems[item.name] then
			items[#items + 1] = {
				name = item.name, label = item.label, count = item.count,
				suspicious = thresholds[item.name] ~= nil and item.count > thresholds[item.name],
			}
		end
	end

	Ov.Notify(xTarget.source, '~y~Yek Bazras (~b~' .. string.upper(xPlayer.job.name) .. '~y~) Dar Hal-e Bazresi-ye Shoma Ast')
	Ov.Log(xPlayer, 'INSPECTION', '[ Target : ' .. xTarget.name .. ' (' .. xTarget.source .. ') ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n')

	buildFile(xTarget, function(file)
		file.items = items
		cb(file)
	end)
end)

-- ------------------------------------------------------------
-- Warn / fine / suspend / lift / note
-- ------------------------------------------------------------
RegisterServerEvent('esx_uniquejobs:oversight:warn')
AddEventHandler('esx_uniquejobs:oversight:warn', function(targetId, reason)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'warn')
	if not ok or Ov.Throttle(src, 'warn', 2) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget then return end
	reason = Ov.Clean(reason, 200)
	if reason == '' then Ov.Notify(src, '~r~Dalil Nemitavanad Khali Bashad') return end

	local jobKey = targetJob(xTarget)
	Ov.AddOffence(xTarget.identifier, xTarget.name, jobKey, 'warn', reason, nil, xPlayer)
	Ov.Notify(xTarget.source, '~r~Akhtar Az Taraf-e ' .. string.upper(xPlayer.job.name) .. '~w~: ' .. reason)
	TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1[JOB WATCH]', 'Akhtar (' .. jobLabel(jobKey) .. '): ' .. reason } })
	Ov.Notify(src, '~g~Akhtar Baraye ' .. xTarget.name .. ' Sabt Shod')
	Ov.Log(xPlayer, 'WARN', '[ Target : ' .. xTarget.name .. ' ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n[ Reason : ' .. reason .. ' ]\n')
end)

RegisterServerEvent('esx_uniquejobs:oversight:fine')
AddEventHandler('esx_uniquejobs:oversight:fine', function(targetId, amount, reason)
	local src = source
	local ok, xPlayer, role = Ov.Can(src, 'fine')
	if not ok or Ov.Throttle(src, 'fine', 3) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget then return end

	amount = math.floor(tonumber(amount) or 0)
	reason = Ov.Clean(reason, 150)
	if reason == '' then Ov.Notify(src, '~r~Dalil Nemitavanad Khali Bashad') return end
	if amount < 1 or amount > role.maxFine then
		Ov.Notify(src, '~r~Mablagh Bayad Bein-e 1 Ta ' .. role.maxFine .. ' Bashad')
		return
	end

	local jobKey = targetJob(xTarget)
	-- billing row, same schema esx_billing / law_codebook.lua use. Target
	-- is the DOJ society account (the one that always exists).
	MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
		['@identifier'] = xTarget.identifier, ['@sender'] = xPlayer.identifier,
		['@target_type'] = 'society', ['@target'] = Cfg.Economy.TaxAccount,
		['@label'] = 'Jarime-ye Kar (' .. jobLabel(jobKey) .. '): ' .. reason, ['@amount'] = amount,
	}, function()
		Ov.AddOffence(xTarget.identifier, xTarget.name, jobKey, 'fine', reason, amount, xPlayer)
		if Cfg.LogFinesToRapSheet and LogCriminalRecord then
			LogCriminalRecord(xTarget.identifier, 'charge', '[Job Watch] ' .. reason, xPlayer.name, xPlayer.identifier, nil)
		end
		Ov.Notify(src, '~g~Jarime-ye $' .. amount .. ' Baraye ' .. xTarget.name .. ' Sader Shod')
		TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1[JOB WATCH]', 'Shoma Jarime Shodid: ' .. reason .. ' ($' .. amount .. ')' } })
		Ov.Log(xPlayer, 'FINE', '[ Target : ' .. xTarget.name .. ' ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n[ Amount : $' .. amount .. ' ]\n[ Reason : ' .. reason .. ' ]\n')
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:suspend')
AddEventHandler('esx_uniquejobs:oversight:suspend', function(targetId, jobKey, hours, reason)
	local src = source
	local ok, xPlayer, role = Ov.Can(src, 'suspend')
	if not ok or Ov.Throttle(src, 'suspend', 3) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget then return end

	if jobKey ~= '*' and not Cfg.Watched[jobKey] then return end
	hours = math.floor(tonumber(hours) or 0)
	reason = Ov.Clean(reason, 150)
	if reason == '' then Ov.Notify(src, '~r~Dalil Nemitavanad Khali Bashad') return end
	if hours < 1 or hours > role.maxSuspendHours then
		Ov.Notify(src, '~r~Modat Bayad Bein-e 1 Ta ' .. role.maxSuspendHours .. ' Saat Bashad')
		return
	end

	local now = os.time()
	local expires = now + hours * 3600
	MySQL.Async.insert('INSERT INTO oversight_suspensions (identifier, name, job, reason, by_name, by_job, created_at, expires_at, active) VALUES (@i, @n, @j, @r, @bn, @bj, @t, @e, 1)', {
		['@i'] = xTarget.identifier, ['@n'] = xTarget.name, ['@j'] = jobKey, ['@r'] = reason,
		['@bn'] = xPlayer.name, ['@bj'] = xPlayer.job.name, ['@t'] = now, ['@e'] = expires,
	}, function(id)
		if not id then return end
		Ov.AddSuspensionCache(xTarget.identifier, id, jobKey, reason, expires)
		Ov.AddOffence(xTarget.identifier, xTarget.name, targetJob(xTarget), 'suspend', reason .. ' (' .. hours .. 'h)', nil, xPlayer)
		if Cfg.LogFinesToRapSheet and LogCriminalRecord then
			LogCriminalRecord(xTarget.identifier, 'charge', '[Job Watch] Tarigh Az Shoghl (' .. hours .. 'h): ' .. reason, xPlayer.name, xPlayer.identifier, nil)
		end

		-- kick them out of the job right now if they're currently in it
		local current = xTarget.job.name
		if Cfg.Watched[current] and (jobKey == '*' or jobKey == current) then
			xTarget.setJob('nojob', 0)
			TriggerClientEvent('esx:inJob', xTarget.source, 'nojob')
		end

		Ov.Notify(xTarget.source, '~r~Shoma Az ' .. (jobKey == '*' and 'Hame-ye Shoghl-ha' or jobLabel(jobKey)) .. ' Be Modat-e ' .. hours .. ' Saat Tarigh Shodid: ' .. reason)
		Ov.Notify(src, '~g~' .. xTarget.name .. ' Tarigh Shod')
		Ov.Log(xPlayer, 'SUSPEND', '[ Target : ' .. xTarget.name .. ' ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n[ Job : ' .. jobKey .. ' ]\n[ Hours : ' .. hours .. ' ]\n[ Reason : ' .. reason .. ' ]\n')
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getSuspensions', function(source, cb)
	if not (Ov.Can(source, 'suspend') or Ov.Can(source, 'lift')) then cb(nil) return end
	MySQL.Async.fetchAll('SELECT id, name, job, reason, by_name, created_at, expires_at FROM oversight_suspensions WHERE active = 1 AND expires_at > @now ORDER BY id DESC LIMIT 40', { ['@now'] = os.time() }, function(rows)
		for _, r in ipairs(rows or {}) do r.left = Ov.FormatRemaining(r.expires_at - os.time()) end
		cb(rows or {})
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:lift')
AddEventHandler('esx_uniquejobs:oversight:lift', function(suspensionId)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'lift')
	if not ok then return end
	suspensionId = tonumber(suspensionId)
	if not suspensionId then return end

	MySQL.Async.execute('UPDATE oversight_suspensions SET active = 0, lifted_by = @by WHERE id = @id AND active = 1', {
		['@by'] = xPlayer.name, ['@id'] = suspensionId,
	}, function(affected)
		if affected and affected > 0 then
			Ov.RemoveSuspensionCache(suspensionId)
			Ov.Notify(src, '~g~Tarigh Laghv Shod')
			Ov.Log(xPlayer, 'LIFT SUSPENSION', '[ Suspension : #' .. suspensionId .. ' ]\n')
		end
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:note')
AddEventHandler('esx_uniquejobs:oversight:note', function(targetId, text)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'notes')
	if not ok or Ov.Throttle(src, 'note', 2) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget then return end
	text = Ov.Clean(text, 200)
	if text == '' then return end
	Ov.AddOffence(xTarget.identifier, xTarget.name, targetJob(xTarget), 'note', text, nil, xPlayer)
	Ov.Notify(src, '~g~Yaddasht Sabt Shod')
end)

-- direct message to a worker (used while spectating, like /agentmsg)
RegisterServerEvent('esx_uniquejobs:oversight:message')
AddEventHandler('esx_uniquejobs:oversight:message', function(targetId, text)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'warn')
	if not ok or Ov.Throttle(src, 'msg', 2) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget then return end
	text = Ov.Clean(text, 200)
	if text == '' then return end
	TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^3[' .. string.upper(xPlayer.job.name) .. ']', text } })
	Ov.Notify(src, '~g~Payam Ersal Shod')
	Ov.Log(xPlayer, 'MESSAGE', '[ Target : ' .. xTarget.name .. ' ]\n[ Text : ' .. text .. ' ]\n')
end)

-- ------------------------------------------------------------
-- Permits
-- ------------------------------------------------------------
RegisterServerEvent('esx_uniquejobs:oversight:issuePermit')
AddEventHandler('esx_uniquejobs:oversight:issuePermit', function(targetId, jobKey, days)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'permits')
	if not ok or Ov.Throttle(src, 'permit', 2) then return end
	local xTarget = getTarget(src, targetId)
	if not xTarget or not Cfg.Watched[jobKey] then return end

	days = math.floor(tonumber(days) or Cfg.Permits.DefaultDays)
	days = math.max(1, math.min(days, Cfg.Permits.MaxDays))
	local now = os.time()
	local expires = now + days * 86400

	MySQL.Async.execute('INSERT INTO oversight_permits (identifier, name, job, issued_by, issued_at, expires_at) VALUES (@i, @n, @j, @by, @t, @e) ON DUPLICATE KEY UPDATE name = VALUES(name), issued_by = VALUES(issued_by), issued_at = VALUES(issued_at), expires_at = VALUES(expires_at)', {
		['@i'] = xTarget.identifier, ['@n'] = xTarget.name, ['@j'] = jobKey,
		['@by'] = xPlayer.name, ['@t'] = now, ['@e'] = expires,
	}, function()
		Ov.SetPermit(xTarget.identifier, jobKey, expires)
		Ov.AddOffence(xTarget.identifier, xTarget.name, jobKey, 'permit', 'Mojavez-e ' .. jobLabel(jobKey) .. ' Sader Shod (' .. days .. ' Rooz)', nil, xPlayer)
		Ov.Notify(xTarget.source, '~g~Mojavez-e ' .. jobLabel(jobKey) .. ' Baraye ' .. days .. ' Rooz Baraye Shoma Sader Shod')
		Ov.Notify(src, '~g~Mojavez Sader Shod')
		Ov.Log(xPlayer, 'PERMIT ISSUED', '[ Target : ' .. xTarget.name .. ' ]\n[ Steam : ' .. xTarget.identifier .. ' ]\n[ Job : ' .. jobKey .. ' ]\n[ Days : ' .. days .. ' ]\n')
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:revokePermit')
AddEventHandler('esx_uniquejobs:oversight:revokePermit', function(identifier, jobKey)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'permit_revoke')
	if not ok or type(identifier) ~= 'string' or not Cfg.Watched[jobKey] then return end

	MySQL.Async.execute('DELETE FROM oversight_permits WHERE identifier = @i AND job = @j', { ['@i'] = identifier, ['@j'] = jobKey }, function()
		Ov.ClearPermit(identifier, jobKey)
		local xTarget = Ov.FindByIdentifier(identifier)
		if xTarget then Ov.Notify(xTarget.source, '~r~Mojavez-e ' .. jobLabel(jobKey) .. ' Shoma Laghv Shod') end
		Ov.Notify(src, '~g~Mojavez Laghv Shod')
		Ov.Log(xPlayer, 'PERMIT REVOKED', '[ Steam : ' .. identifier .. ' ]\n[ Job : ' .. jobKey .. ' ]\n')
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getPermits', function(source, cb)
	if not (Ov.Can(source, 'permits') or Ov.Can(source, 'permit_revoke')) then cb(nil) return end
	MySQL.Async.fetchAll('SELECT identifier, name, job, issued_by, expires_at FROM oversight_permits WHERE expires_at > @now ORDER BY expires_at ASC LIMIT 40', { ['@now'] = os.time() }, function(rows)
		for _, r in ipairs(rows or {}) do
			r.left = Ov.FormatRemaining(r.expires_at - os.time())
			r.jobLabel = jobLabel(r.job)
		end
		cb(rows or {})
	end)
end)

-- ------------------------------------------------------------
-- Economy + timed events + announcements
-- ------------------------------------------------------------
ESX.RegisterServerCallback('esx_uniquejobs:oversight:getEconomy', function(source, cb)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end
	local out = {}
	for _, jobKey in ipairs(Cfg.JobOrder) do
		local m = Ov.GetMods(jobKey)
		local closed = Ov.ActiveEvent('closed', jobKey)
		local bonus = Ov.ActiveEvent('bonus', jobKey)
		out[#out + 1] = {
			job = jobKey, label = jobLabel(jobKey), tax = m.tax, mult = m.mult,
			closedLeft = closed and Ov.FormatRemaining(closed.untilTs - os.time()) or nil,
			bonusMult = bonus and bonus.mult or nil,
			bonusLeft = bonus and Ov.FormatRemaining(bonus.untilTs - os.time()) or nil,
		}
	end
	cb({ jobs = out, minMult = Cfg.Economy.MinPriceMult, maxMult = Cfg.Economy.MaxPriceMult, maxTax = Cfg.Economy.MaxTaxRate })
end)

RegisterServerEvent('esx_uniquejobs:oversight:setEconomy')
AddEventHandler('esx_uniquejobs:oversight:setEconomy', function(jobKey, taxPercent, priceMult)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'economy')
	if not ok or Ov.Throttle(src, 'economy', 3) then return end
	if not Cfg.Watched[jobKey] then return end

	local tax = (tonumber(taxPercent) or 0) / 100
	local mult = tonumber(priceMult) or 1.0
	tax = math.max(0, math.min(tax, Cfg.Economy.MaxTaxRate))
	mult = math.max(Cfg.Economy.MinPriceMult, math.min(mult, Cfg.Economy.MaxPriceMult))
	-- keep 3 decimals so the DB DECIMAL and the cache always agree
	tax = math.floor(tax * 10000 + 0.5) / 10000
	mult = math.floor(mult * 1000 + 0.5) / 1000

	MySQL.Async.execute('INSERT INTO oversight_settings (job, tax_rate, price_mult, updated_by, updated_at) VALUES (@j, @t, @m, @by, @at) ON DUPLICATE KEY UPDATE tax_rate = VALUES(tax_rate), price_mult = VALUES(price_mult), updated_by = VALUES(updated_by), updated_at = VALUES(updated_at)', {
		['@j'] = jobKey, ['@t'] = tax, ['@m'] = mult, ['@by'] = xPlayer.name, ['@at'] = os.time(),
	}, function()
		Ov.SetSetting(jobKey, tax, mult)
		Ov.Notify(src, '~g~' .. jobLabel(jobKey) .. ': Maliat ' .. math.floor(tax * 100 + 0.5) .. '% | Zarib-e Gheymat x' .. mult)
		Ov.Log(xPlayer, 'ECONOMY', '[ Job : ' .. jobKey .. ' ]\n[ Tax : ' .. (tax * 100) .. '% ]\n[ Price Mult : x' .. mult .. ' ]\n')

		for _, id in pairs(ESX.GetPlayers()) do
			local xw = ESX.GetPlayerFromId(id)
			if xw and xw.job.name == jobKey then
				Ov.Notify(xw.source, '~y~Sharayet-e Eghtesadi-ye ' .. jobLabel(jobKey) .. ' Taghir Kard: Maliat ' .. math.floor(tax * 100 + 0.5) .. '% | Gheymat x' .. mult)
			end
		end
	end)
end)

local function broadcastToJob(jobKey, msg, chatTag)
	for _, id in pairs(ESX.GetPlayers()) do
		local xw = ESX.GetPlayerFromId(id)
		if xw then
			local inJob = (jobKey == '*' and Cfg.Watched[xw.job.name] ~= nil) or xw.job.name == jobKey
			local active = Ov.Workers[xw.source] and (jobKey == '*' or Ov.Workers[xw.source].job == jobKey)
			if inJob or active then
				Ov.Notify(xw.source, msg)
				TriggerClientEvent('chat:addMessage', xw.source, { args = { chatTag or '^3[JOB WATCH]', (msg:gsub('~%a~', '')) } })
			end
		end
	end
end

RegisterServerEvent('esx_uniquejobs:oversight:startEvent')
AddEventHandler('esx_uniquejobs:oversight:startEvent', function(kind, jobKey, minutes, mult)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'events')
	if not ok or Ov.Throttle(src, 'event', 3) then return end
	if kind ~= 'bonus' and kind ~= 'closed' then return end
	if jobKey ~= '*' and not Cfg.Watched[jobKey] then return end

	minutes = math.max(1, math.min(math.floor(tonumber(minutes) or 30), Cfg.Economy.MaxEventMinutes))
	local untilTs = os.time() + minutes * 60
	local label = jobKey == '*' and 'Hame-ye Shoghl-ha' or jobLabel(jobKey)

	if kind == 'bonus' then
		mult = math.max(1.1, math.min(tonumber(mult) or 2.0, Cfg.Economy.MaxEventBonusMult))
		Ov.Cache.Events.bonus[jobKey] = { untilTs = untilTs, by = xPlayer.name, mult = mult }
		broadcastToJob(jobKey, '~g~Event: Pardakht-e x' .. string.format('%.2f', mult) .. ' Baraye ' .. label .. ' Be Modat-e ' .. minutes .. ' Daghighe!')
	else
		Ov.Cache.Events.closed[jobKey] = { untilTs = untilTs, by = xPlayer.name }
		broadcastToJob(jobKey, '~r~' .. label .. ' Be Modat-e ' .. minutes .. ' Daghighe Baste Shod (Farmandari)')
	end

	Ov.Notify(src, '~g~Event Shoroo Shod')
	Ov.Log(xPlayer, 'EVENT START: ' .. kind, '[ Job : ' .. jobKey .. ' ]\n[ Minutes : ' .. minutes .. ' ]\n[ Mult : ' .. tostring(mult) .. ' ]\n')
end)

RegisterServerEvent('esx_uniquejobs:oversight:stopEvent')
AddEventHandler('esx_uniquejobs:oversight:stopEvent', function(kind, jobKey)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'events')
	if not ok then return end
	if kind ~= 'bonus' and kind ~= 'closed' then return end
	if not Ov.Cache.Events[kind][jobKey] then return end

	Ov.Cache.Events[kind][jobKey] = nil
	broadcastToJob(jobKey, '~y~Event Payan Yaft (' .. (jobKey == '*' and 'Hame' or jobLabel(jobKey)) .. ')')
	Ov.Notify(src, '~g~Event Payan Yaft')
	Ov.Log(xPlayer, 'EVENT STOP: ' .. kind, '[ Job : ' .. jobKey .. ' ]\n')
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getEvents', function(source, cb)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end
	local list = {}
	for kind, byJob in pairs(Ov.Cache.Events) do
		for jobKey, e in pairs(byJob) do
			if e.untilTs > os.time() then
				list[#list + 1] = {
					kind = kind, job = jobKey, label = jobKey == '*' and 'Hame-ye Shoghl-ha' or jobLabel(jobKey),
					mult = e.mult, left = Ov.FormatRemaining(e.untilTs - os.time()), by = e.by,
				}
			end
		end
	end
	cb(list)
end)

RegisterServerEvent('esx_uniquejobs:oversight:announce')
AddEventHandler('esx_uniquejobs:oversight:announce', function(jobKey, text)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'announce')
	if not ok or Ov.Throttle(src, 'announce', 10) then return end
	if jobKey ~= '*' and not Cfg.Watched[jobKey] then return end
	text = Ov.Clean(text, 200)
	if text == '' then return end

	broadcastToJob(jobKey, '~y~[' .. string.upper(xPlayer.job.name) .. ']~w~ ' .. text, '^3[' .. string.upper(xPlayer.job.name) .. ']')
	Ov.Notify(src, '~g~Elam Shod')
	Ov.Log(xPlayer, 'ANNOUNCE', '[ Job : ' .. jobKey .. ' ]\n[ Text : ' .. text .. ' ]\n')
end)

-- ------------------------------------------------------------
-- Top workers + weekly bonus
-- ------------------------------------------------------------
local function topQuery(jobKey, limit)
	local from = os.date('%Y-%m-%d', os.time() - Cfg.BonusPeriodDays * 86400)
	return {
		sql = 'SELECT identifier, MAX(name) name, SUM(income) income, SUM(items) items, SUM(seconds) seconds FROM oversight_stats WHERE job = @j AND day >= @d GROUP BY identifier ORDER BY income DESC LIMIT ' .. math.floor(limit),
		params = { ['@j'] = jobKey, ['@d'] = from },
	}
end

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getTop', function(source, cb, jobKey)
	if not Ov.Can(source, 'dashboard') or not Cfg.Watched[jobKey] then cb(nil) return end
	local q = topQuery(jobKey, 5)
	MySQL.Async.fetchAll(q.sql, q.params, function(rows) cb(rows or {}) end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:payBonus')
AddEventHandler('esx_uniquejobs:oversight:payBonus', function(jobKey)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'bonus')
	if not ok or Ov.Throttle(src, 'bonus', 5) or not Cfg.Watched[jobKey] then return end

	-- one payout per job per period, so the button can't drain the account
	local since = os.time() - Cfg.BonusPeriodDays * 86400
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM oversight_bonus_log WHERE job = @j AND created_at > @s', { ['@j'] = jobKey, ['@s'] = since }, function(count)
		if count and count > 0 then
			Ov.Notify(src, '~r~Bonus-e In Hafte Ghablan Pardakht Shode')
			return
		end

		local q = topQuery(jobKey, #Cfg.Bonus)
		MySQL.Async.fetchAll(q.sql, q.params, function(rows)
			rows = rows or {}
			if #rows == 0 then Ov.Notify(src, '~r~Hich Karegari Dar In Hafte Nist') return end

			TriggerEvent('esx_addonaccount:getSharedAccount', Cfg.Economy.TaxAccount, function(account)
				if not account then Ov.Notify(src, '~r~Hesab-e Dolat Peida Nashod') return end

				local paidTotal, lines = 0, {}
				for rank, r in ipairs(rows) do
					local amount = Cfg.Bonus[rank]
					local xTarget = amount and Ov.FindByIdentifier(r.identifier)
					if xTarget and account.money >= amount then
						account.removeMoney(amount)
						xTarget.addMoney(amount)
						paidTotal = paidTotal + amount
						Ov.AddOffence(xTarget.identifier, xTarget.name, jobKey, 'bonus', 'Karegar-e Bartar-e Hafte #' .. rank, amount, xPlayer)
						Ov.Notify(xTarget.source, '~g~Tabrik! Rotbe-ye ' .. rank .. ' Karegar-e Hafte (' .. jobLabel(jobKey) .. ') -- Bonus: $' .. amount)
						lines[#lines + 1] = '#' .. rank .. ' ' .. xTarget.name .. ' $' .. amount
					else
						lines[#lines + 1] = '#' .. rank .. ' ' .. tostring(r.name) .. ' (Offline / Mojoodi-e Kam) -- Pardakht Nashod'
					end
				end

				if paidTotal > 0 then
					MySQL.Async.execute('INSERT INTO oversight_bonus_log (job, paid_by, total, created_at) VALUES (@j, @by, @t, @c)', {
						['@j'] = jobKey, ['@by'] = xPlayer.name, ['@t'] = paidTotal, ['@c'] = os.time(),
					})
				end
				Ov.Notify(src, (paidTotal > 0 and '~g~' or '~r~') .. 'Bonus: $' .. paidTotal .. ' Pardakht Shod')
				Ov.Log(xPlayer, 'BONUS', '[ Job : ' .. jobKey .. ' ]\n[ Total : $' .. paidTotal .. ' ]\n' .. table.concat(lines, '\n') .. '\n')
			end)
		end)
	end)
end)

-- ------------------------------------------------------------
-- Flags
-- ------------------------------------------------------------
ESX.RegisterServerCallback('esx_uniquejobs:oversight:getFlags', function(source, cb)
	if not Ov.Can(source, 'flags') then cb(nil) return end
	MySQL.Async.fetchAll("SELECT id, identifier, name, job, kind, detail, x, y, z, case_id, created_at FROM oversight_flags WHERE status = 'open' ORDER BY id DESC LIMIT 30", {}, function(rows)
		for _, r in ipairs(rows or {}) do
			r.label = Ov.FlagLabels[r.kind] or r.kind
			r.jobLabel = jobLabel(r.job)
			r.ago = Ov.FormatRemaining(os.time() - r.created_at)
		end
		cb(rows or {})
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:resolveFlag')
AddEventHandler('esx_uniquejobs:oversight:resolveFlag', function(flagId, status)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'flags')
	if not ok or (status ~= 'dismissed' and status ~= 'confirmed') then return end
	flagId = tonumber(flagId)
	if not flagId then return end

	MySQL.Async.execute('UPDATE oversight_flags SET status = @s, handled_by = @by WHERE id = @id', {
		['@s'] = status, ['@by'] = xPlayer.name, ['@id'] = flagId,
	}, function()
		Ov.Notify(src, '~g~Hoshdar ' .. (status == 'confirmed' and 'Ta-eed' or 'Rad') .. ' Shod')
		Ov.Log(xPlayer, 'FLAG ' .. string.upper(status), '[ Flag : #' .. flagId .. ' ]\n')
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:flagToCase')
AddEventHandler('esx_uniquejobs:oversight:flagToCase', function(flagId)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'cases')
	if not ok or Ov.Throttle(src, 'case', 3) then return end
	flagId = tonumber(flagId)
	if not flagId then return end

	MySQL.Async.fetchAll('SELECT identifier, name, job, kind, detail, case_id FROM oversight_flags WHERE id = @id', { ['@id'] = flagId }, function(rows)
		local f = rows and rows[1]
		if not f then return end
		if f.case_id then Ov.Notify(src, '~y~Ghablan Parvande-ye #' .. f.case_id .. ' Baz Shode') return end

		Ov.OpenCase('[Job Watch] ' .. (Ov.FlagLabels[f.kind] or f.kind) .. ' -- ' .. f.name,
			jobLabel(f.job) .. ': ' .. tostring(f.detail),
			{ { identifier = f.identifier, name = f.name } }, xPlayer, 'medium', function(caseId)
				if not caseId then Ov.Notify(src, '~r~Sakht-e Parvande Anjam Nashod') return end
				MySQL.Async.execute('UPDATE oversight_flags SET case_id = @c, status = @s, handled_by = @by WHERE id = @id', {
					['@c'] = caseId, ['@s'] = 'confirmed', ['@by'] = xPlayer.name, ['@id'] = flagId,
				})
				Ov.Notify(src, '~g~Parvande-ye #' .. caseId .. ' Dar /doj Baz Shod')
				Ov.Log(xPlayer, 'FLAG -> CASE', '[ Flag : #' .. flagId .. ' ]\n[ Case : #' .. caseId .. ' ]\n')
			end)
	end)
end)

-- ------------------------------------------------------------
-- Complaints (anyone can file one; judge/marshal handle them)
-- ------------------------------------------------------------
RegisterServerEvent('esx_uniquejobs:oversight:fileComplaint')
AddEventHandler('esx_uniquejobs:oversight:fileComplaint', function(targetName, text)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or Ov.Throttle(src, 'complaint', 60) then
		Ov.Notify(src, '~r~Lotfan Kami Sabr Konid')
		return
	end
	text = Ov.Clean(text, 400)
	targetName = Ov.Clean(targetName, 60)
	if text == '' then return end

	MySQL.Async.insert('INSERT INTO oversight_complaints (identifier, name, target_name, text, status, created_at) VALUES (@i, @n, @t, @x, @s, @c)', {
		['@i'] = xPlayer.identifier, ['@n'] = xPlayer.name, ['@t'] = targetName, ['@x'] = text, ['@s'] = 'open', ['@c'] = os.time(),
	}, function(id)
		Ov.Notify(src, '~g~Shekayat-e Shoma Sabt Shod')
		for _, xOv in ipairs(Ov.GetOverseers('complaints')) do
			Ov.Notify(xOv.source, '~y~Shekayat-e Jadid Az Taraf-e Yek Karegar (' .. Ov.Clean(xPlayer.name, 30) .. ')')
		end
		Ov.Log(nil, 'COMPLAINT #' .. tostring(id), '[ From : ' .. xPlayer.name .. ' ]\n[ About : ' .. targetName .. ' ]\n[ Text : ' .. text .. ' ]\n')
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getComplaints', function(source, cb)
	if not Ov.Can(source, 'complaints') then cb(nil) return end
	MySQL.Async.fetchAll("SELECT id, identifier, name, target_name, text, case_id, created_at FROM oversight_complaints WHERE status = 'open' ORDER BY id DESC LIMIT 30", {}, function(rows)
		for _, r in ipairs(rows or {}) do r.ago = Ov.FormatRemaining(os.time() - r.created_at) end
		cb(rows or {})
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:resolveComplaint')
AddEventHandler('esx_uniquejobs:oversight:resolveComplaint', function(id, note)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'complaints')
	if not ok then return end
	id = tonumber(id)
	if not id then return end
	note = Ov.Clean(note, 200)

	MySQL.Async.execute("UPDATE oversight_complaints SET status = 'resolved', note = @n, handled_by = @by WHERE id = @id", {
		['@n'] = note, ['@by'] = xPlayer.name, ['@id'] = id,
	}, function()
		Ov.Notify(src, '~g~Shekayat Bayegani Shod')
		Ov.Log(xPlayer, 'COMPLAINT RESOLVED', '[ Complaint : #' .. id .. ' ]\n[ Note : ' .. note .. ' ]\n')
	end)
end)

RegisterServerEvent('esx_uniquejobs:oversight:complaintToCase')
AddEventHandler('esx_uniquejobs:oversight:complaintToCase', function(id)
	local src = source
	local ok, xPlayer = Ov.Can(src, 'cases')
	if not ok or Ov.Throttle(src, 'case', 3) then return end
	id = tonumber(id)
	if not id then return end

	MySQL.Async.fetchAll('SELECT identifier, name, target_name, text, case_id FROM oversight_complaints WHERE id = @id', { ['@id'] = id }, function(rows)
		local c = rows and rows[1]
		if not c then return end
		if c.case_id then Ov.Notify(src, '~y~Ghablan Parvande-ye #' .. c.case_id .. ' Baz Shode') return end

		Ov.OpenCase('[Job Watch] Shekayat: ' .. (c.target_name ~= '' and c.target_name or c.name), tostring(c.text), nil, xPlayer, 'medium', function(caseId)
			if not caseId then Ov.Notify(src, '~r~Sakht-e Parvande Anjam Nashod') return end
			MySQL.Async.execute("UPDATE oversight_complaints SET case_id = @c, status = 'resolved', handled_by = @by WHERE id = @id", {
				['@c'] = caseId, ['@by'] = xPlayer.name, ['@id'] = id,
			})
			Ov.Notify(src, '~g~Parvande-ye #' .. caseId .. ' Dar /doj Baz Shod')
			Ov.Log(xPlayer, 'COMPLAINT -> CASE', '[ Complaint : #' .. id .. ' ]\n[ Case : #' .. caseId .. ' ]\n')
		end)
	end)
end)

-- ------------------------------------------------------------
-- Live blips (overseers)
-- ------------------------------------------------------------
local BlipSubs = {}

RegisterServerEvent('esx_uniquejobs:oversight:blipsToggle')
AddEventHandler('esx_uniquejobs:oversight:blipsToggle', function(state)
	local src = source
	if not Ov.Can(src, 'blips') then return end
	BlipSubs[src] = state and true or nil
	if not state then TriggerClientEvent('esx_uniquejobs:oversight:blipData', src, {}) end
end)

AddEventHandler('playerDropped', function()
	BlipSubs[source] = nil
end)

CreateThread(function()
	while true do
		Wait(Cfg.BlipRefreshMs)
		if next(BlipSubs) then
			local list = {}
			for _, row in ipairs(Ov.GetRoster()) do
				local ped = GetPlayerPed(row.id)
				if ped and ped ~= 0 then
					local c = GetEntityCoords(ped)
					list[#list + 1] = {
						id = row.id, name = row.name, job = row.jobLabel, state = row.state,
						colour = (Cfg.Watched[row.job] and Cfg.Watched[row.job].colour) or 0,
						x = c.x, y = c.y, z = c.z,
					}
				end
			end
			for src in pairs(BlipSubs) do
				if Ov.Can(src, 'blips') then
					TriggerClientEvent('esx_uniquejobs:oversight:blipData', src, list)
				else
					BlipSubs[src] = nil
				end
			end
		end
	end
end)

-- ------------------------------------------------------------
-- Dashboard
-- ------------------------------------------------------------
ESX.RegisterServerCallback('esx_uniquejobs:oversight:getDashboard', function(source, cb)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end

	local from = os.date('%Y-%m-%d', os.time() - 6 * 86400)
	local now = os.time()
	Ov.QueryAll({
		{ key = 'byJob', sql = 'SELECT job, SUM(income) income, SUM(items) items, SUM(seconds) seconds, COUNT(DISTINCT identifier) workers FROM oversight_stats WHERE day >= @d GROUP BY job', params = { ['@d'] = from } },
		{ key = 'byDay', sql = 'SELECT day, SUM(income) income FROM oversight_stats WHERE day >= @d GROUP BY day ORDER BY day', params = { ['@d'] = from } },
		{ key = 'top', sql = 'SELECT MAX(name) name, MAX(job) job, SUM(income) income FROM oversight_stats WHERE day >= @d GROUP BY identifier ORDER BY income DESC LIMIT 5', params = { ['@d'] = from } },
		{ key = 'flags', sql = "SELECT COUNT(*) c FROM oversight_flags WHERE status = 'open'" },
		{ key = 'complaints', sql = "SELECT COUNT(*) c FROM oversight_complaints WHERE status = 'open'" },
		{ key = 'susp', sql = 'SELECT COUNT(*) c FROM oversight_suspensions WHERE active = 1 AND expires_at > @n', params = { ['@n'] = now } },
		{ key = 'permits', sql = 'SELECT COUNT(*) c FROM oversight_permits WHERE expires_at > @n', params = { ['@n'] = now } },
	}, function(r)
		local online = {}
		for _, row in ipairs(Ov.GetRoster()) do
			online[row.job] = online[row.job] or { total = 0, working = 0 }
			online[row.job].total = online[row.job].total + 1
			if row.state == 'working' then online[row.job].working = online[row.job].working + 1 end
		end
		local jobs = {}
		for _, j in ipairs(Cfg.JobOrder) do jobs[#jobs + 1] = { job = j, label = jobLabel(j) } end
		cb({
			jobs = jobs, online = online, byJob = r.byJob, byDay = r.byDay, top = r.top,
			openFlags = r.flags[1] and r.flags[1].c or 0,
			openComplaints = r.complaints[1] and r.complaints[1].c or 0,
			activeSuspensions = r.susp[1] and r.susp[1].c or 0,
			activePermits = r.permits[1] and r.permits[1].c or 0,
		})
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getAudit', function(source, cb)
	if not Ov.Can(source, 'audit') then cb(nil) return end
	MySQL.Async.fetchAll('SELECT spectator_name, spectator_job, target_name, target_job, started_at, ended_at, reason FROM oversight_spectate_log ORDER BY id DESC LIMIT 30', {}, function(rows)
		for _, r in ipairs(rows or {}) do
			r.ago = Ov.FormatRemaining(os.time() - r.started_at)
			r.duration = r.ended_at and Ov.FormatRemaining(r.ended_at - r.started_at) or 'Dar Hal-e Nezarat'
		end
		cb(rows or {})
	end)
end)
