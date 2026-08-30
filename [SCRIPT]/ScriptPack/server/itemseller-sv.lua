ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('getInventoryWithImagesTailor', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleTailor[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_tailor:handleSell')
AddEventHandler('item_shop_tailor:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleTailor[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleTailor[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1'.. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesLumberjack', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleLumberjack[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_lumberjack:handleSell')
AddEventHandler('item_shop_lumberjack:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleLumberjack[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleLumberjack[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesSlaughterer', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleSlaughterer[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_slaughterer:handleSell')
AddEventHandler('item_shop_slaughterer:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleSlaughterer[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleSlaughterer[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesFueler', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleFueler[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_fueler:handleSell')
AddEventHandler('item_shop_fueler:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleFueler[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleFueler[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesLaster', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for _, item in ipairs(inventory) do
        if item.count > 0 then
            local itemData = SellerConfig.itemsForSaleLaster[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_laster:handleSell')
AddEventHandler('item_shop_laster:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleLaster[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleLaster[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label
        local itemCount = xPlayer.getInventoryItem(itemName).count

        if itemCount >= amount then
            xPlayer.removeInventoryItem(itemName, amount)
            xPlayer.addInventoryItem('eskenas', totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..'x eskenas ]\n```', 'user', true, source, false)


            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2' .. totalPrice .. ' X ^0Eskenas ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })

            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))
        else
            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesMiner', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleMiner[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_miner:handleSell')
AddEventHandler('item_miner:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source


    if SellerConfig.itemsForSaleMiner[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleMiner[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label

        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesSeparated', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleSeparated[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_separated:handleSell')
AddEventHandler('item_shop_separated:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleSeparated[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleSeparated[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

ESX.RegisterServerCallback('getInventoryWithImagesdrugdealer2', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.inventory
    local itemsWithImages = {}

    for i=1, #inventory, 1 do
        local item = inventory[i]
        if item.count > 0 then

            local itemData = SellerConfig.itemsForSaleDrugdealer2[item.name]
            if itemData then
                table.insert(itemsWithImages, {
                    name = item.name,
                    count = item.count,
                    label = item.label,
                    price = itemData.price,
                    image = itemData.image
                })
            end
        end
    end

    cb(itemsWithImages)
end)

RegisterServerEvent('item_shop_drugdealer2:handleSell')
AddEventHandler('item_shop_drugdealer2:handleSell', function(itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Src = source

    if SellerConfig.itemsForSaleDrugdealer2[itemName] then
        local pricePerItem = SellerConfig.itemsForSaleDrugdealer2[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            xPlayer.addMoney(totalPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(totalPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. totalPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
                }
            })
            TriggerClientEvent("Task_System:AddCompleteQuest", Src, tonumber(amount), tostring(itemName))

        else

            TriggerClientEvent('esx:showNotification', source, "Shoma Item Kafi Brai Froush Nadarid")
        end
    else

        TriggerClientEvent('esx:showNotification', source, "In Item Ghabel Froush Nist")
    end
end)

