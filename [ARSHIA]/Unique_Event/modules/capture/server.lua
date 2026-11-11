-- ============================================================================
--  Unique Capture  -  SERVER  (Sun-style core)
--  هسته‌ی بازی (زون‌ها، worldها، join/exit، پرچم، امتیاز، اسکوربورد) از نو نوشته شده.
--  بخش دیتابیس/فصل/مدال/هال‌آوفیم/داشبورد از نسخه‌ی قبلی بدون تغییر منتقل شده.
--  تمام رویدادهای حساس سمت سرور اعتبارسنجی میشن (دیگه هیچ کلاینتی نمی‌تونه
--  راند رو استارت/پایان بده، کیل بده یا پرچم رو آنی بگیره).
-- ============================================================================
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- ===== [kept from previous Unique version: logging, DB, seasons, hall of fame] =====
function SendLog(category, embed)
    if not CapConfig.EnableDetailedLogging then return end
    local url = CapConfig.Webhooks and CapConfig.Webhooks[category]
    if not url or url == "" then return end

    embed.footer = embed.footer or { text = CapConfig.LogUsername .. " | " .. category }
    embed.timestamp = embed.timestamp or os.date("!%Y-%m-%dT%H:%M:%SZ")

    local payload = {
        username = CapConfig.LogUsername,
        embeds = { embed },
    }
    if CapConfig.LogAvatarUrl and CapConfig.LogAvatarUrl ~= "" then
        payload.avatar_url = CapConfig.LogAvatarUrl
    end

    PerformHttpRequest(url, function(err, text, headers)
        if err and err ~= 200 and err ~= 204 then
            print("^1[Unique-Capture]^7 Discord log failed for category '" .. category .. "' (HTTP " .. tostring(err) .. ")")
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_history` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `round_date` DATETIME NOT NULL,
          `winner_gang` VARCHAR(50) DEFAULT NULL,
          `winner_points` INT DEFAULT 0,
          `top_killer_name` VARCHAR(100) DEFAULT NULL,
          `top_killer_kills` INT DEFAULT 0,
          `top_gangs_json` TEXT,
          `top_killers_json` TEXT,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_player_stats` (
          `identifier` VARCHAR(60) NOT NULL,
          `name` VARCHAR(100) DEFAULT NULL,
          `kills` INT NOT NULL DEFAULT 0,
          `deaths` INT NOT NULL DEFAULT 0,
          `top5_count` INT NOT NULL DEFAULT 0,
          `gang_points` INT NOT NULL DEFAULT 0,
          PRIMARY KEY (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)
    MySQL.Async.execute("ALTER TABLE capture_player_stats ADD COLUMN IF NOT EXISTS gang_points INT NOT NULL DEFAULT 0", {}, function() end)
    MySQL.Async.execute("ALTER TABLE capture_player_stats ADD COLUMN IF NOT EXISTS last_rank VARCHAR(20) DEFAULT 'Bronze'", {}, function() end)
    MySQL.Async.execute("ALTER TABLE capture_player_stats ADD COLUMN IF NOT EXISTS last_active DATETIME DEFAULT NULL", {}, function() end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_player_zone_stats` (
          `identifier` VARCHAR(60) NOT NULL,
          `zone_name` VARCHAR(100) NOT NULL,
          `points` INT NOT NULL DEFAULT 0,
          PRIMARY KEY (`identifier`, `zone_name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_meta` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL DEFAULT 1,
          `last_reset` DATETIME NOT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_seasons` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL,
          `ended_date` DATETIME NOT NULL,
          `winner_identifier` VARCHAR(60) DEFAULT NULL,
          `winner_name` VARCHAR(100) DEFAULT NULL,
          `winner_score` INT DEFAULT 0,
          `winner_gang_name` VARCHAR(50) DEFAULT NULL,
          `winner_gang_points` INT DEFAULT 0,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)
    MySQL.Async.execute("ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_name VARCHAR(50) DEFAULT NULL", {}, function() end)
    MySQL.Async.execute("ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_points INT DEFAULT 0", {}, function() end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_season_archive` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL,
          `identifier` VARCHAR(60) NOT NULL,
          `name` VARCHAR(100) DEFAULT NULL,
          `kills` INT DEFAULT 0,
          `deaths` INT DEFAULT 0,
          `gang_points` INT DEFAULT 0,
          `top5_count` INT DEFAULT 0,
          `score` INT DEFAULT 0,
          `rank_position` INT DEFAULT 0,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_gang_stats` (
          `gang_name` VARCHAR(50) NOT NULL,
          `points` INT NOT NULL DEFAULT 0,
          PRIMARY KEY (`gang_name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_gang_season_archive` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL,
          `gang_name` VARCHAR(50) NOT NULL,
          `points` INT DEFAULT 0,
          `rank_position` INT DEFAULT 0,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_playoffs` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL,
          `match_label` VARCHAR(50) NOT NULL,
          `gang_a` VARCHAR(50) DEFAULT NULL,
          `gang_b` VARCHAR(50) DEFAULT NULL,
          `winner` VARCHAR(50) DEFAULT NULL,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_scarce_medals` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `season_number` INT NOT NULL,
          `serial_number` INT NOT NULL,
          `identifier` VARCHAR(60) NOT NULL,
          `name` VARCHAR(100) DEFAULT NULL,
          `awarded_at` DATETIME NOT NULL,
          PRIMARY KEY (`id`),
          UNIQUE KEY `season_serial` (`season_number`, `serial_number`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `capture_hall_of_fame` (
          `id` INT NOT NULL AUTO_INCREMENT,
          `identifier` VARCHAR(60) NOT NULL,
          `name` VARCHAR(100) DEFAULT NULL,
          `career_kills` INT DEFAULT 0,
          `career_gang_points` INT DEFAULT 0,
          `final_rank` VARCHAR(20) DEFAULT NULL,
          `inducted_at` DATETIME NOT NULL,
          PRIMARY KEY (`id`),
          UNIQUE KEY `identifier_unique` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(rowsChanged) end)

    Citizen.Wait(1000)
    MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(results)
        if not results or not results[1] then
            MySQL.Async.execute('INSERT INTO capture_meta (season_number, last_reset) VALUES (1, @now)', {
                ['@now'] = os.date('%Y-%m-%d %H:%M:%S')
            })
        end
        StartSeasonCheckThread()
        StartHallOfFameThread()
    end)
end)

function UpsertZoneStat(identifier, zoneName, amount)
    MySQL.Async.execute(
        'INSERT INTO capture_player_zone_stats (identifier, zone_name, points) VALUES (@identifier, @zone, @amount) '..
        'ON DUPLICATE KEY UPDATE points = points + @amount',
        {
            ['@identifier'] = identifier,
            ['@zone'] = zoneName,
            ['@amount'] = amount,
        }
    )
end

function UpsertGangStat(gangName, amount)
    if type(gangName) ~= "string" or gangName == "" or gangName == "nogang" then return end
    MySQL.Async.execute(
        'INSERT INTO capture_gang_stats (gang_name, points) VALUES (@gang, @amount) '..
        'ON DUPLICATE KEY UPDATE points = points + @amount',
        {
            ['@gang'] = gangName,
            ['@amount'] = amount,
        }
    )
end

local SeasonWarningsSent = {}

function StartSeasonCheckThread()
    Citizen.CreateThread(function()
        while true do
            Wait(60 * 60 * 1000)
            MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(results)
                local meta = results and results[1]
                if not meta then return end
                MySQL.Async.fetchAll('SELECT TIMESTAMPDIFF(HOUR, @lastReset, NOW()) as hours', {
                    ['@lastReset'] = meta.last_reset
                }, function(diffResult)
                    local hoursPassed = diffResult and diffResult[1] and diffResult[1].hours or 0
                    local totalHours = CapConfig.SeasonAutoResetDays * 24
                    local hoursRemaining = totalHours - hoursPassed

                    if CapConfig.EnableSeasonWarning and not SeasonWarningsSent[meta.season_number]
                       and hoursRemaining <= CapConfig.SeasonWarningHoursBefore and hoursRemaining > 0 then
                        SeasonWarningsSent[meta.season_number] = true
                        TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "Fasl "..meta.season_number.." Kamtar Az "..CapConfig.SeasonWarningHoursBefore.." Saat Dige Tamam Mishe! Amadeh Bashid !"}})
                        SendLog("Season", {
                            title = "⏳ Season Ending Soon",
                            color = 0xF1C40F,
                            description = "Season " .. meta.season_number .. " ends in less than " .. CapConfig.SeasonWarningHoursBefore .. " hours.",
                        })
                    end

                    if hoursPassed >= totalHours then
                        RunSeasonReset(meta.season_number)
                    end
                end)
            end)
        end
    end)
end

