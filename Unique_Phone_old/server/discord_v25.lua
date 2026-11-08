-- ==========================================================================
-- Discord app v25 — avatar effects (19): a ring or glow around your avatar.
-- Loaded LAST. The effect travels with the member data (discord_ext4/discord_ext).
-- ==========================================================================
local EFFECTS = { none = true, ring = true, glow = true, pulse = true, rainbow = true }

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetAvatarEffect', function(source, cb, effect)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb(false) return end
    if type(effect) ~= "string" or not EFFECTS[effect] then cb({ error = "BAD_EFFECT" }) return end
    local value = effect ~= "none" and effect or nil
    MySQL.Sync.execute("UPDATE phone_discord_profiles SET avatar_effect = @e WHERE identifier = @i", { ['@e'] = value, ['@i'] = xPlayer.identifier })
    for _, m in ipairs(ExecuteSql(true, "SELECT server_id FROM phone_discord_members WHERE identifier = @i", { ['@i'] = xPlayer.identifier })) do
        Discord_BroadcastToServerMembers(m.server_id, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = m.server_id, members = true })
    end
    cb({ ok = true, effect = effect })
end)
