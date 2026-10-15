-------------------------------------------------------------------
-- NOTE: ambient zombies now live on the WHOLE ISLAND (see ISLAND ZOMBIES
-- below + Config.Territory.Island). Regular zones no longer spawn their
-- own zombies (no zombieTier); only the Boss Zone's extra wave remains.
--
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

-------------------------------------------------------------------
-- Zombies must never chase the player outside their OWN zone's
-- radius, no matter how big despawnRadius is - that's the whole
-- point of "territory is dangerous, the rest of the map isn't". So
-- this checks the player's distance from each zombie's HOME zone
-- (not just raw distance from the zombie itself) and immediately
-- drops/deletes it the moment the player steps outside that zone's
-- boundary, before combat AI has a chance to drag it further.
-------------------------------------------------------------------
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
            local zone = Zones[data.zoneIndex]
            local outsideZone = zone and (#(playerCoords - zone.coords) > zone.radius + 15.0) -- small buffer so it isn't a hard line

            if outsideZone then
                -- player left this zombie's territory entirely - stop
                -- the chase right now instead of letting TaskCombatPed
                -- keep dragging it along at raw despawnRadius distance
                DeleteEntity(ped)
                ActiveZombies[ped] = nil
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
-- ISLAND ZOMBIES (Config.Territory.Island.zombies)
-- Zombies exist ONLY on the island (the big circle drawn on the map by
-- client/territory.lua) and never inside its Safe zones. They are local
-- to each player. Everything is configured by the numbers in
-- Island.zombies: maxZombie / spawnCooldown / spawnRadius / maxRadius /
-- fireChance / bombChance / speed / damage.
--   * damageMode 'combat' (default): the game's own melee AI - they run
--     at you and visibly punch/claw you; meleeDamageScale scales that.
--   * damageMode 'script': they chase with TaskGoToEntity and hit for
--     exactly the HP in damage[1]..[2] (with a punch animation).
--   * fire   : spawns burning (double health so it lives long enough).
--   * bomb   : red blip; explodes when it reaches the player or dies
--              next to them.
-------------------------------------------------------------------
local IslandCfg   = Config.Territory and Config.Territory.Island
local IZ          = IslandCfg and IslandCfg.zombies
local IslandZombies = {}   -- [ped] = { dmg, bomb, fire, blip, lastHit, lastTask, deadSince, exploded }
local LastIslandSpawn = 0

local function InsideIsland(x, y)
    local dx, dy = x - IslandCfg.coords.x, y - IslandCfg.coords.y
    return (dx * dx + dy * dy) <= (IslandCfg.radius * IslandCfg.radius)
end

local function InIslandSafeZone(c)
    for _, s in ipairs(IslandCfg.safeZones or {}) do
        if #(vector3(c.x, c.y, c.z) - s.coord) <= s.radius then return true end
    end
    return false
end

local function RemoveIslandZombie(ped, data)
    if data and data.blip and DoesBlipExist(data.blip) then RemoveBlip(data.blip) end
    if DoesEntityExist(ped) then DeleteEntity(ped) end
    IslandZombies[ped] = nil
end

local function ClearIslandZombies()
    for ped, data in pairs(IslandZombies) do RemoveIslandZombie(ped, data) end
end

local function ExplodeIslandZombie(ped, data)
    if data.exploded then return end
    data.exploded = true
    local c = GetEntityCoords(ped)
    AddExplosion(c.x, c.y, c.z, IZ.bombExplosionType or 0, IZ.bombExplosionScale or 0.4, true, false, 0.4)
    if data.blip and DoesBlipExist(data.blip) then RemoveBlip(data.blip) data.blip = nil end
    if DoesEntityExist(ped) and not IsEntityDead(ped) then SetEntityHealth(ped, 0) end
end

local function SpawnIslandZombie(pc)
    local models = IZ.models or (Config.Territory.ZombieTiers and Config.Territory.ZombieTiers.normal and Config.Territory.ZombieTiers.normal.models)
    if not models or #models == 0 then return false end

    local angle = math.random() * 2 * math.pi
    local dist = math.min(IZ.spawnRadius or 40, 40) * (0.4 + math.random() * 0.6)
    local sx, sy = pc.x + math.cos(angle) * dist, pc.y + math.sin(angle) * dist
    if not InsideIsland(sx, sy) then return false end

    local found, gz = GetGroundZFor_3dCoord(sx + 0.0, sy + 0.0, pc.z + 30.0, false)
    if not found then return false end
    if InIslandSafeZone({ x = sx, y = sy, z = gz }) then return false end

    local hash = RequestZombieModel(models[math.random(1, #models)])
    if not hash then return false end

    local ped = CreatePed(4, hash, sx, sy, gz, math.random(0, 359) + 0.0, true, true)
    if not DoesEntityExist(ped) then return false end

    local roll = math.random(100)
    local fire = roll <= (IZ.fireChance or 0)
    local bomb = (not fire) and roll <= ((IZ.fireChance or 0) + (IZ.bombChance or 0))

    local speed = math.random((IZ.speed and IZ.speed[1]) or 5, (IZ.speed and IZ.speed[2]) or 10)
    local health = (IZ.health or 150) * (fire and 2 or 1)

    SetEntityAsMissionEntity(ped, true, true)
    SetPedRelationshipGroupHash(ped, EnsureRelationshipGroup())
    SetPedFleeAttributes(ped, 0, false)
    SetEntityMaxHealth(ped, health)
    SetEntityHealth(ped, health)
    SetPedMoveRateOverride(ped, (IZ.moveRateBase or 0.8) + speed * (IZ.moveRatePerSpeed or 0.12))
    SetPedCanRagdoll(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if IZ.damageMode ~= 'script' then
        -- same setup as the Boss Zone wave: real melee fighters that never back off
        SetPedCombatAttributes(ped, 46, true)   -- can fight unarmed
        SetPedCombatAttributes(ped, 5, true)    -- always fights
        SetPedCombatMovement(ped, 2)            -- advances on the player
        SetPedCombatRange(ped, 0)               -- close range
    end
    TaskWanderStandard(ped, 10.0, 10)

    local blip
    if bomb then
        blip = AddBlipForEntity(ped)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.7)
    end
    if fire then StartEntityFire(ped) end

    IslandZombies[ped] = {
        dmg = math.random((IZ.damage and IZ.damage[1]) or 3, (IZ.damage and IZ.damage[2]) or 5),
        dmgMin = (IZ.damage and IZ.damage[1]) or 3, dmgMax = (IZ.damage and IZ.damage[2]) or 5,
        bomb = bomb, fire = fire, blip = blip, lastHit = 0, lastTask = 0,
    }
    return true
end

local function MaintainIslandZombies(playerPed, pc)
    local now = GetGameTimer()
    local playerInVehicle = IsPedInAnyVehicle(playerPed, false)

    for ped, data in pairs(IslandZombies) do
        if not DoesEntityExist(ped) then
            RemoveIslandZombie(ped, data)
        elseif IsEntityDead(ped) then
            if data.bomb and not data.exploded and #(GetEntityCoords(ped) - pc) <= (IZ.bombDeathRange or 6.0) then
                ExplodeIslandZombie(ped, data)
            end
            data.deadSince = data.deadSince or now
            if now - data.deadSince > 8000 then RemoveIslandZombie(ped, data) end
        else
            local zc = GetEntityCoords(ped)
            local dist = #(zc - pc)
            if dist > (IZ.maxRadius or 75) or InIslandSafeZone(zc) or not InsideIsland(zc.x, zc.y) then
                RemoveIslandZombie(ped, data)
            elseif dist <= (IZ.detectRange or IZ.maxRadius or 75) then
                if IZ.damageMode == 'script' then
                    if now - data.lastTask > 3000 then
                        data.lastTask = now
                        TaskGoToEntity(ped, playerPed, -1, 1.2, 2.0, 1073741824, 0)
                    end
                else
                    -- the game's melee AI: attack as soon as the player is in range, and
                    -- re-issue the order if the zombie ever drops out of combat
                    if not data.aggro or (now - data.lastTask > 4000 and not IsPedInCombat(ped, playerPed)) then
                        data.aggro, data.lastTask = true, now
                        TaskCombatPed(ped, playerPed, 0, 16)
                    end
                end
                if data.bomb and dist <= (IZ.bombTriggerRange or 3.0) then
                    ExplodeIslandZombie(ped, data)
                elseif IZ.damageMode == 'script' and dist <= (IZ.attackRange or 1.8) and not playerInVehicle
                    and now - data.lastHit >= (IZ.attackIntervalMs or 1200) then
                    data.lastHit = now
                    -- face the player and throw a punch so the hit is visible
                    local dx, dy = pc.x - zc.x, pc.y - zc.y
                    SetEntityHeading(ped, GetHeadingFromVector_2d(dx, dy))
                    RequestAnimDict('melee@unarmed@streamed_core')
                    if HasAnimDictLoaded('melee@unarmed@streamed_core') then
                        TaskPlayAnim(ped, 'melee@unarmed@streamed_core', 'short_90_punch', 8.0, -8.0, 600, 0, 0.0, false, false, false)
                        data.lastTask = 0 -- re-issue the chase right after the punch
                    end
                    ApplyDamageToPed(playerPed, math.random(data.dmgMin, data.dmgMax), false)
                end
            elseif data.aggro and dist > (IZ.detectRange or IZ.maxRadius or 75) * 1.5 then
                data.aggro = false
                TaskWanderStandard(ped, 10.0, 10)
            end
        end
    end
end

local MeleeScaleApplied = false
local function SetMeleeScale(on)
    local scale = tonumber(IZ.meleeDamageScale) or 1.0
    if on and scale ~= 1.0 and not MeleeScaleApplied then
        SetAiMeleeWeaponDamageModifier(scale)
        MeleeScaleApplied = true
    elseif not on and MeleeScaleApplied then
        SetAiMeleeWeaponDamageModifier(1.0)
        MeleeScaleApplied = false
    end
end

-- /islandzombies : prints why zombies are (not) spawning for YOU right now.
local LastIslandStatus = ''
RegisterCommand('islandzombies', function()
    if not (IslandCfg and IZ) then return print('[island zombies] Config.Territory.Island.zombies missing') end
    local pc = GetEntityCoords(PlayerPedId())
    local alive = 0
    for ped in pairs(IslandZombies) do if DoesEntityExist(ped) and not IsEntityDead(ped) then alive = alive + 1 end end
    local cd = math.max(0, math.ceil(((IZ.spawnCooldown or 60) * 1000 - (GetGameTimer() - LastIslandSpawn)) / 1000))
    local msg = ('island zombies | enabled=%s | on island=%s | in safe zone=%s | alive=%d/%d | next wave in %ds | mode=%s'):format(
        tostring(IslandCfg.Enabled ~= false and IZ.Enabled ~= false), tostring(InsideIsland(pc.x, pc.y)), tostring(InIslandSafeZone(pc)),
        alive, IZ.maxZombie or 2, cd, tostring(IZ.damageMode or 'combat'))
    print('[Unique_ALLGangs] ' .. msg)
    TriggerEvent('chat:addMessage', { color = { 255, 100, 100 }, args = { 'ZOMBIES', msg } })
end, false)

CreateThread(function()
    math.randomseed(GetGameTimer())
    while true do
        Wait(1000)
        if IslandCfg and IslandCfg.Enabled ~= false and IZ and IZ.Enabled ~= false then
            local playerPed = PlayerPedId()
            local pc = GetEntityCoords(playerPed)
            local active = InsideIsland(pc.x, pc.y) and not InIslandSafeZone(pc) and not IsEntityDead(playerPed)

            SetMeleeScale(active)
            if active then
                local now = GetGameTimer()
                local alive = 0
                for ped in pairs(IslandZombies) do
                    if DoesEntityExist(ped) and not IsEntityDead(ped) then alive = alive + 1 end
                end

                if alive < (IZ.maxZombie or 2) and now - LastIslandSpawn >= (IZ.spawnCooldown or 60) * 1000 then
                    local spawned = 0
                    for _ = 1, (IZ.maxZombie or 2) - alive do
                        if SpawnIslandZombie(pc) then spawned = spawned + 1 end
                    end
                    if spawned > 0 then LastIslandSpawn = now end
                end

                MaintainIslandZombies(playerPed, pc)
            elseif next(IslandZombies) ~= nil then
                -- left the island / entered a Safe zone / died: no zombies follow
                ClearIslandZombies()
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
    if IslandCfg then ClearIslandZombies() SetMeleeScale(false) end
    for hash in pairs(ModelsRequested) do
        SetModelAsNoLongerNeeded(hash)
    end
end)
