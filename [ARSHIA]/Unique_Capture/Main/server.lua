AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Citizen.Wait(300)
    print("^1★^7 Capture System Running ^3->^7 ^2arshiahub.ir^7")
    print("^1★^7 This resource is owned by ^2arshiahub.ir^7")
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function SendLog(category, embed)
    if not Config.EnableDetailedLogging then return end
    local url = Config.Webhooks and Config.Webhooks[category]
    if not url or url == "" then return end

    embed.footer = embed.footer or { text = Config.LogUsername .. " | " .. category }
    embed.timestamp = embed.timestamp or os.date("!%Y-%m-%dT%H:%M:%SZ")

    local payload = {
        username = Config.LogUsername,
        embeds = { embed },
    }
    if Config.LogAvatarUrl and Config.LogAvatarUrl ~= "" then
        payload.avatar_url = Config.LogAvatarUrl
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
                    local totalHours = Config.SeasonAutoResetDays * 24
                    local hoursRemaining = totalHours - hoursPassed

                    if Config.EnableSeasonWarning and not SeasonWarningsSent[meta.season_number]
                       and hoursRemaining <= Config.SeasonWarningHoursBefore and hoursRemaining > 0 then
                        SeasonWarningsSent[meta.season_number] = true
                        TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "Fasl "..meta.season_number.." Kamtar Az "..Config.SeasonWarningHoursBefore.." Saat Dige Tamam Mishe! Amadeh Bashid !"}})
                        SendLog("Season", {
                            title = "⏳ Season Ending Soon",
                            color = 0xF1C40F,
                            description = "Season " .. meta.season_number .. " ends in less than " .. Config.SeasonWarningHoursBefore .. " hours.",
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
    if not Config.EnableHallOfFame then return end
    Citizen.CreateThread(function()
        while true do
            Wait(6 * 60 * 60 * 1000)
            MySQL.Async.fetchAll(
                'SELECT identifier, name, kills, gang_points, last_rank FROM capture_player_stats '..
                'WHERE last_rank = @rank AND last_active IS NOT NULL AND last_active < DATE_SUB(NOW(), INTERVAL @days DAY) '..
                'AND identifier NOT IN (SELECT identifier FROM capture_hall_of_fame)',
                {
                    ['@rank'] = Config.ScarceMedalRank,
                    ['@days'] = Config.HallOfFameInactivityDays,
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

if Config.EnableHallOfFame then
    RegisterCommand(Config.HallOfFameCommand, function(source, args, rawCommand)
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
    if not Config.BackupBeforeSeasonReset then
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

            local fileName = Config.BackupFolder .. "/season_" .. currentSeasonNumber .. "_" .. os.date('%Y-%m-%d_%H-%M-%S') .. ".json"
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
            ['@wk'] = Config.AllTimeScoreWeights.Kills,
            ['@wg'] = Config.AllTimeScoreWeights.GangPoints,
            ['@wd'] = Config.AllTimeScoreWeights.DeathPenalty,
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


                if Config.EnableLeagueMode then
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


                    if Config.EnablePlayoffs and #gangRows >= 4 then
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

local GangLogosCache = {}
local GangLogosFetching = {}

function GetGangLogo(gangName)
    return GangLogosCache[gangName] or Config.DefaultGangLogo
end

function EnsureGangLogoCached(gangName)
    if GangLogosCache[gangName] or GangLogosFetching[gangName] then return end
    GangLogosFetching[gangName] = true
    MySQL.Async.fetchAll('SELECT '..Config.GangsLogoColumn..' as logo FROM '..Config.GangsTable..' WHERE '..Config.GangsNameColumn..' = @gangName LIMIT 1', {
        ['@gangName'] = gangName
    }, function(results)
        GangLogosFetching[gangName] = nil
        if results and results[1] and results[1].logo then
            GangLogosCache[gangName] = results[1].logo
        else
            GangLogosCache[gangName] = Config.DefaultGangLogo
        end
    end)
end

local PlayerPhotoCache = {}
local PlayerPhotoFetching = {}

function GetPlayerPhoto(identifier)
    return PlayerPhotoCache[identifier] or false
end

function EnsurePlayerPhotoCached(identifier)
    if PlayerPhotoCache[identifier] or PlayerPhotoFetching[identifier] then return end
    PlayerPhotoFetching[identifier] = true
    MySQL.Async.fetchAll('SELECT '..Config.UsersProfilePicColumn..' as pic FROM '..Config.UsersTable..' WHERE '..Config.UsersIdentifierColumn..' = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(results)
        PlayerPhotoFetching[identifier] = nil
        if results and results[1] and results[1].pic and results[1].pic ~= "" then
            PlayerPhotoCache[identifier] = results[1].pic
        else
            PlayerPhotoCache[identifier] = false
        end
    end)
end

function LoadZonesFromFile(force)
    if not force and not Config.EnableExternalZonesFile then return nil end
    local content = LoadResourceFile(GetCurrentResourceName(), Config.ZonesFileName)
    if not content then return nil end
    local ok, decoded = pcall(json.decode, content)
    if not ok or not decoded then return nil end
    local zones = {}
    for name, coord in pairs(decoded) do
        if coord and coord.x and coord.y and coord.z then
            zones[name] = vector3(coord.x, coord.y, coord.z)
        end
    end
    return zones
end

CapturesInfo = {
    Zones = LoadZonesFromFile() or Config.DefaultZones,
    Active = false,
    Time = Config.DefaultTime,
    CaptureStart = nil,
    EndTime = nil
}
CaptureState = {
    Kills = {},
    Captures = {},
    Points = {},
}
CurrentCapturing = {
    OnlinePlayers = {},
    InMarkerPlayers = {},
    CurrentCaptureHolders = {},
}

function CalcCaptureTimes()
    Citizen.CreateThread(function()
        while CapturesInfo.Active do
            Citizen.Wait(15000)
            for k,v in pairs(CurrentCapturing.CurrentCaptureHolders) do
                if type(v) == "string" and v ~= "" then

                if not CaptureState.Captures[k] then
                    CaptureState.Captures[k] = {}
                end
                if not CaptureState.Captures[k][v] then
                    CaptureState.Captures[k][v] = 0.25
                else
                    CaptureState.Captures[k][v] = CaptureState.Captures[k][v] + 0.25
                end


                if not CaptureState.Points[v] then
                    CaptureState.Points[v] = 1
                else
                    CaptureState.Points[v] = CaptureState.Points[v] + 1
                end
                UpsertGangStat(v, 1)
                for identifier, marker in pairs(CurrentCapturing.InMarkerPlayers) do
                    if marker.ZoneName == k and marker.InMarker then
                        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
                        if xPlayer then
                            UpsertPlayerStat(identifier, GetPlayerName(xPlayer.source), 'gang_points', 1)
                            CheckScarceMedalEligibility(identifier, GetPlayerName(xPlayer.source))
                            UpsertZoneStat(identifier, k, 1)
                        end
                    end
                end

                end
            end
        end
    end)
end

RegisterNetEvent("arshiahub.ir-CaptureSystem:PlayerEnterZone")
AddEventHandler("arshiahub.ir-CaptureSystem:PlayerEnterZone", function(Zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not CurrentCapturing.OnlinePlayers[xPlayer.identifier] then
        CurrentCapturing.OnlinePlayers[xPlayer.identifier] = {}
    end
    CurrentCapturing.OnlinePlayers[xPlayer.identifier].ZoneName = Zone
    CurrentCapturing.OnlinePlayers[xPlayer.identifier].Gang = xPlayer.gang.name
end)

local ZoneLeaveCooldown = {}

RegisterNetEvent("arshiahub.ir-Capture:PenalizeZoneLeave")
AddEventHandler("arshiahub.ir-Capture:PenalizeZoneLeave", function(ZoneName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ZoneName then return end
    if not ZoneLeaveCooldown[xPlayer.identifier] then ZoneLeaveCooldown[xPlayer.identifier] = {} end
    ZoneLeaveCooldown[xPlayer.identifier][ZoneName] = os.time() + Config.LeaveZonePenaltySeconds
end)

function GetZoneLeavePenaltyRemaining(identifier, ZoneName)
    if not ZoneLeaveCooldown[identifier] or not ZoneLeaveCooldown[identifier][ZoneName] then return 0 end
    local remaining = ZoneLeaveCooldown[identifier][ZoneName] - os.time()
    return remaining > 0 and remaining or 0
end

RegisterNetEvent("arshiahub.ir-Capture:CaptureMarkerStatus")
AddEventHandler("arshiahub.ir-Capture:CaptureMarkerStatus", function(ZoneName,InMarker)
    local xPlayer = ESX.GetPlayerFromId(source)
    if InMarker then
        local remaining = GetZoneLeavePenaltyRemaining(xPlayer.identifier, ZoneName)
        if remaining > 0 then
            TriggerClientEvent("arshiahub.ir-Capture:OxNotify", source, "Shoma Az In Zone Farar Kardid! "..remaining.." Sanie Digar Nemitavanid Capture Konid.", 'error')
            TriggerClientEvent("arshiahub.ir-Capture:CancelLocalZoneTimer", source)
            CurrentCapturing.InMarkerPlayers[xPlayer.identifier] = nil
            return
        end
        CurrentCapturing.InMarkerPlayers[xPlayer.identifier] = {ZoneName = ZoneName, InMarker = InMarker, IsWaitPassed = false}
    else
        CurrentCapturing.InMarkerPlayers[xPlayer.identifier] = nil
    end
    ProcCurrentCapHolder()
end)

RegisterNetEvent("arshiahub.ir-Capture:CaptureMarkerWaitPassed")
AddEventHandler("arshiahub.ir-Capture:CaptureMarkerWaitPassed", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if CurrentCapturing.InMarkerPlayers[xPlayer.identifier] then
        CurrentCapturing.InMarkerPlayers[xPlayer.identifier].IsWaitPassed = true
        ProcCurrentCapHolder()
    end
end)

function ProcCurrentCapHolder()
    local ZonesCapHolder = {}
    for Zone,_ in pairs(CurrentCapturing.CurrentCaptureHolders) do
        ZonesCapHolder[Zone] = nil
    end
    for SteamHex,v in pairs(CurrentCapturing.InMarkerPlayers) do
        if not CurrentCapturing.OnlinePlayers[SteamHex] then goto continue end
        local PlayerGang  = CurrentCapturing.OnlinePlayers[SteamHex].Gang
        if v.InMarker then
            if ZonesCapHolder[v.ZoneName] ~= PlayerGang and ZonesCapHolder[v.ZoneName] ~= nil then
                ZonesCapHolder[v.ZoneName] = -1
            end
            if ZonesCapHolder[v.ZoneName] ~= -1 and v.IsWaitPassed and ZonesCapHolder[v.ZoneName] ~= PlayerGang then
                ZonesCapHolder[v.ZoneName] = PlayerGang
                TriggerEvent("arshiahub.ir-CaptureSystem:ShowMessageToAll","Gang ~r~[~w~"..PlayerGang.."~r~]~w~ Zone ~g~[~r~"..v.ZoneName.."~g~]~w~ Ra Capture Kard !",5)
                SendLog("ZoneCapture", {
                    title = "🚩 Zone Captured",
                    color = 0xF39C12,
                    fields = {
                        {name = "Zone", value = tostring(v.ZoneName), inline = true},
                        {name = "New Owner", value = tostring(PlayerGang), inline = true},
                    },
                })
            end
        end
        ::continue::
    end
    if ZonesCapHolder then
        for k,v in pairs(ZonesCapHolder) do
            if  v ~= -1 and v ~= nil then
                if not CurrentCapturing.CurrentCaptureHolders[k] then
                    CurrentCapturing.CurrentCaptureHolders[k] = nil
                end
                CurrentCapturing.CurrentCaptureHolders[k] = v
            end
        end
    end
    TriggerClientEvent("arshiahub.ir-CaptureSystem:UpdateHolderGang", -1, CurrentCapturing.CurrentCaptureHolders)
end

function GetAcademyBadge(academyKills)
    local badge = nil
    for _, tier in ipairs(Config.AcademyMilestones) do
        if academyKills >= tier.Kills then
            badge = tier.Title
        end
    end
    return badge
end

function GetRankForScore(score)
    local rank = Config.RankThresholds[1].Name
    for _, tier in ipairs(Config.RankThresholds) do
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
        local score = (kills * Config.AllTimeScoreWeights.Kills) + (gangPoints * Config.AllTimeScoreWeights.GangPoints) - (deaths * Config.AllTimeScoreWeights.DeathPenalty)
        cb(GetRankForScore(score))
    end)
end

function CheckScarceMedalEligibility(identifier, name)
    if not Config.EnableScarcityEngine then return end
    MySQL.Async.fetchAll('SELECT kills, deaths, gang_points, last_rank FROM capture_player_stats WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = identifier
    }, function(results)
        local row = results and results[1]
        if not row then return end
        local score = ((row.kills or 0) * Config.AllTimeScoreWeights.Kills) + ((row.gang_points or 0) * Config.AllTimeScoreWeights.GangPoints) - ((row.deaths or 0) * Config.AllTimeScoreWeights.DeathPenalty)
        local newRank = GetRankForScore(score)
        local oldRank = row.last_rank or "Bronze"

        if newRank ~= oldRank then
            MySQL.Async.execute('UPDATE capture_player_stats SET last_rank = @r WHERE identifier = @id', {['@r'] = newRank, ['@id'] = identifier})
        end

        if newRank == Config.ScarceMedalRank and oldRank ~= Config.ScarceMedalRank then
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
            if mintedCount >= Config.ScarceMedalSupplyPerSeason then
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
                    "^2" .. tostring(name) .. " ^7Claimed " .. Config.ScarceMedalName .. " #" .. serial .. "/" .. Config.ScarceMedalSupplyPerSeason .. " For Season " .. seasonNumber .. " !"
                }})
                SendLog("Medals", {
                    title = "🏅 Scarce Medal Claimed",
                    color = 0xFFD700,
                    fields = {
                        {name = "Player", value = tostring(name), inline = true},
                        {name = "Serial", value = "#" .. serial .. "/" .. Config.ScarceMedalSupplyPerSeason, inline = true},
                        {name = "Season", value = tostring(seasonNumber), inline = true},
                    },
                })
            end)
        end)
    end)
end

if Config.EnableScarcityEngine then
    RegisterCommand(Config.ScarcityStatusCommand, function(source, args, rawCommand)
        MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(metaResults)
            local meta = metaResults and metaResults[1]
            local seasonNumber = meta and meta.season_number or 1
            MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM capture_scarce_medals WHERE season_number = @s', {
                ['@s'] = seasonNumber
            }, function(countResult)
                local minted = countResult and countResult[1] and countResult[1].c or 0
                local remaining = math.max(0, Config.ScarceMedalSupplyPerSeason - minted)
                TriggerClientEvent("chat:addMessage", source, {args = {
                    "^1Unique-CaptureSystem",
                    Config.ScarceMedalName .. " (Season " .. seasonNumber .. "): " .. minted .. "/" .. Config.ScarceMedalSupplyPerSeason .. " Claimed | " .. remaining .. " Remaining !"
                }})
            end)
        end)
    end)

    RegisterCommand(Config.MyMedalsCommand, function(source, args, rawCommand)
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
                    "^1🏅", Config.ScarceMedalName .. " #" .. row.serial_number .. " (Season " .. row.season_number .. ") - " .. tostring(row.awarded_at)
                }})
            end
        end)
    end)
