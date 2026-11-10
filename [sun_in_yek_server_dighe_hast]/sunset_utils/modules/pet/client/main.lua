-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inProgress = false
local group = nil
local availblePet = {}
local near = true
local ball = `weapon_ball`
local ballModel = `w_am_baseball`
local ownedPets = {}
local temporarySpawned = false
local spawnedPets = {}
function openPetMenu()
    if inProgress then return end
    ESX.TriggerServerCallback('pet:getPets', function(pets)
        ownedPets = pets
        local list = {}
        if #pets == 0 then return ESX.Alert('','Shoma peti nadarid!',7000,'warning') end
        for k, v in pairs(pets) do
            table.insert(list,{
                img = v.model,
                text = v.label .. '('.. (v.availble and '✅' or '❌') ..')', 
                text2 = 'Pet ID : '.. v.id,
                callBack = function()
                    if v.availble then
                        inProgress = true
                        exports['icon_menu']:ForceCloseMenu()
                        spawnPet(v)
                    else
                        ESX.Alert('','Pet mored nazar dar dastres nist!',7000,'error')
                    end
            end})
        end
        exports['icon_menu']:OpenMenu(list)
    end)
end

CreateThread(function()
    waitForLoad()
    SetTimeout(15000, function()
        ESX.TriggerServerCallback('pet:getPets', function(pets)
            ownedPets = pets
        end)
    end)
end)

function managePet()
    local list = {}
    for k, v in pairs(availblePet) do
        table.insert(list,{
            img = v.model,
            text = v.label,
            text2 =  (GetEntityHealth(v.pet) - 100) .. '% : سلامت',
            callBack = function()
                manageMenu(v)
        end})
    end
    exports['icon_menu']:OpenMenu(list)
end

function manageMenu(data)
    local list = {}
end

