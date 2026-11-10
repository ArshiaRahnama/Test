-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

Config.PlacementZones = {
    ['legion_square'] = {
        coords = vector3(221.024170, -856.087891, 30.206543),
        radius = 100.0,
        whitelistedLicenses = {
            "steam:11000013b961c60",
        },
        spawnLimit = 100,
        furniture = {
            {
                name = 'Traffic Cone',
                model = 'prop_mp_cone_02',
                price = 100
            },
            {
                name = 'Box',
                model = 'prop_tool_box_05',
                price = 200
            },
        }
    },
    ['vinewood_bowl'] = {
        coords = vector3(-1193.5, -892.5, 13.9),
        radius = 80.0,
        whitelistedLicenses = {
            "steam:11000013b961c60",
        },
        spawnLimit = 50,
        furniture = {
            {
                name = 'Bench',
                model = 'prop_bench_01a',
                price = 500
            },
            {
                name = 'Table',
                model = 'prop_table_04',
                price = 300
            },
            {
                name = 'Chair',
                model = 'prop_chair_01a',
                price = 150
            },
        }
    },
}

return Config