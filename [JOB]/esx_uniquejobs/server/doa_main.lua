ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}

local units = {}
local callsigns = {}

if Config_doa.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'doa', Config_doa.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'doa', _U('alert_doa'), true, true)

TriggerEvent('esx_society:registerSociety', 'doa', 'doa', 'society_doj', 'society_doa', 'society_doa', {type = 'public'})

-- SECURITY FIX: had NO job check at all -- any connected player, regardless of job, could TriggerServerEvent this directly and get any
-- weapon with any ammo count for free. getStockItem/putStockItems in this same file were already fixed with this exact check; this one was
-- missed.
RegisterServerEvent('esx_doajob:giveWeapon')
AddEventHandler('esx_doajob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.job.name ~= 'doa' then return end
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_doajob:getStockItem')
AddEventHandler('esx_doajob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_doa armory just by calling this event with a valid
	-- item name. Restricted to actual doa employees.
	if not xPlayer or xPlayer.job.name ~= 'doa' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_doajob:getStockItem without the doa job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doa', function(inventory)

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

RegisterServerEvent('esx_doajob:putStockItems')
AddEventHandler('esx_doajob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'doa' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_doajob:putStockItems without the doa job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doa', function(inventory)

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

ESX.RegisterServerCallback('esx_doajob:getVehicleInfos', function(source, cb, plate)

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

				if Config_doa.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_doajob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_doa.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_doajob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doa', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_doajob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doa', function(store)

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

ESX.RegisterServerCallback('esx_doajob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doa', function(store)

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

ESX.RegisterServerCallback('esx_doajob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_doa', function(store)

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

ESX.RegisterServerCallback('esx_doajob:buy', function(source, cb, amount)


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

ESX.RegisterServerCallback('esx_doajob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doa', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_doajob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_doa', function(inventory)

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

ESX.RegisterServerCallback('esx_doajob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'doa')
	end
end)

RegisterServerEvent('esx_doajob:message')
AddEventHandler('esx_doajob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)

local panic = 0
local panicreqx = {}
local panicreqy = {}
local panicreqname = {}
local sentreq = {}

RegisterServerEvent('esx_doajob:playSoundRadio')
AddEventHandler('esx_doajob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "doa" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_doajob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_doajob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

function TableLength_doa(table)

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

		DiscordLogs_doa(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_doa(messages, titels, true)
	end

end)

function DiscordLogs_doa(messagess, titelss, grren)

	local discordWebhooks = {
		"https://discord.com/api/webhooks/1345568927786467348/utr8cJ16_M5dVZGr3OX676O66etTqRcG2Rgf5PHVa6qSRkMlhab35bPn22Aqcs1AcAgP",
		"https://discord.com/api/webhooks/1357843049677590579/BVrw8-Hb8-I8lDraSGDvd-HJ4WV48x04PVG1xAIp4FGQLUtG9rZrTJxCiCaaulmNk0R8"
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
        "https://discord.com/api/webhooks/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https://discord.com/api/webhooks/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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
        "https://discord.com/api/webhooks/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https://discord.com/api/webhooks/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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
        "https://discord.com/api/webhooks/1345576571213451354/I33wnKXU8kq6_uC89d-eWn3uylFlfGFCQiNrBJpLKAuEgWOoNwzS5qEzB6VTtMlvlKXx",
        "https://discord.com/api/webhooks/1357842548701528235/tFSBdkkJLmVHVm3O_xZuH81sFGUrEVCoDGWjyroa5v1U9qavN01gYoLds38x-Mq8PP_F"
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
        "https://discord.com/api/webhooks/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https://discord.com/api/webhooks/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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
        "https://discord.com/api/webhooks/1345576471233560596/zrT1_rb8_Wx0GM02feSbCOztpbOfkdfrtXLISAxpJKnbdNqsKF-vULEaR1gbTA-9nALE",
        "https://discord.com/api/webhooks/1357842668536856746/6fqR37TuRq754vAIkXYWD5yFaxsgMjbjzxZXyHU3q27-JchKlyp3EItDuXN83E6Kl00V"
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
        "https://discord.com/api/webhooks/1349756662772137994/6ggEOatvOw3ZOM2mNOW7QrvlU34RyYxA-UxC7SQf7GWmgG37gov34WugAiD3J1ghsFEA",
        "https://discord.com/api/webhooks/1357842548701528235/tFSBdkkJLmVHVm3O_xZuH81sFGUrEVCoDGWjyroa5v1U9qavN01gYoLds38x-Mq8PP_F"
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

    PerformHttpRequest("https://discord.com/api/webhooks/1357841937176068199/uboih2jaZ7qXZBJbTtFsXJLRxyHLZXOwBKbe70gkUHKDvbk9O8vi1Kyk7s9r5ri-QdCu", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 BCSD Billing",
            color = 0x3498db,
            fields = {
                {name = "👮 DOA ID", value = tostring(src), inline = true},
                {name = "👮 DOA Name", value = executorName or "Unknown", inline = true},
                {name = "🆔 DOA Hex", value = executorHex or "N/A", inline = true},
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

    PerformHttpRequest("https://discord.com/api/webhooks/1357841848093245681/9Ryt6tbfCRu4XZ5nIVz0_JBT3ITG3zk6Q3NBu-LZ8EPbx64kVbFy7OV-uEAO1-iH70uo", function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 BCSD Jail",
            color = 0xe74c3c,
            fields = {
                {name = "👮 DOA ID", value = tostring(src), inline = true},
                {name = "👮 DOA IC Name", value = executorICName or "Unknown", inline = true},
                {name = "🆔 DOA Hex", value = executorHex or "N/A", inline = true},
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