-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local vehicles = {}
local ropes = {}
local tempRope
local thread = false
CreateThread(function()
    waitForLoad()
    Wait(10000)
    ESX.TriggerServerCallback('rope:getRopes', function(data)
        ropes = data
        if not thread then
            ropeThread()
        end
    end)
end)
exports('addVehicleToRope', function(vehicle)
    if doesHaveRope(vehicle) then
        if not vehicles[1] then
            vehicles[1] = vehicle
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'ropeAttached', true)
            attachTempRope(vehicle, true)
            CreateThread(function()
                while vehicles[1] and not vehicles[2] do
                    Wait(100)
                    if not DoesEntityExist(vehicles[1]) or ESX.GetDistance(SUN.PlayerCoords, GetEntityCoords(vehicles[1])) > configRope.ropeLength+5 then
                        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicles[1]), 'ropeAttached', nil)
                        vehicles[1] = nil
                        deleteRope()
                        break
                    end
                end
            end)
        elseif not vehicles[2] and vehicle ~= vehicles[1] then
            vehicles[2] = vehicle
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'ropeAttached', true)
            deleteRope()
            ESX.TriggerServerEvent('rope:attach', NetworkGetNetworkIdFromEntity(vehicles[1]), NetworkGetNetworkIdFromEntity(vehicles[2]))
        end
    else
        ESX.Alert('', 'Yek tanab be in mashin vasl ast!', 'error', 7000)
    end
end)

exports('doesVehicleInRopeList', function(vehicle)
    return vehicles[1] == vehicle or vehicles[2] == vehicle or Entity(vehicle).state.ropeAttached
end)

function doesHaveRope(vehicle)
    return ESX.DoesHaveItem2('rope', 1) and not Entity(vehicle).state.ropeAttached
end

function getBoneFront(veh)
    local bones = {
        'attach_male',
        'neon_f',
        'overheat',
        'overheat2',
        'rope_attach_a',
        'rope_attach_b',
        'overheat',
        'engine',
        'bonnet',
        'bumper_f',
        'transmission_f',
        'chassis_dummy',
    }
    for i, bone in pairs(bones) do
        local pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, bone))
        if pos.x ~= 0.0 and pos.x ~= 0 and pos.x ~= nil and (pos.x > 20.0 or pos.x < -20 or pos.z > 20 or pos.z < -20) then
            return bone
        end
    end
    return 'chassis_dummy'
end

function getBoneRear(veh)
    local bones = {
        'attach_female',
        'neon_b',
        'tow_arm',
        'tow_mount_a',
        'tow_mount_b',
        'bumper_r',
        'exhaust',
        'boot',
        'petroltank',
        'chassis_dummy',
    }
    for i, bone in pairs(bones) do
        local pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, bone))
        if pos.x ~= 0.0 and pos.x ~= 0 and pos.x ~= nil and (pos.x > 20.0 or pos.x < -20 or pos.z > 20 or pos.z < -20) then
            return bone
        end
    end
    return 'chassis_dummy'
end

function attachTempRope(entity, front)
    playerPed = PlayerPedId()
    local bone = 'chassis'
    if front then
        bone = getBoneRear(entity)
    else
        bone = getBoneFront(entity)
    end

    local pos = GetEntityCoords(playerPed)
    if tempRope then
        deleteRope()
        Wait(300)
    end
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Citizen.Wait(50)
    end

    local bonePos = GetWorldPositionOfEntityBone(entity, GetEntityBoneIndexByName(entity, bone))
    if GetDistanceBetweenCoords(bonePos, pos, true) <= configRope.ropeLength * 1.5 then
        tempRope = AddRope(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, configRope.ropeLength * 0.2, 1, configRope.ropeLength * 0.75, 0.1, 10.0, true, false, true, 1.0, false)
        AttachEntitiesToRope(tempRope, playerPed, entity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, configRope.ropeLength - 2.0, true, true, 'IK_R_Hand', bone)
    end
end


function deleteRope()
    if tempRope then
        DeleteRope(tempRope)
        tempRope = nil
    end
end

RegisterNetEvent('rope:new', function(id, data)
    ropes[id] = data
    if not thread then
        ropeThread()
    end
end)

function ropeThread()
    if not thread then
        thread = true
        CreateThread(function()
            while thread do
                Wait(1000)
                if ESX.tableLength(ropes) > 0 then
                    for k, v in pairs(ropes) do
                        if NetworkDoesEntityExistWithNetworkId(v.gVeh1) and NetworkDoesEntityExistWithNetworkId(v.gVeh1) then
                            v.veh1 = NetworkGetEntityFromNetworkId(v.gVeh1)
                            v.veh2 = NetworkGetEntityFromNetworkId(v.gVeh2)
                            if DoesEntityExist(v.veh1) and DoesEntityExist(v.veh2) then
                                if SUN.vehiclePlayerIsIn == v.veh2 then
                                    TaskLeaveVehicle(PlayerPedId(), v.veh2, 16)
                                end
                                if not v.rope or not DoesRopeExist(v.rope) then
                                    local pos = GetEntityCoords(v.veh1)
                                    local bone1 = getBoneRear(v.veh1)
                                    local bone2 = getBoneFront(v.veh2)
                                    RopeLoadTextures()
                                    while not RopeAreTexturesLoaded() do
                                        Citizen.Wait(50)
                                    end
                                    local rope = AddRope(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, configRope.ropeLength * 0.3, 1, configRope.ropeLength, 0.1, 10.0, true, false, true, 1.0, false)
                                    AttachEntitiesToRope(rope, v.veh1, v.veh2, 0.0, 0.0, 0.1, 0.0, 0.0, 0.1, configRope.ropeLength, false, false, bone1, bone2)
                                    v.rope = rope
                                end
                                if v.src == SUN.src then
                                    NetworkRequestControlOfEntity(v.veh1)
                                    NetworkRequestControlOfEntity(v.veh2)
                                    SetEntityMaxSpeed(v.veh1, configRope.maxSpeed / 3.6)
                                    SetEntityMaxSpeed(v.veh2, GetEntitySpeed(v.veh1) + (IsControlPressed(0, 71) and 15.0 or 0.0))
                                end
                                SetVehicleBrake(v.veh2, false)
                                SetVehicleHandbrake(v.veh2, false)
                                SetVehicleDoorsLocked(v.veh2, 2)
                            elseif v.src == SUN.src then
                                ESX.TriggerServerEvent('rope:remove', k)
                            end
                        elseif v.src == SUN.src then
                            ESX.TriggerServerEvent('rope:remove', k)
                        end
                    end
                else
                    thread = false
                    break
                end
            end
        end)
    end
end

exports('removeVehicleRope', function(vehicle)
    if vehicles[1] == vehicle then
        vehicles[1] = nil
        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'ropeAttached', nil)
        deleteRope()
    end
    Wait(500)
    for k, v in pairs(ropes) do
        if v.veh1 == vehicle or v.veh2 == vehicle then
            ESX.TriggerServerEvent('rope:remove', k)
        end
    end
end)

RegisterNetEvent('rope:remove', function(id)
    if ropes[id] then
        if ropes[id].rope then
            DeleteRope(ropes[id].rope)
        end
        if ropes[id].src == SUN.src then
           vehicles = {}
        end
        if ropes[id].veh1 and DoesEntityExist(ropes[id].veh1) then
            SetEntityMaxSpeed(ropes[id].veh1, 9999.0)
            SetEntityMaxSpeed(ropes[id].veh2, 9999.0)
        end
        ropes[id] = nil
    end
end)