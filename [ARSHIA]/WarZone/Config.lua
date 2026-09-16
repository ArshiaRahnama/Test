Config = {}
Config.ESX = 'esx:getSharedObject'
--- Commend --- 
Config.StartCommend = 'startwarzone'
Config.JoinLobbeyCommend = 'wz'
Config.Startmatchcommend = "startmatch" 
--- other Commend ---
Config.exitCommend = "exitwz"
Config.closelobbey = "closelobbey"
Config.endwarzoneCommend = 'endwarzone'
--- Auto-Queue ---
Config.AutoQueue = {
    enabled = true,
    minPlayers = 4,      -- lobby auto-starts once this many players have joined
    countdown = 30,      -- seconds of countdown before auto-start
    defaultBlood = 3,
    defaultTime = 8,      -- minutes per zone shrink
    defaultMap = 'SANDY', -- 'SANDY' or 'ISLAND'
    defaultTeam = 2,      -- squad size
}
--- Discord Webhook ---
Config.DiscordWebhook = "" -- put your Discord webhook URL here (leave "" to disable)
Config.DiscordWebhookName = "WarZone"
--- Leaderboard / Season ---
Config.Leaderboard = {
    seasonRewardTop1 = 2000000, -- money paid to #1 on season reset
    top = 10,                   -- how many rows /wztop shows
}
--- Progressive Zone Damage ---
Config.ZoneDamage = {
    min = 5,   -- damage/sec when the circle has just started shrinking
    max = 25,  -- damage/sec once the circle has fully closed
}
--- Party System ---
Config.partyCommend = 'wzparty' -- /wzparty invite <id> | /wzparty accept | /wzparty leave | /wzparty list
--- Personal Stats ---
Config.statsCommend = 'wzstats'
--- Match Replay ---
Config.lastmatchCommend = 'wzlastmatch'
--- Menu (icon_menu) ---
Config.menuCommend = 'warzone' -- opens a click-through menu for party/stats/last match
--- Anti-Cheat (server-side speed/teleport monitor) ---
Config.AntiCheat = {
    enabled = true,
    checkIntervalMs = 3000,   -- how often to sample each player's position
    maxSpeed = 15.0,          -- meters/sec allowed on foot before flagging (sprint ~7-8, so this has headroom)
    action = 'alert',         -- 'alert' = just tell admins, 'kick' = also kick the flagged player
    dropGraceMs = 45000,      -- no speed checks for this long after a plane drop starts (covers flight + parachute)
}
--- Killstreak Rewards ---
Config.Killstreak = {
    uavKills = 3,     -- kills in a row (no death) for a free UAV
    airdropKills = 5, -- kills in a row for a free loadout airdrop
}
--- Weapon Tiers ---
-- Every weapon picked up from loot/airdrops rolls one of these. Higher
-- tiers just give more ammo for now (a real damage multiplier would need
-- per-shot damage hooking, which risks desyncing hit detection).
Config.WeaponTiers = {
    { name = 'Common',    color = '~g~', chance = 50, ammoMult = 1.0 },
    { name = 'Uncommon',  color = '~b~', chance = 30, ammoMult = 1.5 },
    { name = 'Rare',      color = '~p~', chance = 15, ammoMult = 2.0 },
    { name = 'Legendary', color = '~y~', chance = 5,  ammoMult = 3.0 },
}
--- Downed State (revive by teammate) ---
Config.Downed = {
    enabled = true,
    bleedoutMs = 30000, -- how long a teammate has to revive you before you fall back to redeploy/Gulag
    reviveHealth = 120,
}
--- Ping System ---
Config.pingControl = 47 -- 'G' key
--- On Fire (killstreak announcement) ---
Config.OnFire = { kills = 3, windowMs = 20000 }
--- Golden Crate (needs a key) ---
Config.GoldenCrateKeyDropChance = 15 -- % chance a kill drops a key
Config.GoldenCrateCoords = {
    ['SANDY'] = vector3(1980.0, 3773.0, 32.4),
    ['ISLAND'] = vector3(4970.0, -5175.0, 3.0),
}
Config.wztopCommend = 'wztop'
Config.seasonresetCommend = 'wzseasonreset' -- admin only
Config.panelCommend = 'wzpanel' -- admin only, opens the graphical admin panel
--- Admin ---
Config.permission = 16 
function IsPlayerCanStart(source) 
    local xPlayer = ESX.GetPlayerFromId(source) 
    -- Fix: xPlayer can be nil (e.g. command run from server console, or
    -- player not fully loaded yet), which used to crash with
    -- "attempt to index a nil value" instead of just denying the command.
    if xPlayer and xPlayer.permission_level and xPlayer.permission_level >= Config.permission  then  
        return true 
    else 
        return false 
    end 
