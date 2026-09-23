--[[
    Unique_Event - client core
    NUI bridge, focus handling, generic menu + dialog + progress bar, interaction points and
    the small helpers every event module shares.
]]

UE.State = { event = nil }          -- the event this player is currently playing (nil = none)
UE.ClientActions = {}               -- [event][action] = function(data)   (hub buttons handled on the client)

-- ============================================================
-- ESX
-- ============================================================
ESX = nil
UE.Gang = 'nogang'

CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.Framework.SharedObject, function(obj) ESX = obj end)
        Wait(50)
    end
    while true do
        local data = ESX.GetPlayerData()
        if data and data.gang then
            UE.Gang = data.gang.name or 'nogang'
            break
        end
        Wait(500)
    end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    UE.Gang = (gang and gang.name) or 'nogang'
end)

function UE.SetEvent(name)
    UE.State.event = name
    TriggerEvent('ue:stateChanged', name)
end

-- ============================================================
-- NUI bridge
-- ============================================================
function UE.Send(action, data)
    SendNUIMessage({ action = action, data = data or {} })
end

UE.UI = { open = { hub = false, menu = false, dialog = false, spec = false }, focused = false }

--- (re)applies the NUI focus according to which panels are open
function UE.UI.Update()
    local any = UE.UI.open.hub or UE.UI.open.menu or UE.UI.open.dialog or UE.UI.open.spec
    if any ~= UE.UI.focused then
        UE.UI.focused = any
        SetNuiFocus(any, any)
    end
end

function UE.UI.Set(panel, state)
    UE.UI.open[panel] = state
    UE.UI.Update()
end

-- registers a command under one or several names (mirrors the server-side UE.Command helper)
function UE.Command(names, fn, restricted)
    for _, n in ipairs(UE.Names(names)) do
        RegisterCommand(n, fn, restricted or false)
    end
end

-- always leave a way out if something goes wrong
RegisterCommand(Config.Hub.FixCommand, function()
    UE.UI.open = { hub = false, menu = false, dialog = false, spec = false }
    UE.UI.focused = false
    SetNuiFocus(false, false)
    UE.Send('closeAll')
    UE.Menu.current = nil
    UE.DialogCallback = nil
end, false)

-- ============================================================
-- Notifications / banners / center text / sounds
-- ============================================================
function UE.Notify(msg, kind, title)
    UE.Send('toast', { msg = tostring(msg), type = kind or 'info', title = title })
end

RegisterNetEvent('ue:notify')
AddEventHandler('ue:notify', function(msg, kind, title) UE.Notify(msg, kind, title) end)

function UE.Announce(text, secs, kind)
    UE.Send('banner', { text = text, secs = secs or 5, kind = kind or 'info' })
end

RegisterNetEvent('ue:announce')
AddEventHandler('ue:announce', function(text, secs, kind) UE.Announce(text, secs, kind) end)

--- big text in the lower middle of the screen (replaces ESX.ShowMissionText). Empty text clears it.
function UE.Center(text)
    UE.Send('center', { text = text or '' })
end

function UE.Sound(file, volume)
    UE.Send('sound', { file = file, volume = volume or 0.4 })
end

function UE.HelpText(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

function UE.Draw3D(x, y, z, text, scale)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    local cam = GetGameplayCamCoords()
    local dist = #(cam - vector3(x, y, z))
    local s = (1.0 / math.max(dist, 1.0)) * 6.0 * (scale or 1.0)
    s = UE.Clamp(s, 0.25, 0.9)
    SetTextScale(s, s)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 230)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(sx, sy)
end

-- ============================================================
-- Generic menu (list of clickable rows)
-- def = { title, subtitle, items = { {label, sub, icon, tag, disabled, header, keep, onSelect} }, onBack, onClose }
-- ============================================================
UE.Menu = { current = nil }

function UE.Menu.Open(def)
    UE.Menu.current = def
    local items = {}
    for i, it in ipairs(def.items) do
        items[i] = { label = it.label, sub = it.sub, icon = it.icon, tag = it.tag, disabled = it.disabled or false, header = it.header or false }
    end
    UE.UI.Set('menu', true)
    UE.Send('menu', { title = def.title, subtitle = def.subtitle, items = items, back = def.onBack ~= nil })
end

function UE.Menu.Close()
    if UE.Menu.current then
        UE.Menu.current = nil
        UE.Send('menuClose')
    end
    UE.UI.Set('menu', false)
end

RegisterNUICallback('menu:select', function(data, cb)
    local menu = UE.Menu.current
    cb('ok')
    if not menu then return end
    local item = menu.items[(tonumber(data.index) or -1) + 1]
    if not item or item.disabled or item.header then return end
    if not item.keep then UE.Menu.Close() end
    if item.onSelect then item.onSelect(item) end
end)

