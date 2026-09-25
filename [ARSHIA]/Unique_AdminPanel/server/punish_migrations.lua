-- ================================================================= --
-- Adds punishment_history — a permanent log of jail sentences and
-- community service assignments, separate from `users.jail` /
-- `communityservice` (which only ever hold the CURRENT sentence and
-- get overwritten/deleted on release — no record survives that a
-- player was ever punished once it's served). This table is written
-- to (never read from) here; Unique_LevelQuest's server/record.lua
-- reads it to show a player their own record history.
--
-- FIX: this used to call MySQL.Async.execute directly at the top
-- level of the file, outside any thread. On the very first tick a
-- resource starts, the oxmysql export it wraps isn't guaranteed to be
-- registered yet (depends on resource start order) — calling it too
-- early can throw, and a Lua error at the top level of a script
-- chunk aborts the REST of that chunk, which meant jail.lua and
-- cs.lua (loaded right after this one in fxmanifest.lua) could fail
-- to load at all, breaking /jail, /unjail, and /cs together. Wrapped
-- in a thread with a short wait, matching the same pattern
-- Unique_Capture's own migration already uses safely.
-- ================================================================= --

Citizen.CreateThread(function()
    Citizen.Wait(500)
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
end)
