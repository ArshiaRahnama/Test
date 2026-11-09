-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.HUD = PB.HUD or 'paintball-hud'
PB.killstreaks = PB.killstreaks or {}

local activeUAV = nil
local enemyBlips = {}

local function clearEnemyBlips()
    for _, b in pairs(enemyBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    enemyBlips = {}
end

RegisterNetEvent('paintball:uavStart', function(payload)
    if activeUAV and activeUAV.heli and DoesEntityExist(activeUAV.heli) then
        DeleteEntity(activeUAV.heli)
    end
    clearEnemyBlips()
    activeUAV = {
        owner = payload.owner,
        ownerTeam = payload.ownerTeam,
        myTeam = payload.yourTeam,
        center = payload.mapCenter,
        endAt = GetGameTimer() + (payload.duration * 1000),
        heli = nil,
        heliBlip = nil,
        flyAwayDistance = payload.flyAwayDistance or 600.0,
        flyAwayDuration = payload.flyAwayDuration or 12000,
        markEnemies = (payload.ownerTeam == payload.yourTeam) or (payload.isOwner) or (payload.ownerTeam == 0 and payload.owner == GetPlayerServerId(SUN.PlayerId)),
    }

    if payload.isOwner and payload.mapCenter then
        local hash = GetHashKey(payload.heliModel or 'buzzard2')
        ESX.Streaming.RequestModel(hash)
        local cx, cy, cz = payload.mapCenter.x, payload.mapCenter.y, payload.mapCenter.z + (payload.height or 80.0)
        local heli = CreateVehicle(hash, cx + (payload.radius or 200.0), cy, cz, 0.0, true, false)
        SetVehicleEngineOn(heli, true, true, false)
        SetEntityInvincible(heli, false)
        SetEntityMaxHealth(heli, payload.hp or 1500)
        SetEntityHealth(heli, payload.hp or 1500)
        SetVehicleDoorsLocked(heli, 4)
        SetEntityCanBeDamaged(heli, true)
        SetVehicleCanBeVisiblyDamaged(heli, true)
        SetModelAsNoLongerNeeded(hash)

        local pilotHash = GetHashKey('s_m_y_pilot_01')
        ESX.Streaming.RequestModel(pilotHash)
        local pilot = CreatePedInsideVehicle(heli, 4, pilotHash, -1, true, false)
        SetPedRandomComponentVariation(pilot, 0)
        SetPedKeepTask(pilot, true)
        SetEntityInvincible(pilot, true)
        SetModelAsNoLongerNeeded(pilotHash)

        TaskHeliMission(pilot, heli, 0, 0, cx, cy, cz, 6, payload.speed or 30.0, (payload.radius or 200.0) - 30.0, -1.0, 30, 30, 50.0, 0)

        activeUAV.heli = heli
        activeUAV.pilot = pilot

        local blip = AddBlipForEntity(heli)
        SetBlipSprite(blip, 422)
        SetBlipColour(blip, 17)
        SetBlipScale(blip, 0.9)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('UAV')
        EndTextCommandSetBlipName(blip)
        activeUAV.heliBlip = blip
    end

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'UAV فعال شد!', duration = 3}})
end)

RegisterNetEvent('paintball:uavEnd', function(info)
    if activeUAV then
        local heli = activeUAV.heli
        local heliBlip = activeUAV.heliBlip
        local pilot = activeUAV.pilot
        if heli and DoesEntityExist(heli) then
            if info.reason == 'shotdown' then
                NetworkExplodeVehicle(heli, true, false, 0)
                SetTimeout(3000, function()
                    if DoesEntityExist(heli) then DeleteEntity(heli) end
                    if heliBlip and DoesBlipExist(heliBlip) then RemoveBlip(heliBlip) end
                end)
            else
                local center = activeUAV.center
                local flyDist = activeUAV.flyAwayDistance or 600.0
                local flyDuration = activeUAV.flyAwayDuration or 12000
                if center and pilot and DoesEntityExist(pilot) then
                    local angle = math.random() * 6.28
                    local awayX = center.x + math.cos(angle) * flyDist
                    local awayY = center.y + math.sin(angle) * flyDist
                    local awayZ = center.z + 200.0
                    TaskHeliMission(pilot, heli, 0, 0, awayX, awayY, awayZ, 4, 60.0, 30.0, -1.0, 30, 30, 50.0, 0)
                end
                SetTimeout(flyDuration, function()
                    if heli and DoesEntityExist(heli) then DeleteEntity(heli) end
                    if heliBlip and DoesBlipExist(heliBlip) then RemoveBlip(heliBlip) end
                end)
            end
        end
        clearEnemyBlips()
        activeUAV = nil
    end
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = info.reason == 'shotdown' and 'UAV ساقط شد' or 'UAV پایان یافت', duration = 3}})
end)

local uavRunning = false
local function startUav()
    if uavRunning then return end
    uavRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if activeUAV and activeUAV.heli and DoesEntityExist(activeUAV.heli) then
                if IsEntityDead(activeUAV.heli) then
                    TriggerServerEvent('paintball:uavShotDown', activeUAV.owner)
                    Wait(2000)
                elseif activeUAV.markEnemies and PB.state.inMatch then
                    clearEnemyBlips()
                    local myTeam = activeUAV.myTeam
                    local mode = PB.state.mode
                    local isSolo = (mode == 'ffa' or mode == 'gungame')
                    if PB.iterateMatchPlayers then
                        PB.iterateMatchPlayers(function(sid, team, pid, ped)
                            local enemy = isSolo or (myTeam and team and team ~= myTeam and team > 0)
                            if enemy then
                                local blip = AddBlipForEntity(ped)
                                SetBlipSprite(blip, 1)
                                SetBlipColour(blip, 1)
                                SetBlipScale(blip, 0.85)
                                SetBlipAsShortRange(blip, false)
                                BeginTextCommandSetBlipName('STRING')
                                AddTextComponentString('Enemy')
                                EndTextCommandSetBlipName(blip)
                                enemyBlips[#enemyBlips + 1] = blip
                            end
                        end)
                    end
                    Wait(2000)
                else
                    Wait(1500)
                end
            else
                if #enemyBlips > 0 then clearEnemyBlips() end
                Wait(1500)
            end
        end
        uavRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startUav)

local airstrikeMarker = nil
local airstrikeMarking = false

local function cleanupMarker()
    if airstrikeMarker and DoesBlipExist(airstrikeMarker) then RemoveBlip(airstrikeMarker) end
    airstrikeMarker = nil
end

local function getCameraAimTarget(maxDistance)
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local rotZ = math.rad(camRot.z)
    local rotX = math.rad(camRot.x)
    local cosX = math.cos(rotX)
    local fwd = vec3(-math.sin(rotZ) * cosX, math.cos(rotZ) * cosX, math.sin(rotX))
    local endC = vec3(camCoords.x + fwd.x * maxDistance, camCoords.y + fwd.y * maxDistance, camCoords.z + fwd.z * maxDistance)
    local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, endC.x, endC.y, endC.z, -1, SUN.ped, 0)
    local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)
    if hit == 1 then return hitCoords end
    return endC
end

