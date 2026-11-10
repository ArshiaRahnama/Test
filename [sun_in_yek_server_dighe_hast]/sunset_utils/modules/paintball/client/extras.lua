-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.HUD = PB.HUD or 'paintball-hud'
PB.MODULE = PB.MODULE or 'paintball'
PB.state = PB.state or {}

local activeSpyPlane = nil
local activeAttackHeli = nil
local spotMarks = {}
local spotCooldown = 0

RegisterNetEvent('paintball:spyPlaneStart', function(payload)
    if activeSpyPlane and activeSpyPlane.heli and DoesEntityExist(activeSpyPlane.heli) then
        DeleteEntity(activeSpyPlane.heli)
    end
    activeSpyPlane = {owner = payload.owner, endAt = GetGameTimer() + (payload.duration * 1000), heli = nil, blip = nil, isEnemy = payload.isEnemy}

    if payload.isOwner and payload.mapCenter then
        local hash = GetHashKey(payload.heliModel or 'frogger')
        ESX.Streaming.RequestModel(hash)
        local cx, cy, cz = payload.mapCenter.x, payload.mapCenter.y, payload.mapCenter.z + (payload.height or 100.0)
        local heli = CreateVehicle(hash, cx + (payload.radius or 250.0), cy, cz, 0.0, true, false)
        SetVehicleEngineOn(heli, true, true, true)
        SetEntityInvincible(heli, true)
        local pilotHash = GetHashKey('s_m_y_pilot_01')
        ESX.Streaming.RequestModel(pilotHash)
        local pilot = CreatePedInsideVehicle(heli, 4, pilotHash, -1, true, false)
        SetEntityInvincible(pilot, true)
        TaskHeliMission(pilot, heli, 0, 0, cx, cy, cz, 6, payload.speed or 30.0, payload.radius - 30.0, -1.0, 30, 30, 50.0, 0)
        SetModelAsNoLongerNeeded(hash)
        SetModelAsNoLongerNeeded(pilotHash)
        activeSpyPlane.heli = heli
        local blip = AddBlipForEntity(heli)
        SetBlipSprite(blip, 422)
        SetBlipColour(blip, 3)
        SetBlipScale(blip, 0.85)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Spy Plane')
        EndTextCommandSetBlipName(blip)
        activeSpyPlane.blip = blip
    end

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = payload.isEnemy and 'Spy Plane دشمن!' or 'Spy Plane فعال', duration = 4}})

    if payload.isEnemy then
        CreateThread(function()
            local endAt = GetGameTimer() + (payload.duration * 1000)
            while GetGameTimer() < endAt do
                HideMinimapInteriorMapThisFrame()
                HideMinimapExteriorMapThisFrame()
                SetRadarZoom(2500)
                Wait(0)
            end
            SetRadarZoom(1100)
        end)
    end
end)

RegisterNetEvent('paintball:spyPlaneEnd', function(info)
    if activeSpyPlane then
        if activeSpyPlane.heli and DoesEntityExist(activeSpyPlane.heli) then DeleteEntity(activeSpyPlane.heli) end
        if activeSpyPlane.blip and DoesBlipExist(activeSpyPlane.blip) then RemoveBlip(activeSpyPlane.blip) end
        activeSpyPlane = nil
    end
    SetRadarZoom(1100)
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'Spy Plane پایان', duration = 2}})
end)

