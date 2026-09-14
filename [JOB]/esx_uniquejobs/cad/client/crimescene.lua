--[[
    Unique_CrimeScene -- world-interaction side. Physically merged into
    cad/ (this file used to live at crimescene/client/main.lua).

    All the panel UI (case list, evidence, notes, BOLO, booking, records,
    leaderboard) lives in cad/html + cad/client/main.lua's CS_* bridge
    (opened with /cad). This file only handles things that happen in
    the game world: blips, ox_target evidence zones, the scene lockdown
    zone, and spawning/driving the prisoner transport convoy. It talks to
    cad/server/crimescene.lua the same way it always did -- these are just
    net events/callbacks, so which file registers them on the server side
    doesn't matter.

    Locals here use the same file-scoping every other job module in this
    resource relies on (see the note at the top of fxmanifest.lua) --
    top-level `local`s don't leak across the client_scripts of a single
    resource, so no _cs suffixes needed except on the couple of things that
    were deliberately global before (kept namespaced below just in case).
]]

local ESX = nil
local PlayerJob = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    PlayerJob = ESX.PlayerData.job and ESX.PlayerData.job.name or nil
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerJob = job and job.name or nil
end)

local function IsDOJJob()
    if not PlayerJob then return false end
    for i = 1, #Config_cs.DOJJobs do
        if Config_cs.DOJJobs[i] == PlayerJob then return true end
    end
    return false
end

local function IsLawEnforcementJob()
    if not PlayerJob then return false end
    for i = 1, #Config_cs.LawEnforcementJobs do
        if Config_cs.LawEnforcementJobs[i] == PlayerJob then return true end
    end
    return false
end

-- ============================================================
-- Scene tracking: blips + ox_target zones per case
-- ============================================================

local SceneBlips = {}     -- [caseId] = blip
local PointZones = {}     -- [caseId][pointId] = zoneId
local LockdownZones = {}  -- [caseId] = zoneId (Law Enforcement's "secure scene" zone)

local function UpdateSceneBlipColor(caseId)
    if not SceneBlips[caseId] or not PointZones[caseId] then return end
    local remaining = 0
    for _ in pairs(PointZones[caseId]) do remaining = remaining + 1 end
    -- 5 = red (fresh scene), 46 = orange (partly worked), 2 = green (almost cleared)
    if remaining >= 3 then
        SetBlipColour(SceneBlips[caseId], 5)
    elseif remaining >= 1 then
        SetBlipColour(SceneBlips[caseId], 46)
    else
        SetBlipColour(SceneBlips[caseId], 2)
    end
end

local function RemoveLockdownZone(caseId)
    if LockdownZones[caseId] then
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeZone(LockdownZones[caseId])
        end
        LockdownZones[caseId] = nil
    end
end

local function RemoveScene(caseId)
    if SceneBlips[caseId] then
        RemoveBlip(SceneBlips[caseId])
        SceneBlips[caseId] = nil
    end
    if PointZones[caseId] then
        for _, zoneId in pairs(PointZones[caseId]) do
            if GetResourceState('ox_target') == 'started' then
                exports.ox_target:removeZone(zoneId)
            end
        end
        PointZones[caseId] = nil
    end
    RemoveLockdownZone(caseId)
end

local function AddLockdownZone(caseId, coords)
    local zoneId = exports.ox_target:addSphereZone({
        coords = coords,
        radius = Config_cs.SceneLockdown.radius,
        debug = false,
        options = {
            {
                name = 'crimescene_secure_' .. caseId,
                icon = 'fa-solid fa-shield-halved',
                label = 'Emn Sazi Sahne',
                canInteract = function() return IsLawEnforcementJob() end,
                onSelect = function()
                    local passed = lib.skillCheck(Config_cs.SceneLockdown.skillCheck)
                    if passed then
                        TriggerServerEvent('CrimeScene:secureScene', caseId)
                    else
                        lib.notify({ title = '', description = 'Emn Sazi Movafagh Nabood, Dobare Talash Konid', type = 'error' })
                    end
                end,
            }
        }
    })
    LockdownZones[caseId] = zoneId
end

RegisterNetEvent('CrimeScene:sceneCreated')
AddEventHandler('CrimeScene:sceneCreated', function(caseId, coords, points, secured)
    if not IsDOJJob() and not IsLawEnforcementJob() then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 60)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Sahne Jorm')
    EndTextCommandSetBlipName(blip)
    SceneBlips[caseId] = blip

    if IsDOJJob() then
        PointZones[caseId] = {}
        for _, point in ipairs(points) do
            local pointId = point.id
            local pCoords = point.coords

            local zoneId = exports.ox_target:addSphereZone({
                coords = pCoords,
                radius = 1.5,
                debug = false,
                options = {
                    {
                        name = 'crimescene_evidence_' .. caseId .. '_' .. pointId,
                        icon = 'fa-solid fa-magnifying-glass',
                        label = 'Baresi Mahal',
                        canInteract = function() return IsDOJJob() end,
                        onSelect = function()
                            local passed = lib.skillCheck(Config_cs.EvidenceSkillCheck)
                            TriggerServerEvent('CrimeScene:collectEvidence', caseId, pointId, passed and true or false)
                        end,
                    }
                }
            })
            PointZones[caseId][pointId] = zoneId
        end
        UpdateSceneBlipColor(caseId)
    end

    if IsLawEnforcementJob() and not secured then
        AddLockdownZone(caseId, coords)
    end
end)

