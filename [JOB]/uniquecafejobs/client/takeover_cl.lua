--[[
	Client half of Holding Takeover War - see shared/takeover.lua.

	HoldingOverrides is a small synced cache: [businessJob] = holdingJob,
	only containing entries that have actually changed hands via a takeover.
	Anywhere in the client that used to read cafe.Holding directly should
	read `HoldingOverrides[cafe.Job] or cafe.Holding` instead (already fixed
	in client/corp_client.lua's Boss Action proximity loop).
]]

HoldingOverrides = {}

CreateThread(function()
	while PlayerData == nil do
		Citizen.Wait(200)
	end
	TriggerServerEvent('uniquecafejobs:takeover:requestSync')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function()
	TriggerServerEvent('uniquecafejobs:takeover:requestSync')
end)

RegisterNetEvent('uniquecafejobs:takeover:syncHoldingOverrides')
AddEventHandler('uniquecafejobs:takeover:syncHoldingOverrides', function(overrides)
	HoldingOverrides = overrides or {}
end)

RegisterNetEvent('uniquecafejobs:takeover:showAuctions')
AddEventHandler('uniquecafejobs:takeover:showAuctions', function(rows)
	local elements = {}
	for _, row in ipairs(rows) do
		local mins = math.floor(row.secondsLeft / 60)
		local bidText = row.highestBid > 0 and ('$%d'):format(row.highestBid) or 'no bids yet'
		local label = ('%s (owned by %s) - %s - %dm left'):format(row.label, row.sellerLabel, bidText, mins)
		table.insert(elements, {
			label = row.canBid and label or (label .. ' [your own business]'),
			value = row.job,
			disabled = not row.canBid,
		})
	end
	if #elements == 0 then
		table.insert(elements, { label = 'No auctions open right now', value = 'noop', disabled = true })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'takeover_auctions', {
		title    = 'Takeover War - Active Auctions',
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		if data.current.value == 'noop' then return end
		local input = lib.inputDialog('Place Bid', {
			{ type = 'number', label = 'Bid amount ($)', default = 20000 },
		})
		if input and input[1] then
			TriggerServerEvent('uniquecafejobs:takeover:placeBid', data.current.value, tonumber(input[1]))
		end
	end, function(data, menu)
		menu.close()
	end)
end)
