-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}
Config.HousePosition =  vector3(-1998.9, 3198.07, -133.81)
Config.GaragePosition = vector3(-1998.9, 3198.07, 33.81)
Config.LockerHash = {
    [`p_cs_locker_02`] = true,
    [`p_cs_locker_01`] = true,
    [`p_cs_locker_01_s`] = true,
}

Config.SafeHash = {
    [`prop_ld_int_safe_01`] = true,
    [`p_v_43_safe_s`] = true,
}

Config.SafeUpgradeObject = {
    [2] = {
        from = {
            ['prop_ld_int_safe_01'] = true,
        },
        to = 'p_v_43_safe_s'
    },
}

Config.LockerUpgradeObject = {
    [2] = {
        from = {
            ['p_cs_locker_02'] = true,
        },
        to = 'p_cs_locker_01'
    },
    [3] = {
        from = {
            ['p_cs_locker_02'] = true,
            ['p_cs_locker_01'] = true,
        },
        to = 'p_cs_locker_01_s',
    },
}

Config.ShellCoords = {
    ['shell_apartment1'] = {
        Join = vector4(-2.3,8.93,8.69,171.77),
        InventoryLevel = {
            {
                Price = 0,
                Size = 50,
            },
            {
                Price = 1000000,
                Size = 70,
            },
            {
                Price = 5000000,
                Size = 110,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 5000000,
                Size = 35,
            },
        },
    },
    ['shell_apartment2'] = {
        Join = vector4(-2.3,8.93,8.69,171.77),
        InventoryLevel = {
            {
                Price = 0,
                Size = 50,
            },
            {
                Price = 1000000,
                Size = 70,
            },
            {
                Price = 5000000,
                Size = 110,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 5000000,
                Size = 35,
            },
        },
    },
    ['shell_apartment3'] = {
        Join = vector4(11.6,4.5,8.13,134.99),
        InventoryLevel = {
            {
                Price = 0,
                Size = 50,
            },
            {
                Price = 1000000,
                Size = 100,
            },
            {
                Price = 5000000,
                Size = 200,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 30,
            },
            {
                Price = 5000000,
                Size = 50,
            },
        },
    },
    ['shell_barber'] = {
        Join = vector4(1.57,5.17,1.0,183.22),
        InventoryLevel = {
            {
                Price = 0,
                Size = 5,
            },
            {
                Price = 1000,
                Size = 10,
            },
            {
                Price = 2000,
                Size = 15,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 5,
            },
            {
                Price = 1000,
                Size = 10,
            },
        },
    },
    ['shell_coke1'] = {
        Join = vector4(-6.29,8.61,1.0,184.56),
    },
    ['shell_coke2'] = {
        Join = vector4(-6.29,8.61,1.0,184.56),
    },
    ['shell_frankaunt'] = {
        Join = vector4(-0.5,-5.18,1.71,0.65),
        InventoryLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 250000,
                Size = 30,
            },
            {
                Price = 500000,
                Size = 50,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 3000000,
                Size = 20,
            },
        },
    },
    ['shell_garagel'] = {
        Join = vector4(12.62,-14.34,1.0,88.85),
    },
    ['shell_garagem'] = {
        Join = vector4(13.38,1.59,1.0,92.74),
    },
    ['shell_garages'] = {
        Join = vector4(5.85,3.22,1.0,184.74),
    },
    ['shell_gunstore'] = {
        Join = vector4(-1.26,-4.95,1.03,358.98),
    },
    ['shell_highend'] = {
        Join = vector4(-21.08,-0.52,7.26,271.53),
        InventoryLevel = {
            {
                Price = 0,
                Size = 40,
            },
            {
                Price = 1000000,
                Size = 60,
            },
            {
                Price = 5000000,
                Size = 100,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 5000000,
                Size = 30,
            },
        },
    },
    ['shell_highendv2'] = {
        Join = vector4(-10.26,0.79,6.55,271.61),
        InventoryLevel = {
            {
                Price = 0,
                Size = 40,
            },
            {
                Price = 1000000,
                Size = 60,
            },
            {
                Price = 5000000,
                Size = 100,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 5000000,
                Size = 30,
            },
        },
    },
    ['shell_lester'] = {
        Join = vector4(-1.75,-5.85,1.11,1.2),
        InventoryLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 75000,
                Size = 20,
            },
            {
                Price = 100000,
                Size = 30,
            },
        },
        SafeLevel = {
            {
                Price = 1000000,
                Size = 2,
            },
            {
                Price = 1000000,
                Size = 5,
            },
        },
    },
    ['shell_medium2'] = {
        Join = vector4(6.25,0.79,1.03,2.81),
        InventoryLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 250000,
                Size = 30,
            },
            {
                Price = 500000,
                Size = 50,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 3000000,
                Size = 20,
            },
        },
    },
    ['shell_medium3'] = {
        Join = vector4(3.74,1.26,2.57,264.4),
        InventoryLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 250000,
                Size = 30,
            },
            {
                Price = 300000,
                Size = 40,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 2000000,
                Size = 15,
            },
        },
    },
    ['shell_meth'] = {
        Join = vector4(-6.39,8.45,1.04,189.35),
    },
    ['shell_michael'] = {
        Join = vector4(-9.18,7.2,9.92,273.3),
        InventoryLevel = {
            {
                Price = 0,
                Size = 50,
            },
            {
                Price = 1000000,
                Size = 100,
            },
            {
                Price = 5000000,
                Size = 200,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 30,
            },
            {
                Price = 5000000,
                Size = 50,
            },
        },
    },
    ['shell_office1'] = {
        Join = vector4(1.16,4.96,2.05,173.72),
        InventoryLevel = {
            {
                Price = 0,
                Size = 30,
            },
            {
                Price = 250000,
                Size = 35,
            },
            {
                Price = 500000,
                Size = 40,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 5,
            },
            {
                Price = 1500000,
                Size = 10,
            },
        },
    },
    ['shell_office2'] = {
        Join = vector4(3.52,-2.09,1.27,84.98),
        InventoryLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 250000,
                Size = 30,
            },
            {
                Price = 500000,
                Size = 50,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 15,
            },
            {
                Price = 5000000,
                Size = 30,
            },
        },
    },
    ['shell_officebig'] = {
        Join = vector4(-12.49,-1.14,5.3,268.6),
        InventoryLevel = {
            {
                Price = 0,
                Size = 35,
            },
            {
                Price = 250000,
                Size = 45,
            },
            {
                Price = 500000,
                Size = 60,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 5000000,
                Size = 30,
            },
        },
    },
    ['shell_ranch'] = {
        Join = vector4(-1.26,5.4,2.4,269.26),
        InventoryLevel = {
            {
                Price = 0,
                Size = 50,
            },
            {
                Price = 1000000,
                Size = 70,
            },
            {
                Price = 5000000,
                Size = 110,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 5000000,
                Size = 35,
            },
        },
    },
    ['shell_store1'] = {
        Join = vector4(-2.54,4.11,1.09,179.94),
        InventoryLevel = {
            {
                Price = 0,
                Size = 30,
            },
            {
                Price = 250000,
                Size = 35,
            },
            {
                Price = 500000,
                Size = 40,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 5,
            },
            {
                Price = 1500000,
                Size = 10,
            },
        },
    },
    ['shell_store2'] = {
        Join = vector4(-0.69,-4.65,1.02,358.98),
        InventoryLevel = {
            {
                Price = 0,
                Size = 35,
            },
            {
                Price = 250000,
                Size = 40,
            },
            {
                Price = 500000,
                Size = 45,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 5,
            },
            {
                Price = 1500000,
                Size = 10,
            },
        },
    },
    ['shell_store3'] = {
        Join = vector4(-0.03,-7.48,2.01,357.5),
    },
    ['shell_trailer'] = {
        Join = vector4(-1.44,-1.85,2.9,1.8),
        InventoryLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 75000,
                Size = 20,
            },
            {
                Price = 100000,
                Size = 30,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 2,
            },
            {
                Price = 1000000,
                Size = 5,
            },
        },
    },
    ['shell_trevor'] = {
        Join = vector4(0.18,-3.47,2.43,354.72),
        InventoryLevel = {
            {
                Price = 0,
                Size = 20,
            },
            {
                Price = 250000,
                Size = 30,
            },
            {
                Price = 500000,
                Size = 50,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 10,
            },
            {
                Price = 3000000,
                Size = 20,
            },
        },
    },
    ['shell_v16low'] = {
        Join = vector4(4.7,-6.39,1.04,359.38),
        InventoryLevel = {
            {
                Price = 0,
                Size = 15,
            },
            {
                Price = 100000,
                Size = 25,
            },
            {
                Price = 200000,
                Size = 35,
            },
        },
        SafeLevel = {
            {
                Price = 0,
                Size = 2,
            },
            {
                Price = 1000000,
                Size = 5,
            },
        },
    },
    ['shell_warehouse1'] = {
        Join = vector4(-8.85,0.08,1.04,266.17),
    },
    ['shell_warehouse2'] = {
        Join = vector4(-8.85,0.08,1.04,266.17),
    },
    ['shell_warehouse3'] = {
        Join = vector4(2.57,-1.81,1.0,93.98),
    },
    ['shell_weed'] = {
        Join = vector4(17.84,11.73,1.02,87.35),
    },
    ['shell_weed2'] = {
        Join = vector4(17.84,11.73,1.02,87.35),
    },
}

