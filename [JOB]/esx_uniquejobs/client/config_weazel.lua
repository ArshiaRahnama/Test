Config_weazel                            = {}
Config_weazel.DrawDistance               = 10.0
Config_weazel.MarkerColor                = { r = 102, g = 0, b = 102 }
Config_weazel.EnablePlayerManagement     = true
Config_weazel.MaxInService               = -1
Config_weazel.Locale                     = 'en'

Config_weazel.AuthorizedVehicles = {
	Shared = {
		{
			model = 'b219tahoe',
			label = 'Weazel Tahoe',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1}

		},
		{
			model = 'b218tau',
			label = 'Weazel Tau',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['6'] = 1, ['7'] = 1}
		},
		{
			model = 'b216explorer',
			label = 'Weazel Explorer',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b214charger',
			label = 'Weazel Charger',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1, ['8'] = 1 }
		},
		{
			model = 'b212caprice',
			label = 'Weazel Caprice',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b211vic',
			label = 'Weazel Vic',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['10'] = 1}
		},
		{
			model = 'b218charger',
			label = 'Weazel Charger18',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'swat_dirtbike',
			label = 'Weazel Motor',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
	},

	Sharedheli = {

	{ model = 'polmav', label = 'Weazel Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	{ model = 'tx_heli', label = 'Weazel Heli', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },



	},

}

Config_weazel.Blips = {

	Blip = {
		Pos     = { x = -586.21, y = -935.42, z = 23.82},
		Sprite  = 184,
		Display = 4,
		Scale   = 1.0,
		Colour  = 49,
	}
}

Config_weazel.Zones = {

    BossActions = {
        Pos   = { x = -574.35, y = -938.76, z = 28.82 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 22,
    },

	Cloakrooms = {
		Pos = { x = -560.32, y =-912.80, z = 33.34},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 21,
	},

    Vehicles = {
        Pos          = {x = -558.938, y = -939.693, z = 23.858},
        SpawnPoint   = {x = -556.927, y = -933.244, z = 23.852},
        Size         = { x = 1.5, y = 1.5, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 36,
        Heading      = 270.66,
	},

	Helicopters = {
        Pos          = { x = -576.46  , y = -924.80, z = 36.83 },
        SpawnPoint   = { x = -583.14, y = -930.56, z = 36.73},
        Size         = { x = 1.5, y = 1.5, z = 1.0 },
        Color        = { r = 0, g = 255, b = 128 },
        Type         = 7,
        Heading      = 90.00,
    },

	VehicleDeleters = {
		Pos  = {x = -616.009, y = -933.139, z = 22.315},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 24
	},

	VehicleDeleters2 = {
		Pos  = { x = -583.14, y = -930.56, z = 36.73},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 255, b = 128 },
		Type = 24
	},

}

Config_weazel.Uniforms = {
	secutiry_outfit = {
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 44,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 36,   ['shoes_2'] = 3,
			['chain_1'] = 20,  ['chain_2'] = 12
		},
		female = {
			['tshirt_1'] = 14,   ['tshirt_2'] = 0,
			['torso_1'] = 27,    ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 0,   ['pants_2'] = 8,
			['shoes_1'] = 3,    ['shoes_2'] = 2,
			['chain_1'] = 2,    ['chain_2'] = 1
		}
	},

  	reporter_outfit = {
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 44,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 36,   ['shoes_2'] = 3,
			['chain_1'] = 20,  ['chain_2'] = 12
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 24,   ['tshirt_2'] = 0,
			['torso_1'] = 28,   ['torso_2'] = 4,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}
	},

	investigator_outfit = {
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 44,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 36,   ['shoes_2'] = 3,
			['chain_1'] = 20,  ['chain_2'] = 12
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 20,   ['tshirt_2'] = 2,
			['torso_1'] = 24,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}
	},

	administrator_outfit = {
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 44,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 36,   ['shoes_2'] = 3,
			['chain_1'] = 20,  ['chain_2'] = 12
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 40,   ['tshirt_2'] = 7,
			['torso_1'] = 64,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}
	},

	boss_outfit = {
		male = {
			['tshirt_1'] = 10,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 44,   ['decals_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 36,   ['shoes_2'] = 3,
			['chain_1'] = 20,  ['chain_2'] = 12
		},
		female = {
			['glasses_1'] = 5,	['glasses_2'] = 0,
			['tshirt_1'] = 40,   ['tshirt_2'] = 7,
			['torso_1'] = 64,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 6,   ['pants_2'] = 0,
			['shoes_1'] = 13,   ['shoes_2'] = 0,
			['chain_1'] = 0,   ['chain_2'] = 0
		}
	}

}