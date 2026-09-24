-- ============================================================
-- Job Watch (oversight) -- black market ("the fence")
-- A standing temptation for the six watched jobs: sell job items
-- off the books for more money than the legal (market-adjusted)
-- price, but with no tax and a real, growing chance of getting
-- flagged to marshal/judge. Availability cycles on a random
-- open/closed timer so it's never a guaranteed income source.
--
-- Sells items straight out of the player's own ESX inventory
-- (xPlayer.getInventoryItem / removeInventoryItem), which the
-- server already tracks authoritatively -- unlike the mining trunk
-- (see the SECURITY NOTE in esx_jobs/server/jobs/minerjob.lua),
-- there is no missing third-party resource in the way here, so this
-- one can and does fully verify the count server-side before paying.
-- ============================================================

local Cfg = Config_oversight

local Heat = {}          -- Heat[identifier] = 0..100, memory-only (like a wanted level -- resets on restart)
local IsOpen = false

local function jobLabel(jobKey)
	return (Cfg.Watched[jobKey] and Cfg.Watched[jobKey].label) or tostring(jobKey)
end

local function GetHeat(identifier)
	return Heat[identifier] or 0
end
Ov.GetBlackMarketHeat = GetHeat

local function AddHeat(identifier, amount)
	local h = math.max(0, math.min(Cfg.BlackMarket.HeatCap, GetHeat(identifier) + amount))
	Heat[identifier] = h
	return h
end

-- heat slowly cools off for everyone, whether they're online or not
CreateThread(function()
	while true do
		Wait(60000)
		for identifier, h in pairs(Heat) do
			local nh = h - Cfg.BlackMarket.HeatDecayPerMinute
			if nh <= 0 then Heat[identifier] = nil else Heat[identifier] = nh end
		end
	end
end)

-- open/closed cycle. Deliberately no player-facing announcement when
-- it flips -- workers only find out by actually finding him and
-- overseers only see it via the (out-of-character) Job Watch screen or
-- the Discord log, never a toast that would spoil the mystery.
local function randRange(a, b) return math.random(a * 60, b * 60) end

if Cfg.BlackMarket.Enabled then
	CreateThread(function()
		while true do
			IsOpen = true
			TriggerEvent('DiscordBot:ToDiscord', Cfg.LogCategory, 'JobWatchLog', '```css\n[ Black Market : OPEN ]\n```', 'user', true, nil, false)
			Wait(randRange(Cfg.BlackMarket.OpenMinMinutes, Cfg.BlackMarket.OpenMaxMinutes) * 1000)

			IsOpen = false
			TriggerEvent('DiscordBot:ToDiscord', Cfg.LogCategory, 'JobWatchLog', '```css\n[ Black Market : CLOSED ]\n```', 'user', true, nil, false)
			Wait(randRange(Cfg.BlackMarket.ClosedMinMinutes, Cfg.BlackMarket.ClosedMaxMinutes) * 1000)
		end
	end)
end

