RegisterNetEvent('lgd:renameItem')
AddEventHandler('lgd:renameItem', function(id, name)   
	local source = source
	MySQL.Sync.execute('UPDATE lc_clothes SET name = @name WHERE id = @id', {
		['@id'] = id,   
		['@name'] = name        
	})
end)

-- Faction-lock / Limited-Edition guard shared by both purchase paths
-- below. Returns true (and notifies the player) if the purchase should be
-- BLOCKED.
local function isJobAllowed(jobName, allowedList)
    for _, j in ipairs(allowedList) do
        if j == jobName then return true end
    end
    return false
end

local function blockClothePurchase(xPlayer, componentType, dataClothe)
    if Config.IsClotheLimited(componentType, dataClothe) then
        showNotification(xPlayer, Locales[Config.Language]['cloth_limited'] or 'This item is Limited Edition and cannot be bought here.', 'error')
        return true
    end

    local lock = Config.GetClotheFactionLock(componentType, dataClothe)
    if lock then
        local job = GetJob(xPlayer)
        local jobName = type(job) == 'table' and job.name or job
        if not isJobAllowed(jobName, lock) then
            showNotification(xPlayer, Locales[Config.Language]['cloth_faction_buy'] or 'Your job does not allow you to buy this item.', 'error')
            return true
        end
    end

    return false
end

local function insertCloth(xPlayer, componentType, name, dataClothe)
    local identifier = GetPlayerLicense(xPlayer)
    MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)', {
        ['@identifier'] = identifier,
        ['@type']       = componentType,
        ['@name']       = name,
        ['@data']       = json.encode(dataClothe)
    })

    sendToDiscordWithSpecialURL(
        "🚮 Buy cloth",
        "\n\n``🔢``ID : ``["..xPlayer.source.."] | "..xPlayer.getName().."``\n``💿``Licence: ``"..identifier.."``\n``💬``Action: ``buy cloth "..name.." ``",
        webhooks['buyCloth'].color,
        webhooks['buyCloth'].webhook
    )
end

RegisterNetEvent('lgd_inv:buyClothData')
AddEventHandler('lgd_inv:buyClothData', function(type, name, index, clothes, index2, variation)
  	local xPlayer = GetPlayerFromId(source)
	xPlayer.source = source

  	local dataClothe = {[index]=tonumber(clothes),[index2]=tonumber(variation)} 

	if blockClothePurchase(xPlayer, type, dataClothe) then return end

	insertCloth(xPlayer, type, name, dataClothe)
end)


RegisterNetEvent('lgd_inv:addCloth')
AddEventHandler('lgd_inv:addCloth', function(type, name, clothe)
	local xPlayer = GetPlayerFromId(source)
	xPlayer.source = source

	if blockClothePurchase(xPlayer, type, clothe) then return end

	insertCloth(xPlayer, type, name, clothe)
end)

-- Event-only unlock for Limited Edition clothes: bypasses the Limited
-- check on purpose (that's the whole point - this is the one path that's
-- allowed to hand one out). Call from another resource with:
--   exports.esx_inventory:grantLimitedCloth(source, 'bags', 12, 3, 'Golden Backpack')
exports('grantLimitedCloth', function(source, componentType, drawable, texture, label)
    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil then return false end
    xPlayer.source = source

    local dataClothe = {[componentType .. '_1'] = tonumber(drawable), [componentType .. '_2'] = tonumber(texture)}
    insertCloth(xPlayer, componentType, label or componentType, dataClothe)
    return true
end)

-- FIX: this used to take a raw price NUMBER straight from the client and
-- deduct exactly that - meaning a modified client could just send any
-- number it wanted (e.g. 1) and buy clothing for effectively nothing,
-- since nothing here ever checked it against what the item actually
-- costs. Now takes the CATEGORY (what's actually being bought) and
-- looks the real price up itself from this same Config every server
-- already has, same as the client's buttons show it - the client no
-- longer has any say in what gets charged.
local function getClothPrice(priceKey)
    if priceKey == 'register' then return Config.ClothPriceRegister end
    if priceKey == 'save' then return Config.ClothPriceSave end
    return Config.ClothPrice and Config.ClothPrice[priceKey]
end

RegisterServerCallback("lgd_clothes:getmoney",function(source, cb, priceKey)
    local xPlayer = GetPlayerFromId(source)
    local price = getClothPrice(priceKey)

    if not price then
        cb(false)
        return
    end

    if getAccount(xPlayer, Config.ClothTypeMoney) >= price then
        removeMoney(xPlayer, Config.ClothTypeMoney, price)
        cb(true)
    else
        cb(false)
    end
end)