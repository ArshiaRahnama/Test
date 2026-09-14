

local state = {
    ready = false,
    spawnSerial = 0,
    graceUntil = 0,
    pausedUntil = 0,
    baselineModel = nil,
    lastPed = 0,
    lastCoords = nil,
    lastPositionAt = 0,
    lastVehicle = 0,
    lastPlate = nil,
    lastPrimaryColour = nil,
    reportCooldown = {},
    evidence = {},
    lastCameraMode = nil,
    cameraChangedAt = 0,
    knownResources = {},
    readyStarting = false,
    lastReadyAt = 0,
    hasPlayerSpawned = false,
    lastSpawnEventAt = 0,
    frameworkLoaded = false,
    frameworkType = "standalone",
}

local function now()
    return GetGameTimer()
end

local function detectionConfig(name, fallback)
    if UNIQUE_AC.Detection and UNIQUE_AC.Detection[name] ~= nil then
        return UNIQUE_AC.Detection[name]
    end
    return fallback
end

local function extendGrace(duration)
    local ms = tonumber(duration) or detectionConfig("RespawnGraceMs", 10000)
    state.graceUntil = math.max(state.graceUntil, now() + ms)
    state.evidence = {}
    state.lastCoords = nil
    state.lastPositionAt = 0
end

local function validPed()
    local ped = PlayerPedId()
    return ped ~= 0 and DoesEntityExist(ped) and NetworkIsPlayerActive(PlayerId()), ped
end

local function resourceStarted(name)
    if type(name) ~= "string" or name == "" then return false end
    local ok, stateName = pcall(GetResourceState, name)
    return ok and stateName == "started"
end

local function detectFramework()
    if resourceStarted("qb-core") then return "qbcore" end
    if resourceStarted("es_extended") then return "esx" end
    return "standalone"
end

local function hasCollisionAndControl(ped)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return false end
    if IsPlayerSwitchInProgress() or IsPauseMenuActive() then return false end
    if IsScreenFadedOut() or IsScreenFadingOut() or IsScreenFadingIn() then return false end
    if not HasCollisionLoadedAroundEntity(ped) then return false end
    if not IsPlayerControlOn(PlayerId()) then return false end
    return true
end

local function gameplaySettled(ped)
    local ok
    ok, ped = validPed()
    if not ok then return false, ped end

    state.frameworkType = detectFramework()

    if detectionConfig("RequirePlayerSpawned", true) and not state.hasPlayerSpawned then
        return false, ped
    end

    if detectionConfig("RequireFrameworkLoaded", true)
        and state.frameworkType ~= "standalone"
        and not state.frameworkLoaded then
        return false, ped
    end

    if not hasCollisionAndControl(ped) then
        return false, ped
    end

    local settleMs = tonumber(detectionConfig("PostSpawnSettleMs", 18000)) or 18000
    if state.lastSpawnEventAt > 0 and now() - state.lastSpawnEventAt < settleMs then
        return false, ped
    end

    return true, ped
end

local function checksAllowed()
    local ok, ped = gameplaySettled()
    if not ok or not state.ready then return false, ped end
    if now() < state.graceUntil or now() < state.pausedUntil then return false, ped end
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then return false, ped end
    return true, ped
end

local function clearEvidence(key)
    state.evidence[key] = nil
end

local function report(punishment, reason, details, key, threshold, cooldown)
    if UNIQUE_AC_CHECK_TEMP_WHITELIST() then return end

    key = key or reason
    threshold = tonumber(threshold) or detectionConfig("EvidenceThreshold", 3)
    cooldown = tonumber(cooldown) or detectionConfig("ClientReportCooldownMs", 10000)

    local t = now()
    local ev = state.evidence[key]
    if not ev or t - ev.startedAt > detectionConfig("EvidenceWindowMs", 15000) then
        ev = { count = 0, startedAt = t }
        state.evidence[key] = ev
    end

    ev.count = ev.count + 1
    if ev.count < threshold then return end

    local last = state.reportCooldown[key] or 0
    if t - last < cooldown then return end

    state.reportCooldown[key] = t
    state.evidence[key] = nil
    TriggerServerEvent("UNIQUE_AC:reportDetection", punishment, reason, tostring(details or "No details"))
end

local function snapshotKnownResources()
    local count = tonumber(GetNumResources()) or 0
    for index = 0, count - 1 do
        local resource = GetResourceByFindIndex(index)
        if type(resource) == "string" and resource ~= "" then state.knownResources[resource] = true end
    end
