<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';

hub_require_admin();

$rows = hub_db()->query('SELECT license_key, server_name, version, player_count, max_players, quarantine_count, appeal_count, ban_count_total, avg_frame_drift_ms, uptime_seconds, resource_count, last_heartbeat_at, last_status FROM servers ORDER BY server_name ASC')->fetchAll();

$now = hub_now();
foreach ($rows as &$row) {
    $row['seconds_since_heartbeat'] = $now - (int)$row['last_heartbeat_at'];
    // Mask the license key for display — full key isn't needed by the dashboard UI.
    $row['license_key'] = substr($row['license_key'], 0, 6) . '…' . substr($row['license_key'], -4);
}
unset($row);

$urgent = hub_db()->query('SELECT server_name, kind, message, created_at FROM urgent_events ORDER BY id DESC LIMIT 25')->fetchAll();

hub_json(['ok' => true, 'servers' => $rows, 'urgent' => $urgent, 'now' => $now]);
