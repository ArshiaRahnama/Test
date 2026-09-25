-- Unique_AdminPanel | client/nlr.lua  -  New Life Rule, client side (runs INSIDE the panel)
-- Same local events as your old anti-NonRP script (antiNonRP:setNewLifeData / startNewLifeThread /
-- startReviveThread / stopReviveThread), same net event (antiNonRP:clearNewLifeData) and same
-- ESX only: the old SUN / alarm / GetServerOSTime globals belonged to another resource, so they were
-- replaced by natives (GetCloudTimeAsInt, GetEntityCoords ...) and a server-side admin alert.
--
-- What changed (see the notes at the bottom of the chat message for the reasons):
--   * ONE monitor thread instead of a new thread per death (the old code stacked threads and
--     duplicated warnings/alarms; `thread` was a shared flag that new threads re-enabled)
--   * the server now owns the record (client KVP is only an offline fallback), so clearing or
--     editing KVP no longer removes your New Life status
--   * red zone on the player's own map + on-screen countdown
--   * escalation: sustained presence in the core radius files a violation with the server
--   * revive protection uses an expiry timestamp (old code: an earlier timer could end a newer one)
--   * adaptive sleeping: nothing runs at 0 ms unless the player is actually near the zone

local Cfg = NLRConfig

local data          = nil    -- { coords = vector3, expiresAt = serverOsTime }
local watching      = false  -- monitoring active (set by startNewLifeThread, after respawn)
local pendingStart  = false  -- died, but not started yet (old name: lossData)
local zoneBlip      = nil
local nearDist      = 9999.0 -- last measured distance, used by the HUD
local inCore        = false
local coreSeconds   = 0
local NEVER = -1e9   -- 'long ago' (GetGameTimer can be small right after the game starts)
local lastSelfWarn, lastAlarm, lastViolation = NEVER, NEVER, NEVER
local reviveUntil   = 0
local reviveRunning = false

-- UTC epoch seconds, same clock as the server's os.time() (was the old resource's GetServerOSTime)
local function serverNow() return GetCloudTimeAsInt() end

local function playerData()
    local ok, pd = pcall(ESX.GetPlayerData)
    return (ok and pd) or {}
end

local function isIsland()
    return playerData().isInIslandZone
end

local function toVec(t)
    if not t then return nil end
    return vector3(t.x + 0.0, t.y + 0.0, t.z + 0.0)
end

-- ------------------------------------------------------------------ blip ---

local function removeBlip()
    if zoneBlip and DoesBlipExist(zoneBlip) then RemoveBlip(zoneBlip) end
    zoneBlip = nil
end

local function makeBlip()
    removeBlip()
    if not data then return end
    zoneBlip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, Cfg.WarnRadius)
    SetBlipColour(zoneBlip, Cfg.Blip.Colour)
    SetBlipAlpha(zoneBlip, Cfg.Blip.Alpha)
end

-- ------------------------------------------------------------ data state ---

local function saveFallback()
    -- offline fallback only; the server copy is the one that counts
    if data then
        SetResourceKvp('deadData', json.encode({ coords = { x = data.coords.x, y = data.coords.y, z = data.coords.z }, ts = data.expiresAt }))
    else
        SetResourceKvp('deadData', json.encode({}))
    end
end

local function clearData()
    data, watching, pendingStart = nil, false, false
    coreSeconds, nearDist, inCore = 0, 9999.0, false
    removeBlip()
    saveFallback()
end

local function setData(coords, expiresAt)
    data = { coords = coords, expiresAt = expiresAt }
    coreSeconds, lastSelfWarn, lastAlarm = 0, NEVER, NEVER
    makeBlip()
    saveFallback()
end

-- ----------------------------------------------------------------- events ---

AddEventHandler('antiNonRP:setNewLifeData', function()
    if isIsland() or GetGameTimer() < (NLRSkipUntil or 0) then return end   -- (VDM victims get no New Life)
    local coords = GetEntityCoords(PlayerPedId())
    setData(coords, serverNow() + Cfg.Duration)
    pendingStart, watching = true, false
    TriggerServerEvent('antiNonRP:sv:died', { x = coords.x, y = coords.y, z = coords.z })
end)

AddEventHandler('antiNonRP:startNewLifeThread', function()
    if not data or isIsland() then return end
    pendingStart, watching = false, true
    TriggerServerEvent('antiNonRP:sv:started')
end)

