Config_taxi                            = {}

Config_taxi.DrawDistance               = 10.0

Config_taxi.MarkerSize                 = { x = 1.0, y = 1.0, z = 1.0 }
Config_taxi.MarkerType                 = 21
Config_taxi.MarkerColor                = { r = 0, g = 0, b = 255 }

Config_taxi.NPCJobEarnings             = {min = 1000, max = 3000}
Config_taxi.MinimumDistance            = 3000

Config_taxi.MaxInService               = -1
Config_taxi.EnablePlayerManagement     = true
Config_taxi.EnableSocietyOwnedVehicles = false
Config_taxi.EnableJobBlip              = true

Config_taxi.Locale                     = 'en'

Config_taxi.AuthorizedVehicles = {
	Shared = {
		{
			model = 'b219tahoe',
			label = 'Taxi Tahoe',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1}

		},
		{
			model = 'b218tau',
			label = 'Taxi Tau',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['6'] = 1, ['7'] = 1}
		},
		{
			model = 'b216explorer',
			label = 'Taxi Explorer',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b214charger',
			label = 'Taxi Charger',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 1, ['8'] = 1 }
		},
		{
			model = 'b212caprice',
			label = 'Taxi Caprice',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'b211vic',
			label = 'Taxi Vic',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['10'] = 1}
		},
		{
			model = 'b218charger',
			label = 'Taxi Charger18',
			Extra = {['1'] = 1, ['2'] = 1, ['3'] = 1, ['4'] = 1, ['5'] = 1, ['6'] = 1}
		},
		{
			model = 'fibm5',
			label = 'Taxi BMWM5',
			Extra = {['1'] = 0}
		},
		{
			model = 'swat_dirtbike',
			label = 'Taxi Motor',
			Extra = {['1'] = 0}
		},
		{
			model = 'bus',
			label = 'Taxi Bus'
		},
	},
}

Config_taxi.AuthorizedHelis = {
	Shared = {
		{
			model = 'tx_heli',
			label = 'Taxi Heli'
		},
		{
			model = 'polmav',
			label = 'Taxi Polmav'
		},

	},
}

Config_taxi.Zones = {

	VehicleSpawner = {
		Pos   = {x = 887.4229, y = -142.919, z = 69.369},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type  = 36, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = 884.3005, y = -151.883, z = 69.385},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 147.21
	},

	VehicleDeleter = {
		Pos   = {x = 884.3005, y = -151.883, z = 69.385},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 255, g = 0, b = 0},
		Type  = 24, Rotate = false,
		Isheli = true
	},

	HeliSpawner = {
		Pos   = {x = 903.2264, y = -157.217, z = 83.007},
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 0, g = 255, b = 0},
		Type  = 34, Rotate = true,

	},

	HeliSpawnPoint = {
		Pos     = {x = 898.0644, y = -162.753, z = 85.103},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 329.89
	},

	HeliDeleter = {
		Pos   = {x = 898.0644, y = -162.753, z = 85.103},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 255, g = 0, b = 0},
		Type  = 24, Rotate = false,
		Isheli = true
	},

	TaxiActions = {
		Pos   = { x = 898.1614, y = -165.833, z = 74.222 },
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 31, Rotate = true
	},

	Armory = {
		Pos   = { x = 909.3887, y = -153.415, z = 74.222 },
		Size  = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 42, Rotate = true
	},

	Cloakroom = {
		Pos     = { x = 901.3662, y = -150.863, z = 75.318 },
		Size    = {x = 1.0, y = 1.0, z = 1.0},
		Color   = {r = 204, g = 204, b = 0},
		Type    = 21, Rotate = true
	},

	Blip = {
		Pos   = { x = 911.84, y = -178.08, z = 74.32 },
		Size  = {x = 0, y = 0, z = 0},
		Color = {r = 204, g = 204, b = 0},
	},
}

Config_taxi.hash = GetHashKey("cs_movpremmale")
Config_taxi.vehicleHash = -956048545
Config_taxi.Price = 500
Config_taxi.Speed = 30.0
Config_taxi.DriveMode = 262207
Config_taxi.SpawnBase = vector3(926.59, -192.94, 73.26)
Config_taxi.SpawnPoints = {
	DownTownCab = {x = 926.59, y = -192.94, z = 73.26, h = 326.35},
	AirPort = {x = -731.76, y = -2575.79, z = 13.83, h = 332.92},
	Ulsa = {x = -1612.60, y = 174.93, z = 59.80, h = 204.96},
	SandyShores = {x = 1771.84, y = 3660.44, z = 34.37, h = 30.81},
	SandyShores2 = {x = 2382.81, y = 5163.99, z = 49.12, h = 222.47},
	PaletoBay = {x = -125.29, y = 6287.95, z = 31.38, h = 313.97},
	MilitaryBase = {x = -2379.27, y = 3471.79, z = 24.46, h = 14.42},
	ZancudoRiver = {x = -447.34, y = 2866.06, z = 35.98, h = 127.48},
}

