-- Run this once against your database before starting the updated
-- Unique_AdminMenu.
--
-- NOTE on bans: the old `banlist`/`banlisthistory` tables below are NOT
-- checked anywhere at connect time (only `uniqueac_banlist`, owned by the
-- UNIQUE_AC resource, is - see Unique_Login/server.lua's playerConnecting).
-- /aban now calls exports.UNIQUE_AC:BanPlayer for permanent bans (real
-- enforcement) and this new `unique_adminmenu_bans` table for temp bans
-- (checked by our own playerConnecting handler below).

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

-- Temp bans issued from Unique_AdminMenu (`/aban <id> <minutes> <reason>`).
-- Permanent bans go through exports.UNIQUE_AC:BanPlayer instead (real
-- enforcement via uniqueac_banlist) and are only mirrored here (external_ban_id
-- set, expire_at NULL) so /aunban and ban-history search have one place to
-- look.
CREATE TABLE IF NOT EXISTS `unique_adminmenu_bans` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) DEFAULT NULL,
  `license` VARCHAR(60) DEFAULT NULL,
  `ip` VARCHAR(64) DEFAULT NULL,
  `playername` VARCHAR(100) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `banned_at` DATETIME DEFAULT NULL,
  `expire_at` INT DEFAULT NULL COMMENT 'unix timestamp, NULL = permanent',
  `external_ban_id` VARCHAR(60) DEFAULT NULL COMMENT 'UNIQUE_AC banId, only set for permanent bans',
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  INDEX (`identifier`),
  INDEX (`ip`),
  INDEX (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
