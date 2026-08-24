

ESX = nil
PlayerData = nil
Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent(Config.getSharedObjectTrigger, function(obj) ESX = obj end)
        Citizen.Wait(5)
    end
    while not PlayerData do
        Citizen.Wait(5)
        PlayerData = ESX.GetPlayerData()
    end
    while not PlayerData.gang do
        Citizen.Wait(5)
        PlayerData = ESX.GetPlayerData()
    end
end)

function Notify(message, notifyType, title)
    local oxType = notifyType
    if oxType == 'error' then oxType = 'error'
    elseif oxType == 'success' then oxType = 'success'
    elseif oxType == 'info' then oxType = 'inform'
    else oxType = 'inform' end

    lib.notify({
        title = title or 'Unique Capture',
        description = message,
        type = oxType,
        position = 'center-right',
    })
end

RegisterNetEvent("arshiahub.ir-Capture:OxNotify")
AddEventHandler("arshiahub.ir-Capture:OxNotify", function(message, notifyType, title)
    Notify(message, notifyType, title)
end)

local ActiveTheme = Config.Themes[Config.ActiveTheme] or Config.Themes.Default
RegisterNetEvent("arshiahub.ir-CaptureSystem:SetTheme")
AddEventHandler("arshiahub.ir-CaptureSystem:SetTheme", function(theme)
    if theme then ActiveTheme = theme end
end)
RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang',function(Gang)
    PlayerData.gang = Gang
end)

CaptureDetails = {
    CaptureHolderGang = {}
}

RegisterNetEvent("arshiahub.ir-CaptureSystem:UpdateHolderGang")
AddEventHandler("arshiahub.ir-CaptureSystem:UpdateHolderGang",function(ZonesHolderGangs)
    CaptureDetails.CaptureHolderGang = ZonesHolderGangs
end)

PlayerCaptureInf = {
    InCapture = false,
    Alive = false,
    InMenu = nil,
    OnGround = false,
    IsOnMarker = false,
    Weapon = nil,
    Armor = 0,
    Group = nil,
    ZoneCoord = nil
}

RegisterCommand(Config.ReSpawnCaptureCommand,function()
    if PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then
        ReSpawn()
    end
end,false)

RegisterCommand(Config.DashboardCommand, function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetDashboard', function(data)
        SetNuiFocus(true, true)
        SendNUIMessage({action = "openDashboard", data = data})
    end)
end, false)

