-- Run this once against your database (essentialmode) before using the
-- new Codebook editing (judge) and the expanded Case system in /doj and /law.
-- NOTE: the case tables here (dept_cases, dept_case_suspects,
-- dept_case_notes, dept_case_charges) are intentionally named differently
-- from crimescene/cad's own doj_cases/doj_case_suspects/doj_case_notes --
-- both systems independently used the "doj_" prefix for a case system with
-- a different schema; these were renamed to dept_* to avoid a collision.
-- The two case systems are separate and don't share data.

CREATE TABLE IF NOT EXISTS `law_codebook` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`code` VARCHAR(20) NOT NULL,
	`title` VARCHAR(255) NOT NULL,
	`category` VARCHAR(20) NOT NULL DEFAULT 'other',
	`fine` INT(11) NOT NULL DEFAULT 0,
	`jail_minutes` INT(11) NOT NULL DEFAULT 0,
	`updated_by` VARCHAR(255) DEFAULT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `dept_cases` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`status` VARCHAR(20) NOT NULL DEFAULT 'open', -- open, investigating, trial, closed, dismissed
	`priority` VARCHAR(10) NOT NULL DEFAULT 'medium', -- low, medium, high
	`opened_by_name` VARCHAR(255) NOT NULL,
	`opened_by_job` VARCHAR(20) NOT NULL,
	`lead_officer_name` VARCHAR(255) NOT NULL,
	`referred_to` VARCHAR(20) DEFAULT NULL,
	`created_at` INT(11) NOT NULL,
	`updated_at` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `dept_case_suspects` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`case_id` INT(11) NOT NULL,
	`identifier` VARCHAR(255) DEFAULT NULL,
	`name` VARCHAR(255) NOT NULL,
	`added_by` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `case_id` (`case_id`)
);

CREATE TABLE IF NOT EXISTS `dept_case_notes` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`case_id` INT(11) NOT NULL,
	`note_type` VARCHAR(20) NOT NULL DEFAULT 'note', -- note, evidence
	`text` VARCHAR(500) NOT NULL,
	`by_name` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `case_id` (`case_id`)
);

CREATE TABLE IF NOT EXISTS `dept_case_charges` (
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
);
