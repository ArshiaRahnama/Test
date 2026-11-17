-- ============================================================================
--  Unique WarZone  -  CLIENT  (Sun-style Battle Royale)
--  همه‌چیز local. سرور تصمیم میگیره (مرگ/ریوایو/گولاگ/لوت)؛ کلاینت فقط اجرا و نمایش.
-- ============================================================================
local CFG = WZConfig
local ESX = nil

local PARACHUTE = GetHashKey(CFG.Parachute)
local SNS_HASH  = GetHashKey(CFG.RedeployWeapon)

local InEvent, InLobby, Countdown = false, false, false
local OnPlane, InGulag, NoCombat, RevivePending = false, false, false, false
local Center, MarkerRadius, NextRadius = nil, 0.0, 0.0
local Blood, AliveCount = 0, 0
local StartAt = 0
local Token = 0
local RingBlip = nil
local LootList, LootObj, DeadLoot = {}, {}, {}
local Plane, Pilot = nil, nil
local Shrinking = false
local LootCooldown = 0

CreateThread(function()
    while not ESX do
        TriggerEvent(CFG.ESX, function(o) ESX = o end)
        Wait(100)
    end
end)

-- ----------------------------------------------------------------------------
--  Helpers
-- ----------------------------------------------------------------------------
local function notify(msg, typ) lib.notify({ description = msg, type = typ or 'inform', position = 'top' }) end

local function WaitFor(cond, ms)
    local t = GetGameTimer() + ms
    while not cond() and GetGameTimer() < t do Wait(25) end
    return cond()
end

local function DrawTxt(x, y, text, scale, r, g, b)
    SetTextFont(4)
    SetTextScale(0.0, scale or 0.5)
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

local function Draw3D(x, y, z, text)
    local on, sx, sy = World3dToScreen2d(x, y, z)
    if not on then return end
    SetTextScale(0.0, 0.32)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 230)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(sx, sy)
end

local function Revive()
    if not IsEntityDead(PlayerPedId()) then return end
    TriggerEvent(CFG.ReviveTrigger)
    WaitFor(function() return not IsEntityDead(PlayerPedId()) end, 5000)
    WaitFor(IsScreenFadedIn, 4000)
end

local function FadeOut(ms)
    DoScreenFadeOut(ms)
    WaitFor(IsScreenFadedOut, ms + 1500)
end

local function Teleport(x, y, z, heading)
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    if heading then SetEntityHeading(ped, heading) end
end

local function GiveParachuteAndSns()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, PARACHUTE, 1, false, false)
    GiveWeaponToPed(ped, SNS_HASH, CFG.RedeployAmmo, false, true)
    SetCurrentPedWeapon(ped, PARACHUTE, true)
end

local function KeepStatusFull()
    TriggerEvent('esx_status:set', 'hunger', 1000000)
    TriggerEvent('esx_status:set', 'thirst', 1000000)
    TriggerEvent('esx_status:set', 'mental', 1000000)
end

-- ----------------------------------------------------------------------------
--  Cleanup
-- ----------------------------------------------------------------------------
local function DeleteLoot()
    for _, o in pairs(LootObj) do if DoesEntityExist(o) then DeleteEntity(o) end end
    for _, d in pairs(DeadLoot) do if d.obj and DoesEntityExist(d.obj) then DeleteEntity(d.obj) end end
    LootObj, DeadLoot, LootList = {}, {}, {}
end

local function DeletePlane()
    if Pilot and DoesEntityExist(Pilot) then DeleteEntity(Pilot) end
    if Plane and DoesEntityExist(Plane) then DeleteEntity(Plane) end
    Plane, Pilot = nil, nil
end

local function RemoveRingBlip()
    if RingBlip and DoesBlipExist(RingBlip) then RemoveBlip(RingBlip) end
    RingBlip = nil
end

local function Cleanup()
    Token = Token + 1
    InEvent, InLobby, Countdown, OnPlane, InGulag, NoCombat, RevivePending = false, false, false, false, false, false, false
    Shrinking = false
    DeleteLoot()
    DeletePlane()
    RemoveRingBlip()
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    SetPedSuffersCriticalHits(ped, true)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
    SetFollowPedCamViewMode(2)
    TriggerEvent('esx_paintball:inPaintBall', false)
