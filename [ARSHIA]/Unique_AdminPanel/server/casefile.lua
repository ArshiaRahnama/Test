-- Unique_AdminPanel | server/casefile.lua
-- Five staff tools that tie the existing data together:
--   1. Case File      one timeline per player (notes, warnings, bans, jail, CS, flags,
--                     reports, impounds, transfers, admin actions, big money moves)
--   2. Global Search  name / identifier / phone / IBAN / plate / online id
--   3. Money Ledger   every money/bank change with the resource that caused it (+ revert)
--   4. Auto Evidence  chat lines, nearby players, context and a screenshot attached to a
--                     report the moment an admin accepts it
--   5. Report Macros  editable canned replies (some also close the report)
--
-- Every callback/event is gated on the SERVER (on-duty admin + minimum level); nothing here
-- trusts what the client says about who it is.

local function q(sql, params)
    local ok, res = pcall(MySQL.Sync.fetchAll, sql, params or {})
    if not ok then
        dprint('[casefile] query failed: ' .. tostring(res))
        return {}
    end
    return res or {}
end

local function exec(sql, params, cb)
    MySQL.Async.execute(sql, params or {}, cb)
end

local function cleanLike(s)
    return (tostring(s or ''):gsub('[%%_\\]', '\\%0'))
end

local function ts(v) return tonumber(v) or 0 end

