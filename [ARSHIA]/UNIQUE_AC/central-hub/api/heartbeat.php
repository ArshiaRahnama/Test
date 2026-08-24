<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
    hub_json(['ok' => false, 'error' => 'POST only'], 405);
}

$body = json_decode(file_get_contents('php://input'), true);
if (!is_array($body)) {
    hub_json(['ok' => false, 'error' => 'Invalid JSON body'], 400);
}

$licenseKey = trim((string)($body['license_key'] ?? ''));
if ($licenseKey === '') {
    hub_json(['ok' => false, 'error' => 'license_key required'], 400);
}

$license = hub_valid_license($licenseKey);
if (!$license) {
    hub_json(['ok' => false, 'error' => 'Invalid, inactive, or expired license key'], 403);
}

if (!hub_rate_limit('heartbeat:' . $licenseKey, 10, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded — heartbeats should be sent about once a minute'], 429);
}

$serverName = trim((string)($body['server_name'] ?? 'Unnamed Server'));
$serverName = mb_substr($serverName === '' ? 'Unnamed Server' : $serverName, 0, 128);

try {
    $db = hub_db();

    // Enforce max_servers per license: count distinct server_names already
    // registered under this key; if this is a NEW one and we're at the cap, reject.
    $existing = $db->prepare('SELECT id, last_status FROM servers WHERE license_key = :k AND server_name = :n LIMIT 1');
    $existing->execute([':k' => $licenseKey, ':n' => $serverName]);
    $existingRow = $existing->fetch();

    if (!$existingRow) {
        $count = $db->prepare('SELECT COUNT(*) AS c FROM servers WHERE license_key = :k');
        $count->execute([':k' => $licenseKey]);
        $c = (int)$count->fetch()['c'];
        if ($c >= (int)$license['max_servers']) {
            hub_json(['ok' => false, 'error' => 'This license key has reached its server limit'], 403);
        }
    }

    $stmt = $db->prepare('
        INSERT OR IGNORE INTO servers (license_key, server_name, version, player_count, max_players, quarantine_count, appeal_count, ban_count_total, avg_frame_drift_ms, uptime_seconds, resource_count, last_heartbeat_at, created_at)
        VALUES (:key, :name, :version, :players, :maxplayers, :quarantine, :appeals, :bans, :drift, :uptime, :resources, :now, :now)
    ');
    $stmt->execute([
        ':key' => $licenseKey,
        ':name' => $serverName,
        ':version' => mb_substr((string)($body['version'] ?? ''), 0, 32),
        ':players' => (int)($body['player_count'] ?? 0),
        ':maxplayers' => (int)($body['max_players'] ?? 0),
        ':quarantine' => (int)($body['quarantine_count'] ?? 0),
        ':appeals' => (int)($body['appeal_count'] ?? 0),
        ':bans' => (int)($body['ban_count_total'] ?? 0),
        ':drift' => (int)($body['avg_frame_drift_ms'] ?? 0),
        ':uptime' => (int)($body['uptime_seconds'] ?? 0),
        ':resources' => (int)($body['resource_count'] ?? 0),
        ':now' => hub_now(),
    ]);

    $update = $db->prepare('
        UPDATE servers SET
            version = :version, player_count = :players, max_players = :maxplayers,
            quarantine_count = :quarantine, appeal_count = :appeals, ban_count_total = :bans,
            avg_frame_drift_ms = :drift, uptime_seconds = :uptime, resource_count = :resources,
            last_heartbeat_at = :now, last_status = :status
        WHERE license_key = :key AND server_name = :name
    ');
    $update->execute([
        ':key' => $licenseKey,
        ':name' => $serverName,
        ':version' => mb_substr((string)($body['version'] ?? ''), 0, 32),
        ':players' => (int)($body['player_count'] ?? 0),
        ':maxplayers' => (int)($body['max_players'] ?? 0),
        ':quarantine' => (int)($body['quarantine_count'] ?? 0),
        ':appeals' => (int)($body['appeal_count'] ?? 0),
        ':bans' => (int)($body['ban_count_total'] ?? 0),
        ':drift' => (int)($body['avg_frame_drift_ms'] ?? 0),
        ':uptime' => (int)($body['uptime_seconds'] ?? 0),
        ':resources' => (int)($body['resource_count'] ?? 0),
        ':now' => hub_now(),
        ':status' => 'online',
    ]);

    if ($existingRow && ($existingRow['last_status'] ?? 'online') === 'offline') {
        hub_notify_discord("🟢 **{$serverName}** is back online.");
    }

    hub_json(['ok' => true]);
} catch (Throwable $e) {
    hub_json(['ok' => false, 'error' => 'Internal error'], 500);
}
