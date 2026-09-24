-- ============================================================
-- Job Watch (oversight) -- shared config
-- Judge + Marshal oversight of the civilian jobs handled by
-- esx_jobs: fisherman, fueler, lumberjack, slaughterer, tailor
-- and miner. Loaded as a shared_script (client AND server).
--
-- `Ov` is the one shared namespace table for this module (helpers
-- that both sides use). Everything else stays local to its file so
-- nothing here can collide with the other ~90k lines of Lua that
-- share this resource's Lua state.
-- ============================================================

Config_oversight = {}
Ov = Ov or {}

Config_oversight.Command = 'jobwatch'        -- also reachable from /doj (judge/marshal)
Config_oversight.LogCategory = 'adminmenu'   -- DiscordBot:ToDiscord category (same one the tracker/uniform logs use)

-- Set to a number (e.g. 15) to let admins with that xPlayer.permission_level
-- open the menu with FULL judge-level perms for testing. nil = off.
Config_oversight.AdminPermissionLevel = nil

-- ------------------------------------------------------------
-- Who may oversee, and what each role may do.
-- perms:
--   dashboard  live roster, worker files, dashboard
--   spectate   FBI-style spectate of a worker
--   inspect    on-foot inspection (must be close to the worker)
--   warn / fine / suspend      disciplinary actions (limits below)
--   lift       lift an active suspension
--   permits / permit_revoke    issue / revoke work permits
--   economy    set per-job tax rate + price multiplier
--   events     double-pay hours + temporary job closures
--   bonus      pay the weekly top-worker bonus
--   complaints view + resolve worker complaints
--   flags      see + handle automatic anomaly flags
--   audit      see who spectated whom
--   blips      live worker blips on the map
--   cases      turn a flag/complaint into a /doj case
--   notes      add a note to a worker's file
--   announce   broadcast a message to everyone in a job
-- ------------------------------------------------------------
Config_oversight.Roles = {
	judge = {
		minGrade = 0,
		maxFine = 100000,
		maxSuspendHours = 24 * 30,
		perms = {
			dashboard = true, spectate = true, inspect = true, warn = true, fine = true,
			suspend = true, lift = true, permits = true, permit_revoke = true, economy = true,
			events = true, bonus = true, complaints = true, flags = true, audit = true,
			blips = true, cases = true, notes = true, announce = true,
		},
	},
	marshal = {
		minGrade = 0,
		maxFine = 20000,
		maxSuspendHours = 24,
		perms = {
			dashboard = true, spectate = true, inspect = true, warn = true, fine = true,
			suspend = true, permit_revoke = true, complaints = true, flags = true,
			blips = true, cases = true, notes = true, announce = true,
		},
	},
}

-- ------------------------------------------------------------
-- The jobs being watched.
--   label / colour   display + blip colour
--   permit           true = a judge-issued permit is required to work
--   openActivity     true = anyone may do it without holding the job
--                    (fishing works with just a rod)
--   maxEventsPerMin  more real work-ticks than this in 60s = 'rate' flag
--   maxIncome10Min   more sales income than this in 10 min = 'income' flag
--   items            items shown in an inspection / spectate info panel
--   stockpile        counts above this show as suspicious in an inspection
--
-- The thresholds are starting points, not gospel -- the fastest
-- legit work-tick in esx_jobs is 1000ms (60/min) so the four
-- zone jobs sit just above that. Tune from real /jobwatch data.
-- ------------------------------------------------------------
Config_oversight.Watched = {
	fisherman = {
		label = 'Fisherman', colour = 3, permit = false, openActivity = true,
		maxEventsPerMin = 4, maxIncome10Min = 400000,
		items = { 'mahigoli', 'ghezelala', 'hamoor', 'salomon', 'meygoo', 'jolbak', 'fishingrod' },
		stockpile = { mahigoli = 80, ghezelala = 80, hamoor = 80, salomon = 80, meygoo = 80 },
	},
	fueler = {
		label = 'Fueler', colour = 5, permit = false,
		maxEventsPerMin = 75, maxIncome10Min = 300000,
		items = { 'petrol', 'petrol_raffin', 'essence' },
		stockpile = { essence = 20 },
	},
	lumberjack = {
		label = 'Lumberjack', colour = 2, permit = false,
		maxEventsPerMin = 75, maxIncome10Min = 300000,
		items = { 'wood', 'cutted_wood', 'packaged_plank' },
		stockpile = { packaged_plank = 90 },
	},
	slaughterer = {
		label = 'Slaughterer', colour = 1, permit = false,
		maxEventsPerMin = 75, maxIncome10Min = 300000,
		items = { 'alive_chicken', 'slaughtered_chicken', 'packaged_chicken' },
		stockpile = { packaged_chicken = 90 },
	},
	tailor = {
		label = 'Tailor', colour = 27, permit = false,
		maxEventsPerMin = 75, maxIncome10Min = 300000,
		items = { 'wool', 'fabric', 'clothe' },
		stockpile = { clothe = 35 },
	},
	miner = {
		label = 'Miner', colour = 46, permit = false,
		maxEventsPerMin = 40, maxIncome10Min = 600000,
		items = { 'stone', 'washed_stone', 'stone_piece', 'iron_piece', 'gold_piece', 'copper', 'iron', 'gold', 'diamond' },
		stockpile = { gold = 15, iron = 30, diamond = 35, stone_piece = 250, iron_piece = 250, gold_piece = 250 },
	},
}

