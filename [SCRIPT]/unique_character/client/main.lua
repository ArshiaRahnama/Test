-- unique_character / client
--
-- Same flow as Sunset's sun-character (fade out -> status text -> hide ped ->
-- register form -> "wearing clothes" -> slow fade-in), rebuilt on Unique's stack
-- and with the bugs of both versions removed:
--
--   Unique loading.lua : needRegister started as `false` but the loop waited for
--                        `nil` -> a slow login could skip registration entirely.
--                        Here it starts as nil and is re-asked from the server.
--   Sunset sun-character: infinite `while loadStep < 2` waits, NUI callbacks never
--                        answered with cb(), controls thread spawned on every
--                        showUI(), cursor stuck if the resource restarts, hard-
--                        coded 'sun-character' NUI url, ps-ui called with the
--                        wrong argument shape for Unique's ps-ui.

local ESX = nil
local needRegister = nil     -- nil = unknown yet, true = new player, false = has character
local uiReady, uiOpen = false, false
local controlLock = false
local flowDone = false       -- spawn finished (set exactly once per session)
local clothesReady = false
local loadedFired = false    -- 'loading:Loaded' must fire once (AdminPanel + essentialmode rely on that)
local isNewCharacter = false
local holding = true        -- keep the ped hidden/frozen until finishSpawn

---------------------------------------------------------------------------
-- small helpers
---------------------------------------------------------------------------

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

-- Unique's ps-ui signature: StatusShow(title, description, icon, values).
-- (Sunset's version takes (title, {lines}); calling that shape here would throw.)
local function status(message)
    pcall(function()
        exports['ps-ui']:StatusShow(Config.Text.loadingTitle, message, 'fas fa-user', {})
    end)
end

local function statusHide()
    pcall(function() exports['ps-ui']:StatusHide() end)
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
    if controlLock then return end -- never stack a second loop (Sunset leaked one per open)
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
        -- Sunset slept 5 s unconditionally; poll instead, give up after 5 s
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

local function waitForWorld()
    waitFor(function() return ESX.IsPlayerLoaded and ESX.IsPlayerLoaded() end, Config.WorldTimeoutMs, 100)

    status(Config.Text.preparing)
    Wait(Config.SettleMs)

    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    RequestCollisionAtCoord(c.x, c.y, c.z)
    waitFor(function()
        c = GetEntityCoords(PlayerPedId())
        RequestCollisionAtCoord(c.x, c.y, c.z)
        return HasCollisionLoadedAroundEntity(PlayerPedId())
    end, Config.CollisionTimeout, 50)

    if Config.WaitForClothes then
        status(Config.Text.clothes)
        waitFor(function() return clothesReady end, Config.ClothesTimeoutMs, 100)
    end
end

local function finishSpawn()
    holding = false
    local ped = PlayerPedId()
    TriggerServerEvent('asgm_LoadingSystem:ChangeKobs', false)

    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
    FreezeEntityPosition(ped, false)
    SetPedDiesInWater(ped, true)
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
    -- (Sunset would black out the screen and freeze a live player here).
    if ESX.IsPlayerLoaded and ESX.IsPlayerLoaded() and IsScreenFadedIn() then
        flowDone, loadedFired, needRegister = true, true, false
        return
    end

    DoScreenFadeOut(Config.FadeOutMs)
    ShutdownLoadingScreen() -- Unique_LoadingScreen closes its own NUI (fade) from the events below

    while not NetworkIsPlayerActive(PlayerId()) do Wait(100) end

    status(Config.Text.retrieving)
    setHidden(true)
    -- spawnmanager / essentialmode can re-create or re-freeze the ped after we
    -- hid it; re-apply until the spawn sequence takes over
    CreateThread(function()
        while holding do
            setHidden(true)
            Wait(500)
        end
    end)
    Wait(1500)

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
    SetNuiFocus(false, false) -- Sunset left the cursor stuck on restart
    statusHide()
end)

exports('isReady', function() return flowDone end)
exports('needsRegister', function() return needRegister end)
