CREATE TABLE IF NOT EXISTS `uniqueac_admin` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_admin_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_banlist` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `PLAYER_NAME` varchar(128) DEFAULT NULL,
  `STEAM` varchar(128) NOT NULL DEFAULT '__NONE__',
  `DISCORD` varchar(64) NOT NULL DEFAULT '__NONE__',
  `LICENSE` varchar(128) NOT NULL DEFAULT '__NONE__',
  `LIVE` varchar(128) NOT NULL DEFAULT '__NONE__',
  `XBL` varchar(128) NOT NULL DEFAULT '__NONE__',
  `IP` varchar(64) NOT NULL DEFAULT '__NONE__',
  `TOKENS` longtext NOT NULL,
  `BANID` bigint unsigned NOT NULL,
  `REASON` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_banid` (`BANID`),
  KEY `idx_uniqueac_license` (`LICENSE`),
  KEY `idx_uniqueac_discord` (`DISCORD`),
  KEY `idx_uniqueac_ip` (`IP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_unban` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_unban_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_whitelist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_whitelist_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_trust` (
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `trust_score` int NOT NULL DEFAULT 100,
  `risk_score` int NOT NULL DEFAULT 0,
  `flag_count` int unsigned NOT NULL DEFAULT 0,
  `quarantine_count` int unsigned NOT NULL DEFAULT 0,
  `reconnect_count` int unsigned NOT NULL DEFAULT 0,
  `last_reconnect_at` bigint unsigned NOT NULL DEFAULT 0,
  `first_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_notes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `target_identifier` varchar(128) NOT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `author_identifier` varchar(128) DEFAULT NULL,
  `author_name` varchar(128) DEFAULT NULL,
  `note` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_notes_target` (`target_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_admin_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `admin_identifier` varchar(128) DEFAULT NULL,
  `admin_name` varchar(128) DEFAULT NULL,
  `action` varchar(64) NOT NULL,
  `target_identifier` varchar(128) DEFAULT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `reason` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_adminlog_admin` (`admin_identifier`),
  KEY `idx_uniqueac_adminlog_target` (`target_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_detections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `reason` varchar(128) NOT NULL,
  `details` text,
  `action` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_detections_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `uniqueac_appeals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `ban_id` bigint unsigned DEFAULT NULL,
  `message` text NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `reviewed_by` varchar(128) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_appeals_identifier` (`identifier`),
  KEY `idx_uniqueac_appeals_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
