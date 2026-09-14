Config_judge                            = {}

Config_judge.DrawDistance               = 20.0
Config_judge.MarkerType                 = 21
Config_judge.MarkerTypeveh              = 36
Config_judge.MarkerTypevehdel           = 24
Config_judge.MarkerTypeboss             = 22
Config_judge.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config_judge.MarkerColor                = { r = 193, g = 175, b = 158 }

Config_judge.EnablePlayerManagement     = true
Config_judge.EnableArmoryManagement     = true
Config_judge.EnableESXIdentity          = true
Config_judge.EnableNonFreemodePeds      = false
Config_judge.EnableSocietyOwnedVehicles = false
Config_judge.EnableLicenses             = true
Config_judge.EnableJobLogs              = true

Config_judge.EnableHandcuffTimer        = false
Config_judge.HandcuffTimer              = 10 * 60000

Config_judge.EnableJobBlip              = true

Config_judge.MaxInService               = -1
Config_judge.Locale                     = 'en'

Config_judge.judgeStations = {

	Paleto = {

		Blip = {
			    Pos     ={ x = 1852.655, y = 3687.546, z = 34.286 },
			    Sprite  = 60,
			    Display = 4,
			    Scale   = 1.2,
			    Colour  = 31,
		},



		AuthorizedWeapons = {
			{ name = 'WEAPON_BZGAS', price = 5000 },
			{ name = 'WEAPON_STUNGUN', price = 5000 },
			{ name = 'WEAPON_NIGHTSTICK', price = 5000 },
			{ name = 'WEAPON_FLASHLIGHT', price = 5000 },
			{ name = 'WEAPON_PISTOL', price = 10000 },
			{ name = 'WEAPON_COMBATPISTOL', price = 10000 },
			{ name = 'WEAPON_PISTOL50', price = 10000 },
			{ name = 'WEAPON_HEAVYPISTOL', price = 10000 },
			{ name = 'WEAPON_SMG', price = 12000 },
			{ name = 'WEAPON_ASSAULTSMG', price = 12000 },
			{ name = 'WEAPON_CARBINERIFLE', price = 12000 },
			{ name = 'WEAPON_COMBATPDW', price = 12000 },
			{ name = 'WEAPON_PUMPSHOTGUN', price = 13000 },
			{ name = 'WEAPON_ASSAULTSHOTGUN', price = 13000 },
			{ name = 'WEAPON_BULLPUPSHOTGUN', price = 13000 },
			{ name = 'WEAPON_ADVANCEDRIFLE', price = 14000 },
			{ name = 'WEAPON_BULLPUPRIFLE', price = 14000 },
			{ name = 'WEAPON_ASSAULTRIFLE', price = 14000 },
			{ name = 'WEAPON_GUSENBERG', price = 14000 },
		},

		AuthorizedItems = {
			{ name = 'water', price = 60 , label = 'Ab'},
			{ name = 'silencer', price = 5000, label = 'Silencer'},
			{ name = 'grip', price = 5000, label = 'Grip' },
			{ name = 'clip', price = 10, label = 'Kheshab' },
			{ name = 'radio', price = 3000, label = 'Bisim' },
			{ name = 'phone', price = 2000, label = 'Goshi' },
			{ name = 'bread', price = 60, label = 'Noon' },

		},

		Cloakrooms = {
			{ x = 1840.233, y = 3691.182, z = 34.286},
			{x = 619.9525, y = 14.88760, z = 82.782},
			{x = 461.2001, y = -998.995, z = 30.689},

		},

		Armories = {
			{x = 1846.653, y = 3694.171, z = 34.286},
			{x = 624.9413, y = -21.8669, z = 82.779},
			{x = 482.5964, y = -995.242, z = 30.689},
		},

		Vehicles = {
			{
				Spawner    = { x = 1868.013, y = 3687.065, z = 33.815},
				SpawnPoint = { x = 1871.425, y = 3692.390, z = 33.591},
				Heading    = 192.32
			},

			{
				Spawner    = {x = 615.4080, y = 24.98834, z = 89.022},
				SpawnPoint = {x = 609.3079, y = 31.02311, z = 89.660},
				Heading    = 246.08
			},

			{
				Spawner    = {x = 458.4525, y = -986.807, z = 25.700},
				SpawnPoint = {x = 451.2926, y = -978.715, z = 25.699},
				Heading    = 91.08
			},
		},

		Helicopters = {
			{
				Spawner    = { x = 1864.269, y = 3663.138, z = 33.929   },
				SpawnPoint = { x = 1867.619, y = 3654.004, z = 33.884   },
				Heading    = 23.91
			},

			{
				Spawner    = {x = 458.7702, y = -978.968, z = 43.691},
				SpawnPoint = {x = 448.9412, y = -981.094, z = 43.691},
				Heading    = 2675.91
			},
		},

		VehicleDeleters = {
			{ x = 1871.425, y = 3692.390, z = 33.591},
			{ x = 1867.619, y = 3654.004, z = 33.884},
			{x = 615.2284, y = 28.91618, z = 89.044},
			{x = 448.9412, y = -981.094, z = 43.691},
			{x = 451.2926, y = -978.715, z = 25.699},
		},

		VehicleDeleters2 = {


		},

		BossActions = {
			{ x = 1854.383, y = 3698.163, z = 34.286 },
			{ x = 631.8889, y = -10.9609, z = 82.778 },
			{ x = 459.8323, y = -985.009, z = 30.689 },
		},

	},
}

