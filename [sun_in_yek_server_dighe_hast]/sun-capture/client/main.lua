-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ZONE_RANGE = 350.0
local SPAWN_PROTECTION_TIME = 6

local currentWorld = 0

local CaptureIsActive, isInCapture, currentZoneId, isInZoneCircle, disableRangeCheck, isDead, inProtection
local blips = {}
local parachuteModel = `gadget_parachute`

ESX = exports['essentialmode']:getObject()
Kos_Nanat_Age_Ino_Mibini_Just_Dumper = false

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(1000)
    end

    TriggerEvent('capture:inCapture', false)
    ESX.SetPlayerData('connect',1)
    while ESX.GetPlayerData().gang == nil do Wait(100) end
    ESX.PlayerData = ESX.GetPlayerData()
end)
CaptureCache = {}
captureConfig = {}

RegisterNetEvent('esx:changeworld',function(world)
    currentWorld = world
end)




RegisterNetEvent('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
end)


function openMenu(untilEnd)
    SendNUIMessage({
        action = 'setVisible',
        data = { visible = true }
    })

    SendNUIMessage({
        action = 'setTimer',
        data = { seconds = untilEnd }
    })

    SendNUIMessage({
        action = 'setFlagOwner',
        data = { }
    })
end

RegisterNetEvent('capture:CaptureStarted', function(untilEnd)
    while ESX.PlayerData.gang == nil do Wait(100) end
    CaptureIsActive = true
    if ESX.PlayerData.gang ~= 'nogang' then
        openMenu(untilEnd)
    end
end)

RegisterNetEvent('capture:ChangeCaptureHandler', function(index, gang)
    if gang == nil then gang = 'N/A' end
    CaptureCache.Zones[index].captureBy = gang
    SendNUIMessage({
        action = 'setFlagOwner',
        data = { owner = gang }
    })
end)


local dieCD = false
RegisterCommand('die',function()
    if dieCD then return end
    if isInCapture then
        local ped = PlayerPedId()
        if GetPedParachuteState(ped) == -1 and not inProtection then
            dieCD = true
            if lib.progressCircle({
                duration = 5000,
                position = 'bottom',
                canCancel = false,
                allowRagdoll = true,
                allowFalling = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            }) then
                ESX.SetEntityHealth(ped, 0)
            end
            dieCD = false
        end
    elseif (ESX.GetPlayerData().job.name == 'police' or ESX.GetPlayerData().job.name == 'sheriff' or ESX.GetPlayerData().job.name == 'mt') and ESX.GetPlayerData().IsInjure and exports['esx_ambulancejob']:notBlackListCoords() or ESX.GetPlayerData().isInIslandZone then
        if ESX.GetPlayerData().isInIslandZone then
            if ESX.isDead() then
                dieCD = true
                TriggerServerEvent('island:dropItems')
                Wait(4000)
                TriggerEvent('island:tpToNearSafeZone')
                dieCD = false
            end
        else
            ESX.SetEntityHealth(PlayerPedId(),0)
        end
    end
    if not ESX.GetPlayerData().isInIslandZone then
        TriggerEvent('gang:die')
    end
end)

function makeEntityFaceEntity(capture, entity)
    local p2 = capture
    local p1 = GetEntityCoords(entity, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading(entity, heading)
end

function calculateZoneData()
    local zones = {}

    for k , v in pairs(CaptureCache.Zones) do
        table.insert(zones,{id = k, zoneLabel = v.label, playerCount = v.playerCount, maxPlayerCount = v.maxPlayerInZone or captureConfig.maxPlayerInZone, gangPlayerCount = v.gangPlayerCount, maxGangCount = v.maxPlayerInZone or captureConfig.maxGangInZone })
    end

    return zones
end

RegisterNetEvent('Cap:OpenMenu', function()
    getCaptureData()
    if not CaptureIsActive then return end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openSpawnMenu',
        data = { zones = calculateZoneData(), canBackHome = isInCapture }
    })
end)

RegisterNUICallback('requestSpawnZones', function(data, cb)
    getCaptureData()
    SendNUIMessage({
        action = 'updateSpawnZones',
        data = { zones = calculateZoneData() }
    })
    cb('ok')
end)

RegisterNUICallback('spawnSelect', function(data, cb)
    isDead = false
    SetNuiFocus(false, false)
    local zoneId = data.id
    if not zoneId then
        return TriggerEvent('Cap:OpenMenu')
    end
    getCaptureData()

    local canJoin = true

    if CaptureCache.Zones[zoneId].playerCount >= captureConfig.maxPlayerInZone and zoneId ~= currentZoneId then
        ESX.notification('error', 'Zarfiat in zone por shode ast')
        canJoin = false
    elseif CaptureCache.Zones[zoneId].gangPlayerCount >= captureConfig.maxGangInZone and zoneId ~= currentZoneId then
        ESX.notification('error', 'Zarfiat gang shoma dar in zone por shode ast')
        canJoin = false
    end

    if canJoin then
        TriggerServerEvent('capture:join', zoneId)
        currentZoneId = zoneId
        SendNUIMessage({
            action = 'setFlagOwner',
            data = { owner = CaptureCache.Zones[zoneId].captureBy or 'N/A' }
        })
    else
        isDead = true
        TriggerEvent('Cap:OpenMenu')
    end
    cb('ok')
end)

