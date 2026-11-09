-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- if GetConvarInt('ox_target:defaults', 1) ~= 1 then return end

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

-- api.addGlobalVehicle({
--     {
--         name = 'ox_target:driverF',
--         icon = 'fa-solid fa-car-side',
--         label = locale('toggle_front_driver_door'),
--         bones = { 'door_dside_f', 'seat_dside_f' },
--         distance = 2,
--         canInteract = function(entity, distance, coords, name)
--             return canInteractWithDoor(entity, coords, 0)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 0)
--         end
--     },
--     {
--         name = 'ox_target:passengerF',
--         icon = 'fa-solid fa-car-side',
--         label = locale('toggle_front_passenger_door'),
--         bones = { 'door_pside_f', 'seat_pside_f' },
--         distance = 2,
--         canInteract = function(entity, distance, coords, name)
--             return canInteractWithDoor(entity, coords, 1)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 1)
--         end
--     },
--     {
--         name = 'ox_target:driverR',
--         icon = 'fa-solid fa-car-side',
--         label = locale('toggle_rear_driver_door'),
--         bones = { 'door_dside_r', 'seat_dside_r' },
--         distance = 2,
--         canInteract = function(entity, distance, coords)
--             return canInteractWithDoor(entity, coords, 2)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 2)
--         end
--     },
--     {
--         name = 'ox_target:passengerR',
--         icon = 'fa-solid fa-car-side',
--         label = locale('toggle_rear_passenger_door'),
--         bones = { 'door_pside_r', 'seat_pside_r' },
--         distance = 2,
--         canInteract = function(entity, distance, coords)
--             return canInteractWithDoor(entity, coords, 3)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 3)
--         end
--     },
--     {
--         name = 'ox_target:bonnet',
--         icon = 'fa-solid fa-car',
--         label = locale('toggle_hood'),
--         offset = vec3(0.5, 1, 0.5),
--         distance = 2,
--         canInteract = function(entity, distance, coords)
--             return canInteractWithDoor(entity, coords, 4, true)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 4)
--         end
--     },
--     {
--         name = 'ox_target:trunk',
--         icon = 'fa-solid fa-car-rear',
--         label = locale('toggle_trunk'),
--         offset = vec3(0.5, 0, 0.5),
--         distance = 2,
--         canInteract = function(entity, distance, coords, name)
--             return canInteractWithDoor(entity, coords, 5, true)
--         end,
--         onSelect = function(data)
--             onSelectDoor(data, 5)
--         end
--     }
-- })

local jobCanSearchBag = {
    police = true,
    sheriff = true,
    mt = true,
    fbi = true,
    detective = true,
    justice = true,
}

local jobPet = {
    ['detective'] = 'a_c_husky_k9',
    ['fbi'] = 'a_c_husky_k9',
    ['mt'] = 'a_c_shepherd',
    ['police'] = 'a_c_husky_k9',
    ['sheriff'] = 'a_c_husky_k9',
    ['ambulance'] = 'a_c_husky_ems',
}


api.addGlobalPlayer({
    {
        menuName = 'info',
        label = "💳نشان دادن کارت شناسایی",
        canInteract = function(ped)
            return NetworkGetPlayerIndexFromPed(ped) ~= -1
        end,
        onSelect = function(data)
            local ped = data.entity
            local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
            ExecuteCommand('sl ' .. targetID)
        end,
    },
    {
        label = "🧲بلند کردن",
        canInteract = function(ped)
            return NetworkGetPlayerIndexFromPed(ped) ~= -1
        end,
        onSelect = function(data)
            local entity = data.entity
            local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
            exports['sun-jobs']:carry(targetID)
        end,
    },
    {
        menuName = 'trade',
        label = "اهداء",
        canInteract = function(ped)
            return NetworkGetPlayerIndexFromPed(ped) ~= -1
        end,
        onSelect = function(data)
            local ped = data.entity
            exports['sun-inventory-hud']:openOtherPlayerInventory(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
        end,
    },
    {
        label = '👜گشتن کیف',
        canInteract = function(ped)
            return not Entity(ped).state.inventoryName and not Entity(ped).state.killMe and jobCanSearchBag[ESX.PlayerData.job.name] and ESX.GetPlayerState(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)), 'bag') and not  ESX.GetPlayerState(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)), 'admin') and NetworkGetPlayerIndexFromPed(ped) ~= -1
        end,
        onSelect = function(data)
            local ped = data.entity
            local id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
            if ESX.GetPlayerState(id, 'bag') then
                ESX.TriggerServerEvent('inventory-bag:openBag', ESX.GetPlayerState(id, 'bag'), id)
                exports['sunset_utils']:me('Eghdam be gashtan kif fard mikone', true)
            end
        end,
    },
    {
        menuName = 'info',
        label = '🏆افتخارات',
        canInteract = function(ped)
            return NetworkGetPlayerIndexFromPed(ped) ~= -1 and not Entity(ped).state.inventoryName and not Entity(ped).state.killMe and not ESX.GetPlayerState(GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)), 'hideInfo')
        end,
        onSelect = function(data)
            local ped = data.entity
            local src = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
            exports['sunset_utils']:openOtherSkillMenu(src)
        end,
    },
    {
        menuName = 'info',
        label = '⚖️تخلفات',
        distance = 5,
        onSelect = function(data)
            local ped = data.entity
            ESX.TriggerServerEvent('cs:viewTargetOffense', GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
        end,
    },
    {
        openMenu = 'info',
        label = 'اطلاعات شخصی',
        distance = 5,
        canInteract = function(entity)
            return NetworkGetPlayerIndexFromPed(entity) ~= -1
        end,
        onSelect = function(ped)
        end,
    },
    {
        openMenu = 'trade',
        label = 'معامله',
        distance = 5,
        canInteract = function(entity)
            return NetworkGetPlayerIndexFromPed(entity) ~= -1
        end,
        onSelect = function(ped)
        end,
    },
    {
        label = '🐶بازرسی',
        canInteract = function(entity)
            return ESX.militaryJobs[ESX.PlayerData.job.name] and exports['sunset_utils']:doesHaveTempPet()
        end,
        onSelect = function(data)
            local entity = data.entity
            exports['sunset_utils']:checkPlayerForDrug(entity)
        end,
    },
})