RegisterNUICallback('menu:back', function(_, cb)
    local menu = UE.Menu.current
    cb('ok')
    if menu and menu.onBack then
        UE.Menu.Close()
        menu.onBack()
    end
end)

--- fired when the player closes the menu with X / ESC
RegisterNUICallback('menu:closed', function(_, cb)
    local menu = UE.Menu.current
    UE.Menu.current = nil
    UE.UI.Set('menu', false)
    cb('ok')
    if menu and menu.onClose then menu.onClose() end
end)

-- ============================================================
-- Text input dialog
-- ============================================================
UE.DialogCallback = nil

--- UE.Dialog({ title, placeholder, value, numeric }, function(value|nil) ... end)
function UE.Dialog(def, cb)
    UE.DialogCallback = cb
    UE.UI.Set('dialog', true)
    UE.Send('dialog', { title = def.title, placeholder = def.placeholder or '', value = def.value or '', numeric = def.numeric or false })
end

RegisterNUICallback('dialog:submit', function(data, cb)
    cb('ok')
    local fn = UE.DialogCallback
    UE.DialogCallback = nil
    UE.UI.Set('dialog', false)
    if fn then fn(data.value) end
end)

RegisterNUICallback('dialog:cancel', function(_, cb)
    cb('ok')
    local fn = UE.DialogCallback
    UE.DialogCallback = nil
    UE.UI.Set('dialog', false)
    if fn then fn(nil) end
end)

-- ============================================================
-- Progress bar (blocking - call it inside a thread)
-- opts = { cancel = function() return true end }   returns true when finished, false when cancelled
-- ============================================================
function UE.Progress(label, ms, opts)
    opts = opts or {}
    UE.Send('progress', { label = label, ms = ms })
    local startedAt = GetGameTimer()
    while GetGameTimer() - startedAt < ms do
        Wait(50)
        if opts.cancel and opts.cancel() then
            UE.Send('progressStop')
            return false
        end
    end
    UE.Send('progressStop')
    return true
end

-- ============================================================
-- Interaction points (walk up + press E). One thread, adapts its own wait time.
-- UE.Interact.Add(id, { coords, radius, text, cond, onUse, markerDist })
-- ============================================================
UE.Interact = { list = {} }

function UE.Interact.Add(id, def) UE.Interact.list[id] = def end
function UE.Interact.Remove(id) UE.Interact.list[id] = nil end

CreateThread(function()
    while true do
        local wait = 700
        if next(UE.Interact.list) then
            local pc = GetEntityCoords(PlayerPedId())
            for _, d in pairs(UE.Interact.list) do
                if not d.cond or d.cond() then
                    local dist = #(pc - d.coords)
                    if dist <= (d.markerDist or 12.0) then
                        wait = 0
                        if d.marker ~= false then
                            DrawMarker(2, d.coords.x, d.coords.y, d.coords.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 60, 80, 180, false, true, 2, false, nil, nil, false)
                        end
                        if dist <= (d.radius or 2.0) then
                            UE.HelpText(d.text or 'Press ~INPUT_CONTEXT~ to interact')
                            if IsControlJustPressed(0, 38) and d.onUse then d.onUse() end
                        end
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-- ============================================================
-- Key bindings (RegisterKeyMapping, so players can rebind them in Settings > Key Bindings)
-- One command per key; the handler that runs depends on which event you're in.
-- ============================================================
UE.KeyHandlers = {}

function UE.BindKey(key, description, eventName, fn)
    key = key:upper()
    if not UE.KeyHandlers[key] then
        UE.KeyHandlers[key] = {}
        local cmd = 'ue_key_' .. key:lower()
        RegisterCommand(cmd, function()
            local handler = UE.KeyHandlers[key][UE.State.event or '']
            if handler then handler() end
        end, false)
        RegisterKeyMapping(cmd, description, 'keyboard', key)
    end
    UE.KeyHandlers[key][eventName] = fn
end

-- ============================================================
-- Player / world helpers
-- ============================================================
function UE.Freeze(state)
    TriggerEvent(Config.Framework.FreezeEvent, state)
end

function UE.FillStatus()
    TriggerEvent(Config.Framework.StatusSet, 'hunger', 1000000)
    TriggerEvent(Config.Framework.StatusSet, 'thirst', 1000000)
end

function UE.GiveWeapon(name, ammo)
    GiveWeaponToPed(PlayerPedId(), GetHashKey(name), ammo or 250, false, true)
end

function UE.LoadModel(model, timeoutMs)
    local hash = type(model) == 'number' and model or GetHashKey(model)
    if not IsModelInCdimage(hash) then return false end
    RequestModel(hash)
    local waited = 0
    while not HasModelLoaded(hash) and waited < (timeoutMs or 5000) do
        Wait(10)
        waited = waited + 10
    end
    return HasModelLoaded(hash)
end

function UE.LoadAnim(dict, timeoutMs)
    RequestAnimDict(dict)
    local waited = 0
    while not HasAnimDictLoaded(dict) and waited < (timeoutMs or 3000) do
        Wait(10)
        waited = waited + 10
    end
    return HasAnimDictLoaded(dict)
end

--- waits for the ground around a point to stream in
function UE.LoadCollision(x, y, z, timeoutMs)
    RequestCollisionAtCoord(x, y, z)
    local waited = 0
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) and waited < (timeoutMs or 3000) do
        RequestCollisionAtCoord(x, y, z)
        Wait(50)
        waited = waited + 50
    end
