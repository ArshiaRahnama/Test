local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

function UpdateAchievements()
    ESX.TriggerServerCallback('HUD_Menu:GetAchievements', function(list, points)
        SendNUIMessage({ type = 'loadAchievements', achievements = list or {}, points = points or 0 })
    end)
end

local profileOpen = false

RegisterCommand('profile', function(_, args)
    local id = tonumber(args[1])
    if not id then
        TriggerEvent('esx:showNotification', 'Usage: /profile [player id]')
        return
    end
    ESX.TriggerServerCallback('HUD_Menu:GetProfile', function(p)
        if not p then
            TriggerEvent('esx:showNotification', 'Player not found')
            return
        end
        profileOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ type = 'showProfile', profile = p })
    end, id)
end, false)

RegisterNUICallback('profileClosed', function(_, cb)
    profileOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

function UpdateWeekly()
    ESX.TriggerServerCallback('HUD_Menu:GetWeekly', function(list, resetIn)
        SendNUIMessage({ type = 'loadWeekly', quests = list or {}, resetIn = resetIn or 0 })
    end)
end