end

local function markReady(reason)
    if state.readyStarting then return end
    if state.ready and now() - state.lastReadyAt < 1500 then return end
    state.readyStarting = true
    CreateThread(function()
        local maxWait = tonumber(detectionConfig("ReadyMaxWaitMs", 120000)) or 120000
        local startedAt = now()
        local ok, ped = gameplaySettled()

        while not ok and now() - startedAt < maxWait do
            Wait(500)
            ok, ped = gameplaySettled()
        end

        if not ok then
            state.readyStarting = false
            return
        end

        state.spawnSerial = state.spawnSerial + 1
        state.ready = true
        state.readyStarting = false
        state.lastReadyAt = now()
        state.lastPed = ped
        state.baselineModel = GetEntityModel(ped)
        extendGrace(detectionConfig("PostReadyGraceMs", detectionConfig("SpawnGraceMs", 20000)))
        TriggerServerEvent("UNIQUE_AC:clientReady", state.spawnSerial, reason or "runtime")
        TriggerServerEvent("UNIQUE_AC:checkIsAdmin")
    end)
end

local function noteSpawn(reason)
    state.hasPlayerSpawned = true
    state.lastSpawnEventAt = now()
    state.ready = false
    state.evidence = {}
    extendGrace(detectionConfig("PostSpawnSettleMs", 18000) + detectionConfig("PostReadyGraceMs", 20000))
    markReady(reason or "playerSpawned")
end

local function noteFrameworkLoaded(framework)
    state.frameworkType = framework or detectFramework()
    state.frameworkLoaded = true
    extendGrace(detectionConfig("FrameworkLoadGraceMs", 12000))
    markReady("frameworkLoaded:" .. tostring(state.frameworkType))
end

AddEventHandler("playerSpawned", function()
    noteSpawn("playerSpawned")
end)

RegisterNetEvent("esx:playerLoaded", function()
    noteFrameworkLoaded("esx")
end)

RegisterNetEvent("esx:onPlayerSpawn", function()
    state.frameworkLoaded = true
    noteSpawn("esx:onPlayerSpawn")
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    noteFrameworkLoaded("qbcore")
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    state.ready = false
    state.frameworkLoaded = false
    state.hasPlayerSpawned = false
    extendGrace(detectionConfig("FrameworkLoadGraceMs", 12000))
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        snapshotKnownResources()
        state.frameworkType = detectFramework()

        CreateThread(function()
            Wait(tonumber(detectionConfig("ResourceRestartAssumeSpawnedMs", 8000)) or 8000)
            local ok, ped = validPed()
            if ok and hasCollisionAndControl(ped) then
                state.hasPlayerSpawned = true
                state.lastSpawnEventAt = now() - (tonumber(detectionConfig("PostSpawnSettleMs", 18000)) or 18000)
                if state.frameworkType ~= "standalone" then state.frameworkLoaded = true end
                markReady("resourceRestartStable")
            end
        end)
        return
    end

    if UNIQUE_AC.AntiInject and state.ready and not state.knownResources[resourceName] then
        TriggerServerEvent("UNIQUE_AC:AntiInject", tostring(resourceName), "unexpected client-only resource start")
    end
    state.knownResources[resourceName] = true
end)

RegisterNetEvent("UNIQUE_AC:clientGrace", function(duration)
    extendGrace(math.min(math.max(tonumber(duration) or 10000, 1000), 600000))
end)

