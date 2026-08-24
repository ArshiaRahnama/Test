<?php
declare(strict_types=1);

require_once __DIR__ . '/../config.php';

function hub_db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO('sqlite:' . HUB_DB_PATH);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        $pdo->exec('PRAGMA foreign_keys = ON');
        // Every statement in schema.sql is "CREATE TABLE IF NOT EXISTS", so re-running
        // it is always safe and cheap — this lets older installs self-heal and pick up
        // new tables (like shared_bans, heatmap_points) without a manual migration step.
        $pdo->exec(file_get_contents(__DIR__ . '/../schema.sql'));

        // CREATE TABLE IF NOT EXISTS can't add columns to an already-existing table, so
        // new columns on `servers` need their own small migration here.
        $existingCols = array_column($pdo->query("PRAGMA table_info(servers)")->fetchAll(), 'name');
        $newColumns = [
            'avg_frame_drift_ms' => 'INTEGER DEFAULT 0',
            'uptime_seconds' => 'INTEGER DEFAULT 0',
            'resource_count' => 'INTEGER DEFAULT 0',
        ];
        foreach ($newColumns as $col => $definition) {
            if (!in_array($col, $existingCols, true)) {
                $pdo->exec("ALTER TABLE servers ADD COLUMN {$col} {$definition}");
            }
        }
    }
    return $pdo;
}

function hub_now(): int {
    return time();
}

function hub_require_admin(string $loginPathRelativeToCaller = 'login.php'): void {
    session_start();
    if (empty($_SESSION['hub_admin']) || $_SESSION['hub_admin'] !== true) {
        header('Location: ' . $loginPathRelativeToCaller);
        exit;
    }
}

function hub_json(array $data, int $status = 200): void {
    http_response_code($status);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

function hub_valid_license(string $key): ?array {
    $stmt = hub_db()->prepare('SELECT * FROM license_keys WHERE key_value = :k LIMIT 1');
    $stmt->execute([':k' => $key]);
    $row = $stmt->fetch();
    if (!$row) return null;
    if ((int)$row['active'] !== 1) return null;
    if ($row['expires_at'] !== null && (int)$row['expires_at'] < hub_now()) return null;
    return $row;
}

function hub_notify_discord(string $message): void {
    if (HUB_DISCORD_WEBHOOK === '' || !preg_match('#^https?://#', HUB_DISCORD_WEBHOOK)) return;
    $payload = json_encode([
        'username' => HUB_BRAND_NAME . ' Hub',
        'embeds' => [[
            'description' => $message,
            'color' => 16753920,
        ]],
    ]);
    $ch = curl_init(HUB_DISCORD_WEBHOOK);
    curl_setopt_array($ch, [
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $payload,
        CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 5,
    ]);
    curl_exec($ch);
    curl_close($ch);
}

// Simple fixed-window rate limiter. $key should already include whatever you're
// limiting by (e.g. "heartbeat:UAC-XXXX" or "ip:1.2.3.4"). Returns true if the
// request is allowed, false if the caller should be rejected with 429.
function hub_rate_limit(string $key, int $maxRequests, int $windowSeconds): bool {
    $db = hub_db();
    $now = hub_now();
    $windowStart = intdiv($now, $windowSeconds) * $windowSeconds;

    $stmt = $db->prepare('SELECT window_start, request_count FROM rate_limits WHERE bucket_key = :k');
    $stmt->execute([':k' => $key]);
    $row = $stmt->fetch();

    if (!$row || (int)$row['window_start'] !== $windowStart) {
        $upsert = $db->prepare('INSERT OR REPLACE INTO rate_limits (bucket_key, window_start, request_count) VALUES (:k, :w, 1)');
        $upsert->execute([':k' => $key, ':w' => $windowStart]);
        return true;
    }

    if ((int)$row['request_count'] >= $maxRequests) {
        return false;
    }

    $update = $db->prepare('UPDATE rate_limits SET request_count = request_count + 1 WHERE bucket_key = :k');
    $update->execute([':k' => $key]);
    return true;
}

function hub_client_ip(): string {
    return $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'] ?? 'unknown';
}
