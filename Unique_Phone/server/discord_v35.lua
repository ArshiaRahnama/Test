-- ==========================================================================
-- Discord app v35 — the ID the player chooses after the code is verified.
-- 3-20 characters: a-z, 0-9, _ and . ; unique on the server.
-- ==========================================================================
local function cleanHandle(s)
    s = tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()
    return s
end

function Discord_ValidHandle(s)
    return type(s) == "string" and #s >= 3 and #s <= 20 and s:match("^[a-z0-9_%.]+$") ~= nil
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetHandle', function(source, cb, handle)
    local xPlayer = Discord_GetPlayer(source)
    if not xPlayer then cb({ error = "NOT_LOGGED_IN" }) return end
    handle = cleanHandle(handle)
    if not Discord_ValidHandle(handle) then cb({ error = "BAD_HANDLE" }) return end
    local taken = ExecuteSql(true, "SELECT identifier FROM phone_discord_profiles WHERE handle = @h AND identifier <> @i LIMIT 1",
        { ['@h'] = handle, ['@i'] = xPlayer.identifier })[1]
    if taken then cb({ error = "TAKEN" }) return end
    local row = ExecuteSql(true, "SELECT identifier FROM phone_discord_profiles WHERE identifier = @i", { ['@i'] = xPlayer.identifier })[1]
    if row then
        MySQL.Sync.execute("UPDATE phone_discord_profiles SET handle = @h WHERE identifier = @i", { ['@h'] = handle, ['@i'] = xPlayer.identifier })
    else
        -- the profile is created the first time the app opens; make it now if it is not there yet
        local disc = string.format("%04d", math.random(1, 9999))
        MySQL.Sync.execute("INSERT INTO phone_discord_profiles (identifier, discriminator, handle, created_at, updated_at) VALUES (@i, @d, @h, @t, @t)",
            { ['@i'] = xPlayer.identifier, ['@d'] = disc, ['@h'] = handle, ['@t'] = os.time() })
    end
    cb({ ok = true, handle = handle })
end)
