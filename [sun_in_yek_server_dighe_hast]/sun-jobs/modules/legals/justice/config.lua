-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.justice = {
	label = 'justice'
}
Shared.justice.config = {
	needUnit = true,
	customPlate = false,
	platePrefix = 'JD',
	decor = 'JC',
	billing = {
		customReason = true,
		reason = 'Unknown',
		player = false,
		maxBillAmount = 100000,
	},
    objects = {
		{ label = "Light 1",				model = 'xm_prop_base_tripod_lampa',	grade = 7, freeze = true },
		{ label = "Light 2",				model = 'prop_studio_light_02',			grade = 7, freeze = true },
		{ label = "Light stand", 			model = 'xm_prop_base_tripod_lampb',	grade = 7, freeze = true },
		{ label = "Board",					model = 'prop_scrim_02',				grade = 7, freeze = true },
		{ label = "Chair 1", 				model = 'v_ilev_chair02_ped', 			grade = 7, freeze = true },
		{ label = "Chair 2",	 			model = 'ex_mp_h_stn_chairstrip_01',	grade = 7, freeze = true },
		{ label = "Chair 4", 				model = 'vw_prop_vw_offchair_03',		grade = 7, freeze = true },
		{ label = "Chair 5", 				model = 'mp_b_din_chair_02',			grade = 7, freeze = true },
		{ label = "worklight", 				model = 'prop_worklight_01a',			grade = 7, freeze = true },
		{ label = "lights 3", 				model = 'prop_air_lights_04a',			grade = 7, freeze = true },
		{ label = "lights 4", 				model = 'prop_air_lights_05a',			grade = 7, freeze = true },
		{ label = "news", 					model = 'ng_proc_paper_news_quik',		grade = 7, freeze = true },
		{ label = "disp 1", 				model = 'prop_news_disp_03a',			grade = 7, freeze = true },
		{ label = "disp 2", 				model = 'prop_news_disp_01a',			grade = 7, freeze = true },
		{ label = "sofacorn",		 		model = 'apa_mp_h_stn_sofacorn_05',		grade = 7, freeze = true },
		{ label = "vstage", 				model = 'v_ilev_fos_tvstage',			grade = 7, freeze = true },
		{ label = "ind_prop_dlc_flag_02",	model = 'ind_prop_dlc_flag_02',			grade = 7, freeze = true },
		{ label = "prop_tyre_wall_05", 		model = 'prop_tyre_wall_05',			grade = 7, freeze = true },
		{ label = "prop_parasol_02_c", 		model = 'prop_parasol_02_c',			grade = 7, freeze = true },
		{ label = "prop_table_01",	 		model = 'prop_table_01',				grade = 7, freeze = true },
		{ label = "prop_yaught_chair_01",	model = 'prop_yaught_chair_01',			grade = 7, freeze = true },
		{ label = "prop_air_lights_02a",	model = 'prop_air_lights_02a',			grade = 7, freeze = true },
		{ label = "prop_air_conelight", 	model = 'prop_air_conelight',			grade = 7, freeze = true },
		{ label = "prop_mp_barrier_02", 	model = 'prop_mp_barrier_02',			grade = 7, freeze = true },
		{ label = "prop_premier_fence_02", 	model = 'prop_premier_fence_02',		grade = 7, freeze = true },
		{ label = "prop_huge_display_01", 	model = 'prop_huge_display_01',			grade = 7, freeze = true },
		{ label = "prop_ld_greenscreen_01", model = 'prop_ld_greenscreen_01',		grade = 7, freeze = true },
		{ label = "prop_satdish_3_b", 		model = 'prop_satdish_3_b',				grade = 7, freeze = true },
		{ label = "prop_walllight_ld_01", 	model = 'prop_walllight_ld_01',			grade = 7, freeze = true },
    },
}
Shared.justice.Locale = 'police'

