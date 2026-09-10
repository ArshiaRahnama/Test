do

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function IsPoliceJob(jobname)
    return jobname == 'police' or jobname == 'sheriff' or jobname == 'fbi' or jobname == 'mt'
        or jobname == 'cid' or jobname == 'cia' or jobname == 'marshal' or jobname == 'judge' or jobname == 'doa'
end

ESX.RegisterUsableItem('darkphone', function(source)
    TriggerClientEvent('DarkPhone:OpenMenu', source)
end)

local LastHostageTime = nil
local HostageOwner = nil

RegisterServerEvent('DarkPhone:StartHostage')
AddEventHandler('DarkPhone:StartHostage', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Gerogan Giri Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Gerogan Giri Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end

    if LastHostageTime then
        if (os.time() - LastHostageTime) < Config.DarkPhone.Hostage.Cooldown then
            TriggerClientEvent('esx:showNotification', _source, "Gerogan Giri Dar Cooldown Ast Lotfan "..(Config.DarkPhone.Hostage.Cooldown - (os.time() - LastHostageTime)).." Sanie Sabr Konid " )
            return
        end
    end

    local xPlayers = ESX.GetPlayers()
    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.DarkPhone.Hostage.CopsRequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Gerogan Giri Bayad Hadaghal "..Config.DarkPhone.Hostage.CopsRequired.." Police Dar Shahr Bashad")
        return
    end
    LastHostageTime = os.time()
    HostageOwner = _source
    xPlayer.removeInventoryItem("darkphone", 1)
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Gerogan Giri] ', 'Alarme Gerogan Giri Braye Tamame ^1Niro Haye Nezami^0 Ersal Shod !' } })
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Gerogan Giri] ', 'Yek ^1Gerogan Giri^0 Start Shod !' } })
            TriggerClientEvent('DarkPhone:setBlipHostage', xPlayers[i], coords)
        end
    end
    TriggerClientEvent('DarkPhone:CheckDistance', _source, coords)
end)

RegisterServerEvent('DarkPhone:CancelHostage')
AddEventHandler('DarkPhone:CancelHostage', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Gerogan Giri] ', '^1Gerogan Giri^0 Be Dalile Door Shodan Az Mahale Start Cancel Shod !' } })
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Gerogan Giri] ', 'Gerogan Gir Az Mahale Start Door Shod Va ^1Gerogan Giri^0 Cancel Shod !' } })
            TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
        end
    end
    HostageOwner = nil
end)

RegisterServerEvent('DarkPhone:SuccessHostage')
AddEventHandler('DarkPhone:SuccessHostage', function()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
        end
    end
    HostageOwner = nil
end)

local LastPursuitTime = nil
local PursuitOwner = nil
local PursuitAccepted = false

RegisterServerEvent('DarkPhone:StartPursuit')
AddEventHandler('DarkPhone:StartPursuit', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Starte Pursuit Ra Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Pursuit Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end

    if LastPursuitTime then
        if (os.time() - LastPursuitTime) < Config.DarkPhone.Pursuit.Cooldown then
            TriggerClientEvent('esx:showNotification', _source, "Pursuit Dar Cooldown Ast Lotfan ~y~"..(Config.DarkPhone.Pursuit.Cooldown - (os.time() - LastPursuitTime)).."~s~ Sanie Sabr Konid " )
            return
        end
    end

    local xPlayers = ESX.GetPlayers()
    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.DarkPhone.Pursuit.CopsRequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte Pursuit Bayad Hadaghal "..Config.DarkPhone.Pursuit.CopsRequired.." Police Dar Shahr Bashad")
        return
    end
    LastPursuitTime = os.time()
    PursuitOwner = _source
    xPlayer.removeInventoryItem("darkphone", 1)
    TriggerClientEvent('chat:addMessage', _source, { args = { '^1[Pursuit] ', 'Alarme Pursuit Braye Tamame ^1Niro Haye Nezami^0 Ersal Shod !' } })
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Yek ^1Pursuit^0 Start Shod !' } })
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Baraye Accept Kardane In Pursuit Az /accp Estefade Konid .' } })
            TriggerClientEvent('DarkPhone:setBlipPursuit', xPlayers[i], coords,_source)
        end
    end
    TriggerClientEvent('DarkPhone:StartProgressBar', _source)
end)

