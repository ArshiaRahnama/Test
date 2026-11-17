-- ============================================================================
--  Unique GunGame  (Sun-style: paintball "gungame" mode)
--  هر کیل = سلاح بعدی؛ با چاقو کشته بشی یه مرحله پایین میای؛ ۶۰۰ ثانیه؛ ریسپاون ۳ ثانیه.
-- ============================================================================
GGConfig = {}

GGConfig.JoinCommand  = 'jgg'            -- ورود
GGConfig.LeaveCommand = 'ggl'            -- خروج
GGConfig.AdminCommand = 'gungame'        -- /gungame start | stop (ادمین)
GGConfig.StatsCommand = 'gungamestats'   -- ۱۰ نفر برتر
GGConfig.PermissionLevel = 9             -- permission_level ادمین

-- ----------------------------------------------------------------------------
--  قوانین مچ (مقادیر sun)
-- ----------------------------------------------------------------------------
GGConfig.MinPlayers  = 2                 -- sun: teamSize.min = 2  (۱ = تست تکی)
GGConfig.MaxPlayers  = 10                -- sun: teamSize.max = 10
GGConfig.StartDelay  = 15                -- بعد از رسیدن به MinPlayers تا این ثانیه صبر میکنه تا بقیه برسن
GGConfig.WarmupTime  = 5                 -- sun: warmupTime
GGConfig.MatchTime   = 600               -- sun: matchTime (ثانیه)
GGConfig.RespawnDelay = 3                -- sun: respawnDelay
GGConfig.SpawnHP     = 200               -- sun: spawnHpArmor
GGConfig.SpawnArmor  = 25
GGConfig.SpawnInvincibility = 2          -- sun: spawnInvincibility (ثانیه)
GGConfig.KnifeDemote = true              -- sun: با چاقو کشته بشی یه لول میای پایین
GGConfig.KnifeWeapon = 'WEAPON_KNIFE'
GGConfig.WeaponAmmo  = 999               -- sun: gungameWeaponSwap => 999

GGConfig.RestrictedJobs = { police = true, sheriff = true, ambulance = true, mechanic = true, weazel = true }

-- ----------------------------------------------------------------------------
--  Progression (دقیقاً لیست sun)
-- ----------------------------------------------------------------------------
GGConfig.Progression = {
    'WEAPON_SNSPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_CERAMICPISTOL', 'WEAPON_COMBATPISTOL',
    'WEAPON_PISTOLXM3', 'WEAPON_PISTOL_MK2', 'WEAPON_SNSPISTOL_MK2', 'WEAPON_APPISTOL', 'WEAPON_MINISMG',
    'WEAPON_MACHINEPISTOL', 'WEAPON_MICROSMG', 'WEAPON_COMBATPDW', 'WEAPON_SMG', 'WEAPON_SMG_MK2',
    'WEAPON_ASSAULTSMG', 'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2', 'WEAPON_COMBATSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_AUTOSHOTGUN',
    'WEAPON_COMPACTRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_BULLPUPRIFLE', 'WEAPON_ADVANCEDRIFLE',
    'WEAPON_TACTICALRIFLE', 'WEAPON_MILITARYRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_SPECIALCARBINE',
    'WEAPON_HEAVYRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_SPECIALCARBINE_MK2',
    'WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_GUSENBERG', 'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_COMBATMG_MK2',
    'WEAPON_MINIGUN', 'WEAPON_SNIPERRIFLE', 'WEAPON_MARKSMANRIFLE', 'WEAPON_MARKSMANRIFLE_MK2',
    'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2', 'WEAPON_PRECISIONRIFLE', 'WEAPON_HEAVYPISTOL',
    'WEAPON_PISTOL50', 'WEAPON_GADGETPISTOL', 'WEAPON_COMPACTLAUNCHER', 'WEAPON_REVOLVER',
    'WEAPON_NAVYREVOLVER', 'WEAPON_REVOLVER_MK2', 'WEAPON_DOUBLEACTION', 'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_DBSHOTGUN', 'WEAPON_MARKSMANPISTOL', 'WEAPON_MUSKET',
}

-- ----------------------------------------------------------------------------
--  Arena (مختصات از نسخه‌ی قبلی خودت)
-- ----------------------------------------------------------------------------
GGConfig.Lobby  = { x = 3054.77, y = -4709.72, z = 15.26 }
GGConfig.Center = { x = 13.87, y = -2478.61, z = 6.01 }
GGConfig.ArenaPoints = {
    { x = 13.87, y = -2478.61, z = 6.01 },
    { x = 45.0,  y = -2460.0,  z = 6.01 },
    { x = -20.0, y = -2495.0,  z = 6.01 },
    { x = 35.0,  y = -2515.0,  z = 6.01 },
}
GGConfig.Exit = { x = 217.93, y = -814.2, z = 30.65 }
GGConfig.ArenaLeashRadius = 120.0        -- دورتر از Center برگردونده میشه؛ 0 = خاموش

-- World ها (routing bucket)
GGConfig.LobbyWorld = 60
GGConfig.MatchWorld = 61

GGConfig.ScoreboardTopCount = 5
GGConfig.UseDatabase = true              -- جدول unique_gungame_stats (هاب ازش میخونه)
GGConfig.DiscordWebhook = ''
GGConfig.ReviveEvent = 'esx_ambulancejob:revivex'
GGConfig.AntiCheatExempt = { Enabled = true, Resource = 'Unique_AdminPanel' }