end

--- ground height at x,y (nil if it never streams in)
function UE.GroundZ(x, y, startZ)
    for i = 1, 60 do
        local found, z = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, (startZ or 300.0) + 0.0, false)
        if found and z ~= 0.0 then return z end
        RequestCollisionAtCoord(x + 0.0, y + 0.0, (startZ or 300.0) + 0.0)
        Wait(20)
    end
    return nil
end

function UE.Teleport(x, y, z, heading)
    local ped = PlayerPedId()
    RequestCollisionAtCoord(x + 0.0, y + 0.0, z + 0.0)
    SetEntityCoordsNoOffset(ped, x + 0.0, y + 0.0, z + 0.0, false, false, false)
    if heading then SetEntityHeading(ped, heading + 0.0) end
    UE.LoadCollision(x, y, z, 2500)
end

--- Triggers the server's revive event and waits until the player is really up (falls back to a manual resurrect).
function UE.Revive(timeoutMs)
    TriggerEvent(Config.Framework.ReviveTrigger)
    local waited = 0
    timeoutMs = timeoutMs or 8000
    local ped = PlayerPedId()
    while (IsEntityDead(ped) or IsPedFatallyInjured(ped)) and waited < timeoutMs do
        Wait(100)
        waited = waited + 100
        ped = PlayerPedId()
    end
    if IsEntityDead(PlayerPedId()) then
        local c = GetEntityCoords(PlayerPedId())
        NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(PlayerPedId()), true, false)
        ClearPedBloodDamage(PlayerPedId())
        Wait(200)
    end
    Wait(600)   -- let the ambulance job's fade in/out finish
end

--- Works out which player (server id) killed `ped`. Returns 0 when nobody did (fall, drowning...).
function UE.ResolveKiller(ped)
    local source = GetPedSourceOfDeath(ped)
    if not source or source == 0 then return 0 end
    if IsEntityAVehicle(source) then source = GetPedInVehicleSeat(source, -1) end
    if source ~= 0 and source ~= ped and IsEntityAPed(source) and IsPedAPlayer(source) then
        local idx = NetworkGetPlayerIndexFromPed(source)
        if idx and idx ~= -1 then return GetPlayerServerId(idx) end
    end
    return 0
end

function UE.Fade(out, ms)
    if out then DoScreenFadeOut(ms or 800) else DoScreenFadeIn(ms or 800) end
end

--- restores the saved skin of the player (skinchanger / esx_skin)
function UE.RestoreSkin()
    if not ESX then return end
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if skin then TriggerEvent('skinchanger:loadSkin', skin) end
    end)
end

--- applies a partial outfit on top of the current skin
function UE.ApplyOutfit(male, female)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if not skin then return end
        local outfit = (skin.sex == 0) and male or female
        TriggerEvent('skinchanger:loadClothes', skin, outfit)
    end)
end

function UE.PedInFront(ped, distance)
    return GetOffsetFromEntityInWorldCoords(ped, 0.0, distance or 2.0, 0.0)
end

-- ============================================================
-- Death loop helper: calls fn() once each time the local player dies (until stop() returns true)
-- ============================================================
function UE.WatchDeath(shouldRun, onDeath)
    CreateThread(function()
        while shouldRun() do
            Wait(100)
            local ped = PlayerPedId()
            if IsEntityDead(ped) or IsPedFatallyInjured(ped) then
                Wait(400)
                if shouldRun() then onDeath(ped) end
                -- wait until the player is alive again before checking once more
                while shouldRun() and (IsEntityDead(PlayerPedId()) or IsPedFatallyInjured(PlayerPedId())) do
                    Wait(200)
                end
            end
        end
    end)
end

-- Cleans everything if the resource is restarted
AddEventHandler('onResourceStop', function(res)
    if res ~= UE.Resource then return end
    SetNuiFocus(false, false)
    UE.Center('')
end)
