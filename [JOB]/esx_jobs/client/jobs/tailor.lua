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

Config.Jobs.tailor = {
	JobName = 'tailor',

	BlipInfos = {
		Sprite = 366,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = "youga2",
			Trailer = "none",
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 706.73, y = -960.90, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_dress_locker"),
			Type = "cloakroom",
			Hint = _U("cloak_change"),
			GPS = {x = 740.80, y = -970.06, z = 23.46}
		},

		Wool = {
			Pos = {x = 1978.92, y = 5171.70, z = 46.63},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("dd_wool"),
			Type = "work",
			Item = {
				{
					name = _U("dd_wool"),
					db_name = "wool",
					time = GettimeSkill("Lebas", 5000),
					max = 80,
					add = 5,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 80
				}
			},
			Hint = _U("dd_pickup"),
			GPS = {x = 715.95, y = -959.63, z = 29.39}
		},

		Fabric = {
			Pos = {x = 715.95, y = -959.63, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("dd_fabric"),
			Type = "work",
			Item = {
				{
					name = _U("dd_fabric"),
					db_name = "fabric",
					time = GettimeSkill("Lebas", 5000),
					max = 20,
					add = 1,
					remove = 4,
					requires = "wool",
					requires_name = _U("dd_wool"),
					drop = 20
				}
			},
			Hint = _U("dd_makefabric"),
			GPS = {x = 712.92, y = -970.58, z = 29.39}
		},

		Clothe = {
			Pos = {x = 712.92, y = -970.58, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("dd_clothing"),
			Type = "work",
			Item = {
				{
					name = _U("dd_clothing"),
					db_name = "clothe",
					time = GettimeSkill("Lebas", 4000),
					max = 10,
					add = 1,
					remove = 2,
					requires = "fabric",
					requires_name = _U("dd_fabric"),
					drop = 10
				}
			},
			Hint = _U("dd_makeclothing"),
			GPS = {x = 429.59, y = -807.34, z = 28.49}
		},

		VehicleSpawner = {
			Pos = {x = 740.80, y = -970.06, z = 23.46},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("spawn_veh"),
			Type = "vehspawner",
			Spawner = 1,
			Hint = _U("spawn_veh_button"),
			Caution = 50000,
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		},

		VehicleSpawnPoint = {
			Pos = {x = 747.31, y = -966.23, z = 23.70},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 270.1,
			GPS = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 693.79, y = -963.01, z = 22.82},
			Size = {x = 3.0, y = 3.0, z = 1.0},
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
