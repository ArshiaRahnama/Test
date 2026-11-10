-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PB = PB or {}
PB.MODULE = PB.MODULE or 'paintball'
PB.HUD = PB.HUD or 'paintball-hud'
PB.ATTACH = PB.ATTACH or 'paintball-attach'
PB.SCORE = PB.SCORE or 'paintball-score'
PB.state = PB.state or {selectedAttachments = {}, perks = {}, inMatch = false, inLobby = false, spectator = false}
PB.state.selectedAttachments = PB.state.selectedAttachments or {}
PB.state.perks = PB.state.perks or {}
PB.flags = PB.flags or {}

local function dbg(...)
    if paintballConfig and paintballConfig.debug then
        print('[PB-DEBUG][client]', ...)
    end
end
PB.dbg = dbg

PB.applyAttachments = function(weaponModel, attachments)
    dbg('applyAttachments', weaponModel, json.encode(attachments or {}))
    PB.state.selectedAttachments[weaponModel] = attachments or {}
    local weaponHash = GetHashKey(weaponModel)
    if not HasPedGotWeapon(SUN.ped, weaponHash, false) then
        dbg('applyAttachments: ped does not have weapon', weaponModel)
        return
    end

    local catalog = paintballConfig.attachmentCatalog
    for group, cat in pairs(catalog) do
        if group ~= 'tint' then
            local hash = cat.components and cat.components[weaponModel]
            if hash and HasPedGotWeaponComponent(SUN.ped, weaponHash, hash) then
                RemoveWeaponComponentFromPed(SUN.ped, weaponHash, hash)
            end
        end
    end

    local function applyGroup(g)
        local cat = catalog[g]
        local hash = cat and cat.components and cat.components[weaponModel]
        if hash then GiveWeaponComponentToPed(SUN.ped, weaponHash, hash) end
    end

    local atts = attachments or {}
    local tintIdx = nil
    if type(atts.groups) == 'table' then
        for _, g in ipairs(atts.groups) do
            applyGroup(g)
        end
        if atts.tint ~= nil and tonumber(atts.tint) then tintIdx = tonumber(atts.tint) end
    else
        for group, info in pairs(atts) do
            if group == 'tint' then
                if type(info) == 'table' then tintIdx = tonumber(info.hash) or 0
                elseif type(info) == 'number' then tintIdx = info end
            else
                local hash = nil
                if type(info) == 'table' and info.hash then
                    hash = info.hash
                elseif info then
                    local cat = catalog[group]
                    hash = cat and cat.components and cat.components[weaponModel]
                end
                if hash then GiveWeaponComponentToPed(SUN.ped, weaponHash, hash) end
            end
        end
    end
    if tintIdx ~= nil then
        SetPedWeaponTintIndex(SUN.ped, weaponHash, tintIdx)
        CreateThread(function()
            for _ = 1, 8 do
                Wait(50)
                if not HasPedGotWeapon(SUN.ped, weaponHash, false) then return end
                local sel = PB.state.selectedAttachments[weaponModel]
                local curTint = sel and (type(sel.tint) == 'table' and sel.tint.hash or sel.tint)
                if tonumber(curTint) ~= tintIdx then return end
                SetPedWeaponTintIndex(SUN.ped, weaponHash, tintIdx)
            end
        end)
    end
end

PB.resetWeaponTints = function()
    local ped = SUN.ped
    if not ped or ped == 0 then return end
    for _, w in ipairs(paintballConfig.weapons or {}) do
        local hash = GetHashKey(w.model)
        if HasPedGotWeapon(ped, hash, false) then
            SetPedWeaponTintIndex(ped, hash, 0)
        end
    end
end

local activePerkFlags = {jump = false, reload = false, recoil = false, silent = false, aim = false, thermal = false, nightvision = false}

