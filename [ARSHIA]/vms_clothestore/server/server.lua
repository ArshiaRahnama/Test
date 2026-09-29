if Config.Core == "ESX" then
    ESX = Config.CoreExport()

    -- Combined cash + bank balance, and a deduction that takes from cash
    -- first and falls back to bank for the remainder (same pattern used
    -- in vms_barber / vms_tattooshop on this server).
    local function getCombinedMoney(xPlayer)
        local cash = xPlayer.getAccount('money').money or 0
        local bank = xPlayer.getAccount('bank').money or 0
        return cash + bank
    end

    local function removeMoneySmart(xPlayer, amount)
        local cash = xPlayer.getAccount('money').money or 0
        if cash >= amount then
            xPlayer.removeAccountMoney('money', amount)
        else
            if cash > 0 then
                xPlayer.removeAccountMoney('money', cash)
            end
            local remainder = amount - cash
            if remainder > 0 then
                xPlayer.removeAccountMoney('bank', remainder)
            end
        end
    end

    ESX.RegisterServerCallback('vms_clothestore:payForClothes', function(source, cb, price, type)
        local xPlayer = ESX.GetPlayerFromId(source)
        local price = tonumber(price)

        if getCombinedMoney(xPlayer) >= price then
            removeMoneySmart(xPlayer, price)
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["you_paid"]:format(price), 5000, 'success')
            cb(true)
        else
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["enought_money"], 5000, 'error')
            cb(false)
        end
    end)

    ESX.RegisterServerCallback('vms_clothestore:checkPropertyDataStore', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local foundStore = false
        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
            foundStore = true
        end)
        cb(foundStore)
    end)

    ESX.RegisterServerCallback('vms_clothestore:getPlayerDressing', function(source, cb)
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

    ESX.RegisterServerCallback('vms_clothestore:getPlayerOutfit', function(source, cb, num)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
            local outfit = store.get('dressing', num)
            cb(outfit.skin)
        end)
    end)

    RegisterServerEvent('vms_clothestore:saveOutfit')
    AddEventHandler('vms_clothestore:saveOutfit', function(label, skin)
    	local xPlayer = ESX.GetPlayerFromId(source)
    	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
    		local dressing = store.get('dressing')
    		if dressing == nil then
    			dressing = {}
    		end
            dressing[#dressing + 1] = {label = label, skin  = skin}
    		store.set('dressing', dressing)
    		store.save()
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["saved_clothes"]:format(label), 5000, 'success')
        end)
    end)
    
    RegisterServerEvent('vms_clothestore:removeClothe')
    AddEventHandler('vms_clothestore:removeClothe', function(id)
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
                TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
            end)
        elseif Config.SkinManager == 'fivem-appearance' then
            MySQL.update('DELETE FROM outfits WHERE name = ? AND identifier = ?', {id, xPlayer.identifier})
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        elseif Config.SkinManager == "illenium-appearance" then
            MySQL.update('DELETE FROM player_outfits WHERE outfitname = ? AND citizenid = ?', {id, xPlayer.identifier})
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        end
    end)

elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    QBCore.Functions.CreateCallback('vms_clothestore:payForClothes', function(source, cb, price, type)
        local Player = QBCore.Functions.GetPlayer(source)
        local price = tonumber(price)
        local cash = Player.Functions.GetMoney('cash') or 0
        local bank = Player.Functions.GetMoney('bank') or 0

        if (cash + bank) >= price then
            if cash >= price then
                Player.Functions.RemoveMoney('cash', price, "Clothes")
            else
                if cash > 0 then
                    Player.Functions.RemoveMoney('cash', cash, "Clothes")
                end
                Player.Functions.RemoveMoney('bank', price - cash, "Clothes")
            end
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["you_paid"]:format(price), 5000, 'success')
            cb(true)
            return
        end
        TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["enought_money"], 5000, 'error')
        cb(false)
    end)
    
    QBCore.Functions.CreateCallback('vms_clothestore:getPlayerDressing', function(source, cb, price)
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

    QBCore.Functions.CreateCallback('vms_clothestore:getCurrentSkin', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {Player.PlayerData.citizenid, 1})
        if result[1] then
            cb(result[1].skin)
        end
    end)

    RegisterServerEvent('vms_clothestore:removeClothe')
    AddEventHandler('vms_clothestore:removeClothe', function(id)
        local Player = QBCore.Functions.GetPlayer(source)
        if Config.SkinManager == "qb-clothing" then
            MySQL.update('DELETE FROM player_outfits WHERE outfitId = ? AND citizenid = ?', {id, Player.PlayerData.citizenid})
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        elseif Config.SkinManager == "illenium-appearance" then
            MySQL.update('DELETE FROM player_outfits WHERE id = ? AND citizenid = ?', {id, Player.PlayerData.citizenid})
            TriggerClientEvent('vms_clothestore:notification', source, Config.Translate["removed_clothes"], 5000, 'success')
        end
    end)

end