CreateThread(function()
    while true do
        Wait(1500)
        local allowed, ped = checksAllowed()
        if not allowed then goto continue end

        if ped ~= state.lastPed then
            state.lastPed = ped
            state.baselineModel = GetEntityModel(ped)
            extendGrace(detectionConfig("PedChangeGraceMs", 10000))
            goto continue
        end

        local cameraMode = GetFollowPedCamViewMode()
        if state.lastCameraMode ~= nil and cameraMode ~= state.lastCameraMode then
            state.cameraChangedAt = now()
        end
        state.lastCameraMode = cameraMode

        if UNIQUE_AC.AntiHealthHack then
            local health = GetEntityHealth(ped)
            if health > (tonumber(UNIQUE_AC.MaxHealth) or 200) then
                report(UNIQUE_AC.HealthPunishment, "Anti Health Hack", ("Health: %s"):format(health), "health", 2)
            else
                clearEvidence("health")
            end
        end

        if UNIQUE_AC.AntiArmorHack then
            local armour = GetPedArmour(ped)
            if armour > (tonumber(UNIQUE_AC.MaxArmor) or 100) then
                report(UNIQUE_AC.ArmorPunishment, "Anti Armor Hack", ("Armour: %s"):format(armour), "armour", 2)
            else
                clearEvidence("armour")
            end
        end

        if UNIQUE_AC.AntiSpectate then
            if NetworkIsInSpectatorMode() then
                report(UNIQUE_AC.SpectatePunishment or UNIQUE_AC.SpactatePunishment or "BAN", "Anti Spectate", "Unexpected spectator mode", "spectate", 3)
            else
                clearEvidence("spectate")
            end
        end

        if UNIQUE_AC.AntiGodMode then
            local cameraSettled = now() - state.cameraChangedAt > detectionConfig("CameraGraceMs", 2500)
            local readySettled = now() - state.lastReadyAt > detectionConfig("GodmodeAfterReadyMs", 12000)
            local gameplaySafe = hasCollisionAndControl(ped)
                and not IsEntityPositionFrozen(ped)
                and not IsPedRagdoll(ped)
                and not IsPedFalling(ped)
                and not IsPedInParachuteFreeFall(ped)
                and not IsCutsceneActive()
            local uiSafe = not IsNuiFocused() and not IsCinematicCamRendering() and cameraSettled and readySettled and gameplaySafe
            if uiSafe then
                local invincible = GetPlayerInvincible(PlayerId()) == true
                local damageDisabled = not GetEntityCanBeDamaged(ped)
                local bulletProof, fireProof, explosionProof, collisionProof, meleeProof, _, _, drownProof = GetEntityProofs(ped)
                local fullProofs = bulletProof and fireProof and explosionProof and collisionProof and meleeProof and drownProof
                if invincible or damageDisabled or fullProofs then
                    report(UNIQUE_AC.GodPunishment, "Anti Godmode",
                        ("invincible=%s damageDisabled=%s fullProofs=%s"):format(tostring(invincible), tostring(damageDisabled), tostring(fullProofs)),
                        "godmode", detectionConfig("GodmodeSamples", 4), 15000)
                else
                    clearEvidence("godmode")
                end
            else
                clearEvidence("godmode")
            end
        end

        if UNIQUE_AC.AntiInvisible then
            local alpha = GetEntityAlpha(ped)
            local invisible = (not IsEntityVisible(ped) and not IsEntityVisibleToScript(ped)) or (alpha > 0 and alpha < 120)
            if invisible then
                report(UNIQUE_AC.InvisiblePunishment, "Anti Invisible", ("Entity alpha: %s"):format(alpha), "invisible", 4)
            else
                clearEvidence("invisible")
            end
        end

        if UNIQUE_AC.AntiTinyPed then
            if GetPedConfigFlag(ped, 223, true) then
                report(UNIQUE_AC.PedFlagPunishment, "Anti Tiny Ped", "Tiny ped flag remained enabled", "tinyped", 3)
            else
                clearEvidence("tinyped")
            end
        end

        if UNIQUE_AC.AntiPedChanger and state.baselineModel then
            local model = GetEntityModel(ped)
            if model ~= state.baselineModel then
                local blocked = false
                if type(Peds) == "table" then
                    for _, name in ipairs(Peds) do
                        if model == GetHashKey(name) then
                            blocked = true
                            break
                        end
                    end
                end

                if blocked then
                    report(UNIQUE_AC.PedChangePunishment, "Anti Ped Changer",
                        ("Blocked player model: %s"):format(model), "pedmodel", 3, 20000)
                else
                    state.baselineModel = model
                    state.graceUntil = math.max(state.graceUntil, now() + detectionConfig("PedChangeGraceMs", 10000))
                    clearEvidence("pedmodel")
                end
            else
                clearEvidence("pedmodel")
            end
        end

        if UNIQUE_AC.AntiFreeCam then
            local playerCoords = GetEntityCoords(ped)
            local camCoords = GetFinalRenderedCamCoord()
            local distance = #(playerCoords - camCoords)
            if distance > 55.0 and not IsCinematicCamRendering() and not IsNuiFocused() then
                report(UNIQUE_AC.CamPunishment, "Anti Free Cam", ("Camera distance: %.2f"):format(distance), "freecam", 4)
            else
                clearEvidence("freecam")
            end
        end

        ::continue::
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local allowed, ped = checksAllowed()
        if not allowed then
            state.lastCoords = nil
            state.lastPositionAt = 0
            goto continue
        end

        local coords = GetEntityCoords(ped)
        local t = now()
        if state.lastCoords and state.lastPositionAt > 0 then
            local elapsed = math.max((t - state.lastPositionAt) / 1000.0, 0.1)
            local distance = #(coords - state.lastCoords)
            local inVehicle = IsPedInAnyVehicle(ped, false)
            local exempt = IsPedFalling(ped) or IsPedRagdoll(ped) or IsPedClimbing(ped) or IsPedVaulting(ped)
                or IsPedInParachuteFreeFall(ped) or IsPedJumpingOutOfVehicle(ped)
                or IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped)
                or not HasCollisionLoadedAroundEntity(ped)

            if UNIQUE_AC.AntiTeleport and not exempt then
                local limit = inVehicle and (tonumber(UNIQUE_AC.MaxVehicleDistance) or 600) or (tonumber(UNIQUE_AC.MaxFootDistance) or 200)
                local scaledLimit = math.max(limit, GetEntitySpeed(ped) * elapsed * 4.0 + 35.0)
                if distance > scaledLimit then
                    report(UNIQUE_AC.TeleportPunishment, "Anti Teleport",
                        ("Moved %.2fm in %.2fs (limit %.2fm)"):format(distance, elapsed, scaledLimit), "teleport", 2, 15000)
                else
                    clearEvidence("teleport")
                end
            end

            if UNIQUE_AC.AntiNoclip and not inVehicle then
                local height = GetEntityHeightAboveGround(ped)
                if distance > 12.0 and height > 5.0 and not exempt then
                    report(UNIQUE_AC.NoclipPunishment, "Anti Noclip", ("Distance %.2f, height %.2f"):format(distance, height), "noclip", 3)
                else
                    clearEvidence("noclip")
                end
            end
        end

        state.lastCoords = coords
        state.lastPositionAt = t
        ::continue::
    end
