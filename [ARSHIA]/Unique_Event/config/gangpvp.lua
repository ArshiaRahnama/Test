-- ============================================================================
--  Unique Gang PvP  (Sun-style: gangprop PVP zone)
--  /pvp نزدیک HQ گنگ => ورود به World جدا (PvP آزاد)، /pvp دوباره => خروج.
--  کیل => SC => خرید اسلحه (فروشگاه چرخشی) و ماشین PvP.
-- ============================================================================
GPConfig = {}
GPConfig.ESX = 'esx:getSharedObject'

GPConfig.Command        = 'pvp'
GPConfig.CarCommand     = 'pvpcar'
GPConfig.World          = 97            -- routing bucket دنیای PvP (sun: 97)
GPConfig.MinGrade       = 2             -- حداقل grade گنگ (sun: grade > 1)
GPConfig.HQDistance     = 50.0          -- برای ورود باید نزدیک HQ گنگ باشی (sun: 50)
GPConfig.CommandCooldown = 30           -- ثانیه؛ ضد اسپم join/leave (sun: 30)
GPConfig.LeaveLock      = 10            -- بعد از کیل/مرگ تا این ثانیه نمیشه خارج شد (ضد فرار از درگیری)
GPConfig.SafeRadius     = 100.0         -- نزدیک پایگاه همه‌ی گنگ‌ها شلیک ممنوع (sun: 100)
GPConfig.RespawnSeconds = 5             -- بعد از مرگ، ریسپاون سر HQ
GPConfig.RewardSC       = 1             -- هر کیل چند SC
GPConfig.SameVictimCooldown = 60        -- کیل دوباره‌ی همون نفر تو این مدت SC نداره (ضد فارم)
GPConfig.FriendlyKillSC = false         -- کیل هم‌گنگی SC بده؟

GPConfig.FallbackHome   = { x = 216.672, y = -815.4998, z = 30.63524 }
GPConfig.ReviveTrigger  = 'esx_ambulancejob:revivex'
GPConfig.AntiCheatExempt = { Enabled = true, Resource = 'Unique_AdminPanel' }
GPConfig.WeaponAmmo     = 250

-- ----------------------------------------------------------------------------
--  Inventory (Unique_inventory روی essentialmode)
--  SC یه آیتم واقعی اینونتوریه. اسلحه‌های PvP سریالشون با پیشوند PV شروع میشه؛
--  با خروج از PvP پاک میشن مگه اینکه تو کارواش (با بلک‌مانی) به اسلحه‌ی واقعی تبدیل بشن.
-- ----------------------------------------------------------------------------
GPConfig.SC = { item = 'sc', label = 'SC', weight = 0.01 }
GPConfig.WeaponSerialPrefix = 'PV'

GPConfig.JoinLockSeconds   = 60    -- بعد از ورود تا این مدت باید نزدیک HQ بمونی (قفل ماندگاره؛ relog ردش نمیکنه) - 0 = خاموش
GPConfig.CprSeconds        = 10    -- مدت CPR هم‌گنگی
GPConfig.CprDistance       = 2.0
GPConfig.AutoRespawnSeconds = 90   -- اگه کسی CPR نکرد و E نزدی، خودکار سر HQ ریسپاون میشی

