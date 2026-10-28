-- ==========================================================================
-- Discord app v15 — profile banner image (from a URL or the phone gallery).
-- Loaded after discord_v14.lua. SQL: sql/discord_v15.sql.
-- ==========================================================================
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetBanner', function(source, cb, url)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb(false) return end
    url = type(url) == "string" and url:gsub("^%s+", ""):gsub("%s+$", "") or ""
    if url ~= "" and not Discord_ExtValidMediaUrl(url) then cb({ error = "BAD_URL" }) return end
    -- a profile row always exists once someone opened the app
    MySQL.Sync.execute("UPDATE phone_discord_profiles SET banner_url = @u WHERE identifier = @i", {
        ['@u'] = url ~= "" and url or nil, ['@i'] = xPlayer.identifier,
    })
    -- everyone who shares a server with this player sees the new banner
    for _, m in ipairs(ExecuteSql(true, "SELECT server_id FROM phone_discord_members WHERE identifier = @i", { ['@i'] = xPlayer.identifier })) do
        Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = m.server_id, members = true })
    end
    cb({ ok = true, banner = url ~= "" and url or nil })
end)
