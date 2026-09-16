--[[ ===========================================================================
    Unique RP - Report System | server/report_main.lua
    arshiahub.ir

    وضعیت‌ها:  pending -> accept -> close  (+ archive)

    باگ‌های امنیتی که نسخه قبلی داشت و اینجا بسته شدن:
      • PNG_ReportSystem:newChat هیچ چکی نداشت - هر پلیری میتونست تو ریپورت
        هرکس دیگه‌ای پیام بذاره و حتی نقش "admin" رو جعل کنه.
      • revive / teleport / givecar / spect همه net-event خام بودن بدون هیچ
        چک دسترسی. Config_Shared.AccessTo* تعریف شده بود ولی استفاده نمیشد.
      • feedBackXP احراز هویت نداشت - هرکسی میتونست بی‌نهایت XP برای هر
        ادمینی فارم کنه.
      • هیچ اعتبارسنجی سمت سرور روی title/sub/info نبود (فقط UI چک میکرد).
=========================================================================== ]]

local ESXReady = false

CreateThread(function()
    while not Rep.Ready() do Wait(200) end
    ESXReady = true
end)

local function guard(src, cb)
    if not Rep.Ready() then
        Rep.Notify(src, ReportLan.esxNotReady)
        if cb then cb({ r = false, msg = "notready" }) end
        return false
    end
    return true
end

-- ===================================================== سرور-کالبک دسترسی ===

