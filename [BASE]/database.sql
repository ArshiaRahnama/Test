-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.19.0.7314
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
DROP DATABASE IF EXISTS `essentialmode`;
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `essentialmode`;

-- Dumping structure for table essentialmode.addon_account
DROP TABLE IF EXISTS `addon_account`;
CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.addon_account: ~43 rows (approximately)
REPLACE INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('caution', 'Caution', 0),
	('society_ambulance', 'ambulance', 1),
	('society_anchor', 'anchor', 1),
	('society_blacktide', 'blacktide', 1),
	('society_burgershot', 'Burgershot', 1),
	('society_cafe', 'Cafe', 1),
	('society_cardealer', 'Cardealer', 1),
	('society_carwash', 'carwash', 1),
	('society_catcafe', 'Cat Cafe', 1),
	('society_cia', 'CIA', 1),
	('society_cid', 'CID', 1),
	('society_concess', 'Concessionnaire', 1),
	('society_cratecarry', 'cratecarry', 1),
	('society_crimson', 'crimson', 1),
	('society_doa', 'DOA', 1),
	('society_doj', 'Department Of Justice', 1),
	('society_ember', 'ember', 1),
	('society_fbi', 'FBI', 1),
	('society_firebrick', 'firebrick', 1),
	('society_flourish', 'flourish', 1),
	('society_forces', 'Forces', 1),
	('society_frostbite', 'frostbite', 1),
	('society_goldcrust', 'goldcrust', 1),
	('society_judge', 'Judge', 1),
	('society_koi', 'koi', 1),
	('society_law', 'Law Enforcement', 1),
	('society_marshal', 'Marshal', 1),
	('society_mechanic', 'Mechanic', 1),
	('society_meridian', 'meridian', 1),
	('society_mt', 'Metropolitan', 1),
	('society_nightjar', 'nightjar', 1),
	('society_nojob', 'nojob', 1),
	('society_obsidian', 'obsidian', 1),
	('society_police', 'police', 1),
	('society_resturan', 'Resturan', 1),
	('society_sheriff', 'sheriff', 1),
	('society_slice', 'slice', 1),
	('society_static', 'static', 1),
	('society_sundae', 'sundae', 1),
	('society_taxi', 'taxi', 1),
	('society_turfco', 'turfco', 1),
	('society_uwucafe', 'uwucafe', 1),
	('society_voltage', 'voltage', 1),
	('society_wasabi', 'wasabi', 1),
	('society_weazel', 'reporterr', 1);

-- Dumping structure for table essentialmode.addon_account_data
DROP TABLE IF EXISTS `addon_account_data`;
CREATE TABLE IF NOT EXISTS `addon_account_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  KEY `index_addon_account_data_account_name` (`account_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9828 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.addon_account_data: ~233 rows (approximately)
REPLACE INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
	(1, 'society_uwucafe', 0, NULL),
	(2, 'society_ambulance', 0, NULL),
	(3, 'society_cardealer', 0, NULL),
	(4, 'society_concess', 0, NULL),
	(5, 'society_fbi', 0, NULL),
	(6, 'society_mechanic', 0, NULL),
	(7, 'society_mt', 0, NULL),
	(8, 'society_police', 0, NULL),
	(9, 'society_sheriff', 0, NULL),
	(10, 'society_taxi', 0, NULL),
	(11, 'society_weazel', 0, NULL),
	(12, 'caution', 0, 'steam:11000014bf543e0'),
	(9560, 'society_ambulance', 65000, NULL),
	(9561, 'society_burgershot', 11000, NULL),
	(9562, 'society_cafe', 0, NULL),
	(9563, 'society_catcafe', 0, NULL),
	(9564, 'society_cia', 0, NULL),
	(9565, 'society_fbi', 0, NULL),
	(9566, 'society_forces', 0, NULL),
	(9567, 'society_mechanic', 21, NULL),
	(9569, 'society_nojob', 0, NULL),
	(9570, 'society_police', 0, NULL),
	(9571, 'society_resturan', 0, NULL),
	(9572, 'society_sheriff', 0, NULL),
	(9573, 'society_taxi', 2300000, NULL),
	(9574, 'society_weazel', 0, NULL),
	(9621, 'caution', 0, 'steam:110000166709e1e'),
	(9622, 'caution', 0, 'steam:1100001713be52a'),
	(9623, 'caution', 0, 'steam:110000164178996'),
	(9624, 'caution', 0, 'steam:110000169d8fddd'),
	(9625, 'caution', 0, 'steam:11000016a8d2c0b'),
	(9626, 'caution', 0, 'steam:1100001318ca3b4'),
	(9627, 'caution', 0, 'steam:11000016c22eb66'),
	(9628, 'caution', 0, 'steam:11000016bb35c7a'),
	(9629, 'caution', 0, 'steam:110000149c62d2d'),
	(9630, 'caution', 0, 'steam:110000160853053'),
	(9631, 'caution', 0, 'steam:110000156815fef'),
	(9632, 'caution', 0, 'steam:1100001461aa653'),
	(9633, 'caution', 0, 'steam:-4pzD-5naH-oZY7'),
	(9634, 'caution', 0, 'steam:11000015d6b8b2c'),
	(9635, 'caution', 0, 'steam:110000146ba8534'),
	(9636, 'caution', 0, 'steam:110000145fe8f30'),
	(9637, 'caution', 0, 'steam:1100001729973c2'),
	(9638, 'caution', 0, 'steam:11000016a6c4666'),
	(9639, 'caution', 0, 'steam:-3rJI-iKDy-cIQh'),
	(9640, 'caution', 0, 'steam:1100001422d5c81'),
	(9641, 'caution', 0, 'steam:11000014ca54195'),
	(9642, 'caution', 0, 'steam:110000169030bb9'),
	(9643, 'caution', 0, 'steam:110000153f7fefe'),
	(9644, 'caution', 0, 'steam:11000013d331dad'),
	(9645, 'caution', 0, 'steam:11000015c854c83'),
	(9646, 'caution', 0, 'steam:1100001317ad216'),
	(9647, 'caution', 0, 'steam:110000152126a25'),
	(9648, 'caution', 0, 'steam:110000159cce98d'),
	(9649, 'caution', 0, 'steam:1100001572caecf'),
	(9650, 'caution', 0, 'steam:11000012e5ee0d7'),
	(9651, 'caution', 0, 'steam:-MCeu-JYtT-395n'),
	(9652, 'caution', 0, 'steam:1100001489ebf35'),
	(9653, 'caution', 0, 'steam:1100001448e7465'),
	(9654, 'caution', 0, 'steam:11000014b4f2b8b'),
	(9655, 'caution', 0, 'steam:11000015fdf900a'),
	(9656, 'caution', 0, 'steam:11000014b49b747'),
	(9657, 'caution', 0, 'steam:-NrTD-JiUj-pEcD'),
	(9658, 'caution', 0, 'steam:11000014b09925a'),
	(9659, 'caution', 0, 'steam:-LCkz-4QFc-k7Fm'),
	(9660, 'caution', 0, 'steam:11000014d6d6246'),
	(9661, 'caution', 0, 'steam:110000152149b54'),
	(9662, 'caution', 0, 'steam:110000141bb248d'),
	(9663, 'caution', 0, 'steam:11000012e8efb1f'),
	(9664, 'caution', 0, 'steam:11000014b3ac4e4'),
	(9665, 'caution', 0, 'steam:11000012e54e661'),
	(9666, 'caution', 0, 'steam:1100001459d9543'),
	(9667, 'caution', 0, 'steam:1100001468e5c85'),
	(9668, 'caution', 0, 'steam:110000172d7c947'),
	(9669, 'caution', 0, 'steam:11000016ab34669'),
	(9670, 'caution', 0, 'steam:11000016d99f254'),
	(9671, 'caution', 0, 'steam:110000164864337'),
	(9672, 'caution', 0, 'steam:110000171261bc3'),
	(9673, 'caution', 500, 'steam:1100001731466fc'),
	(9674, 'caution', 0, 'steam:1100001173251c0'),
	(9675, 'caution', 0, 'steam:11000016fc8e229'),
	(9676, 'caution', 0, 'steam:11000013096b624'),
	(9677, 'caution', 0, 'steam:11000016ecb80df'),
	(9678, 'caution', 0, 'steam:11000016e3841a2'),
	(9679, 'caution', 0, 'steam:-0acj-VaiL-Wbzm'),
	(9680, 'caution', 0, 'steam:-CcvW-T5UP-Zokb'),
	(9681, 'caution', 0, 'steam:11000015edb3c02'),
	(9682, 'caution', 0, 'steam:11000016e2b384e'),
	(9683, 'caution', 1000, 'steam:-yvw7-SeCh-cl7E'),
	(9684, 'caution', 0, 'steam:11000012f7a7272'),
	(9685, 'caution', 0, 'steam:11000015ccad75e'),
	(9686, 'caution', 0, 'steam:1100001720c487c'),
	(9687, 'caution', 0, 'steam:11000016acb2131'),
	(9688, 'caution', 0, 'steam:11000016ae159f7'),
	(9689, 'caution', 0, 'steam:110000156205c33'),
	(9690, 'caution', 0, 'steam:-lDI3-GySJ-zNXT'),
	(9691, 'caution', 0, 'steam:11000016bc36bd7'),
	(9692, 'caution', 0, 'steam:-KtkK-R0z5-XPI6'),
	(9693, 'caution', 0, 'steam:11000012e9a3faf'),
	(9694, 'caution', 0, 'steam:11000016ed53096'),
	(9695, 'caution', 0, 'steam:11000015e81580d'),
	(9696, 'caution', 0, 'steam:-ApsC-jIEr-IKI6'),
	(9697, 'caution', 0, 'steam:-mD8s-IyLK-x5w4'),
	(9698, 'caution', 0, 'steam:110000172d7d95c'),
	(9699, 'caution', 0, 'steam:110000156064b78'),
	(9700, 'caution', 0, 'steam:11000017309b243'),
	(9701, 'caution', 0, 'steam:11000014e79ca78'),
	(9702, 'caution', 0, 'steam:-BmiM-li73-hB12'),
	(9703, 'caution', 0, 'steam:1100001356f1d24'),
	(9704, 'caution', 0, 'steam:11000012fb8d0cd'),
	(9705, 'caution', 0, 'steam:-2EeR-LmGj-PGCh'),
	(9706, 'caution', 0, 'steam:11000016f6063a9'),
	(9707, 'caution', 0, 'steam:110000159d56c19'),
	(9708, 'caution', 0, 'steam:-9pXT-EShF-Sldm'),
	(9709, 'caution', 0, 'steam:11000015a0857f7'),
	(9710, 'caution', 0, 'steam:11000015beb286a'),
	(9711, 'caution', 0, 'steam:11000016b6e1df1'),
	(9712, 'caution', 0, 'steam:110000153c9499d'),
	(9713, 'caution', 0, 'steam:110000149f8aca8'),
	(9714, 'caution', 0, 'steam:-6BBM-pArc-2v2Y'),
	(9715, 'caution', 0, 'steam:-KMw2-xFda-ujLv'),
	(9716, 'caution', 0, 'steam:11000014be70990'),
	(9717, 'caution', 0, 'steam:-OSEg-VbmC-etFm'),
	(9718, 'caution', 0, 'steam:-8Yxu-FbU8-Pa5T'),
	(9719, 'caution', 0, 'steam:-og0q-G6Nb-HEZL'),
	(9720, 'caution', 0, 'steam:11000014aa657f5'),
	(9721, 'caution', 0, 'steam:11000012f495dcc'),
	(9722, 'caution', 0, 'steam:-Zjty-lduH-41TC'),
	(9723, 'caution', 0, 'steam:-Iqol-K0cn-dmE0'),
	(9724, 'caution', 0, 'steam:11000016d29f305'),
	(9725, 'caution', 0, 'steam:110000147e20c6c'),
	(9726, 'caution', 0, 'steam:11000014a8cd228'),
	(9727, 'caution', 0, 'steam:110000130c0e9fb'),
	(9728, 'caution', 0, 'steam:-9aGE-h0YX-ymRY'),
	(9729, 'caution', 0, 'steam:11000014d037b12'),
	(9730, 'caution', 0, 'steam:-E1W6-RQML-eLiv'),
	(9731, 'caution', 0, 'steam:1100001719a1a91'),
	(9732, 'caution', 0, 'steam:110000166a513c2'),
	(9733, 'caution', 0, 'steam:110000171e508ec'),
	(9734, 'caution', 0, 'steam:11000013027807a'),
	(9735, 'caution', 0, 'steam:1100001488134a5'),
	(9736, 'caution', 0, 'steam:11000015f064197'),
	(9737, 'caution', 0, 'steam:11000015adab072'),
	(9738, 'society_cid', 0, NULL),
	(9739, 'society_doa', 0, NULL),
	(9740, 'society_judge', 0, NULL),
	(9741, 'society_marshal', 0, NULL),
	(9742, 'society_uwucafe', 0, NULL),
	(9743, 'society_obsidian', 0, NULL),
	(9744, 'society_voltage', 0, NULL),
	(9745, 'society_ember', 0, NULL),
	(9746, 'society_anchor', 0, NULL),
	(9747, 'society_crimson', 0, NULL),
	(9748, 'society_flourish', 0, NULL),
	(9749, 'society_goldcrust', 0, NULL),
	(9750, 'society_static', 0, NULL),
	(9751, 'society_nightjar', 0, NULL),
	(9752, 'society_firebrick', 0, NULL),
	(9753, 'society_slice', 0, NULL),
	(9754, 'society_frostbite', 0, NULL),
	(9755, 'society_sundae', 0, NULL),
	(9756, 'society_koi', 0, NULL),
	(9757, 'society_wasabi', 0, NULL),
	(9758, 'society_carwash', 0, NULL),
	(9759, 'society_meridian', 0, NULL),
	(9760, 'society_blacktide', 0, NULL),
	(9761, 'society_cratecarry', 0, NULL),
	(9762, 'society_turfco', 0, NULL),
	(9763, 'society_doj', 100, NULL),
	(9764, 'society_law', 9956907, NULL),
	(9765, 'society_uwucafe', 0, NULL),
	(9766, 'society_obsidian', 0, NULL),
	(9767, 'society_voltage', 0, NULL),
	(9768, 'society_ember', 0, NULL),
	(9769, 'society_anchor', 0, NULL),
	(9770, 'society_crimson', 0, NULL),
	(9771, 'society_flourish', 0, NULL),
	(9772, 'society_goldcrust', 0, NULL),
	(9773, 'society_static', 0, NULL),
	(9774, 'society_nightjar', 0, NULL),
	(9775, 'society_firebrick', 0, NULL),
	(9776, 'society_slice', 0, NULL),
	(9777, 'society_frostbite', 0, NULL),
	(9778, 'society_sundae', 0, NULL),
	(9779, 'society_koi', 0, NULL),
	(9780, 'society_wasabi', 0, NULL),
	(9781, 'society_carwash', 0, NULL),
	(9782, 'society_meridian', 0, NULL),
	(9783, 'society_blacktide', 0, NULL),
	(9784, 'society_cratecarry', 0, NULL),
	(9785, 'society_turfco', 0, NULL),
	(9786, 'society_uwucafe', 0, NULL),
	(9787, 'society_obsidian', 0, NULL),
	(9788, 'society_voltage', 0, NULL),
	(9789, 'society_ember', 0, NULL),
	(9790, 'society_anchor', 0, NULL),
	(9791, 'society_crimson', 0, NULL),
	(9792, 'society_flourish', 0, NULL),
	(9793, 'society_goldcrust', 0, NULL),
	(9794, 'society_static', 0, NULL),
	(9795, 'society_nightjar', 0, NULL),
	(9796, 'society_firebrick', 0, NULL),
	(9797, 'society_slice', 0, NULL),
	(9798, 'society_frostbite', 0, NULL),
	(9799, 'society_sundae', 0, NULL),
	(9800, 'society_koi', 0, NULL),
	(9801, 'society_wasabi', 0, NULL),
	(9802, 'society_carwash', 0, NULL),
	(9803, 'society_meridian', 0, NULL),
	(9804, 'society_blacktide', 0, NULL),
	(9805, 'society_cratecarry', 0, NULL),
	(9806, 'society_turfco', 0, NULL),
	(9807, 'society_uwucafe', 0, NULL),
	(9808, 'society_obsidian', 0, NULL),
	(9809, 'society_voltage', 0, NULL),
	(9810, 'society_ember', 0, NULL),
	(9811, 'society_anchor', 0, NULL),
	(9812, 'society_crimson', 0, NULL),
	(9813, 'society_flourish', 0, NULL),
	(9814, 'society_goldcrust', 0, NULL),
	(9815, 'society_static', 0, NULL),
	(9816, 'society_nightjar', 0, NULL),
	(9817, 'society_firebrick', 0, NULL),
	(9818, 'society_slice', 0, NULL),
	(9819, 'society_frostbite', 0, NULL),
	(9820, 'society_sundae', 0, NULL),
	(9821, 'society_koi', 0, NULL),
	(9822, 'society_wasabi', 0, NULL),
	(9823, 'society_carwash', 0, NULL),
	(9824, 'society_meridian', 0, NULL),
	(9825, 'society_blacktide', 0, NULL),
	(9826, 'society_cratecarry', 0, NULL),
	(9827, 'society_turfco', 0, NULL);

-- Dumping structure for table essentialmode.addon_inventory
DROP TABLE IF EXISTS `addon_inventory`;
CREATE TABLE IF NOT EXISTS `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.addon_inventory: ~49 rows (approximately)
REPLACE INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('gang_a', 'gang', 1),
	('gang_apadax', 'gang', 1),
	('gang_army', 'gang', 1),
	('gang_corleone', 'gang', 1),
	('gang_error', 'gang', 1),
	('gang_revenge', 'gang', 1),
	('gang_riders', 'gang', 1),
	('gang_salamanca', 'gang', 1),
	('gang_sp', 'gang', 1),
	('gang_tbc', 'gang', 1),
	('gang_timarestan', 'gang', 1),
	('property', 'House', 0),
	('society_ambulance', 'Ambulance', 1),
	('society_anchor', 'anchor', 1),
	('society_blacktide', 'blacktide', 1),
	('society_burgershot', 'Burgershot', 1),
	('society_cafe', 'Cafe', 1),
	('society_cardealer', 'Cardealer', 1),
	('society_carwash', 'carwash', 1),
	('society_catcafe', 'Cat Cafe', 1),
	('society_cia', 'CIA', 1),
	('society_concess', 'Concessionnaire', 1),
	('society_cratecarry', 'cratecarry', 1),
	('society_crimson', 'crimson', 1),
	('society_ember', 'ember', 1),
	('society_fbi', 'fbi', 1),
	('society_firebrick', 'firebrick', 1),
	('society_flourish', 'flourish', 1),
	('society_forces', 'Forces', 1),
	('society_frostbite', 'frostbite', 1),
	('society_goldcrust', 'goldcrust', 1),
	('society_koi', 'koi', 1),
	('society_mechanic', 'Mechanic', 1),
	('society_meridian', 'meridian', 1),
	('society_mt', 'Metropolitan', 1),
	('society_nightjar', 'nightjar', 1),
	('society_obsidian', 'obsidian', 1),
	('society_police', 'police', 1),
	('society_resturan', 'Resturan', 1),
	('society_sheriff', 'sheriff', 1),
	('society_slice', 'slice', 1),
	('society_static', 'static', 1),
	('society_sundae', 'sundae', 1),
	('society_taxi', 'taxi', 1),
	('society_turfco', 'turfco', 1),
	('society_uwucafe', 'uwucafe', 1),
	('society_voltage', 'voltage', 1),
	('society_wasabi', 'wasabi', 1),
	('society_weazel', 'reporterr', 1);

-- Dumping structure for table essentialmode.addon_inventory_items
DROP TABLE IF EXISTS `addon_inventory_items`;
CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  KEY `index_addon_inventory_inventory_name` (`inventory_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.addon_inventory_items: ~8 rows (approximately)
REPLACE INTO `addon_inventory_items` (`id`, `inventory_name`, `name`, `count`, `owner`) VALUES
	(1, 'society_police', 'drugtest', 0, NULL),
	(2, 'society_police', 'breathalyzer', 10, NULL),
	(3, 'society_mt', 'drugtest', 0, NULL),
	(4, 'society_mt', 'bread', 1, NULL),
	(5, 'society_mt', 'grip', 0, NULL),
	(6, 'society_mt', 'silencer', 0, NULL),
	(7, 'gang_a', 'blowtorch', 1, NULL),
	(8, 'gang_a', 'blackmoney', 0, NULL);

-- Dumping structure for table essentialmode.admin_action_log
DROP TABLE IF EXISTS `admin_action_log`;
CREATE TABLE IF NOT EXISTS `admin_action_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_identifier` varchar(60) DEFAULT NULL,
  `admin_name` varchar(100) DEFAULT NULL,
  `target_identifier` varchar(60) DEFAULT NULL,
  `target_name` varchar(100) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `target_identifier` (`target_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.admin_action_log: ~2 rows (approximately)
REPLACE INTO `admin_action_log` (`id`, `admin_identifier`, `admin_name`, `target_identifier`, `target_name`, `action`, `details`, `created_at`) VALUES
	(1, 'steam:11000014bf543e0', 'GD', 'steam:11000014bf543e0', 'GD', 'give-money', 'target: GD | money: +1000 | reason: No reason specified', '2026-08-16 00:48:09'),
	(2, 'steam:11000014bf543e0', 'GD', 'steam:11000014bf543e0', 'GD', 'ban', 'target: GD | 1 minutes | reason: 1', '2026-08-17 08:31:02');

-- Dumping structure for table essentialmode.admin_ip_log
DROP TABLE IF EXISTS `admin_ip_log`;
CREATE TABLE IF NOT EXISTS `admin_ip_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `license` varchar(60) DEFAULT NULL,
  `discord` varchar(60) DEFAULT NULL,
  `ip` varchar(64) NOT NULL,
  `playername` varchar(100) DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_ip` (`identifier`,`ip`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.admin_ip_log: ~3 rows (approximately)
REPLACE INTO `admin_ip_log` (`id`, `identifier`, `license`, `discord`, `ip`, `playername`, `last_seen`) VALUES
	(1, 'steam:11000014bf543e0', 'license:153122398469261248', 'no info', '192.168.1.110', 'GD', '2026-08-25 16:25:50'),
	(2, 'steam:11000014bf543e0', 'license:153122398469261248', 'no info', '172.20.10.2', 'GD', '2026-08-19 21:05:57'),
	(42, 'steam:11000014bf543e0', 'license:153122398469261248', 'no info', '172.20.10.3', 'GD', '2026-08-26 11:33:09');

-- Dumping structure for table essentialmode.admin_player_notes
DROP TABLE IF EXISTS `admin_player_notes`;
CREATE TABLE IF NOT EXISTS `admin_player_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `note` varchar(500) NOT NULL,
  `admin_name` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.admin_player_notes: ~0 rows (approximately)

-- Dumping structure for table essentialmode.admin_saved_locations
DROP TABLE IF EXISTS `admin_saved_locations`;
CREATE TABLE IF NOT EXISTS `admin_saved_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.admin_saved_locations: ~0 rows (approximately)

-- Dumping structure for table essentialmode.admin_warnings
DROP TABLE IF EXISTS `admin_warnings`;
CREATE TABLE IF NOT EXISTS `admin_warnings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `playername` varchar(100) DEFAULT NULL,
  `admin_identifier` varchar(60) DEFAULT NULL,
  `admin_name` varchar(100) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.admin_warnings: ~2 rows (approximately)
REPLACE INTO `admin_warnings` (`id`, `identifier`, `playername`, `admin_identifier`, `admin_name`, `reason`, `created_at`) VALUES
	(1, 'steam:11000014bf543e0', 'GD', 'steam:11000014bf543e0', 'GD', '1', '2026-08-15 09:31:07'),
	(2, 'steam:11000014bf543e0', 'GD', 'steam:11000014bf543e0', 'GD', '2', '2026-08-15 10:31:57');

-- Dumping structure for table essentialmode.adminjaillog
DROP TABLE IF EXISTS `adminjaillog`;
CREATE TABLE IF NOT EXISTS `adminjaillog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `name` varchar(60) DEFAULT NULL,
  `oocname` varchar(60) DEFAULT NULL,
  `jailreason` varchar(255) DEFAULT NULL,
  `jailtime` int(11) DEFAULT NULL,
  `punisher` varchar(60) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.adminjaillog: ~4 rows (approximately)
REPLACE INTO `adminjaillog` (`id`, `identifier`, `name`, `oocname`, `jailreason`, `jailtime`, `punisher`, `date`) VALUES
	(1, 'steam:11000014bf543e0', 'Arshia_Mtz', NULL, '1', 1, 'Arshia_Mtz', '1787030024'),
	(2, 'steam:11000014bf543e0', 'Arshia_Mtz', NULL, '1', 1, 'Arshia_Mtz', '1787030336'),
	(3, 'steam:11000014bf543e0', 'Arshia_Mtz', NULL, 'unjail (manual)', 0, 'Arshia_Mtz', '1787030355'),
	(4, 'steam:11000014bf543e0', 'Arshia_Mtz', NULL, '1', 1, 'Arshia_Mtz', '1787030358');

-- Dumping structure for table essentialmode.anticheat_flags
DROP TABLE IF EXISTS `anticheat_flags`;
CREATE TABLE IF NOT EXISTS `anticheat_flags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `kind` varchar(32) NOT NULL,
  `score_after` int(11) NOT NULL,
  `evidence` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_anticheat_identifier` (`identifier`),
  KEY `idx_anticheat_kind` (`kind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.anticheat_flags: ~0 rows (approximately)

-- Dumping structure for table essentialmode.audit
DROP TABLE IF EXISTS `audit`;
CREATE TABLE IF NOT EXISTS `audit` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` int(11) DEFAULT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  `oname` varchar(60) DEFAULT NULL,
  `timestamp` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.audit: ~366 rows (approximately)
REPLACE INTO `audit` (`log_id`, `id`, `identifier`, `oname`, `timestamp`, `type`) VALUES
	(1, 1, 'steam:11000014bf543e0', 'AghaT BardiA', '1785397967', 'Enter'),
	(2, 2, 'steam:11000014bf543e0', 'AghaT BardiA', '1785398099', 'Exit([txAdmin] You have been kicked: for unknown r'),
	(3, 3, 'steam:11000014bf543e0', 'AghaT BardiA', '1785398151', 'Enter'),
	(4, 4, 'steam:11000014bf543e0', 'AghaT BardiA', '1785398341', 'Exit(Server->client connection timed out. Last see'),
	(5, 5, 'steam:11000014bf543e0', 'AghaT BardiA', '1785402963', 'Enter'),
	(6, 6, 'steam:11000014bf543e0', 'AghaT BardiA', '1785403257', 'Exit(Server shutting down: SIGHUP received)'),
	(7, 1, 'steam:11000014bf543e0', 'AghaT BardiA', '1785483218', 'Exit(Server shutting down: SIGHUP received)'),
	(8, 1, 'steam:11000014bf543e0', 'AghaT BardiA', '1785483265', 'Enter'),
	(9, 1, 'steam:11000014bf543e0', 'AghaT BardiA', '1785483605', 'Exit(Server->client connection timed out. Last see'),
	(10, 2, 'steam:11000014bf543e0', 'AghaT BardiA', '1785483676', 'Enter'),
	(11, 2, 'steam:11000014bf543e0', 'AghaT BardiA', '1785488741', 'Exit(Server shutting down: SIGHUP received)'),
	(12, 1, 'steam:11000014bf543e0', 'arshiahub.ir', '1785490657', 'Enter'),
	(13, 1, 'steam:11000014bf543e0', 'arshiahub.ir', '1785490759', 'Exit(Server shutting down: SIGHUP received)'),
	(14, 2, 'steam:11000014bf543e0', 'arshiahub.ir', '1785523819', 'Enter'),
	(15, 2, 'steam:11000014bf543e0', 'arshiahub.ir', '1785525179', 'Exit(Server shutting down: SIGHUP received)'),
	(16, 1, 'steam:11000014bf543e0', 'arshiahub.ir', '1785561734', 'Enter'),
	(17, 1, 'steam:11000014bf543e0', 'arshiahub.ir', '1785561758', 'Exit(Exiting)'),
	(18, 2, 'steam:11000014bf543e0', 'GD', '1785561832', 'Enter'),
	(19, 2, 'steam:11000014bf543e0', 'GD', '1785563062', 'Exit(Exiting)'),
	(20, 1, 'steam:11000014bf543e0', 'GD', '1785563234', 'Enter'),
	(21, 1, 'steam:11000014bf543e0', 'GD', '1785563478', 'Exit(Exiting)'),
	(22, 1, 'steam:11000014bf543e0', 'GD', '1785568209', 'Enter'),
	(23, 1, 'steam:11000014bf543e0', 'GD', '1785568244', 'Exit(Exiting)'),
	(24, 1, 'steam:11000014bf543e0', 'GD', '1785569024', 'Enter'),
	(25, 1, 'steam:11000014bf543e0', 'GD', '1785569984', 'Exit(Server shutting down: SIGHUP received)'),
	(26, 1, 'steam:11000014bf543e0', 'GD', '1785570135', 'Enter'),
	(27, 1, 'steam:11000014bf543e0', 'GD', '1785570751', 'Exit(Server shutting down: SIGHUP received)'),
	(28, 1, 'steam:11000014bf543e0', 'GD', '1785570983', 'Enter'),
	(29, 1, 'steam:11000014bf543e0', 'GD', '1785571835', 'Exit(Server shutting down: SIGHUP received)'),
	(30, 1, 'steam:11000014bf543e0', 'GD', '1785572033', 'Enter'),
	(31, 1, 'steam:11000014bf543e0', 'GD', '1785572635', 'Exit(Exiting)'),
	(32, 1, 'steam:11000014bf543e0', 'GD', '1785572995', 'Enter'),
	(33, 1, 'steam:11000014bf543e0', 'GD', '1785573144', 'Exit(Server shutting down: SIGHUP received)'),
	(34, 1, 'steam:11000014bf543e0', 'GD', '1785573286', 'Enter'),
	(35, 1, 'steam:11000014bf543e0', 'GD', '1785574214', 'Exit(Server shutting down: SIGHUP received)'),
	(36, 1, 'steam:11000014bf543e0', 'GD', '1785574540', 'Enter'),
	(37, 1, 'steam:11000014bf543e0', 'GD', '1785575742', 'Exit(Server shutting down: SIGHUP received)'),
	(38, 1, 'steam:11000014bf543e0', 'GD', '1785575990', 'Enter'),
	(39, 1, 'steam:11000014bf543e0', 'GD', '1785576097', 'Exit(Server shutting down: SIGHUP received)'),
	(40, 1, 'steam:11000014bf543e0', 'GD', '1785576321', 'Enter'),
	(41, 1, 'steam:11000014bf543e0', 'GD', '1785577124', 'Exit(Server shutting down: SIGHUP received)'),
	(42, 1, 'steam:11000014bf543e0', 'GD', '1785578695', 'Enter'),
	(43, 1, 'steam:11000014bf543e0', 'GD', '1785579533', 'Exit(Server shutting down: SIGHUP received)'),
	(44, 1, 'steam:11000014bf543e0', 'GD', '1785579743', 'Enter'),
	(45, 1, 'steam:11000014bf543e0', 'GD', '1785580624', 'Exit(Server shutting down: SIGHUP received)'),
	(46, 1, 'steam:11000014bf543e0', 'GD', '1785580757', 'Enter'),
	(47, 1, 'steam:11000014bf543e0', 'GD', '1785581861', 'Exit(Server->client connection timed out. Last see'),
	(48, 1, 'steam:11000014bf543e0', 'GD', '1785581982', 'Enter'),
	(49, 1, 'steam:11000014bf543e0', 'GD', '1785583255', 'Exit(Server shutting down: SIGHUP received)'),
	(50, 1, 'steam:11000014bf543e0', 'GD', '1785583728', 'Enter'),
	(51, 1, 'steam:11000014bf543e0', 'GD', '1785585227', 'Exit(Server shutting down: SIGHUP received)'),
	(52, 1, 'steam:11000014bf543e0', 'GD', '1785589709', 'Enter'),
	(53, 1, 'steam:11000014bf543e0', 'GD', '1785590471', 'Exit(Server shutting down: SIGHUP received)'),
	(54, 1, 'steam:11000014bf543e0', 'GD', '1785591187', 'Enter'),
	(55, 1, 'steam:11000014bf543e0', 'GD', '1785591703', 'Exit(Server->client connection timed out. Last see'),
	(56, 1, 'steam:11000014bf543e0', 'GD', '1785592469', 'Enter'),
	(57, 1, 'steam:11000014bf543e0', 'GD', '1785592980', 'Exit(Server shutting down: SIGHUP received)'),
	(58, 1, 'steam:11000014bf543e0', 'GD', '1785593296', 'Enter'),
	(59, 1, 'steam:11000014bf543e0', 'GD', '1785593415', 'Exit(Server->client connection timed out. Last see'),
	(60, 2, 'steam:11000014bf543e0', 'GD', '1785593570', 'Enter'),
	(61, 2, 'steam:11000014bf543e0', 'GD', '1785594348', 'Exit(Server shutting down: SIGHUP received)'),
	(62, 1, 'steam:11000014bf543e0', 'GD', '1785609086', 'Enter'),
	(63, 1, 'steam:11000014bf543e0', 'GD', '1785610595', 'Exit(Server->client connection timed out. Last see'),
	(64, 1, 'steam:11000014bf543e0', 'GD', '1785611703', 'Enter'),
	(65, 1, 'steam:11000014bf543e0', 'GD', '1785613518', 'Exit(Server shutting down: SIGHUP received)'),
	(66, 1, 'steam:11000014bf543e0', 'GD', '1785614033', 'Enter'),
	(67, 1, 'steam:11000014bf543e0', 'GD', '1785614227', 'Exit(Server shutting down: SIGHUP received)'),
	(68, 2, 'steam:11000014bf543e0', 'GD', '1785648638', 'Enter'),
	(69, 2, 'steam:11000014bf543e0', 'GD', '1785661164', 'Exit(Exiting)'),
	(70, 1, 'steam:11000014bf543e0', 'GD', '1785663056', 'Enter'),
	(71, 1, 'steam:11000014bf543e0', 'GD', '1785665537', 'Exit(Exiting)'),
	(72, 1, 'steam:11000014bf543e0', 'GD', '1785668788', 'Enter'),
	(73, 1, 'steam:11000014bf543e0', 'GD', '1785671291', 'Exit(Server shutting down: SIGHUP received)'),
	(74, 1, 'steam:11000014bf543e0', 'GD', '1785671546', 'Enter'),
	(75, 1, 'steam:11000014bf543e0', 'GD', '1785671636', 'Exit(Exiting)'),
	(76, 1, 'steam:11000014bf543e0', 'GD', '1785671794', 'Enter'),
	(77, 1, 'steam:11000014bf543e0', 'GD', '1785673544', 'Exit(Server shutting down: SIGHUP received)'),
	(78, 1, 'steam:11000014bf543e0', 'GD', '1785673843', 'Enter'),
	(79, 1, 'steam:11000014bf543e0', 'GD', '1785676256', 'Exit(Server shutting down: SIGHUP received)'),
	(80, 1, 'steam:11000014bf543e0', 'GD', '1785677191', 'Enter'),
	(81, 1, 'steam:11000014bf543e0', 'GD', '1785678746', 'Exit(Exiting)'),
	(82, 1, 'steam:11000014bf543e0', 'GD', '1785686300', 'Enter'),
	(83, 1, 'steam:11000014bf543e0', 'GD', '1785687061', 'Exit(Server->client connection timed out. Last see'),
	(84, 1, 'steam:11000014bf543e0', 'GD', '1785687900', 'Enter'),
	(85, 1, 'steam:11000014bf543e0', 'GD', '1785689323', 'Exit(Server shutting down: SIGHUP received)'),
	(86, 1, 'steam:11000014bf543e0', 'GD', '1785697838', 'Enter'),
	(87, 1, 'steam:11000014bf543e0', 'GD', '1785699983', 'Exit(Exiting)'),
	(88, 1, 'steam:11000014bf543e0', 'GD', '1785700679', 'Enter'),
	(89, 1, 'steam:11000014bf543e0', 'GD', '1785705897', 'Exit(Server shutting down: SIGHUP received)'),
	(90, 1, 'steam:11000014bf543e0', 'GD', '1785738820', 'Enter'),
	(91, 1, 'steam:11000014bf543e0', 'GD', '1785744823', 'Exit(Exiting)'),
	(92, 1, 'steam:11000014bf543e0', 'GD', '1785750775', 'Enter'),
	(93, 1, 'steam:11000014bf543e0', 'GD', '1785756419', 'Exit(Server shutting down: SIGHUP received)'),
	(94, 1, 'steam:11000014bf543e0', 'GD', '1785758157', 'Enter'),
	(95, 1, 'steam:11000014bf543e0', 'GD', '1785759174', 'Exit(Server->client connection timed out. Last see'),
	(96, 1, 'steam:11000014bf543e0', 'GD', '1785759437', 'Enter'),
	(97, 1, 'steam:11000014bf543e0', 'GD', '1785760602', 'Exit(Server shutting down: SIGHUP received)'),
	(98, 1, 'steam:11000014bf543e0', 'GD', '1785778537', 'Enter'),
	(99, 1, 'steam:11000014bf543e0', 'GD', '1785779666', 'Exit(Server shutting down: SIGHUP received)'),
	(100, 1, 'steam:11000014bf543e0', 'GD', '1785820947', 'Enter'),
	(101, 1, 'steam:11000014bf543e0', 'GD', '1785821587', 'Exit(Server->client connection timed out. Last see'),
	(102, 1, 'steam:11000014bf543e0', 'GD', '1785822175', 'Enter'),
	(103, 1, 'steam:11000014bf543e0', 'GD', '1785837347', 'Enter'),
	(104, 1, 'steam:11000014bf543e0', 'GD', '1785837672', 'Exit(Exiting)'),
	(105, 1, 'steam:11000014bf543e0', 'GD', '1785838072', 'Enter'),
	(106, 1, 'steam:11000014bf543e0', 'GD', '1785840247', 'Exit(Server shutting down: SIGHUP received)'),
	(107, 1, 'steam:11000014bf543e0', 'GD', '1785841145', 'Enter'),
	(108, 1, 'steam:11000014bf543e0', 'GD', '1785842384', 'Exit(Exiting)'),
	(109, 1, 'steam:11000014bf543e0', 'GD', '1785843864', 'Enter'),
	(110, 1, 'steam:11000014bf543e0', 'GD', '1785844054', 'Exit([txAdmin] Server restarting (admin request).)'),
	(111, 1, 'steam:11000014bf543e0', 'GD', '1785844141', 'Enter'),
	(112, 1, 'steam:11000014bf543e0', 'GD', '1785844627', 'Exit([txAdmin] Server restarting (admin request).)'),
	(113, 1, 'steam:11000014bf543e0', 'GD', '1785844711', 'Enter'),
	(114, 1, 'steam:11000014bf543e0', 'GD', '1785844748', 'Exit(Server->client connection timed out. Last see'),
	(115, 1, 'steam:11000014bf543e0', 'GD', '1785844862', 'Enter'),
	(116, 1, 'steam:11000014bf543e0', 'GD', '1785844967', 'Exit([txAdmin] Server restarting (admin request).)'),
	(117, 1, 'steam:11000014bf543e0', 'GD', '1785845028', 'Enter'),
	(118, 1, 'steam:11000014bf543e0', 'GD', '1785845065', 'Exit(Server->client connection timed out. Last see'),
	(119, 1, 'steam:11000014bf543e0', 'GD', '1785845298', 'Enter'),
	(120, 1, 'steam:11000014bf543e0', 'GD', '1785846781', 'Exit([txAdmin] Server restarting (admin request).)'),
	(121, 1, 'steam:11000014bf543e0', 'GD', '1785847001', 'Enter'),
	(122, 1, 'steam:11000014bf543e0', 'GD', '1785849311', 'Exit(Server->client connection timed out. Last see'),
	(123, 1, 'steam:11000014bf543e0', 'GD', '1785871522', 'Enter'),
	(124, 1, 'steam:11000014bf543e0', 'GD', '1785872178', 'Exit([txAdmin] Server restarting (admin request).)'),
	(125, 1, 'steam:11000014bf543e0', 'GD', '1785872268', 'Enter'),
	(126, 1, 'steam:11000014bf543e0', 'GD', '1785872374', 'Exit([txAdmin] Server restarting (admin request).)'),
	(127, 1, 'steam:11000014bf543e0', 'GD', '1785872465', 'Enter'),
	(128, 1, 'steam:11000014bf543e0', 'GD', '1785872787', 'Exit([txAdmin] Server restarting (admin request).)'),
	(129, 1, 'steam:11000014bf543e0', 'GD', '1785872917', 'Enter'),
	(130, 1, 'steam:11000014bf543e0', 'GD', '1785873576', 'Exit([txAdmin] Server restarting (admin request).)'),
	(131, 1, 'steam:11000014bf543e0', 'GD', '1785873638', 'Enter'),
	(132, 1, 'steam:11000014bf543e0', 'GD', '1785874035', 'Exit([txAdmin] Server restarting (admin request).)'),
	(133, 1, 'steam:11000014bf543e0', 'GD', '1785874124', 'Enter'),
	(134, 1, 'steam:11000014bf543e0', 'GD', '1785874785', 'Exit([txAdmin] Server restarting (admin request).)'),
	(135, 1, 'steam:11000014bf543e0', 'GD', '1785874842', 'Enter'),
	(136, 1, 'steam:11000014bf543e0', 'GD', '1785875067', 'Exit(Server->client connection timed out. Last see'),
	(137, 1, 'steam:11000014bf543e0', 'GD', '1785910816', 'Enter'),
	(138, 1, 'steam:11000014bf543e0', 'GD', '1785911480', 'Exit(Server shutting down: SIGHUP received)'),
	(139, 1, 'steam:11000014bf543e0', 'GD', '1785911925', 'Enter'),
	(140, 1, 'steam:11000014bf543e0', 'GD', '1785914807', 'Exit(Server shutting down: SIGHUP received)'),
	(141, 1, 'steam:11000014bf543e0', 'GD', '1785956309', 'Enter'),
	(142, 1, 'steam:11000014bf543e0', 'GD', '1785957997', 'Exit(Server shutting down: SIGHUP received)'),
	(143, 1, 'steam:11000014bf543e0', 'GD', '1785992588', 'Enter'),
	(144, 1, 'steam:11000014bf543e0', 'GD', '1785994273', 'Exit(Exiting)'),
	(145, 1, 'steam:11000014bf543e0', 'GD', '1785994694', 'Enter'),
	(146, 1, 'steam:11000014bf543e0', 'GD', '1785995558', 'Exit(Server shutting down: SIGHUP received)'),
	(147, 1, 'steam:11000014bf543e0', 'GD', '1786000322', 'Enter'),
	(148, 1, 'steam:11000014bf543e0', 'GD', '1786002066', 'Exit(Server shutting down: SIGHUP received)'),
	(149, 1, 'steam:11000014bf543e0', 'GD', '1786024393', 'Enter'),
	(150, 1, 'steam:11000014bf543e0', 'GD', '1786027763', 'Exit(Exiting)'),
	(151, 1, 'steam:11000014bf543e0', 'GD', '1786045743', 'Enter'),
	(152, 1, 'steam:11000014bf543e0', 'GD', '1786047170', 'Exit(Exiting)'),
	(153, 1, 'steam:11000014bf543e0', 'GD', '1786080963', 'Enter'),
	(154, 1, 'steam:11000014bf543e0', 'GD', '1786081985', 'Exit(Exiting)'),
	(155, 1, 'steam:11000014bf543e0', 'GD', '1786082590', 'Enter'),
	(156, 1, 'steam:11000014bf543e0', 'GD', '1786083148', 'Exit(Exiting)'),
	(157, 1, 'steam:11000014bf543e0', 'GD', '1786086282', 'Enter'),
	(158, 1, 'steam:11000014bf543e0', 'GD', '1786087005', 'Exit(Server->client connection timed out. Last see'),
	(159, 1, 'steam:11000014bf543e0', 'GD', '1786098786', 'Enter'),
	(160, 1, 'steam:11000014bf543e0', 'GD', '1786099133', 'Exit(Exiting)'),
	(161, 1, 'steam:11000014bf543e0', 'GD', '1786142949', 'Enter'),
	(162, 1, 'steam:11000014bf543e0', 'GD', '1786143142', 'Exit(\n[🔥 UNIQUE_AC 🔥]\n⛔️ You\'ve been banned from t'),
	(163, 1, 'steam:11000014bf543e0', 'GD', '1786175799', 'Enter'),
	(164, 1, 'steam:11000014bf543e0', 'GD', '1786176657', 'Exit(Server->client connection timed out. Last see'),
	(165, 1, 'steam:11000014bf543e0', 'GD', '1786177234', 'Enter'),
	(166, 1, 'steam:11000014bf543e0', 'GD', '1786177527', 'Exit(Reliable network event overflow.)'),
	(167, 2, 'steam:11000014bf543e0', 'GD', '1786177584', 'Enter'),
	(168, 2, 'steam:11000014bf543e0', 'GD', '1786177765', 'Exit(Server->client connection timed out. Last see'),
	(169, 1, 'steam:11000014bf543e0', 'GD', '1786178192', 'Enter'),
	(170, 1, 'steam:11000014bf543e0', 'GD', '1786178424', 'Exit(Exiting)'),
	(171, 1, 'steam:11000014bf543e0', 'GD', '1786200233', 'Enter'),
	(172, 1, 'steam:11000014bf543e0', 'GD', '1786200511', 'Exit(Server shutting down: SIGHUP received)'),
	(173, 1, 'steam:11000014bf543e0', 'GD', '1786225542', 'Enter'),
	(174, 1, 'steam:11000014bf543e0', 'GD', '1786225615', 'Exit(Server->client connection timed out. Last see'),
	(175, 1, 'steam:11000014bf543e0', 'GD', '1786225784', 'Enter'),
	(176, 1, 'steam:11000014bf543e0', 'GD', '1786226887', 'Exit(Server->client connection timed out. Last see'),
	(177, 1, 'steam:11000014bf543e0', 'GD', '1786227523', 'Enter'),
	(178, 1, 'steam:11000014bf543e0', 'GD', '1786227914', 'Exit(Server shutting down: SIGHUP received)'),
	(179, 1, 'steam:11000014bf543e0', 'GD', '1786257540', 'Enter'),
	(180, 1, 'steam:11000014bf543e0', 'GD', '1786258036', 'Exit(Server->client connection timed out. Last see'),
	(181, 1, 'steam:11000014bf543e0', 'GD', '1786273616', 'Enter'),
	(182, 1, 'steam:11000014bf543e0', 'GD', '1786273725', 'Exit(Server shutting down: SIGHUP received)'),
	(183, 1, 'steam:11000014bf543e0', 'GD', '1786302359', 'Enter'),
	(184, 1, 'steam:11000014bf543e0', 'GD', '1786302756', 'Exit(Server shutting down: SIGHUP received)'),
	(185, 1, 'steam:11000014bf543e0', 'GD', '1786347145', 'Enter'),
	(186, 1, 'steam:11000014bf543e0', 'GD', '1786347722', 'Exit(Server shutting down: SIGHUP received)'),
	(187, 1, 'steam:11000014bf543e0', 'GD', '1786354030', 'Enter'),
	(188, 1, 'steam:11000014bf543e0', 'GD', '1786354357', 'Exit(Exiting)'),
	(189, 1, 'steam:11000014bf543e0', 'GD', '1786386704', 'Enter'),
	(190, 1, 'steam:11000014bf543e0', 'GD', '1786429858', 'Enter'),
	(191, 1, 'steam:11000014bf543e0', 'GD', '1786431431', 'Exit(Server shutting down: SIGHUP received)'),
	(192, 1, 'steam:11000014bf543e0', 'GD', '1786431541', 'Enter'),
	(193, 1, 'steam:11000014bf543e0', 'GD', '1786431693', 'Exit(Server shutting down: SIGHUP received)'),
	(194, 1, 'steam:11000014bf543e0', 'GD', '1786446565', 'Enter'),
	(195, 1, 'steam:11000014bf543e0', 'GD', '1786447559', 'Exit([txAdmin] Server restarting (admin request).)'),
	(196, 1, 'steam:11000014bf543e0', 'GD', '1786447618', 'Enter'),
	(197, 1, 'steam:11000014bf543e0', 'GD', '1786448708', 'Exit(Server shutting down: SIGHUP received)'),
	(198, 1, 'steam:11000014bf543e0', 'GD', '1786450701', 'Enter'),
	(199, 1, 'steam:11000014bf543e0', 'GD', '1786452015', 'Exit(Server->client connection timed out. Last see'),
	(200, 1, 'steam:11000014bf543e0', 'GD', '1786476783', 'Enter'),
	(201, 1, 'steam:11000014bf543e0', 'GD', '1786477699', 'Exit(Exiting)'),
	(202, 1, 'steam:11000014bf543e0', 'GD', '1786477839', 'Enter'),
	(203, 1, 'steam:11000014bf543e0', 'GD', '1786478385', 'Exit(Exiting)'),
	(204, 1, 'steam:11000014bf543e0', 'GD', '1786518575', 'Enter'),
	(205, 1, 'steam:11000014bf543e0', 'GD', '1786519854', 'Exit(Server shutting down: SIGHUP received)'),
	(206, 1, 'steam:11000014bf543e0', 'GD', '1786564703', 'Enter'),
	(207, 1, 'steam:11000014bf543e0', 'GD', '1786565690', 'Exit(Exiting)'),
	(208, 1, 'steam:11000014bf543e0', 'GD', '1786601489', 'Enter'),
	(209, 1, 'steam:11000014bf543e0', 'GD', '1786602347', 'Exit(Server shutting down: SIGHUP received)'),
	(210, 1, 'steam:11000014bf543e0', 'GD', '1786610948', 'Enter'),
	(211, 1, 'steam:11000014bf543e0', 'GD', '1786611180', 'Exit(Exiting)'),
	(212, 1, 'steam:11000014bf543e0', 'GD', '1786687198', 'Enter'),
	(213, 1, 'steam:11000014bf543e0', 'GD', '1786688700', 'Exit(Server shutting down: SIGHUP received)'),
	(214, 1, 'steam:11000014bf543e0', 'GD', '1786689313', 'Enter'),
	(215, 1, 'steam:11000014bf543e0', 'GD', '1786689722', 'Exit(Server shutting down: SIGHUP received)'),
	(216, 1, 'steam:11000014bf543e0', 'GD', '1786690108', 'Enter'),
	(217, 1, 'steam:11000014bf543e0', 'GD', '1786690369', 'Exit(Server shutting down: SIGHUP received)'),
	(218, 1, 'steam:11000014bf543e0', 'GD', '1786698194', 'Enter'),
	(219, 1, 'steam:11000014bf543e0', 'GD', '1786701592', 'Exit(Exiting)'),
	(220, 1, 'steam:11000014bf543e0', 'GD', '1786708993', 'Enter'),
	(221, 1, 'steam:11000014bf543e0', 'GD', '1786710237', 'Exit(Server shutting down: SIGHUP received)'),
	(222, 1, 'steam:11000014bf543e0', 'GD', '1786723387', 'Enter'),
	(223, 1, 'steam:11000014bf543e0', 'GD', '1786724425', 'Exit(Exiting)'),
	(224, 1, 'steam:11000014bf543e0', 'GD', '1786773472', 'Enter'),
	(225, 1, 'steam:11000014bf543e0', 'GD', '1786773965', 'Exit(Server shutting down: SIGHUP received)'),
	(226, 1, 'steam:11000014bf543e0', 'GD', '1786774275', 'Enter'),
	(227, 1, 'steam:11000014bf543e0', 'GD', '1786775403', 'Exit(Server shutting down: SIGHUP received)'),
	(228, 1, 'steam:11000014bf543e0', 'GD', '1786775620', 'Enter'),
	(229, 1, 'steam:11000014bf543e0', 'GD', '1786776232', 'Exit(Server shutting down: SIGHUP received)'),
	(230, 1, 'steam:11000014bf543e0', 'GD', '1786777211', 'Enter'),
	(231, 1, 'steam:11000014bf543e0', 'GD', '1786777893', 'Exit(Server shutting down: SIGHUP received)'),
	(232, 1, 'steam:11000014bf543e0', 'GD', '1786782978', 'Enter'),
	(233, 1, 'steam:11000014bf543e0', 'GD', '1786783244', 'Exit(Server shutting down: SIGHUP received)'),
	(234, 1, 'steam:11000014bf543e0', 'GD', '1786791239', 'Enter'),
	(235, 1, 'steam:11000014bf543e0', 'GD', '1786791916', 'Exit(Server shutting down: SIGHUP received)'),
	(236, 1, 'steam:11000014bf543e0', 'GD', '1786792099', 'Enter'),
	(237, 1, 'steam:11000014bf543e0', 'GD', '1786792974', 'Exit(Server->client connection timed out. Last see'),
	(238, 1, 'steam:11000014bf543e0', 'GD', '1786793169', 'Enter'),
	(239, 1, 'steam:11000014bf543e0', 'GD', '1786793505', 'Exit(Exiting)'),
	(240, 1, 'steam:11000014bf543e0', 'GD', '1786794588', 'Enter'),
	(241, 1, 'steam:11000014bf543e0', 'GD', '1786795130', 'Exit(Server shutting down: SIGHUP received)'),
	(242, 1, 'steam:11000014bf543e0', 'GD', '1786796354', 'Enter'),
	(243, 1, 'steam:11000014bf543e0', 'GD', '1786796854', 'Exit(Server shutting down: SIGHUP received)'),
	(244, 1, 'steam:11000014bf543e0', 'GD', '1786807778', 'Enter'),
	(245, 1, 'steam:11000014bf543e0', 'GD', '1786808545', 'Exit(Server shutting down: SIGHUP received)'),
	(246, 1, 'steam:11000014bf543e0', 'GD', '1786809538', 'Enter'),
	(247, 1, 'steam:11000014bf543e0', 'GD', '1786811016', 'Exit(Server shutting down: SIGHUP received)'),
	(248, 1, 'steam:11000014bf543e0', 'GD', '1786828263', 'Enter'),
	(249, 1, 'steam:11000014bf543e0', 'GD', '1786829041', 'Exit(Exiting)'),
	(250, 1, 'steam:11000014bf543e0', 'GD', '1786867186', 'Enter'),
	(251, 1, 'steam:11000014bf543e0', 'GD', '1786869639', 'Exit(Server shutting down: SIGHUP received)'),
	(252, 1, 'steam:11000014bf543e0', 'GD', '1786884058', 'Enter'),
	(253, 1, 'steam:11000014bf543e0', 'GD', '1786889490', 'Exit(Exiting)'),
	(254, 1, 'steam:11000014bf543e0', 'GD', '1786905708', 'Enter'),
	(255, 1, 'steam:11000014bf543e0', 'GD', '1786907199', 'Exit(Server shutting down: SIGHUP received)'),
	(256, 1, 'steam:11000014bf543e0', 'GD', '1786907555', 'Enter'),
	(257, 1, 'steam:11000014bf543e0', 'GD', '1786907844', 'Exit(Exiting)'),
	(258, 1, 'steam:11000014bf543e0', 'GD', '1786939211', 'Enter'),
	(259, 1, 'steam:11000014bf543e0', 'GD', '1786942067', 'Exit(Exiting)'),
	(260, 1, 'steam:11000014bf543e0', 'GD', '1786942800', 'Enter'),
	(261, 1, 'steam:11000014bf543e0', 'GD', '1786942862', 'Exit(You have been banned for 1 minutes.\nReason: 1'),
	(262, 2, 'steam:11000014bf543e0', 'GD', '1786942918', 'Enter'),
	(263, 2, 'steam:11000014bf543e0', 'GD', '1786944436', 'Exit(Server->client connection timed out. Last see'),
	(264, 1, 'steam:11000014bf543e0', 'GD', '1786958518', 'Enter'),
	(265, 1, 'steam:11000014bf543e0', 'GD', '1786961823', 'Exit(Server shutting down: SIGHUP received)'),
	(266, 1, 'steam:11000014bf543e0', 'GD', '1786964588', 'Enter'),
	(267, 1, 'steam:11000014bf543e0', 'GD', '1786965684', 'Exit(Server shutting down: SIGHUP received)'),
	(268, 1, 'steam:11000014bf543e0', 'GD', '1786966342', 'Enter'),
	(269, 1, 'steam:11000014bf543e0', 'GD', '1786966594', 'Exit(Server shutting down: SIGHUP received)'),
	(270, 1, 'steam:11000014bf543e0', 'GD', '1786967688', 'Enter'),
	(271, 1, 'steam:11000014bf543e0', 'GD', '1786968156', 'Exit(Server shutting down: SIGHUP received)'),
	(272, 1, 'steam:11000014bf543e0', 'GD', '1786968606', 'Enter'),
	(273, 1, 'steam:11000014bf543e0', 'GD', '1786968656', 'Exit(Server shutting down: SIGHUP received)'),
	(274, 1, 'steam:11000014bf543e0', 'GD', '1786981503', 'Enter'),
	(275, 1, 'steam:11000014bf543e0', 'GD', '1786982220', 'Exit(Server shutting down: SIGHUP received)'),
	(276, 1, 'steam:11000014bf543e0', 'GD', '1787029777', 'Enter'),
	(277, 1, 'steam:11000014bf543e0', 'GD', '1787031101', 'Exit(Server shutting down: SIGHUP received)'),
	(278, 1, 'steam:11000014bf543e0', 'GD', '1787032360', 'Enter'),
	(279, 1, 'steam:11000014bf543e0', 'GD', '1787032990', 'Exit(Server shutting down: SIGHUP received)'),
	(280, 1, 'steam:11000014bf543e0', 'GD', '1787033109', 'Enter'),
	(281, 1, 'steam:11000014bf543e0', 'GD', '1787033286', 'Exit(Server shutting down: SIGHUP received)'),
	(282, 1, 'steam:11000014bf543e0', 'GD', '1787033706', 'Enter'),
	(283, 1, 'steam:11000014bf543e0', 'GD', '1787034258', 'Exit(Server shutting down: SIGHUP received)'),
	(284, 1, 'steam:11000014bf543e0', 'GD', '1787034396', 'Enter'),
	(285, 1, 'steam:11000014bf543e0', 'GD', '1787034628', 'Exit(Server shutting down: SIGHUP received)'),
	(286, 1, 'steam:11000014bf543e0', 'GD', '1787034817', 'Enter'),
	(287, 1, 'steam:11000014bf543e0', 'GD', '1787034980', 'Exit(Exiting)'),
	(288, 1, 'steam:11000014bf543e0', 'GD', '1787049211', 'Enter'),
	(289, 1, 'steam:11000014bf543e0', 'GD', '1787049585', 'Exit(Exiting)'),
	(290, 1, 'steam:11000014bf543e0', 'GD', '1787050345', 'Enter'),
	(291, 1, 'steam:11000014bf543e0', 'GD', '1787051562', 'Exit(Exiting)'),
	(292, 1, 'steam:11000014bf543e0', 'GD', '1787053190', 'Enter'),
	(293, 1, 'steam:11000014bf543e0', 'GD', '1787053544', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(294, 2, 'steam:11000014bf543e0', 'GD', '1787053603', 'Enter'),
	(295, 2, 'steam:11000014bf543e0', 'GD', '1787053618', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(296, 1, 'steam:11000014bf543e0', 'GD', '1787066788', 'Enter'),
	(297, 1, 'steam:11000014bf543e0', 'GD', '1787067614', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(298, 2, 'steam:11000014bf543e0', 'GD', '1787067669', 'Enter'),
	(299, 2, 'steam:11000014bf543e0', 'GD', '1787067942', 'Exit(Server shutting down: SIGHUP received)'),
	(300, 1, 'steam:11000014bf543e0', 'GD', '1787086741', 'Enter'),
	(301, 1, 'steam:11000014bf543e0', 'GD', '1787086767', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(302, 2, 'steam:11000014bf543e0', 'GD', '1787086882', 'Enter'),
	(303, 2, 'steam:11000014bf543e0', 'GD', '1787086884', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(304, 3, 'steam:11000014bf543e0', 'GD', '1787086953', 'Enter'),
	(305, 3, 'steam:11000014bf543e0', 'GD', '1787087934', 'Exit(Server->client connection timed out. Last see'),
	(306, 1, 'steam:11000014bf543e0', 'GD', '1787125716', 'Enter'),
	(307, 1, 'steam:11000014bf543e0', 'GD', '1787125717', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(308, 2, 'steam:11000014bf543e0', 'GD', '1787125786', 'Enter'),
	(309, 2, 'steam:11000014bf543e0', 'GD', '1787126487', 'Exit(Server shutting down: SIGHUP received)'),
	(310, 1, 'steam:11000014bf543e0', 'GD', '1787133952', 'Enter'),
	(311, 1, 'steam:11000014bf543e0', 'GD', '1787133953', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(312, 2, 'steam:11000014bf543e0', 'GD', '1787134040', 'Enter'),
	(313, 2, 'steam:11000014bf543e0', 'GD', '1787134347', 'Exit(Server->client connection timed out. Last see'),
	(314, 1, 'steam:11000014bf543e0', 'GD', '1787134692', 'Enter'),
	(315, 1, 'steam:11000014bf543e0', 'GD', '1787134693', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(316, 2, 'steam:11000014bf543e0', 'GD', '1787134788', 'Enter'),
	(317, 2, 'steam:11000014bf543e0', 'GD', '1787134835', 'Exit(Server->client connection timed out. Last see'),
	(318, 1, 'steam:11000014bf543e0', 'GD', '1787160845', 'Enter'),
	(319, 1, 'steam:11000014bf543e0', 'GD', '1787160845', 'Exit(متاسفانه سیستم امنیتی رفتار مشکوکی رو در حساب'),
	(320, 2, 'steam:11000014bf543e0', 'GD', '1787160959', 'Enter'),
	(321, 2, 'steam:11000014bf543e0', 'GD', '1787161307', 'Exit(Server shutting down: SIGHUP received)'),
	(322, 1, 'steam:11000014bf543e0', 'GD', '1787173115', 'Enter'),
	(323, 1, 'steam:11000014bf543e0', 'GD', '1787173445', 'Exit(Server shutting down: SIGHUP received)'),
	(324, 1, 'steam:11000014bf543e0', 'GD', '1787175079', 'Enter'),
	(325, 1, 'steam:11000014bf543e0', 'GD', '1787175298', 'Exit(Exiting)'),
	(326, 1, 'steam:11000014bf543e0', 'GD', '1787209990', 'Enter'),
	(327, 1, 'steam:11000014bf543e0', 'GD', '1787210771', 'Exit(Server shutting down: SIGHUP received)'),
	(328, 1, 'steam:11000014bf543e0', 'GD', '1787228211', 'Enter'),
	(329, 1, 'steam:11000014bf543e0', 'GD', '1787229119', 'Exit(Exiting)'),
	(330, 1, 'steam:11000014bf543e0', 'GD', '1787419622', 'Enter'),
	(331, 1, 'steam:11000014bf543e0', 'GD', '1787420303', 'Exit([txAdmin] Server restarting (admin request).)'),
	(332, 1, 'steam:11000014bf543e0', 'GD', '1787421635', 'Enter'),
	(333, 1, 'steam:11000014bf543e0', 'GD', '1787422086', 'Exit(Server shutting down: SIGHUP received)'),
	(334, 1, 'steam:11000014bf543e0', 'GD', '1787422154', 'Enter'),
	(335, 1, 'steam:11000014bf543e0', 'GD', '1787425278', 'Exit(Server shutting down: SIGHUP received)'),
	(336, 1, 'steam:11000014bf543e0', 'GD', '1787476027', 'Enter'),
	(337, 1, 'steam:11000014bf543e0', 'GD', '1787476972', 'Exit(Exiting)'),
	(338, 1, 'steam:11000014bf543e0', 'GD', '1787477064', 'Enter'),
	(339, 1, 'steam:11000014bf543e0', 'GD', '1787478260', 'Exit(Server shutting down: SIGHUP received)'),
	(340, 1, 'steam:11000014bf543e0', 'GD', '1787494898', 'Enter'),
	(341, 1, 'steam:11000014bf543e0', 'GD', '1787496577', 'Exit(Exiting)'),
	(342, 1, 'steam:11000014bf543e0', 'GD', '1787506126', 'Enter'),
	(343, 1, 'steam:11000014bf543e0', 'GD', '1787507872', 'Exit(Exiting)'),
	(344, 1, 'steam:11000014bf543e0', 'GD', '1787508709', 'Enter'),
	(345, 1, 'steam:11000014bf543e0', 'GD', '1787508970', 'Exit([txAdmin] Server restarting (admin request).)'),
	(346, 1, 'steam:11000014bf543e0', 'GD', '1787509042', 'Enter'),
	(347, 1, 'steam:11000014bf543e0', 'GD', '1787509597', 'Exit(Server shutting down: SIGHUP received)'),
	(348, 1, 'steam:11000014bf543e0', 'GD', '1787510724', 'Enter'),
	(349, 1, 'steam:11000014bf543e0', 'GD', '1787511635', 'Exit([txAdmin] Server restarting (admin request).)'),
	(350, 1, 'steam:11000014bf543e0', 'GD', '1787511700', 'Enter'),
	(351, 1, 'steam:11000014bf543e0', 'GD', '1787512675', 'Exit(Server->client connection timed out. Last see'),
	(352, 1, 'steam:11000014bf543e0', 'GD', '1787513161', 'Enter'),
	(353, 1, 'steam:11000014bf543e0', 'GD', '1787513881', 'Exit(Server->client connection timed out. Last see'),
	(354, 1, 'steam:11000014bf543e0', 'GD', '1787562866', 'Enter'),
	(355, 1, 'steam:11000014bf543e0', 'GD', '1787564196', 'Exit(Server shutting down: SIGHUP received)'),
	(356, 1, 'steam:11000014bf543e0', 'GD', '1787580060', 'Enter'),
	(357, 1, 'steam:11000014bf543e0', 'GD', '1787581935', 'Exit(Server shutting down: SIGHUP received)'),
	(358, 1, 'steam:11000014bf543e0', 'GD', '1787583696', 'Enter'),
	(359, 1, 'steam:11000014bf543e0', 'GD', '1787583895', 'Exit(Exiting)'),
	(360, 1, 'steam:11000014bf543e0', 'GD', '1787600590', 'Enter'),
	(361, 1, 'steam:11000014bf543e0', 'GD', '1787601602', 'Exit(Server->client connection timed out. Last see'),
	(362, 1, 'steam:11000014bf543e0', 'GD', '1787602016', 'Enter'),
	(363, 1, 'steam:11000014bf543e0', 'GD', '1787602448', 'Exit(Server shutting down: SIGHUP received)'),
	(364, 1, 'steam:11000014bf543e0', 'GD', '1787602608', 'Enter'),
	(365, 1, 'steam:11000014bf543e0', 'GD', '1787602772', 'Exit(Server->client connection timed out. Last see'),
	(366, 1, 'steam:11000014bf543e0', 'GD', '1787603580', 'Enter'),
	(367, 1, 'steam:11000014bf543e0', 'GD', '1787603660', 'Exit(Exiting)'),
	(368, 1, 'steam:11000014bf543e0', 'GD', '1787643602', 'Enter'),
	(369, 1, 'steam:11000014bf543e0', 'GD', '1787644439', 'Exit([txAdmin] Server restarting (admin request).)'),
	(370, 1, 'steam:11000014bf543e0', 'GD', '1787644493', 'Enter'),
	(371, 1, 'steam:11000014bf543e0', 'GD', '1787644570', 'Exit([txAdmin] Server restarting (admin request).)'),
	(372, 1, 'steam:11000014bf543e0', 'GD', '1787644624', 'Enter'),
	(373, 1, 'steam:11000014bf543e0', 'GD', '1787662552', 'Enter'),
	(374, 1, 'steam:11000014bf543e0', 'GD', '1787663867', 'Exit(Server shutting down: SIGHUP received)'),
	(375, 1, 'steam:11000014bf543e0', 'GD', '1787728800', 'Enter'),
	(376, 1, 'steam:11000014bf543e0', 'GD', '1787729526', 'Exit([txAdmin] Server restarting (admin request).)'),
	(377, 1, 'steam:11000014bf543e0', 'GD', '1787729591', 'Enter'),
	(378, 1, 'steam:11000014bf543e0', 'GD', '1787730007', 'Exit([txAdmin] Server restarting (admin request).)'),
	(379, 1, 'steam:11000014bf543e0', 'GD', '1787730065', 'Enter'),
	(380, 1, 'steam:11000014bf543e0', 'GD', '1787730218', 'Exit(Server shutting down: SIGHUP received)'),
	(381, 1, 'steam:11000014bf543e0', 'GD', '1787731391', 'Enter'),
	(382, 1, 'steam:11000014bf543e0', 'GD', '1787731532', 'Exit(Exiting)');

-- Dumping structure for table essentialmode.bag_inventories
DROP TABLE IF EXISTS `bag_inventories`;
CREATE TABLE IF NOT EXISTS `bag_inventories` (
  `bag_id` int(11) NOT NULL,
  `items` longtext NOT NULL DEFAULT '[]',
  `slots` int(11) NOT NULL DEFAULT 41,
  PRIMARY KEY (`bag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.bag_inventories: ~0 rows (approximately)

-- Dumping structure for table essentialmode.baninfo
DROP TABLE IF EXISTS `baninfo`;
CREATE TABLE IF NOT EXISTS `baninfo` (
  `identifier` varchar(25) NOT NULL,
  `license` varchar(50) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `playername` varchar(32) DEFAULT NULL,
  `oocname` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.baninfo: ~0 rows (approximately)
REPLACE INTO `baninfo` (`identifier`, `license`, `liveid`, `xblid`, `discord`, `playerip`, `playername`, `oocname`) VALUES
	('steam:11000014bf543e0', 'license:153122398469261248', 'no info', 'no info', 'no info', 'ip:192.168.1.110', 'Arshia_Mtz', 'GD');

-- Dumping structure for table essentialmode.banlist
DROP TABLE IF EXISTS `banlist`;
CREATE TABLE IF NOT EXISTS `banlist` (
  `identifier` varchar(25) NOT NULL,
  `license` varchar(50) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `targetplayername` varchar(32) NOT NULL,
  `sourceplayername` varchar(32) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` varchar(50) NOT NULL,
  `expiration` varchar(50) NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.banlist: ~0 rows (approximately)
REPLACE INTO `banlist` (`identifier`, `license`, `liveid`, `xblid`, `discord`, `playerip`, `targetplayername`, `sourceplayername`, `reason`, `timeat`, `expiration`, `permanent`) VALUES
	('steam:11000014bf543e0', 'license:153122398469261248', 'no info', 'no info', 'no info', '172.20.10.2', 'GD', 'GD', '1', '1786942862', '1786942922', 0);

-- Dumping structure for table essentialmode.banlisthistory
DROP TABLE IF EXISTS `banlisthistory`;
CREATE TABLE IF NOT EXISTS `banlisthistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(25) NOT NULL,
  `license` varchar(50) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `targetplayername` varchar(32) NOT NULL,
  `sourceplayername` varchar(32) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` int(11) NOT NULL,
  `added` varchar(40) NOT NULL,
  `expiration` int(11) NOT NULL,
  `permanent` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.banlisthistory: ~0 rows (approximately)
REPLACE INTO `banlisthistory` (`id`, `identifier`, `license`, `liveid`, `xblid`, `discord`, `playerip`, `targetplayername`, `sourceplayername`, `reason`, `timeat`, `added`, `expiration`, `permanent`) VALUES
	(1, 'steam:11000014bf543e0', 'license:153122398469261248', 'no info', 'no info', 'no info', '172.20.10.2', 'GD', 'GD', '1', 1786942862, '2026-08-17 08:31:02', 1786942922, 0);

-- Dumping structure for table essentialmode.billing
DROP TABLE IF EXISTS `billing`;
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.billing: ~0 rows (approximately)

-- Dumping structure for table essentialmode.branch_job_memory
DROP TABLE IF EXISTS `branch_job_memory`;
CREATE TABLE IF NOT EXISTS `branch_job_memory` (
  `identifier` varchar(60) NOT NULL,
  `original_job` varchar(50) NOT NULL,
  `original_grade` int(11) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.branch_job_memory: ~1 rows (approximately)
REPLACE INTO `branch_job_memory` (`identifier`, `original_job`, `original_grade`) VALUES
	('steam:11000014bf543e0', 'police', 21);

-- Dumping structure for table essentialmode.capture
DROP TABLE IF EXISTS `capture`;
CREATE TABLE IF NOT EXISTS `capture` (
  `name` varchar(50) NOT NULL,
  `handeler` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture: ~0 rows (approximately)
REPLACE INTO `capture` (`name`, `handeler`) VALUES
	('drug', 'none');

-- Dumping structure for table essentialmode.capture_academy_stats
DROP TABLE IF EXISTS `capture_academy_stats`;
CREATE TABLE IF NOT EXISTS `capture_academy_stats` (
  `identifier` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `kills` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_academy_stats: ~0 rows (approximately)
REPLACE INTO `capture_academy_stats` (`identifier`, `name`, `kills`) VALUES
	('steam:11000014bf543e0', 'GD', 72);

-- Dumping structure for table essentialmode.capture_gang_season_archive
DROP TABLE IF EXISTS `capture_gang_season_archive`;
CREATE TABLE IF NOT EXISTS `capture_gang_season_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL,
  `gang_name` varchar(50) NOT NULL,
  `points` int(11) DEFAULT 0,
  `rank_position` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_gang_season_archive: ~0 rows (approximately)

-- Dumping structure for table essentialmode.capture_gang_stats
DROP TABLE IF EXISTS `capture_gang_stats`;
CREATE TABLE IF NOT EXISTS `capture_gang_stats` (
  `gang_name` varchar(50) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gang_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_gang_stats: ~0 rows (approximately)
REPLACE INTO `capture_gang_stats` (`gang_name`, `points`) VALUES
	('A', 112);

-- Dumping structure for table essentialmode.capture_hall_of_fame
DROP TABLE IF EXISTS `capture_hall_of_fame`;
CREATE TABLE IF NOT EXISTS `capture_hall_of_fame` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `career_kills` int(11) DEFAULT 0,
  `career_gang_points` int(11) DEFAULT 0,
  `final_rank` varchar(20) DEFAULT NULL,
  `inducted_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_unique` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_hall_of_fame: ~0 rows (approximately)

-- Dumping structure for table essentialmode.capture_history
DROP TABLE IF EXISTS `capture_history`;
CREATE TABLE IF NOT EXISTS `capture_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `round_date` datetime NOT NULL,
  `winner_gang` varchar(50) DEFAULT NULL,
  `winner_points` int(11) DEFAULT 0,
  `top_killer_name` varchar(100) DEFAULT NULL,
  `top_killer_kills` int(11) DEFAULT 0,
  `top_gangs_json` text DEFAULT NULL,
  `top_killers_json` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_history: ~2 rows (approximately)
REPLACE INTO `capture_history` (`id`, `round_date`, `winner_gang`, `winner_points`, `top_killer_name`, `top_killer_kills`, `top_gangs_json`, `top_killers_json`) VALUES
	(1, '2026-08-09 01:32:21', 'A', 52, NULL, 0, '[{"Name":"A","Logo":"defaultlogo","Points":52}]', '[]'),
	(2, '2026-08-09 01:51:32', 'A', 4, NULL, 0, '[{"Points":4,"Logo":"defaultlogo","Name":"A"}]', '[]'),
	(3, '2026-08-09 10:12:52', 'A', 4, NULL, 0, '[{"Points":4,"Logo":"defaultlogo","Name":"A"}]', '[]'),
	(4, '2026-08-11 10:05:48', 'A', 5, NULL, 0, '[{"Points":5,"Name":"A","Logo":"defaultlogo"}]', '[]'),
	(5, '2026-08-16 17:11:27', NULL, 0, NULL, 0, '[]', '[]');

-- Dumping structure for table essentialmode.capture_meta
DROP TABLE IF EXISTS `capture_meta`;
CREATE TABLE IF NOT EXISTS `capture_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL DEFAULT 1,
  `last_reset` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_meta: ~0 rows (approximately)
REPLACE INTO `capture_meta` (`id`, `season_number`, `last_reset`) VALUES
	(1, 1, '2026-08-09 09:59:27');

-- Dumping structure for table essentialmode.capture_player_stats
DROP TABLE IF EXISTS `capture_player_stats`;
CREATE TABLE IF NOT EXISTS `capture_player_stats` (
  `identifier` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `kills` int(11) NOT NULL DEFAULT 0,
  `deaths` int(11) NOT NULL DEFAULT 0,
  `top5_count` int(11) NOT NULL DEFAULT 0,
  `gang_points` int(11) NOT NULL DEFAULT 0,
  `last_rank` varchar(20) DEFAULT 'Bronze',
  `last_active` datetime DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_player_stats: ~0 rows (approximately)
REPLACE INTO `capture_player_stats` (`identifier`, `name`, `kills`, `deaths`, `top5_count`, `gang_points`, `last_rank`, `last_active`) VALUES
	('steam:11000014bf543e0', 'GD', 0, 0, 0, 58, 'Silver', '2026-08-12 11:00:41');

-- Dumping structure for table essentialmode.capture_player_zone_stats
DROP TABLE IF EXISTS `capture_player_zone_stats`;
CREATE TABLE IF NOT EXISTS `capture_player_zone_stats` (
  `identifier` varchar(60) NOT NULL,
  `zone_name` varchar(100) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`,`zone_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_player_zone_stats: ~3 rows (approximately)
REPLACE INTO `capture_player_zone_stats` (`identifier`, `zone_name`, `points`) VALUES
	('steam:11000014bf543e0', 'Bandar', 2),
	('steam:11000014bf543e0', 'Mineri', 7),
	('steam:11000014bf543e0', 'Sherkat Naft', 44);

-- Dumping structure for table essentialmode.capture_playoffs
DROP TABLE IF EXISTS `capture_playoffs`;
CREATE TABLE IF NOT EXISTS `capture_playoffs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL,
  `match_label` varchar(50) NOT NULL,
  `gang_a` varchar(50) DEFAULT NULL,
  `gang_b` varchar(50) DEFAULT NULL,
  `winner` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_playoffs: ~0 rows (approximately)

-- Dumping structure for table essentialmode.capture_scarce_medals
DROP TABLE IF EXISTS `capture_scarce_medals`;
CREATE TABLE IF NOT EXISTS `capture_scarce_medals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL,
  `serial_number` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `awarded_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `season_serial` (`season_number`,`serial_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_scarce_medals: ~0 rows (approximately)

-- Dumping structure for table essentialmode.capture_season_archive
DROP TABLE IF EXISTS `capture_season_archive`;
CREATE TABLE IF NOT EXISTS `capture_season_archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `kills` int(11) DEFAULT 0,
  `deaths` int(11) DEFAULT 0,
  `gang_points` int(11) DEFAULT 0,
  `top5_count` int(11) DEFAULT 0,
  `score` int(11) DEFAULT 0,
  `rank_position` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_season_archive: ~0 rows (approximately)

-- Dumping structure for table essentialmode.capture_seasons
DROP TABLE IF EXISTS `capture_seasons`;
CREATE TABLE IF NOT EXISTS `capture_seasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `season_number` int(11) NOT NULL,
  `ended_date` datetime NOT NULL,
  `winner_identifier` varchar(60) DEFAULT NULL,
  `winner_name` varchar(100) DEFAULT NULL,
  `winner_score` int(11) DEFAULT 0,
  `winner_gang_name` varchar(50) DEFAULT NULL,
  `winner_gang_points` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.capture_seasons: ~0 rows (approximately)

-- Dumping structure for table essentialmode.cardealer_vehicles
DROP TABLE IF EXISTS `cardealer_vehicles`;
CREATE TABLE IF NOT EXISTS `cardealer_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.cardealer_vehicles: ~0 rows (approximately)

-- Dumping structure for table essentialmode.communityservice
DROP TABLE IF EXISTS `communityservice`;
CREATE TABLE IF NOT EXISTS `communityservice` (
  `identifier` varchar(60) NOT NULL,
  `actions_remaining` int(11) NOT NULL DEFAULT 0,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.communityservice: ~0 rows (approximately)

-- Dumping structure for table essentialmode.counter
DROP TABLE IF EXISTS `counter`;
CREATE TABLE IF NOT EXISTS `counter` (
  `owner` varchar(60) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `job` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.counter: ~0 rows (approximately)

-- Dumping structure for table essentialmode.crypto_transactions
DROP TABLE IF EXISTS `crypto_transactions`;
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.crypto_transactions: ~0 rows (approximately)

-- Dumping structure for table essentialmode.custom_names
DROP TABLE IF EXISTS `custom_names`;
CREATE TABLE IF NOT EXISTS `custom_names` (
  `entity_job` varchar(50) NOT NULL,
  `custom_label` varchar(50) NOT NULL,
  PRIMARY KEY (`entity_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.custom_names: ~0 rows (approximately)

-- Dumping structure for table essentialmode.datastore
DROP TABLE IF EXISTS `datastore`;
CREATE TABLE IF NOT EXISTS `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.datastore: ~16 rows (approximately)
REPLACE INTO `datastore` (`name`, `label`, `shared`) VALUES
	('gang_a', 'gang', 1),
	('property', 'Property', 0),
	('society_ambulance', 'Ambulance', 1),
	('society_cardealer', 'Cardealer', 1),
	('society_concess', 'Concessionnaire', 1),
	('society_fbi', 'fbi', 1),
	('society_mechanic', 'MÃ©cano', 1),
	('society_mt', 'Metropolitan Police', 1),
	('society_police', 'Police', 1),
	('society_sheriff', 'Sheriff', 1),
	('society_taxi', 'Taxi', 1),
	('society_uwucafe', 'UwU Cafe', 1),
	('society_weazel', 'Weazel News', 1),
	('user_ears', 'Ears', 0),
	('user_glasses', 'Glasses', 0),
	('user_helmet', 'Helmet', 0),
	('user_mask', 'Mask', 0);

-- Dumping structure for table essentialmode.datastore_data
DROP TABLE IF EXISTS `datastore_data`;
CREATE TABLE IF NOT EXISTS `datastore_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  KEY `index_datastore_data_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.datastore_data: ~16 rows (approximately)
REPLACE INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
	(1, 'society_ambulance', NULL, '{}'),
	(2, 'society_cardealer', NULL, '{}'),
	(3, 'society_concess', NULL, '{}'),
	(4, 'society_fbi', NULL, '{}'),
	(5, 'society_mechanic', NULL, '{}'),
	(6, 'society_mt', NULL, '{"weapons":[{"count":1,"name":"WEAPON_BZGAS"},{"count":1,"name":"WEAPON_GUSENBERG"},{"count":1,"name":"WEAPON_BULLPUPRIFLE"}]}'),
	(7, 'society_police', NULL, '{}'),
	(8, 'society_sheriff', NULL, '{}'),
	(9, 'society_taxi', NULL, '{}'),
	(10, 'society_uwucafe', NULL, '{}'),
	(11, 'society_weazel', NULL, '{}'),
	(12, 'user_glasses', 'steam:11000014bf543e0', '{}'),
	(13, 'user_helmet', 'steam:11000014bf543e0', '{}'),
	(14, 'user_mask', 'steam:11000014bf543e0', '{}'),
	(15, 'user_ears', 'steam:11000014bf543e0', '{}'),
	(16, 'gang_a', NULL, '[]'),
	(17, 'property', 'steam:11000014bf543e0', '{"dressing":[{"skin":{"glasses_2":-1,"makeup_4":0,"ears_1":-1,"mask_1":0,"eye_color":5,"moles_1":0,"skin":14,"mask_2":0,"makeup_3":0,"beard_2":10,"age_1":0,"hair_color_1":0,"chain_1":0,"arms_2":0,"hair_2":0,"beard_4":0,"watches_1":-1,"moles_2":1,"helmet_1":-1,"sex":0,"bags_2":0,"face_2":21,"age_2":0,"bproof_1":0,"ears_2":-1,"eyebrows_4":0,"eyebrows_1":0,"complexion_2":1,"bproof_2":0,"complexion_1":0,"lipstick_2":0,"eyebrows_2":10,"shoes_2":0,"tshirt_2":0,"decals_1":0,"makeup_2":0,"hair_1":0,"pants_2":4,"face_3":5,"torso_1":137,"torso_2":0,"eyebrows_3":0,"chain_2":0,"decals_2":0,"hair_color_2":0,"watches_2":-1,"makeup_1":0,"shoes_1":34,"glasses_1":-1,"lipstick_3":0,"helmet_2":0,"arms":15,"face_1":3,"pants_1":61,"beard_1":0,"lipstick_1":0,"tshirt_1":15,"bags_1":0,"lipstick_4":0,"beard_3":0},"label":"1"}]}');

-- Dumping structure for table essentialmode.division_grades
DROP TABLE IF EXISTS `division_grades`;
CREATE TABLE IF NOT EXISTS `division_grades` (
  `division_owner` varchar(50) NOT NULL,
  `division` varchar(50) NOT NULL,
  `grade` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  PRIMARY KEY (`division_owner`,`division`,`grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.division_grades: ~0 rows (approximately)

-- Dumping structure for table essentialmode.divisions
DROP TABLE IF EXISTS `divisions`;
CREATE TABLE IF NOT EXISTS `divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `skin_male` longtext DEFAULT NULL,
  `skin_female` longtext DEFAULT NULL,
  `vehicles` longtext DEFAULT NULL,
  `helis` longtext DEFAULT NULL,
  `weapons` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_name` (`owner`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.divisions: ~0 rows (approximately)
REPLACE INTO `divisions` (`id`, `owner`, `name`, `label`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	(1, 'police', 'Arshia', '1', '{"helmet_1":-1,"bags_2":0,"ears_2":-1,"hair_2":0,"lipstick_4":0,"makeup_3":0,"age_1":0,"mask_2":2,"lipstick_1":0,"tshirt_2":0,"hair_color_1":0,"shoes_2":0,"lipstick_3":0,"eyebrows_1":0,"bproof_1":0,"decals_2":0,"arms":15,"glasses_1":-1,"lipstick_2":0,"makeup_1":0,"eyebrows_3":12,"beard_2":10,"ears_1":-1,"eye_color":12,"watches_2":-1,"moles_1":0,"eyebrows_2":10,"age_2":0,"chain_1":0,"eyebrows_4":12,"tshirt_1":15,"pants_1":61,"hair_color_2":0,"mask_1":0,"beard_3":0,"face_1":19,"makeup_4":0,"complexion_2":1,"chain_2":0,"glasses_2":-1,"bags_1":0,"face_3":10,"complexion_1":0,"hair_1":0,"sex":0,"beard_1":0,"moles_2":1,"helmet_2":-1,"makeup_2":0,"beard_4":0,"pants_2":4,"decals_1":0,"shoes_1":34,"torso_2":0,"arms_2":0,"watches_1":-1,"face_2":21,"bproof_2":0,"torso_1":15,"skin":19}', '[]', '[]', '[]', '[]', '[]'),
	(2, 'doa', 'test', 'Test', '{"eye_color":5,"face_1":0,"age_1":0,"pants_1":61,"hair_color_1":0,"mask_1":0,"glasses_2":-1,"lipstick_4":0,"torso_2":0,"eyebrows_1":0,"bags_2":0,"watches_2":-1,"beard_1":0,"pants_2":4,"lipstick_2":0,"lipstick_1":0,"helmet_2":-1,"lipstick_3":0,"sex":0,"decals_1":0,"complexion_1":0,"arms_2":0,"mask_2":2,"beard_2":10,"shoes_1":34,"makeup_3":0,"chain_1":0,"makeup_4":0,"hair_2":0,"complexion_2":1,"hair_1":10,"shoes_2":0,"eyebrows_4":12,"bags_1":0,"beard_4":0,"makeup_2":0,"chain_2":0,"arms":15,"moles_2":1,"eyebrows_2":10,"tshirt_2":0,"bproof_2":0,"ears_2":-1,"glasses_1":-1,"beard_3":0,"face_2":21,"skin":12,"makeup_1":0,"watches_1":-1,"decals_2":0,"bproof_1":0,"eyebrows_3":12,"moles_1":0,"hair_color_2":0,"tshirt_1":59,"helmet_1":-1,"ears_1":-1,"age_2":0,"torso_1":15,"face_3":5}', '[]', '[]', '[]', '[]', '[]');

-- Dumping structure for table essentialmode.doj_case_evidence
DROP TABLE IF EXISTS `doj_case_evidence`;
CREATE TABLE IF NOT EXISTS `doj_case_evidence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `type` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `suspect_hint_id` varchar(6) DEFAULT NULL,
  `found_by` varchar(64) DEFAULT NULL,
  `found_by_name` varchar(64) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_case_id` (`case_id`),
  KEY `idx_hint_id` (`suspect_hint_id`),
  CONSTRAINT `fk_evidence_case` FOREIGN KEY (`case_id`) REFERENCES `doj_cases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.doj_case_evidence: ~0 rows (approximately)

-- Dumping structure for table essentialmode.doj_case_notes
DROP TABLE IF EXISTS `doj_case_notes`;
CREATE TABLE IF NOT EXISTS `doj_case_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `author` varchar(64) DEFAULT NULL,
  `author_name` varchar(64) DEFAULT NULL,
  `note` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_case_id` (`case_id`),
  CONSTRAINT `fk_notes_case` FOREIGN KEY (`case_id`) REFERENCES `doj_cases` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.doj_case_notes: ~0 rows (approximately)

-- Dumping structure for table essentialmode.doj_cases
DROP TABLE IF EXISTS `doj_cases`;
CREATE TABLE IF NOT EXISTS `doj_cases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rob_name` varchar(64) NOT NULL,
  `rob_family` varchar(64) NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'open',
  `suspect_identifier` varchar(64) DEFAULT NULL,
  `suspect_name` varchar(64) DEFAULT NULL,
  `coords_x` float DEFAULT NULL,
  `coords_y` float DEFAULT NULL,
  `coords_z` float DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.doj_cases: ~0 rows (approximately)

-- Dumping structure for table essentialmode.duckcad_data
DROP TABLE IF EXISTS `duckcad_data`;
CREATE TABLE IF NOT EXISTS `duckcad_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `secondryid` int(11) NOT NULL,
  `steam` text NOT NULL,
  `reason` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `author` text NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.duckcad_data: ~0 rows (approximately)
REPLACE INTO `duckcad_data` (`id`, `secondryid`, `steam`, `reason`, `date`, `author`, `deleted`) VALUES
	(22, 0, 'steam:11000014bf543e0', 'Shop Robbery', '2026-08-02 11:07:27', 'Arshia_Mtz', 0);

-- Dumping structure for table essentialmode.duty_logs
DROP TABLE IF EXISTS `duty_logs`;
CREATE TABLE IF NOT EXISTS `duty_logs` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `steamhex` varchar(50) NOT NULL DEFAULT '',
  `ic_name` varchar(50) NOT NULL DEFAULT '',
  `job_name` varchar(50) NOT NULL DEFAULT '',
  `job_grade` varchar(50) NOT NULL DEFAULT '',
  `date` date DEFAULT NULL,
  `total_time` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.duty_logs: ~60 rows (approximately)
REPLACE INTO `duty_logs` (`id`, `steamhex`, `ic_name`, `job_name`, `job_grade`, `date`, `total_time`) VALUES
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
	(200, 'steam:110000146d830cd', 'Sohrab_Qaderi', 'weazel', 'Director', '2025-02-08', 1800),
	(201, 'steam:11000014bf543e0', 'Arshia_Mzn', 'police', 'Chief', '2026-07-30', 1500),
	(202, 'steam:11000014bf543e0', 'Arshia_Mzn', 'police', 'Deputy Chief', '2026-07-31', 1500),
	(203, 'steam:11000014bf543e0', 'Arshia_Mzn', 'sheriff', 'Chief', '2026-07-31', 1800),
	(204, 'steam:11000014bf543e0', 'Arshia_Mzn', 'police', 'Chief', '2026-08-01', 7200),
	(205, 'steam:11000014bf543e0', 'Arshia_Mtz', 'taxi', 'AnfÃ¤nger', '2026-08-01', 8400),
	(206, 'steam:11000014bf543e0', 'Arshia_Mtz', 'mt', 'Chief', '2026-08-01', 4500),
	(207, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-02', 12300),
	(208, 'steam:11000014bf543e0', 'Arshia_Mtz', 'ambulance', 'No Rank', '2026-08-02', 12000),
	(209, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-03', 3600),
	(210, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-04', 8700),
	(211, 'steam:11000014bf543e0', 'Arshia_Mtz', 'fbi', 'Agent', '2026-08-04', 3300),
	(212, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-05', 3900),
	(213, 'steam:11000014bf543e0', 'Arshia_Mtz', 'weazel', 'Trainee ', '2026-08-05', 1500),
	(214, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-06', 4800),
	(215, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-07', 2400),
	(216, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-08', 2400),
	(217, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-09', 1800),
	(218, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-10', 600),
	(219, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-11', 1500),
	(220, 'steam:11000014bf543e0', 'Arshia_Mtz', 'sheriff', 'Cadet', '2026-08-11', 900),
	(221, 'steam:11000014bf543e0', 'Arshia_Mtz', 'mechanic', 'Rank 18', '2026-08-11', 900),
	(222, 'steam:11000014bf543e0', 'Arshia_Mtz', 'mt', 'Commissioner', '2026-08-11', 300),
	(223, 'steam:11000014bf543e0', 'Arshia_Mtz', 'ambulance', 'Chief', '2026-08-11', 300),
	(224, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-13', 1200),
	(225, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-14', 3900),
	(226, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-15', 4500),
	(227, 'steam:11000014bf543e0', 'Arshia_Mtz', 'sheriff', 'Deputy', '2026-08-15', 6300),
	(228, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cid', 'Chief of CID', '2026-08-15', 4500),
	(229, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cid', 'CID Officer 1', '2026-08-16', 3900),
	(230, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cid', 'CID Officer 1', '2026-08-17', 3900),
	(231, 'steam:11000014bf543e0', 'Arshia_Mtz', 'mt', 'Officer I', '2026-08-17', 3600),
	(232, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-17', 1800),
	(233, 'steam:11000014bf543e0', 'Arshia_Mtz', 'ambulance', 'Intern', '2026-08-17', 1500),
	(234, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-18', 2100),
	(235, 'steam:11000014bf543e0', 'Arshia_Mtz', 'marshal', 'Deputy Chief', '2026-08-18', 1800),
	(236, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cid', 'CID Officer 1', '2026-08-18', 1200),
	(237, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cid', 'CID Officer 1', '2026-08-19', 300),
	(238, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-19', 900),
	(239, 'steam:11000014bf543e0', 'Arshia_Mtz', 'doa', 'DOA Officer 5', '2026-08-19', 900),
	(240, 'steam:11000014bf543e0', 'Arshia_Mtz', 'doa', 'DOA Officer 5', '2026-08-20', 2100),
	(241, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cratecarry', 'Owner', '2026-08-22', 300),
	(242, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-23', 6300),
	(243, 'steam:11000014bf543e0', 'Arshia_Mtz', 'fbi', 'Deputy Chief', '2026-08-23', 1500),
	(244, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-24', 2100),
	(245, 'steam:11000014bf543e0', 'Arshia_Mtz', 'cia', 'Senior Agent ', '2026-08-24', 2100),
	(246, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-25', 2100),
	(247, 'steam:11000014bf543e0', 'Arshia_Mtz', 'police', 'Commissioner', '2026-08-26', 900);

-- Dumping structure for table essentialmode.fightbans
DROP TABLE IF EXISTS `fightbans`;
CREATE TABLE IF NOT EXISTS `fightbans` (
  `Steam` text DEFAULT NULL,
  `isBnaned` int(11) DEFAULT NULL,
  `Expire` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.fightbans: ~2 rows (approximately)
REPLACE INTO `fightbans` (`Steam`, `isBnaned`, `Expire`) VALUES
	('steam11000016db053ad', 0, 0),
	('1', 1, 1785680020);

-- Dumping structure for table essentialmode.fine_types
DROP TABLE IF EXISTS `fine_types`;
CREATE TABLE IF NOT EXISTS `fine_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(50) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.fine_types: ~0 rows (approximately)

-- Dumping structure for table essentialmode.finelog
DROP TABLE IF EXISTS `finelog`;
CREATE TABLE IF NOT EXISTS `finelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `name` varchar(60) DEFAULT NULL,
  `oocname` varchar(60) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `fineamount` int(11) DEFAULT NULL,
  `punisher` varchar(60) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.finelog: ~0 rows (approximately)

-- Dumping structure for table essentialmode.gang_account
DROP TABLE IF EXISTS `gang_account`;
CREATE TABLE IF NOT EXISTS `gang_account` (
  `name` varchar(254) DEFAULT NULL,
  `label` varchar(254) DEFAULT NULL,
  `shared` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.gang_account: ~0 rows (approximately)
REPLACE INTO `gang_account` (`name`, `label`, `shared`) VALUES
	('gang_a', 'gang', 1);

-- Dumping structure for table essentialmode.gang_account_data
DROP TABLE IF EXISTS `gang_account_data`;
CREATE TABLE IF NOT EXISTS `gang_account_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(254) DEFAULT NULL,
  `money` double DEFAULT NULL,
  `dirty_money` double DEFAULT NULL,
  `owner` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.gang_account_data: ~0 rows (approximately)
REPLACE INTO `gang_account_data` (`id`, `gang_name`, `money`, `dirty_money`, `owner`) VALUES
	(98, 'gang_a', 1, 0, NULL);

-- Dumping structure for table essentialmode.gang_grades
DROP TABLE IF EXISTS `gang_grades`;
CREATE TABLE IF NOT EXISTS `gang_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  `vehicles` longtext DEFAULT NULL,
  `helis` longtext DEFAULT NULL,
  `boats` longtext DEFAULT NULL,
  `crafting` longtext DEFAULT NULL,
  `inventorys` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=585 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.gang_grades: ~14 rows (approximately)
REPLACE INTO `gang_grades` (`id`, `gang_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `boats`, `crafting`, `inventorys`) VALUES
	(1, 'nogang', 0, 'nogang', 'NoGang', 0, '[]', '[]', NULL, NULL, NULL, NULL, NULL),
	(572, 'A', 1, 'Rank 1', 'Rank1', 400, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(573, 'A', 9, 'Rank 9', 'Rank9', 3600, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(574, 'A', 11, 'Rank 11', 'Rank11', 4400, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(575, 'A', 4, 'Rank 4', 'Rank4', 1600, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(576, 'A', 6, 'Rank 6', 'Rank6', 2400, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(577, 'A', 7, 'Rank 7', 'Rank7', 2800, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(578, 'A', 5, 'Rank 5', 'Rank5', 2000, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(579, 'A', 8, 'Rank 8', 'Rank8', 3200, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(580, 'A', 2, 'Rank 2', 'Rank2', 800, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(581, 'A', 3, 'Rank 3', 'Rank3', 1200, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(582, 'A', 10, 'Rank 10', 'Rank10', 4000, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(583, 'A', 13, 'Rank 13', 'Rank13', 5200, '[]', '[]', '[]', '[]', '[]', '0', '[]'),
	(584, 'A', 12, 'Rank 12', 'Rank12', 4800, '[]', '[]', '[]', '[]', '[]', '0', '[]');

-- Dumping structure for table essentialmode.gangs
DROP TABLE IF EXISTS `gangs`;
CREATE TABLE IF NOT EXISTS `gangs` (
  `name` varchar(254) DEFAULT NULL,
  `label` varchar(254) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.gangs: ~2 rows (approximately)
REPLACE INTO `gangs` (`name`, `label`) VALUES
	('nogang', 'NoGang'),
	('A', 'gang');

-- Dumping structure for table essentialmode.gangs_data
DROP TABLE IF EXISTS `gangs_data`;
CREATE TABLE IF NOT EXISTS `gangs_data` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(254) DEFAULT NULL,
  `blip` varchar(254) DEFAULT NULL,
  `search` tinyint(1) DEFAULT 0,
  `bulletproof` int(100) DEFAULT 0,
  `access` int(1) NOT NULL DEFAULT 1,
  `armory` varchar(254) DEFAULT NULL,
  `locker` varchar(254) DEFAULT NULL,
  `boss` varchar(254) DEFAULT NULL,
  `vehicles` varchar(254) DEFAULT NULL,
  `veh` varchar(254) DEFAULT NULL,
  `vehprop` longtext DEFAULT NULL,
  `vehdel` varchar(254) DEFAULT NULL,
  `vehspawn` varchar(254) DEFAULT NULL,
  `heli` varchar(254) DEFAULT NULL,
  `helidel` varchar(254) DEFAULT NULL,
  `helispawn` varchar(254) DEFAULT NULL,
  `helimodel` longtext CHARACTER SET utf8 COLLATE utf8_persian_ci DEFAULT NULL,
  `expire_time` date DEFAULT NULL,
  `webhook` longtext DEFAULT NULL,
  `logo` longtext CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'defaultlogo',
  `gps` int(11) DEFAULT 0,
  `slot` int(255) DEFAULT 10,
  `logpower` int(11) DEFAULT 0,
  `vip` int(11) DEFAULT 0,
  `invite_access` int(11) DEFAULT 6,
  `armory_access` int(11) DEFAULT 2,
  `garage_access` int(11) DEFAULT 1,
  `heli_access` int(11) DEFAULT 3,
  `vest_access` int(11) DEFAULT 1,
  `blip_sprite` int(255) DEFAULT 378,
  `gps_color` int(255) DEFAULT 1,
  `blip_color` int(255) DEFAULT 76,
  `garage_limit` int(100) DEFAULT 10,
  `price` int(255) DEFAULT 8000,
  `lockpick` int(11) DEFAULT 0,
  `xp` int(11) DEFAULT 0,
  `rank` int(11) DEFAULT 0,
  `Level` int(11) NOT NULL DEFAULT 0,
  `boat` varchar(254) DEFAULT NULL,
  `boatdel` varchar(254) DEFAULT NULL,
  `boatspawn` varchar(254) DEFAULT NULL,
  `boat_access` int(11) DEFAULT 3,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.gangs_data: ~0 rows (approximately)
REPLACE INTO `gangs_data` (`ID`, `gang_name`, `blip`, `search`, `bulletproof`, `access`, `armory`, `locker`, `boss`, `vehicles`, `veh`, `vehprop`, `vehdel`, `vehspawn`, `heli`, `helidel`, `helispawn`, `helimodel`, `expire_time`, `webhook`, `logo`, `gps`, `slot`, `logpower`, `vip`, `invite_access`, `armory_access`, `garage_access`, `heli_access`, `vest_access`, `blip_sprite`, `gps_color`, `blip_color`, `garage_limit`, `price`, `lockpick`, `xp`, `rank`, `Level`, `boat`, `boatdel`, `boatspawn`, `boat_access`) VALUES
	(97, 'A', '{"x":208.32186889648438,"y":-795.1222534179688,"z":31.46120071411132}', 0, 0, 1, '{"x":211.13352966308595,"y":-788.568603515625,"z":29.89986038208007}', '{"x":212.4344940185547,"y":-784.8438720703125,"z":29.883544921875}', '{"x":208.9144744873047,"y":-793.2288818359375,"z":29.94788360595703}', '[]', '{"x":219.49037170410157,"y":-782.11279296875,"z":29.79902458190918}', '[]', '{"x":225.42271423339845,"y":-775.4795532226563,"z":29.77860450744629}', '{"x":222.0124053955078,"y":-778.9879760742188,"z":30.78024101257324,"a":299.5364990234375}', NULL, NULL, NULL, NULL, '2026-09-02', NULL, 'defaultlogo', 0, 10, 0, 0, 6, 2, 1, 3, 1, 378, 1, 76, 10, 8000, 0, 0, 0, 0, NULL, NULL, NULL, 3);

-- Dumping structure for table essentialmode.items
DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `limit` int(11) NOT NULL DEFAULT -1,
  `rare` tinyint(1) NOT NULL DEFAULT 0,
  `can_remove` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.items: ~238 rows (approximately)
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('aard', 'Aard', 30, 0, 1),
	('abporteghal', 'Ab Porteghal', 10, 0, 1),
	('air_freshener_pine', 'Air Freshener Pine', 10, 0, 1),
	('alive_chicken', 'ElÃ¤vÃ¤ kana', 20, 0, 1),
	('armor', 'Armor', -1, 0, 1),
	('bakingpowder', 'Baking Powder', 30, 0, 1),
	('bandage', 'Bandage', 20, 0, 1),
	('bastani', 'Bastani', 10, 0, 1),
	('beer', 'Beer', 30, 0, 1),
	('berenj_sushi', 'Berenj Sushi', 30, 0, 1),
	('blackmoney', 'Black Money', -1, 1, 1),
	('blowpipe', 'Chalumeaux', 10, 0, 1),
	('blowtorch', 'Blowtorch', -1, 0, 1),
	('bobal_tea_matcha', 'Bobal Tea Matcha', 10, 0, 1),
	('bobal_tea_tamshak', 'Bobal Tea Tamshak', 10, 0, 1),
	('boba_milk_tea_caramel', 'Boba Milk Tea Caramel', 10, 0, 1),
	('boba_milk_tea_matcha', 'Boba Milk Tea Matcha', 10, 0, 1),
	('bread', 'Bread', -1, 0, 1),
	('breathalyzer', 'Test Alchol', 10, 0, 1),
	('bubbletetotfarangi', 'Bubblete Totfarangi', 10, 0, 1),
	('cakebastani', 'Cake Bastani', 10, 0, 1),
	('cakebastanivanili', 'Cake Bastani Vanili', 10, 0, 1),
	('caketotfarangi', 'Cake Totfarangi', 10, 0, 1),
	('cake_bastani_vanili', 'Cake Bastani Vanili', 10, 0, 1),
	('cake_limoii', 'Cake Limoii', 10, 0, 1),
	('calzone', 'Calzone', 10, 0, 1),
	('cannabis', 'Hashish', 50, 0, 1),
	('carokit', 'Kit carosserie', 3, 0, 1),
	('carotool', 'outils carosserie', 4, 0, 1),
	('ceramic_coat', 'Ceramic Coat', 10, 0, 1),
	('chaee', 'Chaee', 10, 0, 1),
	('clip', 'Clip', -1, 0, 1),
	('clothe', 'Vaate', 40, 0, 1),
	('coca', 'Tokhm Kokayin', 150, 0, 1),
	('cocaine', 'Kokayin', 50, 0, 1),
	('coin', 'Coin', -1, 0, 1),
	('cookie_shekari', 'Cookie Shekari', 10, 0, 1),
	('copper', 'Kupari', 56, 0, 1),
	('crack', 'Crack', 25, 0, 1),
	('croissant_kareii', 'Croissant Kareii', 10, 0, 1),
	('cupcake', 'Cup Cake', 10, 0, 1),
	('cupcake_shokolati', 'Cupcake Shokolati', 10, 0, 1),
	('customcoupon', 'Coupon', -1, 0, 1),
	('cutted_wood', 'Pilkottu Puu', 20, 0, 1),
	('dabs', 'Dabs', 50, 0, 1),
	('daneghahve', 'Dane Ghahve', 30, 0, 1),
	('delester', 'Delester', -1, 0, 1),
	('diamond', 'Timantti', 50, 0, 1),
	('dooghbg', 'Doogh Bozorg', -1, 0, 1),
	('dooghg', 'Doogh Kuchak', -1, 0, 1),
	('drugtest', 'Test Mavad', 10, 0, 1),
	('eaglemeet', 'Eagle Meat', -1, 0, 1),
	('ebitenrol', 'Ebi Tenrol', -1, 0, 1),
	('eclip', 'Extended Clip', -1, 0, 1),
	('egg', 'Tokhm Morgh', 30, 0, 1),
	('energy_mix', 'Energy Mix', 10, 0, 1),
	('engine', 'Engine', -1, 0, 1),
	('engine1', 'Engine Scrap X1', -1, 0, 1),
	('engine2', 'Engine Scrap X2', -1, 0, 1),
	('engine3', 'Engine Scrap X3', -1, 0, 1),
	('engine4', 'Engine Scrap X4', -1, 0, 1),
	('engine5', 'Engine Scrap X5', -1, 0, 1),
	('engine6', 'Engine Scrap X6', -1, 0, 1),
	('ephedra', 'Ephedra', 100, 0, 1),
	('ephedrine', 'Ephedrine', 100, 0, 1),
	('eskenas', 'Eskenas', -1, 0, 1),
	('essence', 'PolttoÃ¶ljy', 24, 0, 1),
	('fabric', 'Kangas', 80, 0, 1),
	('fakepee', 'Fake Pee', 5, 0, 1),
	('fenjon', 'Fenjon', 30, 0, 1),
	('fenjonkasif', 'Fenjon Kasif', 30, 0, 1),
	('fish', 'Kala', 100, 0, 1),
	('fishingrod', 'Fishing Rod', -1, 0, 1),
	('fixkit', 'Kit rÃ©paration', 5, 0, 1),
	('fixtool', 'outils rÃ©paration', 6, 0, 1),
	('fountain', 'Fountain Firework', 3, 0, 1),
	('froyo_mango', 'Froyo Mango', 10, 0, 1),
	('fruit_punch', 'Fruit Punch', 10, 0, 1),
	('garlic_bread', 'Garlic Bread', 10, 0, 1),
	('gazbottle', 'bouteille de gaz', 11, 0, 1),
	('gazellemeet', 'Gazelle Meat', -1, 0, 1),
	('ghahve100', 'Ghahve 100', 10, 0, 1),
	('ghahve50', 'Ghahve 50', 10, 0, 1),
	('ghahve80', 'Ghahve 80', 10, 0, 1),
	('gold', 'Kulta', 21, 0, 1),
	('goshteaho', 'Goshte Aho', 20, 0, 1),
	('goshtecougar', 'Goshte Cougar', 20, 0, 1),
	('goshtecoyote', 'Goshte Coyote', 20, 0, 1),
	('goshtehusky', 'Goshte Husky', 20, 0, 1),
	('goshtekhargush', 'Goshte Khargush', 20, 0, 1),
	('goshteoghab', 'Goshte Oghab', 20, 0, 1),
	('goshtepig', 'Goshte Pig', 20, 0, 1),
	('goshterottweiler', 'Goshte Rottweiler', 20, 0, 1),
	('grip', 'Grip', -1, 0, 1),
	('headeaho', 'Heade Aho', 20, 0, 1),
	('headecougar', 'Heade Cougar', 20, 0, 1),
	('headecoyote', 'Heade Coyote', 20, 0, 1),
	('headehusky', 'Heade Husky', 20, 0, 1),
	('headekhargush', 'Heade Khargush', 20, 0, 1),
	('heademorgh', 'Heade Morgh', 20, 0, 1),
	('headeoghab', 'Heade Oghab', 20, 0, 1),
	('headepig', 'Heade Pig', 20, 0, 1),
	('headerottweiler', 'Heade Rottweiler', 20, 0, 1),
	('henmeat', 'Hen Meat', -1, 0, 1),
	('heroine', 'Heroine', 10, 0, 1),
	('hifi', 'HiFi', 1, 0, 1),
	('hotwire', 'Pich Goshti', -1, 0, 1),
	('hot_chocolate', 'Hot Chocolate', 10, 0, 1),
	('icecream_chocolate_cone', 'Icecream Chocolate Cone', 10, 0, 1),
	('icecream_sandwich', 'Icecream Sandwich', 10, 0, 1),
	('icecream_vanilla_cone', 'Icecream Vanilla Cone', 10, 0, 1),
	('ice_coffee_matcha', 'Ice Coffee Matcha', 10, 0, 1),
	('ice_tea_special', 'Ice Tea Special', 10, 0, 1),
	('interior_cleaner', 'Interior Cleaner Kit', 10, 0, 1),
	('iron', 'Rauta', 42, 0, 1),
	('joje', 'Joje', -1, 0, 1),
	('kabab', 'Kabab', -1, 0, 1),
	('kare', 'Kare', 30, 0, 1),
	('kase', 'Kase', 30, 0, 1),
	('kasekasif', 'Kase Kasif', 30, 0, 1),
	('keik_shokolat', 'Keik Shokolat', 10, 0, 1),
	('khame', 'Khame', 30, 0, 1),
	('khame_yakhi', 'Khame Yakhi', 30, 0, 1),
	('khamir_pizza', 'Khamir Pizza', 30, 0, 1),
	('khamir_shirini', 'Khamir Shirini', 30, 0, 1),
	('laptophack', 'Hacking Laptop', -1, 0, 1),
	('lasheaho', 'Lashe Aho', 20, 0, 1),
	('lashecougar', 'Lashe Cougar', 20, 0, 1),
	('lashecoyote', 'Lashe Coyote', 20, 0, 1),
	('lashehusky', 'Lashe Husky', 20, 0, 1),
	('lashekhargush', 'Lashe Khargush', 20, 0, 1),
	('lashemorgh', 'Lashe Morgh', -1, 0, 1),
	('lashemorgh.png', 'Lashe Morgh', 20, 0, 1),
	('lasheoghab', 'Lashe Oghab', 20, 0, 1),
	('lashepig', 'Lashe Pig', 20, 0, 1),
	('lasherottweiler', 'Lashe Rottweiler', 20, 0, 1),
	('latte', 'Latte', 10, 0, 1),
	('lighter', 'Lighter', -1, 0, 1),
	('limo', 'Limo', 30, 0, 1),
	('lockpick', 'Lockpick', -1, 0, 1),
	('lsd', 'LSD', -1, 0, 1),
	('maahi_khaam', 'Maahi Khaam', 30, 0, 1),
	('mahighezel', 'Mahi Ghezel', -1, 0, 1),
	('mahigolip', 'Mahi Golip', -1, 0, 1),
	('mahihamoor', 'Mahi Hamoor', -1, 0, 1),
	('marijuana', 'Marijuana', 250, 0, 1),
	('medikit', 'Medikit', 5, 0, 1),
	('meth', 'Meth', 25, 0, 1),
	('microfiber_cloth', 'Microfiber Cloth', 30, 0, 1),
	('milkshake', 'Milk Shake', 10, 0, 1),
	('milkshake_strawberry', 'Milkshake Strawberry', 10, 0, 1),
	('milk_shake_shokolati', 'Milk Shake Shokolati', 10, 0, 1),
	('miso_soup', 'Miso Soup', 10, 0, 1),
	('mive_mix', 'Mive Mix', 30, 0, 1),
	('mocktail_mojito', 'Virgin Mojito', 10, 0, 1),
	('mocktail_pinacolada', 'Virgin Pina Colada', 10, 0, 1),
	('mufchocolate', 'Mufchocolate', 10, 0, 1),
	('muffin_tamshak', 'Muffin Tamshak', 10, 0, 1),
	('mushroom', 'Mushroom', -1, 0, 1),
	('narcan', 'Narcan', 10, 0, 1),
	('net_cracker', 'Net Cracker', -1, 0, 1),
	('nodel', 'Nodel', 10, 0, 1),
	('nodel_kham', 'Nodel Kham', 30, 0, 1),
	('non_baget', 'Non Baget', 10, 0, 1),
	('noodles', 'Noodles', 10, 0, 1),
	('nori', 'Nori', 30, 0, 1),
	('noshab', 'Noshabe', -1, 0, 1),
	('nutela', 'Nutela', 10, 0, 1),
	('opium', 'Teryak', 50, 0, 1),
	('oreo', 'Oreo', 30, 0, 1),
	('packaged_chicken', 'Kananfilee', 100, 0, 1),
	('packaged_plank', 'Paketoitu Lankku', 100, 0, 1),
	('painkiller', 'Painkiller', 10, 0, 1),
	('panir_pizza', 'Panir Pizza', 30, 0, 1),
	('pankik', 'Pankik', 10, 0, 1),
	('pankik_nutella', 'Pankik Nutella', 10, 0, 1),
	('pankik_oreo', 'Pankik Oreo', 10, 0, 1),
	('pcp', 'PCP', 25, 0, 1),
	('petrol', 'Ã–ljy', 24, 0, 1),
	('petrol_raffin', 'Prosessoitu Ã–ljy', 24, 0, 1),
	('phone', 'Goshi', -1, 0, 1),
	('pizzama', 'Pizza Ma', -1, 0, 1),
	('pizzamo', 'Pizza Mo', -1, 0, 1),
	('pizza_bbq_chicken', 'Pizza BBQ Chicken', 10, 0, 1),
	('pizza_margherita', 'Pizza Margherita', 10, 0, 1),
	('pizza_mushroom', 'Pizza Mushroom', 10, 0, 1),
	('pizza_pepperoni', 'Pizza Pepperoni', 10, 0, 1),
	('podrcacao', 'Podr Cacao', 30, 0, 1),
	('poppy', 'KhashKhaash', 25, 0, 1),
	('posteaho', 'Poste Aho', 20, 0, 1),
	('postecougar', 'Poste Cougar', 20, 0, 1),
	('postecoyote', 'Poste Coyote', 20, 0, 1),
	('postehusky', 'Poste Husky', 20, 0, 1),
	('postekhargush', 'Poste Khargush', 20, 0, 1),
	('postepig', 'Poste Pig', 20, 0, 1),
	('poster', 'Poster', -1, 0, 1),
	('posterottweiler', 'Poste Rottweiler', 20, 0, 1),
	('powdr_matcha', 'Powdr Matcha', 30, 0, 1),
	('premium_wax', 'Premium Wax', 10, 0, 1),
	('rabbitmeat', 'Rabbit Meat', -1, 0, 1),
	('radio', 'Radio', -1, 0, 1),
	('rim_polish', 'Rim Polish', 10, 0, 1),
	('roll_darchin', 'Roll Darchin', 10, 0, 1),
	('scope', 'Scope', -1, 0, 1),
	('sf', 'SF', -1, 0, 1),
	('sh', 'SH', -1, 0, 1),
	('shahkelid', 'Shah Kelid', -1, 0, 1),
	('shekar', 'Shekar', 30, 0, 1),
	('shir', 'Shir', 30, 0, 1),
	('shirini_khamei', 'Shirini Khamei', 10, 0, 1),
	('shokolat', 'Shokolat', 10, 0, 1),
	('shotburst', 'Shotburst Firework', 3, 0, 1),
	('sianor', 'Sianor', -1, 0, 1),
	('sibp', 'Sib Zamini', -1, 0, 1),
	('silencer', 'Silencer', -1, 0, 1),
	('slaughtered_chicken', 'Teurastettu kana', 20, 0, 1),
	('sm', 'SM', -1, 0, 1),
	('soap_foam', 'Soap Foam', 30, 0, 1),
	('soda_lime', 'Soda Lime', 10, 0, 1),
	('soda_water', 'Soda Water', 30, 0, 1),
	('sos_gojeh', 'Sos Gojeh', 30, 0, 1),
	('ss', 'SS', -1, 0, 1),
	('starburst', 'Starburst Firework', 3, 0, 1),
	('stone', 'Kivi', 7, 0, 1),
	('sundae_caramel', 'Sundae Caramel', 10, 0, 1),
	('suop', 'Suop', 10, 0, 1),
	('sushi_california', 'Sushi California', 10, 0, 1),
	('sushi_dragon_roll', 'Sushi Dragon Roll', 10, 0, 1),
	('sushi_salmon_nigiri', 'Sushi Salmon Nigiri', 10, 0, 1),
	('sushi_spicy_tuna', 'Sushi Spicy Tuna', 10, 0, 1),
	('sushi_veggie_roll', 'Sushi Veggie Roll', 10, 0, 1),
	('tamshak', 'Tamshak', 30, 0, 1),
	('tequila', 'Tequila', 10, 0, 1),
	('tiramisuye_toot_farangi', 'Tiramisuye TotFarangi', 10, 0, 1),
	('tire_shine', 'Tire Shine', 10, 0, 1),
	('totfarangi', 'Tot Farangi', 30, 0, 1),
	('trailburst', 'Trailburst Firework', 3, 0, 1),
	('unagieelroll', 'Unagi Eel Roll', -1, 0, 1),
	('vafel_nutella', 'Vafel Nutella', 10, 0, 1),
	('vanil', 'Vanil', 30, 0, 1),
	('vodka', 'Vodka', 10, 0, 1),
	('washed_stone', 'Puhdistettu Kivi', 7, 0, 1),
	('water', 'Water', -1, 0, 1),
	('whiskey', 'Whiskey', 10, 0, 1),
	('whool', 'Wolle', 40, 0, 1),
	('wood', 'Puu', 20, 0, 1),
	('wool', 'Villa', 40, 0, 1),
	('xpbank', 'XP Bank Card', -1, 0, 1),
	('xpshop', 'XP Shop Card', -1, 0, 1),
	('yakh', 'Yakh', 30, 0, 1);

-- Dumping structure for table essentialmode.job_grades
DROP TABLE IF EXISTS `job_grades`;
CREATE TABLE IF NOT EXISTS `job_grades` (
  `job_name` varchar(50) NOT NULL,
  `grade` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT 0,
  `skin_male` longtext DEFAULT NULL,
  `skin_female` longtext DEFAULT NULL,
  `vehicles` longtext DEFAULT NULL,
  `helis` longtext DEFAULT NULL,
  `weapons` longtext DEFAULT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`job_name`,`grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.job_grades: ~625 rows (approximately)
REPLACE INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`, `vehicles`, `helis`, `weapons`, `items`) VALUES
	('ambulance', 0, 'ambulance', 'Ambulancier', 20, '{"tshirt_2":0,"hair_color_1":5,"glasses_2":3,"shoes":9,"torso_2":3,"hair_color_2":0,"pants_1":24,"glasses_1":4,"hair_1":2,"sex":0,"decals_2":0,"tshirt_1":15,"helmet_1":8,"helmet_2":0,"arms":92,"face":19,"decals_1":60,"torso_1":13,"hair_2":0,"skin":34,"pants_2":5}', '{"tshirt_2":3,"decals_2":0,"glasses":0,"hair_1":2,"torso_1":73,"shoes":1,"hair_color_2":0,"glasses_1":19,"skin":13,"face":6,"pants_2":5,"tshirt_1":75,"pants_1":37,"helmet_1":57,"torso_2":0,"arms":14,"sex":1,"glasses_2":0,"decals_1":0,"hair_2":0,"helmet_2":0,"hair_color_1":0}', NULL, NULL, NULL, NULL),
	('ambulance', 1, 'intern', 'Intern', 3000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":85,"shoes_1":179,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":4,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":0,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":279,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":791,"pants_2":4,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":0,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[{"status":true,"model":"ambulance"},{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":false,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"polkch"},{"status":false,"model":"poljug"},{"status":false,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":false,"model":"polros"}]', NULL, '', '[]'),
	('ambulance', 2, 'intern', 'Nurse', 4000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":85,"shoes_1":15,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":7,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":0,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":96,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":601,"pants_2":1,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":2,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 3, 'nurse', 'EMT', 5000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":87,"shoes_1":10,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":1,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":30,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":187,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":686,"pants_2":0,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":2,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 4, 'doctor', 'Doctor', 6000, '{"beard_4":0,"torso_1":601,"lipstick_3":0,"sex":0,"bracelets_1":-1,"nose_1":0,"jaw_2":0,"decals_2":0,"eye_color":0,"arms_2":0,"arms":85,"beard_1":0,"blush_1":-1,"bags_2":0,"watches_1":-1,"decals_1":0,"age_1":0,"torso_2":1,"cheeks_2":0,"cheeks_1":0,"bodyb_1":-1,"face_2":21,"makeup_2":0,"bracelets_2":0,"mask_1":0,"eyebrows_4":12,"complexion_2":1,"face_md_weight":50.0,"jaw_1":0,"tshirt_2":0,"makeup_4":0,"nose_6":0,"shoes_2":0,"eye_squint":0,"sun_1":-1,"beard_2":10,"chain_2":0,"dad":0,"moles_2":1,"bodyb_4":0,"eyebrows_6":0,"lip_thickness":0,"shoes_1":10,"eyebrows_3":12,"moles_1":0,"mask_2":2,"nose_5":0,"blush_2":10,"lipstick_1":0,"nose_4":0,"mom":21,"face_3":5,"tshirt_1":15,"lipstick_2":0,"beard_3":0,"skin":12,"face_1":0,"helmet_2":-1,"bags_1":0,"chin_3":0,"neck_thickness":0,"pants_1":28,"nose_2":0,"chin_1":0,"hair_2":0,"helmet_1":-1,"watches_2":-1,"chest_1":-1,"blush_3":0,"cheeks_3":0,"makeup_1":0,"nose_3":0,"hair_color_1":0,"hair_1":10,"chain_1":126,"pants_2":0,"skin_md_weight":6,"sun_2":10,"bproof_2":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_2":10,"ears_2":-1,"eyebrows_5":0,"glasses_2":-1,"age_2":0,"bodyb_3":-1,"chin_2":0,"chin_4":0,"chest_2":10,"makeup_3":0,"eyebrows_1":0,"bodyb_2":0,"hair_color_2":0,"complexion_1":0,"ears_1":-1,"bproof_1":0,"glasses_1":-1,"blemishes_2":10,"chest_3":0}', '{}', '[{"status":true,"model":"ambulance"},{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"}]', NULL, '', '[]'),
	('ambulance', 5, 'sergon', 'Resident', 7000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":85,"shoes_1":15,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":8,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":0,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":96,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":601,"pants_2":0,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":2,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 6, 'sparamedic', 'Surgeon', 8000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":85,"shoes_1":10,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":2,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":0,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":28,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":601,"pants_2":0,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":2,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 7, 'lparamedic', 'No Rank', 9000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 8, 'lparamedic', 'No Rank', 10000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 9, 'lparamedic', 'No Rank', 11000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 10, 'lparamedic', 'No Rank', 12000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 11, 'lparamedic', 'No Rank', 13000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 12, 'lparamedic', 'Dispatch', 14000, '{"mask_1":-1,"jaw_1":0,"age_1":-1,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":10,"glasses_2":5,"blush_1":-1,"nose_5":0,"beard_3":29,"sex":0,"tshirt_2":0,"beard_1":11,"face_md_weight":50.0,"chin_3":0,"beard_4":29,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":29,"lipstick_1":-1,"shoes_2":7,"jaw_2":0,"complexion_1":-1,"watches_2":0,"blush_3":0,"skin":12,"hair_color_2":29,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":29,"arms":26,"shoes_1":181,"age_2":10,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":10,"makeup_4":0,"chain_1":309,"sun_1":-1,"torso_2":2,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":-1,"bproof_1":0,"eyebrows_6":0,"bags_1":129,"eyebrows_4":29,"hair_1":178,"bproof_2":0,"glasses_1":5,"decals_2":0,"bracelets_2":0,"makeup_1":-1,"tshirt_1":255,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":256,"mom":21,"blemishes_2":10,"complexion_2":10,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":0,"nose_3":0,"nose_6":0,"torso_1":625,"pants_2":0,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":0,"lipstick_2":10,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":29}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 13, 'lparamedic', 'Spiecialist', 15000, '{"mask_1":0,"jaw_1":0,"age_1":0,"lip_thickness":0,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":0,"beard_3":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":50.0,"chin_3":0,"beard_4":0,"bags_2":0,"decals_1":0,"neck_thickness":0,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":0,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"hair_color_1":0,"arms":87,"shoes_1":10,"age_2":0,"chin_4":0,"bodyb_1":-1,"cheeks_2":0,"lipstick_4":0,"lipstick_3":0,"makeup_2":0,"makeup_4":0,"chain_1":126,"sun_1":-1,"torso_2":3,"bodyb_3":-1,"chin_1":0,"blemishes_1":-1,"nose_4":0,"bracelets_1":-1,"helmet_1":-1,"eyebrows_2":10,"eye_color":0,"moles_1":0,"bproof_1":0,"eyebrows_6":0,"bags_1":0,"eyebrows_4":12,"hair_1":10,"bproof_2":0,"glasses_1":-1,"decals_2":0,"bracelets_2":0,"makeup_1":0,"tshirt_1":15,"dad":0,"bodyb_4":0,"face_1":0,"bodyb_2":0,"face_3":5,"pants_1":28,"mom":21,"blemishes_2":10,"complexion_2":1,"cheeks_3":0,"eyebrows_5":0,"sun_2":10,"chin_2":0,"nose_2":0,"helmet_2":-1,"nose_3":0,"nose_6":0,"torso_1":601,"pants_2":0,"arms_2":0,"makeup_3":0,"nose_1":0,"chain_2":0,"cheeks_1":0,"mask_2":2,"lipstick_2":0,"chest_2":10,"skin_md_weight":6,"chest_3":0,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 14, 'lparamedic', 'Commander', 16000, '{"beard_4":0,"torso_1":220,"blemishes_1":-1,"sex":0,"helmet_1":-1,"nose_1":0,"bodyb_2":0,"decals_2":0,"eye_color":0,"arms_2":0,"nose_4":0,"skin":12,"blush_1":-1,"bags_2":0,"watches_1":-1,"decals_1":0,"age_1":0,"torso_2":0,"cheeks_2":0,"cheeks_1":0,"bodyb_1":-1,"face_2":21,"makeup_2":0,"bracelets_2":0,"mask_1":0,"eyebrows_4":12,"complexion_2":1,"face_md_weight":50.0,"jaw_1":0,"tshirt_2":0,"makeup_3":0,"nose_6":0,"shoes_2":0,"eye_squint":0,"sun_1":-1,"beard_2":10,"chain_2":0,"dad":0,"moles_2":1,"bodyb_4":0,"face_1":0,"lip_thickness":0,"shoes_1":34,"eyebrows_3":12,"makeup_4":0,"bracelets_1":-1,"nose_5":0,"nose_3":0,"lipstick_1":0,"blush_2":10,"mom":21,"moles_1":0,"tshirt_1":15,"lipstick_2":0,"beard_3":0,"eyebrows_6":0,"blush_3":0,"helmet_2":-1,"jaw_2":0,"chin_3":0,"neck_thickness":0,"complexion_1":0,"mask_2":2,"chin_1":0,"hair_2":0,"bags_1":0,"watches_2":-1,"chest_1":-1,"pants_1":61,"cheeks_3":0,"glasses_1":-1,"chest_3":0,"hair_color_1":0,"hair_1":10,"chain_1":0,"pants_2":1,"ears_1":-1,"ears_2":-1,"bproof_2":0,"sun_2":10,"lipstick_4":0,"eyebrows_2":10,"chest_2":10,"eyebrows_5":0,"glasses_2":-1,"age_2":0,"bodyb_3":-1,"chin_2":0,"chin_4":0,"skin_md_weight":6,"bproof_1":0,"nose_2":0,"makeup_1":0,"hair_color_2":0,"face_3":5,"blemishes_2":10,"beard_1":0,"lipstick_3":0,"arms":15,"eyebrows_1":0}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 15, 'lparamedic', 'Deputy Chief', 17000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 16, 'lparamedic', 'Assistant Chief', 18000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 17, 'boss', 'Advisor', 19000, '{}', '{}', '[]', NULL, '', '[]'),
	('ambulance', 18, 'boss', 'Chief', 20000, '{"bproof_1":123,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"shoes_1":10,"blush_2":10,"glasses_2":-1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"arms":77,"lip_thickness":0,"torso_2":2,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":3,"makeup_1":0,"helmet_2":-1,"nose_4":0,"mom":21,"nose_5":0,"arms_2":0,"complexion_2":1,"face_md_weight":50.0,"ears_2":-1,"nose_2":0,"sun_1":-1,"chin_3":0,"beard_3":0,"skin":12,"bproof_2":4,"decals_1":0,"pants_2":0,"chest_1":-1,"helmet_1":-1,"bags_1":0,"beard_4":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":72,"chest_2":10,"watches_1":-1,"chin_2":0,"bodyb_4":0,"nose_1":0,"cheeks_2":0,"pants_1":28,"skin_md_weight":6,"hair_color_2":0,"dad":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"eyebrows_2":10,"nose_6":0,"eyebrows_3":12,"blush_1":-1,"blemishes_2":10,"beard_2":10,"neck_thickness":0,"glasses_1":-1,"eyebrows_4":12,"jaw_2":0,"watches_2":-1,"torso_1":750,"eye_color":0,"cheeks_3":0,"chin_4":0,"lipstick_3":0,"ears_1":-1,"face_2":21,"age_2":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"chest_3":0,"eyebrows_5":0,"shoes_2":0,"hair_1":10,"decals_2":0,"bodyb_2":0}', '{"bproof_1":0,"lipstick_2":10,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"shoes_1":184,"blush_2":10,"glasses_2":-1,"bracelets_1":-1,"face_3":6,"mask_2":2,"eyebrows_1":1,"arms":101,"lip_thickness":0,"torso_2":2,"eye_squint":0,"lipstick_1":3,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":3,"makeup_1":5,"helmet_2":-1,"nose_4":0,"mom":21,"nose_5":0,"arms_2":0,"complexion_2":1,"face_md_weight":50.0,"ears_2":-1,"nose_2":0,"sun_1":-1,"chin_3":0,"beard_3":0,"skin":12,"bproof_2":0,"decals_1":0,"pants_2":0,"chest_1":-1,"helmet_1":-1,"bags_1":0,"beard_4":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":67,"chest_2":10,"watches_1":-1,"chin_2":0,"bodyb_4":0,"nose_1":0,"cheeks_2":0,"pants_1":34,"skin_md_weight":6,"hair_color_2":0,"dad":0,"makeup_4":0,"makeup_2":10,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":1,"eyebrows_2":10,"nose_6":0,"eyebrows_3":26,"blush_1":-1,"blemishes_2":10,"beard_2":0,"neck_thickness":0,"glasses_1":-1,"eyebrows_4":12,"jaw_2":0,"watches_2":-1,"torso_1":707,"eye_color":0,"cheeks_3":0,"chin_4":0,"lipstick_3":20,"ears_1":-1,"face_2":21,"age_2":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"chest_3":0,"eyebrows_5":0,"shoes_2":0,"hair_1":30,"decals_2":0,"bodyb_2":0}', '[{"status":true,"model":"ambulance"},{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"}]', NULL, '', '[{"name":"medikit","status":true},{"name":"bandage","status":true}]'),
	('anchor', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('anchor', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('artesh', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('blacktide', 1, 'rank1', 'Runner', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('blacktide', 2, 'rank2', 'Enforcer', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('blacktide', 3, 'boss', 'Boss', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('burgershot', 0, 'trainee', 'Trainee', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('burgershot', 1, 'com', 'Cashier', 0, '{"face":0,"watches_2":-1,"watches_1":-1,"mom":21,"eyebrows_2":10,"bproof_1":0,"makeup_3":0,"beard_4":0,"face_1":0,"cheeks_2":0,"lipstick_3":0,"bodyb_2":0,"torso_1":15,"face_md_weight":50.0,"face_3":5,"eye_color":0,"chin_4":0,"bulletproof_vest_1":79,"cheeks_1":0,"chain_2":0,"decals_2":0,"skin_md_weight":6,"lipstick_2":0,"shoes_1":34,"sun_1":-1,"beard_3":0,"arms":15,"eyebrows_3":12,"chin_2":0,"eyebrows_1":0,"bracelets_1":-1,"bodyb_1":-1,"blush_1":-1,"torso_2":0,"moles_1":0,"eye_squint":0,"nose_5":0,"blemishes_1":-1,"makeup_1":0,"sex":0,"chin_1":0,"pants_1":61,"blemishes_2":10,"glasses_2":-1,"arms_2":0,"bulletproof_vest_2":0,"glasses_1":-1,"helmet_1":-1,"neck_thickness":0,"ears_1":-1,"nose_1":0,"makeup_2":0,"age_2":0,"eyebrows_6":0,"bodyb_3":-1,"hair_color_1":0,"hair_color_2":0,"tshirt_1":15,"moles_2":1,"ears_2":-1,"helmet_2":-1,"bulletproof_2":0,"lip_thickness":0,"jaw_2":0,"nose_2":0,"bulletproof_1":79,"jaw_1":0,"blush_2":10,"complexion_1":0,"dad":0,"nose_6":0,"bags_2":0,"mask_1":0,"eyebrows_5":0,"blush_3":0,"eyebrows_4":12,"beard_2":10,"cheeks_3":0,"complexion_2":1,"decals_1":0,"face_2":21,"chest_3":0,"bags_1":0,"hair_2":0,"lipstick_1":0,"sun_2":10,"beard_1":0,"shoes_2":0,"bracelets_2":0,"chest_2":10,"chest_1":-1,"chain_1":0,"age_1":0,"skin":12,"bproof_2":0,"nose_4":0,"pants_2":1,"hair_1":10,"tshirt_2":0,"chin_3":0,"makeup_4":0,"mask_2":2,"bodyb_4":0,"lipstick_4":0,"nose_3":0}', '{}', '[]', NULL, '', ''),
	('burgershot', 2, 'com', 'Visitor', 0, '{}', '{}', '[]', NULL, '', ''),
	('burgershot', 3, 'com', 'Chef', 0, '{"bags_1":0,"cheeks_1":9.9,"sun_2":10,"watches_1":-1,"blemishes_1":-1,"chest_2":10,"nose_6":0,"beard_3":0,"moles_1":0,"chin_3":9.9,"bracelets_1":-1,"dad":0,"eyebrows_1":0,"chest_3":0,"nose_4":0,"chain_2":0,"face":0,"cheeks_3":9.9,"shoes_2":0,"tshirt_2":0,"tshirt_1":15,"skin":12,"bulletproof_2":0,"eyebrows_3":12,"lip_thickness":5.69999999999999,"sun_1":-1,"sex":0,"bodyb_2":0,"blush_2":10,"beard_1":0,"glasses_2":-1,"makeup_4":0,"age_1":0,"bags_2":0,"face_1":0,"torso_1":20,"chest_1":-1,"complexion_2":1,"bodyb_3":-1,"watches_2":-1,"bulletproof_vest_1":79,"shoes_1":34,"nose_1":0,"hair_color_1":0,"makeup_1":0,"age_2":0,"bproof_1":0,"eyebrows_5":0,"glasses_1":-1,"face_2":21,"chin_2":9.9,"bulletproof_1":79,"face_3":5,"chin_1":9.9,"lipstick_3":0,"face_md_weight":50.0,"hair_color_2":0,"decals_1":0,"eye_color":0,"cheeks_2":9.9,"lipstick_2":0,"mask_1":0,"nose_5":0,"hair_2":0,"skin_md_weight":6,"ears_2":-1,"eyebrows_2":10,"lipstick_1":0,"neck_thickness":-10,"bproof_2":0,"bulletproof_vest_2":0,"arms_2":0,"jaw_1":9.9,"beard_4":0,"chain_1":0,"eyebrows_6":0,"beard_2":10,"jaw_2":0,"pants_2":1,"chin_4":9.9,"torso_2":0,"helmet_2":-1,"lipstick_4":0,"bodyb_4":0,"eyebrows_4":12,"decals_2":0,"bodyb_1":-1,"complexion_1":0,"mask_2":2,"eye_squint":0,"blemishes_2":10,"moles_2":1,"nose_3":0,"mom":21,"hair_1":10,"makeup_2":0,"ears_1":-1,"nose_2":0,"helmet_1":-1,"blush_1":-1,"makeup_3":0,"blush_3":0,"bracelets_2":0,"pants_1":61,"arms":15}', '{}', '[]', NULL, '', ''),
	('burgershot', 4, 'com', 'Manager', 0, '{}', '{}', '[]', NULL, '', ''),
	('burgershot', 5, 'boss', 'Boss', 0, '{"beard_2":10,"eyebrows_2":10,"blush_2":10,"sun_1":-1,"mom":21,"face_md_weight":50.0,"blemishes_2":10,"helmet_1":-1,"chain_2":0,"hair_2":0,"blush_3":0,"skin_md_weight":6,"chin_1":0,"tshirt_2":0,"makeup_2":0,"decals_2":0,"chin_4":0,"moles_1":0,"jaw_1":0,"face":0,"makeup_1":0,"chin_2":0,"nose_3":0,"eye_color":0,"beard_4":0,"eyebrows_6":0,"blemishes_1":-1,"glasses_2":3,"neck_thickness":0,"age_2":0,"nose_2":0,"dad":0,"lipstick_4":0,"sex":0,"bags_1":0,"nose_6":0,"arms_2":0,"pants_2":4,"bodyb_3":-1,"bags_2":0,"bulletproof_2":0,"bulletproof_vest_2":0,"face_2":21,"complexion_2":1,"watches_1":-1,"lipstick_1":0,"shoes_2":3,"eyebrows_3":12,"face_3":5,"moles_2":1,"bracelets_2":0,"hair_color_1":0,"age_1":0,"sun_2":10,"beard_3":0,"eyebrows_1":0,"bulletproof_vest_1":79,"torso_2":1,"ears_2":-1,"helmet_2":-1,"complexion_1":0,"watches_2":0,"bodyb_2":0,"mask_2":2,"eyebrows_4":12,"bracelets_1":-1,"pants_1":26,"lipstick_3":0,"nose_1":0,"lipstick_2":0,"bproof_1":0,"cheeks_3":0,"eyebrows_5":0,"glasses_1":5,"arms":35,"skin":12,"cheeks_1":0,"hair_1":10,"beard_1":0,"shoes_1":28,"hair_color_2":0,"bulletproof_1":79,"blush_1":-1,"chest_2":10,"makeup_3":0,"makeup_4":0,"bproof_2":0,"chest_3":0,"decals_1":0,"ears_1":-1,"chest_1":-1,"jaw_2":0,"nose_5":0,"eye_squint":0,"tshirt_1":15,"chin_3":0,"mask_1":0,"nose_4":0,"torso_1":281,"chain_1":0,"face_1":0,"cheeks_2":0,"bodyb_4":0,"lip_thickness":0,"bodyb_1":-1}', '{}', '[{"status":true,"model":"rumpo"}]', NULL, '', '[{"status":true,"name":"bread"},{"status":true,"name":"water"},{"status":true,"name":"pcucumber"},{"status":true,"name":"scheese"},{"status":true,"name":"tomato"},{"status":true,"name":"mushroom"},{"status":true,"name":"meat"}]'),
	('cafe', 0, 'trainee', 'Trainee', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('cafe', 1, 'boss', 'Chief', 20000, '{"shoes_1":40,"tshirt_1":247,"bags_2":0,"pants_2":0,"chain_1":60,"glasses_2":0,"glasses_1":51,"torso_1":697,"mask_1":-1,"tshirt_2":0,"mask_2":0,"decals_2":0,"helmet_1":-1,"chain_2":0,"helmet_2":0,"arms":24,"torso_2":0,"bags_1":-1,"pants_1":14,"decals_1":0,"bproof_2":0,"bproof_1":0,"shoes_2":0}', '{}', '[{"status":true,"model":"rumpo"}]', NULL, '', ''),
	('cardealer', 0, 'recruit', 'Recruit', 10, '{}', '{}', NULL, NULL, NULL, NULL),
	('cardealer', 1, 'novice', 'Novice', 25, '{}', '{}', NULL, NULL, NULL, NULL),
	('cardealer', 2, 'experienced', 'Experienced', 40, '{}', '{}', NULL, NULL, NULL, NULL),
	('cardealer', 3, 'boss', 'Boss', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('carwash', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('carwash', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('cia', 0, 'trainee', 'Trainee', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('cia', 1, 'com', 'Agent', 1000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 2, 'com', 'Field Agent ', 1500, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 3, 'com', 'Senior Agent ', 2000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 4, 'com', 'Special Agent', 3000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 5, 'com', 'Trooper ', 4000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 6, 'com', 'Senior Trooper', 5000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 7, 'com', 'Master Trooper', 6000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 8, 'com', 'Sergeant', 7000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 9, 'com', 'Senior Sergeant', 8000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 10, 'com', 'Master Sergeant', 9000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 11, 'com', 'Watch SPT', 10000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 12, 'com', 'Lieutenant', 11000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 13, 'com', 'Captain', 12000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 14, 'com', 'Major', 13000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 15, 'boss', 'Colonel ', 14000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 16, 'boss', 'Overseer', 15000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 17, 'boss', 'HQ Overseer', 16000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 18, 'boss', 'Operation Manager ', 17000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 19, 'boss', 'Regulation Manager', 18000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 20, 'boss', 'Deputy Director Of CIA', 19000, '{}', '{}', '[]', NULL, '[]', ''),
	('cia', 21, 'boss', 'Director of the CIA', 20000, '{"eye_color":0,"chest_2":10,"chin_4":0,"makeup_4":0,"decals_2":0,"arms":58,"face_3":5,"face_2":21,"helmet_1":-1,"glasses_2":4,"shoes_2":1,"bproof_2":5,"blush_3":0,"chin_1":0,"chest_1":-1,"eyebrows_3":12,"mom":21,"makeup_3":0,"arms_2":0,"bodyb_1":-1,"jaw_2":0,"makeup_2":0,"torso_1":606,"bags_2":0,"eye_squint":0,"skin_md_weight":6,"mask_2":0,"face_1":0,"hair_color_1":0,"shoes_1":99,"lip_thickness":0,"chest_3":0,"beard_4":0,"beard_1":0,"lipstick_1":0,"face_md_weight":50.0,"lipstick_4":0,"age_1":0,"nose_6":0,"blush_1":-1,"pants_2":10,"hair_2":0,"nose_1":0,"face":0,"nose_3":0,"complexion_1":0,"nose_2":0,"chain_2":1,"chin_3":0,"eyebrows_4":12,"bodyb_2":0,"eyebrows_5":0,"bracelets_2":0,"beard_2":10,"jaw_1":0,"bulletproof_2":0,"sun_2":10,"neck_thickness":-10,"glasses_1":5,"bulletproof_1":79,"bodyb_3":-1,"eyebrows_1":0,"blush_2":10,"ears_2":-1,"sun_1":-1,"decals_1":0,"torso_2":0,"mask_1":121,"hair_color_2":0,"tshirt_1":267,"dad":0,"cheeks_1":0,"sex":0,"cheeks_2":0,"complexion_2":1,"blemishes_1":-1,"lipstick_3":0,"nose_5":0,"age_2":0,"eyebrows_6":0,"bulletproof_vest_1":79,"beard_3":0,"cheeks_3":0,"bags_1":0,"eyebrows_2":10,"ears_1":-1,"makeup_1":0,"nose_4":0,"helmet_2":0,"moles_2":1,"lipstick_2":0,"bracelets_1":-1,"chin_2":0,"tshirt_2":0,"bodyb_4":0,"hair_1":10,"moles_1":0,"chain_1":226,"watches_1":-1,"bulletproof_vest_2":0,"watches_2":-1,"bproof_1":91,"skin":12,"pants_1":117,"blemishes_2":10}', '{}', '[]', NULL, '[]', ''),
	('cid', 0, 'cadet', 'Cadet', 7500, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 1, 'po1', 'CID Officer 1', 7760, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 2, 'po2', 'CID Officer 2', 8020, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 3, 'po3', 'CID Officer 3', 8280, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 4, 'po4', 'CID Officer 4', 8540, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 5, 'po5', 'CID Officer 5', 8800, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 6, 'po6', 'CID Officer 6', 9060, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 7, 'po7', 'CID Officer 7', 9320, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 8, 'po8', 'CID Officer 8', 9580, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 9, 'po9', 'CID Officer 9', 9840, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 10, 'po10', 'CID Officer 10', 10100, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 11, 'po11', 'CID Officer 11', 10360, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 12, 'po12', 'CID Officer 12', 10620, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 13, 'po13', 'CID Officer 13', 10880, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 14, 'po14', 'CID Officer 14', 11140, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 15, 'po15', 'CID Officer 15', 11400, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 16, 'sergeant', 'Sergeant', 11700, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 17, 'lieutenant', 'Lieutenant', 12000, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 18, 'captain', 'Captain', 12400, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 19, 'deputychief', 'Deputy Chief', 12800, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 20, 'assistantboss', 'Assistant Chief of CID', 13200, '{}', '{}', NULL, NULL, NULL, NULL),
	('cid', 21, 'boss', 'Chief of CID', 14000, '{}', '{}', NULL, NULL, NULL, NULL),
	('coffee', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('cratecarry', 1, 'rank1', 'Driver', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('cratecarry', 2, 'rank2', 'Manager', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('cratecarry', 3, 'boss', 'Owner', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('crimson', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('dadgostari', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 0, 'cadet', 'Cadet', 7500, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 1, 'po1', 'DOA Officer 1', 7760, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 2, 'po2', 'DOA Officer 2', 8020, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 3, 'po3', 'DOA Officer 3', 8280, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 4, 'po4', 'DOA Officer 4', 8540, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 5, 'po5', 'DOA Officer 5', 8800, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 6, 'po6', 'DOA Officer 6', 9060, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 7, 'po7', 'DOA Officer 7', 9320, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 8, 'po8', 'DOA Officer 8', 9580, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 9, 'po9', 'DOA Officer 9', 9840, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 10, 'po10', 'DOA Officer 10', 10100, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 11, 'po11', 'DOA Officer 11', 10360, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 12, 'po12', 'DOA Officer 12', 10620, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 13, 'po13', 'DOA Officer 13', 10880, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 14, 'po14', 'DOA Officer 14', 11140, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 15, 'po15', 'DOA Officer 15', 11400, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 16, 'sergeant', 'Sergeant', 11700, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 17, 'lieutenant', 'Lieutenant', 12000, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 18, 'captain', 'Captain', 12400, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 19, 'deputychief', 'Deputy Chief', 12800, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 20, 'assistantboss', 'Assistant Director of DOA', 13200, '{}', '{}', NULL, NULL, NULL, NULL),
	('doa', 21, 'boss', 'Director of DOA', 14000, '{}', '{}', NULL, NULL, NULL, NULL),
	('doc', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('ember', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('ember', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('fbi', 0, 'agent', 'Agent', 20, '{}', '{}', NULL, NULL, NULL, NULL),
	('fbi', 1, 'cadet', 'Agent', 30000, '{"torso_1":349,"mom":21,"lip_thickness":0,"blush_1":-1,"cheeks_1":-0.1,"jaw_2":0,"arms":25,"lipstick_1":0,"eyebrows_5":0,"tshirt_2":0,"makeup_1":0,"sun_2":10,"blemishes_2":10,"face_3":5,"decals_2":0,"eyebrows_6":-10,"decals_1":0,"blush_3":0,"eyebrows_2":10,"bodyb_3":-1,"nose_1":0,"chin_1":3.59999999999999,"moles_1":0,"bodyb_2":0,"eyebrows_1":0,"bproof_2":0,"bodyb_4":0,"makeup_2":0,"bproof_1":53,"eyebrows_3":12,"skin_md_weight":0,"eye_color":0,"nose_6":0,"bulletproof_vest_1":79,"makeup_4":0,"glasses_2":2,"torso_2":15,"beard_4":0,"bags_2":0,"chain_1":226,"shoes_2":0,"face_2":21,"watches_2":-1,"lipstick_3":0,"bracelets_2":0,"bulletproof_2":0,"nose_5":0,"chin_2":0,"cheeks_2":0,"bulletproof_vest_2":0,"chain_2":0,"age_1":0,"eyebrows_4":12,"blemishes_1":-1,"bulletproof_1":79,"face_1":0,"arms_2":0,"shoes_1":20,"chest_2":10,"dad":0,"neck_thickness":0,"moles_2":1,"ears_2":0,"helmet_2":0,"lipstick_4":0,"complexion_1":0,"hair_color_2":0,"bodyb_1":-1,"tshirt_1":15,"eye_squint":0,"chest_3":0,"nose_3":0,"nose_2":0,"jaw_1":0,"pants_1":28,"age_2":0,"hair_color_1":0,"pants_2":0,"face":0,"hair_2":0,"helmet_1":-1,"skin":12,"blush_2":10,"bracelets_1":-1,"mask_2":0,"glasses_1":5,"hair_1":10,"mask_1":121,"watches_1":-1,"chin_3":0,"beard_2":10,"bags_1":0,"chin_4":0,"nose_4":0,"cheeks_3":0,"sex":0,"ears_1":-1,"beard_3":0,"sun_1":-1,"beard_1":0,"lipstick_2":0,"chest_1":-1,"makeup_3":0,"complexion_2":1,"face_md_weight":50}', '{}', '', NULL, '[{"status":false,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_MICROSMG"},{"status":false,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_APPISTOL"},{"status":false,"model":"WEAPON_CERAMICPISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":false,"model":"WEAPON_HEAVYPISTOL"},{"status":false,"model":"WEAPON_SNSPISTOL"},{"status":false,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":false,"model":"WEAPON_COMBATPDW"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":false,"model":"WEAPON_ADVANCEDRIFLE"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":false,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":false,"model":"WEAPON_PISTOL_MK2"},{"status":false,"model":"WEAPON_SMG_MK2"},{"status":false,"model":"WEAPON BZGAS"},{"status":false,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":false,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":false,"model":"wWEAPON_knuckle"},{"status":false,"model":"WEAPON_SNSPISTOL_MK2"}]', ''),
	('fbi', 2, 'po1', 'Senior Agent', 14000, '{}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":false,"model":"polgt17"},{"status":false,"model":"porsche"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"cla45"},{"status":false,"model":"ateamvan"}]', NULL, '[{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_MICROSMG","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_APPISTOL","status":false},{"model":"WEAPON_CERAMICPISTOL","status":false},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_HEAVYPISTOL","status":false},{"model":"WEAPON_SNSPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_NIGHTSTICK","status":false},{"model":"WEAPON_STUNGUN","status":false},{"model":"WEAPON_FLASHLIGHT","status":false},{"model":"WEAPON_COMBATPDW","status":true},{"model":"WEAPON_CARBINERIFLE","status":false},{"model":"WEAPON_ADVANCEDRIFLE","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_SPECIALCARBINE_MK2","status":false},{"model":"WEAPON_BULLPOPRIFLE_MK2","status":false},{"model":"WEAPON_PISTOL_MK2","status":false},{"model":"WEAPON_SMG_MK2","status":false},{"model":"WEAPON BZGAS","status":true},{"model":"WEAPON_ASSAULTRIFLE_MK2","status":false},{"model":"WEAPON_CARBINERIFLE_MK2","status":false},{"model":"wWEAPON_knuckle","status":false},{"model":"WEAPON_SNSPISTOL_MK2","status":false}]', ''),
	('fbi', 3, 'po1', 'Master Agent', 15000, '{}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('fbi', 4, 'po1', 'Lead Agent', 16000, '{"eyebrows_3":12,"blush_1":-1,"chest_1":-1,"eyebrows_6":0,"beard_2":10,"eyebrows_2":10,"cheeks_2":0,"makeup_1":0,"glasses_1":5,"ears_2":-1,"torso_1":612,"blush_3":0,"bracelets_1":-1,"skin":12,"age_2":0,"moles_2":1,"bulletproof_1":79,"bodyb_4":0,"bags_1":0,"helmet_2":-1,"bulletproof_vest_2":0,"face_3":5,"torso_2":0,"sun_2":10,"lipstick_1":0,"lipstick_4":0,"face_md_weight":50.0,"sex":0,"arms":24,"glasses_2":1,"bproof_2":0,"chin_4":0,"skin_md_weight":6,"neck_thickness":0,"chest_3":0,"tshirt_2":3,"shoes_1":10,"bproof_1":0,"jaw_2":0,"watches_1":-1,"chin_3":0,"shoes_2":0,"blush_2":10,"bulletproof_vest_1":79,"mask_2":0,"bulletproof_2":0,"beard_1":0,"makeup_4":0,"nose_4":0,"jaw_1":0,"bags_2":0,"eyebrows_1":0,"face":0,"bracelets_2":0,"face_2":21,"pants_1":28,"ears_1":-1,"makeup_3":0,"watches_2":-1,"mom":45,"beard_3":0,"chain_2":0,"cheeks_1":0,"nose_1":0,"cheeks_3":0,"makeup_2":0,"bodyb_2":0,"eye_squint":0,"sun_1":-1,"beard_4":0,"blemishes_2":10,"chin_2":0,"hair_1":10,"dad":8,"decals_2":0,"lipstick_3":0,"chest_2":10,"decals_1":0,"tshirt_1":72,"age_1":0,"chin_1":0,"bodyb_3":-1,"hair_2":0,"nose_3":0,"complexion_1":0,"nose_2":0,"pants_2":0,"bodyb_1":-1,"arms_2":0,"nose_5":0,"eye_color":0,"complexion_2":1,"helmet_1":-1,"chain_1":0,"lipstick_2":0,"face_1":0,"nose_6":0,"blemishes_1":-1,"eyebrows_5":0,"moles_1":0,"hair_color_2":0,"mask_1":121,"lip_thickness":0,"eyebrows_4":12,"hair_color_1":0}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('fbi', 5, 'po1', 'Command', 17000, '{"eyebrows_3":12,"blush_1":-1,"chest_1":-1,"eyebrows_6":0,"beard_2":10,"eyebrows_2":10,"cheeks_2":0,"moles_1":0,"glasses_1":5,"ears_2":-1,"torso_1":95,"blush_3":0,"bracelets_1":-1,"skin":12,"age_2":0,"moles_2":1,"bulletproof_1":79,"bodyb_4":0,"bags_1":0,"helmet_2":0,"mask_1":121,"face_3":5,"complexion_2":1,"sun_2":10,"lipstick_1":0,"lipstick_4":0,"face_md_weight":50.0,"sex":0,"arms":26,"glasses_2":1,"bproof_2":0,"bulletproof_vest_2":0,"skin_md_weight":9,"neck_thickness":0,"chest_3":0,"tshirt_2":0,"shoes_1":10,"sun_1":-1,"torso_2":1,"jaw_2":0,"tshirt_1":210,"shoes_2":0,"cheeks_1":0,"bulletproof_vest_1":79,"mask_2":0,"chin_3":0,"bproof_1":55,"makeup_4":0,"nose_4":0,"jaw_1":0,"bulletproof_2":0,"eyebrows_1":0,"watches_1":6,"chin_1":0,"face_2":21,"pants_1":24,"ears_1":-1,"makeup_3":0,"face":0,"mom":21,"beard_3":0,"bracelets_2":0,"decals_2":0,"nose_1":0,"cheeks_3":0,"makeup_2":0,"chain_2":0,"hair_color_2":0,"makeup_1":0,"beard_4":0,"blemishes_2":10,"chin_2":0,"hair_1":10,"nose_5":0,"chin_4":0,"lipstick_3":0,"chest_2":10,"decals_1":0,"dad":13,"age_1":0,"bodyb_2":0,"blush_2":10,"hair_2":0,"nose_3":0,"nose_2":0,"nose_6":0,"eye_squint":0,"bodyb_1":-1,"arms_2":0,"watches_2":2,"eye_color":0,"beard_1":0,"helmet_1":243,"chain_1":0,"eyebrows_4":12,"face_1":0,"complexion_1":0,"blemishes_1":-1,"eyebrows_5":0,"lipstick_2":0,"bags_2":0,"bodyb_3":-1,"lip_thickness":0,"pants_2":1,"hair_color_1":0}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('fbi', 6, 'boss', 'Deputy Chief', 18000, '{"eyebrows_3":12,"blush_1":-1,"chest_1":-1,"eyebrows_6":0,"beard_2":10,"eyebrows_2":10,"cheeks_2":0,"makeup_1":0,"glasses_1":5,"ears_2":-1,"torso_1":606,"blush_3":0,"bracelets_1":-1,"skin":12,"age_2":0,"moles_2":1,"bulletproof_1":79,"bodyb_4":0,"bags_1":0,"helmet_2":0,"bulletproof_vest_2":0,"face_3":5,"torso_2":6,"sun_2":10,"lipstick_1":0,"lipstick_4":0,"face_md_weight":50.0,"sex":0,"arms":25,"glasses_2":1,"bproof_2":0,"chin_4":0,"skin_md_weight":6,"neck_thickness":0,"chest_3":0,"tshirt_2":0,"shoes_1":25,"bproof_1":54,"jaw_2":0,"watches_1":14,"chin_3":0,"shoes_2":0,"blush_2":10,"bulletproof_vest_1":79,"mask_2":0,"bulletproof_2":0,"beard_1":0,"makeup_4":0,"nose_4":0,"jaw_1":0,"bags_2":0,"eyebrows_1":0,"face":0,"bracelets_2":0,"face_2":21,"pants_1":33,"ears_1":-1,"makeup_3":0,"watches_2":0,"mom":45,"beard_3":0,"chain_2":0,"cheeks_1":0,"nose_1":0,"cheeks_3":0,"makeup_2":0,"bodyb_2":0,"eye_squint":0,"sun_1":-1,"beard_4":0,"blemishes_2":10,"chin_2":0,"hair_1":10,"dad":8,"decals_2":0,"lipstick_3":0,"chest_2":10,"decals_1":0,"tshirt_1":250,"age_1":0,"chin_1":0,"bodyb_3":-1,"hair_2":0,"nose_3":0,"complexion_1":0,"nose_2":0,"pants_2":0,"bodyb_1":-1,"arms_2":0,"nose_5":0,"eye_color":0,"complexion_2":1,"helmet_1":-1,"chain_1":180,"lipstick_2":0,"face_1":0,"nose_6":0,"blemishes_1":-1,"eyebrows_5":0,"moles_1":0,"hair_color_2":0,"mask_1":121,"lip_thickness":0,"eyebrows_4":12,"hair_color_1":0}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('fbi', 7, 'boss', 'Chief', 19000, '{"bodyb_4":0,"helmet_2":0,"neck_thickness":0,"mom":21,"blemishes_1":-1,"beard_1":0,"bodyb_2":0,"skin":12,"makeup_2":0,"hair_color_1":0,"lipstick_1":0,"bulletproof_vest_1":79,"face_1":0,"bulletproof_2":0,"chin_2":0,"nose_3":0,"chain_1":226,"lipstick_2":0,"blush_2":10,"jaw_1":0,"cheeks_2":0,"decals_2":0,"bproof_1":54,"eyebrows_6":0,"chin_4":0,"nose_4":0,"face_3":5,"eyebrows_1":0,"beard_3":0,"sun_1":-1,"face":0,"arms_2":0,"cheeks_1":0,"mask_2":8,"lip_thickness":0,"hair_color_2":0,"chin_3":0,"shoes_2":1,"moles_2":1,"arms":19,"eye_color":0,"ears_2":-1,"beard_2":10,"makeup_3":0,"mask_1":239,"bodyb_3":-1,"tshirt_2":0,"jaw_2":0,"nose_1":0,"nose_6":0,"dad":13,"chin_1":0,"beard_4":0,"glasses_1":5,"sun_2":10,"torso_2":0,"bracelets_2":0,"bags_2":0,"chain_2":0,"complexion_2":1,"chest_3":0,"eyebrows_4":12,"lipstick_3":0,"bracelets_1":-1,"bodyb_1":-1,"ears_1":-1,"moles_1":0,"face_2":21,"torso_1":613,"bags_1":0,"tshirt_1":210,"eyebrows_2":10,"lipstick_4":0,"nose_5":0,"complexion_1":0,"pants_2":0,"sex":0,"face_md_weight":50.0,"eye_squint":0,"makeup_4":0,"chest_2":10,"glasses_2":1,"makeup_1":0,"eyebrows_3":12,"blush_3":0,"skin_md_weight":9,"bproof_2":0,"bulletproof_1":79,"eyebrows_5":0,"cheeks_3":0,"bulletproof_vest_2":0,"age_2":0,"age_1":0,"shoes_1":99,"helmet_1":83,"hair_2":0,"blush_1":-1,"nose_2":0,"decals_1":0,"watches_1":4,"pants_1":4,"watches_2":1,"hair_1":10,"chest_1":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('fbi', 8, 'boss', 'General', 20000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"bulletproof_1":79,"nose_4":0,"nose_6":0,"mask_2":0,"nose_5":0,"eye_squint":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"watches_1":-1,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":57,"sun_2":10,"hair_color_1":0,"arms":52,"bulletproof_vest_1":79,"bags_2":0,"face_1":0,"bracelets_2":0,"chest_1":-1,"beard_4":0,"pants_1":4,"eyebrows_6":0,"glasses_2":0,"moles_1":0,"pants_2":0,"watches_2":-1,"chin_2":0,"eyebrows_5":0,"cheeks_3":0,"bproof_1":117,"sex":0,"jaw_2":0,"makeup_3":0,"ears_1":-1,"decals_1":0,"lipstick_2":0,"beard_2":10,"chain_2":0,"torso_2":15,"jaw_1":0,"bulletproof_vest_2":0,"beard_1":0,"chin_4":0,"hair_1":10,"blush_1":-1,"mask_1":121,"cheeks_1":0,"nose_2":0,"eye_color":0,"face_3":5,"bodyb_2":0,"chin_1":0,"nose_1":0,"blemishes_1":-1,"eyebrows_4":12,"face":0,"complexion_1":0,"torso_1":574,"chain_1":296,"bproof_2":1,"helmet_2":-1,"hair_color_2":0,"dad":0,"bags_1":0,"tshirt_1":214,"bodyb_3":-1,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":6,"chin_3":0,"bulletproof_2":0,"chest_3":0,"makeup_4":0,"lipstick_1":0,"face_md_weight":50.0,"chest_2":10,"helmet_1":-1,"glasses_1":5,"makeup_2":0,"complexion_2":1,"shoes_2":9,"beard_3":0,"age_1":0,"eyebrows_2":10,"hair_2":0,"arms_2":0,"lipstick_3":0,"tshirt_2":0,"moles_2":1,"sun_1":-1,"mom":21,"neck_thickness":0,"blush_3":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"escalade"},{"status":true,"model":"pf"},{"status":true,"model":"sunbmfbi"},{"status":true,"model":"riot2"},{"status":true,"model":"polgt17"},{"status":true,"model":"porsche"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"cla45"},{"status":true,"model":"ateamvan"}]', NULL, '[{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_MICROSMG"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_APPISTOL"},{"status":true,"model":"WEAPON_CERAMICPISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_HEAVYPISTOL"},{"status":true,"model":"WEAPON_SNSPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_COMBATPDW"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ADVANCEDRIFLE"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_SPECIALCARBINE_MK2"},{"status":true,"model":"WEAPON_BULLPOPRIFLE_MK2"},{"status":true,"model":"WEAPON_PISTOL_MK2"},{"status":true,"model":"WEAPON_SMG_MK2"},{"status":true,"model":"WEAPON BZGAS"},{"status":true,"model":"WEAPON_ASSAULTRIFLE_MK2"},{"status":true,"model":"WEAPON_CARBINERIFLE_MK2"},{"status":true,"model":"wWEAPON_knuckle"},{"status":true,"model":"WEAPON_SNSPISTOL_MK2"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('firebrick', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('firebrick', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('fisherman', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('flourish', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('flourish', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('food', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('forces', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('frostbite', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('frostbite', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('fueler', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('goldcrust', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('goldcrust', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('government', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 0, 'cadet', 'Cadet', 7500, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 1, 'po1', 'Judge Officer 1', 7760, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 2, 'po2', 'Judge Officer 2', 8020, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 3, 'po3', 'Judge Officer 3', 8280, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 4, 'po4', 'Judge Officer 4', 8540, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 5, 'po5', 'Judge Officer 5', 8800, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 6, 'po6', 'Judge Officer 6', 9060, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 7, 'po7', 'Judge Officer 7', 9320, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 8, 'po8', 'Judge Officer 8', 9580, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 9, 'po9', 'Judge Officer 9', 9840, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 10, 'po10', 'Judge Officer 10', 10100, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 11, 'po11', 'Judge Officer 11', 10360, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 12, 'po12', 'Judge Officer 12', 10620, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 13, 'po13', 'Judge Officer 13', 10880, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 14, 'po14', 'Judge Officer 14', 11140, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 15, 'po15', 'Judge Officer 15', 11400, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 16, 'sergeant', 'Sergeant', 11700, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 17, 'lieutenant', 'Lieutenant', 12000, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 18, 'captain', 'Captain', 12400, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 19, 'deputychief', 'Deputy Chief', 12800, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 20, 'assistantboss', 'Assistant Chief Justice', 13200, '{}', '{}', NULL, NULL, NULL, NULL),
	('judge', 21, 'boss', 'Chief Justice', 14000, '{}', '{}', NULL, NULL, NULL, NULL),
	('koi', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('koi', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('lumberjack', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('marshal', 0, 'cadet', 'Cadet', 7500, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 1, 'po1', 'Marshal Officer 1', 7760, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 2, 'po2', 'Marshal Officer 2', 8020, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 3, 'po3', 'Marshal Officer 3', 8280, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 4, 'po4', 'Marshal Officer 4', 8540, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 5, 'po5', 'Marshal Officer 5', 8800, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 6, 'po6', 'Marshal Officer 6', 9060, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 7, 'po7', 'Marshal Officer 7', 9320, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 8, 'po8', 'Marshal Officer 8', 9580, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 9, 'po9', 'Marshal Officer 9', 9840, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 10, 'po10', 'Marshal Officer 10', 10100, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 11, 'po11', 'Marshal Officer 11', 10360, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 12, 'po12', 'Marshal Officer 12', 10620, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 13, 'po13', 'Marshal Officer 13', 10880, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 14, 'po14', 'Marshal Officer 14', 11140, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 15, 'po15', 'Marshal Officer 15', 11400, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 16, 'sergeant', 'Sergeant', 11700, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 17, 'lieutenant', 'Lieutenant', 12000, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 18, 'captain', 'Captain', 12400, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 19, 'deputychief', 'Deputy Chief', 12800, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 20, 'assistantboss', 'Assistant Chief Marshal', 13200, '{}', '{}', NULL, NULL, NULL, NULL),
	('marshal', 21, 'boss', 'Chief Marshal', 14000, '{}', '{}', NULL, NULL, NULL, NULL),
	('mechanic', 0, 'recrue', 'Recrue', 12, '{}', '{}', NULL, NULL, NULL, NULL),
	('mechanic', 1, 'recrue', 'Rank 1', 3000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":4,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":1,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":1,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 2, 'novice', 'Rank 2', 4000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":18,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":15,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":15,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 3, 'novice', 'Rank 3', 5000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":18,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":15,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":15,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":false},{"model":"poljug","status":true},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 4, 'rimente', 'Rank 4', 6000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":1,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":22,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":2,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":false},{"model":"poljug","status":true},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 5, 'rimente', 'Rank 5', 7000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":1,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":22,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":2,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 6, 'rimente', 'Rank 6', 8000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":13,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":19,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":19,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":false},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 7, 'rimente', 'Rank 7', 9000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":34,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":13,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":19,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":19,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 8, 'rimente', 'Rank 8', 10000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":15,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":16,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":16,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 9, 'rimente', 'Rank 9', 11000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":70,"sun_2":10,"hair_color_1":0,"arms":32,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":15,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":16,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":247,"chain_1":0,"pants_1":97,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":16,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 10, 'rimente', 'Rank 10', 12000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":false},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 11, 'rimente', 'Rank 11', 13000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 12, 'rimente', 'Rank 12', 14000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":false}]', NULL, '', '[]'),
	('mechanic', 13, 'rimente', 'Rank 13', 15000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":true}]', NULL, '', '[]'),
	('mechanic', 14, 'rimente', 'Rank 14', 16000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":11,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":false},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":true}]', NULL, '', '[]'),
	('mechanic', 15, 'rimente', 'Rank 15', 17000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":227,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":197,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":1,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":true}]', NULL, '', '[]'),
	('mechanic', 16, 'boss', 'Rank 16', 18000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":10,"sun_2":10,"hair_color_1":0,"arms":30,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":15,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":28,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":0,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":-1,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"motorpm","status":true},{"model":"orbmwm5","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"polkmd","status":true},{"model":"polreb","status":true},{"model":"polros","status":true}]', NULL, '', '[]'),
	('mechanic', 17, 'boss', 'Rank 17', 19000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":2,"nose_5":0,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":10,"sun_2":10,"hair_color_1":0,"arms":19,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":15,"eyebrows_6":0,"glasses_2":-1,"lipstick_1":0,"watches_2":-1,"chin_2":0,"chest_1":-1,"nose_2":0,"eyebrows_2":10,"cheeks_3":0,"jaw_2":0,"sex":0,"ears_1":-1,"decals_1":0,"makeup_3":0,"lipstick_2":0,"chain_2":0,"torso_2":0,"sun_1":3,"jaw_1":0,"beard_1":0,"chin_4":0,"pants_2":0,"blush_1":-1,"eye_squint":0,"cheeks_1":-3.3,"eyebrows_4":12,"eye_color":0,"face_3":5,"bodyb_2":0,"moles_1":0,"chin_1":0,"chin_3":0,"nose_1":0,"blemishes_1":-1,"complexion_1":0,"torso_1":597,"chain_1":0,"pants_1":28,"makeup_2":0,"bodyb_3":-1,"dad":44,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":10,"eyebrows_5":4.0,"hair_1":10,"blush_3":0,"chest_3":0,"tshirt_2":0,"face_md_weight":20.0,"mask_1":0,"helmet_1":-1,"glasses_1":-1,"helmet_2":0,"complexion_2":1,"beard_2":10,"shoes_2":0,"beard_3":0,"hair_2":0,"beard_4":0,"arms_2":0,"lipstick_3":0,"makeup_4":0,"moles_2":1,"chest_2":10,"mom":21,"watches_1":-1,"bproof_2":0,"ears_2":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"}]', NULL, '', '[]'),
	('mechanic', 18, 'boss', 'Rank 18', 20000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"}]', NULL, '', '[]'),
	('meridian', 1, 'rank1', 'Analyst', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('meridian', 2, 'rank2', 'Director', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('meridian', 3, 'boss', 'CEO', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('miner', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('mt', 1, 'com', 'Officer I', 3000, '{"decals_1":0,"lipstick_2":0,"nose_5":0,"dad":0,"mask_2":0,"chin_3":0,"bulletproof_2":0,"cheeks_1":0,"watches_1":-1,"hair_color_1":0,"hair_color_2":0,"torso_1":569,"glasses_1":5,"eye_squint":0,"moles_2":1,"chest_1":-1,"chin_2":0,"eyebrows_4":12,"bags_1":0,"complexion_1":0,"neck_thickness":0,"jaw_2":0,"lip_thickness":0,"face_1":0,"nose_3":0,"lipstick_3":0,"makeup_4":0,"eyebrows_5":0,"skin":12,"sun_2":10,"shoes_1":25,"pants_2":1,"makeup_1":0,"glasses_2":1,"nose_1":0,"beard_4":0,"hair_1":10,"bracelets_1":-1,"bracelets_2":0,"eyebrows_2":10,"bulletproof_vest_2":0,"bproof_2":0,"lipstick_1":0,"tshirt_1":208,"jaw_1":0,"bproof_1":115,"mask_1":0,"face":0,"eyebrows_1":0,"sun_1":-1,"torso_2":1,"face_3":5,"pants_1":130,"moles_1":0,"beard_1":0,"blush_3":0,"mom":25,"nose_6":0,"blush_1":-1,"chest_2":10,"sex":0,"watches_2":-1,"beard_2":10,"bodyb_1":-1,"cheeks_2":0,"nose_4":0,"tshirt_2":0,"decals_2":0,"nose_2":0,"bodyb_3":-1,"face_md_weight":50,"age_1":0,"complexion_2":1,"helmet_2":-1,"lipstick_4":0,"ears_1":-1,"eyebrows_6":0,"beard_3":0,"chain_2":2,"chin_1":0,"bulletproof_1":79,"chain_1":112,"bulletproof_vest_1":79,"arms_2":0,"blemishes_1":-1,"face_2":21,"hair_2":0,"eye_color":0,"blemishes_2":10,"skin_md_weight":2,"bodyb_4":0,"arms":30,"age_2":0,"ears_2":-1,"makeup_2":0,"bags_2":0,"helmet_1":-1,"cheeks_3":0,"chin_4":0,"makeup_3":0,"chest_3":0,"blush_2":10,"eyebrows_3":12,"bodyb_2":0,"shoes_2":0}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":false},{"model":"shacara","status":true},{"model":"polreb","status":false},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":false},{"model":"polkch","status":true},{"model":"poljug","status":false},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":false},{"model":"WEAPON_FLASHLIGHT","status":false},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_CARBINERIFLE","status":false},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":false,"name":"blackmoney"},{"status":false,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"},{"status":false,"name":"water"}]'),
	('mt', 2, 'com', 'Officer II', 4000, '{"ears_1":-1,"mask_2":0,"chest_3":0,"decals_2":0,"torso_2":1,"beard_2":10,"age_2":0,"makeup_3":0,"beard_1":0,"glasses_2":1,"shoes_2":0,"torso_1":576,"lipstick_2":0,"pants_2":1,"hair_color_1":0,"bodyb_4":0,"chest_2":10,"eyebrows_6":0,"eye_squint":0,"bproof_1":66,"lipstick_3":0,"eyebrows_2":10,"makeup_2":0,"bproof_2":0,"dad":0,"mask_1":0,"tshirt_2":0,"eye_color":0,"chain_1":112,"bags_2":0,"age_1":0,"face":0,"chest_1":-1,"nose_2":0,"lipstick_1":0,"sex":0,"helmet_1":142,"watches_2":-1,"shoes_1":25,"watches_1":-1,"face_3":5,"makeup_1":0,"eyebrows_4":12,"chin_4":0,"eyebrows_1":0,"beard_3":0,"complexion_1":0,"blush_3":0,"nose_4":0,"bags_1":0,"eyebrows_3":12,"blush_1":-1,"ears_2":-1,"eyebrows_5":0,"neck_thickness":0,"blush_2":10,"nose_1":0,"tshirt_1":208,"bracelets_1":-1,"complexion_2":1,"hair_2":0,"skin_md_weight":6,"chin_2":0,"sun_1":-1,"lipstick_4":0,"cheeks_2":0,"bulletproof_vest_2":0,"bodyb_2":0,"blemishes_2":10,"cheeks_3":0,"makeup_4":0,"nose_5":0,"chin_3":0,"cheeks_1":0,"arms_2":0,"face_2":21,"face_md_weight":50.0,"hair_1":10,"bulletproof_1":79,"decals_1":0,"face_1":0,"nose_3":0,"skin":12,"bodyb_1":-1,"jaw_1":0,"bulletproof_vest_1":79,"hair_color_2":0,"bracelets_2":0,"arms":19,"sun_2":10,"chin_1":0,"pants_1":130,"moles_1":0,"helmet_2":0,"moles_2":1,"nose_6":0,"mom":21,"bodyb_3":-1,"lip_thickness":0,"glasses_1":5,"jaw_2":0,"bulletproof_2":0,"beard_4":0,"blemishes_1":12,"chain_2":2}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":false},{"model":"shacara","status":true},{"model":"polreb","status":false},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":true},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":false},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":false},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_CARBINERIFLE","status":false},{"model":"WEAPON_ASSAULTSMG","status":false},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":false,"name":"eclip"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":false,"name":"xpshop"},{"status":false,"name":"lsd"}]'),
	('mt', 3, 'com', 'Officer III', 5000, '{"decals_1":0,"lipstick_2":0,"nose_5":0,"dad":0,"mask_2":13,"chin_3":0,"bulletproof_2":0,"cheeks_1":0,"watches_1":-1,"hair_color_1":0,"hair_color_2":0,"torso_1":568,"glasses_1":-1,"eye_squint":0,"moles_2":1,"chest_1":-1,"chin_2":0,"eyebrows_4":12,"bags_1":0,"complexion_1":0,"neck_thickness":0,"jaw_2":0,"lip_thickness":0,"face_1":0,"nose_3":0,"lipstick_3":0,"makeup_4":0,"eyebrows_5":0,"skin":12,"sun_2":10,"shoes_1":25,"pants_2":1,"makeup_1":0,"glasses_2":0,"nose_1":0,"beard_4":0,"hair_1":10,"bracelets_1":-1,"bracelets_2":0,"eyebrows_2":10,"bulletproof_vest_2":0,"bproof_2":0,"lipstick_1":0,"tshirt_1":207,"jaw_1":0,"bproof_1":76,"mask_1":168,"face":0,"eyebrows_1":0,"sun_1":-1,"torso_2":0,"face_3":5,"pants_1":130,"moles_1":0,"beard_1":0,"blush_3":0,"mom":25,"nose_6":0,"blush_1":-1,"chest_2":10,"sex":0,"watches_2":0,"beard_2":10,"bodyb_1":-1,"cheeks_2":0,"nose_4":0,"tshirt_2":1,"decals_2":0,"nose_2":0,"bodyb_3":-1,"face_md_weight":50,"age_1":0,"complexion_2":1,"helmet_2":0,"lipstick_4":0,"ears_1":-1,"eyebrows_6":0,"beard_3":0,"chain_2":2,"chin_1":0,"bulletproof_1":79,"chain_1":0,"bulletproof_vest_1":79,"arms_2":0,"blemishes_1":-1,"face_2":21,"hair_2":0,"eye_color":0,"blemishes_2":10,"skin_md_weight":2,"bodyb_4":0,"arms":19,"age_2":0,"ears_2":-1,"makeup_2":0,"bags_2":0,"helmet_1":142,"cheeks_3":0,"chin_4":0,"makeup_3":0,"chest_3":0,"blush_2":10,"eyebrows_3":12,"bodyb_2":0,"shoes_2":0}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":false},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":false},{"model":"polkch","status":false},{"model":"poljug","status":true},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":false},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"water","status":true},{"name":"grip","status":true},{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"bread","status":false},{"name":"blackmoney","status":false}]'),
	('mt', 4, 'com', 'Specialist', 6000, '{"sun_1":-1,"chain_1":0,"age_1":0,"lipstick_2":0,"pants_2":0,"eye_color":0,"eye_squint":0,"mask_2":5,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":623,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":110,"helmet_2":-1,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":4,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":245,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":208,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":0,"arms":22,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":200,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":0,"bproof_1":66,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":false},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":false},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"water","status":true},{"name":"grip","status":true},{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"bread","status":true},{"name":"blackmoney","status":true}]'),
	('mt', 5, 'com', 'Corporal', 7000, '{"sun_1":-1,"chain_1":0,"age_1":0,"lipstick_2":0,"pants_2":0,"eye_color":0,"eye_squint":0,"mask_2":0,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":171,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":70,"helmet_2":-1,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":-1,"torso_2":0,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":169,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":15,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":0,"arms":30,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":-1,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":195,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":0,"bproof_1":47,"sun_2":10,"chin_2":0,"shoes_2":1,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":false,"model":"polreb"},{"status":true,"model":"polneon"},{"status":false,"model":"polros"},{"status":false,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":false,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":false,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":false,"name":"eclip"},{"status":true,"name":"grip"},{"status":false,"name":"lsd"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":true,"name":"xpshop"}]'),
	('mt', 6, 'com', 'Senior Corporal', 8000, '{"sun_1":-1,"chain_1":112,"age_1":0,"lipstick_2":0,"pants_2":1,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":50,"helmet_2":0,"bodyb_2":0,"watches_2":0,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":1,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":168,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":20,"tshirt_1":208,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":1,"arms":30,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":3,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":2,"bproof_1":121,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":false},{"model":"polkch","status":false},{"model":"poljug","status":true},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":false,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":false,"name":"eclip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('mt', 7, 'com', 'Sergeant', 9000, '{"sun_1":-1,"chain_1":112,"age_1":0,"lipstick_2":0,"pants_2":1,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":83,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":25,"helmet_2":0,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":5,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":167,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":208,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":1,"arms":19,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":2,"bproof_1":122,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":false,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":false,"model":"poljug"},{"status":false,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":false,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":true,"name":"eclip"}]'),
	('mt', 8, 'com', 'Senior Sergeant', 10000, '{"sun_1":-1,"chain_1":0,"age_1":0,"lipstick_2":0,"pants_2":1,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":570,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":25,"helmet_2":0,"bodyb_2":0,"watches_2":0,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":0,"torso_2":3,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":168,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":1,"tshirt_1":208,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":1,"arms":27,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":15,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":3,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":0,"bproof_1":120,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":false},{"model":"pdbuff","status":false},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":false,"model":"WEAPON_NIGHTSTICK"},{"status":false,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":true,"name":"eclip"}]'),
	('mt', 9, 'com', 'Master Sergeant', 11000, '{"sun_1":-1,"chain_1":0,"age_1":0,"lipstick_2":0,"pants_2":4,"eye_color":0,"eye_squint":0,"mask_2":15,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":264,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":25,"helmet_2":0,"bodyb_2":0,"watches_2":1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":19,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":168,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":6,"tshirt_1":207,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":0,"arms":19,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":0,"bproof_1":78,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"eclip"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('mt', 10, 'boss', 'Second Lieutenant', 12000, '{"sun_1":-1,"chain_1":215,"age_1":0,"lipstick_2":0,"pants_2":4,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":25,"helmet_2":0,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":25,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":168,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":232,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":1,"arms":30,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":3,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":1,"bproof_1":117,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true}]'),
	('mt', 11, 'boss', 'First Lieutenant', 13000, '{"eyebrows_1":0,"makeup_1":0,"age_2":0,"glasses_2":0,"mom":21,"sex":0,"decals_2":0,"makeup_2":0,"eyebrows_3":12,"nose_6":0,"jaw_2":0,"age_1":0,"arms":19,"hair_color_2":0,"face_md_weight":50.0,"eye_squint":0,"lipstick_4":0,"lipstick_2":0,"bulletproof_1":79,"blush_2":10,"bodyb_2":0,"bodyb_1":-1,"ears_2":-1,"bags_1":0,"lipstick_1":0,"helmet_2":0,"sun_1":-1,"bulletproof_2":0,"eyebrows_5":0,"bracelets_1":-1,"makeup_4":0,"dad":0,"nose_2":-4.9,"cheeks_2":0,"face":0,"tshirt_1":15,"lip_thickness":0,"arms_2":0,"skin":12,"bracelets_2":0,"beard_1":0,"tshirt_2":0,"shoes_1":24,"nose_1":-1.1,"hair_1":10,"jaw_1":0,"pants_1":59,"bodyb_4":0,"chain_1":226,"chin_4":0,"cheeks_3":0,"sun_2":10,"eyebrows_4":12,"pants_2":8,"complexion_1":0,"chin_1":0,"torso_2":19,"makeup_3":0,"lipstick_3":0,"blemishes_1":-1,"hair_2":0,"cheeks_1":0,"chest_3":0,"mask_1":0,"hair_color_1":0,"bulletproof_vest_2":0,"face_3":5,"face_1":0,"eye_color":0,"bags_2":0,"nose_4":0,"chin_3":0,"complexion_2":1,"bodyb_3":-1,"decals_1":0,"face_2":21,"watches_2":0,"chest_2":10,"watches_1":13,"blemishes_2":10,"eyebrows_6":0,"torso_1":574,"neck_thickness":0,"bulletproof_vest_1":79,"helmet_1":-1,"glasses_1":5,"chain_2":0,"blush_1":-1,"nose_3":4.9,"bproof_1":127,"blush_3":0,"nose_5":0,"moles_1":0,"shoes_2":0,"bproof_2":0,"ears_1":-1,"chest_1":-1,"eyebrows_2":10,"chin_2":0,"mask_2":0,"skin_md_weight":6,"beard_3":0,"beard_4":0,"moles_2":1,"beard_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"lsd","status":false},{"name":"radio","status":true},{"name":"scope","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"xpbank","status":false},{"name":"xpshop","status":false}]'),
	('mt', 12, 'boss', 'Captain', 14000, '{"sun_1":-1,"chain_1":1,"age_1":0,"lipstick_2":0,"pants_2":7,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":-1,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":35,"helmet_2":-1,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":6,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":164,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":207,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":1,"arms":30,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":0,"bproof_1":119,"sun_2":10,"chin_2":0,"shoes_2":1,"tshirt_2":1,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{"sun_2":10,"nose_6":0,"eye_squint":0,"eyebrows_2":10,"decals_2":0,"watches_2":-1,"blush_2":10,"bags_1":0,"complexion_2":1,"eyebrows_6":0,"mask_2":2,"chain_1":0,"hair_2":0,"lipstick_2":10,"chest_2":10,"blemishes_2":10,"helmet_1":-1,"face_1":0,"chain_2":0,"age_1":0,"mask_1":0,"lipstick_1":3,"ears_1":-1,"lip_thickness":0,"face":0,"glasses_1":-1,"pants_2":12,"bracelets_2":0,"makeup_2":10,"moles_2":1,"bulletproof_1":79,"eyebrows_1":1,"torso_1":16,"cheeks_2":0,"lipstick_3":20,"eye_color":0,"nose_2":0,"tshirt_1":15,"cheeks_1":0,"torso_2":0,"ears_2":-1,"bproof_2":0,"bodyb_3":-1,"pants_1":9,"beard_3":0,"bracelets_1":-1,"sex":1,"watches_1":-1,"bodyb_2":0,"sun_1":-1,"skin_md_weight":6,"chin_3":0,"bags_2":0,"eyebrows_5":0,"face_2":21,"skin":12,"helmet_2":-1,"moles_1":0,"hair_1":30,"beard_1":0,"beard_2":0,"face_md_weight":50,"bulletproof_vest_1":79,"bproof_1":0,"lipstick_4":0,"age_2":0,"chest_3":0,"decals_1":0,"hair_color_1":0,"chin_4":0,"bulletproof_2":0,"dad":0,"neck_thickness":0,"hair_color_2":0,"chin_2":0,"makeup_1":5,"blush_1":-1,"nose_4":0,"tshirt_2":0,"nose_5":0,"makeup_3":0,"shoes_1":35,"arms_2":0,"nose_1":0,"eyebrows_4":12,"chest_1":-1,"complexion_1":0,"makeup_4":0,"nose_3":0,"arms":15,"face_3":6,"bulletproof_vest_2":0,"bodyb_1":-1,"shoes_2":0,"jaw_1":0,"blemishes_1":-1,"glasses_2":-1,"jaw_2":0,"blush_3":0,"mom":21,"eyebrows_3":26,"beard_4":0,"bodyb_4":0,"cheeks_3":0,"chin_1":0}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":true},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"eclip"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":false,"name":"xpbank"},{"status":true,"name":"xpshop"}]'),
	('mt', 13, 'boss', 'Major', 15000, '{"moles_1":0,"chin_2":0,"face_2":21,"jaw_1":0,"dad":0,"arms_2":0,"bags_2":0,"lip_thickness":0,"glasses_2":2,"bulletproof_2":0,"bodyb_3":-1,"blush_2":10,"makeup_2":0,"watches_2":-1,"torso_1":574,"decals_1":0,"lipstick_3":0,"shoes_2":0,"skin_md_weight":15,"makeup_1":0,"lipstick_1":0,"lipstick_4":0,"nose_6":0,"nose_1":4,"complexion_1":0,"sun_1":-1,"bodyb_2":0,"moles_2":1,"complexion_2":1,"eyebrows_5":0,"makeup_4":0,"ears_2":-1,"eyebrows_3":12,"cheeks_3":0,"helmet_1":-1,"eyebrows_2":10,"beard_4":0,"beard_1":0,"skin":12,"eye_color":0,"mom":22,"chain_2":0,"age_2":0,"sex":0,"bracelets_1":-1,"beard_2":10,"face_3":5,"cheeks_2":0,"helmet_2":-1,"beard_3":0,"chest_3":0,"hair_color_2":0,"chest_2":10,"cheeks_1":0,"nose_2":0,"chin_3":0,"chest_1":-1,"face":0,"sun_2":10,"hair_2":0,"bodyb_4":0,"bproof_1":64,"nose_5":0,"eyebrows_6":0,"blush_3":0,"torso_2":25,"bags_1":0,"shoes_1":25,"bracelets_2":0,"mask_1":170,"pants_2":4,"watches_1":-1,"ears_1":-1,"bulletproof_1":79,"hair_1":10,"face_md_weight":53,"makeup_3":0,"hair_color_1":0,"chain_1":0,"jaw_2":0,"nose_4":0,"nose_3":0,"eyebrows_1":0,"chin_1":0,"blush_1":-1,"bulletproof_vest_1":79,"pants_1":130,"decals_2":0,"eyebrows_4":12,"age_1":0,"face_1":0,"bulletproof_vest_2":0,"chin_4":0,"neck_thickness":0,"mask_2":9,"bproof_2":1,"glasses_1":5,"tshirt_1":207,"tshirt_2":1,"blemishes_2":10,"arms":19,"blemishes_1":-1,"bodyb_1":-1,"eye_squint":0,"lipstick_2":0}', '{}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":false,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"eclip"},{"status":true,"name":"grip"},{"status":false,"name":"lsd"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":false,"name":"water"},{"status":false,"name":"xpbank"},{"status":false,"name":"xpshop"}]'),
	('mt', 14, 'boss', 'Colonel', 16000, '{"eyebrows_1":0,"bulletproof_vest_1":79,"bracelets_1":-1,"face_1":0,"jaw_1":4.3,"eye_color":0,"helmet_2":-1,"watches_1":4,"hair_2":0,"bags_1":0,"bodyb_2":0,"decals_1":0,"complexion_1":0,"cheeks_3":0,"age_1":0,"bulletproof_2":0,"chin_2":1.2,"bodyb_4":0,"dad":0,"tshirt_2":0,"face":0,"face_2":21,"makeup_1":0,"beard_4":0,"cheeks_2":0,"bodyb_1":-1,"chest_1":-1,"blemishes_1":-1,"tshirt_1":207,"makeup_4":0,"lip_thickness":9.9,"torso_1":574,"beard_2":10,"hair_color_2":0,"bracelets_2":0,"decals_2":0,"bproof_2":0,"shoes_2":0,"eye_squint":0,"hair_color_1":0,"nose_5":-7.4,"skin":12,"chin_1":1.5,"eyebrows_5":0,"blemishes_2":10,"bags_2":0,"neck_thickness":-10,"arms_2":0,"nose_4":1.4,"lipstick_2":0,"lipstick_4":0,"glasses_1":15,"nose_1":-2.1,"nose_2":-0.6,"sun_1":-1,"age_2":0,"face_md_weight":25.0,"chest_2":10,"ears_2":-1,"bulletproof_vest_2":0,"mask_2":13,"blush_1":-1,"eyebrows_2":10,"chin_3":0.6,"chain_2":0,"complexion_2":1,"lipstick_1":0,"mom":21,"cheeks_1":-3.8,"shoes_1":25,"nose_3":-2.5,"nose_6":2.1,"beard_3":0,"blush_3":0,"mask_1":169,"eyebrows_6":0,"makeup_2":0,"lipstick_3":0,"pants_2":4,"jaw_2":4.4,"ears_1":-1,"glasses_2":7,"torso_2":19,"eyebrows_4":12,"bodyb_3":-1,"face_3":5,"chest_3":0,"moles_2":1,"sun_2":10,"sex":0,"makeup_3":0,"skin_md_weight":4,"bulletproof_1":79,"watches_2":0,"moles_1":0,"beard_1":0,"helmet_1":-1,"bproof_1":0,"pants_1":130,"chain_1":238,"arms":19,"blush_2":10,"hair_1":10,"eyebrows_3":12,"chin_4":4.5}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":false},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"lsd","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"xpbank","status":true},{"name":"xpshop","status":true},{"name":"scope","status":true}]'),
	('mt', 15, 'boss', 'Commander', 17000, '{"bulletproof_1":79,"skin_md_weight":2,"eye_squint":0,"nose_6":0,"chest_2":10,"chain_2":0,"age_1":0,"complexion_2":1,"bracelets_1":-1,"beard_2":10,"shoes_1":25,"jaw_1":0,"decals_1":0,"neck_thickness":0,"face_1":0,"lipstick_3":0,"nose_3":0,"blush_1":-1,"bracelets_2":0,"chain_1":15,"arms":19,"mask_1":167,"bulletproof_vest_1":79,"lipstick_1":0,"bodyb_2":0,"cheeks_2":0,"bags_2":0,"nose_2":0,"lipstick_4":0,"torso_2":1,"chin_3":0,"makeup_4":0,"watches_2":-1,"lip_thickness":0,"eyebrows_6":0,"shoes_2":0,"chest_3":0,"bulletproof_2":0,"chin_1":0,"mask_2":9,"makeup_3":0,"bproof_2":0,"mom":25,"face_md_weight":50,"nose_1":0,"blemishes_2":10,"nose_5":0,"ears_2":-1,"tshirt_1":15,"bproof_1":0,"helmet_1":-1,"eye_color":0,"cheeks_3":0,"face_3":5,"chest_1":-1,"eyebrows_1":0,"beard_1":0,"lipstick_2":0,"bodyb_1":-1,"sun_2":10,"face":0,"beard_3":0,"blush_2":10,"blemishes_1":-1,"makeup_2":0,"pants_2":1,"hair_color_2":0,"ears_1":-1,"hair_color_1":0,"chin_2":0,"pants_1":130,"blush_3":0,"beard_4":0,"chin_4":0,"sex":0,"watches_1":-1,"bags_1":0,"sun_1":-1,"decals_2":0,"hair_1":10,"makeup_1":0,"arms_2":0,"tshirt_2":0,"cheeks_1":0,"glasses_1":5,"complexion_1":0,"eyebrows_5":0,"hair_2":0,"jaw_2":0,"eyebrows_4":12,"skin":12,"torso_1":571,"face_2":21,"eyebrows_2":10,"bodyb_4":0,"helmet_2":0,"bulletproof_vest_2":0,"eyebrows_3":12,"bodyb_3":-1,"dad":0,"age_2":0,"moles_1":0,"nose_4":0,"moles_2":1,"glasses_2":1}', '{}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":false},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":true},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"vvpi","status":false},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":true}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"xpshop","status":true}]'),
	('mt', 16, 'boss', 'Deputy Chief', 18000, '{"neck_thickness":0,"makeup_2":0,"lipstick_4":0,"chin_4":0,"bags_2":0,"nose_2":-4.9,"jaw_1":0,"chest_1":-1,"cheeks_3":0,"shoes_2":0,"mom":21,"chin_1":0,"beard_4":0,"blush_1":-1,"nose_1":-1.1,"bproof_2":0,"bags_1":0,"watches_2":-1,"age_1":0,"eyebrows_3":12,"pants_1":130,"tshirt_2":0,"moles_2":1,"complexion_2":1,"nose_3":4.9,"chain_2":0,"lipstick_2":0,"sun_2":10,"decals_2":0,"torso_1":568,"face_1":0,"eyebrows_2":10,"chest_3":0,"bodyb_4":0,"face_md_weight":50.0,"chain_1":226,"shoes_1":35,"beard_2":10,"hair_color_2":0,"helmet_1":119,"mask_2":13,"lip_thickness":0,"cheeks_1":0,"moles_1":0,"nose_6":0,"hair_2":0,"eye_squint":0,"bulletproof_1":79,"glasses_2":1,"hair_1":10,"decals_1":0,"lipstick_1":0,"jaw_2":0,"beard_3":0,"arms":19,"arms_2":0,"beard_1":0,"blush_2":10,"bodyb_2":0,"pants_2":4,"cheeks_2":0,"chin_3":0,"bulletproof_vest_1":79,"blemishes_1":-1,"makeup_4":0,"sun_1":-1,"chest_2":10,"eyebrows_5":0,"bracelets_1":-1,"glasses_1":5,"eye_color":0,"blemishes_2":10,"chin_2":0,"skin":12,"nose_4":0,"torso_2":3,"watches_1":-1,"complexion_1":0,"eyebrows_4":12,"bulletproof_vest_2":0,"eyebrows_1":0,"ears_1":-1,"face_2":21,"tshirt_1":207,"bracelets_2":0,"dad":0,"age_2":0,"bulletproof_2":0,"face":0,"makeup_1":0,"face_3":5,"mask_1":169,"blush_3":0,"helmet_2":0,"nose_5":0,"bproof_1":127,"lipstick_3":0,"eyebrows_6":0,"sex":0,"makeup_3":0,"ears_2":-1,"bodyb_1":-1,"bodyb_3":-1,"skin_md_weight":6,"hair_color_1":0}', '{}', '[{"model":"b2chal","status":true},{"model":"b211vic","status":false},{"model":"b212caprice","status":false},{"model":"b214charger","status":false},{"model":"b216explorer","status":false},{"model":"b218charger","status":false},{"model":"b218tau","status":false},{"model":"b219tahoe","status":true},{"model":"fibm5","status":false},{"model":"polnspeedo","status":true},{"model":"polkch","status":true},{"model":"swat_dirtbike","status":true}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"eclip"},{"status":true,"name":"grip"},{"status":false,"name":"lsd"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"water"},{"status":false,"name":"xpbank"},{"status":false,"name":"xpshop"}]'),
	('mt', 17, 'boss', 'Assistant Chief', 19000, '{"sun_1":-1,"chain_1":111,"age_1":0,"lipstick_2":0,"pants_2":1,"eye_color":0,"eye_squint":0,"mask_2":13,"eyebrows_3":12,"ears_2":0,"moles_1":0,"nose_1":0,"jaw_2":0,"beard_2":10,"hair_1":10,"sex":0,"helmet_1":-1,"chest_1":-1,"torso_1":574,"lip_thickness":0,"ears_1":-1,"eyebrows_5":0,"bulletproof_1":79,"lipstick_3":0,"face_3":5,"chest_3":0,"age_2":0,"bracelets_2":0,"skin":12,"bulletproof_vest_2":0,"face_md_weight":50,"nose_2":0,"nose_6":0,"shoes_1":25,"helmet_2":2,"bodyb_2":0,"watches_2":-1,"bulletproof_vest_1":79,"eyebrows_6":0,"glasses_2":1,"torso_2":11,"complexion_1":0,"moles_2":1,"makeup_3":0,"mask_1":168,"arms_2":0,"nose_4":0,"hair_color_2":0,"watches_1":-1,"tshirt_1":212,"chin_4":0,"cheeks_3":0,"neck_thickness":0,"dad":0,"jaw_1":0,"bproof_2":0,"arms":19,"decals_1":0,"chin_1":0,"makeup_1":0,"bulletproof_2":0,"bodyb_3":-1,"face_2":21,"beard_3":0,"mom":25,"bags_1":0,"bodyb_4":0,"glasses_1":5,"skin_md_weight":2,"face":0,"nose_3":0,"makeup_4":0,"beard_4":0,"eyebrows_4":12,"chest_2":10,"pants_1":130,"hair_color_1":0,"bodyb_1":-1,"bracelets_1":-1,"lipstick_1":0,"blemishes_1":-1,"lipstick_4":0,"eyebrows_1":0,"eyebrows_2":10,"chain_2":2,"bproof_1":127,"sun_2":10,"chin_2":0,"shoes_2":0,"tshirt_2":0,"face_1":0,"cheeks_1":0,"chin_3":0,"complexion_2":1,"nose_5":0,"hair_2":0,"blush_2":10,"cheeks_2":0,"decals_2":0,"blush_3":0,"beard_1":0,"bags_2":0,"makeup_2":0,"blush_1":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"water"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"},{"status":true,"name":"clip"},{"status":true,"name":"bread"}]'),
	('mt', 18, 'boss', 'Chief', 20000, '{"blemishes_1":-1,"bags_1":0,"decals_1":0,"bulletproof_vest_2":0,"lipstick_2":10,"helmet_1":175,"jaw_2":0,"bags_2":0,"eye_squint":0,"eyebrows_6":0,"makeup_3":0,"bulletproof_2":0,"nose_6":0,"beard_1":11,"age_2":10,"bproof_2":1,"bulletproof_vest_1":79,"face_3":5,"blemishes_2":10,"moles_1":-1,"face_1":0,"torso_2":2,"beard_2":10,"face_2":21,"tshirt_1":208,"chin_4":0,"lip_thickness":0,"nose_1":0,"decals_2":0,"eyebrows_2":10,"lipstick_1":-1,"bulletproof_1":79,"mom":25,"pants_2":1,"jaw_1":0,"sun_1":-1,"dad":0,"chin_1":0,"makeup_2":10,"eye_color":0,"bodyb_1":-1,"mask_1":168,"bodyb_2":0,"lipstick_3":0,"arms":19,"eyebrows_5":0,"glasses_2":1,"chain_2":2,"face_md_weight":50,"watches_2":-1,"hair_2":0,"age_1":-1,"torso_1":568,"arms_2":0,"hair_color_2":0,"neck_thickness":0,"chin_3":0,"nose_4":0,"pants_1":130,"cheeks_3":0,"nose_5":0,"hair_1":10,"lipstick_4":0,"hair_color_1":0,"chest_2":10,"face":0,"shoes_2":0,"makeup_4":0,"moles_2":10,"eyebrows_4":0,"cheeks_1":0,"shoes_1":25,"cheeks_2":0,"mask_2":15,"chin_2":0,"ears_1":-1,"bracelets_2":0,"watches_1":-1,"tshirt_2":0,"chain_1":112,"bodyb_3":-1,"bodyb_4":0,"complexion_1":-1,"blush_2":10,"makeup_1":-1,"chest_1":-1,"nose_2":0,"glasses_1":5,"skin_md_weight":2,"helmet_2":0,"blush_1":-1,"beard_3":29,"skin":12,"ears_2":-1,"bracelets_1":-1,"sun_2":10,"eyebrows_1":0,"sex":0,"blush_3":0,"eyebrows_3":0,"complexion_2":10,"chest_3":0,"nose_3":0,"bproof_1":64,"beard_4":29}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":true},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"lsd","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"xpbank","status":true},{"name":"xpshop","status":true},{"name":"scope","status":true}]'),
	('mt', 19, 'boss', 'Commissioner', 20000, '{"bodyb_4":0,"bracelets_2":0,"chain_1":226,"makeup_2":0,"moles_1":0,"moles_2":1,"blemishes_1":1,"tshirt_2":0,"lipstick_1":0,"sun_2":10,"arms_2":0,"eye_color":0,"helmet_1":58,"eyebrows_6":0,"jaw_1":0,"chin_4":0,"beard_3":0,"neck_thickness":0,"chain_2":0,"lipstick_3":0,"hair_1":10,"chest_2":10,"shoes_1":25,"chin_3":0,"face_1":0,"beard_4":0,"nose_4":0,"blemishes_2":10,"cheeks_2":0,"jaw_2":0,"blush_1":0,"blush_3":0,"watches_1":-1,"nose_1":0,"hair_color_2":0,"tshirt_1":212,"mask_2":13,"nose_3":0,"eyebrows_4":12,"skin":12,"sex":0,"bproof_2":1,"makeup_1":0,"chin_2":0,"bodyb_1":-1,"bulletproof_vest_1":79,"cheeks_1":0,"bulletproof_1":79,"lipstick_2":0,"dad":0,"bags_1":0,"face_2":21,"sun_1":-1,"nose_2":0,"face_md_weight":51,"chin_1":0,"pants_1":130,"nose_5":0,"nose_6":0,"complexion_2":1,"ears_2":-1,"mask_1":169,"makeup_3":0,"glasses_2":0,"bulletproof_2":0,"cheeks_3":0,"makeup_4":0,"bproof_1":64,"watches_2":-1,"skin_md_weight":6,"age_2":0,"ears_1":-1,"mom":21,"bodyb_2":0,"bulletproof_vest_2":0,"shoes_2":0,"decals_2":0,"chest_3":0,"bodyb_3":-1,"lipstick_4":0,"chest_1":-1,"eyebrows_2":10,"pants_2":1,"eyebrows_3":12,"arms":19,"bags_2":0,"age_1":0,"lip_thickness":0,"glasses_1":5,"blush_2":0,"face":0,"beard_1":0,"hair_2":0,"eyebrows_5":0,"beard_2":10,"bracelets_1":-1,"helmet_2":2,"torso_2":15,"eyebrows_1":0,"face_3":5,"decals_1":0,"eye_squint":0,"hair_color_1":0,"torso_1":574,"complexion_1":0}', '{}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":true}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"eclip","status":true},{"name":"grip","status":true},{"name":"lsd","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"xpbank","status":true},{"name":"xpshop","status":true},{"name":"scope","status":true}]'),
	('nightclub', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('nightjar', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nightjar', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('nojob', 0, 'Bikar', 'nojob', 500, '', '', '', NULL, '', ''),
	('obsidian', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('obsidian', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('offambulance', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offambulance', 1, 'intern', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 2, 'intern', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 3, 'nurse', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 4, 'doctor', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 5, 'sergon', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 6, 'sparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 7, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 8, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 9, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 10, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 11, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 12, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 13, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 14, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 15, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 16, 'boss', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 17, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offambulance', 18, 'lparamedic', 'Ambulance', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offanchor', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offanchor', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offanchor', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offanchor', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offanchor', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offblacktide', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offblacktide', 1, 'rank1', 'Runner', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offblacktide', 2, 'rank2', 'Enforcer', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offblacktide', 3, 'boss', 'Boss', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcarwash', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcarwash', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcarwash', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcarwash', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcarwash', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcatcafe', 0, 'off_grade_0', 'Off-Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offcatcafe', 1, 'boss', 'Off-Duty', 0, '{}', '{}', '', NULL, '', ''),
	('offcia', 0, 'off_grade_0', 'Off-Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offcia', 1, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 2, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 3, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 4, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 5, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 6, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 7, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 8, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 9, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 10, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 11, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 12, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 13, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 14, 'com', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 15, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 16, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 17, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 18, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 19, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 20, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcia', 21, 'boss', 'CIA', 0, '{}', '{}', '[]', NULL, '', ''),
	('offcid', 0, 'unemployed', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offcratecarry', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcratecarry', 1, 'rank1', 'Driver', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcratecarry', 2, 'rank2', 'Manager', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcratecarry', 3, 'boss', 'Owner', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcrimson', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcrimson', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcrimson', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcrimson', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offcrimson', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offdoa', 0, 'unemployed', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offember', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offember', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offember', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offember', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offember', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfbi', 0, 'agent', 'Agent', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offfbi', 1, 'special', 'Experienced Agent', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offfbi', 2, 'supervisor', 'Supervisor', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offfbi', 3, 'assistant', 'Assistant Director', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offfbi', 4, 'boss', 'Director', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offfirebrick', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfirebrick', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfirebrick', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfirebrick', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfirebrick', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offflourish', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offflourish', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offflourish', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offflourish', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offflourish', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfrostbite', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfrostbite', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfrostbite', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfrostbite', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offfrostbite', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offgoldcrust', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offgoldcrust', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offgoldcrust', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offgoldcrust', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offgoldcrust', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offjudge', 0, 'unemployed', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offkoi', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offkoi', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offkoi', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offkoi', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offkoi', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offmarshal', 0, 'unemployed', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmechanic', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmechanic', 1, 'recrue', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 2, 'novice', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 3, 'novice', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 4, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 5, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 6, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 7, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 8, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 9, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 10, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 11, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 12, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 13, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 14, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 15, 'rimente', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 16, 'boss', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 17, 'boss', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmechanic', 18, 'boss', 'Mechanic', 0, '{}', '{}', '', NULL, '', ''),
	('offmeridian', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offmeridian', 1, 'rank1', 'Analyst', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offmeridian', 2, 'rank2', 'Director', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offmeridian', 3, 'boss', 'CEO', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offmt', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 1, 'off_grade_1', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 2, 'off_grade_2', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 3, 'off_grade_3', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 4, 'off_grade_4', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 5, 'off_grade_5', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 6, 'off_grade_6', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 7, 'off_grade_7', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 8, 'off_grade_8', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 9, 'off_grade_9', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 10, 'off_grade_10', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 11, 'off_grade_11', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 12, 'off_grade_12', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 13, 'off_grade_13', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 14, 'off_grade_14', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 15, 'off_grade_15', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 16, 'off_grade_16', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 17, 'off_grade_17', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 18, 'off_grade_18', 'Off Duty', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offmt', 19, 'off_grade_19', 'Off Dut', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offnightjar', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offnightjar', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offnightjar', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offnightjar', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offnightjar', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offobsidian', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offobsidian', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offobsidian', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offobsidian', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offobsidian', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offpolice', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offpolice', 1, 'cadet', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 2, 'cadet', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 3, 'po1', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 4, 'po1', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 5, 'po2', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 6, 'po2', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 7, 'po3', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 8, 'po3', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 9, 'senior', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 10, 'sergent', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 11, 'com', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 12, 'com', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 13, 'sergent', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 14, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 15, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 16, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 17, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 18, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 19, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 20, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offpolice', 21, 'boss', 'Police', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offsheriff', 1, 'cadet', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 2, 'cadet', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 3, 'cadet', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 4, 'po1', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 5, 'po1', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 6, 'po2', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 7, 'po2', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 8, 'po3', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 9, 'po3', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 10, 'senior', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 11, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 12, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 13, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 14, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 15, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 16, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 17, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 18, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 19, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 20, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 21, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offsheriff', 22, 'boss', 'Sheriff', 0, '{}', '{}', '', NULL, '', ''),
	('offslice', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offslice', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offslice', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offslice', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offslice', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offstatic', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offstatic', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offstatic', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offstatic', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offstatic', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offsundae', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offsundae', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offsundae', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offsundae', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offsundae', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offtaxi', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offtaxi', 1, 'recrue', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 2, 'recrue', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 3, 'experimente', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 4, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 5, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 6, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 7, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 8, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 9, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 10, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 11, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 12, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 13, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 14, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 15, 'uber', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 16, 'boss', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 17, 'boss', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offtaxi', 18, 'boss', 'Taxi', 0, '{}', '{}', '[]', NULL, '', '[]'),
	('offturfco', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offturfco', 1, 'rank1', 'Referee', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offturfco', 2, 'rank2', 'Manager', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offturfco', 3, 'boss', 'Owner', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offuwucafe', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offuwucafe', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offuwucafe', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offuwucafe', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offuwucafe', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offvoltage', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offvoltage', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offvoltage', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offvoltage', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offvoltage', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offwasabi', 0, 'off_grade_0', 'Off Duty', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offwasabi', 1, 'rank1', 'Rank1', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offwasabi', 2, 'rank2', 'Rank2', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offwasabi', 3, 'rank3', 'Rank3', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offwasabi', 4, 'boss', 'Rank4', 0, '{}', '{}', '[]', '[]', NULL, NULL),
	('offweazel', 0, 'off_grade_0', 'Off Duty 0', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offweazel', 1, 'boss', 'Off-Duty', 0, '{}', '{}', '', NULL, '', ''),
	('offweazel', 2, 'off_grade_2', 'Off Duty 2', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('offweazel', 3, 'off_grade_3', 'Off Duty 3', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('police', 0, 'cadet', 'Cadet', 7800, '{}', '{}', NULL, NULL, NULL, NULL),
	('police', 1, 'cadet', 'Officer', 4000, '{"mask_1":0,"hair_color_1":0,"age_1":0,"lip_thickness":5.4,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":1,"blush_1":-1,"nose_5":-2.2,"eyebrows_1":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":55.00000000000001,"chin_3":-3.9,"beard_4":0,"bags_2":0,"blemishes_1":-1,"hair_1":10,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":2.3,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"bodyb_3":-1,"arms":30,"shoes_1":25,"age_2":0,"chin_4":-0.4,"bags_1":0,"beard_3":0,"lipstick_4":0,"lipstick_3":0,"pants_2":1,"chest_3":0,"eyebrows_2":10,"sun_1":5,"torso_2":2,"chain_1":0,"tshirt_1":232,"sun_2":10,"chin_2":0.3,"bracelets_1":-1,"makeup_4":0,"decals_1":0,"bodyb_1":-1,"eyebrows_6":0.2,"bproof_1":91,"eyebrows_4":12,"glasses_1":5,"makeup_2":0,"lipstick_2":0,"bproof_2":0,"blemishes_2":10,"decals_2":0,"mask_2":0,"moles_1":0,"face_1":0,"dad":0,"bodyb_4":0,"helmet_1":-1,"cheeks_3":3.59999999999999,"face_3":5,"pants_1":130,"mom":21,"makeup_1":0,"complexion_2":1,"arms_2":0,"eyebrows_5":0.1,"bodyb_2":0,"bracelets_2":0,"nose_2":4.69999999999999,"helmet_2":0,"nose_3":3.2,"nose_6":0,"torso_1":576,"cheeks_2":-0.89999999999999,"chest_2":10,"makeup_3":0,"nose_1":0.7,"chain_2":0,"nose_4":7.0,"neck_thickness":6.2,"chin_1":-1.6,"cheeks_1":3.0,"skin_md_weight":8,"eye_color":0,"jaw_1":2.3}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":false,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":false,"model":"poljug"},{"status":false,"model":"polkch"},{"status":false,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":false,"model":"polros"},{"status":false,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":false,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":false,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":false,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":false},{"name":"clip","status":true},{"name":"grip","status":false}]'),
	('police', 2, 'cadet', 'Senior Officer', 5000, '{"mask_1":0,"hair_color_1":0,"age_1":0,"lip_thickness":5.4,"ears_1":-1,"face_2":21,"moles_2":1,"glasses_2":-1,"blush_1":-1,"nose_5":-2.2,"eyebrows_1":0,"sex":0,"tshirt_2":0,"beard_1":0,"face_md_weight":55.00000000000001,"chin_3":-3.9,"beard_4":0,"bags_2":0,"blemishes_1":-1,"hair_1":10,"eye_squint":0,"beard_2":10,"hair_2":0,"blush_2":10,"eyebrows_3":12,"lipstick_1":0,"shoes_2":0,"jaw_2":2.3,"complexion_1":0,"watches_2":-1,"blush_3":0,"skin":12,"hair_color_2":0,"watches_1":-1,"ears_2":-1,"chest_1":-1,"bodyb_3":-1,"arms":30,"shoes_1":25,"age_2":0,"chin_4":-0.4,"bags_1":0,"beard_3":0,"lipstick_4":0,"lipstick_3":0,"pants_2":1,"chest_3":0,"eyebrows_2":10,"sun_1":5,"torso_2":1,"chain_1":0,"tshirt_1":211,"sun_2":10,"chin_2":0.3,"bracelets_1":-1,"makeup_4":0,"decals_1":0,"bodyb_1":-1,"eyebrows_6":0.2,"bproof_1":82,"eyebrows_4":12,"glasses_1":-1,"makeup_2":0,"lipstick_2":0,"bproof_2":0,"blemishes_2":10,"decals_2":0,"mask_2":2,"moles_1":0,"face_1":0,"dad":0,"bodyb_4":0,"helmet_1":-1,"cheeks_3":3.59999999999999,"face_3":5,"pants_1":130,"mom":21,"makeup_1":0,"complexion_2":1,"arms_2":0,"eyebrows_5":0.1,"bodyb_2":0,"bracelets_2":0,"nose_2":4.69999999999999,"helmet_2":-1,"nose_3":3.2,"nose_6":0,"torso_1":569,"cheeks_2":-0.89999999999999,"chest_2":10,"makeup_3":0,"nose_1":0.7,"chain_2":0,"nose_4":7.0,"neck_thickness":6.2,"chin_1":-1.6,"cheeks_1":3.0,"skin_md_weight":8,"eye_color":0,"jaw_1":2.3}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":false,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":false,"model":"poljug"},{"status":false,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":false,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":false,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":false,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"}]'),
	('police', 3, 'po1', 'Master Officer', 5500, '{"bproof_1":77,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"makeup_1":0,"blush_2":10,"glasses_2":-1,"cheeks_3":0,"face_3":5,"mask_2":0,"eyebrows_1":0,"arms":52,"lip_thickness":0,"torso_2":0,"cheeks_2":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"eye_squint":0,"beard_4":0,"lipstick_4":0,"mom":26,"nose_5":-3.2,"dad":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":-1.6,"eyebrows_2":10,"chin_3":0,"beard_3":0,"skin":12,"bproof_2":0,"eye_color":0,"chin_4":0,"ears_1":-1,"helmet_1":68,"shoes_1":25,"sun_1":-1,"blemishes_1":-1,"nose_3":9.9,"tshirt_1":207,"chest_2":10,"watches_1":-1,"chin_2":0,"bodyb_4":0,"nose_1":-10,"chest_1":-1,"pants_1":130,"hair_color_2":0,"decals_1":0,"jaw_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"skin_md_weight":8,"nose_6":0.89999999999999,"bracelets_1":-1,"blush_1":-1,"blemishes_2":10,"beard_2":10,"eyebrows_3":12,"torso_1":569,"chest_3":0,"face_md_weight":50.0,"lipstick_3":0,"eyebrows_4":12,"bags_1":0,"watches_2":-1,"pants_2":1,"decals_2":0,"nose_4":5.5,"age_2":0,"neck_thickness":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":-10,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"face_2":21,"hair_1":10,"helmet_2":2,"glasses_1":-1}', '{"bproof_1":90,"lipstick_2":10,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"makeup_1":5,"blush_2":10,"glasses_2":-1,"cheeks_3":0,"face_3":6,"mask_2":2,"eyebrows_1":1,"arms":44,"lip_thickness":0,"torso_2":0,"cheeks_2":0,"lipstick_1":3,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":83,"bodyb_3":-1,"chain_2":2,"hair_color_1":0,"tshirt_2":0,"eye_squint":0,"beard_4":0,"lipstick_4":0,"mom":26,"nose_5":-3.2,"dad":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":-1.6,"eyebrows_2":10,"chin_3":0,"beard_3":0,"skin":12,"bproof_2":0,"eye_color":0,"chin_4":0,"ears_1":-1,"helmet_1":-1,"shoes_1":25,"sun_1":-1,"blemishes_1":-1,"nose_3":9.9,"tshirt_1":15,"chest_2":10,"watches_1":-1,"chin_2":0,"bodyb_4":0,"nose_1":-10,"chest_1":-1,"pants_1":136,"hair_color_2":0,"decals_1":0,"jaw_2":0,"makeup_4":0,"makeup_2":10,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":1,"skin_md_weight":8,"nose_6":0.89999999999999,"bracelets_1":-1,"blush_1":-1,"blemishes_2":10,"beard_2":0,"eyebrows_3":26,"torso_1":568,"chest_3":0,"face_md_weight":50.0,"lipstick_3":20,"eyebrows_4":12,"bags_1":0,"watches_2":-1,"pants_2":1,"decals_2":0,"nose_4":5.5,"age_2":0,"neck_thickness":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":-10,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"face_2":21,"hair_1":30,"helmet_2":-1,"glasses_1":-1}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":false,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":false,"model":"poljug"},{"status":false,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":false,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":false,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":false,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 4, 'po1', 'Corporal', 6000, '{"bproof_1":77,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":112,"bodyb_3":-1,"chain_2":2,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":19,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":574,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":152,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":213,"helmet_2":0,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":195,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":0,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":0,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":0}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":false,"model":"poljug"},{"status":false,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":false,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 5, 'po2', 'Senior Corporal', 6500, '{"bproof_1":67,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":1,"chest_3":0,"arms":30,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":568,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":-1,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":207,"helmet_2":-1,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":130,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":0,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":3,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":1}', '{}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":true,"model":"poljug"},{"status":false,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":false,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 6, 'po2', 'Master Corporal', 7000, '{"bproof_1":77,"lipstick_2":0,"bodyb_1":-1,"chin_1":7.3,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"makeup_1":0,"blush_2":10,"glasses_2":1,"cheeks_3":0,"face_3":5,"mask_2":0,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"torso_2":3,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":112,"bodyb_3":-1,"chain_2":2,"hair_color_1":0,"beard_4":0,"mask_1":0,"arms":19,"dad":0,"mom":21,"nose_5":0,"arms_2":0,"complexion_2":1,"eyebrows_3":12,"ears_2":-1,"nose_2":0,"cheeks_2":0,"eyebrows_2":10,"beard_3":0,"eye_color":0,"bproof_2":0,"ears_1":-1,"bracelets_1":-1,"sun_1":-1,"helmet_1":-1,"chest_1":-1,"shoes_1":25,"blemishes_1":-1,"nose_3":7.0,"tshirt_1":207,"helmet_2":-1,"watches_1":-1,"chin_2":8.0,"bodyb_4":0,"nose_1":-10,"lipstick_4":0,"pants_1":130,"skin":12,"skin_md_weight":2,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"bags_1":0,"sex":0,"tshirt_2":1,"nose_6":0,"chest_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"age_2":0,"lipstick_3":0,"neck_thickness":0,"decals_1":0,"watches_2":-1,"torso_1":568,"face_2":21,"chin_4":-1.9,"face_md_weight":55.00000000000001,"chest_3":0,"nose_4":1.5,"pants_2":3,"decals_2":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":6.2,"cheeks_1":0,"eyebrows_4":12,"eyebrows_5":0,"jaw_2":4.69999999999999,"hair_1":10,"bodyb_2":0,"glasses_1":5}', '{"makeup_1":5,"lipstick_3":20,"cheeks_2":0,"decals_2":0,"nose_4":1.5,"nose_6":0,"mask_2":2,"mom":21,"bproof_1":90,"face_2":21,"bodyb_4":0,"eyebrows_3":26,"bodyb_1":-1,"neck_thickness":0,"eyebrows_1":1,"nose_3":7.0,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":31,"makeup_2":10,"face_1":0,"bracelets_2":0,"tshirt_1":278,"eyebrows_6":0,"glasses_2":1,"chest_1":-1,"watches_2":0,"chin_2":8.0,"eyebrows_5":0,"hair_1":30,"nose_2":0,"tshirt_2":0,"jaw_2":4.69999999999999,"sex":1,"ears_1":-1,"decals_1":0,"eyebrows_4":12,"makeup_3":0,"chain_2":0,"torso_2":1,"lipstick_2":10,"jaw_1":6.2,"beard_1":0,"chin_4":-1.9,"moles_1":0,"blush_1":-1,"cheeks_1":0,"beard_2":0,"blemishes_1":-1,"eye_color":0,"face_3":6,"bodyb_2":0,"mask_1":0,"pants_2":4,"watches_1":-1,"chin_1":7.3,"nose_1":-10,"complexion_1":0,"torso_1":641,"chain_1":149,"pants_1":136,"chin_3":0,"eye_squint":0,"dad":0,"bags_1":0,"hair_color_2":0,"age_1":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":2,"nose_5":0,"chest_3":0,"arms_2":0,"helmet_1":-1,"helmet_2":-1,"face_md_weight":55.00000000000001,"chest_2":10,"blush_3":0,"glasses_1":9,"bags_2":0,"complexion_2":1,"lipstick_1":3,"shoes_2":0,"beard_4":0,"eyebrows_2":10,"hair_2":0,"beard_3":0,"makeup_4":0,"sun_1":-1,"moles_2":1,"cheeks_3":0,"age_2":0,"bproof_2":0,"bodyb_3":-1,"ears_2":-1,"blemishes_2":10}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":false,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":false},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"}]'),
	('police', 7, 'po3', 'Sergeant', 7500, '{"makeup_1":0,"age_2":0,"cheeks_2":0.5,"decals_2":0,"eyebrows_4":12,"nose_6":0,"mask_2":0,"nose_5":-0.4,"chin_3":0.3,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":-0.8,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":35,"sun_2":10,"hair_color_1":0,"arms":22,"makeup_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":211,"eyebrows_6":0.1,"glasses_2":0,"arms_2":0,"watches_2":-1,"chin_2":0.89999999999999,"chest_1":-1,"age_1":0,"bproof_1":117,"nose_2":-0.1,"jaw_2":1.0,"bags_2":0,"ears_1":-1,"decals_1":0,"blush_3":0,"makeup_3":0,"chain_2":0,"torso_2":10,"lipstick_2":0,"moles_1":0,"beard_1":0,"chin_4":0.2,"jaw_1":0.7,"blush_1":-1,"nose_4":3.59999999999999,"cheeks_1":2.0,"sex":0,"eye_color":0,"face_3":5,"bodyb_2":0,"cheeks_3":4.1,"chin_1":2.5,"sun_1":-1,"nose_1":-4.3,"blemishes_1":-1,"complexion_1":0,"torso_1":570,"chain_1":0,"bproof_2":0,"pants_2":5,"tshirt_2":0,"dad":0,"bags_1":0,"eye_squint":0,"hair_color_2":0,"skin":12,"lip_thickness":-1.7,"blush_2":10,"lipstick_4":0,"skin_md_weight":8,"eyebrows_5":-0.7,"hair_1":10,"bodyb_3":-1,"mom":21,"eyebrows_2":10,"face_md_weight":25.0,"mask_1":0,"lipstick_1":0,"glasses_1":5,"helmet_1":-1,"complexion_2":1,"chest_3":0,"beard_2":10,"lipstick_3":0,"hair_2":0,"beard_4":0,"beard_3":0,"makeup_4":0,"chest_2":10,"moles_2":1,"helmet_2":-1,"shoes_2":1,"watches_1":-1,"pants_1":130,"ears_2":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"clip"},{"status":true,"name":"grip"},{"status":true,"name":"silencer"}]'),
	('police', 8, 'po3', 'Senior Sergeant', 8000, '{"bproof_1":0,"lipstick_2":0,"bodyb_1":-1,"chin_1":7.3,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"makeup_1":0,"blush_2":10,"glasses_2":-1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"arms":15,"lip_thickness":0,"torso_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"shoes_2":0,"skin_md_weight":2,"mask_1":0,"eyebrows_2":10,"nose_5":0,"dad":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"eye_color":0,"chin_3":0,"beard_3":0,"skin":12,"torso_1":15,"cheeks_2":0,"age_2":0,"ears_1":-1,"helmet_1":-1,"face_2":21,"sun_1":-1,"blemishes_1":-1,"nose_3":7.0,"tshirt_1":15,"helmet_2":-1,"watches_1":-1,"chin_2":8.0,"bodyb_4":0,"decals_2":0,"decals_1":0,"pants_1":61,"eyebrows_3":12,"mom":21,"nose_1":-10,"makeup_4":0,"makeup_2":0,"beard_4":0,"sun_2":10,"bags_1":0,"sex":0,"bproof_2":0,"nose_6":0,"hair_color_2":0,"blush_1":-1,"blemishes_2":10,"beard_2":10,"jaw_2":4.69999999999999,"neck_thickness":0,"chest_1":-1,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"face_md_weight":55.00000000000001,"complexion_1":0,"chin_4":-1.9,"shoes_1":34,"nose_4":1.5,"chest_2":10,"pants_2":1,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":6.2,"cheeks_1":0,"chest_3":0,"eyebrows_5":0,"glasses_1":-1,"hair_1":10,"cheeks_3":0,"bodyb_2":0}', '{}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 9, 'senior', 'Master Sergeant', 8500, '{"bproof_1":78,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":19,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":585,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":-1,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":220,"helmet_2":-1,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":130,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":1,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":3,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":0}', '{}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 10, 'sergent', 'SPT', 9000, '{"bproof_1":191,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":35,"blush_2":10,"glasses_2":1,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":238,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":19,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":574,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":152,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":213,"helmet_2":0,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":130,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":22,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":1,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":0}', '{}', '[{"status":true,"model":"1200rt"},{"status":false,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 11, 'com', 'Second Lieutenant', 10000, '{"bproof_1":119,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":2,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":25,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":606,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":-1,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":15,"helmet_2":-1,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":130,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":0,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":4,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":3}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 12, 'com', 'First Lieutenant', 11000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 13, 'com', 'Captain', 12000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":false,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 14, 'boss', 'Major', 13000, '{"makeup_1":0,"age_2":0,"cheeks_2":-0.89999999999999,"decals_2":0,"eyebrows_4":12,"nose_6":0,"mask_2":0,"nose_5":-2.2,"bproof_1":0,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"neck_thickness":6.2,"eyebrows_1":0,"nose_3":3.2,"bracelets_1":-1,"shoes_1":25,"sun_2":10,"hair_color_1":0,"arms":74,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":207,"eyebrows_6":0.2,"glasses_2":-1,"dad":0,"watches_2":-1,"chin_2":0.3,"chest_1":-1,"tshirt_2":1,"watches_1":-1,"nose_2":4.69999999999999,"jaw_2":2.3,"sun_1":5,"ears_1":-1,"decals_1":0,"nose_4":7.0,"hair_color_2":0,"chain_2":2,"torso_2":25,"makeup_3":0,"lipstick_2":0,"blush_3":0,"chin_4":-0.4,"eye_squint":0,"blush_1":-1,"moles_1":0,"cheeks_1":3.0,"cheeks_3":3.59999999999999,"eye_color":0,"face_3":5,"bodyb_2":0,"mask_1":0,"bodyb_3":-1,"makeup_2":0,"chin_1":-1.6,"beard_2":10,"complexion_1":0,"torso_1":574,"chain_1":112,"bproof_2":0,"nose_1":0.7,"blemishes_1":-1,"jaw_1":2.3,"bags_1":0,"pants_1":59,"pants_2":8,"skin":12,"lip_thickness":5.4,"blush_2":10,"lipstick_4":0,"skin_md_weight":8,"hair_1":10,"age_1":0,"eyebrows_5":0.1,"beard_1":0,"lipstick_1":0,"face_md_weight":55.00000000000001,"chest_2":10,"chest_3":0,"glasses_1":-1,"helmet_1":-1,"complexion_2":1,"beard_3":0,"eyebrows_2":10,"hair_2":0,"beard_4":0,"lipstick_3":0,"arms_2":0,"makeup_4":0,"helmet_2":-1,"moles_2":1,"shoes_2":0,"mom":21,"sex":0,"chin_3":-3.9,"ears_2":-1,"blemishes_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 15, 'boss', 'Colonel', 14000, '{"makeup_1":0,"age_2":0,"cheeks_2":0,"decals_2":0,"nose_4":0,"nose_6":0,"mask_2":0,"nose_5":0,"bproof_1":127,"face_2":21,"bodyb_4":0,"eyebrows_3":12,"bodyb_1":-1,"watches_1":-1,"eyebrows_1":0,"nose_3":0,"bracelets_1":-1,"shoes_1":35,"sun_2":10,"hair_color_1":0,"arms":19,"bags_2":0,"face_1":0,"bracelets_2":0,"tshirt_1":212,"eyebrows_6":0,"glasses_2":1,"sun_1":-1,"watches_2":-1,"chin_2":-0.1,"chest_1":-1,"dad":0,"hair_1":10,"nose_2":0,"jaw_2":0,"chest_2":10,"ears_1":-1,"decals_1":0,"blush_3":0,"sex":0,"chain_2":0,"torso_2":2,"makeup_3":0,"lipstick_2":0,"beard_1":0,"chin_4":0,"makeup_2":0,"blush_1":-1,"pants_2":0,"cheeks_1":0,"beard_3":0,"eye_color":0,"face_3":5,"bodyb_2":0,"chin_3":0,"cheeks_3":0,"moles_1":0,"eyebrows_4":12,"nose_1":0.1,"complexion_1":0,"torso_1":574,"chain_1":238,"pants_1":130,"blemishes_1":-1,"lipstick_1":0,"jaw_1":-0.1,"bags_1":0,"hair_color_2":0,"eye_squint":0,"skin":12,"lip_thickness":0,"blush_2":10,"lipstick_4":0,"skin_md_weight":8,"age_1":0,"eyebrows_5":0,"bodyb_3":-1,"helmet_2":-1,"tshirt_2":0,"face_md_weight":50.0,"mask_1":121,"chest_3":0,"chin_1":7.9,"moles_2":1,"complexion_2":1,"mom":21,"lipstick_3":0,"eyebrows_2":10,"hair_2":0,"beard_4":0,"arms_2":0,"glasses_1":5,"makeup_4":0,"helmet_1":-1,"bproof_2":2,"beard_2":10,"shoes_2":0,"neck_thickness":-10,"ears_2":-1,"blemishes_2":10}', '{"bproof_1":0,"lipstick_2":10,"bodyb_1":-1,"chin_1":-0.1,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":35,"blush_2":10,"glasses_2":-1,"face_2":21,"face_3":6,"mask_2":2,"tshirt_2":0,"chin_3":-6.8,"lip_thickness":-10,"age_2":0,"eye_squint":0,"lipstick_1":3,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"dad":0,"chain_2":0,"hair_color_1":0,"beard_4":0,"torso_1":16,"sun_1":-1,"helmet_1":-1,"mom":21,"nose_5":-2.3,"arms":15,"complexion_2":1,"makeup_1":5,"ears_2":-1,"nose_2":0,"arms_2":0,"helmet_2":-1,"beard_3":0,"skin":12,"bproof_2":0,"chest_1":-1,"eye_color":0,"ears_1":-1,"decals_1":0,"bags_1":0,"lipstick_4":0,"blemishes_1":-1,"nose_3":4.6,"tshirt_1":15,"chest_2":10,"watches_1":-1,"chin_2":1.7,"bodyb_4":0,"nose_1":-4.5,"eyebrows_4":12,"pants_1":9,"skin_md_weight":0,"hair_color_2":0,"glasses_1":-1,"makeup_4":0,"makeup_2":10,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":1,"eyebrows_2":10,"eyebrows_3":26,"torso_2":0,"blush_1":-1,"blemishes_2":10,"beard_2":0,"nose_6":0,"neck_thickness":-7.4,"cheeks_2":9.9,"watches_2":-1,"lipstick_3":20,"cheeks_3":-10,"face_md_weight":100,"bodyb_3":-1,"chest_3":0,"chin_4":0,"nose_4":7.6,"pants_2":12,"eyebrows_1":1,"blush_3":0,"bracelets_2":0,"eyebrows_6":-0.8,"jaw_1":-5.0,"cheeks_1":-10,"bodyb_2":0,"eyebrows_5":5.69999999999999,"jaw_2":-4.5,"hair_1":30,"bracelets_1":-1,"decals_2":0}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 16, 'boss', 'HighCommand', 15000, '{"bags_2":0,"lipstick_1":0,"bodyb_2":0,"eye_squint":0,"eyebrows_4":12,"lip_thickness":0,"sex":0,"blush_1":-1,"makeup_2":0,"helmet_2":1,"ears_1":-1,"chest_2":10,"age_1":0,"face_2":21,"mask_1":0,"shoes_2":0,"chin_1":0,"lipstick_2":0,"face_3":5,"bags_1":0,"nose_3":0,"nose_6":0,"tshirt_1":214,"bodyb_3":-1,"ears_2":-1,"eyebrows_3":12,"decals_2":0,"torso_1":606,"hair_color_2":0,"mask_2":2,"makeup_3":0,"moles_2":1,"watches_2":0,"jaw_2":0,"skin":12,"jaw_1":0,"nose_5":0,"nose_2":0,"pants_2":0,"chin_3":0,"hair_2":0,"blemishes_1":-1,"pants_1":195,"lipstick_3":0,"helmet_1":28,"glasses_2":2,"makeup_4":0,"tshirt_2":0,"watches_1":7,"mom":21,"hair_color_1":0,"beard_4":0,"chain_2":0,"dad":0,"face_1":0,"nose_1":0,"chain_1":0,"complexion_1":0,"chest_3":0,"sun_1":-1,"torso_2":0,"face_md_weight":50.0,"decals_1":0,"eyebrows_6":0,"arms_2":0,"cheeks_3":0,"complexion_2":1,"eye_color":0,"eyebrows_5":0,"chest_1":-1,"blemishes_2":10,"bodyb_1":-1,"hair_1":10,"neck_thickness":0,"bodyb_4":0,"eyebrows_2":10,"bproof_2":0,"chin_4":0,"cheeks_2":0,"chin_2":0,"skin_md_weight":6,"lipstick_4":0,"glasses_1":8,"blush_3":0,"cheeks_1":0,"eyebrows_1":0,"arms":25,"sun_2":10,"blush_2":10,"bracelets_2":0,"beard_3":0,"beard_1":0,"shoes_1":60,"moles_1":0,"beard_2":10,"age_2":0,"bracelets_1":-1,"nose_4":0,"bproof_1":91,"makeup_1":0}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 17, 'boss', 'Commander', 16000, '{"bproof_1":67,"lipstick_2":0,"bodyb_1":-1,"chin_1":2.2,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":7,"cheeks_3":0,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":1.1,"lip_thickness":1.3,"torso_2":3,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"dad":0,"chain_2":0,"hair_color_1":0,"beard_4":0,"skin":12,"torso_1":605,"arms":19,"mom":21,"nose_5":0,"hair_color_2":0,"complexion_2":1,"makeup_1":0,"ears_2":-1,"nose_2":0,"arms_2":0,"eyebrows_2":10,"beard_3":0,"eye_color":0,"bproof_2":2,"chest_3":0,"sun_1":-1,"bracelets_1":-1,"helmet_1":-1,"ears_1":-1,"skin_md_weight":8,"blemishes_1":-1,"nose_3":0,"tshirt_1":207,"helmet_2":-1,"watches_1":13,"chin_2":2.0,"bodyb_4":0,"nose_1":0,"bags_1":0,"pants_1":130,"eyebrows_4":12,"decals_1":0,"tshirt_2":1,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"jaw_2":-2.2,"nose_6":0,"cheeks_2":0,"blush_1":-1,"blemishes_2":10,"beard_2":10,"eyebrows_3":12,"age_2":0,"shoes_2":0,"lipstick_3":0,"neck_thickness":0,"decals_2":0,"watches_2":0,"face_2":21,"pants_2":1,"bodyb_3":-1,"nose_4":0,"chin_4":0.2,"face_md_weight":65.0,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":-7.0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"chest_2":10,"hair_1":10,"chest_1":-1,"glasses_1":18}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 18, 'boss', 'Deputy Chief', 17000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[]'),
	('police', 19, 'boss', 'Assistant Chief', 18000, '{"bproof_1":120,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":3,"bracelets_1":-1,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":296,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":26,"glasses_1":8,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":605,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":93,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":234,"helmet_2":0,"watches_1":20,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":195,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":0,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":8,"eyebrows_4":12,"lipstick_3":0,"watches_2":0,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":0,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":0}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 20, 'boss', 'Chief', 19000, '{"bproof_1":64,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"makeup_1":0,"blush_2":10,"glasses_2":1,"cheeks_3":0,"face_3":5,"mask_2":13,"eyebrows_1":0,"arms":52,"lip_thickness":0,"torso_2":9,"cheeks_2":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":112,"bodyb_3":-1,"chain_2":2,"hair_color_1":0,"tshirt_2":0,"eye_squint":0,"beard_4":0,"lipstick_4":0,"mom":26,"nose_5":-3.2,"dad":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":-1.6,"eyebrows_2":10,"chin_3":0,"beard_3":0,"skin":12,"bproof_2":0,"eye_color":0,"chin_4":0,"ears_1":-1,"helmet_1":-1,"shoes_1":25,"sun_1":-1,"blemishes_1":-1,"nose_3":9.9,"tshirt_1":212,"chest_2":10,"watches_1":-1,"chin_2":0,"bodyb_4":0,"nose_1":-10,"chest_1":-1,"pants_1":195,"hair_color_2":0,"decals_1":0,"jaw_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":169,"sex":0,"skin_md_weight":8,"nose_6":0.89999999999999,"bracelets_1":-1,"blush_1":-1,"blemishes_2":10,"beard_2":10,"eyebrows_3":12,"torso_1":574,"chest_3":0,"face_md_weight":50.0,"lipstick_3":0,"eyebrows_4":12,"bags_1":0,"watches_2":-1,"pants_2":0,"decals_2":0,"nose_4":5.5,"age_2":0,"neck_thickness":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":-10,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"face_2":21,"hair_1":10,"helmet_2":-1,"glasses_1":5}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('police', 21, 'boss', 'Commissioner', 20000, '{"bproof_1":119,"lipstick_2":0,"bodyb_1":-1,"chin_1":0,"moles_2":1,"age_1":0,"shoes_2":0,"bags_2":0,"beard_1":0,"shoes_1":25,"blush_2":10,"glasses_2":1,"bracelets_1":-1,"face_3":5,"mask_2":0,"eyebrows_1":0,"chin_3":0,"lip_thickness":0,"age_2":0,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":296,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"chest_3":0,"arms":19,"glasses_1":5,"mom":21,"nose_5":0,"makeup_1":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":0,"jaw_2":0,"cheeks_2":0,"beard_3":0,"eye_color":0,"torso_1":606,"skin":12,"ears_1":-1,"chest_1":-1,"helmet_1":152,"sun_1":-1,"decals_1":0,"blemishes_1":-1,"nose_3":0,"tshirt_1":212,"helmet_2":0,"watches_1":-1,"chin_2":0,"bodyb_4":0,"decals_2":0,"beard_4":0,"pants_1":195,"eyebrows_3":12,"skin_md_weight":3,"hair_color_2":0,"makeup_4":0,"makeup_2":0,"complexion_1":0,"sun_2":10,"mask_1":121,"sex":0,"dad":0,"nose_6":0,"eyebrows_2":10,"blush_1":-1,"blemishes_2":10,"beard_2":10,"lipstick_4":0,"neck_thickness":0,"torso_2":0,"eyebrows_4":12,"lipstick_3":0,"watches_2":-1,"nose_1":0,"face_md_weight":50.0,"chin_4":0,"chest_2":10,"nose_4":0,"pants_2":2,"face_2":21,"blush_3":0,"bracelets_2":0,"eyebrows_6":0,"jaw_1":0,"cheeks_1":0,"bodyb_2":0,"eyebrows_5":0,"bags_1":0,"hair_1":10,"cheeks_3":0,"bproof_2":3}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"corvette"},{"status":true,"model":"motorpm"},{"status":true,"model":"orbmwm5"},{"status":true,"model":"pf"},{"status":true,"model":"poljug"},{"status":true,"model":"polkch"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":true,"model":"shacara"},{"status":true,"model":"vvpi"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"silencer","status":true},{"name":"clip","status":true},{"name":"grip","status":true}]'),
	('psuspend', 0, 'employee', 'Employee', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('reporter', 0, 'employee', 'TyÃ¶lÃ¤inen', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('resturan', 0, 'trainee', 'Trainee', 0, '{}', '{}', NULL, NULL, NULL, NULL),
	('resturan', 1, 'boss', 'Chief', 20000, '{}', '{}', '', NULL, '', ''),
	('sheriff', 0, 'cadet', 'Cadet', 7800, '{}', '{}', NULL, NULL, NULL, NULL),
	('sheriff', 1, 'cadet', 'Deputy', 1000, '{"glasses_2":7,"cheeks_2":0,"blemishes_2":10,"lipstick_3":0,"complexion_2":1,"cheeks_1":0,"shoes_2":0,"face_3":5,"hair_1":10,"hair_color_1":0,"bulletproof_vest_1":79,"eyebrows_1":0,"chest_1":-1,"chain_2":0,"face_2":21,"ears_1":-1,"shoes_1":51,"jaw_2":0,"age_1":0,"beard_1":0,"jaw_1":0,"moles_1":0,"blush_1":-1,"sex":0,"chin_3":0,"eyebrows_6":0,"skin_md_weight":6,"eye_squint":0,"watches_2":0,"bulletproof_2":0,"sun_1":-1,"nose_5":0,"nose_1":0,"age_2":0,"sun_2":10,"moles_2":1,"beard_4":0,"decals_2":0,"bracelets_2":0,"eye_color":0,"hair_2":0,"complexion_1":0,"chin_2":0,"pants_1":25,"lipstick_2":0,"eyebrows_4":12,"hair_color_2":0,"dad":0,"blush_2":10,"bproof_1":88,"torso_2":0,"chin_4":0,"eyebrows_3":12,"eyebrows_2":10,"lipstick_4":0,"bodyb_1":-1,"blemishes_1":-1,"makeup_2":0,"mask_2":0,"nose_4":0,"lipstick_1":0,"tshirt_1":214,"beard_3":0,"arms":19,"helmet_2":7,"nose_6":0,"nose_2":0,"face":0,"face_md_weight":50.0,"mom":21,"lip_thickness":0,"face_1":0,"beard_2":10,"decals_1":0,"helmet_1":221,"bulletproof_vest_2":0,"blush_3":0,"torso_1":590,"chin_1":0,"makeup_1":0,"skin":12,"chain_1":227,"mask_1":121,"bulletproof_1":79,"arms_2":0,"makeup_3":0,"bodyb_4":0,"bags_2":0,"eyebrows_5":0,"bodyb_3":-1,"pants_2":0,"nose_3":0,"bodyb_2":0,"tshirt_2":0,"neck_thickness":0,"chest_2":10,"bproof_2":0,"watches_1":-1,"bags_1":-1,"ears_2":-1,"bracelets_1":-1,"chest_3":0,"glasses_1":5,"cheeks_3":0,"makeup_4":0}', '{"tshirt_2":0,"eyebrows_4":12,"eye_color":0,"watches_1":-1,"mask_1":0,"bulletproof_vest_2":0,"shoes_1":35,"mask_2":2,"moles_1":0,"chest_3":0,"helmet_2":-1,"bodyb_4":0,"chin_1":0,"lipstick_3":20,"hair_color_1":0,"blush_3":0,"chain_2":0,"beard_3":0,"pants_2":12,"eyebrows_6":0,"eyebrows_5":0,"ears_2":-1,"hair_1":30,"lipstick_2":10,"arms":15,"nose_2":0,"pants_1":9,"face_1":0,"nose_3":0,"bproof_2":0,"watches_2":-1,"blush_2":10,"face":0,"nose_4":0,"decals_1":0,"bulletproof_2":0,"blemishes_2":10,"glasses_2":-1,"face_md_weight":50.0,"face_3":6,"age_2":0,"decals_2":0,"eyebrows_1":1,"beard_1":0,"nose_1":-4.2,"bulletproof_vest_1":79,"sex":1,"eyebrows_3":26,"beard_2":0,"cheeks_2":-3.2,"lipstick_4":0,"blemishes_1":-1,"nose_5":0,"complexion_1":0,"lip_thickness":0,"nose_6":0,"sun_1":-1,"makeup_1":5,"cheeks_3":0.1,"bulletproof_1":79,"makeup_4":0,"makeup_2":10,"bracelets_2":0,"makeup_3":0,"sun_2":10,"beard_4":0,"shoes_2":0,"dad":0,"skin_md_weight":6,"chain_1":0,"chest_2":10,"eye_squint":0,"arms_2":0,"eyebrows_2":10,"torso_1":16,"jaw_2":-8.6,"neck_thickness":-0.5,"jaw_1":-0.1,"complexion_2":1,"torso_2":0,"moles_2":1,"chin_3":0,"tshirt_1":15,"bodyb_2":0,"bags_1":0,"bodyb_3":-1,"age_1":0,"lipstick_1":3,"glasses_1":-1,"chin_2":0,"hair_2":0,"chin_4":0,"hair_color_2":0,"cheeks_1":-0.1,"mom":21,"bproof_1":0,"bodyb_1":-1,"chest_1":-1,"face_2":21,"bags_2":0,"ears_1":-1,"bracelets_1":-1,"skin":12,"helmet_1":-1,"blush_1":-1}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":false},{"model":"shacara","status":false},{"model":"polreb","status":false},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":false},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"vvpi","status":true},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_NIGHTSTICK","status":false},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":false},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":false},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_CARBINERIFLE","status":false},{"model":"WEAPON_ASSAULTSMG","status":false},{"model":"WEAPON_BULLPUPRIFLE","status":false}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":false,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":false,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 2, 'cadet', 'Senior Deputy', 2000, '{"chest_1":-1,"bproof_1":118,"beard_1":0,"pants_1":31,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":214,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":7,"neck_thickness":0,"torso_2":0,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":26,"blemishes_2":10,"bags_1":-1,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":7,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":221,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":591,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":6,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":false},{"model":"shacara","status":false},{"model":"polreb","status":true},{"model":"polneon","status":false},{"model":"polros","status":false},{"model":"polkmd","status":false},{"model":"polkch","status":false},{"model":"poljug","status":false},{"model":"vvpi","status":true},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":false},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":false},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":false},{"model":"WEAPON_SMG","status":false},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":false},{"model":"WEAPON_SPECIALCARBINE","status":false},{"model":"WEAPON_CARBINERIFLE","status":false},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":false}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":false,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 3, 'cadet', 'Master Deputy', 3000, '{"chest_1":-1,"bproof_1":96,"beard_1":0,"pants_1":31,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":214,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":3,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":8,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":564,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":false,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":false,"model":"polneon"},{"status":false,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":false,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":false,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 4, 'po1', 'Specialist', 4000, '{"chest_1":-1,"bproof_1":118,"beard_1":0,"pants_1":130,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":214,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":3,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":2,"neck_thickness":0,"torso_2":22,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":4,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":221,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":564,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":6,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":false,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":false,"model":"polneon"},{"status":false,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":false,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 5, 'po1', 'Corporal', 5000, '{"chest_1":-1,"bproof_1":81,"beard_1":0,"pants_1":130,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":207,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":5,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":5,"neck_thickness":0,"torso_2":1,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":1,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":221,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":556,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":0,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":false,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":false,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":false,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 6, 'po2', 'Senior Corpral', 6000, '{"chest_1":-1,"bproof_1":116,"beard_1":0,"pants_1":130,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":214,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":0,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":3,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":564,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":7,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":false,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":false,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":false,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 7, 'po2', 'Master Corpral', 7000, '{"chest_1":-1,"bproof_1":91,"beard_1":0,"pants_1":31,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":218,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":2,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":2,"neck_thickness":0,"torso_2":7,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":6,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":25,"nose_2":0,"tshirt_2":0,"helmet_1":58,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":556,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":4,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":false,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":false,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 8, 'po3', 'Sergeant', 8000, '{"chest_1":-1,"bproof_1":88,"beard_1":0,"pants_1":31,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":207,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":4,"neck_thickness":0,"torso_2":4,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":6,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":1,"helmet_1":221,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":572,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":213,"chin_2":0,"skin_md_weight":6,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":0,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":true},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":false},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":false},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":true,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 9, 'po3', 'Senior Sergeant', 9000, '{"chest_1":-1,"bproof_1":93,"beard_1":0,"pants_1":195,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":220,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":1,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":3,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":24,"nose_2":0,"tshirt_2":0,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":545,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":false,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":false,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":false,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":false,"model":"sunsetfbi"},{"status":false,"model":"polgt17"},{"status":false,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":false,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":false,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 10, 'senior', 'Master Sergeant', 10000, '{"eye_color":0,"chest_2":10,"chin_4":0,"makeup_4":0,"decals_2":0,"chin_3":0,"face_3":5,"chain_1":227,"ears_2":-1,"hair_1":10,"shoes_2":0,"bproof_2":1,"bracelets_2":0,"chin_1":0,"chest_1":-1,"eyebrows_3":12,"mom":21,"pants_1":130,"arms_2":0,"sun_1":-1,"jaw_2":0,"makeup_2":0,"torso_1":604,"cheeks_3":0,"eye_squint":0,"skin_md_weight":6,"mask_2":0,"face_1":0,"hair_color_1":0,"shoes_1":25,"lip_thickness":0,"chest_3":0,"beard_4":0,"blemishes_1":-1,"lipstick_1":0,"skin":12,"age_1":0,"blush_1":-1,"nose_6":0,"nose_5":0,"sun_2":10,"hair_2":0,"nose_1":0,"watches_1":20,"nose_3":0,"complexion_1":0,"nose_2":0,"glasses_1":5,"face":0,"jaw_1":0,"bodyb_2":0,"eyebrows_5":0,"lipstick_3":0,"beard_2":10,"blush_2":10,"bulletproof_2":0,"makeup_3":0,"neck_thickness":0,"pants_2":1,"bulletproof_1":79,"mask_1":121,"cheeks_1":0,"face_md_weight":40.0,"beard_1":0,"helmet_1":220,"chain_2":0,"torso_2":3,"eyebrows_1":0,"hair_color_2":0,"tshirt_1":211,"dad":0,"complexion_2":1,"bodyb_3":-1,"cheeks_2":0,"decals_1":0,"eyebrows_4":12,"sex":0,"beard_3":0,"age_2":0,"eyebrows_6":0,"bulletproof_vest_1":79,"eyebrows_2":10,"glasses_2":3,"bags_1":0,"bags_2":0,"ears_1":-1,"makeup_1":0,"nose_4":0,"helmet_2":0,"moles_2":1,"lipstick_2":0,"bracelets_1":-1,"blush_3":0,"tshirt_2":0,"bodyb_4":0,"moles_1":0,"face_2":21,"chin_2":0,"bulletproof_vest_2":0,"bodyb_1":-1,"watches_2":0,"bproof_1":93,"lipstick_4":0,"arms":19,"blemishes_2":10}', '{"blush_3":0,"hair_2":0,"bracelets_2":0,"glasses_2":0,"cheeks_1":0,"nose_5":0,"sex":1,"tshirt_2":1,"complexion_2":1,"bulletproof_1":79,"bags_2":0,"skin":12,"chin_4":0,"glasses_1":7,"torso_2":0,"lipstick_2":10,"age_2":0,"bproof_2":2,"chest_1":-1,"blush_2":10,"makeup_2":10,"nose_6":0,"face_2":21,"cheeks_2":0,"pants_1":136,"chain_2":0,"helmet_1":-1,"jaw_1":0,"beard_4":0,"chin_2":0,"chest_3":0,"arms_2":0,"torso_1":569,"moles_2":1,"chest_2":10,"hair_color_1":0,"hair_color_2":0,"eye_color":0,"bodyb_4":0,"nose_4":0,"nose_3":0,"sun_2":10,"mom":21,"bulletproof_vest_1":79,"eyebrows_4":12,"eyebrows_3":26,"sun_1":-1,"bodyb_1":-1,"makeup_1":5,"beard_1":0,"watches_2":2,"age_1":0,"lip_thickness":0,"jaw_2":0,"lipstick_3":20,"face":0,"blemishes_1":-1,"hair_1":30,"makeup_4":0,"bulletproof_2":0,"bodyb_2":0,"face_3":6,"moles_1":0,"decals_2":0,"bulletproof_vest_2":0,"blemishes_2":10,"makeup_3":0,"shoes_2":1,"watches_1":6,"bproof_1":72,"shoes_1":36,"skin_md_weight":0,"eye_squint":0,"bracelets_1":0,"face_1":0,"lipstick_4":0,"mask_1":121,"mask_2":0,"beard_3":0,"cheeks_3":-10,"blush_1":-1,"eyebrows_2":10,"bodyb_3":-1,"pants_2":1,"bags_1":0,"decals_1":0,"arms":20,"face_md_weight":50.0,"eyebrows_1":1,"lipstick_1":3,"complexion_1":0,"helmet_2":-1,"chain_1":149,"chin_1":-5.5,"eyebrows_6":0,"nose_2":0,"ears_2":-1,"nose_1":0,"ears_1":-1,"chin_3":0,"eyebrows_5":0,"neck_thickness":-10,"dad":0,"tshirt_1":255,"beard_2":0}', '[{"model":"1200rt","status":false},{"model":"sunsetsp","status":false},{"model":"sunsetpv","status":true},{"model":"shacara","status":false},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":false},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":false},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":false},{"model":"lsfdpickup","status":false},{"model":"riot","status":false},{"model":"fchal","status":false}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":false},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":false},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 11, 'boss', 'Second Lieutenant', 11000, '{"chest_1":-1,"bproof_1":127,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":207,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":1,"neck_thickness":0,"torso_2":24,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":1,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":35,"nose_2":0,"tshirt_2":0,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":574,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":29,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":0,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 12, 'boss', 'First Lieutenant', 12000, '{"chest_1":-1,"bproof_1":96,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":207,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":24,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":226,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":35,"nose_2":0,"tshirt_2":1,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":574,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":0,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":5,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":0,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":true,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 13, 'boss', 'FBI', 0, '{"bags_1":0,"chain_1":18,"torso_1":632,"mask_2":13,"chain_2":1,"decals_1":0,"helmet_1":123,"tshirt_2":0,"helmet_2":0,"shoes_2":0,"bproof_2":0,"glasses_1":15,"arms":23,"decals_2":0,"pants_2":1,"tshirt_1":29,"torso_2":15,"mask_1":43,"pants_1":164,"glasses_2":7,"bproof_1":154,"bags_2":0,"shoes_1":40}', '', '', NULL, '', ''),
	('sheriff', 14, 'boss', 'Captain', 13000, '{"chest_1":-1,"bproof_1":127,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":214,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":4,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":1,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":35,"nose_2":0,"tshirt_2":0,"helmet_1":226,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":572,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":0,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":false},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 15, 'boss', 'Major', 14000, '{"chest_1":-1,"bproof_1":127,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":218,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":1,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":26,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":35,"nose_2":0,"tshirt_2":0,"helmet_1":-1,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":536,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":7,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":2,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":false,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":true,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 16, 'boss', 'FBI Management', 15000, '{"eyebrows_1":0,"bulletproof_vest_1":79,"bracelets_1":-1,"face_1":0,"jaw_1":0,"sex":0,"helmet_2":0,"watches_1":-1,"hair_2":0,"bags_1":0,"bodyb_2":0,"decals_1":0,"complexion_1":0,"cheeks_3":0,"age_1":0,"bulletproof_2":0,"lip_thickness":0,"bodyb_4":0,"dad":0,"tshirt_2":0,"eyebrows_3":12,"face_2":21,"makeup_1":0,"helmet_1":-1,"cheeks_2":0,"bodyb_1":-1,"ears_1":-1,"blemishes_1":-1,"tshirt_1":214,"makeup_4":0,"bags_2":0,"torso_1":574,"beard_2":10,"hair_color_2":0,"bracelets_2":0,"face":0,"mask_1":121,"arms":19,"eye_squint":0,"beard_4":0,"nose_5":0,"blush_1":-1,"chin_1":0,"eyebrows_5":0,"blemishes_2":10,"nose_4":0,"neck_thickness":-10,"arms_2":0,"glasses_1":5,"lipstick_2":0,"lipstick_4":0,"age_2":0,"face_3":5,"nose_2":0,"sun_1":-1,"chest_3":0,"face_md_weight":50.0,"chest_2":10,"hair_color_1":0,"bulletproof_vest_2":0,"bproof_2":7,"eyebrows_6":0,"eyebrows_2":10,"nose_6":0,"blush_3":0,"complexion_2":1,"lipstick_1":0,"mom":21,"chest_1":-1,"shoes_1":25,"nose_3":0,"skin":12,"beard_3":0,"watches_2":-1,"chin_2":0,"makeup_2":0,"shoes_2":0,"lipstick_3":0,"pants_2":3,"jaw_2":0,"chin_3":0,"glasses_2":4,"torso_2":16,"eyebrows_4":12,"bodyb_3":-1,"decals_2":0,"nose_1":0,"moles_2":1,"sun_2":10,"makeup_3":0,"skin_md_weight":6,"bulletproof_1":79,"cheeks_1":0,"eye_color":0,"moles_1":0,"beard_1":0,"ears_2":-1,"bproof_1":118,"pants_1":130,"chain_1":226,"chain_2":0,"blush_2":10,"hair_1":10,"mask_2":0,"chin_4":0}', '{"face_2":21,"tshirt_2":1,"bodyb_2":0,"chin_1":0,"beard_2":0,"glasses_2":-1,"chain_2":0,"skin":12,"nose_2":0,"sun_2":10,"age_2":0,"beard_3":0,"bulletproof_vest_2":0,"neck_thickness":0,"bproof_2":8,"moles_1":0,"makeup_4":0,"watches_1":-1,"bags_1":0,"torso_2":0,"blemishes_2":9,"lipstick_3":20,"face_3":6,"shoes_2":0,"helmet_2":0,"watches_2":-1,"eyebrows_1":1,"ears_2":-1,"blush_1":-1,"chin_2":0,"complexion_2":1,"bulletproof_2":0,"chest_2":10,"sun_1":-1,"chest_1":-1,"helmet_1":-1,"bodyb_3":-1,"chin_3":0,"hair_2":0,"blemishes_1":-1,"nose_1":0,"chain_1":0,"cheeks_2":0,"torso_1":587,"complexion_1":0,"lipstick_1":3,"blush_2":10,"bulletproof_vest_1":79,"ears_1":-1,"bodyb_4":0,"nose_5":0,"decals_2":0,"bracelets_2":0,"nose_3":0,"lipstick_2":10,"face_1":0,"makeup_3":0,"sex":1,"nose_4":0,"eye_squint":0,"skin_md_weight":7,"tshirt_1":255,"jaw_1":0,"bulletproof_1":79,"moles_2":1,"arms_2":0,"lipstick_4":0,"cheeks_1":0,"face":0,"beard_4":0,"bproof_1":73,"makeup_1":5,"hair_color_2":0,"jaw_2":0,"hair_color_1":0,"bags_2":0,"age_1":0,"eyebrows_2":10,"beard_1":0,"mask_1":121,"pants_2":1,"mom":21,"decals_1":0,"pants_1":136,"blush_3":0,"lip_thickness":0,"face_md_weight":50,"chest_3":0,"mask_2":0,"makeup_2":10,"eye_color":0,"nose_6":0,"chin_4":0,"eyebrows_3":26,"cheeks_3":0,"bracelets_1":-1,"eyebrows_6":0,"shoes_1":25,"glasses_1":-1,"hair_1":30,"eyebrows_4":12,"eyebrows_5":0,"bodyb_1":-1,"arms":20,"dad":0}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":false,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":false,"model":"fchal"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":true},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":true,"name":"armor"},{"status":false,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":true,"name":"grip"},{"status":true,"name":"lsd"},{"status":true,"name":"phone"},{"status":true,"name":"pizza"},{"status":true,"name":"radio"},{"status":true,"name":"silencer"},{"status":true,"name":"water"}]'),
	('sheriff', 17, 'boss', 'Colonel', 16000, '{"chest_1":-1,"bproof_1":127,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"dad":0,"glasses_1":5,"bodyb_3":-1,"tshirt_1":208,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":0,"age_1":0,"sun_1":-1,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":0,"torso_2":2,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_2":0,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":0,"eyebrows_3":12,"makeup_4":0,"nose_4":0,"blemishes_1":-1,"bracelets_1":-1,"bags_2":0,"arms":19,"blemishes_2":10,"bags_1":0,"eyebrows_1":0,"chin_4":0,"bodyb_1":-1,"arms_2":0,"eyebrows_5":0,"sun_2":10,"eyebrows_6":0,"blush_2":10,"decals_2":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"shoes_1":35,"nose_2":0,"tshirt_2":0,"helmet_1":226,"lipstick_1":0,"jaw_2":0,"chin_3":0,"moles_2":1,"chin_1":0,"moles_1":0,"bodyb_2":0,"torso_1":605,"beard_3":0,"complexion_1":0,"hair_color_2":0,"nose_1":0,"ears_1":-1,"chest_2":10,"chest_3":0,"watches_1":20,"hair_2":0,"complexion_2":1,"mom":21,"eye_squint":0,"decals_1":0,"chin_2":0,"skin_md_weight":6,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":40.0,"bproof_2":1,"jaw_1":0,"nose_6":0,"blush_1":-1,"lipstick_2":0,"bulletproof_vest_1":79,"ears_2":-1,"watches_2":0,"lipstick_4":0,"eye_color":0,"mask_1":121,"bulletproof_1":79,"bodyb_4":0,"chain_2":2,"lipstick_3":0,"eyebrows_2":10}', '{}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":false}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 18, 'boss', 'Commander', 17000, '{"arms":20,"bodyb_2":0,"eye_color":0,"face":0,"pants_1":31,"bulletproof_vest_2":0,"face_2":21,"eyebrows_6":0,"beard_1":0,"makeup_4":0,"bodyb_1":-1,"watches_1":-1,"blemishes_2":10,"mask_1":121,"bags_2":0,"sex":0,"makeup_3":0,"chin_2":0,"jaw_1":0,"cheeks_1":0,"bags_1":125,"eyebrows_5":0,"chain_2":0,"nose_3":0,"shoes_1":24,"bproof_1":0,"skin":12,"cheeks_2":0,"glasses_1":5,"chest_3":0,"mom":21,"age_1":0,"nose_4":0,"moles_2":1,"bracelets_2":0,"chest_2":10,"decals_1":0,"eyebrows_4":12,"bulletproof_vest_1":79,"lipstick_1":0,"shoes_2":0,"blush_1":-1,"beard_3":0,"glasses_2":3,"eye_squint":0,"chin_3":0,"sun_1":-1,"bproof_2":0,"eyebrows_2":10,"torso_2":5,"face_1":0,"bulletproof_2":0,"dad":0,"face_md_weight":40.0,"nose_6":0,"skin_md_weight":6,"nose_5":0,"nose_2":0,"tshirt_1":179,"bracelets_1":-1,"arms_2":0,"makeup_2":0,"hair_color_1":0,"pants_2":0,"chin_4":0,"ears_1":-1,"tshirt_2":5,"lipstick_4":0,"bodyb_3":-1,"beard_4":0,"ears_2":-1,"hair_1":10,"jaw_2":0,"hair_2":0,"nose_1":0,"mask_2":0,"blemishes_1":-1,"decals_2":0,"chin_1":0,"lipstick_3":0,"watches_2":0,"lip_thickness":0,"lipstick_2":0,"makeup_1":0,"blush_2":10,"hair_color_2":0,"face_3":5,"chest_1":-1,"bulletproof_1":79,"age_2":0,"blush_3":0,"beard_2":10,"torso_1":584,"helmet_2":0,"moles_1":0,"chain_1":227,"complexion_1":0,"complexion_2":1,"bodyb_4":0,"neck_thickness":0,"sun_2":10,"eyebrows_1":0,"helmet_1":226,"cheeks_3":0,"eyebrows_3":12}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":true,"name":"scope"},{"status":true,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 19, 'boss', 'Deputy Chief', 18000, '{"bulletproof_vest_1":79,"makeup_3":0,"cheeks_3":0.1,"hair_color_2":0,"eyebrows_6":0,"jaw_1":-0.1,"skin_md_weight":6,"lip_thickness":0,"jaw_2":-8.6,"chin_1":0,"pants_2":4,"nose_4":0,"tshirt_1":230,"eye_squint":0,"eyebrows_2":10,"torso_1":574,"nose_1":-4.2,"face_md_weight":50.0,"shoes_1":8,"nose_6":0,"nose_5":0,"chest_1":-1,"chest_2":10,"face":0,"chest_3":0,"bproof_2":2,"tshirt_2":0,"bodyb_1":-1,"moles_2":1,"decals_1":0,"blush_1":-1,"complexion_1":0,"eye_color":0,"beard_4":0,"nose_2":0,"bodyb_4":0,"chain_1":227,"lipstick_1":0,"ears_2":-1,"moles_1":0,"helmet_2":2,"sex":0,"ears_1":-1,"hair_1":10,"bracelets_1":-1,"lipstick_3":0,"eyebrows_5":0,"chin_3":0,"beard_3":0,"mask_1":169,"pants_1":130,"chin_2":0,"face_3":5,"bulletproof_vest_2":0,"arms":19,"beard_1":0,"blemishes_1":-1,"face_2":21,"blush_3":0,"bracelets_2":0,"age_2":0,"eyebrows_4":12,"bags_2":0,"makeup_4":0,"mask_2":13,"chin_4":0,"eyebrows_1":0,"watches_2":0,"bulletproof_2":0,"face_1":0,"dad":0,"makeup_2":0,"shoes_2":0,"eyebrows_3":12,"makeup_1":0,"age_1":0,"arms_2":0,"chain_2":2,"watches_1":4,"bodyb_2":0,"nose_3":0,"blush_2":10,"bodyb_3":-1,"glasses_1":8,"blemishes_2":10,"helmet_1":119,"sun_1":-1,"lipstick_4":0,"beard_2":10,"sun_2":10,"bags_1":0,"hair_color_1":0,"skin":12,"cheeks_1":-0.1,"lipstick_2":0,"complexion_2":1,"torso_2":14,"mom":21,"bproof_1":64,"decals_2":0,"bulletproof_1":79,"hair_2":0,"neck_thickness":-0.5,"glasses_2":0,"cheeks_2":-3.2}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"sunsetsp"},{"status":true,"model":"sunsetpv"},{"status":true,"model":"shacara"},{"status":true,"model":"polreb"},{"status":true,"model":"polneon"},{"status":true,"model":"polros"},{"status":true,"model":"polkmd"},{"status":true,"model":"polkch"},{"status":true,"model":"poljug"},{"status":true,"model":"vvpi"},{"status":true,"model":"pf"},{"status":true,"model":"pdbuff"},{"status":true,"model":"sunsetfbi"},{"status":true,"model":"polgt17"},{"status":true,"model":"lsfdpickup"},{"status":true,"model":"riot"},{"status":true,"model":"fchal"}]', NULL, '[{"model":"WEAPON_SMOKEGRENADE","status":true},{"model":"WEAPON_NIGHTSTICK","status":true},{"model":"WEAPON_STUNGUN","status":true},{"model":"WEAPON_FLASHLIGHT","status":true},{"model":"WEAPON_PISTOL","status":true},{"model":"WEAPON_COMBATPISTOL","status":true},{"model":"WEAPON_PISTOL50","status":true},{"model":"WEAPON_SMG","status":true},{"model":"WEAPON_ASSAULTRIFLE","status":true},{"model":"WEAPON_GUSENBERG","status":true},{"model":"WEAPON_SPECIALCARBINE","status":true},{"model":"WEAPON_CARBINERIFLE","status":true},{"model":"WEAPON_ASSAULTSMG","status":true},{"model":"WEAPON_BULLPUPRIFLE","status":true}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 20, 'boss', 'Assistant Chief', 19000, '{"ears_2":-1,"nose_5":0,"bulletproof_vest_1":79,"chest_3":0,"torso_2":2,"jaw_2":0,"ears_1":-1,"beard_3":0,"torso_1":605,"makeup_3":0,"complexion_2":1,"chin_3":0,"eye_squint":0,"makeup_4":0,"beard_1":0,"shoes_2":0,"lipstick_3":0,"mask_1":121,"eyebrows_6":0,"watches_2":1,"helmet_1":226,"eyebrows_2":10,"blush_2":10,"cheeks_2":0,"bodyb_1":-1,"dad":0,"bulletproof_2":0,"blush_1":-1,"tshirt_1":208,"bodyb_2":0,"bracelets_2":0,"chin_2":0,"lipstick_4":0,"bproof_1":64,"makeup_1":0,"face_1":0,"face_2":21,"hair_1":10,"bags_1":0,"moles_2":1,"beard_2":10,"face_md_weight":50.0,"chin_1":-5.5,"decals_1":0,"blemishes_1":-1,"eyebrows_1":0,"nose_3":0,"age_1":0,"shoes_1":35,"glasses_1":5,"sun_2":10,"mask_2":0,"cheeks_1":0,"hair_color_2":0,"sex":0,"mom":21,"face":0,"nose_4":0,"eyebrows_3":12,"lipstick_2":0,"skin_md_weight":0,"cheeks_3":-10,"chain_1":227,"jaw_1":0,"watches_1":4,"tshirt_2":0,"chin_4":0,"eye_color":0,"beard_4":0,"lip_thickness":0,"helmet_2":0,"chain_2":2,"age_2":0,"lipstick_1":0,"pants_2":1,"bodyb_3":-1,"eyebrows_4":12,"bproof_2":2,"blush_3":0,"bulletproof_vest_2":0,"nose_6":0,"decals_2":0,"arms_2":0,"arms":19,"chest_2":10,"bracelets_1":-1,"glasses_2":7,"skin":12,"face_3":5,"nose_1":0,"bags_2":0,"moles_1":0,"hair_color_1":0,"nose_2":0,"pants_1":130,"neck_thickness":-10,"eyebrows_5":0,"complexion_1":0,"makeup_2":0,"hair_2":0,"bulletproof_1":79,"bodyb_4":0,"sun_1":-1,"chest_1":-1,"blemishes_2":10}', '', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":true}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":false,"name":"chburger"},{"status":true,"name":"clip"},{"status":false,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":false,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":true,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 21, 'boss', 'Chief', 20000, '{"chest_1":-1,"bproof_1":64,"beard_1":0,"pants_1":4,"face_2":21,"hair_1":10,"cheeks_2":0,"decals_2":0,"glasses_1":8,"bodyb_3":-1,"tshirt_1":208,"makeup_2":0,"nose_5":0,"age_2":0,"pants_2":2,"bags_2":8,"lipstick_1":0,"hair_color_1":0,"bracelets_2":0,"cheeks_1":0,"blush_3":0,"sex":0,"helmet_2":0,"neck_thickness":-10,"torso_2":1,"face_3":5,"beard_4":0,"bulletproof_vest_2":0,"chain_1":227,"mask_1":121,"eyebrows_4":12,"lip_thickness":0,"face_1":0,"skin":12,"makeup_3":0,"cheeks_3":-10,"decals_1":0,"eyebrows_2":10,"age_1":0,"blemishes_1":-1,"bracelets_1":3,"eyebrows_1":0,"arms":26,"ears_1":-1,"bags_1":125,"arms_2":0,"chin_4":0,"bodyb_1":-1,"eyebrows_5":0,"mask_2":0,"sun_2":10,"eye_squint":0,"blush_2":10,"dad":0,"beard_2":10,"shoes_2":0,"makeup_1":0,"eyebrows_6":0,"nose_2":0,"moles_2":1,"helmet_1":-1,"chin_1":-5.5,"lipstick_3":0,"chin_3":0,"complexion_1":0,"tshirt_2":0,"moles_1":0,"bodyb_2":0,"lipstick_2":0,"beard_3":0,"shoes_1":35,"hair_color_2":0,"nose_1":0,"bulletproof_1":79,"chest_2":10,"chest_3":0,"watches_1":6,"hair_2":0,"chin_2":0,"mom":21,"watches_2":0,"chain_2":2,"nose_4":0,"skin_md_weight":0,"glasses_2":3,"face":0,"bulletproof_2":0,"nose_3":0,"face_md_weight":50.0,"bproof_2":2,"jaw_1":0,"nose_6":0,"blush_1":-1,"eyebrows_3":12,"bulletproof_vest_1":79,"ears_2":-1,"blemishes_2":10,"lipstick_4":0,"eye_color":0,"complexion_2":1,"jaw_2":0,"bodyb_4":0,"sun_1":-1,"makeup_4":0,"torso_1":95}', '', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":true}]', NULL, '[{"status":true,"model":"WEAPON_SMOKEGRENADE"},{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"status":true,"name":"blackmoney"},{"status":true,"name":"bread"},{"status":true,"name":"burger"},{"status":true,"name":"chburger"},{"status":true,"name":"clip"},{"status":true,"name":"cocacola"},{"status":false,"name":"eclip"},{"status":true,"name":"fanta"},{"status":true,"name":"grip"},{"status":true,"name":"radio"},{"status":false,"name":"scope"},{"status":false,"name":"scope"},{"status":true,"name":"silencer"},{"status":false,"name":"sprite"},{"status":true,"name":"water"},{"status":true,"name":"cburger"}]'),
	('sheriff', 22, 'boss', 'Commissioner', 20000, '{"bodyb_4":0,"helmet_2":0,"neck_thickness":-10,"moles_1":0,"blemishes_1":-1,"beard_1":0,"bodyb_2":0,"jaw_2":0,"makeup_2":0,"hair_color_1":0,"lipstick_1":0,"bulletproof_vest_1":79,"face_1":0,"bulletproof_2":0,"helmet_1":-1,"nose_3":0,"chain_1":227,"watches_2":0,"blush_2":10,"jaw_1":0,"cheeks_2":0,"decals_2":0,"bproof_1":0,"eyebrows_6":0,"chin_4":0,"nose_4":0,"face_3":5,"eyebrows_1":0,"beard_3":0,"sun_1":-1,"face":0,"bracelets_2":0,"cheeks_1":0,"mask_2":0,"arms_2":0,"hair_color_2":0,"chin_3":0,"bulletproof_vest_2":0,"moles_2":1,"blush_3":0,"eye_color":0,"makeup_3":0,"beard_2":10,"eyebrows_3":12,"mask_1":121,"bodyb_3":-1,"tshirt_2":0,"nose_6":0,"pants_1":4,"lipstick_3":0,"bags_1":0,"chin_1":0,"complexion_1":0,"nose_1":0,"sun_2":10,"torso_2":15,"dad":0,"bags_2":0,"chain_2":0,"complexion_2":1,"glasses_1":5,"eyebrows_4":12,"shoes_2":1,"chest_3":0,"bodyb_1":-1,"arms":52,"ears_1":-1,"face_2":21,"torso_1":574,"lipstick_4":0,"tshirt_1":230,"eyebrows_2":10,"beard_4":0,"nose_5":0,"bracelets_1":-1,"skin":12,"sex":0,"face_md_weight":50.0,"eye_squint":0,"makeup_4":0,"chest_2":10,"glasses_2":4,"makeup_1":0,"mom":21,"lip_thickness":0,"skin_md_weight":6,"bproof_2":0,"bulletproof_1":79,"eyebrows_5":0,"cheeks_3":0,"lipstick_2":0,"age_2":0,"age_1":0,"shoes_1":99,"pants_2":0,"chin_2":0,"blush_1":-1,"ears_2":-1,"decals_1":0,"nose_2":0,"hair_2":0,"watches_1":20,"hair_1":10,"chest_1":-1,"blemishes_2":10}', '{"face_2":21,"tshirt_2":0,"bodyb_2":0,"chin_1":0,"beard_2":0,"glasses_2":0,"chain_2":0,"skin":12,"nose_2":0,"sun_2":10,"age_2":0,"beard_3":0,"bulletproof_vest_2":0,"neck_thickness":0,"bproof_2":1,"moles_1":0,"makeup_4":0,"watches_1":-1,"bags_1":0,"torso_2":3,"blemishes_2":10,"lipstick_3":20,"face_3":6,"shoes_2":1,"helmet_2":0,"watches_2":0,"eyebrows_1":1,"ears_2":-1,"blush_1":-1,"chin_2":0,"complexion_2":1,"bulletproof_2":0,"chest_2":10,"sun_1":-1,"chest_1":-1,"helmet_1":-1,"bodyb_3":-1,"chin_3":0,"hair_2":0,"blemishes_1":-1,"nose_1":0,"chain_1":1,"cheeks_2":0,"torso_1":26,"complexion_1":0,"lipstick_1":3,"blush_2":10,"bulletproof_vest_1":79,"ears_1":-1,"bodyb_4":0,"nose_5":0,"decals_2":0,"bracelets_2":0,"nose_3":0,"lipstick_2":10,"face_1":0,"makeup_3":0,"sex":1,"nose_4":0,"eye_squint":0,"skin_md_weight":7,"tshirt_1":156,"jaw_1":0,"bulletproof_1":79,"moles_2":1,"arms_2":0,"lipstick_4":0,"cheeks_1":0,"face":0,"beard_4":0,"bproof_1":7,"makeup_1":5,"hair_color_2":0,"jaw_2":0,"hair_color_1":0,"bags_2":0,"age_1":0,"eyebrows_2":10,"beard_1":0,"mask_1":22,"pants_2":5,"mom":21,"decals_1":0,"pants_1":50,"blush_3":0,"lip_thickness":0,"face_md_weight":50,"chest_3":0,"mask_2":13,"makeup_2":10,"eye_color":0,"nose_6":0,"chin_4":0,"eyebrows_3":26,"cheeks_3":0,"bracelets_1":10,"eyebrows_6":0,"shoes_1":36,"glasses_1":11,"hair_1":30,"eyebrows_4":12,"eyebrows_5":0,"bodyb_1":-1,"arms":23,"dad":0}', '[{"model":"1200rt","status":true},{"model":"sunsetsp","status":true},{"model":"sunsetpv","status":true},{"model":"shacara","status":true},{"model":"polreb","status":true},{"model":"polneon","status":true},{"model":"polros","status":true},{"model":"polkmd","status":true},{"model":"polkch","status":true},{"model":"poljug","status":true},{"model":"vvpi","status":true},{"model":"pf","status":true},{"model":"pdbuff","status":true},{"model":"sunsetfbi","status":true},{"model":"polgt17","status":true},{"model":"lsfdpickup","status":true},{"model":"riot","status":true},{"model":"fchal","status":true}]', NULL, '[{"status":true,"model":"WEAPON_NIGHTSTICK"},{"status":true,"model":"WEAPON_STUNGUN"},{"status":true,"model":"WEAPON_FLASHLIGHT"},{"status":true,"model":"WEAPON_PISTOL"},{"status":true,"model":"WEAPON_COMBATPISTOL"},{"status":true,"model":"WEAPON_PISTOL50"},{"status":true,"model":"WEAPON_SMG"},{"status":true,"model":"WEAPON_ASSAULTRIFLE"},{"status":true,"model":"WEAPON_GUSENBERG"},{"status":true,"model":"WEAPON_SPECIALCARBINE"},{"status":true,"model":"WEAPON_CARBINERIFLE"},{"status":true,"model":"WEAPON_ASSAULTSMG"},{"status":true,"model":"WEAPON_BULLPUPRIFLE"}]', '[{"name":"blackmoney","status":true},{"name":"bread","status":true},{"name":"clip","status":true},{"name":"grip","status":true},{"name":"radio","status":true},{"name":"silencer","status":true},{"name":"water","status":true},{"name":"chburger","status":false},{"name":"fanta","status":false},{"name":"cocacola","status":true},{"name":"sprite","status":false},{"name":"burger","status":false},{"name":"scope","status":true}]'),
	('slaughterer', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('slice', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('slice', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('static', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('sundae', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('tailor', 0, 'employee', 'Karmand', 1500, '', '', '', NULL, '', ''),
	('taxi', 0, 'recrue', 'Rekrut', 12, '{"hair_2":0,"hair_color_2":0,"torso_1":32,"bags_1":0,"helmet_2":0,"chain_2":0,"eyebrows_3":0,"makeup_3":0,"makeup_2":0,"tshirt_1":31,"makeup_1":0,"bags_2":0,"makeup_4":0,"eyebrows_4":0,"chain_1":0,"lipstick_4":0,"bproof_2":0,"hair_color_1":0,"decals_2":0,"pants_2":0,"age_2":0,"glasses_2":0,"ears_2":0,"arms":27,"lipstick_1":0,"ears_1":-1,"mask_2":0,"sex":0,"lipstick_3":0,"helmet_1":-1,"shoes_2":0,"beard_2":0,"beard_1":0,"lipstick_2":0,"beard_4":0,"glasses_1":0,"bproof_1":0,"mask_1":0,"decals_1":1,"hair_1":0,"eyebrows_2":0,"beard_3":0,"age_1":0,"tshirt_2":0,"skin":0,"torso_2":0,"eyebrows_1":0,"face":0,"shoes_1":10,"pants_1":24}', '{"hair_2":0,"hair_color_2":0,"torso_1":57,"bags_1":0,"helmet_2":0,"chain_2":0,"eyebrows_3":0,"makeup_3":0,"makeup_2":0,"tshirt_1":38,"makeup_1":0,"bags_2":0,"makeup_4":0,"eyebrows_4":0,"chain_1":0,"lipstick_4":0,"bproof_2":0,"hair_color_1":0,"decals_2":0,"pants_2":1,"age_2":0,"glasses_2":0,"ears_2":0,"arms":21,"lipstick_1":0,"ears_1":-1,"mask_2":0,"sex":1,"lipstick_3":0,"helmet_1":-1,"shoes_2":0,"beard_2":0,"beard_1":0,"lipstick_2":0,"beard_4":0,"glasses_1":5,"bproof_1":0,"mask_1":0,"decals_1":1,"hair_1":0,"eyebrows_2":0,"beard_3":0,"age_1":0,"tshirt_2":0,"skin":0,"torso_2":0,"eyebrows_1":0,"face":0,"shoes_1":49,"pants_1":11}', NULL, NULL, NULL, NULL),
	('taxi', 1, 'recrue', 'Training Era', 3000, '{"bproof_1":0,"lipstick_2":0,"bodyb_1":-1,"chin_1":9.9,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"shoes_1":50,"blush_2":10,"glasses_2":0,"face_2":21,"face_3":5,"mask_2":0,"eyebrows_1":0,"chin_3":8.2,"lip_thickness":9.9,"torso_2":2,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"eyebrows_3":12,"bracelets_1":-1,"makeup_1":0,"mom":34,"nose_5":0.89999999999999,"dad":0,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":3.7,"eyebrows_2":10,"bags_1":0,"beard_3":0,"skin":12,"torso_1":113,"cheeks_3":-7.5,"cheeks_2":9.9,"age_2":0,"decals_1":0,"ears_1":-1,"eyebrows_4":12,"blemishes_1":-1,"nose_3":2.3,"tshirt_1":96,"helmet_2":0,"watches_1":-1,"chin_2":9.9,"bodyb_4":0,"nose_1":-5.6,"sun_1":-1,"pants_1":138,"arms":17,"chest_1":2,"bproof_2":0,"makeup_4":0,"makeup_2":0,"beard_4":0,"sun_2":10,"mask_1":0,"sex":0,"chin_4":1.5,"pants_2":1,"hair_color_2":0,"blush_1":-1,"blemishes_2":10,"beard_2":10,"helmet_1":-1,"nose_6":1.5,"face_md_weight":80.0,"glasses_1":0,"chest_3":0,"jaw_2":-4.3,"watches_2":0,"chest_2":10,"eye_color":0,"shoes_2":0,"nose_4":5.0,"neck_thickness":9.9,"lipstick_3":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":-7.19999999999999,"jaw_1":-10,"cheeks_1":4.69999999999999,"bodyb_2":0,"eyebrows_5":-2.4,"complexion_1":0,"hair_1":10,"decals_2":0,"skin_md_weight":0}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":false,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 2, 'novice', 'Amature', 4000, '{"bproof_1":0,"lipstick_2":0,"bodyb_1":-1,"chin_1":9.9,"moles_2":1,"age_1":0,"lipstick_4":0,"bags_2":0,"beard_1":0,"shoes_1":40,"blush_2":10,"glasses_2":0,"face_2":21,"face_3":5,"mask_2":2,"eyebrows_1":0,"chin_3":8.2,"lip_thickness":9.9,"torso_2":10,"eye_squint":0,"lipstick_1":0,"moles_1":0,"makeup_3":0,"hair_2":0,"face_1":0,"chain_1":0,"bodyb_3":-1,"chain_2":0,"hair_color_1":0,"tshirt_2":0,"eyebrows_3":12,"bracelets_1":-1,"makeup_1":0,"mom":34,"nose_5":0.89999999999999,"dad":7,"complexion_2":1,"arms_2":0,"ears_2":-1,"nose_2":3.7,"eyebrows_2":10,"bags_1":0,"beard_3":0,"skin":12,"torso_1":404,"cheeks_3":-7.5,"cheeks_2":9.9,"age_2":0,"decals_1":0,"ears_1":-1,"eyebrows_4":12,"blemishes_1":-1,"nose_3":2.3,"tshirt_1":15,"helmet_2":-1,"watches_1":-1,"chin_2":9.9,"bodyb_4":0,"nose_1":-5.6,"sun_1":-1,"pants_1":143,"arms":0,"chest_1":2,"bproof_2":0,"makeup_4":0,"makeup_2":0,"beard_4":0,"sun_2":10,"mask_1":0,"sex":0,"chin_4":1.5,"pants_2":3,"hair_color_2":0,"blush_1":-1,"blemishes_2":10,"beard_2":10,"helmet_1":-1,"nose_6":1.5,"face_md_weight":80.0,"glasses_1":0,"chest_3":0,"jaw_2":-4.3,"watches_2":-1,"chest_2":10,"eye_color":0,"shoes_2":0,"nose_4":5.0,"neck_thickness":9.9,"lipstick_3":0,"blush_3":0,"bracelets_2":0,"eyebrows_6":-7.19999999999999,"jaw_1":-10,"cheeks_1":4.69999999999999,"bodyb_2":0,"eyebrows_5":-2.4,"complexion_1":0,"hair_1":10,"decals_2":0,"skin_md_weight":0}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":false,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 3, 'experimente', 'Rookie', 5000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":false,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":false,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 4, 'uber', 'Amature Driver', 6000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":false,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 5, 'uber', 'Rookie Driver', 7000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 6, 'uber', 'Driver', 8000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":false,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 7, 'uber', 'Senior Driver', 9000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 8, 'uber', 'Elite Driver', 10000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 9, 'uber', 'Legendary Driver ', 11000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":false,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 10, 'uber', 'Master Driver', 12000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 11, 'uber', 'Taximan', 13000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 12, 'uber', 'Professional', 14000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":false,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 13, 'uber', 'Road Rage', 15000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 14, 'uber', 'Supervisor', 16000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 15, 'uber', 'Supervision I', 17000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 16, 'boss', 'Supervision II', 18000, '{}', '{}', '[{"status":false,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 17, 'boss', 'Manager', 19000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('taxi', 18, 'boss', 'Chief', 20000, '{}', '{}', '[{"status":true,"model":"1200rt"},{"status":true,"model":"motorpm"},{"status":true,"model":"poljug"},{"status":true,"model":"polkmd"},{"status":true,"model":"polreb"},{"status":true,"model":"polros"},{"status":false,"model":"polmav"},{"status":false,"model":"BUZZP"}]', NULL, '', '[]'),
	('turfco', 1, 'rank1', 'Referee', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('turfco', 2, 'rank2', 'Manager', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('turfco', 3, 'boss', 'Owner', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('unemployed', 0, 'unemployed', 'Unemployed', 200, NULL, NULL, NULL, NULL, NULL, NULL),
	('uwucafe', 0, 'rank0', 'Trainee', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('uwucafe', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('voltage', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 1, 'rank1', 'Rank1', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 2, 'rank2', 'Rank2', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 3, 'rank3', 'Rank3', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('wasabi', 4, 'boss', 'Rank4', 1, '{}', '{}', '[]', '[]', NULL, NULL),
	('weazel', 0, 'reporter', 'Reporter', 200, '{}', '{}', NULL, NULL, NULL, NULL),
	('weazel', 1, 'filmbardar', 'Trainee ', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 2, 'filmbardar', 'Weazel 1', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 3, 'filmbardar', 'Weazel 2', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 4, 'filmbardar', 'Weazel 3', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 5, 'filmbardar', 'Professional ', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 6, 'filmbardar', 'Master ', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 7, 'filmbardar', 'Manager ', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 8, 'filmbardar', 'Excutive Administrator ', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 9, 'moaven', 'Deptuy Chief', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 10, 'moaven', 'Assistant Chief', 0, '{}', '{}', '', NULL, '', ''),
	('weazel', 11, 'boss', 'Chief', 0, '{"moles_1":0,"nose_5":-0.2,"sex":0,"face":0,"lipstick_3":0,"eyebrows_2":10,"jaw_2":0,"face_md_weight":55.00000000000001,"chest_3":0,"bproof_1":0,"decals_1":0,"nose_1":3.5,"pants_2":1,"bags_1":0,"bulletproof_2":0,"nose_4":-2.1,"eye_squint":0,"moles_2":1,"lip_thickness":0,"arms_2":0,"bodyb_4":0,"bulletproof_1":79,"beard_4":0,"face_1":0,"arms":15,"lipstick_4":0,"age_1":0,"tshirt_1":15,"jaw_1":0,"cheeks_1":0.2,"glasses_2":-1,"bodyb_1":-1,"cheeks_2":0,"blush_3":0,"watches_1":-1,"eyebrows_1":0,"age_2":0,"eyebrows_4":12,"bulletproof_vest_1":79,"blush_1":-1,"hair_1":10,"beard_1":0,"eyebrows_5":1.1,"hair_color_2":0,"mask_2":2,"bracelets_2":0,"hair_color_1":0,"tshirt_2":0,"helmet_1":-1,"bproof_2":0,"helmet_2":-1,"torso_1":15,"makeup_2":0,"face_2":21,"decals_2":0,"makeup_1":0,"blemishes_1":-1,"eyebrows_3":12,"watches_2":-1,"chin_1":2.0,"bulletproof_vest_2":0,"hair_2":0,"makeup_4":0,"glasses_1":-1,"bodyb_3":-1,"lipstick_1":0,"beard_2":10,"ears_2":-1,"lipstick_2":0,"chain_1":0,"chin_4":0,"dad":0,"bodyb_2":0,"sun_2":10,"sun_1":-1,"torso_2":0,"pants_1":61,"complexion_1":0,"shoes_2":0,"blemishes_2":10,"complexion_2":1,"bracelets_1":-1,"beard_3":0,"shoes_1":34,"chest_2":10,"eye_color":0,"blush_2":10,"nose_3":3.1,"cheeks_3":0,"skin_md_weight":5,"face_3":5,"chin_3":1.3,"chin_2":0,"nose_2":-1.3,"nose_6":0,"neck_thickness":-10,"bags_2":0,"mom":21,"chest_1":-1,"ears_1":-1,"mask_1":0,"eyebrows_6":-10,"skin":12,"chain_2":0,"makeup_3":0}', '{}', '[{"model":"rumpo","status":true}]', NULL, '', '');

-- Dumping structure for table essentialmode.job_inventories
DROP TABLE IF EXISTS `job_inventories`;
CREATE TABLE IF NOT EXISTS `job_inventories` (
  `job_name` varchar(64) NOT NULL,
  `items` longtext NOT NULL DEFAULT '[]',
  `weapons` longtext NOT NULL DEFAULT '[]',
  `slots` int(11) NOT NULL DEFAULT 50,
  PRIMARY KEY (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.job_inventories: ~0 rows (approximately)

-- Dumping structure for table essentialmode.job_skill
DROP TABLE IF EXISTS `job_skill`;
CREATE TABLE IF NOT EXISTS `job_skill` (
  `identifier` varchar(60) NOT NULL,
  `job` varchar(50) NOT NULL,
  `minutes` int(11) NOT NULL DEFAULT 0,
  `milestones_paid` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`identifier`,`job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.job_skill: ~2 rows (approximately)
REPLACE INTO `job_skill` (`identifier`, `job`, `minutes`, `milestones_paid`) VALUES
	('steam:11000014bf543e0', 'ambulance', 15, ''),
	('steam:11000014bf543e0', 'police', 210, '');

-- Dumping structure for table essentialmode.jobs
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  `washmoney` int(11) NOT NULL DEFAULT 0,
  `handyservice` varchar(5) DEFAULT '0',
  `hasapp` tinyint(1) NOT NULL DEFAULT 0,
  `onlyboss` tinyint(1) NOT NULL DEFAULT 0,
  `icon_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.jobs: ~91 rows (approximately)
REPLACE INTO `jobs` (`name`, `label`, `whitelisted`, `washmoney`, `handyservice`, `hasapp`, `onlyboss`, `icon_url`) VALUES
	('ambulance', 'Ambulance', 1, 0, '0', 0, 0, NULL),
	('anchor', 'Restaurant Anchor', 0, 0, '0', 0, 0, NULL),
	('artesh', 'Artesh', 0, 0, '0', 0, 0, NULL),
	('blacktide', 'Blacktide Logistics', 0, 0, '0', 0, 0, NULL),
	('burgershot', 'Burgershot', 1, 0, '0', 0, 0, NULL),
	('cafe', 'Cafe', 1, 0, '0', 0, 0, NULL),
	('cardealer', 'Cardealer', 0, 0, '0', 0, 0, NULL),
	('carwash', 'Carwash Suds', 0, 0, '0', 0, 0, NULL),
	('cia', 'CIA', 1, 0, '0', 0, 0, NULL),
	('cid', 'CID', 1, 0, '0', 0, 0, NULL),
	('coffee', 'Coffee Shop', 0, 0, '0', 0, 0, NULL),
	('cratecarry', 'Crate & Carry Distribution', 0, 0, '0', 0, 0, NULL),
	('crimson', 'Restaurant Crimson', 0, 0, '0', 0, 0, NULL),
	('dadgostari', 'Dadgostari', 0, 0, '0', 0, 0, NULL),
	('doa', 'DOA', 1, 0, '0', 0, 0, NULL),
	('doc', 'Doctor', 0, 0, '0', 0, 0, NULL),
	('ember', 'Restaurant Ember', 0, 0, '0', 0, 0, NULL),
	('fbi', 'FBI', 1, 0, '0', 0, 0, NULL),
	('firebrick', 'Pizza Firebrick', 0, 0, '0', 0, 0, NULL),
	('fisherman', 'Mahi Gir', 0, 0, '0', 0, 0, NULL),
	('flourish', 'Bakery Flourish', 0, 0, '0', 0, 0, NULL),
	('food', 'Food Delivery', 0, 0, '0', 0, 0, NULL),
	('forces', 'Special Forces', 0, 0, '0', 0, 0, NULL),
	('frostbite', 'Bastani Frostbite', 0, 0, '0', 0, 0, NULL),
	('fueler', 'Sherekat Naft', 0, 0, '0', 0, 0, NULL),
	('goldcrust', 'Bakery GoldCrust', 0, 0, '0', 0, 0, NULL),
	('government', 'Government', 0, 0, '0', 0, 0, NULL),
	('judge', 'Judge', 1, 0, '0', 0, 0, NULL),
	('koi', 'Sushi Koi', 0, 0, '0', 0, 0, NULL),
	('lumberjack', 'Najar', 0, 0, '0', 0, 0, NULL),
	('marshal', 'Marshal', 1, 0, '0', 0, 0, NULL),
	('mechanic', 'Mechanic', 1, 0, '0', 0, 0, NULL),
	('meridian', 'Holding 1', 0, 0, '0', 0, 0, NULL),
	('miner', 'Madanchi', 0, 0, '0', 0, 0, NULL),
	('mt', 'Metropolitan', 0, 0, '0', 0, 0, NULL),
	('nightclub', 'Nightclub', 0, 0, '0', 0, 0, NULL),
	('nightjar', 'Bar Nightjar', 0, 0, '0', 0, 0, NULL),
	('nojob', 'Bikar', 0, 0, '0', 0, 0, NULL),
	('obsidian', 'Cafe Obsidian', 0, 0, '0', 0, 0, NULL),
	('offambulance', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offanchor', 'Off Duty - Restaurant Anchor', 1, 0, '0', 0, 0, NULL),
	('offblacktide', 'Off Duty - Blacktide Logistics', 1, 0, '0', 0, 0, NULL),
	('offcarwash', 'Off Duty - Carwash Suds', 1, 0, '0', 0, 0, NULL),
	('offcatcafe', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offcia', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offcid', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offcratecarry', 'Off Duty - Crate & Carry Distribution', 1, 0, '0', 0, 0, NULL),
	('offcrimson', 'Off Duty - Restaurant Crimson', 1, 0, '0', 0, 0, NULL),
	('offdoa', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offember', 'Off Duty - Restaurant Ember', 1, 0, '0', 0, 0, NULL),
	('offfbi', 'FBI (Off Duty)', 0, 0, '0', 0, 0, NULL),
	('offfirebrick', 'Off Duty - Pizza Firebrick', 1, 0, '0', 0, 0, NULL),
	('offflourish', 'Off Duty - Bakery Flourish', 1, 0, '0', 0, 0, NULL),
	('offfrostbite', 'Off Duty - Bastani Frostbite', 1, 0, '0', 0, 0, NULL),
	('offgoldcrust', 'Off Duty - Bakery GoldCrust', 1, 0, '0', 0, 0, NULL),
	('offjudge', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offkoi', 'Off Duty - Sushi Koi', 1, 0, '0', 0, 0, NULL),
	('offmarshal', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offmechanic', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offmeridian', 'Off Duty - Holding 1', 1, 0, '0', 0, 0, NULL),
	('offmt', 'Off Duty', 0, 0, '0', 0, 0, NULL),
	('offnightjar', 'Off Duty - Bar Nightjar', 1, 0, '0', 0, 0, NULL),
	('offobsidian', 'Off Duty - Cafe Obsidian', 1, 0, '0', 0, 0, NULL),
	('offpolice', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offsheriff', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offslice', 'Off Duty - Pizza Slice', 1, 0, '0', 0, 0, NULL),
	('offstatic', 'Off Duty - Bar Static', 1, 0, '0', 0, 0, NULL),
	('offsundae', 'Off Duty - Bastani Sundae', 1, 0, '0', 0, 0, NULL),
	('offtaxi', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('offturfco', 'Off Duty - Holding 2', 1, 0, '0', 0, 0, NULL),
	('offuwucafe', 'Off Duty - Cafe UwU', 1, 0, '0', 0, 0, NULL),
	('offvoltage', 'Off Duty - Cafe Voltage', 1, 0, '0', 0, 0, NULL),
	('offwasabi', 'Off Duty - Sushi Wasabi', 1, 0, '0', 0, 0, NULL),
	('offweazel', 'Off-Duty', 1, 0, '0', 0, 0, NULL),
	('police', 'Police', 1, 0, '0', 0, 0, NULL),
	('psuspend', 'Suspended', 0, 0, '0', 0, 0, NULL),
	('reporter', 'Journalisti', 0, 0, '0', 0, 0, NULL),
	('resturan', 'Resturan', 1, 0, '0', 0, 0, NULL),
	('sheriff', 'Sheriff', 1, 0, '0', 0, 0, NULL),
	('slaughterer', 'Qasab', 0, 0, '0', 0, 0, NULL),
	('slice', 'Pizza Slice', 0, 0, '0', 0, 0, NULL),
	('static', 'Bar Static', 0, 0, '0', 0, 0, NULL),
	('sundae', 'Bastani Sundae', 0, 0, '0', 0, 0, NULL),
	('tailor', 'Khayat', 0, 0, '0', 0, 0, NULL),
	('taxi', 'Taxi', 1, 0, '0', 0, 0, NULL),
	('turfco', 'Holding 2', 0, 0, '0', 0, 0, NULL),
	('unemployed', 'Unemployed', 0, 0, '0', 0, 0, NULL),
	('uwucafe', 'Cafe UwU', 0, 0, '0', 0, 0, NULL),
	('voltage', 'Cafe Voltage', 0, 0, '0', 0, 0, NULL),
	('wasabi', 'Sushi Wasabi', 0, 0, '0', 0, 0, NULL),
	('weazel', 'Weazel News', 1, 0, '0', 0, 0, NULL);

-- Dumping structure for table essentialmode.lapraces
DROP TABLE IF EXISTS `lapraces`;
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.lapraces: ~0 rows (approximately)

-- Dumping structure for table essentialmode.licenses
DROP TABLE IF EXISTS `licenses`;
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.licenses: ~4 rows (approximately)
REPLACE INTO `licenses` (`type`, `label`) VALUES
	('dmv', 'Code de la route'),
	('drive', 'Permis de conduire'),
	('drive_bike', 'Permis moto'),
	('drive_truck', 'Permis camion'),
	('weapon', 'Weapon License');

-- Dumping structure for table essentialmode.login_audit
DROP TABLE IF EXISTS `login_audit`;
CREATE TABLE IF NOT EXISTS `login_audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `license` varchar(128) DEFAULT NULL,
  `device_license` varchar(128) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `action` enum('login_success','login_fail','register','password_reset','new_device','logout_all','password_change','security_hold') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_login_audit_username` (`username`),
  KEY `idx_login_audit_device_license` (`device_license`),
  KEY `idx_login_audit_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.login_audit: ~0 rows (approximately)
REPLACE INTO `login_audit` (`id`, `username`, `license`, `device_license`, `ip`, `action`, `created_at`) VALUES
	(1, 'Arshia', 'steam:-pHaJ-kL0r-jNa7', 'license:153122398469261248', 'ip:172.20.10.3', 'register', '2026-08-22 21:30:14');

-- Dumping structure for table essentialmode.login_reset_throttle
DROP TABLE IF EXISTS `login_reset_throttle`;
CREATE TABLE IF NOT EXISTS `login_reset_throttle` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bucket_key` varchar(64) NOT NULL,
  `window_start` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_bucket_key` (`bucket_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.login_reset_throttle: ~0 rows (approximately)

-- Dumping structure for table essentialmode.login_users
DROP TABLE IF EXISTS `login_users`;
CREATE TABLE IF NOT EXISTS `login_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` char(64) NOT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `license` varchar(128) NOT NULL,
  `device_license` varchar(128) DEFAULT NULL,
  `security_hold` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_login_users_username` (`username`),
  UNIQUE KEY `uq_login_users_license` (`license`),
  KEY `idx_login_users_phone` (`phone`),
  KEY `idx_login_users_device_license` (`device_license`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.login_users: ~1 rows (approximately)
REPLACE INTO `login_users` (`id`, `username`, `password`, `phone`, `license`, `device_license`, `security_hold`, `created_at`) VALUES
	(1, 'Arshia', '9eb68160fb191cc45f205242590d735d11d6db95454df07dafdeaca2ec5dce06', '9058214586', 'steam:-pHaJ-kL0r-jNa7', 'license:153122398469261248', 0, '2026-08-22 21:30:14');

-- Dumping structure for table essentialmode.market
DROP TABLE IF EXISTS `market`;
CREATE TABLE IF NOT EXISTS `market` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `weight` float DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `owner` varchar(60) DEFAULT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.market: ~0 rows (approximately)

-- Dumping structure for table essentialmode.meridian_portfolio
DROP TABLE IF EXISTS `meridian_portfolio`;
CREATE TABLE IF NOT EXISTS `meridian_portfolio` (
  `business_job` varchar(50) NOT NULL,
  `kind` varchar(10) NOT NULL,
  `status` varchar(10) NOT NULL,
  `rank` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`business_job`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.meridian_portfolio: ~17 rows (approximately)
REPLACE INTO `meridian_portfolio` (`business_job`, `kind`, `status`, `rank`) VALUES
	('anchor', 'vip', 'partnered', NULL),
	('carwash', 'vip', 'partnered', NULL),
	('crimson', 'vip', 'partnered', NULL),
	('ember', 'vip', 'partnered', NULL),
	('firebrick', 'portfolio', 'acquired', 'bronze'),
	('flourish', 'portfolio', 'acquired', 'bronze'),
	('frostbite', 'portfolio', 'acquired', 'bronze'),
	('goldcrust', 'portfolio', 'acquired', 'bronze'),
	('koi', 'portfolio', 'acquired', 'bronze'),
	('nightjar', 'portfolio', 'acquired', 'bronze'),
	('obsidian', 'vip', 'partnered', NULL),
	('slice', 'portfolio', 'acquired', 'bronze'),
	('static', 'portfolio', 'acquired', 'bronze'),
	('sundae', 'portfolio', 'acquired', 'bronze'),
	('uwucafe', 'vip', 'partnered', NULL),
	('voltage', 'vip', 'partnered', NULL),
	('wasabi', 'portfolio', 'acquired', 'bronze');

-- Dumping structure for table essentialmode.owned_peds
DROP TABLE IF EXISTS `owned_peds`;
CREATE TABLE IF NOT EXISTS `owned_peds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `ped_model` varchar(60) DEFAULT NULL,
  `ped_expiry` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.owned_peds: ~2 rows (approximately)
REPLACE INTO `owned_peds` (`id`, `identifier`, `ped_model`, `ped_expiry`) VALUES
	(3, 'steam:11000014bf543e0', 'a_m_m_beach_01', '2026-08-31 17:38:40');

-- Dumping structure for table essentialmode.owned_pets
DROP TABLE IF EXISTS `owned_pets`;
CREATE TABLE IF NOT EXISTS `owned_pets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `pet_model` varchar(60) DEFAULT NULL,
  `pet_name` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.owned_pets: ~0 rows (approximately)
REPLACE INTO `owned_pets` (`id`, `identifier`, `pet_model`, `pet_name`) VALUES
	(1, 'steam:11000014bf543e0', 'a_c_chimp', '1');

-- Dumping structure for table essentialmode.owned_properties
DROP TABLE IF EXISTS `owned_properties`;
CREATE TABLE IF NOT EXISTS `owned_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `rented` tinyint(1) NOT NULL DEFAULT 0,
  `owner` varchar(60) DEFAULT NULL,
  `storage_data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.owned_properties: ~4 rows (approximately)
REPLACE INTO `owned_properties` (`id`, `name`, `price`, `rented`, `owner`, `storage_data`) VALUES
	(2, 'Aqua3Apartment', 1500000, 0, 'steam:11000014bf543e0', NULL),
	(3, 'NorthConkerAvenue2045', 1500000, 0, 'steam:11000014bf543e0', 'property'),
	(4, 'HillcrestAvenue2862', 1500000, 0, 'steam:11000014bf543e0', 'property');

-- Dumping structure for table essentialmode.owned_vehicles
DROP TABLE IF EXISTS `owned_vehicles`;
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(22) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 1,
  `WantedLevel` text DEFAULT 'standard',
  `Profile_Pic` text DEFAULT 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676',
  `engine` float DEFAULT 1000,
  `police` tinyint(1) NOT NULL DEFAULT 0,
  `parkmeter` int(11) NOT NULL DEFAULT 0,
  `parkmeternum` int(11) NOT NULL DEFAULT 0,
  `damage` longtext DEFAULT NULL,
  `garagenum` int(11) NOT NULL DEFAULT 1,
  `steamowned` varchar(60) DEFAULT NULL,
  `buyer` varchar(60) DEFAULT NULL,
  `fuel` float NOT NULL DEFAULT 100,
  `body` float NOT NULL DEFAULT 1000,
  `trunk` longtext DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.owned_vehicles: ~26 rows (approximately)
REPLACE INTO `owned_vehicles` (`owner`, `plate`, `vehicle`, `type`, `job`, `stored`, `WantedLevel`, `Profile_Pic`, `engine`, `police`, `parkmeter`, `parkmeternum`, `damage`, `garagenum`, `steamowned`, `buyer`, `fuel`, `body`, `trunk`, `glovebox`) VALUES
	('steam:11000014bf543e0', '1', '{"modArmor":-1,"modSpeakers":-1,"modTrimB":-1,"modSpoilers":-1,"tyreSmokeColor":[255,255,255],"windowTint":-1,"modVanityPlate":-1,"modAirFilter":-1,"modTrimA":-1,"wheelColor":0,"wheels":0,"model":-1848994066,"modDoorSpeaker":-1,"modTank":-1,"pearlescentColor":2,"modFrontWheels":-1,"modFrame":-1,"neonEnabled":[false,false,false,false],"IsPrimaryCustomColor":false,"plate":"1","modRoof":-1,"neonColor":[255,0,255],"modHood":-1,"modDial":-1,"modSmokeEnabled":false,"headlight":255,"modRightFender":-1,"modHydrolic":-1,"modShifterLeavers":-1,"modExhaust":-1,"modEngine":-1,"modHorns":-1,"plateIndex":0,"modFender":-1,"modRearBumper":-1,"modDashboard":-1,"modGrille":-1,"color2":1,"modBackWheels":-1,"modWindows":-1,"IsSecondaryCustomColor":false,"modTrunk":-1,"modOrnaments":-1,"modAPlate":-1,"modSuspension":-1,"modSeats":-1,"modLivery":-1,"modEngineBlock":-1,"modTurbo":false,"modStruts":-1,"SecondaryCustomColor":{"r":15,"g":15,"b":15},"modFrontBumper":-1,"modTransmission":-1,"modSideSkirt":-1,"color1":0,"modBrakes":-1,"fuel":64.98500061035156,"modAerials":-1,"modArchCover":-1,"livery":-1,"modPlateHolder":-1,"PrimaryCustomColor":{"r":8,"g":8,"b":8},"modSteeringWheel":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.985, 1000, NULL, NULL),
	('steam:11000014bf543e0', '123213', '{"modAerials":-1,"modDial":-1,"modHorns":-1,"modTransmission":-1,"modSteeringWheel":-1,"modSpoilers":-1,"modFrame":-1,"wheelColor":0,"modTrunk":-1,"modSeats":-1,"modAirFilter":-1,"modPlateHolder":-1,"modTank":-1,"IsPrimaryCustomColor":false,"modRearBumper":-1,"neonColor":[255,0,255],"modDoorSpeaker":-1,"plate":"123213","modRightFender":-1,"modWindows":-1,"modArmor":-1,"modGrille":-1,"SecondaryCustomColor":{"r":8,"g":8,"b":8},"modBrakes":-1,"modEngineBlock":-1,"modArchCover":-1,"modTrimB":-1,"color2":0,"modHydrolic":-1,"modDashboard":-1,"plateIndex":0,"modSideSkirt":-1,"model":-1848994066,"tyreSmokeColor":[255,255,255],"headlight":255,"modTrimA":-1,"modEngine":-1,"fuel":64.74500274658203,"IsSecondaryCustomColor":false,"modRoof":-1,"modHood":-1,"modOrnaments":-1,"modStruts":-1,"neonEnabled":[false,false,false,false],"windowTint":-1,"pearlescentColor":73,"modLivery":-1,"modTurbo":false,"modFender":-1,"modBackWheels":-1,"wheels":0,"modFrontBumper":-1,"modAPlate":-1,"color1":64,"modShifterLeavers":-1,"modExhaust":-1,"modSmokeEnabled":1,"modFrontWheels":-1,"PrimaryCustomColor":{"r":0,"g":27,"b":87},"modVanityPlate":-1,"modSuspension":-1,"livery":-1,"modSpeakers":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.745, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'A5T4N49S', '{"modExhaust":-1,"plateIndex":4,"modArmor":-1,"modSideSkirt":-1,"modTrimB":-1,"modAirFilter":-1,"fuel":64.86500549316406,"modAPlate":-1,"modGrille":-1,"modSteeringWheel":-1,"modTank":-1,"SecondaryCustomColor":{"b":8,"g":8,"r":8},"modArchCover":-1,"modTurbo":false,"windowTint":-1,"IsSecondaryCustomColor":false,"modVanityPlate":-1,"modFender":-1,"modFrame":-1,"neonColor":[255,0,255],"modRearBumper":-1,"modStruts":-1,"modDashboard":-1,"modHydrolic":-1,"modTransmission":-1,"modHood":-1,"headlight":255,"tyreSmokeColor":[255,255,255],"PrimaryCustomColor":{"b":255,"g":255,"r":255},"modPlateHolder":-1,"modOrnaments":-1,"plate":"A5T4N49S","modShifterLeavers":-1,"neonEnabled":[false,false,false,false],"modDial":-1,"modFrontWheels":-1,"modSeats":-1,"modBackWheels":-1,"modSuspension":-1,"model":-1627000575,"wheels":0,"color2":0,"modRoof":-1,"modLivery":-1,"modEngine":-1,"modWindows":-1,"modFrontBumper":-1,"modSpeakers":-1,"livery":2,"IsPrimaryCustomColor":false,"color1":134,"modBrakes":-1,"modEngineBlock":-1,"modDoorSpeaker":-1,"modTrimA":-1,"modRightFender":-1,"pearlescentColor":0,"modHorns":-1,"modSmokeEnabled":false,"modSpoilers":-1,"modAerials":-1,"wheelColor":156,"modTrunk":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.865, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'B0Z6S41Z', '{"modFrontWheels":-1,"modAirFilter":-1,"modHorns":-1,"modSpoilers":-1,"SecondaryCustomColor":{"r":15,"g":15,"b":15},"modDial":-1,"modRearBumper":-1,"neonColor":[255,0,255],"modFender":-1,"windowTint":-1,"modRoof":-1,"modHood":-1,"modRightFender":-1,"color1":0,"modPlateHolder":-1,"fuel":65.0,"modShifterLeavers":-1,"modLivery":-1,"plate":"B0Z6S41Z","color2":1,"modEngine":-1,"modExhaust":-1,"headlight":255,"modTurbo":false,"modBrakes":-1,"model":-1848994066,"modSeats":-1,"modGrille":-1,"modHydrolic":-1,"modSmokeEnabled":1,"modArmor":-1,"neonEnabled":[false,false,false,false],"modTrimB":-1,"modBackWheels":-1,"modTrunk":-1,"PrimaryCustomColor":{"r":8,"g":8,"b":8},"modSuspension":-1,"modAerials":-1,"modDoorSpeaker":-1,"tyreSmokeColor":[255,255,255],"plateIndex":0,"modAPlate":-1,"modVanityPlate":-1,"modEngineBlock":-1,"livery":-1,"modFrontBumper":-1,"pearlescentColor":2,"modFrame":-1,"IsSecondaryCustomColor":false,"modOrnaments":-1,"modSpeakers":-1,"modTrimA":-1,"modDashboard":-1,"modTank":-1,"IsPrimaryCustomColor":false,"modTransmission":-1,"modWindows":-1,"modStruts":-1,"modArchCover":-1,"modSideSkirt":-1,"wheels":0,"modSteeringWheel":-1,"wheelColor":0}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'C7V8G75Y', '{"modLivery":-1,"modArmor":-1,"modTransmission":-1,"plate":"C7V8G75Y","modDial":-1,"modEngine":-1,"modGrille":-1,"wheelColor":0,"modHorns":-1,"modRoof":-1,"modTrimA":-1,"pearlescentColor":73,"modDoorSpeaker":-1,"model":-1848994066,"modFender":-1,"modTrunk":-1,"modFrontBumper":-1,"tyreSmokeColor":[255,255,255],"modExhaust":-1,"modFrontWheels":-1,"modArchCover":-1,"modAPlate":-1,"IsSecondaryCustomColor":false,"SecondaryCustomColor":{"r":8,"g":8,"b":8},"modHydrolic":-1,"modVanityPlate":-1,"modSuspension":-1,"modEngineBlock":-1,"modStruts":-1,"wheels":0,"fuel":99.90000915527344,"modOrnaments":-1,"modDashboard":-1,"PrimaryCustomColor":{"r":0,"g":27,"b":87},"modSeats":-1,"modBrakes":-1,"headlight":255,"livery":-1,"modBackWheels":-1,"IsPrimaryCustomColor":false,"color1":64,"plateIndex":0,"modWindows":-1,"modHood":-1,"windowTint":-1,"modSpoilers":-1,"modShifterLeavers":-1,"modFrame":-1,"modAirFilter":-1,"modTank":-1,"modSteeringWheel":-1,"color2":0,"modPlateHolder":-1,"modAerials":-1,"neonColor":[255,0,255],"modSmokeEnabled":false,"modRearBumper":-1,"neonEnabled":[false,false,false,false],"modSideSkirt":-1,"modSpeakers":-1,"modTurbo":false,"modRightFender":-1,"modTrimB":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 99.9, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'E1T3P75W', '{"modShifterLeavers":-1,"modTurbo":false,"model":-1848994066,"modTrimB":-1,"tyreSmokeColor":[255,255,255],"modArchCover":-1,"modRightFender":-1,"fuel":64.98500061035156,"wheelColor":0,"modVanityPlate":-1,"color2":0,"modFender":-1,"modArmor":-1,"modSteeringWheel":-1,"modStruts":-1,"modFrontBumper":-1,"modSpeakers":-1,"modDial":-1,"modLivery":-1,"modHood":-1,"modHorns":-1,"PrimaryCustomColor":{"b":87,"g":27,"r":0},"livery":-1,"modBackWheels":-1,"modAerials":-1,"IsSecondaryCustomColor":false,"modPlateHolder":-1,"modAPlate":-1,"modFrontWheels":-1,"modRearBumper":-1,"plateIndex":0,"wheels":0,"modBrakes":-1,"modEngineBlock":-1,"windowTint":-1,"modDashboard":-1,"color1":64,"modGrille":-1,"IsPrimaryCustomColor":false,"modFrame":-1,"modTrunk":-1,"modRoof":-1,"modSmokeEnabled":false,"modSideSkirt":-1,"modExhaust":-1,"modTrimA":-1,"SecondaryCustomColor":{"b":8,"g":8,"r":8},"modSpoilers":-1,"modTransmission":-1,"plate":"E1T3P75W","modSuspension":-1,"neonEnabled":[false,false,false,false],"modTank":-1,"modSeats":-1,"modOrnaments":-1,"modEngine":-1,"modWindows":-1,"modHydrolic":-1,"headlight":255,"modAirFilter":-1,"pearlescentColor":73,"modDoorSpeaker":-1,"neonColor":[255,0,255]}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'H4V5T40P', '{"wheelColor":156,"modDial":-1,"modHood":-1,"modSuspension":-1,"modArmor":-1,"plate":"H4V5T40P","modArchCover":-1,"headlight":255,"modSmokeEnabled":false,"modSpeakers":-1,"modDoorSpeaker":-1,"modEngineBlock":-1,"modTank":-1,"modWindows":-1,"modRearBumper":-1,"modLivery":-1,"modExhaust":-1,"IsSecondaryCustomColor":false,"wheels":1,"IsPrimaryCustomColor":false,"pearlescentColor":0,"modVanityPlate":-1,"windowTint":-1,"color2":134,"modOrnaments":-1,"modTransmission":-1,"modEngine":-1,"modRoof":-1,"model":2046537925,"modTurbo":false,"modSpoilers":-1,"modBackWheels":-1,"SecondaryCustomColor":{"b":255,"r":255,"g":255},"modFrontBumper":-1,"modTrimB":-1,"modTrunk":-1,"modPlateHolder":-1,"plateIndex":4,"livery":0,"modSeats":-1,"neonColor":[255,0,255],"modRightFender":-1,"neonEnabled":[false,false,false,false],"modFender":-1,"modShifterLeavers":-1,"PrimaryCustomColor":{"b":255,"r":255,"g":255},"modSideSkirt":-1,"modFrame":-1,"modAPlate":-1,"modSteeringWheel":-1,"modAirFilter":-1,"modStruts":-1,"modTrimA":-1,"modHorns":-1,"modHydrolic":-1,"fuel":64.8949966430664,"modDashboard":-1,"modAerials":-1,"modBrakes":-1,"color1":134,"modGrille":-1,"tyreSmokeColor":[255,255,255],"modFrontWheels":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.895, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'J3X7Y74B', '{"modBrakes":-1,"modDashboard":-1,"modRightFender":-1,"pearlescentColor":73,"IsPrimaryCustomColor":false,"PrimaryCustomColor":{"r":0,"b":87,"g":27},"modSuspension":-1,"modExhaust":-1,"modFender":-1,"modLivery":-1,"headlight":255,"modTrunk":-1,"color1":64,"modSeats":-1,"modFrontWheels":-1,"modAerials":-1,"modRearBumper":-1,"modGrille":-1,"modAPlate":-1,"modTank":-1,"modFrontBumper":-1,"modSpoilers":-1,"modTransmission":-1,"modTurbo":false,"wheels":0,"livery":-1,"modVanityPlate":-1,"modSpeakers":-1,"plate":"J3X7Y74B","modTrimA":-1,"wheelColor":0,"modArmor":-1,"modHydrolic":-1,"tyreSmokeColor":[255,255,255],"modDoorSpeaker":-1,"neonColor":[255,0,255],"modBackWheels":-1,"model":-1848994066,"modWindows":-1,"modEngineBlock":-1,"modHorns":-1,"IsSecondaryCustomColor":false,"modHood":-1,"modShifterLeavers":-1,"modSmokeEnabled":false,"windowTint":-1,"plateIndex":0,"modTrimB":-1,"modStruts":-1,"modFrame":-1,"SecondaryCustomColor":{"r":8,"b":8,"g":8},"modOrnaments":-1,"fuel":99.97000122070313,"modAirFilter":-1,"modEngine":-1,"neonEnabled":[false,false,false,false],"color2":0,"modRoof":-1,"modSteeringWheel":-1,"modSideSkirt":-1,"modDial":-1,"modArchCover":-1,"modPlateHolder":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'J4E9P13G', '{"modStruts":-1,"modRearBumper":-1,"modSideSkirt":-1,"modDial":-1,"plate":"J4E9P13G","modHydrolic":-1,"modSpeakers":-1,"pearlescentColor":0,"livery":0,"modRightFender":-1,"modTrimA":-1,"modEngineBlock":-1,"modSpoilers":-1,"modVanityPlate":-1,"modWindows":-1,"modExhaust":-1,"modTank":-1,"headlight":255,"neonColor":[255,0,255],"modHood":-1,"color2":134,"modAPlate":-1,"modRoof":-1,"modSmokeEnabled":false,"wheelColor":156,"modBrakes":-1,"modTransmission":-1,"modGrille":-1,"color1":134,"modTurbo":false,"modAerials":-1,"wheels":1,"modTrimB":-1,"modBackWheels":-1,"modFrontWheels":-1,"plateIndex":4,"IsSecondaryCustomColor":false,"modOrnaments":-1,"modLivery":-1,"modDashboard":-1,"IsPrimaryCustomColor":false,"modArchCover":-1,"modFender":-1,"SecondaryCustomColor":{"g":255,"r":255,"b":255},"modDoorSpeaker":-1,"model":2046537925,"modShifterLeavers":-1,"modSteeringWheel":-1,"windowTint":-1,"modFrontBumper":-1,"fuel":65.0,"modHorns":-1,"modAirFilter":-1,"modEngine":-1,"PrimaryCustomColor":{"g":255,"r":255,"b":255},"modSeats":-1,"neonEnabled":[false,false,false,false],"modFrame":-1,"tyreSmokeColor":[255,255,255],"modSuspension":-1,"modArmor":-1,"modPlateHolder":-1,"modTrunk":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'J8V5K97B', '{"modDoorSpeaker":-1,"modTransmission":-1,"modRoof":-1,"modSuspension":-1,"modAPlate":-1,"IsSecondaryCustomColor":false,"modVanityPlate":-1,"modExhaust":-1,"neonEnabled":[false,false,false,false],"modWindows":-1,"modAirFilter":-1,"modTrunk":-1,"SecondaryCustomColor":{"b":8,"r":8,"g":8},"modSmokeEnabled":false,"plateIndex":0,"windowTint":-1,"PrimaryCustomColor":{"b":87,"r":0,"g":27},"livery":-1,"modStruts":-1,"plate":"J8V5K97B","neonColor":[255,0,255],"modHood":-1,"modBrakes":-1,"headlight":255,"modShifterLeavers":-1,"wheels":0,"modFrontWheels":-1,"modEngine":-1,"color2":0,"modHorns":-1,"modTurbo":false,"modDashboard":-1,"modGrille":-1,"modRightFender":-1,"modRearBumper":-1,"modSpoilers":-1,"model":-1848994066,"tyreSmokeColor":[255,255,255],"fuel":99.8600082397461,"modLivery":-1,"IsPrimaryCustomColor":false,"modBackWheels":-1,"modOrnaments":-1,"pearlescentColor":73,"modDial":-1,"modHydrolic":-1,"modSpeakers":-1,"modFrontBumper":-1,"modTank":-1,"color1":64,"modAerials":-1,"modSteeringWheel":-1,"modArmor":-1,"modSideSkirt":-1,"modTrimB":-1,"modFender":-1,"modSeats":-1,"modPlateHolder":-1,"modTrimA":-1,"modEngineBlock":-1,"wheelColor":0,"modFrame":-1,"modArchCover":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 99.86, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'L1Q3J72C', '{"wheels":6,"modWindows":-1,"modDial":-1,"modTurbo":false,"modDashboard":-1,"SecondaryCustomColor":{"g":94,"r":90,"b":102},"PrimaryCustomColor":{"g":8,"r":8,"b":8},"livery":-1,"pearlescentColor":5,"modPlateHolder":-1,"modTrunk":-1,"modRoof":-1,"modHorns":-1,"modSpoilers":-1,"neonEnabled":[false,false,false,false],"modVanityPlate":-1,"modRightFender":-1,"wheelColor":112,"modSmokeEnabled":false,"modBrakes":-1,"modArchCover":-1,"modEngineBlock":-1,"modShifterLeavers":-1,"modSeats":-1,"headlight":255,"modFrame":-1,"modFrontBumper":-1,"color2":4,"modGrille":-1,"model":86520421,"windowTint":-1,"modFender":-1,"modTrimA":-1,"fuel":99.86500549316406,"modSideSkirt":-1,"modArmor":-1,"IsSecondaryCustomColor":false,"modLivery":-1,"neonColor":[255,0,255],"modRearBumper":-1,"modEngine":-1,"modStruts":-1,"modHood":-1,"IsPrimaryCustomColor":false,"modSuspension":-1,"modTrimB":-1,"modFrontWheels":-1,"plate":"L1Q3J72C","plateIndex":0,"modSteeringWheel":-1,"tyreSmokeColor":[255,255,255],"modAirFilter":-1,"modBackWheels":-1,"modAPlate":-1,"modOrnaments":-1,"modSpeakers":-1,"modTank":-1,"modDoorSpeaker":-1,"modAerials":-1,"modTransmission":-1,"color1":0,"modExhaust":-1,"modHydrolic":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 99.865, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'L6V4W46D', '{"modBrakes":-1,"model":-1848994066,"modArchCover":-1,"SecondaryCustomColor":{"r":8,"g":8,"b":8},"modEngine":-1,"modWindows":-1,"modBackWheels":-1,"fuel":64.84000396728516,"modAirFilter":-1,"modArmor":-1,"modTransmission":-1,"modFrontBumper":-1,"neonColor":[255,0,255],"tyreSmokeColor":[255,255,255],"modFender":-1,"modEngineBlock":-1,"modSteeringWheel":-1,"modRearBumper":-1,"modFrame":-1,"modHood":-1,"modDial":-1,"headlight":255,"modSpeakers":-1,"modDoorSpeaker":-1,"modRoof":-1,"modAPlate":-1,"wheelColor":0,"PrimaryCustomColor":{"r":0,"g":27,"b":87},"modVanityPlate":-1,"modPlateHolder":-1,"modAerials":-1,"livery":-1,"modTrimB":-1,"modShifterLeavers":-1,"neonEnabled":[false,false,false,false],"color2":0,"wheels":0,"pearlescentColor":73,"modGrille":-1,"plate":"L6V4W46D","modRightFender":-1,"plateIndex":0,"modExhaust":-1,"modHydrolic":-1,"modTrimA":-1,"modTrunk":-1,"IsPrimaryCustomColor":false,"modSmokeEnabled":false,"modStruts":-1,"modSideSkirt":-1,"modLivery":-1,"modSpoilers":-1,"IsSecondaryCustomColor":false,"color1":64,"modTank":-1,"modHorns":-1,"modTurbo":false,"modDashboard":-1,"modOrnaments":-1,"modSeats":-1,"windowTint":-1,"modSuspension":-1,"modFrontWheels":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.84, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'mtz', '{"modWindows":-1,"modDial":-1,"modArmor":-1,"modBrakes":-1,"wheelColor":0,"windowTint":-1,"modSuspension":-1,"IsPrimaryCustomColor":false,"modStruts":-1,"modEngineBlock":-1,"modTank":-1,"neonColor":[255,0,255],"modShifterLeavers":-1,"tyreSmokeColor":[255,255,255],"modLivery":-1,"modArchCover":-1,"model":-1848994066,"modBackWheels":-1,"modTrimA":-1,"modSpoilers":-1,"modSeats":-1,"wheels":0,"modAirFilter":-1,"fuel":99.8699951171875,"modSteeringWheel":-1,"modRearBumper":-1,"modSmokeEnabled":false,"modFrame":-1,"modEngine":-1,"livery":-1,"color2":0,"modPlateHolder":-1,"modAPlate":-1,"plate":"MTZ","modHorns":-1,"modSpeakers":-1,"modTurbo":false,"modDashboard":-1,"modFender":-1,"modDoorSpeaker":-1,"pearlescentColor":73,"headlight":255,"modGrille":-1,"modExhaust":-1,"IsSecondaryCustomColor":false,"modOrnaments":-1,"modRightFender":-1,"modVanityPlate":-1,"modSideSkirt":-1,"modHydrolic":-1,"modRoof":-1,"modTrunk":-1,"plateIndex":0,"modAerials":-1,"modTrimB":-1,"SecondaryCustomColor":{"r":8,"b":8,"g":8},"modFrontWheels":-1,"neonEnabled":[false,false,false,false],"modTransmission":-1,"modHood":-1,"color1":64,"modFrontBumper":-1,"PrimaryCustomColor":{"r":0,"b":87,"g":27}}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 99.87, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'O5X7Y45C', '{"modSteeringWheel":-1,"modFrame":-1,"tyreSmokeColor":[255,255,255],"modSpoilers":-1,"modStruts":-1,"modDial":-1,"modGrille":-1,"modAPlate":-1,"modFender":-1,"windowTint":-1,"modAirFilter":-1,"modHood":-1,"IsPrimaryCustomColor":false,"plate":"O5X7Y45C","livery":-1,"modSpeakers":-1,"SecondaryCustomColor":{"b":15,"g":15,"r":15},"modLivery":-1,"IsSecondaryCustomColor":false,"color2":1,"modFrontBumper":-1,"neonColor":[255,0,255],"headlight":255,"modTurbo":false,"modBrakes":-1,"model":-1848994066,"modSeats":-1,"fuel":65.0,"modHydrolic":-1,"modSmokeEnabled":1,"wheels":0,"neonEnabled":[false,false,false,false],"modRoof":-1,"modTrimB":-1,"modTrunk":-1,"color1":0,"modPlateHolder":-1,"modAerials":-1,"modDoorSpeaker":-1,"modEngine":-1,"modArmor":-1,"modSuspension":-1,"modVanityPlate":-1,"modShifterLeavers":-1,"wheelColor":0,"modArchCover":-1,"PrimaryCustomColor":{"b":8,"g":8,"r":8},"modTrimA":-1,"modOrnaments":-1,"modRearBumper":-1,"modExhaust":-1,"modBackWheels":-1,"modDashboard":-1,"modFrontWheels":-1,"plateIndex":0,"modTransmission":-1,"modWindows":-1,"pearlescentColor":2,"modTank":-1,"modSideSkirt":-1,"modRightFender":-1,"modHorns":-1,"modEngineBlock":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'Q5E9O77Z', '{"modExhaust":-1,"plateIndex":0,"modArmor":-1,"modSideSkirt":-1,"modTrimB":-1,"modAirFilter":-1,"fuel":64.98500061035156,"modAPlate":-1,"modGrille":-1,"modSteeringWheel":-1,"modTank":-1,"SecondaryCustomColor":{"b":8,"g":8,"r":8},"modArchCover":-1,"modTurbo":false,"windowTint":-1,"IsSecondaryCustomColor":false,"modVanityPlate":-1,"modFender":-1,"modFrame":-1,"neonColor":[255,0,255],"modRearBumper":-1,"modStruts":-1,"modDashboard":-1,"modHydrolic":-1,"modTransmission":-1,"modHood":-1,"headlight":255,"tyreSmokeColor":[255,255,255],"PrimaryCustomColor":{"b":87,"g":27,"r":0},"modPlateHolder":-1,"modOrnaments":-1,"plate":"Q5E9O77Z","modShifterLeavers":-1,"neonEnabled":[false,false,false,false],"modDial":-1,"modFrontWheels":-1,"modSeats":-1,"modBackWheels":-1,"modSuspension":-1,"model":-1848994066,"wheels":0,"color2":0,"modRoof":-1,"modLivery":-1,"modEngine":-1,"modWindows":-1,"modFrontBumper":-1,"modSpeakers":-1,"livery":-1,"IsPrimaryCustomColor":false,"color1":64,"modBrakes":-1,"modEngineBlock":-1,"modDoorSpeaker":-1,"modTrimA":-1,"modRightFender":-1,"pearlescentColor":73,"modHorns":-1,"modSmokeEnabled":false,"modSpoilers":-1,"modAerials":-1,"wheelColor":0,"modTrunk":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.985, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'R3U0J33P', '{"modShifterLeavers":-1,"modRightFender":-1,"modOrnaments":-1,"color1":70,"color2":1,"modBrakes":-1,"IsSecondaryCustomColor":false,"neonEnabled":[false,false,false,false],"modTrimB":-1,"modAPlate":-1,"modHorns":-1,"modWindows":-1,"modHydrolic":-1,"modAirFilter":-1,"modSpoilers":-1,"modDial":-1,"modTransmission":-1,"windowTint":-1,"headlight":255,"modFrontWheels":-1,"modSeats":-1,"modDashboard":-1,"modPlateHolder":-1,"modHood":-1,"wheelColor":0,"modFender":-1,"modFrontBumper":-1,"SecondaryCustomColor":{"b":15,"g":15,"r":15},"modSteeringWheel":-1,"modTrunk":-1,"modEngine":-1,"PrimaryCustomColor":{"b":196,"g":85,"r":0},"fuel":99.94000244140625,"plateIndex":0,"modArchCover":-1,"modAerials":-1,"tyreSmokeColor":[255,255,255],"pearlescentColor":67,"modSpeakers":-1,"modExhaust":-1,"wheels":0,"model":-1848994066,"livery":-1,"modTank":-1,"modRearBumper":-1,"modVanityPlate":-1,"modLivery":-1,"IsPrimaryCustomColor":false,"modStruts":-1,"modBackWheels":-1,"modRoof":-1,"modSuspension":-1,"plate":"R3U0J33P","modSideSkirt":-1,"neonColor":[255,0,255],"modSmokeEnabled":false,"modTurbo":false,"modArmor":-1,"modEngineBlock":-1,"modTrimA":-1,"modDoorSpeaker":-1,"modGrille":-1,"modFrame":-1}', 'car', NULL, 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'sfasf', '{"modShifterLeavers":-1,"modTurbo":false,"model":-1848994066,"modTrimB":-1,"tyreSmokeColor":[255,255,255],"modArchCover":-1,"modRightFender":-1,"fuel":65.0,"wheelColor":0,"modVanityPlate":-1,"color2":0,"modFender":-1,"modArmor":-1,"modSteeringWheel":-1,"modStruts":-1,"modFrontBumper":-1,"modSpeakers":-1,"modDial":-1,"modLivery":-1,"modHood":-1,"modHorns":-1,"PrimaryCustomColor":{"b":87,"g":27,"r":0},"livery":-1,"modBackWheels":-1,"modAerials":-1,"IsSecondaryCustomColor":false,"modPlateHolder":-1,"modAPlate":-1,"modFrontWheels":-1,"modRearBumper":-1,"plateIndex":0,"wheels":0,"modBrakes":-1,"modEngineBlock":-1,"windowTint":-1,"modDashboard":-1,"color1":64,"modGrille":-1,"IsPrimaryCustomColor":false,"modFrame":-1,"modTrunk":-1,"modRoof":-1,"modSmokeEnabled":false,"modSideSkirt":-1,"modExhaust":-1,"modTrimA":-1,"SecondaryCustomColor":{"b":8,"g":8,"r":8},"modSpoilers":-1,"modTransmission":-1,"plate":"sfasf","modSuspension":-1,"neonEnabled":[false,false,false,false],"modTank":-1,"modSeats":-1,"modOrnaments":-1,"modEngine":-1,"modWindows":-1,"modHydrolic":-1,"headlight":255,"modAirFilter":-1,"pearlescentColor":73,"modDoorSpeaker":-1,"neonColor":[255,0,255]}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'T1B8V97N', '{"modEngine":-1,"modSpeakers":-1,"modAerials":-1,"modAirFilter":-1,"modFrontWheels":-1,"modExhaust":-1,"modTurbo":false,"modRearBumper":-1,"modHorns":-1,"modGrille":-1,"neonEnabled":[false,false,false,false],"modOrnaments":-1,"headlight":255,"wheelColor":156,"modSmokeEnabled":false,"modDoorSpeaker":-1,"modTrunk":-1,"IsSecondaryCustomColor":false,"SecondaryCustomColor":{"g":8,"b":8,"r":8},"modSuspension":-1,"modAPlate":-1,"windowTint":-1,"modDashboard":-1,"modSteeringWheel":-1,"neonColor":[255,0,255],"modSpoilers":-1,"color1":132,"modSeats":-1,"modEngineBlock":-1,"model":-1205689942,"modBrakes":-1,"modWindows":-1,"modBackWheels":-1,"pearlescentColor":0,"tyreSmokeColor":[255,255,255],"modRoof":-1,"modFender":-1,"modArmor":-1,"modTrimB":-1,"color2":0,"modHydrolic":-1,"modFrame":-1,"modRightFender":-1,"modDial":-1,"modTransmission":-1,"plate":"T1B8V97N","IsPrimaryCustomColor":false,"modTrimA":-1,"PrimaryCustomColor":{"g":240,"b":240,"r":240},"modVanityPlate":-1,"modSideSkirt":-1,"fuel":65.0,"modTank":-1,"modStruts":-1,"plateIndex":4,"livery":-1,"modPlateHolder":-1,"modFrontBumper":-1,"modArchCover":-1,"modShifterLeavers":-1,"modHood":-1,"wheels":0,"modLivery":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'V2G5M31P', '{"modArchCover":-1,"modRearBumper":-1,"modOrnaments":-1,"headlight":255,"modHood":-1,"modTransmission":-1,"modBrakes":-1,"modGrille":-1,"tyreSmokeColor":[255,255,255],"neonColor":[255,0,255],"modVanityPlate":-1,"IsSecondaryCustomColor":false,"color1":1,"pearlescentColor":3,"modEngine":-1,"color2":1,"modEngineBlock":-1,"modSmokeEnabled":false,"fuel":65.0,"modTurbo":false,"modFender":-1,"modShifterLeavers":-1,"modSeats":-1,"plate":"V2G5M31P","neonEnabled":[false,false,false,false],"modAPlate":-1,"modTank":-1,"modRightFender":-1,"modAerials":-1,"SecondaryCustomColor":{"g":15,"r":15,"b":15},"modStruts":-1,"modSuspension":-1,"modSpeakers":-1,"windowTint":-1,"plateIndex":4,"PrimaryCustomColor":{"g":15,"r":15,"b":15},"modBackWheels":-1,"modDashboard":-1,"modAirFilter":-1,"modTrimA":-1,"wheels":0,"modHydrolic":-1,"modWindows":-1,"modSideSkirt":-1,"livery":-1,"modDoorSpeaker":-1,"modTrimB":-1,"modRoof":-1,"modDial":-1,"modFrontWheels":-1,"model":1127131465,"modFrontBumper":-1,"modArmor":-1,"modHorns":-1,"modSpoilers":-1,"modPlateHolder":-1,"modExhaust":-1,"modSteeringWheel":-1,"modTrunk":-1,"IsPrimaryCustomColor":false,"modFrame":-1,"modLivery":-1,"wheelColor":156}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'V8P0I07C', '{"modShifterLeavers":-1,"plate":"V8P0I07C","pearlescentColor":0,"modArmor":-1,"modTurbo":false,"modRearBumper":-1,"modAPlate":-1,"livery":2,"IsSecondaryCustomColor":false,"modRoof":-1,"modHorns":-1,"tyreSmokeColor":[255,255,255],"modStruts":-1,"modSideSkirt":-1,"modTransmission":-1,"modFrontBumper":-1,"modLivery":-1,"model":-1627000575,"modDial":-1,"modTrimB":-1,"IsPrimaryCustomColor":false,"neonEnabled":[false,false,false,false],"modAirFilter":-1,"modSpeakers":-1,"modBrakes":-1,"modArchCover":-1,"modAerials":-1,"modEngine":-1,"modFrontWheels":-1,"neonColor":[255,0,255],"modWindows":-1,"modExhaust":-1,"modOrnaments":-1,"SecondaryCustomColor":{"g":8,"b":8,"r":8},"modVanityPlate":-1,"modHydrolic":-1,"color2":0,"headlight":255,"wheelColor":156,"modFender":-1,"modDashboard":-1,"fuel":65.0,"modSpoilers":-1,"modSuspension":-1,"modSmokeEnabled":false,"modTrimA":-1,"modGrille":-1,"modPlateHolder":-1,"modDoorSpeaker":-1,"windowTint":-1,"PrimaryCustomColor":{"g":255,"b":255,"r":255},"modTrunk":-1,"modSteeringWheel":-1,"plateIndex":4,"modHood":-1,"modSeats":-1,"modEngineBlock":-1,"modRightFender":-1,"color1":134,"modBackWheels":-1,"modFrame":-1,"wheels":0,"modTank":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'w', '{"modShifterLeavers":-1,"modTurbo":false,"model":-1848994066,"modTrimB":-1,"tyreSmokeColor":[255,255,255],"modArchCover":-1,"modRightFender":-1,"fuel":65.0,"wheelColor":0,"modVanityPlate":-1,"color2":0,"modFender":-1,"modArmor":-1,"modSteeringWheel":-1,"modStruts":-1,"modFrontBumper":-1,"modSpeakers":-1,"modDial":-1,"modLivery":-1,"modHood":-1,"modHorns":-1,"PrimaryCustomColor":{"b":87,"g":27,"r":0},"livery":-1,"modBackWheels":-1,"modAerials":-1,"IsSecondaryCustomColor":false,"modPlateHolder":-1,"modAPlate":-1,"modFrontWheels":-1,"modRearBumper":-1,"plateIndex":0,"wheels":0,"modBrakes":-1,"modEngineBlock":-1,"windowTint":-1,"modDashboard":-1,"color1":64,"modGrille":-1,"IsPrimaryCustomColor":false,"modFrame":-1,"modTrunk":-1,"modRoof":-1,"modSmokeEnabled":false,"modSideSkirt":-1,"modExhaust":-1,"modTrimA":-1,"SecondaryCustomColor":{"b":8,"g":8,"r":8},"modSpoilers":-1,"modTransmission":-1,"plate":"w","modSuspension":-1,"neonEnabled":[false,false,false,false],"modTank":-1,"modSeats":-1,"modOrnaments":-1,"modEngine":-1,"modWindows":-1,"modHydrolic":-1,"headlight":255,"modAirFilter":-1,"pearlescentColor":73,"modDoorSpeaker":-1,"neonColor":[255,0,255]}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'W1P3F37N', '{"modShifterLeavers":-1,"plate":"W1P3F37N","modSeats":-1,"modVanityPlate":-1,"modTurbo":false,"modGrille":-1,"modSteeringWheel":-1,"livery":-1,"modBackWheels":-1,"modRoof":-1,"modSpeakers":-1,"modEngineBlock":-1,"modStruts":-1,"modSideSkirt":-1,"modFrontWheels":-1,"SecondaryCustomColor":{"g":8,"b":8,"r":8},"modArchCover":-1,"model":-1848994066,"IsSecondaryCustomColor":false,"modTrimB":-1,"IsPrimaryCustomColor":false,"neonEnabled":[false,false,false,false],"modAirFilter":-1,"tyreSmokeColor":[255,255,255],"PrimaryCustomColor":{"g":27,"b":87,"r":0},"modDial":-1,"modArmor":-1,"modEngine":-1,"color2":0,"neonColor":[255,0,255],"fuel":65.0,"modTransmission":-1,"modOrnaments":-1,"modPlateHolder":-1,"modLivery":-1,"modHydrolic":-1,"modWindows":-1,"headlight":255,"wheelColor":0,"modFender":-1,"modDashboard":-1,"modFrame":-1,"modSpoilers":-1,"modSuspension":-1,"modSmokeEnabled":false,"modTrimA":-1,"modExhaust":-1,"modHorns":-1,"modDoorSpeaker":-1,"windowTint":-1,"modRearBumper":-1,"modTrunk":-1,"modBrakes":-1,"modFrontBumper":-1,"modHood":-1,"pearlescentColor":73,"modTank":-1,"modAPlate":-1,"color1":64,"plateIndex":0,"modRightFender":-1,"wheels":0,"modAerials":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'W8X4A87V', '{"modEngine":-1,"modSpeakers":-1,"modAerials":-1,"wheels":6,"modExhaust":-1,"modFrame":-1,"modTurbo":false,"modTransmission":-1,"modTrunk":-1,"modGrille":-1,"neonEnabled":[false,false,false,false],"modOrnaments":-1,"headlight":255,"modTrimB":-1,"modSpoilers":-1,"modDoorSpeaker":-1,"modFrontWheels":-1,"IsSecondaryCustomColor":false,"SecondaryCustomColor":{"g":94,"b":102,"r":90},"modSmokeEnabled":false,"modAPlate":-1,"windowTint":-1,"IsPrimaryCustomColor":false,"PrimaryCustomColor":{"g":8,"b":8,"r":8},"modRoof":-1,"modRearBumper":-1,"color1":0,"modSeats":-1,"modEngineBlock":-1,"model":86520421,"modBrakes":-1,"modDial":-1,"modBackWheels":-1,"pearlescentColor":5,"tyreSmokeColor":[255,255,255],"wheelColor":112,"modFender":-1,"modArmor":-1,"modSuspension":-1,"color2":4,"fuel":99.95500183105469,"modTrimA":-1,"plateIndex":0,"modArchCover":-1,"modDashboard":-1,"modVanityPlate":-1,"modSteeringWheel":-1,"modRightFender":-1,"modPlateHolder":-1,"modAirFilter":-1,"modSideSkirt":-1,"plate":"W8X4A87V","modTank":-1,"modStruts":-1,"modHydrolic":-1,"neonColor":[255,0,255],"modWindows":-1,"modFrontBumper":-1,"modHorns":-1,"modShifterLeavers":-1,"modHood":-1,"livery":-1,"modLivery":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 100, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'W9V2F07L', '{"modDoorSpeaker":-1,"modTransmission":-1,"modRoof":-1,"modSuspension":-1,"modAPlate":-1,"IsSecondaryCustomColor":false,"modVanityPlate":-1,"modExhaust":-1,"neonEnabled":[false,false,false,false],"modWindows":-1,"modAirFilter":-1,"modTrunk":-1,"SecondaryCustomColor":{"b":15,"r":15,"g":15},"modSmokeEnabled":false,"plateIndex":0,"windowTint":-1,"PrimaryCustomColor":{"b":196,"r":0,"g":85},"livery":-1,"modStruts":-1,"plate":"W9V2F07L","neonColor":[255,0,255],"modHood":-1,"modBrakes":-1,"headlight":255,"modShifterLeavers":-1,"wheels":0,"modFrontWheels":-1,"modEngine":-1,"color2":1,"modHorns":-1,"modTurbo":false,"modDashboard":-1,"modGrille":-1,"modRightFender":-1,"modRearBumper":-1,"modSpoilers":-1,"model":-1848994066,"tyreSmokeColor":[255,255,255],"fuel":99.8550033569336,"modLivery":-1,"IsPrimaryCustomColor":false,"modBackWheels":-1,"modOrnaments":-1,"pearlescentColor":67,"modDial":-1,"modHydrolic":-1,"modSpeakers":-1,"modFrontBumper":-1,"modTank":-1,"color1":70,"modAerials":-1,"modSteeringWheel":-1,"modArmor":-1,"modSideSkirt":-1,"modTrimB":-1,"modFender":-1,"modSeats":-1,"modPlateHolder":-1,"modTrimA":-1,"modEngineBlock":-1,"wheelColor":0,"modFrame":-1,"modArchCover":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 966, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 99.855, 994, NULL, NULL),
	('steam:11000014bf543e0', 'Y7Q1U87M', '{"modAirFilter":-1,"modRearBumper":-1,"modExhaust":-1,"modFrame":-1,"modSpoilers":-1,"modHorns":-1,"modFender":-1,"wheelColor":156,"modDial":-1,"modSmokeEnabled":false,"neonColor":[255,0,255],"modArchCover":-1,"modTurbo":false,"pearlescentColor":0,"modEngine":-1,"modTrunk":-1,"modSuspension":-1,"modSteeringWheel":-1,"modWindows":-1,"modTransmission":-1,"modShifterLeavers":-1,"tyreSmokeColor":[255,255,255],"modBackWheels":-1,"IsSecondaryCustomColor":false,"modFrontBumper":-1,"plateIndex":4,"SecondaryCustomColor":{"r":8,"b":8,"g":8},"IsPrimaryCustomColor":false,"color2":0,"modStruts":-1,"modSeats":-1,"modFrontWheels":-1,"modGrille":-1,"modPlateHolder":-1,"wheels":0,"modArmor":-1,"modHood":-1,"modTank":-1,"modDashboard":-1,"PrimaryCustomColor":{"r":240,"b":240,"g":240},"neonEnabled":[false,false,false,false],"modVanityPlate":-1,"fuel":64.8699951171875,"modSideSkirt":-1,"modEngineBlock":-1,"modBrakes":-1,"modAerials":-1,"modHydrolic":-1,"modAPlate":-1,"headlight":255,"modTrimB":-1,"modLivery":-1,"model":-1205689942,"livery":-1,"color1":132,"windowTint":-1,"plate":"Y7Q1U87M","modDoorSpeaker":-1,"modOrnaments":-1,"modRightFender":-1,"modSpeakers":-1,"modRoof":-1,"modTrimA":-1}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.87, 1000, NULL, NULL),
	('steam:11000014bf543e0', 'Y9K0Q95Y', '{"modTrunk":-1,"modSuspension":-1,"modAirFilter":-1,"modTransmission":-1,"modHood":-1,"modRoof":-1,"modSeats":-1,"plateIndex":4,"modVanityPlate":-1,"modSideSkirt":-1,"modHorns":-1,"modTrimB":-1,"pearlescentColor":3,"color1":1,"modDial":-1,"modBrakes":-1,"headlight":255,"modRearBumper":-1,"modBackWheels":-1,"model":1127131465,"modArmor":-1,"modAPlate":-1,"modStruts":-1,"tyreSmokeColor":[255,255,255],"modArchCover":-1,"modAerials":-1,"neonColor":[255,0,255],"livery":-1,"modTrimA":-1,"plate":"Y9K0Q95Y","PrimaryCustomColor":{"b":15,"g":15,"r":15},"fuel":64.82999420166016,"modPlateHolder":-1,"modHydrolic":-1,"modSpeakers":-1,"modFender":-1,"wheelColor":156,"color2":1,"modOrnaments":-1,"modDashboard":-1,"modDoorSpeaker":-1,"modFrontWheels":-1,"modTank":-1,"modGrille":-1,"modEngineBlock":-1,"modExhaust":-1,"modFrame":-1,"modRightFender":-1,"windowTint":-1,"modSpoilers":-1,"IsPrimaryCustomColor":false,"IsSecondaryCustomColor":false,"modSmokeEnabled":false,"modSteeringWheel":-1,"modLivery":-1,"modFrontBumper":-1,"modShifterLeavers":-1,"modTurbo":false,"neonEnabled":[false,false,false,false],"modWindows":-1,"wheels":0,"modEngine":-1,"SecondaryCustomColor":{"b":15,"g":15,"r":15}}', 'car', '', 1, 'standard', 'https://media.discordapp.net/attachments/813604209462214676/858319794900959232/unknown.png?width=1201&height=676', 1000, 0, 0, 0, NULL, 1, 'steam:11000014bf543e0', NULL, 64.83, 1000, NULL, NULL);

-- Dumping structure for table essentialmode.ox_inventory
DROP TABLE IF EXISTS `ox_inventory`;
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.ox_inventory: ~2 rows (approximately)
REPLACE INTO `ox_inventory` (`owner`, `name`, `data`, `lastupdated`) VALUES
	('0', 'gang_a', '[{"name":"blowtorch","count":1,"slot":1}]', '2026-08-24 13:59:14'),
	('steam:11000014bf543e0', 'property_steam:11000014bf543e0', '[]', '2026-08-24 13:59:14'),
	('', 'gang_a', NULL, '2026-08-26 07:25:00');

-- Dumping structure for table essentialmode.paintball_job_access
DROP TABLE IF EXISTS `paintball_job_access`;
CREATE TABLE IF NOT EXISTS `paintball_job_access` (
  `job_name` varchar(50) NOT NULL,
  `min_grade` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.paintball_job_access: ~0 rows (approximately)
REPLACE INTO `paintball_job_access` (`job_name`, `min_grade`) VALUES
	('police', 1);

-- Dumping structure for table essentialmode.phone_gallery
DROP TABLE IF EXISTS `phone_gallery`;
CREATE TABLE IF NOT EXISTS `phone_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `image_url` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.phone_gallery: ~0 rows (approximately)

-- Dumping structure for table essentialmode.phone_messages
DROP TABLE IF EXISTS `phone_messages`;
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `number` (`number`)
) ENGINE=InnoDB AUTO_INCREMENT=6732 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.phone_messages: ~0 rows (approximately)

-- Dumping structure for table essentialmode.player_clothe_packs
DROP TABLE IF EXISTS `player_clothe_packs`;
CREATE TABLE IF NOT EXISTS `player_clothe_packs` (
  `pack_id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(64) NOT NULL,
  `label` varchar(64) NOT NULL,
  `contents` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`pack_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.player_clothe_packs: ~0 rows (approximately)

-- Dumping structure for table essentialmode.player_contacts
DROP TABLE IF EXISTS `player_contacts`;
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=12433 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.player_contacts: ~0 rows (approximately)

-- Dumping structure for table essentialmode.player_mails
DROP TABLE IF EXISTS `player_mails`;
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=67023 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.player_mails: ~0 rows (approximately)

-- Dumping structure for table essentialmode.player_worn_clothes
DROP TABLE IF EXISTS `player_worn_clothes`;
CREATE TABLE IF NOT EXISTS `player_worn_clothes` (
  `identifier` varchar(64) NOT NULL,
  `worn` longtext NOT NULL DEFAULT '{}',
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.player_worn_clothes: ~0 rows (approximately)
REPLACE INTO `player_worn_clothes` (`identifier`, `worn`) VALUES
	('steam:11000014bf543e0', '{}');

-- Dumping structure for table essentialmode.police_ext
DROP TABLE IF EXISTS `police_ext`;
CREATE TABLE IF NOT EXISTS `police_ext` (
  `identifier` varchar(60) NOT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.police_ext: ~0 rows (approximately)

-- Dumping structure for table essentialmode.properties
DROP TABLE IF EXISTS `properties`;
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) DEFAULT NULL,
  `room_menu` varchar(255) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `storage_data` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.properties: ~42 rows (approximately)
REPLACE INTO `properties` (`id`, `name`, `label`, `entering`, `exit`, `inside`, `outside`, `ipls`, `gateway`, `is_single`, `is_room`, `is_gateway`, `room_menu`, `price`, `storage_data`) VALUES
	(1, 'WhispymoundDrive', '2677 Whispymound Drive', '{"y":564.89,"z":182.959,"x":119.384}', '{"x":117.347,"y":559.506,"z":183.304}', '{"y":557.032,"z":183.301,"x":118.037}', '{"y":567.798,"z":182.131,"x":119.249}', '[]', NULL, 1, 1, 0, '{"x":118.748,"y":566.573,"z":175.697}', 1500000, 'property'),
	(2, 'NorthConkerAvenue2045', '2045 North Conker Avenue', '{"x":372.796,"y":428.327,"z":144.685}', '{"x":373.548,"y":422.982,"z":144.907}', '{"y":420.075,"z":145.904,"x":372.161}', '{"x":372.454,"y":432.886,"z":143.443}', '[]', NULL, 1, 1, 0, '{"x":377.349,"y":429.422,"z":137.3}', 1500000, 'property'),
	(3, 'RichardMajesticApt2', 'Richard Majestic, Apt 2', '{"y":-379.165,"z":37.961,"x":-936.363}', '{"y":-365.476,"z":113.274,"x":-913.097}', '{"y":-367.637,"z":113.274,"x":-918.022}', '{"y":-382.023,"z":37.961,"x":-943.626}', '[]', NULL, 1, 1, 0, '{"x":-927.554,"y":-377.744,"z":112.674}', 1700000, 'property'),
	(4, 'NorthConkerAvenue2044', '2044 North Conker Avenue', '{"y":440.8,"z":146.702,"x":346.964}', '{"y":437.456,"z":148.394,"x":341.683}', '{"y":435.626,"z":148.394,"x":339.595}', '{"x":350.535,"y":443.329,"z":145.764}', '[]', NULL, 1, 1, 0, '{"x":337.726,"y":436.985,"z":140.77}', 1500000, 'property'),
	(5, 'WildOatsDrive', '3655 Wild Oats Drive', '{"y":502.696,"z":136.421,"x":-176.003}', '{"y":497.817,"z":136.653,"x":-174.349}', '{"y":495.069,"z":136.666,"x":-173.331}', '{"y":506.412,"z":135.0664,"x":-177.927}', '[]', NULL, 1, 1, 0, '{"x":-174.725,"y":493.095,"z":129.043}', 1500000, 'property'),
	(6, 'HillcrestAvenue2862', '2862 Hillcrest Avenue', '{"y":596.58,"z":142.641,"x":-686.554}', '{"y":591.988,"z":144.392,"x":-681.728}', '{"y":590.608,"z":144.392,"x":-680.124}', '{"y":599.019,"z":142.059,"x":-689.492}', '[]', NULL, 1, 1, 0, '{"x":-680.46,"y":588.6,"z":136.769}', 1500000, 'property'),
	(7, 'LowEndApartment', 'Appartement de base', '{"y":-1078.735,"z":28.4031,"x":292.528}', '{"y":-1007.152,"z":-102.002,"x":265.845}', '{"y":-1002.802,"z":-100.008,"x":265.307}', '{"y":-1078.669,"z":28.401,"x":296.738}', '[]', NULL, 1, 1, 0, '{"x":265.916,"y":-999.38,"z":-100.008}', 1500000, 'property'),
	(8, 'MadWayneThunder', '2113 Mad Wayne Thunder', '{"y":454.955,"z":96.462,"x":-1294.433}', '{"x":-1289.917,"y":449.541,"z":96.902}', '{"y":446.322,"z":96.899,"x":-1289.642}', '{"y":455.453,"z":96.517,"x":-1298.851}', '[]', NULL, 1, 1, 0, '{"x":-1287.306,"y":455.901,"z":89.294}', 1500000, 'property'),
	(9, 'HillcrestAvenue2874', '2874 Hillcrest Avenue', '{"x":-853.346,"y":696.678,"z":147.782}', '{"y":690.875,"z":151.86,"x":-859.961}', '{"y":688.361,"z":151.857,"x":-859.395}', '{"y":701.628,"z":147.773,"x":-855.007}', '[]', NULL, 1, 1, 0, '{"x":-858.543,"y":697.514,"z":144.253}', 1500000, 'property'),
	(10, 'HillcrestAvenue2868', '2868 Hillcrest Avenue', '{"y":620.494,"z":141.588,"x":-752.82}', '{"y":618.62,"z":143.153,"x":-759.317}', '{"y":617.629,"z":143.153,"x":-760.789}', '{"y":621.281,"z":141.254,"x":-750.919}', '[]', NULL, 1, 1, 0, '{"x":-762.504,"y":618.992,"z":135.53}', 1500000, 'property'),
	(11, 'TinselTowersApt12', 'Tinsel Towers, Apt 42', '{"y":37.025,"z":42.58,"x":-618.299}', '{"y":58.898,"z":97.2,"x":-603.301}', '{"y":58.941,"z":97.2,"x":-608.741}', '{"y":30.603,"z":42.524,"x":-620.017}', '[]', NULL, 1, 1, 0, '{"x":-622.173,"y":54.585,"z":96.599}', 1700000, 'property'),
	(12, 'MiltonDrive', 'Milton Drive', '{"x":-775.17,"y":312.01,"z":84.658}', NULL, NULL, '{"x":-775.346,"y":306.776,"z":84.7}', '[]', NULL, 0, 0, 1, NULL, 0, 'property'),
	(13, 'Modern1Apartment', 'Appartement Moderne 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_01_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.661,"y":327.672,"z":210.396}', 1500000, 'property'),
	(14, 'Modern2Apartment', 'Appartement Moderne 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_01_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.735,"y":326.757,"z":186.313}', 1500000, 'property'),
	(15, 'Modern3Apartment', 'Appartement Moderne 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_01_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.386,"y":330.782,"z":195.08}', 1500000, 'property'),
	(16, 'Mody1Apartment', 'Appartement Mode 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_02_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.615,"y":327.878,"z":210.396}', 1500000, 'property'),
	(17, 'Mody2Apartment', 'Appartement Mode 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_02_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.297,"y":327.092,"z":186.313}', 1500000, 'property'),
	(18, 'Mody3Apartment', 'Appartement Mode 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_02_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.303,"y":330.932,"z":195.085}', 1500000, 'property'),
	(19, 'Vibrant1Apartment', 'Appartement Vibrant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_03_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.885,"y":327.641,"z":210.396}', 1500000, 'property'),
	(20, 'Vibrant2Apartment', 'Appartement Vibrant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_03_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.607,"y":327.344,"z":186.313}', 1500000, 'property'),
	(21, 'Vibrant3Apartment', 'Appartement Vibrant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_03_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.525,"y":330.851,"z":195.085}', 1500000, 'property'),
	(22, 'Sharp1Apartment', 'Appartement Persan 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_04_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.527,"y":327.89,"z":210.396}', 1500000, 'property'),
	(23, 'Sharp2Apartment', 'Appartement Persan 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_04_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.642,"y":326.497,"z":186.313}', 1500000, 'property'),
	(24, 'Sharp3Apartment', 'Appartement Persan 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_04_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.503,"y":331.318,"z":195.085}', 1500000, 'property'),
	(25, 'Monochrome1Apartment', 'Appartement Monochrome 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_05_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.289,"y":328.086,"z":210.396}', 1500000, 'property'),
	(26, 'Monochrome2Apartment', 'Appartement Monochrome 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_05_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.692,"y":326.762,"z":186.313}', 1500000, 'property'),
	(27, 'Monochrome3Apartment', 'Appartement Monochrome 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_05_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.094,"y":330.976,"z":195.085}', 1500000, 'property'),
	(28, 'Seductive1Apartment', 'Appartement Séduisant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_06_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.263,"y":328.104,"z":210.396}', 1500000, 'property'),
	(29, 'Seductive2Apartment', 'Appartement Séduisant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_06_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.655,"y":326.611,"z":186.313}', 1500000, 'property'),
	(30, 'Seductive3Apartment', 'Appartement Séduisant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_06_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.3,"y":331.414,"z":195.085}', 1500000, 'property'),
	(31, 'Regal1Apartment', 'Appartement Royal 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_07_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.956,"y":328.257,"z":210.396}', 1500000, 'property'),
	(32, 'Regal2Apartment', 'Appartement Royal 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_07_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.545,"y":326.659,"z":186.313}', 1500000, 'property'),
	(33, 'Regal3Apartment', 'Appartement Royal 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_07_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.087,"y":331.429,"z":195.123}', 1500000, 'property'),
	(34, 'Aqua1Apartment', 'Appartement Aqua 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_08_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.187,"y":328.47,"z":210.396}', 1500000, 'property'),
	(35, 'Aqua2Apartment', 'Appartement Aqua 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_08_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.658,"y":326.563,"z":186.313}', 1500000, 'property'),
	(36, 'Aqua3Apartment', 'Appartement Aqua 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_08_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.287,"y":331.084,"z":195.086}', 1500000, 'property'),
	(37, 'IntegrityWay', '4 Integrity Way', '{"x":-47.804,"y":-585.867,"z":36.956}', NULL, NULL, '{"x":-54.178,"y":-583.762,"z":35.798}', '[]', NULL, 0, 0, 1, NULL, 0, 'property'),
	(38, 'IntegrityWay28', '4 Integrity Way - Apt 28', NULL, '{"x":-31.409,"y":-594.927,"z":79.03}', '{"x":-26.098,"y":-596.909,"z":79.03}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-11.923,"y":-597.083,"z":78.43}', 1700000, 'property'),
	(39, 'IntegrityWay30', '4 Integrity Way - Apt 30', NULL, '{"x":-17.702,"y":-588.524,"z":89.114}', '{"x":-16.21,"y":-582.569,"z":89.114}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-26.327,"y":-588.384,"z":89.123}', 1700000, 'property'),
	(40, 'DellPerroHeights', 'Dell Perro Heights', '{"x":-1447.06,"y":-538.28,"z":33.74}', NULL, NULL, '{"x":-1440.022,"y":-548.696,"z":33.74}', '[]', NULL, 0, 0, 1, NULL, 0, 'property'),
	(41, 'DellPerroHeightst4', 'Dell Perro Heights - Apt 28', NULL, '{"x":-1452.125,"y":-540.591,"z":73.044}', '{"x":-1455.435,"y":-535.79,"z":73.044}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1467.058,"y":-527.571,"z":72.443}', 1700000, 'property'),
	(42, 'DellPerroHeightst7', 'Dell Perro Heights - Apt 30', NULL, '{"x":-1451.562,"y":-523.535,"z":55.928}', '{"x":-1456.02,"y":-519.209,"z":55.929}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1457.026,"y":-530.219,"z":55.937}', 1700000, 'property');

-- Dumping structure for table essentialmode.public_inventories
DROP TABLE IF EXISTS `public_inventories`;
CREATE TABLE IF NOT EXISTS `public_inventories` (
  `name` varchar(64) NOT NULL,
  `items` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.public_inventories: ~0 rows (approximately)

-- Dumping structure for table essentialmode.quest
DROP TABLE IF EXISTS `quest`;
CREATE TABLE IF NOT EXISTS `quest` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `daily_data` longtext CHARACTER SET utf8 COLLATE utf8_bin DEFAULT 'None',
  `weekly_data` longtext CHARACTER SET utf8 COLLATE utf8_bin DEFAULT 'None',
  `bigtime_data` longtext CHARACTER SET utf8 COLLATE utf8_bin DEFAULT 'None',
  `quests` longtext CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT '{"JobNum2":0,"JobNum3":0,"JobNum":0,"WeeklyNum":0,"BigTimeNum":0,"FarmNum":0,"GiveNum":0,"GangNum":0,"GangNum2":0,"SellNum":0,"FarmNum2":0}',
  `job` tinyint(5) DEFAULT 0,
  `job2` tinyint(5) DEFAULT 0,
  `job3` tinyint(5) DEFAULT 0,
  `gang` tinyint(5) DEFAULT 0,
  `gang2` tinyint(5) DEFAULT 0,
  `farm` tinyint(5) DEFAULT 0,
  `farm2` tinyint(5) DEFAULT 0,
  `give` tinyint(5) DEFAULT 0,
  `sell` tinyint(5) DEFAULT 0,
  `dailyquests` int(11) DEFAULT 0,
  `date` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`,`identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.quest: ~0 rows (approximately)
REPLACE INTO `quest` (`ID`, `identifier`, `daily_data`, `weekly_data`, `bigtime_data`, `quests`, `job`, `job2`, `job3`, `gang`, `gang2`, `farm`, `farm2`, `give`, `sell`, `dailyquests`, `date`) VALUES
	(134, 'steam:11000014bf543e0', '{"AllEnd":false,"End":false,"Completed":0,"ID":0,"Trigger":"","Category":0,"Finish":0,"status":false}', '{"End":false,"Finish2":0,"Trigger":"","Completed2":0,"Finish":0,"status":false,"Completed":0,"Category":0,"ID":0}', '{"End":false,"Completed":0,"ID":0,"Trigger":"","Category":0,"Finish":0,"status":false}', '{"1":0,"Job":"police"}', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026/08/26');

-- Dumping structure for table essentialmode.quest_list
DROP TABLE IF EXISTS `quest_list`;
CREATE TABLE IF NOT EXISTS `quest_list` (
  `ID` int(11) NOT NULL,
  `job` varchar(50) DEFAULT NULL,
  `category` int(11) DEFAULT 0,
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) CHARACTER SET utf8 COLLATE utf8_persian_ci DEFAULT NULL,
  `help` varchar(50) DEFAULT NULL,
  `mission2` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT 0,
  `amount2` int(11) DEFAULT 0,
  `xp` int(11) DEFAULT 0,
  `gangxp` int(11) DEFAULT 0,
  `money` int(11) DEFAULT 0,
  `coin` int(11) DEFAULT 0,
  `expire` int(15) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `trigger` longtext CHARACTER SET utf8 COLLATE utf8_persian_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.quest_list: ~124 rows (approximately)
REPLACE INTO `quest_list` (`ID`, `job`, `category`, `name`, `label`, `help`, `mission2`, `amount`, `amount2`, `xp`, `gangxp`, `money`, `coin`, `expire`, `model`, `item`, `trigger`) VALUES
	(1, 'player', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(181, 'player', 9, 'farm2', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(361, 'player', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(541, 'player', 2, 'sell', 'None', 'Rob Shop Be Payan Beresanid', NULL, 6, 0, 25, 35, 40000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(721, 'player', 3, 'gang', 'None', 'Rob Shop Be Payan Beresanid', NULL, 6, 0, 25, 35, 40000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(901, 'player', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(902, 'player', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(951, 'player', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(1001, 'player', 3, 'gang', 'None', 'Rob Shop Be Payan Beresanid', NULL, 5, 0, 25, 30, 30000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(1181, 'player', 4, 'gang2', 'None', 'Rob Shop Be Payan Beresanid', NULL, 5, 0, 25, 30, 30000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(1361, 'player', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(1541, 'player', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(1721, 'player', 2, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(1901, 'player', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(1902, 'player', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(1951, 'player', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(2001, 'Military', 5, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(2181, 'Military', 6, 'job2', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(2361, 'Military', 7, 'job3', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(2541, 'Military', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(2721, 'Military', 9, 'farm2', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(2901, 'Military', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(2902, 'Military', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(2951, 'Military', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(3001, 'Mechanic', 5, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(3181, 'Mechanic', 6, 'job2', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(3361, 'Mechanic', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(3541, 'Mechanic', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(3721, 'Mechanic', 2, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(3901, 'Mechanic', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(3902, 'Mechanic', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(3951, 'Mechanic', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(4001, 'Ambulance', 5, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(4181, 'Ambulance', 6, 'job2', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(4361, 'Ambulance', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(4541, 'Ambulance', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(4721, 'Ambulance', 2, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(4901, 'Ambulance', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(4902, 'Ambulance', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(4951, 'Ambulance', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(5001, 'Taxi', 5, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(5181, 'Taxi', 6, 'job2', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(5361, 'Taxi', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(5541, 'Taxi', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(5721, 'Taxi', 2, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(5901, 'Taxi', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(5902, 'Taxi', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(5951, 'Taxi', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(6001, 'Weazel', 5, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(6181, 'Weazel', 6, 'job2', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(6361, 'Weazel', 1, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(6541, 'Weazel', 8, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(6721, 'Weazel', 2, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(6901, 'Weazel', 10, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(6902, 'Weazel', 10, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(6951, 'Weazel', 11, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(3, NULL, 1, 'gang', 'Complete Robbery ( Bime )', 'Rob Shop Be Payan Beresanid', NULL, 7, 0, 25, 40, 50000, 4, NULL, 'daily', NULL, 'esx-br-rob-humane:robberycomplete'),
	(4, NULL, 1, 'gang', 'Complete Robbery ( Shop )', 'Rob Shop Be Payan Beresanid', NULL, 8, 0, 30, 50, 60000, 5, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(5, NULL, 1, 'gang', 'Complete Robbery ( Mini Bank )', 'Rob Shop Be Payan Beresanid', NULL, 2, 0, 25, 25, 20000, 1, NULL, 'daily', NULL, 'esx_holdupbank:robberycomplete'),
	(6, NULL, 1, 'gang', 'Bardasht Shahdone', 'Shashdone Bekan', NULL, 50, 0, 50, 50, 50000, 5, NULL, 'daily', NULL, 'esx_drugs:weedpickup'),
	(7, NULL, 1, 'gang', 'Sakht Marijuana', 'Marijuana Besazid', NULL, 50, 0, 50, 50, 50000, 5, NULL, 'daily', NULL, 'esx_drugs:MarijuanaProg'),
	(8, NULL, 1, 'gang', 'Complete Robbery ( Shop )', 'Rob Shop Be Payan Beresanid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(9, NULL, 1, 'gang', 'Complete Robbery (Jewerly Kharej)', 'Rob Javaheri Biron Shahr Be Payan Beresanid', NULL, 1, 0, 10, 25, 50000, 5, NULL, 'daily', NULL, 'esx_vangelic_robbery_sandy:robberycomplete'),
	(10, NULL, 1, 'gang', 'Complete Robbery (Jewerly Dar Shahr)', 'Rob Javaheri Dakhele Shahr Be Payan Beresanid', NULL, 2, 0, 25, 50, 100000, 5, NULL, 'daily', NULL, 'esx_vangelic_robbery:robberycomplete'),
	(29, NULL, 2, 'farm', 'Farme Pashm', 'Pashm Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestWool'),
	(30, NULL, 2, 'farm', 'Farme Parche', 'Parche Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestFabric'),
	(31, NULL, 2, 'farm', 'Farme Lebas', 'Lebas Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestClothe'),
	(32, NULL, 2, 'farm', 'Farme Choob', 'Choob Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestWood'),
	(33, NULL, 2, 'farm', 'Farme Rafin', 'Rafin Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestRafin'),
	(34, NULL, 2, 'farm', 'Farme Morgh Zende', 'Morgh Zende Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestAliveChicken'),
	(35, NULL, 2, 'farm', 'Farme Ahan', 'Ahan Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestIron'),
	(36, NULL, 2, 'farm', 'Farme Choob Boresh Khorde', 'Choob Boresh Khorde Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestCutWood'),
	(37, NULL, 2, 'farm', 'Farm Benzin', 'Benzin Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestPetrol'),
	(38, NULL, 2, 'farm', 'Farm Morgh BasteBandi Shode', 'Morgh BasteBandi Shode Farm Konid', NULL, 10, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx_jobs:QuestPackagedChicken'),
	(39, NULL, 2, 'farm', 'On Duty', 'Bar Salary Daryaft Konid', NULL, 6, 0, 50, 25, 50000, 5, NULL, 'daily', NULL, 'esx:givesalary'),
	(49, NULL, 3, 'give', 'Darkhast Ghezelala', 'Ghezelala Tahvil Dahid', NULL, 15, 0, 50, 25, 100000, 5, NULL, 'daily', 'ghezelala', 'None'),
	(50, NULL, 3, 'give', 'Darkhast Shishe', 'Shishe Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'meth', 'None'),
	(51, NULL, 3, 'give', 'Darkhast Ephedra', 'Ephedra Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'ephedra', 'None'),
	(52, NULL, 3, 'give', 'Darkhast Ahan', 'Ahan Tahvil Dahid', NULL, 5, 0, 50, 25, 50000, 5, NULL, 'daily', 'iron', 'None'),
	(53, NULL, 3, 'give', 'Darkhast Ephedrine', 'Ephedrine Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'ephedrine', 'None'),
	(54, NULL, 3, 'give', 'Darkhast Javaher', 'Javaher Tahvil Dahid', NULL, 100, 0, 50, 25, 100000, 5, NULL, 'daily', 'jewels', 'None'),
	(55, NULL, 3, 'give', 'Darkhast Tala', 'Tala Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'gold', 'None'),
	(56, NULL, 3, 'give', 'Darkhast Heroine', 'Heroine Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'heroine', 'None'),
	(57, NULL, 3, 'give', 'Darkhast Cocaine', 'Cocaine Tahvil Dahid', NULL, 10, 0, 50, 25, 100000, 5, NULL, 'daily', 'cocaine', 'None'),
	(58, NULL, 3, 'give', 'Darkhast Marijuana', 'Marijuana Tahvil Dahid', NULL, 50, 0, 50, 25, 100000, 5, NULL, 'daily', 'marijuana', 'None'),
	(59, NULL, 3, 'give', 'Darkhast Shahdone', 'Shahdone Tahvil Dahid', NULL, 100, 0, 50, 50, 100000, 5, NULL, 'daily', 'cannabis', 'None'),
	(69, NULL, 4, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(70, NULL, 4, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(71, NULL, 4, 'job', 'Gharbale Sang', 'Kamion Sang Gharbal Konid', NULL, 1, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_miner:Gharbale'),
	(72, NULL, 4, 'job', 'Ghabz', 'Ghabz Sabt Konid', NULL, 15, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'Task_System:Billing'),
	(73, NULL, 4, 'job', 'Mosafer Bari', 'Mosafer Be Maghsad Bereson', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'Task_System:TaxiFinish'),
	(74, NULL, 4, 'job', 'Ghabz', 'Ghabz Sabt Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'Task_System:Billing'),
	(75, NULL, 4, 'job', 'Darman Sarpayee', 'Nafar Ra Heal Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_ambulancejob:heal'),
	(76, NULL, 4, 'job', 'Revive', 'Nafar Ra Darman Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'Task_System:revive'),
	(77, NULL, 4, 'job', 'Impound', 'Mashin Impound Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_mecanojob:Impond'),
	(78, NULL, 4, 'job', 'Repair', 'Mashin Tamir Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'esx_mecanojob:Repaire'),
	(79, NULL, 4, 'job', 'Ghabz', 'Ghabz Sabt Konid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', NULL, 'Task_System:Billing'),
	(89, NULL, 5, 'sell', 'Forooshe Mahi ( Hamoor )', 'Mahi Hamoor Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'hamoor', 'None'),
	(90, NULL, 5, 'sell', 'Forooshe Mahi ( Ghezel )', 'Mahi Ghezelala Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'ghezelala', 'None'),
	(91, NULL, 5, 'sell', 'Forooshe Mahi ( Mahigoli )', 'Mahi Mahigoli Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'mahigoli', 'None'),
	(92, NULL, 5, 'sell', 'Forooshe Mahi ( Salmon )', 'Mahi Salmon Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'salomon', 'None'),
	(93, NULL, 5, 'sell', 'Forooshe Meygoo', 'Meygoo Befrooshid', NULL, 10, 0, 50, 25, 0, 5, NULL, 'daily', 'meygoo', 'None'),
	(94, NULL, 5, 'sell', 'Forooshe Marijuana', 'Marijuana Befrooshid', NULL, 50, 0, 50, 25, 0, 5, NULL, 'daily', 'marijuana', 'None'),
	(95, NULL, 5, 'sell', 'Forooshe Crack', 'Crack Befrooshid', NULL, 30, 0, 50, 25, 0, 5, NULL, 'daily', 'crack', 'None'),
	(96, NULL, 5, 'sell', 'Forooshe Heroin', 'Heroin Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'heroine', 'None'),
	(97, NULL, 5, 'sell', 'Forooshe Cocain', 'Cocain Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'cocaine', 'None'),
	(98, NULL, 5, 'sell', 'Forooshe Mahi ( Alidaie )', 'Mahi Alidaie Befrooshid', NULL, 20, 0, 50, 25, 0, 5, NULL, 'daily', 'alidaie', 'None'),
	(99, NULL, 5, 'sell', 'Forooshe Shishe', 'Shishe Befrooshid', NULL, 10, 0, 50, 25, 10000, 5, NULL, 'daily', 'meth', 'None'),
	(100, NULL, 6, 'give', 'Daily Quest Complete | Mahi Alidaie', 'Anjam Quest', 'Mahi AliDaie', 16, 1, 100, 0, 200000, 10, 1714422603, 'weekly', 'alidaie', 'None'),
	(101, NULL, 6, 'weekly', 'Daily Quest Complete', 'Anjam Quest', NULL, 16, 0, 100, 0, 200000, 10, 1714422603, 'weekly', NULL, 'None'),
	(102, NULL, 7, 'bigtime', 'Win Dar PACMAN', 'Bar Dar PacMan Barande Shavid', NULL, 1, 0, 100, 0, 500000, 10, 1714509006, 'bigtime', NULL, 'pacman:win'),
	(2, NULL, 0, 'gang', 'Complete Robbery ( Shop )', 'Rob Shop Be Payan Beresanid', NULL, 5, 0, 25, 30, 30000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(1, NULL, 0, 'gang', 'Complete Robbery ( Shop )', 'Rob Shop Be Payan Beresanid', NULL, 5, 0, 25, 30, 30000, 3, NULL, 'daily', NULL, 'esx_holdup:robberyComplete'),
	(0, NULL, 0, 'give', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, 'player', 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(361, NULL, 0, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(361, 'player', 1, 'give', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL),
	(0, NULL, 2, 'sell', NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, NULL);

-- Dumping structure for table essentialmode.rented_vehicles
DROP TABLE IF EXISTS `rented_vehicles`;
CREATE TABLE IF NOT EXISTS `rented_vehicles` (
  `vehicle` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `base_price` int(11) NOT NULL,
  `rent_price` int(11) NOT NULL,
  `owner` varchar(22) NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.rented_vehicles: ~0 rows (approximately)

-- Dumping structure for table essentialmode.sunset_doc_models
DROP TABLE IF EXISTS `sunset_doc_models`;
CREATE TABLE IF NOT EXISTS `sunset_doc_models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `date` varchar(50) DEFAULT '',
  `title` varchar(150) DEFAULT '',
  `text` longtext DEFAULT NULL,
  `images` longtext DEFAULT NULL,
  `signatures` longtext DEFAULT NULL,
  `creator` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.sunset_doc_models: ~2 rows (approximately)
REPLACE INTO `sunset_doc_models` (`id`, `name`, `date`, `title`, `text`, `images`, `signatures`, `creator`, `created_at`) VALUES
	(3, 'a', 'تاریخ', 'عنوان', '', '[]', '[]', 'steam:11000014bf543e0', '2026-08-04 10:52:42'),
	(4, 'aa', 'تاریخ', 'عنوان', '', '[]', '[]', 'steam:11000014bf543e0', '2026-08-05 10:19:46');

-- Dumping structure for table essentialmode.sunset_documents
DROP TABLE IF EXISTS `sunset_documents`;
CREATE TABLE IF NOT EXISTS `sunset_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `model_id` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT '',
  `title` varchar(150) DEFAULT '',
  `text` longtext DEFAULT NULL,
  `images` longtext DEFAULT NULL,
  `signatures` longtext DEFAULT NULL,
  `closed` tinyint(1) NOT NULL DEFAULT 0,
  `creator` varchar(64) DEFAULT NULL,
  `owner` varchar(64) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  `is_copy` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.sunset_documents: ~5 rows (approximately)
REPLACE INTO `sunset_documents` (`id`, `name`, `model_id`, `date`, `title`, `text`, `images`, `signatures`, `closed`, `creator`, `owner`, `created_at`, `updated_at`, `is_copy`) VALUES
	(11, 'aa', 3, 'تاریخ', 'عنوان', '', '[]', '[]', 1, 'steam:11000014bf543e0', NULL, '2026-08-04 11:15:34', '2026-08-04 11:15:34', 0),
	(12, '(کپی برابر اصل) aa', 3, 'تاریخ', 'عنوان', '', '[]', '[]', 1, 'steam:11000014bf543e0', NULL, '2026-08-04 11:15:48', '2026-08-04 11:15:48', 1),
	(13, '(کپی برابر اصل) aa', 3, 'تاریخ', 'عنوان', '', '[]', '[]', 1, 'steam:11000014bf543e0', NULL, '2026-08-04 15:54:58', '2026-08-04 15:54:58', 1),
	(14, 'aa', 4, 'تاریخ', 'عنوان', '', '[]', '[{"asign":"GD","info":"Police | Commissioner | 1405/5/14 | 11:19"}]', 1, 'steam:11000014bf543e0', NULL, '2026-08-05 10:19:56', '2026-08-05 10:19:56', 0),
	(15, 'arsgua', 4, 'تاریخ', 'عنوان', 'aaa', '[]', '[{"asign":"GD","info":"Police | Commissioner | 1405/5/14 | 11:20"},{"asign":"GD","info":"Police | Commissioner | 1405/5/14 | 11:20"}]', 1, 'steam:11000014bf543e0', NULL, '2026-08-05 10:20:28', '2026-08-05 10:20:28', 0),
	(16, '(کپی برابر اصل) arsgua', 4, 'تاریخ', 'عنوان', 'aaa', '[]', '[{"asign":"GD","info":"Police | Commissioner | 1405/5/14 | 11:20"},{"asign":"GD","info":"Police | Commissioner | 1405/5/14 | 11:20"}]', 1, 'steam:11000014bf543e0', NULL, '2026-08-05 10:22:41', '2026-08-05 10:22:41', 1);

-- Dumping structure for table essentialmode.trunk_inventories
DROP TABLE IF EXISTS `trunk_inventories`;
CREATE TABLE IF NOT EXISTS `trunk_inventories` (
  `plate` varchar(32) NOT NULL,
  `glove_box` tinyint(1) NOT NULL DEFAULT 0,
  `items` longtext NOT NULL DEFAULT '[]',
  `weapons` longtext NOT NULL DEFAULT '[]',
  PRIMARY KEY (`plate`,`glove_box`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.trunk_inventories: ~0 rows (approximately)

-- Dumping structure for table essentialmode.trunk_inventory
DROP TABLE IF EXISTS `trunk_inventory`;
CREATE TABLE IF NOT EXISTS `trunk_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) NOT NULL,
  `data` text NOT NULL,
  `owned` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.trunk_inventory: ~0 rows (approximately)
REPLACE INTO `trunk_inventory` (`id`, `plate`, `data`, `owned`) VALUES
	(1, ' 123213 ', '{}', 0);

-- Dumping structure for table essentialmode.twitter_tweets
DROP TABLE IF EXISTS `twitter_tweets`;
CREATE TABLE IF NOT EXISTS `twitter_tweets` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.twitter_tweets: ~0 rows (approximately)

-- Dumping structure for table essentialmode.unique_ui_migrations
DROP TABLE IF EXISTS `unique_ui_migrations`;
CREATE TABLE IF NOT EXISTS `unique_ui_migrations` (
  `name` varchar(191) NOT NULL,
  `applied_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.unique_ui_migrations: ~2 rows (approximately)
REPLACE INTO `unique_ui_migrations` (`name`, `applied_at`) VALUES
	('users_add_account_num', '2026-08-10 11:00:45'),
	('users_add_token_coin', '2026-08-10 11:00:45');

-- Dumping structure for table essentialmode.uniqueac_admin
DROP TABLE IF EXISTS `uniqueac_admin`;
CREATE TABLE IF NOT EXISTS `uniqueac_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_admin_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_admin: ~0 rows (approximately)

-- Dumping structure for table essentialmode.uniqueac_admin_log
DROP TABLE IF EXISTS `uniqueac_admin_log`;
CREATE TABLE IF NOT EXISTS `uniqueac_admin_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `admin_identifier` varchar(128) DEFAULT NULL,
  `admin_name` varchar(128) DEFAULT NULL,
  `action` varchar(64) NOT NULL,
  `target_identifier` varchar(128) DEFAULT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_adminlog_admin` (`admin_identifier`),
  KEY `idx_uniqueac_adminlog_target` (`target_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_admin_log: ~0 rows (approximately)
REPLACE INTO `uniqueac_admin_log` (`id`, `admin_identifier`, `admin_name`, `action`, `target_identifier`, `target_name`, `reason`, `created_at`) VALUES
	(1, 'license:153122398469261248', 'GD', 'NOTE_ADD', 'license:153122398469261248', 'GD', '1', '2026-08-15 19:02:31');

-- Dumping structure for table essentialmode.uniqueac_appeals
DROP TABLE IF EXISTS `uniqueac_appeals`;
CREATE TABLE IF NOT EXISTS `uniqueac_appeals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `ban_id` bigint(20) unsigned DEFAULT NULL,
  `message` text NOT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `reviewed_by` varchar(128) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_appeals_identifier` (`identifier`),
  KEY `idx_uniqueac_appeals_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_appeals: ~0 rows (approximately)

-- Dumping structure for table essentialmode.uniqueac_banlist
DROP TABLE IF EXISTS `uniqueac_banlist`;
CREATE TABLE IF NOT EXISTS `uniqueac_banlist` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `PLAYER_NAME` varchar(128) DEFAULT NULL,
  `STEAM` varchar(128) NOT NULL DEFAULT '__NONE__',
  `DISCORD` varchar(64) NOT NULL DEFAULT '__NONE__',
  `LICENSE` varchar(128) NOT NULL DEFAULT '__NONE__',
  `LIVE` varchar(128) NOT NULL DEFAULT '__NONE__',
  `XBL` varchar(128) NOT NULL DEFAULT '__NONE__',
  `IP` varchar(64) NOT NULL DEFAULT '__NONE__',
  `TOKENS` longtext NOT NULL,
  `BANID` bigint(20) unsigned NOT NULL,
  `REASON` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_banid` (`BANID`),
  KEY `idx_uniqueac_license` (`LICENSE`),
  KEY `idx_uniqueac_discord` (`DISCORD`),
  KEY `idx_uniqueac_ip` (`IP`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_banlist: ~0 rows (approximately)

-- Dumping structure for table essentialmode.uniqueac_detections
DROP TABLE IF EXISTS `uniqueac_detections`;
CREATE TABLE IF NOT EXISTS `uniqueac_detections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `reason` varchar(128) NOT NULL,
  `details` text DEFAULT NULL,
  `action` varchar(32) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_detections_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_detections: ~0 rows (approximately)

-- Dumping structure for table essentialmode.uniqueac_notes
DROP TABLE IF EXISTS `uniqueac_notes`;
CREATE TABLE IF NOT EXISTS `uniqueac_notes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `target_identifier` varchar(128) NOT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `author_identifier` varchar(128) DEFAULT NULL,
  `author_name` varchar(128) DEFAULT NULL,
  `note` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_uniqueac_notes_target` (`target_identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_notes: ~0 rows (approximately)
REPLACE INTO `uniqueac_notes` (`id`, `target_identifier`, `target_name`, `author_identifier`, `author_name`, `note`, `created_at`) VALUES
	(1, 'license:153122398469261248', 'GD', 'license:153122398469261248', 'GD', '1', '2026-08-15 19:02:31');

-- Dumping structure for table essentialmode.uniqueac_trust
DROP TABLE IF EXISTS `uniqueac_trust`;
CREATE TABLE IF NOT EXISTS `uniqueac_trust` (
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  `trust_score` int(11) NOT NULL DEFAULT 100,
  `risk_score` int(11) NOT NULL DEFAULT 0,
  `flag_count` int(10) unsigned NOT NULL DEFAULT 0,
  `quarantine_count` int(10) unsigned NOT NULL DEFAULT 0,
  `reconnect_count` int(10) unsigned NOT NULL DEFAULT 0,
  `last_reconnect_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `first_seen` datetime NOT NULL DEFAULT current_timestamp(),
  `last_seen` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_trust: ~0 rows (approximately)
REPLACE INTO `uniqueac_trust` (`identifier`, `player_name`, `trust_score`, `risk_score`, `flag_count`, `quarantine_count`, `reconnect_count`, `last_reconnect_at`, `first_seen`, `last_seen`) VALUES
	('license:153122398469261248', 'GD', 100, 40, 0, 0, 4, 604498, '2026-08-11 10:06:10', '2026-08-23 13:03:12');

-- Dumping structure for table essentialmode.uniqueac_unban
DROP TABLE IF EXISTS `uniqueac_unban`;
CREATE TABLE IF NOT EXISTS `uniqueac_unban` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_unban_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_unban: ~0 rows (approximately)

-- Dumping structure for table essentialmode.uniqueac_whitelist
DROP TABLE IF EXISTS `uniqueac_whitelist`;
CREATE TABLE IF NOT EXISTS `uniqueac_whitelist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `player_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_uniqueac_whitelist_identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table essentialmode.uniqueac_whitelist: ~0 rows (approximately)
REPLACE INTO `uniqueac_whitelist` (`id`, `identifier`, `player_name`) VALUES
	(2, 'license:153122398469261248', 'GD');

-- Dumping structure for table essentialmode.user_accounts
DROP TABLE IF EXISTS `user_accounts`;
CREATE TABLE IF NOT EXISTS `user_accounts` (
  `identifier` varchar(60) NOT NULL,
  `name` varchar(50) NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.user_accounts: ~0 rows (approximately)

-- Dumping structure for table essentialmode.user_licenses
DROP TABLE IF EXISTS `user_licenses`;
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(60) NOT NULL,
  `type` varchar(50) NOT NULL,
  `revoked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.user_licenses: ~0 rows (approximately)

-- Dumping structure for table essentialmode.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(60) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `job` varchar(50) NOT NULL DEFAULT 'unemployed',
  `job_grade` int(11) NOT NULL DEFAULT 0,
  `group` varchar(50) NOT NULL DEFAULT 'user',
  `gang` varchar(50) NOT NULL DEFAULT 'none',
  `gang_grade` int(11) NOT NULL DEFAULT 0,
  `divisions` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `dateofbirth` varchar(50) DEFAULT NULL,
  `sex` varchar(1) DEFAULT NULL,
  `height` varchar(50) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `is_dead` tinyint(1) NOT NULL DEFAULT 0,
  `last_property` varchar(50) DEFAULT NULL,
  `money` int(11) NOT NULL DEFAULT 5000,
  `bank` int(11) NOT NULL DEFAULT 0,
  `black_money` int(11) NOT NULL DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `disabled_reason` varchar(255) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `steam` varchar(60) DEFAULT NULL,
  `license` varchar(60) DEFAULT NULL,
  `discord` varchar(60) DEFAULT NULL,
  `fivem` varchar(60) DEFAULT NULL,
  `xbl` varchar(60) DEFAULT NULL,
  `live` varchar(60) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `playtime` bigint(20) NOT NULL DEFAULT 0,
  `last_seen` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `coin` int(11) NOT NULL DEFAULT 0,
  `timercoin` int(11) NOT NULL DEFAULT 0,
  `score` int(11) NOT NULL DEFAULT 0,
  `skills` longtext DEFAULT NULL,
  `WantedLevel` text DEFAULT 'standard',
  `Profile_Pic` text DEFAULT '',
  `token` int(11) NOT NULL DEFAULT 0,
  `tasks` longtext DEFAULT NULL,
  `tasks_completed` longtext DEFAULT NULL,
  `winnings` longtext DEFAULT '',
  `tattoos` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `name` varchar(60) DEFAULT NULL,
  `playerName` varchar(60) DEFAULT NULL,
  `discordid` varchar(60) DEFAULT NULL,
  `subscription_uses` int(11) NOT NULL DEFAULT 0,
  `permission_level` int(11) NOT NULL DEFAULT 0,
  `phone` varchar(20) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `badge` varchar(20) DEFAULT NULL,
  `rank` int(11) NOT NULL DEFAULT 0,
  `jail` text NOT NULL DEFAULT '0',
  `timePlay` bigint(20) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `R` int(11) NOT NULL DEFAULT 0,
  `starterpack` varchar(10) NOT NULL DEFAULT 'false',
  `roles` varchar(50) DEFAULT '',
  `xp` int(11) NOT NULL DEFAULT 0,
  `setwarn` varchar(255) NOT NULL DEFAULT '0',
  `division` varchar(255) NOT NULL DEFAULT '',
  `account_num` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `account_num` (`account_num`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.users: ~0 rows (approximately)
REPLACE INTO `users` (`identifier`, `accounts`, `inventory`, `job`, `job_grade`, `group`, `gang`, `gang_grade`, `divisions`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `skin`, `is_dead`, `last_property`, `money`, `bank`, `black_money`, `loadout`, `disabled`, `disabled_reason`, `phone_number`, `steam`, `license`, `discord`, `fivem`, `xbl`, `live`, `ip`, `playtime`, `last_seen`, `created_at`, `coin`, `timercoin`, `score`, `skills`, `WantedLevel`, `Profile_Pic`, `token`, `tasks`, `tasks_completed`, `winnings`, `tattoos`, `status`, `name`, `playerName`, `discordid`, `subscription_uses`, `permission_level`, `phone`, `iban`, `badge`, `rank`, `jail`, `timePlay`, `level`, `R`, `starterpack`, `roles`, `xp`, `setwarn`, `division`, `account_num`) VALUES
	('steam:11000014bf543e0', NULL, '[{"count":2,"item":"radio"},{"count":2,"item":"phone"},{"count":1,"item":"hifi"},{"count":1,"item":"CarKey|64JJA687"}]', 'police', 21, 'user', 'A', 13, '[]', '{"x":219.0469512939453,"y":-767.0297241210938,"z":30.47820854187011}', NULL, NULL, '02/01/2000', '0', NULL, '{"sex":0,"bracelets_1":-1,"arms_2":0,"watches_1":-1,"ears_1":-1,"tshirt_2":0,"beard_3":0,"chain_1":0,"bags_2":0,"chain_2":0,"eyebrows_2":10,"shoes_2":0,"complexion_1":0,"bproof_1":0,"face_1":0,"hair_color_2":0,"pants_1":61,"moles_2":1,"bproof_2":0,"face_3":5,"mask_2":0,"beard_2":10,"eye_color":5,"watches_2":-1,"complexion_2":1,"pants_2":4,"eyebrows_1":0,"hair_1":1,"helmet_1":-1,"age_2":0,"hair_color_1":0,"tshirt_1":15,"mask_1":0,"torso_2":0,"beard_4":0,"helmet_2":-1,"torso_1":15,"skin":12,"glasses_2":-1,"age_1":0,"bracelets_2":-1,"moles_1":0,"ears_2":-1,"glasses_1":-1,"beard_1":0,"face_2":21,"shoes_1":34,"hair_2":0,"arms":15,"bags_1":0}', 0, NULL, 0, 280000, 0, '[]', 0, NULL, NULL, NULL, 'license:153122398469261248', NULL, NULL, NULL, NULL, NULL, 0, NULL, '2026-08-22 18:00:33', 6, 90, 0, NULL, 'standard', '', 0, NULL, NULL, '', NULL, NULL, 'GD', 'Arshia_Mtz', 'N/A', 0, 16, '05252198153', '7030581', NULL, 1, '0', 20916, 1, 0, 'false', '', 10, '0', '', 4);

-- Dumping structure for table essentialmode.uwumarket
DROP TABLE IF EXISTS `uwumarket`;
CREATE TABLE IF NOT EXISTS `uwumarket` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `weight` float DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `owner` varchar(60) DEFAULT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.uwumarket: ~0 rows (approximately)

-- Dumping structure for table essentialmode.vehicle_categories
DROP TABLE IF EXISTS `vehicle_categories`;
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.vehicle_categories: ~11 rows (approximately)
REPLACE INTO `vehicle_categories` (`name`, `label`) VALUES
	('compacts', 'Compacts'),
	('coupes', 'Coupes'),
	('motorcycles', 'Motos'),
	('muscle', 'Muscle'),
	('offroad', 'Off Road'),
	('sedans', 'Sedans'),
	('sports', 'Sports'),
	('sportsclassics', 'Sports Classics'),
	('super', 'Super'),
	('suvs', 'SUVs'),
	('vans', 'Vans');

-- Dumping structure for table essentialmode.vehicle_damage
DROP TABLE IF EXISTS `vehicle_damage`;
CREATE TABLE IF NOT EXISTS `vehicle_damage` (
  `plate` varchar(15) NOT NULL,
  `damage` longtext DEFAULT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.vehicle_damage: ~0 rows (approximately)

-- Dumping structure for table essentialmode.vehicle_keys
DROP TABLE IF EXISTS `vehicle_keys`;
CREATE TABLE IF NOT EXISTS `vehicle_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.vehicle_keys: ~0 rows (approximately)

-- Dumping structure for table essentialmode.vehicle_sold
DROP TABLE IF EXISTS `vehicle_sold`;
CREATE TABLE IF NOT EXISTS `vehicle_sold` (
  `client` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `soldby` varchar(50) NOT NULL,
  `date` varchar(50) NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.vehicle_sold: ~0 rows (approximately)

-- Dumping structure for table essentialmode.vehicles
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.vehicles: ~240 rows (approximately)
REPLACE INTO `vehicles` (`name`, `model`, `price`, `category`) VALUES
	('Adder', 'adder', 900000, 'super'),
	('Akuma', 'AKUMA', 7500, 'motorcycles'),
	('Alpha', 'alpha', 60000, 'sports'),
	('Ardent', 'ardent', 1150000, 'sportsclassics'),
	('Asea', 'asea', 5500, 'sedans'),
	('Autarch', 'autarch', 1955000, 'super'),
	('Avarus', 'avarus', 18000, 'motorcycles'),
	('Bagger', 'bagger', 13500, 'motorcycles'),
	('Baller', 'baller2', 40000, 'suvs'),
	('Baller Sport', 'baller3', 60000, 'suvs'),
	('Banshee', 'banshee', 70000, 'sports'),
	('Banshee 900R', 'banshee2', 255000, 'super'),
	('Bati 801', 'bati', 12000, 'motorcycles'),
	('Bati 801RR', 'bati2', 19000, 'motorcycles'),
	('Bestia GTS', 'bestiagts', 55000, 'sports'),
	('BF400', 'bf400', 6500, 'motorcycles'),
	('Bf Injection', 'bfinjection', 16000, 'offroad'),
	('Bifta', 'bifta', 12000, 'offroad'),
	('Bison', 'bison', 45000, 'vans'),
	('Blade', 'blade', 15000, 'muscle'),
	('Blazer', 'blazer', 6500, 'offroad'),
	('Blazer Sport', 'blazer4', 8500, 'offroad'),
	('blazer5', 'blazer5', 1755600, 'offroad'),
	('Blista', 'blista', 8000, 'compacts'),
	('BMX (velo)', 'bmx', 160, 'motorcycles'),
	('Bobcat XL', 'bobcatxl', 32000, 'vans'),
	('Brawler', 'brawler', 45000, 'offroad'),
	('Brioso R/A', 'brioso', 18000, 'compacts'),
	('Btype', 'btype', 62000, 'sportsclassics'),
	('Btype Hotroad', 'btype2', 155000, 'sportsclassics'),
	('Btype Luxe', 'btype3', 85000, 'sportsclassics'),
	('Buccaneer', 'buccaneer', 18000, 'muscle'),
	('Buccaneer Rider', 'buccaneer2', 24000, 'muscle'),
	('Buffalo', 'buffalo', 12000, 'sports'),
	('Buffalo S', 'buffalo2', 20000, 'sports'),
	('Bullet', 'bullet', 90000, 'super'),
	('Burrito', 'burrito3', 19000, 'vans'),
	('Camper', 'camper', 42000, 'vans'),
	('Carbonizzare', 'carbonizzare', 75000, 'sports'),
	('Carbon RS', 'carbonrs', 18000, 'motorcycles'),
	('Casco', 'casco', 30000, 'sportsclassics'),
	('Cavalcade', 'cavalcade2', 55000, 'suvs'),
	('Cheetah', 'cheetah', 375000, 'super'),
	('Chimera', 'chimera', 38000, 'motorcycles'),
	('Chino', 'chino', 15000, 'muscle'),
	('Chino Luxe', 'chino2', 19000, 'muscle'),
	('Cliffhanger', 'cliffhanger', 9500, 'motorcycles'),
	('Cognoscenti Cabrio', 'cogcabrio', 55000, 'coupes'),
	('Cognoscenti', 'cognoscenti', 55000, 'sedans'),
	('Comet', 'comet2', 65000, 'sports'),
	('Comet 5', 'comet5', 1145000, 'sports'),
	('Contender', 'contender', 70000, 'suvs'),
	('Coquette', 'coquette', 65000, 'sports'),
	('Coquette Classic', 'coquette2', 40000, 'sportsclassics'),
	('Coquette BlackFin', 'coquette3', 55000, 'muscle'),
	('Cruiser (velo)', 'cruiser', 510, 'motorcycles'),
	('Cyclone', 'cyclone', 1890000, 'super'),
	('Daemon', 'daemon', 11500, 'motorcycles'),
	('Daemon High', 'daemon2', 13500, 'motorcycles'),
	('Defiler', 'defiler', 9800, 'motorcycles'),
	('Deluxo', 'deluxo', 4721500, 'sportsclassics'),
	('Dominator', 'dominator', 35000, 'muscle'),
	('Double T', 'double', 28000, 'motorcycles'),
	('Dubsta', 'dubsta', 45000, 'suvs'),
	('Dubsta Luxuary', 'dubsta2', 60000, 'suvs'),
	('Bubsta 6x6', 'dubsta3', 120000, 'offroad'),
	('Dukes', 'dukes', 28000, 'muscle'),
	('Dune Buggy', 'dune', 8000, 'offroad'),
	('Elegy', 'elegy2', 38500, 'sports'),
	('Emperor', 'emperor', 8500, 'sedans'),
	('Enduro', 'enduro', 5500, 'motorcycles'),
	('Entity XF', 'entityxf', 425000, 'super'),
	('Esskey', 'esskey', 4200, 'motorcycles'),
	('Exemplar', 'exemplar', 32000, 'coupes'),
	('F620', 'f620', 40000, 'coupes'),
	('Faction', 'faction', 20000, 'muscle'),
	('Faction Rider', 'faction2', 30000, 'muscle'),
	('Faction XL', 'faction3', 40000, 'muscle'),
	('Faggio', 'faggio', 1900, 'motorcycles'),
	('Vespa', 'faggio2', 2800, 'motorcycles'),
	('Felon', 'felon', 42000, 'coupes'),
	('Felon GT', 'felon2', 55000, 'coupes'),
	('Feltzer', 'feltzer2', 55000, 'sports'),
	('Stirling GT', 'feltzer3', 65000, 'sportsclassics'),
	('Fixter (velo)', 'fixter', 225, 'motorcycles'),
	('FMJ', 'fmj', 185000, 'super'),
	('Fhantom', 'fq2', 17000, 'suvs'),
	('Fugitive', 'fugitive', 12000, 'sedans'),
	('Furore GT', 'furoregt', 45000, 'sports'),
	('Fusilade', 'fusilade', 40000, 'sports'),
	('Gargoyle', 'gargoyle', 16500, 'motorcycles'),
	('Gauntlet', 'gauntlet', 30000, 'muscle'),
	('Gang Burrito', 'gburrito', 45000, 'vans'),
	('Burrito', 'gburrito2', 29000, 'vans'),
	('Glendale', 'glendale', 6500, 'sedans'),
	('Grabger', 'granger', 50000, 'suvs'),
	('Gresley', 'gresley', 47500, 'suvs'),
	('GT 500', 'gt500', 785000, 'sportsclassics'),
	('Guardian', 'guardian', 45000, 'offroad'),
	('Hakuchou', 'hakuchou', 31000, 'motorcycles'),
	('Hakuchou Sport', 'hakuchou2', 55000, 'motorcycles'),
	('Hermes', 'hermes', 535000, 'muscle'),
	('Hexer', 'hexer', 12000, 'motorcycles'),
	('Hotknife', 'hotknife', 125000, 'muscle'),
	('Huntley S', 'huntley', 40000, 'suvs'),
	('Hustler', 'hustler', 625000, 'muscle'),
	('Infernus', 'infernus', 180000, 'super'),
	('Innovation', 'innovation', 23500, 'motorcycles'),
	('Intruder', 'intruder', 7500, 'sedans'),
	('Issi', 'issi2', 10000, 'compacts'),
	('Jackal', 'jackal', 38000, 'coupes'),
	('Jester', 'jester', 65000, 'sports'),
	('Jester(Racecar)', 'jester2', 135000, 'sports'),
	('Journey', 'journey', 6500, 'vans'),
	('Kamacho', 'kamacho', 345000, 'offroad'),
	('Khamelion', 'khamelion', 38000, 'sports'),
	('Kuruma', 'kuruma', 30000, 'sports'),
	('Landstalker', 'landstalker', 35000, 'suvs'),
	('RE-7B', 'le7b', 325000, 'super'),
	('Lynx', 'lynx', 40000, 'sports'),
	('Mamba', 'mamba', 70000, 'sports'),
	('Manana', 'manana', 12800, 'sportsclassics'),
	('Manchez', 'manchez', 5300, 'motorcycles'),
	('Massacro', 'massacro', 65000, 'sports'),
	('Massacro(Racecar)', 'massacro2', 130000, 'sports'),
	('Mesa', 'mesa', 16000, 'suvs'),
	('Mesa Trail', 'mesa3', 40000, 'suvs'),
	('Minivan', 'minivan', 13000, 'vans'),
	('Monroe', 'monroe', 55000, 'sportsclassics'),
	('The Liberator', 'monster', 210000, 'offroad'),
	('Moonbeam', 'moonbeam', 18000, 'vans'),
	('Moonbeam Rider', 'moonbeam2', 35000, 'vans'),
	('Nemesis', 'nemesis', 5800, 'motorcycles'),
	('Neon', 'neon', 1500000, 'sports'),
	('Nightblade', 'nightblade', 35000, 'motorcycles'),
	('Nightshade', 'nightshade', 65000, 'muscle'),
	('9F', 'ninef', 65000, 'sports'),
	('9F Cabrio', 'ninef2', 80000, 'sports'),
	('Omnis', 'omnis', 35000, 'sports'),
	('Oppressor', 'oppressor', 3524500, 'super'),
	('Oracle XS', 'oracle2', 35000, 'coupes'),
	('Osiris', 'osiris', 160000, 'super'),
	('Panto', 'panto', 10000, 'compacts'),
	('Paradise', 'paradise', 19000, 'vans'),
	('Pariah', 'pariah', 1420000, 'sports'),
	('Patriot', 'patriot', 55000, 'suvs'),
	('PCJ-600', 'pcj', 6200, 'motorcycles'),
	('Penumbra', 'penumbra', 28000, 'sports'),
	('Pfister', 'pfister811', 85000, 'super'),
	('Phoenix', 'phoenix', 12500, 'muscle'),
	('Picador', 'picador', 18000, 'muscle'),
	('Pigalle', 'pigalle', 20000, 'sportsclassics'),
	('Prairie', 'prairie', 12000, 'compacts'),
	('Premier', 'premier', 8000, 'sedans'),
	('Primo Custom', 'primo2', 14000, 'sedans'),
	('X80 Proto', 'prototipo', 2500000, 'super'),
	('Radius', 'radi', 29000, 'suvs'),
	('raiden', 'raiden', 1375000, 'sports'),
	('Rapid GT', 'rapidgt', 35000, 'sports'),
	('Rapid GT Convertible', 'rapidgt2', 45000, 'sports'),
	('Rapid GT3', 'rapidgt3', 885000, 'sportsclassics'),
	('Reaper', 'reaper', 150000, 'super'),
	('Rebel', 'rebel2', 35000, 'offroad'),
	('Regina', 'regina', 5000, 'sedans'),
	('Retinue', 'retinue', 615000, 'sportsclassics'),
	('Revolter', 'revolter', 1610000, 'sports'),
	('riata', 'riata', 380000, 'offroad'),
	('Rocoto', 'rocoto', 45000, 'suvs'),
	('Ruffian', 'ruffian', 6800, 'motorcycles'),
	('Ruiner 2', 'ruiner2', 5745600, 'muscle'),
	('Rumpo', 'rumpo', 15000, 'vans'),
	('Rumpo Trail', 'rumpo3', 19500, 'vans'),
	('Sabre Turbo', 'sabregt', 20000, 'muscle'),
	('Sabre GT', 'sabregt2', 25000, 'muscle'),
	('Sanchez', 'sanchez', 5300, 'motorcycles'),
	('Sanchez Sport', 'sanchez2', 5300, 'motorcycles'),
	('Sanctus', 'sanctus', 25000, 'motorcycles'),
	('Sandking', 'sandking', 55000, 'offroad'),
	('Savestra', 'savestra', 990000, 'sportsclassics'),
	('SC 1', 'sc1', 1603000, 'super'),
	('Schafter', 'schafter2', 25000, 'sedans'),
	('Schafter V12', 'schafter3', 50000, 'sports'),
	('Scorcher (velo)', 'scorcher', 280, 'motorcycles'),
	('Seminole', 'seminole', 25000, 'suvs'),
	('Sentinel', 'sentinel', 32000, 'coupes'),
	('Sentinel XS', 'sentinel2', 40000, 'coupes'),
	('Sentinel3', 'sentinel3', 650000, 'sports'),
	('Seven 70', 'seven70', 39500, 'sports'),
	('ETR1', 'sheava', 220000, 'super'),
	('Shotaro Concept', 'shotaro', 320000, 'motorcycles'),
	('Slam Van', 'slamvan3', 11500, 'muscle'),
	('Sovereign', 'sovereign', 22000, 'motorcycles'),
	('Stinger', 'stinger', 80000, 'sportsclassics'),
	('Stinger GT', 'stingergt', 75000, 'sportsclassics'),
	('Streiter', 'streiter', 500000, 'sports'),
	('Stretch', 'stretch', 90000, 'sedans'),
	('Stromberg', 'stromberg', 3185350, 'sports'),
	('Sultan', 'sultan', 15000, 'sports'),
	('Sultan RS', 'sultanrs', 65000, 'super'),
	('Super Diamond', 'superd', 130000, 'sedans'),
	('Surano', 'surano', 50000, 'sports'),
	('Surfer', 'surfer', 12000, 'vans'),
	('T20', 't20', 300000, 'super'),
	('Tailgater', 'tailgater', 30000, 'sedans'),
	('Tampa', 'tampa', 16000, 'muscle'),
	('Drift Tampa', 'tampa2', 80000, 'sports'),
	('Thrust', 'thrust', 24000, 'motorcycles'),
	('Tri bike (velo)', 'tribike3', 520, 'motorcycles'),
	('Trophy Truck', 'trophytruck', 60000, 'offroad'),
	('Trophy Truck Limited', 'trophytruck2', 80000, 'offroad'),
	('Tropos', 'tropos', 40000, 'sports'),
	('Turismo R', 'turismor', 350000, 'super'),
	('Tyrus', 'tyrus', 600000, 'super'),
	('Vacca', 'vacca', 120000, 'super'),
	('Vader', 'vader', 7200, 'motorcycles'),
	('Verlierer', 'verlierer2', 70000, 'sports'),
	('Vigero', 'vigero', 12500, 'muscle'),
	('Virgo', 'virgo', 14000, 'muscle'),
	('Viseris', 'viseris', 875000, 'sportsclassics'),
	('Visione', 'visione', 2250000, 'super'),
	('Voltic', 'voltic', 90000, 'super'),
	('Voltic 2', 'voltic2', 3830400, 'super'),
	('Voodoo', 'voodoo', 7200, 'muscle'),
	('Vortex', 'vortex', 9800, 'motorcycles'),
	('Warrener', 'warrener', 4000, 'sedans'),
	('Washington', 'washington', 9000, 'sedans'),
	('Windsor', 'windsor', 95000, 'coupes'),
	('Windsor Drop', 'windsor2', 125000, 'coupes'),
	('Woflsbane', 'wolfsbane', 9000, 'motorcycles'),
	('XLS', 'xls', 32000, 'suvs'),
	('Yosemite', 'yosemite', 485000, 'muscle'),
	('Youga', 'youga', 10800, 'vans'),
	('Youga Luxuary', 'youga2', 14500, 'vans'),
	('Z190', 'z190', 900000, 'sportsclassics'),
	('Zentorno', 'zentorno', 1500000, 'super'),
	('Zion', 'zion', 36000, 'coupes'),
	('Zion Cabrio', 'zion2', 45000, 'coupes'),
	('Zombie', 'zombiea', 9500, 'motorcycles'),
	('Zombie Luxuary', 'zombieb', 12000, 'motorcycles'),
	('Z-Type', 'ztype', 220000, 'sportsclassics');

-- Dumping structure for table essentialmode.weapon_serials
DROP TABLE IF EXISTS `weapon_serials`;
CREATE TABLE IF NOT EXISTS `weapon_serials` (
  `serial` varchar(12) NOT NULL,
  `weapon` varchar(50) NOT NULL,
  `owner_identifier` varchar(60) DEFAULT NULL,
  `registered_identifier` varchar(60) DEFAULT NULL,
  `ammo` int(11) NOT NULL DEFAULT 0,
  `components` text NOT NULL DEFAULT '[]',
  `status` varchar(20) NOT NULL DEFAULT 'unowned',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`serial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table essentialmode.weapon_serials: ~0 rows (approximately)

-- Dumping structure for table essentialmode.whitelist
DROP TABLE IF EXISTS `whitelist`;
CREATE TABLE IF NOT EXISTS `whitelist` (
  `identifier` varchar(60) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table essentialmode.whitelist: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
