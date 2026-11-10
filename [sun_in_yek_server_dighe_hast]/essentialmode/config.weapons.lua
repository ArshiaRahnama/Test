-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config.DefaultWeaponTints = {
	[0] = "Default Skin",
	[1] = "Green Skin",
	[2] = "Gold Skin",
	[3] = "Pink Skin",
	[4] = "Army Skin",
	[5] = "Blue Skin",
	[6] = "Orange Skin",
	[7] = "Platinum Skin",
}

Config.DefaultWeaponTintsMK2 = {
	[0] = "Default Skin",
	[1] = "Gray Skin",
	[2] = "Two-Tone Skin",
	[3] = "White Skin",
	[4] = "Beige Skin",
	[5] = "Green Skin",
	[6] = "Blue Skin",
    [7] = "Earth Skin",
    [8] = "Brown & Black Skin",
    [9] = "Red Contrast Skin",
    [10] = "Blue Contrast Skin",
    [11] = "Yellow Contrast Skin",
    [12] = "Orange Contrast Skin",
    [13] = "Bold Pink Skin",
    [14] = "Bold Purple & Yellow Skin",
    [15] = "Bold Orange Skin",
    [16] = "Bold Green & Purple Skin",
    [17] = "Bold Red Features Skin",
    [18] = "Bold Green Features Skin",
    [19] = "Bold Cyan Features Skin",
    [20] = "Bold Yellow Features Skin",
    [21] = "Bold Red & White Skin",
    [22] = "Bold Blue & White Skin",
    [23] = "Metallic Gold Skin",
    [24] = "Metallic Platinum Skin",
    [25] = "Metallic Gray & Lilac Skin",
    [26] = "Metallic Purple & Lime Skin",
    [27] = "Metallic Red Skin",
    [28] = "Metallic Green Skin",
    [29] = "Metallic Blue Skin",
    [30] = "Metallic White & Aqua Skin",
    [31] = "Metallic Red & Yellow Skin",
}

