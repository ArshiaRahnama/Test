<?php
declare(strict_types=1);
require_once __DIR__ . '/lib/db.php';

$db = hub_db();
$totalServers = (int)$db->query("SELECT COUNT(*) AS c FROM servers")->fetch()['c'];
$totalBans = (int)$db->query("SELECT COALESCE(SUM(ban_count_total),0) AS c FROM servers")->fetch()['c'];
$totalQuarantines = (int)$db->query("SELECT COALESCE(SUM(quarantine_count),0) AS c FROM servers")->fetch()['c'];
$totalPlayersNow = (int)$db->query("SELECT COALESCE(SUM(player_count),0) AS c FROM servers WHERE last_status = 'online'")->fetch()['c'];

// Anonymized activity feed: event KIND only, no server name or raw message —
// enough to show the system is alive without exposing anything about anyone.
$KIND_LABELS = [
    'quarantine'         => '🎯 A suspicious pattern was caught and sent for review',
    'offline'            => '🔧 A protected server briefly lost connection',
    'offline_recovered'  => '🛡️ A protected server came back online',
];
$rawFeed = $db->query("SELECT kind, created_at FROM urgent_events ORDER BY id DESC LIMIT 10")->fetchAll();
$feed = array_map(fn($r) => [
    'label' => $KIND_LABELS[$r['kind']] ?? ('• Activity recorded'),
    'at' => (int)$r['created_at'],
], $rawFeed);