RegisterNUICallback('spawnCancel', function(data, cb)
    SetNuiFocus(false, false)
    if isDead and isInCapture then
        SendNUIMessage({
            action = 'showDeathScreen',
            data = {}
        })
    end
    cb('ok')
end)

function getCaptureData()
    local p = promise.new()
    ESX.TriggerServerCallback('capture:getCache',function(data, _captureConfig, _untilEnd)
        p:resolve({data, _captureConfig, _untilEnd})
    end)
    local data = Citizen.Await(p)
    CaptureCache.Zones, captureConfig, CaptureCache.untilEnd = data[1], data[2], data[3]
    for k, v in pairs(CaptureCache.Zones) do
        v.playerCount = ESX.tableLength(v.players)
        v.gangPlayerCount = 0
        for k2, v2 in pairs(v.players) do
            if v2.gang == ESX.PlayerData.gang.name then
                v.gangPlayerCount += 1
            end
        end
    end
    if CaptureCache.untilEnd then
        SendNUIMessage({
            action = 'setTimer',
            data = { seconds = CaptureCache.untilEnd }
        })
    end
end

RegisterNetEvent('capture:openSetZoneMenu', function()
    local input = lib.inputDialog('Etela\'at zone ra vared konid', {
        {type = 'number', label = 'Shomare zone', required = true},
        {type = 'input', label = 'Label zone', required = true},
        {type = 'number', label = 'World', min = 300, max = 400, icon = 'hashtag', required = true, default = 300},
    })

    if input and input[1] and input[2] and input[3] then
        TriggerServerEvent('capture:setCap', input)
    end
end)

RegisterNetEvent('capture:teleport', function()
    Wait(500)
    local ped = PlayerPedId()
    if IsPedDeadOrDying(ped) then
        TriggerEvent('medic:revive', true, nil, true)
    end

    disableRangeCheck = true

    SetTimeout(5000, function()
        disableRangeCheck = false
    end)

    if not isInCapture then
        isInCapture = true
        doInCapture()
    else
        isInZoneCircle = false
    end

    SendNUIMessage({ action = 'clearFlagContested' })

    TriggerEvent('holster:active', false)

    SetCurrentPedWeapon(ped, parachuteModel, true)

    ESX.fadeScreen(2000, function ()
        local point = CaptureCache.Zones[currentZoneId].coords

        local BaseCoord = (1000.0/2) - 5.0
        local XCoord = math.random(-BaseCoord, BaseCoord)
        local YCoord = math.sqrt(BaseCoord^2 - XCoord^2) * (math.random(1,2) > 1 and -1 or 1)
        local FinalCoord = vector2(point.x + XCoord, point.y + YCoord)

        ESX.SetEntityCoords(PlayerPedId(),vector3(FinalCoord.x, FinalCoord.y, 1500))
        makeEntityFaceEntity(point, PlayerPedId())

        SetTimeout(10000,function()
            TriggerEvent('holster:active',true)
        end)
    end)
end)

