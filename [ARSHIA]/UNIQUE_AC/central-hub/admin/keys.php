<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';

hub_require_admin('../dashboard/login.php');

$db = hub_db();
$notice = null;

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    $action = (string)($_POST['action'] ?? '');

    if ($action === 'create') {
        $owner = trim((string)($_POST['owner_name'] ?? ''));
        $note = trim((string)($_POST['note'] ?? ''));
        $maxServers = max(1, (int)($_POST['max_servers'] ?? 1));
        $days = (int)($_POST['expires_days'] ?? 0);
        $expiresAt = $days > 0 ? hub_now() + ($days * 86400) : null;

        if ($owner === '') {
            $notice = 'Owner name is required.';
        } else {
            $key = 'UAC-' . strtoupper(bin2hex(random_bytes(10)));
            $stmt = $db->prepare('INSERT INTO license_keys (key_value, owner_name, note, max_servers, expires_at, active, created_at) VALUES (:k, :o, :n, :m, :e, 1, :now)');
            $stmt->execute([':k' => $key, ':o' => $owner, ':n' => $note, ':m' => $maxServers, ':e' => $expiresAt, ':now' => hub_now()]);
            $notice = "Created key: {$key}";
        }
    }

    if ($action === 'toggle') {
        $key = (string)($_POST['key_value'] ?? '');
        $stmt = $db->prepare('UPDATE license_keys SET active = 1 - active WHERE key_value = :k');
        $stmt->execute([':k' => $key]);
        $notice = 'Key status toggled.';
    }
}

$keys = $db->query('SELECT * FROM license_keys ORDER BY created_at DESC')->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UNIQUE_AC Hub — License Keys</title>
<link rel="stylesheet" href="../dashboard/style.css">
<style>
  #app { max-width: 820px; }
  .key-form { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; padding: 18px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel); margin-bottom: 22px; }
  .key-form label { grid-column: span 2; display: block; }
  .key-form input { width: 100%; padding: 10px 12px; border: 1px solid var(--line); border-radius: 4px; background: rgba(255,255,255,.04); color: var(--text); margin-top: 6px; }
  .key-form button { grid-column: span 2; padding: 12px; border: 0; border-radius: 4px; background: var(--accent); color: #0A0D0C; font: 800 12px var(--font-mono); text-transform: uppercase; cursor: pointer; }
  .notice { padding: 10px 14px; border-radius: 4px; background: rgba(89,201,122,.12); border: 1px solid rgba(89,201,122,.35); color: var(--success); margin-bottom: 16px; font-size: 13px; }
  table { width: 100%; border-collapse: collapse; font-size: 12px; }
  th, td { padding: 10px; border-bottom: 1px solid var(--line); text-align: left; }
  th { color: var(--muted); text-transform: uppercase; font-size: 10px; }
  code { font-family: var(--font-mono); }
  .active-yes { color: var(--success); } .active-no { color: var(--danger); }
  .key-form small.hint { grid-column: span 2; color: var(--muted); margin-top: -6px; }
</style>
</head>
<body>
  <header class="topbar">
    <h1>UNIQUE<span>_AC</span> <small>LICENSE KEYS</small></h1>
    <a href="../dashboard/index.html" class="logout-link">← Dashboard</a>
  </header>
  <main id="app">
    <?php if ($notice): ?><div class="notice"><?= htmlspecialchars($notice) ?></div><?php endif; ?>

    <form class="key-form" method="post">
      <input type="hidden" name="action" value="create">
      <label>Owner name<input type="text" name="owner_name" required></label>
      <label>Note<input type="text" name="note" placeholder="e.g. Monthly plan"></label>
      <label>Max servers<input type="number" name="max_servers" value="1" min="1"></label>
      <label>Expires in (days, 0 = never)<input type="number" name="expires_days" value="30" min="0"></label>
      <small class="hint">A new key looks like UAC-XXXXXXXXXXXXXXXXXXXX — copy it into the server's UNIQUE_AC.CentralHub.LicenseKey config.</small>
      <button type="submit">Generate key</button>
    </form>

    <table>
      <thead><tr><th>Key</th><th>Owner</th><th>Servers</th><th>Expires</th><th>Status</th><th></th></tr></thead>
      <tbody>
        <?php foreach ($keys as $k): ?>
        <tr>
          <td><code><?= htmlspecialchars($k['key_value']) ?></code></td>
          <td><?= htmlspecialchars($k['owner_name']) ?><?= $k['note'] ? ' · ' . htmlspecialchars($k['note']) : '' ?></td>
          <td><?= (int)$k['max_servers'] ?></td>
          <td><?= $k['expires_at'] ? date('Y-m-d', (int)$k['expires_at']) : 'Never' ?></td>
          <td class="<?= $k['active'] ? 'active-yes' : 'active-no' ?>"><?= $k['active'] ? 'Active' : 'Revoked' ?></td>
          <td>
            <form method="post" style="display:inline">
              <input type="hidden" name="action" value="toggle">
              <input type="hidden" name="key_value" value="<?= htmlspecialchars($k['key_value']) ?>">
              <button type="submit" style="background:none;border:1px solid var(--line);color:var(--text);padding:6px 10px;border-radius:4px;cursor:pointer;font-size:11px;">
                <?= $k['active'] ? 'Revoke' : 'Reactivate' ?>
              </button>
            </form>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
  </main>
</body>
</html>
