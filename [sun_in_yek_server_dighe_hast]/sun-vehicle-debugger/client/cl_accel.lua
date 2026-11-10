-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local enabled = false

local MODE_ACCEL = 'accel'
local MODE_BRAKE = 'brake'
local MODE_HANDLING = 'handling'

local STATE_IDLE     = 0
local STATE_ARMED    = 1
local STATE_RUNNING  = 2
local STATE_DONE     = 3

local mode = MODE_ACCEL
local state = STATE_IDLE
local startMs = 0
local activeVeh = 0

local SPLIT_TARGETS = { 50, 100, 150, 200, 250, 260 }
local splits = {}
for _, s in ipairs(SPLIT_TARGETS) do splits[s] = nil end
local total = nil
local topSpeedKmh = 0.0
local prevGear = -1
local gearShifts = {}
local lastResultModel = ''
local lastResultMass = 0
local accelStartPosX, accelStartPosY = 0, 0
local accelDistanceM = 0.0

local brakeStartSpeed = 0
local brakeStartMs = 0
local brakeStartPosX, brakeStartPosY = 0, 0
local brakeStopMs = nil
local brakeStopDistance = nil
local brakeDecelPeak = 0
local prevSpeedMs = 0
local prevTickMs = 0

local accelBrakePhase = 0

local windLockSpeed = nil
local windLockAngleRad = nil

local handlingMaxLat = 0
local handlingMaxYaw = 0
local handlingMaxRoll = 0
local handlingSampleCount = 0
local handlingAvgGrip = 0
local handlingMinSpeed = 999
local handlingMaxSpeed = 0

local function drawText(x, y, text, scale, r, g, b)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, 255)
    SetTextOutline()
    SetTextDropShadow()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function modelName(veh)
    return GetDisplayNameFromVehicleModel(GetEntityModel(veh))
end

local function vehicleMass(veh)
    return GetVehicleHandlingFloat(veh, 'CHandlingData', 'fMass') or 0.0
end

local function vehicleHandlingF(veh, field)
    return GetVehicleHandlingFloat(veh, 'CHandlingData', field) or 0.0
end

local function vehicleHandlingI(veh, field)
    return GetVehicleHandlingInt(veh, 'CHandlingData', field) or 0
end

local function vehicleHandlingV(veh, field)
    local v = GetVehicleHandlingVector(veh, 'CHandlingData', field)
    if v then return v.x, v.y, v.z end
    return 0.0, 0.0, 0.0
end

local function resetAccel()
    state = STATE_IDLE
    startMs = 0
    for _, s in ipairs(SPLIT_TARGETS) do splits[s] = nil end
    total = nil
    topSpeedKmh = 0.0
    prevGear = -1
    gearShifts = {}
    activeVeh = 0
    accelBrakePhase = 0
    brakeStartSpeed = 0
    brakeStartMs = 0
    brakeStopMs = nil
    brakeStopDistance = nil
    brakeDecelPeak = 0
    accelStartPosX, accelStartPosY = 0, 0
    accelDistanceM = 0.0
end

local function resetBrake()
    state = STATE_IDLE
    brakeStartSpeed = 0
    brakeStartMs = 0
    brakeStopMs = nil
    brakeStopDistance = nil
    brakeDecelPeak = 0
    prevSpeedMs = 0
    activeVeh = 0
end

local function resetHandling()
    state = STATE_IDLE
    handlingMaxLat = 0
    handlingMaxYaw = 0
    handlingMaxRoll = 0
    handlingSampleCount = 0
    handlingAvgGrip = 0
    handlingMinSpeed = 999
    handlingMaxSpeed = 0
    startMs = 0
    activeVeh = 0
end

local function fmtSec(ms)
    if ms == nil then return '--' end
    return string.format('%.3fs', ms / 1000.0)
end

local function fmtDelta(a, b)
    if a == nil or b == nil then return '--' end
    return string.format('%.3fs', (b - a) / 1000.0)
end

