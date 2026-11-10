-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local soghraList = {}
local carring = false
local blips = {}
RegisterNetEvent('soghra:pedThread', function(ped)
    if ESX.doesNetIdExist(ped) then
        local ped = NetworkGetEntityFromNetworkId(ped)
        Wait(1000)
        CreateThread(function()
            while DoesEntityExist(ped) do
                if Entity(ped).state.surrender and not IsEntityPlayingAnim(ped, 'random@arrests@busted', 'idle_a', 3) then
                    ESX.Game.RequestControl(ped)
                    SetEntityAsMissionEntity(ped)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    ESX.Streaming.RequestAnimDict('random@arrests@busted', function()
                        TaskPlayAnim(ped, 'random@arrests@busted', 'idle_a',8.0, -8, -1, 1, 0, false, false, false)
                    end)
                end
                Wait(500)
            end
        end)
    end
end)

RegisterNetEvent('soghra:mainThread', function(ped, id)
    if ESX.doesNetIdExist(ped) then
        local ped = NetworkGetEntityFromNetworkId(ped)
        CreateThread(function()
            while DoesEntityExist(ped) do
                ESX.Game.Utils.DrawText3D(GetEntityCoords(ped), '~g~Hostage', 0.7)
                Wait(0)
            end
        end)
        soghraList[id] = {ped = ped, model = GetEntityModel(ped)}
        local options = {}
        table.insert(options,{
            label = function()
                return not soghraList[id].carried and '🔫' or 'ول کردن'
            end,
            onSelect = function(_)
                if soghraList[id].carried then

                else
                    if not Entity(ped).state.carried and not carring then
                        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(ped), 'carried', true)
                        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(ped), 'surrender', false)
                        Wait(1000)
                        ESX.Game.RequestControl(ped)
                        ClearPedTasksImmediately(ped)
                        ESX.Streaming.RequestAnimDict('anim@gangops@hostage@')
                        soghraList[id].carried = true
                        carring = true
                        AttachEntityToEntity(ped, SUN.ped, 0, -0.24, 0.11, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                        CreateThread(function()
                            while soghraList[id].carried and DoesEntityExist(ped) and GetEntityAttachedTo(ped) == SUN.ped do
                                Wait(0)
                                DisableControlAction(0, 24) -- disable attack
                                DisableControlAction(0, 25) -- disable aim
                                DisableControlAction(0, 47) -- disable weapon
                                DisableControlAction(0, 58) -- disable weapon
                                DisableControlAction(0, 21) -- disable sprint
                                DisablePlayerFiring(SUN.ped, true)
                                if not IsEntityPlayingAnim(SUN.ped, 'anim@gangops@hostage@', 'perp_idle', 3) then
                                    TaskPlayAnim(SUN.ped, 'anim@gangops@hostage@', 'perp_idle', 8.0, -8.0, 100000, 49, 0, false, false, false)
                                end
                                if not IsEntityPlayingAnim(ped, 'anim@gangops@hostage@', 'victim_idle', 3) then
                                    TaskPlayAnim(ped, 'anim@gangops@hostage@', 'victim_idle', 8.0, -8.0, 100000, 49, 0, false, false, false)
                                end
                                ESX.Game.Utils.DrawText2D('[X] ~o~Vel Kardan', 0.5, 0.9, 0.4)
                                if SUN.isPlayerInVehicle then
                                    TaskLeaveVehicle(SUN.ped, GetVehiclePedIsIn(SUN.ped), 16)
                                end
                            end
                            soghraList[id].carried = nil
                            carring = false
                            ClearPedTasksImmediately(SUN.ped)
                        end)
                    end
                end
            end,
        })
        exports['ox_target']:addLocalEntity({ped}, options)
    end
end)

AddEventHandler('KeyDown:x', function()
    for k, v in pairs(soghraList) do
        if v.carried then
            v.carried = false
            carring = false
            Wait(500)
            ESX.Game.RequestControl(v.ped)
            DetachEntity(v.ped, true, false)
            ClearPedTasksImmediately(SUN.ped)
            ClearPedTasksImmediately(v.ped)
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'carried', false)
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'surrender', true)
        end
    end
end)

