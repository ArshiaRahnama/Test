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
            image = itemData.image
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
            image = itemData.image
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
            image = itemData.image
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
            image = itemData.image,
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
            image = itemData.image,
            itemType = 'ammo'
        })
    end

    cb(itemsForSaleGunshop)
end)

RegisterServerEvent('gunshop_item:buy_gunshop')
AddEventHandler('gunshop_item:buy_gunshop', function(itemName, amount)
    local source = source
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

-- Buys a stack of ammo (a real item, xPlayer.addInventoryItem) rather
-- than a weapon (xPlayer.addWeapon) -- see
-- ShopConfig.itemsForSaleAmmoGunshop. `amount` here is how many stacks
-- the player buys, each stack giving itemData.amount units of ammo.
RegisterServerEvent('gunshop_item:buy_ammo')
AddEventHandler('gunshop_item:buy_ammo', function(itemName, amount)
    local source = source
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
