-- SECURITY FIX: `price` used to be trusted verbatim from the client -- a
-- modified client could send price = 1 (or 0) and buy any outfit for
-- almost nothing. There's no per-store id sent to the server either, so
-- instead of trusting the client we look up which Config.Stores entry the
-- player is actually standing next to right now and charge ITS configured
-- price. If they aren't near any store, the purchase is rejected outright.
-- Shared by both the ESX and QB-Core payForClothes callbacks below.
local function getNearbyStorePrice(source)
    local ped = GetPlayerPed(source)
    if ped == 0 then return nil end
    local playerCoords = GetEntityCoords(ped)

    for _, store in ipairs(Config.Stores) do
        local storeCoords = vector3(store.coords.x, store.coords.y, store.coords.z)
        if #(playerCoords - storeCoords) < 15.0 then
            return store.price
        end
    end
    return nil
end

if Config.Core == "ESX" then
    ESX = nil

    -- Don't trust a single one-shot TriggerEvent to land — if essentialmode
    -- (or the es_extended bridge) hasn't finished starting yet when this
    -- resource loads, esx:getSharedObject has no handler yet and the
    -- callback never fires, silently leaving ESX nil forever with nothing
    -- ever getting registered (and no visible error). Retry until it works.
    local attempts = 0
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if not ESX then
            attempts = attempts + 1
            Wait(200)
        end
    end
    print(('^2[unique_clothestore DEBUG] Got ESX after %d attempt(s).^0'):format(attempts + 1))












    local ClotheTypeLabel = {
        tshirt = 'Tishert', torso = 'Lebas', arms = 'Dastkesh', decals = 'Neshan',
        pants = 'Shalvar', shoes = 'Kafsh', mask = 'Mask', bproof = 'Jelighe',
        chain = 'Gardanband', bags = 'Kif', helmet = 'Kolah', glasses = 'Eynak',
        watches = 'Saat', bracelets = 'Dastband', ears = 'Gushvare',
    }
    local KnownClotheTypes = {}
    for t in pairs(ClotheTypeLabel) do KnownClotheTypes[t] = true end

    -- ox_inventory can't create a new item per drawable/texture at runtime,
    -- so each purchased piece becomes an instance of the matching
    -- clothing_<type> item (registered in ox_inventory/data/items.lua),
    -- distinguished by its own metadata instead of its own item name.
    local function giveClotheItem(source, clotheType, drawable, texture)
        local label = (ClotheTypeLabel[clotheType] or clotheType) .. (' #%d'):format(drawable)

        exports.ox_inventory:AddItem(source, 'clothing_' .. clotheType, 1, {
            label = label,
            clotheType = clotheType,
            drawable = drawable,
            texture = texture
        })
    end

    -- Wearing/taking off clothing now goes through ox_inventory's own
    -- native item-use mechanism (`server.export` in the item definition,
    -- see data/items.lua) instead of essentialmode's ESX.RegisterUsableItem
    -- chain — that chain depends on essentialmode's ESX.UsableItemsCallbacks
    -- table actually being populated by the time ox_inventory calls
    -- ESX.UseItem, which turned out to be unreliable across restarts.
    -- This export is called directly by ox_inventory itself, no bridge
    -- involved, so there's nothing else that has to be "ready" first.
    local function handleClothingUse(itemName, inventory, slot)
        local isWorn = itemName:sub(1, 13) == 'worn_clothing'
        local clotheType = isWorn and itemName:sub(15) or itemName:sub(10)

        if not KnownClotheTypes[clotheType] then return end

        local playerId = tonumber(inventory.id)
        if not playerId then return end

        local slotData = inventory.items and inventory.items[slot]
        local metadata = slotData and slotData.metadata
        if not metadata or not metadata.drawable then return end

        if isWorn then
            -- Taking it back off: remove the "(Worn)" placeholder and give
            -- the real, original item back with its original metadata.
            TriggerClientEvent('unique_clothestore:takeOffClotheItem', playerId, metadata.clotheType or clotheType)

            exports.ox_inventory:AddItem(playerId, 'clothing_' .. clotheType, 1, {
                label = metadata.label,
                clotheType = metadata.clotheType or clotheType,
                drawable = metadata.drawable,
                texture = metadata.texture or 0
            })
        else
            -- Wearing it: if a piece of the same type is already worn, take
            -- it off first (back into the inventory) so you never end up
            -- with two different "worn_clothing_<type>" placeholders for
            -- the same clothing slot on the ped.
            local wornSlots = exports.ox_inventory:Search(playerId, 'slots', 'worn_clothing_' .. clotheType)
            local wornSlot = wornSlots and wornSlots['worn_clothing_' .. clotheType] and wornSlots['worn_clothing_' .. clotheType][1]
            if wornSlot then
                local wornMeta = wornSlot.metadata or {}
                exports.ox_inventory:RemoveItem(playerId, 'worn_clothing_' .. clotheType, 1, nil, wornSlot.slot)
                exports.ox_inventory:AddItem(playerId, 'clothing_' .. clotheType, 1, {
                    label = wornMeta.label,
                    clotheType = wornMeta.clotheType or clotheType,
                    drawable = wornMeta.drawable,
                    texture = wornMeta.texture or 0
                })
            end

            print(('^3[unique_clothestore DEBUG] Sending wearClotheItem to player %s: type=%s drawable=%s texture=%s^0'):format(tostring(playerId), tostring(metadata.clotheType or clotheType), tostring(metadata.drawable), tostring(metadata.texture or 0)))
            TriggerClientEvent('unique_clothestore:wearClotheItem', playerId, metadata.clotheType or clotheType, metadata.drawable, metadata.texture or 0)

            exports.ox_inventory:AddItem(playerId, 'worn_clothing_' .. clotheType, 1, {
                label = metadata.label,
                clotheType = metadata.clotheType or clotheType,
                drawable = metadata.drawable,
                texture = metadata.texture or 0
            })
        end
    end

    exports('useClothingItem', function(_, event, item, inventory, slot)
        if event ~= 'usingItem' then return end
        handleClothingUse(item.name, inventory, slot)
    end)











    local PendingClothePurchase = {}

    AddEventHandler('playerDropped', function()
        PendingClothePurchase[source] = nil
    end)

    RegisterServerEvent('unique_clothestore:giveClotheItems')
    AddEventHandler('unique_clothestore:giveClotheItems', function(boughtItems)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer or type(boughtItems) ~= 'table' then return end

        if not PendingClothePurchase[source] then
            print(('[unique_clothestore] ^3WARNING^7: player %d tried to claim clothing items with no matching successful purchase -- ignored.'):format(source))
            return
        end
        PendingClothePurchase[source] = nil

        local given = 0
        for _, entry in ipairs(boughtItems) do
            if given >= 20 then break end

            local clotheType = entry.type
            local drawable = tonumber(entry.drawable)
            local texture = tonumber(entry.texture) or 0

            if type(clotheType) == 'string' and KnownClotheTypes[clotheType]
                and drawable and drawable >= 0 and drawable <= 999
                and texture >= 0 and texture <= 999 then
                giveClotheItem(source, clotheType, drawable, texture)
                given = given + 1
            end
        end
    end)

    ESX.RegisterServerCallback('unique_clothestore:payForClothes', function(source, cb, price, type, number, pin)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then cb(false) return end

        local price = getNearbyStorePrice(source)
        if not price then
            cb(false)
            return
        end

        if type == "cash" then
            if xPlayer.money >= price then
                xPlayer.removeMoney(price)
                PendingClothePurchase[source] = true
                TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["you_paid"]:format(price), 5000, 'success')
                cb(true)
            else
                TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["enought_money"], 5000, 'error')
                cb(false)
                return
            end
        elseif type == 'bank' then

            if xPlayer.bank >= price then
                xPlayer.removeBank(price)
                PendingClothePurchase[source] = true
                TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["you_paid"]:format(price), 5000, 'success')
                cb(true)
            else
                TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["enought_money"], 5000, 'error')
                cb(false)
                return
            end
        end
    end)

    ESX.RegisterServerCallback('unique_clothestore:checkPropertyDataStore', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local foundStore = false
        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
            foundStore = true
        end)
        cb(foundStore)
    end)

    ESX.RegisterServerCallback('unique_clothestore:getPlayerDressing', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if Config.SkinManager == "esx_skin" then
            TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
                local count = store.count('dressing')
                local labels = {}
                for i = 1, count, 1 do
                    local entry = store.get('dressing', i)
                    labels[#labels + 1] = entry.label
                end
                cb(labels)
            end)
        elseif Config.SkinManager == "fivem-appearance" then
            local outfits = {}
            local result = MySQL.query.await('SELECT * FROM outfits WHERE identifier = ?', {xPlayer.identifier})
	        if result then
	        	for i=1, #result, 1 do
	        		outfits[#outfits + 1] = {
	        			id = result[i].id,
	        			name = result[i].name,
	        			ped = json.decode(result[i].ped),
	        			components = json.decode(result[i].components),
	        			props = json.decode(result[i].props)
	        		}
	        	end
	        	cb(outfits)
            end
        elseif Config.SkinManager == "illenium-appearance" then
            local outfits = {}
            local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', {xPlayer.identifier})
	        if result then
	        	for i=1, #result, 1 do
	        		outfits[#outfits + 1] = {
	        			id = result[i].id,
	        			outfitname = result[i].outfitname,
	        			model = json.decode(result[i].model),
	        			components = json.decode(result[i].components),
	        			props = json.decode(result[i].props)
	        		}
	        	end
	        	cb(outfits)
            end
        end
    end)

    ESX.RegisterServerCallback('unique_clothestore:getPlayerOutfit', function(source, cb, num)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
            local outfit = store.get('dressing', num)
            cb(outfit.skin)
        end)
    end)

    RegisterServerEvent('unique_clothestore:saveOutfit')
    AddEventHandler('unique_clothestore:saveOutfit', function(label, skin)
    	local xPlayer = ESX.GetPlayerFromId(source)
    	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
    		local dressing = store.get('dressing')
    		if dressing == nil then
    			dressing = {}
    		end
            dressing[#dressing + 1] = {label = label, skin  = skin}
    		store.set('dressing', dressing)
    		store.save()
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["saved_clothes"]:format(label), 5000, 'success')
        end)
    end)

    RegisterServerEvent('unique_clothestore:removeClothe')
    AddEventHandler('unique_clothestore:removeClothe', function(id)
	    local xPlayer = ESX.GetPlayerFromId(source)
        if Config.SkinManager == 'esx_skin' then
	        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
	    	    local dressing = store.get('dressing') or {}
                for k, v in pairs(dressing) do
                    if v.label == id then
                        table.remove(dressing, k)
                    end
                end
	    	    store.set('dressing', dressing)
                TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
            end)
        elseif Config.SkinManager == 'fivem-appearance' then
            MySQL.update('DELETE FROM outfits WHERE name = ? AND identifier = ?', {id, xPlayer.identifier})
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        elseif Config.SkinManager == "illenium-appearance" then
            MySQL.update('DELETE FROM player_outfits WHERE outfitname = ? AND citizenid = ?', {id, xPlayer.identifier})
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        end
    end)
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    QBCore.Functions.CreateCallback('unique_clothestore:payForClothes', function(source, cb, price, type)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then cb(false) return end

        -- SECURITY FIX: use the real nearby-store price, not the client's.
        local price = getNearbyStorePrice(source)
        if not price then
            cb(false)
            return
        end

        local myMoney = type == "cash" and Player.Functions.GetMoney('cash') or Player.Functions.GetMoney('bank')
        if myMoney >= price then
            if type == "cash" then
                Player.Functions.RemoveMoney('cash', price, "Clothes")
            else
                Player.Functions.RemoveMoney('bank', price, "Clothes")
            end
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["you_paid"]:format(price), 5000, 'success')
            cb(true)
            return
        end
        TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["enought_money"], 5000, 'error')
        cb(false)
    end)

    QBCore.Functions.CreateCallback('unique_clothestore:getPlayerDressing', function(source, cb, price)
        if Config.SkinManager == "illenium-appearance" then
            local Player = QBCore.Functions.GetPlayer(source)
            local outfits = {}
            local result = MySQL.query.await('SELECT * FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.citizenid})
	        if result then
	        	for i=1, #result, 1 do
	        		outfits[#outfits + 1] = {
	        			id = result[i].id,
	        			outfitname = result[i].outfitname,
	        			model = result[i].model,
	        			components = json.decode(result[i].components),
	        			props = json.decode(result[i].props)
	        		}
	        	end
	        	cb(outfits)
            end
        end
    end)

    QBCore.Functions.CreateCallback('unique_clothestore:getCurrentSkin', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, 1})
        if result[1] then
            cb(result[1].skin)
        end
    end)

    RegisterServerEvent('unique_clothestore:removeClothe')
    AddEventHandler('unique_clothestore:removeClothe', function(id)
        local Player = QBCore.Functions.GetPlayer(source)
        if Config.SkinManager == "qb-clothing" then
            MySQL.update('DELETE FROM player_outfits WHERE outfitId = ? AND citizenid = ?', {id, Player.PlayerData.citizenid})
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        elseif Config.SkinManager == "illenium-appearance" then
            MySQL.update('DELETE FROM player_outfits WHERE id = ? AND citizenid = ?', {id, Player.PlayerData.citizenid})
            TriggerClientEvent('unique_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        end
    end)

end