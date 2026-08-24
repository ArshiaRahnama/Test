Config         = {}
Locales        = {}
Config.Locale  = 'en'
Config.Zones   = {}
Config.TickTime         = 100
Config.UpdateClientTime = 5000
Config.ReceiveMsg = true
Config.DrawingTime = 15*1000
Config.TextColor = {r=255, g=255,b=255}
Config.AlertTextColor = {r=255, g=0, b=0}
Config.LogSystem = true
Config.UseSteam = true
Config.LogBotName = "ServerTest CL"
Config.AutoDisableDrawing = true
Config.AutoDisableDrawingTime = 15000
Config.TackleDistance				= 3.0
Config.MaxDistance = 1.5
Config.debug = false
Config.ServiceExtensionOnEscape		= 5
Config.ServiceLocation 				= {x =  1682.3, y = 2515.52, z = 44.9}
Config.ReleaseLocation				= {x = 1846.11, y = 2585.85, z = 45.67}
Config.Price = 100
Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 102, g = 102, b = 204}
Config.MarkerType   = 1

Config.Shops = {
  {x = -814.308,  y = -183.823,  z = 36.568},
  {x = 136.826,   y = -1708.373, z = 28.291},
  {x = -1282.604, y = -1116.757, z = 5.990},
  {x = 1931.513,  y = 3729.671,  z = 31.844},
  {x = 1212.840,  y = -472.921,  z = 65.208},
  {x = -32.885,   y = -152.319,  z = 56.076},
  {x = -278.077,  y = 6228.463,  z = 30.695},

}

for i=1, #Config.Shops, 1 do

	Config.Zones['Shop_' .. i] = {
	 	Pos   = Config.Shops[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end

Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(1682.3, 2515.52, 44.9) },
	{ type = "cleaning", coords = vector3(1669.86, 2494.0, 44.9) },
	{ type = "cleaning", coords = vector3(1657.47, 2529.99, 44.9) },
	{ type = "cleaning", coords = vector3(1689.26, 2523.39, 44.9) },
	{ type = "cleaning", coords = vector3(1679.83, 2494.03, 44.9) },
	{ type = "cleaning", coords = vector3(1666.23, 2506.68, 44.9) },
	{ type = "cleaning", coords = vector3(1687.47, 2508.32, 44.9) },
	{ type = "cleaning", coords = vector3(1700.86, 2519.08, 44.9) },
	{ type = "gardening", coords = vector3(1688.37, 2501.19, 44.9) },
	{ type = "gardening", coords = vector3(1661.83, 2504.66, 44.9) },
	{ type = "gardening", coords = vector3(1666.37, 2520.29, 44.9) },
	{ type = "gardening", coords = vector3(1681.5, 2534.03, 44.9) },
	{ type = "gardening", coords = vector3(1702.24, 2506.54, 44.9) }
}

Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 119, ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,  ['chain_1']  = 0,
			['chain_2']  = 0
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 120,  ['pants_1'] = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,   ['chain_1']  = 0,
			['chain_2']  = 0
		}
	}
}

Config.Cooldowns = {
	["police"] = {
		light = 700,
		heavy = 1200
	},
	["civilian"] = {
		light = 1300,
		heavy = 1350
	}
}

Config.Weapons = {
	[GetHashKey("WEAPON_PISTOL")] = "light",
	[GetHashKey("WEAPON_COMBATPISTOL")] = "light",
	[GetHashKey("WEAPON_PISTOL50")] = "light",
	[GetHashKey("WEAPON_SNSPISTOL")] = "light",
	[GetHashKey("WEAPON_HEAVYPISTOL")] = "light",
	[GetHashKey("WEAPON_STUNGUN")] = "light",
	[GetHashKey("WEAPON_REVOLVER")] = "light",
	[GetHashKey("WEAPON_COMBATPDW")] = "heavy",
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = "heavy",
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = "heavy",
	[GetHashKey("WEAPON_ADVANCEDRIFLE")] = "heavy",
	[GetHashKey("WEAPON_SMG")] = "heavy",
	[GetHashKey("WEAPON_CARBINERIFLE")] = "heavy",
	[GetHashKey("WEAPON_BULLPUPRIFLE")] = "heavy",
	[GetHashKey("WEAPON_MICROSMG")] = "light",
}