RegisterNUICallback('closeDashboard', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('dashboardAction', function(data, cb)
    local actionMap = {
        join = Config.JoinCaptureCommand,
        leave = Config.LeaveCaptureCommand,
        respawn = Config.ReSpawnCaptureCommand,
        seasons = Config.SeasonHistoryCommand,
        standings = Config.StandingsCommand,
        medals = Config.ScarcityStatusCommand,
        mymedals = Config.MyMedalsCommand,
        halloffame = Config.HallOfFameCommand,
        enterAcademy = Config.AcademyCommand,
        leaveAcademy = Config.AcademyLeaveCommand,
        spectate = Config.SpectateCommand,
    }
    local commandToRun = data and data.action and actionMap[data.action]
    if commandToRun then
        ExecuteCommand(commandToRun)
    end
    cb('ok')
end)

if Config.EnableAcademy then
    local AcademyActive = false
    local AcademyPeds = {}
    local AcademySessionKills = 0
    local AcademyTotalKills = 0
    local AcademySessionStart = 0
    local AcademyEntryCoords = nil
    local AcademyDead = false
    local AcademyReviveBusy = false
    local AcademyInSafeZone = false
    local TutorialShown = false
    local LastReminderInterval = 0
    local AcademyLeavePed = nil

    Citizen.CreateThread(function()
        AddRelationshipGroup("ACADEMY_ENEMY")
        local group = GetHashKey("ACADEMY_ENEMY")
        SetRelationshipBetweenGroups(5, group, GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), group)
    end)

    function IsNearAcademyEntry()
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, point in ipairs(Config.AcademyEntryPoints) do
            if #(playerCoords - vector3(point.x, point.y, point.z)) <= Config.AcademyEntryRadius then
                return true
            end
        end
        return false
    end

    function TryEnterAcademy()
        if AcademyActive then
            Notify("You Are Already In The Academy !", 'error')
            return
        end
        if PlayerCaptureInf.InCapture then
            Notify("You Can't Enter The Academy While In A Real Capture !", 'error')
            return
        end
        if not IsNearAcademyEntry() then
            Notify("You Must Be Near An Academy Entry Point To Enter !", 'error')
            return
        end
        AcademyEntryCoords = GetEntityCoords(PlayerPedId())
        AcademyActive = true
        TriggerServerEvent("arshiahub.ir-Capture:EnterAcademyWorld")
    end

    RegisterCommand(Config.AcademyCommand, TryEnterAcademy, false)


    Citizen.CreateThread(function()
        RequestModel(GetHashKey(Config.AcademyInstructorPedModel))
        local timeout = 0
        while not HasModelLoaded(GetHashKey(Config.AcademyInstructorPedModel)) and timeout < 100 do
            Citizen.Wait(10)
            timeout = timeout + 1
        end
        for _, point in ipairs(Config.AcademyEntryPoints) do
            local instructor = CreatePed(4, GetHashKey(Config.AcademyInstructorPedModel), point.x, point.y, point.z, point.w, false, true)
            if DoesEntityExist(instructor) then
                FreezeEntityPosition(instructor, true)
                SetEntityInvincible(instructor, true)
                SetBlockingOfNonTemporaryEvents(instructor, true)
                TaskStartScenarioInPlace(instructor, "WORLD_HUMAN_COP_IDLES", 0, true)

                if GetResourceState('ox_target') == 'started' then
                    exports.ox_target:addLocalEntity(instructor, {
                        {
                            name = 'academy_enter_' .. tostring(instructor),
                            icon = 'fa-solid fa-crosshairs',
                            label = 'Enter Training Academy',
                            distance = 2.5,
                            onSelect = function()
                                TryEnterAcademy()
                            end,
                        }
                    })
                end
            end
        end
    end)

    -- Map blips for every Academy entry point, so players can actually find it.
    Citizen.CreateThread(function()
        for _, point in ipairs(Config.AcademyEntryPoints) do
            local blip = AddBlipForCoord(point.x, point.y, point.z)
            SetBlipSprite(blip, Config.AcademyBlip.Sprite)
            SetBlipDisplay(blip, Config.AcademyBlip.Display)
            SetBlipScale(blip, Config.AcademyBlip.Scale)
            SetBlipColour(blip, Config.AcademyBlip.Color)
            SetBlipAsShortRange(blip, Config.AcademyBlip.ShortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.AcademyBlip.Label)
            EndTextCommandSetBlipName(blip)
        end
    end)


    function GetAcademyDifficulty()
        local tier = math.floor(AcademyTotalKills / Config.AcademyDifficultyStep)
        local accuracy = math.min(Config.AcademyBaseAccuracy + (tier * 5), Config.AcademyMaxAccuracy)
        local armor = math.min(Config.AcademyBaseArmor + (tier * 10), Config.AcademyMaxArmor)
        return accuracy, armor
    end

    -- How many NPCs SHOULD be alive/active right now, based on total kills.
    -- Starts at Config.AcademyStartNPCCount and climbs by 1 every
    -- Config.AcademyNPCCountStep kills, never exceeding Config.AcademyMaxNPCCount.
    function GetAcademyActiveNPCCount()
        local extra = math.floor(AcademyTotalKills / Config.AcademyNPCCountStep)
        return math.min(Config.AcademyMaxNPCCount, Config.AcademyStartNPCCount + extra)
    end

    function CountAliveAcademyPeds()
        local count = 0
        for _, npc in ipairs(AcademyPeds) do
            if DoesEntityExist(npc) and not IsEntityDead(npc) then
                count = count + 1
            end
        end
        return count
    end

    -- Drops dead/deleted entries from AcademyPeds so it doesn't grow
    -- forever over a long session — every other function that reads
    -- this list is O(n) over it.
    local function PruneDeadAcademyPeds()
        local kept = {}
        for _, npc in ipairs(AcademyPeds) do
            if DoesEntityExist(npc) then
                table.insert(kept, npc)
            end
        end
        AcademyPeds = kept
    end

    -- Fully arms/disarms an NPC against the player: while the Safe Zone is
    -- active they're switched to a neutral relationship group and stood
    -- down, so they can't re-acquire the player as a target at all — not
    -- just "stop shooting for a moment".
    function ApplyAcademyPedSettings(npc)
        local accuracy, armor = GetAcademyDifficulty()
        SetPedAccuracy(npc, accuracy)
        SetPedArmour(npc, armor)
        if AcademyInSafeZone then
            SetPedRelationshipGroupHash(npc, GetHashKey("PLAYER"))
            SetPedCombatAttributes(npc, 46, false)
            ClearPedTasksImmediately(npc)
        else
            SetPedRelationshipGroupHash(npc, GetHashKey("ACADEMY_ENEMY"))
            SetPedCombatAttributes(npc, 46, true)
            TaskCombatPed(npc, PlayerPedId(), 0, 16)
        end
    end

    function WatchAcademyPedDeath(npc)
        Citizen.CreateThread(function()
            while AcademyActive and DoesEntityExist(npc) do
                Citizen.Wait(Config.AcademyKillCheckInterval)
                if DoesEntityExist(npc) and IsEntityDead(npc) then
                    AcademySessionKills = AcademySessionKills + 1
                    AcademyTotalKills = AcademyTotalKills + 1
                    TriggerServerEvent("arshiahub.ir-Capture:AcademyNpcKilled")
                    SendNUIMessage({
                        action = "academyKillUpdate",
                        sessionKills = AcademySessionKills,
                        totalKills = AcademyTotalKills,
                    })
                    SetTimeout(3000, function()
                        if DoesEntityExist(npc) then DeleteEntity(npc) end
                        PruneDeadAcademyPeds()
                    end)

                    -- Always replace the one that just died, then trickle in
                    -- any extra NPCs the new kill count has unlocked — one
                    -- at a time, spaced out, never as a sudden swarm.
                    SetTimeout(4000, function()
                        if not AcademyActive then return end
                        SpawnOneAcademyPed()
                        local desired = GetAcademyActiveNPCCount()
                        local toAdd = desired - CountAliveAcademyPeds()
                        for i = 1, toAdd do
                            SetTimeout((2000 * i) + math.random(500, 1500), function()
                                if AcademyActive then SpawnOneAcademyPed() end
                            end)
                        end
                    end)
                    return
                end
            end
        end)
    end

    function SpawnOneAcademyPed()
        local offsetX = math.random(-15, 15)
        local offsetY = math.random(-15, 15)
        RequestModel(GetHashKey(Config.AcademyNPCModel))
        local timeout = 0
        while not HasModelLoaded(GetHashKey(Config.AcademyNPCModel)) and timeout < 100 do
            Citizen.Wait(10)
            timeout = timeout + 1
        end
        local npc = CreatePed(4, GetHashKey(Config.AcademyNPCModel), Config.AcademyCoord.x + offsetX, Config.AcademyCoord.y + offsetY, Config.AcademyCoord.z, 0.0, true, true)
        if DoesEntityExist(npc) then
            table.insert(AcademyPeds, npc)
            GiveWeaponToPed(npc, GetHashKey(Config.AcademyWeapon), 250, false, true)
            ApplyAcademyPedSettings(npc)
            WatchAcademyPedDeath(npc)
        end
    end


    -- Clamps health back up to the floor. Called both reactively (the instant
    -- damage lands) and from a tight backup poll, so a rifle burst can't slip
    -- health past zero in the gap between checks.
    local function EnforceAcademyHealthFloor()
        local ped = PlayerPedId()
        if IsEntityDead(ped) then return end
        local maxHealth = GetEntityMaxHealth(ped)
        local floorHealth = math.floor(maxHealth * Config.AcademyHealthFloorPercent)
        if GetEntityHealth(ped) < floorHealth then
            SetEntityHealth(ped, floorHealth)
        end
    end

    -- Reacts to damage the same frame it happens — far faster than any poll
    -- interval, so health almost never gets a chance to dip below the floor
    -- in the first place.
    AddEventHandler('gameEventTriggered', function(name, args)
        if not AcademyActive or name ~= 'CEventNetworkEntityDamage' then return end
        local victim = args[1]
        if victim == PlayerPedId() then
            EnforceAcademyHealthFloor()
        end
    end)

    function StartAcademyHealthFloor()
        Citizen.CreateThread(function()
            while AcademyActive do
                Citizen.Wait(0)
                EnforceAcademyHealthFloor()
            end
        end)
    end



    function StartAcademyDeathWatch()
        Citizen.CreateThread(function()
            while AcademyActive do
                Citizen.Wait(0)
                if not AcademyDead and IsEntityDead(PlayerPedId()) then
                    AcademyDead = true
                end
                if AcademyDead then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("~r~You died in training.~s~ Press ~INPUT_CONTEXT~ to respawn")
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    if not AcademyReviveBusy and IsControlJustPressed(0, 38) then
                        AcademyReviveBusy = true
                        local ped = PlayerPedId()
                        SetEntityVisible(ped, false, false)
                        Citizen.Wait(1200)
                        TriggerEvent(Config.ReviveTrigger)
                        Citizen.Wait(800)
                        SetEntityCoords(ped, Config.AcademyCoord.x, Config.AcademyCoord.y, Config.AcademyCoord.z, false, false, false, false)
                        SetEntityVisible(ped, true, false)
                        -- The external revive trigger may reset max health back to
                        -- default — reapply the training boost after it runs.
                        SetEntityMaxHealth(ped, Config.AcademyPlayerMaxHealth)
                        SetEntityHealth(ped, Config.AcademyPlayerMaxHealth)
                        SetPedArmour(ped, 100)
                        ClearPedBloodDamage(ped)
                        GiveWeaponToPed(ped, GetHashKey(Config.AcademyWeapon), 250, false, true)
                        -- You respawn right on the safe-zone center, so guarantee that
                        -- state immediately instead of waiting for the next zone tick.
                        AcademyInSafeZone = true
                        SetEntityInvincible(ped, true)
                        Notify("Respawned ! Keep training.", 'success')
                        AcademyDead = false
                        AcademyReviveBusy = false
                    end
                end
            end
        end)
    end


    function StartAcademySafeZone()
        local safePoint = Config.AcademyCoord + Config.AcademySafeZoneOffset

        -- Zone state (NPC re-tasking, invincibility, notifications) — this
        -- doesn't need per-frame precision, a distance check every 100ms is plenty.
        Citizen.CreateThread(function()
            while AcademyActive do
                Citizen.Wait(100)
                local dist = #(GetEntityCoords(PlayerPedId()) - safePoint)
                local nowInSafeZone = dist <= Config.AcademySafeZoneRadius
                if nowInSafeZone ~= AcademyInSafeZone then
                    AcademyInSafeZone = nowInSafeZone
                    SetEntityInvincible(PlayerPedId(), AcademyInSafeZone)
                    for _, npc in ipairs(AcademyPeds) do
                        if DoesEntityExist(npc) then
                            if AcademyInSafeZone then
                                SetPedRelationshipGroupHash(npc, GetHashKey("PLAYER"))
                                SetPedCombatAttributes(npc, 46, false)
                                ClearPedTasksImmediately(npc)
                            else
                                SetPedRelationshipGroupHash(npc, GetHashKey("ACADEMY_ENEMY"))
                                SetPedCombatAttributes(npc, 46, true)
                                TaskCombatPed(npc, PlayerPedId(), 0, 16)
                            end
                        end
                    end
                    if AcademyInSafeZone then
                        Notify("You're in the Safe Zone — NPCs can't touch you here.", 'info')
                    else
                        Notify("You left the Safe Zone — NPCs are coming for you !", 'error')
                    end
                end
            end
        end)
    end


    function StartAcademyTimeReminder()
        LastReminderInterval = 0
        Citizen.CreateThread(function()
            while AcademyActive do
                Citizen.Wait(30000)
                local elapsedMinutes = math.floor((GetGameTimer() - AcademySessionStart) / 60000)
                if elapsedMinutes >= Config.AcademyTimeLimitMinutes then
                    local interval = math.floor((elapsedMinutes - Config.AcademyTimeLimitMinutes) / Config.AcademyReminderIntervalMinutes)
                    if interval > LastReminderInterval or (interval == 0 and LastReminderInterval == 0 and elapsedMinutes == Config.AcademyTimeLimitMinutes) then
                        LastReminderInterval = math.max(interval, 1)
                        Notify("You've been training for a while — why not try a real capture round ?", 'info')
                    end
                end
            end
        end)
    end

    RegisterNetEvent("arshiahub.ir-Capture:AcademyPedsSpawned")
    AddEventHandler("arshiahub.ir-Capture:AcademyPedsSpawned", function(pedNetIds, currentKills)
        if not AcademyActive then return end
        local ped = PlayerPedId()
        AcademyDead = false
        AcademyReviveBusy = false
        -- You spawn exactly on Config.AcademyCoord, which is now the safe-zone center,
        -- so you start inside it — NPCs only engage once you actually walk out.
        AcademyInSafeZone = true
        SetEntityInvincible(ped, true)
        SetEntityMaxHealth(ped, Config.AcademyPlayerMaxHealth)
        SetEntityHealth(ped, Config.AcademyPlayerMaxHealth)
        SetEntityCoords(ped, Config.AcademyCoord.x, Config.AcademyCoord.y, Config.AcademyCoord.z, false, false, false, false)
        GiveWeaponToPed(ped, GetHashKey(Config.AcademyWeapon), 250, false, true)
        SetPedArmour(ped, 100)
        Notify("Welcome To The Training Academy ! Defeat the NPCs. No real stats are recorded here.", 'success')

        AcademySessionKills = 0
        AcademyTotalKills = currentKills or 0
        AcademySessionStart = GetGameTimer()
        SendNUIMessage({
            action = "academyOpen",
            totalKills = AcademyTotalKills,
        })

        if not TutorialShown then
            TutorialShown = true
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "This is the Training Academy — practice aim on NPCs, no real stats recorded."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "How a REAL capture round works, step by step:"}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "1) An admin starts a round with /startCap — everyone gets a chat alert to /joinCap."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "2) /joinCap opens a zone selector — pick which zone you want to fight for."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "3) You parachute in and land near that zone's capture point (a marked circle)."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "4) Walk INTO the capture point marker and stay there without leaving."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "5) After a few seconds of standing still inside it, the zone flips to your gang."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "6) Keep defending it — every 15s it's yours, your gang scores points."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "7) Enemies can retake it the same way — if they get halfway, your gang gets warned."}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "8) Leaving mid-defense with /leaveCap locks you out of that zone for a few minutes — don't rage quit!"}})
            TriggerEvent('chat:addMessage', {args = {"^3[Academy Guide]", "Go practice your aim here first. Good luck out there !"}})
        end

        AcademyPeds = {}
        for _, netId in ipairs(pedNetIds) do
            Citizen.CreateThread(function()
                local timeout = 0
                while not NetworkDoesNetworkIdExist(netId) and timeout < 100 do
                    Citizen.Wait(10)
                    timeout = timeout + 1
                end
                local npc = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(npc) then
                    table.insert(AcademyPeds, npc)
                    ApplyAcademyPedSettings(npc)
                    WatchAcademyPedDeath(npc)
                end
            end)
        end


        Citizen.CreateThread(function()
            RequestModel(GetHashKey(Config.AcademyInstructorPedModel))
            local timeout = 0
            while not HasModelLoaded(GetHashKey(Config.AcademyInstructorPedModel)) and timeout < 100 do
                Citizen.Wait(10)
                timeout = timeout + 1
            end
            local leavePoint = Config.AcademyCoord + vector3(3.0, 3.0, 0.0)
            AcademyLeavePed = CreatePed(4, GetHashKey(Config.AcademyInstructorPedModel), leavePoint.x, leavePoint.y, leavePoint.z, 0.0, true, true)
            if DoesEntityExist(AcademyLeavePed) then
                FreezeEntityPosition(AcademyLeavePed, true)
                SetEntityInvincible(AcademyLeavePed, true)
                SetBlockingOfNonTemporaryEvents(AcademyLeavePed, true)
                SetPedRelationshipGroupHash(AcademyLeavePed, GetHashKey("PLAYER"))
                TaskStartScenarioInPlace(AcademyLeavePed, "WORLD_HUMAN_COP_IDLES", 0, true)

                if GetResourceState('ox_target') == 'started' then
                    exports.ox_target:addLocalEntity(AcademyLeavePed, {
                        {
                            name = 'academy_leave',
                            icon = 'fa-solid fa-door-open',
                            label = 'Leave Training Academy',
                            distance = 2.5,
                            onSelect = function()
                                LeaveAcademyNow()
                            end,
                        }
                    })
                end
            end
        end)

        StartAcademyHealthFloor()
        StartAcademyDeathWatch()
        StartAcademySafeZone()
        StartAcademyTimeReminder()

        Citizen.CreateThread(function()
            while AcademyActive do
                Citizen.Wait(1000)
                local elapsed = math.floor((GetGameTimer() - AcademySessionStart) / 1000)
                local mins = string.format("%02d", math.floor(elapsed / 60))
                local secs = string.format("%02d", elapsed % 60)
                SendNUIMessage({action = "academyTimer", time = mins .. ":" .. secs})
            end
        end)


        Citizen.CreateThread(function()
            local point = Config.AcademyCoord + Config.AcademyTutorialPointOffset
            local explained = false
            while AcademyActive do
                Citizen.Wait(0)
                local dist = #(GetEntityCoords(PlayerPedId()) - point)
                if dist <= 15.0 then
                    DrawMarker(1, point.x, point.y, point.z - 1.0, 0.0,0.0,0.0, 0.0,0.0,0.0, 6.0,6.0,2.0, 0,255,0,100, false,false,2,false,nil,nil,false)
                    if dist <= 3.0 and not explained then
                        explained = true
                        TriggerEvent('chat:addMessage', {args = {"^2[Academy]", "This green circle is a practice capture point — this is EXACTLY what you'll stand in during a real round."}})
                    end
                else
                    Citizen.Wait(500)
                end
            end
        end)
    end)

    function LeaveAcademyNow()
        if not AcademyActive then return end
        AcademyActive = false
        AcademyDead = false
        AcademyReviveBusy = false
        AcademyInSafeZone = false
        SetEntityInvincible(PlayerPedId(), false)
        do
            local ped = PlayerPedId()
            SetEntityMaxHealth(ped, Config.AcademyDefaultPlayerMaxHealth)
            if GetEntityHealth(ped) > Config.AcademyDefaultPlayerMaxHealth then
                SetEntityHealth(ped, Config.AcademyDefaultPlayerMaxHealth)
            end
        end
        TriggerServerEvent("arshiahub.ir-Capture:LeaveAcademyWorld")
        AcademyPeds = {}
        if AcademyLeavePed and DoesEntityExist(AcademyLeavePed) then
            if GetResourceState('ox_target') == 'started' then
                exports.ox_target:removeLocalEntity(AcademyLeavePed, 'academy_leave')
            end
            DeleteEntity(AcademyLeavePed)
        end
        AcademyLeavePed = nil
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Config.AcademyWeapon))
        if AcademyEntryCoords then
            SetEntityCoords(PlayerPedId(), AcademyEntryCoords.x, AcademyEntryCoords.y, AcademyEntryCoords.z, false, false, false, false)
        else
            TpRandomOutCaptureCoord()
        end
        AcademyEntryCoords = nil
        SendNUIMessage({action = "academyClose"})
        Notify("Training Complete ! Session Kills: "..AcademySessionKills..". No real capture stats were recorded.", 'info')
    end

    RegisterCommand(Config.AcademyLeaveCommand, LeaveAcademyNow, false)