RegisterServerEvent('DarkPhone:SuccessPursuit')
AddEventHandler('DarkPhone:SuccessPursuit', function()
    if source ~= PursuitOwner then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('DarkPhone:killBlipPursuit', xPlayers[i])
            TriggerClientEvent('chat:addMessage', xPlayers[i], { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid !' } })
        end
    end
    PursuitOwner = nil
    if PursuitAccepted then
        xPlayer.addMoney(Config.DarkPhone.Pursuit.Reward)
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid Va Shoma $'..Config.DarkPhone.Pursuit.Reward..' Pool Daryaft Kardid !' } })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1[Pursuit] ', 'Alarme ^1Pursuit^0 Be Payan Resid !' } })
    end
    PursuitAccepted = false
end)

ESX.RegisterServerCallback('DarkPhone:getcoord', function(source, cb, id)
	local coord = GetEntityCoords(GetPlayerPed(id))
	cb(coord)
end)

RegisterCommand('accp', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if IsPoliceJob(xPlayer.job.name) then
        if PursuitOwner then
            if PursuitOwner ~= nil then
                PursuitAccepted = true
                local xPlayers = ESX.GetPlayers()
                for i=1, #xPlayers, 1 do
                    local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    if IsPoliceJob(yPlayer.job.name) then
                        TriggerClientEvent('chatMessage',xPlayers[i] , "", {255, 0, 0}, "^5[ Dispatch ] ^7:" .. 'Pursuit' ..  '^7 tavasot ^2'.. xPlayer.name .. ' ^7(^5' .. string.upper(xPlayer.job.name ) ..   '^7) ^7 accept shod' )
                    end
                end
            else
                TriggerClientEvent('esx:showNotification', _source, "Pursuiti Dar Jarian Nist !")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Pursuiti Dar Jarian Nist !")
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    if HostageOwner then
        if HostageOwner == _source then
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('DarkPhone:killBlipHostage', xPlayers[i])
                end
            end
            HostageOwner = nil
        end
    end

    if PursuitOwner then
        if PursuitOwner == _source then
            local xPlayers = ESX.GetPlayers()
            for i=1, #xPlayers, 1 do
                local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('DarkPhone:killBlipPursuit', xPlayers[i])
                end
            end
            PursuitOwner = nil
        end
    end

end)
end

do
local Teams = {}

local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function IsInTeam(id)
    local InTeam = false
    local PlayerTeam = {}
    local TeamID = nil
    if Teams then
        for TID,Team in pairs(Teams) do
            for playerid,_ in pairs(Team) do
                if tonumber(playerid) == id then
                    InTeam = true
                    PlayerTeam = Team
                    TeamID = TID

                end
            end
        end
    end
    return InTeam,PlayerTeam,TeamID
end

exports('IsInTeam', IsInTeam)

RegisterCommand('party', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam,team,teamid = IsInTeam(_source)
    TriggerClientEvent('TeamSystem:OpenMenu',_source,InTeam,_source,team,teamid)

end)

RegisterServerEvent('TeamSystem:CreateTeam')
AddEventHandler('TeamSystem:CreateTeam', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    table.insert(Teams,{[_source] = {name = xPlayer.name , rank = "Leader"}})

end)

-- SECURITY FIX: JoinToTeam used to let ANY player join ANY Teamid just by
-- guessing/sending the id, with no invite check at all. InvitePlayer never
-- recorded anything server-side to prove an invite actually happened, so
-- we track that here.
local PendingInvites = {} -- invitedPlayerId -> teamId

RegisterServerEvent('TeamSystem:InvitePlayer')
AddEventHandler('TeamSystem:InvitePlayer', function(InvitedId,InvitedTeamID)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local yPlayer = ESX.GetPlayerFromId(InvitedId)
    if yPlayer then
        local InTeam,Team,teamid = IsInTeam(InvitedId)
        if InTeam then
            TriggerClientEvent('esx:showNotification', _source, "Player Is Already In A Team")
        else
            PendingInvites[InvitedId] = InvitedTeamID
            TriggerClientEvent('esx:showNotification', _source, "Invite Sent",'success')
            TriggerClientEvent('TeamSystem:AskForInvite',InvitedId,xPlayer.name,InvitedTeamID)
        end
    else
        TriggerClientEvent('esx:showNotification', _source, "Player Doesnt Exist !")
    end
end)