CreateThread(function()
    while not Rep.Ready() do Wait(200) end
    local ESXo = Rep.ESX()

    RegisterServerCallbackSafe('Unique_Report:getAccess', function(source, cb, level)
        cb(Rep.HasAccess(source, level))
    end)

    -- ------------------------------------------------ ثبت ریپورت (کاربر) ---
    RegisterServerCallbackSafe('Unique_Report:create', function(source, cb, payload)
        local src = source
        if not guard(src, cb) then return end
        if type(payload) ~= 'table' then return cb({ r = false, msg = ReportLan.err }) end

        local identifier = Rep.GetIdentifier(src)
        if not identifier then return cb({ r = false, msg = ReportLan.err }) end

        -- کول‌داون
        local okCd, remain = Rep.CheckCooldown(identifier, 'create', Config_Server.createCooldown)
        if not okCd then
            return cb({ r = false, msg = ReportLan.cooldown:format(remain) })
        end

        -- اعتبارسنجی موضوع (whitelist - هرچی تو کانفیگ نباشه رد میشه)
        local cat = Config_Shared.GetCategory(payload.category)
        if not cat then return cb({ r = false, msg = ReportLan.invalidCategory }) end

        -- اعتبارسنجی متن
        local L = Config_Shared.Limits
        local title = Rep.Clean(payload.title, L.titleMax * 4)
        local info  = Rep.Clean(payload.info,  L.infoMax  * 4)

        if not title or Rep.Len(title) < L.titleMin or Rep.Len(title) > L.titleMax then
            return cb({ r = false, msg = ReportLan.titleShort:format(L.titleMin, L.titleMax) })
        end
        if not info or Rep.Len(info) < L.infoMin or Rep.Len(info) > L.infoMax then
            return cb({ r = false, msg = ReportLan.infoShort:format(L.infoMin, L.infoMax) })
        end

        -- سقف ریپورت باز
        local open = MySQL.Sync.fetchAll(
            "SELECT ID FROM reports WHERE identifier = @id AND status IN ('pending','accept')",
            { ['@id'] = identifier })
        if open and #open >= (Config_Server.maxOpenPerPlayer or 1) then
            return cb({ r = false, msg = ReportLan.reportLimit })
        end

        -- مختصات پلیر رو خودکار ضمیمه میکنیم (برای تلپورت ادمین)
        local ped = GetPlayerPed(src)
        local c   = ped and ped ~= 0 and GetEntityCoords(ped) or vector3(0, 0, 0)
        local meta = json.encode({
            coords  = { x = math.floor(c.x), y = math.floor(c.y), z = math.floor(c.z) },
            ping    = GetPlayerPing(src),
            name    = Rep.GetName(src),
        })

        local chat = json.encode({ {
            msgid = 1, user = "user", name = Rep.GetName(src),
            text = info, at = os.time()
        } })

        local now = os.time()
        MySQL.Async.insert([[
            INSERT INTO reports (title, sub, category, priority, identifier, status, chat, meta, created_at)
            VALUES (@title, @sub, @cat, @pri, @id, 'pending', @chat, @meta, @now)
        ]], {
            ['@title'] = title,
            ['@sub']   = info,
            ['@cat']   = cat.key,
            ['@pri']   = cat.priority,
            ['@id']    = identifier,
            ['@chat']  = chat,
            ['@meta']  = meta,
            ['@now']   = now,
        }, function(insertId)
            Rep.TouchCooldown(identifier, 'create')

            -- MySQL.Async.insert برمیگردونه ID رکورد جدید رو مستقیم.
            -- نسخه قبلی یه MySQL.Sync.fetchAll تو دلِ کال‌بکِ async میزد که
            -- هم کند بود هم تو شرایط همزمانی میتونست ID یکی دیگه رو برگردونه.
            local newId = tonumber(insertId) or 0

            cb({ r = true, id = newId, msg = ReportLan.submitReport })

            local pr = Config_Shared.Priorities[cat.priority]
            Rep.NotifyAllAdmins(ReportLan.newReportDetailed:format(
                newId, cat.label, pr and pr.label or '-'))
            Rep.RefreshAdminLists()
            Rep.PushToAdmins('Unique_Report:ping', 'new')

            Rep.LogCreate({
                ID = newId, title = title, sub = info,
                category = cat.key, priority = cat.priority,
            }, Rep.GetName(src), src, identifier)
        end)
    end)

    -- ------------------------------------------- ریپورت خودم (کاربر) ---
    RegisterServerCallbackSafe('Unique_Report:getMine', function(source, cb)
        local src = source
        if not guard(src, cb) then return end

        local identifier = Rep.GetIdentifier(src)
        local rows = MySQL.Sync.fetchAll(
            "SELECT * FROM reports WHERE identifier = @id AND status IN ('pending','accept') ORDER BY ID DESC LIMIT 1",
            { ['@id'] = identifier })

        local rep = rows and rows[1]
        if not rep then return cb({ r = false, msg = "notFound" }) end
        if rep.status == "pending" then
            return cb({ r = false, msg = "pending", id = rep.ID,
                        waited = os.time() - (tonumber(rep.created_at) or os.time()) })
        end

        local xAdmin    = Rep.GetPlayerByIdentifier(rep.admin)
        local adminName = rep.admin_name or (xAdmin and xAdmin.name) or ReportLan.notOnline
        local adminPerm = xAdmin and xAdmin.permission_level or 0

        Rep.GetAvatar(rep.admin, function(avatar)
            cb({
                r = true,
                data = {
                    ID          = rep.ID,
                    title       = rep.title,
                    category    = rep.category,
                    priority    = rep.priority,
                    AdminXP     = Rep.GetXP(rep.admin),
                    AdminName   = adminName,
                    AdminAvatar = avatar,
                    AdminRank   = Rep.GetRankName(adminPerm),
                    AdminOnline = xAdmin ~= nil,
                    chat        = Rep.GetChat(rep.ID),
                }
            })
        end)
    end)

    -- --------------------------------------------- لیست ریپورت (ادمین) ---
    RegisterServerCallbackSafe('Unique_Report:getAll', function(source, cb, filter)
        local src = source
        if not Rep.HasAccess(src, Config_Shared.accessToAdminCommand) then
            return cb({ r = false, msg = ReportLan.notAccess })
        end

        filter = (type(filter) == 'table') and filter or {}
        local where = "r.status != 'archive'"
        if filter.status == 'archive' then where = "r.status = 'archive'" end

        local nameCol = Config_Server.PlayerNameInDB or 'playerName'
        local rows = MySQL.Sync.fetchAll(([[
            SELECT r.ID, r.title, r.sub, r.category, r.priority, r.status,
                   r.identifier, r.admin, r.admin_name, r.created_at,
                   r.accepted_at, r.closed_at, r.rating, r.meta,
                   u.`%s` AS Name
            FROM reports r
            LEFT JOIN users u ON u.identifier = r.identifier
            WHERE %s
            ORDER BY (r.status = 'pending') DESC, r.priority DESC, r.ID DESC
            LIMIT 300
        ]]):format(nameCol, where), {})

        if not rows or #rows == 0 then return cb({ r = true, data = {} }) end

        local now = os.time()
        for _, row in ipairs(rows) do
            row.Name      = row.Name or "N/A"
            row.AdminName = row.admin_name or ReportLan.notOnline
            row.age       = now - (tonumber(row.created_at) or now)
            local xP      = Rep.GetPlayerByIdentifier(row.identifier)
            row.online    = xP ~= nil
            row.pid       = xP and xP.source or 0
            row.msgCount  = #Rep.GetChat(row.ID)
        end

        cb({ r = true, data = rows })
    end)

    -- --------------------------------------- ریپورتِ در دستِ این ادمین ---
    RegisterServerCallbackSafe('Unique_Report:getActive', function(source, cb)
        local src = source
        if not Rep.HasAccess(src, Config_Shared.accessToAdminCommand) then
            return cb({ r = false, msg = ReportLan.notAccess })
        end

        local identifier = Rep.GetIdentifier(src)
        local rows = MySQL.Sync.fetchAll(
            "SELECT * FROM reports WHERE admin = @a AND status = 'accept' ORDER BY ID DESC LIMIT 1",
            { ['@a'] = identifier })

        local rep = rows and rows[1]
        if not rep then return cb({ r = false, msg = "notaccept" }) end

        local xT  = Rep.GetPlayerByIdentifier(rep.identifier)
        local meta = {}
        if rep.meta then local ok, m = pcall(json.decode, rep.meta); if ok then meta = m or {} end end

        Rep.GetAvatar(rep.identifier, function(avatar)
            cb({
                r = true,
                data = {
                    ID       = rep.ID,
                    pid      = xT and xT.source or 0,
                    name     = (xT and xT.name) or meta.name or ReportLan.notOnline,
                    online   = xT ~= nil,
                    avatar   = avatar,
                    title    = rep.title,
                    category = rep.category,
                    priority = rep.priority,
                    coords   = meta.coords,
                    chat     = Rep.GetChat(rep.ID),
                    perms    = {
                        revive   = Rep.HasAccess(src, Config_Shared.AccessToRevive),
                        teleport = Rep.HasAccess(src, Config_Shared.AccessToTeleport),
                        bring    = Rep.HasAccess(src, Config_Shared.AccessToBring),
                        givecar  = Rep.HasAccess(src, Config_Shared.AccessToGiveCar),
                        spect    = Rep.HasAccess(src, Config_Shared.AccessToSpect),
                        freeze   = Rep.HasAccess(src, Config_Shared.AccessToFreeze),
                    }
                }
            })
        end)
    end)

    -- -------------------------------------------------- قبول / بستن ---
    RegisterServerCallbackSafe('Unique_Report:accept', function(source, cb, id)
        AcceptReport(source, id, cb)
    end)

    RegisterServerCallbackSafe('Unique_Report:close', function(source, cb, id)
        CloseReport(source, id, cb)
    end)

    RegisterServerCallbackSafe('Unique_Report:archive', function(source, cb, id)
        local src = source
        if not Rep.HasAccess(src, Config_Shared.accessToArchive) then
            return cb({ r = false, msg = ReportLan.notAccess })
        end
        MySQL.Async.execute("UPDATE reports SET status = 'archive' WHERE ID = @id",
            { ['@id'] = tonumber(id) }, function(n)
                Rep.RefreshAdminLists()
                cb({ r = (n or 0) > 0, msg = ReportLan.archived })
            end)
    end)

    RegisterServerCallbackSafe('Unique_Report:delete', function(source, cb, id)
        local src = source
        if not Rep.HasAccess(src, Config_Shared.accessToDelReport) then
            return cb({ r = false, msg = ReportLan.cantdel })
        end
        MySQL.Async.execute("DELETE FROM reports WHERE ID = @id",
            { ['@id'] = tonumber(id) }, function(n)
                Rep.RefreshAdminLists()
                cb({ r = (n or 0) > 0, msg = ReportLan.deleteReport })
            end)
    end)

    -- ------------------------------------------------------------ چت ---
    -- نسخه قبلی هیچ چکی نداشت. الان: باید یا صاحب ریپورت باشی یا ادمینِ
    -- تخصیص‌داده‌شده به همون ریپورت. نقش (user/admin) هم از روی خودِ سرور
    -- تعیین میشه نه از روی چیزی که کلاینت فرستاده.
    RegisterServerCallbackSafe('Unique_Report:chat', function(source, cb, id, text)
        local src = source
        if not guard(src, cb) then return end

        local rep = Rep.GetReport(id)
        if not rep then return cb({ r = false, msg = ReportLan.reportnotfound }) end
        if rep.status ~= 'accept' then return cb({ r = false, msg = ReportLan.CantAfterAccep }) end

        local identifier = Rep.GetIdentifier(src)
        local role
        if identifier == rep.identifier then
            role = 'user'
        elseif identifier == rep.admin and Rep.HasAccess(src, Config_Shared.accessToAdminCommand) then
            role = 'admin'
        else
            return cb({ r = false, msg = ReportLan.notYours })
        end

        local okCd = Rep.CheckCooldown(identifier, 'chat', Config_Server.chatCooldown)
        if not okCd then return cb({ r = false, msg = ReportLan.tooFast }) end

        local clean = Rep.Clean(text, Config_Shared.Limits.chatMax * 4)
        if not clean then return cb({ r = false }) end

        local authorName = Rep.GetName(src)
        Rep.AddChat(rep.ID, role, clean, authorName)
        Rep.TouchCooldown(identifier, 'chat')
        Rep.LogChat(rep.ID, role, authorName, clean)

        if role == 'user' then
            local xAdmin = Rep.GetPlayerByIdentifier(rep.admin)
            if xAdmin then
                Rep.Notify(xAdmin.source, ReportLan.AdminAlertNewMessage:format(rep.ID))
                TriggerClientEvent('Unique_Report:refreshChat', xAdmin.source, 'admin')
                TriggerClientEvent('Unique_Report:ping', xAdmin.source, 'msg')
            end
        else
            local xUser = Rep.GetPlayerByIdentifier(rep.identifier)
            if xUser then
                Rep.Notify(xUser.source, ReportLan.UserAlertNewMessage)
                TriggerClientEvent('Unique_Report:refreshChat', xUser.source, 'user')
                TriggerClientEvent('Unique_Report:ping', xUser.source, 'msg')
            end
        end

        cb({ r = true })
    end)

    -- ------------------------------------------------- امتیازدهی کاربر ---
    -- نسخه قبلی: هر پلیری میتونست feedBackXP رو با هر identifier ای اسپم کنه.
    -- الان: فقط صاحبِ همون ریپورتِ بسته‌شده، فقط یک‌بار.
    RegisterServerCallbackSafe('Unique_Report:rate', function(source, cb, reportId, rating)
        local src = source
        rating = tonumber(rating)
        if not rating or rating < 1 or rating > 5 then return cb({ r = false }) end

        local rep = Rep.GetReport(reportId)
        if not rep then return cb({ r = false, msg = ReportLan.reportnotfound }) end

        local identifier = Rep.GetIdentifier(src)
        if identifier ~= rep.identifier then return cb({ r = false, msg = ReportLan.notYours }) end
        if rep.status ~= 'close' then return cb({ r = false }) end
        if rep.rating and tonumber(rep.rating) > 0 then return cb({ r = false }) end  -- قبلا امتیاز داده

        MySQL.Async.execute("UPDATE reports SET rating = @rt WHERE ID = @id",
            { ['@rt'] = rating, ['@id'] = rep.ID })

        -- جدول آماری (سازگار با reports_extra.lua)
        MySQL.Async.execute([[
            INSERT INTO admin_report_ratings (report_id, admin_name, rating, created_at)
            VALUES (@rid, @an, @rt, @now)
        ]], {
            ['@rid'] = tostring(rep.ID),
            ['@an']  = rep.admin_name or rep.admin or '-',
            ['@rt']  = rating,
            ['@now'] = os.date('%Y-%m-%d %H:%M:%S'),
        })

        local amount = Config_Server.ActiveFeedBack
            and (Config_Server.XPFeedBack[rating] or 0)
            or Config_Server.XpAfterClose

        if amount > 0 and rep.admin then
            Rep.AddXP(rep.admin, amount)
            local xAdmin = Rep.GetPlayerByIdentifier(rep.admin)
            if xAdmin then Rep.Notify(xAdmin.source, ReportLan.adminxpAdd:format(amount)) end
        end

        Rep.Notify(src, ReportLan.tankstofeedback)
        cb({ r = true })
    end)

    -- ------------------------------------------------- برترین ادمین‌ها ---
    RegisterServerCallbackSafe('Unique_Report:topAdmins', function(source, cb)
        local nameCol = Config_Server.PlayerNameInDB or 'playerName'
        local permCol = Config_Server.NamePermInDB  or 'permission_level'
        local xpCol   = Config_Server.AdminXPColumn or 'unique_admin_xp'

        local rows = MySQL.Sync.fetchAll(([[
            SELECT u.`%s` AS name, u.`%s` AS perm, u.`%s` AS xp, u.identifier,
                   (SELECT COUNT(*) FROM reports r WHERE r.admin = u.identifier AND r.status IN ('close','archive')) AS handled,
                   (SELECT AVG(r2.rating) FROM reports r2 WHERE r2.admin = u.identifier AND r2.rating > 0) AS avg_rating,
                   (SELECT AVG(r3.accepted_at - r3.created_at) FROM reports r3 WHERE r3.admin = u.identifier AND r3.accepted_at > 0) AS avg_response
            FROM users u
            WHERE u.`%s` > 0
            ORDER BY u.`%s` DESC
            LIMIT 15
        ]]):format(nameCol, permCol, xpCol, permCol, xpCol), {})

        if not rows then return cb({ r = false }) end
        for _, r in ipairs(rows) do
            r.rank       = Rep.GetRankName(r.perm)
            r.xp         = tonumber(r.xp) or 0
            r.handled    = tonumber(r.handled) or 0
            r.avg_rating = tonumber(r.avg_rating)
            r.avg_response = tonumber(r.avg_response)
            r.online     = Rep.GetPlayerByIdentifier(r.identifier) ~= nil
            r.identifier = nil   -- به UI نمیدیم
        end
        cb({ r = true, data = rows })
    end)

    -- ------------------------------------------------------ آمار کلی ---
    RegisterServerCallbackSafe('Unique_Report:stats', function(source, cb)
        if not Rep.HasAccess(source, Config_Shared.accessToAdminCommand) then
            return cb({ r = false })
        end
        local s = MySQL.Sync.fetchAll([[
            SELECT
              SUM(status = 'pending') AS pending,
              SUM(status = 'accept')  AS active,
              SUM(status = 'close')   AS closed,
              COUNT(*)                AS total,
              AVG(NULLIF(rating,0))   AS avg_rating,
              AVG(NULLIF(accepted_at,0) - created_at) AS avg_response
            FROM reports
        ]], {})
        cb({ r = true, data = s and s[1] or {} })
    end)
end)