function StartHallOfFameThread()
    if not CapConfig.EnableHallOfFame then return end
    Citizen.CreateThread(function()
        while true do
            Wait(6 * 60 * 60 * 1000)
            MySQL.Async.fetchAll(
                'SELECT identifier, name, kills, gang_points, last_rank FROM capture_player_stats '..
                'WHERE last_rank = @rank AND last_active IS NOT NULL AND last_active < DATE_SUB(NOW(), INTERVAL @days DAY) '..
                'AND identifier NOT IN (SELECT identifier FROM capture_hall_of_fame)',
                {
                    ['@rank'] = CapConfig.ScarceMedalRank,
                    ['@days'] = CapConfig.HallOfFameInactivityDays,
                },
                function(candidates)
                    if not candidates then return end
                    for _, row in ipairs(candidates) do
                        MySQL.Async.execute(
                            'INSERT INTO capture_hall_of_fame (identifier, name, career_kills, career_gang_points, final_rank, inducted_at) '..
                            'VALUES (@id, @name, @kills, @gp, @rank, @date)',
                            {
                                ['@id'] = row.identifier,
                                ['@name'] = row.name,
                                ['@kills'] = row.kills,
                                ['@gp'] = row.gang_points,
                                ['@rank'] = row.last_rank,
                                ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
                            }
                        )
                        TriggerClientEvent('chat:addMessage', -1, {args = {
                            "^1🎖️ HALL OF FAME", "^2" .. tostring(row.name) .. " ^7Has Been Inducted Into The Hall Of Fame (" .. tostring(row.kills) .. " Career Kills) !"
                        }})
                        SendLog("Season", {
                            title = "🎖️ Hall Of Fame Induction",
                            color = 0xF2C744,
                            fields = {
                                {name = "Player", value = tostring(row.name), inline = true},
                                {name = "Final Rank", value = tostring(row.last_rank), inline = true},
                                {name = "Career Kills", value = tostring(row.kills), inline = true},
                                {name = "Career Gang Points", value = tostring(row.gang_points), inline = true},
                            },
                        })
                    end
                end
            )
        end
    end)
end

if CapConfig.EnableHallOfFame then
    RegisterCommand(CapConfig.HallOfFameCommand, function(source, args, rawCommand)
        MySQL.Async.fetchAll('SELECT * FROM capture_hall_of_fame ORDER BY inducted_at DESC LIMIT 20', {}, function(rows)
            if not rows or #rows == 0 then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Hall Of Fame Is Empty So Far."}})
                return
            end
            TriggerClientEvent("chat:addMessage", source, {args = {"^3Unique-CaptureSystem", "=== 🎖️ Hall Of Fame ==="}})
            for _, row in ipairs(rows) do
                TriggerClientEvent("chat:addMessage", source, {args = {
                    "^1🎖️", tostring(row.name) .. " - " .. tostring(row.final_rank) .. " (" .. tostring(row.career_kills) .. " kills, " .. tostring(row.career_gang_points) .. " gang pts)"
                }})
            end
        end)
    end)
end

function RunSeasonReset(currentSeasonNumber)
    if not CapConfig.BackupBeforeSeasonReset then
        PerformSeasonReset(currentSeasonNumber)
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats', {}, function(playerRows)
        MySQL.Async.fetchAll('SELECT * FROM capture_gang_stats', {}, function(gangRows)
            local backup = {
                season_number = currentSeasonNumber,
                backed_up_at = os.date('%Y-%m-%d %H:%M:%S'),
                players = playerRows or {},
                gangs = gangRows or {},
            }

            local fileName = CapConfig.BackupFolder .. "/season_" .. currentSeasonNumber .. "_" .. os.date('%Y-%m-%d_%H-%M-%S') .. ".json"
            local ok = SaveResourceFile(GetCurrentResourceName(), fileName, json.encode(backup), -1)

            if ok then
                print("^2[Unique-Capture]^7 Season " .. currentSeasonNumber .. " backup saved: " .. fileName)
            else
                print("^1[Unique-Capture]^7 WARNING: Season " .. currentSeasonNumber .. " backup FAILED to save (check server write permissions). Proceeding with reset anyway.")
            end

            PerformSeasonReset(currentSeasonNumber)
        end)
    end)
end

function PerformSeasonReset(currentSeasonNumber)
    MySQL.Async.fetchAll(
        'SELECT identifier, name, kills, deaths, gang_points, top5_count, '..
        '(kills*@wk + gang_points*@wg - deaths*@wd) as score '..
        'FROM capture_player_stats ORDER BY score DESC',
        {
            ['@wk'] = CapConfig.AllTimeScoreWeights.Kills,
            ['@wg'] = CapConfig.AllTimeScoreWeights.GangPoints,
            ['@wd'] = CapConfig.AllTimeScoreWeights.DeathPenalty,
        },
        function(rows)
            rows = rows or {}

            for i, row in ipairs(rows) do
                MySQL.Async.execute(
                    'INSERT INTO capture_season_archive (season_number, identifier, name, kills, deaths, gang_points, top5_count, score, rank_position) '..
                    'VALUES (@season, @identifier, @name, @kills, @deaths, @gang_points, @top5, @score, @rank)',
                    {
                        ['@season'] = currentSeasonNumber,
                        ['@identifier'] = row.identifier,
                        ['@name'] = row.name,
                        ['@kills'] = row.kills,
                        ['@deaths'] = row.deaths,
                        ['@gang_points'] = row.gang_points,
                        ['@top5'] = row.top5_count,
                        ['@score'] = row.score,
                        ['@rank'] = i,
                    }
                )
            end

            local winner = rows[1]

            MySQL.Async.fetchAll('SELECT gang_name, points FROM capture_gang_stats ORDER BY points DESC', {}, function(gangRows)
                gangRows = gangRows or {}

                for i, gangRow in ipairs(gangRows) do
                    MySQL.Async.execute(
                        'INSERT INTO capture_gang_season_archive (season_number, gang_name, points, rank_position) VALUES (@season, @gang, @points, @rank)',
                        {
                            ['@season'] = currentSeasonNumber,
                            ['@gang'] = gangRow.gang_name,
                            ['@points'] = gangRow.points,
                            ['@rank'] = i,
                        }
                    )
                end

                local winnerGang = gangRows[1]

                MySQL.Async.execute(
                    'INSERT INTO capture_seasons (season_number, ended_date, winner_identifier, winner_name, winner_score, winner_gang_name, winner_gang_points) '..
                    'VALUES (@season, @date, @wid, @wname, @wscore, @wgang, @wgangpoints)',
                    {
                        ['@season'] = currentSeasonNumber,
                        ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
                        ['@wid'] = winner and winner.identifier or nil,
                        ['@wname'] = winner and winner.name or nil,
                        ['@wscore'] = winner and winner.score or 0,
                        ['@wgang'] = winnerGang and winnerGang.gang_name or nil,
                        ['@wgangpoints'] = winnerGang and winnerGang.points or 0,
                    }
                )

                if winner then
                    TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "Fasl "..currentSeasonNumber.." Tamam Shod! Barande Bazikon: "..tostring(winner.name).." ("..tostring(winner.score).." pts)"}})
                end
                if winnerGang then
                    TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "Barande Gang Fasl "..currentSeasonNumber..": "..tostring(winnerGang.gang_name).." ("..tostring(winnerGang.points).." pts) | Fasle Jadid Shoro Shod!"}})
                end

                SendLog("Season", {
                    title = "🏁 Season " .. currentSeasonNumber .. " Ended",
                    color = 0x9B59B6,
                    fields = {
                        {name = "Player Champion", value = winner and (tostring(winner.name) .. " (" .. tostring(winner.score) .. " pts)") or "N/A", inline = true},
                        {name = "Gang Champion", value = winnerGang and (tostring(winnerGang.gang_name) .. " (" .. tostring(winnerGang.points) .. " pts)") or "N/A", inline = true},
                        {name = "Total Players Ranked", value = tostring(#rows), inline = true},
                    },
                })


                if CapConfig.EnableLeagueMode then
                    MySQL.Async.fetchAll('SELECT gang_name, rank_position FROM capture_gang_season_archive WHERE season_number = @prev', {
                        ['@prev'] = currentSeasonNumber - 1
                    }, function(prevRows)
                        if prevRows and #prevRows > 0 then
                            local prevRank = {}
                            for _, r in ipairs(prevRows) do prevRank[r.gang_name] = r.rank_position end
                            local bestImprovement = 0
                            local bestGang = nil
                            for i, row in ipairs(gangRows) do
                                local oldRank = prevRank[row.gang_name]
                                if oldRank then
                                    local improvement = oldRank - i
                                    if improvement > bestImprovement then
                                        bestImprovement = improvement
                                        bestGang = row.gang_name
                                    end
                                end
                            end
                            if bestGang then
                                TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "Comeback Of The Season: "..bestGang.." ("..bestImprovement.." Rank Jump !)"}})
                            end
                        end
                    end)


                    if CapConfig.EnablePlayoffs and #gangRows >= 4 then
                        local semi1a, semi1b = gangRows[1].gang_name, gangRows[4].gang_name
                        local semi2a, semi2b = gangRows[2].gang_name, gangRows[3].gang_name
                        MySQL.Async.execute('INSERT INTO capture_playoffs (season_number, match_label, gang_a, gang_b) VALUES (@s,"Semifinal 1",@a,@b)', {['@s'] = currentSeasonNumber, ['@a'] = semi1a, ['@b'] = semi1b})
                        MySQL.Async.execute('INSERT INTO capture_playoffs (season_number, match_label, gang_a, gang_b) VALUES (@s,"Semifinal 2",@a,@b)', {['@s'] = currentSeasonNumber, ['@a'] = semi2a, ['@b'] = semi2b})
                        MySQL.Async.execute('INSERT INTO capture_playoffs (season_number, match_label, gang_a, gang_b) VALUES (@s,"Final",NULL,NULL)', {['@s'] = currentSeasonNumber})
                        TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "PLAYOFFS Fasl "..currentSeasonNumber..": Semifinal1 "..semi1a.." vs "..semi1b.." | Semifinal2 "..semi2a.." vs "..semi2b}})
                    end
                end

                MySQL.Async.execute('DELETE FROM capture_gang_stats', {})
            end)

            MySQL.Async.execute('DELETE FROM capture_player_stats', {}, function()
                MySQL.Async.execute(
                    'INSERT INTO capture_meta (season_number, last_reset) VALUES (@season, @now)',
                    {
                        ['@season'] = currentSeasonNumber + 1,
                        ['@now'] = os.date('%Y-%m-%d %H:%M:%S')
                    }
                )
            end)
        end
    )