RegisterNetEvent('paintball:airstrike:promptMark', function()
    if airstrikeMarking then return end
    airstrikeMarking = true
    ESX.TriggerServerCallback('paintball:airstrike:requestMark', function(result)
        if not result or not result.ok then airstrikeMarking = false; return end
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'لیزر دزیگنیتور فعال — E برای مارک', duration = 6}})
        ESX.notification('warning', 'با موس نشانه بگیر و E بزن')
        local startedAt = GetGameTimer()
        local endAt = startedAt + ((result.markerTime or 60) * 1000)

        CreateThread(function()
            while airstrikeMarking and GetGameTimer() < endAt do
                local target = getCameraAimTarget(800.0)
                if target then
                    DrawMarker(28, target.x, target.y, target.z + 0.2, 0,0,0, 0,0,0, 1.5, 1.5, 1.5, 255, 32, 48, 200, false, false, 2, false, false, false, false)
                    DrawMarker(1, target.x, target.y, target.z - 1.0, 0,0,0, 0,0,0, 12.0, 12.0, 0.5, 255, 32, 48, 80, false, false, 2, false, false, false, false)
                    local camCoords = GetGameplayCamCoord()
                    DrawLine(camCoords.x, camCoords.y, camCoords.z, target.x, target.y, target.z, 255, 32, 48, 220)
                end
                Wait(0)
            end
            airstrikeMarking = false
        end)
    end)
end)

AddEventHandler('KeyDown:e', function()
    if not airstrikeMarking then return end
    local target = getCameraAimTarget(800.0)
    if not target then
        airstrikeMarking = false
        return
    end
    local finalX, finalY, finalZ = target.x, target.y, target.z
    local groundOk, gz = GetGroundZFor_3dCoord(target.x, target.y, target.z + 5.0, false)
    if groundOk then finalZ = gz end
    TriggerServerEvent('paintball:airstrike:confirmMark', {x = finalX, y = finalY, z = finalZ})
    ESX.notification('success', ('Airstrike در (%d, %d) درخواست شد'):format(math.floor(finalX), math.floor(finalY)))
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'مارک شد!', duration = 3}})
    airstrikeMarking = false
end)

AddEventHandler('KeyDown:k', function()
    if not airstrikeMarking then return end
    ESX.notification('warning', 'Airstrike لغو شد')
    airstrikeMarking = false
end)

RegisterNetEvent('paintball:airstrikeIncoming', function(payload)
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = ('حمله هوایی در %d ثانیه'):format(payload.delaySec or 12), duration = 5}})
    if payload.warningSound then
        PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true)
    end

    cleanupMarker()
    airstrikeMarker = AddBlipForRadius(payload.coords.x, payload.coords.y, payload.coords.z, payload.radius or 12.0)
    SetBlipColour(airstrikeMarker, 1)
    SetBlipAlpha(airstrikeMarker, 130)

    SetTimeout((payload.delaySec or 15) * 1000, function()
        if airstrikeMarker and DoesBlipExist(airstrikeMarker) then RemoveBlip(airstrikeMarker) end
        airstrikeMarker = nil

        if payload.isOwner then
            local jetCount = payload.jetCount or 3
            local spacing = payload.jetSpacing or 25.0
            local cruiseAlt = payload.altitude or 350.0
            local diveExitAlt = 60.0
            local approachDistance = payload.approachDistance or 800.0
            local exitDistance = 1500.0
            local jetHash = GetHashKey(payload.jetModel or 'lazer')
            local pilotHash = GetHashKey('s_m_y_pilot_01')
            ESX.Streaming.RequestModel(jetHash)
            ESX.Streaming.RequestModel(pilotHash)

            local approachAngle = math.random() * 6.28
            local cosA, sinA = math.cos(approachAngle), math.sin(approachAngle)
            local perpX = -sinA
            local perpY = cosA

            local target = payload.coords
            local cruiseStartX = target.x + cosA * approachDistance
            local cruiseStartY = target.y + sinA * approachDistance
            local cruiseStartZ = target.z + cruiseAlt
            local exitX = target.x - cosA * exitDistance
            local exitY = target.y - sinA * exitDistance
            local exitZ = target.z + cruiseAlt + 40.0

            local heading = math.deg(math.atan2(exitY - cruiseStartY, exitX - cruiseStartX)) - 90.0

            for i = 1, jetCount do
                local offset = (i - math.ceil(jetCount / 2)) * spacing
                local sx = cruiseStartX + perpX * offset
                local sy = cruiseStartY + perpY * offset
                local jet = CreateVehicle(jetHash, sx, sy, cruiseStartZ, heading, true, false)
                SetVehicleEngineOn(jet, true, true, false)
                SetVehicleForwardSpeed(jet, payload.speed or 280.0)
                SetEntityInvincible(jet, true)
                SetEntityCollision(jet, false, false)

                local pilot = CreatePedInsideVehicle(jet, 4, pilotHash, -1, true, false)
                SetEntityInvincible(pilot, true)
                SetModelAsNoLongerNeeded(pilotHash)

                CreateThread(function()
                    if not DoesEntityExist(jet) then return end
                    local approachT = 6.0
                    local approachStart = GetGameTimer()
                    while DoesEntityExist(jet) and (GetGameTimer() - approachStart) < (approachT * 1000) do
                        local p = GetGameTimer() - approachStart
                        local pct = p / (approachT * 1000)
                        local cx = cruiseStartX + (target.x + perpX * offset - cruiseStartX) * pct * 0.55
                        local cy = cruiseStartY + (target.y + perpY * offset - cruiseStartY) * pct * 0.55
                        local cz = cruiseStartZ
                        SetEntityCoordsNoOffset(jet, cx, cy, cz, false, false, false)
                        SetEntityHeading(jet, heading)
                        SetVehicleForwardSpeed(jet, payload.speed or 80.0)
                        Wait(0)
                    end

                    local diveT = 4.5
                    local diveStart = GetGameTimer()
                    local diveStartCoords = GetEntityCoords(jet)
                    local diveTargetX = target.x + perpX * offset
                    local diveTargetY = target.y + perpY * offset
                    local diveTargetZ = target.z + diveExitAlt
                    while DoesEntityExist(jet) and (GetGameTimer() - diveStart) < (diveT * 1000) do
                        local p = GetGameTimer() - diveStart
                        local pct = math.min(1.0, p / (diveT * 1000))
                        local easedPct = pct * pct
                        local cx = diveStartCoords.x + (diveTargetX - diveStartCoords.x) * pct
                        local cy = diveStartCoords.y + (diveTargetY - diveStartCoords.y) * pct
                        local cz = diveStartCoords.z + (diveTargetZ - diveStartCoords.z) * easedPct
                        SetEntityCoordsNoOffset(jet, cx, cy, cz, false, false, false)
                        local pitchAngle = -18.0 - (pct * 8.0)
                        SetEntityRotation(jet, pitchAngle, 0.0, heading, 2, true)
                        SetVehicleForwardSpeed(jet, (payload.speed or 80.0) * 0.7)
                        Wait(0)
                    end
                end)

                CreateThread(function()
                    Wait(8500)
                    local missilesPerJet = math.ceil((payload.count or 14) / jetCount)
                    for m = 1, missilesPerJet do
                        if not DoesEntityExist(jet) then return end
                        local jp = GetEntityCoords(jet)
                        local angle = math.random() * 6.28
                        local r = math.random() * (payload.radius or 12.0)
                        local tx = target.x + math.cos(angle) * r + perpX * offset
                        local ty = target.y + math.sin(angle) * r + perpY * offset
                        local tz = target.z
                        ShootSingleBulletBetweenCoords(jp.x, jp.y, jp.z, tx, ty, tz, 500, false, GetHashKey('WEAPON_RPG'), pilot, true, true, 2000.0)
                        TriggerServerEvent('paintball:broadcastExplosion', {x = tx, y = ty, z = tz, type = payload.explosionType or 2, scale = 1.0})
                        Wait(220)
                    end
                end)

                CreateThread(function()
                    Wait(13000)
                    if not DoesEntityExist(jet) then return end
                    local pullT = 6.0
                    local pullStart = GetGameTimer()
                    local pullStartCoords = GetEntityCoords(jet)
                    while DoesEntityExist(jet) and (GetGameTimer() - pullStart) < (pullT * 1000) do
                        local p = GetGameTimer() - pullStart
                        local pct = math.min(1.0, p / (pullT * 1000))
                        local cx = pullStartCoords.x + (exitX + perpX * offset - pullStartCoords.x) * pct
                        local cy = pullStartCoords.y + (exitY + perpY * offset - pullStartCoords.y) * pct
                        local cz = pullStartCoords.z + (exitZ - pullStartCoords.z) * pct
                        SetEntityCoordsNoOffset(jet, cx, cy, cz, false, false, false)
                        local pitchAngle = 22.0 - (pct * 14.0)
                        SetEntityRotation(jet, pitchAngle, 0.0, heading, 2, true)
                        SetVehicleForwardSpeed(jet, (payload.speed or 80.0) * 0.9)
                        Wait(0)
                    end
                    Wait(3000)
                    if DoesEntityExist(jet) then DeleteEntity(jet) end
                end)
            end
            SetModelAsNoLongerNeeded(jetHash)
        end
    end)
