-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('get-services', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetServices', function(services)
        local list = {}
        for i, v in pairs(services) do
            list[#list + 1] = {
                logo = v.avatar,
                service = v.name,
                job = v.job,
                number = v.number,
                type = 'SERVICE',
            }
        end
        cb({ list = list, reports = {}})
    end)
end)

local ServiceCooldowns = {}
local SERVICE_CD_MS = { [10000000002] = 30000 }
local SERVICE_CD_DEFAULT = 60000

local function CheckServiceCooldown(number)
    local key = tostring(number or '')
    local now = GetGameTimer()
    local cdTime = SERVICE_CD_MS[tonumber(number) or 0] or SERVICE_CD_DEFAULT
    local last = ServiceCooldowns[key]
    if last and (now - last) < cdTime then
        local remain = math.ceil((cdTime - (now - last)) / 1000)
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Services.Name,
            message = ("Please wait %ds before sending another request"):format(remain)
        })
        return false
    end
    ServiceCooldowns[key] = now
    return true
end

RegisterNUICallback('send-message-service', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Services.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not CheckServiceCooldown(body.number) then
        cb(false)
        return
    end

    ESX.TriggerServerCallback('sun-phone:server:SendServiceMessage', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('solved-message-service', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:SolvedMessageService', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('send-location-service', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Services.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    if not CheckServiceCooldown(body.number) then
        cb(false)
        return
    end

    local n = tonumber(body.number)
    if n == 10000000004 or n == 10000000003 then
        if ClosePhoneFully then ClosePhoneFully() end
    end

    ESX.TriggerServerCallback('sun-phone:server:SendServiceLocation', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNetEvent('sun-phone:client:SetWaypoint')
AddEventHandler('sun-phone:client:SetWaypoint', function(x, y)
    SetNewWaypoint(x, y)
end)

RegisterNetEvent('sun-phone:client:ReceiveServiceMessage')
AddEventHandler('sun-phone:client:ReceiveServiceMessage', function(data)
    SendNUIMessage({
        action = 'receive-service-message',
        data = data
    })
end)

RegisterNUICallback('set-waypoint', function(body, cb)
    if body.x and body.y then
        SetNewWaypoint(body.x, body.y)
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "GPS",
            message = "Waypoint set!"
        })
    end
    cb(true)
end)