<?php
/* ماژول‌های سایت: تیکت، تایید دو مرحله‌ای، کد یکبارمصرف و مدیریت دستگاه‌ها */
const TICKET_CATS = ['support' => 'پشتیبانی عمومی', 'report' => 'گزارش بازیکن', 'review' => 'تجدیدنظر / بازبینی', 'bug' => 'باگ', 'other' => 'سایر'];
/* ---------- جداول ---------- */
function ext_install(PDO $p, bool $my): void {
  $pk = $my ? 'INT AUTO_INCREMENT PRIMARY KEY' : 'INTEGER PRIMARY KEY AUTOINCREMENT';
  $t = $my ? 'VARCHAR(190)' : 'TEXT'; $tail = $my ? ' ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' : '';
  $p->exec("CREATE TABLE IF NOT EXISTS web_totp(user_id INT NOT NULL PRIMARY KEY, secret $t NOT NULL, enabled INT NOT NULL DEFAULT 0)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_devices(id $pk, user_id INT NOT NULL, token_hash $t NOT NULL, ua $t, ip $t, created INT NOT NULL, last INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_login_codes(code_hash $t NOT NULL PRIMARY KEY, login_id INT NOT NULL, expires INT NOT NULL)$tail");
}
/* ---------- TOTP (Authenticator) ---------- */
function b32enc(string $b): string { $a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; $bits = ''; foreach (str_split($b) as $c) $bits .= str_pad(decbin(ord($c)), 8, '0', STR_PAD_LEFT); $o = ''; foreach (str_split($bits, 5) as $ch) $o .= $a[bindec(str_pad($ch, 5, '0'))]; return $o; }
function b32dec(string $s): string { $a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; $bits = ''; foreach (str_split(strtoupper($s)) as $c) { $i = strpos($a, $c); if ($i !== false) $bits .= str_pad(decbin($i), 5, '0', STR_PAD_LEFT); } $o = ''; foreach (str_split($bits, 8) as $by) if (strlen($by) === 8) $o .= chr(bindec($by)); return $o; }
function totp_at(string $secret, int $ts): string {
  $h = hash_hmac('sha1', pack('N*', 0, intdiv($ts, 30)), b32dec($secret), true); $o = ord($h[19]) & 15;
  $v = ((ord($h[$o]) & 0x7f) << 24) | (ord($h[$o + 1]) << 16) | (ord($h[$o + 2]) << 8) | ord($h[$o + 3]);
  return str_pad((string)($v % 1000000), 6, '0', STR_PAD_LEFT);
}
function totp_check(string $secret, string $code): bool {
  $code = preg_replace('/\D/', '', $code); if (strlen($code) !== 6) return false;
  foreach ([-1, 0, 1] as $w) if (hash_equals(totp_at($secret, time() + $w * 30), $code)) return true;
  return false;
}
function totp_row(int $uid): ?array { $q = db()->prepare('SELECT * FROM web_totp WHERE user_id=?'); $q->execute([$uid]); return $q->fetch() ?: null; }
function totp_enabled(int $uid): bool { $r = totp_row($uid); return $r && (int)$r['enabled'] === 1; }
/* ---------- کد یکبارمصرف /getcode ---------- */
function code_issue(int $loginId): string {
  $db = db(); $db->prepare('DELETE FROM web_login_codes WHERE expires<? OR login_id=?')->execute([time(), $loginId]);
  $code = str_pad((string)random_int(0, 999999), 6, '0', STR_PAD_LEFT);
  $db->prepare('INSERT INTO web_login_codes(code_hash,login_id,expires) VALUES(?,?,?)')->execute([hash('sha256', $code), $loginId, time() + 180]);
  return $code;
}
function code_consume(string $code): ?array {
  $code = preg_replace('/\D/', '', $code); if (strlen($code) !== 6) return null;
  $db = db(); $h = hash('sha256', $code);
  $q = $db->prepare('SELECT login_id FROM web_login_codes WHERE code_hash=? AND expires>=?'); $q->execute([$h, time()]); $lid = $q->fetchColumn();
  if (!$lid) return null;
  $db->prepare('DELETE FROM web_login_codes WHERE code_hash=?')->execute([$h]);
  $q = $db->prepare('SELECT * FROM login_users WHERE id=?'); $q->execute([$lid]); $u = $q->fetch();
  return $u && (int)$u['security_hold'] !== 1 ? $u : null;
}
/* ---------- دستگاه‌ها و پایان ورود ---------- */
function dev_register(int $uid): void {
  $tok = bin2hex(random_bytes(16)); $_SESSION['dev'] = $tok; $now = time();
  db()->prepare('INSERT INTO web_devices(user_id,token_hash,ua,ip,created,last) VALUES(?,?,?,?,?,?)')->execute([$uid, hash('sha256', $tok), mb_substr((string)($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 180), $_SERVER['REMOTE_ADDR'] ?? '', $now, $now]);
}
function dev_valid(): bool {
  if (empty($_SESSION['dev'])) return true;   // نشست‌های قدیمی
  try { $q = db()->prepare('SELECT id,last FROM web_devices WHERE token_hash=?'); $q->execute([hash('sha256', $_SESSION['dev'])]); $r = $q->fetch();
    if ($r && time() - (int)$r['last'] > 300) db()->prepare('UPDATE web_devices SET last=? WHERE id=?')->execute([time(), $r['id']]);
    return (bool)$r; } catch (Throwable $e) { return true; }
}
function login_finish(array $lu): void {
  session_regenerate_id(true);
  $g = game_profile($lu); $uid = sync_web_account($lu, display_name($lu, $g));
  $_SESSION['uid'] = $uid; $_SESSION['lid'] = (int)$lu['id']; unset($_SESSION['pre']);
  dev_register($uid);
}
function ua_label(string $ua): string {
  $b = preg_match('/Edg/i', $ua) ? 'Edge' : (preg_match('/OPR|Opera/i', $ua) ? 'Opera' : (preg_match('/Chrome/i', $ua) ? 'Chrome' : (preg_match('/Firefox/i', $ua) ? 'Firefox' : (preg_match('/Safari/i', $ua) ? 'Safari' : 'مرورگر'))));
  $o = preg_match('/Windows/i', $ua) ? 'Windows' : (preg_match('/Android/i', $ua) ? 'Android' : (preg_match('/iPhone|iPad/i', $ua) ? 'iOS' : (preg_match('/Mac/i', $ua) ? 'macOS' : (preg_match('/Linux/i', $ua) ? 'Linux' : ''))));
  return trim("$b $o");
}