local function savePartialAccel(reason)
    if state ~= STATE_RUNNING and state ~= STATE_DONE then
        print('[accel-hud] nothing to save (not measuring)')
        return false
    end
    local veh = activeVeh
    if veh == 0 or not DoesEntityExist(veh) then
        print('[accel-hud] vehicle gone')
        return false
    end
    lastResultModel = modelName(veh)
    lastResultMass = vehicleMass(veh)
    local pos = GetEntityCoords(veh)
    local dx = pos.x - accelStartPosX
    local dy = pos.y - accelStartPosY
    accelDistanceM = math.sqrt(dx*dx + dy*dy)
    state = STATE_DONE
    accelBrakePhase = 1
    prevSpeedMs = GetEntitySpeed(veh)
    prevTickMs = GetGameTimer()
    print(('[accel-hud] saved %s for %s (top=%dkm/h)'):format(reason or 'partial', lastResultModel, math.floor(topSpeedKmh + 0.5)))
    return true
end

local function saveBrake()
    local veh = activeVeh
    if veh == 0 or not DoesEntityExist(veh) then return end
    local model = modelName(veh)
    state = STATE_DONE
    print(('[accel-hud] brake test saved: %s  %dkm/h -> 0 in %.2fs / %.1fm'):format(
        model, math.floor(brakeStartSpeed + 0.5),
        (brakeStopMs or 0) / 1000.0, brakeStopDistance or 0))
end

local function saveHandling()
    local veh = activeVeh
    if veh == 0 or not DoesEntityExist(veh) then
        veh = GetVehiclePedIsIn(PlayerPedId(), false)
    end
    if veh == 0 or not DoesEntityExist(veh) then
        print('[accel-hud] get in a vehicle first')
        return
    end
    local model = modelName(veh)
    state = STATE_DONE
    print(('[accel-hud] handling test saved: %s  maxLat=%.2f maxYaw=%.2f'):format(model, handlingMaxLat, handlingMaxYaw))
end

RegisterNetEvent('sun-vehicle-debugger:accelhud', function()
    enabled = not enabled
    resetAccel()
    print(('[accel-hud] %s (mode: %s)'):format(enabled and 'ON' or 'OFF', mode))
end)

RegisterNetEvent('sun-vehicle-debugger:accelmode', function(args)
    local newMode = args[1] or ''
    if newMode == 'accel' or newMode == 'a' then mode = MODE_ACCEL
    elseif newMode == 'brake' or newMode == 'b' then mode = MODE_BRAKE
    elseif newMode == 'handling' or newMode == 'h' then mode = MODE_HANDLING
    else
        print('[accel-hud] usage: /accelmode <accel|brake|handling>')
        return
    end
    resetAccel(); resetBrake(); resetHandling()
    print(('[accel-hud] mode = %s'):format(mode))
end)

RegisterNetEvent('sun-vehicle-debugger:accelstart', function()
    if mode == MODE_ACCEL then
        resetAccel(); state = STATE_ARMED
        print('[accel-hud] ARMED accel — stop, then accelerate')
    elseif mode == MODE_BRAKE then
        resetBrake(); state = STATE_ARMED
        print('[accel-hud] ARMED brake — reach 100+ km/h then full brake')
    elseif mode == MODE_HANDLING then
        resetHandling(); state = STATE_ARMED
        print('[accel-hud] ARMED handling — start cornering. Run /accelsave when done.')
    end
end)

RegisterNetEvent('sun-vehicle-debugger:accelsave', function()
    if mode == MODE_ACCEL then
        savePartialAccel('manual')
    elseif mode == MODE_BRAKE then
        if state == STATE_RUNNING and brakeStopMs == nil then
            print('[accel-hud] brake test still running, brake to stop first')
            return
        end
        if brakeStopMs ~= nil then saveBrake() else print('[accel-hud] no brake data') end
    elseif mode == MODE_HANDLING then
        saveHandling()
    end
end)

