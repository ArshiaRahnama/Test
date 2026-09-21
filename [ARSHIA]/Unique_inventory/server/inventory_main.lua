ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerCallbackSafe("Parzival:getHouseINV", function(source, cb)
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

RegisterServerCallbackSafe("Parzival:getGangINV", function(source, cb)
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

local BlockedWeapons = {
    WEAPON_SNIPERRIFLE = true,
    WEAPON_HEAVYSNIPER = true,
}

-- Single source of truth for "which armory weapons may THIS player take".
-- Used by BOTH the UI list (getJobINV1) and the take-weapon event below, so a
-- client can never request a weapon the menu wouldn't have shown it.
local function getAuthorizedJobWeapons(src, xPlayer)
    local list = {}
    if not xPlayer or not xPlayer.job then return list end
    local grade, job = xPlayer.job.grade, xPlayer.job.name

    TriggerEvent('esx_policejob:getArmoryWeapons', src, function(weapons)
        TriggerEvent('esx_society:getWeapons', src, grade, job, function(authorizedWeapons)
            if type(weapons) ~= 'table' or type(authorizedWeapons) ~= 'table' then return end
            for i = 1, #weapons do
                for _, shared in ipairs(authorizedWeapons) do
                    if shared.model == weapons[i].name and shared.status == true then
                        if not BlockedWeapons[string.upper(weapons[i].name)] then
                            list[#list + 1] = weapons[i].name
                        end
                        break
                    end
                end
            end
        end)
    end)

    return list
end

RegisterServerCallbackSafe("Parzival:getJobINV1", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}

    for _, name in ipairs(getAuthorizedJobWeapons(source, xPlayer)) do
        table.insert(items, {
            type = 'item_weapon',
            name = name,
            label = ESX.GetWeaponLabel(name),
            count = 1
        })
    end

    cb(items)
end)

RegisterServerCallbackSafe("Parzival:getJobINV2", function(source, cb)
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
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or type(item) ~= 'string' then return end

    item = string.upper(item)
    if BlockedWeapons[item] then return end

    -- FIX (exploit): this event used to trust the weapon name from the client
    -- with no checks at all, so any player could trigger it and receive any
    -- weapon with 250 ammo. The weapon must now be in the player's own
    -- authorized armory list (same list the menu shows).
    local allowed = false
    for _, name in ipairs(getAuthorizedJobWeapons(_source, xPlayer)) do
        if string.upper(name) == item then allowed = true break end
    end
    if not allowed then
        print(('^3[Unique_inventory]^0 blocked Parzival:GetJobWeapon from %s (%s) -> %s'):format(
            _source, GetPlayerName(_source) or '?', item))
        return
    end

    if xPlayer.hasWeapon(item) then return end

    -- armory weapons carry a DOJ- serial (see essentialmode/server/common.lua)
    local serial = ESX.GenerateWeaponSerial and ESX.GenerateWeaponSerial('DOJ') or nil
    xPlayer.addWeapon(item, 250, serial)
    TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name,
        'Bardasht ' .. item .. (serial and (' [' .. serial .. ']') or ''), 'user', _source, true, false)
end)

RegisterNetEvent('Parzival:PutJobWeapon', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or type(item) ~= 'string' then return end

    if xPlayer.hasWeapon(item) then
        local loadoutNum, weaponData = xPlayer.getWeapon(item)
        TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job.name, function(store)
            local weapons = store.get('weapons') or {}
            local foundWeapon = false

            for i = 1, #weapons, 1 do
                if weapons[i].name == item then
                    weapons[i].count = weapons[i].count + 10
                    foundWeapon = true
                    break
                end
            end

            if not foundWeapon then
                table.insert(weapons, {
                    name  = item,
                    count = weaponData.ammo
                })
            end

            store.set('weapons', weapons)
            xPlayer.removeWeapon(item)
            TriggerEvent('DiscordBot:ToDiscord', xPlayer.job.name, xPlayer.name, 'Gozashtan ' .. item, 'user', _source, true, false)
        end)
    else
        -- FIX: this used an undefined variable `src` (always nil -> notification never sent)
        TriggerClientEvent('esx:showNotification', _source, 'in aslahe ro nadari')
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