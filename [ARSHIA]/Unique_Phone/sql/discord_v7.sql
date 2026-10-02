-- Discord app v7 (Unique_Phone) -----------------------------------------
-- Safe to re-run. Run AFTER sql/discord.sql.
-- Adds: auto gang/job servers, boosts, VIP tariff, timeouts, warns,
-- auto-mod, reports, XP/levels, badges, custom emoji slots, unread tracking,
-- per-server theme colour.

ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `kind` VARCHAR(10) DEFAULT NULL,          -- NULL = normal, 'gang' or 'job' = auto-managed
  ADD COLUMN IF NOT EXISTS `auto_key` VARCHAR(60) DEFAULT NULL,      -- 'gang:<name>' / 'job:<name>'
  ADD COLUMN IF NOT EXISTS `theme_color` VARCHAR(9) DEFAULT NULL,    -- '#rrggbb' chosen by the owner
  ADD COLUMN IF NOT EXISTS `vip_until` INT(11) DEFAULT NULL;         -- paid VIP expiry (NULL = staff-set / none)

ALTER TABLE `phone_discord_servers`
  ADD UNIQUE INDEX IF NOT EXISTS `auto_key` (`auto_key`);

-- Server boosts: one row per boost, expires after Config.DiscordExt.Boost.Days.
CREATE TABLE IF NOT EXISTS `phone_discord_boosts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `created_at` INT(11) NOT NULL,
  `expires_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_boosts_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Custom reaction emoji unlocked by boost levels.
CREATE TABLE IF NOT EXISTS `phone_discord_emojis` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `emoji` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_emoji` (`server_id`, `emoji`),
  CONSTRAINT `fk_discord_emojis_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Temporary mute (timeout) inside one server.
CREATE TABLE IF NOT EXISTS `phone_discord_timeouts` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `until_at` INT(11) NOT NULL,
  `reason` VARCHAR(120) NOT NULL DEFAULT '',
  `by_name` VARCHAR(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`server_id`, `identifier`),
  CONSTRAINT `fk_discord_timeouts_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Warn history.
CREATE TABLE IF NOT EXISTS `phone_discord_warns` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `reason` VARCHAR(150) NOT NULL DEFAULT '',
  `by_name` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_member` (`server_id`, `identifier`),
  CONSTRAINT `fk_discord_warns_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-server banned words (global words live in config.lua).
CREATE TABLE IF NOT EXISTS `phone_discord_automod` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `word` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_word` (`server_id`, `word`),
  CONSTRAINT `fk_discord_automod_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Report queue for game staff. Message text is snapshotted so the report
-- stays readable even if the message is later deleted.
CREATE TABLE IF NOT EXISTS `phone_discord_reports` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `channel_id` INT(11) NOT NULL,
  `message_id` INT(11) NOT NULL,
  `message_text` VARCHAR(400) NOT NULL DEFAULT '',
  `author_identifier` VARCHAR(60) NOT NULL,
  `author_name` VARCHAR(60) NOT NULL DEFAULT '',
  `reporter_identifier` VARCHAR(60) NOT NULL,
  `reporter_name` VARCHAR(60) NOT NULL DEFAULT '',
  `reason` VARCHAR(150) NOT NULL DEFAULT '',
  `status` VARCHAR(12) NOT NULL DEFAULT 'pending',   -- pending | dismissed | removed
  `handled_by` VARCHAR(60) DEFAULT NULL,
  `created_at` INT(11) NOT NULL,
  `handled_at` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  UNIQUE KEY `one_report_each` (`message_id`, `reporter_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- XP / levels per server.
CREATE TABLE IF NOT EXISTS `phone_discord_xp` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `xp` INT(11) NOT NULL DEFAULT 0,
  `messages` INT(11) NOT NULL DEFAULT 0,
  `last_xp_at` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`server_id`, `identifier`),
  KEY `leaderboard` (`server_id`, `xp`),
  CONSTRAINT `fk_discord_xp_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Messages per calendar month (for the "top chatter of the month" badge).
CREATE TABLE IF NOT EXISTS `phone_discord_monthly` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `ym` INT(11) NOT NULL,                       -- e.g. 202609
  `cnt` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`server_id`, `identifier`, `ym`),
  CONSTRAINT `fk_discord_monthly_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Stored badges (founder / booster / level badges are computed, not stored).
CREATE TABLE IF NOT EXISTS `phone_discord_badges` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `badge` VARCHAR(20) NOT NULL,
  `note` VARCHAR(20) DEFAULT NULL,
  `awarded_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `one_each` (`server_id`, `identifier`, `badge`),
  CONSTRAINT `fk_discord_badges_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Last-read marker per channel, for real unread counters.
CREATE TABLE IF NOT EXISTS `phone_discord_seen` (
  `identifier` VARCHAR(60) NOT NULL,
  `channel_id` INT(11) NOT NULL,
  `last_id` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`, `channel_id`),
  CONSTRAINT `fk_discord_seen_channel` FOREIGN KEY (`channel_id`)
    REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
