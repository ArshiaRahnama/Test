-- Discord app v23 (Unique_Phone): pin limit + newest-pinned-first ordering. Safe to re-run.
ALTER TABLE `phone_discord_messages`
  ADD COLUMN IF NOT EXISTS `pinned_at` INT(11) DEFAULT NULL;
UPDATE `phone_discord_messages` SET `pinned_at` = `created_at` WHERE `is_pinned` = 1 AND `pinned_at` IS NULL;
