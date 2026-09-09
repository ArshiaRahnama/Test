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

-- Job Center (merged in from esx_joblisting): lets a player walk up and pick
-- one of esx_jobs' own jobs without needing a separate resource.
Config.JobCenter = {
	Pos         = {x = -265.0, y = -963.6, z = 30.2},
	DrawDistance = 5.0,
	Size        = {x = 3.0, y = 3.0, z = 1.5},
	MarkerColor = {r = 255, g = 0, b = 0},
	MarkerType  = 1
}

-- Display label shown in the Job Center menu for each job key.
Config.JobLabels = {
	fueler      = 'Fueler',
	lumberjack  = 'Lumberjack',
	slaughterer = 'Slaughterer',
	tailor      = 'Tailor',
	fisherman   = 'Fisherman',
	miner       = 'Miner'
}

-- ===== Miner job (merged in from esx_minerjob) =====
-- Namespaced under Config.Miner so it can't clobber the Config table above
-- (the original esx_minerjob/config.lua did `Config = {...}` as a *global*,
-- which would have wiped out every Config.Jobs/Config.Uniforms_* entry above
-- if loaded as-is in this same resource).
Config.Miner = {
    ChanceToGetItem = 23,
    Objects = {
        ['pickaxe'] = 'prop_tool_pickaxe',
    },

    Uniforms = {
        work_wear = {
			   male = {
				['tshirt_1'] = 184,
				['tshirt_2'] = 0,
				['torso_1'] = 160,
				['torso_2'] = 0,
				['decals_1'] = 0,
				['decals_2'] = 0,
				['arms'] = 23,
				['pants_1'] = 86,
				['pants_2'] = 2,
				['shoes_1'] = 42,
				['shoes_2'] = 0,
				['helmet_1'] = 0,
				['helmet_2'] = 0,
				['chain_1'] = 0,
				['chain_2'] = 0,
				['ears_1'] = -1,
				['ears_2'] = 0
			},
            female = {
                ['tshirt_1'] = 17,
                ['tshirt_2'] = 0,
                ['torso_1'] = 19,
                ['torso_2'] = 0,
                ['decals_1'] = 0,
                ['decals_2'] = 0,
                ['arms'] = 0,
                ['pants_1'] = 38,
                ['pants_2'] = 5,
                ['shoes_1'] = 16,
                ['shoes_2'] = 0,
                ['helmet_1'] = -1,
                ['helmet_2'] = 0,
                ['chain_1'] = 0,
                ['chain_2'] = 0,
                ['ears_1'] = 0,
                ['ears_2'] = 0
            }
        },
    },
    Blips = {
        {title="Madane Sang", colour= 5, id= 67, x = 2942.93, y = 2775.1, z = 39.22	},
        {title="Shostosho Va Qarbale Sangha", colour= 5, id= 67, x = 306.97, y = 2884.08, z = 42.46	},

        {title="Zoob Tala va Ahan", colour= 5, id= 67, x =1108.61, y = -2007.33, z = 30.9	},
        {title="Forosh Ajor", colour= 5, id= 67, x =2486.46, y = 1557.34, z = 31.91	},


    },
	MeltingField = {
        { coords = vector3(1109.52, -2013.08, 34.45) ,task = { c = vector3(1110.0, -2012.42, 35.44), h = 324.77 } },
        { coords = vector3(1114.24, -2006.08, 34.44) ,task = { c = vector3(1113.89, -2006.54, 35.44),h = 144.92 } }
    },
	WashField = {
        { coords = vector3(318.40, 2864.33, 42.52), h = 119.45 },
        { coords = vector3(306.97, 2884.08, 42.46), h = 114.08 },
        { coords = vector3(312.68, 2875.18, 42.50), h = 115.84 }
    },
	ISSell = {

    },
    DGSell = {

    },
    SSell = {
        coords = vector3(2486.46,1557.34,31.91)
    },

    SellLoc = vector3(182.82,-1319.45,29.32),
    ClackLoc = vector3(925.54, -1560.19, 29.74),
    VehLoc = vector3(922.26, -1556.8, 30.78),
    VehSpawn = vector3(910.69, -1565.42, 31.79),
    Rock = vector3(2942.93, 2775.1, 39.22),
    VehDelLoc = vector3(902.57, -1566.37, 29.82),

    Strings = {
        ['press_mine'] = 'Press ~INPUT_CONTEXT~ to mine.',
        ['mining_info'] = 'Press ~INPUT_ATTACK~ to chop, ~INPUT_FRONTEND_RRIGHT~ to stop.',
        ['you_sold'] = 'You sold %sx %s for %s',
        ['someone_close'] = 'There is a player too close to you!',
        ['mining'] = 'Mine',
    }
}
