/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `dsite_presence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dsite_presence` (
  `identifier` varchar(60) NOT NULL,
  `last_seen` int(11) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `dsite_presence` WRITE;
/*!40000 ALTER TABLE `dsite_presence` DISABLE KEYS */;
/*!40000 ALTER TABLE `dsite_presence` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `dsite_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dsite_rate` (
  `k` varchar(190) NOT NULL,
  `cnt` int(11) NOT NULL,
  `ws` int(11) NOT NULL,
  PRIMARY KEY (`k`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `dsite_rate` WRITE;
/*!40000 ALTER TABLE `dsite_rate` DISABLE KEYS */;
/*!40000 ALTER TABLE `dsite_rate` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `login_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `password_salt` varchar(64) NOT NULL DEFAULT '',
  `phone` varchar(20) DEFAULT NULL,
  `license` varchar(80) DEFAULT NULL,
  `device_license` varchar(80) DEFAULT NULL,
  `security_hold` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `login_users` WRITE;
/*!40000 ALTER TABLE `login_users` DISABLE KEYS */;
INSERT INTO `login_users` VALUES
(1,'arshia','b87291482b0f1e58c9738132c5cf660dd2d5934246845e38a485c332b5211775','salt-a',NULL,'lic:a','lic:a',0),
(2,'sam','40dc4c3b79c8ef936cd0aea9d118c2f539a2db5774e616c41bbc7ba1180c361d','salt-b',NULL,'lic:b','lic:b',0),
(3,'eve','9dea043d58c401d5db0e7ca5a7e75a2f695f24455f56190eaca31e9ae954a965','salt-c',NULL,'lic:c','lic:c',0);
/*!40000 ALTER TABLE `login_users` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_accounts` (
  `identifier` varchar(60) NOT NULL,
  `mailbox` varchar(60) NOT NULL,
  `verified_at` int(11) NOT NULL,
  `logged_in` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `mailbox` (`mailbox`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_accounts` WRITE;
/*!40000 ALTER TABLE `phone_discord_accounts` DISABLE KEYS */;
INSERT INTO `phone_discord_accounts` VALUES
('steam:a','arshia',0,1,0),
('steam:b','sam',0,1,0),
('steam:c','eve',0,0,0);
/*!40000 ALTER TABLE `phone_discord_accounts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_name` varchar(60) NOT NULL,
  `action` varchar(120) NOT NULL,
  `target` varchar(120) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_audit` WRITE;
/*!40000 ALTER TABLE `phone_discord_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_audit` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_automod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_automod` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `word` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_word` (`server_id`,`word`),
  CONSTRAINT `fk_discord_automod_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_automod` WRITE;
/*!40000 ALTER TABLE `phone_discord_automod` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_automod` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_badges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `badge` varchar(20) NOT NULL,
  `note` varchar(20) DEFAULT NULL,
  `awarded_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `one_each` (`server_id`,`identifier`,`badge`),
  CONSTRAINT `fk_discord_badges_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_badges` WRITE;
/*!40000 ALTER TABLE `phone_discord_badges` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_badges` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_bans` (
  `identifier` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `reason` varchar(150) NOT NULL DEFAULT '',
  `banned_by` varchar(60) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  `expires_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_bans` WRITE;
/*!40000 ALTER TABLE `phone_discord_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_bans` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_blocks` (
  `blocker` varchar(60) NOT NULL,
  `blocked` varchar(60) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`blocker`,`blocked`),
  KEY `blocked` (`blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_blocks` WRITE;
/*!40000 ALTER TABLE `phone_discord_blocks` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_blocks` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_boosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_boosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `created_at` int(11) NOT NULL,
  `expires_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_boosts_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_boosts` WRITE;
/*!40000 ALTER TABLE `phone_discord_boosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_boosts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_channel_perms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_channel_perms` (
  `channel_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `allow` varchar(200) NOT NULL DEFAULT '[]',
  `deny` varchar(200) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`channel_id`,`role_id`),
  KEY `fk_discord_cp_role` (`role_id`),
  CONSTRAINT `fk_discord_cp_channel` FOREIGN KEY (`channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_discord_cp_role` FOREIGN KEY (`role_id`) REFERENCES `phone_discord_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_channel_perms` WRITE;
/*!40000 ALTER TABLE `phone_discord_channel_perms` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_channel_perms` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `kind` varchar(8) NOT NULL DEFAULT 'text',
  `topic` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_channels_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_channels` WRITE;
/*!40000 ALTER TABLE `phone_discord_channels` DISABLE KEYS */;
INSERT INTO `phone_discord_channels` VALUES
(10,1,'announcements',0,0,0,1,'text','Official news'),
(11,1,'general',1,0,0,0,'text','Chat about anything'),
(12,1,'mayor-stage',2,0,0,0,'stage',NULL),
(20,2,'lounge',0,0,0,0,'text',NULL);
/*!40000 ALTER TABLE `phone_discord_channels` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_custom_emoji`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_custom_emoji` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `name` varchar(16) NOT NULL,
  `url` varchar(500) NOT NULL,
  `created_by` varchar(60) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_name` (`server_id`,`name`),
  CONSTRAINT `fk_discord_ce_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_custom_emoji` WRITE;
/*!40000 ALTER TABLE `phone_discord_custom_emoji` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_custom_emoji` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_dm_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_dm_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dm_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `author_name` varchar(80) NOT NULL DEFAULT '',
  `message` varchar(1000) NOT NULL,
  `created_at` int(11) NOT NULL,
  `edited_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dm_id` (`dm_id`,`id`),
  CONSTRAINT `fk_discord_dmm_dm` FOREIGN KEY (`dm_id`) REFERENCES `phone_discord_dms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_dm_messages` WRITE;
/*!40000 ALTER TABLE `phone_discord_dm_messages` DISABLE KEYS */;
INSERT INTO `phone_discord_dm_messages` VALUES
(1,5,'steam:b','Sam Carter','see you at the station',2000,NULL);
/*!40000 ALTER TABLE `phone_discord_dm_messages` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_dm_seen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_dm_seen` (
  `identifier` varchar(60) NOT NULL,
  `dm_id` int(11) NOT NULL,
  `last_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`,`dm_id`),
  KEY `fk_discord_dms_dm` (`dm_id`),
  CONSTRAINT `fk_discord_dms_dm` FOREIGN KEY (`dm_id`) REFERENCES `phone_discord_dms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_dm_seen` WRITE;
/*!40000 ALTER TABLE `phone_discord_dm_seen` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_dm_seen` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_dms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_dms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_low` varchar(60) NOT NULL,
  `user_high` varchar(60) NOT NULL,
  `created_at` int(11) NOT NULL,
  `last_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`user_low`,`user_high`),
  KEY `user_high` (`user_high`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_dms` WRITE;
/*!40000 ALTER TABLE `phone_discord_dms` DISABLE KEYS */;
INSERT INTO `phone_discord_dms` VALUES
(5,'steam:a','steam:b',0,2000);
/*!40000 ALTER TABLE `phone_discord_dms` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_emojis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_emojis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `emoji` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_emoji` (`server_id`,`emoji`),
  CONSTRAINT `fk_discord_emojis_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_emojis` WRITE;
/*!40000 ALTER TABLE `phone_discord_emojis` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_emojis` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_evidence_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_evidence_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `suspect_identifier` varchar(60) NOT NULL,
  `requested_by` varchar(80) NOT NULL DEFAULT '',
  `warrant_ref` varchar(40) NOT NULL DEFAULT '',
  `case_ref` varchar(40) NOT NULL DEFAULT '',
  `msg_count` int(11) NOT NULL DEFAULT 0,
  `checksum` varchar(24) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `suspect_identifier` (`suspect_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_evidence_log` WRITE;
/*!40000 ALTER TABLE `phone_discord_evidence_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_evidence_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_folder_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_folder_items` (
  `identifier` varchar(60) NOT NULL,
  `server_id` int(11) NOT NULL,
  `folder_id` int(11) NOT NULL,
  PRIMARY KEY (`identifier`,`server_id`),
  KEY `folder_id` (`folder_id`),
  CONSTRAINT `fk_discord_fi_folder` FOREIGN KEY (`folder_id`) REFERENCES `phone_discord_folders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_folder_items` WRITE;
/*!40000 ALTER TABLE `phone_discord_folder_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_folder_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_folders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` varchar(24) NOT NULL DEFAULT 'Folder',
  `color` varchar(9) NOT NULL DEFAULT '#5865F2',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_folders` WRITE;
/*!40000 ALTER TABLE `phone_discord_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_folders` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_low` varchar(60) NOT NULL,
  `user_high` varchar(60) NOT NULL,
  `requester` varchar(60) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'pending',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`user_low`,`user_high`),
  KEY `user_high` (`user_high`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_friends` WRITE;
/*!40000 ALTER TABLE `phone_discord_friends` DISABLE KEYS */;
INSERT INTO `phone_discord_friends` VALUES
(1,'steam:a','steam:b','steam:b','accepted',0);
/*!40000 ALTER TABLE `phone_discord_friends` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `code` varchar(12) NOT NULL,
  `max_uses` int(11) NOT NULL DEFAULT 0,
  `uses` int(11) NOT NULL DEFAULT 0,
  `expires_at` int(11) DEFAULT NULL,
  `created_by` varchar(60) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_inv_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_invites` WRITE;
/*!40000 ALTER TABLE `phone_discord_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_invites` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_login_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_login_codes` (
  `identifier` varchar(60) NOT NULL,
  `mailbox` varchar(60) NOT NULL,
  `code` varchar(10) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `requested_at` int(11) NOT NULL,
  `expires_at` int(11) NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_login_codes` WRITE;
/*!40000 ALTER TABLE `phone_discord_login_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_login_codes` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_member_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_member_roles` (
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`,`identifier`),
  KEY `member` (`server_id`,`identifier`),
  CONSTRAINT `fk_discord_mr_role` FOREIGN KEY (`role_id`) REFERENCES `phone_discord_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_member_roles` WRITE;
/*!40000 ALTER TABLE `phone_discord_member_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_member_roles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `joined_at` int(11) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `server_member` (`server_id`,`identifier`),
  CONSTRAINT `fk_discord_members_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_members` WRITE;
/*!40000 ALTER TABLE `phone_discord_members` DISABLE KEYS */;
INSERT INTO `phone_discord_members` VALUES
(1,1,'steam:a','Arshia Mtz',0,1),
(2,1,'steam:b','Sam Carter',0,0),
(3,2,'steam:b','Sam Carter',0,1);
/*!40000 ALTER TABLE `phone_discord_members` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `author_name` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `created_at` int(11) NOT NULL,
  `edited_at` int(11) DEFAULT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT 0,
  `reply_to_id` int(11) DEFAULT NULL,
  `is_announcement` tinyint(1) NOT NULL DEFAULT 0,
  `role_mentions` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`),
  CONSTRAINT `fk_discord_messages_channel` FOREIGN KEY (`channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_messages` WRITE;
/*!40000 ALTER TABLE `phone_discord_messages` DISABLE KEYS */;
INSERT INTO `phone_discord_messages` VALUES
(1,11,'steam:b','Sam Carter','Morning! Patrol at 9.',1000,NULL,0,NULL,0,NULL),
(2,11,'steam:a','Arshia Mtz','On my way **now**',1010,NULL,0,NULL,0,NULL),
(3,10,'steam:a','Arshia Mtz','Server maintenance tonight',1020,NULL,0,NULL,0,NULL);
/*!40000 ALTER TABLE `phone_discord_messages` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_monthly` (
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `ym` int(11) NOT NULL,
  `cnt` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`server_id`,`identifier`,`ym`),
  CONSTRAINT `fk_discord_monthly_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_monthly` WRITE;
/*!40000 ALTER TABLE `phone_discord_monthly` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_monthly` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_mutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_mutes` (
  `identifier` varchar(60) NOT NULL,
  `kind` varchar(8) NOT NULL,
  `target_id` int(11) NOT NULL,
  PRIMARY KEY (`identifier`,`kind`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_mutes` WRITE;
/*!40000 ALTER TABLE `phone_discord_mutes` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_mutes` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_profiles` (
  `identifier` varchar(60) NOT NULL,
  `discriminator` varchar(4) NOT NULL,
  `bio` varchar(190) NOT NULL DEFAULT '',
  `status` varchar(10) NOT NULL DEFAULT 'online',
  `custom_status` varchar(60) NOT NULL DEFAULT '',
  `banner_color` varchar(20) NOT NULL DEFAULT '#5865F2',
  `show_phone` tinyint(1) NOT NULL DEFAULT 1,
  `show_job` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `avatar_url` varchar(500) DEFAULT NULL,
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_profiles` WRITE;
/*!40000 ALTER TABLE `phone_discord_profiles` DISABLE KEYS */;
INSERT INTO `phone_discord_profiles` VALUES
('steam:a','1049','','online','','#5865F2',1,1,0,0,0,NULL,1),
('steam:b','1049','','online','','#5865F2',1,1,0,0,0,NULL,2),
('steam:c','1049','','online','','#5865F2',1,1,0,0,0,NULL,3);
/*!40000 ALTER TABLE `phone_discord_profiles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_reactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_reactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `emoji` varchar(16) NOT NULL,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `message_identifier_emoji` (`message_id`,`identifier`,`emoji`),
  CONSTRAINT `fk_discord_reactions_message` FOREIGN KEY (`message_id`) REFERENCES `phone_discord_messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_reactions` WRITE;
/*!40000 ALTER TABLE `phone_discord_reactions` DISABLE KEYS */;
INSERT INTO `phone_discord_reactions` VALUES
(1,1,'steam:a','ðŸ‘',1);
/*!40000 ALTER TABLE `phone_discord_reactions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `message_text` varchar(400) NOT NULL DEFAULT '',
  `author_identifier` varchar(60) NOT NULL,
  `author_name` varchar(60) NOT NULL DEFAULT '',
  `reporter_identifier` varchar(60) NOT NULL,
  `reporter_name` varchar(60) NOT NULL DEFAULT '',
  `reason` varchar(150) NOT NULL DEFAULT '',
  `status` varchar(12) NOT NULL DEFAULT 'pending',
  `handled_by` varchar(60) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `handled_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `one_report_each` (`message_id`,`reporter_identifier`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_reports` WRITE;
/*!40000 ALTER TABLE `phone_discord_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_reports` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `color` varchar(9) DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT 1,
  `perms` text NOT NULL,
  `mentionable` tinyint(1) NOT NULL DEFAULT 0,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `hoist` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `server_id` (`server_id`),
  CONSTRAINT `fk_discord_roles_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_roles` WRITE;
/*!40000 ALTER TABLE `phone_discord_roles` DISABLE KEYS */;
INSERT INTO `phone_discord_roles` VALUES
(100,1,'@everyone',NULL,0,'{\"view\":true,\"send\":true,\"react\":true}',0,1,0),
(101,2,'@everyone',NULL,0,'{\"view\":true,\"send\":true,\"react\":true}',0,1,0);
/*!40000 ALTER TABLE `phone_discord_roles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_rules_accept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_rules_accept` (
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `accepted_at` int(11) NOT NULL,
  PRIMARY KEY (`server_id`,`identifier`),
  CONSTRAINT `fk_discord_ra_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_rules_accept` WRITE;
/*!40000 ALTER TABLE `phone_discord_rules_accept` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_rules_accept` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_seen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_seen` (
  `identifier` varchar(60) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `last_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`,`channel_id`),
  KEY `fk_discord_seen_channel` (`channel_id`),
  CONSTRAINT `fk_discord_seen_channel` FOREIGN KEY (`channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_seen` WRITE;
/*!40000 ALTER TABLE `phone_discord_seen` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_seen` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `icon_text` varchar(4) NOT NULL DEFAULT 'D',
  `icon_color` varchar(20) NOT NULL DEFAULT '#5865F2',
  `owner_identifier` varchar(60) NOT NULL,
  `invite_code` varchar(10) NOT NULL,
  `created_at` int(11) NOT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 0,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `kind` varchar(10) DEFAULT NULL,
  `auto_key` varchar(60) DEFAULT NULL,
  `theme_color` varchar(9) DEFAULT NULL,
  `vip_until` int(11) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `welcome_title` varchar(60) DEFAULT NULL,
  `welcome_text` varchar(400) DEFAULT NULL,
  `rules_text` varchar(800) DEFAULT NULL,
  `require_rules` tinyint(1) NOT NULL DEFAULT 0,
  `rules_since` int(11) DEFAULT NULL,
  `vanity` varchar(30) DEFAULT NULL,
  `icon_url` varchar(500) DEFAULT NULL,
  `category` varchar(20) NOT NULL DEFAULT 'community',
  PRIMARY KEY (`id`),
  UNIQUE KEY `invite_code` (`invite_code`),
  UNIQUE KEY `auto_key` (`auto_key`),
  UNIQUE KEY `vanity` (`vanity`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_servers` WRITE;
/*!40000 ALTER TABLE `phone_discord_servers` DISABLE KEYS */;
INSERT INTO `phone_discord_servers` VALUES
(1,'Narges RolePlay','NR','#5865F2','steam:a','KX93PQ',0,1,1,0,NULL,NULL,NULL,NULL,'The home of the community.',NULL,NULL,NULL,0,NULL,NULL,NULL,'roleplay'),
(2,'Private Club','PC','#ED4245','steam:b','ZZ1QWE',0,0,0,0,NULL,NULL,NULL,NULL,'Friends only.',NULL,NULL,NULL,0,NULL,NULL,NULL,'community');
/*!40000 ALTER TABLE `phone_discord_servers` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_stage_speakers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_stage_speakers` (
  `channel_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  PRIMARY KEY (`channel_id`,`identifier`),
  CONSTRAINT `fk_discord_ss_channel` FOREIGN KEY (`channel_id`) REFERENCES `phone_discord_channels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_stage_speakers` WRITE;
/*!40000 ALTER TABLE `phone_discord_stage_speakers` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_stage_speakers` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(40) NOT NULL,
  `description` varchar(120) NOT NULL DEFAULT '',
  `creator_identifier` varchar(60) NOT NULL,
  `creator_name` varchar(60) NOT NULL DEFAULT '',
  `data` mediumtext NOT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `uses` int(11) NOT NULL DEFAULT 0,
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_templates` WRITE;
/*!40000 ALTER TABLE `phone_discord_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_templates` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_timeouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_timeouts` (
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `until_at` int(11) NOT NULL,
  `reason` varchar(120) NOT NULL DEFAULT '',
  `by_name` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`server_id`,`identifier`),
  CONSTRAINT `fk_discord_timeouts_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_timeouts` WRITE;
/*!40000 ALTER TABLE `phone_discord_timeouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_timeouts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_warns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `reason` varchar(150) NOT NULL DEFAULT '',
  `by_name` varchar(60) NOT NULL DEFAULT '',
  `created_at` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `server_member` (`server_id`,`identifier`),
  CONSTRAINT `fk_discord_warns_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_warns` WRITE;
/*!40000 ALTER TABLE `phone_discord_warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_warns` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `phone_discord_xp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone_discord_xp` (
  `server_id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `xp` int(11) NOT NULL DEFAULT 0,
  `messages` int(11) NOT NULL DEFAULT 0,
  `last_xp_at` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`server_id`,`identifier`),
  KEY `leaderboard` (`server_id`,`xp`),
  CONSTRAINT `fk_discord_xp_server` FOREIGN KEY (`server_id`) REFERENCES `phone_discord_servers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `phone_discord_xp` WRITE;
/*!40000 ALTER TABLE `phone_discord_xp` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_discord_xp` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `identifier` varchar(60) NOT NULL,
  `license` varchar(80) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('steam:a','lic:a','Arshia','Mtz',NULL),
('steam:b','lic:b','Sam','Carter',NULL),
('steam:c','lic:c','Eve','Stranger',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

