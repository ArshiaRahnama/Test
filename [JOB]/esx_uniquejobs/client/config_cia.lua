Config_cia = {}

Config_cia.DrawDistance 			  = 10.0
Config_cia.MarkerType    			  = 21
Config_cia.MarkerSize   			  = { x = 1.5, y = 1.5, z = 1.0 }
Config_cia.MarkerColor                = { r = 255, g = 255, b = 255 }
Config_cia.MarkerDeletersColor        = { r = 255, g = 0, b = 0 }

Config_cia.EnablePlayerManagement     = true
Config_cia.EnableArmoryManagement     = true
Config_cia.EnableESXIdentity          = false
Config_cia.EnableSocietyOwnedVehicles = false
Config_cia.EnableLicenses             = true

Config_cia.EnableHandcuffTimer        = false
Config_cia.HandcuffTimer              = 10 * 60000

Config_cia.EnableJobBlip              = true
Config_cia.EnablePoliceFine           = true

Config_cia.MaxInService               = -1
Config_cia.Locale = 'en'

Config_cia.ciaStations = {

	cia = {

		Blip = {
			Pos     = { x = 115.08, y = -748.52, z = 45.76 },
			Sprite  = 88,
			Display = 4,
			Scale   = 0.8,
			Colour  = 38,
		},

		AuthorizedWeapons = {
			{ name = 'WEAPON_BZGAS', price = 5000 },
			{ name = 'WEAPON_STUNGUN', price = 5000 },
			{ name = 'WEAPON_NIGHTSTICK', price = 5000 },
			{ name = 'WEAPON_FLASHLIGHT', price = 5000 },
			{ name = 'WEAPON_PISTOL', price = 10000 },
			{ name = 'WEAPON_COMBATPISTOL', price = 10000 },
			{ name = 'WEAPON_PISTOL50', price = 10000 },
			{ name = 'WEAPON_HEAVYPISTOL', price = 10000 },
			{ name = 'WEAPON_SMG', price = 12000 },
			{ name = 'WEAPON_ASSAULTSMG', price = 12000 },
			{ name = 'WEAPON_CARBINERIFLE', price = 12000 },
			{ name = 'WEAPON_COMBATPDW', price = 12000 },
			{ name = 'WEAPON_PUMPSHOTGUN', price = 13000 },
			{ name = 'WEAPON_ASSAULTSHOTGUN', price = 13000 },
			{ name = 'WEAPON_BULLPUPSHOTGUN', price = 13000 },
			{ name = 'WEAPON_ADVANCEDRIFLE', price = 14000 },
			{ name = 'WEAPON_BULLPUPRIFLE', price = 14000 },
			{ name = 'WEAPON_ASSAULTRIFLE', price = 14000 },
			{ name = 'WEAPON_GUSENBERG', price = 14000 },

		},

		Cloakrooms = {
			{ x = 151.85, y = -736.28, z = 242.15 }
		},

		Armories = {
			{ x = 144.61, y = -761.63, z = 242.15 }

		},

		Vehicles = {
			{
			Spawner    = {x = 70.86228, y = -725.832, z = 44.220},
			SpawnPoints = { x = 64.72499, y = -723.952, z = 44.102, heading = 339.89, radius = 6.0 },



			},
		},

		Heli = {
			{
			Spawner    = {x = 146.8774, y = -744.862, z = 262.86},
			SpawnPoints = {x = 149.6619, y = -753.588, z = 262.87, heading = 164.54, radius = 6.0 },

			},
		},

		VehicleDeleters = {
			{x = 64.72499, y = -723.952, z = 44.102},
			{x = 149.6619, y = -753.588, z = 262.87},
		},

		BossActions = {
			{ x = 149.56, y = -758.36, z = 242.16 }
		},

		Elevator = {
			{
				Top = { x = 136.24, y = -761.96, z = 242.16 },
				Down = { x = 136.16, y = -761.52, z = 45.76 },
				Parking_heli = {x = 141.1895, y = -735.133, z = 262.85}
            }
		},

	},
}

Config_cia.AuthorizedVehicles = {
	Shared = {

	{ model = 'b2chal', label = 'F.B.I Chal', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['4'] = 0, ['5'] = 0 } },

	{ model = 'b211vic', label = 'F.B.I Vic', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0, ['10'] = 1} },

	{ model = 'b212caprice', label = 'F.B.I Caprice', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0} },

	{ model = 'b214charger', label = 'F.B.I Charger', Extra = {['1'] = 0, ['2'] = 1, ['3'] = 1, ['5'] = 0, ['6'] = 0, ['7'] = 1, ['8'] = 0 }},

	{ model = 'b216explorer', label = 'F.B.I Explorer',  Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1}},

	{ model = 'b218charger', label = 'F.B.I Charger18', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 0}},

	{ model = 'b218tau', label = 'F.B.I Tau', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['6'] = 1, ['7'] = 0}},

	{ model = 'b219tahoe', label = "F.B.I Tahoe", Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 1, ['5'] = 1, ['6'] = 1, ['7'] = 0}},
	{ model = 'fibm5', label = "F.B.I BMWM5", Extra = {['1'] = 0}},
	{ model = 'polnspeedo', label = "F.B.I Van", Extra = {['11'] = 0}},
	{ model = 'POLKCH', label = "F.B.I Kamacho", Extra = {['1'] = 0, ['3'] = 0, ['4'] = 0}},
	{ model = 'swat_dirtbike', label = "F.B.I Motor", Extra = {['1'] = 1}},

	},

	Sharedheli = {

	{ model = 'polmav', label = 'Polmav', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },
	{ model = 'tx_heli', label = 'h1', Extra = {['1'] = 0, ['2'] = 0, ['3'] = 0, ['4'] = 0, ['5'] = 0 } },



	},


}