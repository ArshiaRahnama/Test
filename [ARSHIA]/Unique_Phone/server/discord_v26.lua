-- ==========================================================================
-- Discord app v26 — message requests (15). Loaded LAST.
-- Rules (like Discord's defaults):
--   * anyone who shares at least one server with you can send a request
--     (not if either of you blocked the other);
--   * only ONE pending request per pair; the sender may have at most 5 pending requests;
--   * the recipient reads the request and accepts or declines it; until then the
--     recipient cannot reply and the sender can send at most 3 messages;
--   * accepting lets you talk without being friends; declining deletes the conversation.
-- Friends and normal DMs keep using the original callbacks.
-- ==========================================================================
local MAX_PENDING_OUT = 5
local MAX_BEFORE_ACCEPT = 3

local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end
local function now() return os.time() end
local function pairOf(a, b) if a < b then return a, b end return b, a end

local function isFriend(a, b)
    local low, high = pairOf(a, b)
    local f = Q("SELECT status FROM phone_discord_friends WHERE user_low = @l AND user_high = @h", { ['@l'] = low, ['@h'] = high })[1]
    return f ~= nil and f.status == 'accepted'
end
local function blocked(a, b)
    return Q("SELECT 1 AS x FROM phone_discord_blocks WHERE (blocker = @a AND blocked = @b) OR (blocker = @b AND blocked = @a) LIMIT 1", { ['@a'] = a, ['@b'] = b })[1] ~= nil
end
local function sharesServer(a, b)
    return Q("SELECT 1 AS x FROM phone_discord_members m1 JOIN phone_discord_members m2 ON m1.server_id = m2.server_id WHERE m1.identifier = @a AND m2.identifier = @b LIMIT 1", { ['@a'] = a, ['@b'] = b })[1] ~= nil
end
local function identOfUid(uid)
    local r = Q("SELECT identifier FROM phone_discord_profiles WHERE uid = @u", { ['@u'] = tonumber(uid) or 0 })[1]
    return r and r.identifier or nil
end
local function dmOf(me, dmId)
    local d = Q("SELECT * FROM phone_discord_dms WHERE id = @d AND (user_low = @i OR user_high = @i)", { ['@d'] = tonumber(dmId) or 0, ['@i'] = me })[1]
    if not d then return nil end
    d.other = d.user_low == me and d.user_high or d.user_low
    return d
end
local function cardOf(ident)
    local p = Q("SELECT uid, discriminator, avatar_url, status FROM phone_discord_profiles WHERE identifier = @i", { ['@i'] = ident })[1] or {}
    local name = Q("SELECT firstname, lastname FROM users WHERE identifier = @i", { ['@i'] = ident })[1]
    return { uid = p.uid, name = name and ((name.firstname or "") .. " " .. (name.lastname or "")) or "Player", discriminator = p.discriminator or "0000", avatar = p.avatar_url, status = p.status or "online" }
end
local function notify(ident, text, kind)
    local p = ESX.GetPlayerFromIdentifier(ident)
    if p then TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', p.source, { text = text, kind = kind or "info" }) end
end

-- ---- open a request (non-friends) -------------------------------------------
do
    local name = 'Unique_Phone:server:DiscordExt:OpenDM'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, uid)
            local me = Discord_GetPlayer(source)
            local other = identOfUid(uid)
            if not me or not other or isFriend(me.identifier, other) then return orig(source, cb, uid) end
            if blocked(me.identifier, other) or not sharesServer(me.identifier, other) then cb({ error = "NOT_FRIENDS" }) return end
            local low, high = pairOf(me.identifier, other)
            local d = Q("SELECT id, request_state FROM phone_discord_dms WHERE user_low = @l AND user_high = @h", { ['@l'] = low, ['@h'] = high })[1]
            if d then cb({ dmId = d.id, user = cardOf(other), requestState = d.request_state }) return end
            local pending = Q("SELECT COUNT(*) AS c FROM phone_discord_dms WHERE request_state = 'pending' AND requested_by = @i", { ['@i'] = me.identifier })[1].c
            if tonumber(pending) >= MAX_PENDING_OUT then cb({ error = "TOO_MANY_REQUESTS" }) return end
            local id = MySQL.Sync.insert("INSERT INTO phone_discord_dms (user_low, user_high, created_at, last_at, request_state, requested_by) VALUES (@l, @h, @c, 0, 'pending', @b)",
                { ['@l'] = low, ['@h'] = high, ['@c'] = now(), ['@b'] = me.identifier })
            cb({ dmId = id, user = cardOf(other), requestState = 'pending' })
        end
    end
end

