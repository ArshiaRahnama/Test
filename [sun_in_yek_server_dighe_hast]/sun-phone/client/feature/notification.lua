-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


local ActiveRingtones = {}
local RingtoneCheckThread = nil
local RINGTONE_MAX_MS = ((Config.CallRepeats or 5) + 1) * (Config.RepeatTimeout or 3000) + 5000
HasTempPhone = false

RegisterNetEvent('sun-phone:client:setTempPhone', function(state)
    HasTempPhone = state and true or false
end)

-- Resolve a ringtone name (ring1..ring4) to a URL xsound can actually load.
--
-- IMPORTANT: xsound plays audio inside its OWN NUI page, so URLs resolve
-- against the XSOUND resource, not this one. Pointing at
-- nui://sun-phone/... proved unreliable in CEF (cross-resource nui fetch),
-- which is why ringtones were silent. The proven approach (same as the old
-- phone) is to serve the audio from xsound itself. We copied ring1..ring4
-- (and call-sound) into xsound/html/sounds, so we reference them there.
-- Falls back to xsound's built-in 'zangkhor' ringtone if an unknown name
-- is passed (zangkhor ships with xsound, so there's always *some* ring).
-- URLs are relative to XSOUND's own NUI page (it's the resource that loads
-- the audio), so './sounds/x.mp3' = xsound/html/sounds/x.mp3. This is the
-- exact format the old phone used and is proven to work. We copied
-- ring1..ring4 into xsound/html/sounds; zangkhor ships with xsound as a
-- guaranteed fallback.
local RINGTONE_FILES = {
    ring1 = 'ring1.mp3',
    samsung = 'samsung.mp3',
    trevor = 'trevor.mp3',
    nokia = 'nokia.mp3',
}
local function GetRingtoneUrl(name)
    if name == 'silent' then return nil end
    local file = name and RINGTONE_FILES[name]
    if file then
        return ('./sounds/%s'):format(file)
    end
    return './sounds/zangkhor.mp3'
end

-- Caller's ringback ("calling…") tone — what the CALLER hears while waiting
-- for the other side to answer. phonecall.ogg ships with xsound.
-- GLOBAL (no `local`) so client/feature/calls.lua can start/stop the same
-- sound by the same id. Safe because these are only invoked at runtime,
-- long after every client file has loaded.
CALLER_DIAL_URL = './sounds/phonecall.mp3'
function GetCallerDialId()
    return 'phone_dialing_' .. GetPlayerServerId(PlayerId())
end

function StartCallerDial()
    exports['xsound']:Destroy(GetCallerDialId())
    exports['xsound']:PlayUrl(GetCallerDialId(), CALLER_DIAL_URL, 0.5)
end
function StopCallerDial()
    exports['xsound']:Destroy(GetCallerDialId())
end

function PlayBusyTone()
    local id = 'phone_dastres_' .. GetPlayerServerId(PlayerId())
    exports['xsound']:Destroy(id)
    exports['xsound']:PlayUrl(id, './sounds/dastres.mp3', 0.5)
end

local NEARBY_RING_RANGE = 15.0

local function StartRingtoneDistanceCheck()
    if RingtoneCheckThread then return end
    RingtoneCheckThread = true
    CreateThread(function()
        while next(ActiveRingtones) do
            Wait(500)
            local myCoords = GetEntityCoords(PlayerPedId())
            local now = GetGameTimer()
            for ringtoneId, data in pairs(ActiveRingtones) do
                local shouldStop = false
                if (now - (data.startTime or 0)) > RINGTONE_MAX_MS then
                    shouldStop = true
                else
                    local sourcePlayer = GetPlayerFromServerId(data.sourceServerId)
                    local sourcePed = sourcePlayer ~= -1 and GetPlayerPed(sourcePlayer) or 0
                    if sourcePed == 0 then
                        shouldStop = true
                    else
                        local distance = #(myCoords - GetEntityCoords(sourcePed))
                        if distance > NEARBY_RING_RANGE then
                            shouldStop = true
                        else
                            local baseVolume = data.baseVolume or 0.08
                            local volume = math.max(0.0, baseVolume - ((baseVolume / NEARBY_RING_RANGE) * distance))
                            exports['xsound']:setVolume(ringtoneId, volume)
                        end
                    end
                end
                if shouldStop then
                    exports['xsound']:Destroy(ringtoneId)
                    ActiveRingtones[ringtoneId] = nil
                end
            end
        end
        RingtoneCheckThread = nil
    end)
