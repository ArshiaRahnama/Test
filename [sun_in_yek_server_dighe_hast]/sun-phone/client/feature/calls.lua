-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local CallCooldowns = {}
local CALL_COOLDOWN_MS = 5000

local function GenerateCallId(caller, target)
    local CallId = math.ceil(((tonumber(caller) + tonumber(target)) / 100 * 1))
    return CallId
end

RegisterNUICallback('start-call', function(body, cb)
    if PhoneData.CallData.InCall then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "Phone",
            message = "You're in a call!"
        })
        cb(false)
        return
    end

    if not IsAllowToSendOrCall() then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = Config.App.Phone.Name,
            message = Config.MsgSignalZone
        })
        cb(false)
        return
    end

    local targetKey = tostring(body.to_phone_number)
    local nowMs = GetGameTimer()
    local lastCall = CallCooldowns[targetKey]
    if lastCall and (nowMs - lastCall) < CALL_COOLDOWN_MS then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification",
            from = "Phone",
            message = "Please wait before calling again"
        })
        cb(false)
        return
    end
    CallCooldowns[targetKey] = nowMs

    local callId = GenerateCallId(Profile.phone_number, body.to_phone_number)
    body.call_id = callId
    body.is_anonim = Profile.is_anonim
    body.is_service_call = body.is_service_call or false

    ESX.TriggerServerCallback('sun-phone:server:StartCall', function(res)
        if not res.is_valid then
            PlayBusyTone()
            TriggerEvent("sun-phone:client:sendNotifInternal", {
                type = "Notification",
                from = "Phone",
                message = res.message
            })
            cb(false)
            return
        end
        
        HelperNumber = nil
        PhoneData.CallData.AnsweredCall = false
        PhoneData.CallData.InCall = true
        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        PhoneData.CallData.CallId = callId
        PhoneData.CallData.RingSeq = (PhoneData.CallData.RingSeq or 0) + 1
        PhoneData.CallData.RingToken = PhoneData.CallData.RingSeq
        local myRingToken = PhoneData.CallData.RingToken
        cb(res)

        StartCallerDial()

        local RepeatCount = 0
        for _ = 1, Config.CallRepeats + 1, 1 do
            if PhoneData.CallData.RingToken ~= myRingToken then
                break
            end
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    if PhoneData.CallData.InCall then
                        RepeatCount = RepeatCount + 1
                        if RepeatCount > 1 then
                            StartCallerDial()
                        end
                    else
                        StopCallerDial()
                        break
                    end
                    Wait(Config.RepeatTimeout)
                else
                    PhoneData.CallData.CallId = nil
                    PhoneData.CallData.InCall = false
                    PhoneData.CallData.RingToken = nil
                    StopCallerDial()

                    SendNUIMessage({
                        event = 'sun-phone',
                        closeCall = {
                            type = "CLOSE_CALL",
                        },
                    })

                    TriggerEvent("sun-phone:client:sendNotifInternal", {
                        type = "Notification",
                        from = "Phone",
                        message = "Call not answered"
                    })

                    ESX.TriggerServerCallback('sun-phone:server:CancelCall', function(isOk)
                    end, { to_source = res.to_source })
                    break
                end
            end
        end
    end, body)
end)

