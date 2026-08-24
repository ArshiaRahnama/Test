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

if (!hub_rate_limit('urgent:' . $licenseKey, 20, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded'], 429);
}

$serverName = mb_substr(trim((string)($body['server_name'] ?? 'Unnamed Server')) ?: 'Unnamed Server', 0, 128);
$kind = mb_substr(trim((string)($body['kind'] ?? 'event')), 0, 32);
$message = mb_substr(trim((string)($body['message'] ?? '')), 0, 500);

if ($message === '') {
    hub_json(['ok' => false, 'error' => 'message required'], 400);
}

try {
    $stmt = hub_db()->prepare('INSERT INTO urgent_events (license_key, server_name, kind, message, created_at) VALUES (:key, :name, :kind, :msg, :now)');
    $stmt->execute([
        ':key' => $licenseKey, ':name' => $serverName, ':kind' => $kind,
        ':msg' => $message, ':now' => hub_now(),
    ]);

    $icon = $kind === 'offline' ? '🔴' : ($kind === 'offline_recovered' ? '🟢' : '⚠️');
    hub_notify_discord("{$icon} **{$serverName}**: {$message}");

    hub_json(['ok' => true]);
} catch (Throwable $e) {
    hub_json(['ok' => false, 'error' => 'Internal error'], 500);
}
