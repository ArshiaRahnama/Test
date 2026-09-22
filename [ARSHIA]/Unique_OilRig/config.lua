Config = {}

-- ======================================================================
-- TEST MODE  (solo testing on localhost)
-- true  = skips: cops required, /party + teammates, cooldown, police/off-duty job
--         block, armed check and the laptophack item (nothing is consumed).
--         Also enables /oiltp start|rig to teleport around.
-- false = normal rules. MUST be false on the live server.
-- ======================================================================
Config.TestMode = true

-- Jobs that are treated as police everywhere in this script
-- (same list as Config.Rob.PoliceJobs in Unique_AllRobs).
Config.PoliceJobs = { 'police', 'sheriff', 'fbi', 'mt', 'cid', 'cia', 'marshal', 'judge', 'doa' }

-- Jobs that must go OFF DUTY (change job) before they can take part
-- (same rule Unique_AllRobs applies to its robberies).
Config.BlockedJobs = { 'ambulance', 'taxi', 'mechanic' }

Config.OilRig = {
    -- ------------------------------------------------------------------
    -- Requirements to START the heist (all checked on the SERVER)
    -- ------------------------------------------------------------------
    copsRequired      = 7,      -- online police-jobs needed (Life_Invader in Unique_AllRobs uses 7)
    teammatesRequired = 4,      -- /party size needed, leader included. 0 = no party needed
    teamMaxDistance   = 10.0,   -- party members must be this close to the leader when starting
    requireArmed      = true,   -- must hold a gun when talking to the start ped (same as Unique_AllRobs)
    cooldown          = 7200,   -- seconds, whole server, counted from the moment the heist starts
    maxDuration       = 45 * 60,-- seconds. After this the heist is force-reset (guards deleted, zones removed)
    travelTimeout     = 20 * 60,-- seconds the leader has to reach the rig. If not, heist is cancelled + cooldown refunded
    cleanupAfterDone  = 5 * 60, -- seconds after the last crate is looted before guards are deleted

    -- Item needed to hack the laptop. 'laptophack' already exists in the items table.
    requiredItem = 'laptophack',
    consumeItem  = true,        -- remove 1 on every hack attempt (Unique_AllRobs does the same with itemneed)

    -- true  = crates only become searchable AFTER the laptop is hacked (hack actually matters)
    -- false = crates are searchable right away, hack only draws the GPS circles (original behaviour)
    requireHackForLoot = true,

    -- ------------------------------------------------------------------
    -- Start location (peds + target)
    -- ------------------------------------------------------------------
    startHeist = {
        pos = vector3(346.798, 3405.46, 36.8516),
        peds = {
            { pos = vector3(346.798, 3405.46, 36.8516), heading = 21.85,  ped = 's_m_m_highsec_01' },
            { pos = vector3(347.701, 3406.21, 36.4559), heading = 111.78, ped = 's_m_m_highsec_02' },
            { pos = vector3(345.771, 3405.33, 36.4573), heading = 292.42, ped = 's_m_m_fiboffice_02' },
        },
    },

    -- ------------------------------------------------------------------
    -- Oil rig
    -- ------------------------------------------------------------------
    middleArea   = vector3(-2736.2, 6597.84, 29.1568),
    arriveRadius = 100.0,       -- guards / crates / dispatch alert trigger when the leader gets this close
    interactDistance = 6.0,     -- server-side max distance for hacking / looting (ox_target itself uses 1.5)

    alertDuration = 4 * 60 * 1000, -- ms, police blip lifetime (Unique_AllRobs:AlertPolice)
    alertRadius   = 120.0,         -- map circle radius

    -- ------------------------------------------------------------------
    -- Hack: sequence of ps-ui minigames. ALL stages must be passed.
    --   varhack  : { blocks = 5, time = 20 }
    --   scrambler: { mode = 'alphanumeric', time = 30, mirrored = 0 }
    --   circle   : { circles = 3, time = 10 }
    --   maze     : { time = 30 }
    -- ------------------------------------------------------------------
    hack = {
        stages = {
            { type = 'varhack',   blocks = 5, time = 20 },
            { type = 'scrambler', mode = 'alphanumeric', time = 30, mirrored = 0 },
        },
    },

    -- ------------------------------------------------------------------
    -- Crates
    -- ------------------------------------------------------------------
    crateCount  = 3,            -- how many of the crate spots are filled each heist (max = #crates)
    lootTime    = 5,            -- seconds
    revealRadius = 5.0,         -- GPS circle radius shown to the hacker + party after a successful hack

    -- Rolled once per crate, for every entry. Items must exist in the `items` table.
    -- 'blackmoney' is the item Unique_AllRobs pays with. TUNE THESE for your economy.
    crateRewards = {
        { item = 'blackmoney', min = 15000, max = 25000, chance = 100 },
        { item = 'gold',       min = 1,     max = 3,     chance = 60  },
        { item = 'diamond',    min = 1,     max = 2,     chance = 40  },
    },

    guards = {
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
    },

    crates = {
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
    },

    laptop = { coords = vector3(-2732.5, 6621.41, 25.4206), heading = 0.0 },
}

-- Messages (Finglish, same style as Unique_AllRobs)
Config.Strings = {
    wrong_world      = 'Shoma Dar Worlde Asli Nistid !!',
    police_cant      = 'Azaye Organ Haye Nezami Tavanayi In Kar Ra Nadarand .',
    off_duty         = 'Baraye In Kar Shoma Bayad OFF DUTY Bashid .',
    need_weapon      = 'Shoma Aslahe Dar Dast Nadarid !',
    in_progress      = 'Oil Rig Heist Alan Dar Jarian Ast .',
    cooldown         = 'Oil Rig Dar Cooldown Ast Lotfan %d Daghighe Sabr Konid',
    need_police      = 'Baraye Starte Oil Rig Bayad Hadaghal %d Police Dar Shahr Bashad',
    need_party       = 'Baraye Starte Oil Rig Shoma Bayad Dar Team Bashid! /party',
    need_leader      = 'Shoma Bayad Leader Team Bashid !',
    need_members     = 'Shoma Bayad Hadaghal %d Nafar Dar Team Bashid !',
    members_far      = 'Afrade Dakhele Team Az Shoma Door Hastand !',
    party_down       = 'Sisteme Party Dar Dastres Nist, Baadan Talash Konid .',
    heist_started    = 'Oil Rig Heist Start Shod !',
    heist_info       = 'Ba Team Be Mahale Alamat Shode Roye GPS Beravid. Aslahe Va Zereh Ziad Ba Khod Bebarid.',
    arrived          = 'Negahban Ha Amade Shodand ! Laptop Ra Hack Konid.',
    need_item        = 'Baraye Hack Bayad Yek %s Dashte Bashid .',
    hack_busy        = 'Kasi Dar Hale Hack Kardane Laptop Ast .',
    hack_first       = 'Aval Bayad Laptop Ra Hack Konid !',
    hack_ok          = 'Hack Movafagh Bud ! Sandogh Ha Roye GPS Alamat Khordand .',
    hack_fail        = 'Hack Na Movafagh Bud . Laptop Dobare Faal Shod .',
    crate_taken      = 'Fardi Dar Hale Jamavari In Sandogh Ast .',
    all_looted       = 'Hameye Sandogh Ha Khali Shodand . Zood Az Rig Kharej Shavid !',
    reset            = 'Oil Rig Heist Reset Shod .',
    aborted          = 'Oil Rig Heist Cancel Shod .',
    not_cop          = 'Shoma Police Nistid !',
    looting          = 'LOOTING',
    police_alert     = 'Sareghate Oil Rig Dar Jarian Ast !',
    oilrig_blip      = 'Oil Rig',
    got_item         = 'Shoma %s x%d Gereftid',

    t_heist  = 'Oil Rig Heist',
    t_search = 'Search Crate',
    t_laptop = 'Hack Laptop',
}
