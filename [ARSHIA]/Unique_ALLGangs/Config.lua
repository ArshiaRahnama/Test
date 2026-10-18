Config = {}
Config.ESX = 'esx:getSharedObject'
Config.inventoryimg  = "nui://esx_inventory/src/html/assets/images" -- item icon path (was IRV-inventory, before that ox_inventory, before that esx_inventoryhud) -- NOTE: not actually referenced anywhere else in this resource right now
Config.permission = 1
-- Percentage cut taken when washing gang dirty money into clean gang
-- money (see server/boss.lua, FMGangsBoss:washMoney). 20 means
-- washing $1000 dirty yields $800 clean.
Config.WashMoneyCutPercent = 20

-------------------------------------------------------------------
-- Federal Case integration (FBI/CIA) - see server/Gangs.lua,
-- TryFileFederalCase/AddEvidenceToOpenCase, and their call sites in
-- server/boss.lua (washMoney threshold, RegisterGangVehicle,
-- GetRecruitablePlayers). Files/updates REAL, persistent DOJ cases
-- through esx_uniquejobs's own public export
-- (exports.esx_uniquejobs:CreateExternalCase, documented at the
-- bottom of esx_uniquejobs/server/doj_cases.lua) and reads its
-- dept_cases/dept_case_suspects tables directly for the recruit
-- warning - nothing inside esx_uniquejobs itself is modified, this
-- only calls/reads its existing public surface. Every hook checks
-- GetResourceState('esx_uniquejobs') first and does nothing if it
-- isn't running.
-------------------------------------------------------------------
Config.FederalCase = {
    Enabled            = true,
    ReferJob           = 'fbi',   -- 'fbi' or 'cia' - which department new auto-filed cases get referred to
    WashMoneyThreshold = 50000,   -- cumulative $ washed (Gangs[gang].others.totalWashed) before a case auto-files; counter resets after filing

    -- Task Force Escalation: if a gang racks up EscalationThreshold
    -- federal cases within EscalationWindowSeconds of each other, the
    -- one that crosses the threshold auto-escalates to 'critical'
    -- priority and every online fbi/cia player gets a heads-up
    -- notification (esx:showNotification - core ESX, not
    -- esx_uniquejobs-specific). See TryFileFederalCase, server/Gangs.lua.
    EscalationThreshold    = 2,
    EscalationWindowSeconds = 1800, -- 30 minutes
}

-- Informant pipeline (see server/boss.lua, FireEmployee): chance (0-100)
-- that firing a low-rank member (grade <= InformantMaxGrade) logs an
-- anonymous tip into esx_uniquejobs's own doa_informants/doa_tips
-- tables for DOA/FBI to work.
Config.InformantChance  = 25
Config.InformantMaxGrade = 2

