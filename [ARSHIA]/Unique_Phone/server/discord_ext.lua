-- ==========================================================================
-- Discord app v7 — server side (loaded AFTER server/main.lua, see
-- fxmanifest.lua). Uses the helpers main.lua already defines
-- (Discord_GetPlayer, Discord_IsMember, Discord_IsOwner, Discord_BroadcastToServerMembers,
-- Discord_Audit, ExecuteSql ...) and adds:
--   * automatic gang / job servers          * rich presence
--   * server boost + custom emoji slots     * paid VIP
--   * timeout / warn / auto-mod             * message reports -> staff queue
--   * XP + levels + leaderboard             * badges
--   * message search                        * unread counters
--   * per-server theme colour               * share image from gallery/camera
-- Config: Config.DiscordExt (config.lua).  SQL: sql/discord_v7.sql
-- ==========================================================================

local function cfg() return Config.DiscordExt end
local function Q(sql, params) return ExecuteSql(true, sql, params or {}) end
local function Exec(sql, params) return MySQL.Sync.execute(sql, params or {}) end
local function nowTs() return os.time() end
local function isStr(v) return type(v) == "string" end
local function isNonEmptyStr(v) return type(v) == "string" and v ~= "" end
local function truthy(v) return v == 1 or v == true end

local function notify(src, text, kind)
    if src then TriggerClientEvent('Unique_Phone:client:DiscordExt:Notice', src, { text = text, kind = kind or "info" }) end
end

local function safeIdent(s) return isStr(s) and s:match("^[%w_]+$") ~= nil end

-- Charges the configured account; returns true on success.
local function charge(xPlayer, amount)
    local account = cfg().MoneyAccount or 'bank'
    local acc = xPlayer.getAccount and xPlayer.getAccount(account)
    if acc == nil or (tonumber(acc.money) or 0) < amount then return false end
    xPlayer.removeAccountMoney(account, amount)
    return true
end

-- ---- permissions ---------------------------------------------------------

function Discord_IsAutoServer(serverId)
    if serverId == nil then return false end
    local r = Q("SELECT kind FROM phone_discord_servers WHERE id = @id", { ['@id'] = serverId })
    return r[1] ~= nil and isNonEmptyStr(r[1].kind)
end

local function getServerRow(serverId)
    return Q("SELECT * FROM phone_discord_servers WHERE id = @id", { ['@id'] = serverId })[1]
end

-- Moderation (timeout / warn / auto-mod words): server owner or server admin.
local function canModerate(identifier, serverId)
    return Discord_CanManageChannels(identifier, serverId) or Discord_ExtCan(identifier, serverId, 'moderate')
end

-- Configuration (theme, custom emoji, VIP): owner; on auto job servers (no
-- human owner) the job's admins do it.
local function canConfigure(identifier, serverId)
    if Discord_IsOwner(identifier, serverId) or Discord_ExtCan(identifier, serverId, 'manage_server') then return true end
    local s = getServerRow(serverId)
    return s ~= nil and s.kind == 'job' and Discord_IsAdmin(identifier, serverId)
end

-- ==========================================================================
-- 1) AUTOMATIC GANG / JOB SERVERS
-- ==========================================================================

local function nickFrom(row)
    local first, last = row.firstname, row.lastname
    if isNonEmptyStr(first) then
        return first .. (isNonEmptyStr(last) and (" " .. last) or "")
    end
    return "Player"
end

local function newInviteCode()
    for _ = 1, 8 do
        local code = Discord_GenerateInviteCode()
        if Q("SELECT id FROM phone_discord_servers WHERE invite_code = @c", { ['@c'] = code })[1] == nil then return code end
    end
    return Discord_GenerateInviteCode()
end

local function ensureAutoServer(key, kind, name, color, ownerIdentifier, verified, channels)
    local row = Q("SELECT id, owner_identifier FROM phone_discord_servers WHERE auto_key = @k", { ['@k'] = key })[1]
    if row then
        if row.owner_identifier ~= ownerIdentifier then
            Exec("UPDATE phone_discord_servers SET owner_identifier = @o WHERE id = @id", { ['@o'] = ownerIdentifier, ['@id'] = row.id })
        end
        return row.id
    end

    name = Discord_Utf8SafeSub(name, 40)
    local t = nowTs()
    local id = MySQL.Sync.insert([[INSERT INTO phone_discord_servers
        (name, icon_text, icon_color, owner_identifier, invite_code, created_at, is_verified, is_public, kind, auto_key)
        VALUES (@n, @i, @c, @o, @code, @t, @v, 0, @kind, @key)]], {
        ['@n'] = name, ['@i'] = Discord_IconText(name), ['@c'] = color, ['@o'] = ownerIdentifier,
        ['@code'] = newInviteCode(), ['@t'] = t, ['@v'] = verified and 1 or 0, ['@kind'] = kind, ['@key'] = key,
    })
    for pos, ch in ipairs(channels) do
        MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at, is_locked) VALUES (@s, @n, @p, @t, @l)", {
            ['@s'] = id, ['@n'] = ch.name, ['@p'] = pos - 1, ['@t'] = t, ['@l'] = ch.locked and 1 or 0,
        })
    end
    return id
end

-- desired: { [identifier] = { nick = "...", admin = bool } }
local function syncMembers(serverId, desired)
    local existing = Q("SELECT id, identifier, is_admin FROM phone_discord_members WHERE server_id = @s", { ['@s'] = serverId })
    local have, changed = {}, {}
    for _, m in ipairs(existing) do have[m.identifier] = m end

    local t = nowTs()
    for identifier, d in pairs(desired) do
        local m = have[identifier]
        if m == nil then
            MySQL.Sync.insert("INSERT IGNORE INTO phone_discord_members (server_id, identifier, nickname, joined_at, is_admin) VALUES (@s, @i, @n, @t, @a)", {
                ['@s'] = serverId, ['@i'] = identifier, ['@n'] = Discord_Utf8SafeSub(d.nick, 50), ['@t'] = t, ['@a'] = d.admin and 1 or 0,
            })
            changed[identifier] = true
        elseif truthy(m.is_admin) ~= (d.admin == true) then
            Exec("UPDATE phone_discord_members SET is_admin = @a WHERE id = @id", { ['@a'] = d.admin and 1 or 0, ['@id'] = m.id })
            changed[identifier] = true
        end
    end
    for identifier, m in pairs(have) do
        if desired[identifier] == nil then
            Exec("DELETE FROM phone_discord_members WHERE id = @id", { ['@id'] = m.id })
            changed[identifier] = true
        end
    end

    for identifier in pairs(changed) do
        local p = ESX.GetPlayerFromIdentifier(identifier)
        if p then TriggerClientEvent('Unique_Phone:client:DiscordExt:ServersChanged', p.source) end
    end
