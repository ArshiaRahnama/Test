-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local GunShopName = {
    gunshop1 = "GroveStreet",
    gunshop2 = "Alghaede",
    gunshop3 = "ErrorX",
    gunshop4 = "sideA",
    gunshop5 = "Delta_Core",
    gunshop6 = "Rifa",
    gunshop7 = "2poc",
    gunshop8 = "Apachea",
}
local caffeName = {
    caffe1 = "ErrorX",
    caffe2 = "YANKER",
    caffe3 = "Apachea",
    caffe4 = "Survival_Team",
    caffe5 = "2poc",
    caffe6 = "Vextoria",
    caffe7 = "Bleach",
}
local ahangariName = {
    ah1 = "Amazon",
    ah2 = "Apachea",
    ah3 = "Hyperion",
    ah4 = "ZedFM",
    ah5 = "Hydra",
    ah6 = "ErrorX",
    ah7 = "Delta_Core",
}
local gangup20 = {
    gang1 = "GroveStreet",
    gang2 = "Alghaede",
    gang3 = "Capone",
    gang4 = "Khalifa",
    gang5 = "SAVAGE",
}
local caffeList = {
    [ caffeName.caffe1 ] = true,
    [ caffeName.caffe2 ] = true,
    [ caffeName.caffe3 ] = true,
    [ caffeName.caffe4 ] = true,
    [ caffeName.caffe5 ] = true,
    [ caffeName.caffe6 ] = true,
    [ caffeName.caffe7 ] = true
}
local shopAhangari = {
    [ gangup20.gang1 ] = true,
    [ gangup20.gang2 ] = true,
    [ gangup20.gang3 ] = true,
    [ gangup20.gang4 ] = true,
    [ gangup20.gang5 ] = true,
    [ ahangariName.ah1 ] = true,
    [ ahangariName.ah2 ] = true,
    [ ahangariName.ah3 ] = true,
    [ ahangariName.ah4 ] = true,
    [ ahangariName.ah5 ] = true,
    [ ahangariName.ah6 ] = true,
    [ ahangariName.ah7 ] = true
}
local ahLimitPlastic = {
    [ gangup20.gang1 ] = 25,
    [ gangup20.gang2 ] = 25,
    [ gangup20.gang3 ] = 25,
    [ gangup20.gang4 ] = 25,
    [ gangup20.gang5 ] = 25,
    [ ahangariName.ah1 ] = 500,
    [ ahangariName.ah2 ] = 500,
    [ ahangariName.ah3 ] = 500,
    [ ahangariName.ah4 ] = 500,
    [ ahangariName.ah5 ] = 500,
    [ ahangariName.ah6 ] = 500,
    [ ahangariName.ah7 ] = 500
}
local ahLimitCarbon = {
    [ gangup20.gang1 ] = 25,
    [ gangup20.gang2 ] = 25,
    [ gangup20.gang3 ] = 25,
    [ gangup20.gang4 ] = 25,
    [ gangup20.gang5 ] = 25,
    [ ahangariName.ah1 ] = 500,
    [ ahangariName.ah2 ] = 500,
    [ ahangariName.ah3 ] = 500,
    [ ahangariName.ah4 ] = 500,
    [ ahangariName.ah5 ] = 500,
    [ ahangariName.ah6 ] = 500,
    [ ahangariName.ah7 ] = 500
}
local ahLimitSteel = {
    [ gangup20.gang1 ] = 25,
    [ gangup20.gang2 ] = 25,
    [ gangup20.gang3 ] = 25,
    [ gangup20.gang4 ] = 25,
    [ gangup20.gang5 ] = 25,
    [ ahangariName.ah1 ] = 500,
    [ ahangariName.ah2 ] = 500,
    [ ahangariName.ah3 ] = 500,
    [ ahangariName.ah4 ] = 500,
    [ ahangariName.ah5 ] = 500,
    [ ahangariName.ah6 ] = 500,
    [ ahangariName.ah7 ] = 500
}
local ahGunCleaner = {
    [ gangup20.gang1 ] = 10,
    [ gangup20.gang2 ] = 10,
    [ gangup20.gang3 ] = 10,
    [ gangup20.gang4 ] = 10,
    [ gangup20.gang5 ] = 10,
    [ ahangariName.ah1 ] = 500,
    [ ahangariName.ah2 ] = 500,
    [ ahangariName.ah3 ] = 500,
    [ ahangariName.ah4 ] = 500,
    [ ahangariName.ah5 ] = 500,
    [ ahangariName.ah6 ] = 500,
    [ ahangariName.ah7 ] = 500
}
local ahLimitCompMat = {
    -- [ gangup20.gang1 ] = 1,
    -- [ gangup20.gang2 ] = 1,
    -- [ gangup20.gang3 ] = 1,
    -- [ gangup20.gang4 ] = 1,
    -- [ gangup20.gang5 ] = 1,
    [ ahangariName.ah1 ] = 500,
    [ ahangariName.ah2 ] = 500,
    [ ahangariName.ah3 ] = 500,
    [ ahangariName.ah4 ] = 500,
    [ ahangariName.ah5 ] = 500,
    [ ahangariName.ah6 ] = 500,
    [ ahangariName.ah7 ] = 500
}

