-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.MODULE = PB.MODULE or 'paintball'
PB.HUD = PB.HUD or 'paintball-hud'

RegisterNetEvent('paintball:achievementUnlock', function(ach)
    if not ach or not ach.key then return end
    if SUN.IsUIOpen and SUN.IsUIOpen(PB.HUD) then
        SUN.SendUIData(PB.HUD, {type = 'achievementUnlock', payload = ach})
    end
    if SUN.IsUIOpen and SUN.IsUIOpen(PB.MODULE) then
        SUN.SendUIData(PB.MODULE, {type = 'achievementUnlock', payload = ach})
    end
    PlaySoundFrontend(-1, 'MEDAL_BRONZE', 'HUD_MINI_GAME_SOUNDSET', true)
    SetTimeout(150, function()
        if ach.tier == 'platinum' then
            PlaySoundFrontend(-1, 'RACE_PLACED', 'HUD_AWARDS', true)
        elseif ach.tier == 'gold' then
            PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true)
        elseif ach.tier == 'silver' then
            PlaySoundFrontend(-1, 'MEDAL_UP', 'HUD_MINI_GAME_SOUNDSET', true)
        end
    end)
end)
