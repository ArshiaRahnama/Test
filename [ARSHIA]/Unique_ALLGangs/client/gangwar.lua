-------------------------------------------------------------------
-- 45) Gang shootout detection - client half
-- -------------------------------------------------------------------
-- Pure detection: polls IsPedShooting on the LOCAL player (only while
-- actually in a gang - PlayerData.gang is the same global every other
-- file in this resource already relies on, see client/boss.lua) and
-- pings the server with current coords whenever a shot is fired.
--
-- All the actual "is this a real gang shootout" logic (clustering
-- multiple distinct shooters, time window, cooldown, firing the
-- dispatch) lives server-side (server/Gangs.lua,
-- FMGangs:ReportGangShotFired) since it needs to see every gang
-- member's pings together, not just this one client's - a single
-- client has no way to know how many OTHER gang members are also
-- shooting nearby right now.
-------------------------------------------------------------------

CreateThread(function()
    while true do
        Wait((Config.GangWar and Config.GangWar.CheckIntervalMs) or 1000)

        if Config.GangWar and Config.GangWar.Enabled
        and PlayerData and PlayerData.gang and PlayerData.gang.name
        and PlayerData.gang.name ~= 'nogang' then
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local coords = GetEntityCoords(ped)
                TriggerServerEvent('FMGangs:ReportGangShotFired', coords.x, coords.y, coords.z)
            end
        end
    end
end)
