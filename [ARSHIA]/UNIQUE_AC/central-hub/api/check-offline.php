<?php
declare(strict_types=1);
// Run this on a schedule (cron every 1-2 minutes) — it can't be triggered by
// the FiveM server itself, because a crashed/offline server can't report its
// own crash. This is the only piece of the hub that needs a cron job.
//
// Example crontab line (adjust the path and PHP binary):
//   */2 * * * * php /path/to/central-hub/api/check-offline.php >/dev/null 2>&1

require_once __DIR__ . '/../lib/db.php';

// Only allow this to run from the CLI (cron), not as a public web request.
if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    echo 'This script is for cron use only.';
    exit;
}

$threshold = hub_now() - HUB_OFFLINE_THRESHOLD;
$db = hub_db();

$stmt = $db->query('SELECT license_key, server_name, last_status FROM servers WHERE last_heartbeat_at < ' . (int)$threshold . " AND last_status = 'online'");
$rows = $stmt->fetchAll();
foreach ($rows as $row) {
    $update = $db->prepare("UPDATE servers SET last_status = 'offline' WHERE license_key = :k AND server_name = :n");
    $update->execute([':k' => $row['license_key'], ':n' => $row['server_name']]);
    hub_notify_discord("🔴 **{$row['server_name']}** has stopped sending heartbeats — it may be offline.");
}

echo "Checked at " . date('Y-m-d H:i:s') . " — " . count($rows) . " servers flagged offline this run.\n";