exports('doesCarrySoghra', function()
    return carring
end)

function putSoghraInVehicle(vehicle)
    if ESX.doesVehicleHaveDriver(vehicle) then
        return ESX.Alert('', 'In mashin ranande darad', 7000, 'warning')
    end
    for k, v in pairs(soghraList) do
        if v.carried then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            local free = true
            for i = maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                else
                    free = false
                end
            end
            if freeSeat ~= nil and GetVehicleDoorLockStatus(vehicle) ~= 2 then
                if free then
                    v.carried = false
                    carring = false
                    Wait(500)
                    ESX.Game.RequestControl(v.ped)
                    ESX.Game.RequestControl(vehicle)
                    DetachEntity(v.ped, true, false)
                    ClearPedTasksImmediately(SUN.ped)
                    ClearPedTasksImmediately(v.ped)
                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'carried', false)
                    ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'surrender', false)
                    TaskWarpPedIntoVehicle(v.ped, vehicle, freeSeat)
                    ESX.TriggerServerEvent('soghra:hackNotif', Entity(v.ped).state.soghraId)
                else
                    ESX.Alert('', 'Mashin bayad bedun sarneshin bashad', 7000, 'warning')
                end
            else
                ESX.Alert('', 'Mashin sandali khali nadarad', 7000, 'warning')
            end
        end
    end
end
exports('putSoghraInVehicle', putSoghraInVehicle)

RegisterNetEvent('soghra:updateBlips', function(list)
    for k, v in pairs(blips) do
        if not list[k] then
            RemoveBlip(v)
            list[k] = nil
        end
    end
    for k, v in pairs(list) do
        if type(v) ~= 'boolean' then
            if blips[k] then
                RemoveBlip(blips[k])
            end
            blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, 1)
            SetBlipDisplay(blip, 6)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 61)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(tostring(v.id))
            EndTextCommandSetBlipName(blip)
            blips[k] = blip
        end
    end
end)

RegisterCommand('takehostage', function(src)
    if ESX.militaryJobs2[ESX.PlayerData.job.name] then
        local find = false
        for k, ped in pairs(ESX.Game.getPeds()) do
            if Entity(ped).state.hostage and #(SUN.PlayerCoords - GetEntityCoords(ped)) < 5 then
                exports['sunset_utils']:me('Eghdam be azad sazi gerogan mikone', true)
                find = true
                TriggerEvent('mythic_progbar:client:progress', {
                    name = 'freeFreePalestine',
                    duration = 10000,
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
                    if not status and #(SUN.PlayerCoords - GetEntityCoords(ped)) < 5 then
                        ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(ped), 'surrender', nil)
                        Wait(2000)
                        ESX.TriggerServerEvent('soghra:removeHostage', NetworkGetNetworkIdFromEntity(ped))
                        Wait(2000)
                        ESX.Game.RequestControl(ped)
                        ClearPedTasksImmediately(ped)
                        SetBlockingOfNonTemporaryEvents(ped, false)
                        FreezeEntityPosition(ped, false)
                        SetEntityInvincible(ped, false)
                    end
                end)
                break
            end
        end
        if not find then
            ESX.chatMessage('Gerogani jahat azad kardan peyda nashod!', 'plarms')
        end
    end
end)

