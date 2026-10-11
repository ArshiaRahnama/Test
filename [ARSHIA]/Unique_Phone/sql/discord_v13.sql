-- Discord app v13 (Unique_Phone): Discover categories. Safe to re-run.
ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `category` VARCHAR(20) NOT NULL DEFAULT 'community';
