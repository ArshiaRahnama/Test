-- ============================================================
-- Self-healing database migrations
-- Runs once at resource start, synchronously (this is a one-time
-- startup task, not per-request, so blocking briefly here is fine
-- and guarantees every table/column exists before any other file's
-- event handlers can possibly run a query against them).
--
-- Creates every table this resource needs (idempotent -- CREATE
-- TABLE IF NOT EXISTS is always safe to rerun) and upgrades any
-- EXISTING table with columns that were added in a later version,
-- by checking information_schema before each ALTER. This is what
-- the various *.sql files in this resource's root/cad/sql used to
-- require running by hand -- doing it here means a missed manual
-- step can never again cause the "Unknown column" / "Table doesn't
-- exist" runtime errors this resource has hit before. The .sql
-- files are kept as documentation of the schema, but are no longer
-- required reading to deploy.
-- ============================================================

local function ColumnExists(tableName, columnName)
	local count = MySQL.Sync.fetchScalar(
		"SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = @t AND column_name = @c",
		{ ['@t'] = tableName, ['@c'] = columnName }
	)
	return count and count > 0
end

-- Adds a column only if it isn't already there. Safe to call every
-- resource start regardless of which version of the table someone's
-- database currently has.
local function EnsureColumn(tableName, columnName, columnDef)
	if ColumnExists(tableName, columnName) then return end

	MySQL.Sync.execute('ALTER TABLE `' .. tableName .. '` ADD COLUMN ' .. columnDef, {})
	print('[esx_uniquejobs] Migrated: added `' .. columnName .. '` to `' .. tableName .. '`')
end

