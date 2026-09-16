-- ================================================================
--  esx_inventory — security layer schema  (features #17-#22)
--  Safe to run on a live DB: every statement is IF NOT EXISTS /
--  additive. Nothing here drops or alters existing data.
-- ================================================================

-- ── #19 anomaly + #17/#20/#21 integrity: the review queue ─────────
-- This is the table a human actually looks at. Deliberately NOT
-- auto-acted on: every heuristic upstream has a legitimate scenario
-- that can trip it, so these are reports, not punishments.
CREATE TABLE IF NOT EXISTS `inv_security_flags` (
  `id`         INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80) NOT NULL,
  `kind`       VARCHAR(80) NOT NULL,
  `detail`     TEXT DEFAULT NULL,
  `reviewed`   TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_identifier` (`identifier`),
  KEY `idx_created`    (`created_at`),
  KEY `idx_reviewed`   (`reviewed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ── #7 chain of custody ───────────────────────────────────────────
-- Append-only ownership ledger, one row per time a serial changes
-- hands. `via` records HOW it moved (give / drop / pickup / loot /
-- shop / admin / corpse), which is what makes the history actually
-- readable as a story rather than a list of names.
--
-- NOTE: serial is indexed but NOT unique — the whole point is many
-- rows per serial.
CREATE TABLE IF NOT EXISTS `inv_weapon_history` (
  `id`          INT(11) NOT NULL AUTO_INCREMENT,
  `serial`      VARCHAR(40) NOT NULL,
  `weapon`      VARCHAR(60) NOT NULL,
  `from_ident`  VARCHAR(80) DEFAULT NULL,
  `to_ident`    VARCHAR(80) DEFAULT NULL,
  `from_name`   VARCHAR(80) DEFAULT NULL,
  `to_name`     VARCHAR(80) DEFAULT NULL,
  `via`         VARCHAR(30) NOT NULL DEFAULT 'unknown',
  `created_at`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_serial`  (`serial`),
  KEY `idx_to`      (`to_ident`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ── #8 stolen weapon register ─────────────────────────────────────
-- One row per serial. `status` is 'stolen' | 'recovered' | 'cleared'.
-- A police scan (#8 / the existing scanWeapon event) joins against
-- this, which is exactly why the serial had to stay plaintext and
-- indexable rather than being encrypted.
CREATE TABLE IF NOT EXISTS `inv_stolen_weapons` (
  `serial`        VARCHAR(40) NOT NULL,
  `weapon`        VARCHAR(60) DEFAULT NULL,
  `reported_by`   VARCHAR(80) DEFAULT NULL,
  `reported_name` VARCHAR(80) DEFAULT NULL,
  `note`          VARCHAR(255) DEFAULT NULL,
  `status`        VARCHAR(20) NOT NULL DEFAULT 'stolen',
  `reported_at`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_at`   DATETIME DEFAULT NULL,
  `resolved_by`   VARCHAR(80) DEFAULT NULL,
  PRIMARY KEY (`serial`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ── #5 per-item custom descriptions ───────────────────────────────
-- Scoped by owner so two players engraving the same item name don't
-- overwrite each other. `slot_key` distinguishes individual weapon
-- serials / clothing rows from plain stackable items.
CREATE TABLE IF NOT EXISTS `inv_item_notes` (
  `id`         INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(80) NOT NULL,
  `slot_key`   VARCHAR(120) NOT NULL,
  `note`       VARCHAR(255) DEFAULT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_owner_slot` (`identifier`, `slot_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;
