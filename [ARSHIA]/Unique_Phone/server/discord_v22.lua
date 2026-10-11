-- ==========================================================================
-- Discord app v22 — (8) server tags for Discover, (9) role icons.
-- Loaded LAST. The Discover query and the member chips were updated in place
-- (discord_ext4.lua, discord_ext.lua, discord_ext2.lua) to read these fields.
-- ==========================================================================
local TAGS = { roleplay = true, gaming = true, gangs = true, jobs = true, police = true, medical = true,
               racing = true, events = true, community = true, chill = true }
local MAX_TAGS = 4

local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end

-- pure parser (unit-tested): "Roleplay, police,  bogus" -> "roleplay,police", error if too many
function Discord_ExtParseTags(raw)
    local out, seen = {}, {}
    for word in tostring(raw or ""):lower():gmatch("[^,]+") do
        local t = word:gsub("^%s+", ""):gsub("%s+$", "")
        if t ~= "" then
            if not TAGS[t] then return nil, "BAD_TAG" end
            if not seen[t] then seen[t] = true; out[#out + 1] = t end
        end
    end
    if #out > MAX_TAGS then return nil, "TOO_MANY" end
    return table.concat(out, ","), nil
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetServerTags', function(source, cb, serverId, raw)
    local xPlayer = Discord_GetPlayer(source)
    serverId = tonumber(serverId)
    if not xPlayer or not serverId then cb(false) return end
    if not (Discord_IsOwner(xPlayer.identifier, serverId) or Discord_ExtCan(xPlayer.identifier, serverId, 'manage_server')) then cb(false) return end
    local tags, err = Discord_ExtParseTags(raw)
    if err then cb({ error = err }) return end
    Exec("UPDATE phone_discord_servers SET tags = @t WHERE id = @s", { ['@t'] = (tags ~= "" and tags or nil), ['@s'] = serverId })
    cb({ ok = true, tags = tags ~= "" and tags or nil })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetRoleIcon', function(source, cb, serverId, roleId, icon)
    local xPlayer = Discord_GetPlayer(source)
    serverId, roleId = tonumber(serverId), tonumber(roleId)
    if not xPlayer or not serverId or not roleId then cb(false) return end
    if not Discord_ExtCan(xPlayer.identifier, serverId, 'manage_roles') then cb(false) return end
    local role = Q("SELECT id FROM phone_discord_roles WHERE id = @r AND server_id = @s", { ['@r'] = roleId, ['@s'] = serverId })[1]
    if not role then cb(false) return end
    icon = (type(icon) == "string") and icon:gsub("^%s+", ""):gsub("%s+$", "") or ""
    if icon ~= "" and not Discord_ExtIsEmoji(icon) then cb({ error = "BAD_ICON" }) return end
    Exec("UPDATE phone_discord_roles SET icon = @i WHERE id = @r", { ['@i'] = (icon ~= "" and icon or nil), ['@r'] = roleId })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, roles = true })
    cb({ ok = true })
end)
