-- Adds the columns the new license menu needs to the user_licenses table that
-- your existing esx_license / givelicense system already uses. This ONLY adds
-- columns (all nullable/defaulted) - it does not touch or rename `type` or
-- `owner`, so /givelicense, /removelicense and the esx_license:* events keep
-- working exactly as they do today.

ALTER TABLE `user_licenses`
    ADD COLUMN IF NOT EXISTS `expire`      INT  NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS `granted_by`  VARCHAR(100) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `description` TEXT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `created_at`  INT NOT NULL DEFAULT 0;

-- Your F6 "Manage License" feature (esx_uniquejobs) is ALREADY wired up for
-- every job, including cid/marshal/doa/judge - see the chat reply, nothing
-- needed to be added there. BUT it reads player licenses through the OLD
-- license-sv.lua, which looks up each license's label in this separate
-- `licenses` table. That table currently only has 5 rows (dmv, drive,
-- drive_bike, drive_truck, weapon). If a staff member opens F6 -> Manage
-- License on a player who was given one of the NEW license types below (via
-- /license or /managelicense), the lookup finds no row and the old code
-- crashes trying to read a label that doesn't exist. These REPLACE INTO rows
-- prevent that by giving every new type a label in the old table too.
REPLACE INTO `licenses` (`type`, `label`) VALUES
    ('drive_1', 'GovahiName Mashin'),
    ('drive_2', 'GovahiName Motor'),
    ('drive_3', 'GovahiName Kamiun'),
    ('drive_4', 'Ayin Name Ranandegi'),
    ('drive_5', 'GovahiName khalabani'),
    ('drive_6', 'GovahiName Ghayegh'),
    ('drive_7', 'GovahiName Heli'),
    ('hunt_l1', 'Mojaveze Shekar'),
    ('stepson_1', 'Sanade Farzand Khandegi'),
    ('marriage_1', 'Sanade Ezdevaj'),
    ('ceremony_1', 'Bargozari Marasem'),
    ('mojavezgun_1', 'Mojaveze hamle aslahe'),
    ('salamateravan', 'Govahi Salamate Ravan'),
    ('mojavezvest_1', 'Mojaveze pooshidane vest'),
    ('dys', 'Mojaveze DYS (Tirandazi dar Base Zone)');

