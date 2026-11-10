-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local MODULE_NAME = 'paintball'
PB = PB or {}
PB.MODULE = MODULE_NAME
PB.HUD = MODULE_NAME .. '-hud'
PB.ATTACH = MODULE_NAME .. '-attach'
PB.SCORE = MODULE_NAME .. '-score'

PB.flags = {}
PB.state = {
    inMatch = false,
    inLobby = false,
    matchId = nil,
    mode = nil,
    map = nil,
    team = 0,
    spectator = false,
    weapon = nil,
    spawnInvincible = false,
    perks = {},
    activePerk = nil,
    selectedAttachments = {},
    bombCarrier = false,
    coopMoney = 0,
    coopWave = 0,
}

PB.lasthp = 0
PB.lastArmor = 0
PB.matchData = nil
PB.playerHp = {}
PB.markercoords = nil
PB.zoneRadius = 150.0
PB.timer = 0
PB.shrinking = false
PB.lastCoords = nil

function PB.requestFlags()
    ESX.TriggerServerCallback('paintball:getFeatureFlags', function(flags)
        PB.flags = flags or {}
    end)
end

CreateThread(function()
    waitForLoad(1000)
    PB.requestFlags()
end)

RegisterNetEvent('paintball:cleanup', function()
    PB.exitMatch()
end)

RegisterCommand('clearfx', function()
    if PB.cancelActivePerks then PB.cancelActivePerks() end
    AnimpostfxStopAll()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    StopGameplayCamShaking(true)
    SetSeethrough(false)
    SetNightvision(false)
    SetPlayerWeaponDamageModifier(SUN.PlayerId, 1.0)
    SetRunSprintMultiplierForPlayer(SUN.PlayerId, 1.0)
    SetPlayerStealthMultiplier(SUN.PlayerId, 1.0)
    SetPlayerNoiseMultiplier(SUN.PlayerId, 1.0)
    pcall(function() SetPedAudioFootstepLoud(SUN.ped, true) end)
    pcall(function() SetPedAudioFootstepQuiet(SUN.ped, false) end)
    TriggerEvent('core:applyScreenEffect', 'hud_def_desat_Trevor', 0, 10)
    TriggerEvent('core:applyScreenEffect', 'REDMIST_blend', 0, 10)
    TriggerEvent('core:applyScreenEffect', 'REDMIST', 0, 10)
    TriggerEvent('core:applyScreenEffect', 'ChopVision', 0, 10)
    SetEntityInvincible(SUN.ped, false)
    if ESX and ESX.notification then ESX.notification('success', 'افکت‌ها پاک شد') end
end)

RegisterNetEvent('paintball:teamMap', function(map)
    PB.state.matchTeams = {}
    if map then
        for sid, team in pairs(map) do
            PB.state.matchTeams[tonumber(sid)] = team
        end
    end
end)

local PB_BLOCKED_KEYS = {'f2', 'f5', 'f6', 'lmenu'}

function PB.setMatchKeysBlocked(blocked)
    if not exports['essentialmode'] or not exports['essentialmode'].disablecontrol then return end
    for _, key in ipairs(PB_BLOCKED_KEYS) do
        exports['essentialmode']:disablecontrol(key, blocked and true or false)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PB.setMatchKeysBlocked(false)
    end
end)

function PB.iterateMatchPlayers(cb)
    if not PB.state.matchTeams then return end
    local mySid = GetPlayerServerId(SUN.PlayerId)
    for sid, team in pairs(PB.state.matchTeams) do
        if sid ~= mySid then
            local pid = GetPlayerFromServerId(sid)
            if pid ~= -1 then
                local ped = GetPlayerPed(pid)
                if ped and ped ~= 0 and DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                    cb(sid, team, pid, ped)
                end
            end
        end
    end
end

function PB.exitMatch()
    PB.state.inMatch = false
    PB.state.starting = false
    PB.state.matchId = nil
    PB.state.mode = nil
    PB.state.map = nil
    PB.state.team = 0
    PB.state.spectator = false
    PB.state.weapon = nil
    PB.state.bombCarrier = false
    PB.state.coopMoney = 0
    PB.state.coopWave = 0
    PB.state.matchSpectating = false
    PB.timer = 0
    PB.shrinking = false
    PB.markercoords = nil
    if PB.clearZoneFx then PB.clearZoneFx() end
    if PB.matchSpectate then
        PB.matchSpectate.active = false
        PB.matchSpectate.teammates = {}
        PB.matchSpectate.currentTarget = nil
        PB.matchSpectate.currentPid = nil
    end
    if PB.cancelActivePerks then PB.cancelActivePerks() end
    NetworkSetInSpectatorMode(false, 0)
    local ped = SUN.ped
    if ped and ped ~= 0 then
        SetEntityInvincible(SUN.PlayerId, false)
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
    end
    SUN.CloseUI(PB.HUD)
    SUN.CloseUI(PB.ATTACH)
    SUN.CloseUI(PB.SCORE)
    TriggerEvent('inPaintball', false)
    PB.setMatchKeysBlocked(false)
    TriggerEvent('safezone:active', true)
    TriggerEvent('esx:stateweaponcheck', true)
    TriggerEvent('esx:updatecoords', true)
    TriggerEvent('event', false)
    exports['suncore']:SetPlayerVisible(true)
    exports['suncore']:Whitelist(false)
    if PB.lasthp > 0 then
        ESX.SetEntityHealth(SUN.ped, PB.lasthp)
        ESX.SetPedArmour(SUN.ped, PB.lastArmor or 0)
        PB.lasthp = 0
        PB.lastArmor = 0
    end
end