Config = {
    BlipSprite = 237,
    BlipColor = 26,
    BlipText = 'Workbench',
    CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
    HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job
    Categories = {
        ['weapons'] = {
            Label = 'Permanent Weapons',
            Image = 'weapon1',
        },
        ['weapons2'] = {
            Label = 'Temporary Weapons',
            Image = 'weapon2',
        },
        ['items'] = {
            Label = 'Items',
            Image = 'items',
            Jobs = {}
        },
        ['items2'] = {
            Label = 'Coffee Shop',
            Image = 'items2',
            Jobs = {}
        },
        ['items3'] = {
            Label = 'Daroo',
            Image = 'items3',
            Jobs = {}
        },
        ['skins'] = {
            Label = 'Gun skin',
            Image = 'gunskin',
            Jobs = {}
        },
        ['accesscard'] = {
            Label = 'Access Card',
            Image = 'accesscard',
            Jobs = {}
        },
        ['items5'] = {
            Label = 'Ahangari',
            Image = 'items5',
            Jobs = {}
        },
    },

    gangscost = {
        [11] = 10,
        [12] = 20,
        [13] = 30,
        [14] = 40,
        [15] = 50,
        [16] = 50,
        [17] = 50,
        [18] = 50,
        [19] = 50,
        [20] = 50,
        [21] = 50,
        [22] = 50,
        [23] = 50,
        [24] = 50,
        [25] = 50,
        [26] = 50,
        [27] = 50,
        [28] = 50,
        [29] = 50,
        [30] = 50,
    },

    Dischant = {
        -- ["WEAPON_KNIFE"] =              { forge = 1,  gun_metal = 1  },
        -- ["WEAPON_DAGGER"] =             { forge = 1,  gun_metal = 1  },
        -- ["WEAPON_MACHETE"] =            { forge = 2,  gun_metal = 1  },
        -- ["WEAPON_VINTAGEPISTOL"] =      { forge = 4,  gun_metal = 1  },
        -- ["WEAPON_PISTOL"] =             { forge = 3,  gun_metal = 1  },
        -- ["WEAPON_SNSPISTOL"] =          { forge = 2,  gun_metal = 1  },
        -- ["WEAPON_HEAVYPISTOL"] =        { forge = 4,  gun_metal = 1  },
        -- ["WEAPON_COMBATPISTOL"] =       { forge = 3,  gun_metal = 1  },
        -- ["WEAPON_PISTOL50"] =           { forge = 5,  gun_metal = 2  },
        -- ["WEAPON_SMG"] =                { forge = 8,  gun_metal = 2  },
        -- ["WEAPON_SNSPISTOL_MK2"] =      { forge = 4,  gun_metal = 3  },
        -- ["WEAPON_ASSAULTSMG"] =         { forge = 9,  gun_metal = 3  },
        -- ["WEAPON_CARBINERIFLE"] =       { forge = 11, gun_metal = 4  },
        -- ["WEAPON_ASSAULTRIFLE"] =       { forge = 11, gun_metal = 4  },
        -- ["WEAPON_ADVANCEDRIFLE"] =      { forge = 11, gun_metal = 4  },
        -- ["WEAPON_COMBATPDW"] =          { forge = 11, gun_metal = 4  },
        -- ["WEAPON_BULLPUPRIFLE"] =       { forge = 12, gun_metal = 5  },
        -- ["WEAPON_GUSENBERG"] =          { forge = 13, gun_metal = 5  },
        -- ["WEAPON_ASSAULTSHOTGUN"] =     { forge = 12, gun_metal = 5  },
        -- ["WEAPON_BULLPUPSHOTGUN"] =     { forge = 12, gun_metal = 5  },
        -- ["WEAPON_SAWNOFFSHOTGUN"] =     { forge = 12, gun_metal = 6  },
        -- ["WEAPON_PUMPSHOTGUN"] =        { forge = 12, gun_metal = 6  },
        -- ["WEAPON_KNUCKLE"] =            { forge = 1,  gun_metal = 2  },
        -- ["WEAPON_PISTOL_MK2"] =         { forge = 3,  gun_metal = 4  },
        -- ["WEAPON_SPECIALCARBINE"] =     { forge = 12, gun_metal = 5  },
        -- ["WEAPON_CERAMICPISTOL"] =      { forge = 5,  gun_metal = 3  },
        -- ["WEAPON_PUMPSHOTGUN_MK2"] =    { forge = 16, gun_metal = 8  },
        -- ["WEAPON_BULLPUPRIFLE_MK2"] =   { forge = 16, gun_metal = 9  },
        -- ["WEAPON_DOUBLEACTION"] =       { forge = 20, gun_metal = 20 },
        -- ["WEAPON_SMG_MK2"] =            { forge = 16, gun_metal = 9  },
        -- ["WEAPON_COMPACTRIFLE"] =       { forge = 16, gun_metal = 8  },
        -- ["WEAPON_SPECIALCARBINE_MK2"] = { forge = 16, gun_metal = 13 },
        -- ["WEAPON_MICROSMG"] =           { forge = 20, gun_metal = 13 },
        -- ["WEAPON_ASSAULTRIFLE_MK2"] =   { forge = 16, gun_metal = 13 },
        -- ["WEAPON_CARBINERIFLE_MK2"] =   { forge = 16, gun_metal = 13 },
        -- ["WEAPON_APPISTOL"] =           { forge = 33, gun_metal = 23 },
        -- ["WEAPON_GADGETPISTOL"] =       { forge = 17, gun_metal = 14 },
        -- ["WEAPON_COMBATSHOTGUN"] =      { forge = 25, gun_metal = 9  },
        -- ["WEAPON_MILITARYRIFLE"] =      { forge = 18, gun_metal = 15 },
        -- ["WEAPON_TACTICALRIFLE"] =      { forge = 37, gun_metal = 10 },
        -- ["WEAPON_HEAVYRIFLE"] =         { forge = 25, gun_metal = 6  },
    },

    Recipes = {
------------------ level 0
        ['forge'] = {
            Category = 'items', Level = 1, Time = 5,
            Amount = 50, Money = 0, blackmoney = 500000,
            Ingredients = {},
        },
        ['WEAPON_KNIFE'] = {
            Category = 'weapons', Level = 1, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 3,
                ['wolfram'] = 1,
 				['gun_metal'] = 2,
            },
        },
        ['WEAPON_DAGGER'] = {
            Category = 'weapons', Level = 1, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 4,
                ['wolfram'] = 1,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_MACHETE'] = {
            Category = 'weapons', Level = 1, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
------------------ level 1
        ['WEAPON_VINTAGEPISTOL'] = {
            Category = 'weapons', Level = 3, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 9,
                ['wolfram'] = 4,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_VINTAGEPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 3, Time = 15,
            name = 'WEAPON_VINTAGEPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_PISTOL'] = {
            Category = 'weapons', Level = 1, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_PISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 1, Time = 15,
            name = 'WEAPON_PISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 1,
                ['gun_metal'] = 1,
            }
        },
        ['WEAPON_SNSPISTOL'] = {
            Category = 'weapons', Level = 1, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 4,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_SNSPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 1, Time = 15,
            name = 'WEAPON_SNSPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 3,
                ['wolfram'] = 1,
                ['gun_metal'] = 1,
            }
        },
------------------ level 2
        ['WEAPON_HEAVYPISTOL'] = {
            Category = 'weapons', Level = 4, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 11,
                ['wolfram'] = 5,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_HEAVYPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 4, Time = 15,
            name = 'WEAPON_HEAVYPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 3,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_COMBATPISTOL'] = {
            Category = 'weapons', Level = 2, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 3,
                ['gun_metal'] = 3,
            }
        },
        ['WEAPON_COMBATPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 2, Time = 15,
            name = 'WEAPON_COMBATPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 4,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
------------------ level 3
        ['WEAPON_PISTOL50'] = {
            Category = 'weapons', Level = 4, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 15,
                ['wolfram'] = 6,
                ['gun_metal'] = 5,
            }
        },
        ['WEAPON_PISTOL50_TEMP_10'] = {
            Category = 'weapons2', Level = 4, Time = 15,
            name = 'WEAPON_PISTOL50',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 10,
                ['wolfram'] = 4,
                ['gun_metal'] = 3,
            }
        },
        ['WEAPON_SMG'] = {
            Category = 'weapons', Level = 3, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_SMG_TEMP_10'] = {
            Category = 'weapons2', Level = 3, Time = 20,
            name = 'WEAPON_SMG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 12,
                ['wolfram'] = 5,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_SNSPISTOL_MK2'] = {
            Category = 'weapons', Level = 5, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_SNSPISTOL_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 5, Time = 25,
            name = 'WEAPON_SNSPISTOL_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 1,
                ['gun_metal'] = 1,
            }
        },
------------------ level 4
        ['WEAPON_ASSAULTSMG'] = {
            Category = 'weapons', Level = 4, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 19,
                ['wolfram'] = 8,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_ASSAULTSMG_TEMP_10'] = {
            Category = 'weapons2', Level = 4, Time = 20,
            name = 'WEAPON_ASSAULTSMG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 12,
                ['wolfram'] = 6,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_CARBINERIFLE'] = {
            Category = 'weapons', Level = 5, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 25,
                ['wolfram'] = 11,
                ['gun_metal'] = 8,
            }
        },
        ['WEAPON_CARBINERIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 5, Time = 20,
            name = 'WEAPON_CARBINERIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 5,
            }
        },
