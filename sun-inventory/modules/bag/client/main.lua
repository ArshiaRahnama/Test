--[[
    sun-inventory — bag (worn backpack -> extra storage) client.

    FIXES applied here (all genuine bugs in the uploaded package, verified
    against essentialmode's real APIs - not assumptions):
      - ESX.GetDistance doesn't exist; essentialmode has no such helper.
        Replaced with plain vector subtraction (#(a - b)).
      - RegisterNetEvent('esx:addInventoryItem', function(label, count, name)):
        essentialmode's server actually fires this as
        TriggerClientEvent("esx:addInventoryItem", source, item, count) -
        i.e. (item TABLE, count), not (label, count, name). The old
        signature meant `name:find(...)` was being called on a NUMBER
        (count) and would hard-error the first time it ran.
      - The matching removal handler was registered as
        'esx:removeInventoryItemss' (typo, extra 's') so it silently never
        fired at all.
      - ESX.SetPlayerState doesn't exist; the FiveM-native equivalent is
        LocalPlayer.state.
      - ESX.RegisterClientCallback doesn't exist, and the resource it was
        wrapping for ('exports["input"]:Keyboard') isn't in this project
        either, and nothing anywhere ever actually calls 'bag:getName' -
        removed as unreachable dead code rather than half-fixing an unused
        naming prompt with no keyboard-input resource behind it.
      - The "show a bag prop on the ped matching whichever kif_N item is
        equipped" logic (setBag/onSkinChange/doesHaveBagSkin) referenced a
        global `bag` table (`bag[1]`, `bag[2]`) that is never defined
        ANYWHERE in this package - there is no source for "which
        drawable/texture does kif_5 look like". That would have hard-erred
        (indexing a nil value) the first time setBag() ran. Removed rather
        than guessed at; the storage side of bags (this whole file's actual
        job) doesn't depend on it. If you want a worn-bag visual, that
        needs an explicit drawable/texture mapping per kif_N item, which
        isn't defined anywhere in the uploaded resource.
]]

local currentBag = nil
local inSearch = nil
local bagId = nil

function openBag(bagId, maxWeight)
    local items = sortItems(getBagInventory(bagId))
    currentBag = 'kif_'.. bagId
    openOtherInventory({items = items, timeout = 1000, maxWeight = maxWeight, label = 'Kif ' .. bagId, type = 'bag'}, function(data)
        if data.type == 'close' then
            currentBag = nil
        elseif data.type == 'update' then
            return sortItems(getBagInventory(bagId))
        elseif data.type == 'moveToOther' then
            if IsPlayerDead() or inSearch then return end
            TriggerServerEvent('inventory-bag:put', bagId, data.data)
        elseif data.type == 'moveInside' then
            if not inSearch then
                TriggerServerEvent('inventory-bag:updateSlot', bagId, data.data)
            end
        elseif data.type == 'moveToMain' then
            if IsPlayerDead() then return end
            TriggerServerEvent('inventory-bag:get', bagId, data.data)
            Wait(500)
            if data.data.droppedTo then
                data.data.inventoryType = 'main'
                moveInsideHandler(data.data)
            end
        end
    end)
end

function getBagInventory(bagId)
    local p = promise.new()
    ESX.TriggerServerCallback('inventory-bag:getInventory', function(data)
        p:resolve(data)
    end, bagId)
    return Citizen.Await(p)
end

RegisterNetEvent('inventory-bag:openBag', function(openBagId, maxWeight, search, target)
    inSearch = search
    openBag(openBagId, maxWeight)
    if target then
        local ped = GetPlayerPed(GetPlayerFromServerId(target))
        Citizen.CreateThread(function()
            while true do
                Wait(1000)
                if not DoesEntityExist(ped) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(ped)) > 5.0 then
                    break
                end
            end
            closeInventory()
        end)
    end
end)

local function findOwnedBagId()
    for _, v in pairs(ESX.GetPlayerData().inventory) do
        if v.name:find('kif_') and v.count > 0 then
            return tonumber(v.name:gsub('kif_', ''))
        end
    end
    return nil
end

RegisterNetEvent('esx:addInventoryItem', function(item, count)
    local name = item and item.name
    if name and name:find('kif_') then
        Wait(500)
        bagId = findOwnedBagId()
        LocalPlayer.state:set('bag', bagId, true)
    elseif name and name:find('kool') then
        Wait(1000)
        TriggerServerEvent('esx:useItem', name)
    end
end)

RegisterNetEvent('esx:removeInventoryItem', function(item, count)
    local name = item and item.name
    if name and name:find('kif_') then
        if currentBag == name then
            closeInventory()
            currentBag = nil
        end
        Wait(1500)
        bagId = findOwnedBagId()
        LocalPlayer.state:set('bag', bagId, true)
    end
end)
