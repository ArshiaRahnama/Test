-- Unique_Event - database schema
--
-- You do NOT need to run this file manually: every table below is created
-- automatically (CREATE TABLE IF NOT EXISTS) the first time the resource
-- starts, as soon as oxmysql is ready. It's included so you can review the
-- schema, run it manually if you prefer, or use it as a migration reference.

CREATE TABLE IF NOT EXISTS `ue_capture_stats` (
  `identifier`  VARCHAR(64) NOT NULL PRIMARY KEY,
  `name`        VARCHAR(64) NOT NULL DEFAULT '',
  `kills`       INT NOT NULL DEFAULT 0,
  `deaths`      INT NOT NULL DEFAULT 0,
  `gang_points` INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `ue_capture_history` (
  `id`          INT AUTO_INCREMENT PRIMARY KEY,
  `zone`        VARCHAR(64) NOT NULL,
  `winner_gang` VARCHAR(64) NOT NULL DEFAULT '',
  `ended_at`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `ue_gungame_stats` (
  `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
  `name`       VARCHAR(64) NOT NULL DEFAULT '',
  `wins`       INT NOT NULL DEFAULT 0,
  `kills`      INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `ue_warzone_stats` (
  `identifier` VARCHAR(64) NOT NULL PRIMARY KEY,
  `name`       VARCHAR(64) NOT NULL DEFAULT '',
  `wins`       INT NOT NULL DEFAULT 0,
  `kills`      INT NOT NULL DEFAULT 0,
  `deaths`     INT NOT NULL DEFAULT 0
);
