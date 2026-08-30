

ESX = nil
local playersHealing = {}
local reqs = {}
local rcount = 1
local chats = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

RegisterServerEvent('esx_ambulancejob:revivex')
AddEventHandler('esx_ambulancejob:revivex', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)


	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade >= 1 then
		xPlayer.addMoney(Config_ambulance.reviveReward)
		TriggerClientEvent('esx_ambulancejob:revivex', target)

		local xTargetPlayer = ESX.GetPlayerFromId(target)
		TriggerEvent('esx_society:logAction', 'ambulance', 'Player Revived', {
			{["name"] = "Medic", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Patient", ["value"] = xTargetPlayer and xTargetPlayer.name or ('id ' .. tostring(target)), ["inline"] = false},
			{["name"] = "Reward", ["value"] = '$' .. Config_ambulance.reviveReward, ["inline"] = false},
		})
		for k,v in pairs(reqs) do
			if tonumber(v.owner.id) == tonumber(target) then
				CloseRequest_ambulance(k)
			end
		end

	else
		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : revive! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

AddEventHandler('playerDropped', function (reason, resourceName, clientDropReason)
	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(source) then
			CloseRequest_ambulance(k)
		end
	end
end)

RegisterNetEvent("esx_ambulancejob:requestfalse")
AddEventHandler("esx_ambulancejob:requestfalse", function(id)

	for k,v in pairs(reqs) do
		if tonumber(v.owner.id) == tonumber(id) then
			CloseRequest_ambulance(k)
		end
	end
end)
RegisterServerEvent("GetDiagnosis")
AddEventHandler("GetDiagnosis", function(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		TriggerClientEvent("PassDiagnosis", id, source)
	else
		TriggerClientEvent("esx:showNotification", source, "Shoma Medic Nistid!")
	end
end)

RegisterServerEvent("PassDiagnosis")
AddEventHandler("PassDiagnosis", function(a, b, c, d, e, f, g, id)
	TriggerClientEvent("OpenBodyDamage", source, a, b, c, d, e, f, g)
	TriggerClientEvent("OpenBodyDamage", id, a, b, c, d, e, f, g)
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade > 0 then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	else
		print(('esx_ambulancejob: %s attempted to heal!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : heal! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_ambulancejob:getStockItem')
AddEventHandler('esx_ambulancejob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_ambulance armory just by calling this event with a valid
	-- item name. Restricted to actual ambulance employees.
	if not xPlayer or xPlayer.job.name ~= 'ambulance' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_ambulancejob:getStockItem without the ambulance job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('DiscordBot:ToDiscord', 'dwi', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
				TriggerEvent('esx_society:logAction', 'ambulance', 'Item Withdrawn', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
				})
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_ambulancejob:putStockItems')
AddEventHandler('esx_ambulancejob:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'ambulance' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_ambulancejob:putStockItems without the ambulance job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

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
ESX.RegisterServerCallback('esx_ambulancejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

ESX.RegisterServerCallback('esx_ambulancejob:getitem', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_jafari:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.get('money') >= 1000)
	xPlayer.removeMoney(1000)

end)

ESX.RegisterServerCallback('esx_gholi:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.get('money') >= 15000)
	xPlayer.removeMoney(15000)

end)

RegisterServerEvent('esx_ambulancejob:synServerTestcDeadrpBodyx')
AddEventHandler('esx_ambulancejob:synServerTestcDeadrpBodyx', function(ped, target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade > 0 then
		TriggerClientEvent('esx_ambulancejob:finishCPRx', target, ped)
	else
		print(('esx_ambulancejob: %s attempted to syncDeadBody!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : syncDeadBody! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade > 0 then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to put in vehicle!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : put in vehicle! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent("esx_ambulancejob:drag")
AddEventHandler("esx_ambulancejob:drag", function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	if xPlayer.job.name == "ambulance" then
		TriggerClientEvent("esx_ambulancejob:drag", target, source)
	else
		print(('esx_ambulancejob: %s attempted to drag player!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : drag player! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent("esx_ambulancejob:brancard")
AddEventHandler("esx_ambulancejob:brancard", function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source
	if xPlayer.job.name == "ambulance" then
		TriggerClientEvent("esx_ambulancejob:brancard", target, src)
	else
		print(('esx_ambulancejob: %s attempted to brancard player!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : brancard player! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent("esx_ambulancejob:PlShowazaNotification")
AddEventHandler("esx_ambulancejob:PlShowazaNotification", function(target, text)
	local xTarget = ESX.GetPlayerFromId(target)
	if xTarget.job.name == "ambulance" then
		TriggerClientEvent('esx:showNotification', xTarget.source, text)
	else
		print(('esx_ambulancejob: %s attempted to notification player!'):format(xTarget.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xTarget.identifier)..' ]\n[ Attempted : notification player! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_ambulancejob:OutVehicle')
AddEventHandler('esx_ambulancejob:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade > 0 then
		TriggerClientEvent('esx_ambulancejob:OutVehicle', target)
	else
		print(('esx_ambulancejob: %s attempted to Out vehicle!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : Out vehicle! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_ambulancejob:OutBrancard')
AddEventHandler('esx_ambulancejob:OutBrancard', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' and xPlayer.job.grade > 0 then
		TriggerClientEvent('esx_ambulancejob:OutBrancard', target)
	else
		print(('esx_ambulancejob: %s attempted to Out vehicle!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : Out vehicle! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

local PlayerData = {}
ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.name
    local oocname = GetPlayerName(source)
    local removed = 'Steam Name : ' .. oocname .. '('.. source ..')\nIC Name : '..name..'\n'
    PlayerData[source] = {money = 0, items = {}, weapons = {}}

    if Config_ambulance.RemoveCashAfterRPDeath then
        if xPlayer.money > 0 then
            PlayerData[source].money = xPlayer.money
            xPlayer.removeMoney(xPlayer.money)
            removed = removed .. 'Money Removed : ' .. xPlayer.money ..'\n'
        end
    end

    if Config_ambulance.RemoveItemsAfterRPDeath then
        removed = removed .. 'Items Removed : \n'
        PlayerData[source].items = xPlayer.inventory
        for i=1, #xPlayer.inventory, 1 do
            local item = xPlayer.inventory[i]
            if item.count > 0 and not isBlacklistedItem_ambulance(item.name) then
                xPlayer.setInventoryItem(item.name, 0)
                removed = removed .. item.name .. '('.. item.count ..')\n'
            end
        end
    end

    local playerLoadout = {}
    if Config_ambulance.RemoveWeaponsAfterRPDeath then
        removed = removed .. 'Weapons Removed : \n'
        PlayerData[source].weapons = xPlayer.loadout
        for i=1, #xPlayer.loadout, 1 do
            local weapon = xPlayer.loadout[i]
            if not isBlacklistedWeapon_ambulance(weapon.name) then
                xPlayer.removeWeapon(weapon.name)
                removed = removed .. weapon.name .. ' \n'
            else
                table.insert(playerLoadout, weapon)
            end
        end

        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            for i=1, #playerLoadout, 1 do
                xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
            end
        end)
    end

    cb()
    TriggerEvent('DiscordBot:ToDiscord', 'nlr', xPlayer.name .. '('.. source .. ')', '```css\n' .. removed ..'\n```', 'user', true, source, false)
end)

function isBlacklistedItem_ambulance(itemName)
    for _, blacklistedItem in ipairs(Config_ambulance.BlacklistedItems) do
        if blacklistedItem == itemName then
            return true
        end
    end
    return false
end

function isBlacklistedWeapon_ambulance(weaponName)
    for _, blacklistedWeapon in ipairs(Config_ambulance.BlacklistedWeapons) do
        if blacklistedWeapon == weaponName then
            return true
        end
    end
    return false
end

TriggerEvent('es:addAdminCommand', 'backlife', 5, function(source, args, user)
	local Target = tonumber(args[1])
	if not Target then return TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Please Enter ID' } }) end
	local xTarget = ESX.GetPlayerFromId(Target)
	if PlayerData[source] ~= nil then
		money = PlayerData[Target].money
		weapon = PlayerData[Target].weapons
		inventory = PlayerData[Target].items
		if money >= 0 then
			xTarget.addMoney(money)
		end
		for i=1, #inventory, 1 do
			if inventory[i].count > 0 then
				xTarget.addInventoryItem(inventory[i].name, inventory[i].count)
				TriggerEvent('esx_society:logAction', 'ambulance', 'Loadout Restored', {
					{["name"] = "Player", ["value"] = xTarget.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = inventory[i].name .. ' x' .. inventory[i].count, ["inline"] = false},
				})
			end
		end
		local playerLoadout = {}
		for i=1, #weapon, 1 do
			table.insert(playerLoadout, weapon[i])
		end
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xTarget.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
		PlayerData[source] = nil
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Item Haye Player Back Khord!' } })
		TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', 'Item Haye Shoma Tavasot Admin Bazgasht!' } })
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'In Player Itemi Baraye Back Dadan Nadarad!' } })
	end

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "Back New Life Items", params = {{ name = 'id' }} })

if Config_ambulance.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.bank

		cb(bankBalance >= Config_ambulance.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config_ambulance.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeBank(fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash_ambulance(vehicleProps.model, xPlayer.job.grade_name, type)


	if price == 0 then
		print(('esx_ambulancejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : exploit the shop! (invalid vehicle model) ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
		cb(false)
	else
		if xPlayer.money >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash_ambulance(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config_ambulance.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config_ambulance.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ambulance' then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : spawn in an item! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		print(('esx_ambulancejob: %s attempted to spawn in an item!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : spawn in an item! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
		TriggerEvent('esx_society:logAction', 'ambulance', 'Item Received', {
			{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
		})
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

TriggerEvent('es:addAdminCommand', 'revive', 2, function(source, args, user)



	if args[1] ~= nil then

		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ambulancejob:revivex', tonumber(args[1]))

			TriggerEvent('DiscordBot:ToDiscord', 'revive', "Revive By Admin", "```css\n[Admin : " .. GetPlayerName(source) .. " \nRevived : "..GetPlayerName(tonumber(args[1])).."("..tonumber(args[1])..")\n```",'user', source, true, false)
		end
	else

		TriggerClientEvent('esx_ambulancejob:revivex', source)
		TriggerEvent('DiscordBot:ToDiscord', 'revive', "Revive By Admin", "```css\n[Admin : " .. GetPlayerName(source) .. " \nRevived : "..GetPlayerName(source).."("..source..")\n```",'user', source, true, false)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })

function CloseRequest_ambulance(id)
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
			TriggerClientEvent("esx_ambulancejob:delblip", xPlayer.source)
		end
		reqs[reqid] = nil

		for k,v in pairs(GetPlayers()) do
			local xxPlayer = ESX.GetPlayerFromId(v)
			Wait(20)
			if xxPlayer then
				if xxPlayer.job.name == 'ambulance' then
					TriggerClientEvent('chatMessage', xxPlayer.source, "[SYSTEM]", {255, 0, 0}, "Request : ^2"..xPlayer.name.."^0 | ^2"..xPlayer.source.."^0 Baste Shod")
				end
			end
		end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
	end
end

ESX.RegisterUsableItem('medikit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not playersHealing[source] and xPlayer.job.name == 'ambulance' then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not playersHealing[source] and xPlayer.job.name == 'ambulance' then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
			TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_ambulancejob ]\n[ Player Steam : '..tostring(identifier)..' ]\n[ Attempted : Combat Logging (reconnected while marked dead) ]\n```', 'user', true, source, false)
		end
		if tonumber(isDead) == 0 then
			cb(false)
		else
			cb(true)
		end
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatusx')
AddEventHandler('esx_ambulancejob:setDeathStatusx', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if isDead ~= -1 then
		xPlayer.set('IsDead', isDead)
		xPlayer.set('Injure', isDead)

		if type(isDead) ~= 'boolean' then
			isDead = true
		end

		MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})
	else
		xPlayer.set('Injure', 'done')
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local identifier = GetPlayerIdentifier(source)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			v.owner.id = source
		end
	end
end)

RegisterServerEvent("esx_ambulancejob:addreq")
AddEventHandler("esx_ambulancejob:addreq", function(reason)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local identifier = GetPlayerIdentifier(source)
		if doesHaveReq_ambulance(identifier) then
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
			identifier = "none",
		},
			reason = reason,
			status = "open",
			time = os.time()
		}
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'ambulance' then
				TriggerClientEvent('esx:showNotification', xPlayer.source, "DarKhast Jadid Sabt Shod!")
			end
		end
		rcount = rcount + 1
		TriggerClientEvent('esx:showNotification', source, "Darkhast Shoma Baraye Ambulance Ersal Shod!")
	end
end)

RegisterServerEvent("esx_ambulancejob:creqs")
AddEventHandler("esx_ambulancejob:creqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)

		if reqs[reqid] then
			local req = reqs[reqid]
			local identifier = GetPlayerIdentifier(source)
			local ridentifier = req.owner.identifier
			chats[identifier] = nil
			chats[ridentifier] = nil
			TriggerClientEvent('esx:showNotification', source, "Shoma Darkhast Ra Bastid!")
			xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
			if xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Darkhast Shoma Baste Shod!")
				TriggerClientEvent("esx_ambulancejob:delblip", xPlayer.source)
			end
			reqs[reqid] = nil
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
		end



end)

RegisterServerEvent("esx_ambulancejob:areqs")
AddEventHandler("esx_ambulancejob:areqs", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		local identifier = GetPlayerIdentifier(source)
		local coord = GetEntityCoords(GetPlayerPed(source))
		if not canRespond_ambulance(identifier) then
			TriggerClientEvent('esx:showNotification', source, "Shoma Darkhast Accept Shode Darid!")
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

				TriggerClientEvent('esx:showNotification', source, "Shoma Darkhast " .. req.owner.name .. " Ra Ghabol Kardid!")
				for k,v in pairs(GetPlayers()) do
					local xxPlayer = ESX.GetPlayerFromId(v)
					local xPlayer = ESX.GetPlayerFromId(source)

					if xxPlayer.job.name == "ambulance" then
						TriggerClientEvent('chatMessage', xxPlayer.source, "[SYSTEM]", {255, 0, 0}, "Darkhast ^2"..req.owner.name.." ^0|^2 "..req.owner.id.."^0 Tavasot : ^1"..xPlayer.name.." ^0|^1 "..xPlayer.source.." ^0Accept Shod")
					end
				end
				TriggerClientEvent("esx_ambulancejob:acceptreq", source, req.owner.coord)
				xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Darkhast Shoma Ghabol Shod. Ambulance Dar Rah Ast")
					TriggerClientEvent("esx_ambulancejob:addblip", xPlayer.source, source, coord)
				end

			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " In Darkhast Ghablan Tavasot Kasi Javab Dade Shode Ast!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

RegisterServerEvent("esx_ambulancejob:decline")
AddEventHandler("esx_ambulancejob:decline", function(id)
	local reqid = id
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifier(source)
	if xPlayer.job.name == "ambulance" then
		if reqs[reqid] then
		local req = reqs[reqid]
		local ridentifier = req.owner.identifier

		req.status = "open"
		req.respond.name = "none"
		req.respond.identifier = "none"
		chats[identifier] = nil
		chats[ridentifier] = nil
		TriggerClientEvent('esx:showNotification', source, "Shoma req " .. req.owner.name .. " Ra Decline Kardid!")

		xPlayer = ESX.GetPlayerFromIdentifier(req.owner.identifier)
		if xPlayer then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Ambulance Darkhast Shoma Ro Cancel Kard Montazere Yek Ambulance Digar Bashid!")
			TriggerClientEvent("esx_ambulancejob:delblip", xPlayer.source)
		end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " Darkhast Mored Nazar Vojod Nadarad!")
		end
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid")
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getReqs', function(source, cb)
	local treqs = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == "ambulance" then
		local status
		local accept
		if TableLength_ambulance(reqs) > 0 then
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
					phone		= getNumberPhone_ambulance(v.owner.identifier),
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

ESX.RegisterServerCallback('esx_ambulancejob:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

ESX.RegisterServerCallback('esx_ambulancejob:acceptername', function(source, cb, id)
	local reqid = id
	local req = reqs[reqid]
	local acceptername = req.respond.name
	cb(acceptername, source)
end)

ESX.RegisterServerCallback('esx_ambulancejob:icname', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = string.gsub(xPlayer.name, "_", " ")
	cb(name)
end)

function canRespond_ambulance(identifier)
	for k,v in pairs(reqs) do
		if v.respond.identifier == identifier then
			return false
		end
	end

	return true
end

function doesHaveReq_ambulance(identifier)
	for k,v in pairs(reqs) do
		if v.owner.identifier == identifier then
			return true
		end
	end

	return false
end

function TableLength_ambulance(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

ESX.RegisterServerCallback('esx_ambulancejob:list', function(source, cb)
	cb(TableLength_ambulance(reqs))
end)

function CheckReqs_ambulance()
	if TableLength_ambulance(reqs) > 0 then
		for k,v in pairs(reqs) do
			if os.time() - v.time >= 600 and v.respond.name == "none" then
				local xPlayer = ESX.GetPlayerFromIdentifier(reqs[k].owner.identifier)
				if xPlayer then
					TriggerClientEvent('esx:showNotification', xPlayer, "DarKhast Ambulance Shoma Bedalil Adam Pasokhgoyi Baste Shod!")
				end
				reqs[k] = nil
			end
		end
	end
	SetTimeout(5000, CheckReqs_ambulance)
end
CheckReqs_ambulance()

function getNumberPhone_ambulance(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end

RegisterServerEvent("esx_ambulancejob:chat")
AddEventHandler("esx_ambulancejob:chat", function(message)
	TriggerClientEvent('chatMessage', source, "[Ambulance]", {244, 255, 0}, message)
end)

ESX.RegisterServerCallback('esx_ambulancejob:isDead', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	cb(xPlayer.get('IsDead'), xPlayer.get('Injure'))
end)

ESX.RegisterServerCallback('esx_ambulancejob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
		if account.money >= amount then
			account.removeMoney(amount)
			cb(true)
		else
			TriggerClientEvent('chat:addMessage', source, {color = { 255, 0, 0}, multiline = false, args = {"^1[^1^*SYSTEM^1]: ^0".."Money Boss Action Baraye Kharid In Tedad Weapon Kafi Nist!" }})
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_ambulancejob:buyArmoryItem', function(source, cb, weaponName, removeWeapon, tedad)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		TriggerEvent('DiscordBot:ToDiscord', 'pwi', xPlayer.name, 'Deposited ' .. weaponName ,'user', source, true, false)
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)

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

RegisterServerEvent('logmdVehicleSpawn')
AddEventHandler('logmdVehicleSpawn', function(playerName, serverID, steamHex, vehicleModel, plateText, isspawn)
	if isspawn then
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Bardasht Mashin 🚗**"

		DiscordLogs_ambulance(messages, titels, false)
	else
		messages = {
			{["name"] = "👤 **Player Name**", ["value"] = playerName, ["inline"] = false},
			{["name"] = "🎮 **Steam Hex**", ["value"] = steamHex, ["inline"] = false},
			{["name"] = "🚘 **Vehicle Model**", ["value"] = vehicleModel, ["inline"] = false},
			{["name"] = "🔢 **Plate**", ["value"] = plateText, ["inline"] = false},
			{["name"] = "🌍 **Server ID**", ["value"] = serverID, ["inline"] = false}
		}

		titels = "**🚗 Gozasht Mashin 🚗**"

		DiscordLogs_ambulance(messages, titels, true)
	end

end)

RegisterServerEvent('logmdPutItem')
AddEventHandler('logmdPutItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_ambulance_main_wh1', ''),
        GetConvar('unique_ambulance_main_wh2', '')
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

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers)

        end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logmdGetItem')
AddEventHandler('logmdGetItem', function(playerName, serverID, steamHex, itemLabel, itemCount)
    local discordWebhooks = {
        GetConvar('unique_ambulance_main_wh1', ''),
        GetConvar('unique_ambulance_main_wh2', '')
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

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers)

        end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterServerEvent('logmdBuyItem')
AddEventHandler('logmdBuyItem', function(playerName, serverID, steamHex, itemLabel, itemCount, itemPrice)
    local discordWebhooks = {
        GetConvar('unique_ambulance_main_wh3', ''),
        GetConvar('unique_ambulance_main_wh4', '')
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

    for _, webhook in ipairs(discordWebhooks) do
        PerformHttpRequest(webhook, function(err, text, headers)

        end, 'POST', json.encode({username = "Item Logs", embeds = logMessage}), { ['Content-Type'] = 'application/json' })
    end

end)

function DiscordLogs_ambulance(messagess, titelss, grren)

	local discordWebhooks = {
		GetConvar('unique_ambulance_main_wh5', ''),
		GetConvar('unique_ambulance_main_wh6', '')
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

RegisterNetEvent('esx_ambulancejob:blingrequest')
AddEventHandler('esx_ambulancejob:blingrequest', function(player, target, ammont)

	TriggerClientEvent('esx_ambulancejob:OpenMenuDialog', player, player, target, ammont)
end)

RegisterNetEvent('esx_ambulancejob:ChatMessage')
AddEventHandler('esx_ambulancejob:ChatMessage', function(target, player, Chek)

	if Chek then
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^2'..tonumber(player)..' ^0| ^2Ghabol ^0Shod' } })
	else
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^1'..tonumber(player)..' ^0|^1Rad ^0Shod' } })
	end
end)