end)

RegisterNetEvent('paintball:drawExplosion', function(payload)
    if not payload then return end
    local x = tonumber(payload.x) or 0
    local y = tonumber(payload.y) or 0
    local z = tonumber(payload.z) or 0
    local t = tonumber(payload.type) or 2
    local scale = tonumber(payload.scale) or 1.0
    local delay = tonumber(payload.delay) or 0
    if delay > 0 then
        SetTimeout(delay, function()
            AddExplosion(x, y, z, t, scale, true, false, 1.0)
        end)
    else
        AddExplosion(x, y, z, t, scale, true, false, 1.0)
    end
end)

local activeCarePackage = nil

local function pickupModelHash(name)
    local h = GetHashKey(name)
    if IsModelInCdimage(h) and IsModelValid(h) then return h end
    return 0
end

local function cleanupCarePackage(cp)
    if not cp then return end
    if cp.blip and DoesBlipExist(cp.blip) then RemoveBlip(cp.blip) end
    if cp.heliBlip and DoesBlipExist(cp.heliBlip) then RemoveBlip(cp.heliBlip) end
    if cp.parachute and DoesEntityExist(cp.parachute) then
        DetachEntity(cp.parachute, true, true)
        DeleteEntity(cp.parachute)
    end
    if cp.flare and DoesEntityExist(cp.flare) then DeleteEntity(cp.flare) end
    if cp.flarePtfx then
        pcall(function() StopParticleFxLooped(cp.flarePtfx, 0) end)
        cp.flarePtfx = nil
    end
    if cp.crate and DoesEntityExist(cp.crate) then DeleteEntity(cp.crate) end
    if cp.pilot and DoesEntityExist(cp.pilot) then DeleteEntity(cp.pilot) end
    if cp.heli and DoesEntityExist(cp.heli) then DeleteEntity(cp.heli) end
    if activeCarePackage == cp then
        activeCarePackage = nil
        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = nil})
    end
end

local function applyLoot(cp)
    local payload = cp.payload
    pcall(function() TriggerServerEvent('paintball:soundBroadcast', 'madejugger', 0.5) end)
    PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', false)
    if payload.loot == 'rpg' and payload.rpgKit then
        local kit = payload.rpgKit
        local h = GetHashKey(kit.weapon or 'WEAPON_RPG')
        GiveWeaponToPed(SUN.ped, h, kit.ammo or 5, false, true)
        SetPedAmmo(SUN.ped, h, kit.ammo or 5)
        if kit.secondary then
            GiveWeaponToPed(SUN.ped, GetHashKey(kit.secondary), kit.secondaryAmmo or 250, false, false)
        end
        SetCurrentPedWeapon(SUN.ped, h, true)
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'RPG Kit دریافت شد!', duration = 4}})
        ESX.notification('success', 'RPG با ' .. (kit.ammo or 5) .. ' تیر دریافت شد')
    elseif payload.loot == 'juggernaut' and payload.juggernautKit then
        local kit = payload.juggernautKit
        local dur = kit.duration or 30
        SetEntityMaxHealth(SUN.ped, kit.health or 400)
        ESX.SetEntityHealth(SUN.ped, kit.health or 400)
        ESX.SetPedArmour(SUN.ped, kit.armor or 250)
        if kit.outfit then
            TriggerEvent('skinchanger:getSkin', function(skin)
                local set = (tonumber(skin.sex) == 0) and kit.outfit.male or kit.outfit.female
                TriggerEvent('skinchanger:loadClothes', skin, set)
            end)
        end
        if kit.weapon then
            local wh = GetHashKey(kit.weapon)
            GiveWeaponToPed(SUN.ped, wh, kit.weaponAmmo or 500, false, true)
            SetPedAmmo(SUN.ped, wh, kit.weaponAmmo or 500)
            SetCurrentPedWeapon(SUN.ped, wh, true)
        end
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = ('🦾 JUGGERNAUT برای %d ثانیه!'):format(dur), duration = 4}})
        ESX.notification('success', ('تو الان JUGGERNAUT هستی! %d ثانیه'):format(dur))
        SetTimeout(dur * 1000, function()
            SetEntityMaxHealth(SUN.ped, 200)
            ESX.SetEntityHealth(SUN.ped, math.min(200, GetEntityHealth(SUN.ped)))
            ESX.SetPedArmour(SUN.ped, 0)
            ESX.notification('warning', 'حالت JUGGERNAUT تموم شد')
        end)
    end
end