------------------ level 5
        ['tur'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['iron_piece'] = 5,
            }
        },
        ['WEAPON_ASSAULTRIFLE'] = {
            Category = 'weapons', Level = 7, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 9,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_ASSAULTRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 7, Time = 20,
            name = 'WEAPON_ASSAULTRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 6,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_ADVANCEDRIFLE'] = {
            Category = 'weapons', Level = 6, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 27,
                ['wolfram'] = 13,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_ADVANCEDRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 6, Time = 20,
            name = 'WEAPON_ADVANCEDRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 19,
                ['wolfram'] = 9,
                ['gun_metal'] = 7,
            }
        },
        ['rc'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 1,
                ["engine3"] = 1,
                ["iron_piece"] = 10,
                ["iron"] = 1,
                ["gold"] = 1,
				['petrol'] = 25,
				['petrol_raffin'] = 25,
				['essence'] = 50,
				['fabric'] = 10,
            }
        },
        ['trinket1'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 10,
                ["lockpick"] = 1,
                ["sc"] = 10,
            }
        },
        ['clip'] = {
            Category = 'items', Level = 5, Time = 5,
            Amount = 20, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 10,
            }
        },
        ['grip'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 25,
                ["gold_piece"] = 5,
                ["petrol"] = 5,
            }
        },
        ['silencer'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 25,
                ["gold_piece"] = 5,
                ["petrol"] = 5,
            }
        },
        ['blowtorch'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 20,
                ['gold_piece'] = 30,
            }
        },
        ['anbor'] = {
            Category = 'items', Level = 5, Time = 5,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron"] = 1,
                ['aluminum'] = 1,
            }
        },
        ['raspberry'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 35,
                ['gold_piece'] = 25,
                ['petrol'] = 15,
                ['petrol_raffin'] = 15,
                ['fabric'] = 5,
                ['diamond'] = 5,
            }
        },
        ['radio'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ["phone"] = 7,
            }
        },
        ['compass'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ["phone"] = 7,
            }
        },
        ['kingkey'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["iron_piece"] = 8,
                ["gold_piece"] = 2,
                ["petrol"] = 2,
                ["diamond"] = 1,
            }
        },
        ['ghayegh_badi'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["petrol_raffin"] = 5,
                ["fabric"] = 5,
            }
        },
        ['darkphone'] = {
            Category = 'items', Level = 5, Time = 10,
            Amount = 1, limit = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 3,
                ['phone'] = 1,
                ['iron_piece'] = 10,
                ['gold_piece'] = 10,
                ['diamond'] = 2,
            }
        },
        ['lockpick'] = {
            Category = 'items', Level = 5, Time = 5,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['alum_oxide'] = 30,
            }
        },
        ['uwfinder'] = {
            Category = 'items', Level = 5, Time = 5,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['gold_piece'] = 4,
                ['alum_oxide'] = 10,
                ['diamond'] = 2,
            }
        },
        ['mask_ghavasi'] = {
            Category = 'items', Level = 5, Time = 5,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['gold_piece'] = 9,
                ['petrol_raffin'] = 25,
                ['alum_oxide'] = 10,
                ['plastic'] = 10,
            }
        },
------------------ level 6
        ['WEAPON_COMBATPDW'] = {
            Category = 'weapons', Level = 6, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 12,
                ['wolfram'] = 6,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_COMBATPDW_TEMP_10'] = {
            Category = 'weapons2', Level = 6, Time = 20,
            name = 'WEAPON_COMBATPDW',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 4,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_BULLPUPRIFLE'] = {
            Category = 'weapons', Level = 8, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 21,
                ['wolfram'] = 10,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_BULLPUPRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 8, Time = 20,
            name = 'WEAPON_BULLPUPRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 7,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_GUSENBERG'] = {
            Category = 'weapons', Level = 12, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 12,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_GUSENBERG_TEMP_10'] = {
            Category = 'weapons2', Level = 12, Time = 20,
            name = 'WEAPON_GUSENBERG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 19,
                ['wolfram'] = 8,
                ['gun_metal'] = 7,
            }
        },
------------------ level 7
        ['WEAPON_ASSAULTSHOTGUN'] = {
            Category = 'weapons', Level = 10, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 24,
                ['wolfram'] = 12,
                ['gun_metal'] = 14,
            }
        },
        ['WEAPON_ASSAULTSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 10, Time = 20,
            name = 'WEAPON_ASSAULTSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 17,
                ['wolfram'] = 8,
                ['gun_metal'] = 9,
            }
        },
        ['WEAPON_BULLPUPSHOTGUN'] = {
            Category = 'weapons', Level = 12, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 32,
                ['wolfram'] = 16,
                ['gun_metal'] = 17,
            }
        },
        ['WEAPON_BULLPUPSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 12, Time = 20,
            name = 'WEAPON_BULLPUPSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 22,
                ['wolfram'] = 11,
                ['gun_metal'] = 11,
            }
        },
        ['WEAPON_SAWNOFFSHOTGUN'] = {
            Category = 'weapons', Level = 11, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 34,
                ['wolfram'] = 17,
                ['gun_metal'] = 19,
            }
        },
        ['WEAPON_SAWNOFFSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 11, Time = 20,
            name = 'WEAPON_SAWNOFFSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 25,
                ['wolfram'] = 11,
                ['gun_metal'] = 13,
            }
        },
        ['WEAPON_PUMPSHOTGUN'] = {
            Category = 'weapons', Level = 9, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 31,
                ['wolfram'] = 14,
                ['gun_metal'] = 16,
            }
        },
        ['WEAPON_PUMPSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 9, Time = 20,
            name = 'WEAPON_PUMPSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 21,
                ['wolfram'] = 10,
                ['gun_metal'] = 11,
            }
        },
        ['trinket2'] = {
            Category = 'items', Level = 7, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["trinket1"] = 1,
                ["ember"] = 10,
            }
        },
------------------ level 8
        ['WEAPON_KNUCKLE'] = {
            Category = 'weapons', Level = 7, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 1,
                ['gun_metal'] = 5,
            }
        },
        ['WEAPON_KNUCKLE_TEMP_10'] = {
            Category = 'weapons2', Level = 7, Time = 15,
            name = 'WEAPON_KNUCKLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 2,
                ['wolfram'] = 1,
                ['gun_metal'] = 3,
            }
        },
        ['WEAPON_PISTOL_MK2'] = {
            Category = 'weapons', Level = 7, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_PISTOL_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 7, Time = 25,
            name = 'WEAPON_PISTOL_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 2,
                ['gun_metal'] = 4,
            }
        },
        ['trinket3'] = {
            Category = 'items', Level = 8, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["trinket2"] = 1,
                ["ember"] = 30,
            }
        },
