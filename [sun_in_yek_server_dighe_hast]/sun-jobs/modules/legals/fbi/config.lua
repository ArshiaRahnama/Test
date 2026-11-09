-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.fbi = {
	label = 'FBI'
}
Shared.fbi.config = {
	needUnit = false,
	customPlate = true,
	platePrefix = 'FBI',
	decor = 'FBI',
	billing = {
		customReason = true,
		reason = 'Unknown',
		player = false,
		maxBillAmount = 50000,
	},
    objects = {
        { label = 'cone',                model = 'prop_mp_cone_01',              grade = 5, freeze = true },
        { label = 'Road Barrier',        model = 'prop_mp_barrier_02b',          grade = 5, freeze = true },
        { label = 'Crosswalk Barrier',   model = 'prop_barrier_work05',          grade = 5 },
        { label = 'Pointer Barrie',      model = 'prop_mp_arrow_barrier_01',     grade = 5, freeze = true },
        { label = 'spikestrips',         model = 'p_ld_stinger_s',               grade = 5, freeze = true },
        { label = 'box of cash',         model = 'hei_prop_cash_crate_half_full',grade = 5 },
        { label = 'chair 2',             model = 'gr_prop_gr_chair02_ped',       grade = 5, freeze = true },
        { label = 'air conelight',       model = 'prop_air_conelight',           grade = 5, freeze = true },
        { label = 'air sechut',          model = 'prop_air_sechut_01',           grade = 5, freeze = true },
        { label = 'air lights',          model = 'prop_air_lights_04a',          grade = 5, freeze = true },
        { label = 'bollard',             model = 'prop_bollard_01b',             grade = 5, freeze = true },
        { label = 'gazebo',              model = 'prop_gazebo_02',               grade = 5, freeze = true },
        { label = 'table',               model = 'prop_table_03',                grade = 5, freeze = true },
        { label = 'tyre wall',           model = 'prop_tyre_wall_05',            grade = 5, freeze = true },
        { label = 'slowdown',            model = 'stt_prop_track_slowdown',      grade = 5 },
    },
}
Shared.fbi.Locale = 'police'

Shared.fbi.menu = {
    {label = _U(Shared.fbi.Locale, 'citizen_interaction'), cb = openPoliceCitizenInteractionMenu},
    {label = _U(Shared.fbi.Locale, 'vehicle_interaction'), cb = openPoliceVehicleInteractionMenu},
    { label = 'Utilities', cb = function()
        openSpawnSubMenu({color1 = 0, color2 = 0}, 'a_c_husky_k9')
    end},
    {label = 'Extra Divisions', cb = divisionsMenu},
    {label = "Jail", cb = function ()
        TriggerEvent('esx_jail:openmenu')
    end},
    {label = 'Ghabz', cb = openBilling},
}

Shared.fbi.zones = {

    cloakroom = {
        vec(144.36, -761.77, 242.15), 	-- fbi 1
        vec(2523.98, -332.91, 94.09),	-- fbi 2 
        vec(2516.57, -339.44, 101.89),	-- fbi 2
        vec(2516.08, -445.04, 106.91),	-- fbi 2
        vec(1780.41, 3649.91, 35.64),	-- Administatior
        vec(-2354.93, 3258.92, 92.89),	-- Army
    },

    locker = {
        vec(141.87, -769.44, 242.15), 	-- fbi 1
        vec(2486.94, -376.96, 82.69),  	-- fbi 2 
        vec(2525.81, -342.34, 101.89), 	-- fbi 2  
        vec(2502.83, -426.59, 94.58),	-- fbi 2
        vec(1776.47, 3646.81, 35.64),	-- Administatior
        vec(-2361.17, 3247.12, 92.9),	-- Army
    },

    vehicles = {
        {-- fbi 1
            spawner    = vec(58.41, -750.64, 44.24),
            spawnPoint = vec(56.99, -743.95, 44.12, 338.58),
        },
        {-- fbi 2
            spawner    = vec(2516.28, -377.21, 93.14),
            spawnPoint = vec(2528.38, -384.48, 92.99, 268.32),
        },
        {-- Administatior
            spawner    = vec(1758.99, 3634.69, 34.9),
            spawnPoint = vec(1758.36, 3622.66, 34.88, 208.18),
        },
        {-- Army
            spawner    = vec(-2432.26, 3287.86, 32.98),
            spawnPoint = vec(-2417.01, 3283.66, 32.83, 325.61),
        },
    },

    helicopters = {
        {-- fbi 1
            spawner    = vec(134.51, -734.69, 262.84),
            spawnPoint = vec(122.65, -742.26, 262.55, 159.09),
        },
        {-- fbi 2
            spawner    = vec(2505.86, -346.96, 118.02),
            spawnPoint = vec(2510.7, -342.06, 118.19, 225.72),
        },
        {-- fbi 2   
            spawner    = vec(2516.87, -421.65, 118.23),
            spawnPoint = vec(2511.13, -426.64, 118.33, 44.46),
        },
        {-- Administatior
            spawner    = vec(1735.96, 3643.26, 40.07),
            spawnPoint = vec(1747.28, 3642.39, 41.91, 306.99),
        },
        {-- Army
            spawner    = vec(-2424.67, 3264.01, 41.86),
            spawnPoint = vec(-2432.23, 3269.3, 43.01, 60.29),
        },
    },

    vehicleDeleter = {
        vec(63.23, -728.9, 44.12),		-- fbi 1
        vec(2528.38, -384.48, 92.99),	-- fbi 2
        vec(1758.36, 3622.66, 34.88),	-- Administatior
        vec(-2417.01, 3283.66, 32.83),	-- Army

        vec(122.65, -742.26, 262.55),	-- fbi 1  		 heli
        vec(2511.13, -426.64, 118.33), 	-- fbi 2  		 heli
        vec(2510.7, -342.06, 118.19),	-- fbi 2  		 heli
        vec(1747.29, 3642.39, 41.91),	-- Administatior heli
        vec(-2432.23, 3269.3, 43.01),	-- Army			 heli
    },

    bossAction = {
        vec(149.58, -758.36, 242.15),	-- fbi 1
        vec(2512.83, -447.37, 106.91),	-- fbi 2 
        vec(1775.58, 3640.0, 40.4),		-- Administatior
        vec(-2357.65, 3242.39, 92.9),	-- Army
    },
}

