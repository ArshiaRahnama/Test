--[[ ===========================================================================
    Unique RP - Report System | server/report_function.lua
    arshiahub.ir

    توابع پایه. مهم‌ترین تغییر نسبت به نسخه قبلی:

    1) دیگه گلوبال `ESX` رو ست یا nil نمی‌کنیم.
       تو Unique_AdminPanel هشت‌تا فایل سرور هرکدوم `ESX = nil` مینوشتن و بعد
       دوباره میگرفتنش. چون گلوبال‌های Lua تو یک ریسورس مشترکن، هرکدوم از اون
       فایل‌ها که بعد از این فایل لود میشد، ESX رو دوباره nil میکرد؛ و اگه
       es_extended هنوز استارت نشده بود (توجه: es_extended اصلا تو
       dependencies نبود) اون TriggerEvent به هیچ‌جا نمی‌خورد و ESX برای همیشه
       nil می‌موند. نتیجه: لحظه‌ی ثبت ریپورت، تو UpdateAllReport این خط
       `ESX.GetPlayerFromId(...)` می‌خورد به:
           attempt to index a nil value (global 'ESX')
       این دقیقا همون «nil» موقع ریپورت دادنه.
       الان به‌جاش تابع Rep.ESX() داریم که تنبل (lazy) و مقاومه.

    2) ESX.GetPlayerFromIdentifier روی ESX قدیمی/ESS وجود نداره؛ فallback داریم.
=========================================================================== ]]

Rep = Rep or {}

-- ============================================================= ESX SAFE ===

local _esx = nil

--- گرفتن آبجکت ESX بدون دست‌زدن به گلوبال ESX.
function Rep.ESX()
    if _esx then return _esx end

    -- اگه یکی از فایل‌های دیگه‌ی ریسورس قبلا گرفتتش، همون رو قرض می‌گیریم
    if type(ESX) == 'table' and ESX.GetPlayerFromId then
        _esx = ESX
        return _esx
    end

    if Config_Shared.ESX_Version == 2 then
        local ok, obj = pcall(function()
            return exports[Config_Shared.ESX_Export]:getSharedObject()
        end)
        if ok and type(obj) == 'table' then _esx = obj end
    end

    if not _esx then
        TriggerEvent(Config_Shared.ESX_Event, function(obj)
            if type(obj) == 'table' then _esx = obj end
        end)
    end

    return _esx
end

--- تلاش مکرر برای گرفتن ESX در بوت ریسورس (بدون بلاک کردن).
CreateThread(function()
    local tries = 0
    while not Rep.ESX() and tries < 200 do
        tries = tries + 1
        Wait(250)
    end
    if not Rep.ESX() then
        dprint("^1[Unique Report]^0 ESX پیدا نشد. مطمئن شو es_extended قبل از Unique_AdminPanel استارت میشه.")
    end
end)

function Rep.Ready()
    return Rep.ESX() ~= nil
end

function Rep.GetPlayer(src)
    local ESXo = Rep.ESX()
    if not ESXo then return nil end
    local ok, p = pcall(ESXo.GetPlayerFromId, tonumber(src))
    if ok then return p end
    return nil
end

--- ESX.GetPlayerFromIdentifier روی ESX 1.x / ESS وجود نداره. فallback دستی.
function Rep.GetPlayerByIdentifier(identifier)
    if not identifier or identifier == '' then return nil end
    local ESXo = Rep.ESX()
    if not ESXo then return nil end

    if type(ESXo.GetPlayerFromIdentifier) == 'function' then
        local ok, p = pcall(ESXo.GetPlayerFromIdentifier, identifier)
        if ok and p then return p end
    end

    for _, src in ipairs(Rep.GetPlayerSources()) do
        local xP = Rep.GetPlayer(src)
        if xP and xP.identifier == identifier then return xP end
    end
    return nil
end

