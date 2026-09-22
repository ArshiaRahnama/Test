-- ================================================================= --
-- Leaderboard: Top 10 Players (composite score) and Top 10 Gangs (by
-- real gang XP). Read-only, no player input affects the query except
-- which of the two fixed rankings to return.
-- ================================================================= --

-- Player "power score" weighting — level is the primary driver (it's
-- the character's core prestige), then hours played, then coin, with
-- in-level xp as a small tiebreaker. Adjust the multipliers here if
-- you want a different balance.
local SCORE_RANK_WEIGHT     = 1000
local SCORE_HOUR_WEIGHT     = 5
local SCORE_COIN_WEIGHT     = 2

-- Cached briefly so the "am I / are they top 3" check (used for the
-- rare avatar frame) doesn't require its own extra query on every
-- profile/compare fetch. Refreshed whenever the leaderboard itself is
-- queried, which already happens on menu open + every 30s auto-refresh.
local top3Identifiers = {} -- [identifier] = 1|2|3

local function getPlayerTier(identifier)
    return identifier and top3Identifiers[identifier] or nil
end

-- ================================================================= --
-- GANG SYSTEM MIGRATION (Unique_ALLGangs replaced the old gang
-- resource): xp/level/logo used to live on `gangs_data` (gang_name,
-- xp, rank, Level, logo). Unique_ALLGangs repurposes `gangs_data`
-- entirely for gang assets (blip/boss/locker/armory/vehicles) — it no
-- longer has xp/level/logo columns at all. Those now live on the
-- `gangs` table instead, under different names: `name` (technical
-- gang name, matches xPlayer.gang.name), `label` (display name),
-- `level` (no more separate `rank`/`Level` split — just one level
-- column, scale defined by Unique_ALLGangs' own Config.GangLeveL,
-- currently 1-10), and `logo`. Querying the old table/columns here
-- silently returned nothing (no error, just an always-empty gang
-- leaderboard) rather than breaking loudly, which is why it went
-- unnoticed. `label` is preferred for display since it's the
-- human-readable gang name (e.g. "The Ballas") vs `name` being the
-- internal/technical one; falls back to `name` if label is unset.
-- ================================================================= --

ESX.RegisterServerCallback('HUD_Menu:GetLeaderboard', function(source, cb, kind)
    if kind == 'gangs' then
        MySQL.Async.fetchAll([[
            SELECT name, label, xp, level
            FROM gangs
            WHERE name IS NOT NULL AND name <> 'nogang'
            ORDER BY xp DESC
            LIMIT 10
        ]], {}, function(result)
            local entries = {}
            for i = 1, #result do
                table.insert(entries, {
                    position = i,
                    name     = (result[i].label and result[i].label ~= '') and result[i].label or result[i].name,
                    xp       = result[i].xp or 0,
                    rank     = result[i].level or 0,
                })
            end
            cb(entries)
        end)
        return
    end

    MySQL.Async.fetchAll(([[
        SELECT identifier, playerName, rank, xp, coin, timePlay,
               (rank * %d + xp + FLOOR(timePlay / 3600) * %d + coin * %d) AS score
        FROM users
        ORDER BY score DESC
        LIMIT 10
    ]]):format(SCORE_RANK_WEIGHT, SCORE_HOUR_WEIGHT, SCORE_COIN_WEIGHT), {}, function(result)
        top3Identifiers = {}
        local entries = {}
        for i = 1, #result do
            if i <= 3 then
                top3Identifiers[result[i].identifier] = i
            end
            table.insert(entries, {
                position = i,
                name     = result[i].playerName or 'Unknown',
                rank     = result[i].rank or 1,
                xp       = result[i].xp or 0,
                coin     = result[i].coin or 0,
                hours    = math.floor((result[i].timePlay or 0) / 3600),
                tier     = i <= 3 and i or nil,
            })
        end

        local xPlayer = ESX.GetPlayerFromId(source)
        cb(entries, xPlayer and getPlayerTier(xPlayer.identifier) or nil)
    end)
end)

-- Compare Players: read-only lookup by player name (already shown on
-- the leaderboard, nothing sensitive exposed beyond the same stats
-- everyone already sees listed there).
ESX.RegisterServerCallback('HUD_Menu:GetPlayerStats', function(source, cb, playerName)
    if not playerName then return cb(nil) end

    MySQL.Async.fetchAll('SELECT identifier, playerName, rank, xp, coin, timePlay FROM users WHERE playerName = @name LIMIT 1', {
        ['@name'] = playerName
    }, function(result)
        if not result[1] then return cb(nil) end
        cb({
            name  = result[1].playerName,
            level = result[1].rank or 1,
            xp    = result[1].xp or 0,
            coin  = result[1].coin or 0,
            hours = math.floor((result[1].timePlay or 0) / 3600),
            tier  = getPlayerTier(result[1].identifier),
        })
    end)
end)

-- ================================================================= --
-- PER-JOB LEADERBOARD ("Top Police This Week", "Top Mechanic This
-- Month", ...) — ranks members of ONE tracked job by real on-duty
-- time, read from `duty_logs` (the exact same table the DUTY tab
-- already reads — see server/duty.lua's own note on esx_duty writing
-- rows keyed by `steamhex`, and Config.TrackedJobs being the same
-- allow-list the DUTY/SKILL tabs already use). Open to everyone, not
-- just org members — same "public leaderboard" spirit as GetLeaderboard
-- above, just scoped to one job instead of the whole server.
--
-- PHOTO PODIUM: the top 3 get their users.Profile_Pic if they have one
-- set. This now needs an INNER JOIN (not LEFT) to `users` anyway, for
-- the CURRENT-JOB filter below — see that note.
--
-- CURRENT-JOB FILTER: `duty_logs` is a lifetime log of every job a
-- player has EVER clocked hours in, not just their current one — a
-- player who was FBI last month and is Police now still has old FBI
-- rows sitting in the table forever. Without filtering, that player
-- shows up as a top contender for BOTH jobs at once, which is exactly
-- the "one person filling five job slots" bug seen in testing. So
-- this only counts a player toward job X if `users.job` (their job
-- RIGHT NOW, stripped of the `off` duty-toggle prefix the same way
-- server/duty.lua's own orgName does) is ALSO X — someone who's
-- switched away simply stops counting here until they take that job
-- again, even though their historical hours are still sitting in
-- duty_logs untouched.
-- ================================================================= --

ESX.RegisterServerCallback('HUD_Menu:GetJobLeaderboard', function(source, cb, jobName, period)
    -- Only ever query a job this resource actually tracks — same
    -- allow-list server/duty.lua and server/skill.lua already gate on,
    -- doubles as belt-and-braces on top of the parameterized query below.
    if not jobName or not Config.TrackedJobs[jobName] then
        cb({}, nil)
        return
    end

    -- "This week" uses the exact same rolling 7-day window
    -- server/duty.lua's own weekSeconds already uses, so "this week"
    -- means the same thing everywhere in the HUD. "This month" is the
    -- calendar month (1st @ 00:00 to now), which reads more naturally
    -- as "این ماه" than a rolling 30 days would.
    local sinceClause = (period == 'month')
        and "dl.date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')"
        or "dl.date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)"

    MySQL.Async.fetchAll(([[
        SELECT dl.ic_name AS name,
               SUM(dl.total_time) AS seconds,
               u.Profile_Pic AS avatarUrl
        FROM duty_logs dl
        INNER JOIN users u ON CONVERT(u.identifier USING utf8mb4) COLLATE utf8mb4_general_ci
                            = CONVERT(dl.steamhex USING utf8mb4) COLLATE utf8mb4_general_ci
        WHERE dl.job_name = @job AND %s
          AND (CASE WHEN u.job LIKE 'off%%' THEN SUBSTRING(u.job, 4) ELSE u.job END) = @job
        GROUP BY dl.steamhex, dl.ic_name
        ORDER BY seconds DESC
        LIMIT 10
    ]]):format(sinceClause), {
        ['@job'] = jobName,
    }, function(result)
        local entries = {}
        for i = 1, #(result or {}) do
            local seconds = tonumber(result[i].seconds) or 0
            table.insert(entries, {
                position  = i,
                name      = string.gsub(result[i].name or '?', '_', ' '),
                seconds   = seconds,
                hours     = math.floor(seconds / 3600),
                minutes   = math.floor((seconds % 3600) / 60),
                -- Photo podium only for the top 3, and only when a
                -- real picture is actually set (menu.lua's own
                -- avatarUrl convention: nil, never an empty string).
                avatarUrl = (i <= 3 and result[i].avatarUrl and result[i].avatarUrl ~= '')
                    and result[i].avatarUrl or nil,
            })
        end
        cb(entries, Config.TrackedJobs[jobName])
    end)
end)

-- ================================================================= --
-- JOB CHAMPIONS GRID — the PER JOB subtab's landing view: the #1
-- ranked member of EVERY tracked job at once (same duty_logs source,
-- same current-job filter, and same week/month definitions as
-- GetJobLeaderboard above), so the player sees the whole "who's #1 in
-- every org" picture before drilling into any single job's full top 10.
--
-- One query for every job instead of N (one per Config.TrackedJobs
-- entry) — the per-job MAX is picked in Lua rather than SQL, since
-- doing that in SQL cleanly needs a window function (ROW_NUMBER()),
-- and MariaDB version support for those varies host to host; this
-- result set is small (one row per job per CURRENT member who did any
-- duty this week/month) and only ever fetched on menu-open / a 30s
-- refresh / a period toggle, so the extra Lua pass costs nothing
-- worth avoiding it for.
-- ================================================================= --

ESX.RegisterServerCallback('HUD_Menu:GetJobChampions', function(source, cb, period)
    local sinceClause = (period == 'month')
        and "dl.date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')"
        or "dl.date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY)"

    -- Parameterized IN (...) built from Config.TrackedJobs, rather than
    -- leaving the WHERE unfiltered — keeps a duty_logs row for some
    -- untracked player-run company job from ever slipping into this.
    local placeholders, params = {}, {}
    local i = 0
    for jobKey in pairs(Config.TrackedJobs) do
        i = i + 1
        local ph = ('@job%d'):format(i)
        placeholders[i] = ph
        params[ph] = jobKey
    end

    MySQL.Async.fetchAll(([[
        SELECT dl.job_name AS jobName, dl.ic_name AS name,
               SUM(dl.total_time) AS seconds,
               u.Profile_Pic AS avatarUrl
        FROM duty_logs dl
        INNER JOIN users u ON CONVERT(u.identifier USING utf8mb4) COLLATE utf8mb4_general_ci
                            = CONVERT(dl.steamhex USING utf8mb4) COLLATE utf8mb4_general_ci
        WHERE dl.job_name IN (%s) AND %s
          -- Same current-job filter as GetJobLeaderboard above: a row
          -- only counts toward THIS job if it's also the player's job
          -- right now, so nobody shows up as champion of five old
          -- jobs they've long since left.
          AND dl.job_name = (CASE WHEN u.job LIKE 'off%%' THEN SUBSTRING(u.job, 4) ELSE u.job END)
        GROUP BY dl.job_name, dl.steamhex, dl.ic_name
    ]]):format(table.concat(placeholders, ', '), sinceClause), params, function(result)
        local best = {}
        for _, row in ipairs(result or {}) do
            local seconds = tonumber(row.seconds) or 0
            local current = best[row.jobName]
            if not current or seconds > current.seconds then
                best[row.jobName] = {
                    name      = string.gsub(row.name or '?', '_', ' '),
                    seconds   = seconds,
                    avatarUrl = (row.avatarUrl and row.avatarUrl ~= '') and row.avatarUrl or nil,
                }
            end
        end

        local champions = {}
        for jobKey, jobLabel in pairs(Config.TrackedJobs) do
            local top = best[jobKey]
            champions[jobKey] = {
                label     = jobLabel,
                hasData   = top ~= nil,
                name      = top and top.name or nil,
                hours     = top and math.floor(top.seconds / 3600) or 0,
                minutes   = top and math.floor((top.seconds % 3600) / 60) or 0,
                avatarUrl = top and top.avatarUrl or nil,
            }
        end
        cb(champions)
    end)
end)

-- ================================================================= --
-- GANG WATCH — Top 5 gangs by community-service sentences handed to
-- their OWN members this calendar month. Reads `punishment_history`
-- (server/migrations.lua in Unique_AdminPanel — a permanent log of
-- jail/CS sentences, written by punish_cs.lua's SendToCommunityService
-- with type = 'community_service') joined to `users.gang` for each
-- sentenced player's gang, and `gangs` for the display label/logo
-- (same table + same label-over-name preference server/menu.lua and
-- the GetLeaderboard 'gangs' branch above already use).
--
-- CAVEAT worth knowing: this attributes every sentence to whatever
-- gang that player is in RIGHT NOW, not whatever gang they were in
-- the moment they were sentenced (punishment_history doesn't record
-- gang at all, only identifier). Someone who left/joined a gang after
-- being sentenced shifts which gang's count it counts toward. Same
-- class of simplification the score-based player/gang leaderboards
-- above already accept (both are current-state snapshots, not
-- historical reconstructions) — acceptable for "which gangs are
-- currently causing trouble", not meant as a legal audit trail.
--
-- COLLATE NOTE: `users`, `gangs` and `punishment_history` were each
-- created by a different resource's own migration (see
-- server/migrations.lua here, Unique_ALLGangs/database.sql, and
-- Unique_AdminPanel's punish_migrations.lua) at whatever the server's
-- default charset/collation happened to be set to at the time — on
-- this server that drifted (some columns ended up plain `utf8` +
-- utf8mb4_unicode_ci, others utf8mb4 + utf8mb4_general_ci), which
-- MySQL/MariaDB refuses to compare with a bare `=` ("Illegal mix of
-- collations"). A bare `COLLATE utf8mb4_general_ci` isn't enough on
-- its own either — MySQL also rejects attaching a utf8mb4 collation
-- straight onto a column whose charset isn't utf8mb4 yet ("COLLATION
-- ... is not valid for CHARACTER SET ..."). CONVERT(... USING
-- utf8mb4) normalizes the charset FIRST, then COLLATE picks a
-- consistent collation on top — this works regardless of which way
-- any individual table actually drifted.
-- ================================================================= --

ESX.RegisterServerCallback('HUD_Menu:GetGangWatch', function(source, cb)
    MySQL.Async.fetchAll([[
        SELECT u.gang AS gangName,
               g.label AS gangLabel,
               g.logo AS gangLogo,
               COUNT(*) AS csCount
        FROM punishment_history ph
        INNER JOIN users u ON CONVERT(u.identifier USING utf8mb4) COLLATE utf8mb4_general_ci
                             = CONVERT(ph.identifier USING utf8mb4) COLLATE utf8mb4_general_ci
        LEFT JOIN gangs g ON CONVERT(g.name USING utf8mb4) COLLATE utf8mb4_general_ci
                            = CONVERT(u.gang USING utf8mb4) COLLATE utf8mb4_general_ci
        WHERE ph.type = 'community_service'
          AND ph.created_at >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
          AND u.gang IS NOT NULL AND u.gang <> 'none'
        GROUP BY u.gang, g.label, g.logo
        ORDER BY csCount DESC
        LIMIT 5
    ]], {}, function(result)
        local entries = {}
        for i = 1, #(result or {}) do
            entries[i] = {
                position = i,
                name     = (result[i].gangLabel and result[i].gangLabel ~= '') and result[i].gangLabel or result[i].gangName,
                count    = tonumber(result[i].csCount) or 0,
                -- Same 'defaultlogo'/Unique_ALLGangs placeholder filter
                -- server/menu.lua already applies to gang logos.
                logoUrl  = (result[i].gangLogo and result[i].gangLogo ~= '' and result[i].gangLogo ~= 'img/gangicon.png')
                    and result[i].gangLogo or nil,
            }
        end
        cb(entries)
    end)
end)
