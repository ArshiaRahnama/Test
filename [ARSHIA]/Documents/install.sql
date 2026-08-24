-- UNIQUE RP — OFFICIAL DOCUMENTS — run this once before starting the resource.
-- (Server.lua also creates these automatically on first start, this file
-- is just here if you prefer to run migrations by hand.)

CREATE TABLE IF NOT EXISTS `sunset_doc_models` (
    `id`         INT NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(100) NOT NULL,
    `date`       VARCHAR(50)  DEFAULT '',
    `title`      VARCHAR(150) DEFAULT '',
    `text`       LONGTEXT,
    `images`     LONGTEXT,
    `signatures` LONGTEXT,
    `creator`    VARCHAR(64)  DEFAULT NULL,
    `created_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `sunset_documents` (
    `id`         INT NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(100) NOT NULL,
    `model_id`   INT          DEFAULT NULL,
    `date`       VARCHAR(50)  DEFAULT '',
    `title`      VARCHAR(150) DEFAULT '',
    `text`       LONGTEXT,
    `images`     LONGTEXT,
    `signatures` LONGTEXT,
    `closed`     TINYINT(1)   NOT NULL DEFAULT 0,
    `is_copy`    TINYINT(1)   NOT NULL DEFAULT 0,
    `creator`    VARCHAR(64)  DEFAULT NULL,
    `owner`      VARCHAR(64)  DEFAULT NULL,
    `created_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- NOTE: Server.lua now runs this migration automatically on every start
-- (safe to run repeatedly, and prints [Documents] log lines showing
-- what it did) — you don't need to run this by hand.
ALTER TABLE `sunset_documents` ADD COLUMN IF NOT EXISTS `is_copy` TINYINT(1) NOT NULL DEFAULT 0;
UPDATE `sunset_documents` SET `is_copy` = 1, `closed` = 1 WHERE `name` LIKE '%کپی برابر اصل%' AND `is_copy` = 0;
