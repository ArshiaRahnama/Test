Config              = {}
Config.DrawDistance = 10.0
Config.Locale       = 'en'
Config.Jobs         = {}

Config.PublicZones = {

	EnterBuilding = {
		Pos   = { x = -118.21, y = -607.14, z = 35.28 },
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_enter'),
		Teleport = { x = -139.09, y = -620.74, z = 167.82 }
	},

	ExitBuilding = {
		Pos   = { x = -139.45, y = -617.32, z = 167.82 },
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_leave'),
		Teleport = { x = -113.07, y = -604.93, z = 35.28 },
	}

}

Config.Uniforms_Fueler = {
	work_wear = {
		male = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 160,
			['torso_2'] = 0,
			['decals_1'] = 3,
			['decals_2'] = 0,
			['arms'] = 23,
			['pants_1'] = 48,
			['pants_2'] = 0,
			['shoes_1'] = 20,
			['shoes_2'] = 4,
			['helmet_1'] = 149,
			['helmet_2'] = 0,
			['glasses_1'] = 25,
  			['glasses_2'] = 0,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 136,
			['torso_2'] = 0,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 49,
			['pants_2'] = 1,
			['shoes_1'] = 10,
			['shoes_2'] = 4,
			['helmet_1'] = 59,
			['helmet_2'] = 0,
			['glasses_1'] = 22,
  			['glasses_2'] = 7,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		}
	},
}

Config.Uniforms_Lumberjack = {
	work_wear = {
		male = {
			['tshirt_1'] = 56,
			['tshirt_2'] = 0,
			['torso_1'] = 160,
			['torso_2'] = 0,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 45,
			['pants_1'] = 61,
			['pants_2'] = 10,
			['shoes_1'] = 19,
			['shoes_2'] = 4,
			['helmet_1'] = 199,
			['helmet_2'] = 0,
			['glasses_1'] = 17,
  			['glasses_2'] = 3,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = 149,
			['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 136,
			['torso_2'] = 0,
			['decals_1'] = 56,
			['decals_2'] = 0,
			['arms'] = 46,
			['pants_1'] = 49,
			['pants_2'] = 0,
			['shoes_1'] = 10,
			['shoes_2'] = 0,
			['helmet_1'] = 59,
			['helmet_2'] = 0,
			['glasses_1'] = 22,
  			['glasses_2'] = 7,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		}
	},
}

Config.Uniforms_Slaughterer = {
	work_wear = {
		male = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 39,
			['torso_2'] = 4,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 96,
			['pants_1'] = 83,
			['pants_2'] = 1,
			['shoes_1'] = 40,
			['shoes_2'] = 0,
			['helmet_1'] = -1,
			['helmet_2'] = 0,
			['glasses_1'] = 23,
  			['glasses_2'] = 0,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 131,
			['torso_2'] = 4,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 87,
			['pants_1'] = 77,
			['pants_2'] = 0,
			['shoes_1'] = 50,
			['shoes_2'] = 0,
			['helmet_1'] = -1,
			['helmet_2'] = 0,
			['glasses_1'] = 22,
  			['glasses_2'] = 7,
			['chain_1'] = 0,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		}
	},
}

Config.Uniforms_Tailor = {
	work_wear = {
		male = {
			['tshirt_1'] = 15,
			['tshirt_2'] = 0,
			['torso_1'] = 377,
			['torso_2'] = 0,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 82,
			['pants_1'] = 139,
			['pants_2'] = 1,
			['shoes_1'] = 44,
			['shoes_2'] = 0,
			['helmet_1'] = -1,
			['helmet_2'] = 0,
			['glasses_1'] = 6,
  			['glasses_2'] = 3,
			['chain_1'] = 4,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 42,
			['tshirt_2'] = 0,
			['torso_1'] = 58,
			['torso_2'] = 0,
			['decals_1'] = 0,
			['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 32,
			['pants_2'] = 3,
			['shoes_1'] = 43,
			['shoes_2'] = 3,
			['helmet_1'] = -1,
			['helmet_2'] = 0,
			['glasses_1'] = 4,
  			['glasses_2'] = 7,
			['chain_1'] = 120,
			['chain_2'] = 0,
			['ears_1'] = -1,
			['ears_2'] = 0
		}
	},
}
