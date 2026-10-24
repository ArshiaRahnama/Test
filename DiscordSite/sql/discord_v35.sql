-- Discord app v35 (Unique_Phone): the ID a player chooses when creating the account. Safe to re-run.
ALTER TABLE `phone_discord_profiles`
  ADD COLUMN IF NOT EXISTS `handle` VARCHAR(20) DEFAULT NULL,
  ADD UNIQUE INDEX IF NOT EXISTS `handle_unique` (`handle`);
