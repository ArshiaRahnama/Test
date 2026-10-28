-- Discord app v16 (Unique_Phone): channel templates + featured messages. Safe to re-run.
ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `is_featured` TINYINT(1) NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `phone_discord_channel_templates` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `name` VARCHAR(40) NOT NULL,
  `topic` VARCHAR(200) DEFAULT NULL,
  `kind` VARCHAR(8) NOT NULL DEFAULT 'text',
  `is_locked` TINYINT(1) NOT NULL DEFAULT 0,
  `created_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server` (`server_id`),
  CONSTRAINT `fk_discord_ctpl_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
