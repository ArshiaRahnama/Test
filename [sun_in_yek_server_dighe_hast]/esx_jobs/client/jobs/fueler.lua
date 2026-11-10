-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config.Jobs.fueler = {
	pic = 'https://cdn.sunrp.ir/jobs/14.png',
	BlipInfos = {
		Sprite = 436,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "phantom",
			Trailer = "tanker",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = vec(557.93, -2327.90, 4.82),
			Size = vec(3.0, 3.0, 2.0, 19),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("f_oil_refiner"),
			Type = "cloakroom"
		},

		OilFarm = {
			Pos = vec(609.58, 2856.74, 39.90),
			Size = vec(20.0, 20.0, 1.0, 30),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("f_drill_oil"),
			Type = "work",
			Item = {
				{
					name = "Benzin",
					db_name = "petrol",
					time = 15000,
					max = 25,
					add = 5,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("f_drillbutton")
		},

		OilRefinement = {
			Pos = vec(2736.94, 1417.99, 24.48),
			Size = vec(10.0, 10.0, 1.0, 19),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("f_fuel_refine"),
			Type = "work",
			Item = {
				{
					name = "Rafin",
					db_name = "petrol_raffin",
					time = 15000,
					max = 50,
					add = 10,
					remove = 5,
					requires = "petrol",
					requires_name = "Benzin",
					drop = 100
				}
			},
			Hint = _U("f_refine_fuel_button")
		},

		OilMix = {
			Pos = vec(265.75, -3013.39, 5.73),
			Size = vec(10.0, 10.0, 1.0, 19),
			Color = {r = 0, g = 180, b = 255},
			Marker = 1,
			Blip = true,
			Name = _U("f_fuel_mixture"),
			Type = "work",
			Item = {
				{
					name = "Asans",
					db_name = "essence",
					time = 30000,
					max = 100,
					add = 20,
					remove = 10,
					requires = "petrol_raffin",
					requires_name = "Rafin",
					drop = 100
				}
			},
			Hint = _U("f_fuel_mixture_button")
		},

		VehicleSpawner = {
			Pos = vec(554.59, -2314.43, 5.86),
			Size = vec(3.0, 3.0, 2.0, 19),
			Color = {r = 0, g = 200, b = 80},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_truck_button"),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = vec(570.54, -2309.70, 5.90),
			Size = vec(3.0, 3.0, 1.0, 19),
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 0
		},

		VehicleDeletePoint = {
			Pos = vec(536.79, -2282.96, 5.99),
			Size = vec(5.0, 5.0, 2.0, 30),
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
