-- Unique_OilRig | client.lua
--
-- The client only DRAWS things and reports what the player did. All rules
-- (cooldown, cops, party, items, rewards, who may loot what) live in server.lua.

local C = Config.OilRig
local S = Config.Strings

math.randomseed(GetGameTimer())

local GUARD_GROUP = GetHashKey('OILRIG_GUARDS')

local startPeds   = {}
local startZone   = nil
local zones       = { crates = {}, laptop = nil }
local rigBlip     = nil
local guardPeds   = {}
local revealBlips = {}
local revealToken = 0
local watching    = false
local looting     = false

-- ----------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------
local function notify(msg)
    TriggerEvent('esx:showNotification', msg)
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
-- Relationship groups
-- Must exist on EVERY client, not just the leader's: when the guards' network
-- owner changes, the new owner needs to know they hate players too.
-- ----------------------------------------------------------------------
CreateThread(function()
    AddRelationshipGroup('OILRIG_GUARDS')
    SetRelationshipBetweenGroups(0, GUARD_GROUP, GUARD_GROUP)
    SetRelationshipBetweenGroups(5, GUARD_GROUP, GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GUARD_GROUP)
end)

-- ----------------------------------------------------------------------
-- Start peds + ox_target
-- ----------------------------------------------------------------------
CreateThread(function()
    for _, v in ipairs(C.startHeist.peds) do
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

    startZone = exports.ox_target:addBoxZone({
        coords = C.startHeist.pos,
        size = vec3(1.6, 2.4, 2.2),
        rotation = 20.0,
        debug = false,
        options = {
            {
                name = 'oilrig_start',
                icon = 'fa-solid fa-mask',
                label = S.t_heist,
                distance = 2.0,
                onSelect = function()
                    if C.requireArmed and not Config.TestMode and not IsPedArmed(PlayerPedId(), 4) then
                        notify(S.need_weapon)
                        return
                    end
                    TriggerServerEvent('oilrig:server:start')
                end,
            },
        },
    })
end)

-- ----------------------------------------------------------------------
-- Heist begins (sent to the leader and the close party members)
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

RegisterNetEvent('oilrig:client:begin', function(isLeader)
    if rigBlip and DoesBlipExist(rigBlip) then RemoveBlip(rigBlip) end
    rigBlip = addBlip(C.middleArea, 181, 1, S.oilrig_blip)
    SetNewWaypoint(C.middleArea.x, C.middleArea.y)
    notify(S.heist_info)
    if isLeader then watchArrival() end
end)

-- ----------------------------------------------------------------------
-- Guards (spawned by the leader's client as networked peds)
-- ----------------------------------------------------------------------
RegisterNetEvent('oilrig:client:spawnGuards', function()
    CreateThread(function()
        local netIds = {}
        local weapons = C.guards.weapons

        for _, g in ipairs(C.guards.peds) do
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
                    -- hold still until floor collision has streamed in, otherwise they fall through the rig
                    FreezeEntityPosition(ped, true)

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
-- Target zones: the server sends the full list of what should exist,
-- the client just makes its zones match.
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
                label = S.t_search,
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
                label = S.t_laptop,
                distance = 1.5,
                onSelect = function()
                    TriggerServerEvent('oilrig:server:hackStart')
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
-- Hack (ps-ui minigames, all stages must pass)
-- ----------------------------------------------------------------------
local function runStage(stage)
    local p = promise.new()
    local function cb(success) p:resolve(success and true or false) end

    if stage.type == 'varhack' then
        exports['ps-ui']:VarHack(cb, stage.blocks or 5, stage.time or 20)
    elseif stage.type == 'scrambler' then
        exports['ps-ui']:Scrambler(cb, stage.mode or 'alphanumeric', stage.time or 30, stage.mirrored or 0)
    elseif stage.type == 'circle' then
        exports['ps-ui']:Circle(cb, stage.circles or 3, stage.time or 10)
    elseif stage.type == 'maze' then
        exports['ps-ui']:Maze(cb, stage.time or 30)
    else
        print(('[Unique_OilRig] unknown hack stage type: %s'):format(tostring(stage.type)))
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
        for _, stage in ipairs(C.hack.stages) do
            if not runStage(stage) then
                ok = false
                break
            end
        end

        ClearPedTasks(ped)
        TriggerServerEvent('oilrig:server:hackResult', ok)
    end)
end)

-- After a successful hack: fading red circles on the crates (leader + party only)
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
            if token ~= revealToken then return end -- heist was reset, blips already removed
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
-- Looting (server already marked the crate as ours)
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
        label = S.looting,
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
-- Reset / cleanup
-- ----------------------------------------------------------------------
local function clearLocal()
    watching = false

    for idx, zoneId in pairs(zones.crates) do
        exports.ox_target:removeZone(zoneId, true)
        zones.crates[idx] = nil
    end
    if zones.laptop then
        exports.ox_target:removeZone(zones.laptop, true)
        zones.laptop = nil
    end

    if rigBlip and DoesBlipExist(rigBlip) then RemoveBlip(rigBlip) end
    rigBlip = nil

    revealToken = revealToken + 1
    for _, blip in ipairs(revealBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    revealBlips = {}

    -- the server deletes the guards; this only covers peds we still own locally
    for _, ped in ipairs(guardPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    guardPeds = {}
end

RegisterNetEvent('oilrig:client:reset', clearLocal)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clearLocal()
    if startZone then exports.ox_target:removeZone(startZone, true) end
    for _, ped in ipairs(startPeds) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
end)

-- ----------------------------------------------------------------------
-- Ask the server for the current state (resource restart / player joins mid-heist)
-- ----------------------------------------------------------------------
CreateThread(function()
    Wait(3000)
    TriggerServerEvent('oilrig:server:requestState')
end)

AddEventHandler('esx:playerLoaded', function()
    Wait(3000)
    TriggerServerEvent('oilrig:server:requestState')
end)

-- ----------------------------------------------------------------------
-- Test mode helper: /oiltp start | rig
-- ----------------------------------------------------------------------
if Config.TestMode then
    RegisterCommand('oiltp', function(_, args)
        local where = args[1]
        local target
        if where == 'start' then
            target = C.startHeist.pos
        elseif where == 'rig' then
            target = C.middleArea + vector3(0.0, 0.0, 1.0)
        else
            notify('Estefade: /oiltp start  ya  /oiltp rig')
            return
        end
        local ped = PlayerPedId()
        RequestCollisionAtCoord(target.x, target.y, target.z)
        SetEntityCoords(ped, target.x, target.y, target.z, false, false, false, false)
    end)
end
