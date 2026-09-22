-- ============================================================
--  Society Pay  -  server
--  ESX (global) az server/main.lua-ye esx_society miad
-- ============================================================
local C = Config.Pay
local L = C.Locale
local group = Pay.group
local TABLE = 'society_payments'

-- ============================================================
--  Helpers
-- ============================================================
local busy, lastUse = {}, {}

local function getPlayer(src)
    return ESX and ESX.GetPlayerFromId(src) or nil
end

local function notify(src, ntype, title, description)
    TriggerClientEvent('ox_lib:notify', src, {
        type = ntype, title = title, description = description, duration = C.NotifyDuration,
    })
end

local function playerName(xPlayer, src)
    local ok, name = pcall(function() return xPlayer.getName() end)
    if ok and type(name) == 'string' and name ~= '' then return name end
    return GetPlayerName(src) or 'unknown'
end

local function getBank(xPlayer)
    local acc = xPlayer.getAccount('bank')
    return acc and tonumber(acc.money) or 0
end

local function getCoin(xPlayer)
    return tonumber(MySQL.scalar.await('SELECT coin FROM users WHERE identifier = ?', { xPlayer.identifier })) or 0
end

local function cleanNote(r)
    r = tostring(r or '')
    r = r:gsub('%c', ' '):gsub('`', "'"):gsub('%s+', ' ')
    r = r:match('^%s*(.-)%s*$')
    if #r > C.NoteMaxLength then r = r:sub(1, C.NoteMaxLength) end
    return r
end

local function onlineByJob()
    local counts = {}
    for _, id in ipairs(ESX.GetPlayers()) do
        local xp = ESX.GetPlayerFromId(id)
        local job = xp and xp.job and xp.job.name
        if job then counts[job] = (counts[job] or 0) + 1 end
    end
    return counts
end

local function discord(src, title, desc)
    TriggerEvent('DiscordBot:ToDiscord', C.DiscordCategory, title, '```css\n' .. desc .. '\n```', 'user', true, src, false)
end

local function logoOf(org)
    return org and org.logo and C.LogoPath:format(org.logo) or nil
end

-- masraf-e 24 saat-e akhar-e yek bazikon az yek noe
local function usedToday(identifier, payType)
    return tonumber(MySQL.scalar.await(
        'SELECT COALESCE(SUM(amount), 0) FROM ' .. TABLE .. ' WHERE identifier = ? AND pay_type = ? AND created_at >= (NOW() - INTERVAL 1 DAY)',
        { identifier, payType })) or 0
end

local function remainingToday(identifier, payType)
    local limit = C.DailyLimit and C.DailyLimit[payType]
    if not limit then return nil end
    return math.max(0, limit - usedToday(identifier, payType))
end

-- ============================================================
--  Database (jadval + migration)
-- ============================================================
local function tableExists(name)
    return (tonumber(MySQL.scalar.await(
        'SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', { name })) or 0) > 0
end

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `society_payments` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(64) NOT NULL,
            `name` VARCHAR(100) NULL,
            `department` VARCHAR(32) NOT NULL,
            `org` VARCHAR(32) NOT NULL,
            `pay_type` VARCHAR(16) NOT NULL,
            `amount` BIGINT NOT NULL,
            `purpose` VARCHAR(32) NOT NULL,
            `note` VARCHAR(255) NULL,
            `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_identifier` (`identifier`, `pay_type`, `created_at`),
            KEY `idx_org_created` (`org`, `created_at`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])

    -- agar ghablan resource-e joda-ye unique_pay estefade karde bodi, data-hat montaghel mishe
    if tableExists('unique_pay_logs') and (tonumber(MySQL.scalar.await('SELECT COUNT(*) FROM ' .. TABLE)) or 0) == 0 then
        pcall(MySQL.query.await, [[
            INSERT INTO society_payments (id, identifier, name, department, org, pay_type, amount, purpose, note, created_at)
            SELECT id, identifier, name, department, org, pay_type, amount, purpose, note, created_at
            FROM unique_pay_logs
        ]])
    end
end)

-- ============================================================
--  Deduction handlers (each returns ok, errKey)
-- ============================================================
local Handlers = {}

