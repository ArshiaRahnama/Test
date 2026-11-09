-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

function openInventory(name, owner, label, searchKey, flat)
    openOtherInventory({flat = flat, fetch = function(mode, weaponName)
        if flat then
            return sortItems(getSecondLazy('public-' .. name, 'full'))
        end
        return getSecondLazy('public-' .. name, mode, weaponName)
    end, timeout = 1000, label = label, searchKey = searchKey}, function(data)
        if data.type == 'close' then
        elseif data.type == 'update' then
            return sortItems(getPublicInventory(name, owner))
        elseif data.type == 'moveInside' then
            ESX.TriggerServerEvent('inventory-public:updateSlot', name, data.data)
        elseif data.type == 'moveToOther' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('inventory-public:put', name, data.data)
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('inventory-public:get', name, data.data)
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

exports('openInventory', openInventory)