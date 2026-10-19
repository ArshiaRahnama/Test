--[[
	Holdings: Gang 1 (meridian) and Gang 2 (turfco). Each owns its own
	businesses (shared/cafes.lua) and gets a Boss Action with the holding toolkit.
]]

-- Each HOLDING now owns its own independent rank ladder (fee % + upgrade
-- cost per tier), editable in-game by its Owner via the "Manage Ranks"
-- Boss Action (see server/corp_server.lua's HoldingRanks table, backed by
-- the `holding_ranks` SQL table). DefaultRanks below is only the seed used
-- the very first time a holding is bootstrapped (or a re-seed if a holding
-- somehow ends up with zero ranks) - after that, editing/adding/removing
-- ranks for a holding NEVER touches any other holding's ladder.
DefaultRanks = {
	{ id = 'bronze', label = 'Bronze', feePercent = 5,  upgradeCost = 0 },
	{ id = 'silver', label = 'Silver', feePercent = 8,  upgradeCost = 15000 },
	{ id = 'gold',   label = 'Gold',   feePercent = 12, upgradeCost = 30000 },
}

Corp = {
	Meridian = {
		Job     = 'meridian',
		Society = 'meridian',
		Label   = 'Gang 1',

		HQ = { x = -75.3, y = -818.3, z = 243.8 }, -- Maze Bank Tower area (placeholder)
		Blip = { Sprite = 476, Color = 2, Scale = 1.0 },

		BossAction = { Pos = { x = -75.3, y = -818.3, z = 243.8 }, Name = 'Boss Actions', Icon = 'fa-solid fa-chart-line' },
		CloackRoom = { Pos = { x = -71.3, y = -818.3, z = 243.8 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'baller6',
		SpawnMarker  = { x = -60.0, y = -818.3, z = 243.8 },
		SpawnPoint   = { x = -50.0, y = -812.0, z = 242.9, w = 90.0 },
		DeleteMarker = { x = -55.0, y = -813.0, z = 243.8 },

		CollectCooldownMins = 30,

		-- Supply Contract: wholesale raw-ingredient price list Meridian
		-- sells to the other 3 holdings (see the file header note above).
		-- ~40% below the matching UCConfig.UwUShopItem retail price.
		SupplyBuyLimit = 50, -- max units per single purchase
		SupplyPrices = {
			aard = 60,   abporteghal = 3000, ice_coffee_matcha = 2700, bastani = 3000,
			nutela = 120, chaee = 3000,       bakingpowder = 120,      daneghahve = 120,
			egg = 60,    fenjon = 60,         kare = 120,              kase = 60,
			limo = 60,   podrcacao = 120,     shekar = 60,             shir = 120,
			totfarangi = 120, yakh = 60,      water = 60,              bread = 60,
			vanil = 120, tamshak = 105,       powdr_matcha = 120,      oreo = 60,
			nodel_kham = 180, khame = 90,
			-- bakery/bar/pizza/icecream/sushi/carwash/restaurant raw materials
			-- (see the fix note in shared/menu.lua) - same ~40% wholesale cut.
			khamir_shirini = 120, mive_mix = 120,   khamir_pizza = 120, sos_gojeh = 90,
			panir_pizza = 120,    khame_yakhi = 120, berenj_sushi = 120, maahi_khaam = 180,
			nori = 90,            soap_foam = 90,    microfiber_cloth = 90,
			steak_raw = 240,      pasta_dry = 90,    seafood_mix = 240,  truffle = 360,
		},
	},
}

CorpJobSet = { meridian = true, turfco = true }

function IsCorpJob(jobName)
	return CorpJobSet[jobName] == true
end

-- Every holding job -> its Corp.* config table (turfco is added by
-- shared/turfco.lua, which runs after this file, so this stays a function).
function GetHoldingConfig(job)
	if job == Corp.Meridian.Job then return Corp.Meridian end
	if job == TurfCo.Job then return TurfCo end
	return nil
end
