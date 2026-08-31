ESX = nil
local DrugHandeler

-- Unique_Skills doesn't actually export UpdateSkill on this server (throws
-- "No such export UpdateSkill in resource Unique_Skills" and previously aborted the whole
-- event handler at that point -- silently skipping every line after it, including the actual
-- item being handed over and any notification). pcall it so a missing/broken external resource
-- can never again block giving the player their item.
function SafeUpdateSkill(source, skill, amount)
	local ok, err = pcall(function()
		exports['Unique_Skills']:UpdateSkill(source, skill, amount)
	end)
	if not ok then
		print(('[esx_drugs] Unique_Skills:UpdateSkill failed, continuing without skill XP (%s)'):format(tostring(err)))
	end
end

exports.oxmysql:execute('SELECT * FROM capture WHERE name = "drug"', {} , function(drug)
	if drug then
		DrugHandeler = 'gang_' .. string.lower(drug[1].handeler)
	end
end)

RegisterServerEvent('drug:ChangeHandeler')
AddEventHandler('drug:ChangeHandeler', function(newHandler)
	DrugHandeler = 'gang_' .. string.lower(newHandler)
	exports.oxmysql:execute('UPDATE capture SET handeler = @handeler WHERE name = "drug"', {
		['@handeler']	= newHandler
	})
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----------------------------------------
------- ANTI-EXPLOIT / HEAT HELPERS -----
----------------------------------------
-- True if `source`'s ped is currently within `maxDistance` of `coords`. Used to reject
-- process/pickup/sell events fired from an unrealistic distance (menu exploits, teleport, etc).
function IsPlayerNearCoords(source, coords, maxDistance)
	local ped = GetPlayerPed(source)
	if not ped or ped == 0 then return false end
	local playerCoords = GetEntityCoords(ped)
	return #(playerCoords - vector3(coords.x, coords.y, coords.z)) <= maxDistance
end

-- Per-player "heat": rises on every dealer sale, decays over time. Used to scale down price,
-- scale up the police alert's odds/size, and rate-limit rapid-fire selling.
local PlayerHeat = {}
local LastSellAt = {}
local ActiveDeliveries = {}
local DeliveryCooldown = {}

function GetPlayerHeat(source)
	return PlayerHeat[source] or 0
end

function AddPlayerHeat(source, amount)
	PlayerHeat[source] = math.min(Config.Heat.Max, GetPlayerHeat(source) + amount)
	return PlayerHeat[source]
end

CreateThread(function()
	while true do
		Wait(Config.Heat.DecayInterval)

		for src, heat in pairs(PlayerHeat) do
			local newHeat = heat - Config.Heat.DecayAmount

			if newHeat <= 0 then
				PlayerHeat[src] = nil
			else
				PlayerHeat[src] = newHeat
			end
		end
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source
	PlayerHeat[_source] = nil
	LastSellAt[_source] = nil
	ActiveDeliveries[_source] = nil
end)

----------------------------------------
---------- CID EVIDENCE REFERRAL --------
----------------------------------------
-- One persistent evidence "case" per field zone (not one per harvest -- every pickup at the
-- same field just adds to the same case's count). The case stays on DOA's map, always visible,
-- until either DOA collects it (E) or it goes Config.Evidence.InactivityTimeout with no new
-- activity. First detection at a field fires a DOA-only siren-blip alert (Unique_AllRobs); later
-- pickups at that same field quietly bump the counter without re-alerting (no notification spam).
-- Newly-connecting/newly-transferred DOA officers get synced with every currently open case.
local EvidenceSites = {} -- [fieldKey] = { coords, label, count, lastActivity }

function BroadcastEvidenceSite(fieldKey, targetSource)
	local site = EvidenceSites[fieldKey]
	if not site then return end

	local payload = {id = fieldKey, coords = site.coords, label = site.label, count = site.count}

	if targetSource then
		TriggerClientEvent('esx_drugs:newEvidenceSite', targetSource, payload)
		return
	end

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer and xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx_drugs:newEvidenceSite', xPlayers[i], payload)
		end
	end
end

function RemoveEvidenceSite(fieldKey)
	EvidenceSites[fieldKey] = nil

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer and xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx_drugs:removeEvidenceSite', xPlayers[i], fieldKey)
		end
	end
end

-- Send every currently open evidence case to one DOA officer (new connection, or just got the job)
function SyncEvidenceToPlayer(targetSource)
	for fieldKey, _ in pairs(EvidenceSites) do
		BroadcastEvidenceSite(fieldKey, targetSource)
	end
end

function ReportEvidence(fieldKey, coords, drugLabel)
	local site = EvidenceSites[fieldKey]

	if site then
		site.count = site.count + 1
		site.lastActivity = GetGameTimer()
		BroadcastEvidenceSite(fieldKey)
	else
		EvidenceSites[fieldKey] = {
			coords       = coords,
			label        = drugLabel,
			count        = 1,
			lastActivity = GetGameTimer(),
		}
		BroadcastEvidenceSite(fieldKey)
		exports['Unique_AllRobs']:AlertPolice(coords, ('Faaliate Mashkook: %s'):format(drugLabel), Config.Evidence.AlertDuration, Config.Evidence.AlertRadius, {'doa'})
	end
end

-- Auto-clears any evidence case that's had no new activity for Config.Evidence.InactivityTimeout
CreateThread(function()
	while true do
		Wait(60000)

		for fieldKey, site in pairs(EvidenceSites) do
			if GetGameTimer() - site.lastActivity > Config.Evidence.InactivityTimeout then
				RemoveEvidenceSite(fieldKey)
			end
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if xPlayer and xPlayer.job and xPlayer.job.name == 'doa' then
		SyncEvidenceToPlayer(playerId)
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if job and job.name == 'doa' then
		SyncEvidenceToPlayer(playerId)
	end
end)

RegisterServerEvent('esx_drugs:collectEvidence')
AddEventHandler('esx_drugs:collectEvidence', function(fieldKey)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not xPlayer or xPlayer.job.name ~= 'doa' then return end

	local site = EvidenceSites[fieldKey]
	if not site then
		TriggerClientEvent('esx:showNotification', _source, _U('evidence_expired'))
		return
	end

	if not IsPlayerNearCoords(_source, site.coords, Config.Evidence.CollectRadius) then
		return
	end

	RemoveEvidenceSite(fieldKey)

	local streetHash = GetStreetNameAtCoord(site.coords.x, site.coords.y, site.coords.z)
	local streetName = GetStreetNameFromHashKey(streetHash)

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local cidPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if cidPlayer and cidPlayer.job.name == 'cid' then
			TriggerClientEvent('chat:addMessage', xPlayers[i], {
				color = {0, 95, 254},
				multiline = true,
				args = {'[ CID Referral ]', ('Parvandeye %s dar %s (%s bar bardasht shode) - jam-avari shode tavasote %s'):format(site.label, streetName, site.count, GetPlayerName(_source))}
			})
		end
	end

	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'CIDReferralLog', '```css\n[ DOA -> CID Evidence Referral ]\n[ Type : '..tostring(site.label)..' ]\n[ Location : '..tostring(streetName)..' ]\n[ Harvest Count : '..tostring(site.count)..' ]\n[ Collected By : '..GetPlayerName(_source)..' ]\n```', 'user', true, _source, false)
	TriggerClientEvent('esx:showNotification', _source, _U('evidence_collected', site.count))
end)

----------------------------------------
---------- DELIVERY / ESCORT ------------
----------------------------------------
-- Random escort mission: player carries cargo they already own between two zones for a bonus
-- payout. DOA gets a route briefing (start/end + interpolated waypoints) up-front so they can
-- try to ambush, but never gets a live tracker on the carrier -- real cat-and-mouse.
-- (ActiveDeliveries / DeliveryCooldown are declared near the top of the file, alongside PlayerHeat.)

function GetRandomDeliveryPair()
	local zones = Config.Delivery.DropZones
	local a = zones[math.random(1, #zones)]
	local b

	repeat
		b = zones[math.random(1, #zones)]
	until b ~= a

	return a, b
end

function BriefDOAOnDelivery(startCoords, endCoords, duration)
	local waypoints = {}
	local n = Config.Delivery.RouteHintPoints

	for i = 1, n do
		local t = i / (n + 1)
		table.insert(waypoints, {
			x = startCoords.x + (endCoords.x - startCoords.x) * t,
			y = startCoords.y + (endCoords.y - startCoords.y) * t,
			z = startCoords.z + (endCoords.z - startCoords.z) * t,
		})
	end

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer and xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx_drugs:doaDeliveryIntel', xPlayers[i], startCoords, endCoords, waypoints, duration)
		end
	end
end

RegisterServerEvent('esx_drugs:requestDelivery')
AddEventHandler('esx_drugs:requestDelivery', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not Config.Delivery.Enabled then return end

	if ActiveDeliveries[_source] then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_already_active'))
		return
	end

	local now = GetGameTimer()
	if DeliveryCooldown[_source] and (now - DeliveryCooldown[_source]) < Config.Delivery.Cooldown then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_cooldown'))
		return
	end

	local carriedItem
	for i=1, #DrugItemNames, 1 do
		local item = xPlayer.getInventoryItem(DrugItemNames[i])
		if item and item.count >= Config.Delivery.MinAmount then
			carriedItem = item
			break
		end
	end

	if not carriedItem then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_no_cargo'))
		return
	end

	local amount = math.min(carriedItem.count, math.random(Config.Delivery.MinAmount, Config.Delivery.MaxAmount))
	local startZone, endZone = GetRandomDeliveryPair()
	local unitPrice = DrugDealerItems.get(carriedItem.name)
	local reward = ESX.Math.Round(unitPrice * amount * Config.Delivery.RewardMultiplier)

	ActiveDeliveries[_source] = {
		item        = carriedItem.name,
		label       = carriedItem.label,
		amount      = amount,
		reward      = reward,
		dropCoords  = endZone.coords,
		dropName    = endZone.name,
		expiresAt   = now + Config.Delivery.TimeLimit,
	}

	DeliveryCooldown[_source] = now

	TriggerClientEvent('esx_drugs:startDelivery', _source, {
		amount     = amount,
		label      = carriedItem.label,
		reward     = reward,
		dropCoords = endZone.coords,
		dropName   = endZone.name,
		duration   = Config.Delivery.TimeLimit,
	})

	BriefDOAOnDelivery(startZone.coords, endZone.coords, Config.Delivery.TimeLimit)
end)

RegisterServerEvent('esx_drugs:completeDelivery')
AddEventHandler('esx_drugs:completeDelivery', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local mission = ActiveDeliveries[_source]

	if not mission then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_no_active'))
		return
	end

	if GetGameTimer() > mission.expiresAt then
		ActiveDeliveries[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_expired'))
		TriggerClientEvent('esx_drugs:endDelivery', _source)
		return
	end

	if not IsPlayerNearCoords(_source, mission.dropCoords, 5.0) then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_not_at_drop'))
		return
	end

	local xItem = xPlayer.getInventoryItem(mission.item)
	if not xItem or xItem.count < mission.amount then
		ActiveDeliveries[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_cargo_missing'))
		TriggerClientEvent('esx_drugs:endDelivery', _source)
		return
	end

	xPlayer.removeInventoryItem(mission.item, mission.amount)
	xPlayer.addMoney(mission.reward)
	ActiveDeliveries[_source] = nil

	TriggerClientEvent('esx:showNotification', _source, _U('delivery_success', ESX.Math.GroupDigits(mission.reward)))
	TriggerClientEvent('esx_drugs:endDelivery', _source)
	TriggerEvent('DiscordBot:ToDiscord', 'rob', 'DrugSaleLog', '```css\n[ Delivery Completed ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Cargo : '..tostring(mission.amount)..'x '..tostring(mission.item)..' ]\n[ Reward : '..tostring(mission.reward)..' ]\n```', 'user', true, _source, false)
end)

-- DOA-only: attempt to search the nearest player for active delivery cargo. Works even if that
-- player has nothing on them (DOA can't tell from range who's actually carrying), so it doubles
-- as a bluff/stop-and-search mechanic, not a cargo detector.
RegisterServerEvent('esx_drugs:seizeDelivery')
AddEventHandler('esx_drugs:seizeDelivery', function(targetId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not xPlayer or xPlayer.job.name ~= 'doa' then return end

	local targetPlayer = ESX.GetPlayerFromId(targetId)
	if not targetPlayer then return end

	if not IsPlayerNearCoords(_source, GetEntityCoords(GetPlayerPed(targetId)), Config.Delivery.InterceptRadius) then
		return
	end

	local mission = ActiveDeliveries[targetId]
	if not mission then
		TriggerClientEvent('esx:showNotification', _source, _U('delivery_seize_none'))
		return
	end

	targetPlayer.removeInventoryItem(mission.item, mission.amount)
	ActiveDeliveries[targetId] = nil

	TriggerClientEvent('esx_drugs:endDelivery', targetId)
	TriggerClientEvent('esx:showNotification', targetId, _U('delivery_seized'))
	TriggerClientEvent('esx:showNotification', _source, _U('delivery_seize_success', mission.amount, mission.label))

	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ DOA Seizure ]\n[ Officer : '..GetPlayerName(_source)..' ]\n[ Target : '..GetPlayerName(targetId)..' ]\n[ Seized : '..tostring(mission.amount)..'x '..tostring(mission.item)..' ]\n```', 'user', true, _source, false)
end)

function DrugsManager()
	local self = {}
	self.get = function(k)
		return self[k]
	end

	self.regen	= function()
		self.mushroom	= math.random(400, 450)
		self.marijuana	= math.random(900, 1000)
		self.crack		= math.random(4500, 5000)
		self.cocaine	= math.random(1900, 2100)
		self.heroine	= math.random(4500, 5000)
		self.meth		= math.random(10000, 10500)
		TriggerClientEvent('esx_jk_drugs:getPrice', -1, {
			{name = 'marijuana' 	, price = self.marijuana},
			{name = 'crack'			, price = self.crack},
			{name = 'cocaine'		, price = self.cocaine},
			{name = 'heroine'		, price = self.heroine},
			{name = 'meth'			, price = self.meth},
			{name = 'mushroom'		, price = self.mushroom},
		})
	end

	return self
end

-- Deliberately global (not local): earlier code in this file (delivery/evidence handlers) needs
-- to reference these, and Lua's lexical scoping would otherwise hide a `local` declared this late.
DrugDealerItems = DrugsManager()

-- Sellable drug item names, shared by the dealer-price callback and the delivery-mission picker
DrugItemNames = {'marijuana', 'crack', 'cocaine', 'heroine', 'meth', 'mushroom'}

ESX.RegisterServerCallback('getDrugPrices', function(source, cb)
	local list = {}
	for i=1, #DrugItemNames, 1 do
		table.insert(list, {name = DrugItemNames[i], price = DrugDealerItems.get(DrugItemNames[i])})
	end
	cb(list)
end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

RegisterServerEvent('esx_jk_drugs:pickedUpCannabis')
AddEventHandler('esx_jk_drugs:pickedUpCannabis', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xItem = xPlayer.getInventoryItem('cannabis')

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
			SafeUpdateSkill(_source, "Marijuana", 0.006)
			ReportEvidence('WeedField', Config.FieldZones.WeedField.coords, 'Shah Dane')
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
		SafeUpdateSkill(_source, "Marijuana", 0.006)
		TriggerClientEvent("Task_System:Shahdane", _source, amount, itemName)
		ReportEvidence('WeedField', Config.FieldZones.WeedField.coords, 'Shah Dane')
	end
end)

ESX.RegisterServerCallback('esx_jk_drugs:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('esx_jk_drugs:pickedUpCocaPlant')
AddEventHandler('esx_jk_drugs:pickedUpCocaPlant', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xItem = xPlayer.getInventoryItem('coca')
	local multi = true

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if multi then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('cocaine_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
			TriggerClientEvent("Task_System:Bardashtecocaine", _source, amount, itemName)
			ReportEvidence('CocaineField', Config.FieldZones.CocaineField.coords, 'Giahe Coca')
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('cocaine_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
		ReportEvidence('CocaineField', Config.FieldZones.CocaineField.coords, 'Giahe Coca')
	end
end)

RegisterServerEvent('esx_jk_drugs:pickedUpEphedra')
AddEventHandler('esx_jk_drugs:pickedUpEphedra', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xItem = xPlayer.getInventoryItem('ephedra')

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
			ReportEvidence('EphedrineField', Config.FieldZones.EphedrineField.coords, 'Ephedra')
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
		TriggerClientEvent("esx_drugs:WeedPickUp", source)
		TriggerClientEvent("Task_System:BardashteEphedra", _source, amount, itemName)
		ReportEvidence('EphedrineField', Config.FieldZones.EphedrineField.coords, 'Ephedra')
	end
end)

RegisterServerEvent('esx_jk_drugs:pickedUpmushroom')
AddEventHandler('esx_jk_drugs:pickedUpmushroom', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xItem = xPlayer.getInventoryItem('mushroom')

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
			ReportEvidence('MushroomField', Config.FieldZones.MushroomField.coords, 'Mashroom')
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('ephedra_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
		TriggerClientEvent("esx_drugs:WeedPickUp", source)
		ReportEvidence('MushroomField', Config.FieldZones.MushroomField.coords, 'Mashroom')
	end
end)

RegisterServerEvent('esx_jk_drugs:pickedUpPoppy')
AddEventHandler('esx_jk_drugs:pickedUpPoppy', function(hasSkill)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xItem = xPlayer.getInventoryItem('poppy')

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if Config.MultiPlant then
		local picked = math.random(3)
		if xItem.limit ~= -1 and (xItem.count + picked) > xItem.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('opium_inventoryfull'))
		else
			xPlayer.addInventoryItem(xItem.name, picked)
			ReportEvidence('PoppyField', Config.FieldZones.PoppyField.coords, 'Khash-Khaash')
		end
	elseif xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('opium_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 1)
		SafeUpdateSkill(_source, "Heroine", 0.004)
		TriggerClientEvent("Task_System:BardashteKhashkhash", _source, amount, itemName)
		ReportEvidence('PoppyField', Config.FieldZones.PoppyField.coords, 'Khash-Khaash')
	end
end)

RegisterServerEvent('esx_jk_drugs:processCannabis')
AddEventHandler('esx_jk_drugs:processCannabis', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then

		if not IsPlayerNearCoords(_source, Config.ProcessZones.WeedProcessing.coords, Config.MaxInteractDistance) then
			TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
			return
		end

		if xPlayer.job.grade > 0 then
			if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
				TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
				return
			end
		end

		local xCannabis, xMarijuana = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('marijuana')

		if xMarijuana.limit ~= -1 and (xMarijuana.count + 1) > xMarijuana.limit then
			TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
		elseif xCannabis.count < 1 then
			TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
		else
			xPlayer.removeInventoryItem('cannabis', 1)
			xPlayer.addInventoryItem('marijuana', 5)
			TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
			TriggerClientEvent("Task_System:SakhteMarijuana", _source, amount, itemName)

			TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
		end
		TriggerEvent('esx_jk_drugs:processCannabis', _source)

	end

end)

RegisterServerEvent('esx_jk_drugs:processCocaPlant')
AddEventHandler('esx_jk_drugs:processCocaPlant', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xCocaPlant, xCocaine = xPlayer.getInventoryItem('coca'), xPlayer.getInventoryItem('cocaine')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.CocaineProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xCocaine.limit ~= -1 and (xCocaine.count + 1) > xCocaine.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processingfull'))
	elseif xCocaPlant.count < 5 then
		TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processingenough'))
	else
		xPlayer.removeInventoryItem('coca', 5)
		xPlayer.addInventoryItem('cocaine', 2)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		TriggerClientEvent("Task_System:SakhteCocaine", _source, amount, itemName)

		TriggerClientEvent('esx:showNotification', _source, _U('cocaine_processed'))
	end

end)

RegisterServerEvent('esx_jk_drugs:processEphedra')
AddEventHandler('esx_jk_drugs:processEphedra', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xEphedra, xEphedrine = xPlayer.getInventoryItem('ephedra'), xPlayer.getInventoryItem('ephedrine')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.EphedrineProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xEphedrine.limit ~= -1 and (xEphedrine.count + 1) > xEphedrine.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processingfull'))
	elseif xEphedra.count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processingenough'))
	else
		xPlayer.removeInventoryItem('ephedra', 1)
		xPlayer.addInventoryItem('ephedrine', 2)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		TriggerClientEvent("Task_System:SakhteEphedrine", _source, amount, itemName)


		TriggerClientEvent('esx:showNotification', _source, _U('ephedrine_processed'))
	end

end)

RegisterServerEvent('esx_jk_drugs:processEphedrine')
AddEventHandler('esx_jk_drugs:processEphedrine', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xEphedrine, xMeth = xPlayer.getInventoryItem('ephedrine'), xPlayer.getInventoryItem('meth')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.MethProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xMeth.limit ~= -1 and (xMeth.count + 1) > xMeth.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('meth_processingfull'))
	elseif xEphedrine.count < 5 then
		TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
	else
		xPlayer.removeInventoryItem('ephedrine', 5)
		xPlayer.addInventoryItem('meth', 1)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		TriggerClientEvent("Task_System:SakhteShishe", _source, amount, itemName)

		TriggerClientEvent('esx:showNotification', _source, _U('meth_processed'))
	end

end)

RegisterServerEvent('esx_jk_drugs:processCoke')
AddEventHandler('esx_jk_drugs:processCoke', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xCocaine, xCrack = xPlayer.getInventoryItem('cocaine'), xPlayer.getInventoryItem('crack')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.CrackProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xCrack.limit ~= -1 and (xCrack.count + 1) > xCrack.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('crack_processingfull'))
	elseif xCocaine.count < 2 then
		TriggerClientEvent('esx:showNotification', _source, _U('crack_processingenough'))
	else
		xPlayer.removeInventoryItem('cocaine', 2)
		xPlayer.addInventoryItem('crack', 1)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		TriggerClientEvent("Task_System:SakhteCrack", _source, amount, itemName)

		TriggerClientEvent('esx:showNotification', _source, _U('crack_processed'))
	end

end)

RegisterServerEvent('esx_jk_drugs:processPoppy')
AddEventHandler('esx_jk_drugs:processPoppy', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPoppy, xOpium = xPlayer.getInventoryItem('poppy'), xPlayer.getInventoryItem('opium')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.PoppyProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xOpium.limit ~= -1 and (xOpium.count + 5) > xOpium.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('opium_processingfull'))
	elseif xPoppy.count < 5 then
		TriggerClientEvent('esx:showNotification', _source, _U('opium_processingenough'))
	else
		xPlayer.removeInventoryItem('poppy', 5)
		xPlayer.addInventoryItem('opium', 5)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		SafeUpdateSkill(_source, "Heroine", 0.004)
		TriggerClientEvent("Task_System:SakhteTeryak", _source, amount, itemName)

		TriggerClientEvent('esx:showNotification', _source, _U('opium_processed'))
	end
end)

RegisterServerEvent('esx_jk_drugs:processOpium')
AddEventHandler('esx_jk_drugs:processOpium', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xOpium, xHeroine = xPlayer.getInventoryItem('opium'), xPlayer.getInventoryItem('heroine')

	if not IsPlayerNearCoords(_source, Config.ProcessZones.HeroineProcessing.coords, Config.MaxInteractDistance) then
		TriggerClientEvent('esx:showNotification', _source, _U('too_far_process'))
		return
	end

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if xHeroine.limit ~= -1 and (xHeroine.count + 1) > xHeroine.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('heroine_processingfull'))
	elseif xOpium.count < 5 then
		TriggerClientEvent('esx:showNotification', _source, _U('heroine_processingenough'))
	else
		xPlayer.removeInventoryItem('opium', 5)
		xPlayer.addInventoryItem('heroine', 1)
		TriggerClientEvent('esx_drugs:MarijuanaProg', _source)
		SafeUpdateSkill(_source, "Heroine", 0.004)
		TriggerClientEvent("Task_System:SakhteHeroine", _source, amount, itemName)
		TriggerClientEvent('esx:showNotification', _source, _U('heroine_processed'))
	end
end)



RegisterServerEvent('esx_jk_drugs:testResultsFail')
AddEventHandler('esx_jk_drugs:testResultsFail', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('drug_fail')))
		end
	end
end)

RegisterServerEvent('esx_jk_drugs:testResultsFailTipsy')
AddEventHandler('esx_jk_drugs:testResultsFailTipsy', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('fail_tipsy')))
		end
	end
end)

RegisterServerEvent('esx_jk_drugs:testResultsFailDrunk')
AddEventHandler('esx_jk_drugs:testResultsFailDrunk', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('fail_drunk')))
		end
	end
end)

RegisterServerEvent('esx_jk_drugs:testResultsPass')
AddEventHandler('esx_jk_drugs:testResultsPass', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('drug_pass')))
		end
	end
end)

RegisterServerEvent('esx_jk_drugs:testResultsPassBCA')
AddEventHandler('esx_jk_drugs:testResultsPassBCA', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('bca_pass')))
		end
	end
end)

local DrugAlertJobs = {
	police = true, sheriff = true, mt = true, fbi = true,
	cid = true, cia = true, marshal = true, judge = true, doa = true,
}

-- Called when a player sells to the generic drug dealer (Kharidare Mavad / Config.CircleZones.DrugDealer).
-- Delegates the blip + on-screen countdown to Unique_AllRobs's shared export, instead of esx_drugs
-- running its own copy of that logic (see fxmanifest.lua -> dependency 'Unique_AllRobs').
-- `heat` scales the alert up once it crosses Config.Heat.HighHeatThreshold (bigger radius, longer duration).
function AlertCopsDealerSale(sellerSource, coords, heat)
	local duration = Config.DealerAlertDuration
	local radius = 60.0

	if heat and heat >= Config.Heat.HighHeatThreshold then
		duration = math.floor(duration * Config.Heat.HighHeatDurationMult)
		radius = radius * Config.Heat.HighHeatRadiusMult
	end

	exports['Unique_AllRobs']:AlertPolice(coords, _U('dealer_alert_blip'), duration, radius)
end

RegisterServerEvent('esx_jk_drugs:policeAlert')
AddEventHandler('esx_jk_drugs:policeAlert', function()
	local _source = source
	local xPlayers = ESX.GetPlayers()
	local xSelf = ESX.GetPlayerFromId(_source)
	local coords = GetEntityCoords(GetPlayerPed(_source))

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if DrugAlertJobs[xPlayer.job.name] then
			TriggerClientEvent('esx:showNotification', xPlayers[i], (_U('police_alert')))
		end
	end

	TriggerEvent('DiscordBot:ToDiscord', 'rob', 'DrugAlertLog', '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Player Steam : '..(xSelf and xSelf.identifier or '?')..' ]\n[ Event : Drug activity triggered a police alert ]\n[ Coords : '..tostring(coords)..' ]\n```', 'user', true, _source, false)
end)

ESX.RegisterServerCallback('esx_jk_drugs:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_jk_drugs:removeItem')
AddEventHandler('esx_jk_drugs:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

RegisterServerEvent('esx_jk_drugs:giveItem')
AddEventHandler('esx_jk_drugs:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, "You're at maximum items")
	end
end)

RegisterServerEvent('esx_drugs:sellDrug')
AddEventHandler('esx_drugs:sellDrug', function(itemName, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = DrugDealerItems.get(itemName)
	local xItem = xPlayer.getInventoryItem(itemName)

	if xPlayer.job.grade > 0 then
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' or xPlayer.job.name == 'police' or xPlayer.job.name == 'mt' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' or xPlayer.job.name == 'cid' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'marshal' or xPlayer.job.name == 'judge' or xPlayer.job.name == 'doa' then
			TriggerClientEvent('esx:showNotification', _source, 'Shoma nemitavanid On-Duty in kar ro anjam dahid!')
			return
		end
	end

	if not price then
		print(('esx_drugs: %s attempted to sell an invalid drug!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_drugs ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : to sell an invalid drug! ]\n[ Reason Blocked : not authorized / invalid data ]\n```', 'user', true, source, false)
		return
	end

	if xItem.count < amount then
		TriggerClientEvent('esx:showNotification', _source, _U('dealer_notenough'))
		return
	end

	-- Rate-limit: block rapid-fire selling from the same player (menu-exploit / macro spam)
	local now = GetGameTimer()
	if LastSellAt[_source] and (now - LastSellAt[_source]) < Config.SellCooldown then
		TriggerClientEvent('esx:showNotification', _source, _U('dealer_cooldown'))
		return
	end
	LastSellAt[_source] = now

	-- Distance check: the sale must actually happen near the dealer, not from across the map
	if not IsPlayerNearCoords(_source, Config.CircleZones.DrugDealer.coords, Config.CircleZones.DrugDealer.radius + 3.0) then
		TriggerClientEvent('esx:showNotification', _source, _U('dealer_too_far'))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_drugs ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : to sell while too far from the dealer ]\n[ Reason Blocked : distance check failed - possible exploit ]\n```', 'user', true, source, false)
		return
	end

	-- Heat: rises with every sale, decays over time. Higher heat = lower payout + bigger/likelier alert.
	local heat = AddPlayerHeat(_source, Config.Heat.PerSale)
	local heatPercent = heat / Config.Heat.Max
	local priceMultiplier = 1 - (heatPercent * Config.Heat.MaxPriceDrop)

	price = ESX.Math.Round(price * amount * Config.DealerSellBonus * priceMultiplier)

	-- Gang tax: a cut of the seller's own earnings goes to their own gang's account (separate
	-- from the drug-territory-controller bonus below, which is unrelated turf-control income)
	local gangCut = 0
	if Config.GangTaxPercent > 0 and xPlayer.gang and xPlayer.gang.name and xPlayer.gang.name ~= 'none' then
		gangCut = ESX.Math.Round(price * (Config.GangTaxPercent / 100))
	end
	local netPrice = price - gangCut

	xPlayer.addMoney(netPrice)
	xPlayer.removeInventoryItem(xItem.name, amount)
	TriggerClientEvent("Task_System:AddCompleteQuest", _source, amount, xItem.name)
	TriggerEvent('DiscordBot:ToDiscord', 'rob', 'DrugSaleLog', '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(xItem.name)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n[ Heat : '..tostring(heat)..' ]\n```', 'user', true, _source, false)

	TriggerEvent('gangaccount:getGangAccount', DrugHandeler, function(account)
		account.addMoney(price)
	end)

	if gangCut > 0 then
		TriggerEvent('gangaccount:getGangAccount', 'gang_' .. xPlayer.gang.name, function(account)
			account.addMoney(gangCut)
			TriggerClientEvent('esx:showNotification', _source, _U('dealer_gang_tax', Config.GangTaxPercent, ESX.Math.GroupDigits(gangCut)))
		end)
	end

	-- Alert probability scales from Config.Heat.BaseAlertChance (at 0 heat) up to 100% (at max heat)
	local alertChance = math.min(100, Config.Heat.BaseAlertChance + heat)
	if math.random(1, 100) <= alertChance then
		AlertCopsDealerSale(_source, GetEntityCoords(GetPlayerPed(_source)), heat)
	end

	if heat >= Config.Heat.HighHeatThreshold then
		TriggerClientEvent('esx:showNotification', _source, _U('dealer_heat_high'))
	end

	TriggerClientEvent('esx:showNotification', _source, _U('dealer_sold', amount, xItem.label, ESX.Math.GroupDigits(netPrice)))
	TriggerClientEvent('esx_drugs:updateHeat', _source, heat, Config.Heat.Max)
end)

ESX.RegisterUsableItem('marijuana', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('marijuana', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'marijuana')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('cocaine', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('cocaine', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'cocaine')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('crack', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('crack', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'crack')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('meth', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('meth', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'meth')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('mushroom', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('mushroom', 1)

	TriggerClientEvent('esx_jk_drugs:useItem', source, 'mushroom')

	Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('heroine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('heroine', 1)

	TriggerClientEvent('esx_jk_drugs:useItem', source, 'heroine')

	Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('drugtest', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('drugtest', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'drugtest')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('fakepee', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('fakepee', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'fakepee')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('beer', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('beer', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'beer')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('tequila', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('tequila', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'tequila')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('vodka', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('vodka', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'vodka')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('whiskey', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('whiskey', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'whiskey')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('breathalyzer', function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('breathalyzer', 1)

		TriggerClientEvent('esx_jk_drugs:useItem', source, 'breathalyzer')

		Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('lsd', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('lsd', 1)
	TriggerClientEvent('esx_drugs:Cartel', source, 'lsd')
	Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('ecstasy', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ecstasy', 1)
	TriggerClientEvent('esx_drugs:Cartel', source, 'ecstasy')
	Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('desomorphine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('desomorphine', 1)
	TriggerClientEvent('esx_drugs:Cartel', source, 'desomorphine')
	Citizen.Wait(1000)
end)

ESX.RegisterUsableItem('sianor', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('sianor', 1)
	TriggerClientEvent('es_admin:kill',_source)
	Citizen.Wait(3000)
	TriggerClientEvent('es_admin:kill',_source)
end)

ESX.RegisterUsableItem('mahi_fugu', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('mahi_fugu', 1)
	TriggerClientEvent('es_admin:kill',_source)
	Citizen.Wait(3000)
	TriggerClientEvent('es_admin:kill',_source)
end)

function loop()
	DrugDealerItems.regen()

  	SetTimeout(1000*60*10, loop)
end

loop()

