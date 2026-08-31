

ESX                = nil
PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}
PlayersCrafting    = {}
PlayersCrafting2   = {}
PlayersCrafting3   = {}
local rcount = 1
local reqs = {}
local chats = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_mechanic.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'mechanic', Config_mechanic.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'mechanic', _U('mechanic_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'Mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'private'})

ESX.RegisterUsableItem('fixkit', function(source)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('fixkit', 1)

  TriggerClientEvent('esx_mechanicjob:onFixkit', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('you_used_repair_kit'))

end)

AddEventHandler('playerDropped', function (reason, resourceName, clientDropReason)
	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(source) then
			CloseRequest_mechanic(k)
		end
	end
end)

ESX.RegisterUsableItem('carokit', function(source)

  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(source)

  xPlayer.removeInventoryItem('carokit', 1)

  TriggerClientEvent('esx_mechanicjob:onCarokit', _source)
  TriggerClientEvent('esx:showNotification', _source, _U('you_used_body_kit'))

end)

RegisterServerEvent('esx_mechanicjob:getStockItem')
AddEventHandler('esx_mechanicjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_mechanic armory just by calling this event with a valid
	-- item name. Restricted to actual mechanic employees.
	if not xPlayer or xPlayer.job.name ~= 'mechanic' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_mechanicjob:getStockItem without the mechanic job')
		end
		return
	end
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)


		if count > 0 and item.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
				TriggerEvent('esx_society:logAction', 'mechanic', 'Item Withdrawn', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
				})
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('esx_mechanicjob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_mechanic:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)

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

RegisterServerEvent('esx_mechanicjob:putStockItems')
AddEventHandler('esx_mechanicjob:putStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  -- SECURITY FIX: see getStockItem above -- same missing job check.
  if not xPlayer or xPlayer.job.name ~= 'mechanic' then
    if exports.UNIQUE_AC then
      exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_mechanicjob:putStockItems without the mechanic job')
    end
    return
  end

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mechanic', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))

  end)
end)

