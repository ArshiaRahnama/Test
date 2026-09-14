ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local choppedPlates     = {}
local choppingInProgress = {}

local function trim(s)
	return s and s:gsub('^%s+', ''):gsub('%s+$', '') or s
end

ESX.RegisterServerCallback('carlock:isVehicleowned', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	plate = trim(plate)

	if not plate or plate == '' or not xPlayer then
		cb(false)
		return
	end

	exports.oxmysql:scalar('SELECT owner FROM owned_vehicles WHERE plate = ?', { plate }, function(owner)
		if not owner then

			cb(true)
			return
		end

		local isMine = (owner == xPlayer.identifier) or (xPlayer.gang and owner == xPlayer.gang.name)
		cb(not isMine)
	end)
end)

ESX.RegisterServerCallback('choped', function(source, cb, plate)
	plate = trim(plate)
	cb(choppedPlates[plate] == true)
end)

RegisterNetEvent('startchop')
AddEventHandler('startchop', function(vehNetId)
	local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
	if not DoesEntityExist(vehicle) then return end

	local plate = trim(GetVehicleNumberPlateText(vehicle))
	choppingInProgress[plate] = true
end)

RegisterNetEvent('chop:finish')
AddEventHandler('chop:finish', function(vehNetId, plate)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	plate = trim(plate)
	if not plate or plate == '' then return end

	if not choppingInProgress[plate] then

		return
	end

	choppingInProgress[plate] = nil
	choppedPlates[plate] = true

	local tier = math.random(1, 6)
	local item = 'engine' .. tier
	xPlayer.addInventoryItem(item, 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x ' .. item .. ' Daryaft Kardid!')
	TriggerEvent('DiscordBot:ToDiscord', 'rob', 'ChopShopLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Event : Chopped a vehicle for parts ]\n[ Plate : '..tostring(plate)..' ]\n[ Engine Tier Received : '..tostring(tier)..' ]\n```', 'user', true, src, false)
end)

local LOCKPICK_CRAFT_REQUIREMENTS = {
	{ item = 'shahkelid', count = 1 },
	{ item = 'iron',      count = 1 },
	{ item = 'blowtorch', count = 1 },
}

RegisterNetEvent('chop:craft')
AddEventHandler('chop:craft', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	for _, req in ipairs(LOCKPICK_CRAFT_REQUIREMENTS) do
		local invItem = xPlayer.getInventoryItem(req.item)
		if not invItem or invItem.count < req.count then
			TriggerClientEvent('esx:showNotification', src, 'Shoma Vasayel Kafi Baraye Craft Nadarid!')
			return
		end
	end

	for _, req in ipairs(LOCKPICK_CRAFT_REQUIREMENTS) do
		xPlayer.removeInventoryItem(req.item, req.count)
	end

	xPlayer.addInventoryItem('lockpick', 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Lockpick Craft Kardid!')
end)

RegisterNetEvent('chop:craftengine')
AddEventHandler('chop:craftengine', function(key)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	if not xPlayer.job or xPlayer.job.name ~= 'mechanic' then
		TriggerClientEvent('esx:showNotification', src, 'In Kar Faghat Baraye Mechanic Hast!')
		return
	end

	local requirements = ChopConfig.craftengine[key]
	if not requirements then return end

	local totalCost = 0
	for _, req in ipairs(requirements) do
		if req.type == 'money' then
			totalCost = totalCost + req.count
		end
	end



	if not xPlayer.canAfford(totalCost) then
		TriggerClientEvent('esx:showNotification', src, 'Pool Kafi Nadarid!')
		return
	end

	xPlayer.payAny(totalCost)
	xPlayer.addInventoryItem('engine' .. key, 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Engine X' .. key .. ' Craft Kardid!')
end)

RegisterNetEvent('chop:buypich')
AddEventHandler('chop:buypich', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end


	if not xPlayer.canAfford(ChopConfig.tokenzero) then
		TriggerClientEvent('esx:showNotification', src, 'Pool Kafi Nadarid!')
		return
	end

	xPlayer.payAny(ChopConfig.tokenzero)
	xPlayer.addInventoryItem('hotwire', 1)
	TriggerClientEvent('esx:showNotification', src, 'Shoma 1x Pich Goshti Kharidid!')
end)

RegisterNetEvent('chop:sell')
AddEventHandler('chop:sell', function(key)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local item = 'engine' .. key
	local invItem = xPlayer.getInventoryItem(item)
	if not invItem or invItem.count < 1 then
		TriggerClientEvent('esx:showNotification', src, 'Shoma In Item Ro Nadarid!')
		return
	end

	local rewards = ChopConfig.sell[key]
	if not rewards then return end

	xPlayer.removeInventoryItem(item, 1)

	local totalReward = 0
	for _, reward in ipairs(rewards) do
		if reward.type == 'money' then
			totalReward = totalReward + reward.count
		end
	end

	xPlayer.addMoney(totalReward)
	TriggerClientEvent('esx:showNotification', src, 'Shoma ' .. totalReward .. '$ Daryaft Kardid!')
	TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(src)..'(' .. src .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : Engine Tier '..tostring(key)..' (chop shop) ]\n[ Earned : '..tostring(totalReward)..' ]\n```', 'user', true, src, false)
end)
