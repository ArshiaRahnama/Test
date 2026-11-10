-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local caffeZone = {
    caffe_01 = vec(-346.57, -254.44, 34.45),
    caffe_02 = vec(-220.9, -770.78, 34.09),
    caffe_03 = vec(-1389.35, -610.93, 30.32),
    caffe_04 = vec(344.89, -888.66, 29.34),
    caffe_05 = vec(-118.7, 6195.56, 32.38),
    caffe_06 = vec(744.0, -735.63, 28.07),
    caffe_07 = vec(88.24, -1571.61, 29.6),
}
local ahangariZone = {
    Ahangari_01 = vec(-1158.91, -2025.64, 13.15),
    Ahangari_02 = vec(728.26, -1063.91, 22.17),
    Ahangari_03 = vec(-224.3, -1320.0, 30.89),
    Ahangari_04 = vec(1130.05, -787.14, 57.6),
    Ahangari_05 = vec(152.76, -1098.54, 29.19),
    Ahangari_06 = vec(-345.01, -124.86, 39.01),
    Ahangari_07 = vec(479.39, -1326.31, 29.21),
}

ConfigJobCloset = {
    { -- police
        coords = {
            vec(461.84, -982.82, 30.69),   -- pd 1
            vec(616.92, 11.94, 82.78),     -- pd 2
            vec(-63.05, -2512.46, 7.39),   -- pd 3
            vec(-1096.02, -830.84, 26.83), -- pd 5
            vec(1509.54, 784.11, 77.71),   -- pd 4 ist bazresi
            vec(1836.94, 3677.04, 34.33),  -- sheriff sandy
            vec(-440.29, 5996.61, 31.71),  -- sheriff paleto
            vec(-2355.97, 3260.16, 32.81), -- Army
        },
        job = 'police', limit = 20, maxWeight = 500,
    }, { -- weazel
        coords = {
            vec(0.37, 0.87, 0.69),   -- weazel
        },
        job = 'weazel', limit = 1, maxWeight = 1,
    }, { -- sheriff
        coords = {
            vec(461.93, -979.76, 30.69),  -- pd 1
            vec(620.0, 8.19, 82.78),      -- pd 2
            vec(-59.91, -2507.5, 7.39),   -- pd 3
            vec(1506.99, 781.37, 77.71),  -- pd 4 ist bazresi
            vec(-1091.9, -825.61, 26.83), -- pd 5
            vec(1841.65, 3686.33, 34.33), -- sheriff sandy
            vec(-440.29, 5996.61, 31.71),  -- sheriff paleto
            vec(-2353.33, 3257.22, 32.81), -- Army
        },
        job = 'sheriff', limit = 20, maxWeight = 500
    }, { -- mt
        coords = {
            vec(457.84, -979.09, 30.69),   -- pd 1
            vec(616.89, -1.81, 82.78),     -- pd 2
            vec(-50.98, -2508.05, 7.39),   -- pd 3
            vec(1513.88, 784.89, 77.71),   -- pd 4 ist bazresi
            vec(-1098.64, -825.94, 26.83), -- pd 5
            vec(1840.19, 3677.56, 34.33),  -- sheriff sandy
            vec(-440.29, 5996.61, 31.71),  -- sheriff paleto
            vec(-2350.13, 3262.36, 32.81), -- Army
        },
        job = 'mt', limit = 20, maxWeight = 500
    }, { -- detective
        coords = {
            vec(456.84, -983.09, 30.69),    -- pd 1
            vec(614.68, 5.73, 82.78),       -- pd 2
            vec(-53.32, -2507.19, 7.39),    -- pd 3
            vec(-1091.86, -826.98, 26.83),  -- pd 5
            vec(383.34, 799.79, 190.49),    -- pd 8
            vec(1843.2, 3679.44, 34.34),    -- sheriff sandy
            vec(-440.29, 5996.61, 31.71),   -- sheriff paleto
            vec(-2354.06, 3264.26, 32.81),  -- Army
        },
        job = 'detective', limit = 20, maxWeight = 500
    }, { -- mechanic
        coords = {
            vec(1350.34, -779.98, 67.31), -- mc rast
            vec(599.74, 611.3, 135.11),   -- mc portal
            vec(1223.9, 2732.18, 38.22),  -- mc sandy
            vec(153.9, -3011.23, 7.04),   -- mc tune
        },
        job = 'mechanic', limit = 20, maxWeight = 500
    }, { -- ambulance
        coords = {
            vec(1147.43, -1561.23, 35.38),  -- md 1
            vec(-1842.22, -334.34, 49.25),  -- md 2
            vec(-265.21, 6324.63, 32.43),   -- md paleto
            vec(1774.2, 3660.51, 40.4),     -- Administatior
        },
        job = 'ambulance', limit = 20, maxWeight = 500,
    }, { -- taxi
        coords = {
            vec(365.93, -1609.95, 29.29),   -- tx asli
            vec(-807.46, -1358.39, 5.15),   -- tx 2
            vec(2518.04, 4099.99, 38.71),   -- tx sandy
            vec(-366.64, 6044.61, 31.44),   -- tx paleto
            vec(1773.22, 3662.43, 40.4),    -- Administatior
            vec(418.4, -1502.79, 30.16),    -- caffe
            vec(187.39, -871.45, 31.74),    -- caffe parking markazi
        },
        job = 'taxi', limit = 20, maxWeight = 500
    }, { -- fbi
        coords = {
            vec(152.17, -735.9, 242.15),  -- fbi 1
            vec(2508.42, -441.9, 106.91), -- fbi 2
            vec(1781.94, 3647.97, 35.34), -- Administatior
            vec(-2361.53, 3243.2, 92.9),  -- Army
        },
        job = 'fbi', limit = 20, maxWeight = 500
    }, { -- justice
        coords = {
            vec(-512.54, -182.05, 38.22), -- justice
            vec(212.84, -426.03, 47.98),  -- justice 2
        },
        job = 'justice', limit = 20, maxWeight = 500
    }, { -- resturan
        coords = {
            vec(-586.25, -1061.99, 22.34),  -- resturan gorbe
            vec(-1656.52, 173.41, 61.73),   -- resturan shams
            vec(-1343.26, -1061.38, 7.39),  -- resturan B
        },
        job = 'resturan', limit = 20, maxWeight = 500
    }, { -- Sylla 10
        coords = { vec(-646.28, -2388.23, 13.95) },
        gang = 'Sylla', limit = 5, maxWeight = 250
    }, { -- GroveStreet 22
        coords = { vec(-1355.78, 122.1, 56.3), vec(-614.48, 6188.63, 10.54), vec(1558.48, -3019.82, 8.97) },
        gang = 'GroveStreet', limit = 15, maxWeight = 700
    }, { -- TALEB 13
        coords = { vec(-1602.92, -2845.77, 16.13) },
        gang = 'TALEB', limit = 5, maxWeight = 250
    }, { -- DEVIANT 11
        coords = { vec(-1419.4, -2744.34, 16.71) },
        gang = 'DEVIANT', limit = 5, maxWeight = 250
    }, { -- Capone 20
        coords = { vec(-444.27, 271.78, 83.01) },
        gang = 'Capone', limit = 15, maxWeight = 700
    }, { -- NATO 10
        coords = { vec(-1601.74, -21.51, 57.77) },
        gang = 'NATO', limit = 5, maxWeight = 250
    }, { -- el_poder 7
        coords = { vec(1013.29, -2337.37, 30.51) },
        gang = 'el_poder', limit = 5, maxWeight = 250
    }, { -- Purple 15
        coords = { vec(-2198.49, -395.76, 13.29) },
        gang = 'Purple', limit = 10, maxWeight = 500
    }, { -- Alghaede 18
        coords = { vec(-625.36, -1616.58, 33.01), vec(1994.81, 3046.22, 47.22) },
        gang = 'Alghaede', limit = 10, maxWeight = 500
    }, { -- Syc 18
        coords = { vec(-1126.25, 366.72, 71.31) },
        gang = 'Syc', limit = 10, maxWeight = 500
    }, { -- GOD_OF_GAMERS 15
        coords = { vec(-919.19, -2043.53, -0.51) },
        gang = 'GOD_OF_GAMERS', limit = 10, maxWeight = 500
    }, { -- BUSHEHR 17
        coords = { vec(-1530.99, -2637.79, 16.71) },
        gang = 'BUSHEHR', limit = 10, maxWeight = 500,
    }, { -- Hydra 15
        coords = { vec(1615.94, -2611.86, 53.89), vec(152.76, -1098.54, 29.19) },
        gang = 'Hydra', limit = 10, maxWeight = 500
    }, { -- SILENT_HELL 9
        coords = { vec(-1510.46, 20.45, 56.97) },
        gang = 'SILENT_HELL', limit = 2, maxWeight = 100
    }, { -- Ochi 12
        coords = { vec(-1538.85, 97.72, 56.75), vec(-11.9, 516.72, 174.63) },
        gang = 'Ochi', limit = 10, maxWeight = 500
    }, { -- Alpha 17
        coords = { vec(-903.08, -3243.78, 16.71) },
        gang = 'Alpha', limit = 10, maxWeight = 500,
    }, { -- VaGoS 9
        coords = { vec(-1205.92, 287.64, 69.68) },
        gang = 'VaGoS', limit = 2, maxWeight = 100
    }, { -- FOX 10
        coords = { vec(4.39, 663.03, 209.67) },
        gang = 'FOX', limit = 5, maxWeight = 250
    }, { -- Sopranos 15
        coords = { vec(-1458.0, -168.08, 48.83) },
        gang = 'Sopranos', limit = 10, maxWeight = 500
    }, { -- Raven 11
        coords = { vec(-1411.78, -2455.01, 16.71) },
        gang = 'Raven', limit = 5, maxWeight = 250
    }, { -- DISORDER 11
        coords = { vec(1391.2, 1157.73, 114.44) },
        gang = 'DISORDER', limit = 10, maxWeight = 500,
    }, { -- Ballas 18
        coords = { vec(-728.81, -1519.84, 4.97) },
        gang = 'Ballas', limit = 10, maxWeight = 500
    }, { -- Shelby 8
        coords = { vec(-973.27, 104.77, 55.67) },
        gang = 'Shelby', limit = 2, maxWeight = 100
    }, { -- BAD_BAX 9
        coords = { vec(208.23, 760.93, 205.01) },
        gang = 'BAD_BAX', limit = 2, maxWeight = 100
    }, { -- cukur_Godal 15
        coords = { vec(-892.97, -2063.14, 9.32) },
        gang = 'cukur_Godal', limit = 10, maxWeight = 500
    }, { -- savak 10
        coords = { vec(-1923.5, 391.38, 96.5) },
        gang = 'savak', limit = 5, maxWeight = 250
    }, { -- ZAKHAR 10
        coords = { vec(-439.28, 275.37, 83.25) },
        gang = 'ZAKHAR', limit = 5, maxWeight = 250
    }, { -- Coyote 5
        coords = { vec(-1734.12, 373.83, 89.84) },
        gang = 'Coyote', limit = 2, maxWeight = 100
    }, { -- Mandem 11
        coords = { vec(-1434.33, -2484.22, 16.71) },
        gang = 'Mandem', limit = 5, maxWeight = 250
    }, { -- Samurai 12
        coords = { vec(-372.06, -2286.85, 9.05) },
        gang = 'Samurai', limit = 10, maxWeight = 500
    }, { -- BlackHands 15
        coords = { vec(-1610.04, -841.64, 10.27) },
        gang = 'BlackHands', limit = 10, maxWeight = 500
    }, { -- BangBros 11
        coords = { vec(-1668.87, -785.93, 10.34) },
        gang = 'BangBros', limit = 5, maxWeight = 250,
    }, { -- ULTRA 11
        coords = { vec(-1107.39, -2142.2, 13.93) },
        gang = 'ULTRA', limit = 5, maxWeight = 250
    }, { -- Black_Scorpions 7
        coords = { vec(-830.41, 115.16, 56.03) },
        gang = 'Black_Scorpions', limit = 5, maxWeight = 250
    }, { -- SAVAGE 20
        coords = { vec(116.93, -2194.63, 6.03), vec(1897.45, 3092.24, 49.93) },
        gang = 'SAVAGE', limit = 15, maxWeight = 700
    }, { -- GeNTrY 15
        coords = { vec(-1547.28, -2869.77, 16.71) },
        gang = 'GeNTrY', limit = 10, maxWeight = 500
    }, { -- GULAG_GANG 10
        coords = { vec(1035.6, -2530.26, 28.3) },
        gang = 'GULAG_GANG', limit = 5, maxWeight = 250
    }, { -- commando 5
        coords = { vec(-1936.5, 2047.69, 140.87) },
        gang = 'commando', limit = 2, maxWeight = 100
    }, { -- Rooster 7
        coords = { vec(-1819.68, 434.73, 132.31) },
        gang = 'Rooster', limit = 2, maxWeight = 100
    }, { -- Rogue 11
        coords = { vec(-573.2, -2345.39, 13.84) },
        gang = 'Rogue', limit = 5, maxWeight = 250
    }, { -- Senator_Family 17
        coords = { vec(-237.26, -2663.15, 6.0) },
        gang = 'Senator_Family', limit = 10, maxWeight = 500
    }, { -- BlackMask 12
        coords = { vec(-2009.13, 287.81, 91.98) },
        gang = 'BlackMask', limit = 5, maxWeight = 250
    }, { -- Khalifa 20
        coords = { vec(-1583.66, -265.78, 48.28), vec(2485.05, 3411.7, 51.02) },
        gang = 'Khalifa', limit = 15, maxWeight = 700
    }, { -- Al_Nasr 10
        coords = { vec(-972.9, 104.44, 55.67) },
        gang = 'Al_Nasr', limit = 5, maxWeight = 250
    }, { -- Alliance 10
        coords = { vec(-2787.45, 1436.85, 100.93) },
        gang = 'Alliance', limit = 5, maxWeight = 250
    }, { -- Siege 14
        coords = { vec(-570.51, 311.2, 84.49), vec(-316.16, 6119.72, 32.49) },
        gang = 'Siege', limit = 10, maxWeight = 500,
    }, { -- 2poc 15
        coords = { vec(-1107.64, -2094.77, 13.93), vec(-118.7, 6195.56, 32.38) },
        gang = '2poc', limit = 10, maxWeight = 500
    }, { -- Vikings 15
        coords = { vec(-1031.47, -3105.08, 16.71) },
        gang = 'Vikings', limit = 10, maxWeight = 500,
    }, { -- CHECHEN 15
        coords = { vec(-930.06, 31.56, 49.22) },
        gang = 'CHECHEN', limit = 10, maxWeight = 500
    }, { -- Allies 14
        coords = { vec(561.18, -2794.99, 6.08) },
        gang = 'Allies', limit = 10, maxWeight = 500,
    }, { -- EL_CHAPO 5
        coords = { vec(-953.28, 197.55, 67.39) },
        gang = 'EL_CHAPO', limit = 2, maxWeight = 100
    }, { -- Rockstar 10
        coords = { vec(315.43, -2726.06, 5.99) },
        gang = 'Rockstar', limit = 5, maxWeight = 250
    }, { -- Night_Watch 8
        coords = { vec(-1181.58, 305.93, 69.89) },
        gang = 'Night_Watch', limit = 2, maxWeight = 100
    }, { -- Persis_Family 5
        coords = { vec(-898.7, 176.19, 69.45) },
        gang = 'Persis_Family', limit = 2, maxWeight = 100
    }, { -- DallaS 5
        coords = { vec(-1543.64, -249.25, 48.28) },
        gang = 'DallaS', limit = 2, maxWeight = 100,
    }, { -- North_Kids 10
        coords = { vec(803.4, -2816.38, 8.01), vec(2397.97, 3314.82, 47.71) },
        gang = 'North_Kids', limit = 10, maxWeight = 500,
    }, { -- immortal 4
        coords = { vec(-872.63, 61.65, 49.66) },
        gang = 'immortal', limit = 2, maxWeight = 100
    }, { -- Titan 12
        coords = { vec(843.4, -2500.2, 28.43) },
        gang = 'Titan', limit = 5, maxWeight = 250
    }, { -- Pahlavi 6
        coords = { vec(-157.13, -2206.35, 8.71) },
        gang = 'Pahlavi', limit = 2, maxWeight = 100
    }, { -- rocoo 7
        coords = { vec(-112.75, -2222.79, 8.54) },
        gang = 'rocoo', limit = 5, maxWeight = 250
    }, { -- Cicada 5
        coords = { vec(565.93, -2776.81, 6.09) },
        gang = 'Cicada', limit = 2, maxWeight = 100
    }, { -- adidas 5
        coords = { vec(-670.25, -2402.34, 14.14) },
        gang = 'adidas', limit = 2, maxWeight = 100
    }, { -- Vegas 15
        coords = { vec(-1734.01, 373.78, 89.84) },
        gang = 'Vegas', limit = 10, maxWeight = 500
    }, { -- BLACK 9
        coords = { vec(-887.76, 42.3, 49.15) },
        gang = 'BLACK', limit = 2, maxWeight = 100
    }, { -- Azrael 6
        coords = { vec(1069.75, -2270.72, 30.34) },
        gang = 'Azrael', limit = 2, maxWeight = 100
    }, { -- SLAYER 6
        coords = { vec(1082.57, -2272.96, 30.87) },
        gang = 'SLAYER', limit = 2, maxWeight = 100
    }, { -- fantom 5
        coords = { vec(-1558.31, 410.92, 105.11) },
        gang = 'fantom', limit = 2, maxWeight = 100
    }, { -- UN 15
        coords = { vec(959.18, -121.13, 74.96), vec(1920.15, 2923.45, 48.66) },
        gang = 'UN', limit = 10, maxWeight = 500
    }, { -- ASSASSIN 10
        coords = { vec(-1379.45, 434.25, 104.88) },
        gang = 'ASSASSIN', limit = 5, maxWeight = 250
    }, { -- Anarchy 5
        coords = { vec(-0.21, 689.29, 209.67) },
        gang = 'Anarchy', limit = 5, maxWeight = 250
    }, { -- Crows 5
        coords = { vec(-58.21, -1820.99, 26.96) },
        gang = 'Crows', limit = 5, maxWeight = 250
    }, { -- yakuza 13
        coords = { vec(-1527.01, 870.53, 181.68) },
        gang = 'yakuza', limit = 5, maxWeight = 250
    }, { -- Demon 17
        coords = { vec(1039.04, -2515.29, 28.3) },
        gang = 'Demon', limit = 10, maxWeight = 500,
    }, { -- Arnak 5
        coords = { vec(-104.26, -2218.97, 7.81) },
        gang = 'Arnak', limit = 2, maxWeight = 100
    }, { -- Grim_Reapers 5
        coords = { vec(-588.39, -2343.18, 13.84) },
        gang = 'Grim_Reapers', limit = 2, maxWeight = 100
    }, { -- Thugs 10
        coords = { vec(-1582.32, -2537.85, 16.7) },
        gang = 'Thugs', limit = 5, maxWeight = 250
    }, { -- Saudi 16
        coords = { vec(-1485.46, -160.01, 48.83) },
        gang = 'Saudi', limit = 10, maxWeight = 500
    }, { -- Devil_Moon 10
        coords = { vec(-444.61, -1716.05, 19.24) },
        gang = 'Devil_Moon', limit = 5, maxWeight = 250
    }, { -- Terror 15
        coords = { vec(996.6, -2547.75, 28.86) },
        gang = 'Terror', limit = 10, maxWeight = 500
    }, { -- zedix 12
        coords = { vec(-1658.12, -794.39, 10.34) },
        gang = 'zedix', limit = 5, maxWeight = 250
    }, { -- CayreX 7
        coords = { vec(222.25, -1993.57, 19.61) },
        gang = 'CayreX', limit = 2, maxWeight = 100
    }, { -- BARCODE 5
        coords = { vec(-802.18, 180.28, 76.74) },
        gang = 'BARCODE', limit = 2, maxWeight = 100
    }, { -- Legacy 10
        coords = { vec(-1321.76, -2284.73, 16.71) },
        gang = 'Legacy', limit = 5, maxWeight = 250
    }, { -- Devil 8
        coords = { vec(-619.99, -1617.79, 33.01) },
        gang = 'Devil', limit = 2, maxWeight = 100
    }, { -- Vision 15
        coords = { vec(772.22, -2508.5, 19.92) },
        gang = 'Vision', limit = 10, maxWeight = 500
    }, { -- sylvanas 5
        coords = { vec(-1039.5, 216.54, 63.76) },
        gang = 'sylvanas', limit = 2, maxWeight = 100
    }, { -- Parsis 11
        coords = { vec(-1520.06, -2900.31, 16.71) },
        gang = 'Parsis', limit = 5, maxWeight = 250
    }, { -- Amazon 15
        coords = { vec(-572.97, -2346.96, 13.84), vec(-1158.91, -2025.64, 13.15) },
        gang = 'Amazon', limit = 10, maxWeight = 500,
    }, { -- Thirteen 14
        coords = { vec(774.03, -2478.4, 20.13) },
        gang = 'Thirteen', limit = 5, maxWeight = 250
    }, { -- LizardLegit 5
        coords = { vec(-2011.31, 512.63, 107.17) },
        gang = 'LizardLegit', limit = 2, maxWeight = 100
    }, { -- SuDDeN 10
        coords = { vec(-64.29, -1814.96, 27.3) },
        gang = 'SuDDeN', limit = 5, maxWeight = 250
    }, { -- Necro 5
        coords = { vec(-801.09, 179.0, 76.74) },
        gang = 'Necro', limit = 2, maxWeight = 100
    }, { -- mellow 11
        coords = { vec(-1596.48, -2562.62, 16.7) },
        gang = 'mellow', limit = 5, maxWeight = 250
    }, { -- ACT 5
        coords = { vec(-904.68, 196.11, 69.5) },
        gang = 'ACT', limit = 2, maxWeight = 100
    }, { -- PENGUIN 5
        coords = { vec(172.11, 1714.84, 227.39) },
        gang = 'PENGUIN', limit = 2, maxWeight = 100
    }, { -- Lithium 5
        coords = { vec(-1547.67, 22.83, 58.4) },
        gang = 'Lithium', limit = 2, maxWeight = 100
    }, { -- Shadow_legends 5
        coords = { vec(-2793.47, 1452.99, 101.05) },
        gang = 'Shadow_legends', limit = 2, maxWeight = 100
    }, { -- WestSide 5
        coords = { vec(-1481.2, -199.45, 50.5) },
        gang = 'WestSide', limit = 2, maxWeight = 100
    }, { -- Viper 15
        coords = { vec(-1570.0, -47.6, 56.89) },
        gang = 'Viper', limit = 10, maxWeight = 500,
    }, { -- ALIEN 5
        coords = { vec(-2009.75, 316.86, 91.56) },
        gang = 'ALIEN', limit = 2, maxWeight = 100
    }, { -- THE_MOON 5
        coords = { vec(-151.67, 910.63, 235.66) },
        gang = 'THE_MOON', limit = 2, maxWeight = 100
    }, { -- Shadoghlo 5
        coords = { vec(904.98, -2511.05, 29.58) },
        gang = 'Shadoghlo', limit = 2, maxWeight = 100
    }, { -- Blue 5
        coords = { vec(-1704.01, -2809.74, 16.71) },
        gang = 'Blue', limit = 2, maxWeight = 100
    }, { -- MetallicA 12
        coords = { vec(-1303.09, -2450.13, 16.71) },
        gang = 'MetallicA', limit = 5, maxWeight = 250
    }, { -- Warriors 5
        coords = { vec(264.8, -2561.54, 5.7) },
        gang = 'Warriors', limit = 2, maxWeight = 100
    }, { -- ARBAB 13
        coords = { vec(-1988.04, 303.9, 91.76), vec(2174.38, 3315.45, 46.4) },
        gang = 'ARBAB', limit = 5, maxWeight = 250
    }, { -- Wanted 10
        coords = { vec(-807.29, 186.59, 72.48) },
        gang = 'Wanted', limit = 5, maxWeight = 250
    }, { -- WARTLOW 5
        coords = { vec(1224.68, -393.21, 68.86) },
        gang = 'WARTLOW', limit = 2, maxWeight = 100
    }, { -- EndLess 10
        coords = { vec(-354.12, -2771.67, 6.12) },
        gang = 'EndLess', limit = 5, maxWeight = 250
    }, { -- DarKNeSS 10
        coords = { vec(-139.53, 874.78, 232.69) },
        gang = 'DarKNeSS', limit = 5, maxWeight = 250
    }, { -- ZeRo 5
        coords = { vec(-1096.34, 318.9, 66.58) },
        gang = 'ZeRo', limit = 2, maxWeight = 100
    }, { -- Deamens 5
        coords = { vec(-880.78, 48.92, 48.76) },
        gang = 'Deamens', limit = 2, maxWeight = 100
    }, { -- Vampaire 5
        coords = { vec(-879.97, 353.52, 85.29) },
        gang = 'Vampaire', limit = 2, maxWeight = 100
    }, { -- JOKER 5
        coords = { vec(-1877.44, 128.19, 82.05) },
        gang = 'JOKER', limit = 2, maxWeight = 100
    }, { -- Niko 5
        coords = { vec(-103.63, 988.0, 235.78) },
        gang = 'Niko', limit = 2, maxWeight = 100
    }, { -- Medellin 10
        coords = { vec(1115.59, -2280.72, 30.86) },
        gang = 'Medellin', limit = 5, maxWeight = 250
    }, { -- Sky 8
        coords = { vec(986.8, -92.74, 74.85), vec(982.85, -142.9, 74.24) },
        gang = 'Sky', limit = 2, maxWeight = 100
    }, { -- gunners 11
        coords = { vec(-1704.79, -747.65, 11.89), vec(1068.71, 3588.27, 34.82) },
        gang = 'gunners', limit = 5, maxWeight = 250
    }, { -- SyReN 10
        coords = { vec(-1153.97, -2128.99, 13.42) },
        gang = 'SyReN', limit = 5, maxWeight = 250
    }, { -- Rifa 10
        coords = { vec(-460.47, -1726.22, 18.66) },
        gang = 'Rifa', limit = 5, maxWeight = 250
    }, { -- Lord_of_Blood 5
        coords = { vec(-1540.54, 5.36, 56.77) },
        gang = 'Lord_of_Blood', limit = 2, maxWeight = 100
    }, { -- Ganga 5
        coords = { vec(-1952.06, 354.04, 91.2) },
        gang = 'Ganga', limit = 2, maxWeight = 100
    }, { -- arses 10
        coords = { vec(-915.1, -2051.8, -0.51) },
        gang = 'arses', limit = 5, maxWeight = 250
    }, { -- Blaze 5
        coords = { vec(-1897.47, 136.44, 81.79) },
        gang = 'Blaze', limit = 2, maxWeight = 100
    }, { -- Atomic_Fury_Clan 15
        coords = { vec(-1181.57, -2135.13, 13.42) },
        gang = 'Atomic_Fury_Clan', limit = 10, maxWeight = 500,
    }, { -- VaGaBanDs 5
        coords = { vec(-444.46, -1713.49, 18.7) },
        gang = 'VaGaBanDs', limit = 2, maxWeight = 100
    }, { -- Blizzard 5
        coords = { vec(-1529.24, 837.94, 181.59) },
        gang = 'Blizzard', limit = 2, maxWeight = 100
    }, { -- Mercedes 5
        coords = { vec(-1908.98, 292.46, 88.61) },
        gang = 'Mercedes', limit = 2, maxWeight = 100
    }, { -- Black_Rein_Hard 5
        coords = { vec(-1044.14, 295.13, 66.78) },
        gang = 'Black_Rein_Hard', limit = 5, maxWeight = 250
    }, { -- DJ_family 10
        coords = { vec(-77.56, -2214.37, 7.81), vec(1987.51, 3040.23, 47.06) },
        gang = 'DJ_family', limit = 5, maxWeight = 250
    }, { -- Sicilian 5
        coords = { vec(-70.59, 842.74, 235.72) },
        gang = 'Sicilian', limit = 2, maxWeight = 100
    }, { -- Suspect 5
        coords = { vec(-544.61, 318.85, 83.29) },
        gang = 'Suspect', limit = 2, maxWeight = 100
    }, { -- Hexo 11
        coords = { vec(-809.38, 185.47, 72.48) },
        gang = 'Hexo', limit = 5, maxWeight = 250
    }, { -- BruTaL 10
        coords = { vec(1024.73, -2331.07, 30.7) },
        gang = 'BruTaL', limit = 5, maxWeight = 250
    }, { -- knight_wolfs 5
        coords = { vec(-1912.5, 415.62, 96.36) },
        gang = 'knight_wolfs', limit = 2, maxWeight = 100
    }, { -- Reapers 12
        coords = { vec(-1601.93, -841.25, 10.08) },
        gang = 'Reapers', limit = 5, maxWeight = 250
    }, { -- Liquid 10
        coords = { vec(-1200.82, -3077.08, 16.71) },
        gang = 'Liquid', limit = 5, maxWeight = 250
    }, { -- EGOKings 5
        coords = { vec(-1588.15, -829.11, 9.97), vec(-1890.76, 2058.62, 140.98) },
        gang = 'EGOKings', limit = 2, maxWeight = 100
    }, { -- Warden 10
        coords = { vec(315.11, -2737.58, 5.99) },
        gang = 'Warden', limit = 5, maxWeight = 250
    }, { -- Master 5
        coords = { vec(-694.77, 645.96, 155.18) },
        gang = 'Master', limit = 2, maxWeight = 100
    }, { -- Revenants 5
        coords = { vec(-1039.23, 215.59, 63.76) },
        gang = 'Revenants', limit = 2, maxWeight = 100
    }, { -- BANDAR 10
        coords = { vec(222.24, -1993.47, 19.61) },
        gang = 'BANDAR', limit = 5, maxWeight = 250
    }, { -- Apachea 15
        coords = { vec(-116.74, -1807.17, 26.91), vec(-1389.35, -610.93, 30.32), vec(728.26, -1063.91, 22.17) },
        gang = 'Apachea', limit = 10, maxWeight = 500
    }, { -- TFUUE 5
        coords = { vec(-1461.68, 31.86, 53.54) },
        gang = 'TFUUE', limit = 2, maxWeight = 100
    }, { -- hell_band 5
        coords = { vec(-1520.3, 23.96, 56.82) },
        gang = 'hell_band', limit = 2, maxWeight = 100
    }, { -- Mario 11
        coords = { vec(-1445.84, -15.72, 54.58) },
        gang = 'Mario', limit = 5, maxWeight = 250
    }, { -- Space 10
        coords = { vec(-1534.52, -97.58, 54.53) },
        gang = 'Space', limit = 5, maxWeight = 250
    }, { -- BLACK_AGENTS 10
        coords = { vec(1338.43, -2651.79, 48.82) },
        gang = 'BLACK_AGENTS', limit = 5, maxWeight = 250
    }, { -- Yoonan 5
        coords = { vec(-426.51, 271.86, 86.2) },
        gang = 'Yoonan', limit = 2, maxWeight = 100
    }, { -- Vengeance 5
        coords = { vec(-1896.64, 112.79, 81.64) },
        gang = 'Vengeance', limit = 2, maxWeight = 100
    }, { -- ONE4ONE 5
        coords = { vec(-1593.31, 27.17, 61.07) },
        gang = 'ONE4ONE', limit = 2, maxWeight = 100
    }, { -- SHADOW 5
        coords = { vec(-1344.43, 485.98, 102.76) },
        gang = 'SHADOW', limit = 2, maxWeight = 100
    }, { -- Eternal 5
        coords = { vec(-906.25, 182.7, 69.43) },
        gang = 'Eternal', limit = 2, maxWeight = 100
    }, { -- Adler 5
        coords = { vec(-1939.29, 544.8, 114.83) },
        gang = 'Adler', limit = 2, maxWeight = 100
    }, { -- Dark_sky 5
        coords = { vec(-1139.88, 377.03, 71.31) },
        gang = 'Dark_sky', limit = 2, maxWeight = 100
    }, { -- HELL_ZONE 5
        coords = { vec(-1794.11, 435.32, 132.31) },
        gang = 'HELL_ZONE', limit = 2, maxWeight = 100
    }, { -- Albania 5
        coords = { vec(-1371.92, 448.23, 105.35) },
        gang = 'Albania', limit = 2, maxWeight = 100
    }, { -- EVOLUTION 5
        coords = { vec(-1911.15, 410.72, 96.3) },
        gang = 'EVOLUTION', limit = 2, maxWeight = 100
    }, { -- FURY_FM 8
        coords = { vec(-411.81, 418.89, 112.36) },
        gang = 'FURY_FM', limit = 2, maxWeight = 100
    }, { -- Azazel 10
        coords = { vec(-812.91, 111.17, 60.81) },
        gang = 'Azazel', limit = 5, maxWeight = 250
    }, { -- TRAVIS 5
        coords = { vec(-1504.5, -213.78, 50.87) },
        gang = 'TRAVIS', limit = 2, maxWeight = 100
    }, { -- Zoxe 5
        coords = { vec(-2583.47, 1901.23, 167.31) },
        gang = 'Zoxe', limit = 2, maxWeight = 100
    }, { -- Triad 5
        coords = { vec(-1569.36, -2578.22, 16.7) },
        gang = 'Triad', limit = 2, maxWeight = 100
    }, { -- Desolate 10
        coords = { vec(-1172.98, -1163.72, 5.57) },
        gang = 'Desolate', limit = 10, maxWeight = 500,
    }, { -- Punishers 5
        coords = { vec(1359.79, -2655.56, 48.97) },
        gang = 'Punishers', limit = 2, maxWeight = 100
    }, { -- Z_Fire 10
        coords = { vec(-846.83, -40.95, 39.44) },
        gang = 'Z_Fire', limit = 5, maxWeight = 250
    }, { -- FireFlower 10
        coords = { vec(-792.91, -2682.53, 14.85), vec(2003.81, 3049.01, 47.21) },
        gang = 'FireFlower', limit = 5, maxWeight = 250
    }, { -- Everest 5
        coords = { vec(-1024.48, -2174.31, 9.06) },
        gang = 'Everest', limit = 2, maxWeight = 100
    }, { -- Black_Disciple 11
        coords = { vec(-58.91, -1822.73, 26.94) },
        gang = 'Black_Disciple', limit = 5, maxWeight = 250
    }, { -- zodiac 5
        coords = { vec(-1480.65, -45.29, 54.6) },
        gang = 'zodiac', limit = 2, maxWeight = 100
    }, { -- Corleon 10
        coords = { vec(-1106.55, 302.22, 65.71) },
        gang = 'Corleon', limit = 5, maxWeight = 250
    }, { -- Caspian 5
        coords = { vec(-2035.18, 503.06, 107.01) },
        gang = 'Caspian', limit = 2, maxWeight = 100
    }, { -- Sparta 5
        coords = { vec(-1662.39, -790.71, 10.34) },
        gang = 'Sparta', limit = 5, maxWeight = 250
    }, { -- Enrique 10
        coords = { vec(1240.89, -428.04, 68.9) },
        gang = 'Enrique', limit = 5, maxWeight = 250
    }, { -- infinity 5
        coords = { vec(314.84, -2738.12, 5.99) },
        gang = 'infinity', limit = 2, maxWeight = 100
    }, { -- Schutzstaffel 5
        coords = { vec(-1970.88, 250.41, 87.61) },
        gang = 'Schutzstaffel', limit = 2, maxWeight = 100
    }, { -- hakhamanesh 12
        coords = { vec(-79.83, -2236.8, 7.81) },
        gang = 'hakhamanesh', limit = 5, maxWeight = 250
    }, { -- BHSQUAD 5
        coords = { vec(-881.11, 352.6, 85.29) },
        gang = 'BHSQUAD', limit = 2, maxWeight = 100
    }, { -- Polaris_Star 5
        coords = { vec(-1918.52, 355.46, 93.78) },
        gang = 'Polaris_Star', limit = 2, maxWeight = 100
    }, { -- Salamanca 5
        coords = { vec(983.6, -124.35, 73.92) },
        gang = 'Salamanca', limit = 2, maxWeight = 100
    }, { -- ZedFM 5
        coords = { vec(-1448.44, -40.4, 54.66), vec(1130.05, -787.14, 57.6) },
        gang = 'ZedFM', limit = 2, maxWeight = 100
    }, { -- Avant_Garde 5
        coords = { vec(-1510.24, 20.72, 56.96) },
        gang = 'Avant_Garde', limit = 2, maxWeight = 100
    }, { -- Wakanda 5
        coords = { vec(-106.04, -2234.42, 7.81) },
        gang = 'Wakanda', limit = 2, maxWeight = 100
    }, { -- GLitCH 5
        coords = { vec(222.24, -1993.55, 19.61) },
        gang = 'GLitCH', limit = 2, maxWeight = 100
    }, { -- Eden_Dynasty 10
        coords = { vec(650.36, -2915.53, 6.3) },
        gang = 'Eden_Dynasty', limit = 5, maxWeight = 250
    }, { -- Garshasp 5
        coords = { vec(-903.49, 99.38, 55.26) },
        gang = 'Garshasp', limit = 2, maxWeight = 100
    }, { -- Taurus 5
        coords = { vec(-1500.44, 858.87, 181.6) },
        gang = 'Taurus', limit = 2, maxWeight = 100
    }, { -- GF 5
        coords = { vec(-1126.42, 366.84, 71.31) },
        gang = 'GF', limit = 5, maxWeight = 250
    }, { -- Griffin 5
        coords = { vec(-154.7, 887.78, 233.42) },
        gang = 'Griffin', limit = 2, maxWeight = 100
    }, { -- Zeuss 5
        coords = { vec(-572.07, -2345.72, 13.84) },
        gang = 'Zeuss', limit = 2, maxWeight = 100
    }, { -- Lean_Kids 5
        coords = { vec(-812.96, 111.14, 60.8) },
        gang = 'Lean_Kids', limit = 2, maxWeight = 100
    }, { -- Mi6_Team 10
        coords = { vec(1089.01, -2257.97, 30.15) },
        gang = 'Mi6_Team', limit = 5, maxWeight = 250
    }, { -- HeXeN 10
        coords = { vec(-1025.78, -2192.75, 9.07) },
        gang = 'HeXeN', limit = 5, maxWeight = 250
    }, { -- Lunark 5
        coords = { vec(-1153.38, -2129.31, 13.42) },
        gang = 'Lunark', limit = 2, maxWeight = 100
    }, { -- DARKBLOOD 5
        coords = { vec(173.04, 1720.45, 231.07) },
        gang = 'DARKBLOOD', limit = 2, maxWeight = 100
    }, { -- Divine 11
        coords = { vec(1086.21, -2257.52, 30.16) },
        gang = 'Divine', limit = 5, maxWeight = 250
    }, { -- Minion 5
        coords = { vec(-940.05, 202.29, 67.86) },
        gang = 'Minion', limit = 2, maxWeight = 100
    }, { -- Hizbullah 5
        coords = { vec(-1529.44, 838.78, 181.6) },
        gang = 'Hizbullah', limit = 2, maxWeight = 100
    }, { -- Ronin 5
        coords = { vec(804.49, -2519.25, 22.43) },
        gang = 'Ronin', limit = 2, maxWeight = 100
    }, { -- Alabama 5
        coords = { vec(-1388.22, -2780.61, 16.02) },
        gang = 'Alabama', limit = 2, maxWeight = 100
    }, { -- Delta_Core 13
        coords = { vec(-879.34, -2751.43, 13.95), vec(479.39, -1326.31, 29.21) },
        gang = 'Delta_Core', limit = 5, maxWeight = 250
    }, { -- Valhalla 5
        coords = { vec(-1466.52, -157.1, 48.83) },
        gang = 'Valhalla', limit = 2, maxWeight = 100
    }, { -- Jordan 5
        coords = { vec(-2030.99, 515.98, 107.01) },
        gang = 'Jordan', limit = 2, maxWeight = 100
    }, { -- Spirit 5
        coords = { vec(-984.39, 122.98, 56.05) },
        gang = 'Spirit', limit = 2, maxWeight = 100
    }, { -- Survival_Team 10
        coords = { vec(-1493.07, -2586.19, 16.71), vec(344.89, -888.66, 29.34) },
        gang = 'Survival_Team', limit = 5, maxWeight = 250
    }, { -- Crips 5
        coords = { vec(6.2, -1816.58, 25.35) },
        gang = 'Crips', limit = 5, maxWeight = 250
    }, { -- NEXANE 5
        coords = { vec(-971.56, 122.11, 57.05) },
        gang = 'NEXANE', limit = 2, maxWeight = 100
    }, { -- KATANA 10
        coords = { vec(-1565.75, 424.67, 109.59) },
        gang = 'KATANA', limit = 5, maxWeight = 250
    }, { -- Luxury 5
        coords = { vec(-1199.84, 276.02, 69.53) },
        gang = 'Luxury', limit = 2, maxWeight = 100
    }, { -- Yetimler 5
        coords = { vec(-1886.41, 2062.33, 140.98) },
        gang = 'Yetimler', limit = 2, maxWeight = 100
    }, { -- Siren 5
        coords = { vec(-1024.63, 376.93, 71.39) },
        gang = 'Siren', limit = 2, maxWeight = 100
    }, { -- TEHRAN 5
        coords = { vec(-1035.83, 211.55, 64.16) },
        gang = 'TEHRAN', limit = 2, maxWeight = 100
    }, { -- Van_Der_Linde 5
        coords = { vec(-889.4, 30.88, 48.81) },
        gang = 'Van_Der_Linde', limit = 2, maxWeight = 100
    }, { -- Daeesh 12
        coords = { vec(-928.61, 24.58, 48.02) },
        gang = 'Daeesh', limit = 5, maxWeight = 250
    }, { -- Caligo 10
        coords = { vec(1378.8, -2090.45, 52.61) },
        gang = 'Caligo', limit = 5, maxWeight = 250
    }, { -- Prime 5
        coords = { vec(-1276.72, 490.59, 97.81) },
        gang = 'Prime', limit = 2, maxWeight = 100
    }, { -- Unity 5
        coords = { vec(-1471.83, -2556.81, 16.71) },
        gang = 'Unity', limit = 2, maxWeight = 100
    }, { -- ice_star 5
        coords = { vec(-1026.7, 363.5, 71.37) },
        gang = 'ice_star', limit = 2, maxWeight = 100
    }, { -- silenthell 5
        coords = { vec(-1159.49, -3103.1, 16.71) },
        gang = 'silenthell', limit = 2, maxWeight = 100
    }, { -- Witches 5
        coords = { vec(214.36, 766.56, 204.65) },
        gang = 'Witches', limit = 2, maxWeight = 100
    }, { -- Villain 5
        coords = { vec(-915.53, -2038.17, 9.41) },
        gang = 'Villain', limit = 2, maxWeight = 100
    }, { -- Avengers 5
        coords = { vec(-1461.15, 33.57, 53.54) },
        gang = 'Avengers', limit = 2, maxWeight = 100
    }, { -- Black_Rage 5
        coords = { vec(1226.57, -401.77, 68.86) },
        gang = 'Black_Rage', limit = 2, maxWeight = 100
    }, { -- Kingdom_Duty 5
        coords = { vec(-1570.5, -2705.83, 16.71) },
        gang = 'Kingdom_Duty', limit = 2, maxWeight = 100
    }, { -- Aztecas 10
        coords = { vec(254.81, -2572.23, 5.88) },
        gang = 'Aztecas', limit = 5, maxWeight = 250
    }, { -- Golden_gang 5
        coords = { vec(-177.31, 1010.57, 236.13) },
        gang = 'Golden_gang', limit = 2, maxWeight = 100
    }, { -- Vendetta 5
        coords = { vec(6.47, -1816.68, 25.35) },
        gang = 'Vendetta', limit = 2, maxWeight = 100
    }, { -- Gladiator 5
        coords = { vec(-416.22, 450.21, 112.58) },
        gang = 'Gladiator', limit = 2, maxWeight = 100
    }, { -- Marksmans 5
        coords = { vec(-1312.5, -2794.99, 16.71) },
        gang = 'Marksmans', limit = 2, maxWeight = 100
    }, { -- SAYEN 10
        coords = { vec(-1023.42, 285.49, 66.98) },
        gang = 'SAYEN', limit = 5, maxWeight = 250
    }, { -- Brotherhood 5
        coords = { vec(-1378.5, 447.77, 104.88) },
        gang = 'Brotherhood', limit = 2, maxWeight = 100
    }, { -- Crusher 5
        coords = { vec(-1315.72, -2471.78, 16.71) },
        gang = 'Crusher', limit = 2, maxWeight = 100
    }, { -- Vanta 5
        coords = { vec(565.9, -2776.88, 6.09) },
        gang = 'Vanta', limit = 2, maxWeight = 100
    }, { -- Racists_Heaven 5
        coords = { vec(-1930.77, 179.33, 84.64) },
        gang = 'Racists_Heaven', limit = 2, maxWeight = 100
    }, { -- MK8_Family 5
        coords = { vec(-1541.19, -2494.8, 16.7) },
        gang = 'MK8_Family', limit = 2, maxWeight = 100
    }, { -- RICHARD 5
        coords = { vec(-1504.28, 850.39, 181.61) },
        gang = 'RICHARD', limit = 2, maxWeight = 100
    }, { -- ScrewedUpSapiens 10
        coords = { vec(-453.8, 267.86, 83.26) },
        gang = 'ScrewedUpSapiens', limit = 5, maxWeight = 250
    }, { -- Hyprion 5
        coords = { vec(-1501.71, -198.66, 50.67) },
        gang = 'Hyprion', limit = 2, maxWeight = 100
    }, { -- Cyclone 5
        coords = { vec(-2618.11, 1706.94, 142.37) },
        gang = 'Cyclone', limit = 2, maxWeight = 100
    }, { -- Outcasts 5
        coords = { vec(-1942.76, 367.28, 93.69) },
        gang = 'Outcasts', limit = 2, maxWeight = 100
    }, { -- Predator 5
        coords = { vec(-397.22, 432.33, 112.34) },
        gang = 'Predator', limit = 2, maxWeight = 100
    }, { -- ErrorX 15
        coords = { vec(-1550.78, 18.6, 58.67), vec(2485.75, 3410.7, 51.02), vec(-346.57, -254.44, 34.45), vec(-345.01, -124.86, 39.01) },
        gang = 'ErrorX', limit = 10, maxWeight = 500
    }, { -- Zero_TwentyOne 5
        coords = { vec(-1210.13, -2997.04, 16.71) },
        gang = 'Zero_TwentyOne', limit = 2, maxWeight = 100
    }, { -- Texas 5
        coords = { vec(-1005.74, -3185.17, 16.71) },
        gang = 'Texas', limit = 2, maxWeight = 100
    }, { -- Legion 5
        coords = { vec(-1530.73, -2658.89, 16.71) },
        gang = 'Legion', limit = 2, maxWeight = 100
    }, { -- Bleach 5
        coords = { vec(-10.28, -1827.88, 25.39), vec(88.24, -1571.61, 29.6) },
        gang = 'Bleach', limit = 2, maxWeight = 100
    }, { -- Belak 5
        coords = { vec(-970.89, -1971.07, 13.19) },
        gang = 'Belak', limit = 2, maxWeight = 100
    }, { -- sideA 10
        coords = { vec(1241.7, -426.39, 68.9) },
        gang = 'sideA', limit = 5, maxWeight = 250
    }, { -- Monaco 5
        coords = { vec(-1339.35, 471.19, 106.41) },
        gang = 'Monaco', limit = 2, maxWeight = 100
    }, { -- Targaryen 5
        coords = { vec(-1812.65, 444.11, 128.51) },
        gang = 'Targaryen', limit = 2, maxWeight = 100
    }, { -- Fallen 5
        coords = { vec(-1037.09, 213.29, 64.09) },
        gang = 'Fallen', limit = 2, maxWeight = 100
    }, { -- CACTUS 5
        coords = { vec(-634.58, -2394.96, 13.95) },
        gang = 'CACTUS', limit = 2, maxWeight = 100
    }, { -- Soviet_Union 12
        coords = { vec(-810.15, 158.12, 71.5) },
        gang = 'Soviet_Union', limit = 5, maxWeight = 250
    }, { -- XanaX 5
        coords = { vec(-1393.06, -2399.42, 16.71) },
        gang = 'XanaX', limit = 2, maxWeight = 100
    }, { -- Spark 5
        coords = { vec(-906.71, 182.76, 69.42) },
        gang = 'Spark', limit = 2, maxWeight = 100
    }, { -- Sakura 5
        coords = { vec(-1470.52, -2546.32, 16.71) },
        gang = 'Sakura', limit = 2, maxWeight = 100
    }, { -- NoMercy 11
        coords = { vec(997.65, -2342.95, 30.59) },
        gang = 'NoMercy', limit = 5, maxWeight = 250
    }, { -- Bad_Guys 5
        coords = { vec(-857.55, -2728.98, 13.95) },
        gang = 'Bad_Guys', limit = 2, maxWeight = 100
    }, { -- Vextoria 8
        coords = { vec(-259.83, -2676.48, 6.24), vec(744.0, -735.63, 28.07) },
        gang = 'Vextoria', limit = 2, maxWeight = 100
    }, { -- Ashen_Family 6
        coords = { vec(-1889.07, 136.74, 82.05) },
        gang = 'Ashen_Family', limit = 2, maxWeight = 100
    }, { -- YANKER 5
        coords = { vec(-1363.52, -2325.77, 16.71), vec(-220.9, -770.78, 34.09) },
        gang = 'YANKER', limit = 2, maxWeight = 100
    }, { -- LANNISTER 5
        coords = { vec(-1346.49, 479.86, 102.76) },
        gang = 'LANNISTER', limit = 2, maxWeight = 100
    }, { -- ORION 6
        coords = { vec(-703.08, 654.65, 155.18) },
        gang = 'ORION', limit = 2, maxWeight = 100
    }, { -- Berserk 5
        coords = { vec(-1472.35, -2535.18, 16.71) },
        gang = 'Berserk', limit = 2, maxWeight = 100
    }, { -- san_fierro 5
        coords = { vec(-1431.95, -2488.83, 16.71) },
        gang = 'san_fierro', limit = 2, maxWeight = 100
    }, { -- Paradise 5
        coords = { vec(-142.57, -2208.24, 7.81) },
        gang = 'Paradise', limit = 2, maxWeight = 100
    }, { -- Brazil 6
        coords = { vec(-1373.2, -2386.66, 16.71) },
        gang = 'Brazil', limit = 2, maxWeight = 100
    },
}
