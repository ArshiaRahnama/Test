Config = {}

Config.DarkPhone = {}
Config.DarkPhone.Hostage = {}
Config.DarkPhone.Hostage.CopsRequired = 9
Config.DarkPhone.Hostage.CancelDistance = 50
Config.DarkPhone.Hostage.Cooldown = 1*60*60
Config.DarkPhone.Hostage.SuccessTime = 13*60

Config.DarkPhone.Pursuit = {}
Config.DarkPhone.Pursuit.CopsRequired = 4
Config.DarkPhone.Pursuit.Reward = 200000
Config.DarkPhone.Pursuit.Cooldown = 10*60
Config.DarkPhone.Pursuit.SuccessTime = 5*60

Config.Rob = {}

Config.Rob.PoliceJobs = { 'police', 'sheriff', 'fbi', 'mt', 'cid', 'cia', 'marshal', 'judge', 'doa' }
Config.Rob.PoliceAlertDuration = 4 * 60 * 1000 -- default duration (ms) for exports.AlertPolice when no duration is passed in

Config.Rob.Marker = {
	r = 0, g = 255, b = 0, a = 100,
	x = 0.5, y = 0.5, z = 0.5,
	DrawDistance = 15.0, Type = 6
}

Config.Rob.Robs = {
    ["Shop_1"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -43.217666625977, y = -1748.4660644531, z = 29.421022415161},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_2"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 28.13338, y = -1339.13, z = 29.49},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_3"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 1126.7266845703, y = -980.06903076172, z = 45.41577911377},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_4"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 1159.6395263672, y = -313.95556640625, z = 69.205047607422},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_5"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = 378.19546508789, y = 333.32019042969, z = 103.56635284424},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_6"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -1478.8537597656, y = -375.3415222168, z = 39.163391113281},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_7"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -1220.9096679688, y = -916.00067138672, z = 11.326328277588},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_8"] = {
        nameofrob = "Shop Robbery (Dakhel Shahr)",
        type = "Shop",
        position = { x = -709.58001708984, y = -904.08319091797, z = 19.215585708618},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_9"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 2549.3823242188, y = 384.84527587891, z = 108.62292480469},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_10"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 2672.8884277344, y = 3286.5727539063, z = 55.241123199463},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_11"] = {
        nameofrob = "Shop 2",
        type = "Shop",
        position = { x = 1959.2484130859, y = 3748.974609375, z = 32.343730926514},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_12"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1707.8781738281, y = 4920.267578125, z = 42.063678741455},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_13"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1734.8101806641, y = 6420.76953125, z = 35.037212371826},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_14"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = 1169.33203125, y = 2717.8833007813, z = 37.157711029053},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_15"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -3249.9362792969, y = 1004.3435058594, z = 12.8307056427},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_16"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -3047.7390136719, y = 585.63598632813, z = 7.908926486969},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_17"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -2959.6220703125, y = 387.05618286133, z = 14.043290138245},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Shop_18"] = {
        nameofrob = "Shop Robbery (Biron Shahr)",
        type = "Shop",
        position = { x = -1829.1010742188, y = 798.88848876953, z = 138.18865966797},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },

    ["Minibank_1"] = {
        nameofrob = "FleeccE Bank 1",
        type = "Minibank",
        position = vector3(312.7544, -288.8176, 54.14317),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Minibank_2"] = {
        nameofrob = "FleeccE Bank 2",
        type = "Minibank",
        position = vector3(-1206.687, -338.2508, 37.75944),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Minibank_3"] = {
        nameofrob = "FleeccE Bank 3",
        type = "Minibank",
        position = vector3(-352.1897, -59.35669, 49.01496),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Minibank_4"] = {
        nameofrob = "FleeccE Bank 4",
        type = "Minibank",
        position = vector3(1173.054, 2716.382, 38.06644),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Minibank_5"] = {
        nameofrob = "Bank Saheli",
        type = "Minibank",
        position = vector3(-2953.052, 484.5581, 15.67543),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },

    ["Jaw_Shahr"] = {
        nameofrob = "Jaw Shahr",
        type = "Jewerlly",
        position = { x = -631.35131835938, y = -229.70999145508, z = 38.057014465332},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Jaw_BironShahr"] = {
        nameofrob = "Jaw BironShahr",
        type = "Jewerlly",
        position = { x = 2742.3122558594, y = 3469.5939941406, z = 56.287113189697},
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Life_Invader"] = {
        nameofrob = "Life Invader",
        type = "Life_Invader",
        position = { x = -1056.8, y = -233.36, z = 44.02 },
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },
    ["Palateo_Bank"] = {
        nameofrob = "Bank Pelato",
        type = "Palateo_Bank",
        position = { x = -103.82, y = 6477.81, z = 31.36 },
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },

    -- Biggest heist in the system. Just a normal Robs entry like everything
    -- above -- it gets the same marker/blip/status-export treatment for
    -- free. Everything past the initial marker (travel to the rig, hack,
    -- guards, crates, escape) is handled by oilrig_client.lua and
    -- oilrig_server.lua, which plug into the SAME
    -- robberyNeeds/robberyCancel/robberySuccess pipeline every other rob
    -- type here uses -- hacktype 3 is reserved for it (see StartHack in
    -- client.lua and oilrig_client.lua).
    ["OilRig_1"] = {
        nameofrob = "Oil Rig Heist",
        type = "OilRig",
        position = vector3(346.798, 3405.46, 36.8516),
        lastRobbed = 0,
        available = true,
        someonerobbing = false,
    },

}

