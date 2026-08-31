-- ============================================================================
-- Unique_LogPanel — جدول ذخیره‌ی لاگ‌ها برای پنل ادمین/باس
-- این جدول رو یه‌بار روی دیتابیس سرورت اجرا کن (phpMyAdmin / HeidiSQL / ...)
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
  `created_at`  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category`   (`category`),
  KEY `idx_job`        (`job`),
  KEY `idx_identifier` (`identifier`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- اختیاری: پاک‌سازی خودکار لاگ‌های قدیمی‌تر از ۳۰ روز (اگه event scheduler سرورت فعاله)
-- SET GLOBAL event_scheduler = ON;
-- CREATE EVENT IF NOT EXISTS `unique_logpanel_cleanup`
--     ON SCHEDULE EVERY 1 DAY
--     DO DELETE FROM `unique_logpanel` WHERE `created_at` < NOW() - INTERVAL 30 DAY;
