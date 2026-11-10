-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local currentRob
local robCache = {}
local nearHouse, nearExit = false, false
local currentCarry
local soundId = GetSoundId()
local alarmList = {}

CreateThread(function()
    houseRobbery.objectReward2 = {}
    for k, v in pairs(houseRobbery.objectReward) do
        houseRobbery.objectReward2[joaat(k)] = true
    end
end)


local function exitHouse()
    local p = promise.new()
    ESX.fadeScreen(750, function()
        ESX.TriggerServerCallback('houserob:exitHouse', function()
            ESX.Game.Teleport(SUN.ped, currentRob.coords)
            -- deleteObjects2()
            robCache.inHouse = false
            Wait(100)
            p:resolve(true)
        end)
    end)
    Citizen.Await(p)
end

local function houseRobberyThread()
    robCache.detected = false
    CreateThread(function()
        while robCache.id == currentRob.id do
            Wait(0)
            local distance = #(SUN.PlayerCoords - currentRob.coords)
            nearHouse = false
            if distance < 100 then
                DrawMarker(0, currentRob.coords.x, currentRob.coords.y, currentRob.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, true, false)
                if distance < 1.5 then
                    ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baraye serghat az khane')
                    nearHouse = true
                end
            end
            if currentCarry and not IsEntityPlayingAnim(SUN.ped, 'anim@heists@box_carry@', 'idle', 1) then
                TaskPlayAnim(SUN.ped, 'anim@heists@box_carry@', 'idle', 2.0, 2.0, -1, 49, 0, false, false, false)
            end

            if currentCarry and SUN.vehiclePlayerIsIn ~= 0 then
                TaskLeaveVehicle(SUN.ped, SUN.vehiclePlayerIsIn, 16)
            end

            nearExit = false
            if robCache.inHouse then
                local joinCoords = houseRobbery.shellCoords[robCache.template.model].Join.xyz + houseRobbery.houseCoords
                local distance = #(SUN.PlayerCoords - joinCoords)
                if distance < 100 then
                    DrawMarker(0, joinCoords.x, joinCoords.y, joinCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, true, false)
                    if distance < 2 then
                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baraye khoroj az khane')
                        nearExit = true
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        Wait(1000)
        local warn = 0
        local startPed = false
        Wait(9000)
        while robCache.id == currentRob.id do
            Wait(0)
            if robCache and robCache.inHouse then
                if not robCache.detected2 then
                    local color = {0, 255, 0}
                    local playerSpeed = GetEntitySpeed(SUN.ped)

                    local barWidth = math.min(playerSpeed / 20.0, 1.0)

                    local barX = 0.5
                    local barY = 0.1
                    local barHeight = 0.02
                    if barWidth > 0.08 then
                        color = {255, 165, 0}
                    end
                    if barWidth > 0.15 then
                        color = {255, 0, 0}
                        warn = warn + 1
                        if warn > 50 then
                            robCache.detected = true
                        end
                    else
                        warn = 0
                    end
                    if IsPedShooting(SUN.ped) then
                        robCache.detected = true
                    end
                    DrawRect(barX, barY, barWidth, barHeight, color[1], color[2], color[3], 150)

                    if robCache.detected and not startPed then
                        robCache.detected2 = true
                        currentRob.detected = true
                        startPed = true
                        ESX.TriggerServerEvent('houseRobbery:detected')
                        ESX.startCountdown(houseRobbery.alarmExitTime * 60, 'Khorooj', function ()
                            if robCache.inHouse then
                                exitHouse()
                            end
                        end, function()
                            return robCache.inHouse
                        end)
                        for k, ped in pairs(robCache.tempPeds) do
                            FreezeEntityPosition(ped, false)
                            SetBlockingOfNonTemporaryEvents(ped, false)
                            SetEntityInvincible(ped, false)
                            TaskCombatPed(ped, SUN.ped, 0, 16)
                            SetPedAsEnemy(ped, true)
                            SetPedCombatAttributes(ped, 46, true)
                            SetPedCombatAbility(ped, 2)
                            SetPedCombatMovement(ped, 2)
                            SetPedCombatRange(ped, 2)
                            SetPedAlertness(ped, 3)
                            SetPedTargetLossResponse(ped, 1)
                        end

                        PlaySoundFromCoord(soundId, 'VEHICLES_HORNS_AMBULANCE_WARNING', houseRobbery.houseCoords.x, houseRobbery.houseCoords.y, houseRobbery.houseCoords.z)
                    end
                end

                for k, object in pairs(robCache.tempObjects) do
                    local model = GetEntityModel(object)
                    if model and houseRobbery.objectReward2[model] then
                        local distance = #(SUN.PlayerCoords - GetEntityCoords(object))
                        SetEntityDrawOutline(object, distance < 5 and true or false)
                    end
                end
            end
        end
    end)
