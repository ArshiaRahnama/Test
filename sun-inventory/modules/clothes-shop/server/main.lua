--[[
    sun-inventory — clothes shop server.

    Security pattern ported straight from esx_inventory/server/apps/system/
    clothes.lua's own documented fix: the client sends a CATEGORY
    ('tshirt', 'pants', ...) and the drawable/texture it wants to preview,
    never a price — the price is always looked up server-side from
    ClothShop.Prices, so a modified client cannot buy anything for less
    than its real price.
]]

local function isJobAllowed(jobName, allowedList)
    for _, j in ipairs(allowedList) do
        if j == jobName then return true end
    end
    return false
end

-- Returns true (and notifies) if the purchase should be BLOCKED.
local function blockPurchase(xPlayer, wardrobeType, dataClothe)
    local key = WardrobeValueKey(wardrobeType, dataClothe)

    if key and ClothShop.Limited[wardrobeType] and ClothShop.Limited[wardrobeType][key] then
        xPlayer.showNotification('This item is Limited Edition and cannot be bought here.')
        return true
    end

    local lock = key and ClothShop.FactionLock[wardrobeType] and ClothShop.FactionLock[wardrobeType][key]
    if lock then
        local jobName = xPlayer.job and xPlayer.job.name
        if not isJobAllowed(jobName, lock) then
            xPlayer.showNotification('Your job does not allow you to buy this item.')
            return true
        end
    end

    return false
end

RegisterServerEvent('sun-clothes:buy')
AddEventHandler('sun-clothes:buy', function(wardrobeType, label, drawable, texture)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local def = WardrobeTypes[wardrobeType]
    if not def then return end -- unknown type, not a valid shop category

    local price = ClothShop.Prices[wardrobeType]
    if not price then return end

    drawable, texture = tonumber(drawable), tonumber(texture)
    if drawable == nil then return end
    texture = texture or 0

    local dataClothe
    if wardrobeType == 'arms' then
        dataClothe = { arms = drawable, arms_2 = texture }
    else
        dataClothe = { [def.pair[1]] = drawable, [def.pair[2]] = texture }
    end

    if blockPurchase(xPlayer, wardrobeType, dataClothe) then return end

    Inventory.withLock(source, function()
        if xPlayer.getAccount(ClothShop.AccountName).money < price then
            xPlayer.showNotification('Not enough money.')
            return
        end
        xPlayer.removeAccountMoney(ClothShop.AccountName, price)

        MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)', {
            ['@identifier'] = xPlayer.identifier,
            ['@type'] = wardrobeType,
            ['@name'] = label or wardrobeType,
            ['@data'] = json.encode(dataClothe),
        })

        xPlayer.showNotification(('Bought: %s'):format(label or wardrobeType))
    end)
end)

-- Event-only unlock for Limited Edition clothes: bypasses the Limited
-- check on purpose (this is the one path that's allowed to hand one out).
-- exports.sun-inventory:grantLimitedCloth(source, 'bag', 12, 3, 'Golden Backpack')
exports('grantLimitedCloth', function(source, wardrobeType, drawable, texture, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    local def = WardrobeTypes[wardrobeType]
    if not def then return false end

    local dataClothe
    if wardrobeType == 'arms' then
        dataClothe = { arms = tonumber(drawable), arms_2 = tonumber(texture) }
    else
        dataClothe = { [def.pair[1]] = tonumber(drawable), [def.pair[2]] = tonumber(texture) }
    end

    MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)', {
        ['@identifier'] = xPlayer.identifier,
        ['@type'] = wardrobeType,
        ['@name'] = label or wardrobeType,
        ['@data'] = json.encode(dataClothe),
    })
    return true
end)