end

function UpsertPlayerStat(identifier, name, column, amount)
    if column ~= 'kills' and column ~= 'deaths' and column ~= 'top5_count' and column ~= 'gang_points' then return end
    MySQL.Async.execute(
        'INSERT INTO capture_player_stats (identifier, name, '..column..', last_active) VALUES (@identifier, @name, @amount, @now) '..
        'ON DUPLICATE KEY UPDATE '..column..' = '..column..' + @amount, name = @name, last_active = @now',
        {
            ['@identifier'] = identifier,
            ['@name'] = name,
            ['@amount'] = amount,
            ['@now'] = os.date('%Y-%m-%d %H:%M:%S'),
        }
    )
end

-- ===== [kept: ranks, medals, dashboard] =====
function GetRankForScore(score)
    local rank = CapConfig.RankThresholds[1].Name
    for _, tier in ipairs(CapConfig.RankThresholds) do
        if score >= tier.Min then
            rank = tier.Name
        end
    end
    return rank
end

function GetPlayerRank(identifier, cb)
    MySQL.Async.fetchAll('SELECT kills, deaths, gang_points FROM capture_player_stats WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(results)
        local row = results and results[1]
        local kills = row and row.kills or 0
        local deaths = row and row.deaths or 0
        local gangPoints = row and row.gang_points or 0
        local score = (kills * CapConfig.AllTimeScoreWeights.Kills) + (gangPoints * CapConfig.AllTimeScoreWeights.GangPoints) - (deaths * CapConfig.AllTimeScoreWeights.DeathPenalty)
        cb(GetRankForScore(score))
    end)
end

function CheckScarceMedalEligibility(identifier, name)
    if not CapConfig.EnableScarcityEngine then return end
    MySQL.Async.fetchAll('SELECT kills, deaths, gang_points, last_rank FROM capture_player_stats WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(results)
        local row = results and results[1]
        if not row then return end
        local score = ((row.kills or 0) * CapConfig.AllTimeScoreWeights.Kills) + ((row.gang_points or 0) * CapConfig.AllTimeScoreWeights.GangPoints) - ((row.deaths or 0) * CapConfig.AllTimeScoreWeights.DeathPenalty)
        local newRank = GetRankForScore(score)
        local oldRank = row.last_rank or "Bronze"

        if newRank ~= oldRank then
            MySQL.Async.execute('UPDATE capture_player_stats SET last_rank = @r WHERE identifier = @id', {['@r'] = newRank, ['@id'] = identifier})
        end

        if newRank == CapConfig.ScarceMedalRank and oldRank ~= CapConfig.ScarceMedalRank then
            AwardScarceMedal(identifier, name)
        end
    end)
end

function AwardScarceMedal(identifier, name)
    MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(metaResults)
        local meta = metaResults and metaResults[1]
        local seasonNumber = meta and meta.season_number or 1

        MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM capture_scarce_medals WHERE season_number = @s', {
            ['@s'] = seasonNumber
        }, function(countResult)
            local mintedCount = countResult and countResult[1] and countResult[1].c or 0
            if mintedCount >= CapConfig.ScarceMedalSupplyPerSeason then
                return
            end

            MySQL.Async.fetchAll('SELECT 1 as x FROM capture_scarce_medals WHERE season_number = @s AND identifier = @id LIMIT 1', {
                ['@s'] = seasonNumber, ['@id'] = identifier
            }, function(already)
                if already and already[1] then return end

                local serial = mintedCount + 1
                MySQL.Async.execute(
                    'INSERT INTO capture_scarce_medals (season_number, serial_number, identifier, name, awarded_at) VALUES (@s, @serial, @id, @name, @date)',
                    {
                        ['@s'] = seasonNumber,
                        ['@serial'] = serial,
                        ['@id'] = identifier,
                        ['@name'] = name,
                        ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
                    }
                )
                TriggerClientEvent('chat:addMessage', -1, {args = {
                    "^1🏅 SCARCE MEDAL",
                    "^2" .. tostring(name) .. " ^7Claimed " .. CapConfig.ScarceMedalName .. " #" .. serial .. "/" .. CapConfig.ScarceMedalSupplyPerSeason .. " For Season " .. seasonNumber .. " !"
                }})
                SendLog("Medals", {
                    title = "🏅 Scarce Medal Claimed",
                    color = 0xFFD700,
                    fields = {
                        {name = "Player", value = tostring(name), inline = true},
                        {name = "Serial", value = "#" .. serial .. "/" .. CapConfig.ScarceMedalSupplyPerSeason, inline = true},
                        {name = "Season", value = tostring(seasonNumber), inline = true},
                    },
                })
            end)
        end)
    end)
end

if CapConfig.EnableScarcityEngine then
    RegisterCommand(CapConfig.ScarcityStatusCommand, function(source, args, rawCommand)
        MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(metaResults)
            local meta = metaResults and metaResults[1]
            local seasonNumber = meta and meta.season_number or 1
            MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM capture_scarce_medals WHERE season_number = @s', {
                ['@s'] = seasonNumber
            }, function(countResult)
                local minted = countResult and countResult[1] and countResult[1].c or 0
                local remaining = math.max(0, CapConfig.ScarceMedalSupplyPerSeason - minted)
                TriggerClientEvent("chat:addMessage", source, {args = {
                    "^1Unique-CaptureSystem",
                    CapConfig.ScarceMedalName .. " (Season " .. seasonNumber .. "): " .. minted .. "/" .. CapConfig.ScarceMedalSupplyPerSeason .. " Claimed | " .. remaining .. " Remaining !"
                }})
            end)
        end)
    end)

    RegisterCommand(CapConfig.MyMedalsCommand, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll('SELECT season_number, serial_number, awarded_at FROM capture_scarce_medals WHERE identifier = @id ORDER BY season_number DESC', {
            ['@id'] = xPlayer.identifier
        }, function(rows)
            if not rows or #rows == 0 then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Any Scarce Medals Yet."}})
                return
            end
            for _, row in ipairs(rows) do
                TriggerClientEvent("chat:addMessage", source, {args = {
                    "^1🏅", CapConfig.ScarceMedalName .. " #" .. row.serial_number .. " (Season " .. row.season_number .. ") - " .. tostring(row.awarded_at)
                }})
            end
        end)
    end)
end