local pbHostileGroup = nil
local function getPbHostileGroup()
    if pbHostileGroup then return pbHostileGroup end
    pbHostileGroup = AddRelationshipGroup('PB_HOSTILE_KS')
    SetRelationshipBetweenGroups(3, pbHostileGroup, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(3, GetHashKey('PLAYER'), pbHostileGroup)
    SetRelationshipBetweenGroups(3, pbHostileGroup, GetHashKey('CIVMALE'))
    SetRelationshipBetweenGroups(3, pbHostileGroup, GetHashKey('CIVFEMALE'))
    return pbHostileGroup
end

local function configureHostilePed(ped)
    local g = getPbHostileGroup()
    SetPedRelationshipGroupHash(ped, g)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedAlertness(ped, 0)
    SetPedCombatAttributes(ped, 5, false)
    SetPedCombatAttributes(ped, 46, false)
    return g
end

RegisterNetEvent('paintball:attackHeliWarning', function(payload)
    if not payload then return end
    local secs = payload.warningSec or 15
    local label = payload.isFriendly and ('Attack Heli در حال آماده شدن — ' .. secs .. ' ثانیه') or ('⚠ ATTACK HELI دشمن — ' .. secs .. ' ثانیه تا حمله ⚠')
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = label, duration = math.min(secs, 8)}})
    if not payload.isFriendly then
        CreateThread(function()
            local remaining = secs
            while remaining > 0 do
                if remaining <= 5 then
                    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = ('⚠ Attack Heli در ' .. remaining .. ' ثانیه ⚠'), duration = 1.5}})
                    PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', false)
                end
                Wait(1000)
                remaining = remaining - 1
            end
        end)
    end
end)

