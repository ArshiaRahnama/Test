<?php
declare(strict_types=1);
/* Discord site — shared helpers: database, session, login, CSRF. */

function dsite_cfg(string $key) { static $c = null; $c ??= require __DIR__ . '/config.php'; return $c[$key]; }

function db(): PDO {
  static $p = null;
  if ($p) return $p;
  if (dsite_cfg('driver') === 'sqlite') {
    $dir = dirname((string)dsite_cfg('sqlite_path'));
    if (!is_dir($dir)) mkdir($dir, 0750, true);
    $p = new PDO('sqlite:' . dsite_cfg('sqlite_path'));
    $p->exec('PRAGMA foreign_keys=ON');
  } else {
    $c = dsite_cfg('mysql');
    $p = new PDO("mysql:host={$c['host']};port={$c['port']};dbname={$c['db']};charset=utf8mb4", $c['user'], $c['pass'], [PDO::ATTR_TIMEOUT => 3]);
  }
  $p->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $p->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
  dsite_install($p);
  return $p;
}

/** site-only tables (the game's own tables are NOT created here) */
function dsite_install(PDO $p): void {
  static $done = false;
  if ($done) return; $done = true;
  $p->exec("CREATE TABLE IF NOT EXISTS dsite_rate(k VARCHAR(190) NOT NULL PRIMARY KEY, cnt INT NOT NULL, ws INT NOT NULL)");
  $p->exec("CREATE TABLE IF NOT EXISTS dsite_presence(identifier VARCHAR(60) NOT NULL PRIMARY KEY, last_seen INT NOT NULL)");
}

function e(string $s): string { return htmlspecialchars($s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }

function dsite_session(): void {
  if (session_status() === PHP_SESSION_ACTIVE) return;
  session_name('dsite');
  session_set_cookie_params(['lifetime' => 0, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax', 'secure' => !empty($_SERVER['HTTPS'])]);
  session_start();
}
dsite_session();

function csrf(): string { return $_SESSION['csrf'] ??= bin2hex(random_bytes(16)); }
function csrf_field(): string { return '<input type="hidden" name="csrf" value="' . e(csrf()) . '">'; }
function csrf_ok(string $token): bool { $t = $_SESSION['csrf'] ?? ''; return $t !== '' && hash_equals($t, $token); }
function go(string $url): never { header('Location: ' . $url); exit; }

function game_hash(string $pass, string $salt): string { return hash('sha256', $pass . $salt); }

/* rate limit: returns true when the key is currently locked out */
function rate_locked(string $key): bool {
  $r = db()->prepare('SELECT cnt, ws FROM dsite_rate WHERE k = ?'); $r->execute([$key]); $row = $r->fetch();
  return $row && (int)$row['cnt'] >= (int)dsite_cfg('login_max_fail') && time() - (int)$row['ws'] < (int)dsite_cfg('login_window');
}
function rate_fail(string $key): void {
  $r = db()->prepare('SELECT cnt, ws FROM dsite_rate WHERE k = ?'); $r->execute([$key]); $row = $r->fetch();
  $win = (int)dsite_cfg('login_window');
  if (!$row || time() - (int)$row['ws'] >= $win) {
    db()->prepare('DELETE FROM dsite_rate WHERE k = ?')->execute([$key]);
    db()->prepare('INSERT INTO dsite_rate(k, cnt, ws) VALUES (?, 1, ?)')->execute([$key, time()]);
  } else {
    db()->prepare('UPDATE dsite_rate SET cnt = cnt + 1 WHERE k = ?')->execute([$key]);
  }
}
function rate_clear(string $key): void { db()->prepare('DELETE FROM dsite_rate WHERE k = ?')->execute([$key]); }

function phone10(string $raw): ?string {
  $d = preg_replace('/\D/', '', strtr($raw, ['۰'=>'0','۱'=>'1','۲'=>'2','۳'=>'3','۴'=>'4','۵'=>'5','۶'=>'6','۷'=>'7','۸'=>'8','۹'=>'9']));
  return preg_match('/^0?9\d{9}$/', $d) ? '9' . substr($d, -9) : null;
}

/**
 * Logs in with the SAME username/phone and password as the game (login_users table).
 * Returns the user row on success, null (and $err) otherwise.
 */
function game_login(string $ident, string $pass, ?string &$err = null): ?array {
  $ip = $_SERVER['REMOTE_ADDR'] ?? '0';
  $ident = trim($ident);
  if ($ident === '' || $pass === '') { $err = 'Enter your username and password.'; return null; }
  if (rate_locked('lf-user:' . strtolower($ident)) || rate_locked("lf-ip:$ip")) { $err = 'Too many failed attempts. Try again in 15 minutes.'; return null; }
  $u = null;
  $q = db()->prepare('SELECT * FROM login_users WHERE username = ? LIMIT 1'); $q->execute([$ident]); $u = $q->fetch() ?: null;
  if (!$u && ($ph = phone10($ident))) {
    // the game may store the number as 9xxxxxxxx (10 digits) or 09xxxxxxxx (11 digits): try both forms
    $digits = preg_replace('/\D/', '', strtr($ident, ['۰'=>'0','۱'=>'1','۲'=>'2','۳'=>'3','۴'=>'4','۵'=>'5','۶'=>'6','۷'=>'7','۸'=>'8','۹'=>'9']));
    $forms = array_values(array_unique([$ph, '0' . $ph, $digits]));
    $in = implode(',', array_fill(0, count($forms), '?'));
    $q = db()->prepare("SELECT * FROM login_users WHERE phone IN ($in) LIMIT 1"); $q->execute($forms); $u = $q->fetch() ?: null;
  }
  // password_salt is missing on older databases: an absent salt means the legacy unsalted hash
  if (!$u || !hash_equals((string)$u['password'], game_hash($pass, (string)($u['password_salt'] ?? '')))) {
    rate_fail('lf-user:' . strtolower($ident)); rate_fail("lf-ip:$ip");
    usleep(400000);
    $err = 'Wrong username or password.';
    return null;
  }
  if ((int)($u['security_hold'] ?? 0) === 1) { $err = 'This account is locked by a security hold. Use "forgot password" in the game.'; return null; }
  rate_clear('lf-user:' . strtolower($ident));
  return $u;
}

/** the character (users.identifier) linked to a login row */
function identifier_of_login(array $lu): ?string {
  $dl = $lu['device_license'] ?? $lu['license'] ?? null;
  if (!$dl) return null;
  $q = db()->prepare('SELECT identifier FROM users WHERE identifier = ? OR license = ? LIMIT 1');
  $q->execute([$dl, $dl]);
  $id = $q->fetchColumn();
  return $id === false ? null : (string)$id;
}

/** the logged-in user, or null. Re-checks the login row each time (locks take effect at once). */
function current_user(): ?array {
  if (empty($_SESSION['login_id'])) return null;
  $q = db()->prepare('SELECT * FROM login_users WHERE id = ?'); $q->execute([$_SESSION['login_id']]); $lu = $q->fetch();
  if (!$lu || (int)($lu['security_hold'] ?? 0) === 1) { $_SESSION = []; return null; }
  $ident = identifier_of_login($lu);
  if (!$ident) return null;
  return ['identifier' => $ident, 'username' => (string)$lu['username'], 'login_id' => (int)$lu['id']];
}
function require_user(): array {
  $u = current_user();
  if (!$u) go('login.php');
  return $u;
}