RegisterNetEvent('paintball:carePackageDrop', function(payload)
    while not ESX do Wait(50) end
    if activeCarePackage then cleanupCarePackage(activeCarePackage) end

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = '🚁 هلیکوپتر در حال نزدیک شدن', duration = 5}})
    local cfg = paintballConfig.killstreaks and paintballConfig.killstreaks.carePackage or {}

    local crateHash = pickupModelHash(payload.crateModel or 'ch_prop_box_ammo01b')
    if crateHash == 0 then
        for _, m in ipairs(payload.crateModelFallbacks or {'prop_box_ammo07a', 'prop_box_ammo04a', 'prop_mil_crate_01'}) do
            crateHash = pickupModelHash(m)
            if crateHash ~= 0 then break end
        end
    end
    if crateHash == 0 then
        ESX.notification('error', 'مدل crate یافت نشد')
        return
    end

    local heliHash = pickupModelHash(payload.heliModel or 'buzzard2')
    if heliHash == 0 then heliHash = pickupModelHash('buzzard') end
    if heliHash == 0 then heliHash = pickupModelHash('frogger') end
    local pilotHash = pickupModelHash('s_m_y_pilot_01')
    if pilotHash == 0 then pilotHash = pickupModelHash('s_m_m_pilot_01') end
    local parachuteHash = pickupModelHash(payload.parachuteModel or 'p_parachute1_s')
    if parachuteHash == 0 then parachuteHash = pickupModelHash('p_parachute1_sp_s') end
    local flareHash = pickupModelHash(payload.flareModel or 'prop_flare_01a')

    ESX.Streaming.RequestModel(crateHash)
    if heliHash ~= 0 then ESX.Streaming.RequestModel(heliHash) end
    if pilotHash ~= 0 then ESX.Streaming.RequestModel(pilotHash) end
    if parachuteHash ~= 0 then ESX.Streaming.RequestModel(parachuteHash) end
    if flareHash ~= 0 then ESX.Streaming.RequestModel(flareHash) end

    local coords = GetEntityCoords(SUN.ped)
    local fwd = GetEntityForwardVector(SUN.ped)
    local dropX = coords.x + fwd.x * 4.0
    local dropY = coords.y + fwd.y * 4.0
    local groundOk, groundZ = GetGroundZFor_3dCoord(dropX, dropY, coords.z + 5.0, false)
    local landingZ = groundOk and groundZ or coords.z

    local heliApproachDist = payload.heliSpawnDistance or 250.0
    local heliAlt = payload.heliAltitude or 75.0
    local heliSpeed = payload.heliApproachSpeed or 35.0
    local angle = math.random() * math.pi * 2
    local heliStartX = dropX + math.cos(angle) * heliApproachDist
    local heliStartY = dropY + math.sin(angle) * heliApproachDist
    local heliFlightZ = landingZ + heliAlt

    local cp = {
        payload = payload,
        picked = false,
        landed = false,
        dropX = dropX, dropY = dropY, landingZ = landingZ,
    }
    activeCarePackage = cp

    if heliHash ~= 0 and pilotHash ~= 0 then
        cp.heli = CreateVehicle(heliHash, heliStartX, heliStartY, heliFlightZ, 0.0, true, false)
        if cp.heli and DoesEntityExist(cp.heli) then
            SetEntityInvincible(cp.heli, true)
            SetVehicleEngineOn(cp.heli, true, true, true)
            SetHeliBladesFullSpeed(cp.heli)
            SetVehicleDoorsLocked(cp.heli, 4)
            SetEntityCollision(cp.heli, false, false)
            cp.pilot = CreatePedInsideVehicle(cp.heli, 4, pilotHash, -1, true, false)
            if cp.pilot and DoesEntityExist(cp.pilot) then
                SetEntityInvincible(cp.pilot, true)
                SetPedKeepTask(cp.pilot, true)
                SetBlockingOfNonTemporaryEvents(cp.pilot, true)
                TaskHeliMission(cp.pilot, cp.heli, 0, 0, dropX, dropY, heliFlightZ, 4, heliSpeed, 5.0, -1.0, 30, 30, 30.0, 1)
            end
            cp.heliBlip = AddBlipForEntity(cp.heli)
            SetBlipSprite(cp.heliBlip, 422)
            SetBlipColour(cp.heliBlip, 2)
            SetBlipScale(cp.heliBlip, 0.9)
            SetBlipAsShortRange(cp.heliBlip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Care Package Heli')
            EndTextCommandSetBlipName(cp.heliBlip)
        end
        SetModelAsNoLongerNeeded(heliHash)
        SetModelAsNoLongerNeeded(pilotHash)
    end

    cp.heliReady = cp.heli and DoesEntityExist(cp.heli) and cp.pilot and DoesEntityExist(cp.pilot)
    cp.startedAt = GetGameTimer()
    cp.crateHash = crateHash
    cp.parachuteHash = parachuteHash
    cp.flareHash = flareHash

    CreateThread(function()
        local maxWait = 180000
        local cratePoint = nil

        while activeCarePackage == cp and GetGameTimer() - cp.startedAt < maxWait do
            if cp.heliReady and cp.heli and DoesEntityExist(cp.heli) and not cratePoint then
                local hp = GetEntityCoords(cp.heli)
                local d2 = math.sqrt((hp.x - dropX)^2 + (hp.y - dropY)^2)
                if d2 < 10.0 then
                    cratePoint = hp
                    cp.crate = CreateObject(cp.crateHash, hp.x, hp.y, hp.z - 1.5, true, true, false)
                    SetModelAsNoLongerNeeded(cp.crateHash)
                    if cp.crate and DoesEntityExist(cp.crate) then
                        SetEntityDynamic(cp.crate, true)
                        ActivatePhysics(cp.crate)
                        SetEntityHasGravity(cp.crate, true)
                        SetEntityCollision(cp.crate, true, true)
                        SetEntityVelocity(cp.crate, 0.0, 0.0, -1.0)
                        if cp.parachuteHash ~= 0 then
                            cp.parachute = CreateObject(cp.parachuteHash, hp.x, hp.y, hp.z + 0.5, true, true, false)
                            if cp.parachute and DoesEntityExist(cp.parachute) then
                                SetEntityCollision(cp.parachute, false, false)
                                AttachEntityToEntity(cp.parachute, cp.crate, 0, 0.0, 0.0, 1.8, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                                SetModelAsNoLongerNeeded(cp.parachuteHash)
                            end
                        end
                        cp.blip = AddBlipForEntity(cp.crate)
                        SetBlipSprite(cp.blip, 477)
                        SetBlipColour(cp.blip, 2)
                        SetBlipScale(cp.blip, 1.2)
                        SetBlipAsShortRange(cp.blip, false)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentString('Care Package')
                        EndTextCommandSetBlipName(cp.blip)
                        cp.droppedAt = GetGameTimer()
                    end
                    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = '📦 بسته در حال نزول با چتر', duration = 3}})
                    if cp.pilot and DoesEntityExist(cp.pilot) and cp.heli and DoesEntityExist(cp.heli) then
                        local exitAngle = angle + math.pi
                        local exitX = dropX + math.cos(exitAngle) * (heliApproachDist * 3.0)
                        local exitY = dropY + math.sin(exitAngle) * (heliApproachDist * 3.0)
                        TaskHeliMission(cp.pilot, cp.heli, 0, 0, exitX, exitY, heliFlightZ + 60.0, 4, heliSpeed * 1.8, 30.0, -1.0, 30, 30, 30.0, 0)
                    end
                    SetTimeout(20000, function()
                        if cp.heli and DoesEntityExist(cp.heli) then DeleteEntity(cp.heli) end
                        if cp.pilot and DoesEntityExist(cp.pilot) then DeleteEntity(cp.pilot) end
                        if cp.heliBlip and DoesBlipExist(cp.heliBlip) then RemoveBlip(cp.heliBlip) end
                        cp.heli = nil; cp.pilot = nil; cp.heliBlip = nil
                    end)
                end
            end

            if not cratePoint and not cp.heliReady and GetGameTimer() - cp.startedAt > 2000 then
                cratePoint = vector3(dropX, dropY, landingZ + 60.0)
                cp.crate = CreateObject(cp.crateHash, cratePoint.x, cratePoint.y, cratePoint.z, true, true, false)
                SetModelAsNoLongerNeeded(cp.crateHash)
                if cp.crate and DoesEntityExist(cp.crate) then
                    SetEntityDynamic(cp.crate, true)
                    ActivatePhysics(cp.crate)
                    SetEntityHasGravity(cp.crate, true)
                    SetEntityCollision(cp.crate, true, true)
                    SetEntityVelocity(cp.crate, 0.0, 0.0, -1.0)
                    if cp.parachuteHash ~= 0 then
                        cp.parachute = CreateObject(cp.parachuteHash, cratePoint.x, cratePoint.y, cratePoint.z + 0.5, true, true, false)
                        if cp.parachute and DoesEntityExist(cp.parachute) then
                            SetEntityCollision(cp.parachute, false, false)
                            AttachEntityToEntity(cp.parachute, cp.crate, 0, 0.0, 0.0, 1.8, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                            SetModelAsNoLongerNeeded(cp.parachuteHash)
                        end
                    end
                    cp.blip = AddBlipForEntity(cp.crate)
                    SetBlipSprite(cp.blip, 477)
                    SetBlipColour(cp.blip, 2)
                    SetBlipScale(cp.blip, 1.2)
                    SetBlipAsShortRange(cp.blip, false)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString('Care Package')
                    EndTextCommandSetBlipName(cp.blip)
                    cp.droppedAt = GetGameTimer()
                end
            end

            if cp.crate and DoesEntityExist(cp.crate) and not cp.landed then
                local cur = GetEntityCoords(cp.crate)
                local vel = GetEntityVelocity(cp.crate)
                local vx, vy, vz = vel.x or 0.0, vel.y or 0.0, vel.z or 0.0
                local targetVz = -(payload.dropFallSpeed or cfg.dropFallSpeed or 1.8)
                if vz < targetVz - 1.0 then
                    SetEntityVelocity(cp.crate, vx * 0.5, vy * 0.5, targetVz)
                end
                local gOk, gZ = GetGroundZFor_3dCoord(cur.x, cur.y, cur.z + 2.0, false)
                local nearGround = gOk and (cur.z - gZ) < 1.5
                local fallTimeout = cp.droppedAt and (GetGameTimer() - cp.droppedAt) > 35000
                if nearGround or fallTimeout then
                    cp.landed = true
                    local landZ = gOk and gZ or cur.z
                    if cp.parachute and DoesEntityExist(cp.parachute) then
                        DetachEntity(cp.parachute, true, true)
                        DeleteEntity(cp.parachute)
                        cp.parachute = nil
                    end
                    SetEntityCoords(cp.crate, cur.x, cur.y, landZ + 0.2, false, false, false, false)
                    PlaceObjectOnGroundProperly(cp.crate)
                    FreezeEntityPosition(cp.crate, true)
                    SetEntityHasGravity(cp.crate, false)
                    local lc = GetEntityCoords(cp.crate)
                    if cp.flareHash ~= 0 then
                        cp.flare = CreateObject(cp.flareHash, lc.x, lc.y, lc.z + 0.4, true, true, false)
                        if cp.flare and DoesEntityExist(cp.flare) then
                            SetEntityHasGravity(cp.flare, false)
                            FreezeEntityPosition(cp.flare, true)
                            SetModelAsNoLongerNeeded(cp.flareHash)
                        end
                        cp.flareEndAt = GetGameTimer() + (payload.flareDuration or 30000)
                        UseParticleFxAssetNextCall('core')
                        cp.flarePtfx = StartParticleFxLoopedAtCoord('exp_grd_flare', lc.x, lc.y, lc.z + 0.4, 0.0, 0.0, 0.0, 1.2, false, false, false, false)
                    end
                    PlaySoundFromCoord(-1, 'Hit_Generic', lc.x, lc.y, lc.z, 'GTAO_Magnate_Yacht_Cannon_Sounds', false, 100, false)
                    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = '✅ بسته فرود اومد! [E] برای loot', duration = 5}})
                end
            end

            if cp.flare and cp.flareEndAt and GetGameTimer() > cp.flareEndAt then
                if DoesEntityExist(cp.flare) then DeleteEntity(cp.flare) end
                cp.flare = nil
                if cp.flarePtfx then
                    pcall(function() StopParticleFxLooped(cp.flarePtfx, 0) end)
                    cp.flarePtfx = nil
                end
            end

            if cp.landed and DoesEntityExist(cp.crate) then
                local cur = GetEntityCoords(cp.crate)
                local d = #(GetEntityCoords(SUN.ped) - cur)
                local pickupRadius = (payload and payload.lootDistance) or 3.0
                if d < pickupRadius and not IsPedDeadOrDying(SUN.ped, true) then
                    SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = {site = '📦 Care Package [E]'}})
                    cp.inRange = true
                else
                    if cp.inRange then
                        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = nil})
                        cp.inRange = false
                    end
                end
            end

            Wait(50)
        end

        if activeCarePackage == cp then
            cleanupCarePackage(cp)
        end
    end)
