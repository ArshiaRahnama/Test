ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}


if Config_cid.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'CID', Config_cid.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'cid', _U('alert_cid'), true, true)

TriggerEvent('esx_society:registerSociety', 'cid', 'CID', 'society_doj', 'society_cid', 'society_cid', {type = 'public'})

-- SECURITY FIX: had NO job check at all -- any connected player, regardless of job, could TriggerServerEvent this directly and get any
-- weapon with any ammo count for free. getStockItem/putStockItems in this same file were already fixed with this exact check; this one was
-- missed.
RegisterServerEvent('esx_cidjob:giveWeapon')
AddEventHandler('esx_cidjob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.job.name ~= 'cid' then return end
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_cidjob:getStockItem')
AddEventHandler('esx_cidjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_cid armory just by calling this event with a valid
	-- item name. Restricted to actual cid employees.
	if not xPlayer or xPlayer.job.name ~= 'cid' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_cidjob:getStockItem without the cid job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cid', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', source, true, false)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_cidjob:putStockItems')
AddEventHandler('esx_cidjob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'cid' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_cidjob:putStockItems without the cid job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cid', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)


ESX.RegisterServerCallback('esx_cidjob:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_cid.EnableESXIdentity then
					retrivedInfo.owner = result2[1].playerName
				else
					retrivedInfo.owner = result2[1].name
				end

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_cidjob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_cid.EnableESXIdentity then
					cb(string.gsub(result2[1].playerName, "_", " "), true)
				else
					cb(string.gsub(result2[1].playerName, "_", " "), true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_cidjob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cid', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_cidjob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cid', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_cidjob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cid', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + tedad
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = tonumber(tedad)
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_cidjob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cid', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then

				weapons[i].count = weapons[i].count - 1


				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_cidjob:buy', function(source, cb, amount)


	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_cidjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cid', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_cidjob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cid', function(inventory)

		local weapons = inventory.items

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + tedad
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = tonumber(tedad)
			})
		end

		inventory.addItem(weaponName, tonumber(tedad))
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_cidjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'cid')
	end
end)

