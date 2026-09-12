ESX = nil
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

local Event = false
local StartMatch = false 
local Lobbey = false 
local Alive = 0
local Prisoner = 0
local Body = 0
local Squads = {}
local SquadAlive = 0 
local SquadCount = 1
local Team = 1 
local Players = {}
local WzVehs = {}
local Spectators = {} -- source IDs currently in spectator mode (eliminated, squad still alive)
local CurrentSeason = 1
local MatchStartedAt = 0
local MatchStartCount = 0
-- Party system: PartyLeader[source] = leaderSource (a solo player is their
-- own leader). PartyMembers[leaderSource] = {member source ids}.
-- PendingInvites[targetSource] = leaderSource (one pending invite at a time).
local PartyLeader = {}
local PartyMembers = {}
local PendingInvites = {}
-- Match Replay: running log of this match's events, saved to DB on end.
local MatchLog = {}
local MatchId = 0
local CurrentMatchMap = ''

-------------------------------------------------------------------
-- Leaderboard (Season) -- table is per-identifier/per-season, so a
-- season reset never deletes history, it just starts a new season id.
-------------------------------------------------------------------
CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_leaderboard` (
            `identifier` VARCHAR(60) NOT NULL,
            `name` VARCHAR(100) NOT NULL DEFAULT '',
            `kills` INT NOT NULL DEFAULT 0,
            `wins` INT NOT NULL DEFAULT 0,
            `deaths` INT NOT NULL DEFAULT 0,
            `season` INT NOT NULL DEFAULT 1,
            PRIMARY KEY (`identifier`,`season`)
        )
    ]], {})
    -- Migration: this table already existed on some installs from before
    -- the `deaths` column (and /wzstats) were added -- CREATE TABLE IF NOT
    -- EXISTS does nothing to an existing table, so add the column here if
    -- it's missing. If your MySQL/MariaDB version doesn't support
    -- "ADD COLUMN IF NOT EXISTS", oxmysql will just print its own error to
    -- console here -- harmless, and everything else still starts fine.
    MySQL.Async.execute([[
        ALTER TABLE `wz_leaderboard` ADD COLUMN IF NOT EXISTS `deaths` INT NOT NULL DEFAULT 0
    ]], {})
    -- Feature: Match Replay -- one row per finished match with a JSON blob
    -- of its event log, so /wzlastmatch can show a summary later.
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `wz_match_history` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `ended_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            `map` VARCHAR(20) NOT NULL DEFAULT '',
            `player_count` INT NOT NULL DEFAULT 0,
            `winners` VARCHAR(255) NOT NULL DEFAULT '',
            `summary` TEXT,
            PRIMARY KEY (`id`)
        )
    ]], {})
end)

function WZ_AddStat(identifier, name, kills, wins, deaths)
    if not identifier then return end
    deaths = deaths or 0
    MySQL.Async.execute([[
        INSERT INTO wz_leaderboard (identifier, name, kills, wins, deaths, season)
        VALUES (@identifier, @name, @kills, @wins, @deaths, @season)
        ON DUPLICATE KEY UPDATE
            name = @name,
            kills = kills + @kills,
            wins = wins + @wins,
            deaths = deaths + @deaths
    ]], {
        ['@identifier'] = identifier,
        ['@name'] = name,
        ['@kills'] = kills,
        ['@wins'] = wins,
        ['@deaths'] = deaths,
        ['@season'] = CurrentSeason,
    })
end

