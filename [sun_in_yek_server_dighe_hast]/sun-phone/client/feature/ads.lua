-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local AdsCooldowns = {}
local ADS_CD_FETCH = 600
local ADS_CD_ACTION = 3000

local function CheckAdsCooldown(key, cdTime, notify)
    local now = GetGameTimer()
    local last = AdsCooldowns[key]
    if last and (now - last) < cdTime then
        if notify then
            local remain = math.ceil((cdTime - (now - last)) / 1000)
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = Config.App.Ads.Name,
                message = ("Lotfan %d sanie sabr konid"):format(remain)
            })
        end
        return false
    end
    AdsCooldowns[key] = now
    return true
end

local function CanApproveAds()
    return exports['sun-society']:doesHavePerm('adApprove') and true or false
end

local function CanDeleteAds()
    return exports['sun-society']:doesHavePerm('adDelete') and true or false
end

RegisterNUICallback('get-ads', function(body, cb)
    if not CheckAdsCooldown('get-ads', ADS_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetAds', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('get-pending-ads', function(body, cb)
    if not CanApproveAds() then
        return cb({})
    end

    if not CheckAdsCooldown('get-pending-ads', ADS_CD_FETCH, false) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:GetPendingAds', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('is-weazel-job', function(_, cb)
    cb({ approve = CanApproveAds(), delete = CanDeleteAds() })
end)

RegisterNUICallback('approve-ad', function(body, cb)
    if not CanApproveAds() then
        return cb(false)
    end

    if not CheckAdsCooldown('review-ad', ADS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:ApproveAd', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('decline-ad', function(body, cb)
    if not CanApproveAds() then
        return cb(false)
    end

    if not CheckAdsCooldown('review-ad', ADS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeclineAd', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('delete-ad', function(body, cb)
    if not CanDeleteAds() then
        return cb(false)
    end

    if not CheckAdsCooldown('delete-ad', ADS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:DeleteAd', function(result)
        cb(result)
    end, body)
end)

RegisterNUICallback('send-ads', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Ads.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not CheckAdsCooldown('send-ads', ADS_CD_ACTION, true) then
        return cb(false)
    end

    ESX.TriggerServerCallback('sun-phone:server:SendAds', function(isOk)
        cb(isOk)
    end, body)
end)
