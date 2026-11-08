-- Discord app v14 (Unique_Phone): channel order, announcement follows, server health,
-- mutual-friend count, punishment appeals, private staff notes. Safe to re-run.
ALTER TABLE `phone_discord_channels`
  ADD COLUMN IF NOT EXISTS `is_announcement` TINYINT(1) NOT NULL DEFAULT 0;

-- A channel in another server that copies every message of an announcement channel.
CREATE TABLE IF NOT EXISTS `phone_discord_follows` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `source_channel_id` INT(11) NOT NULL,
  `target_channel_id` INT(11) NOT NULL,
  `created_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `one_target` (`target_channel_id`),
  KEY `source` (`source_channel_id`),
  CONSTRAINT `fk_discord_follow_target` FOREIGN KEY (`target_channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_discord_follow_source` FOREIGN KEY (`source_channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Members ask staff to review a timeout or a warning.
CREATE TABLE IF NOT EXISTS `phone_discord_appeals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `kind` VARCHAR(8) NOT NULL,              -- 'timeout' | 'warn'
  `ref_id` INT(11) NOT NULL DEFAULT 0,     -- warn id (0 for a timeout)
  `text` VARCHAR(500) NOT NULL,
  `status` VARCHAR(10) NOT NULL DEFAULT 'pending', -- pending | accepted | denied
  `created_at` INT(11) NOT NULL,
  `handled_by` VARCHAR(60) DEFAULT NULL,
  `handled_at` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `server_status` (`server_id`, `status`),
  KEY `member` (`server_id`, `identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Notes only staff can read. Never sent to the member, never in member lists.
CREATE TABLE IF NOT EXISTS `phone_discord_staff_notes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `target_identifier` VARCHAR(60) NOT NULL,
  `author_identifier` VARCHAR(60) NOT NULL,
  `author_name` VARCHAR(60) NOT NULL DEFAULT '',
  `text` VARCHAR(500) NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `target` (`server_id`, `target_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
