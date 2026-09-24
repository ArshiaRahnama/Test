-- ============================================================
--  Unique_housing - combined SQL install script
--  (merged from allhousing.sql + lockpicking/lockpick.sql)
--
--  NOTE: furni.sql from the original zip was intentionally left
--  OUT of this merge. It contained:
--      ALTER TABLE `playerhousing` ADD `furniture` longtext;
--  ...which targets a table called `playerhousing` that does not
--  exist in this setup (this resource uses `allhousing`, which
--  already has its own `furniture` column below). Running that
--  statement here would only error out ("table doesn't exist"),
--  so it was dropped rather than carried over as dead weight.
-- ============================================================

CREATE TABLE IF NOT EXISTS `allhousing` (
  `id` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `ownername` varchar(50) NOT NULL,
  `owned` tinyint(4) NOT NULL,
  `price` int(11) NOT NULL,
  `resalepercent` int(11) NOT NULL,
  `resalejob` varchar(50) NOT NULL,
  `entry` longtext DEFAULT NULL,
  `garage` longtext DEFAULT NULL,
  `furniture` longtext DEFAULT NULL,
  `shell` varchar(50) NOT NULL,
  `interior` varchar(50) NOT NULL,
  `shells` longtext DEFAULT NULL,
  `doors` longtext DEFAULT NULL,
  `housekeys` longtext DEFAULT NULL,
  `wardrobe` longtext DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `inventorylocation` longtext DEFAULT NULL,
  `mortgage_owed` int(11) NOT NULL DEFAULT 0,
  `last_repayment` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Requires the standard ESX `owned_vehicles` table to already exist.
ALTER TABLE `owned_vehicles` ADD `storedhouse` int(11) NOT NULL;

-- Requires the standard ESX `items` table to already exist.
INSERT INTO `items` (`name`, `label`, `limit`) VALUES
	('lockpick','Lockpick',1);
