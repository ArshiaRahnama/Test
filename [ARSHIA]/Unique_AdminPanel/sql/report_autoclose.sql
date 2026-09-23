-- ===========================================================================
--  Unique RP - Report System | sql/report_autoclose.sql
--  arshiahub.ir
--  Run once. Permanent audit trail of reports that were auto-closed because
--  no admin followed up in time - stays queryable even after the on-duty
--  admins who missed it have logged off, so senior ranks can review it later.
-- ===========================================================================

CREATE TABLE IF NOT EXISTS `report_autoclose_log` (
  `id`                   INT(11)      NOT NULL AUTO_INCREMENT,
  `report_id`            BIGINT(20)   NOT NULL,
  `title`                VARCHAR(255) DEFAULT NULL,
  `category`             VARCHAR(32)  DEFAULT NULL,
  `reporter_identifier`  VARCHAR(64)  DEFAULT NULL,
  `minutes_open`         INT(11)      DEFAULT 0,
  `reviewed`             TINYINT(1)   DEFAULT 0,   -- senior admin marks this once they've looked into why it was missed
  `reviewed_by`          VARCHAR(128) DEFAULT NULL,
  `closed_at`            INT(11)      DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_report`   (`report_id`),
  KEY `idx_reviewed` (`reviewed`),
  KEY `idx_closed`   (`closed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
