-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()

local FurnitureObjects = {}
local isFurnitureLoaded = false
local loadedZones = {}
local SPAWN_DISTANCE = 50.0
local DESPAWN_DISTANCE = 100.0
local CHECK_INTERVAL = 3000

local function LoadFurniture()
    CreateThread(function()
        while not isFurnitureLoaded do
            ESX.TriggerServerCallback('mfk-objectdb:server:GetFurnitureData', function(furnitureData)
                if furnitureData then
                    for zoneName, zoneData in pairs(furnitureData) do
                        local objects = json.decode(zoneData.objects or '[]')
                        for _, furniture in pairs(objects) do
                            if not FurnitureObjects[zoneName] then
                                FurnitureObjects[zoneName] = {}
                            end
                            table.insert(FurnitureObjects[zoneName], {
                                data = {
                                    id = furniture.id,
                                    model = furniture.model,
                                    position = furniture.position,
                                    rotation = furniture.rotation,
                                    zoneName = zoneName
                                }
                            })
                        end
                    end
                    isFurnitureLoaded = true
                end
            end)
            Wait(1000)
        end
    end)
end

local function SpawnZoneObjects(zoneName)
    if not FurnitureObjects[zoneName] or loadedZones[zoneName] then return end

    local zoneConfig = Config.PlacementZones[zoneName]
    if not zoneConfig then return end

    local Player = ESX.GetPlayerData()

    for _, furniture in pairs(FurnitureObjects[zoneName]) do
        if not furniture.object then
            local modelHash = GetHashKey(furniture.data.model)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(0)
            end

            local obj = CreateObject(modelHash,
                furniture.data.position.x,
                furniture.data.position.y,
                furniture.data.position.z,
                false, false, false)

            SetEntityRotation(obj,
                furniture.data.rotation.x,
                furniture.data.rotation.y,
                furniture.data.rotation.z,
                2, true)

            FreezeEntityPosition(obj, true)
            SetEntityCollision(obj, true, true)
            SetModelAsNoLongerNeeded(modelHash)

            if ESX.TableContainsValue(Config.PlacementZones[zoneName].whitelistedLicenses, Player.identifier) then
                exports.ox_target:addLocalEntity(obj, {
                    {
                        name = 'remove_furniture',
                        icon = 'fas fa-trash',
                        label = 'Remove Object',
                        onSelect = function()
                            TriggerEvent('mfk-objectdb:client:RemoveObject', {
                                objectData = {
                                    entity = obj,
                                    model = furniture.data.model,
                                    position = furniture.data.position,
                                    rotation = furniture.data.rotation,
                                    zoneName = zoneName
                                }
                            })
                        end
                    },
                    {
                        name = 'move_furniture',
                        icon = 'fas fa-arrows-alt',
                        label = 'Move Object',
                        onSelect = function()
                            TriggerEvent('mfk-objectdb:client:MoveObject', {
                                objectData = {
                                    entity = obj,
                                    model = furniture.data.model,
                                    position = furniture.data.position,
                                    rotation = furniture.data.rotation,
                                    zoneName = zoneName
                                }
                            })
                        end
                    }
                })

            end
            furniture.object = obj
        end
    end

    loadedZones[zoneName] = true
end

local function RemoveZoneObjects(zoneName)
    if not FurnitureObjects[zoneName] or not loadedZones[zoneName] then return end

    for _, furniture in pairs(FurnitureObjects[zoneName]) do
        if furniture.object and DoesEntityExist(furniture.object) then
            DeleteObject(furniture.object)
            furniture.object = nil
        end
    end

    loadedZones[zoneName] = nil
end

local function CheckPlayerZones()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for zoneName, zoneConfig in pairs(Config.PlacementZones) do
        local distance = #(playerCoords - zoneConfig.coords)

        if distance <= SPAWN_DISTANCE then
            if not loadedZones[zoneName] then
                SpawnZoneObjects(zoneName)
            end
        elseif distance >= DESPAWN_DISTANCE then
            if loadedZones[zoneName] then
                RemoveZoneObjects(zoneName)
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(CHECK_INTERVAL)
        if isFurnitureLoaded then
            CheckPlayerZones()
        end
    end
end)

