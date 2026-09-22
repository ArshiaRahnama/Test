-- ============================================================
-- Unique_OilRig (merged into Unique_AllRobs)
--
-- The heist is registered as a normal entry in Config.Rob.Robs/RobTypes
-- (see config.lua, type "OilRig") so it shares the marker, blip,
-- cooldown, cops-required, party-required, police-alert, DOJ-case and
-- Discord-log conventions every other robbery here already has.
--
-- Everything in THIS file is data specific to running the heist itself
-- once robberyNeeds has already let the player start it: the rig
-- location, guards, crates, hack stages, how reward/guard-count scale
-- with online cops + party size, the escape phase, and rare loot.
-- ============================================================

Config.OilRig = {}

-- Once the leader is this close to the rig, the heist "arrives" --
-- dispatch is alerted (via the same SetAlarmPolice/CreateRob path every
-- other robbery uses), guards spawn, crates are picked, and the laptop
-- becomes hackable.
Config.OilRig.middleArea = vector3(-2736.2, 6597.84, 29.1568)
Config.OilRig.arriveRadius = 100.0

-- Purely decorative peds standing at the start marker
-- (Config.Rob.Robs.OilRig_1.position) -- the marker itself, from the
-- generic loop in client.lua, is what actually handles the interaction.
Config.OilRig.startPeds = {
    { pos = vector3(346.798, 3405.46, 36.8516), heading = 21.85,  ped = 's_m_m_highsec_01' },
    { pos = vector3(347.701, 3406.21, 36.4559), heading = 111.78, ped = 's_m_m_highsec_02' },
    { pos = vector3(345.771, 3405.33, 36.4573), heading = 292.42, ped = 's_m_m_fiboffice_02' },
}

-- Base blackmoney range before scaling (oilrig_server.lua's
-- oilrig:server:deliver multiplies these by online-cops + party-size).
-- Kept in sync with Config.Rob.RobTypes.OilRig.reward/lessreward in
-- config.lua, which is what actually gets paid (via the stock
-- robberySuccess handler) -- this is only the UNSCALED reference point.
Config.OilRig.rewardBase = {
    reward     = { min = 3000000, max = 4500000 },
    lessreward = { min = 900000,  max = 1300000 },
}

-- Server-side max interact distance for hacking/looting (ox_target itself
-- separately enforces ~1.5, this is the anti-cheat backstop).
Config.OilRig.interactDistance = 6.0

-- Safety valves independent of the shared cooldown -- if something goes
-- wrong (leader disconnects mid-hack, a zone gets stuck), the heist
-- resets itself instead of staying "someonerobbing" forever.
Config.OilRig.travelTimeout = 20 * 60   -- seconds the leader has to reach the rig after leaving the start marker
Config.OilRig.maxDuration   = 40 * 60   -- seconds, whole heist, from arrival to forced reset
Config.OilRig.cleanupDelay  = 3 * 60    -- seconds after delivery/failure before guards + zones are cleared

-- ------------------------------------------------------------------
-- Hack (ps-ui). ALL stages must be passed, same VarHack/Scrambler
-- functions Jewerlly (hacktype 1) and Life_Invader/Palateo_Bank
-- (hacktype 2) already use in client.lua's StartHack.
-- ------------------------------------------------------------------
Config.OilRig.hackStages = {
    { type = 'varhack',   blocks = 5, time = 20 },
    { type = 'scrambler', mode = 'alphanumeric', time = 30, mirrored = 0 },
}

-- ------------------------------------------------------------------
-- Scaling: more online cops and a bigger party both raise the reward
-- AND the number of guards. Multipliers are combined and then capped so
-- a slow night doesn't make the rig trivial and a packed server doesn't
-- make the payout absurd.
-- ------------------------------------------------------------------
Config.OilRig.scaling = {
    -- Reward: +10% per online cop, +5% per party member beyond the
    -- first, both capped. E.g. 10 cops + a 5-man crew = +100% +20%,
    -- capped at +150% total -> 2.5x the base blackmoney range.
    rewardPerCop         = 0.10,
    rewardPerPartyMember = 0.05,
    rewardMultiplierCap  = 2.5,

    -- Guards: start at guardsBase, +1 per cop beyond the RobTypes
    -- copsrequired baseline and +1 per party member beyond
    -- teammatesrequired, capped at however many guard spots exist below.
    guardsBase          = 10,
    extraGuardsPerCop    = 1,
    extraGuardsPerMember = 1,
}

