-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.police = {
	label = 'Police'
}
Shared.police.config = {
	needUnit = true,
	customPlate = false,
	platePrefix = 'PD',
	decor = 'PD',
	billing = {
		customReason = true, -- true = dalil
		reason = 'Unknown',
		player = false, -- true = be hesabe shakhs mire
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
Shared.police.Locale = 'police'

Shared.police.menu = {
    { label = _U(Shared.police.Locale, 'citizen_interaction'), cb = openPoliceCitizenInteractionMenu},
    { label = _U(Shared.police.Locale, 'vehicle_interaction'), cb = openPoliceVehicleInteractionMenu},
    { label = 'Utilities', cb = function()
        openSpawnSubMenu({color1 = 73, color2 = 73}, 'a_c_husky_k9')
    end},
    { label = 'Extra Divisions', cb = divisionsMenu},
    { label = "Jail", cb = function ()
        TriggerEvent('esx_jail:openmenu')
    end},
    {label = 'Ghabz', cb = openBilling},

}

Shared.police.zones = {

    cloakroom = {
        vec(455.71, -988.28, 30.69),    -- pd1
        vec(620.17, 14.12, 82.78),	    -- pd2
        vec(-63.76, -2514.61, 7.38),	-- pd3
        vec(1538.18, 811.98, 77.66),	-- pd4 Ist bazresi
        vec(-1098.28, -830.79, 14.28),  -- pd5
        vec(1837.93, 3678.88, 38.94),   -- sheriff sandy
        vec(-437.71, 5988.26, 31.71),	-- sheriff paleto
        vec(-2358.21, 3255.34, 32.81),	-- Army
    },

    locker = {
        vec(452.4, -973.66, 30.69),     -- pd1
        vec(626.03, -23.33, 82.78),	    -- pd2
        vec(-48.38, -2520.1, 7.38),	    -- pd3
        vec(1550.48, 841.86, 77.66),	-- pd4 ist bazresi 

        vec(-1088.26, -811.74, 5.48),	-- pd5-1
        vec(-1074.46, -823.2, 11.03),	-- pd5-2
        vec(-1102.75, -821.66, 14.28),  -- pd5-3

        vec(1837.21, 3682.15, 38.93),   -- sheriff sandy
        vec(-442.23, 5987.3, 31.71),	-- sheriff paleto 

        vec(-2314.94, 3258.34, 32.83),	-- Army
    },

    vehicles = {
        { -- pd1 jelo
            spawner    = vec(442.0, -1013.6, 28.63),
            spawnPoint = vec(436.76, -1019.56, 28.79, 89.47),
        },
        { -- pd1 posht
            spawner    = vec(472.67, -1019.47, 28.13),
            spawnPoint = vec(472.8, -1023.44, 28.14, 274.73),
        },
        { -- pd2 shahri
            spawner    = vec(615.01, 24.64, 89.08),
            spawnPoint = vec(610.33, 31.14, 89.58, 250.0),
        },
        { -- pd3 shahri
            spawner    = vec(-40.64, -2513.43, 6.16),
            spawnPoint = vec(-47.62, -2503.0, 6.01, 238.35),
        },
        { --pd4 Ist Bazresi 
            spawner    = vec(1527.51, 792.43, 77.45),
            spawnPoint = vec(1519.32, 783.99, 77.44, 124.22),
        },
        { -- pd5 shahri
            spawner    = vec(-1066.16, -852.27, 4.87),
            spawnPoint = vec(-1066.39, -861.28, 4.87, 210.13),
        },
        { -- sheriff sandy
            spawner    = vec(1856.23, 3687.57, 34.33),
            spawnPoint = vec(1857.86, 3694.16, 33.87, 208.63),
        },
        { -- paleto 
            spawner    = vec(-452.61, 6023.58, 31.49),
            spawnPoint = vec(-463.0, 6019.33, 31.34, 309.34),
        },
        { -- Army 
            spawner    = vec(-2343.14, 3262.33, 32.83),
            spawnPoint = vec(-2333.73, 3259.83, 32.26, 330.31),
        },
    },

    helicopters = {
        {-- PD1
            spawner    = vec(456.24, -974.67, 43.69),
            spawnPoint = vec(449.11, -981.23, 43.69, 90.58),
        },
        {-- PD2
            spawner    = vec(572.31, 6.6, 103.23),
            spawnPoint = vec(579.89, 12.57, 103.23, 358.89),
        },
        {-- pd4 ist bazresi
            spawner    = vec(1567.52, 833.95, 77.14),
            spawnPoint = vec(1564.5, 843.95, 77.14, 64.76),
        },
        {-- PD5
            spawner    = vec(-1103.81, -835.0, 37.7),
            spawnPoint = vec(-1096.23, -832.01, 37.7, 308.25),
        },
        {-- sheriff sandy
            spawner    = vec(1821.09, 3684.51, 34.34),
            spawnPoint = vec(1815.77, 3674.34, 34.19, 28.14),
        },
        {-- sheriff paleto
            spawner    = vec(-466.2, 5996.55, 31.25),
            spawnPoint = vec(-475.03, 5987.91, 31.34, 227.59),
        },
        {-- Army
            spawner    = vec(-2385.38, 3246.34, 33.01),
            spawnPoint = vec(-2394.58, 3235.1, 37.05, 155.19),
        },
        {-- pd3
            spawner    = vec(-64.2, -2495.9, 10.39),
            spawnPoint = vec(-70.98, -2501.98, 10.39, 324.74),
        },
    },

    vehicleDeleter = {
        vec(436.76, -1019.56, 28.79),  	-- pd1 jelo
        vec(472.68, -1023.43, 28.14), 	-- pd1 posht
        vec(627.6, 24.47, 87.75),		-- pd2 
        vec(-47.67, -2502.96, 6.01),	-- pd3
        vec(1519.32, 783.99, 77.44),	-- pd4 Ist bazresi 
        vec(-1066.39, -861.25, 4.86),	-- pd5

        vec(1857.91, 3694.16, 33.86), 	-- sheriff sandy
        vec(-463.0, 6019.33, 31.34),  	-- paleto
        vec(-2333.73, 3259.83, 32.26),	-- Army

        vec(448.99, -981.21, 43.69), 	-- Heli pd1
        vec(579.89, 12.56, 103.23),		-- Heli pd2
        vec(1564.5, 843.95, 77.14),		-- Heli pd4 Ist bazresi
        vec(-1096.18, -832.03, 37.7),	-- Heli pd5
        vec(1815.77, 3674.34, 34.19),   -- heli sandy
        vec(-475.1, 5987.98, 31.34),	-- heli paleto
        vec(-2394.58, 3235.1, 37.05),	-- heli Army
        vec(-70.98, -2501.98, 10.39),   -- heli pd3
    },

    bossAction = {
        vec(446.78, -973.29, 30.69),	-- pd1
        vec(632.1, -10.99, 82.77),	    -- pd2
        vec(-43.41, -2516.61, 7.38),	-- pd3
        vec(1538.14, 816.43, 82.13),	-- pd4 ist bazresi

        vec(-1114.45, -833.09, 30.76),  -- pd5-1
        vec(-1097.41, -821.48, 19.03),  -- pd5-2
        vec(-1113.94, -833.24, 34.36),  -- pd5-3

        vec(1847.57, 3677.99, 38.93),   -- sheriff sandy
        vec(-434.73, 6004.09, 31.72),   -- sheriff palato 

        vec(-2348.03, 3270.69, 32.81),  -- Army
    },

}


Shared.police.uniforms = {
	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 11,  ['bproof_2'] = 3
		}
	},
}

Shared.police.itemShop = {
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

Shared.police.weaponShop = {
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
    WEAPON_SMOKEGRENADE     = { price = 5000   }
}