PB.applyPerk = function(perk, duration)
    dbg('applyPerk called', perk and perk.key, perk and perk.type, 'duration', duration)
    if not perk then dbg('applyPerk: perk is nil'); return end
    duration = duration or 18
    pcall(function() exports['suncore']:Whitelist(true) end)
    local pid = SUN.PlayerId
    local ped = SUN.ped
    local effectiveDuration = duration
    if perk.type == 'slide' then effectiveDuration = 1 end
    if perk.type == 'armor' or perk.type == 'heal' or perk.type == 'ammo' then effectiveDuration = 0.5 end
    PB.activePerkUntil = (GetGameTimer() / 1000) + effectiveDuration
    PB.activePerkKey = perk.key
    SetTimeout(math.ceil(effectiveDuration * 1000) + 50, function()
        PB.activePerkUntil = 0
        PB.activePerkKey = nil
    end)

    if perk.type == 'movement' then
        SetRunSprintMultiplierForPlayer(pid, math.min(1.49, perk.value or 1.25))
        SetTimeout(duration * 1000, function()
            SetRunSprintMultiplierForPlayer(SUN.PlayerId, 1.0)
        end)
    elseif perk.type == 'jump' then
        activePerkFlags.jump = true
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            while GetGameTimer() < endAt and activePerkFlags.jump do
                SetSuperJumpThisFrame(SUN.PlayerId)
                Wait(0)
            end
            activePerkFlags.jump = false
        end)
    elseif perk.type == 'reload' then
        activePerkFlags.reload = true
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            local lastClipAmmo = nil
            local lastWeapon = nil
            local emptyDetectedAt = nil
            while GetGameTimer() < endAt and activePerkFlags.reload do
                local ped = SUN.ped
                local _, weapon = GetCurrentPedWeapon(ped, true)
                if weapon and weapon ~= 0 then
                    local _, maxClip = GetMaxAmmoInClip(ped, weapon, true)
                    local _, curClip = GetAmmoInClip(ped, weapon)
                    if weapon ~= lastWeapon then
                        lastWeapon = weapon
                        lastClipAmmo = curClip
                        emptyDetectedAt = nil
                    end
                    local reloading = IsPedReloading(ped)
                    local clipDropped = lastClipAmmo and curClip and curClip < lastClipAmmo
                    local now = GetGameTimer()
                    if maxClip and maxClip > 0 then
                        if reloading and curClip < maxClip then
                            SetAmmoInClip(ped, weapon, maxClip)
                            ClearPedSecondaryTask(ped)
                            emptyDetectedAt = nil
                        elseif curClip == 0 and maxClip > 0 then
                            if not emptyDetectedAt then emptyDetectedAt = now end
                            if now - emptyDetectedAt > 200 then
                                SetAmmoInClip(ped, weapon, maxClip)
                                ClearPedSecondaryTask(ped)
                                emptyDetectedAt = nil
                            end
                        else
                            emptyDetectedAt = nil
                        end
                    end
                    lastClipAmmo = curClip
                end
                Wait(0)
            end
            activePerkFlags.reload = false
        end)
    elseif perk.type == 'recoil' then
        activePerkFlags.recoil = true
        SetPlayerWeaponDamageModifier(pid, 1.1)
        StopGameplayCamShaking(true)
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            while GetGameTimer() < endAt and activePerkFlags.recoil do
                SetPedShootRate(SUN.ped, 1000)
                SetPedAccuracy(SUN.ped, 100)
                if IsGameplayCamShaking() then StopGameplayCamShaking(true) end
                Wait(0)
            end
            SetPlayerWeaponDamageModifier(SUN.PlayerId, 1.0)
            activePerkFlags.recoil = false
        end)
    elseif perk.type == 'armor' then
        local cur = GetPedArmour(ped)
        ESX.SetPedArmour(ped, math.min(100, cur + (perk.value or 50)))
    elseif perk.type == 'heal' then
        ESX.SetEntityHealth(ped, math.min(GetEntityMaxHealth(ped), GetEntityHealth(ped) + (perk.value or 50)))
    elseif perk.type == 'stealth' then
        SetPlayerNoiseMultiplier(pid, 0.0)
        SetPedStealthMovement(ped, true, '')
        SetTimeout(duration * 1000, function()
            SetPlayerNoiseMultiplier(SUN.PlayerId, 1.0)
            SetPedStealthMovement(SUN.ped, false, '')
        end)
    elseif perk.type == 'damage' then
        SetPlayerWeaponDamageModifier(pid, perk.value or 1.25)
        SetTimeout(duration * 1000, function()
            SetPlayerWeaponDamageModifier(SUN.PlayerId, 1.0)
        end)
    elseif perk.type == 'silent' then
        activePerkFlags.silent = true
        SetPlayerNoiseMultiplier(pid, 0.0)
        pcall(function() SetPedAudioFootstepLoud(ped, false) end)
        pcall(function() SetPedAudioFootstepQuiet(ped, true) end)
        SetTimeout(duration * 1000, function()
            SetPlayerNoiseMultiplier(SUN.PlayerId, 1.0)
            pcall(function() SetPedAudioFootstepLoud(SUN.ped, true) end)
            pcall(function() SetPedAudioFootstepQuiet(SUN.ped, false) end)
            activePerkFlags.silent = false
        end)
    elseif perk.type == 'aim' then
        activePerkFlags.aim = true
        SetPlayerWeaponDamageModifier(pid, perk.value or 1.4)
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            while GetGameTimer() < endAt and activePerkFlags.aim do
                SetPedShootRate(SUN.ped, 500)
                Wait(0)
            end
            SetPlayerWeaponDamageModifier(SUN.PlayerId, 1.0)
            activePerkFlags.aim = false
        end)
    elseif perk.type == 'ammo' then
        local _, weapon = GetCurrentPedWeapon(ped, true)
        if weapon and weapon ~= 0 then
            local maxAmmoRet, maxAmmo = GetMaxAmmo(ped, weapon)
            local _, maxClip = GetMaxAmmoInClip(ped, weapon, true)
            local target = (maxAmmoRet and maxAmmo and maxAmmo > 0) and maxAmmo or 250
            SetPedAmmo(ped, weapon, target)
            if maxClip and maxClip > 0 then SetAmmoInClip(ped, weapon, maxClip) end
        end
    elseif perk.type == 'thermal' then
        activePerkFlags.thermal = true
        SetSeethrough(true)
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            while GetGameTimer() < endAt and activePerkFlags.thermal do
                Wait(250)
            end
            SetSeethrough(false)
            activePerkFlags.thermal = false
        end)
    elseif perk.type == 'nightvision' then
        activePerkFlags.nightvision = true
        SetNightvision(true)
        CreateThread(function()
            local endAt = GetGameTimer() + (duration * 1000)
            while GetGameTimer() < endAt and activePerkFlags.nightvision do
                Wait(250)
            end
            SetNightvision(false)
            activePerkFlags.nightvision = false
        end)
    elseif perk.type == 'slide' then
        local boost = perk.value or 1.3
        local heading = GetEntityHeading(ped)
        local rad = math.rad(heading)
        local fwdX = -math.sin(rad)
        local fwdY = math.cos(rad)
        SetPlayerInvincible(pid, true)
        SetEntityVelocity(ped, fwdX * 22.0 * boost, fwdY * 22.0 * boost, -2.0)
        local dict = 'move_crouch_proto'
        ESX.Streaming.RequestAnimDict(dict)
        if HasAnimDictLoaded(dict) then
            TaskPlayAnim(ped, dict, 'idle_intro', 8.0, -4.0, 900, 49, 0, false, false, false)
        end
        local trailEffect = 'core'
        ESX.Streaming.RequestNamedPtfxAsset(trailEffect)
        CreateThread(function()
            local startedAt = GetGameTimer()
            local endAt = startedAt + 900
            local tick = 0
            while GetGameTimer() < endAt do
                local elapsed = GetGameTimer() - startedAt
                local progress = elapsed / 900
                local decay = 1.0 - progress * 0.6
                local cur = GetEntityVelocity(SUN.ped)
                SetEntityVelocity(SUN.ped, fwdX * 22.0 * boost * decay, fwdY * 22.0 * boost * decay, math.min(cur.z, -3.0))
                if HasNamedPtfxAssetLoaded(trailEffect) and tick % 2 == 0 then
                    UseParticleFxAssetNextCall(trailEffect)
                    local feet = GetEntityCoords(SUN.ped) - vec3(0, 0, 0.9)
                    StartParticleFxNonLoopedAtCoord('ent_amb_smoke_foundry', feet.x, feet.y, feet.z, 0.0, 0.0, 0.0, 0.5, false, false, false)
                end
                tick = tick + 1
                Wait(0)
            end
            SetPlayerInvincible(SUN.PlayerId, false)
            ClearPedTasks(SUN.ped)
        end)
    end