-- Display order everywhere (menus, dashboard)
Config_oversight.JobOrder = { 'fisherman', 'fueler', 'lumberjack', 'slaughterer', 'tailor', 'miner' }

-- ------------------------------------------------------------
-- Economy: judge-set tax + price multiplier per job, plus timed
-- events. Applied to the esx_jobs delivery payouts, mining sales,
-- and the ScriptPack item sellers (server/itemseller-sv.lua).
-- ------------------------------------------------------------
Config_oversight.Economy = {
	TaxAccount = 'society_doj',       -- where collected tax goes (same account the DOJ jobs already use)
	DefaultTaxRate = 0.0,
	MaxTaxRate = 0.30,
	MinPriceMult = 0.5,
	MaxPriceMult = 2.0,
	MaxEventMinutes = 120,
	MaxEventBonusMult = 3.0,
	-- item sold at a ScriptPack seller -> which watched job it belongs to
	SaleItems = {
		clothe = 'tailor', essence = 'fueler', packaged_plank = 'lumberjack', packaged_chicken = 'slaughterer',
		iron = 'miner', gold = 'miner', diamond = 'miner',
		mahigoli = 'fisherman', ghezelala = 'fisherman', hamoor = 'fisherman',
		salomon = 'fisherman', meygoo = 'fisherman', jolbak = 'fisherman',
	},
}

-- ------------------------------------------------------------
-- Live spectate (modelled on the FBI/CIA spectate in
-- client/agent_speact.lua: invisible ped + NetworkSetInSpectatorMode,
-- info panel, message the target, BACKSPACE to stop) -- plus the
-- things that spectate never had: streaming-safe start, follow loop,
-- return to where you were, time limit and a full audit trail.
-- ------------------------------------------------------------
Config_oversight.Spectate = {
	MaxMinutes = 20,               -- auto-stop (warns 60s before)
	CooldownSeconds = 3,           -- min gap between two spectate starts
	AllowAnyone = false,           -- false = only watched-job workers / recent off-job workers / flagged players
	CanSpectateOversight = false,  -- can a judge/marshal spectate another judge/marshal
	OffJobActivityWindow = 15 * 60,
	ShowFullInventory = false,     -- false = only the job's own items in the info panel
	NotifyTarget = false,          -- true = tell the worker they are being watched
	Hud = true,                    -- on-screen shift stats while spectating
}

Config_oversight.Inspect = { Distance = 8.0 }

Config_oversight.Permits = {
	DefaultDays = 7,
	MaxDays = 60,
	GraceIfNoOversightOnline = true,  -- permit rules pause while no judge/marshal is online
}

Config_oversight.Flags = {
	CooldownSeconds = 300,   -- same player + same kind is flagged at most once per this
	AutoCase = false,        -- true = every flag also opens a /doj case automatically
}

Config_oversight.Stats = {
	ShiftIdleSeconds = 600,  -- no work for this long = shift over
	FlushSeconds = 300,
	WorkingSeconds = 30,     -- last work within this = 'working' in the roster
}

Config_oversight.Bonus = { 5000, 3000, 1500 }   -- 1st / 2nd / 3rd of the 7-day leaderboard
Config_oversight.BonusPeriodDays = 7

Config_oversight.LogFinesToRapSheet = true      -- fines/suspensions also land in /doj Rap Sheet (criminal_records)

Config_oversight.BlipRefreshMs = 4000