end

function HandleMarkers()
    Citizen.CreateThread(function()
        local blip
        local blip2
        blip = AddBlipForRadius(PlayerCaptureInf.ZoneCoord.x,PlayerCaptureInf.ZoneCoord.y,PlayerCaptureInf.ZoneCoord.z,Config.ZoneSize)
        SetBlipAlpha(blip, Config.ZoneBlip.Alpha)
        SetBlipColour(blip, Config.ZoneBlip.Color)

        blip2 = AddBlipForCoord(PlayerCaptureInf.ZoneCoord.x,PlayerCaptureInf.ZoneCoord.y,PlayerCaptureInf.ZoneCoord.z)
        SetBlipSprite(blip2, Config.CapturePointBlip.Model)
        SetBlipScale(blip2, 0.7)
        SetBlipColour(blip2, Config.CapturePointBlip.Color)
        SetBlipAsShortRange(blip2, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(PlayerCaptureInf.InCapture)
        EndTextCommandSetBlipName(blip2)

        while PlayerCaptureInf.InCapture do
            Citizen.Wait(0)
            if PlayerCaptureInf and PlayerCaptureInf.ZoneCoord and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then

                local PointColor = {Point = ActiveTheme.Point.Default, Zone = ActiveTheme.Zone.Default}
                if (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] == PlayerData.gang.name) then
                    PointColor = {Point = ActiveTheme.Point.Owned, Zone = ActiveTheme.Zone.Owned}
                end
                DrawMarker(
                    28,
                    PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    5.0, 5.0, 5.0,
                    PointColor.Point.R, PointColor.Point.G, PointColor.Point.B, PointColor.Point.Alpha,
                    false, true, 2, false, nil, nil, false
                )


                DrawMarker(
                    28,
                    PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z + 250.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    Config.ZoneSize + 3.8, Config.ZoneSize + 3.8, 1200.0,
                    PointColor.Zone.R, PointColor.Zone.G, PointColor.Zone.B, PointColor.Zone.Alpha,
                    false, true, 2, false, nil, nil, false
                )
            else
                RemoveBlip(blip)
                RemoveBlip(blip2)
            end
        end
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:JoinCapture")
AddEventHandler("arshiahub.ir-Capture:JoinCapture", function()
    if not PlayerCaptureInf.InCapture then
        ShowUi(true)
        GotoMenu()
    end
end)

function MenuSaver()
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while PlayerCaptureInf.InMenu and PlayerCaptureInf.InCapture do
            Citizen.Wait(300)
            if not ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), PlayerCaptureInf.InMenu) then
                if PlayerCaptureInf.InMenu == "CaptureMenu" then
                    GotoMenu()
                elseif PlayerCaptureInf.InMenu == "ZoneSelectorCaptureSystem" then
                    ZoneSelectorMenu()
                elseif PlayerCaptureInf.InMenu == "WeaponMenu" then
                    OpenWeaponGroupMenu()
                end
            end
        end
    end)

