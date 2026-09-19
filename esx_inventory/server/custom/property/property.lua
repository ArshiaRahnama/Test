-------------------------------------------------------------------
-- Property (house) storage backend.
--
-- FIX: this whole file used to be a stub. `dataFromProperty` returned
-- the bare global `data` (never assigned anywhere -> always nil, so
-- every property chest opened empty no matter what was stored), and
-- every single deposit/remove handler in `action_Property` had an
-- empty body - depositing or withdrawing an item from a property
-- silently did nothing at all, every time, for every item type.
-- Rebuilt on the same pattern as server/apps/system/stash.lua
-- (lazy-loaded per-id cache + JSON persistence), wired to the exact
-- data shapes client/apps/system/property.lua and
-- client/custom/property/property.lua already expect.
-------------------------------------------------------------------

local Properties = {} -- [id] = { items = {[name]=...}, weapons = {list}, clothes = {[clotheId]=...}, accounts = {[name]=...} }

local function loadProperty(id)
    id = tostring(id)
    if Properties[id] then return Properties[id] end

    local data = { items = {}, weapons = {}, clothes = {}, accounts = {} }
    local result = MySQL.Sync.fetchScalar('SELECT data FROM lc_property WHERE property_id = @id', { ['@id'] = id })
    if result then
        local ok, decoded = pcall(json.decode, result)
        if ok and type(decoded) == 'table' then
            data.items = decoded.items or {}
            data.weapons = decoded.weapons or {}
            data.clothes = decoded.clothes or {}
            data.accounts = decoded.accounts or {}
        end
    end

    Properties[id] = data
    return data
end

local function saveProperty(id)
    id = tostring(id)
    local data = Properties[id]
    if not data then return end
    MySQL.Async.execute('INSERT INTO lc_property (property_id, data) VALUES (@id, @data) ON DUPLICATE KEY UPDATE data = @data', {
        ['@id'] = id,
        ['@data'] = json.encode(data)
    })
end

local function getPropertyWeight(property)
    local total = 0
    for _, item in pairs(property.items) do
        total = total + (tonumber(item.weight) or 0) * (tonumber(item.count) or 1)
    end
    for _, weapon in pairs(property.weapons) do
        total = total + (tonumber(weapon.weight) or 0)
    end
    for _, clothe in pairs(property.clothes) do
        total = total + (tonumber(clothe.weight) or 0)
    end
    return total
end

function dataFromProperty(source, idProperty)
    local property = loadProperty(idProperty)

    local accounts = {}
    for name, entry in pairs(property.accounts) do
        if tonumber(entry.count) and tonumber(entry.count) > 0 then
            table.insert(accounts, { name = name, count = entry.count })
        end
    end

    local items = {}
    for name, entry in pairs(property.items) do
        table.insert(items, { name = name, label = entry.label, count = entry.count })
    end

    local weapons = {}
    for _, entry in pairs(property.weapons) do
        table.insert(weapons, { name = entry.name, label = entry.label })
    end

    local clothes = {}
    for clotheId, entry in pairs(property.clothes) do
        table.insert(clothes, { name = entry.name, label = entry.label, id = clotheId })
    end

    return {
        weight = getPropertyWeight(property),
        maxWeight = Config.DefaultPropertyMaxWeight or 250,
        accounts = accounts,
        items = items,
        weapons = weapons,
        clothes = clothes,
    }
end

