-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Config = {}
local oldWeapon = `WEAPON_UNARMED`
Config.Positions = {

    backrastmele =      { boneNumber = 24818,   position = vec(-0.139, -0.157, -0.160), rotation = vec(0.0, 51.980, 0.00),      part = 'backrastmele'       },
    backrastmele2 =     { boneNumber = 24818,   position = vec(-0.168,      -0.182,     -0.154),     rotation = vec(-0.746,    53.757,     -5.469),    part = 'backrastmele2'      },

    katana1 =           { boneNumber = 24818,   position = vec(0.28,        -0.13,      -0.14),      rotation = vec(-0.9,      -62.59,     -148.38),   part = 'katana1'            },
    katana2 =           { boneNumber = 24818,   position = vec(0.28,        -0.17,      -0.14),      rotation = vec(-0.9,      -62.59,     -148.38),   part = 'katana1'            },

    katana3 =           { boneNumber = 24818,   position = vec(0.26,        -0.14,      0.13),       rotation = vec(178.08,    57.41,      -201.79),   part = 'katana3'            },
    katana4 =           { boneNumber = 24818,   position = vec(0.26,        -0.18,      0.13),       rotation = vec(178.08,    57.41,      -201.78),   part = 'katana4'            },

    kamarrast =         { boneNumber = 57597,   position = vec(-0.332,      0.01,       -0.222),     rotation = vec(0.0,       89.736,     106.548),   part = 'kamarrast'          },
    kamarchap =         { boneNumber = 57597,   position = vec(-0.341,      0.0,        0.256),      rotation = vec(82.54,     10.967,     93.694),    part = 'kamarchap'          },
    kamarflash =        { boneNumber = 0,       position = vec(0.103,       0.169,      0.017),      rotation = vec(179.535,   0.763,      -32.094),   part = 'kamarflash'         },
    kamarnightstick =   { boneNumber = 0,       position = vec(0.221,       0.029,      0.002),      rotation = vec(172.051,   -7.308,     -96.304),   part = 'kamarnightstick'    },
    kamarpistolpolice = { boneNumber = 6442,    position = vec(0.021,       0.0,        0.129),      rotation = vec(-101.855,  1.42,       -2.205),    part = 'kamarpistolpolice' },
    poshtekamargun =    { boneNumber = 24818,   position = vec(-0.091,      -0.143,     0.067),      rotation = vec(0.0,       35.394,     0.0),       part = 'poshtekamargun'     },
    poshtekamargun2 =   { boneNumber = 24818,   position = vec(-0.091,      -0.202,     0.067),      rotation = vec(0.0,       35.394,     0.0),       part = 'poshtekamargun2'    },
    jelosinegun =       { boneNumber = 24818,   position = vec(0.0,         0.172,      0.0),        rotation = vec(5.155,     39.547,     -174.796),  part = 'jelosinegun'        },
    jelosinegun2 =      { boneNumber = 24818,   position = vec(0.067,       0.2,        0.0),        rotation = vec(-179.179,  -49.644,    -179.901),  part = 'jelosinegun2'       },
    poshtkamarpistol =  { boneNumber = 0,       position = vec(0.002,       -0.174,     0.035),      rotation = vec(-5.525,    -46.172,    -177.792),  part = 'poshtkamarpistol'   },

}

