--[[ ===========================================================================
    Unique RP - Report System | shared/report_server_config.lua  (server only)
=========================================================================== ]]

Config_Server = {}

-- ------------------------------------------------------------- ستون‌های DB ---
-- اگه دیتابیست اسم ستون فرق داره، فقط همینجا عوضش کن.
Config_Server.PlayerNameInDB = 'playerName'
Config_Server.NamePermInDB   = 'permission_level'
Config_Server.AdminXPColumn  = 'unique_admin_xp'   -- قبلا png_admin_xp بود (SQL خودش مایگریت میکنه)

-- ------------------------------------------------------------------- XP ---
Config_Server.ActiveFeedBack = true
-- ایندکس = امتیازی که کاربر داده (1 تا 5)
Config_Server.XPFeedBack     = { [1] = 0, [2] = 5, [3] = 15, [4] = 30, [5] = 50 }
Config_Server.XpAfterClose   = 10   -- وقتی ActiveFeedBack=false یا کاربر امتیاز نداد

-- ------------------------------------------------------------- نگه‌داری ---
-- مهم: دیگه پیش‌فرض true نیست. نسخه قبلی هر ری‌استارت کل تاریخچه ریپورت‌ها
-- (و درنتیجه آمار زمان پاسخ‌گویی و رضایت) رو پاک میکرد.
Config_Server.afterRestartCleanAllReport = false
Config_Server.autoArchiveAfterDays       = 30   -- ریپورت‌های بسته‌شده قدیمی‌تر از این خودکار بایگانی میشن (0 = خاموش)

-- --------------------------------------------------------------- ضداسپم ---
Config_Server.createCooldown  = 60     -- ثانیه بین دو ریپورت هر پلیر
Config_Server.chatCooldown    = 1      -- ثانیه بین دو پیام چت
Config_Server.maxOpenPerPlayer = 1     -- چندتا ریپورت باز همزمان

-- ------------------------------------------------------------------ SLA ---
-- اگه ریپورتی این مدت (دقیقه) بدون قبول شدن بمونه، به ادمین‌ها و دیسکورد هشدار میره
Config_Server.slaWarnMinutes  = 10
Config_Server.slaCheckSeconds = 120

-- ------------------------------------------------------------- هشدارها ---
Config_Server.alertToNewReport  = "chat"   -- chat | notif | both | ""
Config_Server.alertToNewMessage = "chat"
Config_Server.alertSound        = true     -- صدای نوتیف داخل پنل

-- --------------------------------------------------- دیسکورد (Unique Bot) ---
Config_Server.Discord = {
    enabled     = false,  -- بعد از گذاشتن وبهوک true کن
    webhook     = "",     -- https://discord.com/api/webhooks/....
    botName     = "Unique Bot",
    avatar      = "",     -- URL آواتار بات (اختیاری)
    siteUrl     = "https://arshiahub.ir",
    color = {
        create  = 3447003,   -- آبی
        accept  = 15258703,  -- کهربایی
        close   = 5763719,   -- سبز
        sla     = 15548997,  -- قرمز
    },
    logCreate = true,
    logAccept = true,
    logClose  = true,
    logSLA    = true,
    logChat   = false,   -- لاگ کردن تک‌تک پیام‌های چت (پرحجمه)
}

-- -- ------------------------------------------------------------- اسپکتیت ---
Config_Server.SpectateEvent = "esx_spectate:spectatexxxx"

-- ------------------------------------------------------------- Steam API ---
Config_Server.SteamAPIKey = ""   -- خالی بذاری، آواتار پیش‌فرض استفاده میشه

-- ------------------------------------------------------------- دستورات ---
Config_Server.CommandNameAddXP   = 'addxp'
Config_Server.CommandNameDelXP   = 'delxp'
Config_Server.CommandNameCleanXP = 'cleanxp'
Config_Server.CommandNameShowXP  = 'showxp'

-- ============================================================ گسترش‌ها ===

-- --------------------------------------------------------- هوش پنل ---
-- وقتی «هدف» (بازیکن گزارش‌شده) مشخص باشه، این‌ها روی جزئیات تیکت نشون
-- داده میشه: ریسک‌اسکور (server/risk_score.lua)، تعداد ریپورتِ دیگه علیه
-- همون بازیکن تو N روز اخیر، و اگه اون تعداد از حد گذشت، اولویت تیکتِ
-- تازه‌ثبت‌شده خودکار میره رو بیشترین سطح.
Config_Server.TargetLookback         = 7     -- روز
Config_Server.AutoPriorityBumpAt     = 3     -- >= این تعداد ریپورتِ دیگه = اولویت اجباری بره رو حداکثر
Config_Server.VoiceCheckRange        = 20.0  -- متر (پیش‌فرض همون چیزیه که investigation.lua برای رنج صدا حدس زده)

-- آستانه‌های رنگِ بج ریسک (0 تا 100، از server/risk_score.lua)
Config_Server.RiskBadge = {
    low  = 30,  -- زیر این = خنثی (خاکستری)
    med  = 60,  -- بین low و med = زرد، بالای med = قرمز
}

-- --------------------------------------------------------- پاسخ آماده ---
-- جابه‌جا شد به shared/report_shared_config.lua (Config_Shared.CannedReplies)
-- چون این فایل فقط تو server_scripts هست و کلاینت اصلاً نمی‌بینتش - ولی
-- دکمه‌های پاسخِ آماده باید تو NUI کلاینت رندر بشن.

-- --------------------------------------------------------- استریک XP ---
-- هر چند روزِ پشت‌سرهمِ «بدون امتیازِ زیر ۳» یک بونس XP یک‌باره میده.
Config_Server.Streak = {
    every  = 3,    -- هر ۳ روز پشت‌سرهم
    amount = 20,   -- این‌قدر XP بونس
}

