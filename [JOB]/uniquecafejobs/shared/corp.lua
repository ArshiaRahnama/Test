--[[
	3 corporate-tier jobs sitting on top of the 17 businesses:

	Meridian Holdings (job 'meridian')  - manages/oversees all 17 businesses,
	    collects a franchise fee from each one on a cooldown.

	Blacktide Logistics (job 'blacktide') - mafia money-laundering front.
	    Members launder black_money AT any of the 17 businesses' shop; the
	    business itself gets a cut too (so it's a real incentive to use
	    a specific business, not just a flat "launder anywhere" button).

	Crate & Carry Distribution (job 'cratecarry') - wholesale distributor.
	    Members buy finished stock wholesale straight out of any of the 17
	    businesses' freezers, then resell it from their own warehouse shop
	    at a markup.

	All 3 use PLACEHOLDER HQ coordinates - move them in-game.
]]

Corp = {
	Meridian = {
		Job     = 'meridian',
		Society = 'meridian',
		Label   = 'Holding 1',

		HQ = { x = -75.3, y = -818.3, z = 243.8 }, -- Maze Bank Tower area (placeholder)
		Blip = { Sprite = 476, Color = 2, Scale = 1.0 },

		BossAction = { Pos = { x = -75.3, y = -818.3, z = 243.8 }, Name = 'Portfolio Dashboard', Icon = 'fa-solid fa-chart-line' },
		CloackRoom = { Pos = { x = -71.3, y = -818.3, z = 243.8 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'baller6',
		SpawnMarker  = { x = -60.0, y = -818.3, z = 243.8 },
		SpawnPoint   = { x = -50.0, y = -812.0, z = 242.9, w = 90.0 },
		DeleteMarker = { x = -55.0, y = -813.0, z = 243.8 },

		FranchiseFeePercent  = 5,   -- % of each business's current balance collected per run
		CollectCooldownMins  = 30,  -- server-wide cooldown between collection runs

		-- ── Portfolio (10 businesses Meridian must ACQUIRE one by one) ──
		-- These are the 10 newer bakery/bar/pizza/icecream/sushi businesses.
		-- Not acquired = completely untouched by Meridian, no fee taken.
		PortfolioJobs = { 'flourish', 'goldcrust', 'static', 'nightjar', 'firebrick', 'slice', 'frostbite', 'sundae', 'koi', 'wasabi' },
		AcquireCost = 20000, -- one-time cost to acquire a portfolio business at Bronze rank

		-- Rank upgrades raise the % collected from that specific business.
		Ranks = {
			{ id = 'bronze', label = 'Bronze', feePercent = 5,  upgradeCost = 0 },      -- starting rank on acquisition
			{ id = 'silver', label = 'Silver', feePercent = 8,  upgradeCost = 15000 },
			{ id = 'gold',   label = 'Gold',   feePercent = 12, upgradeCost = 30000 },
		},

		-- ── VIP (the 7 original/prestige businesses: 3 cafes, 3 restaurants, the car wash) ──
		-- Separate track from Portfolio: no acquiring/ranking, just a single
		-- one-time "Sign Partnership" buy-in per business, then Meridian
		-- automatically collects a flat cut from it every franchise-fee run.
		VIPJobs = { 'uwucafe', 'obsidian', 'voltage', 'ember', 'anchor', 'crimson', 'carwash' },
		VIPPartnershipCost = 50000, -- one-time investment to sign a VIP partnership
		VIPFeePercent = 15,          -- flat cut collected from every signed VIP business
	},

	Blacktide = {
		Job     = 'blacktide',
		Society = 'blacktide',
		Label   = 'Blacktide Logistics',

		HQ = { x = 1207.0, y = -3129.0, z = 5.9 }, -- docks (placeholder)
		Blip = { Sprite = 478, Color = 1, Scale = 1.0 },

		BossAction = { Pos = { x = 1207.0, y = -3129.0, z = 5.9 }, Name = 'Boss Action', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1211.0, y = -3129.0, z = 5.9 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'burrito3',
		SpawnMarker  = { x = 1220.0, y = -3129.0, z = 5.9 },
		SpawnPoint   = { x = 1230.0, y = -3123.0, z = 5.0,  w = 90.0 },
		DeleteMarker = { x = 1225.0, y = -3124.0, z = 5.9 },

		LaunderCutPercent  = 65, -- % Blacktide's own society keeps
		BusinessCutPercent = 10, -- % goes to whichever of the 17 businesses was used
		-- remaining 25% is lost as the "laundering fee" (heat/risk)
		MaxPerWash      = 10000,
		CooldownSeconds = 600, -- per player, per wash
	},

	CrateCarry = {
		Job     = 'cratecarry',
		Society = 'cratecarry',
		Label   = 'Crate & Carry Distribution',

		HQ = { x = 1210.0, y = -3050.0, z = 5.0 }, -- warehouse (placeholder)
		Blip = { Sprite = 473, Color = 5, Scale = 1.0 },

		Freezer    = { Pos = { x = 1210.0, y = -3050.0, z = 5.0 }, Name = 'Warehouse Stock', Icon = 'fa-regular fa-box' },
		ResaleShop = { Pos = { x = 1214.0, y = -3050.0, z = 5.0 }, Name = 'Resale Counter',  Icon = 'fa-solid fa-cash-register' },
		BossAction = { Pos = { x = 1206.0, y = -3050.0, z = 5.0 }, Name = 'Boss Action', Icon = 'fa-solid fa-gear' },
		CloackRoom = { Pos = { x = 1218.0, y = -3050.0, z = 5.0 }, Name = 'Cloack Room', Icon = 'fa-solid fa-shirt' },

		SpawnVehicle = 'mule',
		SpawnMarker  = { x = 1195.0, y = -3050.0, z = 5.0 },
		SpawnPoint   = { x = 1185.0, y = -3044.0, z = 4.1,  w = 90.0 },
		DeleteMarker = { x = 1190.0, y = -3045.0, z = 5.0 },

		WholesaleUnitPrice = 5,   -- price PAID to the source business's society account, per unit bought
		WholesaleBuyLimit  = 20,  -- max units per purchase
		Markup             = 1.8, -- resale price = item's normal price * Markup (rounded)
	},
}

CorpJobSet = { meridian = true, blacktide = true, cratecarry = true }

function IsCorpJob(jobName)
	return CorpJobSet[jobName] == true
end
