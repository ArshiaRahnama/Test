-- Run this once against your database before using the new "Advanced Grade Management" menu.
-- Adds two per-grade permission flags used by the new toggleEmployee / toggleCustom options.
-- Safe to run on a live database: it only ADDS columns with a default value, it does not
-- touch any existing rows or other tables.

ALTER TABLE `job_grades`
  ADD COLUMN `perm_employee_management` TINYINT(1) NOT NULL DEFAULT 0 AFTER `items`,
  ADD COLUMN `perm_vehicle_custom`      TINYINT(1) NOT NULL DEFAULT 0 AFTER `perm_employee_management`,
  ADD COLUMN `perms`                    LONGTEXT DEFAULT NULL AFTER `perm_vehicle_custom`;

-- Vehicles added live via the /addcarjob command (in-game), on top of the static
-- Config.Garage list. Deleted via the DeleteCar icon_menu.
CREATE TABLE IF NOT EXISTS `job_vehicles_custom` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `job_name` VARCHAR(50) NOT NULL,
  `model`    VARCHAR(60) NOT NULL,
  `label`    VARCHAR(60) NOT NULL,
  `is_heli`  TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);
