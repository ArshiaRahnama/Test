ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_cia.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'cia', Config_cia.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'cia', _U('alert_cia'), true, true)

TriggerEvent('esx_society:registerSociety', 'cia', 'cia', 'society_doj', 'society_cia', 'society_cia', {type = 'public'})

RegisterServerEvent('esx_cia_job:giveWeapon')
AddEventHandler('esx_cia_job:giveWeapon', function(weapon, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cia' then
		xPlayer.addWeapon(weapon, ammo)
		TriggerEvent('esx_society:logAction', 'cia', 'Weapon Given', {
			{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Weapon", ["value"] = weapon, ["inline"] = false},
		})
	else
		print(('esx_cia_job: %s attempted to give weapon!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_cia_job:confiscatePlayerItem')
AddEventHandler('esx_cia_job:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'cia' then
		print(('esx_cia_job: %s attempted to confiscate!'):format(sourceXPlayer.identifier))
		return
	end

	TriggerEvent('esx_society:logAction', 'cia', 'Item Confiscated', {
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
				targetXPlayer.removeInventoryItem(itemName, amount)
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

RegisterServerEvent('esx_cia_job:handcuff')
AddEventHandler('esx_cia_job:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cia' then
		TriggerClientEvent('esx_cia_job:handcuff', target)
		local xTarget = ESX.GetPlayerFromId(target)
		TriggerEvent('esx_society:logAction', 'cia', 'Player Cuffed', {
			{["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Suspect", ["value"] = xTarget and xTarget.name or tostring(target), ["inline"] = false},
		})
	else
		print(('esx_cia_job: %s attempted to handcuff a player (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_cia_job:drag')
AddEventHandler('esx_cia_job:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cia' then
		TriggerClientEvent('esx_cia_job:drag', target, source)
	else
		print(('esx_cia_job: %s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_cia_job:putInVehicle')
AddEventHandler('esx_cia_job:putInVehicle', function(target, netId)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name ~= "nojob" then
    TriggerClientEvent('esx_cia_job:putInVehicle', target, netId)
  else

  end
end)

RegisterServerEvent('esx_cia_job:OutVehicle')
AddEventHandler('esx_cia_job:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'cia' then
		TriggerClientEvent('esx_cia_job:OutVehicle', target)
	else
		print(('esx_cia_job: %s attempted to drag out from vehicle (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_cia_job:getStockItem')
AddEventHandler('esx_cia_job:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cia', function(inventory)

		local inventoryItem = inventory.getItem(itemName)


		if count > 0 and inventoryItem.count >= count then


			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				TriggerEvent('esx_society:logAction', 'cia', 'Stock Item Withdrawn', {
					{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
					{["name"] = "Item", ["value"] = itemName .. ' x' .. count, ["inline"] = false},
				})
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	end)

end)

RegisterServerEvent('esx_cia_job:putStockItems')
AddEventHandler('esx_cia_job:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cia', function(inventory)

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

ESX.RegisterServerCallback('esx_cia_job:getOtherPlayerData', function(source, cb, target)

	if Config_cia.EnableESXIdentity then

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

		if Config_cia.EnableLicenses then
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

ESX.RegisterServerCallback('esx_cia_job:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_cia_job:getVehicleInfos', function(source, cb, plate)

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

				if Config_cia.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_cia_job:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then

			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				if Config_cia.EnableESXIdentity then
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

ESX.RegisterServerCallback('esx_cia_job:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cia', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_cia_job:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cia', function(store)

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

		TriggerEvent('esx_society:logAction', 'cia', 'Armory Weapon Added', {
			{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
			{["name"] = "Weapon", ["value"] = weaponName, ["inline"] = false},
		})

		cb()
	end)

end)

ESX.RegisterServerCallback('esx_cia_job:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)

	TriggerEvent('esx_society:logAction', 'cia', 'Armory Weapon Withdrawn', {
		{["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
		{["name"] = "Weapon", ["value"] = weaponName, ["inline"] = false},
	})

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_cia', function(store)

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

ESX.RegisterServerCallback('esx_cia_job:buy', function(source, cb, amount)


	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
		if account.money >= amount then
			account.removeMoney(amount)

			local xPlayer = ESX.GetPlayerFromId(source)
			if xPlayer then
				TriggerEvent('esx_society:logAction', 'cia', 'Society Purchase', {
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

ESX.RegisterServerCallback('esx_cia_job:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cia', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_cia_job:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()

	local _source = source


	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)


		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'cia' then
			Citizen.Wait(5000)
			TriggerClientEvent('esx_cia_job:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('esx_cia_job:spawned')
AddEventHandler('esx_cia_job:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'cia' then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_cia_job:updateBlip', -1)
	end
end)

RegisterServerEvent('esx_cia_job:forceBlip')
AddEventHandler('esx_cia_job:forceBlip', function()
	TriggerClientEvent('esx_cia_job:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('esx_cia_job:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'cia')
	end
end)

RegisterServerEvent('esx_cia_job:message')
AddEventHandler('esx_cia_job:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)

RegisterServerEvent('esx_cia_job:requestarrest')
AddEventHandler('esx_cia_job:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('esx_cia_job:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_cia_job:doarrested', _source)

    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(targetid)
    if xPlayer and xTarget then
        TriggerEvent('esx_society:logAction', 'cia', 'Player Arrested', {
            {["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
            {["name"] = "Suspect", ["value"] = xTarget.name, ["inline"] = false},
        })
    end
end)

RegisterServerEvent('esx_cia_job:requestrelease')
AddEventHandler('esx_cia_job:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('esx_cia_job:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_cia_job:douncuffing', _source)

    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(targetid)
    if xPlayer and xTarget then
        TriggerEvent('esx_society:logAction', 'cia', 'Player Released', {
            {["name"] = "Agent", ["value"] = xPlayer.name, ["inline"] = false},
            {["name"] = "Suspect", ["value"] = xTarget.name, ["inline"] = false},
        })
    end
end)