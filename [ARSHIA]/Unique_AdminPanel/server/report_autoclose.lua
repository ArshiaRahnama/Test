--[[ ===========================================================================
    Unique RP - Report System | server/report_autoclose.lua
    arshiahub.ir

    Fix for: reports that sit in 'pending' (nobody accepted them) just stay
    open forever. report_main.lua's own SLA loop (shared/report_server_config
    .lua's slaWarnMinutes, default 10) already WARNS admins once, but never
    closes the report or leaves a durable trail once everyone's back offline.

    This file is additive - it does not edit report_main.lua/report_function
    .lua/report_server_config.lua. It only ADDS new Config_Server fields (with
    `or` so nothing breaks if a server owner already set them) and a new
    Rep.LogAutoClose, exactly the way ticket_main.lua stays additive toward
    the report system. Must load AFTER shared/report_server_config.lua
    (extends Config_Server) and server/report_function.lua (uses Rep, calls
    Config_Server.Discord) - see the fxmanifest.lua load-order comment.

    What it does, every Config_Server.autoCloseCheckSeconds:
      1. Finds reports stuck in status = 'pending' for longer than
         Config_Server.autoCloseMinutes (default 30).
      2. Closes them (status = 'close', admin_name = 'System (Auto-Close)',
         admin_note explains why) - so they stop cluttering the open queue.
      3. Notifies EVERY on-duty admin that report #N was auto-closed.
      4. Sends a SEPARATE, more pointed notification to admins at or above
         Config_Server.autoCloseNotifyLevel (default 3 - "senior") asking
         them to look into why nobody picked it up in time.
      5. Writes a permanent row to `report_autoclose_log` (sql/report_auto
         close.sql) and a Discord embed if Config_Server.Discord.logSLA is on
         - both survive even if no admin was online when it happened, so
         senior ranks can review it whenever they next log in.
=========================================================================== ]]

-- --------------------------------------------------------------- کانفیگ ---
Config_Server.autoCloseMinutes      = Config_Server.autoCloseMinutes      or 30  -- بعد این‌همه دقیقه بدون قبول‌شدن، خودکار بسته میشه
Config_Server.autoCloseCheckSeconds = Config_Server.autoCloseCheckSeconds or 60  -- هر چند ثانیه چک کنه
Config_Server.autoCloseNotifyLevel  = Config_Server.autoCloseNotifyLevel  or 3   -- فقط رنک‌های >= این عدد نوتیفِ پیگیری جدا میگیرن

-- ------------------------------------------------------------ Discord log --
local function autoCloseEmbed(reportId, minutes, title, category)
    local d = Config_Server.Discord
    return {
        title       = ('⛔ ریپورت #%s بدون پاسخ خودکار بسته شد'):format(reportId),
        description = 'هیچ ادمینی طی مهلت تعیین‌شده این ریپورت را قبول نکرد.',
        color       = d.color and d.color.sla or 15548997,
        fields = {
            { name = 'عنوان / دسته', value = (title or '-') .. ' / ' .. (category or '-'), inline = false },
            { name = 'مدت انتظار',   value = ('%d دقیقه'):format(minutes), inline = true },
        },
        footer = { text = d.siteUrl or '' },
    }
end

function Rep.LogAutoClose(reportId, minutes, title, category)
    local d = Config_Server.Discord
    if not d or not d.enabled or not d.logSLA or not d.webhook or d.webhook == '' then return end
    PerformHttpRequest(d.webhook, function() end, 'POST',
        json.encode({ username = d.botName, avatar_url = d.avatar, embeds = { autoCloseEmbed(reportId, minutes, title, category) } }),
        { ['Content-Type'] = 'application/json' })
end

-- ============================================================= main loop ===
CreateThread(function()
    while true do
        Wait(Config_Server.autoCloseCheckSeconds * 1000)

        if Rep.Ready() and Config_Server.autoCloseMinutes > 0 then
            local cutoff = os.time() - (Config_Server.autoCloseMinutes * 60)

            local rows = MySQL.Sync.fetchAll(
                "SELECT ID, title, category, identifier, created_at FROM reports WHERE status = 'pending' AND created_at < @cut",
                { ['@cut'] = cutoff })

            for _, r in ipairs(rows or {}) do
                local minutesOpen = math.floor((os.time() - (tonumber(r.created_at) or os.time())) / 60)
                local closedAt = os.time()

                MySQL.Async.execute([[
                    UPDATE reports SET status = 'close', closed_at = @closed,
                           admin = NULL, admin_name = 'System (Auto-Close)',
                           admin_note = @note
                    WHERE ID = @id
                ]], {
                    ['@id']     = r.ID,
                    ['@closed'] = closedAt,
                    ['@note']   = ('بسته شدن خودکار: هیچ ادمینی طی %d دقیقه این ریپورت را قبول نکرد.'):format(minutesOpen),
                })

                -- ۱) اطلاع عمومی به همه‌ی ادمین‌های آنلاین که این ریپورت خودکار بسته شد
                Rep.NotifyAllAdmins(
                    ('⛔ ریپورت #%s به دلیل عدم پیگیری بعد از %d دقیقه، خودکار بسته شد.'):format(r.ID, minutesOpen), 1)

                -- ۲) اطلاع جداگانه و واضح‌تر فقط برای رنک‌های بالا، تا بررسی کنن چرا پیگیری نشده
                Rep.NotifyAllAdmins(
                    ('🔺 توجه رنک بالا: ریپورت #%s (%s) توسط هیچ ادمینی طی %d دقیقه بررسی نشد و خودکار بسته شد - لطفاً پیگیری کنید.')
                        :format(r.ID, r.category or r.title or '-', minutesOpen),
                    Config_Server.autoCloseNotifyLevel)

                -- ۳) لاگ دائمی تو دیتابیس - حتی اگه هیچ ادمینی آنلاین نبود، بازم قابل پیگیریه
                MySQL.Async.execute([[
                    INSERT INTO report_autoclose_log
                        (report_id, title, category, reporter_identifier, minutes_open, closed_at)
                    VALUES (@id, @title, @cat, @ident, @mins, @closed)
                ]], {
                    ['@id']     = r.ID,
                    ['@title']  = r.title,
                    ['@cat']    = r.category,
                    ['@ident']  = r.identifier,
                    ['@mins']   = minutesOpen,
                    ['@closed'] = closedAt,
                })

                Rep.LogAutoClose(r.ID, minutesOpen, r.title, r.category)
                Rep.RefreshAdminLists()   -- لیست ریپورت‌های باز رو تو پنل هر ادمینی که الان بازه، رفرش کن

                dprint(('^1[Unique Report]^0 ریپورت #%s به دلیل عدم پیگیری بعد از %d دقیقه خودکار بسته شد.')
                    :format(r.ID, minutesOpen))
            end
        end
    end
end)

dprint('^2[Unique_AdminPanel]^0 Report auto-close guard loaded (server/report_autoclose.lua) - ' ..
    ('timeout: %d minutes, senior-notify level: %d.'):format(Config_Server.autoCloseMinutes or 30, Config_Server.autoCloseNotifyLevel or 3))
