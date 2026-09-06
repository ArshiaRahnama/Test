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
