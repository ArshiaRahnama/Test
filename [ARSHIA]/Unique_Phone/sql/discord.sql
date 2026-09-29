-- Discord app (Unique_Phone) --------------------------------------------
-- Run this once against your database (same as db.sql / the other files
-- in this folder). Uses InnoDB so the foreign keys below actually cascade.

CREATE TABLE IF NOT EXISTS `phone_discord_servers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `icon_text` VARCHAR(4) NOT NULL DEFAULT 'D',
  `icon_color` VARCHAR(20) NOT NULL DEFAULT '#5865F2',
  `owner_identifier` VARCHAR(60) NOT NULL,
  `invite_code` VARCHAR(10) NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invite_code` (`invite_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_channels` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `name` VARCHAR(40) NOT NULL,
  `position` INT(11) NOT NULL DEFAULT 0,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_channels_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_members` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `nickname` VARCHAR(50) NOT NULL,
  `joined_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_member` (`server_id`, `identifier`),
  CONSTRAINT `fk_discord_members_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_messages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `channel_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `author_name` VARCHAR(50) NOT NULL,
  `message` TEXT NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `fk_discord_messages_channel` FOREIGN KEY (`channel_id`)
    REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- v2: edit/pin support (safe to re-run on an existing install)
ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `edited_at` INT(11) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `is_pinned` TINYINT(1) NOT NULL DEFAULT 0;

-- v2: emoji reactions — one row per (message, player, emoji); the unique
-- key is also what makes "toggle" cheap (insert or delete that exact row).
CREATE TABLE IF NOT EXISTS `phone_discord_reactions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `message_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `emoji` VARCHAR(16) NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `message_identifier_emoji` (`message_id`, `identifier`, `emoji`),
  CONSTRAINT `fk_discord_reactions_message` FOREIGN KEY (`message_id`)
    REFERENCES `phone_discord_messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- v3: replies, admin role, public/discoverable servers
ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `reply_to_id` INT(11) DEFAULT NULL;

ALTER TABLE `phone_discord_members`
  ADD COLUMN IF NOT EXISTS `is_admin` TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `is_public` TINYINT(1) NOT NULL DEFAULT 0;

-- Voice channels were removed — clean up if an earlier version created this.
DROP TABLE IF EXISTS `phone_discord_voice_members`;

-- v4: Discord account/profile per character. The in-game info shown on a
-- profile (name, phone, job, gender, birthdate) is read live from `users`
-- / `jobs` / `job_grades` — only the Discord-specific bits are stored here.
CREATE TABLE IF NOT EXISTS `phone_discord_profiles` (
  `identifier` VARCHAR(60) NOT NULL,
  `discriminator` VARCHAR(4) NOT NULL,
  `bio` VARCHAR(190) NOT NULL DEFAULT '',
  `status` VARCHAR(10) NOT NULL DEFAULT 'online',
  `custom_status` VARCHAR(60) NOT NULL DEFAULT '',
  `banner_color` VARCHAR(20) NOT NULL DEFAULT '#5865F2',
  `show_phone` TINYINT(1) NOT NULL DEFAULT 1,
  `show_job` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` INT(11) NOT NULL,
  `updated_at` INT(11) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- v5: staff panel — verified (blue tick) accounts/servers/channels, locked
-- (read-only) channels, announcements, Discord-wide bans, audit log.
ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `verified` TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `is_verified` TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE `phone_discord_channels`
  ADD COLUMN IF NOT EXISTS `is_verified` TINYINT(1) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `is_locked` TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `is_announcement` TINYINT(1) NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `phone_discord_bans` (
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(60) NOT NULL DEFAULT '',
  `reason` VARCHAR(150) NOT NULL DEFAULT '',
  `banned_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  `expires_at` INT(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_audit` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `staff_name` VARCHAR(60) NOT NULL,
  `action` VARCHAR(120) NOT NULL,
  `target` VARCHAR(120) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