end

local function Leave(c)
    FadeOut(500)
    Cleanup()
    Revive()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    if c then Teleport(c.x, c.y, c.z) end
    -- sun: موقعیت مقصد فوراً ذخیره میشه تا ریلاگ بعد از ایونت داخل world ایونت لود نشه
    local pp = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('updatePositions', pp.x, pp.y, pp.z, GetEntityHeading(PlayerPedId()))
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 0)
    TriggerEvent('esx:restoreLoadout')
    DoScreenFadeIn(800)
end

-- ----------------------------------------------------------------------------
--  Lobby / join / start
-- ----------------------------------------------------------------------------
RegisterNetEvent('br:notify')
AddEventHandler('br:notify', function(msg, typ) notify(msg, typ) end)

RegisterNetEvent('br:lobby')
AddEventHandler('br:lobby', function(c)
    InLobby = true
    TriggerEvent('esx_paintball:inPaintBall', true)
    KeepStatusFull()
    Revive()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
    Teleport(c.x, c.y, c.z)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 0)
    -- لابی: شلیک ممنوع
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

local function StartLoops(tok)
    local function alive() return InEvent and tok == Token end

    -- دایره + HUD
    CreateThread(function()
        while alive() do
            if Center then
                local ped = PlayerPedId()
                local pc = GetEntityCoords(ped)
                local inside = #(vector2(pc.x, pc.y) - vector2(Center.x, Center.y)) < MarkerRadius
                if not InGulag then
                    if inside then
                        DrawMarker(28, Center.x, Center.y, Center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, MarkerRadius, MarkerRadius, MarkerRadius, 255, 255, 255, 40, false, false, 2, false, nil, nil, false)
                    else
                        DrawMarker(28, Center.x, Center.y, Center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, MarkerRadius, MarkerRadius, MarkerRadius, 255, 0, 0, 60, false, false, 2, false, nil, nil, false)
                    end
                    if NextRadius < MarkerRadius then
                        DrawMarker(28, Center.x, Center.y, Center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, NextRadius, NextRadius, NextRadius, 0, 120, 255, 25, false, false, 2, false, nil, nil, false)
                    end
                end
            end
            if Countdown then
                local left = math.max(0, math.ceil((StartAt - GetGameTimer()) / 1000))
                DrawTxt(0.01, 0.40, 'Start at : ' .. left .. 's', 0.5, 255, 0, 0)
            end
            DrawTxt(0.01, 0.30, 'Blood : ' .. Blood, 0.5, 255, 0, 0)
            DrawTxt(0.01, 0.50, 'Alive Player : ' .. AliveCount, 0.5, 255, 0, 0)
            DisableControlAction(0, 166, true) -- F5
            DisableControlAction(0, 167, true) -- F6
            if OnPlane or NoCombat or Countdown then
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
            end
            Wait(0)
        end
    end)

    -- دمیج بیرون دایره + استمینا + بلیپ
    CreateThread(function()
        local blipTick = 0
        while alive() do
            local ped = PlayerPedId()
            RestorePlayerStamina(PlayerId(), 1.0)
            if Center and not InGulag and not OnPlane and not Countdown and not RevivePending and not IsEntityDead(ped) then
                local pc = GetEntityCoords(ped)
                if #(vector2(pc.x, pc.y) - vector2(Center.x, Center.y)) >= MarkerRadius then
                    local hp = GetEntityHealth(ped) - CFG.Ring.Damage
                    SetEntityHealth(ped, hp <= 100 and 0 or hp)
                end
            end
            blipTick = blipTick + 1
            if Center and blipTick >= 3 then
                blipTick = 0
                RemoveRingBlip()
                RingBlip = AddBlipForRadius(Center.x, Center.y, Center.z, MarkerRadius)
                SetBlipColour(RingBlip, 4)
                SetBlipAlpha(RingBlip, 100)
            end
            Wait(1000)
        end
    end)

    -- چتر خودکار نزدیک زمین
    if CFG.AutoParachute then
        CreateThread(function()
            while alive() do
                local ped = PlayerPedId()
                if not OnPlane and not IsEntityDead(ped) and GetPedParachuteState(ped) <= 0 then
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

    -- استریم لوت
    CreateThread(function()
        local model = GetHashKey('prop_box_ammo03a')
        RequestModel(model)
        WaitFor(function() return HasModelLoaded(model) end, 5000)
        while alive() do
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            local L, spawned = CFG.Loot, 0
            for _, e in ipairs(LootList) do
                if not e.used and not e.skip then
                    local d = #(vector2(pc.x, pc.y) - vector2(e.coords.x, e.coords.y))
                    local obj = LootObj[e.id]
                    if d < L.StreamDistance and not obj and spawned < 3 then
                        RequestCollisionAtCoord(e.coords.x, e.coords.y, pc.z)
                        local ok, gz = GetGroundZFor_3dCoord(e.coords.x, e.coords.y, pc.z + 100.0, false)
                        if ok then
                            local wok, wz = GetWaterHeight(e.coords.x, e.coords.y, gz)
                            if wok and wz > gz then
                                e.skip = true -- زیر آب
                            else
                                local o = CreateObject(model, e.coords.x, e.coords.y, gz, false, true, true)
                                PlaceObjectOnGroundProperly(o)
                                FreezeEntityPosition(o, true)
                                LootObj[e.id] = o
                                spawned = spawned + 1
                            end
                        end
                    elseif obj and d > L.StreamDistance + 60.0 then
                        DeleteEntity(obj)
                        LootObj[e.id] = nil
                    end
                end
            end
            Wait(500)
        end
    end)

    -- تعامل با لوت و جسد
    CreateThread(function()
        while alive() do
            local sleep = 300
            local ped = PlayerPedId()
            if not OnPlane and not InGulag and not RevivePending and not Countdown and not IsEntityDead(ped) then
                local pc = GetEntityCoords(ped)
                local L = CFG.Loot
                local bestId, bestDist, bestKind, bestPos
                for _, e in ipairs(LootList) do
                    local o = LootObj[e.id]
                    if o and not e.used then
                        local oc = GetEntityCoords(o)
                        local d = #(pc - oc)
                        if d < 10.0 and (not bestDist or d < bestDist) then bestId, bestDist, bestKind, bestPos = e.id, d, 'loot', oc end
                    end
                end
                for id, dl in pairs(DeadLoot) do
                    local d = #(pc - dl.coords)
                    if d < 10.0 and (not bestDist or d < bestDist) then bestId, bestDist, bestKind, bestPos = id, d, 'dead', dl.coords end
                end
                if bestId then
                    sleep = 0
                    DrawMarker(0, bestPos.x, bestPos.y, bestPos.z + 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, true, false, 0, true)
                    local label
                    if bestKind == 'loot' then
                        local e
                        for _, x in ipairs(LootList) do if x.id == bestId then e = x break end end
                        label = e and (e.weapon:gsub('^WEAPON_', '') .. (e.armor and (' + ARMOR ' .. e.armor) or '') .. (e.heal and ' + HEAL' or '')) or 'LOOT'
                    else
                        label = 'DEAD BODY LOOT'
                    end
                    Draw3D(bestPos.x, bestPos.y, bestPos.z + 0.8, label)
                    if bestDist <= L.PickupDistance then
                        Help('Dokme ~INPUT_CONTEXT~ jahat loot kardan box')
                        if IsControlJustReleased(0, 38) and GetGameTimer() >= LootCooldown then
                            LootCooldown = GetGameTimer() + 500
                            TriggerServerEvent(bestKind == 'loot' and 'br:useloot' or 'br:useploot', bestId)
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

RegisterNetEvent('br:join')
AddEventHandler('br:join', function(center, radius, count, blood)
    Cleanup()
    local tok = Token
    InEvent = true
    Center = vector3(center.x, center.y, center.z)
    MarkerRadius, NextRadius = radius + 0.0, radius + 0.0
    Blood, AliveCount = blood or 0, count or 0
    TriggerEvent('esx_paintball:inPaintBall', true)
    KeepStatusFull()
    SetPedSuffersCriticalHits(PlayerPedId(), false)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    StartLoops(tok)
    WaitFor(function() return ESX ~= nil end, 5000)
    if not ESX or tok ~= Token then return end
    ESX.TriggerServerCallback('br:getlootsdata', function(list)
        if tok ~= Token then return end
        local out = {}
        for i, e in ipairs(list or {}) do
            out[i] = { id = e.id, coords = vector3(e.coords.x, e.coords.y, e.coords.z), weapon = e.weapon, armor = e.armor, heal = e.heal, used = e.used }
        end
        LootList = out
    end)
end)

-- ----------------------------------------------------------------------------
--  Plane drop
-- ----------------------------------------------------------------------------
local function Jump()
    local ped = PlayerPedId()
    if not OnPlane then return end
    OnPlane = false
    DetachEntity(ped, true, true)
    local c = GetEntityCoords(ped)
    SetEntityCoordsNoOffset(ped, c.x, c.y, c.z - 20.0, false, false, false) -- Sun: z - 20
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped, true, true)
    FreezeEntityPosition(ped, false)
    GiveParachuteAndSns()
    local tok = Token
    SetTimeout(120000, function() if tok == Token then DeletePlane() end end) -- Sun: هواپیما ۱۲۰ ثانیه می‌مونه
end

-- هواپیمای Titan دقیقاً مثل sun (فیزیک واقعی + خلبان)؛ اگه به هر دلیل پرواز نکرد، خودکار جابه‌جایی دستی میشه
local function StartDrop(tok)
    Revive()
    local ped = PlayerPedId()
    local model = GetHashKey(CFG.airplane)
    RequestModel(model)
    if not WaitFor(function() return HasModelLoaded(model) end, 8000) then return notify('Plane Load Nashod !', 'error') end
    local R = MarkerRadius + CFG.PlaneMargin
    local a = math.random() * 2.0 * math.pi
    local sx, sy = Center.x + math.cos(a) * R, Center.y + math.sin(a) * R
    local ex, ey = Center.x - math.cos(a) * R, Center.y - math.sin(a) * R
    local alt = CFG.PlaneAltitude
    local heading = GetHeadingFromVector_2d(ex - sx, ey - sy)

    Plane = CreateVehicle(model, sx, sy, alt, 10.0, false, true)
    local tries = 0
    while not DoesEntityExist(Plane) and tries < 20 do
        Plane = CreateVehicle(model, sx, sy, alt, 10.0, false, true)
        tries = tries + 1
        Wait(100)
    end
    if not DoesEntityExist(Plane) then return notify('Plane Sakhte Nashod !', 'error') end
    SetEntityHeading(Plane, heading)
    SetEntityDynamic(Plane, true)
    ActivatePhysics(Plane)
    SetVehicleForwardSpeed(Plane, CFG.PlaneSpeed)
    SetHeliBladesFullSpeed(Plane)
    SetVehicleEngineOn(Plane, true, true, false)
    ControlLandingGear(Plane, 3)
    OpenBombBayDoors(Plane)
    SetEntityProofs(Plane, true, false, true, false, false, false, false, false)
    Pilot = CreatePedInsideVehicle(Plane, 1, GetHashKey('mp_m_freemode_01'), -1, false, true)
    SetBlockingOfNonTemporaryEvents(Pilot, true)
    SetPedKeepTask(Pilot, true)
    SetPlaneMinHeightAboveTerrain(Plane, 50)
    TaskVehicleDriveToCoord(Pilot, Plane, ex, ey, alt, 2500.0 * 3.6, 500, model, 16777216, 1.0, 1)

    FadeOut(300)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, true)
    RemoveAllPedWeapons(ped, true)
    Wait(1000)
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
    local att = 0
    AttachEntityToEntity(ped, Plane, 0, 5.0, 0.0, 7.0, 0.0, 0.0, 0.0, true, true, false, true, 0, false)
    while not IsEntityAttached(ped) and att < 60 do
        AttachEntityToEntity(ped, Plane, 0, 5.0, 0.0, 7.0, 0.0, 0.0, 0.0, true, true, false, true, 0, false)
        att = att + 1
        Wait(50)
    end
    OnPlane = true
    DoScreenFadeIn(600)

    local dx, dy = ex - sx, ey - sy
    local total = math.sqrt(dx * dx + dy * dy)
    dx, dy = dx / total, dy / total
    local t0, wasInside, manual = GetGameTimer(), false, false
    local mx, my = sx, sy
    while OnPlane and tok == Token do
        -- فالبک: اگه هواپیما بعد از ۴ ثانیه پرواز نکرد، دستی جابه‌جاش میکنیم
        if not manual and GetGameTimer() - t0 > 4000 and (not DoesEntityExist(Plane) or GetEntitySpeed(Plane) < 25.0) then
            manual = true
            local pc = GetEntityCoords(Plane)
            mx, my = pc.x, pc.y
            FreezeEntityPosition(Plane, true)
            SetEntityCollision(Plane, false, false)
        end
        if manual then
            local step = CFG.PlaneSpeed * GetFrameTime()
            mx, my = mx + dx * step, my + dy * step
            SetEntityCoordsNoOffset(Plane, mx, my, alt, false, false, false)
            SetEntityHeading(Plane, heading)
        end
        local pc = GetEntityCoords(ped)
        local inside = #(pc - Center) < MarkerRadius -- sun: GetDistanceBetweenCoords سه‌بعدی < شعاع
        if inside then
            wasInside = true
            Help('Dokme ~INPUT_CONTEXT~ jahat jump')
            if IsControlJustReleased(1, 51) then Jump() break end
        elseif wasInside then
            Jump() break -- از دایره رد شدی: خودکار می‌پری
        end
        if GetGameTimer() - t0 > CFG.JumpTimeout * 1000 then Jump() break end
        Wait(0)
    end