Config_judge.AuthorizedItems = {
	Shared = {
		{ name = 'water', price = 100 },
		{ name = 'silencer', price = 500 },





	},


}

Config_judge.AuthorizedWeapons = {
	Shared = {
		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
		{ name = 'WEAPON_STUNGUN', price = 500 },
		{ name = 'WEAPON_FLASHLIGHT', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 5000 },
		{ name = 'WEAPON_SNSPISTOL', price = 6000 },
		{ name = 'WEAPON_COMBATPISTOL', price = 7000 },

	},



}

Config_judge.AuthorizedVehicles = {
	Shared = {

	{ model = 'b2chal', label = 'Judge Chal', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 0, ['5'] = 0 } },

	{ model = 'b211vic', label = 'Judge Vic', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0, ['10'] = 1} },

	{ model = 'b212caprice', label = 'Judge Caprice', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0} },

	{ model = 'b214charger', label = 'Judge Charger', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['5'] = 0, ['6'] = 0, ['7'] = 1, ['8'] = 0 }},
	{ model = 'b214charger', label = 'Judge Charger2', Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['5'] = 0, ['6'] = 0, ['7'] = 1, ['8'] = 1 }},

	{ model = 'b216explorer', label = 'Judge Explorer',  Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1}},

	{ model = 'b218charger', label = 'Judge Charger18', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0}},

	{ model = 'b218tau', label = 'Judge Tau', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['6'] = 1, ['7'] = 0}},
	{ model = 'b218tau', label = 'Judge Tau2', Extra = {['1'] = 1, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['6'] = 1, ['7'] = 0}},

	{ model = 'b219tahoe', label = "Judge Tahoe", Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 0}},
	{ model = 'fibm5', label = "Judge BMWM5", Extra = {['1'] = 0}},
	{ model = 'polnspeedo', label = "Judge Van", Extra = {['11'] = 0}},
	{ model = 'POLKCH', label = "Judge Kamacho", Extra = {['1'] = 0, ['3'] = 0, ['4'] = 0}},
	{ model = 'swat_dirtbike', label = "Judge Motor", Extra = {['1'] = 1}},

	},

	Sharedheli = {

	{ model = 'polmav', label = 'Judge Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	{ model = 'tx_heli', label = 'Judge Heli', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },



	},


}

Config_judge.Uniforms = {

	bullet_wear = {
		male = {
			['bproof_1'] = 12,  ['bproof_2'] = 3
		},
		female = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		}
	},

	swat_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 2,
			['decals_1'] = 3,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 33,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['bproof_1'] = 16,  ['bproof_2'] = 2,
			['mask_1'] = 89,   ['mask_2'] = 0
		}
	},

	xray_wear = {
		male = {
			['tshirt_1'] = 154,  ['tshirt_2'] = 0,
			['torso_1'] = 54,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 41,   ['pants_2'] = 0,
			['shoes_1'] = 61,   ['shoes_2'] = 0,
			['helmet_1'] = 0,  ['helmet_2'] = 5,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 31
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 46,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 38,
			['pants_1'] = 32,   ['pants_2'] = 0,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 116,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['mask_1'] = 130,   ['mask_2'] = 0,
			['bproof_1'] = 2,  ['bproof_2'] = 2
		}
	},


}