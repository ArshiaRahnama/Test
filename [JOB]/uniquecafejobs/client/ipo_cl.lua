--[[
	Client half of Holding IPO - see shared/ipo.lua.

	Unlike everything else in this resource, "Investment Opportunities" is
	deliberately NOT job-gated (CreateOXTargetNotJob with businessJob = nil)
	- any player can walk up to a holding's HQ and buy shares, matching the
	feature's whole point (public shareholders, not just employees).
]]

CreateThread(function()
	for _, holding in ipairs({ Corp.Meridian, Corp.Blacktide, Corp.CrateCarry, TurfCo }) do
		CreateOXTargetNotJob(holding.HQ, 'Investment Opportunities (' .. holding.Label .. ')', 'uniquecafejobs:ipo:openMenuClient:' .. holding.Job, 'fas fa-chart-line', nil)
	end
end)

-- ox_target only lets us bind one static event name per option, so route
-- through a single handler that reads the holding job back off the event
-- name suffix instead of registering 4 nearly-identical handlers.
RegisterNetEvent('uniquecafejobs:ipo:openMenuClient:meridian')
AddEventHandler('uniquecafejobs:ipo:openMenuClient:meridian', function() TriggerServerEvent('uniquecafejobs:ipo:requestInfo', Corp.Meridian.Job) end)
RegisterNetEvent('uniquecafejobs:ipo:openMenuClient:blacktide')
AddEventHandler('uniquecafejobs:ipo:openMenuClient:blacktide', function() TriggerServerEvent('uniquecafejobs:ipo:requestInfo', Corp.Blacktide.Job) end)
RegisterNetEvent('uniquecafejobs:ipo:openMenuClient:cratecarry')
AddEventHandler('uniquecafejobs:ipo:openMenuClient:cratecarry', function() TriggerServerEvent('uniquecafejobs:ipo:requestInfo', Corp.CrateCarry.Job) end)
RegisterNetEvent('uniquecafejobs:ipo:openMenuClient:turfco')
AddEventHandler('uniquecafejobs:ipo:openMenuClient:turfco', function() TriggerServerEvent('uniquecafejobs:ipo:requestInfo', TurfCo.Job) end)

RegisterNetEvent('uniquecafejobs:ipo:showInfo')
AddEventHandler('uniquecafejobs:ipo:showInfo', function(info)
	local elements = {}

	if info.offerPercent > 0 then
		table.insert(elements, {
			label = ('%s IPO: %d%% of collections, $%d/share, %d/%d sold'):format(info.holdingLabel, info.offerPercent, info.pricePerShare, info.sharesSold, info.totalShares),
			value = 'info', disabled = true,
		})
		if info.sharesSold < info.totalShares then
			table.insert(elements, { label = 'Buy Shares', value = 'buy' })
		end
	else
		table.insert(elements, { label = 'No active IPO for ' .. info.holdingLabel, value = 'info', disabled = true })
	end

	table.insert(elements, { label = ('Your shares: %d'):format(info.myShares), value = 'info', disabled = true })

	if info.isBoss then
		table.insert(elements, { label = 'Launch / Edit IPO (Boss Only)', value = 'launch' })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ipo_menu', {
		title    = info.holdingLabel .. ' - Investment',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'buy' then
			local input = lib.inputDialog('Buy Shares', {
				{ type = 'number', label = ('Shares (max %d left)'):format(info.totalShares - info.sharesSold), default = 1 },
			})
			if input and input[1] then
				TriggerServerEvent('uniquecafejobs:ipo:buy', info.holdingJob, tonumber(input[1]))
			end
		elseif data.current.value == 'launch' then
			local input = lib.inputDialog('Launch IPO', {
				{ type = 'number', label = ('Offer percent (1-%d)'):format(Config.IPO.MaxOfferPercent), default = info.offerPercent > 0 and info.offerPercent or 10 },
				{ type = 'number', label = ('Price per share (min $%d)'):format(Config.IPO.MinSharePrice), default = info.pricePerShare > 0 and info.pricePerShare or Config.IPO.MinSharePrice },
			})
			if input and input[1] and input[2] then
				TriggerServerEvent('uniquecafejobs:ipo:launch', info.holdingJob, tonumber(input[1]), tonumber(input[2]))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end)
