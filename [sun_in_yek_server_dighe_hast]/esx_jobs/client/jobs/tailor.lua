-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config.Jobs.tailor = {
	pic = 'https://cdn.sunrp.ir/jobs/17.png',
	BlipInfos = {
		Sprite = 366,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "pony2",
			Trailer = "none",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = vec(706.73, -960.90, 29.39),
			Size = vec(3.0, 3.0, 1.0, 5),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("dd_dress_locker"),
			Type = "cloakroom"
		},

		Wool = {
			Pos = vec(1978.92, 5171.70, 47.63),
			Size = vec(8.0, 8.0, 0.5, 19),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("dd_wool"),
			Type = "work",
			Item = {
				{
					name = "Pashm",
					db_name = "wool",
					time = 40000,
					max = 80,
					add = 20,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("dd_pickup")
		},

		Fabric = {
			Pos = vec(717.83, -960.78, 30.4),
			Size = vec(8.0, 8.0, 1.0, 6),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = false,
			Name = _U("dd_fabric"),
			Type = "work",
			Item = {
				{
					name = "Parche",
					db_name = "fabric",
					time = 50000,
					max = 20,
					add = 10,
					remove = 40,
					requires = "wool",
					requires_name = "Pashm",
					drop = 100
				}
			},
			Hint = _U("dd_makefabric")
		},

		Clothe = {
			Pos = vec(712.28, -972.33, 30.4),
			Size = vec(7.5, 7.5, 1.0, 6),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = false,
			Name = _U("dd_clothing"),
			Type = "work",
			Item = {
				{
					name = "Lebas",
					db_name = "clothe",
					time = 25000,
					max = 10,
					add = 5,
					remove = 10,
					requires = "fabric",
					requires_name = "Parche",
					drop = 100
				}
			},
			Hint = _U("dd_makeclothing")
		},

		VehicleSpawner = {
			Pos = vec(740.80, -970.06, 24.46),
			Size = vec(3.0, 3.0, 2.0, 20),
			Color = {r = 0, g = 200, b = 80},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_veh_button"),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = vec(747.31, -966.23, 24.70),
			Size = vec(3.0, 3.0, 1.0, 19),
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 270.1
		},

		VehicleDeletePoint = {
			Pos = vec(689.75, -966.39, 23.52),
			Size = vec(8.0, 8.0, 1.0, 20),
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("return_vh"),
			Type = "vehdelete",
			Hint = _U("return_vh_button"),
			Spawner = 1,
			Caution = 2000
		}
	}
}