function _(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
        end
    else
        return "Moshkel Dar Rabete Ba Locale Pish Omade Be ScArY Elam Konid!"
    end
end

function _U(str, ...)
    return tostring(_(str, ...):gsub("^%l", string.upper))
end

cfg = {
	deformationMultiplier = -1,
	deformationExponent = 0.4,
	collisionDamageExponent = 0.6,

	damageFactorEngine = 3.0,
	damageFactorBody = 4.0,
	damageFactorPetrolTank = 40.0,
	engineDamageExponent = 0.6,
	weaponsDamageMultiplier = 0.01,
	degradingHealthSpeedFactor = 10,
	cascadingFailureSpeedFactor = 8.0,
	degradingFailureThreshold = 800.0,
	cascadingFailureThreshold = 360.0,
	engineSafeGuard = 100.0,
	torqueMultiplierEnabled = true,
	limpMode = false,
	limpModeMultiplier = 0.15,
	preventVehicleFlip = true,
	sundayDriver = false,
	sundayDriverAcceleratorCurve = 7.5,
	sundayDriverBrakeCurve = 5.0,
	displayBlips = false,
	compatibilityMode = false,
	randomTireBurstInterval = 0,

	classDamageMultiplier = {
		[0] = 	0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.05,
				0.7,
				0.25,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.3,
				0.25,
				0.25,
				0.25,
				0.3
	}
}

repairCfg = {
	mechanics = {

	},

	fixMessages = {
		"Mashin Shoma Kami Tamir Shod",
	},
	fixMessageCount = 1,

	noFixMessages = {
		"Motor Mashin Shoma Salem Ast",
		"Mashin Shoma Salem Ast"
	},
	noFixMessageCount = 2
}

RepairEveryoneWhitelisted = true
RepairWhitelist =
{
	"steam:110000146d830cd",
	"steam:000000000000000",
	"ip:192.168.0.1"
}

Config_HUNT = {}

Config_HUNT.ItemsLashe = {
    'lasheoghab',
    'lasheaho',
    'lashekhargush',
    'lasherottweiler',
    'lashehusky',
    'lashecougar',
    'lashepig',
    'lashecoyote',
    'lashemorgh'
}

Config_HUNT.ItemsTabdil = {
    lasheoghab = {name = 'lasheoghab', head = 'headeoghab', gosht = 'goshteoghab', post = ''},
    lasheaho = {name = 'lasheaho', head = 'headeaho', gosht = 'goshteaho', post = 'posteaho'},
    lashekhargush = {name = 'lashekhargush', head = 'headekhargush', gosht = 'goshtekhargush', post = 'postekhargush'},
    lasherottweiler = {name = 'lasherottweiler', head = 'headerottweiler', gosht = 'goshterottweiler', post = 'posterottweiler'},
    lashehusky = {name = 'lashehusky', head = 'headehusky', gosht = 'goshtehusky', post = 'postehusky'},
    lashecougar = {name = 'lashecougar', head = 'headecougar', gosht = 'goshtecougar', post = 'postecougar'},
    lashepig = {name = 'lashepig', head = 'headepig', gosht = 'goshtepig', post = 'postepig'},
    lashecoyote = {name = 'lashecoyote', head = 'headecoyote', gosht = 'goshtecoyote', post = 'postecoyote'},
    lashemorgh = {name = 'lashemorgh', head = 'heademorgh', gosht = 'slaughtered_chicken', post = ''}
}

Config_Megaphone = {}

Config_Megaphone.Framework = 'esx'

Config_Antipg = {
    Debug = false,




    ChopShopEnabled = false,

    InstallLocation = vector3(-352.312, -90.3062, 40.0),

    Marker = {
        Position = vector3(602.6905, -438.514, 24.756),
        Color = {r = 255, g = 0, b = 0, a = 100}
    },

    Items = {
        Engine = {
            Name = 'engine',
            Label = 'Engine',
            Prop = 'prop_car_engine_01'
        }
    }
}

Config_PedShop = {}

Config_PedShop.Locations = {
    PedShop = vector3(-416.513, 1116.741, 325.87),
    PedChange = vector3(-410.834, 1115.171, 325.87)
}

Config_PedShop.AvailablePedsMale = {
    {label = "Beach Guy", model = "a_m_m_beach_01", expire = 7, price = 100000},
    {label = "Farmer", model = "a_m_m_farmer_01", expire = 14, price = 500000},
}

Config_PedShop.AvailablePedsFemale = {
    {label = "Beach Girl", model = "a_f_y_beach_01", expire = 7, price = 100000},
    {label = "Fitness Girl", model = "a_f_y_fitness_01", expire = 14, price = 500000},
    {label = "Sweet", model = "pmp_st_sweet", expire = 30, price = 20000},
    {label = "Yoga", model = "a_f_y_yoga_01", expire = 30, price = 20000},
}

config = {}

Config_Switchjob = {}

Config_Switchjob.AllowedJobs = {}

Config_Switchjob.MenuCommand = "fbichange"

Config_WeaponsOnBack = {}

Config_WeaponsOnBack.mahdod = true

Config_WeaponsOnBack.WeaponComponents = {

    [GetHashKey("WEAPON_CARBINERIFLE")] = {
        ['clip_default'] = 0x9FBE33EC,
        ['clip_extended'] = 0x91109691,
        ['clip_box'] = 0x91109691,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xD89B9658
    },


    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = {
        ['clip_default'] = 0x4C7A391E,
        ['clip_extended'] = 0x5DD5DBD5,
        ['clip_tracer'] = 0x1757F566,
        ['clip_incendiary'] = 0x3D25C2A7,
        ['clip_armor_piercing'] = 0x255D5D57,
        ['clip_fmj'] = 0x44032F11,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x49B2945,
        ['scope_medium'] = 0xC66B6542,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['barrel'] = 0x833637FF
    },


    [GetHashKey("WEAPON_ASSAULTRIFLE")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['clip_drum'] = 0xDBF0A53D,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0x4EAD7533
    },


    [GetHashKey("WEAPON_SPECIALCARBINE")] = {
        ['clip_default'] = 0x7C8BD10E,
        ['clip_extended'] = 0x6B59AEAA,
        ['clip_drum'] = 0xD9C1E5B1,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xA0D89C42,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0x9D65907A,
        ['luxary_finish'] = 0x730154F2
    },


    [GetHashKey("WEAPON_BULLPUPRIFLE")] = {
        ['clip_default'] = 0xC5A12F80,
        ['clip_extended'] = 0xB3688B0F,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53,
        ['luxary_finish'] = 0xA857BC78
    },


    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = {
        ['clip_default'] = 0xFA8FA10F,
        ['clip_extended'] = 0x8EC1C979,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0xAA2C45B4,
        ['suppressor'] = 0x837445AA,
        ['luxary_finish'] = 0x377CD377
    },


    [GetHashKey("WEAPON_SMG")] = {
        ['clip_default'] = 0x26574997,
        ['clip_extended'] = 0x350966FB,
        ['clip_drum'] = 0x79C77076,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x3CC6BA57,
        ['suppressor'] = 0xC304849A,
        ['luxary_finish'] = 0x27872C90
    },


    [GetHashKey("WEAPON_SMGMK2")] = {
        ['clip_default'] = 0x4C24806E,
        ['clip_extended'] = 0xB9835B2E,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope_holo'] = 0x3F3C8181,
        ['scope_small'] = 0x3DECC7DA,
        ['suppressor'] = 0xC304849A,
        ['muzzle_flat'] = 0xB99402D4,
        ['muzzle_tactical'] = 0xC867A07B,
        ['barrel'] = 0xD9103EE1
    },


    [GetHashKey("WEAPON_MICROSMG")] = {
        ['clip_default'] = 0xCB48AEF0,
        ['clip_extended'] = 0x10E6BA2B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xAC42DF71,
        ['luxary_finish'] = 0x487AAE09
    },


    [GetHashKey("WEAPON_ASSAULTSMG")] = {
        ['clip_default'] = 0x8D1307B0,
        ['clip_extended'] = 0xBB46E417,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x278C78AF
    },


    [GetHashKey("WEAPON_GUSENBERG")] = {
        ['clip_default'] = 0x1CE5A6A5,
        ['clip_extended'] = 0xEAC8C270
    },


    [GetHashKey("WEAPON_PISTOL")] = {
        ['clip_default'] = 0xFED0FD71,
        ['clip_extended'] = 0xED265A1C,
        ['flashlight'] = 0x43FD595B,
        ['suppressor'] = 0x65EA7EBB,
        ['luxary_finish'] = 0xD7391086
    },


    [GetHashKey("WEAPON_PISTOL50")] = {
        ['clip_default'] = 0x2297BE19,
        ['clip_extended'] = 0xD9D3AC92,
        ['flashlight'] = 0x359B7AAE,
        ['suppressor'] = 0xA73D4664,
        ['luxary_finish'] = 0x77B8AB2F
    },


    [GetHashKey("WEAPON_SNIPERRIFLE")] = {
        ['suppressor'] = 0x9BC64089,
        ['scope_large'] = 0xD2443DDC,
        ['scope_advanced'] = 0xBC54DA77
    },


    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = {
        ['clip_default'] = 0x324F2D5F,
        ['clip_extended'] = 0x971CF6FD,
        ['clip_drum'] = 0x88C7DA53,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },


    [GetHashKey("WEAPON_PUMPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xE608B35E,
        ['luxary_finish'] = 0xA2D79DDB
    },


    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = {
        ['clip_default'] = 0x94E81BC7,
        ['clip_extended'] = 0x86BD7F72,
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    },


    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = {
        ['flashlight'] = 0x7BC4CDDC,
        ['suppressor'] = 0xA73D4664,
        ['grip'] = 0xC164F53
    },


    [GetHashKey("WEAPON_M4")] = {
        ['clip_default'] = 0xBE5EEA16,
        ['clip_extended'] = 0xB1214F9B,
        ['flashlight'] = 0x7BC4CDDC,
        ['scope'] = 0x9D2FBF29,
        ['suppressor'] = 0x837445AA,
        ['grip'] = 0xC164F53
    }
}