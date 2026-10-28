-- ==========================================================================
-- Discord app v27 — (10) private role channels, (11) super reactions. Loaded LAST.
-- Private channel = @everyone is denied "view" on that channel and the chosen roles
-- are allowed "view" (the existing permission engine does the rest).
-- Super reaction = one per person per message, shown separately with a burst.
-- ==========================================================================
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end

local function jsonList(list)
    if #list == 0 then return "[]" end
    local out = {}
    for _, v in ipairs(list) do out[#out + 1] = '"' .. v .. '"' end
    return "[" .. table.concat(out, ",") .. "]"
end
local function listHas(json, word) return string.find(json or "[]", '"' .. word .. '"', 1, true) ~= nil end

local function defaultRoleId(serverId)
    local r = Q("SELECT id FROM phone_discord_roles WHERE server_id = @s AND is_default = 1 ORDER BY id ASC LIMIT 1", { ['@s'] = serverId })[1]
    return r and r.id or nil
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetChannelPrivate', function(source, cb, serverId, channelId, roleIds, on)
    local xPlayer = Discord_GetPlayer(source)
    serverId, channelId = tonumber(serverId), tonumber(channelId)
    if not xPlayer or not serverId or not channelId then cb(false) return end
    if not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb({ error = "NO_PERMISSION" }) return end
    local ch = Q("SELECT id FROM phone_discord_channels WHERE id = @c AND server_id = @s", { ['@c'] = channelId, ['@s'] = serverId })[1]
    local everyone = defaultRoleId(serverId)
    if not ch or not everyone then cb(false) return end

    -- @everyone: deny view while private, remove that deny when public again
    local ev = Q("SELECT allow, deny FROM phone_discord_channel_perms WHERE channel_id = @c AND role_id = @r", { ['@c'] = channelId, ['@r'] = everyone })[1]
    local evAllow = ev and ev.allow or "[]"
    local evDeny = ev and ev.deny or "[]"
    if on == true then
        if not listHas(evDeny, "view") then evDeny = '["view"]' end
    else
        evDeny = "[]"
    end
    if evAllow == "[]" and evDeny == "[]" then
        Exec("DELETE FROM phone_discord_channel_perms WHERE channel_id = @c AND role_id = @r", { ['@c'] = channelId, ['@r'] = everyone })
    else
        Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, @a, @d)", { ['@c'] = channelId, ['@r'] = everyone, ['@a'] = evAllow, ['@d'] = evDeny })
    end

    -- the chosen roles may view it
    if on == true and type(roleIds) == "table" then
        for _, rid in ipairs(roleIds) do
            local role = tonumber(rid)
            if role and role ~= everyone then
                local row = Q("SELECT allow, deny FROM phone_discord_channel_perms WHERE channel_id = @c AND role_id = @r", { ['@c'] = channelId, ['@r'] = role })[1]
                local allow = row and row.allow or "[]"
                if not listHas(allow, "view") then allow = (allow == "[]") and '["view"]' or allow:gsub("%]$", ',"view"]') end
                Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, @a, @d)",
                    { ['@c'] = channelId, ['@r'] = role, ['@a'] = allow, ['@d'] = row and row.deny or "[]" })
            end
        end
    end
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, channels = true })
    cb({ ok = true })
end)

-- ---- super reactions ------------------------------------------------------------
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SuperReact', function(source, cb, messageId, emoji)
    local xPlayer = Discord_GetPlayer(source)
    messageId = tonumber(messageId)
    if not xPlayer or not messageId or not Discord_ExtIsEmoji(emoji) then cb(false) return end
    local m = Q("SELECT m.id, m.channel_id, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = @m", { ['@m'] = messageId })[1]
    if not m or not Discord_IsMember(xPlayer.identifier, m.server_id) then cb(false) return end
    -- one super reaction per person per message: the same emoji again removes it, another emoji is refused
    local mine = Q("SELECT id, emoji FROM phone_discord_reactions WHERE message_id = @m AND identifier = @i AND is_super = 1", { ['@m'] = messageId, ['@i'] = xPlayer.identifier })[1]
    if mine then
        Exec("DELETE FROM phone_discord_reactions WHERE id = @id", { ['@id'] = mine.id })
        if mine.emoji == emoji then cb({ ok = true, removed = true }) return end
        Exec("INSERT INTO phone_discord_reactions (message_id, identifier, emoji, created_at, is_super) VALUES (@m, @i, @e, @t, 1)",
            { ['@m'] = messageId, ['@i'] = xPlayer.identifier, ['@e'] = emoji, ['@t'] = os.time() })
        Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:Discord:ReactionsChanged', { serverId = m.server_id, messageId = messageId })
        cb({ ok = true, super = true }) return
    end
    Exec("INSERT INTO phone_discord_reactions (message_id, identifier, emoji, created_at, is_super) VALUES (@m, @i, @e, @t, 1)",
        { ['@m'] = messageId, ['@i'] = xPlayer.identifier, ['@e'] = emoji, ['@t'] = os.time() })
    Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:Discord:ReactionsChanged', { serverId = m.server_id, messageId = messageId })
    cb({ ok = true, super = true })
end)