RegisterNetEvent('sun-vehicle-debugger:accelreset', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehicleFixed(veh)
    end
    resetAccel(); resetBrake(); resetHandling()
    print('[accel-hud] reset')
end)

RegisterNetEvent('sun-vehicle-debugger:accelwind', function(args)
    local a = (args[1] or ''):lower()
    if a == 'off' or a == '0' then
        windLockSpeed = 0.0
        windLockAngleRad = nil
        SetWind(0.0)
        SetWindSpeed(0.0)
        print('[accel-hud] wind LOCKED to 0 (no wind)')
    elseif a == 'auto' or a == 'unlock' then
        windLockSpeed = nil
        windLockAngleRad = nil
        print('[accel-hud] wind unlocked (auto)')
    elseif a ~= '' then
        windLockSpeed = tonumber(a) or 0.0
        if args[2] then
            windLockAngleRad = math.rad(tonumber(args[2]) or 0)
        else
            windLockAngleRad = nil
        end
        print(('[accel-hud] wind LOCKED: %.2f m/s @ %s'):format(windLockSpeed, args[2] and (args[2] .. '°') or 'free'))
    else
        print('[accel-hud] usage: /accelwind <off|auto|speed [angle_deg]>')
    end
end)

CreateThread(function()
    while true do
        Wait(200)
        if windLockSpeed ~= nil then
            SetWindSpeed(windLockSpeed)
            if windLockAngleRad ~= nil then
                SetWindDirection(windLockAngleRad)
            end
        end
    end
end)

local function tickAccel(veh, now)
    local speedKmh = GetEntitySpeed(veh) * 3.6
    local gear = GetVehicleCurrentGear(veh)
    local rpm = GetVehicleCurrentRpm(veh)

    if state == STATE_ARMED then
        if speedKmh < 1.0 then
            activeVeh = veh
            prevGear = gear
        elseif activeVeh == veh and speedKmh >= 1.0 then
            state = STATE_RUNNING
            startMs = now
            local pos = GetEntityCoords(veh)
            accelStartPosX, accelStartPosY = pos.x, pos.y
            accelDistanceM = 0.0
        end
    elseif state == STATE_RUNNING then
        if veh ~= activeVeh then
            resetAccel()
        else
            if speedKmh > topSpeedKmh then topSpeedKmh = speedKmh end
            local pos = GetEntityCoords(veh)
            local dx = pos.x - accelStartPosX
            local dy = pos.y - accelStartPosY
            accelDistanceM = math.sqrt(dx*dx + dy*dy)
            if gear ~= prevGear and gear > prevGear and gear > 0 then
                table.insert(gearShifts, { gear = gear, speed = math.floor(speedKmh + 0.5), rpm = rpm, ms = now - startMs })
                prevGear = gear
            end
            for _, s in ipairs(SPLIT_TARGETS) do
                if splits[s] == nil and speedKmh >= s then
                    splits[s] = now - startMs
                end
            end
            if (now - startMs) >= 35000 and splits[260] == nil then savePartialAccel('timeout 35s') end
            if splits[260] ~= nil and total == nil then
                total = splits[260]
                state = STATE_DONE
                lastResultModel = modelName(veh)
                lastResultMass = vehicleMass(veh)
                accelBrakePhase = 1
                prevSpeedMs = GetEntitySpeed(veh)
                prevTickMs = now
            end
        end
    elseif state == STATE_DONE and accelBrakePhase > 0 then
        if veh ~= activeVeh then
            accelBrakePhase = 0
        elseif accelBrakePhase == 1 then
            local foot = IsControlPressed(0, 72)
            local handB = IsControlPressed(0, 76)
            if (foot or handB) and speedKmh >= 30.0 then
                accelBrakePhase = 2
                brakeStartMs = now
                brakeStartSpeed = speedKmh
                local pos = GetEntityCoords(veh)
                brakeStartPosX, brakeStartPosY = pos.x, pos.y
                prevSpeedMs = GetEntitySpeed(veh)
                prevTickMs = now
                brakeDecelPeak = 0
            end
        elseif accelBrakePhase == 2 then
            local speedMs = GetEntitySpeed(veh)
            local dt = (now - prevTickMs) / 1000.0
            if dt > 0 then
                local decel = (prevSpeedMs - speedMs) / dt
                if decel > brakeDecelPeak then brakeDecelPeak = decel end
            end
            prevSpeedMs = speedMs
            prevTickMs = now
            if speedKmh < 1.0 and brakeStopMs == nil then
                brakeStopMs = now - brakeStartMs
                local pos = GetEntityCoords(veh)
                local dx = pos.x - brakeStartPosX
                local dy = pos.y - brakeStartPosY
                brakeStopDistance = math.sqrt(dx*dx + dy*dy)
                accelBrakePhase = 3
                print(('[accel-hud] auto-brake saved: %s  %dkm/h -> 0 in %.2fs / %.1fm'):format(
                    lastResultModel, math.floor(brakeStartSpeed + 0.5),
                    brakeStopMs / 1000.0, brakeStopDistance))
            end
        end
    end
    return speedKmh, gear, rpm
