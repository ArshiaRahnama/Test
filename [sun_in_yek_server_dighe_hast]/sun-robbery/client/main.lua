-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX, playerLoaded, world = exports['essentialmode']:getObject(), false, 0
local currentRob, robThread, currentStep, objects, createdBlip, stressGerefte, currentAction = nil, false, nil, {}, {}, {}, {}
local mythicPerk = false
CreateThread(function()
    while (not ESX.IsPlayerLoaded()) do Wait(1000) end
    ESX.PlayerData = ESX.GetPlayerData()
    playerLoaded = true
    militaryCheckThread()
    for k, v in pairs(config.rob) do
        if v.join and not v.disabled then
            for k2, v2 in pairs(v.join.positions) do
                ESX.AddBlipForCoord(v2.coords, 0.5, 1, 41, v.label, 5)
                ESX.RegisterPoint(v2.coords, 2, {
                    Color = {R = 0,G = 255,B = 0,A = 150},
                    DrawDistance = 5,
                    Radius = {0.5, 0.5, 0.5},
                    Type = 42,
                    world = not v2.canExit and 0,
                    worldCheck = v2.canExit and false,
                },{
                    Notification = ('~INPUT_CONTEXT~ Robbery %s'):format(v.label),
                    Key = 'e',
                    CB = function()
                        Wait(math.random(10, 50))
                        if not IsPedInAnyVehicle(PlayerPedId(), false) and not ESX.isDead() and ESX.GetPlayerData().HandCuffed ~= 1 then
                            if currentRob and v2.canExit then
                                openExitMenu(v2.tpCoords)
                            elseif world == 0 then
                                openRobMenu(k, v2.robber, v2.tpCoords)
                            end
                        end
                    end,
                },{
                    Out = ESX.UI.Menu.CloseAll
                })
            end
        end
    end
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
    militaryCheckThread()
end)

RegisterNetEvent('esx:setGang', function(gang)
    ESX.PlayerData.gang = gang
end)

exports('getConfig', function()
    return config.rob
end)

RegisterNetEvent('esx:changeworld', function(_world)
    world = _world
end)

function openRobMenu(type, robber, tpCoords)
    lib.hideMenu()
    local config = config.rob[type]
    local bAvailable = checkRobberyAvailable(type)
    local options = {
        {label = ('Rob name : %s'):format(config.label), close = false},
        {label = ('Police/Robber : %s/%s'):format(config.startCheck.militaryNeed.count, config.startCheck.robberNeed), close = false},
        {label = ('Available : %s'):format(bAvailable and '✔️' or '❌'), close = false},
    }
    local robberies = {}
    local p = promise:new()
    ESX.TriggerServerCallback('rob:getRobs',function(count)
        p:resolve(count)
    end)
    robberies = Citizen.Await(p)
    local ts = exports['sunset_utils']:GetServerOSTime()
    if (ESX.militaryJobs2[ESX.PlayerData.job.name] or ESX.PlayerData.job.name == 'ambulance') and not robber then
        table.insert(options, {label = '----- Active robs -----', close = false})
        for k, v in pairs(robberies) do
            if v.type == type and ((v.started and not v.success) or ESX.PlayerData.job.name == 'ambulance') then
                table.insert(options, {label = ('Id : %s, Start From : %sM Ago, Police/Robber : %s/%s'):format(v.id, ESX.Math.Round((ts - v.startTS) / 60), ESX.tableLength(v.players.police), ESX.tableLength(v.players.robbers)), close = true, args = {action = 'join', id = v.id}})
            end
        end
    elseif robber then
        if ESX.doesHaveGangPerm('ghoreKeshi') then
            local p = promise:new()
            ESX.TriggerServerCallback('rob:getLotteryWinner', function(winner)
                if winner and winner.gang == ESX.PlayerData.gang.name and not winner.robId then
                    table.insert(options, {label = 'Start robbery', args = {action = 'start'}})
                end
                p:resolve()
            end, config.lotteryId)
            Citizen.Await(p)
        end
        for k, v in pairs(robberies) do
            if v.type == type and not v.success and v.gang == ESX.PlayerData.gang.name then
                table.insert(options, {label = ('Id : %s, Start From : %sM Ago, Police/Robber : %s/%s'):format(v.id, ESX.Math.Round((ts - v.startTS) / 60), ESX.tableLength(v.players.police), ESX.tableLength(v.players.robbers)), close = true, args = {action = 'join', id = v.id}})
            end
        end
    end
    lib.registerMenu({
        id = 'robMenu'.. type,
        title = 'Robbery ' .. config.label,
        position = 'top-left',
        options = options
    }, function(selected, scrollIndex, args)
        if args then
            if args.action == 'start' then
                if not ESX.militaryJobs[ESX.PlayerData.job.name] then
                    ESX.TriggerServerEvent('rob:start', type)
                end
            elseif args.action == 'join' then
                if lib.progressCircle({
                    duration = 10 * 1000,
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    allowRagdoll = true,
                    allowFalling = true,
                    disable = {
                        move = true,
                    },
                }) then
                    ESX.TriggerServerEvent('rob:join', args.id)
                    if tpCoords then
                        Wait(1000)
                        ESX.Game.Teleport(PlayerPedId(), tpCoords)
                    end
                end
            end
        end
    end)
    lib.showMenu('robMenu'.. type)
    ESX.registerExitPoint(4, function ()
        lib.hideMenu()
    end)
