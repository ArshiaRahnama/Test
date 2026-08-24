itens_market = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('lg: buyItemuwuuwu')
AddEventHandler('lg: buyItemuwuuwu', function(data)
    local idJ = source

    local playerMoney = getBankMoney(idJ)
    local namePlayer = getName(idJ)
    local item = getFilterItemByLabel(data.item.name)

    local identifier = getIdentifier(idJ)

    if identifier == data.item.identifier then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_SELF)
        TriggerClientEvent("lg: uwumarketRefused", idJ)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_SELF}})

        return

    -- if error here, item not exists
    elseif not canCarryItem(idJ, item.name, data.selectAmount) then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_FULL)
        TriggerClientEvent("lg: uwumarketRefused", idJ)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_FULL}})

        return
    end
        
    local result = MySQL.Sync.fetchAll('SELECT * FROM uwumarket WHERE id = @id',{
        ['@id'] = data.item.id
    })

    -- secutiry var
    local item_var = nil

    for i,k in pairs(itens_market) do
        if k.id == data.item.id then
            item_var = k
        end
    end

    if result and #result > 0 and item_var then
        local dbAmount = tonumber(result[1].amount)
        local selectAmount = tonumber(data.selectAmount)
        local price = tonumber(result[1].price) * selectAmount

        local varAmount = tonumber(item_var.amount)
        
        if price > playerMoney then
            TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_MONEY)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_MONEY}})
            TriggerClientEvent("lg: uwumarketRefused", idJ)
            return
        end

        if dbAmount >= selectAmount and varAmount >= selectAmount then
            if dbAmount > selectAmount then
                item_var.amount = varAmount - selectAmount

                MySQL.Sync.execute('UPDATE uwumarket SET amount = @amount WHERE id = @id',{
                    ['@amount'] = (dbAmount - selectAmount),
                    ['@id'] = data.item.id
                })
            else
                for i,k in pairs(itens_market) do
                    if k.id == data.item.id then
                        table.remove(itens_market, i)
                        break
                    end
                end

                MySQL.Sync.execute('DELETE FROM uwumarket WHERE id = @id',{
                    ['@id'] = data.item.id
                })
            end

            addBankMoney(data.item.identifier, price)
            removeBankMoney(idJ, price)
            addInventoryItem(idJ, item.name, selectAmount)
            
            TriggerClientEvent('lg: updateuwuMarket', idJ)
            TriggerClientEvent("lg: uwumarketNotify", idJ, "green", translate.TR_SUCESS)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_SUCESS}})

            sendWebhook(WEBHOOKS.ADMIN_WEBHOOK, WEBHOOKS.TITLE_BUY_ITEM, translate.TR_WEBHOOK_LOG_BUY .. '\n' .. translate.TR_WEBHOOK_OWNER .. data.item.owner .. '\n' .. translate.TR_WEBHOOK_LOG_BUY_BY .. namePlayer .. '\n' .. translate.TR_WEBHOOK_LOG_BUY_AMOUNT .. selectAmount .. '\n' .. translate.TR_WEBHOOK_LOG_BUY_PRICE .. translate.TR_SIMBOL_MONEY .. " " .. price, WEBHOOKS.COLOR_BUY)
        else
            TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_AMOUNT)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_AMOUNT}})
            TriggerClientEvent("lg: uwumarketRefused", idJ)
        end
    else
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_NOT_FOUND)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_NOT_FOUND}})
        TriggerClientEvent("lg: uwumarketRefused", idJ)
    end
end)



local function getPriceByName(itemName)
    for _, item in ipairs(list_products) do
        if item.label == itemName then
            return item.price_recommended
        end
    end
    return nil
end

local function getPriceByNameAksar(itemName)
    for _, item in ipairs(list_products) do
        if item.label == itemName then
            return item.Had_AKSAR
        end
    end
    return nil
end

RegisterNetEvent('lg: advertiseItemuwu')
AddEventHandler('lg: advertiseItemuwu', function(data)
    local idJ = source
    local xPlayer = ESX.GetPlayerFromId(idJ)
    local injob = IsCafeJob(xPlayer.job.name) and xPlayer.job.grade >= 3
    if not injob then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_AMOUNTJob)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_AMOUNTJob}})
        TriggerClientEvent("lg: uwumarketRefused", idJ)
        return
    end
    local item = getItemByLabel(idJ, data.item.name)
    local identifier = getIdentifier(idJ)
    local owner = ""

    if data.anonymous then
        owner = "Anonymous"
    else
        -- owner = getName(source)
        owner = "Anonymous"
    end

    

   

    local amount = tonumber(data.item.amount)

    local KoliG = tonumber(data.item.price)
    local price = getPriceByName(data.item.name)
    local HadAksar = getPriceByNameAksar(data.item.name)

    if KoliG < price then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_NAHAYAT_GHEMAT..price)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_NAHAYAT_GHEMAT..price}})
        TriggerClientEvent("lg: uwumarketRefused", idJ)
    elseif KoliG > HadAksar then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_NAHAYAT_GHEMAT_AKSAR..HadAksar)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_NAHAYAT_GHEMAT_AKSAR..HadAksar}})
        TriggerClientEvent("lg: uwumarketRefused", idJ)
    else
        if item and item.count >= amount then
            removeInventoryItem(idJ, item.name, amount)

            MySQL.Async.insert('INSERT INTO uwumarket (name, amount, weight, price, owner, identifier) VALUES (@name, @amount, @weight, @price, @owner, @identifier)',{
                ['@name'] = data.item.name, 
                ['@amount'] = amount, 
                ['@weight'] = item.weight, 
                ['@price'] = tonumber(data.item.price), 
                ['@owner'] = owner, 
                ['@identifier'] = identifier,
            }, function(id)
            table.insert(itens_market, {id = id, name = data.item.name, amount = amount, weight = item.weight, price = tonumber(data.item.price), owner = owner, identifier = identifier}) 
            end)
            TriggerClientEvent('lg: updatePlayeruwuMarket', idJ)
            TriggerClientEvent("lg: uwumarketNotify", idJ, "green", translate.TR_ADVERTISE_ITEM)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_ADVERTISE_ITEM}})

            sendWebhook(WEBHOOKS.PUBLIC_WEBHOOK, WEBHOOKS.TITLE_ANNOUNCE_ITEM, data.item.name .. " x" .. data.item.amount .. '\n' .. translate.TR_WEBHOOK_OWNER .. owner .. '\n' .. translate.TR_WEBHOOK_AMOUNT .. amount .. '\n' .. translate.TR_WEBHOOK_PRICE .. translate.TR_SIMBOL_MONEY .. " " .. data.item.price, WEBHOOKS.COLOR_ANNOUNCE)
        else
            TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_AMOUNT2)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_AMOUNT2}})
            TriggerClientEvent("lg: uwumarketRefused", idJ)
        end
    end
