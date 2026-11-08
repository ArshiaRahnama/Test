-- Discord app v26 (Unique_Phone): message requests. Safe to re-run.
-- request_state: NULL (normal DM) | 'pending' (waiting for the recipient) | 'accepted'
ALTER TABLE `phone_discord_dms`
  ADD COLUMN IF NOT EXISTS `request_state` VARCHAR(10) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `requested_by` VARCHAR(60) DEFAULT NULL;