end

RegisterNetEvent('sun-phone:client:PlayRingtoneNearby', function(ringtoneId, ringtoneName, volume, sourceServerId)
    exports['xsound']:Destroy(ringtoneId)
    local ringtoneUrl = GetRingtoneUrl(ringtoneName)
    if not ringtoneUrl then return end
    ActiveRingtones[ringtoneId] = {
        sourceServerId = sourceServerId,
        ringtoneName = ringtoneName,
        baseVolume = volume,
        startTime = GetGameTimer()
    }

    -- Loop so nearby players keep hearing the ring until it's stopped
    -- (StopRingtoneNearby) or they walk out of range. The distance thread
    -- then fades the volume with the exact sun-tv falloff:
    --   volume = base - (base / range) * distance
    local startVolume = volume
    local sourcePlayer = GetPlayerFromServerId(sourceServerId)
    local sourcePed = sourcePlayer ~= -1 and GetPlayerPed(sourcePlayer) or 0
    if sourcePed ~= 0 then
        local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(sourcePed))
        startVolume = math.max(0.0, volume - ((volume / NEARBY_RING_RANGE) * distance))
    end
    exports['xsound']:PlayUrl(ringtoneId, ringtoneUrl, startVolume, true)

    StartRingtoneDistanceCheck()
end)

RegisterNetEvent('sun-phone:client:StopRingtoneNearby', function(ringtoneId, sourceServerId)
    exports['xsound']:Destroy(ringtoneId)
    if ActiveRingtones[ringtoneId] then
        ActiveRingtones[ringtoneId] = nil
    end
end)

-- Ringtone PREVIEW for the Settings "Test" button. Plays the chosen
-- ringtone locally (only this player hears it) for a few seconds so the
-- player can audition it before saving. Self-stops, and a fresh preview
-- cancels any previous one.
local previewRingtoneId = 'phone_ringtone_preview_' .. GetPlayerServerId(PlayerId())
local previewToken = 0
RegisterNUICallback('preview-ringtone', function(body, cb)
    local name = body and body.ringtone
    -- Stop any in-flight preview first
    exports['xsound']:Destroy(previewRingtoneId)
    previewToken = previewToken + 1
    local myToken = previewToken

    local previewUrl = GetRingtoneUrl(name)
    if not previewUrl then
        return cb({ ok = true })
    end

    exports['xsound']:PlayUrl(previewRingtoneId, previewUrl, 0.4, true)

    -- Auto-stop after 4s (unless another preview superseded this one)
    SetTimeout(4000, function()
        if myToken == previewToken then
            exports['xsound']:Destroy(previewRingtoneId)
        end
    end)

    cb({ ok = true })
end)

-- Stop preview explicitly (e.g. when the ringtone sheet closes)
RegisterNUICallback('stop-preview-ringtone', function(_, cb)
    previewToken = previewToken + 1
    exports['xsound']:Destroy(previewRingtoneId)
    cb({ ok = true })
end)


RegisterNetEvent('sun-phone:client:updateBadge', function(badgeType)
    SendNUIMessage({
        event = 'sun-phone',
        updateBadge = {
            type = badgeType
        },
    })
end)

RegisterNetEvent('sun-phone:client:sendNotifMessage', function(message)
    if ESX.DoesHaveItem2('phone', 1) then
        if PhoneData.isOpen then
            SendNUIMessage({
                event = 'sun-phone',
                notification = {
                    type = "New Message",
                    from = message.from,
                    message = message.message,
                    media = message.media,
                    from_identifier = message.from_identifier,
                    phone_number = message.phone_number,
                },
            })
            SendNUIMessage({
                event = 'sun-phone',
                updateBadge = { type = 'messages' },
            })
        else
            SendNUIMessage({
                event = 'sun-phone',
                outsideMessageNotif = {
                    from = message.from,
                    message = message.message or "New message!"
                },
            })
        end
    end
end)

RegisterNetEvent('sun-phone:client:sendNotifAds', function(message)
    if ESX.DoesHaveItem2('phone', 1) then
        if PhoneData.isOpen then
            SendNUIMessage({
                event = 'sun-phone',
                notification = {
                    type = "Notification",
                    from = "Ads",
                    message = message.message or "New ad posted!"
                },
            })
        else
            SendNUIMessage({
                event = 'sun-phone',
                outsideAdsNotif = {
                    from = "Ads",
                    message = message.message or "New ad posted!"
                },
            })
        end
        SendNUIMessage({
            event = 'sun-phone',
            updateBadge = { type = 'ads' },
        })
    end
end)


