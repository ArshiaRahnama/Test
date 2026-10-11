-- Discord app v25 (Unique_Phone): avatar effects. Safe to re-run.
ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `avatar_effect` VARCHAR(12) DEFAULT NULL;