Config.Weapons = {
    ['WEAPON_BAT'] = {
        default = 'backrastmele',
        clothe = {
            ['bproof|1_m_57-125'] = 'backrastmele2',
        }
    },
    ['WEAPON_LUCILLE'] = {
        default = 'backrastmele',
        clothe = {
            ['bproof|1_m_57-125'] = 'backrastmele2',
        }
    },
    ['WEAPON_KATANA'] = {
        default = 'katana1',
        clothe = {
            ['bproof|1_m_57-125'] = 'katana2',
        }
    },
    ['WEAPON_KATANA2'] = {
        default = 'katana3',
        clothe = {
            ['bproof|1_m_57-125'] = 'katana4',
        }
    },
    ['WEAPON_BATTLEAXE'] = 'kamarrast', -- fix
    ['WEAPON_STONE_HATCHET'] = 'kamarchap', -- fix
    ['WEAPON_FLASHLIGHT'] = 'kamarflash', -- fix
    ['WEAPON_NIGHTSTICK'] = 'kamarnightstick', -- fix
    ['WEAPON_MACHETE'] = 'kamarnightstick', -- fix 
    ['WEAPON_DAGGER'] = 'kamarflash', -- fix
    ['WEAPON_KNIFE'] = 'kamarflash', -- fix 
    ['WEAPON_SWITCHBLADE'] = 'kamarflash', -- fix
    ['WEAPON_POOLCUE'] = 'backrastmele', -- fix
    ['WEAPON_STUNGUN'] = 'kamarpistolpolice', -- fix



-- rifle back
    ['WEAPON_TACTICALRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HEAVYRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_ASSAULTRIFLE_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_CARBINERIFLE_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SPECIALCARBINE_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BULLPUPRIFLE_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_PUMPSHOTGUN_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SPECIALCARBINE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_ASSAULTSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_CARBINERIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_ASSAULTRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BULLPUPRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_PUMPSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BULLPUPSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_PRECISIONRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MUSKET'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HEAVYSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_DBSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_AUTOSHOTGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MG'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_COMBATMG'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_COMBATMG_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SNIPERRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HEAVYSNIPER'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HEAVYSNIPER_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MARKSMANRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MARKSMANRIFLE_MK2'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_RPG'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_GRENADELAUNCHER'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_GRENADELAUNCHER_SMOKE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MINIGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_FIREWORK'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_RAILGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HOMINGLAUNCHER'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_COMPACTLAUNCHER'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_RAYMINIGUN'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SMOKEGRENADE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MINISMG'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_RAYCARBINE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },

-- pistol poshte kamar
    ['WEAPON_PISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_PISTOL50'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_SNSPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_COMBATPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_HEAVYPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_VINTAGEPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_CERAMICPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_APPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_PISTOL_MK2'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_SNSPISTOL_MK2'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_FLAREGUN'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_MARKSMANPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_REVOLVER'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_REVOLVER_MK2'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_DOUBLEACTION'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_NAVYREVOLVER'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_PISTOLXM3'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_RAYPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_MACHINEPISTOL'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },

-- jelo sine
    ['WEAPON_SMG'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_ASSAULTSMG'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_GUSENBERG'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_SAWNOFFSHOTGUN'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_COMBATPDW'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_ADVANCEDRIFLE'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_SMG_MK2'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_COMPACTRIFLE'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_MICROSMG'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },
    ['WEAPON_TECPISTOL'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
        -- clothe = {
        --     ['helmet|1_m_2'] = 'poshtkamarpistol',
        -- }
    },

    ['WEAPON_BAYONETKNIFE'] = 'kamarrast',
    ['WEAPON_BLUEBFKNIFE'] = 'kamarrast',
    ['WEAPON_CHBFKNIFE'] = 'kamarrast',
    ['WEAPON_CRIMSONBFKNIFE'] = 'kamarrast',
    ['WEAPON_FADEBFKNIFE'] = 'kamarrast',
    ['WEAPON_FLIPKNIFE'] = 'kamarrast',
    ['WEAPON_FORESTBFKNIFE'] = 'kamarrast',
    ['WEAPON_GUTKNIFE'] = 'kamarrast',
    ['WEAPON_HUNTSMANKNIFE'] = 'kamarrast',
    ['WEAPON_KARAMBITKNIFE'] = 'kamarrast',
    ['WEAPON_SAFARIBFKNIFE'] = 'kamarrast',
    ['WEAPON_SCORCHEDBFKNIFE'] = 'kamarrast',
    ['WEAPON_SLAUGHTERBFKNIFE'] = 'kamarrast',
    ['WEAPON_STAINEDRBFKNIFE'] = 'kamarrast',
    ['WEAPON_URBANRBFKNIFE'] = 'kamarrast',
    ['WEAPON_BFKNIFE'] = 'kamarrast',
    ['WEAPON_AK47'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_AK74'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_AKS74'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_AR15'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_COLBATON'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_DE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_FNX45'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_GLOCK18C'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_GLOCK22'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HK416'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HUNTINGRIFLE'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_M4'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_M9'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_M70'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MAC10'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MK14'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MOSSBERG'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MP5'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MP9'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_PERFORATOR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_REMINGTON'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SCARH'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SHIV'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SLEDGEHAMMER'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_UZI'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },



    -- ['WEAPON_SMG'] = {
    --     default = 'jelosinegun',
    --     access = {
    --         police = 'poshtekamargun',
    --     },
    --     clothe = {
    --         ['helmet|1_m_2'] = 'poshtkamarpistol',
    --     }
    -- }

    ['WEAPON_AK_47_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_AR_15_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BERYL_762_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BULLPUP_SMG_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_BZ_199_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_FAMAS_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_GAU_5A_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HK2002M_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HOWA_T20_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_HX_15_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_L85_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_M16A1_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_M4_ARCW_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MK_PRISS_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MLTM4R_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MODULAR_RIFLE_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_NVRIFLE_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_R90_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SR_3M_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_VX_47_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_XM7_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_MPH_21_SG_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_SPS_21_SG_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_DKS_101_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_DMRSNIPER_CHR'] = {
        default = 'poshtekamargun',
        clothe = {
            ['bproof|1_m_57-125'] = 'poshtekamargun2',
        }
    },
    ['WEAPON_COMBATHP_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_DESERT_EAGLE_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_H05117_P_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_HKUSP_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_HM_PISTOL_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_LSR_PISTOL_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_M27_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_SYS_PISTOL_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_ZETA_19_CHR'] = {
        default = 'poshtkamarpistol',
        access = {
            police = 'kamarpistolpolice',
        },
    },
    ['WEAPON_M270D_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_MP5_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_SB_SD_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_SPX_7_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_TACTICAL_VECTOR_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_UMP_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_VECOTR_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_VERESK_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
    ['WEAPON_VX_SCORPION_CHR'] = {
        default = 'jelosinegun',
        access = {
            police = 'jelosinegun2',
        },
    },
}

Config.customModels = {
    [`WEAPON_ASSAULTRIFLE_MK2`] = `WEAPON_ASSAULTRIFLE`
}


local loadout
local playerAttachedWeapons <const> = {}
local men = `mp_m_freemode_01`
local CMDactive, forceActive = false, false
local equipedPart = {}
local weaponList = {}
local localAttachedWeapons <const> = {
    bones = {},
    weapon = {}
}
local loaded = false

Citizen.CreateThread(function()
    if GetResourceKvpInt('weaponBack') == 1 then
        CMDactive = true
    end
	waitForLoad()
    weaponList = ESX.GetWeaponList()
    while not ESX.GetPlayerData().loadout do
		Wait(100)
	end

    loadout = ESX.GetPlayerData().loadout
    forceActive = ESX.militaryJobs2[ESX.PlayerData.job.name]
    loaded = true
end)

local function getMaketSerials()
    local set = {}
    local maketSlot = exports['sun-inventory-hud']:getMaketSlot()
    for k, v in pairs(maketSlot or {}) do
        if type(v) == 'table' and v.serial then
            set[v.serial] = true
        end
    end
    return set
end

local function firstCheck()
    if CMDactive or forceActive then
        local equipedWeapon, equipedWeapon2 = exports['sun-inventory-hud']:getWeaponSlot()
        local maketSerials = getMaketSerials()
        for i = 1, #loadout do
            local thisWeapon = loadout[i]
            if maketSerials[thisWeapon.metadata.serial] then
                local part = getWeaponPart(thisWeapon.name)
                local weaponHash = joaat(thisWeapon.name)
                if part then
                    thisWeapon.equiped = true
                    if oldWeapon ~= weaponHash then
                        equipedPart[part] = {hash = weaponHash, alias = generateWeaponDataAlias(thisWeapon), name = thisWeapon.name, serial = thisWeapon.metadata.serial}
                        LocalPlayer.state:set(part, equipedPart[part].alias, true)
                    end
                end
            end
        end
        for i = 1, #loadout do
            local thisWeapon = loadout[i]
            local part = getWeaponPart(thisWeapon.name)
            local weaponHash = joaat(thisWeapon.name)
            if part and equipedWeapon2[thisWeapon.metadata.serial] then
                thisWeapon.equiped = true
                if oldWeapon ~= weaponHash and not equipedPart[part] then
                    equipedPart[part] = {hash = weaponHash, alias = generateWeaponDataAlias(thisWeapon), name = thisWeapon.name, serial = thisWeapon.metadata.serial}
                    LocalPlayer.state:set(part, equipedPart[part].alias, true)
                end
            end
        end
    end
end

local function reCheckEquiped()
    for k, v in pairs(equipedPart) do
        local part = getWeaponPart(v.name)
        if part ~= k then
            equipedPart[part] = v
            LocalPlayer.state:set(part, equipedPart[part].alias, true)
            equipedPart[k] = nil
            LocalPlayer.state:set(k, nil, true)
        end
    end
end

local function clearEquiped()
    for k, v in pairs(equipedPart) do
        equipedPart[k] = nil
        LocalPlayer.state:set(k, nil, true)
    end
end


AddEventHandler('sun:clotheLoaded', function()
    while not ESX.GetPlayerData().loadout do
		Citizen.Wait(10)
	end

    loadout = ESX.GetPlayerData().loadout
    firstCheck()
end)

-- When loadout Updates
RegisterNetEvent('esx:updateLoadout', function(passedLoadout)
	loadout = passedLoadout
end)

local function dequipeWeapon(hash)
    for k, v in pairs(equipedPart) do
        if v.hash == hash then
            LocalPlayer.state:set(k, nil, true)
            equipedPart[k] = nil
        end
    end
end

local function isActive()
    return CMDactive or forceActive
end

AddEventHandler('onSelectWeapon', function(armed, newWeapon)
    if not loaded then return end
    local oldWasExist = (oldWeapon and getPartByHash(oldWeapon))
    local doesNewExist = getPartByHash(newWeapon)
    if oldWasExist and (CMDactive or forceActive) and HasPedGotWeapon(SUN.ped, oldWeapon, false) then
        local thisWeapon = getWeaponByHash(oldWeapon)
        -- Player put back the weapon on holster
        if thisWeapon then
            equipedPart[oldWasExist] = {hash = oldWeapon, alias = generateWeaponDataAlias(thisWeapon), name = thisWeapon.name}
            LocalPlayer.state:set(oldWasExist, equipedPart[oldWasExist].alias, true)
        end
    end
    if doesNewExist and LocalPlayer.state[doesNewExist] and joaat(getWeaponDataFromAlias(LocalPlayer.state[doesNewExist]).name) == newWeapon then
        -- Player took out a gun from holster
        equipedPart[doesNewExist] = nil
        LocalPlayer.state:set(doesNewExist, nil, true)
    end
    dequipeWeapon(newWeapon)

    if doesNewExist and isActive() then
        for i = 1, #loadout do
            local thisWeapon = loadout[i]
            if thisWeapon.equiped then
                local weaponHash = joaat(thisWeapon.name)
                if newWeapon ~= weaponHash then
                    local part = getWeaponPart(thisWeapon.name)
                    if part == doesNewExist and HasPedGotWeapon(SUN.ped, weaponHash, false) then
                        equipedPart[part] = {hash = weaponHash, alias = generateWeaponDataAlias(thisWeapon), name = thisWeapon.name}
                        LocalPlayer.state:set(part, equipedPart[part].alias, true)
                    end
                end
            end
        end
    end
    oldWeapon = newWeapon
end)

RegisterNetEvent('core:client:giveWeapon', function(serial) -- Trigger when weapon equiped
    local thisWeapon = getWeaponBySerial(serial)
    if not thisWeapon or (not CMDactive and not forceActive) then return end
    local part = getWeaponPart(thisWeapon.name)
    if not part then return end
    local current = equipedPart[part]
    if current and current.serial and current.serial ~= serial then
        local maketSerials = getMaketSerials()
        if maketSerials[current.serial] and not maketSerials[serial] then return end
    end
    thisWeapon.equiped = true
    equipedPart[part] = {hash = joaat(thisWeapon.name), alias = generateWeaponDataAlias(thisWeapon), name = thisWeapon.name, serial = serial}
    LocalPlayer.state:set(part, equipedPart[part].alias, true)
end)

local function removeWeaponHandler(serial)
    local thisWeapon = getWeaponBySerial(serial)
    if not thisWeapon then return end
    local part = getWeaponPart(thisWeapon.name)
    if localAttachedWeapons.bones?[part] ~= joaat(thisWeapon.name) then return end
    thisWeapon.equiped = nil
    equipedPart[part] = nil
    LocalPlayer.state:set(part, nil, true)
end

RegisterNetEvent('core:client:removeWeapon', removeWeaponHandler)
RegisterNetEvent('core:removeWeapon', function(name, serial)
    removeWeaponHandler(serial)
end)

-- When wepaon components add
RegisterNetEvent('core:addWeaponComponent', function(weaponName, serial, component)
    local thisWeapon = getWeaponBySerial(serial)
    if not thisWeapon then return end

    thisWeapon.components[#thisWeapon.components+1] = component

    handleCompUpdate(thisWeapon)
end)

-- When weapon components remove
RegisterNetEvent('core:removeWeaponComponent', function(weaponName, serial, component)
    local thisWeapon = getWeaponBySerial(serial)
    if not thisWeapon then return end

    for i = 1, #thisWeapon.components do
        if thisWeapon.components[i] == component then
            table.remove(thisWeapon.components, i)
        end
    end

    handleCompUpdate(thisWeapon)
end)

-- When weapon tint updates
RegisterNetEvent('core:setWeaponTint', function(weaponName, serial, tint)
    local thisWeapon = getWeaponBySerial(serial)
    if not thisWeapon then return end
    thisWeapon.tintIndex = tint

    handleCompUpdate(thisWeapon)
end)

local function AttachWeapon(playerID, thisLoadout, thisPos)
    -- Get the player from server ID
    local player = GetPlayerFromServerId(playerID)
    if player == -1 then return end

    -- Get the ped from player 
    local ped = GetPlayerPed(player)
    local timeout = 1000
    while timeout > 0 and not DoesEntityExist(ped) do
        Wait(250)
        ped = GetPlayerPed(player)
        timeout = timeout - 250
    end
    -- return if ped does not exist
    if not DoesEntityExist(ped) then return end

    -- Remove previous attachment to this part
    deletePreviousData(playerID, thisPos.part)
    -- Get and validate  bone, coords, weapon hash and weapon object model
	local bone = GetPedBoneIndex(ped, thisPos.boneNumber)
    local coords = GetEntityCoords(ped)
    local weaponHash = joaat(thisLoadout.name)
    local weaponModel = GetWeapontypeModel(thisLoadout.name)
    if not IsModelValid(weaponModel) then return print(("%s model is not valid"):format(thisLoadout.name)) end
    RequestModel(weaponModel)
	while not HasModelLoaded(weaponModel) do
		Wait(100)
	end

    -- Create weapon object and collisions
    local handle = CreateWeaponObject(Config.customModels[weaponHash] or weaponHash, 0, coords.x, coords.y, coords.z, false, 1.0, 0)
    SetEntityCollision(handle, false, false)
    Entity(handle).state:set('antiDelete', true, false)
    -- Set weapon tint
    local thisTint = thisLoadout.tintIndex or 0
    SetWeaponObjectTintIndex(handle, thisTint)

    -- Get, validate and creating weapon components object if it exist
    if thisLoadout.components then
        for i = 1, #thisLoadout.components do
            local comp = thisLoadout.components[i]
            -- Get component data
            local compdata = ESX.GetWeaponComponent(thisLoadout.name, comp)
            -- IF component data exist
            if compdata and compdata.hash then
                -- Get the component entity model by hash
                local model = GetWeaponComponentTypeModel(compdata.hash)
                -- Check if the model is valid
                if IsModelValid(model) then
                    ESX.Streaming.RequestModel(model, function()
                        -- Attach component object model to weapon
                        GiveWeaponComponentToWeaponObject(handle, compdata.hash)
                        SetModelAsNoLongerNeeded(model)
                    end)
                end
            end
        end
    end

    -- Attaching weapon object to ped
    AttachEntityToEntity(handle, ped, bone, thisPos.position.x, thisPos.position.y, thisPos.position.z, thisPos.rotation.x, thisPos.rotation.y, thisPos.rotation.z, true, true, false, true, 1, true)

    -- If it's the own ped, save our own Data in to RAM
    if playerID == ESX.src then
        localAttachedWeapons.weapon[weaponHash] = {
            hash = weaponHash,
            handle = handle,
            part = thisPos.part
        }
        localAttachedWeapons.bones[thisPos.part] = weaponHash
    end
    -- Initilize player data into RAM if it doesn't exist
    if not playerAttachedWeapons[playerID] then playerAttachedWeapons[playerID] = {} end
    -- Save the attach data into RAM
    playerAttachedWeapons[playerID][thisPos.part] = handle
    -- Set model as no longer needed
    SetModelAsNoLongerNeeded(weaponModel)
end

function doesPlayerHaveWeapon(hash)
    for i = 1, #loadout do
        local thisWeapon = loadout[i]
        if joaat(thisWeapon.name) == hash then
            return true
        end
    end

    return false
end

function deletePreviousData(id, part)
    local previousData = playerAttachedWeapons[id]?[part]
    if not previousData then return end

    ESX.Game.DeleteObject(previousData)
    playerAttachedWeapons[id][part] = nil

    if id == ESX.src then
        local weaponHash = localAttachedWeapons.bones[part]
        if weaponHash then
            if localAttachedWeapons.weapon[weaponHash] then localAttachedWeapons[weaponHash] = nil end
            localAttachedWeapons.bones[part] = nil
        end
    end
end

function getWeaponBySerial(serial)
    for i = 1, #loadout do
        local thisWeapon = loadout[i]
        if thisWeapon.metadata.serial == serial then
            return thisWeapon
        end
    end
end

function getWeaponByHash(hash)
    for i = 1, #loadout do
        local thisWeapon = loadout[i]
        if thisWeapon.equiped and joaat(thisWeapon.name) == hash then
            return thisWeapon
        end
    end
end

function handleCompUpdate(thisWeapon)
    if not thisWeapon.equiped or oldWeapon == joaat(thisWeapon.name) then return end

    local part = getWeaponPart(thisWeapon.name)
    if not part or (not CMDactive and not forceActive) then return end

    LocalPlayer.state:set(part, generateWeaponDataAlias(thisWeapon), true)
end

function getPartByHash(hash)
    return getWeaponPart(ESX.GetWeaponName(hash))
end

for listner, _ in pairs(Config.Positions) do
    ---@diagnostic disable-next-line: param-type-mismatch
    AddStateBagChangeHandler(listner, nil, function(bagName, key, newValue, _, replicate)
        if replicate then return end
        if not loaded then return end
        if not bagName:match('player:') then return end
        local thisID = tonumber(bagName:gsub('player:', ''), 10)

        if newValue then
            local weaponData = getWeaponDataFromAlias(newValue)
            AttachWeapon(thisID, weaponData, Config.Positions[listner])
        else
            deletePreviousData(thisID, listner)
        end
    end)
end

RegisterNetEvent('onPlayerDropped', function(thisID)
    for listner, _ in pairs(Config.Positions) do
        deletePreviousData(thisID, listner)
    end
end)

function getWeaponPart(weaponName)
    local part = Config.Weapons[weaponName:upper()]
    if type(part) == 'string' then
        return part
    elseif not part then
        return nil
    else
        local _part = part.default
        ESX.PlayerData = ESX.GetPlayerData()
        if part.access and (part.access[ESX.PlayerData.job.name] or part.access[ESX.PlayerData.gang.name]) then
            _part = part.access[ESX.PlayerData.job.name] or part.access[ESX.PlayerData.gang.name]
        end
        if part.clothe then
            local gender = GetEntityModel(PlayerPedId()) == men and 'm' or 'f'
            local skin = exports['skinchanger']:getSkin()
            for k, v in pairs(part.clothe) do
                local data = ESX.splitString(k, '_')
                local numbers = ESX.splitString(data[3], '-')
                local skinNum = skin[data[1]:gsub('|', '_')]
                if data[2] == gender and skinNum >= tonumber(numbers[1]) and skinNum <=  tonumber(numbers[2]) then
                    _part = v
                    break
                end
            end
        end
        return _part
    end
end

local CMDCD = false
RegisterCommand('weapback',function()
    if ESX.GetPlayerData().gang.name ~= 'nogang' and not forceActive then
        TriggerEvent('gangprop:getGangLocation',function(pos)
            if pos then
                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),vector3(pos.x,pos.y,pos.z))
                if distance < 100 then
                    if CMDCD then return ESX.ShowNotification('Spam nakonid!') end
                    CMDCD = true
                    Citizen.SetTimeout(10000,function()
                        CMDCD = false
                    end)
                    if CMDactive then
                        CMDactive = false
                        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Weapon back gheyr fa'al shod!", 'plarms')
                        SetResourceKvpInt('weaponBack',0)
                        for k, v in pairs(equipedPart) do
                            LocalPlayer.state:set(k, nil, true)
                        end
                        equipedPart = {}
                    else
                        CMDactive = true
                        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Weapon back fa'al shod!", 'plarms')
                        SetResourceKvpInt('weaponBack',1)
                        firstCheck()
                    end
                else
                    ESX.ShowNotification('Shoma bayad dar nazdiki khane gang bashid.')
                end
            end
        end)
    else
        ESX.ShowNotification('Shoma bayad dar nazdiki khane gang bashid.')
    end
end, false)

function generateWeaponDataAlias(weapon)
    if not weapon then return end
    local name = weapon.name
    local hash = joaat(name)
    local alias = '' -- name - tint index -
    local weaponConfig = {}
    for k, v in pairs(weaponList) do
        if v.name == name then
            alias = alias .. k .. '-'
            weaponConfig = v
        end
    end
    local tintIndex = GetPedWeaponTintIndex(SUN.ped, hash)
    alias = alias .. (tintIndex or '')
    if weapon.components then
        -- for k, v in pairs(weapon.components) do
            for k2, v2 in pairs(weaponConfig.components) do
                if HasPedGotWeaponComponent(SUN.ped, hash, v2.hash) then
                    alias = alias ..  '-' .. k2
                    -- break
                end
            end
        -- end
    end
    return alias
end

function getWeaponDataFromAlias(alias)
    local data = {}
    local alias = ESX.splitString(alias, '-')
    local weaponConfig = weaponList[tonumber(alias[1])]
    data.name = weaponConfig.name
    data.tintIndex = tonumber(alias[2])
    alias[1] = nil
    alias[2] = nil
    data.components = {}
    for k, v in pairs(alias) do
        if weaponConfig.components[tonumber(v)] then
            table.insert(data.components, weaponConfig.components[tonumber(v)].name)
        end
    end
    return data
end

RegisterNetEvent('esx:setJob', function(job)
    Wait(1000)
    forceActive = ESX.militaryJobs2[job.name]
    clearEquiped()
    if CMDactive or forceActive then
        reCheckEquiped()
    else
        for k, v in pairs(equipedPart) do
            LocalPlayer.state:set(k, nil, true)
        end
        equipedPart = {}
    end
    if not CMDactive and forceActive then
        firstCheck()
    end
end)

RegisterNetEvent('onSkinChange', function()
    Wait(1000)
    if CMDactive or forceActive then
        reCheckEquiped()
    end
end)