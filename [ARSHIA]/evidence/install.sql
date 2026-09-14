-- evidence — install SQL for UniqueRP (ESXOLD) server
-- Import this once via phpMyAdmin/HeidiSQL before starting the resource.
-- Matches the schema used in [BASE]/database.sql on this server.

-- Archive table used by evidence:getStorageData / addEvidenceToStorage / deleteEvidenceFromStorage
-- (this table did not exist yet, so the archive feature would fail silently).
-- `analyzed_by` + `created_at` added for the V3 case-file upgrade (shows who filed the
-- report and when, instead of just a raw JSON blob).
CREATE TABLE IF NOT EXISTS `evidence_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` longtext DEFAULT NULL,
  `analyzed_by` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- If you already imported the old install.sql on a live server, run this instead of
-- re-creating the table (safe to run even if the columns already exist):
-- ALTER TABLE `evidence_storage` ADD COLUMN IF NOT EXISTS `analyzed_by` varchar(100) DEFAULT NULL;
-- ALTER TABLE `evidence_storage` ADD COLUMN IF NOT EXISTS `created_at` datetime DEFAULT NULL;

-- The 'uvlight' usable item (ESX.RegisterUsableItem("uvlight", ...) in server/main.lua)
-- did not exist in the `items` table, so it could never be given to a player.
-- Uses this server's real `items` columns: name, label, limit, rare, can_remove.
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('uvlight', 'UV Light', 1, 0, 1);
