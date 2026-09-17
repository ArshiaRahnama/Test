-- ===========================================================================
--  Unique RP - Report System  |  arshiahub.ir
--  یک بار روی دیتابیس essentialmode اجرا کن.
--  روی نصب تازه و روی نصب قدیمی (PNG) هردو کار میکنه.
--
--  ⚠ از این نسخه به بعد لازم نیست هر آپدیت رو دوباره اینجا رو دستی اجرا
--  کنی: server/report_schema_guard.lua خودش موقعِ استارتِ ریسورس چک
--  میکنه چه ستون/جدولی کمه و خودش اضافه‌ش میکنه. این فایل رو فقط برای
--  نصبِ اولیه (ساختِ خودِ جدولِ reports) لازم داری.
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

-- ===========================================================================
--  گسترش: هدف ریپورت + هوش پنل + یادداشت شیفت + لجر XP + استریک
-- ===========================================================================

-- تا الان `reports.identifier` فقط گزارش‌دهنده بود - هیچ ستونی برای «کی رو
-- داری گزارش میدی» نبود. server/risk_score.lua خودش همین محدودیت رو تو
-- کامنتش نوشته بود: «قبلاً inclusion این signal رو نداشتیم چون فیلدِ
-- target روی تیکت نبود». این سه ستون همون چیزیه که کم بود:
ALTER TABLE `reports` ADD COLUMN `target_identifier` VARCHAR(64)  DEFAULT NULL;
ALTER TABLE `reports` ADD COLUMN `target_name`       VARCHAR(128) DEFAULT NULL;
ALTER TABLE `reports` ADD COLUMN `admin_note`         TEXT        DEFAULT NULL;

ALTER TABLE `reports` ADD INDEX `idx_target_created` (`target_identifier`, `created_at`);

-- لجرِ XP: تا الان XP فقط یک عدد جمع‌شونده روی users.unique_admin_xp بود،
-- بدون تاریخ. یعنی «چقدر XP این ماه گرفتی» اصلاً قابل محاسبه نبود. از الان
-- هر تغییر XP یک ردیف اینجا هم می‌گیره - از این به بعد رتبه‌بندی ماهانه‌ی
-- واقعی (بر اساس XP، نه فقط تعداد تیکت) ممکن میشه. XP قدیمی‌تر از امروز
-- قابل بازیابی نیست (تو هیچ‌جای اسکیمای قبلی تاریخ نداشت).
CREATE TABLE IF NOT EXISTS `admin_xp_log` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64)  DEFAULT NULL,
  `amount`     INT(11)      DEFAULT 0,
  `reason`     VARCHAR(64)  DEFAULT NULL,
  `created_at` INT(11)      DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_identifier_created` (`identifier`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- وضعیت استریکِ هر ادمین (چند روز پشت‌سرهم بدون امتیاز زیر ۳)، تا بونس
-- XP هر آستانه فقط یک‌بار داده بشه، نه هر بار که رتبه‌بندی چک میشه.
CREATE TABLE IF NOT EXISTS `admin_streak_state` (
  `identifier`        VARCHAR(64) NOT NULL,
  `current_streak`    INT(11)     DEFAULT 0,
  `last_bonus_streak` INT(11)     DEFAULT 0,
  `updated_at`         INT(11)     DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