-- ==================================================== قبول کردن ریپورت ===

function AcceptReport(src, reportId, cb)
    cb = cb or function() end
    if not Rep.HasAccess(src, Config_Shared.accessToAcceptReport) then
        return cb({ r = false, msg = ReportLan.notAccess })
    end

    local rep = Rep.GetReport(reportId)
    if not rep then return cb({ r = false, msg = ReportLan.reportnotfound }) end
    if rep.status ~= "pending" then return cb({ r = false, msg = ReportLan.acceptByauthor }) end

    local identifier = Rep.GetIdentifier(src)
    if identifier == rep.identifier then
        return cb({ r = false, msg = ReportLan.cantaccept })
    end

    local adminName = Rep.GetName(src)
    local now = os.time()

    MySQL.Async.execute([[
        UPDATE reports SET status = 'accept', admin = @a, admin_name = @an, accepted_at = @now
        WHERE ID = @id AND status = 'pending'
    ]], {
        ['@a'] = identifier, ['@an'] = adminName, ['@now'] = now, ['@id'] = rep.ID,
    }, function(changed)
        if (changed or 0) == 0 then
            return cb({ r = false, msg = ReportLan.acceptByauthor })
        end

        Rep.AddChat(rep.ID, 'system', ("ادمین %s این ریپورت رو قبول کرد."):format(adminName), adminName)

        local xUser = Rep.GetPlayerByIdentifier(rep.identifier)
        if xUser then
            Rep.Notify(xUser.source, ReportLan.Acceptuser)
            TriggerClientEvent('Unique_Report:refreshChat', xUser.source, 'user')
            TriggerClientEvent('Unique_Report:ping', xUser.source, 'accept')
        end

        Rep.Notify(src, ReportLan.Accept:format(rep.ID))
        Rep.RefreshAdminLists()
        Rep.LogAccept(rep.ID, adminName, Rep.GetPermission(src), now - (tonumber(rep.created_at) or now))
        cb({ r = true, id = rep.ID })
    end)