-- ------------------------------------------------------------- SCHEMA -----
-- (also in sql/unique_adminmenu.sql; created here too so an upgrade needs no manual step)
CreateThread(function()
    Wait(2000)
    exec([[CREATE TABLE IF NOT EXISTS `admin_money_ledger` (
        `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
        `identifier` VARCHAR(60) NOT NULL,
        `account` VARCHAR(10) NOT NULL,
        `delta` BIGINT NOT NULL,
        `balance_after` BIGINT NOT NULL,
        `source` VARCHAR(80) NOT NULL DEFAULT 'unknown',
        `reverted` TINYINT(1) NOT NULL DEFAULT 0,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_ident_time` (`identifier`, `created_at`),
        INDEX `idx_time` (`created_at`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    exec([[CREATE TABLE IF NOT EXISTS `admin_report_evidence` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `report_id` INT NOT NULL,
        `kind` VARCHAR(20) NOT NULL,
        `data` MEDIUMTEXT NULL,
        `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_report` (`report_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    exec([[CREATE TABLE IF NOT EXISTS `admin_report_macros` (
        `id` INT AUTO_INCREMENT PRIMARY KEY,
        `mkey` VARCHAR(40) NOT NULL UNIQUE,
        `label` VARCHAR(60) NOT NULL,
        `text` VARCHAR(500) NOT NULL,
        `close_report` TINYINT(1) NOT NULL DEFAULT 0,
        `sort_order` INT NOT NULL DEFAULT 100,
        `created_by` VARCHAR(100) NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]], {}, function()
        -- seed defaults once
        local n = q('SELECT COUNT(*) AS c FROM `admin_report_macros`')[1]
        if n and tonumber(n.c) == 0 then
            local defaults = {
                { 'clip',       'درخواست کلیپ',      'لطفاً یک کلیپ یا اسکرین‌شات از اتفاق بفرست تا بررسی کنیم.', 0, 10 },
                { 'noevidence', 'مدرک کافی نیست',    'مدرک کافی برای رسیدگی وجود نداره. لطفاً کلیپ یا اسکرین‌شات واضح‌تری ارسال کن.', 0, 20 },
                { 'wait',       'کمی صبر کن',        'در حال بررسیم، چند دقیقه صبر کن.', 0, 30 },
                { 'escalate',   'ارجاع به بالاتر',   'این مورد رو به تیم ارشدتر ارجاع دادم، به‌زودی رسیدگی میشه.', 0, 40 },
                { 'discord',    'مراجعه به Discord', 'برای این موضوع لطفاً از طریق تیکت در Discord سرور پیگیری کن.', 1, 50 },
                { 'noissue',    'مشکلی پیدا نشد',    'بررسی شد، مشکل یا تخلفی پیدا نکردیم. اگه اتفاق جدیدی افتاد دوباره ریپورت بده.', 1, 60 },
                { 'resolved',   'مشکل حل شد',        'موضوع حل شد. اگه دوباره پیش اومد ریپورت بده. موفق باشی {player}!', 1, 70 },
            }
            for _, d in ipairs(defaults) do
                exec('INSERT IGNORE INTO `admin_report_macros` (`mkey`,`label`,`text`,`close_report`,`sort_order`,`created_by`) VALUES (@k,@l,@t,@c,@s,\'system\')',
                    { ['@k'] = d[1], ['@l'] = d[2], ['@t'] = d[3], ['@c'] = d[4], ['@s'] = d[5] })
            end
        end
    end)
end)

-- ------------------------------------------------------------ helpers ----

local function staff(source, minLevel)
    if not IsOnDutyAdmin(source) then return false end
    return AdminMinLevel(source, minLevel or 1)
end

local lastCall = {}
local function throttled(source, key, ms)
    local k = key .. ':' .. source
    local now = GetGameTimer()
    if lastCall[k] and now - lastCall[k] < ms then return true end
    lastCall[k] = now
    return false
end
AddEventHandler('playerDropped', function()
    for k in pairs(lastCall) do
        if k:match(':' .. source .. '$') then lastCall[k] = nil end
    end
end)

local function resolveIdentifier(v)
    -- accepts a server id (number) or an identifier string
    local n = tonumber(v)
    if n and n < 100000 then
        local x = ESX.GetPlayerFromId(n)
        return x and x.identifier or nil
    end
    v = tostring(v or '')
    if v ~= '' and #v <= 60 then return v end
    return nil
end

-- =========================================================================
-- 3. MONEY LEDGER
-- =========================================================================
-- essentialmode's addMoney/removeMoney/setMoney/addBank/removeBank/setBank fire the local
-- (non-network, so clients can't forge it) event below with the calling resource's name.

local queue, QUEUE_MAX = {}, 5000

AddEventHandler('Unique_AdminPanel:ledger', function(identifier, account, delta, after, caller)
    if type(identifier) ~= 'string' or type(delta) ~= 'number' then return end
    delta = math.floor(delta + 0.5)
    if delta == 0 then return end
    if #queue >= QUEUE_MAX then table.remove(queue, 1) end
    queue[#queue + 1] = { identifier, tostring(account), delta, math.floor((tonumber(after) or 0) + 0.5), tostring(caller or 'unknown'):sub(1, 80) }
end)

local function flushLedger()
    if #queue == 0 then return end
    local batch = {}
    for i = 1, math.min(#queue, 200) do batch[i] = table.remove(queue, 1) end
    local rows, params = {}, {}
    for _, r in ipairs(batch) do
        rows[#rows + 1] = '(?,?,?,?,?)'
        for j = 1, 5 do params[#params + 1] = r[j] end
    end
    exports.oxmysql:execute('INSERT INTO `admin_money_ledger` (`identifier`,`account`,`delta`,`balance_after`,`source`) VALUES ' .. table.concat(rows, ','), params)
end

CreateThread(function()
    while true do
        Wait(5000)
        flushLedger()
    end
end)
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then flushLedger() end
end)

-- retention: keep 45 days, delete in small batches
CreateThread(function()
    Wait(90 * 1000)
    while true do
        local n
        repeat
            n = MySQL.Sync.execute('DELETE FROM `admin_money_ledger` WHERE `created_at` < DATE_SUB(NOW(), INTERVAL 45 DAY) LIMIT 5000') or 0
            Wait(500)
        until n < 5000
        Wait(24 * 60 * 60 * 1000)
    end
end)

RegisterServerCallbackSafe('Unique_AdminPanel:GetLedger', function(source, cb, target, hours)
    if not staff(source, 2) or throttled(source, 'ledger', 800) then cb(nil) return end
    local identifier = resolveIdentifier(target)
    if not identifier then cb(nil) return end
    hours = math.min(math.max(tonumber(hours) or 24, 1), 24 * 45)
    flushLedger() -- include the last few seconds

    local rows = q([[SELECT id, account, delta, balance_after, source, reverted, UNIX_TIMESTAMP(created_at) AS t
        FROM admin_money_ledger WHERE identifier = @i AND created_at >= DATE_SUB(NOW(), INTERVAL @h HOUR)
        ORDER BY id DESC LIMIT 300]], { ['@i'] = identifier, ['@h'] = hours })
    local bySource = q([[SELECT source, SUM(delta) AS net, COUNT(*) AS n FROM admin_money_ledger
        WHERE identifier = @i AND created_at >= DATE_SUB(NOW(), INTERVAL @h HOUR) AND reverted = 0
        GROUP BY source ORDER BY ABS(SUM(delta)) DESC LIMIT 12]], { ['@i'] = identifier, ['@h'] = hours })
    local u = q('SELECT playerName FROM users WHERE identifier = @i', { ['@i'] = identifier })[1]
    cb({
        identifier = identifier, name = u and u.playerName or identifier, hours = hours,
        rows = rows, bySource = bySource, canRevert = staff(source, 6),
    })
end)

RegisterServerCallbackSafe('Unique_AdminPanel:GetLedgerTop', function(source, cb, hours)
    if not staff(source, 2) or throttled(source, 'ledgertop', 1500) then cb(nil) return end
    hours = math.min(math.max(tonumber(hours) or 24, 1), 24 * 14)
    flushLedger()
    local rows = q([[SELECT identifier, SUM(delta) AS net, COUNT(*) AS n, MAX(delta) AS biggest
        FROM admin_money_ledger WHERE created_at >= DATE_SUB(NOW(), INTERVAL @h HOUR)
        AND reverted = 0 AND source NOT LIKE 'Unique_AdminPanel%' AND source NOT LIKE 'admin%'
        GROUP BY identifier HAVING SUM(delta) > 0 ORDER BY net DESC LIMIT 20]], { ['@h'] = hours })
    for _, r in ipairs(rows) do
        local u = q('SELECT playerName FROM users WHERE identifier = @i', { ['@i'] = r.identifier })[1]
        r.name = u and u.playerName or r.identifier
        local top = q([[SELECT source, SUM(delta) AS net FROM admin_money_ledger WHERE identifier = @i
            AND created_at >= DATE_SUB(NOW(), INTERVAL @h HOUR) GROUP BY source ORDER BY SUM(delta) DESC LIMIT 1]],
            { ['@i'] = r.identifier, ['@h'] = hours })[1]
        r.topSource = top and top.source or '?'
    end
    cb({ hours = hours, rows = rows })
end)

RegisterServerEvent('Unique_AdminPanel:RevertLedger')
AddEventHandler('Unique_AdminPanel:RevertLedger', function(entryId)
    local src = source
    if not staff(src, 6) or throttled(src, 'revert', 1500) then return end
    entryId = tonumber(entryId)
    if not entryId then return end

    local e = q('SELECT * FROM admin_money_ledger WHERE id = @id', { ['@id'] = entryId })[1]
    if not e or e.reverted == 1 or e.reverted == true then
        TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~r~Entry not found or already reverted')
        return
    end
    if e.account ~= 'money' and e.account ~= 'bank' then
        TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~r~Only cash/bank entries can be reverted')
        return
    end

    -- claim it first so a double click can't revert twice
    local claimed = MySQL.Sync.execute('UPDATE admin_money_ledger SET reverted = 1 WHERE id = @id AND reverted = 0', { ['@id'] = entryId })
    if (claimed or 0) == 0 then return end

    local inverse = -tonumber(e.delta)
    local xTarget = ESX.GetPlayerFromIdentifier(e.identifier)
    local name
    if xTarget then
        name = GetPlayerName(xTarget.source)
        local cur = (e.account == 'money') and xTarget.money or xTarget.bank
        local new = math.max(0, cur + inverse) -- never push someone negative
        if e.account == 'money' then xTarget.setMoney(new) else xTarget.setBank(new) end
        TriggerClientEvent('esx:showNotification', xTarget.source, '~y~An admin corrected a money transaction on your account')
    else
        local col = (e.account == 'money') and 'money' or 'bank'
        MySQL.Sync.execute(('UPDATE users SET `%s` = GREATEST(0, `%s` + @d) WHERE identifier = @i'):format(col, col),
            { ['@d'] = inverse, ['@i'] = e.identifier })
        MySQL.Sync.execute('INSERT INTO admin_money_ledger (identifier, account, delta, balance_after, source, reverted) VALUES (@i,@a,@d,0,@s,1)',
            { ['@i'] = e.identifier, ['@a'] = e.account, ['@d'] = inverse, ['@s'] = 'admin_revert(offline)' })
        local u = q('SELECT playerName FROM users WHERE identifier = @i', { ['@i'] = e.identifier })[1]
        name = u and u.playerName
    end
    LogAdminAction(src, 'ledger_revert', ('entry #%s: %s %+d (%s, from %s)'):format(entryId, e.account, tonumber(e.delta), e.identifier, e.source), e.identifier, name)
    TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~g~Transaction reverted')
end)

-- =========================================================================
-- 1. CASE FILE
-- =========================================================================

local KIND_ORDER = { 'ban', 'jail', 'cs', 'warning', 'kick', 'report', 'flag', 'note', 'impound', 'transfer', 'money', 'admin' }

RegisterServerCallbackSafe('Unique_AdminPanel:GetCaseFile', function(source, cb, target)
    if not staff(source, 1) or throttled(source, 'case', 800) then cb(nil) return end
    local identifier = resolveIdentifier(target)
    if not identifier then cb(nil) return end
    local P = { ['@i'] = identifier }
    local ev = {}
    local function add(kind, t, title, by, detail, extra)
        local e = { kind = kind, t = ts(t), title = title, by = by or '', detail = detail or '' }
        if extra then for k, v in pairs(extra) do e[k] = v end end
        ev[#ev + 1] = e
    end

    -- header
    local user
    local ok, res = pcall(MySQL.Sync.fetchAll, 'SELECT identifier, playerName, phone, iban, job, job_grade, money, bank FROM users WHERE identifier = @i', P)
    if ok and res and res[1] then
        user = res[1]
    else
        user = q('SELECT identifier, playerName, job, job_grade, money, bank FROM users WHERE identifier = @i', P)[1]
    end
    if not user then cb(nil) return end
    local online = ESX.GetPlayerFromIdentifier(identifier)

    for _, r in ipairs(q('SELECT reason, admin_name, UNIX_TIMESTAMP(created_at) t FROM admin_warnings WHERE identifier=@i ORDER BY id DESC LIMIT 100', P)) do
        add('warning', r.t, 'Warning', r.admin_name, r.reason)
    end
    for _, r in ipairs(q('SELECT note, admin_name, UNIX_TIMESTAMP(created_at) t FROM admin_player_notes WHERE identifier=@i ORDER BY id DESC LIMIT 100', P)) do
        add('note', r.t, 'Note', r.admin_name, r.note)
    end
    for _, r in ipairs(q('SELECT note, admin_name, UNIX_TIMESTAMP(created_at) t FROM admin_player_flags WHERE identifier=@i', P)) do
        add('flag', r.t, (r.admin_name == 'SYSTEM') and 'Auto flag' or 'Flag', r.admin_name, r.note)
    end
    for _, r in ipairs(q('SELECT reason, admin_name, active, UNIX_TIMESTAMP(banned_at) t FROM unique_adminmenu_bans WHERE identifier=@i ORDER BY id DESC LIMIT 50', P)) do
        add('ban', r.t, 'Ban', r.admin_name, r.reason, { status = (r.active == 1 or r.active == true) and 'active' or 'expired' })
    end
    for _, r in ipairs(q('SELECT type, reason, duration, issued_by_name, UNIX_TIMESTAMP(created_at) t FROM punishment_history WHERE identifier=@i ORDER BY id DESC LIMIT 100', P)) do
        local kind = (r.type == 'community_service') and 'cs' or (r.type == 'jail' and 'jail') or (r.type == 'kick' and 'kick') or (r.type == 'ban' and 'ban') or 'jail'
        local label = ({ cs = 'Community service', jail = 'Jail', kick = 'Kick', ban = 'Ban' })[kind] or r.type
        add(kind, r.t, label .. (r.duration and (' - ' .. r.duration) or ''), r.issued_by_name, r.reason)
    end
    for _, r in ipairs(q('SELECT plate, model_label, impounded_by, reason, released, UNIX_TIMESTAMP(impounded_at) t FROM admin_impound_yard WHERE owner_identifier=@i ORDER BY id DESC LIMIT 50', P)) do
        add('impound', r.t, 'Impound ' .. tostring(r.plate), r.impounded_by, tostring(r.model_label or '') .. ' - ' .. tostring(r.reason or ''),
            { status = (r.released == 1 or r.released == true) and 'released' or 'impounded' })
    end
    for _, r in ipairs(q('SELECT source_identifier, dest_identifier, admin_name, UNIX_TIMESTAMP(created_at) t FROM admin_transfer_backups WHERE source_identifier=@i OR dest_identifier=@i ORDER BY id DESC LIMIT 20', P)) do
        add('transfer', r.t, 'Character transfer', r.admin_name, (r.source_identifier == identifier and 'Source: moved to ' .. tostring(r.dest_identifier)) or ('Destination: received from ' .. tostring(r.source_identifier)))
    end
    for _, r in ipairs(q('SELECT id, action, details, admin_name, UNIX_TIMESTAMP(created_at) t FROM admin_action_log WHERE target_identifier=@i ORDER BY id DESC LIMIT 150', P)) do
        add('admin', r.t, r.action, r.admin_name, r.details)
    end

    -- reports the player filed (+ which have evidence)
    local reports = q('SELECT ID, title, category, priority, status, admin_name, created_at FROM reports WHERE identifier=@i ORDER BY ID DESC LIMIT 50', P)
    local evSet = {}
    if #reports > 0 then
        local ids = {}
        for _, r in ipairs(reports) do ids[#ids + 1] = tonumber(r.ID) end
        for _, r in ipairs(q('SELECT DISTINCT report_id FROM admin_report_evidence WHERE report_id IN (' .. table.concat(ids, ',') .. ')')) do
            evSet[tonumber(r.report_id)] = true
        end
    end
    for _, r in ipairs(reports) do
        add('report', r.created_at, '#' .. r.ID .. ' ' .. tostring(r.title or ''), r.admin_name,
            ('%s / %s / %s'):format(tostring(r.category), tostring(r.priority), tostring(r.status)),
            { reportId = tonumber(r.ID), hasEvidence = evSet[tonumber(r.ID)] and true or false })
    end

    -- notable money movements only (the full history is in the ledger view)
    for _, r in ipairs(q([[SELECT account, delta, source, UNIX_TIMESTAMP(created_at) t FROM admin_money_ledger
        WHERE identifier=@i AND ABS(delta) >= 100000 AND reverted = 0 ORDER BY id DESC LIMIT 30]], P)) do
        add('money', r.t, ('%s %s%s'):format(r.account, r.delta > 0 and '+' or '', r.delta), r.source, 'Large transaction (>= 100,000)')
    end

    table.sort(ev, function(a, b) return a.t > b.t end)
    if #ev > 400 then for i = #ev, 401, -1 do ev[i] = nil end end

    local counts = {}
    for _, e in ipairs(ev) do counts[e.kind] = (counts[e.kind] or 0) + 1 end

    cb({
        identifier = identifier,
        name = user.playerName or identifier,
        online = online and online.source or nil,
        job = user.job and (tostring(user.job) .. ' (' .. tostring(user.job_grade or 0) .. ')') or nil,
        phone = user.phone, iban = user.iban,
        money = user.money, bank = user.bank,
        counts = counts, kinds = KIND_ORDER, events = ev,
        canLedger = staff(source, 2),
    })
end)

-- =========================================================================
-- 2. GLOBAL SEARCH
-- =========================================================================

RegisterServerCallbackSafe('Unique_AdminPanel:GlobalSearch', function(source, cb, query)
    if not staff(source, 2) or throttled(source, 'search', 400) then cb({ results = {}, error = 'no access' }) return end
    query = tostring(query or ''):gsub('^%s+', ''):gsub('%s+$', '')
    if #query < 2 or #query > 40 then cb({ results = {} }) return end

    local results = {}
    local like, prefix = '%' .. cleanLike(query) .. '%', cleanLike(query) .. '%'

    -- online players (by server id or name)
    for _, id in ipairs(ESX.GetPlayers()) do
        local name = GetPlayerName(id) or ''
        if tostring(id) == query or name:lower():find(query:lower(), 1, true) then
            local x = ESX.GetPlayerFromId(id)
            if x then results[#results + 1] = { kind = 'online', title = ('[%s] %s'):format(id, name), sub = 'Online now - ' .. tostring(x.job and x.job.name or ''), identifier = x.identifier } end
        end
        if #results >= 8 then break end
    end

    -- offline / all players
    local ok, rows = pcall(MySQL.Sync.fetchAll,
        'SELECT identifier, playerName, phone, iban, job FROM users WHERE playerName LIKE @c OR identifier LIKE @p OR phone LIKE @p OR iban = @e LIMIT 15',
        { ['@c'] = like, ['@p'] = prefix, ['@e'] = query })
    if not ok then
        rows = q('SELECT identifier, playerName, job FROM users WHERE playerName LIKE @c OR identifier LIKE @p LIMIT 15', { ['@c'] = like, ['@p'] = prefix })
    end
    for _, r in ipairs(rows or {}) do
        local bits = {}
        if r.phone and r.phone ~= '' then bits[#bits + 1] = 'phone ' .. r.phone end
        if r.iban and r.iban ~= '' then bits[#bits + 1] = 'IBAN ' .. r.iban end
        if r.job then bits[#bits + 1] = tostring(r.job) end
        results[#results + 1] = { kind = 'player', title = r.playerName or r.identifier, sub = table.concat(bits, ' | '), identifier = r.identifier }
    end

    -- vehicles by plate
    for _, r in ipairs(q([[SELECT ov.plate, ov.owner, u.playerName FROM owned_vehicles ov
        LEFT JOIN users u ON u.identifier = ov.owner WHERE ov.plate LIKE @c LIMIT 10]], { ['@c'] = like })) do
        results[#results + 1] = { kind = 'vehicle', title = 'Plate ' .. tostring(r.plate), sub = 'Owner: ' .. tostring(r.playerName or r.owner), identifier = r.owner }
    end

    -- bans
    for _, r in ipairs(q([[SELECT identifier, playername, reason, active FROM unique_adminmenu_bans
        WHERE playername LIKE @c OR identifier LIKE @p OR license LIKE @p ORDER BY id DESC LIMIT 5]], { ['@c'] = like, ['@p'] = prefix })) do
        results[#results + 1] = { kind = 'ban', title = 'Ban: ' .. tostring(r.playername or r.identifier), sub = tostring(r.reason or ''), identifier = r.identifier }
    end

    LogAdminAction(source, 'search', query:sub(1, 40)) -- searching phones / IBANs is audited
    cb({ results = results })
end)

-- =========================================================================
-- 4. AUTO EVIDENCE ON REPORT ACCEPT
-- =========================================================================

local function saveEvidence(reportId, kind, data)
    if data == nil then return end
    if type(data) ~= 'string' then data = json.encode(data) end
    exec('INSERT INTO `admin_report_evidence` (`report_id`,`kind`,`data`) VALUES (@r,@k,@d)', { ['@r'] = reportId, ['@k'] = kind, ['@d'] = data })
end

-- called from AcceptReport (report_main.lua) right after a successful accept
function CollectReportEvidence(rep, xUser, adminSrc)
    CreateThread(function()
        local reportId = tonumber(rep.ID)
        if not reportId then return end
        local saved = {}

        -- chat: the reporter's last 50 lines
        local chat = q('SELECT playername, message, UNIX_TIMESTAMP(created_at) AS t FROM admin_chat_archive WHERE identifier=@i ORDER BY id DESC LIMIT 50', { ['@i'] = rep.identifier })
        if #chat > 0 then
            local ordered = {}
            for i = #chat, 1, -1 do ordered[#ordered + 1] = chat[i] end
            saveEvidence(reportId, 'chat', ordered)
            saved[#saved + 1] = #chat .. ' chat lines'
        end

        if xUser then
            local ped = GetPlayerPed(xUser.source)
            local me = GetEntityCoords(ped)

            -- who was around them right now
            local nearby = {}
            for _, id in ipairs(ESX.GetPlayers()) do
                if id ~= xUser.source then
                    local d = #(me - GetEntityCoords(GetPlayerPed(id)))
                    if d <= 50.0 then
                        local x = ESX.GetPlayerFromId(id)
                        nearby[#nearby + 1] = { id = id, name = GetPlayerName(id), identifier = x and x.identifier, distance = math.floor(d * 10) / 10 }
                    end
                end
            end
            table.sort(nearby, function(a, b) return a.distance < b.distance end)
            saveEvidence(reportId, 'nearby', nearby)
            saved[#saved + 1] = #nearby .. ' nearby players'

            local veh = GetVehiclePedIsIn(ped, false)
            saveEvidence(reportId, 'context', {
                coords = { x = math.floor(me.x * 100) / 100, y = math.floor(me.y * 100) / 100, z = math.floor(me.z * 100) / 100 },
                job = xUser.job and xUser.job.name, health = GetEntityHealth(ped), armour = GetPedArmour(ped),
                plate = veh ~= 0 and GetVehicleNumberPlateText(veh) or nil, at = os.time(),
            })

            -- screenshot (needs screenshot-basic; silently skipped otherwise)
            if GetResourceState('screenshot-basic') == 'started' then
                pcall(function()
                    exports['screenshot-basic']:requestClientScreenshot(xUser.source, { encoding = 'jpg', quality = 0.5 }, function(err, data)
                        if not err and type(data) == 'string' and #data < 1500000 then
                            saveEvidence(reportId, 'screenshot', data)
                            if GetPlayerName(adminSrc) then
                                TriggerClientEvent('Unique_AdminPanel:MenuNotify', adminSrc, ('~b~Report #%s: screenshot saved'):format(reportId))
                            end
                        end
                    end)
                end)
                saved[#saved + 1] = 'screenshot requested'
            end
        end

        if #saved > 0 and GetPlayerName(adminSrc) then
            TriggerClientEvent('chat:addMessage', adminSrc, { args = { '^3[Evidence]', ('Report #%s: %s. Open it: F4 > Server Tools > Reports & Logs > Report Evidence'):format(reportId, table.concat(saved, ', ')) } })
        end
    end)
end

RegisterServerCallbackSafe('Unique_AdminPanel:GetReportEvidence', function(source, cb, reportId)
    if not staff(source, 1) or throttled(source, 'evidence', 800) then cb(nil) return end
    reportId = tonumber(reportId)
    if not reportId then cb(nil) return end
    local out = { reportId = reportId }
    for _, r in ipairs(q('SELECT kind, data, UNIX_TIMESTAMP(created_at) t FROM admin_report_evidence WHERE report_id=@r ORDER BY id', { ['@r'] = reportId })) do
        if r.kind == 'screenshot' then
            out.screenshot = r.data
        else
            local ok, decoded = pcall(json.decode, r.data or 'null')
            out[r.kind] = ok and decoded or nil
        end
        out.savedAt = out.savedAt or r.t
    end
    local rep = q('SELECT title, category, status, admin_name FROM reports WHERE ID=@r', { ['@r'] = reportId })[1]
    out.report = rep
    cb(out)
end)

CreateThread(function() -- evidence retention: 30 days
    Wait(120 * 1000)
    while true do
        MySQL.Sync.execute('DELETE FROM admin_report_evidence WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY)')
        Wait(24 * 60 * 60 * 1000)
    end
end)

-- =========================================================================
-- 5. REPORT MACROS
-- =========================================================================

function GetReportMacros()
    return q('SELECT mkey AS `key`, label, text, close_report AS close FROM admin_report_macros ORDER BY sort_order, id')
end

function ExpandMacroText(text, rep, adminName, playerName)
    return (tostring(text):gsub('{(%w+)}', function(k)
        if k == 'admin' then return adminName or 'admin'
        elseif k == 'player' then return playerName or 'player'
        elseif k == 'id' then return tostring(rep and rep.ID or '')
        elseif k == 'server' then return tostring(Config_Shared and Config_Shared.ServerName or 'server') end
        return '{' .. k .. '}'
    end))
end

RegisterServerCallbackSafe('Unique_AdminPanel:ListMacros', function(source, cb)
    if not staff(source, 5) then cb({}) return end
    cb(GetReportMacros())
end)

RegisterServerEvent('Unique_AdminPanel:AddMacro')
AddEventHandler('Unique_AdminPanel:AddMacro', function(label, text, closeIt)
    local src = source
    if not staff(src, 5) or throttled(src, 'macro', 1000) then return end
    label, text = tostring(label or ''):sub(1, 60), tostring(text or ''):sub(1, 500)
    if #label < 2 or #text < 2 then return end
    local key = ('m%d%d'):format(os.time() % 100000, math.random(10, 99))
    exec('INSERT INTO `admin_report_macros` (`mkey`,`label`,`text`,`close_report`,`sort_order`,`created_by`) VALUES (@k,@l,@t,@c,200,@b)',
        { ['@k'] = key, ['@l'] = label, ['@t'] = text, ['@c'] = closeIt and 1 or 0, ['@b'] = GetPlayerName(src) })
    LogAdminAction(src, 'macro_add', label)
    TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~g~Macro added (variables: {admin} {player} {id} {server})')
end)

RegisterServerEvent('Unique_AdminPanel:DeleteMacro')
AddEventHandler('Unique_AdminPanel:DeleteMacro', function(key)
    local src = source
    if not staff(src, 5) or throttled(src, 'macro', 1000) then return end
    exec('DELETE FROM `admin_report_macros` WHERE `mkey` = @k', { ['@k'] = tostring(key or '') })
    LogAdminAction(src, 'macro_delete', tostring(key))
    TriggerClientEvent('Unique_AdminPanel:MenuNotify', src, '~y~Macro deleted')
end)
