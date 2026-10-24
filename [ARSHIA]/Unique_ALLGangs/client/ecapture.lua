-- E-capture (client). The server runs the progress; this file shows it, takes
-- the E press, and spawns the zombies that come with a capture.

local progress   = {}   -- [zoneKey] = { value, duration, gang }
local zombies    = {}   -- [zoneKey] = { peds }
local lastEnd    = {}

local function ecCfg() return Config.Territory and Config.Territory.ECapture end

local function zoneOf(k)
    for _, z in ipairs(Config.Territory.Zones or {}) do
        if z.key == k then return z end
    end
    return nil
end

RegisterNetEvent('ecapture:progress')
AddEventHandler('ecapture:progress', function(k, value, duration, gang, scores)
    if not gang then progress[k] = nil return end
    progress[k] = { value = value, duration = duration, gang = gang, scores = scores }
end)

-- E in a zone that is not yours: the capture menu (same idea as the PvP capture island menu)
local function openCaptureMenu(k, z)
    TriggerServerEvent('ecapture:info', k)
    local pending = { k = k, z = z }
    CaptureMenuPending = pending
end

CaptureMenuPending = nil
RegisterNetEvent('ecapture:infoReply')
AddEventHandler('ecapture:infoReply', function(k, owner, running)
    local z = zoneOf(k)
    if not z then return end
    local elements = {
        { label = ('Zone: %s'):format(z.label or k), value = 'info', disabled = true },
        { label = ('Mohafez: %s'):format(owner or 'Azad'), value = 'info2', disabled = true },
    }
    if running then
        table.insert(elements, { label = 'Gereftan dar jaryan ast', value = 'info3', disabled = true })
    else
        table.insert(elements, { label = 'Shoro gereftan (' .. (Config.Territory.ECapture.CaptureTime or 180) .. ' sanie)', value = 'start' })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ecapture_menu', {
        title = 'Gereftan zone', align = 'top-left', elements = elements,
    }, function(data, menu)
        if data.current.value == 'start' then
            menu.close()
            TriggerServerEvent('ecapture:start', k)
        end
    end, function(data, menu) menu.close() end)
end)