end

-- ===================================================== بستن ریپورت ===

function CloseReport(src, reportId, cb)
    cb = cb or function() end

    local rep = Rep.GetReport(reportId)
    if not rep then return cb({ r = false, msg = ReportLan.reportnotfound }) end

    local identifier = Rep.GetIdentifier(src)
    local isOwnerAdmin = (identifier == rep.admin)
    -- ادمین ارشد میتونه ریپورت ادمین دیگه رو هم ببنده
    local isSenior = Rep.HasAccess(src, Config_Shared.accessToDelReport)

    if not isOwnerAdmin and not isSenior then
        return cb({ r = false, msg = ReportLan.notYours })
    end

    local now       = os.time()
    local closerName = Rep.GetName(src)
    local openedAt  = tonumber(rep.created_at) or now
    local msgCount  = #Rep.GetChat(rep.ID)

    MySQL.Async.execute("UPDATE reports SET status = 'close', closed_at = @now WHERE ID = @id",
        { ['@now'] = now, ['@id'] = rep.ID }, function()

        Rep.AddChat(rep.ID, 'system', ("ریپورت توسط %s بسته شد."):format(closerName), closerName)

        local xUser = Rep.GetPlayerByIdentifier(rep.identifier)
        local reporterSource = xUser and xUser.source or 0

        if xUser then
            Rep.Notify(xUser.source, ReportLan.closed)
            -- پنجره امتیازدهی
            TriggerClientEvent('Unique_Report:askRating', xUser.source, rep.ID, rep.admin_name or closerName)
        end

        -- زمان پاسخ‌گویی (سازگار با server/reports_extra.lua)
        MySQL.Async.execute([[
            INSERT INTO admin_report_response_times (admin_name, response_seconds, created_at)
            VALUES (@an, @sec, @now)
        ]], {
            ['@an']  = rep.admin_name or closerName,
            ['@sec'] = now - openedAt,
            ['@now'] = os.date('%Y-%m-%d %H:%M:%S'),
        })

        -- ایونت قدیمی که reports_extra.lua / investigation.lua بهش گوش میدن
        TriggerEvent('Unique_AdminPanel:ReportClosed', reporterSource, rep.ID, closerName, openedAt)

        Rep.Notify(src, ReportLan.closedByAdmin:format(rep.ID))
        TriggerClientEvent('Unique_Report:closedCleanup', src)
        Rep.RefreshAdminLists()
        Rep.LogClose(rep.ID, closerName, now - openedAt, msgCount)
        cb({ r = true })
    end)
