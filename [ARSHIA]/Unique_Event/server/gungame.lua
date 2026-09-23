--[[
    Unique_Event - GUNGAME (server)

    Queue-based arenas: once Config.GunGame.PlayersPerArena players are queued, a new arena
    is created (its own routing bucket), a countdown runs, then everyone gets weapon #1.
    Every kill advances the killer one weapon up the ladder; reaching the last weapon and
    getting a kill with it wins the match.

    Bugs fixed vs the original Unique_GunGame:
    - kills are validated server-side (UE.ResolveKiller) instead of trusted from the client,
      so you can no longer grant yourself/an ally free kills
    - revive uses Config.Framework.ReviveTrigger (the resource's real esx_ambulancejob:revivex
      event) instead of the non-existent esx_ambulancejob:revive
    - arenas are properly torn down (bucket freed, threads stopped) so they don't leak
]]

local GG = {}
UE.RegisterModule('gungame', GG)

local Queue = {}              -- ordered list of src waiting for an arena
local Arenas = {}             -- [arenaId] = { id, bucket, players = {[src]={level,kills}}, state, endsAt, countdownEndsAt }
local PlayerArena = {}        -- [src] = arenaId
local nextArenaId = 1

local WEAPON_COUNT = #Config.GunGame.Weapons

UE.DB.Ready(function()
    UE.DB.Exec([[CREATE TABLE IF NOT EXISTS ue_gungame_stats (
        identifier VARCHAR(64) NOT NULL PRIMARY KEY,
        name VARCHAR(64) NOT NULL DEFAULT '',
        wins INT NOT NULL DEFAULT 0,
        kills INT NOT NULL DEFAULT 0
    )]])
end)

local function bumpStat(identifier, name, field, amount)
    UE.DB.Exec('INSERT INTO ue_gungame_stats (identifier, name, ' .. field .. ') VALUES (?, ?, ?) ' ..
        'ON DUPLICATE KEY UPDATE ' .. field .. ' = ' .. field .. ' + VALUES(' .. field .. '), name = VALUES(name)',
        { identifier, name, amount })
end

