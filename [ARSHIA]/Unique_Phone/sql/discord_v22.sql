-- Discord app v22 (Unique_Phone): server tags (Discover) and role icons. Safe to re-run.
ALTER TABLE `phone_discord_servers`
  ADD COLUMN IF NOT EXISTS `tags` VARCHAR(120) DEFAULT NULL;
ALTER TABLE `phone_discord_roles`
  ADD COLUMN IF NOT EXISTS `icon` VARCHAR(16) DEFAULT NULL;
