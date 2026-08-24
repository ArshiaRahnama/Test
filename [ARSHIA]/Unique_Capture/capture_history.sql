CREATE TABLE IF NOT EXISTS `capture_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `round_date` DATETIME NOT NULL,
  `winner_gang` VARCHAR(50) DEFAULT NULL,
  `winner_points` INT DEFAULT 0,
  `top_killer_name` VARCHAR(100) DEFAULT NULL,
  `top_killer_kills` INT DEFAULT 0,
  `top_gangs_json` TEXT,
  `top_killers_json` TEXT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_player_stats` (
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `kills` INT NOT NULL DEFAULT 0,
  `deaths` INT NOT NULL DEFAULT 0,
  `top5_count` INT NOT NULL DEFAULT 0,
  `gang_points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- If upgrading an existing install, run this once:
-- ALTER TABLE capture_player_stats ADD COLUMN gang_points INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `capture_player_zone_stats` (
  `identifier` VARCHAR(60) NOT NULL,
  `zone_name` VARCHAR(100) NOT NULL,
  `points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`, `zone_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_meta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL DEFAULT 1,
  `last_reset` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_seasons` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `ended_date` DATETIME NOT NULL,
  `winner_identifier` VARCHAR(60) DEFAULT NULL,
  `winner_name` VARCHAR(100) DEFAULT NULL,
  `winner_score` INT DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_season_archive` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `kills` INT DEFAULT 0,
  `deaths` INT DEFAULT 0,
  `gang_points` INT DEFAULT 0,
  `top5_count` INT DEFAULT 0,
  `score` INT DEFAULT 0,
  `rank_position` INT DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_gang_stats` (
  `gang_name` VARCHAR(50) NOT NULL,
  `points` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`gang_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `capture_gang_season_archive` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `gang_name` VARCHAR(50) NOT NULL,
  `points` INT DEFAULT 0,
  `rank_position` INT DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If upgrading an existing capture_seasons table, run these once:
-- ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_name VARCHAR(50) DEFAULT NULL;
-- ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_points INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS `capture_playoffs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `match_label` VARCHAR(50) NOT NULL,
  `gang_a` VARCHAR(50) DEFAULT NULL,
  `gang_b` VARCHAR(50) DEFAULT NULL,
  `winner` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If upgrading an existing capture_seasons table for League Mode, run this once:
-- ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_name VARCHAR(50) DEFAULT NULL;
-- ALTER TABLE capture_seasons ADD COLUMN IF NOT EXISTS winner_gang_points INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS `capture_scarce_medals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season_number` INT NOT NULL,
  `serial_number` INT NOT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `awarded_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `season_serial` (`season_number`, `serial_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If upgrading an existing capture_player_stats table for the Scarcity Engine, run this once:
-- ALTER TABLE capture_player_stats ADD COLUMN IF NOT EXISTS last_rank VARCHAR(20) DEFAULT 'Bronze';

CREATE TABLE IF NOT EXISTS `capture_hall_of_fame` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `career_kills` INT DEFAULT 0,
  `career_gang_points` INT DEFAULT 0,
  `final_rank` VARCHAR(20) DEFAULT NULL,
  `inducted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_unique` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If upgrading an existing capture_player_stats table for the Hall of Fame, run this once:
-- ALTER TABLE capture_player_stats ADD COLUMN IF NOT EXISTS last_active DATETIME DEFAULT NULL;

CREATE TABLE IF NOT EXISTS `capture_academy_stats` (
  `identifier` VARCHAR(60) NOT NULL,
  `name` VARCHAR(100) DEFAULT NULL,
  `kills` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
