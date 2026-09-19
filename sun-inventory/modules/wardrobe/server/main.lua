--[[ sun-inventory — wardrobe (owned lc_clothes) server. Reuses the exact
     same `lc_clothes` table the old esx_inventory wrote to, so nothing
     already-owned is lost by switching inventories. ]]

ESX.RegisterServerCallback('sun-wardrobe:getOwned', function(source, cb, wardrobeType)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not WardrobeTypes[wardrobeType] then return cb({}) end

    local rows = MySQL.Sync.fetchAll('SELECT id, type, name, data FROM lc_clothes WHERE identifier = @identifier AND type = @type', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = wardrobeType,
    })
    for _, row in ipairs(rows) do
        row.data = json.decode(row.data) or {}
    end
    cb(rows)
end)

ESX.RegisterServerCallback('sun-wardrobe:getPacks', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb({}) end

    local rows = MySQL.Sync.fetchAll('SELECT id, type, name, data FROM lc_clothes WHERE identifier = @identifier AND type = @type', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = 'outfit',
    })
    for _, row in ipairs(rows) do
        row.data = json.decode(row.data) or {}
    end
    cb(rows)
end)

RegisterServerEvent('sun-wardrobe:createPack')
AddEventHandler('sun-wardrobe:createPack', function(name, fullSkin)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if type(name) ~= 'string' or #name == 0 or #name > 60 or name:match('[^%w%s]') then return end
    if type(fullSkin) ~= 'table' then return end

    MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = 'outfit',
        ['@name'] = name,
        ['@data'] = json.encode(fullSkin),
    })
end)

RegisterServerEvent('lgd:renameItem') -- kept from the old resource: client/clothe.lua-adjacent UIs may still call this event name
AddEventHandler('lgd:renameItem', function(id, name)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if type(name) ~= 'string' or #name == 0 or #name > 60 then return end

    -- IDOR guard: only rename a row that's actually yours.
    MySQL.Async.execute('UPDATE lc_clothes SET name = @name WHERE id = @id AND identifier = @identifier', {
        ['@id'] = tonumber(id),
        ['@name'] = name,
        ['@identifier'] = xPlayer.identifier,
    })
end)

-- Give an owned clothing item (a single lc_clothes row) to another nearby
-- player, mirroring the give-item pattern the rest of this resource uses.
RegisterServerEvent('sun-wardrobe:give')
AddEventHandler('sun-wardrobe:give', function(rowId, targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(tonumber(targetId))
    if not xPlayer or not xTarget or xPlayer.source == xTarget.source then return end

    local pPed, tPed = GetPlayerPed(src), GetPlayerPed(xTarget.source)
    if #(GetEntityCoords(pPed) - GetEntityCoords(tPed)) > 5.0 then return end

    Inventory.withLock(src, function()
        -- Ownership check happens IN the UPDATE's WHERE clause, not before it
        -- - that's what makes this IDOR-safe: a row that isn't yours simply
        -- won't match, so affectedRows tells us whether the transfer is real.
        MySQL.Async.execute('UPDATE lc_clothes SET identifier = @newIdentifier WHERE id = @id AND identifier = @identifier', {
            ['@id'] = tonumber(rowId),
            ['@identifier'] = xPlayer.identifier,
            ['@newIdentifier'] = xTarget.identifier,
        }, function(affectedRows)
            if affectedRows and affectedRows > 0 then
                xPlayer.showNotification('Clothing item given.')
                xTarget.showNotification('You received a clothing item.')
            end
        end)
    end)
end)