RegisterNUICallback('cancel-call', function(body, cb)
    StopCallerDial()
    ESX.TriggerServerCallback('sun-phone:server:CancelCall', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('decline-call', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:DeclineCall', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('end-call', function(body, cb)
    ESX.TriggerServerCallback('sun-phone:server:EndCall', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('accept-call', function(body, cb)
    if PhoneData.isOpen then
        DoPhoneAnimation('cellphone_text_to_call')
    else
        DoPhoneAnimation('cellphone_call_listen_base')
    end

    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = true
    ESX.TriggerServerCallback('sun-phone:server:AcceptCall', function(isOk)
        cb(isOk)
    end, body)
end)

RegisterNUICallback('get-call-histories', function(_, cb)
    ESX.TriggerServerCallback('sun-phone:server:GetCallHistories', function(histories)
        cb(histories)
    end)
end)

-- ============================================================================
-- Client export: Call(data)
-- ----------------------------------------------------------------------------
-- Lets external resources start an outgoing call by phone number, e.g. the
-- taxi / mechanic job systems which call exports['sun-phone']:Call({ number,
-- name }) to connect a requester and a driver once a request is accepted.
-- This is the sun-phone equivalent of the old exports['sunset_phone']:Call.
-- It mirrors the NUI 'start-call' path exactly (same server callback, same
-- ringtone/timeout loop, same pma-voice numeric call_id) so behaviour and
-- audio are identical to dialling from the keypad.
-- ============================================================================
local function InitiateCallTo(number, isHelper)
    if not number then return false end
    if PhoneData.CallData.InCall then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification", from = "Phone", message = "You're in a call!"
        })
        return false
    end
    if not Profile or not Profile.phone_number then
        local p = promise.new()
        InitializePhoneData(function()
            p:resolve()
        end)
        Citizen.Await(p)
    end
    if not Profile or not Profile.phone_number then
        TriggerEvent("sun-phone:client:sendNotifInternal", {
            type = "Notification", from = "Phone", message = "Phone data not loaded!"
        })
        return false
    end

    local body = {
        to_phone_number = tostring(number),
        from_phone_number = Profile.phone_number,
        -- Identify the caller to the helper exactly like a normal call (name if
        -- saved, else the phone number, plus the caller's avatar). Helper calls
        -- used to force is_anonim = true, which is why every caller showed up as
        -- "Anonim" on the helper's phone — there is no anonymous feature here.
        from_avatar = Profile.avatar or '',
        is_anonim = Profile.is_anonim,
        is_service_call = isHelper and true or false,
        is_helper_call = isHelper and true or false,
    }
    body.call_id = GenerateCallId(Profile.phone_number, body.to_phone_number)

    ESX.TriggerServerCallback('sun-phone:server:StartCall', function(res)
        if not res or not res.is_valid then
            if res and res.message then
                TriggerEvent("sun-phone:client:sendNotifInternal", {
                    type = "Notification", from = "Phone", message = res.message
                })
            end
            return
        end

        HelperNumber = isHelper and tostring(number) or nil
        PhoneData.CallData.AnsweredCall = false
        PhoneData.CallData.InCall = true
        PhoneData.CallData.CallId = body.call_id
        PhoneData.CallData.RingSeq = (PhoneData.CallData.RingSeq or 0) + 1
        PhoneData.CallData.RingToken = PhoneData.CallData.RingSeq
        local myRingToken = PhoneData.CallData.RingToken
        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        -- Caller ringback tone (cleared on answer/cancel/timeout/end).
        StartCallerDial()

        local RepeatCount = 0
        for _ = 1, Config.CallRepeats + 1, 1 do
            if PhoneData.CallData.RingToken ~= myRingToken then
                break
            end
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    if PhoneData.CallData.InCall then
                        RepeatCount = RepeatCount + 1
                        if RepeatCount > 1 then
                            StartCallerDial()
                        end
                    else
                        StopCallerDial()
                        break
                    end
                    Wait(Config.RepeatTimeout)
                else
                    PhoneData.CallData.CallId = nil
                    PhoneData.CallData.InCall = false
                    PhoneData.CallData.RingToken = nil
                    StopCallerDial()
                    SendNUIMessage({
                        event = 'sun-phone',
                        closeCall = {
                            type = "CLOSE_CALL",
                        },
                    })
                    TriggerEvent("sun-phone:client:sendNotifInternal", {
                        type = "Notification", from = "Phone", message = "Call not answered"
                    })
                    ESX.TriggerServerCallback('sun-phone:server:CancelCall', function() end, { to_source = res.to_source })
                    break
                end
            end
        end
    end, body)

    return true
end

-- Accepts either a table { number = '...', name = '...' } (the shape the
-- taxi/mechanic systems use) or a plain number/string.
exports('Call', function(data)
    local number = (type(data) == 'table') and data.number or data
    return InitiateCallTo(number)
end)

RegisterNetEvent('sunset_phone:callHelper')
AddEventHandler('sunset_phone:callHelper', function(number, name)
    InitiateCallTo(number, true)
end)

RegisterNetEvent('sunset_phone:CopyNumber')
AddEventHandler('sunset_phone:CopyNumber', function()
    local num = Profile and Profile.phone_number
    if not num or tostring(num) == '' then return end
    exports['esx_carjob']:SetClipboard(tostring(num))
    ESX.Alert('OK', 'Copy shod!', 5000, 'success')
end)

HelperNumber = nil

function RateHelperMenu(number)
    if not number then return end
    local ratePending = true
    local elements = {
        {label = '1', value = '1'},
        {label = '2', value = '2'},
        {label = '3', value = '3', selected = true},
        {label = '4', value = '4'},
        {label = '5', value = '5'},
    }
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'rate', {
        title    = ' ',
        align    = 'center',
        question = 'لطفا میزان رضایت خود را از پاسخ دهنده مشخص کنید',
        elements = elements
    }, function(data, menu)
        ratePending = false
        menu.close()
        ESX.TriggerServerEvent('helper:rate', number, tonumber(data.current.value))
        ESX.Alert('', 'Ba tashakor az sherkat shoma dar nazar sanji!', 5000, 'error')
    end, nil, nil, function()
        if ratePending then
            ESX.TriggerServerEvent('helper:rate', number, 3, true)
        end
    end)
end