end

local function deleteObjects()
    if robCache.entityForTarget then
        for k, v in pairs(robCache.entityForTarget) do
            exports['ox_target']:removeLocalEntity(v.object)
        end
    end
    if robCache.tempObjects then
        for k, v in pairs(robCache.tempObjects) do
            if not currentCarry or v ~= currentCarry.object then
                DeleteEntity(v)
            end
        end
    end

    if robCache.tempPeds then
        for k, v in pairs(robCache.tempPeds) do
            DeletePed(v)
        end
    end
    robCache.tempObjects = {}
    robCache.tempPeds = {}
    robCache.entityForTarget = {}
end

local function deleteObjects2()
    deleteObjects()
    DeleteEntity(robCache.shell)
    StopSound(soundId)
    robCache.shell = nil
end

local function clearOldRobbery()
    ESX.removeBlip(robCache.blip)
    deleteObjects2()
    nearHouse, nearExit = false, false
end

AddEventHandler('onResourceStop', function(resource)
    if resource == 'sunset_utils' then
        clearOldRobbery()
    end
end)

function SetupRelationshipGroup()
    local groupHash = joaat('TEAM_1')
    AddRelationshipGroup('TEAM_1')
    SetRelationshipBetweenGroups(0, groupHash, groupHash)
    SetRelationshipBetweenGroups(5, groupHash, GetHashKey('PLAYER'))
end

local function teleportToHouse()
    DoScreenFadeOut(750)
    Wait(1000)
    local shell = robCache.template.model
    local joinCoords = houseRobbery.shellCoords[shell].Join.xyz + houseRobbery.houseCoords
    for i = 1, 25 do
        ESX.SetEntityCoords(PlayerPedId(), joinCoords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        ESX.SetEntityCoords(PlayerPedId(), joinCoords)
        Wait(50)
    end
    SetEntityHeading(PlayerPedId(), houseRobbery.shellCoords[shell].Join.w)
    DoScreenFadeIn(2500)
end

local function spawnObject(k, v)
    local p = promise.new()
    ESX.Game.SpawnLocalObject(v.model, GetOffsetFromEntityInWorldCoords(robCache.shell, v.pos.x, v.pos.y, v.pos.z),function(object)
        Entity(object).state.antiDelete = true
        FreezeEntityPosition(object, true)
        ESX.SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(robCache.shell, v.pos.x, v.pos.y, v.pos.z))
        if v.rot then SetEntityRotation(object, v.rot.x * 1.0, v.rot.y * 1.0, v.rot.z * 1.0, 2) end
        SetEntityCollision(object,true,true)
        table.insert(robCache.tempObjects, object)
        if houseRobbery.objectReward[v.model] then
            table.insert(robCache.entityForTarget, {object = object, model = v.model, id = k})
        else
            -- SetEntityAlpha(object, 205, true)
        end
        p:resolve()
    end)
    Citizen.Await(p)
end

