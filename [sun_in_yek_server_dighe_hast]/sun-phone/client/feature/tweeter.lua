-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('sun-phone:client:sendNotifTweeter', function(message)
    if not ESX.DoesHaveItem2('phone', 1) then return end

    local mode = (Profile and Profile.tweeter_notif) or 'all'
    if mode == 'off' then return end

    local silent = mode ~= 'all'
    local text = message and message.message or "Post jadid montasher shod!"

    if PhoneData.isOpen then
        SendNUIMessage({
            event = 'sun-phone',
            notification = {
                type = "Notification",
                from = Config.App.Tweeter.Name,
                message = text,
                silent = silent
            },
        })
    else
        SendNUIMessage({
            event = 'sun-phone',
            outsideAdsNotif = {
                from = Config.App.Tweeter.Name,
                message = text,
                silent = silent
            },
        })
    end
end)

local TweeterCooldowns = {}
local TWEETER_CD_FETCH = 600
local TWEETER_CD_LIKE = 1200
local TWEETER_CD_ACTION = 3000

local function CheckTweeterCooldown(key, cdTime, notify)
    local now = GetGameTimer()
    local last = TweeterCooldowns[key]
    if last and (now - last) < cdTime then
        if notify then
            local remain = math.ceil((cdTime - (now - last)) / 1000)
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = Config.App.Tweeter.Name,
                message = ("Lotfan %d sanie sabr konid"):format(remain)
            })
        end
        return false
    end
    TweeterCooldowns[key] = now
    return true
end

RegisterNUICallback('can-review-tweets', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:CanReviewTweets', function(result)
        cb(result or { review = false, delete = false })
    end)
end)

RegisterNUICallback('get-tweets', function(body, cb)
    if not CheckTweeterCooldown('get-tweets', TWEETER_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetTweets', function(result)
        cb(result or { list = {}, liked = {}, count = 0 })
    end, body)
end)

RegisterNUICallback('get-pending-tweets', function(body, cb)
    if not CheckTweeterCooldown('get-pending-tweets', TWEETER_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetPendingTweets', function(result)
        cb(result or { list = {}, count = 0 })
    end, body)
end)

RegisterNUICallback('send-tweet', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Tweeter.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not CheckTweeterCooldown('send-tweet', TWEETER_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:SendTweet', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('approve-tweet', function(body, cb)
    if not CheckTweeterCooldown('review-tweet', TWEETER_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:ApproveTweet', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('decline-tweet', function(body, cb)
    if not CheckTweeterCooldown('review-tweet', TWEETER_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeclineTweet', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('delete-tweet', function(body, cb)
    if not CheckTweeterCooldown('delete-tweet', TWEETER_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeleteTweet', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('like-tweet', function(body, cb)
    local key = 'like-' .. tostring(body and body.id or 0)
    if not CheckTweeterCooldown(key, TWEETER_CD_LIKE, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:LikeTweet', function(result)
        cb(result)
    end, body)
end)