-------------------------------------------------------------------
-- 45) Gang shootout detection -> live dispatch (FBI/CIA) - see
-- client/gangwar.lua (detection) and server/Gangs.lua,
-- FMGangs:ReportGangShotFired (clustering + dispatch). When enough
-- DISTINCT members of the same gang are shooting near each other at
-- once, this fires the same 'Unit:RobAlarm' event esx_uniquejobs's
-- rob_manager.lua already listens for - no changes there needed - so
-- it shows up live in police/FBI's /acceptrob queue, AND (since
-- 'Unit:RobAlarm' responders don't include cia - that's fixed in
-- esx_uniquejobs's own RESPONDER_JOBS table, out of scope here) also
-- files a real federal case via TryFileFederalCase (see #44) so CIA
-- gets a paper trail even when they don't see the live dispatch.
-------------------------------------------------------------------
Config.GangWar = {
    Enabled           = true,
    CheckIntervalMs   = 1000,  -- how often each client polls IsPedShooting
    RadiusMeters      = 40.0,  -- how close shooters need to cluster to count as one incident
    MinShooters       = 3,     -- distinct same-gang shooters required to trigger a dispatch
    TimeWindowSeconds = 20,    -- how recent a shot must be to still count
    CooldownSeconds   = 120,   -- per-gang cooldown between dispatches, so one firefight can't spam the queue

    -- Vehicle trace: after a confirmed shootout, scans for the gang's
    -- OWN registered vehicles (owned_vehicles, owner = gang name, set
    -- by FMGangs:RegisterGangVehicle) that are physically within this
    -- radius of the shooting right now, and logs their plates as
    -- evidence on the case automatically - see
    -- FMGangs:ReportGangShotFired, server/Gangs.lua.
    VehicleTraceRadius = 60.0,

    -- Island fights are the whole point of the island, so they must NOT
    -- spam FBI/CIA dispatch or file federal cases. Shots inside any of
    -- these circles are ignored by the shootout detector.
    SilentRegions = {
        { coord = vector3(4945.34, -4945.37, 13.28), radius = 1200.0 }, -- the island
    },

    -- Shots/pings from players in a non-default routing bucket (Warzone,
    -- Gungame lobbies, etc.) never count toward a gang shootout.
    RequireDefaultBucket = true,
}

-------------------------------------------------------------------
-- Wiretap bait: while a gang has an open federal case
-- (Gangs[gang].others.openFederalCaseId), each /g gang-chat message
-- has a small chance of being logged as a raw, anonymous intercept
-- into esx_uniquejobs's own doa_tips table (under a per-gang
-- "SIGNAL-<gang>" pseudo-informant, NOT the real sender's identity) -
-- see server/main.lua, the 'g' command. The more active a gang is
-- while under investigation, the more it leaks.
-------------------------------------------------------------------
Config.WiretapBait = {
    Enabled       = true,
    ChancePercent = 15,
}

-------------------------------------------------------------------
-- Vehicles selectable from the gang vehicle/heli/boat spawn points
-- (see client/load.lua, OpenVehicleMenu/OpenHeliMenu/OpenBoatMenu).
-- Uses ESX.Game.SpawnVehicleJobs, the same function the server's own
-- police job (esx_uniquejobs) already uses for its vehicle spawner -
-- add/remove models per category as needed.
-------------------------------------------------------------------
Config.GangVehicles = {
    car  = { 'sultan', 'sultanrs', 'kuruma', 'issi2' },
    heli = { 'maverick', 'buzzard2' },
    boat = { 'jetmax', 'suntrap' },
}

-------------------------------------------------------------------
-- Server-wide gang vest presets, selectable from the Clothes Menu's
-- new "Gang Vest" option (client/load.lua, OpenLockerMenu) - applies
-- ONLY the vest/bulletproof component (esx_skin's bproof_1/bproof_2),
-- leaving the rest of whatever the player is currently wearing
-- untouched. Confirmed this component naming against this server's
-- actual skinchanger resource before using it. bproof_1 = 0 means no
-- vest; the numbers below are placeholders - test in-game and adjust
-- to match how you want each preset to actually look.
-------------------------------------------------------------------
Config.GangVests = {
    { name = 'Light Vest', bproof_1 = 1, bproof_2 = 0 },
    { name = 'Heavy Vest', bproof_1 = 2, bproof_2 = 0 },
}

-------------------------------------------------------------------
-- Items selectable in the "Item Access" rank-access submenu (per-item
-- armory restriction). Enforced server-side via esx_inventory's
-- registerStashAccessCheck hook, wired up in server/Gangs.lua's
-- EnsureArmoryStash. Toggling these in the boss menu now actually
-- locks/unlocks that item for that rank in-game.
-------------------------------------------------------------------
Config.ArmoryItems = {
    'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_SMG', 'WEAPON_MICROSMG',
    'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_PUMPSHOTGUN',
    'ammo-9', 'ammo-rifle', 'ammo-shotgun', 'bandage', 'armour',
}
---
Config.OPENPANELCMD = 'openpanel'
Config.ADDXPCMD = 'addgangxp'
Config.REMOVEXPCMD = 'removegangxp'
----
Config.Skin = 'esx_skin'
Config.skinchanger = 'skinchanger'
Config.SteamWebApiKey = '2E63E55937A74CF716E31D90A420ED57'
Config.DefaultAvatar = "img/gangicon.png"
Config.MenuSkintrigger = 'esx_skin:openRestrictedMenu' 
--- chatMessage event / showNotification event
Config.chatMessage = 'chatMessage'
Config.showNotification = 'esx:showNotification' 
Config.showAdvancedNotification = 'esx:showAdvancedNotification'
---- inventory (armory -> IRV-inventory `stashs` table, see server/Gangs.lua EnsureArmoryStash)
-- Config.OpenInventory / TakeItemEvent / AddItemToInventory are no longer
-- used: the armory now opens through IRV-inventory's own stash UI
-- (client's exported `stash()` function), replacing the old
-- esx_inventoryhud custom NUI flow entirely.
----
Config.TimeToPay = 15 -- min 
----
function IsPlayerCanOpenPanel(source) 
    local xPlayer = ESX.GetPlayerFromId(source) 
    if not xPlayer then
        return false
    end
    local level = tonumber(xPlayer.permission_level)
    if level and level >= Config.permission then  
        return true 
    else 
        return false 
    end 
end 
function GetAdminName(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.name 
end 

function GetAdminRank(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local GetRankLabeL = {
        [1] =  'Helper'    , 
        [2] =  'Helper'    , 
        [3] =  'Helper'    , 
        [4] =  'ADMIN'     , 
        [5] =  'ADMIN'     , 
        [6] =  'ADMIN'     , 
        [7] =  'HEADADMIN' , 
        [8] =  'HEADADMIN' , 
        [9] =  'HEADADMIN' , 
        [10] = 'DEVELOPER' , 
        [11] = 'DEVELOPER' , 
        [12] = 'GAMEMASTER' , 
    }
    local RankName = GetRankLabeL[ xPlayer.permission_level ] or 'GAMEMASTER'
    return RankName
end 
function Notifiaction(text)
    ESX.ShowNotification(text)
end 

Config.GangLeveL = {
    [1] = 1000,
    [2] = 2000,
    [3] = 3000,
    [4] = 4000,
    [5] = 5000,
    [6] = 6000,
    [7] = 7000,
    [8] = 8000,
    [9] = 9000,
    [10] = 10000,
}

Config.LevelReward = {
    [1] = 1000,
    [2] = 2000,
    [3] = 3000,
    [4] = 4000,
    [5] = 5000,
    [6] = 6000,
    [7] = 7000,
    [8] = 8000,
    [9] = 9000,
    [10] = 10000,
}


-------------------------------------------------------------------
-- GANG XP SOURCES (server-side only; see GrantGangXP in server/level.lua)
-- Every gain is capped per gang per (server) day so nobody can farm
-- levels. Admin XP packs and /addxp bypass the cap on purpose.
-------------------------------------------------------------------
Config.GangXP = {
    Enabled  = true,
    DailyCap = 1500,
    Sources  = {
        territoryIncome = { [1] = 10, [2] = 25, [3] = 50 }, -- per owned zone, every income payout, by zone tier
        capture         = 150,   -- taking a normal zone by holding it
        bossZone        = 600,   -- taking the Boss Zone
        defend          = 100,   -- owner beat back a real capture attempt (throttled per zone)
        sabotage        = 80,
        warWin          = 400,
        warLose         = 100,
    },
    -- XP cards from robberies (items given by Unique_AllRobs on success). Using one adds this much XP to the gang.
    -- PLACEHOLDERS: the old card values weren't in the repo - set these to what you want.
    Cards = {
        xpshop = 100, xpfleeca = 150, xpjewel = 250, xpbime = 250, xpbankp = 350, xprig = 500,
    },
    DefendMinProgressSeconds = 60,  -- the challenger must have held the zone this long before a defense counts
    DefendThrottleSeconds    = 300, -- per zone
}

-------------------------------------------------------------------
-- GANG LEVEL PERKS - cumulative: a gang gets the value from the
-- highest listed level <= its own level, per key. Read with
-- GetGangPerk(gang, key, default) (server/level.lua).
--   maxZones        territory cap (replaces Config.Territory.MaxZonesPerGang)
--   upgradeDiscount discount on zone upgrades (0.10 = 10%)
--   captureSpeed    challenger needs this much LESS capture time (0.05 = 5%)
--   warRosterMax    max players per side in a Gang War
--   warFeeDiscount  discount on the Gang War declare/accept fee
-------------------------------------------------------------------
Config.GangPerks = {
    [0]  = { maxZones = 2, warRosterMax = 4, upgradeDiscount = 0.0, captureSpeed = 0.0, warFeeDiscount = 0.0 },
    [3]  = { warRosterMax = 5 },
    [5]  = { maxZones = 3, warRosterMax = 6 },
    [6]  = { upgradeDiscount = 0.10 },
    [7]  = { warFeeDiscount = 0.10 },
    [8]  = { warRosterMax = 7 },
    [9]  = { upgradeDiscount = 0.15 },
    [10] = { maxZones = 4, warRosterMax = 8, captureSpeed = 0.05 },
}

-------------------------------------------------------------------
-- GANG WAR - a contained, contract-based fight over ONE territory zone
-- (see server/zonewar.lua). Only rostered players, only inside the
-- zone, only for a limited time. Nothing outside the zone is affected.
-------------------------------------------------------------------
Config.ZoneWar = {
    Enabled               = true,
    AdminEndCommand       = 'endwar',    -- /endwar <id>  (admin) cancels a war and refunds both fees

    MinOnlineToTarget     = 3,          -- a gang is only listed as a target when it has at least this many members online (your own gang needs it too)
    DeclareFee            = 15000,       -- clean gang money, paid by BOTH sides (attacker on declare, defender on accept)
    PoolBurnPercent       = 10,          -- % of the prize pool that disappears (money sink, stops inflation)
    AcceptWindowMin       = 10,          -- defender boss has this long to accept; declining/ignoring refunds the attacker
    StartDelayMin         = 15,          -- time between accept and start (rosters form during this)
    MaxDurationMin        = 30,
    ScoreToWin            = 20,
    RosterMin             = 3,           -- fewer than this on either side at start = cancelled + refunded
    MaxConcurrentWars     = 2,           -- server-wide
    MaxWarsPerWeek        = 2,           -- per gang
    PairCooldownHours     = 48,          -- same two gangs can't fight again for this long
    ForfeitIfEmptySeconds = 180,         -- a side with nobody online for this long forfeits

    ZoneBufferMeters      = 15.0,        -- kills only count when BOTH players are inside radius + buffer
    MaxKillDistance       = 400.0,       -- sanity cap on killer<->victim distance
    SameVictimCooldownSec = 180,         -- the same victim only gives points once per this window
    KillPoints            = 1,
    LeaderKillPoints      = 2,           -- killing the enemy boss
    HoldPointEverySec     = 60,          -- the side with more rostered players inside gets +1
    WarNightMultiplier    = 2,           -- all points x2 during Config.Territory.WarNight

    WinnerProtectHours    = 2,           -- zone can't be captured/challenged after a war
    WinnerIncomeBonus     = 0.25,        -- +25% income from that zone...
    WinnerBonusHours      = 24,          -- ...for this long (memory only, resets on restart)
    WinnerHeistPoints     = 5,           -- Robbery-lottery points the winning gang gets (Unique_AllRobs)

    TickSeconds           = 5,
    Webhook               = '',          -- optional Discord webhook for declare/start/result

    -------------------------------------------------------------------
    -- MODE
    --   'arena' : (default) the roster gathers at their gang HQ, then both
    --             teams are taken to an isolated paintball arena (own
    --             routing bucket, no real deaths, loadout restored) and
    --             play first-to-N rounds. Nothing touches the city.
    --   'zone'  : fight inside the real zone (original mode, see above).
    -- If the paintball resource is not running, 'arena' falls back to 'zone'.
    -------------------------------------------------------------------
    Mode = 'arena',
    Arena = {
        Resource       = 'paintball',   -- resource that exports CreateExternalMatch / EndExternalMatch
        Maps           = { 'cargo', 'island', 'skyscraper' }, -- paintball map names, rotated per war
        Weapon         = 'carbinerifle', -- paintball weapon (no "weapon_" prefix); free for war matches
        RoundsToWin    = 3,             -- "matches": first team to win this many rounds takes the war
        RoundSeconds   = 120,
        Armor          = 100,
        Headbox        = 0,             -- 1 = headshots only count
        GatherSeconds  = 180,           -- roster must be at their HQ within this time after the war starts
        GatherRadius   = 80.0,          -- metres around the gang's boss marker (Boss Menu location)
        MaxMatchMinutes = 25,           -- failsafe: a stuck match is ended as a draw (fees refunded)
    },
}

Config.DefaultRanks = {
   {
    Grade = 1, 
    Label = 'Rank 1',
    Name  = 'Rank1'
   },
   {
    Grade = 2, 
    Label = 'Rank 2',
    Name  = 'Rank2'
   },
   {
    Grade = 3, 
    Label = 'Rank 3',
    Name  = 'Rank3'
   },
   {
    Grade = 4, 
    Label = 'Rank 4',
    Name  = 'Rank4'
   },
   {
    Grade = 5, 
    Label = 'Rank 5',
    Name  = 'Rank5'
   },
   {
    Grade = 6, 
    Label = 'Rank 6',
    Name  = 'Rank6'
   },
   {
    Grade = 7, 
    Label = 'Rank 7',
    Name  = 'Rank7'
   },
   {
    Grade = 8, 
    Label = 'Rank 8',
    Name  = 'Rank8'
   },
   {
    Grade = 9, 
    Label = 'Rank 9',
    Name  = 'Rank9'
   },
   {
    Grade = 10, 
    Label = 'Rank 10',
    Name  = 'Rank10'
   },

}
Config.markers = {
  [0] = 0, 
  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43
}
Config.peds = {
    [0] ='a_m_m_beach_01' ,
    'cs_dreyfuss' ,
    'csb_jackhowitzer' ,
    'g_m_m_chicold_01' ,
    'g_m_y_ballaorig_01' ,
    'g_m_y_ballasout_01' ,
    'g_m_y_famca_01' ,
    'g_m_y_famdnf_01' ,
    'g_m_y_lost_01' ,
    'g_m_y_lost_02' ,
    'g_m_y_salvagoon_01' ,
}
Config.blip = {
    [0] =1,
    8,16,36,38,40,43,47,50,72,84,85,303
}
Config.object = {
    [0] ='imp_prop_impexp_boxpile_01' ,
    'imp_prop_impexp_boxpile_02' ,
    'imp_prop_impexp_boxwood_01' ,
    'prop_box_ammo03a_set2' ,
    'prop_box_wood02a_mws' , 
    'prop_box_wood02a_pu' , 
    'prop_toolchest_04' , 
    'xm_prop_crates_weapon_mix_01a' , 


}
Config.flag = {
    [0] = 'apa_prop_flag_china' , 
    'prop_flag_japan' , 
    'prop_flag_lsservices' , 
}

Config.NeedHandsup = {
    ['Search'] = false,
    ['Cuff'] = false,
}
Config.Animations = {
    ['handsup_anim'] = 'missminuteman_1ig_2',
    ['handsup_anim_dict'] = 'handsup_enter',
    ['dead_anim'] = 'dead',
    ['dead_anim_dict'] = 'dead_a',
}
Config.DefaultEvents = {
    ['Cuff'] = 'For5M:Cuff',
    ['UnCuff'] = 'For5M:UnCuff',
    ['Drag'] = 'For5M:Drag',
    ['PutInVeh'] = 'For5M:PutInVeh',
    ['PutOutVeh'] = 'For5M:PutOutVeh',
    ['LockPick'] = 'For5M:LockPick',
    ['confiscatePlayerItem'] = 'esx:confiscatePlayerItem',
    ['onPlayerDeath'] = 'esx:onPlayerDeath',
    ['playerSpawned'] = 'playerSpawned',
    ['playerLoaded'] = 'esx:playerLoaded',
    ['setGang'] = 'esx:setGang',
    ['DataCard'] = 'esx:getOtherPlayerDataCard',
}
Config.Packs = {
    ['pistolpack'] = {
        --- Name  
        ['WEAPON_APPISTOL'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_PISTOL'] = { Count = 5 , ammo = 250  } ,
        ['WEAPON_PISTOL50'] = { Count = 3 , ammo = 250  } ,
        ['WEAPON_PISTOL_MK2'] = { Count = 8 , ammo = 250  } ,
        ['WEAPON_SNSPISTOL']= { Count = 10 , ammo = 250  } ,
        ['WEAPON_SNSPISTOL_MK2']= { Count = 5 , ammo = 250  } ,
    } , 
    ['riflepack'] = {
        --- Name  
        ['WEAPON_SNSPISTOL_MK2'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTRIFLE_MK2'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTSHOTGUN'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTSMG'] = { Count = 5 , ammo = 250  } ,
        ['WEAPON_ADVANCEDRIFLE']= { Count = 1 , ammo = 250  } ,
        ['WEAPON_CARBINERIFLE']= { Count = 3 , ammo = 250  } ,
    } , 
    ['moneypack'] =  1000000,  -- > Add To Boss Action
    ['xppack'] =  20000,
    ['itempack'] ={
        ['iron'] = 10 ,
        ['gold'] = 20 ,
    } , 
    ['attchmentpack'] = {
        --- Name   , count
        ['grip'] = 10 ,
        ['clip'] = 20 ,
       
    }, 

}


function getVehicleCategory(vehicle) 
    if not vehicle or vehicle == nil then 
        return "car" 
    end 
    local model = GetEntityModel(vehicle) 
    local modelName = GetDisplayNameFromVehicleModel(model) 
    local class = GetVehicleClass(vehicle) 
    if class == 14 then -- HELICOPTERS 
        return "heli" 
    elseif class == 15 then -- PLANES 
        return "heli" 
    elseif class == 8 then -- BOATS 
        return "boat" 
    else 
        return "car" 
    end 
end 
-------------------------------------------------------------------
-- Per-category Discord log webhooks (requested: "Set Log Webhook"
-- should let a boss set a *separate* webhook per action type instead
-- of every log going to one channel). Matches the `category` string
-- each For5M:SendLog call already uses (client/load.lua, server/boss.lua)
-- - 'default' is the fallback used for any category without its own
-- webhook set, and for old gangs that only ever set a single URL the
-- legacy way (kept fully backward compatible, see server/main.lua's
-- GetCategoryWebhook).
-------------------------------------------------------------------
Config.LogCategories = {
    'Boss Action',
    'Garage',
    'Locker',
    'Territory',
}

-------------------------------------------------------------------
-- Territory Control add-on (server/territory.lua, client/territory.lua)
-- Splits the map into a handful of fixed zones gangs can capture by
-- physically holding them (alone) for CaptureSeconds. Owned zones pay
-- dirty money (blackmoney) into the gang every IncomeIntervalMinutes,
-- which has to go through the SAME washMoney flow as any other dirty
-- money (server/boss.lua) - so more territory naturally means more
-- laundering, which is what feeds Config.FederalCase.WashMoneyThreshold
-- below. A random zone is flagged "vulnerable" every so often
-- (faster to capture, and the owner gets warned) to keep a reason to
-- keep checking back even outside active wars. Everything about WHO
-- currently controls a zone is decided server-side only, from
-- distance-validated client pings (see Territory:Ping) - a client can
-- never claim a zone by lying about its own position or a timer.
--
-- The coordinates below are generic Los Santos landmarks and are only
-- placeholders - replace `coord` for each zone with real spots on
-- YOUR map/server before going live.
-------------------------------------------------------------------
Config.Territory = {
    Enabled = true,

    -------------------------------------------------------------------
    -- ISLAND LAYOUT - every zone lives on the island, so wars stay out
    -- of the city. Coordinates are taken from the island's own flag /
    -- weapon-spawn spots (known walkable ground). Zones are kept well
    -- away from the 5 island Safe zones (spawn/teleport areas).
    -- Fine-tune any spot in-game with /zonepos (admin) and paste the
    -- printed `coord = ...` line over the matching zone.
    -- zombieTier is omitted on purpose: the island system already runs
    -- its own zombies, so territory zombies would double the load.
    -------------------------------------------------------------------
    Zones = {
        { key = 'cayo_airstrip',    label = 'Foroodgah Jazire',   coord = vector3(4479.5,  -4590.65,  5.56), radius = 55.0, tier = 2 },
        { key = 'cayo_central',     label = 'Markaze Jazire',     coord = vector3(4995.74, -5166.95,  2.7),  radius = 50.0, tier = 1 },
        { key = 'cayo_north_coast', label = 'Sahele Shomal',      coord = vector3(5104.77, -4676.54,  2.29), radius = 50.0, tier = 1 },
        { key = 'cayo_south_hill',  label = 'Tappe-ye Jonoob',    coord = vector3(4901.82, -5336.31, 35.61), radius = 45.0, tier = 2 },
        { key = 'cayo_tower_base',  label = 'Paye-ye Borj',       coord = vector3(5263.34, -5432.39, 65.6),  radius = 35.0, tier = 3 },
    },

    -------------------------------------------------------------------
    -- ISLAND (client/territory.lua draws the red circle,
    --         client/territory_zombies.lua spawns the zombies)
    -- The whole island is one big danger zone: a red radius blip over it
    -- and ambient zombies that exist ONLY inside the circle (and never
    -- inside the island's Safe zones). Zombies are local per player.
    -------------------------------------------------------------------
    Island = {
        Enabled      = true,
        label        = 'Jazire',
        coords       = vector3(4945.34, -4945.37, 13.28),
        radius       = 1100.0,
        blip         = true,
        blipColor    = 1,     -- red
        blipOpacity  = 50,    -- 0-255
        captureAnnounce = true, -- when a zone changes hands, everyone physically on the island gets a message

        -- No zombies in/near the island's Safe zones (spawn/teleport areas).
        -- radius = the Safe zone's own 50m + a 50m margin, so zombies never hover at the edge.
        safeZones = {
            { coord = vector3(4890.52, -5736.66, 26.35), radius = 100.0 },
            { coord = vector3(5479.87, -5852.72, 20.33), radius = 100.0 },
            { coord = vector3(5587.27, -5222.80, 14.35), radius = 100.0 },
            { coord = vector3(4820.23, -4306.22,  5.38), radius = 100.0 },
            { coord = vector3(3906.31, -4693.10,  4.20), radius = 100.0 },
        },

        zombies = {
            Enabled       = true,
            -- How zombies hurt you:
            --   'combat' (default): the game's own melee AI (TaskCombatPed) - they run at you and visibly
            --                       punch/claw you with normal hit reactions. `damage` is NOT used;
            --                       meleeDamageScale scales the game's melee damage while you are on the island.
            --   'script'          : they run up and hit you with the exact HP in `damage` (+ a punch animation).
            damageMode        = 'combat',
            meleeDamageScale  = 1.0,
            maxZombie     = 2,      -- zombies alive at once, per player
            spawnCooldown = 60,     -- seconds between spawn waves
            spawnRadius   = 40,     -- they appear 40% - 100% of this many metres from the player (1-40)
            maxRadius     = 75,     -- a zombie farther than this from the player is removed
            fireChance    = 10,     -- % of spawns that are burning
            bombChance    = 5,      -- % of spawns that explode when they reach (or die next to) the player
            speed         = { 5, 10 }, -- run speed, random per zombie (1-10)
            damage        = { 3, 5 },  -- HP per hit, random per hit (damageMode = 'script' only)

            -- finer control (optional)
            health            = 150,   -- fire zombies get double
            detectRange       = 75.0,  -- start chasing within this range (<= maxRadius)
            attackRange       = 1.8,   -- melee reach
            attackIntervalMs  = 1200,  -- time between hits
            moveRateBase      = 0.8,   -- run speed -> move rate: base + speed * perSpeed (speed 5 = 1.4, speed 10 = 2.0)
            moveRatePerSpeed  = 0.12,
            bombTriggerRange  = 3.0,   -- bomb zombie explodes this close to the player
            bombDeathRange    = 6.0,   -- ...or when killed this close
            bombExplosionType = 0,     -- GTA explosion type 0 = grenade
            bombExplosionScale = 0.4,  -- damage scale
            -- models = { ... }        -- default: Config.Territory.ZombieTiers.normal.models
        },
    },

    -------------------------------------------------------------------
    -- CAPTURE REWARD: items dropped into the capturing gang's ARMORY
    -- (the first gang armory, Unique_inventory store "gang_<name>") the
    -- moment they take a zone. Members take them out of the armory like
    -- any other item, and every online member gets a chat message +
    -- notification. A zone only pays out once per cooldownMinutes, so two
    -- friendly gangs can't flip it back and forth for items.
    --
    -- The guaranteed part is the ROBBERY PLANS that Unique_AllRobs now
    -- requires (Config.Rob.Plans there): plan_bronze / plan_silver /
    -- plan_premium. On top of that there is a LOW-chance bonus roll for a
    -- weapon or item (`bonus` below).
    -- Item names must exist in the `items` table (a warning is printed at
    -- start if one is missing - run Unique_AllRobs/sql/Unique_RobPlans.sql).
    -------------------------------------------------------------------
    CaptureReward = {
        Enabled            = true,
        inventoryResource  = 'Unique_inventory',
        cooldownMinutes    = 60,

        -- guaranteed items, by zone tier
        byTier = {
            [1] = { { name = 'plan_bronze',  count = 2 } },
            [2] = { { name = 'plan_silver',  count = 1 }, { name = 'plan_bronze', count = 1 } },
            [3] = { { name = 'plan_premium', count = 2 }, { name = 'plan_silver', count = 1 } },
        },
        default  = { { name = 'plan_bronze', count = 1 } },
        bossZone = { { name = 'plan_premium', count = 5 } },

        -- Gang POINTS for the Robbery lottery (Unique_AllRobs, Boss Menu > Robbery):
        -- paid together with the items, so the same per-zone cooldown applies.
        heistPoints = { [1] = 2, [2] = 3, [3] = 5, default = 2, bossZone = 10 },

        -- chance (%) of ONE extra random reward per payout, and what it can be.
        -- type = 'weapon' goes to the armory's weapon list, 'item' to its items.
        -- weight = relative likelihood inside the pool.
        bonus = {
            byTier = {
                [1] = { chance = 5, pool = {
                    { type = 'weapon', name = 'WEAPON_PISTOL',     count = 1, weight = 55 },
                    { type = 'weapon', name = 'WEAPON_PISTOL_MK2', count = 1, weight = 25 },
                    { type = 'item',   name = 'iron',              count = 5, weight = 20 },
                } },
                [2] = { chance = 8, pool = {
                    { type = 'weapon', name = 'WEAPON_SNSPISTOL_MK2', count = 1, weight = 40 },
                    { type = 'weapon', name = 'WEAPON_PISTOL50',      count = 1, weight = 30 },
                    { type = 'weapon', name = 'WEAPON_ASSAULTSMG',    count = 1, weight = 20 },
                    { type = 'item',   name = 'gold',                 count = 5, weight = 10 },
                } },
                [3] = { chance = 12, pool = {
                    { type = 'weapon', name = 'WEAPON_ASSAULTSMG',     count = 1, weight = 40 },
                    { type = 'weapon', name = 'WEAPON_CARBINERIFLE',   count = 1, weight = 35 },
                    { type = 'weapon', name = 'WEAPON_ASSAULTSHOTGUN', count = 1, weight = 25 },
                } },
            },
            bossZone = { chance = 25, pool = {
                { type = 'weapon', name = 'WEAPON_CARBINERIFLE',    count = 1, weight = 40 },
                { type = 'weapon', name = 'WEAPON_ADVANCEDRIFLE',   count = 1, weight = 35 },
                { type = 'weapon', name = 'WEAPON_ASSAULTRIFLE_MK2', count = 1, weight = 25 },
            } },
            default = { chance = 5, pool = {
                { type = 'weapon', name = 'WEAPON_PISTOL', count = 1, weight = 100 },
            } },
        },
    },

    TierIncome = { -- dirty money ($) paid per zone every IncomeIntervalMinutes
        [1] = 1500,
        [2] = 3000,
        [3] = 6000,
    },
    IncomeIntervalMinutes = 60,

    CaptureSeconds          = 240, -- must be the ONLY gang present in the zone for this long, continuously
    VulnerableCaptureSeconds = 120, -- faster capture time while a zone is flagged vulnerable
    TickIntervalMs           = 5000, -- how often the server evaluates who's holding each zone
    PingStaleSeconds         = 12,   -- a client ping older than this no longer counts as "present"
    MaxZonesPerGang          = 2,    -- a gang stops being able to make progress on new zones past this (island has 5 zones + boss)

    VulnerableEventMinMinutes = 90,  -- a random owned zone goes "vulnerable" every 90-180 min
    VulnerableEventMaxMinutes = 180,
    VulnerableWindowSeconds   = 600, -- how long that window lasts

    -- The regular 6 zones above stay exactly as they were - everything
    -- below is additive, off a single Enabled switch each, so any of
    -- these 6 systems can be turned off independently without touching
    -- the base capture loop at all.

    -------------------------------------------------------------------
    -- 1) UPGRADES - a boss spends the gang's CLEAN money (not the
    -- territory blackmoney itself - has to actually be laundered
    -- first) to permanently improve a zone THEY currently own.
    -- Upgrades belong to the zone, not the gang - losing the zone to
    -- someone else wipes them (see CaptureZone), so holding a zone
    -- long-term is what pays off, not just owning it briefly.
    -------------------------------------------------------------------
    Upgrades = {
        Enabled = true,
        alarm = {
            label = 'Sisteme Hoshdar', maxLevel = 1, cost = { 5000 },
            -- effect handled directly in the tick: level 1 = instant
            -- notify to the owner the moment a rival gang enters, not
            -- just when they finish capturing.
        },
        production = {
            label = 'Khatte Tolid', maxLevel = 3, cost = { 8000, 15000, 25000 },
            incomeBonusPerLevel = 0.25, -- +25% zone income per level (stacks)
        },
        fortify = {
            label = 'Estehkamat', maxLevel = 3, cost = { 8000, 15000, 25000 },
            captureTimeBonusPerLevel = 0.20, -- +20% capture time needed for a challenger, per level (stacks)
        },
    },

    -------------------------------------------------------------------
    -- 2) ESPIONAGE - scouting is low-risk/low-reward (peek at a rival
    -- zone's headcount + upgrades), sabotage is higher-risk (temporary
    -- income hit on a rival zone without having to fight for it) - a
    -- lever for smaller gangs who can't win a straight fight.
    -------------------------------------------------------------------
    Scout = {
        Enabled = true,
        Cooldown = 600,          -- per player, seconds
        DetectionChance = 25,    -- % chance the target gang gets notified someone scouted them
        RequireInsideZone = true,
    },
    Sabotage = {
        Enabled = true,
        Cooldown = 3600,             -- per zone per gang, seconds
        DetectionChance = 40,        -- % chance the target gang is told who did it
        IncomeReductionPercent = 50, -- -50% income from that zone while active
        DurationSeconds = 7200,      -- 2 hours
        RequireInsideZone = true,
    },

    -------------------------------------------------------------------
    -- 3) CATCH-UP - a gang well below the average zones-per-gang (or
    -- holding zero) captures faster, so one dominant gang can't lock
    -- everyone else out permanently. Never affects DEFENDING your own
    -- zone, only how fast you can take a new one.
    -------------------------------------------------------------------
    CatchUp = {
        Enabled = true,
        ZeroZonesMultiplier = 0.5,     -- 50% of normal capture time while owning 0 zones
        BelowAverageMultiplier = 0.75, -- 75% while owning fewer than the average
    },

    -------------------------------------------------------------------
    -- 4) BOSS ZONE - a 7th, unowned zone that only opens on a weekly
    -- schedule and needs a much longer hold to take. Reuses the exact
    -- same capture/contest logic as every other zone (it's just
    -- Config.Territory.Zones[7] with bossZone=true) - the tick loop
    -- only skips it outside its weekly window. `openDay` follows
    -- Lua's os.date('*t').wday (1=Sunday, 2=Monday, ... 7=Saturday).
    -- Placeholder coords - put it somewhere suitably dramatic on your map.
    -------------------------------------------------------------------
    BossZone = {
        Enabled = true,
        key = 'boss_zone', label = 'Ghalamroye Padeshah', coord = vector3(5266.43, -5427.52, 141.05), radius = 35.0, tier = 3, -- top of the tower (island weapon-spawn spot); sits 75m above cayo_tower_base so the two never overlap
        bossZone = true,
        openDay = 6,           -- Friday
        openHour = 20,         -- 20:00 server time
        openDurationHours = 3,
        captureSeconds = 600,  -- must hold ALONE for 10 minutes straight
        zombieTier = 'hard',   -- see ZombieTiers below - only spawns while the zone is open (client/territory_zombies.lua)
        rewardBlackMoney = 25000,
        titleReward = 'Farmanravaye Jazire', -- cosmetic, shown on HUD/leaderboard for whoever holds it
    },

    -------------------------------------------------------------------
    -- 5) ALLIANCES - two gangs can formally ally; while allied, their
    -- members no longer count as "a second gang" toward each other in
    -- the contest check (server/territory.lua ProcessTerritoryTick), so
    -- they can garrison and defend each other's zones together instead
    -- of freezing progress by just standing near each other.
    -------------------------------------------------------------------
    Alliance = {
        Enabled = true,
    },

    -------------------------------------------------------------------
    -- 6) WAR NIGHT - a fixed weekly window where capture is faster and
    -- income is doubled everywhere at once, so there's a standing
    -- reason for the whole server to be online at the same time. Same
    -- `wday` convention as BossZone above.
    -------------------------------------------------------------------
    WarNight = {
        Enabled = true,
        day = 6,          -- Friday
        startHour = 20,
        endHour = 23,
        captureMultiplier = 0.5, -- capture needs half the usual time
        incomeMultiplier = 2.0,  -- income doubled
    },

    -------------------------------------------------------------------
    -- 7) ZOMBIES - ambient danger inside territory itself, read only by
    -- client/territory_zombies.lua. Every regular zone above is tagged
    -- zombieTier='normal' (always active); the Boss Zone is tagged
    -- 'hard' and only actually spawns zombies while that zone is open
    -- (client/territory_zombies.lua listens for the same
    -- Territory:BossZoneState broadcast the boss-zone open/close
    -- announcement thread already sends). Zombies are local/per-player,
    -- not synced between players - see that file's header comment for
    -- why, and how to ask for a synced version instead.
    -------------------------------------------------------------------
    ZombieTiers = {
        normal = {
            maxAlive = 6,            -- zombies alive at once per zone, per player
            spawnRadius = 70.0,      -- spawn them within this distance of the player
            despawnRadius = 160.0,   -- delete them once farther than this from the player
            detectRange = 30.0,      -- start chasing the player within this range
            health = 150,
            moveRate = 0.75,         -- < 1.0 = slower shambling walk
            models = {
                'a_m_y_hippy_01', 'a_m_m_hillbilly_01', 'a_f_y_hippie_01',
                'a_m_y_beachvesp_01', 'a_f_y_beachvesp_01', 'a_m_m_farmer_01',
            },
        },
        hard = {
            maxAlive = 12,
            spawnRadius = 90.0,
            despawnRadius = 200.0,
            detectRange = 45.0,
            health = 280,
            moveRate = 0.95,
            models = {
                'a_m_y_hippy_01', 'a_m_m_hillbilly_01', 'a_f_y_hippie_01',
                'a_m_m_farmer_01', 'a_m_y_gentransport', 'a_m_m_ktown_01',
            },
        },
    },
}