end

ESX.RegisterServerCallback("arshiahub.ir-Capture:GetDashboard", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats WHERE identifier = @id LIMIT 1', {
        ['@id'] = xPlayer.identifier
    }, function(mine)
        local myRow = mine and mine[1]
        local kills = myRow and myRow.kills or 0
        local deaths = myRow and myRow.deaths or 0
        local gangPoints = myRow and myRow.gang_points or 0
        local top5 = myRow and myRow.top5_count or 0
        local score = (kills * Config.AllTimeScoreWeights.Kills) + (gangPoints * Config.AllTimeScoreWeights.GangPoints) - (deaths * Config.AllTimeScoreWeights.DeathPenalty)
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
                            local hoursRemaining = math.max(0, (Config.SeasonAutoResetDays * 24) - hoursPassed)

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
                                                supply = Config.ScarceMedalSupplyPerSeason,
                                                enabled = Config.EnableScarcityEngine,
                                                mine = myMedals or {},
                                            },
                                            hallOfFame = hofResult and hofResult[1] and true or false,
                                            leagueEnabled = Config.EnableLeagueMode,
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

RegisterNetEvent("arshiahub.ir-Capture:ZoneUnderAttack")
AddEventHandler("arshiahub.ir-Capture:ZoneUnderAttack", function(ZoneName, AttackerGang)
    local ownerGang = CurrentCapturing.CurrentCaptureHolders[ZoneName]
    if not ownerGang or ownerGang == AttackerGang then return end
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local yPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if yPlayer and yPlayer.gang.name == ownerGang then
            TriggerClientEvent("arshiahub.ir-CaptureSystem:ShowMessage", xPlayers[i],
                "~r~WARNING!~w~ Gang ~r~[" .. AttackerGang .. "]~w~ Dar Hale Capture Kardane Zone Shomast: ~g~[" .. ZoneName .. "]~w~ !", 6)
        end
    end
end)

