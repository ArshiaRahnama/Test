--[[ Unique RP - admin extras (server side) | server/unique_admin_extras.lua
    1) Spectate follows the target's WORLD (routing bucket): an on-duty admin who spectates someone
       in another world is moved into that world and put back when spectating ends.
    2) "Move nearby players to a world" (Sunset's /cwr) - the server picks the players itself,
       the client only sends range + world.
]]

local origWorld = {}      -- admin source -> world they were in before following a spectated player

-- ------------------------------------------------------- spectate: follow world ---
RegisterNetEvent('Unique_Admin:followWorld')
AddEventHandler('Unique_Admin:followWorld', function(target)
    local src = source
    target = tonumber(target)
    if not target or not GetPlayerName(target) then return end
    if not IsOnDutyAdminFor(src) then return end

    local targetWorld, myWorld = GetPlayerRoutingBucket(target), GetPlayerRoutingBucket(src)
    if targetWorld == myWorld then return end
    if origWorld[src] == nil then origWorld[src] = myWorld end          -- remember only the first one
    SetPlayerRoutingBucket(src, targetWorld)
    LogAdminAction(src, 'spectate-world', ('target %s | world %s -> %s'):format(target, myWorld, targetWorld))
end)

RegisterNetEvent('Unique_Admin:restoreWorld')
AddEventHandler('Unique_Admin:restoreWorld', function()
    local src = source
    if origWorld[src] ~= nil then                                      -- only ever restores what the server saved
        SetPlayerRoutingBucket(src, origWorld[src])
        origWorld[src] = nil
    end
end)

AddEventHandler('playerDropped', function() origWorld[source] = nil end)

-- ------------------------------------------------ move nearby players to a world ---
local MAX_RANGE, MAX_WORLD, MIN_LEVEL = 50.0, 9999, 8

RegisterNetEvent('Unique_Admin:worldRange')
AddEventHandler('Unique_Admin:worldRange', function(range, world)
    local src = source
    range, world = tonumber(range), math.floor(tonumber(world) or -1)
    if not IsOnDutyAdminFor(src) or not AdminMinLevel(src, MIN_LEVEL) then
        return TriggerClientEvent('esx:showNotification', src, "~r~You don't have permission for that.")
    end
    if not range or range <= 0 or range > MAX_RANGE or world < 0 or world > MAX_WORLD then
        return TriggerClientEvent('esx:showNotification', src,
            ('~r~Range 1-%d and world 0-%d.'):format(MAX_RANGE, MAX_WORLD))
    end

    local origin = GetEntityCoords(GetPlayerPed(src))
    local moved = 0
    for _, id in ipairs(GetPlayers()) do
        local pid = tonumber(id)
        local ped = GetPlayerPed(pid)
        if ped and ped ~= 0 and #(GetEntityCoords(ped) - origin) <= range then
            SetPlayerRoutingBucket(pid, world)
            local veh = GetVehiclePedIsIn(ped, false)            -- keep the car with its driver/passengers
            if veh ~= 0 then SetEntityRoutingBucket(veh, world) end
            if pid == src then origWorld[src] = nil end          -- an explicit move overrides "restore after spectate"
            moved = moved + 1
        end
    end
    TriggerClientEvent('esx:showNotification', src, ('~g~%d player(s) moved to world %d'):format(moved, world))
    LogAdminAction(src, 'world-range', ('range %s | world %s | moved %d'):format(range, world, moved))
end)
