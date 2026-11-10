-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


exports('getPersonalData', function()
    local p = promise.new()
    ESX.TriggerServerCallback('lvl:getData',function(lvl, xp, timePlay, less, token)
        local needxp = 1000000
        if config.Levels[lvl + 1] then
            needxp = config.Levels[lvl + 1].xp
        end
        xp = ESX.Math.Round(xp)
        p:resolve({
            level = lvl,
            xp = xp,
            needXP = needxp,
            maxXp = needxp,
            timePlay = ESX.displayTime(timePlay),
            token = token,
        })
    end, true)
    return Citizen.Await(p)
end)
