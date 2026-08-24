<?php
declare(strict_types=1);

// ============================================================================
//  UNIQUE_AC Central Hub — configuration
//
//  Don't hand-edit the values below directly — run install.php once instead,
//  it writes your answers into local-config.php (never touched again after
//  install). This file only supplies safe fallback defaults for anything
//  local-config.php doesn't set.
// ============================================================================

if (file_exists(__DIR__ . '/local-config.php')) {
    require __DIR__ . '/local-config.php';
}

if (!defined('HUB_DB_PATH')) {
    // Keep it OUTSIDE the public web root if you can — if it must stay inside
    // (shared hosting with one folder), the .htaccess here blocks direct
    // web access to *.db files.
    define('HUB_DB_PATH', __DIR__ . '/hub.db');
}

if (!defined('HUB_ADMIN_PASSWORD')) {
    define('HUB_ADMIN_PASSWORD', 'change-me-now');
}

if (!defined('HUB_DISCORD_WEBHOOK')) {
    // Used for "urgent" pushes (server offline, important Quarantine) — the
    // closest reliable equivalent to a phone push notification, since
    // Discord's mobile app already delivers real push for messages.
    define('HUB_DISCORD_WEBHOOK', '');
}

if (!defined('HUB_OFFLINE_THRESHOLD')) {
    define('HUB_OFFLINE_THRESHOLD', 180); // seconds without a heartbeat before "offline"
}

if (!defined('HUB_BRAND_NAME')) {
    define('HUB_BRAND_NAME', 'UNIQUE_AC');
}

if (!defined('HUB_BRAND_URL')) {
    define('HUB_BRAND_URL', 'https://arshiahub.ir');
}
