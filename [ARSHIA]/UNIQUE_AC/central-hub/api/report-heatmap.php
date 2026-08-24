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

if (!hub_rate_limit('heatmap:' . $licenseKey, 60, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded'], 429);
}

$x = $body['x'] ?? null;
$y = $body['y'] ?? null;
if (!is_numeric($x) || !is_numeric($y)) {
    hub_json(['ok' => false, 'error' => 'x and y (numeric) required'], 400);
}
$reason = mb_substr(trim((string)($body['reason'] ?? '')), 0, 128);

$stmt = hub_db()->prepare('INSERT INTO heatmap_points (license_key, reason, x, y, created_at) VALUES (:k, :reason, :x, :y, :now)');
$stmt->execute([':k' => $licenseKey, ':reason' => $reason, ':x' => (float)$x, ':y' => (float)$y, ':now' => hub_now()]);

hub_json(['ok' => true]);
