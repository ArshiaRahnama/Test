-- ============================================================================
--  Unique WarZone  (Sun-style Battle Royale: FFA / بدون اسکواد)
--  جریان بازی دقیقاً مثل sunset_battleroyal:
--  لابی -> شمارش معکوس -> هواپیما (Titan) -> پرش با E -> لوت جعبه‌ای -> دایره‌ی کوچیک‌شونده
--  -> Blood (جان‌ها: با E ریوایو و دوباره از آسمان) -> گولاگ ۱ به ۱ -> آخرین نفر برنده.
-- ============================================================================
WZConfig = {}
WZConfig.ESX = 'esx:getSharedObject'

-- ----------------------------------------------------------------------------
--  Commands
-- ----------------------------------------------------------------------------
WZConfig.StartCommend      = 'startwarzone'  -- (ادمین) باز کردن لابی
WZConfig.JoinLobbeyCommend = 'wz'            -- ورود به لابی
WZConfig.Startmatchcommend = 'startmatch'    -- (ادمین) /startmatch [blood] [stageMinutes] [SANDY|ISLAND]
WZConfig.closelobbey       = 'closelobbey'   -- (ادمین) بستن لابی
WZConfig.endwarzoneCommend = 'endwarzone'    -- (ادمین) پایان اجباری مچ
WZConfig.exitCommend       = 'exitwz'        -- خروج بازیکن
WZConfig.statsCommend      = 'wzstats'
WZConfig.wztopCommend      = 'wztop'
WZConfig.permission        = 16              -- permission_level >= این عدد = ادمین

WZConfig.StartNotify      = '^1 /wz  ^7 To Join Lobbey '
WZConfig.StartMatchNotify = '^1 Match Started'

-- ----------------------------------------------------------------------------
--  Auto-Queue: وقتی لابی باز و تعداد بازیکن‌ها به minPlayers رسید، مچ خودکار شروع میشه
-- ----------------------------------------------------------------------------
WZConfig.AutoQueue = {
    enabled      = true,
    minPlayers   = 4,
    countdown    = 30,      -- ثانیه
    defaultBlood = 3,       -- جان‌ها (Blood)
    defaultTime  = 5,       -- هر چند دقیقه یه مرحله‌ی کوچیک شدن دایره
    defaultMap   = 'SANDY',
}

-- ----------------------------------------------------------------------------
--  World ها (routing bucket) - لابی / میدان / گولاگ جدا از هم
-- ----------------------------------------------------------------------------
WZConfig.LobbeyWorld = 50
WZConfig.FightWorld  = 51
WZConfig.Gulagworld  = 52

-- ----------------------------------------------------------------------------
--  Locations
-- ----------------------------------------------------------------------------
WZConfig.LobbeyCoord = vector3(-2131.17, 3262.66, 34.81)
WZConfig.LastCoord   = vector3(231.45, -746.1, 34.59)   -- بعد از مچ/حذف اینجا برمی‌گردی

WZConfig.Maps = {
    SANDY  = { center = vector3(401.42, 2985.57, 42.68),   radius = 1000.0 },
    ISLAND = { center = vector3(5265.58, -5428.06, 65.6),  radius = 1000.0 },
}

WZConfig.Gulag = {
    Wait        = vector3(-529.5824, -1713.481, 21.28796),   -- جای انتظار (بدون شلیک)
    SpotA       = vector3(-485.3407, -1731.27, 19.54065),    -- جایگاه دوئل
    SpotB       = vector3(-552.3165, -1684.193, 19.49011),
    Weapon      = 'WEAPON_HEAVYPISTOL',
    Ammo        = 250,
    FreezeA     = 4,      -- ثانیه فریز قبل از شروع (sun: 4 / 3)
    FreezeB     = 3,
    WaitTimeout = 30,     -- اگه حریفی پیدا نشد بعد از این مدت برمیگرده به جنگ
    DuelTimeout = 90,     -- اگه دوئل تموم نشد، کسی که HP بیشتری داره برنده‌ست
}

