ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_uniquejobs:AntiCheatExempt')
AddEventHandler('esx_uniquejobs:AntiCheatExempt', function(ms, kinds)
	local source = source
	if GetResourceState('UNIQUE_AC') ~= 'started' then return end
	pcall(function()
		exports['UNIQUE_AC']:ExemptPlayer(source, ms or 5000, kinds)
	end)
end)

local rcount = 1
local reqs = {}
local chats = {}

if Config_taxi.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config_taxi.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local source = source

end)

AddEventHandler('playerDropped', function (reason, resourceName, clientDropReason)
	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(source) then
			CloseRequest_taxi(k)
		end
	end
end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_taxi armory just by calling this event with a valid
	-- item name. Restricted to actual taxi employees.
	if not xPlayer or xPlayer.job.name ~= 'taxi' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_taxijob:getStockItem without the taxi job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('DiscordBot:ToDiscord', 'pwi', "taxi", xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
				TriggerEvent('esx_society:logAction', 'taxi', 'Item Withdrawn', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
				})
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'taxi' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_taxijob:putStockItems without the taxi job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

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

ESX.RegisterServerCallback('esx_taxijob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_taxi:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

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

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

ESX.RegisterServerCallback('esx_taxijob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

local Taxi = 0
function CoutnTaxi_taxi()
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == "taxi" then
			Taxi = Taxi + 1
		end
	end
	SetTimeout(10 * 1000, CoutnTaxi_taxi)
end
function CoutnTaxi2_taxi()
	local xPlayers = ESX.GetPlayers()
	local Taxis = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == "taxi" then
			Taxis = Taxis + 1
		end
	end
	return Taxis
end

RegisterServerEvent("esx_taxijob:addreq")
AddEventHandler("esx_taxijob:addreq", function(reason)


	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	if xPlayer then
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name ~= "tax" then
				if xPlayer then
					local identifier = GetPlayerIdentifier(source)
					if doesHaveReq_taxi(identifier) then
							TriggerClientEvent('esx:showNotification', source, "Shoma Az Qabl Darkhast Darid Lotfan Shakiba Bashid!")
						return
					end
					local name = string.gsub(xPlayer.name, "_", " ")
					reqs[tostring(rcount)] = {
						owner = {
						identifier = identifier,
						name = name,
						id = source,
						coord = GetEntityCoords(GetPlayerPed(source)),
					},
					respond = {
						name = "none",
						identifier = "none",
					},
						reason = reason,
						status = "open",
						time = os.time()
					}
					local xPlayers = ESX.GetPlayers()
					for i=1, #xPlayers do
						local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
						if xPlayer.job.name == 'taxi' then
							TriggerClientEvent('esx:showNotification', xPlayer.source, "DarKhast Jadid Sabt Shod!")
						end
					end
					rcount = rcount + 1
					TriggerClientEvent('esx:showNotification', source, "Darkhast Shoma Baraye Taxi Ersal Shod!")
				end
			else
				TriggerClientEvent('esx:showNotification', source, "Shoma Yek Taxi Run Hastid Nemitavnid Darkhast Taxi Konid!")
			end
		end
	end
end)

RegisterServerEvent("esx_taxijob:creqs")
AddEventHandler("esx_taxijob:creqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
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
				TriggerClientEvent("esx_taxijob:delblip", xPlayer.source)
			end
			reqs[reqid] = nil
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("esx_taxijob:areqs")
AddEventHandler("esx_taxijob:areqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
		local identifier = GetPlayerIdentifier(source)
		local coord = GetEntityCoords(GetPlayerPed(source))
		if not canRespond_taxi(identifier) then
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

				TriggerClientEvent('esx:showNotification', source, "Shoma DarKhast " .. req.owner.name .. " Ra Ghabol Kardid!")
				TriggerClientEvent("esx_taxijob:acceptreq", source, req.owner.coord)
				xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, "DarKhast Shoma Ghabol Shod. Taxi Officer Dar Rah Ast")
					TriggerClientEvent("esx_taxijob:addblip", xPlayer.source, source, coord)
				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " In DarKhast Ghablan Tavasot Kasi Accept Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("esx_taxijob:decline")
AddEventHandler("esx_taxijob:decline", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source)
	if xPlayer.job.name == "taxi" then
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
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Taxi Officer DarKhast Shoma Ro Cancel Kard Montazere Yek Taxi Digar Bashid!")
			TriggerClientEvent("esx_taxijob:delblip", xPlayer.source)
		end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " DarKhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('esx_taxijob:getReqs', function(source, cb)
	local treqs = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "taxi" then
		local status
		local accept
		if TableLength_taxi(reqs) > 0 then
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
					phone		= getNumberPhone_taxi(v.owner.identifier),
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

ESX.RegisterServerCallback('esx_taxijob:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

ESX.RegisterServerCallback('esx_taxijob:acceptername', function(source, cb, id)
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

ESX.RegisterServerCallback('esx_taxijob:icname', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = string.gsub(xPlayer.name, "_", " ")
	cb(name)
end)

function canRespond_taxi(identifier)
	for k,v in pairs(reqs) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReq_taxi(identifier)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function TableLength_taxi(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

ESX.RegisterServerCallback('esx_taxijob:list', function(source, cb)
	cb(TableLength_taxi(reqs))
end)

function CheckReqs_taxi()
	if TableLength_taxi(reqs) > 0 then
		for k,v in pairs(reqs) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayer = ESX.GetPlayerFromIdentifier(reqs[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer, "DarKhast Taxi Shoma Bedalil Adam Pasokhgoyi Baste Shod!")
				end
				reqs[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReqs_taxi)
end
CheckReqs_taxi()

function getNumberPhone_taxi(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })

    if result[1] ~= nil then
        return result[1].phone
    end

    return nil
end

RegisterServerEvent("esx_taxijob:chat")
AddEventHandler("esx_taxijob:chat", function(message)
	TriggerClientEvent('chatMessage', source, "[TAXI]", {244, 255, 0}, message)
end)

RegisterServerEvent('esx_taxijob:pay')
AddEventHandler('esx_taxijob:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', _source, 'Mablagh ~g~$'..price..'~s~ Baraye Masafat Tey Shode Pardakhtid!')

	TriggerEvent('esx_society:logAction', 'taxi', 'Fare Paid', {
		{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "Amount", ["value"] = '$' .. price, ["inline"] = false},
	})
end)

RegisterNetEvent('esx_taxijob:blingrequest')
AddEventHandler('esx_taxijob:blingrequest', function(player, target, ammont)

	TriggerClientEvent('esx_taxijob:OpenMenuDialog', player, player, target, ammont)
end)

RegisterNetEvent('esx_taxijob:ChatMessage')
AddEventHandler('esx_taxijob:ChatMessage', function(target, player, Chek)

	if Chek then
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^2'..tonumber(player)..' ^0| ^2Ghabol ^0Shod' } })
	else
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^1'..tonumber(player)..' ^0|^1Rad ^0Shod' } })
	end
end)

ESX.RegisterServerCallback("esx_taxijob:ChekRequest", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq_taxi(identifier) then
			cb(false)
		else
			cb(true)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback("esx_taxijob:GetAccepterID", function(source, cb)
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

RegisterServerEvent("esx_taxijob:CloseRequest_taxi")
AddEventHandler("esx_taxijob:CloseRequest_taxi", function(source)
	source = source
	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(source) then
			CloseRequest_taxi(k)
		end
	end
end)

function CloseRequest_taxi(id)
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
			TriggerClientEvent("esx_taxijob:delblip", xPlayer.source)
		end
		reqs[reqid] = nil

		for k,v in pairs(GetPlayers()) do
			local xxPlayer = ESX.GetPlayerFromId(v)
			Wait(20)
			if xxPlayer then
				if xxPlayer.job.name == 'taxi' then
					TriggerClientEvent('chatMessage', xxPlayer.source, "[SYSTEM]", {255, 0, 0}, "Request : ^2"..xPlayer.name.."^0 | ^2"..xPlayer.source.."^0 Baste Shod")
				end
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
	end
end