RegisterNetEvent('CrimeScene:sceneSecured')
AddEventHandler('CrimeScene:sceneSecured', function(caseId)
    RemoveLockdownZone(caseId)
end)

RegisterNetEvent('CrimeScene:pointRemoved')
AddEventHandler('CrimeScene:pointRemoved', function(caseId, pointId)
    if PointZones[caseId] and PointZones[caseId][pointId] then
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeZone(PointZones[caseId][pointId])
        end
        PointZones[caseId][pointId] = nil
        UpdateSceneBlipColor(caseId)
    end
end)

RegisterNetEvent('CrimeScene:sceneExpired')
AddEventHandler('CrimeScene:sceneExpired', function(caseId)
    RemoveScene(caseId)
end)

RegisterNetEvent('CrimeScene:evidenceCollected')
AddEventHandler('CrimeScene:evidenceCollected', function(caseId, pointId, evType, content, skillCheckPassed)
    lib.notify({
        title = skillCheckPassed and 'Madrak Peida Shod' or 'Madrak Peida Shod (Kamyfiat Payin)',
        description = content,
        type = skillCheckPassed and 'success' or 'warning',
        duration = 8000,
        position = 'center-right',
    })
end)

-- ============================================================
-- BOLO / plate check world feedback -- the actual panel (list, "check
-- nearest vehicle" button) lives in cad/html + cad/client/main.lua now.
-- This is just the toast notifications so it still feels responsive
-- even if the player doesn't have /cad open.
-- ============================================================

RegisterNetEvent('CrimeScene:newBOLO')
AddEventHandler('CrimeScene:newBOLO', function(plate, caseId)
    lib.notify({
        title = 'BOLO Jadid',
        description = 'Pelake Mashkook: ' .. plate .. ' (Parvande #' .. caseId .. ')',
        type = 'error',
        duration = 10000,
        position = 'center-right',
    })
end)

RegisterNetEvent('CrimeScene:plateCheckResult')
AddEventHandler('CrimeScene:plateCheckResult', function(matched, plate, caseId)
    if matched then
        lib.notify({
            title = 'MATCH!',
            description = 'In Khodro BOLO Darad (Parvande #' .. caseId .. ')',
            type = 'error',
            duration = 9000,
            position = 'center-right',
        })
    end
end)

-- ============================================================
-- Prisoner Transport / Prison Break
-- ============================================================

local TransportBlips = {} -- [transportId] = { startBlip, destBlip }

local function ClearTransportBlips(transportId)
    local b = TransportBlips[transportId]
    if not b then return end
    if b.startBlip then RemoveBlip(b.startBlip) end
    if b.destBlip then RemoveBlip(b.destBlip) end
    TransportBlips[transportId] = nil
end

-- Shown to Law Enforcement (escort duty) and the suspect's gang (rescue
-- window) alike -- just awareness blips, not the live van position.
RegisterNetEvent('CrimeScene:transportAlert')
AddEventHandler('CrimeScene:transportAlert', function(transportId, startCoords, prisonCoords, suspectName)
    local startBlip = AddBlipForCoord(startCoords.x, startCoords.y, startCoords.z)
    SetBlipSprite(startBlip, 280)
    SetBlipColour(startBlip, 3)
    SetBlipScale(startBlip, 0.8)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Shoroe Enteghal: ' .. suspectName)
    EndTextCommandSetBlipName(startBlip)

    local destBlip = AddBlipForCoord(prisonCoords.x, prisonCoords.y, prisonCoords.z)
    SetBlipSprite(destBlip, 351)
    SetBlipColour(destBlip, 1)
    SetBlipScale(destBlip, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Zendan')
    EndTextCommandSetBlipName(destBlip)

    TransportBlips[transportId] = { startBlip = startBlip, destBlip = destBlip }

    if IsLawEnforcementJob() then
        lib.notify({ title = 'Enteghale Zendani', description = suspectName .. ' - Eskort Konid', type = 'info', duration = 9000 })
    else
        lib.notify({
            title = 'Forsate Nejat',
            description = suspectName .. ' Dare Montaghel Mishe! Baraye Azad Kardan: /freeprisoner ' .. transportId,
            type = 'error',
            duration = 12000,
        })
    end
end)

RegisterNetEvent('CrimeScene:transportEnded')
AddEventHandler('CrimeScene:transportEnded', function(transportId, outcome)
    ClearTransportBlips(transportId)
end)

-- Only fires for the officer whose client actually spawned the convoy.
RegisterNetEvent('CrimeScene:startPrisonTransport')
AddEventHandler('CrimeScene:startPrisonTransport', function(transportId, startCoords, prisonCoords, suspectName)
    local vanModelHash = GetHashKey(Config_cs.PrisonBreak.vanModel)
    local prisonerModelHash = GetHashKey(Config_cs.PrisonBreak.prisonerPedModel)

    RequestModel(vanModelHash)
    RequestModel(prisonerModelHash)
    local waited = 0
    while (not HasModelLoaded(vanModelHash) or not HasModelLoaded(prisonerModelHash)) and waited < 5000 do
        Citizen.Wait(50)
        waited = waited + 50
    end

    if not HasModelLoaded(vanModelHash) or not HasModelLoaded(prisonerModelHash) then
        lib.notify({ title = '', description = 'Khataye Bargozari Model - Enteghal Laghv Shod', type = 'error' })
        TriggerServerEvent('CrimeScene:reportTransportArrived', transportId) -- fail safe, don't block the booking
        return
    end

    local heading = GetEntityHeading(PlayerPedId())
    local van = CreateVehicle(vanModelHash, startCoords.x, startCoords.y, startCoords.z, heading, true, false)
    SetVehicleOnGroundProperly(van)
    SetVehicleDoorsLocked(van, 1)

    local prisoner = CreatePed(4, prisonerModelHash, startCoords.x + 1.0, startCoords.y, startCoords.z, heading, true, false)
    SetEntityInvincible(prisoner, true) -- rescue is an interaction, not a kill -- keeps the focus on the van fight
    SetBlockingOfNonTemporaryEvents(prisoner, true)
    TaskWarpPedIntoVehicle(prisoner, van, 2) -- back seat

    TaskWarpPedIntoVehicle(PlayerPedId(), van, -1) -- driver seat

    SetModelAsNoLongerNeeded(vanModelHash)
    SetModelAsNoLongerNeeded(prisonerModelHash)

    local routeBlip = AddBlipForCoord(prisonCoords.x, prisonCoords.y, prisonCoords.z)
    SetBlipRoute(routeBlip, true)
    SetBlipSprite(routeBlip, 351)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Zendan - Enteghale ' .. suspectName)
    EndTextCommandSetBlipName(routeBlip)

    lib.notify({ title = 'Enteghal Shoro Shod', description = 'Zendani Ra Be Zendan Beresanid.', type = 'info', duration = 8000 })

    Citizen.CreateThread(function()
        while DoesEntityExist(van) do
            Citizen.Wait(4000)
            if not DoesEntityExist(van) then break end

            local vanCoords = GetEntityCoords(van)
            local engineHealth = GetVehicleEngineHealth(van)
            TriggerServerEvent('CrimeScene:transportTick', transportId, vanCoords, engineHealth)

            if #(vanCoords - prisonCoords) <= Config_cs.PrisonBreak.deliverDistance then
                TriggerServerEvent('CrimeScene:reportTransportArrived', transportId)
                break
            end

            if not DoesEntityExist(prisoner) or IsEntityDead(prisoner) then
                break -- something went very wrong, stop reporting; server window timeout will resolve it
            end
        end
    end)

    local function CleanupConvoy()
        RemoveBlip(routeBlip)
        if DoesEntityExist(van) then DeleteVehicle(van) end
        if DoesEntityExist(prisoner) then DeletePed(prisoner) end
    end

    local endedHandler
    endedHandler = AddEventHandler('CrimeScene:transportEnded', function(endedId)
        if endedId ~= transportId then return end
        CleanupConvoy()
        RemoveEventHandler(endedHandler)
    end)
end)
