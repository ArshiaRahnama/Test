-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.state = PB.state or {inMatch = false}
PB.HUD = PB.HUD or 'paintball-hud'

local bombState = {planted = false, site = nil, defusing = false, defuseStart = 0, plantingStart = 0, sites = nil, blips = {}}
local droppedBombProp = nil
local droppedBombBlip = nil
local droppedBombCoords = nil
local plantedBombProp = nil

local function clearBombBlips()
    for _, b in ipairs(bombState.blips or {}) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    bombState.blips = {}
end

local function createBombBlips(sites)
    clearBombBlips()
    if not sites then return end
    for i, s in ipairs(sites) do
        local blip = AddBlipForCoord(s.coords.x, s.coords.y, s.coords.z)
        SetBlipSprite(blip, 184)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.1)
        SetBlipColour(blip, bombState.planted and bombState.site == i and 1 or (i == 1 and 17 or 5))
        SetBlipAsShortRange(blip, false)
        SetBlipCategory(blip, 7)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Bomb Site '..(s.label or tostring(i)))
        EndTextCommandSetBlipName(blip)
        bombState.blips[#bombState.blips + 1] = blip
    end
end
local domState = {points = {}, captureProgress = nil}
local kothState = {hill = nil, presence = false, lastTeam = 0}
local escortState = {route = {}, current = 1, vipSrc = nil}

RegisterNetEvent('paintball:matchStart', function(payload)
    clearBombBlips()
    bombState = {planted = false, site = nil, defusing = false, sites = nil, blips = {}}
    domState = {points = {}, captureProgress = nil}
    kothState = {hill = nil, presence = false, lastTeam = 0}
    escortState = {route = {}, current = 1, vipSrc = nil}
    if payload.extra then
        if payload.extra.bombSites then
            bombState.sites = payload.extra.bombSites
            createBombBlips(payload.extra.bombSites)
        end
        if payload.extra.dominationPoints then
            domState.points = payload.extra.dominationPoints
        end
        if payload.extra.hill then
            kothState.hill = payload.extra.hill
        end
        if payload.extra.route then
            escortState.route = payload.extra.route
        end
        if payload.extra.vip then
            escortState.vipSrc = payload.extra.vip
        end
    end
end)

local function playKneelAnim(dict, anim, duration)
    local d = dict or 'anim@narcotic_finger_print'
    local a = anim or 'fp_b_to_idle'
    RequestAnimDict(d)
    local tries = 0
    while not HasAnimDictLoaded(d) and tries < 50 do Wait(50); tries = tries + 1 end
    if HasAnimDictLoaded(d) then
        TaskPlayAnim(SUN.ped, d, a, 4.0, -4.0, duration, 49, 0, false, false, false)
    end
end

local function stopBombAnim()
    ClearPedTasks(SUN.ped)
    local dicts = {'anim@narcotic_finger_print', 'anim@gangops@hostage@', 'mp_arresting'}
    for _, d in ipairs(dicts) do
        if HasAnimDictLoaded(d) then RemoveAnimDict(d) end
    end
end

local function spawnBombProp(coords)
    local hash = GetHashKey('prop_ld_bomb_01_s')
    if not IsModelInCdimage(hash) then hash = GetHashKey('hei_prop_heist_bomb') end
    if not IsModelInCdimage(hash) then hash = GetHashKey('prop_ld_bomb_01') end
    if not IsModelInCdimage(hash) then return nil end
    RequestModel(hash)
    local tries = 0
    while not HasModelLoaded(hash) and tries < 50 do Wait(50); tries = tries + 1 end
    if not HasModelLoaded(hash) then return nil end
    local prop = CreateObject(hash, coords.x, coords.y, coords.z, true, true, false)
    if prop and DoesEntityExist(prop) then
        PlaceObjectOnGroundProperly(prop)
        SetModelAsNoLongerNeeded(hash)
        return prop
    end
    return nil
end

local function doPlantBomb(idx)
    local cfg = paintballConfig.gameModes.bombplant
    local plantDur = (cfg.plantTime or 4) * 1000
    playKneelAnim('anim@narcotic_finger_print', 'fp_b_to_idle', plantDur + 500)
    local ok = lib.progressBar({duration = plantDur, label = 'پلنت بمب...', useWhileDead = false, canCancel = true, disable = {move = true, car = true, combat = true}})
    stopBombAnim()
    if ok then
        TriggerServerEvent('paintball:bombPlant', idx)
        PB.state.bombCarrier = false
    end
end

local function doDefuseBomb()
    local cfg = paintballConfig.gameModes.bombplant
    local defuseDur = (cfg.defuseTime or 7) * 1000
    TriggerServerEvent('paintball:bombDefuseStart')
    playKneelAnim('anim@narcotic_finger_print', 'fp_b_to_idle', defuseDur + 500)
    local ok = lib.progressBar({duration = defuseDur, label = 'دیفیوز بمب...', useWhileDead = false, canCancel = true, disable = {move = true, car = true, combat = true}})
    stopBombAnim()
    if ok then
        TriggerServerEvent('paintball:bombDefuseDone')
    else
        TriggerServerEvent('paintball:bombDefuseCancel')
    end
end

local function findNearestPlantSite()
    if not bombState.sites then return nil end
    local nearestIdx, nearestDist = nil, 999
    for i, s in ipairs(bombState.sites) do
        local d = #(SUN.PlayerCoords - s.coords)
        if d <= (s.radius or 3.5) and d < nearestDist then nearestIdx, nearestDist = i, d end
    end
    return nearestIdx
end

AddEventHandler('KeyDown:e', function()
    if not PB.state.inMatch or PB.state.mode ~= 'bombplant' or PB.state.spectator then return end
    if PB.state.bombCarrier and not bombState.planted then
        local idx = findNearestPlantSite()
        if idx then doPlantBomb(idx); return end
    end
    if bombState.planted and bombState.site and bombState.sites then
        local s = bombState.sites[bombState.site]
        if s then
            local d = #(SUN.PlayerCoords - s.coords)
            if d <= (s.radius or 3.5) then doDefuseBomb() end
        end
    end
end)

local bombplantRunning = false
local function startBombplant()
    if bombplantRunning then return end
    if PB.state.mode ~= 'bombplant' then return end
    bombplantRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            local sleep = 800
            if PB.state.inMatch and PB.state.mode == 'bombplant' and not PB.state.spectator then
                sleep = 150
                local sites = bombState.sites

                if PB.state.bombCarrier and not bombState.planted and sites then
                    local nearestIdx = findNearestPlantSite()
                    if nearestIdx then
                        sleep = 0
                        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = {site = sites[nearestIdx].label}})
                        if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                            doPlantBomb(nearestIdx)
                        end
                    else
                        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = nil})
                    end
                elseif bombState.planted and bombState.site and sites then
                    local s = sites[bombState.site]
                    if s then
                        local d = #(SUN.PlayerCoords - s.coords)
                        if d <= (s.radius or 3.5) then
                            sleep = 0
                            SUN.SendUIData(PB.HUD, {type = 'bombPromptDefuse', payload = {site = s.label}})
                            if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                                doDefuseBomb()
                            end
                        else
                            SUN.SendUIData(PB.HUD, {type = 'bombPromptDefuse', payload = nil})
                        end
                    end
                end

                if droppedBombCoords and not PB.state.bombCarrier then
                    local d = #(SUN.PlayerCoords - droppedBombCoords)
                    if d < 2.5 then
                        sleep = 0
                        SUN.SendUIData(PB.HUD, {type = 'bombPromptPlant', payload = {site = 'برداشتن بمب [E]'}})
                        if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) then
                            TriggerServerEvent('paintball:bombPickup')
                        end
                    end
                end

                if sites then
                    for i, s in ipairs(sites) do
                        local d = #(SUN.PlayerCoords - s.coords)
                        if d < 50.0 then
                            local r, g, b = 168, 85, 247
                            if bombState.planted and bombState.site == i then r, g, b = 255, 64, 96 end
                            DrawMarker(1, s.coords.x, s.coords.y, s.coords.z - 1.0, 0,0,0, 0,0,0, (s.radius or 3.5)*2, (s.radius or 3.5)*2, 1.0, r, g, b, 80, false, false, 2, false, false, false, false)
                            sleep = 0
                        end
                    end
                end
            end
            Wait(sleep)
        end
        bombplantRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startBombplant)

