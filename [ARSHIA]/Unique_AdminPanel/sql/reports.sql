-- ===========================================================================
--  Unique RP - Report System  |  arshiahub.ir
--  یک بار روی دیتابیس essentialmode اجرا کن.
--  روی نصب تازه و روی نصب قدیمی (PNG) هردو کار میکنه.
-- ===========================================================================

-- --------------------------------------------------------------- reports ---
CREATE TABLE IF NOT EXISTS `reports` (
  `ID`          BIGINT(20)   NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(255) DEFAULT NULL,
  `sub`         TEXT         DEFAULT NULL,
  `category`    VARCHAR(32)  DEFAULT 'other',
  `priority`    TINYINT(2)   DEFAULT 1,
  `identifier`  VARCHAR(64)  DEFAULT NULL,
  `status`      VARCHAR(16)  DEFAULT 'pending',
  `admin`       VARCHAR(64)  DEFAULT NULL,
  `admin_name`  VARCHAR(128) DEFAULT NULL,
  `chat`        LONGTEXT     DEFAULT NULL,
  `meta`        TEXT         DEFAULT NULL,
  `rating`      TINYINT(2)   DEFAULT 0,
  `sla_warned`  TINYINT(1)   DEFAULT 0,
  `created_at`  INT(11)      DEFAULT 0,
  `accepted_at` INT(11)      DEFAULT 0,
  `closed_at`   INT(11)      DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `idx_status`     (`status`),
  KEY `idx_identifier` (`identifier`),
  KEY `idx_admin`      (`admin`),
  KEY `idx_created`    (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------- مهاجرت از اسکیمای قدیمی (PNG) ------
-- اگه جدول از قبل وجود داشته، ستون‌های جدید رو اضافه میکنیم.
-- خطای "Duplicate column name" یعنی از قبل اضافه شده؛ بی‌خطره، رد شو.

ALTER TABLE `reports` ADD COLUMN `category`    VARCHAR(32)  DEFAULT 'other';
ALTER TABLE `reports` ADD COLUMN `priority`    TINYINT(2)   DEFAULT 1;
ALTER TABLE `reports` ADD COLUMN `admin_name`  VARCHAR(128) DEFAULT NULL;
ALTER TABLE `reports` ADD COLUMN `meta`        TEXT         DEFAULT NULL;
ALTER TABLE `reports` ADD COLUMN `rating`      TINYINT(2)   DEFAULT 0;
ALTER TABLE `reports` ADD COLUMN `sla_warned`  TINYINT(1)   DEFAULT 0;
ALTER TABLE `reports` ADD COLUMN `accepted_at` INT(11)      DEFAULT 0;
ALTER TABLE `reports` ADD COLUMN `closed_at`   INT(11)      DEFAULT 0;

-- ------------------------------------------------- ستون XP روی users ------
-- نصب تازه:
ALTER TABLE `users` ADD COLUMN `unique_admin_xp` INT(11) NOT NULL DEFAULT 0;

-- اگه از نسخه PNG میای و ستون png_admin_xp داری، این خط رو به‌جای بالایی اجرا کن
-- تا XP ادمین‌ها از دست نره:
-- ALTER TABLE `users` CHANGE `png_admin_xp` `unique_admin_xp` INT(11) NOT NULL DEFAULT 0;

-- ------------------------------------------------------ جداول آماری ------
-- (اگه sql/unique_adminmenu.sql رو قبلا ایمپورت کردی، اینا از قبل هستن)

CREATE TABLE IF NOT EXISTS `admin_report_ratings` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `report_id`  VARCHAR(32)  DEFAULT NULL,
  `admin_name` VARCHAR(128) DEFAULT NULL,
  `rating`     TINYINT(2)   DEFAULT NULL,
  `created_at` DATETIME     DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_admin` (`admin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `admin_report_response_times` (
  `id`               INT(11)      NOT NULL AUTO_INCREMENT,
  `admin_name`       VARCHAR(128) DEFAULT NULL,
  `response_seconds` INT(11)      DEFAULT NULL,
  `created_at`       DATETIME     DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_admin` (`admin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------- نگاشت وضعیت‌های قدیمی به جدید (اختیاری) ------------
-- نسخه قبلی فقط pending / accept / close داشت. اگه دیتای قدیمی داری:
UPDATE `reports` SET `category` = 'other'  WHERE `category` IS NULL OR `category` = '';
UPDATE `reports` SET `priority` = 1        WHERE `priority` IS NULL OR `priority` = 0;
UPDATE `reports` SET `created_at` = UNIX_TIMESTAMP() WHERE `created_at` IS NULL OR `created_at` = 0;
