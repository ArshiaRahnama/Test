-- Optional: only needed if Config.UseDatabase = true in config.lua
-- The script also creates this table automatically on startup via oxmysql,
-- so running this file by hand is not required — it's here for reference
-- or for admins who prefer to manage their schema manually.

CREATE TABLE IF NOT EXISTS `unique_gungame_stats` (
    `identifier` VARCHAR(60) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `kills` INT NOT NULL DEFAULT 0,
    `wins` INT NOT NULL DEFAULT 0,
    `matches_played` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
