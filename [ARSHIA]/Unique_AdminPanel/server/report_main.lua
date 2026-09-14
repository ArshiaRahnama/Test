--[[
    PNG_ReportSystem - server/main.lua
    FIXED VERSION برای سرور Unique RP (essentialmode + oxmysql)

    تغییرات اصلی نسبت به نسخه‌ی اورجینال:
    - همه‌ی اکشن‌هایی که UI (ui/js/script.js) میفرسته الان یه هندلر واقعی سمت سرور دارن
      (قبلا فقط 3 تا از حدود 15 تا اکشن پیاده‌سازی شده بودن)
    - اسم توابع با function.lua یکی شدن
    - revive دیگه به esx_ambulancejob وابسته نیست (چون اون رویداد mal جاب آمبولانسه
      و ادمین‌ها معمولا اون جاب رو ندارن) - یه revive مستقل خودش داره
    - spect به رویداد واقعی esx_spectate:spectatexxxx (تو Unique_AdminPanel) وصل شده
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ==================== دسترسی ====================

ESX.RegisterServerCallback('PNG_ReportSystem:Getaccess', function(source, cb, requiredLevel)
    serverAceess(source, requiredLevel, cb)
end)

-- ==================== ثبت ریپورت (کاربر) ====================

RegisterNetEvent('PNG_ReportSystem:CreateNewRepot')
AddEventHandler('PNG_ReportSystem:CreateNewRepot', function(reportData)
    local source = source
    local identifier = (GetPlayerIdentifiers(source))[1]
    if not identifier or not reportData or not reportData.title then return end

    local existing = MySQL.Sync.fetchAll("SELECT ID FROM reports WHERE identifier = @identifier AND status != 'close'", {
        ['@identifier'] = identifier
    })

    if existing and #existing > 0 then
        SendNotif(source, ReportLan.reportLimit)
        return
    end

    local chat = json.encode({ { msgid = 1, user = "user", text = reportData.info or "" } })

    MySQL.Async.execute("INSERT INTO reports (title, sub, identifier, status, chat, created_at) VALUES (@title, @sub, @identifier, 'pending', @chat, @createdat)", {
        ['@title'] = reportData.title,
        ['@sub'] = reportData.sub,
        ['@identifier'] = identifier,
        ['@chat'] = chat,
        ['@createdat'] = os.time()
    }, function(rowsChanged)
        SendNotif(source, ReportLan.submitReport)
        UpdateAllReport()
        SendNotifToAllAdmin()
    end)
end)

-- ==================== دیدن وضعیت ریپورت خودم (کاربر) ====================

ESX.RegisterServerCallback('PNG_ReportSystem:GetDataReport', function(source, cb)
    local identifier = (GetPlayerIdentifiers(source))[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM reports WHERE identifier = @identifier ORDER BY ID DESC LIMIT 1", {
        ['@identifier'] = identifier
    })

    local report = result and result[1]
    if not report then
        return cb({ r = false, msg = "notFound" })
    end

    if report.status == "pending" then
        return cb({ r = false, msg = "pending" })
    end

    if report.status ~= "accept" then
        return cb({ r = false, msg = "notFound" })
    end

    local adminXP = GetAdminXPByIdentifier(report.admin)
    local xAdmin = ESX.GetPlayerFromIdentifier(report.admin)
    local adminName = xAdmin and xAdmin.name or (report.admin or ReportLan.notOnline)
    local adminRank = Config_Shared.Rank[xAdmin and xAdmin.permission_level or -1] or ReportLan.notOnline

    GetSteamAvatarByIdentifier(report.admin, function(avatar)
        cb({
            r = true,
            data = {
                ID = report.ID,
                AdminXP = adminXP,
                AdminName = adminName,
                AdminAvatar = avatar,
                AdminRank = adminRank,
                chat = GetChatMessages(report.ID)
            }
        })
    end)
end)

-- ==================== لیست همه ریپورت‌ها (پنل ادمین) ====================

ESX.RegisterServerCallback('PNG_ReportSystem:GetAllreport', function(source, cb)
    local nameCol = Config_Server.PlayerNameInDB or 'playerName'
    local query = string.format(
        "SELECT r.ID, r.title, r.sub, r.status, r.identifier, r.admin, u.%s AS Name, au.%s AS AdminName " ..
        "FROM reports r " ..
        "LEFT JOIN users u ON u.identifier = r.identifier " ..
        "LEFT JOIN users au ON au.identifier = r.admin " ..
        "ORDER BY r.ID DESC",
        nameCol, nameCol
    )
    local result = MySQL.Sync.fetchAll(query, {})

    if result and #result > 0 then
        for _, row in ipairs(result) do
            row.Name = row.Name or "N/A"
            row.AdminName = row.AdminName or ReportLan.notOnline
        end
        cb({ r = true, data = result })
    else
        cb({ r = false })
    end
end)

-- ==================== قبول کردن ریپورت (ادمین) ====================
-- این تابع مشترکه بین: NUI (پنل ادمین) و دستور /ar (که منوی F12 خودِ
-- Unique_AdminPanel یعنی nui_panel.lua ازش استفاده می‌کنه)

function AcceptReportByIdInternal(source, reportId, cb)
    serverAceess(source, Config_Shared.accessToAcceptReport, function(hasAccess)
        if not hasAccess then return cb(false) end

        local report = GetReportById(reportId)
        if not report then return cb(false) end
        if report.status ~= "pending" then return cb(false) end

        local identifier = (GetPlayerIdentifiers(source))[1]
        MySQL.Async.execute("UPDATE reports SET status = 'accept', admin = @admin WHERE ID = @id", {
            ['@admin'] = identifier,
            ['@id'] = reportId
        }, function()
            local xUser = ESX.GetPlayerFromIdentifier(report.identifier)
            if xUser then
                SendNotif(xUser.source, ReportLan.Acceptuser)
                TriggerClientEvent('PNG_ReportSystem:UpdateUIMessage', xUser.source, 'user')
            end
            UpdateAllReport()
            cb(true)
        end)
    end)
end

ESX.RegisterServerCallback('PNG_ReportSystem:acceptReport', function(source, cb, reportId)
    AcceptReportByIdInternal(source, reportId, cb)
end)

-- سازگاری با منوی F12 قدیمی Unique_AdminPanel (nui_panel.lua با ExecuteCommand('ar '..id) صداش میزنه)
RegisterCommand('ar', function(source, args)
    local reportId = tonumber(args[1])
    if not reportId then return SendNotif(source, ReportLan.notOnline) end
    AcceptReportByIdInternal(source, reportId, function(success)
        if not success then
            SendNotif(source, ReportLan.acceptByauthor or "Failed to accept report")
        end
    end)
end, false)

-- ==================== حذف ریپورت (ادمین) ====================

ESX.RegisterServerCallback('PNG_ReportSystem:deleteReport', function(source, cb, reportId)
    serverAceess(source, Config_Shared.accessToDelReport, function(hasAccess)
        if not hasAccess then return cb(false) end
        MySQL.Async.execute("DELETE FROM reports WHERE ID = @id", { ['@id'] = reportId }, function(rowsChanged)
            cb(rowsChanged and rowsChanged > 0)
        end)
    end)
end)

-- ==================== بستن ریپورت (ادمین) ====================
-- این تابع هم مشترکه بین NUI و دستور /cr (منوی F12)

function CloseReportByIdInternal(source, reportId, cb)
    local report = GetReportById(reportId)
    if not report then return cb(false) end

    local identifier = (GetPlayerIdentifiers(source))[1]
    if report.admin ~= identifier then return cb(false) end

    MySQL.Async.execute("UPDATE reports SET status = 'close' WHERE ID = @id", { ['@id'] = reportId }, function()
        local xUser = ESX.GetPlayerFromIdentifier(report.identifier)
        local closerName = GetPlayerName(source) or identifier
        local reporterSource = xUser and xUser.source or 0

        if xUser then
            SendNotif(xUser.source, ReportLan.closed)
            -- به کاربر بگو میتونه به ادمینی که جوابشو داد امتیاز بده
            TriggerClientEvent('PNG_ReportSystem:feedBack', xUser.source, 'show', report.admin)
        end

        -- سازگاری با reports_extra.lua (میانگین زمان پاسخ‌گویی + امتیازدهی رضایت)
        TriggerEvent('Unique_AdminPanel:ReportClosed', reporterSource, reportId, closerName, tonumber(report.created_at) or os.time())

        UpdateAllReport()
        cb(true)
    end)
end

ESX.RegisterServerCallback('PNG_ReportSystem:closeReport', function(source, cb, reportId)
    CloseReportByIdInternal(source, reportId, cb)
end)

-- سازگاری با منوی F12 قدیمی Unique_AdminPanel (nui_panel.lua با ExecuteCommand('cr '..id) صداش میزنه)
RegisterCommand('cr', function(source, args)
    local reportId = tonumber(args[1])
    if not reportId then return SendNotif(source, ReportLan.notOnline) end
    CloseReportByIdInternal(source, reportId, function(success)
        if not success then
            SendNotif(source, "Failed to close report")
        end
    end)
end, false)

-- ==================== دیتای ریپورتی که این ادمین قبول کرده ====================

ESX.RegisterServerCallback('PNG_ReportSystem:GetDataReportAdmin', function(source, cb)
    local identifier = (GetPlayerIdentifiers(source))[1]
    local result = MySQL.Sync.fetchAll("SELECT * FROM reports WHERE admin = @admin AND status = 'accept' ORDER BY ID DESC LIMIT 1", {
        ['@admin'] = identifier
    })

    local report = result and result[1]
    if not report then
        return cb({ r = false, msg = "notaccept" })
    end

    local xTarget = ESX.GetPlayerFromIdentifier(report.identifier)
    local pid = xTarget and xTarget.source or 0
    local name = xTarget and xTarget.name or (ReportLan.notOnline)

    GetSteamAvatarByIdentifier(report.identifier, function(avatar)
        cb({
            r = true,
            data = {
                ID = report.ID,
                pid = pid,
                name = name,
                avatar = avatar,
                chat = GetChatMessages(report.ID)
            }
        })
    end)
end)

-- ==================== چت داخل ریپورت ====================

ESX.RegisterServerCallback('PNG_ReportSystem:newChat', function(source, cb, reportId, user, text)
    local report = GetReportById(reportId)
    if not report then return cb(false) end

    SaveChatMessage(reportId, user, text)

    if user == "user" then
        NotifyAdminNewMessage(report.admin)
    else
        NotifyUserNewMessage(report.identifier)
    end

    cb(true)
end)

-- ==================== فیدبک و XP ادمین ====================

RegisterNetEvent('PNG_ReportSystem:feedBackXP')
AddEventHandler('PNG_ReportSystem:feedBackXP', function(rateId, adminIdentifier)
    local source = source
    if not adminIdentifier then return end

    local amount = 0
    if Config_Server.ActiveFeedBack then
        amount = Config_Server.XPFeedBack[tonumber(rateId)] or 0
    else
        amount = Config_Server.XpAfterClose
    end

    if amount > 0 then
        AddAdminXPByIdentifier(adminIdentifier, amount)
    end

    SendNotif(source, ReportLan.tankstofeedback)

    local xAdmin = ESX.GetPlayerFromIdentifier(adminIdentifier)
    if xAdmin then
        SendNotif(xAdmin.source, ReportLan.adminxpAdd)
    end
end)

-- ==================== اکشن‌های ادمین روی پلیر ریپورت‌شده ====================
-- توجه: "id" همون سورس‌آیدیِ پلیرِ ریپورت‌شده‌ست (pid که تو GetDataReportAdmin برگردوندیم)

RegisterNetEvent('PNG_ReportSystem:revive')
AddEventHandler('PNG_ReportSystem:revive', function(targetId)
    local adminSource = source
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return SendNotif(adminSource, ReportLan.notOnline)
    end
    -- ریوایو مستقل (به esx_ambulancejob وابسته نیست چون اون جاب-گیت شده)
    TriggerClientEvent('PNG_ReportSystem:doRevive', targetId)
    SendNotif(adminSource, ReportLan.AdminRevive)
    SendNotif(targetId, ReportLan.playerRevive)
end)

RegisterNetEvent('PNG_ReportSystem:teleport')
AddEventHandler('PNG_ReportSystem:teleport', function(targetId)
    local adminSource = source
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return SendNotif(adminSource, ReportLan.notOnline)
    end
    local targetPed = GetPlayerPed(targetId)
    if not targetPed or targetPed == 0 then
        return SendNotif(adminSource, ReportLan.notOnline)
    end
    local coords = GetEntityCoords(targetPed)
    TriggerClientEvent('PNG_ReportSystem:tptoplayer', adminSource, { x = coords.x, y = coords.y, z = coords.z })
    SendNotif(adminSource, ReportLan.AdminTeleport)
end)

RegisterNetEvent('PNG_ReportSystem:givecar')
AddEventHandler('PNG_ReportSystem:givecar', function(targetId)
    local adminSource = source
    -- اسپاون ماشین ادمین برای خود ادمین (تا بتونه بره سمت پلیر)
    TriggerClientEvent('PNG_ReportSystem:spwanManager', adminSource)
end)

RegisterNetEvent('PNG_ReportSystem:spect')
AddEventHandler('PNG_ReportSystem:spect', function(targetId)
    local adminSource = source
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then
        return SendNotif(adminSource, ReportLan.notOnline)
    end
    -- وصل به سیستم اسپکتیت واقعی تو Unique_AdminPanel
    TriggerClientEvent('esx_spectate:spectatexxxx', adminSource, targetId)
end)

-- ==================== دستورات XP ====================

RegisterCommand(Config_Server.CommandNameAddXP, function(source, args)
    serverAceess(source, Config_Shared.AdminXPAccess, function(hasAccess)
        if not hasAccess then return end
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])
        if not targetId or not GetPlayerName(targetId) then
            return SendNotif(source, ReportLan.notOnline)
        end
        if not amount then return end
        PNG_ADD_ADMIN_XP(targetId, amount)
        SendNotif(source, string.format(ReportLan.adminxpAdd .. " (+%d -> %s)", amount, GetPlayerName(targetId)))
        SendNotif(targetId, ReportLan.adminxpAdd)
    end)