end)

RegisterNetEvent('lg: removeItemuwu')
AddEventHandler('lg: removeItemuwu', function(data)
    local idJ = source

    local item = getFilterItemByLabel(data.item.name)
    local identifier = getIdentifier(idJ)
    local namePlayer = getName(idJ)
    local amount = tonumber(data.item.amount)

    -- if error here, item not exists
    if not canCarryItem(idJ, item.name, amount) then
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_FULL)
        TriggerClientEvent("lg: uwumarketRefused", idJ)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_FULL}})

        return
    end

    if item then
        local result = MySQL.Sync.execute('DELETE FROM uwumarket WHERE id = @id and amount = @amount',{
            ['@id'] = data.item.id,
            ['@amount'] = amount
        })

        -- secutiry var
        local item_var = nil

        for i,k in pairs(itens_market) do
            if k.id == data.item.id then
                item_var = k
            end
        end

        if result ~= 0 and item_var then
            for i,k in pairs(itens_market) do
                if k.id == data.item.id then
                    table.remove(itens_market, i)
                end
            end

            addInventoryItem(idJ, item.name, amount)
            TriggerClientEvent('lg: updatePlayeruwuMarket', idJ)
            TriggerClientEvent("lg: uwumarketNotify", idJ, "green", translate.TR_REMOVED_ITEM)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_REMOVED_ITEM}})

            sendWebhook(WEBHOOKS.ADMIN_WEBHOOK, WEBHOOKS.TITLE_REMOVE_ITEM, data.item.name .. " x" .. data.item.amount .. '\n' .. translate.TR_WEBHOOK_OWNER .. namePlayer .. '\n' .. translate.TR_WEBHOOK_LOG_BUY_AMOUNT .. amount .. '\n' .. translate.TR_WEBHOOK_PRICE .. translate.TR_SIMBOL_MONEY .. " " .. data.item.price, WEBHOOKS.COLOR_REMOVE)
        else
            TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_AMOUNT2)
            TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_AMOUNT2}})
            TriggerClientEvent("lg: uwumarketRefused", idJ)
        end
    else
        TriggerClientEvent("lg: uwumarketNotify", idJ, "brown", translate.TR_DONT_AMOUNT2)
        TriggerClientEvent("chat:addMessage", idJ, {args = {translate.TR_DONT_AMOUNT2}})
        TriggerClientEvent("lg: uwumarketRefused", idJ)
    end
end)

RegisterNetEvent('lg: loaduwuMarket')
AddEventHandler('lg: loaduwuMarket', function()
    local idJ = source

    local identifier = getIdentifier(idJ)

    MySQL.Async.fetchAll('SELECT * FROM uwumarket ORDER BY price',{
    }, function(result)
        TriggerClientEvent('lg: loaduwuMarket', idJ, identifier, result)
    end)
end)


RegisterNetEvent('lg: loadPlayeruwuMarket')
AddEventHandler('lg: loadPlayeruwuMarket', function()
    local idJ = source

    local identifier = getIdentifier(idJ)
    local itens_filter = filterInventory(idJ)    

    MySQL.Async.fetchAll('SELECT * FROM uwumarket WHERE identifier = @identifier ORDER BY price',{
        ['@identifier'] = identifier
    }, function(result)
        TriggerClientEvent('lg: loadPlayeruwuMarket', idJ, itens_filter, result)
    end)
end)
 
function sendWebhook(DISCORD_WEBHOOK, DISCORD_TITLE, message, color)
    local send = {
        {
            ["color"] = color,
            ["title"] = DISCORD_TITLE,
            ["description"] = message,
            ["footer"] = {
                ["text"] = WEBHOOKS.DISCORD_FOOTER,
                ['icon_url'] = WEBHOOKS.DISCORD_FOOTER_IMG
            },
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = send, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end


RegisterCommand('asdfghjkl;sfsdfsdfzxcvnads23adfghuwu', function(source, args)
    xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM uwumarket ORDER BY price',{
    }, function(result)
        TriggerClientEvent('lg: updatePlayeruwuMarket', source)
        TriggerClientEvent('lg: loaduwuMarket', source, xPlayer.getIdentifier, result)
    end)
end)