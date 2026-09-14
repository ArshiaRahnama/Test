-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for essentialmode
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `essentialmode`;

-- Dumping structure for table essentialmode.duty_logs
CREATE TABLE IF NOT EXISTS `duty_logs` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `steamhex` varchar(50) NOT NULL DEFAULT '',
  `ic_name` varchar(50) NOT NULL DEFAULT '',
  `job_name` varchar(50) NOT NULL DEFAULT '',
  `job_grade` varchar(50) NOT NULL DEFAULT '',
  `date` date DEFAULT NULL,
  `total_time` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.duty_logs: ~14 rows (approximately)
INSERT INTO `duty_logs` (`id`, `steamhex`, `ic_name`, `job_name`, `job_grade`, `date`, `total_time`) VALUES
	(186, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'police', 'Chief', '2025-02-06', 7800),
	(187, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'police', 'Chief', '2025-02-07', 2400),
	(189, 'steam:11000013b640b5f', 'Amir_Hidden', 'police', 'Chief', '2025-02-07', 14400),
	(190, 'steam:110000169311f06', 'Mmd_Mairex', 'police', 'Chief', '2025-02-07', 600),
	(191, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'taxi', 'Chief', '2025-02-07', 900),
	(192, 'steam:110000169311f06', 'Mmd_Mairex', 'police', 'Chief', '2025-02-08', 8700),
	(193, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'police', 'Chief', '2025-02-08', 3900),
	(194, 'steam:11000013b640b5f', 'Amir_Hidden', 'police', 'Chief', '2025-02-08', 5400),
	(195, 'steam:110000169dec3f7', 'Mehrad_Samet', 'mechanic', 'Chief', '2025-02-08', 4200),
	(196, 'steam:110000169dec3f7', 'Mehrad_Samet', 'police', 'Chief', '2025-02-08', 8400),
	(197, 'steam:110000169311f06', 'Mmd_Mairex', 'mechanic', 'Chief', '2025-02-08', 7800),
	(198, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'taxi', 'Chief', '2025-02-08', 1200),
	(199, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'sheriff', 'Chief', '2025-02-08', 5100),
	(200, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'weazel', 'Director', '2025-02-08', 1800);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
