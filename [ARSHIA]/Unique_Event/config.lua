--[[
    Unique_Event - shared configuration (loaded on BOTH client and server).
    Never put secrets here (webhooks, payouts) - use sv_config.lua for those.
    Every value in this file is actually used by the code - nothing here is decorative.
]]

Config = {}

-- ============================================================
-- Framework hooks
-- ============================================================
Config.Framework = {
    SharedObject    = 'esx:getSharedObject',
    ReviveTrigger   = 'esx_ambulancejob:revivex',  -- client event that revives the local player
    FreezeEvent     = 'es_admin:freezePlayer',      -- client event: freeze/unfreeze the local player
    StatusSet       = 'esx_status:set',             -- client event used to refill hunger/thirst
}

-- ============================================================
-- Hub (/uevent)
-- ============================================================
Config.Hub = {
    -- NOTE: plain "event" is already used on this server by Unique_AdminPanel's
    -- RegisterCommand("event", ...) (its ad-hoc "admin sets a TP point" tool - a
    -- completely different, older feature). Registering the same name here would
    -- silently override or be overridden by it depending on resource start order,
    -- so the hub uses "uevent" instead. "events" is kept as a secondary alias.
    Command = 'uevent',
    Aliases = { 'events' },
    FixCommand = 'eventfix',    -- releases a stuck NUI cursor / HUD if something goes wrong
}

Config.Enable = { Capture = true, GunGame = true, WarZone = true }

-- Minimum ESX permission_level (>=) needed for admin actions of each event.
Config.Perm = { Capture = 11, GunGame = 9, WarZone = 16 }

-- Jobs that can't join GunGame/WarZone while on duty (prevents griefing while "working").
Config.RestrictedJobs = { police = true, sheriff = true, ambulance = true, mechanic = true }
Config.RestrictedFor  = { capture = false, gungame = true, warzone = true }

-- ============================================================
-- Routing buckets (each event lives in its own isolated world)
-- ============================================================
Config.Buckets = {
    Capture      = 50,
    GunGameStart = 100,   -- arena N uses bucket 100+N
    WarZoneLobby = 200,
    WarZoneMatch = 201,
    WarZoneGulag = 202,
}

-- ============================================================
-- UI
-- ============================================================
Config.UI = {
    Brand = 'UNIQUE RP  ·  arshiahub.ir',
    -- Gang logos in the Capture boards. nui://<resource>/img/logos/<logo>.png
    GangLogoResource = 'gangmenu',
}

-- ============================================================
-- CAPTURE
-- ============================================================
Config.Capture = {
    GangsTable = 'gangs_data', GangsNameColumn = 'gang_name', GangsBossColumn = 'boss', GangsLogoColumn = 'logo',
    DefaultGangLogo = 'defaultlogo',

    RequireGang = true,
    RequireGangBoss = true,
    GangBossJoinRadius = 100.0,
    DefaultReturnCoord = vector3(216.672, -815.4998, 30.63524),

    DefaultTime = 60,                -- minutes
    ZoneRadius = 150.0,              -- radius of the play area around a zone point
    CaptureRadius = 5.0,             -- how close to the zone point you must stand to capture
    TimeToCaptureZone = 10,          -- seconds standing alone (no enemy) in the point to take it
    PointInterval = 15,              -- every N seconds the owner gang scores 1 point
    OutOfZoneDamagePerTick = 8,      -- HP lost per 2s while outside the zone radius

    UsePersonalWeapons = true,
    DefaultArmor = 100,

    ZoneBlip = { Sprite = 84, Color = 1, Scale = 1.0 },
    CapturePointBlip = { Sprite = 84, Color = 5, Scale = 0.85 },

    DefaultZones = {
        { name = 'Bime',         x = -1085.34,  y = -253.7799, z = 37.76331 },
        { name = 'Shekar Gah',   x = -673.389,  y = 5646.052,  z = 30.31661 },
        { name = 'Mineri',       x = 2954.27,   y = 2787.458,  z = 41.49114 },
        { name = 'Sherkat Naft', x = 2751.597,  y = 1551.137,  z = 24.50097 },
        { name = 'Bandar',       x = 959.5748,  y = -3097.387, z = 5.90076 },
        { name = 'Paleto',       x = 73.2504,   y = 6573.741,  z = 28.4357 },
        { name = 'Airport',      x = -898.6442, y = -2491.075, z = 14.54905 },
    },
    PersistZones = true,
    ZonesFileName = 'zones.json',

    AllTimeScoreWeights = { Kills = 2, GangPoints = 1, DeathPenalty = 1 },
    RankThresholds = {
        { Name = 'Bronze', Min = 0 }, { Name = 'Silver', Min = 50 }, { Name = 'Gold', Min = 150 }, { Name = 'Legend', Min = 400 },
    },

    -- After a gang loses a zone, that SAME gang can't immediately recapture it - gives the
    -- new owner a real window to defend it instead of an instant back-and-forth flip.
    -- Other gangs are unaffected and can still contest/capture it normally.
    ZoneRecaptureCooldown = 180,
    SeasonAutoResetDays = 30,
}

