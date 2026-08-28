let resourceName = 'Unique_AdminMenu';
let currentChatLog = [];
// Report Queue moved to ox_lib's context menu (see client/nui_panel.lua ->
// OpenReportsMenu) - this custom panel no longer handles reports.

function post(endpoint, data) {
  fetch(`https://${resourceName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data || {})
  }).catch(() => {});
}

// ============================================================================
// STATS WIDGET
// ============================================================================
function renderStats(data) {
  document.getElementById('statsWidget').classList.remove('hidden');
  document.getElementById('statsOnline').textContent = `${data.online}/${data.maxPlayers}`;
  const mins = Math.floor(data.uptimeSeconds / 60);
  const hrs = Math.floor(mins / 60);
  document.getElementById('statsUptime').textContent = hrs > 0 ? `${hrs}h ${mins % 60}m` : `${mins}m`;
  document.getElementById('statsReports').textContent = data.openReports ?? 0;
  document.getElementById('statsReportsRow').classList.toggle('hasOpen', (data.openReports ?? 0) > 0);
}
// Note: this row is display-only, not clickable - the always-on stats
// widget renders without NUI focus (so it never blocks mouse/keyboard
// control of the game), and FiveM only delivers click events to NUI while
// focus is active. Use the "Report Queue" button in Server Tools to open
// the full list.

// ============================================================================
// PANEL: INSPECT / REPORTS / CHATLOG
// ============================================================================
function openPanel(title, showSearch) {
  document.getElementById('panel').classList.remove('hidden');
  document.getElementById('panelTitle').textContent = title;
  document.getElementById('panelSearchWrap').classList.toggle('hidden', !showSearch);
  document.getElementById('panelSearch').value = '';
}

function closePanel() {
  document.getElementById('panel').classList.add('hidden');
  post('closePanel');
}

function renderInspect(data) {
  openPanel(`Inspect: ${data.name} (id: ${data.source})`, false);
  const rows = [
    ['Identifier', data.identifier],
    ['Job', data.job ? `${data.job.label || data.job.name} (grade ${data.job.grade})` : 'n/a'],
    ['Cash', data.money ?? 'n/a'],
    ['Bank', data.bank ?? 'n/a'],
    ['Permission Level', data.permission_level ?? '0'],
    ['Ping', data.ping ?? 'n/a'],
    ['Inventory Items', data.inventory ? data.inventory.length : 'n/a'],
  ];

  let html = rows.map(([k, v]) =>
    `<div class="infoRow"><span>${k}</span><span>${v}</span></div>`
  ).join('');

  if (data.linkedAccounts && data.linkedAccounts.length) {
    html += `<div class="sectionTitle sectionWarn">⚠ Possible Alt Accounts (${data.linkedAccounts.length})</div>`;
    html += data.linkedAccounts.map(a =>
      `<div class="infoRow"><span>${escapeHtml(a.playername || 'Unknown')}</span><span>${escapeHtml(a.identifier)}</span></div>`
    ).join('');
  }

  html += `<div class="sectionTitle">Notes (${(data.notes || []).length})</div>`;
  html += (data.notes && data.notes.length)
    ? data.notes.map(n => `<div class="noteLine">"${escapeHtml(n.note)}" <span class="rMeta">- ${escapeHtml(n.admin_name)}, ${escapeHtml(n.created_at)}</span></div>`).join('')
    : `<div class="rMeta">No notes yet</div>`;

  html += `<div class="sectionTitle">Recent Action History (${(data.history || []).length})</div>`;
  html += (data.history && data.history.length)
    ? data.history.map(h => `<div class="logLine"><span class="who">${escapeHtml(h.action)}</span><span class="time">${escapeHtml(h.created_at)}</span><br>${escapeHtml(h.details || '')} <span class="rMeta">- by ${escapeHtml(h.admin_name)}</span></div>`).join('')
    : `<div class="rMeta">No prior actions logged</div>`;

  document.getElementById('panelBody').innerHTML = html;
}

function renderChatLog(log) {
  currentChatLog = log || [];
  openPanel('Chat Log', true);
  drawChatLog(currentChatLog);
}
function drawChatLog(list) {
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No chat messages yet</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.slice().reverse().map(m => `
    <div class="logLine"><span class="who">${escapeHtml(m.name)}</span><span class="time">${m.time}</span><br>${escapeHtml(m.message)}</div>
  `).join('');
}

// ============================================================================
// PANEL: SCREENSHOT
// ============================================================================
function renderScreenshot(dataUri, name) {
  openPanel(`Screenshot: ${name || ''}`, false);
  document.getElementById('panelBody').innerHTML =
    `<img class="screenshotImg" src="${dataUri}" alt="screenshot" />`;
}

// ============================================================================
// PANEL: NEARBY VEHICLE LIST
// ============================================================================
function renderVehicleList(list) {
  openPanel(`Nearby Vehicles (${list.length})`, false);
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No vehicles nearby</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.map(v => `
    <div class="listRow">
      <div class="listRowMain">
        <span class="listRowTitle">${escapeHtml(v.model)}</span>
        <span class="rMeta">${escapeHtml(v.plate || '')} - ${v.distance}m${v.occupied ? ' - occupied' : ''}</span>
      </div>
      <div class="listRowActions">
        <button class="smallBtn" data-net="${v.netId}" data-action="teleport">Teleport</button>
        <button class="smallBtn smallBtnDanger" data-net="${v.netId}" data-action="delete">Delete</button>
      </div>
    </div>
  `).join('');

  document.getElementById('panelBody').querySelectorAll('.smallBtn').forEach(btn => {
    btn.addEventListener('click', () => {
      post('vehicleListAction', { netId: Number(btn.dataset.net), action: btn.dataset.action });
      closePanel();
    });
  });
}

// ============================================================================
// PANEL: ONLINE PLAYERS
// ============================================================================
function renderOnlinePlayers(list) {
  openPanel(`Online Players (${list.length})`, true);
  drawOnlinePlayers(list);
  window._onlinePlayersCache = list;
}
function drawOnlinePlayers(list) {
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No players online</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.map(p => `
    <div class="infoRow">
      <span>[${p.id}] ${escapeHtml(p.name)} <span class="rMeta">(${escapeHtml(p.job)})</span></span>
      <span>${p.ping}ms - ${p.sessionMinutes}m session</span>
    </div>
  `).join('');
}

// ============================================================================
// PANEL: DASHBOARD
// ============================================================================
function renderDashboard(data) {
  openPanel('Server Dashboard', false);
  let html = `<div class="sectionTitle">Top 10 Richest Players</div>`;
  html += (data.richest && data.richest.length)
    ? data.richest.map((r, i) => `<div class="infoRow"><span>${i + 1}. ${escapeHtml((r.pname || '').trim() || r.identifier)}</span><span>$${Number(r.total || 0).toLocaleString()}</span></div>`).join('')
    : `<div class="rMeta">No data</div>`;

  html += `<div class="sectionTitle">Most Warned Players</div>`;
  html += (data.mostWarned && data.mostWarned.length)
    ? data.mostWarned.map((w, i) => `<div class="infoRow"><span>${i + 1}. ${escapeHtml(w.playername || w.identifier)}</span><span>${w.cnt} warnings</span></div>`).join('')
    : `<div class="rMeta">No warnings logged</div>`;

  html += `<div class="sectionTitle">Resources (${data.resources.length})</div>`;
  html += data.resources.map(r =>
    `<div class="infoRow"><span>${escapeHtml(r.name)}</span><span class="${r.state === 'started' ? 'stateGood' : 'stateBad'}">${escapeHtml(r.state)}</span></div>`
  ).join('');

  document.getElementById('panelBody').innerHTML = html;
}

function escapeHtml(str) {
  const d = document.createElement('div');
  d.textContent = String(str ?? '');
  return d.innerHTML;
}

document.getElementById('panelClose').addEventListener('click', closePanel);
document.getElementById('panelSearch').addEventListener('input', (e) => {
  const q = e.target.value.toLowerCase();
  const title = document.getElementById('panelTitle').textContent;
  if (title === 'Chat Log') {
    drawChatLog(currentChatLog.filter(m =>
      (m.message || '').toLowerCase().includes(q) || (m.name || '').toLowerCase().includes(q)
    ));
  } else if (title.startsWith('Online Players')) {
    drawOnlinePlayers((window._onlinePlayersCache || []).filter(p =>
      (p.name || '').toLowerCase().includes(q) || String(p.id).includes(q)
    ));
  }
});

// ============================================================================
// RADIAL QUICK-ACTIONS MENU
// ============================================================================
const RadialActions = [
  { id: 'freeze',  label: 'Freeze Nearest' },
  { id: 'heal',    label: 'Heal Self' },
  { id: 'revive',  label: 'Revive Self' },
  { id: 'spawncar',label: 'Spawn Car' },
  { id: 'tpwp',    label: 'TP Waypoint' },
  { id: 'fixcar',  label: 'Fix Vehicle' },
];

function buildRadial() {
  const ring = document.getElementById('radialRing');
  ring.innerHTML = '';
  const n = RadialActions.length;
  const radius = 120;
  RadialActions.forEach((a, i) => {
    const angle = (i / n) * 2 * Math.PI - Math.PI / 2;
    const x = 160 + radius * Math.cos(angle) - 55;
    const y = 160 + radius * Math.sin(angle) - 23;
    const el = document.createElement('div');
    el.className = 'radialSlice';
    el.style.left = `${x}px`;
    el.style.top = `${y}px`;
    el.textContent = a.label;
    el.addEventListener('click', () => {
      post('radialAction', { action: a.id });
      hideRadial();
    });
    ring.appendChild(el);
  });
}

function showRadial() {
  buildRadial();
  document.getElementById('radial').classList.remove('hidden');
}
function hideRadial() {
  document.getElementById('radial').classList.add('hidden');
  post('closeRadial');
}

// ============================================================================
// NEW-REPORT TOAST
// ============================================================================
let toastTimer = null;
function showToast(count) {
  let toast = document.getElementById('reportToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'reportToast';
    document.body.appendChild(toast);
  }
  toast.textContent = count > 1 ? `${count} New Reports!` : 'New Report!';
  toast.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove('show'), 4000);
}

// ============================================================================
// MESSAGE ROUTER (from Lua)
// ============================================================================
window.addEventListener('message', (event) => {
  const { type, data, count, name } = event.data;
  switch (type) {
    case 'stats': renderStats(data); break;
    case 'inspect': renderInspect(data); break;
    case 'chatlog': renderChatLog(data); break;
    case 'showRadial': showRadial(); break;
    case 'hideRadial': hideRadial(); break;
    case 'newReportAlert': showToast(count); break;
    case 'screenshot': renderScreenshot(data, name); break;
    case 'vehiclelist': renderVehicleList(data); break;
    case 'onlineplayers': renderOnlinePlayers(data); break;
    case 'dashboard': renderDashboard(data); break;
  }
});

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape') {
    closePanel();
    hideRadial();
  }
});