RegisterCommand(Config.HistoryCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.HistoryCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    TriggerClientEvent("arshiahub.ir-Capture:OpenHistoryMenu", source)
end)

RegisterCommand(Config.SeasonResetCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.SeasonResetCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    MySQL.Async.fetchAll('SELECT * FROM capture_meta ORDER BY id DESC LIMIT 1', {}, function(results)
        local meta = results and results[1]
        local seasonNumber = meta and meta.season_number or 1
        local xPlayer = ESX.GetPlayerFromId(source)
        RunSeasonReset(seasonNumber)
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Season Reset Anjam Shod !"}})
        SendLog("Admin", {
            title = "⚠️ Manual Season Reset Triggered",
            color = 0xE67E22,
            fields = {
                {name = "Admin", value = GetPlayerName(source), inline = true},
                {name = "Season", value = tostring(seasonNumber), inline = true},
            },
        })
    end)
end)

local CurrentThemeName = Config.ActiveTheme

local AdminCommandCooldowns = {}
function IsRateLimited(source, commandName)
    if not Config.EnableAdminRateLimit then return false end
    local key = source .. ":" .. commandName
    local last = AdminCommandCooldowns[key]
    if last and (os.time() - last) < Config.AdminCommandCooldown then
        return true
    end
    AdminCommandCooldowns[key] = os.time()
    return false
end

if Config.EnableDryRun then
    RegisterCommand(Config.DryRunCommand, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level <= Config.CommandPerm then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
            return
        end
        if IsRateLimited(source, Config.DryRunCommand) then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
            return
        end

        local issues = {}
        local zoneCount = 0
        for _ in pairs(CapturesInfo.Zones) do zoneCount = zoneCount + 1 end
        if zoneCount == 0 then table.insert(issues, "No zones configured (CapturesInfo.Zones is empty)") end
        if not CapturesInfo.Time or CapturesInfo.Time <= 0 then table.insert(issues, "CapturesInfo.Time is 0 or invalid") end
        if not Config.Themes[Config.ActiveTheme] then table.insert(issues, "Config.ActiveTheme '"..tostring(Config.ActiveTheme).."' not found in Config.Themes") end
        if type(Config.AllTimeScoreWeights.Kills) ~= "number" then table.insert(issues, "AllTimeScoreWeights.Kills is not a number") end

        MySQL.Async.fetchAll('SELECT 1', {}, function(dbCheck)
            if not dbCheck then table.insert(issues, "Database did not respond to a basic query") end
            MySQL.Async.fetchAll('SELECT '..Config.GangsNameColumn..' FROM '..Config.GangsTable..' LIMIT 1', {}, function(gangCheck)
                if not gangCheck then table.insert(issues, "Could not query Config.GangsTable ('"..Config.GangsTable.."') - check table/column names") end
                MySQL.Async.fetchAll('SELECT '..Config.UsersIdentifierColumn..' FROM '..Config.UsersTable..' LIMIT 1', {}, function(userCheck)
                    if not userCheck then table.insert(issues, "Could not query Config.UsersTable ('"..Config.UsersTable.."') - check table/column names") end

                    if #issues == 0 then
                        TriggerClientEvent("chat:addMessage", source, {args = {"^2Unique-CaptureSystem", "Dry-Run OK - Config Looks Valid! ("..zoneCount.." zones, theme: "..Config.ActiveTheme..")"}})
                        SendLog("Admin", {
                            title = "✅ Dry-Run Passed",
                            color = 0x2ECC71,
                            fields = {{name = "Admin", value = GetPlayerName(source), inline = true}},
                        })
                    else
                        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Dry-Run Found "..#issues.." Issue(s):"}})
                        for _, issue in ipairs(issues) do
                            TriggerClientEvent("chat:addMessage", source, {args = {"^1  -", issue}})
                        end
                        SendLog("Admin", {
                            title = "❌ Dry-Run Found Issues",
                            color = 0xE74C3C,
                            description = table.concat(issues, "\n"),
                            fields = {{name = "Admin", value = GetPlayerName(source), inline = true}},
                        })
                    end
                end)
            end)
        end)
    end)