end

RegisterNetEvent('rob:setRob', function(data)
    currentRob = data
    if not data then
        currentStep = nil
        robThread = false
        mythicPerk = false
        for k, v in pairs(objects) do
            ESX.Game.DeleteEntity(v)
        end
        objects = {}
        deleteBlips()
        if mythicPerk then
            SetPlayerMaxArmour(PlayerId(), 100)
            ESX.SetPedArmour(PlayerPedId(), 0)
            SetPedSuffersCriticalHits(PlayerPedId(), true)
        end
        TriggerEvent('setForceFox', false)
        TriggerEvent('noCollisionState', false)
    elseif not robThread then
        startRobberyThread()
        TriggerEvent('noCollisionState', true)
        if not stressGerefte[currentRob.data.id] then
            stressGerefte[currentRob.data.id] = true
            TriggerEvent('stress:add', 'party_start_rob')
        end
        if currentRob.data.config.fox then
            TriggerEvent('setForceFox', true)
            ESX.chatMessage('Baraye tir andazi dar in robbery niaz be Fox darid!', 'plarms')
        end
        if currentRob.data.trinket > 0 and not mythicPerk then
            mythicPerk = true
            if currentRob.data.config.trinketsPerk[currentRob.data.trinket][currentRob.class] then
                local perkLevel = currentRob.class == 'police' and currentRob.data.level or currentRob.data.trinket
                if currentRob.data.config.trinketsPerk[perkLevel][currentRob.class].disableheadbox then
                    SetPedSuffersCriticalHits(PlayerPedId(), false)
                end
                if currentRob.data.config.trinketsPerk[perkLevel][currentRob.class].armor > 0 then
                    SetPlayerMaxArmour(PlayerId(), currentRob.data.config.trinketsPerk[perkLevel][currentRob.class].armor)
                    ESX.SetPedArmour(PlayerPedId(), currentRob.data.config.trinketsPerk[perkLevel][currentRob.class].armor)
                end
            end
        end
    end
    if currentRob.data.visuals then
        for k, v in pairs(currentRob.data.visuals) do
            if v.type == 'progress1' then
                local ts = exports['sunset_utils']:GetServerOSTime()
                if v.endTS > ts then
                    local s = v.endTS - ts
                    TriggerEvent('countdown', 'cd '.. s)
                end
            end
        end
    end
    if currentRob.data.objects then
        for k, v in pairs(currentRob.data.objects) do
            if not objects[v.id] then
                objects[v.id] = true
                ESX.Game.SpawnLocalObject(v.model, v.coords, function(object)
                    objects[v.id] = object
                    if v.inventoryName then
                        Entity(object).state:set('inventoryName', v.inventoryName, false)
                    end
                    if v.freeze then
                        FreezeEntityPosition(object, true)
                    end
                end)
            end
        end
    end
end)

function openExitMenu(tpCoords)
    -- if currentRob.class == 'police' then
    --     local options = {
    --         {label = 'Jail', args = {action = 'jail'}},
    --         {label = 'Exit', args = {action = 'exit'}},
    --     }
    --     lib.registerMenu({
    --         id = 'robMenuJail',
    --         title = 'Exit',
    --         position = 'top-left',
    --         options = {
    --             {label = 'Jail', args = {action = 'jail'}},
    --             {label = 'Exit', args = {action = 'exit'}},
    --         }
    --     }, function(selected, scrollIndex, args)
    --         if args then
    --             if args.action == 'jail' then
    --                 openJailMenu()
    --             elseif args.action == 'exit' then
    --                 exitDialog()
    --             end
    --         end
    --     end)
    --     lib.showMenu('robMenu'.. type)
    -- else
        exitDialog(tpCoords)
    -- end
end

function exitDialog(tpCoords)
    local alert = lib.alertDialog({
        content = 'Aya mayel be khorouj az robbery hastid?',
        centered = true,
        cancel = true
    })
    if alert == 'confirm' then
        if lib.progressCircle({
            duration = 10 * 1000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            allowRagdoll = true,
            allowFalling = true,
            disable = {
                move = true,
            },
        }) then
            ESX.TriggerServerEvent('rob:exitRobbery')
            if tpCoords then
                Wait(1000)
                ESX.Game.Teleport(PlayerPedId(), tpCoords)
            end
        end
    end