-- ============================================================
-- GUNGAME
-- ============================================================
Config.GunGame = {
    PlayersPerArena = 5,
    MaxQueueSize = 30,
    CountdownTime = 15,
    RoundTimeLimit = 300,     -- seconds, 0 = no limit
    ArenaLeashRadius = 120.0, -- 0 disables the "return to arena" push

    Lobby  = vector3(3054.77, -4709.72, 15.26),
    Center = vector3(13.87, -2478.61, 6.01),
    Exit   = vector3(217.93, -814.2, 30.65),

    Weapons = {
        'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_PUMPSHOTGUN',
        'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_ADVANCEDRIFLE',
        'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER',
        'WEAPON_RPG', 'WEAPON_MINIGUN', 'WEAPON_KNIFE',
    },
    WeaponAmmo = 250,
    GiveParachuteOnSpawn = true,
    WinnerCameraSeconds = 6,

    Sounds = { Kill = 'kill.ogg', MatchStart = 'start.ogg', MatchWin = 'win.ogg' },
}

-- ============================================================
-- WARZONE
-- ============================================================
Config.WarZone = {
    MinPlayers = 4,
    MaxPlayers = 40,
    LobbyCountdown = 30,
    SquadSize = 4,

    LobbyCoord = vector3(-2131.17, 3262.66, 34.81),
    MapZone = vector3(401.42, 2985.57, 42.68),
    ExitCoord = vector3(231.45, -746.1, 34.59),

    StartRadius = 1400.0,
    MinRadius = 60.0,
    ShrinkEveryMs = 45000,
    ShrinkSteps = 6,
    ZoneDamagePerTick = 4,

    Downed = { enabled = true, bleedoutMs = 45000, reviveDistance = 3.0, reviveMs = 6000, reviveHealthPct = 50 },

    GulagZone = vector3(-529.5824, -1713.481, 21.28796),
    GulagRadius = 50.0,
    GulagRoundSeconds = 60,
    GulagSpawns = {
        vector3(-497.1033, -1682.756, 19.28796), vector3(-485.3407, -1731.27, 19.54065),
        vector3(-552.3165, -1684.193, 19.49011), vector3(-540.7516, -1691.024, 19.87769),
        vector3(-506.5846, -1689.89, 19.77661), vector3(-537.1517, -1701.481, 19.60803),
    },

    LootSpawns = {
        vector3(533.84, 2372.82, 48.37), vector3(562.16, 2736.25, 42.06), vector3(525.84, 3577.49, 32.8),
        vector3(545.71, 3365.43, 99.99), vector3(22.43, 3321.2, 38.49), vector3(-133.74, 2850.10, 49.86),
        vector3(-180.31, 2390.35, 94.06), vector3(944.756, 3094.286, 41.26013), vector3(115.05, 2696.94, 52.59),
        vector3(442.9, 2996.13, 40.66), vector3(687.12, 3152.63, 42.03), vector3(203.02, 3253.04, 41.7),
        vector3(587.67, 2786.67, 42.19), vector3(383.21, 2893.97, 43.55), vector3(389.19, 2980.56, 40.91),
        vector3(354.0, 3088.44, 48.76),
    },
    LootWeapons = {
        'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_PUMPSHOTGUN',
        'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_ADVANCEDRIFLE',
        'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_MG', 'WEAPON_COMBATMG',
    },
    LootAmmo = { min = 60, max = 180 },
    CrateCash = { min = 100, max = 400 },
    KillCashReward = 500,
    WinCashReward = 5000,

    KillstreakUAVKills = 3,
    Killcam = { enabled = true, durationMs = 3500 },

    Uniform = {
        male   = { ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 12, ['torso_2'] = 2, ['arms'] = 1, ['pants_1'] = 60, ['pants_2'] = 4, ['shoes_1'] = 27, ['shoes_2'] = 0, ['helmet_1'] = 54, ['helmet_2'] = 0 },
        female = { ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['torso_1'] = 12, ['torso_2'] = 2, ['arms'] = 1, ['pants_1'] = 60, ['pants_2'] = 4, ['shoes_1'] = 27, ['shoes_2'] = 0, ['helmet_1'] = 54, ['helmet_2'] = 0 },
    },
}
