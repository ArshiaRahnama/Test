local ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Set whenever the leaderboard is fetched (menu open + 30s auto-refresh);
-- read by client/menu.lua's UpdateProfile to flag the header avatar.
MyLeaderboardTier = nil

function UpdateLeaderboard()
    ESX.TriggerServerCallback('HUD_Menu:GetLeaderboard', function(entries, myTier)
        MyLeaderboardTier = myTier
        SendNUIMessage({ type = "loadLeaderboard", board = "players", entries = entries })
        SendNUIMessage({ type = "myTier", tier = myTier })
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
