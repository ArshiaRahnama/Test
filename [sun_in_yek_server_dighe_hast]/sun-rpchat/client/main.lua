-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
Citizen.CreateThread(function ()
    while not ESX do
        Wait(5000)
    end
    PlayerData = ESX.GetPlayerData()
end)
local mainCD = false

function cdStuff()
    mainCD = true
    Citizen.SetTimeout(5000,function()
        mainCD = false
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterCommand('mp', function(source, args)
    local player = GetPlayerPed(-1)
    local players = ESX.Game.GetPlayersToSend(100)
    if ESX.GetPlayerData().World ~= 0 and ESX.GetPlayerData().admin ~= 1 and not exports['sun-robbery']:doesInRob() then return end
    if ESX.GetPlayerData().IsDead then
        return ESX.chatMessage('Dar halate dead nemitavanid az in command estefade konid', 'plarms')
    end
    if ESX.GetPlayerData().admin == 1 then
        if args[1] then
            ESX.TriggerServerEvent('mpCommandAdmin', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif PlayerData.job.name == "police" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "sheriff" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand2', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "ambulance" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand3', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "fbi" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand4', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
        -- mechanic
    elseif  PlayerData.job.name == "mechanic" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand5', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "mt" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand6', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "justice" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand7', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    elseif  PlayerData.job.name == "detective" then
        if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
        cdStuff()
        if args[1] then
            ESX.TriggerServerEvent('mpCommand8', table.concat(args," "),players)
        else
            ESX.ShowNotification('~r~~h~Shoma Hadeaghal bayad yek kalame type konid.')
        end
    else
        ESX.ShowNotification('~r~~h~Shoma dastresi nadarid nistid!')
    end
end, false)



RegisterNetEvent('sendProximityMessageShout')
AddEventHandler('sendProximityMessageShout', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 25, 0, 0.4); border-radius: 3px;"><i class="fas fa-globe"></i> <b>{0} Faryad Mizane:</b>  {1}</div>',
            args = { name, message}
        }, 's')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 25, 0, 0.4); border-radius: 3px;"><i class="fas fa-globe"></i> <b>{0} Faryad Mizane:</b>  {1}</div>',
            args = { name, message}
        }, 's')
    end
end)


RegisterNetEvent('sendProximityMessageOOC')
AddEventHandler('sendProximityMessageOOC', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            color = {205, 205, 205},
            multiline = true,
            args = {name, message}
        }, 'ooc')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 30.0 then
        TriggerEvent('chat:addMessage', {
            color = {205, 205, 205},
            multiline = true,
            args = {name, message}
        }, 'ooc')
    end
end)

RegisterNetEvent('sendProximityMessageOOC2')
AddEventHandler('sendProximityMessageOOC2', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            color = {205, 205, 205},
            multiline = true,
            args = {name, message}
        }, 'ooc')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 60.0 then
        TriggerEvent('chat:addMessage', {
            color = {205, 205, 205},
            multiline = true,
            args = {name, message}
        }, 'ooc')
    end
end)

