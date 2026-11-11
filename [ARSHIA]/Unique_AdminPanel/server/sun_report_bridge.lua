--[[ ===========================================================================
    Unique RP - Sun-style report bridge | server/sun_report_bridge.lua
    Loads AFTER server/report_main.lua.

    Sun's chat UI (BASE/chat) talks to this file; everything real (DB, cooldown,
    XP, ratings, logs) still happens in report_main.lua - this only translates:

      player  /report -> SunRep:submit(message, categoryLabel) -> Unique_Report:create
      player  rating  -> SunRep:rate(reportId, 1-10, comment)  -> Unique_Report:rate (1-5)
      admin   panel   -> SunRep:getReports / SunRep:spectate / SunRep:accept
      ticket indicator: open (waiting) -> pending (admin is on it) -> closed (rate)

    Sun status words:  open = waiting in queue, pending = admin accepted.
=========================================================================== ]]

local RATE_WINDOW = 30 * 60      -- unrated closed report stays rateable (seconds)
local MAX_MSG     = 128          -- same cap as the Sun form

local function catByLabel(label)
    for _, c in ipairs(Config_Shared.Categories) do
        if c.sun and (c.label == label or c.sunKey == label) then return c end
    end
end

local function catLabel(key)
    local c = Config_Shared.GetCategory(key)
    return c and c.label or tostring(key)
end

local function sourceOf(identifier)
    local x = Rep.GetPlayerByIdentifier(identifier)
    return x and x.source or nil
end

-- push the ticket indicator state to the reporter
local function pushStatus(row, status, adminName)
    local src = sourceOf(row.identifier)
    if not src then return end
    TriggerClientEvent('SunRep:status', src, {
        status = status, adminName = adminName or row.admin_name,
        cat = catLabel(row.category), message = row.sub,
        time = tonumber(row.created_at) or os.time(), reportId = row.ID,
    })
end

-- ---- wrap accept / close so the reporter's indicator follows the real state ----
local _Accept, _Close = AcceptReport, CloseReport

function AcceptReport(src, reportId, cb)
    _Accept(src, reportId, function(res)
        if res and res.r then
            local row = Rep.GetReport(res.id or reportId)
            if row then pushStatus(row, 'pending', row.admin_name) end
        end
        if cb then cb(res) end
    end)
end

function CloseReport(src, reportId, cb)
    _Close(src, reportId, function(res)
        if res and res.r then
            -- the UPDATE has already run; fetch the final row
            local row = Rep.GetReport(reportId)
            if row then pushStatus(row, 'closed', row.admin_name) end
        end
        if cb then cb(res) end
    end)
end

CreateThread(function()
    while not Rep.Ready() do Wait(200) end

    -- ------------------------------------------------ player: pending rating ---
    RegisterServerCallbackSafe('SunRep:checkPendingRating', function(source, cb)
        local identifier = Rep.GetIdentifier(source)
        if not identifier then return cb({ hasPending = false }) end
        local rows = MySQL.Sync.fetchAll([[
            SELECT ID, admin_name FROM reports
            WHERE identifier = @id AND status = 'close' AND (rating IS NULL OR rating = 0)
              AND closed_at > @since AND admin IS NOT NULL
            ORDER BY ID DESC LIMIT 1
        ]], { ['@id'] = identifier, ['@since'] = os.time() - RATE_WINDOW })
        local r = rows and rows[1]
        if not r then return cb({ hasPending = false }) end
        cb({ hasPending = true, reportId = r.ID, adminName = r.admin_name or '' })
    end)

    -- ------------------------------------------------ admin: queue + history ---
    RegisterServerCallbackSafe('SunRep:getReports', function(source, cb)
        if not Rep.HasAccess(source, Config_Shared.accessToAdminCommand) then
            return cb({ r = false })
        end
        local nameCol = Config_Server.PlayerNameInDB or 'playerName'
        local function owner(row)
            local x = Rep.GetPlayerByIdentifier(row.identifier)
            return {
                id = x and x.source or 0,
                name = row.Name or 'N/A',
                level = x and x.permission_level or 0,
            }
        end

        local active = MySQL.Sync.fetchAll(([[
            SELECT r.ID, r.sub, r.category, r.status, r.identifier, r.admin_name, r.created_at, u.`%s` AS Name
            FROM reports r LEFT JOIN users u ON u.identifier = r.identifier
            WHERE r.status IN ('pending','accept')
            ORDER BY r.ID DESC LIMIT 100
        ]]):format(nameCol), {}) or {}

        local reports = {}
        for _, row in ipairs(active) do
            local accepted = row.status == 'accept'
            reports[tostring(row.ID)] = {
                owner   = owner(row),
                status  = accepted and 'pending' or 'open',
                cat     = catLabel(row.category),
                message = row.sub,
                time    = tonumber(row.created_at) or 0,
                respond = accepted and { name = row.admin_name or '' } or nil,
            }
        end

        local done = MySQL.Sync.fetchAll(([[
            SELECT r.ID, r.sub, r.category, r.identifier, r.admin_name, r.created_at, r.closed_at, u.`%s` AS Name
            FROM reports r LEFT JOIN users u ON u.identifier = r.identifier
            WHERE r.status = 'close'
            ORDER BY r.closed_at DESC LIMIT 40
        ]]):format(nameCol), {}) or {}

        local closed = {}
        for _, row in ipairs(done) do
            closed[#closed + 1] = {
                owner = owner(row), cat = catLabel(row.category), message = row.sub,
                time = tonumber(row.created_at) or 0, closedAt = tonumber(row.closed_at) or 0,
                action = 'accepted', closedBy = { name = row.admin_name or '?' },
            }
        end

        cb({ r = true, reports = reports, closed = closed })
    end)
end)

