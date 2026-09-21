ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- FIX (hardening): helpers used by the events/callbacks below.
local function playersClose(a, b, maxDist)
	local pa, pb = GetPlayerPed(a), GetPlayerPed(b)
	if not pa or pa == 0 or not pb or pb == 0 then return false end
	return #(GetEntityCoords(pa) - GetEntityCoords(pb)) <= (maxDist or 6.0)
end

-- A player may read another player's inventory only if it is themselves,
-- they are standing next to them (frisk/search), or they are staff.
-- Before, the `target` sent by the client was trusted blindly, so anyone
-- could read anybody's items and money from anywhere on the map.
local function canViewInventory(src, target)
	target = tonumber(target)
	if not target then return false end
	if target == src then return true end
	local xSrc = ESX.GetPlayerFromId(src)
	if xSrc and (xSrc.permission_level or 0) > 1 then return true end
	return playersClose(src, target, 6.0)
end

RegisterServerEvent('esx_inventoryhud:getOwnerVehicle')
AddEventHandler('esx_inventoryhud:getOwnerVehicle', function()
	local _source = source
	local KeyItems = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	KeyItems = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	TriggerClientEvent("esx_inventoryhud:setOwnerVehicle", _source, KeyItems)

end)

RegisterServerEvent('esx_inventoryhud:getOwnerHouse')
AddEventHandler('esx_inventoryhud:getOwnerHouse', function()
	local _source = source
	local HouseItems = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	HouseItems = MySQL.Sync.fetchAll('SELECT * FROM owned_properties WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier
	})

	TriggerClientEvent("esx_inventoryhud:setOwnerHouse", _source, HouseItems)

end)

RegisterServerEvent('esx_inventoryhud:getOwnerAccessories')
AddEventHandler('esx_inventoryhud:getOwnerAccessories', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local AccessoriesItems = {}

	-- Accessories Helmet
	local Result_Helmet = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_helmet'
	})

	if Result_Helmet[1] then
		for k,v in pairs(Result_Helmet) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				name = "helmet",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["helmet_1"],
				itemskin = skin["helmet_2"]
			})
		end
	end

	-- Accessories Mask
	local Result_Mask = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_mask'
	})

	if Result_Mask[1] then
		for k,v in pairs(Result_Mask) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				name = "mask",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["mask_1"],
				itemskin = skin["mask_2"]
			})
		end
	end

	-- Accessories Glasses
	local Result_Glasses = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_glasses'
	})

	if Result_Glasses[1] then
		for k,v in pairs(Result_Glasses) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				name = "glasses",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["glasses_1"],
				itemskin = skin["glasses_2"]
			})
		end
	end

	-- Accessories Earring
	local Result_Earring = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'player_ears'
	})

	if Result_Earring[1] then
		for k,v in pairs(Result_Earring) do
			local skin = json.decode(v.skin)
			table.insert(AccessoriesItems, {
				label = v.label,
				count = 1,
				limit = -1,
				type = "item_accessories",
				name = "earring",
				usable = true,
				rare = false,
				canRemove = false,
				itemnum = skin["ears_1"],
				itemskin = skin["ears_2"]
			})
		end
	end

	TriggerClientEvent("esx_inventoryhud:setOwnerAccessories", _source, AccessoriesItems)

end)

RegisterServerEvent('esx_inventoryhud:updateKey')
AddEventHandler('esx_inventoryhud:updateKey', function(target, type, itemName)
	local _source = source
	target = tonumber(target)

	-- FIX (hardening): validate everything the client sent.
	if not target or target == _source then return end
	if type ~= "item_key" and type ~= "item_keyhouse" then return end
	if itemName == nil then return end

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if not sourceXPlayer or not targetXPlayer then return end
	if not playersClose(_source, target, 8.0) then
		TriggerClientEvent('esx:showNotification', _source, 'The player is too far away')
		return
	end

	-- use the same identifier the rest of the resource uses for owned_* tables
	-- (was GetPlayerIdentifiers()[1], which is not always xPlayer.identifier)
	local identifier = sourceXPlayer.identifier
	local identifier_target = targetXPlayer.identifier

	if type == "item_key" then -- vehicle key
		MySQL.Async.execute("UPDATE owned_vehicles SET owner = @newplayer, buyer = @newplayer WHERE owner = @identifier AND plate = @plate",
		{
			['@identifier']	= identifier,
			['@newplayer']	= identifier_target,
			['@plate']		= itemName
		})

		-- pNotify is not installed on this server (see client/inventory_main.lua),
		-- and the old texts were Thai. Using the built-in notification.
		TriggerClientEvent('esx:showNotification', _source, 'You gave the vehicle key ~y~' .. tostring(itemName))
		TriggerClientEvent('esx:showNotification', target, 'You received the vehicle key ~y~' .. tostring(itemName))

		TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", _source)
		TriggerClientEvent("esx_inventoryhud:getOwnerVehicle", target)

	elseif type == "item_keyhouse" then -- house key
		MySQL.Async.execute("UPDATE owned_properties SET owner = @newplayer WHERE owner = @identifier AND id = @id",
		{
			['@identifier']	= identifier,
			['@newplayer']	= identifier_target,
			['@id']			= itemName
		})

		TriggerClientEvent('esx:showNotification', _source, 'You gave a house key')
		TriggerClientEvent('esx:showNotification', target, 'You received a house key')

		TriggerClientEvent("esx_inventoryhud:getOwnerHouse", _source)
		TriggerClientEvent("esx_inventoryhud:getOwnerHouse", target)
	end
end)

