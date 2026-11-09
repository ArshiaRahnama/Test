-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Daily Lottery NUI bridge. All state lives server-side (cached in memory);
-- the phone just relays the two callbacks and forwards the once-a-day result
-- broadcast to the UI.

RegisterNUICallback('get-lottery', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetLottery', function(res)
        cb(res or {})
    end)
end)

RegisterNUICallback('buy-ticket', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:BuyTicket', function(res)
        cb(res or { ok = false, message = 'Khata dar darkhast' })
    end)
end)

-- Fired ONCE per day for the whole server when the draw runs. Feeds the app
-- (for the reveal animation, if it's open) and shows a winner notification so
-- everyone hears about it. Gated to phone owners.
RegisterNetEvent('sun-phone:client:lotteryResult', function(data)
    if not ESX.DoesHaveItem2('phone', 1) then return end

    SendNUIMessage({ event = 'sun-phone', lotteryResult = data })

    TriggerEvent('sun-phone:client:sendNotifInternal', {
        type = 'Notification',
        from = 'Bakht Azmaei',
        message = ('%s barande shod! $%s'):format(tostring(data and data.name), tostring(data and data.amount)),
    })
end)
