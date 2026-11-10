-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNUICallback('get-website', function(_, cb)
    cb({
        url = (Config.Website and Config.Website.Url) or '',
        name = (Config.Website and Config.Website.Name) or 'Website'
    })
end)
