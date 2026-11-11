
local spawnPoints = {}

local autoSpawnEnabled = false
local autoSpawnCallback

AddEventHandler('getMapDirectives', function(add)

    add('spawnpoint', function(state, model)

        return function(opts)
            local x, y, z, heading

            local s, e = pcall(function()

                if opts.x then
                    x = opts.x
                    y = opts.y
                    z = opts.z
                else
                    x = opts[1]
                    y = opts[2]
                    z = opts[3]
                end

                x = x + 0.0001
                y = y + 0.0001
                z = z + 0.0001


                heading = opts.heading and (opts.heading + 0.01) or 0


                addSpawnPoint({
                    x = x, y = y, z = z,
                    heading = heading,
                    model = model
                })


                if not tonumber(model) then
                    model = GetHashKey(model, _r)
                end


                state.add('xyz', { x, y, z })
                state.add('model', model)
            end)

            if not s then
                Citizen.Trace(e .. "\n")
            end
        end

    end, function(state, arg)

        for i, sp in ipairs(spawnPoints) do

            if sp.x == state.xyz[1] and sp.y == state.xyz[2] and sp.z == state.xyz[3] and sp.model == state.model then

                table.remove(spawnPoints, i)
                return
            end
        end
    end)
end)

function loadSpawns(spawnString)

    local data = json.decode(spawnString)


    if not data.spawns then
        error("no 'spawns' in JSON data")
    end


    for i, spawn in ipairs(data.spawns) do

        addSpawnPoint(spawn)
    end
end

local spawnNum = 1

function addSpawnPoint(spawn)

    if not tonumber(spawn.x) or not tonumber(spawn.y) or not tonumber(spawn.z) then
        error("invalid spawn position")
    end


    if not tonumber(spawn.heading) then
        error("invalid spawn heading")
    end


    local model = spawn.model

    if not tonumber(spawn.model) then
        model = GetHashKey(spawn.model)
    end


    if not IsModelInCdimage(model) then
        error("invalid spawn model")
    end






    spawn.model = model


    spawn.idx = spawnNum
    spawnNum = spawnNum + 1


    table.insert(spawnPoints, spawn)

    return spawn.idx
end

function removeSpawnPoint(spawn)
    for i = 1, #spawnPoints do
        if spawnPoints[i].idx == spawn then
            table.remove(spawnPoints, i)
            return
        end
    end
end

function setAutoSpawn(enabled)
    autoSpawnEnabled = enabled
end

function setAutoSpawnCallback(cb)
    autoSpawnCallback = cb
    autoSpawnEnabled = true
end

-- Set the convar `spawnmanager_fade 1` to bring back the black fade-out/fade-in
-- around every spawn. Default (0) = no fade-out, like the sun server. A fade-in is
-- ALWAYS done when the screen happens to be faded out, so it can never stay black.
local function useFade()
    return GetConvarInt('spawnmanager_fade', 0) == 1
end

local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)

        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)

        SetPlayerInvincible(player, true)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

function loadScene(x, y, z)
    NewLoadSceneStart(x, y, z, 0.0, 0.0, 0.0, 20.0, 0)

    local timeout = GetGameTimer() + 5000

    while IsNewLoadSceneActive() and GetGameTimer() < timeout do
        NetworkUpdateLoadScene()
        Citizen.Wait(0)
    end
end

-- exported in fxmanifest but never defined before
function getRandomSpawnPoint()
    if #spawnPoints == 0 then
        return nil
    end

    return spawnPoints[GetRandomIntInRange(1, #spawnPoints + 1)]
end

local spawnLock = false

-- the actual spawn; runs inside pcall so an error can never leave the player
-- frozen/invisible/invincible or the spawn lock stuck
local function doSpawn(spawnIdx, cb)
    if not spawnIdx then
        if #spawnPoints == 0 then
            Citizen.Trace("tried to spawn but there are no spawn points\n")
            return
        end

        spawnIdx = GetRandomIntInRange(1, #spawnPoints + 1)
    end

    local spawn

    if type(spawnIdx) == 'table' then
        spawn = spawnIdx
    else
        spawn = spawnPoints[spawnIdx]
    end

    if not spawn then
        Citizen.Trace("tried to spawn at an invalid spawn index\n")
        return
    end

    if useFade() and not spawn.skipFade then
        DoScreenFadeOut(500)

        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
    end

    freezePlayer(PlayerId(), true)

    if spawn.model then
        if IsModelInCdimage(spawn.model) and IsModelValid(spawn.model) then
            RequestModel(spawn.model)

            local timeout = GetGameTimer() + 10000

            while not HasModelLoaded(spawn.model) and GetGameTimer() < timeout do
                RequestModel(spawn.model)

                Citizen.Wait(0)
            end

            if HasModelLoaded(spawn.model) then
                SetPlayerModel(PlayerId(), spawn.model)
            else
                Citizen.Trace("spawn model failed to load, keeping the current model\n")
            end

            SetModelAsNoLongerNeeded(spawn.model)
        else
            Citizen.Trace("spawn model is not a valid model, keeping the current model\n")
        end
    end

    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

    -- the ped handle changes with the model: fetch it after SetPlayerModel
    local ped = PlayerPedId()

    SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

    NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)

    ClearPedTasksImmediately(ped)

    RemoveAllPedWeapons(ped)
    ClearPlayerWantedLevel(PlayerId())

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreen()

    -- never leave the screen black (also covers the very first spawn)
    if IsScreenFadedOut() then
        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end

    freezePlayer(PlayerId(), false)

    TriggerEvent('playerSpawned', spawn)

    if cb then
        cb(spawn)
    end
end

function spawnPlayer(spawnIdx, cb)
    if spawnLock then
        return
    end

    spawnLock = true

    Citizen.CreateThread(function()
        local ok, err = pcall(doSpawn, spawnIdx, cb)

        if not ok then
            Citizen.Trace("spawnmanager: spawn failed: " .. tostring(err) .. "\n")

            -- undo freezePlayer(true) so the player can move again
            freezePlayer(PlayerId(), false)

            if IsScreenFadedOut() then
                DoScreenFadeIn(500)
            end
        end

        spawnLock = false
    end)
end

local respawnForced
local diedAt

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(50)

        local playerPed = PlayerPedId()

        if playerPed and playerPed ~= -1 then

            if autoSpawnEnabled then
                if NetworkIsPlayerActive(PlayerId()) then
                    if (diedAt and (GetTimeDifference(GetGameTimer(), diedAt) > 2000)) or respawnForced then
                        if autoSpawnCallback then
                            autoSpawnCallback()
                        else
                            spawnPlayer()
                        end

                        respawnForced = false
                        -- death handled: a stale timestamp must not trigger a second respawn
                        -- (if the player is still dead it is set again on the next pass)
                        diedAt = nil
                    end
                end
            end

            if IsEntityDead(playerPed) then
                if not diedAt then
                    diedAt = GetGameTimer()
                end
            else
                diedAt = nil
            end
        end
    end
end)

function forceRespawn()
    spawnLock = false
    respawnForced = true
end
