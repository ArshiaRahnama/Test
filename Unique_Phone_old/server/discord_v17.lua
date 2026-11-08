-- ==========================================================================
-- Discord app v17 — bulk delete (staff removes several messages at once).
-- Loaded after discord_v16.lua.
-- ==========================================================================
local BULK_MAX = 50

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:BulkDelete', function(source, cb, channelId, ids)
    local xPlayer = Discord_GetPlayer(source)
    channelId = tonumber(channelId)
    if not xPlayer or not channelId or type(ids) ~= "table" then cb(false) return end
    local ch = ExecuteSql(true, "SELECT id, server_id FROM phone_discord_channels WHERE id = @c", { ['@c'] = channelId })[1]
    if not ch then cb(false) return end
    if not Discord_ExtCan(xPlayer.identifier, ch.server_id, 'manage_messages') and not Discord_CanManageChannels(xPlayer.identifier, ch.server_id) then
        cb({ error = "NO_PERMISSION" }) return
    end
    if #ids == 0 or #ids > BULK_MAX then cb({ error = "BAD_COUNT" }) return end

    local wanted, clean = {}, {}
    for _, v in ipairs(ids) do
        local n = tonumber(v)
        if not n or wanted[n] then cb({ error = "BAD_LIST" }) return end
        wanted[n] = true
        clean[#clean + 1] = n
    end
    -- only messages that really belong to this channel are deleted
    local holders, params = {}, {}
    for i, n in ipairs(clean) do params['@m' .. i] = n; holders[#holders + 1] = '@m' .. i end
    local rows = ExecuteSql(true, "SELECT id FROM phone_discord_messages WHERE channel_id = @c AND id IN (" .. table.concat(holders, ",") .. ")",
        (function() local p = { ['@c'] = channelId }; for k, v in pairs(params) do p[k] = v end; return p end)())

    local deleted = {}
    for _, r in ipairs(rows) do
        MySQL.Sync.execute("DELETE FROM phone_discord_reactions WHERE message_id = @m", { ['@m'] = r.id })
        MySQL.Sync.execute("DELETE FROM phone_discord_messages WHERE id = @m", { ['@m'] = r.id })
        deleted[#deleted + 1] = r.id
        Discord_BroadcastToServerMembers(ch.server_id, 'Unique_Phone:client:Discord:MessageDeleted', { serverId = ch.server_id, messageId = r.id })
    end
    cb({ ok = true, count = #deleted, ids = deleted })
end)