RegisterServerCallbackSafe("esx_inventoryhud:getPlayerInventory", function(source, cb, target)

	if not canViewInventory(source, target) then return cb(nil) end
	local xPlayer = ESX.GetPlayerFromId(target)
--	local Inventory = targetXPlayer.inventory

	if xPlayer ~= nil then
		cb({inventory = xPlayer.inventory, money = xPlayer.money, accounts = xPlayer.accounts, weapons = xPlayer.loadout})
	else
		cb(nil)
	end

end)

RegisterServerCallbackSafe("esx_inventoryhud:getPlayerInventory2323", function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)




	local items = {}
	local items2      = {}
	local weapons    = {}

	
		items2 = xPlayer.inventory or {}

	
	
		weapons = xPlayer.loadout or {}

		local cash = xPlayer.money
		if cash > 0 then
			table.insert(items, {
				type = 'item_money',
				name = 'cash',
				label = 'Money',
				count = cash,
				peso = 0,
				filter = 'box'
			}) 
		end


	for k,v in pairs(weapons) do
		if v.name ~= nil then
			if string.lower(v.name) == 'weapon_sniperrifle' then

			elseif string.lower(v.name) == 'weapon_heavysniper' then

			else
				table.insert(items, {
					type = 'item_weapon',
					name = v.name,
					label = v.label,
					count = v.ammo,
					peso = ESX.getWeaponWeight and ESX.getWeaponWeight(v.name) or 2,
					filter = 'arma',
					-- serial generated by essentialmode (ESX.GenerateWeaponSerial):
					-- LAW-xxxxx-xxxx / DOJ-... / GANG-...
					serial = v.serial or ''
				})
			end
		end
	end

	for k,v in pairs(items2) do
		if v.name ~= nil then
			if v.count > 0 then
				table.insert(items, {
					type = 'item_standard',
					name = v.name,
					label = v.label,
					count = v.count,
					peso = ESX.getItemWeight and ESX.getItemWeight(v.name) or 0.5,
					filter = 'food'
				})
			end
		end
	end

	-- FIX: total/max weight used to be hardcoded client-side to 1000/4000
	-- no matter what was actually carried (visible on the identity/pocket
	-- circle as a static "1000.0/4000.0" that never moved). Now computed
	-- for real: sum of each item's peso * count, against a configurable
	-- cap.
	-- FIX: a weapon's "count" is its AMMO, not a stack size. Multiplying the
	-- weapon weight by the ammo made every gun weigh e.g. 2kg x 154 = 308kg
	-- (that's how the pocket showed 3254.5/90). A weapon weighs its own
	-- weight once - same as essentialmode's player.lua does.
	local totalWeight = 0
	for k, v in ipairs(items) do
		if v.type == 'item_weapon' then
			totalWeight = totalWeight + (v.peso or 0)
		else
			totalWeight = totalWeight + ((v.peso or 0) * (v.count or 1))
		end
	end


	


	if xPlayer ~= nil then
		cb({
			inventory = items,
			atualPeso = math.floor(totalWeight * 10) / 10,
			maximoPeso = HudConfig.MaxInventoryWeight or 90,
		})
	else
		cb(nil)
	end

end)

