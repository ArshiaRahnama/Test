


-- NOTE: the `Jobs` field on each category below is not currently read anywhere
-- in crafting_cl.lua / crafting_sv.lua (it was dead in the original file too).
-- Real access control comes from which cafe's crafting-station zone the player
-- can even walk up to (see shared/cafes.lua + client/main.lua). Left populated
-- here in case you want to wire it into a menu filter later.
local ANY_CAFE_JOB = {'uwucafe', 'obsidian', 'voltage'}

ConfigCrafting = {
	Locale = 'en',
	BlipSprite = 556,
	BlipColor = 47,
	BlipText = 'Crafting Table',

	UseLimitSystem = true, -- Enable if your esx uses limit system
	
	CraftingStopWithDistance = true, -- Crafting will stop when not near workbench
	
	ExperiancePerCraft = 0, -- The amount of experiance added per craft (100 Experiance is 1 level)
	
	HideWhenCantCraft = false, -- Instead of lowering the opacity it hides the item that is not craftable due to low level or wrong job

	OpenCategoryHamzan = 'UwUHamzan',
	OpenCategoryGhahvesaz = 'UwUGhahve',
	OpenCategoryZarfShoe = 'UwUZarfShoe',
	OpenCategoryGaz = 'UwU',

	
	
	Categories = {
	
	['cafeHamzan'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['cafeGhahvesaz'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['cafeZarfShoe'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	
	['cafeGaz'] = {
		Label = 'Item UwU',
		Image = 'cupcake',
		Jobs = ANY_CAFE_JOB,
	
	},
	['bakeryHamzan'] = {
		Label = 'Bakery',
		Image = 'cupcake',
		Jobs = {'bakery1', 'bakery2'}, -- placeholder, unused (see note above)
	},
	['bakeryGhahvesaz'] = {
		Label = 'Bakery',
		Image = 'cupcake',
		Jobs = {'bakery1', 'bakery2'}, -- placeholder, unused (see note above)
	},
	['bakeryZarfShoe'] = {
		Label = 'Bakery',
		Image = 'cupcake',
		Jobs = {'bakery1', 'bakery2'}, -- placeholder, unused (see note above)
	},
	['bakeryGaz'] = {
		Label = 'Bakery',
		Image = 'cupcake',
		Jobs = {'bakery1', 'bakery2'}, -- placeholder, unused (see note above)
	},
	['barHamzan'] = {
		Label = 'Bar',
		Image = 'cupcake',
		Jobs = {'bar1', 'bar2'}, -- placeholder, unused (see note above)
	},
	['barGhahvesaz'] = {
		Label = 'Bar',
		Image = 'cupcake',
		Jobs = {'bar1', 'bar2'}, -- placeholder, unused (see note above)
	},
	['barZarfShoe'] = {
		Label = 'Bar',
		Image = 'cupcake',
		Jobs = {'bar1', 'bar2'}, -- placeholder, unused (see note above)
	},
	['barGaz'] = {
		Label = 'Bar',
		Image = 'cupcake',
		Jobs = {'bar1', 'bar2'}, -- placeholder, unused (see note above)
	},
	['pizzaHamzan'] = {
		Label = 'Pizza',
		Image = 'cupcake',
		Jobs = {'pizza1', 'pizza2'}, -- placeholder, unused (see note above)
	},
	['pizzaGhahvesaz'] = {
		Label = 'Pizza',
		Image = 'cupcake',
		Jobs = {'pizza1', 'pizza2'}, -- placeholder, unused (see note above)
	},
	['pizzaZarfShoe'] = {
		Label = 'Pizza',
		Image = 'cupcake',
		Jobs = {'pizza1', 'pizza2'}, -- placeholder, unused (see note above)
	},
	['pizzaGaz'] = {
		Label = 'Pizza',
		Image = 'cupcake',
		Jobs = {'pizza1', 'pizza2'}, -- placeholder, unused (see note above)
	},
	['icecreamHamzan'] = {
		Label = 'Ice Cream',
		Image = 'cupcake',
		Jobs = {'icecream1', 'icecream2'}, -- placeholder, unused (see note above)
	},
	['icecreamGhahvesaz'] = {
		Label = 'Ice Cream',
		Image = 'cupcake',
		Jobs = {'icecream1', 'icecream2'}, -- placeholder, unused (see note above)
	},
	['icecreamZarfShoe'] = {
		Label = 'Ice Cream',
		Image = 'cupcake',
		Jobs = {'icecream1', 'icecream2'}, -- placeholder, unused (see note above)
	},
	['icecreamGaz'] = {
		Label = 'Ice Cream',
		Image = 'cupcake',
		Jobs = {'icecream1', 'icecream2'}, -- placeholder, unused (see note above)
	},
	['sushiHamzan'] = {
		Label = 'Sushi',
		Image = 'cupcake',
		Jobs = {'sushi1', 'sushi2'}, -- placeholder, unused (see note above)
	},
	['sushiGhahvesaz'] = {
		Label = 'Sushi',
		Image = 'cupcake',
		Jobs = {'sushi1', 'sushi2'}, -- placeholder, unused (see note above)
	},
	['sushiZarfShoe'] = {
		Label = 'Sushi',
		Image = 'cupcake',
		Jobs = {'sushi1', 'sushi2'}, -- placeholder, unused (see note above)
	},
	['sushiGaz'] = {
		Label = 'Sushi',
		Image = 'cupcake',
		Jobs = {'sushi1', 'sushi2'}, -- placeholder, unused (see note above)
	},

	['carwashHamzan'] = { Label = 'Car Wash', Image = 'cupcake', Jobs = {'carwash'} },
	['carwashGhahvesaz'] = { Label = 'Car Wash', Image = 'cupcake', Jobs = {'carwash'} },
	['carwashZarfShoe'] = { Label = 'Car Wash', Image = 'cupcake', Jobs = {'carwash'} },
	['carwashGaz'] = { Label = 'Car Wash', Image = 'cupcake', Jobs = {'carwash'} },




	
	},
	
	PermanentItems = { -- Items that dont get removed when crafting
		['wrench'] = true
	},
	
	Recipes = { 
		['premium_wax'] = {
			Category = 'carwashHamzan',
			Label = 'Premium Wax',
			Image = 'premium_wax',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soap_foam'] = 2,
			},
		},
		['interior_cleaner'] = {
			Category = 'carwashHamzan',
			Label = 'Interior Cleaner Kit',
			Image = 'interior_cleaner',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['microfiber_cloth'] = 2,
			},
		},
		['rim_polish'] = {
			Category = 'carwashGhahvesaz',
			Label = 'Rim Polish',
			Image = 'rim_polish',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soap_foam'] = 2,
			},
		},
		['air_freshener_pine'] = {
			Category = 'carwashGhahvesaz',
			Label = 'Air Freshener Pine',
			Image = 'air_freshener_pine',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['microfiber_cloth'] = 2,
			},
		},
		['ceramic_coat'] = {
			Category = 'carwashZarfShoe',
			Label = 'Ceramic Coat',
			Image = 'ceramic_coat',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soap_foam'] = 2,
			},
		},
		['tire_shine'] = {
			Category = 'carwashGaz',
			Label = 'Tire Shine',
			Image = 'tire_shine',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['microfiber_cloth'] = 2,
			},
		},

		['croissant_kareii'] = {
			Category = 'bakeryHamzan',
			Label = 'Croissant Kareii',
			Image = 'croissant_kareii',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['non_baget'] = {
			Category = 'bakeryHamzan',
			Label = 'Non Baget',
			Image = 'non_baget',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['keik_shokolat'] = {
			Category = 'bakeryGhahvesaz',
			Label = 'Keik Shokolat',
			Image = 'keik_shokolat',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['shirini_khamei'] = {
			Category = 'bakeryGhahvesaz',
			Label = 'Shirini Khamei',
			Image = 'shirini_khamei',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['cookie_shekari'] = {
			Category = 'bakeryZarfShoe',
			Label = 'Cookie Shekari',
			Image = 'cookie_shekari',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['roll_darchin'] = {
			Category = 'bakeryGaz',
			Label = 'Roll Darchin',
			Image = 'roll_darchin',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_shirini'] = 2,
			},
		},
		['mocktail_mojito'] = {
			Category = 'barHamzan',
			Label = 'Virgin Mojito',
			Image = 'mocktail_mojito',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soda_water'] = 2,
			},
		},
		['mocktail_pinacolada'] = {
			Category = 'barHamzan',
			Label = 'Virgin Pina Colada',
			Image = 'mocktail_pinacolada',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['mive_mix'] = 2,
			},
		},
		['soda_lime'] = {
			Category = 'barGhahvesaz',
			Label = 'Soda Lime',
			Image = 'soda_lime',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soda_water'] = 2,
			},
		},
		['energy_mix'] = {
			Category = 'barGhahvesaz',
			Label = 'Energy Mix',
			Image = 'energy_mix',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['mive_mix'] = 2,
			},
		},
		['fruit_punch'] = {
			Category = 'barZarfShoe',
			Label = 'Fruit Punch',
			Image = 'fruit_punch',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['soda_water'] = 2,
			},
		},
		['ice_tea_special'] = {
			Category = 'barGaz',
			Label = 'Ice Tea Special',
			Image = 'ice_tea_special',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['mive_mix'] = 2,
			},
		},
		['pizza_margherita'] = {
			Category = 'pizzaHamzan',
			Label = 'Pizza Margherita',
			Image = 'pizza_margherita',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_pizza'] = 2,
			},
		},
		['pizza_pepperoni'] = {
			Category = 'pizzaHamzan',
			Label = 'Pizza Pepperoni',
			Image = 'pizza_pepperoni',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['sos_gojeh'] = 2,
			},
		},
		['pizza_mushroom'] = {
			Category = 'pizzaGhahvesaz',
			Label = 'Pizza Mushroom',
			Image = 'pizza_mushroom',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['panir_pizza'] = 2,
			},
		},
		['calzone'] = {
			Category = 'pizzaGhahvesaz',
			Label = 'Calzone',
			Image = 'calzone',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khamir_pizza'] = 2,
			},
		},
		['garlic_bread'] = {
			Category = 'pizzaZarfShoe',
			Label = 'Garlic Bread',
			Image = 'garlic_bread',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['sos_gojeh'] = 2,
			},
		},
		['pizza_bbq_chicken'] = {
			Category = 'pizzaGaz',
			Label = 'Pizza BBQ Chicken',
			Image = 'pizza_bbq_chicken',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['panir_pizza'] = 2,
			},
		},
		['icecream_vanilla_cone'] = {
			Category = 'icecreamHamzan',
			Label = 'Icecream Vanilla Cone',
			Image = 'icecream_vanilla_cone',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['icecream_chocolate_cone'] = {
			Category = 'icecreamHamzan',
			Label = 'Icecream Chocolate Cone',
			Image = 'icecream_chocolate_cone',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['milkshake_strawberry'] = {
			Category = 'icecreamGhahvesaz',
			Label = 'Milkshake Strawberry',
			Image = 'milkshake_strawberry',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['sundae_caramel'] = {
			Category = 'icecreamGhahvesaz',
			Label = 'Sundae Caramel',
			Image = 'sundae_caramel',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['icecream_sandwich'] = {
			Category = 'icecreamZarfShoe',
			Label = 'Icecream Sandwich',
			Image = 'icecream_sandwich',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['froyo_mango'] = {
			Category = 'icecreamGaz',
			Label = 'Froyo Mango',
			Image = 'froyo_mango',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['khame_yakhi'] = 2,
			},
		},
		['sushi_california'] = {
			Category = 'sushiHamzan',
			Label = 'Sushi California',
			Image = 'sushi_california',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['berenj_sushi'] = 2,
			},
		},
		['sushi_salmon_nigiri'] = {
			Category = 'sushiHamzan',
			Label = 'Sushi Salmon Nigiri',
			Image = 'sushi_salmon_nigiri',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['maahi_khaam'] = 2,
			},
		},
		['sushi_dragon_roll'] = {
			Category = 'sushiGhahvesaz',
			Label = 'Sushi Dragon Roll',
			Image = 'sushi_dragon_roll',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['nori'] = 2,
			},
		},
		['sushi_spicy_tuna'] = {
			Category = 'sushiGhahvesaz',
			Label = 'Sushi Spicy Tuna',
			Image = 'sushi_spicy_tuna',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['berenj_sushi'] = 2,
			},
		},
		['miso_soup'] = {
			Category = 'sushiZarfShoe',
			Label = 'Miso Soup',
			Image = 'miso_soup',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['maahi_khaam'] = 2,
			},
		},
		['sushi_veggie_roll'] = {
			Category = 'sushiGaz',
			Label = 'Sushi Veggie Roll',
			Image = 'sushi_veggie_roll',
			Level = 0,
			Time = 8,
			Amount = 1,
			Ingredients = {
				['nori'] = 2,
			},
		},
	 ['shokolat'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['nutela'] = 1, 
		 ['shir'] = 2, 
			
	 	}
	 },

	 ['cakebastani'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 2, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 2, 
		 ['shir'] = 2, 
		 ['egg'] = 1, 
			
	 	}
	 },

	 ['caketotfarangi'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 2, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 2, 
		 ['shir'] = 2, 
		 ['egg'] = 1, 
			
	 	}
	 },

	 ['milkshake'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 2, 
		 ['shir'] = 2, 
			
	 	}
	 },

	 ['latte'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['fenjon'] = 2, 
		 ['shir'] = 2, 
		 ['daneghahve'] = 1, 
			
	 	}
	 },

	 ['hot_chocolate'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 1, 
		 ['water'] = 2, 
	 	}
	 },

	 ['ghahve50'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['fenjon'] = 2, 
		 ['water'] = 1, 
		 ['daneghahve'] = 1, 
	 	}
	 },

	 ['ghahve80'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['shekar'] = 1, 
		 ['fenjon'] = 2, 
		 ['water'] = 1, 
		 ['daneghahve'] = 2, 
	 	}
	 },

	 ['ghahve100'] = {
	 	Level = 1, 
		Category = 'UwUGhahve', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['fenjon'] = 2, 
		 ['water'] = 2, 
		 ['daneghahve'] = 4, 
	 	}
	 },

	 ['fenjon'] = {
	 	Level = 1, 
		Category = 'UwUZarfShoe', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['fenjonkasif'] = 5, 
		 ['water'] = 1, 
	 	}
	 },

	 ['bubbletetotfarangi'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
		 ['totfarangi'] = 1, 
		 ['shir'] = 2, 
		 ['shekar'] = 1, 
		 
	 	}
	 },

	 ['cupcake'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['podrcacao'] = 1, 
		 ['shekar'] = 1, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['aard'] = 1, 
		 ['shir'] = 1, 
		 ['egg'] = 1, 
	 	}
	 },

	--  New Item

	--  ['bastani'] = {
	--  	Level = 1, 
	-- 	Category = 'UwU', 
	-- 	isGun = false, 
	-- 	Jobs = ANY_CAFE_JOB, 
	-- 	JobGrades = {}, 
	-- 	Amount = 3, 
	-- 	SuccessRate = 100, 
	-- 	requireBlueprint = false, 
	-- 	Time = 17, 
	--  	Ingredients = { 
	-- 	 ['podrcacao'] = 1, 
	-- 	 ['shekar'] = 1, 
	-- 	 ['kare'] = 1, 
	-- 	 ['bakingpowder'] = 1, 
	-- 	 ['aard'] = 1, 
	-- 	 ['shir'] = 1, 
	-- 	 ['egg'] = 1, 
	--  	}
	--  },

	 ['boba_milk_tea_caramel'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1,
		 ['daneghahve'] = 2,
	 	}
	 },

	 ['boba_milk_tea_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1,
		 ['powdr_matcha'] = 2,

	 	}
	 },

	 ['bobal_tea_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['powdr_matcha'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	 ['bobal_tea_tamshak'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['tamshak'] = 1, 
	 	}
	 },

	 ['cake_bastani_vanili'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['aard'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['egg'] = 1, 
		 ['vanil'] = 1, 
		 ['shir'] = 1, 
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	 ['cake_limoii'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['limo'] = 1, 
		 ['aard'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['shekar'] = 1, 
		 ['shir'] = 1, 
	 	}
	 },

	 ['cupcake_shokolati'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 11, 
	 	Ingredients = { 
		 ['shokolat'] = 1, 
		 ['aard'] = 1, 
		 ['shir'] = 1,
		 ['egg'] = 1,
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['ice_coffee_matcha'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 

		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['khame'] = 1, 
		 ['powdr_matcha'] = 1, 

		
	 	}
	 },

	 ['milk_shake_shokolati'] = {
	 	Level = 1, 
		Category = 'UwUHamzan', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
			['shir'] = 1, 
			['shekar'] = 2,
		 	['podrcacao'] = 1, 
	 	}
	 },

	 ['mufchocolate'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 10, 
	 	Ingredients = { 
		 ['shokolat'] = 1, 
		 ['podrcacao'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1,
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
		 ['shir'] = 1,
		 ['bakingpowder'] = 1,  
	 	}
	 },

	 ['muffin_tamshak'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
		 ['tamshak'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['nodel'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 1, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['water'] = 2, 
		 ['nodel_kham'] = 1, 
		 ['kase'] = 1, 

	 	}
	 },

	 ['kase'] = {
	 	Level = 1, 
		Category = 'UwUZarfShoe', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['water'] = 1, 
		 ['kasekasif'] = 5, 
	 	}
	 },

	 ['pankik'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 5, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['shir'] = 1, 
		 ['egg'] = 1, 
		 ['aard'] = 1, 
		 ['shekar'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },

	 ['pankik_nutella'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 12, 
	 	Ingredients = { 
			['aard'] = 1, 
			['shir'] = 1, 
			['egg'] = 1, 
			['kare'] = 1, 
			['bakingpowder'] = 1, 
		 	['nutela'] = 1, 
	 	}
	 },

	 ['pankik_oreo'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 8, 
	 	Ingredients = { 
		 ['oreo'] = 1, 
		 ['shir'] = 1, 
		 ['shekar'] = 1, 
		 ['egg'] = 1, 
		 ['bakingpowder'] = 1, 
		 ['kare'] = 1,
		 ['aard'] = 1, 
	 	}
	 },

	 ['tiramisuye_toot_farangi'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 2, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 17, 
	 	Ingredients = { 
		 ['aard'] = 2, 
		 ['totfarangi'] = 1, 
		 ['shekar'] = 1, 
		 ['egg'] = 1, 
		 ['khame'] = 1, 
		 ['shir'] = 1, 
		 ['kare'] = 1, 
		 ['bakingpowder'] = 1, 
	 	}
	 },


	 ['vafel_nutella'] = {
	 	Level = 1, 
		Category = 'UwU', 
		isGun = false, 
		Jobs = ANY_CAFE_JOB, 
		JobGrades = {}, 
		Amount = 3, 
		SuccessRate = 100, 
		requireBlueprint = false, 
		Time = 15, 
	 	Ingredients = { 
		 ['nutela'] = 1, 
		 ['aard'] = 1, 
		 ['egg'] = 1, 
		 ['shir'] = 1, 
		 ['aard'] = 1, 
		 ['kare'] = 1, 
		 ['shekar'] = 1, 
	 	}
	 },

	},

	
	Workbenches = { -- Every workbench location, leave {} for jobs if you want everybody to access
		{coords = vector3(-591.012, -1056.49, 22.2), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-587.6, -1062.60, 22.556), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-586.874, -1061.84, 22.344), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		{coords = vector3(-591.0, -1064.16, 22.544), jobs = {}, blip = false, recipes = {}, radius = 1.5 },
		

	},
	
}
	
	

function SendTextMessage(msg)

		-- SetNotificationTextEntry('STRING')
		-- AddTextComponentString(msg)
		-- DrawNotification(0,1)

		--EXAMPLE USED IN VIDEO
		--exports['mythic_notify']:SendAlert('inform', msg)
		
	ESX.ShowNotification(msg, "Craft Table", "info", 5000)

end