end

-- ======================================= اکشن‌های ادمین روی پلیر ریپورتی ===
-- همه از یک مسیر مشترک رد میشن که هم دسترسی رو چک میکنه و هم اینکه
-- اون پلیر واقعا صاحبِ ریپورتِ فعالِ همین ادمینه (جلوگیری از سوءاستفاده).

local function adminAction(src, targetId, requiredLevel, fn)
    if not Rep.HasAccess(src, requiredLevel) then
        return Rep.Notify(src, ReportLan.notAccess)
    end

    targetId = tonumber(targetId)
    if not targetId or targetId <= 0 or not GetPlayerName(targetId) then
        return Rep.Notify(src, ReportLan.notOnline)
    end

    -- باید ریپورت فعالی داشته باشه که هم مالِ این ادمینه هم مالِ این پلیر
    local identifier  = Rep.GetIdentifier(src)
    local targetIdent = Rep.GetIdentifier(targetId)
    local rows = MySQL.Sync.fetchAll(
        "SELECT ID FROM reports WHERE admin = @a AND identifier = @t AND status = 'accept' LIMIT 1",
        { ['@a'] = identifier, ['@t'] = targetIdent })

    if not rows or #rows == 0 then
        return Rep.Notify(src, ReportLan.notYours)
    end

    fn(src, targetId)
