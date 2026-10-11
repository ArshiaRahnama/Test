<?php
/*
 * Checks that the website can reach the GAME database and that the tables it needs exist.
 * Run from the command line:   php tools/check_db.php
 * Reads the settings from config.php (or the DSITE_DB_* environment variables).
 */
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require __DIR__ . '/../lib.php';

$c = dsite_cfg('mysql');
echo "driver: " . dsite_cfg('driver') . "\n";
echo "host: {$c['host']}:{$c['port']}  database: {$c['db']}  user: {$c['user']}\n";
try {
  $db = db();
  echo "connection: OK\n";
} catch (Throwable $e) {
  echo "connection: FAILED — " . $e->getMessage() . "\n";
  echo "check: host/port, the database name, the user and password in config.php, and that MySQL allows this host.\n";
  exit(1);
}

$need = ['login_users', 'users', 'phone_discord_accounts', 'phone_discord_profiles', 'phone_discord_servers',
         'phone_discord_members', 'phone_discord_channels', 'phone_discord_messages', 'phone_discord_friends',
         'phone_discord_dms', 'phone_discord_dm_messages', 'dsite_rate', 'dsite_presence'];
$missing = [];
foreach ($need as $t) {
  try { $db->query("SELECT 1 FROM `$t` LIMIT 1")->fetch(); }
  catch (Throwable $e) { $missing[] = $t; }
}
if ($missing) {
  echo "missing tables: " . implode(', ', $missing) . "\n";
  echo "  game tables (login_users, users, phone_discord_*): run the game's SQL files.\n";
  echo "  dsite_* tables: run sql/site_schema.sql.\n";
  exit(1);
}
$n = (int)$db->query('SELECT COUNT(*) FROM login_users')->fetchColumn();
echo "all tables: OK (login accounts found: $n)\n";
exit(0);
