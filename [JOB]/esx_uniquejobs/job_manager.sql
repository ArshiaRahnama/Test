-- created automatically on start by server/job_manager.lua - listed here for reference
CREATE TABLE IF NOT EXISTS `uj_job_ops` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `job` VARCHAR(40) NOT NULL,
  `op` LONGTEXT NOT NULL,
  `by_name` VARCHAR(80) DEFAULT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
