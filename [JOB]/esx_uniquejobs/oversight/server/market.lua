-- ============================================================
-- Job Watch (oversight) -- live market
-- A rolling per-job "supply pressure" built from real sales
-- (Ov.RecordActivity feeds this via Ov.MarketFeed -- see the call
-- site in core.lua). Heavy selling pushes that job's price down for
-- a while; an idle job drifts back to 1.0x on its own. A job listed
-- in Config_oversight.SupplyChain also picks up part of its
-- supplier's pressure, so lumberjack flooding the market with wood
-- nudges tailor's prices UP (materials feel scarce) even though
-- tailor's own sales haven't moved. This result STACKS with the
-- judge's manual Eghtesad multiplier in server/core.lua's Payout --
-- it never overrides it.
--
-- Pure price simulation: no item, inventory, or recipe changes
-- anywhere. Safe to disable (Config_oversight.Market.Enabled =
-- false) without touching anything else in this module.
-- ============================================================

local Cfg = Config_oversight

-- Pressure[job] = { {ts, qty}, ... } -- raw sale events in the window
-- MarketMult[job] = current price multiplier (what GetMods reads)
-- History[job] = { {ts, mult}, ... } -- short trail for the ticker's trend arrow
local Pressure, MarketMult, History = {}, {}, {}

for jobKey in pairs(Cfg.Watched) do
	MarketMult[jobKey] = 1.0
	Pressure[jobKey] = {}
	History[jobKey] = {}
end

-- called from Ov.RecordActivity (core.lua) on every production/sale tick
function Ov.MarketFeed(jobKey, qty)
	if not Cfg.Market.Enabled or not Cfg.Watched[jobKey] then return end
	qty = tonumber(qty) or 0
	if qty <= 0 then return end
	local list = Pressure[jobKey]
	if not list then list = {}; Pressure[jobKey] = list end
	list[#list + 1] = { os.time(), qty }
end

local function windowSum(jobKey)
	local list = Pressure[jobKey]
	if not list then return 0 end
	local cutoff = os.time() - Cfg.Market.WindowMinutes * 60
	local kept, sum = {}, 0
	for _, e in ipairs(list) do
		if e[1] >= cutoff then
			kept[#kept + 1] = e
			sum = sum + e[2]
		end
	end
	Pressure[jobKey] = kept
	return sum
end

local function clamp(v, lo, hi)
	if v < lo then return lo end
	if v > hi then return hi end
	return v
end

local function recompute()
	local swing = Cfg.Market.MaxSwing
	local ownPressure = {}

	-- pass 1: each job's own supply pressure (independent of the others)
	for jobKey in pairs(Cfg.Watched) do
		local sold = windowSum(jobKey)
		ownPressure[jobKey] = clamp(sold * Cfg.Market.PressurePerUnit, 0, swing)
	end

	-- pass 2: supply-chain ripple -- a consuming job's price is nudged
	-- UP by part of its supplier(s)' own pressure (scarcity), on top of
	-- its own oversupply-driven pressure DOWN.
	for jobKey in pairs(Cfg.Watched) do
		local target = 1.0 - ownPressure[jobKey]
		local suppliers = Cfg.SupplyChain[jobKey]
		if suppliers then
			local scarcity = 0
			for _, supplierJob in ipairs(suppliers) do
				scarcity = scarcity + (ownPressure[supplierJob] or 0)
			end
			target = target + scarcity * Cfg.SupplyChainStrength
		end
		target = clamp(target, 1.0 - swing, 1.0 + swing)

		-- ease current mult toward target rather than snapping, so the
		-- ticker feels like a market and not a light switch
		local current = MarketMult[jobKey] or 1.0
		local step = Cfg.Market.RecoveryPerTick
		if current < target then current = math.min(target, current + step)
		elseif current > target then current = math.max(target, current - step) end
		MarketMult[jobKey] = current

		local hist = History[jobKey]
		hist[#hist + 1] = { os.time(), current }
		local cutoff = os.time() - 3600
		local kept = {}
		for _, e in ipairs(hist) do
			if e[1] >= cutoff then kept[#kept + 1] = e end
		end
		History[jobKey] = kept
	end
end

function Ov.GetMarketMult(jobKey)
	if not Cfg.Market.Enabled then return 1.0 end
	return MarketMult[jobKey] or 1.0
end

-- trend = current mult vs. mult ~15 minutes ago, for the ticker's arrow
local function trendFor(jobKey)
	local hist = History[jobKey]
	local current = MarketMult[jobKey] or 1.0
	if not hist or #hist == 0 then return 0 end
	local target = os.time() - 900
	local past = current
	for _, e in ipairs(hist) do
		if e[1] <= target then past = e[2] end
	end
	return current - past
end

if Cfg.Market.Enabled then
	CreateThread(function()
		while true do
			Wait(Cfg.Market.TickSeconds * 1000)
			local ok, err = pcall(recompute)
			if not ok then print('[esx_uniquejobs] Job Watch market tick error: ' .. tostring(err)) end
		end
	end)
end

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getMarket', function(source, cb)
	if not Ov.Can(source, 'dashboard') then cb(nil) return end
	local out = {}
	for _, jobKey in ipairs(Cfg.JobOrder) do
		local suppliers = Cfg.SupplyChain[jobKey]
		local supplierLabels = nil
		if suppliers then
			supplierLabels = {}
			for _, s in ipairs(suppliers) do
				supplierLabels[#supplierLabels + 1] = (Cfg.Watched[s] and Cfg.Watched[s].label) or s
			end
		end
		out[#out + 1] = {
			job = jobKey, label = Cfg.Watched[jobKey].label,
			mult = Ov.GetMarketMult(jobKey), trend = trendFor(jobKey),
			volume = windowSum(jobKey), suppliers = supplierLabels,
		}
	end
	cb({ jobs = out, windowMinutes = Cfg.Market.WindowMinutes })
end)
