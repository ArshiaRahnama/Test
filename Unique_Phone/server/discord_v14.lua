-- ==========================================================================
-- Discord app v14 — server side. Loaded after discord_ext4.lua.
--  * channel order (drag & drop)            * announcement channels + follows
--  * server health (7 days)                 * mutual friends count
--  * punishment appeals + staff queue       * private staff notes
-- SQL: sql/discord_v14.sql. Client bridges: client/discord_ext.lua.
-- ==========================================================================

local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end
local function now() return os.time() end
local function isStr(v) return type(v) == "string" end
local function trim(s) return ((tostring(s or "")):gsub("^%s+", ""):gsub("%s+$", "")) end
local function clean(s, n) return Discord_Utf8SafeSub((trim((tostring(s or "")):gsub("[%c]", " "))), n) end
local function truthy(v) return v == 1 or v == true end
local function notify(src, text, kind)
    if src then TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', src, { text = text, kind = kind or "info" }) end
end
local function refresh(serverId, flags)
    flags = flags or {}; flags.serverId = serverId
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', flags)
end

local function serverOf(channelId)
    local r = Q("SELECT id, server_id, name, is_announcement FROM phone_discord_channels WHERE id = @c", { ['@c'] = tonumber(channelId) })[1]
    return r
end

-- ==========================================================================
-- 1) CHANNEL ORDER (drag & drop)
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetChannelOrder', function(source, cb, serverId, ids)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or type(ids) ~= "table" then cb(false) return end
    if not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb({ error = "NO_PERMISSION" }) return end
    local current = Q("SELECT id FROM phone_discord_channels WHERE server_id = @s", { ['@s'] = serverId })
    local known = {}
    for _, c in ipairs(current) do known[c.id] = true end
    if #ids ~= #current then cb({ error = "BAD_LIST" }) return end
    local seen = {}
    for _, id in ipairs(ids) do
        local n = tonumber(id)
        if not n or not known[n] or seen[n] then cb({ error = "BAD_LIST" }) return end
        seen[n] = true
    end
    for pos, id in ipairs(ids) do
        Exec("UPDATE phone_discord_channels SET position = @p WHERE id = @c", { ['@p'] = pos - 1, ['@c'] = tonumber(id) })
    end
    refresh(serverId, { channels = true })
    cb({ ok = true })
end)

-- ==========================================================================
-- 2) ANNOUNCEMENT CHANNELS + FOLLOWS
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetAnnouncementChannel', function(source, cb, channelId, on)
    local xPlayer = Discord_GetPlayer(source)
    local ch = serverOf(channelId)
    if not xPlayer or not ch then cb(false) return end
    if not Discord_CanManageChannels(xPlayer.identifier, ch.server_id) then cb({ error = "NO_PERMISSION" }) return end
    Exec("UPDATE phone_discord_channels SET is_announcement = @a WHERE id = @c", { ['@a'] = on == true and 1 or 0, ['@c'] = ch.id })
    refresh(ch.server_id, { channels = true })
    cb({ ok = true })
end)

-- announcement channels of PUBLIC servers, for the follow picker
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetAnnouncementChannels', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb({}) return end
    local rows = Q([[SELECT c.id, c.name, s.id AS server_id, s.name AS server_name
                     FROM phone_discord_channels c JOIN phone_discord_servers s ON s.id = c.server_id
                     WHERE c.is_announcement = 1 AND s.is_public = 1 ORDER BY s.name, c.position]], {})
    local out = {}
    for _, r in ipairs(rows) do
        out[#out + 1] = { id = r.id, name = r.name, serverId = r.server_id, serverName = r.server_name }
    end
    cb(out)
end)

-- follow an announcement channel into one of MY channels (I must be admin there)
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:FollowChannel', function(source, cb, targetChannelId, sourceChannelId)
    local xPlayer = Discord_GetPlayer(source)
    local target = serverOf(targetChannelId)
    local src = serverOf(sourceChannelId)
    if not xPlayer or not target or not src then cb(false) return end
    if src.server_id == target.server_id then cb({ error = "SAME_SERVER" }) return end
    if not truthy(src.is_announcement) then cb({ error = "NOT_ANNOUNCEMENT" }) return end
    local srvPublic = Q("SELECT is_public FROM phone_discord_servers WHERE id = @s", { ['@s'] = src.server_id })[1]
    if not srvPublic or not truthy(srvPublic.is_public) then cb({ error = "NOT_PUBLIC" }) return end
    if not Discord_CanManageChannels(xPlayer.identifier, target.server_id) then cb({ error = "NO_PERMISSION" }) return end
    Exec("DELETE FROM phone_discord_follows WHERE target_channel_id = @t", { ['@t'] = target.id })
    Exec("INSERT INTO phone_discord_follows (source_channel_id, target_channel_id, created_by, created_at) VALUES (@s, @t, @b, @n)",
        { ['@s'] = src.id, ['@t'] = target.id, ['@b'] = xPlayer.identifier, ['@n'] = now() })
    refresh(target.server_id, { channels = true })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:UnfollowChannel', function(source, cb, targetChannelId)
    local xPlayer = Discord_GetPlayer(source)
    local target = serverOf(targetChannelId)
    if not xPlayer or not target then cb(false) return end
    if not Discord_CanManageChannels(xPlayer.identifier, target.server_id) then cb({ error = "NO_PERMISSION" }) return end
    Exec("DELETE FROM phone_discord_follows WHERE target_channel_id = @t", { ['@t'] = target.id })
    refresh(target.server_id, { channels = true })
    cb({ ok = true })
