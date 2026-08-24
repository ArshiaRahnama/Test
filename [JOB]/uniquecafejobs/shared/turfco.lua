--[[
	Turf Wars Inc. - rents out one of the EXISTING paintball resource's maps
	to a specific gang for a set number of minutes. While rented, only that
	gang can host a lobby on that map (enforced in the paintball resource's
	own CreateLobby via an export - see server/turfco_server.lua).

	Map names below are copied straight from [ARSHIA]/paintball's own
	MapData table - keep this list in sync if maps are added/removed there.
]]

TurfCo = {
	Job     = 'turfco',
	Society = 'turfco',
	Label   = 'Holding 2',

	HQ = { x = 2565.0, y = 2585.0, z = 37.9 }, -- Grand Senora desert area (placeholder)
	Blip = { Sprite = 84, Color = 5, Scale = 1.0 },

	BossAction = { Pos = { x = 2565.0, y = 2585.0, z = 37.9 }, Name = 'Rent Paintball Map', Icon = 'fa-solid fa-flag' },
	CloackRoom = { Pos = { x = 2569.0, y = 2585.0, z = 37.9 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

	SpawnVehicle = 'sandking',
	SpawnMarker  = { x = 2578.0, y = 2585.0, z = 37.9 },
	SpawnPoint   = { x = 2588.0, y = 2579.0, z = 37.0,  w = 90.0 },
	DeleteMarker = { x = 2583.0, y = 2580.0, z = 37.9 },

	-- Same map keys as [ARSHIA]/paintball's MapData table.
	Maps = { 'bank', 'bimeh', 'cargo', 'skyscraper', 'island', 'javaheri', 'shop1', 'shop2', 'jail', '1v1' },

	RentCostPerMinute = 500, -- what the renting gang pays Turf Wars, per minute requested
	MaxRentMinutes    = 120,
}
