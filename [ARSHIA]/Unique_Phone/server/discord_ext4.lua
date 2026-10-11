-- ==========================================================================
-- Discord app v11 — server side (loaded AFTER discord_ext3.lua).
--   * avatars + server icons (https image URLs, or pick from the phone Gallery)
--   * friends (request / accept / decline / remove) and blocking
--   * direct messages between accepted friends
--   * uploaded (image) server emoji, used as :name:
-- SQL: sql/discord_v11.sql   Config: Config.DiscordExt.Media / .Social
-- ==========================================================================

local function cfg() return Config.DiscordExt end
local function Q(sql, params) return ExecuteSql(true, sql, params or {}) end
local function Exec(sql, params) return MySQL.Sync.execute(sql, params or {}) end
local function nowTs() return os.time() end
local function isStr(v) return type(v) == "string" end
local function truthy(v) return v == 1 or v == true end
local function trim(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
local function clean(s, maxLen) return Discord_Utf8SafeSub(trim((tostring(s or ""):gsub("[%c]", " "))), maxLen) end

local function notify(src, text, kind)
    TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', src, { text = text, kind = kind or "info" })
end

-- --------------------------------------------------------------------------
-- Media URL validation (avatars / icons / emoji)
-- --------------------------------------------------------------------------

function Discord_ExtValidMediaUrl(url)
    if not isStr(url) then return false end
    local M = cfg().Media or {}
    if #url < 12 or #url > (M.MaxUrlLength or 400) then return false end
    if not url:match("^https://[%w%-%.]+[/%w%-%._~:%?#%[%]@!%$&%(%)%*%+,;=%%]*$") then return false end
    local host = url:match("^https://([^/%?#:]+)")
    if not host or not host:find("%.") then return false end
    host = host:lower()
    if host:match("^%d+%.%d+%.%d+%.%d+$") or host == "localhost" then return false end
    local allowed = M.AllowedHosts or {}
    if #allowed > 0 then
        local ok = false
        for _, h in ipairs(allowed) do
            h = tostring(h):lower()
            if host == h or host:sub(-(#h + 1)) == "." .. h then ok = true break end
        end
        if not ok then return false end
    end
    return true
end

-- --------------------------------------------------------------------------
-- Identity helpers
-- --------------------------------------------------------------------------

local function discordUser(source)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then return nil end
    if Q("SELECT 1 AS x FROM phone_discord_accounts WHERE identifier = @i AND logged_in = 1", { ['@i'] = xPlayer.identifier })[1] == nil then return nil end
    return xPlayer
end

local function pairOf(a, b)
    if a < b then return a, b end
    return b, a
end

local function profileOf(identifier)
    return Discord_EnsureProfile(identifier)
end

-- identifier -> { uid, name, tag, status, avatar, activity }; one batch query for the names
local function cardsFor(identifiers)
    local out = {}
    if #identifiers == 0 then return out end
    local params, holders = {}, {}
    for i, id in ipairs(identifiers) do
        params['@i' .. i] = id
        holders[#holders + 1] = '@i' .. i
    end
    local inList = table.concat(holders, ",")
    local names = {}
    for _, u in ipairs(Q("SELECT identifier, firstname, lastname FROM users WHERE identifier IN (" .. inList .. ")", params)) do
        names[u.identifier] = trim((u.firstname or "") .. " " .. (u.lastname or ""))
    end
    local profiles = {}
    for _, p in ipairs(Q("SELECT identifier, uid, discriminator, status, avatar_url, custom_status FROM phone_discord_profiles WHERE identifier IN (" .. inList .. ")", params)) do
        profiles[p.identifier] = p
    end
    for _, id in ipairs(identifiers) do
        local p = profiles[id] or profileOf(id)
        local name = names[id]
        local online = ESX.GetPlayerFromIdentifier(id)
        if (not name or name == "") and online then name = Discord_GetDisplayName(online.source) end
        if not name or name == "" then name = "Player" end
        local status = "offline"
        if online and p.status and p.status ~= "invisible" then status = p.status end
        out[id] = {
            uid = p.uid, name = name, discriminator = p.discriminator, avatar = p.avatar_url, status = status,
            customStatus = (status ~= "offline") and p.custom_status or nil,
            activity = online and Discord_GetActivity(id) or nil,
        }
    end
    return out
end

local function identifierByUid(uid)
    uid = tonumber(uid)
    if not uid then return nil end
    local r = Q("SELECT identifier FROM phone_discord_profiles WHERE uid = @u", { ['@u'] = uid })[1]
    return r and r.identifier or nil
end

local function isBlockedEither(a, b)
    return Q("SELECT 1 AS x FROM phone_discord_blocks WHERE (blocker = @a AND blocked = @b) OR (blocker = @b AND blocked = @a) LIMIT 1", { ['@a'] = a, ['@b'] = b })[1] ~= nil
end

local function friendRow(a, b)
    local low, high = pairOf(a, b)
    return Q("SELECT * FROM phone_discord_friends WHERE user_low = @l AND user_high = @h", { ['@l'] = low, ['@h'] = high })[1], low, high
end

local function socialChanged(identifier, kind)
    local p = ESX.GetPlayerFromIdentifier(identifier)
    if p then TriggerClientEvent('Unique_Phone:client:DiscordExt:SocialChanged', p.source, { kind = kind }) end
end

-- --------------------------------------------------------------------------
-- Avatars + server icons
-- --------------------------------------------------------------------------

local function broadcastAvatar(identifier)
    for _, m in ipairs(Q("SELECT server_id FROM phone_discord_members WHERE identifier = @i", { ['@i'] = identifier })) do
        Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = m.server_id, members = true, meta = true })
    end
    for _, f in ipairs(Q("SELECT user_low, user_high FROM phone_discord_friends WHERE status = 'accepted' AND (user_low = @i OR user_high = @i)", { ['@i'] = identifier })) do
        socialChanged(f.user_low == identifier and f.user_high or f.user_low, "avatar")
    end
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMyDiscord', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb(false) return end
    local p = profileOf(xPlayer.identifier)
    cb({ uid = p.uid, avatar = p.avatar_url, discriminator = p.discriminator, name = Discord_GetDisplayName(source) })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetAvatar', function(source, cb, url)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb(false) return end
    url = trim(url)
    if url == "" then
        profileOf(xPlayer.identifier)
        Exec("UPDATE phone_discord_profiles SET avatar_url = NULL WHERE identifier = @i", { ['@i'] = xPlayer.identifier })
    else
        if not Discord_ExtValidMediaUrl(url) then cb({ error = "BAD_URL" }) return end
        profileOf(xPlayer.identifier)
        Exec("UPDATE phone_discord_profiles SET avatar_url = @u WHERE identifier = @i", { ['@u'] = url, ['@i'] = xPlayer.identifier })
    end
    broadcastAvatar(xPlayer.identifier)
    cb({ ok = true, avatar = url ~= "" and url or nil })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetGalleryImages', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb({}) return end
    local limit = math.floor(tonumber((cfg().Media or {}).GalleryPickerLimit) or 40)
    local rows = Q("SELECT image_url FROM phone_gallery WHERE identifier = @i ORDER BY id DESC LIMIT " .. limit, { ['@i'] = xPlayer.identifier })
    local out = {}
    for _, r in ipairs(rows) do if Discord_ExtValidMediaUrl(r.image_url) then out[#out + 1] = r.image_url end end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetServerIcon', function(source, cb, serverId, url)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer or not tonumber(serverId) then cb(false) return end
    if not (Discord_IsOwner(xPlayer.identifier, serverId) or Discord_ExtCan(xPlayer.identifier, serverId, 'manage_server')) then cb(false) return end
    url = trim(url)
    if url ~= "" and not Discord_ExtValidMediaUrl(url) then cb({ error = "BAD_URL" }) return end
    Exec("UPDATE phone_discord_servers SET icon_url = @u WHERE id = @s", { ['@u'] = url ~= "" and url or nil, ['@s'] = serverId })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId })
    cb({ ok = true })
end)

