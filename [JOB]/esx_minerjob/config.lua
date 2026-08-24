Config = {
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


}

Strings = {
    ['press_mine'] = 'Press ~INPUT_CONTEXT~ to mine.',
    ['mining_info'] = 'Press ~INPUT_ATTACK~ to chop, ~INPUT_FRONTEND_RRIGHT~ to stop.',
    ['you_sold'] = 'You sold %sx %s for %s',
    ['someone_close'] = 'There is a player too close to you!',
    ['mining'] = 'Mine',
}