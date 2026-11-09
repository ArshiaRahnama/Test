-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}

Config.CanJail = {
    { coords = vec(456.7, -994.24, 34.25),    radius = 50.0,  unjail = vec(417.49, -986.89, 29.4)   },
    { coords = vec(609.71, -8.03, 82.78),     radius = 15.0,  unjail = vec(649.10, -9.54, 82.78)    },
    { coords = vec(1843.81, 3674.45, 34.33),  radius = 7.0,   unjail = vec(1858.35, 3677.34, 34.13) },
    { coords = vec(-442.24, 6012.08, 27.58),  radius = 20.0,  unjail = vec(-432.09, 6012.62, 31.49) },

    { coords = vec(-52.59, -2523.38, 7.39),   radius = 20.0,  unjail = vec(-45.3, -2504.76, 6.01)   },
    { coords = vec(1561.44, 831.1, 77.66),    radius = 20.0,  unjail = vec(407.03, -1613.41, 29.29) },
    { coords = vec(-1084.51, -832.25, 19.04), radius = 35.0,  unjail = vec(-1065.03,-852.5,4.87)    },

    { coords = vec(-546.53, -201.5, 38.22),   radius = 50.0,  unjail = vec(-552.55,-212.83,37.65), forceCenterJail = true },
    { coords = vec(261.89, -428.15, 47.47),   radius = 8.0,   unjail = vec(253.26, -400.69, 46.32)  },
    { coords = vec(2507.51,-351.32,105.69),   radius = 20.0,  unjail = vec(2504.81,-384.02,94.12)   },
    { coords = vec(1763.6, 2487.04, 46.56),   radius = 25.0,  unjail = vec(407.03, -1613.41, 29.29) },
}

Config.Admin = {
    coords = { x = 637.34, y = 1296.43, z = -69.7 },
    heading = 268.21,
    distance = 13
}

Config.Unjails = {
    admin = { x = 407.03, y = -1613.42, z = 29.29 }, heading = 319.42
}

Config.cutscene = {
    cuff = vec(405.9, -999.5, -100.0),
    guardModel = 'csb_cop',
    guardCoords = vec(405.6, -1000.9, -100.0, 2.9),
    clotheModel = 'prop_cs_t_shirt_pile',
    clotheCoords = vec(402.36, -1001.24, -98.0, 356.4),
    clotheCoords2 = vec(402.7, -1000.0, -99.0, 183.02),
    camCoords = vec(402.9, -1002.5, -99.0),
    camRot = vec(0.0, 0.0, 0.0),
    stopTurn = vec(405.9, -997.4, -99, 97.76),
    enterCoords = vec(402.86, -996.55, -99.0),
    stopNLook = vec(403.66, -1001.99, -99.0, 188.08),
    computerCoords = vec(401.48, -1001.83, -99.0, 1.97),
    pointCoords = vec(402.08, -1001.8, -99.0, 357.9),
    enterHeadings = {Front = 178.32, Side = 264.63},
    grabCoords = vec(403.19, -997.42, -99.0, 12.43),
    walkCoords = vec(406.04, -997.09, -99.0),
    police2Coords = vec(497.05, -1021.52, 28.03, 0.41),
    spawnCoords2 = vec(496.65, -1020.39, 27.99, 353.8),
    riotCoords = vec(496.21, -1000.39, 27.36, 358.99),
    behindRiotCoords = vec(495.53, -1005.96, 27.74, 353.07),
    camCoords2 = vec(503.74, -1024.76, 30.32),
    camCoords3 = vec(505.57, -1006.08, 29.67),
    camRot2 = vec(-10.0, 0.0, 30.0),
    camRot3 = vec(-10.0, 0.0, 70.0),
}

Config.justice = {
    {
        jail = vec(-535.54, -172.75, 38.22),
        range = vec(-535.54, -172.75, 38.22, 3.0),
        animation = {
            camCoords = vec(-553.08, -226.27, 52.55),
            pointAt = vec(-561.36, -232.35, 49.78),
            ped1 = vec(-565.24, -225.95, 49.78, 197.9),
            ped2 = vec(-565.34, -224.81, 49.78, 206.86)
        }
    },
    {
        jail = vec(265.17, -426.88, 47.47),
        range = vec(232.99, -418.92, 48.1, 3.0),
        animation = {
            camCoords = vec(216.74, -382.05, 65.72),
            pointAt = vec(205.55, -390.78, 63.35),
            ped1 = vec(211.77, -393.23, 63.35, 73.56),
            ped2 = vec(212.9, -393.63, 63.35, 69.98)
        }
    }
}