-- Maps each Config.Rob.Robs[x].type to a code from esx_uniquejobs'
-- law codebook (server/law_codebook.lua), so a successful robbery
-- auto-files the matching charge on the DOJ case opened for it.
-- §7 = Sereghat (Theft), §8 = Sereghat-e Mosallahane (Armed Theft),
-- §9 = Hamle-ye Dozdi / Grand Theft Auto, §13 = the Oil Rig's own,
-- heavier code (see esx_uniquejobs/server/law_codebook.lua).
Config.Rob.LawCode = {
    ["Shop"] = "§7",
    ["Minibank"] = "§8",
    ["Jewerlly"] = "§8",
    ["Life_Invader"] = "§9",
    ["Palateo_Bank"] = "§9",
    ["OilRig"] = "§13",
}

-- Rob types serious enough that catching the suspect auto-schedules a
-- /doj court hearing on the case (judge still runs it manually, this
-- just puts it on the docket instead of relying on someone remembering).
Config.Rob.CourtHearingTypes = {
    ["Life_Invader"] = true,
    ["Palateo_Bank"] = true,
    ["OilRig"] = true,
}
Config.Rob.CourtHearingMinutes = 45

Config.Rob.RobTypes ={
    ["Shop"] ={
        reward = {
            ["blackmoney"] = {min = 2500, max = 4000},
        },
        lessreward = {
            ["blackmoney"] = {min = 1500, max = 2000},
        },
        itemneed = {
        },
		successtime = 300,
        cooldown = 600,
        copsrequired = 3,
        cancelDistance = 20.0,
        lastRobbed = 0,
        blipsprite = 52,
        hacktype = 0,
        teammatesrequired = 0,
    },
    ["Minibank"] ={
        reward = {
            ["blackmoney"] = {min = 11500, max = 12400},
        },
        lessreward = {
            ["blackmoney"] = {min = 8500, max = 9500},
        },
        itemneed = {
            ["blowtorch"] = 1,
        },
		successtime = 600,
        cooldown = 1200,
        copsrequired = 5,
        cancelDistance = 20.0,
        lastRobbed = 0,
        blipsprite = 431,
        hacktype = 0,
        teammatesrequired = 4,
    },
    ["Jewerlly"] ={
        reward = {
            ["blackmoney"] = {min = 37000, max = 40000},
        },
        lessreward = {
            ["blackmoney"] = {min = 20000, max = 30000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 700,
        cooldown = 1200,
        copsrequired = 5,
        cancelDistance = 25.0,
        lastRobbed = 0,
        blipsprite = 617,
        hacktype = 1,
        teammatesrequired = 4,
    },
    ["Life_Invader"] ={
        reward = {
            ["blackmoney"] = {min = 40000, max = 50000},
        },
        lessreward = {
            ["blackmoney"] = {min = 25000, max = 35000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 1200,
        cooldown = 1800,
        copsrequired = 7,
        cancelDistance = 40.0,
        lastRobbed = 0,
        blipsprite = 77,
        hacktype = 2,
        teammatesrequired = 5,
    },
    ["Palateo_Bank"] ={
        reward = {
            ["blackmoney"] = {min = 1700000, max = 2500000},
        },
        lessreward = {
            ["blackmoney"] = {min = 400000, max = 500000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
		successtime = 1200,
        cooldown = 2100,
        copsrequired = 7,
        cancelDistance = 20.0,
        lastRobbed = 0,
        blipsprite = 207,
        hacktype = 2,
        teammatesrequired = 5,
    },
    -- Biggest heist. hacktype = 3 tells client.lua's StartHack dispatcher
    -- to hand off to oilrig_client.lua's own multi-phase flow (travel,
    -- laptop hack, guards, crates, escape) instead of firing a plain
    -- ps-ui minigame + the generic single-marker progress bar.
    -- reward.blackmoney below is the BASE range -- oilrig_server.lua
    -- scales it up at delivery time by online cops + party size
    -- (see Config.OilRig.scaling in oilrig_config.lua) before letting
    -- the normal robberySuccess handler pay it out.
    ["OilRig"] ={
        reward = {
            ["blackmoney"] = {min = 3000000, max = 4500000},
        },
        lessreward = {
            ["blackmoney"] = {min = 900000, max = 1300000},
        },
        itemneed = {
            ["laptophack"] = 1,
        },
        successtime = 2700, -- 45 min: how long this rob TYPE stays "in progress" for the generic re-start-cooldown check
        cooldown = 7200,    -- 2h location cooldown, same convention as everything else here
        copsrequired = 7,   -- BASE minimum to even start; more online cops = bigger reward + more guards, see scaling
        cancelDistance = 9999.0, -- unused (oilrig_client.lua doesn't call the generic StartProgressBar), kept for shape consistency
        lastRobbed = 0,
        blipsprite = 59, -- radar_heist: GTA's own dedicated "heist" icon (was 851, radar_oil_tanker -- fine but generic; this fits a heist specifically)
        hacktype = 3,
        teammatesrequired = 4, -- BASE minimum; larger party = more guards + bigger reward
    },
}

-------------------------------------------------------------------
-- GANG HEISTS (plan robberies)  - heist_server.lua / heist_client.lua / web/
--
-- Robbery TYPES listed in Plans.Requirements are "plan robberies". They are
-- NOT started by walking up to the marker any more: the gang's boss opens
-- Boss Menu > Robbery, sees the gang's plans (from the gang ARMORY) and
-- claims one robbery. First gang to claim it owns it for ClaimMinutes (7);
-- the plans are taken out of the armory when claiming. The gang then has to
-- go there with a party of the required size and press E like always.
-- Types that are NOT listed (Shop) work exactly like before.
-------------------------------------------------------------------
Config.Rob.Plans = {
    Items = { bronze = 'plan_bronze', silver = 'plan_silver', premium = 'plan_premium' },
    Labels = { bronze = 'Bronze', silver = 'Silver', premium = 'Premium' },
    Requirements = {
        -- type            = { tier, how many plans of that tier }
        -- Shop and Minibank (FleeccE 1-4, Bank Saheli) need NO plan: new gangs can always start with them.
        OilRig             = { tier = 'bronze',  count = 3 }, -- Oil Rig Heist ("air robbery" / AirPort)
        Jewerlly           = { tier = 'silver',  count = 2 }, -- Jaw Shahr, Jaw BironShahr
        Life_Invader       = { tier = 'premium', count = 5 }, -- Insurance (Bime)
        Palateo_Bank       = { tier = 'premium', count = 5 }, -- Bank Pelato
    },
}

Config.Heist = {
    Enabled          = true,

    ClaimMinutes     = 10,    -- time the claiming gang has to START the robbery (was 7; less pressure)
    RefundOnExpire   = 0.5,   -- share of the plans given back when the claim runs out unstarted (0-1)
    RefundOnCancel   = 0.5,   -- ...and when the boss cancels it
    ReclaimLockMinutes = 15,  -- after an expired/cancelled claim the same gang can't re-claim the same robbery for this long
                               -- (stops a gang parking on a robbery for free)
    CountersRequirePolice = true, -- can't claim unless enough police are online (the start check needs them anyway)

    -- Party: people in the party who DIE are thrown out of it.
    KickDeadFromParty = true,
    -- At the start marker, the leader's party must include at least `teammatesrequired`
    -- members of the CLAIMING gang (so a gang can't hand its claim to strangers).
    RequirePartyFromGang = true,

    -------------------------------------------------------------------
    -- ROBBERY LOTTERY (the "قرعه‌کشی" tab)
    -- The board runs in timed ROUNDS ("Robbery A", "Robbery B" ...). Each round
    -- shows PerRound plan robberies and goes through two phases:
    --   WAITING (WaitMinutes) : "not started yet" + countdown, nobody can request
    --   OPEN    (OpenMinutes) : the first gang whose boss requests a robbery gets it
    -- A request costs the plans (from the armory) AND gang POINTS (Cost below).
    -- Set Enabled = false to skip rounds: bosses can then request any plan
    -- robbery at any time (plans only, no points).
    -- MODEL: during OPEN, a boss adds a TICKET to a robbery ("افزودن پلن به قرعه‌کشی"):
    -- it costs the plans + the points below. When the round closes, one gang is
    -- drawn at random, weighted by its tickets. The winner gets the robbery (then
    -- must start it within ClaimMinutes); everybody else gets their plans and points back.
    -------------------------------------------------------------------
    Lottery = {
        Enabled      = true,
        WaitMinutes  = 5,
        OpenMinutes  = 15,
        PerRound     = 3,
        Names        = { 'A', 'B', 'C', 'D', 'E', 'F' },   -- round names repeat in this order
        -- points a request costs, per robbery TYPE (numbers from the reference menu)
        -- points per TICKET, scaled with what the robbery really pays
        -- (Jewelry ~38k, Life Invader ~45k, Bank Pelato ~2.1M, Oil Rig ~3.75M)
        Cost = { Jewerlly = 8, Life_Invader = 9, Palateo_Bank = 25, OilRig = 40 },
        DefaultCost = 10,
        -- FAIRNESS: a gang's chance grows with the SQUARE ROOT of its tickets, not
        -- linearly, and a gang can hold at most MaxTicketsPerGang tickets per robbery.
        -- 1 ticket vs 5 tickets -> 31% vs 69%  (linear would be 17% vs 83%).
        -- 1 ticket vs 10 tickets -> the 10 is capped at 5, so 31% vs 69%.
        -- Every gang that enters keeps a real chance; the menu shows the exact %.
        MaxTicketsPerGang = 5,
        -- COMEBACK: a gang that loses a draw it entered gets a bigger chance next time
        -- (+PityBonus per losing draw, up to PityMaxSteps; a win resets it). Keeps the
        -- lottery from feeling rigged against smaller gangs.
        PityBonus = 0.5,
        PityMaxSteps = 3,
    },

    -- Gang points: spent on requests, earned by playing. Points live in gang_heist_stats.
    Points = {
        Start     = 20,    -- a brand-new gang starts with this many (so it can request right away)
        RobberyWin = 3,    -- when a robbery's token is used (a counted WIN)
        -- CONSOLATION for a lost draw: the losing gangs that bought tickets get a small
        -- bonus of points ON TOP of their refund. Points are not money, so cash is never
        -- touched; the bonus is capped so points can not inflate:
        --   per draw, per gang : min(ConsolationMax, floor(ticket cost * tickets * Consolation))
        --   per gang per day   : ConsolationDailyMax
        Consolation         = 0.25,
        ConsolationMax      = 10,
        ConsolationDailyMax = 40,
        -- other resources add points with exports['Unique_AllRobs']:AddGangHeistPoints(gang, n, reason)
        -- (Unique_ALLGangs does: zone captures + Gang War wins, see their configs)
    },

    Token = {
        Item       = 'rob_token',  -- the ONE item a successful robbery gives (created by sql/Unique_RobPlans.sql)
        -- XP for the gang when the token is used: the gang gets the XP of the robbery's card
        -- (values in Unique_ALLGangs Config.GangXP.Cards). Set GiveXP = false to turn it off.
        GiveXP     = true,
        XPByRobType = { Shop = 'xpshop', Minibank = 'xpfleeca', Jewerlly = 'xpjewel', Life_Invader = 'xpbime', Palateo_Bank = 'xpbankp', OilRig = 'xprig' },
        -- old card items still sitting in players' inventories: still usable (XP only, no win)
        LegacyCards = { xpshop = true, xpfleeca = true, xpjewel = true, xpbime = true, xpbankp = true, xprig = true },
        UseMinutes = 30,           -- the winner must USE the token within this long ...
        GangTokens = 1,            -- ... gang tokens added to the gang balance when it is used
    },
    -- A won robbery only counts as a WIN once its token is used in time; if the time
    -- runs out it counts as a LOSS (and the unused token item stops working).

    Police = {
        Enabled = true,
        Radius  = 200.0,           -- police this close to the robbery when it succeeds are paid
        Pay     = 20000,           -- $ per police officer
        Account = 'bank',          -- 'bank' | 'money' (cash)
        -- how many officers can be paid at most, per robbery type (default = that type's copsrequired)
        MaxPaid = { Shop = 2 },
        -- where "around the robbery" is measured from, when it isn't the start marker
        -- (the Oil Rig's marker is a depot ~3km from the rig)
        Anchor  = { OilRig = vector3(-2736.0, 6598.0, 29.6) },
        -- Which robberies this applies to (plan robberies always; Shop too because police are dispatched there)
        Types   = { 'Shop', 'Minibank', 'Jewerlly', 'Life_Invader', 'Palateo_Bank', 'OilRig' },
    },
}
