<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';
hub_require_admin('login.php');

// GTA V's usable world coordinates run roughly -4000..4500 on both axes.
// We normalize into a 0..1000 SVG viewBox for a simple scatter plot.
$WORLD_MIN = -4500.0;
$WORLD_MAX = 4500.0;
$SVG_SIZE = 900;

$points = hub_db()->query("SELECT x, y, reason FROM heatmap_points WHERE created_at > " . (hub_now() - 30 * 86400) . " ORDER BY id DESC LIMIT 2000")->fetchAll();

function normalize($v, $min, $max, $size) {
    $t = ($v - $min) / ($max - $min);
    $t = max(0.0, min(1.0, $t));
    return $t * $size;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UNIQUE_AC Hub — Exploit Heatmap</title>
<link rel="stylesheet" href="style.css">
<style>
  #app { max-width: 960px; }
  .heatmap-wrap { border: 1px solid var(--line); border-radius: 4px; background: var(--panel); padding: 16px; }
  .heatmap-wrap svg { width: 100%; height: auto; background: rgba(0,0,0,.3); border-radius: 4px; }
  .heatmap-note { color: var(--muted); font-size: 12px; margin-top: 12px; }
  .heatmap-empty { color: var(--muted); text-align: center; padding: 60px 20px; }
</style>
</head>
<body>
  <header class="topbar">
    <h1>UNIQUE<span>_AC</span> <small>HEATMAP</small></h1>
    <a href="index.html" class="logout-link">← Dashboard</a>
  </header>
  <main id="app">
    <p style="color:var(--muted);font-size:13px;margin-bottom:16px;">Detection coordinates from the last 30 days, aggregated across every server on your license keys. No player identity is included — a cluster here usually means a map bug or exploit spot worth checking in-game.</p>

    <?php if (empty($points)): ?>
      <div class="heatmap-wrap"><div class="heatmap-empty">No heatmap data yet. Enable UNIQUE_AC.CentralHub in your servers' config to start collecting it.</div></div>
    <?php else: ?>
      <div class="heatmap-wrap">
        <svg viewBox="0 0 <?= $SVG_SIZE ?> <?= $SVG_SIZE ?>" xmlns="http://www.w3.org/2000/svg">
          <rect x="0" y="0" width="<?= $SVG_SIZE ?>" height="<?= $SVG_SIZE ?>" fill="none" stroke="rgba(255,255,255,.08)" />
          <?php foreach ($points as $p): ?>
            <?php
              $px = normalize((float)$p['x'], $WORLD_MIN, $WORLD_MAX, $SVG_SIZE);
              $py = $SVG_SIZE - normalize((float)$p['y'], $WORLD_MIN, $WORLD_MAX, $SVG_SIZE); // flip Y so north is up
            ?>
            <circle cx="<?= round($px, 1) ?>" cy="<?= round($py, 1) ?>" r="4" fill="rgba(255,23,68,.35)">
              <title><?= htmlspecialchars($p['reason']) ?></title>
            </circle>
          <?php endforeach; ?>
        </svg>
      </div>
      <p class="heatmap-note"><?= count($points) ?> points shown · darker/denser clusters = more detections in that area</p>
    <?php endif; ?>
  </main>
</body>
</html>
