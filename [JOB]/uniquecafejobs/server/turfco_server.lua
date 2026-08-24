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
			minutesLeft = r and math.ceil((r.expiresAt - os.time()) / 60) or nil,
		})
	end
	TriggerClientEvent('uniquecafejobs:turfco:showRentMenu', src, rows)
end)

RegisterNetEvent('uniquecafejobs:turfco:rentMap')
AddEventHandler('uniquecafejobs:turfco:rentMap', function(mapName, gangName, minutes)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer or xPlayer.job.name ~= TurfCo.Job then return end

	local validMap = false
	for _, m in ipairs(TurfCo.Maps) do if m == mapName then validMap = true end end
	if not validMap then return end

	if getReservation(mapName) then
		TriggerClientEvent('esx:showNotification', src, 'This map is already rented right now.')
		return
	end

	minutes = tonumber(minutes)
	if not minutes or minutes <= 0 or minutes > TurfCo.MaxRentMinutes then
		TriggerClientEvent('esx:showNotification', src, ('Minutes must be between 1 and %d.'):format(TurfCo.MaxRentMinutes))
		return
	end

	gangName = tostring(gangName):lower():gsub("%s+", "")
	if gangName == '' then
		TriggerClientEvent('esx:showNotification', src, 'Invalid gang name.')
		return
	end

	if GetResourceState('Unique_Gangs') ~= 'started' then
		TriggerClientEvent('esx:showNotification', src, 'Gang account system is not available right now.')
		return
	end

	local cost = minutes * TurfCo.RentCostPerMinute

	TriggerEvent('gangaccount:getGangAccount', gangName, function(gangAccount)
		if not gangAccount then
			TriggerClientEvent('esx:showNotification', src, 'No gang with that name.')
			return
		end
		if gangAccount.money < cost then
			TriggerClientEvent('esx:showNotification', src, ('Gang needs $%d to rent %d minutes.'):format(cost, minutes))
			return
		end

		gangAccount.removeMoney(cost)
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. TurfCo.Job, function(account)
			account.addMoney(cost)
		end)

		Reservations[mapName] = { gang = gangName, expiresAt = os.time() + (minutes * 60) }
		TriggerClientEvent('esx:showNotification', src, ('%s map rented to %s for %d minutes. They can host paintball lobbies there now - nobody else can.'):format(mapName, gangName, minutes))
	end)
end)
