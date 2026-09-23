-- ===========================================================================
--  Unique RP - Ticket System | sql/tickets.sql
--  arshiahub.ir
--
--  Run once against the essentialmode database. Mirrors the conventions of
--  sql/reports.sql (same DB, same InnoDB/utf8mb4 settings, same style of
--  IF NOT EXISTS + idempotent ALTERs so re-running this file is harmless).
-- ===========================================================================

-- ----------------------------------------------------------------- tickets ---
CREATE TABLE IF NOT EXISTS `tickets` (
  `id`                BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `title`             VARCHAR(255) DEFAULT NULL,
  `category`          VARCHAR(32)  DEFAULT 'other',
  `priority`          TINYINT(2)   DEFAULT 1,
  `status`            VARCHAR(16)  DEFAULT 'open',        -- open | in_progress | closed
  `creator_identifier` VARCHAR(64) DEFAULT NULL,
  `creator_name`      VARCHAR(128) DEFAULT NULL,
  `source_report_id`  BIGINT(20)   DEFAULT NULL,          -- set when created from an existing player report
  `created_at`        INT(11)      DEFAULT 0,
  `updated_at`        INT(11)      DEFAULT 0,
  `closed_at`         INT(11)      DEFAULT 0,
  `closed_by`         VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status`   (`status`),
  KEY `idx_creator`  (`creator_identifier`),
  KEY `idx_report`   (`source_report_id`),
  KEY `idx_created`  (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------ ticket_participants ---
-- Players attached to a ticket (the reporter, the reported player, witnesses,
-- anyone an admin adds). Many-to-many on purpose - a ticket can involve more
-- than one player, and a player can be on more than one open ticket.
CREATE TABLE IF NOT EXISTS `ticket_participants` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `ticket_id`  BIGINT(20)   NOT NULL,
  `identifier` VARCHAR(64)  DEFAULT NULL,
  `name`       VARCHAR(128) DEFAULT NULL,
  `role`       VARCHAR(16)  DEFAULT 'involved',   -- creator | reported | involved
  `added_by`   VARCHAR(128) DEFAULT NULL,
  `added_at`   INT(11)      DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_ticket_player` (`ticket_id`, `identifier`),
  KEY `idx_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------------- ticket_admins ---
-- Admins assigned/managing a ticket. Also many-to-many: more than one admin
-- can work a ticket together (handoffs, escalation), and an admin can be on
-- more than one ticket at once.
CREATE TABLE IF NOT EXISTS `ticket_admins` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `ticket_id`  BIGINT(20)   NOT NULL,
  `identifier` VARCHAR(64)  DEFAULT NULL,
  `name`       VARCHAR(128) DEFAULT NULL,
  `assigned_by` VARCHAR(128) DEFAULT NULL,
  `assigned_at` INT(11)     DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_ticket_admin` (`ticket_id`, `identifier`),
  KEY `idx_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------- ticket_messages ---
CREATE TABLE IF NOT EXISTS `ticket_messages` (
  `id`         BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `ticket_id`  BIGINT(20)   NOT NULL,
  `identifier` VARCHAR(64)  DEFAULT NULL,
  `name`       VARCHAR(128) DEFAULT NULL,
  `is_admin`   TINYINT(1)   DEFAULT 0,
  `is_system`  TINYINT(1)   DEFAULT 0,   -- automated log lines (status changes, assignments, ...)
  `message`    TEXT         DEFAULT NULL,
  `created_at` INT(11)      DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_ticket_created` (`ticket_id`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
