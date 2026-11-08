-- Unique_inventory | server/purge_keys.lua
-- Vehicle keys ('vehicle_keys' entries, one per plate) are temporary: after a
-- server restart every player's stale keys are wiped as they load in, so the
-- inventory never fills up with old keys. Keys are re-created by Unique_Garage
-- when the player locks / unlocks a vehicle again.
local ESXp = nil
TriggerEvent('esx:getSharedObject', function(obj) ESXp = obj end)

local purged = {}  -- identifier -> true once wiped during this server run

local function purge(src, force)
    if HudConfig and HudConfig.PurgeKeysOnLoad == false then return end
    if not ESXp then TriggerEvent('esx:getSharedObject', function(obj) ESXp = obj end) end
    local xPlayer = ESXp and ESXp.GetPlayerFromId(src)
    if not xPlayer or not xPlayer.inventory then return end
    -- only the first load after a server/resource start: keys earned later survive relogs
    if not force and purged[xPlayer.identifier] then return end
    purged[xPlayer.identifier] = true
    local removed = 0
    for i = #xPlayer.inventory, 1, -1 do
        local e = xPlayer.inventory[i]
        if e and e.name == 'vehicle_keys' then
            table.remove(xPlayer.inventory, i)
            removed = removed + 1
        end
    end
    if removed > 0 then
        if xPlayer.reconcileSlots then pcall(xPlayer.reconcileSlots) end
        TriggerClientEvent('esx_inventoryhud:RefreshCurrentInventory', src)
        print(('[Unique_inventory] removed %d stale vehicle key(s) from player %s'):format(removed, tostring(src)))
    end
end

AddEventHandler('esx:playerLoaded', function(source)
    SetTimeout(1500, function() purge(source) end)
    -- some scripts add items a few seconds after load; sweep once more
    SetTimeout(8000, function() purge(source, true) end)
end)

-- server console / txAdmin:  uq_purgekeys   -> wipes vehicle keys of everybody online right now
RegisterCommand('uq_purgekeys', function(src)
    if src ~= 0 then return end
    for _, id in ipairs(GetPlayers()) do purge(tonumber(id), true) end
    print('[Unique_inventory] purge done')
end, true)
