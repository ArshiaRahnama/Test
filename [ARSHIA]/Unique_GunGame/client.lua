--[[
    Unique_GunGame - client logic

    Handles everything for the local player once the server places them into an
    arena: the scripted-camera intro, death/respawn loop, kill reporting, and
    relaying server events into NUI messages for the HUD.

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

local CAM_PAN_WAIT = 3000       -- ms the scripted camera holds before teleporting the player
local CAM_SETTLE_WAIT = 2000    -- ms to hold position after teleport before releasing the camera
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

local function teleportWithCam(coords, invincibleDuring)
    if invincibleDuring then SetEntityInvincible(PlayerPedId(), true) end

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
    SetCamCoord(cam, coords.x + 1.5, coords.y - 5.0, coords.z + 2.0)
    SetCamActive(cam, true)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
    RenderScriptCams(true, true, 1000, true, false)
    Citizen.Wait(CAM_PAN_WAIT)

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 3.0)
    RemoveAllPedWeapons(PlayerPedId(), true)
    Citizen.Wait(CAM_SETTLE_WAIT)

    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)

    if invincibleDuring then SetEntityInvincible(PlayerPedId(), false) end
end

local function applyEventOutfit()
    if not Config.ChangeOutfitOnJoin then return end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local outfit = (skin.sex == 0) and Config.OutfitMale or Config.OutfitFemale
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
    end)
end

local function spawnIntoArena()
    if Config.GiveParachuteOnSpawn then
        TriggerServerEvent('Unique_GunGame:GiveParachute', GetPlayerServerId(PlayerId()))
    end
    RemoveAllPedWeapons(PlayerPedId(), true)
    teleportWithCam(currentLocationSet.Arena, true)
    TriggerEvent('esx:addWeapon', Config.Weapons[1], Config.WeaponAmmo)
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
    teleportWithCam(currentLocationSet.Lobby, true)
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
    SetEntityCoords(PlayerPedId(), exitLoc.x + math.random(-10, 10), exitLoc.y + math.random(-10, 10), exitLoc.z + 2.0)

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

    TriggerEvent('esx_ambulancejob:revive')
    while ESX.GetPlayerData().IsDead do
        Citizen.Wait(REVIVE_RETRY_WAIT)
        TriggerEvent('esx_ambulancejob:revive')
        if not inEvent then
            alreadyDead = false
            SetEntityInvincible(PlayerPedId(), false)
            return
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
    TriggerEvent('esx:addWeapon', weapon, Config.WeaponAmmo)
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
    SendNUIMessage({ action = 'showCountdown', seconds = seconds })
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