end

if Config.EnableHealthCheck then
    RegisterCommand(Config.HealthCheckCommand, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.permission_level <= Config.CommandPerm then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
            return
        end
        if IsRateLimited(source, Config.HealthCheckCommand) then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
            return
        end

        TriggerClientEvent("chat:addMessage", source, {args = {"^3Unique-CaptureSystem", "=== Health Check ==="}})
        TriggerClientEvent("chat:addMessage", source, {args = {"^3Capture Active:", tostring(CapturesInfo.Active)}})
        TriggerClientEvent("chat:addMessage", source, {args = {"^3Active Theme:", tostring(CurrentThemeName)}})

        local zoneCount = 0
        for _ in pairs(CapturesInfo.Zones) do zoneCount = zoneCount + 1 end
        TriggerClientEvent("chat:addMessage", source, {args = {"^3Zones Configured:", tostring(zoneCount)}})

        local tables = {"capture_history","capture_player_stats","capture_player_zone_stats","capture_meta","capture_seasons","capture_season_archive","capture_gang_stats","capture_gang_season_archive"}
        local function checkNext(i)
            if i > #tables then return end
            MySQL.Async.fetchAll('SELECT COUNT(*) as c FROM '..tables[i], {}, function(res)
                local count = res and res[1] and res[1].c
                TriggerClientEvent("chat:addMessage", source, {args = {"^3"..tables[i]..":", count and (tostring(count).." rows") or "ERROR (table missing or unreadable)"}})
                checkNext(i + 1)
            end)
        end
        checkNext(1)
    end)
end

RegisterCommand(Config.ThemeCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.ThemeCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    local themeName = args[1]
    if not themeName or not Config.Themes[themeName] then
        local names = {}
        for name,_ in pairs(Config.Themes) do table.insert(names, name) end
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Available Themes: "..table.concat(names, ", ")}})
        return
    end
    CurrentThemeName = themeName
    TriggerClientEvent("arshiahub.ir-CaptureSystem:SetTheme", -1, Config.Themes[themeName])
    TriggerClientEvent("chat:addMessage", -1, {args = {"^1Unique-CaptureSystem", "Capture Theme Changed To: "..themeName}})
    SendLog("Admin", {
        title = "🎨 Theme Changed",
        color = 0x1ABC9C,
        fields = {
            {name = "Admin", value = GetPlayerName(source), inline = true},
            {name = "New Theme", value = themeName, inline = true},
        },
    })
end)

AddEventHandler("esx:playerLoaded", function(playerId, xPlayer)
    if CurrentThemeName ~= Config.ActiveTheme then
        TriggerClientEvent("arshiahub.ir-CaptureSystem:SetTheme", playerId, Config.Themes[CurrentThemeName])
    end
end)

RegisterCommand(Config.SeasonHistoryCommand, function(source, args, rawCommand)
    MySQL.Async.fetchAll('SELECT * FROM capture_seasons ORDER BY season_number DESC LIMIT 10', {}, function(seasons)
        if not seasons or #seasons == 0 then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Hich Fasli Hanoz Tamam Nashode."}})
            return
        end
        for _, s in ipairs(seasons) do
            TriggerClientEvent("chat:addMessage", source, {args = {
                "^1[Season " .. s.season_number .. "]",
                "^3" .. tostring(s.ended_date) .. " ^7| Player: ^2" .. tostring(s.winner_name) .. " (" .. tostring(s.winner_score) .. "pts) ^7| Gang: ^5" .. tostring(s.winner_gang_name) .. " (" .. tostring(s.winner_gang_points) .. "pts)"
            }})
        end
    end)
end)

RegisterCommand(Config.ExportZonesCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.ExportZonesCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    local zonesForExport = {}
    for name, coord in pairs(CapturesInfo.Zones) do
        zonesForExport[name] = {x = coord.x, y = coord.y, z = coord.z}
    end
    local ok = SaveResourceFile(GetCurrentResourceName(), Config.ZonesFileName, json.encode(zonesForExport), -1)
    if ok then
        TriggerClientEvent("chat:addMessage", source, {args = {"^2Unique-CaptureSystem", "Zones Exported To "..Config.ZonesFileName}})
        SendLog("Admin", {
            title = "📤 Zones Exported",
            color = 0x3498DB,
            fields = {{name = "Admin", value = GetPlayerName(source), inline = true}},
        })
    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Export FAILED (check server write permissions)"}})
    end
end)

RegisterCommand(Config.ImportZonesCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.ImportZonesCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    if CapturesInfo.Active then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Cannot Import Zones While A Capture Is Active !"}})
        return
    end
    local loaded = LoadZonesFromFile(true)
    if loaded then
        CapturesInfo.Zones = loaded
        local count = 0
        for _ in pairs(loaded) do count = count + 1 end
        TriggerClientEvent("chat:addMessage", source, {args = {"^2Unique-CaptureSystem", "Imported "..count.." Zones From "..Config.ZonesFileName}})
        SendLog("Admin", {
            title = "📥 Zones Imported",
            color = 0x3498DB,
            fields = {
                {name = "Admin", value = GetPlayerName(source), inline = true},
                {name = "Zone Count", value = tostring(count), inline = true},
            },
        })
    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Failed To Load "..Config.ZonesFileName.." (missing or invalid JSON)"}})
    end
end)

