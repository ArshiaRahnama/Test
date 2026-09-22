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

    -- Static per menu-open (Config.TrackedJobs doesn't change at
    -- runtime) — the PER JOB subtab's grid/detail view still reads job
    -- labels from this instead of hardcoding them in leaderboard.js.
    SendNUIMessage({ type = "trackedJobs", jobs = Config.TrackedJobs })

    ESX.TriggerServerCallback('HUD_Menu:GetGangWatch', function(entries)
        SendNUIMessage({ type = "loadGangWatch", entries = entries })
    end)
end

RegisterNUICallback('compareRequest', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:GetPlayerStats', function(stats)
        SendNUIMessage({ type = "compareResult", stats = stats })
    end, data.playerName)
    cb('ok')
end)

-- PER JOB subtab landing view: the #1 member of every tracked job at
-- once — fired on subtab open and on the week/month toggle.
RegisterNUICallback('jobChampionsRequest', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:GetJobChampions', function(champions)
        SendNUIMessage({ type = "loadJobChampions", period = data.period, champions = champions })
    end, data.period)
    cb('ok')
end)

-- PER JOB subtab detail view: fired when a champion card is clicked
-- (or the week/month toggle changes while a job's detail is open).
-- jobLabel comes back from the server too so the UI never has to keep
-- its own copy of Config.TrackedJobs' labels in sync.
RegisterNUICallback('jobLeaderboardRequest', function(data, cb)
    ESX.TriggerServerCallback('HUD_Menu:GetJobLeaderboard', function(entries, jobLabel)
        SendNUIMessage({
            type     = "loadJobLeaderboard",
            job      = data.job,
            period   = data.period,
            jobLabel = jobLabel,
            entries  = entries,
        })
    end, data.job, data.period)
    cb('ok')
end)