end)

-- called by the send path (main.lua) after a normal message was stored
function Discord_ExtForwardFollows(sourceChannelId, sourceServerId, authorName, text, createdAt)
    local src = serverOf(sourceChannelId)
    if not src or not truthy(src.is_announcement) then return end
    local srcServer = Q("SELECT name FROM phone_discord_servers WHERE id = @s", { ['@s'] = sourceServerId })[1]
    local label = "📢 " .. (srcServer and srcServer.name or "Announcements")
    for _, f in ipairs(Q("SELECT target_channel_id FROM phone_discord_follows WHERE source_channel_id = @c", { ['@c'] = src.id })) do
        local t = serverOf(f.target_channel_id)
        if t then
            local id = MySQL.Sync.insert("INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at, is_announcement) VALUES (@c, 'follow', @n, @m, @t, 1)", {
                ['@c'] = t.id, ['@n'] = Discord_Utf8SafeSub(label .. " · " .. tostring(authorName), 40), ['@m'] = Discord_Utf8SafeSub(tostring(text), 1000), ['@t'] = createdAt,
            })
            Discord_BroadcastToServerMembers(t.server_id, 'Unique_Phone:client:Discord:NewMessage', {
                id = id, serverId = t.server_id, channelId = t.id, author_name = label .. " · " .. tostring(authorName),
                message = text, created_at = createdAt, isAnnouncement = true, authorVerified = true,
            })
        end
    end
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetFollows', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local rows = Q([[SELECT f.target_channel_id, c.name AS target_name, sc.name AS source_name, s.name AS source_server
                     FROM phone_discord_follows f
                     JOIN phone_discord_channels c ON c.id = f.target_channel_id
                     JOIN phone_discord_channels sc ON sc.id = f.source_channel_id
                     JOIN phone_discord_servers s ON s.id = sc.server_id
                     WHERE c.server_id = @s]], { ['@s'] = serverId })
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = { targetChannelId = r.target_channel_id, targetName = r.target_name, sourceName = r.source_name, sourceServer = r.source_server } end
    cb(out)
end)

-- ==========================================================================
-- 3) SERVER HEALTH (last 7 days, owner / admins)
-- ==========================================================================
local DAY = 86400