RegisterServerEvent('TeamSystem:RequestInvite')
AddEventHandler('TeamSystem:RequestInvite', function(InvitedId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam, Team, teamid = IsInTeam(_source)
    if not InTeam then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Ozv Hich Teami Nistid")
        return
    end
    if Team[_source].rank ~= "Leader" then
        TriggerClientEvent('esx:showNotification', _source, "Faghat Leader Mitavanad Da'vat Konad")
        return
    end
    TriggerEvent('TeamSystem:InvitePlayer', InvitedId, teamid)
end)

RegisterServerEvent('TeamSystem:JoinToTeam')
AddEventHandler('TeamSystem:JoinToTeam', function(Teamid)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    -- SECURITY FIX: only allow joining a team the player was actually
    -- invited to, and only once (invite is consumed on use).
    if PendingInvites[_source] ~= Teamid then
        TriggerClientEvent('esx:showNotification', _source, "You Weren't Invited To This Team")
        return
    end
    if not Teams[Teamid] then return end

    local InTeam = IsInTeam(_source)
    if InTeam then
        TriggerClientEvent('esx:showNotification', _source, "Player Is Already In A Team")
        return
    end

    PendingInvites[_source] = nil
    Teams[Teamid][_source] ={name = xPlayer.name , rank = "Member"}

end)

RegisterServerEvent('TeamSystem:LeaveTeam')
AddEventHandler('TeamSystem:LeaveTeam', function(Teamid)
    local _source = source
    if not Teams[Teamid] or not Teams[Teamid][_source] then return end
    Teams[Teamid][_source] = nil
end)

RegisterServerEvent('TeamSystem:Kick')
AddEventHandler('TeamSystem:Kick', function(Teamid,playerid)
    -- SECURITY FIX: this had NO permission check at all -- any player
    -- could kick any member from any team. Only the team's Leader may
    -- kick, and only members of that same team can be kicked.
    local _source = source
    if not Teams[Teamid] then return end
    local caller = Teams[Teamid][_source]
    if not caller or caller.rank ~= "Leader" then
        TriggerClientEvent('esx:showNotification', _source, "Faghat Leader Mitavanad Ekhraj Konad")
        return
    end
    if not Teams[Teamid][playerid] then return end
    Teams[Teamid][playerid] = nil
end)

RegisterServerEvent('TeamSystem:Promote')
AddEventHandler('TeamSystem:Promote', function(Teamid,playerid)
    -- SECURITY FIX: this had NO permission check at all -- any player
    -- could promote anyone (including themselves) to Leader of any team.
    -- Only the current Leader may hand off leadership, and only to an
    -- existing member of that same team.
    local _source = source
    if not Teams[Teamid] then return end
    local caller = Teams[Teamid][_source]
    if not caller or caller.rank ~= "Leader" then
        TriggerClientEvent('esx:showNotification', _source, "Faghat Leader Mitavanad Erteqa Dahad")
        return
    end
    if not Teams[Teamid][playerid] then return end

    Teams[Teamid][_source].rank = "Member"
    Teams[Teamid][playerid].rank = "Leader"
end)

RegisterServerEvent('TeamSystem:DeleteTeam')
AddEventHandler('TeamSystem:DeleteTeam', function(Teamid)
    -- SECURITY FIX: this had NO permission check at all -- any player
    -- could destroy any team by guessing/sending its Teamid. Only that
    -- team's Leader may delete it now.
    local _source = source
    if not Teams[Teamid] then return end
    local caller = Teams[Teamid][_source]
    if not caller or caller.rank ~= "Leader" then
        TriggerClientEvent('esx:showNotification', _source, "Faghat Leader Mitavanad Team Ra Delete Konad")
        return
    end
    Teams[Teamid] = nil
end)

RegisterCommand('tchat', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local InTeam,team,teamid = IsInTeam(_source)
    if InTeam then
        local name = string.gsub(xPlayer.name, "_", " ")
        local message = table.concat(args, " ")

        for id,_ in pairs(team) do
            TriggerClientEvent('chatMessage', id, "", {255, 0, 0},"^4[^1 Team ^4]: ^3" .. name .. " " .. "^0^*" .. message .. "")
        end
    else
        TriggerClientEvent('esx:showNotification', _source, "Shoma Ozv Hich Teami Nistid",'error')
    end

end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    local InTeam, Team, teamid = IsInTeam(_source)
    if InTeam then
        local wasLeader = Team[_source].rank == "Leader"
        Teams[teamid][_source] = nil

        if wasLeader then
            local newLeader = nil
            for playerid,_ in pairs(Teams[teamid]) do
                newLeader = playerid
                break
            end
            if newLeader then
                Teams[teamid][newLeader].rank = "Leader"
            else
                Teams[teamid] = nil
            end
        end
    end
end)
end

do
ESX = nil
local RobberyCode = 0
local Robs ={}
local RobsInProgress = {}
local RobCases = {}      -- [_source] = esx_uniquejobs DOJ case id opened for the current robbery
local DispatchCode = {}  -- [_source] = esx_uniquejobs rob_manager.lua dispatch/accept code
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function IsPoliceJob(jobname)
    for i = 1, #Config.Rob.PoliceJobs do
        if Config.Rob.PoliceJobs[i] == jobname then
            return true
        end
    end
    return false
end

CreateThread(function()
    while true do
        Wait(1000)
        for k,v in pairs(Config.Rob.Robs) do
            if (os.time() - v.lastRobbed) < Config.Rob.RobTypes[v.type].cooldown and v.lastRobbed ~= 0 then
                TriggerClientEvent('Morphy_RobSystem:SetMarker', -1, k, false)
            else
                TriggerClientEvent('Morphy_RobSystem:SetMarker', -1, k, true)
            end
        end

    end
end)

RegisterServerEvent('Morphy_RobSystem:robberyNeeds')
AddEventHandler('Morphy_RobSystem:robberyNeeds', function(robname)
    local _source = source
    -- BUGFIX: robname used to be indexed into Config.Rob.Robs with no
    -- existence check anywhere in this file. A client sending a bogus
    -- name (e.g. via a direct TriggerServerEvent) threw a Lua error
    -- ("attempt to index a nil value") instead of being rejected.
    if not Config.Rob.Robs[robname] then
        return
    end
    if GetPlayerRoutingBucket(_source) ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Dar Worlde Asli Nistid !!",'error')
		return
	end
    local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
    if RobsInProgress[_source] then
        TriggerClientEvent('esx:showNotification', _source, "Shoma Al'an Dar Hale Ejraye Yek Dozdi Hastid !",'error')
        return
    end
    if Config.Rob.Robs[robname].someonerobbing then
        TriggerClientEvent('esx:showNotification', _source, "Fardi Dar Hale Hack Ast .")
        return
    end

    if IsPoliceJob(xPlayer.job.name) then
        TriggerClientEvent('esx:showNotification', _source, "Azaye Organ Haye Nezami Tavanayi Dozdi Nadarand .",'error')
        return
    end

    if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'taxi' or xPlayer.job.name == 'mechanic' then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Dozdi Shoma Bayad OFF DUTY Bashid .",'error')
        return
    end

    if (os.time() - Config.Rob.Robs[robname].lastRobbed) < Config.Rob.RobTypes[Config.Rob.Robs[robname].type].cooldown and Config.Rob.Robs[robname].lastRobbed ~= 0 then
        TriggerClientEvent('esx:showNotification', _source, "In Makan Qablan Azash Dozdi Shode Lotfan "..(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].cooldown - (os.time() - Config.Rob.Robs[robname].lastRobbed)).." Sanie Sabr Konid Barai Dozdi Dobare" )
        return
    end
    if (os.time() - Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed) < Config.Rob.RobTypes[Config.Rob.Robs[robname].type].successtime then
        TriggerClientEvent('esx:showNotification', _source, "Robbery Digari Dar Jarian Ast Lotfan "..(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].successtime - (os.time() - Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed)).." Sanie Sabr Konid " )
        return
    end

    if Config.Rob.RobTypes[Config.Rob.Robs[robname].type].teammatesrequired ~= 0 then
        local InTeam,PlayerTeam,TeamID = exports[GetCurrentResourceName()]:IsInTeam(_source)
        if not InTeam then
            TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Shoma Bayad Dar Team Bashid! /party" )
            return
        end
        if PlayerTeam[_source].rank ~= "Leader" then
            TriggerClientEvent('esx:showNotification', _source, "Shoma Bayad Leader Team Bashid !" )
            return
        end

        local TeamMemberCount = 0
        local CloseMemberCount = 0
        local ped = GetPlayerPed(_source)
        local playerCoords = GetEntityCoords(ped)
        for mateid,_ in pairs(PlayerTeam) do
            TeamMemberCount = TeamMemberCount + 1
            local ped2 = GetPlayerPed(mateid)
            local playerCoords2 = GetEntityCoords(ped2)
            if #(playerCoords - playerCoords2) <= 10 then
                CloseMemberCount = CloseMemberCount + 1
            end
        end

        if TeamMemberCount < Config.Rob.RobTypes[Config.Rob.Robs[robname].type].teammatesrequired then
            TriggerClientEvent('esx:showNotification', _source, "Shoma Bayad Hadaghal "..Config.Rob.RobTypes[Config.Rob.Robs[robname].type].teammatesrequired.." Nafar Dar Team bashid !" )
            return
        end

        if CloseMemberCount < Config.Rob.RobTypes[Config.Rob.Robs[robname].type].teammatesrequired then
            TriggerClientEvent('esx:showNotification', _source, "Afrade Dakhele Team Az Shoma Door Hastand!",'error')
            return
        end
    end

    local cops = 0
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            cops = cops + 1
        end
    end

    if cops < Config.Rob.RobTypes[Config.Rob.Robs[robname].type].copsrequired then
        TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Hadaghal "..Config.Rob.RobTypes[Config.Rob.Robs[robname].type].copsrequired.." Police Dar Shahr Bashad")
        return
    end

    for itemname,amount in pairs(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].itemneed) do
        if xPlayer.getInventoryItem(itemname) then
            if amount > xPlayer.getInventoryItem(itemname).count then
                TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Be tedade "..amount.." az "..itemname.." Dashte Bashid .")
                return
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Baraye Starte In Robbery Bayad Be tedade "..amount.." az "..itemname.." Dashte Bashid .")
            return
        end

    end
    for itemname,amount in pairs(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].itemneed) do
        xPlayer.removeInventoryItem(itemname, amount)
    end
    Config.Rob.Robs[robname].someonerobbing = true
    RobsInProgress[_source] = robname
    TriggerClientEvent('Morphy_RobSystem:StartHack', _source,robname,Config.Rob.RobTypes[Config.Rob.Robs[robname].type].hacktype)