end

RegisterNetEvent('br:start')
AddEventHandler('br:start', function(seconds)
    if not InEvent then return end
    local tok = Token
    InLobby = false
    Countdown = true
    StartAt = GetGameTimer() + (seconds or 10) * 1000
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    CreateThread(function()
        while GetGameTimer() < StartAt and tok == Token do Wait(100) end
        if tok ~= Token then return end
        Countdown = false
        FreezeEntityPosition(PlayerPedId(), false)
        StartDrop(tok)
    end)
end)

-- ----------------------------------------------------------------------------
--  Ring / counters / feed
-- ----------------------------------------------------------------------------
RegisterNetEvent('br:updatemarker')
AddEventHandler('br:updatemarker', function(r)
    NextRadius = (tonumber(r) or NextRadius) + 0.0
    if Shrinking then return end
    Shrinking = true
    local tok = Token
    CreateThread(function()
        while tok == Token and MarkerRadius > NextRadius do
            MarkerRadius = math.max(NextRadius, MarkerRadius - CFG.Ring.ShrinkSpeed * 0.1)
            Wait(100)
        end
        Shrinking = false
    end)
end)

RegisterNetEvent('br:updatepcount')
AddEventHandler('br:updatepcount', function(n) AliveCount = n or AliveCount end)

RegisterNetEvent('br:updateblood')
AddEventHandler('br:updateblood', function(n) Blood = n or Blood end)