ESX.RegisterServerCallback("capture:GetDashboard", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats WHERE identifier = @id LIMIT 1', {
        ['@id'] = xPlayer.identifier
    }, function(mine)
        local myRow = mine and mine[1]
        local kills = myRow and myRow.kills or 0
        local deaths = myRow and myRow.deaths or 0
        local gangPoints = myRow and myRow.gang_points or 0
        local top5 = myRow and myRow.top5_count or 0
        local score = (kills * CapConfig.AllTimeScoreWeights.Kills) + (gangPoints * CapConfig.AllTimeScoreWeights.GangPoints) - (deaths * CapConfig.AllTimeScoreWeights.DeathPenalty)
        local rank = GetRankForScore(score)

        MySQL.Async.fetchAll('SELECT zone_name, points FROM capture_player_zone_stats WHERE identifier = @id ORDER BY points DESC LIMIT 5', {
            ['@id'] = xPlayer.identifier
        }, function(myZones)
            MySQL.Async.fetchAll('SELECT name, kills FROM capture_player_stats ORDER BY kills DESC LIMIT 10', {}, function(topKillers)
                MySQL.Async.fetchAll('SELECT gang_name, points FROM capture_gang_stats ORDER BY points DESC LIMIT 10', {}, function(gangStandings)
                    MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(metaResults)
                        local meta = metaResults and metaResults[1]
                        local seasonNumber = meta and meta.season_number or 1
                        local lastReset = meta and meta.last_reset or os.date('%Y-%m-%d %H:%M:%S')

                        MySQL.Async.fetchAll('SELECT TIMESTAMPDIFF(HOUR, @lastReset, NOW()) as hours', {
                            ['@lastReset'] = lastReset
                        }, function(diffResult)
                            local hoursPassed = diffResult and diffResult[1] and diffResult[1].hours or 0
                            local hoursRemaining = math.max(0, (CapConfig.SeasonAutoResetDays * 24) - hoursPassed)

                            MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM capture_scarce_medals WHERE season_number = @s', {
                                ['@s'] = seasonNumber
                            }, function(medalCount)
                                local minted = medalCount and medalCount[1] and medalCount[1].c or 0

                                MySQL.Async.fetchAll('SELECT serial_number, season_number, awarded_at FROM capture_scarce_medals WHERE identifier = @id ORDER BY season_number DESC', {
                                    ['@id'] = xPlayer.identifier
                                }, function(myMedals)
                                    MySQL.Async.fetchAll('SELECT inducted_at FROM capture_hall_of_fame WHERE identifier = @id LIMIT 1', {
                                        ['@id'] = xPlayer.identifier
                                    }, function(hofResult)
                                        cb({
                                            brand = "arshiahub.ir",
                                            myStats = {
                                                kills = kills, deaths = deaths, gang_points = gangPoints,
                                                top5 = top5, score = score, rank = rank,
                                            },
                                            myZones = myZones or {},
                                            topKillers = topKillers or {},
                                            gangStandings = gangStandings or {},
                                            season = {number = seasonNumber, hours_remaining = hoursRemaining},
                                            medals = {
                                                minted = minted,
                                                supply = CapConfig.ScarceMedalSupplyPerSeason,
                                                enabled = CapConfig.EnableScarcityEngine,
                                                mine = myMedals or {},
                                            },
                                            hallOfFame = hofResult and hofResult[1] and true or false,
                                            leagueEnabled = CapConfig.EnableLeagueMode,
                                        })
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end)


-- ============================================================================
--  CORE  (جدید)
-- ============================================================================
local Zones      = {}   -- [id] = {id,label,coords,world,captureBy,players={[src]=true},lastAlert}
local Sessions   = {}   -- [src] = {src,identifier,name,gang,zoneId,kills,deaths,contest,lastDeath,prevBucket}
local Board      = {}   -- [identifier] = {name,kills,deaths}   (اسکوربورد راند)
local GangScore  = {}   -- [gang] = points
local Round      = { active = false, id = 0, startedAt = 0, endsAt = 0, minutes = CapConfig.DefaultTime }
local HomeCache, LeavePenalty, JoinTokens, JoinCooldown = {}, {}, {}, {}
local CurrentThemeName = CapConfig.ActiveTheme

local function NowMs() return GetGameTimer() end

local function Reply(src, color, msg)
    if src == 0 then print('[Unique-Capture] ' .. tostring(msg)) return end
    TriggerClientEvent('chat:addMessage', src, { args = { (color or '^1') .. 'Unique-CaptureSystem', msg } })
end

local function HasPerm(src)
    if src == 0 then return true end
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer ~= nil and (tonumber(xPlayer.permission_level) or 0) > CapConfig.CommandPerm
end

local adminCooldowns = {}
function IsRateLimited(src, name)
    if not CapConfig.EnableAdminRateLimit or src == 0 then return false end
    local key, now = src .. ':' .. name, os.time()
    if adminCooldowns[key] and (now - adminCooldowns[key]) < CapConfig.AdminCommandCooldown then return true end
    adminCooldowns[key] = now
    return false
end

-- چک دسترسی + ریت‌لیمیت یکجا؛ true یعنی اجازه داره
local function AdminGate(src, name)
    if not HasPerm(src) then Reply(src, '^1', "You Don't Have Permissions !") return false end
    if IsRateLimited(src, name) then Reply(src, '^1', 'Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !') return false end
    return true
end

local function Notify(src, msg, typ) TriggerClientEvent('capture:notify', src, msg, typ or 'inform') end

local function GangOf(xPlayer)
    local g = xPlayer and xPlayer.gang
    if type(g) == 'table' and g.name and g.name ~= '' then return g.name end
    return 'nogang'
end

local function ExemptFromAC(src, ms)
    local ex = CapConfig.AntiCheatExempt
    if not ex or not ex.Enabled or GetResourceState(ex.Resource) ~= 'started' then return end
    pcall(function() exports[ex.Resource]:ExemptPlayer(src, ms) end)
end

local function GetSession(src, create)
    local s = Sessions[src]
    if s or not create then return s end
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    s = { src = src, identifier = xPlayer.identifier, name = GetPlayerName(src) or ('ID ' .. src),
          gang = GangOf(xPlayer), zoneId = nil, kills = 0, deaths = 0, contest = nil, lastDeath = 0 }
    Sessions[src] = s
    return s
end

local function RefreshGang(s)
    local xPlayer = ESX.GetPlayerFromId(s.src)
    if xPlayer then s.gang = GangOf(xPlayer) end
    return s.gang
end

-- ----------------------------------------------------------------------------
--  Zones
-- ----------------------------------------------------------------------------
local function NewZone(id, label, x, y, z, world)
    return { id = id, label = label, coords = vector3(x, y, z), world = world, captureBy = nil, players = {}, lastAlert = 0 }
end

local function ParseZones(decoded)
    if type(decoded) ~= 'table' then return nil end
    local out, count, maxId = {}, 0, 0
    local function add(id, label, x, y, z, world)
        id, x, y, z = tonumber(id), tonumber(x), tonumber(y), tonumber(z)
        if not id or not x or not y or not z or not label or label == '' then return end
        id = math.floor(id)
        world = math.floor(tonumber(world) or (CapConfig.WorldMin + id))
        out[id] = NewZone(id, tostring(label), x, y, z, world)
        count = count + 1
        if id > maxId then maxId = id end
    end
    local legacy = {}
    for k, v in pairs(decoded) do
        if type(v) == 'table' then
            if v.id then add(v.id, v.label, v.x, v.y, v.z, v.world)
            elseif type(k) == 'string' and v.x then legacy[#legacy + 1] = { name = k, v = v } end
        end
    end
    table.sort(legacy, function(a, b) return a.name < b.name end)
    for _, l in ipairs(legacy) do maxId = maxId + 1 add(maxId, l.name, l.v.x, l.v.y, l.v.z, nil) end
    return count > 0 and out or nil
end

local function LoadZones(force)
    if CapConfig.PersistZones or force then
        local content = LoadResourceFile(GetCurrentResourceName(), CapConfig.ZonesFileName)
        if content then
            local ok, decoded = pcall(json.decode, content)
            local zones = ok and ParseZones(decoded)
            if zones then return zones end
        end
    end
    if force then return nil end
    return ParseZones(CapConfig.DefaultZones) or {}
end

local function SaveZones()
    local list = {}
    for id, z in pairs(Zones) do list[#list + 1] = { id = id, label = z.label, x = z.coords.x, y = z.coords.y, z = z.coords.z, world = z.world } end
    table.sort(list, function(a, b) return a.id < b.id end)
    return SaveResourceFile(GetCurrentResourceName(), CapConfig.ZonesFileName, json.encode(list), -1)
end

Zones = LoadZones() or {}

local function CountZones() local n = 0 for _ in pairs(Zones) do n = n + 1 end return n end

local function InCaptureList()
    local list = {}
    for src, s in pairs(Sessions) do if s.zoneId then list[#list + 1] = src end end
    return list
end

local function NearFlag(src, zone, extra)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - zone.coords) <= (extra or (CapConfig.FlagRadius + CapConfig.FlagRadiusTolerance))
end

-- ----------------------------------------------------------------------------
--  Gang home (HQ)
-- ----------------------------------------------------------------------------
local function ExtractCoord(v)
    if type(v) ~= 'table' then return nil end
    if v.x and v.y and v.z then return tonumber(v.x), tonumber(v.y), tonumber(v.z) end
    if type(v.coord) == 'table' then return ExtractCoord(v.coord) end
    return nil
end

function ParseBossCoords(raw)
    if type(raw) ~= 'string' or raw == '' then return nil end
    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' then return nil end
    local x, y, z = ExtractCoord(decoded)
    if x then return vector3(x, y, z) end
    local best
    for _, entry in ipairs(decoded) do
        local ex, ey, ez = ExtractCoord(entry)
        if ex and (not best or tonumber(entry.code) == 1) then
            best = vector3(ex, ey, ez)
            if tonumber(entry.code) == 1 then break end
        end
    end
    return best
end

local function GetGangHome(gang, cb)
    local c = HomeCache[gang]
    if c and (os.time() - c.at) < 300 then return cb(c.coords) end
    local fb = CapConfig.FallbackHome
    MySQL.Async.fetchAll('SELECT ' .. CapConfig.GangsBossColumn .. ' as boss FROM ' .. CapConfig.GangsTable ..
        ' WHERE ' .. CapConfig.GangsNameColumn .. ' = @g LIMIT 1', { ['@g'] = gang }, function(rows)
        local coords = (rows and rows[1] and ParseBossCoords(rows[1].boss)) or vector3(fb.x, fb.y, fb.z)
        HomeCache[gang] = { coords = coords, at = os.time() }
        cb(coords)
    end)
end

-- ----------------------------------------------------------------------------
--  Leave-zone penalty
-- ----------------------------------------------------------------------------
local function PenaltyRemaining(identifier, zoneId)
    local t = LeavePenalty[identifier] and LeavePenalty[identifier][zoneId]
    if not t then return 0 end
    local r = t - os.time()
    return r > 0 and r or 0
end

-- ----------------------------------------------------------------------------
--  Zone membership
-- ----------------------------------------------------------------------------
local function LeaveZone(src, s)
    if s.zoneId and Zones[s.zoneId] then Zones[s.zoneId].players[src] = nil end
    s.zoneId, s.contest = nil, nil
end

local function SendHome(src, s)
    SetPlayerRoutingBucket(src, s.prevBucket or 0)
    s.prevBucket = nil
    ExemptFromAC(src, 10000)
    GetGangHome(s.gang, function(home)
        if GetPlayerName(src) then TriggerClientEvent('capture:exited', src, { x = home.x, y = home.y, z = home.z }) end
    end)
end

local function ForceExit(src)
    local s = Sessions[src]
    if not s or not s.zoneId then return end
    LeaveZone(src, s)
    SendHome(src, s)
end

local function ZonePlayerCounts(zone, gang)
    local pc, gc = 0, 0
    for psrc in pairs(zone.players) do
        pc = pc + 1
        local ps = Sessions[psrc]
        if ps and ps.gang == gang then gc = gc + 1 end
    end
    return pc, gc
end

-- ----------------------------------------------------------------------------
--  Callbacks
-- ----------------------------------------------------------------------------
ESX.RegisterServerCallback('capture:getCache', function(src, cb)
    local s = GetSession(src, true)
    local gang = s and RefreshGang(s) or 'nogang'
    local list = {}
    for id, z in pairs(Zones) do
        local pc, gc = ZonePlayerCounts(z, gang)
        list[#list + 1] = { id = id, label = z.label, coords = { x = z.coords.x, y = z.coords.y, z = z.coords.z },
            world = z.world, captureBy = z.captureBy, playerCount = pc, gangPlayerCount = gc,
            maxPlayerCount = CapConfig.MaxPlayersInZone, maxGangCount = CapConfig.MaxGangInZone }
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    cb(list, { active = Round.active, theme = CapConfig.Themes[CurrentThemeName] },
        Round.active and math.max(0, Round.endsAt - os.time()) or nil)
end)

ESX.RegisterServerCallback('capture:getScoreboard', function(src, cb)
    local players, gangs = {}, {}
    for _, b in pairs(Board) do players[#players + 1] = { name = b.name, kills = b.kills, deaths = b.deaths } end
    table.sort(players, function(a, b) return a.kills > b.kills end)
    for g, p in pairs(GangScore) do
        local flags = {}
        for _, z in pairs(Zones) do if z.captureBy == g then flags[#flags + 1] = z.label end end
        gangs[#gangs + 1] = { name = g, Score = p, capturedFlags = flags }
    end
    table.sort(gangs, function(a, b) return a.Score > b.Score end)
    local outP, outG = {}, {}
    for i = 1, math.min(10, #players) do outP[i] = players[i] end
    for i = 1, math.min(10, #gangs) do outG[i] = gangs[i] end
    cb({ players = outP, gangs = outG })
end)

-- ----------------------------------------------------------------------------
--  Join / Exit
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.JoinCaptureCommand, function(src)
    if src == 0 then return end
    local s = GetSession(src, true)
    if not s then return end
    if not Round.active then return Reply(src, '^1', 'Capture Not Active !') end
    if RefreshGang(s) == 'nogang' then return Reply(src, '^1', 'You Must First Join To A Gang !') end
    if s.zoneId then return TriggerClientEvent('Cap:OpenMenu', src) end
    local function allow()
        JoinTokens[src] = os.time() + 120
        TriggerClientEvent('Cap:OpenMenu', src)
    end
    if not CapConfig.NearGangBoss.Required then return allow() end
    local ped = GetPlayerPed(src)
    local pc = ped and ped ~= 0 and GetEntityCoords(ped) or nil
    GetGangHome(s.gang, function(home)
        if pc and #(pc - home) <= CapConfig.NearGangBoss.Distance then allow()
        else Reply(src, '^1', 'Go To Your Gang To Can Join !') end
    end)
end, false)

RegisterCommand(CapConfig.ReSpawnCaptureCommand, function(src)
    if src == 0 then return end
    local s = Sessions[src]
    if s and s.zoneId and Round.active then TriggerClientEvent('Cap:OpenMenu', src) end
end, false)

RegisterCommand(CapConfig.LeaveCaptureCommand, function(src)
    if src == 0 then return end
    local s = Sessions[src]
    if s and s.zoneId then TriggerClientEvent('capture:requestExit', src) end
end, false)

RegisterNetEvent('capture:join')
AddEventHandler('capture:join', function(zoneId)
    local src = source
    local now = NowMs()
    if (JoinCooldown[src] or 0) > now then return end
    JoinCooldown[src] = now + 1500
    local s = GetSession(src, true)
    if not s then return end
    local function deny(msg)
        Notify(src, msg, 'error')
        TriggerClientEvent('capture:joinDenied', src, msg)
    end
    if not Round.active then return deny('Capture Not Active !') end
    if RefreshGang(s) == 'nogang' then return deny('You Must First Join To A Gang !') end
    zoneId = tonumber(zoneId)
    local zone = zoneId and Zones[zoneId]
    if not zone then return deny('Zone Peyda Nashod !') end
    if not s.zoneId and (JoinTokens[src] or 0) < os.time() then return deny('Go To Your Gang To Can Join !') end
    if s.zoneId ~= zoneId then
        local pc, gc = ZonePlayerCounts(zone, s.gang)
        if pc >= CapConfig.MaxPlayersInZone then return deny('Zarfiat in zone por shode ast') end
        if gc >= CapConfig.MaxGangInZone then return deny('Zarfiat gang shoma dar in zone por shode ast') end
    end
    if not s.zoneId then s.prevBucket = GetPlayerRoutingBucket(src) end
    if s.zoneId and s.zoneId ~= zoneId and Zones[s.zoneId] then Zones[s.zoneId].players[src] = nil end
    s.contest = nil
    s.zoneId = zoneId
    zone.players[src] = true
    JoinTokens[src] = nil
    Board[s.identifier] = Board[s.identifier] or { name = s.name, kills = 0, deaths = 0 }
    ExemptFromAC(src, (CapConfig.SpawnProtectionTime + 6) * 1000)
    SetPlayerRoutingBucket(src, zone.world)
    TriggerClientEvent('capture:updateKillDeath', src, { kills = s.kills, deaths = s.deaths })
    TriggerClientEvent('capture:teleport', src, zoneId, zone.world)
end)

RegisterNetEvent('capture:exit')
AddEventHandler('capture:exit', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId then return TriggerClientEvent('capture:exited', src, nil) end
    if Round.active and s.contest and CapConfig.LeaveZonePenaltySeconds > 0 then
        LeavePenalty[s.identifier] = LeavePenalty[s.identifier] or {}
        LeavePenalty[s.identifier][s.contest.zoneId] = os.time() + CapConfig.LeaveZonePenaltySeconds
    end
    LeaveZone(src, s)
    SendHome(src, s)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local s = Sessions[src]
    if s then LeaveZone(src, s) end
    Sessions[src], JoinTokens[src], JoinCooldown[src] = nil, nil, nil
end)

-- ----------------------------------------------------------------------------
--  Flag: contest + capture   (تایمر سمت سرور هم چک میشه؛ کپچر آنی ممکن نیست)
-- ----------------------------------------------------------------------------
RegisterNetEvent('capture:setFlagContested')
AddEventHandler('capture:setFlagContested', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId or not Round.active then return end
    local zone = Zones[s.zoneId]
    if not zone or zone.captureBy == RefreshGang(s) or not NearFlag(src, zone) then return end
    local rem = PenaltyRemaining(s.identifier, zone.id)
    if rem > 0 then
        Notify(src, 'Shoma Az In Zone Farar Kardid! ' .. rem .. ' Sanie Digar Nemitavanid Capture Konid.', 'error')
        return TriggerClientEvent('capture:contestDenied', src)
    end
    s.contest = { zoneId = zone.id, startedAt = NowMs() }
    if zone.captureBy and (NowMs() - zone.lastAlert) > 5000 then
        zone.lastAlert = NowMs()
        for psrc in pairs(zone.players) do
            local ps = Sessions[psrc]
            if ps and ps.gang == zone.captureBy then TriggerClientEvent('capture:setFlagContested', psrc, s.gang) end
        end
    end
end)

RegisterNetEvent('capture:cancelContest')
AddEventHandler('capture:cancelContest', function()
    local s = Sessions[source]
    if s then s.contest = nil end
end)

local function CaptureZone(zone, s)
    zone.captureBy = s.gang
    local pts, ppts = CapConfig.Points.Capture, CapConfig.Points.CapturePlayer
    GangScore[s.gang] = (GangScore[s.gang] or 0) + pts
    UpsertGangStat(s.gang, pts)
    UpsertPlayerStat(s.identifier, s.name, 'gang_points', ppts)
    UpsertZoneStat(s.identifier, zone.label, ppts)
    CheckScarceMedalEligibility(s.identifier, s.name)
    for _, src in ipairs(InCaptureList()) do
        TriggerClientEvent('capture:ChangeCaptureHandler', src, zone.id, zone.captureBy)
        Notify(src, 'Gang [' .. s.gang .. '] Zone [' .. zone.label .. '] Ra Capture Kard !', 'inform')
    end
    SendLog('ZoneCapture', { title = '🚩 Zone Captured', color = 0xF39C12, fields = {
        { name = 'Zone', value = tostring(zone.label), inline = true },
        { name = 'New Owner', value = tostring(s.gang), inline = true },
        { name = 'By', value = tostring(s.name), inline = true } } })
end

RegisterNetEvent('capture:CaptureMe')
AddEventHandler('capture:CaptureMe', function()
    local src = source
    local s = Sessions[src]
    if not s or not s.zoneId or not Round.active then return end
    local c, zone = s.contest, Zones[s.zoneId]
    s.contest = nil
    if not c or not zone or c.zoneId ~= zone.id or zone.captureBy == RefreshGang(s) then return end
    if (NowMs() - c.startedAt) < (CapConfig.CaptureSeconds * 1000 - 1500) then return end
    if not NearFlag(src, zone) then return end
    CaptureZone(zone, s)
end)

-- ----------------------------------------------------------------------------
--  Death / kills   (از ایونت سرورِ esx:onPlayerDeath خودِ بیس؛ اعتبارسنجی سرور)
-- ----------------------------------------------------------------------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local victim = source
    local s = Sessions[victim]
    if not s or not s.zoneId or not Round.active then return end
    local now = NowMs()
    if now - s.lastDeath < 2500 then return end
    s.lastDeath, s.contest = now, nil
    s.deaths = s.deaths + 1
    Board[s.identifier] = Board[s.identifier] or { name = s.name, kills = 0, deaths = 0 }
    Board[s.identifier].deaths = s.deaths
    UpsertPlayerStat(s.identifier, s.name, 'deaths', 1)
    TriggerClientEvent('capture:updateKillDeath', victim, { kills = s.kills, deaths = s.deaths })

    local kid = type(data) == 'table' and tonumber(data.killer) or nil
    local k = kid and kid ~= victim and Sessions[kid]
    if k and k.zoneId == s.zoneId then
        k.kills = k.kills + 1
        Board[k.identifier] = Board[k.identifier] or { name = k.name, kills = 0, deaths = 0 }
        Board[k.identifier].kills = k.kills
        UpsertPlayerStat(k.identifier, k.name, 'kills', 1)
        CheckScarceMedalEligibility(k.identifier, k.name)
        TriggerClientEvent('capture:updateKillDeath', kid, { kills = k.kills, deaths = k.deaths })
        local z = Zones[s.zoneId]
        GetPlayerRank(k.identifier, function(kr)
            GetPlayerRank(s.identifier, function(vr)
                SendLog('Kills', { title = '🔫 Kill', color = 0xE74C3C, fields = {
                    { name = 'Killer', value = k.name .. ' [' .. kr .. '] (' .. k.gang .. ')' },
                    { name = 'Victim', value = s.name .. ' [' .. vr .. '] (' .. s.gang .. ')' },
                    { name = 'Zone', value = tostring(z and z.label), inline = true } } })
            end)
        end)
    end
end)

-- ----------------------------------------------------------------------------
--  Round lifecycle
-- ----------------------------------------------------------------------------
local function HoldTick()
    local P = CapConfig.Points
    for _, zone in pairs(Zones) do
        local owner = zone.captureBy
        if owner then
            GangScore[owner] = (GangScore[owner] or 0) + P.HoldTick
            UpsertGangStat(owner, P.HoldTick)
            for psrc in pairs(zone.players) do
                local ps = Sessions[psrc]
                if ps and ps.gang == owner and NearFlag(psrc, zone, P.HoldPresence) then
                    UpsertPlayerStat(ps.identifier, ps.name, 'gang_points', 1)
                    UpsertZoneStat(ps.identifier, zone.label, 1)
                    CheckScarceMedalEligibility(ps.identifier, ps.name)
                end
            end
        end
    end
end

local function EnforceGangs()
    for src, s in pairs(Sessions) do
        if s.zoneId then
            local old = s.gang
            local now = RefreshGang(s)
            if now == 'nogang' or now ~= old then
                Notify(src, 'Gang Shoma Taghir Kard ! Az Capture Kharej Shodid.', 'error')
                ForceExit(src)
            end
        end
    end
end

local function TopLists()
    local gangs, killers = {}, {}
    for g, p in pairs(GangScore) do gangs[#gangs + 1] = { Name = g, Points = p } end
    for id, b in pairs(Board) do if b.kills > 0 then killers[#killers + 1] = { Name = b.name, Point = b.kills, Identifier = id } end end
    table.sort(gangs, function(a, b) return a.Points > b.Points end)
    table.sort(killers, function(a, b) return a.Point > b.Point end)
    local g5, k5 = {}, {}
    for i = 1, math.min(5, #gangs) do g5[i] = gangs[i] end
    for i = 1, math.min(5, #killers) do k5[i] = killers[i] end
    return g5, k5
end

local function Hook(url, embed)
    if type(url) ~= 'string' or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST', json.encode({ username = CapConfig.LogUsername, embeds = { embed } }),
        { ['Content-Type'] = 'application/json' })
end

local function SendResult()
    local topGangs, topKillers = TopLists()
    local wg, tk = topGangs[1], topKillers[1]
    for _, k in ipairs(topKillers) do UpsertPlayerStat(k.Identifier, k.Name, 'top5_count', 1) end
    MySQL.Async.execute(
        'INSERT INTO capture_history (round_date, winner_gang, winner_points, top_killer_name, top_killer_kills, top_gangs_json, top_killers_json) ' ..
        'VALUES (@d, @wg, @wp, @tn, @tk, @gj, @kj)', {
            ['@d'] = os.date('%Y-%m-%d %H:%M:%S'), ['@wg'] = wg and wg.Name, ['@wp'] = wg and wg.Points or 0,
            ['@tn'] = tk and tk.Name, ['@tk'] = tk and tk.Point or 0,
            ['@gj'] = json.encode(topGangs), ['@kj'] = json.encode(topKillers) })
    SendLog('RoundEnd', { title = '🔴 Capture Round Ended', color = 0xE74C3C, fields = {
        { name = 'Winning Gang', value = wg and (wg.Name .. ' (' .. wg.Points .. ' pts)') or 'N/A', inline = true },
        { name = 'Top Killer', value = tk and (tk.Name .. ' (' .. tk.Point .. ' kills)') or 'N/A', inline = true } } })
    local ke, ge = { title = '🏆 Top 5 Killers', color = 0xFF0000, fields = {} }, { title = '🥇 Top 5 Gangs', color = 0x00FF00, fields = {} }
    for i, k in ipairs(topKillers) do ke.fields[#ke.fields + 1] = { name = '#' .. i .. ' - ' .. k.Name, value = 'Kills: **' .. k.Point .. '**', inline = true } end
    for i, g in ipairs(topGangs) do ge.fields[#ge.fields + 1] = { name = '#' .. i .. ' - ' .. g.Name, value = 'Points: **' .. g.Points .. '**', inline = true } end
    if #ke.fields == 0 then ke.fields[1] = { name = 'No Data', value = 'No kills.', inline = true } end
    if #ge.fields == 0 then ge.fields[1] = { name = 'No Data', value = 'No gang points.', inline = true } end
    Hook(CapConfig.KillersWebhook, ke)
    Hook(CapConfig.GangsWebhook, ge)
    return wg, tk
end

function EndRound()
    if not Round.active then return false end
    Round.active = false
    local rid = Round.id
    local wg, tk = SendResult()
    TriggerClientEvent('capture:CaptureEnded', -1)
    TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'Capture Tamam Shod ! Barande Gang: ' ..
        (wg and (wg.Name .. ' (' .. wg.Points .. ' pts)') or 'N/A') .. ' | Top Killer: ' .. (tk and (tk.Name .. ' (' .. tk.Point .. ')') or 'N/A') } })
    SetTimeout(8000, function()
        if Round.active or Round.id ~= rid then return end
        for _, src in ipairs(InCaptureList()) do ForceExit(src) end
        for _, z in pairs(Zones) do z.players, z.captureBy = {}, nil end
    end)
    return true
end

function StartRound()
    if Round.active then return false, 'Capture Already Active !' end
    if CountZones() == 0 or Round.minutes <= 0 then return false, 'First Set Zones And Time !' end
    for _, src in ipairs(InCaptureList()) do ForceExit(src) end
    for _, z in pairs(Zones) do z.players, z.captureBy, z.lastAlert = {}, nil, 0 end
    Board, GangScore = {}, {}
    for _, s in pairs(Sessions) do s.kills, s.deaths, s.contest, s.zoneId = 0, 0, nil, nil end
    Round.id = Round.id + 1
    Round.active = true
    Round.startedAt = os.time()
    Round.endsAt = Round.startedAt + Round.minutes * 60
    local rid = Round.id
    TriggerClientEvent('capture:CaptureStarted', -1, Round.minutes * 60)
    CreateThread(function()
        while Round.active and Round.id == rid do
            Wait(1000)
            if Round.active and Round.id == rid and os.time() >= Round.endsAt then EndRound() end
        end
    end)
    CreateThread(function()
        local acc = 0
        while Round.active and Round.id == rid do
            Wait(1000)
            acc = acc + 1
            if acc >= CapConfig.Points.HoldInterval then acc = 0 HoldTick() EnforceGangs() end
        end
    end)
    SendLog('RoundStart', { title = '🟢 Capture Round Started', color = 0x2ECC71, fields = {
        { name = 'Zones', value = tostring(CountZones()), inline = true },
        { name = 'Duration', value = Round.minutes .. ' min', inline = true } } })
    return true
end

RegisterCommand(CapConfig.StartCaptureCommand, function(src)
    if not HasPerm(src) then return Reply(src, '^1', "You Don't Have Permissions !") end
    local ok, err = StartRound()
    if not ok then return Reply(src, '^1', err) end
    TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'Capture Start Shod ! Baraye Join Shodan /' .. CapConfig.JoinCaptureCommand .. ' Bezanid' } })
    SendLog('Admin', { title = '▶️ Round Started By Admin', color = 0x2ECC71, fields = { { name = 'Admin', value = src == 0 and 'console' or GetPlayerName(src), inline = true } } })
end, false)

RegisterCommand(CapConfig.EndCaptureCommand, function(src)
    if not HasPerm(src) then return Reply(src, '^1', "You Don't Have Permissions !") end
    if not EndRound() then return Reply(src, '^1', 'Capture Active Nist !') end
    SendLog('Admin', { title = '⏹️ Round Force-Ended By Admin', color = 0xE67E22, fields = { { name = 'Admin', value = src == 0 and 'console' or GetPlayerName(src), inline = true } } })
end, false)

-- ----------------------------------------------------------------------------
--  Admin: zones & time   (/editCap)
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.EditCaptureCommand, function(src)
    if src == 0 then return end
    if not AdminGate(src, CapConfig.EditCaptureCommand) then return end
    TriggerClientEvent('capture:OpenAdminMenu', src)
end, false)

ESX.RegisterServerCallback('capture:adminInfo', function(src, cb)
    if not HasPerm(src) then return cb(nil) end
    local list = {}
    for id, z in pairs(Zones) do list[#list + 1] = { id = id, label = z.label, world = z.world } end
    table.sort(list, function(a, b) return a.id < b.id end)
    cb({ minutes = Round.minutes, zones = list, active = Round.active })
end)

RegisterNetEvent('capture:admin:setTime')
AddEventHandler('capture:admin:setTime', function(minutes)
    local src = source
    if not HasPerm(src) then return end
    minutes = tonumber(minutes)
    if not minutes or minutes < 1 or minutes > 600 then return Notify(src, 'Zaman Na Mo\'tabar (1-600)', 'error') end
    Round.minutes = math.floor(minutes)
    Notify(src, 'Zaman Capture: ' .. Round.minutes .. ' Daghighe', 'success')
end)

RegisterNetEvent('capture:setCap')
AddEventHandler('capture:setCap', function(input)
    local src = source
    if not HasPerm(src) then return end
    if Round.active then return Notify(src, 'Dar Hin Capture Nemitavan Zone Ra Taghir Dad !', 'error') end
    if type(input) ~= 'table' then return end
    local id, label, world = tonumber(input[1]), tostring(input[2] or ''), tonumber(input[3])
    if not id or id < 1 or id > 99 or id ~= math.floor(id) then return Notify(src, 'Shomare Zone Na Mo\'tabar (1-99)', 'error') end
    label = label:gsub('^%s+', ''):gsub('%s+$', '')
    if label == '' or #label > 24 then return Notify(src, 'Label Na Mo\'tabar', 'error') end
    if not world or world < CapConfig.WorldMin or world > CapConfig.WorldMax then
        return Notify(src, 'World Bayad Beyne ' .. CapConfig.WorldMin .. ' Ta ' .. CapConfig.WorldMax .. ' Bashad', 'error')
    end
    for zid, z in pairs(Zones) do
        if zid ~= id and string.lower(z.label) == string.lower(label) then return Notify(src, 'Label Tekrari Ast !', 'error') end
    end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    local c = GetEntityCoords(ped)
    Zones[id] = NewZone(id, label, c.x, c.y, c.z, math.floor(world))
    SaveZones()
    Notify(src, 'Zone #' .. id .. ' (' .. label .. ') Zakhire Shod', 'success')
    SendLog('Admin', { title = '📍 Zone Set', color = 0x3498DB, fields = {
        { name = 'Admin', value = GetPlayerName(src), inline = true }, { name = 'Zone', value = id .. ' / ' .. label, inline = true } } })
end)

RegisterNetEvent('capture:admin:removeZone')
AddEventHandler('capture:admin:removeZone', function(id)
    local src = source
    if not HasPerm(src) then return end
    if Round.active then return Notify(src, 'Dar Hin Capture Nemitavan Zone Ra Hazf Kard !', 'error') end
    id = tonumber(id)
    if id and Zones[id] then
        Zones[id] = nil
        SaveZones()
        Notify(src, 'Zone Hazf Shod', 'success')
    end
end)

-- ----------------------------------------------------------------------------
--  Stats / history callbacks (منوی آمار و تاریخچه)
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.StatsCommand, function(src)
    if src ~= 0 then TriggerClientEvent('capture:OpenStatsMenu', src) end
end, false)

RegisterCommand(CapConfig.HistoryCommand, function(src)
    if src == 0 or not AdminGate(src, CapConfig.HistoryCommand) then return end
    TriggerClientEvent('capture:OpenHistoryMenu', src)
end, false)

ESX.RegisterServerCallback('capture:GetHistory', function(src, cb)
    if not HasPerm(src) then return cb({}) end
    MySQL.Async.fetchAll('SELECT * FROM capture_history ORDER BY id DESC LIMIT 15', {}, function(r) cb(r or {}) end)
end)

ESX.RegisterServerCallback('capture:GetMyStats', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return cb(nil, {}, {}) end
    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats WHERE identifier = @i LIMIT 1', { ['@i'] = xPlayer.identifier }, function(mine)
        MySQL.Async.fetchAll('SELECT name, kills FROM capture_player_stats ORDER BY kills DESC LIMIT 10', {}, function(top)
            MySQL.Async.fetchAll('SELECT zone_name, points FROM capture_player_zone_stats WHERE identifier = @i ORDER BY points DESC LIMIT 3',
                { ['@i'] = xPlayer.identifier }, function(zs) cb(mine and mine[1] or nil, top or {}, zs or {}) end)
        end)
    end)
end)

-- ----------------------------------------------------------------------------
--  Admin utility commands
-- ----------------------------------------------------------------------------
RegisterCommand(CapConfig.SeasonResetCommand, function(src)
    if not AdminGate(src, CapConfig.SeasonResetCommand) then return end
    MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(r)
        local n = r and r[1] and r[1].season_number or 1
        RunSeasonReset(n)
        Reply(src, '^2', 'Season Reset Anjam Shod !')
        SendLog('Admin', { title = '⚠️ Manual Season Reset Triggered', color = 0xE67E22, fields = {
            { name = 'Admin', value = src == 0 and 'console' or GetPlayerName(src), inline = true }, { name = 'Season', value = tostring(n), inline = true } } })
    end)
end, false)

RegisterCommand(CapConfig.SeasonHistoryCommand, function(src)
    MySQL.Async.fetchAll('SELECT * FROM capture_seasons ORDER BY season_number DESC LIMIT 10', {}, function(rows)
        if not rows or #rows == 0 then return Reply(src, '^1', 'Hich Fasli Hanoz Tamam Nashode.') end
        for _, s in ipairs(rows) do
            Reply(src, '^3', '[Season ' .. s.season_number .. '] ' .. tostring(s.ended_date) .. ' | Player: ' .. tostring(s.winner_name) ..
                ' (' .. tostring(s.winner_score) .. 'pts) | Gang: ' .. tostring(s.winner_gang_name) .. ' (' .. tostring(s.winner_gang_points) .. 'pts)')
        end
    end)
end, false)

if CapConfig.EnableDryRun then
    RegisterCommand(CapConfig.DryRunCommand, function(src)
        if not AdminGate(src, CapConfig.DryRunCommand) then return end
        local issues, worlds = {}, {}
        if CountZones() == 0 then issues[#issues + 1] = 'No zones configured' end
        if Round.minutes <= 0 then issues[#issues + 1] = 'Round duration invalid' end
        if not CapConfig.Themes[CapConfig.ActiveTheme] then issues[#issues + 1] = 'ActiveTheme not found' end
        for id, z in pairs(Zones) do
            if z.world < CapConfig.WorldMin or z.world > CapConfig.WorldMax then issues[#issues + 1] = 'Zone ' .. id .. ' world out of range' end
            if worlds[z.world] then issues[#issues + 1] = 'Zones ' .. worlds[z.world] .. ' & ' .. id .. ' share world ' .. z.world end
            worlds[z.world] = id
        end
        MySQL.Async.fetchAll('SELECT ' .. CapConfig.GangsNameColumn .. ', ' .. CapConfig.GangsBossColumn .. ' FROM ' .. CapConfig.GangsTable .. ' LIMIT 1', {}, function(g)
            if not g then issues[#issues + 1] = 'Cannot query gangs table' end
            MySQL.Async.fetchAll('SELECT ' .. CapConfig.UsersIdentifierColumn .. ' FROM ' .. CapConfig.UsersTable .. ' LIMIT 1', {}, function(u)
                if not u then issues[#issues + 1] = 'Cannot query users table' end
                if #issues == 0 then Reply(src, '^2', 'Dry-Run OK (' .. CountZones() .. ' zones)')
                else
                    Reply(src, '^1', 'Dry-Run Found ' .. #issues .. ' Issue(s):')
                    for _, i in ipairs(issues) do Reply(src, '^1', ' - ' .. i) end
                end
            end)
        end)
    end, false)
end

if CapConfig.EnableHealthCheck then
    RegisterCommand(CapConfig.HealthCheckCommand, function(src)
        if not AdminGate(src, CapConfig.HealthCheckCommand) then return end
        Reply(src, '^3', '=== Health === Active: ' .. tostring(Round.active) .. ' | Theme: ' .. CurrentThemeName .. ' | Zones: ' .. CountZones() ..
            ' | InCapture: ' .. #InCaptureList())
        local tables = { 'capture_history', 'capture_player_stats', 'capture_player_zone_stats', 'capture_meta', 'capture_seasons', 'capture_season_archive', 'capture_gang_stats', 'capture_gang_season_archive' }
        local function nxt(i)
            if i > #tables then return end
            MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM ' .. tables[i], {}, function(r)
                Reply(src, '^3', tables[i] .. ': ' .. (r and r[1] and (r[1].c .. ' rows') or 'ERROR'))
                nxt(i + 1)
            end)
        end
        nxt(1)
    end, false)
end

RegisterCommand(CapConfig.ThemeCommand, function(src, args)
    if not AdminGate(src, CapConfig.ThemeCommand) then return end
    local name = args[1]
    if not name or not CapConfig.Themes[name] then
        local names = {}
        for n in pairs(CapConfig.Themes) do names[#names + 1] = n end
        return Reply(src, '^1', 'Available Themes: ' .. table.concat(names, ', '))
    end
    CurrentThemeName = name
    TriggerClientEvent('capture:SetTheme', -1, CapConfig.Themes[name])
    TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'Capture Theme Changed To: ' .. name } })
end, false)

AddEventHandler('esx:playerLoaded', function(playerId)
    if CurrentThemeName ~= CapConfig.ActiveTheme then
        TriggerClientEvent('capture:SetTheme', playerId, CapConfig.Themes[CurrentThemeName])
    end
end)

RegisterCommand(CapConfig.ExportZonesCommand, function(src)
    if not AdminGate(src, CapConfig.ExportZonesCommand) then return end
    Reply(src, SaveZones() and '^2' or '^1', SaveZones() and ('Zones Exported To ' .. CapConfig.ZonesFileName) or 'Export FAILED (check write permissions)')
end, false)

RegisterCommand(CapConfig.ImportZonesCommand, function(src)
    if not AdminGate(src, CapConfig.ImportZonesCommand) then return end
    if Round.active then return Reply(src, '^1', 'Cannot Import Zones While A Capture Is Active !') end
    local z = LoadZones(true)
    if not z then return Reply(src, '^1', 'Failed To Load ' .. CapConfig.ZonesFileName .. ' (missing or invalid JSON)') end
    Zones = z
    Reply(src, '^2', 'Imported ' .. CountZones() .. ' Zones')
end, false)

if CapConfig.EnableLeagueMode then
    RegisterCommand(CapConfig.StandingsCommand, function(src)
        MySQL.Async.fetchAll('SELECT gang_name, points FROM capture_gang_stats ORDER BY points DESC LIMIT 15', {}, function(rows)
            if not rows or #rows == 0 then return Reply(src, '^1', 'No Standings Data Yet This Season.') end
            Reply(src, '^3', '=== Season Standings ===')
            for i, r in ipairs(rows) do Reply(src, '^2', '#' .. i .. ' ' .. tostring(r.gang_name) .. ' - ' .. tostring(r.points) .. ' pts') end
        end)
    end, false)
    if CapConfig.EnablePlayoffs then
        RegisterCommand(CapConfig.PlayoffResultCommand, function(src, args)
            if not AdminGate(src, CapConfig.PlayoffResultCommand) then return end
            local map = { semi1 = 'Semifinal 1', semi2 = 'Semifinal 2', final = 'Final' }
            local label, winner = args[1] and map[string.lower(args[1])], args[2]
            if not label or not winner then return Reply(src, '^1', 'Usage: /' .. CapConfig.PlayoffResultCommand .. ' [semi1|semi2|final] [gang_name]') end
            MySQL.Async.fetchAll('SELECT * FROM capture_playoffs WHERE match_label = @l ORDER BY id DESC LIMIT 1', { ['@l'] = label }, function(r)
                local m = r and r[1]
                if not m then return Reply(src, '^1', 'No Match Found For ' .. label) end
                MySQL.Async.execute('UPDATE capture_playoffs SET winner = @w WHERE id = @id', { ['@w'] = winner, ['@id'] = m.id })
                TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', label .. ' Winner: ' .. winner .. ' !' } })
                if label ~= 'Final' then
                    MySQL.Async.fetchAll('SELECT * FROM capture_playoffs WHERE season_number = @s AND match_label IN ("Semifinal 1","Semifinal 2")', { ['@s'] = m.season_number }, function(semis)
                        if semis and #semis == 2 and semis[1].winner and semis[2].winner then
                            MySQL.Async.execute('UPDATE capture_playoffs SET gang_a = @a, gang_b = @b WHERE season_number = @s AND match_label = "Final"',
                                { ['@a'] = semis[1].winner, ['@b'] = semis[2].winner, ['@s'] = m.season_number })
                            TriggerClientEvent('chat:addMessage', -1, { args = { '^1Unique-CaptureSystem', 'FINAL: ' .. semis[1].winner .. ' vs ' .. semis[2].winner .. ' !' } })
                        end
                    end)
                end
            end)
        end, false)
    end
end

if CapConfig.EnablePublicAPI then
    print('^3[Unique-Capture]^7 Public API enabled at ' .. CapConfig.PublicAPIPath .. ' - NOTE: takes over SetHttpHandler.')
    SetHttpHandler(function(req, res)
        if req.path ~= CapConfig.PublicAPIPath then
            res.writeHead(404, { ['Content-Type'] = 'application/json' }) res.send(json.encode({ error = 'not found' })) return
        end
        local g, k = TopLists()
        res.writeHead(200, { ['Content-Type'] = 'application/json', ['Access-Control-Allow-Origin'] = '*' })
        res.send(json.encode({ active = Round.active, time_remaining = Round.active and (Round.endsAt - os.time()) or 0,
            zone_count = CountZones(), active_theme = CurrentThemeName, top_killers = k, top_gangs = g }))
    end)
end

-- exports (برای اسکریپت‌های دیگه)
exports('IsCaptureActive', function() return Round.active end)
exports('IsPlayerInCapture', function(src) local s = Sessions[src] return s ~= nil and s.zoneId ~= nil end)
