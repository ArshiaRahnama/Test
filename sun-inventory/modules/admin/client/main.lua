RegisterNetEvent('inventory:admin:openInventory', function(target, permission)
    openOtherPlayerInventory(target, permission)
end)

RegisterNetEvent('inventory:admin:openInventoryOffline', function(target)
    ESX.TriggerServerCallback('inventory:getOfflinePlayerInventory', function()
        openOtherPlayerInventoryOffline(target, true)
    end, target)
end)

-- NOTE: this function was called (above) but never defined anywhere in the resource, so
-- using /inventory:admin:openInventory on an online player would throw
-- "attempt to call a nil value (global 'openOtherPlayerInventory')".
-- Reconstructed here to mirror openOtherPlayerInventoryOffline below; verify the
-- 'inventory:admin:getInventory' server callback name matches your server-side code.
function openOtherPlayerInventory(target, permission)
    local items = sortItems(getOnlinePlayerItem(target))
    openOtherInventory({items = items, timeout = 1000}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getOnlinePlayerItem(target))
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

function getOnlinePlayerItem(target)
    local p = promise.new()
    ESX.TriggerServerCallback('inventory:admin:getInventory', function(data)
        p:resolve(data)
    end, target)
    return Citizen.Await(p)
end

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