RegisterNetEvent('paintball:bombPlantedFx', function(coords)
    if plantedBombProp and DoesEntityExist(plantedBombProp) then DeleteEntity(plantedBombProp) end
    if coords then
        plantedBombProp = spawnBombProp(vector3(coords.x, coords.y, coords.z))
        CreateThread(function()
            while plantedBombProp and DoesEntityExist(plantedBombProp) and bombState.planted do
                local cd = GetEntityCoords(plantedBombProp)
                DrawMarker(28, cd.x, cd.y, cd.z + 0.5, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 50, 50, 200, false, true, 2, false, nil, nil, false)
                Wait(0)
            end
            if plantedBombProp and DoesEntityExist(plantedBombProp) then DeleteEntity(plantedBombProp) end
            plantedBombProp = nil
        end)
    end
end)

RegisterNetEvent('paintball:bombExplosionFx', function(coords)
    if plantedBombProp and DoesEntityExist(plantedBombProp) then DeleteEntity(plantedBombProp) end
    plantedBombProp = nil
    if not coords then return end
    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
    PlaySoundFromCoord(-1, 'EXPLOSION', coords.x, coords.y, coords.z, 'GTAO_FM_Events_Soundset', false, 0, false)
    CreateThread(function()
        for i = 1, 3 do
            AddExplosion(coords.x + math.random(-3, 3) + 0.0, coords.y + math.random(-3, 3) + 0.0, coords.z, 7, 0.8, true, false, 0.8)
            Wait(150)
        end
    end)
end)