-- pure helpers (also unit-tested): hour-of-day histogram and per-day counts
function Discord_ExtHealthBuckets(timestamps, since, nowTs)
    local hours, days = {}, {}
    for h = 0, 23 do hours[h] = 0 end
    local ndays = math.max(1, math.floor((nowTs - since) / DAY) + 1)
    for d = 1, 7 do days[d] = 0 end
    for _, t in ipairs(timestamps) do
        t = tonumber(t)
        if t and t >= since and t <= nowTs then
            local h = os.date("*t", t).hour
            hours[h] = hours[h] + 1
            local idx = 7 - math.floor((nowTs - t) / DAY)
            if idx >= 1 and idx <= 7 then days[idx] = days[idx] + 1 end
        end
    end
    local hourList, dayList = {}, {}  -- ndays kept for callers that want the real window length
    for h = 0, 23 do hourList[#hourList + 1] = hours[h] end
    for d = 1, 7 do dayList[#dayList + 1] = days[d] end
    return hourList, dayList, ndays
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetHealth', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local t = now()
    local since = t - 7 * DAY
    local perChannel = Q([[SELECT c.id, c.name, COUNT(m.id) AS cnt FROM phone_discord_channels c
                           LEFT JOIN phone_discord_messages m ON m.channel_id = c.id AND m.created_at >= @since
                           WHERE c.server_id = @s GROUP BY c.id, c.name ORDER BY cnt DESC, c.position ASC]], { ['@s'] = serverId, ['@since'] = since })
    local stamps = {}
    for _, r in ipairs(Q([[SELECT m.created_at FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id
                           WHERE c.server_id = @s AND m.created_at >= @since ORDER BY m.created_at DESC LIMIT 20000]], { ['@s'] = serverId, ['@since'] = since })) do
        stamps[#stamps + 1] = r.created_at
    end
    local hours, days = Discord_ExtHealthBuckets(stamps, since, t)
    local members = Q("SELECT COUNT(*) AS c FROM phone_discord_members WHERE server_id = @s", { ['@s'] = serverId })[1].c
    local newMembers = Q("SELECT COUNT(*) AS c FROM phone_discord_members WHERE server_id = @s AND joined_at >= @since", { ['@s'] = serverId, ['@since'] = since })[1].c
    local channels = {}
    local total = 0
    for _, r in ipairs(perChannel) do channels[#channels + 1] = { id = r.id, name = r.name, count = r.cnt }; total = total + r.cnt end
    cb({ channels = channels, hours = hours, days = days, totalMessages = total, totalMembers = members, newMembers = newMembers, windowDays = 7 })
end)

-- ==========================================================================
-- 4) MUTUAL FRIENDS COUNT (for a profile card)
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMutualFriends', function(source, cb, uid)
    local xPlayer = Discord_GetPlayer(source)
    uid = tonumber(uid)
    if not xPlayer or not uid then cb({ count = 0 }) return end
    local other = Q("SELECT identifier FROM phone_discord_profiles WHERE uid = @u", { ['@u'] = uid })[1]
    if not other or other.identifier == xPlayer.identifier then cb({ count = 0 }) return end
    local function friendsOf(id)
        local set = {}
        for _, f in ipairs(Q("SELECT user_low, user_high FROM phone_discord_friends WHERE status = 'accepted' AND (user_low = @i OR user_high = @i)", { ['@i'] = id })) do
            set[f.user_low == id and f.user_high or f.user_low] = true
        end
        return set
    end
    local mine, theirs = friendsOf(xPlayer.identifier), friendsOf(other.identifier)
    local n = 0
    for id in pairs(mine) do if theirs[id] then n = n + 1 end end
    cb({ count = n })
end)

-- ==========================================================================
-- 5) PUNISHMENT APPEALS
-- ==========================================================================
local function activeTimeout(serverId, identifier)
    local t = Q("SELECT until_at FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })[1]
    if t and tonumber(t.until_at) > now() then return t end
    return nil
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMyPunishments', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    local warns = {}
    for _, w in ipairs(Q("SELECT id, reason, created_at FROM phone_discord_warns WHERE server_id = @s AND identifier = @i ORDER BY id DESC LIMIT 20", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })) do
        warns[#warns + 1] = { id = w.id, reason = w.reason, createdAt = w.created_at }
    end
    local t = activeTimeout(serverId, xPlayer.identifier)
    local pend = Q("SELECT kind, ref_id FROM phone_discord_appeals WHERE server_id = @s AND identifier = @i AND status = 'pending'", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })
    cb({ timeoutUntil = t and tonumber(t.until_at) or nil, warns = warns, pending = pend })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SubmitAppeal', function(source, cb, serverId, kind, warnId, text)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    if kind ~= "timeout" and kind ~= "warn" then cb({ error = "BAD_KIND" }) return end
    text = clean(text, 500)
    if #text < 10 then cb({ error = "TOO_SHORT" }) return end
    local ref = 0
    if kind == "timeout" then
        if not activeTimeout(serverId, xPlayer.identifier) then cb({ error = "NO_PUNISHMENT" }) return end
    else
        ref = tonumber(warnId) or 0
        local w = Q("SELECT id FROM phone_discord_warns WHERE id = @w AND server_id = @s AND identifier = @i", { ['@w'] = ref, ['@s'] = serverId, ['@i'] = xPlayer.identifier })[1]
        if not w then cb({ error = "NO_PUNISHMENT" }) return end
    end
    if Q("SELECT id FROM phone_discord_appeals WHERE server_id = @s AND identifier = @i AND kind = @k AND ref_id = @r AND status = 'pending'",
         { ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@k'] = kind, ['@r'] = ref })[1] then cb({ error = "ALREADY_PENDING" }) return end
    Exec("INSERT INTO phone_discord_appeals (server_id, identifier, kind, ref_id, text, status, created_at) VALUES (@s, @i, @k, @r, @t, 'pending', @n)",
        { ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@k'] = kind, ['@r'] = ref, ['@t'] = text, ['@n'] = now() })
    for _, pid in ipairs(GetPlayers()) do
        local p = ESX.GetPlayerFromId(tonumber(pid))
        if p and Discord_CanManageChannels(p.identifier, serverId) then notify(p.source, "New appeal in Discord (" .. kind .. ").", "warn") end
    end
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetAppeals', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local rows = Q([[SELECT a.id, a.identifier, a.kind, a.ref_id, a.text, a.created_at, m.nickname
                     FROM phone_discord_appeals a LEFT JOIN phone_discord_members m ON m.server_id = a.server_id AND m.identifier = a.identifier
                     WHERE a.server_id = @s AND a.status = 'pending' ORDER BY a.id ASC LIMIT 100]], { ['@s'] = serverId })
    local out = {}
    for _, r in ipairs(rows) do
        local reason = ""
        if r.kind == "timeout" then
            local t = Q("SELECT reason FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = r.identifier })[1]
            reason = t and t.reason or ""
        else
            local w = Q("SELECT reason FROM phone_discord_warns WHERE id = @w", { ['@w'] = r.ref_id })[1]
            reason = w and w.reason or ""
        end
        out[#out + 1] = { id = r.id, name = r.nickname or "Member", kind = r.kind, text = r.text, reason = reason, createdAt = r.created_at }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ResolveAppeal', function(source, cb, appealId, accept)
    local xPlayer = Discord_GetPlayer(source)
    local a = Q("SELECT * FROM phone_discord_appeals WHERE id = @a", { ['@a'] = tonumber(appealId) or 0 })[1]
    if not xPlayer or not a or a.status ~= "pending" or not Discord_CanManageChannels(xPlayer.identifier, a.server_id) then cb(false) return end
    local by = Discord_GetDisplayName(source)
    if accept == true then
        if a.kind == "timeout" then
            Exec("DELETE FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = a.server_id, ['@i'] = a.identifier })
        else
            Exec("DELETE FROM phone_discord_warns WHERE id = @w", { ['@w'] = a.ref_id })
        end
    end
    Exec("UPDATE phone_discord_appeals SET status = @st, handled_by = @b, handled_at = @t WHERE id = @a",
        { ['@st'] = accept == true and "accepted" or "denied", ['@b'] = by, ['@t'] = now(), ['@a'] = a.id })
    local target = ESX.GetPlayerFromIdentifier(a.identifier)
    if target then notify(target.source, "Your appeal was " .. (accept == true and "accepted" or "declined") .. ".", accept == true and "success" or "warn") end
    cb({ ok = true })
end)

-- ==========================================================================
-- 6) PRIVATE STAFF NOTES (owner / admins only)
-- ==========================================================================
local function staffOnly(xPlayer, serverId)
    return xPlayer and serverId and Discord_CanManageChannels(xPlayer.identifier, serverId)
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetStaffNotes', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not staffOnly(xPlayer, serverId) then cb(false) return end
    local m = Q("SELECT identifier FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = tonumber(memberRowId) or 0, ['@s'] = serverId })[1]
    if not m then cb(false) return end
    local out = {}
    for _, n in ipairs(Q("SELECT id, author_identifier, author_name, text, created_at FROM phone_discord_staff_notes WHERE server_id = @s AND target_identifier = @t ORDER BY id DESC LIMIT 50", { ['@s'] = serverId, ['@t'] = m.identifier })) do
        out[#out + 1] = { id = n.id, author = n.author_name, text = n.text, createdAt = n.created_at, mine = n.author_identifier == xPlayer.identifier }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddStaffNote', function(source, cb, serverId, memberRowId, text)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not staffOnly(xPlayer, serverId) then cb(false) return end
    local m = Q("SELECT identifier FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = tonumber(memberRowId) or 0, ['@s'] = serverId })[1]
    text = clean(text, 500)
    if not m or #text < 2 then cb(false) return end
    Exec("INSERT INTO phone_discord_staff_notes (server_id, target_identifier, author_identifier, author_name, text, created_at) VALUES (@s, @t, @a, @n, @x, @c)",
        { ['@s'] = serverId, ['@t'] = m.identifier, ['@a'] = xPlayer.identifier, ['@n'] = Discord_GetDisplayName(source), ['@x'] = text, ['@c'] = now() })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteStaffNote', function(source, cb, noteId)
    local xPlayer = Discord_GetPlayer(source)
    local n = Q("SELECT id, server_id, author_identifier FROM phone_discord_staff_notes WHERE id = @n", { ['@n'] = tonumber(noteId) or 0 })[1]
    if not xPlayer or not n or not staffOnly(xPlayer, n.server_id) then cb(false) return end
    if n.author_identifier ~= xPlayer.identifier and not Discord_IsOwner(xPlayer.identifier, n.server_id) then cb(false) return end
    Exec("DELETE FROM phone_discord_staff_notes WHERE id = @n", { ['@n'] = n.id })
    cb({ ok = true })
end)
