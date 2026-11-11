if GetConvarInt('ox_target:defaults', 1) ~= 1 then return end

local api = require 'client.api'
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetEntityBonePosition_2 = GetEntityBonePosition_2
local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus

local bones = {
    [0] = 'dside_f',
    [1] = 'pside_f',
    [2] = 'dside_r',
    [3] = 'pside_r'
}

---@param vehicle number
---@param door number
local function toggleDoor(vehicle, door)
    if GetVehicleDoorLockStatus(vehicle) ~= 2 then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
        else
            SetVehicleDoorOpen(vehicle, door, false, false)
        end
    end
end

---@param entity number
---@param coords vector3
---@param door number
---@param useOffset boolean?
---@return boolean?
local function canInteractWithDoor(entity, coords, door, useOffset)
    if not GetIsDoorValid(entity, door) or GetVehicleDoorLockStatus(entity) > 1 or IsVehicleDoorDamaged(entity, door) or cache.vehicle then return end

    if useOffset then return true end

    local boneName = bones[door]

    if not boneName then return false end

    local boneId = GetEntityBoneIndexByName(entity, 'door_' .. boneName)

    if boneId ~= -1 then
        return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or
            #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_' .. boneName))) < 0.72
    end
end

local function onSelectDoor(data, door)
    local entity = data.entity

    if NetworkGetEntityOwner(entity) == cache.playerId then
        return toggleDoor(entity, door)
    end

    TriggerServerEvent('ox_target:toggleEntityDoor', VehToNet(entity), door)
end

RegisterNetEvent('ox_target:toggleEntityDoor', function(netId, door)
    local entity = NetToVeh(netId)
    toggleDoor(entity, door)
end)

if GetConvarInt('ox_target:vehicleDoors', 0) == 1 then
api.addGlobalVehicle({
    {
        name = 'ox_target:driverF',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_front_driver_door'),
        bones = { 'door_dside_f', 'seat_dside_f' },
        distance = 2,
        canInteract = function(entity, distance, coords, name)
            return canInteractWithDoor(entity, coords, 0)
        end,
        onSelect = function(data)
            onSelectDoor(data, 0)
        end
    },
    {
        name = 'ox_target:passengerF',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_front_passenger_door'),
        bones = { 'door_pside_f', 'seat_pside_f' },
        distance = 2,
        canInteract = function(entity, distance, coords, name)
            return canInteractWithDoor(entity, coords, 1)
        end,
        onSelect = function(data)
            onSelectDoor(data, 1)
        end
    },
    {
        name = 'ox_target:driverR',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_rear_driver_door'),
        bones = { 'door_dside_r', 'seat_dside_r' },
        distance = 2,
        canInteract = function(entity, distance, coords)
            return canInteractWithDoor(entity, coords, 2)
        end,
        onSelect = function(data)
            onSelectDoor(data, 2)
        end
    },
    {
        name = 'ox_target:passengerR',
        icon = 'fa-solid fa-car-side',
        label = locale('toggle_rear_passenger_door'),
        bones = { 'door_pside_r', 'seat_pside_r' },
        distance = 2,
        canInteract = function(entity, distance, coords)
            return canInteractWithDoor(entity, coords, 3)
        end,
        onSelect = function(data)
            onSelectDoor(data, 3)
        end
    },
    {
        name = 'ox_target:bonnet',
        icon = 'fa-solid fa-car',
        label = locale('toggle_hood'),
        offset = vec3(0.5, 1, 0.5),
        distance = 2,
        canInteract = function(entity, distance, coords)
            return canInteractWithDoor(entity, coords, 4, true)
        end,
        onSelect = function(data)
            onSelectDoor(data, 4)
        end
    },
    {
        name = 'ox_target:trunk',
        icon = 'fa-solid fa-car-rear',
        label = locale('toggle_trunk'),
        offset = vec3(0.5, 0, 0.5),
        distance = 2,
        canInteract = function(entity, distance, coords, name)
            return canInteractWithDoor(entity, coords, 5, true)
        end,
        onSelect = function(data)
            onSelectDoor(data, 5)
        end
    }
})
end -- ox_target:vehicleDoors

