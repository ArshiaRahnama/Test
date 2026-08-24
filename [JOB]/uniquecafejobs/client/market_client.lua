AddEventHandler('playerSpawned', function()
    SendMarketNUI({
        config = Config,
        translate = translate,
        NameResource = GetCurrentResourceName()
    })
end)

AddEventHandler('onResourceStart', function()
    Wait(5000)
    SendMarketNUI({
        config = Config,
        translate = translate,
        NameResource = GetCurrentResourceName()
    })
end)

RegisterNetEvent('lg: loaduwuMarket')
AddEventHandler('lg: loaduwuMarket', function(identifier, result)
    SendMarketNUI({
        open = true,
        list_products = list_products,
        products = result,
        identifier = identifier
    })

    SetNuiFocus(true, true)
end)

RegisterNetEvent('lg: loadPlayeruwuMarket')
AddEventHandler('lg: loadPlayeruwuMarket', function(inventory, result)

    SendMarketNUI({
        myProductsOpen = true,
        list_products = list_products,
        inventory = inventory,
        myProducts = result
    })
end)

RegisterNetEvent('lg: updatePlayeruwuMarket')
AddEventHandler('lg: updatePlayeruwuMarket', function()
    TriggerServerEvent('lg: loadPlayeruwuMarket')
end)


RegisterNetEvent('lg: updateuwuMarket')
AddEventHandler('lg: updateuwuMarket', function()
    TriggerServerEvent('lg: loaduwuMarket')
end)

RegisterNetEvent('lg: uwumarketNotify')
AddEventHandler('lg: uwumarketNotify', function(color, Notify)
    SendMarketNUI({
        Notify = Notify,
        color = color
    })
end)

RegisterNetEvent('lg: uwumarketRefused')
AddEventHandler('lg: uwumarketRefused', function()
    SendMarketNUI({
        Refused = true
    })
end)

RegisterNUICallback('loaduwuAnuncios', function(data, cb)
    TriggerServerEvent('lg: loaduwuMarket')

    cb('ok')
end)

RegisterNUICallback('loadMyAnunciosuwu', function(data, cb)
    TriggerServerEvent('lg: loadPlayeruwuMarket')

    cb('ok')
end)

RegisterNUICallback('anunciarItemuwu', function(data, cb)
    TriggerServerEvent('lg: advertiseItemuwu', data)

    cb('ok')
end)

RegisterNUICallback('buyItemuwu', function(data, cb)
    TriggerServerEvent('lg: buyItemuwuuwu', data)
    cb('ok')
end)

RegisterNUICallback('removeItem', function(data, cb)
    TriggerServerEvent('lg: removeItemuwu', data)
    cb('ok')
end)

RegisterNUICallback('sendNotify', function(data, cb)
    TriggerEvent('lg: uwumarketNotify', data.color, data.Notify)

    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)

    cb('ok')
end)


-- Citizen.CreateThread(function()
-- 	for k,v in pairs(Config.marketlocation) do 
--         exports.ox_target:addBoxZone({
--             coords = vec3(v.x, v.y, v.z+1.1),
--             size = vec3(1.5, 1.5, 1.5),
--             rotation = 45,
--             debug = drawZones,
--             options = {
--                 {
--                     name = 'Market',
--                     event = 'ox:uwumarket',
--                     icon = 'fa-solid fa-cart-shopping',
--                     label = 'Market',
--                 }
--             }
--         })
--     end
-- end)




RegisterNetEvent("ox:uwumarket")
AddEventHandler("ox:uwumarket", function()
	ExecuteCommand('asdfghjkl;sfsdfsdfzxcvnads23adfghuwu')
end)