local function updateTemplate(teleport)
    -- deleteObjects()
    local shell = robCache.template.model
    local objectList = robCache.template.objects or {}
    local pedList = robCache.template.peds or {}
    if teleport then
        DoScreenFadeOut(750)
    end

    if not robCache.shell then
        local p = promise.new()
        ESX.Game.SpawnLocalObject(shell, houseRobbery.houseCoords,function(obj)
            robCache.shell = obj
            SetEntityHeading(robCache.shell, 0.0)
            FreezeEntityPosition(robCache.shell, true)
            while not IsScreenFadedOut() and teleport do Wait(0) end
            local joinCoords = houseRobbery.shellCoords[shell].Join.xyz + houseRobbery.houseCoords
            if teleport then
                for i = 1, 25 do
                    ESX.SetEntityCoords(PlayerPedId(), joinCoords)
                    Wait(50)
                end
                while IsEntityWaitingForWorldCollision(PlayerPedId()) do
                    ESX.SetEntityCoords(PlayerPedId(), joinCoords)
                    Wait(50)
                end
                SetEntityHeading(PlayerPedId(), houseRobbery.shellCoords[shell].Join.w)
            end
            if teleport then
                DoScreenFadeIn(2500)
            end
            p:resolve()
        end)
        Citizen.Await(p)
    end

    for k, v in pairs(objectList) do
        if IsModelInCdimage(joaat(v.model)) then
            if not v.delete and houseRobbery.objectReward[v.model] then
                spawnObject(k, v)
            end
        else
            ESX.chatMessage(('%s load nashod'):format(v.model), 'plarms')
        end
    end

    for k, v in pairs(objectList) do
        if IsModelInCdimage(joaat(v.model)) then
            if not v.delete and not houseRobbery.objectReward[v.model] then
                spawnObject(k, v)
            end
        else
            ESX.chatMessage(('%s load nashod'):format(v.model), 'plarms')
        end
    end

    for k2, v in pairs(robCache.entityForTarget) do
        exports['ox_target']:addLocalEntity({v.object},{{
                label = 'سرقت🦹‍♂️',
                onSelect = function()
                    if currentRob and houseRobbery.objectReward[v.model] and not currentCarry then
                        local config = houseRobbery.objectReward[v.model]
                        ESX.entityFaceEntity(SUN.ped, v.object)
                        if config.type == 1 then
                            local success = lib.skillCheck({'easy', 'easy'}, {'1', '2', '3'})
                            if success then
                                exports['sun-animmenu']:PlayEmote('pickup', true)
                                Wait(1500)
                                AttachEntityToEntity(v.object, SUN.ped, GetPedBoneIndex(SUN.ped, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
                                ESX.Streaming.RequestAnimDict('anim@heists@box_carry@')
                                currentCarry = {
                                    model = v.model,
                                    id = v.id,
                                    type = 1,
                                    object = v.object,
                                }
                            else
                                ESX.chatMessage('Be dalil faile mini game, reward hazf shod', 'plarms')
                                DeleteEntity(v.object)
                            end
                            ESX.TriggerServerEvent('houserob:deleteObject', v.id)
                        elseif config.type == 2 or config.type == 3 then
                            DeleteEntity(v.object)
                            ESX.TriggerServerEvent('houserob:deleteObject', v.id)
                            Wait(300)
                            if config.type == 3 then
                                exports['sun-animmenu']:PlayEmote('pickup', true)
                                ESX.TriggerServerEvent('houserob:putInVehicle', {object = v.object, model = v.model, id = v.id}, nil, nil)
                            else
                                exports['ps-ui']:Scrambler(function(success)
                                    if success then
                                        exports['sun-animmenu']:PlayEmote('pickup', true)
                                        ESX.TriggerServerEvent('houserob:putInVehicle', {object = v.object, model = v.model, id = v.id}, nil, nil)
                                    else
                                        robCache.detected = true
                                    end
                                end, 'numeric', 45, 0)
                            end
                        end
                    end
                end,
        }})
    end
    SetupRelationshipGroup()
    for k, v in pairs(pedList) do
        local p = promise.new()
        ESX.Game.SpawnLocalPedAsync(27, v.model, GetOffsetFromEntityInWorldCoords(robCache.shell, v.pos.x, v.pos.y, v.pos.z), 165, function(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            Wait(10)
            local coords = GetOffsetFromEntityInWorldCoords(robCache.shell, v.pos.x, v.pos.y, v.pos.z)
            ESX.SetEntityCoordsNoOffset(ped, coords)
            if v.rot then SetEntityRotation(ped, v.rot.x * 1.0, v.rot.y * 1.0, v.rot.z * 1.0, 2) end
            -- TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SLEEP', 0, true)
            ESX.Streaming.RequestAnimDict('timetable@tracy@sleep@')
            TaskPlayAnim(ped, 'timetable@tracy@sleep@', 'idle_c', 2.0, 2.0, -1, 1, 0, false, false, false)
            GiveWeaponToPed(ped, joaat(v.weapon), 250, false, true)
            SetCurrentPedWeapon(ped, joaat(v.weapon), true)
            SetPedRelationshipGroupHash(ped, joaat('TEAM_1'))
            table.insert(robCache.tempPeds, ped)
            p:resolve()
        end)
        Citizen.Await(p)
    end

    -- for k, v in pairs(robCache.entityForTarget) do
        
    -- end

end


AddEventHandler('KeyDown:e', function()
    if nearHouse and ESX.checkCooldown('houserob', 3000) then
        if currentRob.detected then
            return ESX.chatMessage('System Amniyati khane fa\'al ast, Nemitavanid vared khane shavid', 'plarms')
        end
        ESX.TriggerServerCallback('houserob:enterHouse', function(template)
            if not template then return end
            robCache.template = template
            teleportToHouse()
            robCache.inHouse = true
        end)
    end
    if nearExit and ESX.checkCooldown('houserob2', 3000) then
        exitHouse()
    end
end)

local function clearCarryObject()
    if currentCarry then
        DeleteEntity(currentCarry.object)
        ClearPedTasks(SUN.ped)
        currentCarry = nil
    end
end

AddEventHandler('KeyDown:x', function()
    if ESX.checkCooldown('houserob', 3000) and currentCarry then
        local alert = lib.alertDialog({
            header = '',
            content = 'Aya mayel be door andakhtan in shey hastid?',
            centered = true,
            cancel = true
        })
        if alert == 'confirm' then
            clearCarryObject()
        end
    end
end)


RegisterNetEvent('houserob:setRobData', function(data)
    if data then
        currentRob = data
    end

    if currentRob and data then
        if robCache.blip then
            clearOldRobbery()
        end
        robCache.blip = ESX.AddBlipForCoord(currentRob.coords.xyz, 2.0, 40, 1, 'House robbery')
        SetNewWaypoint(currentRob.coords.x, currentRob.coords.y)
        robCache.template = currentRob.template
        deleteObjects()
        updateTemplate()
        if robCache.id ~= currentRob.id then
            robCache.id = currentRob.id
            houseRobberyThread()
        end
    else
        if robCache.inHouse then
            exitHouse()
        end
        clearOldRobbery()
        robCache = {}
        currentCarry = nil
        currentRob = nil
    end
end)

exports('houseRobGetCurrentCarry', function()
    return currentCarry
end)

exports('putCarriedHouseObject', function(vehicle)
    if currentCarry then
        local _currentCarry = ESX.CopyTable(currentCarry)
        currentCarry = nil
        CreateThread(function()
            lib.progressCircle({
                duration = 5000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            })
        end)
        Wait(5000)
        DeleteEntity(_currentCarry.object)
        ClearPedTasks(SUN.ped)
        ESX.TriggerServerEvent('houserob:putInVehicle', _currentCarry, ESX.GetPlate(vehicle), exports['sun-inventory-hud']:getVehicleMaxWeight(vehicle))
    end
end)

RegisterNetEvent('houseRobbery:alarm', function(coords, houseId)
    local blip = ESX.AddBlipForCoord(coords.xyz, 0.5, 40, 1, ('House robbery(%s)'):format(houseId))
    local blip2 = ESX.AddBlipForCoord(coords.xyz, 1.0, 161, 1, ('House robbery(%s)'):format(houseId))
    ESX.PulseBlip(blip2)
    ESX.chatMessage(('Yek robbery khane dar %sM shoma dar hale anjam ast'):format(ESX.Math.Round(#(SUN.PlayerCoords - coords))), 'plarms')
    alarmList[houseId] = {
        blip,
        blip2
    }
    SetTimeout(houseRobbery.alarmTime * 60000, function()
        ESX.removeBlip(blip)
        ESX.removeBlip(blip2)
    end)
end)

RegisterNetEvent('houseRobbery:deleteAlarm', function(houseId)
    if alarmList[houseId] then
        for k, v in pairs(alarmList[houseId]) do
            ESX.removeBlip(v)
        end
    end
end)

RegisterNetEvent('houseRobbery:alarm2', function(coords, houseId)
    SetNewWaypoint(coords.x, coords.y)
end)

AddEventHandler('esx:onPlayerDeath', function()
    if robCache and robCache.inHouse then
        if robCache.tempPeds then
            for k, v in pairs(robCache.tempPeds) do
                DeletePed(v)
            end
        end
        exitHouse()
    end
end)
