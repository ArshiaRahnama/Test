-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- ============================================================================
-- Camera / photo capture.
--
-- Capture mirrors the OLD phone (minimal cell-cam loop, no high-quality-photo
-- natives that CTD). We DON'T upload here:
--   • the server cannot reach the (.ir) upload center (PerformHttpRequest
--     returned status=0), but the player's CEF can;
--   • client-side PerformHttpRequest doesn't exist in this build.
-- So /TakePhoto just returns the captured image (base64) + the upload URL to
-- the NUI, and the React side uploads it via fetch FROM THE PHONE'S OWN NUI
-- (so the request originates from this resource, which is what the center
-- keys on). See web/src/utils/common.js -> captureAndUploadPhoto().
-- ============================================================================

local frontCam = false
local takePhoto = false

local function CellFrontCamActivate(activate)
    return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

local function DrawInstructionalText()
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName("~INPUT_FRONTEND_ACCEPT~ Take Photo | ~INPUT_FRONTEND_CANCEL~ Close | ~INPUT_VEH_HEADLIGHT~ Switch Camera")
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function RestorePhoneAfterCamera()
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    PhoneData.isOpen = true
    if PhoneData.CallData and PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_call_to_text')
    else
        DoPhoneAnimation('cellphone_text_in')
    end
    SetTimeout(250, function()
        newPhoneProp()
    end)
end

RegisterNUICallback('TakePhoto', function(_, cb)
    if not Config.UploadUrl or Config.UploadUrl == '' then
        ESX.Alert('', 'Camera not setup', 3000, 'error')
        return cb(false)
    end

    -- Stop the phone's animation-maintenance loop (animation.lua CheckAnimLoop)
    -- so it doesn't re-play 'cellphone_text_in' every 500ms and fight the
    -- cell-cam pose (the "camera keeps opening and closing"). Restarted by
    -- RestorePhoneAfterCamera -> DoPhoneAnimation.
    if PhoneData and PhoneData.AnimationData then
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    CreateMobilePhone(4)
    CellCamActivate(true, true)
    takePhoto = true
    frontCam = false

    while takePhoto do
        if IsControlJustPressed(0, 74) or IsControlJustPressed(1, 74) then
            frontCam = not frontCam
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then       -- CANCEL  (Backspace / Esc)
            takePhoto = false
            frontCam = false
            CellFrontCamActivate(frontCam)
            DestroyMobilePhone()
            CellCamActivate(false, false)
            RestorePhoneAfterCamera()
            cb(false)
            break
        elseif IsControlJustPressed(1, 176) then       -- CAPTURE  (Enter)
            takePhoto = false

            -- Wipe the on-screen guide + HUD BEFORE the shot so none of it is
            -- baked into the photo. A couple of clean frames render first so
            -- the help box (which lingers a few frames) is fully gone.
            ClearAllHelpMessages()
            for _ = 1, 2 do
                HideHudComponentThisFrame(7)
                HideHudComponentThisFrame(8)
                HideHudComponentThisFrame(9)
                HideHudComponentThisFrame(6)
                HideHudComponentThisFrame(19)
                HideHudAndRadarThisFrame()
                Wait(0)
            end

            -- JPG + quality instead of PNG: a PNG screenshot at high
            -- resolutions is many MB and fills the upload center. The NUI
            -- downsizes further before upload (common.js downscaleImage).
            exports['screenshot-basic']:requestScreenshot({ encoding = 'jpg', quality = 0 }, function(dataUri)
                frontCam = false
                CellFrontCamActivate(frontCam)
                DestroyMobilePhone()
                CellCamActivate(false, false)
                RestorePhoneAfterCamera()
                if not dataUri or dataUri == '' then
                    cb(false)
                    return
                end
                -- Hand the raw image + URL to the NUI; React uploads it from the
                -- phone's own origin (the server can't reach the center).
                cb({ image = dataUri, uploadUrl = tostring(Config.UploadUrl) })
            end)
            break
        end
        DrawInstructionalText()
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
        EnableAllControlActions(0)
        -- Re-block the pause menu AFTER EnableAllControlActions so Escape only
        -- cancels the camera (control 177) and never opens the GTA map — the
        -- phone's InputControlLoop keeps running (isOpen stays true here) but
        -- this thread's EnableAll would otherwise re-arm the pause keys.
        DisableControlAction(0, 199, true)
        DisableControlAction(0, 200, true)
        DisableControlAction(0, 202, true)
        DisableControlAction(0, 322, true)
        Wait(0)
    end
end)

RegisterNUICallback('ReopenPhone', function(_, cb)
    RestorePhoneAfterCamera()
    cb('ok')
end)
