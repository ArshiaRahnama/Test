
Customize = {}

Customize.ESX = "ESX"

Customize.Mysql = "oxmysql"

Customize.GetVehFuel = function(Veh)
    return exports['LegacyFuel']:GetFuel(Veh)
end
Customize.SetVehFuel = function(Veh, Fuel)
    return exports['LegacyFuel']:SetFuel(Veh, Fuel)
end

Customize.GaragesPrice = 0
Customize.ImpoundGaragesPrice = 600
Customize.JobGaragesPrice = 1

Customize.UseDamageMult = true
Customize.DamageMult    = 8

Customize.BoatPoundPrice     = 50000
Customize.AircraftPoundPrice = 100000

Customize.Garages = {
    {
        Blips = {
            Position = vector3(213.56, -809.54, 31.01),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(213.56, -809.54, 31.01), Heading = 340.67 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(236.95, -783.71, 30.63, 179.64),
            location = { posX = 233.37, posY = -789.9, posZ = 30.6, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(212.39, -797.34, 30.88),
        VehSpawnPos = vector4(209.64, -791.39, 30.5, 248.63),
    },
    {
        Blips = {
            Position = vector3(596.49, 90.62, 93.13),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(596.49, 90.62, 93.13), Heading = 338.84 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(608.5, 114.57, 30.63, 92.6),
            location = { posX = 605.62, posY = 105.15, posZ = 92.87, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(608.46, 104.16, 92.47),
        VehSpawnPos = vector4(608.46, 104.16, 92.47, 69.59),
    },
    {
        Blips = {
            Position = vector3(101.34, -1073.53, 29.37),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(101.34, -1073.53, 29.37), Heading = 69.88 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(131.24, -1059.99, 28.84, 158.13),
            location = { posX = 126.01, posY = -1070.79, posZ = 29.19, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(117.5, -1081.27, 28.84),
        VehSpawnPos = vector4(117.5, -1081.27, 28.84, 1.26),
    },
    {
        Blips = {
            Position = vector3(-157.87, -154.73, 43.62),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-157.87, -154.73, 43.62), Heading = 157.95 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-159.99, -160.09, 43.27, 159.44),
            location = { posX = -162.15, posY = -164.8, posZ = 43.62, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-180.79, -178.36, 43.27),
        VehSpawnPos = vector4(-180.79, -178.36, 43.27, 343.27),
    },
    {
        Blips = {
            Position = vector3(1035.99, -763.98, 57.99),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(1035.99, -763.98, 57.99), Heading = 326.01 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(1042.04, -771.32, 57.67, 186.31),
            location = { posX = 1037.75, posY = -778.58, posZ = 58.2, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1045.93, -774.45, 57.67),
        VehSpawnPos = vector4(1045.93, -774.45, 57.67, 90.25),
    },
    {
        Blips = {
            Position = vector3(610.06, 2746.19, 41.98),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(610.06, 2746.19, 41.98), Heading = 171.07 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(612.95, 2741.33, 41.58, 178.67),
            location = { posX = 607.61, posY = 2731.46, posZ = 42.0, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(612.23, 2723.95, 41.52),
        VehSpawnPos = vector4(612.23, 2723.95, 41.52, 3.68),
    },
    {
        Blips = {
            Position = vector3(-281.27, -888.95, 31.32),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-281.27, -888.95, 31.32), Heading = 334.02 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-292.3, -886.7, 30.74, 165.4),
            location = { posX = -301.97, posY = -898.44, posZ = 31.08, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-292.3, -886.7, 30.74),
        VehSpawnPos = vector4(-292.3, -886.7, 30.74, 165.4),
    },
    {
        Blips = {
            Position = vector3(1526.46, 3776.08, 34.51),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(1526.46, 3776.08, 34.51), Heading = 217.39 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(1516.74, 3762.97, 33.68, 194.94),
            location = { posX = 1512.68, posY = 3748.84, posZ = 34.23, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1516.74, 3762.97, 33.68),
        VehSpawnPos = vector4(1516.74, 3762.97, 33.68, 194.94),
    },
    {
        Blips = {
            Position = vector3(119.45, 6626.52, 31.96),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(119.45, 6626.52, 31.96), Heading = 223.73 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(134.82, 6625.46, 31.34, 171.21),
            location = { posX = 130.98, posY = 6614.19, posZ = 31.84, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(151.04, 6606.6, 31.52),
        VehSpawnPos = vector4(151.04, 6606.6, 31.52, 359.71),
    },
    {
        Blips = {
            Position = vector3(4454.28, -4475.95, 4.32),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(4454.28, -4475.95, 4.32), Heading = 195.71 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(4468.26, -4480.04, 3.87, 117.3),
            location = { posX = 4460.96, posY = -4496.17, posZ = 4.2, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(4432.82, -4491.54, 3.87),
        VehSpawnPos = vector4(4432.82, -4491.54, 3.87, 204.85),
    },
    {
        Blips = {
            Position = vector3(-956.46, -178.77, 41.88),
            Label = "Garage System",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(-956.46, -178.77, 41.88), Heading = 295.45 },
        Type = 'car',
        UIName = 'Pilbox Hill',
        Camera = {
            vehSpawn = vector4(-920.48, -154.48, 41.53, 202.41),
            location = { posX = -926.34, posY = -165.19, posZ = 41.88, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-920.48, -154.48, 41.53),
        VehSpawnPos = vector4(-920.48, -154.48, 41.53, 202.41),
    },








































    {
        Blips = {
            Position = vector3(240.77, -792.27, 30.48),
            Label = "Car Garage - garag 1",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(240.77, -792.27, 30.48), Heading = 35.00 },
        Type = 'car',
        UIName = 'Garag 1',
        Camera = {
            vehSpawn = vector4(229.72, -806.15, 30.51, 160.00),
            location = { posX = 240.77, posY = -792.27, posZ = 30.48, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(240.77, -792.27, 30.48),
        VehSpawnPos = vector4(229.72, -806.15, 30.51, 160.00),
    },
    {
        Blips = {
            Position = vector3(126.88, -1073.28, 29.19),
            Label = "Car Garage - garag 2",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(126.88, -1073.28, 29.19), Heading = 30.00 },
        Type = 'car',
        UIName = 'Garag 2',
        Camera = {
            vehSpawn = vector4(107.55, -1063.97, 28.8, 244.74),
            location = { posX = 126.88, posY = -1073.28, posZ = 29.19, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(126.88, -1073.28, 29.19),
        VehSpawnPos = vector4(107.55, -1063.97, 28.8, 244.74),
    },
    {
        Blips = {
            Position = vector3(373.00, 281.15, 103.37),
            Label = "Car Garage - garag 3",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(373.00, 281.15, 103.37), Heading = 23.00 },
        Type = 'car',
        UIName = 'Garag 3',
        Camera = {
            vehSpawn = vector4(370.91, 284.2, 102.91, 340.21),
            location = { posX = 373.00, posY = 281.15, posZ = 103.37, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(373.00, 281.15, 103.37),
        VehSpawnPos = vector4(370.91, 284.2, 102.91, 340.21),
    },
    {
        Blips = {
            Position = vector3(-300.55, -905.57, 31.6),
            Label = "Car Garage - garag 4",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-300.55, -905.57, 31.6), Heading = 30.00 },
        Type = 'car',
        UIName = 'Garag 4',
        Camera = {
            vehSpawn = vector4(-296.29, -886.75, 31.08, 167.32),
            location = { posX = -300.55, posY = -905.57, posZ = 31.6, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-300.55, -905.57, 31.6),
        VehSpawnPos = vector4(-296.29, -886.75, 31.08, 167.32),
    },
    {
        Blips = {
            Position = vector3(1730.04, 3719.86, 34.07),
            Label = "Car Garage - garag 5",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(1730.04, 3719.86, 34.07), Heading = 12.00 },
        Type = 'car',
        UIName = 'Garag 5',
        Camera = {
            vehSpawn = vector4(1737.84, 3719.28, 33.04, 21.22),
            location = { posX = 1730.04, posY = 3719.86, posZ = 34.07, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1730.04, 3719.86, 34.07),
        VehSpawnPos = vector4(1737.84, 3719.28, 33.04, 21.22),
    },
    {
        Blips = {
            Position = vector3(130.05, 6606.26, 31.85),
            Label = "Car Garage - garag 6",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(130.05, 6606.26, 31.85), Heading = 23.00 },
        Type = 'car',
        UIName = 'Garag 6',
        Camera = {
            vehSpawn = vector4(128.78, 6622.99, 30.78, 315.01),
            location = { posX = 130.05, posY = 6606.26, posZ = 31.85, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(130.05, 6606.26, 31.85),
        VehSpawnPos = vector4(128.78, 6622.99, 30.78, 315.01),
    },
    {
        Blips = {
            Position = vector3(-1620.85, 5123.33, 19.79),
            Label = "Car Garage - garag 7 paintball",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-1620.85, 5123.33, 19.79), Heading = 18.00 },
        Type = 'car',
        UIName = 'Garag 7 Paintball',
        Camera = {
            vehSpawn = vector4(-1632.97, 5115.16, 19.79, 300.47),
            location = { posX = -1620.85, posY = 5123.33, posZ = 19.79, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1620.85, 5123.33, 19.79),
        VehSpawnPos = vector4(-1632.97, 5115.16, 19.79, 300.47),
    },
    {
        Blips = {
            Position = vector3(1196.37, -1382.36, 35.22),
            Label = "Car Garage - garag 8 bimarestan",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(1196.37, -1382.36, 35.22), Heading = 15.00 },
        Type = 'car',
        UIName = 'Garag 8 Bimarestan',
        Camera = {
            vehSpawn = vector4(1198.35, -1402.86, 35.22, 180.96),
            location = { posX = 1196.37, posY = -1382.36, posZ = 35.22, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1196.37, -1382.36, 35.22),
        VehSpawnPos = vector4(1198.35, -1402.86, 35.22, 180.96),
    },
    {
        Blips = {
            Position = vector3(610.24, 95.89, 92.54),
            Label = "Car Garage - garag 9 PD2",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(610.24, 95.89, 92.54), Heading = 20.00 },
        Type = 'car',
        UIName = 'Garag 9 Pd2',
        Camera = {
            vehSpawn = vector4(600.2, 97.82, 92.33, 246.48),
            location = { posX = 610.24, posY = 95.89, posZ = 92.54, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(610.24, 95.89, 92.54),
        VehSpawnPos = vector4(600.2, 97.82, 92.33, 246.48),
    },
    {
        Blips = {
            Position = vector3(-2036.26, -471.74, 11.42),
            Label = "Car Garage - garag 10 saheli",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-2036.26, -471.74, 11.42), Heading = 25.00 },
        Type = 'car',
        UIName = 'Garag 10 Saheli',
        Camera = {
            vehSpawn = vector4(-2024.47, -472.47, 11.4, 319.31),
            location = { posX = -2036.26, posY = -471.74, posZ = 11.42, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-2036.26, -471.74, 11.42),
        VehSpawnPos = vector4(-2024.47, -472.47, 11.4, 319.31),
    },
    {
        Blips = {
            Position = vector3(540.35, -3044.67, 6.07),
            Label = "Car Garage - garag 11 Island tp",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 18,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(540.35, -3044.67, 6.07), Heading = 15.00 },
        Type = 'car',
        UIName = 'Garag 11 Island Tp',
        Camera = {
            vehSpawn = vector4(542.86, -3051.00, 6.07, 2.47),
            location = { posX = 540.35, posY = -3044.67, posZ = 6.07, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(540.35, -3044.67, 6.07),
        VehSpawnPos = vector4(542.86, -3051.00, 6.07, 2.47),
    },
    {
        Blips = {
            Position = vector3(-1653.2, -3145.96, 14.00),
            Label = "Airport - foroodgah payin",
            Sprite = 90,
            Display = 4,
            Scale = 0.7,
            Color = 5,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-1653.2, -3145.96, 14.00), Heading = 35.00 },
        Type = 'air',
        UIName = 'Foroodgah Payin',
        Camera = {
            vehSpawn = vector4(-1653.1, -3144.63, 13.99, 327.71),
            location = { posX = -1653.2, posY = -3145.96, posZ = 14.00, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1653.2, -3145.96, 14.00),
        VehSpawnPos = vector4(-1653.1, -3144.63, 13.99, 327.71),
    },
    {
        Blips = {
            Position = vector3(1693.54, 3247.75, 40.9),
            Label = "Airport - foroodgah sandy",
            Sprite = 90,
            Display = 4,
            Scale = 0.7,
            Color = 5,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(1693.54, 3247.75, 40.9), Heading = 30.00 },
        Type = 'air',
        UIName = 'Foroodgah Sandy',
        Camera = {
            vehSpawn = vector4(1693.54, 3247.75, 40.9, 100.42),
            location = { posX = 1693.54, posY = 3247.75, posZ = 40.9, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1693.54, 3247.75, 40.9),
        VehSpawnPos = vector4(1693.54, 3247.75, 40.9, 100.42),
    },
    {
        Blips = {
            Position = vector3(2123.97, 4801.5, 41.03),
            Label = "Airport - foroodgah sandy mythic",
            Sprite = 90,
            Display = 4,
            Scale = 0.7,
            Color = 5,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(2123.97, 4801.5, 41.03), Heading = 30.00 },
        Type = 'air',
        UIName = 'Foroodgah Sandy Mythic',
        Camera = {
            vehSpawn = vector4(2123.97, 4801.5, 41.03, 112.62),
            location = { posX = 2123.97, posY = 4801.5, posZ = 41.03, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(2123.97, 4801.5, 41.03),
        VehSpawnPos = vector4(2123.97, 4801.5, 41.03, 112.62),
    },
    {
        Blips = {
            Position = vector3(-1619.75, 5153.14, 21.52),
            Label = "Airport - paintball 1",
            Sprite = 90,
            Display = 4,
            Scale = 0.7,
            Color = 5,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-1619.75, 5153.14, 21.52), Heading = 8.00 },
        Type = 'air',
        UIName = 'Paintball 1',
        Camera = {
            vehSpawn = vector4(-1619.75, 5153.14, 21.52, 30.89),
            location = { posX = -1619.75, posY = 5153.14, posZ = 21.52, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1619.75, 5153.14, 21.52),
        VehSpawnPos = vector4(-1619.75, 5153.14, 21.52, 30.89),
    },
    {
        Blips = {
            Position = vector3(-1645.35, 5138.98, 21.52),
            Label = "Airport - paintball 2",
            Sprite = 90,
            Display = 4,
            Scale = 0.7,
            Color = 5,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-1645.35, 5138.98, 21.52), Heading = 8.00 },
        Type = 'air',
        UIName = 'Paintball 2',
        Camera = {
            vehSpawn = vector4(-1645.35, 5138.98, 21.52, 32.17),
            location = { posX = -1645.35, posY = 5138.98, posZ = 21.52, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1645.35, 5138.98, 21.52),
        VehSpawnPos = vector4(-1645.35, 5138.98, 21.52, 32.17),
    },
    {
        Blips = {
            Position = vector3(-718.87, -1320.18, -0.47),
            Label = "Boat Dock - boat 1",
            Sprite = 410,
            Display = 4,
            Scale = 0.7,
            Color = 3,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-718.87, -1320.18, -0.47), Heading = 15.00 },
        Type = 'sea',
        UIName = 'Boat 1',
        Camera = {
            vehSpawn = vector4(-718.87, -1320.18, -0.47, 45.00),
            location = { posX = -718.87, posY = -1320.18, posZ = -0.47, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-718.87, -1320.18, -0.47),
        VehSpawnPos = vector4(-718.87, -1320.18, -0.47, 45.00),
    },
    {
        Blips = {
            Position = vector3(1334.61, 4264.68, 29.86),
            Label = "Boat Dock - boat 2",
            Sprite = 410,
            Display = 4,
            Scale = 0.7,
            Color = 3,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(1334.61, 4264.68, 29.86), Heading = 15.00 },
        Type = 'sea',
        UIName = 'Boat 2',
        Camera = {
            vehSpawn = vector4(1334.61, 4264.68, 29.86, 87.00),
            location = { posX = 1334.61, posY = 4264.68, posZ = 29.86, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(1334.61, 4264.68, 29.86),
        VehSpawnPos = vector4(1334.61, 4264.68, 29.86, 87.00),
    },
    {
        Blips = {
            Position = vector3(-290.46, 6622.72, -0.47),
            Label = "Boat Dock - boat 3",
            Sprite = 410,
            Display = 4,
            Scale = 0.7,
            Color = 3,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-290.46, 6622.72, -0.47), Heading = 15.00 },
        Type = 'sea',
        UIName = 'Boat 3',
        Camera = {
            vehSpawn = vector4(-290.46, 6622.72, -0.47, 52.00),
            location = { posX = -290.46, posY = 6622.72, posZ = -0.47, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-290.46, 6622.72, -0.47),
        VehSpawnPos = vector4(-290.46, 6622.72, -0.47, 52.00),
    },
    {
        Blips = {
            Position = vector3(-1600.48, 5262.57, 0.31),
            Label = "Boat Dock - boat 4",
            Sprite = 410,
            Display = 4,
            Scale = 0.7,
            Color = 3,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-1600.48, 5262.57, 0.31), Heading = 15.00 },
        Type = 'sea',
        UIName = 'Boat 4',
        Camera = {
            vehSpawn = vector4(-1600.48, 5262.57, 0.31, 40.5),
            location = { posX = -1600.48, posY = 5262.57, posZ = 0.31, rotX = 0.0, rotY = 0.0, rotZ = -22.0, fov = 50.0 },
        },
        VehPutPos = vector3(-1600.48, 5262.57, 0.31),
        VehSpawnPos = vector4(-1600.48, 5262.57, 0.31, 40.5),
    },

}

Customize.JobGarages = {





















}

Customize.ImpoundGarages = {
    {
        Blips = {
            Position = vector3(409.43, -1623.11, 29.29),
            Label = "Impound Garages",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 1,
        },
        Npc = {  Hash = "s_m_y_barman_01", Pos = vector3(409.43, -1623.11, 29.29), Heading = 233.95 },
        Type = 'car',
        UIName = 'Police',
        Camera = {
            vehSpawn = vector4(402.04, -1632.39, 28.9, 159.52),
            location = { posX = 402.56, posY = -1644.22, posZ = 31.76, rotX = -10.0, rotY = 0.0, rotZ = 22.0, fov = 50.0 },
        },
        VehSpawnPos = vector4(419.88, -1629.18, 28.9, 140.26),
    },

    {
        Blips = {
            Position = vector3(-191.77, -1166.11, 23.67),
            Label = "Impound Garages 1",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 1,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-191.77, -1166.11, 23.67), Heading = 0.0 },
        Type = 'car',
        UIName = 'Impound 1',
        Camera = {
            vehSpawn = vector4(-191.77, -1166.11, 23.67, 0.0),
            location = { posX = -191.77, posY = -1166.11, posZ = 23.67, rotX = -10.0, rotY = 0.0, rotZ = 22.0, fov = 50.0 },
        },
        VehSpawnPos = vector4(-191.77, -1166.11, 23.67, 0.0),
    },
    {
        Blips = {
            Position = vector3(1651.38, 3804.84, 37.65),
            Label = "Impound Garages 2",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 1,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(1651.38, 3804.84, 37.65), Heading = 0.0 },
        Type = 'car',
        UIName = 'Impound 2',
        Camera = {
            vehSpawn = vector4(1651.38, 3804.84, 37.65, 0.0),
            location = { posX = 1651.38, posY = 3804.84, posZ = 37.65, rotX = -10.0, rotY = 0.0, rotZ = 22.0, fov = 50.0 },
        },
        VehSpawnPos = vector4(1651.38, 3804.84, 37.65, 0.0),
    },
    {
        Blips = {
            Position = vector3(-234.82, 6198.65, 30.9),
            Label = "Impound Garages 3",
            Sprite = 357,
            Display = 4,
            Scale = 0.7,
            Color = 1,
        },
        Npc = { Hash = "s_m_y_barman_01", Pos = vector3(-234.82, 6198.65, 30.9), Heading = 0.0 },
        Type = 'car',
        UIName = 'Impound 3',
        Camera = {
            vehSpawn = vector4(-234.82, 6198.65, 30.9, 0.0),
            location = { posX = -234.82, posY = 6198.65, posZ = 30.9, rotX = -10.0, rotY = 0.0, rotZ = 22.0, fov = 50.0 },
        },
        VehSpawnPos = vector4(-234.82, 6198.65, 30.9, 0.0),
    },
}

Customize.ParkMeter = {

	vector4(209.9976, -848.596, 30.2, 252.41),

	vector4(-393.05, -119.06, 38.55,298.0),

	vector4(307.08, -1080.92, 29.30,121.0),

	vector4(-53.59, -1116.49, 26.38, 4.0),

	vector4(238.33, 196.32, 105.08,70.0),

	vector4(1855.321, 3672.612, 33.936, 174.73),

	vector4(-435.48,6031.76,31.29, 29.0),

	vector4(371.29,-951.33,29.36,131.19),

	vector4(220.10, -1384.57, 30.50,273.60),


	vector4(-125.96,6478.01,31.47,134.92),

	vector4(-2955.91,492.85,15.31,84.07),

	vector4(-1100.78,-259.02,37.69,197.54),

	vector4(298.17,-268.35,54.02,339.93),
	vector4(-1193.0,-318.24,37.71,31.8),
	vector4(1192.75,2695.76,37.93,99.34),
	vector4(148.0729, -1028.10, 29.215, 246.89),
	vector4(-346.697, -28.8208, 47.387, 243.76),

	vector4(-1617.59, 5004.727, 47.655, 203.53),


	vector4(879.51, -2174.85, 30.52,174.62),

	vector4(-1057.8,-2019.48,13.16,136.13),

	vector4(1205.69,-1266.3,35.23,172.99),

	vector4(704.42,-986.2,24.09,275.0),

	vector4(550.75,-2307.61,5.88,263.27),

	vector4(296.61,-604.75,43.32, 70.0),

	vector4(-229.587, 6310.491, 31.380, 129.43),

	vector4(-388.021, 1194.434, 325.64, 96.94),

	vector4(1742.104, 3797.224, 34.250, 117.76),

	vector4(-683.049, -1112.95, 14.525, 30.6),

	vector4(764.5612, -156.799, 74.435, 54.8),

	vector4(-776.087, 306.6092, 85.700, 87.93),

	vector4(567.3180, -1764.72, 29.165, 328.63),

	vector4(97.65206, 6376.479, 31.225, 11.45),

	vector4(1157.076, -330.597, 68.958, 190.47),
	vector4(1164.447, 2695.738, 37.791, 182.48),
	vector4(1695.968, 4934.767, 42.078, 52.01),
	vector4(-718.666, -920.364, 19.013, 177.9),
	vector4(-1234.66, -899.294, 11.978, 295.24),
	vector4(2682.160, 3275.360, 55.240, 151.17),
	vector4(-3242.04, 988.7712, 12.484, 9.91),
	vector4(1149.288, -974.626, 46.443, 171.38),
	vector4(34.14589, -1357.31, 29.231, 83.73),
	vector4(539.4173, 2677.723, 42.287, 277.85),
	vector4(2565.174, 394.4153, 108.46, 184.95),
	vector4(-3051.52, 596.8996, 7.4523, 293.71),
	vector4(-2981.49, 385.8695, 14.843, 348.79),
	vector4(1971.805, 3748.071, 32.326, 204.85),
	vector4(-1507.58, -382.950, 40.906, 41.34),
	vector4(-53.7423, -1764.81, 28.966, 45.73),
	vector4(1732.147, 6403.972, 34.634, 149.84),
	vector4(-1824.97, 781.3043, 138.03, 223.23),
	vector4(379.8361, 314.9067, 103.19, 74.46),

	vector4(894.5945, -1579.14, 30.761, 0.56),
	vector4(-1859.61, -821.500, 3.5311, 315.64),
	vector4(-1075.93, -1667.51, 4.4455, 30.82),
	vector4(1778.500, 3889.966, 34.460, 104.48),
	vector4(1370.832, 3616.020, 34.892, 195.02),
	vector4(2325.559, 2577.434, 46.667, 161.24),

    vector4(2770.833, 3496.333, 55.247, 245.67),
	vector4(2779.716, 3455.494, 55.539, 156.99),

	vector4(-659.14,-272.73,35.77,25.89),
	vector4(-667.233, -225.571, 37.280, 83.96),


	vector4(2351.584, 3133.523, 48.208, 73.25),
	vector4(-427.037, -1690.72, 19.029, 157.85),
	vector4(-69.1657, 6274.908, 31.370, 72.57),


	vector4(-581.741, -1104.33, 22.178, 88.16),
	vector4(-572.710, -1107.87, 22.178, 269.48),


	vector4(-621.058, -924.560, 23.033, 359.81),

	vector4(56.51899, -744.858, 44.131, 337.47),


	vector4(-572.395, 5264.198, 70.468, 50.97),


	vector4(-571.186, 5340.380, 70.214, 338.36)

}

Customize.Hotkey = "U"
Customize.SwitchDistance = 3
Customize.HotwireItem = 'hotwire'
Customize.TargetDistance = 5.0
