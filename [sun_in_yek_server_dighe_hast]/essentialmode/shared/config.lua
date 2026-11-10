-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX.blockedItems = { -- ghabele enteghal nist - soulbound
    customtoken = true,
    zombie_head = true,
    decals_m_174_0 = true,
    decals_f_178_0 = true,
    decals_m_181_0 = true,
    decals_m_183_0 = true,

    WEAPON_LUCILLE = true,
    WEAPON_KATANA = true,
    WEAPON_KATANA2 = true,

    persuit_1 = true,
    darktape = true,

    speaker = true,
    tvpub = true,

    sim_912 = true,
    sim_913 = true,
    sim_915 = true,
    sim_917 = true,
    sim_910 = true,
    sim_930 = true,

    chests_1 = true,
    chests_2 = true,
    chests_3 = true,
    chests_4 = true,
}

ESX.blockedItemsJob = {
    -- ['phone'] = {
    --     'police',
    -- }
}

ESX.protectedItems = { -- ba newlife napare - search nemishe
    boombox = true,
    asa = true,
    customtoken = true,
    weapon_sniperrifle = true,
    weapon_heavysniper_mk2 = true,
    WEAPON_LUCILLE = true,
    WEAPON_KATANA = true,
    WEAPON_KATANA2 = true,

    speaker = true,
    weapon_minigun = true,
    zombie_head = true,
    sun_hookah_1 = true,

    persuit_1 = true,
    darktape = true,

    decals_m_174_0 = true,
    decals_f_178_0 = true,
    decals_m_181_0 = true,
    decals_m_183_0 = true,

    sim_912 = true,
    sim_913 = true,
    sim_915 = true,
    sim_917 = true,
    sim_910 = true,
    sim_930 = true,
}

ESX.blockedItemButCanGive = { -- can give
    persuit_1 = true,

    chests_1 = true,
    chests_2 = true,
    chests_3 = true,
    chests_4 = true,
}

ESX.tempItems = {  -- ba reset mipare
    persuit_1 = true,
    darktape = true,

    chests_1 = true,
    chests_2 = true,
    chests_3 = true,
    chests_4 = true,
}

ESX.blackListSearch = {
    kit50 = true,
    kit100 = true,
    kittire = true,
    cleaner = true,
    adrenaline = true,
    medikit = true,
    bandage = true,
    jack = true,
    compass = true,

    sim_912 = true,
    sim_913 = true,
    sim_915 = true,
    sim_917 = true,
    sim_910 = true,
    sim_930 = true,
    sim_982 = true,
}

ESX.tintsLabel = {
    [1] = 'Skin Sabz',
    [2] = 'Skin Talee',
    [3] = 'Skin Surati',
    [4] = 'Skin Cream',
    [5] = 'Skin Meshki',
    [6] = 'Skin Nareji',
    [7] = 'Skin Plat',
}

ESX.basicJobs = {
    wash = true,
    carbimeh = true,
    resturan = true,
}

ESX.meleeWeapons = {
    [`weapon_unarmed`] = true,
    [`weapon_bat`] = true,
    [`weapon_bottle`] = true,
    [`weapon_crowbar`] = true,
    [`weapon_flashlight`] = true,
    [`weapon_golfclub`] = true,
    [`weapon_hammer`] = true,
    [`weapon_hatchet`] = true,
    [`weapon_knuckle`] = true,
    [`weapon_knife`] = true,
    [`weapon_machete`] = true,
    [`weapon_switchblade`] = true,
    [`weapon_nightstick`] = true,
    [`weapon_wrench`] = true,
    [`weapon_battleaxe`] = true,
    [`weapon_poolcue`] = true,
    [`weapon_stone_hatchet`] = true,
}

ESX.unarmedWeapons = {
    [`weapon_unarmed`] = true,
    [`WEAPON_OBJECT`] = true,
}