Config.GarageCoords = {
    ['shell_garages'] = {
        Slot = {
            [1] =vector4(-0.22,-0.72,1.29,179.7),
        },
    },
    ['shell_garagem'] = {
        Slot = {
            [1] = vector4(-4.38,0.04,1.27,268.99),
            [2] = vector4(-4.41,4.93,1.27,270.82),
            [3] = vector4(-4.35,-5.0,1.27,270.66),
            [4] = vector4(3.39,-4.89,1.27,87.87),
            [5] = vector4(3.61,5.12,1.27,91.33),
        },
    },
    ['shell_garagel'] = {
        Slot = {
            [1] = vector4(6.17,-7.53,1.27,178.91),
            [2] = vector4(0.25,-8.12,1.27,180.1),
            [3] = vector4(-5.61,-7.91,1.27,179.87),
            [4] = vector4(6.12,0.01,1.27,183.01),
            [5] = vector4(0.11,-0.42,1.27,181.8),
            [6] = vector4(-5.42,-0.12,1.27,178.7),
            [7] = vector4(4.94,7.58,0.65,178.66),
            [8] = vector4(-0.3,7.32,1.27,180.83),
            [9] = vector4(-5.46,8.31,1.27,181.38),
            [10] = vector4(-5.66,20.58,1.27,180.08),
        },
    },
}