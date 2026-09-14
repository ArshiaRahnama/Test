-- ================================================================= --
-- CAPTURE TAB — surfaces Unique_Capture's own dashboard (normally
-- only reachable via the standalone /capture command + its separate
-- terminal-style menu) inside this HUD instead.
--
-- Reuses Unique_Capture's OWN existing callback
-- (arshiahub.ir-Capture:GetDashboard) directly — server-to-server,
-- same technique as server/duty.lua and server/record.lua — instead
-- of re-querying its half-dozen tables (capture_player_stats,
-- capture_player_zone_stats, capture_gang_stats, capture_meta,
-- capture_scarce_medals, capture_hall_of_fame) ourselves. That
-- callback already assembles exactly what a summary tab needs in one
-- call: rank/score, kill/death/zone stats, top killers, gang
-- standings, season countdown, and medal/hall-of-fame status.
-- ================================================================= --

local function captureAvailable()
    return ESX.ServerCallbacks['arshiahub.ir-Capture:GetDashboard'] ~= nil
end

ESX.RegisterServerCallback('HUD_Menu:GetCapture', function(source, cb)
    if not captureAvailable() then
        cb(nil)
        return
    end
    ESX.TriggerServerCallback('arshiahub.ir-Capture:GetDashboard', nil, source, function(dashboard)
        cb(dashboard)
    end)
end)
