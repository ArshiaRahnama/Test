--[[
    Unique_GunGame - client logic

    Handles everything for the local player once the server places them into an
    arena: the fade-teleport intro (dropping them in from above), death/respawn
    loop, kill reporting, and relaying server events into NUI messages for the HUD.

    See config.lua for every tunable value and README.md for command/setup docs.
]]

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- ============================================================
-- Constants
-- ============================================================

local FADE_OUT_MS = 300         -- ms for the screen to fade to black before teleporting
local FADE_IN_MS = 500          -- ms for the screen to fade back in after teleporting
local FADE_HOLD_MS = 300        -- ms to stay faded out after moving the ped, before fading back in
local DROP_HEIGHT = 40.0        -- meters above the arena point players are dropped from (they fall/parachute in)
local PARACHUTE_DEPLOY_WAIT = 200 -- ms after landing coords are set before forcing the parachute open
local FALL_POLL_MS = 100        -- how often to check if the player has landed yet
local FALL_MAX_WAIT_MS = 10000  -- safety cap so a stuck landing check can't hang forever
local LANDING_GRACE_MS = 500    -- brief extra invincibility after landing before becoming vulnerable
local BUCKET_SWITCH_WAIT = 200  -- ms given to the routing bucket switch to settle before teleporting
local OUTFIT_APPLY_WAIT = 500   -- ms given to the outfit swap before spawning weapons
local RESPAWN_DELAY = 3000      -- ms after death before the first revive attempt
local REVIVE_RETRY_WAIT = 2500  -- ms between repeated revive attempts if the first one didn't take
local FREEZE_SETTLE_WAIT = 1000 -- ms after a successful revive before freezing the player for the progress bar
local RESPAWN_PROGRESS_MS = 2000 -- duration of the on-screen "Respawning..." progress bar
local WEAPON_SWAP_WAIT = 100    -- ms between clearing weapons and giving the new one on a level-up

-- ============================================================
-- Runtime state
-- ============================================================

local inEvent = false
local alreadyDead = false
local currentLocationSet = nil -- the {Lobby, Arena, Exit} set for the arena this player is currently in

-- ============================================================
-- Helpers
-- ============================================================

-- Standard fade-teleport-fade, far more robust than a scripted camera (which can get
-- stuck if anything interrupts it). When dropFromAbove is true the player is placed
-- high over the target point instead of exactly on it, so they fall/parachute in.
local function teleportWithFade(coords, dropFromAbove)
    SetEntityInvincible(PlayerPedId(), true)

    DoScreenFadeOut(FADE_OUT_MS)
    local waited = 0
    while not IsScreenFadedOut() and waited < 2000 do
        Citizen.Wait(50)
        waited = waited + 50
    end

    local targetZ = dropFromAbove and (coords.z + DROP_HEIGHT) or coords.z
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, targetZ, false, false, false, false)

    Citizen.Wait(FADE_HOLD_MS)
    DoScreenFadeIn(FADE_IN_MS)
    Citizen.Wait(FADE_IN_MS)

    if not dropFromAbove then
        SetEntityInvincible(PlayerPedId(), false)
    end
    -- when dropping from above, invincibility is left on until the caller gives a
    -- weapon/parachute and the fall has had a moment to start, so a stray bullet
    -- or fall damage can't kill someone before they've even landed
end

local function applyEventOutfit()
    if not Config.ChangeOutfitOnJoin then return end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local outfit = (skin.sex == 0) and Config.OutfitMale or Config.OutfitFemale
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
    end)
end

local function spawnIntoArena()
    RemoveAllPedWeapons(PlayerPedId(), true)
    if Config.GiveParachuteOnSpawn then
        GiveWeaponToPed(PlayerPedId(), GetHashKey('gadget_parachute'), 1, false, false)
    end

    teleportWithFade(currentLocationSet.Arena, true)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.Weapons[1]), Config.WeaponAmmo, false, true)

    if Config.GiveParachuteOnSpawn then
        Citizen.Wait(PARACHUTE_DEPLOY_WAIT)
        TaskParachute(PlayerPedId(), true)
    end

    -- Stay invincible until the player has actually landed rather than guessing a fixed
    -- delay - a 40m fall takes longer than a short guess, and taking fall damage the
    -- instant invincibility dropped (while still airborne) is what made deaths right
    -- after spawning feel instant.
    local waited = 0
    while GetEntityHeightAboveGround(PlayerPedId()) > 1.5 and waited < FALL_MAX_WAIT_MS do
        Citizen.Wait(FALL_POLL_MS)
        waited = waited + FALL_POLL_MS
    end
    Citizen.Wait(LANDING_GRACE_MS)
    SetEntityInvincible(PlayerPedId(), false)
end

-- Scans every active player ped against the ped that killed us to resolve a
-- server id. GetPedKiller only returns a ped handle, so this is unavoidable
-- for turning "who killed me" into "which player id do I report".
local function findKillerServerId(killerPed, ownPed)
    if not killerPed or killerPed == ownPed then return 0 end
    for _, id in ipairs(GetActivePlayers()) do
        if GetPlayerPed(id) == killerPed then
            return GetPlayerServerId(id)
        end
    end
    return 0
end

-- ============================================================
-- Join / leave
-- ============================================================

