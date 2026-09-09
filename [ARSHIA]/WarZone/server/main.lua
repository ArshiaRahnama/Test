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
local AutoQueueRunning = false

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
            `season` INT NOT NULL DEFAULT 1,
            PRIMARY KEY (`identifier`,`season`)
        )
    ]], {})
end)

function WZ_AddStat(identifier, name, kills, wins)
    if not identifier then return end
    MySQL.Async.execute([[
        INSERT INTO wz_leaderboard (identifier, name, kills, wins, season)
        VALUES (@identifier, @name, @kills, @wins, @season)
        ON DUPLICATE KEY UPDATE
            name = @name,
            kills = kills + @kills,
            wins = wins + @wins
    ]], {
        ['@identifier'] = identifier,
        ['@name'] = name,
        ['@kills'] = kills,
        ['@wins'] = wins,
        ['@season'] = CurrentSeason,
    })
end

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
    if AutoQueueRunning then return end
    AutoQueueRunning = true
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
        AutoQueueRunning = false
    end)
end

-- Shared match-start logic used by /startmatch, the admin NUI panel, and
-- Auto-Queue. `source` is 0 for system/auto-queue starts (no player to
-- notify). Returns true on success, false + an error string otherwise.
function BeginMatch(source, blood, time, mapArg, teamArg)
    if StartMatch then
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Warzone has started', 'error') end
        return false, 'already started'
    end
    if not Lobbey then
        if source and source ~= 0 then SendNotifyServerToPlayer(source, 'Lobbey has not opened', 'error') end
        return false, 'lobby not open'
    end
    blood = tonumber(blood)
    time = tonumber(time)
    if not blood or not time or not mapArg then
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
    TriggerClientEvent("AWZ:CloseUI", -1)
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
        for k,v in pairs(Players) do  TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
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
        for k,v in pairs(Players) do  TriggerClientEvent("AWZ:ExitMision",v.ID )  end 
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
        local KeyNumber = 0 
        SquadCount = 1
        while #Players > KeyNumber do 
            Wait(5)
            KeyNumber = KeyNumber + 1 
            if type( Squads[SquadCount] ) ~= 'table'  then Squads[SquadCount] = {} end 
            table.insert( Squads[SquadCount] , Players[KeyNumber].ID )
            if #Squads[SquadCount] == Team  then 
                SquadCount = SquadCount + 1
            end     
        end 
        InsertTeam ()
        Wait(1000)
        for k,v in pairs(Players) do 
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
    -- falls into (a Gulag kill still counts).
    if KillData.killer ~= false and KillData.killer ~= "Leaved" then
        local killerPlayer = ESX.GetPlayerFromId(KillData.killer)
        if killerPlayer then
            WZ_AddStat(killerPlayer.identifier, GetPlayerName(KillData.killer), 1, 0)
        end
    end

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
        if #mates > 0 then
            table.insert(Spectators, source)
            TriggerClientEvent("AWZ:EnterSpectator", source, mates)
        else
            TriggerClientEvent("AWZ:ExitMision", source)
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
    TriggerClientEvent("AWZ:ExitMision", source)
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
            SquadAlive = #Squads 
            Wait(500)
            Alive = PlayerCount
          if #Squads  == 1  and StartMatch and  Alive <= Team  then 
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

    -- Any players still in spectator mode (their squad lost, so the match
    -- ending is their cue to leave too) get sent out now.
    for k, v in pairs(Spectators) do
        TriggerClientEvent("AWZ:ExitMision", v)
    end
    Spectators = {}

    Event = false 
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