RegisterNetEvent('br:pkilled')
AddEventHandler('br:pkilled', function(killer, killed, weapon, head)
    SendNUIMessage({ type = 'addKill', killer = killer, weapon = weapon, killed = killed, headshot = head }) -- فرمت sun
end)

-- ----------------------------------------------------------------------------
--  Loot events
-- ----------------------------------------------------------------------------
RegisterNetEvent('br:updateloot')
AddEventHandler('br:updateloot', function(id)
    for _, e in ipairs(LootList) do if e.id == id then e.used = true break end end
    local o = LootObj[id]
    if o and DoesEntityExist(o) then DeleteEntity(o) end
    LootObj[id] = nil
end)

RegisterNetEvent('br:createploot')
AddEventHandler('br:createploot', function(d)
    if not InEvent or not d or not d.coords then return end
    local model = GetHashKey('prop_box_ammo06a')
    RequestModel(model)
    WaitFor(function() return HasModelLoaded(model) end, 3000)
    local c = vector3(d.coords.x, d.coords.y, d.coords.z)
    local o = CreateObject(model, c.x, c.y, c.z - 0.9, false, true, true)
    PlaceObjectOnGroundProperly(o)
    FreezeEntityPosition(o, true)
    DeadLoot[d.id] = { obj = o, coords = c }
end)

