-- Unique_Login — run this once before starting the resource.

CREATE TABLE IF NOT EXISTS `login_users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `password` char(64) NOT NULL, -- SHA2-256 hex digest, never plaintext
  `phone` varchar(32) DEFAULT NULL,
  `license` varchar(128) NOT NULL,
  -- EXPANSION: the real FiveM `license:` identifier of the device that most
  -- recently logged into this account. Lets playerConnecting auto-login
  -- returning players (same PC) without showing the panel again.
  `device_license` varchar(128) DEFAULT NULL,
  -- EXPANSION: set to 1 when this account logs in from several distinct
  -- new devices in a short window (see Config.SuspiciousDeviceLock) —
  -- strongly suggests the password leaked. While set, normal login is
  -- blocked; only a successful "forgot password" SMS-OTP reset clears it,
  -- which forces re-proof of phone ownership before the account is usable
  -- again.
  `security_hold` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_login_users_username` (`username`),
  UNIQUE KEY `uq_login_users_license` (`license`),
  -- EXPANSION: was a plain (non-unique) KEY before — meant two accounts
  -- could technically end up sharing one phone number under a race
  -- condition (both pass the "does this phone already exist" check before
  -- either INSERT completes). UNIQUE closes that at the DB level.
  UNIQUE KEY `uq_login_users_phone` (`phone`),
  KEY `idx_login_users_device_license` (`device_license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ─────────────────────────────────────────────────────────
-- If you already have this table from before (old installs), run this once
-- to add the new column instead of the CREATE TABLE above:
--
-- ALTER TABLE `login_users`
--   ADD COLUMN `device_license` varchar(128) DEFAULT NULL AFTER `license`,
--   ADD KEY `idx_login_users_device_license` (`device_license`);
--
-- And to add the phone UNIQUE constraint (fails if you already have
-- duplicate phone numbers — clean those up first with something like:
-- SELECT phone, COUNT(*) FROM login_users GROUP BY phone HAVING COUNT(*) > 1):
--
-- ALTER TABLE `login_users`
--   DROP KEY `idx_login_users_phone`,
--   ADD UNIQUE KEY `uq_login_users_phone` (`phone`);
--
-- And to add the suspicious-activity lock column:
--
-- ALTER TABLE `login_users`
--   ADD COLUMN `security_hold` tinyint(1) NOT NULL DEFAULT 0 AFTER `device_license`;
-- ─────────────────────────────────────────────────────────

-- EXPANSION: audit trail — every login attempt (success/fail), registration,
-- password reset, new-device, and logout-all event gets a row here. Nothing
-- in this resource reads it back except the phone's Security app; it's also
-- there so an admin panel (or a plain SELECT ... WHERE username = ?) can
-- show "recent activity" on an account, and so patterns like many failed
-- logins across many IPs are visible.
CREATE TABLE IF NOT EXISTS `login_audit` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `license` varchar(128) DEFAULT NULL,        -- this resource's own account id
  `device_license` varchar(128) DEFAULT NULL, -- real FiveM license: of the connecting device
  `ip` varchar(64) DEFAULT NULL,
  `action` enum('login_success','login_fail','register','password_reset','new_device','logout_all','password_change','security_hold','security_hold_cleared') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_login_audit_username` (`username`),
  KEY `idx_login_audit_device_license` (`device_license`),
  KEY `idx_login_audit_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- If you already have this table from before (old installs), run this once
-- to add the new enum value instead of the CREATE TABLE above:
--
-- ALTER TABLE `login_audit`
--   MODIFY COLUMN `action` enum('login_success','login_fail','register','password_reset','new_device','logout_all','password_change','security_hold','security_hold_cleared') NOT NULL;
