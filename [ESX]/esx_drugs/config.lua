Config = {}

Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 1.0, y = 1.0, z = -1.0}
Config.MarkerColor  = {r = 100, g = 204, b = 100}
Config.ShowBlips	= true
Config.ShowMarkers 	= false
Config.MultiPlant	= false

Config.GiveBlack 	= false
Config.EnableCops   = true
Config.UseESXPhone	= false
Config.UseGCPhone	= true
Config.RequireCops	= true
Config.RequiredCopsCoke  = 1
Config.RequiredCopsMeth  = 1
Config.RequiredCopsWeed  = 1
Config.RequiredCopsOpium = 1
Config.RequiredCopsHerin = 1
Config.RequiredCopsCrack = 1

--Drug Dealer (Kharidare Mavad) Stuff--
Config.DealerSellBonus     = 1.3            -- Sell to the dealer for 30% more than the base price
Config.DealerAlertDuration = 4 * 60 * 1000  -- How long the police alert blip / on-screen timer lasts (ms)

--Heat System--
-- Every sale raises the seller's personal heat. Higher heat = more likely (and more severe) police
-- alerts, and a temporarily lower payout, so camping one dealer spot stops being free money.
Config.Heat = {
	PerSale           = 18,   -- heat added per sale
	DecayAmount       = 6,    -- heat removed...
	DecayInterval     = 15 * 1000, -- ...every this many ms of not selling
	Max               = 100,
	BaseAlertChance   = 25,   -- % chance of an alert even at 0 heat (random patrol overhears you)
	MaxPriceDrop      = 0.45, -- at max heat, price is reduced by up to 45%
	HighHeatThreshold = 70,   -- at/above this heat, alerts get a bigger radius + longer duration, and the seller gets a warning
	HighHeatRadiusMult    = 1.6, -- alert radius multiplier once HighHeatThreshold is reached
	HighHeatDurationMult  = 1.5, -- alert duration multiplier once HighHeatThreshold is reached
}

--Gang Tax--
Config.GangTaxPercent = 10 -- % of each dealer sale automatically deposited into the seller's own gang account (0 = disabled)

--Anti-Exploit--
Config.MaxInteractDistance = 5.0 -- max allowed distance (game units) between player and a processing zone/ped when the server receives a process event
Config.SellCooldown        = 2500 -- minimum ms allowed between two sales from the same player

--Escort / Delivery Missions (DOA can intercept)--
Config.Delivery = {
	Enabled          = true,
	MinAmount        = 5,             -- min units of cargo required to start a delivery
	MaxAmount        = 15,            -- max units taken as cargo
	TimeLimit        = 6 * 60 * 1000, -- 6 minutes to reach the drop-off
	RewardMultiplier = 1.6,           -- pays this x the normal dealer price per unit on success
	InterceptRadius  = 3.0,           -- how close DOA must get to a carrier to attempt a seizure
	Cooldown         = 8 * 60 * 1000, -- per-player cooldown between delivery missions
	RouteHintPoints  = 3,             -- number of interpolated waypoints briefed to DOA along the route
	-- Add/replace with real coordinates for your map. Needs at least 2.
	DropZones = {
		{coords = vector3(215.14, -800.85, 30.55),    name = 'Bandare Ghadimi'},
		{coords = vector3(-1035.71, -2735.79, 20.17), name = 'Forudgahe Bari'},
		{coords = vector3(2569.71, 4681.62, 34.13),   name = 'Anbare Sandy Shores'},
		{coords = vector3(-3037.0, 84.0, 12.85),      name = 'Eskele Chumash'},
	},
}