-- ============================================================================
-- Unique default options (Persian). Every option that depends on a resource
-- which is not started is hidden / ignored safely - nothing errors.
-- ============================================================================
local utils = require 'client.utils'

local function started(resource)
    return GetResourceState(resource) == 'started'
end

---Calls an export, returns nothing (and never errors) if the resource/export is missing
local function callExport(resource, fn, ...)
    if not started(resource) then return end

    local args = table.pack(...)
    local ok, result = pcall(function()
        local e = exports[resource]
        return e[fn](e, table.unpack(args, 1, args.n))
    end)

    if ok then return result end
end

---The inventory resource
local function inventoryResource()
    if started('Unique_inventory') then return 'Unique_inventory' end
end

local function inventory(fn, ...)
    local resource = inventoryResource()

    if resource then return callExport(resource, fn, ...) end
end

local ESX

local function getPlayerData()
    if not ESX and started('essentialmode') then
        local ok, obj = pcall(function() return exports['essentialmode']:getSharedObject() end)
        if ok and type(obj) == 'table' then ESX = obj end
    end

    if ESX and ESX.GetPlayerData then
        local ok, data = pcall(ESX.GetPlayerData)
        if ok and type(data) == 'table' then return data end
    end

    return {}
end

local function jobName()
    local job = getPlayerData().job

    return job and job.name or ''
end

local function playerState(id, key)
    local ok, value = pcall(function() return Player(id).state[key] end)

    return ok and value or nil
end

---@return number? serverId
local function serverIdFromPed(ped)
    local index = NetworkGetPlayerIndexFromPed(ped)

    if index == -1 then return nil end

    return GetPlayerServerId(index)
end

local function notifyError(text)
    lib.notify({ description = text, type = 'error' })
end

local function me(text, state)
    callExport('Unique_utils', 'me', text, state)
end

local jobCanSearchBag = {
    police = true,
    sheriff = true,
    mt = true,
    fbi = true,
    detective = true,
    justice = true,
}

local militaryJobs = jobCanSearchBag

local jobPet = {
    detective = 'a_c_husky_k9',
    fbi = 'a_c_husky_k9',
    mt = 'a_c_shepherd',
    police = 'a_c_husky_k9',
    sheriff = 'a_c_husky_k9',
    ambulance = 'a_c_husky_ems',
}

-- Player: sub menus "info" / "trade" -----------------------------------------

---@type table<string, fun(ped: number): boolean>
local infoChildren = {
    idCard = function(ped)
        return serverIdFromPed(ped) ~= nil
    end,
    honors = function(ped)
        local id = serverIdFromPed(ped)

        return id ~= nil and started('Unique_utils') and not Entity(ped).state.inventoryName and not Entity(ped).state.killMe
            and not playerState(id, 'hideInfo')
    end,
    offenses = function(ped)
        return serverIdFromPed(ped) ~= nil and started('Unique_jobs')
    end,
}

local tradeChildren = {
    give = function(ped)
        return serverIdFromPed(ped) ~= nil and inventoryResource() ~= nil
    end,
}

local function anyAvailable(children, ped)
    for _, check in pairs(children) do
        if check(ped) then return true end
    end

    return false
end

