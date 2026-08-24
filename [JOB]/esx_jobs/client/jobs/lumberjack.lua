ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function GettimeSkill(name, time)

	local ChekSkills = 0
	if GetResourceState('Unique_Skills') == 'started' then
		local ok, result = pcall(function() return exports['Unique_Skills']:CheckSkill(name) end)
		if ok then ChekSkills = result end
	end
	if ChekSkills == 100 then
		local time2 = tonumber(time) / 2
		return time2
	else
		return time
	end
end

Config.Jobs.lumberjack = {
	JobName = 'lumberjack',
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
			Pos = {x = 1200.63, y = -1276.87, z = 34.38},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("lj_locker_room"),
			Type = "cloakroom",
			Hint = _U("cloak_change")
		},

		Wood = {
			Pos = {x = -534.32, y = 5373.79, z = 69.50},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("lj_mapblip"),
			Type = "work",
			Item = {
				{
					name = _U("lj_wood"),
					db_name = "wood",
					time = GettimeSkill("ChoobBori", 4000),
					max = 100,
					add = 5,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 100
				}
			},
			Hint = _U("lj_pickup")
		},

		CuttedWood = {
			Pos = {x = -552.21, y = 5326.90, z = 72.59},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("lj_cutwood"),
			Type = "work",
			Item = {
				{
					name = _U("lj_cutwood"),
					db_name = "cutted_wood",
					time = GettimeSkill("ChoobBori", 7000),
					max = 100,
					add = 1,
					remove = 1,
					requires = "wood",
					requires_name = _U("lj_wood"),
					drop = 100
				}
			},
			Hint = _U("lj_cutwood_button")
		},

		Planks = {
			Pos = {x = -501.38, y = 5280.53, z = 79.61},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("lj_board"),
			Type = "work",
			Item = {
				{
					name = _U("lj_planks"),
					db_name = "packaged_plank",
					time = GettimeSkill("ChoobBori", 5000),
					max = 20,
					add = 1,
					remove = 5,
					requires = "cutted_wood",
					requires_name = _U("lj_cutwood"),
					drop = 20
				}
			},
			Hint = _U("lj_pick_boards")
		},

		VehicleSpawner = {
			Pos = {x = 1191.96, y = -1261.77, z = 34.17},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_veh_button"),
			Caution = 50000
		},

		VehicleSpawnPoint = {
			Pos = {x = 1194.62, y = -1286.95, z = 34.12},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 264.40
		},

		VehicleDeletePoint = {
			Pos = {x = 1217.392, y = -1289.31, z = 34.224},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("return_vh"),
			Type = "vehdelete",
			Hint = _U("return_vh_button"),
			Spawner = 1,
			Caution = 50000,
			GPS = 0,
			Teleport = 0
		},

























	}
}