end 
--- Reward ---
function Reward( src ) 
    local xPlayer = ESX.GetPlayerFromId(src) 
    if xPlayer then
        xPlayer.addMoney(500000)
    end
end 
--- Notify Function  -- 
function SendNotifyServerToPlayer(src , Notify , Tag ) -- For Server Side  -- tag = info / error / 
    -- Fix: essentialmode's client never registers a net event handler for
    -- 'esx:ShowNotification' (only a local ESX.ShowNotification function
    -- exists), so this call was silently doing nothing and players never saw
    -- these messages. Routed through our own event instead (added in
    -- client/main.lua).
    TriggerClientEvent('AWZ:ShowNotification' ,src , Notify)
end 
function SendNotifyToPlayer(Notify, Tag ) -- For Client side
    ESX.ShowNotification(Notify)
   
end 
--- other function ---
function FreezePlayer( freeze )
    TriggerEvent('es_admin:freezePlayer', freeze)
end 

function statusfull()
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'mental', 1000000)
end 
function AddWeapon( weapon , ammo )
	TriggerEvent('esx:addWeapon', weapon , ammo)
end 
function ReviveTrigger()
    TriggerEvent("esx_ambulancejob:revivex")
end 
function SetMaxHealth()
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
end 	
function disableDeadEfect( disable )
	TriggerEvent("esx_paintball:inPaintBall", disable)
end 
---join lobbey 
function insertToJoinLobbey() 
    --- Everything you want happens when you join the lobby
