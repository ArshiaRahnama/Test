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

local function buildDropDisplay(itemType, name, count, label, serial)
    return {
        type = itemType,
        name = name,
        count = count,
        label = label or GetItemLabel(name) or name,
        serial = serial,
        image = Config.Pictures and Config.Pictures[name] or nil,
    }
end

RegisterNetEvent('esx_inventory:requestDrop')
AddEventHandler('esx_inventory:requestDrop', function(item, count)
    local source = source
    if not Config.Drop or not Config.Drop.enabled then return end

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
                removeWeapon(xPlayer, name, item.serial)
                removed = true
                display = buildDropDisplay(itemType, name, 1, label, item.serial)
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

    SetTimeout(Config.Drop.despawnTime or 300000, function()
        if Drops[dropId] then
            Drops[dropId] = nil
            TriggerClientEvent('esx_inventory:removeDrop', -1, dropId)
        end
    end)
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
        addWeapon(xPlayer, item.name, 255, item.serial)
        given = true
    elseif item.type == 'item_account' then
        addMoney(xPlayer, item.name, item.count)
        given = true
    end

    if given then
        Drops[dropId] = nil
        TriggerClientEvent('esx_inventory:removeDrop', -1, dropId)
        showNotification(xPlayer, (Locales[Config.Language]['pickup_item'] or 'You picked up %sx %s'):format(item.count, item.label), 'success')
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