if Config.EnableLeagueMode then
    RegisterCommand(Config.StandingsCommand, function(source, args, rawCommand)
        MySQL.Async.fetchAll('SELECT gang_name, points FROM capture_gang_stats ORDER BY points DESC LIMIT 15', {}, function(rows)
            if not rows or #rows == 0 then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "No Standings Data Yet This Season."}})
                return
            end
            TriggerClientEvent("chat:addMessage", source, {args = {"^3Unique-CaptureSystem", "=== Season Standings ==="}})
            for i, row in ipairs(rows) do
                TriggerClientEvent("chat:addMessage", source, {args = {"^2#"..i, tostring(row.gang_name).." - "..tostring(row.points).." pts"}})
            end
        end)
    end)

    if Config.EnablePlayoffs then
        RegisterCommand(Config.PlayoffResultCommand, function(source, args, rawCommand)
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.permission_level <= Config.CommandPerm then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
                return
            end
            if IsRateLimited(source, Config.PlayoffResultCommand) then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
                return
            end

            local matchKey = args[1]
            local winnerGang = args[2]
            local labelMap = {semi1 = "Semifinal 1", semi2 = "Semifinal 2", final = "Final"}
            local dbLabel = matchKey and labelMap[string.lower(matchKey)]

            if not dbLabel or not winnerGang then
                TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Usage: /"..Config.PlayoffResultCommand.." [semi1|semi2|final] [gang_name]"}})
                return
            end

            MySQL.Async.fetchAll('SELECT * FROM capture_playoffs WHERE match_label = @l ORDER BY id DESC LIMIT 1', {['@l'] = dbLabel}, function(results)
                local match = results and results[1]
                if not match then
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "No Match Found For "..dbLabel}})
                    return
                end
                MySQL.Async.execute('UPDATE capture_playoffs SET winner = @w WHERE id = @id', {['@w'] = winnerGang, ['@id'] = match.id})
                TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", dbLabel.." Winner: "..winnerGang.." !"}})

                if dbLabel == "Semifinal 1" or dbLabel == "Semifinal 2" then
                    MySQL.Async.fetchAll('SELECT * FROM capture_playoffs WHERE season_number = @s AND match_label IN ("Semifinal 1","Semifinal 2")', {
                        ['@s'] = match.season_number
                    }, function(semis)
                        if semis and #semis == 2 and semis[1].winner and semis[2].winner then
                            MySQL.Async.execute('UPDATE capture_playoffs SET gang_a = @a, gang_b = @b WHERE season_number = @s AND match_label = "Final"', {
                                ['@a'] = semis[1].winner, ['@b'] = semis[2].winner, ['@s'] = match.season_number
                            })
                            TriggerClientEvent('chat:addMessage', -1, {args = {"^1Unique-CaptureSystem", "FINAL: "..semis[1].winner.." vs "..semis[2].winner.." !"}})
                        end
                    end)
                end
            end)
        end)
    end
end

ESX.RegisterServerCallback("arshiahub.ir-Capture:GetHistory", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM capture_history ORDER BY id DESC LIMIT 15', {}, function(results)
        cb(results or {})
    end)
end)

RegisterCommand(Config.StatsCommand, function(source, args, rawCommand)
    TriggerClientEvent("arshiahub.ir-Capture:OpenStatsMenu", source)
end)

ESX.RegisterServerCallback("arshiahub.ir-Capture:GetMyStats", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM capture_player_stats WHERE identifier = @identifier LIMIT 1', {
        ['@identifier'] = xPlayer.identifier
    }, function(mine)
        MySQL.Async.fetchAll('SELECT name, kills FROM capture_player_stats ORDER BY kills DESC LIMIT 10', {}, function(topAllTime)
            MySQL.Async.fetchAll('SELECT zone_name, points FROM capture_player_zone_stats WHERE identifier = @identifier ORDER BY points DESC LIMIT 3', {
                ['@identifier'] = xPlayer.identifier
            }, function(myZones)
                cb(mine and mine[1] or nil, topAllTime or {}, myZones or {})
            end)
        end)
    end)
end)

RegisterCommand(Config.StartCaptureCommand, function(source, args, rawCommand)

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    local ZoneNumbers = 0
    for _ in pairs(CapturesInfo.Zones) do
        ZoneNumbers = ZoneNumbers + 1
    end
    if not CapturesInfo.Active then
        if ZoneNumbers > 0 and CapturesInfo.Time > 0 then
            TriggerEvent("arshiahub.ir-Capture:StartCapture")
            TriggerClientEvent("chat:addMessage", -1, {args = {"^1Unique-CaptureSystem", "Capture Start Shod ! Baraye Join Shodan /"..Config.JoinCaptureCommand.." Bezanid"}})
            SendLog("Admin", {
                title = "▶️ Round Started By Admin",
                color = 0x2ECC71,
                fields = {{name = "Admin", value = GetPlayerName(source), inline = true}},
            })
        else
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "First Set Zones And Time !"}})
        end
    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Capture Already Active !"}})
    end
end)
RegisterCommand(Config.EditCaptureCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    if IsRateLimited(source, Config.EditCaptureCommand) then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Lotfan Sabr Konid Ghabl Az Estefadeye Dobare !"}})
        return
    end
    TriggerClientEvent("arshiahub.ir-Capture:OpenAdminMenu", source)
end)

RegisterCommand(Config.EndCaptureCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level <= Config.CommandPerm then
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        return
    end
    SendLog("Admin", {
        title = "⏹️ Round Force-Ended By Admin",
        color = 0xE67E22,
        fields = {{name = "Admin", value = GetPlayerName(source), inline = true}},
    })
    TriggerEvent('arshiahub.ir-Capture:CaptureEnd')
end)

RegisterCommand(Config.LeaveCaptureCommand, function(source, args, rawCommand)
    TriggerClientEvent("arshiahub.ir-Capture:LeaveCapture", source, true)
end)

RegisterCommand(Config.JoinCaptureCommand, function(source, args, rawCommand)
    if CapturesInfo.Active and CapturesInfo.Time > 0 then
        if ESX.GetPlayerFromId(source).gang.name ~= "nogang" then
            GetDistanceFromGangBoss(source, function(Distance)
                if Distance and Distance < 100.0 then
                    TriggerClientEvent("arshiahub.ir-Capture:JoinCapture", source)
                    SetPlayerRoutingBucket(source, Config.CaptureWorld)
                else
                    TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Go To Your Gang To Can Join !"}})
                end
            end)
        else
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Must First Join To A Gang !"}})
        end


    else
        TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "Capture Not Active !"}})
    end
end)

RegisterNetEvent("arshiahub.ir-Capture:StartCapture")
AddEventHandler("arshiahub.ir-Capture:StartCapture", function()
    CapturesInfo.Active = true
    CaptureState.Kills = {}
    CaptureState.Captures = {}
    CaptureState.Points = {}
    CurrentCapturing.OnlinePlayers = {}
    CurrentCapturing.InMarkerPlayers = {}
    CurrentCapturing.CurrentCaptureHolders = {}
    TriggerClientEvent("arshiahub.ir-CaptureSystem:UpdateHolderGang", -1, CurrentCapturing.CurrentCaptureHolders)
    CapturesInfo.CaptureStart = os.time()
    CapturesInfo.EndTime = CapturesInfo.CaptureStart + (CapturesInfo.Time * 60)
    CreateZonesVar()
    StartTimer()
    CalcCaptureTimes()
    SendUiData()
    SendAllTimeTopThread()

    local zoneCount = 0
    for _ in pairs(CapturesInfo.Zones) do zoneCount = zoneCount + 1 end
    SendLog("RoundStart", {
        title = "🟢 Capture Round Started",
        color = 0x2ECC71,
        fields = {
            {name = "Zones", value = tostring(zoneCount), inline = true},
            {name = "Duration", value = tostring(CapturesInfo.Time) .. " min", inline = true},
        },
    })
end)

