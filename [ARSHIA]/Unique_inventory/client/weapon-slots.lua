-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

maketSlot = {}

function addMaketSlot(slot, serial, name)
    for k, v in pairs(maketSlot) do
        if v.serial == serial then
            maketSlot[k] = nil
        end
    end
    maketSlot[slot] = { serial = serial, name = name }
    TriggerEvent('core:client:giveWeapon', serial)
    SetCurrentPedWeapon(PlayerPedId(), name, true)
    ESX.TriggerServerEvent('inventory:setSlot', 'maket', slot, serial, name)
end

function removeMaketSlot(serial)
    local name
    for k, v in pairs(maketSlot) do
        if v.serial == serial then
            name = v.name
            maketSlot[k] = nil
            break
        end
    end
    if name then
        TriggerEvent('core:client:removeWeapon', serial, name)
    end
    ESX.TriggerServerEvent('inventory:removeSlot', 'maket', serial)
end

exports('getMaketSlot', function()
    return maketSlot
end)

local function nameInOtherSlot(name, targetType, targetSlot)
    local targetKey = (targetType == 'maket') and (targetSlot + 100) or targetSlot
    local ws = exports['Unique_inventory']:getWeaponSlot()
    for k, v in pairs(ws or {}) do
        if type(v) == 'table' and v.name == name and tonumber(k) ~= targetKey then
            return true
        end
    end
    return false
end

function ApplyMaketSlots(data)
    maketSlot = {}
    if type(data) == 'table' then
        for k, v in pairs(data) do
            maketSlot[tonumber(k)] = v
        end
    end
end

RegisterNUICallback('weaponSlotDrop', function(data, cb)
    local slot = tonumber(data.slot)
    local name = data.name
    local serial = data.serial

    if not name or not serial or not slot then
        return cb({ ok = false })
    end

    if nameInOtherSlot(name, data.slotType, slot) then
        return cb({ ok = false, reason = 'duplicate' })
    end

    if data.slotType == 'maket' then
        if not IsMaketWeapon(name) then
            return cb({ ok = false, reason = 'not_maket' })
        end
        if ESX.GetPlayerData().World ~= 0 or playWeaponAnim(name) then
            addMaketSlot(slot, serial, name)
        end
        Wait(200)
        exports['Unique_inventory']:reopenInventoryUI()
        return cb({ ok = true })
    end

    -- makets (minigun, sniper, katana, ...) are back-carried weapons: they only fit the maket slots
    if IsMaketWeapon(name) then
        ESX.ShowNotification('ماکت فقط داخل اسلات «ماکت» قرار می‌گیرد')
        Wait(100)
        exports['Unique_inventory']:reopenInventoryUI()
        return cb({ ok = false, reason = 'maket_only' })
    end

    exports['Unique_inventory']:moveInside({
        name = name,
        count = 1,
        metadata = { serial = serial },
        droppedTo = slot,
        droppedFromData = { name = name, metadata = { serial = serial } },
        droppedToData = data.occupant,
        inventoryType = 'main',
    })

    Wait(200)
    exports['Unique_inventory']:loadPlayerInventory()
    cb({ ok = true })
end)

RegisterNUICallback('weaponSlotRemove', function(data, cb)
    local serial = data.serial
    if not serial then
        return cb({ ok = false })
    end

    local name = data.name
    if not name then
        if data.slotType == 'maket' then
            for _, v in pairs(maketSlot) do
                if v.serial == serial then name = v.name break end
            end
        else
            local ws = exports['Unique_inventory']:getWeaponSlot()
            for _, v in pairs(ws or {}) do
                if type(v) == 'table' and v.serial == serial then name = v.name break end
            end
        end
    end

    if ESX.GetPlayerData().World ~= 0 or playWeaponAnim(name) then
        if data.slotType == 'maket' then
            removeMaketSlot(serial)
        else
            removeWeaponSlot(serial)
        end
    end

    Wait(200)
    exports['Unique_inventory']:reopenInventoryUI()
    cb({ ok = true })
end)
