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

-- Jail re-uses the exact same coordinates the existing /az command already
-- teleports on-duty admins to, so it lines up with whatever jail/holding
-- area this server already has set up. It also writes into `adminjaillog`,
-- the same table the offline /ajailoffline command uses, so both show up
-- in one place.
local JailCoords = vector3(-425.507, 1123.468, 325.85)
local PreJailCoords = {}

RegisterServerEvent('Unique_AdminMenu:JailTarget')
AddEventHandler('Unique_AdminMenu:JailTarget', function(targetId, minutes, reason)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end
    minutes = tonumber(minutes) or 0
    reason = (type(reason) == 'string' and reason ~= '') and reason or 'No reason specified'

    PreJailCoords[targetId] = GetEntityCoords(GetPlayerPed(targetId))
    ExemptFromAntiCheat(targetId, 5000, { teleport = true, speed = true })
    TriggerClientEvent('Unique_AdminMenu:ApplyTeleportCoords', targetId, JailCoords.x, JailCoords.y, JailCoords.z)
    TriggerClientEvent('esx:showNotification', targetId, ("~r~You have been jailed for %s minutes: %s"):format(minutes, reason))

    MySQL.Async.execute(
        "INSERT INTO `adminjaillog` (`identifier`, `name`, `jailreason`, `jailtime`, `punisher`, `date`) VALUES (@identifier, @name, @reason, @jailtime, @punisher, @date)",
        {
            ['@identifier'] = Target.identifier,
            ['@name'] = GetPlayerName(targetId),
            ['@reason'] = reason,
            ['@jailtime'] = minutes,
            ['@punisher'] = GetPlayerName(source),
            ['@date'] = tostring(os.time()),
        }
    )
    LogAdminAction(source, "jail", ("target: %s | %s minutes | reason: %s"):format(GetPlayerName(targetId), minutes, reason), Target.identifier, GetPlayerName(targetId))
end)

RegisterServerEvent('Unique_AdminMenu:UnjailTarget')
AddEventHandler('Unique_AdminMenu:UnjailTarget', function(targetId)
    local source = source
    if not IsOnDutyAdmin(source) then return end
    targetId = tonumber(targetId)
    local Target = ESX.GetPlayerFromId(targetId)
    if not Target then return end

    local back = PreJailCoords[targetId]
    ExemptFromAntiCheat(targetId, 5000, { teleport = true, speed = true })
    if back then
        TriggerClientEvent('Unique_AdminMenu:ApplyTeleportCoords', targetId, back.x, back.y, back.z)
        PreJailCoords[targetId] = nil
    end
    TriggerClientEvent('esx:showNotification', targetId, "~g~You have been released from jail")
    LogAdminAction(source, "unjail", ("target: %s"):format(GetPlayerName(targetId)), Target.identifier, GetPlayerName(targetId))
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
                    cb({
                        richest = richest or {},
                        mostWarned = warned or {},
                        resources = resources,
                        onlineCount = #ESX.GetPlayers(),
                    })
                end
            )
        end
    )
end)
