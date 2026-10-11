-- ==========================================================================
-- Discord app v23 — pin limit (50 per channel) and pinned_at for ordering.
-- Loaded LAST. The pinned list itself is sorted in main.lua (GetPinnedMessages).
-- ==========================================================================
local PIN_LIMIT = 50
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end

do
    local name = 'Unique_Phone:server:Discord:TogglePinMessage'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, messageId)
            local m = Q("SELECT id, channel_id, is_pinned FROM phone_discord_messages WHERE id = @m", { ['@m'] = tonumber(messageId) or 0 })[1]
            local pinningNow = m ~= nil and not (m.is_pinned == 1 or m.is_pinned == true)
            if pinningNow then
                local n = Q("SELECT COUNT(*) AS c FROM phone_discord_messages WHERE channel_id = @c AND is_pinned = 1", { ['@c'] = m.channel_id })[1]
                if n and tonumber(n.c) >= PIN_LIMIT then cb({ error = "PIN_LIMIT", limit = PIN_LIMIT }) return end
            end
            return orig(source, function(result, ...)
                if m and type(result) == "table" and result.isPinned ~= nil then
                    if result.isPinned then
                        Exec("UPDATE phone_discord_messages SET pinned_at = @t WHERE id = @m", { ['@t'] = os.time(), ['@m'] = m.id })
                    else
                        Exec("UPDATE phone_discord_messages SET pinned_at = NULL WHERE id = @m", { ['@m'] = m.id })
                    end
                end
                return cb(result, ...)
            end, messageId)
        end
    end
end
