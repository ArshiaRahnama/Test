-- Unique_AdminPanel | client/toast.lua
-- Fancy notification cards rendered by html/app.js (type 'uapToast'). Never takes focus/mouse.
-- variants: victim | driver | admin | warn | danger | ok

local SOUNDS = {
    driver = { 'CHECKPOINT_MISSED', 'HUD_MINI_GAME_SOUNDSET' },
    danger = { 'CHECKPOINT_MISSED', 'HUD_MINI_GAME_SOUNDSET' },
    warn   = { 'CHALLENGE_UNLOCKED', 'HUD_AWARDS' },
    victim = { 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    ok     = { 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    admin  = { 'CHALLENGE_UNLOCKED', 'HUD_AWARDS' },
}

function UapToast(variant, title, lines, duration)
    SendNUIMessage({
        type = 'uapToast',
        data = { variant = variant or 'warn', title = title or '', lines = lines or {}, duration = duration or 7000 },
    })
    local s = SOUNDS[variant or 'warn']
    if s then PlaySoundFrontend(-1, s[1], s[2], true) end
end

RegisterNetEvent('vdm:cl:toast', function(p)
    if type(p) ~= 'table' then return end
    UapToast(p.variant, p.title, p.lines, p.duration)
end)