-- ---- sending: request DMs use these rules; everything else goes to the original --------
do
    local name = 'Unique_Phone:server:DiscordExt:SendDM'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, dmId, text)
            local me = Discord_GetPlayer(source)
            local d = me and dmOf(me.identifier, dmId)
            if not d or d.request_state == nil or isFriend(me.identifier, d.other) then return orig(source, cb, dmId, text) end
            if blocked(me.identifier, d.other) then cb({ error = "NOT_FRIENDS" }) return end
            if d.request_state == 'pending' then
                if d.requested_by ~= me.identifier then cb({ error = "NEEDS_ACCEPT" }) return end
                local sent = Q("SELECT COUNT(*) AS c FROM phone_discord_dm_messages WHERE dm_id = @d AND identifier = @i", { ['@d'] = d.id, ['@i'] = me.identifier })[1].c
                if tonumber(sent) >= MAX_BEFORE_ACCEPT then cb({ error = "WAIT_FOR_ACCEPT" }) return end
            end
            text = Discord_Utf8SafeSub((tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")), 500)
            if text == "" then cb(false) return end
            local created = now()
            local id = MySQL.Sync.insert("INSERT INTO phone_discord_dm_messages (dm_id, identifier, author_name, message, created_at) VALUES (@d, @i, @n, @m, @c)",
                { ['@d'] = d.id, ['@i'] = me.identifier, ['@n'] = Discord_GetDisplayName(source), ['@m'] = text, ['@c'] = created })
            Exec("UPDATE phone_discord_dms SET last_at = @t WHERE id = @d", { ['@t'] = created, ['@d'] = d.id })
            Exec("REPLACE INTO phone_discord_dm_seen (identifier, dm_id, last_id) VALUES (@i, @d, @m)", { ['@i'] = me.identifier, ['@d'] = d.id, ['@m'] = id })
            local tp = ESX.GetPlayerFromIdentifier(d.other)
            if tp then
                TriggerClientEvent('Unique_Phone:client:DiscordExt:DMNew', tp.source, {
                    dmId = d.id, message = { id = id, author_name = Discord_GetDisplayName(source), message = text, created_at = created, isMine = false },
                    from = cardOf(me.identifier), request = d.request_state == 'pending',
                })
            end
            cb({ ok = true, id = id, created_at = created, message = text })
        end
    end
end

-- ---- history: tell the client what state the conversation is in -----------------
do
    local name = 'Unique_Phone:server:DiscordExt:GetDMMessages'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, dmId, beforeId)
            local me = Discord_GetPlayer(source)
            return orig(source, function(result, ...)
                if type(result) == "table" and result.messages and me then
                    local d = dmOf(me.identifier, dmId)
                    if d and d.request_state ~= nil then
                        result.requestState = d.request_state
                        result.requestedByMe = d.requested_by == me.identifier
                        if not isFriend(me.identifier, d.other) then
                            result.canSend = (d.request_state == 'accepted') or (d.request_state == 'pending' and d.requested_by == me.identifier)
                        end
                    end
                end
                return cb(result, ...)
            end, dmId, beforeId)
        end
    end
end

-- ---- the inbox -----------------------------------------------------------------------
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMessageRequests', function(source, cb)
    local me = Discord_GetPlayer(source)
    if not me then cb({}) return end
    local out = {}
    for _, d in ipairs(Q("SELECT id, user_low, user_high, requested_by, last_at FROM phone_discord_dms WHERE request_state = 'pending' AND requested_by <> @i AND (user_low = @i OR user_high = @i) ORDER BY last_at DESC LIMIT 50", { ['@i'] = me.identifier })) do
        local first = Q("SELECT message FROM phone_discord_dm_messages WHERE dm_id = @d ORDER BY id DESC LIMIT 1", { ['@d'] = d.id })[1]
        out[#out + 1] = { dmId = d.id, user = cardOf(d.requested_by), lastMessage = first and Discord_Utf8SafeSub(first.message, 80) or "", at = d.last_at }
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AcceptRequest', function(source, cb, dmId)
    local me = Discord_GetPlayer(source)
    local d = me and dmOf(me.identifier, dmId)
    if not d or d.request_state ~= 'pending' or d.requested_by == me.identifier then cb(false) return end
    Exec("UPDATE phone_discord_dms SET request_state = 'accepted' WHERE id = @d", { ['@d'] = d.id })
    notify(d.requested_by, Discord_GetDisplayName(source) .. " accepted your message request.", "success")
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeclineRequest', function(source, cb, dmId)
    local me = Discord_GetPlayer(source)
    local d = me and dmOf(me.identifier, dmId)
    if not d or d.request_state ~= 'pending' or d.requested_by == me.identifier then cb(false) return end
    Exec("DELETE FROM phone_discord_dm_messages WHERE dm_id = @d", { ['@d'] = d.id })
    Exec("DELETE FROM phone_discord_dm_seen WHERE dm_id = @d", { ['@d'] = d.id })
    Exec("DELETE FROM phone_discord_dms WHERE id = @d", { ['@d'] = d.id })
    cb({ ok = true })
end)
