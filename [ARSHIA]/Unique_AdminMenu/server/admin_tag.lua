-- Broadcasts the on-duty admin list so everyone's client can draw a floating
-- name tag over their heads (client/admin_tag.lua). Reuses IsOnDutyAdmin
-- from server/main.lua. Also tracks duty-session start times for the Staff
-- Dashboard (server/expansion.lua's GetDashboard callback reads this global).

DutySessionStart = {} -- source -> os.time() when they went on duty (global, read by GetDashboard)

local function BroadcastAdminTags()
    local tags = {}
    local players = ESX.GetPlayers()
    for i = 1, #players do
        local src = players[i]
        if IsOnDutyAdmin(src) then
            tags[#tags + 1] = { source = src }
            if not DutySessionStart[src] then
                DutySessionStart[src] = os.time()
            end
        else
            DutySessionStart[src] = nil
        end
    end
    TriggerClientEvent('Unique_AdminMenu:SyncAdminTags', -1, tags)
end

RegisterServerEvent('Unique_AdminMenu:UpdateAdminTag')
AddEventHandler('Unique_AdminMenu:UpdateAdminTag', function()
    -- Any duty-state change just re-derives the full list server-side
    -- (IsOnDutyAdmin is the source of truth), so a spoofed client call
    -- can't add someone who isn't actually on duty.
    BroadcastAdminTags()
end)

AddEventHandler('playerDropped', function()
    DutySessionStart[source] = nil
    Citizen.SetTimeout(0, BroadcastAdminTags)
end)

-- Also recompute periodically in case a duty toggle ever happens without
-- going through Unique_AdminMenu:UpdateAdminTag (e.g. esx_aduty console command).
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        BroadcastAdminTags()
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId)
    Citizen.SetTimeout(500, function()
        TriggerClientEvent('Unique_AdminMenu:SyncAdminTags', playerId, (function()
            local tags = {}
            local players = ESX.GetPlayers()
            for i = 1, #players do
                if IsOnDutyAdmin(players[i]) then
                    tags[#tags + 1] = { source = players[i] }
                end
            end
            return tags
        end)())
    end)
end)
