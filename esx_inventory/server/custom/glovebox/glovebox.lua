-------------------------------------------------------------------
-- Glovebox storage backend - items only, separate from the trunk
-- (VehCoffre in server/apps/system/trunk.lua). Same lazy-load +
-- JSON-persistence pattern as server/custom/property/property.lua.
-------------------------------------------------------------------

local Gloveboxes = {} -- [plate] = { items = {[name] = {label, count, weight}} }

local function normalizePlate(plate)
    return tostring(plate):gsub("^%s*(.-)%s*$", "%1")
end

local function loadGlovebox(plate)
    plate = normalizePlate(plate)
    if Gloveboxes[plate] then return Gloveboxes[plate] end

    local data = { items = {} }
    local result = MySQL.Sync.fetchScalar('SELECT data FROM lc_glovebox WHERE plate = @plate', { ['@plate'] = plate })
    if result then
        local ok, decoded = pcall(json.decode, result)
        if ok and type(decoded) == 'table' then
            data.items = decoded.items or {}
        end
    end

    Gloveboxes[plate] = data
    return data
end

local function saveGlovebox(plate)
    plate = normalizePlate(plate)
    local data = Gloveboxes[plate]
    if not data then return end
    MySQL.Async.execute('INSERT INTO lc_glovebox (plate, data) VALUES (@plate, @data) ON DUPLICATE KEY UPDATE data = @data', {
        ['@plate'] = plate,
        ['@data'] = json.encode(data)
    })
end

local function getGloveboxWeight(glovebox)
    local total = 0
    for _, item in pairs(glovebox.items) do
        total = total + (tonumber(item.weight) or 0) * (tonumber(item.count) or 1)
    end
    return total
end

RegisterServerCallback("lgddddd:getGlovebox", function(source, cb, plate)
    if type(plate) ~= 'string' or plate == '' then
        cb(nil)
        return
    end

    local glovebox = loadGlovebox(plate)
    local items = {}
    for name, entry in pairs(glovebox.items) do
        table.insert(items, { name = name, label = entry.label, count = entry.count })
    end

    cb({
        weight = getGloveboxWeight(glovebox),
        maxWeight = Config.DefaultGloveboxMaxWeight or 5,
        items = items,
    })
end)

RegisterNetEvent("lgd:actionGlovebox")
AddEventHandler("lgd:actionGlovebox", function(plate, action, name, label, count)
    local source = source
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer or type(plate) ~= 'string' or type(name) ~= 'string' then return end
    count = tonumber(count) or 0
    if count <= 0 then return end

    local glovebox = loadGlovebox(plate)

    if action == 'deposit' then
        local playerItem = GetItem(xPlayer, name)
        if not playerItem or GetItemAmount(playerItem) < count then
            showNotification(xPlayer, Locales[Config.Language]['trunk_error_number_item'], 'error')
            return
        end

        local weight = ESX and ESX.getItemWeight and ESX.getItemWeight(name) or 0
        if getGloveboxWeight(glovebox) + (weight * count) > (Config.DefaultGloveboxMaxWeight or 5) then
            showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
            return
        end

        if glovebox.items[name] then
            glovebox.items[name].count = tonumber(glovebox.items[name].count) + count
        else
            glovebox.items[name] = { label = label or name, count = count, weight = weight }
        end

        RemoveItem(xPlayer, name, count)
        showNotification(xPlayer, (Locales[Config.Language]['trunk_deposit']):format(count, label or name), 'success')
        saveGlovebox(plate)

    elseif action == 'remove' then
        local entry = glovebox.items[name]
        if not entry or tonumber(entry.count) < count then
            showNotification(xPlayer, Locales[Config.Language]['trunk_error_number_item'], 'error')
            return
        end

        if not getWeight(xPlayer, name, count) then
            showNotification(xPlayer, Locales[Config.Language]['trunk_weight_player_max'], 'error')
            return
        end

        entry.count = tonumber(entry.count) - count
        if entry.count <= 0 then glovebox.items[name] = nil end

        AddItem(xPlayer, name, count)
        showNotification(xPlayer, (Locales[Config.Language]['trunk_remove']):format(count, label or name), 'success')
        saveGlovebox(plate)
    end
end)
