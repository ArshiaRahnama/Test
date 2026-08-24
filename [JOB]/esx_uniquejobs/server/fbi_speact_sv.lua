ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('checkPlayerJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and xPlayer.job.name == "fbi")
end)

ESX.RegisterServerCallback('getFbiRank', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and xPlayer.job.grade or 0)
end)

ESX.RegisterServerCallback('getOnlinePlayersByJob', function(source, cb, job)
    local players = {}
    for _, playerId in pairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job.name == job then
            table.insert(players, { id = playerId, name = xPlayer.name })
        end
    end
    cb(players)
end)

local spectatingFBI = {}

RegisterServerEvent('fbi_spectate:startSpectate')
AddEventHandler('fbi_spectate:startSpectate', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "fbi" then
        spectatingFBI[source] = targetId

        local target = ESX.GetPlayerFromId(targetId)
        TriggerClientEvent('fbi_spectate:spectate', source, targetId, target.inventory, target.loadout, target.money, target.bank, target.name, target.job.name, target.job.grade_label, target.job.grade, target.gang.name, target.gang.grade_label, target.gang.grade)
    end
end)

local spectatingFBI = {}

RegisterServerEvent('fbi_spectate:startSpectate')
AddEventHandler('fbi_spectate:startSpectate', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "fbi" then
        spectatingFBI[source] = targetId

        local target = ESX.GetPlayerFromId(targetId)
        TriggerClientEvent('fbi_spectate:spectate', source, targetId, target.inventory, target.loadout, target.money, target.bank, target.name, target.job.name, target.job.grade_label, target.job.grade, target.gang.name, target.gang.grade_label, target.gang.grade)
    end
end)

RegisterCommand("fbimsg", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "fbi" then
        local spectateTarget = spectatingFBI[source]
        if spectateTarget then
            local message = table.concat(args, " ")
            if message and message ~= "" then
                local targetPlayer = ESX.GetPlayerFromId(spectateTarget)
                if targetPlayer then
                    TriggerClientEvent('fbi_chat:receiveMessage', spectateTarget, xPlayer.name, message)
                    TriggerClientEvent('esx:showNotification', source, "✅ Message sent to " .. spectateTarget)
                else
                    TriggerClientEvent('esx:showNotification', source, "❌ Target not found!")
                end
            else
                TriggerClientEvent('esx:showNotification', source, "❌ Usage: /fbimsg [Message]")
            end
        else
            TriggerClientEvent('esx:showNotification', source, "❌ You are not spectating anyone!")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "❌ You are not an FBI agent!")
    end
end, false)

RegisterServerEvent('fbi_spectate:stopSpectate')
AddEventHandler('fbi_spectate:stopSpectate', function()
    spectatingFBI[source] = nil
end)

RegisterServerEvent('fbi_spectate:startSpectate')
AddEventHandler('fbi_spectate:startSpectate', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.job.name == "fbi" then

        local target = ESX.GetPlayerFromId(targetId)

        TriggerClientEvent('fbi_spectate:spectate',

        source,
        targetId,
        target.getInventoryItem(),
        target.loadout,
        target.money,
        target.bank,
        target.name,
        target.job.name,
        target.job.grade_label,
        target.job.grade,
        target.gang.name,
        target.gang.grade_label,
        target.gang.grade
        )
    end
end)

local idchatrom = 0
local fbisource = 0

RegisterCommand('fow_fbi', function(source, args)
    if ESX.GetPlayerFromId(source).job.name == 'fbi' then

        if args[1] then
            local xPlayer = ESX.GetPlayerFromId(args[1])
            if xPlayer then
                if idchatrom ~= tonumber(args[1]) then
                    if idchatrom == 0 then
                        idchatrom = tonumber(args[1])
                        fbisource = source
                        TriggerClientEvent('esx:showNotification', xPlayer.source, "Yek Chat Room Baraye Shoma Az Taraf ~r~F.B.I~w~ Baz Shod ")
                        TriggerClientEvent('esx:showNotification', source, "Shoma Yek Chat Room Ba ~g~"..xPlayer.name.."~w~ Baz Kardid")

                        TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^5Chat Room: ', 'Baraye Chat Ba F.B.I Az Command ^2/fw ^0 Estefade Konid' } })
                    else
                        TriggerClientEvent('esx:showNotification', source, "~r~Shoma Yek Chat Rom Baz Darid!")
                    end
                else
                    TriggerClientEvent('esx:showNotification', source, "~r~Shoma Yek Chat Rom Baz Darid!")
                end
            else
                TriggerClientEvent('esx:showNotification', source, "~r~Player Online Nist")
            end
        else
            TriggerClientEvent('esx:showNotification', source, "~r~lotfan id vared konid")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Shoma Dast Resi Nadarid!")
    end
end)

RegisterCommand('fcw_fbi', function(source, args)
    if ESX.GetPlayerFromId(source).job.name == 'fbi' then
        if idchatrom ~= 0 then
            local xPlayer = ESX.GetPlayerFromId(idchatrom)
            idchatrom = 0
            if xPlayer then
                TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Chat Room Shoma Ba F.B.I Baste Shod")
            end
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Chat Room Shoma Ba ~g~".. xPlayer.name.."~w~ Baste Shod")
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Shoma Chat Room Baz Nadarid!!!")
        end
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Shoma Dast Resi Nadarid!")
    end
end)

RegisterCommand('fw_fbi', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(fbisource)
    local Target  = ESX.GetPlayerFromId(idchatrom)
    local Message = table.concat(args, " ")
    if source == fbisource then
        TriggerClientEvent('fbi_chat:receiveMessage', idchatrom, nil, Message, true)
        TriggerClientEvent('fbi_chat:receiveMessage', fbisource, nil, Message, true)
    elseif source == idchatrom then
        TriggerClientEvent('fbi_chat:receiveMessage', fbisource, Target.name, Message, false)
        TriggerClientEvent('fbi_chat:receiveMessage', idchatrom, Target.name, Message, false)

    end
end)