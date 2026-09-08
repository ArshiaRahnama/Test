-- ================================================================= --
-- Adds punishment_history — a permanent log of jail sentences and
-- community service assignments, separate from `users.jail` /
-- `communityservice` (which only ever hold the CURRENT sentence and
-- get overwritten/deleted on release — no record survives that a
-- player was ever punished once it's served). This table is written
-- to (never read from) here; Unique_LevelQuest's server/record.lua
-- reads it to show a player their own record history.
-- ================================================================= --

MySQL.Async.execute([[
    CREATE TABLE IF NOT EXISTS `punishment_history` (
        `id`             INT AUTO_INCREMENT PRIMARY KEY,
        `identifier`     VARCHAR(60) NOT NULL,
        `type`           VARCHAR(20) NOT NULL,
        `reason`         TEXT NULL,
        `duration`       INT NULL,
        `issued_by_name` VARCHAR(100) NULL,
        `issued_by_type` VARCHAR(30) NULL,
        `created_at`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        INDEX `idx_identifier` (`identifier`)
    )
]], {})
