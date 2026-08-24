ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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


    local totalPrice = itemPrice * amount


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


    local totalPrice = itemPrice * amount


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

    local totalPrice = itemPrice * amount



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

    local totalPrice = itemPrice * amount



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