action_Property = {
    ['item'] = {
        ['deposit'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end
            local count = tonumber(data.count) or 0
            if count <= 0 then return end

            local playerItem = GetItem(xPlayer, data.name)
            if not playerItem or GetItemAmount(playerItem) < count then return end

            local property = loadProperty(data.idProperty)
            local weight = tonumber(data.weight) or (ESX and ESX.getItemWeight(data.name)) or 0

            if getPropertyWeight(property) + (weight * count) > (Config.DefaultPropertyMaxWeight or 250) then
                showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
                return
            end

            if property.items[data.name] then
                property.items[data.name].count = tonumber(property.items[data.name].count) + count
            else
                property.items[data.name] = { label = data.label, count = count, weight = weight }
            end

            RemoveItem(xPlayer, data.name, count)
            saveProperty(data.idProperty)
        end,
        ['remove'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end
            local count = tonumber(data.count) or 0
            if count <= 0 then return end

            local property = loadProperty(data.idProperty)
            local entry = property.items[data.name]
            if not entry or tonumber(entry.count) < count then
                showNotification(xPlayer, Locales[Config.Language]['trunk_error_number_item'], 'error')
                return
            end

            if not getWeight(xPlayer, data.name, count) then
                showNotification(xPlayer, Locales[Config.Language]['trunk_weight_player_max'], 'error')
                return
            end

            entry.count = tonumber(entry.count) - count
            if entry.count <= 0 then property.items[data.name] = nil end

            AddItem(xPlayer, data.name, count)
            saveProperty(data.idProperty)
        end
    },

    ['weapon'] = {
        ['deposit'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end

            local weaponInfo = getWeapon(xPlayer, data.name)
            if not weaponInfo then return end

            local property = loadProperty(data.idProperty)
            local weight = tonumber(data.weight) or (ESX and ESX.getWeaponWeight(data.name)) or 0

            if getPropertyWeight(property) + weight > (Config.DefaultPropertyMaxWeight or 250) then
                showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
                return
            end

            table.insert(property.weapons, {
                name = data.name,
                label = data.label,
                weight = weight,
                serial = weaponInfo.serial,
                ammo = weaponInfo.ammo,
            })
            removeWeapon(xPlayer, data.name, weaponInfo.serial)
            saveProperty(data.idProperty)
        end,
        ['remove'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end

            local property = loadProperty(data.idProperty)
            local foundIdx
            for i, entry in ipairs(property.weapons) do
                if entry.name == data.name then
                    foundIdx = i
                    break
                end
            end
            if not foundIdx then return end

            local weapon = table.remove(property.weapons, foundIdx)
            addWeapon(xPlayer, data.name, weapon.ammo or 250, weapon.serial or ESX.GenerateWeaponSerial())
            saveProperty(data.idProperty)
        end
    },

    ['account'] = {
        ['deposit'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end
            local count = tonumber(data.count) or 0
            if count <= 0 then return end
            if getAccount(xPlayer, data.name) < count then
                showNotification(xPlayer, Locales[Config.Language]['trunk_error_number_item'], 'error')
                return
            end

            local property = loadProperty(data.idProperty)
            if property.accounts[data.name] then
                property.accounts[data.name].count = tonumber(property.accounts[data.name].count) + count
            else
                property.accounts[data.name] = { count = count }
            end

            removeMoney(xPlayer, data.name, count)
            saveProperty(data.idProperty)
        end,
        ['remove'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer or type(data.name) ~= 'string' then return end
            local count = tonumber(data.count) or 0
            if count <= 0 then return end

            local property = loadProperty(data.idProperty)
            local entry = property.accounts[data.name]
            if not entry or tonumber(entry.count) < count then
                showNotification(xPlayer, Locales[Config.Language]['trunk_error_number'], 'error')
                return
            end

            entry.count = tonumber(entry.count) - count
            if entry.count <= 0 then property.accounts[data.name] = nil end

            addMoney(xPlayer, data.name, count)
            saveProperty(data.idProperty)
        end
    },

    ['clothe'] = {
        ['deposit'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer then return end

            local property = loadProperty(data.idProperty)
            local weight = tonumber(data.weight) or 0

            if getPropertyWeight(property) + weight > (Config.DefaultPropertyMaxWeight or 250) then
                showNotification(xPlayer, Locales[Config.Language]['trunk_weight_max'], 'error')
                return
            end

            property.clothes[tostring(data.name)] = { name = data.name, label = data.label, weight = weight }

            MySQL.Async.execute('UPDATE lc_clothes SET identifier = @identifier WHERE id = @id', {
                ['@identifier'] = 'property_' .. tostring(data.idProperty),
                ['@id'] = data.name
            })
            saveProperty(data.idProperty)
        end,
        ['remove'] = function(source, data)
            local xPlayer = GetPlayerFromId(source)
            if not xPlayer then return end

            local property = loadProperty(data.idProperty)
            if not property.clothes[tostring(data.name)] then return end
            property.clothes[tostring(data.name)] = nil

            MySQL.Async.execute('UPDATE lc_clothes SET identifier = @identifier WHERE id = @id', {
                ['@identifier'] = GetPlayerLicense(xPlayer),
                ['@id'] = data.name
            })
            saveProperty(data.idProperty)
        end
    },
}