end

local function deleteAutoServer(row)
    local members = Q("SELECT identifier FROM phone_discord_members WHERE server_id = @s", { ['@s'] = row.id })
    Exec("DELETE FROM phone_discord_servers WHERE id = @id", { ['@id'] = row.id })
    for _, m in ipairs(members) do
        local p = ESX.GetPlayerFromIdentifier(m.identifier)
        if p then TriggerClientEvent('Unique_Phone:client:DiscordExt:ServersChanged', p.source) end
    end
end

local function syncGangs()
    local G = cfg().AutoServers.Gangs
    if not G or not G.Enabled then return end
    if not (safeIdent(G.GangsTable) and safeIdent(G.UserColumn) and safeIdent(G.GradeColumn)) then return end

    local okG, gangRows = pcall(Q, ("SELECT name, label FROM `%s`"):format(G.GangsTable), {})
    if not okG or gangRows == nil then return end
    local okU, userRows = pcall(Q, ("SELECT identifier, firstname, lastname, `%s` AS gang, `%s` AS grade FROM users WHERE `%s` IS NOT NULL AND `%s` <> ''"):format(
        G.UserColumn, G.GradeColumn, G.UserColumn, G.UserColumn), {})
    if not okU or userRows == nil then return end

    local excluded = {}
    for _, n in ipairs(G.Exclude or {}) do excluded[n] = true end

    local byGang, labels = {}, {}
    for _, g in ipairs(gangRows) do if g.name and not excluded[g.name] then labels[g.name] = g.label or g.name end end
    for _, u in ipairs(userRows) do
        if labels[u.gang] then
            byGang[u.gang] = byGang[u.gang] or {}
            table.insert(byGang[u.gang], u)
        end
    end

    for gangName, members in pairs(byGang) do
        local top = -1
        for _, u in ipairs(members) do top = math.max(top, tonumber(u.grade) or 0) end
        table.sort(members, function(a, b)
            local ga, gb = tonumber(a.grade) or 0, tonumber(b.grade) or 0
            if ga ~= gb then return ga > gb end
            return tostring(a.identifier) < tostring(b.identifier)
        end)
        local owner = members[1].identifier

        local desired = {}
        for _, u in ipairs(members) do
            desired[u.identifier] = { nick = nickFrom(u), admin = ((tonumber(u.grade) or 0) == top and u.identifier ~= owner) }
        end

        local sid = ensureAutoServer('gang:' .. gangName, 'gang', labels[gangName], G.IconColor or '#ED4245', owner, false, {
            { name = 'general' }, { name = 'planning' }, { name = 'media' },
        })
        syncMembers(sid, desired)
    end

    -- gangs that no longer exist
    if #gangRows > 0 then
        for _, row in ipairs(Q("SELECT id, auto_key FROM phone_discord_servers WHERE kind = 'gang'", {})) do
            local name = tostring(row.auto_key):gsub("^gang:", "")
            if labels[name] == nil and not excluded[name] then deleteAutoServer(row) end
        end
    end
end