-- member row id -> { avatar, uid } for the member meta
function Discord_ExtProfileMap(serverId)
    local out = {}
    for _, r in ipairs(Q([[SELECT m.identifier, p.avatar_url, p.uid FROM phone_discord_members m
                           LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = @s]], { ['@s'] = serverId })) do
        out[r.identifier] = { avatar = r.avatar_url, uid = r.uid }
    end
    return out
end

-- --------------------------------------------------------------------------
-- Uploaded (image) emoji
-- --------------------------------------------------------------------------

function Discord_ExtImageEmojis(serverId)
    local out = {}
    for _, r in ipairs(Q("SELECT name, url FROM phone_discord_custom_emoji WHERE server_id = @s ORDER BY id", { ['@s'] = serverId })) do out[#out + 1] = { name = r.name, url = r.url } end
    return out
end

function Discord_ExtImageEmojiCount(serverId)
    return (Q("SELECT COUNT(*) AS c FROM phone_discord_custom_emoji WHERE server_id = @s", { ['@s'] = serverId })[1] or {}).c or 0
end

function Discord_ExtImageEmojiAllowed(serverId, token)
    if not isStr(token) then return false end
    local name = token:match("^:([%w_]+):$")
    if not name then return false end
    return Q("SELECT 1 AS x FROM phone_discord_custom_emoji WHERE server_id = @s AND name = @n", { ['@s'] = serverId, ['@n'] = name })[1] ~= nil
end

local function emojiSlots(serverId)
    local total = (Q("SELECT COUNT(*) AS c FROM phone_discord_boosts WHERE server_id = @s AND expires_at > @now", { ['@s'] = serverId, ['@now'] = nowTs() })[1] or {}).c or 0
    local B = cfg().Boost
    local slots = B.BaseEmojiSlots or 0
    for _, L in ipairs(B.Levels or {}) do if total >= L.boosts then slots = L.emojiSlots end end
    return slots
end

local function emojiManager(source, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer or not tonumber(serverId) then return nil end
    if Discord_IsOwner(xPlayer.identifier, serverId) or Discord_ExtCan(xPlayer.identifier, serverId, 'manage_server') then return xPlayer end
    return nil
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddImageEmoji', function(source, cb, serverId, name, url)
    local xPlayer = emojiManager(source, serverId)
    if not xPlayer then cb(false) return end
    name = trim(name):lower()
    url = trim(url)
    if not name:match("^[a-z0-9_]+$") or #name < 2 or #name > 12 then cb({ error = "BAD_NAME" }) return end
    if not Discord_ExtValidMediaUrl(url) then cb({ error = "BAD_URL" }) return end
    local used = Discord_ExtImageEmojiCount(serverId) + #(Q("SELECT emoji FROM phone_discord_emojis WHERE server_id = @s", { ['@s'] = serverId }))
    if used >= emojiSlots(serverId) then cb({ error = "NO_SLOTS" }) return end
    if Q("SELECT 1 AS x FROM phone_discord_custom_emoji WHERE server_id = @s AND name = @n", { ['@s'] = serverId, ['@n'] = name })[1] then cb({ error = "TAKEN" }) return end
    MySQL.Sync.insert("INSERT INTO phone_discord_custom_emoji (server_id, name, url, created_by, created_at) VALUES (@s, @n, @u, @c, @t)", {
        ['@s'] = serverId, ['@n'] = name, ['@u'] = url, ['@c'] = xPlayer.identifier, ['@t'] = nowTs(),
    })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RemoveImageEmoji', function(source, cb, serverId, name)
    if not emojiManager(source, serverId) or not isStr(name) then cb(false) return end
    Exec("DELETE FROM phone_discord_custom_emoji WHERE server_id = @s AND name = @n", { ['@s'] = serverId, ['@n'] = name })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId })
    cb(true)
