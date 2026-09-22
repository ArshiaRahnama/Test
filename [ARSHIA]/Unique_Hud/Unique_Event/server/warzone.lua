--[[
    Unique_Event - WARZONE (server)

    Lobby auto-starts a match once MinPlayers are in. Players parachute onto the map,
    loot weapons from ground crates, fight inside a shrinking safe zone, can be downed and
    revived by a squadmate before bleeding out, and losers who die outside a squad's last
    life go to the Gulag for a 1v1 second chance. Last squad standing wins.

    Bugs fixed vs the original WarZone:
    - `setweapons` / cash / kill events are no longer trusted from the client; every gameplay
      change that matters (weapons, money, zone damage, kills) is decided and applied here
    - death is resolved with UE.ResolveKiller instead of a client-reported killer id
    - the match cannot get stuck: an empty lobby resets itself, and a match with everyone
      dead force-ends instead of waiting forever for a shrinking-to-zero circle
]]

local WZ = {}
UE.RegisterModule('warzone', WZ)

UE.DB.Ready(function()
    UE.DB.Exec([[CREATE TABLE IF NOT EXISTS ue_warzone_stats (
        identifier VARCHAR(64) NOT NULL PRIMARY KEY,
        name VARCHAR(64) NOT NULL DEFAULT '',
        wins INT NOT NULL DEFAULT 0,
        kills INT NOT NULL DEFAULT 0,
        deaths INT NOT NULL DEFAULT 0
    )]])
end)

local function bumpStat(identifier, name, field, amount)
    UE.DB.Exec('INSERT INTO ue_warzone_stats (identifier, name, ' .. field .. ') VALUES (?, ?, ?) ' ..
        'ON DUPLICATE KEY UPDATE ' .. field .. ' = ' .. field .. ' + VALUES(' .. field .. '), name = VALUES(name)',
        { identifier, name, amount })
end

-- ---------------------------------------------------------------------------
-- State
-- ---------------------------------------------------------------------------
local Lobby = {}                      -- ordered list of src in the lobby (pre-match)
local Match = nil                     -- the running match, or nil
local Squads = {}                     -- [squadId] = { id, name, members = {src,...} }
local PlayerSquad = {}                -- [src] = squadId
local nextSquadId = 1
local countdownThread = nil

local function newSquadFor(src)
    local id = nextSquadId nextSquadId = nextSquadId + 1
    Squads[id] = { id = id, members = { src } }
    PlayerSquad[src] = id
    return id
end