end

RegisterNetEvent('Unique_Report:action')
AddEventHandler('Unique_Report:action', function(kind, targetId)
    local src = source

    if kind == 'revive' then
        adminAction(src, targetId, Config_Shared.AccessToRevive, function(a, t)
            TriggerClientEvent('Unique_Report:doRevive', t)
            Rep.Notify(a, ReportLan.AdminRevive)
            Rep.Notify(t, ReportLan.playerRevive)
        end)

    elseif kind == 'teleport' then
        adminAction(src, targetId, Config_Shared.AccessToTeleport, function(a, t)
            local ped = GetPlayerPed(t)
            if not ped or ped == 0 then return Rep.Notify(a, ReportLan.notOnline) end
            local c = GetEntityCoords(ped)
            TriggerClientEvent('Unique_Report:teleportTo', a, { x = c.x, y = c.y, z = c.z }, true)
            Rep.Notify(a, ReportLan.AdminTeleport)
            Rep.Notify(t, ReportLan.UserAdminTeleport)
        end)

    elseif kind == 'bring' then
        adminAction(src, targetId, Config_Shared.AccessToBring, function(a, t)
            local ped = GetPlayerPed(a)
            if not ped or ped == 0 then return end
            local c = GetEntityCoords(ped)
            TriggerClientEvent('Unique_Report:teleportTo', t, { x = c.x, y = c.y, z = c.z }, false)
            Rep.Notify(t, ReportLan.broughtToAdmin)
        end)

    elseif kind == 'return' then
        -- برگشت به موقعیت قبلی: فقط دسترسی لازمه، چک ریپورت نه
        if not Rep.HasAccess(src, Config_Shared.AccessToReturn) then
            return Rep.Notify(src, ReportLan.notAccess)
        end
        TriggerClientEvent('Unique_Report:returnBack', src)

    elseif kind == 'givecar' then
        adminAction(src, targetId, Config_Shared.AccessToGiveCar, function(a)
            TriggerClientEvent('Unique_Report:spawnAdminCar', a)
            Rep.Notify(a, ReportLan.adminGiveCar)
        end)

    elseif kind == 'spect' then
        adminAction(src, targetId, Config_Shared.AccessToSpect, function(a, t)
            TriggerClientEvent(Config_Server.SpectateEvent or 'esx_spectate:spectatexxxx', a, t)
        end)

    elseif kind == 'freeze' then
        adminAction(src, targetId, Config_Shared.AccessToFreeze, function(a, t)
            TriggerClientEvent('Unique_Report:toggleFreeze', t)
        end)
    end
end)