RegisterServerEvent('esx_cidjob:message')
AddEventHandler('esx_cidjob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)


RegisterServerEvent('esx_cidjob:playSoundRadio')
AddEventHandler('esx_cidjob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "cid" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_cidjob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_cidjob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

RegisterServerEvent("cid:ShotsAlarm")
AddEventHandler("cid:ShotsAlarm", function(x,y,z,s)
	local xPlayers = ESX.GetPlayers()
	 if GetPlayerRoutingBucket( source )  == 0  then
		TriggerClientEvent("cid:ShotsAlarm", -1  , x,y,z,s)
	 end


end)


RegisterServerEvent('logMTVehicleSpawn')
AddEventHandler('logMTVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_cid(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_cid(messages, titels, true)
	end

end)

function DiscordLogs_cid(messagess, titelss, grren)

	local discordWebhooks = {
		GetConvar('unique_cid_main_wh1', ''),
		GetConvar('unique_cid_main_wh2', '')
	}

	local colors = 0

	if grren then
		colors = 65280
	else
		colors = 16711680
	end



    local logMessage = {
        {
			["color"] = colors,
			["title"] = titelss,
			["fields"] = messagess,

            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            }
        }
    }

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers)

        end, 'POST', json.encode({username = "Vehicle Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent('logMTPutItem')
AddEventHandler('logMTPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_cid_main_wh4', '')
    }

    local logMessage = {
        {
            ["color"] = 65280,
            ["title"] = "**📥 Gozashtan Item 📥**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Jib", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Gozasht Item", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logMTGetItem')
AddEventHandler('logMTGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_cid_main_wh4', '')
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**📤 Bardashtan Item 📤**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Inventory", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Item Bardashti", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logMTBuyItem')
AddEventHandler('logMTBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh5', ''),
        GetConvar('unique_cid_main_wh6', '')
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🛒 Buy Item 🛒**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "📦 Item Dar Inventory", ["value"] = itemLabel, ["inline"] = false},
                {["name"] = "🔢 Kharid", ["value"] = tostring(itemCount), ["inline"] = false},
                {["name"] = "💰 Price", ["value"] = "$" .. tostring(itemPrice), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logMTGetWeapon')
AddEventHandler('logMTGetWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_cid_main_wh4', '')
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🔫 Bardashtan Aslahe 🔫**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false},
                {["name"] = "🔢 Tedad Tir", ["value"] = tostring(ammoCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logMTPutWeapon')
AddEventHandler('logMTPutWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_cid_main_wh4', '')
    }

    local logMessage = {
        {
            ["color"] = 65280,
            ["title"] = "**🔫 Gozashtan Aslahe Dar Armory 🔫**",
            ["fields"] = {
                {["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false},
                {["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false},
                {["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false},
                {["name"] = "🔢 Tedad Tir", ["value"] = tostring(ammoCount), ["inline"] = false},
                {["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false}
            },
            ["footer"] = {["text"] = os.date("%Y-%m-%d %H:%M:%S")}
        }
    }

    for _, webhook in pairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logMTBuyWeapon')
AddEventHandler('logMTBuyWeapon', function(playerName, serverID, steamHex, weaponLabel, buyCount, totalPrice)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh5', ''),
        GetConvar('unique_cid_main_wh6', '')
    }

    local logMessage = {
        {
            ["color"] = 16711680,
            ["title"] = "**🛒 Kharid Aslahe 🛒**",
            ["fields"] = {
                { ["name"] = "👤 Player Name", ["value"] = playerName, ["inline"] = false },
                { ["name"] = "🎮 Steam Hex", ["value"] = steamHex, ["inline"] = false },
                { ["name"] = "🔫 Aslahe", ["value"] = weaponLabel, ["inline"] = false },
                { ["name"] = "🔢 Tedad Kharidari", ["value"] = tostring(buyCount), ["inline"] = false },
                { ["name"] = "💰 Gheymat", ["value"] = "$" .. tostring(totalPrice), ["inline"] = false },
                { ["name"] = "🌍 Server ID", ["value"] = serverID, ["inline"] = false }
            },
            ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Weapon Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent("CidBillingWebhook")
AddEventHandler("CidBillingWebhook", function(targetId, amount, reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    local executorName = xPlayer.name
    local targetName = xTarget.name

    local executorHex = xPlayer.identifier
    local targetHex = xTarget.identifier

    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local unixTime = os.time()

    if LogCriminalRecord then
        LogCriminalRecord(targetHex, 'charge', reason .. ' ($' .. tostring(amount) .. ')', executorName, executorHex, nil)
    end

    PerformHttpRequest(GetConvar('unique_cid_main_wh7', ''), function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 LSMT Billing",
            color = 0x3498db,
            fields = {
                {name = "👮 Cid ID", value = tostring(src), inline = true},
                {name = "👮 Cid Name", value = executorName or "Unknown", inline = true},
                {name = "🆔 Cid Hex", value = executorHex or "N/A", inline = true},
                {name = "🧍 Player ID", value = tostring(targetId), inline = true},
                {name = "🧍 Player Name", value = targetName or "Unknown", inline = true},
                {name = "🆔 Player Hex", value = targetHex or "N/A", inline = true},
                {name = "💰 Amount", value = "$" .. tostring(amount), inline = true},
                {name = "📝 Reason", value = reason or "N/A", inline = false},
                {name = "🕒 Time", value = timestamp, inline = true},
                {name = "📅 Unix Timestamp", value = tostring(unixTime), inline = true}
            },
            timestamp = timestamp
        }}
    }), {['Content-Type'] = 'application/json'})
end)

RegisterServerEvent("CidJailWebhook")
AddEventHandler("CidJailWebhook", function(targetId, jailTime, reason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not xTarget then return end

    local executorICName = xPlayer.name
    local targetICName = xTarget.name

    local executorHex = xPlayer.identifier
    local targetHex = xTarget.identifier

    local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    local unixTime = os.time()

    if LogCriminalRecord then
        LogCriminalRecord(targetHex, 'arrest', reason, executorICName, executorHex, jailTime)
    end

    PerformHttpRequest(GetConvar('unique_cid_main_wh8', ''), function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 LSMT Jail",
            color = 0xe74c3c,
            fields = {
                {name = "👮 Cid ID", value = tostring(src), inline = true},
                {name = "👮 Cid IC Name", value = executorICName or "Unknown", inline = true},
                {name = "🆔 Cid Hex", value = executorHex or "N/A", inline = true},
                {name = "🧍‍♂️ Player ID", value = tostring(targetId), inline = true},
                {name = "🧍‍♂️ Player IC Name", value = targetICName or "Unknown", inline = true},
                {name = "🆔 Player Hex", value = targetHex or "N/A", inline = true},
                {name = "⏱ Jail Time", value = tostring(jailTime) .. " minutes", inline = true},
                {name = "📋 Reason", value = reason or "No reason given", inline = false},
                {name = "🕒 Time", value = timestamp, inline = true},
                {name = "📅 Unix Timestamp", value = tostring(unixTime), inline = true}
            },
            timestamp = timestamp
        }}
    }), {['Content-Type'] = 'application/json'})
end)