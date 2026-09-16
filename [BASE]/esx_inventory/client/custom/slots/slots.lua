--[[
    ================================================================
    GRID SLOTS — features #1, #2, #3, #5, #7, #8, #23 (client half)
    ================================================================

    Thin on purpose. Every callback here does one thing: forward an
    intent (move/split/drop/annotate) to the server and let the server's
    answer redraw the UI. The client never mutates its own view of the
    grid optimistically — an optimistic grid is how you end up with a UI
    that disagrees with the server and players who think they were
    robbed.

    The one exception is the drag animation itself (#23), which is
    purely visual and happens in the NUI.
]]

if Config.Framework ~= "esx" then
    return
end

InvGrid = { data = nil }

function RefreshGrid()
    TriggerServerCallback('esx_inventory:getGrid', function(grid)
        if not grid then return end
        InvGrid.data = grid
        SendNUIMessage({ action = 'grid:set', grid = grid })
    end)
end

-- Server-pushed refresh: fires on ANY inventory change, including ones
-- that originated elsewhere (a shop, another player giving you
-- something, an admin command). This is what keeps an open grid live.
RegisterNetEvent('esx_inventory:gridUpdated')
AddEventHandler('esx_inventory:gridUpdated', function(grid)
    if not (Inv.isInInventory or Inv.isInTrunk or Inv.openInvPlayer or Inv.isInProperty or Inv.isInGlovebox) then
        return
    end
    InvGrid.data = grid
    SendNUIMessage({ action = 'grid:set', grid = grid })
end)

--═════════════════════════════════════════════════════════════════════
-- #1 — move
--═════════════════════════════════════════════════════════════════════
RegisterNUICallback('grid:move', function(data, cb)
    if data and data.from and data.to then
        TriggerServerEvent('esx_inventory:moveSlot', data.from, data.to)
    end
    if cb then cb('ok') end
end)

--═════════════════════════════════════════════════════════════════════
-- #2 — split (shift-drag)
--═════════════════════════════════════════════════════════════════════
RegisterNUICallback('grid:split', function(data, cb)
    if cb then cb('ok') end
    if not (data and data.from and data.to) then return end

    -- If the UI already asked for an amount (its own inline stepper),
    -- use it. Otherwise fall back to the resource's keyboard prompt.
    if data.count then
        TriggerServerEvent('esx_inventory:splitSlot', data.from, data.to, tonumber(data.count))
        return
    end

    KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
        local n = tonumber(result)
        if n and n > 0 then
            TriggerServerEvent('esx_inventory:splitSlot', data.from, data.to, n)
        end
    end)
end)

--═════════════════════════════════════════════════════════════════════
-- #3 — dragged out of the window onto the world
--═════════════════════════════════════════════════════════════════════
RegisterNUICallback('grid:dropToGround', function(data, cb)
    if cb then cb('ok') end
    if not (data and data.slot) then return end

    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) or IsPedRagdoll(playerPed) then
        NotificationInInventory(Locales[Config.Language]['no_possible'], 'error')
        return
    end

    local function fire(n)
        -- Throw animation, then the drop. Played before the server call
        -- so the prop appears roughly when the hand finishes moving,
        -- rather than a beat before it.
        function_inv:RequestAnimDict('random@domestic', function()
            TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8.0, 900, 48, 0.0, false, false, false)
        end)
        TriggerServerEvent('esx_inventory:dropSlotToGround', data.slot, n)
    end

    if data.count then
        fire(tonumber(data.count))
    elseif data.all then
        fire(nil)
    else
        KeyboardUtils.use(Locales[Config.Language]['quantite'], function(result)
            local n = tonumber(result)
            if n and n > 0 then fire(n) end
        end)
    end
end)

--═════════════════════════════════════════════════════════════════════
-- #5 — per-item note
--═════════════════════════════════════════════════════════════════════
RegisterNUICallback('grid:editNote', function(data, cb)
    if cb then cb('ok') end
    if not (data and data.slotKey) then return end

    KeyboardUtils.use(Locales[Config.Language]['title_note'] or 'Description:', function(result)
        -- An empty submit clears the note rather than storing "" -
        -- handled server-side, this just passes it through.
        TriggerServerEvent('esx_inventory:setItemNote', data.slotKey, result)
    end)
end)

--═════════════════════════════════════════════════════════════════════
-- #7 / #8 — custody history and stolen report
--═════════════════════════════════════════════════════════════════════
RegisterNUICallback('grid:weaponHistory', function(data, cb)
    if cb then cb('ok') end
    if not (data and data.serial) then return end

    TriggerServerCallback('esx_inventory:getWeaponHistory', function(result)
        if not result then return end
        SendNUIMessage({ action = 'open:History', history = result })
    end, data.serial)
end)

RegisterNUICallback('grid:reportStolen', function(data, cb)
    if cb then cb('ok') end
    if not (data and data.serial) then return end

    KeyboardUtils.use(Locales[Config.Language]['title_stolen'] or 'Circumstances (optional):', function(note)
        TriggerServerEvent('esx_inventory:reportWeaponStolen', data.serial, data.name, note)
    end)
end)

--═════════════════════════════════════════════════════════════════════
-- #15 — backpack band opens/closes with the pack
--═════════════════════════════════════════════════════════════════════
RegisterNetEvent('esx_inventory:backpackChanged')
AddEventHandler('esx_inventory:backpackChanged', function()
    if Inv.isInInventory then RefreshGrid() end
end)