end

local function tickBrake(veh, now)
    local speedMs = GetEntitySpeed(veh)
    local speedKmh = speedMs * 3.6

    if state == STATE_ARMED then
        if speedKmh >= 100.0 then
            activeVeh = veh
            local handBrake = IsControlPressed(0, 76)
            local foot = IsControlPressed(0, 72)
            if handBrake or foot then
                state = STATE_RUNNING
                brakeStartMs = now
                brakeStartSpeed = speedKmh
                local pos = GetEntityCoords(veh)
                brakeStartPosX, brakeStartPosY = pos.x, pos.y
                prevSpeedMs = speedMs
                prevTickMs = now
                brakeDecelPeak = 0
            end
        end
    elseif state == STATE_RUNNING then
        if veh ~= activeVeh then
            resetBrake()
        else
            local dt = (now - prevTickMs) / 1000.0
            if dt > 0 then
                local decel = (prevSpeedMs - speedMs) / dt
                if decel > brakeDecelPeak then brakeDecelPeak = decel end
            end
            prevSpeedMs = speedMs
            prevTickMs = now

            if speedKmh < 1.0 and brakeStopMs == nil then
                brakeStopMs = now - brakeStartMs
                local pos = GetEntityCoords(veh)
                local dx = pos.x - brakeStartPosX
                local dy = pos.y - brakeStartPosY
                brakeStopDistance = math.sqrt(dx*dx + dy*dy)
                saveBrake()
            end
        end
    end
    return speedKmh
end

local function tickHandling(veh, now)
    local speedKmh = GetEntitySpeed(veh) * 3.6

    if state == STATE_ARMED then
        if speedKmh >= 30.0 then
            activeVeh = veh
            state = STATE_RUNNING
            startMs = now
        end
    elseif state == STATE_RUNNING then
        if veh ~= activeVeh then
            resetHandling()
        else
            local rotVel = GetEntityRotationVelocity(veh)
            local yawRate = math.abs(rotVel.z)
            local rollRate = math.abs(rotVel.y)

            local fwdVel = GetEntityVelocity(veh)
            local fwdVec = GetEntityForwardVector(veh)
            local rightVec = vector3(fwdVec.y, -fwdVec.x, 0.0)
            local lateralMs = math.abs(fwdVel.x * rightVec.x + fwdVel.y * rightVec.y)
            local lateralG = lateralMs / 9.81

            local wheelsOnGround = 0
            for i = 0, 3 do
                if IsVehicleTyreBurst(veh, i, false) == false then
                    wheelsOnGround = wheelsOnGround + 1
                end
            end
            local gripSample = wheelsOnGround / 4.0

            if lateralG > handlingMaxLat then handlingMaxLat = lateralG end
            if yawRate > handlingMaxYaw then handlingMaxYaw = yawRate end
            if rollRate > handlingMaxRoll then handlingMaxRoll = rollRate end
            handlingAvgGrip = handlingAvgGrip + gripSample
            handlingSampleCount = handlingSampleCount + 1
            if speedKmh < handlingMinSpeed and speedKmh > 5 then handlingMinSpeed = speedKmh end
            if speedKmh > handlingMaxSpeed then handlingMaxSpeed = speedKmh end
        end
    end
    return speedKmh
