-- ============================================================================
--  Unique Capture  (Sun-style gameplay)
--  همه‌ی تنظیمات اینجاست. هسته‌ی بازی دقیقاً از منطق sun-capture پیروی می‌کنه:
--  هر زون یه World (routing bucket) جدا داره، پرش با چتر از ارتفاع، دایره‌ی زون،
--  اسپان‌پروتکشن، ریجن‌خودکار، اسکوربورد Q، تایمر F4 و ...
-- ============================================================================
CapConfig = {}

-- ----------------------------------------------------------------------------
--  Webhooks / Logging
-- ----------------------------------------------------------------------------
CapConfig.KillersWebhook = GetConvar('unique_config_config_killerswebhook', '')
CapConfig.GangsWebhook   = GetConvar('unique_config_config_killerswebhook', '')

CapConfig.EnableDetailedLogging = true
CapConfig.LogUsername  = "Unique Capture System"
CapConfig.LogAvatarUrl = ""

CapConfig.Webhooks = { RoundStart = "", RoundEnd = "", ZoneCapture = "", Kills = "", Admin = "" }

-- ----------------------------------------------------------------------------
--  Framework
-- ----------------------------------------------------------------------------
CapConfig.getSharedObjectTrigger = "esx:getSharedObject"
CapConfig.ReviveTrigger          = "esx_ambulancejob:revivex"

-- آنتی‌چیت Unique_AdminPanel: سرور موقع تله‌پورت/اسپان‌پروتکشن برای چند ثانیه
-- بازیکن رو exempt می‌کنه تا اشتباهی کیک/بن نشه. اگه نمی‌خوای false کن.
CapConfig.AntiCheatExempt = { Enabled = true, Resource = 'Unique_AdminPanel' }

-- ----------------------------------------------------------------------------
--  Database
-- ----------------------------------------------------------------------------
CapConfig.GangsTable      = "gangs_data"
CapConfig.GangsNameColumn = "gang_name"
CapConfig.GangsBossColumn = "boss"   -- JSON: یا {x,y,z} یا آرایه‌ی مارکرها [{coord={x,y,z},code=1,...}]


-- مختصات وقتی HQ گنگ پیدا نشد
CapConfig.FallbackHome = { x = 216.672, y = -815.4998, z = 30.63524 }

-- ----------------------------------------------------------------------------
--  Commands
-- ----------------------------------------------------------------------------
CapConfig.CommandPerm            = 10          -- permission_level باید بزرگ‌تر از این باشه
CapConfig.JoinCaptureCommand     = "joinCap"
CapConfig.StartCaptureCommand    = "startCap"
CapConfig.EndCaptureCommand      = "endCap"
CapConfig.EditCaptureCommand     = "editCap"
CapConfig.LeaveCaptureCommand    = "leaveCap"
CapConfig.ReSpawnCaptureCommand  = "reCap"     -- منوی انتخاب زون (وقتی گیر کردی)
CapConfig.HistoryCommand         = "captureHistory"
CapConfig.StatsCommand           = "captureStats"
CapConfig.DieCommand             = "die"       -- مثل sun: ۵ ثانیه پروگرس و خودکشی (برای گیرکردن)

-- ----------------------------------------------------------------------------
--  Gameplay  (مقادیر پیش‌فرض = همون مقادیر sun-capture)
-- ----------------------------------------------------------------------------
CapConfig.DefaultTime         = 60       -- مدت هر راند (دقیقه)
CapConfig.WorldMin            = 300      -- بازه‌ی World هر زون (sun: 300..400)
CapConfig.WorldMax            = 400

CapConfig.ZoneRange           = 350.0    -- قطر دایره‌ی زون (شعاع = نصفش)
CapConfig.DropHeight          = 1500.0   -- ارتفاع پرش
CapConfig.FirstDropRadius     = 495.0    -- فاصله‌ی اولین اسپان از پرچم
CapConfig.SpawnProtectionTime = 6        -- ثانیه
CapConfig.SpawnArmor          = 100

