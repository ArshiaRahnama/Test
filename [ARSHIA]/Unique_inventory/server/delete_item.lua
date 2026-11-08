-- Unique_inventory | server/delete_item.lua
-- Permanently destroys an item the player owns (Delete button in the UI).
ESX = ESX or nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastDelete = {}

RegisterServerEvent('Unique_inventory:deleteItem')
AddEventHandler('Unique_inventory:deleteItem', function(itemType, itemName, itemCount, itemLabel)
    local src = source
    if HudConfig and HudConfig.AllowDelete == false then return end
    if type(itemName) ~= 'string' or itemName == '' then return end

    local now = GetGameTimer()
    if lastDelete[src] and (now - lastDelete[src]) < 400 then return end
    lastDelete[src] = now

    if not ESX then TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) end
    local xPlayer = ESX and ESX.GetPlayerFromId(src)
    if not xPlayer then
        print(('[Unique_inventory] delete: no xPlayer for %s'):format(tostring(src)))
        return
    end

    local count = math.floor(tonumber(itemCount) or 1)
    if count < 1 then count = 1 end

    local function notify(msg) TriggerClientEvent('esx:showNotification', src, msg) end
    local function fail(why)
        print(('[Unique_inventory] delete failed for %s (%s %s): %s'):format(tostring(src), tostring(itemType), tostring(itemName), tostring(why)))
        notify('Could not delete this item')
    end

    if itemType == 'item_keyhouse' then return notify('House keys cannot be deleted') end
    local up = string.upper(itemName)
    local ok, err = pcall(function()
        if itemType == 'item_weapon' or up:find('^WEAPON_') then
            -- never call getWeapon (throws "invalid vector field: ammo" here)
            local okH, has = pcall(xPlayer.hasWeapon, up)
            if okH and has == false then return fail('weapon not owned') end
            xPlayer.removeWeapon(up)
            notify(('Deleted %s'):format(GetCachedWeaponLabel and GetCachedWeaponLabel(up) or up))
        elseif itemType == 'item_money' or itemName == 'cash' or itemName == 'money' then
            local have = xPlayer.getMoney()
            if have < 1 then return fail('no cash') end
            local n = math.min(count, have)
            xPlayer.removeMoney(n)
            notify(('Deleted $%d cash'):format(n))
        elseif itemType == 'item_account' or itemType == 'black_money' or itemName == 'black_money' then
            local acc = xPlayer.getAccount('black_money')
            if not acc or acc.money < 1 then return fail('no dirty money') end
            local n = math.min(count, acc.money)
            xPlayer.removeAccountMoney('black_money', n)
            notify(('Deleted $%d dirty money'):format(n))
        else
            local name = string.lower(itemName)
            -- several entries can share one name (vehicle_keys: one per plate) so pick
            -- the exact entry by label/plate, and remove it by index.
            local idx, entry
            local wantLabel = tostring(itemLabel or '')
            for i, e in ipairs(xPlayer.inventory or {}) do
                if e.name == name and (tonumber(e.count) or 0) > 0 then
                    local plate = e.info and e.info.plate
                    if (wantLabel ~= '' and (e.label == wantLabel or plate == wantLabel or (plate and wantLabel:find(plate, 1, true)))) then
                        idx, entry = i, e break
                    end
                    if not entry then idx, entry = i, e end
                end
            end
            if not entry then return fail('item not owned') end
            local n = math.min(count, entry.count)
            xPlayer.removeInventoryItem(name, n, idx)
            notify(('Deleted %dx %s'):format(n, entry.label or name))
        end
    end)
    if not ok then fail(err) end
    -- tell the client to refresh its list
    TriggerClientEvent('esx_inventoryhud:RefreshCurrentInventory', src)
end)

AddEventHandler('playerDropped', function() lastDelete[source] = nil end)