end 
--- Notify --- 
Config.StartNotify = '^1 /wz  ^7 To Join Lobbey '
Config.StartMatchNotify = '^1 Match Started'
--- WarZone --- 
-- Fix: these three used to all be the same bucket number (50), meaning the
-- lobby, the live battlefield, and the Gulag were never actually isolated
-- from each other as separate network instances -- it likely went unnoticed
-- because they're also far apart on the map, but any resource or check that
-- relies on bucket membership (not just distance) would treat them as one
-- world. Given each its own bucket now for real isolation.
Config.FightWorld = 51
Config.LobbeyWorld = 50 
Config.Gulagworld = 52 
Config.DistanceZone = 1000.0 
Config.airplane = 'mammatus'
Config.ShowKillFeed = true 
Config.LobbeyCoord = vector3(-2131.17,3262.66,34.81)
Config.LastCoord  =  vector3(231.45, -746.1, 34.59) 
--- Gulag  --- 
Config.GulagZone = vector3(-529.5824, -1713.481, 21.28796) 
Config.GulagCoordSpwan = {
    vector3(-497.1033, -1682.756, 19.28796)	,
    vector3(-485.3407, -1731.27, 19.54065),
    vector3(-552.3165, -1684.193, 19.49011),
    vector3(-540.7516, -1691.024, 19.87769),
    vector3(-506.5846, -1689.89, 19.77661),
    vector3(-537.1517, -1701.481, 19.60803),
}
--- Sandy Zone ---
Config.SandyZone = vector3(401.42 , 2985.57 ,42.68)  
Config.SandyVehicles = {
    vector3(405.42 , 2987.57 ,42.68)  , 
}
Config.shops = {
    ['SANDY1'] = { -- SandyShopCoordsInZoneOne 
    vector3(533.84,2372.82,48.37), 
    vector3(562.16 , 2736.25 , 42.06), 
    -- Fix: this entry was vector3(5332.03, 3086.49, 40.47) -- an x of 5332
    -- is nowhere near Sandy Shores (every other point here is x:0-950),
    -- it's actually in the Island's coordinate range. Almost certainly a
    -- copy-paste/typo (likely meant ~533.03, matching the pattern of the
    -- point above it), so a shop could spawn kilometers away and be
    -- unreachable. Removed rather than guess the exact intended spot --
    -- the other 8 points in this list still give full rotation coverage.
    vector3(525.84 , 3577.49 , 32.8), 
    vector3(545.71 , 3365.43 , 99.99), 
    vector3(22.43 , 3321.2 , 38.49), 
    vector3(-133.74 , 2850.10 , 49.86), 
    vector3(-180.31 , 2390.35 , 94.06), 
    vector3(944.756, 3094.286, 41.26013)
    },
    ['SANDY2'] = {
    vector3(115.05 , 2696.94 , 52.59 ), 
	vector3(442.9 , 2996.13 , 40.66),
	vector3(687.12, 3152.63 , 42.03),
	vector3(203.02, 3253.04 , 41.7),
	vector3(587.67, 2786.67 , 42.19),
    },
    ['SANDY3'] = {
    vector3(383.21 , 2893.97 , 43.55), 
	vector3(389.19 , 2980.56 , 40.91) , 
	vector3(354.0 , 3088.44 , 48.76)
    }, 

    ['ISLAND1'] = {
        vector3(5047.97, -4880.59, 15.64) , 
        vector3(5154.15, -5131.53, 2.29),
        vector3(5587.24, -5222.88, 14.35) , 
        vector3(5262.36, -5433.44, 65.6) , 
        vector3(5319.66, -5597.26, 65.21) , 
        vector3(5484.2, -5852.13, 20.14) , 
        vector3(5012.6, -5744.08, 19.88) , 
        vector3(4887.37, -5460.19, 30.74) , 

    }, 
    ['ISLAND2'] = {
        vector3(5110.87, -5525.04, 54.24) , 
        vector3(5428.38, -5704.28, 36.82) , 
        vector3(5381.07, -5422.75, 45.81) , 
        vector3(5138.71, -5276.09, 8.35) , 
        vector3(5401.99, -5177.35, 31.45) , 

    }, 
    ['ISLAND3'] = {
        vector3(5255.68, -5442.74, 63.8) , 
        vector3(5278.21, -5296.3, 31.86) , 
        vector3(5169.35, -5358.93, 42.78) , 
    }, 

}
--- Island Zone ---
Config.IslandZone = vector3(5265.58, -5428.06, 65.6)
Config.IslandVehicles = {
    vector3(4767.455, -5589.468, 23.39929), 
    vector3(5286.198, -5107.187, 13.66003), 
    vector3(4891.029, -5737.227, 25.80884), 
    vector3(5321.13, -5250.606, 32.04321),
    vector3(5380.905, -5580.923, 52.22925),
    vector3(4938.422, -5237.117, 2.73811),
    vector3(5117.275, -5519.13, 54.1333) ,
    vector3(5330.492, -5258.479, 32.5824),
    vector3(4953.007, -5668.048, 20.88867),
    vector3(5458.681, -5229.982, 26.66809),
    vector3(4951.029, -5741.42, 19.42273),
    vector3(4962, -5722.892, 19.16992),
    vector3(5527.398, -5299.372, 11.94141),
    vector3(5529.284, -5288.545, 11.95825),
}

--- Weapon Tier roll (shared: used client-side when granting loot) ---
function RollWeaponTier()
    local roll = math.random(1, 100)
    local cumulative = 0
    for _, tier in ipairs(Config.WeaponTiers) do
        cumulative = cumulative + tier.chance
        if roll <= cumulative then
            return tier
        end
    end
    return Config.WeaponTiers[1]
