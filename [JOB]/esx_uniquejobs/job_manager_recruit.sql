-- created automatically on start by server/recruit_manager.lua - listed here for reference
CREATE TABLE IF NOT EXISTS `uj_org_perm` (`id` INT NOT NULL AUTO_INCREMENT, `job` VARCHAR(40) NOT NULL, `kind` VARCHAR(16) NOT NULL, `typ` VARCHAR(16) NOT NULL, `val` VARCHAR(60) NOT NULL, PRIMARY KEY (`id`));
CREATE TABLE IF NOT EXISTS `uj_org_level` (`job` VARCHAR(40) NOT NULL, `level` INT NOT NULL DEFAULT 0, PRIMARY KEY (`job`));