ESX.RegisterServerCallback('esx_uniquejobs:oversight:blackmarketList', function(source, cb)
	if not Cfg.BlackMarket.Enabled or not IsOpen then cb(nil) return end
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then cb(nil) return end

	local list = {}
	for itemName, jobKey in pairs(Cfg.Economy.SaleItems) do
		local invItem = xPlayer.getInventoryItem(itemName)
		if invItem and invItem.count and invItem.count > 0 then
			list[#list + 1] = { name = itemName, label = invItem.label, count = invItem.count, job = jobKey }
		end
	end
	cb(list)
end)

RegisterServerEvent('esx_uniquejobs:oversight:blackmarketSell')
AddEventHandler('esx_uniquejobs:oversight:blackmarketSell', function(itemName, amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not Cfg.BlackMarket.Enabled then return end
	if Ov.Throttle(src, 'blackmarket', 3) then return end

	if not IsOpen then
		Ov.Notify(src, '~r~Kasi Javab Nemide... (Bazar Faalan Baste-ast)')
		return
	end

	local jobKey = Cfg.Economy.SaleItems[itemName]
	if not jobKey then return end -- not a job item -- not fenceable

	amount = tonumber(amount)
	if not amount or amount <= 0 or amount ~= math.floor(amount) then return end
	amount = math.min(amount, Cfg.BlackMarket.MaxSellPerCall)

	local invItem = xPlayer.getInventoryItem(itemName)
	if not invItem or not invItem.count or invItem.count < amount then
		Ov.Notify(src, '~r~In Meghdar Ra Nadarid')
		return
	end

	-- legal (market-adjusted) price as the baseline, then the fence's own
	-- bonus on top -- taxed nothing, gets no judge multiplier, it's off
	-- the books by definition. BasePrices mirrors ScriptPack's real
	-- per-item legal prices (see the config.lua comment on that table).
	local m = Ov.GetMods(jobKey)
	local legalUnitMult = m.mult * m.market * m.bonus * (1 - m.tax)
	local baseUnit = Cfg.BlackMarket.BasePrices[itemName] or 500
	local gross = math.floor(baseUnit * amount * legalUnitMult * Cfg.BlackMarket.BonusMult + 0.5)

	xPlayer.removeInventoryItem(itemName, amount)
	xPlayer.addMoney(gross)

	local heat = AddHeat(xPlayer.identifier, Cfg.BlackMarket.HeatPerSale)
	local chance = Cfg.BlackMarket.DetectionBaseChance + (Cfg.BlackMarket.DetectionMaxChance - Cfg.BlackMarket.DetectionBaseChance) * (heat / Cfg.BlackMarket.HeatCap)
	local detected = math.random() < chance

	Ov.Notify(src, '~g~$' .. gross .. ' Az Forushande-ye Siah Daryaft Kardid' .. (detected and ' ~r~(Ehsas Mikonid Kasi Motevajeh Shod...)' or ''))

	TriggerEvent('DiscordBot:ToDiscord', Cfg.LogCategory, 'JobWatchLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Event : BLACK MARKET SALE ]\n[ Item : '..amount..'x '..itemName..' ]\n[ Job : '..jobKey..' ]\n[ Gross : $'..gross..' ]\n[ Heat : '..math.floor(heat)..' ]\n[ Detected : '..tostring(detected)..' ]\n```', 'user', true, src, false)

	if detected then
		local ped = GetPlayerPed(src)
		local coords = (ped and ped ~= 0) and GetEntityCoords(ped) or vector3(0.0, 0.0, 0.0)
		local detail = Ov.Clean(amount .. 'x ' .. itemName .. ' -- Bedoon-e Maliat, Kharej Az Sistem-e Rasmi', 200)

		MySQL.Async.insert('INSERT INTO oversight_flags (identifier, name, job, kind, detail, x, y, z, status, created_at) VALUES (@i, @n, @j, @k, @d, @x, @y, @z, @st, @t)', {
			['@i'] = xPlayer.identifier, ['@n'] = xPlayer.name, ['@j'] = jobKey, ['@k'] = 'blackmarket', ['@d'] = detail,
			['@x'] = coords.x, ['@y'] = coords.y, ['@z'] = coords.z, ['@st'] = 'open', ['@t'] = os.time(),
		})

		for _, xOv in ipairs(Ov.GetOverseers('flags')) do
			TriggerClientEvent('esx_uniquejobs:oversight:alert', xOv.source, {
				kind = 'blackmarket', label = Ov.FlagLabels.blackmarket, name = xPlayer.name, id = src,
				job = jobKey, jobLabel = jobLabel(jobKey), detail = detail, x = coords.x, y = coords.y, z = coords.z,
			})
		end
	end
end)

-- ungated on purpose: any player standing next to the fence ped can see
-- whether he's open the same way they'd see it in-character (the ped's
-- own idle animation), so the client marker/scenario below just mirrors
-- that. The gated getBlackMarketStatus below stays judge/marshal-only
-- because IT'S the out-of-character staff screen (Ov.OpenBlackMarketInfo).
ESX.RegisterServerCallback('esx_uniquejobs:oversight:blackmarketIsOpen', function(source, cb)
	cb(IsOpen)
end)

ESX.RegisterServerCallback('esx_uniquejobs:oversight:getBlackMarketStatus', function(source, cb)
	if not Ov.Can(source, 'flags') then cb(nil) return end
	cb({ open = IsOpen })
end)
