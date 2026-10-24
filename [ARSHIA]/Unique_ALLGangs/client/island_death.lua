-- Island death / revive (client). Rules in Config.Territory.Island.Death.
-- The server does every decision; this file only shows things and reports
-- deaths and /e cpr attempts.

local reported      = false
local deathEnds     = 0
local markers       = {}   -- [victimServerId] = { blip, coords }
local drops         = {}   -- [id] = { coords = vector3, count }
local reviveBusy    = false

local function islandCfg() return Config.Territory and Config.Territory.Island end
local function deathCfg()  local i = islandCfg(); return i and i.Death end

local function insideIslandClient(c)
    local i = islandCfg()
    if not i or not i.Enabled then return false end
    return #(c - i.coords) <= (i.radius or 1100.0)
end

local function notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

local function drawTxt(text, x, y)
    SetTextFont(4)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 50, 50, 255)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

-- exported for other resources (esx_uniquejobs medic G-request): true when the
-- rule "no medic alert on the island" applies to this player right now.
exports('IslandNoMedic', function()
    local cfg = deathCfg()
    return (cfg and cfg.Enabled and cfg.BlockMedicAlert and insideIslandClient(GetEntityCoords(PlayerPedId()))) or false
end)

-- ── 1. report a death that happens on the island ─────────────────────────
CreateThread(function()
    while true do
        Wait(500)
        local cfg = deathCfg()
        if cfg and cfg.Enabled then
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                if not reported and insideIslandClient(GetEntityCoords(ped)) then
                    reported = true
                    TriggerServerEvent('island_death:died')
                end
            else
                reported = false
            end
        end
    end
end)

RegisterNetEvent('island_death:youDied')
AddEventHandler('island_death:youDied', function(window, blockMedic)
    deathEnds = GetGameTimer() + (window or 300) * 1000
    if blockMedic then
        notify('~r~Dar jazire medic khabar dade nemishavad. Montazer-e ehya-ye gang-e khod bashid.')
    end
end)

RegisterNetEvent('island_death:released')
AddEventHandler('island_death:released', function()
    deathEnds = 0
    notify('~r~Kasi shoma ra ehya nakard. Az zamin azad shodid.')
end)

-- countdown while dead on the island
CreateThread(function()
    while true do
        if deathEnds > GetGameTimer() and IsEntityDead(PlayerPedId()) then
            Wait(0)
            local left = math.floor((deathEnds - GetGameTimer()) / 1000)
            drawTxt(('Montazer-e ehya: %ds | Gang ya mottahed bayad /e cpr bezanand'):format(left), 0.35, 0.82)
        else
            Wait(500)
        end
    end
end)

-- ── 2. the gang and allies see a marker on the dead player ───────────────
RegisterNetEvent('island_death:marker')
AddEventHandler('island_death:marker', function(victimId, name, id, coords, gang)
    if markers[victimId] and markers[victimId].blip and DoesBlipExist(markers[victimId].blip) then
        RemoveBlip(markers[victimId].blip)
    end
    local c = vector3(coords.x, coords.y, coords.z)
    local blip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(blip, 303)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(('%s [%d] - %s'):format(name, id, gang))
    EndTextCommandSetBlipName(blip)
    markers[victimId] = { blip = blip, coords = c }
end)

RegisterNetEvent('island_death:clearMarker')
AddEventHandler('island_death:clearMarker', function(victimId)
    local m = markers[victimId]
    if m then
        if m.blip and DoesBlipExist(m.blip) then RemoveBlip(m.blip) end
        markers[victimId] = nil
    end
end)

-- nearest dead player that is still marked, within range
local function nearestMarkedDead(ped, range)
    local best, bestD = nil, range
    local pc = GetEntityCoords(ped)
    for vid, m in pairs(markers) do
        local d = #(pc - m.coords)
        if d <= bestD then best, bestD = vid, d end
    end
    return best
end

-- ── 3. /e cpr next to a marked dead player = revive attempt ──────────────
-- Own bottom bar (the scenario keeps running while it fills). X cancels.
local function drawReviveBar(pct, label)
    DrawRect(0.5, 0.94, 0.32, 0.03, 0, 0, 0, 170)
    DrawRect(0.5 - 0.15 + (0.30 * pct) / 2, 0.94, 0.30 * pct, 0.022, 60, 200, 255, 230)
    SetTextFont(4); SetTextScale(0.35, 0.35); SetTextColour(255, 255, 255, 255); SetTextCentre(true)
    SetTextEntry('STRING'); AddTextComponentString(label)
    DrawText(0.5, 0.925)
end

CreateThread(function()
    while true do
        Wait(250)
        local cfg = deathCfg()
        local ped = PlayerPedId()
        if cfg and cfg.Enabled and not reviveBusy and insideIslandClient(GetEntityCoords(ped)) and IsPedUsingScenario(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD') then
            local vid = nearestMarkedDead(ped, cfg.ReviveRange)
            if vid then
                reviveBusy = true
                local start = GetGameTimer()
                local ok = true
                while GetGameTimer() - start < cfg.ReviveTime do
                    Wait(0)
                    if not IsPedUsingScenario(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD') or not markers[vid] then ok = false break end
                    if IsControlJustReleased(0, 73) then ok = false break end -- X cancels
                    local pct = (GetGameTimer() - start) / cfg.ReviveTime
                    drawReviveBar(pct, ('Dar hale ehya... (X baraye laghv) %d%%'):format(math.floor(pct * 100)))
                end
                if ok then TriggerServerEvent('island_death:revive', vid) end
                reviveBusy = false
            end
        end
    end
end)

-- ── 4. you were revived ───────────────────────────────────────────────────
RegisterNetEvent('island_death:revived')
AddEventHandler('island_death:revived', function(health)
    local ped = PlayerPedId()
    local c = GetEntityCoords(ped)
    NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(ped), true, false)
    SetEntityHealth(PlayerPedId(), health or 150)
    deathEnds = 0
    reported = false
end)

-- ── 5. dropped piles: E to pick up ───────────────────────────────────────
RegisterNetEvent('island_death:drops')
AddEventHandler('island_death:drops', function(list)
    drops = {}
    for _, d in ipairs(list or {}) do
        drops[d.id] = { coords = vector3(d.coords.x, d.coords.y, d.coords.z), count = d.count }
    end
end)

CreateThread(function()
    TriggerServerEvent('island_death:requestDrops')
    while true do
        local cfg = deathCfg()
        local near = false
        if cfg and cfg.Enabled then
            local pc = GetEntityCoords(PlayerPedId())
            for id, d in pairs(drops) do
                local dist = #(pc - d.coords)
                if dist < 15.0 then
                    near = true
                    DrawMarker(1, d.coords.x, d.coords.y, d.coords.z - 0.9, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.4, 255, 80, 80, 150, false, true, 2, nil, nil, false, false)
                    if dist < (cfg.PickupRange or 2.0) then
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName('Baraye bardashtan ~INPUT_CONTEXT~ bezan')
                        EndTextCommandDisplayHelp(0, false, false, -1)
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('island_death:pickup', id)
                        end
                    end
                end
            end
        end
        Wait(near and 0 or 500)
    end
end)
