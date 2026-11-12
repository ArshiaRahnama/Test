-- ============================================================================
--  Unique Capture  -  CLIENT  (Sun-style)
--  همه‌چیز local هست تا با globalهای warzone/gungame/hub قاطی نشه.
-- ============================================================================
local CFG = CapConfig
local ESX, PlayerData = nil, nil
local Theme = CFG.Colors

local Active, UntilEnd = false, 0           -- راند فعال؟
local InCap, ZoneId, Zones = false, nil, {} -- داخل کپچر؟
local Kills, Deaths = 0, 0
local IsDead, InProtection, InZoneCircle = false, false, false
local TeleportBusy, MenuOpen, ScoreboardOpen, TimerHidden, Dying = false, false, false, false, false
local LastBoard, LastBoardAt = nil, 0
local Blips = {}
local LastCoords = nil
local LoopToken, ProtId, GhostRunning = 0, 0, false
local CapBlockedUntil = 0

local PARACHUTE = GetHashKey('gadget_parachute')

local function nui(action, data) SendNUIMessage({ action = action, data = data or {} }) end
local function notify(msg, typ)
    lib.notify({ description = msg, type = typ or 'inform', position = 'top' })
end

local function MyGang()
    local pd = PlayerData or (ESX and ESX.GetPlayerData and ESX.GetPlayerData())
    local g = pd and pd.gang
    if type(g) == 'table' then return g.name or 'nogang' end
    if type(g) == 'string' and g ~= '' then return g end
    return 'nogang'
end

local function WaitFor(cond, ms)
    local t = GetGameTimer() + ms
    while not cond() and GetGameTimer() < t do Wait(25) end
    return cond()
end

-- ----------------------------------------------------------------------------
--  Init
-- ----------------------------------------------------------------------------
local function ShowHud(seconds)
    nui('setVisible', { visible = true })
    nui('setTimer', { seconds = seconds or UntilEnd or 0 })
    nui('updateStats', { kills = Kills, deaths = Deaths })
    if not InCap then nui('setFlagOwner', {}) end
end

local function HideHud() nui('setVisible', { visible = false }) end

-- cache زون‌ها از سرور (باید داخل thread صدا زده بشه)
local function FetchCache()
    if not ESX then return false end
    local done, ok = false, false
    ESX.TriggerServerCallback('capture:getCache', function(list, cfg, untilEnd)
        local zones = {}
        for _, z in ipairs(list or {}) do
            zones[z.id] = { id = z.id, label = z.label, coords = vector3(z.coords.x, z.coords.y, z.coords.z), world = z.world,
                captureBy = z.captureBy, playerCount = z.playerCount, gangPlayerCount = z.gangPlayerCount,
                maxPlayerCount = z.maxPlayerCount, maxGangCount = z.maxGangCount }
        end
        Zones = zones
        Active = (cfg and cfg.active) and true or false
        UntilEnd = untilEnd or 0
        ok, done = true, true
    end)
    WaitFor(function() return done end, 5000)
    return ok
end

CreateThread(function()
    while not ESX do
        TriggerEvent(CFG.getSharedObjectTrigger, function(o) ESX = o end)
        Wait(100)
    end
    while not (ESX.GetPlayerData and ESX.GetPlayerData() and ESX.GetPlayerData().gang) do Wait(250) end
    PlayerData = ESX.GetPlayerData()
    if FetchCache() and Active and MyGang() ~= 'nogang' then ShowHud(UntilEnd) end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData = PlayerData or {}
    PlayerData.gang = gang
    if MyGang() == 'nogang' and not InCap then HideHud() end
end)

RegisterNetEvent('capture:notify')
AddEventHandler('capture:notify', function(msg, typ) notify(msg, typ) end)

