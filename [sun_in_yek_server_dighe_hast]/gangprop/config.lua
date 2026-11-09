-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config                            = {}
Config.DrawDistance               = 100.0
Config.DrawDistance2               = 20.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 2.5, y = 1.5, z = 1.0 }
Config.MarkerColor                = { r = 255, g = 0, b = 0 }
Config.markerColor = {
    [1] = vec(255, 0, 0),
    [2] = vec(0, 255, 0),
    [3] = vec(0, 0, 255),
    [4] = vec(255, 255, 0),
    [5] = vec(255, 0, 255),
    [6] = vec(128, 0, 128),
    [7] = vec(128, 128, 0),
    [8] = vec(128, 128, 128),
    [9] = vec(0, 0, 0),
    [10] = vec(0, 128, 128),
}
Config.markerTypes = {
    locker = {
        type = 22,
        size = vector3(1.5, 1.5, 1.0),
    },
    armory = {
        type = 40,
        size = vector3(1.5, 1.5, 1.0),
    },
    veh = {
        type = 36,
        size = vector3(1.5, 1.5, 1.0),
    },
    vehdel = {
        type = 1,
        size = vector3(2.5, 2.5, 1.0),
    },
    heli = {
        type = 1,
        size = vector3(1.5, 1.5, 1.0),
    },
    helidel = {
        type = 34,
        size = vector3(3.5, 3.5, 2.0),
        radius = 5,
    },
    boss = {
        type = 31,
        size = vector3(1.5, 1.5, 1.0),
    },
    boat = {
        type = 35,
        size = vector3(1.5, 1.5, 1.0),
    },
    boatdel = {
        type = 35,
        size = vector3(3.5, 3.5, 2.0),
    },
}
Config.blipColor = {
    [1] = 46,
    [2] = 2,
    [3] = 4,
    [4] = 5,
    [5] = 48,
    [6] = 27,
    [7] = 16,
    [8] = 55,
    [9] = 85,
    [10] = 30,
}
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.MaxInService               = -1
Config.Locale                     = 'en'
Config.PVPCar = {
    {
        name = 'bf400',
        sc = 1,
    },
    {
        name = 'nwkuruma',
        sc = 3,
    },
    {
        name = 'vetir',
        sc = 1,
    },
    {
        name = 'kamacho',
        sc = 2,
    },
    {
        name = 'wastelander',
        sc = 5,
    },
    {
        name = 'monster',
        sc = 3,
    },
}

