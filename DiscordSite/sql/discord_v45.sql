-- Discord app v45 (Unique_Phone): user-made channel categories. Safe to re-run.
CREATE TABLE IF NOT EXISTS `phone_discord_categories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `server_id` INT(11) NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `position` INT(11) NOT NULL DEFAULT 0,
  `created_at` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_cat_server` FOREIGN KEY (`server_id`)
    REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `phone_discord_channels` ADD COLUMN IF NOT EXISTS `category_id` INT(11) DEFAULT NULL;