end, false)

RegisterCommand(Config_Server.CommandNameDelXP, function(source, args)
    serverAceess(source, Config_Shared.AdminXPAccess, function(hasAccess)
        if not hasAccess then return end
        local targetId = tonumber(args[1])
        local amount = tonumber(args[2])
        if not targetId or not GetPlayerName(targetId) then
            return SendNotif(source, ReportLan.notOnline)
        end
        if not amount then return end
        PNG_REMOVE_ADMIN_XP(targetId, amount)
        SendNotif(source, string.format("XP removed (-%d) from %s", amount, GetPlayerName(targetId)))
    end)
end, false)

RegisterCommand(Config_Server.CommandNameCleanXP, function(source, args)
    serverAceess(source, Config_Shared.AdminXPAccess, function(hasAccess)
        if not hasAccess then return end
        local targetId = tonumber(args[1])
        if not targetId or not GetPlayerName(targetId) then
            return SendNotif(source, ReportLan.notOnline)
        end
        PNG_CLEAN_ADMIN_XP(targetId)
        SendNotif(source, "XP player pak shod")
    end)
end, false)

RegisterCommand(Config_Server.CommandNameShowXP, function(source, args)
    serverAceess(source, Config_Shared.AdminXPAccess, function(hasAccess)
        if not hasAccess then return end
        local targetId = tonumber(args[1])
        if not targetId or not GetPlayerName(targetId) then
            return SendNotif(source, ReportLan.notOnline)
        end
        local xp = PNG_GET_ADMIN_XP(targetId)
        SendNotif(source, string.format("%s XP: %d", GetPlayerName(targetId), xp))
    end)
end, false)