end

CreateThread(function()
    while true do
        if not enabled then
            Wait(500)
        else
            Wait(0)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            local now = GetGameTimer()

            if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then
                drawText(0.012, 0.40, '~y~[accel-hud]~w~ get in driver seat', 0.45, 255, 255, 255)
            else
                local x, y = 0.012, 0.36
                local name = modelName(veh)
                local mass = vehicleMass(veh)

                local modeLabel = mode:upper()
                local drag = vehicleHandlingF(veh, 'fInitialDragCoeff')
                local windSpeed = GetWindSpeed()
                local windVec = GetWindDirection()
                local windAbsDeg = math.deg(math.atan(windVec.y, windVec.x))
                local fwd = GetEntityForwardVector(veh)
                local carDeg = math.deg(math.atan(fwd.y, fwd.x))
                local windRel = ((windAbsDeg - carDeg + 540) % 360) - 180
                local windLabel
                local ar = math.abs(windRel)
                if ar < 30 then windLabel = '~g~TAIL'
                elseif ar > 150 then windLabel = '~r~HEAD'
                elseif ar < 60 or ar > 120 then windLabel = '~y~quarter'
                else windLabel = '~y~SIDE' end
                drawText(x, y, ('~b~%s~w~  mass=%.0f  drag=%.2f  ~o~[%s]'):format(name, mass, drag, modeLabel), 0.42, 255, 255, 255)
                local wx = 0.82
                local windHeader = windLockSpeed ~= nil and '~o~WIND ~r~[LOCK]' or '~o~WIND'
                drawText(wx, 0.05, windHeader, 0.42, 255, 255, 255)
                drawText(wx, 0.078, ('Speed: ~y~%.1f~w~ m/s'):format(windSpeed), 0.38, 200, 220, 255)
                drawText(wx, 0.104, ('Rel  : ~y~%+d\xc2\xb0'):format(math.floor(windRel + 0.5)), 0.38, 200, 220, 255)
                drawText(wx, 0.130, ('Side : %s'):format(windLabel), 0.38, 200, 220, 255)

                if mode == MODE_ACCEL then
                    local speedKmh, gear, rpm = tickAccel(veh, now)
                    drawText(x, y + 0.025, ('Speed: ~y~%.0f~w~ km/h  Gear: ~y~%d~w~  RPM: ~y~%.2f'):format(speedKmh, gear, rpm), 0.36, 255, 255, 255)
                    local stateStr
                    if state == STATE_IDLE then stateStr = '~o~/accelstart~w~ to arm'
                    elseif state == STATE_ARMED then stateStr = '~y~ARMED~w~ — stop then accelerate'
                    elseif state == STATE_RUNNING then stateStr = '~g~MEASURING~w~ ' .. string.format('%.2fs', (now - startMs) / 1000.0)
                    else stateStr = '~g~DONE~w~ — /accelreset' end
                    drawText(x, y + 0.052, 'State: ' .. stateStr, 0.36, 255, 255, 255)
                    drawText(x, y + 0.082, ('0-50   : ~y~%s'):format(fmtSec(splits[50])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.104, ('50-100 : ~y~%s'):format(fmtDelta(splits[50], splits[100])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.126, ('100-150: ~y~%s'):format(fmtDelta(splits[100], splits[150])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.148, ('150-200: ~y~%s'):format(fmtDelta(splits[150], splits[200])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.170, ('200-250: ~y~%s'):format(fmtDelta(splits[200], splits[250])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.192, ('250-260: ~y~%s'):format(fmtDelta(splits[250], splits[260])), 0.36, 255, 255, 255)
                    drawText(x, y + 0.218, ('0-260  : ~y~%s'):format(fmtSec(total)), 0.40, 255, 255, 255)
                    drawText(x, y + 0.246, ('Dist: ~y~%.1f~w~ m  Top: ~y~%d~w~ km/h  Gears: ~y~%d'):format(accelDistanceM, math.floor(topSpeedKmh + 0.5), #gearShifts), 0.34, 255, 255, 255)
                    if #gearShifts > 0 then
                        local yy = y + 0.272
                        drawText(x, yy, 'Shifts:', 0.32, 200, 200, 200)
                        for i, g in ipairs(gearShifts) do
                            if i <= 7 then
                                drawText(x, yy + i * 0.018, string.format('  G%d @ %dkm/h  %.2frpm  %.2fs', g.gear, g.speed, g.rpm, g.ms / 1000.0), 0.30, 200, 200, 200)
                            end
                        end
                    end
                    if accelBrakePhase > 0 then
                        local by = y + 0.272 + (#gearShifts > 0 and (math.min(#gearShifts, 7) + 1) * 0.018 or 0) + 0.010
                        local brakeF = vehicleHandlingF(veh, 'fBrakeForce')
                        local bstateStr
                        if accelBrakePhase == 1 then bstateStr = '~y~BRAKE NOW~w~ to record stop'
                        elseif accelBrakePhase == 2 then bstateStr = '~g~BRAKING~w~ from ' .. string.format('%.0f km/h', brakeStartSpeed)
                        else bstateStr = '~g~BRAKE DONE~w~ — /accelreset' end
                        drawText(x, by, '~o~[brake]~w~ ' .. bstateStr .. string.format('  fBrakeForce=%.2f', brakeF), 0.34, 255, 255, 255)
                        drawText(x, by + 0.022, ('Stop time: ~y~%s~w~  dist: ~y~%s'):format(
                            brakeStopMs and string.format('%.3fs', brakeStopMs/1000.0) or '--',
                            brakeStopDistance and string.format('%.1f m', brakeStopDistance) or '--'), 0.34, 255, 255, 255)
                        drawText(x, by + 0.044, ('Peak decel: ~y~%.1f~w~ m/s\xc2\xb2  (%.1fg)'):format(brakeDecelPeak, brakeDecelPeak/9.81), 0.34, 255, 255, 255)
                    end

                elseif mode == MODE_BRAKE then
                    local speedKmh = tickBrake(veh, now)
                    local brakeF = vehicleHandlingF(veh, 'fBrakeForce')
                    drawText(x, y + 0.025, ('Speed: ~y~%.0f~w~ km/h  fBrakeForce: ~o~%.2f'):format(speedKmh, brakeF), 0.36, 255, 255, 255)
                    local stateStr
                    if state == STATE_IDLE then stateStr = '~o~/accelstart~w~ to arm'
                    elseif state == STATE_ARMED then stateStr = '~y~ARMED~w~ — get to 100+ km/h then brake'
                    elseif state == STATE_RUNNING then stateStr = '~g~BRAKING~w~ from ' .. string.format('%.0f km/h', brakeStartSpeed)
                    else stateStr = '~g~DONE~w~ — /accelreset' end
                    drawText(x, y + 0.052, 'State: ' .. stateStr, 0.36, 255, 255, 255)
                    drawText(x, y + 0.082, ('Start speed: ~y~%.0f~w~ km/h'):format(brakeStartSpeed), 0.38, 255, 255, 255)
                    drawText(x, y + 0.108, ('Stop time  : ~y~%s'):format(brakeStopMs and string.format('%.3fs', brakeStopMs/1000.0) or '--'), 0.38, 255, 255, 255)
                    drawText(x, y + 0.134, ('Stop dist  : ~y~%s'):format(brakeStopDistance and string.format('%.1f m', brakeStopDistance) or '--'), 0.38, 255, 255, 255)
                    drawText(x, y + 0.160, ('Peak decel : ~y~%.1f~w~ m/s\xc2\xb2  (%.1fg)'):format(brakeDecelPeak, brakeDecelPeak/9.81), 0.38, 255, 255, 255)

                elseif mode == MODE_HANDLING then
                    local speedKmh = tickHandling(veh, now)
                    local steerLock = vehicleHandlingF(veh, 'fSteeringLock')
                    local tracMax = vehicleHandlingF(veh, 'fTractionCurveMax')
                    local tracBias = vehicleHandlingF(veh, 'fTractionBiasFront')
                    drawText(x, y + 0.025, ('Speed: ~y~%.0f~w~  steerLock=%.1f  tracMax=%.2f  bias=%.2f'):format(speedKmh, steerLock, tracMax, tracBias), 0.34, 255, 255, 255)
                    local stateStr
                    if state == STATE_IDLE then stateStr = '~o~/accelstart~w~ to arm'
                    elseif state == STATE_ARMED then stateStr = '~y~ARMED~w~ — drive 30+ km/h to start'
                    elseif state == STATE_RUNNING then stateStr = '~g~MEASURING~w~ ' .. string.format('%.1fs', (now - startMs) / 1000.0)
                    else stateStr = '~g~DONE~w~' end
                    drawText(x, y + 0.052, 'State: ' .. stateStr, 0.36, 255, 255, 255)
                    drawText(x, y + 0.082, ('Max lat-G  : ~y~%.2f~w~ g  (cornering grip)'):format(handlingMaxLat), 0.38, 255, 255, 255)
                    drawText(x, y + 0.108, ('Max yaw    : ~y~%.2f~w~ rad/s  (rotation speed)'):format(handlingMaxYaw), 0.38, 255, 255, 255)
                    drawText(x, y + 0.134, ('Max roll   : ~y~%.2f~w~ rad/s  (body lean)'):format(handlingMaxRoll), 0.38, 255, 255, 255)
                    drawText(x, y + 0.160, ('Avg grip   : ~y~%.0f%%'):format(handlingSampleCount > 0 and (handlingAvgGrip / handlingSampleCount * 100) or 0), 0.38, 255, 255, 255)
                    drawText(x, y + 0.186, ('Speed range: ~y~%.0f-%.0f~w~ km/h'):format(handlingMinSpeed < 999 and handlingMinSpeed or 0, handlingMaxSpeed), 0.36, 255, 255, 255)
                    local _, _, comZ = vehicleHandlingV(veh, 'vecCentreOfMassOffset')
                    drawText(x, y + 0.212, ('~b~Grip~w~ max=%.2f min=%.2f bias=%.2f'):format(tracMax, vehicleHandlingF(veh,'fTractionCurveMin'), tracBias), 0.34, 200, 220, 255)
                    drawText(x, y + 0.234, ('~b~Brake~w~ force=%.2f biasF=%.2f hand=%.1f'):format(vehicleHandlingF(veh,'fBrakeForce'), vehicleHandlingF(veh,'fBrakeBiasFront'), vehicleHandlingF(veh,'fHandBrakeForce')), 0.34, 200, 220, 255)
                    drawText(x, y + 0.256, ('~b~CoM-z~w~ %.3f  ~b~susp~w~ F=%.2f anti=%.2f'):format(comZ, vehicleHandlingF(veh,'fSuspensionForce'), vehicleHandlingF(veh,'fAntiRollBarForce')), 0.34, 200, 220, 255)
                    drawText(x, y + 0.282, ('~o~OffRoad~w~ tracLoss=%.2f raise=%.3f travel=%.2f/%.2f'):format(vehicleHandlingF(veh,'fTractionLossMult'), vehicleHandlingF(veh,'fSuspensionRaise'), vehicleHandlingF(veh,'fSuspensionUpperLimit'), vehicleHandlingF(veh,'fSuspensionLowerLimit')), 0.34, 220, 200, 160)
                    drawText(x, y + 0.308, '~o~Tip:~w~ corner hard, /accelsave to finish', 0.34, 220, 220, 220)
                end
            end
        end
    end
end)
