-- ==========================================================================
-- Discord app v9 — bridge for other resources (loaded AFTER discord_ext2.lua).
-- esx_uniquejobs (DOJ / law / CAD) talks to the phone only through these
-- exports, so the two resources stay independent:
--
--   exports['Unique_Phone']:DiscordPostToJob(job, channelName, text, label)
--   exports['Unique_Phone']:DiscordNotifyIdentifiers({ identifiers }, text, kind)
--   exports['Unique_Phone']:DiscordNotifyJobs({ jobs }, text, kind)
--   exports['Unique_Phone']:DiscordExportEvidence(requesterSource, identifier, opts)
-- ==========================================================================

local function cfg() return Config.DiscordExt end
local function Q(sql, params) return ExecuteSql(true, sql, params or {}) end
local function Exec(sql, params) return MySQL.Sync.execute(sql, params or {}) end
local function nowTs() return os.time() end
local function isStr(v) return type(v) == "string" end
local function truthy(v) return v == 1 or v == true end

local function notify(src, text, kind)
    TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', src, { text = text, kind = kind or "info" })
end

-- --------------------------------------------------------------------------
-- Job server channels
-- --------------------------------------------------------------------------

local function jobServerId(jobName)
    local r = Q("SELECT id FROM phone_discord_servers WHERE auto_key = @k", { ['@k'] = 'job:' .. tostring(jobName) })[1]
    return r and r.id or nil
end

-- Finds a channel by name inside a server, creating it (read-only for members) when missing.
local function ensureChannel(serverId, channelName, locked)
    channelName = string.lower((tostring(channelName):gsub("%s+", "-")))
    local c = Q("SELECT id FROM phone_discord_channels WHERE server_id = @s AND name = @n", { ['@s'] = serverId, ['@n'] = channelName })[1]
    if c then return c.id, false end
    local pos = (Q("SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = @s", { ['@s'] = serverId })[1] or {}).c or 0
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at, is_locked, kind) VALUES (@s, @n, @p, @t, @l, 'text')", {
        ['@s'] = serverId, ['@n'] = channelName, ['@p'] = pos, ['@t'] = nowTs(), ['@l'] = locked and 1 or 0,
    })
    return id, true
end

-- Called by the job-server sync (discord_ext.lua) so configured extra channels always exist.
function Discord_ExtEnsureExtraChannels(serverId, jobName)
    local extra = (cfg().Gov and cfg().Gov.ExtraChannels or {})[jobName]
    if not extra then return end
    local created = false
    for _, ch in ipairs(extra) do
        local _, isNew = ensureChannel(serverId, ch.name, ch.locked ~= false)
        created = created or isNew
    end
    if created then
        Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId, channels = true })
    end
end

-- Posts a read-only system message into <job>'s official server. Returns true when it was posted.
exports('DiscordPostToJob', function(jobName, channelName, text, label)
    if not isStr(jobName) or not isStr(channelName) or not isStr(text) then return false end
    local serverId = jobServerId(jobName)
    if not serverId then return false end
    local channelId = ensureChannel(serverId, channelName, true)
    text = Discord_Utf8SafeSub(text, 900)
    label = Discord_Utf8SafeSub(isStr(label) and label ~= "" and label or "System", 40)
    local t = nowTs()
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at, is_announcement) VALUES (@c, 'system', @n, @m, @t, 1)", {
        ['@c'] = channelId, ['@n'] = label, ['@m'] = text, ['@t'] = t,
    })
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:NewMessage', {
        id = id, serverId = serverId, channelId = channelId, author_name = label, message = text, created_at = t,
        isAnnouncement = true, authorVerified = true,
    })
    return true
end)

exports('DiscordNotifyIdentifiers', function(identifiers, text, kind)
    local sent = 0
    if type(identifiers) ~= "table" or not isStr(text) then return 0 end
    for _, identifier in ipairs(identifiers) do
        local p = ESX.GetPlayerFromIdentifier(identifier)
        if p then notify(p.source, text, kind); sent = sent + 1 end
    end
    return sent
end)

