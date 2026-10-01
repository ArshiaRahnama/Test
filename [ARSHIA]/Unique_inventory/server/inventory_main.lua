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
                label = GetCachedWeaponLabel(v.name),
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
                label = GetCachedWeaponLabel(v.name),
                count = v.ammo,
                -- FIX: gang "Item Access" boss-menu locks existed but were
                -- never actually enforced anywhere the player could see/take
                -- items from (see server/job_gang_lock.lua). Item stays
                -- visible either way; NUI shows a lock badge for locked ones.
                locked = IsGangItemLocked(xPlayer, v.name)
            })
        end
    end

    for k,v in pairs(items2) do
        if v.count > 0 then
            table.insert(items, {
                type = 'item_standard',
                name = v.name,
                label = v.label,
                count = v.count,
                locked = IsGangItemLocked(xPlayer, v.name)
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
--
-- FIX (item-lock feature): this used to build a list of ONLY the weapons the
-- player is authorized for (everything else silently disappeared from the
-- armory). Now returns EVERY armory weapon, each tagged `authorized`, so the
-- caller can decide to show-but-lock instead of hide - same UX as the gang
-- inventory's lock badge.
local function getJobArmoryWeapons(src, xPlayer)
    local list = {}
    if not xPlayer or not xPlayer.job then return list end
    local grade, job = xPlayer.job.grade, xPlayer.job.name

    TriggerEvent('esx_policejob:getArmoryWeapons', src, function(weapons)
        TriggerEvent('esx_society:getWeapons', src, grade, job, function(authorizedWeapons)
            if type(weapons) ~= 'table' then return end
            authorizedWeapons = type(authorizedWeapons) == 'table' and authorizedWeapons or {}
            for i = 1, #weapons do
                if not BlockedWeapons[string.upper(weapons[i].name)] then
                    local authorized = false
                    for _, shared in ipairs(authorizedWeapons) do
                        if shared.model == weapons[i].name and shared.status == true then
                            authorized = true
                            break
                        end
                    end
                    list[#list + 1] = { name = weapons[i].name, authorized = authorized }
                end
            end
        end)
    end)

    return list
end

-- Kept for anything else that might still call the old name/shape (returns
-- only the authorized weapon NAMES) - GetJobWeapon below uses this for its
-- hard server-side check.
local function getAuthorizedJobWeapons(src, xPlayer)
    local list = {}
    for _, w in ipairs(getJobArmoryWeapons(src, xPlayer)) do
        if w.authorized then list[#list + 1] = w.name end
    end
    return list
end

RegisterServerCallbackSafe("Parzival:getJobINV1", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = {}

    for _, w in ipairs(getJobArmoryWeapons(source, xPlayer)) do
        table.insert(items, {
            type = 'item_weapon',
            name = w.name,
            label = GetCachedWeaponLabel(w.name),
            count = 1,
            -- FIX (item-lock feature): show every armory weapon; lock the
            -- ones this grade isn't authorized for instead of hiding them.
            locked = not w.authorized
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
                        count = elements[i].count,
                        -- FIX (item-lock feature): grade-gated job-stock items
                        -- (config_joblock.lua) show up but locked instead of
                        -- either being fully hidden or fully takeable by anyone.
                        locked = IsJobItemLocked(xPlayer, elements[i].value)
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
    if not xPlayer then return end

    -- FIX (item-lock feature, real enforcement): the UI now shows locked
    -- items instead of hiding them, so the server MUST reject a take request
    -- for one even if a modified client sends it anyway.
    if IsJobItemLocked(xPlayer, item) then
        TriggerClientEvent('esx:showNotification', source, 'این آیتم برای رتبه‌ی شما قفل است')
        return
    end

    local sourceItem = xPlayer.getInventoryItem(string.lower(item))
    -- FIX: inventoryItem/sourceItem being nil (item unknown to this society)
    -- used to crash this whole callback with "attempt to index a nil value".
    if not sourceItem then return end

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)

        local inventoryItem = inventory.getItem(string.lower(item))
        if not inventoryItem then return end

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
    if not xPlayer then return end
    -- FIX: was raw `item` here while GetJobItem always lower-cases - a client
    -- sending an upper-case item name would pass GetJobItem but silently fail
    -- here. Also added the nil-checks GetJobItem already got above.
    item = string.lower(item)
    local sourceItem = xPlayer.getInventoryItem(item)
    if sourceItem and sourceItem.count >= count then

        TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..xPlayer.job.name, function(inventory)
    
            local inventoryItem = inventory.getItem(item)
            if not inventoryItem then return end
    
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

-------------------------------------------------------------------------
-- FIX (found while wiring the gang item-lock feature): "gangs:getFromInventory"
-- and "gangs:addToInventory" are fired by client/inventory_main.lua (take
-- from / put into gang inventory) but NEVER had a server-side listener
-- ANYWHERE in this codebase - the gang chest's take/put buttons did
-- absolutely nothing server-side (visual only). Implemented properly here,
-- using the exact same esx_addoninventory/esx_datastore shared-gang-store
-- Parzival:getGangINV already reads from, so what you see in the chest is
-- what you can actually take.
-------------------------------------------------------------------------
RegisterNetEvent('gangs:getFromInventory', function(itemType, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or type(count) ~= 'number' or count <= 0 then return end

    if IsGangItemLocked(xPlayer, itemName) then
        TriggerClientEvent('esx:showNotification', source, 'این آیتم برای رتبه‌ی شما در گنگ قفل است')
        return
    end

    local GANG = 'gang_' .. string.lower(xPlayer.gang.name)

    if itemType == 'item_weapon' then
        local upper = string.upper(itemName)
        if BlockedWeapons[upper] then return end
        if xPlayer.hasWeapon(upper) then return end

        TriggerEvent('esx_datastore:getSharedDataStore', GANG, function(store)
            local weapons = store.get('weapons') or {}
            for i = 1, #weapons do
                if string.upper(weapons[i].name) == upper then
                    table.remove(weapons, i)
                    store.set('weapons', weapons)
                    xPlayer.addWeapon(upper, 250)
                    return
                end
            end
        end)
    else
        local sourceItem = xPlayer.getInventoryItem(string.lower(itemName))
        if not sourceItem then return end

        TriggerEvent('esx_addoninventory:getSharedInventory', GANG, function(inventory)
            local inventoryItem = inventory.getItem(string.lower(itemName))
            if not inventoryItem or inventoryItem.count < count then return end
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then return end

            inventory.removeItem(string.lower(itemName), count)
            xPlayer.addInventoryItem(string.lower(itemName), count)
        end)
    end
end)

RegisterNetEvent('gangs:addToInventory', function(itemType, itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not xPlayer.gang or type(count) ~= 'number' or count <= 0 then return end

    local GANG = 'gang_' .. string.lower(xPlayer.gang.name)

    if itemType == 'item_weapon' then
        local upper = string.upper(itemName)
        if not xPlayer.hasWeapon(upper) then return end

        TriggerEvent('esx_datastore:getSharedDataStore', GANG, function(store)
            local weapons = store.get('weapons') or {}
            local found = false
            for i = 1, #weapons do
                if string.upper(weapons[i].name) == upper then
                    weapons[i].count = (weapons[i].count or 0) + 250
                    found = true
                    break
                end
            end
            if not found then
                table.insert(weapons, { name = upper, count = 250 })
            end
            store.set('weapons', weapons)
            xPlayer.removeWeapon(upper)
        end)
    else
        local sourceItem = xPlayer.getInventoryItem(string.lower(itemName))
        if not sourceItem or sourceItem.count < count then return end

        TriggerEvent('esx_addoninventory:getSharedInventory', GANG, function(inventory)
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        end)
    end
end)