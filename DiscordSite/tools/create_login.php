<?php
/*
 * Creates a website/game login for an EXISTING character. Run once, from the command line:
 *   php tools/create_login.php <username> <password> <character identifier, e.g. steam:110000...>
 * The password is never stored in plain text. Refuses weak passwords and existing usernames.
 */
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require __DIR__ . '/../lib.php';

[$script, $username, $password, $identifier] = array_pad($argv, 4, null);
if (!$username || !$password || !$identifier) {
  fwrite(STDERR, "usage: php tools/create_login.php <username> <password> <character identifier>\n");
  exit(2);
}
if (strlen($password) < 10) { fwrite(STDERR, "password must be at least 10 characters\n"); exit(2); }
if (!preg_match('/^[A-Za-z0-9_.-]{3,32}$/', $username)) { fwrite(STDERR, "username: 3-32 letters, digits, _ . -\n"); exit(2); }

$db = db();
$c = $db->prepare('SELECT identifier, license FROM users WHERE identifier = ?'); $c->execute([$identifier]);
$char = $c->fetch();
if (!$char) { fwrite(STDERR, "no character with identifier $identifier\n"); exit(1); }

$q = $db->prepare('SELECT id FROM login_users WHERE username = ?'); $q->execute([$username]);
if ($q->fetch()) { fwrite(STDERR, "username already exists\n"); exit(1); }

$salt = bin2hex(random_bytes(16));
$lic = $char['license'] ?: $char['identifier'];
$db->prepare('INSERT INTO login_users (username, password, password_salt, license, device_license, security_hold) VALUES (?, ?, ?, ?, ?, 0)')
   ->execute([$username, game_hash($password, $salt), $salt, $lic, $lic]);
echo "created login '$username' for $identifier\n";