RegisterServerCallbackSafe("esx_inventoryhud:getPlayerInventory1", function(source, cb, target, data)

	if not canViewInventory(source, target) then return cb(nil) end
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer == nil then return cb(nil) end

	-- FIX: this used to be `Inventory = xPlayer.inventory` and then table.insert()
	-- keys/accessories straight into it - i.e. into the player's LIVE inventory,
	-- duplicating those entries again on every call. Work on a copy instead.
	local Inventory = {}
	for _, it in ipairs(xPlayer.inventory or {}) do Inventory[#Inventory + 1] = it end

	if data == nil then
		if xPlayer ~= nil then
			cb({inventory = Inventory, money = xPlayer.money, accounts = xPlayer.accounts, weapons = xPlayer.loadout})
		else
			cb(nil)
		end
	else

		if data.vehicle == true then

			local Vehicle_Key = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
				['@identifier'] = xPlayer.identifier
			})

			for i=1, #Vehicle_Key, 1 do
				table.insert(Inventory, {
					label = Vehicle_Key[i].plate,
					count = 1,
					limit = -1,
					type = "item_key",
					name = "key",
					usable = true,
					rare = false,
					canRemove = false
				})
			end
			
		end

		if data.house == true then

			local Properties_Key = MySQL.Sync.fetchAll('SELECT * FROM owned_properties WHERE owner = @identifier', {
				['@identifier'] = xPlayer.identifier
			})

			for i=1, #Properties_Key, 1 do
				table.insert(Inventory, {
					label = Properties_Key[i].name,
					count = 1,
					limit = -1,
					type = "item_keyhouse",
					name = "keyhouse",
					usable = false,
					rare = false,
					canRemove = false,
					house_id = Properties_Key[i].id
				})
			end
		end

		-- Accessories Helmet
		local Result_Helmet = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
			['@owner'] = xPlayer.identifier,
			['@type'] = 'player_helmet'
		})

		if Result_Helmet[1] then
			for k,v in pairs(Result_Helmet) do
				local skin = json.decode(v.skin)
				table.insert(Inventory, {
					label = v.label,
					count = 1,
					limit = -1,
					type = "item_accessories",
					name = "helmet",
					usable = true,
					rare = false,
					canRemove = false,
					itemnum = skin["helmet_1"],
					itemskin = skin["helmet_2"]
				})
			end
		end

		-- Accessories Mask
		local Result_Mask = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
			['@owner'] = xPlayer.identifier,
			['@type'] = 'player_mask'
		})

		if Result_Mask[1] then
			for k,v in pairs(Result_Mask) do
				local skin = json.decode(v.skin)
				table.insert(Inventory, {
					label = v.label,
					count = 1,
					limit = -1,
					type = "item_accessories",
					name = "mask",
					usable = true,
					rare = false,
					canRemove = false,
					itemnum = skin["mask_1"],
					itemskin = skin["mask_2"]
				})
			end
		end

		-- Accessories Glasses
		local Result_Glasses = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
			['@owner'] = xPlayer.identifier,
			['@type'] = 'player_glasses'
		})

		if Result_Glasses[1] then
			for k,v in pairs(Result_Glasses) do
				local skin = json.decode(v.skin)
				table.insert(Inventory, {
					label = v.label,
					count = 1,
					limit = -1,
					type = "item_accessories",
					name = "glasses",
					usable = true,
					rare = false,
					canRemove = false,
					itemnum = skin["glasses_1"],
					itemskin = skin["glasses_2"]
				})
			end
		end

		-- Accessories Earring
		local Result_Earring = MySQL.Sync.fetchAll('SELECT * FROM meeta_accessory_inventory WHERE owner = @owner AND type = @type', {
			['@owner'] = xPlayer.identifier,
			['@type'] = 'player_ears'
		})

		if Result_Earring[1] then
			for k,v in pairs(Result_Earring) do
				local skin = json.decode(v.skin)
				table.insert(Inventory, {
					label = v.label,
					count = 1,
					limit = -1,
					type = "item_accessories",
					name = "earring",
					usable = true,
					rare = false,
					canRemove = false,
					itemnum = skin["ears_1"],
					itemskin = skin["ears_2"]
				})
			end
		end

		if xPlayer ~= nil then
			cb({inventory = Inventory, money = xPlayer.getMoney(), accounts = xPlayer.accounts, weapons = xPlayer.loadout})
		else
			cb(nil)
		end
	end

end)

RegisterServerCallbackSafe("esx_inventoryhud:GetHouseItems", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = {}
	local items2      = {}
	local weapons    = {}

	TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayer.identifier, function(inventory)
		items2 = inventory.items
	end)
	
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		weapons = store.get('weapons') or {}
	end)

	for k,v in pairs(weapons) do
		if string.lower(v.name) == 'weapon_sniperrifle' then

		elseif string.lower(v.name) == 'weapon_heavysniper' then

		else
			table.insert(items, {
				type = 'item_weapon',
				name = v.name,
				label = ESX.GetWeaponLabel(v.name),
				count = v.ammo.ammo
			})
		end
	end

	for k,v in pairs(items2) do
		if v.count > 0 then
			table.insert(items, {
				type = 'item_standard',
				name = v.name,
				label = v.label,
				count = v.count
			})
		end
	end

	
		
	cb(items)
end)

RegisterServerCallbackSafe("esx_inventoryhud:GetData", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		cb({})
		return
	end

	-- FIX: this used to run `SELECT btc, phone FROM users ...`, but the
	-- `users` table has no `btc` column at all, so that query errored
	-- out and the MySQL callback never ran -> cb() was never called ->
	-- MyData stayed an empty table for the whole session (that's why
	-- Phone Number / Steam Hex showed "N/A" and Bitcoin showed "0" no
	-- matter what). Selecting real columns fixes that, and the identity
	-- card's old "Bitcoin" row now shows the player's actual Coin
	-- balance (see config.js: registro label).
	MySQL.Async.fetchAll('SELECT coin, phone FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(data)
		local row = (data and data[1]) or {}

		-- xPlayer.identifier follows the server's configured primary
		-- identifier (could be license/discord/etc), so pull the actual
		-- steam: identifier explicitly for the "Steam Hex" field.
		local steamHex = xPlayer.identifier
		for _, id in ipairs(GetPlayerIdentifiers(source)) do
			if string.sub(id, 1, 6) == "steam:" then
				steamHex = id
				break
			end
		end

		cb({
			steam = steamHex,
			coin = row.coin or 0,
			phone = row.phone or "N/A",
			money = xPlayer.money,
			bank = xPlayer.bank,
			name = xPlayer.name
		})
	end)
end)