end)

local function tryLootCarePackage()
    local cp = activeCarePackage
    if not cp or not cp.landed or cp.picked then return false end
    if not cp.crate or not DoesEntityExist(cp.crate) then return false end
    if IsPedDeadOrDying(SUN.ped, true) then return false end
    local cur = GetEntityCoords(cp.crate)
    local d = #(GetEntityCoords(SUN.ped) - cur)
    local pickupRadius = (cp.payload and cp.payload.lootDistance) or 2.5
    if d > pickupRadius then return false end
    if cp.requesting then return false end
    cp.requesting = true
    if cp.payload and cp.payload.cpId then
        ESX.TriggerServerCallback('paintball:carePackageLoot', function(ok, reason)
            cp.requesting = false
            if not ok then
                if reason == 'already_looted' then
                    ESX.notification('error', 'یکی دیگه قبل از تو لوت کرد')
                end
                return
            end
            cp.picked = true
            SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = nil})
            applyLoot(cp)
            cleanupCarePackage(cp)
        end, cp.payload.cpId)
    else
        cp.picked = true
        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = nil})
        applyLoot(cp)
        cleanupCarePackage(cp)
    end
    return true
end

AddEventHandler('KeyDown:e', function()
    tryLootCarePackage()
end)

local carePackageRunning = false
local function startCarePackage()
    if carePackageRunning then return end
    carePackageRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            local cp = activeCarePackage
            if cp and cp.landed and not cp.picked and cp.crate and DoesEntityExist(cp.crate) then
                local cur = GetEntityCoords(cp.crate)
                local d = #(GetEntityCoords(SUN.ped) - cur)
                local pickupRadius = (cp.payload and cp.payload.lootDistance) or 3.0
                if d < pickupRadius then
                    SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = {site = 'Care Package [E]'}})
                    if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                        tryLootCarePackage()
                    end
                    Wait(0)
                else
                    Wait(150)
                end
            else
                Wait(600)
            end
        end
        carePackageRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startCarePackage)

