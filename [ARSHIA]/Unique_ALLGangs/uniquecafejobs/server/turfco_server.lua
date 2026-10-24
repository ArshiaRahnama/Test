--[[
	Server side for Turf Wars Inc. Reservation state lives here; the actual
	paintball MATCH is entirely handled by the existing [ARSHIA]/paintball
	resource - this just gates who's allowed to host a lobby on a reserved
	map, via an export that resource calls from its own CreateLobby.
]]

TriggerEvent('esx_society:registerSociety', TurfCo.Job, TurfCo.Label, 'society_' .. TurfCo.Job, 'society_' .. TurfCo.Job, 'society_' .. TurfCo.Job, { type = 'public' })

-- mapName -> { gang = 'thegangname', expiresAt = os.time() }
local Reservations = {}

local function getReservation(mapName)
	local r = Reservations[mapName]
	if r and os.time() < r.expiresAt then
		return r
	end
	Reservations[mapName] = nil
	return nil
end

-- Called by [ARSHIA]/paintball's server.lua (see the 2-line patch in its
-- CreateLobby function) before letting anyone host a lobby on a map.
-- Returns nil if the map is free, or the reserving gang's name if not.
exports('GetMapReservation', function(mapName)
	local r = getReservation(mapName)
	return r and r.gang or nil
end)

RegisterNetEvent('uniquecafejobs:turfco:spawnVehicle')
AddEventHandler('uniquecafejobs:turfco:spawnVehicle', function(vehicleName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if xPlayer.job.name == TurfCo.Job and vehicleName == TurfCo.SpawnVehicle then
		TriggerClientEvent('spawnCarClientTurfco', source, vehicleName)
	end
end)

RegisterNetEvent('uniquecafejobs:turfco:requestRentMenu')
AddEventHandler('uniquecafejobs:turfco:requestRentMenu', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= TurfCo.Job then return end

	local rows = {}
	for _, mapName in ipairs(TurfCo.Maps) do
		local r = getReservation(mapName)
		table.insert(rows, {
			map = mapName,
			rentedBy = r and r.gang or nil,
			daysLeft = r and math.ceil((r.expiresAt - os.time()) / 86400) or nil,
		})
	end
	TriggerClientEvent('uniquecafejobs:turfco:showRentMenu', src, rows)
end)

RegisterNetEvent('uniquecafejobs:turfco:requestMapInfo')
AddEventHandler('uniquecafejobs:turfco:requestMapInfo', function(mapName)
	local src = source
	local valid = false
	for _, m in ipairs(TurfCo.Maps) do if m == mapName then valid = true end end
	if not valid then return end
	local r = getReservation(mapName)
	TriggerClientEvent('uniquecafejobs:turfco:mapInfo', src, mapName,
		r and r.gang or nil, r and math.ceil((r.expiresAt - os.time()) / 86400) or 0)
end)

-- A Gang 2 staff member bills a customer standing within 10m. The customer pays
-- from their bank; the money goes to society_turfco; the map is reserved for the
-- gang name for TurfCo.RentDays days.
RegisterNetEvent('uniquecafejobs:turfco:rentMap')
AddEventHandler('uniquecafejobs:turfco:rentMap', function(mapName, gangName, customerId)
	local src = source
	local staff = ESX.GetPlayerFromId(src)
	local sg = staff and staff.gang and staff.gang.name
	local okB, isBoss = pcall(function() return IsGangBoss(src) end)
	if not staff or not (okB and isBoss and HoldingOwnerOf(TurfCo.Job) == sg) then return end

	local function notify(id, msg) TriggerClientEvent('esx:showNotification', id, msg) end

	local valid = false
	for _, m in ipairs(TurfCo.Maps) do if m == mapName then valid = true end end
	if not valid then return notify(src, 'This map cannot be rented.') end

	if getReservation(mapName) then return notify(src, 'This map is already rented right now.') end

	local cid = tonumber(customerId)
	local customer = cid and ESX.GetPlayerFromId(cid)
	if not customer then return notify(src, 'Customer is not online.') end

	local d = #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(cid)))
	if d > 10.0 then return notify(src, 'The customer must be within 10m of you.') end

	local gang = (tostring(gangName or ''):lower():gsub('%s+', ''))
	if gang == '' then return notify(src, 'Invalid gang name.') end

	local price = TurfCo.RentPrice
	if (getBankMoney(cid) or 0) < price then
		notify(src, 'Customer does not have $' .. price .. ' in the bank.')
		return notify(cid, 'You need $' .. price .. ' in your bank to rent a paintball map.')
	end

	removeBankMoney(cid, price)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. TurfCo.Job, function(account)
		if account then account.addMoney(price) end
	end)

	Reservations[mapName] = { gang = gang, expiresAt = os.time() + TurfCo.RentDays * 86400 }
	notify(cid, ('You paid $%d. %s is reserved for %s for %d days.'):format(price, mapName, gang, TurfCo.RentDays))
	notify(src, ('%s rented to %s for %d days. Customer charged $%d.'):format(mapName, gang, TurfCo.RentDays, price))
end)

exports('CanGangUseMap', function(mapName, gangName)
	local r = getReservation(mapName)
	if not r then return true end
	return r.gang == tostring(gangName or ''):lower():gsub('%s+', '')
end)
