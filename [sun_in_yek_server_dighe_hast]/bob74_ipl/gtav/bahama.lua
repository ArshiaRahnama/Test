-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Bahama Mamas: -1388.0013, -618.41967, 30.819599
exports('GetBahamaMamasObject', function()
    return BahamaMamas
end)

BahamaMamas = {
    ipl = "hei_sm_16_interior_v_bahama_milo_",

    Enable = function(state)
        EnableIpl(BahamaMamas.ipl, state)
    end
}
