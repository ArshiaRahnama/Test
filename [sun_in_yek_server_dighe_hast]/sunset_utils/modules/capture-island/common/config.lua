-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configCapIs = {
    zones = {
        {
            coords = vec(4598.1, -4863.82, 17.37, 1650.01),
            label = 'Jazire',
            blip = true,
            blipColor = 1,
            blipOpacity = 50,
            zombieConfig = 101,
            safeZone = {
                vec(3895.1, -4703.86, 4.42, 23.0),   -- safe 1
                vec(5580.52, -5219.09, 14.48, 23.0), -- safe 2
                vec(4890.35, -5736.57, 26.35, 23.0), -- safe 3
                vec(5478.76, -5847.96, 20.55, 23.0), -- Safe 4
                vec(5008.28, -5759.91, 16.27, 47.0), -- Safe 5
            },
            outdoorSafeRange = 100,
            weaponsLocation = {
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(5032.81, -4630.78, 21.68, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(5107.82, -4581.2, 29.72, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(4877.84, -4488.8, 26.93, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(4901.82, -5336.31, 35.61, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(5125.18, -5526.13, 70.97, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(5043.78, -5114.89, 22.94, 5.0)
                },
                {
                    name = 'weapon_marksmanrifle_mk2',
                    coords = vec(5266.43, -5427.52, 141.05, 5.0)
                },
            },
            teleporter = {
                {
                    from = vec(3908.37, -4704.04, 4.32, 2.0),   -- Safe 1
                    to = vec(607.35, -3057.4, 6.07, 359.8),     -- Sahel gun sazi
                    time = 10,
                },
                {
                    from = vec(5573.73, -5221.54, 15.44, 2.0),  -- Safe 2
                    to = vec(607.35, -3057.4, 6.07, 359.8),     -- Sahel gun sazi
                    time = 10,
                },
                {
                    from = vec(4890.12, -5738.13, 26.35, 2.0),   -- Safe 3
                    to = vec(607.35, -3057.4, 6.07, 359.8),     -- Sahel gun sazi
                    time = 10,
                },
                {
                    from = vec(5479.89, -5849.29, 20.51, 2.0),   -- Safe 4
                    to = vec(607.35, -3057.4, 6.07, 359.8),     -- Sahel gun sazi
                    time = 10,
                },
                {
                    from = vec(5018.66, -5739.65, 17.68, 2.0),   -- Safe 5
                    to = vec(607.35, -3057.4, 6.07, 359.8),     -- Sahel gun sazi
                    time = 10,
                }
            },
            flags = {
                {   --flag 1
                    coords = vec(4479.5, -4590.65, 5.56, 3.01),
                    label = 'Flag 1',
                    drawRange = 100,
                    captureTime = 120,
                    nearPerks = {
                        radius = 20,
                        time = 5,
                        vest = true,
                        add = 10,
                        headDisable = true,
                        uav = true,
                        uavRadius = 100,
                    },
                    reward = {
                        type = 1,
                        config = {
                            {'plan_give', 5}, -- {'WEAPON_SMG', 2}
                            {'point_give', 5},
                        },
                        salary = 1000,
                        time = 30.0,
                        deleteAfter = 2.0,
                    }
                },
                {   --flag 2
                    coords = vec(4995.74, -5166.95, 2.7, 3.01),
                    label = 'Flag 2',
                    drawRange = 100,
                    captureTime = 120,
                    nearPerks = {
                        radius = 20,
                        time = 5,
                        vest = true,
                        add = 10,
                        headDisable = true,
                        uav = true,
                        uavRadius = 100,
                    },
                    reward = {
                        type = 1,
                        config = {
                            {'plan_give', 5},
                            {'point_give', 5},
                        },
                        time = 30.0,
                        salary = 1000,
                        deleteAfter = 2.0,
                    }
                },
                {   --flag 3
                    coords = vec(5104.77, -4676.54, 2.29, 3.01),
                    label = 'Flag 3',
                    drawRange = 100,
                    captureTime = 120,
                    nearPerks = {
                        radius = 20,
                        time = 5,
                        vest = true,
                        add = 10,
                        headDisable = true,
                        uav = true,
                        uavRadius = 100,
                    },
                    reward = {
                        type = 1,
                        config = {
                            {'plan_give', 5},
                            {'point_give', 5},
                        },
                        time = 30.0,
                        salary = 1000,
                        deleteAfter = 2.0,
                    }
                },
                {   --flag 4
                    coords = vec(5263.34, -5432.39, 65.6, 3.01),
                    label = 'Flag 4',
                    drawRange = 100,
                    captureTime = 120,
                    nearPerks = {
                        radius = 20,
                        time = 5,
                        vest = true,
                        add = 10,
                        headDisable = true,
                        uav = true,
                        uavRadius = 100,
                    },
                    reward = {
                        type = 1,
                        config = {
                            {'plan_give', 5},
                            {'point_give', 5},
                        },
                        time = 30.0,
                        salary = 1000,
                        deleteAfter = 2.0,
                    }
                },
            },
        }
    }
}