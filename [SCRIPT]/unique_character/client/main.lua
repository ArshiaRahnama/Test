-- unique_character / client
--
-- Unique character flow: fade out -> status text -> hide ped -> register form ->
-- "wearing clothes" -> slow fade-in.
--
-- Pitfalls this client is written to avoid:
--   * needRegister must start as nil (not false) and be re-asked from the server;
--     otherwise a slow login could skip registration entirely.
--   * no unbounded `while step < N` waits: every wait has a timeout.
--   * NUI callbacks must always answer cb(); the controls thread must not be
--     spawned again on every showUI(); the cursor must be released when the
--     resource restarts; the NUI url must use GetParentResourceName().
--   * the bottom status panel lives in this resource's own NUI (no ps-ui dependency).
--   * the screen must stay black until everything is loaded: other scripts that fade it
--     in early (spawnmanager does) must not be visible: a black rectangle covers the screen
--     (Config.HoldBlack) while the engine fade is left alone, and Config.MinBlackMs is a hard minimum.
--     NEVER force the engine fade back to black: spawnmanager waits for IsScreenFadedIn()
--     before it fires 'playerSpawned', so doing that deadlocks the whole spawn.

local ESX = nil
local needRegister = nil     -- nil = unknown yet, true = new player, false = has character
local uiReady, uiOpen = false, false
local controlLock = false
local flowDone = false       -- spawn finished (set exactly once per session)
local clothesReady = false
local loadedFired = false    -- 'loading:Loaded' must fire once (AdminPanel + essentialmode rely on that)
local isNewCharacter = false
local holding = true        -- keep the ped hidden/frozen AND the screen black until finishSpawn
local blackSince = nil      -- GetGameTimer() when the screen went black
local covering = false      -- a black rectangle is being drawn over the screen
local spawnedSeen = false   -- spawnmanager fired 'playerSpawned' (ped spawned at the default spawn point)
local teleportDone = false  -- essentialmode finished moving the ped to its last position

---------------------------------------------------------------------------
-- small helpers
---------------------------------------------------------------------------

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

