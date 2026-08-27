-- Run this once against your database (essentialmode) before using the
-- Seizure Log and Informant Management options in the /doj menu (DOA).

CREATE TABLE IF NOT EXISTS `doa_seizures` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`item_label` VARCHAR(255) NOT NULL,
	`quantity` INT(11) NOT NULL,
	`est_value` INT(11) NOT NULL,
	`suspect_identifier` VARCHAR(255) DEFAULT NULL,
	`suspect_name` VARCHAR(255) DEFAULT NULL,
	`officer_name` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `doa_informants` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(255) NOT NULL,
	`codename` VARCHAR(255) NOT NULL,
	`registered_by` VARCHAR(255) NOT NULL,
	`total_paid` INT(11) NOT NULL DEFAULT 0,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `identifier` (`identifier`)
);

CREATE TABLE IF NOT EXISTS `doa_tips` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`informant_id` INT(11) NOT NULL,
	`tip_text` VARCHAR(500) NOT NULL,
	`logged_by` VARCHAR(255) NOT NULL,
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `informant_id` (`informant_id`)
);
