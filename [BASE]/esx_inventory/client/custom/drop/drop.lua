--[[
    Client half of the ground-drop system (see server/custom/drop/drop.lua
    for the authoritative, server-validated half).

    Each drop is rendered as a purely LOCAL, non-networked decorative prop
    (every connected client independently spawns its own copy at the same
    coords) plus a DrawMarker/DrawText3D prompt. This avoids all networked-
    entity ownership/migration headaches - the prop is just a visual, the
    server is the only thing that actually tracks who can pick what up.
]]

local Drop = {
    list = {},           -- [dropId] = { coords = vector3, item = {...}, entity = objHandle }
    nearestId = nil,
    nearestDist = 999999.0,
}

local DROP_MODEL = (Config.Drop and Config.Drop.prop) or 'prop_paper_bag01'
local PICKUP_DIST = (Config.Drop and Config.Drop.pickupDistance) or 1.6

local function spawnDropProp(coords)
    local hash = GetHashKey(DROP_MODEL)
    local attempts = 0
    while not HasModelLoaded(hash) and attempts < 200 do
        RequestModel(hash)
        Wait(0)
        attempts = attempts + 1
    end
    if not HasModelLoaded(hash) then return nil end

    local obj = CreateObjectNoOffset(hash, coords.x, coords.y, coords.z - 0.95, false, false, false)
    SetEntityCollision(obj, false, false)
    FreezeEntityPosition(obj, true)
    PlaceObjectOnGroundProperly(obj)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

RegisterNetEvent('esx_inventory:spawnDrop')
AddEventHandler('esx_inventory:spawnDrop', function(dropId, coords, item)
    if Drop.list[dropId] then return end -- already known locally

    local vcoords = type(coords) == 'vector3' and coords or vector3(coords.x, coords.y, coords.z)
    Drop.list[dropId] = {
        coords = vcoords,
        item = item,
        entity = nil,
    }

    CreateThread(function()
        local entry = Drop.list[dropId]
        if not entry then return end -- removed again before the model finished loading
        entry.entity = spawnDropProp(vcoords)
    end)
end)

RegisterNetEvent('esx_inventory:removeDrop')
AddEventHandler('esx_inventory:removeDrop', function(dropId)
    local entry = Drop.list[dropId]
    if not entry then return end

    if entry.entity and DoesEntityExist(entry.entity) then
        DeleteEntity(entry.entity)
    end
    Drop.list[dropId] = nil
    if Drop.nearestId == dropId then
        Drop.nearestId = nil
        Drop.nearestDist = 999999.0
    end
end)

-- Proximity loop: only runs its (cheap) per-drop math every frame while at
-- least one drop exists, and only draws the marker/prompt for the single
-- closest one so this never gets expensive even with many drops around.
CreateThread(function()
    while true do
        local sleep = 500
        local hasAny = false
        for _ in pairs(Drop.list) do hasAny = true break end

        if hasAny and not (Inv.isInInventory or Inv.isInTrunk or Inv.openInvPlayer or Inv.isInProperty) then
            sleep = 0
            local playerCoords = GetEntityCoords(PlayerPedId())
            local closestId, closestDist = nil, PICKUP_DIST + 0.001

            for id, entry in pairs(Drop.list) do
                local dist = #(playerCoords - entry.coords)
                if dist <= closestDist then
                    closestId, closestDist = id, dist
                end
            end

            Drop.nearestId, Drop.nearestDist = closestId, closestDist

            if closestId then
                local entry = Drop.list[closestId]
                local c = entry.coords
                DrawMarker(1, c.x, c.y, c.z - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.25, 255, 200, 80, 140, false, true, 2, false, nil, nil, false)
                DrawText3D(c.x, c.y, c.z - 0.55, (Locales[Config.Language]['drop_prompt'] or 'Pick up %s'):format(entry.item.label .. (entry.item.count and entry.item.count > 1 and (' x' .. entry.item.count) or '')))

                if IsControlJustReleased(0, 38) then -- INPUT_PICKUP / E
                    TriggerServerEvent('esx_inventory:pickupDrop', closestId)
                end
            end
        else
            Drop.nearestId = nil
        end

        Wait(sleep)
    end
end)

-- ▓▓▓ NUI hookups ▓▓▓

-- "Drop" top button (see ui.html) works exactly like the existing
-- delete/use/give buttons: item dragged onto it posts here.
RegisterNUICallback('dropItem', function(data, cb)
    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) then
        if cb then cb('ok') end
        return
    end

    if IsPedRagdoll(playerPed) then
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
        if cb then cb('ok') end
        return
    end

    local item = data.item
    if item == nil then if cb then cb('ok') end return end

    if item.type == 'item_standard' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) and tonumber(result) > 0 then
                TriggerServerEvent('esx_inventory:requestDrop', item, tonumber(result))
                Wait(150)
                loadPlayerInventory('item', nil, true, true)
            end
        end)
    elseif item.type == 'item_weapon' then
        if not Config.WeaponNoGive[item.name] then
            TriggerServerEvent('esx_inventory:requestDrop', item, 1)
            Wait(150)
            loadPlayerInventory('item', nil, true, true)
        end
    elseif item.type == 'item_account' then
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            if result ~= nil and tonumber(result) and tonumber(result) > 0 then
                TriggerServerEvent('esx_inventory:requestDrop', item, tonumber(result))
                Wait(150)
                loadPlayerInventory('item', nil, true, true)
            end
        end)
    else
        -- Clothes / ID card / phone: not ground-droppable (see server file).
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
    end

    if cb then cb('ok') end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for _, entry in pairs(Drop.list) do
        if entry.entity and DoesEntityExist(entry.entity) then
            DeleteEntity(entry.entity)
        end
    end
end)