-- -------------------------------------------------------------- player events ---
RegisterNetEvent('SunRep:submit')
AddEventHandler('SunRep:submit', function(message, categoryLabel)
    local src = source
    local cat = catByLabel(tostring(categoryLabel or ''))
    if not cat then return Rep.Notify(src, ReportLan.invalidCategory) end

    message = Rep.Clean(tostring(message or ''), MAX_MSG * 4) or ''
    if Rep.Len(message) > MAX_MSG then message = message:sub(1, MAX_MSG) end

    -- report_main enforces title 5-64 / info 15-1000: build values that pass for short Sun inputs
    local L = Config_Shared.Limits
    local title = cat.label
    if Rep.Len(title) < L.titleMin then title = 'Report: ' .. title end
    local info = message
    if Rep.Len(info) < L.infoMin then info = ('%s | %s'):format(cat.label, message) end
    if Rep.Len(info) < L.infoMin then info = info .. ' (ریپورت سریع)' end

    local create = GetLocalServerCallback('Unique_Report:create')
    if not create then return Rep.Notify(src, ReportLan.err) end
    create(src, function(res)
        if not res or not res.r then
            return Rep.Notify(src, (res and res.msg) or ReportLan.err)
        end
        local row = Rep.GetReport(res.id)
        if row then pushStatus(row, 'open') end
    end, { category = cat.key, title = title, info = info })
end)

RegisterNetEvent('SunRep:rate')
AddEventHandler('SunRep:rate', function(reportId, rating10)
    local src = source
    rating10 = tonumber(rating10)
    if not rating10 then return end
    local rating5 = math.max(1, math.min(5, math.ceil(rating10 / 2)))   -- Sun 1-10 -> report system 1-5
    local rate = GetLocalServerCallback('Unique_Report:rate')
    if rate then rate(src, function() end, reportId, rating5) end
end)

RegisterNetEvent('SunRep:cancel')
AddEventHandler('SunRep:cancel', function()
    local src = source
    local identifier = Rep.GetIdentifier(src)
    if not identifier then return end
    -- only a report nobody accepted yet can be withdrawn
    MySQL.Async.execute(
        "UPDATE reports SET status = 'archive' WHERE identifier = @id AND status = 'pending'",
        { ['@id'] = identifier }, function(n)
            if (n or 0) > 0 then
                Rep.RefreshAdminLists()
                TriggerClientEvent('SunRep:hide', src)
            end
        end)
end)

-- on join / resource restart: put the indicator back for a still-open report
RegisterNetEvent('SunRep:sync')
AddEventHandler('SunRep:sync', function()
    local src = source
    local identifier = Rep.GetIdentifier(src)
    if not identifier then return end
    local rows = MySQL.Sync.fetchAll([[
        SELECT * FROM reports WHERE identifier = @id
          AND (status IN ('pending','accept')
               OR (status = 'close' AND (rating IS NULL OR rating = 0) AND closed_at > @since AND admin IS NOT NULL))
        ORDER BY ID DESC LIMIT 1
    ]], { ['@id'] = identifier, ['@since'] = os.time() - RATE_WINDOW })
    local row = rows and rows[1]
    if not row then return end
    if row.status == 'pending' then pushStatus(row, 'open')
    elseif row.status == 'accept' then pushStatus(row, 'pending', row.admin_name)
    else pushStatus(row, 'closed', row.admin_name) end
end)

-- --------------------------------------------------------------- admin events ---
-- eye button: spectate the reporter (needs spectate access + the player must have an active report)
RegisterNetEvent('SunRep:spectate')
AddEventHandler('SunRep:spectate', function(ownerPid)
    local src = source
    ownerPid = tonumber(ownerPid)
    if not Rep.HasAccess(src, Config_Shared.AccessToSpect) then return Rep.Notify(src, ReportLan.notAccess) end
    if not ownerPid or ownerPid <= 0 or not GetPlayerName(ownerPid) then return Rep.Notify(src, ReportLan.notOnline) end
    local rows = MySQL.Sync.fetchAll(
        "SELECT ID FROM reports WHERE identifier = @t AND status IN ('pending','accept') LIMIT 1",
        { ['@t'] = Rep.GetIdentifier(ownerPid) })
    if not rows or #rows == 0 then return Rep.Notify(src, ReportLan.reportnotfound) end
    TriggerClientEvent(Config_Server.SpectateEvent or 'esx_spectate:spectatexxxx', src, ownerPid)
end)

-- phone button (after the spectate delay): accept the reporter's report
RegisterNetEvent('SunRep:accept')
AddEventHandler('SunRep:accept', function(ownerPid)
    local src = source
    ownerPid = tonumber(ownerPid)
    if not ownerPid or ownerPid <= 0 or not GetPlayerName(ownerPid) then return Rep.Notify(src, ReportLan.notOnline) end
    local rows = MySQL.Sync.fetchAll(
        "SELECT ID FROM reports WHERE identifier = @t AND status = 'pending' ORDER BY ID DESC LIMIT 1",
        { ['@t'] = Rep.GetIdentifier(ownerPid) })
    if not rows or #rows == 0 then return Rep.Notify(src, ReportLan.acceptByauthor) end
    AcceptReport(src, rows[1].ID, function(res)
        if not res.r then Rep.Notify(src, res.msg or ReportLan.err) end
    end)
end)
