-- ============================================================================
-- logs — جدول ذخیره‌ی لاگ‌ها برای پنل ادمین/باس (قبلاً بخشی از ریسورس جدای
-- Unique_LogPanel بود؛ الان ادغام شده تو همین ریسورس logs)
-- این فایل رو یه‌بار روی دیتابیس سرورت اجرا کن (phpMyAdmin / HeidiSQL / adminer).
-- اگه از نسخه‌ی قبلی (Unique_LogPanel جدا) آپدیت می‌کنی و قبلاً این جدول رو
-- ساخته بودی، دوباره اجراکردن این فایل کاملاً بی‌خطره — هم CREATE و هم ALTER با
-- IF NOT EXISTS/محافظت نوشته شدن، دیتای موجودت دست‌نخورده می‌مونه.
-- ============================================================================
CREATE TABLE IF NOT EXISTS `unique_logpanel` (
  `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `category`    VARCHAR(64)   NOT NULL DEFAULT 'unknown',
  `job`         VARCHAR(64)   DEFAULT NULL,
  `title`       VARCHAR(191)  DEFAULT NULL,
  `message`     TEXT          NOT NULL,
  `source`      INT           DEFAULT NULL,
  `identifier`  VARCHAR(64)   DEFAULT NULL,
  `player_name` VARCHAR(191)  DEFAULT NULL,
  `pinned`      TINYINT(1)    NOT NULL DEFAULT 0,
  `created_at`  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category`    (`category`),
  KEY `idx_job`         (`job`),
  KEY `idx_identifier`  (`identifier`),
  KEY `idx_created_at`  (`created_at`),
  KEY `idx_player_name` (`player_name`),
  KEY `idx_job_created` (`job`, `created_at`),
  KEY `idx_pinned`      (`pinned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- اگه جدول از نسخه‌ی خیلی قدیمی از قبل بدون ستون pinned ساخته شده، این خط
-- بدون از دست رفتن دیتا اضافه‌اش می‌کنه (اگه ستون از قبل باشه، فقط یه خطای
-- بی‌ضرر «Duplicate column» می‌ده - همون خط رو نادیده بگیر):
ALTER TABLE `unique_logpanel` ADD COLUMN `pinned` TINYINT(1) NOT NULL DEFAULT 0 AFTER `player_name`;
ALTER TABLE `unique_logpanel` ADD INDEX `idx_pinned` (`pinned`);

-- توجه: پاک‌سازی خودکار لاگ‌های قدیمی داخل خودِ اسکریپت (SERVER/LogPanel.lua)
-- انجام می‌شه، با Config.RetentionDays. اگه ترجیح می‌دی این کار رو دیتابیس انجام
-- بده (نه ریسورس)، Config.RetentionDays رو صفر کن و از event زیر (با فعال‌بودن
-- event scheduler) استفاده کن:
-- SET GLOBAL event_scheduler = ON;
-- CREATE EVENT IF NOT EXISTS `unique_logpanel_cleanup`
--     ON SCHEDULE EVERY 1 DAY
--     DO DELETE FROM `unique_logpanel` WHERE `created_at` < NOW() - INTERVAL 30 DAY AND `category` <> 'logpanel_delete';