CapConfig.CaptureSeconds      = 10       -- چند ثانیه روی پرچم بمونی
CapConfig.FlagRadius          = 1.5      -- شعاع پرچم (متر)
CapConfig.FlagRadiusTolerance = 2.5      -- تلورانس چک سمت سرور (لگ/سینک)

CapConfig.MaxPlayersInZone    = 40       -- ظرفیت هر زون
CapConfig.MaxGangInZone       = 10       -- ظرفیت هر گنگ در هر زون

CapConfig.Heal = { Delay = 5000, Amount = 1, Interval = 1000 } -- ۵ ثانیه بدون دمیج/شلیک => هر ثانیه ۱ HP
CapConfig.Ammo = 50                      -- حداقل مهمات سلاح انتخابی (sun: ۵۰)
CapConfig.AutoParachute       = true     -- باز شدن خودکار چتر نزدیک زمین (جلوگیری از مرگ بی‌دلیل)
CapConfig.AutoParachuteHeight = 140.0

CapConfig.DieSeconds          = 5

CapConfig.BlipSprite = 378
CapConfig.BlipColor  = 76
CapConfig.BlipScale  = 1.2
CapConfig.BlipRadius = 22.0

-- شرط ورود: نزدیک HQ گنگ باشی (مثل قبل). false => هرجا میشه /joinCap زد
CapConfig.NearGangBoss = { Required = true, Distance = 100.0 }

-- امتیازها
CapConfig.Points = {
    Capture       = 50,   -- امتیاز گنگ برای گرفتن پرچم
    CapturePlayer = 10,   -- gang_points بازیکنی که پرچم رو گرفت (آمار دائمی)
    HoldTick      = 1,    -- امتیاز گنگ برای هر پرچمی که نگه داشته
    HoldInterval  = 15,   -- هر چند ثانیه HoldTick حساب بشه
    HoldPresence  = 15.0, -- بازیکنی که تا این فاصله از پرچمِ گنگش باشه gang_points آماری می‌گیره
}

-- اگه وسط گرفتن پرچم (یا لحظه‌ای که روی پرچم بودی) با دکمه‌ی «Back to Home» بری، تا این مدت نمی‌تونی اون زون رو بگیری
CapConfig.LeaveZonePenaltySeconds = 180

-- ----------------------------------------------------------------------------
--  Zones   (id یکتا + label یکتا + world بین WorldMin و WorldMax)
--  ادمین با /editCap زون اضافه/حذف می‌کنه و تو zones.json ذخیره میشه
-- ----------------------------------------------------------------------------
CapConfig.PersistZones = true
CapConfig.ZonesFileName = "zones.json"

CapConfig.DefaultZones = {
    { id = 1, label = "Bime",         x = -1085.34,  y = -253.7799, z = 37.76331, world = 301 },
    { id = 2, label = "Shekar Gah",   x = -673.389,  y = 5646.052,  z = 30.31661, world = 302 },
    { id = 3, label = "Mineri",       x = 2954.27,   y = 2787.458,  z = 41.49114, world = 303 },
    { id = 4, label = "Sherkat Naft", x = 2751.597,  y = 1551.137,  z = 24.50097, world = 304 },
    { id = 5, label = "Bandar",       x = 959.5748,  y = -3097.387, z = 5.90076,  world = 305 },
    { id = 6, label = "Paleto",       x = 73.2504,   y = 6573.741,  z = 28.4357,  world = 306 },
    { id = 7, label = "Airport",      x = -898.6442, y = -2491.075, z = 14.54905, world = 307 },
}

-- ----------------------------------------------------------------------------
--  Marker colors  (رنگ‌های sun: سبز برای مال گنگ خودت، نارنجی برای بقیه)
-- ----------------------------------------------------------------------------
CapConfig.Colors = {
    Owned = { R = 3,   G = 144, B = 0, Alpha = 100 },
    Enemy = { R = 255, G = 102, B = 0, Alpha = 100 },
}