local Drawtext = function(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale or 0.5, scale or 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

PB.drawText = Drawtext

local function pbClearZoneFx()
    if PB.inZoneDrunk then
        PB.inZoneDrunk = false
        ClearTimecycleModifier()
        StopGameplayCamShaking(true)
    end
end
PB.clearZoneFx = pbClearZoneFx

local zoneRunning = false
local function startZone()
    if zoneRunning then return end
    zoneRunning = true
    CreateThread(function()
        local lastDamageAt = 0
        local lastSmokeAt = 0
        local smokeAngle = 0.0
        local ptfxReady = false
        while PB.state.inMatch do
            local modeCfg = paintballConfig.gameModes[PB.state.mode]
            local zoneCfg = (modeCfg and modeCfg.zone) or {}
            local zoneOn = PB.state.inMatch and PB.markercoords and PB.shrinking and PB.zoneVisible
                and zoneCfg.enabled and PB.roundStartedAt and PB.roundDuration and PB.roundDuration > 0
                and not PB.state.inAC130

            if zoneOn then
                local now = GetGameTimer()
                local damageInterval = zoneCfg.damageInterval or 600
                local isShrink = zoneCfg.shrink == true
                local shrinkAtRemaining = zoneCfg.shrinkAtRemaining or 60
                local finalCloseSeconds = zoneCfg.finalCloseSeconds or 5
                local finalRadius = zoneCfg.finalRadius or 3.0
                local initial = PB.zoneInitialRadius or PB.zoneRadius or 100.0
                if initial < finalRadius then initial = finalRadius end
                local elapsed = (now - PB.roundStartedAt) / 1000
                local remaining = PB.roundDuration - elapsed
                local shrinkActive = isShrink and (remaining <= shrinkAtRemaining and remaining > 0)

                if shrinkActive then
                    if not PB.zoneShrinking then
                        PB.zoneShrinking = true
                        if ESX and ESX.notification then
                            ESX.notification('error', '⚠ زون در حال جمع شدنه — برو سمت مرکز!')
                        end
                        if paintballConfig.sound == nil or paintballConfig.sound.enabled ~= false then
                            PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
                        end
                    end
                    local window = shrinkAtRemaining - finalCloseSeconds
                    local progress = (window > 0) and ((shrinkAtRemaining - remaining) / window) or 1.0
                    if progress < 0 then progress = 0 elseif progress > 1 then progress = 1 end
                    PB.zoneRadius = initial - (initial - finalRadius) * progress
                else
                    PB.zoneShrinking = false
                    PB.zoneRadius = initial
                end

                local cx, cy, cz = PB.markercoords.x, PB.markercoords.y, PB.markercoords.z
                local rad = PB.zoneRadius or initial

                local pulse = 0.5 + 0.5 * math.sin(now / 320.0)
                local r, g, b, alpha
                if shrinkActive then r, g, b, alpha = 255, 45, 20, math.floor(55 + 55 * pulse)
                else r, g, b, alpha = 255, 120, 30, 30 end
                DrawMarker(28, cx, cy, cz, 0,0,0, 0,0,0, rad, rad, rad, r, g, b, alpha, false, false, 2, false, false, false, false)

                if shrinkActive then
                    if not ptfxReady then
                        if ESX and ESX.Streaming then ESX.Streaming.RequestNamedPtfxAsset('core') end
                        if HasNamedPtfxAssetLoaded('core') then ptfxReady = true end
                    end
                    if ptfxReady and (now - lastSmokeAt > 200) then
                        lastSmokeAt = now
                        smokeAngle = (smokeAngle + 0.6) % 6.2831853
                        for i = 0, 4 do
                            local ang = smokeAngle + (i * 1.2566370)
                            local px = cx + math.cos(ang) * rad
                            local py = cy + math.sin(ang) * rad
                            UseParticleFxAssetNextCall('core')
                            StartParticleFxNonLoopedAtCoord('ent_amb_smoke_foundry', px, py, cz - 1.0, 0.0, 0.0, 0.0, 1.7, false, false, false)
                        end
                    end
                end

                local alive = not PB.state.matchSpectating and not PB.state.spectator
                local outside = alive and (#(SUN.PlayerCoords - PB.markercoords) > rad)
                if outside then
                    if not PB.inZoneDrunk then
                        PB.inZoneDrunk = true
                        SetTimecycleModifier('spectator5')
                        SetTimecycleModifierStrength(1.0)
                        ShakeGameplayCam('DRUNK_SHAKE', 3.0)
                    end
                elseif PB.inZoneDrunk then
                    pbClearZoneFx()
                end
                if outside and not PB.state.spawnInvincible and (now - lastDamageAt > damageInterval) then
                    lastDamageAt = now
                    local maxHp = GetEntityMaxHealth(SUN.ped)
                    local dmg = math.max(zoneCfg.damageOutside or 5, math.ceil(maxHp * (zoneCfg.damagePct or 0.04)))
                    ESX.SetEntityHealth(SUN.ped, math.max(0, GetEntityHealth(SUN.ped) - dmg))
                end

                Wait(0)
            else
                pbClearZoneFx()
                Wait(500)
            end
        end
        zoneRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startZone)

local pbApplySpectate, pbAllowToSpec, pbCountAliveTeammates, pbResolveTargetByIdx, pbSpectateNext, pbBeginSpectateSession, pbEndSpectateSession

local function reportDeath(killerSrc, weaponHash, headshot, killerNetId)
    if not PB.state.inMatch or PB.state.spectator then return end
    if PB.state.spawnInvincible then return end
    if PB.state.deathReported then return end
    PB.state.deathReported = true
    PB.state.deathReportedAt = GetGameTimer()
    if PB.cancelActivePerks then PB.cancelActivePerks() end
    ESX.TriggerServerCallback('paintball:onDeath', function() end, killerSrc, weaponHash, headshot, killerNetId)
    PB.startPostDeathSpectate()
end

function PB.startPostDeathSpectate()
    if PB.matchSpectate and PB.matchSpectate.active then return end
    if not PB.state.inMatch then return end
    if PB.state.spectator then return end
    PB.matchSpectate = PB.matchSpectate or {active = false, teammates = {}, idx = 1}
    PB.matchSpectate.active = true
    PB.matchSpectate.teammates = PB.matchSpectate.teammates or {}
    PB.matchSpectate.idx = 1
    PB.state.matchSpectating = true
    if PB.state.matchTeams then
        local mySid = GetPlayerServerId(SUN.PlayerId)
        local myTeam = PB.state.team or 0
        local mode = PB.state.mode
        local isFFA = mode == 'ffa' or mode == 'gungame' or mode == 'aimtrainer'
        local list = {}
        for sid, team in pairs(PB.state.matchTeams) do
            if sid ~= mySid then
                if isFFA then
                    list[#list + 1] = sid
                elseif myTeam > 0 and team == myTeam then
                    list[#list + 1] = sid
                end
            end
        end
        PB.matchSpectate.teammates = list
    end
    if pbBeginSpectateSession then pbBeginSpectateSession({keepBodyVisible = true}) end
    SUN.SendUIData(PB.HUD, {type = 'matchSpectate', payload = {active = true}})
    SetTimeout(600, function()
        if not PB.matchSpectate.active then return end
        if PB.state.deathReported == false then return end
        if #PB.matchSpectate.teammates > 0 and pbResolveTargetByIdx then
            local pid, tped, foundIdx = pbResolveTargetByIdx(PB.matchSpectate.idx or 1)
            if pid and tped then
                PB.matchSpectate.idx = foundIdx
                PB.matchSpectate.currentTarget = tped
                PB.matchSpectate.currentPid = pid
                if pbApplySpectate then pbApplySpectate(tped) end
            end
        end
    end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if not PB.state.inMatch or PB.state.spectator then return end
    if PB.state.deathReported then return end
    local killerSrc = data and data.killerServerId
    local weaponHash = data and data.deathCause
    local headshot = data and data.headshot or false
    local killerNetId = nil
    local ped = SUN.ped
    if ped and ped ~= 0 then
        local ke = GetPedSourceOfDeath(ped)
        if ke and ke ~= 0 and DoesEntityExist(ke) and not IsPedAPlayer(ke) and NetworkGetEntityIsNetworked(ke) then
            killerNetId = NetworkGetNetworkIdFromEntity(ke)
        end
    end
    reportDeath(killerSrc, weaponHash, headshot, killerNetId)
end)

local deathRespawnRunning = false
local function startDeathRespawn()
    if deathRespawnRunning then return end
    deathRespawnRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            Wait(4000)
            if PB.state.inMatch and not PB.state.spectator and PB.state.deathReported and PB.state.deathReportedAt then
                local elapsed = GetGameTimer() - PB.state.deathReportedAt
                local ped = SUN.ped
                if elapsed > 10000 and ped and ped ~= 0 and IsEntityDead(ped) then
                    TriggerServerEvent('paintball:requestRespawn')
                    PB.state.deathReportedAt = GetGameTimer() - 5000
                end
            end
        end
        deathRespawnRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startDeathRespawn)

local deathDetectRunning = false
local function startDeathDetect()
    if deathDetectRunning then return end
    deathDetectRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if PB.state.inMatch and not PB.state.spectator and not PB.state.deathReported then
                local ped = SUN.ped
                if ped and ped ~= 0 and IsEntityDead(ped) then
                    local killer, weapon, killerNetId = nil, nil, nil
                    local killerEntity = GetPedSourceOfDeath(ped)
                    if killerEntity and killerEntity ~= 0 and DoesEntityExist(killerEntity) then
                        if IsPedAPlayer(killerEntity) then
                            local pid = NetworkGetPlayerIndexFromPed(killerEntity)
                            if pid ~= -1 then killer = GetPlayerServerId(pid) end
                        elseif NetworkGetEntityIsNetworked(killerEntity) then
                            killerNetId = NetworkGetNetworkIdFromEntity(killerEntity)
                        end
                    end
                    weapon = GetPedCauseOfDeath(ped)
                    local headshot = IsPedDeadOrDying(ped, true) and GetPedLastDamageBone(ped) == 31086
                    reportDeath(killer, weapon, headshot, killerNetId)
                end
                local _mx = GetEntityMaxHealth(SUN.ped)
                if _mx < 1 then _mx = 200 end
                TriggerServerEvent('paintball:reportHp', math.max(0, math.min(1, GetEntityHealth(SUN.ped) / _mx)), GetPedArmour(SUN.ped))
                Wait(500)
            else
                Wait(2000)
            end
        end
        deathDetectRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startDeathDetect)

RegisterNetEvent('paintball:playerHealth', function(hpData)
    PB.playerHp = hpData or {}
end)

RegisterNetEvent('paintball:matchStart', function(payload)
    PB.lasthp = GetEntityHealth(SUN.ped)
    PB.lastArmor = GetPedArmour(SUN.ped)
    PB.state.inMatch = true
    PB.state.inLobby = false
    PB.state.starting = false
    PB.state.isHost = payload.isHost and true or false
    PB.state.matchId = payload.id
    PB.state.mode = payload.mode
    PB.state.map = payload.map
    PB.state.team = payload.team
    PB.state.spectator = payload.spectator and true or false
    PB.state.weapon = payload.weapon
    PB.state.perks = payload.perks or {}
    PB.state.perksEnabled = payload.data and payload.data.perksEnabled ~= false
    PB.state.hardcore = payload.hardcore and true or false
    PB.state.matchTeams = {}
    if payload.teamMap then
        for sid, team in pairs(payload.teamMap) do
            PB.state.matchTeams[tonumber(sid)] = team
        end
    end
    PB.state.loadoutAttachments = payload.loadoutAttachments or {}
    PB.state.selectedAttachments = {}
    for w, atts in pairs(PB.state.loadoutAttachments) do
        PB.state.selectedAttachments[w] = {}
        for k, v in pairs(atts) do PB.state.selectedAttachments[w][k] = v end
    end
    PB.matchData = payload.data
    TriggerEvent('paintball:matchThreads')
    if PB.dbg then PB.dbg('matchStart: stored perks=', json.encode(PB.state.perks), 'loadout=', json.encode(PB.state.loadoutAttachments)) end
    SUN.CloseUI(PB.MODULE)
    SetNuiFocus(false, false)
    TriggerEvent('inPaintball', true)
    PB.setMatchKeysBlocked(true)
    TriggerEvent('safezone:active', false)
    TriggerEvent('medic:revive', true, nil, true)
    TriggerEvent('status:setupdate', false)
    TriggerEvent('esx_inventoryhud:br', true)
    TriggerEvent('esx:stateweaponcheck', false)
    TriggerEvent('esx:updatecoords', false)
    TriggerEvent('event', true)
    exports['suncore']:Whitelist(true)
    SUN.OpenUI(PB.HUD, {
        view = 'hud',
        mode = payload.mode,
        map = payload.map,
        team = payload.team,
        spectator = payload.spectator,
        roundIndex = payload.roundIndex,
        rounds = payload.rounds,
        flags = PB.flags,
        weapon = payload.weapon,
        extra = payload.extra,
        perks = PB.state.perksEnabled and PB.state.perks or {},
    }, {type = 'overlay', path = MODULE_NAME})
    SetTimeout(400, function()
        SUN.SendUIData(PB.HUD, {type = 'perkHud', payload = {perks = PB.state.perksEnabled and PB.state.perks or {}}})
    end)
    SetTimeout(1400, function()
        if not PB.state.inMatch then return end
        local mode = PB.state.mode
        local team = PB.state.team or 0
        local title, sub, color, icon
        if mode == 'escort' then
            local extra = payload.extra or {}
            local isVip = extra.vip == GetPlayerServerId(SUN.PlayerId)
            if team == (extra.vipTeam or 1) then
                title = isVip and 'تو VIP هستی!' or 'تو DEFENDER هستی'
                sub = isVip and 'باید زنده به مقصد برسی' or 'از VIP محافظت کن'
                color = 'success'
                icon = isVip and '★' or '◈'
            else
                title = 'تو ATTACKER هستی'
                sub = 'VIP رو بکش قبل از رسیدن به مقصد'
                color = 'error'
                icon = '⚔'
            end
        elseif mode == 'bombplant' then
            local extra = payload.extra or {}
            local atk = extra.atkTeam or 1
            if team == atk then
                title = 'تو ATTACKER هستی'
                sub = 'بمب رو پلنت کن!'
                color = 'success'
                icon = '◈'
            else
                title = 'تو DEFENDER هستی'
                sub = 'از سایت‌های بمب دفاع کن'
                color = 'warning'
                icon = '◆'
            end
        elseif mode == 'infection' then
            local extra = payload.extra or {}
            local isInfected = extra.infected and extra.infected[tostring(GetPlayerServerId(SUN.PlayerId))]
            if isInfected then
                title = 'تو زامبی هستی'
                sub = 'بازمانده‌ها رو آلوده کن'
                color = 'error'
                icon = '☣'
            else
                title = 'تو SURVIVOR هستی'
                sub = 'تا آخر بازی زنده بمون'
                color = 'success'
                icon = '◈'
            end
        elseif mode == 'juggernaut' then
            local extra = payload.extra or {}
            if extra.juggernaut == GetPlayerServerId(SUN.PlayerId) then
                title = 'تو JUGGERNAUT هستی!'
                sub = 'با مینی‌گان بکش همه رو'
                color = 'success'
                icon = '★'
            else
                title = 'تو شکارچی هستی'
                sub = 'JUGGERNAUT رو بکش'
                color = 'warning'
                icon = '⚔'
            end
        elseif mode == 'tdm' or mode == 'sunset_tdm' or mode == 'tournament' or mode == 'gunrotation' or mode == 'domination' or mode == 'koth' then
            title = team == 1 and 'تو تیم آلفا هستی' or 'تو تیم براوو هستی'
            if mode == 'koth' then
                sub = 'تپه رو نگه دار'
            elseif mode == 'domination' then
                sub = 'سه نقطه رو کنترل کن'
            elseif mode == 'gunrotation' then
                sub = 'با سلاح‌های در حال چرخش بکش'
            elseif mode == 'tournament' then
                sub = 'تورنومنت — تیمت رو به برد برسون'
            else
                sub = 'دشمن رو بکش'
            end
            color = team == 1 and 'success' or 'info'
            icon = team == 1 and '◈' or '◇'
        elseif mode == 'ffa' or mode == 'gungame' then
            title = 'همه دشمن تو هستن'
            sub = mode == 'gungame' and 'هر کیل سلاح بهتر' or 'بیشترین کیل برنده'
            color = 'warning'
            icon = '⚔'
        elseif mode == 'coop' or mode == 'wavedefense' or mode == 'survival' then
            title = 'تو SURVIVOR هستی'
            sub = mode == 'survival' and 'بی‌نهایت موج زامبی' or 'موج‌های زامبی رو تموم کن'
            color = 'warning'
            icon = '◆'
        end
        if title then
            local tourCfg = paintballConfig.preMatchTour or {}
            local bannerDuration = tourCfg.enabled and ((tourCfg.duration or 10) * 1000 - 1000) or 9000
            if bannerDuration < 3000 then bannerDuration = 3000 end
            SUN.SendUIData(PB.HUD, {type = 'roleBanner', payload = {title = title, sub = sub, color = color, icon = icon, duration = bannerDuration}})
        end
    end)
end)

RegisterNetEvent('paintball:matchEnd', function(payload)
    SUN.SendUIData(PB.HUD, {type = 'matchEnd', payload = payload})
    if PB.matchSpectate and PB.matchSpectate.active then
        PB.matchSpectate.active = false
        PB.matchSpectate.teammates = {}
        PB.matchSpectate.currentTarget = nil
        PB.matchSpectate.currentPid = nil
        NetworkSetInSpectatorMode(false, 0)
        local ped = SUN.ped
        if ped and ped ~= 0 then
            SetEntityInvincible(SUN.PlayerId, false)
            SetEntityVisible(ped, true, false)
            FreezeEntityPosition(ped, false)
        end
        pcall(function() exports['suncore']:SetPlayerVisible(true) end)
    end
    PB.state.matchSpectating = false
    local entryCoords = PB.lastEntryCoords
    local rHp, rAr = PB.lasthp or 0, PB.lastArmor or 0
    PB.state.inMatch = false
    PB.state.matchId = nil
    PB.timer = 0
    PB.shrinking = false
    PB.zoneVisible = false
    PB.zoneShrinking = false
    PB.roundStartedAt = nil
    PB.roundDuration = nil
    AnimpostfxStopAll()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    StopGameplayCamShaking(true)
    if PB.clearZoneFx then PB.clearZoneFx() end
    if PB.cancelActivePerks then PB.cancelActivePerks() end
    SetSeethrough(false)
    SetNightvision(false)
    TriggerEvent('core:applyScreenEffect', 'hud_def_desat_Trevor', 0, 10)
    TriggerEvent('core:applyScreenEffect', 'REDMIST_blend', 0, 10)
    TriggerEvent('core:applyScreenEffect', 'REDMIST', 0, 10)
    TriggerEvent('inPaintball', false)
    PB.setMatchKeysBlocked(false)
    TriggerEvent('safezone:active', true)
    TriggerEvent('esx:stateweaponcheck', true)
    TriggerEvent('esx:updatecoords', true)
    TriggerEvent('event', false)
    exports['suncore']:Whitelist(false)
    NetworkSetInSpectatorMode(false, 0)
    SetTimeout(8000, function()
        SUN.CloseUI(PB.HUD)
        SUN.CloseUI(PB.ATTACH)
        SUN.CloseUI(PB.SCORE)
        local PlayerPed = SUN.ped
        if PB.resetWeaponTints then PB.resetWeaponTints() end
        TriggerEvent('medic:revive', true, nil, true)
        RemoveAllPedWeapons(PlayerPed, false)
        TriggerEvent('esx:restoreLoadout')
        if exports['sunset_clothe'] and exports['sunset_clothe'].removeStuffJob then
            exports['sunset_clothe']:removeStuffJob()
            exports['sunset_clothe']:removeStuffJob()
            Wait(500)
            exports['sunset_clothe']:loadUsed()
        end
        TriggerEvent('status:setupdate', true)
        TriggerServerEvent('paintball:returnedToWorld')
        if entryCoords then
            ESX.SetEntityCoords(SUN.ped, entryCoords.x, entryCoords.y, entryCoords.z + 1.0)
        end
        PB.lasthp = 0
        PB.lastArmor = 0
        if rHp > 0 then
            SetTimeout(800, function()
                local pp = SUN.ped
                if pp and pp ~= 0 then
                    ESX.SetEntityHealth(pp, rHp)
                    ESX.SetPedArmour(pp, rAr)
                end
            end)
        end
        exports['suncore']:SetPlayerVisible(true)
    end)
end)

RegisterNetEvent('paintball:returnedToWorld', function() end)

RegisterNetEvent('paintball:closeLobby', function()
    PB.state.inLobby = false
    if SUN.IsUIOpen and SUN.IsUIOpen(PB.MODULE) then
        SUN.SendUIData(PB.MODULE, {type = 'returnToPlay', payload = {reason = 'لابی توسط میزبان بسته شد'}})
    else
        ESX.notification('error', 'lobby baste shod')
    end
end)

RegisterNetEvent('paintball:matchCountdown', function(payload)
    if not payload then return end
    local total = tonumber(payload.seconds) or 5
    if total <= 0 then return end
    PB.state.starting = true
    SetNuiFocus(false, false)
    SUN.SendUIData(PB.MODULE, {type = 'matchCountdown', payload = {
        seconds = total,
        modeLabel = payload.modeLabel,
        map = payload.map,
    }})
    CreateThread(function()
        local startedAt = GetGameTimer()
        local endAt = startedAt + (total * 1000)
        local lastTick = -1
        while GetGameTimer() < endAt do
            local remaining = math.ceil((endAt - GetGameTimer()) / 1000)
            if remaining ~= lastTick then
                lastTick = remaining
                SUN.SendUIData(PB.MODULE, {type = 'matchCountdownTick', payload = {remaining = remaining}})
                if payload.tickSound and remaining > 0 then
                    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
                    PlaySoundFrontend(-1, payload.tickSoundName or 'TIMER_STOP', payload.tickSoundSet or 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                    if remaining <= 3 then
                        PlaySoundFrontend(-1, '3_2_1', 'HUD_MINI_GAME_SOUNDSET', true)
                    end
                end
            end
            Wait(50)
        end
        SUN.SendUIData(PB.MODULE, {type = 'matchCountdownGo'})
        PlaySoundFrontend(-1, payload.goSoundName or 'CHALLENGE_UNLOCKED', payload.goSoundSet or 'HUD_AWARDS', true)
        SetTimeout(5000, function()
            if not PB.state.inMatch then
                PB.state.starting = false
                SetNuiFocus(true, true)
            end
        end)
    end)
end)

RegisterNetEvent('paintball:lobbyState', function(snapshot)
    PB.state.inLobby = true
    SUN.SendUIData(PB.MODULE, {type = 'lobbyState', payload = snapshot})
end)

RegisterNetEvent('paintball:roundUpdate', function(info)
    SUN.SendUIData(PB.HUD, {type = 'roundUpdate', payload = info})
    if info.seconds then
        PB.timer = info.seconds
    end
    if (paintballConfig.sound == nil or paintballConfig.sound.enabled ~= false) and info.state ~= PB.lastRoundSoundState then
        PB.lastRoundSoundState = info.state
        if info.state == 'warmup' then
            PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
        elseif info.state == 'live' then
            PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true)
        end
    end
    if info.state == 'live' and info.seconds and info.seconds > 0 then
        PB.state.perkUsableAt = GetGameTimer() + (((paintballConfig.perkSystem and paintballConfig.perkSystem.activationDelay) or 5) * 1000)
        local z = paintballConfig.gameModes[PB.state.mode] and paintballConfig.gameModes[PB.state.mode].zone
        PB.shrinking = (z and z.enabled == true) or false
        if PB.shrinking then
            PB.roundStartedAt = GetGameTimer()
            PB.roundDuration = info.seconds
            PB.zoneRadius = PB.zoneInitialRadius or PB.zoneRadius or 100.0
            PB.zoneVisible = true
            PB.zoneShrinking = false
        end
    elseif info.state == 'roundEnd' or info.state == 'warmup' then
        PB.zoneShrinking = false
        PB.roundStartedAt = nil
        PB.zoneRadius = PB.zoneInitialRadius or PB.zoneRadius
    end
end)

RegisterNetEvent('paintball:teamCounts', function(counts, startSize, kills)
    SUN.SendUIData(PB.HUD, {type = 'teamCounts', payload = {counts = counts, startSize = startSize, kills = kills}})
end)

RegisterNetEvent('paintball:timerUpdate', function(seconds)
    PB.timer = seconds
    SUN.SendUIData(PB.HUD, {type = 'timer', payload = {seconds = seconds}})
end)

RegisterNetEvent('paintball:killFeed', function(info)
    SUN.SendUIData(PB.HUD, {type = 'killFeed', payload = info})
    if PB.flags.ui and PB.flags.ui.showHitmarker and info.victim and info.killer == GetPlayerName(SUN.PlayerId, true) then
        SUN.SendUIData(PB.HUD, {type = 'hitmarker', payload = {kill = true}})
    end
end)

RegisterNetEvent('paintball:scoreboard', function(rows)
    PB.lastScoreboard = rows
    SUN.SendUIData(PB.HUD, {type = 'scoreboard', payload = rows})
end)

local scoreboardOpen = false
local scoreboardKeyDown = false

RegisterCommand('+pbScoreboard', function()
    if not PB.state.inMatch then return end
    scoreboardKeyDown = true
    if not scoreboardOpen then
        scoreboardOpen = true
        SUN.SendUIData(PB.HUD, {type = 'showScoreboard', payload = true})
    end
end, false)

RegisterCommand('-pbScoreboard', function()
    scoreboardKeyDown = false
    if scoreboardOpen then
        scoreboardOpen = false
        SUN.SendUIData(PB.HUD, {type = 'showScoreboard', payload = false})
    end
end, false)

RegisterKeyMapping('+pbScoreboard', 'Paintball - Scoreboard', 'keyboard', 'CAPITAL')

AddEventHandler('paintball:cleanup', function()
    if scoreboardOpen then
        scoreboardOpen = false
        scoreboardKeyDown = false
        SUN.SendUIData(PB.HUD, {type = 'showScoreboard', payload = false})
    end
end)

RegisterNetEvent('paintball:gungameWeaponSwap', function(payload)
    if not payload or not payload.weapon then return end
    local hash = GetHashKey(payload.weapon)
    RemoveAllPedWeapons(SUN.ped, true)
    GiveWeaponToPed(SUN.ped, hash, 999, false, true)
    SetCurrentPedWeapon(SUN.ped, hash, true)
    SetPedAmmo(SUN.ped, hash, 999)
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = ('سلاح جدید · Level ' .. (payload.level or '?')), duration = 2.5}})
end)

