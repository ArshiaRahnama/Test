local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function UpdateLeaderboard()
    ESX.TriggerServerCallback('HUD_Menu:GetLeaderboard', function(entries)
        SendNUIMessage({ type = "loadLeaderboard", board = "players", entries = entries })
    end, 'players')

    ESX.TriggerServerCallback('HUD_Menu:GetLeaderboard', function(entries)
        SendNUIMessage({ type = "loadLeaderboard", board = "gangs", entries = entries })
    end, 'gangs')
end

RegisterNUICallback('compareRequest', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:GetPlayerStats', function(stats)
        SendNUIMessage({ type = "compareResult", stats = stats })
    end, data.playerName)
    cb('ok')
end)