-- ------------------------------------------------------------------
-- Guards -- up to 19 spots, `guardsBase` + scaling decides how many of
-- these actually get used each run (picked in order, front spots first).
-- ------------------------------------------------------------------
Config.OilRig.guards = {
    armour   = 100,
    accuracy = 50,
    guardRadius = 115.0,
    weapons = { 'WEAPON_PISTOL', 'WEAPON_ASSAULTSMG', 'WEAPON_ASSAULTRIFLE' },
    peds = {
        { coords = vector3(-2740.9, 6598.14, 29.6310), heading = 270.87, model = 'hc_driver' },
        { coords = vector3(-2736.3, 6592.37, 29.6306), heading = 177.93, model = 'csb_janitor' },
        { coords = vector3(-2729.8, 6597.79, 29.6301), heading = 354.93, model = 'hc_gunman' },
        { coords = vector3(-2736.7, 6604.00, 29.4214), heading = 177.88, model = 'hc_driver' },
        { coords = vector3(-2740.2, 6598.62, 25.0534), heading = 268.28, model = 'csb_janitor' },
        { coords = vector3(-2735.0, 6592.12, 25.0534), heading = 268.3,  model = 'hc_gunman' },
        { coords = vector3(-2730.2, 6596.66, 25.0534), heading = 359.44, model = 'csb_janitor' },
        { coords = vector3(-2733.3, 6589.02, 21.5044), heading = 265.05, model = 'hc_gunman' },
        { coords = vector3(-2727.4, 6596.52, 21.5044), heading = 174.77, model = 'hc_driver' },
        { coords = vector3(-2727.6, 6606.27, 21.5044), heading = 180.79, model = 'csb_janitor' },
        { coords = vector3(-2729.6, 6611.07, 15.2254), heading = 180.79, model = 'csb_janitor' },
        { coords = vector3(-2742.7, 6599.25, 15.2254), heading = 180.79, model = 'hc_gunman' },
        { coords = vector3(-2744.3, 6586.42, 15.2254), heading = 180.79, model = 'csb_janitor' },
        { coords = vector3(-2730.9, 6587.61, 15.2254), heading = 180.79, model = 'csb_janitor' },
        { coords = vector3(-2730.1, 6598.66, 12.2224), heading = 180.79, model = 'hc_gunman' },
        { coords = vector3(-2731.2, 6618.20, 25.8724), heading = 180.79, model = 'hc_driver' },
        { coords = vector3(-2736.8, 6617.62, 25.8724), heading = 180.79, model = 'csb_janitor' },
        { coords = vector3(-2716.8, 6578.35, 29.1484), heading = 180.79, model = 'hc_gunman' },
        { coords = vector3(-2718.0, 6584.74, 29.1484), heading = 180.79, model = 'csb_janitor' },
    },
}

-- ------------------------------------------------------------------
-- Crates -- small guaranteed flavor loot for WHOEVER loots each one
-- (unlike the main reward, which only goes to the leader who finishes
-- the escape -- same "leader gets the official payout" convention the
-- rest of Unique_AllRobs uses). Not gated by team membership: anyone
-- who made it past the guards to the crate can search it.
-- ------------------------------------------------------------------
Config.OilRig.crateCount   = 3
Config.OilRig.lootTime     = 5      -- seconds
Config.OilRig.revealRadius = 5.0    -- GPS circle shown after a successful hack

Config.OilRig.crateRewards = {
    { item = 'gold',   min = 1, max = 3, chance = 60 },
    { item = 'diamond', min = 1, max = 2, chance = 40 },
    { item = 'coin',   min = 5, max = 15, chance = 80 },
}

