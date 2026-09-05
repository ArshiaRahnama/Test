ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Global (not local) on purpose: server/settings.lua and
-- server/investigation.lua also reference Config.MinPermissionLevel /
-- Config.DiscordWebhook, and each .lua file in a resource is its own
-- separate Lua chunk - a `local` here would only be visible within this
-- file, not to the others (this was the exact bug behind the
-- "attempt to index a nil value (global 'Config')" error).
Config = {
    DiscordWebhook = GetConvar('unique_adminmenu_webhook', ""),


    MinPermissionLevel = 1,
}

local AdminToggleState = {}

local function GetState(source)
    if not AdminToggleState[source] then
        AdminToggleState[source] = {}
    end
    return AdminToggleState[source]
end

AddEventHandler('playerDropped', function()
    AdminToggleState[source] = nil
end)

function IsOnDutyAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    if xPlayer.permission_level == nil or xPlayer.permission_level < Config.MinPermissionLevel then
        return false
    end
    if not xPlayer.get('aduty') then
        return false
    end
    return true
end

-- ------------------------------------------------- BUTTON PERMISSIONS ---
-- Real server-side enforcement for the per-button levels set in the
-- Button Permissions NUI panel (client/general_utils.lua's AButton /
-- server/settings.lua's admin_button_perms table) - not just hiding the
-- button client-side. Every handler this applies to calls
-- IsOnDutyAdminFor(source, buttonId) instead of plain IsOnDutyAdmin, so a
-- rank-1 admin can't bypass a rank-5-only action by typing the command
-- directly or editing their client.
--
-- Cached in memory (ButtonPermsCache) rather than hitting the DB on every
-- single admin action - refreshed at startup and whenever
-- Unique_AdminMenu:SetButtonPerm changes a value (see server/settings.lua).
ButtonPermsCache = {}

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(50) end
    MySQL.Async.fetchAll('SELECT button_id, min_level FROM admin_button_perms', {}, function(rows)
        for _, r in ipairs(rows or {}) do
            ButtonPermsCache[r.button_id] = r.min_level
        end
    end)
end)

-- buttonId may be nil (falls back to the plain Config.MinPermissionLevel
-- gate, same as IsOnDutyAdmin) - lets every call site pass a catalog id
-- without needing a special case for the ungated ones.
function IsOnDutyAdminFor(source, buttonId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    if not xPlayer.get('aduty') then return false end

    local required = (buttonId and ButtonPermsCache[buttonId]) or Config.MinPermissionLevel
    if xPlayer.permission_level == nil or xPlayer.permission_level < required then
        return false
    end
    return true
end

-- Denial gets its own log line (and Discord post, via LogAdminAction) so a
-- rank trying to reach past their level shows up in the audit trail, not
-- just a silent no-op.
function DenyButtonAccess(source, buttonId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local required = (buttonId and ButtonPermsCache[buttonId]) or Config.MinPermissionLevel
    LogAdminAction(source, "denied-permission", ("button: %s | has: %s | needs: %s"):format(
        buttonId or '?', xPlayer and xPlayer.permission_level or 'n/a', required))
    TriggerClientEvent('esx:showNotification', source, "~r~You don't have permission for that.")
end

function LogAdminAction(source, action, details, targetIdentifier, targetName)
    local name = GetPlayerName(source) or ('Unknown (' .. tostring(source) .. ')')
    local line = ('[Unique_AdminMenu] %s (id:%s) -> %s%s'):format(
        name, tostring(source), action, details and (' | ' .. details) or ''
    )
    print(line)

    if Config.DiscordWebhook ~= "" then
        local embeds = {
            {
                ["title"] = "Admin Action: " .. action,
                ["type"] = "rich",
                ["color"] = 15105642,
                ["description"] = ("**Admin:** %s (id: %s)\n%s"):format(name, tostring(source), details or ""),
            }
        }
        PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST',
            json.encode({ username = "Admin Log", embeds = embeds }),
            { ['Content-Type'] = 'application/json' })
    end

    -- Also mirror into the server's shared Discord logging resource (used
    -- by jail.lua/cs.lua/etc. for their own DiscordBot:ToDiscord('adminmenu', ...)
    -- calls), so everything lands in the same admin-log channel by default -
    -- no separate webhook convar to configure.
    TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', name, line, 'user', true, source, false)

    if targetIdentifier then
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.execute(
            "INSERT INTO `admin_action_log` (`admin_identifier`, `admin_name`, `target_identifier`, `target_name`, `action`, `details`, `created_at`) VALUES (@adminidentifier, @adminname, @targetidentifier, @targetname, @action, @details, @createdat)",
            {
                ['@adminidentifier'] = xPlayer and xPlayer.identifier or nil,
                ['@adminname'] = name,
                ['@targetidentifier'] = targetIdentifier,
                ['@targetname'] = targetName,
                ['@action'] = action,
                ['@details'] = details,
                ['@createdat'] = os.date('%Y-%m-%d %H:%M:%S'),
            }
        )
    end
end

exports('IsAdminToggleActive', function(source, feature)
    local state = AdminToggleState[source]
    if not state then return false end
    return state[feature] == true
end)

local ValidFeatures = {
    godmode      = true,
    invisibility = true,
    invisibility2= true,
    noclip       = true,
    superjump    = true,
    fastrun      = true,
    noragdoll    = true,
    infstamina   = true,
    blip         = true,
}

