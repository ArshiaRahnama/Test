--[[
    Drop-on-ground system.

    Flow:
      1. NUI "Drop" (button or right-click context menu) -> client fires
         'esx_inventory:requestDrop' with the item the player dragged/picked.
      2. This file validates the player actually owns that amount, removes
         it from their inventory using the SAME framework-agnostic helpers
         (RemoveItem/removeWeapon/removeMoney/etc, from
         server/custom/framework/esx.lua or qb.lua) already used by the
         existing delete/give flows, then stores a "drop" record and tells
         every client to render it.
      3. 'esx_inventory:pickupDrop' is re-validated server-side: we re-check
         the requesting player's actual ped distance to the stored drop
         coords (never trust a client-reported distance), so this can't be
         used to teleport-pickup items from across the map.
      4. Drops auto-expire after Config.Drop.despawnTime.

    All state here (Drops table) lives only in this resource's memory - a
    server restart clears the ground, same as most inventory drop systems.
]]

Drops = {}
local nextDropId = 1

local function countActiveDrops()
    local n = 0
    for _ in pairs(Drops) do n = n + 1 end
    return n
end

local function getPedCoords(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

local function vdist(a, b)
    local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function buildDropDisplay(itemType, name, count, label, serial, ammo, components)
    return {
        type = itemType,
        name = name,
        count = count,
        label = label or GetItemLabel(name) or name,
        serial = serial,
        -- BUGFIX: a dropped weapon used to lose its magazine and every
        -- attachment. Pickup then handed back a hardcoded 255 rounds,
        -- which also made "drop it and pick it up again" a free ammo
        -- refill. Both are carried through the drop now.
        ammo = ammo,
        components = components,
        image = Config.Pictures and Config.Pictures[name] or nil,
    }
end

--- Place an already-validated stack on the ground. Split out of the
--- net-event handler below so the grid's drag-to-ground path (#3, see
--- server/custom/slots/slots.lua) can reuse the identical spawn/cap/
--- despawn/broadcast logic instead of reimplementing it — the two used
--- to be one function only because there was only one caller.
--- `display` must already have had the item REMOVED from the player.
local notifyGroundWatchers   -- defined below, called from placeDrop

local function placeDrop(source, coords, display)
    local dropId = 'drop_' .. nextDropId
    nextDropId = nextDropId + 1

    Drops[dropId] = {
        id = dropId,
        coords = coords,
        item = display,
        owner = source,
        createdAt = os.time(),
    }

    TriggerClientEvent('esx_inventory:spawnDrop', -1, dropId, coords, display)
    notifyGroundWatchers(coords)

    SetTimeout(Config.Drop.despawnTime or 300000, function()
        if Drops[dropId] then
            Drops[dropId] = nil
            TriggerClientEvent('esx_inventory:removeDrop', -1, dropId)
        end
    end)

    return dropId
end

-- Internal (server->server) entry point used by the grid. Not a net
-- event: TriggerEvent from another server script only, so a client can
-- never reach it directly.
AddEventHandler('esx_inventory:internalDrop', function(source, item, count)
    local xPlayer = GetPlayerFromId(source)
    if not xPlayer then return end

    if countActiveDrops() >= (Config.Drop.maxStacksOnGround or 200) then
        showNotification(xPlayer, Locales[Config.Language]['drop_full_ground'] or 'Too many items on the ground right now, try again shortly.', 'error')
        return
    end

    local coords = getPedCoords(source)
    if not coords then return end

    local x_Item = GetItem(xPlayer, item.name)
    if not x_Item or GetItemAmount(x_Item) < count then return end

    RemoveItem(xPlayer, item.name, count)
    placeDrop(source, coords, buildDropDisplay('item_standard', item.name, count, item.label))
end)

RegisterNetEvent('esx_inventory:requestDrop')
AddEventHandler('esx_inventory:requestDrop', function(item, count)
    local source = source
    if not Config.Drop or not Config.Drop.enabled then return end
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'drop') then return end

    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil or item == nil or type(item) ~= 'table' then return end

    if countActiveDrops() >= (Config.Drop.maxStacksOnGround or 200) then
        showNotification(xPlayer, Locales[Config.Language]['drop_full_ground'] or 'Too many items on the ground right now, try again shortly.', 'error')
        return
    end

    local coords = getPedCoords(source)
    if not coords then return end

    local itemType = item.type
    local name = item.name
    local label = item.label
    local removed = false
    local display

    if itemType == 'item_standard' then
        count = tonumber(count) or 1
        local x_Item = GetItem(xPlayer, name)
        if count > 0 and GetItemAmount(x_Item) >= count then
            RemoveItem(xPlayer, name, count)
            removed = true
            display = buildDropDisplay(itemType, name, count, label)
        end
    elseif itemType == 'item_weapon' then
        if not Config.WeaponNoGive or not Config.WeaponNoGive[name] then
            if getWeapon(xPlayer, name, item.serial) then
                -- read ammo/components BEFORE removing it, and read them
                -- from the server's own loadout - never from `item`,
                -- which is client-supplied and would be a trivial way to
                -- mint ammo or attachments out of nothing.
                local _, weaponData = infoWeapon(xPlayer, name, item.serial)
                local ammo, comps = 0, {}
                if weaponData then
                    ammo = tonumber(weaponData.ammo) or 0
                    for _, c in ipairs(weaponData.components or {}) do comps[#comps + 1] = c end
                end

                removeWeapon(xPlayer, name, item.serial)
                removed = true
                display = buildDropDisplay(itemType, name, 1, label, item.serial, ammo, comps)
            end
        end
    elseif itemType == 'item_account' then
        count = tonumber(count) or 0
        if count > 0 and getAccount(xPlayer, name) >= count then
            removeMoney(xPlayer, name, count)
            removed = true
            display = buildDropDisplay(itemType, name, count, Config.AccountName and Config.AccountName[name] or label)
        end
    end
    -- Clothes/idcard/phone are intentionally not droppable on the ground -
    -- they're per-character records tied to a DB row (same reason
    -- Config.ItemNoGive/WeaponNoGive block certain items from `give`).

    if not removed or not display then
        return
    end

    placeDrop(source, coords, display)