end

PB.cancelActivePerks = function()
    for k in pairs(activePerkFlags) do
        activePerkFlags[k] = false
    end
    PB.activePerkUntil = 0
    PB.activePerkKey = nil
    local pid = SUN.PlayerId
    local ped = SUN.ped
    pcall(function() SetRunSprintMultiplierForPlayer(pid, 1.0) end)
    pcall(function() SetPlayerWeaponDamageModifier(pid, 1.0) end)
    pcall(function() SetPlayerNoiseMultiplier(pid, 1.0) end)
    pcall(function() SetSeethrough(false) end)
    pcall(function() SetNightvision(false) end)
    pcall(function() SetPlayerInvincible(pid, false) end)
    if ped and ped ~= 0 then
        pcall(function() SetPedStealthMovement(ped, false, '') end)
        pcall(function() SetPedAudioFootstepLoud(ped, true) end)
        pcall(function() SetPedAudioFootstepQuiet(ped, false) end)
    end
end

local lastWeapon = nil
local weaponSwapRunning = false
local function startWeaponSwap()
    if weaponSwapRunning then return end
    weaponSwapRunning = true
    CreateThread(function()
        while PB.state.inMatch do
            if PB.state.inMatch and not PB.state.spectator then
                local weapon = GetSelectedPedWeapon(SUN.ped)
                if weapon ~= lastWeapon then
                    lastWeapon = weapon
                    local model = nil
                    for _, w in ipairs(paintballConfig.weapons) do
                        if GetHashKey(w.model) == weapon then model = w.model break end
                    end
                    if model then
                        SUN.SendUIData(PB.HUD, {type = 'weaponSwap', payload = {weapon = model}})
                    end
                end
            end
            Wait(500)
        end
        weaponSwapRunning = false
    end)