RegisterNetEvent('paintball:attackHeliStart', function(payload)
    if activeAttackHeli and activeAttackHeli.heli and DoesEntityExist(activeAttackHeli.heli) then
        DeleteEntity(activeAttackHeli.heli)
    end
    activeAttackHeli = {owner = payload.owner, endAt = GetGameTimer() + (payload.duration * 1000), heli = nil, blip = nil}

    if payload.isOwner and payload.mapCenter then
        local hash = GetHashKey(payload.heliModel or 'valkyrie2')
        if not IsModelInCdimage(hash) then hash = GetHashKey('valkyrie') end
        ESX.Streaming.RequestModel(hash)
        local cx, cy, cz = payload.mapCenter.x, payload.mapCenter.y, payload.mapCenter.z + (payload.height or 70.0)
        local heli = CreateVehicle(hash, cx + (payload.radius or 180.0), cy, cz, 0.0, true, false)
        SetVehicleEngineOn(heli, true, true, true)
        SetEntityInvincible(heli, false)
        SetEntityMaxHealth(heli, 5000)
        SetEntityHealth(heli, 5000)

        local pilotHash = GetHashKey('s_m_y_pilot_01')
        ESX.Streaming.RequestModel(pilotHash)
        local pilot = CreatePedInsideVehicle(heli, 4, pilotHash, -1, true, false)
        SetEntityInvincible(pilot, true)
        configureHostilePed(pilot)
        SetPedAccuracy(pilot, payload.pilotAccuracy or 70)

        local gunnerHash = GetHashKey('s_m_m_marine_01')
        if not IsModelInCdimage(gunnerHash) then gunnerHash = GetHashKey('s_m_y_blackops_01') end
        ESX.Streaming.RequestModel(gunnerHash)
        local gunner = CreatePedInsideVehicle(heli, 4, gunnerHash, 1, true, false)
        SetEntityInvincible(gunner, true)
        local hostileGroup = configureHostilePed(gunner)
        if NetworkGetEntityIsNetworked(gunner) then
            ESX.TriggerServerCallback('paintball:registerAIKill', function() end, NetworkGetNetworkIdFromEntity(gunner), 'attackheli')
        end
        if NetworkGetEntityIsNetworked(pilot) then
            ESX.TriggerServerCallback('paintball:registerAIKill', function() end, NetworkGetNetworkIdFromEntity(pilot), 'attackheli')
        end
        if NetworkGetEntityIsNetworked(heli) then
            ESX.TriggerServerCallback('paintball:registerAIKill', function() end, NetworkGetNetworkIdFromEntity(heli), 'attackheli')
        end
        SetPedAccuracy(gunner, payload.gunnerAccuracy or 90)
        SetPedCombatAttributes(gunner, 0, true)
        SetPedCombatAttributes(gunner, 1, true)
        SetPedCombatAttributes(gunner, 52, true)
        SetPedCombatAbility(gunner, 100)
        SetPedCombatRange(gunner, 3)
        SetPedSeeingRange(gunner, 300.0)
        SetPedHearingRange(gunner, 300.0)
        SetPedShootRate(gunner, 1000)
        SetPedTargetLossResponse(gunner, 1)
        GiveWeaponToPed(gunner, GetHashKey('WEAPON_COMBATMG_MK2'), 9999, true, true)
        SetPedInfiniteAmmo(gunner, true, GetHashKey('WEAPON_COMBATMG_MK2'))
        SetPedInfiniteAmmoClip(gunner, true)

        SetModelAsNoLongerNeeded(hash)
        SetModelAsNoLongerNeeded(pilotHash)
        SetModelAsNoLongerNeeded(gunnerHash)

        activeAttackHeli.heli = heli
        activeAttackHeli.gunner = gunner
        activeAttackHeli.pilot = pilot

        local blip = AddBlipForEntity(heli)
        SetBlipSprite(blip, 422)
        SetBlipColour(blip, payload.isFriendly and 2 or 1)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Attack Heli')
        EndTextCommandSetBlipName(blip)
        activeAttackHeli.blip = blip

        CreateThread(function()
            local endAt = GetGameTimer() + (payload.duration * 1000)
            local engageDist = payload.engageDistance or 200.0
            local currentTarget = nil
            local isSolo = (PB.state.mode == 'ffa' or PB.state.mode == 'gungame')
            SetEntityCanBeDamagedByRelationshipGroup(SUN.ped, false, hostileGroup)
            while activeAttackHeli and DoesEntityExist(heli) and not IsEntityDead(heli) and GetGameTimer() < endAt do
                SetEntityCanBeDamagedByRelationshipGroup(SUN.ped, false, hostileGroup)
                if currentTarget and (not DoesEntityExist(currentTarget) or IsPedDeadOrDying(currentTarget, true)) then
                    currentTarget = nil
                end
                local myTeam = PB.state.team or 0
                local heliCoords = GetEntityCoords(heli)
                local closestPed, closestDist = nil, engageDist
                if PB.iterateMatchPlayers then
                    PB.iterateMatchPlayers(function(sid, team, pid, tp)
                        local isEnemy = isSolo or (team and team ~= myTeam and team > 0)
                        if isEnemy then
                            SetEntityCanBeDamagedByRelationshipGroup(tp, true, hostileGroup)
                            local d = #(heliCoords - GetEntityCoords(tp))
                            if d < closestDist then closestPed, closestDist = tp, d end
                        else
                            SetEntityCanBeDamagedByRelationshipGroup(tp, false, hostileGroup)
                        end
                    end)
                end
                if not currentTarget and closestPed then
                    currentTarget = closestPed
                end

                if currentTarget then
                    TaskHeliMission(pilot, heli, 0, currentTarget, 0.0, 0.0, 0.0, 8, payload.speed or 25.0, 30.0, -1.0, 30, 20, 50.0, 0)
                    TaskCombatPed(gunner, currentTarget, 0, 16)
                else
                    ClearPedTasks(gunner)
                    TaskHeliMission(pilot, heli, 0, 0, cx, cy, cz, 6, payload.speed or 25.0, payload.radius - 20.0, -1.0, 30, 30, 50.0, 0)
                end
                Wait(800)
            end
        end)
    end

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = payload.isFriendly and 'Attack Heli فعال شد' or 'Attack Heli دشمن!', duration = 4}})
end)