end

function GotoMenu()
    local PlayerPed = PlayerPedId()
    ESX.UI.Menu.CloseAll()
    TpRandomOutCaptureCoord()
    TriggerEvent('es_admin:freezePlayer', true)
    SetEntityVisible(PlayerPed, false, false)
    SetArmor()
    PlayerCaptureInf.InMenu = "CaptureMenu"
    PlayerCaptureInf.Alive = false
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        local elements = {}

        table.insert(elements, {label = '========== Your Current Data =========', value = nil})



        if not Config.UsePersonalWeapons then
            if not PlayerCaptureInf.Weapon then PlayerCaptureInf.Weapon = {'WEAPON_CARBINERIFLE'} end
            local weaponLabels = {}
            for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
                local label = ESX.GetWeaponLabel(weapon)
                table.insert(weaponLabels, label or weapon)
            end

            local fullLabel = table.concat(weaponLabels, " | ")
            table.insert(elements, {label = '🔫 Weapon : ' .. fullLabel or "None" , value = "changeWeapon"})
        end
        table.insert(elements, {label = '⌛ Remaining Time : ' .. tostring(CaptureInfo.Time), value = nil})
        table.insert(elements, {label = '🛡️ Armor : ' .. tostring(PlayerCaptureInf.Armor), value = nil})
        table.insert(elements, {label = '========== Actions =========', value = nil})
        table.insert(elements, {label = 'Goto Capture 🏳️', value = 'gotoCapture'})
        table.insert(elements, {label = 'Leave Capture 🚪', value = 'leaveCapture'})
        MenuSaver()
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureMenu',
            {
                title    = 'Capture Menu',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'gotoCapture' then
                    PlayerCaptureInf.InMenu = nil
                    ZoneSelectorMenu()
                    menu.close()
                elseif data.current.value == 'leaveCapture' then
                    ExecuteCommand(Config.LeaveCaptureCommand)
                    menu.close()
                elseif data.current.value == 'changeWeapon' then
                    PlayerCaptureInf.InMenu = nil
                    OpenWeaponGroupMenu()
                    menu.close()
                end
            end,
            function(data, menu)
            end
        )
    end)
end
RegisterNetEvent("arshiahub.ir-CaptureSystem:SendAllTimeTop")
AddEventHandler("arshiahub.ir-CaptureSystem:SendAllTimeTop", function(TopAllTime)
    if not PlayerCaptureInf.InCapture then return end
    local msg = { action = "updateAllTime" }
    for i = 1, 5 do
        if TopAllTime[i] then
            msg["alltimeplayer" .. i] = TopAllTime[i].name
            msg["alltimescore" .. i] = TopAllTime[i].score
            local photo = TopAllTime[i].Photo
            if photo and string.sub(photo, 1, 4) == "http" then
                msg["alltimephoto" .. i] = photo
            elseif photo then
                msg["alltimephoto" .. i] = string.format(Config.PlayerPhotoUrlTemplate, photo)
            else
                msg["alltimephoto" .. i] = Config.DefaultPlayerPhoto
            end
        end
    end
    SendNUIMessage(msg)
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:SendDataToUi")
AddEventHandler("arshiahub.ir-CaptureSystem:SendDataToUi", function(KillData, GangsData, Time, Percent)
    if not PlayerCaptureInf.InCapture then return end
    local msg = {
        action = "updateData",
        time = Time or "00:00",
        percent = Percent or 0
    }
    for i = 1, 5 do
        if KillData[i] then
            msg["playercallback" .. i] = KillData[i].Name
            msg["pointcallback" .. i] = KillData[i].Point
            local photo = KillData[i].Photo
            if photo and string.sub(photo, 1, 4) == "http" then
                msg["playerphotocallback" .. i] = photo
            elseif photo then
                msg["playerphotocallback" .. i] = string.format(Config.PlayerPhotoUrlTemplate, photo)
            else
                msg["playerphotocallback" .. i] = Config.DefaultPlayerPhoto
            end
        end
    end
    for i = 1, 5 do
        if GangsData[i] then
            msg["gangcallback" .. i] = GangsData[i].Name
            msg["gangpointcallback" .. i] = GangsData[i].Points
            local logo = GangsData[i].Logo or Config.DefaultGangLogo
            if string.sub(logo, 1, 4) == "http" then
                msg["ganglogocallback" .. i] = logo
            else
                msg["ganglogocallback" .. i] = string.format(Config.GangLogoUrlTemplate, logo)
            end
        end
    end
    SendNUIMessage(msg)
end)
local isVisible = false
AddEventHandler("onKeyDown", function(key)
    if not PlayerCaptureInf.InCapture then return end
    if key == "g" then
        isVisible = not isVisible
        SendNUIMessage({
            action = "toggleTips",
            hide = not isVisible
        })
    end
end)

function ShowUi(show)
    SendNUIMessage({action = "changeShow", hide = not show})
end

function ZoneSelectorMenu()
    local PlayerPed = PlayerPedId()
    ESX.UI.Menu.CloseAll()
    TpRandomOutCaptureCoord()
    TriggerEvent('es_admin:freezePlayer', true)
    SetEntityVisible(PlayerPed, false, false)
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        if CaptureInfo.Zones and next(CaptureInfo.Zones) ~= nil then
            local elements = {}

            table.insert(elements, {label = '========== Zones =========', value = nil})

            for zoneName, coords in pairs(CaptureInfo.Zones) do
                table.insert(elements, {label = '📍 Zone Name : ' .. zoneName, value = zoneName})
            end

            if #elements > 2 then
                PlayerCaptureInf.InMenu = "ZoneSelectorCaptureSystem"
                MenuSaver()
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'ZoneSelectorCaptureSystem',
                    {
                        title    = 'Capture Menu',
                        align    = "top-right",
                        elements = elements
                    },
                    function(data, menu)
                        if data.current.value then
                            PlayerCaptureInf.ZoneCoord = CaptureInfo.Zones[data.current.value]
                            PlayerCaptureInf.InCapture = data.current.value
                            menu.close()
                            PlayerCaptureInf.InMenu = nil
                            SpawnInCapture()
                        end
                    end,
                    function(data, menu)
                    end
                )
            else
                PlayerCaptureInf.InMenu = nil
                for k, v in pairs(CaptureInfo.Zones) do
                    PlayerCaptureInf.ZoneCoord = v
                    PlayerCaptureInf.InCapture = k
                    SpawnInCapture()
                end
            end
        end
    end)
