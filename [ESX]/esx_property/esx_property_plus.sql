-- ============================================================
--  esx_property PLUS — SQL migration
--  این رو یکبار روی دیتابیس اجرا کن (بعد از جداول اصلی esx_property)
-- ============================================================

ALTER TABLE `owned_properties`
	ADD COLUMN IF NOT EXISTS `storage_level`      INT DEFAULT 1,
	ADD COLUMN IF NOT EXISTS `safe_level`          INT DEFAULT 1,
	ADD COLUMN IF NOT EXISTS `for_sale`            TINYINT(1) DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `sale_price`          INT DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `mortgage_active`     TINYINT(1) DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `mortgage_remaining`  INT DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `mortgage_installment` INT DEFAULT 0,
	ADD COLUMN IF NOT EXISTS `mortgage_days_left`  INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS `property_furniture` (
	`id`         INT AUTO_INCREMENT PRIMARY KEY,
	`property`   VARCHAR(60)  NOT NULL,
	`owner`      VARCHAR(60)  NOT NULL,
	`model`      VARCHAR(64)  NOT NULL,
	`x`          FLOAT NOT NULL,
	`y`          FLOAT NOT NULL,
	`z`          FLOAT NOT NULL,
	`heading`    FLOAT NOT NULL DEFAULT 0,
	`scale`      FLOAT NOT NULL DEFAULT 1.0,
	`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	INDEX (`property`)
);
