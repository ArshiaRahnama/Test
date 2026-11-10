-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local SPAWN_DISTANCE = 50.0

local function GetCurrentZone()
    local playerCoords = GetEntityCoords(PlayerPedId())

    for zoneName, zone in pairs(Config.PlacementZones) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            return zoneName
        end
    end
    return nil
end

RegisterCommand('fur', function()
    local zoneName = GetCurrentZone()
    if not zoneName then
        ESX.ShowNotification('You are not in a valid furniture placement zone')
        return
    end

    TriggerServerEvent('mfk_furniture:checkPermission', zoneName)
end, false)

RegisterCommand('furcount', function()
    local zoneName = GetCurrentZone()
    if not zoneName then
        ESX.ShowNotification('You are not in a valid furniture placement zone')
        return
    end

    TriggerServerEvent('mfk_furniture:checkZoneCount', zoneName)
end, false)

RegisterNetEvent('mfk_furniture:openMenu', function()
    local zoneName = GetCurrentZone()
    if not zoneName then
        ESX.ShowNotification('You are not in a valid furniture placement zone')
        return
    end

    local zoneConfig = Config.PlacementZones[zoneName]
    if not zoneConfig or not zoneConfig.furniture then
        ESX.ShowNotification('No furniture available for this zone')
        return
    end

    local options = {}
    for i, furniture in ipairs(zoneConfig.furniture) do
        options[#options + 1] = {
            title = furniture.name,
            description = ('Price: $%d'):format(furniture.price),
            onSelect = function()
                TriggerServerEvent('mfk_furniture:checkPurchase', zoneName, i)
            end
        }
    end

    lib.registerContext({
        id = 'furniture_menu',
        title = 'Furniture Shop',
        options = options
    })

    lib.showContext('furniture_menu')
end)

local function GetNearbyPlayers(distance)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            if #(playerCoords - targetCoords) <= (distance or SPAWN_DISTANCE) then
                local serverId = GetPlayerServerId(playerId)
                table.insert(players, serverId)
            end
        end
    end
    return players
end

local function SpawnAndPlaceFurniture(zoneName, furnitureIndex)
    if not zoneName then
        ESX.ShowNotification('You can only place furniture in designated areas')
        return
    end

    local zoneConfig = Config.PlacementZones[zoneName]
    if not zoneConfig or not zoneConfig.furniture then
        ESX.ShowNotification('No furniture available for this zone')
        return
    end

    local furniture = zoneConfig.furniture[furnitureIndex]
    if not furniture then
        ESX.ShowNotification('Invalid furniture selection')
        return
    end

    ESX.TriggerServerCallback('mfk-objectdb:server:GetZoneObjectCount', function(currentObjects)
        if currentObjects >= zoneConfig.spawnLimit then
            ESX.ShowNotification('This zone has reached its maximum object limit (' .. zoneConfig.spawnLimit .. ')')
            return
        end

        local offset = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 3

        lib.requestModel(furniture.model)
        local obj = CreateObject(furniture.model, offset.x, offset.y, offset.z, false, false, false)

        SetEntityCollision(obj, false, false)
        SetEntityInvincible(obj, true)
        SetEntityHasGravity(obj, false)
        SetEntityDynamic(obj, false)
        SetEntityRecordsCollisions(obj, false)
        SetEntityCanBeDamaged(obj, false)
        SetEntityProofs(obj, true, true, true, true, true, true, true, true)
        SetEntityAlpha(obj, 200, false)

        Wait(0)

        SetEntityCollision(obj, true, true)
        FreezeEntityPosition(obj, true)

        local data = exports['sun-gizmo']:useGizmo(obj)

        if data then
            local finalObj = CreateObject(furniture.model, data.position.x, data.position.y, data.position.z, false, false, false)
            SetEntityRotation(finalObj, data.rotation.x, data.rotation.y, data.rotation.z, 2, true)
            FreezeEntityPosition(finalObj, true)
            SetEntityCollision(finalObj, true, true)
            SetEntityInvincible(finalObj, true)
            SetEntityHasGravity(finalObj, false)
            SetEntityDynamic(finalObj, false)
            SetEntityRecordsCollisions(finalObj, false)
            SetEntityCanBeDamaged(finalObj, false)
            SetEntityProofs(finalObj, true, true, true, true, true, true, true, true)

            ESX.TriggerServerEvent('mfk-objectdb:server:saveFurniture', {
                object = furniture.model,
                coords = json.encode(data.position),
                rotation = json.encode(data.rotation),
                zoneName = zoneName,
                nearbyPlayers = GetNearbyPlayers(SPAWN_DISTANCE)
            })
            ESX.ShowNotification('Furniture placed successfully!')
            DeleteEntity(obj)
        else
            DeleteEntity(obj)
        end
    end, zoneName)
end

RegisterNetEvent('mfk_furniture:spawnFurniture', function(zoneName, furnitureIndex)
    SpawnAndPlaceFurniture(zoneName, furnitureIndex)
end)