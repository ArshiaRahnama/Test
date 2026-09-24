-- Unique RP loading screen: closes the NUI loadscreen at the right moment
-- (fade-out first). Hooks the events this server already fires.
local closed = false

local function closeLoadscreen()
    if closed then return end
    closed = true
    SendLoadingScreenMessage(json.encode({ eventName = 'unique:closing' }))
    Wait(700)
    ShutdownLoadingScreenNui()
end

for _, ev in ipairs({ 'playerSpawned', 'esx:playerLoaded', 'loading:Loaded', 'showRegisterForm' }) do
    AddEventHandler(ev, function() CreateThread(closeLoadscreen) end)
end

-- Failsafe: never leave a player stuck behind the loadscreen.
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(250) end
    Wait(45000)
    closeLoadscreen()
end)
