--[[
    kq_detective — body cleanup ("collect body").

    NPC corpses only (see Config.cleanup comment in config.lua for why player
    peds are excluded — deleting a real connected player's ped is not safe).
]]

RegisterNetEvent('kq_detective:collectBody')
AddEventHandler('kq_detective:collectBody', function(data)
    if not Config.cleanup.enabled then return end
    if not Contains(Config.cleanup.jobs, playerJob) then return end

    local ped = data.entity
    if not DoesEntityExist(ped) or not IsEntityDead(ped) or IsPedAPlayer(ped) then return end

    local coords = GetEntityCoords(ped)
    local bagModel = GetHashKey(Config.cleanup.bagProp)
    local bag = nil

    RequestModel(bagModel)
    local attempts = 0
    while not HasModelLoaded(bagModel) and attempts < 100 do
        Citizen.Wait(10)
        attempts = attempts + 1
    end

    if HasModelLoaded(bagModel) then
        bag = CreateObject(bagModel, coords.x, coords.y, coords.z + 0.1, true, true, false)
        AttachEntityToEntity(bag, ped, 0, 0.0, 0.0, 0.15, 0.0, 0.0, GetEntityHeading(ped), false, false, false, false, 1, true)
        SetModelAsNoLongerNeeded(bagModel)
    end

    -- Reuses the same investigate animation rather than guessing at an
    -- unverified "drag body" anim name.
    if Config.animation.enabled then
        PlayAnim(Config.animation.dict, Config.animation.anim, 1)
    end

    Citizen.Wait(Config.cleanup.bagDuration)

    if bag and DoesEntityExist(bag) then
        DeleteEntity(bag)
    end

    NetworkRequestControlOfEntity(ped)
    local waited = 0
    while not NetworkHasControlOfEntity(ped) and waited < 1000 do
        Citizen.Wait(50)
        waited = waited + 50
    end

    if DoesEntityExist(ped) then
        SetEntityAsMissionEntity(ped, true, true)
        DeleteEntity(ped)
    end

    TriggerServerEvent('kq_detective:bodyCollected')
end)