------------------ level 9
        ['WEAPON_SPECIALCARBINE'] = {
            Category = 'weapons', Level = 8, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 24,
                ['wolfram'] = 11,
                ['gun_metal'] = 9,
            }
        },
        ['WEAPON_SPECIALCARBINE_TEMP_10'] = {
            Category = 'weapons2', Level = 8, Time = 20,
            name = 'WEAPON_SPECIALCARBINE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_CERAMICPISTOL'] = {
            Category = 'weapons', Level = 9, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 3,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_CERAMICPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 9, Time = 20,
            name = 'WEAPON_CERAMICPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 5,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
------------------ level 10
        ['uav'] = { -- UAV
            Category = 'items', Level = 10, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 2,
                ["engine1"] = 1,
                ['iron_piece'] = 10,
                ['petrol'] = 25,
            }
        },
        ['armoredhat'] = { -- armoredhat
            Category = 'items', Level = 10, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['alum_oxide'] = 50,
            }
        },
        ['WEAPON_PUMPSHOTGUN_MK2'] = {
            Category = 'weapons', Level = 13, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 37,
                ['wolfram'] = 18,
                ['gun_metal'] = 21,
            }
        },
        ['WEAPON_PUMPSHOTGUN_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 13, Time = 25,
            name = 'WEAPON_PUMPSHOTGUN_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 27,
                ['wolfram'] = 12,
                ['gun_metal'] = 14,
            }
        },
        ['WEAPON_BULLPUPRIFLE_MK2'] = {
            Category = 'weapons', Level = 11, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 29,
                ['wolfram'] = 14,
                ['gun_metal'] = 13,
            }
        },
        ['WEAPON_BULLPUPRIFLE_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 11, Time = 25,
            name = 'WEAPON_BULLPUPRIFLE_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 21,
                ['wolfram'] = 9,
                ['gun_metal'] = 9,
            }
        },
        ['yusuf'] = {
            Category = 'skins', Level = 10, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["gold_piece"] = 20,
                ["gold"] = 3,
            }
        },
------------------ level 11
        ['WEAPON_DOUBLEACTION'] = {
            Category = 'weapons', Level = 12, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 7,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_DOUBLEACTION_TEMP_10'] = {
            Category = 'weapons2', Level = 12, Time = 25,
            name = 'WEAPON_DOUBLEACTION',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 11,
                ['wolfram'] = 5,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_SMG_MK2'] = {
            Category = 'weapons', Level = 10, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 10,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_SMG_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 10, Time = 25,
            name = 'WEAPON_SMG_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 7,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_COMPACTRIFLE'] = {
            Category = 'weapons', Level = 11, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 17,
                ['wolfram'] = 8,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_COMPACTRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 11, Time = 20,
            name = 'WEAPON_COMPACTRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 13,
                ['wolfram'] = 5,
                ['gun_metal'] = 4,
            }
        },
        ['camo1'] = {
            Category = 'skins', Level = 11, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 10,
 				["diamond"] = 3,
                ["gold_piece"] = 10,
                ["gold"] = 1,
				['petrol'] = 10,
            }
        },
        ['camo2'] = {
            Category = 'skins', Level = 11, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 10,
 				["diamond"] = 3,
                ["gold_piece"] = 10,
                ["gold"] = 1,
				['petrol'] = 10,
            }
        },
------------------ level 12
        ['WEAPON_SPECIALCARBINE_MK2'] = {
            Category = 'weapons', Level = 14, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 28,
                ['wolfram'] = 14,
                ['gun_metal'] = 12,
            }
        },
        ['WEAPON_SPECIALCARBINE_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 14, Time = 25,
            name = 'WEAPON_SPECIALCARBINE_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 21,
                ['wolfram'] = 9,
                ['gun_metal'] = 8,
            }
        },
        ['camo3'] = {
            Category = 'skins', Level = 12, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 10,
 				["diamond"] = 3,
                ["gold_piece"] = 10,
                ["gold"] = 1,
				['petrol'] = 10,
            }
        },
        ['camo4'] = {
            Category = 'skins', Level = 12, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 10,
 				["diamond"] = 3,
                ["gold_piece"] = 10,
                ["gold"] = 1,
				['petrol'] = 10,
            }
        },
        ['desomorphine2'] = { -- vest up
            Category = 'items3', Level = 12, Time = 10,
            Amount = 1, limit = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mushroom"] = 5,
                ["heroine"] = 3,
            }
        },
------------------ level 13
        ['WEAPON_MICROSMG'] = {
            Category = 'weapons', Level = 15, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 22,
                ['wolfram'] = 10,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_MICROSMG_TEMP_10'] = {
            Category = 'weapons2', Level = 15, Time = 25,
            name = 'WEAPON_MICROSMG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 15,
                ['wolfram'] = 7,
                ['gun_metal'] = 7,
            }
        },
        ['camo5'] = {
            Category = 'skins', Level = 13, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 15,
 				["diamond"] = 4,
                ["gold_piece"] = 15,
				['petrol_raffin'] = 25,
            }
        },
        ['camo6'] = {
            Category = 'skins', Level = 13, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 15,
 				["diamond"] = 4,
                ["gold_piece"] = 15,
				['petrol_raffin'] = 25,
            }
        },
        ['diastat2'] = { -- speed up
            Category = 'items3', Level = 13, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mushroom"] = 5,
                ["marijuana"] = 10,
            }
        },
        ['sianor2'] = {
            Category = 'items3', Level = 13, Time = 10,
            Amount = 4, Money = 0, blackmoney = 0,
            Ingredients = {
                ["extra_marijuana"] = 25,
                ["extra_crack"] = 20,
                ["extra_heroine"] = 10,
                ["extra_meth"] = 10,
                ["mushroom"] = 75,
                ["titopgold"] = 4,
            }
        },
        ['sianor3'] = {
            Category = 'items3', Level = 5, Time = 10,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["sianor"] = 10,
                ["titopgold"] = 10,
            }
        },
------------------ level 14
        ['WEAPON_ASSAULTRIFLE_MK2'] = {
            Category = 'weapons', Level = 13, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 24,
                ['wolfram'] = 12,
                ['gun_metal'] = 9,
            }
        },
        ['WEAPON_ASSAULTRIFLE_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 13, Time = 25,
            name = 'WEAPON_ASSAULTRIFLE_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 17,
                ['wolfram'] = 8,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_CARBINERIFLE_MK2'] = {
            Category = 'weapons', Level = 13, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 28,
                ['wolfram'] = 14,
                ['gun_metal'] = 12,
            }
        },
        ['WEAPON_CARBINERIFLE_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 13, Time = 25,
            name = 'WEAPON_CARBINERIFLE_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 21,
                ['wolfram'] = 9,
                ['gun_metal'] = 8,
            }
        },
        ['camo7'] = {
            Category = 'skins', Level = 14, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 15,
 				["diamond"] = 4,
                ["gold_piece"] = 15,
				['petrol_raffin'] = 25,
            }
        },
        ['camo8'] = {
            Category = 'skins', Level = 14, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron_piece"] = 15,
 				["diamond"] = 4,
 				["gold_piece"] = 15,
				['petrol_raffin'] = 25,
            }
        },
        ['wellbutrin2'] = { -- hel up
            Category = 'items3', Level = 14, Time = 10,
            limit = 10, Amount = 1,
            Money = 0, blackmoney = 0,
            Ingredients = {
                ["mushroom"] = 5,
                ["cocaine"] = 6,
            }
        },
