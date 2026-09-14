-- ================================================================= --
-- Unique_LevelQuest — database reference (NOT required anymore)
-- ================================================================= --
-- You do NOT need to run this file. server/migrations.lua checks your
-- database automatically every time the resource starts and adds
-- whatever's missing (users.xp, users.rank, the quest table, and its
-- `date` column) — safe to run on a fresh DB or one that already has
-- some/all of this, every single time, with no errors either way.
--
-- This file is kept only so you can see what the schema looks like, or
-- run it by hand if you ever want to for some reason.
-- ================================================================= --

ALTER TABLE `users`
    ADD COLUMN `xp`   INT(11) NOT NULL DEFAULT 0,
    ADD COLUMN `rank` INT(11) NOT NULL DEFAULT 1;

CREATE TABLE IF NOT EXISTS `quest` (
    `identifier` VARCHAR(60)  NOT NULL,
    `date`       VARCHAR(20)  NOT NULL DEFAULT '',
    `quests`     LONGTEXT     NOT NULL,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