RegisterNetEvent('br:removeploot')
AddEventHandler('br:removeploot', function(id)
    local d = DeadLoot[id]
    if d then
        if d.obj and DoesEntityExist(d.obj) then DeleteEntity(d.obj) end
        DeadLoot[id] = nil
    end
end)

RegisterNetEvent('br:lootGranted')
AddEventHandler('br:lootGranted', function(d)
    if not d then return end
    local ped = PlayerPedId()
    local last
    for _, w in ipairs(d.weapons or {}) do
        local h = GetHashKey(w.name)
        GiveWeaponToPed(ped, h, w.ammo or CFG.Loot.Ammo, false, false)
        last = h
    end
    if last then SetCurrentPedWeapon(ped, last, true) end
    if d.armor then
        SetPedArmour(ped, math.min(100, GetPedArmour(ped) + d.armor))
        notify('Shoma yek armor ' .. d.armor .. ' poushidid', 'success')
    elseif d.heal then
        SetEntityHealth(ped, GetEntityMaxHealth(ped))
        notify('Shoma yek bandage estefade kardid', 'success')
    end
    PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
    local dict = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@'
    RequestAnimDict(dict)
    if WaitFor(function() return HasAnimDictLoaded(dict) end, 2000) then
        TaskPlayAnim(ped, dict, 'plant_floor', 8.0, -8.0, 3750, 2, 0, false, false, false)
        local tok = Token
        SetTimeout(1850, function() if tok == Token then ClearPedTasks(PlayerPedId()) end end)
    end
end)

