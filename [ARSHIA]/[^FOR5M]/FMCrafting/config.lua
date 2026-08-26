CraftData = {}

CraftData.HideMinimap = true -- If true it'll hide the minimap when the Crafting menu is opened

CraftData.Crafting = {

		tableName = 'Gang', -- Title
		tableID = 'general1', -- make a different one for every table with NO spaces
		crafts = { -- What items are available for crafting and the recipe
			{
				item = 'WEAPON_ASSAULTRIFLE', -- Item id and name of the image
				amount = 1,
				Level = 0,
				successCraftPercentage = 100, -- Percentage of successful craft 0 = 0% | 50 = 50% | 100 = 100%
				isItem = false, -- if true = is item | if false = is weapon
				time = 5, -- Time to craft (in seconds)
				recipe = { -- Recipe to craft it
					{'iron', 20, true}, -- item/amount/if the item should be removed when crafting
					{'wood', 20, true},
				},
			},
			{
				item = 'jewels', -- Item id and name of the image
				amount = 3,
				Level = 0,
				successCraftPercentage = 100, -- Percentage of successful craft 0 = 0% | 50 = 50% | 100 = 100%
				isItem = true, -- if true = is item | if false = is weapon
				time = 5, -- Time to craft (in seconds)
				recipe = { -- Recipe to craft it
					{'gold', 12, true}, -- item/amount/if the item should be removed when crafting
					{'diamond', 6, true},
				},
			},
		},
	
}