RegisterNetEvent('sun-phone:client:sendNotifEmail', function(message)
    if ESX.DoesHaveItem2('phone', 1) then
        CachedData.emails = nil
        if PhoneData.isOpen then
            SendNUIMessage({
                event = 'sun-phone',
                notification = {
                    type = "Notification",
                    from = message.from or "Email",
                    message = message.subject or message.message or "New email!"
                },
            })
        else
            ESX.Alert('', string.format("[Email] %s", message.subject or message.message or "New email!"), 5000, 'info')
        end
        SendNUIMessage({
            event = 'sun-phone',
            updateBadge = { type = 'emails' },
        })
    end
end)

RegisterNetEvent('sun-phone:client:sendNotifInternal', function(message)
    if ESX.DoesHaveItem2('phone', 1) then
        if PhoneData.isOpen then
            SendNUIMessage({
                event = 'sun-phone',
                notification = {
                    type = "Notification",
                    from = message.from,
                    message = message.message
                },
            })
        else
            ESX.Alert('', string.format("[%s] %s", message.from, message.message), 5000, 'info')
        end
    end
end)

RegisterNetEvent('sun-phone:client:sendNotifIncomingCall', function(message)
    if not (ESX.DoesHaveItem2('phone', 1) or HasTempPhone) then
        ESX.TriggerServerCallback('sun-phone:server:EndCall', function(isOk)
        end, { to_source = message.to_source })
        return
    end

    PhoneData.CallData.InCall = true
    PhoneData.CallData.CallId = message.call_id
    PhoneData.CallData.RingSeq = (PhoneData.CallData.RingSeq or 0) + 1
    PhoneData.CallData.RingToken = PhoneData.CallData.RingSeq
    local myRingToken = PhoneData.CallData.RingToken

    if ESX.DoesHaveItem2('phone', 1) or HasTempPhone then
        local ringtoneId = 'phone_ringtone_' .. GetPlayerServerId(PlayerId())
        -- The PHONE OWNER's own ringtone is now played reliably by the phone's
        -- NUI (IncomingCallNotificationComponent / the closed-phone popup) from
        -- the bundled /sounds/ringN.mp3 — xsound playback for the owner was
        -- removed because it depended on files being copied into
        -- xsound/html/sounds (unreliable → silent rings). We still BROADCAST
        -- the ring to NEARBY players via xsound below (bonus positional audio
        -- for bystanders); the owner no longer double-hears it.
        if (message.ringtone or 'ring1') ~= 'silent' then
            local nearbyPlayers = ESX.Game.GetPlayersToSend(10)
            local mySrc = GetPlayerServerId(PlayerId())
            for i = #nearbyPlayers, 1, -1 do
                if tonumber(nearbyPlayers[i]) == mySrc then
                    table.remove(nearbyPlayers, i)
                end
            end
            ESX.TriggerServerEvent('sun-phone:server:PlayRingtoneNearby', ringtoneId, message.ringtone or 'ring1', 0.08, nearbyPlayers)
        end

        if PhoneData.isOpen then
            SendNUIMessage({
                event = 'sun-phone',
                notification = {
                    type = 'Incoming Call',
                    ringtone = message.ringtone or 'ring1',
                    from = message.from,
                    photo = message.photo,
                    from_source = message.from_source,
                    to_source = message.to_source,
                    to_person_for_caller = message.to_person_for_caller,
                    to_photo_for_caller = message.to_photo_for_caller,
                    call_id = message.call_id
                },
            })
        else
            SendNUIMessage({
                event = 'sun-phone',
                outsideCallNotif = {
                    from = message.from,
                    ringtone = message.ringtone or 'ring1',
                    photo = message.photo,
                    message = message.message,
                    from_source = message.from_source,
                    to_source = message.to_source,
                    to_person_for_caller = message.to_person_for_caller,
                    to_photo_for_caller = message.to_photo_for_caller,
                    call_id = message.call_id
                },
            })
        end

        local RepeatCount = 0
        for _ = 1, Config.CallRepeats + 1, 1 do
            if PhoneData.CallData.RingToken ~= myRingToken then
                break
            end
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    if PhoneData.CallData.InCall then
                        RepeatCount = RepeatCount + 1
                        -- (ringtone is a looping xsound now — no per-tick sound)
                    else
                        break
                    end
                    Wait(Config.RepeatTimeout)
                else

                    local ringtoneId = 'phone_ringtone_' .. GetPlayerServerId(PlayerId())
                    exports['xsound']:Destroy(ringtoneId)
                    ESX.TriggerServerEvent('sun-phone:server:StopRingtoneNearby', ringtoneId)

                    PhoneData.CallData.CallId = nil
                    PhoneData.CallData.InCall = false
                    PhoneData.CallData.RingToken = nil

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

                    ESX.TriggerServerCallback('sun-phone:server:EndCall', function(isOk)
                    end, { to_source = message.to_source })
                    break
                end
            end
        end
    end
end)