end

function SpawnInCapture()
    ShowUi(true)
    ESX.UI.Menu.CloseAll()
    local PlayerPed = PlayerPedId()
    TriggerServerEvent("arshiahub.ir-CaptureSystem:PlayerEnterZone",PlayerCaptureInf.InCapture)

    PlayerCaptureInf.OnGround = false
    PlayerCaptureInf.InMenu = false
    PlayerCaptureInf.Alive = true

    HandleMarkers()

    if not Config.UsePersonalWeapons then
        if not PlayerCaptureInf.Weapon then PlayerCaptureInf.Weapon = {'WEAPON_CARBINERIFLE'} end
        SetCanPedEquipAllWeapons(PlayerPed, false)

        for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
            GiveWeaponToPed(PlayerPed, GetHashKey(weapon), 250, false, true)
            SetCanPedSelectWeapon(PlayerPed, GetHashKey(weapon), true)
        end
    end
    GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 1, false, true)


    TriggerEvent('es_admin:freezePlayer', false)
    SetEntityVisible(PlayerPed, true, false)
    TpRandomOutCaptureCoord()


    TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	SetEntityHealth(PlayerPed, GetEntityMaxHealth(PlayerPed))
    SetPedArmour(PlayerPed, PlayerCaptureInf.Armor)



    DeathLoop()
    LandingHandel()
end

function LeaveCapture(Voluntary)
    SendNUIMessage({action = "resetUi"})
    if PlayerCaptureInf.InCapture or PlayerCaptureInf.InMenu then
        local PlayerPed = PlayerPedId()
        if Voluntary and PlayerCaptureInf.IsOnMarker and PlayerCaptureInf.InCapture then
            TriggerServerEvent("arshiahub.ir-Capture:PenalizeZoneLeave", PlayerCaptureInf.InCapture)
        end
        ESX.UI.Menu.CloseAll()
        PlayerCaptureInf.InMenu = nil
        SetEntityVisible(PlayerPed, true, false)
        Citizen.Wait(2400)
        TriggerEvent(Config.ReviveTrigger)
        Citizen.Wait(2000)
        TriggerServerEvent("arshiahub.ir-Capture:LeaveCapture")
        SetCanPedEquipAllWeapons(PlayerPed, true)
        if PlayerCaptureInf.Weapon then
            for _, weapon in ipairs(PlayerCaptureInf.Weapon) do
                RemoveWeaponFromPed(PlayerPed, weapon)
            end
        end
        PlayerCaptureInf = {
            InCapture = false,
            Alive = false,
            InMenu = nil,
            OnGround = false,
            IsOnMarker = false,
            Weapon = nil,
            Armor = 100,
            Group = nil,
            ZoneCoord = nil
        }
    end

end

function LandingHandel()
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        local ZoneX, ZoneY, ZoneZ = PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z
        while true do
            Citizen.Wait(100)
            if not PlayerCaptureInf.InCapture then break end
            local PlayerX, PlayerY, PlayerZ = table.unpack(GetEntityCoords(PlayerPed))
            if #(vector2(PlayerX, PlayerY) - vector2(ZoneX, ZoneY)) <= Config.ZoneSize or PlayerZ <= Config.zToAutoTeleport and not PlayerCaptureInf.OnGround then
                local newX, newY = GetRandomInCaptureCoord(ZoneX, ZoneY)
                local zCoord = GetGroundZ(newX, newY)
                if zCoord == nil then
                    Wait(150)
                    newX, newY = GetRandomInCaptureCoord(ZoneX, ZoneY)
                    zCoord = GetGroundZ(newX, newY)
                end
                if zCoord == nil then zCoord = 30.0 end
                SetEntityCoords(PlayerPed, newX, newY, zCoord, false, false, false, false)
                PlayerCaptureInf.OnGround = true
                if HasPedGotWeapon(PlayerPed, GetHashKey("GADGET_PARACHUTE"), false) then
                    RemoveWeaponFromPed(PlayerPed, GetHashKey("GADGET_PARACHUTE"))
                end
                ZoneController()
                break
            end
        end
    end)
end

function GetGroundZ(x, y)
    local zCoord = 0.0
    local found = false

    for i = 1, 100 do
        Citizen.Wait(2)
        found, zCoord = GetGroundZFor_3dCoord(x, y, 300.0, 0)
        if found and zCoord ~= 0.0 then
            return zCoord + 1.0
        end
    end

    return nil
end

function GetRandomInCaptureCoord(baseX, baseY)
    local angle = math.random() * 2 * math.pi
    local distance = math.random(Config.ZoneSize - 30, Config.ZoneSize - 10)
    local offsetX = math.cos(angle) * distance
    local offsetY = math.sin(angle) * distance
    return baseX + offsetX, baseY + offsetY
end

function TpRandomOutCaptureCoord()
    local PlayerPed = PlayerPedId()
    if not PlayerCaptureInf.ZoneCoord or not PlayerCaptureInf.InCapture then
        SetEntityCoords(PlayerPed, 670.52, 844.99, 371.47)
        SetEntityHeading(PlayerPed, 351.5)
        SetGameplayCamRelativeHeading(0.0)
        return
    end
    local angle = math.random() * 2 * math.pi
    local radius = math.random(Config.ParchuteSpawnDistance.min + Config.ZoneSize, Config.ParchuteSpawnDistance.max + Config.ZoneSize)
    local X = PlayerCaptureInf.ZoneCoord.x + math.cos(angle) * radius
    local Y = PlayerCaptureInf.ZoneCoord.y + math.sin(angle) * radius
    local heading = math.deg(math.atan2(PlayerCaptureInf.ZoneCoord.y - Y, PlayerCaptureInf.ZoneCoord.x - X))
    SetEntityCoords(PlayerPed, X, Y, Config.ParchuteSpawnHeight, false, false, false, false)
    SetEntityHeading(PlayerPed, heading - 90.0)
    SetGameplayCamRelativeHeading(0.0)
end

function ReSpawn()
    if PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive then

        TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", nil, false)


        PlayerCaptureInf.Capture = nil

        PlayerCaptureInf.Alive = false
        PlayerCaptureInf.OnGround = false
        SetEntityVisible(PlayerPedId(), false, false)
        Citizen.Wait(2400)
        TriggerEvent(Config.ReviveTrigger)
        Citizen.Wait(2000)
        ZoneSelectorMenu()
    end
end
function DeathLoop()
    Citizen.CreateThread(function()
        while PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive do
            Citizen.Wait(0)
            if IsEntityDead(PlayerPedId()) then
                Citizen.Wait(500)
                local PedKiller = GetPedSourceOfDeath(PlayerPedId())
                local Killer
                if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                    Killer = NetworkGetPlayerIndexFromPed(PedKiller)
                end

                if Killer ~= nil then
                    if Killer ~= PlayerId() then
                        TriggerServerEvent('arshiahub.ir-Capture:KillerPoint',GetPlayerServerId(Killer))
                    end
                    TriggerServerEvent("arshiahub.ir-CaptureSystem:SendKillLog", GetPlayerServerId(Killer), PlayerCaptureInf.InCapture)
                end
                ReSpawn()
            end
        end
    end)
end