exports('DiscordNotifyJobs', function(jobs, text, kind)
    local set = {}
    for _, j in ipairs(jobs or {}) do set[j] = true end
    local sent = 0
    for _, pid in ipairs(GetPlayers()) do
        local p = ESX.GetPlayerFromId(tonumber(pid))
        if p and p.job and set[p.job.name] then notify(p.source, text, kind); sent = sent + 1 end
    end
    return sent
end)

-- --------------------------------------------------------------------------
-- Evidence export (called by esx_uniquejobs AFTER it validated the warrant)
-- --------------------------------------------------------------------------

-- 64-bit FNV-1a over the exported text: an integrity fingerprint (not cryptographic) shown on the evidence record.
local function fingerprint(str)
    local h = 0xcbf29ce484222325
    for i = 1, #str do
        h = h ~ str:byte(i)
        h = h * 0x100000001b3
    end
    return string.format("%016x", h)
end

exports('DiscordExportEvidence', function(requesterSource, identifier, opts)
    opts = type(opts) == "table" and opts or {}
    if not isStr(identifier) or identifier == "" then return { ok = false, error = "BAD_TARGET" } end

    local G = cfg().Gov or {}
    local days = math.max(1, math.min(tonumber(opts.sinceDays) or G.ExportDays or 30, 365))
    local limit = math.max(10, math.min(tonumber(opts.maxMessages) or G.ExportMaxMessages or 300, 1000))
    local since = nowTs() - days * 86400

    local servers = Q([[SELECT s.id, s.name, s.kind, m.nickname, m.joined_at FROM phone_discord_members m
                        JOIN phone_discord_servers s ON s.id = m.server_id WHERE m.identifier = @i ORDER BY s.id]], { ['@i'] = identifier })
    if #servers == 0 then return { ok = true, empty = true, servers = {}, messages = {}, total = 0, days = days, checksum = fingerprint("") } end

    local rows = Q([[SELECT m.id, m.created_at, m.message, c.name AS channel, s.name AS server, s.id AS server_id
                     FROM phone_discord_messages m
                     JOIN phone_discord_channels c ON c.id = m.channel_id
                     JOIN phone_discord_servers s ON s.id = c.server_id
                     WHERE m.identifier = @i AND m.is_announcement = 0 AND m.created_at >= @since
                     ORDER BY m.id DESC LIMIT @lim]], { ['@i'] = identifier, ['@since'] = since, ['@lim'] = limit + 1 })

    local truncated = #rows > limit
    if truncated then rows[#rows] = nil end
    -- oldest first, like a transcript
    local messages, parts = {}, {}
    for i = #rows, 1, -1 do
        local r = rows[i]
        messages[#messages + 1] = { id = r.id, at = r.created_at, server = r.server, channel = r.channel, text = Discord_Utf8SafeSub(r.message, 500) }
        parts[#parts + 1] = r.id .. "|" .. r.created_at .. "|" .. r.server .. "|" .. r.channel .. "|" .. r.message
    end

    local outServers = {}
    for _, s in ipairs(servers) do outServers[#outServers + 1] = { name = s.name, kind = s.kind, nickname = s.nickname, joinedAt = s.joined_at } end
    local checksum = fingerprint(table.concat(parts, "\n"))

    local by = requesterSource and Discord_GetDisplayName(requesterSource) or "?"
    Exec("INSERT INTO phone_discord_evidence_log (suspect_identifier, requested_by, warrant_ref, case_ref, msg_count, checksum, created_at) VALUES (@i, @b, @w, @c, @n, @h, @t)", {
        ['@i'] = identifier, ['@b'] = by, ['@w'] = tostring(opts.warrantRef or ""), ['@c'] = tostring(opts.caseRef or ""), ['@n'] = #messages, ['@h'] = checksum, ['@t'] = nowTs(),
    })
    if requesterSource then
        Discord_Audit(requesterSource, "Warrant evidence export (" .. #messages .. " msgs, " .. tostring(opts.warrantRef or "?") .. ")", identifier)
    end

    return { ok = true, servers = outServers, messages = messages, total = #messages, truncated = truncated, days = days, checksum = checksum, exportedAt = nowTs() }
end)