end)

RegisterNetEvent('esx_inventory:pickupDrop')
AddEventHandler('esx_inventory:pickupDrop', function(dropId)
    local source = source
    local drop = Drops[dropId]
    if not drop then
        -- Already picked up / despawned on the server but the client's
        -- local visual hadn't caught up yet - just tell it to clean up.
        TriggerClientEvent('esx_inventory:removeDrop', source, dropId)
        return
    end

    local coords = getPedCoords(source)
    if not coords then return end

    -- Real server-side distance check (client distance is only used to
    -- decide whether to even show the "[E] Pick up" prompt/UI - it is
    -- never trusted for the actual pickup).
    local maxDist = (Config.Drop.pickupDistance or 1.6) + 1.0 -- small server-side margin for latency/interp
    if vdist(coords, drop.coords) > maxDist then
        return
    end

    local xPlayer = GetPlayerFromId(source)
    if xPlayer == nil then return end

    local item = drop.item
    local given = false

    if item.type == 'item_standard' then
        if getWeight(xPlayer, item.name, item.count) then
            AddItem(xPlayer, item.name, item.count)
            given = true
        else
            showNotification(xPlayer, Locales[Config.Language]['give_error_weight'] or 'Not enough space.', 'error')
            return
        end
    elseif item.type == 'item_weapon' then
        addWeapon(xPlayer, item.name, tonumber(item.ammo) or 0, item.serial)
        for _, c in ipairs(item.components or {}) do
            addWeaponComponent(xPlayer, item.name, c)
        end
        given = true
    elseif item.type == 'item_account' then
        addMoney(xPlayer, item.name, item.count)
        given = true
    end

    if given then
        Drops[dropId] = nil
        TriggerClientEvent('esx_inventory:removeDrop', -1, dropId)
        notifyGroundWatchers(drop.coords)
        showNotification(xPlayer, (Locales[Config.Language]['pickup_item'] or 'You picked up %sx %s'):format(item.count, item.label), 'success')
    end
end)

--═════════════════════════════════════════════════════════════════════
-- GROUND PANEL (round 5) — what is lying within reach of this player
--
-- The client asks; the server measures. Distance is computed from the
-- server's own ped coords and its own stored drop coords, so this can't
-- be used to enumerate the map's loot from a distance.
--═════════════════════════════════════════════════════════════════════

RegisterServerCallback('esx_inventory:getNearbyDrops', function(source, cb)
    local coords = getPedCoords(source)
    if not coords then cb({}) return end

    local reach = (Config.Drop and Config.Drop.panelDistance) or 3.0
    local list = {}

    for id, drop in pairs(Drops) do
        if vdist(coords, drop.coords) <= reach then
            local it = drop.item
            list[#list + 1] = {
                dropId = id,
                type   = it.type,
                name   = it.name,
                label  = it.label,
                count  = it.count,
                image  = it.image,
                serial = it.serial,
                weight = (ESX and ESX.getItemWeight and ESX.getItemWeight(it.name)) or 0,
                rank   = Config.GetItemRank and Config.GetItemRank(it.name) or 'common',
            }
        end
    end

    cb(list)
end)

--- Anyone with the inventory open near a drop that just changed needs to
--- see it change. Cheap: only players inside the panel radius are told,
--- and the client ignores the event unless its panel is actually open.
function notifyGroundWatchers(coords)
    local reach = ((Config.Drop and Config.Drop.panelDistance) or 3.0) + 2.0
    for _, pid in ipairs(GetPlayers()) do
        local pc = getPedCoords(tonumber(pid))
        if pc and vdist(pc, coords) <= reach then
            TriggerClientEvent('esx_inventory:groundChanged', tonumber(pid))
        end
    end
end

--- BUGFIX: drops were only broadcast at the moment they were created, so
--- anyone who connected (or reconnected, or restarted their game) after
--- that point saw NOTHING on the ground - the item was still there
--- server-side and still pickable, but invisible, which reads exactly
--- like it was lost. Clients ask for the current ground state when they
--- finish loading.
RegisterNetEvent('esx_inventory:requestDrops')
AddEventHandler('esx_inventory:requestDrops', function()
    local source = source
    if _G.InvGuard and not _G.InvGuard.rateLimit(source, 'default') then return end
    for id, drop in pairs(Drops) do
        TriggerClientEvent('esx_inventory:spawnDrop', source, id, drop.coords, drop.item)
    end
end)

-- Cleanup so a resource restart doesn't leave phantom drops referenced by
-- clients that are still connected across a `restart esx_inventory`.
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for id in pairs(Drops) do
            TriggerClientEvent('esx_inventory:removeDrop', -1, id)
        end
        Drops = {}
    end
end)
