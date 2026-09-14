
CREATE TABLE IF NOT EXISTS `k9` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `dog_data` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
