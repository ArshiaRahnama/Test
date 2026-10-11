-- ==========================================================================
-- Discord app v18 — per-server audit log. Loaded LAST (after every callback is
-- registered): it wraps the admin callbacks listed below. A row is written only
-- when the wrapped callback succeeds, so refused actions are never logged.
-- Framework: essentialmode stores callbacks in ESX.ServerCallbacks[name] and
-- calls them as (source, cb, ...).
-- ==========================================================================
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end

local function serverOfChannel(channelId)
    local r = Q("SELECT server_id FROM phone_discord_channels WHERE id = @c", { ['@c'] = tonumber(channelId) or 0 })[1]
    return r and r.server_id or nil
end
local function serverOfMessage(messageId)
    local r = Q("SELECT c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = @m", { ['@m'] = tonumber(messageId) or 0 })[1]
    return r and r.server_id or nil
end
local function memberName(memberRowId)
    local r = Q("SELECT nickname FROM phone_discord_members WHERE id = @m", { ['@m'] = tonumber(memberRowId) or 0 })[1]
    return r and r.nickname or ("member #" .. tostring(memberRowId))
end
local function roleName(roleId)
    local r = Q("SELECT name FROM phone_discord_roles WHERE id = @r", { ['@r'] = tonumber(roleId) or 0 })[1]
    return r and r.name or ("role #" .. tostring(roleId))
end

