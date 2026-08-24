Config = {}
Config.Locale = 'en'

Config.AdminJail = {
	unjail = vec(212.92, -845.81, 30.38)
}

Config.AllowedJobs = {

	{name = 'police', unjailPerm = 15},
	{name = 'sheriff', unjailPerm = 15},
	{name = 'mt', unjailPerm = 15},

	{name = 'cid', unjailPerm = 15},
	{name = 'cia', unjailPerm = 15},
	{name = 'marshal', unjailPerm = 15},
	{name = 'fbi', unjailPerm = 15},
	{name = 'judge', unjailPerm = 15},
	{name = 'doa', unjailPerm = 15},
}

Config.CanJail = {
	{ coords = vec(456.7, -994.24, 34.25),    radius = 50.0,  unjail = vec(417.49, -986.89, 29.4)   },
	{ coords = vec(609.71, -8.03, 82.78),     radius = 15.0,  unjail = vec(649.10, -9.54, 82.78)    },
	{ coords = vec(1810.42, 3678.42, 34.19),  radius = 15.0,  unjail = vec(1843.97, 3674.32, 33.97) },
	{ coords = vec(-442.24, 6012.08, 27.58),  radius = 20.0,  unjail = vec(-432.09, 6012.62, 31.49) },
	{ coords = vec(-52.59, -2523.38, 7.39),   radius = 20.0,  unjail = vec(-45.3, -2504.76, 6.01)   },
	{ coords = vec(1561.44, 831.1, 77.66),    radius = 20.0,  unjail = vec(1843.97, 3674.32, 33.97) },
	{ coords = vec(-1084.51, -832.25, 19.04), radius = 35.0,  unjail = vec(-1065.03,-852.5,4.87)    },
	{ coords = vec(-558.15,-232.8,34.27),     radius = 10.0,  unjail = vec(-552.55,-212.83,37.65)   },
	{ coords = vec(2507.51,-351.32,105.69),   radius = 20.0,  unjail = vec(2504.81,-384.02,94.12)   },
	{ coords = vec(1763.6, 2487.04, 46.56),   radius = 25.0,  unjail = vec(1843.97, 3674.32, 33.97), cutscene = true },
	{ coords = vec(846.26, -1294.02, 28.24),  radius = 20.0,  unjail = vec(821.74, -1275.26, 26.39) },
	{ coords = vec(380.17, 797.27, 187.46),   radius = 6.0,   unjail = vec(389.3, 797.63, 187.67)   },
}

Config.cutscene = {
	cuff = vec(405.9, -999.5, -100.0),
	guardModel = 's_f_y_cop_01',
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

Config.ServiceExtensionOnEscape = 8
Config.DistanceExtension = 50.0

Config.ServiceLocation = vec(-3451.93, -3464.14, 462.35)
Config.ReleaseLocation = vec(-255.97, -973.38, 31.22)

Config.pedLocation = {
	vec(-3460.57, -3484.77, 462.35),
	vec(-3468.69, -3473.04, 462.35),
	vec(-3465.0, -3457.78, 462.35),
	vec(-3447.82, -3452.46, 462.35),
	vec(-3430.84, -3460.88, 462.35),
}

Config.ServiceLocations = {
	{ type = "cleaning",  coords = vec(-3451.27,-3463.8,462.35) },
	{ type = "gardening", coords = vec(-3449.92,-3488.68,462.35) },
	{ type = "gardening", coords = vec(-3443.9,-3439.61,462.35) },
	{ type = "gardening", coords = vec(-3424.43,-3467.07,462.35) },
	{ type = "gardening", coords = vec(-3475.29,-3449.92,462.35) },
}

Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 74, 	['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 5,
			['shoes_2']  = 0,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 3,
			['torso_1']  = 0,  	['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 85,  ['pants_1']  = 3,
			['pants_2']  = 15,  ['shoes_1']  = 16,
			['shoes_2']  = 0, 	['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}