RegisterNetEvent("arshiahub.ir-CaptureSystem:ShowKillLog")
AddEventHandler("arshiahub.ir-CaptureSystem:ShowKillLog", function(DamagedID, KillerID, DamagedGang, KillerGang, DamagedName, KillerName, ZoneName, KillTime, KillerRank, DamagedRank)
    if not PlayerCaptureInf.InCapture then return end
    if Config.SplitZonesKillLog and ZoneName ~= PlayerCaptureInf.InCapture then return end

    local SelfID = GetPlayerServerId(PlayerId())
    local DamagedTag,KillerTag

    if DamagedGang == PlayerData.gang.name then
        DamagedTag = "team"
    else
        DamagedTag = "enemy"
    end
    if KillerGang == PlayerData.gang.name then
        KillerTag = "team"
    else
        KillerTag = "enemy"
    end
    SendNUIMessage({
        action = "newKill",
        killer = KillerName,
        damaged = DamagedName,
        team1 = KillerTag,
        team2 = DamagedTag,
        killerRank = KillerRank,
        damagedRank = DamagedRank,
    })

    TriggerEvent('chat:addMessage', {
        args = {
            "^1[Capture Kill]",
            "^3" .. KillTime .. " ^7| ^2" .. KillerName .. " ^6[" .. tostring(KillerRank) .. "]^7 (^5" .. KillerGang .. "^7) ^0killed ^1" .. DamagedName .. " ^6[" .. tostring(DamagedRank) .. "]^7 (^5" .. DamagedGang .. "^7) ^0in zone ^6" .. tostring(ZoneName)
        }
    })
end)

local CapturingThreadActive = false
local CancelLocalTimer = false

RegisterNetEvent("arshiahub.ir-Capture:CancelLocalZoneTimer")
AddEventHandler("arshiahub.ir-Capture:CancelLocalZoneTimer", function()
    CancelLocalTimer = true
end)

function StartCaptureZoneTimer()
    if CapturingThreadActive then return end
    CapturingThreadActive = true
    CancelLocalTimer = false
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        local TimeInZone = 0
        local HalfwayWarningSent = false
        if CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] == PlayerData.gang.name then
            CapturingThreadActive = false
            return
        end
        TriggerServerEvent("arshiahub.ir-CaptureSystem:ShowMessageToAll","Gang ~r~[~w~"..PlayerData.gang.name.."~r~]~w~ Dar Hale Capture Kardan Ast | Zone : ~g~[~r~"..PlayerCaptureInf.InCapture.."~g~]",5)
        Citizen.CreateThread(function()
            local Off = false
            SetTimeout((Config.TimeToCaptureZone + 2) * 1000 , function()
                Off = true
            end)
            while not Off and not CancelLocalTimer and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.IsOnMarker and (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] ~= PlayerData.gang.name) do
                Citizen.Wait(0)
                Draw3DText(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z + 1.0, "⏱️ " .. TimeInZone .. " / " .. Config.TimeToCaptureZone)
            end
        end)
        while not CancelLocalTimer and PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.IsOnMarker and (CaptureDetails.CaptureHolderGang[PlayerCaptureInf.InCapture] ~= PlayerData.gang.name) do
            Citizen.Wait(1000)
            local Distance = #(GetEntityCoords(PlayerPed) - vector3(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z))
            if Distance <= 5.0 then
                if PlayerCaptureInf.IsOnMarker then
                    TimeInZone = TimeInZone + 1

                    if not HalfwayWarningSent and TimeInZone >= math.floor(Config.TimeToCaptureZone / 2) then
                        HalfwayWarningSent = true
                        TriggerServerEvent("arshiahub.ir-Capture:ZoneUnderAttack", PlayerCaptureInf.InCapture, PlayerData.gang.name)
                    end

                    if TimeInZone >= Config.TimeToCaptureZone then
                        TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerWaitPassed")
                        CapturingThreadActive = false
                        return
                    end
                end
            end
        end
        CapturingThreadActive = false
    end)
end

function ZoneController()
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        Citizen.Wait(1000)
        while PlayerCaptureInf.InCapture and PlayerCaptureInf.Alive and PlayerCaptureInf.OnGround and PlayerCaptureInf.ZoneCoord do
            local Distance = #(GetEntityCoords(PlayerPed) - vector3(PlayerCaptureInf.ZoneCoord.x, PlayerCaptureInf.ZoneCoord.y, PlayerCaptureInf.ZoneCoord.z))

            if Distance >= Config.ZoneSize and PlayerCaptureInf.OnGround then
                local Hp = GetEntityHealth(PlayerPed)
                SetEntityHealth(PlayerPed, Hp - Config.OutOfZoneDamage)
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.1)
            end

            if Distance <= 5 then

                if not PlayerCaptureInf.IsOnMarker then
                    PlayerCaptureInf.IsOnMarker = true
                    TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", PlayerCaptureInf.InCapture, true)
                    StartCaptureZoneTimer()
                end
            else
                if PlayerCaptureInf.IsOnMarker then
                    PlayerCaptureInf.IsOnMarker = false
                    TriggerServerEvent("arshiahub.ir-Capture:CaptureMarkerStatus", nil, false)
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:LeaveCapture")
AddEventHandler("arshiahub.ir-Capture:LeaveCapture", function(Voluntary)
    LeaveCapture(Voluntary)
end)

RegisterNetEvent("arshiahub.ir-Capture:OpenAdminMenu")
AddEventHandler("arshiahub.ir-Capture:OpenAdminMenu", function()
    GotoAdminMenu()
end)

function GotoAdminMenu()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetInfo', function(CaptureInfo)
        ESX.UI.Menu.CloseAll()

        local elements = {
            {label = '========== Your Current Time =========', value = nil},
            {label = '🕒 Capture Time : ' .. tostring(CaptureInfo.Time), value = "changeTime"},
            {label = '========== Your Current Zones =========', value = nil},
        }

        if CaptureInfo.Zones and next(CaptureInfo.Zones) ~= nil then
            for zoneName, _ in pairs(CaptureInfo.Zones) do
                table.insert(elements, {label = '📍 Zone Name : ' .. zoneName, value = zoneName})
            end
        else
            table.insert(elements, {label = '📍 No Zones', value = nil})
        end

        local actions = {
            {label = '========== Actions =========', value = nil},
            {label = 'Add Zone 📍', value = 'addZone'},
            {label = 'Start Capture 🚪', value = 'startCap'},
            {label = 'Start Announce !', value = 'announce'},
        }

        for _, v in pairs(actions) do
            table.insert(elements, v)
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureAdminMenu',
            {
                title    = 'Capture Admin Menu',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'changeTime' then
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'CaptureTime',
                        { title = 'Change Capture Time' },
                        function(data2, menu2)
                            local time = tonumber(data2.value)
                            if time and time > 0 then
                                CaptureInfo.Time = time
                                TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                                GotoAdminMenu()
                            end
                            menu2.close()
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )

                elseif data.current.value == 'addZone' then
                    ESX.UI.Menu.Open(
                        'dialog', GetCurrentResourceName(), 'CaptureZoneName',
                        { title = 'Zone Name' },
                        function(data2, menu2)
                            if data2.value then
                                local coords = GetEntityCoords(PlayerPedId())
                                if type(CaptureInfo.Zones) ~= "table" then CaptureInfo.Zones = {} end
                                CaptureInfo.Zones[data2.value] = {x = coords.x, y = coords.y, z = coords.z}
                                TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                                GotoAdminMenu()
                            end
                            menu2.close()
                        end,
                        function(data2, menu2)
                            menu2.close()
                        end
                    )

                elseif data.current.value == 'startCap' then
                    ExecuteCommand(Config.StartCaptureCommand)
                    menu.close()
                elseif CaptureInfo.Zones[data.current.value] then
                    CaptureInfo.Zones[data.current.value] = nil
                    TriggerServerEvent('arshiahub.ir-CaptureSystem:UpdateInfo', CaptureInfo)
                    GotoAdminMenu()
                elseif data.current.value == 'announce' then
                    ExecuteCommand("announce Capture Start Shod ! /"..Config.JoinCaptureCommand.." Baraye Join Shodan !")
                    menu.close()
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end

