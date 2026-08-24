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

Config.Jobs.slaughterer = {
	JobName = 'slaughterer',
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
			Pos = {x = -1071.13, y = -2003.78, z = 14.78},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("s_slaughter_locker"),
			Type = "cloakroom",
			Hint = _U("cloak_change")
		},

		AliveChicken = {
			Pos = {x = -62.90, y = 6241.46, z = 30.09},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U("s_hen"),
			Type = "work",
			Item = {
				{
					name = _U("s_alive_chicken"),
					db_name = "alive_chicken",
					time = GettimeSkill("Ghasab", 5000),
					max = 20,
					add = 1,
					remove = 1,
					requires = "nothing",
					requires_name = "Nothing",
					drop = 20
				}
			},
			Hint = _U("s_catch_hen")
		},

		SlaughterHouse = {
			Pos = {x = -77.99, y = 6229.06, z = 30.09},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("s_slaughtered"),
			Type = "work",
			Item = {
				{
					name = _U("s_slaughtered_chicken"),
					db_name = "slaughtered_chicken",
					time = GettimeSkill("Ghasab", 5000),
					max = 20,
					add = 1,
					remove = 1,
					requires = "alive_chicken",
					requires_name = _U("s_alive_chicken"),
					drop = 20
				}
			},
			Hint = _U("s_chop_animal")
		},

		Packaging = {
			Pos = {x = -101.97, y = 6208.79, z = 30.02},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U("s_package"),
			Type = "work",
			Item = {
				{
					name = _U("s_packagechicken"),
					db_name = "packaged_chicken",
					time = GettimeSkill("Ghasab", 5000),
					max = 100,
					add = 5,
					remove = 1,
					requires = "slaughtered_chicken",
					requires_name = _U("s_unpackaged"),
					drop = 100
				}
			},
			Hint = _U("s_unpackaged_button")
		},

		VehicleSpawner = {
			Pos = {x = -1042.94, y = -2023.25, z = 12.16},
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
			Pos = {x = -1048.85, y = -2025.32, z = 12.16},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U("service_vh"),
			Type = "vehspawnpt",
			Spawner = 1,
			Heading = 130.1
		},

		VehicleDeletePoint = {
			Pos = {x = -1061.51, y = -2008.35, z = 12.16},
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
