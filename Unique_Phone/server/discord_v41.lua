-- ==========================================================================
-- Discord app v41 — mutual servers: the servers you and another person are both in.
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMutualServers', function(source, cb, uid)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb({}) return end
    uid = tonumber(uid)
    local other = uid and ExecuteSql(true, "SELECT identifier FROM phone_discord_profiles WHERE uid = @u LIMIT 1", { ['@u'] = uid })[1]
    if not other or other.identifier == xPlayer.identifier then cb({}) return end
    local rows = ExecuteSql(true, [[SELECT s.id, s.name FROM phone_discord_servers s
        JOIN phone_discord_members a ON a.server_id = s.id AND a.identifier = @me
        JOIN phone_discord_members b ON b.server_id = s.id AND b.identifier = @them
        ORDER BY s.name LIMIT 50]], { ['@me'] = xPlayer.identifier, ['@them'] = other.identifier })
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = { id = r.id, name = r.name } end
    cb(out)
end)
