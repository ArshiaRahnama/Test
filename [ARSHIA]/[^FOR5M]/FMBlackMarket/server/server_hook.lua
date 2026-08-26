ESX , QBCore = nil , nil
if CAS.Framework == "qb" then
    QBCore = exports["qb-core"]:GetCoreObject()
else
    TriggerEvent(Config.ESX, function(obj) ESX = obj end)   
end


GetPlayer = function(playerId)
    if CAS.Framework == "qb" then
        return QBCore.Functions.GetPlayer(playerId)
    else
        return ESX.GetPlayerFromId(playerId)
    end
end


AddItem = function(player,itemName, count)
    local xPlayer = GetPlayer(player)
    if CAS.Framework == "qb" then
        return xPlayer.Functions.AddItem(itemName, count)
    else
        return xPlayer.addInventoryItem(itemName, count)
    end
end
AddWeapon  = function(player,itemName, count)
    local xPlayer = GetPlayer(player)
    if CAS.Framework == "qb" then
        return --
    else
        return xPlayer.addWeapon(itemName, count)
    end
end

Notify = function(source, text)
    if CAS.Framework == "qb" then
        return TriggerClientEvent("QBCore:Notify",source, text)
    else
        local xPlayer = GetPlayer(source)
        TriggerClientEvent("esx:showNotification",source, text)
        return
    end
end 

RemoveMoney = function(source, method, price)
    local player = GetPlayer(source)
    if CAS.Framework == "qb" then
        if player.Functions.GetMoney(method) >= price then
            player.Functions.RemoveMoney(method, price)
            return true
        else
            Notify(source, "You don't have enough money.")
        end
    else
        if method == 'bank' and player.bank  >= price  or method ~= 'bank' and player.money  >= price    then
            if method == 'bank'  then 
                player.removeBank( price )
            else 
                player.removeMoney( price )
            end 
            return true
        else
            Notify(source, "You don't have enough money.")
        end
    end
    return false
end


