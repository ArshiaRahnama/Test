-------------------------------------------------------------------
-- TERRITORY ZOMBIES - ambient danger inside gang territory itself
-- ---------------------------------------------------------------
-- Every regular Territory Control zone (Config.Territory.Zones) is
-- always dangerous - zombies wander/attack there regardless of who
-- owns it, all the time. The Boss Zone additionally spawns a tougher
-- wave, but ONLY while it's actually open (same weekly window
-- server/territory.lua already announces via 'Territory:BossZoneState'
-- - this file just listens for that, it doesn't duplicate the
-- schedule logic).
--
-- Design choices, stated up front (same as the standalone version
-- this was adapted from):
--   - Zombies are spawned LOCALLY, per player - not synced between
--     players. Every player gets their own set, so nobody's fight is
--     blocked by someone else's, but two players standing together
--     won't see the exact same zombies. Ask for a server-authoritative
--     version if you want that instead - it's a much bigger, more
--     failure-prone undertaking I didn't want to guess my way through.
--   - A zombie only exists inside its zone's own radius. Nothing
--     spawns anywhere else on the map, gang territory or not.
--   - Attacking is handled by the game's own combat AI (TaskCombatPed)
--     once a zombie notices the player within its tier's detectRange -
--     this script only decides who's aggro'd and cleans up the rest.
-------------------------------------------------------------------

local Zones = {}          -- flat list: { coords=vector3, radius=n, tier=<ZombieTiers entry>, isBossZone=bool }
local ActiveZombies = {}  -- ActiveZombies[ped] = { zoneIndex = n, tier = <entry>, aggro = bool, deadSince = ms|nil }
local ModelsRequested = {}
local BossZoneOpen = false
local BossZoneIndex = nil -- filled in once Zones is built, if a Boss Zone entry exists

-------------------------------------------------------------------
-- Build the zone list once at resource start, pairing each zone with
-- its ZombieTiers entry (Config.Territory.ZombieTiers). A zone with
-- no zombieTier, or an unknown one, is simply skipped - no zombies
-- there, no error either.
-------------------------------------------------------------------
CreateThread(function()
    if not Config.Territory or not Config.Territory.ZombieTiers then return end

    for _, zoneCfg in ipairs(Config.Territory.Zones or {}) do
        local tier = Config.Territory.ZombieTiers[zoneCfg.zombieTier]
        if tier then
            Zones[#Zones + 1] = { coords = zoneCfg.coord, radius = zoneCfg.radius, tier = tier, isBossZone = false }
        end
    end

    local bz = Config.Territory.BossZone
    if bz and bz.Enabled and bz.zombieTier then
        local tier = Config.Territory.ZombieTiers[bz.zombieTier]
        if tier then
            Zones[#Zones + 1] = { coords = bz.coord, radius = bz.radius, tier = tier, isBossZone = true }
            BossZoneIndex = #Zones
        end
    end
end)

RegisterNetEvent('Territory:BossZoneState')
AddEventHandler('Territory:BossZoneState', function(open)
    BossZoneOpen = open
end)

local function RequestZombieModel(modelName)
    local hash = GetHashKey(modelName)
    if not ModelsRequested[hash] then
        RequestModel(hash)
        ModelsRequested[hash] = true
    end
    local waited = 0
    while not HasModelLoaded(hash) and waited < 3000 do
        Wait(50)
        waited = waited + 50
    end
    return HasModelLoaded(hash) and hash or nil
end

-------------------------------------------------------------------
-- Hostile relationship group, set up once - guarantees zombies attack
-- the player regardless of whatever other relationship groups this
-- server's other resources (gang wars, the Boss Zone before this
-- rewrite, etc.) may have configured.
-------------------------------------------------------------------
local ZombieRelationshipGroup = nil

local function EnsureRelationshipGroup()
    if ZombieRelationshipGroup then return ZombieRelationshipGroup end
    ZombieRelationshipGroup = GetHashKey('TERRITORY_ZOMBIE_HORDE')
    AddRelationshipGroup('TERRITORY_ZOMBIE_HORDE')
    SetRelationshipBetweenGroups(5, ZombieRelationshipGroup, GetHashKey('PLAYER')) -- 5 = hate
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), ZombieRelationshipGroup)
    SetRelationshipBetweenGroups(0, ZombieRelationshipGroup, ZombieRelationshipGroup) -- 0 = like, so they don't fight each other
    return ZombieRelationshipGroup
end