function Rep.GetPlayerSources()
    local ESXo = Rep.ESX()
    if ESXo and type(ESXo.GetPlayers) == 'function' then
        local ok, list = pcall(ESXo.GetPlayers)
        if ok and type(list) == 'table' then return list end
    end
    -- فallback نیتیو
    local out = {}
    for _, id in ipairs(GetPlayers()) do out[#out + 1] = tonumber(id) end
    return out
end

function Rep.GetIdentifier(src)
    local xP = Rep.GetPlayer(src)
    if xP and xP.identifier then return xP.identifier end
    local ids = GetPlayerIdentifiers(src)
    return ids and ids[1] or nil
end

function Rep.GetPermission(src)
    local xP = Rep.GetPlayer(src)
    if not xP then return -1 end
    return tonumber(xP.permission_level) or -1
end

function Rep.GetName(src)
    local xP = Rep.GetPlayer(src)
    if xP and xP.name then return xP.name end
    return GetPlayerName(src) or ("ID " .. tostring(src))
end

function Rep.GetRankName(perm)
    return Config_Shared.Rank[tonumber(perm) or -1] or 'Player'
end

-- ============================================================ دسترسی ===

--- چک دسترسی همزمان (بدون callback). برای جاهایی که لازم داریم فوری بدونیم.
function Rep.HasAccess(src, requiredLevel)
    return Rep.GetPermission(src) >= (tonumber(requiredLevel) or 0)
end

--- نسخه‌ی callback‌دار (سازگار با کد قدیمی `serverAceess`).
function Rep.Access(src, requiredLevel, cb)
    cb(Rep.HasAccess(src, requiredLevel))
end

-- alias برای سازگاری عقب‌رو با نسخه‌ی قبلی
function serverAceess(source, requiredLevel, callback)
    Rep.Access(source, requiredLevel, callback)
end

-- ============================================================ نوتیف ===

function Rep.Notify(playerId, message, kind)
    playerId = tonumber(playerId)
    if not playerId or playerId <= 0 or not message then return end

    local mode = kind or Config_Server.alertToNewMessage

    if mode == "notif" or mode == "both" then
        TriggerClientEvent('esx:showNotification', playerId, message)
    end
    if mode ~= "notif" then
        TriggerClientEvent('chat:addMessage', playerId, {
            color = { 232, 163, 61 },
            multiline = true,
            args = { ReportLan.prefix, message }
        })
    end
end

-- alias قدیمی
function SendNotif(playerId, message)
    Rep.Notify(playerId, message)
end

function Rep.NotifyAllAdmins(message, minLevel)
    minLevel = minLevel or 1
    for _, src in ipairs(Rep.GetPlayerSources()) do
        if Rep.GetPermission(src) >= minLevel then
            Rep.Notify(src, message, Config_Server.alertToNewReport)
        end
    end
end

function Rep.PushToAdmins(eventName, ...)
    for _, src in ipairs(Rep.GetPlayerSources()) do
        if Rep.GetPermission(src) >= Config_Shared.accessToAdminCommand then
            TriggerClientEvent(eventName, src, ...)
        end
    end
end

--- رفرش لیست ریپورت برای همه‌ی ادمین‌های آنلاین
function Rep.RefreshAdminLists()
    Rep.PushToAdmins('Unique_Report:refreshList')
end

-- aliasهای قدیمی
function UpdateAllReport() Rep.RefreshAdminLists() end
function SendNotifToAllAdmin() Rep.NotifyAllAdmins(ReportLan.newReprot) end

-- ======================================================== اعتبارسنجی ===

--- حذف کاراکترهای کنترلی + کوتاه کردن به طول مجاز.
--- هیچ escape ای اینجا نمیزنیم؛ UI خودش موقع نمایش escape میکنه
--- (تا متن اصلی سالم تو دیتابیس بمونه).
function Rep.Clean(str, maxLen)
    if type(str) ~= 'string' then return nil end
    str = str:gsub('[\0\1-\8\11\12\14-\31\127]', '')  -- کنترلی‌ها (به جز \n \r \t)
    str = str:gsub('^%s+', ''):gsub('%s+$', '')
    if maxLen and #str > maxLen then
        -- بریدن بر اساس مرز کاراکتر UTF-8، نه بایت.
        -- برش بایتی وسط یک حرف فارسی، رشته‌ی نامعتبر میسازه و بعداً
        -- json.encode روی بلاک چت میترکه.
        local cut = maxLen
        while cut > 0 do
            local b = str:byte(cut + 1)
            if not b or b < 128 or b > 191 then break end
            cut = cut - 1
        end
        str = str:sub(1, cut)
    end
    if str == '' then return nil end
    return str
end

--- تعداد کاراکتر واقعی UTF-8 (فارسی هر حرف 2 بایته؛ #str جواب غلط میده)
function Rep.Len(str)
    if type(str) ~= 'string' then return 0 end
    local _, count = str:gsub('[^\128-\191]', '')
    return count
end

-- ============================================================ کول‌داون ===

local cooldowns = {}   -- [identifier] = { create = os.time(), chat = os.time() }

function Rep.CheckCooldown(identifier, kind, seconds)
    if not identifier or not seconds or seconds <= 0 then return true, 0 end
    cooldowns[identifier] = cooldowns[identifier] or {}
    local last = cooldowns[identifier][kind] or 0
    local elapsed = os.time() - last
    if elapsed < seconds then
        return false, seconds - elapsed
    end
    return true, 0
end

function Rep.TouchCooldown(identifier, kind)
    if not identifier then return end
    cooldowns[identifier] = cooldowns[identifier] or {}
    cooldowns[identifier][kind] = os.time()
end

AddEventHandler('playerDropped', function()
    local src = source
    local id = Rep.GetIdentifier(src)
    if id then cooldowns[id] = nil end
end)

-- ============================================================== XP ===

local XPCOL = nil
local function xpCol()
    XPCOL = XPCOL or (Config_Server.AdminXPColumn or 'unique_admin_xp')
    return XPCOL
end

function Rep.GetXP(identifier)
    if not identifier then return 0 end
    local rows = MySQL.Sync.fetchAll(
        ("SELECT `%s` AS xp FROM users WHERE identifier = @id"):format(xpCol()),
        { ['@id'] = identifier })
    if rows and rows[1] then return tonumber(rows[1].xp) or 0 end
    return 0
end

function Rep.SetXP(identifier, value)
    if not identifier then return end
    if value < 0 then value = 0 end
    MySQL.Async.execute(
        ("UPDATE users SET `%s` = @xp WHERE identifier = @id"):format(xpCol()),
        { ['@id'] = identifier, ['@xp'] = math.floor(value) })
end

function Rep.AddXP(identifier, amount, reason)
    amount = tonumber(amount) or 0
    if amount == 0 then return end
    Rep.SetXP(identifier, Rep.GetXP(identifier) + amount)

    -- لجر: تا این تیکه از قبل نبود، «چقدر XP این ماه گرفتی» اصلاً قابل
    -- محاسبه نبود چون فقط یک عدد جمع‌شونده بدون تاریخ ذخیره می‌شد.
    MySQL.Async.execute(
        "INSERT INTO admin_xp_log (identifier, amount, reason, created_at) VALUES (@id, @amt, @reason, @now)",
        { ['@id'] = identifier, ['@amt'] = amount, ['@reason'] = reason or 'manual', ['@now'] = os.time() })
end

-- exports سازگار با نسخه قبلی (با source کار میکنن، نه identifier)
function UNIQUE_GET_ADMIN_XP(playerId)
    local id = Rep.GetIdentifier(playerId); if not id then return 0 end
    return Rep.GetXP(id)
end
function UNIQUE_ADD_ADMIN_XP(playerId, amount)
    local id = Rep.GetIdentifier(playerId); if not id then return false end
    Rep.AddXP(id, amount, 'command:addxp'); return true
end
function UNIQUE_REMOVE_ADMIN_XP(playerId, amount)
    local id = Rep.GetIdentifier(playerId); if not id then return false end
    Rep.AddXP(id, -(tonumber(amount) or 0), 'command:delxp'); return true
end
function UNIQUE_CLEAN_ADMIN_XP(playerId)
    local id = Rep.GetIdentifier(playerId); if not id then return false end
    Rep.SetXP(id, 0); return true
end

-- aliasهای PNG_* برای اینکه اسکریپت‌های قدیمی سرور نشکنن
PNG_GET_ADMIN_XP    = UNIQUE_GET_ADMIN_XP
PNG_ADD_ADMIN_XP    = UNIQUE_ADD_ADMIN_XP
PNG_REMOVE_ADMIN_XP = UNIQUE_REMOVE_ADMIN_XP
PNG_CLEAN_ADMIN_XP  = UNIQUE_CLEAN_ADMIN_XP

-- ============================================================ چت ریپورت ===

function Rep.GetChat(reportId)
    local rows = MySQL.Sync.fetchAll("SELECT chat FROM reports WHERE ID = @id",
        { ['@id'] = reportId })
    if rows and rows[1] and rows[1].chat then
        local ok, decoded = pcall(json.decode, rows[1].chat)
        if ok and type(decoded) == 'table' then
            table.sort(decoded, function(a, b) return (a.msgid or 0) < (b.msgid or 0) end)
            return decoded
        end
    end
    return {}
end

function Rep.AddChat(reportId, who, text, authorName)
    text = Rep.Clean(text, Config_Shared.Limits.chatMax * 4)
    if not text then return false end

    local chat = Rep.GetChat(reportId)
    local maxId = 0
    for _, m in ipairs(chat) do
        if (m.msgid or 0) > maxId then maxId = m.msgid end
    end

    chat[#chat + 1] = {
        msgid = maxId + 1,
        user  = who,                 -- "user" | "admin" | "system"
        name  = authorName,
        text  = text,
        at    = os.time(),
    }

    MySQL.Async.execute("UPDATE reports SET chat = @chat WHERE ID = @id", {
        ['@chat'] = json.encode(chat),
        ['@id']   = reportId,
    })
    return true
end

-- aliasهای قدیمی
function GetChatMessages(id) return Rep.GetChat(id) end
function SaveChatMessage(id, user, text) return Rep.AddChat(id, user, text) end

-- ========================================================== دیتای ریپورت ===

function Rep.GetReport(reportId)
    reportId = tonumber(reportId)
    if not reportId then return nil end
    local rows = MySQL.Sync.fetchAll("SELECT * FROM reports WHERE ID = @id",
        { ['@id'] = reportId })
    return rows and rows[1] or nil
end

function GetReportById(id) return Rep.GetReport(id) end

-- ============================================================= آواتار ===

local avatarCache = {}

function Rep.GetAvatar(identifier, cb)
    local fallback = "./img/self.png"
    if not identifier or type(identifier) ~= 'string' or not identifier:find('steam:') then
        return cb(fallback)
    end
    if avatarCache[identifier] then return cb(avatarCache[identifier]) end

    local key = Config_Server.SteamAPIKey
    if not key or key == "" then return cb(fallback) end

    local steamID = identifier:gsub("steam:", "")
    -- https (نسخه قبلی http ساده میزد)
    local url = ("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s")
        :format(key, steamID)

    PerformHttpRequest(url, function(status, body)
        if status ~= 200 or not body then return cb(fallback) end
        local ok, data = pcall(json.decode, body)
        local url2 = ok and data and data.response and data.response.players
            and data.response.players[1] and data.response.players[1].avatarfull
        if url2 then
            avatarCache[identifier] = url2
            return cb(url2)
        end
        cb(fallback)
    end, 'GET', '', {})
end

function GetSteamAvatarByIdentifier(id, cb) Rep.GetAvatar(id, cb) end

-- ================================================ دیسکورد (Unique Bot) ===

local function discordSend(embed)
    local d = Config_Server.Discord
    if not d.enabled or not d.webhook or d.webhook == "" then return end

    local payload = {
        username   = d.botName or Config_Shared.BotName,
        avatar_url = (d.avatar ~= "" and d.avatar) or nil,
        embeds     = { embed },
    }

    PerformHttpRequest(d.webhook, function() end, 'POST',
        json.encode(payload), { ['Content-Type'] = 'application/json' })
end

local function embedBase(title, color, fields, description)
    return {
        title       = title,
        description = description,
        color       = color,
        fields      = fields,
        footer      = {
            text = ("%s • %s"):format(Config_Shared.ServerName, Config_Shared.ServerSite)
        },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end

function Rep.LogCreate(report, playerName, playerId, identifier)
    local d = Config_Server.Discord
    if not d.logCreate then return end
    local cat = Config_Shared.GetCategory(report.category)
    local pr  = Config_Shared.Priorities[tonumber(report.priority) or 1]

    discordSend(embedBase(("ریپورت جدید  #%s"):format(report.ID), d.color.create, {
        { name = "عنوان",    value = report.title or "-",                    inline = false },
        { name = "موضوع",    value = (cat and cat.label) or report.category or "-", inline = true },
        { name = "اولویت",   value = (pr and pr.label) or "-",               inline = true },
        { name = "بازیکن",   value = ("%s (ID %s)"):format(playerName or "?", playerId or "?"), inline = true },
        { name = "شناسه",    value = ("`%s`"):format(identifier or "?"),     inline = false },
    }, report.sub))
end

function Rep.LogAccept(reportId, adminName, adminPerm, waitedSeconds)
    local d = Config_Server.Discord
    if not d.logAccept then return end
    discordSend(embedBase(("ریپورت #%s قبول شد"):format(reportId), d.color.accept, {
        { name = "ادمین",         value = ("%s (%s)"):format(adminName, Rep.GetRankName(adminPerm)), inline = true },
        { name = "زمان انتظار",   value = Rep.HumanTime(waitedSeconds),  inline = true },
    }))
end

function Rep.LogClose(reportId, adminName, totalSeconds, messageCount)
    local d = Config_Server.Discord
    if not d.logClose then return end
    discordSend(embedBase(("ریپورت #%s بسته شد"):format(reportId), d.color.close, {
        { name = "ادمین",        value = adminName or "-",                inline = true },
        { name = "مدت رسیدگی",   value = Rep.HumanTime(totalSeconds),     inline = true },
        { name = "تعداد پیام",   value = tostring(messageCount or 0),     inline = true },
    }))
end

function Rep.LogSLA(reportId, minutes, title)
    local d = Config_Server.Discord
    if not d.logSLA then return end
    discordSend(embedBase(("ریپورت #%s بی‌پاسخ مونده"):format(reportId), d.color.sla, {
        { name = "مدت انتظار", value = ("%d دقیقه"):format(minutes), inline = true },
        { name = "عنوان",      value = title or "-",                 inline = false },
    }, "هیچ ادمینی هنوز این ریپورت رو قبول نکرده."))
end

function Rep.LogChat(reportId, who, name, text)
    local d = Config_Server.Discord
    if not d.logChat then return end
    discordSend(embedBase(("پیام در ریپورت #%s"):format(reportId), d.color.create, {
        { name = who == 'admin' and "ادمین" or "بازیکن", value = name or "-", inline = true },
    }, text))
end

-- ============================================================= کمکی ===

function Rep.HumanTime(seconds)
    seconds = tonumber(seconds) or 0
    if seconds < 60 then return ("%d ثانیه"):format(seconds) end
    if seconds < 3600 then return ("%d دقیقه"):format(math.floor(seconds / 60)) end
    if seconds < 86400 then
        return ("%d ساعت و %d دقیقه"):format(math.floor(seconds / 3600), math.floor((seconds % 3600) / 60))
    end
    return ("%d روز"):format(math.floor(seconds / 86400))
end

-- ===================================================== هوش پنل (گسترش) ===

--- ریسک‌اسکورِ یک شناسه، از سیستمِ موجودِ server/risk_score.lua.
--- pcall شده چون این فایل قبل از risk_score.lua لود میشه؛ GetRiskScoreForIdentifier
--- تا وقتی اون فایل هم لود بشه global نیست - این تابع فقط زمانی که یک
--- ادمین واقعاً یک تیکت رو باز میکنه صدا زده میشه (خیلی بعد از لود کامل
--- ریسورس)، ولی pcall برای موقعی که کسی بدون risk_score.lua این ریسورس رو
--- کپی کرده باشه هم امن نگهش میداره.
function Rep.RiskFor(identifier, cb)
    if not identifier or type(GetRiskScoreForIdentifier) ~= 'function' then
        return cb(nil)
    end
    local ok = pcall(GetRiskScoreForIdentifier, identifier, cb)
    if not ok then cb(nil) end
end

--- آیا این شناسه الان یک فلگ فعال داره؟ (server/investigation.lua's money
--- spike، server/collusion_detection.lua، server/spawn_pattern.lua - هر
--- سه‌تا رو یک جدول مشترک `admin_player_flags` مینویسن). برای لیستِ صف
--- (ممکنه ده‌ها ردیف باشه) به‌جای صدا زدن ریسک‌اسکورِ کامل (۳ کوئری
--- زنجیره‌ای برای هرکدوم) فقط یک کوئریِ دسته‌ای ارزون میزنیم.
function Rep.FlaggedIdentifiers(identifiers, cb)
    local list = {}
    local seen = {}
    for _, id in ipairs(identifiers) do
        if id and id ~= '' and not seen[id] then seen[id] = true; list[#list + 1] = id end
    end
    if #list == 0 then return cb({}) end

    local placeholders, params = {}, {}
    for i, id in ipairs(list) do
        placeholders[i] = '@id' .. i
        params['@id' .. i] = id
    end

    MySQL.Async.fetchAll(
        ("SELECT identifier FROM admin_player_flags WHERE identifier IN (%s)"):format(table.concat(placeholders, ',')),
        params,
        function(rows)
            local out = {}
            for _, r in ipairs(rows or {}) do out[r.identifier] = true end
            cb(out)
        end)
end

--- چند تا ریپورتِ دیگه علیه همین «هدف» تو N روز اخیر ثبت شده (برای بجِ
--- «سابقه‌ی تکرار» و بالابردنِ خودکارِ اولویت).
function Rep.TargetReportCount(targetIdentifier, excludeReportId, days, cb)
    if not targetIdentifier then return cb(0) end
    local cutoff = os.time() - ((tonumber(days) or Config_Server.TargetLookback or 7) * 86400)
    MySQL.Async.fetchScalar(
        "SELECT COUNT(*) FROM reports WHERE target_identifier = @tid AND created_at >= @cut AND ID != @exclude",
        { ['@tid'] = targetIdentifier, ['@cut'] = cutoff, ['@exclude'] = tonumber(excludeReportId) or 0 },
        function(n) cb(tonumber(n) or 0) end)
end

--- یادداشتِ بین‌ادمینیِ یک تیکت (بازیکن هیچ‌وقت اینو نمی‌بینه).
function Rep.SetAdminNote(reportId, note)
    note = Rep.Clean(note, 2000)  -- nil اگه خالی باشه - یعنی پاک کردنِ یادداشت هم با متنِ خالی ممکنه
    MySQL.Async.execute("UPDATE reports SET admin_note = @note WHERE ID = @id",
        { ['@note'] = note, ['@id'] = tonumber(reportId) })
    return note
end

-- ========================================================= استریکِ XP ===
-- چند روزِ پشت‌سرهم که این ادمین حداقل یک ریپورت بسته و هیچ امتیازی زیر ۳
-- نگرفته. روزهایی که هیچی نبسته نه استریک رو میشکنن نه جلو میبرن (روزهای
-- خنثی) - فقط روزی که ریپورتِ امتیازدارِ زیر ۳ داشته باشه استریک صفر میشه.

function Rep.RecomputeStreak(adminIdentifier, cb)
    if not adminIdentifier then return cb(0, false) end

    -- هر روزی که این ادمین حداقل یک ریپورتِ امتیازدار بسته، به‌همراه
    -- کمترین امتیازِ اون روز.
    MySQL.Async.fetchAll([[
        SELECT DATE(FROM_UNIXTIME(closed_at)) AS d, MIN(rating) AS min_rating
        FROM reports
        WHERE admin = @a AND status IN ('close','archive') AND rating > 0 AND closed_at > 0
        GROUP BY DATE(FROM_UNIXTIME(closed_at))
        ORDER BY d DESC
        LIMIT 60
    ]], { ['@a'] = adminIdentifier }, function(rows)
        rows = rows or {}

        -- از امروز به عقب بشمار؛ اولین شکاف یا اولین روزِ min_rating<3 استریک رو تموم میکنه.
        local streak = 0
        local cursor = os.date('*t')
        cursor = os.time({ year = cursor.year, month = cursor.month, day = cursor.day })

        local byDate = {}
        for _, r in ipairs(rows) do byDate[r.d] = tonumber(r.min_rating) end

        for i = 0, 59 do
            local dayStr = os.date('%Y-%m-%d', cursor - (i * 86400))
            local minRating = byDate[dayStr]
            if minRating == nil then
                -- روز خنثی: نه شکست نه ادامه. فقط برای «امروز» (i==0) اجازه
                -- میدیم بدون شکستن استریک رد بشیم (شیفت هنوز تموم نشده)،
                -- برای روزهای قبل‌تر یعنی استریک همین‌جا تمومه.
                if i == 0 then goto continue end
                break
            elseif minRating < 3 then
                break
            else
                streak = streak + 1
            end
            ::continue::
        end

        MySQL.Async.fetchAll("SELECT last_bonus_streak FROM admin_streak_state WHERE identifier = @id",
            { ['@id'] = adminIdentifier }, function(stateRows)
                local lastBonus = (stateRows and stateRows[1] and tonumber(stateRows[1].last_bonus_streak)) or 0
                local every = (Config_Server.Streak and Config_Server.Streak.every) or 3

                local milestone = streak > 0 and streak % every == 0 and streak or nil
                local earnedBonus = milestone and milestone > lastBonus

                MySQL.Async.execute([[
                    INSERT INTO admin_streak_state (identifier, current_streak, last_bonus_streak, updated_at)
                    VALUES (@id, @cur, @lb, @now)
                    ON DUPLICATE KEY UPDATE current_streak = @cur, last_bonus_streak = @lb, updated_at = @now
                ]], {
                    ['@id']  = adminIdentifier,
                    ['@cur'] = streak,
                    ['@lb']  = earnedBonus and milestone or lastBonus,
                    ['@now'] = os.time(),
                })

                cb(streak, earnedBonus)
            end)
    end)
end