local pbSentryHostileGroup = nil
local function getSentryHostileGroup()
    if pbSentryHostileGroup then return pbSentryHostileGroup end
    pbSentryHostileGroup = AddRelationshipGroup('PB_SENTRY_HOSTILE')
    SetRelationshipBetweenGroups(3, pbSentryHostileGroup, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(3, GetHashKey('PLAYER'), pbSentryHostileGroup)
    SetRelationshipBetweenGroups(3, pbSentryHostileGroup, GetHashKey('CIVMALE'))
    SetRelationshipBetweenGroups(3, pbSentryHostileGroup, GetHashKey('CIVFEMALE'))
    return pbSentryHostileGroup
end

RegisterNetEvent('paintball:sentrySpawn', function(payload)
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'Sentry Gun', duration = 3}})
    local hash = GetHashKey(payload.model or 's_m_m_marine_01')
    if not IsModelInCdimage(hash) then hash = GetHashKey('s_m_y_blackops_01') end
    ESX.Streaming.RequestModel(hash)

    local pCoords = GetEntityCoords(SUN.ped)
    local fwd = GetEntityForwardVector(SUN.ped)
    local spawnX = pCoords.x + fwd.x * 2.0
    local spawnY = pCoords.y + fwd.y * 2.0
    local spawnZ = pCoords.z
    local groundOk, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ + 1.0, false)
    if groundOk then spawnZ = groundZ end

    local heading = GetEntityHeading(SUN.ped) - 180.0
    local sentry = CreatePed(4, hash, spawnX, spawnY, spawnZ, heading, true, false)
    PlaceObjectOnGroundProperly(sentry)
    if sentry and NetworkGetEntityIsNetworked(sentry) then
        local netId = NetworkGetNetworkIdFromEntity(sentry)
        ESX.TriggerServerCallback('paintball:registerAIKill', function() end, netId, 'sentry')
    end
    SetEntityMaxHealth(sentry, payload.hp or 2500)
    SetEntityHealth(sentry, payload.hp or 2500)
    SetPedArmour(sentry, 500)
    SetPedSuffersCriticalHits(sentry, false)
    SetPedCanRagdoll(sentry, false)
    SetPedCanBeShotInVehicle(sentry, false)
    SetPedDiesWhenInjured(sentry, false)
    SetPedCanBeKnockedOffVehicle(sentry, 1)
    SetPedConfigFlag(sentry, 281, true)
    GiveWeaponToPed(sentry, GetHashKey(payload.weapon or 'WEAPON_COMBATMG'), 99999, true, true)
    SetPedInfiniteAmmo(sentry, true, GetHashKey(payload.weapon or 'WEAPON_COMBATMG'))
    SetPedInfiniteAmmoClip(sentry, true)
    SetPedAccuracy(sentry, payload.accuracy or 90)
    SetPedCombatAttributes(sentry, 0, true)
    SetPedCombatAttributes(sentry, 1, true)
    SetPedCombatAttributes(sentry, 2, true)
    SetPedCombatAttributes(sentry, 5, true)
    SetPedCombatAttributes(sentry, 17, true)
    SetPedCombatAttributes(sentry, 46, true)
    SetPedCombatAttributes(sentry, 52, true)
    SetPedCombatAttributes(sentry, 20, true)
    SetPedCombatAbility(sentry, 100)
    SetPedCombatRange(sentry, 3)
    SetPedCombatMovement(sentry, 3)
    SetPedAlertness(sentry, 3)
    SetPedSeeingRange(sentry, 250.0)
    SetPedHearingRange(sentry, 250.0)
    SetPedShootRate(sentry, 1000)
    local hostileGroup = getSentryHostileGroup()
    SetPedRelationshipGroupHash(sentry, hostileGroup)
    SetBlockingOfNonTemporaryEvents(sentry, false)
    SetPedFleeAttributes(sentry, 0, false)
    SetPedTargetLossResponse(sentry, 1)
    SetPedConfigFlag(sentry, 350, true)
    FreezeEntityPosition(sentry, true)
    SetModelAsNoLongerNeeded(hash)

    local sentryActive = true
    local myTeam = payload.team or PB.state.team or 0

    SetEntityCanBeDamagedByRelationshipGroup(SUN.ped, false, hostileGroup)

    CreateThread(function()
        local currentTarget = nil
        local isSolo = (PB.state.mode == 'ffa' or PB.state.mode == 'gungame')
        while sentryActive and DoesEntityExist(sentry) and not IsPedDeadOrDying(sentry, true) do
            SetEntityCanBeDamagedByRelationshipGroup(SUN.ped, false, hostileGroup)
            SetPedFleeAttributes(sentry, 0, false)
            SetBlockingOfNonTemporaryEvents(sentry, false)
            local closestPed, closestDist = nil, 200.0
            local sentryCoords = GetEntityCoords(sentry)
            if PB.iterateMatchPlayers then
                PB.iterateMatchPlayers(function(sid, team, pid, ped)
                    local isEnemy = isSolo or (team and team ~= myTeam and team > 0)
                    if isEnemy then
                        SetEntityCanBeDamagedByRelationshipGroup(ped, true, hostileGroup)
                        local d = #(sentryCoords - GetEntityCoords(ped))
                        if d < closestDist then closestPed, closestDist = ped, d end
                    else
                        SetEntityCanBeDamagedByRelationshipGroup(ped, false, hostileGroup)
                    end
                end)
            end
            if currentTarget and (not DoesEntityExist(currentTarget) or IsPedDeadOrDying(currentTarget, true)) then
                currentTarget = nil
            end
            if closestPed and (not currentTarget or currentTarget ~= closestPed) then
                currentTarget = closestPed
                TaskCombatPed(sentry, currentTarget, 0, 16)
            end
            if not closestPed and currentTarget then
                currentTarget = nil
            end
            Wait(300)
        end
    end)

    SetTimeout((payload.duration or 30) * 1000, function()
        sentryActive = false
        if DoesEntityExist(sentry) then DeleteEntity(sentry) end
    end)
end)

local activePredator = nil

