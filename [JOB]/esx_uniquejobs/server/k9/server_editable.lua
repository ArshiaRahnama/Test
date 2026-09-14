CORE = nil

if CFG.FRAMEWORK == 'QBCore' then
    CORE = exports['qb-core']:GetCoreObject()
elseif CFG.FRAMEWORK == 'QBX' then 
    CORE = exports['qbx-core']:GetCoreObject()
elseif CFG.FRAMEWORK == 'ESX' then 
    CORE = exports['es_extended']:getSharedObject()
elseif CFG.FRAMEWORK == 'ESXOLD' then 
    TriggerEvent('esx:getSharedObject', function(obj) CORE = obj end)
end

-- callbacks --
lib.callback.register('sh-k9:CB:HAS_ITEM', function(source, item)
    local Player = GetPlayer(source)
    if not Player then return false end

    if CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        local getItem = Player.getInventoryItem(item)
        if not getItem then return false end
        return getItem.count >= 1 

    elseif CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        return CORE.Functions.HasItem(source, item, 1)
    else
        -- implement ur code
        return true
    end
end)


-- functions -- 
function GetPlayer(src)
    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        return CORE.Functions.GetPlayer(src)
    elseif CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        return CORE.GetPlayerFromId(src)
    else
        -- implement ur code of getting player data
        return true
    end
end

function HasAccess(src)
    local Player = GetPlayer(src)
    if not Player then return nil end

    if CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        return Player.job.name
    elseif CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        return Player.PlayerData.job.name
    else
        -- add your code for getting job
        return 'police'
    end
end

function GetIdentifier(src)
    local Player = GetPlayer(src)
    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        return Player.PlayerData.citizenid
    elseif CFG.FRAMEWORK == 'ESX' then
        if CORE.GetConfig().Multichar then
            return Player.identifier
        else
            return CORE.GetIdentifier(src)
        end
    elseif CFG.FRAMEWORK == 'ESXOLD' then
        return Player.identifier
    else
        return GetPlayerIdentifierByType(src, 'license')
    end
end

function AddItem(Player, item)
    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        Player.Functions.AddItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, CORE.Shared.Items[item], 'add')
    elseif CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        Player.addInventoryItem(item, 1)
    else
        -- add ur code for removing item
    end
end

function RemoveItem(Player, item)
    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        Player.Functions.RemoveItem(item, 1)
        TriggerClientEvent('inventory:client:ItemBox', Player.PlayerData.source, CORE.Shared.Items[item], 'remove')
    elseif CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        Player.removeInventoryItem(item, 1)
    else
        -- add ur code for removing item
    end
end

-- get items --
function GetPlayerItems(playerId)
    local Player = GetPlayer(playerId)
    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        return Player.PlayerData.items
    elseif CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
        return Player.getInventory(), Player.getLoadout()
    else
        -- add your code for getting items
        return nil
    end
end

function GetVehicleItems(plate, type)
    local items = {}
    local query = nil

    if CFG.INVENTORY == 'qb-inventory' then
        if CFG.SETTINGS.SEARCH.advanced then 
            if type == 'trunk' then
                return exports['qb-inventory']:GetTrunkItems(plate)
            elseif type == 'glovebox' then
                return exports['qb-inventory']:GetGloveboxItems(plate)
            else
                return nil
            end
        else 
            if type == 'trunk' then
                query = 'SELECT items FROM trunkitems WHERE plate = ?'
            elseif type == 'glovebox' then
                query = 'SELECT items FROM gloveboxitems WHERE plate = ?'
            end

            local db = MySQL.scalar.await(query, {plate})
            local result = json.decode(db)
            if not result then return nil end

            for _, item in pairs(result) do
                local itemInfo = CORE.Shared.Items[item.name:lower()]
                if itemInfo then items[item.slot] = { name = itemInfo["name"] } end
            end

            return items
        end

    elseif CFG.INVENTORY == 'qs-inventory' then
        if type == 'trunk' then
            query = 'SELECT items FROM inventory_trunk WHERE plate = ?'
        elseif type == 'glovebox' then
            query = 'SELECT items FROM inventory_glovebox WHERE plate = ?'
        end

        local db = MySQL.scalar.await(query, {plate})
        local result = json.decode(db)
        if not result then return nil end

        local list = nil
        if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
            list = CORE.Shared.Items
        else
            list = exports['qs-inventory']:GetItemList()
        end

        for _, item in pairs(result) do
            local itemInfo = list[item.name:lower()]
            if itemInfo then items[item.slot] = { name = itemInfo["name"] } end
        end

        return items

    elseif CFG.INVENTORY == 'lc-inventory' then
        if type == 'trunk' then
            -- uses the GetTrunkItems export added to lc-inventory/server/apps/system/trunk.lua
            -- (see lc-inventory-patch/ in the K9 integration package) - guarded with pcall
            -- in case that patch hasn't been applied/restarted yet, so a missing export
            -- fails clean instead of throwing a script error every time it's called.
            local ok, result = pcall(function()
                return exports['lc-inventory']:GetTrunkItems(plate)
            end)
            if not ok then
                print('^1[k9] lc-inventory export "GetTrunkItems" not found - did you apply lc-inventory-patch/server/apps/system/trunk.lua and restart lc-inventory?^0')
                return nil
            end
            return result
        else
            -- lc-inventory has no glovebox system
            return nil
        end

    elseif CFG.INVENTORY == 'ox-inventory' then
        local get_inv = nil
        if type == 'trunk' then
            get_inv = exports.ox_inventory:GetInventoryItems('trunk'..plate)
        elseif type == 'glovebox' then
            get_inv = exports.ox_inventory:GetInventoryItems('glove'..plate)
        end

        for _, item in pairs(get_inv) do
            items[#items+1] = { name = item.name }
        end

        return items

    else
        -- implement your code here if you using different inventory
        return nil
    end
end
