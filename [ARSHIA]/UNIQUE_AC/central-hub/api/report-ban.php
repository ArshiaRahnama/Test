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
$license = $licenseKey !== '' ? hub_valid_license($licenseKey) : null;
if (!$license) {
    hub_json(['ok' => false, 'error' => 'Invalid, inactive, or expired license key'], 403);
}

if (!hub_rate_limit('report-ban:' . $licenseKey, 30, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded'], 429);
}

$identifier = trim((string)($body['identifier'] ?? ''));
if ($identifier === '') {
    hub_json(['ok' => false, 'error' => 'identifier required'], 400);
}
$reason = mb_substr(trim((string)($body['reason'] ?? '')), 0, 300);
$serverName = mb_substr(trim((string)($body['server_name'] ?? 'Unnamed Server')) ?: 'Unnamed Server', 0, 128);

$stmt = hub_db()->prepare('INSERT INTO shared_bans (license_key, identifier, reason, source_server, created_at) VALUES (:k, :id, :reason, :server, :now)');
$stmt->execute([':k' => $licenseKey, ':id' => $identifier, ':reason' => $reason, ':server' => $serverName, ':now' => hub_now()]);

hub_json(['ok' => true]);
