-- ============================================================================
--  Unique Gang PvP  -  CLIENT
-- ============================================================================
local CFG = GPConfig
local ESX = nil

local InPvp, IsDown = false, false          -- IsDown: خودم مُردم و منتظر CPR/E هستم
local Home, Safe = nil, {}
local Kills, Deaths, SC, Count = 0, 0, 0, 0
local LockEnd = 0
local ShopBlips, ShopData = {}, {}
local DownMates = {}
local MyCar = nil
local Busy = false                           -- پروگرس (CPR/کارواش) در جریان
local Token = 0

CreateThread(function()
    while not ESX do
        TriggerEvent(CFG.ESX, function(o) ESX = o end)
        Wait(100)
    end
end)

local function notify(msg, typ) lib.notify({ description = msg, type = typ or 'inform', position = 'top' }) end

local function WaitFor(cond, ms)
    local t = GetGameTimer() + ms
    while not cond() and GetGameTimer() < t do Wait(25) end
    return cond()
end

local function DrawTxt(x, y, text, scale, r, g, b)
    SetTextFont(4)
    SetTextScale(0.0, scale or 0.4)
    SetTextColour(r or 255, g or 255, b or 255, 255)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function Help(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function Revive()
    if not IsEntityDead(PlayerPedId()) then return end
    TriggerEvent(CFG.ReviveTrigger)
    WaitFor(function() return not IsEntityDead(PlayerPedId()) end, 5000)
    WaitFor(IsScreenFadedIn, 4000)
end

local function Teleport(c)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    RequestCollisionAtCoord(c.x, c.y, c.z)
    SetEntityCoordsNoOffset(ped, c.x, c.y, c.z, false, false, false)
end

local function DeleteCar()
    if MyCar and DoesEntityExist(MyCar) then
        SetEntityAsMissionEntity(MyCar, true, true)
        DeleteVehicle(MyCar)
    end
    MyCar = nil
end

local function RemoveShopBlips()
    for _, b in ipairs(ShopBlips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    ShopBlips = {}
end

local function Cleanup()
    Token = Token + 1
    InPvp, IsDown, Busy = false, false, false
    DownMates, LockEnd = {}, 0
    DeleteCar()
    RemoveShopBlips()
    ShopData = {}
    local ped = PlayerPedId()
    SetPedSuffersCriticalHits(ped, true)
    TriggerEvent('esx_paintball:inPaintBall', false)
end

-- ----------------------------------------------------------------------------
--  Shops
-- ----------------------------------------------------------------------------
local function RefreshShops()
    if not ESX or not InPvp then return end
    local tok = Token
    ESX.TriggerServerCallback('gpvp:getShops', function(list)
        if tok ~= Token or not InPvp then return end
        RemoveShopBlips()
        ShopData = {}
        for _, sh in ipairs(list or {}) do
            local c = vector3(sh.coords.x, sh.coords.y, sh.coords.z)
            ShopData[#ShopData + 1] = { idx = sh.idx, coords = c, weapons = sh.weapons }
            local b = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(b, CFG.Shop.blip.sprite)
            SetBlipColour(b, CFG.Shop.blip.color)
            SetBlipScale(b, CFG.Shop.blip.scale)
            SetBlipAsShortRange(b, false)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('PVP Shop')
            EndTextCommandSetBlipName(b)
            ShopBlips[#ShopBlips + 1] = b
        end
    end)
end

RegisterNetEvent('gpvp:shopsChanged')
AddEventHandler('gpvp:shopsChanged', function()
    notify('Shop Haye PVP Taghir Kardand !', 'inform')
    RefreshShops()
end)

local function OpenShop(sh)
    local opts = {}
    for _, w in ipairs(sh.weapons) do
        local label = w.name:gsub('^weapon_', ''):upper()
        opts[#opts + 1] = { title = label, description = ('Price: %d SC | Stock: %d'):format(w.price, w.count),
            icon = 'gun', disabled = w.count <= 0,
            onSelect = function() TriggerServerEvent('gpvp:buyWeapon', sh.idx, w.id) end }
    end
    lib.registerContext({ id = 'gpvp_shop', title = ('PVP Shop  |  %d SC'):format(SC), options = opts })
    lib.showContext('gpvp_shop')
end

-- ----------------------------------------------------------------------------
--  Wash (PV -> اسلحه‌ی واقعی با بلک‌مانی)
-- ----------------------------------------------------------------------------
local function DoWash(w)
    if Busy then return end
    Busy = true
    ESX.TriggerServerCallback('gpvp:washStart', function(ok)
        if not ok then Busy = false return end
        local done = lib.progressCircle({ duration = CFG.Wash.seconds * 1000, label = 'Dar Hale Shostan Aslahe...', position = 'bottom',
            canCancel = true, disable = { move = true, car = true, combat = true } })
        Busy = false
        if done and InPvp and not IsDown then TriggerServerEvent('gpvp:wash', w.serial)
        else TriggerServerEvent('gpvp:washCancel') end
    end, w.serial)
end

local function OpenWash()
    ESX.TriggerServerCallback('gpvp:getWashList', function(list)
        local opts = {}
        for _, w in ipairs(list or {}) do
            opts[#opts + 1] = { title = w.label, description = ('Wash: $%s (Black Money) | %s'):format(w.price, w.serial), icon = 'soap',
                onSelect = function() DoWash(w) end }
        end
        if #opts == 0 then opts[1] = { title = 'Hich Aslahe PvP Nadarid', readOnly = true } end
        lib.registerContext({ id = 'gpvp_wash', title = 'Gun Wash', options = opts })
        lib.showContext('gpvp_wash')
    end)
end

-- ----------------------------------------------------------------------------
--  Cars
-- ----------------------------------------------------------------------------
RegisterCommand(CFG.CarCommand, function()
    if not InPvp or IsDown then return end
    local opts = {}
    for _, c in ipairs(CFG.Cars) do
        opts[#opts + 1] = { title = c.label, description = c.price .. ' SC', icon = 'car',
            onSelect = function() TriggerServerEvent('gpvp:buyCar', c.model) end }
    end
    lib.registerContext({ id = 'gpvp_cars', title = ('PVP Cars  |  %d SC'):format(SC), options = opts })
    lib.showContext('gpvp_cars')
end, false)

RegisterNetEvent('gpvp:spawnCar')
AddEventHandler('gpvp:spawnCar', function(model)
    if not InPvp then return end
    local hash = GetHashKey(model)
    RequestModel(hash)
    if not WaitFor(function() return HasModelLoaded(hash) end, 8000) then return notify('Model Load Nashod !', 'error') end
    DeleteCar()
    local ped = PlayerPedId()
    local c = GetOffsetFromEntityInWorldCoords(ped, 0.0, 4.0, 0.5)
    MyCar = CreateVehicle(hash, c.x, c.y, c.z, GetEntityHeading(ped), true, false)
    SetVehicleOnGroundProperly(MyCar)
    SetVehRadioStation(MyCar, 'OFF')
    TaskWarpPedIntoVehicle(ped, MyCar, -1)
    SetModelAsNoLongerNeeded(hash)
end)

-- ----------------------------------------------------------------------------
--  Events
-- ----------------------------------------------------------------------------
RegisterNetEvent('gpvp:notify')
AddEventHandler('gpvp:notify', function(msg, typ) notify(msg, typ) end)

RegisterNetEvent('gpvp:count')
AddEventHandler('gpvp:count', function(n) Count = n or Count end)

RegisterNetEvent('gpvp:stats')
AddEventHandler('gpvp:stats', function(s)
    if not s then return end
    Kills, Deaths, SC = s.kills or Kills, s.deaths or Deaths, s.sc or SC
end)

RegisterNetEvent('gpvp:mateDown')
AddEventHandler('gpvp:mateDown', function(id, down) DownMates[id] = down and true or nil end)

RegisterNetEvent('gpvp:pullBack')
AddEventHandler('gpvp:pullBack', function(home)
    if InPvp and home and not IsDown then
        Teleport(home)
        notify('Dar Zaman Cooldown Bayad Nazdik Khane Gang Bemanid', 'error')
    end
end)

-- ----------------------------------------------------------------------------
--  Join
-- ----------------------------------------------------------------------------
RegisterNetEvent('gpvp:joined')
AddEventHandler('gpvp:joined', function(d)
    Cleanup()
    local tok = Token
    InPvp = true
    Home = vector3(d.home.x, d.home.y, d.home.z)
    Safe = {}
    for i, c in ipairs(d.safe or {}) do Safe[i] = vector3(c.x, c.y, c.z) end
    Kills, Deaths, SC = d.kills or 0, d.deaths or 0, d.sc or 0
    LockEnd = GetGameTimer() + (d.lock or 0) * 1000
    TriggerEvent('esx_paintball:inPaintBall', true)
    notify('Shoma Be PVP Zone Peyvastid !', 'success')
    RefreshShops()

    -- HUD + ممنوعیت شلیک نزدیک پایگاه + شمارنده‌ی کولداون
    CreateThread(function()
        local nearBase, nextCheck = false, 0
        while InPvp and tok == Token do
            local ped = PlayerPedId()
            if GetGameTimer() >= nextCheck then
                nextCheck = GetGameTimer() + 500
                local pc = GetEntityCoords(ped)
                nearBase = false
                for _, c in ipairs(Safe) do
                    if #(pc - c) <= CFG.SafeRadius then nearBase = true break end
                end
                SetPedSuffersCriticalHits(ped, false)
            end
            if nearBase then
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
            end
            DrawTxt(0.5 - 0.06, 0.965, ('PVP ZONE | %d Players'):format(Count), 0.4, 255, 255, 255)
            DrawTxt(0.65, 0.95, ('~r~PVP Kill : %d  ~s~|  ~y~SC : %d'):format(Kills, SC), 0.4)
            local lockLeft = math.ceil((LockEnd - GetGameTimer()) / 1000)
            if lockLeft > 0 then DrawTxt(0.44, 0.06, ('PVP Cooldown : %ds'):format(lockLeft), 0.6, 255, 80, 80) end
            Wait(0)
        end
    end)

    -- شاپ‌ها و کارواش
    CreateThread(function()
        while InPvp and tok == Token do
            local sleep = 400
            local ped = PlayerPedId()
            if not IsDown and not Busy and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                local pc = GetEntityCoords(ped)
                for _, sh in ipairs(ShopData) do
                    local dd = #(pc - sh.coords)
                    if dd < 25.0 then
                        sleep = 0
                        DrawMarker(1, sh.coords.x, sh.coords.y, sh.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.6, 255, 60, 60, 120, false, true, 2, false, nil, nil, false)
                        if dd <= CFG.Shop.buyDistance then
                            Help('Press ~INPUT_CONTEXT~ to open PVP Shop')
                            if IsControlJustReleased(0, 38) then OpenShop(sh) end
                        end
                    end
                end
                for _, c in ipairs(CFG.Wash.points) do
                    local dd = #(pc - c)
                    if dd < 25.0 then
                        sleep = 0
                        DrawMarker(1, c.x, c.y, c.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.6, 60, 120, 255, 120, false, true, 2, false, nil, nil, false)
                        if dd <= CFG.Wash.distance then
                            Help('Press ~INPUT_CONTEXT~ to open Gun Wash')
                            if IsControlJustReleased(0, 38) then OpenWash() end
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)

    -- CPR برای هم‌گنگی‌های افتاده
    CreateThread(function()
        while InPvp and tok == Token do
            local sleep = 300
            if not IsDown and not Busy and not IsEntityDead(PlayerPedId()) and next(DownMates) then
                local pc = GetEntityCoords(PlayerPedId())
                for id in pairs(DownMates) do
                    local pl = GetPlayerFromServerId(id)
                    if pl and pl ~= -1 then
                        local c = GetEntityCoords(GetPlayerPed(pl))
                        if #(pc - c) <= CFG.CprDistance then
                            sleep = 0
                            Help('Press ~INPUT_CONTEXT~ to revive (CPR)')
                            if IsControlJustReleased(0, 38) then
                                Busy = true
                                TriggerServerEvent('gpvp:cprStart', id)
                                local done = lib.progressCircle({ duration = CFG.CprSeconds * 1000, label = 'Dar Hale CPR...', position = 'bottom',
                                    canCancel = true, disable = { move = true, car = true, combat = true },
                                    anim = { dict = 'mini@cpr@char_a@cpr_str', clip = 'cpr_pumpchest', flag = 1 } })
                                Busy = false
                                if done and InPvp and not IsDown then TriggerServerEvent('gpvp:cpr', id)
                                else TriggerServerEvent('gpvp:cprCancel') end
                            end
                            break
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)

    -- سلامت: اگه مُردم ولی ایونت نیومد
    CreateThread(function()
        while InPvp and tok == Token do
            Wait(1000)
            if not IsDown and IsEntityDead(PlayerPedId()) then TriggerEvent('gpvp:died') end
        end
    end)

    -- بازخوانی دوره‌ای شاپ‌ها (موجودی)
    CreateThread(function()
        while InPvp and tok == Token do
            Wait(60000)
            RefreshShops()
        end
    end)
end)

RegisterNetEvent('gpvp:left')
AddEventHandler('gpvp:left', function(home)
    Cleanup()
    Revive()
    local ped = PlayerPedId()
    if home then Teleport(home) end
    RemoveAllPedWeapons(ped, true)
    TriggerEvent('esx:restoreLoadout') -- اسلحه‌های PvP پاک، لودوات واقعی برمی‌گرده
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
end)

-- ----------------------------------------------------------------------------
--  Death: صبر برای CPR هم‌گنگی، یا E => ریسپاون سر HQ
-- ----------------------------------------------------------------------------
RegisterNetEvent('gpvp:died')
AddEventHandler('gpvp:died', function()
    if not InPvp or IsDown then return end
    IsDown = true
    local tok = Token
    CreateThread(function()
        local untilT = GetGameTimer() + CFG.RespawnSeconds * 1000
        local nextReq = 0
        while IsDown and tok == Token do
            local now = GetGameTimer()
            if now < untilT then
                DrawTxt(0.38, 0.45, ('Respawn dar %d sanie | Montazer CPR Hamgangi'):format(math.ceil((untilT - now) / 1000)), 0.5, 255, 80, 80)
            else
                DrawTxt(0.36, 0.45, 'Press [E] Respawn Sar HQ | Ya Montazer CPR Hamgangi', 0.5, 255, 255, 255)
                if IsControlJustReleased(0, 38) and now >= nextReq then
                    nextReq = now + 1500
                    TriggerServerEvent('gpvp:requestRespawn')
                end
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('gpvp:respawn')
AddEventHandler('gpvp:respawn', function(home)
    if not InPvp then return end
    DeleteCar()
    Revive()
    local ped = PlayerPedId()
    if home then Teleport(home) end
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    IsDown = false
end)

RegisterNetEvent('gpvp:revived')
AddEventHandler('gpvp:revived', function()
    if not InPvp then return end
    Revive() -- ریوایو سر جا
    local ped = PlayerPedId()
    SetEntityHealth(ped, 150)
    IsDown = false
    notify('Hamgangi Shoma Ra Zende Kard !', 'success')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    DeleteCar()
    RemoveShopBlips()
end)
