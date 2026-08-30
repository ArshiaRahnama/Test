ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_fbi.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'fbi', Config_fbi.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'fbi', _U('alert_fbi'), true, true)

TriggerEvent('esx_society:registerSociety', 'fbi', 'fbi', 'society_doj', 'society_fbi', 'society_fbi', {type = 'public'})

RegisterServerEvent('esx_fbi_job:giveWeapon')
AddEventHandler('esx_fbi_job:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'fbi' then
		xPlayer.addWeapon(weapon, ammo)
		TriggerEvent('esx_society:logAction', 'fbi', 'Weapon Given', {
			{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Weapon", ["value"] = weapon, ["inline"] = false},
		})
	else
		print(('esx_fbi_job: %s attempted to give weapon!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_fbi_job ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : give weapon! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_fbi_job:confiscatePlayerItem')
AddEventHandler('esx_fbi_job:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'fbi' then
		print(('esx_fbi_job: %s attempted to confiscate!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_fbi_job ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : confiscate! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
		return
	end

	TriggerEvent('esx_society:logAction', 'fbi', 'Item Confiscated', {
		{["name"] = "Agent", ["value"] = sourceXPlayer.name, ["inline"] = false},
		{["name"] = "From", ["value"] = targetXPlayer and targetXPlayer.name or tostring(target), ["inline"] = false},
		{["name"] = "Item", ["value"] = tostring(itemName) .. ' x' .. tostring(amount), ["inline"] = false},
	})

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)


		if targetItem.count > 0 and targetItem.count <= amount then


			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetxPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('esx_fbi_job:handcuff')
AddEventHandler('esx_fbi_job:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_fbi_job:handcuff', target)
		local xTarget = ESX.GetPlayerFromId(target)
		TriggerEvent('esx_society:logAction', 'fbi', 'Player Cuffed', {
			{["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Suspect", ["value"] = xTarget and xTarget.name or tostring(target), ["inline"] = false},
		})
	else
		print(('esx_fbi_job: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_fbi_job ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : handcuff a player (not cop)! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_fbi_job:drag')
AddEventHandler('esx_fbi_job:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_fbi_job:drag', target, source)
	else
		print(('esx_fbi_job: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_fbi_job ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : drag (not cop)! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_fbi_job:putInVehicle')
AddEventHandler('esx_fbi_job:putInVehicle', function(target, netId)
  local xPlayer = ESX.GetPlayerFromId(source)
  -- BUG FIX: was `~= "nojob"`, which let ANY employed player (any job at
  -- all, not just fbi) force any target into a vehicle -- matches the
  -- `== 'fbi'` check used by every sibling handler in this file
  -- (handcuff, drag, OutVehicle).
  if xPlayer.job.name == "fbi" then
    TriggerClientEvent('esx_fbi_job:putInVehicle', target, netId)
  else

  end
end)

RegisterServerEvent('esx_fbi_job:OutVehicle')
AddEventHandler('esx_fbi_job:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'fbi' then
		TriggerClientEvent('esx_fbi_job:OutVehicle', target)
	else
		print(('esx_fbi_job: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
		TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_fbi_job ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : drag out from vehicle (not cop)! ]\n[ Reason Blocked : not authorized for this job action ]\n```', 'user', true, source, false)
	end
end)

RegisterServerEvent('esx_fbi_job:getStockItem')
AddEventHandler('esx_fbi_job:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_fbi armory just by calling this event with a valid
	-- item name. Restricted to actual fbi employees.
	if not xPlayer or xPlayer.job.name ~= 'fbi' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_fbi_job:getStockItem without the fbi job')
		end
		return
	end
	-- SECURITY FIX: previously had NO job check at all -- any player
	-- (any job, even none) could pull items straight out of the
	-- society_fbi armory just by calling this event with a valid
	-- item name. Restricted to actual fbi employees.
	if not xPlayer or xPlayer.job.name ~= 'fbi' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_fbi_job:getStockItem without the fbi job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fbi', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('esx_society:logAction', 'fbi', 'Stock Item Withdrawn', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
				})
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_fbi_job:putStockItems')
AddEventHandler('esx_fbi_job:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- SECURITY FIX: see getStockItem above -- same missing job check.
	if not xPlayer or xPlayer.job.name ~= 'fbi' then
		if exports.UNIQUE_AC then
			exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_fbi_job:putStockItems without the fbi job')
		end
		return
	end
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fbi', function(inventory)

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

ESX.RegisterServerCallback('esx_fbi_job:getOtherPlayerData', function(source, cb, target)

	if Config_fbi.EnableESXIdentity then

		local xPlayer = ESX.GetPlayerFromId(target)

		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config_fbi.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end

	else

		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)

	end

end)

ESX.RegisterServerCallback('esx_fbi_job:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_fbi_job:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_fbi.EnableESXIdentity then
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
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

ESX.RegisterServerCallback('esx_fbi_job:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_fbi.EnableESXIdentity then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					cb(result2[1].name, true)
				end

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_fbi_job:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_fbi_job:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

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

		TriggerEvent('esx_society:logAction', 'fbi', 'Armory Weapon Added', {
			{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Weapon", ["value"] = weaponName, ["inline"] = false},
		})

		cb()
	end)

end)

ESX.RegisterServerCallback('esx_fbi_job:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_society:logAction', 'fbi', 'Armory Weapon Withdrawn', {
		{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "Weapon", ["value"] = weaponName, ["inline"] = false},
	})

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_fbi', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)

end)

ESX.RegisterServerCallback('esx_fbi_job:buy', function(source, cb, amount)


	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
		if account.money >= amount then
			account.removeMoney(amount)

			local xPlayer = ESX.GetPlayerFromId(source)
			if xPlayer then
				TriggerEvent('esx_society:logAction', 'fbi', 'Society Purchase', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Amount", ["value"] = '$' .. amount, ["inline"] = false},
				})
			end

			cb(true)
		else
			cb(false)
		end
	end)

end)

ESX.RegisterServerCallback('esx_fbi_job:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fbi', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_fbi_job:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()

	local _source = source


	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)


		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'fbi' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_fbi_job:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_fbi_job:spawned')
AddEventHandler('esx_fbi_job:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'fbi' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_fbi_job:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_fbi_job:forceBlip')
AddEventHandler('esx_fbi_job:forceBlip', function()
	TriggerClientEvent('esx_fbi_job:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_fbi_job:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'fbi')
	end
end)

RegisterServerEvent('esx_fbi_job:message')
AddEventHandler('esx_fbi_job:message', function(target, msg)
	-- SECURITY FIX: previously had no check at all -- any player could
	-- send an arbitrary fake "system" notification to any target id.
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer or xPlayer.job.name ~= 'fbi' then return end
	if type(msg) ~= "string" then return end
	msg = msg:sub(1, 200):gsub("~[a-zA-Z]~", "")
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('esx_fbi_job:requestarrest')
AddEventHandler('esx_fbi_job:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- SECURITY FIX: previously had NO job check -- any player could
    -- "arrest" any other player. Matches the job gate used by
    -- handcuff/drag/OutVehicle elsewhere in this file.
    if not xPlayer or xPlayer.job.name ~= 'fbi' then
        if exports.UNIQUE_AC then
            exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_fbi_job:requestarrest without the fbi job')
        end
        return
    end
    TriggerClientEvent('esx_fbi_job:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_fbi_job:doarrested', _source)

    local xTarget = ESX.GetPlayerFromId(targetid)
    if xPlayer and xTarget then
        TriggerEvent('esx_society:logAction', 'fbi', 'Player Arrested', {
            {["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
            {["name"] = "Suspect", ["value"] = xTarget.name, ["inline"] = false},
        })
    end
end)

RegisterServerEvent('esx_fbi_job:requestrelease')
AddEventHandler('esx_fbi_job:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- SECURITY FIX: previously had NO job check -- any player could
    -- release any arrested player.
    if not xPlayer or xPlayer.job.name ~= 'fbi' then
        if exports.UNIQUE_AC then
            exports.UNIQUE_AC:BanPlayer(_source, 'Cheat Lua Executer', 'Tried esx_fbi_job:requestrelease without the fbi job')
        end
        return
    end
    TriggerClientEvent('esx_fbi_job:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_fbi_job:douncuffing', _source)

    local xTarget = ESX.GetPlayerFromId(targetid)
    if xPlayer and xTarget then
        TriggerEvent('esx_society:logAction', 'fbi', 'Player Released', {
            {["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
            {["name"] = "Suspect", ["value"] = xTarget.name, ["inline"] = false},
        })
    end
end)
