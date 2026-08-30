-- Run this once against your database before using the new "Advanced Grade Management" menu.
-- Adds two per-grade permission flags used by the new toggleEmployee / toggleCustom options.
-- Safe to run on a live database: it only ADDS columns with a default value, it does not
-- touch any existing rows or other tables.

ALTER TABLE `job_grades`
  ADD COLUMN `perm_employee_management` TINYINT(1) NOT NULL DEFAULT 0 AFTER `items`,
  ADD COLUMN `perm_vehicle_custom`      TINYINT(1) NOT NULL DEFAULT 0 AFTER `perm_employee_management`;