RegisterNetEvent('paintball:bombDefusedFx', function(coords)
    if plantedBombProp and DoesEntityExist(plantedBombProp) then DeleteEntity(plantedBombProp) end
    plantedBombProp = nil
    if coords then
        PlaySoundFromCoord(-1, 'Beep_Red', coords.x, coords.y, coords.z, 'DLC_HEIST_HACKING_SNAKE_SOUNDS', false, 0, false)
    end
end)

local function clearDroppedBomb()
    if droppedBombProp and DoesEntityExist(droppedBombProp) then DeleteEntity(droppedBombProp) end
    if droppedBombBlip and DoesBlipExist(droppedBombBlip) then RemoveBlip(droppedBombBlip) end
    droppedBombProp = nil
    droppedBombBlip = nil
    droppedBombCoords = nil
end

RegisterNetEvent('paintball:bombDropRequest', function()
    local coords = GetEntityCoords(SUN.ped)
    local gOk, gZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 1.0, false)
    local dropZ = gOk and gZ or (coords.z - 0.9)
    PB.state.bombCarrier = false
    TriggerServerEvent('paintball:bombDropConfirm', {x = coords.x, y = coords.y, z = dropZ})
end)

RegisterNetEvent('paintball:bombCarrierUpdate', function(payload)
    payload = payload or {}
    clearDroppedBomb()
    if payload.droppedAt then
        droppedBombCoords = vector3(payload.droppedAt.x, payload.droppedAt.y, payload.droppedAt.z)
        droppedBombProp = spawnBombProp(droppedBombCoords)
        if droppedBombProp and DoesEntityExist(droppedBombProp) then
            droppedBombBlip = AddBlipForEntity(droppedBombProp)
            SetBlipSprite(droppedBombBlip, 568)
            SetBlipColour(droppedBombBlip, 1)
            SetBlipScale(droppedBombBlip, 1.0)
            SetBlipAsShortRange(droppedBombBlip, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('بمب افتاده')
            EndTextCommandSetBlipName(droppedBombBlip)
        end
    end
end)


RegisterNetEvent('paintball:bombBlastDamage', function(payload)
    if not payload then return end
    local px = GetEntityCoords(SUN.ped)
    local bp = vector3(payload.x, payload.y, payload.z)
    local d = #(px - bp)
    local radius = payload.radius or 12.0
    if d > radius then return end
    local damage = math.floor((1.0 - (d / radius)) * 200) + 50
    ApplyDamageToPed(SUN.ped, damage, true)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.0)
end)


local function teamColor(team)
    if team == 1 then return 251, 191, 36 end
    if team == 2 then return 96, 165, 250 end
    return 200, 200, 200
end