-- Bottom status panel (part of this resource's NUI, no ps-ui needed).
-- Messages sent before the NUI page is ready are remembered and replayed on 'initialize'.
local lastStatus = nil

local function status(message)
    lastStatus = message
    if uiReady then
        SendNUIMessage({ action = 'status', show = true, title = Config.Text.loadingTitle, values = { message } })
    end
end

local function statusHide()
    lastStatus = nil
    SendNUIMessage({ action = 'status', show = false })
end

local function setHidden(state)
    local ped = PlayerPedId()
    SetEntityVisible(ped, not state, false)
    SetEntityInvincible(ped, state)
    FreezeEntityPosition(ped, state)
end

-- Black cover drawn every frame. Unlike DoScreenFadeOut it does not touch the engine's
-- fade state, so spawnmanager can finish its own fade-in and fire 'playerSpawned'.
local function startCover()
    if covering or not Config.HoldBlack then return end
    covering = true
    CreateThread(function()
        while covering do
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
            if Config.CoverHud then HideHudAndRadarThisFrame() end
            Wait(0)
        end
    end)
end

local function stopCover()
    covering = false
end

local function waitFor(cond, timeoutMs, step)
    local started = GetGameTimer()
    while not cond() and (GetGameTimer() - started) < timeoutMs do
        Wait(step or 50)
    end
    return cond()
end

---------------------------------------------------------------------------
-- trace: "who is loading my player?"  (F8 command: uc_trace)
---------------------------------------------------------------------------

local traceOn     = Config.Trace == true
local traceStart  = GetGameTimer()
local traceCounts = {}
local traceOrder  = {}

local function trace(fmt, ...)
    if not traceOn then return end
    print(('[unique_character +%5dms] '):format(GetGameTimer() - traceStart) .. fmt:format(...))
end

local function traceCount(name)
    if traceCounts[name] == nil then
        traceCounts[name] = 0
        traceOrder[#traceOrder + 1] = name
    end
    traceCounts[name] = traceCounts[name] + 1
    trace('event %s (#%d)', name, traceCounts[name])
end

local function traceSummary()
    print('[unique_character] ---- load trace summary ----')
    local repeated = 0
    for _, name in ipairs(traceOrder) do
        local n = traceCounts[name]
        print(('  %-26s x%d%s'):format(name, n, n > 1 and '   <-- fired more than once' or ''))
        if n > 1 then repeated = repeated + 1 end
    end
    print(repeated == 0 and '  (nothing fired twice)' or ('  ' .. repeated .. ' event(s) fired more than once: something else is loading the player too'))
end

-- every load-related event, counted always (cheap), printed only when tracing
for _, ev in ipairs({
    'playerSpawned', 'esx:playerLoaded', 'esx:playerSpawned', 'loading:Loaded', 'es_admin:freezePlayer',
    'skinchanger:loadSkin', 'skinchanger:modelLoaded', 'skincreator:newChar', 'registerForm', 'showRegisterForm',
}) do
    if ev == 'esx:playerLoaded' or ev == 'registerForm' then RegisterNetEvent(ev) end -- sent by the server
    AddEventHandler(ev, function() traceCount(ev) end)
end

RegisterCommand('uc_trace', function()
    traceOn = not traceOn
    print('[unique_character] trace ' .. (traceOn and 'ON' or 'OFF'))
    if not traceOn or next(traceCounts) ~= nil then traceSummary() end
end, false)

-- state changes of the screen and of the ped (swapped ped / model / visibility / freeze)
CreateThread(function()
    local last = {}
    while true do
        if not traceOn then
            Wait(500)
        else
            local ped = PlayerPedId()
            local now = {
                fade    = IsScreenFadedOut() and 'black' or (IsScreenFadingIn() and 'fading-in' or (IsScreenFadingOut() and 'fading-out' or 'visible')),
                ped     = ped,
                model   = GetEntityModel(ped),
                visible = IsEntityVisible(ped),
                frozen  = IsEntityPositionFrozen(ped),
            }
            for k, v in pairs(now) do
                if last[k] ~= v then
                    trace('%s: %s -> %s', k, tostring(last[k]), tostring(v))
                    last[k] = v
                end
            end
            Wait(100)
        end
    end
end)

-- another loader still running? (the server stops these, this only warns if it could not)
CreateThread(function()
    Wait(8000)
    for _, name in ipairs(Config.ConflictingResources or {}) do
        if GetResourceState(name) == 'started' then
            print(('[unique_character] WARNING: "%s" is still running and also loads the player. Stop it or remove it from ensure.'):format(name))
        end
    end
end)

---------------------------------------------------------------------------
-- spawn progress (who puts the ped where, and when)
--
-- spawnmanager spawns the ped at the DEFAULT spawn point and fires 'playerSpawned'.
-- essentialmode then waits for esx:playerLoaded, teleports the ped to its LAST
-- position and finishes with es_admin:freezePlayer(true). If we fade in before that,
-- the player sees: default spawn -> jump to the last position -> freeze.
-- So the fade-in waits for both signals below.
---------------------------------------------------------------------------

AddEventHandler('playerSpawned', function()
    spawnedSeen = true
    trace('playerSpawned (ped is at the default spawn point)')
end)

AddEventHandler('es_admin:freezePlayer', function(state)
    -- only the freeze that essentialmode sends right after placing the ped counts
    if state == true and spawnedSeen and not teleportDone then
        teleportDone = true
        trace('essentialmode placed the ped at its last position')
    end
end)

---------------------------------------------------------------------------
-- state from the server
---------------------------------------------------------------------------

-- essentialmode pushes this right after esx:playerLoaded (login.lua)
RegisterNetEvent('registerForm')
AddEventHandler('registerForm', function(state)
    needRegister = state and true or false
end)

-- answer to our own fallback ask
RegisterNetEvent('unique_character:state')
AddEventHandler('unique_character:state', function(state)
    if needRegister == nil then needRegister = state and true or false end
end)

-- clothing system gate: any of these events means "clothes are on"
for _, ev in ipairs(Config.ClothesEvents) do
    AddEventHandler(ev, function() clothesReady = true end) -- local events, not RegisterNetEvent
end

---------------------------------------------------------------------------
-- NUI
---------------------------------------------------------------------------

local function controlLoop()
    if controlLock then return end -- never stack a second loop
    controlLock = true
    CreateThread(function()
        while uiOpen do
            Wait(0)
            DisableControlAction(0, 1,   true) -- LookLeftRight
            DisableControlAction(0, 2,   true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
            DisableControlAction(0, 21,  true) -- sprint
            DisableControlAction(0, 24,  true) -- attack
            DisableControlAction(0, 25,  true) -- aim
            DisableControlAction(0, 47,  true) -- weapon
            DisableControlAction(0, 58,  true) -- weapon
            DisableControlAction(0, 263, true) -- melee
            DisableControlAction(0, 264, true) -- melee
            DisableControlAction(0, 257, true) -- melee
            DisableControlAction(0, 140, true) -- melee
            DisableControlAction(0, 141, true) -- melee
            DisableControlAction(0, 143, true) -- melee
            DisableControlAction(0, 75,  true) -- exit vehicle
            DisableControlAction(27, 75, true) -- exit vehicle
        end
        controlLock = false
    end)
end

local function showUI(state)
    if state then
        -- poll instead of sleeping a fixed 5 s, give up after 5 s
        waitFor(function() return uiReady end, 5000, 50)
    end
    uiOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({ type = 'enableui', enable = state })
    if state then controlLoop() end
end

RegisterNUICallback('initialize', function(_, cb)
    uiReady = true
    cb('ok')
    if lastStatus ~= nil and not flowDone then status(lastStatus) end -- replay what was shown before the page loaded
end)

local function notify(message)
    SendNUIMessage({ action = 'notification', message = message })
end

local function unlockForm()
    SendNUIMessage({ action = 'unlock' })
end

RegisterNUICallback('register', function(data, cb)
    cb('ok') -- always answer, otherwise the NUI fetch hangs

    if not ESX or not uiOpen or type(data) ~= 'table' then return unlockForm() end

    ESX.TriggerServerCallback('unique_character:register', function(code)
        if code == 'ok' or code == 'already' then
            isNewCharacter = (code == 'ok')
            needRegister = false
            showUI(false)
            return
        end
        unlockForm()
        notify(Config.Text[code] or Config.Text.error)
    end, data.firstname, data.lastname)
end)

---------------------------------------------------------------------------
-- spawn sequence (everything old ReadToPlay() did, in the same order, but
-- driven by conditions + timeouts instead of ~20 s of fixed sleeps)
---------------------------------------------------------------------------

-- true once the ped REALLY is at its saved last position (not just "events arrived")
local function isPlaced()
    if not (ESX.IsPlayerLoaded and ESX.IsPlayerLoaded()) then return false end
    if not (spawnedSeen and teleportDone) then return false end

    local data = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
    local lp = data and data.lastPosition
    if lp and lp.x and lp.y then
        local c = GetEntityCoords(PlayerPedId())
        local dx, dy = c.x - lp.x, c.y - lp.y
        -- x,y only: if the ground has not streamed in yet the ped can fall, z would never match
        if (dx * dx + dy * dy) > (Config.PlaceRadius * Config.PlaceRadius) then return false end
    end
    return true
end

local function placementReport()
    local data = ESX.GetPlayerData and ESX.GetPlayerData() or ESX.PlayerData
    local lp = data and data.lastPosition
    local dist = 'n/a'
    if lp and lp.x and lp.y then
        local c = GetEntityCoords(PlayerPedId())
        dist = ('%.0fm'):format(math.sqrt((c.x - lp.x) ^ 2 + (c.y - lp.y) ^ 2))
    end
    return ('esx loaded: %s, playerSpawned: %s, essentialmode placed it: %s, distance to last position: %s'):format(
        tostring(ESX.IsPlayerLoaded and ESX.IsPlayerLoaded() or false), tostring(spawnedSeen), tostring(teleportDone), dist)
end

local function stage(message, minMs, cond, timeoutMs, report)
    status(message)
    local started = GetGameTimer()
    if cond then
        local nextReport = started + 10000
        while not cond() and (GetGameTimer() - started) < (timeoutMs or 0) do
            if report and GetGameTimer() >= nextReport then
                nextReport = nextReport + 10000
                print(('[unique_character] still waiting (+%ds) "%s": %s'):format((GetGameTimer() - started) // 1000, message, report()))
            end
            Wait(100)
        end
    end
    local left = minMs - (GetGameTimer() - started)
    if left > 0 then Wait(left) end
end

local function waitForWorld()
    -- 'Preparing for spawn'
    stage(Config.Text.preparing, math.max(Config.PrepareMs, Config.SettleMs), nil)

    -- 'Teleporting to last location': ESX loaded + ground collision under the ped
    stage(Config.Text.teleporting, Config.TeleportMs, isPlaced, Config.WorldTimeoutMs, placementReport)

    if not isPlaced() then
        print(('[unique_character] WARNING: the player was not placed at the last position within %ds (%s). Fading in anyway; run uc_trace to see what is late.')
            :format(Config.WorldTimeoutMs // 1000, placementReport()))
    end

    local c = GetEntityCoords(PlayerPedId())
    RequestCollisionAtCoord(c.x, c.y, c.z)
    waitFor(function()
        c = GetEntityCoords(PlayerPedId())
        RequestCollisionAtCoord(c.x, c.y, c.z)
        return HasCollisionLoadedAroundEntity(PlayerPedId())
    end, Config.CollisionTimeout, 50)

    -- 'Wearing clothe': clothing/skin system finished
    stage(Config.Text.clothes, Config.ClothesMinMs, Config.WaitForClothes and function() return clothesReady end or nil, Config.ClothesTimeoutMs)

    -- never fade in earlier than MinBlackMs after the screen went black
    while blackSince and (GetGameTimer() - blackSince) < Config.MinBlackMs do
        Wait(100)
    end
end

local function finishSpawn()
    TriggerServerEvent('asgm_LoadingSystem:ChangeKobs', false)

    SetPedDiesInWater(PlayerPedId(), true)
    TriggerEvent('es_admin:freezePlayer', false)

    TriggerEvent('esx:restoreLoadout')
    TriggerServerEvent('asgm_streetlabel:spawned')
    TriggerServerEvent('asgm_hud:spawned')
    TriggerEvent('esx_status:setLastStats')
    TriggerServerEvent('esx_rack:loaded')

    -- exactly once: skincreator, Unique_LoadingScreen, Unique_AdminPanel and
    -- essentialmode's position reporting all key off this event
    if not loadedFired then
        loadedFired = true
        TriggerEvent('loading:Loaded')
    end

    Wait(500)
    TriggerEvent('es_admin:freezePlayer', false)
    TriggerEvent('esx:playerSpawned')
    Wait(500)

    ESX.SetPlayerData('IsPlayerLoaded', 1)
    TriggerEvent('esx_best:checkVanish')
    ESX.SetPlayerData('IsLoaded', 1)
    DisplayRadar(true)

    -- release the black screen + the hidden/frozen ped together, then fade in
    holding = false
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)
    TriggerEvent('es_admin:freezePlayer', false)

    -- hand over from the black cover to a real fade, without a single visible frame:
    -- make the engine fade fully black first, only then drop the cover and fade in
    DoScreenFadeOut(0)
    waitFor(function() return IsScreenFadedOut() end, 1000, 0)
    stopCover()
    status(Config.Text.welcome)
    DoScreenFadeIn(Config.FadeInMs)
    statusHide()

    flowDone = true
    trace('spawn flow finished (new character: %s)', tostring(isNewCharacter))
    if traceOn then traceSummary() end
    TriggerEvent('unique_character:spawned', isNewCharacter)

    if isNewCharacter then
        Wait(2000)
        TriggerEvent('skincreator:newChar') -- appearance editor, same as before
    end

    -- other scripts freeze the ped late (essentialmode playerSpawned): keep
    -- releasing it for the same ~15 s window the old code used
    for _ = 1, Config.UnfreezeWindowSec do
        Wait(1000)
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerEvent('es_admin:freezePlayer', false)
    end
end

---------------------------------------------------------------------------
-- main flow
---------------------------------------------------------------------------

CreateThread(function()
    while ESX == nil do Wait(100) end

    -- Resource restarted while the player is already playing: do nothing
    -- (otherwise the screen would black out and a live player would be frozen).
    if ESX.IsPlayerLoaded and ESX.IsPlayerLoaded() and IsScreenFadedIn() then
        flowDone, loadedFired, needRegister = true, true, false
        return
    end

    DoScreenFadeOut(Config.FadeOutMs)
    startCover()
    blackSince = GetGameTimer()
    ShutdownLoadingScreen() -- Unique_LoadingScreen closes its own NUI (fade) from the events below

    while not NetworkIsPlayerActive(PlayerId()) do Wait(100) end

    status(Config.Text.retrieving)
    setHidden(true)
    -- spawnmanager / essentialmode can re-create or re-freeze the ped after we hid it.
    -- Re-apply that until the spawn sequence takes over. (The screen is covered by
    -- startCover(); we deliberately do NOT re-force the engine fade, see the header.)
    CreateThread(function()
        while holding do
            setHidden(true)
            Wait(100)
        end
    end)
    Wait(Config.RetrieveMs)

    -- Ask the server ourselves if registerForm never arrived (and keep asking).
    local deadline = GetGameTimer() + Config.StateFallbackMs
    while needRegister == nil do
        if GetGameTimer() >= deadline then
            TriggerServerEvent('unique_character:check')
            deadline = GetGameTimer() + Config.StateRetryMs
        end
        Wait(250)
    end

    if needRegister then
        status(Config.Text.register)
        TriggerEvent('showRegisterForm') -- lets Unique_LoadingScreen close its loadscreen
        showUI(true)
        -- register callback flips needRegister to false when the server said ok
        while needRegister do Wait(250) end
    end

    waitForWorld()
    finishSpawn()
end)

---------------------------------------------------------------------------
-- cleanup + exports
---------------------------------------------------------------------------

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    uiOpen = false
    covering = false
    SetNuiFocus(false, false) -- never leave the cursor stuck on restart
    statusHide()
end)

exports('isReady', function() return flowDone end)
exports('needsRegister', function() return needRegister end)
