-- ==========================================================================
-- Discord app v24 — "Seen" on direct messages (27). Loaded LAST.
-- Adds otherSeen (the last message id the other person has read) to the DM
-- history reply. Uses the existing phone_discord_dm_seen table; no new table.
-- ==========================================================================
do
    local name = 'Unique_Phone:server:DiscordExt:GetDMMessages'
    local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
    if orig then
        ESX.ServerCallbacks[name] = function(source, cb, dmId, beforeId)
            local xPlayer = Discord_GetPlayer(source)
            return orig(source, function(result, ...)
                if type(result) == "table" and result.messages and xPlayer then
                    local dm = ExecuteSql(true, "SELECT user_low, user_high FROM phone_discord_dms WHERE id = @d", { ['@d'] = tonumber(dmId) or 0 })[1]
                    if dm then
                        local other = dm.user_low == xPlayer.identifier and dm.user_high or dm.user_low
                        local seen = ExecuteSql(true, "SELECT last_id FROM phone_discord_dm_seen WHERE identifier = @i AND dm_id = @d", { ['@i'] = other, ['@d'] = tonumber(dmId) or 0 })[1]
                        result.otherSeen = seen and tonumber(seen.last_id) or 0
                    end
                end
                return cb(result, ...)
            end, dmId, beforeId)
        end
    end
end
