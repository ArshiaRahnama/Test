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

-- Persistent duty log: one row per on-duty session, with a real start/end
-- timestamp. This is separate from (and outlives) the in-memory
-- DutySessionStart used for the live Staff Dashboard - restarting the
-- resource or the player relogging doesn't lose this history.
CREATE TABLE IF NOT EXISTS `admin_duty` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) DEFAULT NULL,
  `identifier` VARCHAR(60) NOT NULL,
  `date` VARCHAR(20) DEFAULT NULL,
  `onduty` INT NOT NULL,
  `offduty` INT DEFAULT NULL,
  `totaltime` INT DEFAULT NULL COMMENT 'minutes',
  INDEX (`identifier`),
  INDEX (`offduty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Persistent player flags: unlike admin_player_notes (only shown when you
-- Inspect someone), a flag actively reminds every on-duty admin in chat
-- every few seconds for as long as the flagged player is online.
CREATE TABLE IF NOT EXISTS `admin_player_flags` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) NOT NULL UNIQUE,
  `note` VARCHAR(255) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Periodic economy snapshots for the Dashboard's economy-health chart.
CREATE TABLE IF NOT EXISTS `admin_economy_snapshots` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `taken_at` INT NOT NULL,
  `total_cash` BIGINT NOT NULL DEFAULT 0,
  `total_bank` BIGINT NOT NULL DEFAULT 0,
  `player_count` INT NOT NULL DEFAULT 0,
  INDEX (`taken_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-button minimum permission_level overrides (see AButton() in
-- client/general_utils.lua). Missing rows fall back to
-- Config.MinPermissionLevel, same as every other tool in this resource.
CREATE TABLE IF NOT EXISTS `admin_button_perms` (
  `button_id` VARCHAR(80) NOT NULL PRIMARY KEY,
  `min_level` INT NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reporter satisfaction ratings, collected right after a report is closed
-- (see the TriggerEvent added to esx_aduty/Server/ReportMenu_sv.lua's `cr`
-- command). rating: 1=unsatisfied, 2=neutral, 3=satisfied.
CREATE TABLE IF NOT EXISTS `admin_report_ratings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `report_id` VARCHAR(20) DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `rating` TINYINT NOT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`admin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Per-admin report response times (open -> close), fed by the same
-- esx_aduty `cr` command hook as admin_report_ratings above.
CREATE TABLE IF NOT EXISTS `admin_report_response_times` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `response_seconds` INT NOT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`admin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Persistent per-player chat archive (the existing in-memory ChatLog in
-- server/admin_tools.lua only keeps the last 500 messages server-wide and
-- resets on restart - too small/short-lived for "search one player's full
-- history"). Fed by the same chatMessage event, just also written here.
CREATE TABLE IF NOT EXISTS `admin_chat_archive` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(60) DEFAULT NULL,
  `playername` VARCHAR(100) DEFAULT NULL,
  `message` VARCHAR(500) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL,
  INDEX (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Impound yard: a real log of every impound (plate/model/reason/date),
-- separate from the vehicle actually being deleted client-side, with a
-- release button that restores it to the owner's garage (owned_vehicles).
CREATE TABLE IF NOT EXISTS `admin_impound_yard` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `plate` VARCHAR(12) DEFAULT NULL,
  `model_label` VARCHAR(60) DEFAULT NULL,
  `owner_identifier` VARCHAR(60) DEFAULT NULL,
  `owner_name` VARCHAR(100) DEFAULT NULL,
  `impounded_by` VARCHAR(100) DEFAULT NULL,
  `reason` VARCHAR(255) DEFAULT NULL,
  `impounded_at` DATETIME DEFAULT NULL,
  `released` TINYINT(1) NOT NULL DEFAULT 0,
  `released_at` DATETIME DEFAULT NULL,
  `released_by` VARCHAR(100) DEFAULT NULL,
  INDEX (`plate`),
  INDEX (`owner_identifier`),
  INDEX (`released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Snapshot of the destination account's `users` row right before a
-- character transfer overwrites it, so a bad transfer is reversible.
CREATE TABLE IF NOT EXISTS `admin_transfer_backups` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `source_identifier` VARCHAR(60) DEFAULT NULL,
  `dest_identifier` VARCHAR(60) DEFAULT NULL,
  `dest_snapshot_json` LONGTEXT DEFAULT NULL,
  `admin_name` VARCHAR(100) DEFAULT NULL,
  `created_at` DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Periodic faction/society treasury snapshots (addon_account_data), used
-- for the audit panel's history view and spike detection.
CREATE TABLE IF NOT EXISTS `admin_faction_snapshots` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `account_name` VARCHAR(100) DEFAULT NULL,
  `balance` INT NOT NULL DEFAULT 0,
  `taken_at` INT NOT NULL,
  INDEX (`account_name`),
  INDEX (`taken_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
