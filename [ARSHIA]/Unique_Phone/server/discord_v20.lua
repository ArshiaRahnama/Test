-- ==========================================================================
-- Discord app v20 — search filters (26): from:name  in:channel  before:YYYY-MM-DD
-- Wraps the in-game search callback. The filters are removed from the query and
-- applied to the results; the remaining text is searched exactly as before.
-- Loaded LAST.
-- ==========================================================================

-- pure parser (also unit-tested): returns plain text and a filter table
function Discord_ExtParseSearch(raw)
    local filters = {}
    local text = tostring(raw or "")
    text = text:gsub("(%S+):(%S+)", function(key, value)
        key = key:lower()
        if key == "from" or key == "in" or key == "before" then
            filters[key] = value
            return ""
        end
        return nil -- not a filter: keep the word as typed
    end)
    text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return text, filters
end

-- seconds since epoch for YYYY-MM-DD (start of that day, server time); nil if malformed
function Discord_ExtDateToTs(s)
    local y, m, d = tostring(s or ""):match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
    if not y then return nil end
    return os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 0, min = 0, sec = 0 })
end

local name = 'Unique_Phone:server:DiscordExt:Search'
local orig = ESX.ServerCallbacks and ESX.ServerCallbacks[name]
if orig then
    ESX.ServerCallbacks[name] = function(source, cb, serverId, channelId, query)
        local text, f = Discord_ExtParseSearch(query)
        if next(f) == nil then return orig(source, cb, serverId, channelId, query) end   -- no filters: unchanged
        if (utf8.len(text) or #text) < 2 then cb({}) return end                          -- filters need some words to search
        local before = f.before and Discord_ExtDateToTs(f.before)
        if f.before and not before then cb({}) return end
        return orig(source, function(rows)
            local out = {}
            local from = f.from and f.from:lower()
            local inCh = f["in"] and f["in"]:lower():gsub("^#", "")
            for _, r in ipairs(rows or {}) do
                local ok = true
                if from and not tostring(r.author_name or ""):lower():find(from, 1, true) then ok = false end
                if inCh and not tostring(r.channel_name or ""):lower():find(inCh, 1, true) then ok = false end
                if before and tonumber(r.created_at) and tonumber(r.created_at) >= before then ok = false end
                if ok then out[#out + 1] = r end
            end
            cb(out)
        end, serverId, channelId, text)
    end
end
