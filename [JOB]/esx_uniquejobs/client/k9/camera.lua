-- variables --
local fov_max, fov_min, zoomspeed = 70.0, 1.0, 5.0
local fov, curZoom = (fov_max+fov_min)*0.5, 1.0
local left, right, up, down = 30.0, 30.0, 30.0, 30.0

local lang, camera, camcontrols = CFG.LANG, CFG.SETTINGS.CAMERA, CFG.CONTROLS.cam

-- functions --
local function TABLET()
    local coords = GetEntityCoords(cache.ped)
    PlayAnimation(cache.ped, "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 51)
    local obj = CreateObject("prop_cs_tablet_02", coords, true, false)
    AttachEntityToEntity(obj, cache.ped, GetPedBoneIndex(cache.ped, 28422), 
        -0.05, 0.0, 0.0, 0.0, 0.0, 0.0,
        true, true, false, true, 1, true
    )

    CreateThread(function()
        while true do
            if not DoesEntityExist(dog_ent) or not usingCamera or IsEntityDead(cache.ped) then
                Wait(1000)
                ClearPedTasks(cache.ped)
                DeleteObject(obj)
                break
            end
            Wait(0)
        end
    end)
end

function MOUNT_CAMERA()
    if not DoesEntityExist(dog_ent) or IsEntityDead(dog_ent) then return end

    if not action.hasCamera then
        if camera.item then
            local hasItem = lib.callback.await('sh-k9:CB:HAS_ITEM', false, camera.item)
            if not hasItem then 
                if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
                    if CORE.Shared.Items[camera.item] then
                        return Notify(string.format(lang.missing_item, CORE.Shared.Items[camera.item].label), 'error', 4000) 
                    else
                        return Notify(string.format(lang.missing_item, camera.item), 'error', 4000) 
                    end
                else
                    return Notify(string.format(lang.missing_item, camera.item), 'error', 4000) 
                end
            end
        end
    end
    
    --[[ local obj = CreateObject(`prop_ing_camera_01`, GetEntityCoords(dog_ent), true, false)
    AttachEntityToEntity(obj, dog_ent, GetPedBoneIndex(dog_ent, 39317), -- 
        -0.1, 0.0, -0.2, -- up/down, left/right, front/back
        30.0, 60.0, 80.0, -- rot
        true, true, false, true, 1, true
    )
    Wait(2500)
    DeleteObject(obj) ]]

    if #(GetEntityCoords(dog_ent) - GetEntityCoords(cache.ped)) > 1.5 then
        return Notify(lang.dog_not_close, 'error', 3500)
    end

    PlayAnimation(cache.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1)
    SetEntityHeadingLookAt(ped, dog_ent) 
    SetEntityHeadingLookAt(dog_ent, cache.ped) 
    Wait(2000)
    ClearPedTasks(cache.ped)

    action.hasCamera = not action.hasCamera
    if action.hasCamera then 
        if camera.item then TriggerServerEvent('sh-k9:sv:RemoveItem', camera.item) end
        Notify(lang.camera_mounted, 'success', 3500) 
    else
        if camera.item then TriggerServerEvent('sh-k9:sv:AddItem', camera.item) end
        Notify(lang.camera_removed, 'success', 3500)
    end
end

function DOG_CAMERA()
    if not DoesEntityExist(dog_ent) then return end
    if not action.hasCamera then return Notify(lang.mount_first, 'error', 3500) end

    local cameraScaleform = Scaleforms.LoadMovie("TRAFFIC_CAM")
    local cameraScaleform2 = Scaleforms.LoadMovie("DRONE_CAM")
    Wait(500)
    Scaleforms.PopVoid(cameraScaleform, "PLAY_CAM_MOVIE")

    action.usingCamera = not action.usingCamera
    if action.usingCamera then 
        ESX.UI.Menu.CloseAll()
        TABLET() 
    end

    while action.usingCamera do
        Wait(0)

        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam, dog_ent, 0.0, 0.5, -0.1, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(dog_ent))
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, 1, 0)

        local startRot = GetCamRot(cam, 2)
        local maxLeft = startRot.z + left
        local maxRight = startRot.z - right
        local maxUp = startRot.x + up
        local maxDown = startRot.x - down

        while action.usingCamera do
            if IsEntityDead(cache.ped) then action.usingCamera = true end

            if IsControlJustPressed(1, camcontrols.cancel) then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                OPEN_K9_MENU()
                action.usingCamera = false
            end

            local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
            local rotation = GetCamRot(cam, 2)
            local rotX = rotation.x
            if IsControlPressed(0, camcontrols.up) then -- UP
                if rotation.x < maxUp then
                    rotX = rotation.x + 0.5
                end
            elseif IsControlPressed(0, camcontrols.down) then -- DOWN
                if rotation.x > maxDown then
                    rotX = rotation.x - 0.5
                end
            end
            SetCamRot(cam, rotX, 0.0, GetEntityHeading(dog_ent))

            -- DATE IN RIGHT DOWN CORNER
            Scaleforms.PopMulti(cameraScaleform, "SET_CAM_DATE", GetClockDayOfWeek(), GetClockHours() + 0.0, GetClockMinutes() + 0.0)
                
                -- COMPAS
            Scaleforms.PopBool(cameraScaleform2, 'SET_HEADING_METER_IS_VISIBLE', true)
            Scaleforms.PopFloat(cameraScaleform2, 'SET_HEADING', GetEntityHeading(dog_ent))
        
            DrawScaleformMovieFullscreen(cameraScaleform, 255, 255, 255, 255)
            DrawScaleformMovieFullscreen(cameraScaleform2, 255, 255, 255, 255)

            HANDLE_ZOOM(cam)
            SetTimecycleModifier("CAMERA_BW")
            SetTimecycleModifierStrength(1.0)

            DisableControls()
            Wait(0)
        end

        ClearTimecycleModifier()
        fov = (fov_max+fov_min)*0.5
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        SetNightvision(false)
        SetSeethrough(false)
        ClearFocus()

        Scaleforms.UnloadMovie(cameraScaleform)
        Scaleforms.UnloadMovie(cameraScaleform2)
    end
end

function HANDLE_ZOOM(cam)
    if IsControlJustPressed(0, camcontrols.zoomUp) then
        fov = math.max(fov - zoomspeed, fov_min)
    end
    if IsControlJustPressed(0, camcontrols.zoomDown) then
        fov = math.min(fov + zoomspeed, fov_max)
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov-current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
end