RegisterNetEvent('paintball:attackHeliEnd', function(info)
    if activeAttackHeli then
        local ah = activeAttackHeli
        activeAttackHeli = nil
        if ah.blip and DoesBlipExist(ah.blip) then RemoveBlip(ah.blip) end
        if ah.gunner and DoesEntityExist(ah.gunner) then
            ClearPedTasks(ah.gunner)
        end
        if ah.pilot and DoesEntityExist(ah.pilot) and ah.heli and DoesEntityExist(ah.heli) then
            local hc = GetEntityCoords(ah.heli)
            TaskHeliMission(ah.pilot, ah.heli, 0, 0, hc.x + 800.0, hc.y + 800.0, hc.z + 200.0, 4, 80.0, 30.0, -1.0, 30, 30, 50.0, 0)
        end
        SetTimeout(8000, function()
            if ah.gunner and DoesEntityExist(ah.gunner) then DeleteEntity(ah.gunner) end
            if ah.pilot and DoesEntityExist(ah.pilot) then DeleteEntity(ah.pilot) end
            if ah.heli and DoesEntityExist(ah.heli) then DeleteEntity(ah.heli) end
        end)
    end
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'Attack Heli پایان', duration = 2}})
end)

AddEventHandler('KeyDown:q', function()
    if not PB.state.inMatch or PB.state.spectator then return end
    if not paintballConfig.spotting or not paintballConfig.spotting.enabled then return end
    local now = GetGameTimer() / 1000
    if spotCooldown > now then return end

    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local rz, rx = math.rad(camRot.z), math.rad(camRot.x)
    local cosX = math.cos(rx)
    local fwd = vec3(-math.sin(rz) * cosX, math.cos(rz) * cosX, math.sin(rx))
    local maxDist = paintballConfig.spotting.maxDistance or 400.0
    local endX = camCoords.x + fwd.x * maxDist
    local endY = camCoords.y + fwd.y * maxDist
    local endZ = camCoords.z + fwd.z * maxDist
    local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, endX, endY, endZ, -1, SUN.ped, 0)
    local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)
    local markCoords
    if hit == 1 then
        markCoords = vec3(hitCoords.x, hitCoords.y, hitCoords.z + 1.2)
    else
        markCoords = vec3(endX, endY, endZ)
    end

    local removeRadius = paintballConfig.spotting.removeRadius or 5.0
    for id, m in pairs(spotMarks) do
        if m.coords then
            local d = #(vec3(m.coords.x, m.coords.y, m.coords.z) - markCoords)
            if d <= removeRadius then
                TriggerServerEvent('paintball:spotRemove', id)
                spotCooldown = now + (paintballConfig.spotting.cooldown or 1.5)
                return
            end
        end
    end

    spotCooldown = now + (paintballConfig.spotting.cooldown or 1.5)
    local markId = tostring(GetPlayerServerId(SUN.PlayerId)) .. '_' .. tostring(GetGameTimer())
    TriggerServerEvent('paintball:spotAdd', {x = markCoords.x, y = markCoords.y, z = markCoords.z}, markId)
end)