local dominationRunning = false
local function startDomination()
    if dominationRunning then return end
    if PB.state.mode ~= 'domination' then return end
    dominationRunning = true
    CreateThread(function()
        local lastPresenceSent = 0
        local lastPresenceVal = nil
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'domination' and domState.points then
                local isSpectator = PB.state.spectator
                local nearest, nearestDist = nil, 999
                local pc = SUN.PlayerCoords

                for i, pt in ipairs(domState.points) do
                    local d = #(pc - vector3(pt.coords.x, pt.coords.y, pt.coords.z))
                    if not isSpectator and d < 4.0 and d < nearestDist then
                        nearest, nearestDist = i, d
                    end
                    if d < 80.0 then
                        local colorTeam = (pt.captureTeam and pt.captureTeam > 0) and pt.captureTeam or (pt.owner or 0)
                        local r, g, b = teamColor(colorTeam)
                        local owned = (pt.owner or 0) > 0
                        local size = owned and 6.0 or 4.5
                        local h = owned and 2.5 or 1.5
                        local alpha = pt.contested and 220 or ((colorTeam > 0) and 150 or 90)
                        if pt.contested then r, g, b = 255, 80, 80 end
                        DrawMarker(1, pt.coords.x, pt.coords.y, pt.coords.z - 1.0, 0, 0, 0, 0, 0, 0, size, size, h, r, g, b, alpha, false, true, 2, false, nil, nil, false)
                        local pillarR, pillarG, pillarB = r, g, b
                        if owned then pillarR, pillarG, pillarB = math.min(255, r + 60), math.min(255, g + 60), math.min(255, b + 60) end
                        DrawMarker(21, pt.coords.x, pt.coords.y, pt.coords.z + (owned and 3.5 or 2.0), 0, 0, 0, 0, 0, 0, owned and 1.4 or 1.0, owned and 1.4 or 1.0, owned and 1.4 or 1.0, pillarR, pillarG, pillarB, 200, true, true, 2, false, nil, nil, false)
                        if pt.label and d < 50.0 then
                            SetTextScale(0.5, 0.5)
                            SetTextFont(4)
                            SetTextProportional(true)
                            SetTextColour(255, 255, 255, 255)
                            SetTextOutline()
                            SetTextEntry("STRING")
                            SetTextCentre(true)
                            AddTextComponentString(pt.label)
                            SetDrawOrigin(pt.coords.x, pt.coords.y, pt.coords.z + (owned and 5.0 or 3.5), 0)
                            DrawText(0.0, 0.0)
                            ClearDrawOrigin()
                        end
                    end
                end

                if not isSpectator then
                    local now = GetGameTimer()
                    if nearest ~= lastPresenceVal or (now - lastPresenceSent > 2000) then
                        lastPresenceVal = nearest
                        lastPresenceSent = now
                        TriggerServerEvent('paintball:domPresence', nearest)
                    end
                    if nearest then
                        local pt = domState.points[nearest]
                        SUN.SendUIData(PB.HUD, {type = 'domCapturing', payload = {point = nearest, label = pt.label, owner = pt.owner, contested = pt.contested, captureTeam = pt.captureTeam, captureProgress = pt.captureProgress, captureTime = domState.captureTime or 12, myTeam = PB.state.team}})
                    else
                        SUN.SendUIData(PB.HUD, {type = 'domCapturing', payload = nil})
                    end
                end

                Wait(0)
            else
                Wait(1000)
            end
        end
        dominationRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startDomination)

RegisterNetEvent('paintball:domState', function(st)
    if st then
        domState.points = st.points or {}
        if st.captureTime then domState.captureTime = st.captureTime end
    end
end)

local kothRunning = false
local function startKoth()
    if kothRunning then return end
    if PB.state.mode ~= 'koth' then return end
    kothRunning = true
    CreateThread(function()
        local lastPresenceSent = 0
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'koth' and kothState.hill then
                local hc = kothState.hill.coords
                local radius = kothState.hill.radius or 8.0
                local d = #(SUN.PlayerCoords - vector3(hc.x, hc.y, hc.z))

                if d < 100.0 then
                    local holder = kothState.holderTeam or 0
                    local r, g, b = teamColor(holder)
                    if kothState.contested then r, g, b = 255, 60, 60 end
                    DrawMarker(1, hc.x, hc.y, hc.z - 1.0, 0, 0, 0, 0, 0, 0, radius * 2, radius * 2, 1.5, r, g, b, 80, false, true, 2, false, nil, nil, false)
                    DrawMarker(28, hc.x, hc.y, hc.z + 3.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, r, g, b, 200, false, true, 2, false, nil, nil, false)
                end

                if not PB.state.spectator then
                    local inside = d <= radius
                    local now = GetGameTimer()
                    if inside then
                        if kothState.presence ~= 'inside' then
                            kothState.presence = 'inside'
                            lastPresenceSent = now
                            TriggerServerEvent('paintball:kothHolder', PB.state.team)
                            SUN.SendUIData(PB.HUD, {type = 'kothInside', payload = {inside = true}})
                        elseif now - lastPresenceSent > 2000 then
                            lastPresenceSent = now
                            TriggerServerEvent('paintball:kothHolder', PB.state.team)
                        end
                    else
                        if kothState.presence then
                            kothState.presence = nil
                            lastPresenceSent = now
                            TriggerServerEvent('paintball:kothHolder', 0)
                            SUN.SendUIData(PB.HUD, {type = 'kothInside', payload = {inside = false}})
                        end
                    end
                end

                Wait(0)
            else
                Wait(1000)
            end
        end
        kothRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startKoth)

