RegisterNetEvent('hud:achievementToast')
AddEventHandler('hud:achievementToast', function(title, description)
    SendNUIMessage({
        type = "achievementToast",
        title = title,
        description = description,
    })
end)
