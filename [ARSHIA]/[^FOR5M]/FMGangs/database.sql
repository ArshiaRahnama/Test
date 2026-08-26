-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5315
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table for5m.gangs 
CREATE TABLE IF NOT EXISTS `gangs` (
  `name` varchar(254) DEFAULT NULL,
  `label` varchar(254) DEFAULT NULL,
  `disband` int(11) DEFAULT 0,
  `logo` longtext DEFAULT NULL,
  `webhook` longtext DEFAULT NULL,
  `expire` int(255) DEFAULT 0,
  `expire_day` int(255) DEFAULT 0,
  `level` int(255) DEFAULT 0,
  `xp` int(255) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table for5m.gangs: ~4 rows (approximately)
/*!40000 ALTER TABLE `gangs` DISABLE KEYS */;
INSERT INTO `gangs` (`name`, `label`, `disband`, `logo`, `expire`, `expire_day`, `level`, `xp`) VALUES
	('nogang', 'nogang', 0, 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676&ex=66c48919&is=66c33799&hm=e95ded7afbabbf9ab358c1dcefef1e3109a0d64d08a21c05423cd5c940c94e15&', 0, 0, 0, 0);
/*!40000 ALTER TABLE `gangs` ENABLE KEYS */;

-- Dumping structure for table for5m.gangs_data
CREATE TABLE IF NOT EXISTS `gangs_data` (
  `gang_name` longtext DEFAULT NULL,
  `blip` longtext DEFAULT NULL,
  `boss` longtext DEFAULT NULL,
  `locker` longtext DEFAULT NULL,
  `armory` longtext DEFAULT NULL,
  `veh` longtext DEFAULT NULL,
  `vehspawn` longtext DEFAULT NULL,
  `heli` longtext DEFAULT NULL,
  `helispawn` longtext DEFAULT NULL,
  `boat` longtext DEFAULT NULL,
  `boatspawn` longtext DEFAULT NULL,
  `deletecars` longtext DEFAULT NULL,
  `craft` longtext DEFAULT NULL,
  `shop` longtext DEFAULT NULL,
  `flag` longtext DEFAULT NULL,
  `bots` longtext DEFAULT NULL,
  `others` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table for5m.gangs_data: ~4 rows (approximately)
/*!40000 ALTER TABLE `gangs_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `gangs_data` ENABLE KEYS */;

-- Dumping structure for table for5m.gang_grades
CREATE TABLE IF NOT EXISTS `gang_grades` (
  `gang_name` longtext DEFAULT NULL,
  `grade` int(11) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `clothes` longtext DEFAULT NULL,
  `access` longtext DEFAULT '{"setclothe":false,"putitem":false,"garage":false,"takeitem":false,"bossaction":false,"heliANDBoat":false}' , 
  `salary` int(255) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- Dumping data for table for5m.gang_grades: ~22 rows (approximately)
/*!40000 ALTER TABLE `gang_grades` DISABLE KEYS */;
INSERT INTO `gang_grades` (`gang_name`, `grade`, `name`, `label`, `clothes`, `access`) VALUES
	('nogang', 0, 'nogang', 'nogang', '{}', '{}');
/*!40000 ALTER TABLE `gang_grades` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
