-- ============================================================================
--  Unique GunGame  -  CLIENT  (Sun-style)
-- ============================================================================
local CFG = GGConfig

local InLobby, InMatch, Dead = false, false, false
local Level, TotalLevels = 1, #CFG.Progression
local Token = 0
local Invincible = false

local function notify(msg, typ) lib.notify({ description = msg, type = typ or 'inform', position = 'top' }) end
local function nui(action, data) SendNUIMessage({ action = action, data = data or {} }) end

local function WaitFor(cond, ms)
    local t = GetGameTimer() + ms
    while not cond() and GetGameTimer() < t do Wait(25) end
    return cond()
end

local function DrawTxt(x, y, text, scale, r, g, b, centre)
    SetTextFont(4)
    SetTextScale(0.0, scale or 0.5)
    SetTextColour(r or 255, g or 255, b or 255, 255)
    SetTextOutline()
    if centre then SetTextCentre(true) end
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function Revive()
    if not IsEntityDead(PlayerPedId()) then return end
    TriggerEvent(CFG.ReviveEvent)
    WaitFor(function() return not IsEntityDead(PlayerPedId()) end, 5000)
    WaitFor(IsScreenFadedIn, 4000)
end

local function FadeOut(ms)
    DoScreenFadeOut(ms)
    WaitFor(IsScreenFadedOut, ms + 1500)
end

local function Teleport(c)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    RequestCollisionAtCoord(c.x, c.y, c.z)
    SetEntityCoordsNoOffset(ped, c.x, c.y, c.z, false, false, false)
end

-- سلاح معتبر برای این build (اگه معتبر نبود نزدیک‌ترین سلاح معتبر قبلی)
local function ValidWeapon(level)
    for i = math.min(level, TotalLevels), 1, -1 do
        local h = GetHashKey(CFG.Progression[i])
        if IsWeaponValid(h) then return h, CFG.Progression[i] end
    end
    return GetHashKey('WEAPON_PISTOL'), 'WEAPON_PISTOL'
end

local function GiveLevelWeapon(level)
    local ped = PlayerPedId()
    local hash = ValidWeapon(level)
    RemoveAllPedWeapons(ped, true)
    GiveWeaponToPed(ped, hash, CFG.WeaponAmmo, false, true)
    SetCurrentPedWeapon(ped, hash, true)
    SetPedAmmo(ped, hash, CFG.WeaponAmmo)
end

local function StartInvincibility()
    if CFG.SpawnInvincibility <= 0 then return end
    local tok = Token
    Invincible = true
    SetPlayerInvincible(PlayerId(), true)
    SetTimeout(CFG.SpawnInvincibility * 1000, function()
        if tok == Token or Invincible then
            Invincible = false
            SetPlayerInvincible(PlayerId(), false)
        end
    end)
end

local function Cleanup()
    Token = Token + 1
    InLobby, InMatch, Dead, Invincible = false, false, false, false
    local ped = PlayerPedId()
    SetPlayerInvincible(PlayerId(), false)
    FreezeEntityPosition(ped, false)
    nui('ggHide')
    TriggerEvent('esx_paintball:inPaintBall', false)
end

local function Leave(c)
    FadeOut(500)
    Cleanup()
    Revive()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    if c then Teleport(c) end
    -- sun: موقعیت مقصد فوراً ذخیره میشه تا ریلاگ بعد از ایونت داخل world ایونت لود نشه
    local pp = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('updatePositions', pp.x, pp.y, pp.z, GetEntityHeading(PlayerPedId()))
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 0)
    TriggerEvent('esx:restoreLoadout')
    DoScreenFadeIn(800)
end

-- ----------------------------------------------------------------------------
--  Events
-- ----------------------------------------------------------------------------
RegisterNetEvent('gg:notify')
AddEventHandler('gg:notify', function(msg, typ) notify(msg, typ) end)

RegisterNetEvent('gg:lobby')
AddEventHandler('gg:lobby', function(c)
    Cleanup()
    InLobby = true
    TriggerEvent('esx_paintball:inPaintBall', true)
    TriggerEvent('esx_status:set', 'hunger', 1000000)
    TriggerEvent('esx_status:set', 'thirst', 1000000)
    Revive()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    Teleport(c)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 0)
    notify('Montazer Shoroo GunGame Bashid...', 'success')
    local tok = Token
    CreateThread(function()
        while InLobby and tok == Token do
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            Wait(0)
        end
    end)
end)