-- =============================================================== SLA ===
-- ریپورت‌هایی که بیش از حد مونده‌ان رو به ادمین‌ها و دیسکورد یادآوری میکنه.

CreateThread(function()
    while true do
        Wait((Config_Server.slaCheckSeconds or 120) * 1000)

        if Rep.Ready() and (Config_Server.slaWarnMinutes or 0) > 0 then
            local cutoff = os.time() - (Config_Server.slaWarnMinutes * 60)
            local rows = MySQL.Sync.fetchAll([[
                SELECT ID, title, created_at FROM reports
                WHERE status = 'pending' AND created_at < @cut AND sla_warned = 0
            ]], { ['@cut'] = cutoff })

            for _, r in ipairs(rows or {}) do
                local mins = math.floor((os.time() - (tonumber(r.created_at) or os.time())) / 60)
                Rep.NotifyAllAdmins(ReportLan.slaWarn:format(r.ID, mins))
                Rep.LogSLA(r.ID, mins, r.title)
                MySQL.Async.execute("UPDATE reports SET sla_warned = 1 WHERE ID = @id", { ['@id'] = r.ID })
            end
        end
    end
end)

-- ==================================================== دستورات ادمین ===

RegisterCommand('ar', function(src, args)
    local id = tonumber(args[1])
    if not id then return Rep.Notify(src, "استفاده: /ar [شماره ریپورت]") end
    AcceptReport(src, id, function(res)
        if not res.r then Rep.Notify(src, res.msg or ReportLan.err) end
    end)
end, false)

