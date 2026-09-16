--[[
    Unique_GunGame - server logic

    Manages the join queue, spins up independent concurrent arenas (each isolated
    with its own routing bucket), tracks kills/scoreboards per arena, and
    optionally persists stats to a database and posts wins to Discord.

    See config.lua for every tunable value and README.md for command/setup docs.
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ============================================================
-- Constants
-- ============================================================

local CHAT_TAG = '^3Unique_GunGame'
local TICK_MS = 1000          -- resolution of both the countdown and round timer
local INITIAL_BUCKET = 100    -- first routing bucket handed out (kept away from the default world, bucket 0)

-- ============================================================
-- Runtime state
-- ============================================================

local Queue = {}        -- source ids waiting to be grouped into an arena
local Pending = {}      -- [src] = true while a player has been pulled from Queue into a forming group but the arena hasn't started yet
local Matches = {}      -- [matchId] = { state='running'|'ended', players={[src]={name,identifier,kills,level}}, bucket, locationSet }
local PlayerMatch = {}  -- [src] = matchId, for O(1) lookup on kill/drop events
local EventActive = false -- players can only /jgg once an admin runs "/gungame start"
local nextMatchId = 1
local nextBucket = INITIAL_BUCKET
local freeBuckets = {}  -- buckets released by ended arenas, reused before handing out new numbers

-- ============================================================
-- Generic helpers
-- ============================================================

local function notify(source, msg)
    TriggerClientEvent('chat:addMessage', source, { args = { CHAT_TAG, msg } })
end

local function broadcastMessage(msg)
    TriggerClientEvent('chat:addMessage', -1, { args = { CHAT_TAG, msg } })
end

local function isInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

local function removeFromTable(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            table.remove(tbl, i)
            return
        end
    end
end

local function totalActivePlayers()
    local total = #Queue
    for _ in pairs(Pending) do
        total = total + 1
    end
    for _, match in pairs(Matches) do
        for _ in pairs(match.players) do
            total = total + 1
        end
    end
    return total
end

-- ============================================================
-- Routing bucket pool
-- ============================================================
-- Each arena gets its own bucket so concurrent arenas can't see or interact
-- with each other, even when they share identical world coordinates.

local function allocateBucket()
    if #freeBuckets > 0 then
        return table.remove(freeBuckets)
    end
    local bucket = nextBucket
    nextBucket = nextBucket + 1
    return bucket
end

local function releaseBucket(bucket)
    freeBuckets[#freeBuckets + 1] = bucket
end

-- ============================================================
-- Scoreboard / kill feed
-- ============================================================

local function buildScoreboard(match)
    local list = {}
    for src, data in pairs(match.players) do
        list[#list + 1] = { source = src, name = data.name, kills = data.kills, level = data.level }
    end
    table.sort(list, function(a, b) return a.kills > b.kills end)
    for i, entry in ipairs(list) do
        entry.rank = i
    end
    return list
end

local function broadcastScoreboard(match)
    local board = buildScoreboard(match)
    for src in pairs(match.players) do
        TriggerClientEvent('Unique_GunGame:UpdateScoreboard', src, board)
    end
end

-- Kill feed and chat updates only ever go to players inside the arena where the
-- kill happened, so concurrent arenas never spam each other's chat or HUD.
local function broadcastKillFeed(match, killerName, victimName)
    for src in pairs(match.players) do
        TriggerClientEvent('chat:addMessage', src, { args = { CHAT_TAG, '^0' .. killerName .. ' killed ' .. tostring(victimName) } })
        TriggerClientEvent('Unique_GunGame:KillFeed', src, killerName, victimName)
    end
end

local function announceKillstreakIfNeeded(match, playerData)
    for _, threshold in ipairs(Config.KillstreakAnnouncements) do
        if playerData.streak == threshold then
            for src in pairs(match.players) do
                TriggerClientEvent('chat:addMessage', src, { args = { CHAT_TAG, '^1' .. playerData.name .. ' ^0is on a ' .. threshold .. '-kill streak!' } })
            end
            return
        end
    end
end

-- ============================================================
-- Optional persistence (oxmysql)
-- ============================================================

local function ensureStatsTable()
    if not Config.UseDatabase then return end
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS unique_gungame_stats (
            identifier VARCHAR(60) NOT NULL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            kills INT NOT NULL DEFAULT 0,
            wins INT NOT NULL DEFAULT 0,
            matches_played INT NOT NULL DEFAULT 0
        )
    ]])
end

local function persistKill(playerData)
    if not Config.UseDatabase or not playerData.identifier then return end
    exports.oxmysql:execute(
        'INSERT INTO unique_gungame_stats (identifier, name, kills) VALUES (?, ?, 1) ON DUPLICATE KEY UPDATE kills = kills + 1, name = ?',
        { playerData.identifier, playerData.name, playerData.name }
    )
end

local function persistMatchResult(match, winnerIdentifier)
    if not Config.UseDatabase then return end
    for _, playerData in pairs(match.players) do
        if playerData.identifier then
            local won = (playerData.identifier == winnerIdentifier) and 1 or 0
            exports.oxmysql:execute(
                'INSERT INTO unique_gungame_stats (identifier, name, matches_played, wins) VALUES (?, ?, 1, ?) ON DUPLICATE KEY UPDATE matches_played = matches_played + 1, wins = wins + ?, name = ?',
                { playerData.identifier, playerData.name, won, won, playerData.name }
            )
        end
    end
end

-- ============================================================
-- Optional Discord webhook
-- ============================================================

local function postWinToDiscord(winnerName)
    if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({
        embeds = { {
            title = 'Unique GunGame',
            description = winnerName .. ' won an arena!',
            color = 16744478,
        } }
    }), { ['Content-Type'] = 'application/json' })
end

-- ============================================================
-- Arena lifecycle
-- ============================================================

local function endMatch(matchId, winnerSrc)
    local match = Matches[matchId]
    if not match then return end
    match.state = 'ended' -- any running round-timer loop reads this and stops itself

    local winnerData = winnerSrc and match.players[winnerSrc]
    if winnerData then
        broadcastMessage('^1' .. winnerData.name .. ' ^0won an arena in the GunGame event!')
        postWinToDiscord(winnerData.name)
    end
    persistMatchResult(match, winnerData and winnerData.identifier or nil)

    for src in pairs(match.players) do
        TriggerClientEvent('Unique_GunGame:End', src, match.locationSet)
        SetPlayerRoutingBucket(src, 0)
        PlayerMatch[src] = nil
    end

    releaseBucket(match.bucket)
    Matches[matchId] = nil
end

local function startMatch(group)
    local matchId = nextMatchId
    nextMatchId = nextMatchId + 1

    local locationSet = Config.Locations[((matchId - 1) % #Config.Locations) + 1]
    local bucket = allocateBucket()
    local match = { state = 'running', players = {}, bucket = bucket, locationSet = locationSet }

    for _, src in ipairs(group) do
        Pending[src] = nil
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            match.players[src] = { name = GetPlayerName(src), identifier = xPlayer.identifier, kills = 0, level = 0, streak = 0 }
            PlayerMatch[src] = matchId
            SetPlayerRoutingBucket(src, bucket)
            TriggerClientEvent('Unique_GunGame:JoinToMach', src, locationSet)
        end
    end

    if not next(match.players) then
        -- everyone in the group disconnected during the countdown, nothing to run
        releaseBucket(bucket)
        return
    end

    Matches[matchId] = match
    broadcastScoreboard(match)

    if Config.RoundTimeLimit and Config.RoundTimeLimit > 0 then
        Citizen.CreateThread(function()
            local remaining = Config.RoundTimeLimit
            while remaining > 0 and match.state == 'running' do
                for src in pairs(match.players) do
                    TriggerClientEvent('Unique_GunGame:UpdateTimer', src, remaining)
                end
                Citizen.Wait(TICK_MS)
                remaining = remaining - 1
            end
            if match.state == 'running' then
                local board = buildScoreboard(match)
                endMatch(matchId, board[1] and board[1].source or nil)
            end
        end)
    end
end

-- Pulls players out of the queue in fixed-size groups and runs an independent
-- countdown for each one, so several arenas can be mid-countdown or running at once.
local function tryFormArenas()
    while #Queue >= Config.PlayersPerArena do
        local group = {}
        for i = 1, Config.PlayersPerArena do
            local src = table.remove(Queue, 1)
            group[i] = src
            Pending[src] = true
        end

        local function abortGroup()
            for _, src in ipairs(group) do
                Pending[src] = nil
                notify(src, '^1The event has been stopped by an admin.')
            end
        end

        Citizen.CreateThread(function()
            local remaining = Config.CountdownTime
            while remaining > 0 do
                if not EventActive then
                    abortGroup()
                    return
                end
                for _, src in ipairs(group) do
                    TriggerClientEvent('Unique_GunGame:UpdateCountdown', src, remaining)
                end
                Citizen.Wait(TICK_MS)
                remaining = remaining - 1
            end
            if not EventActive then
                abortGroup()
                return
            end
            startMatch(group)
        end)
    end
end

-- ============================================================
-- Commands
-- ============================================================

RegisterCommand(Config.AdminCommand, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.permission_level < Config.PermissionLevel then
        TriggerClientEvent('esx:showNotification', source, 'Shoam Mojaz Be Estefadeh  Nistid.')
        return
    end

    if args[1] == 'start' then
        if EventActive then
            notify(source, '^1The GunGame event is already active.')
            return
        end
        EventActive = true
        broadcastMessage('^0The GunGame event is now open! Use /' .. Config.JoinCommand .. ' to join.')
    elseif args[1] == 'stop' then
        EventActive = false

        local matchIds = {}
        for matchId in pairs(Matches) do matchIds[#matchIds + 1] = matchId end
        for _, matchId in ipairs(matchIds) do
            endMatch(matchId, nil)
        end

        for _, src in ipairs(Queue) do
            notify(src, '^1The event has been stopped by an admin.')
        end
        Queue = {}
        Pending = {}

        broadcastMessage('^0The GunGame event has been closed and all arenas stopped!')
    else
        notify(source, '^0Usage: /' .. Config.AdminCommand .. ' start | stop')
    end
end)

RegisterCommand(Config.JoinCommand, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if not EventActive then
        notify(source, '^1The GunGame event has not been started yet.')
        return
    end
    if PlayerMatch[source] then
        notify(source, '^1You are already in a running arena!')
        return
    end
    if Pending[source] then
        notify(source, '^1Your arena is about to start, hang tight!')
        return
    end
    if isInTable(Queue, source) then
        notify(source, '^1You are already queued!')
        return
    end
    if Config.RestrictedJobs[xPlayer.job.name] then
        notify(source, '^0Baray Join Shodan Dar GunGame Bayad Off Duty Job Khod Bashid')
        return
    end
    if totalActivePlayers() >= Config.MaxQueueSize then
        notify(source, '^1GunGame is full right now, try again later.')
        return
    end

    Queue[#Queue + 1] = source
    notify(source, ('^0Joined the queue (%d waiting). A new arena starts automatically every %d players.'):format(#Queue, Config.PlayersPerArena))
    tryFormArenas()
end)

RegisterCommand(Config.LeaveCommand, function(source)
    if isInTable(Queue, source) then
        removeFromTable(Queue, source)
        notify(source, '^1You left the queue.')
    elseif Pending[source] then
        notify(source, "^1Your arena's countdown has already started, you can't leave now.")
    else
        notify(source, '^1You are not waiting in the queue (you may already be in a running arena).')
    end
end)

RegisterCommand(Config.StatsCommand, function(source)
    if not Config.UseDatabase then
        notify(source, '^1Persistent stats are disabled on this server.')
        return
    end

    exports.oxmysql:query('SELECT name, kills, wins, matches_played FROM unique_gungame_stats ORDER BY kills DESC LIMIT 10', {}, function(rows)
        if not rows or #rows == 0 then
            notify(source, '^0No GunGame stats recorded yet.')
            return
        end

        notify(source, '^3--- Unique_GunGame Top Kills ---')
        for i, row in ipairs(rows) do
            notify(source, ('^0%d. %s ^0- ^1%d kills ^0/ ^2%d wins ^0/ %d matches'):format(i, row.name, row.kills, row.wins, row.matches_played))
        end
    end)
end)

-- ============================================================
-- Player / match event handlers
-- ============================================================

AddEventHandler('playerDropped', function()
    local src = source
    removeFromTable(Queue, src)
    Pending[src] = nil

    local matchId = PlayerMatch[src]
    local match = matchId and Matches[matchId]
    if not match then return end

    match.players[src] = nil
    PlayerMatch[src] = nil

    if next(match.players) == nil then
        releaseBucket(match.bucket)
        match.state = 'ended'
        Matches[matchId] = nil
    else
        broadcastScoreboard(match)
    end
end)

RegisterServerEvent('Unique_GunGame:ReportKill')
AddEventHandler('Unique_GunGame:ReportKill', function(killerServerId, victimName)
    local killerSrc = tonumber(killerServerId)
    local matchId = PlayerMatch[killerSrc]
    local match = matchId and Matches[matchId]
    if not match then return end

    local data = match.players[killerSrc]
    if not data then return end

    data.kills = data.kills + 1
    data.streak = data.streak + 1
    persistKill(data)
    announceKillstreakIfNeeded(match, data)

    local newLevel = math.min(math.floor(data.kills / Config.KillsPerLevel), #Config.Weapons - 1)
    if newLevel ~= data.level then
        data.level = newLevel
        local weapon = Config.Weapons[data.level + 1]
        if weapon then
            TriggerClientEvent('Unique_GunGame:LevelUp', killerSrc, weapon)
        end
    end

    broadcastKillFeed(match, data.name, victimName)
    broadcastScoreboard(match)

    if data.kills >= Config.KillsToWin then
        endMatch(matchId, killerSrc)
    end
end)

RegisterServerEvent('Unique_GunGame:PlayerDied')
AddEventHandler('Unique_GunGame:PlayerDied', function()
    local matchId = PlayerMatch[source]
    local match = matchId and Matches[matchId]
    if not match then return end

    local data = match.players[source]
    if data then data.streak = 0 end
end)

RegisterServerEvent('Unique_GunGame:GiveParachute')
AddEventHandler('Unique_GunGame:GiveParachute', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    xPlayer.addWeapon('gadget_parachute', 1)
end)

-- ============================================================
-- Exports (for other resources to query GunGame state)
-- ============================================================

exports('IsPlayerInGunGame', function(source)
    return PlayerMatch[source] ~= nil
end)

exports('GetQueueSize', function()
    return #Queue
end)

-- ============================================================
-- Startup / shutdown
-- ============================================================

Citizen.CreateThread(function()
    ensureStatsTable()
end)

if Config.QueueReminderInterval and Config.QueueReminderInterval > 0 then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.QueueReminderInterval * 1000)
            if EventActive and #Queue > 0 and #Queue < Config.PlayersPerArena then
                local needed = Config.PlayersPerArena - #Queue
                broadcastMessage(('^0GunGame needs %d more player(s) to start an arena - use /%s to join!'):format(needed, Config.JoinCommand))
            end
        end
    end)
end

-- Without this, restarting the script mid-event would leave players stuck in an
-- isolated routing bucket with no way back to the normal world.
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for src in pairs(PlayerMatch) do
        SetPlayerRoutingBucket(src, 0)
        TriggerClientEvent('Unique_GunGame:End', src, Config.Locations[1])
    end
    for _, src in ipairs(Queue) do
        notify(src, '^1The GunGame script was restarted, you have been removed from the queue.')
    end
end)
