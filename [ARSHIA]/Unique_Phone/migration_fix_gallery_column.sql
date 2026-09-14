-- Run this ONCE on your existing database (phpMyAdmin / HeidiSQL / mysql CLI).
-- It's needed because the phone camera now saves photos directly as base64
-- data instead of uploading to an external webhook, and the old `TEXT`
-- column (max ~64KB) is too small to reliably hold that - this widens it to
-- `LONGTEXT` (max ~4GB) so photos never get truncated or rejected.
-- Safe to run even if already applied - it just re-sets the column type.

ALTER TABLE `phone_gallery` MODIFY `image_url` LONGTEXT NOT NULL;
