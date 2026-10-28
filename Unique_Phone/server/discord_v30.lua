-- ==========================================================================
-- Discord app v30 — rank-based job servers.
--  * one Discord role per job rank (named after the rank label, e.g. "Judge", "Chief Justice")
--  * people get the role of their current grade automatically
--  * the TOP rank of a job gets full access (administrator)
--  * channels can be limited to a minimum rank (Config.DiscordJobRanks)
-- Called by syncJobs() in discord_ext.lua for every job server.
-- ==========================================================================
local function Q(sql, p) return ExecuteSql(true, sql, p or {}) end
local function Exec(sql, p) return MySQL.Sync.execute(sql, p or {}) end

local RANK_PERMS_NORMAL = '{"view":true,"send":true,"react":true}'
local RANK_PERMS_TOP = '{"view":true,"send":true,"react":true,"pin":true,"manage_messages":true,"manage_channels":true,"manage_roles":true,"administrator":true}'

local function cfg()
    return (Config and Config.DiscordJobRanks) or { Enabled = true, ChannelMinGrade = {} }
end

local function roleForRank(sid, name)
    return Q("SELECT id FROM phone_discord_roles WHERE server_id = @s AND name = @n", { ['@s'] = sid, ['@n'] = name })[1]
end

function Discord_JobRankSync(sid, jobName, users)
    local c = cfg()
    if c.Enabled == false then return end

    local grades = Q("SELECT grade, label, name FROM job_grades WHERE job_name = @j ORDER BY grade ASC", { ['@j'] = jobName })
    if #grades == 0 then return end
    local top = grades[#grades].grade

    -- 1) one role per rank (create or refresh its permissions and position)
    local roleByGrade = {}
    for i, g in ipairs(grades) do
        local label = tostring(g.label or g.name or ("Rank " .. g.grade)):sub(1, 32)
        local perms = (g.grade == top) and RANK_PERMS_TOP or RANK_PERMS_NORMAL
        local row = roleForRank(sid, label)
        if row then
            Exec("UPDATE phone_discord_roles SET perms = @p, position = @pos WHERE id = @id", { ['@p'] = perms, ['@pos'] = i, ['@id'] = row.id })
            roleByGrade[g.grade] = row.id
        else
            roleByGrade[g.grade] = MySQL.Sync.insert(
                "INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default, hoist) VALUES (@s, @n, NULL, @pos, @p, 0, 0, 1)",
                { ['@s'] = sid, ['@n'] = label, ['@pos'] = i, ['@p'] = perms })
        end
    end

    -- 2) everyone gets exactly the role of their current rank
    local rankRoleIds = {}
    for _, id in pairs(roleByGrade) do table.insert(rankRoleIds, id) end
    if #rankRoleIds > 0 then
        local marks, p = {}, { ['@s'] = sid }
        for i, id in ipairs(rankRoleIds) do marks[#marks + 1] = "@r" .. i; p["@r" .. i] = id end
        Exec("DELETE FROM phone_discord_member_roles WHERE server_id = @s AND role_id IN (" .. table.concat(marks, ",") .. ")", p)
    end
    for _, u in ipairs(users) do
        local rid = roleByGrade[tonumber(u.job_grade) or -1]
        if rid then
            Exec("INSERT INTO phone_discord_member_roles (server_id, identifier, role_id) VALUES (@s, @i, @r)",
                { ['@s'] = sid, ['@i'] = u.identifier, ['@r'] = rid })
        end
    end

    -- 3) channels with a minimum rank: @everyone cannot see them, ranks at or above the minimum can
    local everyone = Q("SELECT id FROM phone_discord_roles WHERE server_id = @s AND is_default = 1 LIMIT 1", { ['@s'] = sid })[1]
    if not everyone then return end
    for chName, minGrade in pairs(c.ChannelMinGrade or {}) do
        local ch = Q("SELECT id FROM phone_discord_channels WHERE server_id = @s AND name = @n", { ['@s'] = sid, ['@n'] = chName })[1]
        if ch then
            Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, '[]', '[\"view\"]')",
                { ['@c'] = ch.id, ['@r'] = everyone.id })
            for _, g in ipairs(grades) do
                if g.grade >= minGrade then
                    local rid = roleByGrade[g.grade]
                    if rid then
                        Exec("REPLACE INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (@c, @r, '[\"view\",\"send\",\"react\"]', '[]')",
                            { ['@c'] = ch.id, ['@r'] = rid })
                    end
                end
            end
        end
    end
end
