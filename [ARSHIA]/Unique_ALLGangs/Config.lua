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

    Zones = {
        { key = 'grove_street',        label = 'Khiaboone Grove',            coord = vector3(-170.0,  -1609.0,  34.0), radius = 40.0, tier = 1 },
        { key = 'vespucci_beach',      label = 'Sahele Vespucci',            coord = vector3(-1180.0, -1520.0,   4.0), radius = 45.0, tier = 1 },
        { key = 'la_mesa_industrial',  label = 'Mantaghe Sanati La Mesa',      coord = vector3(850.0,   -1940.0,  31.0), radius = 50.0, tier = 2 },
        { key = 'del_perro_pier',      label = 'Eskele Del Perro',           coord = vector3(-1850.0, -1230.0,  13.0), radius = 45.0, tier = 2 },
        { key = 'sandy_shores',        label = 'Sandy Shores',              coord = vector3(1961.0,   3740.0,  32.0), radius = 55.0, tier = 2 },
        { key = 'paleto_bay',          label = 'Khalije Paleto',             coord = vector3(-448.0,   6008.0,  31.0), radius = 60.0, tier = 3 },
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
    MaxZonesPerGang          = 3,    -- a gang stops being able to make progress on new zones past this

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
        key = 'boss_zone', label = 'Ghalamroye Padeshah', coord = vector3(2565.0, 2585.0, 37.9), radius = 70.0, tier = 3,
        bossZone = true,
        openDay = 6,           -- Friday
        openHour = 20,         -- 20:00 server time
        openDurationHours = 3,
        captureSeconds = 600,  -- must hold ALONE for 10 minutes straight
        guardCount = 4,        -- hostile NPCs guarding it while open (client-side, cosmetic difficulty)
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
}