function doInCapture()
    local ped = PlayerPedId()
    TriggerEvent('capture:inCapture', true)
    CreateThread(function()
        local flare = `WEAPON_FLARE`
        local molotov = `WEAPON_MOLOTOV`
        while isInCapture do
            GiveWeaponToPed(ped, parachuteModel, 5, false, false)

            local selected = GetSelectedPedWeapon(ped)
            if selected ~= molotov and selected ~= flare then
                SetPedAmmo(ped, GetSelectedPedWeapon(ped), 50)
            end

            Wait(1000)
        end
    end)

    local captureTID
    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        while isInCapture do
            local zone = CaptureCache.Zones[currentZoneId]
            if zone.world == currentWorld then

                if zone.captureBy == ESX.PlayerData.gang.name then
                    DrawMarker(28, zone.coords.x, zone.coords.y, zone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5,  3,  144,  0, 100, false, true, 2, false, false, false, false)
                    DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 50, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ZONE_RANGE, ZONE_RANGE, 500.0,  3,  144,  0, 100, false, true, 2, false, false, false, false)
                else
                    DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 100.5,  255,  102,  0, 100, false, true, 2, false, false, false, false)
                    DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 50, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ZONE_RANGE, ZONE_RANGE, 500.0,  255,  102,  0, 100, false, true, 2, false, false, false, false)
                end

                local distance = #(GetEntityCoords(ped) - zone.coords)
                if zone.captureBy ~= ESX.PlayerData.gang.name and distance <= 1.5 then
                    if not captureTID and not IsPedDeadOrDying(ped, true) then
                        SendNUIMessage({
                            action = 'startCaptureTimer',
                            data = { seconds = 10 }
                        })
                        TriggerServerEvent('capture:setFlagContested')
                        captureTID = ESX.SetTimeout(10000, function ()
                            if not IsPedDeadOrDying(ped, true) then
                                TriggerServerEvent('capture:CaptureMe')
                            end
                            Wait(2000)
                            captureTID = nil
                        end)
                    end
                elseif captureTID then
                    SendNUIMessage({ action = 'stopCaptureTimer' })
                    ESX.ClearTimeout(captureTID)
                    print(captureTID)
                    captureTID = nil
                end
            end
            Wait(2)
        end
    end)

    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local lastCoords
        while isInCapture do
            local zone = CaptureCache.Zones[currentZoneId]
            if zone.world == currentWorld then
                local coords = GetEntityCoords(ped)
                local distance = #(coords.xy - zone.coords.xy)
                if not disableRangeCheck then
                    if distance < ZONE_RANGE / 2 then
                        if not isInZoneCircle then
                            isInZoneCircle = true
                            teleportToEdge()
                        end
                        lastCoords = coords
                    elseif isInZoneCircle then
                        ESX.SetEntityCoords(ped, lastCoords)
                        SetPedToRagdoll(ped, 5000, 5000, 0, false, false, false)
                    end
                end
            end
            Wait(1000)
        end
    end)

    local lastDamageTime = 0
    local lastShootTime = 0
    local isHealingActive = true
    local isHealing = false

    local damageHandler = AddEventHandler('gameEventTriggered', function(name, args)
        if not isHealingActive then return end
        if name == 'CEventNetworkEntityDamage' then
            local victim = args[1]
            local playerPed = PlayerPedId()
            if victim == playerPed then
                lastDamageTime = GetGameTimer()
                if isHealing then
                    SendNUIMessage({ action = 'hideHeal' })
                    isHealing = false
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while isInCapture do
            local playerPed = PlayerPedId()
            if IsPedShooting(playerPed) then
                lastShootTime = GetGameTimer()
                if isHealing then
                    SendNUIMessage({ action = 'hideHeal' })
                    isHealing = false
                end
            end
            if not isInZoneCircle then
                ESX.disableFiring()
            end
            Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while isInCapture do
            local playerPed = PlayerPedId()
            local currentTime = GetGameTimer()
            local currentHealth = GetEntityHealth(playerPed)
            local maxHealth = GetEntityMaxHealth(playerPed)

            local isDead = IsPedDeadOrDying(playerPed, true)

            if isDead and isHealing then
                SendNUIMessage({ action = 'hideHeal' })
                isHealing = false
            end

            if not isDead and currentHealth < maxHealth and currentHealth > 0 then
                local timeSinceLastDamage = currentTime - lastDamageTime
                local timeSinceLastShoot = currentTime - lastShootTime

                if timeSinceLastDamage >= 5000 and timeSinceLastShoot >= 5000 then
                    if not isHealing then
                        SendNUIMessage({ action = 'showHeal' })
                        isHealing = true
                    end
                    local newHealth = math.min(currentHealth + 1, maxHealth)
                    ESX.SetEntityHealth(playerPed, newHealth)
                    if newHealth >= maxHealth then
                        SendNUIMessage({ action = 'hideHeal' })
                        isHealing = false
                    end
                end
            elseif isHealing then
                SendNUIMessage({ action = 'hideHeal' })
                isHealing = false
            end

            Wait(1000)
        end

        if isHealing then
            SendNUIMessage({ action = 'hideHeal' })
        end
        isHealingActive = false
        RemoveEventHandler(damageHandler)
    end)

    for k, v in pairs(CaptureCache.Zones) do
        table.insert(blips, ESX.AddBlipForCoord(v.coords, 1.2, 378, 76, v.label, 4))
        table.insert(blips, ESX.AddBlipForRadius(v.coords, 22, 80))
    end
end

function exitCapture()
    if isInCapture then
        disableRangeCheck = true

        SetTimeout(10000, function()
            disableRangeCheck = false
        end)
        TriggerServerEvent('capture:exit')
        TriggerEvent('medic:revive', true, nil, true)
        TriggerEvent('gangprop:tptogang')
        TriggerEvent('capture:inCapture', false)

        for k, v in pairs(blips) do
            ESX.removeBlip(v)
        end

        isInCapture, isInZoneCircle, currentZoneId, blips, isDead = false, false, nil, {}, false

        SetNuiFocus(false, false)

        SendNUIMessage({
            action = 'hideFlagOwner',
            data = {}
        })
    end
