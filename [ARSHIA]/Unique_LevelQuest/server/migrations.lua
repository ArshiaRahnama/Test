-- ================================================================= --
-- Auto migration — runs every time this resource starts.
-- ================================================================= --
-- Checks INFORMATION_SCHEMA before adding anything, so it's always
-- safe to run again: a fresh database gets everything created, a
-- database that already has some/all of it just gets whatever's
-- missing, silently. No more manual sql.sql runs, no more
-- "Duplicate column" / "Unknown column" errors either way.
-- ================================================================= --

local function columnExists(tableName, columnName, cb)
    MySQL.Async.fetchScalar([[
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = @c
    ]], { ['@t'] = tableName, ['@c'] = columnName }, function(count)
        cb(count ~= nil and count > 0)
    end)
end

local function tableExists(tableName, cb)
    MySQL.Async.fetchScalar([[
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t
    ]], { ['@t'] = tableName }, function(count)
        cb(count ~= nil and count > 0)
    end)
end

local function ensureColumn(tableName, columnName, definitionSql)
    columnExists(tableName, columnName, function(exists)
        if exists then return end
        MySQL.Async.execute('ALTER TABLE `' .. tableName .. '` ADD COLUMN ' .. definitionSql, {}, function()
            print(('[Unique_LevelQuest] migrated: added column %s.%s'):format(tableName, columnName))
        end)
    end)
end

CreateThread(function()
    -- users.xp / users.rank
    ensureColumn('users', 'xp',   "`xp` INT(11) NOT NULL DEFAULT 0")
    ensureColumn('users', 'rank', "`rank` INT(11) NOT NULL DEFAULT 1")

    -- users.coin is an INT(11) on this server, but quest/skill rewards are
    -- fractional (0.04, 0.10 ...). Writing 5 + 0.04 into an INT column
    -- silently rounds back to 5, so nearly every reward was being lost.
    -- The fractional part is accumulated here and only whole coins are
    -- ever written to users.coin (see GrantCoin in server/coin.lua).
    ensureColumn('users', 'coin_frac', "`coin_frac` DECIMAL(8,4) NOT NULL DEFAULT 0")

    -- quest table (create if missing, then make sure `date` exists even
    -- if the table was already there from an older/partial version)
    tableExists('quest', function(exists)
        if exists then
            ensureColumn('quest', 'date', "`date` VARCHAR(20) NOT NULL DEFAULT ''")
            return
        end

        MySQL.Async.execute([[
            CREATE TABLE `quest` (
                `identifier` VARCHAR(60)  NOT NULL,
                `date`       VARCHAR(20)  NOT NULL DEFAULT '',
                `quests`     LONGTEXT     NOT NULL,
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ]], {}, function()
            print('[Unique_LevelQuest] migrated: created table quest')
        end)
    end)

    -- job_skill table: per-player, per-job minutes worked (drives the
    -- Skill tab). Not shared with anything else on this server.
    tableExists('job_skill', function(exists)
        if exists then
            ensureColumn('job_skill', 'milestones_paid', "`milestones_paid` VARCHAR(50) NOT NULL DEFAULT ''")
            return
        end

        MySQL.Async.execute([[
            CREATE TABLE `job_skill` (
                `identifier`       VARCHAR(60) NOT NULL,
                `job`              VARCHAR(50) NOT NULL,
                `minutes`          INT(11)     NOT NULL DEFAULT 0,
                `milestones_paid`  VARCHAR(50) NOT NULL DEFAULT '',
                PRIMARY KEY (`identifier`, `job`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ]], {}, function()
            print('[Unique_LevelQuest] migrated: created table job_skill')
        end)
    end)

    -- player_skills: per-player activity skills (Unique-style). `percent` is
    -- 0..100, `finished` flips to 1 the moment it reaches 100.
    tableExists('player_skills', function(exists)
        if exists then return end
        MySQL.Async.execute([[
            CREATE TABLE `player_skills` (
                `identifier` VARCHAR(60) NOT NULL,
                `skill`      VARCHAR(50) NOT NULL,
                `percent`    DECIMAL(8,4) NOT NULL DEFAULT 0,
                `finished`   TINYINT(1)  NOT NULL DEFAULT 0,
                PRIMARY KEY (`identifier`, `skill`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ]], {}, function()
            print('[Unique_LevelQuest] migrated: created table player_skills')
        end)
    end)

    tableExists('weapon_skins', function(exists)
        if exists then return end
        MySQL.Async.execute([[
            CREATE TABLE `weapon_skins` (
                `identifier` VARCHAR(60) NOT NULL,
                `weapon`     VARCHAR(50) NOT NULL,
                `tint`       INT(11) NOT NULL DEFAULT 0,
                PRIMARY KEY (`identifier`, `weapon`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        ]], {}, function() print('[Unique_LevelQuest] migrated: created table weapon_skins') end)
    end)

end)
