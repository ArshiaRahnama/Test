-- ============================================================================
-- EXPANSION PACK - extra Player / Vehicle / World / Comms / Dashboard tools
-- Everything here follows the same pattern as admin_tools.lua: check
-- IsOnDutyAdmin(source) first, validate input, do the thing, LogAdminAction.
-- ============================================================================

-- ---------------------------------------------------------------- PLAYER ---

RegisterServerEvent('Unique_AdminPanel:SetHealth')
AddEventHandler('Unique_AdminPanel:SetHealth', function(targetId, pct)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 2) then return end
    targetId = tonumber(targetId)
    pct = tonumber(pct)
    if not targetId or not ESX.GetPlayerFromId(targetId) or not pct then return end
    pct = math.max(0, math.min(100, pct))

    TriggerClientEvent('Unique_AdminPanel:ApplySetHealth', targetId, pct)
    LogAdminAction(source, "set-health", ("target: %s | %s%%"):format(GetPlayerName(targetId), pct), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:SetArmor')
AddEventHandler('Unique_AdminPanel:SetArmor', function(targetId, pct)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 2) then return end
    targetId = tonumber(targetId)
    pct = tonumber(pct)
    if not targetId or not ESX.GetPlayerFromId(targetId) or not pct then return end
    pct = math.max(0, math.min(100, pct))

    TriggerClientEvent('Unique_AdminPanel:ApplySetArmor', targetId, pct)
    LogAdminAction(source, "set-armor", ("target: %s | %s%%"):format(GetPlayerName(targetId), pct), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

-- SetPlayerInvincible is a server-authoritative native that can target ANY
-- player id, not just the caller - so target-godmode needs no client toggle
-- at all, unlike the self-godmode in main.lua's RequestToggle.
local TargetGodmode = {}
AddEventHandler('playerDropped', function() TargetGodmode[source] = nil end) -- ids get reused
RegisterServerEvent('Unique_AdminPanel:ToggleTargetGodmode')
AddEventHandler('Unique_AdminPanel:ToggleTargetGodmode', function(targetId)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_godmode') then DenyButtonAccess(source, 'btn_godmode') return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TargetGodmode[targetId] = not TargetGodmode[targetId]
    -- applied by the target's own client (server-side SetPlayerInvincible can crash FXServer)
    TriggerClientEvent('Unique_AdminPanel:ApplyTargetGodmode', targetId, TargetGodmode[targetId] and true or false)
    TriggerClientEvent('esx:showNotification', targetId, TargetGodmode[targetId] and "~g~An admin enabled God Mode on you" or "~r~An admin disabled God Mode on you")
    LogAdminAction(source, "toggle-target-godmode", ("target: %s -> %s"):format(GetPlayerName(targetId), tostring(TargetGodmode[targetId])), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:ToggleCuff')
AddEventHandler('Unique_AdminPanel:ToggleCuff', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 2) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end

    TargetGodmode[targetId] = TargetGodmode[targetId] -- no-op, keeps table warm; real state lives client-side
    TriggerClientEvent('Unique_AdminPanel:ApplyCuff', targetId)
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

RegisterServerEvent('Unique_AdminPanel:WhisperTarget')
AddEventHandler('Unique_AdminPanel:WhisperTarget', function(targetId, message)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end
    if type(message) ~= 'string' or message == '' then return end

    TriggerClientEvent('chatMessage', targetId, "[ADMIN MESSAGE]", { 90, 170, 255 }, message)
    LogAdminAction(source, "whisper", ("target: %s | msg: %s"):format(GetPlayerName(targetId), message))
end)

RegisterServerEvent('Unique_AdminPanel:ScreenshotTarget')
AddEventHandler('Unique_AdminPanel:ScreenshotTarget', function(targetId)
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
            TriggerClientEvent('Unique_AdminPanel:ShowScreenshot', source, data, targetName)
        end)
    end)
    if not ok then
        dprint("[Unique_AdminPanel] screenshot-basic export call failed: " .. tostring(err))
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

RegisterServerCallbackSafe('Unique_AdminPanel:GetOnlinePlayers', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll('SELECT identifier, note FROM admin_player_flags', {}, function(flagRows)
        local flagged = {}
        for _, f in ipairs(flagRows or {}) do flagged[f.identifier] = f.note end

        local list, identifiers = {}, {}
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
                    flagNote = flagged[xPlayer.identifier],
                    identifier = xPlayer.identifier,
                }
                identifiers[#identifiers + 1] = xPlayer.identifier
            end
        end
        table.sort(list, function(a, b) return a.id < b.id end)

        GetTrustScoresBatch(identifiers, function(scores)
            for _, p in ipairs(list) do p.trustScore = scores[p.identifier] end
            cb(list)
        end)
    end)
end)

-- Same data as GetOnlinePlayers, just sorted by most-recently-connected
-- (SessionStart is already tracked for the online-playtime panel above).
RegisterServerCallbackSafe('Unique_AdminPanel:GetNewPlayers', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    MySQL.Async.fetchAll('SELECT identifier, note FROM admin_player_flags', {}, function(flagRows)
        local flagged = {}
        for _, f in ipairs(flagRows or {}) do flagged[f.identifier] = f.note end

        local list, identifiers = {}, {}
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local joinedAt = SessionStart[playerId] or 0
                local sessionSeconds = joinedAt > 0 and (os.time() - joinedAt) or 0
                list[#list + 1] = {
                    id = playerId,
                    name = GetPlayerName(playerId),
                    ping = GetPlayerPing(playerId),
                    job = xPlayer.job and (xPlayer.job.label or xPlayer.job.name) or 'n/a',
                    sessionMinutes = math.floor(sessionSeconds / 60),
                    joinedAt = joinedAt,
                    flagNote = flagged[xPlayer.identifier],
                    identifier = xPlayer.identifier,
                }
                identifiers[#identifiers + 1] = xPlayer.identifier
            end
        end
        table.sort(list, function(a, b) return a.joinedAt > b.joinedAt end)
        -- Most recent 20 joins only - this is meant for "who just connected",
        -- not a full roster (that's what Online Players is for).
        while #list > 20 do table.remove(list) end

        local trimmedIds = {}
        for _, p in ipairs(list) do trimmedIds[#trimmedIds + 1] = p.identifier end
        GetTrustScoresBatch(trimmedIds, function(scores)
            for _, p in ipairs(list) do p.trustScore = scores[p.identifier] end
            cb(list)
        end)
    end)
end)

-- --------------------------------------------------------------- VEHICLE ---

RegisterServerEvent('Unique_AdminPanel:GiveVehicle')
AddEventHandler('Unique_AdminPanel:GiveVehicle', function(targetId, model)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 20) then return end
    targetId = tonumber(targetId)
    if not targetId or not ESX.GetPlayerFromId(targetId) then return end
    if type(model) ~= 'string' or model == '' then return end

    TriggerClientEvent('Unique_AdminPanel:ApplyGivenVehicle', targetId, model)
    LogAdminAction(source, "give-vehicle", ("target: %s | model: %s"):format(GetPlayerName(targetId), model), ESX.GetPlayerFromId(targetId).identifier, GetPlayerName(targetId))
end)

-- ----------------------------------------------------------------- WORLD ---

local WorldState = { trafficDensity = 'normal', timeFrozen = false }

RegisterServerEvent('Unique_AdminPanel:ToggleFreezeTime')
AddEventHandler('Unique_AdminPanel:ToggleFreezeTime', function()
    local source = source
    if not IsOnDutyAdmin(source) then return end
    WorldState.timeFrozen = not WorldState.timeFrozen
    TriggerClientEvent('Unique_AdminPanel:ApplyFreezeTime', -1, WorldState.timeFrozen)
    LogAdminAction(source, "toggle-freeze-time", tostring(WorldState.timeFrozen))
end)

local ValidDensity = { off = true, low = true, normal = true, high = true }
RegisterServerEvent('Unique_AdminPanel:SetTrafficDensity')
AddEventHandler('Unique_AdminPanel:SetTrafficDensity', function(level)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    level = tostring(level or ''):lower()
    if not ValidDensity[level] then return end

    WorldState.trafficDensity = level
    TriggerClientEvent('Unique_AdminPanel:ApplyTrafficDensity', -1, level)
    LogAdminAction(source, "set-traffic-density", level)
end)

-- ------------------------------------------------------------------ VEHICLE (nearby) ---

-- Locking and max-upgrading the nearest vehicle re-uses the same
-- Unique_AdminPanel:VehicleAction event admin_tools.lua already validates
-- and logs through - just teaching it two more action names.
local ExtraVehicleActions = { lock = true, maxupgrade = true }
RegisterServerEvent('Unique_AdminPanel:VehicleAction')
AddEventHandler('Unique_AdminPanel:VehicleAction', function(action)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    if not ExtraVehicleActions[action] then return end

    TriggerClientEvent('Unique_AdminPanel:ApplyVehicleAction', source, action)
    LogAdminAction(source, "vehicle-" .. action, nil)
end)

-- ----------------------------------------------------------------- COMMS ---

RegisterServerEvent('Unique_AdminPanel:AdminChat')
AddEventHandler('Unique_AdminPanel:AdminChat', function(message)
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

RegisterServerEvent('Unique_AdminPanel:AnnounceWithSound')
AddEventHandler('Unique_AdminPanel:AnnounceWithSound', function(message)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 4) then return end
    if type(message) ~= 'string' or message == '' then return end

    TriggerClientEvent('chatMessage', -1, "[ANNOUNCE]", { 255, 165, 0 }, message)
    TriggerClientEvent('Unique_AdminPanel:PlayAnnounceSound', -1)
    LogAdminAction(source, "announce-sound", message)
end)

-- --------------------------------------------------------------- DASHBOARD ---

RegisterServerCallbackSafe('Unique_AdminPanel:GetDashboard', function(source, cb)
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

                            MySQL.Async.fetchAll(
                                ("SELECT `admin_name`, AVG(`rating`) AS avg_rating, COUNT(*) AS cnt FROM `admin_report_ratings` WHERE `admin_name` IN (%s) GROUP BY `admin_name`"):format(table.concat(placeholders, ',')),
                                params,
                                function(ratingRows)
                                    local ratingByName = {}
                                    for _, row in ipairs(ratingRows or {}) do
                                        ratingByName[row.admin_name] = { avg = row.avg_rating, cnt = row.cnt }
                                    end

                                    MySQL.Async.fetchAll(
                                        ("SELECT `admin_name`, AVG(`response_seconds`) AS avg_seconds, COUNT(*) AS cnt FROM `admin_report_response_times` WHERE `admin_name` IN (%s) GROUP BY `admin_name`"):format(table.concat(placeholders, ',')),
                                        params,
                                        function(responseRows)
                                            local responseByName = {}
                                            for _, row in ipairs(responseRows or {}) do
                                                responseByName[row.admin_name] = { avgSeconds = row.avg_seconds, cnt = row.cnt }
                                            end

                                            local staff = {}
                                            for i, src in ipairs(onlineAdmins) do
                                                local start = DutySessionStart and DutySessionStart[src]
                                                local r = ratingByName[names[i]]
                                                local rt = responseByName[names[i]]
                                                staff[#staff + 1] = {
                                                    name = names[i],
                                                    source = src,
                                                    dutyMinutes = start and math.floor((os.time() - start) / 60) or 0,
                                                    actions = actionsByName[names[i]] or 0,
                                                    satisfaction = r and math.min(100, math.floor((r.avg / 5) * 100)) or nil,
                                                    ratingCount = r and r.cnt or 0,
                                                    avgResponseMinutes = rt and math.floor(rt.avgSeconds / 60) or nil,
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
                end
            )
        end
    )
end)

-- ------------------------------------------------------ VOICE/CHAT MUTE ---
-- Reuses esx_aduty's own client-side handlers (chat:setMuteStatus /
-- aduty:setMuteStatus already exist there regardless of which resource
-- triggers them), instead of re-implementing voice muting.

RegisterServerEvent('Unique_AdminPanel:MuteTarget')
AddEventHandler('Unique_AdminPanel:MuteTarget', function(targetId, muted)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 2) then return end
    targetId = tonumber(targetId)
    if not GetPlayerName(targetId) then return end
    if targetId == source then
        TriggerClientEvent('esx:showNotification', source, "~r~You can't mute yourself.")
        return
    end

    TriggerClientEvent('chat:setMuteStatus', targetId, muted and true or false)
    TriggerClientEvent('aduty:setMuteStatus', targetId, muted and true or false)
    LogAdminAction(source, muted and "mute" or "unmute", ("target: %s"):format(GetPlayerName(targetId)))
end)

-- ------------------------------------------------- WEAPON / INVENTORY ---

RegisterServerEvent('Unique_AdminPanel:GiveWeaponTarget')
AddEventHandler('Unique_AdminPanel:GiveWeaponTarget', function(targetId, weapon, ammo)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 5) then return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end
    if type(weapon) ~= 'string' or weapon == '' then return end
    ammo = tonumber(ammo) or 250

    local weaponName = "WEAPON_" .. string.upper(weapon):gsub("^WEAPON_", "")
    Target.addWeapon(weaponName, ammo)
    LogAdminAction(source, "give-weapon", ("target: %s | %s (%s ammo)"):format(GetPlayerName(targetId), weaponName, ammo), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:RemoveWeaponTarget')
AddEventHandler('Unique_AdminPanel:RemoveWeaponTarget', function(targetId, weapon)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 5) then return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end
    if type(weapon) ~= 'string' or weapon == '' then return end

    local weaponName = "WEAPON_" .. string.upper(weapon):gsub("^WEAPON_", "")
    Target.removeWeapon(weaponName)
    LogAdminAction(source, "remove-weapon", ("target: %s | %s"):format(GetPlayerName(targetId), weaponName), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:ClearInventoryTarget')
AddEventHandler('Unique_AdminPanel:ClearInventoryTarget', function(targetId)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_clearinv') then DenyButtonAccess(source, 'btn_clearinv') return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end

    for i = 1, #Target.inventory do
        if Target.inventory[i].count > 0 then
            Target.setInventoryItem(Target.inventory[i].name, 0)
        end
    end
    LogAdminAction(source, "clear-inventory", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:ClearLoadoutTarget')
AddEventHandler('Unique_AdminPanel:ClearLoadoutTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 5) then return end
    local Target = ESX.GetPlayerFromId(tonumber(targetId))
    if not Target then return end

    for i = #Target.loadout, 1, -1 do
        Target.removeWeapon(Target.loadout[i].name)
    end
    LogAdminAction(source, "clear-loadout", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)

-- ------------------------------------------------------- BULK ACTIONS ---
-- Reuses the same framework-level client events esx_aduty's own bulk
-- commands use (es_admin:freezePlayer / esx_basicneeds:healPlayer /
-- esx_ambulancejob:revivexIfDead), so behavior matches exactly.

local ServerFreezeState = false

RegisterServerEvent('Unique_AdminPanel:BulkAction')
AddEventHandler('Unique_AdminPanel:BulkAction', function(action, reason)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_bulk') then DenyButtonAccess(source, 'btn_bulk') return end

    if action == 'freezeall' then
        ServerFreezeState = not ServerFreezeState
        TriggerClientEvent('es_admin:freezePlayer', -1, ServerFreezeState)
        LogAdminAction(source, "bulk-freeze", ServerFreezeState and "froze everyone" or "unfroze everyone")

    elseif action == 'healall' then
        TriggerClientEvent('esx_basicneeds:healPlayer', -1)
        LogAdminAction(source, "bulk-heal", "healed everyone")

    elseif action == 'reviveall' then
        TriggerClientEvent('esx_ambulancejob:revivexIfDead', -1)
        LogAdminAction(source, "bulk-revive", "revived everyone")

    elseif action == 'kickall' then
        reason = (type(reason) == 'string' and reason ~= '') and reason or 'Server maintenance'
        LogAdminAction(source, "bulk-kick", ("reason: %s"):format(reason))
        for _, id in ipairs(ESX.GetPlayers()) do
            if id ~= source then
                DropPlayer(id, reason)
            end
        end

    elseif action == 'clearall' then
        TriggerClientEvent('chat:clear', -1)
        LogAdminAction(source, "bulk-clear-chat", "cleared chat for everyone")
    end
end)

RegisterServerEvent('Unique_AdminPanel:LogClientAction')
AddEventHandler('Unique_AdminPanel:LogClientAction', function(action, details)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    -- client-reported: tag it so nobody can pass it off as a server-verified
    -- action, and keep the fields short / printable (log + webhook safe)
    action = tostring(action or ''):gsub('[^%w_%-]', ''):sub(1, 30)
    if action == '' then return end
    LogAdminAction(source, 'client:' .. action, tostring(details or ''):gsub('[%c`@]', ' '):sub(1, 200))
end)

-- --------------------------------------------------- JAIL / CS RELAY ---
-- Real per-button enforcement for Jail/CS: check here (correct `source`,
-- since this IS a genuine client->server trigger), then tell the SAME
-- admin's client to fire the actual cross-resource event itself. We can't
-- just re-fire arshia_jail:sendto / esx_communityGGservice:sendToCommunityService
-- directly from here - those events expect `source` to be the real
-- triggering client, which only holds if the trigger came from that
-- client's own TriggerServerEvent call.

RegisterServerEvent('Unique_AdminPanel:RequestJail')
AddEventHandler('Unique_AdminPanel:RequestJail', function(targetId, minutes, reason)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_jail') then DenyButtonAccess(source, 'btn_jail') return end
    if not ESX.GetPlayerFromId(tonumber(targetId)) then return end
    TriggerClientEvent('Unique_AdminPanel:ProceedJail', source, targetId, minutes, reason)
end)

RegisterServerEvent('Unique_AdminPanel:RequestCS')
AddEventHandler('Unique_AdminPanel:RequestCS', function(targetId, count, reason)
    local source = source
    if not IsOnDutyAdminFor(source, 'btn_cs') then DenyButtonAccess(source, 'btn_cs') return end
    if not ESX.GetPlayerFromId(tonumber(targetId)) then return end
    TriggerClientEvent('Unique_AdminPanel:ProceedCS', source, targetId, count, reason)
end)

-- ---------------------------------------------------------- LAUNCH ---
-- Launches a TARGET player into the air. Ragdoll-slap (existing /slap
-- command in main.lua) already covers the ragdoll+damage version; this is
-- the separate "just launch them upward" one.

RegisterServerEvent('Unique_AdminPanel:LaunchTarget')
AddEventHandler('Unique_AdminPanel:LaunchTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminMinLevel(source, 2) then return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    TriggerClientEvent('Unique_AdminPanel:ApplyLaunch', targetId)
    LogAdminAction(source, "launch", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)


-- =========================================================================
-- Added with the MenuV menu (ported from esx_adminmenu): Kill target and
-- Sit-in-target's-vehicle. Unlike the original esx_adminmenu events these
-- are gated server-side (on-duty admin + minimum level), so a modified
-- client can't trigger them.
-- =========================================================================
local function AdminHasLevel(src, level)
    local x = ESX.GetPlayerFromId(src)
    return x ~= nil and (x.permission_level or 0) >= level
end

RegisterServerEvent('Unique_AdminPanel:SlayTarget')
AddEventHandler('Unique_AdminPanel:SlayTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminHasLevel(source, 2) then return end
    targetId = tonumber(targetId)
    local Target = targetId and ESX.GetPlayerFromId(targetId)
    if not Target then return end

    TriggerClientEvent('Unique_AdminPanel:ApplySlay', targetId)
    LogAdminAction(source, "slay", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminPanel:IntoVehicle')
AddEventHandler('Unique_AdminPanel:IntoVehicle', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) or not AdminHasLevel(source, 2) then return end
    targetId = tonumber(targetId)
    local Target = targetId and ESX.GetPlayerFromId(targetId)
    if not Target or targetId == source then return end

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(targetId), false)
    if vehicle == 0 then
        TriggerClientEvent('Unique_AdminPanel:MenuNotify', source, "~r~That player is not in a vehicle")
        return
    end

    local seat = -2
    for i = -1, 6 do
        if GetPedInVehicleSeat(vehicle, i) == 0 then seat = i break end
    end
    if seat == -2 then
        TriggerClientEvent('Unique_AdminPanel:MenuNotify', source, "~r~No free seat in that vehicle")
        return
    end

    -- the admin's own client does the warp (server-side ped natives are crash-prone)
    TriggerClientEvent('Unique_AdminPanel:WarpIntoVehicle', source, NetworkGetNetworkIdFromEntity(vehicle), seat)
    LogAdminAction(source, "intovehicle", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
end)

-- Vehicle spawn-name -> display-name list for the "Spawn by Category" menu.
-- Read from essentialmode's own vehicle_names.json (server-side, cached).
local vehicleNamesCache
RegisterServerCallbackSafe('Unique_AdminPanel:GetVehicleNames', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end
    if not vehicleNamesCache then
        local raw = LoadResourceFile('essentialmode', 'shared/data/vehicle_names.json')
        local ok, data = pcall(json.decode, raw or '{}')
        vehicleNamesCache = (ok and type(data) == 'table' and data.names) or {}
    end
    cb(vehicleNamesCache)
end)

-- --------------------------------------------------- DATA RETENTION ---
-- The chat archive had no retention at all: every chat line ever typed was
-- kept forever (big table, slow LIKE searches, and a privacy liability).
-- Keep 30 days; delete in small batches so the DB is never locked for long.
local CHAT_ARCHIVE_DAYS = 30

CreateThread(function()
    Wait(60 * 1000)
    while true do
        local deleted
        repeat
            deleted = MySQL.Sync.execute(
                "DELETE FROM `admin_chat_archive` WHERE `created_at` < DATE_SUB(NOW(), INTERVAL @d DAY) LIMIT 5000",
                { ['@d'] = CHAT_ARCHIVE_DAYS }
            ) or 0
            Wait(500)
        until deleted < 5000
        Wait(24 * 60 * 60 * 1000)
    end
end)