RegisterNetEvent("arshiahub.ir-Capture:OpenStatsMenu")
AddEventHandler("arshiahub.ir-Capture:OpenStatsMenu", function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetMyStats', function(Mine, TopAllTime, MyZones)
        ESX.UI.Menu.CloseAll()
        local elements = {}

        local kills = Mine and Mine.kills or 0
        local deaths = Mine and Mine.deaths or 0
        local top5 = Mine and Mine.top5_count or 0
        local kd = deaths > 0 and string.format("%.2f", kills / deaths) or tostring(kills)

        table.insert(elements, {label = '========== 📊 My Stats ==========', value = nil})
        table.insert(elements, {label = 'Kills: '..kills, value = nil})
        table.insert(elements, {label = 'Deaths: '..deaths, value = nil})
        table.insert(elements, {label = 'K/D Ratio: '..kd, value = nil})
        table.insert(elements, {label = 'Times In Top 5: '..top5, value = nil})

        table.insert(elements, {label = '========== 📍 My Best Zones ==========', value = nil})
        if MyZones and #MyZones > 0 then
            for i, row in ipairs(MyZones) do
                table.insert(elements, {label = '#'..i..' '..tostring(row.zone_name)..' - '..tostring(row.points)..' pts', value = nil})
            end
        else
            table.insert(elements, {label = 'No Data Yet', value = nil})
        end

        table.insert(elements, {label = '========== 🏆 All-Time Top Killers ==========', value = nil})

        if TopAllTime and #TopAllTime > 0 then
            for i, row in ipairs(TopAllTime) do
                table.insert(elements, {label = '#'..i..' '..tostring(row.name)..' - '..tostring(row.kills)..' kills', value = nil})
            end
        else
            table.insert(elements, {label = 'No Data Yet', value = nil})
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureStatsMenu',
            {
                title    = 'Capture Stats',
                align    = "top-right",
                elements = elements
            },
            function(data, menu) end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

RegisterNetEvent("arshiahub.ir-Capture:OpenHistoryMenu")
AddEventHandler("arshiahub.ir-Capture:OpenHistoryMenu", function()
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetHistory', function(History)
        ESX.UI.Menu.CloseAll()
        local elements = {}

        if not History or #History == 0 then
            table.insert(elements, {label = 'No Rounds Recorded Yet', value = nil})
        else
            for _, round in ipairs(History) do
                local label = string.format('📅 %s | 🏆 %s (%d pts) | 🔫 %s (%d kills)',
                    tostring(round.round_date),
                    tostring(round.winner_gang or 'N/A'),
                    round.winner_points or 0,
                    tostring(round.top_killer_name or 'N/A'),
                    round.top_killer_kills or 0
                )
                table.insert(elements, {label = label, value = round})
            end
        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'CaptureHistoryMenu',
            {
                title    = 'Capture History',
                align    = "top-right",
                elements = elements
            },
            function(data, menu)
                if data.current.value then
                    OpenHistoryRoundDetail(data.current.value)
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

function OpenHistoryRoundDetail(round)
    local elements = {}
    table.insert(elements, {label = '========== 🥇 Top Gangs ==========', value = nil})

    local ok, gangs = pcall(json.decode, round.top_gangs_json or '[]')
    if ok and gangs then
        for i, gang in ipairs(gangs) do
            table.insert(elements, {label = '#'..i..' '..tostring(gang.Name)..' - '..tostring(gang.Points)..' pts', value = nil})
        end
    end

    table.insert(elements, {label = '========== 🏆 Top Killers ==========', value = nil})
    local ok2, killers = pcall(json.decode, round.top_killers_json or '[]')
    if ok2 and killers then
        for i, killer in ipairs(killers) do
            table.insert(elements, {label = '#'..i..' '..tostring(killer.Name)..' - '..tostring(killer.Point)..' kills', value = nil})
        end
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'CaptureHistoryDetail',
        {
            title    = tostring(round.round_date),
            align    = "top-right",
            elements = elements
        },
        function(data, menu) end,
        function(data, menu)
            menu.close()
        end
    )
end

function SetArmor()
    if Config.UseGroupForArmor then
        if Config.Armor[PlayerData.group] then
            PlayerCaptureInf.Armor = Config.Armor[PlayerData.group]
        else
            PlayerCaptureInf.Armor = Config.DefaultArmor
        end
    else
        PlayerCaptureInf.Armor = Config.DefaultArmor
    end

end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.7, 0.7)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("arshiahub.ir-CaptureSystem:TpPlayer")
AddEventHandler("arshiahub.ir-CaptureSystem:TpPlayer",function(x,y,z)
    local player = GetPlayerPed(-1)
    SetEntityCoords(player, x, y, z, false, false, false, true)
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:ShowMessage")
AddEventHandler("arshiahub.ir-CaptureSystem:ShowMessage",function(text,time)
    if PlayerCaptureInf.InCapture then
        Citizen.CreateThread(function()
            local TimeOut = true
            AddEventHandler("arshiahub.ir-CaptureSystem:ShowMessage",function(text,time)
                TimeOut = false
            end)
            SetTimeout((time) * 1000 , function()
                TimeOut = false
            end)
            while TimeOut do
                Citizen.Wait(0)
                DrawTextBottom(text)
            end
        end)
    end
end)
function DrawTextBottom(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.7, 0.7)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.35, 0.93)
end

function OpenWeaponGroupMenu()
    local elements = {}
    ESX.UI.Menu.CloseAll()
    local playerGroup = PlayerData.group
    for i, weaponGroup in ipairs(Config.Weapons) do
        local hasAccess = false

        if not weaponGroup.access then
            hasAccess = true
        elseif weaponGroup.access == playerGroup or (weaponGroup.access == "vip+" and (playerGroup == "vip+" or playerGroup == "admin")) then
            hasAccess = true
        end

        local weaponLabels = {}
        for _, weapon in ipairs(weaponGroup.Names) do
            local label = ESX.GetWeaponLabel(weapon)
            table.insert(weaponLabels, label or weapon)
        end

        local fullLabel = table.concat(weaponLabels, " | ")
        if not hasAccess then
            fullLabel = "[LOCKED("..weaponGroup.access..")] " .. fullLabel
        end

        table.insert(elements, {
            label = fullLabel,
            groupIndex = i,
            access = hasAccess,
            group = weaponGroup.access,
        })
    end
    PlayerCaptureInf.InMenu = "WeaponMenu"
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'WeaponMenu', {
        title    = "Weapon Menu",
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.access then
            PlayerCaptureInf.Weapon = Config.Weapons[data.current.groupIndex].Names
            PlayerCaptureInf.InMenu = nil
            GotoMenu()
        else
            Notify("You Dont Have Access To "..data.current.group.." Group Weapons", 'error')
        end
    end, function(data, menu)
        PlayerCaptureInf.InMenu = nil
        GotoMenu()
    end)
end

RegisterNetEvent('arshiahub.ir-CaptureSystem:ReceiveGroup')
AddEventHandler('arshiahub.ir-CaptureSystem:ReceiveGroup',function(group)
    PlayerCaptureInf.Group = group
end)

