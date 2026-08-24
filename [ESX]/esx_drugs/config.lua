Config = {}

Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 1.0, y = 1.0, z = -1.0}
Config.MarkerColor  = {r = 100, g = 204, b = 100}
Config.ShowBlips	= true
Config.ShowMarkers 	= false
Config.MultiPlant	= false

Config.GiveBlack 	= false
Config.EnableCops   = true
Config.UseESXPhone	= false
Config.UseGCPhone	= true
Config.RequireCops	= true
Config.RequiredCopsCoke  = 1
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 1
Config.RequiredCopsOpium = 1
Config.RequiredCopsHerin = 1
Config.RequiredCopsCrack = 1

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 10,
	CocaineProcessing = 2000 * 10,
	EphedrineProcessing = 2000 * 10,
	MethProcessing = 2000 * 10,
	PoppyProcessing = 2000 * 10,
	CrackProcessing = 2000 * 10,
	HeroineProcessing = 1000 * 10,
	MushroomProcessing = 2000 * 10,
}

Config.FieldZones = {
	WeedField = {coords = vector3(2224.2, 5566.53, 54.06), name = 'Zamin Shah Dane',color = 25, sprite = 496, radius = 1.0},
	CocaineField = {coords = vector3(1849.8, 4914.2, 44.92), name = 'Zamin Cocaine' ,color = 4, sprite = 496, radius = 1.0},
	EphedrineField = {coords = vector3(1591.18, -1982.81, 95.12), name = 'Zamin Ephedrine',color = 62, sprite = 496, radius = 1.0},
	PoppyField = {coords = vector3(-1800.83, 1990.43, 132.71), name = 'Zamin Khash-Khaash',color = 38, sprite = 496, radius = 1.0},
	MushroomField = {coords = vector3(33.88, 4347.98, 41.62), name = 'Zamin Mushroom' ,color = 4, sprite = 496, radius = 1.0},
}

Config.ProcessZones = {
	WeedProcessing = {coords = vector3(2329.02, 2571.29, 46.68), name = 'Laboratory Marijuana', color = 25, sprite = 496, radius = 1.0},
	CocaineProcessing = {coords = vector3(-2083.58, -1011.96, 5.88), name = 'Laboratory Cocaine', color = 4, sprite = 455, radius = 1.0},
	EphedrineProcessing = {coords = vector3(-1078.62, -1679.62, 4.58), name = 'Laboratory Ephedrine', color = 62, sprite = 310, radius = 1.0},
	MethProcessing = {coords = vector3(1391.94, 3605.94, 38.94), name = 'Laboratory Shishe', color = 25, sprite = 93, radius = 1.0},
	CrackProcessing = {coords = vector3(974.72, -100.91, 74.87), name = 'Laboratory Crack', color = 72, sprite = 226, radius = 1.0},
	PoppyProcessing ={coords = vector3(3559.76, 3674.54, 28.12), name = 'Laboratory Teryak', color = 38, sprite = 499, radius = 1.0},
	HeroineProcessing = {coords = vector3(1789.671, 3896.110, 34.389), name = 'Laboratory Heroine', color = 59, sprite = 388, radius = 1.0},
}

Config.Peds = {
	WeedProcess =		{ ped = -264140789, x = 2328.29, y = 2569.61,	z = 45.68, 	h = 325.04 },
	CokeProcess =		{ ped = -264140789, x = -2084.48, y = -1011.68,	z = 4.88,	h = 252.42 },
	EphedrineProcess =	{ ped = 516505552, x = -1079.49, y = -1679.92,	z = 3.58,	h = 181.96 },

	OpiumProcess =		{ ped = -730659924, x = 3559.03, y = 3674.78,	z = 27.12,	h = 224.32 },
	CrackProcess =		{ ped = -264140789, x = 973.68, y = -100.35,	z = 73.85,	h = 277.73 },
}

Config.MarkerSize   = {x = 2.5, y = 2.5, z = 1.0}

Config.Locations = {
	{ x = -2083.25, y = -1012.14, z = 5.0},
	{ x = -2084.32, y = -1013.68, z = 5.0},
	{ x = 2329.02, y = 2571.29, z = 45.75},
	{ x = -1078.62, y = -1679.62, z = 3.60},
	{ x = 3559.76, y = 3674.54, z = 27.20},
	{ x = 1789.823, y = 3896.140, z = 33.389},
	{ x = 1391.94, y = 3605.94, z = 38.00}

}

Config.Zones = {}

Config.CircleZones = {

}

for i=1, #Config.Locations, 1 do
	Config.Zones['drug_' .. i] = {
		Pos   = Config.Locations[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