api.addGlobalPed({
    {
        label = 'غارت کردن',
        canInteract = function(entity)
            local job = ESX.GetPlayerData().job.name
            return Entity(entity).state.inventoryName and job ~= 'taxi' and job ~= 'mechanic' and job ~= 'ambulance'
        end,
        onSelect = function(data)
            local entity = data.entity
            exports['sun-inventory-hud']:openInventory(Entity(entity).state.inventoryName, nil, nil, true, true)
        end,
    },
    {
        label = '💀جسد',
        canInteract = function(entity)
            return Entity(entity).state.killMe
        end,
        onSelect = function(entity)
        end,
    },
})

local recycles = {
    `prop_fire_hydrant_2`
}

api.addModel(recycles, {
    label = '🗑️گشتن',
    onSelect = function(data)
        local entity = data.entity
        exports['sun-inventory-hud']:openRecycle(entity)
    end,
})

local loots = {
    `sun_lootbox`
}
api.addModel(loots, {
    {
        label = '👜باز کردن',
        canInteract = function(entity)
            return Entity(entity).state.inventoryName
        end,
        onSelect = function(data)
            local entity = data.entity
            exports['sun-inventory-hud']:openInventory(Entity(entity).state.inventoryName, nil, nil, true)
        end,
    }
})

api.addGlobalVehicle({
    {
        label = "🚙باز کردن صندوق عقب",
        onSelect = function(data)
            local entity = data.entity
            exports['sun-inventory-hud']:openTrunk(entity)
        end,
    },
    {
        label = "👊بیرون انداختن سرنشینان",
        onSelect = function(data)
            local entity = data.entity
            local plate = ESX.GetPlate(entity)
            if plate then
                plate = 'key_' .. string.upper(ESX.Math.Trim(plate))
                if ESX.DoesHaveItem(plate,1,nil,nil,false) then
                    for seat = -1, GetVehicleMaxNumberOfPassengers(entity) - 1 do
                        local driver = GetPedInVehicleSeat(entity, seat)
                        if driver ~= 0 then
                            TriggerServerEvent('3dme:shareDisplay2', "Dar mashin ro baz mikone va fard ro az mashin biroun mindaze", true)
                            local targetID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
                            ESX.TriggerServerEvent('citizen:putoutvehicle2',targetID)
                        end
                    end
                else
                    ESX.Alert('','Shoma switch in mashin ra nadarid',5000,'error')
                end
            end
        end,
    },
    {
        label = "🛑برداشتن تابلو",
        canInteract = function(vehicle)
            local placedEntity = Entity(vehicle).state.placedEntity
            return placedEntity and placedEntity >= 100
        end,
        onSelect = function(data)
            local vehicle = data.entity
            TriggerEvent('yaghi:pickup',vehicle)
        end,
    },
    {
        label = 'وصل کردن طناب',
        canInteract = function(vehicle)
            return ESX.DoesHaveItem2('rope', 1) and exports['sunset_utils']:canAccessToVehicle(vehicle) and not exports['sunset_utils']:doesVehicleInRopeList(vehicle)
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:putCarriedHouseObject(vehicle)
        end,
    },
    {
        label = 'جدا کردن طناب',
        canInteract = function(vehicle)
            return exports['sunset_utils']:doesVehicleInRopeList(vehicle)
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:removeVehicleRope(vehicle)
        end,
    },
    {
        label = 'گذاشتن گروگان',
        canInteract = function(vehicle)
            return exports['sunset_utils']:doesCarrySoghra()
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:putSoghraInVehicle(vehicle)
        end,
    },
    {
        label = 'بیرون انداختن گروگان',
        canInteract = function(vehicle)
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            for i = maxSeats - 1, 0, -1 do
                if not IsVehicleSeatFree(vehicle, i) then
                    local ped = GetPedInVehicleSeat(vehicle, i)
                    if Entity(ped).state.soghraId then
                        return true
                    end
                end
            end    
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:putOutSoghra(vehicle)
        end,
    },{
        label = '⛽بنزین زدن',
        canInteract = function()
            return exports['sunset_utils']:DoesNearPump()
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:RefuelVehicleFromPump(true, vehicle)
        end,
    },{
        label = '⛽بنزین زدن(دبه)',
        canInteract = function()
            local ped = PlayerPedId()
            return HasPedGotWeapon(ped, `WEAPON_PETROLCAN`) and GetAmmoInPedWeapon(ped, `WEAPON_PETROLCAN`) > 100
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:RefuelVehicleFromPump(nil, vehicle)
        end,
    },{
        label = '👜بار زدن شیء',
        canInteract = function(vehicle)
            return exports['sunset_utils']:houseRobGetCurrentCarry() and exports['sunset_utils']:canAccessToVehicle(vehicle)
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sunset_utils']:putCarriedHouseObject(vehicle)
        end,
    },{
        label = '🐶صدا زدن',
        canInteract = function(vehicle)
            return jobPet[ESX.PlayerData.job.name]
        end,
        onSelect = function(data)
            local vehicle = data.entity
            exports['sun-animmenu']:PlayEmote('whistle')
            Wait(1000)
            exports['sunset_utils']:spawnTemporaryPet(jobPet[ESX.PlayerData.job.name])
        end,
    }
})