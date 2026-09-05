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

    -- Give every player a permanent "Wardrobe Remote" the first time they
    -- spawn — a nicer way to manage worn clothes than digging through the
    -- inventory item by item. Non-consumable, can't be dropped/sold.
    AddEventHandler('es:firstSpawn', function(source, player)
        CreateThread(function()
            local xPlayer
            for _ = 1, 25 do
                xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then break end
                Wait(200)
            end
            if not xPlayer then return end

            local has = xPlayer.getInventoryItem('wardrobe_remote')
            if not has or has.count <= 0 then
                xPlayer.addInventoryItem('wardrobe_remote', 1)
            end
        end)
    end)

    -- Each drawable/texture combo is its own real item (e.g.
    -- "clothing_tshirt_5_2"), not one generic "clothing_tshirt" item with
    -- per-instance metadata -- this essentialmode's addInventoryItem only
    -- takes (name, count), it has no metadata/slot-info support at all, so
    -- the metadata approach never actually worked (info was always nil).
    --
    -- ESX here is the actual shared object (same table essentialmode itself
    -- uses - esx:getSharedObject passes a live reference, not a copy, for
    -- same-side server events), so registering new entries directly into
    -- ESX.Items from here makes them immediately valid for
    -- addInventoryItem/getInventoryItem/GetItemLabel etc, exactly like any
    -- item essentialmode loaded from the `items` table itself.
    local function clotheItemName(clotheType, drawable, texture)
        return ('clothing_%s_%d_%d'):format(clotheType, drawable, texture)
    end

    local function wornClotheItemName(clotheType, drawable, texture)
        return ('worn_clothing_%s_%d_%d'):format(clotheType, drawable, texture)
    end

    -- Registers both the "wear" handler for clothing_<type>_<d>_<t> and the
    -- matching "take off" handler for worn_clothing_<type>_<d>_<t>, and adds
    -- both names to ESX.Items (in-memory) + the `items` table (persisted,
    -- so they still exist after essentialmode restarts and reloads its
    -- items from the DB). Safe to call repeatedly for the same variant -
    -- guarded so it only does real work the first time.
    local RegisteredClotheVariants = {}
    local function ensureClotheVariantRegistered(clotheType, drawable, texture)
        local key = clotheType .. '_' .. drawable .. '_' .. texture
        if RegisteredClotheVariants[key] then return end
        RegisteredClotheVariants[key] = true

        local itemName = clotheItemName(clotheType, drawable, texture)
        local wornItemName = wornClotheItemName(clotheType, drawable, texture)
        local label = (ClotheTypeLabel[clotheType] or clotheType) .. (' #%d'):format(drawable)
        local wornLabel = 'Worn: ' .. label

        for _, def in ipairs({ { itemName, label }, { wornItemName, wornLabel } }) do
            local name, itemLabel = def[1], def[2]
            if not ESX.Items[name] then
                ESX.Items[name] = { name = name, label = itemLabel, limit = -1, rare = false, canRemove = true }
                MySQL.Async.execute('INSERT IGNORE INTO items (name, label, `limit`, rare, can_remove) VALUES (?, ?, -1, 0, 1)', { name, itemLabel })
            end
        end

        ESX.RegisterUsableItem(wornItemName, function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return end
            if not xPlayer.getInventoryItem(wornItemName) or xPlayer.getInventoryItem(wornItemName).count <= 0 then return end

            TriggerClientEvent('unique_clothestore:takeOffClotheItem', source, clotheType)
            xPlayer.removeInventoryItem(wornItemName, 1)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('ox_lib:notify', source, { description = ('درآوردی: %s'):format(label), type = 'inform' })
        end)

        ESX.RegisterUsableItem(itemName, function(source)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then return end
            if not xPlayer.getInventoryItem(itemName) or xPlayer.getInventoryItem(itemName).count <= 0 then return end

            -- if a piece of the same type is already worn, take it off
            -- first so you never end up with two worn items for one slot
            for otherKey in pairs(RegisteredClotheVariants) do
                local otherType = otherKey:match('^(.+)_%d+_%d+$')
                if otherType == clotheType then
                    local otherDrawable, otherTexture = otherKey:match('_(%d+)_(%d+)$')
                    local otherWornName = wornClotheItemName(clotheType, tonumber(otherDrawable), tonumber(otherTexture))
                    local wornItem = xPlayer.getInventoryItem(otherWornName)
                    if wornItem and wornItem.count > 0 then
                        xPlayer.removeInventoryItem(otherWornName, wornItem.count)
                        xPlayer.addInventoryItem(clotheItemName(clotheType, tonumber(otherDrawable), tonumber(otherTexture)), wornItem.count)
                    end
                end
            end

            xPlayer.removeInventoryItem(itemName, 1)
            xPlayer.addInventoryItem(wornItemName, 1)
            TriggerClientEvent('unique_clothestore:wearClotheItem', source, clotheType, drawable, texture)
            TriggerClientEvent('ox_lib:notify', source, { description = ('پوشیدی: %s'):format(label), type = 'success' })
        end)
    end

    -- Re-register every variant this system has ever created (persisted in
    -- the `items` table) so their usable-item handlers exist again after a
    -- restart - ESX.UsableItemsCallbacks is in-memory only.
    CreateThread(function()
        local rows = MySQL.query.await("SELECT name FROM items WHERE name LIKE 'clothing\\_%'", {}) or {}
        for _, row in ipairs(rows) do
            local clotheType, drawable, texture = row.name:match('^clothing_([a-z]+)_(%d+)_(%d+)$')
            if clotheType and KnownClotheTypes[clotheType] then
                ensureClotheVariantRegistered(clotheType, tonumber(drawable), tonumber(texture))
            end
        end
    end)

    local function giveClotheItem(source, clotheType, drawable, texture)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        ensureClotheVariantRegistered(clotheType, drawable, texture)
        xPlayer.addInventoryItem(clotheItemName(clotheType, drawable, texture), 1)
    end

    -- The "Wardrobe Remote" — a nicer way to manage worn clothes than
    -- digging through the inventory item by item. Opens a menu listing
    -- everything currently worn, each with its own take-off button, plus
    -- an "Undress All" option.
    ESX.RegisterUsableItem('wardrobe_remote', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        local wornTypes = {}
        for clotheType in pairs(ClotheTypeLabel) do
            local wornItemName = 'worn_clothing_' .. clotheType
            for i = 1, #xPlayer.inventory, 1 do
                if xPlayer.inventory[i].name == wornItemName then
                    local meta = xPlayer.inventory[i].info or {}
                    wornTypes[#wornTypes + 1] = { clotheType = clotheType, label = meta.label or ClotheTypeLabel[clotheType] }
                    break
                end
            end
        end

        TriggerClientEvent('unique_clothestore:openWardrobeMenu', source, wornTypes)
    end)

    RegisterServerEvent('unique_clothestore:takeOffFromMenu')
    AddEventHandler('unique_clothestore:takeOffFromMenu', function(clotheType)
        local playerId = source
        if clotheType == '__all__' then
            local any = false
            for t in pairs(ClotheTypeLabel) do
                if takeOffClothing(playerId, t) then any = true end
            end
            if any then
                TriggerClientEvent('ox_lib:notify', playerId, { description = 'کلاً لخت شدی', type = 'inform' })
            end
            return
        end

        if not KnownClotheTypes[clotheType] then return end
        local ok, label = takeOffClothing(playerId, clotheType)
        if ok then
            TriggerClientEvent('ox_lib:notify', playerId, { description = ('درآوردی: %s'):format(label or clotheType), type = 'inform' })
        end
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