--[[ Unique RP - extra admin tools (ported from Sunset's admin set, written for this server)
    Used by client/menuv_ui.lua:  Flip vehicle, Turbo, Vehicle extras, Freecam.
]]

local function notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end

local function targetVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then return GetVehiclePedIsIn(ped, false) end
    local c = GetEntityCoords(ped)
    local v = GetClosestVehicle(c.x, c.y, c.z, 6.0, 0, 71)
    if v ~= 0 and DoesEntityExist(v) then return v end
    return nil
end

local function takeControl(ent)
    NetworkRequestControlOfEntity(ent)
    local t = GetGameTimer()
    while not NetworkHasControlOfEntity(ent) and GetGameTimer() - t < 1000 do
        NetworkRequestControlOfEntity(ent)
        Wait(0)
    end
end

-- ------------------------------------------------------------- vehicle ---
function UniqueFlipVehicle()
    local v = targetVehicle()
    if not v then return notify('~r~Hich mashini nazdik shoma nist!') end
    takeControl(v)
    SetVehicleOnGroundProperly(v)
    notify('~g~Vehicle flipped upright')
end

function UniqueToggleTurbo()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return notify('~r~Shoma savar mashin nistid!') end
    local v = GetVehiclePedIsIn(ped, false)
    takeControl(v)
    SetVehicleModKit(v, 0)
    local on = not IsToggleModOn(v, 18)
    ToggleVehicleMod(v, 18, on)
    notify('~y~Turbo: ' .. (on and '~g~ON' or '~r~OFF'))
end

function UniqueVehicleExtras()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return notify('~r~Shoma savar mashin nistid!') end
    local v = GetVehiclePedIsIn(ped, false)
    local options = {}
    for i = 0, 20 do
        if DoesExtraExist(v, i) then
            local on = IsVehicleExtraTurnedOn(v, i)
            options[#options + 1] = {
                title = ('Extra #%d'):format(i),
                description = on and 'ON  (click to hide)' or 'OFF (click to show)',
                icon = on and 'eye' or 'eye-slash',
                onSelect = function()
                    takeControl(v)
                    SetVehicleExtra(v, i, on and 1 or 0)      -- 1 = disable, 0 = enable
                    UniqueVehicleExtras()
                end,
            }
        end
    end
    if #options == 0 then return notify('~y~This vehicle has no extras') end
    lib.registerContext({ id = 'unique_vehicle_extras', title = 'Vehicle Extras', options = options })
    lib.showContext('unique_vehicle_extras')
end

-- ------------------------------------------------------------- freecam ---
UniqueFreecamActive = false
local fc = { cam = nil, speed = 1.0 }

local function stopFreecam()
    if not UniqueFreecamActive then return end
    UniqueFreecamActive = false
    RenderScriptCams(false, false, 0, true, true)
    if fc.cam then SetCamActive(fc.cam, false); DestroyCam(fc.cam, false); fc.cam = nil end
    FreezeEntityPosition(PlayerPedId(), false)
end

function UniqueFreecamToggle()
    if UniqueFreecamActive then
        stopFreecam()
        return notify('~y~Freecam: ~r~OFF')
    end
    UniqueFreecamActive = true
    local ped = PlayerPedId()
    local pos, rot = GetEntityCoords(ped), GetGameplayCamRot(0)
    fc.cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(fc.cam, pos.x, pos.y, pos.z + 1.0)
    SetCamRot(fc.cam, rot.x, rot.y, rot.z, 2)
    SetCamActive(fc.cam, true)
    RenderScriptCams(true, false, 0, true, true)
    FreezeEntityPosition(ped, true)
    notify('~y~Freecam: ~g~ON ~s~(WASD, Shift fast, Ctrl slow, Q/E up-down)')

    CreateThread(function()
        while UniqueFreecamActive do
            Wait(0)
            local camRot, camPos = GetCamRot(fc.cam, 2), GetCamCoord(fc.cam)
            local right, forward = GetCamMatrix(fc.cam)
            local speed = fc.speed
            if IsControlPressed(0, 21) then speed = speed * 3.0 end      -- Shift
            if IsControlPressed(0, 36) then speed = speed * 0.3 end      -- Ctrl
            local np = camPos
            if IsControlPressed(0, 32) then np = np + forward * speed end
            if IsControlPressed(0, 33) then np = np - forward * speed end
            if IsControlPressed(0, 34) then np = np - right * speed end
            if IsControlPressed(0, 35) then np = np + right * speed end
            if IsControlPressed(0, 44) then np = np + vector3(0, 0, speed) end   -- Q
            if IsControlPressed(0, 46) then np = np - vector3(0, 0, speed) end   -- E
            local rx = math.max(-89.0, math.min(89.0, camRot.x - GetDisabledControlNormal(0, 2) * 8.0))
            local rz = camRot.z - GetDisabledControlNormal(0, 1) * 8.0
            SetCamCoord(fc.cam, np.x, np.y, np.z)
            SetCamRot(fc.cam, rx, 0.0, rz, 2)
            for _, c in ipairs({ 1, 2, 24, 25, 30, 31 }) do DisableControlAction(0, c, true) end
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then stopFreecam() end
end)

-- ====================================================== spectate: prev / next ===
-- [<] / [>] while spectating (works for both the F4-menu path and the report path)
local stepping = false
local function spectateStep(dir)
    local sp = UniqueSpec
    if stepping or not sp then return end
    stepping = true
    ESX.TriggerServerCallback('Admin_Menu:GetActivePlayers', function(players)
        local me, ids = GetPlayerServerId(PlayerId()), {}
        for key in pairs(players or {}) do
            local sid = tonumber(key)
            if sid and sid ~= me then ids[#ids + 1] = sid end
        end
        table.sort(ids)
        if #ids == 0 then stepping = false return end
        local cur = 0
        for i, id in ipairs(ids) do if id == sp.id then cur = i break end end
        local nextId = ids[((cur - 1 + dir) % #ids) + 1]
        CreateThread(function()
            if sp.path == 'menu' then
                if lastspec and lastspec ~= 0 then spec[lastspec] = false end
                lastspec, spec[nextId] = nextId, true
                if not spectate(nextId) then spec[nextId], lastspec = false, 0 end
            else
                AdutySpectate(nextId)
            end
            Wait(400)
            stepping = false
        end)
    end)
end

CreateThread(function()
    while true do
        local sp = UniqueSpec
        if sp and (GetGameTimer() - sp.t) < 200 and not IsNuiFocused() then
            if IsControlJustPressed(0, 174) then spectateStep(-1)      -- left arrow
            elseif IsControlJustPressed(0, 175) then spectateStep(1) end -- right arrow
            Wait(0)
        else
            Wait(250)
        end
    end
end)

-- ============================================================ talking players ===
-- card on the left under the chat: who is talking in voice right now (ID, name, distance)
UniqueTalkActive = false

function UniqueTalkToggle()
    UniqueTalkActive = not UniqueTalkActive
    notify('~y~Talking list: ' .. (UniqueTalkActive and '~g~ON' or '~r~OFF'))
    if not UniqueTalkActive then return end
    CreateThread(function()
        local me = GetPlayerServerId(PlayerId())
        while UniqueTalkActive do
            Wait(0)
            local rows, myPos = {}, GetEntityCoords(PlayerPedId())
            for _, pl in ipairs(GetActivePlayers()) do
                if NetworkIsPlayerTalking(pl) then
                    local sid = GetPlayerServerId(pl)
                    local ped = GetPlayerPed(pl)
                    rows[#rows + 1] = {
                        sid = sid, name = GetPlayerName(pl),
                        dist = (sid == me) and 0 or #(GetEntityCoords(ped) - myPos),
                    }
                end
            end
            table.sort(rows, function(a, b) return a.dist < b.dist end)
            if #rows > 0 then
                local X0, W, TOP, LH = 0.015, 0.17, 0.43, 0.026
                local h = 0.032 + #rows * LH
                DrawRect(X0 + W / 2, TOP + h / 2, W, h, 10, 12, 18, 205)
                DrawRect(X0 + W / 2, TOP + 0.0015, W, 0.003, 101, 174, 255, 255)
                local function t(str, x, y, r, g, b, right)
                    SetTextFont(4); SetTextProportional(true); SetTextScale(0.0, 0.29)
                    SetTextColour(r, g, b, 255); SetTextOutline()
                    if right then SetTextRightJustify(true); SetTextWrap(0.0, x) end
                    SetTextEntry('STRING'); AddTextComponentString(str)
                    EndTextCommandDisplayText(right and 0.0 or x, y)
                end
                t('TALKING', X0 + 0.008, TOP + 0.006, 101, 174, 255, false)
                for i, r in ipairs(rows) do
                    local y = TOP + 0.030 + (i - 1) * LH
                    t(('~g~●~s~ [%d] %s'):format(r.sid, r.name), X0 + 0.008, y, 255, 255, 255, false)
                    t(r.dist > 0 and ('%dm'):format(math.floor(r.dist)) or 'you', X0 + W - 0.008, y, 190, 198, 212, true)
                end
            end
        end
    end)
end

-- ======================================================= object / IPL / alarm ===
function UniqueDeleteObject(modelName)
    modelName = tostring(modelName or ''):gsub('%s+', '')
    if modelName == '' then return end
    local hash = tonumber(modelName) or GetHashKey(modelName)
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    local obj = GetClosestObjectOfType(c.x, c.y, c.z, 300.0, hash, false, false, false)
    if obj == 0 or not DoesEntityExist(obj) then return notify('~r~No object of that model within 300m') end
    local dist = #(GetEntityCoords(obj) - c)
    local networked = NetworkGetEntityIsNetworked(obj)
    if networked then takeControl(obj) end
    SetEntityAsMissionEntity(obj, true, true)
    if networked then DeleteEntity(obj) else DeleteObject(obj) end
    notify(('~g~Deleted ~s~%s ~y~(%.1fm)%s'):format(modelName, dist, networked and '' or ' ~o~- map prop: only for you'))
end

function UniqueIpl(name, on)
    name = tostring(name or ''):gsub('%s+', '')
    if name == '' then return end
    if on then RequestIpl(name) else RemoveIpl(name) end
    notify(('~y~IPL ~s~%s: %s ~o~(only for you)'):format(name, on and '~g~ON' or '~r~OFF'))
end

local reminders = 0
function UniqueReminder(minutes, text)
    minutes = tonumber(minutes)
    text = tostring(text or '')
    if not minutes or minutes < 1 or text == '' then return notify('~r~Minutes (>=1) and text are required') end
    reminders = reminders + 1
    local function fire(prefix)
        lib.notify({ title = 'Reminder' .. prefix, description = text, type = 'warning', duration = 8000, position = 'center-right' })
        TriggerEvent('chat:addMessage', { color = { 255, 200, 0 }, multiline = true, args = { '[REMINDER]', text } }, 'staff')
    end
    if minutes > 2 then SetTimeout((minutes - 2) * 60000, function() fire(' (in 2 min)') end) end
    if minutes > 1 then SetTimeout((minutes - 1) * 60000, function() fire(' (in 1 min)') end) end
    SetTimeout(minutes * 60000, function() fire(' - now') end)
    notify(('~g~Reminder set for %d min'):format(minutes))
end

function UniqueWorldRange(range, world)
    TriggerServerEvent('Unique_Admin:worldRange', tonumber(range), tonumber(world))
end
