--[[
    Unique_GunGame - client logic

    Handles everything for the local player once the server places them into an
    arena: the scripted-camera spawn intro, death/respawn loop (waiting on your
    server's own revive flow), kill reporting, arena leash, player blips, the
    winner MVP screen, and relaying server events into NUI messages for the HUD.

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
local LEASH_CHECK_MS = 1000     -- how often to check the arena-leash distance
local FIREWORKS_ASSET_WAIT_MS = 2000 -- safety cap while waiting for the firework particle asset to load

-- ============================================================
-- Runtime state
-- ============================================================

local inEvent = false
local alreadyDead = false
local currentLocationSet = nil -- the {Lobby, ArenaPoints, Center, Exit} set for the arena this player is currently in
local matchBlips = {}          -- blips currently shown for other players in this arena

-- ============================================================
-- Helpers
-- ============================================================

local function teleportWithCam(coords)
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
end

local function applyEventOutfit()
    if not Config.ChangeOutfitOnJoin then return end
    TriggerEvent('skinchanger:getSkin', function(skin)
        local outfit = (skin.sex == 0) and Config.OutfitMale or Config.OutfitFemale
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
    end)
end

-- Picks a random point from the current arena's ArenaPoints list, so a fight
-- doesn't always start/restart from the exact same corner.
local function pickArenaPoint()
    local points = currentLocationSet.ArenaPoints
    if not points or #points == 0 then
        return currentLocationSet.Center
    end
    return points[math.random(#points)]
end

local function spawnIntoArena()
    if Config.GiveParachuteOnSpawn then
        TriggerServerEvent('Unique_GunGame:GiveParachute', GetPlayerServerId(PlayerId()))
    end
    RemoveAllPedWeapons(PlayerPedId(), true)
    teleportWithCam(pickArenaPoint())
    GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.Weapons[1]), Config.WeaponAmmo, false, true)

    if Config.Sounds and Config.Sounds.MatchStart then
        SendNUIMessage({ action = 'playSound', sound = Config.Sounds.MatchStart, volume = Config.SoundVolume })
    end
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

local function clearMatchBlips()
    for _, blip in ipairs(matchBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    matchBlips = {}
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
    teleportWithCam(currentLocationSet.Lobby)
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
    clearMatchBlips()

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

    local killerServerId = findKillerServerId(GetPedKiller(playerPed), playerPed)
    if killerServerId ~= 0 then
        TriggerServerEvent('Unique_GunGame:ReportKill', killerServerId, GetPlayerName(PlayerId()))
    end
    TriggerServerEvent('Unique_GunGame:PlayerDied')

    Citizen.Wait(RESPAWN_DELAY)
    if not inEvent then
        alreadyDead = false
        SetEntityInvincible(PlayerPedId(), false)
        return
    end

    if Config.ReviveEvent and Config.ReviveEvent ~= '' then
        TriggerEvent(Config.ReviveEvent)
    end
    while ESX.GetPlayerData().IsDead do
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
        TriggerServerEvent('Unique_GunGame:GiveParachute', GetPlayerServerId(PlayerId()))
    end
end)

-- ============================================================
-- Arena leash
-- ============================================================
-- Keeps players from wandering (or driving) away from the fight instead of
-- actually playing. Pulls them back to a random arena point if they stray too far.

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(LEASH_CHECK_MS)
        if inEvent and Config.ArenaLeashRadius and Config.ArenaLeashRadius > 0 and currentLocationSet then
            local center = currentLocationSet.Center
            local ped = PlayerPedId()
            local dist = #(GetEntityCoords(ped) - vector3(center.x, center.y, center.z))
            if dist > Config.ArenaLeashRadius then
                local point = pickArenaPoint()
                SetEntityCoords(ped, point.x, point.y, point.z + 1.0, false, false, false, true)
            end
        end
    end
end)

-- ============================================================
-- Player blips
-- ============================================================
-- Shows a blip for every other player currently in this arena (the roster the
-- server sends is scoped to this match only, so other concurrent arenas never
-- show up here).

RegisterNetEvent('Unique_GunGame:UpdateRoster')
AddEventHandler('Unique_GunGame:UpdateRoster', function(roster)
    clearMatchBlips()
    if not Config.ShowPlayerBlips then return end

    local myServerId = GetPlayerServerId(PlayerId())
    for _, entry in ipairs(roster) do
        if entry.source ~= myServerId then
            local targetIndex = GetPlayerFromServerId(entry.source)
            if targetIndex ~= -1 then
                local targetPed = GetPlayerPed(targetIndex)
                local blip = AddBlipForEntity(targetPed)
                SetBlipSprite(blip, Config.PlayerBlipSprite)
                SetBlipColour(blip, Config.PlayerBlipColor)
                SetBlipScale(blip, 0.8)
                SetBlipAsShortRange(blip, false)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(entry.name)
                EndTextCommandSetBlipName(blip)
                matchBlips[#matchBlips + 1] = blip
            end
        end
    end
end)

-- ============================================================
-- Winner MVP screen
-- ============================================================

RegisterNetEvent('Unique_GunGame:ShowMVP')
AddEventHandler('Unique_GunGame:ShowMVP', function(winnerName, winnerKills, winnerServerId)
    local isMe = winnerServerId == GetPlayerServerId(PlayerId())
    local card = (Config.CallingCards and #Config.CallingCards > 0)
        and Config.CallingCards[math.random(#Config.CallingCards)]
        or nil

    SendNUIMessage({ action = 'showMVP', name = winnerName, kills = winnerKills, isYou = isMe, card = card })

    if Config.Sounds and Config.Sounds.MatchWin then
        SendNUIMessage({ action = 'playSound', sound = Config.Sounds.MatchWin, volume = Config.SoundVolume })
    end

    if Config.WinnerFireworks then
        Citizen.CreateThread(function()
            local winnerIndex = GetPlayerFromServerId(winnerServerId)
            local fxCoords = (winnerIndex ~= -1) and GetEntityCoords(GetPlayerPed(winnerIndex)) or GetEntityCoords(PlayerPedId())

            RequestNamedPtfxAsset('scr_indep_fireworks')
            local waited = 0
            while not HasNamedPtfxAssetLoaded('scr_indep_fireworks') and waited < FIREWORKS_ASSET_WAIT_MS do
                Citizen.Wait(50)
                waited = waited + 50
            end
            if HasNamedPtfxAssetLoaded('scr_indep_fireworks') then
                UseParticleFxAssetNextCall('scr_indep_fireworks')
                StartParticleFxNonLoopedAtCoord('scr_indep_firework_finale', fxCoords.x, fxCoords.y, fxCoords.z + 3.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
            end
        end)
    end

    Citizen.SetTimeout(Config.WinnerCameraSeconds * 1000, function()
        SendNUIMessage({ action = 'hideMVP' })
    end)
end)

-- ============================================================
-- Physical join point (optional)
-- ============================================================

if Config.JoinPed and Config.JoinPed.Enabled then
    Citizen.CreateThread(function()
        local modelHash = GetHashKey(Config.JoinPed.Model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Citizen.Wait(50) end

        local c = Config.JoinPed.Coords
        local ped = CreatePed(4, modelHash, c.x, c.y, c.z - 1.0, c.heading or 0.0, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(modelHash)

        while true do
            Citizen.Wait(0)
            local dist = #(GetEntityCoords(PlayerPedId()) - vector3(c.x, c.y, c.z))
            if dist < Config.JoinPed.MarkerDistance then
                DrawMarker(2, c.x, c.y, c.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 140, 0, 180, false, true, 2, false, nil, nil, false)

                if dist < Config.JoinPed.InteractDistance then
                    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(c.x, c.y, c.z + 1.0)
                    if onScreen then
                        SetTextScale(0.35, 0.35)
                        SetTextFont(4)
                        SetTextColour(255, 255, 255, 215)
                        SetTextEntry('STRING')
                        AddTextComponentString('~y~E~w~ - ' .. Config.JoinPed.Label)
                        SetTextCentre(true)
                        DrawText(sx, sy)
                    end

                    if IsControlJustReleased(0, 38) then -- E
                        ExecuteCommand(Config.JoinCommand)
                    end
                end
            else
                Citizen.Wait(400) -- far away, no need to check every frame
            end
        end
    end)
end

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

RegisterNetEvent('Unique_GunGame:PlaySound')
AddEventHandler('Unique_GunGame:PlaySound', function(sound)
    SendNUIMessage({ action = 'playSound', sound = sound, volume = Config.SoundVolume })
end)

-- ============================================================
-- Cleanup on resource restart
-- ============================================================

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if inEvent then
        SetEntityInvincible(PlayerPedId(), false)
    end
    clearMatchBlips()
    SendNUIMessage({ action = 'hideCountdown' })
    SendNUIMessage({ action = 'hideTimer' })
    SendNUIMessage({ action = 'hideScoreboard' })
    SendNUIMessage({ action = 'hideMVP' })
end)
