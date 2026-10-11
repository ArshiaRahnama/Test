-- Discord app v12 (Unique_Phone): channel topics. Safe to re-run.
ALTER TABLE `phone_discord_channels`
  ADD COLUMN IF NOT EXISTS `topic` VARCHAR(200) DEFAULT NULL;