-- ----------------------------------------------------------------------------
--  Shop: هر openMinutes دقیقه openCount تا از شاپ‌ها (با یکی از setهای اسلحه) باز میشن
-- ----------------------------------------------------------------------------
GPConfig.Shop = {
    openMinutes = 90,
    openCount   = 4,
    buyDistance = 3.0,
    serverTolerance = 5.0,
    blip = { sprite = 110, color = 1, scale = 0.9 },
    shops = {
        vector3(659.65, 532.51, 130.25),   vector3(216.02, -22.48, 69.71),    vector3(198.67, -928.85, 30.69),
        vector3(1543.91, -2151.81, 77.53), vector3(1080.5, -692.2, 57.79),    vector3(-52.09, -1784.88, 27.85),
        vector3(-1702.16, -1090.76, 13.15), vector3(-530.22, -229.36, 36.7),  vector3(-1034.02, -1071.3, 4.1),
        vector3(-1120.53, -2841.5, 13.95),
    },
    sets = {
        {
            { name = 'weapon_carbinerifle',     price = 5,  count = 7 }, { name = 'weapon_advancedrifle',    price = 5,  count = 6 },
            { name = 'weapon_pumpshotgun_mk2',  price = 10, count = 6 }, { name = 'weapon_carbinerifle_mk2', price = 12, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 }, { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {
            { name = 'weapon_bullpuprifle',     price = 7,  count = 7 }, { name = 'weapon_assaultshotgun',   price = 7,  count = 6 },
            { name = 'weapon_specialcarbine',   price = 7,  count = 6 }, { name = 'weapon_bullpuprifle_mk2', price = 10, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 }, { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {
            { name = 'weapon_pumpshotgun',      price = 7,  count = 7 }, { name = 'weapon_specialcarbine_mk2', price = 12, count = 6 },
            { name = 'weapon_bullpupshotgun',   price = 7,  count = 6 }, { name = 'weapon_compactrifle',     price = 12, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 }, { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {
            { name = 'weapon_combatpdw',        price = 5,  count = 7 }, { name = 'weapon_assaultrifle_mk2', price = 12, count = 6 },
            { name = 'weapon_gusenberg',        price = 8,  count = 6 }, { name = 'weapon_sawnoffshotgun',   price = 7,  count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 }, { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
    },
}

-- ----------------------------------------------------------------------------
--  ماشین‌های PvP (با SC)  -  اسم مدل‌ها رو با ماشین‌های سرور خودت عوض کن
-- ----------------------------------------------------------------------------
GPConfig.Cars = {
    { model = 'sanchez',   label = 'Sanchez',   price = 1 },
    { model = 'mesa3',     label = 'Mesa',      price = 2 },
    { model = 'technical', label = 'Technical', price = 3 },
    { model = 'kuruma2',   label = 'Kuruma Armored', price = 3 },
    { model = 'insurgent', label = 'Insurgent', price = 5 },
}

-- ----------------------------------------------------------------------------
--  کارواش: اسلحه‌ی PV رو با بلک‌مانی به اسلحه‌ی واقعی تبدیل میکنه (باید seconds ثانیه بمونی)
-- ----------------------------------------------------------------------------
GPConfig.Wash = {
    seconds = 30,
    account = 'black_money',
    distance = 2.5,
    serverTolerance = 5.0,
    points = {
        vector3(-1132.18, 4924.06, 219.71), vector3(-14.27, 6566.36, 31.91),   vector3(1505.37, 6326.61, 24.08),
        vector3(2489.38, 4961.79, 44.77),   vector3(464.33, 3565.72, 33.24),   vector3(-1090.58, 2715.06, 19.08),
        vector3(-49.82, 1892.68, 195.36),   vector3(2474.66, 1574.6, 32.74),   vector3(2601.37, 2803.5, 33.82),
        vector3(-2230.16, 3480.74, 30.17),
    },
    weapons = {
        { name = 'weapon_carbinerifle', price = 220000 },       { name = 'weapon_assaultrifle', price = 220000 },
        { name = 'weapon_advancedrifle', price = 220000 },      { name = 'weapon_combatpdw', price = 220000 },
        { name = 'weapon_bullpuprifle', price = 240000 },       { name = 'weapon_gusenberg', price = 250000 },
        { name = 'weapon_assaultshotgun', price = 240000 },     { name = 'weapon_sawnoffshotgun', price = 240000 },
        { name = 'weapon_pumpshotgun', price = 240000 },        { name = 'weapon_bullpupshotgun', price = 240000 },
        { name = 'weapon_specialcarbine', price = 240000 },     { name = 'weapon_pumpshotgun_mk2', price = 300000 },
        { name = 'weapon_bullpuprifle_mk2', price = 300000 },   { name = 'weapon_compactrifle', price = 320000 },
        { name = 'weapon_specialcarbine_mk2', price = 320000 }, { name = 'weapon_assaultrifle_mk2', price = 320000 },
        { name = 'weapon_carbinerifle_mk2', price = 320000 },   { name = 'weapon_microsmg', price = 400000 },
        { name = 'weapon_doubleaction', price = 400000 },
    },
}