-- ----------------------------------------------------------------------------
--  Blips
-- ----------------------------------------------------------------------------
local function RemoveBlips()
    for _, b in ipairs(Blips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    Blips = {}
end

local function CreateBlips()
    RemoveBlips()
    for _, z in pairs(Zones) do
        local b = AddBlipForCoord(z.coords.x, z.coords.y, z.coords.z)
        SetBlipSprite(b, CFG.BlipSprite)
        SetBlipColour(b, CFG.BlipColor)
        SetBlipScale(b, CFG.BlipScale)
        SetBlipAsShortRange(b, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(z.label)
        EndTextCommandSetBlipName(b)
        local r = AddBlipForRadius(z.coords.x, z.coords.y, z.coords.z, CFG.BlipRadius)
        SetBlipColour(r, 1)
        SetBlipAlpha(r, 80)
        Blips[#Blips + 1] = b
        Blips[#Blips + 1] = r
    end
end

-- ----------------------------------------------------------------------------
--  Spawn protection (نامیرا + چشمک برای بقیه با state bag)
-- ----------------------------------------------------------------------------
AddStateBagChangeHandler('captureProtected', nil, function(bagName, _, value)
    local ply = GetPlayerFromStateBagName(bagName)
    if not ply or ply == 0 then return end
    local ped = GetPlayerPed(ply)
    if not ped or ped == 0 then return end
    if value then SetEntityAlpha(ped, 150, false) else ResetEntityAlpha(ped) end
end)

local function EndProtection(id)
    if id and id ~= ProtId then return end
    InProtection = false
    SetPlayerInvincible(PlayerId(), false)
    LocalPlayer.state:set('captureProtected', false, true)
    ResetEntityAlpha(PlayerPedId())
end

local function StartProtection()
    ProtId = ProtId + 1
    local id = ProtId
    InProtection = true
    SetPlayerInvincible(PlayerId(), true)
    LocalPlayer.state:set('captureProtected', true, true)
    SetPedArmour(PlayerPedId(), CFG.SpawnArmor)
    SetTimeout(CFG.SpawnProtectionTime * 1000, function() EndProtection(id) end)
end

-- ----------------------------------------------------------------------------
--  Ghost mode  (مثل sun: بعد مرگ تا انتخاب زون مرده/نامرئی می‌مونی)
-- ----------------------------------------------------------------------------
local function ReleaseGhost()
    local ped = PlayerPedId()
    SetEntityVisible(ped, true, false)
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityCollision(ped, true, true)
end

local OpenSpawnMenu

local function StartGhost()
    if GhostRunning then return end
    GhostRunning = true
    CreateThread(function()
        local t0, reviveSent = GetGameTimer(), false
        while IsDead and InCap do
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                -- آمبولانس خودش با capture:inCapture بعد ~۱ ثانیه ریوایو می‌کنه؛ اگه نکرد خودمون
                if not reviveSent and GetGameTimer() - t0 > 2500 then
                    reviveSent = true
                    TriggerEvent(CFG.ReviveTrigger)
                end
            else
                SetEntityVisible(ped, false, false)
                SetEntityInvincible(ped, true)
                FreezeEntityPosition(ped, true)
                SetEntityCollision(ped, false, false)
            end
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)   -- look
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true) -- chat
            if not MenuOpen and IsDisabledControlJustPressed(0, 38) then CreateThread(OpenSpawnMenu) end
            Wait(0)
        end
        GhostRunning = false
    end)
end

local function OnDeath()
    if IsDead or not InCap then return end
    IsDead = true
    nui('hideHeal')
    nui('stopCaptureTimer')
    if not MenuOpen then nui('showDeathScreen', {}) end
    StartGhost()
end

AddEventHandler('esx:onPlayerDeath', function() OnDeath() end)

-- ----------------------------------------------------------------------------
--  Spawn menu
-- ----------------------------------------------------------------------------
local function ZoneUiList()
    local arr = {}
    for id, z in pairs(Zones) do
        arr[#arr + 1] = { id = id, zoneLabel = z.label, playerCount = z.playerCount, maxPlayerCount = z.maxPlayerCount,
            gangPlayerCount = z.gangPlayerCount, maxGangCount = z.maxGangCount }
    end
    table.sort(arr, function(a, b) return a.id < b.id end)
    return arr
end

OpenSpawnMenu = function()
    if MenuOpen then return end
    if not FetchCache() then return notify('Server Pasokh Nadad !', 'error') end
    if not Active then return notify('Capture Not Active !', 'error') end
    MenuOpen = true
    SetNuiFocus(true, true)
    ShowHud(UntilEnd)
    nui('hideDeathScreen') -- پنل مرگ z-index بالاتری داره و روی منو می‌افتاد
    nui('openSpawnMenu', { zones = ZoneUiList(), canBackHome = InCap })
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    SetNuiFocus(false, false)
    nui('closeSpawnMenu')
end

RegisterNetEvent('Cap:OpenMenu')
AddEventHandler('Cap:OpenMenu', function() CreateThread(OpenSpawnMenu) end)

RegisterNUICallback('requestSpawnZones', function(_, cb)
    cb('ok')
    CreateThread(function()
        if MenuOpen and FetchCache() then nui('updateSpawnZones', { zones = ZoneUiList() }) end
    end)
end)

RegisterNUICallback('spawnSelect', function(data, cb)
    cb('ok')
    MenuOpen = false
    SetNuiFocus(false, false)
    local id = data and tonumber(data.id)
    if id then TriggerServerEvent('capture:join', id) end
end)

RegisterNUICallback('spawnCancel', function(_, cb)
    cb('ok')
    MenuOpen = false
    SetNuiFocus(false, false)
    if IsDead and InCap then nui('showDeathScreen', {}) end
end)

RegisterNUICallback('spawnBackHome', function(_, cb)
    cb('ok')
    MenuOpen = false
    SetNuiFocus(false, false)
    TriggerServerEvent('capture:exit')
end)

RegisterNUICallback('captureTimerComplete', function(_, cb) cb('ok') end)

RegisterNetEvent('capture:joinDenied')
AddEventHandler('capture:joinDenied', function()
    if not InCap or IsDead then CreateThread(OpenSpawnMenu) end
end)

-- ----------------------------------------------------------------------------
--  Drop / teleport
-- ----------------------------------------------------------------------------
local function RingPoint(center, radius)
    local a = math.random() * 2.0 * math.pi
    return vector3(center.x + math.cos(a) * radius, center.y + math.sin(a) * radius, CFG.DropHeight)
end

local function TeleportTo(p, heading)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    RequestCollisionAtCoord(p.x, p.y, p.z)
    SetEntityCoordsNoOffset(ped, p.x, p.y, p.z, false, false, false)
    if heading then SetEntityHeading(ped, heading) end
    SetGameplayCamRelativeHeading(0.0)
end

local function EquipParachute()
    local ped = PlayerPedId()
    if not HasPedGotWeapon(ped, PARACHUTE, false) then GiveWeaponToPed(ped, PARACHUTE, 1, false, false) end
    SetCurrentPedWeapon(ped, PARACHUTE, true)
end

local function FadeOut(ms)
    DoScreenFadeOut(ms)
    WaitFor(IsScreenFadedOut, ms + 1500)
end

local function Revive()
    if not IsEntityDead(PlayerPedId()) then return end
    TriggerEvent(CFG.ReviveTrigger)
    WaitFor(function() return not IsEntityDead(PlayerPedId()) end, 5000)
    WaitFor(IsScreenFadedIn, 4000) -- آمبولانس خودش فید می‌کنه
end

local StartLoops

RegisterNetEvent('capture:teleport')
AddEventHandler('capture:teleport', function(zoneId)
    if TeleportBusy then return end
    TeleportBusy = true
    FetchCache()
    local zone = Zones[zoneId]
    if not zone then
        TeleportBusy = false
        return TriggerServerEvent('capture:exit')
    end
    CloseMenu()
    ZoneId = zoneId
    local first = not InCap
    if first then
        InCap = true
        TriggerEvent('capture:inCapture', true)
        CreateBlips()
        StartLoops()
    end
    InZoneCircle = false
    LastCoords = nil
    CapBlockedUntil = 0

    Revive()
    IsDead = false
    nui('hideDeathScreen')
    FadeOut(500)
    ReleaseGhost()

    local p = RingPoint(zone.coords, CFG.FirstDropRadius)
    local heading = GetHeadingFromVector_2d(zone.coords.x - p.x, zone.coords.y - p.y)
    TeleportTo(p, heading)
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    EquipParachute()
    StartProtection()
    nui('setFlagOwner', { owner = zone.captureBy or 'N/A' })
    ShowHud(UntilEnd)
    DoScreenFadeIn(800)
    TeleportBusy = false
end)

-- وقتی اولین بار وارد دایره‌ی زون شدی: دوباره از ارتفاع داخل دایره اسپان میشی (مثل sun)
local function EdgeTeleport(zone)
    TeleportBusy = true
    local p = RingPoint(zone.coords, CFG.ZoneRange / 2.0 - 5.0)
    local heading = GetHeadingFromVector_2d(zone.coords.x - p.x, zone.coords.y - p.y)
    TeleportTo(p, heading)
    LastCoords = p
    InZoneCircle = true
    EquipParachute()
    StartProtection()
    TeleportBusy = false
end

-- ----------------------------------------------------------------------------
--  Cleanup / exit
-- ----------------------------------------------------------------------------
local function Cleanup()
    InCap, ZoneId, IsDead, InZoneCircle, TeleportBusy, Dying = false, nil, false, false, false, false
    LoopToken = LoopToken + 1
    LastCoords = nil
    RemoveBlips()
    EndProtection()
    ReleaseGhost()
    nui('hideFlagOwner')
    nui('clearFlagContested')
    nui('stopCaptureTimer')
    nui('hideDeathScreen')
    nui('hideHeal')
    if ScoreboardOpen then ScoreboardOpen = false nui('closeScoreboard') end
    CloseMenu()
    SetNuiFocus(false, false)
    TriggerEvent('capture:inCapture', false)
end

RegisterNetEvent('capture:exited')
AddEventHandler('capture:exited', function(home)
    if not InCap and not home then return end
    local ped
    FadeOut(500)
    Cleanup()
    Revive()
    ped = PlayerPedId()
    if home then
        FreezeEntityPosition(ped, true)
        RequestCollisionAtCoord(home.x, home.y, home.z)
        SetEntityCoordsNoOffset(ped, home.x, home.y, home.z, false, false, false)
        local t = GetGameTimer() + 3000
        while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < t do Wait(50) end
        FreezeEntityPosition(ped, false)
    end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    DoScreenFadeIn(800)
    if Active and MyGang() ~= 'nogang' then ShowHud(UntilEnd) else HideHud() end
end)

RegisterNetEvent('capture:requestExit')
AddEventHandler('capture:requestExit', function()
    if InCap then TriggerServerEvent('capture:exit') end
end)

-- ----------------------------------------------------------------------------
--  Round events
-- ----------------------------------------------------------------------------
RegisterNetEvent('capture:CaptureStarted')
AddEventHandler('capture:CaptureStarted', function(untilEnd)
    Active, UntilEnd, Kills, Deaths = true, untilEnd or 0, 0, 0
    if MyGang() ~= 'nogang' then ShowHud(UntilEnd) end
end)

RegisterNetEvent('capture:CaptureEnded')
AddEventHandler('capture:CaptureEnded', function()
    Active = false
    if MenuOpen then CloseMenu() end
    if not InCap then HideHud() return end
    notify('Capture Tamam Shod ! Ta 5 Sanie Digar Be Khane Bar Migardid.', 'inform')
    CreateThread(function()
        Wait(5000)
        if InCap then TriggerServerEvent('capture:exit') end
    end)
end)

RegisterNetEvent('capture:ChangeCaptureHandler')
AddEventHandler('capture:ChangeCaptureHandler', function(index, gang)
    if Zones[index] then Zones[index].captureBy = gang end
    if InCap and index == ZoneId then
        nui('setFlagOwner', { owner = gang or 'N/A' })
        nui('clearFlagContested')
    end
end)

RegisterNetEvent('capture:setFlagContested')
AddEventHandler('capture:setFlagContested', function(attacker)
    if InCap then nui('setFlagContested', { attacker = attacker }) end
end)

RegisterNetEvent('capture:contestDenied')
AddEventHandler('capture:contestDenied', function()
    CapBlockedUntil = GetGameTimer() + 5000
end)

RegisterNetEvent('capture:updateKillDeath')
AddEventHandler('capture:updateKillDeath', function(d)
    Kills, Deaths = tonumber(d and d.kills) or 0, tonumber(d and d.deaths) or 0
    nui('updateStats', { kills = Kills, deaths = Deaths })
end)

-- ----------------------------------------------------------------------------
--  Main loops (فقط وقتی داخل کپچری)
-- ----------------------------------------------------------------------------
local function DisableFire()
    DisablePlayerFiring(PlayerId(), true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
end

StartLoops = function()
    LoopToken = LoopToken + 1
    local token = LoopToken
    local function alive() return InCap and token == LoopToken end

    -- مارکرها + دایره‌ی زون + گرفتن پرچم
    CreateThread(function()
        local capStart = nil
        local function cancelCap()
            if capStart then
                capStart = nil
                nui('stopCaptureTimer')
                TriggerServerEvent('capture:cancelContest')
            end
        end
        while alive() do
            local zone = ZoneId and Zones[ZoneId]
            if zone then
                local owned = zone.captureBy == MyGang()
                local c = owned and Theme.Owned or Theme.Enemy
                local zc = zone.coords
                DrawMarker(1, zc.x, zc.y, zc.z - 100.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, CFG.ZoneRange, CFG.ZoneRange, 2000.0,
                    c.R, c.G, c.B, c.Alpha, false, true, 2, false, nil, nil, false)
                DrawMarker(1, zc.x, zc.y, zc.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, CFG.FlagRadius * 2.0, CFG.FlagRadius * 2.0, 1.2,
                    c.R, c.G, c.B, 180, false, true, 2, false, nil, nil, false)

                local ped = PlayerPedId()
                local pc = GetEntityCoords(ped)
                local d2 = #(vector2(pc.x, pc.y) - vector2(zc.x, zc.y))
                local radius = CFG.ZoneRange / 2.0

                if not InZoneCircle then
                    DisableFire()
                    if d2 < radius and not TeleportBusy and not IsDead then EdgeTeleport(zone) end
                else
                    if d2 >= radius and not TeleportBusy and not IsDead then
                        if LastCoords then
                            SetEntityCoordsNoOffset(ped, LastCoords.x, LastCoords.y, LastCoords.z, false, false, false)
                            if GetEntityHeightAboveGround(ped) < 5.0 then SetPedToRagdoll(ped, 5000, 5000, 0, false, false, false) end
                        end
                    else
                        LastCoords = pc
                    end
                end

                if InProtection and IsPedShooting(ped) then EndProtection() end

                -- گرفتن پرچم
                local near = InZoneCircle and not IsDead and not TeleportBusy and not owned
                    and #(pc - zc) <= CFG.FlagRadius and GetGameTimer() >= CapBlockedUntil
                if near and not capStart then
                    capStart = GetGameTimer()
                    TriggerServerEvent('capture:setFlagContested')
                    nui('startCaptureTimer', { seconds = CFG.CaptureSeconds })
                elseif capStart and (not near or GetGameTimer() < CapBlockedUntil) then
                    cancelCap()
                elseif capStart and GetGameTimer() - capStart >= CFG.CaptureSeconds * 1000 then
                    capStart = nil
                    nui('stopCaptureTimer')
                    TriggerServerEvent('capture:CaptureMe')
                    CapBlockedUntil = GetGameTimer() + 1500
                end

                if not IsDead and IsEntityDead(ped) then OnDeath() end
            end
            Wait(0)
        end
    end)

    -- ریجن (۱ HP / ثانیه بعد از ۵ ثانیه بدون دمیج/شلیک)
    CreateThread(function()
        local lastHp, lastCombat, lastTick, shown = nil, 0, 0, false
        while alive() do
            local ped = PlayerPedId()
            local now = GetGameTimer()
            local hp, maxHp = GetEntityHealth(ped), GetEntityMaxHealth(ped)
            if lastHp and hp < lastHp then lastCombat = now end
            lastHp = hp
            if IsPedShooting(ped) then lastCombat = now end
            local canHeal = not IsDead and hp > 100 and hp < maxHp and (now - lastCombat) >= CFG.Heal.Delay
            if canHeal then
                if not shown then shown = true nui('showHeal') end
                if now - lastTick >= CFG.Heal.Interval then
                    lastTick = now
                    SetEntityHealth(ped, math.min(maxHp, hp + CFG.Heal.Amount))
                    lastHp = GetEntityHealth(ped)
                end
            elseif shown then
                shown = false
                nui('hideHeal')
            end
            Wait(100)
        end
        if shown then nui('hideHeal') end
    end)

    -- مهمات حداقل + چتر
    CreateThread(function()
        while alive() do
            if not IsDead then
                local ped = PlayerPedId()
                if not HasPedGotWeapon(ped, PARACHUTE, false) then GiveWeaponToPed(ped, PARACHUTE, 1, false, false) end
                local _, w = GetCurrentPedWeapon(ped, true)
                if w and w ~= 0 and GetWeaponDamageType(w) == 3 and GetAmmoInPedWeapon(ped, w) < CFG.Ammo then
                    SetPedAmmo(ped, w, CFG.Ammo)
                end
            end
            Wait(1000)
        end
    end)

    -- چتر خودکار نزدیک زمین
    if CFG.AutoParachute then
        CreateThread(function()
            while alive() do
                local ped = PlayerPedId()
                if not IsDead and not InProtection and GetPedParachuteState(ped) <= 0 then
                    local falling = IsPedInParachuteFreeFall(ped) or (IsPedFalling(ped) and GetEntityVelocity(ped).z < -12.0)
                    if falling and GetEntityHeightAboveGround(ped) < CFG.AutoParachuteHeight then
                        if not HasPedGotWeapon(ped, PARACHUTE, false) then GiveWeaponToPed(ped, PARACHUTE, 1, false, false) end
                        ForcePedToOpenParachute(ped)
                    end
                end
                Wait(200)
            end
        end)
    end
end

-- ----------------------------------------------------------------------------
--  Keys: Q اسکوربورد | F4 تایمر | /die
-- ----------------------------------------------------------------------------
RegisterCommand('captureScoreboard', function()
    if not InCap or not ESX then return end
    if ScoreboardOpen then
        ScoreboardOpen = false
        return nui('closeScoreboard')
    end
    ScoreboardOpen = true
    if LastBoard and GetGameTimer() - LastBoardAt < 5000 then return nui('openScoreboard', LastBoard) end
    ESX.TriggerServerCallback('capture:getScoreboard', function(data)
        if not ScoreboardOpen then return end
        local families = {}
        for _, g in ipairs(data and data.gangs or {}) do
            families[#families + 1] = { name = g.name, capturedFlags = g.capturedFlags or {}, point = g.Score }
        end
        LastBoard = { players = data and data.players or {}, families = families }
        LastBoardAt = GetGameTimer()
        nui('openScoreboard', LastBoard)
    end)
end, false)
RegisterKeyMapping('captureScoreboard', 'Capture: Scoreboard', 'keyboard', 'Q')

RegisterCommand('captureTimerToggle', function()
    if not InCap then return end
    TimerHidden = not TimerHidden
    nui('setTimerVisibility', { hidden = TimerHidden })
end, false)
RegisterKeyMapping('captureTimerToggle', 'Capture: Hide/Show Timer', 'keyboard', 'F4')

RegisterCommand(CFG.DieCommand, function()
    if not InCap or IsDead or Dying then return end
    local ped = PlayerPedId()
    if InProtection or TeleportBusy or IsPedInParachuteFreeFall(ped) or GetPedParachuteState(ped) > 0 then
        return notify('Dar Hali Ke Parachute Dari Ya Spawn Protection Faal Ast Nemitavanid Bemirid !', 'error')
    end
    Dying = true
    local done = lib.progressCircle({ duration = CFG.DieSeconds * 1000, label = 'Khodkoshi...', position = 'bottom',
        canCancel = true, disable = { move = true, car = true, combat = true } })
    Dying = false
    if done and InCap and not IsDead then SetEntityHealth(PlayerPedId(), 0) end
end, false)

-- ----------------------------------------------------------------------------
--  Admin / Stats / History menus (ox_lib)
-- ----------------------------------------------------------------------------
RegisterNetEvent('capture:OpenAdminMenu')
AddEventHandler('capture:OpenAdminMenu', function()
    if not ESX then return end
    ESX.TriggerServerCallback('capture:adminInfo', function(info)
        if not info then return end
        local removeOpts = {}
        for _, z in ipairs(info.zones) do
            removeOpts[#removeOpts + 1] = { title = ('#%d  %s'):format(z.id, z.label), description = 'World ' .. z.world, icon = 'trash',
                onSelect = function() TriggerServerEvent('capture:admin:removeZone', z.id) end }
        end
        if #removeOpts == 0 then removeOpts[1] = { title = 'Zone Nist', readOnly = true } end
        lib.registerContext({ id = 'capture_remove', title = 'Hazf Zone', menu = 'capture_admin', options = removeOpts })
        lib.registerContext({ id = 'capture_admin', title = 'Capture Admin', options = {
            { title = 'Zaman Capture', description = info.minutes .. ' Daghighe', icon = 'clock', onSelect = function()
                local r = lib.inputDialog('Zaman Capture', { { type = 'number', label = 'Daghighe', default = info.minutes, min = 1, max = 600, required = true } })
                if r then TriggerServerEvent('capture:admin:setTime', r[1]) end
            end },
            { title = 'Set / Update Zone', description = 'Mokhtasat Felie Shoma Be Onvane Parcham Zakhire Mishavad', icon = 'flag', onSelect = function()
                local r = lib.inputDialog('Set Zone', {
                    { type = 'number', label = 'Shomare Zone (1-99)', min = 1, max = 99, required = true },
                    { type = 'input', label = 'Name Zone', max = 24, required = true },
                    { type = 'number', label = ('World (%d-%d)'):format(CFG.WorldMin, CFG.WorldMax), default = CFG.WorldMin, min = CFG.WorldMin, max = CFG.WorldMax, required = true } })
                if r then TriggerServerEvent('capture:setCap', { r[1], r[2], r[3] }) end
            end },
            { title = 'Hazf Zone', description = #info.zones .. ' Zone', icon = 'trash', menu = 'capture_remove' },
            { title = info.active and 'Payan Capture' or 'Shoroo Capture', icon = info.active and 'stop' or 'play', onSelect = function()
                ExecuteCommand(info.active and CFG.EndCaptureCommand or CFG.StartCaptureCommand)
            end },
        } })
        lib.showContext('capture_admin')
    end)
end)

RegisterNetEvent('capture:OpenStatsMenu')
AddEventHandler('capture:OpenStatsMenu', function()
    if not ESX then return end
    ESX.TriggerServerCallback('capture:GetMyStats', function(mine, top)
        mine = mine or {}
        local opts = {
            { title = 'Kills / Deaths', description = (mine.kills or 0) .. ' / ' .. (mine.deaths or 0), icon = 'crosshairs', readOnly = true },
            { title = 'Gang Points', description = tostring(mine.gang_points or 0), icon = 'flag', readOnly = true },
        }
        for i, t in ipairs(top or {}) do
            opts[#opts + 1] = { title = ('#%d  %s'):format(i, t.name or '?'), description = (t.kills or 0) .. ' kills', icon = 'ranking-star', readOnly = true }
        end
        lib.registerContext({ id = 'capture_stats', title = 'Capture Stats', options = opts })
        lib.showContext('capture_stats')
    end)
end)

RegisterNetEvent('capture:OpenHistoryMenu')
AddEventHandler('capture:OpenHistoryMenu', function()
    if not ESX then return end
    ESX.TriggerServerCallback('capture:GetHistory', function(rows)
        local opts = {}
        for _, r in ipairs(rows or {}) do
            opts[#opts + 1] = { title = tostring(r.round_date), readOnly = true, icon = 'clock-rotate-left',
                description = ('Gang: %s (%s) | Killer: %s (%s)'):format(tostring(r.winner_gang), tostring(r.winner_points), tostring(r.top_killer_name), tostring(r.top_killer_kills)) }
        end
        if #opts == 0 then opts[1] = { title = 'Hich Raundi Sabt Nashode', readOnly = true } end
        lib.registerContext({ id = 'capture_history', title = 'Capture History', options = opts })
        lib.showContext('capture_history')
    end)
end)

-- ----------------------------------------------------------------------------
--  Resource stop safety
-- ----------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
    RemoveBlips()
    EndProtection()
    ReleaseGhost()
    if InCap then TriggerEvent('capture:inCapture', false) end
end)