Shared.fbi.helicopters = {
    { label = "FBI Frogger", model = "frogger2", 	 livery = 2,  grade = 11 },
    { label = "FBI Anni", 	 model = "Annihilator",	 livery = 1,  grade = 11 },
    { label = "FBI Anni2", 	 model = "Annihilator2", livery = 1,  grade = 11 },
	{ label = "buzzard", 	 model = "buzzp", 		 livery = 4,  grade = 1  },
	{ label = "maverick", 	 model = "polmav", 		 livery = 5,  grade = 1  },
}

Shared.fbi.uniforms = {
	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 11,  ['bproof_2'] = 3
		}
	},
}

Shared.fbi.itemShop = {
	water       = { count = 1000,   price = 400000  },
	bread       = { count = 1000,   price = 450000  },
	silencer    = { count = 100,    price = 1000000 },
	grip        = { count = 100,    price = 1000000 },
	clip        = { count = 2000,   price = 1000000 },
	radio       = { count = 500,    price = 1000000 },
	flashlight  = { count = 100,    price = 1000000 },
	camera      = { count = 20,     price = 1000000 },
	armor50     = { count = 20,     price = 1000000 },
}

Shared.fbi.weaponShop = {
	WEAPON_STUNGUN          = { price = 1000 },
    WEAPON_NIGHTSTICK       = { price = 1000 },
    WEAPON_PISTOL           = { price = 15000 },
    WEAPON_SNSPISTOL        = { price = 15000 },
    WEAPON_VINTAGEPISTOL    = { price = 15000 },
    WEAPON_HEAVYPISTOL      = { price = 15000 },
    WEAPON_COMBATPISTOL     = { price = 15000 },
    WEAPON_PISTOL50         = { price = 15000 },
    WEAPON_SMG              = { price = 22500 },
    WEAPON_SNSPISTOL_MK2    = { price = 15000 },
    WEAPON_ASSAULTSMG       = { price = 30000 },
    WEAPON_CARBINERIFLE     = { price = 37500 },
    WEAPON_ASSAULTRIFLE     = { price = 37500 },
    WEAPON_ADVANCEDRIFLE    = { price = 37500 },
    WEAPON_COMBATPDW        = { price = 37500 },
    WEAPON_BULLPUPRIFLE     = { price = 37500 },
    WEAPON_GUSENBERG        = { price = 37500 },
    WEAPON_ASSAULTSHOTGUN   = { price = 45000 },
    WEAPON_SAWNOFFSHOTGUN   = { price = 45000 },
    WEAPON_PUMPSHOTGUN      = { price = 45000 },
    WEAPON_BULLPUPSHOTGUN   = { price = 45000 },
    WEAPON_PISTOL_MK2       = { price = 90000 },
    WEAPON_SPECIALCARBINE   = { price = 210000 },
    WEAPON_CERAMICPISTOL    = { price = 120000 },
    WEAPON_PUMPSHOTGUN_MK2  = { price = 300000 },
    WEAPON_BULLPUPRIFLE_MK2 = { price = 300000 },
    WEAPON_DOUBLEACTION     = { price = 600000 },
    WEAPON_SMG_MK2          = { price = 240000 },
    WEAPON_COMPACTRIFLE     = { price = 300000 },
    WEAPON_SPECIALCARBINE_MK2 = { price = 600000 },
    WEAPON_MICROSMG         = { price = 600000 },
    WEAPON_ASSAULTRIFLE_MK2 = { price = 600000 },
    WEAPON_CARBINERIFLE_MK2 = { price = 600000 },
    WEAPON_APPISTOL         = { price = 900000 },
    WEAPON_GADGETPISTOL     = { price = 600000 },
    WEAPON_COMBATSHOTGUN    = { price = 900000 },
    WEAPON_MILITARYRIFLE    = { price = 900000 },
}