RegisterNetEvent('paintball:spotMark', function(payload)
    if not payload or not payload.id or not payload.coords then return end
    if spotMarks[payload.id] and DoesBlipExist(spotMarks[payload.id].blip) then
        RemoveBlip(spotMarks[payload.id].blip)
    end
    local cfg = paintballConfig.spotting or {}
    local blip = AddBlipForCoord(payload.coords.x, payload.coords.y, payload.coords.z)
    SetBlipSprite(blip, cfg.blipSprite or 162)
    SetBlipColour(blip, cfg.blipColour or 5)
    SetBlipScale(blip, cfg.blipScale or 1.1)
    SetBlipAsShortRange(blip, false)
    SetBlipFlashes(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Spotted Location')
    EndTextCommandSetBlipName(blip)
    spotMarks[payload.id] = {blip = blip, coords = payload.coords, endAt = GetGameTimer() + ((payload.duration or 12) * 1000), owner = payload.owner}
end)

RegisterNetEvent('paintball:spotSound', function(payload)
    if not payload then return end
    PlaySoundFrontend(-1, payload.soundName or 'WAYPOINT_SET', payload.soundSet or 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)

RegisterNetEvent('paintball:spotRemove', function(payload)
    if not payload or not payload.id then return end
    local m = spotMarks[payload.id]
    if m and m.blip and DoesBlipExist(m.blip) then RemoveBlip(m.blip) end
    spotMarks[payload.id] = nil
end)

local spottingRunning = false
local function startSpotting()
    if spottingRunning then return end
    spottingRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            local cnt = 0
            for _ in pairs(spotMarks) do cnt = cnt + 1 end
            if cnt > 0 and PB.state.inMatch then
                local cfg = paintballConfig.spotting or {}
                local color = cfg.color or {r = 255, g = 200, b = 80}
                local arrowSize = cfg.arrowSize or 0.9
                local circleSize = cfg.groundCircleSize or 1.2
                local drawDist = cfg.drawDistance or 250.0
                local alpha = cfg.alpha or 200
                for _, m in pairs(spotMarks) do
                    if m.coords then
                        local d = #(SUN.PlayerCoords - vec3(m.coords.x, m.coords.y, m.coords.z))
                        if d < drawDist then
                            DrawMarker(0, m.coords.x, m.coords.y, m.coords.z + 1.5, 0,0,0, 180,0,0, arrowSize, arrowSize, arrowSize, color.r, color.g, color.b, alpha, true, false, 2, false, false, false, false)
                            DrawMarker(1, m.coords.x, m.coords.y, m.coords.z - 1.0, 0,0,0, 0,0,0, circleSize, circleSize, 0.3, color.r, color.g, color.b, math.floor(alpha * 0.4), false, false, 2, false, false, false, false)
                        end
                    end
                end
                Wait(0)
            else
                Wait(800)
            end
        end
        spottingRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startSpotting)

RegisterNetEvent('paintball:killstreakProgress', function(payload)
    SUN.SendUIData(PB.HUD, {type = 'killstreakProgress', payload = payload})
end)

local matchTourActive = false
local tourPlayedForMatch = nil

RegisterNetEvent('paintball:matchStart', function(payload)
    tourPlayedForMatch = nil
end)

RegisterNetEvent('paintball:matchEnd', function()
    tourPlayedForMatch = nil
    matchTourActive = false
end)

RegisterNetEvent('paintball:spawn', function(payload)
    if not paintballConfig.preMatchTour or not paintballConfig.preMatchTour.enabled then return end
    if matchTourActive then return end
    if not PB.state.matchId then return end
    if tourPlayedForMatch == PB.state.matchId then return end
    tourPlayedForMatch = PB.state.matchId

    local mapKey = payload.map or PB.state.map
    local map = paintballConfig.maps[mapKey] or paintballConfig.coopMaps[mapKey]
    if not map or not map.center then return end

    SetTimeout(1200, function()
        if not PB.state.inMatch then return end
        matchTourActive = true
        CreateThread(function()
            local cfg = paintballConfig.preMatchTour
            local center = map.center
            local height = cfg.cameraHeight or 80.0
            local distance = cfg.cameraDistance or 60.0
            local duration = cfg.duration or 10
            local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
            SetCamFov(cam, 60.0)
            SetCamCoord(cam, center.x + distance, center.y, center.z + height)
            PointCamAtCoord(cam, center.x, center.y, center.z)
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 600, false, false)
            FreezeEntityPosition(SUN.ped, true)
            local startedAt = GetGameTimer()
            local endAt = startedAt + (duration * 1000)
            SUN.SendUIData(PB.HUD, {type = 'preMatchTour', payload = {active = true, duration = duration}})
            while matchTourActive and GetGameTimer() < endAt and PB.state.inMatch do
                local elapsed = GetGameTimer() - startedAt
                local progress = elapsed / (duration * 1000)
                local angle = progress * 6.28
                local cx = center.x + math.cos(angle) * distance
                local cy = center.y + math.sin(angle) * distance
                local cz = center.z + height - (progress * height * 0.3)
                SetCamCoord(cam, cx, cy, cz)
                PointCamAtCoord(cam, center.x, center.y, center.z)
                Wait(0)
            end
            RenderScriptCams(false, true, 800, false, false)
            Wait(900)
            DestroyCam(cam, false)
            FreezeEntityPosition(SUN.ped, false)
            SUN.SendUIData(PB.HUD, {type = 'preMatchTour', payload = {active = false}})
            matchTourActive = false
        end)
    end)
end)

