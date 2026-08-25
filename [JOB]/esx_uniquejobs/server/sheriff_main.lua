ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}

local units = {}
local callsigns = {}

if Config_sheriff.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'sheriff', Config_sheriff.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'sheriff', _U('alert_sheriff'), true, true)

TriggerEvent('esx_society:registerSociety', 'sheriff', 'sheriff', 'society_law', 'society_sheriff', 'society_sheriff', {type = 'public'})

RegisterServerEvent('esx_sheriffjob:giveWeapon')
AddEventHandler('esx_sheriffjob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_sheriffjob:getStockItem')
AddEventHandler('esx_sheriffjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_sheriff armory just by calling this event with a valid
	-- item name. Restricted to actual sheriff employees.
	if not xPlayer or xPlayer.job.name ~= 'sheriff' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_sheriffjob:getStockItem without the sheriff job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

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

RegisterServerEvent('esx_sheriffjob:putStockItems')
AddEventHandler('esx_sheriffjob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'sheriff' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_sheriffjob:putStockItems without the sheriff job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

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

ESX.RegisterServerCallback('esx_sheriffjob:getVehicleInfos', function(source, cb, plate)

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

				if Config_sheriff.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_sheriffjob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_sheriff.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_sheriffjob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_sheriffjob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

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

ESX.RegisterServerCallback('esx_sheriffjob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

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

ESX.RegisterServerCallback('esx_sheriffjob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_sheriff', function(store)

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

ESX.RegisterServerCallback('esx_sheriffjob:buy', function(source, cb, amount)


	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_law', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_sheriffjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_sheriffjob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_sheriff', function(inventory)

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

ESX.RegisterServerCallback('esx_sheriffjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'sheriff')
	end
end)

RegisterServerEvent('esx_sheriffjob:message')
AddEventHandler('esx_sheriffjob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)

local panic = 0
local panicreqx = {}
local panicreqy = {}
local panicreqname = {}
local sentreq = {}

RegisterServerEvent('esx_sheriffjob:playSoundRadio')
AddEventHandler('esx_sheriffjob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "sheriff" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_sheriffjob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_sheriffjob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

function TableLength_sheriff(table)

	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count

end

RegisterServerEvent('logshVehicleSpawn')
AddEventHandler('logshVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_sheriff(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_sheriff(messages, titels, true)
	end

end)

function DiscordLogs_sheriff(messagess, titelss, grren)

	local discordWebhooks = {
		"https:// arshiahub.ir/changeme/1345568927786467348/utr8cJ16_M5dVZGr3OX676O66etTqRcG2Rgf5PHVa6qSRkMlhab35bPn22Aqcs1AcAgP",
		"https:// arshiahub.ir/changeme/1357843049677590579/BVrw8-Hb8-I8lDraSGDvd-HJ4WV48x04PVG1xAIp4FGQLUtG9rZrTJxCiCaaulmNk0R8"
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

RegisterServerEvent('logshPutItem')
AddEventHandler('logshPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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

RegisterServerEvent('logshGetItem')
AddEventHandler('logshGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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

RegisterServerEvent('logshBuyItem')
AddEventHandler('logshBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https:// arshiahub.ir/changeme/1357842548701528235/tFSBdkkJLmVHVm3O_xZuH81sFGUrEVCoDGWjyroa5v1U9qavN01gYoLds38x-Mq8PP_F"
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

RegisterServerEvent('logshGetWeapon')
AddEventHandler('logshGetWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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

RegisterServerEvent('logshPutWeapon')
AddEventHandler('logshPutWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https:// arshiahub.ir/changeme/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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

RegisterServerEvent('logshBuyWeapon')
AddEventHandler('logshBuyWeapon', function(playerName, serverID, steamHex, weaponLabel, buyCount, totalPrice)
    local discordWebhooks = {
        "https:// arshiahub.ir/changeme/1349756662772137994/6ggEOatvOw3ZOM2mNOW7QrvlU34RyYxA-UxC7SQf7GWmgG37gov34WugAiD3J1ghsFEA",
        "https:// arshiahub.ir/changeme/1357842548701528235/tFSBdkkJLmVHVm3O_xZuH81sFGUrEVCoDGWjyroa5v1U9qavN01gYoLds38x-Mq8PP_F"
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

RegisterServerEvent("ShBillingWebhook")
AddEventHandler("ShBillingWebhook", function(targetId, amount, reason)
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

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357841937176068199/uboih2jaZ7qXZBJbTtFsXJLRxyHLZXOwBKbe70gkUHKDvbk9O8vi1Kyk7s9r5ri-QdCu", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 BCSD Billing",
            color = 0x3498db,
            fields = {
                {name = "👮 Police ID", value = tostring(src), inline = true},
                {name = "👮 Police Name", value = executorName or "Unknown", inline = true},
                {name = "🆔 Police Hex", value = executorHex or "N/A", inline = true},
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

RegisterServerEvent("ShJailWebhook")
AddEventHandler("ShJailWebhook", function(targetId, jailTime, reason)
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

    PerformHttpRequest("https:// arshiahub.ir/changeme/1357841848093245681/9Ryt6tbfCRu4XZ5nIVz0_JBT3ITG3zk6Q3NBu-LZ8EPbx64kVbFy7OV-uEAO1-iH70uo", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 BCSD Jail",
            color = 0xe74c3c,
            fields = {
                {name = "👮 Police ID", value = tostring(src), inline = true},
                {name = "👮 Police IC Name", value = executorICName or "Unknown", inline = true},
                {name = "🆔 Police Hex", value = executorHex or "N/A", inline = true},
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