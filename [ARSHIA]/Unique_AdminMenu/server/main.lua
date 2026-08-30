ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Config = {
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