local function squadOf(src) return PlayerSquad[src] and Squads[PlayerSquad[src]] or nil end
local function squadmates(src)
    local sq = squadOf(src)
    if not sq then return {} end
    local out = {}
    for _, s in ipairs(sq.members) do if s ~= src then out[#out + 1] = s end end
    return out
end

-- ---------------------------------------------------------------------------
-- Lobby
-- ---------------------------------------------------------------------------
local function pushLobby()
    local mode = 'Squads (' .. Config.WarZone.SquadSize .. ')'
    local cd = countdownThread and countdownThread.endsAt and math.max(0, countdownThread.endsAt - os.time()) or nil
    for _, src in ipairs(Lobby) do
        TriggerClientEvent('ue:warzone:lobby', src, {
            players = #Lobby, needed = Config.WarZone.MinPlayers, mode = mode, map = 'SANDY SHORES', countdown = cd,
        })
    end
end

local function startCountdownIfReady()
    if Match then return end
    if #Lobby >= Config.WarZone.MinPlayers and not countdownThread then
        countdownThread = { endsAt = os.time() + Config.WarZone.LobbyCountdown }
        CreateThread(function()
            while countdownThread and os.time() < countdownThread.endsAt do
                Wait(1000)
                pushLobby()
                if #Lobby < Config.WarZone.MinPlayers then countdownThread = nil pushLobby() return end
            end
            if countdownThread then
                countdownThread = nil
                WZ.StartMatch()
            end
        end)
    end
end

local function tryJoinLobby(src)
    local ok, reason = UE.CanJoin(src, 'warzone')
    if not ok then return UE.Notify(src, reason, 'error') end
    if Match then return UE.Notify(src, 'A match is already in progress - try again shortly.', 'error') end
    if #Lobby >= Config.WarZone.MaxPlayers then return UE.Notify(src, 'The WarZone lobby is full.', 'error') end

    Lobby[#Lobby + 1] = src
    UE.Enter(src, 'warzone')
    UE.SetBucket(src, Config.Buckets.WarZoneLobby)
    UE.Teleport(Config.WarZone.LobbyCoord.x + math.random(-5, 5) + 0.0, Config.WarZone.LobbyCoord.y + math.random(-5, 5) + 0.0, Config.WarZone.LobbyCoord.z)
    newSquadFor(src)
    TriggerClientEvent('ue:warzone:joinLobby', src)
    UE.Notify(src, ('Joined the WarZone lobby (%d/%d).'):format(#Lobby, Config.WarZone.MinPlayers), 'success')
    pushLobby()
    startCountdownIfReady()
end
UE.Command({ 'wz' }, function(src) tryJoinLobby(src) end)

local function doLeaveLobby(src, silent)
    if not UE.Remove(Lobby, src) then return end
    UE.Exit(src, 'warzone')
    UE.ResetBucket(src)
    local sq = squadOf(src)
    if sq then UE.Remove(sq.members, src) PlayerSquad[src] = nil if #sq.members == 0 then Squads[sq.id] = nil end end
    if not silent then
        TriggerClientEvent('ue:warzone:leave', src, UE.Vec(Config.WarZone.ExitCoord))
        UE.Notify(src, 'Left the WarZone lobby.', 'info')
    end
    pushLobby()
end
UE.Command({ 'exitwz' }, function(src)
    if Match and Match.players[src] then return UE.Notify(src, 'You cannot leave mid-match - die or win instead.', 'error') end
    doLeaveLobby(src, false)
end)

-- ---------------------------------------------------------------------------
-- Squad party (/wzparty <id> to invite, target accepts via hub)
-- ---------------------------------------------------------------------------
local pendingInvites = {}   -- [target] = { from = src, expiresAt }

local function invite(src, targetId)
    targetId = tonumber(targetId)
    if not targetId or not UE.Contains(Lobby, targetId) then return UE.Notify(src, 'That player is not in the WarZone lobby.', 'error') end
    local mySquad = squadOf(src)
    if mySquad and #mySquad.members >= Config.WarZone.SquadSize then return UE.Notify(src, 'Your squad is full.', 'error') end
    pendingInvites[targetId] = { from = src, expiresAt = os.time() + 20 }
    UE.Notify(targetId, UE.Name(src) .. ' invited you to their squad. Open /uevent to accept.', 'info')
    UE.Notify(src, 'Invite sent to ' .. UE.Name(targetId) .. '.', 'success')
end

local function acceptInvite(src)
    local inv = pendingInvites[src]
    if not inv or inv.expiresAt < os.time() then return UE.Notify(src, 'That invite has expired.', 'error') end
    pendingInvites[src] = nil
    if not UE.Contains(Lobby, inv.from) or not UE.Contains(Lobby, src) then return UE.Notify(src, 'That player already left the lobby.', 'error') end
    local targetSquad = squadOf(inv.from)
    if not targetSquad or #targetSquad.members >= Config.WarZone.SquadSize then return UE.Notify(src, 'That squad is full.', 'error') end

    local mySquad = squadOf(src)
    if mySquad then UE.Remove(mySquad.members, src) if #mySquad.members == 0 then Squads[mySquad.id] = nil end end
    targetSquad.members[#targetSquad.members + 1] = src
    PlayerSquad[src] = targetSquad.id
    for _, s in ipairs(targetSquad.members) do UE.Notify(s, UE.Name(src) .. ' joined the squad.', 'success') end
end

-- ---------------------------------------------------------------------------
-- Match lifecycle
-- ---------------------------------------------------------------------------
local function pickLootSpawn()
    local p = Config.WarZone.LootSpawns[math.random(#Config.WarZone.LootSpawns)]
    return vector3(p.x + math.random(-15, 15) + 0.0, p.y + math.random(-15, 15) + 0.0, p.z)
end

function WZ.StartMatch()
    if Match or #Lobby == 0 then return end
    local players = {}
    for _, src in ipairs(Lobby) do
        players[src] = { hp = 100, armor = 0, downed = false, alive = true, kills = 0, cash = 0, uav = 0, heal = 2, vest = 1 }
    end
    Lobby = {}

    local crates = {}
    for i = 1, 18 do crates[i] = { id = i, pos = pickLootSpawn(), weapon = Config.WarZone.LootWeapons[math.random(#Config.WarZone.LootWeapons)], taken = false } end

    Match = {
        players = players, crates = crates, zoneCenter = Config.WarZone.MapZone, radius = Config.WarZone.StartRadius,
        step = 0, startedAt = os.time(), gulag = {}, gulagQueue = {},
    }

    for src in pairs(players) do
        UE.SetBucket(src, Config.Buckets.WarZoneMatch)
        TriggerClientEvent('ue:warzone:matchStart', src, {
            crates = crates, center = UE.Vec(Match.zoneCenter), radius = Match.radius,
            squad = squadmates(src), teamId = PlayerSquad[src],
        })
    end
    UE.Log('WarZone', { title = 'Match started', color = 0x2EE6C8, description = UE.Count(players) .. ' players, ' .. UE.Count(Squads) .. ' squads' })

    WZ.PushCounts()

    CreateThread(function()
        while Match and Match.step < Config.WarZone.ShrinkSteps do
            Wait(Config.WarZone.ShrinkEveryMs)
            if not Match then return end
            Match.step = Match.step + 1
            Match.radius = math.max(Config.WarZone.MinRadius, Config.WarZone.StartRadius * (1 - (Match.step / Config.WarZone.ShrinkSteps)) ^ 1.4)
            for src in pairs(Match.players) do
                TriggerClientEvent('ue:warzone:zoneUpdate', src, UE.Vec(Match.zoneCenter), Match.radius)
            end
            for _, s in ipairs(UE.PlayersIn('warzone')) do UE.Announce(s, 'THE ZONE IS SHRINKING', 4, 'warn') end
        end
    end)

    -- zone damage tick
    CreateThread(function()
        while Match do
            Wait(2000)
            if not Match then return end
            for src, p in pairs(Match.players) do
                if p.alive and not p.downed then
                    local ped = GetPlayerPed(src)
                    if ped and ped ~= 0 then
                        local pos = GetEntityCoords(ped)
                        if UE.Dist2D(pos, Match.zoneCenter) > Match.radius then
                            TriggerClientEvent('ue:warzone:zoneDamage', src, Config.WarZone.ZoneDamagePerTick)
                        end
                    end
                end
            end
        end
    end)
end

function WZ.PushCounts()
    if not Match then return end
    local squadsAlive, playersAlive = {}, 0
    for src, p in pairs(Match.players) do
        if p.alive then playersAlive = playersAlive + 1 local sq = PlayerSquad[src] if sq then squadsAlive[sq] = true end end
    end
    for src in pairs(Match.players) do
        TriggerClientEvent('ue:warzone:counts', src, UE.Count(squadsAlive), playersAlive)
    end
end

local function squadAllDead(squadId)
    local sq = Squads[squadId]
    if not sq then return true end
    for _, s in ipairs(sq.members) do
        if Match.players[s] and Match.players[s].alive then return false end
    end
    return true
end

function WZ.EndMatch(winningSquadId)
    if not Match then return end
    local finished = Match
    Match = nil

    local names = {}
    if winningSquadId and Squads[winningSquadId] then
        for _, s in ipairs(Squads[winningSquadId].members) do
            names[#names + 1] = UE.Name(s)
            local x = UE.GetPlayer(s)
            if x then
                bumpStat(x.identifier, UE.Name(s), 'wins', 1)
                if SvConfig.Rewards.WarZoneWinPerPlayer > 0 then x.addMoney(SvConfig.Rewards.WarZoneWinPerPlayer) end
            end
        end
    end

    for src, p in pairs(finished.players) do
        local x = UE.GetPlayer(src)
        if x then
            bumpStat(x.identifier, UE.Name(src), 'kills', p.kills)
            if not p.alive then bumpStat(x.identifier, UE.Name(src), 'deaths', 1) end
        end
        TriggerClientEvent('ue:warzone:matchEnd', src, { names = table.concat(names, ', '), isYou = (winningSquadId ~= nil and PlayerSquad[src] == winningSquadId) })
        UE.Exit(src, 'warzone')
        PlayerSquad[src] = nil
    end
    for _, sq in pairs(Squads) do Squads[sq.id] = nil end
    Squads, nextSquadId = {}, 1

    UE.Log('WarZone', { title = 'Match ended', color = 0xFFB020, description = names[1] and ('Winning squad: **' .. table.concat(names, ', ') .. '**') or 'No winner (empty lobby)' })

    SetTimeout(6000, function()
        for src, p in pairs(finished.players) do
            if GetPlayerName(src) then
                UE.ResetBucket(src)
                TriggerClientEvent('ue:warzone:leave', src, UE.Vec(Config.WarZone.ExitCoord))
            end
        end
    end)
end

print('^2[Unique_Event]^7 WarZone module loaded (part 1/2)')

-- ---------------------------------------------------------------------------
-- Loot crates
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:warzone:loot')
AddEventHandler('ue:warzone:loot', function(crateId)
    local src = source
    if not Match or not Match.players[src] or not Match.players[src].alive then return end
    local crate = Match.crates[crateId]
    if not crate or crate.taken then return end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    if UE.Dist(GetEntityCoords(ped), crate.pos) > 3.5 then return end   -- server-side distance check

    crate.taken = true
    local ammo = math.random(Config.WarZone.LootAmmo.min, Config.WarZone.LootAmmo.max)
    local cash = math.random(Config.WarZone.CrateCash.min, Config.WarZone.CrateCash.max)
    Match.players[src].cash = Match.players[src].cash + cash
    TriggerClientEvent('ue:warzone:lootResult', src, crateId, crate.weapon, ammo, cash)
    for s in pairs(Match.players) do
        if s ~= src then TriggerClientEvent('ue:warzone:crateTaken', s, crateId) end
    end
end)

local function applyUseItem(src, kind)
    local p = Match and Match.players[src]
    if not p or not p.alive then return end
    if kind == 'heal' and p.heal > 0 then
        p.heal = p.heal - 1
        TriggerClientEvent('ue:warzone:itemUsed', src, 'heal', p.heal)
    elseif kind == 'vest' and p.vest > 0 then
        p.vest = p.vest - 1
        TriggerClientEvent('ue:warzone:itemUsed', src, 'vest', p.vest)
    elseif kind == 'uav' and p.uav > 0 then
        p.uav = p.uav - 1
        TriggerClientEvent('ue:warzone:itemUsed', src, 'uav', p.uav)
        local sq = squadOf(src)
        local team = sq and sq.members or { src }
        local enemies = {}
        for s, pl in pairs(Match.players) do
            if pl.alive and not UE.Contains(team, s) then
                local ped = GetPlayerPed(s)
                if ped ~= 0 then enemies[#enemies + 1] = UE.Vec(GetEntityCoords(ped)) end
            end
        end
        for _, s in ipairs(team) do if Match.players[s] then TriggerClientEvent('ue:warzone:uavPing', s, enemies) end end
    end
end

RegisterNetEvent('ue:warzone:useItem')
AddEventHandler('ue:warzone:useItem', function(kind) applyUseItem(source, kind) end)

-- ---------------------------------------------------------------------------
-- Down / revive / death
-- ---------------------------------------------------------------------------
local function finalizeElimination(src)
    if not Match then return end
    local p = Match.players[src]
    if not p then return end
    p.alive = false
    p.downed = false
    TriggerClientEvent('ue:warzone:dead', src)

    local sq = PlayerSquad[src]
    if sq and squadAllDead(sq) then
        WZ.PushCounts()
        local aliveSquads = {}
        for id in pairs(Squads) do if not squadAllDead(id) then aliveSquads[#aliveSquads + 1] = id end end
        if #aliveSquads <= 1 then
            WZ.EndMatch(aliveSquads[1])
            return
        end
    end
    WZ.PushCounts()
end

-- ---------------------------------------------------------------------------
-- Gulag: every player gets exactly one 1v1 second chance before being out for good.
-- Winner returns to the safe zone; loser (and a timeout draw) is eliminated for real.
-- ---------------------------------------------------------------------------
local GulagQueue = {}     -- ordered list of src waiting for an opponent
local GulagMatch = {}     -- [src] = { opponent = src, endsAt = ostime }

local function gulagFinish(a, winner)
    local b = GulagMatch[a] and GulagMatch[a].opponent
    GulagMatch[a] = nil
    if b then GulagMatch[b] = nil end
    for _, s in ipairs({ a, b }) do
        if s and Match and Match.players[s] then
            if s == winner then
                Match.players[s].alive = true
                Match.players[s].downed = false
                Match.players[s].hp = 100
                UE.SetBucket(s, Config.Buckets.WarZoneMatch)
                local edge = Match.zoneCenter
                TriggerClientEvent('ue:warzone:gulagReturn', s, UE.Vec(edge), Match.radius)
                UE.Notify(s, 'You won the Gulag - back in the fight!', 'success')
            else
                UE.SetBucket(s, Config.Buckets.WarZoneMatch)
                finalizeElimination(s)
            end
        end
    end
end

local function startGulagRound(a, b)
    local endsAt = os.time() + Config.WarZone.GulagRoundSeconds
    GulagMatch[a] = { opponent = b, endsAt = endsAt }
    GulagMatch[b] = { opponent = a, endsAt = endsAt }
    local spawns = Config.WarZone.GulagSpawns
    local sa, sb = spawns[math.random(#spawns)], spawns[math.random(#spawns)]
    for _, pair in ipairs({ { a, sa, b }, { b, sb, a } }) do
        local s, spawn, opp = pair[1], pair[2], pair[3]
        UE.SetBucket(s, Config.Buckets.WarZoneGulag)
        TriggerClientEvent('ue:warzone:gulagStart', s, UE.Vec(spawn), UE.Name(opp), Config.WarZone.GulagRoundSeconds, UE.Vec(Config.WarZone.GulagZone), Config.WarZone.GulagRadius)
    end
    SetTimeout(Config.WarZone.GulagRoundSeconds * 1000, function()
        if GulagMatch[a] then gulagFinish(a, nil) end   -- timed out with nobody dead -> both eliminated
    end)
end

local function gulagPumpQueue()
    while #GulagQueue >= 2 do
        local a = table.remove(GulagQueue, 1)
        local b = table.remove(GulagQueue, 1)
        if Match and Match.players[a] and Match.players[b] then
            startGulagRound(a, b)
        elseif Match and Match.players[a] then
            GulagQueue[#GulagQueue + 1] = a
        elseif Match and Match.players[b] then
            GulagQueue[#GulagQueue + 1] = b
        end
    end
end

RegisterNetEvent('ue:warzone:gulagDied')
AddEventHandler('ue:warzone:gulagDied', function()
    local src = source
    local gm = GulagMatch[src]
    if not gm then return end
    gulagFinish(src, gm.opponent)
end)

local function forceGulagOrDeath(src)
    if not Match then return end
    local p = Match.players[src]
    if not p then return end

    if not p.gulagUsed and Config.WarZone.GulagRoundSeconds > 0 then
        p.gulagUsed = true
        p.alive = false   -- out of the main zone while gulagging
        p.downed = false
        TriggerClientEvent('ue:warzone:toGulag', src)
        GulagQueue[#GulagQueue + 1] = src
        WZ.PushCounts()
        gulagPumpQueue()
        -- nobody to pair with for a while: bring them back into the match automatically
        SetTimeout(45000, function()
            if UE.Remove(GulagQueue, src) and Match and Match.players[src] then
                Match.players[src].alive = true
                UE.SetBucket(src, Config.Buckets.WarZoneMatch)
                TriggerClientEvent('ue:warzone:gulagReturn', src, UE.Vec(Match.zoneCenter), Match.radius)
                UE.Notify(src, 'No Gulag opponent was found - you are back in the fight.', 'info')
            end
        end)
        return
    end

    finalizeElimination(src)
end

RegisterNetEvent('ue:warzone:downed')
AddEventHandler('ue:warzone:downed', function()
    local src = source
    local p = Match and Match.players[src]
    if not p or not p.alive or p.downed then return end
    if not Config.WarZone.Downed.enabled then return forceGulagOrDeath(src) end

    p.downed = true
    TriggerClientEvent('ue:warzone:downedSelf', src, Config.WarZone.Downed.bleedoutMs)
    for _, s in ipairs(squadmates(src)) do
        if Match.players[s] and Match.players[s].alive then
            TriggerClientEvent('ue:warzone:mateDowned', s, src, UE.Name(src))
        end
    end
    SetTimeout(Config.WarZone.Downed.bleedoutMs, function()
        if Match and Match.players[src] and Match.players[src].downed then
            forceGulagOrDeath(src)
        end
    end)
end)

RegisterNetEvent('ue:warzone:reviveRequest')
AddEventHandler('ue:warzone:reviveRequest', function(targetSrc)
    local src = source
    targetSrc = tonumber(targetSrc)
    local reviver = Match and Match.players[src]
    local target = Match and Match.players[targetSrc]
    if not reviver or not target or not reviver.alive or not target.downed then return end
    if not UE.Contains(squadmates(src), targetSrc) then return end
    local pedA, pedB = GetPlayerPed(src), GetPlayerPed(targetSrc)
    if pedA == 0 or pedB == 0 or UE.Dist(GetEntityCoords(pedA), GetEntityCoords(pedB)) > Config.WarZone.Downed.reviveDistance + 1.0 then return end

    target.downed = false
    target.hp = Config.WarZone.Downed.reviveHealthPct
    TriggerClientEvent('ue:warzone:revived', targetSrc, target.hp)
    TriggerClientEvent('ue:warzone:reviveDone', src)
    UE.Notify(src, 'Teammate revived!', 'success')
end)

RegisterNetEvent('ue:warzone:died')
AddEventHandler('ue:warzone:died', function()
    local src = source
    local p = Match and Match.players[src]
    if not p or not p.alive then return end
    local ped = GetPlayerPed(src)
    local killer = UE.ResolveKiller(ped)

    if killer ~= 0 and killer ~= src and Match.players[killer] then
        Match.players[killer].kills = Match.players[killer].kills + 1
        Match.players[killer].cash = Match.players[killer].cash + Config.WarZone.KillCashReward
        for s in pairs(Match.players) do
            TriggerClientEvent('ue:warzone:killFeed', s, UE.Name(killer), UE.Name(src), killer == s)
        end
        if Config.WarZone.Killcam.enabled then TriggerClientEvent('ue:warzone:killcam', src, killer, Config.WarZone.Killcam.durationMs) end
        if Match.players[killer].kills % Config.WarZone.KillstreakUAVKills == 0 then
            Match.players[killer].uav = Match.players[killer].uav + 1
            TriggerClientEvent('ue:warzone:itemUsed', killer, 'uav', Match.players[killer].uav)
            UE.Notify(killer, 'Killstreak reward: +1 UAV', 'success')
        end
    end
    forceGulagOrDeath(src)
end)

-- ---------------------------------------------------------------------------
-- Hub actions / commands
-- ---------------------------------------------------------------------------
UE.Command({ 'wzparty' }, function(src, args) invite(src, args[1]) end)

UE.Actions.warzone = {
    join = function(src) tryJoinLobby(src) end,
    leave = function(src)
        if Match and Match.players[src] then return UE.Notify(src, 'You cannot leave mid-match.', 'error') end
        doLeaveLobby(src, false)
    end,
    invite = function(src, data) invite(src, data.target) end,
    accept = function(src) acceptInvite(src) end,
    useItem = function(src, data) applyUseItem(src, data.kind) end,
    start = function(src)
        if not UE.CanAdmin(src, 'warzone') then return UE.Notify(src, 'No permission.', 'error') end
        if countdownThread then countdownThread.endsAt = os.time() WZ.StartMatch() countdownThread = nil
        else WZ.StartMatch() end
    end,
    ['end'] = function(src)
        if not UE.CanAdmin(src, 'warzone') then return UE.Notify(src, 'No permission.', 'error') end
        WZ.EndMatch(nil)
    end,
}

UE.OnDrop(function(src)
    doLeaveLobby(src, true)
    if GulagMatch[src] then
        gulagFinish(src, GulagMatch[src].opponent)   -- disconnecting counts as a loss, opponent wins by default
    elseif UE.Remove(GulagQueue, src) then
        -- was waiting in the gulag queue, nothing more to clean up
    elseif Match and Match.players[src] and Match.players[src].alive then
        Match.players[src].alive = false
        forceGulagOrDeath(src)
    end
end)

-- ---------------------------------------------------------------------------
-- Status / stats / leaderboard
-- ---------------------------------------------------------------------------
function WZ.Status(src)
    local inMatch = Match and Match.players[src] ~= nil
    return {
        state = Match and 'live' or (#Lobby > 0 and 'open' or 'idle'),
        lobby = #Lobby, needed = Config.WarZone.MinPlayers,
        matchPlayers = Match and UE.Count(Match.players) or 0,
        youIn = UE.InEvent[src] == 'warzone', inLobby = UE.Contains(Lobby, src), inMatch = inMatch,
    }
end

function WZ.Stats(src, done)
    local ident = UE.GetPlayer(src) and UE.GetPlayer(src).identifier or nil
    UE.DB.All('SELECT identifier, name, wins, kills, deaths FROM ue_warzone_stats ORDER BY wins DESC, kills DESC LIMIT 10', {}, function(rows)
        local top = {}
        for _, r in ipairs(rows or {}) do top[#top + 1] = { name = r.name, wins = r.wins, kills = r.kills, deaths = r.deaths, you = (r.identifier == ident) } end
        done({ top = top, lobby = #Lobby, needed = Config.WarZone.MinPlayers, invite = pendingInvites[src] and UE.Name(pendingInvites[src].from) or nil })
    end)
end

function WZ.Leaderboard(done)
    UE.DB.All('SELECT name, wins, kills, deaths FROM ue_warzone_stats ORDER BY wins DESC, kills DESC LIMIT 10', {}, function(rows) done(rows or {}) end)
end

function WZ.Page(src, cb)
    WZ.Stats(src, function(stats)
        local squadNames = {}
        local sq = squadOf(src)
        if sq then for _, s in ipairs(sq.members) do squadNames[#squadNames + 1] = UE.Name(s) end end
        cb({ stats = stats, squad = squadNames, perm = Config.Perm.WarZone })
    end)
end

print('^2[Unique_Event]^7 WarZone module loaded (part 2/2)')
