----------------------------------------
------------ DRUG CONVOY EVENT ----------
----------------------------------------
-- See server/convoy.lua for the full design note. This file only ever touches entities that
-- exist for EVERY client the same way (networked, resolved from a netId broadcast by the
-- server) -- never spawns anything purely local, since this needs to be fair PvP for whoever
-- shows up, not a per-client illusion.

local activeConvoy = nil -- {id, route, blip, netVeh, netDriver, netGuards, stopped}
local spawnerWatch = {}  -- convoyId -> true while this client's own driver-down watcher thread should keep running

local function netIdToEntity(netId, timeoutMs)
    local start = GetGameTimer()
    while not NetworkDoesEntityExistWithNetworkId(netId) do
        Citizen.Wait(50)
        if GetGameTimer() - start > (timeoutMs or 10000) then return nil end
    end
    return NetworkGetEntityFromNetworkId(netId)
end

local function loadModel(hash)
    RequestModel(hash)
    local attempts = 0
    while not HasModelLoaded(hash) and attempts < 200 do
        Citizen.Wait(10)
        attempts = attempts + 1
    end
    return HasModelLoaded(hash)
end

-- The one client the server picked spawns the actual networked vehicle/peds and drives the
-- route, then reports the network IDs back so the server can broadcast them to everyone else.
RegisterNetEvent('esx_drugs:convoy:becomeSpawner')
AddEventHandler('esx_drugs:convoy:becomeSpawner', function(convoyId, route)
    local cfg = Config.Convoy
    local fromCoords, toCoords = route.from.coords, route.to.coords

    local vehModel = GetHashKey(cfg.VehicleModel)
    if not loadModel(vehModel) then
        print('[esx_drugs] Convoy: vehicle model never loaded, aborting spawn.')
        return
    end

    local veh = CreateVehicle(vehModel, fromCoords.x, fromCoords.y, fromCoords.z, 0.0, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleEngineOn(veh, true, true, false)
    SetModelAsNoLongerNeeded(vehModel)

    local driverModel = GetHashKey(cfg.DriverModel)
    loadModel(driverModel)
    local driver = CreatePedInsideVehicle(veh, 4, driverModel, -1, true, true)
    SetEntityAsMissionEntity(driver, true, true)
    SetBlockingOfNonTemporaryEvents(driver, true)
    SetPedFleeAttributes(driver, 0, false)
    SetDriverAbility(driver, 1.0)
    SetDriverAggressiveness(driver, 0.0)
    SetModelAsNoLongerNeeded(driverModel)

    local guardModel = GetHashKey(cfg.GuardModel)
    loadModel(guardModel)

    local guardGroup = AddRelationshipGroup('esx_drugs_convoy')
    SetRelationshipBetweenGroups(5, guardGroup, GetHashKey('PLAYER')) -- 5 = hate, both directions
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), guardGroup)

    local guards = {}
    for i = 1, cfg.GuardCount do
        local guard = CreatePedInsideVehicle(veh, 4, guardModel, i - 1, true, true)
        SetEntityAsMissionEntity(guard, true, true)
        SetPedRelationshipGroupHash(guard, guardGroup)
        GiveWeaponToPed(guard, GetHashKey(cfg.GuardWeapon), 999, false, true)
        SetPedAccuracy(guard, cfg.GuardAccuracy)
        SetPedCombatAbility(guard, 2)
        SetPedCombatMovement(guard, 2)
        SetPedCombatRange(guard, 2)
        SetPedCombatAttributes(guard, 46, true)
        SetEntityMaxHealth(guard, cfg.GuardHealth)
        SetEntityHealth(guard, cfg.GuardHealth)
        SetBlockingOfNonTemporaryEvents(guard, true)
        table.insert(guards, guard)
    end
    SetModelAsNoLongerNeeded(guardModel)

    TaskVehicleDriveToCoordLongrange(driver, veh, toCoords.x, toCoords.y, toCoords.z, cfg.Speed, 786603, 5.0)

    local netVeh, netDriver, netGuards = NetworkGetNetworkIdFromEntity(veh), NetworkGetNetworkIdFromEntity(driver), {}
    for _, g in ipairs(guards) do
        table.insert(netGuards, NetworkGetNetworkIdFromEntity(g))
    end

    TriggerServerEvent('esx_drugs:convoy:registerEntities', convoyId, netVeh, netDriver, netGuards)

    -- Only the spawner watches for "has this convoy been stopped" -- everyone else just reacts
    -- to the server's broadcast -- so only one client is ever reporting it.
    spawnerWatch[convoyId] = true
    Citizen.CreateThread(function()
        while spawnerWatch[convoyId] do
            Citizen.Wait(500)
            if not DoesEntityExist(veh) or not DoesEntityExist(driver)
                or IsEntityDead(driver) or IsPedDeadOrDying(driver, true)
                or GetVehicleEngineHealth(veh) < 100.0 then
                spawnerWatch[convoyId] = false
                TriggerServerEvent('esx_drugs:convoy:driverDown', convoyId)
            end
        end
    end)