ESX.RegisterServerCallback('esx_mechanicjob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterNetEvent('esx_mechanicjob:buypetrol')
AddEventHandler('esx_mechanicjob:buypetrol', function()
	ESX.GetPlayerFromId(source).removeMoney(0)
	ESX.GetPlayerFromId(source).addWeapon('WEAPON_PETROLCAN', 4500)
end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

ESX.RegisterServerCallback("esx_mechanicjob:ChekRequest", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq_mechanic(identifier) then
			cb(false)
		else
			cb(true)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("esx_mechanicjob:GetAccepterID", function(source, cb)
	local xPlayer
	local playerhast = true

	for k,v in pairs(reqs) do
		if v.owner.id == source then
			xPlayer = ESX.GetPlayerFromIdentifier(v.respond.identifier)
			if xPlayer then
				playerhast = true
				break
			else
				playerhast = false
			end

		end
	end

	if xPlayer and playerhast then
		cb(xPlayer.source)
	else
		cb(false)
	end
end)

RegisterServerEvent("esx_mechanincjob:CloseRequest_mechanic")
AddEventHandler("esx_mechanincjob:CloseRequest_mechanic", function(source)
	source = source
	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(source) then
			CloseRequest_mechanic(k)
		end
	end
end)

function CloseRequest_mechanic(id)
	local reqid = id
	local source = id
	local xPlayer = ESX.GetPlayerFromId(source)

	if reqs[reqid] then
		local req = reqs[reqid]
		local identifier = GetPlayerIdentifier(source)
		local ridentifier = req.owner.identifier

		chats[ridentifier] = nil
		xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
		if xPlayer then
			TriggerClientEvent("esx_mechanicjob:delblip", xPlayer.source)
		end
		reqs[reqid] = nil

		for k,v in pairs(GetPlayers()) do
			local xxPlayer = ESX.GetPlayerFromId(v)
			Wait(20)
			if xxPlayer then
				if xxPlayer.job.name == 'mechanic' then
					TriggerClientEvent('chatMessage', xxPlayer.source, "[SYSTEM]", {255, 0, 0}, "Request : ^2"..xPlayer.name.."^0 | ^2"..xPlayer.source.."^0 Baste Shod")
				end
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
	end
end

RegisterServerEvent("esx_mechanicjob:addreq")
AddEventHandler("esx_mechanicjob:addreq", function(reason)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq_mechanic(identifier) then
				TriggerClientEvent('esx:showNotification', source, "Shoma Az Qabl Darkhast Darid Lotfan Shakiba Bashid!")
			return
		end
		local name = string.gsub(xPlayer.name, "_", " ")
		reqs[tostring(rcount)] = {
			owner = {
			identifier = identifier,
			name = name,
			id = source,
			coord = GetEntityCoords(GetPlayerPed(source))
		},
		respond = {
			name = "none",
			id = "none",
			identifier = "none",
		},
			reason = reason,
			status = "open",
			time = os.time()
		}
		rcount = rcount + 1
		TriggerClientEvent('esx:showNotification', source, "Darkhast Shoma Baraye Mechanic Ersal Shod!")

		-- Try the dispatch duty queue first (esx_society /dduty). If someone's
		-- waiting, push the request straight into their F6 Request List.
		local assignedWorker = exports['esx_society']:popNextInQueue('mechanic')

		if assignedWorker then
			TriggerClientEvent('esx:showNotification', assignedWorker, "DarKhast Jadid Baraye Shoma Ersal Shod!")
			TriggerClientEvent('esx_society:requestListRequested', assignedWorker)
		else
			local xPlayers = ESX.GetPlayers()
			for i=1, #xPlayers do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'mechanic' then
					TriggerClientEvent('esx:showNotification', xPlayer.source, "DarKhast Jadid Sabt Shod!")
				end
			end
		end
	end
end)

RegisterServerEvent("esx_mechanicjob:creqs")
AddEventHandler("esx_mechanicjob:creqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "mechanic" then
		if reqs[reqid] then
			local req = reqs[reqid]
			local identifier = GetPlayerIdentifier(source)
			local ridentifier = req.owner.identifier
			chats[identifier] = nil
			chats[ridentifier] = nil
			TriggerClientEvent('esx:showNotification', source, "Shoma DarKhast Ra Bastid!")
			xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
			if xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, "DarKhast Shoma Baste Shod!")
				TriggerClientEvent("esx_mechanicjob:delblip", xPlayer.source)
			end
			reqs[reqid] = nil
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("esx_mechanicjob:areqs")
AddEventHandler("esx_mechanicjob:areqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "mechanic" then
		local identifier = GetPlayerIdentifier(source)
		local coord = GetEntityCoords(GetPlayerPed(source))
		if not canRespond_mechanic(identifier) then
			TriggerClientEvent('esx:showNotification', source, "Shoma DarKhast Accept Shode Darid!")
			return
		end
		if reqs[reqid] then
			if reqs[reqid].status == "open" then
				local req = reqs[reqid]
				local ridentifier = req.owner.identifier
				local name = string.gsub(xPlayer.name, "_", " ")
				req.status = "pending"
				req.respond.name = name
				req.respond.identifier = identifier
				chats[identifier] = ridentifier
				chats[ridentifier] = identifier

				TriggerClientEvent('esx:showNotification', source, "Shoma Dakhast " .. req.owner.name .. " Ra Ghabol Kardid!")
				TriggerClientEvent("esx_mechanicjob:acceptreq", source, req.owner.coord)
				xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Darkhast Shoma Ghabol Shod. Mechanic Dar Rah Ast")
					TriggerClientEvent("esx_mechanicjob:addblip", xPlayer.source, source, coord)
				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " In DarKhast Ghablan Tavasot Kasi Javab Dade Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("esx_mechanicjob:decline")
AddEventHandler("esx_mechanicjob:decline", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source)
	if xPlayer.job.name == "mechanic" then
		if reqs[reqid] then
		local req = reqs[reqid]
		local ridentifier = req.owner.identifier

		req.status = "open"
		req.respond.name = "none"
		req.respond.identifier = "none"
		chats[identifier] = nil
		chats[ridentifier] = nil
		TriggerClientEvent('esx:showNotification', source, "Shoma DarKhast " .. req.owner.name .. " Ra Decline Kardid!")

		xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
		if xPlayer then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Mechanic DarKhast Shoma Ro Cancel Kard Montazere Yek Mechanic Digar Bashid!")
			TriggerClientEvent("esx_mechanicjob:delblip", xPlayer.source)
		end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('esx_mechanicjob:getReqs', function(source, cb)
	local treqs = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "mechanic" then
		local status
		local accept
		if TableLength_mechanic(reqs) > 0 then
			for k,v in pairs(reqs) do
				if v.status == "open" then
					status = "❌"
					accept = "open"
				else
					status = "✔️"
					accept = "accepted"
				end
				table.insert(treqs, {
					name		= v.owner.name,
					phone		= getNumberPhone_mechanic(v.owner.identifier),
					coord		= v.owner.coord,
					reqid	    = k,
					reason		= v.reason,
					status		= status,
					id		    = v.owner.id,
					accept		= accept,
				})
			end
			cb(treqs)
		else
			TriggerClientEvent('esx:showNotification', source, "~r~DarKhasti Vojod nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('esx_mechanicjob:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

ESX.RegisterServerCallback('esx_mechanicjob:acceptername', function(source, cb, id)
	local reqid = id
	local req = reqs[reqid]
	local acceptername = req.respond.name
	if req.respond.identifier ~= "none" then
		local xPlayer = ESX.GetPlayerFromIdentifier(req.respond.identifier)
		if xPlayer then
			cb(acceptername, xPlayer.source)
		else
			cb(acceptername, nil)
		end
	else
		cb(acceptername, nil)
	end
end)

ESX.RegisterServerCallback('esx_mechanicjob:icname', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = string.gsub(xPlayer.name, "_", " ")
	cb(name)
end)

function canRespond_mechanic(identifier)
	for k,v in pairs(reqs) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReq_mechanic(identifier)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function TableLength_mechanic(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

ESX.RegisterServerCallback('esx_mechanicjob:list', function(source, cb)
	cb(TableLength_mechanic(reqs))
end)

function CheckReqs_mechanic()
	if TableLength_mechanic(reqs) > 0 then
		for k,v in pairs(reqs) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayer = ESX.GetPlayerFromIdentifier(reqs[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer, "DarKhast Mechanic Shoma Bedalil Adam Pasokhgoyi Baste Shod!")
				end
				reqs[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReqs_mechanic)
end
CheckReqs_mechanic()

function getNumberPhone_mechanic(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end

RegisterServerEvent("esx_mechanicjob:chat")
AddEventHandler("esx_mechanicjob:chat", function(message)
	TriggerClientEvent('chatMessage', source, "[MECHANIC]", {244, 255, 0}, message)
end)

RegisterNetEvent('esx_mechanicjob:blingrequest')
AddEventHandler('esx_mechanicjob:blingrequest', function(player, target, ammont)

	TriggerClientEvent('esx_mechanicjob:OpenMenuDialog', player, player, target, ammont)
end)

RegisterNetEvent('esx_mechanicjob:ChatMessage')
AddEventHandler('esx_mechanicjob:ChatMessage', function(target, player, Chek)

	if Chek then
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^2'..tonumber(player)..' ^0| ^2Ghabol ^0Shod' } })
	else
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^1'..tonumber(player)..' ^0|^1Rad ^0Shod' } })
	end
end)

RegisterServerEvent('logVehicleSpawn')
AddEventHandler('logVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_mechanic(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_mechanic(messages, titels, true)
	end

end)

function DiscordLogs_mechanic(messagess, titelss, grren)

	local discordWebhook = GetConvar('unique_mechanic_main_discordwebhook', '')

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

    PerformHttpRequest(discordWebhook, function(err, text, headers)

    end, 'POST', json.encode({username = "Vehicle Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })

end