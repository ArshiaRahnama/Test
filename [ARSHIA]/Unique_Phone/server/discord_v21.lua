-- ==========================================================================
-- Discord app v21 — (3) message edit history, (7) per-server ban list with reasons.
-- Loaded LAST (after discord_v20.lua). Wraps callbacks like the audit log does.
-- ==========================================================================
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end
local function ok(result)
    if result == true then return true end
    return type(result) == "table" and result.error == nil and result.ok ~= false
end

-- ---- 3) edit history: remember the text before each real edit -------------
do
    local name = 'Unique_Phone:server:Discord:EditMessage'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, messageId, newText)
            local before = Q("SELECT message FROM phone_discord_messages WHERE id = @m", { ['@m'] = tonumber(messageId) or 0 })[1]
            local xPlayer = Discord_GetPlayer(source)
            return orig(source, function(result, ...)
                if before and xPlayer and ok(result) and before.message ~= newText then
                    MySQL.Async.execute("INSERT INTO phone_discord_message_edits (message_id, old_text, edited_by, created_at) VALUES (@m, @t, @b, @c)", {
                        ['@m'] = tonumber(messageId), ['@t'] = Discord_Utf8SafeSub(before.message, 1000), ['@b'] = xPlayer.identifier, ['@c'] = os.time(),
                    })
                end
                return cb(result, ...)
            end, messageId, newText)
        end
    end
end

-- readers may see the history of any message in a server they belong to
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetEditHistory', function(source, cb, messageId)
    local xPlayer = Discord_GetPlayer(source)
    local m = Q("SELECT m.id, m.message, m.edited_at, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = @m", { ['@m'] = tonumber(messageId) or 0 })[1]
    if not xPlayer or not m or not Discord_IsMember(xPlayer.identifier, m.server_id) then cb(false) return end
    local versions = {}
    for _, e in ipairs(Q("SELECT old_text, created_at FROM phone_discord_message_edits WHERE message_id = @m ORDER BY id ASC LIMIT 20", { ['@m'] = m.id })) do
        versions[#versions + 1] = { text = e.old_text, at = e.created_at }
    end
    cb({ current = m.message, editedAt = m.edited_at, versions = versions })
end)

-- ---- 7) bans scoped to one server ------------------------------------------
local function bannedHere(identifier, serverId)
    return Q("SELECT reason FROM phone_discord_server_bans WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })[1]
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:BanMember', function(source, cb, serverId, memberRowId, reason)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local m = Q("SELECT id, identifier, nickname FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = tonumber(memberRowId) or 0, ['@s'] = serverId })[1]
    if not m then cb(false) return end
    local srv = Q("SELECT owner_identifier, name FROM phone_discord_servers WHERE id = @s", { ['@s'] = serverId })[1]
    if not srv or srv.owner_identifier == m.identifier or m.identifier == xPlayer.identifier then cb({ error = "NOT_ALLOWED" }) return end
    local why = Discord_Utf8SafeSub((tostring(reason or ""):gsub("[%c]", " ")), 160)
    Exec("REPLACE INTO phone_discord_server_bans (server_id, identifier, name, reason, banned_by, created_at) VALUES (@s, @i, @n, @r, @b, @c)", {
        ['@s'] = serverId, ['@i'] = m.identifier, ['@n'] = Discord_Utf8SafeSub(tostring(m.nickname or ""), 60), ['@r'] = why,
        ['@b'] = Discord_GetDisplayName(source), ['@c'] = os.time(),
    })
    Exec("DELETE FROM phone_discord_members WHERE id = @mid", { ['@mid'] = m.id })
    Exec("DELETE FROM phone_discord_member_roles WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = m.identifier })
    local target = ESX.GetPlayerFromIdentifier(m.identifier)
    if target then TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', target.source, { text = "You were banned from " .. tostring(srv.name) .. ".", kind = "error" }) end
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, members = true })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:UnbanMember', function(source, cb, serverId, identifierOrRow)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    if type(identifierOrRow) ~= "string" then cb(false) return end
    Exec("DELETE FROM phone_discord_server_bans WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifierOrRow })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetServerBans', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local out = {}
    for _, b in ipairs(Q("SELECT identifier, name, reason, banned_by, created_at FROM phone_discord_server_bans WHERE server_id = @s ORDER BY created_at DESC LIMIT 100", { ['@s'] = serverId })) do
        out[#out + 1] = { identifier = b.identifier, name = b.name, reason = b.reason, by = b.banned_by, at = b.created_at }
    end
    cb(out)
end)

-- banned people cannot join through any door: public, VIP or invite
do
    local function serverFromInvite(code)
        code = string.upper((tostring(code or ""):gsub("%s+", "")))
        local s = Q("SELECT id FROM phone_discord_servers WHERE invite_code = @c", { ['@c'] = code })[1]
        if s then return s.id end
        local inv = Q("SELECT server_id FROM phone_discord_invites WHERE code = @c", { ['@c'] = code })[1]
        if inv then return inv.server_id end
        local v = Q("SELECT id FROM phone_discord_servers WHERE vanity = @v", { ['@v'] = string.lower(tostring(code)) })[1]
        return v and v.id or nil
    end
    local guard = {
        { 'Unique_Phone:server:Discord:JoinPublicServer', function(a) return tonumber(a[1]) end },
        { 'Unique_Phone:server:Discord:JoinVIPServer',   function(a) return tonumber(a[1]) end },
        { 'Unique_Phone:server:Discord:JoinServer',      function(a) return serverFromInvite(a[1]) end },
    }
    for _, g in ipairs(guard) do
        local name, serverOf = g[1], g[2]
        local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
        if orig then
            ESX.ServerCallbacks[name] = function(source, cb, ...)
                local args = { ... }
                local xPlayer = Discord_GetPlayer(source)
                local sid = serverOf(args)
                if xPlayer and sid and bannedHere(xPlayer.identifier, sid) then
                    cb({ error = "BANNED" }) return
                end
                return orig(source, cb, ...)
            end
        end
    end
end