-- ---------------------------------------------------------------------------
-- Queue
-- ---------------------------------------------------------------------------
local function tryJoinQueue(src)
    local ok, reason = UE.CanJoin(src, 'gungame')
    if not ok then return UE.Notify(src, reason, 'error') end
    if UE.Contains(Queue, src) then return UE.Notify(src, 'You are already in the queue.', 'error') end
    if #Queue >= Config.GunGame.MaxQueueSize then return UE.Notify(src, 'The GunGame queue is full.', 'error') end

    Queue[#Queue + 1] = src
    UE.Enter(src, 'gungame')
    UE.SetBucket(src, Config.Buckets.GunGameStart)
    TriggerClientEvent('ue:gungame:queued', src, UE.Vec(Config.GunGame.Lobby))
    UE.Notify(src, 'Joined the GunGame queue (' .. #Queue .. '/' .. Config.GunGame.PlayersPerArena .. ').', 'success')
    GG.CheckStart()
end
UE.Command({ 'jgg' }, function(src) tryJoinQueue(src) end)

local function leaveQueue(src, silent)
    if UE.Remove(Queue, src) then
        UE.Exit(src, 'gungame')
        UE.ResetBucket(src)
        if not silent then
            TriggerClientEvent('ue:gungame:leave', src, UE.Vec(Config.GunGame.Exit))
            UE.Notify(src, 'Left the GunGame queue.', 'info')
        end
    end
end

-- ---------------------------------------------------------------------------
-- Arena lifecycle
-- ---------------------------------------------------------------------------
function GG.CheckStart()
    if #Queue < Config.GunGame.PlayersPerArena then return end
    local id = nextArenaId
    nextArenaId = nextArenaId + 1
    local bucket = Config.Buckets.GunGameStart + id
    local players = {}
    for _ = 1, Config.GunGame.PlayersPerArena do
        local src = table.remove(Queue, 1)
        if src and GetPlayerName(src) then
            players[src] = { level = 1, kills = 0 }
        end
    end
    if UE.Count(players) < 2 then
        for src in pairs(players) do Queue[#Queue + 1] = src end
        return
    end

    local arena = { id = id, bucket = bucket, players = players, state = 'countdown', countdownEndsAt = os.time() + Config.GunGame.CountdownTime }
    Arenas[id] = arena
    for src in pairs(players) do
        PlayerArena[src] = id
        UE.SetBucket(src, bucket)
        TriggerClientEvent('ue:gungame:arenaStart', src, {
            center = UE.Vec(Config.GunGame.Center), countdown = Config.GunGame.CountdownTime,
            weapon = Config.GunGame.Weapons[1], total = WEAPON_COUNT,
        })
    end
    UE.Log('GunGame', { title = 'Arena #' .. id .. ' starting', color = 0xFFB020, description = UE.Count(players) .. ' players' })

    CreateThread(function()
        Wait(Config.GunGame.CountdownTime * 1000)
        if not Arenas[id] then return end
        arena.state = 'live'
        arena.endsAt = (Config.GunGame.RoundTimeLimit > 0) and (os.time() + Config.GunGame.RoundTimeLimit) or 0
        for src in pairs(arena.players) do
            TriggerClientEvent('ue:gungame:go', src)
        end
    end)

    -- round time limit -> highest level wins
    if Config.GunGame.RoundTimeLimit > 0 then
        CreateThread(function()
            Wait((Config.GunGame.CountdownTime + Config.GunGame.RoundTimeLimit) * 1000)
            if Arenas[id] and Arenas[id].state == 'live' then
                local best, bestScore = nil, -1
                for src, p in pairs(Arenas[id].players) do
                    if p.level > bestScore then best, bestScore = src, p.level end
                end
                GG.EndArena(id, best)
            end
        end)
    end

    GG.CheckStart()  -- more players may already be queued for another arena
end

function GG.EndArena(id, winnerSrc)
    local arena = Arenas[id]
    if not arena then return end
    arena.state = 'ended'

    local rows = {}
    for src, p in pairs(arena.players) do rows[#rows + 1] = { src = src, name = UE.Name(src), level = p.level, kills = p.kills } end
    table.sort(rows, function(a, b) return a.level > b.level end)

    local winnerName = winnerSrc and UE.Name(winnerSrc) or (rows[1] and rows[1].name) or '-'
    if winnerSrc then
        local x = UE.GetPlayer(winnerSrc)
        if x then bumpStat(x.identifier, winnerName, 'wins', 1) end
        if SvConfig.Rewards.GunGameWin > 0 and x then x.addMoney(SvConfig.Rewards.GunGameWin) end
    end

    for src, p in pairs(arena.players) do
        local x = UE.GetPlayer(src)
        if x then bumpStat(x.identifier, UE.Name(src), 'kills', p.kills) end
        TriggerClientEvent('ue:gungame:mvp', src, {
            name = winnerName, kills = winnerSrc and (arena.players[winnerSrc] and arena.players[winnerSrc].kills or 0) or 0,
            level = winnerSrc and (arena.players[winnerSrc] and arena.players[winnerSrc].level or 0) or 0,
            isYou = (src == winnerSrc), rows = rows,
        })
        UE.Exit(src, 'gungame')
        PlayerArena[src] = nil
    end
    UE.Log('GunGame', { title = 'Arena #' .. id .. ' finished', color = 0x39E07D, description = 'Winner: **' .. winnerName .. '**' })

    SetTimeout(Config.GunGame.WinnerCameraSeconds * 1000, function()
        for src in pairs(arena.players) do
            if GetPlayerName(src) then
                UE.ResetBucket(src)
                TriggerClientEvent('ue:gungame:leave', src, UE.Vec(Config.GunGame.Exit))
            end
        end
        Arenas[id] = nil
    end)
end

local function dropFromArena(src)
    local id = PlayerArena[src]
    if not id or not Arenas[id] then return end
    local arena = Arenas[id]
    arena.players[src] = nil
    PlayerArena[src] = nil
    if UE.Count(arena.players) <= 1 and arena.state ~= 'ended' then
        local last = next(arena.players)
        GG.EndArena(id, last)
    end
end

UE.Command({ 'ggl' }, function(src)
    if PlayerArena[src] then
        UE.Notify(src, 'You cannot leave mid-match - wait for it to finish.', 'error')
    else
        leaveQueue(src, false)
    end
end)

UE.OnDrop(function(src)
    leaveQueue(src, true)
    dropFromArena(src)
end)

-- ---------------------------------------------------------------------------
-- Kills
-- ---------------------------------------------------------------------------
RegisterNetEvent('ue:gungame:died')
AddEventHandler('ue:gungame:died', function(killerId)
    local src = source
    local id = PlayerArena[src]
    if not id or not Arenas[id] or Arenas[id].state ~= 'live' then return end
    local arena = Arenas[id]
    local killer = (arena.players[killerId] and UE.PlausibleKiller(src, killerId)) and killerId or 0

    if killer ~= 0 then
        local kp = arena.players[killer]
        kp.kills = kp.kills + 1
        local wasTop = (kp.level >= WEAPON_COUNT)
        if wasTop then
            GG.EndArena(id, killer)
            return
        end
        kp.level = kp.level + 1
        TriggerClientEvent('ue:gungame:levelUp', killer, kp.level, Config.GunGame.Weapons[kp.level])
        for s in pairs(arena.players) do
            TriggerClientEvent('ue:gungame:killFeed', s, UE.Name(killer), UE.Name(src), killer == s)
        end
        GG.PushBoard(id)
    end
    TriggerClientEvent('ue:gungame:respawn', src, UE.Vec(Config.GunGame.Center))
end)

function GG.PushBoard(id)
    local arena = Arenas[id]
    if not arena then return end
    local rows = {}
    for src, p in pairs(arena.players) do rows[#rows + 1] = { name = UE.Name(src), level = p.level } end
    table.sort(rows, function(a, b) return a.level > b.level end)
    for src in pairs(arena.players) do TriggerClientEvent('ue:gungame:board', src, rows) end
end

-- ---------------------------------------------------------------------------
-- Arena leash (kicks players who wander too far back toward the center)
-- ---------------------------------------------------------------------------
if Config.GunGame.ArenaLeashRadius > 0 then
    CreateThread(function()
        while true do
            Wait(4000)
            for src, id in pairs(PlayerArena) do
                if Arenas[id] and Arenas[id].state == 'live' then
                    TriggerClientEvent('ue:gungame:leashCheck', src, UE.Vec(Config.GunGame.Center), Config.GunGame.ArenaLeashRadius)
                end
            end
        end
    end)
end

-- ---------------------------------------------------------------------------
-- Status / stats / leaderboard
-- ---------------------------------------------------------------------------
function GG.Status(src)
    local liveArenas, totalPlaying = 0, 0
    for _, a in pairs(Arenas) do if a.state ~= 'ended' then liveArenas = liveArenas + 1 totalPlaying = totalPlaying + UE.Count(a.players) end end
    return {
        state = (liveArenas > 0 and 'live') or (#Queue > 0 and 'open') or 'idle',
        queue = #Queue, need = Config.GunGame.PlayersPerArena, arenas = liveArenas, playing = totalPlaying,
        youIn = UE.InEvent[src] == 'gungame', inQueue = UE.Contains(Queue, src), inMatch = PlayerArena[src] ~= nil,
    }
end

function GG.Stats(src, done)
    local ident = UE.GetPlayer(src) and UE.GetPlayer(src).identifier or nil
    UE.DB.All('SELECT identifier, name, wins, kills FROM ue_gungame_stats ORDER BY wins DESC, kills DESC LIMIT 10', {}, function(rows)
        local top = {}
        for _, r in ipairs(rows or {}) do top[#top + 1] = { name = r.name, wins = r.wins, kills = r.kills, you = (r.identifier == ident) } end
        done({ top = top, queue = #Queue, need = Config.GunGame.PlayersPerArena })
    end)
end

function GG.Leaderboard(done)
    UE.DB.All('SELECT name, wins, kills FROM ue_gungame_stats ORDER BY wins DESC, kills DESC LIMIT 10', {}, function(rows) done(rows or {}) end)
end

function GG.Page(src, cb)
    GG.Stats(src, function(stats) cb({ stats = stats, weapons = Config.GunGame.Weapons, perm = Config.Perm.GunGame }) end)
end

UE.Actions.gungame = {
    join = function(src) tryJoinQueue(src) end,
    leave = function(src)
        if PlayerArena[src] then return UE.Notify(src, 'You cannot leave mid-match.', 'error') end
        leaveQueue(src, false)
    end,
}

print('^2[Unique_Event]^7 GunGame module loaded')
