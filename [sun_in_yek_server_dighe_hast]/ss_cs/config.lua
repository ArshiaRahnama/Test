-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {}
Config.Locale = 'en' -- Language

Config.ServiceExtensionOnEscape = 8 -- Escape Extension
Config.DistanceExtension =  50.0    -- 36.0 -- Escape Distance           

-- Service Location
Config.ServiceLocation = {x = -3451.93, y = -3464.14, z = 462.35} -- {x = 1731.39, y = 2530.18, z = 45.56}           --                   50
-- Release Location
Config.ReleaseLocation = {x = -255.97, y = -973.38, z = 31.22}

Config.pedLocation = {
	vec(-3460.57, -3484.77, 462.35),
	vec(-3468.69, -3473.04, 462.35),
	vec(-3465.0, -3457.78, 462.35),
	vec(-3447.82, -3452.46, 462.35),
	vec(-3430.84, -3460.88, 462.35),
}
-- Service Locations
Config.ServiceLocations = {
	-- cs new
	{ type = "cleaning",  coords = vec(-3452.16, -3463.98, 462.35) },
	{ type = "gardening", coords = vec(-3464.69, -3454.7, 462.35)  },
	{ type = "gardening", coords = vec(-3453.37, -3449.99, 462.35) },
	{ type = "gardening", coords = vec(-3442.36, -3452.83, 462.35) },
	{ type = "gardening", coords = vec(-3436.78, -3462.72, 462.35) },
	{ type = "gardening", coords = vec(-3440.14, -3474.35, 462.35) },
	{ type = "gardening", coords = vec(-3450.22, -3478.91, 462.35) },
	{ type = "gardening", coords = vec(-3460.11, -3474.59, 462.35) },
	{ type = "gardening", coords = vec(-3465.83, -3465.46, 462.35) },
}

-- Uniforms
-- Config.Uniforms = {
-- 	prison_wear = {
-- 		male = {
-- 			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
-- 			['torso_1']  = 324, ['torso_2']  = 0,
-- 			['decals_1'] = 0,   ['decals_2'] = 0,
-- 			['arms']     = 82, 	['pants_1']  = 36,
-- 			['pants_2']  = 0,   ['shoes_1']  = 57,
-- 			['shoes_2']  = 0,  ['chain_1']  = 0,
-- 			['chain_2']  = 0
-- 		},
-- 		female = {
-- 			['tshirt_1'] = 15,  ['tshirt_2'] = 3,
-- 			['torso_1']  = 0,  	['torso_2']  = 0,
-- 			['decals_1'] = 0,   ['decals_2'] = 0,
-- 			['arms']     = 85,  ['pants_1']  = 3,
-- 			['pants_2']  = 15,  ['shoes_1']  = 16,
-- 			['shoes_2']  = 0, 	['chain_1']  = 0,
-- 			['chain_2']  = 0
-- 		}
-- 	}
-- }

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