Shared.justice.menu = {
    {label = _U(Shared.justice.Locale, 'citizen_interaction'),	cb = openPoliceCitizenInteractionMenu},
    {label = _U(Shared.justice.Locale, 'vehicle_interaction'), cb = openPoliceVehicleInteractionMenu},
    { label = 'Utilities', cb = function()
        openSpawnSubMenu({color1 = 98, color2 = 98})
    end},
    {label = 'Extra Divisions',	cb = divisionsMenu},
    {label = "Jail", cb = function ()
        TriggerEvent('esx_jail:openmenu')
    end},
    {label = 'Ghabz', cb = openBilling},
    {label = 'Jail info', cb = function ()
        checkPlayerJailInfo()
    end}
}

Shared.justice.zones = {

    cloakroom = {
        vec(-523.63, -169.61, 38.22), 	-- justice
        vec(223.46, -420.84, 47.98),    -- justice2
        vec(1780.41, 3649.91, 35.64),	-- Administatior
    },

    locker = {
        vec(-515.34, -183.5, 38.22), 	-- justice
        vec(219.57, -428.85, 47.98),    -- justice2
        vec(1776.47, 3646.81, 35.64),	-- Administatior
    },

    vehicles = {
        {-- justic
            spawner    = vec(-503.17, -178.37, 37.81),
            spawnPoint = vec(-492.41, -187.19, 37.32, 30.98),
        },
        {-- justic
            spawner    = vec(-543.6, -158.67, 38.48),
            spawnPoint = vec(-553.38, -159.71, 38.22, 288.91),
        },
        {-- justic2
            spawner    = vec(220.66, -366.02, 44.26),
            spawnPoint = vec(233.56, -368.3, 44.23, 252.75),
        },
        {-- Administatior
            spawner    = vec(1758.99, 3634.69, 34.9),
            spawnPoint = vec(1758.36, 3622.66, 34.88, 208.18),
        },

    },

    helicopters = {
        {-- justic
            spawner    = vec(-522.23, -191.1, 46.17),
            spawnPoint = vec(-511.1, -202.88, 49.78, 124.35),
        },
        {-- justic2
            spawner    = vec(254.95, -410.79, 59.61),
            spawnPoint = vec(268.5, -414.2, 63.35, 336.95),
        },
        {-- Administatior
            spawner    = vec(1735.96, 3643.26, 40.07),
            spawnPoint = vec(1747.28, 3642.39, 41.91, 306.99),
        },
    },

    vehicleDeleter = {
        vec(-492.41, -187.19, 37.32), 	-- justice  car
        vec(-553.38, -159.71, 38.22),    -- justice  car

        vec(-512.13, -203.73, 49.78), 	-- justic 	heli

        vec(233.56, -368.3, 44.23), 	-- justice 2 car
        vec(268.5, -414.2, 63.35),      -- justic 2 heli

        vec(1758.36, 3622.66, 34.88),	-- Administatior car
        vec(1747.29, 3642.39, 41.91),	-- Administatior heli
    },

    bossAction = {
        vec(-544.52, -184.88, 38.22),	-- justice
        vec(221.05, -414.82, 47.98),    -- justice2
        vec(1775.58, 3640.0, 40.4),		-- Administatior
    },
}

Shared.justice.uniforms = {
	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 11,  ['bproof_2'] = 3
		}
	},
}

Shared.justice.itemShop = {
	water       = { count = 1000,   price = 400000  },
	bread       = { count = 1000,   price = 450000  },
	silencer    = { count = 100,    price = 1000000 },
	grip        = { count = 100,    price = 1000000 },
	clip        = { count = 2000,   price = 1000000 },
	radio       = { count = 500,    price = 1000000 },
	flashlight  = { count = 100,    price = 1000000 },
	camera      = { count = 20,     price = 1000000 },
	armor50     = { count = 20,     price = 1000000 },
    mask_ghavasi  = { count = 100,  price = 5000000 },
    jooje_kebab   = { count = 1000, price = 5000000 },
    juice_orange  = { count = 1000, price = 1600000 },
    gun_cleaner   = { count = 100,  price = 600000  },
}

Shared.justice.weaponShop = {
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
