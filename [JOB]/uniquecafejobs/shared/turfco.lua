--[[
	Turf Wars Inc. (Gang 2).

	Paintball maps are rented for TurfCo.RentDays days, one gang per map. The
	customer pays TurfCo.RentPrice from their bank; the money goes to society_turfco.
	While rented, only that gang can host a lobby on the map (paintball resource
	checks GetMapReservation before CreateLobby).

	Map names and area centers are copied from [ARSHIA]/paintball's MapData.
	'jail' and 'island' are not rentable: that resource blocks them (no verified data).
]]

TurfCo = {
	Job     = 'turfco',
	Society = 'turfco',
	Label   = 'Gang 2',

	HQ = { x = 2565.0, y = 2585.0, z = 37.9 },
	Blip = { Sprite = 84, Color = 5, Scale = 1.0 },

	BossAction = { Pos = { x = 2565.0, y = 2585.0, z = 37.9 }, Name = 'Turf Wars Boss', Icon = 'fa-solid fa-flag' },
	CloackRoom = { Pos = { x = 2569.0, y = 2585.0, z = 37.9 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

	SpawnVehicle = 'sandking',
	SpawnMarker  = { x = 2578.0, y = 2585.0, z = 37.9 },
	SpawnPoint   = { x = 2588.0, y = 2579.0, z = 37.0, w = 90.0 },
	DeleteMarker = { x = 2583.0, y = 2580.0, z = 37.9 },

	Maps = { 'bank', 'bimeh', 'cargo', 'skyscraper', 'javaheri', 'shop1', 'shop2', '1v1' },
	MapPoints = {
		bank       = { x = 249.33,   y = 217.76,  z = 100.29 },
		bimeh      = { x = -1075.87, y = -243.6,  z = 30.02 },
		cargo      = { x = -1076.06, y = 4912.23, z = 150.97 },
		skyscraper = { x = -156.88,  y = -987.02, z = 254.13 },
		javaheri   = { x = -623.36,  y = -231.63, z = 30.06 },
		shop1      = { x = 28.88,    y = -1345.42, z = 20.5 },
		shop2      = { x = -1221.6,  y = -911.33,  z = 5.33 },
		['1v1']    = { x = -2087.34, y = 3118.99,  z = 15.71 },
	},

	RentDays  = 30,
	RentPrice = 150000,

	CollectCooldownMins = 30,
}
