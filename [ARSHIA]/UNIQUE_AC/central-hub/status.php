<?php
declare(strict_types=1);
require_once __DIR__ . '/lib/db.php';

$db = hub_db();
$total = (int)$db->query("SELECT COUNT(*) AS c FROM servers")->fetch()['c'];
$online = (int)$db->query("SELECT COUNT(*) AS c FROM servers WHERE last_status = 'online' AND last_heartbeat_at > " . (hub_now() - HUB_OFFLINE_THRESHOLD))->fetch()['c'];
$totalPlayers = (int)$db->query("SELECT COALESCE(SUM(player_count),0) AS c FROM servers WHERE last_status = 'online'")->fetch()['c'];
$lastHeartbeat = (int)$db->query("SELECT COALESCE(MAX(last_heartbeat_at),0) AS c FROM servers")->fetch()['c'];
$allOperational = $total === 0 || $online === $total;

// Recent offline/recovery events, anonymized the same way as showcase.php.
$incidents = $db->query("SELECT kind, created_at FROM urgent_events WHERE kind IN ('offline','offline_recovered') ORDER BY id DESC LIMIT 8")->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= htmlspecialchars(HUB_BRAND_NAME) ?> — Status</title>
<link rel="stylesheet" href="dashboard/style.css">
<meta http-equiv="refresh" content="30">
<style>
  body { display: flex; align-items: flex-start; justify-content: center; padding: 40px 20px; }
  .status-card { width: 100%; max-width: 480px; padding: 34px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel); text-align: center; }
  .status-pill { display: inline-flex; align-items: center; gap: 8px; padding: 9px 18px; border-radius: 4px; font: 800 12px var(--font-mono); text-transform: uppercase; letter-spacing: .06em; margin-bottom: 22px; }
  .status-pill i { width: 8px; height: 8px; border-radius: 50%; }
  .status-pill.ok { background: rgba(89,201,122,.12); border: 1px solid rgba(89,201,122,.35); color: var(--success); }
  .status-pill.ok i { background: var(--success); animation: pulse 1.6s infinite; }
  .status-pill.degraded { background: rgba(228,72,58,.12); border: 1px solid rgba(228,72,58,.35); color: var(--danger); }
  .status-pill.degraded i { background: var(--danger); }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.3} }
  .status-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-top: 20px; }
  .status-grid div { padding: 14px; border: 1px solid var(--line); border-radius: 4px; }
  .status-grid small { display: block; color: var(--muted); font-size: 10px; text-transform: uppercase; margin-bottom: 6px; }
  .status-grid b { font: 700 22px var(--font-mono); }
  .status-foot { margin-top: 22px; color: var(--muted); font-size: 11px; }
  .incidents { margin-top: 26px; text-align: left; }
  .incidents h3 { font-size: 12px; text-transform: uppercase; letter-spacing: .06em; color: var(--muted); margin-bottom: 10px; }
  .incident-row { display: flex; justify-content: space-between; padding: 9px 12px; border: 1px solid var(--line); border-radius: 4px; margin-bottom: 6px; font-size: 12px; }
  .incident-row.offline { border-left: 3px solid var(--danger); }
  .incident-row.offline_recovered { border-left: 3px solid var(--success); }
  .incident-row small { color: var(--muted); font-family: var(--font-mono); }
</style>
</head>
<body>
  <div class="status-card">
    <h1>UNIQUE<span style="color:var(--accent)">_AC</span></h1>
    <div class="status-pill <?= $allOperational ? 'ok' : 'degraded' ?>">
      <i></i> <?= $allOperational ? 'All Systems Operational' : 'Some Servers Offline' ?>
    </div>
    <div class="status-grid">
      <div><small>Servers Online</small><b><?= $online ?> / <?= $total ?></b></div>
      <div><small>Players Now</small><b><?= number_format($totalPlayers) ?></b></div>
    </div>

    <?php if (!empty($incidents)): ?>
    <div class="incidents">
      <h3>Recent Incidents</h3>
      <?php foreach ($incidents as $inc): ?>
        <div class="incident-row <?= htmlspecialchars($inc['kind']) ?>">
          <span><?= $inc['kind'] === 'offline' ? '🔴 Server went offline' : '🟢 Server recovered' ?></span>
          <small><?= date('M j, H:i', (int)$inc['created_at']) ?></small>
        </div>
      <?php endforeach; ?>
    </div>
    <?php endif; ?>

    <p class="status-foot">
      Last update: <?= $lastHeartbeat > 0 ? date('Y-m-d H:i:s', $lastHeartbeat) . ' UTC' : 'no data yet' ?> · auto-refreshes every 30s<br>
      <?= htmlspecialchars(HUB_BRAND_NAME) ?> · <a href="<?= htmlspecialchars(HUB_BRAND_URL) ?>" style="color:var(--accent)"><?= htmlspecialchars(HUB_BRAND_URL) ?></a> · <a href="showcase.php" style="color:var(--accent)">showcase</a>
    </p>
  </div>
</body>
</html>