RegisterNetEvent('paintball:gungameLevels', function(rows)
    SUN.SendUIData(PB.HUD, {type = 'gungameLevels', payload = rows})
end)

PB.state.carrierBlip = PB.state.carrierBlip or nil
RegisterNetEvent('paintball:bombCarrier', function(info)
    print('[PB-BOMB] bombCarrier event received, weapon=', info and info.weapon)
    PB.state.bombCarrier = true
    if info and info.weapon then
        local h = GetHashKey(info.weapon)
        GiveWeaponToPed(SUN.ped, h, 1, false, true)
        SetCurrentPedWeapon(SUN.ped, h, true)
    end
    if PB.state.carrierBlip and DoesBlipExist(PB.state.carrierBlip) then RemoveBlip(PB.state.carrierBlip) end
    local b = AddBlipForEntity(SUN.ped)
    SetBlipSprite(b, 568)
    SetBlipColour(b, 1)
    SetBlipScale(b, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('بمب با تو')
    EndTextCommandSetBlipName(b)
    PB.state.carrierBlip = b
    if ESX then ESX.notification('success', 'بمب دست توئه — برو پلنت کن!') end
    SUN.SendUIData(PB.HUD, {type = 'bombCarrier', payload = {state = true}})
end)

RegisterNetEvent('paintball:bombSwitchSides', function(info)
    PB.state.team = info.atkTeam == PB.state.team and info.defTeam or info.atkTeam
    ESX.notification('warning', 'side ha avaz shod')
end)

RegisterNetEvent('paintball:domState', function(state)
    SUN.SendUIData(PB.HUD, {type = 'domState', payload = state})
end)

RegisterNetEvent('paintball:domTick', function(score)
    SUN.SendUIData(PB.HUD, {type = 'domTick', payload = score})
end)

RegisterNetEvent('paintball:kothTick', function(state)
    SUN.SendUIData(PB.HUD, {type = 'kothTick', payload = state})
end)

RegisterNetEvent('paintball:juggernautChange', function(info)
    SUN.SendUIData(PB.HUD, {type = 'juggernautChange', payload = info})
end)

RegisterNetEvent('paintball:gunRotationSwap', function(weapon)
    if not PB.state.inMatch then return end
    RemoveAllPedWeapons(SUN.ped, true)
    local hash = GetHashKey(weapon)
    GiveWeaponToPed(SUN.ped, hash, 999, false, true)
    SetPedAmmo(SUN.ped, hash, 999)
    GiveWeaponToPed(SUN.ped, `WEAPON_KNIFE`, 1, false, false)
    SetCurrentPedWeapon(SUN.ped, hash, true)
    PB.state.weapon = weapon
    local cleanLabel = (weapon or ''):gsub('WEAPON_', '')
    SUN.SendUIData(PB.HUD, {type = 'killstreakBanner', payload = {label = 'سلاح عوض شد: ' .. cleanLabel, duration = 2.5}})
    SUN.SendUIData(PB.HUD, {type = 'weaponSwap', payload = {weapon = weapon}})
end)

RegisterNetEvent('paintball:escortAdvance', function(info)
    SUN.SendUIData(PB.HUD, {type = 'escortAdvance', payload = info})
end)

RegisterNetEvent('paintball:escortVipChange', function(info)
    SUN.SendUIData(PB.HUD, {type = 'escortVipChange', payload = info})
end)

RegisterNetEvent('paintball:multikill', function(info)
    SUN.SendUIData(PB.HUD, {type = 'multikill', payload = info})
end)

RegisterNetEvent('paintball:killstreak', function(info)
    SUN.SendUIData(PB.HUD, {type = 'killstreak', payload = info})
end)

RegisterNetEvent('paintball:killstreakUpdate', function(info)
    SUN.SendUIData(PB.HUD, {type = 'killstreakUpdate', payload = info})
end)

RegisterNetEvent('paintball:assistGranted', function()
    SUN.SendUIData(PB.HUD, {type = 'assistGranted'})
end)

RegisterNetEvent('paintball:perkApply', function(payload)
    if PB.dbg then PB.dbg('event paintball:perkApply received', payload and payload.perk and payload.perk.key, 'duration', payload and payload.duration) end
    PB.state.activePerk = payload.perk
    PB.applyPerk(payload.perk, payload.duration)
    SUN.SendUIData(PB.HUD, {type = 'perkApply', payload = payload})
end)

RegisterNetEvent('paintball:partyState', function(state)
    SUN.SendUIData(PB.MODULE, {type = 'partyState', payload = state})
end)

RegisterNetEvent('paintball:partyDisbanded', function()
    SUN.SendUIData(PB.MODULE, {type = 'partyDisbanded'})
end)

RegisterNetEvent('paintball:partyInvite', function(payload)
    SUN.SendUIData(PB.MODULE, {type = 'partyInvite', payload = payload})
end)

RegisterNetEvent('paintball:readyCheckRequest', function(info)
    SUN.SendUIData(PB.MODULE, {type = 'readyCheckRequest', payload = info})
    if paintballConfig.sound == nil or paintballConfig.sound.enabled ~= false then
        CreateThread(function()
            for _ = 1, 6 do
                PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
                PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                Wait(300)
            end
        end)
    end
end)

RegisterNetEvent('paintball:readyCheckUpdate', function(info)
    SUN.SendUIData(PB.MODULE, {type = 'readyCheckUpdate', payload = info})
end)

RegisterNetEvent('paintball:applyAttachments', function(payload)
    if PB.dbg then PB.dbg('event paintball:applyAttachments received', payload and payload.weapon, json.encode(payload and payload.attachments or {})) end
    PB.applyAttachments(payload.weapon, payload.attachments)
    SUN.SendUIData(PB.ATTACH, {type = 'attachmentsApplied', payload = payload})
end)

function PB.getOutfit(modeKey, team)
    local override = paintballConfig.modeOutfitOverride and paintballConfig.modeOutfitOverride[modeKey]
    if override then
        if override.team and team and override.team[team] then
            return paintballConfig.outfits[override.team[team]] or paintballConfig.outfits[team] or paintballConfig.outfits[1]
        end
        if override.playerOutfit then
            return paintballConfig.outfits[override.playerOutfit] or paintballConfig.outfits[1]
        end
    end
    return paintballConfig.outfits[team] or paintballConfig.outfits[1]
end

RegisterNetEvent('paintball:spawn', function(payload)
    while not ESX do Wait(50) end
    PB.state.deathReported = false
    PB.state.deathReportedAt = nil
    PB.state.perkUsableAt = GetGameTimer() + (((paintballConfig.perkSystem and paintballConfig.perkSystem.activationDelay) or 5) * 1000)
    if pbEndSpectateSession then pbEndSpectateSession() end
    SUN.SendUIData(PB.HUD, {type = 'matchSpectate', payload = {active = false}})
    local PlayerPed = SUN.ped
    if not SUN.IsUIOpen(PB.HUD) then
        SUN.OpenUI(PB.HUD, {
            view = 'hud',
            mode = payload.mode or PB.state.mode,
            map = payload.map or PB.state.map,
            team = payload.team or PB.state.team,
            weapon = payload.weapon,
            spectator = false,
            flags = PB.flags,
            perks = PB.state.perksEnabled and PB.state.perks or {},
        }, {type = 'overlay', path = MODULE_NAME})
    else
        SUN.SendUIData(PB.HUD, {type = 'spawnUpdate', payload = {
            mode = payload.mode or PB.state.mode,
            map = payload.map or PB.state.map,
            team = payload.team or PB.state.team,
            weapon = payload.weapon,
        }})
    end

    local outfit = payload.outfit and paintballConfig.outfits[payload.outfit] or PB.getOutfit(payload.mode or PB.state.mode, payload.team)
    if outfit then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local set = (tonumber(skin.sex) == 0) and outfit.male or outfit.female
            TriggerEvent('skinchanger:loadClothes', skin, set)
        end)
    end

    local map = paintballConfig.maps[payload.map or PB.state.map] or paintballConfig.coopMaps[payload.map or PB.state.map]
    if map then
        PB.markercoords = map.center
        local rad = map.radius or 100.0
        local c = map.center
        local function chk(pt)
            if pt then
                local d = #(vec3(pt.x, pt.y, pt.z) - c)
                if d + 15.0 > rad then rad = d + 15.0 end
            end
        end
        if map.teamSpawns then
            for _, team in pairs(map.teamSpawns) do
                if type(team) == 'table' then
                    for _, sub in pairs(team) do
                        if type(sub) == 'table' then for _, pt in pairs(sub) do chk(pt) end end
                    end
                end
            end
        end
        if map.ffaSpawns then for _, pt in ipairs(map.ffaSpawns) do chk(pt) end end
        PB.zoneRadius = rad
        PB.zoneInitialRadius = rad
        PB.zoneVisible = true
        PB.zoneShrinking = false
        local _mode = payload.mode or PB.state.mode
        local _z = paintballConfig.gameModes[_mode] and paintballConfig.gameModes[_mode].zone
        PB.shrinking = (_z and _z.enabled == true) or false
        PB.lastCoords = nil
    end

    if payload.coords and not payload.noTeleport then
        ESX.SetEntityCoords(PlayerPed, payload.coords.x, payload.coords.y, payload.coords.z)
        SetEntityHeading(PlayerPed, payload.coords.w or 0.0)
    elseif map and (payload.team or PB.state.team) > 0 then
        local spawn
        local mode = payload.mode or PB.state.mode
        if mode == 'infection' and payload.center then
            local angle = math.random() * math.pi * 2
            local dist = math.random(0, 10) + 0.0
            spawn = {x = payload.center.x + math.cos(angle) * dist, y = payload.center.y + math.sin(angle) * dist, z = payload.center.z, w = math.random(0, 359) + 0.0}
        elseif mode == 'ffa' or mode == 'gungame' or mode == 'practice' or mode == 'aimtrainer' or mode == 'juggernaut' then
            local list = map.ffaSpawns
            if list and #list > 0 then spawn = list[math.random(#list)] end
        elseif map.teamSpawns and map.teamSpawns[payload.spawnTeam or payload.team or PB.state.team] then
            local list = map.teamSpawns[payload.spawnTeam or payload.team or PB.state.team]
            if list and list[1] and list[1][1] then spawn = list[1][math.random(#list[1])] end
        end
        if mode == 'coop' or mode == 'wavedefense' or mode == 'survival' then
            local list = map.playerSpawns
            if list and #list > 0 then spawn = list[math.random(#list)] end
        end
        if not spawn and map.ffaSpawns and #map.ffaSpawns > 0 then
            spawn = map.ffaSpawns[math.random(#map.ffaSpawns)]
        end
        if spawn then
            ESX.SetEntityCoords(PlayerPed, spawn.x, spawn.y, spawn.z)
            SetEntityHeading(PlayerPed, spawn.w or 0.0)
        end
    end

    NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPed).x, GetEntityCoords(PlayerPed).y, GetEntityCoords(PlayerPed).z, GetEntityHeading(PlayerPed), true, false)
    SetPlayerInvincible(SUN.PlayerId, false)
    ClearPedBloodDamage(PlayerPed)
    NetworkSetInSpectatorMode(false, 0)
    TriggerEvent('medic:revive', true, nil, true)
    RemoveAllPedWeapons(PlayerPed, false)

    local weapon = payload.weapon or PB.state.weapon
    if weapon then
        GiveWeaponToPed(PlayerPed, GetHashKey(weapon), 250, false, true)
        SetCurrentPedWeapon(PlayerPed, GetHashKey(weapon), true)
        PB.state.weapon = weapon
        if PB.state.selectedAttachments and PB.state.selectedAttachments[weapon] then
            local atts = PB.state.selectedAttachments[weapon]
            PB.applyAttachments(weapon, atts)
            TriggerServerEvent('paintball:setLoadoutBatch', weapon, atts)
        end
    end
    if paintballConfig.gameModes[payload.mode or PB.state.mode] and paintballConfig.gameModes[payload.mode or PB.state.mode].knifeOnSpawn ~= false then
        GiveWeaponToPed(PlayerPed, `WEAPON_KNIFE`, 1, false, false)
    end

    if payload.secondaryWeapon then
        GiveWeaponToPed(PlayerPed, GetHashKey(payload.secondaryWeapon), payload.secondaryAmmo or 100, false, false)
    end

    if payload.equipment and #payload.equipment > 0 and paintballConfig.equipment then
        local lookup = {}
        for _, e in ipairs(paintballConfig.equipment.items) do lookup[e.key] = e.count or 1 end
        for _, key in ipairs(payload.equipment) do
            local count = lookup[key] or 1
            GiveWeaponToPed(PlayerPed, GetHashKey(key), count, false, false)
        end
    end

    if weapon then
        SetCurrentPedWeapon(PlayerPed, GetHashKey(weapon), true)
        local wHash = GetHashKey(weapon)
        local unarmed, knife = GetHashKey('WEAPON_UNARMED'), GetHashKey('WEAPON_KNIFE')
        CreateThread(function()
            local startedAt = GetGameTimer()
            while GetGameTimer() - startedAt < 1500 do
                if not PB.state.inMatch or PB.state.deathReported or PB.state.spectator then return end
                local ped = SUN.ped
                if ped and ped ~= 0 and not IsEntityDead(ped) then
                    local cur = GetSelectedPedWeapon(ped)
                    if cur ~= wHash and (cur == unarmed or cur == knife) then
                        SetCurrentPedWeapon(ped, wHash, true)
                    end
                end
                Wait(100)
            end
        end)
    end

    local hp = payload.hp or (payload.jugBoost and payload.jugBoost.hp) or (PB.matchData and PB.matchData.hp) or (paintballConfig.respawnHealth or 200)
    local armor = payload.armor or (payload.jugBoost and payload.jugBoost.armor) or (PB.matchData and PB.matchData.armor) or 0
    local maxArmor = payload.maxArmor or (payload.jugBoost and payload.jugBoost.armor) or 98
    if armor > maxArmor then armor = maxArmor end
    SetEntityMaxHealth(PlayerPed, hp)
    Wait(0)
    SetEntityHealth(PlayerPed, hp)
    ESX.SetEntityHealth(PlayerPed, hp)
    ESX.SetPedArmour(PlayerPed, armor)

    local applyToken = (PB.spawnApplyToken or 0) + 1
    PB.spawnApplyToken = applyToken
    CreateThread(function()
        local startedAt = GetGameTimer()
        while GetGameTimer() - startedAt < 5000 do
            if PB.spawnApplyToken ~= applyToken then return end
            if not PB.state.inMatch or PB.state.deathReported then return end
            local ped = SUN.ped
            if ped and ped ~= 0 and not IsEntityDead(ped) then
                if GetEntityMaxHealth(ped) < hp then SetEntityMaxHealth(ped, hp) end
                if GetEntityHealth(ped) < hp then ESX.SetEntityHealth(ped, hp) end
                if GetPedArmour(ped) < armor then ESX.SetPedArmour(ped, armor) end
            end
            Wait(400)
        end
    end)

    exports['suncore']:SetPlayerVisible(true)

    if payload.invincibleSeconds and payload.invincibleSeconds > 0 and not (PB.state.hardcore and paintballConfig.hardcoreMode and paintballConfig.hardcoreMode.disableSpawnProtection) then
        PB.state.spawnInvincible = true
        SetPlayerInvincible(SUN.PlayerId, true)
        SUN.SendUIData(PB.HUD, {type = 'spawnProtection', payload = {seconds = payload.invincibleSeconds}})
        SetTimeout(payload.invincibleSeconds * 1000, function()
            SetPlayerInvincible(SUN.PlayerId, false)
            PB.state.spawnInvincible = false
            SUN.SendUIData(PB.HUD, {type = 'spawnProtection', payload = {seconds = 0}})
        end)
    end

    if PB.state.hardcore and paintballConfig.hardcoreMode then
        local hc = paintballConfig.hardcoreMode
        if hc.damageMultiplier then
            SetPlayerWeaponDamageModifier(SUN.PlayerId, hc.damageMultiplier)
        end
    else
        SetPlayerWeaponDamageModifier(SUN.PlayerId, 1.0)
    end
end)

RegisterNetEvent('paintball:giveEquipment', function(equipment)
    if not PB.state.inMatch or PB.state.spectator then return end
    if not paintballConfig.equipment or not equipment then return end
    local lookup = {}
    for _, e in ipairs(paintballConfig.equipment.items) do lookup[e.key] = e.count or 1 end
    for _, key in ipairs(equipment) do
        GiveWeaponToPed(SUN.ped, GetHashKey(key), lookup[key] or 1, false, false)
    end
end)

CreateThread(function()
    while not ESX do Wait(100) end
    ESX.RegisterClientCallback('paintball:getCoords', function(cb)
        cb(GetEntityCoords(SUN.ped))
    end)
end)

RegisterNetEvent('paintball:airstrikeDamage', function(info)
    while not ESX do Wait(50) end
    local hp = GetEntityHealth(SUN.ped)
    ESX.SetEntityHealth(SUN.ped, math.max(0, hp - (info.amount or 200)))
end)

RegisterNetEvent('paintball:airstrikeDamageCheck', function(info)
    if not info or not info.coords then return end
    if not PB.state.inMatch or PB.state.spectator then return end
    if PB.state.spawnInvincible then return end
    local myCoords = GetEntityCoords(SUN.ped)
    local dx = myCoords.x - info.coords.x
    local dy = myCoords.y - info.coords.y
    local dz = myCoords.z - info.coords.z
    local d = math.sqrt(dx * dx + dy * dy + dz * dz)
    if d <= (info.radius or 20.0) then
        while not ESX do Wait(50) end
        local hp = GetEntityHealth(SUN.ped)
        ESX.SetEntityHealth(SUN.ped, math.max(0, hp - (info.amount or 200)))
    end
end)

PB.matchSpectate = PB.matchSpectate or {active = false, teammates = {}, idx = 1}

pbApplySpectate = function(targetPed)
    NetworkSetInSpectatorMode(false, 0)
    if targetPed and DoesEntityExist(targetPed) then
        NetworkSetInSpectatorMode(true, targetPed)
    end
end

pbAllowToSpec = function(targetPid, targetPed)
    if not targetPid or targetPid == -1 then return false end
    if not targetPed or not DoesEntityExist(targetPed) then return false end
    if IsPedDeadOrDying(targetPed, true) then return false end
    if targetPid == SUN.PlayerId then return false end
    return NetworkIsPlayerActive(targetPid)
end

pbCountAliveTeammates = function()
    local list = PB.matchSpectate.teammates or {}
    local count = 0
    for _, sid in ipairs(list) do
        local pid = GetPlayerFromServerId(sid)
        if pid ~= -1 then
            local tped = GetPlayerPed(pid)
            if pbAllowToSpec(pid, tped) then count = count + 1 end
        end
    end
    return count
end

pbResolveTargetByIdx = function(idx)
    local list = PB.matchSpectate.teammates or {}
    if #list == 0 then return nil, nil, idx end
    local sid = list[idx]
    local pid = sid and GetPlayerFromServerId(sid) or -1
    if pid ~= -1 then
        local tped = GetPlayerPed(pid)
        if pbAllowToSpec(pid, tped) then return pid, tped, idx end
    end
    for i = 1, #list do
        local ni = ((idx - 1 + i) % #list) + 1
        local s = list[ni]
        local p = s and GetPlayerFromServerId(s) or -1
        if p ~= -1 then
            local tp = GetPlayerPed(p)
            if pbAllowToSpec(p, tp) then return p, tp, ni end
        end
    end
    return nil, nil, idx
end

pbSpectateNext = function(dir)
    local list = PB.matchSpectate.teammates or {}
    if #list == 0 then return end
    local nextIdx = ((PB.matchSpectate.idx or 1) + (dir or 1) - 1) % #list + 1
    local pid, tped, foundIdx = pbResolveTargetByIdx(nextIdx)
    if pid and tped then
        PB.matchSpectate.idx = foundIdx
        PB.matchSpectate.currentTarget = tped
        PB.matchSpectate.currentPid = pid
        pbApplySpectate(tped)
    end
end

pbBeginSpectateSession = function(opts)
    if not ESX then return end
    opts = opts or {}
    pcall(function() exports['suncore']:Whitelist(true) end)
    local ped = SUN.ped
    if ped and ped ~= 0 then
        SetEntityInvincible(SUN.PlayerId, true)
        if not opts.keepBodyVisible then
            pcall(function() exports['suncore']:SetPlayerVisible(false) end)
            SetEntityVisible(ped, false, false)
            FreezeEntityPosition(ped, true)
        end
    end
end

pbEndSpectateSession = function()
    PB.matchSpectate.active = false
    PB.matchSpectate.teammates = {}
    PB.matchSpectate.currentTarget = nil
    PB.matchSpectate.currentPid = nil
    PB.state.matchSpectating = false
    PB.state.spectator = false
    NetworkSetInSpectatorMode(false, 0)
    local ped = SUN.ped
    if ped and ped ~= 0 then
        SetEntityInvincible(SUN.PlayerId, false)
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
    end
    pcall(function() exports['suncore']:SetPlayerVisible(true) end)
    pcall(function() exports['suncore']:Whitelist(false) end)
end

RegisterNetEvent('paintball:spectate', function(info)
    while not ESX do Wait(50) end
    PB.state.spectator = true
    pbBeginSpectateSession()
    local map = paintballConfig.maps[info.map] or paintballConfig.coopMaps[info.map]
    if map then
        ESX.SetEntityCoords(SUN.ped, map.center.x, map.center.y, map.center.z + 30.0)
    end
    if not SUN.IsUIOpen(PB.HUD) then
        SUN.OpenUI(PB.HUD, {view = 'hud', mode = PB.state.mode, map = info.map, spectator = true, flags = PB.flags}, {type = 'overlay', path = MODULE_NAME})
    end

    PB.matchSpectate = PB.matchSpectate or {active = false, teammates = {}, idx = 1}
    PB.matchSpectate.active = true
    PB.matchSpectate.idx = 1
    local mySid = GetPlayerServerId(SUN.PlayerId)
    local list = {}
    if info.targets and #info.targets > 0 then
        for _, sid in ipairs(info.targets) do
            if sid ~= mySid then list[#list + 1] = sid end
        end
    elseif PB.state.matchTeams then
        for sid in pairs(PB.state.matchTeams) do
            if sid ~= mySid then list[#list + 1] = sid end
        end
    end
    PB.matchSpectate.teammates = list
    SUN.SendUIData(PB.HUD, {type = 'matchSpectate', payload = {active = true, lobbySpectator = true}})
    SetTimeout(900, function()
        if not PB.matchSpectate.active then return end
        if #PB.matchSpectate.teammates > 0 and pbResolveTargetByIdx then
            local pid, tped, foundIdx = pbResolveTargetByIdx(PB.matchSpectate.idx or 1)
            if pid and tped then
                PB.matchSpectate.idx = foundIdx
                PB.matchSpectate.currentTarget = tped
                PB.matchSpectate.currentPid = pid
                if pbApplySpectate then pbApplySpectate(tped) end
            end
        end
    end)
end)

RegisterNetEvent('paintball:enterMatchSpectate', function(payload)
    if not payload then return end
    PB.matchSpectate.active = true
    PB.matchSpectate.teammates = payload.teammates or {}
    PB.matchSpectate.idx = 1
    PB.state.matchSpectating = true
    pbBeginSpectateSession({keepBodyVisible = true})
    SUN.SendUIData(PB.HUD, {type = 'matchSpectate', payload = {active = true}})
    SetTimeout(800, function()
        if PB.matchSpectate.active and #PB.matchSpectate.teammates > 0 then
            local pid, tped, foundIdx = pbResolveTargetByIdx(PB.matchSpectate.idx or 1)
            if pid and tped then
                PB.matchSpectate.idx = foundIdx
                PB.matchSpectate.currentTarget = tped
                PB.matchSpectate.currentPid = pid
                pbApplySpectate(tped)
            end
        end
    end)
end)

RegisterNetEvent('paintball:exitMatchSpectate', function()
    if not PB.matchSpectate.active then return end
    pbEndSpectateSession()
    SUN.SendUIData(PB.HUD, {type = 'matchSpectate', payload = {active = false}})
end)

local pbWeaponLabels = {}
CreateThread(function()
    for _, w in ipairs(paintballConfig.weapons or {}) do
        if w.model then pbWeaponLabels[GetHashKey(w.model)] = w.label or w.model end
    end
end)

local pbLastSpectInfoAt = 0
local pbSpectInfoShown = false
local function pbUpdateSpectateInfo()
    local now = GetGameTimer()
    if now - pbLastSpectInfoAt < 350 then return end
    pbLastSpectInfoAt = now
    local pid = PB.matchSpectate.currentPid
    local ped = PB.matchSpectate.currentTarget
    if pid and pid ~= -1 and ped and ped ~= 0 and DoesEntityExist(ped) then
        local whash = GetSelectedPedWeapon(ped)
        local hd = PB.playerHp[tostring(pid)] or {}
        SUN.SendUIData(PB.HUD, {type = 'spectateInfo', payload = {
            active = true,
            name = GetPlayerName(pid) or '—',
            weapon = pbWeaponLabels[whash] or 'دست خالی',
            hpFrac = hd.hp or 1.0,
            armor = hd.ar or 0,
        }})
        pbSpectInfoShown = true
    elseif pbSpectInfoShown then
        SUN.SendUIData(PB.HUD, {type = 'spectateInfo', payload = {active = false}})
        pbSpectInfoShown = false
    end
end

local function pbHideSpectateInfo()
    if pbSpectInfoShown then
        SUN.SendUIData(PB.HUD, {type = 'spectateInfo', payload = {active = false}})
        pbSpectInfoShown = false
    end
end

local spectateRunning = false
local function startSpectate()
    if spectateRunning then return end
    spectateRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if PB.matchSpectate.active then
                pbUpdateSpectateInfo()
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 263, true)
                DisableControlAction(0, 264, true)

                local cur = PB.matchSpectate.currentTarget
                local curPid = PB.matchSpectate.currentPid
                if not pbAllowToSpec(curPid, cur) then
                    local pid, tped, foundIdx = pbResolveTargetByIdx(PB.matchSpectate.idx or 1)
                    if pid and tped then
                        PB.matchSpectate.idx = foundIdx
                        PB.matchSpectate.currentTarget = tped
                        PB.matchSpectate.currentPid = pid
                        pbApplySpectate(tped)
                    elseif cur then
                        PB.matchSpectate.currentTarget = nil
                        PB.matchSpectate.currentPid = nil
                        NetworkSetInSpectatorMode(false, 0)
                    end
                end

                if IsControlJustPressed(1, 40) then
                    pbSpectateNext(1)
                elseif IsControlJustPressed(1, 39) then
                    pbSpectateNext(-1)
                end
                Wait(0)
            else
                pbHideSpectateInfo()
                Wait(800)
            end
        end
        spectateRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startSpectate)
