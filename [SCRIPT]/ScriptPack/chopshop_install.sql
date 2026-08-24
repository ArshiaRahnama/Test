-- Run this once against your database. These items do not currently exist
-- in database.sql and the new chop shop will fail (silent no-op on
-- addInventoryItem) without them.

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('engine1', 'Engine Scrap X1', -1, 0, 1),
	('engine2', 'Engine Scrap X2', -1, 0, 1),
	('engine3', 'Engine Scrap X3', -1, 0, 1),
	('engine4', 'Engine Scrap X4', -1, 0, 1),
	('engine5', 'Engine Scrap X5', -1, 0, 1),
	('engine6', 'Engine Scrap X6', -1, 0, 1),
	('shahkelid', 'Shah Kelid', -1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
