-- ============================================================
-- Drug Convoy Event
-- Periodic server-wide PvP event: an NPC-driven cargo van hauls a big shipment between two of
-- Config.Delivery.DropZones. Anyone (any gang, any player) can attack it to stop it and loot the
-- cargo -- no case, no menu, just show up and fight. DOA gets an in-game department-chat heads-up
-- when it spawns, and if a DOA officer is who actually stops it, it's logged as a real seizure
-- (exports['esx_uniquejobs']:LogSeizure) with a cash payout instead of handing them raw drugs.
--
-- Entity spawning follows the same pattern this file already uses elsewhere for anything that
-- needs to exist consistently for every player (see client/convoy.lua): one connected client is
-- picked to spawn the networked vehicle + peds, then every client is told their network IDs so
-- they resolve to the same entities. This works regardless of the server's OneSync mode, unlike
-- server-side entity creation.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local ActiveConvoy = nil -- { id, route = {from, to}, netVeh, netDriver, netGuards, stopped, looted, spawnedAt }
local NextConvoyId = 1

local function announceToDOA(message)
	if not (Config.UniqueJobs.Convoy and Config.UniqueJobs.Convoy.AnnounceToDOA) then return end

	local ok, err = pcall(function()
		exports['esx_uniquejobs']:SendDeptMessage('doa', 'DOA', { 200, 60, 60 }, 'Dispatch', '-', message)
	end)

	if not ok then
		print(('[esx_drugs] Convoy: could not announce to DOA dept chat (is esx_uniquejobs running?): %s'):format(tostring(err)))
	end
end

