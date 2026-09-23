ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================
-- esx_uniquejobs' oversight/ module (Job Watch: judge + marshal
-- management of fisherman/fueler/lumberjack/slaughterer/tailor/
-- miner) is optional. When it's running, every sale of a job item
-- here gets its tax + price-multiplier applied and is reported to
-- the live worker stats / anomaly flags; when it isn't, OvSellPrice
-- just returns the plain price and OvSellReport is a no-op, so
-- these NPC shops behave exactly as before.
-- ============================================================
local OVERSIGHT_RESOURCE = 'esx_uniquejobs'

local function OvUp()
	return GetResourceState(OVERSIGHT_RESOURCE) == 'started'
end

-- gross -> net, tax-and-multiplier adjusted; net is what actually
-- gets paid, and this also records the sale (item + net income)
-- against the worker's Job Watch stats.
local function OvSell(source, itemName, gross, amount)
	if not OvUp() then return gross end
	local ok, result = pcall(function() return exports[OVERSIGHT_RESOURCE]:ProcessJobSale(source, itemName, gross, amount) end)
	if not ok or type(result) ~= 'table' or not result.net then return gross end
	return result.net
end

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
    amount = tonumber(amount)


    if SellerConfig.itemsForSaleTailor[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleTailor[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1'.. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)

    if SellerConfig.itemsForSaleLumberjack[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleLumberjack[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)


    if SellerConfig.itemsForSaleSlaughterer[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleSlaughterer[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)


    if SellerConfig.itemsForSaleFueler[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleFueler[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)

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
    amount = tonumber(amount)


    if SellerConfig.itemsForSaleMiner[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleMiner[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label

        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)

    if SellerConfig.itemsForSaleSeparated[itemName] and amount and amount > 0 and amount == math.floor(amount) then
        local pricePerItem = SellerConfig.itemsForSaleSeparated[itemName].price
        local totalPrice = pricePerItem * amount
        local itemLabel = xPlayer.getInventoryItem(itemName).label


        local itemCount = xPlayer.getInventoryItem(itemName).count
        if itemCount >= amount then

            xPlayer.removeInventoryItem(itemName, amount)


            local netPrice = OvSell(source, itemName, totalPrice, amount)
            xPlayer.addMoney(netPrice)
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..tostring(itemName)..' x'..tostring(amount)..' ]\n[ Earned : '..tostring(netPrice)..' ]\n```', 'user', true, source, false)



            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {
                    "[System]",
                    'Shoma ^2$^2' .. netPrice .. ' ^0Brai Froush ^1' .. amount .. '^1x ^1' .. itemLabel .. ' ^0Daryaft Kardid'
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
    amount = tonumber(amount)

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

