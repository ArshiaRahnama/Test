-- Discord app v15 (Unique_Phone): profile banner image. Safe to re-run.
ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `banner_url` VARCHAR(500) DEFAULT NULL;
