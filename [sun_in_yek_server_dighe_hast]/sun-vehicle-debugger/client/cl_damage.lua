-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local enabled = false
local hitCount = 0
local lastEngine, lastBody, lastPetrol = 1000.0, 1000.0, 1000.0

local hitThreshold = 1.0
local windowMs = 600

local windowOpen = false
local windowStartTime = 0
local windowEngineSum = 0.0
local windowBodySum = 0.0
local windowPetrolSum = 0.0
local windowPeakSpeed = 0.0

local lastHitEngine = 0.0
local lastHitBody = 0.0
local lastHitPetrol = 0.0
local lastHitSpeed = 0.0
local lastHitNum = 0

local speedHistorySize = 30
local speedHistory = {}
local speedHistoryIdx = 1
for i = 1, speedHistorySize do speedHistory[i] = 0.0 end

local function peakRecentSpeed()
    local m = 0.0
    for i = 1, speedHistorySize do
        if speedHistory[i] > m then m = speedHistory[i] end
    end
    return m
end

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

local function drawBar(x, y, w, h, pct, r, g, b)
    DrawRect(x + w / 2, y + h / 2, w, h, 30, 30, 30, 200)
    DrawRect(x + (w * pct) / 2, y + h / 2, w * pct, h, r, g, b, 220)
end

local function modelName(veh)
    return GetDisplayNameFromVehicleModel(GetEntityModel(veh))
end

local function resetState()
    hitCount = 0
    lastEngine, lastBody, lastPetrol = 1000.0, 1000.0, 1000.0
    windowOpen = false
    windowEngineSum, windowBodySum, windowPetrolSum, windowPeakSpeed = 0.0, 0.0, 0.0, 0.0
    lastHitEngine, lastHitBody, lastHitPetrol, lastHitSpeed, lastHitNum = 0.0, 0.0, 0.0, 0.0, 0
end

local function finalizeHit()
    if not windowOpen then return end
    hitCount = hitCount + 1
    lastHitEngine = windowEngineSum
    lastHitBody = windowBodySum
    lastHitPetrol = windowPetrolSum
    lastHitSpeed = windowPeakSpeed
    lastHitNum = hitCount

    windowOpen = false
    windowEngineSum, windowBodySum, windowPetrolSum, windowPeakSpeed = 0.0, 0.0, 0.0, 0.0
end

RegisterNetEvent('sun-vehicle-debugger:dmghud', function()
    enabled = not enabled
    resetState()
    print(('[sun-damage-hud] %s'):format(enabled and 'ON' or 'OFF'))
end)

RegisterNetEvent('sun-vehicle-debugger:dmgreset', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        SetVehicleEngineHealth(veh, 1000.0)
        SetVehicleBodyHealth(veh, 1000.0)
        SetVehiclePetrolTankHealth(veh, 1000.0)
        SetVehicleFixed(veh)
    end
    resetState()
    print('[sun-damage-hud] reset')
end)

CreateThread(function()
    while true do
        if not enabled then
            Wait(500)
        else
            Wait(0)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then
                drawText(0.012, 0.40, '~y~[dmghud]~w~ get in driver seat', 0.45, 255, 255, 255)
            else
                local engine = GetVehicleEngineHealth(veh)
                local body = GetVehicleBodyHealth(veh)
                local petrol = GetVehiclePetrolTankHealth(veh)
                local speedKmh = GetEntitySpeed(veh) * 3.6

                local eDelta = lastEngine - engine
                local bDelta = lastBody - body
                local pDelta = lastPetrol - petrol
                local now = GetGameTimer()

                if eDelta > hitThreshold or bDelta > hitThreshold or pDelta > hitThreshold then
                    if not windowOpen then
                        windowOpen = true
                        windowStartTime = now
                        windowPeakSpeed = peakRecentSpeed()
                    end
                    if eDelta > 0 then windowEngineSum = windowEngineSum + eDelta end
                    if bDelta > 0 then windowBodySum = windowBodySum + bDelta end
                    if pDelta > 0 then windowPetrolSum = windowPetrolSum + pDelta end
                end

                if windowOpen and (now - windowStartTime) >= windowMs then
                    finalizeHit()
                end

                lastEngine = engine
                lastBody = body
                lastPetrol = petrol

                speedHistory[speedHistoryIdx] = speedKmh
                speedHistoryIdx = speedHistoryIdx + 1
                if speedHistoryIdx > speedHistorySize then speedHistoryIdx = 1 end

                local name = modelName(veh)
                local x, y = 0.012, 0.36
                drawText(x, y,         ('~b~%s'):format(name), 0.42, 255, 255, 255)
                drawText(x, y + 0.025, ('Speed: ~y~%.0f~w~ km/h'):format(speedKmh), 0.38, 255, 255, 255)

                local ePct = math.max(0.0, engine / 1000.0)
                local bPct = math.max(0.0, body / 1000.0)
                local pPct = math.max(0.0, petrol / 1000.0)

                drawText(x, y + 0.055,  ('Engine : ~y~%.0f~w~ / 1000'):format(engine), 0.38, 255, 255, 255)
                drawBar(x, y + 0.078, 0.18, 0.012, ePct, 220, 60, 60)

                drawText(x, y + 0.097,  ('Body   : ~y~%.0f~w~ / 1000'):format(body), 0.38, 255, 255, 255)
                drawBar(x, y + 0.120, 0.18, 0.012, bPct, 60, 160, 220)

                drawText(x, y + 0.139,  ('Petrol : ~y~%.0f~w~ / 1000'):format(petrol), 0.38, 255, 255, 255)
                drawBar(x, y + 0.162, 0.18, 0.012, pPct, 220, 180, 60)

                local hitColor = windowOpen and '~o~' or '~g~'
                drawText(x, y + 0.185, ('Hits   : %s%d~w~%s'):format(hitColor, hitCount, windowOpen and '  (recording...)' or ''), 0.42, 255, 255, 255)
                if lastHitNum > 0 then
                    drawText(x, y + 0.210, ('#%d @ ~y~%.0f~w~ km/h  -E:~r~%.1f~w~  -B:~b~%.1f~w~  -P:~o~%.1f'):format(lastHitNum, lastHitSpeed, lastHitEngine, lastHitBody, lastHitPetrol), 0.34, 255, 255, 255)
                end
            end
        end
    end
end)
