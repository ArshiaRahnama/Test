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
Config.AdminCommand = 'gungame'        -- /gungame start | stop (admin only)
Config.StatsCommand = 'gungamestats'   -- shows the top-10 leaderboard in chat
Config.PermissionLevel = 9             -- ESX permission_level required for /gungame

-- ============================================================
-- Concurrent arenas
-- ============================================================

Config.PlayersPerArena = 5   -- as soon as this many players are queued, a new arena starts automatically
Config.MaxQueueSize = 30     -- total players allowed across the waiting queue + all running arenas
Config.CountdownTime = 15    -- seconds of countdown once a group of PlayersPerArena is formed
Config.RoundTimeLimit = 300  -- seconds per arena, 0 = no time limit (highest kills wins when it hits 0)

-- Testing convenience: when true, only 1 player is needed to form an arena, so you
-- can test the whole flow solo on a local server. Turn this off before going live.
Config.TestMode = false

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
--
-- ArenaPoints is a list of spawn points inside that arena; a random one is picked
-- every time a player spawns or respawns, so the same corner doesn't get camped.
-- Center is used as the reference point for Config.ArenaLeashRadius and doesn't need
-- to be one of the ArenaPoints - the middle of the play space is usually right.
Config.Locations = {
    { -- Arena set 1
        Lobby = { x = 3054.77, y = -4709.72, z = 15.26 },
        Center = { x = 13.87, y = -2478.61, z = 6.01 },
        ArenaPoints = {
            { x = 13.87, y = -2478.61, z = 6.01 },
            { x = 45.0,  y = -2460.0,  z = 6.01 },
            { x = -20.0, y = -2495.0,  z = 6.01 },
            { x = 35.0,  y = -2515.0,  z = 6.01 },
        },
        Exit = { x = 217.93, y = -814.2, z = 30.65 },
    },
    { -- Arena set 2 (same spot by default - swap in real coordinates for a second look)
        Lobby = { x = 3054.77, y = -4709.72, z = 15.26 },
        Center = { x = 13.87, y = -2478.61, z = 6.01 },
        ArenaPoints = {
            { x = 13.87, y = -2478.61, z = 6.01 },
            { x = 45.0,  y = -2460.0,  z = 6.01 },
            { x = -20.0, y = -2495.0,  z = 6.01 },
            { x = 35.0,  y = -2515.0,  z = 6.01 },
        },
        Exit = { x = 217.93, y = -814.2, z = 30.65 },
    },
}

-- If a player strays further than this from their arena's Center, they're pulled
-- back automatically - stops someone just running away from the fight. 0 disables it.
Config.ArenaLeashRadius = 120.0

-- ============================================================
-- Weapon progression
-- ============================================================

-- Index 1 is the starting weapon, players level up every KillsPerLevel kills (the
-- classic GunGame rule is 1 kill per weapon). The ladder ends on a melee weapon for
-- a forced knife-fight finish once someone is one kill from winning.
Config.Weapons = {
    'weapon_pistol',
    'weapon_combatpistol',
    'weapon_appistol',
    'weapon_pistol50',
    'weapon_microsmg',
    'weapon_smg',
    'weapon_smg_mk2',
    'weapon_assaultsmg',
    'weapon_combatpdw',
    'weapon_pumpshotgun',
    'weapon_sawnoffshotgun',
    'weapon_bullpupshotgun',
    'weapon_assaultshotgun',
    'weapon_assaultrifle',
    'weapon_carbinerifle',
    'weapon_advancedrifle',
    'weapon_specialcarbine',
    'weapon_bullpuprifle',
    'weapon_compactrifle',
    'weapon_mg',
    'weapon_combatmg',
    'weapon_gusenberg',
    'weapon_marksmanrifle',
    'weapon_sniperrifle',
    'weapon_heavysniper',
    'weapon_grenadelauncher',
    'weapon_rpg',
    'weapon_minigun',
    'weapon_stungun',    -- comic relief right before the finish
    'weapon_battleaxe',  -- final weapon: melee only, forces a knife-fight for the win
}
Config.WeaponAmmo = 250
Config.KillsPerLevel = 1                                    -- classic GunGame: one kill moves you to the next weapon
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
-- Winner celebration / MVP screen
-- ============================================================

Config.WinnerCameraSeconds = 5   -- how long everyone in the arena sees the MVP screen before being teleported out
Config.WinnerFireworks = true    -- fireworks particle effect at the winner's position, visible to the whole arena

-- Calling cards shown on the MVP screen (Call of Duty style). Drop your own images
-- into html/callingcards/ and list the filenames here - a random one is shown each
-- win. Left empty by default: the MVP screen falls back to a plain CSS badge, no
-- images required to use the feature out of the box.
Config.CallingCards = {}

-- ============================================================
-- Sound effects
-- ============================================================

-- Drop your own .ogg/.mp3 files into html/sounds/ and reference them here as
-- 'sounds/filename.ogg'. Leave any of these nil to skip that sound entirely -
-- none are required for the script to work.
Config.Sounds = {
    Kill = nil,        -- played for everyone in the arena on every kill
    MatchStart = nil,  -- played when a player is dropped into a fresh arena
    MatchWin = nil,    -- played when an arena is won
}
Config.SoundVolume = 0.5

-- ============================================================
-- Player blips
-- ============================================================

-- Shows a blip on the minimap for every other player currently in your arena.
Config.ShowPlayerBlips = true
Config.PlayerBlipSprite = 1
Config.PlayerBlipColor = 1

-- ============================================================
-- Physical join point (optional, in addition to /jgg)
-- ============================================================

-- An NPC standing in the world players can walk up to and press E on to join,
-- instead of only the chat command. Off by default since Coords needs to be set
-- to a real spot on your map first.
Config.JoinPed = {
    Enabled = false,
    Model = 's_m_y_swat_01',
    Coords = { x = 0.0, y = 0.0, z = 0.0, heading = 0.0 },
    Label = 'Join GunGame',
    InteractDistance = 2.0,
    MarkerDistance = 10.0,
}

-- ============================================================
-- Optional integrations
-- ============================================================

-- Persistent leaderboard (requires the 'oxmysql' resource to be started before this one).
-- Leave false if your server doesn't run oxmysql - everything else still works fine.
Config.UseDatabase = false

-- Post a message to a Discord channel whenever an arena is won. Leave empty to disable.
Config.DiscordWebhook = ''

-- Announce (to everyone in that arena) when a player's current life-streak hits one
-- of these numbers. The streak resets to 0 whenever that player dies. Empty table disables it.
Config.KillstreakAnnouncements = { 3, 5, 7 }

-- Reminds everyone on the server how many more players are needed to start an arena,
-- as long as the event is open and the queue isn't already full enough on its own.
-- Seconds between reminders, 0 disables them.
Config.QueueReminderInterval = 30

-- How many top rows the scoreboard shows. If a player isn't in the top N, their own
-- row is appended after it so they can always see their own standing.
Config.ScoreboardTopCount = 5

-- Client event triggered while a player is dead, asking your server's medical/EMS
-- system to revive them. The script waits on ESX.GetPlayerData().IsDead to know when
-- they're actually back up, exactly like a normal ESX ambulance-job revive flow.
-- Change this if your server's revive event has a different name.
Config.ReviveEvent = 'esx_ambulancejob:revive'