RegisterNetEvent('paintball:cleanup', function()
    if matchTourActive then
        matchTourActive = false
        RenderScriptCams(false, false, 0, false, false)
        FreezeEntityPosition(SUN.ped, false)
        SUN.SendUIData(PB.HUD, {type = 'preMatchTour', payload = {active = false}})
    end
end)

RegisterNetEvent('paintball:matchEnd', function(payload)
    if not paintballConfig.matchOutro or not paintballConfig.matchOutro.enabled then return end
    local map = paintballConfig.maps[PB.state.map] or paintballConfig.coopMaps[PB.state.map]
    if not map or not map.center then return end
    CreateThread(function()
        Wait(500)
        local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
        SetCamFov(cam, 50.0)
        local offset = paintballConfig.matchOutro.cameraOffset or vec3(0.0, -6.0, 3.0)
        AttachCamToEntity(cam, SUN.ped, offset.x, offset.y, offset.z, true)
        PointCamAtEntity(cam, SUN.ped, 0.0, 0.0, 0.5, true)
        RenderScriptCams(true, true, 500, false, false)
        SetCamActive(cam, true)
        SUN.SendUIData(PB.HUD, {type = 'matchOutro', payload = {active = true, duration = paintballConfig.matchOutro.duration or 8, winner = payload.winner, summary = payload.summary, mode = payload.mode}})
        local duration = (paintballConfig.matchOutro.duration or 8) * 1000
        Wait(duration)
        RenderScriptCams(false, true, 500, false, false)
        Wait(600)
        DestroyCam(cam, false)
        SUN.SendUIData(PB.HUD, {type = 'matchOutro', payload = {active = false}})
    end)
end)

AddEventHandler('paintball:cleanup', function()
    if activeSpyPlane then
        if activeSpyPlane.heli and DoesEntityExist(activeSpyPlane.heli) then DeleteEntity(activeSpyPlane.heli) end
        if activeSpyPlane.blip and DoesBlipExist(activeSpyPlane.blip) then RemoveBlip(activeSpyPlane.blip) end
        activeSpyPlane = nil
    end
    if activeAttackHeli then
        if activeAttackHeli.heli and DoesEntityExist(activeAttackHeli.heli) then DeleteEntity(activeAttackHeli.heli) end
        if activeAttackHeli.blip and DoesBlipExist(activeAttackHeli.blip) then RemoveBlip(activeAttackHeli.blip) end
        activeAttackHeli = nil
    end
    for _, m in pairs(spotMarks) do
        if m.blip and DoesBlipExist(m.blip) then RemoveBlip(m.blip) end
    end
    spotMarks = {}
    SetRadarZoom(1100)
end)

AddEventHandler('onResourceStop', function(rn)
    if GetCurrentResourceName() == rn then
        if activeSpyPlane and activeSpyPlane.heli and DoesEntityExist(activeSpyPlane.heli) then DeleteEntity(activeSpyPlane.heli) end
        if activeAttackHeli and activeAttackHeli.heli and DoesEntityExist(activeAttackHeli.heli) then DeleteEntity(activeAttackHeli.heli) end
        for _, m in pairs(spotMarks) do if m.blip and DoesBlipExist(m.blip) then RemoveBlip(m.blip) end end
    end
end)