Config.blackListItem = {
    ['marijuana'] = 30,
    ['extra_marijuana'] = 1,
    ['cocaine'] = 10,
    ['crack'] = 5,
    ['extra_crack'] = 1,
    ['meth'] = 5,
    ['extra_meth'] = 1,
    ['opium'] = 10,
    ['heroine'] = 5,
    ['extra_heroine'] = 1,
    ['forge'] = 1,
    ['blackmoney'] = 5000,
    ['wolfram'] = 1,
}

Config.checkLicense = {
    ['mojavezgun_1'] = 'Aslahe',
    ['hunt_l1'] = 'Shekar',
    ['selahsard'] = 'Selahe Sard',
}

Config.whiteListWeapon = {
    WEAPON_SNIPERRIFLE = true,
    WEAPON_MINIGUN = true,
    WEAPON_LUCILLE = true,
    WEAPON_KATANA = true,
    WEAPON_KATANA2 = true,
    WEAPON_PETROLCAN = true,
    WEAPON_HEAVYSNIPER_MK2 = true,
}

Config.suggestionjail = {

    ['police'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },
    ['sheriff'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Ranandegi Dar Halat Masti',           	time = 10 },
			{ label = 'Mosabeghe Khiyabani',           			time = 20 },
			{ label = 'Tasadof Va Farar Kardan',           		time = 20 },
			{ label = 'Farar Az Mamor Sheriff',           		time = 10 },
			{ label = 'Farar az Mamor Sheriff Sarneshin',     	time = 10 },
			{ label = 'Ranandeghi Khatarnak',           		time = 20 },
			{ label = 'Hamle Kardan Be Shahrvandan',        	time = 20 },
			{ label = 'Dozdi Az Shahrvandan',           		time = 20 },
			{ label = 'Ensedad Dar Ejra Edaalat',           	time = 15 },
			{ label = 'Hamle Ashyaee Gheyre Mojaz',          	time = 10 },
			{ label = 'Yaghi Gari',           					time = 10 },
			{ label = 'Mozahemat Baraye Organ Dolati',        	time = 15 },
			{ label = 'Hamle Mavad Mokhader',           		time = 15 },
			{ label = 'Forosh Daroo Haye Gheyr Ghanooni',     	time = 15 },
			{ label = 'Ghachagh Mavad Mokhader',           		time = 20 },
			{ label = 'Dargiri Khiyabani',           			time = 20 },
			{ label = 'Ghatl',           						time = 30 },
			{ label = 'Tirandazi be Mamoran Nezami',        	time = 30 },
			{ label = 'Gerogan Giri',           				time = 25 },
			{ label = 'Serghat Khane',           				time = 15 },
			{ label = 'Serghat Mashin',           				time = 20 },
			{ label = 'Haml Selahe Garm Gheyr Mojaz',        	time = 20 },
			{ label = 'Hamle Vest Bedone Mojavez',           	time = 10 },
			{ label = 'Hamle Kolah Ballestic Bedone Mojavez', 	time = 10 },
			{ label = 'Hamle Selah Sard Bedone Mojavez',     	time = 10 },
			{ label = 'Hamle Aslahe Mojaz Bedone Mojavez',   	time = 10 },
			{ label = 'Tir Andazi Ba Selahe Garm',          	time = 15 },
			{ label = 'Enteghal Gheyre Ghanooni Selah Garm',	time = 10 },
			{ label = 'Tozi Selah Garm Ya Mohemat',     		time = 20 },

        },
    },
    ['mt'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },
    ['fbi'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'Store Robbery',           		time = 12 },
			{ label = 'Mini Bank Robbery',     			time = 17 },
			{ label = 'Mini Jaw Robbery',           	time = 12 },
			{ label = 'Gun Shop Robbery',  				time = 12 },
			{ label = 'Jav City Robbery',       		time = 20 },
			{ label = 'Jav Sandy Robbery',      		time = 20 },
			{ label = 'Maze Bank Robbery',           	time = 25 },
        },
    },
    ['detective'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },
    ['justice'] = {
        allowManual = true,
        maxTime     = 60,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },
    ['default'] = {
        allowManual = true,
        maxTime     = 40,
        list = {
			{ label = 'notitle',           		        time = 1 },
        },
    },
}