RegisterNetEvent('br:droploot')
AddEventHandler('br:droploot', function()
    local ped = PlayerPedId()
    local list = {}
    for _, name in ipairs(CFG.Loot.Weapons) do
        local h = GetHashKey(name)
        if HasPedGotWeapon(ped, h, false) then
            list[#list + 1] = { name = name, ammo = math.min(CFG.Loot.Ammo, math.max(1, GetAmmoInPedWeapon(ped, h))) }
        end
    end
    local c = GetEntityCoords(ped)
    if #list > 0 then TriggerServerEvent('br:createdeadpickup', { x = c.x, y = c.y, z = c.z }, list) end
end)

-- ----------------------------------------------------------------------------
--  Blood: ریوایو با E و دوباره پرتاب از آسمان
-- ----------------------------------------------------------------------------
RegisterNetEvent('br:reviveth')
AddEventHandler('br:reviveth', function(blood)
    if not InEvent then return end
    Blood = blood or Blood
    RevivePending = true
    local tok = Token
    CreateThread(function()
        local pos = GetEntityCoords(PlayerPedId())
        Revive()
        local ped = PlayerPedId()
        SetEntityInvincible(ped, true)
        SetEntityHealth(ped, 150)
        notify('Baraye Zende Shodan E Ra Bezanid', 'inform')
        local busy = false
        while RevivePending and tok == Token do
            ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
            if not busy then
                SetTextFont(4)
                SetTextScale(0.0, 0.5)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry('STRING')
                AddTextComponentString('press [E] to heal your self')
                DrawText(0.5, 0.8)
                if IsControlJustReleased(0, 38) then
                    busy = true
                    local done = lib.progressCircle({ duration = CFG.ReviveProgressMs, label = 'Dar Hale Zende Shodan...', position = 'bottom',
                        canCancel = false, disable = { move = true, car = true, combat = true } })
                    if done and RevivePending and tok == Token then TriggerServerEvent('br:redeploy') end
                    busy = false
                end
            end
            Wait(0)
        end
    end)
end)

RegisterNetEvent('br:redeploy')
AddEventHandler('br:redeploy', function()
    if not InEvent then return end
    RevivePending = false
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    SetEntityInvincible(ped, false)
    ClearPedBloodDamage(ped)
    ClearPedTasksImmediately(ped)
    SetEntityCoordsNoOffset(ped, c.x, c.y, CFG.RedeployHeight, false, false, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    GiveParachuteAndSns()
end)

-- ----------------------------------------------------------------------------
--  Gulag
-- ----------------------------------------------------------------------------
local function GulagSound() SendNUIMessage({ type = 'sound', name = 'gulag', volume = 0.9 }) end -- sun: InteractSound_CL:PlayOnOne gulag 0.9

local function EnterGulagSpot(c, heading)
    FadeOut(400)
    Revive()
    local ped = PlayerPedId()
    ClearPedBloodDamage(ped)
    RemoveAllPedWeapons(ped, true)
    Teleport(c.x, c.y, c.z, heading)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 0)
    DoScreenFadeIn(500)
end

RegisterNetEvent('br:waitgulag')
AddEventHandler('br:waitgulag', function(c)
    if not InEvent then return end
    RevivePending, InGulag, NoCombat = false, true, true
    GulagSound()
    EnterGulagSpot(c)
    SetEntityInvincible(PlayerPedId(), true)
    notify('Dar Gulag Montazer Harif Bemanid...', 'inform')
end)

local function Duel(c, freeze, weapon, ammo, opp)
    if not InEvent then return end
    InGulag, NoCombat = true, true
    GulagSound()
    local heading = GetHeadingFromVector_2d(opp.x - c.x, opp.y - c.y)
    EnterGulagSpot(c, heading)
    local ped = PlayerPedId()
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    GiveWeaponToPed(ped, GetHashKey(weapon), ammo, false, true)
    SetCurrentPedWeapon(ped, GetHashKey(weapon), true)
    notify('Duel Shoroo Mishavad !', 'inform')
    local tok = Token
    CreateThread(function() -- Sun: FristPersonView
        while InGulag and tok == Token do
            DisableControlAction(0, 0, true)
            SetFollowPedCamViewMode(4)
            DisableControlAction(0, 22, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon), true)
            Wait(0)
        end
        SetFollowPedCamViewMode(2)
    end)
    SetTimeout((freeze or 3) * 1000, function()
        if tok ~= Token then return end
        local p = PlayerPedId()
        FreezeEntityPosition(p, false)
        SetEntityInvincible(p, false)
        NoCombat = false
    end)
