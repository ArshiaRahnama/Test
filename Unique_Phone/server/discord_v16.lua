-- ==========================================================================
-- Discord app v16 — channel templates (built-in + your own) and featured
-- messages (starred by staff). Loaded after discord_v15.lua.
-- ==========================================================================
local BUILTIN_TEMPLATES = {
    briefing = { name = "briefing", topic = "Official briefings", kind = "text", locked = true,  label = "Briefing (read-only)" },
    event    = { name = "event",    topic = "Event chat",         kind = "text", locked = false, label = "Event chat" },
    stage    = { name = "stage",    topic = "Event chat (text only)", kind = "stage", locked = false, label = "Stage event" },
}
local MAX_CHANNELS = 50

local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end
local function cleanName(s)
    s = tostring(s or ""):gsub("[%c]", " "):gsub("^%s+", ""):gsub("%s+$", "")
    s = Discord_Utf8SafeSub(s, 30):lower():gsub("%s+", "-")
    return s
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetChannelTemplates', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local out = {}
    for key, t in pairs(BUILTIN_TEMPLATES) do out[#out + 1] = { key = key, label = t.label, kind = t.kind, locked = t.locked, custom = false } end
    table.sort(out, function(a, b) return a.key < b.key end)
    for _, r in ipairs(Q("SELECT id, name, kind, is_locked FROM phone_discord_channel_templates WHERE server_id = @s ORDER BY id", { ['@s'] = serverId })) do
        out[#out + 1] = { key = "c" .. r.id, label = r.name .. " (saved)", kind = r.kind, locked = r.is_locked == 1, custom = true, templateId = r.id }
    end
    cb(out)
end)

-- create a channel from a template; name optional (defaults to the template name)
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateChannelFromTemplate', function(source, cb, serverId, key, name)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local count = Q("SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = @s", { ['@s'] = serverId })[1].c
    if count >= MAX_CHANNELS then cb({ error = "LIMIT" }) return end
    local tpl
    if BUILTIN_TEMPLATES[key] then tpl = BUILTIN_TEMPLATES[key]
    else
        local id = tonumber(tostring(key or ""):match("^c(%d+)$"))
        local r = id and Q("SELECT name, topic, kind, is_locked FROM phone_discord_channel_templates WHERE id = @i AND server_id = @s", { ['@i'] = id, ['@s'] = serverId })[1]
        if r then tpl = { name = r.name, topic = r.topic, kind = r.kind, locked = r.is_locked == 1 } end
    end
    if not tpl then cb({ error = "BAD_TEMPLATE" }) return end
    local chName = cleanName(name ~= nil and name ~= "" and name or tpl.name)
    if chName == "" then cb({ error = "BAD_NAME" }) return end
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at, is_locked, kind, topic) VALUES (@s, @n, @p, @t, @l, @k, @tp)", {
        ['@s'] = serverId, ['@n'] = chName, ['@p'] = count, ['@t'] = os.time(), ['@l'] = tpl.locked and 1 or 0, ['@k'] = tpl.kind, ['@tp'] = tpl.topic,
    })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, channels = true })
    cb({ ok = true, id = id, name = chName })
end)

-- save an existing channel's name / topic / type as a reusable template
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SaveChannelTemplate', function(source, cb, channelId)
    local xPlayer = Discord_GetPlayer(source)
    local ch = Q("SELECT id, server_id, name, topic, kind, is_locked FROM phone_discord_channels WHERE id = @c", { ['@c'] = tonumber(channelId) or 0 })[1]
    if not xPlayer or not ch or not Discord_CanManageChannels(xPlayer.identifier, ch.server_id) then cb(false) return end
    local n = Q("SELECT COUNT(*) AS c FROM phone_discord_channel_templates WHERE server_id = @s", { ['@s'] = ch.server_id })[1].c
    if n >= 10 then cb({ error = "LIMIT" }) return end
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_channel_templates (server_id, name, topic, kind, is_locked, created_by, created_at) VALUES (@s, @n, @t, @k, @l, @b, @c)", {
        ['@s'] = ch.server_id, ['@n'] = Discord_Utf8SafeSub(ch.name, 40), ['@t'] = ch.topic, ['@k'] = ch.kind or "text",
        ['@l'] = (ch.is_locked == 1 or ch.is_locked == true) and 1 or 0, ['@b'] = xPlayer.identifier, ['@c'] = os.time(),
    })
    cb({ ok = true, id = id })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteChannelTemplate', function(source, cb, templateId)
    local xPlayer = Discord_GetPlayer(source)
    local t = Q("SELECT id, server_id FROM phone_discord_channel_templates WHERE id = @i", { ['@i'] = tonumber(templateId) or 0 })[1]
    if not xPlayer or not t or not Discord_CanManageChannels(xPlayer.identifier, t.server_id) then cb(false) return end
    Exec("DELETE FROM phone_discord_channel_templates WHERE id = @i", { ['@i'] = t.id })
    cb({ ok = true })
end)

-- ==========================================================================
-- Featured messages (staff stars a message; everyone sees the star)
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ToggleFeatured', function(source, cb, messageId)
    local xPlayer = Discord_GetPlayer(source)
    local m = Q("SELECT m.id, m.is_featured, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = @m", { ['@m'] = tonumber(messageId) or 0 })[1]
    if not xPlayer or not m or not Discord_CanManageChannels(xPlayer.identifier, m.server_id) then cb(false) return end
    local on = not (m.is_featured == 1 or m.is_featured == true)
    Exec("UPDATE phone_discord_messages SET is_featured = @f WHERE id = @m", { ['@f'] = on and 1 or 0, ['@m'] = m.id })
    Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = m.server_id, featured = m.id, on = on })
    cb({ ok = true, featured = on })
end)