end

function startRobberyThread()
    if not robThread then
        robThread = true
        local stepCount = #currentRob.data.config.steps
        local ts = 0
        local lastCoords, lastCoords2
        CreateThread(function()
            while robThread do
                ts = exports['sunset_utils']:GetServerOSTime()
                Wait(1000)
            end
        end)
        CreateThread(function()
            while robThread do
                Wait(0)
                local coords = GetEntityCoords(PlayerPedId())
                if currentRob.class == 'robbers' then
                    for k, v in pairs(currentRob.data.config.steps) do
                        if not v.passed and not v.started and (k == 1 or currentRob.data.config.steps[k - 1].passed) then
                            if not createdBlip[k] then
                                deleteBlips()
                                createdBlip[k] = ESX.AddBlipForCoord(v.coords, 0.5, 1, 1, v.label, 5)
                            end
                            if k == stepCount then
                                DrawMarker(10 + k, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 255, 215, 0, 150, true, true, 0, true)
                            else
                                DrawMarker(10 + k, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 0, 255, 0, 150, true, true, 0, true)
                            end
                            local distance = #(v.coords - coords)
                            if distance < 2 then
                                v.k = k
                                currentStep = v
                                if v.label then
                                    ESX.ShowHelpNotification('~INPUT_CONTEXT~ Jahat '.. v.label)
                                end
                            elseif currentStep and currentStep.k == k then
                                currentStep = nil
                            end
                        end
                    end
                end
                if currentRob.data.config._successTime and currentRob.data.config._successTime > ts and not currentRob.data.config.steps[stepCount].started then
                    ESX.Game.Utils.DrawText2D(('%ss ta force success'):format(currentRob.data.config._successTime - ts), 0.85, 0.95, 0.4)
                end
                if currentRob.data.config.vehicles then
                    for k, v in pairs(currentRob.data.config.vehicles.spawner) do
                        if v.access == currentRob.class then
                            for k2, v2 in pairs(v.coords) do
                                local distance = #(v2.spawner - coords)
                                if distance < 2 then
                                    ESX.ShowHelpNotification('~INPUT_CONTEXT~ Jahat spawn mashin')
                                    currentAction = {
                                        type = 'spawner',
                                        k = k,
                                        k2 = k2,
                                    }
                                elseif currentAction.k == k and currentAction.k2 == k2 and currentAction.type == 'spawner' then
                                    currentAction = {}
                                end
                                --
                                DrawMarker(5, v2.spawner.x, v2.spawner.y, v2.spawner.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 0, 255, 0, 150, true, true, 0, true)
                            end
                        end
                    end
                    for k, v in pairs(currentRob.data.config.vehicles.deleter) do
                        local distance = #(v - coords)
                        if distance < 4 then
                            ESX.ShowHelpNotification('~INPUT_CONTEXT~ Jahat hazf mashin')
                            currentAction = {
                                type = 'delete',
                                k = k,
                            }
                        elseif currentAction.k == k and currentAction.type == 'delete' then
                            currentAction = {}
                        end
                        DrawMarker(24, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.5, 0, 255, 0, 150, true, true, 0, true)
                    end
                end
                if currentRob.data.config.rangeCheck then
                    if #(currentRob.data.config.rangeCheck.coords.xyz - coords) > currentRob.data.config.rangeCheck.coords.w then
                        ESX.Game.Teleport(PlayerPedId(), lastCoords)
                    else
                        lastCoords = coords
                    end
                end
                if currentRob.data.config.rangeCheck2 and currentRob.class == 'robbers' and not currentRob.data.success then
                    if #(currentRob.data.config.rangeCheck2.coords.xyz - coords) > currentRob.data.config.rangeCheck2.coords.w then
                        ESX.Game.Teleport(PlayerPedId(), lastCoords2)
                    else
                        lastCoords2 = coords
                    end
                end
            end
        end)
    end
end

function deleteBlips()
    for k, v in pairs(createdBlip) do
        ESX.removeBlip(v)
    end
    createdBlip = {}
