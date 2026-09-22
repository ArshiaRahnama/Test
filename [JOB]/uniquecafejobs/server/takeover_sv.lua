--[[
	Holding Takeover War - see shared/takeover.lua for the concept.

	Ownership override layer
	-------------------------
	`GetBusinessHolding(cafe)` is now THE way to read who owns a business -
	every spot in server/corp_server.lua and client/corp_client.lua that used
	to read `cafe.Holding` directly has been changed to call this instead
	(client-side via a small synced cache, see below), so a completed
	takeover actually takes effect everywhere without a resource restart.
]]

local HoldingOverride = {}   -- [businessJob] = holdingJob (only set once a takeover has happened)
local WeeklySales     = {}   -- [businessJob] = number, reset every takeover cycle
local ActiveAuctions  = {}   -- [businessJob] = { openedAt, closesAt, sellerHolding, highestBid, highestBidder }
local lastTakeoverRun = 0

function GetBusinessHolding(cafe)
	return HoldingOverride[cafe.Job] or cafe.Holding
end

-- Called from server/crafting_sv.lua every time a craft's tax is credited to
-- a business - that credit IS this business's tracked "sales" for Takeover
-- War purposes. Reusing an existing money event instead of inventing a
-- separate NPC-customer-sale system.
function RecordSale(businessJob, amount)
	if not amount or amount <= 0 then return end
	WeeklySales[businessJob] = (WeeklySales[businessJob] or 0) + amount
	MySQL.Async.execute('REPLACE INTO takeover_weekly_sales (business_job, week_total) VALUES (@job, @total)', {
		['@job'] = businessJob, ['@total'] = WeeklySales[businessJob],
	})
end

local function pushHoldingOverridesTo(playerSource)
	TriggerClientEvent('uniquecafejobs:takeover:syncHoldingOverrides', playerSource, HoldingOverride)
end

local function broadcastHoldingOverrides()
	for _, playerId in ipairs(GetPlayers()) do
		pushHoldingOverridesTo(tonumber(playerId))
	end
end

local function notifyAllHoldingPlayers(msg)
	for _, playerId in ipairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
		if xPlayer and GetHoldingConfig(xPlayer.job.name) then
			TriggerClientEvent('esx:showNotification', xPlayer.source, msg)
		end
	end
end

CreateThread(function()
	for _, row in ipairs(MySQL.Sync.fetchAll('SELECT * FROM business_holding_override', {})) do
		HoldingOverride[row.business_job] = row.holding_job
	end
	for _, row in ipairs(MySQL.Sync.fetchAll('SELECT * FROM takeover_weekly_sales', {})) do
		WeeklySales[row.business_job] = row.week_total
	end
	for _, row in ipairs(MySQL.Sync.fetchAll('SELECT * FROM takeover_auctions', {})) do
		ActiveAuctions[row.business_job] = {
			openedAt = row.opened_at, closesAt = row.closes_at,
			sellerHolding = row.seller_holding, highestBid = row.highest_bid,
			highestBidder = row.highest_bidder,
		}
	end

	local stateRows = MySQL.Sync.fetchAll('SELECT * FROM takeover_state WHERE id = 1', {})
	if stateRows[1] then
		lastTakeoverRun = stateRows[1].last_run_at
	else
		lastTakeoverRun = os.time()
		MySQL.Async.execute('REPLACE INTO takeover_state (id, last_run_at) VALUES (1, @t)', { ['@t'] = lastTakeoverRun })
	end
end)