end

RegisterNUICallback('spawnBackHome', function(data, cb)
    SetNuiFocus(false, false)
    exitCapture()
    cb('ok')
end)

AddEventHandler('esx:onPlayerDeath',function()
    if CaptureIsActive and isInCapture then
        isDead = true
        SendNUIMessage({
            action = 'showDeathScreen',
            data = {}
        })
    end
end)

AddEventHandler('KeyDown:e', function()
    if isDead then
        SendNUIMessage({
            action = 'hideDeathScreen',
            data = {}
        })
        TriggerEvent('Cap:OpenMenu')
    end
end)


RegisterNetEvent('capture:updateKillDeath', function(data)
    SendNUIMessage({
        action = 'updateStats',
        data = { kills = data.kills, deaths = data.deaths }
    })
end)

function teleportToEdge()
    local ped = PlayerPedId()
    local zone = CaptureCache.Zones[currentZoneId]
    local BaseCoord = (ZONE_RANGE/2) - 5.0
    local XCoord = math.random(-BaseCoord, BaseCoord)
    local YCoord = math.sqrt(BaseCoord^2 - XCoord^2) * (math.random(1,2) > 1 and -1 or 1)
    local point = zone.coords
    local FinalCoord = vector2(point.x + XCoord, point.y + YCoord)
    ESX.Game.Teleport(ped, vector3(FinalCoord.x, FinalCoord.y, 1500), nil, true)
    spawnProtection()
    makeEntityFaceEntity(point, ped)
end

function spawnProtection()
    ESX.SetPlayerData('armorInvis',true)
    ESX.SetPedArmour(PlayerPedId(),100)
    if SPAWN_PROTECTION_TIME > 0 then
        NetworkSetFriendlyFireOption(false)
        ESX.SetPlayerState('spawnProtection', true)
        inProtection = true

        SetTimeout(SPAWN_PROTECTION_TIME * 1000, function()
            NetworkSetFriendlyFireOption(true)
            inProtection = nil
        end)
    end
end

AddStateBagChangeHandler('spawnProtection', nil, function(bagName, key, value)
    local ped = GetPlayerPed(GetPlayerFromStateBagName(bagName))
    if ped == 0 then return end
    if value then
        CreateThread(function()
            local endTime = GetGameTimer() + (SPAWN_PROTECTION_TIME * 1000)
            local fadeIn = true
            while GetGameTimer() < endTime do
                if fadeIn then
                    SetEntityAlpha(ped, 100, false)
                else
                    SetEntityAlpha(ped, 255, false)
                end
                fadeIn = not fadeIn
                Wait(500)
            end
            SetEntityAlpha(ped, 255, false)
            ResetEntityAlpha(ped)
        end)
    end
end)

local isScoreboardActive = false
local fetchCooldown = false
AddEventHandler('KeyDown:q',function(key)
    if CaptureIsActive and isInCapture then
        isScoreboardActive = not isScoreboardActive
        if isScoreboardActive then
            if not fetchCooldown then
                fetchCooldown = true
                SetTimeout(5000, function()
                    fetchCooldown = false
                end)
                ESX.TriggerServerCallback('capture:getScoreboard', function(data)
                    local gangsData = {}
                    for k, v in pairs(data.gangs or {}) do
                        local capturedFlags = {}
                        for k2, v2 in pairs(CaptureCache.Zones) do
                            if v2.captureBy == v.name then
                                table.insert(capturedFlags, v2.label)
                            end
                        end
                        table.insert(gangsData, {
                            name = v.name,
                            capturedFlags = capturedFlags,
                            point = v.Score,
                        })
                    end
                    SendNUIMessage({
                        action = 'openScoreboard',
                        data = { players = data.players or {}, families = gangsData}
                    })
                end)
            else
                SendNUIMessage({
                    action = 'openScoreboard',
                    data = {}
                })
            end
        else
            SendNUIMessage({ action = 'closeScoreboard' })
        end
    end
end)

local timerOpen = false
AddEventHandler('KeyDown:f4', function()
     if CaptureIsActive then
        timerOpen = not timerOpen
        SendNUIMessage({
            action = 'setTimerVisibility',
            data = { hidden = timerOpen }
        })
    end
end)

RegisterNetEvent('capture:setFlagContested', function(attacker)
    SendNUIMessage({
        action = 'setFlagContested',
        data = { attacker = attacker }
    })
end)

RegisterNetEvent('capture:CaptureEnded', function()
    CaptureIsActive = false
    Wait(5000)
    exitCapture()
    SendNUIMessage({
        action = 'setVisible',
        data = { visible = false }
    })
end)