--[[
	Multi-cafe registry. Add a new cafe by copying one of the blocks below and
	giving it a new `Job` (must also exist in the `jobs` / `job_grades` SQL
	tables), a new `Society` name, and its own set of station coordinates.

	Every cafe is a fully separate business: an employee of one cafe cannot
	use another cafe's freezer/crafting/boss menu/cloakroom - same rule as
	the rest of the server's job resources.

	Only "UwU Café" keeps its original coordinates (that's the one that
	already existed and works). All 16 other businesses below use PLACEHOLDER
	coordinates - move them in-game to wherever you actually want them.

	Checked: none of the 16 placeholder anchor points below are within ~150m
	of each other, "UwU", or any of the 4 holding HQs in shared/corp.lua /
	shared/turfco.lua, so there's no risk of two businesses' freezer/crafting/
	spawn clusters overlapping each other. What's NOT verified (no way to
	render the actual map from here) is whether any single anchor happens to
	land inside a building, underwater, etc. - each block's comment now names
	the real Los Santos neighborhood its numbers actually fall in (a couple
	were mislabeled - e.g. "Rockford Hills" was actually Pacific Bluffs) so
	you know roughly where to teleport to when fine-tuning in-game.
]]

Cafes = {

	-- ── Café #1: UwU Café (original, unchanged location) ──
	UwU = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'uwucafe',
		Holding = 'meridian',
		Society = 'uwucafe',
		Label   = 'Cafe 1',

		Blip = {
			Pos     = { x = -581.831, y = -1064.56, z = 22.347 },
			Sprite  = 621,
			Display = 4,
			Scale   = 0.7,
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
	-- PLACEHOLDER location - these coords actually sit on the Pacific Bluffs
	-- coastline near Vespucci (not Rockford Hills as originally noted) -
	-- still not overlapping any other business/HQ below, but confirm/move
	-- in-game before going live.
	Obsidian = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'obsidian',
		Holding = 'meridian',
		Society = 'obsidian',
		Label   = 'Cafe 2',

		Blip = {
			Pos     = { x = -1223.0, y = -906.0, z = 12.33 },
			Sprite  = 621,
			Display = 4,
			Scale   = 0.7,
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
	-- PLACEHOLDER location - these coords actually sit near Cypress Flats /
	-- Elysian Island (east LS industrial, not Textile City as originally
	-- noted) - still not overlapping any other business/HQ, but
	-- confirm/move in-game before going live.
	Voltage = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'voltage',
		Holding = 'turfco',
		Society = 'voltage',
		Label   = 'Cafe 3',

		Blip = {
			Pos     = { x = 442.9, y = -1750.0, z = 29.5 },
			Sprite  = 621,
			Display = 4,
			Scale   = 0.7,
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
	-- PLACEHOLDER location - these coords actually sit near the Pacific
	-- Bluffs / GWC Golfing Society area (not Vinewood Hills as originally
	-- noted; z=30.3 is too low for the Hills) - still not overlapping any
	-- other business/HQ, but confirm/move in-game before going live.
	Ember = {
		Type    = 'restaurant',
		MenuGroup = 'restaurant',
		Job     = 'ember',
		Holding = 'meridian',
		Society = 'ember',
		Label   = 'Restaurant 1',

		Blip = {
			Pos     = { x = -1391.0, y = -583.0, z = 30.3 },
			Sprite  = 93,
			Display = 4,
			Scale   = 0.7,
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
		MenuGroup = 'restaurant',
		Job     = 'anchor',
		Holding = 'turfco',
		Society = 'anchor',
		Label   = 'Restaurant 2',

		Blip = {
			Pos     = { x = -1850.0, y = -1230.0, z = 13.0 },
			Sprite  = 356,
			Display = 4,
			Scale   = 0.7,
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
	-- PLACEHOLDER location - these coords actually sit near Pillbox Hill /
	-- Textile City downtown high-rises (not Rodeo Drive as originally
	-- noted) - still not overlapping any other business/HQ, but
	-- confirm/move in-game before going live.
	Crimson = {
		Type    = 'restaurant',
		MenuGroup = 'restaurant',
		Job     = 'crimson',
		Holding = 'meridian',
		Society = 'crimson',
		Label   = 'Restaurant 3',

		Blip = {
			Pos     = { x = -278.0, y = -720.0, z = 33.0 },
			Sprite  = 93,
			Display = 4,
			Scale   = 0.7,
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
	-- ── Bakery: Gold Crust Bakehouse ──
	-- ── Bar: Static Lounge ──
	-- PLACEHOLDER location (Pacific Bluffs, near the golf club) - move in-game.
	Static = {
		Type    = 'restaurant',
		MenuGroup = 'restaurant',
		Job     = 'static',
		Holding = 'turfco',
		Society = 'static',
		Label   = 'Restaurant 4',

		Blip = {
			Pos     = { x = -1385.0, y = -600.0, z = 30.5 },
			Sprite  = 93,
			Display = 4,
			Scale   = 0.7,
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
	-- PLACEHOLDER location (Vinewood Hills, near the sign) - move in-game.
	Nightjar = {
		Type    = 'cafe',
		MenuGroup = 'cafe',
		Job     = 'nightjar',
		Holding = 'turfco',
		Society = 'nightjar',
		Label   = 'Cafe 4',

		Blip = {
			Pos     = { x = -560.0, y = 290.0, z = 82.5 },
			Sprite  = 93,
			Display = 4,
			Scale   = 0.7,
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
	-- ── Pizza: Slice Society ──
	-- ── Icecream: Frostbite Creamery ──
	-- ── Icecream: Sundae Funday ──
	-- ── Sushi: Koi Sushi House ──
	-- ── Sushi: Wasabi & Co. ──
	-- ── Carwash: Suds & Cash ──
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

-- Ownership / holding lookup: cafes AND vms barber/tattoo shops.
-- Use this in holding, takeover, portfolio and vms money code. Cafe UI and
-- crafting keep GetCafeForJob (cafes only).
function GetBusinessForJob(jobName)
	local cafe = GetCafeForJob(jobName)
	if cafe then return cafe end
	for _, biz in ipairs(VmsBusinesses or {}) do
		if biz.Job == jobName then return biz end
	end
	return nil
end