RegisterCommand('cr', function(src, args)
    local id = tonumber(args[1])
    if not id then return Rep.Notify(src, "استفاده: /cr [شماره ریپورت]") end
    CloseReport(src, id, function(res)
        if not res.r then Rep.Notify(src, res.msg or ReportLan.err) end
    end)
end, false)

local function xpCommand(name, fn)
    RegisterCommand(name, function(src, args)
        if not Rep.HasAccess(src, Config_Shared.AdminXPAccess) then
            return Rep.Notify(src, ReportLan.notAccess)
        end
        local target = tonumber(args[1])
        if not target or not GetPlayerName(target) then
            return Rep.Notify(src, ReportLan.notOnline)
        end
        fn(src, target, tonumber(args[2]))
    end, false)
end

xpCommand(Config_Server.CommandNameAddXP, function(src, target, amount)
    if not amount then return end
    UNIQUE_ADD_ADMIN_XP(target, amount)
    Rep.Notify(src, ("+%d XP به %s"):format(amount, Rep.GetName(target)))
    Rep.Notify(target, ReportLan.adminxpAdd:format(amount))
end)

xpCommand(Config_Server.CommandNameDelXP, function(src, target, amount)
    if not amount then return end
    UNIQUE_REMOVE_ADMIN_XP(target, amount)
    Rep.Notify(src, ("-%d XP از %s"):format(amount, Rep.GetName(target)))
    Rep.Notify(target, ReportLan.adminxpDel:format(amount))
end)

xpCommand(Config_Server.CommandNameCleanXP, function(src, target)
    UNIQUE_CLEAN_ADMIN_XP(target)
    Rep.Notify(src, ("XP بازیکن %s صفر شد."):format(Rep.GetName(target)))
end)

xpCommand(Config_Server.CommandNameShowXP, function(src, target)
    Rep.Notify(src, ("%s → %d XP"):format(Rep.GetName(target), UNIQUE_GET_ADMIN_XP(target)))
end)

-- ============================== سازگاری با بقیه‌ی Unique_AdminPanel ===
-- investigation.lua / admin_tools.lua / nui_panel.lua به این export وابسته‌ان
-- و وضعیت‌ها رو با اسم قدیمی میخوان:  open = هنوز قبول نشده، pending = در حال بررسی

exports('GetReports', function()
    local rows = MySQL.Sync.fetchAll(
        "SELECT ID, title, sub, category, identifier, status, created_at FROM reports WHERE status IN ('pending','accept')", {})
    local out = {}
    for _, r in ipairs(rows or {}) do
        local xOwner = Rep.GetPlayerByIdentifier(r.identifier)
        out[tostring(r.ID)] = {
            owner = {
                id         = xOwner and xOwner.source or 0,
                name       = xOwner and xOwner.name or r.identifier,
                identifier = r.identifier,
            },
            status   = (r.status == "pending") and "open" or "pending",
            category = r.category or r.title,
            Detail   = r.sub,
            time     = tonumber(r.created_at) or os.time(),
        }
    end
    return out
end)

-- =========================================== نگه‌داری / بایگانی خودکار ===

MySQL.ready(function()
    Wait(4000)

    if Config_Server.afterRestartCleanAllReport then
        MySQL.Async.execute("DELETE FROM reports", {}, function()
            print("^3[Unique Report]^0 همه ریپورت‌ها پاک شدند (afterRestartCleanAllReport = true).")
        end)
    else
        -- ریپورت‌های نیمه‌باز از ری‌استارت قبلی رو به حالت انتظار برمیگردونیم
        -- تا تو صفِ ادمین‌ها گم نشن.
        MySQL.Async.execute([[
            UPDATE reports SET status = 'pending', admin = NULL, admin_name = NULL,
                   accepted_at = 0, sla_warned = 0
            WHERE status = 'accept'
        ]], {})
    end

    local days = tonumber(Config_Server.autoArchiveAfterDays) or 0
    if days > 0 then
        MySQL.Async.execute([[
            UPDATE reports SET status = 'archive'
            WHERE status = 'close' AND closed_at > 0 AND closed_at < @cut
        ]], { ['@cut'] = os.time() - (days * 86400) })
    end

    print(("^2[Unique Report]^0 سیستم ریپورت %s آماده است. (%s)")
        :format(Config_Shared.ServerName, Config_Shared.ServerSite))
end)