RegisterNetEvent('antiNonRP:clearNewLifeData', function(force)
    if pendingStart or force then clearData() end
end)

-- server-authoritative record (login, resource restart)
RegisterNetEvent('antiNonRP:cl:record', function(rec)
    if rec and rec.coords and rec.expiresAt and rec.expiresAt > serverNow() and not isIsland() then
        setData(toVec(rec.coords), rec.expiresAt)
        pendingStart, watching = false, true
    elseif rec == false then
        clearData()
    end
end)

RegisterNetEvent('antiNonRP:cl:clear', function() clearData() end) -- also fired locally (vdm.lua)

RegisterNetEvent('antiNonRP:cl:finalWarning', function(strikes)
    if UapToast then UapToast('danger', ('اخطار نهایی نیو لایف (%s)'):format(strikes or 1), { 'فوراً از این منطقه خارج شو', 'ادمین‌ها خبردار شدن' }, 9000) end
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding:0.5vw;direction:rtl;margin:0.5vw;background-color:rgba(255,0,0,0.5);border-radius:3px;">{0}</div>',
        args = { ('اخطار نهایی (%s): از منطقه‌ی نیو لایف فوراً خارج شو!'):format(strikes or 1) },
    })
end)

-- admins: alert with a flashing blip
RegisterNetEvent('antiNonRP:cl:adminAlert', function(info)
    if not info or not info.coords then return end
    PlaySoundFrontend(-1, 'CHALLENGE_UNLOCKED', 'HUD_AWARDS', true)
    local b = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
    SetBlipSprite(b, 161); SetBlipColour(b, 1); SetBlipScale(b, 1.1)
    SetBlipFlashes(b, true)
    BeginTextCommandSetBlipName('STRING'); AddTextComponentString(('NLR: [%s] %s'):format(info.id, info.name)); EndTextCommandSetBlipName(b)
    SetTimeout(60000, function() if DoesBlipExist(b) then RemoveBlip(b) end end)
end)

-- --------------------------------------------------------------- monitor ---

local function warnPlayer()
    local t = GetGameTimer()
    if t - lastSelfWarn < Cfg.SelfWarnCooldown * 1000 then return end
    lastSelfWarn = t
    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; direction: rtl; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.4); border-radius: 3px;"><i class="far fa-newspaper"></i><br>  {1}</div>',
        args = { 'System', Cfg.Text.Warn },
    })
    TriggerEvent('MpGameMessage:send', 'Ekhtar', Cfg.Text.GameMessage, 10000, 'success')
    if UapToast then UapToast('warn', 'منطقه‌ی نیو لایف', { 'از مکان مرگت فاصله بگیر', 'ماندن اینجا = اخطار و برخورد' }, 7000) end
end

local function alarmAdmins()
    local t = GetGameTimer()
    if t - lastAlarm < Cfg.AdminAlarmCooldown * 1000 then return end
    lastAlarm = t
    TriggerServerEvent('antiNonRP:sv:near')
end

CreateThread(function()
    -- wait for the server clock, then ask the server for our record (falls back to KVP)
    while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
    Wait(6000)
    TriggerServerEvent('antiNonRP:sv:requestRecord')
    Wait(8000)
    if not data then
        local raw = GetResourceKvpString('deadData')
        local kvp = raw and json.decode(raw)
        if kvp and kvp.ts and kvp.ts > serverNow() and kvp.coords and not isIsland() then
            setData(toVec(kvp.coords), kvp.ts)
            pendingStart, watching = false, true
        end
    end
end)

CreateThread(function()
    while true do
        if not (data and watching) then
            Wait(2000)
        else
            if data.expiresAt <= serverNow() then
                clearData()
                Wait(2000)
            else
                local ped = PlayerPedId()
                local pd = playerData()
                local dist = #(GetEntityCoords(ped) - data.coords)
                nearDist = dist
                local eligible = (pd.World or 0) == 0 and not pd.inNCZ and not IsEntityDead(ped)
                local inZone = eligible and dist < Cfg.WarnRadius
                inCore = eligible and dist < Cfg.CoreRadius
                local step = (dist < Cfg.WarnRadius + 100.0) and 1000 or 3000

                if inZone then warnPlayer() end
                if inCore then
                    alarmAdmins()
                    coreSeconds = coreSeconds + step / 1000
                    if coreSeconds >= Cfg.ViolationSeconds and GetGameTimer() - lastViolation > Cfg.ViolationCooldown * 1000 then
                        lastViolation, coreSeconds = GetGameTimer(), 0
                        TriggerServerEvent('antiNonRP:sv:violation', math.floor(dist))
                    end
                else
                    coreSeconds = math.max(0, coreSeconds - step / 500) -- decays twice as fast as it grows
                end
                Wait(step)
            end
        end
    end
end)

