-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('new-or-continue-chat', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:StartOrContinueChatting', function(chatting)
        cb(chatting)
    end, body)
end)

RegisterNUICallback('get-chats', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetChats', function(chats)
        cb(chats)
    end)
end)

RegisterNUICallback('get-chatting', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetChatting', function(chatting)
        cb(chatting)
    end, body)
end)

RegisterNUICallback('get-chatting-older', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetChattingOlder', function(page)
        cb(page)
    end, body)
end)

local SmsCooldowns = {}
local SMS_COOLDOWN_MS = 1500
local LocationShareCooldowns = {}
local LOCATION_SHARE_COOLDOWN_MS = 30000

RegisterNUICallback('send-chatting', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Message.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    local key = tostring(body.to_identifier or body.phone_number or '')
    local nowMs = GetGameTimer()

    local isLocationShare = type(body.media) == 'string' and body.media:find('"type":"location"', 1, true) ~= nil
    if isLocationShare then
        local lastLoc = LocationShareCooldowns[key]
        if lastLoc and (nowMs - lastLoc) < LOCATION_SHARE_COOLDOWN_MS then
            local remain = math.ceil((LOCATION_SHARE_COOLDOWN_MS - (nowMs - lastLoc)) / 1000)
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = Config.App.Message.Name,
                message = ("Please wait %ds before sharing location again"):format(remain)
            })
            cb(false)
            return
        end
        LocationShareCooldowns[key] = nowMs
    end

    local last = SmsCooldowns[key]
    if last and (nowMs - last) < SMS_COOLDOWN_MS then
        cb(false)
        return
    end
    SmsCooldowns[key] = nowMs

    ESX.TriggerServerCallback('sun-phone:server:SendChatting', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNetEvent('sun-phone:client:UpdateMessages')
AddEventHandler('sun-phone:client:UpdateMessages', function(message, phoneNumber)
    SendNUIMessage({
        action = 'update-message',
        data = {
            phone_number = phoneNumber,
            message = message
        }
    })
end)

RegisterNetEvent('sun-phone:client:RefreshChats')
AddEventHandler('sun-phone:client:RefreshChats', function()
    SendNUIMessage({
        action = 'refresh-chats'
    })
end)