local function syncJobs()
    local J = cfg().AutoServers.Jobs
    if not J or not J.Enabled then return end

    local okJ, jobRows = pcall(Q, "SELECT name, label FROM jobs", {})
    if not okJ or jobRows == nil then return end

    local excluded, included, includeAll = {}, {}, (J.Include == nil or #J.Include == 0)
    for _, n in ipairs(J.Exclude or {}) do excluded[n] = true end
    for _, n in ipairs(J.Include or {}) do included[n] = true end

    local jobs, quoted = {}, {}
    local off = J.OffDutyPrefix or 'off'
    local allNames = {}
    for _, j in ipairs(jobRows) do allNames[j.name] = true end
    for _, j in ipairs(jobRows) do
        -- 'offpolice' is only an off-duty variant when 'police' is itself a job
        local isVariant = off ~= '' and j.name:sub(1, #off) == off and allNames[j.name:sub(#off + 1)] == true
        if safeIdent(j.name) and not isVariant and not excluded[j.name] and (includeAll or included[j.name]) then
            jobs[j.name] = j.label or j.name
            table.insert(quoted, "'" .. j.name .. "'")
            table.insert(quoted, "'" .. off .. j.name .. "'")
        end
    end
    if #quoted == 0 then return end

    local userRows = Q(("SELECT identifier, firstname, lastname, job, job_grade FROM users WHERE job IN (%s)"):format(table.concat(quoted, ",")), {})
    local gradeRows = Q("SELECT job_name, MAX(grade) AS top FROM job_grades GROUP BY job_name", {})
    local topGrade = {}
    for _, g in ipairs(gradeRows or {}) do topGrade[g.job_name] = tonumber(g.top) or 0 end

    local byJob = {}
    for _, u in ipairs(userRows or {}) do
        local name = u.job
        if jobs[name] == nil and off ~= '' and name:sub(1, #off) == off then name = name:sub(#off + 1) end
        if jobs[name] then
            byJob[name] = byJob[name] or {}
            table.insert(byJob[name], u)
        end
    end

    for jobName, label in pairs(jobs) do
        local color = (J.Colors and J.Colors[jobName]) or J.IconColor or '#5865F2'
        local sid = ensureAutoServer('job:' .. jobName, 'job', label .. " | Official", color, 'auto:job:' .. jobName, true, {
            { name = 'announcements', locked = true }, { name = 'general' }, { name = 'dispatch' },
        })
        local desired = {}
        for _, u in ipairs(byJob[jobName] or {}) do
            desired[u.identifier] = { nick = nickFrom(u), admin = (tonumber(u.job_grade) or 0) >= (topGrade[jobName] or 9999) }
        end
        syncMembers(sid, desired)
        if Discord_ExtEnsureExtraChannels then Discord_ExtEnsureExtraChannels(sid, jobName) end -- v9: e.g. judge -> #court-docket
    end
end

local syncBusy, syncQueued = false, false
local function runAutoSync()
    if syncBusy then return end
    syncBusy = true
    local ok1, e1 = pcall(syncGangs)
    if not ok1 then print("[Unique_Phone] Discord gang sync failed: " .. tostring(e1)) end
    local ok2, e2 = pcall(syncJobs)
    if not ok2 then print("[Unique_Phone] Discord job sync failed: " .. tostring(e2)) end
    syncBusy = false
end

function Discord_QueueAutoSync(delayMs)
    if syncQueued then return end
    syncQueued = true
    CreateThread(function()
        Wait(delayMs or 3000)
        syncQueued = false
        runAutoSync()
    end)
end

CreateThread(function()
    Wait(12000) -- let oxmysql / the gang + job resources finish loading
    while true do
        runAutoSync()
        Wait((tonumber(cfg().AutoServers.SyncInterval) or 120) * 1000)
    end
end)

AddEventHandler('esx:setJob', function() Discord_QueueAutoSync(2000) end)
AddEventHandler('esx:playerLoaded', function() Discord_QueueAutoSync(6000) end)
RegisterServerEvent('For5M:SetGang') -- fired by Unique_ALLGangs when someone's gang changes
AddEventHandler('For5M:SetGang', function() Discord_QueueAutoSync(4000) end)

-- ==========================================================================
-- 2) RICH PRESENCE
-- ==========================================================================

local Presence = {} -- [source] = { veh = 'driving'|'riding', place = index }

RegisterServerEvent('Unique_Phone:server:Discord:Presence')
AddEventHandler('Unique_Phone:server:Discord:Presence', function(state)
    local src = source
    if type(state) ~= "table" then return end
    local st = {}
    if state.veh == 'driving' or state.veh == 'riding' then st.veh = state.veh end
    local idx = tonumber(state.place)
    if idx and cfg().Presence.Places[idx] then st.place = idx end
    Presence[src] = st
end)

AddEventHandler('playerDropped', function() Presence[source] = nil end)

function Discord_GetActivity(identifier)
    local P = cfg().Presence
    if not P or not P.Enabled then return nil end
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    if xPlayer == nil then return nil end

    local parts = {}
    local job = xPlayer.job
    if job and job.name then
        for _, dj in ipairs(P.DutyJobs or {}) do
            if dj == job.name then parts[#parts + 1] = "On duty · " .. (job.label or job.name) break end
        end
    end
    local st = Presence[xPlayer.source]
    if st then
        if st.place then parts[#parts + 1] = P.Places[st.place].label
        elseif st.veh == 'driving' then parts[#parts + 1] = P.DrivingText or "Driving"
        elseif st.veh == 'riding' then parts[#parts + 1] = P.RidingText or "Riding in a vehicle" end
    end
    if #parts == 0 then return nil end
    return table.concat(parts, " — ")
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetPresenceConfig', function(source, cb)
    local P = cfg().Presence
    local places = {}
    for i, p in ipairs(P.Places or {}) do
        places[i] = { x = p.coords.x, y = p.coords.y, z = p.coords.z, r = p.radius }
    end
    cb({ enabled = P.Enabled == true, places = places, every = P.CheckEveryMs or 5000 })
end)

-- ==========================================================================
-- 3) BOOST, CUSTOM EMOJI, THEME, VIP
-- ==========================================================================

local EmojiPool = {
    "😀","😂","🤣","😊","😍","😘","😎","🤔","😴","😭","😡","🥳","😇","🤗","😱","🙄","😏","🤯","🥶","🤡",
    "👍","👎","👏","🙏","💪","🤝","🙌","👋","🫡","✌️","🤞","👌","💯","🔥","❤️","💔","💎","⭐","⚡","🚀",
    "🎉","🎮","🚗","🏎️","🚓","🚑","🔫","💰","🍕","☕","🌹","🌙","☀️","🍀","💀","👑","🏆","🎯","📢","✅",
}
local EmojiPoolSet = {}
for _, e in ipairs(EmojiPool) do EmojiPoolSet[e] = true end

local function boostStats(serverId, identifier)
    local rows = Q("SELECT identifier, COUNT(*) AS c FROM phone_discord_boosts WHERE server_id = @s AND expires_at > @now GROUP BY identifier",
        { ['@s'] = serverId, ['@now'] = nowTs() })
    local total, mine = 0, 0
    for _, r in ipairs(rows) do
        total = total + r.c
        if r.identifier == identifier then mine = r.c end
    end
    return total, mine
end

local function boostLevel(count)
    local B = cfg().Boost
    local level, slots = 0, B.BaseEmojiSlots or 0
    for i, L in ipairs(B.Levels or {}) do
        if count >= L.boosts then level = i; slots = L.emojiSlots end
    end
    return level, slots
end

local function customEmojis(serverId)
    local out = {}
    for _, r in ipairs(Q("SELECT emoji FROM phone_discord_emojis WHERE server_id = @s ORDER BY id ASC", { ['@s'] = serverId })) do
        out[#out + 1] = r.emoji
    end
    return out
end

function Discord_ExtCustomEmojiAllowed(serverId, emoji)
    return Q("SELECT id FROM phone_discord_emojis WHERE server_id = @s AND emoji = @e", { ['@s'] = serverId, ['@e'] = emoji })[1] ~= nil
end

local function pushExtrasUpdated(serverId)
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', { serverId = serverId })
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetServerInfo', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    local s = getServerRow(serverId)
    if s == nil then cb(false) return end

    local B = cfg().Boost
    local total, mine = boostStats(serverId, xPlayer.identifier)
    local level, slots = boostLevel(total)
    local levels = {}
    for i, L in ipairs(B.Levels or {}) do levels[i] = { boosts = L.boosts, emojiSlots = L.emojiSlots, name = L.name } end

    local isAuto = isNonEmptyStr(s.kind)
    local configure = canConfigure(xPlayer.identifier, serverId)
    local info = {
        serverId = serverId,
        kind = isAuto and s.kind or nil,
        theme = s.theme_color,
        canModerate = canModerate(xPlayer.identifier, serverId) or Discord_IsStaff(source),
        canConfigure = configure,
        isOwner = Discord_IsOwner(xPlayer.identifier, serverId),
        boostCount = total, myBoosts = mine, maxBoosts = B.MaxPerPlayerPerServer or 2,
        boostPrice = B.Price, boostDays = B.Days, boostLevel = level, emojiSlots = slots, levels = levels,
        customEmojis = customEmojis(serverId),
        isFeatured = truthy(s.is_featured), vipUntil = s.vip_until,
    }
    Discord_ExtInfoExtras(xPlayer, source, serverId, s, info) -- v8: roles, perms, vanity, welcome, nickname
    if configure then info.emojiPool = EmojiPool end
    if configure and not isAuto then info.vipPlans = cfg().VIP.Plans end
    cb(info)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:Boost', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    local B = cfg().Boost
    local _, mine = boostStats(serverId, xPlayer.identifier)
    if mine >= (B.MaxPerPlayerPerServer or 2) then cb({ error = "MAX" }) return end
    if not charge(xPlayer, B.Price) then cb({ error = "NO_MONEY" }) return end

    local t = nowTs()
    MySQL.Sync.insert("INSERT INTO phone_discord_boosts (server_id, identifier, created_at, expires_at) VALUES (@s, @i, @t, @e)", {
        ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@t'] = t, ['@e'] = t + (B.Days or 30) * 86400,
    })
    pushExtrasUpdated(serverId)
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetTheme', function(source, cb, serverId, color)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canConfigure(xPlayer.identifier, serverId) then cb(false) return end
    if color == nil or color == "" then
        color = nil
    elseif not (isStr(color) and color:match("^#%x%x%x%x%x%x$")) then
        cb(false) return
    end
    Exec("UPDATE phone_discord_servers SET theme_color = @c WHERE id = @id", { ['@c'] = color, ['@id'] = serverId })
    pushExtrasUpdated(serverId)
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddEmoji', function(source, cb, serverId, emoji)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canConfigure(xPlayer.identifier, serverId) then cb(false) return end
    if not isStr(emoji) or not EmojiPoolSet[emoji] then cb(false) return end
    local total = boostStats(serverId, xPlayer.identifier)
    local _, slots = boostLevel(total)
    if #customEmojis(serverId) >= slots then cb({ error = "NO_SLOTS" }) return end
    Exec("INSERT IGNORE INTO phone_discord_emojis (server_id, emoji) VALUES (@s, @e)", { ['@s'] = serverId, ['@e'] = emoji })
    pushExtrasUpdated(serverId)
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RemoveEmoji', function(source, cb, serverId, emoji)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canConfigure(xPlayer.identifier, serverId) or not isStr(emoji) then cb(false) return end
    Exec("DELETE FROM phone_discord_emojis WHERE server_id = @s AND emoji = @e", { ['@s'] = serverId, ['@e'] = emoji })
    pushExtrasUpdated(serverId)
    cb(true)
end)

-- Paid VIP: makes the server show up in the Featured / VIP tab for N days.
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:BuyVIP', function(source, cb, serverId, planId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsOwner(xPlayer.identifier, serverId) or Discord_IsAutoServer(serverId) then cb(false) return end

    local plan
    for _, p in ipairs(cfg().VIP.Plans or {}) do if p.id == planId then plan = p end end
    if plan == nil then cb(false) return end
    if not charge(xPlayer, plan.price) then cb({ error = "NO_MONEY" }) return end

    local s = getServerRow(serverId)
    local base = math.max(nowTs(), tonumber(s.vip_until) or 0)
    local untilTs = base + plan.days * 86400
    Exec("UPDATE phone_discord_servers SET is_featured = 1, vip_until = @u WHERE id = @id", { ['@u'] = untilTs, ['@id'] = serverId })
    pushExtrasUpdated(serverId)
    cb({ ok = true, vipUntil = untilTs })
end)

CreateThread(function()
    Wait(20000)
    while true do
        Exec("UPDATE phone_discord_servers SET is_featured = 0, vip_until = NULL WHERE vip_until IS NOT NULL AND vip_until <= @now", { ['@now'] = nowTs() })
        Exec("DELETE FROM phone_discord_boosts WHERE expires_at <= @now", { ['@now'] = nowTs() })
        Wait(60000)
    end
end)

-- ==========================================================================
-- 4) AUTO-MOD, TIMEOUT, WARN
-- ==========================================================================

-- Folds Arabic/Persian letter variants, strips zero-width chars, tatweel and
-- harakat, lower-cases ASCII — so "ك" == "ک", "ي" == "ی" and "b a d" tricks
-- with ZWNJ don't slip past.
local strip = { "\u{200C}", "\u{200D}", "\u{200B}", "\u{0640}", "\u{200E}", "\u{200F}" }
for cp = 0x064B, 0x0652 do strip[#strip + 1] = utf8.char(cp) end
function Discord_ExtNormalize(s)
    s = tostring(s or "")
    for _, ch in ipairs(strip) do s = s:gsub(ch, "") end
    s = s:gsub("\u{064A}", "\u{06CC}"):gsub("\u{0649}", "\u{06CC}"):gsub("\u{0643}", "\u{06A9}")
    return s:lower()
end

local function escapePattern(s) return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end

local function wordHit(normText, normWord)
    if normWord == "" then return false end
    if normWord:match("^[%w_%-]+$") then -- latin word: whole-word match ("class" must not trip "ass")
        return normText:find("%f[%w]" .. escapePattern(normWord) .. "%f[%W]") ~= nil
    end
    return normText:find(normWord, 1, true) ~= nil
end

function Discord_ExtAutoModHit(serverId, text)
    local A = cfg().AutoMod
    if not A or not A.Enabled or not isStr(text) then return false end
    local norm = Discord_ExtNormalize(text)
    for _, w in ipairs(A.GlobalWords or {}) do
        if wordHit(norm, Discord_ExtNormalize(w)) then return true end
    end
    for _, r in ipairs(Q("SELECT word FROM phone_discord_automod WHERE server_id = @s", { ['@s'] = serverId })) do
        if wordHit(norm, Discord_ExtNormalize(r.word)) then return true end
    end
    return false
end

local function getTimeout(serverId, identifier)
    local t = Q("SELECT until_at, reason FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })[1]
    if t == nil then return nil end
    if tonumber(t.until_at) <= nowTs() then
        Exec("DELETE FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })
        return nil
    end
    return t
end

-- Called by SendMessage before inserting. Returns nil (ok) or an error table.
function Discord_ExtPreSend(xPlayer, src, serverId, message, channelId)
    local gate = Discord_ExtPermGate(xPlayer, src, serverId, channelId) -- v8: roles, stage, rules screening
    if gate then return gate end
    local t = getTimeout(serverId, xPlayer.identifier)
    if t then return { error = "TIMEOUT", untilAt = tonumber(t.until_at) } end
    if Discord_ExtAutoModHit(serverId, message) and not (Discord_CanManageChannels(xPlayer.identifier, serverId) or Discord_IsStaff(src)) then
        return { error = "AUTOMOD" }
    end
    return nil
end

local function applyTimeout(serverId, identifier, minutes, reason, byName)
    if minutes <= 0 then
        Exec("DELETE FROM phone_discord_timeouts WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })
        return nil
    end
    local untilTs = nowTs() + minutes * 60
    Exec("REPLACE INTO phone_discord_timeouts (server_id, identifier, until_at, reason, by_name) VALUES (@s, @i, @u, @r, @b)", {
        ['@s'] = serverId, ['@i'] = identifier, ['@u'] = untilTs, ['@r'] = Discord_Utf8SafeSub(reason or "", 120), ['@b'] = Discord_Utf8SafeSub(byName or "", 60),
    })
    return untilTs
end

local function minutesAllowed(m)
    if m == 0 then return true end
    for _, v in ipairs(cfg().Moderation.TimeoutMinutes or {}) do if v == m then return true end end
    return false
end

-- Loads a member row and checks the actor may act on it.
local function moderationTarget(xPlayer, serverId, memberRowId)
    if serverId == nil or memberRowId == nil or not canModerate(xPlayer.identifier, serverId) then return nil end
    local t = Q([[SELECT m.id, m.identifier, m.nickname, m.is_admin, s.owner_identifier
                  FROM phone_discord_members m JOIN phone_discord_servers s ON s.id = m.server_id
                  WHERE m.id = @id AND m.server_id = @s]], { ['@id'] = memberRowId, ['@s'] = serverId })[1]
    if t == nil or t.identifier == xPlayer.identifier or t.identifier == t.owner_identifier then return nil end
    if truthy(t.is_admin) and not Discord_IsOwner(xPlayer.identifier, serverId) then return nil end
    return t
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:Timeout', function(source, cb, serverId, memberRowId, minutes, reason)
    local xPlayer = Discord_GetPlayer(source)
    minutes = tonumber(minutes)
    if xPlayer == nil or minutes == nil or not minutesAllowed(minutes) then cb(false) return end
    local t = moderationTarget(xPlayer, serverId, memberRowId)
    if t == nil then cb(false) return end

    local untilTs = applyTimeout(serverId, t.identifier, minutes, reason, Discord_GetDisplayName(source))
    local server = getServerRow(serverId)
    local target = ESX.GetPlayerFromIdentifier(t.identifier)
    if target then
        notify(target.source, untilTs and ("You were timed out in " .. server.name .. " for " .. minutes .. " min.") or ("Your timeout in " .. server.name .. " was lifted."), untilTs and "warn" or "info")
    end
    cb({ ok = true, untilAt = untilTs })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:Warn', function(source, cb, serverId, memberRowId, reason)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end
    local t = moderationTarget(xPlayer, serverId, memberRowId)
    if t == nil then cb(false) return end

    reason = isStr(reason) and Discord_Utf8SafeSub(reason, 120) or ""
    local by = Discord_GetDisplayName(source)
    MySQL.Sync.insert("INSERT INTO phone_discord_warns (server_id, identifier, reason, by_name, created_at) VALUES (@s, @i, @r, @b, @t)", {
        ['@s'] = serverId, ['@i'] = t.identifier, ['@r'] = reason, ['@b'] = by, ['@t'] = nowTs(),
    })
    local count = Q("SELECT COUNT(*) AS c FROM phone_discord_warns WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = t.identifier })[1].c

    local M = cfg().Moderation
    local auto = false
    if (M.AutoTimeoutAtWarns or 0) > 0 and count % M.AutoTimeoutAtWarns == 0 then
        applyTimeout(serverId, t.identifier, M.AutoTimeoutMinutes or 60, "Auto: " .. count .. " warns", "Auto-mod")
        auto = true
    end

    local server = getServerRow(serverId)
    local target = ESX.GetPlayerFromIdentifier(t.identifier)
    if target then
        notify(target.source, ("Warning in %s (#%d)%s"):format(server.name, count, reason ~= "" and (": " .. reason) or ""), "warn")
    end
    cb({ ok = true, count = count, autoTimeout = auto })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ClearWarns', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end
    local t = moderationTarget(xPlayer, serverId, memberRowId)
    if t == nil then cb(false) return end
    Exec("DELETE FROM phone_discord_warns WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = t.identifier })
    cb(true)
end)

-- Everything the moderation popup needs about one member.
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMemberMod', function(source, cb, serverId, memberRowId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end
    local t = moderationTarget(xPlayer, serverId, memberRowId)
    if t == nil then cb(false) return end

    local warns = Q("SELECT reason, by_name, created_at FROM phone_discord_warns WHERE server_id = @s AND identifier = @i ORDER BY id DESC LIMIT 10",
        { ['@s'] = serverId, ['@i'] = t.identifier })
    local count = Q("SELECT COUNT(*) AS c FROM phone_discord_warns WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = t.identifier })[1].c
    local to = getTimeout(serverId, t.identifier)
    cb({
        nickname = t.nickname, warnCount = count, warns = warns,
        timeoutUntil = to and tonumber(to.until_at) or nil,
        minutes = cfg().Moderation.TimeoutMinutes,
    })
end)

-- Per-server banned words
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetAutoMod', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canModerate(xPlayer.identifier, serverId) then cb(false) return end
    local words = {}
    for _, r in ipairs(Q("SELECT word FROM phone_discord_automod WHERE server_id = @s ORDER BY id ASC", { ['@s'] = serverId })) do words[#words + 1] = r.word end
    cb({ words = words, max = cfg().AutoMod.MaxWordsPerServer or 40 })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AddAutoModWord', function(source, cb, serverId, word)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canModerate(xPlayer.identifier, serverId) or not isStr(word) then cb(false) return end
    word = Discord_Utf8SafeSub((word:gsub("^%s+", ""):gsub("%s+$", "")), 40)
    if #word < 2 then cb(false) return end
    local n = Q("SELECT COUNT(*) AS c FROM phone_discord_automod WHERE server_id = @s", { ['@s'] = serverId })[1].c
    if n >= (cfg().AutoMod.MaxWordsPerServer or 40) then cb({ error = "FULL" }) return end
    Exec("INSERT IGNORE INTO phone_discord_automod (server_id, word) VALUES (@s, @w)", { ['@s'] = serverId, ['@w'] = word })
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RemoveAutoModWord', function(source, cb, serverId, word)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not canModerate(xPlayer.identifier, serverId) or not isStr(word) then cb(false) return end
    Exec("DELETE FROM phone_discord_automod WHERE server_id = @s AND word = @w", { ['@s'] = serverId, ['@w'] = word })
    cb(true)
end)

-- ==========================================================================
-- 5) REPORTS  ->  staff queue
-- ==========================================================================

local ReportCooldown = {}

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:Report', function(source, cb, messageId, reason)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or messageId == nil then cb(false) return end

    local last = ReportCooldown[xPlayer.identifier] or 0
    if nowTs() - last < (cfg().Moderation.ReportCooldownSeconds or 20) then cb({ error = "COOLDOWN" }) return end

    local authorIdentifier, serverId = Discord_GetMessageOwnerAndServer(messageId)
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    if authorIdentifier == xPlayer.identifier then cb({ error = "SELF" }) return end

    local m = Q("SELECT channel_id, author_name, message FROM phone_discord_messages WHERE id = @id", { ['@id'] = messageId })[1]
    if m == nil then cb(false) return end

    local inserted = MySQL.Sync.execute([[INSERT IGNORE INTO phone_discord_reports
        (server_id, channel_id, message_id, message_text, author_identifier, author_name, reporter_identifier, reporter_name, reason, created_at)
        VALUES (@s, @c, @m, @t, @ai, @an, @ri, @rn, @r, @now)]], {
        ['@s'] = serverId, ['@c'] = m.channel_id, ['@m'] = messageId, ['@t'] = Discord_Utf8SafeSub(m.message, 400),
        ['@ai'] = authorIdentifier, ['@an'] = m.author_name, ['@ri'] = xPlayer.identifier, ['@rn'] = Discord_GetDisplayName(source),
        ['@r'] = isStr(reason) and Discord_Utf8SafeSub(reason, 150) or "", ['@now'] = nowTs(),
    })
    if (tonumber(inserted) or 0) == 0 then cb({ error = "DUP" }) return end
    ReportCooldown[xPlayer.identifier] = nowTs()

    for _, pid in ipairs(GetPlayers()) do
        local id = tonumber(pid)
        if id and Discord_IsStaff(id) then notify(id, "New Discord message report in the queue.", "warn") end
    end
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:StaffReports', function(source, cb, status)
    if not Discord_IsStaff(source) then cb(false) return end
    if status ~= 'pending' and status ~= 'dismissed' and status ~= 'removed' then status = 'pending' end
    local rows = Q([[SELECT r.id, r.message_id, r.message_text, r.author_name, r.reporter_name, r.reason, r.status, r.created_at, r.handled_by,
                            s.name AS server_name, c.name AS channel_name
                     FROM phone_discord_reports r
                     LEFT JOIN phone_discord_servers s ON s.id = r.server_id
                     LEFT JOIN phone_discord_channels c ON c.id = r.channel_id
                     WHERE r.status = @st ORDER BY r.id DESC LIMIT 100]], { ['@st'] = status })
    local pending = Q("SELECT COUNT(*) AS c FROM phone_discord_reports WHERE status = 'pending'")[1].c
    cb({ reports = rows, pending = pending })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:StaffResolveReport', function(source, cb, reportId, action)
    if not Discord_IsStaff(source) then cb(false) return end
    if action ~= 'dismiss' and action ~= 'delete' and action ~= 'delete_warn' then cb(false) return end
    local r = Q("SELECT * FROM phone_discord_reports WHERE id = @id", { ['@id'] = reportId })[1]
    if r == nil or r.status ~= 'pending' then cb(false) return end

    local by = Discord_GetDisplayName(source)
    local t = nowTs()
    if action == 'dismiss' then
        Exec("UPDATE phone_discord_reports SET status = 'dismissed', handled_by = @b, handled_at = @t WHERE message_id = @m AND status = 'pending'",
            { ['@b'] = by, ['@t'] = t, ['@m'] = r.message_id })
    else
        if Q("SELECT id FROM phone_discord_messages WHERE id = @id", { ['@id'] = r.message_id })[1] then
            Exec("DELETE FROM phone_discord_messages WHERE id = @id", { ['@id'] = r.message_id })
            Discord_BroadcastToServerMembers(r.server_id, 'Unique_Phone:client:Discord:MessageDeleted', { serverId = r.server_id, messageId = r.message_id })
        end
        Exec("UPDATE phone_discord_reports SET status = 'removed', handled_by = @b, handled_at = @t WHERE message_id = @m AND status = 'pending'",
            { ['@b'] = by, ['@t'] = t, ['@m'] = r.message_id })
        if action == 'delete_warn' then
            MySQL.Sync.insert("INSERT INTO phone_discord_warns (server_id, identifier, reason, by_name, created_at) VALUES (@s, @i, @r, @b, @t)", {
                ['@s'] = r.server_id, ['@i'] = r.author_identifier, ['@r'] = "Reported message removed", ['@b'] = by, ['@t'] = t,
            })
            local target = ESX.GetPlayerFromIdentifier(r.author_identifier)
            if target then notify(target.source, "A message of yours was removed after a report, and you received a warning.", "warn") end
        end
    end
    Discord_Audit(source, "Report #" .. reportId .. " -> " .. action, "message #" .. tostring(r.message_id))
    cb(true)
end)

-- ==========================================================================
-- 6) XP / LEVELS / LEADERBOARD / BADGES
-- ==========================================================================

local function needFor(level)
    local X = cfg().XP
    return (X.BaseToLevel or 100) + (X.Step or 50) * level
end

function Discord_ExtLevelFromXp(xp)
    local lvl, rem = 0, tonumber(xp) or 0
    while lvl < 500 and rem >= needFor(lvl) do
        rem = rem - needFor(lvl)
        lvl = lvl + 1
    end
    return lvl, rem, needFor(lvl)
end

local LevelCache = {}

-- Called by SendMessage after the row is inserted.
function Discord_ExtPostSend(xPlayer, src, serverId, channelId, messageId, message)
    local roleMentions = Discord_ExtHandleRoleMentions(xPlayer, src, serverId, messageId, message) -- v8
    local X, t = cfg().XP, nowTs()
    local gain = math.random(X.Min or 15, X.Max or 25)
    local key = serverId .. ":" .. xPlayer.identifier

    MySQL.Async.execute("INSERT INTO phone_discord_monthly (server_id, identifier, ym, cnt) VALUES (@s, @i, @ym, 1) ON DUPLICATE KEY UPDATE cnt = cnt + 1", {
        ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@ym'] = tonumber(os.date('%Y%m')),
    })
    MySQL.Async.execute([[INSERT INTO phone_discord_xp (server_id, identifier, xp, messages, last_xp_at) VALUES (@s, @i, @g, 1, @t)
        ON DUPLICATE KEY UPDATE messages = messages + 1,
            xp = xp + IF(@t - last_xp_at >= @cd, @g, 0),
            last_xp_at = IF(@t - last_xp_at >= @cd, @t, last_xp_at)]], {
        ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@g'] = gain, ['@t'] = t, ['@cd'] = X.CooldownSeconds or 20,
    }, function()
        MySQL.Async.fetchAll("SELECT xp FROM phone_discord_xp WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = xPlayer.identifier }, function(rows)
            if not rows or not rows[1] then return end
            local lvl = Discord_ExtLevelFromXp(rows[1].xp)
            local prev = LevelCache[key]
            LevelCache[key] = lvl
            if prev ~= nil and lvl > prev then
                local s = getServerRow(serverId)
                notify(src, ("Level up! You reached level %d in %s."):format(lvl, s and s.name or "the server"), "success")
            end
        end)
    end)
    return roleMentions
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetLeaderboard', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end

    local rows = Q([[SELECT x.identifier, x.xp, x.messages, m.nickname
                     FROM phone_discord_xp x
                     JOIN phone_discord_members m ON m.server_id = x.server_id AND m.identifier = x.identifier
                     WHERE x.server_id = @s ORDER BY x.xp DESC LIMIT 15]], { ['@s'] = serverId })
    local list = {}
    for i, r in ipairs(rows) do
        local lvl, into, need = Discord_ExtLevelFromXp(r.xp)
        list[i] = { rank = i, name = r.nickname, xp = r.xp, messages = r.messages, level = lvl, mine = (r.identifier == xPlayer.identifier) }
    end

    local me = Q("SELECT xp, messages FROM phone_discord_xp WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })[1] or { xp = 0, messages = 0 }
    local rank = Q("SELECT COUNT(*) + 1 AS r FROM phone_discord_xp WHERE server_id = @s AND xp > @x", { ['@s'] = serverId, ['@x'] = me.xp })[1].r
    local lvl, into, need = Discord_ExtLevelFromXp(me.xp)
    cb({ list = list, me = { xp = me.xp, messages = me.messages, level = lvl, into = into, need = need, rank = rank } })
end)

-- level + badges for every member row of a server, keyed by member row id
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMemberMeta', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end

    local s = getServerRow(serverId)
    local members = Q("SELECT id, identifier FROM phone_discord_members WHERE server_id = @s", { ['@s'] = serverId })
    local xpBy, badgeBy, boosters = {}, {}, {}
    for _, r in ipairs(Q("SELECT identifier, xp FROM phone_discord_xp WHERE server_id = @s", { ['@s'] = serverId })) do xpBy[r.identifier] = r.xp end
    for _, r in ipairs(Q("SELECT identifier, badge FROM phone_discord_badges WHERE server_id = @s", { ['@s'] = serverId })) do
        badgeBy[r.identifier] = badgeBy[r.identifier] or {}
        table.insert(badgeBy[r.identifier], r.badge)
    end
    for _, r in ipairs(Q("SELECT DISTINCT identifier FROM phone_discord_boosts WHERE server_id = @s AND expires_at > @now", { ['@s'] = serverId, ['@now'] = nowTs() })) do
        boosters[r.identifier] = true
    end

    local levelBadges = cfg().LevelBadges or {}
    local topRole = Discord_ExtMemberRoleMap(serverId) -- v8: coloured names
    local meta = {}
    for _, m in ipairs(members) do
        local lvl = Discord_ExtLevelFromXp(xpBy[m.identifier] or 0)
        local badges = {}
        if s and s.owner_identifier == m.identifier then badges[#badges + 1] = 'founder' end
        for _, b in ipairs(badgeBy[m.identifier] or {}) do badges[#badges + 1] = b end
        if boosters[m.identifier] then badges[#badges + 1] = 'booster' end
        local bestThreshold, bestBadge = 0, nil
        for threshold, badge in pairs(levelBadges) do
            if lvl >= threshold and threshold > bestThreshold then bestThreshold, bestBadge = threshold, badge end
        end
        if bestBadge then badges[#badges + 1] = bestBadge end
        local tr = topRole[m.identifier]
        meta[tostring(m.id)] = { level = lvl, badges = badges, color = tr and tr.color or nil }
    end

    local defs = {}
    for key, d in pairs(cfg().Badges or {}) do defs[key] = { icon = d.icon, label = d.label } end
    cb({ meta = meta, defs = defs })
end)

-- Background awards: "first member" (once per normal server) and "top chatter" (monthly).
local TopChatterDone = {}
local function prevMonthKey()
    local d = os.date('*t')
    local y, m = d.year, d.month - 1
    if m == 0 then y, m = y - 1, 12 end
    return y * 100 + m
end

CreateThread(function()
    Wait(30000)
    while true do
        pcall(function()
            for _, s in ipairs(Q([[SELECT s.id, s.owner_identifier FROM phone_discord_servers s
                                   WHERE s.kind IS NULL AND NOT EXISTS
                                     (SELECT 1 FROM phone_discord_badges b WHERE b.server_id = s.id AND b.badge = 'first_member')]])) do
                local first = Q("SELECT identifier FROM phone_discord_members WHERE server_id = @s AND identifier <> @o ORDER BY joined_at ASC, id ASC LIMIT 1",
                    { ['@s'] = s.id, ['@o'] = s.owner_identifier })[1]
                if first then
                    Exec("INSERT IGNORE INTO phone_discord_badges (server_id, identifier, badge, awarded_at) VALUES (@s, @i, 'first_member', @t)",
                        { ['@s'] = s.id, ['@i'] = first.identifier, ['@t'] = nowTs() })
                end
            end

            local pm = prevMonthKey()
            for _, s in ipairs(Q("SELECT id FROM phone_discord_servers")) do
                local key = pm .. ":" .. s.id
                if not TopChatterDone[key] then
                    TopChatterDone[key] = true
                    local top = Q("SELECT identifier, cnt FROM phone_discord_monthly WHERE server_id = @s AND ym = @ym ORDER BY cnt DESC LIMIT 1",
                        { ['@s'] = s.id, ['@ym'] = pm })[1]
                    if top and top.cnt >= (cfg().TopChatterMinMessages or 10) then
                        Exec("DELETE FROM phone_discord_badges WHERE server_id = @s AND badge = 'top_chatter'", { ['@s'] = s.id })
                        Exec("INSERT IGNORE INTO phone_discord_badges (server_id, identifier, badge, note, awarded_at) VALUES (@s, @i, 'top_chatter', @n, @t)",
                            { ['@s'] = s.id, ['@i'] = top.identifier, ['@n'] = tostring(pm), ['@t'] = nowTs() })
                    end
                end
            end
            Exec("DELETE FROM phone_discord_monthly WHERE ym < @old", { ['@old'] = prevMonthKey() - 300 })
        end)
        Wait(10 * 60 * 1000)
    end
end)

-- ==========================================================================
-- 7) SEARCH
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:Search', function(source, cb, serverId, channelId, query)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) or not isStr(query) then cb(false) return end
    query = Discord_Utf8SafeSub((query:gsub("^%s+", ""):gsub("%s+$", "")), 40)
    if (utf8.len(query) or #query) < 2 then cb({}) return end
    local like = "%" .. query:gsub("[\\%%_]", "\\%0") .. "%"

    local viewSet, viewList = Discord_ExtViewableSet(xPlayer.identifier, serverId, source) -- v8: only channels you may read
    if #viewList == 0 then cb({}) return end

    local sql = [[SELECT m.id, m.channel_id, c.name AS channel_name, m.author_name, m.message, m.created_at
                  FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id
                  WHERE c.server_id = @s AND m.message LIKE @q]]
    local params = { ['@s'] = serverId, ['@q'] = like }
    if tonumber(channelId) and tonumber(channelId) > 0 then
        if not viewSet[tonumber(channelId)] then cb({}) return end
        sql = sql .. " AND m.channel_id = @c"
        params['@c'] = tonumber(channelId)
    else
        local ids = {}
        for _, id in ipairs(viewList) do ids[#ids + 1] = tostring(math.floor(id)) end
        sql = sql .. " AND m.channel_id IN (" .. table.concat(ids, ",") .. ")"
    end
    sql = sql .. " ORDER BY m.id DESC LIMIT 40"

    local rows = Q(sql, params)
    for _, r in ipairs(rows) do r.message = Discord_Utf8SafeSub(r.message, 160) end
    cb(rows)
end)

-- ==========================================================================
-- 8) UNREAD COUNTERS
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetUnread', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end
    local id = xPlayer.identifier

    -- channels never opened before start "read" at their current last message
    Exec([[INSERT IGNORE INTO phone_discord_seen (identifier, channel_id, last_id)
           SELECT @id, c.id, COALESCE((SELECT MAX(m.id) FROM phone_discord_messages m WHERE m.channel_id = c.id), 0)
           FROM phone_discord_channels c
           JOIN phone_discord_members mem ON mem.server_id = c.server_id AND mem.identifier = @id]], { ['@id'] = id })

    local rows = Q([[SELECT c.id AS channelId, c.server_id AS serverId, COUNT(m.id) AS cnt
                     FROM phone_discord_channels c
                     JOIN phone_discord_members mem ON mem.server_id = c.server_id AND mem.identifier = @id
                     JOIN phone_discord_seen s ON s.channel_id = c.id AND s.identifier = @id
                     JOIN phone_discord_messages m ON m.channel_id = c.id AND m.id > s.last_id AND m.identifier <> @id
                     GROUP BY c.id, c.server_id]], { ['@id'] = id })
    local viewCache, out = {}, {}
    for _, r in ipairs(rows) do
        if viewCache[r.serverId] == nil then viewCache[r.serverId] = Discord_ExtViewableSet(id, r.serverId, source) end
        if viewCache[r.serverId][r.channelId] then out[#out + 1] = r end
    end
    cb(out)
end)

RegisterServerEvent('Unique_Phone:server:DiscordExt:MarkSeen')
AddEventHandler('Unique_Phone:server:DiscordExt:MarkSeen', function(channelId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    channelId = tonumber(channelId)
    if xPlayer == nil or channelId == nil then return end
    local serverId = Discord_GetServerIdForChannel(channelId)
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then return end
    Exec([[REPLACE INTO phone_discord_seen (identifier, channel_id, last_id)
           VALUES (@id, @c, COALESCE((SELECT MAX(id) FROM phone_discord_messages WHERE channel_id = @c), 0))]],
        { ['@id'] = xPlayer.identifier, ['@c'] = channelId })
end)

-- ==========================================================================
-- 9) SHARE (gallery / camera -> a Discord channel)
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetShareTargets', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end
    local servers = Q([[SELECT s.id, s.name FROM phone_discord_servers s
                        JOIN phone_discord_members m ON m.server_id = s.id WHERE m.identifier = @i ORDER BY s.id]], { ['@i'] = xPlayer.identifier })
    local out = {}
    for _, s in ipairs(servers) do
        local chans = Discord_ExtSendableChannels(xPlayer, source, s.id) -- v8: roles / locks / stage rules
        if #chans > 0 then out[#out + 1] = { id = s.id, name = s.name, channels = chans } end
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ShareImage', function(source, cb, channelId, url, caption)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or not isStr(url) then cb(false) return end
    if #url > 500 or not url:match("^https?://") or url:find("[%s\"'<>]") then cb({ error = "BAD_URL" }) return end

    if Q("SELECT logged_in FROM phone_discord_accounts WHERE identifier = @i", { ['@i'] = xPlayer.identifier })[1] == nil then
        cb({ error = "NO_ACCOUNT" }) return
    end

    local serverId = Discord_GetServerIdForChannel(tonumber(channelId))
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end

    local lock = Q("SELECT is_locked FROM phone_discord_channels WHERE id = @c", { ['@c'] = channelId })[1]
    if lock and truthy(lock.is_locked) and not (canModerate(xPlayer.identifier, serverId) or Discord_IsStaff(source)) then
        cb({ error = "LOCKED" }) return
    end

    caption = isStr(caption) and Discord_Utf8SafeSub((caption:gsub("^%s+", ""):gsub("%s+$", "")), cfg().Share.MaxCaptionLength or 200) or ""
    local message = (caption ~= "" and (caption .. " ") or "") .. url

    local blocked = Discord_ExtPreSend(xPlayer, source, serverId, caption, tonumber(channelId))
    if blocked then cb(blocked) return end

    local authorName, createdAt = Discord_ExtAuthorName(xPlayer, source, serverId), nowTs()
    local newId = MySQL.Sync.insert("INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at) VALUES (@c, @i, @n, @m, @t)", {
        ['@c'] = channelId, ['@i'] = xPlayer.identifier, ['@n'] = authorName, ['@m'] = message, ['@t'] = createdAt,
    })
    local roleMentions = Discord_ExtPostSend(xPlayer, source, serverId, tonumber(channelId), newId, message)

    local member = Q("SELECT id FROM phone_discord_members WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })[1]
    local profile = Discord_EnsureProfile(xPlayer.identifier)
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:Discord:NewMessage', {
        id = newId, serverId = serverId, channelId = tonumber(channelId), author_name = authorName, message = message,
        created_at = createdAt, authorVerified = truthy(profile and profile.verified), authorMemberId = member and member.id,
        roleMentions = roleMentions,
    }, source)
    cb({ ok = true })
end)