Config.weapons2 = {}
Config.Weapons = {
    --- melee weapon
    {    -- WEAPON_DAGGER
        name = 'WEAPON_DAGGER', hash = `WEAPON_DAGGER`, label = "Dagger", model = 'w_me_dagger',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {},
    }, { -- WEAPON_BAT
        name = 'WEAPON_BAT', hash = `WEAPON_BAT`, label = "Bat", model = 'w_me_bat',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_BOTTLE
        name = 'WEAPON_BOTTLE', hash = `WEAPON_BOTTLE`, label = "Bottle", model = 'w_me_bottle',
        weight = 4, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_CROWBAR
        name = 'WEAPON_CROWBAR', hash = `WEAPON_CROWBAR`, label = "Crowbar", model = 'w_me_crowbar',
        weight = 4, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_FLASHLIGHT
        name = 'WEAPON_FLASHLIGHT', hash = `WEAPON_FLASHLIGHT`, label = "Flashlight", model = 'w_me_flashlight',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_GOLFCLUB
        name = 'WEAPON_GOLFCLUB', hash = `WEAPON_GOLFCLUB`, label = "Golf Club", model = 'w_me_gclub',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_HAMMER
        name = 'WEAPON_HAMMER', hash = `WEAPON_HAMMER`, label = "Hammer", model = 'w_me_hammer',
        weight = 3, weightTrunk = 5, difficulty = 3,
        components = {}
    }, { -- WEAPON_HATCHET
        name = 'WEAPON_HATCHET', hash = `WEAPON_HATCHET`, label = "Hatchet", model = 'w_me_hatchet',
        weight = 3, weightTrunk = 5, difficulty = 3,
        components = {}
    }, { -- WEAPON_LUCILLE
        name = 'WEAPON_LUCILLE', hash = `WEAPON_LUCILLE`, label = "Lucille", model = 'w_me_lucille',
        weight = 0.1, weightTrunk = 1000, difficulty = 4,
        components = {}
    }, { -- WEAPON_KNUCKLE
        name = 'WEAPON_KNUCKLE', hash = `WEAPON_KNUCKLE`, label = "Knuckle Dusters", model = 'w_me_knuckle',
        weight = 2, weightTrunk = 4, difficulty = 3,
        components = {
            { name = 'default_varmod', label = "Defualt Skin", hash = `COMPONENT_KNUCKLE_VARMOD_BASE`    },
			{ name = 'pimp_varmod',    label = "Pimp Skin",    hash = `COMPONENT_KNUCKLE_VARMOD_PIMP`    },
			{ name = 'ballas_varmod',  label = "Ballas Skin",  hash = `COMPONENT_KNUCKLE_VARMOD_BALLAS`  },
            { name = 'dollar_varmod',  label = "Dollar Skin",  hash = `COMPONENT_KNUCKLE_VARMOD_DOLLAR`  },
            { name = 'diamond_varmod', label = "Diamond Skin", hash = `COMPONENT_KNUCKLE_VARMOD_DIAMOND` },
            { name = 'hate_varmod',    label = "Hate Skin",    hash = `COMPONENT_KNUCKLE_VARMOD_HATE`    },
            { name = 'love_varmod',    label = "Love Skin",    hash = `COMPONENT_KNUCKLE_VARMOD_LOVE`    },
            { name = 'player_varmod',  label = "Player Skin",  hash = `COMPONENT_KNUCKLE_VARMOD_PLAYER`  },
            { name = 'king_varmod',    label = "King Skin",    hash = `COMPONENT_KNUCKLE_VARMOD_KING`    },
			{ name = 'vagos_varmod',   label = "Vagos Skin",   hash = `COMPONENT_KNUCKLE_VARMOD_VAGOS`   },
        }
    }, { -- WEAPON_KNIFE
        name = 'WEAPON_KNIFE', hash = `WEAPON_KNIFE`, label = "Knife", model = 'w_me_knife_01',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_MACHETE
        name = 'WEAPON_MACHETE', hash = `WEAPON_MACHETE`, label = "Machete", model = 'w_me_machete',
        weight = 4, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_SWITCHBLADE
        name = 'WEAPON_SWITCHBLADE', hash = `WEAPON_SWITCHBLADE`, label = "Switch Blade", model = 'w_me_dagger',
        weight = 3, weightTrunk = 5, difficulty = 4,
        components = {
            { name = 'default_varmod', label = "Defualt Skin", hash = `COMPONENT_SWITCHBLADE_VARMOD_BASE` },
			{ name = 'var1_varmod',    label = "Var1 Skin",    hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR1` },
			{ name = 'var2_varmod',    label = "Var2 Skin",    hash = `COMPONENT_SWITCHBLADE_VARMOD_VAR2` },
        }
    }, { -- WEAPON_NIGHTSTICK
        name = 'WEAPON_NIGHTSTICK', hash = `WEAPON_NIGHTSTICK`, label = "Nightstick", model = 'w_me_nightstick',
        weight = 3, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_WRENCH
        name = 'WEAPON_WRENCH', hash = `WEAPON_WRENCH`, label = "Pipe Wrench", model = 'w_me_wrench',
        weight = 4, weightTrunk = 5, difficulty = 1,
        components = {}
    }, { -- WEAPON_BATTLEAXE
        name = 'WEAPON_BATTLEAXE', hash = `WEAPON_BATTLEAXE`, label = "Battle Axe", model = 'w_me_battleaxe',
        weight = 4, weightTrunk = 5, difficulty = 3,
        components = {}
    }, { -- WEAPON_POOLCUE
        name = 'WEAPON_POOLCUE', hash = `WEAPON_POOLCUE`, label = "Pool Cue", model = 'w_me_poolcue',
        weight = 3, weightTrunk = 5, difficulty = 3,
        components = {}
    }, { -- WEAPON_STONE_HATCHET
        name = 'WEAPON_STONE_HATCHET', hash = `WEAPON_STONE_HATCHET`, label = "Stone Hatchet", model = 'w_me_stonehatchet',
        weight = 4, weightTrunk = 5, difficulty = 3,
        components = {}
    }, { -- WEAPON_CANDYCANE
		name = 'WEAPON_CANDYCANE', hash = `WEAPON_CANDYCANE`, label = 'Candy Cane', model = 'w_me_candy_xm3',
        weight = 5, weightTrunk = 10, difficulty = 4,
		components = {},
	}, { -- WEAPON_BAYONETKNIFE
        name = 'WEAPON_BAYONETKNIFE', hash = `WEAPON_BAYONETKNIFE`, label = "Bayonet", model = 'w_me_bayonetknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_BLUEBFKNIFE
        name = 'WEAPON_BLUEBFKNIFE', hash = `WEAPON_BLUEBFKNIFE`, label = "BlueSteel Knife", model = 'w_me_bluebfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_CHBFKNIFE
        name = 'WEAPON_CHBFKNIFE', hash = `WEAPON_CHBFKNIFE`, label = "CaseHardened Knife", model = 'w_me_chbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_CRIMSONBFKNIFE
        name = 'WEAPON_CRIMSONBFKNIFE', hash = `WEAPON_CRIMSONBFKNIFE`, label = "Crimson Knife", model = 'w_me_crimsonbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_FADEBFKNIFE
        name = 'WEAPON_FADEBFKNIFE', hash = `WEAPON_FADEBFKNIFE`, label = "Fade Knife", model = 'w_me_fadebfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_FLIPKNIFE
        name = 'WEAPON_FLIPKNIFE', hash = `WEAPON_FLIPKNIFE`, label = "Flip Knife", model = 'w_me_flipknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_FORESTBFKNIFE
        name = 'WEAPON_FORESTBFKNIFE', hash = `WEAPON_FORESTBFKNIFE`, label = "Forest Knife", model = 'w_me_forestbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_GUTKNIFE
        name = 'WEAPON_GUTKNIFE', hash = `WEAPON_GUTKNIFE`, label = "Gut Knife", model = 'w_me_gutknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_HUNTSMANKNIFE
        name = 'WEAPON_HUNTSMANKNIFE', hash = `WEAPON_HUNTSMANKNIFE`, label = "Huntsman Knife", model = 'w_me_huntsmanknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_KARAMBITKNIFE
        name = 'WEAPON_KARAMBITKNIFE', hash = `WEAPON_KARAMBITKNIFE`, label = "Karambit Knife", model = 'w_me_karambitknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_SAFARIBFKNIFE
        name = 'WEAPON_SAFARIBFKNIFE', hash = `WEAPON_SAFARIBFKNIFE`, label = "SafariMesh Knife", model = 'w_me_safaribfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_SCORCHEDBFKNIFE
        name = 'WEAPON_SCORCHEDBFKNIFE', hash = `WEAPON_SCORCHEDBFKNIFE`, label = "Scorched Knife", model = 'w_me_scorchedbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_SLAUGHTERBFKNIFE
        name = 'WEAPON_SLAUGHTERBFKNIFE', hash = `WEAPON_SLAUGHTERBFKNIFE`, label = "Slaughter Knife", model = 'w_me_slaughterbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_STAINEDRBFKNIFE
        name = 'WEAPON_STAINEDRBFKNIFE', hash = `WEAPON_STAINEDRBFKNIFE`, label = "Stained Knife", model = 'w_me_stainedbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_URBANRBFKNIFE
        name = 'WEAPON_URBANRBFKNIFE', hash = `WEAPON_URBANRBFKNIFE`, label = "UrbanMasked Knife", model = 'w_me_urbanbfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_BFKNIFE
        name = 'WEAPON_BFKNIFE', hash = `WEAPON_BFKNIFE`, label = "Vanilla Knife", model = 'w_me_vanillabfknife_01',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_COLBATON
        name = 'WEAPON_COLBATON', hash = `WEAPON_COLBATON`, label = "Colbaton", model = 'w_me_colbaton',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_KATANA
        name = 'WEAPON_KATANA', hash = `WEAPON_KATANA`, label = "Katana", model = 'w_me_katana',
        weight = 0.1, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_KATANA2
        name = 'WEAPON_KATANA2', hash = `WEAPON_KATANA2`, label = "Katana2", model = 'w_me_katana2',
        weight = 0.1, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_PERFORATOR
        name = 'WEAPON_PERFORATOR', hash = `WEAPON_PERFORATOR`, label = "The Perforator", model = 'w_me_perforator',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_SHIV
        name = 'WEAPON_SHIV', hash = `WEAPON_SHIV`, label = "Shiv", model = 'w_me_shiv',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_SLEDGEHAMMER
        name = 'WEAPON_SLEDGEHAMMER', hash = `WEAPON_SLEDGEHAMMER`, label = "Sledge Hammer", model = 'w_me_sledgehammer',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    },
    --- Pistol Weapon
    {    -- WEAPON_PISTOL
        name = 'WEAPON_PISTOL', hash = `WEAPON_PISTOL`, label = "Pistol", model = 'w_pi_pistol',
        weight = 5, weightTrunk = 7, difficulty = 2, maxShots = 500,
		components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_PISTOL_CLIP_01`     },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_PISTOL_CLIP_02`     },
			{ name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`         },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP_02`      },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_PISTOL_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PISTOL_MK2
        name = 'WEAPON_PISTOL_MK2', hash = `WEAPON_PISTOL_MK2`, label = "Pistol MK2", model = 'w_pi_pistolmk2',
        weight = 6, weightTrunk = 8, difficulty = 3, maxShots = 500,
		components = {
			{ name = 'clip_default',     label = "Default Clip",     hash = `COMPONENT_PISTOL_MK2_CLIP_01`           },
            { name = 'clip_extended',    label = "Extended Clip",    hash = `COMPONENT_PISTOL_MK2_CLIP_02`           },
            { name = 'clip_tracer',      label = "Tracer Clip",      hash = `COMPONENT_PISTOL_MK2_CLIP_TRACER`       },
            { name = 'clip_incendiary',  label = "Incendiary Clip",  hash = `COMPONENT_PISTOL_MK2_CLIP_INCENDIARY`   },
            { name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = `COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT`  },
            { name = 'clip_fmj',         label = "FMJ Clip",         hash = `COMPONENT_PISTOL_MK2_CLIP_FMJ`          },
            { name = 'mounted_scope',    label = "Mounted Scope",    hash = `COMPONENT_AT_PI_RAIL`                   },
			{ name = 'flashlight',       label = "Flashlight",       hash = `COMPONENT_AT_PI_FLSH_02`                },
            { name = 'suppressor',       label = "Suppressor",       hash = `COMPONENT_AT_PI_SUPP_02`                },
            { name = 'compensator',      label = "Compensator",      hash = `COMPONENT_AT_PI_COMP`                   },
            { name = 'camo1',            label = "Camo 1",           hash = `COMPONENT_PISTOL_MK2_CAMO`              },
            { name = 'camo2',            label = "Camo 2",           hash = `COMPONENT_PISTOL_MK2_CAMO_02`           },
            { name = 'camo3',            label = "Camo 3",           hash = `COMPONENT_PISTOL_MK2_CAMO_03`           },
            { name = 'camo4',            label = "Camo 4",           hash = `COMPONENT_PISTOL_MK2_CAMO_04`           },
            { name = 'camo5',            label = "Camo 5",           hash = `COMPONENT_PISTOL_MK2_CAMO_05`           },
            { name = 'camo6',            label = "Camo 6",           hash = `COMPONENT_PISTOL_MK2_CAMO_06`           },
            { name = 'camo7',            label = "Camo 7",           hash = `COMPONENT_PISTOL_MK2_CAMO_07`           },
            { name = 'camo8',            label = "Camo 8",           hash = `COMPONENT_PISTOL_MK2_CAMO_08`           },
            { name = 'camo9',            label = "Camo 9",           hash = `COMPONENT_PISTOL_MK2_CAMO_09`           },
            { name = 'camo10',           label = "Camo 10",          hash = `COMPONENT_PISTOL_MK2_CAMO_10`           },
            { name = 'camo11',           label = "Camo 11",          hash = `COMPONENT_PISTOL_MK2_CAMO_IND_01`       },
            { name = 'camo12',           label = "Camo 12",          hash = `COMPONENT_PISTOL_MK2_CAMO_SLIDE`        },
            { name = 'camo13',           label = "Camo 13",          hash = `COMPONENT_PISTOL_MK2_CAMO_02_SLIDE`     },
            { name = 'camo14',           label = "Camo 14",          hash = `COMPONENT_PISTOL_MK2_CAMO_03_SLIDE`     },
            { name = 'camo15',           label = "Camo 15",          hash = `COMPONENT_PISTOL_MK2_CAMO_04_SLIDE`     },
            { name = 'camo16',           label = "Camo 16",          hash = `COMPONENT_PISTOL_MK2_CAMO_05_SLIDE`     },
            { name = 'camo17',           label = "Camo 17",          hash = `COMPONENT_PISTOL_MK2_CAMO_06_SLIDE`     },
            { name = 'camo18',           label = "Camo 18",          hash = `COMPONENT_PISTOL_MK2_CAMO_07_SLIDE`     },
            { name = 'camo19',           label = "Camo 19",          hash = `COMPONENT_PISTOL_MK2_CAMO_08_SLIDE`     },
            { name = 'camo20',           label = "Camo 20",          hash = `COMPONENT_PISTOL_MK2_CAMO_09_SLIDE`     },
            { name = 'camo21',           label = "Camo 21",          hash = `COMPONENT_PISTOL_MK2_CAMO_10_SLIDE`     },
            { name = 'camo22',           label = "Camo 22",          hash = `COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE` }
		}, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_COMBATPISTOL
        name = 'WEAPON_COMBATPISTOL', hash = `WEAPON_COMBATPISTOL`, label = "Combat Pistol", model = 'w_pi_combatpistol',
        weight = 5, weightTrunk = 7, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_COMBATPISTOL_CLIP_01`         },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_COMBATPISTOL_CLIP_02`         },
			{ name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`                   },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`                   },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER` }
        }, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_APPISTOL
        name = 'WEAPON_APPISTOL', hash = `WEAPON_APPISTOL`, label = "AP Pistol", model = 'w_pi_appistol',
        weight = 7, weightTrunk = 9, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_APPISTOL_CLIP_01`     },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_APPISTOL_CLIP_02`     },
			{ name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`           },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`           },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_APPISTOL_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_STUNGUN
        name = 'WEAPON_STUNGUN', hash = `WEAPON_STUNGUN`, label = "Taser", model = 'w_pi_stungun',
        weight = 5, weightTrunk = 7, difficulty = 3, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PISTOL50
        name = 'WEAPON_PISTOL50', hash = `WEAPON_PISTOL50`, label = "Pistol .50", model = 'w_pi_pistol50',
        weight = 7, weightTrunk = 9, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_PISTOL50_CLIP_01`     },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_PISTOL50_CLIP_02`     },
			{ name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`           },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`        },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_PISTOL50_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SNSPISTOL
        name = 'WEAPON_SNSPISTOL', hash = `WEAPON_SNSPISTOL`, label = "SNS Pistol", model = 'w_pi_sns_pistol',
        weight = 5, weightTrunk = 7, difficulty = 1, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_SNSPISTOL_CLIP_01`         },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_SNSPISTOL_CLIP_02`         },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_SNSPISTOL_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SNSPISTOL_MK2
        name = 'WEAPON_SNSPISTOL_MK2', hash = `WEAPON_SNSPISTOL_MK2`, label = "SNS Pistol MK2", model = 'w_pi_sns_pistol_mk2',
        weight = 6, weightTrunk = 8, difficulty = 3, maxShots = 500,
        components = {
			{ name = 'clip_default',     label = "Default Clip",     hash = `COMPONENT_SNSPISTOL_MK2_CLIP_01`           },
            { name = 'clip_extended',    label = "Extended Clip",    hash = `COMPONENT_SNSPISTOL_MK2_CLIP_02`           },
            { name = 'clip_tracer',      label = "Tracer Clip",      hash = `COMPONENT_SNSPISTOL_MK2_CLIP_TRACER`       },
            { name = 'clip_incendiary',  label = "Incendiary Clip",  hash = `COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY`   },
            { name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = `COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT`  },
            { name = 'clip_fmj',         label = "FMJ Clip",         hash = `COMPONENT_SNSPISTOL_MK2_CLIP_FMJ`          },
            { name = 'mounted_scope',    label = "Mounted Scope",    hash = `COMPONENT_AT_PI_RAIL_02`                   },
			{ name = 'flashlight',       label = "Flashlight",       hash = `COMPONENT_AT_PI_FLSH_03`                   },
            { name = 'suppressor',       label = "Suppressor",       hash = `COMPONENT_AT_PI_SUPP_02`                   },
            { name = 'compensator',      label = "Compensator",      hash = `COMPONENT_AT_PI_COMP_02`                   },
            { name = 'camo1',            label = "Camo 1",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO`              },
            { name = 'camo2',            label = "Camo 2",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_02`           },
            { name = 'camo3',            label = "Camo 3",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_03`           },
            { name = 'camo4',            label = "Camo 4",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_04`           },
            { name = 'camo5',            label = "Camo 5",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_05`           },
            { name = 'camo6',            label = "Camo 6",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_06`           },
            { name = 'camo7',            label = "Camo 7",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_07`           },
            { name = 'camo8',            label = "Camo 8",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_08`           },
            { name = 'camo9',            label = "Camo 9",           hash = `COMPONENT_SNSPISTOL_MK2_CAMO_09`           },
            { name = 'camo10',           label = "Camo 10",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_10`           },
            { name = 'camo11',           label = "Camo 11",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_IND_01`       },
            { name = 'camo12',           label = "Camo 12",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE`        },
            { name = 'camo13',           label = "Camo 13",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE`     },
            { name = 'camo14',           label = "Camo 14",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE`     },
            { name = 'camo15',           label = "Camo 15",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE`     },
            { name = 'camo16',           label = "Camo 16",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE`     },
            { name = 'camo17',           label = "Camo 17",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE`     },
            { name = 'camo18',           label = "Camo 18",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE`     },
            { name = 'camo19',           label = "Camo 19",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE`     },
            { name = 'camo20',           label = "Camo 20",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE`     },
            { name = 'camo21',           label = "Camo 21",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE`     },
            { name = 'camo22',           label = "Camo 22",          hash = `COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE` }
		}, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_HEAVYPISTOL
        name = 'WEAPON_HEAVYPISTOL', hash = `WEAPON_HEAVYPISTOL`, label = "Heavy Pistol", model = 'w_pi_heavypistol',
        weight = 6, weightTrunk = 8, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_HEAVYPISTOL_CLIP_01`     },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_HEAVYPISTOL_CLIP_02`     },
			{ name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`              },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`              },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_HEAVYPISTOL_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_VINTAGEPISTOL
        name = 'WEAPON_VINTAGEPISTOL', hash = `WEAPON_VINTAGEPISTOL`, label = "Vintage Pistol", model = 'w_pi_vintage_pistol',
        weight = 5, weightTrunk = 7, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_VINTAGEPISTOL_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_VINTAGEPISTOL_CLIP_02` },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`            },
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_FLAREGUN
        name = 'WEAPON_FLAREGUN', hash = `WEAPON_FLAREGUN`, label = "Flaregun", model = 'w_pi_flaregun',
        weight = 5, weightTrunk = 7, difficulty = 3, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MARKSMANPISTOL
        name = 'WEAPON_MARKSMANPISTOL', hash = `WEAPON_MARKSMANPISTOL`, label = "Marksman Pistol", model = 'w_pi_marksmanpistol',
        weight = 8, weightTrunk = 10, difficulty = 3, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_REVOLVER
        name = 'WEAPON_REVOLVER', hash = `WEAPON_REVOLVER`, label = "Heavy Revolver", model = 'w_pi_revolver',
        weight = 8, weightTrunk = 10, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",   hash = `COMPONENT_REVOLVER_CLIP_01`     },
            { name = 'boss_varmod',   label = "VIP Skin",       hash = `COMPONENT_REVOLVER_VARMOD_BOSS` },
            { name = 'goon_varmod',   label = "Bodyguard Skin", hash = `COMPONENT_REVOLVER_VARMOD_GOON` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_REVOLVER_MK2
        name = 'WEAPON_REVOLVER_MK2', hash = `WEAPON_REVOLVER_MK2`, label = "Heavy Revolver MK2", model = 'w_pi_revolvermk2',
        weight = 8, weightTrunk = 10, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default',     label = "Default Clip",     hash = `COMPONENT_REVOLVER_MK2_CLIP_01`          },
            { name = 'clip_tracer',      label = "Tracer Clip",      hash = `COMPONENT_REVOLVER_MK2_CLIP_TRACER`      },
            { name = 'clip_incendiary',  label = "Incendiary Clip",  hash = `COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY`  },
            { name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = `COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT` },
            { name = 'clip_fmj',         label = "FMJ Clip",         hash = `COMPONENT_REVOLVER_MK2_CLIP_FMJ`         },
            { name = 'holo_sight',       label = "Holograph Sight",  hash = `COMPONENT_AT_SIGHTS`                     },
            { name = 'small_scope',      label = "Small Scope",      hash = `COMPONENT_AT_SCOPE_MACRO_MK2`            },
			{ name = 'flashlight',       label = "Flashlight",       hash = `COMPONENT_AT_PI_FLSH`                    },
            { name = 'compensator',      label = "Compensator",      hash = `COMPONENT_AT_PI_COMP_03`                 },
            { name = 'camo1',            label = "Camo 1",           hash = `COMPONENT_REVOLVER_MK2_CAMO`             },
            { name = 'camo2',            label = "Camo 2",           hash = `COMPONENT_REVOLVER_MK2_CAMO_02`          },
            { name = 'camo3',            label = "Camo 3",           hash = `COMPONENT_REVOLVER_MK2_CAMO_03`          },
            { name = 'camo4',            label = "Camo 4",           hash = `COMPONENT_REVOLVER_MK2_CAMO_04`          },
            { name = 'camo5',            label = "Camo 5",           hash = `COMPONENT_REVOLVER_MK2_CAMO_05`          },
            { name = 'camo6',            label = "Camo 6",           hash = `COMPONENT_REVOLVER_MK2_CAMO_06`          },
            { name = 'camo7',            label = "Camo 7",           hash = `COMPONENT_REVOLVER_MK2_CAMO_07`          },
            { name = 'camo8',            label = "Camo 8",           hash = `COMPONENT_REVOLVER_MK2_CAMO_08`          },
            { name = 'camo9',            label = "Camo 9",           hash = `COMPONENT_REVOLVER_MK2_CAMO_09`          },
            { name = 'camo10',           label = "Camo 10",          hash = `COMPONENT_REVOLVER_MK2_CAMO_10`          },
            { name = 'camo11',           label = "Camo 11",          hash = `COMPONENT_REVOLVER_MK2_CAMO_IND_01`      }
		}, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_DOUBLEACTION
        name = 'WEAPON_DOUBLEACTION', hash = `WEAPON_DOUBLEACTION`, label = "Double-Action Revolver", model = 'w_pi_doubleaction',
        weight = 8, weightTrunk = 10, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_RAYPISTOL
        name = 'WEAPON_RAYPISTOL', hash = `WEAPON_RAYPISTOL`, label = "Up-n-Atomizer", model = 'w_pi_raypistol',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'xmas_varmod', label = "Xmas Skin", hash = `COMPONENT_RAYPISTOL_VARMOD_XMAS18`}
        }, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_CERAMICPISTOL
        name = 'WEAPON_CERAMICPISTOL', hash = `WEAPON_CERAMICPISTOL`, label = "Ceramic Pistol", model = 'w_pi_ceramicpistol',
        weight = 7, weightTrunk = 9, difficulty = 3, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_CERAMICPISTOL_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_CERAMICPISTOL_CLIP_02` },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_CERAMICPISTOL_SUPP`    }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_NAVYREVOLVER
        name = 'WEAPON_NAVYREVOLVER', hash = `WEAPON_NAVYREVOLVER`, label = "Navy Revolver", model = 'w_pi_navyrevolver',
        weight = 7, weightTrunk = 10, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_GADGETPISTOL
        name = 'WEAPON_GADGETPISTOL', hash = `WEAPON_GADGETPISTOL`, label = "Perico Pistol", model = 'w_pi_gadgetpistol',
        weight = 7, weightTrunk = 10, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PISTOLXM3
		name = 'WEAPON_PISTOLXM3', hash = `WEAPON_PISTOLXM3`, label = 'WM 29 Pistol', model = 'w_pi_pistol_xm3',
        weight = 5, weightTrunk = 10, difficulty = 4, maxShots = 500,
		components = {
			{ name = 'clip_default', label = 'Default Clip', hash = `COMPONENT_PISTOLXM3_CLIP_01`, type = 'clip' },
			{ name = 'suppressor',   label = 'Suppressor',   hash = `COMPONENT_PISTOLXM3_SUPP`,    type = 'supp' },
		}, tints = Config.DefaultWeaponTints,
	}, { -- WEAPON_DE
        name = 'WEAPON_DE', hash = `WEAPON_DE`, label = "Desert Eagle", model = 'w_pi_de_luxe',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default', label = "DE clip", hash = `COMPONENT_DE_CLIP_01` },
        }
    }, { -- WEAPON_FNX45
        name = 'WEAPON_FNX45', hash = `WEAPON_FNX45`, label = "FN FNX45", model = 'w_pi_fnx45',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default', label = "FNX45 clip", hash = `COMPONENT_FNX45_CLIP_01` },
        }
    }, { -- WEAPON_GLOCK18C
        name = 'WEAPON_GLOCK18C', hash = `WEAPON_GLOCK18C`, label = "Glock18c", model = 'w_pi_glock18c',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default', label = "Default Clip", hash = `COMPONENT_APPISTOL_CLIP_01` },
        }
    }, { -- WEAPON_GLOCK22
        name = 'WEAPON_GLOCK22', hash = `WEAPON_GLOCK22`, label = "GLOCK-22", model = 'w_pi_glock22',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default', label = "Default Clip", hash = `COMPONENT_PISTOL_CLIP_01` },
        }
    }, { -- WEAPON_HK416
        name = 'WEAPON_HK416', hash = `WEAPON_HK416`, label = "HK-416", model = 'w_ar_hk416',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`    },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`      },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`   },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MEDIUM` },
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_HK416_CLIP_01`   },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_HK416_CLIP_02`   },
        }
    }, { -- WEAPON_M9
        name = 'WEAPON_M9', hash = `WEAPON_M9`, label = "M9A3", model = 'w_pi_m9',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_M9_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_M9_CLIP_02` },
        }
    },
    --- SMG Weapon
    {    -- WEAPON_SMG
        name = 'WEAPON_SMG', hash = `WEAPON_SMG`, label = "SMG", model = 'w_sb_smg',
        weight = 9, weightTrunk = 11, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_SMG_CLIP_01`       },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_SMG_CLIP_02`       },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_SMG_CLIP_03`       },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`        },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MACRO_02` },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`        },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_SMG_VARMOD_LUXE`   }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SMG_MK2
        name = 'WEAPON_SMG_MK2', hash = `WEAPON_SMG_MK2`, label = "SMG MK2", model = 'w_sb_smgmk2',
        weight = 9, weightTrunk = 11, difficulty = 3, maxShots = 500,
        components = {
            { name = 'clip_default',     label = "Default Clip",     hash = `COMPONENT_SMG_MK2_CLIP_01`           },
            { name = 'clip_extended',    label = "Extended Clip",    hash = `COMPONENT_SMG_MK2_CLIP_02`           },
            { name = 'clip_tracer',      label = "Tracer Clip",      hash = `COMPONENT_SMG_MK2_CLIP_TRACER`       },
            { name = 'clip_incendiary',  label = "Incendiary Clip",  hash = `COMPONENT_SMG_MK2_CLIP_INCENDIARY`   },
            { name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = `COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT`  },
            { name = 'clip_fmj',         label = "FMJ Clip",         hash = `COMPONENT_SMG_MK2_CLIP_FMJ`          },
            { name = 'holo_sight',       label = "Holograph Sight",  hash = `COMPONENT_AT_SIGHTS_SMG`             },
            { name = 'small_scope',      label = "Small Scope",      hash = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2` },
            { name = 'medium_scope',     label = "Medium Scope",     hash = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2`    },
            { name = 'flashlight',       label = "Flashlight",       hash = `COMPONENT_AT_AR_FLSH`                },
            { name = 'suppressor',       label = "Suppressor",       hash = `COMPONENT_AT_PI_SUPP`                },
            { name = 'muzzle1',          label = "Muzzle Brake 1",   hash = `COMPONENT_AT_MUZZLE_01`              },
            { name = 'muzzle2',          label = "Muzzle Brake 2",   hash = `COMPONENT_AT_MUZZLE_02`              },
            { name = 'muzzle3',          label = "Muzzle Brake 3",   hash = `COMPONENT_AT_MUZZLE_03`              },
            { name = 'muzzle4',          label = "Muzzle Brake 4",   hash = `COMPONENT_AT_MUZZLE_04`              },
            { name = 'muzzle5',          label = "Muzzle Brake 5",   hash = `COMPONENT_AT_MUZZLE_05`              },
            { name = 'muzzle6',          label = "Muzzle Brake 6",   hash = `COMPONENT_AT_MUZZLE_06`              },
            { name = 'muzzle7',          label = "Muzzle Brake 7",   hash = `COMPONENT_AT_MUZZLE_07`              },
            { name = 'default_barrel',   label = "Default Barrel",   hash = `COMPONENT_AT_SB_BARREL_01`           },
            { name = 'heavy_barrel',     label = "Heavy Barrel",     hash = `COMPONENT_AT_SB_BARREL_02`           },
            { name = 'camo1',            label = "Camo 1",           hash = `COMPONENT_SMG_MK2_CAMO`              },
            { name = 'camo2',            label = "Camo 2",           hash = `COMPONENT_SMG_MK2_CAMO_02`           },
            { name = 'camo3',            label = "Camo 3",           hash = `COMPONENT_SMG_MK2_CAMO_03`           },
            { name = 'camo4',            label = "Camo 4",           hash = `COMPONENT_SMG_MK2_CAMO_04`           },
            { name = 'camo5',            label = "Camo 5",           hash = `COMPONENT_SMG_MK2_CAMO_05`           },
            { name = 'camo6',            label = "Camo 6",           hash = `COMPONENT_SMG_MK2_CAMO_06`           },
            { name = 'camo7',            label = "Camo 7",           hash = `COMPONENT_SMG_MK2_CAMO_07`           },
            { name = 'camo8',            label = "Camo 8",           hash = `COMPONENT_SMG_MK2_CAMO_08`           },
            { name = 'camo9',            label = "Camo 9",           hash = `COMPONENT_SMG_MK2_CAMO_09`           },
            { name = 'camo10',           label = "Camo 10",          hash = `COMPONENT_SMG_MK2_CAMO_10`           },
            { name = 'camo11',           label = "Camo 11",          hash = `COMPONENT_SMG_MK2_CAMO_IND_01`       }
		}, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_ASSAULTSMG
        name = 'WEAPON_ASSAULTSMG', hash = `WEAPON_ASSAULTSMG`, label = "Assault SMG", model = 'w_sb_assaultsmg',
        weight = 10, weightTrunk = 12, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_ASSAULTSMG_CLIP_01`         },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_ASSAULTSMG_CLIP_02`         },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`                 },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MACRO`             },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`              },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MICROSMG
        name = 'WEAPON_MICROSMG', hash = `WEAPON_MICROSMG`, label = "Micro SMG", model = 'w_sb_microsmg',
        weight = 9, weightTrunk = 11, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MICROSMG_CLIP_01`     },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MICROSMG_CLIP_02`     },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_PI_FLSH`           },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MACRO`       },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`        },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_MICROSMG_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_COMBATPDW
        name = 'WEAPON_COMBATPDW', hash = `WEAPON_COMBATPDW`, label = "Combat PDW", model = 'w_sb_pdw',
        weight = 10, weightTrunk = 12, difficulty = 3, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_COMBATPDW_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_COMBATPDW_CLIP_02` },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_COMBATPDW_CLIP_03` },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`        },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`      },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL`    }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MACHINEPISTOL
        name = 'WEAPON_MACHINEPISTOL', hash = `WEAPON_MACHINEPISTOL`, label = "Machine Pistol", model = 'w_sb_mp5',
        weight = 10, weightTrunk = 12, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MACHINEPISTOL_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MACHINEPISTOL_CLIP_02` },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_MACHINEPISTOL_CLIP_03` },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_PI_SUPP`            }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MINISMG
        name = 'WEAPON_MINISMG', hash = `WEAPON_MINISMG`, label = "Mini SMG", model = 'w_sb_minismg',
        weight = 10, weightTrunk = 12, difficulty = 3, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MINISMG_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MINISMG_CLIP_02` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_TECPISTOL
        name = 'WEAPON_TECPISTOL', hash = `WEAPON_TECPISTOL`, label = "Tactical SMG", model = 'w_pi_pistolsmg_m31',
        weight = 10, weightTrunk = 12, difficulty = 3, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_RAYCARBINE
        name = 'WEAPON_RAYCARBINE', hash = `WEAPON_RAYCARBINE`, label = "Unholy Hellbringer", model = 'w_pi_raygun',
        weight = 10, weightTrunk = 12, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MAC10
        name = 'WEAPON_MAC10', hash = `WEAPON_MAC10`, label = "MAC-10", model = 'w_sb_mac10',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {}
    }, { -- WEAPON_MP5
        name = 'WEAPON_MP5', hash = `WEAPON_MP5`, label = "MP5", model = 'w_sb_mp5',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip", hash = `COMPONENT_SMG_CLIP_01` },
        }
    }, { -- WEAPON_MP9
        name = 'WEAPON_MP9', hash = `WEAPON_MP9`, label = "MP9", model = 'w_sb_mp9',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`  },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MACRO` },
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MP9_CLIP_01`    },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MP9_CLIP_02`    },
        }
    }, { -- WEAPON_UZI
        name = 'WEAPON_UZI', hash = `WEAPON_UZI`, label = "UZI", model = 'w_sb_uzi',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_UZI_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_UZI_CLIP_02` },
        }
    },
    --- ShotGun Weapon
    {    -- WEAPON_PUMPSHOTGUN
        name = 'WEAPON_PUMPSHOTGUN', hash = `WEAPON_PUMPSHOTGUN`, label = "Pump Shotgun", model = 'w_sg_pumpshotgun',
        weight = 15, weightTrunk = 17, difficulty = 3, maxShots = 500,
        components = {
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH` },
			{ name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_SR_SUPP` },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PUMPSHOTGUN_MK2
        name = 'WEAPON_PUMPSHOTGUN_MK2', hash = `WEAPON_PUMPSHOTGUN_MK2`, label = "Pump Shotgun MK2", model = 'w_sg_pumpshotgunmk2',
        weight = 17, weightTrunk = 20, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_01`           },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY`   },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING`},
            { name = 'clip_hollowpoint',   label = "Hollowpoint Clip",   hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT`  },
            { name = 'clip_explosive',     label = "Explosive Clip",     hash = `COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE`    },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                         },
            { name = 'small_scope',        label = "Small Scope",        hash = `COMPONENT_AT_SCOPE_MACRO_MK2`                },
            { name = 'medium_scope',       label = "Medium Scope",       hash = `COMPONENT_AT_SCOPE_SMALL_MK2`                },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                        },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_SR_SUPP_03`                     },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_08`                      },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO`              },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_02`           },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_03`           },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_04`           },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_05`           },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_06`           },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_07`           },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_08`           },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_09`           },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_10`           },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01`       }
		}, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_SAWNOFFSHOTGUN
        name = 'WEAPON_SAWNOFFSHOTGUN', hash = `WEAPON_SAWNOFFSHOTGUN`, label = "Sawed-Off Shotgun", model = 'w_sg_sawnoff',
        weight = 15, weightTrunk = 17, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'luxe_varmod', label = "Luxary Skin", hash = `COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_ASSAULTSHOTGUN
        name = 'WEAPON_ASSAULTSHOTGUN', hash = `WEAPON_ASSAULTSHOTGUN`, label = "Assault Shotgun", model = 'w_sg_assaultshotgun',
        weight = 15, weightTrunk = 17, difficulty = 2, maxShots = 500,
        components = {
			{ name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_ASSAULTSHOTGUN_CLIP_02` },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`             },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`             },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`           }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_BULLPUPSHOTGUN
        name = 'WEAPON_BULLPUPSHOTGUN', hash = `WEAPON_BULLPUPSHOTGUN`, label = "Bullpup Shotgun", model = 'w_sg_bullpupshotgun',
        weight = 15, weightTrunk = 17, difficulty = 2, maxShots = 500,
        components = {
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`    },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02` },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`  }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MUSKET
        name = 'WEAPON_MUSKET', hash = `WEAPON_MUSKET`, label = "Musket", model = 'w_ar_musket',
        weight = 15, weightTrunk = 17, difficulty = 2, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_HEAVYSHOTGUN
        name = 'WEAPON_HEAVYSHOTGUN', hash = `WEAPON_HEAVYSHOTGUN`, label = "Heavy Shotgun", model = 'w_sg_heavyshotgun',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_HEAVYSHOTGUN_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_HEAVYSHOTGUN_CLIP_02` },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_HEAVYSHOTGUN_CLIP_03` },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`           },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`        },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`         }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_DBSHOTGUN
        name = 'WEAPON_DBSHOTGUN', hash = `WEAPON_DBSHOTGUN`, label = "Double-Barrel Shotgun", model = 'w_sg_dbshotgun',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_AUTOSHOTGUN
        name = 'WEAPON_AUTOSHOTGUN', hash = `WEAPON_AUTOSHOTGUN`, label = "Auto Shotgun", model = 'w_sg_autoshotgun',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_COMBATSHOTGUN
        name = 'WEAPON_COMBATSHOTGUN', hash = `WEAPON_COMBATSHOTGUN`, label = "Combat Shotgun", model = 'w_sg_combatshotgun',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {}, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_SWEEPERSHOTGUN', hash = `WEAPON_SWEEPERSHOTGUN`, label = "Sweeper Shotgun", model = 'w_sg_sweeper',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default', label = "Default Clip", hash = `COMPONENT_SWEEPERSHOTGUN_CLIP_01` },
            { name = 'flashlight',   label = "Flashlight",   hash = `COMPONENT_AT_AR_FLSH`             },
            { name = 'scope',        label = "Scope",        hash = `COMPONENT_AT_SCOPE_SMALL`         },
        }, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MOSSBERG
        name = 'WEAPON_MOSSBERG', hash = `WEAPON_MOSSBERG`, label = "Mossberg 500", model = 'w_sg_mossberg',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {}
    }, { -- WEAPON_REMINGTON
        name = 'WEAPON_REMINGTON', hash = `WEAPON_REMINGTON`, label = "Remington 870", model = 'w_sg_remington',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {}
    },
    --- Rifle Weapon
    {    -- WEAPON_ASSAULTRIFLE
        name = 'WEAPON_ASSAULTRIFLE', hash = `WEAPON_ASSAULTRIFLE`, label = "Assault Rifle", model = 'w_ar_assaultrifle',
        weight = 13, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_ASSAULTRIFLE_CLIP_01`     },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_ASSAULTRIFLE_CLIP_02`     },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_ASSAULTRIFLE_CLIP_03`     },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`               },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MACRO`           },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`            },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`             },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_ASSAULTRIFLE_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    },
    --- Rifle Weapon
    {    -- WEAPON_ASSAULTRIFLE
        name = 'WEAPON_AKBC', hash = `WEAPON_AKBC`, label = "Assault Rifle BC", model = 'w_ar_birthdaycake', skin = true,
        weight = 13, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_ASSAULTRIFLE_CLIP_01`     },
            { name = 'suppressor',    label = "Suppressor",    hash = `w_at_ar_pink_supp_02`            },
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_ASSAULTRIFLE_MK2
        name = 'WEAPON_ASSAULTRIFLE_MK2', hash = `WEAPON_ASSAULTRIFLE_MK2`, label = "Assault Rifle MK2", model = 'w_ar_assaultriflemk2',
        weight = 15, weightTrunk = 17, difficulty = 3, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                           },
            { name = 'small_scope',        label = "Small Scope",        hash = `COMPONENT_AT_SCOPE_MACRO_MK2`                  },
            { name = 'large_scope',        label = "Large Scope",        hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2`                 },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                     },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                          },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP_02`                       },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                        },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                        },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                        },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                        },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                        },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                        },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                        },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_AR_BARREL_01`                     },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_AR_BARREL_02`                     },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_CARBINERIFLE
        name = 'WEAPON_CARBINERIFLE', hash = `WEAPON_CARBINERIFLE`, label = "Carbine Rifle", model = 'w_ar_carbinerifle',
        weight = 14, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_CARBINERIFLE_CLIP_01`     },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_CARBINERIFLE_CLIP_02`     },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_CARBINERIFLE_CLIP_03`     },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`               },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MEDIUM`          },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`               },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`             },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_CARBINERIFLE_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_CARBINERIFLE_MK2
        name = 'WEAPON_CARBINERIFLE_MK2', hash = `WEAPON_CARBINERIFLE_MK2`, label = "Carbine Rifle MK2", model = 'w_ar_carbineriflemk2',
        weight = 15, weightTrunk = 17, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                           },
            { name = 'small_scope',        label = "Small Scope",        hash = `COMPONENT_AT_SCOPE_MACRO_MK2`                  },
            { name = 'large_scope',        label = "Large Scope",        hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2`                 },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                     },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                          },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP`                          },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                        },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                        },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                        },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                        },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                        },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                        },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                        },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_CR_BARREL_01`                     },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_CR_BARREL_02`                     },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_ADVANCEDRIFLE
        name = 'WEAPON_ADVANCEDRIFLE', hash = `WEAPON_ADVANCEDRIFLE`, label = "Advanced Rifle", model = 'w_ar_advancedrifle',
        weight = 14, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_ADVANCEDRIFLE_CLIP_01`     },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_ADVANCEDRIFLE_CLIP_02`     },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`                },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL`            },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`                },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SPECIALCARBINE
        name = 'WEAPON_SPECIALCARBINE', hash = `WEAPON_SPECIALCARBINE`, label = "Special Carbine", model = 'w_ar_specialcarbine',
        weight = 14, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_SPECIALCARBINE_CLIP_01`         },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_SPECIALCARBINE_CLIP_02`         },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_SPECIALCARBINE_CLIP_03`         },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`                     },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MEDIUM`                },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP_02`                  },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`                   },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SPECIALCARBINE_MK2
        name = 'WEAPON_SPECIALCARBINE_MK2', hash = `WEAPON_SPECIALCARBINE_MK2`, label = "Special Carbine MK2", model = 'w_ar_specialcarbinemk2',
        weight = 15, weightTrunk = 18, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                             },
            { name = 'small_scope',        label = "Small Scope",        hash = `COMPONENT_AT_SCOPE_MACRO_MK2`                    },
            { name = 'large_scope',        label = "Large Scope",        hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2`                   },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                       },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                            },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP_02`                         },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                          },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                          },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                          },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                          },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                          },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                          },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                          },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_SC_BARREL_01`                       },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_SC_BARREL_02`                       },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,        
    }, { -- WEAPON_BULLPUPRIFLE
        name = 'WEAPON_BULLPUPRIFLE', hash = `WEAPON_BULLPUPRIFLE`, label = "Bullpup Rifle", model = 'w_ar_bullpuprifle',
        weight = 14, weightTrunk = 16, difficulty = 3, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_BULLPUPRIFLE_CLIP_01`    },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_BULLPUPRIFLE_CLIP_02`    },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`              },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL`          },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`              },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`            },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_BULLPUPRIFLE_VARMOD_LOW` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_BULLPUPRIFLE_MK2
        name = 'WEAPON_BULLPUPRIFLE_MK2', hash = `weapon_bullpuprifle_mk2`, label = "Bullpup Rifle MK2", model = 'w_ar_bullpupriflemk2',
        weight = 15, weightTrunk = 18, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                           },
            { name = 'small_scope',        label = "Small Scope",        hash = `COMPONENT_AT_SCOPE_MACRO_02_MK2`               },
            { name = 'medium_scope',       label = "Medium Scope",       hash = `COMPONENT_AT_SCOPE_SMALL_MK2`                  },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                     },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                          },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP`                          },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                        },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                        },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                        },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                        },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                        },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                        },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                        },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_BP_BARREL_01`                     },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_BP_BARREL_02`                     },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_COMPACTRIFLE
        name = 'WEAPON_COMPACTRIFLE', hash = `WEAPON_COMPACTRIFLE`, label = "Compact Rifle", model = 'w_ar_carbinerifle',
        weight = 14, weightTrunk = 16, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_COMPACTRIFLE_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_COMPACTRIFLE_CLIP_02` },
            { name = 'clip_drum',     label = "Drum Clip",     hash = `COMPONENT_COMPACTRIFLE_CLIP_03` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MILITARYRIFLE
        name = 'WEAPON_MILITARYRIFLE', hash = `WEAPON_MILITARYRIFLE`, label = "Military Rifle", model = 'w_ar_milrifle',
        weight = 15, weightTrunk = 17, difficulty = 3, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MILITARYRIFLE_CLIP_01`  },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MILITARYRIFLE_CLIP_02`  },
            { name = 'iron_sight',    label = "Iron Sight",    hash = `COMPONENT_MILITARYRIFLE_SIGHT_01` },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL`         },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`             },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`             }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_TACTICALRIFLE
		name = 'WEAPON_TACTICALRIFLE', hash = `WEAPON_TACTICALRIFLE`, label = 'Service Carbine', model = 'w_ar_carbinerifle_reh',
        weight = 5, weightTrunk = 10, difficulty = 4, maxShots = 500,
		components = {
			{ name = 'grip',          label = 'Grip',          hash = `COMPONENT_AT_AR_AFGRIP`,           type = 'grip' },
			{ name = 'clip_default',  label = 'Default Clip',  hash = `COMPONENT_TACTICALRIFLE_CLIP_01`,  type = 'clip' },
			{ name = 'clip_extended', label = 'Extended Clip', hash = `COMPONENT_TACTICALRIFLE_CLIP_02`,  type = 'clip' },
			{ name = 'flashlight',    label = 'Flashlight',    hash = `COMPONENT_AT_AR_FLSH_REH`,         type = 'flash'},
			{ name = 'suppressor',    label = 'Suppressor',    hash = `COMPONENT_AT_AR_SUPP_02`,          type = 'supp' }
		}, tints = Config.DefaultWeaponTints,
	}, { -- WEAPON_HEAVYRIFLE
		name = 'WEAPON_HEAVYRIFLE', hash = `WEAPON_HEAVYRIFLE`, label = 'Heavy Rifle', model = 'w_ar_heavyrifleh',
		weight = 5, weightTrunk = 10, difficulty = 4, maxShots = 500,
		components = {
			{ name = 'clip_default',  label = 'Default Clip',  hash = `COMPONENT_HEAVYRIFLE_CLIP_01`,  type = 'clip'   },
			{ name = 'clip_extended', label = 'Extended Clip', hash = `COMPONENT_HEAVYRIFLE_CLIP_02`,  type = 'clip'   },
			{ name = 'iron_sight',    label = 'Iron Sight',    hash = `COMPONENT_HEAVYRIFLE_SIGHT_01`, type = 'sight'  },
			{ name = 'flashlight',    label ='Flashlight',     hash = `COMPONENT_AT_AR_FLSH`,          type = 'flash'  },
			{ name = 'scope',         label = 'Scope',         hash = `COMPONENT_AT_SCOPE_MEDIUM`,     type = 'scope'  },
			{ name = 'grip',          label = 'Grip',          hash = `COMPONENT_AT_AR_AFGRIP`,        type = 'grip'   },
			{ name = 'suppressor',    label = 'Suppressor',    hash = `COMPONENT_AT_AR_SUPP`,          type = 'supp'   },
			{ name = 'camo1',         label = 'Camo 1',        hash = `COMPONENT_HEAVYRIFLE_CAMO1`,    type = 'finish' },
		}, tints = Config.DefaultWeaponTints,
	}, { -- WEAPON_AK47
        name = 'WEAPON_AK47', hash = `WEAPON_AK47`, label = "AK-47", model = 'w_ar_ak47',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Ak47 Clip",  hash = `COMPONENT_AK47_CLIP_01` },
            { name = 'clip_extended', label = "Ak47 Clip2", hash = `COMPONENT_AK47_CLIP_02` },
        }
    }, { -- WEAPON_AK74
        name = 'WEAPON_AK74', hash = `WEAPON_AK74`, label = "AK-74", model = 'w_ar_ak74',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default', label = "Default Clip", hash = `COMPONENT_ASSAULTRIFLE_CLIP_01` },
        }
    }, { -- WEAPON_AKS74
        name = 'WEAPON_AKS74', hash = `WEAPON_AKS74`, label = "AKS74-U", model = 'w_ar_assaultrifle_aks74',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default', label = "Default Clip", hash = `COMPONENT_ASSAULTRIFLE_CLIP_01` },
        }
    }, { -- WEAPON_AR15
        name = 'WEAPON_AR15', hash = `WEAPON_AR15`, label = "AR-15", model = 'w_ar_ar15',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'grip',         label = "Grip",       hash = `COMPONENT_AT_AR_AFGRIP` },
            { name = 'clip_default', label = "ar47 Clip",  hash = `COMPONENT_AR15_CLIP_01` },
            { name = 'scope',        label = 'Scope',      hash = `COMPONENT_AT_SCOPE_MEDIUM`, type = 'scope' },
        }
    }, { -- WEAPON_M4
        name = 'WEAPON_M4', hash = `WEAPON_M4`, label = "M4", model = 'w_ar_m4',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_M4_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_M4_CLIP_02` },
        }
    }, { -- WEAPON_M70
        name = 'WEAPON_M70', hash = `WEAPON_M70`, label = "M70", model = 'w_ar_m70',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_M70_CLIP_01` },
        }
    }, { -- WEAPON_SCARH
        name = 'WEAPON_SCARH', hash = `WEAPON_SCARH`, label = "SCAR-H", model = 'w_ar_scarh',
        weight = 10, weightTrunk = 15, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_SCARH_CLIP_01` },
			{ name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_SCARH_CLIP_02` },
        }
    },
    --- MG Weapon
    {    -- WEAPON_MG
        name = 'WEAPON_MG', hash = `WEAPON_MG`, label = "MG", model = 'w_mg_mg',
        weight = 15, weightTrunk = 20, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MG_CLIP_01`         },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MG_CLIP_02`         },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL_02`  },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_MG_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_COMBATMG
        name = 'WEAPON_COMBATMG', hash = `WEAPON_COMBATMG`, label = "Combat MG", model = 'w_mg_combatmg',
        weight = 15, weightTrunk = 20, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_COMBATMG_CLIP_01`         },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_COMBATMG_CLIP_02`         },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_MEDIUM`          },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`             },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_COMBATMG_VARMOD_LOWRIDER` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_COMBATMG_MK2
        name = 'WEAPON_COMBATMG_MK2', hash = `WEAPON_COMBATMG_MK2`, label = "Combat MG MK2", model = 'w_mg_combatmgmk2',
        weight = 17, weightTrunk = 20, difficulty = 4, maxShots = 500,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_COMBATMG_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_COMBATMG_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_COMBATMG_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_COMBATMG_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                       },
            { name = 'medium_scope',       label = "Medium Scope",       hash = `COMPONENT_AT_SCOPE_SMALL_MK2`              },
            { name = 'large_scope',        label = "Large Scope",        hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2`             },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                 },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                      },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP`                      },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                    },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                    },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                    },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                    },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                    },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                    },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                    },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_MG_BARREL_01`                 },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_MG_BARREL_02`                 },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_COMBATMG_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_COMBATMG_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_COMBATMG_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_COMBATMG_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_COMBATMG_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_COMBATMG_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_COMBATMG_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_COMBATMG_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_COMBATMG_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_COMBATMG_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_COMBATMG_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_GUSENBERG
        name = 'WEAPON_GUSENBERG', hash = `WEAPON_GUSENBERG`, label = "Gusenberg Sweeper", model = 'w_sb_gusenberg',
        weight = 14, weightTrunk = 16, difficulty = 2, maxShots = 500,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_GUSENBERG_CLIP_01` },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_GUSENBERG_CLIP_02` }
		}, tints = Config.DefaultWeaponTints,
    },
    --- Sniper Weapon
    {    -- WEAPON_SNIPERRIFLE
        name = 'WEAPON_SNIPERRIFLE', hash = `WEAPON_SNIPERRIFLE`, label = "Sniper Rifle", model = 'w_sr_sniperrifle',
        weight = 1, weightTrunk = 15, difficulty = 4,
        components = {
            { name = 'clip_default',   label = "Default Clip",   hash = `COMPONENT_SNIPERRIFLE_CLIP_01`     },
            { name = 'suppressor',     label = "Suppressor",     hash = `COMPONENT_AT_AR_SUPP_02`           },
            { name = 'scope',          label = "Scope",          hash = `COMPONENT_AT_SCOPE_LARGE`          },
            { name = 'advanced_scope', label = "Advanced Scope", hash = `COMPONENT_AT_SCOPE_MAX`            },
			{ name = 'luxe_varmod',    label = "Luxary Skin",    hash = `COMPONENT_SNIPERRIFLE_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_HEAVYSNIPER
        name = 'WEAPON_HEAVYSNIPER', hash = `WEAPON_HEAVYSNIPER`, label = "Heavy Sniper", model = 'w_sr_heavysniper',
        weight = 1, weightTrunk = 15, difficulty = 4,
        components = {
            { name = 'clip_default',   label = "Default Clip",   hash = `COMPONENT_HEAVYSNIPER_CLIP_01` },
            { name = 'scope',          label = "Scope",          hash = `COMPONENT_AT_SCOPE_LARGE`      },
            { name = 'advanced_scope', label = "Advanced Scope", hash = `COMPONENT_AT_SCOPE_MAX`        }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_HEAVYSNIPER_MK2
        name = 'WEAPON_HEAVYSNIPER_MK2', hash = `WEAPON_HEAVYSNIPER_MK2`, label = "Heavy Sniper MK2", model = 'w_sr_heavysnipermk2',
        weight = 1, weightTrunk = 20, difficulty = 4,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_02`            },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ`           },
            { name = 'clip_explosive',     label = "Explosive Clip",     hash = `COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE`     },
            { name = 'zoom_scope',         label = "Zoom Scope",         hash = `COMPONENT_AT_SCOPE_LARGE_MK2`                 },
            { name = 'advanced_scope',     label = "Advanced Scope",     hash = `COMPONENT_AT_SCOPE_MAX`                       },
            { name = 'nv_scope',           label = "Night Vision Scope", hash = `COMPONENT_AT_SCOPE_NV`                        },
            { name = 'thermal_scope',      label = "Thermal Scope",      hash = `COMPONENT_AT_SCOPE_THERMAL`                   },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_SR_SUPP_03`                      },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_08`                       },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_09`                       },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_SR_BARREL_01`                    },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_SR_BARREL_02`                    },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_MARKSMANRIFLE
        name = 'WEAPON_MARKSMANRIFLE', hash = `WEAPON_MARKSMANRIFLE`, label = "Marksman Rifle", model = 'w_sr_marksmanrifle',
        weight = 14, weightTrunk = 16, difficulty = 4,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_MARKSMANRIFLE_CLIP_01`     },
            { name = 'clip_extended', label = "Extended Clip", hash = `COMPONENT_MARKSMANRIFLE_CLIP_02`     },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`                },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM` },
            { name = 'suppressor',    label = "Suppressor",    hash = `COMPONENT_AT_AR_SUPP`                },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`              },
			{ name = 'luxe_varmod',   label = "Luxary Skin",   hash = `COMPONENT_MARKSMANRIFLE_VARMOD_LUXE` }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MARKSMANRIFLE_MK2
        name = 'WEAPON_MARKSMANRIFLE_MK2', hash = `WEAPON_MARKSMANRIFLE_MK2`, label = "Marksman Rifle MK2", model = 'w_sr_marksmanriflemk2',
        weight = 15, weightTrunk = 17, difficulty = 4,
        components = {
            { name = 'clip_default',       label = "Default Clip",       hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_01`            },
            { name = 'clip_extended',      label = "Extended Clip",      hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_02`            },
            { name = 'clip_tracer',        label = "Tracer Clip",        hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER`        },
            { name = 'clip_incendiary',    label = "Incendiary Clip",    hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY`    },
            { name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING` },
            { name = 'clip_fmj',           label = "FMJ Clip",           hash = `COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ`           },
            { name = 'holo_sight',         label = "Holograph Sight",    hash = `COMPONENT_AT_SIGHTS`                            },
            { name = 'large_scope',        label = "Large Scope",        hash = `COMPONENT_AT_SCOPE_MEDIUM_MK2`                  },
            { name = 'zoom_scope',         label = "Zoom Scope",         hash = `COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2`        },
            { name = 'grip',               label = "Grip",               hash = `COMPONENT_AT_AR_AFGRIP_02`                      },
            { name = 'flashlight',         label = "Flashlight",         hash = `COMPONENT_AT_AR_FLSH`                           },
            { name = 'suppressor',         label = "Suppressor",         hash = `COMPONENT_AT_AR_SUPP`                           },
            { name = 'muzzle1',            label = "Muzzle Brake 1",     hash = `COMPONENT_AT_MUZZLE_01`                         },
            { name = 'muzzle2',            label = "Muzzle Brake 2",     hash = `COMPONENT_AT_MUZZLE_02`                         },
            { name = 'muzzle3',            label = "Muzzle Brake 3",     hash = `COMPONENT_AT_MUZZLE_03`                         },
            { name = 'muzzle4',            label = "Muzzle Brake 4",     hash = `COMPONENT_AT_MUZZLE_04`                         },
            { name = 'muzzle5',            label = "Muzzle Brake 5",     hash = `COMPONENT_AT_MUZZLE_05`                         },
            { name = 'muzzle6',            label = "Muzzle Brake 6",     hash = `COMPONENT_AT_MUZZLE_06`                         },
            { name = 'muzzle7',            label = "Muzzle Brake 7",     hash = `COMPONENT_AT_MUZZLE_07`                         },
            { name = 'default_barrel',     label = "Default Barrel",     hash = `COMPONENT_AT_MRFL_BARREL_01`                    },
            { name = 'heavy_barrel',       label = "Heavy Barrel",       hash = `COMPONENT_AT_MRFL_BARREL_02`                    },
            { name = 'camo1',              label = "Camo 1",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO`               },
            { name = 'camo2',              label = "Camo 2",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_02`            },
            { name = 'camo3',              label = "Camo 3",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_03`            },
            { name = 'camo4',              label = "Camo 4",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_04`            },
            { name = 'camo5',              label = "Camo 5",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_05`            },
            { name = 'camo6',              label = "Camo 6",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_06`            },
            { name = 'camo7',              label = "Camo 7",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_07`            },
            { name = 'camo8',              label = "Camo 8",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_08`            },
            { name = 'camo9',              label = "Camo 9",             hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_09`            },
            { name = 'camo10',             label = "Camo 10",            hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_10`            },
            { name = 'camo11',             label = "Camo 11",            hash = `COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01`        }
        }, tints = Config.DefaultWeaponTintsMK2,
    }, { -- WEAPON_PRECISIONRIFLE
		name = 'WEAPON_PRECISIONRIFLE', hash = `WEAPON_PRECISIONRIFLE`, label = 'Precision Rifle', model = 'w_sr_precisionrifle_reh',
		weight = 5, weightTrunk = 10, difficulty = 4,
		components = {
			{ name = 'clip_default',  label = 'Default Clip',  hash = `COMPONENT_PRECISIONRIFLE_CLIP_01`,  type = 'clip' },
		}, tints = Config.DefaultWeaponTints,
	}, { -- WEAPON_ESNIPERRIFLE
        name = 'WEAPON_ESNIPERRIFLE', hash = `WEAPON_ESNIPERRIFLE`, label = "Epic Sniperrifle", model = 'w_sr_esniperrifle',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_JOSAKK
        name = 'WEAPON_JOSAKK', hash = `WEAPON_JOSAKK`, label = "Liquit Sniperrifle", model = 'w_r_josakk',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}
    }, { -- WEAPON_HUNTINGRIFLE
        name = 'WEAPON_HUNTINGRIFLE', hash = `WEAPON_HUNTINGRIFLE`, label = "Hunting Rifle", model = 'w_sr_huntingrifle',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {
            { name = 'scope',        label = "Scope",        hash = `COMPONENT_AT_SCOPE_LARGE` },
			{ name = 'clip_default', label = "Default Clip", hash = `COMPONENT_HUNTINGRIFLE_CLIP_01` },
        }
    }, { -- WEAPON_MK14
        name = 'WEAPON_MK14', hash = `WEAPON_MK14`, label = "MK14", model = 'w_sr_mk14',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {
            { name = 'clip_default',  label = "Default Clip", hash = `COMPONENT_MARKSMANRIFLE_CLIP_01` },
        }
    },
    --- LAUNCHER Weapon
    {    -- WEAPON_RPG
        name = 'WEAPON_RPG', hash = `WEAPON_RPG`, label = "RPG", model = 'w_lr_rpg',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_GRENADELAUNCHER
        name = 'WEAPON_GRENADELAUNCHER', hash = `WEAPON_GRENADELAUNCHER`, label = "Grenade Launcher", model = 'w_lr_grenadelauncher',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {
            { name = 'clip_default',  label = "Default Clip",  hash = `COMPONENT_GRENADELAUNCHER_CLIP_01` },
            { name = 'flashlight',    label = "Flashlight",    hash = `COMPONENT_AT_AR_FLSH`              },
            { name = 'scope',         label = "Scope",         hash = `COMPONENT_AT_SCOPE_SMALL`          },
            { name = 'grip',          label = "Grip",          hash = `COMPONENT_AT_AR_AFGRIP`            }
		}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_GRENADELAUNCHER_SMOKE
        name = 'WEAPON_GRENADELAUNCHER_SMOKE', hash = `WEAPON_GRENADELAUNCHER_SMOKE`, label = "Grenade Launcher Smoke", model = 'w_lr_grenadelauncher',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MINIGUN
        name = 'WEAPON_MINIGUN', hash = `WEAPON_MINIGUN`, label = "Minigun", model = 'w_mg_minigun',
        weight = 1, weightTrunk = 15, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_FIREWORK
        name = 'WEAPON_FIREWORK', hash = `WEAPON_FIREWORK`, label = "Firework", model = 'w_lr_firework',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_RAILGUN
        name = 'WEAPON_RAILGUN', hash = `WEAPON_RAILGUN`, label = "Railgun", model = 'w_lr_railgun',
        weight = 14, weightTrunk = 16, difficulty = 3,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_HOMINGLAUNCHER
        name = 'WEAPON_HOMINGLAUNCHER', hash = `WEAPON_HOMINGLAUNCHER`, label = "Homing Launcher", model = 'w_lr_homing',
        weight = 14, weightTrunk = 16, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_COMPACTLAUNCHER
        name = 'WEAPON_COMPACTLAUNCHER', hash = `WEAPON_COMPACTLAUNCHER`, label = "Compact Launcher", model = 'w_lr_compactlauncher',
        weight = 14, weightTrunk = 16, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_RAYMINIGUN
        name = 'WEAPON_RAYMINIGUN', hash = `WEAPON_RAYMINIGUN`, label = "Widowmaker", model = 'w_mg_rayminigun',
        weight = 14, weightTrunk = 16, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_RAILGUNXM3
		name = 'WEAPON_RAILGUNXM3', hash = `WEAPON_RAILGUNXM3`, label = 'Railgun', model = 'w_ar_railgun_xm3',
        weight = 5, weightTrunk = 10, difficulty = 4,
		components = {
			{ name = 'clip_default', label = 'Default Clip', hash = `COMPONENT_RAILGUNXM3_CLIP_01`, type = 'clip' },
		},
	},
    --- GRENADE Weapon 
    {    -- WEAPON_GRENADE
        name = 'WEAPON_GRENADE', hash = `WEAPON_GRENADE`, label = "Grenade", model = 'w_ex_grenadefrag',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_BZGAS
        name = 'WEAPON_BZGAS', hash = `WEAPON_BZGAS`, label = "BZ Gas", model = 'w_ex_grenadesmoke',
        weight = 5, weightTrunk = 10, difficulty = 2,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_MOLOTOV
        name = 'WEAPON_MOLOTOV', hash = `WEAPON_MOLOTOV`, label = "Molotov Cocktail", model = 'w_ex_molotov',
        weight = 5, weightTrunk = 10, difficulty = 2,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_STICKYBOMB
        name = 'WEAPON_STICKYBOMB', hash = `WEAPON_STICKYBOMB`, label = "Sticky Bomb", model = 'w_ex_grenade',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PROXMINE
        name = 'WEAPON_PROXMINE', hash = `WEAPON_PROXMINE`, label = "Proximity Mine", model = 'w_ex_mine',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SNOWBALL
        name = 'WEAPON_SNOWBALL', hash = `WEAPON_SNOWBALL`, label = "Snow Ball", model = 'w_am_baseball',
        weight = 5, weightTrunk = 10, difficulty = 1,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PIPEBOMB
        name = 'WEAPON_PIPEBOMB', hash = `WEAPON_PIPEBOMB`, label = "Pipe Bomb", model = 'w_ex_pipebomb',
        weight = 10, weightTrunk = 15, difficulty = 4,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_BALL
        name = 'WEAPON_BALL', hash = `WEAPON_BALL`, label = "Ball", model = 'w_am_baseball',
        weight = 1, weightTrunk = 5, difficulty = 1,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_SMOKEGRENADE
        name = 'WEAPON_SMOKEGRENADE', hash = `WEAPON_SMOKEGRENADE`, label = "Smoke Grenade", model = 'w_ex_grenadesmoke',
        weight = 5, weightTrunk = 10, difficulty = 2,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_FLARE
        name = 'WEAPON_FLARE', hash = `WEAPON_FLARE`, label = "Flare", model = 'w_am_flare',
        weight = 5, weightTrunk = 10, difficulty = 3,
        components = {}, tints = Config.DefaultWeaponTints,
    }, { -- WEAPON_PETROLCAN
        name = 'WEAPON_PETROLCAN', hash = `WEAPON_PETROLCAN`, label = "Jerrycan", model = 'w_am_jerrycan',
        weight = 5, weightTrunk = 10, difficulty = 1,
        components = {},
    }, { -- WEAPON_FIREEXTINGUISHER
        name = 'WEAPON_FIREEXTINGUISHER', hash = `WEAPON_FIREEXTINGUISHER`, label = "Fire Extinguisher", model = 'w_am_fire_exting',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {},
    }, { -- WEAPON_HAZARDCAN
        name = 'WEAPON_HAZARDCAN', hash = `WEAPON_HAZARDCAN`, label = "Hazardous Jerry Can", model = 'w_am_jerrycan',
        weight = 15, weightTrunk = 20, difficulty = 1,
        components = {},
    }, { -- WEAPON_ACIDPACKAGE
		name = 'WEAPON_ACIDPACKAGE', hash = `WEAPON_ACIDPACKAGE`, label = 'Acid', model = 'w_am_papers_xm3',
        weight = 5, weightTrunk = 10, difficulty = 4,
		components = {},
	},
    --- GADGET
    { -- GADGET_PARACHUTE
        name = 'GADGET_PARACHUTE', hash = `GADGET_PARACHUTE`, label = "Parachute", model = 'p_parachute1_mp_dec',
        weight = 5, weightTrunk = 10, difficulty = 2,
        components = {},
    },
    --- CHROMIUM WEAPONS PACK
    {
        name = 'WEAPON_AK_47_CHR', hash = `WEAPON_AK_47_CHR`, label = "AK-47 CHR", model = 'w_ar_ak_47_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_ak_47_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_ak_47_chr_mag2` },
            { name = 'scope_holo', label = 'Dot Sight', hash = `did_ak_47_chr_dot` },
            { name = 'scope_holo', label = 'Holo Sight', hash = `did_ak_47_chr_holo` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_ak_47_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_ak_47_chr_grip` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_ak_47_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_ak_47_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_ak_47_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_ak_47_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_AR_15_CHR', hash = `WEAPON_AR_15_CHR`, label = "AR-15 CHR", model = 'w_ar_ar_15_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_ar_15_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_ar_15_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_ar_15_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_ar_15_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_ar_15_chr_grip` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_ar_15_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_ar_15_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_ar_15_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_ar_15_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_BERYL_762_CHR', hash = `WEAPON_BERYL_762_CHR`, label = "BERYL 762 CHR", model = 'w_ar_beryl_762_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_beryl_762_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_beryl_762_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_beryl_762_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_beryl_762_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_beryl_762_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_beryl_762_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_beryl_762_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_beryl_762_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_BULLPUP_SMG_CHR', hash = `WEAPON_BULLPUP_SMG_CHR`, label = "BULLPUP SMG", model = 'w_sb_bullpup_smg_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_sb_bullpup_smg_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_sb_bullpup_smg_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_bullpup_smg_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_ar_bullpup_smg_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `w_at_bullpup_smg_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_m4_bullpup_smg_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_m4_bullpup_smg_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_m4_bullpup_smg_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_BZ_199_CHR', hash = `WEAPON_BZ_199_CHR`, label = "BZ 199 CHR", model = 'w_ar_bz_199_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_bz_199_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_bz_199_chr_mag2` },
            { name = 'scope_holo', label = 'Holo', hash = `did_bz_199_chr_holo` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_bz_199_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_bz_199_chr_grip` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_bz_199_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_bz_199_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_bz_199_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_bz_199_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_COMBATHP_CHR', hash = `WEAPON_COMBATHP_CHR`, label = "COMBATHP CHR", model = 'w_pi_combathp_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_combathp_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_combathp_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_combathp_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_combathp_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_combathp_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_combathp_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_combathp_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_combathp_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_DESERT_EAGLE_CHR', hash = `WEAPON_DESERT_EAGLE_CHR`, label = "DESERT EAGLE CHR", model = 'w_pi_desert_eagle_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_pi_desert_eagle_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_pi_desert_eagle_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_desert_eagle_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_desert_eagle_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `w_at_desert_eagle_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_desert_eagle_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_desert_eagle_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_desert_eagle_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_DKS_101_CHR', hash = `WEAPON_DKS_101_CHR`, label = "DKS-101 CHR", model = 'w_sr_dks_101_chr',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_dks_101_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_dks_101_chr_mag2` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_dks_101_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_dks_101_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_dks_101_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_DMRSNIPER_CHR', hash = `WEAPON_DMRSNIPER_CHR`, label = "DMR Sniper CHR", model = 'w_sr_dmrsniper_chr',
        weight = 15, weightTrunk = 20, difficulty = 4,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_dmrsniper_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_dmrsniper_chr_mag2` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_dmrsniper_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_dmrsniper_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_dmrsniper_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_dmrsniper_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_FAMAS_CHR', hash = `WEAPON_FAMAS_CHR`, label = "FAMAS CHR", model = 'w_ar_famas_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_famas_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_famas_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_famas_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_famas_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_famas_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_famas_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_famas_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_GAU_5A_CHR', hash = `WEAPON_GAU_5A_CHR`, label = "GAU-5A CHR", model = 'w_ar_gua_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_gua_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_gua_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_gua_chr_mod_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_gua_chr_mod_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_gua_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_gua_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_gua_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_gua_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_H05117_P_CHR', hash = `WEAPON_H05117_P_CHR`, label = "H05117-P CHR", model = 'w_pi_h05117_p_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_h05117_p_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_h05117_p_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_h05117_p_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_h05117_p_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_h05117_p_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_h05117_p_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_h05117_p_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_h05117_p_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_HK2002M_CHR', hash = `WEAPON_HK2002M_CHR`, label = "HK2002M CHR", model = 'w_ar_kh2002m_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_kh2002m_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_kh2002m_chr_mag2` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_kh2002m_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_kh2002m_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_kh2002m_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_kh2002m_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_kh2002m_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_HKUSP_CHR', hash = `WEAPON_HKUSP_CHR`, label = "HKUSP CHR", model = 'w_pi_hkusp_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_hkusp_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_hkusp_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_hkusp_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_hkusp_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_hkusp_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_hkusp_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_hkusp_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_hkusp_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_HM_PISTOL_CHR', hash = `WEAPON_HM_PISTOL_CHR`, label = "HM-Pistol CHR", model = 'w_pi_hm_pistol_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_hm_pistol_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_hm_pistol_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_hm_pistol_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_hm_pistol_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_hm_pistol_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_hm_pistol_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_hm_pistol_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_hm_pistol_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_HOWA_T20_CHR', hash = `WEAPON_HOWA_T20_CHR`, label = "HOWA T20 CHR", model = 'w_ar_howat20_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_howat20_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_howat20_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_howat20_chr_mod_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_howat20_chr_mod_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_howat20_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_howat20_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_howat20_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_howat20_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_HX_15_CHR', hash = `WEAPON_HX_15_CHR`, label = "HX-15 CHR", model = 'w_ar_hx_15_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_hx_15_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_hx_15_chr_mag2` },
            { name = 'scope_dot', label = 'Dot Sight', hash = `did_hx_15_chr_dot` },
            { name = 'scope_holo', label = 'Holo Sight', hash = `did_hx_15_chr_holo` },
            { name = 'scope_optic', label = 'Optic', hash = `did_hx_15_chr_optic` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_hx_15_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_hx_15_chr_grip` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_hx_15_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_hx_15_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_hx_15_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_hx_15_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_L85_CHR', hash = `WEAPON_L85_CHR`, label = "L85 CHR", model = 'w_ar_l85_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_l85_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_l85_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_l85_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_l85_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_l85_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_l85_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_l85_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_l85_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_LSR_PISTOL_CHR', hash = `WEAPON_LSR_PISTOL_CHR`, label = "LSR-Pistol CHR", model = 'w_pi_lsr_pistol_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_lsr_pistol_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_lsr_pistol_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_lsr_pistol_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_lsr_pistol_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_lsr_pistol_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_lsr_pistol_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_lsr_pistol_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_lsr_pistol_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_M16A1_CHR', hash = `WEAPON_M16A1_CHR`, label = "M16A1 CHR", model = 'w_ar_m16a1_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_m16a1_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_m16a1_chr_mag2` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_m16a1_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_m16a1_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_m16a1_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_m16a1_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_M270D_CHR', hash = `WEAPON_M270D_CHR`, label = "M270D CHR", model = 'w_pi_m270d_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_m270d_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_m270d_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_m270d_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_m270d_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_m270d_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_m270d_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_m270d_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_m270d_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_M27_CHR', hash = `WEAPON_M27_CHR`, label = "M27 CHR", model = 'w_pi_m27s_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_m27s_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_m27s_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_m27s_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_m27s_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_m27s_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_m27s_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_m27s_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_m27s_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_M4_ARCW_CHR', hash = `WEAPON_M4_ARCW_CHR`, label = "M4 Arctic White CHR", model = 'w_ar_m4_arcw_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_m4_arcw_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_m4_arcw_chr_mag2` },
            { name = 'scope_holo', label = 'Dot Sight', hash = `did_m4_arcw_chr_at_scope_dot` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_m4_arcw_chr_at_supp` },
            { name = 'grip', label = 'Grip', hash = `did_m4_arcw_chr_at_grip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_m4_arcw_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_m4_arcw_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_m4_arcw_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_MK_PRISS_CHR', hash = `WEAPON_MK_PRISS_CHR`, label = "MK PRISS CHR", model = 'w_ar_mk_priss_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_mk_priss_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_mk_priss_chr_mag2` },
            { name = 'scope_holo', label = 'Holo', hash = `did_mk_priss_chr_holo` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_mk_priss_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_mk_priss_chr_grip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_mk_priss_chrd_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_mk_priss_chrd_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_mk_priss_chrd_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_MLTM4R_CHR', hash = `WEAPON_MLTM4R_CHR`, label = "MLTM4R", model = 'w_ar_lmtm4r_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_lmtm4r_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_lmtm4r_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_lmtm4r_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_lmtm4r_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_lmtm4r_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_lmtm4r_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_lmtm4r_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_lmtm4r_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_MODULAR_RIFLE_CHR', hash = `WEAPON_MODULAR_RIFLE_CHR`, label = "Modular Rifle CHR", model = 'w_ar_modular_rifle_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_modular_rifle_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_modular_rifle_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_modular_rifle_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_modular_rifle_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_modular_rifle_chr_grip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_modular_rifle_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_modular_rifle_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_modular_rifle_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_MP5_CHR', hash = `WEAPON_MP5_CHR`, label = "MP5 CHR", model = 'w_sb_mp5_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_sb_mp5_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_sb_mp5_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_mp5_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_mp5_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_sb_mp5_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_sb_mp5_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_sb_mp5_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_sb_mp5_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_MPH_21_SG_CHR', hash = `WEAPON_MPH_21_SG_CHR`, label = "MPH-21-SG CHR", model = 'w_sg_mph_21_sg_chr',
        weight = 12, weightTrunk = 18, difficulty = 3,
        components = {
            { name = 'suppressor', label = 'Suppressor', hash = `did_mph_21_sg_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_mph_21_sg_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_mph_21_sg_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_mph_21_sg_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_NVRIFLE_CHR', hash = `WEAPON_NVRIFLE_CHR`, label = "NV-RIFLE CHR", model = 'w_ar_nvrifle_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_w_nvrifle_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_w_nvrifle_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_w_nvrifle_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_w_nvrifle_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_w_nvrifle_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_w_nvrifle_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_w_nvrifle_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_w_nvrifle_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_R90_CHR', hash = `WEAPON_R90_CHR`, label = "R90 CHR", model = 'w_sg_r90_chr',
        weight = 12, weightTrunk = 18, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_r90_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_r90_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_r90_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_r90_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_r90_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_r90_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_r90_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_SB_SD_CHR', hash = `WEAPON_SB_SD_CHR`, label = "SB-SD CHR", model = 'w_sb_sbsd_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_sbsd_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_sbsd_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_sbsd_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_sbsd_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_sbsd_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_sbsd_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_sbsd_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_SPS_21_SG_CHR', hash = `WEAPON_SPS_21_SG_CHR`, label = "SPS-21-SG CHR", model = 'w_sg_sps_21_sg_chr',
        weight = 12, weightTrunk = 18, difficulty = 3,
        components = {
            { name = 'suppressor', label = 'Suppressor', hash = `did_sps_21_sg_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_sps_21_sg_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_sps_21_sg_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_sps_21_sg_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_SPX_7_CHR', hash = `WEAPON_SPX_7_CHR`, label = "SPX-7 CHR", model = 'w_sb_spx_7_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_spx_7_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_spx_7_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_spx_7_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_spx_7_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_spx_7_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_spx_7_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_spx_7_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_SR_3M_CHR', hash = `WEAPON_SR_3M_CHR`, label = "SR-3M CHR", model = 'w_sb_sr_3m_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_sr_3m_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_sr_3m_chr_mag2` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_sr_3m_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_sr_3m_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_sr_3m_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_sr_3m_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_SYS_PISTOL_CHR', hash = `WEAPON_SYS_PISTOL_CHR`, label = "SYS-Pistol CHR", model = 'w_pi_sys_pistol_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_sys_pistol_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_sys_pistol_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_sys_pistol_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_sys_pistol_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_sys_pistol_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_sys_pistol_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_sys_pistol_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_sys_pistol_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_TACTICAL_VECTOR_CHR', hash = `WEAPON_TACTICAL_VECTOR_CHR`, label = "TACTICAL Vector CHR", model = 'w_sb_tactical_vector_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_tactical_vector_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_tactical_vector_chr_mag2` },
            { name = 'scope_holo', label = 'Holo', hash = `did_tactical_vector_chr_holo` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_tactical_vector_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_tactical_vector_chr_grip` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_tactical_vector_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_tactical_vector_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_tactical_vector_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_tactical_vector_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_UMP_CHR', hash = `WEAPON_UMP_CHR`, label = "UMP CHR", model = 'w_sb_ump_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_sb_ump_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_sb_ump_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_ump_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_ump_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_at_ump_chr_grip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_sb_ump_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_sb_ump_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_sb_ump_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_VECOTR_CHR', hash = `WEAPON_VECOTR_CHR`, label = "VECOTR CHR", model = 'w_sb_vector_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_sb_vector_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_sb_vector_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_sb_vector_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_sb_vector_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `w_sb_vector_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_sb_vector_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_sb_vector_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_sb_vector_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_VERESK_CHR', hash = `WEAPON_VERESK_CHR`, label = "VERESK CHR", model = 'w_ar_veresk_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_veresk_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_veresk_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_veresk_chr_scope_small` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_veresk_chr_supp` },
            { name = 'grip', label = 'Grip', hash = `did_veresk_chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_veresk_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_veresk_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_veresk_chr_camo3` },
        }, tints = Config.DefaultWeaponTintsMK2,
    }, {
        name = 'WEAPON_VX_47_CHR', hash = `WEAPON_VX_47_CHR`, label = "VX-47 CHR", model = 'w_ar_vx_47_chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_vx_47_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_vx_47_chr_mag2` },
            { name = 'scope_holo', label = 'Holo', hash = `did_vx_47_chr_holo` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_vx_47_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_vx_47_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_vx_47_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_vx_47_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_VX_SCORPION_CHR', hash = `WEAPON_VX_SCORPION_CHR`, label = "VX-SCORPION CHR", model = 'w_sb_vx_scorpion_chr',
        weight = 7, weightTrunk = 12, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_vx_scorpion_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_vx_scorpion_chr_mag2` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_vx_scorpion_chr_supp` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_vx_scorpion_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_vx_scorpion_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_vx_scorpion_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_XM7_CHR', hash = `WEAPON_XM7_CHR`, label = "XM7 CHR", model = 'w_ar_xm7chr',
        weight = 10, weightTrunk = 15, difficulty = 3,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `w_ar_xm7chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `w_ar_xm7chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `w_at_xm7chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `w_at_xm7chr_suppressor` },
            { name = 'grip', label = 'Grip', hash = `w_at_xm7chr_afgrip` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `w_ar_xm7_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `w_ar_xm7_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `w_ar_xm7_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    }, {
        name = 'WEAPON_ZETA_19_CHR', hash = `WEAPON_ZETA_19_CHR`, label = "ZETA-19 CHR", model = 'w_pi_zeta_19_chr',
        weight = 5, weightTrunk = 8, difficulty = 2,
        components = {
            { name = 'clip_default',  label = 'Default Mag', hash = `did_zeta_19_chr_mag1` },
            { name = 'clip_extended', label = 'Extended Mag', hash = `did_zeta_19_chr_mag2` },
            { name = 'scope_holo', label = 'Scope', hash = `did_zeta_19_chr_scope` },
            { name = 'suppressor', label = 'Suppressor', hash = `did_zeta_19_chr_supp` },
            { name = 'flashlight', label = 'Flashlight', hash = `did_zeta_19_chr_flsh` },
            { name = 'camo1', label = 'Purple Pink Chromium', hash = `did_zeta_19_chr_camo1` },
            { name = 'camo2', label = 'Red Chromium', hash = `did_zeta_19_chr_camo2` },
            { name = 'camo3', label = 'Gold', hash = `did_zeta_19_chr_camo3` },
        }, tints = Config.DefaultWeaponTints,
    },
}

for k, v in pairs(Config.Weapons) do
    v.k = k
    Config.weapons2[v.name] = v
end

Config.weapons3 = {}
for k, v in pairs(Config.Weapons) do
    v.k = k
    Config.weapons3[GetHashKey(v.name)] = v
end
    -- --- addone
    -- {
    --     name = 'WEAPON_SOWRD01', hash = `WEAPON_SOWRD01`, label = "SOWRD01",
    --     weight = 5, weightTrunk = 10, difficulty = 4,
    --     components = {},
    -- },
    -- {
    --     name = 'WEAPON_SOWRD02', hash = `WEAPON_SOWRD02`, label = "SOWRD02",
    --     weight = 5, weightTrunk = 10, difficulty = 4,
    --     components = {},
    -- },
    -- {
    --     name = 'WEAPON_SOWRD03',
    --     hash = `WEAPON_SOWRD03'),
    --     label = "SOWRD03",
    --     components = {},
    --     weight = 5, weightTrunk = 10,
    --     difficulty = 4,
    -- },
    -- {
    --     name = 'WEAPON_SOWRD04',
    --     hash = `WEAPON_SOWRD04'),
    --     label = "SOWRD04",
    --     components = {},
    --     weight = 5, weightTrunk = 10,
    --     difficulty = 4,
    -- },
    -- {
    --     name = 'WEAPON_SOWRD05',
    --     hash = `WEAPON_SOWRD05'),
    --     label = "SOWRD05",
    --     components = {},
    --     weight = 5, weightTrunk = 10,
    --     difficulty = 4,
    -- },
    -- {
    --     name = 'WEAPON_SOWRD06',
    --     hash = `WEAPON_SOWRD06'),
    --     label = "SOWRD06",
    --     components = {},
    --     weight = 5, weightTrunk = 10,
    --     difficulty = 4,
    -- },
    -- {
    --     name = 'WEAPON_SOWRD07',
    --     hash = `WEAPON_SOWRD07'),
    --     label = "SOWRD07",
    --     components = {},
    --     weight = 5, weightTrunk = 10,
    --     difficulty = 4,
    -- },