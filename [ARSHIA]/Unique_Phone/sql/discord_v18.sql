-- Discord app v18 (Unique_Phone): per-server audit log. Safe to re-run.
CREATE TABLE IF NOT EXISTS `phone_discord_server_audit` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `actor_identifier` VARCHAR(60) NOT NULL,
  `actor_name` VARCHAR(60) NOT NULL DEFAULT '',
  `action` VARCHAR(40) NOT NULL,
  `target` VARCHAR(160) NOT NULL DEFAULT '',
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_time` (`server_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