local cmdCD = false
RegisterCommand('hack', function(src)
    if cmdCD then return end
    cmdCD = true
    SetTimeout(5000, function()
        cmdCD = false
    end)
    if SUN.isPlayerInVehicle then
        local soghraId = nil
        if not SUN.PlayerIsDriver then
            if GetEntitySpeed(SUN.vehiclePlayerIsIn) * 3.6 >= 24 then
                local maxSeats = GetVehicleMaxNumberOfPassengers(SUN.vehiclePlayerIsIn)
                local freeSeat = nil
                for i = maxSeats - 1, 0, -1 do
                    if not IsVehicleSeatFree(SUN.vehiclePlayerIsIn, i) then
                        local ped = GetPedInVehicleSeat(SUN.vehiclePlayerIsIn, i)
                        if Entity(ped).state.soghraId then
                            soghraId = Entity(ped).state.soghraId
                            break
                        end
                    end
                end
                if soghraId then
                    ESX.TriggerServerCallback('soghra:get', function(data)
                        if data then
                            if data.hackLevel < data.hack.count then
                                if data.hackCooldown then
                                    ESX.chatMessage(('Baraye hack mojadad %s sanie sabr konid'):format(ESX.Math.Round(data.hackCooldown - GetServerOSTime())), 'plarms')
                                else
                                    ESX.TriggerServerEvent('soghra:endHack', soghraId, startHackingGame(40 + (data.hackLevel * 5), 30 - (data.hackLevel * 3)))
                                end
                            else
                                ESX.chatMessage('Hack in gerogan be payan reside', 'plarms')
                            end
                        else
                            ESX.chatMessage('Error', 'plarms')
                        end
                    end, soghraId)
                else
                    ESX.chatMessage('Hich gerogani dar in mashin nist', 'plarms')
                end
            else
                ESX.chatMessage('Mashin bayad dar hale harekat bashad', 'plarms')
            end
        else
            ESX.chatMessage('Ranande nemitavanad hack konad', 'plarms')
        end
    else
        ESX.chatMessage('Barye hack bayad dar mashin bashid', 'plarms')
    end
end)

function putOutSoghra(vehicle)
    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = nil
    local soghraId, ped
    for i = maxSeats - 1, 0, -1 do
        if not IsVehicleSeatFree(vehicle, i) then
            local _ped = GetPedInVehicleSeat(vehicle, i)
            if Entity(_ped).state.soghraId then
                soghraId = Entity(_ped).state.soghraId
                ped = _ped
                break
            end
        end
    end
    if soghraId then
        if IsVehicleSeatFree(vehicle, -1) then
            ESX.Game.RequestControl(vehicle)
            ESX.Game.RequestControl(ped)
            TaskLeaveVehicle(ped, vehicle, 16)
            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(ped), 'surrender', true)
        else
            ESX.chatMessage('In mashin ranande darad', 'plarms')
        end
    end
end
exports('putOutSoghra', putOutSoghra)

