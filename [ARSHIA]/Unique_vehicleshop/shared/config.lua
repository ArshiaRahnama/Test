Config = {}
Config.Vehicles = {}
------------------------------------------------------------------------------------
Config.Mysql = "oxmysql" -- this server uses oxmysql (per server.cfg)
Config.lang = {
    openmenu = "~g~[E]~w~ Open Galery",
    noperm = "No Permission",
    nomoney = "Insufficient money",
    buyvehicle = "Purchase successful"
}

Config.drawtextorfloating = false
Config.table = "esx" -- esx , qb , other 


Config.vehicleshop = {
    [1] = {
        galeryname = "UNIQUE VEHICLE",
        dec = "Lorem ipsum dolor sit amet consectetur. Consectetur condimentum erat sed fringilla lacinia bibendum.",
        type = "car",
        minRank = 0, -- minimum permission_level required to use this shop (essentialmode: 0 = everyone, higher = staff/admin only). Raise this for staff/test shops, e.g. 2 or 8.
        categories = {"compacts","coupes","motorcycles","muscle","offroad","sedans","sports","sportsclassics","super","suvs","vans"},
        coord = vector3(-32.785, -1102.3, 26.4223),
        buyspawn = vector3(-8.8265, -1082.0, 26.2381),
        vehspawn = vector3(-99.3386230469, -1049.10900878906, 26.756130218506),
        blip = {
            sprite = 225,      -- car mod shop icon
            color = 5,         -- yellow (matches the UI theme)
            scale = 0.85,
            label = "Vehicle Shop",
        },
        marker = {
            type = 27,         -- spinning arrow marker (way more fun than a flat circle)
            color = {r = 255, g = 193, b = 7, a = 130},
            size = vector3(1.4, 1.4, 1.0),
            offsetZ = -0.98,
            radius = 5.0,      -- distance at which the marker becomes visible
            interactRadius = 3.0, -- distance at which [E] activates
        },
    },
    [2] = {
        -- Self-contained boat shop (no longer depends on esx_boat)
        galeryname = "UNIQUE BOATS",
        dec = "Boat showroom - buy the best watercraft in the city right here.",
        type = "boat",
        minRank = 0,
        categories = {"boats"},
        coord = vector3(-40.7176, -1094.69, 27.274),
        buyspawn = vector3(-792.78, -1501.01, -0.47),
        vehspawn = vector3(-792.78, -1501.01, -0.47),
        blip = {
            sprite = 410,      -- boat icon
            color = 3,         -- light blue
            scale = 0.85,
            label = "Boat Shop",
        },
        marker = {
            type = 27,
            color = {r = 10, g = 197, b = 243, a = 130},
            size = vector3(1.4, 1.4, 1.0),
            offsetZ = -0.98,
            radius = 5.0,
            interactRadius = 3.0,
        },
    },
    [3] = {
        -- Self-contained heli shop (no longer depends on esx_heli)
        galeryname = "UNIQUE AIR",
        dec = "Helicopter showroom - the fastest way to move around the city skies.",
        type = "helicopter",
        minRank = 0,
        categories = {"helicopters"},
        coord = vector3(-38.7102, -1100.23, 27.274),
        buyspawn = vector3(-1405.34, -3212.34, 13.944),
        vehspawn = vector3(-1405.34, -3212.34, 13.944),
        blip = {
            sprite = 43,       -- helicopter icon
            color = 5,
            scale = 0.85,
            label = "Air Shop",
        },
        marker = {
            type = 27,
            color = {r = 219, g = 8, b = 255, a = 130},
            size = vector3(1.4, 1.4, 1.0),
            offsetZ = -0.98,
            radius = 5.0,
            interactRadius = 3.0,
        },
    },
    [4] = {
        -- Self-contained plane shop (no longer depends on esx_air).
        -- Coords match esx_air/config.lua: Zones.AirShops[1].Outside for the entrance,
        -- and Zones.AirShops[1].Inside for the preview/buy spawn (same airfield as the heli shop).
        galeryname = "UNIQUE PLANES",
        dec = "Aircraft showroom - fixed-wing planes for the pilots of the city.",
        type = "airplane",
        minRank = 0,
        categories = {"planes"},
        coord = vector3(-51.4241, -1094.91, 27.274),
        buyspawn = vector3(-1405.34, -3212.34, 13.944),
        vehspawn = vector3(-1405.34, -3212.34, 13.944),
        blip = {
            sprite = 307,      -- plane icon
            color = 2,         -- green
            scale = 0.85,
            label = "Plane Shop",
        },
        marker = {
            type = 27,
            color = {r = 4, g = 255, b = 23, a = 130},
            size = vector3(1.4, 1.4, 1.0),
            offsetZ = -0.98,
            radius = 5.0,
            interactRadius = 3.0,
        },
    },
}