-- ----------------------------------------------------------------------------
--  Plane (sun: Titan روی ارتفاع ۱۰۰۰ از یه طرف ring به طرف دیگه)
-- ----------------------------------------------------------------------------
WZConfig.airplane       = 'titan'
WZConfig.PlaneAltitude  = 1000.0
WZConfig.PlaneSpeed     = 100.0
WZConfig.PlaneMargin    = 500.0   -- فاصله‌ی شروع هواپیما از لبه‌ی دایره
WZConfig.JumpTimeout    = 90      -- اگه تا این ثانیه نپریدی خودکار می‌پری
WZConfig.StartCountdown = 10      -- شمارش معکوس قبل از هواپیما

-- ----------------------------------------------------------------------------
--  Ring (دایره): مرحله‌ها نسبت به شعاع اولیه؛ بیرونش هر ثانیه Damage از HP کم میشه (sun: 1)
-- ----------------------------------------------------------------------------
WZConfig.Ring = {
    Stages      = { 0.70, 0.45, 0.25, 0.12, 0.05 },
    ShrinkSpeed = 2.0,     -- متر بر ثانیه (sun: 0.2 هر ۱۰۰ms)
    Damage      = 1,       -- HP بر ثانیه بیرون از دایره
}

WZConfig.MaxMatchMinutes = 60   -- سقف زمانی مچ؛ اگه تموم نشد بیشترین کیل برنده‌ست

-- ----------------------------------------------------------------------------
--  Blood / Redeploy
-- ----------------------------------------------------------------------------
WZConfig.RedeployWeapon   = 'WEAPON_SNSPISTOL'
WZConfig.RedeployAmmo     = 250
WZConfig.RedeployHeight   = 1000.0
WZConfig.ReviveTimeout    = 30     -- اگه E نزدی بعد از این ثانیه خودکار ریوایو میشی
WZConfig.ReviveProgressMs = 3000   -- مدت نگه داشتن E (sun: 3 ثانیه)
WZConfig.Parachute        = 'gadget_parachute'
WZConfig.AutoParachute    = true   -- باز شدن خودکار چتر نزدیک زمین
WZConfig.AutoParachuteHeight = 140.0

-- ----------------------------------------------------------------------------
--  Loot (جعبه‌ها)
-- ----------------------------------------------------------------------------
WZConfig.Loot = {
    Count          = 140,
    ArmorChance    = 15,            -- درصد جعبه‌هایی که آرمور میدن
    HealChance     = 10,            -- درصد جعبه‌هایی که بانداژ میدن
    Armors         = { 25, 50, 100 },
    Ammo           = 250,
    StreamDistance = 200.0,         -- از این فاصله جعبه ساخته میشه
    PickupDistance = 2.0,
    ServerPickupTolerance = 10.0,   -- تلورانس چک فاصله سمت سرور (z نامعلومه)
    Weapons = {
        'WEAPON_GUSENBERG', 'WEAPON_MACHINEPISTOL', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL',
        'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTRIFLE',
        'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE',
        'WEAPON_SPECIALCARBINE', 'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2',
        'WEAPON_COMPACTRIFLE', 'WEAPON_COMBATPDW', 'WEAPON_ASSAULTSMG',
    },
    DeadDropMaxWeapons = 6,        -- حداکثر سلاحی که از جسد میفته
}

-- ----------------------------------------------------------------------------
--  Rewards / Webhook / Anticheat
-- ----------------------------------------------------------------------------
WZConfig.WinnerReward = 500000
WZConfig.ShowKillFeed = true

WZConfig.DiscordWebhook     = ""
WZConfig.DiscordWebhookName = "WarZone"

WZConfig.AntiCheatExempt = { Enabled = true, Resource = 'Unique_AdminPanel' }

-- ----------------------------------------------------------------------------
--  Client helpers
-- ----------------------------------------------------------------------------
WZConfig.ReviveTrigger = 'esx_ambulancejob:revivex'