RegisterNetEvent('mfk-objectdb:client:AddNewFurniture', function(data)
    local furniture = data.object
    local zoneName = data.zoneName

    if not FurnitureObjects[zoneName] then
        FurnitureObjects[zoneName] = {}
    end

    table.insert(FurnitureObjects[zoneName], {
        data = {
            id = furniture.id,
            model = furniture.model,
            position = furniture.position,
            rotation = furniture.rotation,
            owner = furniture.owner,
            zoneName = zoneName
        }
    })

    if loadedZones[zoneName] then
        local modelHash = GetHashKey(furniture.model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end

        local obj = CreateObject(modelHash,
            furniture.position.x,
            furniture.position.y,
            furniture.position.z,
            false, false, false)

        SetEntityRotation(obj,
            furniture.rotation.x,
            furniture.rotation.y,
            furniture.rotation.z,
            2, true)

        FreezeEntityPosition(obj, true)
        SetEntityCollision(obj, true, true)
        SetModelAsNoLongerNeeded(modelHash)

        local Player = ESX.GetPlayerData()
        if ESX.TableContainsValue(Config.PlacementZones[zoneName].whitelistedLicenses, Player.identifier) then
            exports.ox_target:addLocalEntity(obj, {
                {
                    name = 'remove_furniture',
                    icon = 'fas fa-trash',
                    label = 'Remove Object',
                    onSelect = function()
                        TriggerEvent('mfk-objectdb:client:RemoveObject', {
                            objectData = {
                                entity = obj,
                                model = furniture.data.model,
                                position = furniture.data.position,
                                rotation = furniture.data.rotation,
                                zoneName = zoneName
                            }
                        })
                    end
                },
                {
                    name = 'move_furniture',
                    icon = 'fas fa-arrows-alt',
                    label = 'Move Object',
                    onSelect = function()
                        TriggerEvent('mfk-objectdb:client:MoveObject', {
                            objectData = {
                                entity = obj,
                                model = furniture.data.model,
                                position = furniture.data.position,
                                rotation = furniture.data.rotation,
                                zoneName = zoneName
                            }
                        })
                    end
                }
            })
        end

        FurnitureObjects[zoneName][#FurnitureObjects[zoneName]].object = obj
    end
end)

RegisterNetEvent('mfk-objectdb:client:RemoveObject', function(data)
    local objectData = data.objectData
    if not objectData then return end

    local entity = objectData.entity
    if entity and DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
        local modelHash = GetHashKey(objectData.model)
        local objects = GetGamePool('CObject')
        for _, obj in ipairs(objects) do
            if GetEntityModel(obj) == modelHash then
                local objCoords = GetEntityCoords(obj)
                local targetCoords = vector3(objectData.position.x, objectData.position.y, objectData.position.z)
                if #(objCoords - targetCoords) < 1.0 then
                    SetEntityAsMissionEntity(obj, true, true)
                    DeleteEntity(obj)
                end
            end
        end

        local zoneName = objectData.zoneName
        if FurnitureObjects[zoneName] then
            for i, furniture in ipairs(FurnitureObjects[zoneName]) do
                if furniture.data.id == objectData.id then
                    table.remove(FurnitureObjects[zoneName], i)
                    break
                end
            end
        end
    end

    ESX.TriggerServerEvent('mfk-objectdb:server:RemoveFurniture', {
        id = objectData.id,
        zoneName = objectData.zoneName,
        nearbyPlayers = GetNearbyPlayers(SPAWN_DISTANCE)
    })
end)

RegisterNetEvent('mfk-objectdb:client:RemoveFurniture', function(data)
    local zoneName = data.zoneName
    local id = data.object.id

    if FurnitureObjects[zoneName] then
        for i, furniture in ipairs(FurnitureObjects[zoneName]) do
            if furniture.data.id == id then
                if furniture.object and DoesEntityExist(furniture.object) then
                    DeleteObject(furniture.object)
                end
                table.remove(FurnitureObjects[zoneName], i)
                break
            end
        end
    end
end)

RegisterNetEvent('mfk-objectdb:client:MoveObject', function(data)
    local objectData = data.objectData
    if not objectData then return end

    local entity = objectData.entity
    if not entity or not DoesEntityExist(entity) then return end
    local originalCoords = GetEntityCoords(entity)
    local originalRotation = GetEntityRotation(entity, 2)


    local newData = exports['sun-gizmo']:useGizmo(entity)

    if newData then
        SetEntityCoords(entity, newData.position.x, newData.position.y, newData.position.z, false, false, false, false)
        SetEntityRotation(entity, newData.rotation.x, newData.rotation.y, newData.rotation.z, 2, true)
        local zoneName = objectData.zoneName
        if FurnitureObjects[zoneName] then
            for _, furniture in ipairs(FurnitureObjects[zoneName]) do
                if furniture.data.id == objectData.id then
                    furniture.data.position = newData.position
                    furniture.data.rotation = newData.rotation
                    break
                end
            end
        end
        ESX.TriggerServerEvent('mfk-objectdb:server:UpdateFurniturePosition', {
            id = objectData.id,
            zoneName = zoneName,
            newPosition = newData.position,
            newRotation = newData.rotation,
            nearbyPlayers = GetNearbyPlayers(SPAWN_DISTANCE)
        })

        ESX.ShowNotification('Object position updated successfully!')
    else
        SetEntityCoords(entity, originalCoords.x, originalCoords.y, originalCoords.z, false, false, false, false)
        SetEntityRotation(entity, originalRotation.x, originalRotation.y, originalRotation.z, 2, true)
    end
end)

RegisterNetEvent('mfk-objectdb:client:UpdateFurniturePosition', function(data)
    local zoneName = data.zoneName
    local id = data.id
    if not FurnitureObjects[zoneName] then return end

    for _, furniture in ipairs(FurnitureObjects[zoneName]) do
        if furniture.data.id == id then
            furniture.data.position = data.newPosition
            furniture.data.rotation = data.newRotation
            if furniture.object and DoesEntityExist(furniture.object) then
                SetEntityCoords(furniture.object,
                    data.newPosition.x,
                    data.newPosition.y,
                    data.newPosition.z,
                    false, false, false, false)
                SetEntityRotation(furniture.object,
                    data.newRotation.x,
                    data.newRotation.y,
                    data.newRotation.z,
                    2, true)
            end
            break
        end
    end
end)

CreateThread(function()
    while not ESX do Wait(10000) end
    LoadFurniture()
end)