Config.PVPShop = {
    openTime = 90,
    openCount = 4,
    washCount = 3,
    shops = {
        { coords = vec(659.65,532.51,130.25)    },
        { coords = vec(216.02,-22.48,69.71)     },
        { coords = vec(198.67,-928.85,30.69)    },
        { coords = vec(1543.91,-2151.81,77.53)  },
        { coords = vec(1080.5,-692.2,57.79)     },
        { coords = vec(-52.09,-1784.88,27.85)   },
        { coords = vec(-1702.16,-1090.76,13.15) },
        { coords = vec(-530.22,-229.36,36.7)    },
        { coords = vec(-1034.02,-1071.3,4.1)    },
        { coords = vec(-1120.53,-2841.5,13.95)  },
    },
    weapons = {
        {-- loot 1
            { name = 'weapon_carbinerifle',     price = 5,  count = 7 },
            { name = 'weapon_advancedrifle',    price = 5,  count = 6 },
            { name = 'weapon_pumpshotgun_mk2',  price = 10, count = 6 },
            { name = 'weapon_carbinerifle_mk2', price = 12, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 },
            { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {-- loot 2
            { name = 'weapon_bullpuprifle',     price = 7,  count = 7 },
            { name = 'weapon_assaultshotgun',   price = 7,  count = 6 },
            { name = 'weapon_specialcarbine',   price = 7,  count = 6 },
            { name = 'weapon_bullpuprifle_mk2', price = 10, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 },
            { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {-- loot 3
            { name = 'weapon_pumpshotgun',      price = 7,  count = 7 },
            { name ='weapon_specialcarbine_mk2',price = 12, count = 6 },
            { name = 'weapon_bullpupshotgun',   price = 7,  count = 6 },
            { name = 'weapon_compactrifle',     price = 12, count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 },
            { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
        {-- loot 4
            { name = 'weapon_combatpdw',        price = 5,  count = 7 },
            { name = 'weapon_assaultrifle_mk2', price = 12, count = 6 },
            { name = 'weapon_gusenberg',        price = 8,  count = 6 },
            { name = 'weapon_sawnoffshotgun',   price = 7,  count = 6 },
            { name = 'weapon_microsmg',         price = 20, count = 1 },
            { name = 'weapon_doubleaction',     price = 20, count = 1 },
        },
    }
}



Config.PVPWash = {
    washTime = 30,
    coords = {
        { coords = vec(-1132.18, 4924.06, 219.71) }, -- cargo
        { coords = vec(-14.27, 6566.36, 31.91)    }, -- paleto
        { coords = vec(1505.37, 6326.61, 24.08)   }, -- chopshop bala
        { coords = vec(2489.38, 4961.79, 44.77)   }, -- mythic
        { coords = vec(464.33, 3565.72, 33.24)    }, -- chopshop chap
        { coords = vec(-1090.58, 2715.06, 19.08)  }, -- gunshop 8
        { coords = vec(-49.82, 1892.68, 195.36)   }, -- vasate map
        { coords = vec(2474.66, 1574.6, 32.74)    }, -- forooshe ajor
        { coords = vec(2601.37, 2803.5, 33.82)    }, -- chopshop rast
        { coords = vec(-2230.16, 3480.74, 30.17)  }, -- artesh
    },
    weapons = {
        { name = 'weapon_carbinerifle',      price = 220000 },
        { name = 'weapon_assaultrifle',      price = 220000 },
        { name = 'weapon_advancedrifle',     price = 220000 },
        { name = 'weapon_combatpdw',         price = 220000 },
        { name = 'weapon_bullpuprifle',      price = 240000 },
        { name = 'weapon_gusenberg',         price = 250000 },
        { name = 'weapon_assaultshotgun',    price = 240000 },
        { name = 'weapon_sawnoffshotgun',    price = 240000 },
        { name = 'weapon_pumpshotgun',       price = 240000 },
        { name = 'weapon_bullpupshotgun',    price = 240000 },
        { name = 'weapon_specialcarbine',    price = 240000 },
        { name = 'weapon_pumpshotgun_mk2',   price = 300000 },
        { name = 'weapon_bullpuprifle_mk2',  price = 300000 },
        { name = 'weapon_compactrifle',      price = 320000 },
        { name = 'weapon_specialcarbine_mk2',price = 320000 },
        { name = 'weapon_assaultrifle_mk2',  price = 320000 },
        { name = 'weapon_carbinerifle_mk2',  price = 320000 },
        { name = 'weapon_microsmg',          price = 400000 },
        { name = 'weapon_doubleaction',      price = 400000 },
    }
}

Config.vipVest = {
    {    -- Capone
        gang = { 'Capone' }, label = 'Capone VIP',
        num = { {56,0}, nil }
    }, { -- GroveStreet
        gang = { 'GroveStreet' }, label = 'GroveStreet VIP',
        num = { {57,0}, {56,16} }
    }, { -- GroveStreet2
        gang = { 'GroveStreet' }, label = 'GroveStreet VIP2',
        num = { {64,2}, {60,3} }
    }, { -- Alghaede
        gang = { 'Alghaede' }, label = 'Alghaede VIP',
        num = { {57,1}, {56,15} }
    }, { -- Raven
        gang = { 'Raven' }, label = 'Raven VIP',
        num = { {57,2}, {56,1} }
    }, { -- Legend_Family
        gang = { 'Legend_Family' }, label = 'Legend_Family VIP',
        num = { {57,3}, nil }
    }, { -- DISORDER
        gang = { 'DISORDER' }, label = 'DISORDER VIP',
        num = { {57,4}, {56,2} }
    }, { -- DISORDER
        gang = { 'DISORDER' }, label = 'DISORDER VIP2',
        num = { {60,0}, {57,9} }
    }, { -- DISORDER
        gang = { 'DISORDER' }, label = 'DISORDER VIP3',
        num = { {56,1}, nil }
    }, { -- Alpha
        gang = { 'Alpha' }, label = 'Alpha VIP',
        num = { {57,5}, {56,3} }
    }, { -- Alpha
        gang = { 'Alpha' }, label = 'Alpha VIP2',
        num = { {56,5}, nil }
    }, { -- DIABLO
        gang = { 'DIABLO' }, label = 'DIABLO VIP',
        num = { {57,6}, {56,4} }
    }, { -- ZAKHAR
        gang = { 'ZAKHAR' }, label = 'ZAKHAR VIP',
        num = { {57,7}, {56,5} }
    }, { -- Crips
        gang = { 'Crips' }, label = 'Crips VIP',
        num = { {57,8}, {56,6} }
    }, { -- Mandem
        gang = { 'Mandem' }, label = 'Mandem VIP',
        num = { {58,0}, {56,7} }
    }, { -- el_poder
        gang = { 'el_poder' }, label = 'el_poder VIP',
        num = { {57,9}, {56,9} }
    }, { -- Sopranos
        gang = { 'Sopranos', }, label = 'Sopranos VIP',
        num = { {58,1}, {56,8} }
    }, { -- BUSHEHR
        gang = { 'BUSHEHR' }, label = 'BUSHEHR VIP',
        num = { {57,10}, nil }
    }, { -- BUSHEHR
        gang = { 'BUSHEHR' }, label = 'BUSHEHR VIP 2',
        num = { {60,4}, {56,0} }
    }, { -- FOX
        gang = { 'FOX' }, label = 'FOX VIP',
        num = { {58,2}, {56,10} }
    }, { -- ULTRA
        gang = { 'ULTRA' }, label = 'ULTRA VIP',
        num = { {59,0}, {56,11} }
    }, { -- ULTRA 2
        gang = { 'ULTRA' }, label = 'ULTRA VIP2',
        num = { {56,13}, {60,4} }
    }, { -- GULAG_GANG
        gang = { 'GULAG_GANG' }, label = 'GULAG GANG VIP',
        num = { {57,17}, {56,12} }
    }, { -- Ballas
        gang = { 'Ballas' }, label = 'Ballas VIP',
        num = { {57,11}, {56,13} }
    }, { -- Ballas
        gang = { 'Ballas' }, label = 'Ballas VIP 2',
        num = { {62,6}, {58,6} }
    }, { -- SAVAGE
        gang = { 'SAVAGE' }, label = 'SAVAGE VIP',
        num = { {58,3}, {56,14} }
    }, { -- SAVAGE
        gang = { 'SAVAGE' }, label = 'SAVAGE VIP2',
        num = { {60,5}, {57,25} }
    }, { -- Siege
        gang = { 'Siege' }, label = 'Siege VIP',
        num = { {58,4}, {56,17} }
    }, { -- Siege
        gang = { 'Siege' }, label = 'Siege VIP 2',
        num = { {60,1}, nil }
    }, { -- Alliance
        gang = { 'Alliance' }, label = 'Alliance VIP',
        num = { {57,12}, {56,18} }
    }, { -- Al_Nasr
        gang = { 'Al_Nasr' }, label = 'Al_Nasr VIP',
        num = { {57,13}, {56,19} }
    }, { -- Night_Watch
        gang = { 'Night_Watch' }, label = 'Night Watch VIP',
        num = { {57,14}, {56,20} }
    }, { -- Syc
        gang = { 'Syc' }, label = 'Syc VIP',
        num = { {57,15}, {56,21} }
    }, { -- BlackHands
        gang = { 'BlackHands' }, label = 'BlackHands VIP',
        num = { {57,16}, {57,4} }
    }, { -- Persis_Family
        gang = { 'Persis_Family' }, label = 'Persis VIP',
        num = { {58,5}, {56,22} }
    }, { -- commando
        gang = { 'commando' }, label = 'Commando VIP',
        num = { {58,6}, {56,23} }
    }, { -- Rockstar
        gang = { 'Rockstar' }, label = 'Rockstar VIP',
        num = { {57,18}, {56,24} }
    }, { -- Khalifa
        gang = { 'Khalifa' }, label = 'Khalifa VIP',
        num = { {57,21}, {57,2} }
    }, { -- Khalifa
        gang = { 'Khalifa' }, label = 'Khalifa VIP2',
        num = { {62,1}, {58,1}}
    }, { -- Vikings
        gang = { 'Vikings' }, label = 'Vikings VIP',
        num = { {58,7}, {56,25}, }
    }, { -- Vikings
        gang = { 'Vikings' }, label = 'Vikings VIP2',
        num = { {60,6}, {59,5}, }
    }, { -- TALEB
        gang = { 'TALEB' }, label = 'TALEB VIP',
        num = { {58,8}, nil }
    }, { -- North_Kids
        gang = { 'North_Kids' }, label = 'North_Kids VIP',
        num = { {57,19}, {57,0} }
    }, { -- North_Kids
        gang = { 'North_Kids' }, label = 'North_Kids VIP2',
        num = { {62,5}, {58,5} }
    }, { -- Allies
        gang = { 'Allies' }, label = 'Allies VIP',
        num = { {57,20}, {57,1}, }
    }, { -- Demon
        gang = { 'Demon' }, label = 'Demon VIP',
        num = { {57,22}, {57,3} }
    }, { -- Demon
        gang = { 'Demon' }, label = 'Demon VIP',
        num = { {56,7}, {59,6} }
    }, { -- ASSASSIN
        gang = { 'ASSASSIN' }, label = 'ASSASSIN VIP',
        num = { {57,23}, {57,5} }
    }, { -- UN
        gang = { 'UN' }, label = 'UN VIP',
        num = { {57,24}, {57,6} }
    }, { -- UN 2
        gang = { 'UN' }, label = 'UN VIP 2',
        num = { {56,12}, {58,9} }
    }, { -- UN
        gang = { 'UN' }, label = 'UN VIP 3',
        num = { {60,10}, {60,18} }
    }, { -- Arnak
        gang = { 'Arnak' }, label = 'Arnak VIP',
        num = { {58,9}, {57,7} }
    }, { -- cukur_Godal
        gang = { 'cukur_Godal' }, label = 'Cukur Godal VIP',
        num = { {57,25}, {57,8} }
    }, { -- Anarchy
        gang = { 'Anarchy' }, label = 'Anarchy VIP',
        num = { {61,0}, {57,10} }
    }, { -- zedix
        gang = { 'zedix' }, label = 'zedix VIP',
        num = { {61,1}, {57,11} }
    }, { -- Terror
        gang = { 'Terror' }, label = 'Terror VIP',
        num = { {61,2}, {57,12} }
    }, { -- Terror
        gang = { 'Terror' }, label = 'Terror VIP2',
        num = { {56,8}, {58,8} }
    }, { -- Devil_Moon
        gang = { 'Devil_Moon' }, label = 'Devil Moon VIP',
        num = { {61,3}, {57,13} }
    }, { -- Saudi
        gang = { 'Saudi' }, label = 'Saudi VIP',
        num = { {61,4}, {57,14} }
    }, { -- Saudi
        gang = { 'Saudi' }, label = 'Saudi VIP 2',
        num = { {64,12}, {60,19} }
    }, { -- Sky
        gang = { 'Sky' }, label = 'Sky VIP',
        num = { {58,10}, {57,15} }
    }, { -- Crows
        gang = { 'Crows' }, label = 'Crows VIP',
        num = { {60,2}, {57,16} }
    }, { -- 013_ZaKan
        gang = { '013_ZaKan' }, label = '013_ZaKan VIP',
        num = { {61,5}, {57,17} }
    }, { -- 2poc
        gang = { '2poc' }, label = '2poc VIP',
        num = { {58,11}, {57,18} }
    }, { -- Hydra
        gang = { 'Hydra' }, label = 'Hydra VIP',
        num = { {56,2}, nil }
    }, { -- DEVIANT
        gang = { 'DEVIANT' }, label = 'DEVIANT VIP',
        num = { {60,3}, {57,19} }
    }, { -- mellow
        gang = { 'mellow' }, label = 'mellow VIP',
        num = { {61,6}, {57,20} }
    }, { -- SuDDeN
        gang = { 'SuDDeN' }, label = 'SuDDeN VIP',
        num = { {56,3}, {57,21} }
    }, { -- SuDDeN
        gang = { 'SuDDeN' }, label = 'SuDDeN VIP2',
        num = { {62,4}, {58,4} }
    }, { -- GeNTrY
        gang = { 'GeNTrY' }, label = 'GeNTrY VIP',
        num = { {56,4}, nil }
    }, { -- GOD_OF_GAMERS
        gang = { 'GOD_OF_GAMERS' }, label = 'GOD_OF_GAMERS VIP',
        num = { {61,7}, {57,22} }
    }, { -- Blue
        gang = { 'Blue' }, label = 'Blue VIP',
        num = { {61,8}, {57,23} }
    }, { -- Samurai
        gang = { 'Samurai' }, label = 'Samurai VIP',
        num = { {62,0}, {58,0} }
    }, { -- Samurai
        gang = { 'Samurai' }, label = 'Samurai VIP2',
        num = { {58,12}, {59,3} }
    }, { -- Wanted
        gang = { 'Wanted' }, label = 'Wanted VIP',
        num = { {61,9}, {57,24} }
    }, { -- Medellin
        gang = { 'Medellin' }, label = 'Medellin VIP',
        num = { {61,10}, {59,0} }
    }, { -- Rogue
        gang = { 'Rogue' }, label = 'Rogue VIP',
        num = { {64,0}, {60,0} }
    }, { -- Purple
        gang = { 'Purple' }, label = 'Purple VIP',
        num = { {56,6}, {59,1} }
    }, { -- Purple 2
        gang = { 'Purple' }, label = 'Purple VIP2',
        num = { {63,0}, {61,0} }
    }, { -- Ochi
        gang = { 'Ochi' }, label = 'Ochi VIP',
        num = { {62,2}, {58,2} }
    }, { -- BloodLust
        gang = { 'BloodLust' }, label = 'BloodLust VIP',
        num = { {62,3}, {58,3} }
    }, { -- MetallicA
        gang = { 'MetallicA' }, label = 'MetallicA VIP',
        num = { {61,11}, {59,2} }
    }, { -- Dark_sky
        gang = { 'Dark_sky' }, label = 'Dark_sky VIP',
        num = { {61,12}, {59,4} }
    }, { -- Space
        gang = { 'Space' }, label = 'Space VIP',
        num = { {62,7}, {58,7} }
    }, { -- Yoonan
        gang = { 'Yoonan' }, label = 'Yoonan VIP',
        num = { {61,13}, {59,7} }
    }, { -- BANDAR
        gang = { 'BANDAR' }, label = 'BANDAR VIP',
        num = { {61,14}, {59,8} }
    }, { -- Hexo
        gang = { 'Hexo' }, label = 'Hexo VIP',
        num = { {61,15}, {59,9} }
    }, { -- Warden
        gang = { 'Warden' }, label = 'Warden VIP',
        num = { {56,9}, {59,10} }
    }, { -- Eden_Dynasty
        gang = { 'Eden_Dynasty' }, label = 'Eden_Dynasty VIP',
        num = { {56,10}, {60,1} }
    }, { -- Eden_Dynasty 2
        gang = { 'Eden_Dynasty' }, label = 'Eden_Dynasty VIP 2',
        num = { {56,14}, {60,5} }
    }, { -- Legacy
        gang = { 'Legacy' }, label = 'Legacy VIP',
        num = { {61,16}, {59,11} }
    }, { -- Atomic_Fury_Clan
        gang = { 'Atomic_Fury_Clan' }, label = 'Atomic_Fury_Clan VIP',
        num = { {61,17}, {59,12} }
    }, { -- BLACK_AGENTS
        gang = { 'BLACK_AGENTS' }, label = 'BLACK_AGENTS VIP',
        num = { {61,18}, {59,13} }
    }, { -- Lean_Kids
        gang = { 'Lean_Kids' }, label = 'Lean_Kids VIP',
        num = { {60,7}, {59,14} }
    }, { -- Black_Disciple
        gang = { 'Black_Disciple' }, label = 'Black_Disciple VIP',
        num = { {64,1}, {60,2} }
    }, { -- Wakanda
        gang = { 'Wakanda' }, label = 'Wakanda VIP',
        num = { {61,19}, {59,15} }
    }, { -- Vision
        gang = { 'Vision' }, label = 'Vision VIP',
        num = { {56,11}, {59,16} }
    }, { -- Vegas
        gang = { 'Vegas' }, label = 'Vegas VIP',
        num = { {61,20}, {59,17} }
    }, { -- Ronin
        gang = { 'Ronin' }, label = 'Ronin VIP',
        num = { {61,21}, {59,18} }
    }, { -- DARKBLOOD
        gang = { 'DARKBLOOD' }, label = 'DARKBLOOD VIP',
        num = { {61,22}, {59,19} }
    }, { -- SyReN
        gang = { 'SyReN' }, label = 'SyReN VIP',
        num = { {61,23}, {59,20} }
    }, { -- FireFlower
        gang = { 'FireFlower' }, label = 'FireFlower VIP',
        num = { {61,24}, {59,21} }
    }, { -- Senator_Family
        gang = { 'Senator_Family' }, label = 'Senator Family VIP',
        num = { {64,3}, {60,6} }
    }, { -- BruTaL
        gang = { 'BruTaL' }, label = 'BruTaL VIP',
        num = { {56,15}, {59,23} }
    }, { -- Reapers
        gang = { 'Reapers' }, label = 'Reapers VIP',
        num = { {58,13}, {59,22} }
    }, { -- Delta_Core
        gang = { 'Delta_Core' }, label = 'Delta_Core VIP',
        num = { {64,4}, {60,7} }
    }, { -- GF
        gang = { 'GF' }, label = 'GF VIP',
        num = { {61,25}, {59,24} }
    }, { -- GF
        gang = { 'GF' }, label = 'GF VIP 2',
        num = { {65,0}, {59,25} }
    }, { -- chain
        gang = { 'chain' }, label = 'chain VIP',
        num = { {56,16}, {58,10} }
    }, { -- Desolate
        gang = { 'Desolate' }, label = 'Desolate VIP',
        num = { {56,17}, {60,8} }
    }, { -- Liquid
        gang = { 'Liquid' }, label = 'Liquid VIP',
        num = { {60,8}, {61,1} }
    }, { -- GLitCH
        gang = { 'GLitCH' }, label = 'GLitCH VIP',
        num = { {64,5}, {60,9} }
    }, { -- Apachea
        gang = { 'Apachea' }, label = 'Apachea VIP',
        num = { {64,6}, {60,10} }
    }, { -- Rifa
        gang = { 'Rifa' }, label = 'Rifa VIP',
        num = { {64,7}, {60,11} }
    }, { -- FURY_FM
        gang = { 'FURY_FM' }, label = 'FURY_FM VIP',
        num = { {60,9}, {58,11} }
    }, { -- SAYEN
        gang = { 'SAYEN' }, label = 'SAYEN VIP',
        num = { {56,18}, {60,12} }
    }, { -- ErrorX
        gang = { 'ErrorX' }, label = 'ErrorX VIP',
        num = { {58,14}, {62,0} }
    }, { -- Spark
        gang = { 'Spark' }, label = 'Spark VIP',
        num = { {65,1}, {62,1} }
    }, { -- Viper
        gang = { 'Viper' }, label = 'Viper VIP',
        num = { {64,8}, {60,13} }
    }, { -- Niko
        gang = { 'Niko' }, label = 'Niko VIP',
        num = { {65,2}, {62,2} }
    }, { -- sideA
        gang = { 'sideA' }, label = 'sideA VIP',
        num = { {64,9}, {60,14} }
    }, { -- Targaryen
        gang = { 'Targaryen' }, label = 'Targaryen VIP',
        num = { {58,15}, {62,3} }
    }, { -- NoMercy
        gang = { 'NoMercy' }, label = 'NoMercy VIP',
        num = { {64,10}, {60,15} }
    }, { -- Amazon
        gang = { 'Amazon' }, label = 'Amazon VIP',
        num = { {65,3}, {62,4} }
    }, { -- RICHARD
        gang = { 'RICHARD' }, label = 'RICHARD VIP',
        num = { {64,11}, {60,16} }
    }, { -- HeXeN
        gang = { 'HeXeN' }, label = 'HeXeN VIP',
        num = { {56,19}, {60,17} }
    },
}
