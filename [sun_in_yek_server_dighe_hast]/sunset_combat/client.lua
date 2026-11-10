-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('sscombat:toggle', function(status, time)
    if status then
        SendNUIMessage({
            action = 'new',
            time = time
        })
    else
        SendNUIMessage({
            action = 'hide'
        })
    end
end)