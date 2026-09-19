-- Renamed from openInventory(name, owner, label, searchKey) to
-- openPublicInventory(...): that name collided with client/main.lua's
-- openInventory() (the player's own inventory toggle). Since scripts load
-- alphabetically, this file was loading AFTER client/main.lua and silently
-- overwriting the real openInventory global — the TAB keybind would have
-- called this 4-arg function with no arguments instead.
function openPublicInventory(name, owner, label, searchKey)
    local items = sortItems(getPublicInventory(name, owner))
    openOtherInventory({items = items, timeout = 1000, label = label, searchKey = searchKey}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getPublicInventory(name, owner))
        elseif data.type == 'moveInside' then
            TriggerServerEvent('inventory-public:updateSlot', name, data.data)
        elseif data.type == 'moveToOther' then
            if IsPlayerDead() then return end
            TriggerServerEvent('inventory-public:put', name, data.data)
        elseif data.type == 'moveToMain' then
            if IsPlayerDead() then return end
            TriggerServerEvent('inventory-public:get', name, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                moveInsideHandler(data.data)
            end
        end
    end)
end

function getPublicInventory(name, owner)
    local p = promise.new()
    ESX.TriggerServerCallback('inventory-public:getInventory', function(data)
        p:resolve(data)
    end, name, owner)
    return Citizen.Await(p)
end

exports('openInventory', openPublicInventory)