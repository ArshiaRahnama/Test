-- ==========================================================================
-- Discord app v8 — server side (loaded AFTER server/discord_ext.lua).
--   * real roles + permissions + per-channel overrides
--   * role mentions (@Moderator, @admin)
--   * limited invites (uses / expiry) + vanity invite
--   * welcome screen + rules screening
--   * stage channels
--   * server templates, server card
--   * per-user mutes (channel / server), per-server nickname, server folders
--   * unread "NEW MESSAGES" marker support
-- Config: Config.DiscordExt (config.lua).  SQL: sql/discord_v8.sql
-- ==========================================================================

local function cfg() return Config.DiscordExt end
-- same palette as main.lua (its copy is file-local)
local DiscordIconPalette = { "#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4" }
local function Q(sql, params) return ExecuteSql(true, sql, params or {}) end
local function Exec(sql, params) return MySQL.Sync.execute(sql, params or {}) end
local function nowTs() return os.time() end
local function isStr(v) return type(v) == "string" end
local function truthy(v) return v == 1 or v == true end
local function trim(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
local function clean(s, maxLen)
    s = trim(tostring(s or ""):gsub("[%c]", " "))
    return Discord_Utf8SafeSub(s, maxLen)
end
local function validColor(c) return c == nil or c == "" or (isStr(c) and c:match("^#%x%x%x%x%x%x$") ~= nil) end

local function pushExtras(serverId, flags)
    flags = flags or {}
    flags.serverId = serverId
    Discord_BroadcastToServerMembers(serverId, 'Unique_Phone:client:DiscordExt:ServerExtrasUpdated', flags)
end

-- ==========================================================================
-- 1) PERMISSIONS CORE
-- ==========================================================================

local PERM_LIST = {
    { key = 'view',            label = 'View channels' },
    { key = 'send',            label = 'Send messages' },
    { key = 'react',           label = 'Add reactions' },
    { key = 'mention_roles',   label = 'Mention @roles / @admin' },
    { key = 'pin',             label = 'Pin messages' },
    { key = 'manage_messages', label = 'Delete others\' messages' },
    { key = 'speak',           label = 'Speak in stage channels' },
    { key = 'manage_channels', label = 'Manage channels' },
    { key = 'manage_roles',    label = 'Manage roles' },
    { key = 'manage_server',   label = 'Manage server (theme, invites, welcome...)' },
    { key = 'kick',            label = 'Kick members' },
    { key = 'moderate',        label = 'Timeout / warn / auto-mod' },
    { key = 'administrator',   label = 'Administrator (everything)' },
}
local PERM_SET = {}
for _, p in ipairs(PERM_LIST) do PERM_SET[p.key] = true end

local CHANNEL_PERM_LIST = {
    { key = 'view',            label = 'View channel' },
    { key = 'send',            label = 'Send messages' },
    { key = 'react',           label = 'Add reactions' },
    { key = 'pin',             label = 'Pin messages' },
    { key = 'manage_messages', label = 'Delete others\' messages' },
    { key = 'speak',           label = 'Speak (stage)' },
}
local CH_PERM = {}
for _, p in ipairs(CHANNEL_PERM_LIST) do CH_PERM[p.key] = true end

local DEFAULT_PERMS = { view = true, send = true, react = true }

local defaultRoleCache = {}

local function ensureDefaultRole(serverId)
    if defaultRoleCache[serverId] then return defaultRoleCache[serverId] end
    local r = Q("SELECT id FROM phone_discord_roles WHERE server_id = @s AND is_default = 1 ORDER BY id ASC LIMIT 1", { ['@s'] = serverId })[1]
    local id = r and r.id
    if not id then
        id = MySQL.Sync.insert("INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default) VALUES (@s, @n, NULL, 0, @p, 0, 1)", {
            ['@s'] = serverId, ['@n'] = '@everyone', ['@p'] = json.encode(DEFAULT_PERMS),
        })
    end
    defaultRoleCache[serverId] = id
    return id
end

local function decodeList(str)
    local ok, t = pcall(json.decode, str or "[]")
    local set = {}
    if ok and type(t) == "table" then for _, k in ipairs(t) do set[k] = true end end
    return set
end

local function decodePerms(str)
    local ok, t = pcall(json.decode, str or "{}")
    local out = {}
    if ok and type(t) == "table" then for k, v in pairs(t) do if PERM_SET[k] and v == true then out[k] = true end end end
    return out
end