if Config.EnableSpectate then
    local SpectateActive = false
    local SpectateCam = nil
    local SpectateOriginalCoords = nil
    local SpectateHeading = 0.0
    local SpectatePitch = -25.0
    local SpectateListOpen = false
    local SpectateLockedSource = nil
    local VitalsThreadRunning = false

    local function ExitFreeLook()
        SpectateListOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({action = "spectateListClose"})
    end

    -- Releases the lock and drops back into the plain free-flying camera,
    -- starting from wherever the target currently is.
    local function ReturnToFreeCam()
        if not SpectateLockedSource then return end
        SpectateLockedSource = nil
        SendNUIMessage({action = "spectateVitalsClose"})
        local camCoord = GetCamCoord(SpectateCam)
        SpectateHeading = GetCamRot(SpectateCam, 2).z
        SpectatePitch = -15.0
        SetCamRot(SpectateCam, SpectatePitch, 0.0, SpectateHeading, 2)
    end

    local function LockOntoTarget(targetSource)
        local targetPlayer = GetPlayerFromServerId(targetSource)
        if targetPlayer == -1 then
            Notify("That Player Is No Longer Available To Spectate !", 'error')
            return
        end
        SpectateLockedSource = targetSource
        ExitFreeLook()
        SendNUIMessage({action = "spectateVitalsOpen", name = GetPlayerName(targetSource)})

        if not VitalsThreadRunning then
            VitalsThreadRunning = true
            Citizen.CreateThread(function()
                while SpectateActive do
                    Citizen.Wait(Config.SpectateVitalsRefreshMs)
                    if SpectateLockedSource then
                        local tp = GetPlayerFromServerId(SpectateLockedSource)
                        local tPed = tp ~= -1 and GetPlayerPed(tp) or nil
                        if tPed and tPed ~= 0 and DoesEntityExist(tPed) then
                            local health = math.max(0, math.min(100, GetEntityHealth(tPed) - 100))
                            local armor = math.max(0, math.min(100, GetPedArmour(tPed)))
                            SendNUIMessage({action = "spectateVitalsUpdate", health = health, armor = armor})
                        else
                            Notify("Lost Track Of That Player — Back To Free Camera.", 'info')
                            ReturnToFreeCam()
                        end
                    end
                end
                VitalsThreadRunning = false
            end)
        end
    end

    local function RequestSpectateList()
        ESX.TriggerServerCallback('arshiahub.ir-Capture:GetSpectateTargets', function(list)
            SendNUIMessage({action = "spectateListOpen", players = list})
        end)
    end

    RegisterNUICallback('spectateSelectTarget', function(data, cb)
        if data and data.source then
            LockOntoTarget(tonumber(data.source))
        end
        cb('ok')
    end)

    RegisterNUICallback('spectateFreeCam', function(data, cb)
        ReturnToFreeCam()
        cb('ok')
    end)

    RegisterNUICallback('spectateCloseList', function(data, cb)
        ExitFreeLook()
        cb('ok')
    end)

    RegisterCommand(Config.SpectateCommand, function()
        if SpectateActive then
            Notify("Already Spectating !", 'error')
            return
        end
        if PlayerCaptureInf.InCapture then
            Notify("You Can't Spectate While Playing In A Real Capture !", 'error')
            return
        end
        SpectateActive = true
        TriggerServerEvent("arshiahub.ir-Capture:EnterSpectateWorld")
    end, false)

    RegisterNetEvent("arshiahub.ir-Capture:SpectateReady")
    AddEventHandler("arshiahub.ir-Capture:SpectateReady", function()
        if not SpectateActive then return end
        local ped = PlayerPedId()
        SpectateOriginalCoords = GetEntityCoords(ped)

        local startCoord = SpectateOriginalCoords + vector3(0.0, 0.0, 100.0)
        if CapturesInfo and CapturesInfo.Zones then
            for _, coord in pairs(CapturesInfo.Zones) do
                startCoord = vector3(coord.x, coord.y, coord.z + 100.0)
                break
            end
        end

        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        SetEntityInvincible(ped, true)
        SetEntityCoordsNoOffset(ped, startCoord.x, startCoord.y, startCoord.z - 150.0, false, false, false)

        SpectateHeading = 0.0
        SpectatePitch = -25.0
        SpectateLockedSource = nil
        SpectateCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(SpectateCam, startCoord.x, startCoord.y, startCoord.z)
        SetCamRot(SpectateCam, SpectatePitch, 0.0, SpectateHeading, 2)
        SetCamFov(SpectateCam, 70.0)
        SetCamActive(SpectateCam, true)
        RenderScriptCams(true, true, 800, true, true)

        SendNUIMessage({action = "spectateOpen"})
        Notify("Spectator Mode ON — WASD to move, mouse to look, TAB for the player list, ESC to exit.", 'success')

        Citizen.CreateThread(function()
            while SpectateActive do
                Citizen.Wait(0)

                if SpectateListOpen then
                    DisableControlAction(0, 1, true)
                    DisableControlAction(0, 2, true)
                    EnableControlAction(0, 200, true)
                    if IsControlJustPressed(0, 200) or IsControlJustPressed(0, 37) then
                        ExitFreeLook()
                    end
                    goto continueSpectateLoop
                end

                DisableAllControlActions(0)
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                EnableControlAction(0, 200, true)
                EnableControlAction(0, 37, true)

                if IsControlJustPressed(0, 200) then
                    ExecuteCommand(Config.SpectateLeaveCommand)
                    return
                end

                if IsControlJustPressed(0, 37) then -- TAB
                    SpectateListOpen = true
                    SetNuiFocus(true, false)
                    RequestSpectateList()
                    goto continueSpectateLoop
                end

                local mx = GetDisabledControlNormal(0, 1)
                local my = GetDisabledControlNormal(0, 2)

                if SpectateLockedSource then
                    -- Locked on: orbit around the target instead of free-flying.
                    local tp = GetPlayerFromServerId(SpectateLockedSource)
                    local tPed = tp ~= -1 and GetPlayerPed(tp) or nil
                    if tPed and tPed ~= 0 and DoesEntityExist(tPed) then
                        SpectateHeading = SpectateHeading - (mx * 6.0)
                        SpectatePitch = math.max(-85.0, math.min(30.0, SpectatePitch - (my * 6.0)))

                        local targetCoord = GetEntityCoords(tPed) + vector3(0.0, 0.0, Config.SpectateLockHeight)
                        local rh = math.rad(SpectateHeading)
                        local rp = math.rad(SpectatePitch)
                        local dist = Config.SpectateLockDistance
                        local offset = vector3(
                            math.sin(rh) * math.cos(rp) * dist,
                            math.cos(rh) * math.cos(rp) * dist,
                            math.sin(-rp) * dist
                        )
                        SetCamCoord(SpectateCam, targetCoord.x - offset.x, targetCoord.y - offset.y, targetCoord.z - offset.z)
                        PointCamAtEntity(SpectateCam, tPed, 0.0, 0.0, 0.5, true)
                    end
                    goto continueSpectateLoop
                end

                SpectateHeading = SpectateHeading - (mx * 6.0)
                SpectatePitch = math.max(-89.0, math.min(89.0, SpectatePitch - (my * 6.0)))
                SetCamRot(SpectateCam, SpectatePitch, 0.0, SpectateHeading, 2)

                do
                    local camCoord = GetCamCoord(SpectateCam)
                    local speed = Config.SpectateSpeed
                    if IsControlPressed(0, 21) then speed = speed * 3.0 end

                    local forward, right, up = 0.0, 0.0, 0.0
                    if IsControlPressed(0, 32) then forward = forward + speed end
                    if IsControlPressed(0, 33) then forward = forward - speed end
                    if IsControlPressed(0, 34) then right = right - speed end
                    if IsControlPressed(0, 35) then right = right + speed end
                    if IsControlPressed(0, 22) then up = up + speed end
                    if IsControlPressed(0, 36) then up = up - speed end

                    if forward ~= 0.0 or right ~= 0.0 or up ~= 0.0 then
                        local rad = math.rad(SpectateHeading)
                        local dx = (math.sin(-rad) * forward) + (math.cos(-rad) * right)
                        local dy = (math.cos(-rad) * forward) - (math.sin(-rad) * right)
                        SetCamCoord(SpectateCam, camCoord.x + dx, camCoord.y + dy, camCoord.z + up)
                    end
                end

                ::continueSpectateLoop::
            end
        end)
    end)

    RegisterCommand(Config.SpectateLeaveCommand, function()
        if not SpectateActive then return end
        SpectateActive = false
        SpectateListOpen = false
        SpectateLockedSource = nil
        SetNuiFocus(false, false)
        RenderScriptCams(false, true, 800, true, true)
        if SpectateCam then
            DestroyCam(SpectateCam, false)
            SpectateCam = nil
        end
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        SetEntityInvincible(ped, false)
        if SpectateOriginalCoords then
            SetEntityCoords(ped, SpectateOriginalCoords.x, SpectateOriginalCoords.y, SpectateOriginalCoords.z, false, false, false, false)
        end
        SpectateOriginalCoords = nil
        TriggerServerEvent("arshiahub.ir-Capture:LeaveSpectateWorld")
        SendNUIMessage({action = "spectateClose"})
        SendNUIMessage({action = "spectateListClose"})
        SendNUIMessage({action = "spectateVitalsClose"})
        Notify("Spectator Mode OFF.", 'info')
    end, false)


    AddEventHandler("arshiahub.ir-Capture:LeaveCapture", function()
        if SpectateActive then
            ExecuteCommand(Config.SpectateLeaveCommand)
        end
    end)
end