function spawnPet(v)
    --ESX.TriggerServerCallback('pet:spawnPet',function(pet)
        ESX.TriggerServerEvent('suncore:whiteListPed')
        Wait(2000)
        local coords = GetEntityCoords(SUN.ped)
        local pet = ESX.Game.spawnPed(v.model,vector3(coords.x + 0.5, coords.y + 0.5, coords.z),28)
        Citizen.Wait(2000)
        local netId = NetworkGetNetworkIdFromEntity(pet)
        v.pet = pet
        v.netId = NetworkGetNetworkIdFromEntity(pet)
        v.follow = true
        ESX.TriggerServerEvent('pet:registerPet',netId,v.id)
        spawnedPets[v.id] = v
        if DoesEntityExist(pet) then
            Citizen.CreateThread(function()
                while DoesEntityExist(pet) and not IsPedDeadOrDying(pet) do
                    Wait(3000)
                    local distance = ESX.GetDistance(GetEntityCoords(pet),GetEntityCoords(SUN.ped))
                    if v.follow and distance > 5 and GetEntitySpeed(pet) < 1 and not v.sitting and not v.sleeping and not v.dead and not v.barking then                       
                        requestControlOfPet(pet)
                        followOwner(pet)
                        SetPedCanRagdoll(pet, false)
                        SetPedCanRagdollFromPlayerImpact(pet, false)
                    end
                end
            end)
            Citizen.CreateThread(function()
                while DoesEntityExist(pet) and not IsPedDeadOrDying(pet) do
                    -- if not NetworkHasControlOfEntity(pet) then
                    --     print('request control of pet')
                    --     NetworkRequestControlOfEntity(pet)
                    --     Wait(1000)
                    -- end
                    local coords = GetEntityCoords(pet)
                    if SUN.isPlayerInVehicle then
                        if (not IsPedInAnyVehicle(pet) or GetVehiclePedIsIn(pet) ~= SUN.vehiclePlayerIsIn) and not v.sitting and not v.sleeping and not v.dead and not v.barking and ESX.GetDistance(coords,SUN.PlayerCoords) < 6.0 then
                            local freeSeat = nil  
                            for i=-1,10 do
                                if IsVehicleSeatFree(SUN.vehiclePlayerIsIn, i) then
                                    freeSeat = i
                                    break
                                end
                            end
                            if freeSeat then
                                requestControlOfPet(pet)
                                SetPedIntoVehicle(pet, SUN.vehiclePlayerIsIn, freeSeat)
                               -- SetPedNeverLeavesGroup(pet, false)
                                if configPet[v.model].animList.sit then
                                    ESX.Streaming.RequestAnimDict(configPet[v.model].animList.sit[1])
                                    TaskPlayAnim(pet, configPet[v.model].animList.sit[1], configPet[v.model].animList.sit[2] ,8.0, -8, -1, 1, 0, false, false, false)
                                end
                            end
                        end
                    elseif IsPedInAnyVehicle(pet) then
                        local coords = GetEntityCoords(pet)
                        requestControlOfPet(pet)
                        SetEntityCoords(pet, vector3(coords.x+2,coords.y+2,coords.z))
                        --SetPedNeverLeavesGroup(pet, true)
                    end
                    if v.sitting and not IsEntityPlayingAnim(pet,configPet[v.model].animList.sit[1],configPet[v.model].animList.sit[2],3) then
                        --requestControlOfPet(pet)
                        TaskPlayAnim(pet,configPet[v.model].animList.sit[1], configPet[v.model].animList.sit[2] ,8.0, -8, -1, 1, 0, false, false, false)
                    elseif v.sleeping and not IsEntityPlayingAnim(pet,configPet[v.model].animList.sleep[1],configPet[v.model].animList.sleep[2],3) then
                        --requestControlOfPet(pet)
                        TaskPlayAnim(pet,configPet[v.model].animList.sleep[1], configPet[v.model].animList.sleep[2] ,8.0, -8, -1, 1, 0, false, false, false)
                    elseif v.dead and not IsEntityPlayingAnim(pet,configPet[v.model].animList.dead[1],configPet[v.model].animList.dead[2],3) then
                        --requestControlOfPet(pet)
                        TaskPlayAnim(pet,configPet[v.model].animList.dead[1], configPet[v.model].animList.dead[2] ,8.0, -8, -1, 1, 0, false, false, false)
                    elseif v.barking and not IsEntityPlayingAnim(pet,configPet[v.model].animList.bark[1],configPet[v.model].animList.bark[2],3) then
                        --requestControlOfPet(pet)
                        TaskPlayAnim(pet,configPet[v.model].animList.bark[1], configPet[v.model].animList.bark[2] ,8.0, -8, -1, 1, 0, false, false, false)
                    end
                    if IsPedShooting(SUN.ped) then
                        if SUN.CurrentWeaponModel == ball then
                            ESX.TriggerServerEvent('pet:removeBall')
                            local ballEntity = GetClosestObjectOfType(coords, 200.0, ballModel)
                            --SetPedNeverLeavesGroup(ped, false)
                            v.sitting = false
                            v.sleeping = false
                            v.barking = false
                            v.dead = false
                            v.follow = false
                            ClearPedTasks(pet)
                            Wait(4000)
                            --TaskGoToCoordAnyMeans(pet, GetEntityCoords(ballEntity), 5.0, 0, 0, 786603, 0xbf800000)
                            TaskGoToEntity(pet, ballEntity, -1, 1.0, 10.0, 1073741824.0, 0)
                            Wait(1000)
                            CreateThread(function()
                                while true do
                                    Wait(500)
                                    if DoesEntityExist(ballEntity) then
                                        local distance = ESX.GetDistance(GetEntityCoords(pet),GetEntityCoords(ballEntity))
                                        if distance < 1.5 then
                                            local boneIndex = GetPedBoneIndex(pet, 17188)
                                            requestControlOfPet(pet)
                                            AttachEntityToEntity(ballEntity, pet, boneIndex, 0.120, 0.010, 0.010, 5.0, 150.0, 0.0, true, true, false, true, 1, true)
                                            --TaskGoToCoordAnyMeans(pet, GetEntityCoords(SUN.ped), 5.0, 0, 0, 786603, 0xbf800000)
                                            TaskGoToEntity(pet, SUN.ped, -1, 1.0, 10.0, 1073741824.0, 0)
                                            --SetPedNeverLeavesGroup(ped, true)
                                            SetTimeout(20000, function()
                                                v.follow = true
                                            end)
                                            break
                                        end
                                    else
                                        break
                                    end
                                end
                                while true do
                                    local distance = ESX.GetDistance(GetEntityCoords(pet),GetEntityCoords(SUN.ped))
                                    if distance < 1.5 then
                                        ESX.Game.DeleteEntity(ballEntity)
                                        ESX.TriggerServerEvent('pet:backBall')
                                        v.follow = true
                                        break
                                    end
                                    Wait(500)
                                end
                            end)
                        end
                    end
                    Citizen.Wait(0)
                end
                for k, v in ipairs(availblePet) do
                    if v.netId == netId then
                        table.remove(availblePet,k)
                        break
                    end
                end
                print('delete',netId)
                ESX.TriggerServerEvent('pet:deletePet',netId)
                if v.temporary then
                    temporarySpawned = false
                end
            end)
            if v.temporary then
                if ESX.PlayerData.job.name == 'ambulance' then
                    local temporaryBlips = {}
                    CreateThread(function()
                        while DoesEntityExist(pet) and not IsPedDeadOrDying(pet) do
                            local players = ESX.Game.GetPlayersInArea(SUN.PlayerCoords, 125)
                            for k, v in pairs(players) do
                                local id = GetPlayerServerId(v)
                                if ESX.GetPlayerState(id, 'isInjure') then
                                    if not temporaryBlips[id] or not DoesBlipExist(temporaryBlips[id].blip) then
                                        local ped = GetPlayerPed(v)
                                        local blip = AddBlipForEntity(ped)
                                        SetBlipSprite(blip, 480)
                                        SetBlipDisplay(blip, 6)
                                        SetBlipScale(blip, 0.9)
                                        SetBlipColour(blip, 5)
                                        SetBlipAsShortRange(blip, true)
                                        BeginTextCommandSetBlipName('STRING')
                                        AddTextComponentString('Injure')
                                        EndTextCommandSetBlipName(blip)
                                        temporaryBlips[id] = {blip = blip, check = true}
                                    else
                                        temporaryBlips[id].check = true
                                    end
                                elseif temporaryBlips[id] then
                                    RemoveBlip(temporaryBlips[id].blip)
                                    temporaryBlips[id] = nil
                                end
                            end
                            for k, v in pairs(temporaryBlips) do
                                if DoesBlipExist(v.blip) and not v.check then
                                    RemoveBlip(v.blip)
                                    temporaryBlips[k] = nil
                                else
                                    v.check = false
                                end
                            end
                            Wait(10000)
                        end
                        for k, v in pairs(temporaryBlips) do
                            RemoveBlip(v.blip)
                        end
                        temporaryBlips = {}
                    end)
                end
            end
            Citizen.Wait(2000)
            -- if not group then
            --     group = GetPedGroupIndex(SUN.ped)
            -- end
            requestControlOfPet(pet)
            SetEntityAsMissionEntity(pet, true, true)
            SetPedFleeAttributes(pet, 0, 0)
            SetPedCanRagdoll(pet, false)
            SetPedCanRagdollFromPlayerImpact(pet, false)
            -- SetGroupFormationSpacing(group, 0.5,0.5,0.5)
            --SetGroupSeparationRange(group, 1.0)
            -- SetPedAsGroupLeader(PlayerPedId(), group)
            -- SetPedAsGroupMember(PlayerPedId(), group)
            -- SetPedAsGroupMember(pet, group)
            -- SetPedNeverLeavesGroup(pet, true)
            SetPedCanBeTargetted(pet, false)

            if not v.temporary then
                v.blip = AddBlipForEntity(pet)
                SetBlipSprite(v.blip, 442)
                ShowHeadingIndicatorOnBlip(v.blip, true) 
                SetBlipNameToPlayerName(v.blip, id)
                SetBlipScale(v.blip, 0.65)
                SetBlipColour(v.blip, 57)
                SetBlipAsShortRange(v.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Pet')
                EndTextCommandSetBlipName(v.blip)
            end

            SetBlockingOfNonTemporaryEvents(pet, true)
            followOwner(pet)
            SetEntityInvincible(pet, true)
            local options = {}
            if configPet[v.model].animList.sit then
                table.insert(options,{
                    label = function()
                        return not v.sitting and '⬇️بشین' or '⬆️پاشو'
                    end,
                    onSelect = function(_)
                        if v.sitting then
                            exports['sun-animmenu']:PlayEmote('point')
                            v.sitting = false
                            Wait(1000)
                            ClearPedTasks(pet)
                            ClearPedTasks(SUN.ped)
                        else
                            v.sleeping = false
                            v.barking = false
                            v.dead = false
                            exports['sun-animmenu']:PlayEmote('pointdown')
                            Wait(1000)
                            ESX.Streaming.RequestAnimDict(configPet[v.model].animList.sit[1])
                            TaskPlayAnim(pet, configPet[v.model].animList.sit[1], configPet[v.model].animList.sit[2] ,8.0, -8, -1, 1, 0, false, false, false)
                            v.sitting = true
                        end
                    end,
                })
            end

            if configPet[v.model].animList.list then
                local list = configPet[v.model].animList.list
                for k2, v2 in pairs(list) do
                    table.insert(options,{
                        label = v2.label,
                        onSelect = function(_)
                            if v2.type == 'scenario' then
                                TaskStartScenarioInPlace(pet, v2.anim, 0, true)
                            elseif v2.type == 'anim' then
                                ESX.Streaming.RequestAnimDict(v2.anim)
                                TaskPlayAnim(pet, v2.anim, v2.anim2,8.0, -8, -1, 1, 0, false, false, false)
                            end
                        end,
                    })
                end
            end
            if configPet[v.model].animList.sleep then
                table.insert(options,{
                    label = function()
                        return not v.sleeping and '😴بخواب' or '⬆️پاشو'
                    end,
                    onSelect = function(_)
                        if v.sleeping then
                            exports['sun-animmenu']:PlayEmote('point')
                            v.sleeping = false
                            Wait(1000)
                            ClearPedTasks(pet)
                            ClearPedTasks(SUN.ped)
                        else
                            v.sitting = false
                            v.barking = false
                            v.dead = false
                            exports['sun-animmenu']:PlayEmote('pointdown')
                            Wait(1000)
                            ESX.Streaming.RequestAnimDict(configPet[v.model].animList.sleep[1])
                            TaskPlayAnim(pet, configPet[v.model].animList.sleep[1], configPet[v.model].animList.sleep[2] ,8.0, -8, -1, 1, 0, false, false, false)
                            v.sleeping = true
                        end
                    end,
                })
                table.insert(options,{
                    label = 'لغو انیمیشن',
                    onSelect = function(_)
                        ClearPedTasks(pet)
                    end,
                })
            end
            spawnedPets[v.id].bark = function(_)
                if v.barking then
                    exports['sun-animmenu']:PlayEmote('point')
                    v.barking = false
                    Wait(1000)
                    ClearPedTasks(pet)
                    ClearPedTasks(SUN.ped)
                else
                    v.sitting = false
                    v.sleeping = false
                    v.dead = false
                    exports['sun-animmenu']:PlayEmote('pointdown')
                    Wait(1000)
                    local anim = nil
                    if type(configPet[v.model].animList.bark[1]) == 'string' then 
                        anim = configPet[v.model].animList.bark 
                    else
                        anim = configPet[v.model].animList.bark[math.random(1,#configPet[v.model].animList.bark)]
                    end
                    ESX.Streaming.RequestAnimDict(anim[1])
                    TaskPlayAnim(pet, anim[1], anim[2] ,8.0, -8, -1, 1, 0, false, false, false)
                    v.barking = true
                end
            end

            if configPet[v.model].animList.bark then
                table.insert(options,{
                    label = function()
                        return not v.barking and '🔊' or '🔇'
                    end,
                    onSelect = spawnedPets[v.id].bark,
                })
            end

            if configPet[v.model].animList.dead then
                table.insert(options,{
                    label = function()
                        return not v.dead and '💀خودتو به مردن بزن' or '⬆️پاشو'
                    end,
                    onSelect = function(_)
                        if v.dead then
                            exports['sun-animmenu']:PlayEmote('point')
                            v.dead = false
                            Wait(1000)
                            ClearPedTasks(pet)
                            ClearPedTasks(SUN.ped)
                        else
                            v.sitting = false
                            v.barking = false
                            v.sleeping = false
                            exports['sun-animmenu']:PlayEmote('pointdown')
                            Wait(1000)
                            local anim = nil
                            if type(configPet[v.model].animList.dead[1]) == 'string' then 
                                anim = configPet[v.model].animList.dead 
                            else
                                anim = configPet[v.model].animList.dead[math.random(1,#configPet[v.model].animList.dead)]
                            end
                            ESX.Streaming.RequestAnimDict(anim[1])
                            TaskPlayAnim(pet, anim[1], anim[2] ,8.0, -8, -1, 1, 0, false, false, false)
                            v.dead = true
                        end
                    end,
                })
            end

            table.insert(options,{
                label = '🏠برو خونه',
                onSelect = function()
                    v.sitting = false
                    v.sleeping = false
                    v.barking = false
                    v.dead = false
                    ClearPedTasks(pet)
                    Wait(1000)
                    local coords = GetEntityCoords(pet)
                    -- SetPedNeverLeavesGroup(pet, false)
                    --TaskGoToCoordAnyMeans(pet, coords.x + 60, coords.y, coords.z, 5.0, 0, 0, 786603, 0xbf800000)
                    TaskGoStraightToCoord(pet, coords.x + 60, coords.y, coords.z, 10.0, 5000, 250)
                    Citizen.Wait(10000)
                    ESX.Game.DeleteEntity(pet)
                end,
            })
            table.insert(options,{
                label = function()
                    return (GetEntityHealth(pet) - 100) .. '% : 💊سلامت'
                end,
                onSelect = function(_)
                end,
            })
            exports['ox_target']:addLocalEntity({pet}, options)
            table.insert(availblePet,v)
        end
        inProgress = false
    --end,v.id)
end

AddEventHandler('onPlayEmote',function(name)
    if name == 'whistle' then
        local switchNear = true
        for k, v in pairs(availblePet) do
            if v.sitting or v.sleeping or v.barking or v.dead then
                switchNear = false
                v.sleeping = false
                v.sitting = false
                v.barking = false
                v.dead = false
                --exports['sun-animmenu']:PlayEmote('point')
                Wait(1000)
                ClearPedTasks(v.pet)
            end
        end
        -- if switchNear then
        --     near = not near
        --     local float = near and 0.5 or 3.0
        --     SetGroupFormationSpacing(group, float, float, float)
        -- end
    end
end)

exports('openPetMenu',openPetMenu)

function requestControlOfPet(pet)
    while not NetworkHasControlOfEntity(pet) do
        NetworkRequestControlOfEntity(pet)
        if not DoesEntityExist(pet) then
            break
        end
        Wait(100)
    end
end

function followOwner(pet)
    TaskGoToEntity(pet, SUN.ped, -1, 1.0, 10.0, 1073741824.0, 0)
    -- SetPedKeepTask(pet, true)
    --TaskFollowToOffsetOfEntity(pet, SUN.ped, 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
    --SetPedKeepTask(pet, true)
end

function getPetsData(target)
    local data = {}
    local _ownedPets = ownedPets
    if target then
        local p = promise.new()
        ESX.TriggerServerCallback('pet:getPets', function(pets)
            p:resolve(pets)
        end, target)
        _ownedPets = Citizen.Await(p)
    end
    for k, v in pairs(configPet) do
        local doesHave = false
        for k2, v2 in pairs(_ownedPets) do
            if k == v2.model then
                doesHave = true
                break
            end
        end
        table.insert(data, {model = k, owned = doesHave, label = v.label, img = ('nui://sun-ui/ui/skill/img/pets/%s.png'):format(k)})
    end
    return data
end

function spawnTemporaryPet(model)
    if not temporarySpawned then
        if not ESX.doesHaveJobPerm('spawnPet') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
        temporarySpawned = true
        local data = {
            model = model,
            id = -1,
            temporary = true,
        }
        spawnPet(data)
    end
end

exports('spawnTemporaryPet', spawnTemporaryPet)

exports('doesHaveTempPet', function()
    return temporarySpawned
end)

exports('checkPlayerForDrug', function(ped)
    local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
    if id then
        ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
            local haveAnything
            for k, v in pairs(data.inventory) do
                if configPetItemCheck[v.name] and v.count > 0 and v.count >= configPetItemCheck[v.name] then
                    haveAnything = true
                    break
                end
            end
            if haveAnything then
                Wait(1000)
                if spawnedPets[-1] then
                    ESX.entityFaceEntity(spawnedPets[-1].pet, ped)
                    spawnedPets[-1].bark()
                    Wait(15000)
                    spawnedPets[-1].bark()
                end
            end
        end, id)
    end
end)