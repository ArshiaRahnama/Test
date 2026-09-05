-- Dramatic "banhammer" scene played on the target right before the ban
-- actually takes effect (see the SetTimeout in server/admin_tools.lua's
-- aban command). Two parts: an arrest scene (same proven drag-into-vehicle
-- mechanic as client/kick_scene.lua, reskinned with cops + a police
-- cruiser instead of a kidnapper + van), then an explosive "BANNED" finale.
--
-- Part 1 (arrest) is wrapped in pcall with its own streaming timeouts, so
-- its real duration varies (near-instant if cop/vehicle assets are already
-- cached, up to ~11s worst case if all three have to stream from disk).
-- Part 2 (finale) always runs for a fixed 6s regardless of what happened
-- in Part 1. server/admin_tools.lua's delay before the actual
-- ban/DropPlayer is set to a safe upper bound covering both.

local SAFE_UPPER_BOUND_MS = 12000 -- server/admin_tools.lua's aban delay before the real ban/DropPlayer

RegisterNetEvent('Unique_AdminMenu:PlayBanScene')
AddEventHandler('Unique_AdminMenu:PlayBanScene', function(reason)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- ------------------------------------------------- PART 1: ARREST ---
    -- Wrapped in pcall on purpose: whatever happens in here (a bad model,
    -- an invalid entity handle, a native that errors), it must NEVER be
    -- able to stop Part 2 (the finale) below from running - that's what
    -- actually needs to happen for the ban itself to proceed on schedule.
    pcall(function()
        local carModel = joaat("police")
        local cruiser = GetClosestVehicle(coords, 15.0, carModel, 70)
        if not DoesEntityExist(cruiser) then
            RequestModel(carModel)
            local timeout = GetGameTimer() + 3000
            while not HasModelLoaded(carModel) and GetGameTimer() < timeout do Wait(0) end
            if HasModelLoaded(carModel) then
                cruiser = CreateVehicle(carModel, coords.x + 3.0, coords.y + 1.0, coords.z, 0.0, true, false)
            end
        end
        if not DoesEntityExist(cruiser) then return end
        SetVehicleSiren(cruiser, true)

        local animDict = 'random@kidnap_girl'
        RequestAnimDict(animDict)
        local dictTimeout = GetGameTimer() + 3000
        while not HasAnimDictLoaded(animDict) and GetGameTimer() < dictTimeout do Wait(0) end
        if not HasAnimDictLoaded(animDict) then return end

        local copModel = joaat("s_m_y_cop_01")
        RequestModel(copModel)
        local copTimeout = GetGameTimer() + 3000
        while not HasModelLoaded(copModel) and GetGameTimer() < copTimeout do Wait(0) end
        if not HasModelLoaded(copModel) then return end

        local cop1 = CreatePed(0, copModel, coords.x + 1.0, coords.y, coords.z, 0.0, true, true)
        local cop2 = CreatePed(0, copModel, coords.x - 1.0, coords.y + 0.5, coords.z, 0.0, true, true)
        if not DoesEntityExist(cop1) then return end
        for _, cop in ipairs({ cop1, cop2 }) do
            if DoesEntityExist(cop) then
                SetEntityAsMissionEntity(cop, true, true) -- protects it from ambient-population cleanup
                SetBlockingOfNonTemporaryEvents(cop, true)
                SetPedCanRagdoll(cop, false)
            end
        end

        local scenePos = GetEntityCoords(cruiser)
        local sceneRot = GetEntityRotation(cruiser)

        local scene = NetworkCreateSynchronisedScene(scenePos, sceneRot, 2, false, false, 1.0, 0, 1.0)
        NetworkAddPedToSynchronisedScene(playerPed, scene, animDict, "ig_1_girl_drag_into_van", 8.0, -4.0, 1, 16, 0, 0)
        NetworkAddPedToSynchronisedScene(cop1, scene, animDict, "ig_1_guy2_drag_into_van", 8.0, -4.0, 1, 16, 0, 0)
        NetworkAddEntityToSynchronisedScene(cruiser, scene, animDict, "drag_into_van_burr", 1.0, 1.0, 1)
        NetworkStartSynchronisedScene(scene)

        -- Second cop just stands watch nearby, radio-chatter style, for a
        -- fuller "you're surrounded" arrest feel without needing a second
        -- synced clip slot.
        if DoesEntityExist(cop2) then
            TaskStartScenarioInPlace(cop2, "WORLD_HUMAN_AA_COFFEE", 0, true)
        end

        ClearPedTasksImmediately(playerPed) -- in case a previous ragdoll/task is still queued
        local animMs = math.max(GetAnimDuration(animDict, "drag_into_van_burr") * 1000, 2000)
        Wait(animMs)

        ClearPedTasks(playerPed)
        if DoesEntityExist(cop1) then
            SetEntityAsMissionEntity(cop1, false, true)
            DeleteEntity(cop1)
        end
        if DoesEntityExist(cop2) then
            SetEntityAsMissionEntity(cop2, false, true)
            DeleteEntity(cop2)
        end
        SetVehicleSiren(cruiser, false)
    end)

    -- --------------------------------------------- PART 2: BANHAMMER ---
    FreezeEntityPosition(playerPed, false)
    SetTimeScale(0.25)
    SetPedToRagdoll(playerPed, 5500, 5500, 0, true, true, false)
    SetEntityVelocity(playerPed, 0.0, 0.0, 3.0)
    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)

    local finaleCoords = GetEntityCoords(playerPed)
    CreateThread(function()
        Wait(1200) -- real-time; Wait() isn't affected by SetTimeScale
        SetTimeScale(1.0)

        AddExplosion(finaleCoords.x, finaleCoords.y, finaleCoords.z, 12, 0.0, true, false, 0.0, true)
        ShakeGameplayCam("JOLT_SHAKE", 3.0)
        PlaySoundFrontend(-1, "Bed", "WastedSounds", true)

        Wait(200)
        AddExplosion(finaleCoords.x + 0.6, finaleCoords.y, finaleCoords.z, 12, 0.0, true, false, 0.0, true)
        Wait(200)
        AddExplosion(finaleCoords.x - 0.6, finaleCoords.y + 0.4, finaleCoords.z, 12, 0.0, true, false, 0.0, true)
        ShakeGameplayCam("EXPLOSION_SHAKE", 2.5)

        AnimpostfxPlay("DeathFailOut", 0, false)
    end)

    -- Fixed finale window now (was BAN_SCENE_DURATION minus a GetAnimDuration
    -- call that could return 0 for this clip name and silently shrink the
    -- whole finale to nothing) - Part 1 above is capped at ~11s worst case
    -- (three 3s streaming timeouts + a 2s min anim wait), so give the
    -- finale a fixed, guaranteed window after it instead of depending on
    -- Part 1's actual timing.
    local finaleDuration = 6000
    local endAt = GetGameTimer() + finaleDuration
    CreateThread(function()
        Wait(1200)
        while GetGameTimer() < endAt do
            SetTextFont(4)
            SetTextScale(1.8, 1.8)
            SetTextColour(220, 30, 30, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(3, 0, 0, 0, 200)
            SetTextOutline()
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("~r~BANNED")
            DrawText(0.5, 0.38)

            if reason and reason ~= "" then
                SetTextFont(4)
                SetTextScale(0.5, 0.5)
                SetTextColour(255, 255, 255, 220)
                SetTextDropshadow(0, 0, 0, 0, 200)
                SetTextEdge(2, 0, 0, 0, 180)
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(reason)
                DrawText(0.5, 0.46)
            end

            Wait(0)
        end
    end)

    Wait(finaleDuration - 1500)
    DoScreenFadeOut(1500)
    Wait(1500)
end)
