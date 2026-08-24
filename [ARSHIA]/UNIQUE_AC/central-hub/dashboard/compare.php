<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';
hub_require_admin('login.php');
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UNIQUE_AC Hub — Compare Servers</title>
<link rel="stylesheet" href="style.css">
<style>
  #app { max-width: 820px; }
  .compare-pickers { display: grid; grid-template-columns: 1fr auto 1fr; gap: 14px; align-items: center; margin-bottom: 22px; }
  .compare-pickers select { width: 100%; padding: 12px 14px; border: 1px solid var(--line); border-radius: 4px; background: rgba(255,255,255,.04); color: var(--text); font-size: 13px; }
  .compare-vs { color: var(--muted); font: 800 12px var(--font-mono); text-align: center; }
  .compare-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
  .compare-card { border: 1px solid var(--line); border-radius: 4px; background: var(--panel-2); padding: 18px; }
  .compare-card h3 { margin: 0 0 14px; font-size: 15px; }
  .compare-row { display: flex; justify-content: space-between; padding: 9px 0; border-bottom: 1px solid var(--line); font-size: 13px; }
  .compare-row:last-child { border-bottom: none; }
  .compare-row b { font-family: var(--font-mono); }
  .compare-row b.win { color: var(--success); }
  .empty-hint { color: var(--muted); text-align: center; padding: 30px; font-size: 13px; }
</style>
</head>
<body>
  <header class="topbar">
    <h1>UNIQUE<span>_AC</span> <small>COMPARE</small></h1>
    <a href="index.html" class="logout-link">← Dashboard</a>
  </header>
  <main id="app">
    <div class="compare-pickers">
      <select id="server-a"><option value="">Loading…</option></select>
      <span class="compare-vs">VS</span>
      <select id="server-b"><option value="">Loading…</option></select>
    </div>
    <div id="compare-output"><div class="empty-hint">Pick two servers above to compare.</div></div>
  </main>

<script>
const METRICS = [
  { key: 'player_count', label: 'Players Online', higherIsBetter: true },
  { key: 'max_players', label: 'Max Players', higherIsBetter: null },
  { key: 'quarantine_count', label: 'Quarantine Cases', higherIsBetter: false },
  { key: 'appeal_count', label: 'Pending Appeals', higherIsBetter: false },
  { key: 'ban_count_total', label: 'Total Bans', higherIsBetter: null },
  { key: 'version', label: 'Version', higherIsBetter: null },
];

let servers = [];

function escapeHtml(v) {
  return String(v ?? '').replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
}

function populateSelects() {
  const opts = servers.map((s, i) => `<option value="${i}">${escapeHtml(s.server_name)}</option>`).join('');
  document.getElementById('server-a').innerHTML = '<option value="">Select a server…</option>' + opts;
  document.getElementById('server-b').innerHTML = '<option value="">Select a server…</option>' + opts;
}

function renderCompare() {
  const ai = document.getElementById('server-a').value;
  const bi = document.getElementById('server-b').value;
  const out = document.getElementById('compare-output');
  if (ai === '' || bi === '') {
    out.innerHTML = '<div class="empty-hint">Pick two servers above to compare.</div>';
    return;
  }
  const a = servers[ai], b = servers[bi];

  function card(server, other) {
    const rows = METRICS.map((m) => {
      const val = server[m.key];
      const otherVal = other[m.key];
      let winClass = '';
      if (m.higherIsBetter !== null && typeof val === 'number' && typeof otherVal === 'number' && val !== otherVal) {
        const better = m.higherIsBetter ? val > otherVal : val < otherVal;
        winClass = better ? 'win' : '';
      }
      return `<div class="compare-row"><span>${m.label}</span><b class="${winClass}">${escapeHtml(val)}</b></div>`;
    }).join('');
    return `<div class="compare-card"><h3>${escapeHtml(server.server_name)}</h3>${rows}</div>`;
  }

  out.innerHTML = `<div class="compare-grid">${card(a, b)}${card(b, a)}</div>`;
}

async function load() {
  try {
    const res = await fetch('api-servers.php', { cache: 'no-store' });
    const data = await res.json();
    if (!data.ok) return;
    servers = data.servers || [];
    populateSelects();
  } catch (e) {}
}

document.getElementById('server-a').addEventListener('change', renderCompare);
document.getElementById('server-b').addEventListener('change', renderCompare);
load();
</script>
</body>
</html>