-- ==================== Top Admins ====================

ESX.RegisterServerCallback('PNG_ReportSystem:GetTopAdmin', function(source, cb)
    local nameCol = Config_Server.PlayerNameInDB or 'playerName'
    local permCol = Config_Server.NamePermInDB or 'permission_level'
    local query = string.format(
        "SELECT png_admin_xp AS xp, %s AS name, %s AS perm FROM users WHERE %s > 0 ORDER BY png_admin_xp DESC LIMIT 10",
        nameCol, permCol, permCol
    )
    local result = MySQL.Sync.fetchAll(query, {})
    if result and #result > 0 then
        cb({ r = true, data = result })
    else
        cb({ r = false })
    end
end)

-- ==================== سازگاری با بقیه‌ی Unique_AdminPanel ====================
-- exports('GetReports', ...) قبلا تو aduty_reports.lua بود و investigation.lua،
-- admin_tools.lua و nui_panel.lua (منوی F12) بهش وابسته‌ان. اینجا همون export
-- رو نگه داشتیم ولی دیتاش رو زنده از جدول reports میسازیم و به همون شکل قدیمی
-- برمیگردونیم (status: 'open'/'pending' بجای 'pending'/'accept', تا اون سه فایل
-- بدون تغییر درست کار کنن):
--   قدیم 'open'    == جدید 'pending'  (هنوز قبول نشده)
--   قدیم 'pending' == جدید 'accept'   (یه ادمین قبول کرده، در حال بررسی)
-- ریپورت‌های 'close' اصلا تو خروجی نمیان (دقیقا مثل رفتار قبلی که بعد بسته‌شدن پاک میشدن)

exports('GetReports', function()
    local result = MySQL.Sync.fetchAll("SELECT ID, title, sub, identifier, status, created_at FROM reports WHERE status != 'close'", {})
    local out = {}
    if not result then return out end

    for _, r in ipairs(result) do
        local xOwner = ESX.GetPlayerFromIdentifier(r.identifier)
        out[tostring(r.ID)] = {
            owner = {
                id = xOwner and xOwner.source or 0,
                name = xOwner and xOwner.name or r.identifier,
                identifier = r.identifier
            },
            status = (r.status == "pending") and "open" or "pending", -- open=هنوز قبول نشده / pending=قبول شده
            category = r.title,
            Detail = r.sub,
            time = tonumber(r.created_at) or os.time()
        }
    end

    return out
end)

-- ==================== ری‌استارت / پاکسازی ====================

MySQL.ready(function()
    Wait(3000)
    if Config_Server.afterRestartCleanAllReport then
        MySQL.Async.execute("DELETE FROM reports", {}, function()
            print("^5 [PNG_Bot] ^2- Cleanup was successful ... ^0")
        end)
    end
end)
