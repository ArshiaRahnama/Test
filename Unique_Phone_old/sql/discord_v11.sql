-- Discord app v11 (Unique_Phone) -----------------------------------------
-- Safe to re-run. Run AFTER discord.sql / discord_v7.sql / discord_v8.sql.
-- Adds: avatars + server icons (image URLs), friends, blocks, direct messages,
-- uploaded (image) server emoji.

ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `avatar_url` VARCHAR(500) DEFAULT NULL;

-- Stable numeric id used by the UI instead of the character identifier.
ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `uid` INT(11) NOT NULL AUTO_INCREMENT,
  ADD UNIQUE INDEX IF NOT EXISTS `uid` (`uid`);

ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `icon_url` VARCHAR(500) DEFAULT NULL;

-- Friendship: one row per pair (user_low < user_high as strings).
CREATE TABLE IF NOT EXISTS `phone_discord_friends` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_low` VARCHAR(60) NOT NULL,
  `user_high` VARCHAR(60) NOT NULL,
  `requester` VARCHAR(60) NOT NULL,
  `status` VARCHAR(10) NOT NULL DEFAULT 'pending',     -- pending | accepted
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`user_low`, `user_high`),
  KEY `user_high` (`user_high`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_blocks` (
  `blocker` VARCHAR(60) NOT NULL,
  `blocked` VARCHAR(60) NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`blocker`, `blocked`),
  KEY `blocked` (`blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_dms` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_low` VARCHAR(60) NOT NULL,
  `user_high` VARCHAR(60) NOT NULL,
  `created_at` INT(11) NOT NULL,
  `last_at` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`user_low`, `user_high`),
  KEY `user_high` (`user_high`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_dm_messages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `dm_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `author_name` VARCHAR(80) NOT NULL DEFAULT '',
  `message` VARCHAR(1000) NOT NULL,
  `created_at` INT(11) NOT NULL,
  `edited_at` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dm_id` (`dm_id`, `id`),
  CONSTRAINT `fk_discord_dmm_dm` FOREIGN KEY (`dm_id`)
    REFERENCES `phone_discord_dms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_dm_seen` (
  `identifier` VARCHAR(60) NOT NULL,
  `dm_id` INT(11) NOT NULL,
  `last_id` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`, `dm_id`),
  CONSTRAINT `fk_discord_dms_dm` FOREIGN KEY (`dm_id`)
    REFERENCES `phone_discord_dms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Uploaded server emoji (image URL, used as :name:).
CREATE TABLE IF NOT EXISTS `phone_discord_custom_emoji` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `name` VARCHAR(16) NOT NULL,
  `url` VARCHAR(500) NOT NULL,
  `created_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_name` (`server_id`, `name`),
  CONSTRAINT `fk_discord_ce_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
