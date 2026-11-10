-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

exports('GetRedCarpetObject', function()
    return RedCarpet
end)

RedCarpet = {
    ipl = "redCarpet",

    Enable = function(state)
        EnableIpl(RedCarpet.ipl, state)
    end
}
