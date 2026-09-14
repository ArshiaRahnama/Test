Config_police                            = {}

Config_police.DrawDistance               = 20.0
Config_police.MarkerType                 = 21
Config_police.MarkerTypeveh              = 36
Config_police.MarkerTypevehdel           = 24
Config_police.MarkerTypeboss             = 22
Config_police.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config_police.MarkerColor                = { r = 50, g = 50, b = 204 }

Config_police.EnablePlayerManagement     = true
Config_police.EnableArmoryManagement     = true
Config_police.EnableESXIdentity          = true
Config_police.EnableNonFreemodePeds      = false
Config_police.EnableSocietyOwnedVehicles = false
Config_police.EnableLicenses             = true
Config_police.EnableJobLogs              = true

Config_police.EnableHandcuffTimer        = false
Config_police.HandcuffTimer              = 10 * 60000

Config_police.EnableJobBlip              = true

Config_police.MaxInService               = -1
Config_police.Locale                     = 'en'

Config_police.PoliceStations = {

	LSPD = {

		Blip = {
			Pos     = { x = 439.0507, y = -981.906, z = 30.689 },
			Sprite  = 60,
			Display = 4,
			Scale   = 1.2,
			Colour  = 26,
		},

		 Blip2 = {
		 	Pos     = { x = 626.0573, y = 1.681767, z = 82.785 },
		 	Sprite  = 60,
		 	Display = 4,
		 	Scale   = 1.2,
		 	Colour  = 26,
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
			{ name = 'breathalyzer', price = 60, label = 'Test Alchol' },
			{ name = 'drugtest', price = 60, label = 'Test Mavad' },

		},

		Cloakrooms = {
			{ x = 461.59, y = -999.17, z = 30.69 },
			{ x = 461.88, y = -996.46, z = 30.69 },
			{x = 619.7421, y = 14.96955, z = 82.781},
			{ x = 1840.233, y = 3691.182, z = 34.286},

		},

		Armories = {
			{ x = 482.85, y = -995.61 , z = 30.69 },

			{ x = 627.1611, y = -22.4110, z = 82.779 },
			{x = 1846.653, y = 3694.171, z = 34.286},
		},

		Vehicles = {
			{
				Spawner    = { x = 459.50, y = -986.84, z = 25.70 },
				SpawnPoint = { x = 448.90, y = -981.23, z = 25.70 },
				Heading    = 90.00
			},

			{
				Spawner    = { x = 472.61, y = -1019.39, z = 28.2 },
				SpawnPoint = { x = 472.77, y = -1023.45, z = 28.2 },
				Heading    = 275.38
			},

			{
				Spawner    = { x = 617.0625, y = 23.97951, z = 88.835 },
				SpawnPoint = { x = 621.3605, y = 26.58137, z = 88.3982 },
				Heading    = 248.38
			},

			{
				Spawner    = { x = 1868.013, y = 3687.065, z = 33.815},
				SpawnPoint = { x = 1871.425, y = 3692.390, z = 33.591},
				Heading    = 192.32
			},

		},

		Helicopters = {
			{
				Spawner    = { x = 456.25, y = -974.68, z = 43.69 },
				SpawnPoint = { x = 449.12, y = -981.22, z = 43.69 },
				Heading    = 90.29
			},

			{
				Spawner    = { x = 567.4899, y = 7.857464, z = 103.22 },
				SpawnPoint = { x = 579.7794, y = 12.49081, z = 103.23 },
				Heading    = 90.29
			},

			{
				Spawner    = { x = 1864.269, y = 3663.138, z = 33.929   },
				SpawnPoint = { x = 1867.619, y = 3654.004, z = 33.884   },
				Heading    = 23.91
			},
		},

		VehicleDeleters = {
			{ x = 448.90, y = -981.23, z = 25.70 },
			{ x = 472.77, y = -1023.45, z = 28.2 },
			{ x = 462.74, y = -1019.02, z = 28.1 },
			{ x = 426.19, y = -978.83, z = 25.70 },
			{ x = 449.0, y = -981.21, z = 43.69 },
			{ x = 615.4552, y = 28.65608, z = 89.012 },
			{ x = 579.7794, y = 12.49081, z = 103.23 },
			{ x = 1871.425, y = 3692.390, z = 33.591},
			{ x = 1867.619, y = 3654.004, z = 33.884},
		},

		BossActions = {
			{ x = 459.75, y = -985.60, z = 30.73 },
		},
	},



}

Config_police.AuthorizedItems = {
	Shared = {
		{ name = 'water', price = 100 },
		{ name = 'silencer', price = 500 },





	},


}

Config_police.AuthorizedWeapons = {
	Shared = {
		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
		{ name = 'WEAPON_STUNGUN', price = 500 },
		{ name = 'WEAPON_FLASHLIGHT', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 5000 },
		{ name = 'WEAPON_SNSPISTOL', price = 6000 },
		{ name = 'WEAPON_COMBATPISTOL', price = 7000 },

	},



}

Config_police.AuthorizedVehicles = {
	Shared = {

	{ model = 'b2chal', label = 'Police Chal', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 0, ['5'] = 0 } },

	{ model = 'b211vic', label = 'Police Vic', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0, ['10'] = 1} },

	{ model = 'b212caprice', label = 'Police Caprice', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0} },

	{ model = 'b214charger', label = 'Police Charger', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['5'] = 0, ['6'] = 0, ['7'] = 1, ['8'] = 0 }},
	{ model = 'b214charger', label = 'Police Charger2', Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['5'] = 0, ['6'] = 0, ['7'] = 1, ['8'] = 1 }},

	{ model = 'b216explorer', label = 'Police Explorer',  Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1}},

	{ model = 'b218charger', label = 'Police Charger18', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0}},

	{ model = 'b218tau', label = 'Police Tau', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['6'] = 1, ['7'] = 0}},
	{ model = 'b218tau', label = 'Police Tau2', Extra = {['1'] = 1, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['6'] = 1, ['7'] = 0}},

	{ model = 'b219tahoe', label = "Police Tahoe", Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 0}},
	{ model = 'fibm5', label = "Police BMWM5", Extra = {['1'] = 0}},
	{ model = 'polnspeedo', label = "Police Van", Extra = {['11'] = 0}},
	{ model = 'POLKCH', label = "Police Kamacho", Extra = {['1'] = 0, ['3'] = 0, ['4'] = 0}},
	{ model = 'swat_dirtbike', label = "Police Motor", Extra = {['1'] = 1}},

	},

	Sharedheli = {

	{ model = 'polmav', label = 'Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	{ model = 'tx_heli', label = 'h1', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	},


}

Config_police.Uniforms = {

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