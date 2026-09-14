-- ---------------------------------------------------------------
-- Report System (سیستم ریپورت) - merged into Unique_AdminPanel
-- این فایل رو یک بار روی دیتابیس essentialmode ایمپورت کن.
-- (قبلا PNG_reports.sql بود، جدول از png_report به reports تغییر اسم داد)
-- ---------------------------------------------------------------

ALTER TABLE `users` ADD COLUMN `png_admin_xp` INT(255) DEFAULT "0";

CREATE TABLE IF NOT EXISTS `reports` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `sub` longtext DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `identifier` longtext DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `admin` longtext DEFAULT NULL,
  `chat` longtext DEFAULT NULL,
  `created_at` INT(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
