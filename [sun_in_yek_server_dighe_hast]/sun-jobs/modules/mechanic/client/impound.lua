-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local blips = {}
RegisterNetEvent('mechanic:impound:addDeadVehicleBlip', function(id, coords)
    local blip = ESX.AddBlipForCoord(coords, 1.0, 100, 1, 'Dead Car', 6)
    blips[id] = blip
end)

RegisterNetEvent('mechanic:impound:removeDeadVehicleBlip', function(id, coords)
    if blips[id] then
        ESX.removeBlip(blips[id])
    end
end)

function mechanicDeleteVehicleImpound()
    local vehicle = ESX.isVehicleDriver()
    if vehicle then
        local target
        for k, v in pairs(ESX.Game.GetVehicles()) do
            if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(v)) <= 20 then
                if not IsVehicleModel(v, `flatbed`) and IsEntityAttachedToAnyVehicle(v) and GetEntityAttachedTo(v) == vehicle then
                    target = v
                    break
                end
            end
        end
        for k, entity in pairs(ESX.Game.GetObjects()) do
            if Entity(entity).state.impoundEntity then
                if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity)) <= 20 and IsEntityAttachedToAnyVehicle(entity) and GetEntityAttachedTo(entity) == vehicle then
                    target = entity
                    break
                end
            end
        end
        if target then
            if not lib.progressActive() then
                if lib.progressCircle({
                    duration = 15000,
                    position = 'middle',
                    useWhileDead = false,
                    canCancel = false,
                    allowRagdoll = true,
                    allowFalling = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                }) then
                    if DoesEntityExist(target) then
                        ESX.TriggerServerEvent('mechanic:impound:end', NetworkGetNetworkIdFromEntity(target))
                    end
                end
            end
        else
            ESX.chatMessage('Mashini baraye impound nadarid', 'job')
        end
    else
        ESX.chatMessage('Shoma savar mashini nistid', 'job')
    end
end

AddEventHandler('enterVehicle', function(vehicle, isDriver)
    if ESX.PlayerData.job.name == 'mechanic' and isDriver then
        for k, entity in pairs(ESX.Game.GetObjects()) do
            if Entity(entity).state.impoundEntity then
                if IsEntityAttachedToEntity(entity, vehicle) then
                    local near = nil
                    local coords = GetEntityCoords(PlayerPedId())
                    for k, v in pairs(Shared.mechanic.zones.vehicleDeleterImpound) do
                        if not near or #(coords - v.xyz) < near.distance then
                            near = {
                                coords = v,
                                distance = #(coords - v.xyz),
                            }
                        end
                    end
                    if near then
                        SetNewWaypoint(near.coords.x, near.coords.y)
                    end
                    break
                end
            end
        end
    end
end)