RegisterServerEvent('Unique_AdminMenu:RequestToggle')
AddEventHandler('Unique_AdminMenu:RequestToggle', function(feature)
    local source = source
    if not ValidFeatures[feature] then return end

    if not IsOnDutyAdmin(source) then
        LogAdminAction(source, "DENIED toggle:" .. feature, "player is not an on-duty admin")
        TriggerClientEvent('esx:showNotification', source, "~r~Shoma dastresi nadarid ya OffDuty hastid!")
        return
    end

    local state = GetState(source)
    state[feature] = not state[feature]
    local newValue = state[feature]

    if feature == 'godmode' then


        SetPlayerInvincible(source, newValue)
    end

    LogAdminAction(source, "toggle:" .. feature, "new state: " .. tostring(newValue))
    TriggerClientEvent('Unique_AdminMenu:ApplyToggle', source, feature, newValue)
end)

ESX.RegisterServerCallback('Admin_Menu:GetActivePlayers', function(source, cb)
    if not IsOnDutyAdmin(source) then cb({}) return end

    local cX = ESX.GetPlayers()
    local cJ = {}
    for i=1, #cX, 1 do
      local cSource = cX[i]
      local name = GetPlayerName(cSource)
      if name ~= '**Invalid**' then
        cJ[cSource] = (cSource == source) and (name .. ' (You)') or name
      end
    end
    cb(cJ)
end)

ESX.RegisterServerCallback('esx_spectate:xPlayerServerSide', function(source, cb, ID)
  if not IsOnDutyAdmin(source) then cb(nil) return end
  local xPlayer = ESX.GetPlayerFromId(tonumber(ID))
  if xPlayer then
      cb(xPlayer)
  else
      cb(nil)
  end
end)

ESX.RegisterServerCallback('Admin_Menu:GetTargetPosition', function(source, cb, id)
  if not IsOnDutyAdmin(source) then cb(GetEntityCoords(GetPlayerPed(tonumber(source)))) return end
  local sPlayer = ESX.GetPlayerFromId(tonumber(id))
  local xPlayer = ESX.GetPlayerFromId(source)
  ExemptFromAntiCheat(source, 6000, { teleport = true, speed = true, noclip = true, invisibility = true })
  if xPlayer and sPlayer then
    cb(GetEntityCoords(GetPlayerPed(tonumber(id))))
  else
    cb(GetEntityCoords(GetPlayerPed(tonumber(source))))
  end
end)

ESX.RegisterServerCallback('esx_spectate:RequestPermission', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  cb(tonumber(xPlayer.permission_level))
end)

ESX.RegisterServerCallback('esx_spectate:RequestDutyStatus', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.get('aduty') then
      cb(true)
  else
      cb(false)
  end
end)

RegisterCommand('slap', function(source, args)
  if not tonumber(args[1]) then return end
  local TargetId = tonumber(args[1])
  local xPlayer = ESX.GetPlayerFromId(source)
  local Target = ESX.GetPlayerFromId(TargetId)



  if xPlayer.permission_level >= 2 and xPlayer.get('aduty') and Target then
    LogAdminAction(source, "slap", "target: " .. GetPlayerName(TargetId) .. " (id:" .. TargetId .. ")")
    TriggerClientEvent('AdminMenu:SlapPlayers', TargetId)
  end
end)

-- Batch trust-score computation (same formula as InspectPlayer's) for a
-- list of identifiers at once - used by the Online/New Players badges so
-- we're not running 3 queries per player in a loop.
function GetTrustScoresBatch(identifiers, callback)
    if not identifiers or #identifiers == 0 then callback({}) return end

    local placeholders, params = {}, {}
    for i, id in ipairs(identifiers) do
        placeholders[i] = '@id' .. i
        params['@id' .. i] = id
    end
    local inClause = table.concat(placeholders, ',')

    MySQL.Async.fetchAll(("SELECT identifier, COUNT(*) AS cnt FROM admin_warnings WHERE identifier IN (%s) GROUP BY identifier"):format(inClause), params, function(warnRows)
        MySQL.Async.fetchAll(("SELECT identifier, COUNT(*) AS cnt FROM unique_adminmenu_bans WHERE identifier IN (%s) GROUP BY identifier"):format(inClause), params, function(banRows)
            MySQL.Async.fetchAll(("SELECT target_identifier AS identifier, COUNT(*) AS cnt FROM admin_action_log WHERE target_identifier IN (%s) AND action IN ('kick','jail','community-service') GROUP BY target_identifier"):format(inClause), params, function(punishRows)
                local warnByI, banByI, punishByI = {}, {}, {}
                for _, r in ipairs(warnRows or {}) do warnByI[r.identifier] = r.cnt end
                for _, r in ipairs(banRows or {}) do banByI[r.identifier] = r.cnt end
                for _, r in ipairs(punishRows or {}) do punishByI[r.identifier] = r.cnt end

                local scores = {}
                for _, id in ipairs(identifiers) do
                    local score = 100 - ((warnByI[id] or 0) * 5) - ((banByI[id] or 0) * 25) - ((punishByI[id] or 0) * 3)
                    if score < 0 then score = 0 end
                    scores[id] = score
                end
                callback(scores)
            end)
        end)
    end)
end