RegisterNetEvent("arshiahub.ir-Capture:LeaveCapture")
AddEventHandler("arshiahub.ir-Capture:LeaveCapture", function()
    local _source = source
    GetGangBossCoords(_source, function(Coord)
        TriggerClientEvent("arshiahub.ir-CaptureSystem:TpPlayer", _source, Coord.x, Coord.y, Coord.z)
        SetPlayerRoutingBucket(_source, 0)
    end)

end)

RegisterNetEvent("arshiahub.ir-Capture:CaptureEnd")
AddEventHandler("arshiahub.ir-Capture:CaptureEnd", function()
    if not CapturesInfo.Active then return end
    CapturesInfo.Active = false
    TriggerClientEvent("arshiahub.ir-Capture:LeaveCapture", -1)
    SendResult()
end)

RegisterNetEvent("arshiahub.ir-Capture:KillerPoint")
AddEventHandler("arshiahub.ir-Capture:KillerPoint", function(KillerID)
    local xPlayer = ESX.GetPlayerFromId(KillerID)
    if xPlayer then
        if CaptureState.Kills[xPlayer.identifier] then
            CaptureState.Kills[xPlayer.identifier] = CaptureState.Kills[xPlayer.identifier] + 1
        else
            CaptureState.Kills[xPlayer.identifier] = 1
        end
        UpsertPlayerStat(xPlayer.identifier, GetPlayerName(xPlayer.source), 'kills', 1)
        CheckScarceMedalEligibility(xPlayer.identifier, GetPlayerName(xPlayer.source))
    end
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:SendGroupToClient")
AddEventHandler("arshiahub.ir-CaptureSystem:SendGroupToClient", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        TriggerClientEvent("arshiahub.ir-CaptureSystem:ReceiveGroup", _source, xPlayer.group)
    end
end)

function CreateZonesVar()
    for k,v in pairs(CapturesInfo.Zones) do
        CaptureState.Captures[k] = {}
        CurrentCapturing.CurrentCaptureHolders[k] = {}
    end
end

function SendAllTimeTopThread()
    Citizen.CreateThread(function()
        while CapturesInfo.Active do
            MySQL.Async.fetchAll(
                'SELECT identifier, name, kills, deaths, gang_points, (kills*@wk + gang_points*@wg - deaths*@wd) as score '..
                'FROM capture_player_stats ORDER BY score DESC LIMIT 5',
                {
                    ['@wk'] = Config.AllTimeScoreWeights.Kills,
                    ['@wg'] = Config.AllTimeScoreWeights.GangPoints,
                    ['@wd'] = Config.AllTimeScoreWeights.DeathPenalty,
                },
                function(results)
                    results = results or {}
                    for _, row in ipairs(results) do
                        EnsurePlayerPhotoCached(row.identifier)
                        row.Photo = GetPlayerPhoto(row.identifier)
                    end
                    TriggerClientEvent("arshiahub.ir-CaptureSystem:SendAllTimeTop", -1, results)
                end
            )
            Wait(Config.AllTimeRefreshInterval * 1000)
        end
    end)
end

function SendUiData()
    Citizen.CreateThread(function()
        while CapturesInfo.Active do
            Wait(1000)
            local minute, seconds = CalculateTime()
            local time
            local percent = 0
            local totalDuration = CapturesInfo.EndTime - CapturesInfo.CaptureStart
            if totalDuration > 0 then
                percent = math.max(0, math.min(100, math.floor(((CapturesInfo.EndTime - os.time()) / totalDuration) * 100)))
            end

            if minute > 0 then
                time = string.format("%02d:%02d", minute, seconds)
            else
                time = string.format("%02d", seconds)
            end
            if minute == 0 and seconds == 0 then
                TriggerEvent("arshiahub.ir-Capture:CaptureEnd")
            end
            local topFiveKills = GetTopKillers()
            local topFiveGangs = GetTopGangs()
            TriggerClientEvent("arshiahub.ir-CaptureSystem:SendDataToUi", -1, topFiveKills, topFiveGangs, time, percent)
        end
    end)
end

function GetTopKillers()
    local killers = {}

    for identifier, kills in pairs(CaptureState.Kills) do
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            EnsurePlayerPhotoCached(identifier)
            table.insert(killers, {
                Name = GetPlayerName(xPlayer.source),
                Point = kills,
                Identifier = identifier,
                Photo = GetPlayerPhoto(identifier)
            })
        end
    end

    table.sort(killers, function(a, b)
        return a.Point > b.Point
    end)

    local topFive = {}
    for i = 1, math.min(5, #killers) do
        topFive[i] = killers[i]
    end

    return topFive
end

function CalculateTime()
    local time = CapturesInfo.EndTime - os.time()
    local minutes = time // 60
    local seconds = time % 60
    return minutes, seconds
end

function StartTimer()
    Citizen.CreateThread(function()
        while CapturesInfo.Active do
            Wait(60000)
            CapturesInfo.Time = CapturesInfo.Time - 1
            if CapturesInfo.Time <= 0 then
                TriggerEvent("arshiahub.ir-Capture:CaptureEnd")
                CapturesInfo.Active = false
            end
        end
    end)
end

ESX.RegisterServerCallback("arshiahub.ir-Capture:GetInfo", function(source, cb)
    cb(CapturesInfo)
end)
RegisterNetEvent("arshiahub.ir-CaptureSystem:UpdateInfo")
AddEventHandler("arshiahub.ir-CaptureSystem:UpdateInfo", function(CaptureInfo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.permission_level > Config.CommandPerm then
            CapturesInfo = CaptureInfo
        else
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
        end
    end
end)
RegisterNetEvent("arshiahub.ir-CaptureSystem:ShowMessageToAll")
AddEventHandler("arshiahub.ir-CaptureSystem:ShowMessageToAll", function(text,time)
    TriggerClientEvent("arshiahub.ir-CaptureSystem:ShowMessage", -1 , text,time)
end)

function GetGangBossCoords(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end

    local gangName = xPlayer.gang.name

    MySQL.Async.fetchAll('SELECT '..Config.GangsBossColumn..' as boss FROM '..Config.GangsTable..' WHERE '..Config.GangsNameColumn..' = @gangName LIMIT 1', {
        ['@gangName'] = gangName
    }, function(results)
        if results and #results > 0 then
            local bossData = results[1].boss
            local success, bossCoords = pcall(json.decode, bossData)
            if success and bossCoords and bossCoords.x and bossCoords.y and bossCoords.z then
                cb(vector3(bossCoords.x, bossCoords.y, bossCoords.z))
            else
                cb(vector3(216.672, -815.4998, 30.63524))
            end
        else
            cb(vector3(216.672, -815.4998, 30.63524))
        end
    end)
end

RegisterNetEvent('arshiahub.ir-CaptureSystem:SendPlayerGroupClient')
AddEventHandler('arshiahub.ir-CaptureSystem:SendPlayerGroupClient', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("arshiahub.ir-CaptureSystem:ReceiveGroup", xPlayer.source, xPlayer.group)
end)

RegisterNetEvent("arshiahub.ir-CaptureSystem:SendKillLog")
AddEventHandler("arshiahub.ir-CaptureSystem:SendKillLog",function(KillerID,ZoneName)
    local DamagedPlayer = ESX.GetPlayerFromId(source)
    local KillerPlayer = ESX.GetPlayerFromId(KillerID)
    if KillerPlayer and DamagedPlayer then
        UpsertPlayerStat(DamagedPlayer.identifier, GetPlayerName(DamagedPlayer.source), 'deaths', 1)
        GetPlayerRank(KillerPlayer.identifier, function(killerRank)
            GetPlayerRank(DamagedPlayer.identifier, function(damagedRank)
                TriggerClientEvent("arshiahub.ir-CaptureSystem:ShowKillLog", -1, DamagedPlayer.source, KillerPlayer.source,
                DamagedPlayer.gang.name, KillerPlayer.gang.name, GetPlayerName(DamagedPlayer.source), GetPlayerName(KillerPlayer.source), ZoneName, os.date("%H:%M:%S"), killerRank, damagedRank)

                SendLog("Kills", {
                    title = "🔫 Kill",
                    color = 0xE74C3C,
                    fields = {
                        {name = "Killer", value = GetPlayerName(KillerPlayer.source) .. " [" .. killerRank .. "] (" .. KillerPlayer.gang.name .. ")", inline = false},
                        {name = "Victim", value = GetPlayerName(DamagedPlayer.source) .. " [" .. damagedRank .. "] (" .. DamagedPlayer.gang.name .. ")", inline = false},
                        {name = "Zone", value = tostring(ZoneName), inline = true},
                    },
                })
            end)
        end)
    end
end)
function GetDistanceFromGangBoss(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    GetGangBossCoords(source, function(bossCoords)
        if bossCoords then
            local distance = #(playerCoords - bossCoords)
            cb(distance)
        else
            cb(nil)
        end
    end)
end

function SendResult()
    local topFiveKillers = GetTopKillers()
    local topGangs = GetTopGangs()

    local winnerGang = topGangs[1] and topGangs[1].Name or nil
    local winnerPoints = topGangs[1] and topGangs[1].Points or 0
    local topKillerName = topFiveKillers[1] and topFiveKillers[1].Name or nil
    local topKillerKills = topFiveKillers[1] and topFiveKillers[1].Point or 0

    for _, killer in ipairs(topFiveKillers) do
        if killer.Identifier then
            UpsertPlayerStat(killer.Identifier, killer.Name, 'top5_count', 1)
        end
    end

    MySQL.Async.execute(
        'INSERT INTO capture_history (round_date, winner_gang, winner_points, top_killer_name, top_killer_kills, top_gangs_json, top_killers_json) VALUES (@date, @winnerGang, @winnerPoints, @topKillerName, @topKillerKills, @topGangsJson, @topKillersJson)',
        {
            ['@date'] = os.date('%Y-%m-%d %H:%M:%S'),
            ['@winnerGang'] = winnerGang,
            ['@winnerPoints'] = winnerPoints,
            ['@topKillerName'] = topKillerName,
            ['@topKillerKills'] = topKillerKills,
            ['@topGangsJson'] = json.encode(topGangs),
            ['@topKillersJson'] = json.encode(topFiveKillers),
        }
    )

    SendLog("RoundEnd", {
        title = "🔴 Capture Round Ended",
        color = 0xE74C3C,
        fields = {
            {name = "Winning Gang", value = winnerGang and (tostring(winnerGang) .. " (" .. winnerPoints .. " pts)") or "N/A", inline = true},
            {name = "Top Killer", value = topKillerName and (tostring(topKillerName) .. " (" .. topKillerKills .. " kills)") or "N/A", inline = true},
        },
    })

    local killersEmbed = {
        title = "🏆 Top 5 Killers",
        color = 0xFF0000,
        fields = {},
        footer = {
            text = "Arshiahub.ir Capture System | " .. os.date("%Y-%m-%d %H:%M:%S"),
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    for i, killer in ipairs(topFiveKillers) do
        table.insert(killersEmbed.fields, {
            name = "#" .. i .. " - " .. (killer.Name or "Unknown"),
            value = "Kills: **" .. (killer.Point or 0) .. "**",
            inline = true
        })
    end

    if #killersEmbed.fields == 0 then
        table.insert(killersEmbed.fields, {
            name = "No Data",
            value = "No kills.",
            inline = true
        })
    end

    PerformHttpRequest(Config.KillersWebhook, function(err, text, headers)
        if err then
            print("[arshiahub.ir-Capture] Error send webhook: " .. err)
        end
    end, 'POST', json.encode({
        username = "Arshiahub.ir Capture System",
        avatar_url = "https://cdn.discordapp.com/attachments/1364687459400548405/1365210979289403413/logo.png?ex=685f89cd&is=685e384d&hm=3e5247fef3fded26438a03112a1d6a2c40410b18f9285397f22d5cdf315285b1&",
        embeds = { killersEmbed }
    }), { ['Content-Type'] = 'application/json' })

    local gangsEmbed = {
        title = "🥇 Top 5 Gangs",
        color = 0x00FF00,
        fields = {},
        footer = {
            text = "Arshiahub.ir Capture System | " .. os.date("%Y-%m-%d %H:%M:%S"),
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    for i, gang in ipairs(topGangs) do
        local gangName = tostring(gang.Name)
        if gangName:match("^%d+$") then
            local xPlayer = ESX.GetPlayerFromIdentifier(gangName)
            gangName = xPlayer and xPlayer.gang.name or "Unknown Gang"
        end
        table.insert(gangsEmbed.fields, {
            name = "#" .. i .. " - " .. gangName,
            value = "Points: **" .. (gang.Points or 0) .. "**",
            inline = true
        })
    end

    if #gangsEmbed.fields == 0 then
        table.insert(gangsEmbed.fields, {
            name = "No Data",
            value = "No gang points.",
            inline = true
        })
    end

    PerformHttpRequest(Config.GangsWebhook, function(err, text, headers)
        if err then
            print("[arshiahub.ir-Capture] Error send webhook: " .. err)
        end
    end, 'POST', json.encode({
        username = "Arshiahub.ir Capture System",
        avatar_url = "https://cdn.discordapp.com/attachments/1364687459400548405/1365210979289403413/logo.png?ex=685f89cd&is=685e384d&hm=3e5247fef3fded26438a03112a1d6a2c40410b18f9285397f22d5cdf315285b1&",
        embeds = { gangsEmbed }
    }), { ['Content-Type'] = 'application/json' })
end

function GetTopGangs()
    local gangs = {}

    for gang, points in pairs(CaptureState.Points) do
        local gangName = tostring(gang)
        if type(gangName) == "string" and string.sub(gangName, 1, 6) == "table:" then
            goto continue
        end
        EnsureGangLogoCached(gangName)
        table.insert(gangs, {
            Name = gangName,
            Points = points,
            Logo = GetGangLogo(gangName)
        })
        ::continue::
    end

    table.sort(gangs, function(a, b)
        return (a.Points or 0) > (b.Points or 0)
    end)

    local topFive = {}
    for i = 1, math.min(5, #gangs) do
        topFive[i] = gangs[i]
    end

    return topFive
end

if Config.EnablePublicAPI then
    print("^3[Unique-Capture]^7 Public API enabled at " .. Config.PublicAPIPath .. " - NOTE: this takes over the server's HTTP handler, it may conflict with other resources using SetHttpHandler.")

    SetHttpHandler(function(req, res)
        if req.path ~= Config.PublicAPIPath then
            res.writeHead(404, {["Content-Type"] = "application/json"})
            res.send(json.encode({error = "not found"}))
            return
        end

        local zoneCount = 0
        for _ in pairs(CapturesInfo.Zones) do zoneCount = zoneCount + 1 end

        local data = {
            active = CapturesInfo.Active,
            time_remaining = (CapturesInfo.Active and CapturesInfo.EndTime) and (CapturesInfo.EndTime - os.time()) or 0,
            zone_count = zoneCount,
            active_theme = CurrentThemeName,
            top_killers = GetTopKillers(),
            top_gangs = GetTopGangs(),
        }

        res.writeHead(200, {["Content-Type"] = "application/json", ["Access-Control-Allow-Origin"] = "*"})
        res.send(json.encode(data))
    end)
end

if Config.EnableAcademy then
    local AcademyPedsBySource = {}

    Citizen.CreateThread(function()
        MySQL.Async.execute([[
            CREATE TABLE IF NOT EXISTS `capture_academy_stats` (
              `identifier` VARCHAR(60) NOT NULL,
              `name` VARCHAR(100) DEFAULT NULL,
              `kills` INT NOT NULL DEFAULT 0,
              PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]], {}, function() end)
    end)

    RegisterNetEvent("arshiahub.ir-Capture:EnterAcademyWorld")
    AddEventHandler("arshiahub.ir-Capture:EnterAcademyWorld", function()
        local _source = source
        SetPlayerRoutingBucket(_source, Config.AcademyWorld)

        if AcademyPedsBySource[_source] then
            for _, netId in ipairs(AcademyPedsBySource[_source]) do
                local ped = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(ped) then DeleteEntity(ped) end
            end
        end

        local peds = {}
        for i = 1, Config.AcademyStartNPCCount do
            local offsetX = math.random(-15, 15)
            local offsetY = math.random(-15, 15)
            local ped = CreatePed(4, GetHashKey(Config.AcademyNPCModel), Config.AcademyCoord.x + offsetX, Config.AcademyCoord.y + offsetY, Config.AcademyCoord.z, 0.0, true, true)
            if DoesEntityExist(ped) then
                SetEntityRoutingBucket(ped, Config.AcademyWorld)
                GiveWeaponToPed(ped, GetHashKey(Config.AcademyWeapon), 250, false, true)
                table.insert(peds, NetworkGetNetworkIdFromEntity(ped))
            end
        end
        AcademyPedsBySource[_source] = peds

        local xPlayer = ESX.GetPlayerFromId(_source)
        MySQL.Async.fetchAll('SELECT kills FROM capture_academy_stats WHERE identifier = @id LIMIT 1', {
            ['@id'] = xPlayer.identifier
        }, function(results)
            local currentKills = results and results[1] and results[1].kills or 0
            TriggerClientEvent("arshiahub.ir-Capture:AcademyPedsSpawned", _source, peds, currentKills)
        end)
    end)

    RegisterNetEvent("arshiahub.ir-Capture:AcademyNpcKilled")
    AddEventHandler("arshiahub.ir-Capture:AcademyNpcKilled", function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        if not xPlayer then return end
        MySQL.Async.execute(
            'INSERT INTO capture_academy_stats (identifier, name, kills) VALUES (@id, @name, 1) '..
            'ON DUPLICATE KEY UPDATE kills = kills + 1, name = @name',
            {
                ['@id'] = xPlayer.identifier,
                ['@name'] = GetPlayerName(_source),
            }
        )
    end)

    RegisterNetEvent("arshiahub.ir-Capture:LeaveAcademyWorld")
    AddEventHandler("arshiahub.ir-Capture:LeaveAcademyWorld", function()
        local _source = source
        SetPlayerRoutingBucket(_source, 0)
        if AcademyPedsBySource[_source] then
            for _, netId in ipairs(AcademyPedsBySource[_source]) do
                local ped = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(ped) then DeleteEntity(ped) end
            end
            AcademyPedsBySource[_source] = nil
        end
    end)

    AddEventHandler('playerDropped', function()
        local _source = source
        if AcademyPedsBySource[_source] then
            for _, netId in ipairs(AcademyPedsBySource[_source]) do
                local ped = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(ped) then DeleteEntity(ped) end
            end
            AcademyPedsBySource[_source] = nil
        end
    end)
end

if Config.EnableSpectate then
    local SpectatorSources = {}

    RegisterCommand(Config.SpectateCommand, function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        if xPlayer.permission_level <= Config.SpectatePermLevel then
            TriggerClientEvent("chat:addMessage", source, {args = {"^1Unique-CaptureSystem", "You Don't Have Permissions !"}})
            return
        end
        if not CapturesInfo.Active then
            TriggerClientEvent("arshiahub.ir-Capture:OxNotify", source, "No Active Capture Round To Spectate !", 'error')
            return
        end
        SpectatorSources[source] = true
        SetPlayerRoutingBucket(source, Config.CaptureWorld)
        TriggerClientEvent("arshiahub.ir-Capture:SpectateReady", source)
    end)

    RegisterCommand(Config.SpectateLeaveCommand, function(source, args, rawCommand)
        SpectatorSources[source] = nil
        SetPlayerRoutingBucket(source, 0)
    end)

    AddEventHandler('playerDropped', function()
        SpectatorSources[source] = nil
    end)

    -- Every real round participant currently in the capture world (spectators
    -- themselves are excluded so they can't "watch" each other).
    ESX.RegisterServerCallback("arshiahub.ir-Capture:GetSpectateTargets", function(source, cb)
        local list = {}
        local xPlayers = ESX.GetPlayers()
        for i = 1, #xPlayers do
            local playerSrc = xPlayers[i]
            if not SpectatorSources[playerSrc] and GetPlayerRoutingBucket(playerSrc) == Config.CaptureWorld then
                local yPlayer = ESX.GetPlayerFromId(playerSrc)
                if yPlayer then
                    list[#list + 1] = {
                        source = playerSrc,
                        name = GetPlayerName(playerSrc),
                        gang = (yPlayer.gang and yPlayer.gang.name) or "nogang",
                    }
                end
            end
        end
        cb(list)
    end)
end
