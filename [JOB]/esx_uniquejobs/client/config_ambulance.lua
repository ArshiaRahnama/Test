

Config_ambulance                            = {}

Config_ambulance.DrawDistance               = 200.0

Config_ambulance.Marker                     = { type = 21,  x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true }
Config_ambulance.MarkerBoss                 = 42
Config_ambulance.MarkerClock                = 20

Config_ambulance.reviveReward               = 15000
Config_ambulance.AntiCombatLog              = false
Config_ambulance.LoadIpl                    = false

Config_ambulance.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config_ambulance.EarlyRespawnTimer          = 15 * minute
Config_ambulance.BleedoutTimer              = 5 * minute

Config_ambulance.EnablePlayerManagement     = true

Config_ambulance.RemoveWeaponsAfterRPDeath  = true
Config_ambulance.RemoveCashAfterRPDeath     = true
Config_ambulance.RemoveItemsAfterRPDeath    = true

Config_ambulance.EarlyRespawnFine           = true
Config_ambulance.EarlyRespawnFineAmount     = 15000

Config_ambulance.BlacklistedItems = {
    'hifi',
    'boombox',
    'customcoupon'
}

Config_ambulance.BlacklistedWeapons = {
    'WEAPON_MINIGUN',
    'WEAPON_SNIPERRIFLE'
}

Config_ambulance.RespawnPoint = { coords = vector3(vector3(299.9083, -574.085, 43.260)), heading = 109.78 }

Config_ambulance.Hospitals = {

	CentralLosSantos = {

		AuthorizedItems = {
			{ name = 'water', price = 60 , label = 'Ab'},
			{ name = 'bread', price = 60, label = 'Noon' },
			{ name = 'radio', price = 3000, label = 'Bisim' },
			{ name = 'phone', price = 2000, label = 'Goshi' },
			{ name = 'medikit', price = 2000, label = 'Medikit' },
			{ name = 'bandage', price = 1000, label = 'Bandage' },
		},


		Blip = {
			coords = vector3(289.3741, -595.735, 43.173),
			coords2 = vector3(-249.500, 6325.161, 32.427),
			sprite = 305,
			scale  = 1.2,
			color  = 1,


		},



		AmbulanceLebas = {
			vector3(298.8177, -598.294, 43.284)
		},

		AmbulanceBossAction = {
			vector3(312.1822, -597.323, 43.284)
		},

		Pharmacies = {
			vector3(311.7456, -564.056, 43.284),
			vector3(1822.93, 3666.95, 34.27),
		},

		Armory = {
			vector3(304.4680, -600.968, 43.284),
			vector3(1834.18, 3690.48, 34.27),
		},

		Vehicles = {
			{
				Spawner = vector3(293.5631, -600.239, 43.301),
				InsideShop = vector3(-1841.30, -348.156, 43.596),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = { x = 294.6011, y = -607.727, z = 43.333 },
				Heading    = 90.00
			},

			{
				Spawner = vector3(-1842.95, -342.370, 43.689),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = { x = -1822.48, y = -350.313, z = 43.596 },
				Heading    = 316.33
			}
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(294.6011, -607.727, 43.333)
			},
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(351.3263, -587.819, 74.164)
			},
		},

		Helicopters = {
			{
				Spawner = vector3(354.6627, -576.387, 74.164),
				InsideShop = vector3(-1859.43, -348.885, 58.831),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = { x = 351.3263, y = -587.819, z = 74.164 },
				Heading    = 67.36
			},
		},

		FastTravels = {
            {
				From = vector3(294.7, -1448.1, 29.0),
				To = { coords = vector3(272.8, -1358.8, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},
		},

		FastTravelsPrompt = {
			{
				From = vector3(332.2641, -595.540, 43.284),
				To = { coords = vector3(339.06, -584.03, 74.17), heading = 0.0 },
				Marker = { type = 21, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Prompt = _U('fast_travel1')
			},

			{
				From = vector3(339.06, -584.03, 74.17),
				To = { coords = vector3(332.2641, -595.540, 43.284), heading = 0.0 },
				Marker = { type = 21, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Prompt = _U('fast_travel2')
			},














		}

	}
}

Config_ambulance.AuthorizedVehicles = {
	Shared = {
		{
			model = 'b219tahoe',
			label = 'Medic Tahoe',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1}

		},
		{
			model = 'b2chal',
			label = 'Medic Tahoe',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 0}

		},
		{
			model = 'b218tau',
			label = 'Medic Tau',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['6'] = 1, ['7'] = 1}
		},
		{
			model = 'b216explorer',
			label = 'Medic Explorer',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b214charger',
			label = 'Medic Charger',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1, ['8'] = 1 }
		},
		{
			model = 'b212caprice',
			label = 'Medic Caprice',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b211vic',
			label = 'Medic Vic',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['10'] = 1}
		},
		{
			model = 'b218charger',
			label = 'Medic Charger18',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'fibm5',
			label = 'Medic BMWM5',
			Extra = {['1'] = 0}
		},
		{
			model = 'ambulance',
			label = 'Ambulance',
			Extra = {['1'] = 0}
		},
		{
			model = 'swat_dirtbike',
			label = 'Medic Motor',
			Extra = {['1'] = 0}
		},
		{
			model = 'polnspeedo',
			label = 'Medic Van',
			Extra = {['1'] = 0}
		},
		{
			model = 'POLKCH',
			label = 'Medic Kamacho',
			Extra = {['1'] = 0, ['2'] = 1, ['3'] = 0, ['4'] = 0,}
		},
	},

	Sharedheli = {

		{ model = 'tx_heli', label = 'Medic Heli', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
		{ model = 'polmav', label = 'Medic Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	},
}