Config.Vehicles["compacts"] = {
    { label = "Blista", name = "blista", price = 2000 },
    { label = "Brioso", name = "brioso", price = 62000 },
    { label = "Dilettante", name = "dilettante", price = 40000 },
    { label = "Issi S", name = "issi2", price = 38500 },
    { label = "Panto", name = "panto", price = 22000 },
    { label = "Prairie", name = "prairie", price = 60000 },
    { label = "Rhapsody", name = "rhapsody", price = 30000 },
    } 
    
    Config.Vehicles["coupes"] = {
    { label = "Cogcabrio", name = "cogcabrio", price = 40000 },
    { label = "Exemplar", name = "exemplar", price = 60000 },
    { label = "F620", name = "f620", price = 70000 },
    { label = "Felon", name = "felon", price = 70000 },
    { label = "Felon S", name = "felon2", price = 60000 },
    { label = "Jackal", name = "jackal", price = 92000 },
    { label = "Oracle S", name = "oracle", price = 82000 },
    { label = "Oracle", name = "oracle2", price = 87000 },
    { label = "sentinel", name = "sentinel", price = 100000 },
    { label = "Windsor", name = "windsor", price = 70000 },
    { label = "windsor S", name = "windsor2", price = 70000 },
    { label = "zion", name = "zion", price = 75000 },
    { label = "zion S", name = "zion2", price = 80000 },
    } 
    
    
    Config.Vehicles["motorcycles"] = {
    { label = "Avarus", name = "avarus", price = 4700 },
    { label = "Bati", name = "bati", price = 50000 },
    { label = "Carbonr S", name = "carbonrs", price = 31200 },
    { label = "Cliff hanger", name = "cliffhanger", price = 7700 },
    { label = "Daemon", name = "daemon", price = 18100 },
    { label = "Defiler", name = "defiler", price = 5000 },
    { label = "Diablous S", name = "Diablous2", price = 50000 },
    { label = "Double", name = "double", price = 35000 },
    { label = "Ess key", name = "esskey", price = 14000 },
    { label = "Faggio S", name = "faggio", price = 5500 },
    { label = "FCR", name = "fcr", price = 13500 },
    { label = "FCR S", name = "fcr2", price = 19600 },
    { label = "Gargoyle", name = "gargoyle", price = 34000 },
    { label = "Hakuchou", name = "hakuchou", price = 60000 },
    { label = "Hexer", name = "hexer", price = 19500 },
    { label = "Innovation", name = "innovation", price = 32000 },
    { label = "Lectro", name = "lectro", price = 40000 },
    { label = "Nightblade", name = "nightblade", price = 25000 },
    { label = "PCJ", name = "pcj", price = 13500 },
    { label = "Ruffian", name = "ruffian", price = 10000 },
    { label = "Sanchez", name = "sanchez2", price = 15000 },
    { label = "Vader", name = "vader", price = 11700 },
    { label = "Vortex", name = "vortex", price = 13356 },
    { label = "Wolfsbane", name = "wolfsbane", price = 27000 },
    } 
    
    
    Config.Vehicles["muscle"] = {
    { label = "Blade", name = "blade", price = 1000 },
    { label = "Buccaneer", name = "buccaneer", price = 10000 },
    { label = "Chino", name = "chino", price = 15000 },
    { label = "Chino S", name = "chino2", price = 20000 },
    { label = "Coquette GM", name = "coquette3", price = 80000 },
    { label = "Dominator", name = "dominator", price = 55000 },
    { label = "Faction", name = "faction", price = 35000 },
    { label = "Gauntlet", name = "gauntlet", price = 40000 },
    { label = "Hermes", name = "hermes", price = 53000 },
    { label = "Hotknife", name = "hotknife", price = 50000 },
    { label = "Moon Beam", name = "moonbeam", price = 65000 },
    { label = "Night Shade", name = "nightshade", price = 30300 },
    { label = "Picador", name = "picador", price = 15000 },
    { label = "Ratloader MS", name = "ratloader2", price = 18000 },
    { label = "Ruiner", name = "ruiner", price = 54000 },
    { label = "Sabre GT", name = "sabregt", price = 87000 },
    { label = "Slam Van", name = "slamvan", price = 80000 },
    { label = "stalion", name = "stalion", price = 42000 },
    { label = "Tampa GT", name = "tampa", price = 20000 },
    { label = "Vigero", name = "vigero", price = 78000 },
    { label = "Virgo", name = "virgo", price = 75000 },
    { label = "Voodoo", name = "voodoo", price = 70000 },
    { label = "Yosemite", name = "yosemite", price = 70000 },
    } 
    
    Config.Vehicles["offroad"] = {
    { label = "Bf Injection", name = "bfinjection", price = 15000 },
    { label = "Bifta", name = "bifta", price = 18000 },
    { label = "Brawler", name = "brawler", price = 30000 },
    { label = "Mesa OR", name = "mesa3", price = 45000 },
    { label = "Rancher XL", name = "rancherxl", price = 30000 },
    { label = "Rebel OR", name = "rebel2", price = 20000 },
    } 
    
    
    Config.Vehicles["sedans"] = {
    { label = "Asea", name = "asea", price = 3000 },
    { label = "Asterope", name = "asterope", price = 4000 },
    { label = "COG55", name = "cog55", price = 25000 },
    { label = "Cognoscenti", name = "cognoscenti", price = 30000 },
    { label = "Emperor", name = "emperor", price = 8000 },
    { label = "Fugitive", name = "fugitive", price = 35000 },
    { label = "Glendale", name = "glendale", price = 25000 },
    { label = "Ingot", name = "ingot", price = 45000 },
    { label = "Intruder", name = "intruder", price = 53000 },
    { label = "Premier", name = "premier", price = 35000 },
    { label = "Primo", name = "primo", price = 50000 },
    { label = "Regina", name = "regina", price = 22500 },
    { label = "Schafter SD", name = "schafter2", price = 45000 },
    { label = "Stanier", name = "stanier", price = 40000 },
    { label = "Stratum", name = "stratum", price = 63000 },
    { label = "Stretch", name = "stretch", price = 100000 },
    { label = "Superd", name = "superd", price = 42000 },
    { label = "Surge", name = "surge", price = 30000 },
    { label = "Tailgater", name = "tailgater", price = 86000 },
    { label = "Warrener", name = "warrener", price = 35000 },
    { label = "Washington", name = "washington", price = 25000 },
    } 
    
    
    
    Config.Vehicles["sports"] = {
    { label = "Alpha", name = "alpha", price = 20000 },
    { label = "Banshee", name = "banshee", price = 35000 },
    { label = "Blista S", name = "blista2", price = 6000 },
    { label = "Blista GT", name = "blista3", price = 25000 },
    { label = "Buffalo", name = "buffalo", price = 68000 },
    { label = "Buffalo GT", name = "buffalo3", price = 70000 },
    { label = "Carboni", name = "carbonizzare", price = 55500 },
    { label = "Comet SX", name = "comet2", price = 80000 },
    { label = "Coquette", name = "coquette", price = 45000 },
    { label = "Elegy", name = "elegy", price = 75000 },
    { label = "Elegy S", name = "elegy2", price = 78000 },
    { label = "Feltzer S", name = "feltzer2", price = 63100 },
    { label = "Furore GT", name = "furoregt", price = 50000 },
    { label = "Fusilade", name = "fusilade", price = 66000 },
    { label = "Futo", name = "futo", price = 75000 },
    { label = "Jester", name = "jester", price = 150000 },
    { label = "Khamelion", name = "khamelion", price = 83000 },
    { label = "Kuruma", name = "kuruma", price = 98000 },
    { label = "Lynx S", name = "lynx2", price = 57300 },
    { label = "Massacro", name = "massacro", price = 88000 },
    { label = "Neon", name = "neon", price = 170000 },
    { label = "Ninef", name = "ninef", price = 63000 },
    { label = "Pariah", name = "pariah", price = 72200 },
    { label = "Penumbra", name = "penumbra", price = 66500 },
    { label = "Raiden", name = "raiden", price = 68800 },
    { label = "Rapid GT", name = "rapidgt", price = 35000 },
    { label = "Rapidgt Turbo", name = "rapidgt2", price = 82500 },
    { label = "Revolter", name = "revolter", price = 40000 },
    { label = "ruston", name = "ruston", price = 93200 },
    { label = "Schafter ST", name = "schafter3", price = 40000 },
    { label = "Schwarzer", name = "schwarzer", price = 65350 },
    { label = "Seven 70", name = "seven70", price = 93000 },
    { label = "Specter", name = "specter", price = 58750 },
    { label = "Streiter", name = "streiter", price = 100000 },
    { label = "Sultan", name = "sultan", price = 86642 },
    { label = "Surano", name = "surano", price = 71350 },
    { label = "Tampa ST", name = "tampa2", price = 43500 },
    { label = "Tropos", name = "tropos", price = 95000 },
    { label = "Verlierer ST", name = "verlierer2", price = 96000 },
    } 
    
    
    Config.Vehicles["sportsclassics"] = {
    { label = "Btype", name = "btype", price = 90000 },
    { label = "Btype SC", name = "btype2", price = 95000 },
    { label = "Btype S", name = "btype3", price = 99000 },
    { label = "Casco", name = "casco", price = 42000 },
    { label = "Coquette SC", name = "coquette2", price = 54000 },
    { label = "Feltzer SC", name = "feltzer3", price = 80000 },
    { label = "GT500", name = "gt500", price = 70000 },
    { label = "Infernus SC", name = "infernus2", price = 70000 },
    { label = "Mamba", name = "mamba", price = 40000 },
    { label = "Manana", name = "manana", price = 66000 },
    { label = "Monroe", name = "monroe", price = 84000 },
    { label = "Peyote", name = "peyote", price = 86500 },
    { label = "Pigalle", name = "pigalle", price = 20000 },
    { label = "Rapid GTSC", name = "rapidgt3", price = 38000 },
    { label = "Retinue", name = "retinue", price = 78000 },
    { label = "Savestra", name = "savestra", price = 85000 },
    { label = "Stinger", name = "stinger", price = 76000 },
    { label = "Stromberg", name = "stromberg", price = 77000 },
    { label = "Turismo SC", name = "turismo2", price = 90000 },
    { label = "Viseris", name = "viseris", price = 100000 },
    { label = "Ztype", name = "ztype", price = 100000 },
    } 
    
    
    Config.Vehicles["super"] = {
    { label = "Adder", name = "adder", price = 120000 },
    { label = "Banshee 900R", name = "banshee2", price = 60000 },
    { label = "Bullet", name = "bullet", price = 95000 },
    { label = "Cyclone", name = "cyclone", price = 127000 },
    { label = "drafter", name = "drafter", price = 500000 },
    { label = "Entity XF", name = "entityxf", price = 60000 },
    { label = "FMJ", name = "fmj", price = 150000 },
    { label = "GPL", name = "gp1", price = 127000 },
    { label = "Italigtb", name = "italigtb", price = 200000 },
    { label = "jugular", name = "jugular", price = 500000 },
    { label = "LE7B", name = "le7b", price = 85000 },
    { label = "Nero", name = "nero", price = 220000 },
    { label = "Osiris", name = "osiris", price = 100000 },
    { label = "Penetrator", name = "penetrator", price = 69999 },
    { label = "Pfister", name = "pfister811", price = 130000 },
    { label = "Prototipo", name = "prototipo", price = 125000 },
    { label = "Reaper", name = "reaper", price = 167000 },
    { label = "SCL", name = "sc1", price = 100000 },
    { label = "Sheava", name = "sheava", price = 147000 },
    { label = "sultanrs", name = "sultanrs", price = 95000 },
    { label = "T20", name = "t20", price = 250000 },
    { label = "Tempesta", name = "tempesta", price = 127000 },
    { label = "Turismor", name = "turismor", price = 127000 },
    { label = "Tyrus", name = "tyrus", price = 135000 },
    { label = "Vagner", name = "vagner", price = 127000 },
    { label = "Visione", name = "visione", price = 130000 },
    { label = "Voltic", name = "voltic", price = 127000 },
    { label = "XA21", name = "xa21", price = 150000 },
    { label = "Zentorno", name = "zentorno", price = 325000 },
    } 
    
    
    Config.Vehicles["suvs"] = {
    { label = "Baller", name = "baller", price = 40000 },
    { label = "Baller Super", name = "baller4", price = 50000 },
    { label = "BJXL", name = "bjxl", price = 50000 },
    { label = "Cavalcade", name = "cavalcade", price = 92000 },
    { label = "Contender", name = "contender", price = 70000 },
    { label = "Dubsta", name = "dubsta", price = 95000 },
    { label = "FQ2", name = "fq2", price = 63000 },
    { label = "Granger", name = "granger", price = 50000 },
    { label = "Gresley", name = "gresley", price = 70000 },
    { label = "Habanero", name = "habanero", price = 62000 },
    { label = "Huntley", name = "huntley", price = 100000 },
    { label = "Lands Talker", name = "landstalker", price = 85000 },
    { label = "Mesa S", name = "mesa", price = 60000 },
    { label = "Patriot", name = "patriot", price = 70000 },
    { label = "Radi", name = "radi", price = 74000 },
    { label = "Rocoto", name = "rocoto", price = 60000 },
    { label = "Sadler", name = "sadler", price = 100000 },
    { label = "Seminole", name = "seminole", price = 97000 },
    { label = "Serrano", name = "serrano", price = 78000 },
    { label = "XLS", name = "xls", price = 70000 },
    } 
    
    Config.Vehicles["vans"] = {
    { label = "Bobcatxl", name = "bobcatxl", price = 50000 },
    { label = "Camper", name = "camper", price = 60000 },
    { label = "Journey", name = "journey", price = 80000 },
    { label = "Minivan", name = "minivan", price = 70000 },
    { label = "Minivan2", name = "minivan2", price = 50000 },
    { label = "Rumpo VN", name = "rumpo3", price = 65000 },
    { label = "Speedo", name = "speedo", price = 100000 },
    { label = "Youga", name = "Youga", price = 24000 },
    { label = "Youga VN", name = "youga2", price = 20000 },
    } 

    -- Boat prices (self-contained, no esx_boat dependency)
    Config.Vehicles["boats"] = {
    { label = "Jetmax", name = "jetmax", price = 10000000 },
    { label = "Marquis", name = "marquis", price = 60000000 },
    { label = "Seashark", name = "seashark3", price = 15000000 },
    { label = "Speeder", name = "speeder", price = 50000000 },
    { label = "Speeder 2", name = "speeder2", price = 50000000 },
    { label = "Toro", name = "toro2", price = 50000000 },
    { label = "Tropic2", name = "tropic2", price = 5000000 },
    { label = "Longfin", name = "longfin", price = 60000000 },
    { label = "Dinghy", name = "dinghy4", price = 50000000 },
    }

    -- Helicopter prices (self-contained, no esx_heli dependency)
    Config.Vehicles["helicopters"] = {
    { label = "Volatus", name = "volatus", price = 750000000 },
    { label = "Swift2", name = "swift2", price = 70000000 },
    { label = "Supervolito", name = "supervolito", price = 50000000 },
    { label = "Buzzard2", name = "buzzard2", price = 35000000 },
    { label = "Seasparrow", name = "seasparrow", price = 30000000 },
    { label = "Havok", name = "havok", price = 20000000 },
    }

    -- Plane prices (self-contained, no esx_air dependency)
    Config.Vehicles["planes"] = {
    { label = "Nimbus", name = "nimbus", price = 100000000 },
    { label = "Vestra", name = "vestra", price = 70000000 },
    { label = "Dodo", name = "dodo", price = 50000000 },
    { label = "Mammatus", name = "mammatus", price = 30000000 },
    { label = "Microlight", name = "microlight", price = 10000000 },
    }

    Config.TestDrive = {
		seconds = 15,
		coords  = vector3(-942.64,-3365.96,12.95),
		range   = 400,
	}