RegisterNetEvent('paintball:kothUpdate', function(payload)
    if payload then
        kothState.holderTeam = payload.holderTeam
        kothState.contested = payload.contested
    end
end)

local infectedBuffs = nil
RegisterNetEvent('paintball:infectionApplyBuffs', function(payload)
    infectedBuffs = payload or {speed = 1.2, healthRegen = true}
end)

local juggernautBlip = nil
local juggernautSrcGlobal = nil
local jugSpeedMult = nil

local function clearJugBlip()
    if juggernautBlip and DoesBlipExist(juggernautBlip) then RemoveBlip(juggernautBlip) end
    juggernautBlip = nil
end

RegisterNetEvent('paintball:juggernautChange', function(payload)
    juggernautSrcGlobal = payload and payload.juggernaut or nil
    clearJugBlip()
    if juggernautSrcGlobal and juggernautSrcGlobal ~= GetPlayerServerId(SUN.PlayerId) then
        local pid = GetPlayerFromServerId(juggernautSrcGlobal)
        if pid ~= -1 then
            local ped = GetPlayerPed(pid)
            if DoesEntityExist(ped) then
                juggernautBlip = AddBlipForEntity(ped)
                SetBlipSprite(juggernautBlip, 303)
                SetBlipColour(juggernautBlip, 1)
                SetBlipScale(juggernautBlip, 1.3)
                SetBlipAsShortRange(juggernautBlip, false)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('JUGGERNAUT')
                EndTextCommandSetBlipName(juggernautBlip)
            end
        end
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'JUGGERNAUT جدید - بکشش!', duration = 4}})
    elseif juggernautSrcGlobal == GetPlayerServerId(SUN.PlayerId) then
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'تو الان JUGGERNAUT هستی!', duration = 4}})
    end
end)

RegisterNetEvent('paintball:juggernautApply', function(payload)
    jugSpeedMult = payload and payload.speed or 0.85
end)

RegisterNetEvent('paintball:juggernautClear', function()
    jugSpeedMult = nil
end)

local juggernautRunning = false
local function startJuggernaut()
    if juggernautRunning then return end
    if PB.state.mode ~= 'juggernaut' then return end
    juggernautRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'juggernaut' and jugSpeedMult then
                SetPedMoveRateOverride(SUN.ped, jugSpeedMult)
                Wait(500)
            else
                Wait(1500)
            end
        end
        juggernautRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startJuggernaut)

local infectedSlideActive = false
local infectionRunning = false
local function startInfection()
    if infectionRunning then return end
    if PB.state.mode ~= 'infection' then return end
    infectionRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'infection' and infectedBuffs and not PB.state.spectator then
                SetPedMoveRateOverride(SUN.ped, infectedBuffs.speed or 1.35)
                if infectedBuffs.superJump then
                    SetSuperJumpThisFrame(SUN.PlayerId)
                end
                if infectedBuffs.healthRegen then
                    local h = GetEntityHealth(SUN.ped)
                    local max = GetEntityMaxHealth(SUN.ped)
                    if h < max and h > 0 then
                        SetEntityHealth(SUN.ped, math.min(max, h + 3))
                    end
                end
                if infectedBuffs.slide and IsControlJustPressed(0, 36) and not infectedSlideActive and IsPedRunning(SUN.ped) then
                    infectedSlideActive = true
                    local fwd = GetEntityForwardVector(SUN.ped)
                    SetEntityVelocity(SUN.ped, fwd.x * 22.0, fwd.y * 22.0, GetEntityVelocity(SUN.ped).z)
                    RequestAnimDict('move_crouch_proto')
                    local tries = 0
                    while not HasAnimDictLoaded('move_crouch_proto') and tries < 20 do Wait(50); tries = tries + 1 end
                    if HasAnimDictLoaded('move_crouch_proto') then
                        TaskPlayAnim(SUN.ped, 'move_crouch_proto', 'idle_intro', 8.0, -8.0, 800, 51, 0, false, false, false)
                    end
                    SetTimeout(800, function() infectedSlideActive = false end)
                end
                Wait(0)
            else
                Wait(1500)
            end
        end
        infectionRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startInfection)

