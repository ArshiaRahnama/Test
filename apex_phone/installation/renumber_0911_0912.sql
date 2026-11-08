-- Renumbers EXISTING phone numbers that do not start with 0911 / 0912 (e.g. the old Unique_Phone numbers like 0525xxxxxxx).
-- ⚠️ MAKE A DATABASE BACKUP FIRST. Run it ONCE, with the server STOPPED (or at least no player online).
-- Every old number gets ONE new number everywhere it is stored: accounts, SIM lines, SIM cards, Zapp/WhatsApp profile,
-- other players' contacts and block lists, and users.phone / users.phone_number. Old call/message history keeps the old number.
-- Needs MariaDB 10.2+ / MySQL 5.7+.
SET @rn := 0;
DROP TEMPORARY TABLE IF EXISTS tmp_renum;
CREATE TEMPORARY TABLE tmp_renum (old VARCHAR(20) NOT NULL PRIMARY KEY, new VARCHAR(20) NOT NULL UNIQUE);

INSERT INTO tmp_renum (old, new)
SELECT x.old,
       CONCAT(IF(MOD(x.rn, 2) = 0, '0911', '0912'),
              LPAD(MOD(x.rn * 7919 + UNIX_TIMESTAMP(), 10000000), 7, '0'))
FROM (
    SELECT n.old AS old, (@rn := @rn + 1) AS rn
    FROM (
        SELECT phone AS old FROM apex_phone_accounts WHERE phone IS NOT NULL AND phone NOT REGEXP '^091[12][0-9]{7}$'
        UNION SELECT number FROM apex_phone_lines WHERE number NOT REGEXP '^091[12][0-9]{7}$'
        UNION SELECT number FROM apex_phone_sims  WHERE number NOT REGEXP '^091[12][0-9]{7}$'
    ) n
    WHERE n.old IS NOT NULL AND n.old <> ''
) x;

UPDATE apex_phone_accounts          a JOIN tmp_renum t ON t.old = a.phone  SET a.phone  = t.new;
UPDATE apex_phone_lines             l JOIN tmp_renum t ON t.old = l.number SET l.number = t.new;
UPDATE apex_phone_sims              s JOIN tmp_renum t ON t.old = s.number SET s.number = t.new;
UPDATE apex_phone_sims_blocked      s JOIN tmp_renum t ON t.old = s.number SET s.number = t.new;
UPDATE apex_phone_recado_profiles   r JOIN tmp_renum t ON t.old = r.number SET r.number = t.new;
UPDATE apex_phone_contacts          c JOIN tmp_renum t ON t.old = c.number SET c.number = t.new;
UPDATE apex_phone_blocks            b JOIN tmp_renum t ON t.old = b.number SET b.number = t.new;
UPDATE users u JOIN tmp_renum t ON t.old = u.phone        SET u.phone        = t.new;
UPDATE users u JOIN tmp_renum t ON t.old = u.phone_number SET u.phone_number = t.new;

SELECT old AS old_number, new AS new_number FROM tmp_renum;
DROP TEMPORARY TABLE tmp_renum;
