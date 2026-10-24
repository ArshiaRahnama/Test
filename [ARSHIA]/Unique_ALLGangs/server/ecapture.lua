-- E-capture for the island zones (Config.Territory.ECapture). Rules copied from
-- Unique_Pvp's capture island:
--   * a gang member starts the capture from the E menu; the zone's owner is the defender
--   * it runs for CaptureTime seconds
--   * score = kills during the capture + 10 per member standing in the zone
--   * attackers win when their score is higher; a tie (or no attacker in zone) keeps the owner
--   * kills: an attacker's death gives the defenders a kill, a defender's death gives the attackers one
--   * the winners in the zone share RewardMoney; every attacker in zone may get zombie_essence
--   * a zone can be captured again only after CooldownMins

local EC        = {}   -- [zoneKey] = { gang, starter, owner, startedAt, endsAt, attackerKills, defenderKills }
local Zombies   = {}   -- [zoneKey] = { entities }
local LastTaken = {}   -- [zoneKey] = os.time() of the last finished capture

local function ecCfg() return Config.Territory and Config.Territory.ECapture end
local function zoneCfg(k) return ZoneConfigByKey[k] end

local function isEZone(k)
    for _, z in ipairs(ecCfg().Zones) do if z == k then return true end end
    return false
end

local function gangOf(x)
    local g = x and x.gang and x.gang.name
    if not g or g == '' or g == 'nogang' then return nil end
    return g
end

local function inZone(src, z)
    local p = GetEntityCoords(GetPlayerPed(src))
    return #(p - z.coord) <= (z.radius or 50.0) + 2.0
end

local function notify(src, msg) TriggerClientEvent('esx:showNotification', src, msg) end

local function notifyZone(k, msg)
    local z = zoneCfg(k)
    for _, pid in ipairs(GetPlayers()) do
        local id = tonumber(pid)
        if z and inZone(id, z) then notify(id, msg) end
    end
end

