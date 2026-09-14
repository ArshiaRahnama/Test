-- Unique_Garage database fixes
-- Your `owned_vehicles` table already exists (essentialmode framework, 16 columns) — it was
-- NOT created by the previous version of this file (CREATE TABLE IF NOT EXISTS is a no-op on
-- an existing table). That table is missing `fuel` and `body`, which server.lua/parkmeter_sv.lua
-- write to on every store/retrieve — this is why cars were never actually saving.
-- Run this once; it only ADDS the two missing columns and leaves everything else untouched.

ALTER TABLE `owned_vehicles` ADD COLUMN IF NOT EXISTS `fuel`  FLOAT NOT NULL DEFAULT 100;
ALTER TABLE `owned_vehicles` ADD COLUMN IF NOT EXISTS `body`  FLOAT NOT NULL DEFAULT 1000;

-- vehicle_keys already exists on your server (seen in the screenshot) — nothing to do there.

-- Required items (ESX legacy `items` table). If your inventory is ox_inventory or similar,
-- add these through that system's items file instead — this INSERT won't apply there.
INSERT INTO `items` (`name`, `label`) VALUES ('lockpick', 'Lockpick') ON DUPLICATE KEY UPDATE `name` = `name`;
INSERT INTO `items` (`name`, `label`) VALUES ('hotwire', 'Pich Goshti') ON DUPLICATE KEY UPDATE `name` = `name`;

-- Extra repair: make sure `stored` is never NULL/empty text on any row (this can happen for
-- cars added before the esx_vehicleshop INSERT fix, or from other older tools that didn't set it).
-- If this column ever came back empty/blank, IN GARAGE would always show 0 no matter what.
UPDATE `owned_vehicles` SET `stored` = 1 WHERE `stored` IS NULL OR `stored` = '';

-- CRITICAL FIX: oxmysql's driver (mysql2) auto-converts TINYINT(1) columns to Lua booleans
-- (true/false) instead of numbers. Since `stored` needs 3 states (0=out, 1=in garage,
-- 2=impound), this silently collapsed 1 and 2 into the same `true` value, which is the real
-- root cause of "IN GARAGE always shows 0" and parked cars looking like they vanished/impounded.
-- Widening the display width to TINYINT(4) stops the driver from treating it as boolean.
-- >>> THIS IS THE MOST IMPORTANT LINE IN THIS FILE. RUN IT. <<<
ALTER TABLE `owned_vehicles` MODIFY COLUMN `stored` TINYINT(4) NOT NULL DEFAULT 1;
