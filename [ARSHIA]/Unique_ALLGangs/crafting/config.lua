CraftConfig = {

	BlipSprite = 556,
	BlipColor = 47,
	BlipText = 'Crafting Table',

	UseLimitSystem = false, -- Enable if your esx uses limit system
	
	CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
	
	ExperiancePerCraft = 0, -- The amount of experiance added per craft (100 Experiance is 1 level)
	
	HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job
	
	Categories = {

	['ammo'] = {
		Label = 'Items',
		Image = 'clip',
		Jobs = {},
		Gang = {},
	},

	['knife'] = {
		Label = 'Melees',
		Image = 'WEAPON_KNIFE',
		Jobs = {},
		Gang = {},
	},

	['pistol'] = {
		Label = 'Pistols',
		Image = 'WEAPON_PISTOL',
		Jobs = {},
		Gang = {},
	},

	['smg'] = {
		Label = 'SMGs',
		Image = 'WEAPON_SMG',
		Jobs = {},
		Gang = {},
	},

	['rifle'] = {
		Label = 'Rifles',
		Image = 'WEAPON_BULLPUPRIFLE',
		Jobs = {},
		Gang = {},
	},
	
	},
	
	PermanentItems = { -- Items that dont get removed when crafting
		['wrench'] = true
	},
	
	Recipes = { -- Enter Item name and then the speed value! The higher the value the more torque

	-- OWNER-ONLY (holding businesses): see Business. Only the gang that owns the holding
	-- of that business can craft these.
	['cyanide'] = {
		Level = 0, Category = 'Business', isGun = false, Jobs = {}, JobGrades = {},
		Amount = 1, SuccessRate = 90, requireBlueprint = false, Time = 20,
		Business = 'UwU', -- Cafe 1 (Gang 1)
		Ingredients = { ['essence'] = 2, ['mushroom'] = 1 },
	},
	['reviveX'] = {
		Level = 0, Category = 'Business', isGun = false, Jobs = {}, JobGrades = {},
		Amount = 1, SuccessRate = 90, requireBlueprint = false, Time = 20,
		Business = 'Obsidian', -- Cafe 2 (Gang 1)
		Ingredients = { ['gold_piece'] = 2, ['marijuana'] = 1 },
	},

	-- Items

	['clip'] = {
		Level = 5, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 5, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 10, 
		Ingredients = { 
		   ["iron_piece"] = 10,
		}
	},
	['silencer'] = {
		Level = 5, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["petrol"] = 2,
		   ["iron_piece"] = 5,
		   ["gold_piece"] = 1,
		}
	},
	['grip'] = {
		Level = 5, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["petrol"] = 1,
		   ["gold_piece"] = 1,
		   ["iron_piece"] = 5,
		}
	},
	['eclip'] = {
		Level = 6, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   ["iron_piece"] = 20,
		   ["gold_piece"] = 3,
		}
	},
	['blowtorch'] = {
		Level = 6, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["iron_piece"] = 4,
		   ["gold_piece"] = 6,
		   ["essence"] = 5, 
		}
	},
	['scope'] = {
		Level = 7, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["blackmoney"] = 10000,
		   ["iron_piece"] = 20,
		   ["essence"] = 10,
		}
	},
	['laptophack'] = {
		Level = 7, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   ["diamond"] = 1,
		   ["petrol"] = 3,
		   ["petrol_raffin"] = 3,
		   ["gold_piece"] = 10,
		   ["iron_piece"] = 20,
		}
	},
	['lsd'] = {
		Level = 5, 
	   	Category = 'ammo', 
	   	isGun = false, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   ["blackmoney"] = 20000,
		   ["mushroom"] = 75,
		   ["marijuana"] = 50,
		   ["essence"] = 30,
		   
		}
	},

	-- Weapons

	-- Knife
	['WEAPON_KNIFE'] = {
		Level = 1, 
	   	Category = 'knife', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["diamond"] = 1,
		   ["gold_piece"] = 1,
		   ["iron_piece"] = 5,
		   ["essence"] = 5,
		   ["petrol_raffin"] = 10,
		   ["fabric"] = 4,
		}
	},
	['WEAPON_DAGGER'] = {
		Level = 1, 
	   	Category = 'knife', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["fabric"] = 4,
		   ["diamond"] = 1,
		   ["cutted_wood"] = 5,
		   ["gold_piece"] = 1,
		   ["petrol_raffin"] = 5,
		   ["petrol"] = 5,   
		}
	},
	['WEAPON_MACHETE'] = {
		Level = 1, 
	   	Category = 'knife', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["essence"] = 5,
		   ["diamond"] = 2,
		   ["cutted_wood"] = 5,
		   ["gold_piece"] = 5,
		   ["iron_piece"] = 5,
		   ["petrol_raffin"] = 5,
		   ["petrol"] = 5,
		}
	},
	['WEAPON_KNUCKLE'] = {
		Level = 8, 
	   	Category = 'knife', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   ["iron"] = 1,
		   ["fabric"] = 10,
		   ["diamond"] = 2,
		   ["essence"] = 5,
		   ["iron_piece"] = 10,
		   ["gold_piece"] = 10,
		   ["petrol_raffin"] = 10,
		   ["petrol"] = 10,
		}
	},

	-- Pistols

	['WEAPON_PISTOL'] = {
		Level = 1, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
			["petrol"] = 10,
			["iron_piece"] = 5,
			["essence"] = 10,
			["petrol_raffin"] = 10,
		}
	},
	['WEAPON_SNSPISTOL'] = {
		Level = 1, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   	["essence"] = 15,
			["cutted_wood"] = 10,
			["gold_piece"] = 5,
			["iron_piece"] = 5,
			["petrol_raffin"] = 15,
		}
	},
	['WEAPON_VINTAGEPISTOL'] = {
		Level = 1, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
			["fabric"] = 5,
			["essence"] = 30,
			["cutted_wood"] = 20,
			["gold_piece"] = 5,
			["iron_piece"] = 10,
			["petrol"] = 10,
		}
	},
	['WEAPON_COMBATPISTOL'] = {
		Level = 2, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
			["fabric"] = 5,
			["essence"] = 15,
			["cutted_wood"] = 10,
			["gold_piece"] = 5,
			["iron_piece"] = 10,
			["petrol_raffin"] = 15,
			["petrol"] = 10,
		}
	},
	['WEAPON_HEAVYPISTOL'] = {
		Level = 2, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   	["fabric"] = 5,
			["essence"] = 10,
			["gold_piece"] = 5,
			["iron_piece"] = 10,
			["petrol_raffin"] = 15,
			["petrol"] = 10,
		}
	},
	['WEAPON_PISTOL50'] = {
		Level = 3, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 15, 
		Ingredients = { 
		   	["iron"] = 1,
			["essence"] = 30,
			["cutted_wood"] = 20,
			["gold_piece"] = 5,
			["petrol_raffin"] = 25,
			["petrol"] = 10,
		}
	},
	-- ['WEAPON_SNSPISTOL_MK2'] = {
	-- 	Level = 3, 
	--    	Category = 'pistol', 
	--    	isGun = true, 
	--    	Jobs = {}, 
	--    	JobGrades = {}, 
	--    	Amount = 1, 
	--    	SuccessRate = 100,
	--    	requireBlueprint = false, 
	--    	Time = 20, 
	-- 	Ingredients = { 
	-- 	   	["iron"] = 1,
	-- 		["fabric"] = 10,
	-- 		["diamond"] = 5,
	-- 		["essence"] = 20,
	-- 		["gold_piece"] = 5,
	-- 		["iron_piece"] = 5,
	-- 		["petrol_raffin"] = 20,
	-- 		["petrol"] = 15,
	-- 	}
	-- },
	-- ['WEAPON_PISTOL_MK2'] = {
	-- 	Level = 8, 
	--    	Category = 'pistol', 
	--    	isGun = true, 
	--    	Jobs = {}, 
	--    	JobGrades = {}, 
	--    	Amount = 1, 
	--    	SuccessRate = 100,
	--    	requireBlueprint = false, 
	--    	Time = 20, 
	-- 	Ingredients = { 
	-- 	   	["iron"] = 1,
	-- 		["fabric"] = 10,
	-- 		["diamond"] = 5,
	-- 		["essence"] = 30,
	-- 		["gold_piece"] = 10,
	-- 		["iron_piece"] = 10,
	-- 		["petrol_raffin"] = 20,
	-- 		["petrol"] = 15,
	-- 	}
	-- },
	['WEAPON_CERAMICPISTOL'] = {
		Level = 9, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   	["iron"] = 2,
			["fabric"] = 10,
			["diamond"] = 3,
			["cutted_wood"] = 15,
			["gold_piece"] = 5,
			["iron_piece"] = 5,
			["essence"] = 30,
			["petrol_raffin"] = 20,
		}
	},
	['WEAPON_DOUBLEACTION'] = {
		Level = 11, 
	   	Category = 'pistol', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 20, 
		Ingredients = { 
		   	["iron"] = 15,
			["fabric"] = 20,
			["diamond"] = 20,
			["gold"] = 2,
			["essence"] = 50,
			["cutted_wood"] = 50,
			["petrol"] = 25,
			["iron_piece"] = 40,
			["petrol_raffin"] = 25,
		}
	},

	-- SMGs
	['WEAPON_SMG'] = {
		Level = 3, 
	   	Category = 'smg', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 25, 
		Ingredients = { 
			["iron"] = 1,
			["fabric"] = 5,
			["essence"] = 30,
			["cutted_wood"] = 20,
			["petrol"] = 10,
		}
	},
	['WEAPON_ASSAULTSMG'] = {
		Level = 4, 
	   	Category = 'smg', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 25, 
		Ingredients = { 
			["iron"] = 2,
			["essence"] = 30,
			["cutted_wood"] = 20,
			["gold_piece"] = 5,
			["petrol_raffin"] = 25,
			["petrol"] = 15,
		}
	},
	['WEAPON_GUSENBERG'] = {
		Level = 8, 
	   	Category = 'smg', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 25, 
		Ingredients = { 
			["iron"] = 4,
			["fabric"] = 10,
			["essence"] = 50,
			["gold_piece"] = 10,
			["petrol_raffin"] = 25,
			["petrol"] = 15,
		}
	},
	-- ['WEAPON_SMG_MK2'] = {
	-- 	Level = 11, 
	--    	Category = 'smg', 
	--    	isGun = true, 
	--    	Jobs = {}, 
	--    	JobGrades = {}, 
	--    	Amount = 1, 
	--    	SuccessRate = 100,
	--    	requireBlueprint = false, 
	--    	Time = 25, 
	-- 	Ingredients = { 
	-- 		["iron"] = 7,
	-- 		["fabric"] = 20,
	-- 		["essence"] = 50,
	-- 		["cutted_wood"] = 50,
	-- 		["petrol"] = 25,
	-- 		["petrol_raffin"] = 25,
	-- 		["gold"] = 2,
	-- 	}
	-- },

	-- Rifles
	['WEAPON_CARBINERIFLE'] = {
		Level = 4, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 3,
			["fabric"] = 10,
			["essence"] = 40,
			["gold_piece"] = 10,
			["petrol_raffin"] = 25,
			["petrol"] = 15,
		}
	},
	['WEAPON_ASSAULTRIFLE'] = {
		Level = 5, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 3,
			["fabric"] = 10,
			["cutted_wood"] = 30,
			["gold_piece"] = 10,
			["petrol_raffin"] = 25,
			["petrol"] = 20,
		}
	},
	['WEAPON_ADVANCEDRIFLE'] = {
		Level = 5, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 3,
			["fabric"] = 10,
			["essence"] = 40,
			["cutted_wood"] = 30,
			["gold_piece"] = 10,
			["petrol_raffin"] = 25,
		}
	},
	['WEAPON_COMBATPDW'] = {
		Level = 6, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 3,
			["fabric"] = 10,
			["essence"] = 30,
			["cutted_wood"] = 30,
			["gold_piece"] = 10,
			["petrol"] = 15,
		}
	},
	['WEAPON_BULLPUPRIFLE'] = {
		Level = 6, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 4,
			["essence"] = 50,
			["cutted_wood"] = 30,
			["petrol"] = 20,
			["petrol_raffin"] = 25,
			["gold"] = 1,
		}
	},
	['WEAPON_SPECIALCARBINE'] = {
		Level = 9, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 4,
			["fabric"] = 10,
			["essence"] = 50,
			["petrol"] = 25,
			["petrol_raffin"] = 25,
			["gold"] = 1,
		}
	},
	-- ['WEAPON_BULLPUPRIFLE_MK2'] = {
	-- 	Level = 10, 
	--    	Category = 'rifle', 
	--    	isGun = true, 
	--    	Jobs = {}, 
	--    	JobGrades = {}, 
	--    	Amount = 1, 
	--    	SuccessRate = 100,
	--    	requireBlueprint = false, 
	--    	Time = 30, 
	-- 	Ingredients = { 
	-- 		["iron"] = 7,
	-- 		["fabric"] = 15,
	-- 		["essence"] = 50,
	-- 		["petrol"] = 25,
	-- 		["petrol_raffin"] = 25,
	-- 		["gold"] = 2,
	-- 	}
	-- },
	['WEAPON_COMPACTRIFLE'] = {
		Level = 11, 
	   	Category = 'rifle', 
	   	isGun = true, 
	   	Jobs = {}, 
	   	JobGrades = {}, 
	   	Amount = 1, 
	   	SuccessRate = 100,
	   	requireBlueprint = false, 
	   	Time = 30, 
		Ingredients = { 
			["iron"] = 7,
			["fabric"] = 20,
			["essence"] = 50,
			["cutted_wood"] = 50,
			["petrol"] = 25,
			["petrol_raffin"] = 25,
			["gold"] = 1,
		}
	},
	-- ['WEAPON_SPECIALCARBINE_MK2'] = {
	-- 	Level = 12, 
	--    	Category = 'rifle', 
	--    	isGun = true, 
	--    	Jobs = {}, 
	--    	JobGrades = {}, 
	--    	Amount = 1, 
	--    	SuccessRate = 100,
	--    	requireBlueprint = false, 
	--    	Time = 30, 
	-- 	Ingredients = { 
	-- 		["iron"] = 8,
	-- 		["fabric"] = 20,
	-- 		["diamond"] = 10,
	-- 		["gold"] = 2,
	-- 		["essence"] = 50,
	-- 		["cutted_wood"] = 50,
	-- 		["petrol"] = 25,
	-- 		["iron_piece"] = 10,
	-- 		["petrol_raffin"] = 25,
	-- 	}
	-- },
},
	
	Workbenches = {
        -- PUBLIC: anyone may craft here, but only the recipes listed.
        {
            name    = 'Public Workbench',
            coords  = vec3(2942.174072, 4626.169922, 48.720612),
            blip    = true,
            radius  = 4.0,
            public  = true,
            recipes = { 'WEAPON_PISTOL', 'silencer', 'clip' },
        },
    },
}
