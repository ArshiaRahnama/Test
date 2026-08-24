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

ESX.RegisterServerCallback('HUD_Menu:GetLeaderboard', function(source, cb, kind)
    if kind == 'gangs' then
        MySQL.Async.fetchAll([[
            SELECT gang_name, xp, rank, Level
            FROM gangs_data
            WHERE gang_name IS NOT NULL
            ORDER BY xp DESC
            LIMIT 10
        ]], {}, function(result)
            local entries = {}
            for i = 1, #result do
                table.insert(entries, {
                    position = i,
                    name     = result[i].gang_name,
                    xp       = result[i].xp or 0,
                    rank     = result[i].rank or 0,
                })
            end
            cb(entries)
        end)
        return
    end

    MySQL.Async.fetchAll(([[
        SELECT playerName, rank, xp, coin, timePlay,
               (rank * %d + xp + FLOOR(timePlay / 3600) * %d + coin * %d) AS score
        FROM users
        ORDER BY score DESC
        LIMIT 10
    ]]):format(SCORE_RANK_WEIGHT, SCORE_HOUR_WEIGHT, SCORE_COIN_WEIGHT), {}, function(result)
        local entries = {}
        for i = 1, #result do
            table.insert(entries, {
                position = i,
                name     = result[i].playerName or 'Unknown',
                rank     = result[i].rank or 1,
                xp       = result[i].xp or 0,
                coin     = result[i].coin or 0,
                hours    = math.floor((result[i].timePlay or 0) / 3600),
            })
        end
        cb(entries)
    end)
end)

-- Compare Players: read-only lookup by player name (already shown on
-- the leaderboard, nothing sensitive exposed beyond the same stats
-- everyone already sees listed there).
ESX.RegisterServerCallback('HUD_Menu:GetPlayerStats', function(source, cb, playerName)
    if not playerName then return cb(nil) end

    MySQL.Async.fetchAll('SELECT playerName, rank, xp, coin, timePlay FROM users WHERE playerName = @name LIMIT 1', {
        ['@name'] = playerName
    }, function(result)
        if not result[1] then return cb(nil) end
        cb({
            name  = result[1].playerName,
            rank  = result[1].rank or 1,
            xp    = result[1].xp or 0,
            coin  = result[1].coin or 0,
            hours = math.floor((result[1].timePlay or 0) / 3600),
        })
    end)
end)
