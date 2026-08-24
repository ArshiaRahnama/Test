-- Run this once against your database before starting the updated
-- Unique_AdminMenu. Uses `banlist` / `banlisthistory` (already in your
-- database.sql) for bans - no new table needed for those.

CREATE TABLE IF NOT EXISTS `admin_warnings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL,
  `playername` VARCHAR(100) DEFAULT NULL,
  `admin_identifier` VARCHAR(60) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `admin_saved_locations` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `x` FLOAT NOT NULL,
  `y` FLOAT NOT NULL,
  `z` FLOAT NOT NULL,
  `created_by` VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Notes: persistent, shared between all admins.
CREATE TABLE IF NOT EXISTS `admin_player_notes` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL,
  `note` VARCHAR(500) NOT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Action History: every admin action, persisted so it can be looked up per
-- target player later (also still printed/webhooked live via LogAdminAction).
CREATE TABLE IF NOT EXISTS `admin_action_log` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `admin_identifier` VARCHAR(60) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `target_identifier` VARCHAR(60) DEFAULT NULL,
  `target_name` VARCHAR(100) DEFAULT NULL,
  `action` VARCHAR(100) NOT NULL,
  `details` VARCHAR(500) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`target_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Multi-Account Detector: every (identifier, ip) pair ever seen, so a new
-- login can be checked against who else has connected from the same IP.
CREATE TABLE IF NOT EXISTS `admin_ip_log` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL,
  `license` VARCHAR(60) DEFAULT NULL,
  `discord` VARCHAR(60) DEFAULT NULL,
  `ip` VARCHAR(64) NOT NULL,
  `playername` VARCHAR(100) DEFAULT NULL,
  `last_seen` DATETIME DEFAULT NULL,
  UNIQUE KEY `identifier_ip` (`identifier`, `ip`),
  INDEX (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
