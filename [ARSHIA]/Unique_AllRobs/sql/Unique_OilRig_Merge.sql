-- ============================================================
-- Unique_OilRig merge -- run this once against your database.
-- Safe to re-run (REPLACE INTO / INSERT ... ON DUPLICATE KEY).
-- ============================================================

-- ------------------------------------------------------------------
-- Pre-existing bug fix: Unique_AllRobs' Jewerlly/Life_Invader/
-- Palateo_Bank rewards already reference xpfleeca / xpjewel / xpbime /
-- xpbankp as gang-XP-card items, but none of them exist in the `items`
-- table (only xpbank/xpshop do) -- so every one of those robberies has
-- SILENTLY been failing to give that part of the reward. Add them.
-- ------------------------------------------------------------------
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `weight`) VALUES
	('xpfleeca', 'XP Fleeca Card', -1, 0, 1, 0.500),
	('xpjewel',  'XP Jewelry Card', -1, 0, 1, 0.500),
	('xpbime',   'XP Bime Card', -1, 0, 1, 0.500),
	('xpbankp',  'XP Palateo Bank Card', -1, 0, 1, 0.500);

-- ------------------------------------------------------------------
-- New items for the Oil Rig heist itself.
-- ------------------------------------------------------------------
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `weight`) VALUES
	('xprig',              'XP Oil Rig Card',  -1, 0, 1, 0.500),
	('oilrig_cash_bag',    'Kif-e Pool-e Sangin', 1, 1, 0, 8.000),
	('weapon_crate_rifle', 'Jaebe-ye Aslahe',   5, 1, 1, 12.000),
	('heavy_armor',        'Zereh-e Sangin',    5, 1, 1, 4.000),
	('oilrig_relic',       'Shiye Kamyab-e Oil Rig', -1, 1, 1, 1.000);

-- ------------------------------------------------------------------
-- §13 law code, in case esx_uniquejobs' law_codebook table was already
-- seeded before this update (DEFAULT_LAWS in law_codebook.lua only
-- inserts on a genuinely empty table). `code` has no unique index in
-- this schema, so guard with NOT EXISTS instead of ON DUPLICATE KEY --
-- safe to run this file more than once.
-- ------------------------------------------------------------------
INSERT INTO `law_codebook` (`code`, `title`, `category`, `fine`, `jail_minutes`, `updated_by`, `timestamp`)
SELECT '§13', 'Sereghat-e Mosallahane Dar Meghyas-e Bozorg (Oil Rig Heist)', 'property', 20000, 90, 'Unique_OilRig Merge', UNIX_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM `law_codebook` WHERE `code` = '§13');
