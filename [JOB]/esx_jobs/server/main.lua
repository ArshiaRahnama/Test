local PlayersWorking = {}
local vehicles = {}
local allowedJobs = {
	'fisherman',
	'tailor',
	'slaughterer',
	'lumberjack',
	'fueler',
	'miner'
}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function IsAllowed(job)
	for i,v in ipairs(allowedJobs) do
		if v == job then
			return true
		end
	end

	return false
end

-- Runs one production/delivery tick for a player and, as long as they're
-- still marked as working, schedules the next one. `job` and `zoneKey` are
-- just identifiers -- the actual reward (times, item names, amounts, price)
-- is always read here from Config.Jobs, which is loaded server-side too
-- (client/jobs/*.lua is now also in the server_scripts list). The client
-- never sends the reward table itself, so there's nothing for a modified
-- client to tamper with.
local function Work(source, job, zoneKey)
	local jobData = Config.Jobs[job]
	local zone = jobData and jobData.Zones[zoneKey]

	if not zone or zone.Type ~= "work" and zone.Type ~= "delivery" or not zone.Item then
		PlayersWorking[source] = false
		return
	end

	local item = zone.Item

	SetTimeout(item[1].time, function()
		if not PlayersWorking[source] then return end

		local xPlayer = ESX.GetPlayerFromId(source)
		if not xPlayer then return end

		-- make sure the player is still actually on this job/zone before paying out again
		if xPlayer.job.name ~= job then
			PlayersWorking[source] = false
			return
		end

		for i=1, #item, 1 do
			local entry = item[i]

			local requiredQtty = 0
			if entry.requires ~= "nothing" then
				requiredQtty = xPlayer.getInventoryItem(entry.requires).count
			end

			if entry.db_name then
				-- production step: consumes "requires" (if any), produces "db_name"
				local itemQtty = xPlayer.getInventoryItem(entry.db_name).count

				if itemQtty >= entry.max then
					TriggerClientEvent('esx:showNotification', source, _U('max_limit', entry.name))
				elseif entry.requires ~= "nothing" and requiredQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', entry.requires_name))
				else
					xPlayer.addInventoryItem(entry.db_name, entry.add)
					if entry.requires ~= "nothing" then
						xPlayer.removeInventoryItem(entry.requires, entry.remove)
					end
				end
			else
				-- delivery step: sells "requires" for money, nothing is added to the inventory
				if entry.requires == "nothing" or requiredQtty <= 0 then
					TriggerClientEvent('esx:showNotification', source, _U('not_enough', entry.requires_name))
				else
					xPlayer.removeInventoryItem(entry.requires, entry.remove)
					if entry.price then
						xPlayer.addMoney(entry.price)
					end
				end
			end
		end

		Work(source, job, zoneKey)
	end)
end

RegisterServerEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function(job, zoneKey)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	-- job/zoneKey are trusted only as *lookup keys* into the shared config,
	-- so validating them just means: is this a real job the player actually
	-- holds, and does that job actually have this zone.
	if not IsAllowed(job) then return end
	if xPlayer.job.name ~= job then return end
	if type(zoneKey) ~= "string" or not Config.Jobs[job] or not Config.Jobs[job].Zones[zoneKey] then return end

	if not PlayersWorking[source] then
		PlayersWorking[source] = true
		Work(source, job, zoneKey)
	end
end)

RegisterServerEvent('esx_jobs:stopWork')
AddEventHandler('esx_jobs:stopWork', function()
	PlayersWorking[source] = false
end)

RegisterServerEvent('esx_jobs:addVehicle')
AddEventHandler('esx_jobs:addVehicle', function(netID)
	local identifier = GetPlayerIdentifier(source)

	if netID ~= nil then

		local vehicle = NetworkGetEntityFromNetworkId(netID)
		if DoesEntityExist(vehicle) then

			local model = GetEntityModel(vehicle)

			if model == GetHashKey("benson") then
				if not vehicles[identifier] then
					vehicles[identifier] = 0
				end

				vehicles[identifier] = netID
				TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])

			end

		end

	else

		if not vehicles[identifier] then
			vehicles[identifier] = 0
		end

		vehicles[identifier] = 0
		TriggerClientEvent('esx_carlock:workVehicle', source, nil)

	end

end)

AddEventHandler('esx:playerLoaded', function(source)

	local identifier = GetPlayerIdentifier(source)
	if vehicles[identifier] ~= nil and vehicles[identifier] ~= 0 then
		TriggerClientEvent('esx_carlock:workVehicle', source, vehicles[identifier])
	end

end)

-- renamed to match client/main.lua's ESX.TriggerServerEvent('esx_jobs:cautionss', ...) calls
RegisterServerEvent('esx_jobs:cautionss')
AddEventHandler('esx_jobs:cautionss', function(cautionType, cautionAmount, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	if cautionType == "take" then
		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)

		end)

		TriggerClientEvent('esx_jobs:spawnJobVehicle', source, spawnPoint, vehicle)
	elseif cautionType == "give_back" then

		TriggerEvent('esx_addonaccount:getAccount', 'caution', xPlayer.identifier, function(account)

		end)
	end
end)