-- ── Open a new cycle's auctions: weakest business of every Type that has 2+
-- businesses (see shared/takeover.lua for why solo Types are skipped) ──
local function openTakeoverAuctions()
	local byType = {}
	for _, cafe in pairs(Cafes) do
		byType[cafe.Type] = byType[cafe.Type] or {}
		table.insert(byType[cafe.Type], cafe)
	end

	local opened = {}
	for _, list in pairs(byType) do
		if #list >= 2 then
			local weakest = nil
			for _, cafe in ipairs(list) do
				local sales = WeeklySales[cafe.Job] or 0
				if not weakest or sales < (WeeklySales[weakest.Job] or 0) then
					weakest = cafe
				end
			end
			if weakest and not ActiveAuctions[weakest.Job] then
				local now = os.time()
				local auction = {
					openedAt = now,
					closesAt = now + (Config.Takeover.BidWindowMinutes * 60),
					sellerHolding = GetBusinessHolding(weakest),
					highestBid = 0,
					highestBidder = nil,
				}
				ActiveAuctions[weakest.Job] = auction
				MySQL.Async.execute('REPLACE INTO takeover_auctions (business_job, opened_at, closes_at, seller_holding, highest_bid, highest_bidder) VALUES (@job, @opened, @closes, @seller, 0, NULL)', {
					['@job'] = weakest.Job, ['@opened'] = auction.openedAt, ['@closes'] = auction.closesAt, ['@seller'] = auction.sellerHolding,
				})
				table.insert(opened, weakest)
			end
		end
	end

	-- new cycle: everyone's weekly sales counter resets, weak or not
	for job in pairs(WeeklySales) do
		WeeklySales[job] = 0
		MySQL.Async.execute('REPLACE INTO takeover_weekly_sales (business_job, week_total) VALUES (@job, 0)', { ['@job'] = job })
	end

	if #opened > 0 then
		local names = {}
		for _, cafe in ipairs(opened) do
			table.insert(names, GetDisplayLabel(cafe.Job, cafe.Label))
		end
		notifyAllHoldingPlayers(('Takeover War: up for auction this cycle - %s'):format(table.concat(names, ', ')))
	end
end

-- ── Close any auction whose bid window has run out ──
local function closeExpiredAuctions()
	for businessJob, auction in pairs(ActiveAuctions) do
		if os.time() >= auction.closesAt then
			local cafe = GetCafeForJob(businessJob)
			if not cafe then
				ActiveAuctions[businessJob] = nil
			elseif not auction.highestBidder then
				notifyAllHoldingPlayers(('Takeover War: no bids on %s - %s keeps it.'):format(
					GetDisplayLabel(businessJob, cafe.Label), GetDisplayLabel(auction.sellerHolding, GetHoldingConfig(auction.sellerHolding) and GetHoldingConfig(auction.sellerHolding).Label or auction.sellerHolding)))
				ActiveAuctions[businessJob] = nil
				MySQL.Async.execute('DELETE FROM takeover_auctions WHERE business_job = @job', { ['@job'] = businessJob })
			else
				-- Re-verify the winner can still actually afford it - money
				-- may have been spent elsewhere since the bid was placed.
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. auction.highestBidder, function(buyerAccount)
					local winnerLabel = GetDisplayLabel(auction.highestBidder, GetHoldingConfig(auction.highestBidder) and GetHoldingConfig(auction.highestBidder).Label or auction.highestBidder)
					local sellerLabel = GetDisplayLabel(auction.sellerHolding, GetHoldingConfig(auction.sellerHolding) and GetHoldingConfig(auction.sellerHolding).Label or auction.sellerHolding)
					local businessLabel = GetDisplayLabel(businessJob, cafe.Label)

					if not buyerAccount or buyerAccount.money < auction.highestBid then
						notifyAllHoldingPlayers(('Takeover War: %s could not cover its winning bid on %s - auction voided, %s keeps it.'):format(winnerLabel, businessLabel, sellerLabel))
						ActiveAuctions[businessJob] = nil
						MySQL.Async.execute('DELETE FROM takeover_auctions WHERE business_job = @job', { ['@job'] = businessJob })
						return
					end

					buyerAccount.removeMoney(auction.highestBid)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. auction.sellerHolding, function(sellerAccount)
						if sellerAccount then sellerAccount.addMoney(auction.highestBid) end
					end)

					HoldingOverride[businessJob] = auction.highestBidder
					MySQL.Async.execute('REPLACE INTO business_holding_override (business_job, holding_job) VALUES (@job, @holding)', {
						['@job'] = businessJob, ['@holding'] = auction.highestBidder,
					})

					notifyAllHoldingPlayers(('Takeover War: %s won %s from %s for $%d!'):format(winnerLabel, businessLabel, sellerLabel, auction.highestBid))
					broadcastHoldingOverrides()

					ActiveAuctions[businessJob] = nil
					MySQL.Async.execute('DELETE FROM takeover_auctions WHERE business_job = @job', { ['@job'] = businessJob })
				end)
			end
		end
	end
end