local function pickRoute()
	local zones = Config.Delivery.DropZones
	if #zones < 2 then return nil end

	local fromIdx = math.random(1, #zones)
	local toIdx = math.random(1, #zones)
	while toIdx == fromIdx do
		toIdx = math.random(1, #zones)
	end

	return { from = zones[fromIdx], to = zones[toIdx] }
end

local function pickSpawnerClient()
	local xPlayers = ESX.GetPlayers()
	if #xPlayers == 0 then return nil end
	return xPlayers[1]
end

local function despawnConvoy(reason)
	if not ActiveConvoy then return end

	TriggerClientEvent('esx_drugs:convoy:cleanup', -1, ActiveConvoy.id)
	ActiveConvoy = nil
end

function SpawnConvoy()
	if ActiveConvoy then return end -- only one convoy at a time

	local route = pickRoute()
	if not route then
		print('[esx_drugs] Convoy: need at least 2 Config.Delivery.DropZones, skipping spawn.')
		return
	end

	local spawnerSource = pickSpawnerClient()
	if not spawnerSource then
		return -- nobody online to spawn it for, try again next loop
	end

	local convoyId = NextConvoyId
	NextConvoyId = NextConvoyId + 1

	ActiveConvoy = {
		id = convoyId,
		route = route,
		stopped = false,
		looted = false,
		spawnedAt = os.time(),
	}

	TriggerClientEvent('esx_drugs:convoy:becomeSpawner', spawnerSource, convoyId, route)

	SetTimeout(Config.Convoy.DespawnTimeout, function()
		if ActiveConvoy and ActiveConvoy.id == convoyId and not ActiveConvoy.looted then
			despawnConvoy('timeout')
		end
	end)
end

function StartConvoyLoop()
	if not Config.Convoy.Enabled then return end

	local delay = math.random(Config.Convoy.MinInterval, Config.Convoy.MaxInterval)
	SetTimeout(delay, function()
		SpawnConvoy()
		StartConvoyLoop()
	end)
end

-- Spawner client reports back the network IDs once the vehicle/peds actually exist, so we can
-- broadcast them to everyone else and start tracking the convoy as "live".
RegisterServerEvent('esx_drugs:convoy:registerEntities')
AddEventHandler('esx_drugs:convoy:registerEntities', function(convoyId, netVeh, netDriver, netGuards)
	if not ActiveConvoy or ActiveConvoy.id ~= convoyId then return end

	ActiveConvoy.netVeh = netVeh
	ActiveConvoy.netDriver = netDriver
	ActiveConvoy.netGuards = netGuards

	TriggerClientEvent('esx_drugs:convoy:announce', -1, convoyId, ActiveConvoy.route, netVeh, netDriver, netGuards)
	announceToDOA(('Yek convoy-e mashkook az %s be samte %s harekat kard. Sarnesh-in-esh mosalah hastand.'):format(ActiveConvoy.route.from.name, ActiveConvoy.route.to.name))
end)

-- Any client near the van reports that it's been stopped (driver dead / destroyed). Trusting the
-- client here is fine -- this is a PvE-flavoured server event with no real economy weight riding
-- on it (same trust level as e.g. a delivery mission's own client-reported progress).
RegisterServerEvent('esx_drugs:convoy:driverDown')
AddEventHandler('esx_drugs:convoy:driverDown', function(convoyId)
	local _source = source
	if not ActiveConvoy or ActiveConvoy.id ~= convoyId or ActiveConvoy.stopped then return end

	ActiveConvoy.stopped = true
	TriggerClientEvent('esx_drugs:convoy:stopped', -1, convoyId)
	announceToDOA('Convoy-e mavad motevaghef shod. Mahmule hanuz ghabele bazyabi ast.')

	SetTimeout(Config.Convoy.DespawnTimeout, function()
		if ActiveConvoy and ActiveConvoy.id == convoyId and not ActiveConvoy.looted then
			despawnConvoy('timeout_after_stop')
		end
	end)
end)

-- Looting the stopped van. First valid claim wins (ActiveConvoy.looted flag), same anti-double-dip
-- pattern as delivery/evidence elsewhere in this file.
RegisterServerEvent('esx_drugs:convoy:loot')
AddEventHandler('esx_drugs:convoy:loot', function(convoyId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end

	if not ActiveConvoy or ActiveConvoy.id ~= convoyId or not ActiveConvoy.stopped then
		TriggerClientEvent('esx:showNotification', _source, _U('convoy_gone'))
		return
	end

	if ActiveConvoy.looted then
		TriggerClientEvent('esx:showNotification', _source, _U('convoy_already_looted'))
		return
	end

	ActiveConvoy.looted = true

	local cash = math.random(Config.Convoy.CargoCash.min, Config.Convoy.CargoCash.max)
	local cargoSummary = {}
	local totalItemValue = 0

	for _, entry in ipairs(Config.Convoy.CargoItems) do
		if math.random(1, 100) <= entry.chance then
			local amount = math.random(entry.min, entry.max)
			table.insert(cargoSummary, { item = entry.item, label = entry.label, amount = amount })

			local unitValue = DrugDealerItems.get(entry.item)
			if unitValue then
				totalItemValue = totalItemValue + (unitValue * amount)
			end
		end
	end

	if IsRestrictedJob(xPlayer) then
		-- DOA (or any other on-duty responder job) securing the convoy is a seizure, not a
		-- looting run: no raw drugs handed over, log it properly and pay a cash bonus instead.
		local totalEstValue = totalItemValue + cash
		local bonusCash = ESX.Math.Round(Config.Convoy.DOASeizureCash * GetGradeBonusMultiplier(xPlayer))
		xPlayer.addMoney(bonusCash)

		if Config.UniqueJobs.LogSeizures then
			local okSeize, errSeize = pcall(function()
				exports['esx_uniquejobs']:LogSeizure(
					'Convoy Mavad (' .. ActiveConvoy.route.from.name .. ' -> ' .. ActiveConvoy.route.to.name .. ')',
					1,
					totalEstValue,
					nil,
					nil,
					GetCharacterName(xPlayer)
				)
			end)
			if not okSeize then
				print(('[esx_drugs] Convoy: could not log seizure (is esx_uniquejobs running?): %s'):format(tostring(errSeize)))
			end
		end

		TriggerClientEvent('esx:showNotification', _source, _U('convoy_doa_secured', ESX.Math.GroupDigits(bonusCash)))
		announceToDOA(('Mahmule tavasote %s zabt shod.'):format(GetCharacterName(xPlayer)))
	else
		xPlayer.addMoney(cash)

		local labels = {}
		for _, entry in ipairs(cargoSummary) do
			xPlayer.addInventoryItem(entry.item, entry.amount)
			table.insert(labels, entry.amount .. 'x ' .. entry.label)
		end

		TriggerClientEvent('esx:showNotification', _source, _U('convoy_looted', ESX.Math.GroupDigits(cash), #labels > 0 and table.concat(labels, ', ') or '-'))
	end

	despawnConvoy('looted')
end)

CreateThread(function()
	Wait(5000) -- let the rest of server/main.lua finish initializing (DrugDealerItems etc.)
	StartConvoyLoop()
end)