local escortCaptureProgress = 0
local escortCaptureRequired = 4000

local escortRunning = false
local function startEscort()
    if escortRunning then return end
    if PB.state.mode ~= 'escort' then return end
    escortRunning = true
    CreateThread(function()
        local lastCaptureTick = 0
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'escort' and escortState.route then
                local cp = escortState.route[escortState.current]
                if cp then
                    local cx = cp.x or cp[1]
                    local cy = cp.y or cp[2]
                    local cz = cp.z or cp[3]
                    local distCp = #(SUN.PlayerCoords - vector3(cx, cy, cz))
                    if distCp < 80.0 then
                        DrawMarker(1, cx, cy, cz - 1.0, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.5, 251, 191, 36, 80, false, true, 2, false, nil, nil, false)
                        DrawMarker(21, cx, cy, cz + 2.0, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 251, 191, 36, 200, true, true, 2, false, nil, nil, false)
                    end

                    local myServerId = GetPlayerServerId(SUN.PlayerId)
                    if not PB.state.spectator and escortState.vipSrc == myServerId then
                        local now = GetGameTimer()
                        if now - lastCaptureTick > 200 then
                            lastCaptureTick = now
                            local cpVec = vector3(cx, cy, cz)
                            local d = #(SUN.PlayerCoords - cpVec)
                            if d < 3.5 then
                                local enemyInside = false
                                local myTeam = PB.state.team or 0
                                if PB.iterateMatchPlayers then
                                    PB.iterateMatchPlayers(function(sid, team, pid, tp)
                                        if enemyInside then return end
                                        if team and team ~= myTeam and team > 0 then
                                            local ed = #(GetEntityCoords(tp) - cpVec)
                                            if ed < 5.0 then enemyInside = true end
                                        end
                                    end)
                                end
                                if enemyInside then
                                    if escortCaptureProgress > 0 then
                                        escortCaptureProgress = 0
                                        SUN.SendUIData(PB.HUD, {type = 'escortCapture', payload = {progress = 0, contested = true}})
                                    end
                                else
                                    escortCaptureProgress = math.min(escortCaptureRequired, escortCaptureProgress + 200)
                                    local pct = math.floor((escortCaptureProgress / escortCaptureRequired) * 100)
                                    SUN.SendUIData(PB.HUD, {type = 'escortCapture', payload = {progress = pct, contested = false}})
                                    if escortCaptureProgress >= escortCaptureRequired then
                                        escortCaptureProgress = 0
                                        TriggerServerEvent('paintball:escortReachedCheckpoint', escortState.current)
                                        SUN.SendUIData(PB.HUD, {type = 'escortCapture', payload = nil})
                                    end
                                end
                            else
                                if escortCaptureProgress > 0 then
                                    escortCaptureProgress = 0
                                    SUN.SendUIData(PB.HUD, {type = 'escortCapture', payload = nil})
                                end
                            end
                        end
                    end
                end
                Wait(0)
            else
                if escortCaptureProgress > 0 then escortCaptureProgress = 0 end
                Wait(1000)
            end
        end
        escortRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startEscort)

RegisterNetEvent('paintball:roundUpdate', function(info)
    if info.bomb then
        local wasPlanted = bombState.planted
        bombState.planted = info.bomb.planted
        bombState.site = info.bomb.site
        bombState.defusing = info.bomb.defusing
        if bombState.planted ~= wasPlanted and bombState.sites then
            createBombBlips(bombState.sites)
        end
    end
end)


AddEventHandler('paintball:cleanup', function() clearBombBlips() end)
RegisterNetEvent('paintball:matchEnd', function() clearBombBlips() end)
AddEventHandler('onResourceStop', function(rn) if GetCurrentResourceName() == rn then clearBombBlips() end end)

