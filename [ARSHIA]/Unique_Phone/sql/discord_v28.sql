-- Discord app v28 (Unique_Phone): who may create channels and servers (admin panel). Safe to re-run.
CREATE TABLE IF NOT EXISTS `phone_discord_creators` (
  `identifier` VARCHAR(60) NOT NULL,
  `granted_by` VARCHAR(60) NOT NULL DEFAULT '',
  `granted_at` INT(11) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `phone_discord_settings` (
  `k` VARCHAR(40) NOT NULL,
  `v` VARCHAR(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