CreateThread(function()
	-- ============================================================
	-- Base tables -- safe to (re)run every start, never touches
	-- existing rows
	-- ============================================================

	local createStatements = {
		[[CREATE TABLE IF NOT EXISTS `criminal_records` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`identifier` VARCHAR(255) NOT NULL,
			`type` VARCHAR(20) NOT NULL,
			`reason` VARCHAR(255) NOT NULL,
			`officer_name` VARCHAR(255) NOT NULL,
			`officer_identifier` VARCHAR(255) NOT NULL,
			`jail_time` INT(11) DEFAULT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `identifier` (`identifier`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `doa_seizures` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`item_label` VARCHAR(255) NOT NULL,
			`quantity` INT(11) NOT NULL,
			`est_value` INT(11) NOT NULL,
			`suspect_identifier` VARCHAR(255) DEFAULT NULL,
			`suspect_name` VARCHAR(255) DEFAULT NULL,
			`officer_name` VARCHAR(255) NOT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `doa_informants` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`identifier` VARCHAR(255) NOT NULL,
			`codename` VARCHAR(255) NOT NULL,
			`registered_by` VARCHAR(255) NOT NULL,
			`total_paid` INT(11) NOT NULL DEFAULT 0,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			UNIQUE KEY `identifier` (`identifier`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `doa_tips` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`informant_id` INT(11) NOT NULL,
			`tip_text` VARCHAR(500) NOT NULL,
			`logged_by` VARCHAR(255) NOT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `informant_id` (`informant_id`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `law_codebook` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`code` VARCHAR(20) NOT NULL,
			`title` VARCHAR(255) NOT NULL,
			`category` VARCHAR(20) NOT NULL DEFAULT 'other',
			`fine` INT(11) NOT NULL DEFAULT 0,
			`jail_minutes` INT(11) NOT NULL DEFAULT 0,
			`updated_by` VARCHAR(255) DEFAULT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`)
		)]],

		-- dept_* (not doj_*): the /doj menu's own simpler case system.
		-- Deliberately named differently from crimescene's doj_cases/
		-- doj_case_notes/doj_case_suspects below -- both independently
		-- used the doj_ prefix with incompatible schemas; these were
		-- renamed to avoid the collision. The two case systems are
		-- separate and don't share data.
		[[CREATE TABLE IF NOT EXISTS `dept_cases` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`title` VARCHAR(255) NOT NULL,
			`status` VARCHAR(20) NOT NULL DEFAULT 'open',
			`priority` VARCHAR(10) NOT NULL DEFAULT 'medium',
			`opened_by_name` VARCHAR(255) NOT NULL,
			`opened_by_job` VARCHAR(20) NOT NULL,
			`lead_officer_name` VARCHAR(255) NOT NULL,
			`referred_to` VARCHAR(20) DEFAULT NULL,
			`created_at` INT(11) NOT NULL,
			`updated_at` INT(11) NOT NULL,
			PRIMARY KEY (`id`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `dept_case_suspects` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`case_id` INT(11) NOT NULL,
			`identifier` VARCHAR(255) DEFAULT NULL,
			`name` VARCHAR(255) NOT NULL,
			`added_by` VARCHAR(255) NOT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `case_id` (`case_id`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `dept_case_notes` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`case_id` INT(11) NOT NULL,
			`note_type` VARCHAR(20) NOT NULL DEFAULT 'note',
			`text` VARCHAR(500) NOT NULL,
			`by_name` VARCHAR(255) NOT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `case_id` (`case_id`)
		)]],

		[[CREATE TABLE IF NOT EXISTS `dept_case_charges` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`case_id` INT(11) NOT NULL,
			`law_code` VARCHAR(20) NOT NULL,
			`law_title` VARCHAR(255) NOT NULL,
			`fine` INT(11) NOT NULL,
			`jail_minutes` INT(11) NOT NULL,
			`added_by` VARCHAR(255) NOT NULL,
			`timestamp` INT(11) NOT NULL,
			PRIMARY KEY (`id`),
			KEY `case_id` (`case_id`)
		)]],

		-- crimescene/cad's own case system (doj_* prefix, kept as-is --
		-- this is the one actually wired into /cad, robberies, BOLOs, etc.)
		[[CREATE TABLE IF NOT EXISTS `doj_cases` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`rob_name` VARCHAR(64) NOT NULL,
			`rob_family` VARCHAR(64) NOT NULL,
			`status` VARCHAR(32) NOT NULL DEFAULT 'open',
			`suspect_identifier` VARCHAR(64) DEFAULT NULL,
			`suspect_name` VARCHAR(64) DEFAULT NULL,
			`warrant_status` VARCHAR(16) NOT NULL DEFAULT 'none',
			`warrant_requested_by` VARCHAR(64) DEFAULT NULL,
			`warrant_decided_by` VARCHAR(64) DEFAULT NULL,
			`closed_by_name` VARCHAR(64) DEFAULT NULL,
			`archived_at` DATETIME DEFAULT NULL,
			`coords_x` FLOAT DEFAULT NULL,
			`coords_y` FLOAT DEFAULT NULL,
			`coords_z` FLOAT DEFAULT NULL,
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			KEY `idx_status` (`status`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],

		[[CREATE TABLE IF NOT EXISTS `doj_case_evidence` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`case_id` INT NOT NULL,
			`type` VARCHAR(32) NOT NULL,
			`content` TEXT NOT NULL,
			`suspect_hint_id` VARCHAR(6) DEFAULT NULL,
			`plate` VARCHAR(10) DEFAULT NULL,
			`found_by` VARCHAR(64) DEFAULT NULL,
			`found_by_name` VARCHAR(64) DEFAULT NULL,
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			KEY `idx_case_id` (`case_id`),
			KEY `idx_hint_id` (`suspect_hint_id`),
			KEY `idx_plate` (`plate`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],

		[[CREATE TABLE IF NOT EXISTS `doj_case_notes` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`case_id` INT NOT NULL,
			`author` VARCHAR(64) DEFAULT NULL,
			`author_name` VARCHAR(64) DEFAULT NULL,
			`note` TEXT NOT NULL,
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			KEY `idx_case_id` (`case_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],

		[[CREATE TABLE IF NOT EXISTS `doj_criminal_records` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`case_id` INT DEFAULT NULL,
			`suspect_identifier` VARCHAR(64) DEFAULT NULL,
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
			KEY `idx_suspect_identifier` (`suspect_identifier`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],

		[[CREATE TABLE IF NOT EXISTS `doj_case_suspects` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`case_id` INT NOT NULL,
			`suspect_identifier` VARCHAR(64) DEFAULT NULL,
			`suspect_name` VARCHAR(64) DEFAULT NULL,
			`role` VARCHAR(16) NOT NULL DEFAULT 'accomplice',
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			KEY `idx_case_id` (`case_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],

		[[CREATE TABLE IF NOT EXISTS `doj_ia_reports` (
			`id` INT NOT NULL AUTO_INCREMENT,
			`target_identifier` VARCHAR(64) DEFAULT NULL,
			`target_name` VARCHAR(64) NOT NULL,
			`target_job` VARCHAR(32) DEFAULT NULL,
			`category` VARCHAR(32) NOT NULL DEFAULT 'other',
			`description` TEXT NOT NULL,
			`filed_by` VARCHAR(64) DEFAULT NULL,
			`filed_by_name` VARCHAR(64) DEFAULT NULL,
			`status` VARCHAR(16) NOT NULL DEFAULT 'open',
			`verdict` TEXT DEFAULT NULL,
			`reviewed_by_name` VARCHAR(64) DEFAULT NULL,
			`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
			`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`),
			KEY `idx_target_identifier` (`target_identifier`),
			KEY `idx_status` (`status`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
	}

	for _, sql in ipairs(createStatements) do
		MySQL.Sync.execute(sql, {})
	end

	-- ============================================================
	-- Column-level upgrades for tables that existed before these
	-- columns were added -- this is exactly the gap that caused the
	-- "Unknown column 'archived_at'" / missing-table errors.
	-- ============================================================

	EnsureColumn('doj_cases', 'warrant_status', "`warrant_status` VARCHAR(16) NOT NULL DEFAULT 'none' AFTER `suspect_name`")
	EnsureColumn('doj_cases', 'warrant_requested_by', "`warrant_requested_by` VARCHAR(64) DEFAULT NULL AFTER `warrant_status`")
	EnsureColumn('doj_cases', 'warrant_decided_by', "`warrant_decided_by` VARCHAR(64) DEFAULT NULL AFTER `warrant_requested_by`")
	EnsureColumn('doj_cases', 'closed_by_name', "`closed_by_name` VARCHAR(64) DEFAULT NULL AFTER `warrant_decided_by`")
	EnsureColumn('doj_cases', 'archived_at', "`archived_at` DATETIME DEFAULT NULL AFTER `closed_by_name`")
	EnsureColumn('doj_case_evidence', 'plate', "`plate` VARCHAR(10) DEFAULT NULL AFTER `suspect_hint_id`")
	EnsureColumn('doj_criminal_records', 'suspect_identifier', "`suspect_identifier` VARCHAR(64) DEFAULT NULL AFTER `case_id`")

	print('[esx_uniquejobs] Database migrations checked -- all tables/columns present.')
end)
