--[[
	4 holding jobs, each owning a fixed subset of the 17 businesses (see the
	`Holding` field on every business in shared/cafes.lua):

	Holding 1 (job 'meridian')     - owns: uwucafe, obsidian, voltage, ember, anchor, crimson (6)
	Blacktide Logistics            - owns: flourish, goldcrust, carwash (3) + mafia laundering
	Crate & Carry Distribution     - owns: firebrick, slice, frostbite, sundae (4) + wholesale reseller
	Holding 2 (job 'turfco')       - owns: static, nightjar, koi, wasabi (4) + paintball turf rental

	Every holding's Boss Action gives the SAME generic management toolkit
	over ONLY the businesses it owns: Portfolio Dashboard, Rank Up (fee %),
	Manage Staff, Open/Close, Rename - see server/corp_server.lua. On top of
	that, every holding also keeps its own special mechanic:
	Blacktide = money laundering, CrateCarry = wholesale reseller,
	TurfCo = paintball turf rental, Meridian = raw-material Supply
	Contract (see Corp.Meridian.SupplyPrices below + the
	'uniquecafejobs:corp:*SupplyContract' events in server/corp_server.lua) -
	Meridian sells straight off that price list to the OTHER 3 holdings, at
	roughly 40% below the Config.UwUShopItem retail price (shared/menu.lua),
	so a Director+ of Blacktide/CrateCarry/TurfCo can restock one of THEIR
	OWN businesses in bulk instead of only ever paying full NPC price.

	All HQ coordinates are PLACEHOLDERS - move them in-game.
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
		Label   = 'Holding 1',

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
		-- ~40% below the matching Config.UwUShopItem retail price.
		SupplyBuyLimit = 50, -- max units per single purchase
		SupplyPrices = {
			aard = 60,   abporteghal = 3000, ice_coffee_matcha = 2700, bastani = 3000,
			nutela = 120, chaee = 3000,       bakingpowder = 120,      daneghahve = 120,
			egg = 60,    fenjon = 60,         kare = 120,              kase = 60,
			limo = 60,   podrcacao = 120,     shekar = 60,             shir = 120,
			totfarangi = 120, yakh = 60,      water = 60,              bread = 60,
			vanil = 120, tamshak = 105,       powdr_matcha = 120,      oreo = 60,
			nodel_kham = 180, khame = 90,
		},
	},

	Blacktide = {
		Job     = 'blacktide',
		Society = 'blacktide',
		Label   = 'Blacktide Logistics',

		HQ = { x = 1207.0, y = -3129.0, z = 5.9 }, -- docks (placeholder)
		Blip = { Sprite = 478, Color = 1, Scale = 1.0 },

		BossAction = { Pos = { x = 1207.0, y = -3129.0, z = 5.9 }, Name = 'Boss Actions', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1211.0, y = -3129.0, z = 5.9 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'burrito3',
		SpawnMarker  = { x = 1220.0, y = -3129.0, z = 5.9 },
		SpawnPoint   = { x = 1230.0, y = -3123.0, z = 5.0,  w = 90.0 },
		DeleteMarker = { x = 1225.0, y = -3124.0, z = 5.9 },

		CollectCooldownMins = 30,

		LaunderCutPercent  = 65,
		BusinessCutPercent = 10,
		MaxPerWash      = 10000,
		CooldownSeconds = 600,
	},

	CrateCarry = {
		Job     = 'cratecarry',
		Society = 'cratecarry',
		Label   = 'Crate & Carry Distribution',

		HQ = { x = 1210.0, y = -3050.0, z = 5.0 }, -- warehouse (placeholder)
		Blip = { Sprite = 473, Color = 5, Scale = 1.0 },

		Freezer    = { Pos = { x = 1210.0, y = -3050.0, z = 5.0 }, Name = 'Warehouse Stock', Icon = 'fa-regular fa-box' },
		ResaleShop = { Pos = { x = 1214.0, y = -3050.0, z = 5.0 }, Name = 'Resale Counter',  Icon = 'fa-solid fa-cash-register' },
		BossAction = { Pos = { x = 1206.0, y = -3050.0, z = 5.0 }, Name = 'Boss Actions', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1218.0, y = -3050.0, z = 5.0 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'mule',
		SpawnMarker  = { x = 1195.0, y = -3050.0, z = 5.0 },
		SpawnPoint   = { x = 1185.0, y = -3044.0, z = 4.1,  w = 90.0 },
		DeleteMarker = { x = 1190.0, y = -3045.0, z = 5.0 },

		CollectCooldownMins = 30,

		WholesaleUnitPrice = 5,
		WholesaleBuyLimit  = 20,
		Markup             = 1.8,
	},
}

CorpJobSet = { meridian = true, blacktide = true, cratecarry = true, turfco = true }

function IsCorpJob(jobName)
	return CorpJobSet[jobName] == true
end

-- Every holding job -> its Corp.* config table (turfco is added by
-- shared/turfco.lua, which runs after this file, so this stays a function).
function GetHoldingConfig(job)
	if job == Corp.Meridian.Job then return Corp.Meridian end
	if job == Corp.Blacktide.Job then return Corp.Blacktide end
	if job == Corp.CrateCarry.Job then return Corp.CrateCarry end
	if job == TurfCo.Job then return TurfCo end
	return nil
end