api.addGlobalPlayer({
    {
        menuName = 'info',
        label = '💳نشان دادن کارت شناسایی',
        canInteract = infoChildren.idCard,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)

            if id then ExecuteCommand('sl ' .. id) end
        end,
    },
    {
        label = '🧲بلند کردن',
        canInteract = function(ped)
            return serverIdFromPed(ped) ~= nil and started('Unique_jobs')
        end,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)

            if id then callExport('Unique_jobs', 'carry', id) end
        end,
    },
    {
        menuName = 'trade',
        label = 'اهداء',
        canInteract = tradeChildren.give,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)

            if id then inventory('openOtherPlayerInventory', id) end
        end,
    },
    {
        label = '👜گشتن کیف',
        canInteract = function(ped)
            local id = serverIdFromPed(ped)

            if not id or not jobCanSearchBag[jobName()] then return false end

            local state = Entity(ped).state

            return not state.inventoryName and not state.killMe and playerState(id, 'bag') ~= nil and not playerState(id, 'admin')
        end,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)
            local bag = id and playerState(id, 'bag')

            if bag then
                TriggerServerEvent('inventory-bag:openBag', bag, id)
                me('Eghdam be gashtan kif fard mikone', true)
            end
        end,
    },
    {
        menuName = 'info',
        label = '🏆افتخارات',
        canInteract = infoChildren.honors,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)

            if id then callExport('Unique_utils', 'openOtherSkillMenu', id) end
        end,
    },
    {
        menuName = 'info',
        label = '⚖️تخلفات',
        distance = 5,
        canInteract = infoChildren.offenses,
        onSelect = function(data)
            local id = serverIdFromPed(data.entity)

            if id then TriggerServerEvent('cs:viewTargetOffense', id) end
        end,
    },
    {
        openMenu = 'info',
        label = 'اطلاعات شخصی',
        distance = 5,
        canInteract = function(entity)
            return serverIdFromPed(entity) ~= nil and anyAvailable(infoChildren, entity)
        end,
        onSelect = function() end,
    },
    {
        openMenu = 'trade',
        label = 'معامله',
        distance = 5,
        canInteract = function(entity)
            return serverIdFromPed(entity) ~= nil and anyAvailable(tradeChildren, entity)
        end,
        onSelect = function() end,
    },
    {
        label = '🐶بازرسی',
        canInteract = function(entity)
            return serverIdFromPed(entity) ~= nil and militaryJobs[jobName()] and started('Unique_utils')
                and callExport('Unique_utils', 'doesHaveTempPet')
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'checkPlayerForDrug', data.entity)
        end,
    },
})

-- Peds ----------------------------------------------------------------------

api.addGlobalPed({
    {
        label = 'غارت کردن',
        canInteract = function(entity)
            local job = jobName()

            return Entity(entity).state.inventoryName and job ~= 'taxi' and job ~= 'mechanic' and job ~= 'ambulance'
                and inventoryResource() ~= nil
        end,
        onSelect = function(data)
            local name = Entity(data.entity).state.inventoryName

            if name then inventory('openInventory', name, nil, nil, true, true) end
        end,
    },
    {
        label = '💀جسد',
        canInteract = function(entity)
            return Entity(entity).state.killMe
        end,
        onSelect = function() end,
    },
})

-- Models --------------------------------------------------------------------

api.addModel({ `prop_fire_hydrant_2` }, {
    {
        label = '🗑️گشتن',
        canInteract = function()
            return inventoryResource() ~= nil
        end,
        onSelect = function(data)
            inventory('openRecycle', data.entity)
        end,
    },
})

api.addModel({ `unique_lootbox` }, {
    {
        label = '👜باز کردن',
        canInteract = function(entity)
            return Entity(entity).state.inventoryName and inventoryResource() ~= nil
        end,
        onSelect = function(data)
            local name = Entity(data.entity).state.inventoryName

            if name then inventory('openInventory', name, nil, nil, true) end
        end,
    },
})

-- Vehicles ------------------------------------------------------------------