end)

CreateThread(function()
    while true do
        Wait(750)
        local allowed, ped = checksAllowed()
        if allowed and UNIQUE_AC.AntiSuperJump and IsPedJumping(ped) then
            TriggerServerEvent("UNIQUE_AC:CheckJumping")
            Wait(2000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(3000)
        local allowed, ped = checksAllowed()
        if allowed and UNIQUE_AC.AntiWeaponComponent and type(BlacklistedComponents) == "table" then
            local weapon = GetSelectedPedWeapon(ped)
            if weapon and weapon ~= GetHashKey("WEAPON_UNARMED") then
                for _, componentName in ipairs(BlacklistedComponents) do
                    local componentHash = GetHashKey(componentName)
                    if HasPedGotWeaponComponent(ped, weapon, componentHash) then
                        RemovePedWeaponComponent(ped, weapon, componentHash)
                        report(UNIQUE_AC.ComponentPunishment or UNIQUE_AC.WeaponPunishment, "Anti Weapon Component",
                            "Illegal component: " .. tostring(componentName), "component:" .. tostring(componentHash), 1)
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(4000)
        local allowed, ped = checksAllowed()
        if allowed and UNIQUE_AC.AntiUnderground and not IsPedFalling(ped) then
            local coords = GetEntityCoords(ped)

            local inRealInterior = GetInteriorFromEntity(ped) ~= 0

            local inSafeZone = false
            if type(UNIQUE_AC.UndergroundSafeZones) == "table" then
                for _, zone in ipairs(UNIQUE_AC.UndergroundSafeZones) do
                    if type(zone) == "table" and zone.x and zone.y and zone.z then
                        local dist = #(coords - vector3(zone.x, zone.y, zone.z))
                        if dist <= (tonumber(zone.radius) or 40.0) then
                            inSafeZone = true
                            break
                        end
                    end
                end
            end

            if not inRealInterior and not inSafeZone then
                local groundFound, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 50.0, false)
                local outOfWorld = math.abs(coords.x) > 8000.0 or math.abs(coords.y) > 8000.0 or coords.z < -150.0

                if outOfWorld then
                    report(UNIQUE_AC.UndergroundPunishment or "BAN", "Anti Out Of Bounds",
                        ("Coords: %.1f, %.1f, %.1f"):format(coords.x, coords.y, coords.z), "bounds", 1)
                elseif groundFound and (coords.z < groundZ - (UNIQUE_AC.UndergroundTolerance or 6.0)) then
                    report(UNIQUE_AC.UndergroundPunishment or "KICK", "Anti Underground",
                        ("Coords: %.1f, %.1f, %.1f (ground %.1f)"):format(coords.x, coords.y, coords.z, groundZ), "underground", 2)
                end
            end
        end
    end
end)

