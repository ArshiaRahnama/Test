-- Discord app v8 (Unique_Phone) ------------------------------------------
-- Safe to re-run. Run AFTER sql/discord.sql and sql/discord_v7.sql.
-- Adds: roles + permissions + channel overrides, limited invites + vanity,
-- welcome/rules screening, stage channels, server templates, mutes,
-- server folders, role mentions.

ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `description`   VARCHAR(200) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `welcome_title` VARCHAR(60)  DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `welcome_text`  VARCHAR(400) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `rules_text`    VARCHAR(800) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `require_rules` TINYINT(1)   NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `rules_since`   INT(11)      DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `vanity`        VARCHAR(30)  DEFAULT NULL;

ALTER TABLE `phone_discord_servers`
  ADD UNIQUE INDEX IF NOT EXISTS `vanity` (`vanity`);

ALTER TABLE `phone_discord_channels`
  ADD COLUMN IF NOT EXISTS `kind` VARCHAR(8) NOT NULL DEFAULT 'text';     -- 'text' | 'stage'

ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `role_mentions` VARCHAR(120) DEFAULT NULL;      -- "3,7" (role ids) / "-1" = @admin

-- Roles. One row per server has is_default = 1 (@everyone).
CREATE TABLE IF NOT EXISTS `phone_discord_roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `name` VARCHAR(32) NOT NULL,
  `color` VARCHAR(9) DEFAULT NULL,
  `position` INT(11) NOT NULL DEFAULT 1,
  `perms` TEXT NOT NULL,                       -- JSON object {"send":true,...}
  `mentionable` TINYINT(1) NOT NULL DEFAULT 0,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_roles_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_member_roles` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `role_id` INT(11) NOT NULL,
  PRIMARY KEY (`role_id`, `identifier`),
  KEY `member` (`server_id`, `identifier`),
  CONSTRAINT `fk_discord_mr_role` FOREIGN KEY (`role_id`)
    REFERENCES `phone_discord_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-channel role overrides (allow / deny lists of permission names).
CREATE TABLE IF NOT EXISTS `phone_discord_channel_perms` (
  `channel_id` INT(11) NOT NULL,
  `role_id` INT(11) NOT NULL,
  `allow` VARCHAR(200) NOT NULL DEFAULT '[]',
  `deny` VARCHAR(200) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`channel_id`, `role_id`),
  CONSTRAINT `fk_discord_cp_channel` FOREIGN KEY (`channel_id`)
    REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_discord_cp_role` FOREIGN KEY (`role_id`)
    REFERENCES `phone_discord_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Extra invite codes with a use limit and/or an expiry.
CREATE TABLE IF NOT EXISTS `phone_discord_invites` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `code` VARCHAR(12) NOT NULL,
  `max_uses` INT(11) NOT NULL DEFAULT 0,       -- 0 = unlimited
  `uses` INT(11) NOT NULL DEFAULT 0,
  `expires_at` INT(11) DEFAULT NULL,           -- NULL = never
  `created_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_inv_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Welcome screen / rules screening: a row = "accepted".
CREATE TABLE IF NOT EXISTS `phone_discord_rules_accept` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `accepted_at` INT(11) NOT NULL,
  PRIMARY KEY (`server_id`, `identifier`),
  CONSTRAINT `fk_discord_ra_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Stage channels: people allowed to speak besides owner/admins.
CREATE TABLE IF NOT EXISTS `phone_discord_stage_speakers` (
  `channel_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`channel_id`, `identifier`),
  CONSTRAINT `fk_discord_ss_channel` FOREIGN KEY (`channel_id`)
    REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Server templates (snapshot of channels / roles / settings, no messages or members).
CREATE TABLE IF NOT EXISTS `phone_discord_templates` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(10) NOT NULL,
  `name` VARCHAR(40) NOT NULL,
  `description` VARCHAR(120) NOT NULL DEFAULT '',
  `creator_identifier` VARCHAR(60) NOT NULL,
  `creator_name` VARCHAR(60) NOT NULL DEFAULT '',
  `data` MEDIUMTEXT NOT NULL,
  `is_public` TINYINT(1) NOT NULL DEFAULT 1,
  `uses` INT(11) NOT NULL DEFAULT 0,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-user mutes (kind = 'channel' | 'server').
CREATE TABLE IF NOT EXISTS `phone_discord_mutes` (
  `identifier` VARCHAR(60) NOT NULL,
  `kind` VARCHAR(8) NOT NULL,
  `target_id` INT(11) NOT NULL,
  PRIMARY KEY (`identifier`, `kind`, `target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-user server folders for the server rail.
CREATE TABLE IF NOT EXISTS `phone_discord_folders` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(24) NOT NULL DEFAULT 'Folder',
  `color` VARCHAR(9) NOT NULL DEFAULT '#5865F2',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_folder_items` (
  `identifier` VARCHAR(60) NOT NULL,
  `server_id` INT(11) NOT NULL,
  `folder_id` INT(11) NOT NULL,
  PRIMARY KEY (`identifier`, `server_id`),
  KEY `folder_id` (`folder_id`),
  CONSTRAINT `fk_discord_fi_folder` FOREIGN KEY (`folder_id`)
    REFERENCES `phone_discord_folders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- v9: government bridge (esx_uniquejobs): who exported whose chats, and when.
-- The exported text itself lives in esx_uniquejobs (dept_discord_evidence).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `phone_discord_evidence_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `suspect_identifier` VARCHAR(60) NOT NULL,
  `requested_by` VARCHAR(80) NOT NULL DEFAULT '',
  `warrant_ref` VARCHAR(40) NOT NULL DEFAULT '',
  `case_ref` VARCHAR(40) NOT NULL DEFAULT '',
  `msg_count` INT(11) NOT NULL DEFAULT 0,
  `checksum` VARCHAR(24) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `suspect_identifier` (`suspect_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
