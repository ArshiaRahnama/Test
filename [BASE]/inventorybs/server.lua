ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('society:getStockItems', function(source, cb, vaultType)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {}

    MySQL.Async.fetchAll('SELECT * FROM score_entreprise WHERE name = @name', {
        ['@name'] = xPlayer.job.name
    }, function(result)
        if result[1] then
            local items = json.decode(result[1].coffre)
            local money = result[1].money
            data.items = {}

            for k, v in pairs(items) do
                table.insert(data.items, {
                    label = ESX.GetItemLabel(k),
                    name = k,
                    count = v
                })
            end

            data.money = {
                label = 'Argent',
                name = 'money',
                count = money
            }

            cb(data)
        end
    end)
end)


ESX.RegisterServerCallback('society:getArmoryWeapons', function(source, cb)
    local data = {}
    data.weapons = {
        { label = 'WEAPON_PISTOL', name = 'WEAPON_PISTOL', count = 8 },
        { label = 'WEAPON_SMG', name = 'WEAPON_SMG', count = 8 },
    }

    cb(data)
end)

RegisterServerEvent('society:getStockItem')
AddEventHandler('society:getStockItem', function(itemName, count, vaultType, itemType)
    local xPlayer = ESX.GetPlayerFromId(source)

    if itemType == 'account' then
        local jobName = xPlayer.job.name

        MySQL.Async.fetchScalar('SELECT money FROM score_entreprise WHERE name = @name', {
            ['@name'] = jobName
        }, function(currentMoney)
            if currentMoney >= count then
                MySQL.Async.execute('UPDATE score_entreprise SET money = money - @count WHERE name = @name', {
                    ['@count'] = count,
                    ['@name'] = jobName
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        xPlayer.addAccountMoney(itemName, count)
                        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Atlas', '~y~Retrait', 'Vous avez retiré ~g~' .. count .. '$', 'CHAR_ATLAS', 1)
                    else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue lors du retrait d\'argent')
                    end
                end)
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'L\'entreprise n\'a pas assez d\'argent')
            end
        end)
    elseif itemType == 'item' then
        local jobName = xPlayer.job.name

        MySQL.Async.fetchScalar('SELECT coffre FROM score_entreprise WHERE name = @name', {
            ['@name'] = jobName
        }, function(currentVault)
            if currentVault then
                local currentVaultTable = json.decode(currentVault)

                if currentVaultTable[itemName] and currentVaultTable[itemName] >= count then
                    currentVaultTable[itemName] = currentVaultTable[itemName] - count

                    local updatedVault = json.encode(currentVaultTable)

                    MySQL.Async.execute('UPDATE score_entreprise SET coffre = @coffre WHERE name = @name', {
                        ['@coffre'] = updatedVault,
                        ['@name'] = jobName
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            xPlayer.addInventoryItem(itemName, count)
                            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Atlas', '~y~Retrait', 'Vous avez retiré ~g~' .. count .. ' ' .. ESX.GetItemLabel(itemName), 'CHAR_ATLAS', 1)
                        else
                            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue lors du retrait des objets du coffre')
                        end
                    end)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'L\'entreprise n\'a pas assez de cet objet dans le coffre')
                end
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue lors de la récupération des données du coffre')
            end
        end)
    end
end)
RegisterServerEvent('society:putStockItems')
AddEventHandler('society:putStockItems', function(itemName, count, vaultType, itemType)
    local xPlayer = ESX.GetPlayerFromId(source)
 
    if itemType == 'account' then
        if xPlayer.getAccount(itemName).money >= count then
            MySQL.Async.execute('UPDATE score_entreprise SET money = money + @count WHERE name = @name', {
                ['@count'] = count,
                ['@name'] = xPlayer.job.name
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.removeAccountMoney(itemName, count)
                    TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Atlas', '~y~Dépot', 'Vous avez déposé ~g~' .. count .. '$', 'CHAR_ATLAS', 1)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue')
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez d\'argent')
        end
    elseif itemType == 'item' then
        if xPlayer.getInventoryItem(itemName).count >= count then
            local jobName = xPlayer.job.name
    
            MySQL.Async.fetchScalar('SELECT coffre FROM score_entreprise WHERE name = @name', {
                ['@name'] = jobName
            }, function(currentVault)
                if currentVault then
                    local currentVaultTable = json.decode(currentVault)
    
                    if currentVaultTable[itemName] then
                        currentVaultTable[itemName] = currentVaultTable[itemName] + count
                    else
                        currentVaultTable[itemName] = count
                    end
    
                    local updatedVault = json.encode(currentVaultTable)
    
                    MySQL.Async.execute('UPDATE score_entreprise SET coffre = @coffre WHERE name = @name', {
                        ['@coffre'] = updatedVault,
                        ['@name'] = jobName
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            xPlayer.removeInventoryItem(itemName, count)
                            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Atlas', '~y~Dépot', 'Vous avez déposé ~g~' .. count .. ' ' .. ESX.GetItemLabel(itemName), 'CHAR_ATLAS', 1)
                        else
                            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue lors de la récupération des données du coffre')
                        end
                    end)
                else
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Une erreur est survenue lors de la récupération des données du coffre')
                end
            end)
        end
    end
    
end)