end
local antiSpam = false
AddEventHandler('KeyDown:e', function()
    if antiSpam then return end
    antiSpam = true
    SetTimeout(3000, function ()
        antiSpam = false
    end)
    if currentStep and currentRob then
        if not currentRob.data.config.steps[currentStep.k].passed and not currentRob.data.config.steps[currentStep.k].started then
            local step = currentRob.data.config.steps[currentStep.k]
            local haveItem = true
            local itemNeed = ''
            if step.itemNeed then
                for k, v in pairs(step.itemNeed) do
                    if not ESX.DoesHaveItem2(k, v) then
                        haveItem = false
                        itemNeed = ('%sx %s'):format(v, ESX.getItemLabel(k))
                        break
                    end
                end
            end
            local skip = false
            if step.itemNeed and not haveItem then
                local alert = lib.alertDialog({
                    content = ('In step niaz be %s darad, shoma in item ra nadarid, aya mayel be skip in step hastid? !!Tavajoh konid ke ba skip in step meghdar kami az loot robbery kam mishavad'):format(itemNeed, (step.failPercentRemove or 0)),
                    centered = true,
                    cancel = true
                })
                if alert == 'cancel' then
                    return
                else
                    skip = true
                end
            end
            if step.module == 'simple1' then
                ESX.TriggerServerCallback('rob:doesStepAvailable', function(bAvailable)
                    if bAvailable then
                        ESX.TriggerServerEvent('rob:startStep', currentStep.k, not step.itemNeed or haveItem)
                    end
                end, currentRob.data.id, currentStep.k)
            elseif step.module == 'hack' then
                local success = false
                if not skip then
                    local p = promise.new()
                    if step.data.type == 'var' then
                        exports['ps-ui']:VarHack(function(success)
                            p:resolve(success)
                        end, step.data.block, step.data.time)
                    elseif step.data.type == 'thermite' then
                        exports['ps-ui']:Thermite(function(success)
                            p:resolve(success)
                        end, step.data.time, step.data.block, step.data.fail)
                    elseif step.data.type == 'maze' then
                        exports['ps-ui']:Maze(function(success)
                            p:resolve(success)
                        end, step.data.time)
                    elseif step.data.type == 'scrambler' then
                        exports['ps-ui']:Scrambler(function(success)
                            p:resolve(success)
                        end, step.data.type2, step.data.time, step.data.mirrored)
                    end
                    success = Citizen.Await(p)
                else
                    success = false
                end
                ESX.TriggerServerEvent('rob:startStep', currentStep.k, success and (not step.itemNeed or haveItem))
            end
        end
    end
    if currentAction and currentRob then
        if currentAction.type == 'spawner' then
            local options = {}
            for k, v in pairs(currentRob.data.config.vehicles.spawner[currentAction.k].models) do
                table.insert(options, {label = v.label, args = v})
            end
            lib.registerMenu({
                id = 'robMenuSpawn',
                title = 'Vehicle spawn',
                position = 'top-left',
                options = options
            }, function(selected, scrollIndex, args)
                if args then
                    Wait(math.random(100, 1000))
                    ESX.TriggerServerCallback('rob:canSpawnVehicle', function(can)
                        if can then
                            local spawnerAccess = currentRob.data.config.vehicles.spawner[currentAction.k].access
                            ESX.Game.SpawnVehicle(args.model, currentRob.data.config.vehicles.spawner[currentAction.k].coords[currentAction.k2].spawnPoint.xyz, currentRob.data.config.vehicles.spawner[currentAction.k].coords[currentAction.k2].spawnPoint.w, function(vehicle)
                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                SetVehicleMaxMods(vehicle, true)
                                if args.livery then
                                    SetVehicleLivery(vehicle, args.livery)
                                end
                                if spawnerAccess == 'police' then
                                    exports['esx_vehiclecontrol']:SetDecor(vehicle, 'PD')
                                end
                                ESX.giveCarKey(vehicle)
                                Wait(2000)
                                TriggerServerEvent('rob:addVehicle', NetworkGetNetworkIdFromEntity(vehicle), nil, joaat(args.model))
                            end)
                        else
                            ESX.chatMessage('Shoma had aksar mashin ra spawn kardid!', 'plarms')
                        end
                    end, joaat(args.model), args.limit)
                end
            end)
            lib.showMenu('robMenuSpawn')
        elseif currentAction.type == 'delete' then
            local vehicle = ESX.isVehicleDriver()
            TriggerServerEvent('rob:addVehicle', NetworkGetNetworkIdFromEntity(vehicle), true, GetEntityModel(vehicle))
            Wait(1000)
            ESX.Game.DeleteEntity(vehicle)
        end
    end
end)

exports('doesInRob', function ()
    return currentRob
end)

exports('doesRobSuccess', function ()
    return currentRob and currentRob.data and currentRob.data.success
end)

function SetVehicleMaxMods(vehicle, turbo)
    local props = {
        modEngine       =   3,
        modBrakes       =   2,
        windowTint      =   1,
        modArmor        =   4,
        modTransmission =   2,
        modSuspension   =   GetNumVehicleMods(vehicle, 15) - 1,
        modTurbo        =   turbo,
        modXenon     = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
end

RegisterNetEvent('robbery:updateProgressCircle', function(time)
    TriggerEvent('countdown', 'cd stop')
    Wait(100)
    TriggerEvent('countdown', 'cd '.. time)
end)

RegisterNetEvent('rob:playSound', function()
    exports['xsound']:PlayUrl('robbery', './sounds/censorbeep.mp3', 0.5)
end)