local function vehiclePlate(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    return plate and plate:gsub('^%s+', ''):gsub('%s+$', ''):upper() or nil
end

local function canAccessToVehicle(vehicle)
    return callExport('Unique_utils', 'canAccessToVehicle', vehicle)
end

api.addGlobalVehicle({
    {
        label = '🚙باز کردن صندوق عقب',
        canInteract = function()
            return inventoryResource() ~= nil
        end,
        onSelect = function(data)
            inventory('openTrunk', data.entity)
        end,
    },
    {
        label = '👊بیرون انداختن سرنشینان',
        canInteract = function()
            return started('Unique_jobs')
        end,
        onSelect = function(data)
            local vehicle = data.entity
            local plate = vehiclePlate(vehicle)

            if not plate then return end

            if not utils.hasPlayerGotItems('key_' .. plate) then
                return notifyError('Shoma switch in mashin ra nadarid')
            end

            for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                local ped = GetPedInVehicleSeat(vehicle, seat)

                if ped ~= 0 then
                    local id = serverIdFromPed(ped)

                    if id then
                        TriggerServerEvent('3dme:shareDisplay2', 'Dar mashin ro baz mikone va fard ro az mashin biroun mindaze', true)
                        TriggerServerEvent('citizen:putoutvehicle2', id)
                    end
                end
            end
        end,
    },
    {
        label = '🛑برداشتن تابلو',
        canInteract = function(vehicle)
            local placedEntity = Entity(vehicle).state.placedEntity

            return placedEntity and placedEntity >= 100
        end,
        onSelect = function(data)
            TriggerEvent('yaghi:pickup', data.entity)
        end,
    },
    {
        label = 'وصل کردن طناب',
        canInteract = function(vehicle)
            return started('Unique_utils') and utils.hasPlayerGotItems('rope') and canAccessToVehicle(vehicle)
                and not callExport('Unique_utils', 'doesVehicleInRopeList', vehicle)
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'putCarriedHouseObject', data.entity)
        end,
    },
    {
        label = 'جدا کردن طناب',
        canInteract = function(vehicle)
            return callExport('Unique_utils', 'doesVehicleInRopeList', vehicle)
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'removeVehicleRope', data.entity)
        end,
    },
    {
        label = 'گذاشتن گروگان',
        canInteract = function()
            return callExport('Unique_utils', 'doesCarrySoghra')
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'putSoghraInVehicle', data.entity)
        end,
    },
    {
        label = 'بیرون انداختن گروگان',
        canInteract = function(vehicle)
            if not started('Unique_utils') then return false end

            for seat = GetVehicleMaxNumberOfPassengers(vehicle) - 1, 0, -1 do
                if not IsVehicleSeatFree(vehicle, seat) then
                    local ped = GetPedInVehicleSeat(vehicle, seat)

                    if ped ~= 0 and Entity(ped).state.soghraId then return true end
                end
            end

            return false
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'putOutSoghra', data.entity)
        end,
    },
    {
        label = '⛽بنزین زدن',
        canInteract = function()
            return callExport('Unique_utils', 'DoesNearPump')
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'RefuelVehicleFromPump', true, data.entity)
        end,
    },
    {
        label = '⛽بنزین زدن(دبه)',
        canInteract = function()
            local ped = cache.ped

            return started('Unique_utils') and HasPedGotWeapon(ped, `WEAPON_PETROLCAN`, false)
                and GetAmmoInPedWeapon(ped, `WEAPON_PETROLCAN`) > 100
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'RefuelVehicleFromPump', nil, data.entity)
        end,
    },
    {
        label = '👜بار زدن شیء',
        canInteract = function(vehicle)
            return callExport('Unique_utils', 'houseRobGetCurrentCarry') and canAccessToVehicle(vehicle)
        end,
        onSelect = function(data)
            callExport('Unique_utils', 'putCarriedHouseObject', data.entity)
        end,
    },
    {
        label = '🐶صدا زدن',
        canInteract = function()
            return jobPet[jobName()] and started('Unique_utils')
        end,
        onSelect = function()
            local pet = jobPet[jobName()]

            if not pet then return end

            callExport('Unique_animmenu', 'PlayEmote', 'whistle')
            Wait(1000)
            callExport('Unique_utils', 'spawnTemporaryPet', pet)
        end,
    },
})
