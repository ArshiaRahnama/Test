ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

	local count = 1
	if minerSkill == 100 then
		count = 2
	end

	-- lgdddd:actionItem (lc-inventory's real vehicle trunk) moves the item
	-- OUT OF the player's own inventory and into the trunk, so give it to
	-- the player first, then hand it straight over. lc-inventory shows its
	-- own success/weight-limit notification, so nothing else needed here.
	xPlayer.addInventoryItem("stone", count)
	TriggerEvent("lgdddd:actionItem", plate, class, "deposit", count, "stone")
	TriggerEvent('quest-miner:mine')
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
	if count <= 0 then return end

	-- "remove" hands `count` stone_piece from the real trunk into the
	-- player's own inventory (that's how lgdddd:actionItem works) -- take
	-- it straight back off them since this is a sale, not a pickup.
	TriggerEvent("lgdddd:actionItem", plate, class, "remove", count, "stone_piece")
	xPlayer.removeInventoryItem('stone_piece', count)

	local poull = count * 500
	xPlayer.addMoney(poull)
	TriggerEvent('quest-miner:sell')
	TriggerClientEvent('esx:showNotification', source, 'Shoma ~g~'..poull..'~w~ Pool Az Frosh Ajor Daryaft Kardid')
	TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Job : Miner ]\n[ Sold Count : '..tostring(count)..' ]\n[ Earned : '..tostring(poull)..' ]\n```', 'user', true, source, false)
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
	if Tedad == 0 then return end

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

	-- NOTE: the original condition here ("Tedad >= 200 or Tedad <= 300")
	-- was true for literally every number, so the original "else" branch
	-- was unreachable dead code either way -- kept the reward math as-is.
	local count1 = math.random(5, 60)
	local count2 = math.random(5, 50)
	local count3 = math.random(5, 40)
	local count4 = math.random(0, 7)

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