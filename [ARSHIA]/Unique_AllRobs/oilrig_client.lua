-- ============================================================
-- Unique_OilRig (merged into Unique_AllRobs) -- client
--
-- The start-marker interaction (press E, armed check, distance) is
-- handled entirely by the EXISTING generic marker loop in client.lua
-- (DrawRobMarker), because Config.Rob.Robs.OilRig_1 is just a normal
-- entry there. This file only starts once that marker's hacktype (3)
-- hands off control to it.
-- ============================================================

local C = Config.OilRig
local GUARD_GROUP = GetHashKey('OILRIG_GUARDS')

local startPeds  = {}
local zones      = { crates = {}, laptop = nil, dropoff = nil }
local rigBlip    = nil
local guardPeds  = {}
local revealBlips = {}
local revealToken = 0
local watching   = false
local looting    = false
local carryingBag = false

local function notify(msg, typ)
    TriggerEvent('esx:showNotification', msg, typ)
end

local function loadModel(hash)
    if HasModelLoaded(hash) then return true end
    RequestModel(hash)
    local timeout = GetGameTimer() + 10000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

local function addBlip(coords, sprite, colour, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- ----------------------------------------------------------------------
-- Relationship groups (every client needs these, not just the leader's --
-- when network ownership of a guard migrates, the new owner still needs
-- to know it's hostile).
-- ----------------------------------------------------------------------
CreateThread(function()
    AddRelationshipGroup('OILRIG_GUARDS')
    SetRelationshipBetweenGroups(0, GUARD_GROUP, GUARD_GROUP)
    SetRelationshipBetweenGroups(5, GUARD_GROUP, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GUARD_GROUP)
end)

-- Decorative peds at the start marker (the marker itself, from
-- client.lua's generic loop, handles the actual E-key interaction).
CreateThread(function()
    for _, v in ipairs(C.startPeds or {}) do
        local hash = GetHashKey(v.ped)
        if loadModel(hash) then
            local ped = CreatePed(4, hash, v.pos.x, v.pos.y, v.pos.z - 0.95, v.heading, false, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetModelAsNoLongerNeeded(hash)
            startPeds[#startPeds + 1] = ped
        end
    end
end)

-- ----------------------------------------------------------------------
-- Travel -> arrival
-- ----------------------------------------------------------------------
local function watchArrival()
    if watching then return end
    watching = true
    CreateThread(function()
        while watching do
            local dist = #(GetEntityCoords(PlayerPedId()) - C.middleArea)
            if dist <= C.arriveRadius then
                watching = false
                TriggerServerEvent('oilrig:server:arrived')
                break
            end
            Wait(dist > 300.0 and 2000 or 500)
        end
    end)
end

RegisterNetEvent('oilrig:client:begin', function()
    if rigBlip and DoesBlipExist(rigBlip) then RemoveBlip(rigBlip) end
    rigBlip = addBlip(C.middleArea, 621, 1, 'Oil Rig')
    SetNewWaypoint(C.middleArea.x, C.middleArea.y)
    notify(C.strings.heist_info)
    watchArrival()
end)

-- ----------------------------------------------------------------------
-- Guards
-- ----------------------------------------------------------------------
RegisterNetEvent('oilrig:client:spawnGuards', function(guardCount)
    CreateThread(function()
        local netIds = {}
        local weapons = C.guards.weapons
        local peds = C.guards.peds

        for i = 1, math.min(guardCount or #peds, #peds) do
            local g = peds[i]
            local hash = GetHashKey(g.model)
            if loadModel(hash) then
                RequestCollisionAtCoord(g.coords.x, g.coords.y, g.coords.z)
                local ped = CreatePed(4, hash, g.coords.x, g.coords.y, g.coords.z, g.heading, true, true)

                if ped ~= 0 and DoesEntityExist(ped) then
                    SetEntityAsMissionEntity(ped, true, true)
                    SetPedRelationshipGroupHash(ped, GUARD_GROUP)
                    SetPedAccuracy(ped, C.guards.accuracy)
                    SetPedArmour(ped, C.guards.armour)
                    SetPedCanSwitchWeapon(ped, true)
                    SetPedDropsWeaponsWhenDead(ped, false)
                    SetPedFleeAttributes(ped, 0, false)
                    SetPedCombatAttributes(ped, 46, true)
                    SetPedCombatAbility(ped, 2)
                    SetPedAlertness(ped, 3)
                    GiveWeaponToPed(ped, GetHashKey(weapons[math.random(#weapons)]), 250, false, true)
                    TaskGuardCurrentPosition(ped, C.guards.guardRadius, C.guards.guardRadius, true)
                    FreezeEntityPosition(ped, true) -- held until collision streams in, see below

                    guardPeds[#guardPeds + 1] = ped
                    netIds[#netIds + 1] = NetworkGetNetworkIdFromEntity(ped)
                end
                SetModelAsNoLongerNeeded(hash)
            end
            Wait(50)
        end

        TriggerServerEvent('oilrig:server:guards', netIds)

        Wait(2500)
        for _, ped in ipairs(guardPeds) do
            if DoesEntityExist(ped) then FreezeEntityPosition(ped, false) end
        end
    end)
end)

-- ----------------------------------------------------------------------
-- ox_target zones: server sends the full list of what should exist,
-- client just makes its zones match.
-- ----------------------------------------------------------------------
local function addCrateZone(idx)
    local cfg = C.crates[idx]
    if not cfg then return end
    zones.crates[idx] = exports.ox_target:addBoxZone({
        coords = cfg.coords,
        size = vec3(1.4, 2.4, 2.0),
        rotation = cfg.heading,
        debug = false,
        options = {
            {
                name = 'oilrig_crate_' .. idx,
                icon = 'fa-solid fa-box-open',
                label = 'Search Crate',
                distance = 1.5,
                onSelect = function()
                    TriggerServerEvent('oilrig:server:lootStart', idx)
                end,
            },
        },
    })
end

local function addLaptopZone()
    zones.laptop = exports.ox_target:addBoxZone({
        coords = C.laptop.coords,
        size = vec3(0.9, 0.8, 2.0),
        rotation = C.laptop.heading,
        debug = false,
        options = {
            {
                name = 'oilrig_laptop',
                icon = 'fa-solid fa-laptop-code',
                label = 'Hack Laptop',
                distance = 1.5,
                onSelect = function()
                    TriggerServerEvent('oilrig:server:hackStart')
                end,
            },
        },
    })
end

local function addDropoffZone()
    zones.dropoff = exports.ox_target:addBoxZone({
        coords = C.escape.dropoff,
        size = vec3(2.5, 2.5, 2.0),
        rotation = 0.0,
        debug = false,
        options = {
            {
                name = 'oilrig_dropoff',
                icon = 'fa-solid fa-money-bill-transfer',
                label = 'Taslim Kardan Kif',
                distance = 2.0,
                onSelect = function()
                    TriggerServerEvent('oilrig:server:deliver')
                end,
            },
        },
    })
end

RegisterNetEvent('oilrig:client:sync', function(payload)
    local want = {}
    for _, idx in ipairs(payload.crates or {}) do want[idx] = true end

    for idx, zoneId in pairs(zones.crates) do
        if not want[idx] then
            exports.ox_target:removeZone(zoneId, true)
            zones.crates[idx] = nil
        end
    end
    for idx in pairs(want) do
        if not zones.crates[idx] then addCrateZone(idx) end
    end

    if payload.laptop and not zones.laptop then
        addLaptopZone()
    elseif not payload.laptop and zones.laptop then
        exports.ox_target:removeZone(zones.laptop, true)
        zones.laptop = nil
    end
end)

-- ----------------------------------------------------------------------
-- Hack (ps-ui, all Config.OilRig.hackStages must pass)
-- ----------------------------------------------------------------------
local function runStage(stage)
    local p = promise.new()
    local function cb(success) p:resolve(success and true or false) end

    if stage.type == 'varhack' then
        exports['ps-ui']:VarHack(cb, stage.blocks or 5, stage.time or 20)
    elseif stage.type == 'scrambler' then
        exports['ps-ui']:Scrambler(cb, stage.mode or 'alphanumeric', stage.time or 30, stage.mirrored or 0)
    else
        return false
    end
    return Citizen.Await(p)
end

RegisterNetEvent('oilrig:client:startHack', function()
    CreateThread(function()
        local ped = PlayerPedId()
        local dict = 'anim@heists@prison_heiststation@cop_reactions'
        if loadAnimDict(dict) then
            TaskPlayAnim(ped, dict, 'cop_b_idle', 8.0, 8.0, -1, 1, 0, false, false, false)
        end

        local ok = true
        for _, stage in ipairs(C.hackStages) do
            if not runStage(stage) then
                ok = false
                break
            end
        end

        ClearPedTasks(ped)
        TriggerServerEvent('oilrig:server:hackResult', ok)
    end)
end)

RegisterNetEvent('oilrig:client:reveal', function(list)
    local blips = {}
    for _, idx in ipairs(list or {}) do
        local cfg = C.crates[idx]
        if cfg then
            local blip = AddBlipForRadius(cfg.coords.x, cfg.coords.y, cfg.coords.z, C.revealRadius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, 1)
            SetBlipAlpha(blip, 250)
            SetBlipAsShortRange(blip, true)
            blips[#blips + 1] = blip
            revealBlips[#revealBlips + 1] = blip
        end
    end

    local token = revealToken
    CreateThread(function()
        for alpha = 250, 0, -1 do
            if token ~= revealToken then return end
            for _, blip in ipairs(blips) do
                if DoesBlipExist(blip) then SetBlipAlpha(blip, alpha) end
            end
            Wait(500)
        end
        for _, blip in ipairs(blips) do
            if DoesBlipExist(blip) then RemoveBlip(blip) end
        end
    end)
end)

-- ----------------------------------------------------------------------
-- Looting
-- ----------------------------------------------------------------------
RegisterNetEvent('oilrig:client:lootCrate', function(idx)
    if looting then
        TriggerServerEvent('oilrig:server:lootCancel', idx)
        return
    end
    looting = true

    local ped = PlayerPedId()
    local dict = 'mp_take_money_mg'
    if loadAnimDict(dict) then
        TaskPlayAnim(ped, dict, 'stand_cash_in_bag_loop', 1.0, 1.0, -1, 1, 0, false, false, false)
    end

    TriggerEvent('mythic_progbar:client:progress', {
        name = 'oilrig_loot',
        duration = C.lootTime * 1000,
        label = 'LOOTING',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        ClearPedTasks(ped)
        looting = false
        if cancelled then
            TriggerServerEvent('oilrig:server:lootCancel', idx)
        else
            TriggerServerEvent('oilrig:server:lootDone', idx)
        end
    end)
end)

-- ----------------------------------------------------------------------
-- Escape (leader only -- see oilrig_server.lua's oilrig:server:deliver)
-- ----------------------------------------------------------------------
RegisterNetEvent('oilrig:client:escapeBegin', function()
    carryingBag = true
    SetNewWaypoint(C.escape.dropoff.x, C.escape.dropoff.y)
    if not zones.dropoff then addDropoffZone() end
    CreateThread(function()
        while carryingBag do
            SetRunSprintMultiplierForPlayer(PlayerId(), C.escape.speedMultiplier)
            Wait(0)
        end
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end)
end)

-- ----------------------------------------------------------------------
-- Reset / cleanup
-- ----------------------------------------------------------------------
local function clearLocal()
    watching = false
    carryingBag = false
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

    for idx, zoneId in pairs(zones.crates) do
        exports.ox_target:removeZone(zoneId, true)
        zones.crates[idx] = nil
    end
    if zones.laptop then exports.ox_target:removeZone(zones.laptop, true); zones.laptop = nil end
    if zones.dropoff then exports.ox_target:removeZone(zones.dropoff, true); zones.dropoff = nil end

    if rigBlip and DoesBlipExist(rigBlip) then RemoveBlip(rigBlip) end
    rigBlip = nil

    revealToken = revealToken + 1
    for _, blip in ipairs(revealBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    revealBlips = {}

    for _, ped in ipairs(guardPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    guardPeds = {}
end

RegisterNetEvent('oilrig:client:reset', clearLocal)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearLocal()
    for _, ped in ipairs(startPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
end)

CreateThread(function()
    Wait(3000)
    TriggerServerEvent('oilrig:server:requestState')
end)