end

--- ===================================================================
--- EXPANSION PACK v2
--- Team-Size Vote, Map Vote, Vehicle Loot, Buy Station, Reboot Van,
--- Custom Loadout Drop, Environmental Hazards, Killcam, Self-Revive Kit,
--- Vehicle Killstreak, Persistent Rank, Battle Pass, Cosmetic Shop,
--- Pre-Match Contract, Reports. See server/main.lua and client/main.lua
--- (search "-- Expansion:") for the implementation of each.
--- ===================================================================

--- Team-Size Vote (Solo/Duo/Trio/Squad) -- players in the lobby vote with
--- /wzmode <1-4>; the most-voted size is used when Auto-Queue starts the
--- match (an admin's /startmatch <blood> <time> <map> <team> still
--- overrides it directly, same as before).
Config.ModeVote = {
    enabled = true,
    voteCommend = 'wzmode',
    labels = { [1] = 'Solo', [2] = 'Duo', [3] = 'Trio', [4] = 'Squad' },
}

--- Map Vote -- players in the lobby vote with /wzmapvote <sandy|island>;
--- the winning map is used the same way as the Team-Size Vote above.
Config.MapVote = {
    enabled = true,
    voteCommend = 'wzmapvote',
}

--- Vehicle Loot -- WarZone now actually spawns vehicles at the coordinates
--- in Config.SandyVehicles/Config.IslandVehicles (those lists existed
--- before but nothing ever spawned anything at them). A share of them
--- start locked and need either a found Car Key or a bit of hot-wiring
--- time to get into.
Config.VehicleLoot = {
    enabled = true,
    models = { 'sultan', 'kuruma', 'baller', 'asea', 'panto', 'blista' },
    lockedChance = 55,   -- % chance a spawned vehicle starts locked
    keyDropChance = 20,  -- % chance a kill drops a Car Key (rolled alongside the Golden Crate key)
    breakInMs = 8000,    -- how long holding E on a locked car with no key takes to hot-wire it
}

--- Buy Station -- one fixed, always-open shop per map (in addition to the
--- rotating loot-crate shops) whose priciest items are paid for out of the
--- WHOLE squad's pooled cash, split evenly, instead of just the buyer's.
Config.BuyStation = {
    enabled = true,
    coords = {
        ['SANDY']  = vector3(280.0, 3120.0, 41.5),
        ['ISLAND'] = vector3(5200.0, -5350.0, 15.5),
    },
    items = {
        { value = 'heavysniper', label = 'Heavy Sniper + 250 ammo',      cost = 1500 },
        { value = 'fullkit',     label = 'Full Armor + Full Bandages',   cost = 1200 },
        { value = 'vehiclekey',  label = 'Guaranteed Car Key',           cost = 600  },
        { value = 'streakskip',  label = 'Vehicle Killstreak (-2 kills needed)', cost = 3000 },
    },
}

--- Reboot Van -- for squad matches (Team > 1) this replaces the Gulag duel:
--- an eliminated player goes straight to Spectator mode (same as losing
--- the Gulag today) and any alive squadmate can bring them back by
--- standing at the van for `reviveMs`. Solo matches (Team == 1) are
--- unaffected and still use the Gulag.
Config.RebootVan = {
    enabled = true,
    reviveMs = 8000,
    coords = {
        ['SANDY']  = vector3(320.0, 3080.0, 41.0),
        ['ISLAND'] = vector3(5150.0, -5300.0, 15.0),
    },
}

