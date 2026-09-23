-- ============================================================
-- Job Watch (oversight) -- /jobwatch menu (ox_lib contexts,
-- same look and feel as /doj and /agent). Also reachable from
-- /doj for judge + marshal. Every button only asks the server;
-- the server re-checks role + limits on every action.
-- ============================================================

local Cfg = Config_oversight
local T = 'esx_uniquejobs:oversight:'

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(200)
	end
end)

Ov.Perms = nil
Ov.RoleInfo = nil
local blipsOn = false
local lastRoster = {}

local function can(perm) return Ov.Perms ~= nil and Ov.Perms[perm] == true end
local function money(n) return '$' .. tostring(math.floor(tonumber(n) or 0)) end
local function clean(name) return (tostring(name or '?'):gsub('_', ' ')) end
local function ago(ts) return ts end

local function jobOptions(includeAll)
	local out = {}
	if includeAll then out[#out + 1] = { value = '*', label = 'Hame-ye Shoghl-ha' } end
	for _, j in ipairs(Cfg.JobOrder) do
		out[#out + 1] = { value = j, label = Cfg.Watched[j].label }
	end
	return out
end

local stateIcon = { working = 'person-digging', ['break'] = 'mug-hot', idle = 'bed' }
local stateText = { working = 'Dar Hal-e Kar', ['break'] = 'Estrahat', idle = 'Bikar' }

local function show(id, title, back, options)
	lib.registerContext({ id = id, title = title, menu = back, options = options })
	lib.showContext(id)
end

local function empty(text)
	return { { title = text, disabled = true, icon = 'circle-info' } }
end

-- ============================================================
-- Main menu
-- ============================================================
function Ov.OpenMainMenu()
	ESX.TriggerServerCallback(T .. 'getRole', function(role)
		if not role then
			ESX.ShowNotification('~r~Faghat Ghazi Ya Marshal Mitavanad In Menu Ra Baz Konad')
			return
		end
		Ov.Perms, Ov.RoleInfo = role.perms, role

		local o = {}
		o[#o + 1] = {
			title = 'Job Watch -- ' .. string.upper(role.role),
			description = 'Nezarat Bar Fisherman, Fueler, Lumberjack, Slaughterer, Tailor, Miner',
			icon = 'scale-balanced', disabled = true,
		}

		if Ov.Spec.active then
			o[#o + 1] = { title = 'Dar Hal-e Nezarat -- Payan', icon = 'eye-slash', onSelect = function() Ov.StopSpectate(false) end }
			o[#o + 1] = { title = 'Menu-ye Nezarat', icon = 'eye', onSelect = function() Ov.OpenSpectateMenu() end }
		end

		if can('dashboard') then
			o[#o + 1] = { title = 'Karegaran-e Online (Live)', description = 'Vaziat-e Zende, Spectate, Bazresi, Akhtar, Jarime', icon = 'users', onSelect = function() Ov.OpenRoster() end }
			o[#o + 1] = { title = 'Dashboard', description = 'Daramad, Kar-e Hafte, Amar-e Koli', icon = 'chart-column', onSelect = function() Ov.OpenDashboard() end }
		end
		if can('flags') then
			o[#o + 1] = { title = 'Hoshdar-ha (Flags)', description = 'Kar-e Gheyr-e Manteghi, Bedoon-e Mojavez, Daramad-e Ajib', icon = 'triangle-exclamation', onSelect = function() Ov.OpenFlags() end }
			if Ov.LastAlert then
				o[#o + 1] = { title = 'GPS Be Akharin Hoshdar', description = clean(Ov.LastAlert.name), icon = 'location-dot', onSelect = function()
					SetNewWaypoint(Ov.LastAlert.x + 0.0, Ov.LastAlert.y + 0.0)
					ESX.ShowNotification('~g~GPS Set Shod')
				end }
			end
		end
		if can('complaints') then
			o[#o + 1] = { title = 'Shekayat-ha', description = 'Shekayat-haye Karegaran', icon = 'inbox', onSelect = function() Ov.OpenComplaints() end }
		end
		if can('permits') or can('permit_revoke') then
			o[#o + 1] = { title = 'Mojavez-ha (Permits)', icon = 'id-badge', onSelect = function() Ov.OpenPermits() end }
		end
		if can('suspend') or can('lift') then
			o[#o + 1] = { title = 'Tarigh-haye Faal', icon = 'user-slash', onSelect = function() Ov.OpenSuspensions() end }
		end
		if can('dashboard') then
			o[#o + 1] = { title = 'Eghtesad (Maliat + Gheymat)', description = 'Maliat Va Zarib-e Gheymat-e Har Shoghl', icon = 'coins', onSelect = function() Ov.OpenEconomy() end }
		end
		if can('events') then
			o[#o + 1] = { title = 'Event-ha', description = 'Pardakht-e Do Barabar, Ta\'til-e Movaghat-e Shoghl', icon = 'bolt', onSelect = function() Ov.OpenEvents() end }
		end
		if can('bonus') then
			o[#o + 1] = { title = 'Karegar-e Bartar-e Hafte', description = 'Bonus Be 3 Nafar-e Aval', icon = 'trophy', onSelect = function() Ov.OpenTopMenu() end }
		end
		if can('announce') then
			o[#o + 1] = { title = 'Elam-e Omoomi', description = 'Payam Be Hame-ye Karegaran-e Yek Shoghl', icon = 'bullhorn', onSelect = function()
				local input = lib.inputDialog('Elam-e Omoomi', {
					{ type = 'select', label = 'Shoghl', options = jobOptions(true), required = true, default = '*' },
					{ type = 'input', label = 'Matn', required = true, max = 200 },
				})
				if input then TriggerServerEvent(T .. 'announce', input[1], input[2]) end
			end }
		end
		if can('blips') then
			o[#o + 1] = { title = blipsOn and 'Blip-haye Zende: ROSHAN' or 'Blip-haye Zende: KHAMOOSH', description = 'Makan-e Zende-ye Karegaran Rooye Naghshe', icon = 'map-location-dot', onSelect = function()
				blipsOn = not blipsOn
				TriggerServerEvent(T .. 'blipsToggle', blipsOn)
				ESX.ShowNotification(blipsOn and '~g~Blip-ha Roshan Shod' or '~y~Blip-ha Khamoosh Shod')
				Ov.OpenMainMenu()
			end }
		end
		if can('audit') then
			o[#o + 1] = { title = 'Log-e Nezarat (Audit)', description = 'Ke Ki Ra Nezarat Karde Ast', icon = 'clipboard-list', onSelect = function() Ov.OpenAudit() end }
		end

		show('ov_main', 'Job Watch', nil, o)
	end)
end
OpenJobWatchMenu = Ov.OpenMainMenu -- global: called from client/doj_menu.lua

-- ============================================================
-- Live roster
-- ============================================================
function Ov.OpenRoster()
	ESX.TriggerServerCallback(T .. 'getRoster', function(rows)
		if not rows then return end
		lastRoster = rows

		local perJob = {}
		for _, r in ipairs(rows) do
			perJob[r.job] = perJob[r.job] or { total = 0, working = 0 }
			perJob[r.job].total = perJob[r.job].total + 1
			if r.state == 'working' then perJob[r.job].working = perJob[r.job].working + 1 end
		end

		local o = {}
		for _, j in ipairs(Cfg.JobOrder) do
			local c = perJob[j] or { total = 0, working = 0 }
			o[#o + 1] = {
				title = Cfg.Watched[j].label,
				description = c.total .. ' Online | ' .. c.working .. ' Dar Hal-e Kar',
				icon = 'briefcase', arrow = c.total > 0, disabled = c.total == 0,
				onSelect = function() Ov.OpenJobRoster(j) end,
			}
		end
		show('ov_roster', 'Karegaran-e Online', 'ov_main', o)
	end)
end

function Ov.OpenJobRoster(jobKey)
	local o = {}
	for _, r in ipairs(lastRoster) do
		if r.job == jobKey then
			local desc = (stateText[r.state] or '?') .. ' | Shift: ' .. r.shiftMin .. 'm | Item: ' .. r.items .. ' | ' .. money(r.income)
			if r.offJob then desc = desc .. ' | (Kharej Az Shoghl)' end
			o[#o + 1] = {
				title = clean(r.name) .. ' [' .. r.id .. ']',
				description = desc,
				icon = r.suspended and 'user-slash' or (stateIcon[r.state] or 'user'),
				iconColor = r.flags > 0 and 'red' or nil,
				metadata = r.flags > 0 and { { label = 'Hoshdar', value = r.flags } } or nil,
				onSelect = function() Ov.OpenWorkerMenu(r.id, 'ov_jobroster') end,
			}
		end
	end
	if #o == 0 then o = empty('Hich Karegari Online Nist') end
	show('ov_jobroster', Cfg.Watched[jobKey].label, 'ov_roster', o)
end

-- ============================================================
-- One worker: file + every action
-- ============================================================
local function askReason(title)
	local input = lib.inputDialog(title, { { type = 'input', label = 'Dalil', required = true, max = 200 } })
	return input and input[1]
end

function Ov.OpenWorkerMenu(id, back)
	ESX.TriggerServerCallback(T .. 'getWorkerFile', function(f)
		if not f then ESX.ShowNotification('~r~Bazikon Peida Nashod') return end
		local r = f.row
		local o = {}

		o[#o + 1] = {
			title = clean(f.name) .. ' [' .. f.id .. ']',
			description = f.jobLabel .. ' | ' .. tostring(f.grade or '-') .. (r and (' | ' .. (stateText[r.state] or '?') .. ' | Shift: ' .. r.shiftMin .. 'm | Item: ' .. r.items .. ' | ' .. money(r.income)) or ''),
			icon = 'id-card', disabled = true,
		}
		if f.suspension then
			o[#o + 1] = { title = 'TARIGH: ' .. f.suspension.left .. ' Baghi', description = f.suspension.reason, icon = 'user-slash', iconColor = 'red', disabled = true }
		end
		for _, p in ipairs(f.permits or {}) do
			o[#o + 1] = { title = 'Mojavez ' .. p.label .. ': ' .. (p.has and 'Darad' or 'NADARAD'), icon = 'id-badge', iconColor = p.has and 'green' or 'red', disabled = true }
		end

		if can('spectate') then
			o[#o + 1] = { title = 'Nezarat (Spectate)', description = 'Deedan-e Zende-ye Karegar', icon = 'eye', onSelect = function() Ov.StartSpectate(f.id) end }
		end
		if can('inspect') then
			o[#o + 1] = { title = 'Bazresi (Inspect)', description = 'Bayad Nazdik Bashid -- Mojavez, Sabeghe, Item-haye Mashkook', icon = 'magnifying-glass', onSelect = function() Ov.Inspect(f.id) end }
		end
		if can('warn') then
			o[#o + 1] = { title = 'Akhtar (Warn)', icon = 'triangle-exclamation', onSelect = function()
				local reason = askReason('Akhtar Be ' .. clean(f.name))
				if reason then TriggerServerEvent(T .. 'warn', f.id, reason) end
				Ov.OpenWorkerMenu(id, back)
			end }
			o[#o + 1] = { title = 'Ersal-e Payam', icon = 'comment-dots', onSelect = function()
				local input = lib.inputDialog('Payam Be ' .. clean(f.name), { { type = 'input', label = 'Matn', required = true, max = 200 } })
				if input then TriggerServerEvent(T .. 'message', f.id, input[1]) end
				Ov.OpenWorkerMenu(id, back)
			end }
		end
		if can('fine') then
			local maxFine = Ov.RoleInfo and Ov.RoleInfo.maxFine or 0
			o[#o + 1] = { title = 'Jarime (Fine)', description = 'Hadd-e Aksar: ' .. money(maxFine), icon = 'file-invoice-dollar', onSelect = function()
				local input = lib.inputDialog('Jarime Baraye ' .. clean(f.name), {
					{ type = 'number', label = 'Mablagh ($)', required = true, min = 1, max = maxFine },
					{ type = 'input', label = 'Dalil', required = true, max = 150 },
				})
				if input then TriggerServerEvent(T .. 'fine', f.id, input[1], input[2]) end
				Ov.OpenWorkerMenu(id, back)
			end }
		end
		if can('suspend') then
			local maxH = Ov.RoleInfo and Ov.RoleInfo.maxSuspendHours or 24
			o[#o + 1] = { title = 'Tarigh Az Shoghl (Suspend)', description = 'Hadd-e Aksar: ' .. maxH .. ' Saat', icon = 'user-slash', onSelect = function()
				local input = lib.inputDialog('Tarigh -- ' .. clean(f.name), {
					{ type = 'select', label = 'Shoghl', options = jobOptions(true), required = true, default = Cfg.Watched[f.job] and f.job or '*' },
					{ type = 'number', label = 'Modat (Saat)', required = true, default = 1, min = 1, max = maxH },
					{ type = 'input', label = 'Dalil', required = true, max = 150 },
				})
				if input then TriggerServerEvent(T .. 'suspend', f.id, input[1], input[2], input[3]) end
				Ov.OpenWorkerMenu(id, back)
			end }
		end
		if can('permits') then
			o[#o + 1] = { title = 'Sodur-e Mojavez', icon = 'id-badge', onSelect = function()
				local input = lib.inputDialog('Mojavez Baraye ' .. clean(f.name), {
					{ type = 'select', label = 'Shoghl', options = jobOptions(false), required = true, default = Cfg.Watched[f.job] and f.job or nil },
					{ type = 'number', label = 'Modat (Rooz)', required = true, default = Cfg.Permits.DefaultDays, min = 1, max = Cfg.Permits.MaxDays },
				})
				if input then TriggerServerEvent(T .. 'issuePermit', f.id, input[1], input[2]) end
				Ov.OpenWorkerMenu(id, back)
			end }
		end
		if can('notes') then
			o[#o + 1] = { title = 'Yaddasht', icon = 'note-sticky', onSelect = function()
				local input = lib.inputDialog('Yaddasht -- ' .. clean(f.name), { { type = 'input', label = 'Matn', required = true, max = 200 } })
				if input then TriggerServerEvent(T .. 'note', f.id, input[1]) end
				Ov.OpenWorkerMenu(id, back)
			end }
		end

		-- 7-day stats + history
		for _, s in ipairs(f.stats7d or {}) do
			o[#o + 1] = {
				title = '7 Rooz -- ' .. ((Cfg.Watched[s.job] and Cfg.Watched[s.job].label) or s.job),
				description = 'Item: ' .. tostring(s.items or 0) .. ' | Daramad: ' .. money(s.income) .. ' | Saat: ' .. string.format('%.1f', (tonumber(s.seconds) or 0) / 3600),
				icon = 'chart-line', disabled = true,
			}
		end
		if #(f.offences or {}) > 0 then
			o[#o + 1] = { title = 'Sabeghe (' .. #f.offences .. ')', icon = 'clock-rotate-left', arrow = true, onSelect = function()
				local h = {}
				for _, off in ipairs(f.offences) do
					h[#h + 1] = {
						title = string.upper(off.kind) .. ': ' .. tostring(off.reason),
						description = 'Tavassot: ' .. tostring(off.by_name) .. (off.amount and (' | ' .. money(off.amount)) or ''),
						icon = 'file-lines', disabled = true,
					}
				end
				show('ov_history', 'Sabeghe -- ' .. clean(f.name), 'ov_worker', h)
			end }
		end

		show('ov_worker', 'Karegar', back or 'ov_main', o)
	end, id)
end

function Ov.Inspect(id)
	ESX.TriggerServerCallback(T .. 'inspect', function(f, err)
		if not f then ESX.ShowNotification('~r~' .. tostring(err or 'Khata')) return end
		local o = {}
		o[#o + 1] = { title = clean(f.name) .. ' [' .. f.id .. ']', description = f.jobLabel .. ' | ' .. tostring(f.grade or '-'), icon = 'id-card', disabled = true }
		if f.suspension then
			o[#o + 1] = { title = 'TARIGH-SHODE (' .. f.suspension.left .. ')', description = f.suspension.reason, icon = 'user-slash', iconColor = 'red', disabled = true }
		end
		for _, p in ipairs(f.permits or {}) do
			o[#o + 1] = { title = 'Mojavez ' .. p.label .. ': ' .. (p.has and 'Darad' or 'NADARAD'), icon = 'id-badge', iconColor = p.has and 'green' or 'red', disabled = true }
		end
		if #(f.items or {}) == 0 then
			o[#o + 1] = { title = 'Hich Item-e Marboot Be Shoghl Nadarad', icon = 'box-open', disabled = true }
		end
		for _, it in ipairs(f.items or {}) do
			o[#o + 1] = {
				title = it.count .. 'x ' .. tostring(it.label),
				description = it.suspicious and 'MASHKOOK -- Anbasht-e Bish Az Had' or nil,
				icon = it.suspicious and 'triangle-exclamation' or 'box', iconColor = it.suspicious and 'red' or nil, disabled = true,
			}
		end
		if #(f.offences or {}) > 0 then
			o[#o + 1] = { title = 'Sabeghe: ' .. #f.offences .. ' Mored (Akharin: ' .. string.upper(f.offences[1].kind) .. ')', icon = 'clock-rotate-left', disabled = true }
		end
		show('ov_inspect', 'Bazresi -- ' .. clean(f.name), 'ov_main', o)
	end, id)
end

-- ============================================================
-- Spectate menu (X while spectating): same idea as the FBI
-- "Ettela'at-e Hadaf" + "Ersal-e Payam" + "Tavaghof" entries
-- ============================================================
function Ov.OpenSpectateMenu()
	if not Ov.Spec.active then return end
	local info = Ov.Spec.info or {}
	local o = {}
	o[#o + 1] = {
		title = clean(info.name) .. ' [' .. tostring(Ov.Spec.target) .. ']',
		description = tostring(info.jobLabel) .. ' | ' .. (stateText[info.state] or '?') .. ' | Shift: ' .. tostring(info.shiftMin or 0) .. 'm | ' .. money(info.income),
		icon = 'eye', disabled = true,
	}
	if Cfg.Spectate.ShowFullInventory and info.cash then
		o[#o + 1] = { title = 'Cash: ' .. money(info.cash), icon = 'money-bill', disabled = true }
	end
	for _, it in ipairs(info.inventory or {}) do
		o[#o + 1] = { title = it.count .. 'x ' .. tostring(it.label), icon = 'box', disabled = true }
	end
	o[#o + 1] = { title = 'Amaliyat Bar Karegar', description = 'Akhtar, Jarime, Tarigh, Yaddasht, Payam', icon = 'gavel', arrow = true, onSelect = function()
		Ov.OpenWorkerMenu(Ov.Spec.target, 'ov_specmenu')
	end }
	o[#o + 1] = { title = 'Tavaghof-e Nezarat', icon = 'eye-slash', onSelect = function() Ov.StopSpectate(false) end }
	show('ov_specmenu', 'Nezarat', nil, o)
end

-- ============================================================
-- Dashboard
-- ============================================================
function Ov.OpenDashboard()
	ESX.TriggerServerCallback(T .. 'getDashboard', function(d)
		if not d then return end
		local o = {}

		o[#o + 1] = {
			title = 'Kholase',
			description = 'Hoshdar-e Baz: ' .. d.openFlags .. ' | Shekayat: ' .. d.openComplaints .. ' | Tarigh: ' .. d.activeSuspensions .. ' | Mojavez: ' .. d.activePermits,
			icon = 'gauge-high', disabled = true,
		}

		local byJob, maxIncome = {}, 1
		for _, r in ipairs(d.byJob or {}) do
			byJob[r.job] = r
			if (tonumber(r.income) or 0) > maxIncome then maxIncome = tonumber(r.income) end
		end
		for _, j in ipairs(d.jobs) do
			local r = byJob[j.job]
			local on = d.online[j.job]
			o[#o + 1] = {
				title = j.label .. ' -- ' .. (on and on.total or 0) .. ' Online (' .. (on and on.working or 0) .. ' Kar)',
				description = r and ('7 Rooz: ' .. money(r.income) .. ' | Item: ' .. tostring(r.items) .. ' | Karegar: ' .. tostring(r.workers) .. ' | Saat: ' .. string.format('%.1f', (tonumber(r.seconds) or 0) / 3600)) or 'Dade-i Nist',
				progress = r and math.floor((tonumber(r.income) or 0) / maxIncome * 100) or 0,
				colorScheme = 'green', icon = 'briefcase',
			}
		end

		local maxDay = 1
		for _, r in ipairs(d.byDay or {}) do if (tonumber(r.income) or 0) > maxDay then maxDay = tonumber(r.income) end end
		for _, r in ipairs(d.byDay or {}) do
			o[#o + 1] = { title = tostring(r.day), description = 'Daramad-e Koli: ' .. money(r.income), progress = math.floor((tonumber(r.income) or 0) / maxDay * 100), colorScheme = 'blue', icon = 'calendar-day' }
		end

		for i, r in ipairs(d.top or {}) do
			o[#o + 1] = { title = '#' .. i .. ' ' .. clean(r.name), description = ((Cfg.Watched[r.job] and Cfg.Watched[r.job].label) or tostring(r.job)) .. ' | ' .. money(r.income), icon = 'trophy', disabled = true }
		end

		show('ov_dash', 'Dashboard (7 Rooz)', 'ov_main', o)
	end)
end

-- ============================================================
-- Flags / complaints
-- ============================================================
function Ov.OpenFlags()
	ESX.TriggerServerCallback(T .. 'getFlags', function(rows)
		if not rows then return end
		local o = {}
		for _, f in ipairs(rows) do
			o[#o + 1] = {
				title = f.label .. ' -- ' .. clean(f.name),
				description = f.jobLabel .. ' | ' .. tostring(f.detail) .. ' | ' .. f.ago .. ' Pish',
				icon = 'triangle-exclamation', iconColor = 'orange', arrow = true,
				onSelect = function()
					local s = {}
					s[#s + 1] = { title = tostring(f.detail), icon = 'circle-info', disabled = true }
					if f.x and (f.x ~= 0 or f.y ~= 0) then
						s[#s + 1] = { title = 'GPS Be Makan', icon = 'location-dot', onSelect = function()
							SetNewWaypoint(f.x + 0.0, f.y + 0.0)
							ESX.ShowNotification('~g~GPS Set Shod')
						end }
					end
					s[#s + 1] = { title = 'Ta-eed (Confirm)', icon = 'check', onSelect = function() TriggerServerEvent(T .. 'resolveFlag', f.id, 'confirmed') Ov.OpenFlags() end }
					s[#s + 1] = { title = 'Rad (Dismiss)', icon = 'xmark', onSelect = function() TriggerServerEvent(T .. 'resolveFlag', f.id, 'dismissed') Ov.OpenFlags() end }
					if can('cases') then
						s[#s + 1] = { title = f.case_id and ('Parvande #' .. f.case_id) or 'Baz Kardan-e Parvande (/doj)', icon = 'folder-open', disabled = f.case_id ~= nil, onSelect = function()
							TriggerServerEvent(T .. 'flagToCase', f.id)
							Ov.OpenFlags()
						end }
					end
					show('ov_flag', f.label, 'ov_flags', s)
				end,
			}
		end
		if #o == 0 then o = empty('Hich Hoshdar-e Bazi Nist') end
		show('ov_flags', 'Hoshdar-ha', 'ov_main', o)
	end)
end

function Ov.OpenComplaints()
	ESX.TriggerServerCallback(T .. 'getComplaints', function(rows)
		if not rows then return end
		local o = {}
		for _, c in ipairs(rows) do
			o[#o + 1] = {
				title = clean(c.name) .. (c.target_name ~= '' and (' -> ' .. c.target_name) or ''),
				description = tostring(c.text), icon = 'inbox', arrow = true,
				metadata = { { label = 'Zaman', value = c.ago .. ' Pish' } },
				onSelect = function()
					local s = {}
					s[#s + 1] = { title = tostring(c.text), icon = 'quote-left', disabled = true }
					s[#s + 1] = { title = 'Bayegani (Resolve)', icon = 'check', onSelect = function()
						local input = lib.inputDialog('Bayegani', { { type = 'input', label = 'Yaddasht (Ekhtiari)', max = 200 } })
						TriggerServerEvent(T .. 'resolveComplaint', c.id, input and input[1] or '')
						Ov.OpenComplaints()
					end }
					if can('cases') then
						s[#s + 1] = { title = c.case_id and ('Parvande #' .. c.case_id) or 'Baz Kardan-e Parvande (/doj)', icon = 'folder-open', disabled = c.case_id ~= nil, onSelect = function()
							TriggerServerEvent(T .. 'complaintToCase', c.id)
							Ov.OpenComplaints()
						end }
					end
					show('ov_complaint', 'Shekayat', 'ov_complaints', s)
				end,
			}
		end
		if #o == 0 then o = empty('Hich Shekayat-e Bazi Nist') end
		show('ov_complaints', 'Shekayat-ha', 'ov_main', o)
	end)
end

-- ============================================================
-- Permits / suspensions
-- ============================================================
function Ov.OpenPermits()
	ESX.TriggerServerCallback(T .. 'getPermits', function(rows)
		if not rows then return end
		local o = {}
		for _, p in ipairs(rows) do
			o[#o + 1] = {
				title = clean(p.name) .. ' -- ' .. p.jobLabel,
				description = 'Sader-konande: ' .. tostring(p.issued_by) .. ' | ' .. p.left .. ' Baghi',
				icon = 'id-badge', arrow = can('permit_revoke'), disabled = not can('permit_revoke'),
				onSelect = function()
					local confirm = lib.alertDialog({ header = 'Laghv-e Mojavez', content = clean(p.name) .. ' -- ' .. p.jobLabel, centered = true, cancel = true })
					if confirm == 'confirm' then
						TriggerServerEvent(T .. 'revokePermit', p.identifier, p.job)
						Ov.OpenPermits()
					end
				end,
			}
		end
		if #o == 0 then o = empty('Hich Mojavez-e Faali Nist') end
		show('ov_permits', 'Mojavez-ha', 'ov_main', o)
	end)
end

function Ov.OpenSuspensions()
	ESX.TriggerServerCallback(T .. 'getSuspensions', function(rows)
		if not rows then return end
		local o = {}
		for _, s in ipairs(rows) do
			o[#o + 1] = {
				title = clean(s.name) .. ' -- ' .. (s.job == '*' and 'Hame-ye Shoghl-ha' or ((Cfg.Watched[s.job] and Cfg.Watched[s.job].label) or s.job)),
				description = tostring(s.reason) .. ' | ' .. s.left .. ' Baghi | Tavassot: ' .. tostring(s.by_name),
				icon = 'user-slash', arrow = can('lift'), disabled = not can('lift'),
				onSelect = function()
					local confirm = lib.alertDialog({ header = 'Laghv-e Tarigh', content = clean(s.name) .. ' -- ' .. tostring(s.reason), centered = true, cancel = true })
					if confirm == 'confirm' then
						TriggerServerEvent(T .. 'lift', s.id)
						Ov.OpenSuspensions()
					end
				end,
			}
		end
		if #o == 0 then o = empty('Hich Tarigh-e Faali Nist') end
		show('ov_susp', 'Tarigh-haye Faal', 'ov_main', o)
	end)
end

-- ============================================================
-- Economy / events / top workers / audit
-- ============================================================
function Ov.OpenEconomy()
	ESX.TriggerServerCallback(T .. 'getEconomy', function(e)
		if not e then return end
		local o = {}
		for _, j in ipairs(e.jobs) do
			local desc = 'Maliat: ' .. math.floor(j.tax * 100 + 0.5) .. '% | Gheymat: x' .. string.format('%.2f', j.mult)
			if j.bonusMult then desc = desc .. ' | EVENT x' .. string.format('%.2f', j.bonusMult) .. ' (' .. j.bonusLeft .. ')' end
			if j.closedLeft then desc = desc .. ' | BASTE (' .. j.closedLeft .. ')' end
			o[#o + 1] = {
				title = j.label, description = desc, icon = 'coins',
				arrow = can('economy'), disabled = not can('economy'),
				onSelect = function()
					local input = lib.inputDialog('Eghtesad -- ' .. j.label, {
						{ type = 'number', label = 'Maliat (%)', default = math.floor(j.tax * 100 + 0.5), min = 0, max = math.floor(e.maxTax * 100), required = true },
						{ type = 'number', label = 'Zarib-e Gheymat', default = j.mult, min = e.minMult, max = e.maxMult, step = 0.05, precision = 2, required = true },
					})
					if input then
						TriggerServerEvent(T .. 'setEconomy', j.job, input[1], input[2])
						Wait(400)
						Ov.OpenEconomy()
					end
				end,
			}
		end
		show('ov_economy', 'Eghtesad', 'ov_main', o)
	end)
end

function Ov.OpenEvents()
	ESX.TriggerServerCallback(T .. 'getEvents', function(list)
		if not list then return end
		local o = {}
		o[#o + 1] = { title = 'Pardakht-e Do Barabar (Bonus Hour)', icon = 'bolt', onSelect = function()
			local input = lib.inputDialog('Event -- Pardakht-e Bishtar', {
				{ type = 'select', label = 'Shoghl', options = jobOptions(true), required = true, default = '*' },
				{ type = 'number', label = 'Modat (Daghighe)', default = 30, min = 1, max = Cfg.Economy.MaxEventMinutes, required = true },
				{ type = 'number', label = 'Zarib', default = 2.0, min = 1.1, max = Cfg.Economy.MaxEventBonusMult, step = 0.1, precision = 1, required = true },
			})
			if input then
				TriggerServerEvent(T .. 'startEvent', 'bonus', input[1], input[2], input[3])
				Wait(400)
				Ov.OpenEvents()
			end
		end }
		o[#o + 1] = { title = 'Ta\'til-e Movaghat (Close Job)', icon = 'lock', onSelect = function()
			local input = lib.inputDialog('Event -- Ta\'til-e Shoghl', {
				{ type = 'select', label = 'Shoghl', options = jobOptions(true), required = true },
				{ type = 'number', label = 'Modat (Daghighe)', default = 15, min = 1, max = Cfg.Economy.MaxEventMinutes, required = true },
			})
			if input then
				TriggerServerEvent(T .. 'startEvent', 'closed', input[1], input[2])
				Wait(400)
				Ov.OpenEvents()
			end
		end }
		for _, ev in ipairs(list) do
			o[#o + 1] = {
				title = (ev.kind == 'bonus' and ('BONUS x' .. string.format('%.2f', ev.mult or 1)) or 'BASTE') .. ' -- ' .. ev.label,
				description = ev.left .. ' Baghi | Tavassot: ' .. tostring(ev.by) .. ' | Baraye Payan Bezanid',
				icon = ev.kind == 'bonus' and 'bolt' or 'lock', iconColor = ev.kind == 'bonus' and 'green' or 'red',
				onSelect = function()
					TriggerServerEvent(T .. 'stopEvent', ev.kind, ev.job)
					Wait(400)
					Ov.OpenEvents()
				end,
			}
		end
		show('ov_events', 'Event-ha', 'ov_main', o)
	end)
end

function Ov.OpenTopMenu()
	local o = {}
	for _, j in ipairs(Cfg.JobOrder) do
		o[#o + 1] = { title = Cfg.Watched[j].label, icon = 'trophy', arrow = true, onSelect = function()
			ESX.TriggerServerCallback(T .. 'getTop', function(rows)
				local s = {}
				for i, r in ipairs(rows or {}) do
					s[#s + 1] = {
						title = '#' .. i .. ' ' .. clean(r.name),
						description = 'Daramad: ' .. money(r.income) .. ' | Item: ' .. tostring(r.items) .. ' | Saat: ' .. string.format('%.1f', (tonumber(r.seconds) or 0) / 3600) .. (Cfg.Bonus[i] and (' | Bonus: ' .. money(Cfg.Bonus[i])) or ''),
						icon = 'medal', disabled = true,
					}
				end
				if #s == 0 then s = empty('Dade-i Baraye In Hafte Nist') else
					s[#s + 1] = { title = 'Pardakht-e Bonus Be Nafarat-e Bartar', description = 'Az Hesab-e DOJ -- Faghat Karegaran-e Online', icon = 'hand-holding-dollar', onSelect = function()
						local confirm = lib.alertDialog({ header = 'Pardakht-e Bonus', content = Cfg.Watched[j].label .. ': Bonus Be Nafarat-e Bartar-e Hafte Pardakht Shavad?', centered = true, cancel = true })
						if confirm == 'confirm' then TriggerServerEvent(T .. 'payBonus', j) end
					end }
				end
				show('ov_top', 'Bartarin-ha -- ' .. Cfg.Watched[j].label, 'ov_toplist', s)
			end, j)
		end }
	end
	show('ov_toplist', 'Karegar-e Bartar-e Hafte', 'ov_main', o)
end

function Ov.OpenAudit()
	ESX.TriggerServerCallback(T .. 'getAudit', function(rows)
		if not rows then return end
		local o = {}
		for _, r in ipairs(rows) do
			o[#o + 1] = {
				title = clean(r.spectator_name) .. ' -> ' .. clean(r.target_name),
				description = string.upper(tostring(r.spectator_job)) .. ' | ' .. r.ago .. ' Pish | Modat: ' .. r.duration .. (r.reason and (' | ' .. r.reason) or ''),
				icon = 'eye', disabled = true,
			}
		end
		if #o == 0 then o = empty('Hich Nezarati Sabt Nashode') end
		show('ov_audit', 'Log-e Nezarat', 'ov_main', o)
	end)
end