Handlers.bank = function(src, xPlayer, dept, amount)
    local account = nil
    TriggerEvent('esx_addonaccount:getSharedAccount', dept.account, function(acc) account = acc end)
    if not account then
        print(('^1[esx_society:pay]^0 society account "%s" was not found, payment cancelled'):format(dept.account))
        return false, 'generic'
    end
    if getBank(xPlayer) < amount then return false, 'funds' end
    xPlayer.removeAccountMoney('bank', amount)
    account.addMoney(amount)
    return true
end

Handlers.coin = function(src, xPlayer, dept, amount)
    -- atomic: only succeeds if the player really has enough coin
    local affected = MySQL.update.await('UPDATE users SET coin = coin - ? WHERE identifier = ? AND coin >= ?', {
        amount, xPlayer.identifier, amount,
    })
    if not affected or affected < 1 then return false, 'funds' end
    TriggerEvent('Coin-System:LoadCoin2', src) -- refresh HUD
    return true
end

-- ============================================================
--  /pay : data-ye wizard
-- ============================================================
lib.callback.register('esx_society:pay:open', function(src)
    local xPlayer = getPlayer(src)
    if not xPlayer then return nil end

    local balances = { bank = getBank(xPlayer), coin = getCoin(xPlayer) }
    local remaining = { bank = remainingToday(xPlayer.identifier, 'bank'), coin = remainingToday(xPlayer.identifier, 'coin') }
    local online = onlineByJob()
    local departments = {}

    for _, dept in ipairs(C.Departments) do
        local d = { id = dept.id, label = dept.label, emoji = dept.emoji, color = dept.color, online = 0, orgs = {}, types = {} }

        for _, org in ipairs(dept.orgs) do
            local n = online[org.job] or 0
            d.online = d.online + n
            d.orgs[#d.orgs + 1] = { job = org.job, label = org.label, online = n, logo = logoOf(org) }
        end

        for _, key in ipairs(dept.types) do
            local t = Pay.getType(dept, key)
            d.types[#d.types + 1] = {
                key = key, label = t.label, min = t.min, max = t.max, quick = t.quick,
                balance = balances[key] or 0, remaining = remaining[key],
            }
        end
        departments[#departments + 1] = d
    end

    local purposes = {}
    for _, p in ipairs(C.Purposes) do
        purposes[#purposes + 1] = { key = p.key, label = p.label, needsNote = p.needsNote == true }
    end

    -- akharin pardakht-e in bazikon (baraye "pardakht-e sari")
    local last = nil
    local lr = MySQL.query.await('SELECT department, org, purpose FROM ' .. TABLE .. ' WHERE identifier = ? ORDER BY id DESC LIMIT 1', { xPlayer.identifier })
    lr = lr and lr[1]
    if lr then
        local dept = Pay.getDept(lr.department)
        if dept and Pay.getOrg(dept, lr.org) then last = { dept = lr.department, org = lr.org, purpose = lr.purpose } end
    end

    return { departments = departments, purposes = purposes, noteMax = C.NoteMaxLength, last = last }
end)

-- ============================================================
--  Payment
-- ============================================================
local function notifyOrg(name, org, t, amount, purpose)
    for _, id in ipairs(ESX.GetPlayers()) do
        local xp = ESX.GetPlayerFromId(id)
        if xp and xp.job and xp.job.name == org.job then
            notify(id, 'inform', L.org_notify_title, L.org_notify_desc:format(name, group(amount), t.label, purpose.label))
        end
    end
end

local function processPayment(src, deptId, orgJob, typeKey, amount, purposeKey, note)
    local xPlayer = getPlayer(src)
    if not xPlayer then return { ok = false, error = L.err_generic } end

    local dept    = type(deptId) == 'string' and Pay.getDept(deptId)
    local org     = dept and type(orgJob) == 'string' and Pay.getOrg(dept, orgJob)
    local t       = dept and type(typeKey) == 'string' and Pay.getType(dept, typeKey)
    local purpose = type(purposeKey) == 'string' and Pay.getPurpose(purposeKey)
    if not (dept and org and t and purpose) then return { ok = false, error = L.err_generic } end

    amount = math.tointeger(tonumber(amount))
    if not amount or amount <= 0 then return { ok = false, error = L.err_invalid } end
    if amount < t.min then return { ok = false, error = L.err_min:format(group(t.min)) } end
    if amount > t.max then return { ok = false, error = L.err_max:format(group(t.max)) } end

    note = cleanNote(note)
    if purpose.needsNote and note == '' then return { ok = false, error = L.err_note } end

    local left = remainingToday(xPlayer.identifier, t.key)
    if left and amount > left then return { ok = false, error = L.err_daily:format(group(left)) } end

    local ok, err = Handlers[t.key](src, xPlayer, dept, amount)
    if not ok then return { ok = false, error = L['err_' .. (err or 'generic')] or L.err_generic } end

    local name = playerName(xPlayer, src)
    local okDb, receipt = pcall(MySQL.insert.await,
        'INSERT INTO ' .. TABLE .. ' (identifier, name, department, org, pay_type, amount, purpose, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        { xPlayer.identifier, name, dept.id, org.job, t.key, amount, purpose.key, note })
    if not okDb then receipt = nil end

    print(('^2[esx_society:pay]^0 %s (%s) paid %s %s to %s/%s | %s %s'):format(
        name, xPlayer.identifier, group(amount), t.key, dept.id, org.job, purpose.key, note))
    discord(src, 'Society Pay', ('[ Player : %s ]\n[ Identifier : %s ]\n[ ID : %s ]\n[ Department : %s ]\n[ Organ : %s ]\n[ Type : %s ]\n[ Amount : %s ]\n[ Purpose : %s ]\n[ Note : %s ]\n[ Receipt : %s ]'):format(
        name, xPlayer.identifier, src, dept.label, org.label, t.label, group(amount), purpose.key,
        note ~= '' and note or '-', receipt and ('#' .. receipt) or '-'))

    if C.NotifyOrg then notifyOrg(name, org, t, amount, purpose) end

    return {
        ok = true, receipt = receipt, amount = amount,
        orgLabel = org.label, deptLabel = dept.label, color = dept.color, logo = logoOf(org),
        typeKey = t.key, typeLabel = t.label, purposeLabel = purpose.label,
        balance = t.key == 'bank' and getBank(xPlayer) or getCoin(xPlayer),
        remaining = remainingToday(xPlayer.identifier, t.key),
    }
end

lib.callback.register('esx_society:pay:pay', function(src, deptId, orgJob, typeKey, amount, purposeKey, note)
    if busy[src] then return { ok = false, error = L.err_cooldown } end

    local now = GetGameTimer()
    if lastUse[src] and (now - lastUse[src]) < C.Cooldown then
        return { ok = false, error = L.err_cooldown }
    end

    busy[src] = true
    local ok, res = pcall(processPayment, src, deptId, orgJob, typeKey, amount, purposeKey, note)
    busy[src] = nil
    lastUse[src] = GetGameTimer()

    if not ok then
        print(('^1[esx_society:pay]^0 error: %s'):format(tostring(res)))
        return { ok = false, error = L.err_generic }
    end
    return res
end)

AddEventHandler('playerDropped', function()
    local src = source
    busy[src], lastUse[src] = nil, nil
end)

-- ============================================================
--  Row helpers (boss panel + /paylog)
-- ============================================================
local SELECT_ROWS = [[
    SELECT id, name, department, org, pay_type, amount, purpose, note,
           DATE_FORMAT(created_at, '%Y-%m-%d %H:%i') AS created
    FROM society_payments
]]

local function decorate(r)
    local dept, org = Pay.findOrg(r.org)
    local purpose = Pay.getPurpose(r.purpose)
    local tcfg = C.Types[r.pay_type]
    return {
        id = r.id, name = r.name or '-', org = r.org,
        orgLabel = org and org.label or r.org, logo = logoOf(org),
        color = dept and dept.color or '#3b6fe0',
        deptLabel = dept and dept.label or r.department,
        payType = r.pay_type, typeLabel = tcfg and tcfg.label or r.pay_type,
        amount = tonumber(r.amount) or 0,
        purposeLabel = purpose and purpose.label or r.purpose,
        note = r.note or '', created = r.created,
    }
end

local function escapeLike(s)
    return (tostring(s):gsub('([%%_\\])', '\\%1'))
end

local function toPage(v)
    v = math.tointeger(tonumber(v)) or 1
    return v < 1 and 1 or v
end

-- ============================================================
--  Boss Action panel (faghat Boss-e ordan-haye DOJ / LAW)
-- ============================================================
local function bossContext(src)
    local xPlayer = getPlayer(src)
    if not xPlayer or not xPlayer.job then return nil, L.err_generic end
    local dept, org = Pay.findOrg(xPlayer.job.name)
    if not org then return nil, L.err_not_gov end
    if not Pay.isBossGrade(xPlayer.job.grade_name) then return nil, L.err_not_boss end
    return xPlayer, dept, org
end

local function orgInfo(dept, org)
    return { job = org.job, label = org.label, deptLabel = dept.label, color = dept.color, logo = logoOf(org) }
end

-- tedad-e vaariz-haye emrooz (baraye nashan dadan roye dokme-ye boss menu)
lib.callback.register('esx_society:pay:todayCount', function(src)
    local xPlayer, dept, org = bossContext(src)
    if not xPlayer then return 0 end
    return tonumber(MySQL.scalar.await('SELECT COUNT(*) FROM ' .. TABLE .. ' WHERE org = ? AND created_at >= CURDATE()', { org.job })) or 0
end)

lib.callback.register('esx_society:pay:bossList', function(src, f)
    local xPlayer, dept, org = bossContext(src)
    if not xPlayer then return { ok = false, error = dept } end
    f = type(f) == 'table' and f or {}

    local ptype = (f.type == 'bank' or f.type == 'coin') and f.type or 'all'
    local search = cleanNote(f.search or ''):sub(1, 50)
    local page = toPage(f.page)
    local size = C.PageSize

    local where, params = { 'org = ?' }, { org.job }
    if ptype ~= 'all' then where[#where + 1] = 'pay_type = ?'; params[#params + 1] = ptype end
    if search ~= '' then
        local like = '%' .. escapeLike(search) .. '%'
        local idNum = math.tointeger(tonumber((search:gsub('^#', ''))))
        if idNum then
            where[#where + 1] = '(name LIKE ? OR note LIKE ? OR id = ?)'
            params[#params + 1] = like; params[#params + 1] = like; params[#params + 1] = idNum
        else
            where[#where + 1] = '(name LIKE ? OR note LIKE ?)'
            params[#params + 1] = like; params[#params + 1] = like
        end
    end
    local whereSql = ' WHERE ' .. table.concat(where, ' AND ')

    local total = tonumber(MySQL.scalar.await('SELECT COUNT(*) FROM ' .. TABLE .. whereSql, params)) or 0
    local pages = math.max(1, math.ceil(total / size))
    if page > pages then page = pages end

    local qParams = { table.unpack(params) }
    qParams[#qParams + 1] = size
    qParams[#qParams + 1] = (page - 1) * size
    local rows = MySQL.query.await(SELECT_ROWS .. whereSql .. ' ORDER BY id DESC LIMIT ? OFFSET ?', qParams) or {}

    local out = {}
    for i, r in ipairs(rows) do out[i] = decorate(r) end

    local s = (MySQL.query.await([[
        SELECT COUNT(*) AS total,
               COALESCE(SUM(CASE WHEN pay_type = 'bank' THEN amount ELSE 0 END), 0) AS total_bank,
               COALESCE(SUM(CASE WHEN pay_type = 'coin' THEN amount ELSE 0 END), 0) AS total_coin,
               COALESCE(SUM(CASE WHEN created_at >= CURDATE() THEN 1 ELSE 0 END), 0) AS today_count,
               COALESCE(SUM(CASE WHEN created_at >= CURDATE() AND pay_type = 'bank' THEN amount ELSE 0 END), 0) AS today_bank
        FROM society_payments WHERE org = ?
    ]], { org.job }) or {})[1] or {}

    return {
        ok = true, org = orgInfo(dept, org), rows = out, total = total, page = page, pages = pages,
        stats = {
            total = tonumber(s.total) or 0, totalBank = tonumber(s.total_bank) or 0, totalCoin = tonumber(s.total_coin) or 0,
            todayCount = tonumber(s.today_count) or 0, todayBank = tonumber(s.today_bank) or 0,
        },
    }
end)

-- gozaresh: nemoodar-e rooz-be-rooz, babat-ha, bartarin pardakht-konandeha
lib.callback.register('esx_society:pay:bossReport', function(src, days)
    local xPlayer, dept, org = bossContext(src)
    if not xPlayer then return { ok = false, error = dept } end

    days = math.tointeger(tonumber(days)) or C.ReportDays[1]
    local okDays = false
    for _, d in ipairs(C.ReportDays) do if d == days then okDays = true break end end
    if not okDays then days = C.ReportDays[1] end

    local back = days - 1
    local since = 'created_at >= (CURDATE() - INTERVAL ? DAY)'

    local today = MySQL.scalar.await("SELECT DATE_FORMAT(CURDATE(), '%Y-%m-%d')")
    local y, m, d = tostring(today):match('^(%d+)-(%d+)-(%d+)$')
    if not y then return { ok = false, error = L.err_generic } end
    local base = os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12 })

    local byDay = {}
    for _, r in ipairs(MySQL.query.await(
        "SELECT DATE_FORMAT(created_at, '%Y-%m-%d') AS d, pay_type, COUNT(*) AS n, COALESCE(SUM(amount), 0) AS total FROM " .. TABLE ..
        ' WHERE org = ? AND ' .. since .. ' GROUP BY d, pay_type', { org.job, back }) or {}) do
        byDay[r.d] = byDay[r.d] or {}
        byDay[r.d][r.pay_type] = { n = tonumber(r.n) or 0, total = tonumber(r.total) or 0 }
    end

    local series, totals = {}, { bank = 0, coin = 0, count = 0, today = { bank = 0, coin = 0, count = 0 } }
    for i = back, 0, -1 do
        local ds = os.date('%Y-%m-%d', base - i * 86400)
        local e = byDay[ds] or {}
        local bank, coin = (e.bank and e.bank.total) or 0, (e.coin and e.coin.total) or 0
        local n = ((e.bank and e.bank.n) or 0) + ((e.coin and e.coin.n) or 0)
        series[#series + 1] = { date = ds, bank = bank, coin = coin, count = n }
        totals.bank = totals.bank + bank; totals.coin = totals.coin + coin; totals.count = totals.count + n
        if i == 0 then totals.today = { bank = bank, coin = coin, count = n } end
    end

    local purposes = {}
    for _, r in ipairs(MySQL.query.await(
        "SELECT purpose, COUNT(*) AS n, COALESCE(SUM(CASE WHEN pay_type = 'bank' THEN amount ELSE 0 END), 0) AS bank, COALESCE(SUM(CASE WHEN pay_type = 'coin' THEN amount ELSE 0 END), 0) AS coin FROM " .. TABLE ..
        ' WHERE org = ? AND ' .. since .. ' GROUP BY purpose ORDER BY n DESC', { org.job, back }) or {}) do
        local p = Pay.getPurpose(r.purpose)
        purposes[#purposes + 1] = { label = p and p.label or r.purpose, count = tonumber(r.n) or 0, bank = tonumber(r.bank) or 0, coin = tonumber(r.coin) or 0 }
    end

    local top = {}
    for _, r in ipairs(MySQL.query.await(
        "SELECT MAX(name) AS name, COUNT(*) AS n, COALESCE(SUM(CASE WHEN pay_type = 'bank' THEN amount ELSE 0 END), 0) AS bank, COALESCE(SUM(CASE WHEN pay_type = 'coin' THEN amount ELSE 0 END), 0) AS coin FROM " .. TABLE ..
        ' WHERE org = ? AND ' .. since .. ' GROUP BY identifier ORDER BY bank DESC, coin DESC LIMIT 5', { org.job, back }) or {}) do
        top[#top + 1] = { name = r.name or '-', count = tonumber(r.n) or 0, bank = tonumber(r.bank) or 0, coin = tonumber(r.coin) or 0 }
    end

    return { ok = true, org = orgInfo(dept, org), days = days, ranges = C.ReportDays, series = series, totals = totals, purposes = purposes, top = top }
end)

-- ============================================================
--  /paylog : pardakht-haye khodam
-- ============================================================
lib.callback.register('esx_society:pay:myList', function(src, page)
    local xPlayer = getPlayer(src)
    if not xPlayer then return { ok = false, error = L.err_generic } end
    page = toPage(page)
    local size = C.PageSize

    local total = tonumber(MySQL.scalar.await('SELECT COUNT(*) FROM ' .. TABLE .. ' WHERE identifier = ?', { xPlayer.identifier })) or 0
    local pages = math.max(1, math.ceil(total / size))
    if page > pages then page = pages end

    local rows = MySQL.query.await(SELECT_ROWS .. ' WHERE identifier = ? ORDER BY id DESC LIMIT ? OFFSET ?',
        { xPlayer.identifier, size, (page - 1) * size }) or {}
    local out = {}
    for i, r in ipairs(rows) do out[i] = decorate(r) end

    return { ok = true, rows = out, total = total, page = page, pages = pages }
end)
