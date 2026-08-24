-- Run this once against your server's database before starting Unique_CrimeScene.

CREATE TABLE IF NOT EXISTS `doj_cases` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rob_name` VARCHAR(64) NOT NULL,
  `rob_family` VARCHAR(64) NOT NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'open', -- open | cold | referred_judge | referred_cia | referred_fbi | closed
  `suspect_identifier` VARCHAR(64) DEFAULT NULL, -- internal only, never shown as-is to players
  `suspect_name` VARCHAR(64) DEFAULT NULL,
  `warrant_status` VARCHAR(16) NOT NULL DEFAULT 'none', -- none | requested | approved | denied
  `warrant_requested_by` VARCHAR(64) DEFAULT NULL,
  `warrant_decided_by` VARCHAR(64) DEFAULT NULL,
  `closed_by_name` VARCHAR(64) DEFAULT NULL,
  `coords_x` FLOAT DEFAULT NULL,
  `coords_y` FLOAT DEFAULT NULL,
  `coords_z` FLOAT DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `doj_case_evidence` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `case_id` INT NOT NULL,
  `type` VARCHAR(32) NOT NULL, -- hint | vehicle | strong_lead
  `content` TEXT NOT NULL,
  `suspect_hint_id` VARCHAR(6) DEFAULT NULL, -- only set on strong_lead rows, used for wanted-board / fingerprint matching
  `plate` VARCHAR(10) DEFAULT NULL, -- only set on vehicle rows, used for BOLOs
  `found_by` VARCHAR(64) DEFAULT NULL,
  `found_by_name` VARCHAR(64) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_case_id` (`case_id`),
  KEY `idx_hint_id` (`suspect_hint_id`),
  KEY `idx_plate` (`plate`),
  CONSTRAINT `fk_evidence_case` FOREIGN KEY (`case_id`) REFERENCES `doj_cases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `doj_case_notes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `case_id` INT NOT NULL,
  `author` VARCHAR(64) DEFAULT NULL,
  `author_name` VARCHAR(64) DEFAULT NULL,
  `note` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_case_id` (`case_id`),
  CONSTRAINT `fk_notes_case` FOREIGN KEY (`case_id`) REFERENCES `doj_cases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `doj_criminal_records` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `case_id` INT DEFAULT NULL, -- optional link back to the investigation, NULL for a caught-red-handed arrest
  `suspect_identifier` VARCHAR(64) DEFAULT NULL, -- set only when the arrest was linked to an online player, used to sync Unique_Cad
  `suspect_name` VARCHAR(64) NOT NULL,
  `charges` TEXT NOT NULL,
  `fine` INT NOT NULL DEFAULT 0,
  `jail_minutes` INT NOT NULL DEFAULT 0,
  `booked_by` VARCHAR(64) DEFAULT NULL,
  `booked_by_name` VARCHAR(64) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_case_id` (`case_id`),
  KEY `idx_suspect_name` (`suspect_name`),
  CONSTRAINT `fk_records_case` FOREIGN KEY (`case_id`) REFERENCES `doj_cases` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If you already ran an earlier version of this file (without the `plate`
-- column on doj_case_evidence), run this once to upgrade instead of
-- dropping/recreating the table:
-- ALTER TABLE `doj_case_evidence` ADD COLUMN `plate` VARCHAR(10) DEFAULT NULL AFTER `suspect_hint_id`;
-- ALTER TABLE `doj_case_evidence` ADD KEY `idx_plate` (`plate`);

-- If you already ran an earlier version of this file (without the warrant /
-- closed_by columns on doj_cases, or the doj_criminal_records table), run
-- this once to upgrade instead of dropping/recreating anything:
-- ALTER TABLE `doj_cases` ADD COLUMN `warrant_status` VARCHAR(16) NOT NULL DEFAULT 'none' AFTER `suspect_name`;
-- ALTER TABLE `doj_cases` ADD COLUMN `warrant_requested_by` VARCHAR(64) DEFAULT NULL AFTER `warrant_status`;
-- ALTER TABLE `doj_cases` ADD COLUMN `warrant_decided_by` VARCHAR(64) DEFAULT NULL AFTER `warrant_requested_by`;
-- ALTER TABLE `doj_cases` ADD COLUMN `closed_by_name` VARCHAR(64) DEFAULT NULL AFTER `warrant_decided_by`;
-- (then run the CREATE TABLE doj_criminal_records statement above by itself)

-- If you already ran an earlier version without `suspect_identifier` on
-- doj_criminal_records (added for the Unique_Cad integration):
-- ALTER TABLE `doj_criminal_records` ADD COLUMN `suspect_identifier` VARCHAR(64) DEFAULT NULL AFTER `case_id`;
