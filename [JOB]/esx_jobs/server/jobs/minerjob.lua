ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================
-- esx_uniquejobs' oversight/ module (Job Watch) is optional -- see
-- server/main.lua's copy of this same wrapper for the full
-- explanation. Duplicated here (rather than shared) because Lua
-- resources can't require() each other's files across a boundary.
-- ============================================================
local OVERSIGHT_RESOURCE = 'esx_uniquejobs'
local function OvUp() return GetResourceState(OVERSIGHT_RESOURCE) == 'started' end
local function OvPayout(source, job, gross)
	if not OvUp() then return gross end
	local ok, result = pcall(function() return exports[OVERSIGHT_RESOURCE]:ProcessJobPayout(source, job, gross) end)
	if not ok or type(result) ~= 'table' or not result.net then return gross end
	return result.net
end
local function OvReport(source, job, items, money)
	if not OvUp() then return end
	TriggerEvent('esx_uniquejobs:oversight:activity', source, job, 'tick', items, money, 'mine')
end

-- ============================================================
-- SECURITY NOTE (read before touching SellStone / WashStonePieces /
-- PutStoneInVehicle below):
--
-- The real vehicle trunk lives in a resource called `lgdddd`, which
-- is NOT part of this repository (grep the whole repo for "lgdddd"
-- -- only this file and its client twin reference it; there is no
-- `RegisterServerCallback('lgdddd:getChestVehicle', ...)` anywhere
-- to re-query it server-side). That means these three handlers
-- cannot independently verify "does this player's trunk actually
-- contain the stone/stone_piece they claim" the way, say,
-- Unique_inventory's `esx_trunk:getSharedDataStore` event would let
-- an in-repo handler do. Until `lgdddd` (or whatever replaces it)
-- exposes a server-to-server way to read a trunk's contents, the
-- mitigations below (hard per-call caps + a cooldown + Job Watch
-- rate/income anomaly flags) are what stands between this event and
-- an unlimited money/item duplication exploit -- they reduce the
-- damage a modified client can do per minute, they do not close the
-- hole. Wiring in a real check the moment `lgdddd` exposes one
-- should be treated as a priority fix, not a nice-to-have.
-- ============================================================
local MAX_WASH_PER_CALL = 300   -- matches the TaskSystem:GharbaleSang threshold at 290 below
local MAX_SELL_PER_CALL = 500
local lastCall = {} -- lastCall[source][event] = os.time()

local function OnCooldown(source, key, seconds)
	lastCall[source] = lastCall[source] or {}
	local now = os.time()
	if lastCall[source][key] and now - lastCall[source][key] < seconds then return true end
	lastCall[source][key] = now
	return false
end

AddEventHandler('playerDropped', function() lastCall[source] = nil end)

local PLayersOnduty = {}
RegisterNetEvent('Miner:SetDuty')
AddEventHandler('Miner:SetDuty',function(status)
local xPlayer = ESX.GetPlayerFromId(source)
	PLayersOnduty[xPlayer.identifier] = status
end)
ESX.RegisterServerCallback('Miner:SetDuty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(PLayersOnduty[xPlayer.identifier])
end)
function MineManager()
	local self = {}
	self.get = function(k)
		return self[k]
	end

	self.regen	= function()
		self.gold	= math.random(500, 600)
		self.iron		= math.random(400, 500)
		TriggerClientEvent('esx_miner:getPrice', -1, {
			{name = 'gold' 	, price = self.gold},
			{name = 'iron'  , price = self.iron},
		})
	end

	return self
end

RegisterServerEvent('mining:PutStoneInVehicle')
AddEventHandler('mining:PutStoneInVehicle', function(plate, minerSkill, class)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if xPlayer.job.name ~= 'miner' then
		TriggerClientEvent('esx:showNotification', source, "~r~You need to be a miner to do this.")
		return
	end
	if OnCooldown(source, 'mine', 2) then return end

	local count = 1
	if minerSkill == 100 then
		count = 2
	end

	-- lgdddd:actionItem (esx_inventory's real vehicle trunk) moves the item
	-- OUT OF the player's own inventory and into the trunk, so give it to
	-- the player first, then hand it straight over. esx_inventory shows its
	-- own success/weight-limit notification, so nothing else needed here.
	xPlayer.addInventoryItem("stone", count)
	TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count, "stone")
	TriggerEvent('quest-miner:mine')
	OvReport(source, 'miner', { stone = count }, 0)
end)

