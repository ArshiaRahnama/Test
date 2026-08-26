ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- SECURITY FIX: every buy_* handler below used to multiply the CLIENT-
-- SUPPLIED `itemPrice` by `amount` and charge that -- a modified client
-- could send itemPrice = 1 (or any value) for any item, including guns in
-- buy_gunshop, and pay whatever it wants instead of the configured price.
-- This looks the real price up server-side from ShopConfig instead; the
-- price argument from the client is no longer trusted anywhere below.
local function getShopItemPrice(configTable, itemName)
    local itemData = configTable and configTable[itemName]
    if not itemData then return nil end
    return itemData.price
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
AddEventHandler('shops_item:buy_shops', function(itemName, amount, itemPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then return end

    -- SECURITY FIX: real price from config, not the client's itemPrice.
    local realPrice = getShopItemPrice(ShopConfig.itemsForSaleShops, itemName)
    if not realPrice then return end
    local totalPrice = realPrice * amount


    if xPlayer.canAfford(totalPrice) then

        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)


        if item.limit == -1 or (item.count + amount <= item.limit) then

            xPlayer.payAny(totalPrice)


            xPlayer.addInventoryItem(itemName, amount)


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
AddEventHandler('mc_item:buy_mc', function(itemName, amount, itemPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then return end

    -- SECURITY FIX: real price from config, not the client's itemPrice.
    local realPrice = getShopItemPrice(ShopConfig.itemsForSaleMC, itemName)
    if not realPrice then return end
    local totalPrice = realPrice * amount


    if xPlayer.canAfford(totalPrice) then

        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)


        if item.limit == -1 or (item.count + amount <= item.limit) then

            xPlayer.payAny(totalPrice)


            xPlayer.addInventoryItem(itemName, amount)


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
AddEventHandler('narekshop_item:buy_narekshop', function(itemName, amount, itemPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then return end

    -- SECURITY FIX: real price from config, not the client's itemPrice.
    local realPrice = getShopItemPrice(ShopConfig.itemsForSaleNarekshop, itemName)
    if not realPrice then return end
    local totalPrice = realPrice * amount



    if xPlayer.canAfford(totalPrice) then



        local item = xPlayer.getInventoryItem(itemName)
        local itemLabel = ESX.GetItemLabel(itemName)


        if item.limit == -1 or (item.count + amount <= item.limit) then

            xPlayer.payAny(totalPrice)


            xPlayer.addInventoryItem(itemName, amount)


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
            image = itemData.image
        })
    end

    cb(itemsForSaleGunshop)
end)

RegisterServerEvent('gunshop_item:buy_gunshop')
AddEventHandler('gunshop_item:buy_gunshop', function(itemName, amount, itemPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 or amount ~= math.floor(amount) then return end

    -- SECURITY FIX: real price from config, not the client's itemPrice.
    local realPrice = getShopItemPrice(ShopConfig.itemsForSaleGunshop, itemName)
    if not realPrice then return end
    local totalPrice = realPrice * amount



    if xPlayer.canAfford(totalPrice) then


        local itemLabel = ESX.GetWeaponLabel(itemName)


        if not xPlayer.hasWeapon(itemName) then

            xPlayer.payAny(totalPrice)


            xPlayer.addWeapon(itemName, 50)


            TriggerClientEvent('chat:addMessage', source, {
                args = {"[System]", 'Shoma ^2 ' .. amount .. '^2x ' .. itemLabel .. ' ^0Ra be ^1$^1'.. totalPrice .. ' ^0Kharidid'},
                color = {255, 0, 0}
            })

        else

            TriggerClientEvent('esx:showNotification', source, 'Shoma In Aslehe Ra Darid.')
        end
    else

        TriggerClientEvent('esx:showNotification', source, 'Shoma Pool Kafi Nadarid.')
    end
end)
