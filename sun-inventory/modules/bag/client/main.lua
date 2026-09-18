local doesHaveBag = false
local currentBag = nil
local inSearch = nil
local bagId = nil
local kifChanged = false
function openBag(bagId, maxWeight)
    local items = sortItems(getBagInventory(bagId))
    currentBag = 'kif_'.. bagId
    openOtherInventory({items = items, timeout = 1000, maxWeight = maxWeight, label = 'Kif ' .. bagId, type = 'bag'}, function(data)
        if data.type == 'close' then
            currentBag = nil
        elseif data.type == 'update' then
            return sortItems(getBagInventory(bagId))
        elseif data.type == 'moveInside' then
            if not inSearch then
                ESX.TriggerServerEvent('inventory-bag:updateSlot', bagId, data.data)
            end
        elseif data.type == 'moveToOther' then
            if ESX.isDead() or inSearch then return end
            ESX.TriggerServerEvent('inventory-bag:put', bagId, data.data, inSearch)
        elseif data.type == 'moveToMain' then
            if ESX.isDead() then return end
            ESX.TriggerServerEvent('inventory-bag:get', bagId, data.data, inSearch)
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

RegisterNetEvent('inventory-bag:openBag', function(bagId, maxWeight, search, target)
    inSearch = search
    openBag(bagId, maxWeight)
    if target then
        local ped = GetPlayerPed(GetPlayerFromServerId(target))
        Citizen.CreateThread(function()
            while true do
                Wait(1000)
                if not DoesEntityExist(ped) or ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped)) > 5 then
                    break
                end
            end
            closeInventory()
        end)
    end
end)

RegisterNetEvent('esx:addInventoryItem', function(label, count, name)
    if name and name:find('kif_') then
        setBag()
        Wait(500)
        bagId = nil
        local doesHave = false
        for k, v in pairs(ESX.GetPlayerData().inventory) do
            if v.name:find('kif_') and v.count > 0 then
                doesHave = true
                local id = v.name:gsub('kif_', '')
                bagId = tonumber(id)
                break
            end
        end
        ESX.SetPlayerState('bag', bagId)
    elseif name and name:find('kool') then
        Wait(1000)
        ESX.TriggerServerEvent('esx:useItem', name)
    end
end)

RegisterNetEvent('esx:removeInventoryItemss', function(label, count, name)
    if name and name:find('kif_') then
        if currentBag == name then
            closeInventory()
            currentBag = nil
        end
        Wait(1500)
        local doesHave = false
        bagId = nil
        for k, v in pairs(ESX.GetPlayerData().inventory) do
            if v.name:find('kif_') and v.count > 0 then
                doesHave = true
                local id = v.name:gsub('kif_', '')
                bagId = tonumber(id)
                break
            end
        end
        doesHaveBag = doesHave
        ESX.SetPlayerState('bag', bagId)
        if not doesHaveBag and kifChanged then
            kifChanged = false
            TriggerEvent('skinchanger:loadStuff', {bags_1 = 0, bags_2 = 0})
        end
    end
end)

AddEventHandler('onSkinChange', function()
    if doesHaveBag then
        if not doesHaveBagSkin() then
            kifChanged = true
            TriggerEvent('skinchanger:loadStuff', {bags_1 = bag[1], bags_2 = bag[2]})
        end
    end
end)

function setBag()
    if not doesHaveBag and not doesHaveBagSkin() then
        doesHaveBag = true
        kifChanged = true
        TriggerEvent('skinchanger:loadStuff', {bags_1 = bag[1], bags_2 = bag[2]})
    end
end

CreateThread(function()
    while ESX == nil do
        Wait(1000)
    end
    ESX.RegisterClientCallback('bag:getName', function(cb)
        local keyboard, name = exports["input"]:Keyboard({
            header = 'Name kif ra vared konid', 
            rows = {'Name'}
        })
        if keyboard then
            if name then
                cb(name)
            end
        end
    end)
end)

function doesHaveBagSkin()
    local p = promise.new()
    TriggerEvent('skinchanger:getSkin', function(skin)
        p:resolve(skin.bags_1 ~= 0)
    end)
    return Citizen.Await(p)
end