RegisterServerEvent('mining:SellStone')
AddEventHandler('mining:SellStone', function(plate, class, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if xPlayer.job.name ~= 'miner' then
		TriggerClientEvent('esx:showNotification', source, "~r~You need to be a miner to do this.")
		return
	end

	count = tonumber(count) or 0
	if count <= 0 or count ~= math.floor(count) then return end
	count = math.min(count, MAX_SELL_PER_CALL) -- see the SECURITY NOTE above -- this is a damage cap, not a real balance check
	if OnCooldown(source, 'sell', 2) then return end

	-- "remove" hands `count` stone_piece from the real trunk into the
	-- player's own inventory (that's how lgdddd:actionItem works) -- take
	-- it straight back off them since this is a sale, not a pickup.
	TriggerEvent("lgdddd:actionItem", plate, class, "remove", count, "stone_piece")
	xPlayer.removeInventoryItem('stone_piece', count)

	local gross = count * 500
	local net = OvPayout(source, 'miner', gross)
	xPlayer.addMoney(net)
	OvReport(source, 'miner', { stone_piece = count }, net)
	TriggerEvent('quest-miner:sell')
	TriggerClientEvent('esx:showNotification', source, 'Shoma ~g~'..net..'~w~ Pool Az Frosh Ajor Daryaft Kardid')
	TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Job : Miner ]\n[ Sold Count : '..tostring(count)..' ]\n[ Earned : '..tostring(net)..' ]\n```', 'user', true, source, false)
end)

RegisterServerEvent('mining:WashStonePieces')
AddEventHandler('mining:WashStonePieces', function(plate, class, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if xPlayer.job.name ~= 'miner' then
		TriggerClientEvent('esx:showNotification', source, "~r~You need to be a miner to do this.")
		return
	end

	local Tedad = tonumber(count) or 0
	if Tedad <= 0 or Tedad ~= math.floor(Tedad) then return end
	Tedad = math.min(Tedad, MAX_WASH_PER_CALL) -- see the SECURITY NOTE above -- this is a damage cap, not a real balance check
	if OnCooldown(source, 'wash', 5) then return end

	if Tedad >= 290 then
		TriggerClientEvent('TaskSystem:GharbaleSang', source)
	end

	TriggerClientEvent('mining:WashStonePieces_cl', source)
	TriggerClientEvent("esx_miner:Gharbale", source)

	-- take the raw "stone" out of the real trunk (same give-then-take
	-- pattern as above, since lgdddd:actionItem only moves things through
	-- the player's own inventory)
	TriggerEvent("lgdddd:actionItem", plate, class, "remove", Tedad, "stone")
	xPlayer.removeInventoryItem('stone', Tedad)

	-- Reward is scaled to Tedad (out of a max wash batch of 300), not a flat
	-- random roll independent of how much stone was actually claimed -- the
	-- original version handed out full random rolls (stone_piece up to 60,
	-- iron up to 50, gold up to 40, diamond up to 7) no matter what `count`
	-- was, which is what let this event be spammed with any nonzero count
	-- for max reward every time.
	local scale = Tedad / MAX_WASH_PER_CALL
	local count1 = math.floor(math.random(5, 60) * scale)
	local count2 = math.floor(math.random(5, 50) * scale)
	local count3 = math.floor(math.random(5, 40) * scale)
	local count4 = (math.random() < (0.25 * scale)) and 1 or 0 -- diamond stays rare regardless of batch size

	if count1 > 0 then
		xPlayer.addInventoryItem('stone_piece', count1)
		TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count1, "stone_piece")
	end
	if count2 > 0 then
		xPlayer.addInventoryItem('iron_piece', count2)
		TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count2, "iron_piece")
	end
	if count3 > 0 then
		xPlayer.addInventoryItem('gold_piece', count3)
		TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count3, "gold_piece")
	end
	if count4 > 0 then
		xPlayer.addInventoryItem('diamond', count4)
		TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count4, "diamond")
	end

	OvReport(source, 'miner', { stone = Tedad, stone_piece = count1, iron_piece = count2, gold_piece = count3, diamond = count4 }, 0)
end)

RegisterServerEvent('mining:MeltItems')
AddEventHandler('mining:MeltItems', function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if xPlayer.job.name ~= 'miner' then
        TriggerClientEvent('esx:showNotification', source, "~r~You need to be a miner to do this.")
        return
    end

    -- SECURITY FIX: this used to unconditionally give the refined item and
    -- try to remove 20 raw pieces regardless of whether the player actually
    -- had 20 -- with no balance check, a player with 0 (or any amount less
    -- than 20) raw pieces could spam this event for unlimited free
    -- gold/iron.
    if type == "gold_piece" then
        local item = xPlayer.getInventoryItem("gold_piece")
        if not item or item.count < 20 then return end
        xPlayer.addInventoryItem('gold', 1)
        xPlayer.removeInventoryItem('gold_piece', 20)
    elseif type == "iron_piece" then
        local item = xPlayer.getInventoryItem("iron_piece")
        if not item or item.count < 20 then return end
        xPlayer.addInventoryItem('iron', 1)
        xPlayer.removeInventoryItem('iron_piece', 20)
    end
end)