-- locationSet is picked server-side per arena (round-robin over Config.Locations) and
-- isolation between concurrent arenas comes from the server assigning each one its own
-- routing bucket, so this client never needs to know about other arenas running at once.
RegisterNetEvent('Unique_GunGame:JoinToMach')
AddEventHandler('Unique_GunGame:JoinToMach', function(locationSet)
    currentLocationSet = locationSet
    inEvent = true
    alreadyDead = false

    SendNUIMessage({ action = 'hideCountdown' })
    SendNUIMessage({ action = 'showScoreboard' })

    Citizen.Wait(BUCKET_SWITCH_WAIT)
    teleportWithFade(currentLocationSet.Lobby, false)
    applyEventOutfit()
    Citizen.Wait(OUTFIT_APPLY_WAIT)
    spawnIntoArena()
end)

RegisterNetEvent('Unique_GunGame:End')
AddEventHandler('Unique_GunGame:End', function(locationSet)
    inEvent = false
    alreadyDead = false
    SetEntityInvincible(PlayerPedId(), false)
    RemoveAllPedWeapons(PlayerPedId(), true)

    SendNUIMessage({ action = 'hideScoreboard' })
    SendNUIMessage({ action = 'hideTimer' })

    local exitLoc = (locationSet or currentLocationSet or Config.Locations[1]).Exit
    teleportWithFade({
        x = exitLoc.x + math.random(-10, 10),
        y = exitLoc.y + math.random(-10, 10),
        z = exitLoc.z + 2.0,
    }, false)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

-- ============================================================
-- Death / kill reporting
-- ============================================================

-- Runs the full death -> revive -> respawn sequence. Bails out early at every
-- stage if the arena ends (inEvent goes false) while this is still in progress,
-- so a player who dies right as their arena is won doesn't get stuck frozen or
-- teleported back into an arena that no longer exists for them.
local function handleDeath(playerPed)
    alreadyDead = true
    SetEntityInvincible(playerPed, true)
    TriggerServerEvent('Unique_GunGame:PlayerDied')

    local killerServerId = findKillerServerId(GetPedKiller(playerPed), playerPed)
    if killerServerId ~= 0 then
        TriggerServerEvent('Unique_GunGame:ReportKill', killerServerId, GetPlayerName(PlayerId()))
    end

    Citizen.Wait(RESPAWN_DELAY)
    if not inEvent then
        alreadyDead = false
        SetEntityInvincible(PlayerPedId(), false)
        return
    end

    if Config.ForceNativeRevive then
        -- Resurrects the ped directly at the game-engine level, bypassing whatever
        -- custom death/medic system the server might otherwise force this player
        -- to sit through (long timers, distress signals, etc).
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
        ClearPedTasksImmediately(PlayerPedId())
    else
        if Config.ReviveEvent and Config.ReviveEvent ~= '' then
            TriggerEvent(Config.ReviveEvent)
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(REVIVE_RETRY_WAIT)
            if Config.ReviveEvent and Config.ReviveEvent ~= '' then
                TriggerEvent(Config.ReviveEvent)
            end
            if not inEvent then
                alreadyDead = false
                SetEntityInvincible(PlayerPedId(), false)
                return
            end
        end
    end

    Citizen.Wait(FREEZE_SETTLE_WAIT)
    if not inEvent then
        alreadyDead = false
        SetEntityInvincible(PlayerPedId(), false)
        return
    end

    TriggerEvent('es_admin:freezePlayer', true)
    TriggerEvent('mythic_progbar:client:progress', {
        name = 'unique_gungame_respawn',
        duration = RESPAWN_PROGRESS_MS,
        label = 'Respawning...',
        useWhileDead = true,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    })
    Citizen.Wait(RESPAWN_PROGRESS_MS)
    TriggerEvent('es_admin:freezePlayer', false)

    if inEvent then
        spawnIntoArena()
    end
    SetEntityInvincible(PlayerPedId(), false)
    alreadyDead = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if inEvent then
            local playerPed = PlayerPedId()
            if IsEntityDead(playerPed) and not alreadyDead then
                handleDeath(playerPed)
            end
        end
    end
end)

RegisterNetEvent('Unique_GunGame:LevelUp')
AddEventHandler('Unique_GunGame:LevelUp', function(weapon)
    RemoveAllPedWeapons(PlayerPedId(), true)
    Citizen.Wait(WEAPON_SWAP_WAIT)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(weapon), Config.WeaponAmmo, false, true)
    if Config.GiveParachuteOnSpawn then
        GiveWeaponToPed(PlayerPedId(), GetHashKey('gadget_parachute'), 1, false, false)
    end
end)

-- ============================================================
-- NUI relay: scoreboard / countdown / timer / kill feed
-- ============================================================

RegisterNetEvent('Unique_GunGame:UpdateScoreboard')
AddEventHandler('Unique_GunGame:UpdateScoreboard', function(board)
    SendNUIMessage({ action = 'updateScoreboard', players = board })
end)

RegisterNetEvent('Unique_GunGame:UpdateCountdown')
AddEventHandler('Unique_GunGame:UpdateCountdown', function(seconds)
    SendNUIMessage({ action = 'showCountdown', seconds = seconds, total = Config.CountdownTime })
end)

RegisterNetEvent('Unique_GunGame:UpdateTimer')
AddEventHandler('Unique_GunGame:UpdateTimer', function(seconds)
    SendNUIMessage({ action = 'showTimer', seconds = seconds })
end)

RegisterNetEvent('Unique_GunGame:KillFeed')
AddEventHandler('Unique_GunGame:KillFeed', function(killerName, victimName)
    SendNUIMessage({ action = 'addKillFeed', killer = killerName, victim = victimName })
end)

-- ============================================================
-- Cleanup on resource restart
-- ============================================================

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if inEvent then
        SetEntityInvincible(PlayerPedId(), false)
    end
    SendNUIMessage({ action = 'hideCountdown' })
    SendNUIMessage({ action = 'hideTimer' })
    SendNUIMessage({ action = 'hideScoreboard' })
end)