-- ------------------------------------------------------------
-- Live market (dynamic pricing). Every legit sale nudges that job's
-- price down for a while (oversupply); the market drifts back to
-- 1.0x on its own if nobody's selling. This multiplier STACKS with
-- the judge's own manual Eghtesad multiplier (Ov.GetMods in
-- server/core.lua) -- the judge is no longer setting the only
-- price in town, they're negotiating against a live market.
-- ------------------------------------------------------------
Config_oversight.Market = {
	Enabled = true,
	WindowMinutes = 30,           -- rolling window used to measure how much has been sold
	TickSeconds = 60,             -- how often the market recomputes
	PressurePerUnit = 0.006,      -- each unit sold in the window pushes price down by this much (before clamping)
	MaxSwing = 0.35,              -- price can drift at most +/-35% from 1.0x on its own
	RecoveryPerTick = 0.04,       -- how fast an idle market drifts back toward 1.0x each tick
}

-- ------------------------------------------------------------
-- Supply chain (price-linked, not recipe-linked): a consuming job's
-- market price is nudged UP when its supplier job is under heavy
-- sale pressure (raw material getting scarce) and drifts back down
-- when the supplier is quiet. This does NOT touch esx_jobs' actual
-- production recipes/items -- it's a pure economic ripple effect,
-- so it's safe to turn on without risking the delivery/production
-- flow of either job. See CHANGES.md for why it's scoped this way.
-- ------------------------------------------------------------
Config_oversight.SupplyChain = {
	tailor = { 'lumberjack' },   -- fabric/thread gets pricier when wood is scarce (feels like looms/spindles)
	fueler = { 'miner' },        -- refining gets pricier when ore is scarce
}
Config_oversight.SupplyChainStrength = 0.5 -- 0..1: how much of the supplier's own pressure carries over

-- ------------------------------------------------------------
-- Black market (the "fence"). A physical ped (Ped below, ox_target
-- interaction, no command) buys job items for more than the legal
-- price, off the books -- no tax, no judge multiplier. Every sale
-- raises the seller's Heat; higher Heat means a higher chance the
-- sale gets flagged to marshal/judge (server/blackmarket.lua). He's
-- only open for business on a random cycle -- his own idle animation
-- and the marker above his head show which -- so it's never a
-- guaranteed income source, it's a standing temptation to go find.
-- ------------------------------------------------------------
Config_oversight.BlackMarket = {
	Enabled = true,
	BonusMult = 1.35,             -- pays 35% more than the current legal (market-adjusted) price
	HeatPerSale = 18,             -- 0-100 meter, per identifier, memory-only (resets on restart, like a wanted level)
	HeatCap = 100,
	HeatDecayPerMinute = 2.5,
	DetectionBaseChance = 0.12,   -- chance to get flagged at 0 heat
	DetectionMaxChance = 0.85,    -- chance to get flagged at max heat
	OpenMinMinutes = 15,
	OpenMaxMinutes = 35,
	ClosedMinMinutes = 10,
	ClosedMaxMinutes = 25,
	MaxSellPerCall = 40,
	-- Mirrors the real per-unit legal prices from
	-- ScriptPack/itemseller_config.lua for exactly the items listed in
	-- Config_oversight.Economy.SaleItems above, so the fence's prices
	-- feel like real prices-plus-a-cut rather than a flat made-up rate.
	-- ScriptPack is a separate resource with no price-lookup export, so
	-- this is a deliberate, documented duplication -- if those prices
	-- ever change, update both places.
	BasePrices = {
		clothe = 1500, essence = 300, packaged_plank = 1200, packaged_chicken = 200,
		iron = 12000, gold = 20000, diamond = 5000,
		mahigoli = 800, ghezelala = 1100, hamoor = 1000, salomon = 600, meygoo = 850, jolbak = 300,
	},
	-- A physical fence -- no command, find him and target him (ox_target,
	-- already a dependency of this resource). The Coords below are a
	-- generic, out-of-the-way vanilla-map spot (the open storm drain on
	-- Elysian Island) chosen specifically because it's unlikely to be
	-- built over by a custom MLO -- if it clips into something on your
	-- map, this is the one line to move.
	Ped = {
		Model = 's_m_y_dealer_01',           -- GTA's classic hoodie street-dealer ped
		Coords = vector4(1013.65, -3149.35, 5.90, 130.0),
		ScenarioOpen = 'WORLD_HUMAN_SMOKING',           -- relaxed -- he's open for business
		ScenarioClosed = 'WORLD_HUMAN_STAND_IMPATIENT', -- checking a watch, arms crossed -- not today
		MarkerDistance = 20.0,        -- the open/closed marker only renders this close (no map-wide spoiler)
		PollSeconds = 12,             -- how often nearby clients re-check open/closed
	},
}

-- Simple shared helper: role + grade check for a job name
function Ov.IsOversightJob(jobName)
	return Config_oversight.Roles[jobName] ~= nil
end