--Drug Convoy Event (server-wide PvP: an NPC cargo van hauls a big shipment between two of the
--Delivery DropZones below; ANY player/gang can attack and stop it to loot the cargo -- no
--paperwork, just a fight. Reuses Config.Delivery.DropZones as route endpoints. DOA gets an
--in-game heads-up via esx_uniquejobs' department chat, and if a DOA officer is the one who stops
--it, it's logged as a real seizure instead of handing them raw drugs -- see Config.UniqueJobs.Convoy)--
Config.Convoy = {
	Enabled        = true,
	MinInterval    = 45 * 60 * 1000, -- min time between convoys (ms)
	MaxInterval    = 90 * 60 * 1000, -- max time between convoys (ms)
	VehicleModel   = 'burrito3',
	DriverModel    = 'g_m_importexport_01',
	GuardModel     = 'g_m_importexport_01',
	GuardCount     = 2,               -- armed passengers who bail out and fight once the van is attacked
	GuardWeapon    = 'WEAPON_CARBINERIFLE',
	GuardHealth    = 250,
	GuardAccuracy  = 40,
	Speed          = 20.0,            -- driving speed along the route
	BlipSprite     = 380,
	BlipColor      = 1,
	StoppedRadius  = 15.0,            -- how close a player must be to loot once the van is stopped
	DespawnTimeout = 15 * 60 * 1000,  -- auto-cleanup if nobody stops it in time
	CargoCash      = { min = 15000, max = 30000 }, -- cash in the loot, on top of item cargo
	CargoItems = { -- each rolled independently against its own chance (%)
		{ item = 'cocaine',   label = 'Cocaine',   min = 15, max = 30, chance = 70 },
		{ item = 'marijuana', label = 'Marijuana', min = 20, max = 40, chance = 70 },
		{ item = 'meth',      label = 'Meth',      min = 10, max = 20, chance = 40 },
		{ item = 'heroine',   label = 'Heroine',   min = 8,  max = 15, chance = 30 },
	},
	DOASeizureCash = 25000, -- flat cash (before Config.GradeBonus scaling) if DOA is who stops it, instead of raw drugs
}

--CID Evidence Referral (DOA collects physical clues at harvest sites and refers them to CID)--
Config.Evidence = {
	InactivityTimeout  = 45 * 60 * 1000, -- if a site gets no new activity for this long, it clears itself uncollected (ms)
	PedInteractRadius  = 8.0,            -- server-side anti-exploit distance check when collecting (covers the ped's offset from the field center)
	AlertDuration      = 5 * 60 * 1000,  -- how long the DOA-only siren blip / countdown lasts when a NEW site is first detected
	AlertRadius        = 80.0,           -- radius of the translucent alert circle for that siren blip
	CollectAnimDuration = 4000,          -- ms spent playing the "documenting the scene" animation before evidence is actually collected
	CollectReward       = 20000,         -- base cash paid directly to the DOA officer who collects a case (see Config.GradeBonus -- scales up with grade)
}

--esx_uniquejobs Integration--
-- Everything here is optional/best-effort: every call into esx_uniquejobs is pcall-wrapped
-- (see server/main.lua), so if esx_uniquejobs isn't running, esx_drugs keeps working exactly
-- as before -- it just skips the extra logging/records.
Config.UniqueJobs = {
	-- When DOA collects an evidence case (esx_drugs:collectEvidence), also file a criminal
	-- record (exports['esx_uniquejobs']:LogCriminalRecord) against the top suspect, on top of
	-- the DOJ case that already gets created.
	LogCriminalRecord = true,

	-- When DOA seizes an active delivery's cargo (esx_drugs:seizeDelivery), also log it to
	-- esx_uniquejobs' DOA seizure ledger (exports['esx_uniquejobs']:LogSeizure) instead of only
	-- a Discord line, so it shows up in the /doj DOA seizures list.
	LogSeizures = true,

	-- Minimum number of on-duty DOA officers online before a delivery mission can be requested.
	-- 0 disables this requirement. Checked the same way Config.RequiredCops* already is.
	Delivery = {
		RequireDOA    = 1,
	},

	-- Convoy event (Config.Convoy above)
	Convoy = {
		AnnounceToDOA = true, -- send an in-game department-chat message to DOA when a convoy spawns/stops (exports['esx_uniquejobs']:SendDeptMessage)
	},
}

-- Cash/reward scaling by ESX job grade (xPlayer.job.grade) for DOA-side payouts. Doesn't require
-- esx_uniquejobs at all (job.grade is core ESX) -- kept alongside Config.UniqueJobs since it's
-- part of the same "make DOA work feel tied to rank/department" pass.
Config.GradeBonus = {
	Enabled          = true,
	PerGradePercent  = 5,   -- +5% to Evidence.CollectReward and delivery-seizure cash bonus per job grade level
	Max              = 50,  -- hard cap on the total % bonus regardless of grade
	SeizureCashBase  = 5000, -- base cash paid to the officer for a successful delivery seizure (0 = no direct cash, only the ledger entry)
}

-- One permanent DOA "field investigator" ped per farm zone (Config.FieldZones), standing just
-- off to the side. Regular players can target it but it has no options for them; DOA officers
-- get a collect-evidence option here whenever that field has an open case.
-- `offset` is added to the matching Config.FieldZones[key].coords -- adjust per-field if the
-- ped ends up inside a bush/rock/fence for your map.
Config.EvidencePeds = {
	WeedField      = { model = 's_m_y_ranger_01', offset = vector3(3.0, 3.0, 0.0), heading = 0.0 },
	CocaineField   = { model = 's_m_y_ranger_01', offset = vector3(3.0, 3.0, 0.0), heading = 0.0 },
	EphedrineField = { model = 's_m_y_ranger_01', offset = vector3(3.0, 3.0, 0.0), heading = 0.0 },
	PoppyField     = { model = 's_m_y_ranger_01', offset = vector3(3.0, 3.0, 0.0), heading = 0.0 },
	MushroomField  = { model = 's_m_y_ranger_01', offset = vector3(3.0, 3.0, 0.0), heading = 0.0 },
}

-- Priority assigned to the DOJ case esx_uniquejobs files when DOA refers a collected evidence
-- site to CID (exports['esx_uniquejobs']:CreateExternalCase). Keyed by the drugLabel passed into
-- ReportEvidence() for each field (server/main.lua). Anything not listed here defaults to
-- 'medium'. Valid values: 'low', 'medium', 'high' (whatever esx_uniquejobs' PRIORITY_LABELS
-- accepts -- unrecognized values fall back to 'medium' on that side too).
Config.CasePriority = {
	['Shah Dane']    = 'low',    -- weed
	['Mashroom']     = 'low',
	['Giahe Coca']   = 'medium', -- cocaine plant
	['Ephedra']      = 'medium',
	['Khash-Khaash'] = 'high',   -- poppy -> opium -> heroine chain
}

Config.Locale = 'en'

Config.Delays = {
	WeedProcessing = 1000 * 10,
	CocaineProcessing = 2000 * 10,
	EphedrineProcessing = 2000 * 10,
	MethProcessing = 2000 * 10,
	PoppyProcessing = 2000 * 10,
	CrackProcessing = 2000 * 10,
	HeroineProcessing = 1000 * 10,
	MushroomProcessing = 2000 * 10,
}

Config.FieldZones = {
	WeedField = {coords = vector3(2224.2, 5566.53, 54.06), name = 'Zamin Shah Dane',color = 25, sprite = 496, radius = 1.0},
	CocaineField = {coords = vector3(1849.8, 4914.2, 44.92), name = 'Zamin Cocaine' ,color = 4, sprite = 496, radius = 1.0},
	EphedrineField = {coords = vector3(1591.18, -1982.81, 95.12), name = 'Zamin Ephedrine',color = 62, sprite = 496, radius = 1.0},
	PoppyField = {coords = vector3(-1800.83, 1990.43, 132.71), name = 'Zamin Khash-Khaash',color = 38, sprite = 496, radius = 1.0},
	MushroomField = {coords = vector3(33.88, 4347.98, 41.62), name = 'Zamin Mushroom' ,color = 4, sprite = 496, radius = 1.0},
}

Config.ProcessZones = {
	WeedProcessing = {coords = vector3(2329.02, 2571.29, 46.68), name = 'Laboratory Marijuana', color = 25, sprite = 496, radius = 1.0},
	CocaineProcessing = {coords = vector3(-2083.58, -1011.96, 5.88), name = 'Laboratory Cocaine', color = 4, sprite = 455, radius = 1.0},
	EphedrineProcessing = {coords = vector3(-1078.62, -1679.62, 4.58), name = 'Laboratory Ephedrine', color = 62, sprite = 310, radius = 1.0},
	MethProcessing = {coords = vector3(1391.94, 3605.94, 38.94), name = 'Laboratory Shishe', color = 25, sprite = 93, radius = 1.0},
	CrackProcessing = {coords = vector3(974.72, -100.91, 74.87), name = 'Laboratory Crack', color = 72, sprite = 226, radius = 1.0},
	PoppyProcessing ={coords = vector3(3559.76, 3674.54, 28.12), name = 'Laboratory Teryak', color = 38, sprite = 499, radius = 1.0},
	HeroineProcessing = {coords = vector3(1789.671, 3896.110, 34.389), name = 'Laboratory Heroine', color = 59, sprite = 388, radius = 1.0},
}

Config.Peds = {
	WeedProcess =		{ ped = -264140789, x = 2328.29, y = 2569.61,	z = 45.68, 	h = 325.04 },
	CokeProcess =		{ ped = -264140789, x = -2084.48, y = -1011.68,	z = 4.88,	h = 252.42 },
	EphedrineProcess =	{ ped = 516505552, x = -1079.49, y = -1679.92,	z = 3.58,	h = 181.96 },
	MethProcess =		{ ped = 516505552, x = 1391.83, y = 3606.03,	z = 37.94,	h = 120.83 },
	OpiumProcess =		{ ped = -730659924, x = 3559.03, y = 3674.78,	z = 27.12,	h = 224.32 },
	CrackProcess =		{ ped = -264140789, x = 973.68, y = -100.35,	z = 73.85,	h = 277.73 },
}

Config.MarkerSize   = {x = 2.5, y = 2.5, z = 1.0}

Config.Locations = {
	{ x = -2083.25, y = -1012.14, z = 5.0},
	{ x = -2084.32, y = -1013.68, z = 5.0},
	{ x = 2329.02, y = 2571.29, z = 45.75},
	{ x = -1078.62, y = -1679.62, z = 3.60},
	{ x = 3559.76, y = 3674.54, z = 27.20},
	{ x = 1789.823, y = 3896.140, z = 33.389},
	{ x = 1391.94, y = 3605.94, z = 38.00}

}

Config.Zones = {}

Config.CircleZones = {
	DrugDealer = {coords = vector3(-1221.33, -1487.33, 3.37), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 15.0},
}

for i=1, #Config.Locations, 1 do
	Config.Zones['drug_' .. i] = {
		Pos   = Config.Locations[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