Config_taxi.JobLocations = {
	vector3(293.5, -590.2, 42.7),
	vector3(253.4, -375.9, 44.1),
	vector3(120.8, -300.4, 45.1),
	vector3(-38.4, -381.6, 38.3),
	vector3(-107.4, -614.4, 35.7),
	vector3(-252.3, -856.5, 30.6),
	vector3(-236.1, -988.4, 28.8),
	vector3(-277.0, -1061.2, 25.7),
	vector3(-576.5, -999.0, 21.8),
	vector3(-602.8, -952.6, 21.6),
	vector3(-790.7, -961.9, 14.9),
	vector3(-912.6, -864.8, 15.0),
	vector3(-1069.8, -792.5, 18.8),
	vector3(-1306.9, -854.1, 15.1),
	vector3(-1468.5, -681.4, 26.2),
	vector3(-1380.9, -452.7, 34.1),
	vector3(-1326.3, -394.8, 36.1),
	vector3(-1383.7, -270.0, 42.5),
	vector3(-1679.6, -457.3, 39.4),
	vector3(-1812.5, -416.9, 43.7),
	vector3(-2043.6, -268.3, 23.0),
	vector3(-2186.4, -421.6, 12.7),
	vector3(-1862.1, -586.5, 11.2),
	vector3(-1859.5, -617.6, 10.9),
	vector3(-1635.0, -988.3, 12.6),
	vector3(-1284.0, -1154.2, 5.3),
	vector3(-1126.5, -1338.1, 4.6),
	vector3(-867.9, -1159.7, 5.0),
	vector3(-847.5, -1141.4, 6.3),
	vector3(-722.6, -1144.6, 10.2),
	vector3(-575.5, -318.4, 34.5),
	vector3(-592.3, -224.9, 36.1),
	vector3(-559.6, -162.9, 37.8),
	vector3(-535.0, -65.7, 40.6),
	vector3(-758.2, -36.7, 37.3),
	vector3(-1375.9, 21.0, 53.2),
	vector3(-1320.3, -128.0, 48.1),
	vector3(-1285.7, 294.3, 64.5),
	vector3(-1245.7, 386.5, 75.1),
	vector3(-760.4, 285.0, 85.1),
	vector3(-626.8, 254.1, 81.1),
	vector3(-563.6, 268.0, 82.5),
	vector3(-486.8, 272.0, 82.8),
	vector3(88.3, 250.9, 108.2),
	vector3(234.1, 344.7, 105.0),
	vector3(435.0, 96.7, 99.2),
	vector3(482.6, -142.5, 58.2),
	vector3(762.7, -786.5, 25.9),
	vector3(809.1, -1290.8, 25.8),
	vector3(490.8, -1751.4, 28.1),
	vector3(432.4, -1856.1, 27.0),
	vector3(164.3, -1734.5, 28.9),
	vector3(-57.7, -1501.4, 31.1),
	vector3(52.2, -1566.7, 29.0),
	vector3(310.2, -1376.8, 31.4),
	vector3(182.0, -1332.8, 28.9),
	vector3(-74.6, -1100.6, 25.7),
	vector3(-887.0, -2187.5, 8.1),
	vector3(-749.6, -2296.6, 12.5),
	vector3(-1064.8, -2560.7, 19.7),
	vector3(-1033.4, -2730.2, 19.7),
	vector3(-1018.7, -2732.0, 13.3),
	vector3(797.4, -174.4, 72.7),
	vector3(508.2, -117.9, 60.8),
	vector3(159.5, -27.6, 67.4),
	vector3(-36.4, -106.9, 57.0),
	vector3(-355.8, -270.4, 33.0),
	vector3(-831.2, -76.9, 37.3),
	vector3(-1038.7, -214.6, 37.0),
	vector3(1918.4, 3691.4, 32.3),
	vector3(1820.2, 3697.1, 33.5),
	vector3(1619.3, 3827.2, 34.5),
	vector3(1418.6, 3602.2, 34.5),
	vector3(1944.9, 3856.3, 31.7),
	vector3(2285.3, 3839.4, 34.0),
	vector3(2760.9, 3387.8, 55.7),
	vector3(1952.8, 2627.7, 45.4),
	vector3(1051.4, 474.8, 93.7),
	vector3(866.4, 17.6, 78.7),
	vector3(319.0, 167.4, 103.3),
	vector3(88.8, 254.1, 108.2),
	vector3(-44.9, 70.4, 72.4),
	vector3(-115.5, 84.3, 70.8),
	vector3(-384.8, 226.9, 83.5),
	vector3(-578.7, 139.1, 61.3),
	vector3(-651.3, -584.9, 34.1),
	vector3(-571.8, -1195.6, 17.9),
	vector3(-1513.3, -670.0, 28.4),
	vector3(-1297.5, -654.9, 26.1),
	vector3(-1645.5, 144.6, 61.7),
	vector3(-1160.6, 744.4, 154.6),
	vector3(-798.1, 831.7, 204.4)
}

Config_taxi.AuthorizedItems = {
	{ name = 'water', price = 60 , label = 'Ab'},



	{ name = 'radio', price = 3000, label = 'Bisim' },
	{ name = 'phone', price = 2000, label = 'Goshi' },
	{ name = 'bread', price = 60, label = 'Noon' },

  }