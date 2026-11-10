-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

RegisterNetEvent('inventory:admin:openInventory', function(target, permission)
    openOtherPlayerInventory(target, true)
end)

RegisterNetEvent('inventory:admin:openInventoryOffline', function(target)
    ESX.TriggerServerCallback('inventory:getOfflinePlayerInventory', function()
        openOtherPlayerInventoryOffline(target, true)
    end, target)
end)

function openOtherPlayerInventoryOffline(target)
    local items = sortItems(getOfflinePlayerItem(target))
    openOtherInventory({items = items, timeout = 1000}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getOfflinePlayerItem(target))
        elseif data.type == 'moveInside' then
        elseif data.type == 'moveToOther' then
            ESX.TriggerServerEvent('inventory:admin:put', target, data.data)
        elseif data.type == 'moveToMain' then
            ESX.TriggerServerEvent('inventory:admin:get', target, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                moveInsideHandler(data.data)
            end
        end
    end)
end

function getOfflinePlayerItem(target)
    local p = promise.new()
    ESX.TriggerServerCallback('inventory:getOfflinePlayerInventory', function(data)
        p:resolve(data)
    end, target)
    return Citizen.Await(p)
end