local escortVipBlip = nil
local escortCheckpointBlip = nil

local function clearEscortBlips()
    if escortVipBlip and DoesBlipExist(escortVipBlip) then RemoveBlip(escortVipBlip) end
    if escortCheckpointBlip and DoesBlipExist(escortCheckpointBlip) then RemoveBlip(escortCheckpointBlip) end
    escortVipBlip = nil
    escortCheckpointBlip = nil
end

local function refreshEscortBlips()
    clearEscortBlips()
    if not escortState.route then return end
    if escortState.vipSrc and escortState.vipSrc ~= GetPlayerServerId(SUN.PlayerId) then
        local pid = GetPlayerFromServerId(escortState.vipSrc)
        if pid ~= -1 then
            local ped = GetPlayerPed(pid)
            if DoesEntityExist(ped) then
                escortVipBlip = AddBlipForEntity(ped)
                SetBlipSprite(escortVipBlip, 480)
                SetBlipColour(escortVipBlip, 5)
                SetBlipScale(escortVipBlip, 1.1)
                SetBlipAsShortRange(escortVipBlip, false)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('VIP')
                EndTextCommandSetBlipName(escortVipBlip)
            end
        end
    end
    local cp = escortState.route[escortState.current]
    if cp then
        escortCheckpointBlip = AddBlipForCoord(cp.x or cp[1], cp.y or cp[2], cp.z or cp[3])
        SetBlipSprite(escortCheckpointBlip, 38)
        SetBlipColour(escortCheckpointBlip, 5)
        SetBlipScale(escortCheckpointBlip, 1.3)
        SetBlipRoute(escortCheckpointBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('چک‌پوینت ' .. tostring(escortState.current))
        EndTextCommandSetBlipName(escortCheckpointBlip)
    end
end

RegisterNetEvent('paintball:escortAdvance', function(info)
    escortState.current = info.current
    escortState.route = info.route or escortState.route
    refreshEscortBlips()
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'چک‌پوینت ' .. tostring(info.current - 1) .. ' رد شد', duration = 3}})
end)

RegisterNetEvent('paintball:escortVipChange', function(info)
    escortState.vipSrc = info.vip
    refreshEscortBlips()
end)


AddEventHandler('paintball:cleanup', function() clearEscortBlips() end)

local aimTargets = {}
local aimSettings = {targetCount = 20, targetLifetime = 4, targetRespawn = 1}

local function clearAimTargets()
    for _, t in ipairs(aimTargets) do
        if t.entity and DoesEntityExist(t.entity) then DeleteEntity(t.entity) end
    end
    aimTargets = {}
end

local function pickAimSpawn()
    local map = paintballConfig.maps[PB.state.map] or paintballConfig.coopMaps[PB.state.map]
    local center = (map and map.center) or vector3(GetEntityCoords(SUN.ped))
    local angle = math.random() * math.pi * 2
    local dist = 8.0 + math.random() * 22.0
    local x = center.x + math.cos(angle) * dist
    local y = center.y + math.sin(angle) * dist
    local gOk, gZ = GetGroundZFor_3dCoord(x, y, center.z + 30.0, false)
    local z = gOk and (gZ + 0.9 + math.random() * 0.8) or (center.z + 1.3)
    return vector3(x, y, z)
end

local function spawnAimTarget()
    local pos = pickAimSpawn()
    local modelHash = GetHashKey('prop_target_dummy')
    if not IsModelInCdimage(modelHash) then modelHash = GetHashKey('prop_offdoc_chair_01') end
    if not IsModelInCdimage(modelHash) then modelHash = GetHashKey('prop_barrel_01a') end
    RequestModel(modelHash)
    local tries = 0
    while not HasModelLoaded(modelHash) and tries < 50 do Wait(50); tries = tries + 1 end
    if not HasModelLoaded(modelHash) then return nil end
    local prop = CreateObject(modelHash, pos.x, pos.y, pos.z, true, true, false)
    if not prop or not DoesEntityExist(prop) then return nil end
    SetEntityHasGravity(prop, false)
    FreezeEntityPosition(prop, true)
    SetEntityCollision(prop, true, true)
    SetEntityHealth(prop, 200)
    SetEntityMaxHealth(prop, 200)
    SetEntityInvincible(prop, false)
    SetEntityCanBeDamaged(prop, true)
    local blip = AddBlipForEntity(prop)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, false)
    SetModelAsNoLongerNeeded(modelHash)
    return {entity = prop, blip = blip, spawnedAt = GetGameTimer(), pos = pos, headshotZ = pos.z + 0.4}
