-- variables --
local USING_ACE = USING_ACE
local JOBS = CFG.RESTRICTIONS.JOBS
local SEARCH_ITEMS = CFG.SETTINGS.SEARCH.items

-- CALLBACKS --
lib.callback.register('sh-k9:CB:HAS_ACE', function(source)
    local src = source
    return IsPlayerAceAllowed(src, 'k9')
end)

lib.callback.register('sh-k9:CB:GET_DOGS', function(source)
    local src = source
    local dogs = {}
    local cid = GetIdentifier(src)
    
    if CFG.DATABASE == 'mysql-async' then
        local result = MySQL.Sync.fetchAll("SELECT * FROM k9 WHERE identifier = @identifier", { ['@identifier'] = cid })
        for k, v in pairs(result) do
            local data = json.decode(v.dog_data)
            dogs[#dogs+1] = data
            dogs[#dogs]["id"] = v.id
        end
    elseif CFG.DATABASE == 'oxmysql' then
        local result = MySQL.query.await('SELECT * FROM k9 WHERE identifier = ?', { cid })
        for k, v in pairs(result) do
            local data = json.decode(v.dog_data)
            dogs[#dogs+1] = data
            dogs[#dogs]["id"] = v.id
        end
    else
        -- nothing
    end

    return dogs
end)

lib.callback.register('sh-k9:CB:SEARCH_PLAYER', function(source, playerId)
    local src = source
    local Player = GetPlayer(src)
    local SearchedPlayer = GetPlayer(playerId)
    local found = false

    if not Player or not SearchedPlayer then return end 
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end

    local items, weapons = nil, nil
    local allWeapons = CFG.SETTINGS.SEARCH.AllWeapons

    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
        items = GetPlayerItems(playerId)
    else
        items, weapons = GetPlayerItems(playerId)
    end

    if (items and next(items)) or (weapons and next(weapons)) then
        for itemName in pairs(SEARCH_ITEMS) do
            if items and next(items) then
                for k, item in pairs(items) do
                    if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
                        if allWeapons then
                            if string.find(item.name, "weapon") then
                                found = true
                                break
                            end
                        end 
                        if itemName == item.name then
                            found = true
                            break
                        end
                    else
                        if item.count > 0 then
                            if allWeapons then
                                if string.find(string.lower(item.name), "weapon") then
                                    found = true
                                    break
                                end
                            end 
                            if itemName == item.name then
                                found = true
                                break
                            end
                        end
                    end
                end
            end

            if weapons and next(weapons) then
                for k, item in pairs(weapons) do
                    if allWeapons then
                        if string.find(string.lower(item.name), "weapon") then
                            found = true
                            break
                        end
                    end 
                    if itemName == item.name then
                        found = true
                        break
                    end
                end
            end
        end
    end
    return found
end)

lib.callback.register('sh-k9:CB:SEARCH_VEHICLE', function(source, plate)
    local src = source
    local Player = GetPlayer(src)

    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end

    local found = false
    local trunkitems, gloveboxitems = GetVehicleItems(plate, 'trunk'), GetVehicleItems(plate, 'glovebox')
    local allWeapons = CFG.SETTINGS.SEARCH.AllWeapons

    if (trunkitems and next(trunkitems)) or (gloveboxitems and next(gloveboxitems)) then
        for itemName in pairs(SEARCH_ITEMS) do
            if not found then
                if trunkitems and next(trunkitems) then
                    for k, item in pairs(trunkitems) do
                        if allWeapons then
                            if string.find(string.lower(item.name), "weapon") then
                                found = true
                                break
                            end
                        end 

                        if itemName == item.name then
                            found = true
                            break
                        end
                    end
                end

                if gloveboxitems and next(gloveboxitems) then
                    for k, item in pairs(gloveboxitems) do
                        if allWeapons then
                            if string.find(string.lower(item.name), "weapon") then
                                --print('found weapon ', item.name)
                                found = true
                                break
                            end
                        end 

                        if itemName == item.name then
                            --print('found item ', itemName)
                            found = true
                            break
                        end
                    end
                end
            end
        end
    end

    return found
end)


-- EVENTS --
RegisterNetEvent('sh-k9:sv:TackleAction', function(id, netId)
    local src = source
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end
    local cid = GetIdentifier(src)

    if CFG.DATABASE == 'mysql-async' then
        local result = MySQL.Sync.fetchAll("SELECT * FROM k9 WHERE identifier = @identifier", { ['@identifier'] = cid })
        if result and next(result) then
            TriggerClientEvent('sh-k9:cl:TackleAction', id, netId)
        end
    elseif CFG.DATABASE == 'oxmysql' then
        local result = MySQL.query.await('SELECT * FROM k9 WHERE identifier = ?', { cid })
        if result and next(result) then
            TriggerClientEvent('sh-k9:cl:TackleAction', id, netId)
        end
    end
end)

RegisterNetEvent('sh-k9:sv:SaveDog', function(data, id, appearance)
    local src = source
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end
    local cid = GetIdentifier(src)

    if id and type(id) == 'number' then
        if appearance then
            data.appearance = appearance
        end

        if CFG.DATABASE == 'mysql-async' then
            MySQL.Async.execute('UPDATE k9 SET dog_data = @dog_data WHERE id = @id AND identifier = @identifier',
            { ['@dog_data'] = json.encode(data), ['@id'] = id, ['@identifier'] = cid })
        elseif CFG.DATABASE == 'oxmysql' then
            local cb = MySQL.update.await('UPDATE k9 SET dog_data = ? WHERE id = ? AND identifier = ?', { json.encode(data), id, cid })
        end
    end
end)

RegisterNetEvent('sh-k9:sv:RemoveItem', function(item)
    local src = source
    local Player = GetPlayer(src)

    if not Player then return end 
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end
    RemoveItem(Player, item)
end)

RegisterNetEvent('sh-k9:sv:AddItem', function(item)
    local src = source
    local Player = GetPlayer(src)

    if not Player then return end 
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end
    AddItem(Player, item)
end)

RegisterNetEvent('sh-k9:sv:RegisterDog', function(breed, hash, name)
    local src = source
    if (USING_ACE and not IsPlayerAceAllowed(src, 'k9')) or not JOBS[HasAccess(src)] then return end
    local cid = GetIdentifier(src)

    local dog_data = {
        dogName = name, dogHash = hash, dogBreed = breed,
        stats = { health = CFG.SETTINGS.STATUS.maxHealth, armor = CFG.SETTINGS.maxArmor, lvl = 1, xp = 0, hunger = 100, thirst = 100 }
    }

    if CFG.DATABASE == 'mysql-async' then
        MySQL.Async.execute('INSERT INTO k9 (identifier, dog_data) VALUES (@identifier, @dog_data)', { ['@identifier'] = cid, ['@dog_data'] = json.encode(dog_data) })
        TriggerClientEvent('sh-k9:cl:OpenK9', src)
    elseif CFG.DATABASE == 'oxmysql' then
        local cb = MySQL.insert.await('INSERT INTO k9 (identifier, dog_data) VALUES (?, ?)', { cid, json.encode(dog_data) })
        if cb then 
            TriggerClientEvent('sh-k9:cl:OpenK9', src)
        end
    end
end)