ESX.militaryJobs = {
    police = true,
    sheriff = true,
    mt = true,
    detective = true,
    fbi = true,
    justice = true,
    offpolice = true,
    offsheriff = true,
    offmt = true,
    offdetective = true,
    offfbi = true,
    offjustice = true,
}

ESX.militaryJobs2 = {
    police = true,
    sheriff = true,
    mt = true,
    detective = true,
    fbi = true,
    justice = true,
}

ESX.jobsGang = {
	TX = true,
	Army = true,
	Mechanics = true,
	Weazels = true,
	Medics = true,
    D_O_J = true, 
}

ESX.jobs2 = {
    police = true,
    sheriff = true,
    mt = true,
    detective = true,
    fbi = true,
    justice = true,
    ambulance = true,
    taxi = true,
    mechanic = true,
    weazel = true,
}


ESX.lang = {
    missing = 'Maghadir vorudi kamel nist!',
    spam = 'In action dar cooldown ast, sabur bashid.',
    full = 'Jib shoma fazaye kafi nadarad!',
    notEnough = 'Be tedad kafi az in item mojoud nist.',
    bagFull = 'Had aksar yek kif mitavanid dar inja gozasht.',
    perm = 'Shoma dastresi kafi nadarid!',
    noPlayer = 'Fard mored nazar dar server nist.',
    cant = 'In farayand ghabel anjam nist.',
}

