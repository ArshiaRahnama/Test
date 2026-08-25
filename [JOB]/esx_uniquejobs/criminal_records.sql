-- Run this once against your database (essentialmode) before using the
-- Criminal Background Check option in the /agent menu.
-- Powers: how many times a player has been arrested, the reasons, which
-- officer logged it, and (combined with the existing `billing` table) how
-- much they currently owe in unpaid fines.

CREATE TABLE IF NOT EXISTS `criminal_records` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(255) NOT NULL,
	`type` VARCHAR(20) NOT NULL,          -- 'arrest' or 'charge'
	`reason` VARCHAR(255) NOT NULL,
	`officer_name` VARCHAR(255) NOT NULL,
	`officer_identifier` VARCHAR(255) NOT NULL,
	`jail_time` INT(11) DEFAULT NULL,     -- minutes, only set for 'arrest' rows
	`timestamp` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `identifier` (`identifier`)
);