RegisterNetEvent('sendProximityMessageMPAdmin')
AddEventHandler('sendProximityMessageMPAdmin', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local name = GetPlayerName(GetPlayerFromServerId(id), true)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(149, 63, 183, 0.8); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Admin  ({0}):</b> {1}</div>',
            args = { name, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(149, 63, 183, 0.8); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Admin ({0}):</b> {1}</div>',
            args = { name, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP')
AddEventHandler('sendProximityMessageMP', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Police({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Police({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP2')
AddEventHandler('sendProximityMessageMP2', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Sheriff({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Sheriff({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP3')
AddEventHandler('sendProximityMessageMP3', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 150, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Ambulance({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 153, 150, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Ambulance({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP4')
AddEventHandler('sendProximityMessageMP4', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu FBI({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu FBI({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP5')
AddEventHandler('sendProximityMessageMP5', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(220, 120, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Mechanic({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(220, 120, 0, 0.7);color:white; border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Mechanic({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP6')
AddEventHandler('sendProximityMessageMP6', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Metropolitan({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 25, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Metropolitan({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP7')
AddEventHandler('sendProximityMessageMP7', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 255, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Justice({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 255, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu Justice({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageMP8')
AddEventHandler('sendProximityMessageMP8', function(id, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 255, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu CID({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 100.0 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 255, 255, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b>Bolandgu CID({0}):</b> {1}</div>',
            args = { id, message }
        }, 'mp')
    end
end)

RegisterNetEvent('sendProximityMessageProxevent')
AddEventHandler('sendProximityMessageProxevent', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chatMessage',  name, {0, 25, 255}, message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 40.0 then
        TriggerEvent('chatMessage', name, {0, 25, 255},  message)
    end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chatMessage', "", {250, 175, 214}, "( "..name .. " ) ".. message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
        TriggerEvent('chatMessage', "", {250, 175, 214}, "( "..name .. " ) ".. message)
    end
end)

RegisterNetEvent('sendTasMessage')
AddEventHandler('sendTasMessage', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    Citizen.Wait(1000)
    if pid == myId then
        TriggerEvent('chatMessage', name, {255, 0, 0}, message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
        TriggerEvent('chatMessage', name, {255, 0, 0},  message)
    end
end)

RegisterNetEvent('sendAdminmsg')
AddEventHandler('sendAdminmsg', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    Citizen.Wait(1000)
    if pid == myId then
        TriggerEvent('chatMessage', name, {255, 0, 0}, message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 30.0 then
        TriggerEvent('chatMessage', name, {255, 0, 0},  message)
    end
end)


RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
    if ESX == nil then return end
    if not ESX.Game.PlayerExist(id) then return end
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if pid == myId then
        TriggerEvent('chatMessage', "", {255, 0, 0}, message  .."  ( " .. name .. " ) ")
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
        TriggerEvent('chatMessage', "", {255, 0, 0}, message  .."  ( " .. name .. " ) ")
    end
end)
shab = false

RegisterCommand('shab',function()
    if ESX.GetPlayerData().jailed or ESX.isDead() then return end
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    shab = true
    shabtr()
end, false)

RegisterCommand('rooz',function()
    if ESX.GetPlayerData().jailed or ESX.isDead() then return end
    SendNUIMessage({type = 'closeAll'})
    shab = false
    Wait(1000)
    ClearPedTasks(PlayerPedId())
end, false)

RegisterCommand('like',function()
    if ESX.GetPlayerData().jailed then return end
    ExecuteCommand('e thumbsup')
end, false)


RegisterCommand('dlike',function()
    if ESX.GetPlayerData().jailed then return end
    loadanimdict('anim@arena@celeb@flat@solo@no_props@')
    TaskPlayAnim(PlayerPedId(), 'anim@arena@celeb@flat@solo@no_props@', 'thumbs_down_a_player_a', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
end, false)

function shabtr()
    Citizen.CreateThread(function()
        while shab do
            Wait(10)
            if not IsEntityPlayingAnim(PlayerPedId(), "mp_sleep", "sleep_loop", 1) then
                ExecuteCommand('e fallasleep')
            end
            --ESX.ShowMissionText('/rooz baraye bidar shodan')
        end
    end)
end


function loadanimdict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname)
        while not HasAnimDictLoaded(dictname) do
            Citizen.Wait(1)
        end
    end
end

RegisterCommand('ooc', function(source, args, user)
    if ESX.GetPlayerData().World ~= 0 and not exports['sun-robbery']:doesInRob() then return end
    if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
    cdStuff()
    if args[1] == nil then return end
    local text = table.concat(args, " ")
    ESX.TriggerServerEvent('rpchat:ooc',text,ESX.Game.GetPlayersToSend(30))
end, false)

RegisterCommand('b', function(source, args, user)
    if ESX.GetPlayerData().World ~= 0 and not exports['sun-robbery']:doesInRob() then return end
    if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
    cdStuff()
    if args[1] == nil then return end
    local text = table.concat(args, " ")
    ESX.TriggerServerEvent('rpchat:ooc',text,ESX.Game.GetPlayersToSend(30))
end, false)

RegisterCommand('s', function(source, args, user)
    if ESX.GetPlayerData().World ~= 0 then return end
    if ESX.GetPlayerData().IsDead then
        return ESX.chatMessage('Dar halate dead nemitavanid az in command estefade konid', 'plarms')
    end
    if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
    cdStuff()
    if args[1] == nil then return end
    local text = table.concat(args, " ")
    ESX.TriggerServerEvent('rpchat:s',text,ESX.Game.GetPlayersToSend(100))
end, false)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/ooc', 'OOC', {
        { name="Text", help="Text" }
    })
    TriggerEvent('chat:addSuggestion', '/b', 'OOC', {
        { name="Text", help="Text" }
    })
    TriggerEvent('chat:addSuggestion', '/s', 'Faryad zadan', {
        { name="Text", help="Text" }
    })
end)