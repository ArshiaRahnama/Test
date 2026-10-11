<?php
/*
 * Sets a new password for an EXISTING game login (the same password works in the game and on the website).
 * Run from the command line on the server:
 *   php tools/set_password.php <username or phone> <new password>
 * The new password must be at least 10 characters. It is stored salted (SHA-256 of password + salt),
 * the same way the game stores it. Requires the password_salt column (see the message if it is missing).
 */
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require __DIR__ . '/../lib.php';

[$script, $ident, $password] = array_pad($argv, 3, null);
if (!$ident || !$password) {
    fwrite(STDERR, "usage: php tools/set_password.php <username or phone> <new password>\n");
    exit(2);
}
if (strlen($password) < 10) { fwrite(STDERR, "password must be at least 10 characters\n"); exit(2); }

$db = db();
try {
    $db->query('SELECT password_salt FROM login_users LIMIT 1')->fetch();
} catch (Throwable $e) {
    fwrite(STDERR, "the login_users table has no password_salt column. Run once:\n" .
        "  ALTER TABLE login_users ADD COLUMN password_salt varchar(64) NOT NULL DEFAULT '' AFTER password;\n");
    exit(1);
}

$q = $db->prepare('SELECT id, username FROM login_users WHERE username = ? LIMIT 1'); $q->execute([trim($ident)]);
$row = $q->fetch();
if (!$row) {
    $ph = phone10($ident);
    if ($ph) { $q = $db->prepare('SELECT id, username FROM login_users WHERE phone = ? OR phone = ? LIMIT 1'); $q->execute([$ph, '0' . $ph]); $row = $q->fetch(); }
}
if (!$row) { fwrite(STDERR, "no login found for '$ident'\n"); exit(1); }

$salt = bin2hex(random_bytes(16));
$db->prepare('UPDATE login_users SET password = ?, password_salt = ? WHERE id = ?')
   ->execute([game_hash($password, $salt), $salt, (int)$row['id']]);
echo "password updated for login '{$row['username']}'. Log in with it on the website and in the game.\n";