end

RegisterNetEvent('paintball:aimScore', function(payload)
    SUN.SendUIData(PB.HUD, {type = 'aimScore', payload = payload})
    if payload and payload.headshot then
        SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'HEADSHOT +2', duration = 1.2}})
    end
end)

RegisterNetEvent('paintball:matchStart', function(info)
    if info and info.aim then
        aimSettings.targetCount = info.targetCount or 20
        aimSettings.targetLifetime = info.targetLifetime or 4
        aimSettings.targetRespawn = info.targetRespawn or 1
        clearAimTargets()
        CreateThread(function()
            Wait(2000)
            for i = 1, aimSettings.targetCount do
                local t = spawnAimTarget()
                if t then aimTargets[#aimTargets + 1] = t end
                Wait(120)
            end
        end)
    end
end)

local aimtrainerRunning = false
local function startAimtrainer()
    if aimtrainerRunning then return end
    if PB.state.mode ~= 'aimtrainer' then return end
    aimtrainerRunning = true
    CreateThread(function()
        local lastTargetCheck = 0
        local lastShotSent = 0
        while PB.state.inMatch do
            if PB.state.inMatch and PB.state.mode == 'aimtrainer' then
                local now = GetGameTimer()

                if not PB.state.spectator and IsPedShooting(SUN.ped) and (now - lastShotSent > 150) then
                    lastShotSent = now
                    TriggerServerEvent('paintball:aimShot')
                end

                if #aimTargets > 0 and (now - lastTargetCheck > 150) then
                    lastTargetCheck = now
                    for i = #aimTargets, 1, -1 do
                        local t = aimTargets[i]
                        if not DoesEntityExist(t.entity) or IsEntityDead(t.entity) or GetEntityHealth(t.entity) < 100 then
                            if not t.reported then
                                t.reported = true
                                local aim = GetPedLastWeaponImpactCoord(SUN.ped)
                                local hs = false
                                if aim and aim.x ~= 0 then
                                    local d = #(aim - t.pos)
                                    if d < 1.2 and aim.z > t.headshotZ then hs = true end
                                end
                                TriggerServerEvent('paintball:aimHit', i, hs)
                            end
                            if t.blip and DoesBlipExist(t.blip) then RemoveBlip(t.blip) end
                            if DoesEntityExist(t.entity) then DeleteEntity(t.entity) end
                            table.remove(aimTargets, i)
                            SetTimeout((aimSettings.targetRespawn or 1) * 1000, function()
                                if PB.state.inMatch and PB.state.mode == 'aimtrainer' then
                                    local nt = spawnAimTarget()
                                    if nt then aimTargets[#aimTargets + 1] = nt end
                                end
                            end)
                        elseif aimSettings.targetLifetime and (now - t.spawnedAt) > aimSettings.targetLifetime * 1000 then
                            if t.blip and DoesBlipExist(t.blip) then RemoveBlip(t.blip) end
                            if DoesEntityExist(t.entity) then DeleteEntity(t.entity) end
                            table.remove(aimTargets, i)
                            SetTimeout(300, function()
                                if PB.state.inMatch and PB.state.mode == 'aimtrainer' then
                                    local nt = spawnAimTarget()
                                    if nt then aimTargets[#aimTargets + 1] = nt end
                                end
                            end)
                        end
                    end
                end

                Wait(0)
            else
                if #aimTargets > 0 then clearAimTargets() end
                Wait(1500)
            end
        end
        aimtrainerRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startAimtrainer)

AddEventHandler('paintball:cleanup', function() clearAimTargets() end)
RegisterNetEvent('paintball:matchEnd', function() clearAimTargets() end)

RegisterNetEvent('paintball:infectionSwitched', function()
    ESX.notification('warning', 'shoma alude shodid! be doshmana hojom kon')
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'تو زامبی شدی - بکش بقیه رو', duration = 4}})
    RemoveAllPedWeapons(SUN.ped, false)
    GiveWeaponToPed(SUN.ped, `WEAPON_KNIFE`, 1, false, true)
end)
