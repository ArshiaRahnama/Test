<?php
declare(strict_types=1);
require_once __DIR__ . '/lib/db.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= htmlspecialchars(HUB_BRAND_NAME) ?> — Security & Bug Bounty</title>
<link rel="stylesheet" href="dashboard/style.css">
<style>
  body { padding: 50px 20px; }
  .page { max-width: 640px; margin: 0 auto; }
  h1 { font-size: 26px; margin-bottom: 6px; } h1 span { color: var(--accent); }
  .sub { color: var(--muted); margin-bottom: 30px; }
  .card { border: 1px solid var(--line); border-radius: 4px; background: var(--panel); padding: 22px; margin-bottom: 16px; }
  .card h2 { font-size: 15px; margin: 0 0 10px; display: flex; align-items: center; gap: 8px; }
  .card p { color: var(--muted); font-size: 13px; line-height: 1.7; margin: 0; }
  .scope-list { margin: 10px 0 0; padding-left: 18px; color: var(--muted); font-size: 13px; line-height: 1.9; }
  .out-of-scope { border-left: 3px solid var(--danger); }
  .in-scope { border-left: 3px solid var(--success); }
  .contact { margin-top: 8px; font-family: var(--font-mono); color: var(--accent); font-size: 13px; }
</style>
</head>
<body>
  <div class="page">
    <h1>Security & <span>Bug Bounty</span></h1>
    <p class="sub">Found a security issue in UNIQUE_AC or this hub? Please report it responsibly — don't exploit it, don't share it publicly first.</p>

    <div class="card in-scope">
      <h2>✅ In scope</h2>
      <ul class="scope-list">
        <li>Authentication or authorization bypass in the FiveM resource or this hub</li>
        <li>SQL injection, XSS, or CSRF in any panel/page</li>
        <li>Any way for a non-admin to trigger admin-only actions</li>
        <li>Any way to bypass Trust Score / Quarantine detection logic</li>
        <li>Exposure of the SQLite database, license keys, or player data</li>
      </ul>
    </div>

    <div class="card out-of-scope">
      <h2>🚫 Out of scope</h2>
      <ul class="scope-list">
        <li>Issues requiring physical/console access to the server</li>
        <li>Social engineering of server staff</li>
        <li>Denial of service via raw traffic volume (report rate-limit bypasses instead)</li>
      </ul>
    </div>

    <div class="card">
      <h2>📬 How to report</h2>
      <p>Email details (steps to reproduce, impact, affected version from your VERSION file) to the address below. Please allow reasonable time for a fix before any public disclosure.</p>
      <div class="contact">security@<?= htmlspecialchars(parse_url(HUB_BRAND_URL, PHP_URL_HOST) ?: 'arshiahub.ir') ?></div>
    </div>
  </div>
</body>
</html>