local AdminDialSeq = 0

function StopAdminDialLoop()
    AdminDialSeq = AdminDialSeq + 1
end

RegisterNetEvent('sun-phone:client:sendNotifStartCall', function(message)
    if ESX.DoesHaveItem2('phone', 1) then
        SendNUIMessage({
            event = 'sun-phone',
            notification = {
                type = 'Calling...',
                to_person = message.to_person,
                photo = message.photo,
                from_source = message.from_source,
                to_source = message.to_source,
            },
        })
    end

    if message.play_dial then
        AdminDialSeq = AdminDialSeq + 1
        local myToken = AdminDialSeq
        CreateThread(function()
            for _ = 1, Config.CallRepeats + 1, 1 do
                if AdminDialSeq ~= myToken then break end
                StartCallerDial()
                Wait(Config.RepeatTimeout)
            end
            if AdminDialSeq == myToken then
                StopCallerDial()
            end
        end)
    end
end)

RegisterNetEvent('sun-phone:client:setInCall', function(message)
    local ringtoneId = 'phone_ringtone_' .. GetPlayerServerId(PlayerId())
    exports['xsound']:Destroy(ringtoneId)
    ESX.TriggerServerEvent('sun-phone:server:StopRingtoneNearby', ringtoneId)
    -- Call connected → stop the caller's ringback tone.
    StopAdminDialLoop()
    StopCallerDial()

    PhoneData.CallData.AnsweredCall = true
    PhoneData.CallData.InCall = true
    PhoneData.CallData.CallId = message.call_id
    exports['pma-voice']:addPlayerToCall(message.call_id)

    SendNUIMessage({
        event = 'sun-phone',
        notification = {
            type = "In Call",
            from = message.from,
            photo = message.photo,
            from_source = message.from_source,
            to_source = message.to_source,
            call_id = message.call_id
        },
    })
end)

function ResetCallState()
    local ringtoneId = 'phone_ringtone_' .. GetPlayerServerId(PlayerId())
    exports['xsound']:Destroy(ringtoneId)
    ESX.TriggerServerEvent('sun-phone:server:StopRingtoneNearby', ringtoneId)
    StopAdminDialLoop()
    StopCallerDial()

    local wasOnCall = PhoneData.CallData.InCall
    local wasAnswered = PhoneData.CallData.AnsweredCall
    local callId = PhoneData.CallData.CallId

    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.InCall = false
    PhoneData.CallData.CallId = nil
    PhoneData.CallData.RingToken = nil
    HasTempPhone = false

    if callId then
        exports['pma-voice']:removePlayerFromCall(callId)
    end

    if PhoneData.isOpen then
        if wasOnCall or (PhoneData.AnimationData.anim and PhoneData.AnimationData.anim ~= 'cellphone_text_in' and PhoneData.AnimationData.anim ~= 'cellphone_text_out') then
            DoPhoneAnimation('cellphone_text_in')
        end
    elseif PhoneData.AnimationData.lib then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    SendNUIMessage({
        event = 'sun-phone',
        closeCall = {
            type = "CLOSE_CALL",
        },
    })

    if HelperNumber then
        local rateNumber = HelperNumber
        HelperNumber = nil
        if wasAnswered and Profile and rateNumber ~= Profile.phone_number then
            RateHelperMenu(rateNumber)
        end
    end
end

RegisterNetEvent('sun-phone:client:closeCall', function()
    ResetCallState()
end)

RegisterNetEvent('sun-phone:client:closeCallSelf', function()
    ResetCallState()
end)
