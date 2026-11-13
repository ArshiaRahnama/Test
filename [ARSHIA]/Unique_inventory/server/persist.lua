-- ============================================================================
-- Unique_inventory | server/persist.lua
-- Makes sure what players carry survives a server restart.
--
-- essentialmode saves inventory + loadout only when a player disconnects and every
-- 8 minutes, and the disconnect write is asynchronous - when the server process is
-- stopped (txAdmin restart) it often never finishes. Anything picked up, bought, given
-- by an admin or moved in the last minutes was lost.
--
--   * a short autosave of every online player (default every 2 minutes)
--   * an immediate save of everybody when txAdmin announces a shutdown / restart
--   * a save when essentialmode itself is stopped or restarted
-- Convar: set unique_inv_autosave_min 2     (0 = turn the periodic autosave off)
-- ============================================================================

local function saveAll(reason)
    if not ESX or not ESX.SavePlayers then return end
    local ok, err = pcall(function() ESX.SavePlayers() end)
    if not ok then
        print(('^1[Unique_inventory]^0 save (%s) failed: %s'):format(reason, tostring(err)))
    end
end

CreateThread(function()
    local minutes = GetConvarInt('unique_inv_autosave_min', 2)
    if minutes <= 0 then return end
    while true do
        Wait(minutes * 60 * 1000)
        saveAll('autosave')
    end
end)

-- txAdmin: manual restart / stop and scheduled restarts
AddEventHandler('txAdmin:events:serverShuttingDown', function() saveAll('txAdmin shutdown') end)
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
    if type(data) == 'table' and tonumber(data.secondsRemaining) and data.secondsRemaining <= 120 then
        saveAll('scheduled restart')
    end
end)

-- `restart essentialmode` / `stop essentialmode` would drop everybody's unsaved changes
AddEventHandler('onResourceStop', function(res)
    if res == 'essentialmode' then saveAll('essentialmode stopping') end
end)


-- --------------------------------------------------------------------------
-- diagnostics: what the server actually holds for a player
--   * a line in the server console every time somebody logs in
--   * console/RCON command:  uniqueinv_check <server id>
-- --------------------------------------------------------------------------
local function describe(xp)
    local stacks, units, lines = 0, 0, {}
    for _, row in ipairs(xp.inventory or {}) do
        if (row.count or 0) > 0 then
            stacks = stacks + 1
            units = units + row.count
            if #lines < 15 then lines[#lines + 1] = ('%s x%d'):format(tostring(row.name), row.count) end
        end
    end
    local weapons = {}
    for _, w in ipairs(xp.loadout or {}) do
        weapons[#weapons + 1] = ('%s%s'):format(tostring(w.name), w.serial and '' or ' (NO SERIAL)')
    end
    return stacks, units, lines, weapons
end

AddEventHandler('esx:playerLoaded', function(src)
    SetTimeout(2500, function()
        local xp = ESX and ESX.GetPlayerFromId(src)
        if not xp then return end
        local stacks, units, _, weapons = describe(xp)
        print(('^3[Unique_inventory]^0 login: id %s (%s) -> %d item stacks (%d units), %d weapons, max weight %s'):format(
            src, tostring(xp.identifier), stacks, units, #weapons, tostring(xp.getMaxWeight())))
    end)
end)

RegisterCommand('uniqueinv_check', function(source, args)
    if source ~= 0 then return end   -- console / RCON only
    local id = tonumber(args[1])
    local xp = id and ESX and ESX.GetPlayerFromId(id)
    if not xp then print('usage: uniqueinv_check <server id of an online player>') return end
    local stacks, units, lines, weapons = describe(xp)
    print(('^3[Unique_inventory]^0 id %d (%s): %d stacks / %d units, %d weapons, used %.2f / max %s kg'):format(
        id, tostring(xp.identifier), stacks, units, #weapons, xp.getUsedWeight(), tostring(xp.getMaxWeight())))
    print('  items:   ' .. (#lines > 0 and table.concat(lines, ', ') or '(none)'))
    print('  weapons: ' .. (#weapons > 0 and table.concat(weapons, ', ') or '(none)'))
end, true)