------------------ level 15
        ['WEAPON_APPISTOL'] = {
            Category = 'weapons', Level = 19, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 10,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_APPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 19, Time = 25,
            name = 'WEAPON_APPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 7,
                ['gun_metal'] = 7,
            }
        },
        ['camo9'] = {
            Category = 'skins', Level = 15, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron"] = 1,
 				["diamond"] = 5,
                ["gold"] = 1,
				['essence'] = 100,
            }
        },
        ['camo10'] = {
            Category = 'skins', Level = 15, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron"] = 1,
 				["diamond"] = 5,
                ["gold"] = 1,
				['essence'] = 100,
            }
        },
        ['camo11'] = {
            Category = 'skins', Level = 15, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 3,
                ["iron"] = 1,
 				["diamond"] = 10,
                ["gold"] = 2,
				['essence'] = 100,
            }
        },
        ['scope'] = {
            Category = 'skins', Level = 15, Time = 15,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 50,
                ['wolfram'] = 25,
                ["iron"] = 4,
                ["diamond"] = 10,
                ["gold"] = 5,
                ['petrol'] = 10,
                ['petrol_raffin'] = 10,
                ['essence'] = 10,
            }
        },
        -- ['lsd2'] = {
        --     Category = 'items3', Level = 15, Time = 10,
        --     Amount = 1, Money = 0, blackmoney = 0,
        --     Ingredients = {
        --         ["mushroom"] = 5,
        --         ["meth"] = 3,
        --     }
        -- },
        ['mask_shab'] = {
            Category = 'items', Level = 15, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['cutted_wood'] = 20,
                ['petrol'] = 20,
                ['petrol_raffin'] = 20,
                ['essence'] = 20,
                ['fabric'] = 20,
            }
        },
------------------ level 16
        ['firework'] = {
            Category = 'items', Level = 16, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 12,
                ['cutted_wood'] = 10,
                ['petrol'] = 10,
                ['petrol_raffin'] = 10,
                ['essence'] = 10,
                ['fabric'] = 10,
            }
        },
        ['eclip'] = {
            Category = 'items', Level = 16, Time = 20,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 76,
                ['wolfram'] = 37,
                ["iron"] = 4,
                ["diamond"] = 10,
                ["gold"] = 5,
                ['petrol'] = 10,
                ['petrol_raffin'] = 10,
                ['essence'] = 10,
            }
        },
        ['tintblack'] = {
            Category = 'skins', Level = 16, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 10,
                ["diamond"] = 4,
                ["gold"] = 1,
                ['essence'] = 50,
            }
        },
        ['tintcream'] = {
            Category = 'skins', Level = 16, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 12,
                ["diamond"] = 5,
                ["gold"] = 2,
                ['essence'] = 50,
            }
        },
        ['WEAPON_GADGETPISTOL'] = {
            Category = 'weapons', Level = 16, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 7,
                ['gun_metal'] = 5,
            }
        },
        ['WEAPON_GADGETPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 16, Time = 25,
            name = 'WEAPON_GADGETPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 11,
                ['wolfram'] = 4,
                ['gun_metal'] = 3,
            }
        },
------------------ level 17
        ['tintgold'] = {
            Category = 'skins', Level = 17, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 30,
                ['wolfram'] = 15,
                ["diamond"] = 6,
                ["gold"] = 3,
                ['essence'] = 50,
            }
        },
        ['tintgreen'] = {
            Category = 'skins', Level = 17, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 36,
                ['wolfram'] = 17,
                ["diamond"] = 7,
                ["gold"] = 4,
                ['essence'] = 50,
            }
        },
        ['WEAPON_COMBATSHOTGUN'] = {
            Category = 'weapons', Level = 14, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 13,
                ['gun_metal'] = 17,
            }
        },
        ['WEAPON_COMBATSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 14, Time = 25,
            name = 'WEAPON_COMBATSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 18,
                ['wolfram'] = 9,
                ['gun_metal'] = 11,
            }
        },
        ['GADGET_PARACHUTE'] = {
            Category = 'items', Level = 17, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 9,
                ['wolfram'] = 3,
                ['cutted_wood'] = 20,
                ['petrol'] = 20,
                ['petrol_raffin'] = 20,
                ['essence'] = 20,
                ['fabric'] = 20,
            }
        },
------------------ level 18
        ['tintorange'] = {
            Category = 'skins', Level = 18, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 40,
                ['wolfram'] = 20,
                ["diamond"] = 8,
                ["gold"] = 5,
                ['essence'] = 50,
            }
        },
        ['WEAPON_MILITARYRIFLE'] = {
            Category = 'weapons', Level = 15, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 12,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_MILITARYRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 15, Time = 25,
            name = 'WEAPON_MILITARYRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 19,
                ['wolfram'] = 8,
                ['gun_metal'] = 7,
            }
        },
------------------ level 19 
        ['tintpink'] = {
            Category = 'skins', Level = 19, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 46,
                ['wolfram'] = 22,
                ["diamond"] = 9,
                ["gold"] = 6,
                ['essence'] = 50,
            }
        },
        ['WEAPON_FLARE'] = {
            Category = 'weapons', Level = 19, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 12,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_TACTICALRIFLE'] = {
            Category = 'weapons', Level = 17, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 24,
                ['wolfram'] = 11,
                ['gun_metal'] = 9,
            }
        },
        ['WEAPON_TACTICALRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 17, Time = 25,
            name = 'WEAPON_TACTICALRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 6,
            }
        },
------------------ level 20 
        ['tintplat'] = {
            Category = 'skins', Level = 20, Time = 10,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 50,
                ['wolfram'] = 25,
                ["diamond"] = 10,
                ["gold"] = 7,
                ['essence'] = 50,
            }
        },
        ['WEAPON_HEAVYRIFLE'] = {
            Category = 'weapons', Level = 20, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 18,
                ['wolfram'] = 9,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_HEAVYRIFLE_TEMP_10'] = {
            Category = 'weapons2', Level = 20, Time = 25,
            name = 'WEAPON_HEAVYRIFLE',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 13,
                ['wolfram'] = 6,
                ['gun_metal'] = 4,
            }
        },
