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
--     in early are overridden (Config.HoldBlack), and Config.MinBlackMs is a hard minimum.

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

local function waitFor(cond, timeoutMs, step)
    local started = GetGameTimer()
    while not cond() and (GetGameTimer() - started) < timeoutMs do
        Wait(step or 50)
    end
    return cond()
end

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

local function stage(message, minMs, cond, timeoutMs)
    status(message)
    local started = GetGameTimer()
    if cond then waitFor(cond, timeoutMs or 0, 100) end
    local left = minMs - (GetGameTimer() - started)
    if left > 0 then Wait(left) end
end

local function waitForWorld()
    -- 'Preparing for spawn'
    stage(Config.Text.preparing, math.max(Config.PrepareMs, Config.SettleMs), nil)

    -- 'Teleporting to last location': ESX loaded + ground collision under the ped
    stage(Config.Text.teleporting, Config.TeleportMs, function()
        return ESX.IsPlayerLoaded and ESX.IsPlayerLoaded()
    end, Config.WorldTimeoutMs)

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

    status(Config.Text.welcome)
    DoScreenFadeIn(Config.FadeInMs)
    statusHide()

    flowDone = true
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
    blackSince = GetGameTimer()
    ShutdownLoadingScreen() -- Unique_LoadingScreen closes its own NUI (fade) from the events below

    while not NetworkIsPlayerActive(PlayerId()) do Wait(100) end

    status(Config.Text.retrieving)
    setHidden(true)
    -- spawnmanager / essentialmode can re-create or re-freeze the ped after we hid it,
    -- and other scripts may fade the screen back in while we are still loading.
    -- Re-apply both until the spawn sequence takes over.
    CreateThread(function()
        while holding do
            setHidden(true)
            if Config.HoldBlack and not IsScreenFadedOut() then
                DoScreenFadeOut(0)
            end
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
    SetNuiFocus(false, false) -- never leave the cursor stuck on restart
    statusHide()
end)

exports('isReady', function() return flowDone end)
exports('needsRegister', function() return needRegister end)