RegisterNetEvent('paintball:predatorStart', function(payload)
    if activePredator and activePredator.drone and DoesEntityExist(activePredator.drone) then
        DeleteEntity(activePredator.drone)
    end

    activePredator = {
        owner = payload.owner,
        endAt = GetGameTimer() + (payload.duration * 1000),
        isOwner = payload.isOwner,
        drone = nil,
        blip = nil,
        savedCoords = nil,
        savedHeading = nil,
        cam = nil,
        impacted = false,
    }

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'Predator Drone — اوپراتور تو هستی', duration = 5}})

    if payload.isOwner and payload.mapCenter then
        local hash = GetHashKey(payload.droneModel or 'shahed136')
        ESX.Streaming.RequestModel(hash)
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then
            ESX.notification('error', 'مدل shahed136 لود نشد — fxmanifest چک کن')
            activePredator = nil
            return
        end

        local center = payload.mapCenter
        local angle = math.random() * 6.28
        local dist = payload.spawnDistance or 400.0
        local alt = payload.spawnAltitude or 150.0
        local sx = center.x + math.cos(angle) * dist
        local sy = center.y + math.sin(angle) * dist
        local sz = center.z + alt
        local heading = math.deg(math.atan2(center.y - sy, center.x - sx)) - 90.0

        local drone = CreateVehicle(hash, sx, sy, sz, heading, true, false)
        SetVehicleEngineOn(drone, true, true, true)
        SetVehicleEngineHealth(drone, 1000.0)
        SetVehicleFuelLevel(drone, 100.0)
        SetEntityInvincible(drone, false)
        SetVehicleForwardSpeed(drone, 55.0)
        SetEntityCollision(drone, true, true)
        SetHeliBladesFullSpeed(drone)
        SetModelAsNoLongerNeeded(hash)
        CreateThread(function()
            local pushStart = GetGameTimer()
            while activePredator and activePredator.drone == drone and DoesEntityExist(drone) and (GetGameTimer() - pushStart) < 3000 do
                local cur = GetEntityVelocity(drone)
                if cur.z < -2.0 then
                    SetEntityVelocity(drone, cur.x, cur.y, math.max(-1.0, cur.z + 0.5))
                end
                local speed = GetEntitySpeed(drone)
                if speed < 45.0 then
                    SetVehicleForwardSpeed(drone, 55.0)
                end
                Wait(100)
            end
        end)

        activePredator.drone = drone

        activePredator.savedCoords = GetEntityCoords(SUN.ped)
        activePredator.savedHeading = GetEntityHeading(SUN.ped)
        PB.state.inAC130 = true

        SetPedIntoVehicle(SUN.ped, drone, -1)
        SetEntityVisible(SUN.ped, false, false)
        SetEntityInvincible(SUN.ped, true)
        SetPedCanBeKnockedOffVehicle(SUN.ped, 1)
        SetPedConfigFlag(SUN.ped, 32, true)
        SetFollowVehicleCamViewMode(1)
        SetFollowVehicleCamZoomLevel(2)

        if payload.hudOverlay then
            SUN.SendUIData(PB.HUD, {type = 'predatorHud', payload = {active = true, duration = payload.duration or 30}})
        end

        SetTimecycleModifier('scanline_cam_cheap')
        SetTimecycleModifierStrength(1.0)
        AnimpostfxPlay('MP_OrbitalCannon', 0, true)
        ShakeGameplayCam('DRUNK_SHAKE', 0.08)

        local blip = AddBlipForEntity(drone)
        SetBlipSprite(blip, 64)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Predator')
        EndTextCommandSetBlipName(blip)
        activePredator.blip = blip

        ESX.notification('warning', 'پهپاد انتحاری — خودتو پرت کن!')

        CreateThread(function()
            while activePredator and activePredator.drone and DoesEntityExist(activePredator.drone) and GetGameTimer() < activePredator.endAt and not activePredator.impacted do
                if HasEntityCollidedWithAnything(activePredator.drone) or IsEntityDead(activePredator.drone) then
                    activePredator.impacted = true
                    local coords = GetEntityCoords(activePredator.drone)
                    TriggerServerEvent('paintball:predatorImpact', {x = coords.x, y = coords.y, z = coords.z})
                    break
                end
                Wait(50)
            end
        end)
    end
end)

RegisterNetEvent('paintball:predatorEnd', function(info)
    if not activePredator then return end
    local drone = activePredator.drone
    local blip = activePredator.blip
    local saved = activePredator.savedCoords
    local heading = activePredator.savedHeading

    ClearTimecycleModifier()
    AnimpostfxStop('MP_OrbitalCannon')
    StopGameplayCamShaking(true)

    if drone and DoesEntityExist(drone) then
        if not activePredator.impacted then
            local c = GetEntityCoords(drone)
            AddExplosion(c.x, c.y, c.z, 4, 1.0, true, false, 1.0)
        end
        DeleteEntity(drone)
    end

    if blip and DoesBlipExist(blip) then RemoveBlip(blip) end

    SetEntityVisible(SUN.ped, true, false)
    SetEntityInvincible(SUN.ped, false)
    if saved then
        SetEntityCoords(SUN.ped, saved.x, saved.y, saved.z, false, false, false, false)
        SetEntityHeading(SUN.ped, heading or 0.0)
    end
    PB.state.inAC130 = false

    SUN.SendUIData(PB.HUD, {type = 'predatorHud', payload = {active = false}})
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = info.reason == 'impact' and 'انفجار!' or 'Predator پایان یافت', duration = 3}})
    activePredator = nil
end)

local activeAC130 = nil

RegisterNetEvent('paintball:ac130Start', function(payload)
    if activeAC130 and activeAC130.plane and DoesEntityExist(activeAC130.plane) then
        DeleteEntity(activeAC130.plane)
    end
    activeAC130 = {
        owner = payload.owner,
        ownerTeam = payload.ownerTeam,
        center = payload.mapCenter,
        endAt = GetGameTimer() + (payload.duration * 1000),
        isOwner = payload.isOwner,
        plane = nil,
        pilot = nil,
        blip = nil,
        savedCoords = nil,
    }

    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'AC-130 در حال رسیدن', duration = 4}})

    if payload.isOwner and payload.mapCenter then
        local hash = GetHashKey(payload.planeModel or 'bombushka')
        local pilotHash = GetHashKey('s_m_y_pilot_01')
        ESX.Streaming.RequestModel(hash)
        ESX.Streaming.RequestModel(pilotHash)
        local cx, cy, cz = payload.mapCenter.x, payload.mapCenter.y, payload.mapCenter.z + (payload.height or 250.0)
        local plane = CreateVehicle(hash, cx + (payload.radius or 220.0) + 100, cy, cz, 270.0, true, false)
        SetVehicleEngineOn(plane, true, true, false)
        SetEntityInvincible(plane, true)
        SetEntityCanBeDamaged(plane, false)
        SetVehicleDoorsLocked(plane, 4)
        SetVehicleForwardSpeed(plane, payload.speed or 22.0)

        local pilot = CreatePedInsideVehicle(plane, 4, pilotHash, -1, true, false)
        SetEntityInvincible(pilot, true)
        SetPedKeepTask(pilot, true)
        TaskPlaneMission(pilot, plane, 0, 0, cx, cy, cz, 6, payload.speed or 22.0, 0.0, 270.0, cz + 30.0, cz - 30.0)

        SetModelAsNoLongerNeeded(hash)
        SetModelAsNoLongerNeeded(pilotHash)

        activeAC130.plane = plane
        activeAC130.pilot = pilot

        local blip = AddBlipForEntity(plane)
        SetBlipSprite(blip, 423)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('AC-130')
        EndTextCommandSetBlipName(blip)
        activeAC130.blip = blip

        activeAC130.savedCoords = GetEntityCoords(SUN.ped)
        activeAC130.savedHeading = GetEntityHeading(SUN.ped)

        SetTimeout(2000, function()
            if not activeAC130 or not DoesEntityExist(plane) then return end
            local gunnerSeat = payload.gunnerSeat or -2
            SetPedIntoVehicle(SUN.ped, plane, gunnerSeat)
            SetPedConfigFlag(SUN.ped, 32, true)
            DisablePlayerFiring(SUN.PlayerId, false)
            PB.state.inAC130 = true
            ESX.notification('warning', 'AC-130: کلیک چپ رو بزن شلیک کن')
        end)

        CreateThread(function()
            while activeAC130 and activeAC130.plane and DoesEntityExist(activeAC130.plane) and GetGameTimer() < activeAC130.endAt do
                if IsPedInVehicle(SUN.ped, activeAC130.plane, false) then
                    SetEntityInvincible(SUN.ped, true)
                    DisableControlAction(0, 75, true)
                    DisableControlAction(27, 75, true)
                    if IsDisabledControlJustPressed(0, 24) then
                        local cam = GetGameplayCamCoord()
                        local rot = GetGameplayCamRot(2)
                        local rz = math.rad(rot.z)
                        local rx = math.rad(rot.x)
                        local cosX = math.cos(rx)
                        local fwd = vec3(-math.sin(rz) * cosX, math.cos(rz) * cosX, math.sin(rx))
                        local rayHandle = StartShapeTestRay(cam.x, cam.y, cam.z, cam.x + fwd.x * 1000, cam.y + fwd.y * 1000, cam.z + fwd.z * 1000, -1, SUN.ped, 0)
                        local _, hit, hitCoords = GetShapeTestResult(rayHandle)
                        if hit == 1 then
                            local pCoords = GetEntityCoords(activeAC130.plane)
                            ShootSingleBulletBetweenCoords(pCoords.x, pCoords.y, pCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, 800, false, GetHashKey('WEAPON_RPG'), SUN.ped, true, true, 2000.0)
                            AddExplosion(hitCoords.x, hitCoords.y, hitCoords.z, 2, 1.0, true, false, 1.0)
                        end
                    end
                end
                Wait(0)
            end
        end)
    end
