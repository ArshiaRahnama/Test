-- Discord app v21 (Unique_Phone): message edit history + per-server bans. Safe to re-run.
CREATE TABLE IF NOT EXISTS `phone_discord_message_edits` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `message_id` INT(11) NOT NULL,
  `old_text` VARCHAR(1000) NOT NULL,
  `edited_by` VARCHAR(60) NOT NULL,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_server_bans` (
  `server_id` INT(11) NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(60) NOT NULL DEFAULT '',
  `reason` VARCHAR(160) NOT NULL DEFAULT '',
  `banned_by` VARCHAR(60) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`server_id`, `identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
