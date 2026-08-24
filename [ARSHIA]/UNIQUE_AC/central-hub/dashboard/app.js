if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('service-worker.js').catch(() => {});
}

const POLL_MS = 15000;
const grid = document.getElementById('server-grid');
const loading = document.getElementById('loading-state');
const liveDot = document.getElementById('live-dot');
const urgentSection = document.getElementById('urgent-section');
const urgentList = document.getElementById('urgent-list');

function escapeHtml(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;').replaceAll("'", '&#039;');
}

function timeAgo(unixSeconds) {
  const delta = Math.max(0, Math.floor(Date.now() / 1000) - unixSeconds);
  if (delta < 60) return `${delta}s ago`;
  if (delta < 3600) return `${Math.floor(delta / 60)}m ago`;
  if (delta < 86400) return `${Math.floor(delta / 3600)}h ago`;
  return `${Math.floor(delta / 86400)}d ago`;
}

function renderServers(servers) {
  if (servers.length === 0) {
    loading.hidden = false;
    loading.textContent = 'No servers have reported in yet. Check that UNIQUE_AC.CentralHub is enabled with a valid license key.';
    grid.hidden = true;
    return;
  }
  loading.hidden = true;
  grid.hidden = false;
  grid.innerHTML = '';

  servers.forEach((s) => {
    const isOnline = s.last_status === 'online' && s.seconds_since_heartbeat < 180;
    const card = document.createElement('div');
    card.className = `server-card ${isOnline ? 'is-online' : 'is-offline'}`;
    card.innerHTML = `
      <div class="server-card-head">
        <span class="status-dot"></span>
        <b>${escapeHtml(s.server_name)}</b>
        <span class="version-tag">${escapeHtml(s.version || '?')}</span>
      </div>
      <div class="server-stats">
        <div><small>Players</small><b>${s.player_count}${s.max_players ? ' / ' + s.max_players : ''}</b></div>
        <div><small>Quarantine</small><b class="${s.quarantine_count > 0 ? 'flag' : ''}">${s.quarantine_count}</b></div>
        <div><small>Appeals</small><b class="${s.appeal_count > 0 ? 'flag' : ''}">${s.appeal_count}</b></div>
        <div><small>Total Bans</small><b>${s.ban_count_total}</b></div>
      </div>
      <div class="server-foot">
        <span>${isOnline ? 'Online' : 'Offline'} · last seen ${timeAgo(s.last_heartbeat_at)}${isOnline ? ` · ~${s.avg_frame_drift_ms ?? 0}ms drift · ${s.resource_count ?? '?'} resources` : ''}</span>
        <span class="license-tag">${escapeHtml(s.license_key)}</span>
      </div>
    `;
    grid.appendChild(card);
  });
}

function renderUrgent(events) {
  if (!events || events.length === 0) { urgentSection.hidden = true; return; }
  urgentSection.hidden = false;
  urgentList.innerHTML = '';
  events.forEach((e) => {
    const row = document.createElement('div');
    row.className = `urgent-row kind-${escapeHtml(e.kind)}`;
    row.innerHTML = `<b>${escapeHtml(e.server_name)}</b><span>${escapeHtml(e.message)}</span><small>${timeAgo(e.created_at)}</small>`;
    urgentList.appendChild(row);
  });
}

async function poll() {
  try {
    const res = await fetch('api-servers.php', { cache: 'no-store' });
    if (res.status === 302 || res.redirected) { window.location.href = 'login.php'; return; }
    const data = await res.json();
    if (!data.ok) return;
    liveDot.classList.add('is-live');
    renderServers(data.servers || []);
    renderUrgent(data.urgent || []);
  } catch (e) {
    liveDot.classList.remove('is-live');
  }
}

poll();
setInterval(poll, POLL_MS);
