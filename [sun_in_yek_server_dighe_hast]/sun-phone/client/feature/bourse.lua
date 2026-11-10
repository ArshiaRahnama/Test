-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Bourse (stock market) NUI bridge. The phone owns NO market logic — every
-- callback just relays to the server (server/feature/bourse.lua), which runs
-- the price engine and holds the portfolios.

RegisterNUICallback('get-stocks', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetStocks', function(res)
        cb(res or { stocks = {}, bank = 0 })
    end)
end)

RegisterNUICallback('get-stock', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetStock', function(res)
        cb(res or {})
    end, body)
end)

RegisterNUICallback('get-portfolio', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetPortfolio', function(res)
        cb(res or { holdings = {}, bank = 0 })
    end)
end)

RegisterNUICallback('buy-stock', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:BuyStock', function(res)
        cb(res or { ok = false, message = 'Request failed' })
    end, body)
end)

RegisterNUICallback('sell-stock', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:SellStock', function(res)
        cb(res or { ok = false, message = 'Request failed' })
    end, body)
end)
