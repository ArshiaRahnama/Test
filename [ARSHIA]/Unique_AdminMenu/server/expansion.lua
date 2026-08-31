-- ============================================================================
-- EXPANSION PACK - extra Player / Vehicle / World / Comms / Dashboard tools
-- Everything here follows the same pattern as admin_tools.lua: check
-- IsOnDutyAdmin(source) first, validate input, do the thing, LogAdminAction.
-- ============================================================================

-- ---------------------------------------------------------------- PLAYER ---

RegisterServerEvent('Unique_AdminMenu:SetHealth')
AddEventHandler('Unique_AdminMenu:SetHealth', function(targetId, pct)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    pct = tonumber(pct)
    if not targetId or not ESX.GetPlayerFromId(targetId) or not pct then return end
    pct = math.max(0, math.min(100, pct))

    TriggerClientEvent('Unique_AdminMenu:ApplySetHealth', targetId, pct)
    LogAdminAction(source, "set-health", ("target: %s | %s%%"):format(GetPlayerName(targetId), pct), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:SetArmor')
AddEventHandler('Unique_AdminMenu:SetArmor', function(targetId, pct)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    pct = tonumber(pct)
    if not targetId or not ESX.GetPlayerFromId(targetId) or not pct then return end
    pct = math.max(0, math.min(100, pct))

    TriggerClientEvent('Unique_AdminMenu:ApplySetArmor', targetId, pct)
    LogAdminAction(source, "set-armor", ("target: %s | %s%%"):format(GetPlayerName(targetId), pct), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

-- SetPlayerInvincible is a server-authoritative native that can target ANY
-- player id, not just the caller - so target-godmode needs no client toggle
-- at all, unlike the self-godmode in main.lua's RequestToggle.
local TargetGodmode = {}
RegisterServerEvent('Unique_AdminMenu:ToggleTargetGodmode')
AddEventHandler('Unique_AdminMenu:ToggleTargetGodmode', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TargetGodmode[targetId] = not TargetGodmode[targetId]
    SetPlayerInvincible(targetId, TargetGodmode[targetId])
    TriggerClientEvent('esx:showNotification', targetId, TargetGodmode[targetId] and "~g~An admin enabled God Mode on you" or "~r~An admin disabled God Mode on you")
    LogAdminAction(source, "toggle-target-godmode", ("target: %s -> %s"):format(GetPlayerName(targetId), tostring(TargetGodmode[targetId])), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:ToggleCuff')
AddEventHandler('Unique_AdminMenu:ToggleCuff', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TargetGodmode[targetId] = TargetGodmode[targetId] -- no-op, keeps table warm; real state lives client-side
    TriggerClientEvent('Unique_AdminMenu:ApplyCuff', targetId)
    LogAdminAction(source, "cuff-toggle", ("target: %s (id:%s)"):format(GetPlayerName(targetId), targetId), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

-- Real jail/unjail (movement lock + countdown) is handled by
-- Unique_Punishment's arshia_jail:sendto / arshia_jail:UnjailPlayer, which
-- do their own permission_level check. This just mirrors it into our own
-- admin_action_log / Discord log for a unified history, without duplicating
-- the fake teleport-only jail this used to be.
AddEventHandler('arshia_jail:sendto', function(target, jailType, minutes, reason)
    local source = source
    if jailType ~= 'admin' or not IsOnDutyAdmin(source) then return end
    local Target = ESX.GetPlayerFromId(tonumber(target))
    if not Target then return end
    LogAdminAction(source, "jail", ("target: %s | %s minutes | reason: %s"):format(GetPlayerName(target), minutes, reason), Target.identifier, GetPlayerName(target))
end)

AddEventHandler('arshia_jail:UnjailPlayer', function(target)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    local Target = ESX.GetPlayerFromId(tonumber(target))
    if not Target then return end
    LogAdminAction(source, "unjail", ("target: %s"):format(GetPlayerName(target)), Target.identifier, GetPlayerName(target))
end)

AddEventHandler('esx_communityGGservice:sendToCommunityService', function(target, count, reason)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    local Target = ESX.GetPlayerFromId(tonumber(target))
    if not Target then return end
    LogAdminAction(source, "community-service", ("target: %s | %s actions | reason: %s"):format(GetPlayerName(target), count, reason), Target.identifier, GetPlayerName(target))
end)

RegisterServerEvent('Unique_AdminMenu:WhisperTarget')
AddEventHandler('Unique_AdminMenu:WhisperTarget', function(targetId, message)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end
    if type(message) ~= 'string' or message == '' then return end

    TriggerClientEvent('chatMessage', targetId, "[ADMIN MESSAGE]", { 90, 170, 255 }, message)
    LogAdminAction(source, "whisper", ("target: %s | msg: %s"):format(GetPlayerName(targetId), message))
end)

RegisterServerEvent('Unique_AdminMenu:ScreenshotTarget')
AddEventHandler('Unique_AdminMenu:ScreenshotTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    if GetResourceState('screenshot-basic') ~= 'started' then
        TriggerClientEvent('esx:showNotification', source, "~r~screenshot-basic resource is not running")
        return
    end

    local targetName = GetPlayerName(targetId)
    -- GetResourceState() only tells us the resource is running, not that it
    -- actually exposes this export (a different/older build might not) -
    -- pcall so a missing or broken export shows a clean message instead of
    -- throwing a script error and killing this event.
    local ok, err = pcall(function()
        exports['screenshot-basic']:requestClientScreenshot(targetId, { encoding = 'jpg', quality = 0.7 }, function(reqErr, data)
            if reqErr then
                TriggerClientEvent('esx:showNotification', source, "~r~Screenshot failed")
                return
            end
            TriggerClientEvent('Unique_AdminMenu:ShowScreenshot', source, data, targetName)
        end)
    end)
    if not ok then
        print("[Unique_AdminMenu] screenshot-basic export call failed: " .. tostring(err))
        TriggerClientEvent('esx:showNotification', source, "~r~screenshot-basic doesn't expose requestClientScreenshot - check that resource is the official, up-to-date build")
        return
    end
    LogAdminAction(source, "screenshot", ("target: %s (id:%s)"):format(targetName, targetId), ESX.GetPlayerFromId(targetId).identifier, targetName)
end)

-- ---------------------------------------------------------------- ONLINE ---

local SessionStart = {}
AddEventHandler('esx:playerLoaded', function(playerId)
    SessionStart[playerId] = os.time()
end)
AddEventHandler('playerDropped', function()
    SessionStart[source] = nil
end)

ESX.RegisterServerCallback('Unique_AdminMenu:GetOnlinePlayers', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    local list = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            local sessionSeconds = SessionStart[playerId] and (os.time() - SessionStart[playerId]) or 0
            list[#list + 1] = {
                id = playerId,
                name = GetPlayerName(playerId),
                ping = GetPlayerPing(playerId),
                job = xPlayer.job and (xPlayer.job.label or xPlayer.job.name) or 'n/a',
                sessionMinutes = math.floor(sessionSeconds / 60),
            }
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    cb(list)
end)

-- --------------------------------------------------------------- VEHICLE ---

RegisterServerEvent('Unique_AdminMenu:GiveVehicle')
AddEventHandler('Unique_AdminMenu:GiveVehicle', function(targetId, model)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end
    if type(model) ~= 'string' or model == '' then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyGivenVehicle', targetId, model)
    LogAdminAction(source, "give-vehicle", ("target: %s | model: %s"):format(GetPlayerName(targetId), model), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

-- ----------------------------------------------------------------- WORLD ---

local WorldState = { trafficDensity = 'normal', timeFrozen = false }

RegisterServerEvent('Unique_AdminMenu:ToggleFreezeTime')
AddEventHandler('Unique_AdminMenu:ToggleFreezeTime', function()
    local source = source
    if not IsOnDutyAdmin(source) then return end
    WorldState.timeFrozen = not WorldState.timeFrozen
    TriggerClientEvent('Unique_AdminMenu:ApplyFreezeTime', -1, WorldState.timeFrozen)
    LogAdminAction(source, "toggle-freeze-time", tostring(WorldState.timeFrozen))
end)

local ValidDensity = { off = true, low = true, normal = true, high = true }
RegisterServerEvent('Unique_AdminMenu:SetTrafficDensity')
AddEventHandler('Unique_AdminMenu:SetTrafficDensity', function(level)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    level = tostring(level or ''):lower()
    if not ValidDensity[level] then return end

    WorldState.trafficDensity = level
    TriggerClientEvent('Unique_AdminMenu:ApplyTrafficDensity', -1, level)
    LogAdminAction(source, "set-traffic-density", level)
end)

-- ------------------------------------------------------------------ VEHICLE (nearby) ---

-- Locking and max-upgrading the nearest vehicle re-uses the same
-- Unique_AdminMenu:VehicleAction event admin_tools.lua already validates
-- and logs through - just teaching it two more action names.
local ExtraVehicleActions = { lock = true, maxupgrade = true }
RegisterServerEvent('Unique_AdminMenu:VehicleAction')
AddEventHandler('Unique_AdminMenu:VehicleAction', function(action)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if not ExtraVehicleActions[action] then return end

    TriggerClientEvent('Unique_AdminMenu:ApplyVehicleAction', source, action)
    LogAdminAction(source, "vehicle-" .. action, nil)
end)

-- ----------------------------------------------------------------- COMMS ---

RegisterServerEvent('Unique_AdminMenu:AdminChat')
AddEventHandler('Unique_AdminMenu:AdminChat', function(message)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if type(message) ~= 'string' or message == '' then return end

    for _, playerId in ipairs(ESX.GetPlayers()) do
        if IsOnDutyAdmin(playerId) then
            TriggerClientEvent('chatMessage', playerId, ("[ADMIN CHAT] %s"):format(GetPlayerName(source)), { 201, 162, 75 }, message)
        end
    end
    LogAdminAction(source, "admin-chat", message)
end)

RegisterServerEvent('Unique_AdminMenu:AnnounceWithSound')
AddEventHandler('Unique_AdminMenu:AnnounceWithSound', function(message)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if type(message) ~= 'string' or message == '' then return end

    TriggerClientEvent('chatMessage', -1, "[ANNOUNCE]", { 255, 165, 0 }, message)
    TriggerClientEvent('Unique_AdminMenu:PlayAnnounceSound', -1)
    LogAdminAction(source, "announce-sound", message)
end)

-- --------------------------------------------------------------- DASHBOARD ---

ESX.RegisterServerCallback('Unique_AdminMenu:GetDashboard', function(source, cb)
    if not IsOnDutyAdmin(source) then cb(nil) return end

    local resources = {}
    for i = 0, GetNumResources() - 1 do
        local name = GetResourceByFindIndex(i)
        if name then
            resources[#resources + 1] = { name = name, state = GetResourceState(name) }
        end
    end
    table.sort(resources, function(a, b) return a.name:lower() < b.name:lower() end)

    MySQL.Async.fetchAll(
        "SELECT `identifier`, CONCAT(COALESCE(`firstname`,''), ' ', COALESCE(`lastname`,'')) AS pname, (`money` + `bank`) AS total FROM `users` ORDER BY total DESC LIMIT 10",
        {},
        function(richest)
            MySQL.Async.fetchAll(
                "SELECT `identifier`, MAX(`playername`) AS playername, COUNT(*) AS cnt FROM `admin_warnings` GROUP BY `identifier` ORDER BY cnt DESC LIMIT 10",
                {},
                function(warned)
                    local onlineAdmins = {}
                    for _, src in ipairs(ESX.GetPlayers()) do
                        if IsOnDutyAdmin(src) then onlineAdmins[#onlineAdmins + 1] = src end
                    end

                    if #onlineAdmins == 0 then
                        cb({
                            richest = richest or {},
                            mostWarned = warned or {},
                            resources = resources,
                            onlineCount = #ESX.GetPlayers(),
                            staff = {},
                        })
                        return
                    end

                    -- One admin_name IN (...) query covering everyone on duty,
                    -- instead of a round trip per admin.
                    local names, placeholders = {}, {}
                    for i, src in ipairs(onlineAdmins) do
                        names[i] = GetPlayerName(src)
                        placeholders[i] = '@n' .. i
                    end
                    local params = {}
                    for i, n in ipairs(names) do params['@n' .. i] = n end

                    MySQL.Async.fetchAll(
                        ("SELECT `admin_name`, COUNT(*) AS cnt FROM `admin_action_log` WHERE `admin_name` IN (%s) GROUP BY `admin_name`"):format(table.concat(placeholders, ',')),
                        params,
                        function(actionRows)
                            local actionsByName = {}
                            for _, row in ipairs(actionRows or {}) do
                                actionsByName[row.admin_name] = row.cnt
                            end

                            local staff = {}
                            for i, src in ipairs(onlineAdmins) do
                                local start = DutySessionStart and DutySessionStart[src]
                                staff[#staff + 1] = {
                                    name = names[i],
                                    source = src,
                                    dutyMinutes = start and math.floor((os.time() - start) / 60) or 0,
                                    actions = actionsByName[names[i]] or 0,
                                }
                            end
                            table.sort(staff, function(a, b) return a.dutyMinutes > b.dutyMinutes end)

                            cb({
                                richest = richest or {},
                                mostWarned = warned or {},
                                resources = resources,
                                onlineCount = #ESX.GetPlayers(),
                                staff = staff,
                            })
                        end
                    )
                end
            )
        end
    )
end)
