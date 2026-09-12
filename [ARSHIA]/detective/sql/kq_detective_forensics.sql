-- kq_detective forensics — required items.
-- Run this once against your `essentialmode` database.
-- (Schema matches your existing `items` table: name, label, limit, rare, can_remove.)

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('evidence_print', 'Fingerprint Sample', 20, 0, 1),
('evidence_casing', 'Shell Casing', 20, 0, 1),
('kit_azmayeshi', 'Kit Azmayeshi', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