local function SpawnZombie(zoneIndex, spawnCoords, tier)
    local modelName = tier.models[math.random(1, #tier.models)]
    local hash = RequestZombieModel(modelName)
    if not hash then return end

    local ped = CreatePed(4, hash, spawnCoords.x, spawnCoords.y, spawnCoords.z, math.random(0, 359) + 0.0, true, true)
    if not DoesEntityExist(ped) then return end

    SetEntityAsMissionEntity(ped, true, true)
    SetPedRelationshipGroupHash(ped, EnsureRelationshipGroup())
    SetPedCombatAttributes(ped, 46, true)   -- can fight unarmed
    SetPedCombatAttributes(ped, 5, true)    -- always fights, never backs off
    SetPedFleeAttributes(ped, 0, false)     -- never flees
    SetPedCombatMovement(ped, 2)            -- willing to advance on the player
    SetPedCombatRange(ped, 0)               -- close-range/melee focus
    SetEntityMaxHealth(ped, tier.health)
    SetEntityHealth(ped, tier.health)
    SetPedMoveRateOverride(ped, tier.moveRate)
    SetPedCanRagdoll(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true) -- don't get distracted by ambient world events
    TaskWanderStandard(ped, 10.0, 10)

    ActiveZombies[ped] = { zoneIndex = zoneIndex, tier = tier, aggro = false }
end

-------------------------------------------------------------------
-- Per-zone top-up: spawn a couple more zombies near the player (never
-- outside the zone's own radius) if this zone is under its cap.
-------------------------------------------------------------------
local function MaintainZone(zoneIndex, zone, playerCoords)
    local aliveInZone = 0
    for _, data in pairs(ActiveZombies) do
        if data.zoneIndex == zoneIndex then aliveInZone = aliveInZone + 1 end
    end

    if aliveInZone < zone.tier.maxAlive then
        local toSpawn = math.min(2, zone.tier.maxAlive - aliveInZone) -- a couple at a time, not a wall of peds in one frame
        for _ = 1, toSpawn do
            local angle = math.random() * 2 * math.pi
            local dist = zone.tier.spawnRadius * (0.4 + math.random() * 0.6) -- not right on top of the player either
            local sx = playerCoords.x + math.cos(angle) * dist
            local sy = playerCoords.y + math.sin(angle) * dist

            -- keep the spawn point inside the zone's own radius so
            -- zombies never appear outside the territory itself
            local dxz, dyz = sx - zone.coords.x, sy - zone.coords.y
            if math.sqrt(dxz * dxz + dyz * dyz) <= zone.radius then
                SpawnZombie(zoneIndex, vector3(sx, sy, zone.coords.z + 1.0), zone.tier)
            end
        end
    end
end

local function MaintainZombies(playerPed, playerCoords)
    for ped, data in pairs(ActiveZombies) do
        if not DoesEntityExist(ped) then
            ActiveZombies[ped] = nil
        elseif IsEntityDead(ped) then
            -- leave the body for a few seconds so it doesn't just vanish mid-fight, then clean it up
            data.deadSince = data.deadSince or GetGameTimer()
            if GetGameTimer() - data.deadSince > 8000 then
                DeleteEntity(ped)
                ActiveZombies[ped] = nil
            end
        else
            local dist = #(GetEntityCoords(ped) - playerCoords)
            if dist > data.tier.despawnRadius then
                DeleteEntity(ped)
                ActiveZombies[ped] = nil
            elseif dist <= data.tier.detectRange and not data.aggro then
                data.aggro = true
                TaskCombatPed(ped, playerPed, 0, 16)
            elseif dist > data.tier.detectRange * 1.5 and data.aggro then
                -- player broke distance by enough that it's not worth chasing anymore
                data.aggro = false
                TaskWanderStandard(ped, 10.0, 10)
            end
        end
    end
end

-------------------------------------------------------------------
-- Instantly clear every Boss Zone zombie the moment it closes (it's
-- meant to go back to being safe outside its weekly window, not just
-- stop spawning NEW ones while old ones are still roaming around).
-------------------------------------------------------------------
CreateThread(function()
    local wasOpen = BossZoneOpen
    while true do
        Wait(1000)
        if wasOpen and not BossZoneOpen and BossZoneIndex then
            for ped, data in pairs(ActiveZombies) do
                if data.zoneIndex == BossZoneIndex then
                    if DoesEntityExist(ped) then DeleteEntity(ped) end
                    ActiveZombies[ped] = nil
                end
            end
        end
        wasOpen = BossZoneOpen
    end
end)

-------------------------------------------------------------------
-- Main loop
-------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(1000)
        if #Zones > 0 then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local anyMaintained = false

            for i, zone in ipairs(Zones) do
                local skip = zone.isBossZone and not BossZoneOpen
                if not skip then
                    local dist = #(playerCoords - zone.coords)
                    if dist <= zone.radius then
                        anyMaintained = true
                        MaintainZone(i, zone, playerCoords)
                    end
                end
            end

            if anyMaintained or next(ActiveZombies) ~= nil then
                MaintainZombies(playerPed, playerCoords)
            end
        end
    end
end)

-------------------------------------------------------------------
-- Cleanup: never leave zombies behind when the resource stops/
-- restarts, and never leave a requested model stuck loaded.
-------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for ped in pairs(ActiveZombies) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    ActiveZombies = {}
    for hash in pairs(ModelsRequested) do
        SetModelAsNoLongerNeeded(hash)
    end
end)
