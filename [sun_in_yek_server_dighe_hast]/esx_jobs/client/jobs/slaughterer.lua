-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config.Jobs.slaughterer = {
	pic = 'https://cdn.sunrp.ir/jobs/16.png',
	BlipInfos = {
		Sprite = 256,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "benson",
			Trailer = "none",
			HasCaution = true
		}
	},

	Zones = {

		CloakRoom = {
			Pos = vec(-1071.13, -2003.78, 14.78),
			Size = vec(3.0, 3.0, 1.0, 9),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("s_slaughter_locker"),
			Type = "cloakroom"
		},

		AliveChicken = {
			Pos = vec(-64.08, 6238.36, 31.09),
			Size = vec(8.0, 8.0, 1.0, 10),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("s_hen"),
			Type = "work",
			Item = {
				{
					name = "Morgh zende",
					db_name = "alive_chicken",
					time = 50000,
					max = 20,
					add = 10,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("s_catch_hen")
		},

		SlaughterHouse = {
			Pos = vec(-85.5, 6234.27, 31.09),
			Size = vec(8.0, 8.0, 1.0, 10),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = false,
			Name = _U("s_slaughtered"),
			Type = "work",
			Item = {
				{
					name = "Morgh",
					db_name = "slaughtered_chicken",
					time = 50000,
					max = 20,
					add = 10,
					remove = 10,
					requires = "alive_chicken",
					requires_name = "Morgh zende",
					drop = 100
				}
			},
			Hint = _U("s_chop_animal")
		},

		Packaging = {
			Pos = vec(-105.5, 6204.93, 31.03),
			Size = vec(8.0, 8.0, 1.0, 10),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = false,
			Name = _U("s_package"),
			Type = "work",
			Item = {
				{
					name = "Basteye Morgh",
					db_name = "packaged_chicken",
					time = 50000,
					max = 100,
					add = 50,
					remove = 10,
					requires = "slaughtered_chicken",
					requires_name = "Morgh",
					drop = 100
				}
			},
			Hint = _U("s_unpackaged_button")
		},

		VehicleSpawner = {
			Pos = vec(-1043.6, -2020.82, 13.16),
			Size = vec(3.0, 3.0, 1.0, 12),
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
			Pos = vec(-1048.85, -2025.32, 13.16),
			Size = vec(3.0, 3.0, 1.0, 9),
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 130.1
		},

		VehicleDeletePoint = {
			Pos = vec(-1061.51, -2008.35, 13.16),
			Size = vec(5.0, 5.0, 1.0, 12),
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