---------------------- New Gun recep
        ['WEAPON_COMBATMG'] = {
            Category = 'weapons', Level = 16, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 26,
                ['wolfram'] = 13,
                ['gun_metal'] = 18,
            }
        },
        ['WEAPON_COMBATMG_TEMP_10'] = {
            Category = 'weapons2', Level = 16, Time = 25,
            name = 'WEAPON_COMBATMG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 18,
                ['wolfram'] = 9,
                ['gun_metal'] = 12,
            }
        },
        ['WEAPON_COMBATMG_MK2'] = {
            Category = 'weapons', Level = 17, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 30,
                ['wolfram'] = 15,
                ['gun_metal'] = 20,
            }
        },
        ['WEAPON_COMBATMG_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 17, Time = 25,
            name = 'WEAPON_COMBATMG_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 22,
                ['wolfram'] = 10,
                ['gun_metal'] = 14,
            }
        },
        ['WEAPON_MG'] = {
            Category = 'weapons', Level = 14, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 22,
                ['wolfram'] = 11,
                ['gun_metal'] = 16,
            }
        },
        ['WEAPON_MG_TEMP_10'] = {
            Category = 'weapons2', Level = 14, Time = 25,
            name = 'WEAPON_MG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 7,
                ['gun_metal'] = 11,
            }
        },
        ['WEAPON_MARKSMANPISTOL'] = {
            Category = 'weapons', Level = 18, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 9,
                ['wolfram'] = 4,
                ['gun_metal'] = 5,
            }
        },
        ['WEAPON_MARKSMANPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 18, Time = 25,
            name = 'WEAPON_MARKSMANPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 7,
                ['wolfram'] = 2,
                ['gun_metal'] = 3,
            }
        },
        ['WEAPON_NAVYREVOLVER'] = {
            Category = 'weapons', Level = 19, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 10,
                ['wolfram'] = 5,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_NAVYREVOLVER_TEMP_10'] = {
            Category = 'weapons2', Level = 19, Time = 25,
            name = 'WEAPON_NAVYREVOLVER',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 3,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_PISTOLXM3'] = {
            Category = 'weapons', Level = 20, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 3,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_PISTOLXM3_TEMP_10'] = {
            Category = 'weapons2', Level = 20, Time = 25,
            name = 'WEAPON_PISTOLXM3',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 4,
                ['wolfram'] = 2,
                ['gun_metal'] = 2,
            }
        },
        ['WEAPON_REVOLVER'] = {
            Category = 'weapons', Level = 19, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 13,
                ['wolfram'] = 5,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_REVOLVER_TEMP_10'] = {
            Category = 'weapons2', Level = 19, Time = 25,
            name = 'WEAPON_REVOLVER',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 8,
                ['wolfram'] = 4,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_REVOLVER_MK2'] = {
            Category = 'weapons', Level = 18, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 12,
                ['wolfram'] = 5,
                ['gun_metal'] = 5,
            }
        },
        ['WEAPON_REVOLVER_MK2_TEMP_10'] = {
            Category = 'weapons2', Level = 18, Time = 25,
            name = 'WEAPON_REVOLVER_MK2',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 9,
                ['wolfram'] = 3,
                ['gun_metal'] = 3,
            }
        },
        ['WEAPON_AUTOSHOTGUN'] = {
            Category = 'weapons', Level = 16, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 22,
                ['wolfram'] = 11,
                ['gun_metal'] = 13,
            }
        },
        ['WEAPON_AUTOSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 16, Time = 25,
            name = 'WEAPON_AUTOSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 7,
                ['gun_metal'] = 9,
            }
        },
        ['WEAPON_DBSHOTGUN'] = {
            Category = 'weapons', Level = 17, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 38,
                ['wolfram'] = 19,
                ['gun_metal'] = 24,
            }
        },
        ['WEAPON_DBSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 17, Time = 25,
            name = 'WEAPON_DBSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 27,
                ['wolfram'] = 13,
                ['gun_metal'] = 16,
            }
        },
        ['WEAPON_HEAVYSHOTGUN'] = {
            Category = 'weapons', Level = 15, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 20,
                ['wolfram'] = 9,
                ['gun_metal'] = 12,
            }
        },
        ['WEAPON_HEAVYSHOTGUN_TEMP_10'] = {
            Category = 'weapons2', Level = 15, Time = 25,
            name = 'WEAPON_HEAVYSHOTGUN',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 6,
                ['gun_metal'] = 8,
            }
        },
        ['WEAPON_MACHINEPISTOL'] = {
            Category = 'weapons', Level = 13, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_MACHINEPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 13, Time = 25,
            name = 'WEAPON_MACHINEPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 12,
                ['wolfram'] = 5,
                ['gun_metal'] = 4,
            }
        },
        ['WEAPON_MINISMG'] = {
            Category = 'weapons', Level = 14, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 25,
                ['wolfram'] = 11,
                ['gun_metal'] = 10,
            }
        },
        ['WEAPON_MINISMG_TEMP_10'] = {
            Category = 'weapons2', Level = 14, Time = 25,
            name = 'WEAPON_MINISMG',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 16,
                ['wolfram'] = 8,
                ['gun_metal'] = 7,
            }
        },
        ['WEAPON_TECPISTOL'] = {
            Category = 'weapons', Level = 15, Time = 25,
            Amount = 1, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 14,
                ['wolfram'] = 6,
                ['gun_metal'] = 6,
            }
        },
        ['WEAPON_TECPISTOL_TEMP_10'] = {
            Category = 'weapons2', Level = 15, Time = 25,
            name = 'WEAPON_TECPISTOL',
            Amount = 1, day = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 10,
                ['wolfram'] = 4,
                ['gun_metal'] = 4,
            }
        },
---------------------- cart
        ['redacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ["orangeacard"] = 5,
            }
        },
        ['orangeacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ["yellowacard"] = 5,
            }
        },
        ['yellowacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ["greenacard"] = 5,
            }
        },
        ['greenacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ["blueacard"] = 5,
            }
        },
        ['blueacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
                ['forge'] = 6,
                ['wolfram'] = 2,
                ["purpleacard"] = 5,
            }
        },
        ['purpleacard'] = {
            Category = 'accesscard', Level = 5, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            Ingredients = {
               ['forge'] = 6,
               ['wolfram'] = 2,
               ["redacard"] = 5,
            }
        },
------------------ caffe
        ['vodka2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["orange_pack"] = 90,
            },
            access = caffeList
        },
        ['whisky2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["corn_pack"] = 90,
            },
            access = caffeList
        },
        ['absolut2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["wheat_pack"] = 90,
            },
            access = caffeList
        },
        ['cider2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["apple_pack"] = 90,
            },
            access = caffeList
        },
        ['wine2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["grape_pack"] = 90,
            },
            access = caffeList
        },
        ['sake2'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 4,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["rice_pack"] = 90,
            },
            access = caffeList
        },
------------------ Abmive
        ['juice_beer'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 50,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["wheat_pack"] = 20,
            },
            access = caffeList
        },
        ['juice_orange'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 50,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["orange_pack"] = 20,
            },
            access = caffeList
        },
        ['juice_grape'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 50,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["grape_pack"] = 20,
            },
            access = caffeList
        },
        ['juice_apple'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 50,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["apple_pack"] = 20,
            },
            access = caffeList
        },
        ['juice_caffee'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 50,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["caffee_pack"] = 30,
            },
            access = caffeList
        },
---------------------- tanbacoo
        ['tbc_apple'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 6,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["apple_pack"] = 30,
            },
            access = caffeList
        },
        ['tbc_orange'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 6,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["orange_pack"] = 30,
            },
            access = caffeList
        },
        ['tbc_grape'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 6,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["grape_pack"] = 30,
            },
            access = caffeList
        },
