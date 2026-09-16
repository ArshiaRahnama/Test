--[[
    Unique_GunGame - configuration

    Every tunable value for the script lives here. See README.md for how each
    section is used at runtime.
]]

Config = {}

-- ============================================================
-- Commands & permissions
-- ============================================================

Config.JoinCommand = 'jgg'             -- join the GunGame queue
Config.LeaveCommand = 'ggl'            -- leave the queue
Config.AdminCommand = 'gungame'        -- /gungame stop (admin only)
Config.StatsCommand = 'gungamestats'   -- shows the top-10 leaderboard in chat
Config.PermissionLevel = 9             -- ESX permission_level required for /gungame

-- ============================================================
-- Concurrent arenas
-- ============================================================

Config.PlayersPerArena = 5   -- as soon as this many players are queued, a new arena starts automatically
Config.MaxQueueSize = 30     -- total players allowed across the waiting queue + all running arenas
Config.CountdownTime = 15    -- seconds of countdown once a group of PlayersPerArena is formed
Config.RoundTimeLimit = 300  -- seconds per arena, 0 = no time limit (highest kills wins when it hits 0)

-- Announce (to everyone in that arena) when a player's current life-streak hits one
-- of these numbers. The streak resets to 0 whenever that player dies. Empty table disables it.
Config.KillstreakAnnouncements = { 3, 5, 7 }

-- Reminds everyone on the server how many more players are needed to start an arena,
-- as long as the event is open and the queue isn't already full enough on its own.
-- Seconds between reminders, 0 disables them.
Config.QueueReminderInterval = 30

-- Jobs that cannot queue while on duty
Config.RestrictedJobs = {
    police = true,
    sheriff = true,
    ambulance = true,
    mechanic = true,
    weazel = true,
}

-- Arena location sets. Arenas are isolated from each other with routing buckets,
-- so identical coordinates are safe to reuse (players in different arenas simply
-- never see each other even standing on the same spot). Add more sets here if you
-- want visual variety between concurrent arenas - they'll be assigned round-robin.
Config.Locations = {
    { -- Arena set 1
        Lobby = { x = 3054.77, y = -4709.72, z = 15.26 },
        Arena = { x = 13.87,   y = -2478.61, z = 6.01 },
        Exit  = { x = 217.93,  y = -814.2,   z = 30.65 },
    },
    { -- Arena set 2 (same spot by default - swap in real coordinates for a second look)
        Lobby = { x = 3054.77, y = -4709.72, z = 15.26 },
        Arena = { x = 13.87,   y = -2478.61, z = 6.01 },
        Exit  = { x = 217.93,  y = -814.2,   z = 30.65 },
    },
}

-- ============================================================
-- Weapon progression
-- ============================================================

-- Index 1 is the starting weapon, players level up every KillsPerLevel kills.
Config.Weapons = {
    'weapon_pistol',
    'weapon_combatpistol',
    'weapon_pistol50',
    'weapon_smg',
    'weapon_assaultsmg',
    'weapon_combatpdw',
    'weapon_assaultrifle',
    'weapon_carbinerifle',
    'weapon_bullpuprifle',
    'weapon_specialcarbine',
}
Config.WeaponAmmo = 250
Config.KillsPerLevel = 5                                    -- kills needed to move to the next weapon
Config.KillsToWin = Config.KillsPerLevel * #Config.Weapons  -- reaching the last weapon and getting KillsPerLevel more kills wins an arena
Config.GiveParachuteOnSpawn = true

-- ============================================================
-- Cosmetics
-- ============================================================

-- Outfit applied while a match is running (set to false to keep the player's normal clothes)
Config.ChangeOutfitOnJoin = true
Config.OutfitMale = {
    ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
    ['torso_1'] = 228,  ['torso_2'] = 1,
    ['decals_1'] = 0,   ['decals_2'] = 0,
    ['arms'] = 38,
    ['pants_1'] = 59,   ['pants_2'] = 1,
    ['shoes_1'] = 110,  ['shoes_2'] = 0,
    ['helmet_1'] = -1,  ['helmet_2'] = 0,
    ['glasses_1'] = 0,  ['glasses_2'] = 0,
    ['chain_1'] = 0,    ['chain_2'] = 0,
    ['ears_1'] = 0,     ['ears_2'] = 0,
    ['mask_1'] = 0,     ['mask_2'] = 2,
    ['bproof_1'] = 0,   ['bproof_2'] = 0,
}
Config.OutfitFemale = {
    ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
    ['torso_1'] = 238,  ['torso_2'] = 1,
    ['decals_1'] = 0,   ['decals_2'] = 0,
    ['arms'] = 33,
    ['pants_1'] = 61,   ['pants_2'] = 1,
    ['shoes_1'] = 25,   ['shoes_2'] = 0,
    ['helmet_1'] = -1,  ['helmet_2'] = 0,
    ['glasses_1'] = 0,  ['glasses_2'] = 0,
    ['chain_1'] = 0,    ['chain_2'] = 0,
    ['ears_1'] = 0,     ['ears_2'] = 0,
    ['mask_1'] = 0,     ['mask_2'] = 0,
    ['bproof_1'] = 0,   ['bproof_2'] = 0,
}

-- ============================================================
-- Optional integrations
-- ============================================================

-- Persistent leaderboard (requires the 'oxmysql' resource to be started before this one).
-- Leave false if your server doesn't run oxmysql - everything else still works fine.
Config.UseDatabase = false

-- Post a message to a Discord channel whenever an arena is won. Leave empty to disable.
Config.DiscordWebhook = ''
