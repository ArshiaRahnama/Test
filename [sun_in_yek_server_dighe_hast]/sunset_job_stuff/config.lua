-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {
    BlipSprite = 237,
    BlipColor = 26,
    BlipText = 'Workbench',
    CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
    HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job
    Categories = {
        ['items'] = {
            Label = 'Items',
            Image = 'items',
            Jobs = {}
        },
    },

    Dischant = {
        ["WEAPON_KNIFE"] = {iron = 0 }
    },

    Recipes = {

-- ambulance
        ['medikit'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 30, limit = 20,
            Ingredients = {
                ['wool'] = 10,
                ['opium'] = 2,
                ['cocaine'] = 2,
                ['cannabis'] = 5,
            },
            job = { ['ambulance'] = true }
        },

        ['bandage'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 30, limit = 20,
            Ingredients = {
                ['fabric'] = 1,
                ['heroine'] = 1,
                ['poppy'] = 5,
                ['marijuana'] = 10,
            },
            job = { ['ambulance'] = true }
        },

        ['adrenaline'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 6, limit = 2,
            Ingredients = {
                ['ephedrine'] = 6,
                ['opium'] = 6,
                ['crack'] = 3,
            },
            job = { ['ambulance'] = true }
        },

        -- ['erythropoietin'] = {
        --     Category = 'items', Time = 5, grade = 1, Money = 0,
        --     Amount = 10, limit = 1,
        --     Ingredients = {
        --         ['coca'] = 4,
        --         ['heroine'] = 4,
        --         ['cannabis'] = 2,
        --         ['ephedra'] = 2,
        --     },
        --     job = { ['ambulance'] = true }
        -- },

        ['gelofen'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 10, limit = 4,
            Ingredients = {
                ['cocaine'] = 2,
                ['heroine'] = 2,
                ['coca'] = 2,
            },
            job = { ['ambulance'] = true }
        },

        -- ['estaminofon'] = {
        --     Category = 'items', Time = 5, grade = 1, Money = 0,
        --     Amount = 10, limit = 2,
        --     Ingredients = {
        --         ['marijuana'] = 4,
        --         ['poppy'] = 4,
        --         ['ephedra'] = 4,
        --     },
        --     job = { ['ambulance'] = true }
        -- },

-- mechanic
        ['kittire'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 4, limit = 4,
            Ingredients = {
                ['iron_piece'] = 2,
                ['petrol_raffin'] = 2,
                ['wood'] = 2,
                ['pich'] = 2,
            },
            job = { ['mechanic'] = true }
        },

        ['kit50'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 5, limit = 3,
            Ingredients = {
                ['petrol'] = 1,
                ['fabric'] = 1,
                ['blowtorch'] = 1,
                ['pich'] = 1,
            },
            job = { ['mechanic'] = true }
        },

        ['kit100'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 20, limit = 20,
            Ingredients = {
                ['diamond'] = 1,
                ['fabric'] = 1,
                ['gold_piece'] = 1,
                ['pich'] = 1,
                ['blowtorch'] = 1,
            },
            job = { ['mechanic'] = true }
        },

        ['cleaner'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 5, limit = 3,
            Ingredients = {
                ['fabric'] = 1,
                ['petrol'] = 1,
                ['water'] = 1,
            },
            job = { ['mechanic'] = true }
        },

        ['jack'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 20, limit = 2,
            Ingredients = {
                ['gold_piece'] = 5,
                ['iron_piece'] = 5,
            },
            job = { ['mechanic'] = true }
        },

        ['engine1'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 4, limit = 2,
            Ingredients = {
                ['iron_piece'] = 14,
                ['gold_piece'] = 10,
                ['pich'] = 8,
            },
            job = { ['mechanic'] = true }
        },

        ['engine2'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 4, limit = 2,
            Ingredients = {
                ['iron_piece'] = 20,
                ['gold_piece'] = 12,
                ['petrol'] = 12,
                ['blowtorch'] = 2,
                ['pich'] = 10,
            },
            job = { ['mechanic'] = true }
        },

        ['engine3'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 2, limit = 3,
            Ingredients = {
                ['iron_piece'] = 20,
                ['gold_piece'] = 15,
                ['petrol_raffin'] = 6,
                ['fabric'] = 6,
                ['blowtorch'] = 1,
            },
            job = { ['mechanic'] = true }
        },

        ['engine4'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 2, limit = 3,
            Ingredients = {
                ['iron_piece'] = 20,
                ['gold_piece'] = 20,
                ['petrol_raffin'] = 10,
                ['fabric'] = 5,
                ['blowtorch'] = 1,
                ['pich'] = 5,
                ['wood'] = 15,
            },
            job = { ['mechanic'] = true }
        },

        ['engine5'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 2, limit = 3,
            Ingredients = {
                ['iron_piece'] = 25,
                ['gold_piece'] = 25,
                ['essence'] = 10,
                ['blowtorch'] = 2,
                ['pich'] = 5,
                ['diamond'] = 1,
            },
            job = { ['mechanic'] = true }
        },

        ['engine6'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 2, limit = 3,
            Ingredients = {
                ['iron'] = 1,
                ['gold'] = 1,
                ['petrol'] = 20,
                ['blowtorch'] = 3,
                ['pich'] = 6,
                ['cutted_wood'] = 10,
                ['diamond'] = 2,
            },
            job = { ['mechanic'] = true }
        },

        ['pich'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 20, limit = 7,
            Ingredients = {
                ['iron_piece'] = 32,
                ['wood'] = 8,
            },
            job = { ['mechanic'] = true }
        },

        ['lockpick'] = {
            Category = 'items', Time = 5, grade = 1, Money = 0,
            Amount = 6, limit = 5,
            Ingredients = {
                ['alum_oxide'] = 66,
            },
            job = { ['mechanic'] = true }
        },

        ['cargps'] = {
            Category = 'items', Time = 5, grade = 6, Money = 0,
            Amount = 1, limit = 5,
            Ingredients = {
                ['plastic'] = 5,
                ['aluminum'] = 2,
                ['iron'] = 1,
                ['phone'] = 1,
            },
            job = { ['mechanic'] = true }
        },

-- khayat
        ['kool1'] = {
            Category = 'items', lable = 'کیف 50 کیلویی',
            Time = 10, grade = 0, Money = 0,
            Amount = 1, limit = 2,
            Ingredients = {
                ['pig_skin'] = 2,
                ['husky_skin'] = 2,
            },
            job = {}, job2 = { ['tailor'] = 20 },
        },

        ['kool2'] = {
            Category = 'items', lable = 'کیف 75 کیلویی',
            Time = 10, grade = 0, Money = 0,
            Amount = 1, limit = 2,
            Ingredients = {
                ['fabric'] = 10,
                ['wool'] = 40,
                ['deer_skin'] = 2,
                ['rottweiler_skin'] = 2,
                ['husky_skin'] = 1,
            },
            job = {}, job2 = { ['tailor'] = 21, },
        },

        ['kool3'] = {
            Category = 'items', lable = 'کیف 100 کیلویی',
            Time = 10, grade = 0, Money = 0,
            Amount = 1, limit = 2,
            Ingredients = {
                ['fabric'] = 10,
                ['wool'] = 40,
                ['boar_skin'] = 2,
                ['panther_skin'] = 1,
                ['shepherd_skin'] = 2,
                ['retriever_skin'] = 2,
            },
            job = {}, job2 = { ['tailor'] = 22 },
        },

    },

    Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

        [1] =  { coords = vec(1145.05, -1568.78, 35.4), recipes = {}, blip = false, radius = 3.0, job = { ['ambulance'] = true } }, -- md 1
        [2] =  { coords = vec(-1829.7, -346.01, 49.25), recipes = {}, blip = false, radius = 3.0, job = { ['ambulance'] = true } }, -- md 2 
        [3] =  { coords = vec(-261.66, 6322.12, 32.43), recipes = {}, blip = false, radius = 3.0, job = { ['ambulance'] = true } }, -- md paleto

        [10] = { coords = vec(1312.57,-767.09,67.18),   recipes = {}, blip = false, radius = 3.0, job = { ['mechanic'] = true } },  -- mc 1
        [11] = { coords = vec(587.45,612.85,129.0),     recipes = {}, blip = false, radius = 3.0, job = { ['mechanic'] = true } },  -- mc 2 new
        [12] = { coords = vec(1242.24,2725.06,38.01),   recipes = {}, blip = false, radius = 3.0, job = { ['mechanic'] = true } },  -- mc sandy
        [13] = { coords = vec(134.88,-3050.63,7.04),    recipes = {}, blip = false, radius = 3.0, job = { ['mechanic'] = true } },  -- mc tune

        [20] = { recipes = {}, blip = false, radius = 2.0, job = { ['tailor'] = true } },    -- kahayat kif 50k
        [21] = { recipes = {}, blip = false, radius = 2.0, job = { ['tailor'] = true } },    -- kahayat kif 75k
        [22] = { recipes = {}, blip = false, radius = 2.0, job = { ['tailor'] = true } },    -- kahayat kif 100k

    },

    Text = {
        ['not_enough_ingredients'] = 'You dont have enough ingredients',
        ['you_cant_hold_item'] = 'You cant hold the item',
        ['item_crafted'] = 'Item crafted!',
        ['wrong_job'] = 'You cant open this workbench',
        ['workbench_hologram'] = '[~b~E~w~] Workbench',
        ['wrong_usage'] = 'Wrong usage of command',
        ['inv_limit_exceed'] = 'Inventory limit exceeded! Clean up before you lose more',
        ['crafting_failed'] = 'You failed to craft the item!'
    }
}

    function SendTextMessage(msg)
            SetNotificationTextEntry('STRING')
            AddTextComponentString(msg)
            DrawNotification(0,1)
    end

    Config.Weapons = {
        -- Meeles
        {
            name = 'WEAPON_DAGGER',
            hash = GetHashKey('WEAPON_DAGGER'),
            label = "Dagger",
            components = {}
        },
        {
            name = 'WEAPON_BAT',
            hash = GetHashKey('WEAPON_BAT'),
            label = "Bat",
            components = {}
        },
        {
            name = 'WEAPON_BOTTLE',
            hash = GetHashKey('WEAPON_BOTTLE'),
            label = "Bottle",
            components = {}
        },
        {
            name = 'WEAPON_CROWBAR',
            hash = GetHashKey('WEAPON_CROWBAR'),
            label = "Crowbar",
            components = {}
        },
        {
            name = 'WEAPON_FLASHLIGHT',
            hash = GetHashKey('WEAPON_FLASHLIGHT'),
            label = "Flashlight",
            components = {}
        },
        {
            name = 'WEAPON_GOLFCLUB',
            hash = GetHashKey('WEAPON_GOLFCLUB'),
            label = "Golf Club",
            components = {}
        },
        {
            name = 'WEAPON_HAMMER',
            hash = GetHashKey('WEAPON_HAMMER'),
            label = "Hammer",
            components = {}
        },
        {
            name = 'WEAPON_HATCHET',
            hash = GetHashKey('WEAPON_HATCHET'),
            label = "Hatchet",
            components = {}
        },
        {
            name = 'WEAPON_KNUCKLE',
            hash = GetHashKey('WEAPON_KNUCKLE'),
            label = "Knuckle Dusters",
            components = {
                {name = 'default_varmod', label = "Defualt Skin", hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BASE')},
                {name = 'pimp_varmod',    label = "Pimp Skin",    hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PIMP')},
                {name = 'ballas_varmod',  label = "Ballas Skin",  hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_BALLAS')},
                {name = 'dollar_varmod',  label = "Dollar Skin",  hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DOLLAR')},
                {name = 'diamond_varmod', label = "Diamond Skin", hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_DIAMOND')},
                {name = 'hate_varmod',    label = "Hate Skin",    hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_HATE')},
                {name = 'love_varmod',    label = "Love Skin",    hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_LOVE')},
                {name = 'player_varmod',  label = "Player Skin",  hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_PLAYER')},
                {name = 'king_varmod',    label = "King Skin",    hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_KING')},
                {name = 'vagos_varmod',   label = "Vagos Skin",   hash = GetHashKey('COMPONENT_KNUCKLE_VARMOD_VAGOS')},
            },
        },
        {
            name = 'WEAPON_KNIFE',
            hash = GetHashKey('WEAPON_KNIFE'),
            label = "Knife",
            components = {}
        },
        {
            name = 'WEAPON_MACHETE',
            hash = GetHashKey('WEAPON_MACHETE'),
            label = "Machete",
            components = {}
        },
        {
            name = 'WEAPON_SWITCHBLADE',
            hash = GetHashKey('WEAPON_SWITCHBLADE'),
            label = "Switch Blade",
            components = {
                {name = 'default_varmod', label = "Defualt Skin", hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_BASE')},
                {name = 'var1_varmod',    label = "Var1 Skin",    hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR1')},
                {name = 'var2_varmod',    label = "Var2 Skin",    hash = GetHashKey('COMPONENT_SWITCHBLADE_VARMOD_VAR2')},
            },
        },
        {
            name = 'WEAPON_NIGHTSTICK',
            hash = GetHashKey('WEAPON_NIGHTSTICK'),
            label = "Nightstick",
            components = {}
        },
        {
            name = 'WEAPON_WRENCH',
            hash = GetHashKey('WEAPON_WRENCH'),
            label = "Pipe Wrench",
            components = {}
        },
        {
            name = 'WEAPON_BATTLEAXE',
            hash = GetHashKey('WEAPON_BATTLEAXE'),
            label = "Battle Axe",
            components = {}
        },
        {
            name = 'WEAPON_POOLCUE',
            hash = GetHashKey('WEAPON_POOLCUE'),
            label = "Pool Cue",
            components = {}
        },
        {
            name = 'WEAPON_STONE_HATCHET',
            hash = GetHashKey('WEAPON_STONE_HATCHET'),
            label = "Stone Hatchet",
            components = {}
        },
        -- Pistols
        {
            name = 'WEAPON_PISTOL',
            hash = GetHashKey('WEAPON_PISTOL'),
            label = "Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_PISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_PISTOL_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_PISTOL_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_PISTOL_MK2',
            hash = GetHashKey('WEAPON_PISTOL_MK2'),
            label = "Pistol MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',     label = "Default Clip",     hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_01')},
                {name = 'clip_extended',    label = "Extended Clip",    hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_02')},
                {name = 'clip_tracer',      label = "Tracer Clip",      hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',  label = "Incendiary Clip",  hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_INCENDIARY')},
                {name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT')},
                {name = 'clip_fmj',         label = "FMJ Clip",         hash = GetHashKey('COMPONENT_PISTOL_MK2_CLIP_FMJ')},
                {name = 'mounted_scope',    label = "Mounted Scope",    hash = GetHashKey('COMPONENT_AT_PI_RAIL')},
                {name = 'flashlight',       label = "Flashlight",       hash = GetHashKey('COMPONENT_AT_PI_FLSH_02')},
                {name = 'suppressor',       label = "Suppressor",       hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
                {name = 'compensator',      label = "Compensator",      hash = GetHashKey('COMPONENT_AT_PI_COMP')},
                {name = 'camo1',            label = "Camo 1",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO')},
                {name = 'camo2',            label = "Camo 2",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02')},
                {name = 'camo3',            label = "Camo 3",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03')},
                {name = 'camo4',            label = "Camo 4",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04')},
                {name = 'camo5',            label = "Camo 5",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05')},
                {name = 'camo6',            label = "Camo 6",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06')},
                {name = 'camo7',            label = "Camo 7",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07')},
                {name = 'camo8',            label = "Camo 8",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08')},
                {name = 'camo9',            label = "Camo 9",           hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09')},
                {name = 'camo10',           label = "Camo 10",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10')},
                {name = 'camo11',           label = "Camo 11",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01')},
                {name = 'camo12',           label = "Camo 12",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_SLIDE')},
                {name = 'camo13',           label = "Camo 13",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_02_SLIDE')},
                {name = 'camo14',           label = "Camo 14",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_03_SLIDE')},
                {name = 'camo15',           label = "Camo 15",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_04_SLIDE')},
                {name = 'camo16',           label = "Camo 16",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_05_SLIDE')},
                {name = 'camo17',           label = "Camo 17",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_06_SLIDE')},
                {name = 'camo18',           label = "Camo 18",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_07_SLIDE')},
                {name = 'camo19',           label = "Camo 19",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_08_SLIDE')},
                {name = 'camo20',           label = "Camo 20",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_09_SLIDE')},
                {name = 'camo21',           label = "Camo 21",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_10_SLIDE')},
                {name = 'camo22',           label = "Camo 22",          hash = GetHashKey('COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE')}
            }
        },
        {
            name = 'WEAPON_COMBATPISTOL',
            hash = GetHashKey('WEAPON_COMBATPISTOL'),
            label = "Combat Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER')}
            },
        },
        {
            name = 'WEAPON_APPISTOL',
            hash = GetHashKey('WEAPON_APPISTOL'),
            label = "AP Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_APPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_APPISTOL_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_APPISTOL_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_STUNGUN',
            hash = GetHashKey('WEAPON_STUNGUN'),
            label = "Taser",
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_PISTOL50',
            hash = GetHashKey('WEAPON_PISTOL50'),
            label = "Pistol .50",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_PISTOL50_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_PISTOL50_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_PISTOL50_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_SNSPISTOL',
            hash = GetHashKey('WEAPON_SNSPISTOL'),
            label = "SNS Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_SNSPISTOL_CLIP_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_SNSPISTOL_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_SNSPISTOL_MK2',
            hash = GetHashKey('WEAPON_SNSPISTOL_MK2'),
            label = "SNS Pistol MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',     label = "Default Clip",     hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_01')},
                {name = 'clip_extended',    label = "Extended Clip",    hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_02')},
                {name = 'clip_tracer',      label = "Tracer Clip",      hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',  label = "Incendiary Clip",  hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY')},
                {name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT')},
                {name = 'clip_fmj',         label = "FMJ Clip",         hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CLIP_FMJ')},
                {name = 'mounted_scope',    label = "Mounted Scope",    hash = GetHashKey('COMPONENT_AT_PI_RAIL_02')},
                {name = 'flashlight',       label = "Flashlight",       hash = GetHashKey('COMPONENT_AT_PI_FLSH_03')},
                {name = 'suppressor',       label = "Suppressor",       hash = GetHashKey('COMPONENT_AT_PI_SUPP_02')},
                {name = 'compensator',      label = "Compensator",      hash = GetHashKey('COMPONENT_AT_PI_COMP_02')},
                {name = 'camo1',            label = "Camo 1",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO')},
                {name = 'camo2',            label = "Camo 2",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02')},
                {name = 'camo3',            label = "Camo 3",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03')},
                {name = 'camo4',            label = "Camo 4",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04')},
                {name = 'camo5',            label = "Camo 5",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05')},
                {name = 'camo6',            label = "Camo 6",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06')},
                {name = 'camo7',            label = "Camo 7",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07')},
                {name = 'camo8',            label = "Camo 8",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08')},
                {name = 'camo9',            label = "Camo 9",           hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09')},
                {name = 'camo10',           label = "Camo 10",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10')},
                {name = 'camo11',           label = "Camo 11",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01')},
                {name = 'camo12',           label = "Camo 12",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE')},
                {name = 'camo13',           label = "Camo 13",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE')},
                {name = 'camo14',           label = "Camo 14",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE')},
                {name = 'camo15',           label = "Camo 15",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE')},
                {name = 'camo16',           label = "Camo 16",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE')},
                {name = 'camo17',           label = "Camo 17",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE')},
                {name = 'camo18',           label = "Camo 18",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE')},
                {name = 'camo19',           label = "Camo 19",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE')},
                {name = 'camo20',           label = "Camo 20",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE')},
                {name = 'camo21',           label = "Camo 21",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE')},
                {name = 'camo22',           label = "Camo 22",          hash = GetHashKey('COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE')}
            }
        },
        {
            name = 'WEAPON_HEAVYPISTOL',
            hash = GetHashKey('WEAPON_HEAVYPISTOL'),
            label = "Heavy Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_HEAVYPISTOL_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_HEAVYPISTOL_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_VINTAGEPISTOL',
            hash = GetHashKey('WEAPON_VINTAGEPISTOL'),
            label = "Vintage Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_VINTAGEPISTOL_CLIP_02')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
            }
        },
        {
            name = 'WEAPON_FLAREGUN',
            hash = GetHashKey('WEAPON_FLAREGUN'),
            label = "Flaregun",
            ammo = {label = "Flare(s)", hash = GetHashKey('AMMO_FLAREGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_MARKSMANPISTOL',
            hash = GetHashKey('WEAPON_MARKSMANPISTOL'),
            label = "Marksman Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_REVOLVER',
            hash = GetHashKey('WEAPON_REVOLVER'),
            label = "Heavy Revolver",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",   hash = GetHashKey('COMPONENT_REVOLVER_CLIP_01')},
                {name = 'boss_varmod',   label = "VIP Skin",       hash = GetHashKey('COMPONENT_REVOLVER_VARMOD_BOSS')},
                {name = 'goon_varmod',   label = "Bodyguard Skin", hash = GetHashKey('COMPONENT_REVOLVER_VARMOD_GOON')}
            }
        },
        {
            name = 'WEAPON_REVOLVER_MK2',
            hash = GetHashKey('WEAPON_REVOLVER_MK2'),
            label = "Heavy Revolver MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',     label = "Default Clip",     hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_01')},
                {name = 'clip_tracer',      label = "Tracer Clip",      hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',  label = "Incendiary Clip",  hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY')},
                {name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT')},
                {name = 'clip_fmj',         label = "FMJ Clip",         hash = GetHashKey('COMPONENT_REVOLVER_MK2_CLIP_FMJ')},
                {name = 'holo_sight',       label = "Holograph Sight",  hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',      label = "Small Scope",      hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')},
                {name = 'flashlight',       label = "Flashlight",       hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'compensator',      label = "Compensator",      hash = GetHashKey('COMPONENT_AT_PI_COMP_03')},
                {name = 'camo1',            label = "Camo 1",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO')},
                {name = 'camo2',            label = "Camo 2",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_02')},
                {name = 'camo3',            label = "Camo 3",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_03')},
                {name = 'camo4',            label = "Camo 4",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_04')},
                {name = 'camo5',            label = "Camo 5",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_05')},
                {name = 'camo6',            label = "Camo 6",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_06')},
                {name = 'camo7',            label = "Camo 7",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_07')},
                {name = 'camo8',            label = "Camo 8",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_08')},
                {name = 'camo9',            label = "Camo 9",           hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_09')},
                {name = 'camo10',           label = "Camo 10",          hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_10')},
                {name = 'camo11',           label = "Camo 11",          hash = GetHashKey('COMPONENT_REVOLVER_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_DOUBLEACTION',
            hash = GetHashKey('WEAPON_DOUBLEACTION'),
            label = "Double-Action Revolver",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_RAYPISTOL',
            hash = GetHashKey('WEAPON_RAYPISTOL'),
            label = "Up-n-Atomizer",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'xmas_varmod', label = "Xmas Skin", hash = GetHashKey('COMPONENT_RAYPISTOL_VARMOD_XMAS18')}
            }
        },
        {
            name = 'WEAPON_CERAMICPISTOL',
            hash = GetHashKey('WEAPON_CERAMICPISTOL'),
            label = "Ceramic Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_CERAMICPISTOL_CLIP_02')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_CERAMICPISTOL_SUPP')}
            }
        },
        {
            name = 'WEAPON_NAVYREVOLVER',
            hash = GetHashKey('WEAPON_NAVYREVOLVER'),
            label = "Navy Revolver",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_GADGETPISTOL',
            hash = GetHashKey('WEAPON_GADGETPISTOL'),
            label = "Perico Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_PISTOL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        -- SMGs
        {
            name = 'WEAPON_MICROSMG',
            hash = GetHashKey('WEAPON_MICROSMG'),
            label = "Micro SMG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MICROSMG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MICROSMG_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_PI_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_MICROSMG_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_SMG',
            hash = GetHashKey('WEAPON_SMG'),
            label = "SMG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_SMG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_SMG_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_SMG_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_SMG_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_SMG_MK2',
            hash = GetHashKey('WEAPON_SMG_MK2'),
            label = "SMG MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',     label = "Default Clip",     hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_01')},
                {name = 'clip_extended',    label = "Extended Clip",    hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_02')},
                {name = 'clip_tracer',      label = "Tracer Clip",      hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',  label = "Incendiary Clip",  hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_INCENDIARY')},
                {name = 'clip_hollowpoint', label = "Hollowpoint Clip", hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT')},
                {name = 'clip_fmj',         label = "FMJ Clip",         hash = GetHashKey('COMPONENT_SMG_MK2_CLIP_FMJ')},
                {name = 'holo_sight',       label = "Holograph Sight",  hash = GetHashKey('COMPONENT_AT_SIGHTS_SMG')},
                {name = 'small_scope',      label = "Small Scope",      hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2')},
                {name = 'medium_scope',     label = "Medium Scope",     hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_SMG_MK2')},
                {name = 'flashlight',       label = "Flashlight",       hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',       label = "Suppressor",       hash = GetHashKey('COMPONENT_AT_PI_SUPP')},
                {name = 'muzzle1',          label = "Muzzle Brake 1",   hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',          label = "Muzzle Brake 2",   hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',          label = "Muzzle Brake 3",   hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',          label = "Muzzle Brake 4",   hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',          label = "Muzzle Brake 5",   hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',          label = "Muzzle Brake 6",   hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',          label = "Muzzle Brake 7",   hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',   label = "Default Barrel",   hash = GetHashKey('COMPONENT_AT_SB_BARREL_01')},
                {name = 'heavy_barrel',     label = "Heavy Barrel",     hash = GetHashKey('COMPONENT_AT_SB_BARREL_02')},
                {name = 'camo1',            label = "Camo 1",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO')},
                {name = 'camo2',            label = "Camo 2",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_02')},
                {name = 'camo3',            label = "Camo 3",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_03')},
                {name = 'camo4',            label = "Camo 4",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_04')},
                {name = 'camo5',            label = "Camo 5",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_05')},
                {name = 'camo6',            label = "Camo 6",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_06')},
                {name = 'camo7',            label = "Camo 7",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_07')},
                {name = 'camo8',            label = "Camo 8",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_08')},
                {name = 'camo9',            label = "Camo 9",           hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_09')},
                {name = 'camo10',           label = "Camo 10",          hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_10')},
                {name = 'camo11',           label = "Camo 11",          hash = GetHashKey('COMPONENT_SMG_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_ASSAULTSMG',
            hash = GetHashKey('WEAPON_ASSAULTSMG'),
            label = "Assault SMG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_COMBATPDW',
            hash = GetHashKey('WEAPON_COMBATPDW'),
            label = "Combat PDW",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_COMBATPDW_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')}
            }
        },
        {
            
            name = 'WEAPON_MACHINEPISTOL',
            hash = GetHashKey('WEAPON_MACHINEPISTOL'),
            label = "Machine Pistol",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_MACHINEPISTOL_CLIP_03')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_PI_SUPP')}
            }
        },
        {
            name = 'WEAPON_MINISMG',
            hash = GetHashKey('WEAPON_MINISMG'),
            label = "Mini SMG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MINISMG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MINISMG_CLIP_02')}
            }
        },
        {
            name = 'WEAPON_RAYCARBINE',
            hash = GetHashKey('WEAPON_RAYCARBINE'),
            label = "Unholy Hellbringer",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SMG')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        -- Shotguns
        {
            name = 'WEAPON_PUMPSHOTGUN',
            hash = GetHashKey('WEAPON_PUMPSHOTGUN'),
            label = "Pump Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_SR_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_PUMPSHOTGUN_MK2',
            hash = GetHashKey('WEAPON_PUMPSHOTGUN_MK2'),
            label = "Pump Shotgun MK2",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_01')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_hollowpoint',   label = "Hollowpoint Clip",   hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT')},
                {name = 'clip_explosive',     label = "Explosive Clip",     hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',        label = "Small Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')},
                {name = 'medium_scope',       label = "Medium Scope",       hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_SR_SUPP_03')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_08')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_SAWNOFFSHOTGUN',
            hash = GetHashKey('WEAPON_SAWNOFFSHOTGUN'),
            label = "Sawed-Off Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'luxe_varmod', label = "Luxary Skin", hash = GetHashKey('COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_ASSAULTSHOTGUN',
            hash = GetHashKey('WEAPON_ASSAULTSHOTGUN'),
            label = "Assault Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
            }
        },
        {
            name = 'WEAPON_BULLPUPSHOTGUN',
            hash = GetHashKey('WEAPON_BULLPUPSHOTGUN'),
            label = "Bullpup Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
            }
        },
        {
            name = 'WEAPON_MUSKET',
            hash = GetHashKey('WEAPON_MUSKET'),
            label = "Musket",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_HEAVYSHOTGUN',
            hash = GetHashKey('WEAPON_HEAVYSHOTGUN'),
            label = "Heavy Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_HEAVYSHOTGUN_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
            }
        },
        {
            name = 'WEAPON_DBSHOTGUN',
            hash = GetHashKey('WEAPON_DBSHOTGUN'),
            label = "Double-Barrel Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_AUTOSHOTGUN',
            hash = GetHashKey('WEAPON_AUTOSHOTGUN'),
            label = "Auto Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_COMBATSHOTGUN',
            hash = GetHashKey('WEAPON_COMBATSHOTGUN'),
            label = "Combat Shotgun",
            ammo = {label = "Shell(s)", hash = GetHashKey('AMMO_SHOTGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        -- Rifles
        {
            name = 'WEAPON_ASSAULTRIFLE',
            hash = GetHashKey('WEAPON_ASSAULTRIFLE'),
            label = "Assault Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_ASSAULTRIFLE_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_ASSAULTRIFLE_MK2',
            hash = GetHashKey('WEAPON_ASSAULTRIFLE_MK2'),
            label = "Assault Rifle MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',        label = "Small Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')},
                {name = 'large_scope',        label = "Large Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_AR_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_AR_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_CARBINERIFLE',
            hash = GetHashKey('WEAPON_CARBINERIFLE'),
            label = "Carbine Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_CARBINERIFLE_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_CARBINERIFLE_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_CARBINERIFLE_MK2',
            hash = GetHashKey('WEAPON_CARBINERIFLE_MK2'),
            label = "Carbine Rifle MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',        label = "Small Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')},
                {name = 'large_scope',        label = "Large Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_CR_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_CR_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_ADVANCEDRIFLE',
            hash = GetHashKey('WEAPON_ADVANCEDRIFLE'),
            label = "Advanced Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_SPECIALCARBINE',
            hash = GetHashKey('WEAPON_SPECIALCARBINE'),
            label = "Special Carbine",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_SPECIALCARBINE_CLIP_03')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_SPECIALCARBINE_MK2',
            hash = GetHashKey('WEAPON_SPECIALCARBINE_MK2'),
            label = "Special Carbine MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',        label = "Small Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_MK2')},
                {name = 'large_scope',        label = "Large Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_SC_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_SC_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_BULLPUPRIFLE',
            hash = GetHashKey('WEAPON_BULLPUPRIFLE'),
            label = "Bullpup Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_BULLPUPRIFLE_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_BULLPUPRIFLE_VARMOD_LOW')}
            }
        },
        {
            name = 'WEAPON_BULLPUPRIFLE_MK2',
            hash = GetHashKey('weapon_bullpuprifle_mk2'),
            label = "Bullpup Rifle MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'small_scope',        label = "Small Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MACRO_02_MK2')},
                {name = 'meduim_scope',       label = "Medium Scope",       hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_BP_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_BP_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_COMPACTRIFLE',
            hash = GetHashKey('WEAPON_COMPACTRIFLE'),
            label = "Compact Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_02')},
                {name = 'clip_drum',     label = "Drum Clip",     hash = GetHashKey('COMPONENT_COMPACTRIFLE_CLIP_03')}
            }
        },
        {
            name = 'WEAPON_MILITARYRIFLE',
            hash = GetHashKey('WEAPON_MILITARYRIFLE'),
            label = "Military Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RIFLE')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MILITARYRIFLE_CLIP_02')},
                {name = 'iron_sight',    label = "Iron Sight",    hash = GetHashKey('COMPONENT_MILITARYRIFLE_SIGHT_01')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')}
            }
        },
        -- MGs
        {
            name = 'WEAPON_MG',
            hash = GetHashKey('WEAPON_MG'),
            label = "MG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_MG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MG_CLIP_02')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_02')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_MG_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_COMBATMG',
            hash = GetHashKey('WEAPON_COMBATMG'),
            label = "Combat MG",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_MG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_COMBATMG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_COMBATMG_CLIP_02')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_COMBATMG_VARMOD_LOWRIDER')}
            }
        },
        {
            name = 'WEAPON_COMBATMG_MK2',
            hash = GetHashKey('WEAPON_COMBATMG_MK2'),
            label = "Combat MG MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_MG')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_COMBATMG_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'meduim_scope',       label = "Medium Scope",       hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL_MK2')},
                {name = 'large_scope',        label = "Large Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_MG_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_MG_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_COMBATMG_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_GUSENBERG',
            hash = GetHashKey('WEAPON_GUSENBERG'),
            label = "Gusenberg Sweeper",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_MG')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_GUSENBERG_CLIP_02')}
            }
        },
        -- Sniper Rifles
        {
            name = 'WEAPON_SNIPERRIFLE',
            hash = GetHashKey('WEAPON_SNIPERRIFLE'),
            label = "Sniper Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SNIPER')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',   label = "Default Clip",   hash = GetHashKey('COMPONENT_SNIPERRIFLE_CLIP_01')},
                {name = 'suppressor',     label = "Suppressor",     hash = GetHashKey('COMPONENT_AT_AR_SUPP_02')},
                {name = 'scope',          label = "Scope",          hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE')},
                {name = 'advanced_scope', label = "Advanced Scope", hash = GetHashKey('COMPONENT_AT_SCOPE_MAX')},
                {name = 'luxe_varmod',    label = "Luxary Skin",    hash = GetHashKey('COMPONENT_SNIPERRIFLE_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_HEAVYSNIPER',
            hash = GetHashKey('WEAPON_HEAVYSNIPER'),
            label = "Heavy Sniper",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SNIPER')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',   label = "Default Clip",   hash = GetHashKey('COMPONENT_HEAVYSNIPER_CLIP_01')},
                {name = 'scope',          label = "Scope",          hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE')},
                {name = 'advanced_scope', label = "Advanced Scope", hash = GetHashKey('COMPONENT_AT_SCOPE_MAX')}
            }
        },
        {
            name = 'WEAPON_HEAVYSNIPER_MK2',
            hash = GetHashKey('WEAPON_HEAVYSNIPER_MK2'),
            label = "Heavy Sniper MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SNIPER')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_02')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ')},
                {name = 'clip_explosive',     label = "Explosive Clip",     hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE')},
                {name = 'zoom_scope',         label = "Zoom Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_MK2')},
                {name = 'advanced_scope',     label = "Advanced Scope",     hash = GetHashKey('COMPONENT_AT_SCOPE_MAX')},
                {name = 'nv_scope',           label = "Night Vision Scope", hash = GetHashKey('COMPONENT_AT_SCOPE_NV')},
                {name = 'thermal_scope',      label = "Thermal Scope",      hash = GetHashKey('COMPONENT_AT_SCOPE_THERMAL')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_SR_SUPP_03')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_08')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_09')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_SR_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_SR_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01')}
            }
        },
        {
            name = 'WEAPON_MARKSMANRIFLE',
            hash = GetHashKey('WEAPON_MARKSMANRIFLE'),
            label = "Marksman Rifle",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SNIPER')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_01')},
                {name = 'clip_extended', label = "Extended Clip", hash = GetHashKey('COMPONENT_MARKSMANRIFLE_CLIP_02')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM')},
                {name = 'suppressor',    label = "Suppressor",    hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')},
                {name = 'luxe_varmod',   label = "Luxary Skin",   hash = GetHashKey('COMPONENT_MARKSMANRIFLE_VARMOD_LUXE')}
            }
        },
        {
            name = 'WEAPON_MARKSMANRIFLE_MK2',
            hash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2'),
            label = "Marksman Rifle MK2",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_SNIPER')},
            tints = Config.DefaultWeaponTintsMK2,
            components = {
                {name = 'clip_default',       label = "Default Clip",       hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_01')},
                {name = 'clip_extended',      label = "Extended Clip",      hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_02')},
                {name = 'clip_tracer',        label = "Tracer Clip",        hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER')},
                {name = 'clip_incendiary',    label = "Incendiary Clip",    hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY')},
                {name = 'clip_armorpiercing', label = "Armorpiercing Clip", hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING')},
                {name = 'clip_fmj',           label = "FMJ Clip",           hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ')},
                {name = 'holo_sight',         label = "Holograph Sight",    hash = GetHashKey('COMPONENT_AT_SIGHTS')},
                {name = 'large_scope',        label = "Large Scope",        hash = GetHashKey('COMPONENT_AT_SCOPE_MEDIUM_MK2')},
                {name = 'zoom_scope',         label = "Zoom Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2')},
                {name = 'grip',               label = "Grip",               hash = GetHashKey('COMPONENT_AT_AR_AFGRIP_02')},
                {name = 'flashlight',         label = "Flashlight",         hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'suppressor',         label = "Suppressor",         hash = GetHashKey('COMPONENT_AT_AR_SUPP')},
                {name = 'muzzle1',            label = "Muzzle Brake 1",     hash = GetHashKey('COMPONENT_AT_MUZZLE_01')},
                {name = 'muzzle2',            label = "Muzzle Brake 2",     hash = GetHashKey('COMPONENT_AT_MUZZLE_02')},
                {name = 'muzzle3',            label = "Muzzle Brake 3",     hash = GetHashKey('COMPONENT_AT_MUZZLE_03')},
                {name = 'muzzle4',            label = "Muzzle Brake 4",     hash = GetHashKey('COMPONENT_AT_MUZZLE_04')},
                {name = 'muzzle5',            label = "Muzzle Brake 5",     hash = GetHashKey('COMPONENT_AT_MUZZLE_05')},
                {name = 'muzzle6',            label = "Muzzle Brake 6",     hash = GetHashKey('COMPONENT_AT_MUZZLE_06')},
                {name = 'muzzle7',            label = "Muzzle Brake 7",     hash = GetHashKey('COMPONENT_AT_MUZZLE_07')},
                {name = 'default_barrel',     label = "Default Barrel",     hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_01')},
                {name = 'heavy_barrel',       label = "Heavy Barrel",       hash = GetHashKey('COMPONENT_AT_MRFL_BARREL_02')},
                {name = 'camo1',              label = "Camo 1",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO')},
                {name = 'camo2',              label = "Camo 2",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_02')},
                {name = 'camo3',              label = "Camo 3",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_03')},
                {name = 'camo4',              label = "Camo 4",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_04')},
                {name = 'camo5',              label = "Camo 5",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_05')},
                {name = 'camo6',              label = "Camo 6",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_06')},
                {name = 'camo7',              label = "Camo 7",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_07')},
                {name = 'camo8',              label = "Camo 8",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_08')},
                {name = 'camo9',              label = "Camo 9",             hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_09')},
                {name = 'camo10',             label = "Camo 10",            hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_10')},
                {name = 'camo11',             label = "Camo 11",            hash = GetHashKey('COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01')}
            }
        },
        -- Heavy Weapons
        {
            name = 'WEAPON_RPG',
            hash = GetHashKey('WEAPON_RPG'),
            label = "RPG",
            ammo = {label = "Rocket(s)", hash = GetHashKey('AMMO_RPG')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_GRENADELAUNCHER',
            hash = GetHashKey('WEAPON_GRENADELAUNCHER'),
            label = "Grenade Launcher",
            ammo = {label = "Grenade(s)", hash = GetHashKey('AMMO_GRENADELAUNCHER')},
            tints = Config.DefaultWeaponTints,
            components = {
                {name = 'clip_default',  label = "Default Clip",  hash = GetHashKey('COMPONENT_GRENADELAUNCHER_CLIP_01')},
                {name = 'flashlight',    label = "Flashlight",    hash = GetHashKey('COMPONENT_AT_AR_FLSH')},
                {name = 'scope',         label = "Scope",         hash = GetHashKey('COMPONENT_AT_SCOPE_SMALL')},
                {name = 'grip',          label = "Grip",          hash = GetHashKey('COMPONENT_AT_AR_AFGRIP')}
            }
        },
        {
            name = 'WEAPON_GRENADELAUNCHER_SMOKE',
            hash = GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'),
            label = "Grenade Launcher Smoke",
            ammo = {label = "Grenade(s)", hash = GetHashKey('AMMO_GRENADELAUNCHER_SMOKE')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_MINIGUN',
            hash = GetHashKey('WEAPON_MINIGUN'),
            label = "Minigun",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_MINIGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_FIREWORK',
            hash = GetHashKey('WEAPON_FIREWORK'),
            label = "Firework",
            ammo = {label = "Firework(s)", hash = GetHashKey('AMMO_FIREWORK')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_RAILGUN',
            hash = GetHashKey('WEAPON_RAILGUN'),
            label = "Railgun",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RAILGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_HOMINGLAUNCHER',
            hash = GetHashKey('WEAPON_HOMINGLAUNCHER'),
            label = "Homing Launcher",
            ammo = {label = "Rocket(s)", hash = GetHashKey('AMMO_HOMINGLAUNCHER')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_COMPACTLAUNCHER',
            hash = GetHashKey('WEAPON_COMPACTLAUNCHER'),
            label = "Compact Launcher",
            ammo = {label = "Grenade(s)", hash = GetHashKey('AMMO_GRENADELAUNCHER')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_RAYMINIGUN',
            hash = GetHashKey('WEAPON_RAYMINIGUN'),
            label = "Widowmaker",
            ammo = {label = "Round(s)", hash = GetHashKey('AMMO_RAYMINIGUN')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        -- Throwables
        {
            name = 'WEAPON_GRENADE',
            hash = GetHashKey('WEAPON_GRENADE'),
            label = "Grenade",
            ammo = {label = "Grenade(s)", hash = GetHashKey('AMMO_GRENADE')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_BZGAS',
            hash = GetHashKey('WEAPON_BZGAS'),
            label = "BZ Gas",
            ammo = {label = "Can(s)", hash = GetHashKey('AMMO_BZGAS')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_MOLOTOV',
            hash = GetHashKey('WEAPON_MOLOTOV'),
            label = "Molotov Cocktail",
            ammo = {label = "Cocktail(s)", hash = GetHashKey('AMMO_MOLOTOV')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_STICKYBOMB',
            hash = GetHashKey('WEAPON_STICKYBOMB'),
            label = "Sticky Bomb",
            ammo = {label = "Bomb(s)", hash = GetHashKey('AMMO_STICKYBOMB')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_PROXMINE',
            hash = GetHashKey('WEAPON_PROXMINE'),
            label = "Proximity Mine",
            ammo = {label = "Mine(s)", hash = GetHashKey('AMMO_PROXMINE')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_SNOWBALL',
            hash = GetHashKey('WEAPON_SNOWBALL'),
            label = "Snow Ball",
            ammo = {label = "Snowball(s)", hash = GetHashKey('AMMO_SNOWBALL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_PIPEBOMB',
            hash = GetHashKey('WEAPON_PIPEBOMB'),
            label = "Pipe Bomb",
            ammo = {label = "Bomb(s)", hash = GetHashKey('AMMO_PIPEBOMB')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_BALL',
            hash = GetHashKey('WEAPON_BALL'),
            label = "Ball",
            ammo = {label = "Ball(s)", hash = GetHashKey('AMMO_BALL')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_SMOKEGRENADE',
            hash = GetHashKey('WEAPON_SMOKEGRENADE'),
            label = "Smoke Grenade",
            ammo = {label = "Bomb(s)", hash = GetHashKey('AMMO_SMOKEGRENADE')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        {
            name = 'WEAPON_FLARE',
            hash = GetHashKey('WEAPON_FLARE'),
            label = "Flare",
            ammo = {label = "Flare(s)", hash = GetHashKey('AMMO_FLARE')},
            tints = Config.DefaultWeaponTints,
            components = {}
        },
        -- Miscellaneous
        {
            name = 'WEAPON_PETROLCAN',
            hash = GetHashKey('WEAPON_PETROLCAN'),
            label = "Jerrycan",
            ammo = {label = "Fuel", hash = GetHashKey('AMMO_PETROLCAN')},
            components = {}
        },
        {
            name = 'GADGET_PARACHUTE',
            hash = GetHashKey('GADGET_PARACHUTE'),
            label = "Parachute",
            components = {}
        },
        {
            name = 'WEAPON_FIREEXTINGUISHER',
            hash = GetHashKey('WEAPON_FIREEXTINGUISHER'),
            label = "Fire Extinguisher",
            ammo = {label = "Charge", hash = GetHashKey('AMMO_FIREEXTINGUISHER')},
            components = {}
        },
        {
            name = 'WEAPON_HAZARDCAN',
            hash = GetHashKey('WEAPON_HAZARDCAN'),
            label = "Hazardous Jerry Can",
            ammo = {label = "Fuel", hash = GetHashKey('AMMO_HAZARDCAN')},
            components = {}
        },
}