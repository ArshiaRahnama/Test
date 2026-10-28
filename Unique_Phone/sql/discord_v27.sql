-- Discord app v27 (Unique_Phone): private role channels (10) and super reactions (11). Safe to re-run.
ALTER TABLE `phone_discord_reactions`
  ADD COLUMN IF NOT EXISTS `is_super` TINYINT(1) NOT NULL DEFAULT 0;
