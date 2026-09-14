RegisterNetEvent('lgd:renameItem')
AddEventHandler('lgd:renameItem', function(id, name)   
	local source = source
	MySQL.Sync.execute('UPDATE lc_clothes SET name = @name WHERE id = @id', {
		['@id'] = id,   
		['@name'] = name        
	})
end)


RegisterNetEvent('lgd_inv:buyClothData')
AddEventHandler('lgd_inv:buyClothData', function(type, name, index, clothes, index2, variation)
  	local xPlayer = GetPlayerFromId(source)
	local identifier = GetPlayerLicense(xPlayer)

  	local dataClothe = {[index]=tonumber(clothes),[index2]=tonumber(variation)} 

	MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)', { 
		['@identifier']   = identifier,
    	['@type']   = type,
    	['@name']   = name,
    	['@data'] = json.encode(dataClothe)
	})

	sendToDiscordWithSpecialURL(
		"🚮 Buy cloth",
		"\n\n``🔢``ID : ``["..source.."] | "..xPlayer.getName().."``\n``💿``Licence: ``"..GetPlayerLicense(xPlayer).."``\n``💬``Action: ``buy cloth "..name.." ``", 
		webhooks['buyCloth'].color, 
		webhooks['buyCloth'].webhook
	)
end)


RegisterNetEvent('lgd_inv:addCloth')
AddEventHandler('lgd_inv:addCloth', function(type, name, clothe)
	local xPlayer = GetPlayerFromId(source)
	local identifier = GetPlayerLicense(xPlayer)
	MySQL.Async.execute('INSERT INTO lc_clothes (identifier, type, name, data) VALUES (@identifier, @type, @name, @data)',{
		['@identifier'] = identifier,
    	['@type'] = type,
    	['@name'] = name,
    	['@data'] = json.encode(clothe)
		}, function(rowsChanged) 
	end)

	sendToDiscordWithSpecialURL(
		"🚮 Buy cloth",
		"\n\n``🔢``ID : ``["..source.."] | "..xPlayer.getName().."``\n``💿``Licence: ``"..GetPlayerLicense(xPlayer).."``\n``💬``Action: ``buy cloth "..name.." ``", 
		webhooks['buyCloth'].color, 
		webhooks['buyCloth'].webhook
	)
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