Config.offense = {
	{
		key = 'kos',
		label = 'Naghze Ghavanin K.O.S',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 400, 500 }
	},
	{
		key = 'vdm',
		label = 'VDM',
		expire = 30, min = 50,
		counts = { 100, 200, 250, 300, 500 }
	},
	{
		key = 'ncz',
		label = 'Naghze Ghavanin NCZ',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 400, 500 }
	},
	{
		key = 'meta',
		label = 'Meta Gaming',
		expire = 30, min = 150,
		counts = { 200, 300, 350, 500 }
	},
	{
		key = 'mix',
		label = 'Mix IC & OC',
		expire = 60, min = 0,
		counts = { 0, 25, 75, 150, 200, 300, 500 }
	},
	{
		key = 'cl',
		label = 'Combat Log',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 400, 500 }
	},
	{
		key = 'frp',
		label = 'Fear Rp',
		expire = 30, min = 50,
		counts = { 100, 200, 250, 300, 350, 500 }
	},
	{
		key = 'pg',
		label = 'Power Gaming',
		expire = 30, min = 50,
		counts = { 100, 200, 250, 300, 350, 500 }
	},
	{
		key = 'cb',
		label = 'Cop Baiting',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 400, 500 }
	},
	{
		key = 'mercy',
		label = 'Mercy Killing',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300, 400, 500 }
	},
	{
		key = 'trolkil',
		label = 'Troll Kill',
		expire = 60, min = 50,
		counts = { 100, 200, 500 }
	},
	{
		key = 'nlr',
		label = 'Naghze Ghavanin NewLife',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300, 400, 500 }
	},
	{
		key = 'sexrp',
		label = 'Sexual RP',
		expire = 360, min = 100,
		counts = { 150, 300, 500 }
	},
	{
		key = 'khpd',
		label = 'Naghze Ghavanin TireAndazi be PD',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 350, 500 }
	},
	{
		key = 'jab',
		label = 'Job Abuse',
		expire = 30, min = 50,
		counts = { 100, 200, 300, 350, 500 }
	},
	{
		key = 'nrob',
		label = 'Naghze Ghavanin Robbery',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300, 350, 500 }
	},
	{
		key = 'srch',
		label = 'Naghze Ghavanin Search',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300, 350, 500 }
	},
	{
		key = 'faha',
		label = 'Fahashi Type A',
		expire = 360, min = 150,
		counts = { 200, 250, 300, 400, 500, 600, 1000 }
	},
	{
		key = 'fahb',
		label = 'Fahashi Type B',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300, 350, 400, 500 }
	},
	{
		key = 'fahc',
		label = 'Fahashi Type C',
		expire = 360, min = 150,
		counts = { 200, 250, 300, 400, 500, 600, 1000 }
	},
	{
		key = 'rajaz',
		label = 'Rajaz Khani',
		expire = 60, min = 0,
		counts = { 50, 150, 200, 250, 300, 500 }
	},
	{
		key = 'nbug',
		label = 'Bug Abuse',
		expire = 360, min = 100,
		counts = { 150, 300, 500, 1000 }
	},
	{
		key = 'mbug',
		label = 'Mic Abuse',
		expire = 60, min = 0,
		counts = { 50, 200, 300, 500 }
	},
	{
		key = 'rbim',
		label = 'Report Bimored',
		expire = 60, min = 0,
		counts = { 0, 200, 300, 400, 500, 1000 }
	},
	{
		key = 'nheli',
		label = 'Naghze Ghavanin Heli',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300 }
	},
	{
		key = 'nertebat',
		label = 'Naghze Ghavanin Ertebatat',
		expire = 90, min = 0,
		counts = { 0, 150, 200, 250 }
	},
	{
		key = 'nkheft',
		label = 'Naghze Ghavanin Kheft Giri',
		expire = 30, min = 50,
		counts = { 100, 150, 200, 250 }
	},
	{
		key = 'hfbi',
		label = 'Hokme FBI',
		expire = 30, min = 25,
		counts = { 50 }
	},
	{
		key = 'tbeorgan',
		label = 'Tohin Be Organ Dolati',
		expire = 60, min = 25,
		counts = { 50, 100, 150, 200 }
	},
	{
		key = 'nfollow',
		label = 'Naghze ghvanin Follow Rp',
		expire = 30, min = 150,
		counts = { 200, 250, 300, 500 }
	},
	{
		key = 'dekhalat',
		label = 'Dekhalat dar Rp',
		expire = 60, min = 150,
		counts = { 150, 250, 300, 500 }
	},
	{
		key = 'nsafez',
		label = 'Naghze Ghavanin SafeZone',
		expire = 30, min = 100,
		counts = { 150, 200, 250, 300 }
	},
	{
		key = 'vdmabuse',
		label = 'Vdm Abuse System',
		expire = 30, min = 0,
		counts = { 250, 500, 1000 }
	},
	{
		key = 'nooc',
		label = 'Naghze Ghavanin OOC',
		expire = 60, min = 0,
		counts = { 0, 100, 150, 200 }
	},
	{
		key = 'ness',
		label = 'Naghze Ghavanin /S',
		expire = 60, min = 0,
		counts = { 0, 100, 150, 200 }
	},
	{
		key = 'nmedo',
		label = 'Naghze Ghavanin /ME & /DO',
		expire = 60, min = 0,
		counts = { 0, 100, 150, 200 }
	},
	{
		key = 'nrpp',
		label = 'Naghze Ghavanin RP Pause',
		expire = 30, min = 150,
		counts = { 200, 300, 500 }
	},
	{
		key = 'ndm',
		label = 'Death Match',
		expire = 30, min = 200,
		counts = { 300, 500, 1000 }
	},
	{
		key = 'ngcuf',
		label = 'Naghz Ghavanin Cuff',
		expire = 30, min = 50,
		counts = { 75, 150, 200 }
	},
	{
		key = 'ncamp',
		label = 'Camp Va Dargiri Atrafe Base',
		expire = 90, min = 200,
		counts = { 300, 300, 500 }
	},
	{
		key = 'tamkin',
		label = 'peyravi nakardan az dastoore admin',
		expire = 30, min = 150,
		counts = { 200, 300, 500 }
	},
	{
		key = 'scamncz',
		label = 'SCAMER',
		expire = 360, min = 0,
		counts = { 0, 0, 0 }
	},
	{
		key = 'fbiwarn',
		label = 'FBI Warn',
		expire = 30, min = 0,
		counts = { 0, 0, 0 }
	},
	{
		key = 'fbistri',
		label = 'FBI Strikes',
		expire = 60, min = 0,
		counts = { 0, 0, 0 }
	},

}