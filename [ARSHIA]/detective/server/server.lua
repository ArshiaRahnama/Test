--[[
    kq_detective — server logic, adapted for this server:
      * core framework: essentialmode + ESX bridge (Config.esxSettings.enabled)
      * revive hook: esx_ambulancejob:revivex ([JOB]/esx_uniquejobs)

    Player-death tracking used to only exist for QBCore (Config.qbSettings.enabled).
    On ESX that meant kq_detective could investigate dead NPCs, but never a
    downed/dead PLAYER — 'kq_detective:savePlayerInfo' / 'getPlayerInfo' were
    never registered. This version makes that pipeline framework-agnostic:
    whichever branch below populates `deadPlayers` / `playerDeathInfo`
    (ESX or QB), the same handlers serve both.
]]

-- Global on purpose (no `local`): server/forensics.lua reads/writes
-- playerDeathInfo[src].forensics for the fingerprint/ballistics feature.
playerDeathInfo = {}   -- [source] = { timeOfDeath, source = killerNetId, cause, bone, distance, forensics }
local deadPlayers = {}       -- array of server ids currently considered "dead"

local function SyncDeadPlayers()
    TriggerClientEvent('kq_detective:syncDeadPlayers', -1, deadPlayers)
end

local function AddDeadPlayer(src)
    for i = 1, #deadPlayers do
        if deadPlayers[i] == src then return end
    end
    table.insert(deadPlayers, src)
end

local function RemoveDeadPlayer(src)
    for i = #deadPlayers, 1, -1 do
        if deadPlayers[i] == src then
            table.remove(deadPlayers, i)
        end
    end
end

local function ClearDeadPlayer(src)
    playerDeathInfo[src] = nil
    RemoveDeadPlayer(src)
    SyncDeadPlayers()
end

--
-- Shared handlers (framework-agnostic)
--

RegisterServerEvent('kq_detective:savePlayerInfo')
AddEventHandler('kq_detective:savePlayerInfo', function(killerNetId, cause, bone, distance)
    local src = source

    -- Resolve the killer's server id from the networked entity id the victim's
    -- client sent us, so we can identify who to blame for forensics purposes.
    local killerServerId = nil
    local killerEntity = killerNetId and killerNetId ~= 0 and NetworkGetEntityFromNetworkId(killerNetId)
    if killerEntity and killerEntity ~= 0 then
        local owner = NetworkGetEntityOwner(killerEntity)
        if owner and owner > 0 then
            killerServerId = owner
        end
    end

    local forensics = {}
    if KQ_RollForensics then
        forensics = KQ_RollForensics(src, killerServerId, cause)
    end

    playerDeathInfo[src] = {
        timeOfDeath = GetGameTimer(),
        source = killerNetId,
        cause = cause,
        bone = bone,
        distance = distance,
        forensics = forensics,
    }

    AddDeadPlayer(src)
    SyncDeadPlayers()
end)

RegisterServerEvent('kq_detective:getPlayerInfo')
AddEventHandler('kq_detective:getPlayerInfo', function(targetSrc, ped)
    local info = playerDeathInfo[targetSrc]
    if not info then return end

    local payload = {
        source = info.source,
        cause = info.cause,
        bone = info.bone,
        distance = info.distance,
        sinceDeath = GetGameTimer() - info.timeOfDeath,
        -- Only flags go to the client — never the suspect's identifier itself.
        -- Whether evidence exists (and the serial, which is public/etched on
        -- the casing) is fine to reveal; who it belongs to is not.
        hasPrint = info.forensics and info.forensics.hasPrint or false,
        hasCasing = info.forensics and info.forensics.hasCasing or false,
        serial = info.forensics and info.forensics.serial or nil,
    }

    TriggerClientEvent('kq_detective:investigatePlayer', source, payload, ped)
end)

AddEventHandler('playerDropped', function()
    ClearDeadPlayer(source)
end)

--
-- QBCore (kept for portability, disabled on this server via config.lua)
--

if Config.qbSettings.enabled then
    if Config.qbSettings.useNewQBExport then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    local function RefreshDeadPlayers()
        local players = GetPlayers()
        local nowDead = {}

        for _, playerId in pairs(players) do
            local player = QBCore.Functions.GetPlayer(tonumber(playerId))

            if player and player.PlayerData and player.PlayerData.metadata then
                local meta = player.PlayerData.metadata
                if meta.isdead or meta.inlaststand then
                    table.insert(nowDead, tonumber(playerId))
                end
            end
        end

        deadPlayers = nowDead
        SyncDeadPlayers()
    end

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while true do
            RefreshDeadPlayers()
            Citizen.Wait(Config.qbSettings.deadPlayerRefreshTime)
        end
    end)

    AddEventHandler('hospital:server:RevivePlayer', function()
        ClearDeadPlayer(source)
    end)
end

--
-- ESX (this server's active framework)
--

if Config.esxSettings.enabled then
    -- essentialmode/client/modules/death.lua fires this on real death
    -- (TriggerServerEvent('esx:onPlayerDeath', data)). The client side of
    -- kq_detective (client.lua) listens for the same event and calls
    -- UploadDeathInfo(), which sends us 'kq_detective:savePlayerInfo' —
    -- handled generically above. Nothing else needed here for the death side.

    -- This server's ambulance job revives with 'esx_ambulancejob:revivex'
    -- ([JOB]/esx_uniquejobs/server/ambulance_main.lua), called either with
    -- an explicit target id or from the dying player themself.
    AddEventHandler('esx_ambulancejob:revivex', function(target)
        local src = target or source
        ClearDeadPlayer(src)
    end)

    -- Fallback in case other revive systems are ever added to this server.
    AddEventHandler('hospital:server:RevivePlayer', function()
        ClearDeadPlayer(source)
    end)
end
