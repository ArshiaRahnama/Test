-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local NewsCooldowns = {}
local NEWS_CD_FETCH = 600
local NEWS_CD_LIKE = 1200
local NEWS_CD_ACTION = 3000

local function CheckNewsCooldown(key, cdTime, notify)
    local now = GetGameTimer()
    local last = NewsCooldowns[key]
    if last and (now - last) < cdTime then
        if notify then
            local remain = math.ceil((cdTime - (now - last)) / 1000)
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = "News",
                message = ("Lotfan %d sanie sabr konid"):format(remain)
            })
        end
        return false
    end
    NewsCooldowns[key] = now
    return true
end

RegisterNetEvent('sun-phone:client:sendNotifNews', function(message)
    if not ESX.DoesHaveItem2('phone', 1) then return end

    local text = message and message.message or "Khabar jadid montasher shod!"

    SendNUIMessage({
        event = 'sun-phone',
        updateBadge = { type = 'news' }
    })

    if PhoneData.isOpen then
        SendNUIMessage({
            event = 'sun-phone',
            notification = {
                type = "Notification",
                from = "News",
                message = text,
                silent = false,
                force = true
            },
        })
    else
        SendNUIMessage({
            event = 'sun-phone',
            outsideAdsNotif = {
                from = "News",
                message = text,
                silent = false,
                force = true
            },
        })
    end
end)

RegisterNetEvent('sun-phone:client:newsUnread', function(count, title)
    if not ESX.DoesHaveItem2('phone', 1) then return end

    count = tonumber(count) or 0
    if count <= 0 then return end

    SendNUIMessage({
        event = 'sun-phone',
        updateBadge = { type = 'news', count = count }
    })

    local text = (title and title ~= '')
        and ('%d khabar dar nabodane shoma montasher shod: %s'):format(count, title)
        or ('%d khabar dar nabodane shoma montasher shod'):format(count)

    SendNUIMessage({
        event = 'sun-phone',
        outsideAdsNotif = {
            from = "News",
            message = text,
            silent = false,
            force = true
        },
    })
end)

CreateThread(function()
    while not ESX or not ESX.PlayerData do Wait(1000) end
    Wait(20000)
    TriggerServerEvent('sun-phone:server:RequestNewsUnread')
end)

RegisterNUICallback('news-seen', function(_, cb)
    TriggerServerEvent('sun-phone:server:MarkNewsSeen')
    cb(true)
end)

RegisterNUICallback('can-review-news', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:CanReviewNews', function(result)
        cb(result or { review = false, delete = false })
    end)
end)

RegisterNUICallback('get-news', function(body, cb)
    if not CheckNewsCooldown('get-news', NEWS_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetNews', function(result)
        cb(result or { list = {}, liked = {}, total = 0, has_more = false })
    end, body)
end)

RegisterNUICallback('get-pending-news', function(body, cb)
    if not CheckNewsCooldown('get-pending-news', NEWS_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetPendingNews', function(result)
        cb(result or { list = {}, total = 0, has_more = false })
    end, body)
end)

RegisterNUICallback('send-news', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "News",
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not CheckNewsCooldown('send-news', NEWS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:SendNews', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('approve-news', function(body, cb)
    if not CheckNewsCooldown('review-news', NEWS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:ApproveNews', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('decline-news', function(body, cb)
    if not CheckNewsCooldown('review-news', NEWS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeclineNews', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('delete-news', function(body, cb)
    if not CheckNewsCooldown('delete-news', NEWS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeleteNews', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('like-news', function(body, cb)
    local key = 'like-' .. tostring(body and body.id or 0)
    if not CheckNewsCooldown(key, NEWS_CD_LIKE, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:LikeNews', function(result)
        cb(result)
    end, body)
end)
