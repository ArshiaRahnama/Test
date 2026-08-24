ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end
local Data_Storage = nil
RegisterServerEvent('esx_property:getstorage')
AddEventHandler('esx_property:getstorage', function(datastorage)
	Data_Storage = datastorage

end)

function SetPropertyOwned(name, price, rented, owner, storage_data)
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner, storage_data) VALUES (@name, @price, @rented, @owner, @storage_data)', {
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner,
		['@storage_data']  = storage_data
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, true)

			if rented then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rented_for', ESX.Math.GroupDigits(price)))
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for', ESX.Math.GroupDigits(price)))
			end
		end
	end)
end

function RemoveOwnedProperty(name, owner)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('made_property'))
		end
	end)
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil
			local storage_data = nil


			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end





			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,

				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				price     = properties[i].price,
				storage_data = properties[i].storage_data
			})

		end

		TriggerClientEvent('esx_property:sendProperties', -1, Config.Properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

AddEventHandler('esx_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner,
				storage_data = result[i].storage_data
			})
		end

		cb(properties)
	end)
end)

AddEventHandler('esx_property:setPropertyOwned', function(name, price, rented, owner, storage_data)
	SetPropertyOwned(name, price, rented, owner, storage_data)
end)

AddEventHandler('esx_property:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('esx_property:rentProperty')
AddEventHandler('esx_property:rentProperty', function(propertyName, storage_data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)
	local rent     = ESX.Math.Round(property.price / 200)

	SetPropertyOwned(propertyName, rent, true, xPlayer.identifier, storage_data)
end)

RegisterServerEvent('esx_property:buyProperty')
AddEventHandler('esx_property:buyProperty', function(propertyName, storage_data)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)

	if xPlayer.canAfford(property.price) then
		xPlayer.payAny(property.price)
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier, storage_data)
	else
		TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
	end
end)