ESX.dropWeaponReward = {
    ['WEAPON_KNIFE'] = {
        police    = { player = 1000, job = 1350 },
        sheriff   = { player = 1000, job = 1350 },
        mt        = { player = 1000, job = 1350 },
        detective = { player = 1000, job = 1350 },
        justice   = { player = 0,    job = 0    },
    },
    ['WEAPON_DAGGER'] = {
        police    = { player = 1000, job = 1200 },
        sheriff   = { player = 1000, job = 1200 },
        mt        = { player = 1000, job = 1200 },
        detective = { player = 1000, job = 1200 },
        justice   = { player = 0,    job = 0    },
    },
    ['WEAPON_MACHETE'] = {
        police    = { player = 1000, job = 1800 },
        sheriff   = { player = 1000, job = 1800 },
        mt        = { player = 1000, job = 1800 },
        detective = { player = 1000, job = 1800 },
        justice   = { player = 0,    job = 0    },
    },
    ['WEAPON_VINTAGEPISTOL'] = {
        police    = { player = 1367, job = 4100 },
        sheriff   = { player = 1367, job = 4100 },
        mt        = { player = 1367, job = 4100 },
        detective = { player = 1367, job = 4100 },
        justice   = { player = 1367, job = 4100 },
    },
    ['WEAPON_PISTOL'] = {
        police    = { player = 1000, job = 2600 },
        sheriff   = { player = 1000, job = 2600 },
        mt        = { player = 1000, job = 2600 },
        detective = { player = 1000, job = 2600 },
        justice   = { player = 1000, job = 2600 },
    },
    ['WEAPON_SNSPISTOL'] = {
        police    = { player = 1000, job = 2000 },
        sheriff   = { player = 1000, job = 2000 },
        mt        = { player = 1000, job = 2000 },
        detective = { player = 1000, job = 2000 },
        justice   = { player = 1000, job = 2000 },
    },
    ['WEAPON_HEAVYPISTOL'] = {
        police    = { player = 1700, job = 5100 },
        sheriff   = { player = 1700, job = 5100 },
        mt        = { player = 1700, job = 5100 },
        detective = { player = 1700, job = 5100 },
        justice   = { player = 1700, job = 5100 },
    },
    ['WEAPON_COMBATPISTOL'] = {
        police    = { player = 1000, job = 3000 },
        sheriff   = { player = 1000, job = 3000 },
        mt        = { player = 1000, job = 3000 },
        detective = { player = 1000, job = 3000 },
        justice   = { player = 1000, job = 3000 },
    },
    ['WEAPON_PISTOL50'] = {
        police    = { player = 2167, job = 6500 },
        sheriff   = { player = 2167, job = 6500 },
        mt        = { player = 2167, job = 6500 },
        detective = { player = 2167, job = 6500 },
        justice   = { player = 2167, job = 6500 },
    },
    ['WEAPON_SMG'] = {
        police    = { player = 2400, job = 7200 },
        sheriff   = { player = 2400, job = 7200 },
        mt        = { player = 2400, job = 7200 },
        detective = { player = 2400, job = 7200 },
        justice   = { player = 2400, job = 7200 },
    },
    ['WEAPON_SNSPISTOL_MK2'] = {
        police    = { player = 1000, job = 2400 },
        sheriff   = { player = 1000, job = 2400 },
        mt        = { player = 1000, job = 2400 },
        detective = { player = 1000, job = 2400 },
        justice   = { player = 1000, job = 2400 },
    },
    ['WEAPON_ASSAULTSMG'] = {
        police    = { player = 2733, job = 8200 },
        sheriff   = { player = 2733, job = 8200 },
        mt        = { player = 2733, job = 8200 },
        detective = { player = 2733, job = 8200 },
        justice   = { player = 2733, job = 8200 },
    },
    ['WEAPON_CARBINERIFLE'] = {
        police    = { player = 3667, job = 10000 },
        sheriff   = { player = 3667, job = 10000 },
        mt        = { player = 3667, job = 10000 },
        detective = { player = 3667, job = 10000 },
        justice   = { player = 3667, job = 10000 },
    },
    ['WEAPON_ASSAULTRIFLE'] = {
        police    = { player = 3000, job = 9000 },
        sheriff   = { player = 3000, job = 9000 },
        mt        = { player = 3000, job = 9000 },
        detective = { player = 3000, job = 9000 },
        justice   = { player = 3000, job = 9000 },
    },
    ['WEAPON_ADVANCEDRIFLE'] = {
        police    = { player = 4167, job = 10000 },
        sheriff   = { player = 4167, job = 10000 },
        mt        = { player = 4167, job = 10000 },
        detective = { player = 4167, job = 10000 },
        justice   = { player = 4167, job = 10000 },
    },
    ['WEAPON_COMBATPDW'] = {
        police    = { player = 2000, job = 6000 },
        sheriff   = { player = 2000, job = 6000 },
        mt        = { player = 2000, job = 6000 },
        detective = { player = 2000, job = 6000 },
        justice   = { player = 2000, job = 6000 },
    },
    ['WEAPON_BULLPUPRIFLE'] = {
        police    = { player = 3167, job = 9500 },
        sheriff   = { player = 3167, job = 9500 },
        mt        = { player = 3167, job = 9500 },
        detective = { player = 3167, job = 9500 },
        justice   = { player = 3167, job = 9500 },
    },
    ['WEAPON_GUSENBERG'] = {
        police    = { player = 4000, job = 10000 },
        sheriff   = { player = 4000, job = 10000 },
        mt        = { player = 4000, job = 10000 },
        detective = { player = 4000, job = 10000 },
        justice   = { player = 4000, job = 10000 },
    },
    ['WEAPON_ASSAULTSHOTGUN'] = {
        police    = { player = 4167, job = 10000 },
        sheriff   = { player = 4167, job = 10000 },
        mt        = { player = 4167, job = 10000 },
        detective = { player = 4167, job = 10000 },
        justice   = { player = 4167, job = 10000 },
    },
    ['WEAPON_BULLPUPSHOTGUN'] = {
        police    = { player = 5000, job = 10000 },
        sheriff   = { player = 5000, job = 10000 },
        mt        = { player = 5000, job = 10000 },
        detective = { player = 5000, job = 10000 },
        justice   = { player = 5000, job = 10000 },
    },
    ['WEAPON_SAWNOFFSHOTGUN'] = {
        police    = { player = 5433, job = 10000 },
        sheriff   = { player = 5433, job = 10000 },
        mt        = { player = 5433, job = 10000 },
        detective = { player = 5433, job = 10000 },
        justice   = { player = 5433, job = 10000 },
    },
    ['WEAPON_PUMPSHOTGUN'] = {
        police    = { player = 6267, job = 10000 },
        sheriff   = { player = 6267, job = 10000 },
        mt        = { player = 6267, job = 10000 },
        detective = { player = 6267, job = 10000 },
        justice   = { player = 6267, job = 10000 },
    },
    ['WEAPON_KNUCKLE'] = {
        police    = { player = 1000, job = 3000 },
        sheriff   = { player = 1000, job = 3000 },
        mt        = { player = 1000, job = 3000 },
        detective = { player = 1000, job = 3000 },
        justice   = { player = 0,    job = 0    },
    },
    ['WEAPON_PISTOL_MK2'] = {
        police    = { player = 1267, job = 3800 },
        sheriff   = { player = 1267, job = 3800 },
        mt        = { player = 1267, job = 3800 },
        detective = { player = 1267, job = 3800 },
        justice   = { player = 1267, job = 3800 },
    },
    ['WEAPON_SPECIALCARBINE'] = {
        police    = { player = 3667, job = 10000 },
        sheriff   = { player = 3667, job = 10000 },
        mt        = { player = 3667, job = 10000 },
        detective = { player = 3667, job = 10000 },
        justice   = { player = 3667, job = 10000 },
    },
    ['WEAPON_CERAMICPISTOL'] = {
        police    = { player = 1167, job = 3500 },
        sheriff   = { player = 1167, job = 3500 },
        mt        = { player = 1167, job = 3500 },
        detective = { player = 1167, job = 3500 },
        justice   = { player = 1167, job = 3500 },
    },
    ['WEAPON_PUMPSHOTGUN_MK2'] = {
        police    = { player = 5833, job = 10000 },
        sheriff   = { player = 5833, job = 10000 },
        mt        = { player = 5833, job = 10000 },
        detective = { player = 5833, job = 10000 },
        justice   = { player = 5833, job = 10000 },
    },
    ['WEAPON_BULLPUPRIFLE_MK2'] = {
        police    = { player = 4667, job = 10000 },
        sheriff   = { player = 4667, job = 10000 },
        mt        = { player = 4667, job = 10000 },
        detective = { player = 4667, job = 10000 },
        justice   = { player = 4667, job = 10000 },
    },
    ['WEAPON_DOUBLEACTION'] = {
        police    = { player = 2400, job = 7200 },
        sheriff   = { player = 2400, job = 7200 },
        mt        = { player = 2400, job = 7200 },
        detective = { player = 2400, job = 7200 },
        justice   = { player = 2400, job = 7200 },
    },
    ['WEAPON_SMG_MK2'] = {
        police    = { player = 3333, job = 10000 },
        sheriff   = { player = 3333, job = 10000 },
        mt        = { player = 3333, job = 10000 },
        detective = { player = 3333, job = 10000 },
        justice   = { player = 3333, job = 10000 },
    },
    ['WEAPON_COMPACTRIFLE'] = {
        police    = { player = 2667, job = 8000 },
        sheriff   = { player = 2667, job = 8000 },
        mt        = { player = 2667, job = 8000 },
        detective = { player = 2667, job = 8000 },
        justice   = { player = 2667, job = 8000 },
    },
    ['WEAPON_SPECIALCARBINE_MK2'] = {
        police    = { player = 4500, job = 10000 },
        sheriff   = { player = 4500, job = 10000 },
        mt        = { player = 4500, job = 10000 },
        detective = { player = 4500, job = 10000 },
        justice   = { player = 4500, job = 10000 },
    },
    ['WEAPON_MICROSMG'] = {
        police    = { player = 3467, job = 10000 },
        sheriff   = { player = 3467, job = 10000 },
        mt        = { player = 3467, job = 10000 },
        detective = { player = 3467, job = 10000 },
        justice   = { player = 3467, job = 10000 },
    },
    ['WEAPON_ASSAULTRIFLE_MK2'] = {
        police    = { player = 3833, job = 10000 },
        sheriff   = { player = 3833, job = 10000 },
        mt        = { player = 3833, job = 10000 },
        detective = { player = 3833, job = 10000 },
        justice   = { player = 3833, job = 10000 },
    },
    ['WEAPON_CARBINERIFLE_MK2'] = {
        police    = { player = 4500, job = 10000 },
        sheriff   = { player = 4500, job = 10000 },
        mt        = { player = 4500, job = 10000 },
        detective = { player = 4500, job = 10000 },
        justice   = { player = 4500, job = 10000 },
    },
    ['WEAPON_APPISTOL'] = {
        police    = { player = 3333, job = 10000 },
        sheriff   = { player = 3333, job = 10000 },
        mt        = { player = 3333, job = 10000 },
        detective = { player = 3333, job = 10000 },
        justice   = { player = 3333, job = 10000 },
    },
    ['WEAPON_GADGETPISTOL'] = {
        police    = { player = 2233, job = 6700 },
        sheriff   = { player = 2233, job = 6700 },
        mt        = { player = 2233, job = 6700 },
        detective = { player = 2233, job = 6700 },
        justice   = { player = 2233, job = 6700 },
    },
    ['WEAPON_COMBATSHOTGUN'] = {
        police    = { player = 4600, job = 10000 },
        sheriff   = { player = 4600, job = 10000 },
        mt        = { player = 4600, job = 10000 },
        detective = { player = 4600, job = 10000 },
        justice   = { player = 4600, job = 10000 },
    },
    ['WEAPON_MILITARYRIFLE'] = {
        police    = { player = 4000, job = 10000 },
        sheriff   = { player = 4000, job = 10000 },
        mt        = { player = 4000, job = 10000 },
        detective = { player = 4000, job = 10000 },
        justice   = { player = 4000, job = 10000 },
    },
    ['WEAPON_MARKSMANPISTOL'] = {
        police    = { player = 1467, job = 4400 },
        sheriff   = { player = 1467, job = 4400 },
        mt        = { player = 1467, job = 4400 },
        detective = { player = 1467, job = 4400 },
        justice   = { player = 1467, job = 4400 },
    },
    ['WEAPON_NAVYREVOLVER'] = {
        police    = { player = 1600, job = 4800 },
        sheriff   = { player = 1600, job = 4800 },
        mt        = { player = 1600, job = 4800 },
        detective = { player = 1600, job = 4800 },
        justice   = { player = 1600, job = 4800 },
    },
    ['WEAPON_PISTOLXM3'] = {
        police    = { player = 1100, job = 3300 },
        sheriff   = { player = 1100, job = 3300 },
        mt        = { player = 1100, job = 3300 },
        detective = { player = 1100, job = 3300 },
        justice   = { player = 1100, job = 3300 },
    },
    ['WEAPON_REVOLVER'] = {
        police    = { player = 1933, job = 5800 },
        sheriff   = { player = 1933, job = 5800 },
        mt        = { player = 1933, job = 5800 },
        detective = { player = 1933, job = 5800 },
        justice   = { player = 1933, job = 5800 },
    },
    ['WEAPON_REVOLVER_MK2'] = {
        police    = { player = 1800, job = 5400 },
        sheriff   = { player = 1800, job = 5400 },
        mt        = { player = 1800, job = 5400 },
        detective = { player = 1800, job = 5400 },
        justice   = { player = 1800, job = 5400 },
    },
    ['WEAPON_TACTICALRIFLE'] = {
        police    = { player = 3667, job = 10000 },
        sheriff   = { player = 3667, job = 10000 },
        mt        = { player = 3667, job = 10000 },
        detective = { player = 3667, job = 10000 },
        justice   = { player = 3667, job = 10000 },
    },
    ['WEAPON_HEAVYRIFLE'] = {
        police    = { player = 2833, job = 8500 },
        sheriff   = { player = 2833, job = 8500 },
        mt        = { player = 2833, job = 8500 },
        detective = { player = 2833, job = 8500 },
        justice   = { player = 2833, job = 8500 },
    },
    ['WEAPON_DBSHOTGUN'] = {
        police    = { player = 6667, job = 10000 },
        sheriff   = { player = 6667, job = 10000 },
        mt        = { player = 6667, job = 10000 },
        detective = { player = 6667, job = 10000 },
        justice   = { player = 6667, job = 10000 },
    },
    ['WEAPON_AUTOSHOTGUN'] = {
        police    = { player = 3767, job = 10000 },
        sheriff   = { player = 3767, job = 10000 },
        mt        = { player = 3767, job = 10000 },
        detective = { player = 3767, job = 10000 },
        justice   = { player = 3767, job = 10000 },
    },
    ['WEAPON_HEAVYSHOTGUN'] = {
        police    = { player = 3333, job = 10000 },
        sheriff   = { player = 3333, job = 10000 },
        mt        = { player = 3333, job = 10000 },
        detective = { player = 3333, job = 10000 },
        justice   = { player = 3333, job = 10000 },
    },
    ['WEAPON_MACHINEPISTOL'] = {
        police    = { player = 2533, job = 7600 },
        sheriff   = { player = 2533, job = 7600 },
        mt        = { player = 2533, job = 7600 },
        detective = { player = 2533, job = 7600 },
        justice   = { player = 2533, job = 7600 },
    },
    ['WEAPON_MINISMG'] = {
        police    = { player = 3767, job = 10000 },
        sheriff   = { player = 3767, job = 10000 },
        mt        = { player = 3767, job = 10000 },
        detective = { player = 3767, job = 10000 },
        justice   = { player = 3767, job = 10000 },
    },
    ['WEAPON_TECPISTOL'] = {
        police    = { player = 2133, job = 6400 },
        sheriff   = { player = 2133, job = 6400 },
        mt        = { player = 2133, job = 6400 },
        detective = { player = 2133, job = 6400 },
        justice   = { player = 2133, job = 6400 },
    },
    ['WEAPON_MG'] = {
        police    = { player = 4000, job = 10000 },
        sheriff   = { player = 4000, job = 10000 },
        mt        = { player = 4000, job = 10000 },
        detective = { player = 4000, job = 10000 },
        justice   = { player = 4000, job = 10000 },
    },
    ['WEAPON_COMBATMG'] = {
        police    = { player = 4667, job = 10000 },
        sheriff   = { player = 4667, job = 10000 },
        mt        = { player = 4667, job = 10000 },
        detective = { player = 4667, job = 10000 },
        justice   = { player = 4667, job = 10000 },
    },
    ['WEAPON_COMBATMG_MK2'] = {
        police    = { player = 5333, job = 10000 },
        sheriff   = { player = 5333, job = 10000 },
        mt        = { player = 5333, job = 10000 },
        detective = { player = 5333, job = 10000 },
        justice   = { player = 5333, job = 10000 },
    },
    ['WEAPON_FLARE'] = {
        police    = { player = 1300, job = 3900 },
        sheriff   = { player = 1300, job = 3900 },
        mt        = { player = 1300, job = 3900 },
        detective = { player = 1300, job = 3900 },
        justice   = { player = 1300, job = 3900 },
    },
}

ESX.submarines = {
    [`avisa`] = true,
    [`submersible`] = true,
    [`submersible2`] = true,
}

ESX.blackListItems = {
}

ESX.headDisable = {
    ['sheriff'] = true
}