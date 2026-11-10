-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local tick = 1

function createScaleform(scaleformName)
    local scaleform = RequestScaleformMovie(scaleformName)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    local scaleformTable = {}
    t1 = {
        __index = function(_, indexed)
            return function(_, ...)
                local args = {...}
                local expectingReturn = args[1]
                table.remove(args, 1)
                BeginScaleformMovieMethod(scaleform, indexed)
                for i,v in pairs(args) do
                    if type(v) == "string" then
                        ScaleformMovieMethodAddParamTextureNameString(v)
                    elseif type(v) == "number" then
                        if math.type(v) == "float" then
                            ScaleformMovieMethodAddParamFloat(v)
                        else
                            ScaleformMovieMethodAddParamInt(v)
                        end
                    elseif type(v) == "boolean" then
                        ScaleformMovieMethodAddParamBool(v)
                    end
                end
                local value = EndScaleformMovieMethodReturnValue()
                if expectingReturn then
                    while not IsScaleformMovieMethodReturnValueReady(value) do
                        Wait(0)
                    end
                    local returnString = GetScaleformMovieMethodReturnValueString(value)
                    local returnInt = GetScaleformMovieMethodReturnValueInt(value)
                    local returnBool = GetScaleformMovieMethodReturnValueBool(value)
                    EndScaleformMovieMethod()
                    if returnString ~= "" then
                        return returnString
                    end
                    if returnInt ~= 0 and not returnBool then
                        return returnInt
                    end
                    return returnBool
                end
            end
        end,
        __call = function(called, ms, r, g, b, a)
            local startScaleformTimer = GetGameTimer()
            CreateThread(function()
                repeat
                    Citizen.Wait(0)
                    DrawScaleformMovieFullscreen(scaleform, r or 255, g or 255, b or 255, a or 255)
                until GetGameTimer()-startScaleformTimer >= (ms or math.floor(2000*tick))
            end)
        end
    }
    setmetatable(scaleformTable, t1)
    return scaleformTable
end

function showRaceCountdown(time)
    local scaleform = createScaleform("COUNTDOWN")
    if time == 0 then
        scaleform:SET_MESSAGE(false, "GO")
    else
        scaleform:SET_MESSAGE(false, time)
    end
    scaleform(math.floor(1000*tick))
end

function showBigRaceMessage(bigMessage, smallMessage, ms)
    local scaleform = createScaleform("mp_big_message_freemode")
    scaleform:SHOW_SHARD_WASTED_MP_MESSAGE(false, bigMessage or "", smallMessage or "")
    scaleform(ms or math.floor(2000*tick))
end
RegisterNetEvent('sun-race:showRaceMessge', showBigRaceMessage)

function startPreview()
    local vehicle = cache.vehicle
    FreezeEntityPosition(vehicle, true)
    local forwardVector, rightVector, upVector, position = GetEntityMatrix(vehicle)
    local forwardCoords, rightCoords, upCoords = forwardVector*5, rightVector*3, upVector*2
    local cam1Coords, cam1Rot = (GetEntityCoords(vehicle)+forwardCoords+rightCoords+upCoords).xyz, (GetEntityRotation(vehicle)+vector3(-20,0,-210)).xyz
    local cam1 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cam1Coords.x, cam1Coords.y, cam1Coords.z, cam1Rot.x, cam1Rot.y, cam1Rot.z, GetGameplayCamFov() * 1.0)
    SetCamAffectsAiming(cam1, false)
    local forwardCoords, rightCoords, upCoords = forwardVector*3, rightVector*-1.5, upVector*0.5
    local cam2Coords, cam2Rot = (GetEntityCoords(vehicle)+forwardCoords+rightCoords+upCoords).xyz, (GetEntityRotation(vehicle)+vector3(-20,0,-150)).xyz
    local cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cam2Coords.x, cam2Coords.y, cam2Coords.z, cam2Rot.x, cam2Rot.y, cam2Rot.z, GetGameplayCamFov() * 1.0)
    SetCamAffectsAiming(cam2, false)
    local forwardCoords, rightCoords, upCoords = forwardVector*0, rightVector*-2, upVector*0
    local cam3Coords, cam3Rot = (GetEntityCoords(vehicle)+forwardCoords+rightCoords+upCoords).xyz, (GetEntityRotation(vehicle)+vector3(0,0,-100)).xyz
    local cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cam3Coords.x, cam3Coords.y, cam3Coords.z, cam3Rot.x, cam3Rot.y, cam3Rot.z, GetGameplayCamFov() * 1.0)
    SetCamAffectsAiming(cam3, false)
    SetCamActiveWithInterp(cam2, cam1, math.floor(3700*tick))
    RenderScriptCams(true, false, 0, true, false)
    Wait(math.floor(3700*tick))
    SetCamActive(cam3, true)
    RenderScriptCams(true, false, 0, true, false)
    local relRotate = GetEntityRotation(vehicle).xyz
    SetGameplayCamRelativeRotation(relRotate.x, relRotate.y, relRotate.z)
    SetGameplayCamRelativePitch(-10.0, 1.0)
    RenderScriptCams(false, true, math.floor(5000*tick), false, false)
    Wait(math.floor(5000*tick))
    isMovingCamera = false
    local lastSecond = GetGameTimer()
    local secondsElapsed = 3
    while secondsElapsed >= 0 do
        Wait(0)
        local dif = GetGameTimer()-lastSecond
        if dif > math.floor(1000*tick) then
            if secondsElapsed >= 1 then
                if secondsElapsed == 1 then
                    PlaySoundFrontend(-1, "Countdown_GO", "DLC_AW_Frontend_Sounds", true)
                end
                PlaySoundFrontend(-1, "Countdown_3", "DLC_AW_Frontend_Sounds", false)
            end
            lastSecond = GetGameTimer()
            showRaceCountdown(secondsElapsed)
            secondsElapsed = secondsElapsed-1
        end
    end
    FreezeEntityPosition(vehicle, false)
end