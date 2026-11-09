-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isInZone = false
local currentZoneId = nil
local isInSafeZone = false
local zonesBlip = {}
local drawedZone = {}
local drawedTelepoter = {}
local nearIslandPVPDeactive = false
local nearWeaponId = nil
local addedWeapon = {}
local weaponBlipId = {}
local nearTeleporterId = nil
local flagsData = {}
local flagsBlip = {}
local flagsConfig = {}
local drawedFlags = {}
local canCaptureFlag = nil
local canCaptureFlag2 = nil
local isInHack = false
local islandLoaded = false
local headDisable = false
local playerBlips = {}
local nearLoot = nil
local lootBoxHash = `prop_box_ammo03a`
local zombieSpawned = false
local zombieId = nil
local zombieSpawnCooldown = 0
CreateThread(function()
    waitForLoad()
    for k, v in pairs(configCapIs.zones) do
        if v.blip then
            v.blipId = ESX.AddBlipForRadius(v.coords, v.blipColor, v.blipOpacity)
        end
        for k2, v2 in pairs(v.flags) do
            v2.k = k .. k2
            flagsConfig[v2.k] = v2
            flagsData[k..k2] = v2
            flagsBlip[k..k2] = ESX.AddBlipForCoord(v2.coords, 0.9, 38, 0, v2.label .. '(None)')
        end
    end
    ESX.TriggerServerCallback('island:getFlagData', function(data)
        for k, v in pairs(data) do
            if flagsData[k] then
                v.blip = flagsBlip[k]
                flagsData[k] = v
                if flagsData[k].capturingBy then
                    changeFlagsBlipColor(k, 81)
                elseif flagsData[k].capturedBy then
                    if flagsData[k].capturedBy == ESX.PlayerData.gang.name then
                        changeFlagsBlipColor(k, 2)
                    else
                        changeFlagsBlipColor(k, 1)
                    end
                    changeBlipLabel(k, flagsConfig[k].label .. '('.. flagsData[k].capturedBy ..')')
                else
                    changeFlagsBlipColor(k, 0)
                    changeBlipLabel(k, flagsConfig[k].label .. '(None)')
                end
            end
        end
        islandLoaded = true
    end)
    while true do
        Wait(2000)
        while SUN.PlayerCoords == nil do Wait(100) end
        local coords = SUN.PlayerCoords
        local inZone = false
        for k, v in pairs(configCapIs.zones) do
            local distance = ESX.GetDistance(coords, v.coords.xyz)
            if distance <= v.coords.w and SUN.World == 0 then
                if not isInZone then
                    TriggerEvent('MpGameMessage:send', '~r~Danger Zone', '', 5000, 'success')
                    -- ESX.SetPlayerData('isInIslandZone', true)
                    currentZoneId = k
                    TriggerServerEvent('island:setInIslandState', v.safeZone[math.random(1, #v.safeZone)].xyz)
                    CreateThread(function()
                        for k, v in pairs(v.safeZone) do
                            table.insert(zonesBlip, ESX.AddBlipForRadius(v, 2, 100))
                        end
                        -- flagsData = {}
                        -- for k, v in pairs(v.flags) do
                        --     flagsData[k] = v
                        --     flagsData[k].blip = ESX.AddBlipForCoord(v.coords, 0.9, 38, 2, '')
                        -- end

                        --draw flags
                        CreateThread(function()
                            while isInZone do
                                Wait(0)
                                if not foxState then
                                    disableFiring()
                                end
                                if SUN.isPlayerInVehicle and SUN.vehicleClass == 15 then
                                    disableFiring()
                                end
                                for k, v in pairs(v.flags) do
                                    local r, g, b = 255, 255, 255
                                    if flagsData[v.k] then
                                        if flagsData[v.k].capturingBy then
                                            r, g, b = 255, 140, 0
                                        elseif flagsData[v.k].capturedBy then
                                            if flagsData[v.k].capturedBy == ESX.PlayerData.gang.name then
                                                r, g, b = 0, 255, 0
                                            else
                                                r, g, b = 255, 0, 0
                                            end
                                        end
                                    end
                                    DrawMarker(1, v.coords.xyz - vec(0, 0, 1), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 100.0, r, g, b, 40, false, true, 2, false, false, false, false)
                                end
                            end
                        end)
                        CreateThread(function()
                            while isInZone do
                                Wait(1000)
                                local ped = PlayerPedId()
                                if not foxState then
                                    if not ESX.isDead() then
                                        SetEntityHealth(ped, GetEntityHealth(ped) - 3)
                                        ESX.ShowNotification('Be dalile baz nabudan FoxG 3 hp har sanie az shoma kam mishavad!')
                                    end
                                end
                                local vehicle = ESX.isVehicleDriver()
                                if vehicle and isInSafeZone then
                                    ESX.Game.DeleteVehicle(vehicle)
                                end
                            end
                        end)
                        --
                        while isInZone do
                            Wait(50)
                            --out player check
                            local zoneData = configCapIs.zones[currentZoneId]
                            for k, v in pairs(GetActivePlayers()) do
                                if v ~= PlayerId() then
                                    if ESX.GetDistance(zoneData.coords.xyz, GetEntityCoords(GetPlayerPed(v))) < zoneData.coords.w then
                                        SetEntityInvincible(GetPlayerPed(v), false)
                                    else
                                        SetEntityInvincible(GetPlayerPed(v), true)
                                    end
                                end
                            end
                            --safe zone check
                            local _isInSafeZone = false
                            for k2, v2 in pairs(zoneData.safeZone) do
                                local distance = #(SUN.PlayerCoords - v2.xyz)
                                if distance < v2.w then
                                    _isInSafeZone = true
                                    break
                                end
                                if distance < v2.w*3 then
                                    if not drawedZone[k..k2] then
                                        drawedZone[k..k2] = true
                                        CreateThread(function()
                                            while drawedZone[k..k2] do
                                                Wait(0)
                                                DrawMarker(28, v2.xyz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v2.w, v2.w, v2.w, 0, 255, 0, 20, false, true, 2, false, false, false, false)
                                            end
                                        end)
                                    end
                                else
                                    drawedZone[k..k2] = nil
                                end
                            end
                            if not _isInSafeZone and isInSafeZone then
                                NetworkSetFriendlyFireOption(true)
                            elseif _isInSafeZone and not isInSafeZone then
                                NetworkSetFriendlyFireOption(false)
                            end
                            isInSafeZone = _isInSafeZone
                            if isInSafeZone then
                                --ESX.ShowMissionText('~g~Safe Zone')
                            else
                                ESX.ShowMissionText('~r~Danger Zone')
                            end

                            if zombieSpawned and (ESX.isDead() or isInSafeZone) then
                                zombieSpawned = false
                                stopZombie(zombieId)
                                zombieSpawnCooldown = GetGameTimer() + 60000
                                zombieId = nil
                            end

                            if v.zombieConfig and not zombieSpawned and not isInSafeZone and not ESX.isDead() and not zombieId and GetGameTimer() > zombieSpawnCooldown then
                                zombieSpawned = true
                                zombieId = startZombie(v.zombieConfig)
                            end
                            --give weapon
                            for k2, v2 in pairs(v.weaponsLocation) do
                                local distance = ESX.GetDistance(SUN.PlayerCoords, v2.coords.xyz)
                                if distance < v2.coords.w then
                                    nearWeaponId = k2
                                    ESX.ShowHelpNotification('~INPUT_PICKUP~ Jahat pickup(~g~'.. ESX.GetWeaponLabel(v2.name) ..'~w~)')
                                elseif nearWeaponId == k2 then
                                    if addedWeapon[nearWeaponId] then
                                        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(v2.name))
                                    end
                                    nearWeaponId = nil
                                end
                                if distance < 30 then
                                    if not weaponBlipId[k..k2] then
                                        weaponBlipId[k..k2] = ESX.AddBlipForCoord(v2.coords.xyz, 0.9, 110, 46, '', 5)
                                    end
                                elseif weaponBlipId[k..k2] then
                                    ESX.removeBlip(weaponBlipId[k..k2])
                                    weaponBlipId[k..k2] = nil
                                end
                            end

                            --teleporter
                            for k2, v2 in pairs(v.teleporter) do
                                local distance = ESX.GetDistance(SUN.PlayerCoords, v2.from.xyz)
                                if distance < v2.from.w then
                                    ESX.ShowHelpNotification('~INPUT_PICKUP~ Jahat khoruj')
                                    nearTeleporterId = k2
                                elseif nearTeleporterId == k2 then
                                    nearTeleporterId = nil
                                end
                                if distance < 5 then
                                    if not drawedTelepoter[k..k2] then
                                        drawedTelepoter[k..k2] = true
                                        CreateThread(function()
                                            while drawedTelepoter[k..k2] do
                                                Wait(0)
                                                DrawMarker(0, v2.from.xyz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                                                ESX.Game.Utils.Draw3D(v2.from.xyz + vec(0, 0, 1), 'Exit')
                                            end
                                        end)
                                    end
                                else
                                    drawedTelepoter[k..k2] = nil
                                end
                            end

                            --flag check
                            for k2, v2 in pairs(v.flags) do
                                local distance = ESX.GetDistance(SUN.PlayerCoords, v2.coords.xyz)
                                if distance <= v2.drawRange then
                                    if not drawedFlags[k..k2] then
                                        drawedFlags[k..k2] = true
                                        CreateThread(function()
                                            while drawedFlags[k..k2] do
                                                Wait(0)
                                                local distance = ESX.GetDistance(SUN.PlayerCoords, v2.coords.xyz)
                                                local data = flagsData[k..k2] or {}
                                                local config = flagsConfig[k..k2] or {}
                                                local text = '~g~'.. v2.label .. '~w~\nCaptured By ~r~'.. (data.capturedBy or 'None') .. '~w~'
                                                if data.capturingBy then
                                                    text = text .. '\nCapturing By ~r~'.. data.capturingBy .. '~w~('.. (data.capturingEndTS - GetServerOSTime()) ..'s)'
                                                elseif data.rewardTime then
                                                    text = text .. '\n~y~' .. ESX.Math.Round(data.rewardTime - GetServerOSTime()) .. 's Remaining to reward~w~'
                                                end
                                                ESX.Game.Utils.DrawText3D(v2.coords.xyz + vec(0, 0, 15), text, 7)
                                                DrawMarker(5, v2.coords.xyz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 215, 0, 100, false, true, 2, false, false, false, false)
                                                if config.nearPerks and data.capturedBy == ESX.PlayerData.gang.name then
                                                    local radius = config.nearPerks.radius + .0
                                                    DrawMarker(28, v2.coords.xyz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, radius, radius, radius, 191, 0, 255, 20, false, true, 2, false, false, false, false)
                                                    if distance <= radius then
                                                        if not config.lastGivedPerk or config.lastGivedPerk + config.nearPerks.time <= GetGameTimer() then
                                                            config.lastGivedPerk = GetGameTimer() + (config.nearPerks.time * 1000)
                                                            if GetEntityHealth(SUN.ped) < GetPedMaxHealth(SUN.ped) then
                                                                ESX.SetEntityHealth(SUN.ped, GetEntityHealth(SUN.ped) + 1)
                                                            elseif GetPedArmour(SUN.ped) < GetPlayerMaxArmour(PlayerId()) then
                                                                ESX.SetPedArmour(SUN.ped, GetPedArmour(SUN.ped) + 1)
                                                            end
                                                        end
                                                        if config.nearPerks.headDisable then
                                                            SetPedSuffersCriticalHits(PlayerPedId(), false)
                                                            headDisable = true
                                                        end
                                                        if config.nearPerks.uav then
                                                            for k, v in pairs(ESX.Game.GetPlayers()) do
                                                                if v ~= PlayerId() then
                                                                    local ped = GetPlayerPed(v)
                                                                    local distance = ESX.GetDistance(v2.coords.xyz, GetEntityCoords(ped))
                                                                    if distance < config.nearPerks.uavRadius then
                                                                        if not DoesBlipExist(GetBlipFromEntity(ped)) then
                                                                            blip = AddBlipForEntity(ped)
                                                                            SetBlipSprite(blip, 8)
                                                                            ShowHeadingIndicatorOnBlip(blip, true)
                                                                            SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
                                                                            SetBlipNameToPlayerName(blip, id)
                                                                            SetBlipScale(blip, 0.85)
                                                                            SetBlipColour(blip, 1)
                                                                            SetBlipAsShortRange(blip, true)
                                                                            BeginTextCommandSetBlipName("STRING")
                                                                            AddTextComponentString(v)
                                                                            EndTextCommandSetBlipName(blip)
                                                                            playerBlips[GetPlayerServerId(v)] = blip
                                                                        end
                                                                    elseif playerBlips[GetPlayerServerId(v)] then
                                                                        RemoveBlip(playerBlips[GetPlayerServerId(v)])
                                                                        playerBlips[GetPlayerServerId(v)] = nil
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    elseif headDisable then
                                                        SetPedSuffersCriticalHits(PlayerPedId(), true)
                                                        headDisable = false
                                                        removePlayersBlip()
                                                    end
                                                elseif headDisable then
                                                    SetPedSuffersCriticalHits(PlayerPedId(), true)
                                                    headDisable = false
                                                    removePlayersBlip()
                                                end
                                            end
                                            if headDisable then
                                                SetPedSuffersCriticalHits(PlayerPedId(), true)
                                                headDisable = false
                                                removePlayersBlip()
                                            end
                                        end)
                                    end
                                else
                                    drawedFlags[k..k2] = nil
                                end
                                if distance <= v2.coords.w and not nearLoot then
                                    if not isInHack then
                                        canCaptureFlag = {k = k, k2 = k2}
                                        canCaptureFlag2 = true
                                        ESX.ShowHelpNotification('~INPUT_PICKUP~ Jahat Capture Flag')
                                    end
                                elseif canCaptureFlag and canCaptureFlag.k == k and canCaptureFlag.k2 == k2 then
                                    canCaptureFlag = nil
                                    canCaptureFlag2 = nil
                                end
                            end

                            --loot box
                            local entity = GetClosestObjectOfType(SUN.PlayerCoords, 2.0, lootBoxHash, false, false, false)
                            if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
                                local lastDistance = nil
                                for k2, v2 in pairs(v.flags) do
                                    local distance = ESX.GetDistance(GetEntityCoords(entity), v2.coords.xyz)
                                    if distance < 10 then
                                        if not lastDistance or lastDistance > distance then
                                            nearLoot = k .. k2
                                            ESX.ShowHelpNotification('~INPUT_PICKUP~ Jahat baz kardan box')
                                        end
                                    end
                                end
                            else
                                nearLoot = nil
                            end
                        end
                    end)
                end
                inZone = true
            elseif distance <= (v.coords.w + v.outdoorSafeRange) and SUN.World == 0 then
                if not nearIslandPVPDeactive then
                    nearIslandPVPDeactive = true
                    -- ESX.chatMessage('Safe zone', 'plarms')
                    CreateThread(function()
                        NetworkSetFriendlyFireOption(false)
                        while nearIslandPVPDeactive do
                            Wait(100)
                            local distance = ESX.GetDistance(SUN.PlayerCoords, v.coords.xyz)
                            if distance <= v.coords.w or distance > (v.coords.w + v.outdoorSafeRange) then
                                nearIslandPVPDeactive = false
                                NetworkSetFriendlyFireOption(true)
                                break
                            end
                            -- ESX.ShowMissionText('~g~Safe Zone')
                        end
                    end)
                end

            end
        end
        if not inZone and isInZone then
            -- ESX.SetPlayerData('isInIslandZone', false)
            TriggerServerEvent('island:setInIslandState')
            isInZone = false
            Wait(200)
            currentZoneId = nil
            ESX.chatMessage('Exit zone', 'plarms')
            for k, v in pairs(zonesBlip) do
                ESX.removeBlip(v)
            end
            zonesBlip = {}
            nearWeaponId = nil
            nearTeleporterId = nil
            canCaptureFlag = {}
            canCaptureFlag = false
            zombieSpawned = false
            stopZombie(zombieId)
            zombieId = nil
            zombieSpawnCooldown = GetGameTimer() + 60000 -- Set 1 minute cooldown
            -- for k, v in pairs(flagsData) do
            --     if v.blip then
            --         ESX.removeBlip(v.blip)
            --     end
            -- end
            -- flagsData = {}
        elseif inZone and not isInZone then

        end
        isInZone = inZone
        ESX.SetPlayerData('isInIslandZone', isInZone)
        Wait(5000)
    end
end)

AddEventHandler('island:tpToNearSafeZone', function()
    if currentZoneId and configCapIs.zones[currentZoneId] then
        ESX.Game.Teleport(SUN.ped, configCapIs.zones[currentZoneId].safeZone[math.random(1, #configCapIs.zones[currentZoneId].safeZone)].xyz)
        Wait(3000)
        ESX.revive()
        Wait(7000)
        if ESX.isDead() then
            ESX.revive()
        end
    end
end)

local eCD = false
AddEventHandler('KeyDown:e', function()
    if canCaptureFlag and canCaptureFlag.k and canCaptureFlag.k2 then
        if ESX.tableLength(ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), configCapIs.zones[currentZoneId].coords.w, true)) < 4 then
            canCaptureFlag = nil
            return ESX.chatMessage('Tedad player kafi baraye capture dar jazire vojud nadarad | had aghal 4 nafar', 'plarms')
        end
        local data = canCaptureFlag
        local kk = data.k .. data.k2
        if (flagsData[kk].capturedBy == ESX.PlayerData.gang.name and not flagsData[kk].capturingBy) or flagsData[kk].capturingBy == ESX.PlayerData.gang.name then return end
        isInHack = true
        canCaptureFlag = nil
        if startHackingGame(25, 20) then
            if canCaptureFlag2 then
                ESX.TriggerServerEvent('island:captureFlag', data.k .. data.k2, configCapIs.zones[data.k].flags[data.k2].captureTime,  data.k, data.k2)
            end
        end
        isInHack = false
    elseif nearWeaponId then
        local data = configCapIs.zones[currentZoneId].weaponsLocation[nearWeaponId]
        if data and not HasPedGotWeapon(PlayerPedId(), GetHashKey(data.name), false) then
            TriggerEvent('addWeaponTokhm', GetHashKey(data.name), true)
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), 250, false, true)
            addedWeapon[nearWeaponId] = true
        end
    elseif nearTeleporterId then
        if eCD then return end
        local data = configCapIs.zones[currentZoneId].teleporter[nearTeleporterId]
        if data then
            eCD = true
            TriggerEvent("mythic_progbar:client:progress", {
                name = 'tp',
                duration = data.time * 1000,
                label = '',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }
            }, function(status)
                eCD = false
                if not status then
                    ESX.fadeScreen(1000, function()
                        ESX.Game.Teleport(PlayerPedId(), data.to.xyzw)
                    end)
                end
            end)
        end
    elseif nearLoot then
        ESX.TriggerServerCallback('island:canOpenBox', function(can)
            if can then
                exports['sun-inventory-hud']:openInventory('capture-island:'.. nearLoot)
            end
        end, nearLoot)
        CreateThread(function()
            while nearLoot do
                Wait(1000)
            end
            exports['sun-inventory-hud']:closeInventory()
        end)
    end
end)

RegisterNetEvent('island:updateFlag', function(k, v)
    while not islandLoaded do Wait(100) end
    v.blip = flagsBlip[k]
    flagsData[k] = v
    if flagsData[k].capturingBy then
        changeFlagsBlipColor(k, 81)
        if isInZone or flagsData[k].capturedBy == ESX.PlayerData.gang.name then
            TriggerEvent('chat:addMessage', {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(148, 0, 211, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i> Island<br>  {0}</div>',
                args = {'^2'.. flagsConfig[k].label .. '^0 tavasot gang ^1'.. flagsData[k].capturingBy .. '^0 dar hale capture shodan ast' }
            }, 'gang')
        end
    elseif flagsData[k].capturedBy then
        if flagsData[k].capturedBy == ESX.PlayerData.gang.name then
            changeFlagsBlipColor(k, 2)
        else
            changeFlagsBlipColor(k, 1)
        end
        changeBlipLabel(k, flagsConfig[k].label .. '('.. flagsData[k].capturedBy ..')')
    else
        changeFlagsBlipColor(k, 0)
        changeBlipLabel(k, flagsConfig[k].label .. '(None)')
    end
end)

RegisterNetEvent('island:dropAlarm', function(k)
    while not islandLoaded do Wait(100) end
    if isInZone then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(148, 0, 211, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i> Island<br>  {0}</div>',
            args = {'Drop box ^2'.. flagsConfig[k].label .. '^0 dar hale ^2forud^0 amadan ast' }
        }, 'gang')
    end
end)

function changeFlagsBlipColor(k, color)
    if flagsBlip[k] then
        SetBlipColour(flagsBlip[k], color)
    end
end

function changeBlipLabel(k, text)
    if flagsBlip[k] then
        ESX.changeBlipLabel(flagsBlip[k], text)
    end
end

function removePlayersBlip()
    for k, v in pairs(playerBlips) do
        RemoveBlip(v)
    end
    playerBlips = {}
end

RegisterNetEvent('island:shotFlare', function(coords)
    if ESX.GetDistance(SUN.PlayerCoords, coords.xyz) < 200 then
        RequestWeaponAsset(GetHashKey("weapon_flare"))
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end
        RequestWeaponAsset(GetHashKey("weapon_bzgas"))
        while not HasWeaponAssetLoaded(GetHashKey("weapon_bzgas")) do
            Wait(0)
        end
        local crateSpawn = coords.xyz + vec(0, 0, 70)
        -- ESX.Game.SpawnLocalPed(5, 'a_c_cow', crateSpawn, 10, nil)
        crate = ESX.Game.SpawnLocalObject('prop_box_wood02a_pu', crateSpawn, nil, true)
        SetEntityInvincible(crate, true)
        SetEntityLodDist(crate, 1000)
        ActivatePhysics(crate)
        SetDamping(crate, 2, 2.0)
        SetEntityVelocity(crate, 0.0, 0.0, -0.2)

        parachute = ESX.Game.SpawnLocalObject('p_cargo_chute_s', crateSpawn, nil, true)
        SetEntityInvincible(parachute, true)
        SetEntityLodDist(parachute, 1000)
        ActivatePhysics(parachute)
        SetDamping(parachute, 2, 2.0)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)

        pickup = ESX.Game.SpawnLocalObject('prop_box_ammo03a', crateSpawn, nil, true)
        SetEntityInvincible(pickup, true)
        SetEntityLodDist(pickup, 1000)
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 2.0)
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)

        soundID = GetSoundId()
        PlaySoundFromEntity(soundID, "Crate_Beeps", pickup, "MP_CRATE_DROP_SOUNDS", false, 0)

        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        AttachEntityToEntity(pickup, crate, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true)
        ShootSingleBulletBetweenCoords(coords.xyz + vec(0, 0, 50), coords.xyz, 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later
        ShootSingleBulletBetweenCoords(coords.xyz + vec(0, 0, 50), coords.xyz, 0, false, GetHashKey("weapon_bzgas"), 0, true, false, -1.0) -- flare needs to be dropped with dropCoords like that, otherwise it remains static and won't remove itself later

        local pickupCoord = GetEntityCoords(pickup)
        while pickupCoord.z - coords.z > 4.0 do
            pickupCoord = GetEntityCoords(pickup)
            Wait(0)
        end

        SetEntityInvincible(crate, false)

        local parachuteCoords = vector3(GetEntityCoords(parachute)) -- we get the parachute dropCoords so we know where to drop the flare
        DetachEntity(parachute, true, true)
        DeleteEntity(parachute)
        DetachEntity(pickup) -- will despawn on its own
        StopSound(soundID) -- stop the crate beeping sound
        ReleaseSoundId(soundID) -- won't need this sound ID any longer
		DeleteEntity(pickup)

    end
end)