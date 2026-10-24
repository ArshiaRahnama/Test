-- Island death / revive. Rules live in Config.Territory.Island.Death.
-- The island is the red circle (Config.Territory.Island). Everything here only
-- applies to deaths that happen inside that circle.

local DeadOnIsland = {}   -- [src] = { coords, time, gang, name }
local Drops        = {}   -- [id]  = { coords, items = { {item,count} | {weapon,ammo} }, expires }
local dropSeq      = 0

local function islandCfg() return Config.Territory and Config.Territory.Island end
local function deathCfg()  local i = islandCfg(); return i and i.Death end

local function insideIsland(c)
    local i = islandCfg()
    if not i or not i.Enabled then return false end
    return #(vector3(c.x, c.y, c.z) - i.coords) <= (i.radius or 1100.0)
end

local function gangOf(x)
    local g = x and x.gang and x.gang.name
    if not g or g == '' or g == 'nogang' then return nil end
    return g
end

local function notify(src, msg) TriggerClientEvent('esx:showNotification', src, msg) end

local function dropList()
    local out = {}
    for id, d in pairs(Drops) do
        out[#out + 1] = { id = id, coords = { x = d.coords.x, y = d.coords.y, z = d.coords.z }, count = #d.items }
    end
    return out
end

local function broadcastDrops() TriggerClientEvent('island_death:drops', -1, dropList()) end

-- the client asks for the piles when it joins
RegisterNetEvent('island_death:requestDrops')
AddEventHandler('island_death:requestDrops', function()
    TriggerClientEvent('island_death:drops', source, dropList())
end)

-- ── death: the client reports it when it happens on the island ────────────
RegisterNetEvent('island_death:died')
AddEventHandler('island_death:died', function()
    local src = source
    local cfg = deathCfg()
    if not cfg or not cfg.Enabled or DeadOnIsland[src] then return end

    local x = ESX.GetPlayerFromId(src)
    if not x then return end
    local p = GetEntityCoords(GetPlayerPed(src))
    if not insideIsland(p) then return end

    -- drop the good items where the player fell
    local items = {}
    for _, name in ipairs(cfg.DropItems) do
        if name:match('^WEAPON_') then
            local ammo = nil
            for _, w in ipairs(x.loadout or {}) do
                if w.name == name then ammo = tonumber(w.ammo) or 0 end
            end
            if ammo then
                items[#items + 1] = { weapon = name, ammo = ammo }
                x.removeWeapon(name, ammo)
            end
        else
            local it = x.getInventoryItem(name)
            if it and it.count and it.count > 0 then
                items[#items + 1] = { item = name, count = it.count }
                x.removeInventoryItem(name, it.count)
            end
        end
    end
    if #items > 0 then
        dropSeq = dropSeq + 1
        Drops[dropSeq] = { coords = p, items = items, expires = os.time() + cfg.DropTimeout }
        broadcastDrops()
    end

    local gang = gangOf(x)
    local t0 = os.time()
    DeadOnIsland[src] = { coords = p, time = t0, gang = gang, name = GetPlayerName(src) }

    -- the gang and its allies get a marker on the dead player
    for _, pid in ipairs(GetPlayers()) do
        local id = tonumber(pid)
        if id ~= src then
            local hx = ESX.GetPlayerFromId(id)
            if hx and AreGangsAllied(gangOf(hx), gang) then
                TriggerClientEvent('island_death:marker', id, src, GetPlayerName(src), src, { x = p.x, y = p.y, z = p.z }, gang or 'Bedon gang')
            end
        end
    end

    TriggerClientEvent('island_death:youDied', src, cfg.ReviveWindow, cfg.BlockMedicAlert)

    -- released when nobody revived in time (no drop again, no marker left behind)
    SetTimeout(cfg.ReviveWindow * 1000, function()
        local d = DeadOnIsland[src]
        if d and d.time == t0 then
            DeadOnIsland[src] = nil
            TriggerClientEvent('island_death:released', src)
            TriggerClientEvent('island_death:clearMarker', -1, src)
        end
    end)
end)

-- ── revive: a gang/ally member doing /e cpr next to the dead player ───────
RegisterNetEvent('island_death:revive')
AddEventHandler('island_death:revive', function(victimId)
    local src = source
    local victim = tonumber(victimId)
    local cfg = deathCfg()
    if not cfg or not victim then return end

    local d = DeadOnIsland[victim]
    if not d then return notify(src, 'Ein shakhs mored nist.') end

    local rx = ESX.GetPlayerFromId(src)
    if not rx or not AreGangsAllied(gangOf(rx), d.gang) then
        return notify(src, 'Faghat aza-ye gang ya gang-e mottahed mitoonan ehya konan.')
    end

    local rp = GetEntityCoords(GetPlayerPed(src))
    if not insideIsland(rp) then return notify(src, 'Ehya faghat dakhel-e jazire mojaz ast.') end
    local dist = #(rp - GetEntityCoords(GetPlayerPed(victim)))
    if dist > cfg.ReviveRange + 1.0 then return notify(src, 'Kheyli door hasti.') end

    local it = rx.getInventoryItem(cfg.ReviveItem)
    if not it or (it.count or 0) < 1 then
        return notify(src, ('Baraye ehya %s lazeme.'):format(cfg.ReviveItem))
    end
    rx.removeInventoryItem(cfg.ReviveItem, 1)

    DeadOnIsland[victim] = nil
    TriggerClientEvent('island_death:clearMarker', -1, victim)
    TriggerClientEvent('island_death:revived', victim, cfg.ReviveHealth)
    notify(src, 'Ehya anjam shod.')
    notify(victim, 'Tavasot-e gang-e shoma ehya shodid.')
end)

-- ── pickup: anyone can take a pile from the ground ─────────────────────────
RegisterNetEvent('island_death:pickup')
AddEventHandler('island_death:pickup', function(dropId)
    local src = source
    local cfg = deathCfg()
    local drop = Drops[tonumber(dropId)]
    if not cfg or not drop then return end

    local dist = #(GetEntityCoords(GetPlayerPed(src)) - drop.coords)
    if dist > cfg.PickupRange + 1.0 then return end

    local x = ESX.GetPlayerFromId(src)
    if not x then return end
    for _, it in ipairs(drop.items) do
        if it.weapon then x.addWeapon(it.weapon, it.ammo or 0)
        else x.addInventoryItem(it.item, it.count) end
    end
    Drops[tonumber(dropId)] = nil
    broadcastDrops()
    notify(src, 'Item ha bardashte shod.')
end)

-- piles disappear after DropTimeout
CreateThread(function()
    while true do
        Wait(30000)
        local changed = false
        for id, d in pairs(Drops) do
            if os.time() >= d.expires then Drops[id] = nil; changed = true end
        end
        if changed then broadcastDrops() end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if DeadOnIsland[src] then
        DeadOnIsland[src] = nil
        TriggerClientEvent('island_death:clearMarker', -1, src)
    end
end)
