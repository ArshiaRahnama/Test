-- ==========================================================================
-- Discord app v28 — only chosen people may create servers and channels.
-- The switch and the creators list are in the staff panel (main.lua actions).
-- Loaded LAST; wraps the creation callbacks like the audit log does.
-- ==========================================================================
function Discord_CreationRestricted()
    local r = ExecuteSql(true, "SELECT v FROM phone_discord_settings WHERE k = 'creation_restricted'", {})[1]
    if r then return r.v == "1" end
    return Config.DiscordCreation ~= nil and Config.DiscordCreation.Restricted == true
end

function Discord_CanCreate(src)
    if not Discord_CreationRestricted() then return true end
    if (Config.DiscordCreation == nil or Config.DiscordCreation.StaffAlwaysAllowed ~= false) and Discord_IsStaff(src) then return true end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end
    return ExecuteSql(true, "SELECT identifier FROM phone_discord_creators WHERE identifier = @i", { ['@i'] = xPlayer.identifier })[1] ~= nil
end

do
    local names = {
        'Unique_Phone:server:Discord:CreateServer',
        'Unique_Phone:server:Discord:CreateChannel',
        'Unique_Phone:server:DiscordExt:CreateStageChannel',
        'Unique_Phone:server:DiscordExt:CreateChannelFromTemplate',
    }
    for _, name in ipairs(names) do
        local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
        if orig then
            ESX.ServerCallbacks[name] = function(source, cb, ...)
                if not Discord_CanCreate(source) then cb({ error = "NOT_CREATOR" }) return end
                return orig(source, cb, ...)
            end
        end
    end
end
