-- Auction House table. Safe to run on an existing install (adds the job column if missing).
CREATE TABLE IF NOT EXISTS `auctionhouse2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) NOT NULL DEFAULT '',
  `item` varchar(255) NOT NULL DEFAULT '',
  `amount` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `job` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `job_idx` (`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
ALTER TABLE `auctionhouse2` ADD COLUMN IF NOT EXISTS `job` varchar(64) NOT NULL DEFAULT '';
