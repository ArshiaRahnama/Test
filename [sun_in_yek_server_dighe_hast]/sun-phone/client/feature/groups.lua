-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local GroupCooldowns = {}
local GROUP_CD_MSG = 1500
local GROUP_CD_FETCH = 1500
local GROUP_CD_ACTION = 2000

local function CheckGroupCooldown(key, cdTime, notify)
    local now = GetGameTimer()
    local last = GroupCooldowns[key]
    if last and (now - last) < cdTime then
        if notify then
            local remain = math.ceil((cdTime - (now - last)) / 1000)
            TriggerEvent('sun-phone:client:sendNotifInternal', {
                type = 'Notification',
                from = Config.App.Message.Name,
                message = ('Lotfan %d sanie sabr konid'):format(remain)
            })
        end
        return false
    end
    GroupCooldowns[key] = now
    return true
end

RegisterNUICallback('create-group', function(body, cb)
    if not CheckGroupCooldown('create-group', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:CreateGroup', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('get-group-chat', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetGroupChat', function(res)
        cb(res or {})
    end, body)
end)

RegisterNUICallback('get-group-messages-older', function(body, cb)
    if not CheckGroupCooldown('older-' .. tostring(body and body.group_id or 0), GROUP_CD_FETCH, false) then
        return cb({ messages = {}, has_more = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:GetGroupMessagesOlder', function(res)
        cb(res or { messages = {}, has_more = false })
    end, body)
end)

RegisterNUICallback('send-group-message', function(body, cb)
    if not IsAllowToSendOrCall() then
        TriggerEvent('sun-phone:client:sendNotifInternal', {
            type = 'Notification',
            from = Config.App.Message.Name,
            message = Config.MsgSignalZone
        })
        cb({ ok = false })
        return
    end
    if not CheckGroupCooldown('send-' .. tostring(body and body.group_id or 0), GROUP_CD_MSG, false) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:SendGroupMessage', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('join-group-code', function(body, cb)
    if not CheckGroupCooldown('join-group-code', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:JoinGroupByCode', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-set-admin', function(body, cb)
    if not CheckGroupCooldown('group-set-admin', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:SetGroupAdmin', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-remove-member', function(body, cb)
    if not CheckGroupCooldown('group-remove-member', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:RemoveGroupMember', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-leave', function(body, cb)
    if not CheckGroupCooldown('group-leave', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:LeaveGroup', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-delete', function(body, cb)
    if not CheckGroupCooldown('group-delete', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:DeleteGroup', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-update', function(body, cb)
    if not CheckGroupCooldown('group-update', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:UpdateGroup', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNUICallback('group-regen-code', function(body, cb)
    if not CheckGroupCooldown('group-regen-code', GROUP_CD_ACTION, true) then
        return cb({ ok = false })
    end

    ESX.TriggerServerCallback('sun-phone:server:RegenGroupCode', function(res)
        cb(res or { ok = false })
    end, body)
end)

RegisterNetEvent('sun-phone:client:groupMessage', function(data)
    SendNUIMessage({ event = 'sun-phone', groupMessage = data })
end)

RegisterNetEvent('sun-phone:client:groupUpdated', function(data)
    SendNUIMessage({ event = 'sun-phone', groupUpdated = data })
end)
