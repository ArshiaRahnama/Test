ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("Parzival:getHouseINV", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}
    local items2      = {}
    local weapons    = {}

    TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayer.identifier, function(inventory)
        items2 = inventory.items
    end)
    
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        weapons = store.get('weapons') or {}
    end)

    for k,v in pairs(weapons) do
        if string.lower(v.name) == 'weapon_sniperrifle' then

		elseif string.lower(v.name) == 'weapon_heavysniper' then

		else
            table.insert(items, {
                type = 'item_weapon',
                name = v.name,
                label = ESX.GetWeaponLabel(v.name),
                count = v.ammo.ammo
            })
        end
    end

    for k,v in pairs(items2) do
        if v.count > 0 then
            table.insert(items, {
                type = 'item_standard',
                name = v.name,
                label = v.label,
                count = v.count
            })
        end
    end
    cb(items)
end)

ESX.RegisterServerCallback("Parzival:getGangINV", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}
    local items2      = {}
    local weapons    = {}
    local GANG = 'gang_' .. string.lower(xPlayer.gang.name)
    TriggerEvent('esx_addoninventory:getSharedInventory', GANG, function(inventory)
        items2 = inventory.items
    end)
    TriggerEvent('esx_datastore:getSharedDataStore', GANG, function(store)
        weapons = store.get('weapons') or {}
    end)

    for k,v in pairs(weapons) do
        if string.lower(v.name) == 'weapon_sniperrifle' then

		elseif string.lower(v.name) == 'weapon_heavysniper' then

		else
            table.insert(items, {
                type = 'item_weapon',
                name = v.name,
                label = ESX.GetWeaponLabel(v.name),
                count = v.ammo
            })
        end
    end

    for k,v in pairs(items2) do
        if v.count > 0 then
            table.insert(items, {
                type = 'item_standard',
                name = v.name,
                label = v.label,
                count = v.count
            })
        end
    end
    cb(items)
end)

ESX.RegisterServerCallback("Parzival:getJobINV1", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}
        local grade = xPlayer.job.grade
        local job = xPlayer.job.name
        TriggerEvent('esx_policejob:getArmoryWeapons', source, function(weapons)
            TriggerEvent('esx_society:getWeapons', source, grade, job, function(authorizedWeapons)
                local elements = {}
                for i=1, #weapons, 1 do
                    local found = false
                    --if weapons[i].count > 0 then
                        if authorizedWeapons ~= nil then
                            for _,sharedWeapons in ipairs(authorizedWeapons) do
                                if found then break end
                                if sharedWeapons.model == weapons[i].name and sharedWeapons.status == true then
                                    wname = ESX.GetWeaponLabel(weapons[i].name)
                                    table.insert(elements, {label = wname, value = weapons[i].name})
                                    found = true
                                end
                            end
                        end
                    --end
                end

                for i=1, #elements, 1 do
                    if string.lower(elements[i].value) == 'weapon_sniperrifle' then

                    elseif string.lower(elements[i].value) == 'weapon_heavysniper' then
            
                    else
                        table.insert(items, {
                            type = 'item_weapon',
                            name = elements[i].value,
                            label = ESX.GetWeaponLabel(elements[i].value),
                            count = 1
                        })
                    end
                end
                
            end)
        end)

    cb(items)
end)

ESX.RegisterServerCallback("Parzival:getJobINV2", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}
      
    TriggerEvent('esx_policejob:getStockItems', source, function(itemsss)

        local elements = {}

        for i=1, #itemsss, 1 do
            table.insert(elements, {label = (itemsss[i].label or "Unknown"), value = itemsss[i].name, count = itemsss[i].count})
        end

        for i=1, #elements, 1 do
            if elements[i].count > 0 then
                
                    table.insert(items, {
                        type = 'item_standard',
                        name = elements[i].value,
                        label = elements[i].label,
                        count = elements[i].count
                    })
            end
        end

    end)
    cb(items)
end)

RegisterNetEvent('Parzival:GetJobWeapon', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    print('1')
    if not xPlayer.hasWeapon(item) then
        print('123')
               
        -- TriggerEvent('DiscordBot:ToDiscord', 'policearmory', xPlayer.name, 'Withdrawn ' .. weaponName ,'user', source, true, false)
        -- TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..xPlayer.job.name, function(store)
    
        --     local weapons = store.get('weapons')
    
        --     if weapons == nil then
        --         weapons = {}
        --     end
    
        
         
           
        --     for i=1, #weapons, 1 do
        --         if weapons[i].name == item and weapons[i].count == item.count then

        --             table.remove(weapons, i)
        --             break
        --         end
        --     end
            
            xPlayer.addWeapon(item, 250)
            TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name, 'Bardasht '..item ,'user', source, true, false)
            -- store.set('weapons', weapons)
        
        -- end)
    end
end)

RegisterNetEvent('Parzival:PutJobWeapon', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.hasWeapon(item) then
        local loadoutNum,  testest = xPlayer.getWeapon(item)
        TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..xPlayer.job.name, function(store)

            local weapons = store.get('weapons')

            if weapons == nil then
                weapons = {}
            end

            
            local foundWeapon = false

            for i=1, #weapons, 1 do
                if weapons[i].name == item then
                    weapons[i].count = weapons[i].count + 10
                    foundWeapon = true
                    break
                end
            end

            if not foundWeapon then
                table.insert(weapons, {
                    name  = item,
                    count = testest.ammo
                })
            end

            


            store.set('weapons', weapons)
            xPlayer.removeWeapon(item) 
            TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name, 'Gozashtan ' .. item ,'user', source, true, false)
    
        end)
    else 
        TriggerClientEvent('inventory:notify', src, 'error', 'in aslahe ro nadari')
    end
end)

RegisterNetEvent('Parzival:GetJobItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(string.lower(item))
        
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)

        local inventoryItem = inventory.getItem(string.lower(item))

        -- is there enough in the society?
        if count > 0 and inventoryItem.count >= count then
        
            -- can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
            else
                inventory.removeItem(string.lower(item), count)
                xPlayer.addInventoryItem(string.lower(item), count)
                -- TriggerEvent('DiscordBot:ToDiscord', 'policearmory', xPlayer.name, 'Withdrawn x' ..count ..' '..inventoryItem.label ,'user', source, true, false)
                
                if xPlayer.job.name == 'ambulance' then
                    TriggerEvent('DiscordBot:ToDiscord', 'mediclocker', xPlayer.name, 'Bardasht x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
                else
                    TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name, 'Bardasht x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
                end
            end
        else

        end
    end)
end)

RegisterNetEvent('Parzival:PutJobItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(item).count >= count then
        local sourceItem = xPlayer.getInventoryItem(item)

        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
    
            local inventoryItem = inventory.getItem(item)
    
            -- does the player have enough of the item?
            if sourceItem.count >= count and count > 0 then
                xPlayer.removeInventoryItem(item, count)
                inventory.addItem(item, count)
                if xPlayer.job.name == 'ambulance' then
                    TriggerEvent('DiscordBot:ToDiscord', 'mediclocker', xPlayer.name, 'Gozashtan x' ..count ..' '..inventoryItem.label, 'user' , true, source, false)
                else
                    TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name, 'Bardasht x' ..count ..' '..inventoryItem.label ,'user', true, source, false)
                end
            else
                
            end
    
        end)
        

    end
end)