-- One thread handles both the monthly open-cycle and the (much more
-- frequent) per-auction close check. Real-world minutes, not game time.
CreateThread(function()
	while true do
		Citizen.Wait(5 * 60 * 1000) -- every 5 real minutes
		if os.time() - lastTakeoverRun >= (Config.Takeover.IntervalDays * 86400) then
			lastTakeoverRun = os.time()
			MySQL.Async.execute('REPLACE INTO takeover_state (id, last_run_at) VALUES (1, @t)', { ['@t'] = lastTakeoverRun })
			openTakeoverAuctions()
		end
		closeExpiredAuctions()
	end
end)

RegisterNetEvent('uniquecafejobs:takeover:requestSync')
AddEventHandler('uniquecafejobs:takeover:requestSync', function()
	pushHoldingOverridesTo(source)
end)

RegisterNetEvent('uniquecafejobs:takeover:requestAuctions')
AddEventHandler('uniquecafejobs:takeover:requestAuctions', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end

	local rows = {}
	for businessJob, auction in pairs(ActiveAuctions) do
		local cafe = GetCafeForJob(businessJob)
		if cafe then
			table.insert(rows, {
				job = businessJob,
				label = GetDisplayLabel(businessJob, cafe.Label),
				sellerLabel = GetDisplayLabel(auction.sellerHolding, GetHoldingConfig(auction.sellerHolding) and GetHoldingConfig(auction.sellerHolding).Label or auction.sellerHolding),
				highestBid = auction.highestBid,
				canBid = auction.sellerHolding ~= holding.Job,
				secondsLeft = math.max(0, auction.closesAt - os.time()),
			})
		end
	end
	table.sort(rows, function(a, b) return a.label < b.label end)
	TriggerClientEvent('uniquecafejobs:takeover:showAuctions', src, rows)
end)

RegisterNetEvent('uniquecafejobs:takeover:placeBid')
AddEventHandler('uniquecafejobs:takeover:placeBid', function(businessJob, bidAmount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local holding = xPlayer and GetHoldingConfig(xPlayer.job.name)
	if not holding then return end
	if xPlayer.job.grade < 5 then
		TriggerClientEvent('esx:showNotification', src, 'Director rank or higher required.')
		return
	end

	local auction = ActiveAuctions[businessJob]
	if not auction then
		TriggerClientEvent('esx:showNotification', src, 'That auction is no longer open.')
		return
	end
	if auction.sellerHolding == holding.Job then
		TriggerClientEvent('esx:showNotification', src, 'You cannot bid on your own business.')
		return
	end
	if os.time() >= auction.closesAt then
		TriggerClientEvent('esx:showNotification', src, 'Bidding has closed on that business.')
		return
	end

	bidAmount = tonumber(bidAmount)
	local minValid = math.max(Config.Takeover.MinBid, auction.highestBid + Config.Takeover.MinBidIncrement)
	if not bidAmount or bidAmount < minValid or bidAmount ~= math.floor(bidAmount) then
		TriggerClientEvent('esx:showNotification', src, ('Minimum bid is $%d.'):format(minValid))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holding.Job, function(account)
		if not account or account.money < bidAmount then
			TriggerClientEvent('esx:showNotification', src, ('%s society balance is too low for that bid.'):format(holding.Label))
			return
		end

		auction.highestBid = bidAmount
		auction.highestBidder = holding.Job
		MySQL.Async.execute('UPDATE takeover_auctions SET highest_bid = @bid, highest_bidder = @holding WHERE business_job = @job', {
			['@bid'] = bidAmount, ['@holding'] = holding.Job, ['@job'] = businessJob,
		})
		TriggerClientEvent('esx:showNotification', src, ('Bid placed: $%d on %s.'):format(bidAmount, GetDisplayLabel(businessJob, GetCafeForJob(businessJob).Label)))
	end)
end)

-- Admin-only testing aid: /forcetakeover skips straight to opening a cycle
-- without waiting IntervalDays. Uses the same permission_level check pattern
-- already used for the 'th2' admin command in server/items.lua.
RegisterCommand('forcetakeover', function(source)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if not xPlayer or xPlayer.permission_level < 1 then
			TriggerClientEvent('esx:showNotification', source, 'No permission.')
			return
		end
	end
	openTakeoverAuctions()
end, true)