Config.OilRig.crates = {
    { coords = vector3(-2739.6, 6608.67, 15.0348), heading = 59.0 },
    { coords = vector3(-2717.7, 6610.90, 21.7323), heading = 0.0  },
    { coords = vector3(-2722.3, 6611.42, 21.7416), heading = 90.0 },
    { coords = vector3(-2723.6, 6614.66, 21.7416), heading = 90.0 },
    { coords = vector3(-2728.0, 6599.0,  21.7416), heading = 0.0  },
    { coords = vector3(-2724.9, 6595.0,  21.7416), heading = 0.0  },
    { coords = vector3(-2724.9, 6590.67, 21.9416), heading = 90.0 },
    { coords = vector3(-2739.1, 6609.55, 21.7416), heading = 90.0 },
    { coords = vector3(-2730.4, 6615.08, 25.9878), heading = 0.0  },
    { coords = vector3(-2728.3, 6615.11, 25.9878), heading = 0.0  },
}

Config.OilRig.laptop = { coords = vector3(-2732.5, 6621.41, 25.4206), heading = 0.0 }

-- ------------------------------------------------------------------
-- Escape phase: after the last crate is looted, the leader gets a heavy
-- cash bag and must carry it to the dropoff. A second, urgent police
-- alert fires if delivery hasn't happened `pursuitDelay` seconds after
-- the escape begins, aimed at the carrier's live position.
-- ------------------------------------------------------------------
Config.OilRig.escape = {
    bagItem       = 'oilrig_cash_bag',
    dropoff       = vector3(-2196.1, 3243.5, 32.81), -- Paleto Bay chop-shop-style spot; change to whatever fits your map
    dropRadius    = 8.0,
    speedMultiplier = 0.75, -- while carrying the bag
    pursuitDelay  = 2 * 60, -- seconds after escape starts before the second alert fires
    timeLimit     = 8 * 60, -- seconds to deliver before the bag (and the heist) is lost
}

-- Rolled independently at successful delivery, on top of the normal
-- blackmoney/xprig reward (which goes through the shared robberySuccess
-- handler). Each of these needs a matching row in `items` -- see
-- sql/Unique_OilRig_Merge.sql.
Config.OilRig.rareLoot = {
    { item = 'weapon_crate_rifle', chance = 8,  label = 'Jعbe-ye Aslahe' },
    { item = 'heavy_armor',        chance = 12, label = 'Zereh-e Sangin' },
    { item = 'oilrig_relic',       chance = 3,  label = 'Ashyaye Kamyab' },
}

-- Evidence scattered by the crime-scene system (Config_cs.EvidenceCountByFamily.OilRig
-- in esx_uniquejobs/cad/config_crimescene.lua) already uses evidence_print/
-- evidence_casing generically for every family -- nothing OilRig-specific
-- needed there beyond the family count, already added.

Config.OilRig.strings = {
    heist_info    = 'Ba Team Be Mahale Alamat Shode Roye GPS Beravid. Aslahe Va Zereh Ziad Ba Khod Bebarid.',
    arrived       = 'Negahban Ha Amade Shodand! Laptop Ra Hack Konid.',
    hack_busy     = 'Kasi Dar Hale Hack Kardane Laptop Ast.',
    hack_first    = 'Aval Bayad Laptop Ra Hack Konid!',
    hack_ok       = 'Hack Movafagh Bud! Sandogh Ha Roye GPS Alamat Khordand.',
    hack_fail     = 'Hack Na Movafagh Bud. Laptop Dobare Faal Shod.',
    crate_taken   = 'Fardi Dar Hale Jamavari In Sandogh Ast.',
    got_bag       = 'Kif-e Pool Ra Bardashtid! Sari-tar Az Dast Police Farar Konid.',
    escape_info   = 'Kif Sangin Ast, Sor\'atetun Kamtar Shode. Be Mahale Taslim Roye GPS Beravid.',
    pursuit_alert = 'Sareghan-e Oil Rig Dar Hale Farar Hastand!',
    delivered     = 'Kif Taslim Shod! Ganimat Be Shoma Reside.',
    lost_bag      = 'Vaghte Farar Tamoom Shod, Kif Az Dast Raft.',
    all_looted    = 'Hameye Sandogh Ha Khali Shodand. Kif Ra Bardarid Va Farar Konid!',
}
