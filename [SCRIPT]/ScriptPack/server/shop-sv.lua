ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- FIX (security): every buy_* handler below used to trust an `itemPrice`
-- argument sent directly by the client, e.g.:
--     AddEventHandler('shops_item:buy_shops', function(itemName, amount, itemPrice)
--         local totalPrice = itemPrice * amount
-- A modified client (trainer) could send itemPrice = 0 or a negative number
-- to get items for free, or even to gain money (negative totalPrice -> payAny
-- effectively adds funds). The fix below always looks the price up
-- server-side from ShopConfig and ignores whatever price the client claims.
-- `amount` is also now validated as a positive integer.

local function isValidAmount(amount)
    amount = tonumber(amount)
    return amount ~= nil and amount > 0 and amount == math.floor(amount)
end

ESX.RegisterServerCallback('getitemsForSaleShops', function(source, cb)
    local itemsForSaleShops = {}

    for itemName, itemData in pairs(ShopConfig.itemsForSaleShops) do
        table.insert(itemsForSaleShops, {
            name = itemName,
            label = ESX.GetItemLabel(itemName),
            price = itemData.price,
            category = itemData.category
        })
    end

    cb(itemsForSaleShops)
end)

RegisterServerEvent('shops_item:buy_shops')
AddEventHandler('shops_item:buy_shops', function(itemName, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleShops[itemName]
    if not itemData or not isValidAmount(amount) then return end

    local itemPrice = itemData.price -- server-authoritative price, not client-supplied
    local totalPrice = itemPrice * amount

    if xPlayer.canAfford(totalPrice) then

        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)

        if item and (item.limit == -1 or (item.count + amount <= item.limit)) then

            xPlayer.payAny(totalPrice)

            xPlayer.addInventoryItem(itemName, amount)

            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Cost : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)

            TriggerClientEvent('chat:addMessage', source, {
            args = {"[System]", 'Shoma ^2 ' .. amount .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
            color = {255, 0, 0}
            })

        end
    else

        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)

ESX.RegisterServerCallback('getitemsForSaleMC', function(source, cb)
    local itemsForSaleMC = {}

    for itemName, itemData in pairs(ShopConfig.itemsForSaleMC) do
        table.insert(itemsForSaleMC, {
            name = itemName,
            label = ESX.GetItemLabel(itemName),
            price = itemData.price,
            category = itemData.category
        })
    end

    cb(itemsForSaleMC)
end)

RegisterServerEvent('mc_item:buy_mc')
AddEventHandler('mc_item:buy_mc', function(itemName, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleMC[itemName]
    if not itemData or not isValidAmount(amount) then return end

    local itemPrice = itemData.price
    local totalPrice = itemPrice * amount

    if xPlayer.canAfford(totalPrice) then

        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)

        if item and (item.limit == -1 or (item.count + amount <= item.limit)) then

            xPlayer.payAny(totalPrice)

            xPlayer.addInventoryItem(itemName, amount)

            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Cost : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)

            TriggerClientEvent('chat:addMessage', source, {
            args = {"[System]", 'Shoma ^2 ' .. amount .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
            color = {255, 0, 0}
            })

        end
    else

        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)

ESX.RegisterServerCallback('getitemsForSaleNarekshop', function(source, cb)
    local itemsForSaleNarekshop = {}

    for itemName, itemData in pairs(ShopConfig.itemsForSaleNarekshop) do
        table.insert(itemsForSaleNarekshop, {
            name = itemName,
            label = ESX.GetItemLabel(itemName),
            price = itemData.price,
            category = itemData.category
        })
    end

    cb(itemsForSaleNarekshop)
end)

RegisterServerEvent('narekshop_item:buy_narekshop')
AddEventHandler('narekshop_item:buy_narekshop', function(itemName, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleNarekshop[itemName]
    if not itemData or not isValidAmount(amount) then return end

    local itemPrice = itemData.price
    local totalPrice = itemPrice * amount

    if xPlayer.canAfford(totalPrice) then

        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)

        if item and (item.limit == -1 or (item.count + amount <= item.limit)) then

            xPlayer.payAny(totalPrice)

            xPlayer.addInventoryItem(itemName, amount)

            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Cost : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)

            TriggerClientEvent('chat:addMessage', source, {
                args = {"[System]", 'Shoma ^2 ' .. amount .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
                color = {255, 0, 0}
            })

        end
    else

        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)

ESX.RegisterServerCallback('getitemsForSaleGunshop', function(source, cb)
    local itemsForSaleGunshop = {}

    for itemName, itemData in pairs(ShopConfig.itemsForSaleGunshop) do
        table.insert(itemsForSaleGunshop, {
            name = itemName,
            label = ESX.GetWeaponLabel(itemName),
            price = itemData.price,
            category = itemData.category,
            meta = ShopConfig.GunshopMeta[itemName],
            itemType = 'weapon'
        })
    end

    -- Ammo entries (see ShopConfig.itemsForSaleAmmoGunshop) merged into
    -- the same list -- ESX.Items[name].label since these are regular
    -- items, not weapons, so ESX.GetWeaponLabel doesn't apply to them.
    for itemName, itemData in pairs(ShopConfig.itemsForSaleAmmoGunshop) do
        local itemInfo = ESX.Items[itemName]
        table.insert(itemsForSaleGunshop, {
            name = itemName,
            label = itemInfo and itemInfo.label or itemName,
            price = itemData.price,
            amount = itemData.amount or 1,
            category = itemData.category,
            itemType = 'ammo'
        })
    end

    -- Permits (see ShopConfig.itemsForSaleGunshopPermits) -- not weapons or
    -- real items, they grant a row in user_licenses (licenseConfig.licenses)
    -- instead. See gunshop_item:buy_permit below.
    for itemName, itemData in pairs(ShopConfig.itemsForSaleGunshopPermits) do
        local licenseInfo = licenseConfig.licenses[itemData.licenseType]
        table.insert(itemsForSaleGunshop, {
            name = itemName,
            label = licenseInfo and licenseInfo.label or itemName,
            price = itemData.price,
            category = itemData.category,
            itemType = 'permit'
        })
    end

    cb(itemsForSaleGunshop)
end)

-- Basic anti-spam: one gunshop purchase per 500ms per player, so a
-- fast-clicking macro/exploit can't fire the buy event faster than the
-- server can process it. Resets naturally as it's just a per-source
-- timestamp table, no cleanup needed since it's small and keyed by
-- source (which FiveM reuses).
local lastGunshopPurchase = {}

local function isRateLimited(source)
    local now = GetGameTimer()
    local last = lastGunshopPurchase[source]
    if last and (now - last) < 500 then return true end
    lastGunshopPurchase[source] = now
    return false
end

RegisterServerEvent('gunshop_item:buy_gunshop')
AddEventHandler('gunshop_item:buy_gunshop', function(itemName, amount)
    local source = source
    if isRateLimited(source) then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleGunshop[itemName]
    if not itemData or not isValidAmount(amount) then return end

    local itemPrice = itemData.price
    local totalPrice = itemPrice * amount

    if xPlayer.canAfford(totalPrice) then

        local itemLabel = ESX.GetWeaponLabel(itemName)

        xPlayer.payAny(totalPrice)

        xPlayer.addWeapon(itemName, 50)

        TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought Weapon : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Cost : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)

        TriggerClientEvent('chat:addMessage', source, {
            args = {"[System]", 'Shoma ^2 ' .. amount .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
            color = {255, 0, 0}
        })

    else

        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)

-- Buys a permit/license (see ShopConfig.itemsForSaleGunshopPermits), e.g.
-- the DYS permit that lets a player fire a suppressed weapon inside the NCZ
-- (see client/ncz-cl.lua). This does NOT go through the normal
-- server/licensemenu-sv.lua 'license:add' event (that one is F6/staff-only
-- and doesn't take payment) -- it writes to user_licenses directly here,
-- always permanent, then asks licensemenu-sv.lua to push the refreshed
-- license list to the buyer via the 'license:internalPush' event.
RegisterServerEvent('gunshop_item:buy_permit')
AddEventHandler('gunshop_item:buy_permit', function(itemName)
    local source = source
    if isRateLimited(source) then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleGunshopPermits[itemName]
    if not itemData then return end

    local licenseType = itemData.licenseType
    local licenseInfo = licenseConfig.licenses[licenseType]
    if not licenseInfo then return end

    local identifier = GetPlayerIdentifier(source, 0)

    MySQL.Async.fetchAll('SELECT 1 FROM user_licenses WHERE owner = @owner AND type = @type', {
        ['@owner'] = identifier,
        ['@type']  = licenseType
    }, function(rows)
        if rows[1] then
            TriggerClientEvent('esx:showNotification', source, 'Shoma az ghabl in mojavez ra darid.')
            return
        end

        if not xPlayer.canAfford(itemData.price) then
            TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
            return
        end

        xPlayer.payAny(itemData.price)

        MySQL.Async.execute('INSERT INTO user_licenses (owner, type, expire, granted_by, description, created_at) VALUES (@owner, @type, 0, @granted_by, @description, @created_at)', {
            ['@owner']       = identifier,
            ['@type']        = licenseType,
            ['@granted_by']  = 'Gun Shop',
            ['@description'] = 'Kharide shode az Gun Shop',
            ['@created_at']  = os.time()
        }, function(rowsChanged)
            if rowsChanged and rowsChanged > 0 then
                xPlayer.showNotification(('~g~Shoma %s ra kharidid!'):format(licenseInfo.label))
                TriggerEvent('license:internalPush', source)

                TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought Permit : '..tostring(licenseType)..' ]\n[ Cost : '..tostring(itemData.price)..' ]\n```', 'user', true, source, false)
            end
        end)
    end)
end)

-- Buys a stack of ammo (a real item, xPlayer.addInventoryItem) rather
-- than a weapon (xPlayer.addWeapon) -- see
-- ShopConfig.itemsForSaleAmmoGunshop. `amount` here is how many stacks
-- the player buys, each stack giving itemData.amount units of ammo.
RegisterServerEvent('gunshop_item:buy_ammo')
AddEventHandler('gunshop_item:buy_ammo', function(itemName, amount)
    local source = source
    if isRateLimited(source) then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local itemData = ShopConfig.itemsForSaleAmmoGunshop[itemName]
    if not itemData or not isValidAmount(amount) then return end

    local itemPrice = itemData.price
    local totalPrice = itemPrice * amount
    local totalAmmo = (itemData.amount or 1) * amount

    if xPlayer.canAfford(totalPrice) then
        local itemInfo = ESX.Items[itemName]
        local itemLabel = itemInfo and itemInfo.label or itemName

        xPlayer.payAny(totalPrice)
        xPlayer.addInventoryItem(itemName, totalAmmo)

        TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought Ammo : '..tostring(itemName)..' x'..tostring(totalAmmo)..' ]\n[ Cost : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)

        TriggerClientEvent('chat:addMessage', source, {
            args = {"[System]", 'Shoma ^2 ' .. totalAmmo .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
            color = {255, 0, 0}
        })
    else
        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)
