<?php
/* Discord site — settings. Change these to match your server. */
return [
  'site_name' => 'Unique Discord',

  // 'mysql' = the server's game database (the same one the in-game phone uses).
  // 'sqlite' is only for local tests.
  'driver' => getenv('DSITE_DRIVER') ?: 'mysql',
  'mysql' => [
    'host' => getenv('DSITE_DB_HOST') ?: '127.0.0.1',
    'port' => 3306,
    'db'   => getenv('DSITE_DB_NAME') ?: 'essentialmode',
    'user' => getenv('DSITE_DB_USER') ?: 'root',
    'pass' => getenv('DSITE_DB_PASS') ?: '',
  ],
  'sqlite_path' => __DIR__ . '/data/discord.sqlite',

  // a player counts as "online" when users.last_seen is newer than this many seconds
  'online_window' => 150,

  // login attempts: at most N failures per account / IP in the window
  'login_max_fail' => 5,
  'login_window' => 900,

  // the phone's Discord chat: how fast one session may send
  'send_cooldown_ms' => 700,
];