CreateThread(function()
    while true do
        local cfg = ecCfg()
        local sleep = 800
        if cfg and cfg.Enabled and PlayerData and PlayerData.gang then
            local pc = GetEntityCoords(PlayerPedId())
            for _, k in ipairs(cfg.Zones) do
                local z = zoneOf(k)
                if z and not progress[k] then
                    local d = #(pc - z.coord)
                    if d < (z.radius or 50.0) + 2.0 and d < cfg.InteractRange then
                        sleep = 0
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName(('Baraye gereftan %s ~INPUT_CONTEXT~ bezan'):format(z.label or k))
                        EndTextCommandDisplayHelp(0, false, false, -1)
                        if IsControlJustReleased(0, 38) then openCaptureMenu(k, z) end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

-- progress bar at the top of the screen
CreateThread(function()
    while true do
        local shown = false
        for k, p in pairs(progress) do
            local z = zoneOf(k)
            local pc = GetEntityCoords(PlayerPedId())
            if z and #(pc - z.coord) < 150.0 then
                shown = true
                local pct = math.min(100, math.floor((p.value / math.max(1, p.duration)) * 100))
                SetTextFont(4); SetTextScale(0.4, 0.4); SetTextColour(255, 255, 255, 255); SetTextOutline()
                SetTextEntry('STRING')
                AddTextComponentString(('%s | %s | %d%%'):format(z.label or k, p.scores or '', pct))
                DrawText(0.42, 0.04)
            end
        end
        Wait(shown and 0 or 500)
    end
end)

-- zombies: networked (server spawned). Each client takes control of the ones near
-- it and attacks only when a player comes within AggroRange.
local zombieNet = {}   -- [zoneKey] = { netIds, aggro }

RegisterNetEvent('ecapture:zombieNet')
AddEventHandler('ecapture:zombieNet', function(k, ids, aggro)
    zombieNet[k] = { ids = ids or {}, aggro = aggro or 10.0 }
end)

CreateThread(function()
    while true do
        Wait(500)
        local pc = GetEntityCoords(PlayerPedId())
        for k, z in pairs(zombieNet) do
            for _, nid in ipairs(z.ids) do
                if NetworkDoesNetworkIdExist(nid) then
                    local ent = NetworkGetEntityFromNetworkId(nid)
                    if ent ~= 0 and DoesEntityExist(ent) and not IsPedDeadOrDying(ent, true) then
                        if #(pc - GetEntityCoords(ent)) < z.aggro then
                            if not NetworkHasControlOfEntity(ent) then
                                NetworkRequestControlOfEntity(ent)
                            end
                            if NetworkHasControlOfEntity(ent) then
                                SetBlockingOfNonTemporaryEvents(ent, false)
                                SetPedRelationshipGroupHash(ent, GetHashKey('HATES_PLAYER'))
                                TaskCombatPed(ent, PlayerPedId(), 0, 16)
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('ecapture:end')
AddEventHandler('ecapture:end', function(k)
    lastEnd[k] = GetGameTimer()
    zombieNet[k] = nil
end)

-- ── look: same as the PvP capture island ────────────────────────────────────
local ecBlips = {}     -- [zoneKey] = { radius = blip, marker = blip }
local ecOwners = {}    -- [zoneKey] = { owner, running }

local function ecDisplay() return ecCfg().Display end

local function ecBuildBlips()
    local d = ecDisplay()
    for _, k in ipairs(ecCfg().Zones) do
        local z = zoneOf(k)
        if z and not ecBlips[k] then
            local rb = AddBlipForRadius(z.coord.x, z.coord.y, z.coord.z, (z.radius or 50.0) + 0.0)
            SetBlipColour(rb, d.Blip.color)
            SetBlipAlpha(rb, 110)
            SetBlipAsShortRange(rb, false)
            local mb = AddBlipForCoord(z.coord.x, z.coord.y, z.coord.z)
            SetBlipSprite(mb, d.Blip.sprite)
            SetBlipScale(mb, d.Blip.scale)
            SetBlipColour(mb, d.Blip.color)
            SetBlipAsShortRange(mb, false)
            ecBlips[k] = { radius = rb, marker = mb }
        end
    end
end

local function ecRefreshNames()
    local d = ecDisplay()
    for k, b in pairs(ecBlips) do
        local z = zoneOf(k)
        local o = ecOwners[k] or {}
        local owner = o.owner or 'Azad'
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(('%s | %s | %s%s'):format(d.BlipPrefix, z and z.label or k, owner, o.running and ' | GERFTAN' or ''))
        EndTextCommandSetBlipName(b.marker)
    end
end

RegisterNetEvent('ecapture:ownersAllReply')
AddEventHandler('ecapture:ownersAllReply', function(map)
    ecOwners = map or {}
    ecRefreshNames()
end)

CreateThread(function()
    while not Config.Territory or not ecCfg() do Wait(500) end
    ecBuildBlips()
    while true do
        TriggerServerEvent('ecapture:ownersAll')
        Wait(15000)
    end
end)

-- the red circle on the ground, like the PvP capture zone
CreateThread(function()
    while true do
        local sleep = 1000
        local cfg = ecCfg()
        if cfg and cfg.Enabled then
            local pc = GetEntityCoords(PlayerPedId())
            local d = ecDisplay()
            for _, k in ipairs(cfg.Zones) do
                local z = zoneOf(k)
                if z and #(pc - z.coord) < 150.0 then
                    sleep = 0
                    DrawMarker(28, z.coord.x, z.coord.y, z.coord.z, 0, 0, 0, 0, 0, 0,
                        (z.radius or 50.0) * 2, (z.radius or 50.0) * 2, 1.0,
                        d.ZoneColor.r, d.ZoneColor.g, d.ZoneColor.b, d.ZoneColor.a, false, false, 2, false, nil, nil, false)
                end
            end
        end
        Wait(sleep)
    end
end)