-- the people standing in the zone, by side
local function sides(k)
    local z, st, c = zoneCfg(k), Territories[k], EC[k]
    local att, def = {}, 0
    for _, pid in ipairs(GetPlayers()) do
        local id = tonumber(pid)
        local g = gangOf(ESX.GetPlayerFromId(id))
        if g and z and inZone(id, z) then
            if g == c.gang then
                att[#att + 1] = id
            elseif st and (g == st.owner or AreGangsAllied(g, st.owner)) then
                def = def + 1
            end
        end
    end
    return att, def
end

local function scoreText(k)
    local c = EC[k]
    if not c then return '' end
    local att, def = sides(k)
    local a = c.attackerKills + #att * 10
    local d = c.defenderKills + def * 10
    return ('%s %d - %d %s'):format(c.gang, a, d, c.owner or 'Azad')
end

local function broadcast(k)
    local c = EC[k]
    if not c then
        TriggerClientEvent('ecapture:progress', -1, k, 0, 0, nil, '')
        return
    end
    local elapsed = os.time() - c.startedAt
    TriggerClientEvent('ecapture:progress', -1, k, elapsed, ecCfg().CaptureTime, c.gang, scoreText(k))
end

-- Zombies (networked, server spawned)
local function SpawnZombies(k, z, cfg)
    local hash = GetHashKey(cfg.ZombieModel)
    Zombies[k] = {}
    for _ = 1, cfg.ZombiesPerCapture do
        local ang = math.random() * 2 * math.pi
        local r = math.random() * cfg.ZombieSpawnRadius
        local ped = CreatePed(4, hash, z.coord.x + math.cos(ang) * r, z.coord.y + math.sin(ang) * r, z.coord.z, math.random(0, 359) + 0.0, true, true)
        if ped and ped ~= 0 then table.insert(Zombies[k], ped) end
    end
    CreateThread(function()
        Wait(1000)
        local ids = {}
        for _, ped in ipairs(Zombies[k] or {}) do table.insert(ids, NetworkGetNetworkIdFromEntity(ped)) end
        TriggerClientEvent('ecapture:zombieNet', -1, k, ids, cfg.AggroRange)
    end)
end

local function DespawnZombies(k)
    for _, ped in ipairs(Zombies[k] or {}) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    Zombies[k] = nil
end

local function finish(k, winnerGang, attList)
    local cfg = ecCfg()
    local c = EC[k]
    EC[k] = nil
    LastTaken[k] = os.time()
    DespawnZombies(k)
    if winnerGang == c.gang then
        CaptureZone(k, c.gang, c.starter)
        local share = math.floor(cfg.RewardMoney / math.max(1, #attList))
        for _, id in ipairs(attList) do
            local xp = ESX.GetPlayerFromId(id)
            if xp then
                xp.addAccountMoney('black_money', share)
                if math.random(1, 100) <= cfg.ZombieEssenceChance then xp.addInventoryItem('zombie_essence', 1) end
                notify(id, ('Zone %s be dast amad! Pool: $%d'):format(zoneCfg(k).label or k, share))
            end
        end
    else
        notifyZone(k, ('Gereftan %s nakam ond. %s moafagh shod.'):format(zoneCfg(k).label or k, c.owner or 'Mohafez'))
    end
    TriggerClientEvent('ecapture:end', -1, k, winnerGang == c.gang)
    broadcast(k)
end

-- the E menu asks who holds the zone and whether a capture is running
RegisterNetEvent('ecapture:info')
AddEventHandler('ecapture:info', function(k)
    local src = source
    if not isEZone(k) then return end
    local st = Territories[k]
    TriggerClientEvent('ecapture:infoReply', src, k, st and st.owner or nil, EC[k] ~= nil)
end)

-- starts from the E menu
RegisterNetEvent('ecapture:start')
AddEventHandler('ecapture:start', function(k)
    local src = source
    local cfg = ecCfg()
    if not cfg or not cfg.Enabled or not isEZone(k) then return end
    local z, st = zoneCfg(k), Territories[k]
    local gang = gangOf(ESX.GetPlayerFromId(src))
    if not z or not st or not gang then return notify(src, 'Baraye gereftan bayad aza-ye gang bashi.') end
    if not inZone(src, z) then return end
    if st.owner == gang then return notify(src, 'In zone az ghabl moal-e gang-e shomast.') end
    if EC[k] then return notify(src, 'Gereftan in zone ghablan shoro shode.') end
    if LastTaken[k] and os.time() - LastTaken[k] < cfg.CooldownMins * 60 then
        return notify(src, 'In zone ta chand daghighe digar gerefte nemishe.')
    end
    local now = os.time()
    EC[k] = { gang = gang, starter = src, owner = st.owner, startedAt = now, endsAt = now + cfg.CaptureTime,
              attackerKills = 0, defenderKills = 0 }
    notifyZone(k, ('%s shoro be gereftan %s kard! (%d sanie)'):format(gang, z.label or k, cfg.CaptureTime))
    SpawnZombies(k, z, cfg)
    broadcast(k)
end)

-- the PvP rule for kills: a death during the capture scores for the other side
AddEventHandler('island_death:died', function()
    local src = source
    local g = gangOf(ESX.GetPlayerFromId(src))
    if not g then return end
    for k, c in pairs(EC) do
        if g == c.gang then c.defenderKills = c.defenderKills + 1
        elseif g == c.owner then c.attackerKills = c.attackerKills + 1 end
    end
end)

-- one tick per second: the timer, the zone check, the scores
CreateThread(function()
    while true do
        Wait(1000)
        local cfg = ecCfg()
        if cfg and cfg.Enabled then
            for k, c in pairs(EC) do
                local att = sides(k)
                if #att == 0 then
                    EC[k] = nil
                    DespawnZombies(k)
                    notifyZone(k, 'Gereftan zone lagv shod (kasi az gang-e shoma dar zone nabud).')
                    TriggerClientEvent('ecapture:end', -1, k, false)
                    broadcast(k)
                elseif os.time() >= c.endsAt then
                    local a, d = sides(k)
                    local aScore = c.attackerKills + #a * 10
                    local dScore = c.defenderKills + d * 10
                    local winner = (aScore > dScore or not c.owner) and c.gang or c.owner
                    finish(k, winner, a)
                else
                    broadcast(k)
                end
            end
        end
    end
end)

-- blips: who holds each E zone right now, and whether a capture is running
RegisterNetEvent('ecapture:ownersAll')
AddEventHandler('ecapture:ownersAll', function()
    local src = source
    local out = {}
    for _, k in ipairs(ecCfg().Zones) do
        local st = Territories[k]
        out[k] = { owner = st and st.owner or nil, running = EC[k] ~= nil }
    end
    TriggerClientEvent('ecapture:ownersAllReply', src, out)
end)

