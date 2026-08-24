ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
for _, cafe in pairs(Cafes) do
	TriggerEvent('esx_society:registerSociety', cafe.Job, cafe.Label, 'society_' .. cafe.Job, 'society_' .. cafe.Job, 'society_' .. cafe.Job, {type = 'public'})
end

local cooldown = {}

ESX.RegisterServerCallback('AH_uwucafejob:getPropertyInventory', function(source, cb, station)
	local xPlayer    = ESX.GetPlayerFromId(source)

	local items      = {}
	local weapons    = {}
	local item = {}
	local weapons = {}

	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
		
		if inventory then 
			for k,v in pairs(inventory.items) do 
				local invitem = v.name
				local testd   = v.count
				local itlab   = v.label
				
				table.insert(items, {
					count = testd,
					name = invitem,
					label = itlab
				})
					
			end
		end
	end)
	


	cb({
		dirty_money = {},
		items      = items,
		weapons    = {}
	})
end)

AddEventHandler('playerDropped', function()

    _source = source

    if cooldown[_source] then
      cooldown[_source] = nil
    end

end)


RegisterServerEvent('minijob:getFromInventory')
AddEventHandler('minijob:getFromInventory', function(type2, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)


	if type2 == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)


        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
            local inventoryItem = inventory.getItem(item)

            -- is there enough in the property?
            if count > 0 and inventoryItem.count >= count then
            
                -- can the player carry the said amount of x item?
                if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                    -- TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
                else
                    inventory.removeItem(item, count)
                    xPlayer.addInventoryItem(item, count)

                end
            else
                -- TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
            end
        end)
            

	elseif type2 == 'item_weapon' then
		local weapon = xPlayer.hasWeapon(item)

		if not weapon then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..xPlayer.job.name, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
				local components   = {}

				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
						components = storeWeapons[i].components
						table.remove(storeWeapons, i)
						break
					end
				end

				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)

				if type(components) == 'table' then 
					for k,v in pairs(components) do 
						xPlayer.addWeaponComponent(weaponName, v)

					end
				else
					xPlayer.addWeaponComponent(weaponName, components)
				end
			
		
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, 'Shoma Dar hale Hazer in Aslahe ro darid')			
		end

	end

end)


RegisterServerEvent('minijob:addToInventory')
AddEventHandler('minijob:addToInventory', function(type, item, count)
	local _source      = source

	if cooldown[_source] then
		if os.time() - cooldown[_source] <= 2 then
		  TriggerClientEvent('esx:showNotification', source, '~h~Lotfan spam nakonid!')
		  return
		else
		  cooldown[_source] = os.time()
		end
	else
	cooldown[_source] = os.time()
	end


	local xPlayer      = ESX.GetPlayerFromId(_source)

	
	if type == 'item_standard' then
		local playerItem = xPlayer.getInventoryItem(item)
		local playerItemCount = playerItem.count
		local isvorod = false 
        local itemwahite = false
		if string.sub(playerItem.name, 1, 7) == "CarKey|" and playerItemCount ~= 0 then
			isvorod = false 
		else
			isvorod = true 
		end
		
		if isvorod then 
            for i,items2 in pairs(Config.UwUItems) do 
                if item == items2 then 
                    itemwahite = true
                    break
                else
                    itemwahite = false 
                end
            end
            if itemwahite then
                if playerItemCount >= count and count > 0 then
                    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
                        
                        xPlayer.removeInventoryItem(item, count)
                        inventory.addItem(item, count)
                        
                    end)
                else
                    -- TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
                end
            else
                TriggerClientEvent('esx:showNotification', _source, "Shoma Fagat Item Haye In Cafe Ro Mitavanid Dakhel Freezr Bezarid!!")
            end
            
		end

	elseif type == 'item_weapon' then
        local amir = false
        if amir then 
            local weapon = xPlayer. hasWeapon(item)

            if weapon then
                TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..xPlayer.job.name, function(store)
                    local storeWeapons = store.get('weapons') or {}
                    
                    
                    table.insert(storeWeapons, {
                        name = item,
                        ammo = weapon.ammo,
                        components = weapon.components
                    })

                    store.set('weapons', storeWeapons)
                    xPlayer.removeWeapon(item)
        
                
                end)
            else
            end
        end
	end
end)

RegisterNetEvent('AH_uwucafejob:BuyItems')
AddEventHandler('AH_uwucafejob:BuyItems', function(items, counts, prises)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem(items).limit >= (xPlayer.getInventoryItem(items).count + counts) then
		if xPlayer.bank >= (prises*counts) then 
			xPlayer.removeBank(prises*counts)
			xPlayer.addInventoryItem(items, counts)

			TriggerClientEvent('chat:addMessage', source, { args = { "^1[SYSTEM]: ^0Shoma ^2"..counts.."^0 Item Be Mablagh ^2"..prises*counts.." $ ^0Kharidid" } })
		else
			TriggerClientEvent('esx:showNotification', source, "Pool Bank Shoma Kafi Nist Baraye Kharid")
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Jib Shoma Fazae Kafi Nadarad")
	end
end)




RegisterServerEvent("spawnCarOnMarker")
AddEventHandler("spawnCarOnMarker", function(vehicleName)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end

    local myCafe = GetCafeForJob(xPlayer.job.name)
    if myCafe then
        if vehicleName == myCafe.SpawnVehicle then
            TriggerClientEvent("spawnCarClient", source, vehicleName)
        else
            TriggerClientEvent("chatMessage", source, "^1شما فقط می‌توانید '" .. myCafe.SpawnVehicle .. "' اسپاون کنید.")
        end
    else
        TriggerClientEvent("chatMessage", source, "^1شما اجازه این کار را ندارید!")
    end
end)

RegisterNetEvent('AH_uwucafejob:blingrequest')
AddEventHandler('AH_uwucafejob:blingrequest', function(player, target, ammont)

	TriggerClientEvent('AH_uwucafejob:OpenMenuDialog', player, player, target, ammont)
end)

RegisterNetEvent('AH_uwucafejob:ChatMessage')
AddEventHandler('AH_uwucafejob:ChatMessage', function(target, player, Chek)

	if Chek then 
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^2'..tonumber(player)..' ^0| ^2Ghabol ^0Shod' } })
	else
		TriggerClientEvent('chat:addMessage', target, { args = { '^1SYSTEM', 'Darkhast Ghabz Tavasot ID: ^1'..tonumber(player)..' ^0|^1Rad ^0Shod' } })
	end
end)


ESX.RegisterServerCallback("AH_uwucafejob:GetOnDutyJob", function(source, cb)
	for k,v in pairs(GetPlayers()) do 
		local Target = ESX.GetPlayerFromId(v)
		if IsCafeJob(Target.job.name) then 
			cb(true)
			return
		end
	end
	cb(false)
end)