RegisterServerEvent('esx_property:removeOwnedProperty')
AddEventHandler('esx_property:removeOwnedProperty', function(propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	RemoveOwnedProperty(propertyName, xPlayer.identifier)
end)

AddEventHandler('esx_property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('esx_property:saveLastProperty')
AddEventHandler('esx_property:saveLastProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)



	if GetResourceState('UNIQUE_AC') == 'started' then
		pcall(function()
			exports['UNIQUE_AC']:ExemptPlayer(source, 5000, { teleport = true, speed = true })
		end)
	end

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE identifier = @identifier', {
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:deleteLastProperty')
AddEventHandler('esx_property:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)



	if GetResourceState('UNIQUE_AC') == 'started' then
		pcall(function()
			exports['UNIQUE_AC']:ExemptPlayer(source, 5000, { teleport = true, speed = true })
		end)
	end

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:getItem')
AddEventHandler('esx_property:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getInventory', Data_Storage, xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)


			if count > 0 and inventoryItem.count >= count then


				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					local weaponArray = {
						{
						  ["color"] = "0059ff",
						  ["title"] = "Home 🔫 Weapon Log ",
						  ["description"] = "ID: **("..source..")**\nPlayer Name: **"..GetPlayerName(source).."**",
						  ["fields"] = {
							{
								["name"] = "Owner :",
								["value"] = "**"..xPlayerOwner.identifier.."**"
							},
							{
								["name"] = "Item name:",
								["value"] = "**"..item.."**"
							},
							{
							  ["name"] = "Count:",
							  ["value"] = "**"..count.."**"
							},
							{
							  ["name"] = "Time:",
							  ["value"] = "**"..os.date('%Y-%m-%d %H:%M:%S').."**"
							}
						  },
						  ["footer"] = {
						  ["text"] = "Unique Server RP Log System",
						  ["icon_url"] = "https://media.discordapp.net/attachments/946854641516285992/950662917093724170/Logo-Server-Discord.png?width=468&height=468",
						  }
						}
					  }
					TriggerEvent('DiscordBot:ToDiscord', "homeweapon", SystemName, weaponArray,'system', source, false, false)
					TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
			end
		end)

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getDataStore', Data_Storage, xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}
			local weaponName   = nil
			local ammo         = nil
			local ok		   = false
			local components   = nil

			for i=1, #storeWeapons, 1 do
				if storeWeapons[i].name == item then
					ok = true
					weaponName = storeWeapons[i].name
					ammo       = storeWeapons[i].ammo
					components = storeWeapons[i].components
					table.remove(storeWeapons, i)
					break
				end
			end
			if ok then
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
				for k,v in pairs(components) do
					xPlayer.addWeaponComponent(weaponName, v)
				end
				local weapon2Array = {
					{
					  ["color"] = "0059ff",
					  ["title"] = "Home 🔫 Weapon Log ",
					  ["description"] = "ID: **("..source..")**\nPlayer Name: **"..GetPlayerName(source).."**",
					  ["fields"] = {
						{
							["name"] = "Owner :",
							["value"] = "**"..xPlayerOwner.identifier.."**"
						},
						{
							["name"] = "Weapon name:",
							["value"] = "**"..item.."**"
						},
						{
						  ["name"] = "Ammo:",
						  ["value"] = "**"..count.."**"
						},
						{
						  ["name"] = "Time:",
						  ["value"] = "**"..os.date('%Y-%m-%d %H:%M:%S').."**"
						}
					  },
					  ["footer"] = {
					  ["text"] = "Mid Night Server RP Log System",
					  ["icon_url"] = "https://media.discordapp.net/attachments/946854641516285992/950662917093724170/Logo-Server-Discord.png?width=468&height=468",
					  }
					}
				  }
				TriggerEvent('DiscordBot:ToDiscord', "homeweapon", SystemName, weapon2Array,'system', source, false, false)
			end
		end)

	end
end)

RegisterServerEvent('esx_property:putItem')
AddEventHandler('esx_property:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		local playerItem = xPlayer.getInventoryItem(item)
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then

			local isvorod = false
			if string.sub(playerItem.name, 1, 7) == "CarKey|" and playerItemCount ~= 0 then

				isvorod = false
			else
				isvorod = true
			end

			if isvorod then
				TriggerEvent('esx_addoninventory:getInventory', Data_Storage, xPlayerOwner.identifier, function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					local ItemArray = {
						{
						["color"] = "0059ff",
						["title"] = "Home Item Log ",
						["description"] = "ID: **("..source..")**\nPlayer Name: **"..GetPlayerName(source).."**",
						["fields"] = {
							{
								["name"] = "Owner :",
								["value"] = "**"..xPlayerOwner.identifier.."**"
							},
							{
								["name"] = "Item name:",
								["value"] = "**"..item.."**"
							},
							{
							["name"] = "Count:",
							["value"] = "**"..count.."**"
							},
							{
							["name"] = "Time:",
							["value"] = "**"..os.date('%Y-%m-%d %H:%M:%S').."**"
							}
						},
						["footer"] = {
						["text"] = "Mid Night Server RP Log System",
						["icon_url"] = "https://media.discordapp.net/attachments/946854641516285992/950662917093724170/Logo-Server-Discord.png?width=468&height=468",
						}
						}
					}
					TriggerEvent('DiscordBot:ToDiscord', "homeitem", SystemName, ItemArray,'system', source, false, false)
					TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, inventory.getItem(item).label))
				end)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_weapon' then
		local weapo = xPlayer.hasWeapon(item)

		if weapo then
			TriggerEvent('esx_datastore:getDataStore', Data_Storage, xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}




				table.insert(storeWeapons, {
					name 	   = item,
					ammo   	   = weapo.ammo,
					components = weapo.components
				})

				store.set('weapons', storeWeapons)
				xPlayer.removeWeapon(item)




				local Item2Array = {
					{
					  ["color"] = "0059ff",
					  ["title"] = "Home 🔫 Weapon Log ",
					  ["description"] = "ID: **("..source..")**\nPlayer Name: **"..GetPlayerName(source).."**",
					  ["fields"] = {
						{
							["name"] = "Owner :",
							["value"] = "**"..xPlayerOwner.identifier.."**"
						},
						{
							["name"] = "Weapon name:",
							["value"] = "**"..item.."**"
						},
						{
						  ["name"] = "Ammo:",
						  ["value"] = "**"..count.."**"
						},
						{
						  ["name"] = "Time:",
						  ["value"] = "**"..os.date('%Y-%m-%d %H:%M:%S').."**"
						}
					  },
					  ["footer"] = {
					  ["text"] = "Mid Night Server RP Log System",
					  ["icon_url"] = "https://media.discordapp.net/attachments/946854641516285992/950662917093724170/Logo-Server-Discord.png?width=468&height=468",
					  }
					}
				  }
				TriggerEvent('DiscordBot:ToDiscord', "homeitem", SystemName, Item2Array,'system', source, false, false)
			end)
		end

	end
end)

ESX.RegisterServerCallback('esx_property:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			local propertyName = ownedProperties[i].name
			local exists = false

			for j=1, #Config.Properties, 1 do
				if Config.Properties[j].name == propertyName then
					exists = true
					break
				end
			end

			if exists then
				table.insert(properties, propertyName)
			else
				print(('[esx_property] WARNING: owned_properties has orphaned row for "%s" (owner: %s) — property no longer exists in "properties" table, skipping'):format(propertyName, xPlayer.identifier))
			end
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getLastProperty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT last_property FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		cb(users[1].last_property)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPropertyInventory', function(source, cb, owner)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local items      = {}
	local weapons    = {}

	TriggerEvent('esx_addoninventory:getInventory', Data_Storage, xPlayer.identifier, function(inventory)
		items = inventory.items or {}
	end)

	TriggerEvent('esx_datastore:getDataStore', Data_Storage, xPlayer.identifier, function(store)
		weapons = store.get('weapons') or {}
	end)

	cb({
		items      = items,
		weapons    = weapons
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items,
		weapons    = xPlayer.loadout
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)


			if xPlayer then
				xPlayer.removeBank(result[i].price)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rent', ESX.Math.GroupDigits(result[i].price)))





			end
		end
	end)
end

TriggerEvent('cron:runAt', 22, 0, PayRent)



