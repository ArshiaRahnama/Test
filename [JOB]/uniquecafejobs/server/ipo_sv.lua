--[[
	Holding IPO - see shared/ipo.lua for the concept.
]]

local IPOState      = {} -- [holdingJob] = { offerPercent, pricePerShare, sharesSold }
local Shareholders   = {} -- [holdingJob] = { [identifier] = { shares = n, name = 'x' } }

CreateThread(function()
	for _, row in ipairs(MySQL.Sync.fetchAll('SELECT * FROM holding_ipo', {})) do
		IPOState[row.holding_job] = {
			offerPercent = row.offer_percent,
			pricePerShare = row.price_per_share,
			sharesSold = row.shares_sold,
		}
	end
	for _, row in ipairs(MySQL.Sync.fetchAll('SELECT * FROM holding_shares', {})) do
		Shareholders[row.holding_job] = Shareholders[row.holding_job] or {}
		Shareholders[row.holding_job][row.identifier] = { shares = row.shares, name = row.owner_name }
	end
end)

-- Called from server/corp_server.lua's collectFranchiseFee, right after a
-- holding's franchise-fee collection for this cycle is known in full.
function PayIPODividends(holdingJob, totalCollected)
	local ipo = IPOState[holdingJob]
	if not ipo or ipo.offerPercent <= 0 or ipo.sharesSold <= 0 then return end

	local dividendPool = math.floor(totalCollected * ipo.offerPercent / 100)
	if dividendPool <= 0 then return end

	local perShare = dividendPool / Config.IPO.TotalShares
	local holders = Shareholders[holdingJob] or {}

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holdingJob, function(hAccount)
		if not hAccount then return end
		local totalPaid = 0
		local holdingLabel = GetDisplayLabel(holdingJob, GetHoldingConfig(holdingJob) and GetHoldingConfig(holdingJob).Label or holdingJob)

		for identifier, holder in pairs(holders) do
			local amount = math.floor(perShare * holder.shares)
			if amount > 0 then
				totalPaid = totalPaid + amount
				local xTarget = ESX.GetPlayerFromIdentifier(identifier)
				if xTarget then
					xTarget.addBank(amount)
					TriggerClientEvent('esx:showNotification', xTarget.source, ('Dividend: +$%d from your %s shares.'):format(amount, holdingLabel))
				else
					MySQL.Async.execute('UPDATE users SET bank = bank + @amount WHERE identifier = @id', { ['@amount'] = amount, ['@id'] = identifier })
				end
			end
		end

		if totalPaid > 0 and totalPaid <= hAccount.money then
			hAccount.removeMoney(totalPaid)
		end
	end)
end

RegisterNetEvent('uniquecafejobs:ipo:requestInfo')
AddEventHandler('uniquecafejobs:ipo:requestInfo', function(holdingJob)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or not GetHoldingConfig(holdingJob) then return end

	local ipo = IPOState[holdingJob]
	local myShares = (Shareholders[holdingJob] and Shareholders[holdingJob][xPlayer.identifier] and Shareholders[holdingJob][xPlayer.identifier].shares) or 0
	local isBoss = xPlayer.job.name == holdingJob and xPlayer.job.grade_name == 'boss'

	TriggerClientEvent('uniquecafejobs:ipo:showInfo', src, {
		holdingJob = holdingJob,
		holdingLabel = GetDisplayLabel(holdingJob, GetHoldingConfig(holdingJob).Label),
		offerPercent = ipo and ipo.offerPercent or 0,
		pricePerShare = ipo and ipo.pricePerShare or 0,
		sharesSold = ipo and ipo.sharesSold or 0,
		totalShares = Config.IPO.TotalShares,
		myShares = myShares,
		isBoss = isBoss,
	})
end)

