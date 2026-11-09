-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared.mechanic = {
    label = 'Mechanic'
}
Shared.mechanic.Locale = 'mechanic'

Shared.mechanic.config = {
	needUnit = false,
	customPlate = true,
	platePrefix = 'MC',
	decor = 'MC',
	billing = {
		customReason = false,
		reason = 'Mechanic',
		player = true,
		maxBillAmount = 50000,
	},
    objects = {
        { label = 'Roadcane',   model = 'prop_roadcone02a',     grade = 13 },
        { label = 'Toolbox',    model = 'prop_toolchest_01',    grade = 13 },
    },
    impound = {
        deleteTime = 15 * 60000,
        reward = 5000,
        policeReward = 5000,
    },
    towTrucks = {
        `towtruck`,
    },
    mechanicBot = {
        mechanicNeed = 0,
		timer = 90 * 1000,
		models = {
			`s_m_y_xmech_02`,
		},
        cars = {
            `flatbed`,
            `sunsetsk`,
            `towtruck`,
        },
		spawnRadius = 150,
        cost = 15000,
    }
}

Shared.mechanic.markers = {
    vehicleDeleterImpound = {
        type = 24,
        color = {255, 0, 0, 100},
        size = {2.5, 2.5, 2.5},
        upDown = true,
        range = 4.0,
        label = '~INPUT_CONTEXT~ Park Kardan(Flatbed)',
    },
}

Shared.mechanic.menu = {
	{label = function()
		local p = promise.new()
		ESX.TriggerServerCallback('mechanic:getlist', function(data)
			p:resolve('Request list('.. ESX.tableLength(data) ..')')
		end)
		return Citizen.Await(p)
	end, cb = openMechanicRequest},
	{label = 'Ghabz', cb = openBilling},
	{label = 'Repair', cb = mechanicRepairVehicle},
    {label = 'Ta\'amir engine', cb = mechanicFixEngine},
    {label = 'Flip', cb = mechanicFlip},
    {label = 'Flatbed', cb = mechanicFlatbed},
	{label = 'Extra Divisions', cb = divisionsMenu},
    {label = 'Check Insurance', cb = mechanicCheckVehicleInsurance},
	{label = 'Ghayegh badi', cb = function()
		exports['sunset_utils']:ghayeghBadi(true, {color1 = 126, color2 = 126})
	end},
    { label = 'Spawn Object', cb = openSpawnObject},

}


Shared.mechanic.zones = {
    bossAction = {
        vec(1343.18, -777.54, 71.29),   -- city 1
        vec(597.08, 605.5, 135.12),     -- city 2
        vec(1227.81, 2734.44, 38.22),   -- sandy
        vec(152.81, -3009.2, 10.7),     -- tune
        vec(-79.42, -2019.47, 18.03),   -- car dealer
    },
    locker = {
        vec(597.23, 639.9, 128.93),     -- mc 1
        vec(1338.48, -776.51, 71.28),   -- mc old
        vec(1228.6, 2740.67, 38.22),    -- mc sandy
        vec(124.63, -3013.36, 7.04),    -- mc tune
        vec(-187.3, -2148.83, 16.7),    -- car dealer
    },
    cloakroom = {
        vec(1339.12, -770.01 ,71.21),   -- city 1
        vec(1232.14, 2737.48, 38.22),   -- sandy
        vec(103.03, 6614.12, 32.43),    -- paleto
        vec(597.03, 636.21, 128.93),    -- city 2
        vec(152.28, -3014.71, 7.04),    -- tune
        vec(-94.52, -2009.47, 18.03),   -- car dealer
    },

    vehicles = {
        { -- city 1
            spawner    = vec(1320.57, -736.03, 65.67),
            spawnPoint = vec(1301.99, -729.17, 64.71, 340.25),
        },
        { -- sandy
            spawner    = vec(1223.82, 2720.42, 38.01),
            spawnPoint = vec(1225.97, 2710.94, 38.01, 177.96),
        },
        { -- paleto
            spawner    = vec(115.08, 6625.78, 31.79),
            spawnPoint = vec(118.93, 6599.34, 32.02, 270.87),
        },
        { -- city 2
            spawner    = vec(626.29, 640.3, 128.91),
            spawnPoint = vec(619.98, 650.02, 128.91, 283.91),
        },
        { -- tune
            spawner    = vec(157.22, -3018.08, 7.04),
            spawnPoint = vec(165.56, -3005.97, 5.89, 359.42),
        },
        { -- car dealer
            spawner    = vec(-94.59, -2021.11, 18.02),
            spawnPoint = vec(-86.37, -2026.46, 18.02, 77.5),
        },
        { -- air palane custom
            spawner    = vec(-1239.07, -2244.42, 13.94),
            spawnPoint = vec(-1237.47, -2253.65, 13.94, 150.7),
        },
        { -- pacific bluffs
            spawner    = vec(-1987.35, -320.09, 44.11),
            spawnPoint = vec(-1996.38, -317.93, 44.11, 330.06),
        },
        { -- ghayegh custom
            spawner    = vec(-923.56, -1509.36, 5.18),
            spawnPoint = vec(-928.53, -1502.72, 5.02, 101.26),
        },
    },

    vehicleDeleter = {
        vec(1318.19, -724.77, 65.37),   -- city 1
        vec(619.98, 650.03, 128.91),    -- city 2
        vec(1225.98, 2710.94, 38.0),    -- sandy
        vec(118.94, 6599.34, 32.01),    -- paleto
        vec(1339.46, -708.37, 68.12),   -- city 1
        vec(676.76, 614.4, 130.81),     -- city 2
        vec(1228.39, 2734.09, 42.06),   -- sandy
        vec(-86.37, -2026.46, 18.02),   -- car dealer
        vec(-1237.47, -2253.65, 13.94), -- air palane custom
        vec(-1996.38, -317.93, 44.11),  -- pacific bluffs
        vec(-928.51, -1502.67, 5.02)    -- ghayegh custom
    },

    helicopters = {
        {-- city 1
            spawner    = vec(1344.5, -719.87, 66.86),
            spawnPoint = vec(1339.46, -708.37, 68.12, 347.31),
        },
        {-- city 2
            spawner    = vec(687.4, 612.35, 128.91),
            spawnPoint = vec(676.76, 614.4, 130.81, 254.14),
        },
        {-- sandy
            spawner    = vec(1223.68, 2742.87, 42.07),
            spawnPoint = vec(1228.39, 2734.09, 42.06, 178.37),
        },
        {-- tune
            spawner    = vec(156.24, -3006.65, 7.03),
            spawnPoint = vec(137.12, -3017.55, 18.92, 277.5),
        },
    },

    vehicleDeleterImpound = {
        vec(1304.27, -729.09, 64.77),   -- mc ghadim
        vec(40.23, -832.1, 30.81),      -- parking markazi
        vec(691.91, 621.43, 128.91),    -- mc 1
        vec(-1986.61, -325.19, 48.11),  -- saheli
        vec(1026.26, 2664.88, 39.55),   -- sandy
        vec(87.15, 6620.77, 31.49),     -- paleto
        vec(-234.48, -1393.83, 31.27),
        vec(-69.52, -2017.98, 18.02),  -- car dealer
        vec(-905.8, -1495.53, 5.02),   -- ghayegh custom
    },
}

Shared.mechanic.itemShop = {
	water = {count = 20, price = 17500},
	bread = {count = 20, price = 20000},
    radio = {count = 5, price = 25000},
}