end

RegisterNetEvent('br:waitgulag2')
AddEventHandler('br:waitgulag2', Duel)
RegisterNetEvent('br:waitgulag3')
AddEventHandler('br:waitgulag3', Duel)

RegisterNetEvent('br:backwar')
AddEventHandler('br:backwar', function()
    if not InEvent then return end
    FadeOut(400)
    Revive()
    InGulag, NoCombat, RevivePending = false, false, false
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetFollowPedCamViewMode(2)
    RemoveAllPedWeapons(ped, true)
    Teleport(Center.x, Center.y, 800.0) -- sun: دقیقاً مرکز دایره
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    GiveParachuteAndSns()
    DoScreenFadeIn(600)
end)

-- ----------------------------------------------------------------------------
--  Exit / end
-- ----------------------------------------------------------------------------
RegisterNetEvent('br:leavemeg')
AddEventHandler('br:leavemeg', function(c) CreateThread(function() Leave(c) end) end)

RegisterNetEvent('br:end')
AddEventHandler('br:end', function(c)
    if not InEvent and not InLobby then return end
    notify('WarZone Tamam Shod !', 'inform')
    local tok = Token
    CreateThread(function()
        Wait(1000) -- sun: br:end => Wait(1000)
        if tok == Token then Leave(c) end
    end)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    DeleteLoot()
    DeletePlane()
    RemoveRingBlip()
    local ped = PlayerPedId()
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
end)