--- Custom Loadout Drop -- picked once from the lobby (via the /warzone
--- menu) before the plane takes off; 'none' keeps today's behaviour
--- (unarmed drop, find everything on the ground).
Config.CustomLoadout = {
    enabled = true,
    options = {
        { value = 'none',    label = 'Default (unarmed, loot everything)', weapons = {} },
        { value = 'assault', label = 'Assault: Carbine Rifle + Pistol', weapons = {
            { name = 'WEAPON_CARBINERIFLE', ammo = 250 }, { name = 'WEAPON_PISTOL', ammo = 100 } } },
        { value = 'sniper',  label = 'Sniper: Marksman Rifle + SMG', weapons = {
            { name = 'WEAPON_MARKSMANRIFLE', ammo = 100 }, { name = 'WEAPON_SMG', ammo = 200 } } },
        { value = 'rungun',  label = 'Run and Gun: SMG + Shotgun', weapons = {
            { name = 'WEAPON_SMG', ammo = 250 }, { name = 'WEAPON_PUMPSHOTGUN', ammo = 60 } } },
    },
}

--- Environmental Hazards -- every ~everyMs while a match is live, a random
--- hazard hits a random spot inside the current zone.
Config.Hazards = {
    enabled = true,
    everyMs = 90000,
    radius = 35.0,
    damagePerTick = 5,
    types = { 'gas', 'sandstorm', 'lightning' },
}

--- Killcam -- a short scripted cam on your killer's position/angle right
--- after you die on the open battlefield (not in the Gulag -- that duel is
--- 1v1 already, you know exactly who got you).
Config.Killcam = { enabled = true, durationMs = 4000 }

--- Self-Revive Kit -- rare loot-crate drop; use it while Downed to revive
--- yourself with no teammate needed.
Config.SelfRevive = { enabled = true, crateDropChance = 8, reviveHealth = 100 }

--- Vehicle Killstreak -- on top of the existing UAV/Airdrop killstreak
--- rewards, a longer streak grants a temporary attack helicopter.
Config.VehicleKillstreak = {
    enabled = true,
    kills = 7,
    vehicle = 'buzzard2',
    durationMs = 90000,
}

--- Persistent Rank -- separate from the seasonal /wztop leaderboard, this
--- XP never resets. Flat curve: level = floor(xp / xpPerLevel) + 1.
Config.Rank = {
    xpPerKill = 10,
    xpPerWin = 60,
    xpPerLevel = 100,
    command = 'wzrank',
}

--- Battle Pass -- simple daily challenges, tracked per calendar day,
--- rewarding WZCoins (the persistent currency used by the Cosmetic Shop
--- below, separate from the per-match WzCash).
Config.BattlePass = {
    enabled = true,
    command = 'wzbattlepass',
    dailyChallenges = {
        { id = 'kills5',  label = 'Get 5 kills today',  target = 5,  stat = 'kills', reward = 150 },
        { id = 'win1',    label = 'Win 1 match today',  target = 1,  stat = 'wins',  reward = 300 },
        { id = 'kills15', label = 'Get 15 kills today', target = 15, stat = 'kills', reward = 400 },
    },
}

--- Cosmetic Shop -- squad-uniform-style clothing variants, bought once
--- with WZCoins and owned forever after.
Config.CosmeticShop = {
    command = 'wzshop',
    items = {
        { id = 'skin_red_ops', label = 'Red Ops Uniform',      cost = 500, variant = 6 },
        { id = 'skin_desert',  label = 'Desert Camo Uniform',  cost = 500, variant = 7 },
        { id = 'skin_night',   label = 'Night Stalker Uniform',cost = 750, variant = 8 },
    },
}

--- Pre-Match Contract -- picked from the /warzone menu before joining the
--- lobby; an optional bonus objective for extra WZCoins.
Config.PreMatchContract = {
    enabled = true,
    options = {
        { id = 'none',     label = 'No contract',            target = 0, stat = 'none',   reward = 0   },
        { id = 'nodeath3', label = '3 kills without dying',  target = 3, stat = 'streak', reward = 250 },
        { id = 'win',      label = 'Win the match',          target = 1, stat = 'win',    reward = 500 },
    },
}

--- Reports -- reachable from the /warzone menu, pings online admins live
--- and logs to `wz_reports` for later review.
Config.Report = { enabled = true }
