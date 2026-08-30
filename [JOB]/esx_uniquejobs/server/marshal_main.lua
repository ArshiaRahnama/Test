ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local drag = false
local AS, ASWarn = {}, {}


if Config_marshal.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'marshal', Config_marshal.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'marshal', _U('alert_marshal'), true, true)

TriggerEvent('esx_society:registerSociety', 'marshal', 'Marshal', 'society_doj', 'society_marshal', 'society_marshal', {type = 'public'})

-- SECURITY FIX: had NO job check at all -- any connected player, regardless of job, could TriggerServerEvent this directly and get any
-- weapon with any ammo count for free. getStockItem/putStockItems in this same file were already fixed with this exact check; this one was
-- missed.
RegisterServerEvent('esx_marshaljob:giveWeapon')
AddEventHandler('esx_marshaljob:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or xPlayer.job.name ~= 'marshal' then return end
	xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_marshaljob:requestrelease')
AddEventHandler('esx_marshaljob:requestrelease', function(targetid, playerheading, playerCoords, playerlocation)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.job.name == "marshal" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.gang.name ~= "nogang" or xPlayer.job.name == "mt" or xPlayer.job.name == "forces" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if cPlayer.get("Cuff") then

				TriggerClientEvent("esx_marshaljob:getuncuffed", targetid, playerheading, playerCoords, playerlocation)
				TriggerClientEvent("esx_marshaljob:douncuffing", source)

			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Dastband Nakhorde Ast')
			end
		else
			exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
		end
	else
		TriggerClientEvent('esx:showNotification', source, '~y~Shoma Nemitavanid Dast Band Organ Nezami Ra Baz Konid')
		exports.Mid_BanSystem:BanThis(source, "Tried To Cuff Players With Cheat", 500)
	end
end)

RegisterServerEvent('esx_marshaljob:drag')
AddEventHandler('esx_marshaljob:drag', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 20.0 then
			if cPlayer.get("Cuff") then


				TriggerClientEvent('esx_marshaljob:drag', target, source)
				TriggerClientEvent('esx_marshaljob:draging', source)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Drag Kardan Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('marshaljob:putInVehiclecarry')
AddEventHandler('marshaljob:putInVehiclecarry', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= nil or xPlayer.gan.name ~= 'nogang' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : put in vehicle! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_marshaljob:putInVehicle')
AddEventHandler('esx_marshaljob:putInVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)

	local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = nil

	if GetPlayerName(target) or cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then

			if cPlayer.get("Cuff") then

				for _, vehicle in ipairs(vehicles) do
					local vehicleCoords = GetEntityCoords(vehicle)
					local distance = #(playerCoords - vehicleCoords)

					if closestDistance == nil or distance < closestDistance then
						closestDistance = distance
						if distance < 4 then

							TriggerClientEvent('esx_marshaljob:putInVehicle', target)
							TriggerClientEvent("esx_marshaljob:draging", source)
							return
						else
							TriggerClientEvent('esx:showNotification', source, '~y~Mashini Nazdik Shoma Nist.')
						end
					end
				end

			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Vared Kardan Dar Mashin Dastband Nakhorde Ast.')
			end
		else
		end
	end
end)

RegisterServerEvent('marshaljob:OutVehiclecarry')
AddEventHandler('marshaljob:OutVehiclecarry', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'nojob' or xPlayer.gang.name ~= 'nogang' then
		TriggerClientEvent('marshaljob:OutVehiclecarry', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : put in vehicle! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_marshaljob:OutVehicle')
AddEventHandler('esx_marshaljob:OutVehicle', function(target)
	local cPlayer = ESX.GetPlayerFromId(target)
	if GetPlayerName(target) or not cPlayer then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(target)))) < 15.0 then
			if cPlayer.get("Cuff") or cPlayer.get("IsDead") then

				TriggerClientEvent('esx_marshaljob:OutVehicle', target)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~Fard Mored Nazar Baraye Kharej Kardan Az Mashin Dastband Nakhorde Ast.')
			end
		else

		end
	end
end)

RegisterServerEvent('esx_marshaljob:getStockItem')
AddEventHandler('esx_marshaljob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_marshal armory just by calling this event with a valid
	-- item name. Restricted to actual marshal employees.
	if not xPlayer or xPlayer.job.name ~= 'marshal' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_marshaljob:getStockItem without the marshal job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_marshal', function(inventory)

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

RegisterServerEvent('esx_marshaljob:putStockItems')
AddEventHandler('esx_marshaljob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'marshal' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_marshaljob:putStockItems without the marshal job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_marshal', function(inventory)

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


ESX.RegisterServerCallback('esx_marshaljob:getVehicleInfos', function(source, cb, plate)

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

				if Config_marshal.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_marshaljob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_marshal.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_marshaljob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_marshal', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_marshaljob:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)
	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_marshal', function(store)

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

ESX.RegisterServerCallback('esx_marshaljob:buyArmoryWeapon', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_marshal', function(store)

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

ESX.RegisterServerCallback('esx_marshaljob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)
	TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_marshal', function(store)

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

ESX.RegisterServerCallback('esx_marshaljob:buy', function(source, cb, amount)


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

ESX.RegisterServerCallback('esx_marshaljob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_marshal', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_marshaljob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_marshal', function(inventory)

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

ESX.RegisterServerCallback('esx_marshaljob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'marshal')
	end
end)

RegisterServerEvent('esx_marshaljob:message')
AddEventHandler('esx_marshaljob:message', function(target, msg)

	TriggerClientEvent('esx:showNotification', target, msg)
end)


RegisterServerEvent('esx_marshaljob:playSoundRadio')
AddEventHandler('esx_marshaljob:playSoundRadio', function(soundFile, soundVolume)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do

		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == "marshal" and xPlayer.job.grade >= 0 then

			if xPlayer.source ~= source then
				TriggerEvent('InteractSound_SV:PlayOnOne', xPlayer.source, soundFile, soundVolume)
			end

		end

	end
end)

ESX.RegisterServerCallback('esx_marshaljob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_marshaljob:getIcName', function(source, cb)
	local _source = source
	characterName = string.gsub(exports.essentialmode:IcName(_source), "_", " ")
	cb(characterName)
end)

RegisterServerEvent("Marshal:ShotsAlarm")
AddEventHandler("Marshal:ShotsAlarm", function(x,y,z,s)
	local xPlayers = ESX.GetPlayers()
	 if GetPlayerRoutingBucket( source )  == 0  then
		TriggerClientEvent("Marshal:ShotsAlarm", -1  , x,y,z,s)
	 end


end)












RegisterServerEvent('esx_marshaljob:SetCuffStatus')
AddEventHandler('esx_marshaljob:SetCuffStatus', function(status)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('Cuff', status)
end)

ESX.RegisterServerCallback('esx_marshaljob:IsHandCuffed', function(source, cb, target)
	local xTarget = ESX.GetPlayerFromId(target)
	if xTarget then
		cb(xTarget.get('Cuff'))

	end
end)

ESX.RegisterServerCallback("PD_CuffStatus:GetPedHandsUpStatus", function(source, cb, ID)
	local Dead = true
	local Injure = true
	local IsCuffed = true
	local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
	if xPlayer.get("Injure") == nil then Injure = false end
	if xPlayer.get("Injure") == false then Injure = false end
	if xPlayer.get("Injure") ~= false then Injure = true end
	if xPlayer.get("IsDead") == nil then Dead = false end
	if xPlayer.get("IsDead") == false then Dead = false end
	if xPlayer.get("IsDead") ~= false then Dead = true end
	if xPlayer.get("Cuff") == nil then IsCuffed = false end
	if xPlayer.get("Cuff") == false then IsCuffed = false end
	cb(IsCuffed, Injure, Dead)
end)

RegisterServerEvent('esx:requestarrestpd')
AddEventHandler('esx:requestarrestpd', function(targetid, playerheading, playerCoords, playerlocation, front)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local cPlayer = ESX.GetPlayerFromId(targetid)
	if not GetPlayerName(targetid) or not cPlayer then
		return
	end
	if xPlayer.job.name == "marshal" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "fbi" or xPlayer.job.name == "mt" or xPlayer.gang.name ~= "nogang" then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(tonumber(targetid)))) < 15.0 then
			if not cPlayer.get("Cuff") then
				TriggerClientEvent("esx_marshaljob:getarrested", targetid, playerheading, playerCoords, playerlocation, true, front)
				TriggerClientEvent("esx_marshaljob:doarrested", source, front)
			else
				TriggerClientEvent('esx:showNotification', source, '~y~In Player Az Ghabl Dastband Khorde Ast.')
			end
		else

		end
	else

	end
end)

RegisterServerEvent('logpdVehicleSpawn')
AddEventHandler('logpdVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_marshal(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_marshal(messages, titels, true)
	end

end)

function DiscordLogs_marshal(messagess, titelss, grren)

	local discordWebhooks = {
		GetConvar('unique_cid_main_wh1', ''),
		GetConvar('unique_marshal_main_wh1', '')
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

RegisterServerEvent('logpdPutItem')
AddEventHandler('logpdPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_marshal_main_wh2', '')
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

RegisterServerEvent('logpdGetItem')
AddEventHandler('logpdGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_marshal_main_wh2', '')
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

RegisterServerEvent('logpdBuyItem')
AddEventHandler('logpdBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh5', ''),
        GetConvar('unique_marshal_main_wh3', '')
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

RegisterServerEvent('logpdGetWeapon')
AddEventHandler('logpdGetWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_marshal_main_wh4', '')
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

RegisterServerEvent('logpdPutWeapon')
AddEventHandler('logpdPutWeapon', function(playerName, serverID, steamHex, weaponLabel, ammoCount)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh3', ''),
        GetConvar('unique_marshal_main_wh4', '')
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

RegisterServerEvent('logpdBuyWeapon')
AddEventHandler('logpdBuyWeapon', function(playerName, serverID, steamHex, weaponLabel, buyCount, totalPrice)
    local discordWebhooks = {
        GetConvar('unique_cid_main_wh5', ''),
        GetConvar('unique_marshal_main_wh3', '')
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

RegisterServerEvent("PdBillingWebhook")
AddEventHandler("PdBillingWebhook", function(targetId, amount, reason)
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

    PerformHttpRequest(GetConvar('unique_marshal_main_wh5', ''), function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = {{
            title = "📄 LSPD Billing",
            color = 0x3498db,
            fields = {
                {name = "👮 Marshal ID", value = tostring(src), inline = true},
                {name = "👮 Marshal Name", value = executorName or "Unknown", inline = true},
                {name = "🆔 Marshal Hex", value = executorHex or "N/A", inline = true},
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

RegisterServerEvent("PdJailWebhook")
AddEventHandler("PdJailWebhook", function(targetId, jailTime, reason)
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

    PerformHttpRequest(GetConvar('unique_marshal_main_wh6', ''), function(err, text, headers) end, 'POST', json.encode({
        content = "",
        embeds = { {
            title = "🚔 LSPD Jail",
            color = 0xe74c3c,
            fields = {
                {name = "👮 Marshal ID", value = tostring(src), inline = true},
                {name = "👮 Marshal IC Name", value = executorICName or "Unknown", inline = true},
                {name = "🆔 Marshal Hex", value = executorHex or "N/A", inline = true},
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
