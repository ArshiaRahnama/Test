-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Map fixes
exports('GetMercenariesFixesObject', function()
    return MercenariesFixes
end)

MercenariesFixes = {
    ipl = "m23_1_legacy_fixes",

    Enable = function(state)
        EnableIpl(MercenariesFixes.ipl, state)
    end,

    LoadDefault = function()
        MercenariesFixes.Enable(true)
    end
}