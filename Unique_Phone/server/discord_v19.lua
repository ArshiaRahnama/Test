-- ==========================================================================
-- Discord app v19 — reply pings (12) and member-join alerts (28).
-- Loaded LAST, after discord_v18.lua. Wraps callbacks the same way the audit log does.
-- ==========================================================================
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end

-- 12) A reply can ping the person it answers (the sender chooses; default on).
-- The original send callback ignores the 4th argument; we read it here.
do
    local name = 'Unique_Phone:server:Discord:SendMessage'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, channelId, message, replyToId, replyPing)
            local wantPing = replyPing == true and tonumber(replyToId) ~= nil
            return orig(source, function(result, ...)
                if wantPing and type(result) == "table" and result.id then
                    local target = Q("SELECT identifier FROM phone_discord_messages WHERE id = @r", { ['@r'] = tonumber(replyToId) })[1]
                    local sender = ESX.GetPlayerFromId(source)
                    if target and sender and target.identifier ~= sender.identifier then
                        local p = ESX.GetPlayerFromIdentifier(target.identifier)
                        local ch = Q("SELECT server_id FROM phone_discord_channels WHERE id = @c", { ['@c'] = tonumber(channelId) or 0 })[1]
                        if p and ch then
                            TriggerClientEvent('Unique_Phone:client:DiscordExt:ReplyPing', p.source, {
                                serverId = ch.server_id, channelId = tonumber(channelId), from = Discord_GetDisplayName(source),
                                text = Discord_Utf8SafeSub(tostring(message or ""), 80),
                            })
                        end
                    end
                end
                return cb(result, ...)
            end, channelId, message, replyToId, replyPing)
        end
    end
end

-- 28) When someone joins a server, its staff who are online get a notice.
do
    local joins = {
        'Unique_Phone:server:Discord:JoinServer',
        'Unique_Phone:server:Discord:JoinPublicServer',
        'Unique_Phone:server:Discord:JoinVIPServer',
    }
    for _, name in ipairs(joins) do
        local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
        if orig then
            ESX.ServerCallbacks[name] = function(source, cb, ...)
                return orig(source, function(result, ...)
                    if type(result) == "table" and result.id and not result.error then
                        local who = Discord_GetDisplayName(source)
                        local sname = result.name or "your server"
                        for _, pid in ipairs(GetPlayers()) do
                            local p = ESX.GetPlayerFromId(tonumber(pid))
                            if p and Discord_CanManageChannels(p.identifier, result.id) then
                                TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', p.source, {
                                    text = who .. " joined " .. sname .. ".", kind = "info" })
                            end
                        end
                    end
                    return cb(result, ...)
                end, ...)
            end
        end
    end
end
