-- Copies the contacts of the old Unique_Phone (player_contacts) into the Apex Phone.
-- Run ONCE, AFTER apex_phone has started at least one time (it creates apex_phone_contacts itself).
-- Safe to re-run: a contact already present (same owner + number) is not copied again.
-- The IBAN column of the old contacts is not carried over (Apex contacts have no IBAN field).
INSERT INTO `apex_phone_contacts` (`owner`, `name`, `number`)
SELECT pc.`identifier`, LEFT(pc.`name`, 64), LEFT(pc.`number`, 20)
FROM `player_contacts` pc
WHERE pc.`identifier` IS NOT NULL AND pc.`name` <> '' AND pc.`number` <> ''
  AND NOT EXISTS (
        SELECT 1 FROM `apex_phone_contacts` a
        WHERE a.`owner` = pc.`identifier` COLLATE utf8mb4_unicode_ci
          AND a.`number` = LEFT(pc.`number`, 20) COLLATE utf8mb4_unicode_ci
  );
