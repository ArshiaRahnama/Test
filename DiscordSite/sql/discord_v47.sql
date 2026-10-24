-- Discord app v47 (Unique_Phone): "Pause Invites" (Security Actions). Safe to re-run.
ALTER TABLE `phone_discord_servers` ADD COLUMN IF NOT EXISTS `invites_paused_until` INT(11) DEFAULT NULL;
