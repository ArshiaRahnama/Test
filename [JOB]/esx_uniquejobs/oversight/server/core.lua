-- ============================================================
-- Job Watch (oversight) -- server core
-- Permissions, cached state (permits / suspensions / settings /
-- timed events), the live worker registry, anomaly flags and the
-- economy hooks that esx_jobs + the ScriptPack item sellers call.
--
-- esx_jobs feeds this through a plain server-side event (NOT a
-- RegisterNetEvent, so a client can never fake it):
--   TriggerEvent('esx_uniquejobs:oversight:activity', src, job, kind, items, money, zone)
-- and asks it questions through exports (CanPlayerWork,
-- ProcessJobPayout, ...). If this resource is stopped, esx_jobs
-- falls back to "everything allowed, no tax" -- see its OvCall
-- helpers -- so a crash here can never freeze the jobs.
-- ============================================================

local Cfg = Config_oversight

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ------------------------------------------------------------
-- Small helpers
-- ------------------------------------------------------------

-- Strips control chars + backticks (they'd break the Discord code
-- block the log lines sit in), trims, and cuts to `max` characters
-- without ever splitting a UTF-8 (Persian) character in half.
function Ov.Clean(s, max)
	if type(s) ~= 'string' then return '' end
	s = s:gsub('[%c`]', ' '):gsub('^%s+', ''):gsub('%s+$', '')
	max = max or 200
	local len = utf8.len(s)
	if not len then
		s = s:gsub('[\128-\255]', '?')
		len = #s
	end
	if len > max then
		s = s:sub(1, (utf8.offset(s, max + 1) or (#s + 1)) - 1)
	end
	return s
end

function Ov.Notify(src, msg)
	TriggerClientEvent('esx:showNotification', src, msg)
end

function Ov.FormatRemaining(seconds)
	seconds = math.max(0, math.floor(seconds or 0))
	local d = math.floor(seconds / 86400)
	local h = math.floor((seconds % 86400) / 3600)
	local m = math.floor((seconds % 3600) / 60)
	if d > 0 then return d .. 'd ' .. h .. 'h' end
	if h > 0 then return h .. 'h ' .. m .. 'm' end
	return math.max(1, m) .. 'm'
end

local throttles = {}
-- returns true when the call should be IGNORED (too soon)
function Ov.Throttle(src, key, seconds)
	local k = tostring(src) .. ':' .. key
	local now = os.time()
	if throttles[k] and now - throttles[k] < seconds then return true end
	throttles[k] = now
	return false
end

-- Runs several SELECTs at once, calls cb({key = rows, ...}) when
-- the last one comes back.
function Ov.QueryAll(list, cb)
	local results, pending = {}, #list
	if pending == 0 then cb(results) return end
	for _, q in ipairs(list) do
		MySQL.Async.fetchAll(q.sql, q.params or {}, function(rows)
			results[q.key] = rows or {}
			pending = pending - 1
			if pending == 0 then cb(results) end
		end)
	end
end

-- ------------------------------------------------------------
-- Permissions
-- ------------------------------------------------------------
function Ov.GetRole(xPlayer)
	if not xPlayer or not xPlayer.job then return nil end
	local role = Cfg.Roles[xPlayer.job.name]
	if role and (tonumber(xPlayer.job.grade) or 0) >= (role.minGrade or 0) then
		return role, xPlayer.job.name
	end
	if Cfg.AdminPermissionLevel and (tonumber(xPlayer.permission_level) or 0) >= Cfg.AdminPermissionLevel then
		return Cfg.Roles.judge, 'admin'
	end
	return nil
end

-- ok, xPlayer, role, roleName = Ov.Can(source, 'spectate')
function Ov.Can(src, perm)
	local xPlayer = ESX.GetPlayerFromId(tonumber(src))
	local role, roleName = Ov.GetRole(xPlayer)
	if not role or (perm and not role.perms[perm]) then
		return false, xPlayer, role, roleName
	end
	return true, xPlayer, role, roleName
end

function Ov.GetOverseers(perm)
	local list = {}
	for _, id in pairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(id)
		local role = Ov.GetRole(xPlayer)
		if role and (not perm or role.perms[perm]) then
			list[#list + 1] = xPlayer
		end
	end
	return list
end

function Ov.FindByIdentifier(identifier)
	for _, id in pairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(id)
		if xPlayer and xPlayer.identifier == identifier then return xPlayer end
	end
	return nil
end

function Ov.Log(xPlayer, action, lines)
	local who = ''
	if xPlayer then
		who = '[ Officer : ' .. tostring(xPlayer.name) .. ' (' .. tostring(xPlayer.source) .. ') ]\n' ..
			'[ Steam : ' .. tostring(xPlayer.identifier) .. ' ]\n' ..
			'[ Job : ' .. tostring(xPlayer.job and xPlayer.job.name) .. ' ]\n'
	end
	TriggerEvent('DiscordBot:ToDiscord', Cfg.LogCategory, 'JobWatchLog',
		'```css\n' .. who .. '[ Action : ' .. action .. ' ]\n' .. (lines or '') .. '```',
		'user', true, xPlayer and xPlayer.source or nil, false)
end

-- ------------------------------------------------------------
-- Cached state: settings / permits / suspensions / timed events
-- ------------------------------------------------------------
local Settings = {}      -- Settings[job] = { tax = 0.05, mult = 1.0 }
local Permits = {}       -- Permits[identifier][job] = expires_at
local Suspensions = {}   -- Suspensions[identifier][id] = { job, reason, expires }
local Events = { closed = {}, bonus = {} }  -- Events.kind[job or '*'] = { untilTs, by, mult }
local RecentFlag = {}    -- RecentFlag[identifier] = ts (lets a flagged player be spectated)

Ov.Cache = { Settings = Settings, Permits = Permits, Suspensions = Suspensions, Events = Events }

local function LoadState()
	local now = os.time()
	local ok, err = pcall(function()
		local rows = MySQL.Sync.fetchAll('SELECT job, tax_rate, price_mult FROM oversight_settings', {}) or {}
		for _, r in ipairs(rows) do
			Settings[r.job] = { tax = tonumber(r.tax_rate) or 0, mult = tonumber(r.price_mult) or 1 }
		end

		rows = MySQL.Sync.fetchAll('SELECT identifier, job, expires_at FROM oversight_permits WHERE expires_at > @now', { ['@now'] = now }) or {}
		for _, r in ipairs(rows) do
			Permits[r.identifier] = Permits[r.identifier] or {}
			Permits[r.identifier][r.job] = r.expires_at
		end

		rows = MySQL.Sync.fetchAll('SELECT id, identifier, job, reason, expires_at FROM oversight_suspensions WHERE active = 1 AND expires_at > @now', { ['@now'] = now }) or {}
		for _, r in ipairs(rows) do
			Suspensions[r.identifier] = Suspensions[r.identifier] or {}
			Suspensions[r.identifier][r.id] = { job = r.job, reason = r.reason, expires = r.expires_at }
		end
	end)
	return ok, err
end

-- db_migrations.lua creates the tables from its own thread at start;
-- retry for a while instead of assuming it already finished.
CreateThread(function()
	for attempt = 1, 20 do
		local ok = LoadState()
		if ok then
			print('[esx_uniquejobs] Job Watch: state loaded')
			return
		end
		Wait(2000)
	end
	print('[esx_uniquejobs] Job Watch: could not load state (oversight_* tables missing?) -- running with defaults')
end)

local function ActiveSuspension(identifier, jobKey)
	local t = Suspensions[identifier]
	if not t then return nil end
	local now = os.time()
	for id, s in pairs(t) do
		if s.expires <= now then
			t[id] = nil
		elseif s.job == '*' or s.job == jobKey then
			return s, id
		end
	end
	return nil
end
Ov.ActiveSuspension = ActiveSuspension

local function HasPermit(identifier, jobKey)
	local t = Permits[identifier]
	return t ~= nil and t[jobKey] ~= nil and t[jobKey] > os.time()
end
Ov.HasPermit = HasPermit

local function ActiveEvent(kind, jobKey)
	local now = os.time()
	for _, key in ipairs({ jobKey, '*' }) do
		local e = Events[kind][key]
		if e then
			if e.untilTs <= now then
				Events[kind][key] = nil
			else
				return e, key
			end
		end
	end
	return nil
end
Ov.ActiveEvent = ActiveEvent

-- setters used by actions.lua so the cache and the DB never drift
function Ov.SetSetting(jobKey, tax, mult) Settings[jobKey] = { tax = tax, mult = mult } end
function Ov.SetPermit(identifier, jobKey, expires)
	Permits[identifier] = Permits[identifier] or {}
	Permits[identifier][jobKey] = expires
end
function Ov.ClearPermit(identifier, jobKey)
	if Permits[identifier] then Permits[identifier][jobKey] = nil end
end
function Ov.AddSuspensionCache(identifier, id, job, reason, expires)
	Suspensions[identifier] = Suspensions[identifier] or {}
	Suspensions[identifier][id] = { job = job, reason = reason, expires = expires }
end
function Ov.RemoveSuspensionCache(id)
	for _, t in pairs(Suspensions) do
		if t[id] then t[id] = nil return true end
	end
	return false
end
function Ov.MarkRecentFlag(identifier) RecentFlag[identifier] = os.time() end

-- ------------------------------------------------------------
-- Can this player work / take this job right now?
-- ------------------------------------------------------------
local function CanWork(src, jobKey)
	local w = Cfg.Watched[jobKey]
	if not w then return { ok = true } end
	local xPlayer = ESX.GetPlayerFromId(tonumber(src))
	if not xPlayer then return { ok = true } end

	local closed = ActiveEvent('closed', jobKey)
	if closed then
		return { ok = false, reason = '~r~In Shoghl Movaghatan Baste Shode (' .. Ov.FormatRemaining(closed.untilTs - os.time()) .. ' Baghi)' }
	end

	local s = ActiveSuspension(xPlayer.identifier, jobKey)
	if s then
		return { ok = false, reason = '~r~Shoma Az In Shoghl Ta ' .. Ov.FormatRemaining(s.expires - os.time()) .. ' Dige Tarigh Shodid: ' .. tostring(s.reason) }
	end

	if w.permit and not HasPermit(xPlayer.identifier, jobKey) then
		local graceActive = Cfg.Permits.GraceIfNoOversightOnline and #Ov.GetOverseers('permits') == 0
		if not graceActive then
			return { ok = false, reason = '~r~Baraye In Shoghl Bayad Mojavez Az Ghazi Begirid' }
		end
	end

	return { ok = true }
end

-- Taking the job (Job Center) is only blocked by a suspension --
-- a closure or a missing permit only stops the actual work.
local function CanTakeJob(src, jobKey)
	local xPlayer = ESX.GetPlayerFromId(tonumber(src))
	if not xPlayer then return { ok = true } end
	local s = ActiveSuspension(xPlayer.identifier, jobKey)
	if s then
		return { ok = false, reason = '~r~Shoma Az In Shoghl Ta ' .. Ov.FormatRemaining(s.expires - os.time()) .. ' Dige Tarigh Shodid: ' .. tostring(s.reason) }
	end
	return { ok = true }
end

-- ------------------------------------------------------------
-- Live worker registry (a "shift" = a run of work with gaps
-- shorter than Stats.ShiftIdleSeconds)
-- ------------------------------------------------------------
local Workers = {}   -- Workers[src] = shift table
Ov.Workers = Workers

local function DayKey() return os.date('%Y-%m-%d') end

local function FlushWorker(w)
	if not w then return end
	if w.pendItems == 0 and w.pendIncome == 0 and w.pendSales == 0 and w.pendSeconds == 0 then return end

	MySQL.Async.execute([[
		INSERT INTO oversight_stats (identifier, job, day, name, items, income, seconds, sales)
		VALUES (@i, @j, @d, @n, @it, @inc, @s, @sa)
		ON DUPLICATE KEY UPDATE name = VALUES(name), items = items + VALUES(items),
			income = income + VALUES(income), seconds = seconds + VALUES(seconds), sales = sales + VALUES(sales)
	]], {
		['@i'] = w.identifier, ['@j'] = w.job, ['@d'] = DayKey(), ['@n'] = w.name,
		['@it'] = w.pendItems, ['@inc'] = w.pendIncome, ['@s'] = w.pendSeconds, ['@sa'] = w.pendSales,
	})

	w.pendItems, w.pendIncome, w.pendSales, w.pendSeconds = 0, 0, 0, 0
end

local function NewShift(src, xPlayer, jobKey, now)
	return {
		identifier = xPlayer.identifier, name = xPlayer.name, job = jobKey,
		startedAt = now, lastActivity = now, zone = nil,
		items = {}, itemsTotal = 0, income = 0, sales = 0,
		events = {}, incomeLog = {}, lastFlag = {}, flagCount = 0, offJob = false,
		pendItems = 0, pendIncome = 0, pendSales = 0, pendSeconds = 0,
	}
end

-- ------------------------------------------------------------
-- Flags (automatic anomaly alerts)
-- ------------------------------------------------------------
local FlagLabels = {
	rate = 'Sor-at-e Kar Gheyr-e Manteghi',
	income = 'Daramad-e Gheyr-e Manteghi',
	offjob = 'Kar Bedoon-e Shoghl',
	nopermit = 'Kar Bedoon-e Mojavez',
}
Ov.FlagLabels = FlagLabels

-- Opens a real /doj case through the existing global from
-- server/doj_cases.lua (same way evidence/ and CAD do).
function Ov.OpenCase(title, evidenceText, suspects, xOfficer, priority, cb)
	if not CreateExternalCase then
		if cb then cb(nil) end
		return
	end
	CreateExternalCase({
		title = title,
		priority = priority or 'medium',
		openedByName = xOfficer and xOfficer.name or 'Job Watch',
		openedByJob = xOfficer and xOfficer.job.name or 'judge',
		evidenceText = evidenceText,
		suspects = suspects,
	}, cb)
end

local function RaiseFlag(src, xPlayer, w, kind, detail)
	local now = os.time()
	if w.lastFlag[kind] and now - w.lastFlag[kind] < Cfg.Flags.CooldownSeconds then return end
	w.lastFlag[kind] = now
	w.flagCount = w.flagCount + 1
	RecentFlag[xPlayer.identifier] = now

	local ped = GetPlayerPed(src)
	local coords = (ped and ped ~= 0) and GetEntityCoords(ped) or vector3(0.0, 0.0, 0.0)
	detail = Ov.Clean(detail, 200)

	MySQL.Async.insert('INSERT INTO oversight_flags (identifier, name, job, kind, detail, x, y, z, status, created_at) VALUES (@i, @n, @j, @k, @d, @x, @y, @z, @st, @t)', {
		['@i'] = xPlayer.identifier, ['@n'] = xPlayer.name, ['@j'] = w.job, ['@k'] = kind, ['@d'] = detail,
		['@x'] = coords.x, ['@y'] = coords.y, ['@z'] = coords.z, ['@st'] = 'open', ['@t'] = now,
	}, function(flagId)
		if Cfg.Flags.AutoCase and flagId then
			Ov.OpenCase('[Job Watch] ' .. (FlagLabels[kind] or kind) .. ' -- ' .. xPlayer.name,
				detail, { { identifier = xPlayer.identifier, name = xPlayer.name } }, nil, 'medium', function(caseId)
					if caseId then
						MySQL.Async.execute('UPDATE oversight_flags SET case_id = @c WHERE id = @id', { ['@c'] = caseId, ['@id'] = flagId })
					end
				end)
		end
	end)

	for _, xOv in ipairs(Ov.GetOverseers('flags')) do
		TriggerClientEvent('esx_uniquejobs:oversight:alert', xOv.source, {
			kind = kind, label = FlagLabels[kind] or kind, name = xPlayer.name, id = src,
			job = w.job, jobLabel = Cfg.Watched[w.job] and Cfg.Watched[w.job].label or w.job,
			detail = detail, x = coords.x, y = coords.y, z = coords.z,
		})
	end

	Ov.Log(nil, 'FLAG: ' .. kind, '[ Worker : ' .. xPlayer.name .. ' (' .. src .. ') ]\n[ Steam : ' .. xPlayer.identifier .. ' ]\n[ Job : ' .. w.job .. ' ]\n[ Detail : ' .. detail .. ' ]\n')
end

-- ------------------------------------------------------------
-- Activity intake
--   items = { item_name = count, ... }   (may be nil)
--   money = what the worker actually received (after tax), 0 if none
-- ------------------------------------------------------------
function Ov.RecordActivity(src, jobKey, kind, items, money, zone)
	local wcfg = Cfg.Watched[jobKey]
	if not wcfg then return end
	local xPlayer = ESX.GetPlayerFromId(tonumber(src))
	if not xPlayer then return end

	local now = os.time()
	local w = Workers[src]
	if w and (w.job ~= jobKey or w.identifier ~= xPlayer.identifier or now - w.lastActivity > Cfg.Stats.ShiftIdleSeconds) then
		FlushWorker(w)
		w = nil
	end
	if not w then
		w = NewShift(src, xPlayer, jobKey, now)
		Workers[src] = w
	end

	-- time worked: only count gaps that are still "the same shift"
	local gap = now - w.lastActivity
	if gap > 0 and gap <= Cfg.Stats.ShiftIdleSeconds then w.pendSeconds = w.pendSeconds + gap end
	w.lastActivity = now
	if zone then w.zone = zone end

	local total = 0
	if type(items) == 'table' then
		for name, count in pairs(items) do
			count = math.floor(tonumber(count) or 0)
			if count > 0 then
				w.items[name] = (w.items[name] or 0) + count
				total = total + count
			end
		end
	end
	w.itemsTotal = w.itemsTotal + total
	w.pendItems = w.pendItems + total

	money = math.floor(tonumber(money) or 0)
	if money > 0 then
		w.income = w.income + money
		w.sales = w.sales + 1
		w.pendIncome = w.pendIncome + money
		w.pendSales = w.pendSales + 1
		w.incomeLog[#w.incomeLog + 1] = { now, money }
	end

	-- ---- anomaly checks ----
	w.events[#w.events + 1] = now
	local cutoff = now - 60
	while w.events[1] and w.events[1] < cutoff do table.remove(w.events, 1) end
	if #w.events > wcfg.maxEventsPerMin then
		RaiseFlag(src, xPlayer, w, 'rate', #w.events .. ' Kar Dar 60 Sanie (Hadd-e Mojaz: ' .. wcfg.maxEventsPerMin .. ')')
	end

	cutoff = now - 600
	local sum = 0
	local kept = {}
	for _, e in ipairs(w.incomeLog) do
		if e[1] >= cutoff then kept[#kept + 1] = e; sum = sum + e[2] end
	end
	w.incomeLog = kept
	if sum > wcfg.maxIncome10Min then
		RaiseFlag(src, xPlayer, w, 'income', '$' .. sum .. ' Daramad Dar 10 Daghighe (Hadd: $' .. wcfg.maxIncome10Min .. ')')
	end

	if xPlayer.job.name ~= jobKey and not wcfg.openActivity then
		w.offJob = true
		RaiseFlag(src, xPlayer, w, 'offjob', 'Shoghl-e Feli: ' .. tostring(xPlayer.job.name) .. ' -- Kar Dar: ' .. jobKey)
	end

	if wcfg.permit and not HasPermit(xPlayer.identifier, jobKey) then
		RaiseFlag(src, xPlayer, w, 'nopermit', 'Bedoon-e Mojavez-e ' .. wcfg.label)
	end
end

-- Server-only event (no RegisterNetEvent): only other server
-- scripts can trigger it.
AddEventHandler('esx_uniquejobs:oversight:activity', function(src, jobKey, kind, items, money, zone)
	if type(jobKey) ~= 'string' then return end
	Ov.RecordActivity(src, jobKey, kind, items, money, zone)
end)

-- periodic flush + idle shift cleanup
CreateThread(function()
	while true do
		Wait(Cfg.Stats.FlushSeconds * 1000)
		local now = os.time()
		for src, w in pairs(Workers) do
			FlushWorker(w)
			if now - w.lastActivity > Cfg.Stats.ShiftIdleSeconds * 2 then
				Workers[src] = nil
			end
		end
	end
end)

AddEventHandler('playerDropped', function()
	local src = source
	if Workers[src] then
		FlushWorker(Workers[src])
		Workers[src] = nil
	end
end)

-- ------------------------------------------------------------
-- Roster rows (used by the menu, blips and the spectate HUD)
-- ------------------------------------------------------------
function Ov.BuildWorkerRow(xTarget)
	if not xTarget or not xTarget.job then return nil end
	local src = xTarget.source
	local now = os.time()
	local w = Workers[src]
	local jobKey = xTarget.job.name
	local onWatchedJob = Cfg.Watched[jobKey] ~= nil
	local recentOffJob = w and (now - w.lastActivity <= Cfg.Spectate.OffJobActivityWindow)

	if not onWatchedJob and not recentOffJob then return nil end

	local activeJob = onWatchedJob and jobKey or w.job
	local state = 'idle'
	if w then
		local since = now - w.lastActivity
		if since <= Cfg.Stats.WorkingSeconds then state = 'working'
		elseif since <= Cfg.Stats.ShiftIdleSeconds then state = 'break' end
	end

	local row = {
		id = src, name = xTarget.name, job = activeJob,
		jobLabel = Cfg.Watched[activeJob] and Cfg.Watched[activeJob].label or activeJob,
		grade = xTarget.job.grade_label,
		offJob = not onWatchedJob,
		state = state,
		sinceMin = w and math.floor((now - w.lastActivity) / 60) or nil,
		shiftMin = w and math.floor((w.lastActivity - w.startedAt) / 60) or 0,
		items = w and w.itemsTotal or 0,
		income = w and w.income or 0,
		sales = w and w.sales or 0,
		zone = w and w.zone or nil,
		flags = w and w.flagCount or 0,
		suspended = ActiveSuspension(xTarget.identifier, activeJob) ~= nil,
	}
	if Cfg.Watched[activeJob] and Cfg.Watched[activeJob].permit then
		row.permit = HasPermit(xTarget.identifier, activeJob)
	end
	return row
end

function Ov.GetRoster()
	local rows = {}
	for _, id in pairs(ESX.GetPlayers()) do
		local row = Ov.BuildWorkerRow(ESX.GetPlayerFromId(id))
		if row then rows[#rows + 1] = row end
	end
	local order = {}
	for i, j in ipairs(Cfg.JobOrder) do order[j] = i end
	table.sort(rows, function(a, b)
		if a.job ~= b.job then return (order[a.job] or 99) < (order[b.job] or 99) end
		return a.name < b.name
	end)
	return rows
end

-- may this target be spectated / inspected at all?
function Ov.IsOversightTarget(xTarget)
	if not xTarget then return false end
	if Cfg.Spectate.AllowAnyone then return true end
	if Ov.BuildWorkerRow(xTarget) then return true end
	local t = RecentFlag[xTarget.identifier]
	return t ~= nil and os.time() - t <= 1800
end

-- ------------------------------------------------------------
-- Economy
-- ------------------------------------------------------------
local function GetMods(jobKey)
	local s = Settings[jobKey]
	local bonus = ActiveEvent('bonus', jobKey)
	return {
		tax = s and s.tax or Cfg.Economy.DefaultTaxRate,
		mult = s and s.mult or 1.0,
		bonus = bonus and bonus.mult or 1.0,
		closed = ActiveEvent('closed', jobKey) ~= nil,
	}
end
Ov.GetMods = GetMods

-- gross -> { net, tax, adjusted }. Does NOT record stats: the caller
-- either reports the payout through the activity event (esx_jobs) or
-- goes through ProcessJobSale (which records it).
local function Payout(src, jobKey, gross)
	gross = math.floor(tonumber(gross) or 0)
	if gross <= 0 or not Cfg.Watched[jobKey] then
		return { net = math.max(0, gross), tax = 0, adjusted = math.max(0, gross) }
	end

	local m = GetMods(jobKey)
	local adjusted = math.floor(gross * m.mult * m.bonus + 0.5)
	local tax = math.floor(adjusted * m.tax)
	local net = adjusted - tax

	if tax > 0 then
		TriggerEvent('esx_addonaccount:getSharedAccount', Cfg.Economy.TaxAccount, function(account)
			if account then account.addMoney(tax) end
		end)
	end

	if src and (tax > 0 or m.mult ~= 1.0 or m.bonus ~= 1.0) then
		local parts = {}
		if m.mult ~= 1.0 then parts[#parts + 1] = 'Zarib-e Gheymat x' .. string.format('%.2f', m.mult) end
		if m.bonus ~= 1.0 then parts[#parts + 1] = '~g~Event x' .. string.format('%.2f', m.bonus) .. '~w~' end
		if tax > 0 then parts[#parts + 1] = '~r~Maliat ' .. math.floor(m.tax * 100 + 0.5) .. '% (-$' .. tax .. ')~w~' end
		Ov.Notify(src, table.concat(parts, ' | '))
	end

	return { net = net, tax = tax, adjusted = adjusted }
end

exports('CanPlayerWork', function(src, jobKey) return CanWork(src, jobKey) end)
exports('CanTakeJob', function(src, jobKey) return CanTakeJob(src, jobKey) end)
exports('GetJobModifiers', function(jobKey) return GetMods(jobKey) end)
exports('IsJobSuspended', function(identifier, jobKey) return ActiveSuspension(identifier, jobKey) ~= nil end)

-- esx_jobs Work() delivery + mining sale: tick reports the income itself
exports('ProcessJobPayout', function(src, jobKey, gross)
	return Payout(src, jobKey, gross)
end)

-- ScriptPack item sellers: item name -> job, applies price/tax, and
-- records the sale in the worker's stats.
exports('ProcessJobSale', function(src, itemName, gross, amount)
	local jobKey = Cfg.Economy.SaleItems[itemName]
	if not jobKey then
		gross = math.floor(tonumber(gross) or 0)
		return { net = gross, tax = 0, adjusted = gross, job = nil }
	end
	local res = Payout(src, jobKey, gross)
	res.job = jobKey
	Ov.RecordActivity(src, jobKey, 'sale', { [itemName] = tonumber(amount) or 1 }, res.net, 'seller')
	return res
end)