end)

-- Every client (spawner included) gets this once the server has real network IDs to share --
-- sets up the blip and arms the guards to fight back once someone actually attacks the convoy.
RegisterNetEvent('esx_drugs:convoy:announce')
AddEventHandler('esx_drugs:convoy:announce', function(convoyId, route, netVeh, netDriver, netGuards)
    activeConvoy = { id = convoyId, route = route, netVeh = netVeh, netDriver = netDriver, netGuards = netGuards, stopped = false }
    ESX.ShowNotification(_U('convoy_incoming'))

    Citizen.CreateThread(function()
        local veh = netIdToEntity(netVeh, 15000)
        if not veh or not (activeConvoy and activeConvoy.id == convoyId) then return end

        local blip = AddBlipForEntity(veh)
        SetBlipSprite(blip, Config.Convoy.BlipSprite)
        SetBlipColour(blip, Config.Convoy.BlipColor)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Convoy Mavad')
        EndTextCommandSetBlipName(blip)
        activeConvoy.blip = blip

        local guardPeds = {}
        for _, netId in ipairs(netGuards) do
            local ped = netIdToEntity(netId, 15000)
            if ped then table.insert(guardPeds, ped) end
        end

        local guardsDeployed = false
        while activeConvoy and activeConvoy.id == convoyId do
            Citizen.Wait(750)

            if not guardsDeployed and DoesEntityExist(veh) and HasEntityBeenDamagedByAnyPed(veh) then
                guardsDeployed = true
                for _, guard in ipairs(guardPeds) do
                    if DoesEntityExist(guard) and not IsEntityDead(guard) then
                        TaskLeaveVehicle(guard, veh, 0)
                        Citizen.SetTimeout(1500, function()
                            if DoesEntityExist(guard) and not IsEntityDead(guard) then
                                TaskCombatHatedTargetsAroundPed(guard, 100.0, 0)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('esx_drugs:convoy:stopped')
AddEventHandler('esx_drugs:convoy:stopped', function(convoyId)
    if not activeConvoy or activeConvoy.id ~= convoyId then return end
    activeConvoy.stopped = true

    ESX.ShowNotification(_U('convoy_stopped_notify'))

    if activeConvoy.blip and DoesBlipExist(activeConvoy.blip) then
        SetBlipColour(activeConvoy.blip, 1)
        SetBlipFlashes(activeConvoy.blip, true)
    end

    Citizen.CreateThread(function()
        local veh = netIdToEntity(activeConvoy.netVeh, 10000)
        if not veh or not (activeConvoy and activeConvoy.id == convoyId) then return end

        local ok, err = pcall(function()
            exports.ox_target:addLocalEntity(veh, {
                {
                    name = 'esx_drugs:convoy:loot_' .. convoyId,
                    icon = 'fa-solid fa-box-open',
                    label = _U('convoy_loot_prompt'),
                    distance = 3.0,
                    onSelect = function()
                        TriggerServerEvent('esx_drugs:convoy:loot', convoyId)
                    end,
                },
            })
        end)

        if not ok then
            print(('[esx_drugs] Convoy: ox_target addLocalEntity failed (is ox_target running?): %s'):format(tostring(err)))
        end
    end)
end)

RegisterNetEvent('esx_drugs:convoy:cleanup')
AddEventHandler('esx_drugs:convoy:cleanup', function(convoyId)
    if not activeConvoy or activeConvoy.id ~= convoyId then return end

    spawnerWatch[convoyId] = false

    if activeConvoy.blip and DoesBlipExist(activeConvoy.blip) then
        RemoveBlip(activeConvoy.blip)
    end

    if NetworkDoesEntityExistWithNetworkId(activeConvoy.netVeh) then
        local veh = NetworkGetEntityFromNetworkId(activeConvoy.netVeh)
        if DoesEntityExist(veh) then
            pcall(function() exports.ox_target:removeLocalEntity(veh, 'esx_drugs:convoy:loot_' .. convoyId) end)
            if NetworkHasControlOfEntity(veh) then SetEntityAsNoLongerNeeded(veh) end
        end
    end

    local watchLists = { activeConvoy.netDriver and { activeConvoy.netDriver } or {}, activeConvoy.netGuards or {} }
    for _, list in ipairs(watchLists) do
        for _, netId in ipairs(list) do
            if NetworkDoesEntityExistWithNetworkId(netId) then
                local ent = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(ent) and NetworkHasControlOfEntity(ent) then
                    SetEntityAsNoLongerNeeded(ent)
                end
            end
        end
    end

    activeConvoy = nil
end)
