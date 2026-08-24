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

if (!hub_rate_limit('check-ban:' . $licenseKey, 120, 60)) {
    hub_json(['ok' => false, 'error' => 'Rate limit exceeded'], 429);
}

$identifier = trim((string)($body['identifier'] ?? ''));
if ($identifier === '') {
    hub_json(['ok' => false, 'error' => 'identifier required'], 400);
}

$stmt = hub_db()->prepare('SELECT reason, source_server, created_at FROM shared_bans WHERE license_key = :k AND identifier = :id ORDER BY id DESC LIMIT 1');
$stmt->execute([':k' => $licenseKey, ':id' => $identifier]);
$row = $stmt->fetch();

hub_json(['ok' => true, 'found' => (bool)$row, 'match' => $row ?: null]);