function ShowMyStats(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    MySQL.Async.fetchAll([[
        SELECT SUM(kills) as kills, SUM(wins) as wins, SUM(deaths) as deaths
        FROM wz_leaderboard WHERE identifier = @identifier
    ]], {
        ['@identifier'] = xPlayer.identifier,
    }, function(rows)
        local kills = (rows and rows[1] and rows[1].kills) or 0
        local wins = (rows and rows[1] and rows[1].wins) or 0
        local deaths = (rows and rows[1] and rows[1].deaths) or 0
        local kd = deaths > 0 and string.format('%.2f', kills / deaths) or tostring(kills)
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">🔫 Your WarZone Stats<br>Kills: '..kills..' | Deaths: '..deaths..' | K/D: '..kd..'<br>Wins: '..wins..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end
RegisterCommand(Config.statsCommend, function(source, args)
    ShowMyStats(source)
end)
RegisterServerEvent('AWZ:ShowMyStats')
AddEventHandler('AWZ:ShowMyStats', function()
    ShowMyStats(source)
end)

function ShowLastMatch(source)
    MySQL.Async.fetchAll('SELECT * FROM wz_match_history ORDER BY id DESC LIMIT 1', {}, function(rows)
        if not rows or #rows == 0 then
            return SendNotifyServerToPlayer(source, 'No match history yet', 'error')
        end
        local match = rows[1]
        local lines = ''
        local ok, events = pcall(json.decode, match.summary or '[]')
        if ok and events then
            for i, ev in ipairs(events) do
                lines = lines .. (i)..'. '..ev..'<br>'
            end
        end
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">📼 Last Match ('..match.map..', '..match.player_count..' players)<br>Winners: '..match.winners..'<br>'..lines..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end
RegisterCommand(Config.lastmatchCommend, function(source, args)
    ShowLastMatch(source)
end)
RegisterServerEvent('AWZ:ShowLastMatch')
AddEventHandler('AWZ:ShowLastMatch', function()
    ShowLastMatch(source)
end)

-------------------------------------------------------------------
-- Party system: keep a group of players together in the same squad when
-- the match starts, instead of everyone being grouped by join order only.
-------------------------------------------------------------------
function GetPartyLeader(src)
    return PartyLeader[src] or src
end
function GetPartyMembers(leaderSrc)
    return PartyMembers[leaderSrc] or {leaderSrc}
end
function PartyInviteAction(source, target)
    if not target or not GetPlayerName(target) then
        return SendNotifyServerToPlayer(source, 'Invalid player id', 'error')
    end
    if target == source then
        return SendNotifyServerToPlayer(source, "You can't invite yourself", 'error')
    end
    local myLeader = GetPartyLeader(source)
    if #GetPartyMembers(myLeader) >= 4 then
        return SendNotifyServerToPlayer(source, 'Your party is already full (max 4)', 'error')
    end
    PendingInvites[target] = myLeader
    SendNotifyServerToPlayer(target, GetPlayerName(source)..' invited you to their WarZone party. Open /'..Config.menuCommend..' to accept', 'info')
    SendNotifyServerToPlayer(source, 'Invite sent to '..GetPlayerName(target), 'info')
end
function PartyAcceptAction(source)
    local leader = PendingInvites[source]
    if not leader or not GetPlayerName(leader) then
        return SendNotifyServerToPlayer(source, 'You have no pending party invite', 'error')
    end
    if #GetPartyMembers(leader) >= 4 then
        PendingInvites[source] = nil
        return SendNotifyServerToPlayer(source, 'That party is already full', 'error')
    end
    -- leave any existing party first
    LeaveParty(source)
    PartyLeader[source] = leader
    PartyMembers[leader] = PartyMembers[leader] or {leader}
    table.insert(PartyMembers[leader], source)
    PendingInvites[source] = nil
    for _, mid in ipairs(PartyMembers[leader]) do
        SendNotifyServerToPlayer(mid, GetPlayerName(source)..' joined the party', 'info')
    end
end
function PartyLeaveAction(source)
    LeaveParty(source)
    SendNotifyServerToPlayer(source, 'You left your party', 'info')
end
function PartyListAction(source)
    local leader = GetPartyLeader(source)
    local names = {}
    for _, mid in ipairs(GetPartyMembers(leader)) do
        table.insert(names, GetPlayerName(mid) or ('#'..mid))
    end
    SendNotifyServerToPlayer(source, 'Party: '..table.concat(names, ', '), 'info')
end
RegisterCommand(Config.partyCommend, function(source, args)
    local sub = args[1]
    if sub == 'invite' then
        PartyInviteAction(source, tonumber(args[2]))
    elseif sub == 'accept' then
        PartyAcceptAction(source)
    elseif sub == 'leave' then
        PartyLeaveAction(source)
    elseif sub == 'list' then
        PartyListAction(source)
    else
        SendNotifyServerToPlayer(source, 'Usage: /'..Config.partyCommend..' invite <id> | accept | leave | list', 'error')
    end
end)
RegisterServerEvent('AWZ:PartyInviteEvent')
AddEventHandler('AWZ:PartyInviteEvent', function(target)
    PartyInviteAction(source, tonumber(target))
end)
RegisterServerEvent('AWZ:PartyAcceptEvent')
AddEventHandler('AWZ:PartyAcceptEvent', function()
    PartyAcceptAction(source)
end)
RegisterServerEvent('AWZ:PartyLeaveEvent')
AddEventHandler('AWZ:PartyLeaveEvent', function()
    PartyLeaveAction(source)
end)
function LeaveParty(src)
    local leader = PartyLeader[src]
    if not leader then return end
    if PartyMembers[leader] then
        for k, mid in ipairs(PartyMembers[leader]) do
            if mid == src then table.remove(PartyMembers[leader], k) break end
        end
        if #PartyMembers[leader] <= 1 then
            PartyMembers[leader] = nil
        end
    end
    PartyLeader[src] = nil
end
AddEventHandler('playerDropped', function()
    LeaveParty(source)
    PendingInvites[source] = nil
end)

-- Feature: /warzone menu support -- current party state and the online
-- player list, both used to build the icon_menu client-side without
-- needing the player to type anyone's id.
ESX.RegisterServerCallback('AWZ:GetPartyInfo', function(source, cb)
    local leader = GetPartyLeader(source)
    local members = GetPartyMembers(leader)
    local memberNames = {}
    local inParty = #members > 1
    if inParty then
        for _, mid in ipairs(members) do
            if mid ~= source then
                table.insert(memberNames, GetPlayerName(mid) or ('#'..mid))
            end
        end
    end
    local pendingFromName = nil
    if PendingInvites[source] then
        pendingFromName = GetPlayerName(PendingInvites[source])
    end
    cb({
        inParty = inParty,
        isLeader = (leader == source),
        members = memberNames,
        pendingFrom = pendingFromName,
    })
end)
ESX.RegisterServerCallback('AWZ:GetOnlinePlayers', function(source, cb)
    local list = {}
    for _, playerId in ipairs(GetPlayers()) do
        local pid = tonumber(playerId)
        if pid ~= source then
            table.insert(list, { id = pid, name = GetPlayerName(pid) })
        end
    end
    cb(list)
end)


RegisterCommand(Config.wztopCommend, function(source, args)
    MySQL.Async.fetchAll('SELECT name, kills, wins FROM wz_leaderboard WHERE season = @season ORDER BY (wins*5 + kills) DESC LIMIT @lim', {
        ['@season'] = CurrentSeason,
        ['@lim'] = Config.Leaderboard.top,
    }, function(rows)
        if not rows or #rows == 0 then
            return SendNotifyServerToPlayer(source, 'Leaderboard is empty for this season', 'error')
        end
        local lines = ''
        for i, row in ipairs(rows) do
            lines = lines .. i..'. '..row.name..' — '..row.wins..' wins / '..row.kills..' kills<br>'
        end
        local template = '<div style="padding: 0.6vw; margin: 0.5vw; background-color:rgba(0,0,0,0.75); border-radius: 3px; font-size:0.85vw;">🏆 WarZone Leaderboard (Season '..CurrentSeason..')<br>'..lines..'</div>'
        TriggerClientEvent('chat:addMessage', source, {template = template, args = {}})
    end)
end)

RegisterCommand(Config.seasonresetCommend, function(source, args)
    if not IsPlayerCanStart(source) then
        return SendNotifyServerToPlayer(source, 'You do not have permission to use this command', 'error')
    end
    MySQL.Async.fetchAll('SELECT identifier, name, kills, wins FROM wz_leaderboard WHERE season = @season ORDER BY (wins*5 + kills) DESC LIMIT 1', {
        ['@season'] = CurrentSeason,
    }, function(rows)
        local rewardedText = 'No players on the leaderboard this season.'
        if rows and #rows > 0 then
            local top = rows[1]
            -- Only pay out if the #1 player is currently online (we only
            -- have a `source` for connected players).
            for _, playerId in ipairs(GetPlayers()) do
                local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
                if xPlayer and xPlayer.identifier == top.identifier then
                    xPlayer.addMoney(Config.Leaderboard.seasonRewardTop1)
                    rewardedText = top.name..' wins Season '..CurrentSeason..' and gets $'..Config.Leaderboard.seasonRewardTop1..'!'
                end
            end
            if rewardedText == 'No players on the leaderboard this season.' then
                rewardedText = top.name..' wins Season '..CurrentSeason..' with '..top.wins..' wins / '..top.kills..' kills, but is offline so the reward was not paid automatically.'
            end
        end
        SendMessage(rewardedText)
        SendDiscordWebhook('🏆 Season '..CurrentSeason..' ended', rewardedText, 15844367)
        CurrentSeason = CurrentSeason + 1
        SendMessage('Season '..CurrentSeason..' has begun!')
    end)
end)

-------------------------------------------------------------------
-- Discord Webhook
-------------------------------------------------------------------
function SendDiscordWebhook(title, description, color)
    if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
        json.encode({
            username = Config.DiscordWebhookName,
            embeds = { { title = title, description = description, color = color or 3447003 } }
        }),
        { ['Content-Type'] = 'application/json' }
    )
end

-------------------------------------------------------------------
-- Auto-Queue: once enough players have joined the open lobby, count
-- down and auto-start the match with the configured defaults. Any
-- admin can still start manually at any time (this thread just backs
-- off once StartMatch/Lobbey flip).
-------------------------------------------------------------------
function AutoQueueWatch()
    -- Fix: this used to gate on a global `AutoQueueRunning` flag that only
    -- got cleared once the OLD thread's `Wait()` resolved and it noticed
    -- Lobbey had flipped false -- up to a few seconds later. If an admin
    -- closed and reopened the lobby quickly, the new call could see the
    -- flag still "true" and skip starting a watcher entirely, silently
    -- disabling Auto-Queue for that session. BeginMatch() already guards
    -- against double-starting a match (via the StartMatch flag), so it's
    -- safe to just let a fresh thread run per lobby session instead.
    CreateThread(function()
        while Lobbey and not StartMatch do
            Wait(3000)
            if Lobbey and not StartMatch and #Players >= Config.AutoQueue.minPlayers then
                SendMessage('Enough players joined — match starts in '..Config.AutoQueue.countdown..'s!')
                local secondsLeft = Config.AutoQueue.countdown
                while secondsLeft > 0 and Lobbey and not StartMatch do
                    Wait(1000)
                    secondsLeft = secondsLeft - 1
                    -- lost enough players in the meantime, abort the countdown
                    if #Players < Config.AutoQueue.minPlayers then
                        SendMessage('Not enough players anymore, auto-start cancelled.')
                        break
                    end
                    if secondsLeft > 0 and secondsLeft <= 5 then
                        SendMessage('Match starting in '..secondsLeft..'...')
                    end
                end
                if Lobbey and not StartMatch and #Players >= Config.AutoQueue.minPlayers and secondsLeft <= 0 then
                    BeginMatch(0, Config.AutoQueue.defaultBlood, Config.AutoQueue.defaultTime, Config.AutoQueue.defaultMap, Config.AutoQueue.defaultTeam)
                end
            end
        end
    end)
end

-- Shared match-start logic used by /startmatch, the admin NUI panel, and
-- Auto-Queue. `source` is 0 for system/auto-queue starts (no player to
-- notify). Returns true on success, false + an error string otherwise.
function BeginMatch(source, blood, time, mapArg, teamArg)
    print('[WZ DEBUG] BeginMatch called: source='..tostring(source)..' blood='..tostring(blood)..' time='..tostring(time)..' map='..tostring(mapArg)..' team='..tostring(teamArg)..' | StartMatch='..tostring(StartMatch)..' Lobbey='..tostring(Lobbey)..' #Players='..#Players)
    if StartMatch then
        print('[WZ DEBUG] BeginMatch REJECTED: match already started')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Warzone has started', 'error') end
        return false, 'already started'
    end
    if not Lobbey then
        print('[WZ DEBUG] BeginMatch REJECTED: lobby not open')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Lobbey has not opened', 'error') end
        return false, 'lobby not open'
    end
    blood = tonumber(blood)
    time = tonumber(time)
    if not blood or not time or blood <= 0 or time <= 0 or not mapArg then
        print('[WZ DEBUG] BeginMatch REJECTED: bad args (blood='..tostring(blood)..' time='..tostring(time)..' map='..tostring(mapArg)..')')
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Enter the elements correctly', 'error') end
        return false, 'bad args'
    end
    local Coords, Map
    if string.upper(mapArg) == 'ISLAND' then
        Coords = Config.IslandZone
        Map = 'ISLAND'
    else
        Coords = Config.SandyZone
        Map = 'SANDY'
    end
    teamArg = tonumber(teamArg)
    if teamArg and teamArg > 0 and teamArg <= 4 then
        Team = teamArg
    else
        Team = 1
    end
    StartMatch = true
    Lobbey = false
    MatchStartedAt = os.time()
    MatchStartCount = #Players
    MatchId = MatchId + 1
    MatchLog = {'Match started on '..Map..' with '..#Players..' players'}
    CurrentMatchMap = Map
    print('[WZ DEBUG] BeginMatch ACCEPTED: Map='..Map..' Team='..Team..' #Players going in='..#Players)
    TriggerClientEvent("AWZ:CloseUI", -1)
    AntiCheatMonitor()
    StartWarZone(blood, time, Coords, Team, Map)
    return true
end

----Commend
function OpenLobby(source)
    if StartMatch then
        if source and source ~= 0 then SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end
        return false
    end
    if Lobbey then
        if source and source ~= 0 then SendNotifyServerToPlayer(source , 'Lobbey has opened' , 'error') end
        return false
    end
    Lobbey = true 
    Event = true 
    SquadCount = 1
    Squads = {} 
    Team = 1 
    Body = 0 
    SendMessage(Config.StartNotify) 
    UpdateMembers()
    if Config.AutoQueue.enabled then
        AutoQueueWatch()
    end
    return true
end
RegisterCommand(Config.StartCommend,function(source,args) 
    if IsPlayerCanStart(source) then 
        OpenLobby(source)
    else
        -- Fix: this used to fail completely silently when the player's
        -- permission_level was too low, giving no feedback at all.
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end) 
-- Admin GUI panel entry point for opening the lobby.
RegisterServerEvent('AWZ:AdminOpenLobby')
AddEventHandler('AWZ:AdminOpenLobby', function()
    if IsPlayerCanStart(source) then
        OpenLobby(source)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)
RegisterCommand(Config.Startmatchcommend ,function(source,args)
    if IsPlayerCanStart(source) then 
        BeginMatch(source, args[1], args[2], args[3], args[4])
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
-- Admin NUI panel: opens client-side (permission is re-checked here before
-- opening, and again in AWZ:AdminStart below before actually starting).
RegisterCommand(Config.panelCommend, function(source, args)
    if IsPlayerCanStart(source) then
        TriggerClientEvent('AWZ:OpenAdminPanel', source, Lobbey, StartMatch)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)
RegisterServerEvent('AWZ:AdminStart')
AddEventHandler('AWZ:AdminStart', function(blood, time, mapArg, teamArg)
    if IsPlayerCanStart(source) then
        BeginMatch(source, blood, time, mapArg, teamArg)
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end
end)

RegisterCommand(Config.JoinLobbeyCommend,function(source,args)
    local InWz = false 
    for k,v in pairs(Players) do if v.ID == source then  InWz = true  end end 
    if Lobbey  then 
        if not InWz then 
            TriggerClientEvent("AWZ:OpenUI",source)

        end
    else 
        SendNotifyServerToPlayer(source , 'Lobbey has not opened' , 'error')  
    end
end)
RegisterCommand(Config.closelobbey,function(source,args)
    if IsPlayerCanStart(source) then 
        if  StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end 
        if not  Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has not  opened' , 'error')  end 
        for k,v in pairs(Players) do  print('[WZ DEBUG] ExitMision -> '..v.ID..' from CLOSELOBBEY command') TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
        Players = {}
        StartMatch = false 
        Lobbey = false 
        Event = false 
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
RegisterCommand(Config.endwarzoneCommend ,function(source,args)
    if IsPlayerCanStart(source) then 
        if not StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has not started' , 'error') end 
        if  Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has opened' , 'error')  end 
        for k,v in pairs(Players) do  print('[WZ DEBUG] ExitMision -> '..v.ID..' from ENDWARZONE command') TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
        Players = {}
        StartMatch = false 
        Lobbey = false 
        Event = false 
    else
        SendNotifyServerToPlayer(source , 'You do not have permission to use this command' , 'error')
    end 
end)
RegisterCommand(Config.exitCommend,function(source,args)
    if StartMatch  or Lobbey then 
        for k,v in pairs(Players) do 
            if v.ID  ==  source then 
                -- Fix: leaving via /exitwz while in the Gulag never
                -- decremented Prisoner (only dying there did), leaving the
                -- counter permanently stale and able to block the match from
                -- ever detecting a winner.
                if v.ingulag then
                    Prisoner = Prisoner - 1
                end
                table.remove(Players , k,v) 
                print('[WZ DEBUG] ExitMision -> '..source..' from EXITWZ command')
                TriggerClientEvent("AWZ:ExitMision",source )
                SendNotifyServerToPlayer(source , 'You left the Battle' , 'info') 
                break 
            end 
        end 
    end 
end)
function StartWarZone( Blood , Time , Coord , Team , Map) 
    SendMessage(Config.StartMatchNotify) 
    CreateThread(function()
        print('[WZ DEBUG] StartWarZone thread begins, snapshotting #Players='..#Players)
        -- Fix: this loop used to read the live `Players` table across
        -- Wait(5) yields, so a player disconnecting/leaving mid-loop (still
        -- possible: StartMatch is already true, and playerDropped/exitwz
        -- both still remove from Players once it is) could shift indices
        -- out from under it, or shrink Players below `KeyNumber` --
        -- crashing this thread on `Players[KeyNumber].ID` being nil and
        -- leaving squads only half-assigned for the whole match. Snapshot
        -- the roster synchronously (no yields) first, then build squads
        -- from the stable copy.
        local PlayersSnapshot = {}
        for _, p in ipairs(Players) do
            table.insert(PlayersSnapshot, p)
        end
        local KeyNumber = 0 
        SquadCount = 1
        -- Feature: Party-aware squad building + Squad Fill. Group the
        -- snapshot by party leader first (a solo player is their own
        -- "party" of one), place each party into its own squad slot(s),
        -- then top up any squad still short of `Team` with leftover solo
        -- players instead of leaving them in their own tiny squad.
        local seen = {}
        local groups = {}
        for _, p in ipairs(PlayersSnapshot) do
            if not seen[p.ID] then
                local leader = GetPartyLeader(p.ID)
                local group = {}
                for _, memberId in ipairs(GetPartyMembers(leader)) do
                    -- only include party members who actually joined this lobby
                    for _, p2 in ipairs(PlayersSnapshot) do
                        if p2.ID == memberId and not seen[memberId] then
                            table.insert(group, memberId)
                            seen[memberId] = true
                        end
                    end
                end
                if #group == 0 then
                    table.insert(group, p.ID)
                    seen[p.ID] = true
                end
                table.insert(groups, group)
            end
        end
        local soloLeftovers = {}
        for _, group in ipairs(groups) do
            Wait(5)
            if #group > Team then
                -- party bigger than the team size: split across squads
                for i = 1, #group, Team do
                    Squads[SquadCount] = {}
                    for j = i, math.min(i + Team - 1, #group) do
                        table.insert(Squads[SquadCount], group[j])
                    end
                    SquadCount = SquadCount + 1
                end
            elseif #group == 1 then
                -- solo player -- park them for the fill-in pass below
                table.insert(soloLeftovers, group[1])
            else
                Squads[SquadCount] = {}
                for _, memberId in ipairs(group) do
                    table.insert(Squads[SquadCount], memberId)
                end
                SquadCount = SquadCount + 1
            end
        end
        -- Squad Fill: top up the last party squad (if it has room) and any
        -- solo players into shared squads, instead of every solo player
        -- getting their own squad.
        local fillIndex = SquadCount - 1
        if type(Squads[fillIndex]) ~= 'table' or #Squads[fillIndex] >= Team then
            fillIndex = SquadCount
        end
        for _, soloId in ipairs(soloLeftovers) do
            if type(Squads[fillIndex]) ~= 'table' then Squads[fillIndex] = {} end
            table.insert(Squads[fillIndex], soloId)
            if #Squads[fillIndex] >= Team then
                fillIndex = fillIndex + 1
            end
        end
        if type(Squads[fillIndex]) == 'table' and #Squads[fillIndex] == 0 then
            Squads[fillIndex] = nil
        end
        -- Defensive: a player could still disconnect during the snapshot
        -- window above (or the Wait(5) ticks while squads are built). Drop
        -- any squad member no longer in the live Players table so they
        -- can't linger as a "ghost" member -- which CountSquads()/the win
        -- check would otherwise never be able to clear, since a departed
        -- player never triggers their own squad cleanup twice.
        for i, squad in pairs(Squads) do
            if type(squad) == 'table' then
                for k = #squad, 1, -1 do
                    local stillHere = false
                    for _, p in ipairs(Players) do
                        if p.ID == squad[k] then stillHere = true break end
                    end
                    if not stillHere then
                        table.remove(squad, k)
                    end
                end
                if #squad == 0 then
                    Squads[i] = nil
                end
            end
        end
        local squadDebug = ''
        for i, squad in pairs(Squads) do
            if type(squad) == 'table' then
                squadDebug = squadDebug..'squad'..i..'=['..table.concat(squad, ',')..'] '
            end
        end
        print('[WZ DEBUG] Squads built: '..squadDebug)
        InsertTeam ()
        Wait(1000)
        print('[WZ DEBUG] About to send AWZ:StartMatch to #Players='..#Players..' (live table, post-Wait(1000))')
        for k,v in pairs(Players) do 
            print('[WZ DEBUG] -> sending AWZ:StartMatch to source='..v.ID)
            SetPlayerRoutingBucket(v.ID, Config.FightWorld  )
            TriggerClientEvent('AWZ:StartMatch' ,v.ID, Blood , Config.DistanceZone , Coord , Time , 0  , Map )
        end 
    end)
end 
function InsertTeam ()
    if #Squads  ~= 0  and #Players ~= 0 then 
        for i=1 , #Squads  , 1 do 
            local Myteam = {}
            for d = 1 , #Squads[i]  , 1 do  
                table.insert(Myteam , { ID = Squads[i][d]  , Name =  GetPlayerName(Squads[i][d])} )
            end 
            for k,v in pairs( Myteam ) do
                TriggerClientEvent("AWZ:MyTeam",v.ID , Myteam  , Team  , v.ID , GetPlayerName( v.ID )  )
            end
        end     
    end 
end 

AddEventHandler('playerDropped', function () 
    if StartMatch  or Lobbey then  
        for k,v in pairs(Players) do 
            if v.ID == source then 
                -- Fix: disconnecting while in the Gulag never decremented
                -- Prisoner either, same stale-counter problem as /exitwz.
                if v.ingulag then
                    Prisoner = Prisoner - 1
                end
                table.remove(Players , k,v) 
                RemovePlayerFromSquad( source )
                break 
            end 
        end 
    end 
    for k, v in pairs(Spectators) do
        if v == source then
            table.remove(Spectators, k)
            break
        end
    end
end) 
RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(KillData)
    if not StartMatch then return end
    local InWzNormal, InWzGulag = false, false
    for k, v in pairs(Players) do
        if v.ID == source then
            if v.ingulag then InWzGulag = true else InWzNormal = true end
        end
    end
    if not InWzNormal and not InWzGulag then return end

    -- Leaderboard: track the kill regardless of which branch this death
    -- falls into (a Gulag kill still counts), and always count a death for
    -- the victim (used for /wzstats K/D).
    local killerName = 'the Gulag'
    if KillData.killer ~= false and KillData.killer ~= "Leaved" then
        local killerPlayer = ESX.GetPlayerFromId(KillData.killer)
        if killerPlayer then
            WZ_AddStat(killerPlayer.identifier, GetPlayerName(KillData.killer), 1, 0, 0)
            killerName = GetPlayerName(KillData.killer)
        end
    end
    local victimPlayer = ESX.GetPlayerFromId(source)
    if victimPlayer then
        WZ_AddStat(victimPlayer.identifier, GetPlayerName(source), 0, 0, 1)
    end
    table.insert(MatchLog, GetPlayerName(source)..' was eliminated by '..killerName)

    if InWzNormal then
        -- Normal battlefield death
        TriggerClientEvent("AWZ:respwan", source, false)
        if KillData.killer ~= false and KillData.killer ~= "Leaved" then
            TriggerClientEvent("AWZ:respwan", KillData.killer, true, GetPlayerName(source), GetPlayerName(KillData.killer))
        end
    elseif InWzGulag then
        -- Death while in the Gulag: this is a real elimination. If any
        -- squadmate is still alive, send the player to spectator mode
        -- instead of exiting them straight out of the resource.
        local mates = GetAliveSquadmates(source)
        for k, v in pairs(Players) do
            if v.ID == source then
                table.remove(Players, k)
                break
            end
        end
        -- Fix: this player is done either way (fighting or spectating), so
        -- they must be removed from Squads now. Leaving them listed there
        -- while spectating meant a squad whose last real fighter had died
        -- still looked "alive" to CountSquads()/the win check forever,
        -- since the squad's entry was never emptied.
        RemovePlayerFromSquad(source)
        if #mates > 0 then
            table.insert(Spectators, source)
            TriggerClientEvent("AWZ:EnterSpectator", source, mates)
        else
            print("[WZ DEBUG] ExitMision -> "..source.." from GULAG DEATH (no alive squadmates)") TriggerClientEvent("AWZ:ExitMision", source)
        end
        Prisoner = Prisoner - 1
        if KillData.killer ~= false and KillData.killer ~= "Leaved" then
            for k, v in pairs(Players) do
                if v.ID == KillData.killer then
                    v.ingulag = false
                    Prisoner = Prisoner - 1
                end
            end
            TriggerClientEvent("AWZ:respwan", KillData.killer, true, GetPlayerName(source), GetPlayerName(KillData.killer))
            TriggerClientEvent("AWZ:Prisonbreak", KillData.killer)
        end
    end
end)
-- Returns the source IDs of `src`'s squadmates that are still alive
-- (present in Players), used to decide whether to spectate or fully exit.
function GetAliveSquadmates(src)
    local mates = {}
    for i, squad in pairs(Squads) do
        if type(squad) == 'table' then
            local isMember = false
            for _, id in pairs(squad) do
                if id == src then isMember = true end
            end
            if isMember then
                for _, id in pairs(squad) do
                    if id ~= src then
                        for _, p in pairs(Players) do
                            if p.ID == id then
                                table.insert(mates, id)
                            end
                        end
                    end
                end
                break
            end
        end
    end
    return mates
end
RegisterServerEvent('AWZ:LeaveSpectator')
AddEventHandler('AWZ:LeaveSpectator', function()
    for k, v in pairs(Spectators) do
        if v == source then
            table.remove(Spectators, k)
            break
        end
    end
    print("[WZ DEBUG] ExitMision -> "..source.." from LEAVE SPECTATOR") TriggerClientEvent("AWZ:ExitMision", source)
end)
RegisterServerEvent("AWZ:SetRBucket")
AddEventHandler("AWZ:SetRBucket", function(Wz)
    SetPlayerRoutingBucket(source,Wz)
end)
-- Fix: this event was triggered by the client (entering the Gulag) but never
-- handled server-side, so players were never actually moved to the Gulag's
-- routing bucket and stayed visible/interactable in the main fight world.
RegisterServerEvent("Warzone:SetW")
AddEventHandler("Warzone:SetW", function(Wz)
    SetPlayerRoutingBucket(source, Wz)
end)
RegisterServerEvent("AWZ:Loadout")
AddEventHandler("AWZ:Loadout", function(loadout)
    for k,v in pairs(Players) do 
        TriggerClientEvent("AWZ:UpdateLoadout",v.ID,loadout)
    end 
end)

ESX.RegisterServerCallback('AWZ:SetPlayerInWarZone', function(source, cb)
    local CanInsert =  true 
    for k,v in pairs(Players) do 
        if v.ID == source then 
            CanInsert = false 
        end
    end 
    if CanInsert then 
        SetPlayerRoutingBucket(source , Config.LobbeyWorld  )
        table.insert(Players , { ID = source , ingulag = false })
    end    
    print('[WZ DEBUG] AWZ:SetPlayerInWarZone source='..source..' CanInsert='..tostring(CanInsert)..' #Players now='..#Players)
     cb(CanInsert)
end)
ESX.RegisterServerCallback('AWZ:SetPlayerInGulag', function(source, cb)
    local CanInsert =  true 
    for k,v in pairs(Players) do 
        if v.ID == source then 
          v.ingulag = true 
          Prisoner = Prisoner + 1
        end
    end 
     cb(Prisoner)
end)
ESX.RegisterServerCallback('AWZ:GetPlayerInGulag', function(source, cb)
    cb(Prisoner)
end)
-- Fix: the client called this callback (when the Gulag timer runs out with no
-- opponent) but it was never registered server-side, so the prisoner never
-- actually got cleared and the Prisoner counter stayed stale.
ESX.RegisterServerCallback('AWZ:SetPlayerRemoveGulag', function(source, cb)
    for k, v in pairs(Players) do
        if v.ID == source and v.ingulag then
            v.ingulag = false
            Prisoner = Prisoner - 1
        end
    end
    cb(true)
end)
function UpdateMembers()
    CreateThread(function()
        while Event do  
            Wait(10 * 1000)
            -- Fix: this used to count live players via routing-bucket
            -- membership (GetPlayersFromWolrd), which breaks with Spectator
            -- Mode -- a spectating (eliminated) player deliberately stays in
            -- the fight world's bucket so they can see their teammates, so
            -- the bucket count would never drop for them. `#Players` is the
            -- authoritative "still competing" count (spectators are removed
            -- from it the moment they're eliminated).
            local PlayerCount = #Players
            SquadAlive = CountSquads()
            Wait(500)
            Alive = PlayerCount
          if CountSquads()  == 1  and StartMatch and  Alive <= Team  then 
                for k ,v in pairs(Squads) do 
                    WarZoneWinner( v) 
                    DelVehs()
                    Event = false
                    StartMatch = false 
                    Lobbey = false 
                    Alive = 0
                    Prisoner = 0
                    Body = 0
                    SquadAlive = 0 
                    Team = 1 
                    Players = {}
                    WzVehs = {}
                    break 
                end 
            end 
            if PlayerCount  == 1   and StartMatch then 
                for k ,v in pairs(Players) do 
                    local Won = {}
                    table.insert(Won , v.ID )
                    Wait(500)
                    WarZoneWinner( Won ) 
                    DelVehs()
                    Event = false
                    StartMatch = false 
                    Lobbey = false 
                    Alive = 0
                    Prisoner = 0
                    Body = 0
                    SquadAlive = 0 
                    Team = 1 
                    Players = {}
                    WzVehs = {}
                    break 
                end 
            end 
            for k,v in pairs(Players) do 
                TriggerClientEvent("AWZ:UpdateAlive",v.ID,PlayerCount , SquadAlive)
            end 
        end 
    end)
end 
function DelVehs()
    CreateThread(function()
        for k,v in pairs(WzVehs) do 
            if DoesEntityExist(v) then 
             
                DeleteEntity(v)
            end 
        end 
    end)
end 

function WarZoneWinner(Winners)
    local p1 , p2 , p3 , p4 = '' , '', '' ,''
    local Squad = {}
    for k,v in pairs( Winners ) do 
        if k == 1 then 
            p1 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 2 then 
            p2 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 3 then 
            p3 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        elseif k == 4 then 
            p4 = GetPlayerName( v )
            table.insert( Squad, v )
            Reward(v )
        end 
    end 
    for k,v in pairs( Squad) do 
        TriggerClientEvent("AWZ:WinnerTeam",v , true )
        -- Leaderboard: record a win for every member of the winning squad.
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer then
            WZ_AddStat(xPlayer.identifier, GetPlayerName(v), 0, 1)
        end
    end 
    Wait(1000)
    TriggerClientEvent("AWZ:ShowWinner", -1  , p1 , p2 , p3 ,p4 , true , Squad    )

    -- Discord Webhook: announce the result.
    local winnerNames = {}
    for _, n in ipairs({p1, p2, p3, p4}) do
        if n ~= '' then table.insert(winnerNames, n) end
    end
    local durationMin = math.floor((os.time() - MatchStartedAt) / 60)
    SendDiscordWebhook(
        '🔫 WarZone match ended',
        '**Winners:** '..table.concat(winnerNames, ', ')..'\n**Players:** '..MatchStartCount..'\n**Duration:** '..durationMin..' min',
        3066993
    )

    -- Feature: Match Replay -- save this match's event log for /wzlastmatch.
    table.insert(MatchLog, 'Winner: '..table.concat(winnerNames, ', '))
    MySQL.Async.execute([[
        INSERT INTO wz_match_history (map, player_count, winners, summary)
        VALUES (@map, @player_count, @winners, @summary)
    ]], {
        ['@map'] = CurrentMatchMap or '',
        ['@player_count'] = MatchStartCount,
        ['@winners'] = table.concat(winnerNames, ', '),
        ['@summary'] = json.encode(MatchLog),
    })

    -- Any players still in spectator mode (their squad lost, so the match
    -- ending is their cue to leave too) get sent out now.
    for k, v in pairs(Spectators) do
        print("[WZ DEBUG] ExitMision -> "..v.." from MATCH WINNER cleanup (leftover spectator)") TriggerClientEvent("AWZ:ExitMision", v)
    end
    Spectators = {}

    Event = false 
end  

-- Fix: RemovePlayerFromSquad() sets Squads[i] = nil for an eliminated squad,
-- which leaves a hole in the Squads table. Lua's `#` length operator is
-- undefined behaviour on a table with holes (it can return any valid
-- "border" index, not the real count) -- so `#Squads` could silently give
-- the wrong number of remaining squads once any squad other than the last
-- one is fully eliminated, and the "only 1 squad left" win check could
-- then never fire. This counts non-nil entries directly instead.
function CountSquads()
    local count = 0
    for k, v in pairs(Squads) do
        if type(v) == 'table' then
            count = count + 1
        end
    end
    return count
end
function RemovePlayerFromSquad ( src )
    if #Squads  ~= 0  and #Players ~= 0 then 
        CreateThread(function()            
            for k,v in pairs(Players) do 
                if v.ID == src then 
                    table.remove(Players , k,v) 
                end 
            end 
        end)
        for i,m in pairs(Squads) do 
            if type( Squads[i] ) == 'table'  then 
                for k,v in pairs(Squads[i]) do 
                    if v == src then 
                        table.remove(Squads[i] , k ,v  ) 
                    end 
                end 
                if #Squads[i] == 0 then 
                    Squads[i] = nil 
                 end 
            end 
        end 
    end 
end 
ESX.RegisterServerCallback('AWZ:RemoveForSquad', function(source, cb)
    RemovePlayerFromSquad ( source  )
    cb(true)
end)

RegisterNetEvent("WarZone:SetBodyBox")
AddEventHandler("WarZone:SetBodyBox",function(Weapons , Coords)
CreateThread(function()
    local Weapons = Weapons
    local Coords = Coords
    Wait(5000)
    Body = Body + 1
    for k,v in pairs(Players) do 
        TriggerClientEvent("WarZone:GetBoxLoot", v.ID ,Weapons , Coords , Body )
    end 
end)
end) 
RegisterNetEvent("WarZone:SyncDelBox")
AddEventHandler("WarZone:SyncDelBox",function( codeBox )
    for k,v in pairs(Players) do
        TriggerClientEvent("WarZone:clSyncDelBox", v.ID  ,codeBox)
    end 
end)
function SendMessage( msg )
    local template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color:rgba(255, 0, 0, 0.4);  border-radius: 3px;">🔫 WarZone   <br> '..msg..' <br> </div>'
    -- Fix: the default chat resource's detectChannel() does table.concat(args, ...),
    -- so `args` must be a table -- passing a string (".") crashed cl_chat.lua
    -- every time this function ran (e.g. on /startwarzone).
    TriggerClientEvent('chat:addMessage', -1 , {template = template ,args = {}})
end 
-------------------------------------------------------------------
-- Anti-Cheat (simple): samples each in-match player's position every
-- Config.AntiCheat.checkIntervalMs and flags anyone moving faster than
-- Config.AntiCheat.maxSpeed. This is intentionally basic (alert-only by
-- default) -- it resets its own tracking whenever a player's Gulag state
-- changes, since entering/leaving the Gulag is a legitimate long-distance
-- teleport that would otherwise always false-positive.
-------------------------------------------------------------------
local AntiCheatLastPos = {}
local AntiCheatLastGulag = {}
function AntiCheatMonitor()
    if not Config.AntiCheat.enabled then return end
    CreateThread(function()
        AntiCheatLastPos = {}
        AntiCheatLastGulag = {}
        while StartMatch do
            Wait(Config.AntiCheat.checkIntervalMs)
            for _, p in ipairs(Players) do
                local ped = GetPlayerPed(p.ID)
                if ped and ped ~= 0 and DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local last = AntiCheatLastPos[p.ID]
                    local gulagChanged = AntiCheatLastGulag[p.ID] ~= nil and AntiCheatLastGulag[p.ID] ~= p.ingulag
                    if last and not gulagChanged then
                        local dist = #(coords - last.coords)
                        local dt = (GetGameTimer() - last.time) / 1000.0
                        if dt > 0.1 then
                            local speed = dist / dt
                            if speed > Config.AntiCheat.maxSpeed then
                                local msg = (GetPlayerName(p.ID) or ('#'..p.ID))..' moved '..math.floor(dist)..'m in '..string.format('%.1f', dt)..'s (~'..math.floor(speed)..' m/s) in WarZone -- possible speed/teleport hack'
                                print('[WZ ANTICHEAT] '..msg)
                                SendDiscordWebhook('⚠️ Possible cheat detected', msg, 15158332)
                                for _, adminId in ipairs(GetPlayers()) do
                                    local aid = tonumber(adminId)
                                    if IsPlayerCanStart(aid) then
                                        SendNotifyServerToPlayer(aid, msg, 'error')
                                    end
                                end
                                if Config.AntiCheat.action == 'kick' then
                                    DropPlayer(p.ID, 'Kicked: suspicious movement detected in WarZone')
                                end
                            end
                        end
                    end
                    AntiCheatLastPos[p.ID] = {coords = coords, time = GetGameTimer()}
                    AntiCheatLastGulag[p.ID] = p.ingulag
                end
            end
        end
    end)
end

function GetPlayersFromWolrd( Wolrd )
    local xPlayers = ESX.GetPlayers()
    local Players = 0 
    for k, v in pairs (xPlayers) do 
        if GetPlayerRoutingBucket(v) == Wolrd then
            Players = Players + 1 
        end 
    end 
    return Players
end

ESX.RegisterServerCallback('setweapons', function(source, cb, weapons)
    local xPlayer = ESX.GetPlayerFromId(source)
    if weapons then
        for k,v in pairs(weapons) do
            xPlayer.addWeapon(v.name, v.ammo)
            for kk,vv in pairs(v.components) do 
                xPlayer.addWeaponComponent(v.name, vv)
            end
        end
        cb(true)
    end
end)



