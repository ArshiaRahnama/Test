-- steam_compat.lua
-- Players without a real Steam account still have a FiveM license:<n>. Several
-- scripts look for a steam: identifier, so this file adds steam:<n> (same value
-- as the license) to the identifier list when no real steam: entry exists.
-- Real Steam identifiers are never changed. The override only affects the
-- resource this file is loaded in.
local _nativeGetPlayerIdentifiers = GetPlayerIdentifiers

function GetPlayerIdentifiers(src)
    local ids = _nativeGetPlayerIdentifiers(src) or {}
    local hasSteam, license = false, nil
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 6) == "steam:" then hasSteam = true end
        if not license and string.sub(id, 1, 8) == "license:" then
            license = string.sub(id, 9)
        end
    end
    if hasSteam or not license or license == "" then
        return ids
    end
    local out = { "steam:" .. license }
    for _, id in ipairs(ids) do out[#out + 1] = id end
    return out
end
