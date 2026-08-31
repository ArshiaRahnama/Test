

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
        local InTeam,PlayerTeam,TeamID = exports["PartySystem"]:IsInTeam(_source)
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
    Config.Rob.Robs[robname].someonerobbing = false
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    RobsInProgress[_source] = robname
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

    Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed = os.time()
    Config.Rob.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberyHackFail')
AddEventHandler('Morphy_RobSystem:robberyHackFail', function(robname)
    local _source = source
    Config.Rob.Robs[robname].someonerobbing = false
    RobsInProgress[_source] = nil

    Config.Rob.RobTypes[Config.Rob.Robs[robname].type].lastRobbed = os.time()
    Config.Rob.Robs[robname].lastRobbed = os.time()

end)

RegisterServerEvent('Morphy_RobSystem:robberySuccess')
AddEventHandler('Morphy_RobSystem:robberySuccess', function(robname,RobberyCode)
    local _source = source
    RobsInProgress[_source] = nil
    local xPlayer  = ESX.GetPlayerFromId(_source)
    -- TEMP FIX (was crashing: exports["esx_policejob"] doesn't exist, that
    -- resource is esx_uniquejobs now, and its real export is
    -- CheckRob_police/CheckRob_marshal not CheckRob). Always giving full
    -- reward for now until the final "who approves a rob" design is
    -- decided (police-tier escalation vs PartySystem/TeamSystem -- this
    -- file already uses exports["PartySystem"]:IsInTeam(...) elsewhere,
    -- around line 461, for the teammatesrequired check at robbery start,
    -- so a team-based accept flow here would follow the same pattern).
    local accepted = true
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
    RobsInProgress[_source] = nil
    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx:showNotification', _source, "Be Dalile Door Shodan Az Robbery , Robery Shoma Cancel Shod !")
    local xPlayers, yPlayer = ESX.GetPlayers(), nil
    TriggerEvent('DiscordBot:ToDiscord', 'rob', "Robbery System", "```css\n[ID] : ".._source.."\n[IC Name] : "..xPlayer.name.."\n[Steam Name] : "..GetPlayerName(source).."\n[Gang Name] : "..xPlayer.gang.name.."\n[Gang Grade] : "..xPlayer.gang.grade.."\n[Steam Hex] : "..xPlayer.identifier.."\n[Rob Name] : "..robname.."\n[Status] : Canceled\n```",'user', _source, true, false)
    SetAlarmPolice(robname , "cancel",_source)
    for i=1, #xPlayers, 1 do
        yPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if IsPoliceJob(yPlayer.job.name) then
            TriggerClientEvent('esx:showNotification', xPlayers[i],"Robbery "..Config.Rob.Robs[robname].nameofrob.." Cnacel Shod")
            TriggerClientEvent('Morphy_RobSystem:killBlip', xPlayers[i],robname)
        end
    end

end)

function SetAlarmPolice(Name ,  typ , source )
    local xPlayers = ESX.GetPlayers()
    if typ == 'start' then

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if IsPoliceJob(xPlayer.job.name)  then
             SendMessage( xPlayer.source , 'Az Dispatch be Tamai Vahed Ha Az ^1' ..Config.Rob.Robs[Name].nameofrob .. '^0 Gozarsh Dozdi Reside')
            end
        end
        TriggerEvent('Unit:RobAlarm' , Name )
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

