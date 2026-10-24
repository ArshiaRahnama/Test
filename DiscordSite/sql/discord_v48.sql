-- Discord app v48 (Unique_Phone): Privacy Settings per server ("Allow direct messages from server members"). Safe to re-run.
-- No row = allowed (the default, like Discord).
CREATE TABLE IF NOT EXISTS `phone_discord_dm_privacy` (
  `identifier` VARCHAR(60) NOT NULL,
  `server_id` INT(11) NOT NULL,
  `allow_dms` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`identifier`, `server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
