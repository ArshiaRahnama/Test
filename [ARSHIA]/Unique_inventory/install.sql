CREATE TABLE IF NOT EXISTS `unique_inv_slots` (
  `identifier` varchar(64) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`identifier`)
);

CREATE TABLE IF NOT EXISTS `unique_stash` (
  `skey` varchar(128) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`skey`)
);