end)

-- --------------------------------------------------------------------------
-- Friends + blocks
-- --------------------------------------------------------------------------

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetSocial', function(source, cb)
    local xPlayer = discordUser(source)
    if not xPlayer then cb(false) return end
    local me = xPlayer.identifier
    local mine = profileOf(me)

    local friendIds, incoming, outgoing, accepted = {}, {}, {}, {}
    for _, f in ipairs(Q("SELECT user_low, user_high, requester, status FROM phone_discord_friends WHERE user_low = @i OR user_high = @i", { ['@i'] = me })) do
        local other = f.user_low == me and f.user_high or f.user_low
        friendIds[#friendIds + 1] = other
        if f.status == 'accepted' then accepted[other] = true
        elseif f.requester == me then outgoing[#outgoing + 1] = other
        else incoming[#incoming + 1] = other end
    end
    local blockedIds = {}
    for _, b in ipairs(Q("SELECT blocked FROM phone_discord_blocks WHERE blocker = @i", { ['@i'] = me })) do blockedIds[#blockedIds + 1] = b.blocked; friendIds[#friendIds + 1] = b.blocked end

    local dmRows = Q([[SELECT d.id, d.user_low, d.user_high, d.last_at,
                           (SELECT m.message FROM phone_discord_dm_messages m WHERE m.dm_id = d.id ORDER BY m.id DESC LIMIT 1) AS last_message,
                           (SELECT m.identifier FROM phone_discord_dm_messages m WHERE m.dm_id = d.id ORDER BY m.id DESC LIMIT 1) AS last_by,
                           (SELECT COUNT(*) FROM phone_discord_dm_messages m
                              WHERE m.dm_id = d.id AND m.identifier <> @i AND m.id > COALESCE((SELECT s.last_id FROM phone_discord_dm_seen s WHERE s.dm_id = d.id AND s.identifier = @i), 0)) AS unread
                       FROM phone_discord_dms d WHERE (d.user_low = @i OR d.user_high = @i) AND d.last_at > 0 ORDER BY d.last_at DESC LIMIT 60]], { ['@i'] = me })
    for _, d in ipairs(dmRows) do friendIds[#friendIds + 1] = d.user_low == me and d.user_high or d.user_low end

    -- de-duplicate
    local seen, ids = {}, {}
    for _, id in ipairs(friendIds) do if not seen[id] then seen[id] = true; ids[#ids + 1] = id end end
    local cards = cardsFor(ids)

    local friends, inc, out, blocked, dms, dmUnread = {}, {}, {}, {}, {}, 0
    for id in pairs(accepted) do friends[#friends + 1] = cards[id] end
    table.sort(friends, function(a, b) return a.name:lower() < b.name:lower() end)
    for _, id in ipairs(incoming) do inc[#inc + 1] = cards[id] end
    for _, id in ipairs(outgoing) do out[#out + 1] = cards[id] end
    for _, id in ipairs(blockedIds) do blocked[#blocked + 1] = cards[id] end
    for _, d in ipairs(dmRows) do
        local other = d.user_low == me and d.user_high or d.user_low
        local unread = tonumber(d.unread) or 0
        dmUnread = dmUnread + unread
        dms[#dms + 1] = { id = d.id, user = cards[other], lastMessage = d.last_message and Discord_Utf8SafeSub(d.last_message, 60) or "", lastMine = d.last_by == me, lastAt = d.last_at, unread = unread,
                          canSend = accepted[other] == true }
    end
    cb({ me = { uid = mine.uid, avatar = mine.avatar_url, discriminator = mine.discriminator }, friends = friends, incoming = inc, outgoing = out, blocked = blocked, dms = dms, dmUnread = dmUnread })
end)

local function sendRequest(source, xPlayer, target)
    local me = xPlayer.identifier
    local S = cfg().Social or {}
    if target == me then return { error = "SELF" } end
    if Q("SELECT 1 AS x FROM phone_discord_accounts WHERE identifier = @i", { ['@i'] = target })[1] == nil then return { error = "NOT_FOUND" } end
    if isBlockedEither(me, target) then return { error = "NOT_FOUND" } end

    local row, low, high = friendRow(me, target)
    if row then
        if row.status == 'accepted' then return { error = "ALREADY" } end
        if row.requester == me then return { error = "PENDING" } end
        -- they already asked us: this is an accept
        Exec("UPDATE phone_discord_friends SET status = 'accepted' WHERE id = @id", { ['@id'] = row.id })
        socialChanged(target, "accepted")
        return { ok = true, status = "accepted" }
    end

    local count = (Q("SELECT COUNT(*) AS c FROM phone_discord_friends WHERE (user_low = @i OR user_high = @i) AND status = 'accepted'", { ['@i'] = me })[1] or {}).c or 0
    if count >= (S.MaxFriends or 150) then return { error = "LIMIT" } end
    local out = (Q("SELECT COUNT(*) AS c FROM phone_discord_friends WHERE requester = @i AND status = 'pending'", { ['@i'] = me })[1] or {}).c or 0
    if out >= (S.MaxPendingOut or 30) then return { error = "LIMIT_PENDING" } end

    MySQL.Sync.insert("INSERT INTO phone_discord_friends (user_low, user_high, requester, status, created_at) VALUES (@l, @h, @r, 'pending', @t)", {
        ['@l'] = low, ['@h'] = high, ['@r'] = me, ['@t'] = nowTs(),
    })
    local tp = ESX.GetPlayerFromIdentifier(target)
    if tp then
        notify(tp.source, Discord_GetDisplayName(source) .. " sent you a friend request.", "info")
        socialChanged(target, "request")
    end
    return { ok = true, status = "sent" }
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddFriendByTag', function(source, cb, tag)
    local xPlayer = discordUser(source)
    if not xPlayer then cb({ error = "NO_ACCOUNT" }) return end
    tag = trim(tag)
    local name, disc = tag:match("^(.-)%s*#%s*(%d%d%d%d)$")
    if not name or name == "" then cb({ error = "BAD_TAG" }) return end
    name = name:lower():gsub("%s+", "")
    local rows = Q([[SELECT p.identifier FROM phone_discord_profiles p
                     JOIN users u ON u.identifier = p.identifier
                     JOIN phone_discord_accounts a ON a.identifier = p.identifier
                     WHERE p.discriminator = @d AND LOWER(REPLACE(CONCAT(IFNULL(u.firstname, ''), IFNULL(u.lastname, '')), ' ', '')) = @n LIMIT 1]], { ['@d'] = disc, ['@n'] = name })
    if not rows[1] then cb({ error = "NOT_FOUND" }) return end
    local res = sendRequest(source, xPlayer, rows[1].identifier)
    socialChanged(xPlayer.identifier, "mine")
    cb(res)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddFriendByUid', function(source, cb, uid)
    local xPlayer = discordUser(source)
    if not xPlayer then cb({ error = "NO_ACCOUNT" }) return end
    local target = identifierByUid(uid)
    if not target then cb({ error = "NOT_FOUND" }) return end
    local res = sendRequest(source, xPlayer, target)
    cb(res)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RespondFriend', function(source, cb, uid, accept)
    local xPlayer = discordUser(source)
    local other = identifierByUid(uid)
    if not xPlayer or not other then cb(false) return end
    local row = friendRow(xPlayer.identifier, other)
    if not row or row.status ~= 'pending' or row.requester == xPlayer.identifier then cb(false) return end
    if accept == true then
        if isBlockedEither(xPlayer.identifier, other) then cb(false) return end
        Exec("UPDATE phone_discord_friends SET status = 'accepted' WHERE id = @id", { ['@id'] = row.id })
        local tp = ESX.GetPlayerFromIdentifier(other)
        if tp then notify(tp.source, Discord_GetDisplayName(source) .. " accepted your friend request.", "success") end
    else
        Exec("DELETE FROM phone_discord_friends WHERE id = @id", { ['@id'] = row.id })
    end
    socialChanged(other, accept == true and "accepted" or "declined")
    cb(true)
end)

-- cancel an outgoing request OR remove a friend
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RemoveFriend', function(source, cb, uid)
    local xPlayer = discordUser(source)
    local other = identifierByUid(uid)
    if not xPlayer or not other then cb(false) return end
    local row = friendRow(xPlayer.identifier, other)
    if not row then cb(false) return end
    Exec("DELETE FROM phone_discord_friends WHERE id = @id", { ['@id'] = row.id })
    socialChanged(other, "removed")
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:BlockUser', function(source, cb, uid)
    local xPlayer = discordUser(source)
    local other = identifierByUid(uid)
    if not xPlayer or not other or other == xPlayer.identifier then cb(false) return end
    Exec("INSERT IGNORE INTO phone_discord_blocks (blocker, blocked, created_at) VALUES (@a, @b, @t)", { ['@a'] = xPlayer.identifier, ['@b'] = other, ['@t'] = nowTs() })
    local row = friendRow(xPlayer.identifier, other)
    if row then Exec("DELETE FROM phone_discord_friends WHERE id = @id", { ['@id'] = row.id }) end
    socialChanged(other, "removed")
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:UnblockUser', function(source, cb, uid)
    local xPlayer = discordUser(source)
    local other = identifierByUid(uid)
    if not xPlayer or not other then cb(false) return end
    Exec("DELETE FROM phone_discord_blocks WHERE blocker = @a AND blocked = @b", { ['@a'] = xPlayer.identifier, ['@b'] = other })
    cb(true)
end)

-- --------------------------------------------------------------------------
-- Direct messages
-- --------------------------------------------------------------------------

local lastDm = {}

local function dmFor(me, dmId)
    dmId = tonumber(dmId)
    if not dmId then return nil end
    local d = Q("SELECT * FROM phone_discord_dms WHERE id = @d AND (user_low = @i OR user_high = @i)", { ['@d'] = dmId, ['@i'] = me })[1]
    if not d then return nil end
    return d, d.user_low == me and d.user_high or d.user_low
end

local function canTalk(me, other)
    if isBlockedEither(me, other) then return false end
    local row = friendRow(me, other)
    return row ~= nil and row.status == 'accepted'
end

local function shapeMessage(m, me)
    return { id = m.id, author_name = m.author_name, message = m.message, created_at = m.created_at, edited_at = m.edited_at, isMine = m.identifier == me }
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:OpenDM', function(source, cb, uid)
    local xPlayer = discordUser(source)
    local other = identifierByUid(uid)
    if not xPlayer or not other then cb(false) return end
    if not canTalk(xPlayer.identifier, other) then cb({ error = "NOT_FRIENDS" }) return end
    local low, high = pairOf(xPlayer.identifier, other)
    local d = Q("SELECT id FROM phone_discord_dms WHERE user_low = @l AND user_high = @h", { ['@l'] = low, ['@h'] = high })[1]
    local id = d and d.id or MySQL.Sync.insert("INSERT INTO phone_discord_dms (user_low, user_high, created_at, last_at) VALUES (@l, @h, @t, 0)", { ['@l'] = low, ['@h'] = high, ['@t'] = nowTs() })
    cb({ dmId = id, user = cardsFor({ other })[other] })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetDMMessages', function(source, cb, dmId, beforeId)
    local xPlayer = discordUser(source)
    if not xPlayer then cb(false) return end
    local d, other = dmFor(xPlayer.identifier, dmId)
    if not d then cb(false) return end
    local pageSize = math.floor(tonumber((cfg().Social or {}).DmPageSize) or 50)
    local rows
    if tonumber(beforeId) then
        rows = Q("SELECT * FROM phone_discord_dm_messages WHERE dm_id = @d AND id < @b ORDER BY id DESC LIMIT " .. pageSize, { ['@d'] = d.id, ['@b'] = tonumber(beforeId) })
    else
        rows = Q("SELECT * FROM phone_discord_dm_messages WHERE dm_id = @d ORDER BY id DESC LIMIT " .. pageSize, { ['@d'] = d.id })
    end
    local list = {}
    for i = #rows, 1, -1 do list[#list + 1] = shapeMessage(rows[i], xPlayer.identifier) end

    local lastSeen
    if not tonumber(beforeId) then
        local prev = Q("SELECT last_id FROM phone_discord_dm_seen WHERE identifier = @i AND dm_id = @d", { ['@i'] = xPlayer.identifier, ['@d'] = d.id })[1]
        lastSeen = prev and tonumber(prev.last_id) or nil
        Exec([[REPLACE INTO phone_discord_dm_seen (identifier, dm_id, last_id)
               VALUES (@i, @d, COALESCE((SELECT MAX(id) FROM phone_discord_dm_messages WHERE dm_id = @d), 0))]], { ['@i'] = xPlayer.identifier, ['@d'] = d.id })
    end
    cb({ messages = list, hasMore = #rows >= pageSize, lastSeen = lastSeen, user = cardsFor({ other })[other], canSend = canTalk(xPlayer.identifier, other) })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SendDM', function(source, cb, dmId, text)
    local xPlayer = discordUser(source)
    if not xPlayer or not isStr(text) then cb(false) return end
    local d, other = dmFor(xPlayer.identifier, dmId)
    if not d then cb(false) return end
    if not canTalk(xPlayer.identifier, other) then cb({ error = "NOT_FRIENDS" }) return end

    local S = cfg().Social or {}
    local t = GetGameTimer()
    if lastDm[source] and (t - lastDm[source]) < (S.DmCooldownMs or 700) then cb({ error = "COOLDOWN" }) return end
    lastDm[source] = t

    text = Discord_Utf8SafeSub(trim(text), S.MaxMessageLength or 500)
    if text == "" then cb(false) return end
    if Discord_ExtAutoModHit(0, text) then cb({ error = "AUTOMOD" }) return end

    local author, created = Discord_GetDisplayName(source), nowTs()
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_dm_messages (dm_id, identifier, author_name, message, created_at) VALUES (@d, @i, @n, @m, @t)", {
        ['@d'] = d.id, ['@i'] = xPlayer.identifier, ['@n'] = author, ['@m'] = text, ['@t'] = created,
    })
    Exec("UPDATE phone_discord_dms SET last_at = @t WHERE id = @d", { ['@t'] = created, ['@d'] = d.id })
    Exec("REPLACE INTO phone_discord_dm_seen (identifier, dm_id, last_id) VALUES (@i, @d, @m)", { ['@i'] = xPlayer.identifier, ['@d'] = d.id, ['@m'] = id })

    local tp = ESX.GetPlayerFromIdentifier(other)
    if tp then
        TriggerClientEvent('Unique_Phone:client:DiscordExt:DMNew', tp.source, {
            dmId = d.id, message = { id = id, author_name = author, message = text, created_at = created, isMine = false },
            from = cardsFor({ xPlayer.identifier })[xPlayer.identifier],
        })
    end
    cb({ ok = true, id = id, created_at = created, message = text })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:EditDM', function(source, cb, messageId, text)
    local xPlayer = discordUser(source)
    if not xPlayer or not isStr(text) then cb(false) return end
    local m = Q("SELECT m.id, m.dm_id, m.identifier FROM phone_discord_dm_messages m WHERE m.id = @m", { ['@m'] = tonumber(messageId) })[1]
    if not m or m.identifier ~= xPlayer.identifier then cb(false) return end
    local d, other = dmFor(xPlayer.identifier, m.dm_id)
    if not d or not canTalk(xPlayer.identifier, other) then cb(false) return end
    text = Discord_Utf8SafeSub(trim(text), (cfg().Social or {}).MaxMessageLength or 500)
    if text == "" or Discord_ExtAutoModHit(0, text) then cb(false) return end
    local t = nowTs()
    Exec("UPDATE phone_discord_dm_messages SET message = @m, edited_at = @t WHERE id = @id", { ['@m'] = text, ['@t'] = t, ['@id'] = m.id })
    local tp = ESX.GetPlayerFromIdentifier(other)
    if tp then TriggerClientEvent('Unique_Phone:client:DiscordExt:DMEdited', tp.source, { dmId = d.id, messageId = m.id, message = text, edited_at = t }) end
    cb({ ok = true, message = text, edited_at = t })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteDM', function(source, cb, messageId)
    local xPlayer = discordUser(source)
    if not xPlayer then cb(false) return end
    local m = Q("SELECT id, dm_id, identifier FROM phone_discord_dm_messages WHERE id = @m", { ['@m'] = tonumber(messageId) })[1]
    if not m or m.identifier ~= xPlayer.identifier then cb(false) return end
    local d, other = dmFor(xPlayer.identifier, m.dm_id)
    if not d then cb(false) return end
    Exec("DELETE FROM phone_discord_dm_messages WHERE id = @id", { ['@id'] = m.id })
    local tp = ESX.GetPlayerFromIdentifier(other)
    if tp then TriggerClientEvent('Unique_Phone:client:DiscordExt:DMDeleted', tp.source, { dmId = d.id, messageId = m.id }) end
    cb(true)
end)

RegisterServerEvent('Unique_Phone:server:DiscordExt:MarkDMSeen')
AddEventHandler('Unique_Phone:server:DiscordExt:MarkDMSeen', function(dmId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local d = dmFor(xPlayer.identifier, dmId)
    if not d then return end
    Exec([[REPLACE INTO phone_discord_dm_seen (identifier, dm_id, last_id)
           VALUES (@i, @d, COALESCE((SELECT MAX(id) FROM phone_discord_dm_messages WHERE dm_id = @d), 0))]], { ['@i'] = xPlayer.identifier, ['@d'] = d.id })
end)

AddEventHandler('playerDropped', function() lastDm[source] = nil end)

-- --------------------------------------------------------------------------
-- Channel name + topic (v12)
-- --------------------------------------------------------------------------

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetChannelInfo', function(source, cb, serverId, channelId, name, topic)
    local xPlayer = Discord_GetPlayer(source)
    serverId, channelId = tonumber(serverId), tonumber(channelId)
    if not xPlayer or not serverId or not channelId or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    local row = Q("SELECT id FROM phone_discord_channels WHERE id = @c AND server_id = @s", { ['@c'] = channelId, ['@s'] = serverId })[1]
    if not row then cb(false) return end
    name = string.lower((clean(name, 30):gsub("%s+", "-")))
    if name == "" then cb(false) return end
    topic = clean(topic, 200)
    Exec("UPDATE phone_discord_channels SET name = @n, topic = @t WHERE id = @c", { ['@n'] = name, ['@t'] = topic ~= "" and topic or nil, ['@c'] = channelId })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, channels = true })
    cb({ ok = true, name = name, topic = topic ~= "" and topic or nil })
end)

-- --------------------------------------------------------------------------
-- Discover (v13): public servers, categories, search, featured first
-- --------------------------------------------------------------------------

local DISCOVER_CATEGORIES = { gaming = true, roleplay = true, gangs = true, jobs = true, community = true, other = true }

local function likeEscape(s)
    return (s:gsub("[\\%%_]", "\\%0"))
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetDiscover', function(source, cb, query, category)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end
    local me = xPlayer.identifier

    local where = "s.is_public = 1"
    local params = { ['@me'] = me }
    if isStr(category) and DISCOVER_CATEGORIES[category] then
        where = where .. " AND s.category = @cat"
        params['@cat'] = category
    end
    local q = clean(query, 40)
    if #q >= 2 then
        where = where .. " AND (LOWER(s.name) LIKE @q OR LOWER(s.description) LIKE @q)"
        params['@q'] = "%" .. likeEscape(q:lower()) .. "%"
    end

    local rows = Q([[SELECT s.id, s.name, s.icon_text, s.icon_color, s.icon_url, s.description, s.category, s.is_verified, s.is_featured, s.vanity,
                            (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) AS memberCount
                     FROM phone_discord_servers s WHERE ]] .. where .. [[
                     ORDER BY s.is_featured DESC, memberCount DESC, s.id ASC LIMIT 60]], params)
    if #rows == 0 then cb({}) return end

    local ids, holders, p2 = {}, {}, {}
    for i, r in ipairs(rows) do
        p2['@s' .. i] = r.id
        holders[#holders + 1] = '@s' .. i
    end
    local inList = table.concat(holders, ",")
    local mine = {}
    for _, m in ipairs(Q("SELECT server_id FROM phone_discord_members WHERE identifier = @me", { ['@me'] = me })) do mine[m.server_id] = true end
    local online = {}
    for _, m in ipairs(Q("SELECT server_id, identifier FROM phone_discord_members WHERE server_id IN (" .. inList .. ")", p2)) do
        if ESX.GetPlayerFromIdentifier(m.identifier) then online[m.server_id] = (online[m.server_id] or 0) + 1 end
    end

    local out = {}
    for _, r in ipairs(rows) do
        out[#out + 1] = {
            id = r.id, name = r.name, icon_text = r.icon_text, icon_color = r.icon_color, icon_url = r.icon_url,
            description = r.description, category = r.category, vanity = r.vanity,
            isVerified = truthy(r.is_verified), isFeatured = truthy(r.is_featured),
            memberCount = tonumber(r.memberCount) or 0, onlineCount = online[r.id] or 0, isMember = mine[r.id] == true,
        }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetDiscoverCategory', function(source, cb, serverId, category, isPublic)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if xPlayer == nil or serverId == nil then cb(false) return end
    if Discord_IsAutoServer(serverId) then cb({ error = "AUTO" }) return end
    if not (Discord_IsOwner(xPlayer.identifier, serverId) or Discord_ExtCan(xPlayer.identifier, serverId, 'manage_server')) then cb(false) return end
    if not isStr(category) or not DISCOVER_CATEGORIES[category] then cb({ error = "BAD_CATEGORY" }) return end
    Exec("UPDATE phone_discord_servers SET category = @c, is_public = @p WHERE id = @s", {
        ['@c'] = category, ['@p'] = (isPublic == true) and 1 or 0, ['@s'] = serverId,
    })
    cb({ ok = true })
end)


-- --------------------------------------------------------------------------
-- v14: website presence (written by the website into dsite_presence, same database)
-- A player counts as "on the website" when they made a request in the last 60 s.
-- Missing table or database error => nobody counts as on the website.
-- --------------------------------------------------------------------------

local WEB_PRESENCE_WINDOW = 60

function Discord_ExtWebOnline(identifiers)
    local out = {}
    if type(identifiers) ~= "table" or #identifiers == 0 then return out end
    local params, holders = {}, {}
    for i, id in ipairs(identifiers) do
        params['@w' .. i] = id
        holders[#holders + 1] = '@w' .. i
    end
    local ok, rows = pcall(ExecuteSql, true, "SELECT identifier, last_seen FROM dsite_presence WHERE identifier IN (" .. table.concat(holders, ",") .. ")", params)
    if not ok or type(rows) ~= "table" then return out end
    local now = os.time()
    for _, r in ipairs(rows) do
        if now - (tonumber(r.last_seen) or 0) < WEB_PRESENCE_WINDOW then out[r.identifier] = true end
    end
    return out
end
