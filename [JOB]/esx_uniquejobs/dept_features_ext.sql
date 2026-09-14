-- NOTE: kept only as human-readable schema documentation. These
-- tables are now created automatically on resource start by
-- server/db_migrations.lua (same self-healing pattern the rest of
-- this resource already uses) -- you do NOT need to run this file
-- by hand for a normal install/update.
--
-- Run this once against your database, after law_and_cases.sql (dept_cases
-- must already exist). Adds tables for four new /doj + /law features:
--   - dept_case_docket  : court docket / hearing schedule + final verdicts (judge)
--   - dept_case_events  : unified case timeline log (status/priority/lead/refer/etc.)
--   - dept_traffic_stops: lightweight traffic-stop log (no full booking needed)
--   - dept_mugshots     : one photo/mugshot per citizen identifier

CREATE TABLE IF NOT EXISTS `dept_case_docket` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`case_id` INT(11) NOT NULL,
	`scheduled_at` INT(11) NOT NULL,               -- unix timestamp of the hearing
	`status` VARCHAR(20) NOT NULL DEFAULT 'scheduled', -- scheduled, held, rescheduled, cancelled
	`verdict` VARCHAR(20) DEFAULT NULL,            -- guilty, not_guilty, plea_deal
	`verdict_notes` VARCHAR(500) DEFAULT NULL,
	`verdict_by_name` VARCHAR(255) DEFAULT NULL,
	`verdict_at` INT(11) DEFAULT NULL,
	`created_by_name` VARCHAR(255) NOT NULL,
	`created_at` INT(11) NOT NULL,
	`updated_at` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `case_id` (`case_id`)
);

CREATE TABLE IF NOT EXISTS `dept_case_events` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`case_id` INT(11) NOT NULL,
	`event_type` VARCHAR(30) NOT NULL, -- suspect_added, note, evidence, charge, status, priority, lead, referred, docket, verdict
	`text` VARCHAR(500) NOT NULL,
	`by_name` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `case_id` (`case_id`)
);

CREATE TABLE IF NOT EXISTS `dept_traffic_stops` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`officer_identifier` VARCHAR(255) NOT NULL,
	`officer_name` VARCHAR(255) NOT NULL,
	`officer_job` VARCHAR(20) NOT NULL,
	`citizen_identifier` VARCHAR(255) DEFAULT NULL,
	`citizen_name` VARCHAR(255) NOT NULL,
	`reason` VARCHAR(255) NOT NULL,
	`outcome` VARCHAR(20) NOT NULL DEFAULT 'warning', -- warning, citation, search, escalated
	`notes` VARCHAR(500) DEFAULT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `officer_identifier` (`officer_identifier`),
	KEY `citizen_identifier` (`citizen_identifier`)
);

CREATE TABLE IF NOT EXISTS `dept_mugshots` (
	`identifier` VARCHAR(255) NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`photo_url` VARCHAR(500) NOT NULL,
	`taken_by_name` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`identifier`)
);
