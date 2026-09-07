-- NOTE: kept only as human-readable schema documentation. This table
-- and column are now created/added automatically on resource start
-- by server/db_migrations.lua -- you do NOT need to run this file by
-- hand for a normal install/update.
--
-- Run this once, after dept_features_ext.sql.
-- Adds:
--   - dept_evidence_custody : hand-off log for individual evidence items
--                             (dept_case_notes rows where note_type='evidence')
--   - dept_traffic_stops.location : street name captured automatically at the
--                             time of the stop, used as "last known location"
--                             on the Rap Sheet

CREATE TABLE IF NOT EXISTS `dept_evidence_custody` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`note_id` INT(11) NOT NULL,     -- dept_case_notes.id (the evidence row being handed off)
	`case_id` INT(11) NOT NULL,
	`from_name` VARCHAR(255) NOT NULL,
	`from_job` VARCHAR(20) NOT NULL,
	`to_name` VARCHAR(255) NOT NULL,
	`to_job` VARCHAR(20) NOT NULL,
	`reason` VARCHAR(255) DEFAULT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `note_id` (`note_id`),
	KEY `case_id` (`case_id`)
);

ALTER TABLE `dept_traffic_stops` ADD COLUMN IF NOT EXISTS `location` VARCHAR(255) DEFAULT NULL;