RegisterNetEvent('uniquecafejobs:ipo:launch')
AddEventHandler('uniquecafejobs:ipo:launch', function(holdingJob, offerPercent, pricePerShare)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= holdingJob or xPlayer.job.grade_name ~= 'boss' then return end

	local existing = IPOState[holdingJob]
	if existing and existing.sharesSold > 0 then
		TriggerClientEvent('esx:showNotification', src, 'Shares are already sold - terms are locked in for this IPO.')
		return
	end

	offerPercent = tonumber(offerPercent)
	pricePerShare = tonumber(pricePerShare)
	if not offerPercent or offerPercent <= 0 or offerPercent > Config.IPO.MaxOfferPercent or offerPercent ~= math.floor(offerPercent) then
		TriggerClientEvent('esx:showNotification', src, ('Offer percent must be 1-%d.'):format(Config.IPO.MaxOfferPercent))
		return
	end
	if not pricePerShare or pricePerShare < Config.IPO.MinSharePrice or pricePerShare ~= math.floor(pricePerShare) then
		TriggerClientEvent('esx:showNotification', src, ('Price per share must be at least $%d.'):format(Config.IPO.MinSharePrice))
		return
	end

	IPOState[holdingJob] = { offerPercent = offerPercent, pricePerShare = pricePerShare, sharesSold = 0 }
	MySQL.Async.execute('REPLACE INTO holding_ipo (holding_job, offer_percent, price_per_share, shares_sold) VALUES (@job, @pct, @price, 0)', {
		['@job'] = holdingJob, ['@pct'] = offerPercent, ['@price'] = pricePerShare,
	})
	TriggerClientEvent('esx:showNotification', src, ('IPO launched: %d%% of collections, $%d/share.'):format(offerPercent, pricePerShare))
end)

RegisterNetEvent('uniquecafejobs:ipo:buy')
AddEventHandler('uniquecafejobs:ipo:buy', function(holdingJob, shareCount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local ipo = IPOState[holdingJob]
	if not ipo or ipo.offerPercent <= 0 then
		TriggerClientEvent('esx:showNotification', src, 'This holding has no active IPO.')
		return
	end

	shareCount = tonumber(shareCount)
	if not shareCount or shareCount <= 0 or shareCount ~= math.floor(shareCount) then
		TriggerClientEvent('esx:showNotification', src, 'Invalid share count.')
		return
	end
	if ipo.sharesSold + shareCount > Config.IPO.TotalShares then
		TriggerClientEvent('esx:showNotification', src, ('Only %d shares left.'):format(Config.IPO.TotalShares - ipo.sharesSold))
		return
	end

	local cost = shareCount * ipo.pricePerShare
	local xMoney, xBank = xPlayer.money, xPlayer.bank
	if xMoney < cost and xBank < cost then
		TriggerClientEvent('esx:showNotification', src, 'Not enough money.')
		return
	end

	if xMoney >= cost then
		xPlayer.removeMoney(cost)
	else
		xPlayer.removeBank(cost)
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. holdingJob, function(hAccount)
		if hAccount then hAccount.addMoney(cost) end
	end)

	ipo.sharesSold = ipo.sharesSold + shareCount
	MySQL.Async.execute('UPDATE holding_ipo SET shares_sold = @sold WHERE holding_job = @job', { ['@sold'] = ipo.sharesSold, ['@job'] = holdingJob })

	Shareholders[holdingJob] = Shareholders[holdingJob] or {}
	local holder = Shareholders[holdingJob][xPlayer.identifier]
	if holder then
		holder.shares = holder.shares + shareCount
	else
		holder = { shares = shareCount, name = xPlayer.name }
		Shareholders[holdingJob][xPlayer.identifier] = holder
	end
	MySQL.Async.execute('REPLACE INTO holding_shares (holding_job, identifier, owner_name, shares) VALUES (@job, @id, @name, @shares)', {
		['@job'] = holdingJob, ['@id'] = xPlayer.identifier, ['@name'] = holder.name, ['@shares'] = holder.shares,
	})

	TriggerClientEvent('esx:showNotification', src, ('Bought %d shares of %s for $%d.'):format(shareCount, GetDisplayLabel(holdingJob, GetHoldingConfig(holdingJob).Label), cost))
end)
