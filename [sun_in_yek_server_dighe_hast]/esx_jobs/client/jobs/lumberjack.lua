-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config.Jobs.lumberjack = {
	pic = 'https://cdn.sunrp.ir/jobs/15.png',
	BlipInfos = {
		Sprite = 237,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "phantom",
			Trailer = "trailers",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = vec(1200.63, -1276.87, 34.38),
			Size = vec(3.0, 3.0, 1.0, 19),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("lj_locker_room"),
			Type = "cloakroom"
		},

		Wood = {
			Pos = vec(-528.61, 5378.19, 70.31),
			Size = vec(12.0, 12.0, 1.0, 25),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("lj_mapblip"),
			Type = "work",
			Item = {
				{
					name = "Choob",
					db_name = "wood",
					time = 16000,
					max = 100,
					add = 20,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("lj_pickup")
		},

		CuttedWood = {
			Pos = vec(-553.49, 5324.41, 73.6),
			Size = vec(7.5, 7.5, 1.0, 25),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("lj_cutwood"),
			Type = "work",
			Item = {
				{
					name = "Alvar",
					db_name = "cutted_wood",
					time = 40000,
					max = 100,
					add = 20,
					remove = 20,
					requires = "wood",
					requires_name = "Choob",
					drop = 100
				}
			},
			Hint = _U("lj_cutwood_button")
		},

		Planks = {
			Pos = vec(-501.05, 5285.01, 80.61),
			Size = vec(12.0, 12.0, 2.0, 25),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("lj_board"),
			Type = "work",
			Item = {
				{
					name = "Basteye Alvar",
					db_name = "packaged_plank",
					time = 50000,
					max = 20,
					add = 10,
					remove = 50,
					requires = "cutted_wood",
					requires_name = "Alvar",
					drop = 100
				}
			},
			Hint = _U("lj_pick_boards")
		},

		VehicleSpawner = {
			Pos = vec(1191.96, -1261.77, 35.17),
			Size = vec(3.0, 3.0, 2.0, 30),
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
			Pos = vec(1194.62, -1286.95, 35.12),
			Size = vec(3.0, 3.0, 1.0, 19),
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 264.40
		},

		VehicleDeletePoint = {
			Pos = vec(1221.19, -1289.32, 35.22),
			Size = vec(5.0, 5.0, 1.0, 15),
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
