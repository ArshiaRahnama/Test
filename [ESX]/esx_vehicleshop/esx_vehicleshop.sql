-- esx_vehicleshop database
-- Your `owned_vehicles` table already exists (essentialmode framework) with all the columns this
-- script needs (owner, plate, vehicle, type, job, stored, steamowned) — confirmed from your earlier
-- HeidiSQL screenshot. This file is safe to run: IF NOT EXISTS means it does nothing on a table
-- that's already there, and only actually creates it if you're setting this up on a fresh database.

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
	`owner` varchar(60) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NULL DEFAULT NULL,
	`stored` TINYINT(1) NOT NULL DEFAULT '0',
	`steamowned` varchar(60) DEFAULT NULL,
	PRIMARY KEY (`plate`)
);

-- Other tables this script reads/writes (cardealer_vehicles, rented_vehicles, vehicle_categories,
-- vehicle_sold, vehicles) all showed up in your database sidebar screenshot already, so nothing to
-- create there. If a specific feature errors with "table doesn't exist", tell me which one and
-- I'll add the matching CREATE TABLE for it.

-- One-time repair for vehicles already added before this fix (engine/fuel/body left at 0/NULL,
-- so they showed "no engine" and/or appeared impounded on retrieval). Safe to run more than once.
UPDATE `owned_vehicles` SET `engine` = 1000 WHERE `engine` IS NULL OR `engine` = 0;
UPDATE `owned_vehicles` SET `body`   = 1000 WHERE `body`   IS NULL OR `body`   = 0;
UPDATE `owned_vehicles` SET `fuel`   = 100  WHERE `fuel`   IS NULL OR `fuel`   = 0;
UPDATE `owned_vehicles` SET `stored` = 1    WHERE `stored` IS NULL;

-- New: installment/finance loans created by the modern showroom UI (client/shop_nui.lua +
-- server/shop_nui.lua). One row per active loan, looked up by plate for billing and by
-- owner for the player's own loan list. Safe to run more than once.
CREATE TABLE IF NOT EXISTS `vehicleshop_financing` (
	`id`                 INT NOT NULL AUTO_INCREMENT,
	`owner`              VARCHAR(60) NOT NULL,
	`plate`              VARCHAR(12) NOT NULL,
	`vehicle_name`       VARCHAR(60) NOT NULL,
	`total_price`        INT NOT NULL,
	`remaining_balance`  INT NOT NULL,
	`installment_amount` INT NOT NULL,
	`installments_left`  INT NOT NULL,
	`missed_payments`    INT NOT NULL DEFAULT 0,
	`next_due`           DATETIME NOT NULL,
	`created_at`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	KEY `owner` (`owner`),
	KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
