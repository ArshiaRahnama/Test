-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('copy-to-clipboard', function(data, cb)
    if data.text then
        SendNUIMessage({
            action = "setClipboard",
            text = data.text
        })
    end
    cb(true)
end)
