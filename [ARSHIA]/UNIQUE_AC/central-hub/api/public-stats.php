<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';

// Public, read-only, rate-limited by IP. Returns the exact same aggregate, fully
// anonymized numbers shown on showcase.php — no player names, server names, or
// license keys. Intended for third-party sites that want to display "powered by
// UNIQUE_AC" style stats.

header('Access-Control-Allow-Origin: *');

if (!hub_rate_limit('public-api:' . hub_client_ip(), 30, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded — max 30 requests per minute per IP'], 429);
}

$db = hub_db();
$totalServers = (int)$db->query("SELECT COUNT(*) AS c FROM servers")->fetch()['c'];
$onlineServers = (int)$db->query("SELECT COUNT(*) AS c FROM servers WHERE last_status = 'online' AND last_heartbeat_at > " . (hub_now() - HUB_OFFLINE_THRESHOLD))->fetch()['c'];
$totalBans = (int)$db->query("SELECT COALESCE(SUM(ban_count_total),0) AS c FROM servers")->fetch()['c'];
$totalQuarantines = (int)$db->query("SELECT COALESCE(SUM(quarantine_count),0) AS c FROM servers")->fetch()['c'];
$totalPlayersNow = (int)$db->query("SELECT COALESCE(SUM(player_count),0) AS c FROM servers WHERE last_status = 'online'")->fetch()['c'];

hub_json([
    'ok' => true,
    'brand' => HUB_BRAND_NAME,
    'servers_protected' => $totalServers,
    'servers_online' => $onlineServers,
    'players_online_now' => $totalPlayersNow,
    'cheaters_removed' => $totalBans,
    'cases_reviewed' => $totalQuarantines,
    'generated_at' => hub_now(),
]);