--------------------- ghaza
        ['boar_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 8, Money = 0, blackmoney = 0,
            Ingredients = {
                ["boar_meat"] = 1,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['boar_soup'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 8, Money = 0, blackmoney = 0,
            Ingredients = {
                ["boar_meat"] = 1,
                ["water"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['deer_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 6, Money = 0, blackmoney = 0,
            Ingredients = {
                ["deer_meat"] = 1,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['deer_soup'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 6, Money = 0, blackmoney = 0,
            Ingredients = {
                ["deer_meat"] = 1,
                ["water"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['pig_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 6, Money = 0, blackmoney = 0,
            Ingredients = {
                ["pig_meat"] = 1,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['pig_soup'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 6, Money = 0, blackmoney = 0,
            Ingredients = {
                ["pig_meat"] = 1,
                ["water"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['rabbit_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 23, Money = 0, blackmoney = 0,
            Ingredients = {
                ["rabbit_meat"] = 1,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['rabbit_soup'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 23, Money = 0, blackmoney = 0,
            Ingredients = {
                ["rabbit_meat"] = 1,
                ["water"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['kotlet_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 23, Money = 0, blackmoney = 0,
            Ingredients = {
                ["pigeon_meat"] = 1,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['pigeon_soup'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 23, Money = 0, blackmoney = 0,
            Ingredients = {
                ["pigeon_meat"] = 1,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['sardine_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_sardine"] = 14,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['sangsar_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_sangsar"] = 11,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['ordak_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_ordak"] = 11,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['ghezel_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_ghezel"] = 10,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['hamoor_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_hamoor"] = 10,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['sorkhoo_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_sorkhoo"] = 10,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['salmon_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_salmon"] = 10,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['shooride_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_shooride"] = 10,
                ["bread"] = 1,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['tilapia_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_tilapia"] = 10,
                ["bread"] = 1,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['sefid_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_sefid"] = 9,
                ["bread"] = 2,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['shir_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_shir"] = 9,
                ["bread"] = 1,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['meygoo_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["mahi_meygoo"] = 8,
                ["bread"] = 4,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['chicken_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["slaughtered_chicken"] = 6,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
        ['jooje_kebab'] = {
            Category = 'items2', Level = 5, Time = 5, limit = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ["packaged_chicken"] = 24,
                ["bread"] = 3,
                ["petrol"] = 1,
            },
            access = caffeList
        },
---------------------- ahangari
        ['plastic'] = {
            Category = 'items5', Level = 9, Time = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            limit = 1, customLimit = ahLimitPlastic,
            Ingredients = {
                ['petrol'] = 25,
                ['wool'] = 25,
            },
            access = shopAhangari
        },
        ['carbon'] = {
            Category = 'items5', Level = 9, Time = 5,
            Amount = 20, Money = 0, blackmoney = 0,
            limit = 1, customLimit = ahLimitCarbon,
            Ingredients = {
                ['wood'] = 10,
                ['petrol'] = 10,
                ['petrol_raffin'] = 5,
                ['essence'] = 5,
            },
            access = shopAhangari
        },
        ['steel'] = {
            Category = 'items5', Level = 9, Time = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            limit = 1, customLimit = ahLimitSteel,
            Ingredients = {
                ['iron_piece'] = 4,
                ['petrol'] = 10,
                ['wolfram'] = 1,
                ['carbon'] = 10,
            },
            access = shopAhangari
        },
        ['gun_cleaner'] = {
            Category = 'items5', Level = 9, Time = 5,
            Amount = 5, Money = 0, blackmoney = 0,
            limit = 1, customLimit = ahGunCleaner,
            Ingredients = {
                ['petrol'] = 5,
                ['essence'] = 15,
                ['fabric'] = 5,
            },
            access = shopAhangari
        },
        ['comp_mat'] = {
            Category = 'items5', Level = 9, Time = 5,
            Amount = 20,
            Money = 0, blackmoney = 0,
            limit = 1, customLimit = ahLimitCompMat,
            Ingredients = {
                ['gold_piece'] = 19,
                ['gold'] = 2,
                ['fabric'] = 10,
                ['diamond'] = 5,
                ['gun_metal'] = 1,
            },
            access = shopAhangari
        },
---------------------- GunShop gunmetal
        ['gun_metal'] = {
            Category = 'items5', Level = 5, Time = 5,
            Amount = 10, Money = 0, blackmoney = 0,
            Ingredients = {
                ['gold_piece'] = 5,
                ['aluminum'] = 10,
                ['diamond'] = 3,
                ['wolfram'] = 2,
                ['plastic'] = 5,
                ['steel'] = 10,
            },
        },
    },
--
    Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access

        { coords = vec(591.62, -3273.71, 6.0),      recipes = {}, blip = false, radius = 2.0 }, -- public
        -- gangs
        { coords = vec(811.19, -2532.77, 22.45),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_01
        { coords = vec(990.89, -2545.34, 28.33),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_02
        { coords = vec(1074.67, -2329.03, 30.3),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_03
        { coords = vec(959.52, -2124.39, 31.46),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_04
        { coords = vec(1361.74, -2092.65, 47.21),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_05
        { coords = vec(149.97, -2205.05, 4.69),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_07
        { coords = vec(-109.52, -2212.08, 7.81),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_08
        { coords = vec(-432.07, -1673.66, 19.03),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_09
        { coords = vec(-613.15, -1623.85, 33.01),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_10
        { coords = vec(983.7, -91.04, 74.85),       recipes = {}, blip = false, radius = 2.0 }, -- Gang G_11
        { coords = vec(1405.54, 1137.44, 109.75),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_12
        { coords = vec(-133.92, 869.91, 232.69),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_16
        { coords = vec(-78.31, 1002.53, 230.61),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_18
        { coords = vec(-571.17, 299.88, 84.56),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_19
        { coords = vec(-888.53, -53.98, 38.05),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_20
        { coords = vec(-815.77, 178.53, 76.74),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_27
        { coords = vec(-1121.44, 363.62, 74.97),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_31
        { coords = vec(-1361.81, 122.36, 56.51),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_34 
        { coords = vec(-1550.91, 84.03, 53.87),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_35
        { coords = vec(-1581.52, -20.69, 57.57),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_36
        { coords = vec(-1589.65, -82.61, 54.33),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_37
        { coords = vec(-1919.25, 553.67, 114.44),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_42
        { coords = vec(-1790.41, 430.35, 125.21),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_43
        { coords = vec(-1736.13, 372.17, 89.73),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_44
        { coords = vec(-1545.99, 421.32, 109.66),   recipes = {}, blip = false, radius = 1.5 }, -- Gang G_45
        { coords = vec(-1535.1, 844.24, 177.05),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_49
        { coords = vec(-3194.99, 832.46, 8.93),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_51
        { coords = vec(-2678.76, 1327.51, 140.88),  recipes = {}, blip = false, radius = 2.0 }, -- Gang G_52
        { coords = vec(-2614.63, 1684.65, 141.87),  recipes = {}, blip = false, radius = 2.0 }, -- Gang G_53
        { coords = vec(-1870.29, 2061.68, 135.43),  recipes = {}, blip = false, radius = 2.0 }, -- Gagn G_55
        { coords = vec(1990.6, 3045.63, 47.22),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_60
        { coords = vec(-1565.72, -214.37, 49.5),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_61
        { coords = vec(-315.94, -2781.5, 5.0),      recipes = {}, blip = false, radius = 2.0 }, -- Gang G_62
        { coords = vec(-1483.14, -34.52, 51.32),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_65
        { coords = vec(15.52, -1822.19, 24.95),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_66
        { coords = vec(221.33, -1987.23, 19.69),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_67
        { coords = vec(-118.06, -2212.11, 7.81),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_68
        { coords = vec(552.26, -2769.97, 6.09),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_69
        { coords = vec(-987.66, 338.54, 72.07),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_70
        { coords = vec(-97.03, -1792.12, 26.91),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_72
        { coords = vec(167.27, 1703.5, 227.39),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_73
        { coords = vec(-638.45, -2389.01, 13.95),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_74
        { coords = vec(309.7, -2557.93, 5.7),       recipes = {}, blip = false, radius = 2.0 }, -- Gang G_78
        { coords = vec(-683.53, -1449.38, 5.0),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_84
        { coords = vec(-1560.82, 7.8, 58.86),       recipes = {}, blip = false, radius = 2.0 }, -- Gang G_85
        { coords = vec(-567.67, -2345.89, 13.84),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_86
        { coords = vec(-462.96, -2274.6, 7.72),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_87
        { coords = vec(777.27, -2802.55, 7.45),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_95
        { coords = vec(16.33, 700.79, 209.67),      recipes = {}, blip = false, radius = 2.0 }, -- Gang G_100
        { coords = vec(997.88, -2365.26, 30.65),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_102
        { coords = vec(1223.08, -402.46, 68.86),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_103
        { coords = vec(-2217.22, -377.46, 13.32),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_104
        { coords = vec(1921.99, 3052.74, 49.31),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_105
        { coords = vec(-1595.57, -856.46, 10.1),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_109
        { coords = vec(-1679.35, -788.8, 10.37),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_110
        { coords = vec(-1738.28, -723.65, 10.49),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_111
        { coords = vec(-1480.13, -203.53, 54.59),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_112
        { coords = vec(-446.55, 267.99, 83.01),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_113
        { coords = vec(1342.06, -2617.81, 49.23),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_114
        { coords = vec(-315.22, -2688.72, 7.57),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_115
        { coords = vec(-1455.39, -161.06, 48.84),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_116
        { coords = vec(660.51, -2908.74, 6.3),      recipes = {}, blip = false, radius = 2.0 }, -- Gang G_117
        { coords = vec(-942.3, -2036.83, -0.51),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_118
        { coords = vec(-898.48, -2037.75, 9.33),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_119
        { coords = vec(892.06, -2499.33, 29.58),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_120
        { coords = vec(320.75, -2734.67, 5.99),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_121
        { coords = vec(1630.87, -2615.36, 53.29),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_122
        { coords = vec(-1139.15, -2096.57, 9.52),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_123
        { coords = vec(-1157.75, -2127.32, 13.42),  recipes = {}, blip = false, radius = 2.0 }, -- Gang G_124
        { coords = vec(-1025.17, -2159.3, 5.29),    recipes = {}, blip = false, radius = 2.0 }, -- Gang G_125
        { coords = vec(-863.67, -2760.46, 13.95),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_126
        { coords = vec(-1027.71, -1999.16, 5.35),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_127
        { coords = vec(-1194.28, -1161.78, 5.57),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_128
        { coords = vec(-814.47, -2648.98, 14.85),   recipes = {}, blip = false, radius = 2.0 }, -- Gang G_129
        { coords = vec(-235.83, -2657.01, 6.0),     recipes = {}, blip = false, radius = 2.0 }, -- Gang G_130

        { coords = vec(-1613.92, -2731.89, 13.94),  recipes = {}, blip = false, radius = 2.0 }, -- Gang G_200

        {    -- caffe 1
            coords = vec(-330.48, -241.53, 34.45),    recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe1] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 2
            coords = vec(-231.66, -787.72, 34.09),    recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe2] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 3
            coords = vec(-1383.8, -633.37, 30.82),    recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe3] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 4
            coords = vec(345.46, -897.93, 29.34),     recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe4] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 5
            coords = vec(-135.05, 6184.73, 32.38),    recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe5] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 6
            coords = vec(748.67, -715.88, 28.07),     recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe6] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- caffe 7
            coords = vec(71.32, -1583.37, 29.6),      recipes = {}, blip = false, radius = 2.0, access = { [caffeName.caffe7] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 10.0, drawTextRadius = 0.5, hideLabel = true
        },
        -- ahangari
        { -- ahangari 1
            coords = vec(-1155.17, -2022.79, 13.17),  recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah1] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- ahangari 2
            coords = vec(733.66, -1066.7, 22.17),     recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah2] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- ahangari 3
            coords = vec(-227.88, -1327.13, 30.89),   recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah3] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- ahangari 4
            coords = vec(1127.09, -784.18, 57.6),     recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah4] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- ahangari 5
            coords = vec(141.6, -1106.06, 29.19),     recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah5] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, {    -- ahangari 6
            coords = vec(-323.54, -129.76, 39.0),     recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah6] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        }, { -- ahangari 7
            coords = vec(485.38, -1323.26, 29.21),    recipes = {}, blip = false, radius = 2.0, access = { [ahangariName.ah7] = true },
            radius2 = 0.6, color = { R = 224, G = 50, B = 50, A = 255 }, type = 12, range = 1.0, drawDistance = 2.0, drawTextRadius = 0.5, hideLabel = true
        },
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

--#region --------------- temp

    -- { coords = vec(0.27, 0.55, 700.45),     recipes = {}, blip = false,
    --     radius = 2.0,
    --     color = { R = 12, G = 123, B = 86, A = 255 }, -- a = opasity
    --     type = 13,            -- model
    --     range = 1.0,          -- range E
    --     drawDistance = 2.0,   -- az chand metri bebine
    --     drawTextRadius = 0.5, -- range neveshtan text
    --     hideLabel = false     -- true label hide mishe
    -- },

    -- local gunshopDaroo = { -- gunshop 1 - 2 - 3
    --     GroveStreet = true,
    --     Alghaede = true,
    --     Crows = true,
    -- }
    -- ['adrenaline'] = {
    --     Category = 'items3', Level = 10, Time = 10,
    --     limit = 10,
    --     Amount = 5,
    --     Money = 0, blackmoney = 0,
    --     Ingredients = {
    --         ['ephedrine'] = 6,
    --         ['opium'] = 6,
    --         ['crack'] = 5,
    --     },
    --     access = gunshopDaroo
    -- },
    -- ['erythropoietin'] = {
    --     Category = 'items3', Level = 10, Time = 10,
    --     limit = 20,
    --     Amount = 5,
    --     Money = 0, blackmoney = 0,
    --     Ingredients = {
    --         ['coca'] = 6,
    --         ['heroine'] = 2,
    --         ['cannabis'] = 3,
    --         ['ephedra'] = 5,
    --     },
    --     access = gunshopDaroo
    -- },
    -- ['gelofen'] = {
    --     Category = 'items3', Level = 10, Time = 10,
    --     limit = 20,
    --     Amount = 5,
    --     Money = 0, blackmoney = 0,
    --     Ingredients = {
    --         ['cocaine'] = 2,
    --         ['heroine'] = 1,
    --         ['coca'] = 4,
    --     },
    --     access = gunshopDaroo
    -- },
    -- ['estaminofon'] = {
    --     Category = 'items3', Level = 10, Time = 10,
    --     limit = 5,
    --     Amount = 5,
    --     Money = 0, blackmoney = 0,
    --     Ingredients = {
    --         ['marijuana'] = 3,
    --         ['poppy'] = 3,
    --         ['ephedra'] = 3,
    --     },
    --     access = gunshopDaroo
    -- },
--#endregion