// Last 14 days of ban activity, bucketed by day (for the little bar chart).
// urgent_events only stores 'quarantine' rows with a timestamp, which we use
// as a proxy for "activity" since raw ban timestamps aren't tracked centrally.
$chartRaw = $db->query("
    SELECT strftime('%Y-%m-%d', created_at, 'unixepoch') AS day, COUNT(*) AS c
    FROM urgent_events WHERE kind = 'quarantine' AND created_at > " . (hub_now() - 14 * 86400) . "
    GROUP BY day ORDER BY day ASC
")->fetchAll();
$chartByDay = [];
foreach ($chartRaw as $r) { $chartByDay[$r['day']] = (int)$r['c']; }
$chartDays = [];
for ($i = 13; $i >= 0; $i--) {
    $day = date('Y-m-d', hub_now() - $i * 86400);
    $chartDays[] = ['day' => $day, 'c' => $chartByDay[$day] ?? 0];
}
$chartMax = max(1, max(array_column($chartDays, 'c')));
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= htmlspecialchars(HUB_BRAND_NAME) ?> — Protecting FiveM Servers</title>
<link rel="stylesheet" href="dashboard/style.css">
<style>
  body { padding: 0; }
  .hero { position: relative; padding: 80px 20px 60px; text-align: center; overflow: hidden; border-bottom: 1px solid var(--line); }
  .hero::before {
    content: ""; position: absolute; inset: 0; z-index: 0; opacity: .5;
    background:
      radial-gradient(circle at 20% 20%, rgba(56,214,196,.16), transparent 32%),
      radial-gradient(circle at 82% 78%, rgba(245,166,35,.12), transparent 34%);
  }
  .hero-inner { position: relative; z-index: 1; }
  .badge-live { display: inline-flex; align-items: center; gap: 7px; padding: 6px 14px; border: 1px solid rgba(89,201,122,.35); border-radius: 999px; background: rgba(89,201,122,.1); color: var(--success); font: 800 10px var(--font-mono); text-transform: uppercase; letter-spacing: .08em; margin-bottom: 22px; }
  .badge-live i { width: 7px; height: 7px; border-radius: 50%; background: var(--success); animation: pulse 1.6s infinite; }
  @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.3} }
  .hero h1 { font-size: 44px; margin: 0 0 12px; letter-spacing: -.02em; }
  .hero h1 span { color: var(--accent); }
  .hero .tagline { color: var(--muted); font-size: 16px; max-width: 520px; margin: 0 auto 40px; }

  .stat-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; max-width: 760px; margin: 0 auto; }
  @media (min-width: 640px) { .stat-grid { grid-template-columns: repeat(4, 1fr); } }
  .stat-card { padding: 24px 14px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel); position: relative; overflow: hidden; }
  .stat-card::after { content: ""; position: absolute; top: 0; left: 0; width: 14px; height: 14px; border-top: 2px solid var(--accent); border-left: 2px solid var(--accent); opacity: .5; }
  .stat-card b { display: block; font: 800 32px var(--font-mono); color: var(--accent); margin-bottom: 6px; }
  .stat-card small { color: var(--muted); text-transform: uppercase; font-size: 10px; letter-spacing: .06em; }

  .section { max-width: 760px; margin: 0 auto; padding: 50px 20px; }
  .section h2 { font-size: 18px; margin: 0 0 18px; display: flex; align-items: center; gap: 8px; }
  .section h2 i { width: 4px; height: 16px; background: var(--accent); display: inline-block; }

  .chart-card { border: 1px solid var(--line); border-radius: 4px; background: var(--panel); padding: 22px; }
  .chart-bars { display: flex; align-items: flex-end; gap: 6px; height: 100px; }
  .chart-bar { flex: 1; background: linear-gradient(180deg, var(--accent), rgba(56,214,196,.25)); border-radius: 2px 2px 0 0; min-height: 3px; transition: height .4s ease; }
  .chart-labels { display: flex; justify-content: space-between; margin-top: 10px; color: var(--muted); font-size: 10px; font-family: var(--font-mono); }

  .feed-list { display: flex; flex-direction: column; gap: 8px; }
  .feed-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel-2); font-size: 13px; }
  .feed-row small { color: var(--muted); font-family: var(--font-mono); white-space: nowrap; margin-left: 12px; }
  .feed-empty { color: var(--muted); font-size: 13px; text-align: center; padding: 20px; border: 1px dashed var(--line); border-radius: 4px; }

  .cta-section { text-align: center; padding: 60px 20px 80px; }
  .cta-section a { display: inline-block; padding: 15px 32px; background: var(--accent); color: #0A0D0C; text-decoration: none; border-radius: 4px; font: 800 12px var(--font-mono); text-transform: uppercase; letter-spacing: .05em; }
  .cta-section p { color: var(--muted); font-size: 12px; margin-top: 14px; }
</style>
</head>
<body>

  <div class="hero">
    <div class="hero-inner">
      <div class="badge-live"><i></i> Live data · updates automatically</div>
      <h1>UNIQUE<span>_AC</span></h1>
      <p class="tagline">Security operations for FiveM roleplay servers — real numbers, across every server we protect, updated in real time.</p>

      <div class="stat-grid">
        <div class="stat-card"><b data-count="<?= $totalServers ?>">0</b><small>Servers Protected</small></div>
        <div class="stat-card"><b data-count="<?= $totalPlayersNow ?>">0</b><small>Players Online Now</small></div>
        <div class="stat-card"><b data-count="<?= $totalBans ?>">0</b><small>Cheaters Removed</small></div>
        <div class="stat-card"><b data-count="<?= $totalQuarantines ?>">0</b><small>Cases Reviewed</small></div>
      </div>
    </div>
  </div>

  <div class="section">
    <h2><i></i>Activity, last 14 days</h2>
    <div class="chart-card">
      <div class="chart-bars">
        <?php foreach ($chartDays as $d): ?>
          <div class="chart-bar" style="height: <?= max(3, (int)(($d['c'] / $chartMax) * 100)) ?>%" title="<?= htmlspecialchars($d['day']) ?>: <?= $d['c'] ?>"></div>
        <?php endforeach; ?>
      </div>
      <div class="chart-labels"><span><?= htmlspecialchars($chartDays[0]['day']) ?></span><span>today</span></div>
    </div>
  </div>

  <div class="section">
    <h2><i></i>Recent Activity</h2>
    <div class="feed-list">
      <?php if (empty($feed)): ?>
        <div class="feed-empty">No activity recorded yet.</div>
      <?php else: foreach ($feed as $f): ?>
        <div class="feed-row"><span><?= htmlspecialchars($f['label']) ?></span><small><?= date('M j, H:i', $f['at']) ?></small></div>
      <?php endforeach; endif; ?>
    </div>
    <p style="color:var(--muted);font-size:11px;margin-top:14px;">No player names, server names, or identifying details are ever shown here.</p>
  </div>

  <div class="cta-section">
    <a href="<?= htmlspecialchars(HUB_BRAND_URL) ?>">Get UNIQUE_AC for your server →</a>
    <p>Live status: <a href="status.php" style="color:var(--accent)">status.php</a></p>
  </div>

  <script>
    // Simple count-up animation for the hero stats.
    document.querySelectorAll('[data-count]').forEach((el) => {
      const target = parseInt(el.dataset.count, 10) || 0;
      const duration = 1200;
      const start = performance.now();
      function tick(now) {
        const progress = Math.min(1, (now - start) / duration);
        const eased = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.floor(eased * target).toLocaleString();
        if (progress < 1) requestAnimationFrame(tick);
      }
      requestAnimationFrame(tick);
    });
  </script>
</body>
</html>