RegisterNetEvent('gg:countdown')
AddEventHandler('gg:countdown', function(n) nui('ggCountdown', { seconds = n }) end)

RegisterNetEvent('gg:time')
AddEventHandler('gg:time', function(sec) nui('ggTime', { seconds = sec }) end)

RegisterNetEvent('gg:board')
AddEventHandler('gg:board', function(top, mine, total)
    nui('ggBoard', { top = top, mine = mine, total = total })
end)

RegisterNetEvent('gg:kill')
AddEventHandler('gg:kill', function(killer, victim, weapon)
    nui('ggKill', { killer = killer, killed = victim, weapon = weapon })
end)

RegisterNetEvent('gg:spawn')
AddEventHandler('gg:spawn', function(point, level, weapon, warmup)
    local firstTime = not InMatch
    InLobby, InMatch, Dead = false, true, false
    Level = level or 1
    local tok = Token
    Revive()
    FadeOut(300)
    local ped = PlayerPedId()
    Teleport(point)
    SetEntityHealth(ped, CFG.SpawnHP)
    SetPedArmour(ped, CFG.SpawnArmor)
    GiveLevelWeapon(Level)
    nui('ggLevel', { level = Level, total = TotalLevels, weapon = weapon })
    DoScreenFadeIn(500)
    if (warmup or 0) > 0 then
        FreezeEntityPosition(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)
        local untilT = GetGameTimer() + warmup * 1000
        while GetGameTimer() < untilT and tok == Token do
            DrawTxt(0.5, 0.35, ('Shoroo Dar %d'):format(math.ceil((untilT - GetGameTimer()) / 1000)), 0.9, 255, 80, 80, true)
            DisablePlayerFiring(PlayerId(), true)
            Wait(0)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        SetPlayerInvincible(PlayerId(), false)
    end
    StartInvincibility()

    if firstTime then
        -- محدوده‌ی arena: دورتر از Center برگردونده میشه
        CreateThread(function()
            local center = vector3(CFG.Center.x, CFG.Center.y, CFG.Center.z)
            while InMatch and tok == Token do
                if CFG.ArenaLeashRadius > 0 and not Dead then
                    local pc = GetEntityCoords(PlayerPedId())
                    if #(vector2(pc.x, pc.y) - vector2(center.x, center.y)) > CFG.ArenaLeashRadius then
                        local pt = CFG.ArenaPoints[math.random(#CFG.ArenaPoints)]
                        Teleport(pt)
                        notify('Az Arena Kharej Shodid !', 'error')
                    end
                end
                Wait(1000)
            end
        end)
        -- ممنوع بودن کنترل‌های F5/F6
        CreateThread(function()
            while InMatch and tok == Token do
                DisableControlAction(0, 166, true)
                DisableControlAction(0, 167, true)
                Wait(0)
            end
        end)
    end
end)

RegisterNetEvent('gg:weapon')
AddEventHandler('gg:weapon', function(weapon, level)
    if not InMatch then return end
    Level = level or Level
    GiveLevelWeapon(Level)
    nui('ggLevel', { level = Level, total = TotalLevels, weapon = weapon })
    nui('ggBanner', { label = ('Salah Jadid  -  Level %s'):format(Level) }) -- sun: killstreakBanner
    PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
end)

RegisterNetEvent('gg:died')
AddEventHandler('gg:died', function(delay)
    if not InMatch then return end
    Dead = true
    local tok = Token
    CreateThread(function()
        local untilT = GetGameTimer() + (delay or CFG.RespawnDelay) * 1000
        while Dead and tok == Token and GetGameTimer() < untilT do
            DrawTxt(0.5, 0.45, ('Respawn Dar %d'):format(math.ceil((untilT - GetGameTimer()) / 1000)), 0.7, 255, 80, 80, true)
            Wait(0)
        end
    end)
end)

RegisterNetEvent('gg:leave')
AddEventHandler('gg:leave', function(c) CreateThread(function() Leave(c) end) end)

RegisterNetEvent('gg:end')
AddEventHandler('gg:end', function(c, winnerName)
    if not InMatch and not InLobby then return end
    if winnerName then notify('Barande: ' .. winnerName, 'success') end
    nui('ggBanner', { label = winnerName and ('Winner: ' .. winnerName) or 'GunGame Tamam Shod' })
    local tok = Token
    CreateThread(function()
        Wait(5000)
        if tok == Token then Leave(c) end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    SetPlayerInvincible(PlayerId(), false)
    FreezeEntityPosition(PlayerPedId(), false)
end)