CreateThread(function()
    local semiAutoWeapons = {
        [`WEAPON_PISTOL`] = true, [`WEAPON_PISTOL_MK2`] = true, [`WEAPON_COMBATPISTOL`] = true,
        [`WEAPON_APPISTOL`] = true, [`WEAPON_PISTOL50`] = true, [`WEAPON_SNSPISTOL`] = true,
        [`WEAPON_HEAVYPISTOL`] = true, [`WEAPON_MARKSMANPISTOL`] = true, [`WEAPON_REVOLVER`] = true,
    }
    local shotTimestamps = {}
    local wasShooting = false

    while true do
        Wait(0)
        local allowed, ped = checksAllowed()
        if allowed and UNIQUE_AC.AntiMacroFire then
            local weapon = GetSelectedPedWeapon(ped)
            if semiAutoWeapons[weapon] then
                local shooting = IsPedShooting(ped)
                if shooting and not wasShooting then
                    local t = now()
                    table.insert(shotTimestamps, t)
                    local minShots = tonumber(UNIQUE_AC.MacroFireMinShots) or 6
                    if #shotTimestamps > minShots then
                        table.remove(shotTimestamps, 1)
                    end

                    if #shotTimestamps >= minShots then
                        local intervals = {}
                        for i = 2, #shotTimestamps do
                            intervals[#intervals + 1] = shotTimestamps[i] - shotTimestamps[i - 1]
                        end
                        local sum = 0
                        for _, v in ipairs(intervals) do sum = sum + v end
                        local mean = sum / #intervals
                        local variance = 0
                        for _, v in ipairs(intervals) do variance = variance + (v - mean) ^ 2 end
                        variance = variance / #intervals
                        local stdDev = math.sqrt(variance)

                        if stdDev < (tonumber(UNIQUE_AC.MacroFireMaxVarianceMs) or 9) and mean < 400 then
                            report(UNIQUE_AC.MacroFirePunishment, "Anti Macro Fire",
                                ("StdDev %.2fms across %d shots, avg %.0fms"):format(stdDev, #intervals, mean), "macrofire", 2, 20000)
                        end
                    end
                else
                    Wait(30)
                end
                wasShooting = shooting
            else
                shotTimestamps = {}
                wasShooting = false
                Wait(500)
            end
        else
            shotTimestamps = {}
            wasShooting = false
            Wait(500)
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:applySlap", function()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end
    local upward = 4.0 + math.random() * 2.0
    local sideways = (math.random() - 0.5) * 6.0
    SetEntityVelocity(ped, sideways, sideways, upward)
    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.4)
end)

local rpZones = {}
local rpZoneBlips = {}
local wasInRpZone = false

local function clearRpZoneBlips()
    for _, blip in ipairs(rpZoneBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    rpZoneBlips = {}
end

RegisterNetEvent("UNIQUE_AC:updateRpZones", function(zones)
    rpZones = zones or {}
    clearRpZoneBlips()
    for _, zone in ipairs(rpZones) do
        local radiusBlip = AddBlipForRadius(zone.x, zone.y, zone.z, zone.radius + 0.0)
        SetBlipColour(radiusBlip, 1)
        SetBlipAlpha(radiusBlip, 90)

        local marker = AddBlipForCoord(zone.x, zone.y, zone.z)
        SetBlipSprite(marker, 84)
        SetBlipColour(marker, 1)
        SetBlipScale(marker, 0.7)
        SetBlipAsShortRange(marker, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("RP-Stop Zone")
        EndTextCommandSetBlipName(marker)

        rpZoneBlips[#rpZoneBlips + 1] = radiusBlip
        rpZoneBlips[#rpZoneBlips + 1] = marker
    end
end)

CreateThread(function()
    while true do
        if #rpZones == 0 then
            Wait(1000)
        else
            Wait(0)
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local insideAny = false

            for _, zone in ipairs(rpZones) do
                local center = vector3(zone.x, zone.y, zone.z)
                DrawMarker(28, zone.x, zone.y, zone.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    zone.radius * 2.0, zone.radius * 2.0, 2.0, 235, 60, 60, 70, false, false, 2, false, nil, nil, false)

                local dist = #(coords - center)
                if dist <= zone.radius then
                    insideAny = true
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 47, true)
                    DisableControlAction(0, 58, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)

                    if dist > zone.radius - 1.5 and dist > 0.05 then
                        local dir = (coords - center) / dist
                        local clamped = center + dir * (zone.radius - 1.5)
                        SetEntityCoordsNoOffset(ped, clamped.x, clamped.y, coords.z, true, true, true)
                    end
                end
            end

            if insideAny and not wasInRpZone then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("~r~RP-STOP~s~ — an admin has paused roleplay in this area.")
                EndTextCommandDisplayHelp(0, false, true, -1)
            end
            wasInRpZone = insideAny
        end
    end
end)

RegisterNetEvent("UNIQUE_AC:quarantineFreeze", function(status)
    state.quarantined = status and true or false
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        FreezeEntityPosition(ped, state.quarantined)
        SetEntityInvincible(ped, state.quarantined)
        SetPlayerInvincible(PlayerId(), state.quarantined)
    end
end)

CreateThread(function()
    while true do
        if state.quarantined then
            SetTextFont(4)
            SetTextScale(0.0, 0.42)
            SetTextColour(255, 70, 90, 255)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("~r~UNIQUE_AC~s~ ~w~— Under Security Review\n~s~An admin is checking your case. Please wait, do not disconnect.")
            SetTextCentre(true)
            DrawText(0.5, 0.88)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    local lastHealth, lastVehicle = nil, 0
    while true do
        Wait(3000)
        local allowed, ped = checksAllowed()
        if allowed and UNIQUE_AC.AntiVehicleGodMode and IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                local engineHealth = GetVehicleEngineHealth(vehicle)
                local bodyHealth = GetVehicleBodyHealth(vehicle)
                local isDamaged = HasEntityCollidedWithAnything(vehicle)

                if vehicle ~= lastVehicle then
                    lastHealth = { engine = engineHealth, body = bodyHealth }
                    lastVehicle = vehicle
                elseif isDamaged and engineHealth >= (lastHealth.engine or 1000) and bodyHealth >= (lastHealth.body or 1000) and (lastHealth.engine or 1000) < 950 then
                    report(UNIQUE_AC.VehicleGodPunishment or "BAN", "Anti Vehicle God Mode",
                        ("Engine %.0f / Body %.0f stayed static under damage"):format(engineHealth, bodyHealth), "vehiclegod:" .. tostring(vehicle), 2)
                end

                lastHealth = { engine = engineHealth, body = bodyHealth }
            else
                lastVehicle = 0
            end
        else
            lastVehicle = 0
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2500)
        local allowed, ped = checksAllowed()
        if not allowed then goto continue end

        if UNIQUE_AC.AntiInfinityAmmo then
            SetPedInfiniteAmmoClip(ped, false)
        end

        if UNIQUE_AC.AntiBlackListWeapon and type(Weapon) == "table" then
            local selected = GetSelectedPedWeapon(ped)
            for _, weaponName in ipairs(Weapon) do
                if selected == GetHashKey(weaponName) then
                    RemoveWeaponFromPed(ped, selected)
                    report(UNIQUE_AC.WeaponPunishment, "Anti Black List Weapon", "Weapon: " .. tostring(weaponName), "weapon:" .. tostring(selected), 1)
                    break
                end
            end
        end

        if UNIQUE_AC.AntiWeaponDamageChanger and type(DAMAGE) == "table" then
            local weapon = GetSelectedPedWeapon(ped)
            local expected = DAMAGE[weapon]
            if expected and expected.DAMAGE then
                local actual = math.floor(GetWeaponDamage(weapon))
                if actual > expected.DAMAGE + 1 then
                    report(UNIQUE_AC.DamagePunishment or UNIQUE_AC.WeaponPunishment, "Anti Weapon Damage Changer",
                        ("%s damage %s, expected %s"):format(expected.name or weapon, actual, expected.DAMAGE), "damage:" .. tostring(weapon), 3)
                end
            end
        end

        if UNIQUE_AC.AntiInfiniteStamina and not IsPedInAnyVehicle(ped, false) and IsPedSprinting(ped) then
            local stamina = GetPlayerSprintStaminaRemaining(PlayerId())
            if stamina >= 99.5 and GetEntitySpeed(ped) > 6.5 then
                report(UNIQUE_AC.InfinitePunishment, "Anti Infinite Stamina", ("Stamina stayed at %.2f"):format(stamina), "stamina", 8, 30000)
            else
                clearEvidence("stamina")
            end
        end

        if UNIQUE_AC.AntiNightVision and GetUsingnightvision() and not IsPedInAnyHeli(ped) then
            report(UNIQUE_AC.VisionPunishment, "Anti Night Vision", "Night vision enabled outside an allowed helicopter", "nightvision", 3)
        else
            clearEvidence("nightvision")
        end

        if UNIQUE_AC.AntiThermalVision and GetUsingseethrough() and not IsPedInAnyHeli(ped) then
            report(UNIQUE_AC.VisionPunishment, "Anti Thermal Vision", "Thermal vision enabled outside an allowed helicopter", "thermal", 3)
        else
            clearEvidence("thermal")
        end

        if UNIQUE_AC.AntiBlacklistTasks and type(Tasks) == "table" then
            for _, taskId in ipairs(Tasks) do
                if GetIsTaskActive(ped, taskId) then
                    report(UNIQUE_AC.TasksPunishment, "Anti Black List Tasks", "Task: " .. tostring(taskId), "task:" .. tostring(taskId), 2)
                    break
                end
            end
        end

        if UNIQUE_AC.AntiBlacklistAnims and type(Anims) == "table" then
            for _, anim in ipairs(Anims) do
                local dict = type(anim) == "table" and (anim.dict or anim[1]) or nil
                local name = type(anim) == "table" and (anim.anim or anim[2]) or nil
                if type(dict) == "string" and type(name) == "string" and IsEntityPlayingAnim(ped, dict, name, 3) then
                    report(UNIQUE_AC.AnimsPunishment, "Anti Black List Animation", dict .. "/" .. name,
                        "anim:" .. dict .. ":" .. name, 2)
                    ClearPedTasks(ped)
                    break
                end
            end
        end

        ::continue::
    end
end)

CreateThread(function()
    local rainbowChanges = 0
    local rainbowWindow = 0
    while true do
        Wait(1000)
        local allowed, ped = checksAllowed()
        if not allowed or not IsPedInAnyVehicle(ped, false) then
            state.lastVehicle = 0
            state.lastPlate = nil
            state.lastPrimaryColour = nil
            rainbowChanges = 0
            goto continue
        end

        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= state.lastVehicle then
            state.lastVehicle = vehicle
            state.lastPlate = GetVehicleNumberPlateText(vehicle)
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            state.lastPrimaryColour = { r, g, b }
            rainbowWindow = now()
            rainbowChanges = 0
            goto continue
        end

        if UNIQUE_AC.AntiPlateChanger then
            local plate = GetVehicleNumberPlateText(vehicle)
            if state.lastPlate and plate ~= state.lastPlate then
                report(UNIQUE_AC.PlatePunishment, "Anti Plate Changer", state.lastPlate .. " -> " .. plate, "plate", 2)
                state.lastPlate = plate
            else
                clearEvidence("plate")
            end
        end

        if UNIQUE_AC.AntiBlackListPlate and type(Plate) == "table" then
            local currentPlate = (GetVehicleNumberPlateText(vehicle) or ""):gsub("%s+", "")
            for _, blocked in ipairs(Plate) do
                if currentPlate:upper() == tostring(blocked):gsub("%s+", ""):upper() then
                    report(UNIQUE_AC.PlatePunishment, "Anti Black List Plate", "Plate: " .. currentPlate, "blockedplate", 1)
                    break
                end
            end
        end

        if UNIQUE_AC.AntiRainbowVehicle then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            local old = state.lastPrimaryColour
            if old and (r ~= old[1] or g ~= old[2] or b ~= old[3]) then
                if now() - rainbowWindow > 5000 then
                    rainbowWindow = now()
                    rainbowChanges = 0
                end
                rainbowChanges = rainbowChanges + 1
                state.lastPrimaryColour = { r, g, b }
                if rainbowChanges >= 4 then
                    report(UNIQUE_AC.RainbowPunishment, "Anti Rainbow", "Vehicle colour changed rapidly", "rainbow", 2, 20000)
                    rainbowChanges = 0
                end
            end
        end

        if UNIQUE_AC.AntiChangeSpeed then
            local speed = GetEntitySpeed(vehicle)
            local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
            if maxSpeed > 1.0 and speed > maxSpeed + 18.0 then
                report(UNIQUE_AC.SpeedPunishment, "Anti Speed Changer", ("%.1f km/h, estimated max %.1f km/h"):format(speed * 3.6, maxSpeed * 3.6), "vehiclespeed", 4)
            else
                clearEvidence("vehiclespeed")
            end
        end

        ::continue::
    end
end)

local camHistory = {}
local aimbotHits = {}

CreateThread(function()
    while true do
        Wait(100)
        if UNIQUE_AC.AimbotWatch and UNIQUE_AC.AimbotWatch.Enable then
            local rot = GetGameplayCamRot(2)
            table.insert(camHistory, { t = now(), x = rot.x, z = rot.z })
            if #camHistory > 30 then table.remove(camHistory, 1) end
        end
    end
end)

local function angleDelta(a, b)
    local d = math.abs(a - b) % 360.0
    if d > 180.0 then d = 360.0 - d end
    return d
end

local function camSnapOverLastWindow(windowMs)
    local nowT = now()
    local currentRot = GetGameplayCamRot(2)
    local best = nil
    for i = #camHistory, 1, -1 do
        local sample = camHistory[i]
        if nowT - sample.t >= windowMs then
            best = sample
            break
        end
    end
    if not best then return 0.0 end
    return angleDelta(currentRot.z, best.z) + angleDelta(currentRot.x, best.x)
end

local function evaluateAimbotPattern()
    local cfg = UNIQUE_AC.AimbotWatch
    if not cfg or not cfg.Enable then return end
    local minSample = tonumber(cfg.MinSampleHits) or 8
    if #aimbotHits < minSample then return end

    local headshots, snapSum, snapCount = 0, 0.0, 0
    for _, hit in ipairs(aimbotHits) do
        if hit.headshot then
            headshots = headshots + 1
            snapSum = snapSum + hit.snap
            snapCount = snapCount + 1
        end
    end

    local ratio = headshots / #aimbotHits
    local avgSnap = snapCount > 0 and (snapSum / snapCount) or 0.0

    if ratio >= (tonumber(cfg.HeadshotRatio) or 0.75) and avgSnap >= (tonumber(cfg.SnapAngleDegrees) or 35.0) then
        report(UNIQUE_AC.AimbotPunishment, "Anti Aimbot Pattern",
            ("Headshot ratio %.0f%% over %d hits, avg snap %.0f deg"):format(ratio * 100, #aimbotHits, avgSnap),
            "aimbot", 1, 15000)
        aimbotHits = {}
    end
end

AddEventHandler("gameEventTriggered", function(name, args)
    if not state.ready or now() < state.graceUntil then return end

    if UNIQUE_AC.AntiPickupCollect and name == "CEventNetworkPlayerCollectedPickup" then
        report(UNIQUE_AC.PickupPunishment, "Anti Collected Pickup", json.encode(args), "pickup", 2)
    end

    if UNIQUE_AC.AntiSuicide and name == "CEventNetworkEntityDamage" and args and args[1] == PlayerPedId() and args[2] == PlayerPedId() then
        report(UNIQUE_AC.SuicidePunishment, "Anti Suicide", "Self-inflicted network damage", "suicide", 2)
    end

    if UNIQUE_AC.AimbotWatch and UNIQUE_AC.AimbotWatch.Enable and name == "CEventNetworkEntityDamage"
        and args and args[2] == PlayerPedId() and args[1] ~= PlayerPedId() then
        local isHeadShot = args[5] == true or args[5] == 1
        local windowMs = tonumber(UNIQUE_AC.AimbotWatch.SnapWindowMs) or 150
        local snap = camSnapOverLastWindow(windowMs)
        table.insert(aimbotHits, { headshot = isHeadShot, snap = snap })
        local maxSample = math.max(8, tonumber(UNIQUE_AC.AimbotWatch.MinSampleHits) or 8)
        if #aimbotHits > maxSample then table.remove(aimbotHits, 1) end
        evaluateAimbotPattern()
    end
end)

function UNIQUE_AC_ACTION(punishment, reason, details)
    report(punishment, reason, details, reason, 1)
end

function UNIQUE_AC_CHANGE_TEMP_WHHITELIST(status, durationMs)
    if status == true then
        local duration = math.min(math.max(tonumber(durationMs) or 60000, 1000), 600000)
        state.pausedUntil = now() + duration
    else
        state.pausedUntil = 0
    end
end

function UNIQUE_AC_CHANGE_TEMP_WHITELIST(status, durationMs)
    return UNIQUE_AC_CHANGE_TEMP_WHHITELIST(status, durationMs)
end

function UNIQUE_AC_CHECK_TEMP_WHITELIST()
    return now() < state.pausedUntil
end
