-- ==========================================================================
-- Discord app v7 — client side. Thin NUI <-> server bridge (same style as
-- the "Discord:" section of client/main.lua) + rich-presence reporter +
-- phone-icon unread badge. All real work is in server/discord_ext.lua.
-- ==========================================================================

-- NUI callback name, server callback name, and the NUI payload fields that
-- are passed (in this order) as the server callback's arguments.
local function bridge(nuiName, serverName, ...)
    local argNames = { ... }
    RegisterNUICallback(nuiName, function(data, cb)
        data = data or {}
        local args = {}
        for i, name in ipairs(argNames) do args[i] = data[name] end
        ESX.TriggerServerCallback('Unique_Phone:server:DiscordExt:' .. serverName, function(result)
            if result == nil then result = false end
            cb(result)
        end, table.unpack(args, 1, #argNames))
    end)
end

bridge('DiscordExt_GetServerInfo',      'GetServerInfo',      'serverId')
bridge('DiscordExt_Boost',              'Boost',              'serverId')
bridge('DiscordExt_SetTheme',           'SetTheme',           'serverId', 'color')
bridge('DiscordExt_AddEmoji',           'AddEmoji',           'serverId', 'emoji')
bridge('DiscordExt_RemoveEmoji',        'RemoveEmoji',        'serverId', 'emoji')
bridge('DiscordExt_BuyVIP',             'BuyVIP',             'serverId', 'planId')
bridge('DiscordExt_Timeout',            'Timeout',            'serverId', 'memberId', 'minutes', 'reason')
bridge('DiscordExt_Warn',               'Warn',               'serverId', 'memberId', 'reason')
bridge('DiscordExt_ClearWarns',         'ClearWarns',         'serverId', 'memberId')
bridge('DiscordExt_GetMemberMod',       'GetMemberMod',       'serverId', 'memberId')
bridge('DiscordExt_GetAutoMod',         'GetAutoMod',         'serverId')
bridge('DiscordExt_AddAutoModWord',     'AddAutoModWord',     'serverId', 'word')
bridge('DiscordExt_RemoveAutoModWord',  'RemoveAutoModWord',  'serverId', 'word')
bridge('DiscordExt_Report',             'Report',             'messageId', 'reason')
bridge('DiscordExt_StaffReports',       'StaffReports',       'status')
bridge('DiscordExt_StaffResolveReport', 'StaffResolveReport', 'reportId', 'action')
bridge('DiscordExt_GetLeaderboard',     'GetLeaderboard',     'serverId')
bridge('DiscordExt_GetMemberMeta',      'GetMemberMeta',      'serverId')
bridge('DiscordExt_Search',             'Search',             'serverId', 'channelId', 'query')
bridge('DiscordExt_GetUnread',          'GetUnread')
bridge('DiscordExt_GetShareTargets',    'GetShareTargets')
bridge('DiscordExt_ShareImage',         'ShareImage',         'channelId', 'url', 'caption')

-- ---- v8: roles, permissions, invites, rules, stage, templates, folders ----
bridge('DiscordExt_GetRoles',           'GetRoles',           'serverId')
bridge('DiscordExt_CreateRole',         'CreateRole',         'serverId', 'name', 'color')
bridge('DiscordExt_UpdateRole',         'UpdateRole',         'serverId', 'roleId', 'data')
bridge('DiscordExt_DeleteRole',         'DeleteRole',         'serverId', 'roleId')
bridge('DiscordExt_MoveRole',           'MoveRole',           'serverId', 'roleId', 'dir')
bridge('DiscordExt_SetMemberRole',      'SetMemberRole',      'serverId', 'memberId', 'roleId', 'on')
bridge('DiscordExt_GetChannelPerms',    'GetChannelPerms',    'serverId', 'channelId')
bridge('DiscordExt_SetChannelPerm',     'SetChannelPerm',     'serverId', 'channelId', 'roleId', 'allow', 'deny')
bridge('DiscordExt_CreateStageChannel', 'CreateStageChannel', 'serverId', 'name')
bridge('DiscordExt_GetSpeakers',        'GetSpeakers',        'serverId', 'channelId')
bridge('DiscordExt_SetSpeaker',         'SetSpeaker',         'serverId', 'channelId', 'memberId', 'on')
bridge('DiscordExt_ListInvites',        'ListInvites',        'serverId')
bridge('DiscordExt_CreateInvite',       'CreateInvite',       'serverId', 'maxUses', 'expireMinutes')
bridge('DiscordExt_RevokeInvite',       'RevokeInvite',       'serverId', 'inviteId')
bridge('DiscordExt_SetVanity',          'SetVanity',          'serverId', 'code')
bridge('DiscordExt_SetWelcome',         'SetWelcome',         'serverId', 'title', 'text', 'rules', 'description', 'require')
bridge('DiscordExt_AcceptRules',        'AcceptRules',        'serverId')
bridge('DiscordExt_CreateTemplate',     'CreateTemplate',     'serverId', 'name', 'description', 'isPublic')
bridge('DiscordExt_ListTemplates',      'ListTemplates')
bridge('DiscordExt_DeleteTemplate',     'DeleteTemplate',     'templateId')
bridge('DiscordExt_UseTemplate',        'UseTemplate',        'code', 'name')
bridge('DiscordExt_GetServerCard',      'GetServerCard',      'serverId')
bridge('DiscordExt_GetMutes',           'GetMutes')
bridge('DiscordExt_SetMute',            'SetMute',            'kind', 'targetId', 'on')
bridge('DiscordExt_SetNickname',        'SetNickname',        'serverId', 'memberId', 'nickname')
bridge('DiscordExt_EnterChannel',       'EnterChannel',       'channelId')
bridge('DiscordExt_GetFolders',         'GetFolders')
bridge('DiscordExt_CreateFolder',       'CreateFolder',       'name', 'color', 'serverId')
bridge('DiscordExt_MoveToFolder',       'MoveToFolder',       'serverId', 'folderId')
bridge('DiscordExt_EditFolder',         'EditFolder',         'folderId', 'name', 'color')
bridge('DiscordExt_DeleteFolder',       'DeleteFolder',       'folderId')

RegisterNUICallback('DiscordExt_MarkSeen', function(data, cb)
    if data and data.channelId then TriggerServerEvent('Unique_Phone:server:DiscordExt:MarkSeen', data.channelId) end
    cb('ok')
end)

-- The NUI adds up per-channel unread counts and tells us the total; it
-- becomes the number on the Discord icon of the phone's home screen
-- (same .app-unread-alerts badge WhatsApp / Mail use).
local function setDiscordAlerts(count)
    local app = Config.PhoneApplications and Config.PhoneApplications['discord']
    if not app then return end
    app.Alerts = math.max(0, tonumber(count) or 0)
    SendNUIMessage({ action = "RefreshAppAlerts", AppData = Config.PhoneApplications })
end

RegisterNUICallback('DiscordExt_SetUnread', function(data, cb)
    setDiscordAlerts(data and data.count)
    cb('ok')
end)

-- ---- server -> NUI pushes ------------------------------------------------

RegisterNetEvent('Unique_Phone:client:DiscordExt:Notice')
AddEventHandler('Unique_Phone:client:DiscordExt:Notice', function(payload)
    SendNUIMessage({ action = "DiscordExtNotice", data = payload })
end)

RegisterNetEvent('Unique_Phone:client:DiscordExt:ServersChanged')
AddEventHandler('Unique_Phone:client:DiscordExt:ServersChanged', function()
    SendNUIMessage({ action = "DiscordExtServersChanged" })
end)

RegisterNetEvent('Unique_Phone:client:DiscordExt:ServerExtrasUpdated')
AddEventHandler('Unique_Phone:client:DiscordExt:ServerExtrasUpdated', function(payload)
    SendNUIMessage({ action = "DiscordExtServerExtrasUpdated", data = payload })
end)

-- Every new Discord message also reaches the NUI through the existing
-- "DiscordNewMessage" action; the NUI counts it as unread when that channel
-- isn't the one currently on screen. Nothing to do here.

-- Initial unread numbers a few seconds after the character loads.
CreateThread(function()
    Wait(15000)
    ESX.TriggerServerCallback('Unique_Phone:server:DiscordExt:GetUnread', function(rows)
        SendNUIMessage({ action = "DiscordExtUnread", data = rows or {} })
    end)
end)

-- ---- rich presence ---------------------------------------------------------
-- Reports only what changed: "driving / riding" + the index of the configured
-- place the player is standing in. The server turns it into the text shown
-- under the player's name ("On duty · Police — Driving").

CreateThread(function()
    Wait(8000)
    local last = ""
    while true do
        local P = Config.DiscordExt and Config.DiscordExt.Presence
        if P and P.Enabled then
            local ped = PlayerPedId()

            local veh = nil
            if IsPedInAnyVehicle(ped, false) then
                local v = GetVehiclePedIsIn(ped, false)
                veh = (GetPedInVehicleSeat(v, -1) == ped) and 'driving' or 'riding'
            end

            local place = nil
            local pos = GetEntityCoords(ped)
            for i, pl in ipairs(P.Places or {}) do
                if #(pos - pl.coords) <= pl.radius then place = i break end
            end

            local key = tostring(veh) .. ":" .. tostring(place)
            if key ~= last then
                last = key
                TriggerServerEvent('Unique_Phone:server:Discord:Presence', { veh = veh, place = place })
            end
        end
        Wait((P and P.CheckEveryMs) or 5000)
    end
end)