local endLocationBlips = {}
RegisterNetEvent('soghra:markLocation', function(data, location)
    if ESX.militaryJobs[ESX.PlayerData.job.name] then return end
    local coords = location.coords
    local blip = ESX.AddBlipForCoord(coords.xyz, 1.5, 197, 61, 'Gerogan')
    SetNewWaypoint(coords.x, coords.y)
    if soghraList[data.id] then
        createLocalPed(1, location.model or soghraConfig.defaultLocationModel, location.coords - vec(0, 0, 1, 0), function(ped)
            SetBlockingOfNonTemporaryEvents(ped, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            soghraList[data.id].koskesh = ped
            ESX.Game.SpawnLocalVehicle('pony', location.vehCoords.xyz, location.vehCoords.w, function(vehicle)
                soghraList[data.id].koskeshVeh = vehicle
                SetVehicleDoorsLocked(vehicle, 2)
            end)
        end)
        CreateThread(function()
            while soghraList[data.id] do
                Wait(0)
                DrawMarker(32, location.coords.xyz + vec(0, 0, 1.2), 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 0, 250, true, true, false, true)
                if #(SUN.PlayerCoords - location.coords.xyz) < 2 then
                    ESX.ShowHelpNotification('~INPUT_CONTEXT~ Jahat Tahvil dadan gerogan')
                    if IsControlJustReleased(1, 38) then
                        if carring then
                            for k, v in pairs(soghraList) do
                                if v.carried then
                                    TriggerEvent('mythic_progbar:client:progress', {
                                        name = 'freeFreePalestine',
                                        duration = 10000,
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
                                        if not status and #(SUN.PlayerCoords - GetEntityCoords(v.ped)) < 5 then
                                            carring = false
                                            v.carried = false
                                            Wait(500)
                                            ESX.Game.RequestControl(v.ped)
                                            DetachEntity(v.ped, true, false)
                                            ClearPedTasksImmediately(SUN.ped)
                                            ClearPedTasksImmediately(v.ped)
                                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'carried', false)
                                            ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(v.ped), 'surrender', true)
                                            ESX.TriggerServerEvent('soghra:giveReward', data.id)
                                        end
                                    end)
                                end
                            end
                        else
                            ESX.Alert('', 'Shoma bayad hostage ra take konid', 7000, 'warning')
                        end
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('soghra:end', function(id)
    if soghraList[id] then
        if soghraList[id].koskesh then
            local ped = ESX.Game.SpawnLocalPed(1, soghraList[id].model, GetEntityCoords(soghraList[id].koskesh), 10)
            local koskesh = soghraList[id].koskesh
            SetBlockingOfNonTemporaryEvents(ped)
            GiveWeaponToPed(koskesh, `WEAPON_PISTOL`, 10, false, true)
            FreezeEntityPosition(koskesh, false)
            ESX.Streaming.RequestAnimDict('anim@gangops@hostage@')
            AttachEntityToEntity(ped, koskesh, 0, -0.24, 0.11, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
            local data = ESX.CopyTable(soghraList[id])
            local animThread = true
            CreateThread(function()
                while DoesEntityExist(data.koskesh) and animThread do
                    if not IsEntityPlayingAnim(data.koskesh, 'anim@gangops@hostage@', 'perp_idle', 3) then
                        TaskPlayAnim(data.koskesh, 'anim@gangops@hostage@', 'perp_idle', 8.0, -8.0, 100000, 49, 0, false, false, false)
                    end
                    if not IsEntityPlayingAnim(ped, 'anim@gangops@hostage@', 'victim_idle', 3) then
                        TaskPlayAnim(ped, 'anim@gangops@hostage@', 'victim_idle', 8.0, -8.0, 100000, 49, 0, false, false, false)
                    end
                    SetCurrentPedWeapon(data.koskesh, `WEAPON_PISTOL`, true)
                    Wait(100)
                end
            end)
            local vehicle = soghraList[id].koskeshVeh
            -- TaskGoStraightToCoord(soghraList[id].koskesh, GetWorldPositionOfEntityBone(soghraList[id].koskeshVeh, GetEntityBoneIndexByName(soghraList[id].koskeshVeh, 'platelight')).xyz, 1.0, 1000, GetEntityHeading(soghraList[id].koskeshVeh))
            -- local coords    = GetEntityCoords(soghraList[id].koskeshVeh)
            -- local forward   = GetEntityForwardVector(soghraList[id].koskeshVeh)
            -- TaskGoStraightToCoord(soghraList[id].koskesh, table.unpack(coords - forward * 3.0), 0.1, 20000, GetEntityHeading(soghraList[id].koskeshVeh), 0.5)
            local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -4.0, 0.0)
            TaskGoStraightToCoord(koskesh, coords, 1.0, 20000, GetEntityHeading(vehicle), 0.5)
            while #(coords - GetEntityCoords(koskesh)) > 2.0 do Wait(2000) end
            DetachEntity(ped)
            animThread = false
            Wait(200)
            ClearPedTasksImmediately(ped)
            ClearPedTasksImmediately(koskesh)
            SetVehicleDoorsLocked(vehicle, 1)
            TaskOpenVehicleDoor(koskesh, vehicle, -1, 2, 10)
            Wait(4000)
            TaskGoStraightToCoord(koskesh, GetOffsetFromEntityInWorldCoords(koskesh, 2.0, 0.0, 0.0), 1.0, 20000, GetEntityHeading(ped) + 180.0, 0.5)
            Wait(2000)
            TaskEnterVehicle(ped, vehicle, 10000, 2, 1.0, 1, 0)
            Wait(1000)
            for i = 0, 5 do
                SetVehicleDoorShut(vehicle, i, false)
            end
            Wait(2000)
            TaskEnterVehicle(koskesh, vehicle, 10000, -1, 1.0, 1, 0)
            Wait(10000)
            SoundVehicleHornThisFrame(vehicle)
            TaskVehicleDriveToCoordLongrange(koskesh, vehicle, 0.0, 0.0, 0.0, GetVehicleModelMaxSpeed(GetEntityModel(vehicle)), 447, 2.0)
            SetTimeout(30000, function()
                DeleteEntity(koskesh)
                DeleteEntity(ped)
                DeleteEntity(vehicle)
            end)
        end
    end
    soghraList[id] = nil
end)