local function loadCtx(identifier, serverId, src)
    local ctx = { identifier = identifier, serverId = serverId, base = {}, myRoleIds = {}, top = 0, roles = {} }
    local srv = serverId and Q("SELECT * FROM phone_discord_servers WHERE id = @s", { ['@s'] = serverId })[1]
    if not srv then ctx.none = true return ctx end
    ctx.server = srv
    local mem = Q("SELECT id, nickname, joined_at, is_admin FROM phone_discord_members WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })[1]
    ctx.member = mem
    ctx.isMember = mem ~= nil
    ctx.isOwner = srv.owner_identifier == identifier
    ctx.isAdminFlag = mem ~= nil and truthy(mem.is_admin)
    ctx.isStaff = (src ~= nil) and Discord_IsStaff(src) or false
    ctx.full = ctx.isOwner or ctx.isAdminFlag or ctx.isStaff

    ctx.defaultId = ensureDefaultRole(serverId)
    for _, r in ipairs(Q("SELECT id, name, color, position, perms, mentionable, is_default FROM phone_discord_roles WHERE server_id = @s", { ['@s'] = serverId })) do
        r.permsT = decodePerms(r.perms)
        r.isDefault = truthy(r.is_default)
        ctx.roles[r.id] = r
    end
    local def = ctx.roles[ctx.defaultId]
    if def then for k in pairs(def.permsT) do ctx.base[k] = true end end
    for _, m in ipairs(Q("SELECT role_id FROM phone_discord_member_roles WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = identifier })) do
        local r = ctx.roles[m.role_id]
        if r and not r.isDefault then
            ctx.myRoleIds[#ctx.myRoleIds + 1] = r.id
            for k in pairs(r.permsT) do ctx.base[k] = true end
            if r.position > ctx.top then ctx.top = r.position end
        end
    end
    return ctx
end

local function ctxOverrides(ctx)
    if ctx.ov then return ctx.ov end
    ctx.ov = {}
    for _, row in ipairs(Q([[SELECT cp.channel_id, cp.role_id, cp.allow, cp.deny FROM phone_discord_channel_perms cp
                             JOIN phone_discord_channels c ON c.id = cp.channel_id WHERE c.server_id = @s]], { ['@s'] = ctx.serverId })) do
        ctx.ov[row.channel_id] = ctx.ov[row.channel_id] or {}
        ctx.ov[row.channel_id][row.role_id] = { allow = decodeList(row.allow), deny = decodeList(row.deny) }
    end
    return ctx.ov
end

local function ctxSpeakers(ctx)
    if ctx.speakers then return ctx.speakers end
    ctx.speakers = {}
    for _, r in ipairs(Q([[SELECT ss.channel_id FROM phone_discord_stage_speakers ss JOIN phone_discord_channels c ON c.id = ss.channel_id
                           WHERE c.server_id = @s AND ss.identifier = @i]], { ['@s'] = ctx.serverId, ['@i'] = ctx.identifier })) do
        ctx.speakers[r.channel_id] = true
    end
    return ctx.speakers
end

-- channel = { id, kind, is_locked }
local function ctxCan(ctx, perm, channel)
    if ctx.none then return false end
    if not ctx.isMember and not ctx.isStaff then return false end
    if ctx.full or ctx.base.administrator then return true end

    local v = ctx.base[perm] == true
    if channel and CH_PERM[perm] then
        local ov = ctxOverrides(ctx)[channel.id]
        if ov then
            local d = ov[ctx.defaultId]
            if d then
                if d.deny[perm] then v = false end
                if d.allow[perm] then v = true end
            end
            local anyDeny, anyAllow = false, false
            for _, rid in ipairs(ctx.myRoleIds) do
                local o = ov[rid]
                if o then
                    anyDeny = anyDeny or o.deny[perm] == true
                    anyAllow = anyAllow or o.allow[perm] == true
                end
            end
            if anyDeny then v = false end
            if anyAllow then v = true end
        end
    end

    if channel and perm == 'send' then
        if not ctxCan(ctx, 'view', channel) then return false end
        if truthy(channel.is_locked) and not (ctx.base.manage_channels or ctx.base.manage_messages) then return false end
        if channel.kind == 'stage' then
            if not (ctx.base.manage_channels or ctxCan(ctx, 'speak', channel) or ctxSpeakers(ctx)[channel.id]) then return false end
        end
    end
    return v
end

local function getChannelRow(channelId)
    channelId = tonumber(channelId)
    if not channelId then return nil end
    return Q("SELECT id, server_id, name, kind, is_locked FROM phone_discord_channels WHERE id = @c", { ['@c'] = channelId })[1]
end

function Discord_ExtCan(identifier, serverId, perm, channelId, src)
    if identifier == nil or serverId == nil then return false end
    local ctx = loadCtx(identifier, serverId, src)
    local ch = channelId and getChannelRow(channelId) or nil
    return ctxCan(ctx, perm, ch)
end

-- Channels the player may see, with the flags the UI needs.
function Discord_ExtFilterChannels(xPlayer, src, serverId, channels)
    local ctx = loadCtx(xPlayer.identifier, serverId, src)
    local out = {}
    for _, ch in ipairs(channels) do
        local row = { id = ch.id, kind = ch.kind or 'text', is_locked = ch.isLocked and 1 or 0 }
        if ctxCan(ctx, 'view', row) then
            ch.kind = row.kind
            ch.canSend = ctxCan(ctx, 'send', row)
            out[#out + 1] = ch
        end
    end
    return out
end

function Discord_ExtViewableSet(identifier, serverId, src)
    local ctx = loadCtx(identifier, serverId, src)
    local set, list = {}, {}
    for _, c in ipairs(Q("SELECT id, kind, is_locked FROM phone_discord_channels WHERE server_id = @s", { ['@s'] = serverId })) do
        if ctxCan(ctx, 'view', c) then set[c.id] = true; list[#list + 1] = c.id end
    end
    return set, list
end

function Discord_ExtSendableChannels(xPlayer, src, serverId)
    local ctx = loadCtx(xPlayer.identifier, serverId, src)
    local out = {}
    for _, c in ipairs(Q("SELECT id, name, kind, is_locked FROM phone_discord_channels WHERE server_id = @s ORDER BY position, id", { ['@s'] = serverId })) do
        if ctxCan(ctx, 'send', c) then out[#out + 1] = { id = c.id, name = c.name } end
    end
    return out
end

-- Channel management implies the new manage_channels permission too.
local _origCanManage = Discord_CanManageChannels
function Discord_CanManageChannels(identifier, serverId)
    return _origCanManage(identifier, serverId) or Discord_ExtCan(identifier, serverId, 'manage_channels')
end

local function needsRules(ctx)
    if ctx.full or ctx.base.administrator or not ctx.member then return false end
    local s = ctx.server
    if not truthy(s.require_rules) or s.rules_since == nil then return false end
    if tonumber(ctx.member.joined_at) < tonumber(s.rules_since) then return false end
    return Q("SELECT 1 AS x FROM phone_discord_rules_accept WHERE server_id = @s AND identifier = @i", { ['@s'] = ctx.serverId, ['@i'] = ctx.identifier })[1] == nil
end

-- Called from SendMessage (via Discord_ExtPreSend). nil = allowed.
function Discord_ExtPermGate(xPlayer, src, serverId, channelId)
    local ctx = loadCtx(xPlayer.identifier, serverId, src)
    local ch = getChannelRow(channelId)
    if ch == nil or ch.server_id ~= serverId then return { error = "NO_PERMISSION" } end
    if needsRules(ctx) then return { error = "RULES" } end
    if not ctxCan(ctx, 'send', ch) then
        if ch.kind == 'stage' and ctxCan(ctx, 'view', ch) then return { error = "STAGE" } end
        return { error = "NO_PERMISSION" }
    end
    return nil
end

function Discord_ExtCanReact(xPlayer, src, serverId, messageId)
    local m = Q("SELECT channel_id FROM phone_discord_messages WHERE id = @m", { ['@m'] = messageId })[1]
    if not m then return false end
    local ctx = loadCtx(xPlayer.identifier, serverId, src)
    local ch = getChannelRow(m.channel_id)
    return ctxCan(ctx, 'view', ch) and ctxCan(ctx, 'react', ch)
end

function Discord_ExtAuthorName(xPlayer, src, serverId)
    local m = Q("SELECT nickname FROM phone_discord_members WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })[1]
    if m and isStr(m.nickname) and m.nickname ~= "" then return m.nickname end
    return Discord_GetDisplayName(src)
end

-- Can `actor` act on `target`? (kick / role assign). Owner is untouchable.
function Discord_ExtOutranks(actorIdentifier, serverId, targetIdentifier)
    local a, t = loadCtx(actorIdentifier, serverId), loadCtx(targetIdentifier, serverId)
    if t.isOwner then return false end
    if a.isOwner then return true end
    if t.isAdminFlag or t.base.administrator then return a.isAdminFlag or a.base.administrator == true end
    if a.isAdminFlag or a.base.administrator then return true end
    return a.top > t.top
end

function Discord_ExtParseRoleIds(str)
    local out = {}
    if isStr(str) then for n in str:gmatch("%-?%d+") do out[#out + 1] = tonumber(n) end end
    return out
end

-- ==========================================================================
-- 2) ROLE MENTIONS
-- ==========================================================================

local function escapePattern(s) return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end

local function mentions(loweredText, loweredName)
    if loweredName == "" then return false end
    local pat = "@" .. escapePattern(loweredName)
    local init = 1
    while true do
        local s, e = loweredText:find(pat, init)
        if not s then return false end
        local nxt = loweredText:sub(e + 1, e + 1)
        if nxt == "" or not nxt:match("[%w_]") then return true end
        init = e + 1
    end
end

-- Returns the list of role ids that this message really pings (and stores it).
function Discord_ExtHandleRoleMentions(xPlayer, src, serverId, messageId, message)
    if not isStr(message) or not message:find("@", 1, true) or messageId == nil then return nil end
    local ctx = loadCtx(xPlayer.identifier, serverId, src)
    local canAny = ctx.full or ctx.base.administrator == true or ctx.base.mention_roles == true
    local text = Discord_ExtNormalize(message)
    local ids = {}
    for _, r in pairs(ctx.roles) do
        if not r.isDefault and (canAny or truthy(r.mentionable)) and mentions(text, Discord_ExtNormalize(r.name)) then
            ids[#ids + 1] = r.id
        end
    end
    if canAny and (mentions(text, "admin") or mentions(text, "admins")) then ids[#ids + 1] = -1 end
    if #ids == 0 then return nil end
    table.sort(ids)
    Exec("UPDATE phone_discord_messages SET role_mentions = @r WHERE id = @id", { ['@r'] = table.concat(ids, ","), ['@id'] = messageId })
    return ids
end

-- ==========================================================================
-- 3) SERVER INFO EXTRAS (merged into DiscordExt:GetServerInfo)
-- ==========================================================================

local function boostLevelFor(serverId)
    local total = Q("SELECT COUNT(*) AS c FROM phone_discord_boosts WHERE server_id = @s AND expires_at > @now", { ['@s'] = serverId, ['@now'] = nowTs() })[1].c
    local level = 0
    for i, L in ipairs(cfg().Boost.Levels or {}) do if total >= L.boosts then level = i end end
    return level
end

local function vanityEligible(s)
    local V = cfg().Vanity or {}
    if isStr(s.kind) and s.kind ~= "" then return s.kind == 'job' end
    if V.AllowVerified ~= false and truthy(s.is_verified) then return true end
    if V.AllowFeatured and truthy(s.is_featured) then return true end
    return boostLevelFor(s.id) >= (V.MinBoostLevel or 2)
end

function Discord_ExtInfoExtras(xPlayer, src, serverId, s, info)
    local ctx = loadCtx(xPlayer.identifier, serverId, src)

    local roles = {}
    for _, r in pairs(ctx.roles) do
        if not r.isDefault then roles[#roles + 1] = { id = r.id, name = r.name, color = r.color, mentionable = truthy(r.mentionable), position = r.position } end
    end
    table.sort(roles, function(a, b) if a.position ~= b.position then return a.position > b.position end return a.id < b.id end)
    info.roles = roles

    local mine = {}
    for _, id in ipairs(ctx.myRoleIds) do mine[#mine + 1] = id end
    if ctx.isOwner or ctx.isAdminFlag or ctx.base.administrator then mine[#mine + 1] = -1 end
    info.myRoleIds = mine

    local perms = {}
    for _, key in ipairs({ 'manage_channels', 'manage_roles', 'manage_server', 'kick', 'moderate', 'pin', 'manage_messages', 'mention_roles' }) do
        perms[key] = ctxCan(ctx, key, nil)
    end
    perms.administrator = ctx.full or ctx.base.administrator == true
    info.perms = perms

    info.memberRowId = ctx.member and ctx.member.id
    info.myNickname = ctx.member and ctx.member.nickname
    info.description = s.description
    info.vanity = s.vanity
    info.welcome = { title = s.welcome_title, text = s.welcome_text, rules = s.rules_text, require = truthy(s.require_rules) }

    local has = (isStr(s.welcome_text) and s.welcome_text ~= "") or (isStr(s.rules_text) and s.rules_text ~= "")
    local accepted = Q("SELECT 1 AS x FROM phone_discord_rules_accept WHERE server_id = @s AND identifier = @i", { ['@s'] = serverId, ['@i'] = xPlayer.identifier })[1] ~= nil
    local fresh = ctx.member and s.rules_since ~= nil and tonumber(ctx.member.joined_at) >= tonumber(s.rules_since)
    info.showWelcome = has and fresh and not accepted and not ctx.isOwner
    info.mustAccept = info.showWelcome and truthy(s.require_rules) and not ctx.full
end

-- ==========================================================================
-- 4) ROLES (manage UI)
-- ==========================================================================

local function canManageRoles(ctx) return ctxCan(ctx, 'manage_roles', nil) end
local function grantableAdmin(ctx) return ctx.full or ctx.base.administrator == true end
local function editableRole(ctx, r)
    if r.isDefault then return ctx.full or ctx.base.administrator == true end
    return ctx.full or ctx.base.administrator == true or r.position < ctx.top
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetRoles', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    if not canManageRoles(ctx) then cb(false) return end

    local roles = {}
    for _, r in pairs(ctx.roles) do
        roles[#roles + 1] = { id = r.id, name = r.name, color = r.color, position = r.position, mentionable = truthy(r.mentionable),
                              isDefault = r.isDefault, perms = r.permsT, editable = editableRole(ctx, r) }
    end
    table.sort(roles, function(a, b)
        if a.isDefault ~= b.isDefault then return b.isDefault end
        if a.position ~= b.position then return a.position > b.position end
        return a.id < b.id
    end)

    local members, byIdent = {}, {}
    for _, m in ipairs(Q("SELECT id, identifier, nickname FROM phone_discord_members WHERE server_id = @s ORDER BY nickname", { ['@s'] = serverId })) do
        members[#members + 1] = { id = m.id, nickname = m.nickname }
        byIdent[m.identifier] = m.id
    end
    local assign = {}
    for _, a in ipairs(Q("SELECT role_id, identifier FROM phone_discord_member_roles WHERE server_id = @s", { ['@s'] = serverId })) do
        if byIdent[a.identifier] then
            assign[tostring(a.role_id)] = assign[tostring(a.role_id)] or {}
            table.insert(assign[tostring(a.role_id)], byIdent[a.identifier])
        end
    end
    cb({ roles = roles, members = members, assign = assign, permList = PERM_LIST, canGrantAdmin = grantableAdmin(ctx), isFull = ctx.full or ctx.base.administrator == true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateRole', function(source, cb, serverId, name, color)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    if not canManageRoles(ctx) then cb(false) return end
    name = clean(name, 32)
    if name == "" or name:lower() == "everyone" or name:lower() == "@everyone" or not validColor(color) then cb(false) return end
    local count, maxPos = 0, 0
    for _, r in pairs(ctx.roles) do count = count + 1; if r.position > maxPos then maxPos = r.position end end
    if count >= 26 then cb({ error = "LIMIT" }) return end
    local position = (ctx.full or ctx.base.administrator) and (maxPos + 1) or 1
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default) VALUES (@s, @n, @c, @p, @pm, 0, 0)", {
        ['@s'] = serverId, ['@n'] = name, ['@c'] = (color ~= "" and color) or nil, ['@p'] = position, ['@pm'] = "{}",
    })
    pushExtras(serverId)
    cb({ ok = true, id = id })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:UpdateRole', function(source, cb, serverId, roleId, data)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or roleId == nil or type(data) ~= "table" then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local r = ctx.roles[tonumber(roleId)]
    if not canManageRoles(ctx) or not r or not editableRole(ctx, r) then cb(false) return end

    local name, color, mentionable = r.name, r.color, truthy(r.mentionable)
    if not r.isDefault then
        if isStr(data.name) then
            name = clean(data.name, 32)
            if name == "" or name:lower() == "everyone" or name:lower() == "@everyone" then cb(false) return end
        end
        if data.color ~= nil then
            if not validColor(data.color) then cb(false) return end
            color = (data.color ~= "" and data.color) or nil
        end
        if data.mentionable ~= nil then mentionable = data.mentionable == true end
    end

    local perms = r.permsT
    if type(data.perms) == "table" then
        perms = {}
        for k, v in pairs(data.perms) do
            if PERM_SET[k] and v == true then
                local had = r.permsT[k] == true
                if not had and not grantableAdmin(ctx) and (k == 'administrator' or not ctx.base[k]) then
                    cb({ error = "CANT_GRANT" }) return
                end
                perms[k] = true
            end
        end
        -- don't let a non-admin strip perms they couldn't have set
        for k in pairs(r.permsT) do
            if perms[k] == nil and not grantableAdmin(ctx) and (k == 'administrator' or not ctx.base[k]) then perms[k] = true end
        end
    end

    Exec("UPDATE phone_discord_roles SET name = @n, color = @c, mentionable = @m, perms = @p WHERE id = @id", {
        ['@n'] = name, ['@c'] = color, ['@m'] = mentionable and 1 or 0, ['@p'] = json.encode(perms), ['@id'] = r.id,
    })
    pushExtras(serverId, { channels = true })
    cb({ ok = true })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteRole', function(source, cb, serverId, roleId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local r = ctx.roles[tonumber(roleId)]
    if not canManageRoles(ctx) or not r or r.isDefault or not editableRole(ctx, r) then cb(false) return end
    Exec("DELETE FROM phone_discord_roles WHERE id = @id", { ['@id'] = r.id })
    pushExtras(serverId, { channels = true })
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:MoveRole', function(source, cb, serverId, roleId, dir)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    if not canManageRoles(ctx) or not grantableAdmin(ctx) then cb(false) return end -- hierarchy is changed by owner/admins only
    local list = {}
    for _, r in pairs(ctx.roles) do if not r.isDefault then list[#list + 1] = r end end
    table.sort(list, function(a, b) if a.position ~= b.position then return a.position < b.position end return a.id < b.id end)
    local idx
    for i, r in ipairs(list) do if r.id == tonumber(roleId) then idx = i end end
    local target = idx and (idx + (tonumber(dir) == 1 and 1 or -1)) or nil
    if not idx or not target or target < 1 or target > #list then cb(false) return end
    list[idx], list[target] = list[target], list[idx]
    for i, r in ipairs(list) do Exec("UPDATE phone_discord_roles SET position = @p WHERE id = @id", { ['@p'] = i, ['@id'] = r.id }) end
    pushExtras(serverId)
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetMemberRole', function(source, cb, serverId, memberRowId, roleId, on)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local r = ctx.roles[tonumber(roleId)]
    if not canManageRoles(ctx) or not r or r.isDefault or not editableRole(ctx, r) then cb(false) return end
    local t = Q("SELECT identifier FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = memberRowId, ['@s'] = serverId })[1]
    if not t then cb(false) return end
    if t.identifier ~= xPlayer.identifier and not Discord_ExtOutranks(xPlayer.identifier, serverId, t.identifier) and not ctx.full then cb(false) return end
    if on then
        Exec("INSERT IGNORE INTO phone_discord_member_roles (server_id, identifier, role_id) VALUES (@s, @i, @r)", { ['@s'] = serverId, ['@i'] = t.identifier, ['@r'] = r.id })
    else
        Exec("DELETE FROM phone_discord_member_roles WHERE role_id = @r AND identifier = @i", { ['@r'] = r.id, ['@i'] = t.identifier })
    end
    pushExtras(serverId, { channels = true })
    cb(true)
end)

-- Colour / role list for every member (for coloured names) — merged into GetMemberMeta.
function Discord_ExtMemberRoleMap(serverId)
    local roles = {}
    for _, r in ipairs(Q("SELECT id, color, position, is_default FROM phone_discord_roles WHERE server_id = @s", { ['@s'] = serverId })) do roles[r.id] = r end
    local top = {}
    for _, a in ipairs(Q("SELECT role_id, identifier FROM phone_discord_member_roles WHERE server_id = @s", { ['@s'] = serverId })) do
        local r = roles[a.role_id]
        if r and r.color and r.color ~= "" and (top[a.identifier] == nil or r.position > top[a.identifier].position) then top[a.identifier] = r end
    end
    return top
end

-- ==========================================================================
-- 5) CHANNEL OVERRIDES + STAGE
-- ==========================================================================

local function canEditChannelPerms(ctx) return canManageRoles(ctx) or ctxCan(ctx, 'manage_channels', nil) end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetChannelPerms', function(source, cb, serverId, channelId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local ch = getChannelRow(channelId)
    if not ch or ch.server_id ~= serverId or not canEditChannelPerms(ctx) then cb(false) return end

    local roles = {}
    for _, r in pairs(ctx.roles) do roles[#roles + 1] = { id = r.id, name = r.name, color = r.color, isDefault = r.isDefault, position = r.position } end
    table.sort(roles, function(a, b)
        if a.isDefault ~= b.isDefault then return a.isDefault end
        if a.position ~= b.position then return a.position > b.position end
        return a.id < b.id
    end)
    local overrides = {}
    for _, o in ipairs(Q("SELECT role_id, allow, deny FROM phone_discord_channel_perms WHERE channel_id = @c", { ['@c'] = ch.id })) do
        local allow, deny = {}, {}
        for k in pairs(decodeList(o.allow)) do allow[#allow + 1] = k end
        for k in pairs(decodeList(o.deny)) do deny[#deny + 1] = k end
        overrides[tostring(o.role_id)] = { allow = allow, deny = deny }
    end
    cb({ channel = { id = ch.id, name = ch.name, kind = ch.kind }, roles = roles, overrides = overrides, permList = CHANNEL_PERM_LIST })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetChannelPerm', function(source, cb, serverId, channelId, roleId, allowList, denyList)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local ch = getChannelRow(channelId)
    if not ch or ch.server_id ~= serverId or not canEditChannelPerms(ctx) or not ctx.roles[tonumber(roleId)] then cb(false) return end

    local allow, deny, denySet = {}, {}, {}
    if type(denyList) == "table" then for _, k in ipairs(denyList) do if CH_PERM[k] then denySet[k] = true; deny[#deny + 1] = k end end end
    if type(allowList) == "table" then for _, k in ipairs(allowList) do if CH_PERM[k] and not denySet[k] then allow[#allow + 1] = k end end end

    if #allow == 0 and #deny == 0 then
        Exec("DELETE FROM phone_discord_channel_perms WHERE channel_id = @c AND role_id = @r", { ['@c'] = ch.id, ['@r'] = tonumber(roleId) })
    else
        Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, @a, @d)", {
            ['@c'] = ch.id, ['@r'] = tonumber(roleId), ['@a'] = json.encode(allow), ['@d'] = json.encode(deny),
        })
    end
    pushExtras(serverId, { channels = true })
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateStageChannel', function(source, cb, serverId, channelName)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not isStr(channelName) or not Discord_CanManageChannels(xPlayer.identifier, serverId) then cb(false) return end
    channelName = string.lower((clean(channelName, 30):gsub("%s+", "-")))
    if channelName == "" then cb(false) return end
    local position = (Q("SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = @s", { ['@s'] = serverId })[1] or {}).c or 0
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at, kind) VALUES (@s, @n, @p, @t, 'stage')", {
        ['@s'] = serverId, ['@n'] = channelName, ['@p'] = position, ['@t'] = nowTs(),
    })
    pushExtras(serverId, { channels = true })
    cb({ id = id, name = channelName, position = position, kind = 'stage', canSend = true })
end)

local function stageChannelFor(ctx, serverId, channelId)
    local ch = getChannelRow(channelId)
    if not ch or ch.server_id ~= serverId or ch.kind ~= 'stage' then return nil end
    if not (ctx.full or ctx.base.administrator or ctx.base.manage_channels) then return nil end
    return ch
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetSpeakers', function(source, cb, serverId, channelId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local ch = stageChannelFor(ctx, serverId, channelId)
    if not ch then cb(false) return end
    local speakers = {}
    for _, r in ipairs(Q("SELECT identifier FROM phone_discord_stage_speakers WHERE channel_id = @c", { ['@c'] = ch.id })) do speakers[r.identifier] = true end
    local members = {}
    for _, m in ipairs(Q("SELECT id, identifier, nickname FROM phone_discord_members WHERE server_id = @s ORDER BY nickname", { ['@s'] = serverId })) do
        members[#members + 1] = { id = m.id, nickname = m.nickname, speaker = speakers[m.identifier] == true }
    end
    cb({ channel = { id = ch.id, name = ch.name }, members = members })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetSpeaker', function(source, cb, serverId, channelId, memberRowId, on)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local ch = stageChannelFor(ctx, serverId, channelId)
    local t = ch and Q("SELECT identifier FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = memberRowId, ['@s'] = serverId })[1]
    if not ch or not t then cb(false) return end
    if on then
        Exec("INSERT IGNORE INTO phone_discord_stage_speakers (channel_id, identifier) VALUES (@c, @i)", { ['@c'] = ch.id, ['@i'] = t.identifier })
    else
        Exec("DELETE FROM phone_discord_stage_speakers WHERE channel_id = @c AND identifier = @i", { ['@c'] = ch.id, ['@i'] = t.identifier })
    end
    pushExtras(serverId, { channels = true })
    cb(true)
end)

-- ==========================================================================
-- 6) INVITES + VANITY
-- ==========================================================================

function Discord_ExtNormalizeInvite(input)
    local s = trim(input)
    s = s:gsub("^https?://", ""):gsub("^www%.", ""):gsub("^discord%.gg/", ""):gsub("^discord%.com/invite/", "")
    s = s:gsub("[/?#].*$", "")
    return s:sub(1, 40)
end

local function codeTaken(code)
    local up = code:upper()
    if Q("SELECT 1 AS x FROM phone_discord_servers WHERE invite_code = @c OR vanity = @l", { ['@c'] = up, ['@l'] = code:lower() })[1] then return true end
    return Q("SELECT 1 AS x FROM phone_discord_invites WHERE code = @c", { ['@c'] = up })[1] ~= nil
end

local function newCode()
    for _ = 1, 10 do
        local c = Discord_GenerateInviteCode()
        if not codeTaken(c) then return c end
    end
    return Discord_GenerateInviteCode() .. tostring(math.random(2, 9))
end

function Discord_ExtResolveInvite(raw)
    if not isStr(raw) or raw == "" then return nil end
    local inv = Q("SELECT id, server_id, max_uses, uses, expires_at FROM phone_discord_invites WHERE code = @c", { ['@c'] = raw:upper() })[1]
    if inv then
        if inv.expires_at ~= nil and nowTs() >= tonumber(inv.expires_at) then return nil, "EXPIRED" end
        if tonumber(inv.max_uses) > 0 and tonumber(inv.uses) >= tonumber(inv.max_uses) then return nil, "FULL" end
        return inv.server_id, nil, inv.id
    end
    local v = Q("SELECT id FROM phone_discord_servers WHERE vanity = @v", { ['@v'] = raw:lower() })[1]
    if v then return v.id end
    return nil
end

function Discord_ExtConsumeInvite(inviteId)
    Exec("UPDATE phone_discord_invites SET uses = uses + 1 WHERE id = @id", { ['@id'] = inviteId })
end

local function inviteManager(source, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then return nil end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    if not (ctx.isOwner or ctxCan(ctx, 'manage_server', nil)) then return nil end
    return xPlayer, ctx
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ListInvites', function(source, cb, serverId)
    local xPlayer, ctx = inviteManager(source, serverId)
    if not xPlayer then cb(false) return end
    local rows = Q("SELECT id, code, max_uses, uses, expires_at, created_by FROM phone_discord_invites WHERE server_id = @s ORDER BY id DESC", { ['@s'] = serverId })
    local I = cfg().Invites or {}
    cb({
        main = ctx.server.invite_code, invites = rows, vanity = ctx.server.vanity, vanityEligible = vanityEligible(ctx.server),
        maxUses = I.MaxUses or { 0, 1, 5, 10, 25, 100 }, expireMinutes = I.ExpireMinutes or { 0, 60, 1440, 10080 },
        vanityRule = (cfg().Vanity or {}).MinBoostLevel or 2, now = nowTs(),
    })
end)

local function inList(list, v) for _, x in ipairs(list or {}) do if x == v then return true end end return false end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateInvite', function(source, cb, serverId, maxUses, expireMinutes)
    local xPlayer = inviteManager(source, serverId)
    if not xPlayer then cb(false) return end
    local I = cfg().Invites or {}
    maxUses, expireMinutes = tonumber(maxUses), tonumber(expireMinutes)
    if not maxUses or not expireMinutes or not inList(I.MaxUses or { 0, 1, 5, 10, 25, 100 }, maxUses) or not inList(I.ExpireMinutes or { 0, 60, 1440, 10080 }, expireMinutes) then cb(false) return end
    local active = Q("SELECT COUNT(*) AS c FROM phone_discord_invites WHERE server_id = @s", { ['@s'] = serverId })[1].c
    if active >= (I.MaxActive or 20) then cb({ error = "LIMIT" }) return end
    local code = newCode()
    MySQL.Sync.insert("INSERT INTO phone_discord_invites (server_id, code, max_uses, expires_at, created_by, created_at) VALUES (@s, @c, @m, @e, @b, @t)", {
        ['@s'] = serverId, ['@c'] = code, ['@m'] = maxUses, ['@e'] = expireMinutes > 0 and (nowTs() + expireMinutes * 60) or nil,
        ['@b'] = Discord_GetDisplayName(source), ['@t'] = nowTs(),
    })
    cb({ ok = true, code = code })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:RevokeInvite', function(source, cb, serverId, inviteId)
    if not inviteManager(source, serverId) then cb(false) return end
    Exec("DELETE FROM phone_discord_invites WHERE id = @id AND server_id = @s", { ['@id'] = inviteId, ['@s'] = serverId })
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetVanity', function(source, cb, serverId, code)
    local xPlayer, ctx = inviteManager(source, serverId)
    if not xPlayer then cb(false) return end
    code = trim(code):lower()
    if code == "" then
        Exec("UPDATE phone_discord_servers SET vanity = NULL WHERE id = @s", { ['@s'] = serverId })
        pushExtras(serverId)
        cb({ ok = true, vanity = nil })
        return
    end
    if not vanityEligible(ctx.server) then cb({ error = "NOT_ELIGIBLE" }) return end
    if not code:match("^[a-z0-9%-]+$") or #code < 3 or #code > 24 or code:match("^%-") or code:match("%-$") then cb({ error = "BAD_FORMAT" }) return end
    if ctx.server.vanity ~= code and codeTaken(code) then cb({ error = "TAKEN" }) return end
    Exec("UPDATE phone_discord_servers SET vanity = @v WHERE id = @s", { ['@v'] = code, ['@s'] = serverId })
    pushExtras(serverId)
    cb({ ok = true, vanity = code })
end)

CreateThread(function()
    Wait(45000)
    while true do
        Exec("DELETE FROM phone_discord_invites WHERE (expires_at IS NOT NULL AND expires_at < @old) OR (max_uses > 0 AND uses >= max_uses AND created_at < @old)", { ['@old'] = nowTs() - 86400 })
        Wait(30 * 60 * 1000)
    end
end)

-- ==========================================================================
-- 7) WELCOME SCREEN + RULES
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetWelcome', function(source, cb, serverId, title, text, rules, description, require)
    local xPlayer, ctx = inviteManager(source, serverId)  -- owner / manage_server
    if not xPlayer then cb(false) return end
    title, text, rules, description = clean(title, 60), clean(text, 400), Discord_Utf8SafeSub(trim(rules), 800), clean(description, 200)
    local has = text ~= "" or rules ~= ""
    require = (require == true) and rules ~= ""
    local since = ctx.server.rules_since
    if has and since == nil then since = nowTs() end
    if not has then since = nil end
    Exec([[UPDATE phone_discord_servers SET welcome_title = @t, welcome_text = @x, rules_text = @r, description = @d, require_rules = @q, rules_since = @s WHERE id = @id]], {
        ['@t'] = title ~= "" and title or nil, ['@x'] = text ~= "" and text or nil, ['@r'] = rules ~= "" and rules or nil,
        ['@d'] = description ~= "" and description or nil, ['@q'] = require and 1 or 0, ['@s'] = since, ['@id'] = serverId,
    })
    pushExtras(serverId)
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:AcceptRules', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    Exec("INSERT IGNORE INTO phone_discord_rules_accept (server_id, identifier, accepted_at) VALUES (@s, @i, @t)", { ['@s'] = serverId, ['@i'] = xPlayer.identifier, ['@t'] = nowTs() })
    cb(true)
end)

-- ==========================================================================
-- 8) TEMPLATES
-- ==========================================================================

local function templateCode()
    for _ = 1, 10 do
        local c = Discord_GenerateInviteCode()
        if Q("SELECT 1 AS x FROM phone_discord_templates WHERE code = @c", { ['@c'] = c })[1] == nil then return c end
    end
    return Discord_GenerateInviteCode() .. "9"
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateTemplate', function(source, cb, serverId, name, description, isPublic)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil or not Discord_IsOwner(xPlayer.identifier, serverId) or Discord_IsAutoServer(serverId) then cb(false) return end
    name, description = clean(name, 40), clean(description, 120)
    if name == "" then cb(false) return end
    local mine = Q("SELECT COUNT(*) AS c FROM phone_discord_templates WHERE creator_identifier = @i", { ['@i'] = xPlayer.identifier })[1].c
    if mine >= ((cfg().Templates or {}).MaxPerPlayer or 5) then cb({ error = "LIMIT" }) return end

    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    local s = ctx.server
    local data = { channels = {}, roles = {}, overrides = {}, settings = {
        theme_color = s.theme_color, description = s.description, welcome_title = s.welcome_title, welcome_text = s.welcome_text,
        rules_text = s.rules_text, require_rules = truthy(s.require_rules),
    }, default_perms = ctx.roles[ctx.defaultId].permsT }

    local chIndex = {}
    for _, c in ipairs(Q("SELECT id, name, kind, is_locked FROM phone_discord_channels WHERE server_id = @s ORDER BY position, id", { ['@s'] = serverId })) do
        data.channels[#data.channels + 1] = { name = c.name, kind = c.kind or 'text', locked = truthy(c.is_locked) }
        chIndex[c.id] = #data.channels
    end
    local roleName = {}
    local list = {}
    for _, r in pairs(ctx.roles) do if not r.isDefault then list[#list + 1] = r end end
    table.sort(list, function(a, b) if a.position ~= b.position then return a.position < b.position end return a.id < b.id end)
    for _, r in ipairs(list) do
        data.roles[#data.roles + 1] = { name = r.name, color = r.color, perms = r.permsT, mentionable = truthy(r.mentionable) }
        roleName[r.id] = r.name
    end
    roleName[ctx.defaultId] = "@everyone"
    for chId, byRole in pairs(ctxOverrides(ctx)) do
        for roleId, o in pairs(byRole) do
            if chIndex[chId] and roleName[roleId] then
                local allow, deny = {}, {}
                for k in pairs(o.allow) do allow[#allow + 1] = k end
                for k in pairs(o.deny) do deny[#deny + 1] = k end
                data.overrides[#data.overrides + 1] = { channel = chIndex[chId], role = roleName[roleId], allow = allow, deny = deny }
            end
        end
    end

    local code = templateCode()
    MySQL.Sync.insert("INSERT INTO phone_discord_templates (code, name, description, creator_identifier, creator_name, data, is_public, created_at) VALUES (@c, @n, @d, @i, @cn, @data, @p, @t)", {
        ['@c'] = code, ['@n'] = name, ['@d'] = description, ['@i'] = xPlayer.identifier, ['@cn'] = Discord_GetDisplayName(source),
        ['@data'] = json.encode(data), ['@p'] = isPublic and 1 or 0, ['@t'] = nowTs(),
    })
    cb({ ok = true, code = code })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:ListTemplates', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end
    local cols = "id, code, name, description, creator_name, is_public, uses, created_at"
    local mine = Q("SELECT " .. cols .. " FROM phone_discord_templates WHERE creator_identifier = @i ORDER BY id DESC", { ['@i'] = xPlayer.identifier })
    local pub = Q("SELECT " .. cols .. " FROM phone_discord_templates WHERE is_public = 1 AND creator_identifier <> @i ORDER BY uses DESC, id DESC LIMIT 30", { ['@i'] = xPlayer.identifier })
    cb({ mine = mine, public = pub })
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteTemplate', function(source, cb, templateId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or templateId == nil then cb(false) return end
    local t = Q("SELECT creator_identifier FROM phone_discord_templates WHERE id = @id", { ['@id'] = templateId })[1]
    if not t or (t.creator_identifier ~= xPlayer.identifier and not Discord_IsStaff(source)) then cb(false) return end
    Exec("DELETE FROM phone_discord_templates WHERE id = @id", { ['@id'] = templateId })
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:UseTemplate', function(source, cb, code, serverName)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or not isStr(code) then cb(false) return end
    local tpl = Q("SELECT id, code, name, data, is_public, creator_identifier FROM phone_discord_templates WHERE code = @c", { ['@c'] = trim(code):upper() })[1]
    if not tpl then cb({ error = "NOT_FOUND" }) return end
    local ok, data = pcall(json.decode, tpl.data)
    if not ok or type(data) ~= "table" then cb(false) return end

    serverName = clean(serverName, 40)
    if serverName == "" then serverName = tpl.name end

    local st = data.settings or {}
    local iconColor = DiscordIconPalette[math.random(1, #DiscordIconPalette)]
    local iconText = Discord_IconText(serverName)
    local inviteCode = newCode()
    local t = nowTs()
    local has = (isStr(st.welcome_text) and st.welcome_text ~= "") or (isStr(st.rules_text) and st.rules_text ~= "")

    local newId = MySQL.Sync.insert([[INSERT INTO phone_discord_servers
        (name, icon_text, icon_color, owner_identifier, invite_code, created_at, theme_color, description, welcome_title, welcome_text, rules_text, require_rules, rules_since)
        VALUES (@n, @i, @c, @o, @code, @t, @theme, @d, @wt, @wx, @ru, @rq, @rs)]], {
        ['@n'] = serverName, ['@i'] = iconText, ['@c'] = iconColor, ['@o'] = xPlayer.identifier, ['@code'] = inviteCode, ['@t'] = t,
        ['@theme'] = validColor(st.theme_color) and st.theme_color ~= "" and st.theme_color or nil,
        ['@d'] = isStr(st.description) and clean(st.description, 200) or nil, ['@wt'] = isStr(st.welcome_title) and clean(st.welcome_title, 60) or nil,
        ['@wx'] = isStr(st.welcome_text) and clean(st.welcome_text, 400) or nil, ['@ru'] = isStr(st.rules_text) and Discord_Utf8SafeSub(st.rules_text, 800) or nil,
        ['@rq'] = (st.require_rules == true and has) and 1 or 0, ['@rs'] = has and t or nil,
    })
    MySQL.Sync.insert("INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at) VALUES (@s, @i, @n, @t)", {
        ['@s'] = newId, ['@i'] = xPlayer.identifier, ['@n'] = Discord_GetDisplayName(source), ['@t'] = t,
    })

    local defPerms = {}
    for k, v in pairs(data.default_perms or DEFAULT_PERMS) do if PERM_SET[k] and v == true then defPerms[k] = true end end
    local defId = MySQL.Sync.insert("INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default) VALUES (@s, @n, NULL, 0, @p, 0, 1)", {
        ['@s'] = newId, ['@n'] = '@everyone', ['@p'] = json.encode(defPerms),
    })
    defaultRoleCache[newId] = defId

    local roleIds = { ["@everyone"] = defId }
    for i, r in ipairs(data.roles or {}) do
        if i > 25 then break end
        local perms = {}
        for k, v in pairs(r.perms or {}) do if PERM_SET[k] and v == true then perms[k] = true end end
        local rname = clean(r.name, 32)
        if rname ~= "" then
            roleIds[rname] = MySQL.Sync.insert("INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default) VALUES (@s, @n, @c, @p, @pm, @m, 0)", {
                ['@s'] = newId, ['@n'] = rname, ['@c'] = validColor(r.color) and r.color ~= "" and r.color or nil, ['@p'] = i,
                ['@pm'] = json.encode(perms), ['@m'] = r.mentionable == true and 1 or 0,
            })
        end
    end

    local chIds = {}
    local channels = data.channels or {}
    if #channels == 0 then channels = { { name = 'general' } } end
    for pos, ch in ipairs(channels) do
        if pos > 30 then break end
        local cname = string.lower((clean(ch.name, 30):gsub("%s+", "-")))
        if cname == "" then cname = "channel-" .. pos end
        chIds[pos] = MySQL.Sync.insert("INSERT INTO phone_discord_channels (server_id, name, position, created_at, is_locked, kind) VALUES (@s, @n, @p, @t, @l, @k)", {
            ['@s'] = newId, ['@n'] = cname, ['@p'] = pos - 1, ['@t'] = t, ['@l'] = ch.locked == true and 1 or 0, ['@k'] = ch.kind == 'stage' and 'stage' or 'text',
        })
    end
    for _, o in ipairs(data.overrides or {}) do
        local chId, rId = chIds[o.channel], roleIds[o.role]
        if chId and rId then
            local allow, deny = {}, {}
            for _, k in ipairs(o.allow or {}) do if CH_PERM[k] then allow[#allow + 1] = k end end
            for _, k in ipairs(o.deny or {}) do if CH_PERM[k] then deny[#deny + 1] = k end end
            Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, @a, @d)", { ['@c'] = chId, ['@r'] = rId, ['@a'] = json.encode(allow), ['@d'] = json.encode(deny) })
        end
    end

    Exec("UPDATE phone_discord_templates SET uses = uses + 1 WHERE id = @id", { ['@id'] = tpl.id })
    cb({ id = newId, name = serverName, icon_text = iconText, icon_color = iconColor, invite_code = inviteCode, isOwner = true })
end)

-- ==========================================================================
-- 9) SERVER CARD
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetServerCard', function(source, cb, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local s = Q("SELECT * FROM phone_discord_servers WHERE id = @s", { ['@s'] = serverId })[1]
    if not s then cb(false) return end
    local isMember = Discord_IsMember(xPlayer.identifier, serverId)
    if not isMember and not (truthy(s.is_public) or truthy(s.is_featured)) then cb(false) return end

    local members = Q("SELECT identifier FROM phone_discord_members WHERE server_id = @s", { ['@s'] = serverId })
    local online = 0
    for _, m in ipairs(members) do if ESX.GetPlayerFromIdentifier(m.identifier) then online = online + 1 end end
    local isAuto = isStr(s.kind) and s.kind ~= ""
    cb({
        id = s.id, name = s.name, icon_text = s.icon_text, icon_color = s.icon_color, description = s.description, theme = s.theme_color,
        memberCount = #members, onlineCount = online, boostLevel = boostLevelFor(serverId), isVerified = truthy(s.is_verified), isFeatured = truthy(s.is_featured),
        isMember = isMember, isOwner = s.owner_identifier == xPlayer.identifier, canLeave = isMember and not isAuto and s.owner_identifier ~= xPlayer.identifier,
        kind = isAuto and s.kind or nil, vanity = s.vanity, isPublic = truthy(s.is_public), createdAt = s.created_at,
    })
end)

-- ==========================================================================
-- 10) MUTES, NICKNAME, UNREAD MARKER, FOLDERS
-- ==========================================================================

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetMutes', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({ channels = {}, servers = {} }) return end
    local out = { channels = {}, servers = {} }
    for _, r in ipairs(Q("SELECT kind, target_id FROM phone_discord_mutes WHERE identifier = @i", { ['@i'] = xPlayer.identifier })) do
        if r.kind == 'channel' then out.channels[#out.channels + 1] = r.target_id elseif r.kind == 'server' then out.servers[#out.servers + 1] = r.target_id end
    end
    cb(out)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetMute', function(source, cb, kind, targetId, on)
    local xPlayer = Discord_GetPlayer(source)
    targetId = tonumber(targetId)
    if xPlayer == nil or not targetId or (kind ~= 'channel' and kind ~= 'server') then cb(false) return end
    local serverId = targetId
    if kind == 'channel' then serverId = Discord_GetServerIdForChannel(targetId) end
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    if on then
        Exec("INSERT IGNORE INTO phone_discord_mutes (identifier, kind, target_id) VALUES (@i, @k, @t)", { ['@i'] = xPlayer.identifier, ['@k'] = kind, ['@t'] = targetId })
    else
        Exec("DELETE FROM phone_discord_mutes WHERE identifier = @i AND kind = @k AND target_id = @t", { ['@i'] = xPlayer.identifier, ['@k'] = kind, ['@t'] = targetId })
    end
    cb(true)
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:SetNickname', function(source, cb, serverId, memberRowId, nickname)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or serverId == nil then cb(false) return end
    local ctx = loadCtx(xPlayer.identifier, serverId, source)
    if not ctx.isMember then cb(false) return end

    local targetRow, targetIdent = ctx.member.id, xPlayer.identifier
    memberRowId = tonumber(memberRowId)
    if memberRowId and memberRowId > 0 and memberRowId ~= ctx.member.id then
        if not ctxCan(ctx, 'moderate', nil) then cb(false) return end
        local t = Q("SELECT id, identifier FROM phone_discord_members WHERE id = @m AND server_id = @s", { ['@m'] = memberRowId, ['@s'] = serverId })[1]
        if not t or not (ctx.full or Discord_ExtOutranks(xPlayer.identifier, serverId, t.identifier)) then cb(false) return end
        targetRow, targetIdent = t.id, t.identifier
    end

    nickname = clean(nickname, 32)
    if nickname == "" then
        local p = ESX.GetPlayerFromIdentifier(targetIdent)
        nickname = p and Discord_GetDisplayName(p.source) or "Player"
    end
    Exec("UPDATE phone_discord_members SET nickname = @n WHERE id = @id", { ['@n'] = nickname, ['@id'] = targetRow })
    pushExtras(serverId, { members = true })
    cb({ ok = true, nickname = nickname })
end)

-- Opens a channel: returns where the player stopped reading (for the "NEW MESSAGES" line) and marks it read.
ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:EnterChannel', function(source, cb, channelId)
    local xPlayer = Discord_GetPlayer(source)
    channelId = tonumber(channelId)
    if xPlayer == nil or not channelId then cb(false) return end
    local serverId = Discord_GetServerIdForChannel(channelId)
    if serverId == nil or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    local prev = Q("SELECT last_id FROM phone_discord_seen WHERE identifier = @i AND channel_id = @c", { ['@i'] = xPlayer.identifier, ['@c'] = channelId })[1]
    Exec([[REPLACE INTO phone_discord_seen (identifier, channel_id, last_id)
           VALUES (@i, @c, COALESCE((SELECT MAX(id) FROM phone_discord_messages WHERE channel_id = @c), 0))]], { ['@i'] = xPlayer.identifier, ['@c'] = channelId })
    cb({ lastSeen = prev and tonumber(prev.last_id) or nil })
end)

local function folderState(identifier)
    local folders, byId = {}, {}
    for _, f in ipairs(Q("SELECT id, name, color FROM phone_discord_folders WHERE identifier = @i ORDER BY id", { ['@i'] = identifier })) do
        f.servers = {}
        folders[#folders + 1] = f
        byId[f.id] = f
    end
    for _, it in ipairs(Q("SELECT server_id, folder_id FROM phone_discord_folder_items WHERE identifier = @i", { ['@i'] = identifier })) do
        if byId[it.folder_id] then table.insert(byId[it.folder_id].servers, it.server_id) end
    end
    return folders
end

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:GetFolders', function(source, cb)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb({}) return end
    cb(folderState(xPlayer.identifier))
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:CreateFolder', function(source, cb, name, color, serverId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil then cb(false) return end
    name = clean(name, 24)
    if name == "" then name = "Folder" end
    if not validColor(color) or color == "" or color == nil then color = "#5865F2" end
    if Q("SELECT COUNT(*) AS c FROM phone_discord_folders WHERE identifier = @i", { ['@i'] = xPlayer.identifier })[1].c >= 20 then cb(false) return end
    local id = MySQL.Sync.insert("INSERT INTO phone_discord_folders (identifier, name, color) VALUES (@i, @n, @c)", { ['@i'] = xPlayer.identifier, ['@n'] = name, ['@c'] = color })
    serverId = tonumber(serverId)
    if serverId and Discord_IsMember(xPlayer.identifier, serverId) then
        Exec("REPLACE INTO phone_discord_folder_items (identifier, server_id, folder_id) VALUES (@i, @s, @f)", { ['@i'] = xPlayer.identifier, ['@s'] = serverId, ['@f'] = id })
    end
    cb(folderState(xPlayer.identifier))
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:MoveToFolder', function(source, cb, serverId, folderId)
    local xPlayer = Discord_GetPlayer(source)
    serverId, folderId = tonumber(serverId), tonumber(folderId)
    if xPlayer == nil or not serverId or not Discord_IsMember(xPlayer.identifier, serverId) then cb(false) return end
    if not folderId or folderId == 0 then
        Exec("DELETE FROM phone_discord_folder_items WHERE identifier = @i AND server_id = @s", { ['@i'] = xPlayer.identifier, ['@s'] = serverId })
    else
        if Q("SELECT 1 AS x FROM phone_discord_folders WHERE id = @f AND identifier = @i", { ['@f'] = folderId, ['@i'] = xPlayer.identifier })[1] == nil then cb(false) return end
        Exec("REPLACE INTO phone_discord_folder_items (identifier, server_id, folder_id) VALUES (@i, @s, @f)", { ['@i'] = xPlayer.identifier, ['@s'] = serverId, ['@f'] = folderId })
    end
    cb(folderState(xPlayer.identifier))
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:EditFolder', function(source, cb, folderId, name, color)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or not tonumber(folderId) then cb(false) return end
    name = clean(name, 24)
    if name == "" or not validColor(color) then cb(false) return end
    Exec("UPDATE phone_discord_folders SET name = @n, color = COALESCE(NULLIF(@c, ''), color) WHERE id = @f AND identifier = @i", { ['@n'] = name, ['@c'] = color or "", ['@f'] = folderId, ['@i'] = xPlayer.identifier })
    cb(folderState(xPlayer.identifier))
end)

ESX.RegisterServerCallback('Unique_Phone:server:DiscordExt:DeleteFolder', function(source, cb, folderId)
    local xPlayer = Discord_GetPlayer(source)
    if xPlayer == nil or not tonumber(folderId) then cb(false) return end
    Exec("DELETE FROM phone_discord_folders WHERE id = @f AND identifier = @i", { ['@f'] = folderId, ['@i'] = xPlayer.identifier })
    cb(folderState(xPlayer.identifier))
end)

-- Tidy: servers that no longer exist / memberships that ended drop out of folders.
CreateThread(function()
    Wait(60000)
    while true do
        Exec([[DELETE fi FROM phone_discord_folder_items fi
               LEFT JOIN phone_discord_members m ON m.server_id = fi.server_id AND m.identifier = fi.identifier WHERE m.id IS NULL]])
        Wait(60 * 60 * 1000)
    end
end)
