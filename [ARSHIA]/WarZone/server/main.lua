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

----Commend
RegisterCommand(Config.StartCommend,function(source,args) 
    if IsPlayerCanStart(source) then 
        if StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end 
        if Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has opened' , 'error')  end 
        Lobbey = true 
        Event = true 
        SquadCount = 1
        Squads = {} 
        Team = 1 
        Body = 0 
        SendMessage(Config.StartNotify) 
        UpdateMembers()
    end 
end) 
RegisterCommand(Config.Startmatchcommend ,function(source,args)
    if IsPlayerCanStart(source) then 
        if StartMatch then return SendNotifyServerToPlayer(source , 'Warzone has started' , 'error') end 
        if not Lobbey then return SendNotifyServerToPlayer(source , 'Lobbey has not opened' , 'error')  end 
            if tonumber(args[1]) and tonumber(args[2]) and args[3]  then
                local Coords 
                local Map 
                Team  = 1 
                if string.upper(args[3]) == 'ISLAND' then 
                    Coords = Config.IslandZone 
                    Map = 'ISLAND'

                else
                    Coords = Config.SandyZone
                    Map = 'SANDY'
                end 
                if tonumber(args[4]) and tonumber(args[4]) > 0 and tonumber(args[4]) <= 4   then 
                    Team = tonumber(args[4])
                else 
                    Team  = 1
                end 
                StartMatch = true  
                Lobbey = false 
                TriggerClientEvent("AWZ:CloseUI",-1)
                StartWarZone(tonumber(args[1]) , tonumber(args[2]) , Coords , Team , Map )
            else
                SendNotifyServerToPlayer(source , 'Enter the elements correctly' , 'error')
            end 
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
    end 
end)
RegisterCommand(Config.exitCommend,function(source,args)
    if StartMatch  or Lobbey then 
        for k,v in pairs(Players) do 
            if v.ID  ==  source then 
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
                table.remove(Players , k,v) 
                RemovePlayerFromSquad( source )
                break 
            end 
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

    if InWzNormal then
        -- Normal battlefield death
        TriggerClientEvent("AWZ:respwan", source, false)
        if KillData.killer ~= false and KillData.killer ~= "Leaved" then
            TriggerClientEvent("AWZ:respwan", KillData.killer, true, GetPlayerName(source), GetPlayerName(KillData.killer))
        end
    elseif InWzGulag then
        -- Death while in the Gulag
        for k, v in pairs(Players) do
            if v.ID == source then
                table.remove(Players, k)
                break
            end
        end
        TriggerClientEvent("AWZ:ExitMision", source)
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
            local PlayerCount = GetPlayersFromWolrd( Config.FightWorld  )
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
    end 
    Wait(1000)
    TriggerClientEvent("AWZ:ShowWinner", -1  , p1 , p2 , p3 ,p4 , true , Squad    )

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