-- each entry: action label; server(args) -> serverId; target(args) -> text
-- args[1] is the first argument after (source, cb)
local byServerArg1 = function(a) return tonumber(a[1]) end
local AUDIT = {
    ['Unique_Phone:server:Discord:KickMember']     = { 'kick member',        byServerArg1, function(a) return memberName(a[2]) end },
    ['Unique_Phone:server:Discord:ToggleAdmin']    = { 'toggle admin',       byServerArg1, function(a) return memberName(a[2]) end },
    ['Unique_Phone:server:Discord:DeleteMessage']  = { 'delete message',     function(a) return serverOfMessage(a[1]) end, function(a) return 'message #' .. tostring(a[1]) end },
    ['Unique_Phone:server:DiscordExt:Timeout']     = { 'timeout member',     byServerArg1, function(a) return memberName(a[2]) .. ' · ' .. tostring(a[3]) .. ' min' end },
    ['Unique_Phone:server:DiscordExt:Warn']        = { 'warn member',        byServerArg1, function(a) return memberName(a[2]) end },
    ['Unique_Phone:server:DiscordExt:ClearWarns']  = { 'clear warnings',     byServerArg1, function(a) return memberName(a[2]) end },
    ['Unique_Phone:server:DiscordExt:BulkDelete']  = { 'bulk delete',        function(a) return serverOfChannel(a[1]) end, function(a) return #(a[2] or {}) .. ' messages' end },
    ['Unique_Phone:server:DiscordExt:CreateRole']  = { 'create role',        byServerArg1, function(a) return tostring(a[2]) end },
    ['Unique_Phone:server:DiscordExt:UpdateRole']  = { 'edit role',          byServerArg1, function(a) return roleName(a[2]) end },
    ['Unique_Phone:server:DiscordExt:DeleteRole']  = { 'delete role',        byServerArg1, function(a) return roleName(a[2]) end },
    ['Unique_Phone:server:DiscordExt:SetMemberRole'] = { 'change member role', byServerArg1, function(a) return memberName(a[2]) .. ' · ' .. roleName(a[3]) .. (a[4] and ' (added)' or ' (removed)') end },
    ['Unique_Phone:server:DiscordExt:CreateInvite']  = { 'create invite',   byServerArg1, function(a) return 'uses ' .. tostring(a[2]) .. ' · expires ' .. tostring(a[3]) .. ' min' end },
    ['Unique_Phone:server:DiscordExt:RevokeInvite']  = { 'revoke invite',   byServerArg1, function(a) return 'invite #' .. tostring(a[2]) end },
    ['Unique_Phone:server:DiscordExt:SetWelcome']    = { 'edit welcome & rules', byServerArg1, function() return 'welcome screen' end },
    ['Unique_Phone:server:DiscordExt:SetChannelPerm']= { 'channel permission', byServerArg1, function(a) return 'channel #' .. tostring(a[2]) .. ' · ' .. roleName(a[3]) end },
    ['Unique_Phone:server:DiscordExt:CreateStageChannel'] = { 'create stage',  byServerArg1, function(a) return tostring(a[2]) end },
    ['Unique_Phone:server:DiscordExt:CreateChannelFromTemplate'] = { 'create channel', byServerArg1, function(a) return tostring(a[3] or a[2]) end },
    ['Unique_Phone:server:DiscordExt:SetChannelOrder'] = { 'reorder channels', byServerArg1, function() return 'all channels' end },
    ['Unique_Phone:server:DiscordExt:SetAnnouncementChannel'] = { 'announcement mode', function(a) return serverOfChannel(a[1]) end, function(a) return 'channel #' .. tostring(a[1]) .. ' · ' .. tostring(a[2]) end },
    ['Unique_Phone:server:DiscordExt:FollowChannel']   = { 'follow channel',  function(a) return serverOfChannel(a[1]) end, function(a) return 'from channel #' .. tostring(a[2]) end },
    ['Unique_Phone:server:DiscordExt:UnfollowChannel'] = { 'unfollow channel', function(a) return serverOfChannel(a[1]) end, function(a) return 'channel #' .. tostring(a[1]) end },
    ['Unique_Phone:server:DiscordExt:ToggleFeatured']  = { 'star / unstar message', function(a) return serverOfMessage(a[1]) end, function(a) return 'message #' .. tostring(a[1]) end },
    ['Unique_Phone:server:DiscordExt:ResolveAppeal']   = { 'resolve appeal', function(a)
            local r = Q("SELECT server_id FROM phone_discord_appeals WHERE id = @a", { ['@a'] = tonumber(a[1]) or 0 })[1]
            return r and r.server_id or nil end, function(a) return 'appeal #' .. tostring(a[1]) .. (a[2] and ' · accepted' or ' · declined') end },
    ['Unique_Phone:server:DiscordExt:AddStaffNote']    = { 'staff note added', byServerArg1, function(a) return memberName(a[2]) end },
    ['Unique_Phone:server:DiscordExt:DeleteStaffNote'] = { 'staff note deleted', function(a)
            local r = Q("SELECT server_id FROM phone_discord_staff_notes WHERE id = @n", { ['@n'] = tonumber(a[1]) or 0 })[1]
            return r and r.server_id or nil end, function(a) return 'note #' .. tostring(a[1]) end },
    ['Unique_Phone:server:DiscordExt:SaveChannelTemplate'] = { 'save channel template', function(a) return serverOfChannel(a[1]) end, function(a) return 'channel #' .. tostring(a[1]) end },
    ['Unique_Phone:server:DiscordExt:DeleteChannelTemplate'] = { 'delete channel template', function(a)
            local r = Q("SELECT server_id FROM phone_discord_channel_templates WHERE id = @t", { ['@t'] = tonumber(a[1]) or 0 })[1]
            return r and r.server_id or nil end, function(a) return 'template #' .. tostring(a[1]) end },
}

local function succeeded(result)
    if result == true then return true end
    if type(result) == "table" then return result.error == nil and result.ok ~= false end
    return false
end

local function record(source, sid, label, target)
    if not sid then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("INSERT INTO phone_discord_server_audit (server_id, actor_identifier, actor_name, action, target, created_at) VALUES (@s, @i, @n, @a, @t, @c)", {
        ['@s'] = sid, ['@i'] = xPlayer and xPlayer.identifier or "?", ['@n'] = Discord_GetDisplayName(source),
        ['@a'] = label, ['@t'] = Discord_Utf8SafeSub(tostring(target or ""), 160), ['@c'] = os.time(),
    })
end

local wrapped = 0
for name, spec in pairs(AUDIT) do
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        local label, serverOf, targetOf = spec[1], spec[2], spec[3]
        ESX.ServerCallbacks[name] = function(source, cb, ...)
            local args = { ... }
            -- resolve the server BEFORE the action (a deleted row can't be looked up afterwards)
            local okS, sid = pcall(serverOf, args)
            local okT, target = pcall(targetOf, args)
            return orig(source, function(result, ...)
                if succeeded(result) and okS then pcall(record, source, sid, label, okT and target or "") end
                return cb(result, ...)
            end, ...)
        end
        wrapped = wrapped + 1
    end
end
print("[Unique_Phone] server audit log attached to " .. wrapped .. " admin actions")

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetServerAudit', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local rows = Q("SELECT actor_name, action, target, created_at FROM phone_discord_server_audit WHERE server_id = @s ORDER BY id DESC LIMIT 100", { ['@s'] = serverId })
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = { actor = r.actor_name, action = r.action, target = r.target, at = r.created_at } end
    cb(out)
end)