end)

RegisterNetEvent('paintball:ac130End', function(info)
    if activeAC130 then
        local plane = activeAC130.plane
        local blip = activeAC130.blip
        local saved = activeAC130.savedCoords
        local heading = activeAC130.savedHeading
        PB.state.inAC130 = false
        SetEntityInvincible(SUN.ped, false)
        if plane and DoesEntityExist(plane) and IsPedInVehicle(SUN.ped, plane, false) then
            ClearPedTasksImmediately(SUN.ped)
            if saved then
                SetEntityCoords(SUN.ped, saved.x, saved.y, saved.z, false, false, false, false)
                SetEntityHeading(SUN.ped, heading or 0.0)
            end
        end
        if plane and DoesEntityExist(plane) then
            local center = activeAC130.center
            if center then
                local angle = math.random() * 6.28
                local awayX = center.x + math.cos(angle) * 800
                local awayY = center.y + math.sin(angle) * 800
                local awayZ = center.z + 400
                if activeAC130.pilot and DoesEntityExist(activeAC130.pilot) then
                    TaskPlaneMission(activeAC130.pilot, plane, 0, 0, awayX, awayY, awayZ, 4, 60.0, 0.0, 0.0, awayZ + 30, awayZ - 30)
                end
            end
            SetTimeout(15000, function()
                if plane and DoesEntityExist(plane) then DeleteEntity(plane) end
                if blip and DoesBlipExist(blip) then RemoveBlip(blip) end
            end)
        end
        activeAC130 = nil
    end
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'AC-130 پایان یافت', duration = 3}})
end)

RegisterNetEvent('paintball:nukeWarning', function(payload)
    local warnSec = payload.warning or 30
    local shake = payload.shake or 1.5
    local flash = payload.screenFlash or 0.7
    SUN.SendUIData(PB.HUD, {type = 'nukeWarning', payload = {seconds = warnSec, shake = shake, flash = flash}})
    PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true)

    CreateThread(function()
        local startedAt = GetGameTimer()
        local endAt = startedAt + (warnSec * 1000)
        local lastBeep = startedAt
        while GetGameTimer() < endAt do
            local elapsed = (GetGameTimer() - startedAt) / 1000
            local remaining = warnSec - elapsed
            local intensity = math.min(1.0, elapsed / warnSec)

            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shake * intensity)

            if (GetGameTimer() - lastBeep) > math.max(200, 1500 - (intensity * 1300)) then
                PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true)
                lastBeep = GetGameTimer()
            end

            SUN.SendUIData(PB.HUD, {type = 'nukeTick', payload = {remaining = remaining, intensity = intensity}})
            Wait(50)
        end

        StopGameplayCamShaking(true)
        local coords = GetEntityCoords(SUN.ped)
        AddExplosion(coords.x, coords.y, coords.z, 21, 30.0, true, false, 1.0)
        AnimpostfxPlay('ChopVision', 800, false)
        SetTimeout(900, function()
            AnimpostfxStopAll()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            SetTransitionOutOfBlurredLowResBuffersForPlayerSwitch()
        end)
        SUN.SendUIData(PB.HUD, {type = 'nukeBoom'})
    end)
end)

local function pbCleanupKsEntities()
    if activeUAV then
        if activeUAV.heli and DoesEntityExist(activeUAV.heli) then DeleteEntity(activeUAV.heli) end
        if activeUAV.heliBlip and DoesBlipExist(activeUAV.heliBlip) then RemoveBlip(activeUAV.heliBlip) end
        activeUAV = nil
    end
    if activeAC130 then
        if activeAC130.plane and DoesEntityExist(activeAC130.plane) then DeleteEntity(activeAC130.plane) end
        if activeAC130.blip and DoesBlipExist(activeAC130.blip) then RemoveBlip(activeAC130.blip) end
        SetEntityInvincible(SUN.ped, false)
        PB.state.inAC130 = false
        activeAC130 = nil
    end
    if activePredator then
        ClearTimecycleModifier()
        AnimpostfxStopAll()
        StopGameplayCamShaking(true)
        if activePredator.drone and DoesEntityExist(activePredator.drone) then DeleteEntity(activePredator.drone) end
        if activePredator.blip and DoesBlipExist(activePredator.blip) then RemoveBlip(activePredator.blip) end
        SetEntityVisible(SUN.ped, true, false)
        SetEntityInvincible(SUN.ped, false)
        PB.state.inAC130 = false
        activePredator = nil
    end
    cleanupMarker()
    clearEnemyBlips()
    StopGameplayCamShaking(true)
end
AddEventHandler('paintball:cleanup', pbCleanupKsEntities)
RegisterNetEvent('paintball:matchEnd', pbCleanupKsEntities)

AddEventHandler('onResourceStop', function(rn)
    if GetCurrentResourceName() == rn then
        if activeUAV and activeUAV.heli and DoesEntityExist(activeUAV.heli) then DeleteEntity(activeUAV.heli) end
        cleanupMarker()
        clearEnemyBlips()
        StopGameplayCamShaking(true)
    end
end)
