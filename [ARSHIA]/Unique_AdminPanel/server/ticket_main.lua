--[[ ===========================================================================
    Unique RP - Ticket System | server/ticket_main.lua
    arshiahub.ir

    Self-contained: doesn't touch report_main.lua/admin_tools.lua at all.
    Talks to the report system only through the read-only exports it already
    publishes (exports.Unique_AdminPanel:GetReports()), same as
    server/admin_tools.lua's GetServerStats already does - so this file can
    be added/removed without risking the load-order bugs documented at the
    top of esm_callback_bridge.lua and fxmanifest.lua.

    All server callbacks go through RegisterServerCallbackSafe (see
    server/esm_callback_bridge.lua) - plain ESX.RegisterServerCallback would
    silently no-op on this server (no es_extended, essentialmode is the
    core), exactly like every other file in this resource.
=========================================================================== ]]

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local function now() return os.time() end

local function getIdentifier(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then return xPlayer.identifier end
    -- fallback: first license identifier, same shape essentialmode uses
    for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
        if id:find('license:') then return id end
    end
    return nil
end

local function getName(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.getName then
        local ok, n = pcall(function() return xPlayer.getName() end)
        if ok and n and n ~= '' then return n end
    end
    return GetPlayerName(src) or ('id:' .. tostring(src))
end

--- permission_level >= Ticket_Config.MinPermissionLevel AND currently on duty
--- (xPlayer.get('aduty')) - identical rule to server/main.lua's IsOnDutyAdmin,
--- kept as its own copy so this file has zero load-order dependency on
--- server/main.lua running first.
local function isTicketAdmin(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end
    if (xPlayer.permission_level or 0) < Ticket_Config.MinPermissionLevel then return false end
    return xPlayer.get('aduty') and true or false
end

local function toast(src, variant, title, lines)
    TriggerClientEvent('vdm:cl:toast', src, { variant = variant, title = title, lines = lines or {}, duration = 7000 })
end

local function clean(str, maxLen)
    if type(str) ~= 'string' then return nil end
    str = str:gsub('^%s+', ''):gsub('%s+$', '')
    if str == '' then return nil end
    if #str > maxLen then str = str:sub(1, maxLen) end
    return str
end

local function pushDiscord(embed)
    local hook = GetConvar(Ticket_Config.DiscordWebhookConvar, '')
    if hook == '' then return end
    PerformHttpRequest(hook, function() end, 'POST', json.encode({ embeds = { embed } }),
        { ['Content-Type'] = 'application/json' })
end

local function logSystemMessage(ticketId, text)
    MySQL.Async.execute(
        'INSERT INTO `ticket_messages` (`ticket_id`,`identifier`,`name`,`is_admin`,`is_system`,`message`,`created_at`) VALUES (@t,@i,@n,1,1,@m,@c)',
        { ['@t'] = ticketId, ['@i'] = nil, ['@n'] = 'System', ['@m'] = text, ['@c'] = now() })
end

--- Notify every currently on-duty admin (used for "new ticket" / "new message
--- from a player" pings) - mirrors Rep.NotifyAllAdmins's intent in
--- server/report_main.lua without importing that file.
local function notifyAllAdmins(variant, title, lines)
    for _, src in ipairs(ESX.GetPlayers()) do
        if isTicketAdmin(src) then
            toast(src, variant, title, lines)
        end
    end
end

-- =========================================================== helpers/DB ===

local function ticketSummaryRow(row)
    return {
        id        = row.id,
        title     = row.title,
        category  = row.category,
        priority  = tonumber(row.priority) or 1,
        status    = row.status,
        creator   = { identifier = row.creator_identifier, name = row.creator_name },
        sourceReportId = row.source_report_id,
        createdAt = tonumber(row.created_at) or 0,
        updatedAt = tonumber(row.updated_at) or 0,
        closedAt  = tonumber(row.closed_at) or 0,
        closedBy  = row.closed_by,
    }
end

local function fetchTicket(id)
    local rows = MySQL.Sync.fetchAll('SELECT * FROM `tickets` WHERE `id` = @id', { ['@id'] = id })
    return rows and rows[1] or nil
end

local function fetchParticipants(id)
    return MySQL.Sync.fetchAll(
        'SELECT `identifier`,`name`,`role`,`added_by`,`added_at` FROM `ticket_participants` WHERE `ticket_id` = @id ORDER BY `added_at` ASC',
        { ['@id'] = id }) or {}
end

local function fetchAssignedAdmins(id)
    return MySQL.Sync.fetchAll(
        'SELECT `identifier`,`name`,`assigned_by`,`assigned_at` FROM `ticket_admins` WHERE `ticket_id` = @id ORDER BY `assigned_at` ASC',
        { ['@id'] = id }) or {}
end

local function fetchMessages(id)
    return MySQL.Sync.fetchAll(
        'SELECT `identifier`,`name`,`is_admin`,`is_system`,`message`,`created_at` FROM `ticket_messages` WHERE `ticket_id` = @id ORDER BY `created_at` ASC',
        { ['@id'] = id }) or {}
end

--- Push a full detail refresh to any online participant/assigned admin of a
--- ticket, so the panel updates live instead of needing a manual refresh.
local function broadcastTicketUpdate(id)
    local t = fetchTicket(id)
    if not t then return end
    local detail = {
        ticket       = ticketSummaryRow(t),
        participants = fetchParticipants(id),
        admins       = fetchAssignedAdmins(id),
        messages     = fetchMessages(id),
    }
    for _, src in ipairs(ESX.GetPlayers()) do
        local ident = getIdentifier(src)
        if ident then
            local isParticipant = ident == t.creator_identifier
            if not isParticipant then
                for _, p in ipairs(detail.participants) do
                    if p.identifier == ident then isParticipant = true break end
                end
            end
            local isAssigned = false
            if isTicketAdmin(src) then
                for _, a in ipairs(detail.admins) do
                    if a.identifier == ident then isAssigned = true break end
                end
            end
            if isParticipant or isAssigned or isTicketAdmin(src) then
                TriggerClientEvent('Unique_Ticket:push', src, id, detail)
            end
        end
    end
end

-- =========================================================== callbacks ===

-- ------------------------------------------------------------- create ---
RegisterServerCallbackSafe('Unique_Ticket:create', function(source, cb, payload)
    payload = payload or {}
    local title = clean(payload.title, Ticket_Config.TitleMax)
    local message = clean(payload.message, Ticket_Config.MessageMax)
    if not title or not message then
        return cb({ r = false, msg = 'عنوان و توضیحات نمی‌توانند خالی باشند.' })
    end
    local category = payload.category or 'other'
    local valid = false
    for _, c in ipairs(Ticket_Config.Categories) do if c.id == category then valid = true break end end
    if not valid then category = 'other' end

    local priority = tonumber(payload.priority) or 1
    local validPrio = false
    for _, p in ipairs(Ticket_Config.Priorities) do if p.id == priority then validPrio = true break end end
    if not validPrio then priority = 1 end

    local identifier, name = getIdentifier(source), getName(source)
    if not identifier then return cb({ r = false, msg = 'خطا در شناسایی حساب.' }) end

    -- MySQL.Sync.insert does not exist on this server's DB wrapper - only
    -- MySQL.Async.insert(query, params, callback) does, and it hands back
    -- the new row's id through that callback (exactly like server/report_
    -- main.lua's own report INSERT does). Everything that needs `id` has to
    -- live inside this callback.
    MySQL.Async.insert(
        'INSERT INTO `tickets` (`title`,`category`,`priority`,`status`,`creator_identifier`,`creator_name`,`created_at`,`updated_at`) VALUES (@title,@cat,@prio,\'open\',@ident,@name,@t,@t)',
        { ['@title'] = title, ['@cat'] = category, ['@prio'] = priority, ['@ident'] = identifier, ['@name'] = name, ['@t'] = now() },
        function(insertId)
            local id = tonumber(insertId) or 0
            if id == 0 then return cb({ r = false, msg = 'خطای دیتابیس.' }) end

            MySQL.Async.execute(
                'INSERT INTO `ticket_participants` (`ticket_id`,`identifier`,`name`,`role`,`added_by`,`added_at`) VALUES (@t,@i,@n,\'creator\',@i,@c)',
                { ['@t'] = id, ['@i'] = identifier, ['@n'] = name, ['@c'] = now() })

            MySQL.Async.execute(
                'INSERT INTO `ticket_messages` (`ticket_id`,`identifier`,`name`,`is_admin`,`message`,`created_at`) VALUES (@t,@i,@n,0,@m,@c)',
                { ['@t'] = id, ['@i'] = identifier, ['@n'] = name, ['@m'] = message, ['@c'] = now() })

            notifyAllAdmins('warn', 'تیکت جدید', { ('#%d - %s'):format(id, title), 'از طرف: ' .. name })
            pushDiscord({ title = '🎫 تیکت جدید #' .. id, description = title, color = 0x38bdf8,
                fields = { { name = 'بازیکن', value = name, inline = true }, { name = 'دسته', value = category, inline = true } } })

            cb({ r = true, id = id })
        end)
end)

-- ------------------------------------------------- create from a report ---
-- Reuses the SAME export report_main.lua already publishes for admin_tools.lua
-- (exports('GetReports', ...)) - read-only, no edits to the report system.
RegisterServerCallbackSafe('Unique_Ticket:createFromReport', function(source, cb, reportId)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    local ok, reports = pcall(function() return exports.Unique_AdminPanel:GetReports() end)
    if not ok or not reports or not reports[tostring(reportId)] then
        return cb({ r = false, msg = 'گزارش پیدا نشد یا دیگر باز نیست.' })
    end
    local rep = reports[tostring(reportId)]
    local adminIdent, adminName = getIdentifier(source), getName(source)

    MySQL.Async.insert(
        [[INSERT INTO `tickets` (`title`,`category`,`priority`,`status`,`creator_identifier`,`creator_name`,`source_report_id`,`created_at`,`updated_at`)
          VALUES (@title,'report',2,'open',@ident,@name,@rid,@t,@t)]],
        {
            ['@title'] = ('گزارش: %s'):format(rep.category or 'بدون عنوان'),
            ['@ident'] = rep.owner and rep.owner.identifier or nil,
            ['@name']  = rep.owner and rep.owner.name or 'نامشخص',
            ['@rid']   = reportId,
            ['@t']     = now(),
        },
        function(insertId)
    local id = tonumber(insertId) or 0
    if id == 0 then return cb({ r = false, msg = 'خطای دیتابیس.' }) end

    if rep.owner and rep.owner.identifier then
        MySQL.Async.execute(
            'INSERT IGNORE INTO `ticket_participants` (`ticket_id`,`identifier`,`name`,`role`,`added_by`,`added_at`) VALUES (@t,@i,@n,\'creator\',@a,@c)',
            { ['@t'] = id, ['@i'] = rep.owner.identifier, ['@n'] = rep.owner.name, ['@a'] = adminName, ['@c'] = now() })
    end
    MySQL.Async.execute(
        'INSERT IGNORE INTO `ticket_admins` (`ticket_id`,`identifier`,`name`,`assigned_by`,`assigned_at`) VALUES (@t,@i,@n,@n,@c)',
        { ['@t'] = id, ['@i'] = adminIdent, ['@n'] = adminName, ['@c'] = now() })
    MySQL.Async.execute(
        'INSERT INTO `ticket_messages` (`ticket_id`,`identifier`,`name`,`is_admin`,`message`,`created_at`) VALUES (@t,@i,@n,0,@m,@c)',
        { ['@t'] = id, ['@i'] = rep.owner and rep.owner.identifier or nil, ['@n'] = rep.owner and rep.owner.name or 'نامشخص', ['@m'] = rep.Detail or '(بدون توضیح)', ['@c'] = now() })
    logSystemMessage(id, ('%s این تیکت را از گزارش #%s ساخت.'):format(adminName, tostring(reportId)))

    cb({ r = true, id = id })
        end)
end)

-- ------------------------------------------------------------- lists ---
RegisterServerCallbackSafe('Unique_Ticket:getMine', function(source, cb)
    local identifier = getIdentifier(source)
    if not identifier then return cb({ r = false, data = {} }) end
    local rows = MySQL.Sync.fetchAll(
        [[SELECT DISTINCT t.* FROM `tickets` t
          LEFT JOIN `ticket_participants` p ON p.ticket_id = t.id
          WHERE t.creator_identifier = @i OR p.identifier = @i
          ORDER BY t.updated_at DESC LIMIT 100]],
        { ['@i'] = identifier })
    local out = {}
    for _, r in ipairs(rows or {}) do out[#out + 1] = ticketSummaryRow(r) end
    cb({ r = true, data = out })
end)

RegisterServerCallbackSafe('Unique_Ticket:getAll', function(source, cb, filter)
    if not isTicketAdmin(source) then return cb({ r = false, data = {} }) end
    filter = filter or {}
    local where, params = '1=1', {}
    if filter.status and filter.status ~= 'all' then
        where = where .. ' AND `status` = @status'
        params['@status'] = filter.status
    end
    if filter.mine then
        where = where .. ' AND `id` IN (SELECT `ticket_id` FROM `ticket_admins` WHERE `identifier` = @me)'
        params['@me'] = getIdentifier(source)
    end
    local rows = MySQL.Sync.fetchAll(
        'SELECT * FROM `tickets` WHERE ' .. where .. ' ORDER BY (`status` != \'closed\') DESC, `priority` DESC, `updated_at` DESC LIMIT 300',
        params)
    local out = {}
    for _, r in ipairs(rows or {}) do out[#out + 1] = ticketSummaryRow(r) end
    cb({ r = true, data = out })
end)

RegisterServerCallbackSafe('Unique_Ticket:listOpenReports', function(source, cb)
    if not isTicketAdmin(source) then return cb({ r = false, data = {} }) end
    local ok, reports = pcall(function() return exports.Unique_AdminPanel:GetReports() end)
    local out = {}
    if ok and reports then
        for id, r in pairs(reports) do
            out[#out + 1] = { id = id, category = r.category, detail = r.Detail, owner = r.owner and r.owner.name or '?', status = r.status }
        end
    end
    cb({ r = true, data = out })
end)

-- ------------------------------------------------------------- detail ---
local function canView(source, t)
    if isTicketAdmin(source) then return true end
    local identifier = getIdentifier(source)
    if identifier == t.creator_identifier then return true end
    local rows = MySQL.Sync.fetchAll('SELECT 1 FROM `ticket_participants` WHERE `ticket_id` = @t AND `identifier` = @i',
        { ['@t'] = t.id, ['@i'] = identifier })
    return rows and #rows > 0
end

RegisterServerCallbackSafe('Unique_Ticket:getDetail', function(source, cb, ticketId)
    local t = fetchTicket(ticketId)
    if not t or not canView(source, t) then return cb({ r = false }) end
    cb({
        r = true,
        ticket       = ticketSummaryRow(t),
        participants = fetchParticipants(ticketId),
        admins       = fetchAssignedAdmins(ticketId),
        messages     = fetchMessages(ticketId),
    })
end)

-- --------------------------------------------------------------- chat ---
RegisterServerCallbackSafe('Unique_Ticket:sendMessage', function(source, cb, ticketId, text)
    local t = fetchTicket(ticketId)
    if not t or not canView(source, t) then return cb({ r = false }) end
    local msg = clean(text, Ticket_Config.MessageMax)
    if not msg then return cb({ r = false, msg = 'پیام خالی است.' }) end
    local isAdmin = isTicketAdmin(source)
    local identifier, name = getIdentifier(source), getName(source)

    MySQL.Async.execute(
        'INSERT INTO `ticket_messages` (`ticket_id`,`identifier`,`name`,`is_admin`,`message`,`created_at`) VALUES (@t,@i,@n,@a,@m,@c)',
        { ['@t'] = ticketId, ['@i'] = identifier, ['@n'] = name, ['@a'] = isAdmin and 1 or 0, ['@m'] = msg, ['@c'] = now() })
    MySQL.Async.execute('UPDATE `tickets` SET `updated_at` = @c WHERE `id` = @t', { ['@t'] = ticketId, ['@c'] = now() })

    if not isAdmin then
        notifyAllAdmins('warn', ('پیام جدید در تیکت #%d'):format(ticketId), { name .. ': ' .. msg })
    end
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

-- -------------------------------------------------------------- priority ---
RegisterServerCallbackSafe('Unique_Ticket:setPriority', function(source, cb, ticketId, priority)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    priority = tonumber(priority)
    local valid = false
    for _, p in ipairs(Ticket_Config.Priorities) do if p.id == priority then valid = true break end end
    if not valid then return cb({ r = false }) end
    MySQL.Async.execute('UPDATE `tickets` SET `priority` = @p, `updated_at` = @c WHERE `id` = @t',
        { ['@p'] = priority, ['@t'] = ticketId, ['@c'] = now() })
    logSystemMessage(ticketId, ('%s اولویت تیکت را تغییر داد.'):format(getName(source)))
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

-- Lets ui/report/js/script.js show "این ریپورت تیکت #42 داره" instead of a
-- blind "تبدیل به تیکت" button, and avoid admins accidentally spawning five
-- duplicate tickets off the same report.
RegisterServerCallbackSafe('Unique_Ticket:getReportTicketIds', function(source, cb, reportId)
    if not isTicketAdmin(source) then return cb({ r = false, data = {} }) end
    local rows = MySQL.Sync.fetchAll(
        'SELECT `id`,`status` FROM `tickets` WHERE `source_report_id` = @r ORDER BY `id` DESC',
        { ['@r'] = reportId })
    cb({ r = true, data = rows or {} })
end)

-- ---------------------------------------------------------- linked report ---
-- Read-only preview of the report a ticket was created from - queries the
-- `reports` table directly (its schema is documented in sql/reports.sql)
-- instead of exports.Unique_AdminPanel:GetReports(), because that export
-- only returns still-open reports and a linked report may since have been
-- closed/archived by an admin elsewhere.
RegisterServerCallbackSafe('Unique_Ticket:getLinkedReport', function(source, cb, reportId)
    local rows = MySQL.Sync.fetchAll(
        'SELECT ID, title, sub, category, status, admin_name, created_at, closed_at FROM reports WHERE ID = @id',
        { ['@id'] = reportId })
    local r = rows and rows[1]
    if not r then return cb({ r = false }) end
    cb({ r = true, report = {
        id = r.ID, title = r.title, detail = r.sub, category = r.category,
        status = r.status, adminName = r.admin_name,
        createdAt = tonumber(r.created_at) or 0, closedAt = tonumber(r.closed_at) or 0,
    } })
end)

-- ---------------------------------------------------------------- status ---
-- IMPORTANT: this is the ONLY code path in this entire file that can set a
-- ticket's status to 'closed' - there is no background thread, no timeout,
-- nothing else touches `tickets`.`status`. A ticket stays open/in_progress
-- indefinitely until an on-duty admin explicitly calls this with
-- status = 'closed' (isTicketAdmin(source) below, same gate as every other
-- admin-only callback in this file). Unlike server/report_autoclose.lua,
-- there is intentionally NO auto-close timer for tickets.
RegisterServerCallbackSafe('Unique_Ticket:setStatus', function(source, cb, ticketId, status)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    local valid = false
    for _, s in ipairs(Ticket_Config.Statuses) do if s.id == status then valid = true break end end
    if not valid then return cb({ r = false }) end

    local adminName = getName(source)
    if status == 'closed' then
        MySQL.Async.execute('UPDATE `tickets` SET `status` = @s, `updated_at` = @c, `closed_at` = @c, `closed_by` = @a WHERE `id` = @t',
            { ['@s'] = status, ['@t'] = ticketId, ['@c'] = now(), ['@a'] = adminName })
    else
        MySQL.Async.execute('UPDATE `tickets` SET `status` = @s, `updated_at` = @c WHERE `id` = @t',
            { ['@s'] = status, ['@t'] = ticketId, ['@c'] = now() })
    end
    logSystemMessage(ticketId, ('%s وضعیت تیکت را به «%s» تغییر داد.'):format(adminName, status))
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

-- ---------------------------------------------------------- participants ---
-- Player search for the "add player" box - checks online players first
-- (instant), then falls back to the users table by name (offline players
-- can still be attached to a ticket, e.g. to review after they log off).
RegisterServerCallbackSafe('Unique_Ticket:searchPlayer', function(source, cb, query)
    if not isTicketAdmin(source) then return cb({ r = false, data = {} }) end
    query = clean(query, 60)
    local out = {}
    if query then
        local q = query:lower()
        for _, src in ipairs(ESX.GetPlayers()) do
            local n = getName(src)
            if n and n:lower():find(q, 1, true) or tostring(src) == query then
                out[#out + 1] = { identifier = getIdentifier(src), name = n, source = src, online = true }
            end
        end
        if #out < 15 then
            local rows = MySQL.Sync.fetchAll(
                'SELECT `identifier`,`firstname`,`lastname` FROM `users` WHERE `firstname` LIKE @q OR `lastname` LIKE @q LIMIT 15',
                { ['@q'] = '%' .. query .. '%' })
            for _, r in ipairs(rows or {}) do
                local already = false
                for _, o in ipairs(out) do if o.identifier == r.identifier then already = true break end end
                if not already then
                    out[#out + 1] = { identifier = r.identifier, name = (r.firstname or '') .. ' ' .. (r.lastname or ''), online = false }
                end
            end
        end
    end
    cb({ r = true, data = out })
end)

RegisterServerCallbackSafe('Unique_Ticket:addParticipant', function(source, cb, ticketId, identifier, name)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    if not identifier then return cb({ r = false, msg = 'بازیکن نامعتبر.' }) end
    MySQL.Async.execute(
        'INSERT IGNORE INTO `ticket_participants` (`ticket_id`,`identifier`,`name`,`role`,`added_by`,`added_at`) VALUES (@t,@i,@n,\'involved\',@a,@c)',
        { ['@t'] = ticketId, ['@i'] = identifier, ['@n'] = name or identifier, ['@a'] = getName(source), ['@c'] = now() })
    logSystemMessage(ticketId, ('%s بازیکن %s را به تیکت اضافه کرد.'):format(getName(source), name or identifier))
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

RegisterServerCallbackSafe('Unique_Ticket:removeParticipant', function(source, cb, ticketId, identifier)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    MySQL.Async.execute('DELETE FROM `ticket_participants` WHERE `ticket_id` = @t AND `identifier` = @i',
        { ['@t'] = ticketId, ['@i'] = identifier })
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

-- --------------------------------------------------------- assigned admins ---
RegisterServerCallbackSafe('Unique_Ticket:getOnlineAdmins', function(source, cb)
    if not isTicketAdmin(source) then return cb({ r = false, data = {} }) end
    local out = {}
    for _, src in ipairs(ESX.GetPlayers()) do
        if isTicketAdmin(src) then
            out[#out + 1] = { identifier = getIdentifier(src), name = getName(src), source = src }
        end
    end
    cb({ r = true, data = out })
end)

RegisterServerCallbackSafe('Unique_Ticket:assignAdmin', function(source, cb, ticketId, identifier, name)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    MySQL.Async.execute(
        'INSERT IGNORE INTO `ticket_admins` (`ticket_id`,`identifier`,`name`,`assigned_by`,`assigned_at`) VALUES (@t,@i,@n,@a,@c)',
        { ['@t'] = ticketId, ['@i'] = identifier, ['@n'] = name, ['@a'] = getName(source), ['@c'] = now() })
    -- MySQL.Sync.fetchScalar doesn't exist on this server's DB wrapper
    -- either - fold the "only bump status if it was still open" check into
    -- the UPDATE's WHERE clause instead of reading first, which is both
    -- simpler and avoids a read-then-write race.
    MySQL.Async.execute(
        "UPDATE `tickets` SET `status` = 'in_progress', `updated_at` = @c WHERE `id` = @t AND `status` = 'open'",
        { ['@t'] = ticketId, ['@c'] = now() })
    logSystemMessage(ticketId, ('%s، %s را به تیکت اضافه کرد.'):format(getName(source), name))
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

RegisterServerCallbackSafe('Unique_Ticket:unassignAdmin', function(source, cb, ticketId, identifier)
    if not isTicketAdmin(source) then return cb({ r = false }) end
    MySQL.Async.execute('DELETE FROM `ticket_admins` WHERE `ticket_id` = @t AND `identifier` = @i',
        { ['@t'] = ticketId, ['@i'] = identifier })
    broadcastTicketUpdate(ticketId)
    cb({ r = true })
end)

dprint('^2[Unique_AdminPanel]^0 Ticket system loaded (server/ticket_main.lua).')
