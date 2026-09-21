CREATE TABLE IF NOT EXISTS `trunk_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) NOT NULL,
  `data` text NOT NULL,
  `owned` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
);

-- v1.2.0 (glovebox): rows are keyed "GLOVE:<plate>" (up to 15 chars), so the
-- plate column must be wider than the old varchar(8). Safe to run repeatedly.
ALTER TABLE `trunk_inventory` MODIFY `plate` varchar(20) NOT NULL;