-- ------------------------------------------------------------------- HUD ---

local function drawText(text, x, y, r, g, b, scale)
    SetTextFont(4); SetTextScale(scale, scale); SetTextColour(r, g, b, 230); SetTextOutline(); SetTextCentre(true)
    BeginTextCommandDisplayText('STRING'); AddTextComponentSubstringPlayerName(text); EndTextCommandDisplayText(x, y)
end

local function mmss(sec) sec = math.max(0, math.floor(sec)); return ('%d:%02d'):format(sec // 60, sec % 60) end

CreateThread(function()
    while true do
        local drawing = false
        if Cfg.Hud then
            if data and watching and nearDist < Cfg.WarnRadius + 60.0 then
                drawing = true
                local left = data.expiresAt - serverNow()
                if inCore then
                    drawText(('~r~NEW LIFE ZONE~s~ - LEAVE NOW  (%s)'):format(mmss(left)), 0.5, 0.90, 255, 60, 60, 0.5)
                else
                    drawText(('New Life zone  |  %s left  |  stay %dm away'):format(mmss(left), math.floor(Cfg.WarnRadius)), 0.5, 0.90, 255, 200, 90, 0.4)
                end
            end
            if GetGameTimer() < reviveUntil then
                drawing = true
                drawText(('Revive protection: %s'):format(mmss((reviveUntil - GetGameTimer()) / 1000)), 0.5, 0.94, 120, 200, 255, 0.38)
            end
        end
        Wait(drawing and 0 or 500)
    end
end)

-- --------------------------------------------------------- revive protection ---

local function startReviveLoop()
    if reviveRunning then return end
    reviveRunning = true
    CreateThread(function()
        while GetGameTimer() < reviveUntil do
            local ped = PlayerPedId()
            if Cfg.Revive.Mode == 'block' then
                DisableControlAction(0, 21, true)  -- sprint
                DisableControlAction(0, 24, true)  -- attack
                DisableControlAction(0, 25, true)  -- aim
                DisableControlAction(0, 22, true)  -- jump
                Wait(0)
            else
                if IsPedRunning(ped) or IsPedSprinting(ped) then
                    SetPedToRagdoll(ped, Cfg.Revive.Ragdoll, Cfg.Revive.Ragdoll, 0, 0, 0, 0)
                end
                Wait(1000)
            end
        end
        reviveRunning = false
    end)
end

AddEventHandler('antiNonRP:startReviveThread', function()
    if isIsland() or GetGameTimer() < (NLRSkipUntil or 0) then return end   -- VDM victims get no revive handicap
    reviveUntil = GetGameTimer() + Cfg.Revive.Duration * 1000  -- an expiry, so a newer revive can't be cut short by an older timer
    startReviveLoop()
end)

AddEventHandler('antiNonRP:stopReviveThread', function()
    reviveUntil = 0
end)

local function ripHandler()
    if Cfg.Revive.Mode ~= 'ragdoll' then return end
    if GetGameTimer() < reviveUntil and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('weapon_stungun') then
        Wait(200)
        SetPedToRagdoll(PlayerPedId(), Cfg.Revive.Ragdoll, Cfg.Revive.Ragdoll, 0, 0, 0, 0)
    end
end

AddEventHandler('KeyDown:space', ripHandler)
AddEventHandler('KeyDown:mouse_left', ripHandler)
AddEventHandler('KeyDown:mouse_right', ripHandler)

-- ---------------------------------------------------------------- command ---
RegisterCommand('nlr', function()
    if not data then
        TriggerEvent('chat:addMessage', { args = { '^2NLR', 'شما الان محدودیت نیو لایف ندارید.' } })
        return
    end
    local left = data.expiresAt - serverNow()
    TriggerEvent('chat:addMessage', { args = { '^3NLR', ('%s باقی مانده - شعاع ممنوعه %dm (روی نقشه قرمز)'):format(mmss(left), math.floor(Cfg.WarnRadius)) } })
end, false)