end)

RegisterServerEvent('Morphy_RobSystem:robberyStarted')
AddEventHandler('Morphy_RobSystem:robberyStarted', function(robname)
    local _source = source

    -- CRITICAL BUGFIX (money exploit): this handler used to trust
    -- `robname` unconditionally. Because it's a RegisterServerEvent, any
    -- client could call it directly -- skipping every check in
    -- robberyNeeds (police-job check, off-duty check, cops-required,
    -- team-required, item-required, cooldown, location) -- and then
    -- immediately fire robberySuccess to collect the reward for free.
    -- robberyNeeds is the ONLY place that sets RobsInProgress[_source]
    -- BEFORE the hack starts, so requiring it to already equal `robname`
    -- here proves the player actually passed those checks.
    if not Config.Rob.Robs[robname] or RobsInProgress[_source] ~= robname then
        return
    end

    local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
    SetAlarmPolice(robname , "start",_source)
    RobberyCode = RobberyCode + 1
    for i=1, #xPlayers, 1 do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Yek Robbery Dar "..Config.Rob.Robs[robname].nameofrob.." Start Shod")
            TriggerClientEvent('Morphy_RobSystem:setBlip', xPlayers[i], robname, Config.Rob.Robs[robname].position)
        end
    end
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Rob Code] : "..RobberyCode.."\n[Status] : Started\n```",'user', _source, true, false)
    TriggerClientEvent('esx:showNotification', _source, "Robbery Start Shod !",'success')
    TriggerClientEvent('Morphy_RobSystem:StartProgressBar', _source, robname, RobberyCode)

    -- Open a real, persistent case on esx_uniquejobs' /doj board for this
    -- attempt, with the robber pre-filled as a suspect. robberySuccess
    -- files the charge on it later; robberyCancel/playerDropped dismiss
    -- it if the attempt never resolves.
    pcall(function()
        exports['esx_uniquejobs']:CreateExternalCase({
            title = Config.Rob.Robs[robname].nameofrob .. " (Rob Code #" .. RobberyCode .. ")",
            priority = 'medium',
            openedByName = 'Sisteme Dispatch',
            openedByJob = 'police',
            evidenceText = 'Alarm-e Dozdi Be Sorate Automatic Az Tarighe Unique_AllRobs Sabt Shod. Rob Code: ' .. RobberyCode,
            suspects = { { identifier = xPlayer.identifier, name = xPlayer.name } },
        }, function(caseId)
            if caseId then
                RobCases[_source] = caseId
            end
        end)
    end)

    Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed = os.time()
    Config.Rob.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberyHackFail')
AddEventHandler('Morphy_RobSystem:robberyHackFail', function(robname)
    local _source = source
    if not Config.Rob.Robs[robname] or RobsInProgress[_source] ~= robname then return end
    Config.Rob.Robs[robname].someonerobbing = false
    RobsInProgress[_source] = nil

    Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed = os.time()
    Config.Rob.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberySuccess')
AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname,RobberyCode)
    local _source = source
    if not Config.Rob.Robs[robname] or RobsInProgress[_source] ~= robname then return end
    RobsInProgress[_source] = nil
    local xPlayer  = ESX.GetPlayerFromId(_source)

    Config.Rob.Robs[robname].someonerobbing = false
    Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed = os.time()
    Config.Rob.Robs[robname].lastRobbed = os.time()

    -- Real DOJ/dispatch check: exports["esx_policejob"]:CheckRob(...) never
    -- existed under that name -- the actual resource is esx_uniquejobs,
    -- exporting CheckRob_police / CheckRob_marshal (both the same underlying
    -- check, kept as two names for back-compat callers). dispatchCode is the
    -- code esx_uniquejobs handed back when this robbery's alert was raised
    -- in SetAlarmPolice('start'); if a unit ran /acceptrob on it, full
    -- reward is paid, otherwise the pre-existing (previously dead) lessreward
    -- table is used instead. If esx_uniquejobs is unreachable for any reason
    -- this fails safe to the old always-full-reward behavior.
    local accepted = true
    local dispatchCode = DispatchCode[_source]
    local acceptInfo = nil
    if dispatchCode then
        local ok, isAccepted = pcall(function()
            return exports['esx_uniquejobs']:CheckRob_police(dispatchCode)
        end)
        if ok then
            accepted = isAccepted and true or false
        end
        if accepted then
            local infoOk, info = pcall(function()
                return exports['esx_uniquejobs']:GetRobAcceptInfo(dispatchCode)
            end)
            if infoOk then acceptInfo = info end
        end
    end
    if accepted then
        for itemname,amount in pairs(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].reward) do
            if type(amount) == "table" then
                amount = math.random(amount.min, amount.max)
            end
            if itemname == "cash" then
                xPlayer.addMoney(amount)
            elseif string.sub(itemname, 1, 2) == "xp" then
                if xPlayer.gang.name ~= "nogang" then
                    xPlayer.addInventoryItem(itemname, amount)
                end
            else
                xPlayer.addInventoryItem(itemname, amount)
            end
        end
    else
        for itemname,amount in pairs(Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lessreward) do
            if type(amount) == "table" then
                amount = math.random(amount.min, amount.max)
            end
            if itemname == "cash" then
                xPlayer.addMoney(amount)
            elseif string.sub(itemname, 1, 2) == "xp" then
                if xPlayer.gang.name ~= "nogang" then
                    xPlayer.addInventoryItem(itemname, amount)
                end
            else
                xPlayer.addInventoryItem(itemname, amount)
            end
        end
    end

    -- File the matching charge on the case opened at robberyStarted, and
    -- move it to "investigating" if a unit engaged, or leave it "open" for
    -- someone to pick up later.
    local caseId = RobCases[_source]
    local lawCode = Config.Rob.LawCode[Config.Rob.Robs[robname].type]
    local officerName = acceptInfo and acceptInfo.acceptedByName or 'Sisteme Dispatch (Automatic)'
    if caseId then
        if lawCode then
            pcall(function()
                exports['esx_uniquejobs']:AddExternalCharge(caseId, lawCode, officerName)
            end)
        end
        pcall(function()
            exports['esx_uniquejobs']:SetExternalCaseStatus(caseId, accepted and 'investigating' or 'open')
        end)

        -- Heavy robberies (bank / Life Invader): if a unit actually engaged,
        -- put it on the /doj court docket automatically instead of relying
        -- on someone remembering to schedule it by hand.
        if accepted and Config.Rob.CourtHearingTypes[Config.Rob.Robs[robname].type] then
            pcall(function()
                exports['esx_uniquejobs']:ScheduleExternalHearing(caseId, Config.Rob.CourtHearingMinutes, officerName)
            end)
        end
    end

    -- Real criminal-record entry (separate from the case charge above) --
    -- this is what powers /agent Background Check and, when an officer
    -- identifier is attached, officer_performance.lua's arrest/charge
    -- counts. No unit ever engaging still logs it under the dispatch
    -- system itself so the suspect's rap sheet isn't empty.
    if lawCode then
        pcall(function()
            exports['esx_uniquejobs']:LogCriminalRecord(
                xPlayer.identifier, 'charge',
                Config.Rob.Robs[robname].nameofrob .. ' (' .. lawCode .. ')',
                officerName,
                acceptInfo and acceptInfo.acceptedBy or nil,
                nil
            )
        end)
    end

    -- Nobody ever engaged: the suspect walked away clean with the case
    -- still open. Ping online CID/Marshal directly (their job, per DOJ_JOBS
    -- in doj_manager.lua) so they can pull the case from /doj and put in a
    -- warrant request (esx_uniquejobs:dojRequestWarrant) against the named
    -- suspect -- the same flow used for any other manual warrant, just
    -- with the legwork of opening the case and naming the suspect already
    -- done for them.
    if not accepted and caseId then
        local investigators = ESX.GetPlayers()
        for i = 1, #investigators, 1 do
            local yPlayer = ESX.GetPlayerFromId(investigators[i])
            if yPlayer and (yPlayer.job.name == 'cid' or yPlayer.job.name == 'marshal') then
                TriggerClientEvent('chatMessage', yPlayer.source, "[ TAHGHIGHAT ]", {200, 30, 30},
                    "^7Mozanne-e Parvande #" .. caseId .. " (" .. Config.Rob.Robs[robname].nameofrob .. ") Farar Kard -- Mozanne: ^3" .. xPlayer.name .. "^7 -- Az /doj Barresi Konid Va Hokm Bekhahid")
            end
        end
    end

    RobCases[_source] = nil
    DispatchCode[_source] = nil

    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Rob Code] : "..RobberyCode.."\n[Status] : Success".."\n[Is Accepted] : "..tostring(accepted).."\n```",'user', _source, true, false)
    local xPlayers, yPlayer = ESX.GetPlayers(), nil
    SetAlarmPolice(robname , "end",_source)
    for i=1, #xPlayers, 1 do
        yPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Rob.Robs[robname].nameofrob.." Success Shod",'success')
            TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],robname)
        end
    end

