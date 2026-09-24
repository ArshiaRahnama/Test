-- =====================================================================
--  Unique RP — Website Database (database.sql)
--  این فایل رو داخل دیتابیس اصلی سرورت (همون‌جایی که جداول ESX مثل
--  users و gangs هستن) ایمپورت کن. جداول سایت با پیشوند web_ ساخته
--  می‌شن تا هیچ‌وقت با جداول واقعی گیم تداخل پیدا نکنن.
--
--  توجه: اگه lib.php رو با اطلاعات دیتابیس واقعیت تنظیم کرده باشی،
--  خود سایت این جدول‌ها رو در اولین اجرا خودکار می‌سازه؛ این فایل
--  فقط برای کسایی هست که می‌خوان دستی از phpMyAdmin/HeidiSQL ایمپورت کنن.
-- =====================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- حساب‌های کاربری سایت (ثبت‌نام/ورود با شماره موبایل)
CREATE TABLE IF NOT EXISTS `web_accounts` (
  `id`       INT AUTO_INCREMENT PRIMARY KEY,
  `phone`    VARCHAR(190) NOT NULL UNIQUE,
  `pass`     VARCHAR(190) NOT NULL,
  `fullname` VARCHAR(190) NOT NULL,
  `gender`   VARCHAR(190) NOT NULL,
  `level`    INT NOT NULL DEFAULT 1,
  `acc`      VARCHAR(190) NOT NULL,
  `cid`      VARCHAR(190) NOT NULL,
  `role`     VARCHAR(190) NOT NULL DEFAULT 'user',
  `created`  INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- تیکت‌های پشتیبانی سایت
CREATE TABLE IF NOT EXISTS `web_tickets` (
  `id`      INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `subject` VARCHAR(190) NOT NULL,
  `status`  VARCHAR(190) NOT NULL,
  `created` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- پیام‌های هر تیکت
CREATE TABLE IF NOT EXISTS `web_msgs` (
  `id`        INT AUTO_INCREMENT PRIMARY KEY,
  `ticket_id` INT NOT NULL,
  `user_id`   INT NOT NULL,
  `body`      TEXT NOT NULL,
  `created`   INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================
--  این جداول رو نساز — سایت الان مستقیم از این جداولِ *واقعیِ* سرورت
--  می‌خونه (باید از قبل روی همین دیتابیس موجود باشن):
--    users(identifier, firstname, lastname, level, playtime, job,
--          `group`, last_seen, ...)   -> شهروندان، برترین‌ها، دپارتمان‌ها، کادر
--    gangs(name, level, disband)      -> بخش عضوگیری/گنگ‌ها
--  اگه اسم دیتابیس یا ستون‌ها روی سرور خودت فرق داره، در lib.php
--  بخش CFG['mysql'] و تابع site_stats() رو مطابق شماتیک خودت تنظیم کن.
-- =====================================================================