end
AddEventHandler('paintball:matchThreads', startWeaponSwap)

local attachOpen = false

local function openAttach()
    dbg('openAttach called', 'inMatch=', PB.state.inMatch, 'spectator=', PB.state.spectator, 'weapon=', PB.state.weapon, 'attachOpen=', attachOpen)
    if not PB.state.inMatch or PB.state.spectator then
        dbg('openAttach: blocked (not in match or spectator)')
        return
    end
    if attachOpen then dbg('openAttach: already open'); return end
    local weapon = PB.state.weapon
    if not weapon then
        dbg('openAttach: no weapon set')
        ESX.notification('error', 'aslahe ee dar dast nadari')
        return
    end
    attachOpen = true
    dbg('openAttach: requesting server callback for', weapon)
    ESX.TriggerServerCallback('paintball:getAttachments', function(data)
        dbg('openAttach: server returned', data and json.encode(data) or 'nil')
        if not data then
            attachOpen = false
            ESX.notification('error', 'attachment data dariaft nashod')
            return
        end
        dbg('openAttach: opening UI ATTACH module=', PB.ATTACH, 'list count=', data.list and #data.list)
        SUN.OpenUI(PB.ATTACH, {
            view = 'attachments',
            weapon = weapon,
            list = data.list or {},
            current = data.current or {},
            flags = PB.flags,
        }, {type = 'panel', path = PB.MODULE, focus = true, cursor = true})
    end, weapon)
end

local function closeAttach()
    if not attachOpen then return end
    attachOpen = false
    SUN.CloseUI(PB.ATTACH)
end

local function toggleAttach()
    if attachOpen then closeAttach() else openAttach() end
end

AddEventHandler('sunset_utils:uiClosed', function(name)
    if name == PB.ATTACH then
        attachOpen = false
    end
end)

local _attachActionCooldowns = {}
local ATTACH_ACTION_COOLDOWNS = {
    toggleAttachment = 300,
    setTint = 300,
    requestAttachments = 800,
}

local function attachActionAllowed(action)
    local cd = ATTACH_ACTION_COOLDOWNS[action]
    if not cd then return true end
    local now = GetGameTimer()
    local last = _attachActionCooldowns[action] or 0
    if now - last < cd then return false end
    _attachActionCooldowns[action] = now
    return true
end

AddEventHandler('sunset_utils:uiCallback:'..PB.ATTACH, function(action, data)
    if not attachActionAllowed(action) then return end
    if action == 'toggleAttachment' then
        TriggerServerEvent('paintball:toggleAttachment', data.weapon, data.group, data.enable)
    elseif action == 'setTint' then
        TriggerServerEvent('paintball:setWeaponTint', data.weapon, data.tintIndex)
    elseif action == 'requestAttachments' then
        ESX.TriggerServerCallback('paintball:getAttachments', function(result)
            SUN.SendUIData(PB.ATTACH, {type = 'attachments', payload = {weapon = data.weapon, list = result.list, current = result.current}})
        end, data.weapon)
    elseif action == 'close' or action == 'escape' then
        attachOpen = false
        SUN.CloseUI(PB.ATTACH)
    end
end)

local perkCooldowns = {}
local perkLastAttempt = {}
local perkLastNotif = {}
local PERK_PRESS_DEBOUNCE = 500
local PERK_NOTIF_THROTTLE = 3000

local function notifyThrottled(slot, kind, message)
    local now = GetGameTimer()
    local key = (slot or 0) .. ':' .. kind
    local last = perkLastNotif[key] or 0
    if now - last < PERK_NOTIF_THROTTLE then return end
    perkLastNotif[key] = now
    ESX.notification(kind, message)
end

function PB.tryActivatePerk(slot)
    local nowMs = GetGameTimer()
    local lastAttempt = perkLastAttempt[slot] or 0
    if nowMs - lastAttempt < PERK_PRESS_DEBOUNCE then return end
    perkLastAttempt[slot] = nowMs

    dbg('tryActivatePerk slot=', slot, 'inMatch=', PB.state.inMatch, 'spectator=', PB.state.spectator)
    if not PB.state.inMatch then return end
    if PB.state.perksEnabled == false then
        notifyThrottled(slot, 'error', 'perks در این مچ غیرفعاله')
        return
    end
    if PB.state.spectator then
        notifyThrottled(slot, 'error', 'shoma spectator hastid')
        return
    end
    if PB.state.matchSpectating or PB.state.deathReported then
        notifyThrottled(slot, 'error', 'shoma dead hastid')
        return
    end
    if PB.state.perkUsableAt and nowMs < PB.state.perkUsableAt then
        local left = math.ceil((PB.state.perkUsableAt - nowMs) / 1000)
        notifyThrottled(slot, 'error', ('%d ثانیه تا فعال شدن perk ها'):format(left))
        return
    end
    if not PB.state.perks or not PB.state.perks[slot] then
        notifyThrottled(slot, 'error', ('perk slot %d entekhab nashode'):format(slot))
        return
    end
    local now = nowMs / 1000
    if PB.activePerkUntil and PB.activePerkUntil > now then
        local left = math.ceil(PB.activePerkUntil - now)
        notifyThrottled(slot, 'error', ('یک perk فعاله — %d ثانیه صبر کن'):format(left))
        return
    end
    if perkCooldowns[slot] and perkCooldowns[slot] > now then
        local left = math.ceil(perkCooldowns[slot] - now)
        notifyThrottled(slot, 'error', ('cooldown: %ds'):format(left))
        return
    end
    local cd = (paintballConfig.perkSystem and paintballConfig.perkSystem.perkCooldown or 30)
    local dur = (paintballConfig.perkSystem and paintballConfig.perkSystem.perkDuration or 18)
    perkCooldowns[slot] = now + cd
    PB.activePerkUntil = now + dur
    SUN.SendUIData(PB.HUD, {type = 'perkActivate', payload = {slot = slot, duration = dur, cooldown = cd}})
    dbg('tryActivatePerk: triggering server event with perkKey=', PB.state.perks[slot])
    TriggerServerEvent('paintball:activatePerk', PB.state.perks[slot])
    ESX.notification('success', ('perk %d feal shod'):format(slot))
end

RegisterNetEvent('paintball:remotePerkApply', function(payload)
    if not payload or not payload.src or not payload.perk then return end
    local target = GetPlayerFromServerId(payload.src)
    if target == -1 then return end
    local targetPed = GetPlayerPed(target)
    if not DoesEntityExist(targetPed) then return end
    local duration = payload.duration or 18
    if payload.perk.type == 'silent' or payload.perk.type == 'stealth' then
        pcall(function() SetPedAudioFootstepLoud(targetPed, false) end)
        pcall(function() SetPedAudioFootstepQuiet(targetPed, true) end)
        SetTimeout(duration * 1000, function()
            local stillThere = GetPlayerFromServerId(payload.src)
            if stillThere == -1 then return end
            local p = GetPlayerPed(stillThere)
            if not DoesEntityExist(p) then return end
            pcall(function() SetPedAudioFootstepLoud(p, true) end)
            pcall(function() SetPedAudioFootstepQuiet(p, false) end)
        end)
    end
end)

AddEventHandler('onKeyDown', function(key)
    if key == 'b' or key == 'numpad1' or key == 'numpad2' or key == 'numpad3' or key == '1' or key == '2' or key == '3' then
        dbg('onKeyDown', key, 'inMatch=', PB.state.inMatch, 'spectator=', PB.state.spectator)
    end
    if not PB.state.inMatch or PB.state.spectator then return end
    if key == 'b' then
        toggleAttach()
    elseif key == 'numpad1' then
        PB.tryActivatePerk(1)
    elseif key == 'numpad2' then
        PB.tryActivatePerk(2)
    elseif key == 'numpad3' then
        PB.tryActivatePerk(3)
    end
end)

RegisterCommand('pbattach', function()
    dbg('command /pbattach fired', 'inMatch=', PB.state.inMatch, 'spectator=', PB.state.spectator)
    if not PB.state.inMatch or PB.state.spectator then
        dbg('/pbattach blocked - not in match or spectator')
        return
    end
    toggleAttach()
end)

RegisterCommand('pbperk1', function()
    dbg('command /pbperk1 fired')
    PB.tryActivatePerk(1)
end)

RegisterCommand('pbperk2', function()
    dbg('command /pbperk2 fired')
    PB.tryActivatePerk(2)
end)

RegisterCommand('pbperk3', function()
    dbg('command /pbperk3 fired')
    PB.tryActivatePerk(3)
end)

do
    local kb = (paintballConfig.perkSystem and paintballConfig.perkSystem.keybinds) or {}
    RegisterKeyMapping('pbperk1', 'Paintball - فعال‌سازی perk اسلات ۱', 'keyboard', kb[1] or 'NUMPAD1')
    RegisterKeyMapping('pbperk2', 'Paintball - فعال‌سازی perk اسلات ۲', 'keyboard', kb[2] or 'NUMPAD2')
    RegisterKeyMapping('pbperk3', 'Paintball - فعال‌سازی perk اسلات ۳', 'keyboard', kb[3] or 'NUMPAD3')
end

RegisterCommand('pbleave', function()
    if PB.state.starting then
        if ESX and ESX.notification then ESX.notification('error', 'مچ در حال شروعه — الان نمیتونی خارج شی') end
        return
    end
    if PB.state.inMatch then
        TriggerServerEvent('paintball:leaveMatch')
    elseif PB.state.inLobby then
        TriggerServerEvent('paintball:leaveLobby')
    end
end)
RegisterKeyMapping('pbleave', 'Paintball - خروج از لابی/مچ', 'keyboard', '')

RegisterCommand('pbhostend', function()
    if not PB.state.inMatch then return end
    if PB.state.isHost then
        TriggerServerEvent('paintball:hostEndMatch')
    elseif ESX and ESX.notification then
        ESX.notification('error', 'فقط هاست میتونه مچ رو تموم کنه')
    end
end)
RegisterKeyMapping('pbhostend', 'Paintball - پایان مچ (هاست)', 'keyboard', '')

RegisterCommand('pbstate', function()
    print('[PB-STATE] inMatch=', PB.state.inMatch, 'inLobby=', PB.state.inLobby, 'spectator=', PB.state.spectator)
    print('[PB-STATE] mode=', PB.state.mode, 'map=', PB.state.map, 'team=', PB.state.team)
    print('[PB-STATE] weapon=', PB.state.weapon, 'matchId=', PB.state.matchId)
    print('[PB-STATE] perks=', json.encode(PB.state.perks or {}))
    print('[PB-STATE] flags=', json.encode(PB.flags or {}))
end)