end)

RegisterServerEvent('Morphy_RobSystem:robberyCancel')
AddEventHandler('Morphy_RobSystem:robberyCancel', function(robname)
    local _source = source

    -- BUGFIX: this handler used to have no ownership/validity check at
    -- all -- any client could send an arbitrary/unowned robname and
    -- generate a fake "Canceled" Discord log + fake police notification
    -- for a robbery that never happened.
    if not Config.Rob.Robs[robname] or RobsInProgress[_source] ~= robname then
        return
    end
    RobsInProgress[_source] = nil

    -- BUGFIX: someonerobbing was never reset back to false here, so any
    -- cancelled robbery (player walks too far away) permanently soft-locked
    -- that location -- robberyNeeds would refuse everyone forever with
    -- "Fardi Dar Hale Hack Ast" until the resource restarted.
    Config.Rob.Robs[robname].someonerobbing = false

    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx:showNotification', _source, "Be Dalile Door Shodan Az Robbery , Robery Shoma Cancel Shod !")
    local xPlayers, yPlayer = ESX.GetPlayers(), nil
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Status] : Canceled\n```",'user', _source, true, false)
    SetAlarmPolice(robname , "cancel",_source)

    -- The case opened at robberyStarted never reached a success/hackfail
    -- resolution -- dismiss it instead of leaving a dangling open case.
    if RobCases[_source] then
        pcall(function()
            exports['esx_uniquejobs']:SetExternalCaseStatus(RobCases[_source], 'dismissed')
        end)
        RobCases[_source] = nil
    end
    DispatchCode[_source] = nil

    for i=1, #xPlayers, 1 do
        yPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Rob.Robs[robname].nameofrob.." Cnacel Shod")
            TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],robname)
        end
    end

end)

function SetAlarmPolice(Name ,  typ , source )
    if not Config.Rob.Robs[Name] then return end
    local xPlayers = ESX.GetPlayers()
    if typ == 'start' then

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name)  then
                -- Unit-aware dispatch: esx_uniquejobs' unit_manager only
                -- gives a player a callsign while they're in an active
                -- unit, so this is exactly "on an active unit right now"
                -- without needing a separate duty-status system. Officers
                -- with no unit are skipped instead of getting pinged for
                -- every single robbery in the city.
                local ok, callsign = pcall(function()
                    return exports['esx_uniquejobs']:GetPlayerUnitCallsign(xPlayer.identifier)
                end)
                if not ok or callsign then
                    local unitTag = (ok and callsign) and ('Vahed ^3' .. callsign .. '^0 : ') or ''
                    SendMessage( xPlayer.source , unitTag .. 'Az Dispatch be Tamai Vahed Ha Az ^1' ..Config.Rob.Robs[Name].nameofrob .. '^0 Gozarsh Dozdi Reside')
                end
            end
        end

        -- Route through esx_uniquejobs' real /acceptrob dispatch queue and
        -- keep the code it hands back, so robberySuccess can later check
        -- whether a unit actually accepted before paying full reward.
        -- CreateRob already broadcasts the dispatch chat alert itself, so
        -- we only fall back to the old bare event if the export call fails
        -- (e.g. esx_uniquejobs isn't running for some reason).
        local ok, dispatchCode = pcall(function()
            return exports['esx_uniquejobs']:CreateRob(Name)
        end)
        if ok and dispatchCode and source then
            DispatchCode[source] = dispatchCode
        elseif not ok then
            TriggerEvent('Unit:RobAlarm' , Name )
        end
    elseif typ  == 'end' then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name)  then
              SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Dar ^1' ..Config.Rob.Robs[Name].nameofrob .. '^0 Sareghan ^1Movafagh^0 Be Dozdi Shodand')
            end
        end
    elseif typ  == 'cancel' then
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name) then
                SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Dar ^1' ..Config.Rob.Robs[Name].nameofrob .. '^0 Sareghan Dar Dozdi ^1Na Movafagh^0 Bodand')
            end
        end
    end
end

function SendMessage( src , msg )
    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color:rgba(13, 196, 196, 0.4);  border-radius: 3px;">Dispatch   <br> '..msg..' <br> </div>'
    TriggerClientEvent('chat:addMessage', src , {template = template ,args = "."})
end

----------------------------------------
------------ SHARED EXPORT --------------
----------------------------------------
-- Generic police alert, usable by ANY other resource (esx_drugs, esx_addons, etc.):
--   exports['Unique_AllRobs']:AlertPolice(coords, label, duration, radius, jobFilter)
-- coords    : vector3 / {x=,y=,z=} of the alert location
-- label     : text shown on the blip name + dispatch chat message + HUD timer (optional)
-- duration  : how long the blip + on-screen countdown lasts in ms (optional, defaults to Config.Rob.PoliceAlertDuration)
-- radius    : radius (in game units) of the translucent alert circle on the map (optional, defaults to 60.0)
-- jobFilter : optional array of job names (e.g. {'doa'}) to further restrict who gets it,
--             on top of the usual Config.Rob.PoliceJobs check -- lets callers target just one
--             department (DOA-only evidence alerts) instead of every cop-like job at once.
function AlertPolice(coords, label, duration, radius, jobFilter)
    local xPlayers = ESX.GetPlayers()
    duration = duration or Config.Rob.PoliceAlertDuration or (4 * 60 * 1000)
    label = label or 'Yek Faaliate Mashkook'
    radius = radius or 60.0

    local allowedJobs = nil
    if jobFilter then
        allowedJobs = {}
        for _, j in ipairs(jobFilter) do allowedJobs[j] = true end
    end

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if IsPoliceJob(xPlayer.job.name) and (not allowedJobs or allowedJobs[xPlayer.job.name]) then
            SendMessage(xPlayer.source, 'Az Dispatch be Tamai Vahed Ha ^1' .. label .. '^0 Gozarsh Shod')
            TriggerClientEvent('Unique_AllRobs:policeAlert', xPlayers[i], coords, label, duration, radius)
        end
    end
end

exports('AlertPolice', AlertPolice)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    if RobsInProgress[_source] then
        if RobsInProgress[_source] ~= nil then
            local xPlayer  = ESX.GetPlayerFromId(_source)
            local xPlayers, yPlayer = ESX.GetPlayers(), nil
            TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..RobsInProgress[_source].."\n[Status] : Canceled\n```",'user', _source, true, false)
            SetAlarmPolice(RobsInProgress[_source] , "cancel",_source)
            -- BUGFIX: same as robberyCancel -- free the location instead of
            -- leaving it permanently marked as "someone is robbing it".
            if Config.Rob.Robs[RobsInProgress[_source]] then
                Config.Rob.Robs[RobsInProgress[_source]].someonerobbing = false
            end
            for i=1, #xPlayers, 1 do
                yPlayer = ESX.GetPlayerFromId(xPlayers[i])

                if IsPoliceJob(yPlayer.job.name) then
                    TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Rob.Robs[RobsInProgress[_source]].nameofrob.." Cnacel Shod")
                    TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],RobsInProgress[_source])
                end
            end
        end
    end
    RobsInProgress[_source] = nil

    if RobCases[_source] then
        pcall(function()
            exports['esx_uniquejobs']:SetExternalCaseStatus(RobCases[_source], 'dismissed')
        end)
        RobCases[_source] = nil
    end
    DispatchCode[_source] = nil

end)

-- ✅ اضافه شد: export فقط-خواندنی برای اسکوربورد جدید (Unique_Hud). هیچ رفتار
-- موجودی رو عوض نمی‌کنه، فقط وضعیت زنده‌ی دزدی‌ها رو (available/someonerobbing)
-- به‌صورت خلاصه‌شده بر اساس نوع (Shop/Jewerlly/Minibank/Palateo_Bank/Life_Invader)
-- برمی‌گردونه.
function GetRobStatusSummary()
    local summary = {}
    for key, rob in pairs(Config.Rob.Robs) do
        local t = rob.type
        if not summary[t] then
            summary[t] = { total = 0, active = 0, beingRobbed = 0 }
        end
        summary[t].total = summary[t].total + 1
        if rob.available then
            summary[t].active = summary[t].active + 1
        end
        if rob.someonerobbing then
            summary[t].beingRobbed = summary[t].beingRobbed + 1
        end
    end
    return summary
end
exports('GetRobStatusSummary', GetRobStatusSummary)
end