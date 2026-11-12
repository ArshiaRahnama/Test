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
