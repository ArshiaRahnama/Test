--[[
	Multi-cafe registry. Add a new cafe by copying one of the blocks below and
	giving it a new `Job` (must also exist in the `jobs` / `job_grades` SQL
	tables), a new `Society` name, and its own set of station coordinates.

	Every cafe is a fully separate business: an employee of one cafe cannot
	use another cafe's freezer/crafting/boss menu/cloakroom - same rule as
	the rest of the server's job resources.

	Only "UwU Café" keeps its original coordinates (that's the one that
	already existed and works). The 2 new cafes use PLACEHOLDER coordinates -
	move them in-game to wherever you actually want them.
]]

Cafes = {

	-- ── Café #1: UwU Café (original, unchanged location) ──
	UwU = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'uwucafe',
		Society = 'uwucafe',
		Label   = 'Cafe UwU',

		Blip = {
			Pos     = { x = -581.831, y = -1064.56, z = 22.347 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 8, -- pink
		},

		Freezer            = { Pos = { x = -590.8,   y = -1058.64, z = 22.744 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -588.1, y = -1068.47, z = 22.344, h = 359.67 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -596.610, y = -1052.73, z = 22.245 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -586.200, y = -1050.61, z = 22.744 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -591.0,   y = -1064.16, z = 22.544 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -586.874, y = -1061.84, z = 22.344 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -587.6,   y = -1062.60, z = 22.556 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -591.012, y = -1056.49, z = 22.2 },   Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -583.987, y = -1061.46, z = 22.344 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -607.457, y = -1064.42, z = 22.788 },
		SpawnPoint   = { x = -621.072, y = -1058.83, z = 21.789, w = 268.28 },
		DeleteMarker = { x = -612.353, y = -1059.27, z = 22.788 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -582.082, y = -1055.85, z = 21.0 },
			{ x = -582.100, y = -1054.57, z = 21.0 },
			{ x = -576.409, y = -1056.27, z = 21.0 },
			{ x = -576.473, y = -1054.95, z = 21.0 },
			{ x = -574.052, y = -1054.91, z = 21.0 },
			{ x = -573.980, y = -1056.40, z = 21.0 },
			{ x = -577.532, y = -1063.56, z = 21.0 },
			{ x = -579.982, y = -1061.24, z = 21.0 },
			{ x = -581.632, y = -1064.19, z = 21.0 },
		},
	},

	-- ── Café #2: Obsidian Brew ──
	-- PLACEHOLDER location (Rockford Hills area) - move in-game.
	Obsidian = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'obsidian',
		Society = 'obsidian',
		Label   = 'Cafe Obsidian',

		Blip = {
			Pos     = { x = -1223.0, y = -906.0, z = 12.33 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27, -- dark purple / obsidian-ish
		},

		Freezer            = { Pos = { x = -1231.5, y = -900.4, z = 12.6 },  Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1229.0, y = -913.0, z = 12.2, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1238.0, y = -893.5, z = 12.7 },  Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1227.6, y = -891.8, z = 12.6 },  Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1232.3, y = -906.0, z = 12.35 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1227.7, y = -903.2, z = 12.15 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1228.4, y = -903.9, z = 12.35 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1232.4, y = -898.3, z = 12.05 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1225.2, y = -902.8, z = 12.15 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1248.0, y = -906.0, z = 12.63 },
		SpawnPoint   = { x = -1262.0, y = -900.0, z = 11.6,  w = 268.28 },
		DeleteMarker = { x = -1253.0, y = -900.9, z = 12.63 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1222.7, y = -897.5, z = 10.8 },
			{ x = -1222.7, y = -896.2, z = 10.8 },
			{ x = -1217.0, y = -897.9, z = 10.8 },
			{ x = -1217.1, y = -896.6, z = 10.8 },
			{ x = -1214.7, y = -896.5, z = 10.8 },
			{ x = -1214.6, y = -898.0, z = 10.8 },
			{ x = -1218.2, y = -905.2, z = 10.8 },
			{ x = -1220.6, y = -902.9, z = 10.8 },
			{ x = -1222.3, y = -905.8, z = 10.8 },
		},
	},

	-- ── Café #3: Voltage Coffee Co. ──
	-- PLACEHOLDER location (Textile City / industrial area) - move in-game.
	Voltage = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'voltage',
		Society = 'voltage',
		Label   = 'Cafe Voltage',

		Blip = {
			Pos     = { x = 442.9, y = -1750.0, z = 29.5 },
			Sprite  = 621,
			Display = 4,
			Scale   = 1.0,
			Colour  = 5, -- yellow / electric
		},

		Freezer            = { Pos = { x = 434.4, y = -1743.6, z = 29.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = 436.9, y = -1753.6, z = 29.4, h = 90.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = 428.3, y = -1738.1, z = 29.9 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = 438.7, y = -1736.0, z = 29.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = 434.0, y = -1749.7, z = 29.6 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = 438.2, y = -1747.2, z = 29.4 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = 437.4, y = -1747.9, z = 29.6 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = 434.0, y = -1742.1, z = 29.3 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = 441.4, y = -1746.8, z = 29.4 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = 418.0, y = -1750.0, z = 29.5 },
		SpawnPoint   = { x = 404.0, y = -1744.0, z = 28.6, w = 88.0 },
		DeleteMarker = { x = 413.0, y = -1744.9, z = 29.5 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = 443.2, y = -1740.9, z = 27.8 },
			{ x = 443.2, y = -1739.6, z = 27.8 },
			{ x = 448.9, y = -1741.3, z = 27.8 },
			{ x = 448.8, y = -1740.0, z = 27.8 },
			{ x = 451.2, y = -1739.9, z = 27.8 },
			{ x = 451.3, y = -1741.4, z = 27.8 },
			{ x = 447.7, y = -1748.6, z = 27.8 },
			{ x = 445.3, y = -1746.3, z = 27.8 },
			{ x = 443.6, y = -1749.2, z = 27.8 },
		},
	},

	-- ── Restaurant #1: Ember & Ash ──
	-- PLACEHOLDER location (Vinewood Hills grill spot) - move in-game.
	Ember = {
		Type    = 'restaurant',
		MenuGroup = 'cafe',
		Job     = 'ember',
		Society = 'ember',
		Label   = 'Restaurant Ember',

		Blip = {
			Pos     = { x = -1391.0, y = -583.0, z = 30.3 },
			Sprite  = 93,
			Display = 4,
			Scale   = 1.0,
			Colour  = 1, -- red, fire theme
		},

		Freezer            = { Pos = { x = -1398.5, y = -577.4, z = 30.6 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1396.0, y = -590.0, z = 30.2, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1405.0, y = -570.5, z = 30.7 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1394.6, y = -568.8, z = 30.6 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1399.3, y = -583.0, z = 30.35 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1394.7, y = -580.2, z = 30.15 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1395.4, y = -580.9, z = 30.35 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1399.4, y = -575.3, z = 30.05 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1392.2, y = -579.8, z = 30.15 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1415.0, y = -583.0, z = 30.63 },
		SpawnPoint   = { x = -1429.0, y = -577.0, z = 29.6,  w = 268.28 },
		DeleteMarker = { x = -1420.0, y = -577.9, z = 30.63 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1389.7, y = -574.5, z = 28.8 },
			{ x = -1389.7, y = -573.2, z = 28.8 },
			{ x = -1384.0, y = -574.9, z = 28.8 },
			{ x = -1384.1, y = -573.6, z = 28.8 },
			{ x = -1381.7, y = -573.5, z = 28.8 },
			{ x = -1381.6, y = -575.0, z = 28.8 },
			{ x = -1385.2, y = -582.2, z = 28.8 },
			{ x = -1387.6, y = -579.9, z = 28.8 },
			{ x = -1389.3, y = -582.8, z = 28.8 },
		},
	},

	-- ── Restaurant #2: The Rusty Anchor ──
	-- PLACEHOLDER location (Del Perro pier, seafood/dockside vibe) - move in-game.
	Anchor = {
		Type    = 'restaurant',
		MenuGroup = 'cafe',
		Job     = 'anchor',
		Society = 'anchor',
		Label   = 'Restaurant Anchor',

		Blip = {
			Pos     = { x = -1850.0, y = -1230.0, z = 13.0 },
			Sprite  = 356,
			Display = 4,
			Scale   = 1.0,
			Colour  = 3, -- blue, seaside theme
		},

		Freezer            = { Pos = { x = -1857.5, y = -1224.4, z = 13.3 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1855.0, y = -1237.0, z = 12.9, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1864.0, y = -1217.5, z = 13.4 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1853.6, y = -1215.8, z = 13.3 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1858.3, y = -1230.0, z = 13.05 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1853.7, y = -1227.2, z = 12.85 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1854.4, y = -1227.9, z = 13.05 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1858.4, y = -1222.3, z = 12.75 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1851.2, y = -1226.8, z = 12.85 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1874.0, y = -1230.0, z = 13.33 },
		SpawnPoint   = { x = -1888.0, y = -1224.0, z = 12.3,  w = 268.28 },
		DeleteMarker = { x = -1879.0, y = -1224.9, z = 13.33 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1848.7, y = -1221.5, z = 11.5 },
			{ x = -1848.7, y = -1220.2, z = 11.5 },
			{ x = -1843.0, y = -1221.9, z = 11.5 },
			{ x = -1843.1, y = -1220.6, z = 11.5 },
			{ x = -1840.7, y = -1220.5, z = 11.5 },
			{ x = -1840.6, y = -1222.0, z = 11.5 },
			{ x = -1844.2, y = -1229.2, z = 11.5 },
			{ x = -1846.6, y = -1226.9, z = 11.5 },
			{ x = -1848.3, y = -1229.8, z = 11.5 },
		},
	},

	-- ── Restaurant #3: Crimson Fork ──
	-- PLACEHOLDER location (Rodeo Drive, upscale fine-dining vibe) - move in-game.
	Crimson = {
		Type    = 'restaurant',
		MenuGroup = 'cafe',
		Job     = 'crimson',
		Society = 'crimson',
		Label   = 'Restaurant Crimson',

		Blip = {
			Pos     = { x = -278.0, y = -720.0, z = 33.0 },
			Sprite  = 93,
			Display = 4,
			Scale   = 1.0,
			Colour  = 18, -- dark purple / crimson-ish, upscale
		},

		Freezer            = { Pos = { x = -285.5, y = -714.4, z = 33.3 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -283.0, y = -727.0, z = 32.9, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -292.0, y = -707.5, z = 33.4 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -281.6, y = -705.8, z = 33.3 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -286.3, y = -720.0, z = 33.05 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -281.7, y = -717.2, z = 32.85 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -282.4, y = -717.9, z = 33.05 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -286.4, y = -712.3, z = 32.75 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -279.2, y = -716.8, z = 32.85 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -302.0, y = -720.0, z = 33.33 },
		SpawnPoint   = { x = -316.0, y = -714.0, z = 32.3,  w = 268.28 },
		DeleteMarker = { x = -307.0, y = -714.9, z = 33.33 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -276.7, y = -711.5, z = 31.5 },
			{ x = -276.7, y = -710.2, z = 31.5 },
			{ x = -271.0, y = -711.9, z = 31.5 },
			{ x = -271.1, y = -710.6, z = 31.5 },
			{ x = -268.7, y = -710.5, z = 31.5 },
			{ x = -268.6, y = -712.0, z = 31.5 },
			{ x = -272.2, y = -719.2, z = 31.5 },
			{ x = -274.6, y = -716.9, z = 31.5 },
			{ x = -276.3, y = -719.8, z = 31.5 },
		},
	},

	-- ── Bakery: Flourish Bakery ──
	-- PLACEHOLDER location - move in-game.
	Flourish = {
		Type    = 'bakery',
		MenuGroup = 'bakery',
		Job     = 'flourish',
		Society = 'flourish',
		Label   = 'Bakery Flourish',

		Blip = {
			Pos     = { x = -1100.0, y = 260.0, z = 69.0 },
			Sprite  = 432,
			Display = 4,
			Scale   = 1.0,
			Colour  = 46,
		},

		Freezer            = { Pos = { x = -1107.5, y = 265.6, z = 69.3 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1105.0, y = 253.0, z = 68.9, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1114.0, y = 272.5, z = 69.4 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1103.6, y = 274.2, z = 69.3 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1108.3, y = 260.0, z = 69.05 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1103.7, y = 262.8, z = 68.85 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1104.4, y = 262.1, z = 69.05 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1108.4, y = 267.7, z = 68.75 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1101.2, y = 263.2, z = 68.85 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1121.0, y = 260.0, z = 69.33 },
		SpawnPoint   = { x = -1135.0, y = 266.0, z = 68.3, w = 268.28 },
		DeleteMarker = { x = -1126.0, y = 265.1, z = 69.33 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1098.7, y = 268.5, z = 67.5 },
			{ x = -1098.7, y = 269.8, z = 67.5 },
			{ x = -1093.0, y = 268.1, z = 67.5 },
			{ x = -1093.1, y = 269.4, z = 67.5 },
			{ x = -1090.7, y = 269.5, z = 67.5 },
			{ x = -1090.8, y = 268.0, z = 67.5 },
			{ x = -1094.2, y = 260.8, z = 67.5 },
			{ x = -1091.8, y = 263.1, z = 67.5 },
			{ x = -1090.1, y = 260.2, z = 67.5 },
		},
	},
	-- ── Bakery: Gold Crust Bakehouse ──
	-- PLACEHOLDER location - move in-game.
	GoldCrust = {
		Type    = 'bakery',
		MenuGroup = 'bakery',
		Job     = 'goldcrust',
		Society = 'goldcrust',
		Label   = 'Bakery GoldCrust',

		Blip = {
			Pos     = { x = 150.0, y = -1300.0, z = 29.0 },
			Sprite  = 432,
			Display = 4,
			Scale   = 1.0,
			Colour  = 46,
		},

		Freezer            = { Pos = { x = 142.5, y = -1294.4, z = 29.3 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = 145.0, y = -1307.0, z = 28.9, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = 136.0, y = -1287.5, z = 29.4 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = 146.4, y = -1285.8, z = 29.3 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = 141.7, y = -1300.0, z = 29.05 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = 146.3, y = -1297.2, z = 28.85 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = 145.6, y = -1297.9, z = 29.05 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = 141.6, y = -1292.3, z = 28.75 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = 148.8, y = -1296.8, z = 28.85 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = 129.0, y = -1300.0, z = 29.33 },
		SpawnPoint   = { x = 115.0, y = -1294.0, z = 28.3, w = 268.28 },
		DeleteMarker = { x = 124.0, y = -1294.9, z = 29.33 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = 151.3, y = -1291.5, z = 27.5 },
			{ x = 151.3, y = -1290.2, z = 27.5 },
			{ x = 157.0, y = -1291.9, z = 27.5 },
			{ x = 156.9, y = -1290.6, z = 27.5 },
			{ x = 159.3, y = -1290.5, z = 27.5 },
			{ x = 159.2, y = -1292.0, z = 27.5 },
			{ x = 155.8, y = -1299.2, z = 27.5 },
			{ x = 158.2, y = -1296.9, z = 27.5 },
			{ x = 159.9, y = -1299.8, z = 27.5 },
		},
	},
	-- ── Bar: Static Lounge ──
	-- PLACEHOLDER location - move in-game.
	Static = {
		Type    = 'bar',
		MenuGroup = 'bar',
		Job     = 'static',
		Society = 'static',
		Label   = 'Bar Static',

		Blip = {
			Pos     = { x = -1385.0, y = -600.0, z = 30.5 },
			Sprite  = 93,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27,
		},

		Freezer            = { Pos = { x = -1392.5, y = -594.4, z = 30.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1390.0, y = -607.0, z = 30.4, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1399.0, y = -587.5, z = 30.9 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1388.6, y = -585.8, z = 30.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1393.3, y = -600.0, z = 30.55 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1388.7, y = -597.2, z = 30.35 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1389.4, y = -597.9, z = 30.55 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1393.4, y = -592.3, z = 30.25 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1386.2, y = -596.8, z = 30.35 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1406.0, y = -600.0, z = 30.83 },
		SpawnPoint   = { x = -1420.0, y = -594.0, z = 29.8, w = 268.28 },
		DeleteMarker = { x = -1411.0, y = -594.9, z = 30.83 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1383.7, y = -591.5, z = 29.0 },
			{ x = -1383.7, y = -590.2, z = 29.0 },
			{ x = -1378.0, y = -591.9, z = 29.0 },
			{ x = -1378.1, y = -590.6, z = 29.0 },
			{ x = -1375.7, y = -590.5, z = 29.0 },
			{ x = -1375.8, y = -592.0, z = 29.0 },
			{ x = -1379.2, y = -599.2, z = 29.0 },
			{ x = -1376.8, y = -596.9, z = 29.0 },
			{ x = -1375.1, y = -599.8, z = 29.0 },
		},
	},
	-- ── Bar: Nightjar Pub ──
	-- PLACEHOLDER location - move in-game.
	Nightjar = {
		Type    = 'bar',
		MenuGroup = 'bar',
		Job     = 'nightjar',
		Society = 'nightjar',
		Label   = 'Bar Nightjar',

		Blip = {
			Pos     = { x = -560.0, y = 290.0, z = 82.5 },
			Sprite  = 93,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27,
		},

		Freezer            = { Pos = { x = -567.5, y = 295.6, z = 82.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -565.0, y = 283.0, z = 82.4, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -574.0, y = 302.5, z = 82.9 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -563.6, y = 304.2, z = 82.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -568.3, y = 290.0, z = 82.55 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -563.7, y = 292.8, z = 82.35 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -564.4, y = 292.1, z = 82.55 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -568.4, y = 297.7, z = 82.25 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -561.2, y = 293.2, z = 82.35 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -581.0, y = 290.0, z = 82.83 },
		SpawnPoint   = { x = -595.0, y = 296.0, z = 81.8, w = 268.28 },
		DeleteMarker = { x = -586.0, y = 295.1, z = 82.83 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -558.7, y = 298.5, z = 81.0 },
			{ x = -558.7, y = 299.8, z = 81.0 },
			{ x = -553.0, y = 298.1, z = 81.0 },
			{ x = -553.1, y = 299.4, z = 81.0 },
			{ x = -550.7, y = 299.5, z = 81.0 },
			{ x = -550.8, y = 298.0, z = 81.0 },
			{ x = -554.2, y = 290.8, z = 81.0 },
			{ x = -551.8, y = 293.1, z = 81.0 },
			{ x = -550.1, y = 290.2, z = 81.0 },
		},
	},
	-- ── Pizza: Firebrick Pizza Co. ──
	-- PLACEHOLDER location - move in-game.
	Firebrick = {
		Type    = 'pizza',
		MenuGroup = 'pizza',
		Job     = 'firebrick',
		Society = 'firebrick',
		Label   = 'Pizza Firebrick',

		Blip = {
			Pos     = { x = -710.0, y = -915.0, z = 19.2 },
			Sprite  = 273,
			Display = 4,
			Scale   = 1.0,
			Colour  = 1,
		},

		Freezer            = { Pos = { x = -717.5, y = -909.4, z = 19.5 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -715.0, y = -922.0, z = 19.099999999999998, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -724.0, y = -902.5, z = 19.599999999999998 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -713.6, y = -900.8, z = 19.5 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -718.3, y = -915.0, z = 19.25 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -713.7, y = -912.2, z = 19.05 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -714.4, y = -912.9, z = 19.25 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -718.4, y = -907.3, z = 18.95 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -711.2, y = -911.8, z = 19.05 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -731.0, y = -915.0, z = 19.529999999999998 },
		SpawnPoint   = { x = -745.0, y = -909.0, z = 18.5, w = 268.28 },
		DeleteMarker = { x = -736.0, y = -909.9, z = 19.529999999999998 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -708.7, y = -906.5, z = 17.7 },
			{ x = -708.7, y = -905.2, z = 17.7 },
			{ x = -703.0, y = -906.9, z = 17.7 },
			{ x = -703.1, y = -905.6, z = 17.7 },
			{ x = -700.7, y = -905.5, z = 17.7 },
			{ x = -700.8, y = -907.0, z = 17.7 },
			{ x = -704.2, y = -914.2, z = 17.7 },
			{ x = -701.8, y = -911.9, z = 17.7 },
			{ x = -700.1, y = -914.8, z = 17.7 },
		},
	},
	-- ── Pizza: Slice Society ──
	-- PLACEHOLDER location - move in-game.
	Slice = {
		Type    = 'pizza',
		MenuGroup = 'pizza',
		Job     = 'slice',
		Society = 'slice',
		Label   = 'Pizza Slice',

		Blip = {
			Pos     = { x = -47.0, y = -1750.0, z = 29.5 },
			Sprite  = 273,
			Display = 4,
			Scale   = 1.0,
			Colour  = 1,
		},

		Freezer            = { Pos = { x = -54.5, y = -1744.4, z = 29.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -52.0, y = -1757.0, z = 29.4, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -61.0, y = -1737.5, z = 29.9 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -50.6, y = -1735.8, z = 29.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -55.3, y = -1750.0, z = 29.55 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -50.7, y = -1747.2, z = 29.35 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -51.4, y = -1747.9, z = 29.55 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -55.4, y = -1742.3, z = 29.25 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -48.2, y = -1746.8, z = 29.35 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -68.0, y = -1750.0, z = 29.83 },
		SpawnPoint   = { x = -82.0, y = -1744.0, z = 28.8, w = 268.28 },
		DeleteMarker = { x = -73.0, y = -1744.9, z = 29.83 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -45.7, y = -1741.5, z = 28.0 },
			{ x = -45.7, y = -1740.2, z = 28.0 },
			{ x = -40.0, y = -1741.9, z = 28.0 },
			{ x = -40.1, y = -1740.6, z = 28.0 },
			{ x = -37.7, y = -1740.5, z = 28.0 },
			{ x = -37.8, y = -1742.0, z = 28.0 },
			{ x = -41.2, y = -1749.2, z = 28.0 },
			{ x = -38.8, y = -1746.9, z = 28.0 },
			{ x = -37.1, y = -1749.8, z = 28.0 },
		},
	},
	-- ── Icecream: Frostbite Creamery ──
	-- PLACEHOLDER location - move in-game.
	Frostbite = {
		Type    = 'icecream',
		MenuGroup = 'icecream',
		Job     = 'frostbite',
		Society = 'frostbite',
		Label   = 'Bastani Frostbite',

		Blip = {
			Pos     = { x = -820.0, y = 180.0, z = 71.5 },
			Sprite  = 314,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27,
		},

		Freezer            = { Pos = { x = -827.5, y = 185.6, z = 71.8 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -825.0, y = 173.0, z = 71.4, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -834.0, y = 192.5, z = 71.9 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -823.6, y = 194.2, z = 71.8 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -828.3, y = 180.0, z = 71.55 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -823.7, y = 182.8, z = 71.35 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -824.4, y = 182.1, z = 71.55 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -828.4, y = 187.7, z = 71.25 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -821.2, y = 183.2, z = 71.35 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -841.0, y = 180.0, z = 71.83 },
		SpawnPoint   = { x = -855.0, y = 186.0, z = 70.8, w = 268.28 },
		DeleteMarker = { x = -846.0, y = 185.1, z = 71.83 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -818.7, y = 188.5, z = 70.0 },
			{ x = -818.7, y = 189.8, z = 70.0 },
			{ x = -813.0, y = 188.1, z = 70.0 },
			{ x = -813.1, y = 189.4, z = 70.0 },
			{ x = -810.7, y = 189.5, z = 70.0 },
			{ x = -810.8, y = 188.0, z = 70.0 },
			{ x = -814.2, y = 180.8, z = 70.0 },
			{ x = -811.8, y = 183.1, z = 70.0 },
			{ x = -810.1, y = 180.2, z = 70.0 },
		},
	},
	-- ── Icecream: Sundae Funday ──
	-- PLACEHOLDER location - move in-game.
	Sundae = {
		Type    = 'icecream',
		MenuGroup = 'icecream',
		Job     = 'sundae',
		Society = 'sundae',
		Label   = 'Bastani Sundae',

		Blip = {
			Pos     = { x = -1090.0, y = -390.0, z = 36.7 },
			Sprite  = 314,
			Display = 4,
			Scale   = 1.0,
			Colour  = 27,
		},

		Freezer            = { Pos = { x = -1097.5, y = -384.4, z = 37.0 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1095.0, y = -397.0, z = 36.6, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1104.0, y = -377.5, z = 37.1 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1093.6, y = -375.8, z = 37.0 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1098.3, y = -390.0, z = 36.75 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1093.7, y = -387.2, z = 36.550000000000004 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1094.4, y = -387.9, z = 36.75 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1098.4, y = -382.3, z = 36.45 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1091.2, y = -386.8, z = 36.550000000000004 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1111.0, y = -390.0, z = 37.03 },
		SpawnPoint   = { x = -1125.0, y = -384.0, z = 36.0, w = 268.28 },
		DeleteMarker = { x = -1116.0, y = -384.9, z = 37.03 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1088.7, y = -381.5, z = 35.2 },
			{ x = -1088.7, y = -380.2, z = 35.2 },
			{ x = -1083.0, y = -381.9, z = 35.2 },
			{ x = -1083.1, y = -380.6, z = 35.2 },
			{ x = -1080.7, y = -380.5, z = 35.2 },
			{ x = -1080.8, y = -382.0, z = 35.2 },
			{ x = -1084.2, y = -389.2, z = 35.2 },
			{ x = -1081.8, y = -386.9, z = 35.2 },
			{ x = -1080.1, y = -389.8, z = 35.2 },
		},
	},
	-- ── Sushi: Koi Sushi House ──
	-- PLACEHOLDER location - move in-game.
	Koi = {
		Type    = 'sushi',
		MenuGroup = 'sushi',
		Job     = 'koi',
		Society = 'koi',
		Label   = 'Sushi Koi',

		Blip = {
			Pos     = { x = -560.0, y = -1250.0, z = 17.6 },
			Sprite  = 88,
			Display = 4,
			Scale   = 1.0,
			Colour  = 2,
		},

		Freezer            = { Pos = { x = -567.5, y = -1244.4, z = 17.900000000000002 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -565.0, y = -1257.0, z = 17.5, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -574.0, y = -1237.5, z = 18.0 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -563.6, y = -1235.8, z = 17.900000000000002 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -568.3, y = -1250.0, z = 17.650000000000002 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -563.7, y = -1247.2, z = 17.450000000000003 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -564.4, y = -1247.9, z = 17.650000000000002 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -568.4, y = -1242.3, z = 17.35 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -561.2, y = -1246.8, z = 17.450000000000003 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -581.0, y = -1250.0, z = 17.93 },
		SpawnPoint   = { x = -595.0, y = -1244.0, z = 16.900000000000002, w = 268.28 },
		DeleteMarker = { x = -586.0, y = -1244.9, z = 17.93 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -558.7, y = -1241.5, z = 16.1 },
			{ x = -558.7, y = -1240.2, z = 16.1 },
			{ x = -553.0, y = -1241.9, z = 16.1 },
			{ x = -553.1, y = -1240.6, z = 16.1 },
			{ x = -550.7, y = -1240.5, z = 16.1 },
			{ x = -550.8, y = -1242.0, z = 16.1 },
			{ x = -554.2, y = -1249.2, z = 16.1 },
			{ x = -551.8, y = -1246.9, z = 16.1 },
			{ x = -550.1, y = -1249.8, z = 16.1 },
		},
	},
	-- ── Sushi: Wasabi & Co. ──
	-- PLACEHOLDER location - move in-game.
	Wasabi = {
		Type    = 'sushi',
		MenuGroup = 'sushi',
		Job     = 'wasabi',
		Society = 'wasabi',
		Label   = 'Sushi Wasabi',

		Blip = {
			Pos     = { x = -1210.0, y = -450.0, z = 36.9 },
			Sprite  = 88,
			Display = 4,
			Scale   = 1.0,
			Colour  = 2,
		},

		Freezer            = { Pos = { x = -1217.5, y = -444.4, z = 37.199999999999996 }, Name = "Freezer",     Icon = "fa-regular fa-snowflake" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -1215.0, y = -457.0, z = 36.8, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -1224.0, y = -437.5, z = 37.3 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -1213.6, y = -435.8, z = 37.199999999999996 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -1218.3, y = -450.0, z = 36.949999999999996 }, Name = "HamZan",      Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -1213.7, y = -447.2, z = 36.75 }, Name = "Ghahve Saz",  Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -1214.4, y = -447.9, z = 36.949999999999996 }, Name = "Zarf Shoe",   Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -1218.4, y = -442.3, z = 36.65 }, Name = "Gaz",         Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -1211.2, y = -446.8, z = 36.75 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -1231.0, y = -450.0, z = 37.23 },
		SpawnPoint   = { x = -1245.0, y = -444.0, z = 36.199999999999996, w = 268.28 },
		DeleteMarker = { x = -1236.0, y = -444.9, z = 37.23 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -1208.7, y = -441.5, z = 35.4 },
			{ x = -1208.7, y = -440.2, z = 35.4 },
			{ x = -1203.0, y = -441.9, z = 35.4 },
			{ x = -1203.1, y = -440.6, z = 35.4 },
			{ x = -1200.7, y = -440.5, z = 35.4 },
			{ x = -1200.8, y = -442.0, z = 35.4 },
			{ x = -1204.2, y = -449.2, z = 35.4 },
			{ x = -1201.8, y = -446.9, z = 35.4 },
			{ x = -1200.1, y = -449.8, z = 35.4 },
		},
	},

	-- ── Carwash: Suds & Cash ──
	-- PLACEHOLDER location - move in-game.
	Suds = {
		Type    = 'carwash',
		MenuGroup = 'carwash',
		Job     = 'carwash',
		Society = 'carwash',
		Label   = 'Carwash Suds',

		Blip = {
			Pos     = { x = -207.0, y = -1330.0, z = 31.0 },
			Sprite  = 402,
			Display = 4,
			Scale   = 1.0,
			Colour  = 46,
		},

		Freezer            = { Pos = { x = -214.5, y = -1324.4, z = 31.3 }, Name = "Storage",    Icon = "fa-regular fa-box" },
		PedShop            = { Model = 's_m_m_ammucountry', Pos = { x = -212.0, y = -1337.0, z = 30.9, h = 200.0 }, Name = "Shop", Icon = "fa-solid fa-shop" },
		BossAction         = { Pos = { x = -221.0, y = -1317.5, z = 31.4 }, Name = "Boss Actions", Icon = "fa-solid fa-gear" },
		CloackRoom         = { Pos = { x = -210.6, y = -1315.8, z = 31.3 }, Name = "Cloack Room", Icon = "fa-solid fa-shirt" },
		Crafting_Hamzan    = { Pos = { x = -215.3, y = -1330.0, z = 31.05 }, Name = "Bench 1",     Icon = "fa-brands fa-files-pinwheel" },
		Crafting_Ghahvesaz = { Pos = { x = -210.7, y = -1327.2, z = 30.85 }, Name = "Bench 2",     Icon = "fa-brands fa-java" },
		Crafting_ZarfShoe  = { Pos = { x = -211.4, y = -1327.9, z = 31.05 }, Name = "Bench 3",     Icon = "fa-brands fa-first-order-alt" },
		Crafting_Gaz       = { Pos = { x = -215.4, y = -1322.3, z = 30.75 }, Name = "Bench 4",     Icon = "fa-brands fa-firefox-browser" },
		Menu_Sefaresh      = { Pos = { x = -208.2, y = -1326.8, z = 30.85 }, Name = "Menu",        Icon = "fa-brands fa-whmcs" },

		SpawnVehicle = 'scania',
		SpawnMarker  = { x = -228.0, y = -1330.0, z = 31.33 },
		SpawnPoint   = { x = -242.0, y = -1324.0, z = 30.3, w = 268.28 },
		DeleteMarker = { x = -233.0, y = -1324.9, z = 31.33 },

		CatModel        = "a_c_cat_01",
		SpawnLocations = {
			{ x = -205.7, y = -1321.5, z = 29.5 },
			{ x = -205.7, y = -1320.2, z = 29.5 },
			{ x = -200.0, y = -1321.9, z = 29.5 },
			{ x = -200.1, y = -1320.6, z = 29.5 },
			{ x = -197.7, y = -1320.5, z = 29.5 },
			{ x = -197.8, y = -1322.0, z = 29.5 },
			{ x = -201.2, y = -1329.2, z = 29.5 },
			{ x = -198.8, y = -1326.9, z = 29.5 },
			{ x = -197.1, y = -1329.8, z = 29.5 },
		},
	},
}

-- ── Helpers shared by both client and server ──

CafeJobSet = {}
for _, cafe in pairs(Cafes) do
	CafeJobSet[cafe.Job] = true
end

-- Returns the cafe table this job belongs to, or nil if it's not a cafe job.
function GetCafeForJob(jobName)
	for _, cafe in pairs(Cafes) do
		if cafe.Job == jobName then
			return cafe
		end
	end
	return nil
end

function IsCafeJob(jobName)
	return CafeJobSet[jobName] == true
end
