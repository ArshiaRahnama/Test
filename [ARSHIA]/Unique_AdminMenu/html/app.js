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

  let html = '';
  if (data.flag) {
    html += `<div class="sectionTitle sectionWarn">🚩 FLAGGED - ${escapeHtml(data.flag.note)}</div>`;
    html += `<div class="infoRow"><span>Flagged by ${escapeHtml(data.flag.admin_name || '?')}</span><span>${escapeHtml(data.flag.created_at || '')}</span></div>`;
  }

  if (data.trustScore !== undefined) {
    const tColor = data.trustScore >= 80 ? '#5fae72' : data.trustScore >= 50 ? '#c9a24b' : '#c85450';
    const b = data.trustBreakdown || {};
    html += `<div class="infoRow"><span>Trust Score</span><span style="color:${tColor};font-weight:600;">${data.trustScore}/100</span></div>`;
    html += `<div class="rMeta" style="padding:0 0 8px;">${b.warnings || 0} warnings &middot; ${b.bans || 0} bans &middot; ${b.punishments || 0} kicks/jails/CS</div>`;
  }

  const rows = [
    ['Identifier', data.identifier],
    ['Job', data.job ? `${data.job.label || data.job.name} (grade ${data.job.grade})` : 'n/a'],
    ['Cash', data.money ?? 'n/a'],
    ['Bank', data.bank ?? 'n/a'],
    ['Permission Level', data.permission_level ?? '0'],
    ['Ping', data.ping ?? 'n/a'],
    ['Inventory Items', data.inventory ? data.inventory.length : 'n/a'],
  ];

  html += rows.map(([k, v]) =>
    `<div class="infoRow"><span>${k}</span><span>${v}</span></div>`
  ).join('');

  if (data.linkedAccounts && data.linkedAccounts.length) {
    html += `<div class="sectionTitle sectionWarn">⚠ Possible Alt Accounts (${data.linkedAccounts.length})</div>`;
    html += data.linkedAccounts.map(a =>
      `<div class="infoRow"><span>${escapeHtml(a.playername || 'Unknown')}</span><span>${escapeHtml(a.identifier)}</span></div>`
    ).join('');
  }

  html += `<div class="sectionTitle">Owned Vehicles (${(data.vehicles || []).length})</div>`;
  html += (data.vehicles && data.vehicles.length)
    ? data.vehicles.map(v =>
        `<div class="infoRow"><span>${escapeHtml(v.modelLabel || v.plate)} <span class="rMeta">(${escapeHtml(v.plate)})</span></span><span>${v.stored ? 'In Garage' : 'Impound/Out'}${v.job ? ' - ' + escapeHtml(v.job) : ''}</span></div>`
      ).join('')
    : `<div class="rMeta">No owned vehicles found</div>`;

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
function renderOnlinePlayers(list, title) {
  openPanel(`${title || 'Online Players'} (${list.length})`, true);
  drawOnlinePlayers(list);
  window._onlinePlayersCache = list;
}
function drawOnlinePlayers(list) {
  if (!list.length) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>No players online</span></div>';
    return;
  }
  document.getElementById('panelBody').innerHTML = list.map(p => {
    const t = p.trustScore;
    const trustColor = t === undefined || t === null ? '#888' : t >= 80 ? '#5fae72' : t >= 50 ? '#c9a24b' : '#c85450';
    const trustBadge = (t !== undefined && t !== null)
      ? `<span title="Trust Score" style="display:inline-block;min-width:26px;padding:1px 5px;margin-right:6px;border-radius:4px;background:${trustColor};color:#111;font-weight:600;font-size:11px;text-align:center;">${t}</span>`
      : '';
    return `
    <div class="infoRow"${p.flagNote ? ' style="border-left:3px solid #e08a3c;"' : ''}>
      <span>${trustBadge}${p.flagNote ? '🚩 ' : ''}[${p.id}] ${escapeHtml(p.name)} <span class="rMeta">(${escapeHtml(p.job)})</span>${p.flagNote ? `<br><span class="rMeta">flag: ${escapeHtml(p.flagNote)}</span>` : ''}</span>
      <span>${p.ping}ms - ${p.sessionMinutes}m session</span>
    </div>
  `;
  }).join('');
}

// ============================================================================
// PANEL: DASHBOARD
// ============================================================================
function renderDashboard(data) {
  openPanel('Server Dashboard', false);
  let html = `<div class="sectionTitle">Staff On Duty (${(data.staff || []).length})</div>`;
  html += (data.staff && data.staff.length)
    ? data.staff.map(s => `<div class="infoRow"><span>${escapeHtml(s.name)} (id: ${s.source})</span><span>${s.dutyMinutes}m on duty &middot; ${s.actions} actions${s.satisfaction !== undefined && s.satisfaction !== null ? ` &middot; ${s.satisfaction}% satisfaction (${s.ratingCount})` : ''}${s.avgResponseMinutes !== undefined && s.avgResponseMinutes !== null ? ` &middot; ~${s.avgResponseMinutes}m avg response` : ''}</span></div>`).join('')
    : `<div class="rMeta">No admins currently on duty</div>`;

  html += `<div class="sectionTitle">Top 10 Richest Players</div>`;
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
  } else if (title.startsWith('Online Players') || title.startsWith('New Players')) {
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
    case 'onlineplayers': renderOnlinePlayers(data.list || data, data.title); break;
    case 'dashboard': renderDashboard(data); break;
    case 'buttonperms': renderButtonPerms(data); break;
    case 'proximity': renderProximity(data); break;
    case 'economychart': renderEconomyChart(data); break;
    case 'factionchart': renderFactionChart(data); break;
  }
});

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape') {
    closePanel();
    hideRadial();
  }
});

// ============================================================================
// PANEL: VOICE PROXIMITY
// ============================================================================
function renderProximity(data) {
  openPanel(data.title || 'Voice Proximity Check', false);
  const lines = data.lines || [];
  document.getElementById('panelBody').innerHTML = lines.length
    ? lines.map(l => `<div class="infoRow"><span>${escapeHtml(l)}</span></div>`).join('')
    : '<div class="infoRow"><span>No one nearby.</span></div>';
}

// ============================================================================
// PANEL: BUTTON PERMISSIONS
// ============================================================================
function renderButtonPerms(data) {
  openPanel('Button Permissions', false);
  const catalog = data.catalog || [];
  const perms = data.perms || {};
  const defaultLevel = data.defaultLevel ?? 1;

  const byCategory = {};
  catalog.forEach(b => {
    (byCategory[b.category] ||= []).push(b);
  });

  let html = `<div class="rMeta" style="padding:0 0 8px;">Minimum permission_level required to SEE each button. Blank = uses the server default (${defaultLevel}).</div>`;
  Object.keys(byCategory).forEach(cat => {
    html += `<div class="sectionTitle">${escapeHtml(cat)}</div>`;
    html += byCategory[cat].map(b => `
      <div class="infoRow">
        <span>${escapeHtml(b.label)}</span>
        <input type="number" min="0" max="20" class="permInput" data-id="${b.id}"
               value="${perms[b.id] ?? ''}" placeholder="${defaultLevel}"
               style="width:60px;text-align:center;" />
      </div>
    `).join('');
  });
  document.getElementById('panelBody').innerHTML = html;

  document.querySelectorAll('.permInput').forEach(input => {
    input.addEventListener('change', () => {
      const level = input.value === '' ? null : parseInt(input.value, 10);
      post('setButtonPerm', { id: input.dataset.id, level: level ?? defaultLevel });
    });
  });
}

// ============================================================================
// PANEL: ECONOMY CHART
// ============================================================================
function buildLineChartSVG(totals) {
  const w = 600, h = 260, pad = 40;
  const maxV = Math.max(...totals) * 1.1 || 1;
  const minV = Math.min(0, Math.min(...totals));
  const stepX = (w - pad * 2) / (totals.length - 1);
  const scaleY = v => h - pad - ((v - minV) / (maxV - minV || 1)) * (h - pad * 2);

  const path = totals.map((v, i) => `${i === 0 ? 'M' : 'L'} ${pad + i * stepX} ${scaleY(v)}`).join(' ');
  const last = totals[totals.length - 1];
  const first = totals[0];
  const trendColor = last >= first ? '#5fae72' : '#c85450';

  let svg = `<svg viewBox="0 0 ${w} ${h}" style="width:100%;height:auto;background:rgba(255,255,255,0.03);border-radius:8px;">`;
  svg += `<line x1="${pad}" y1="${h - pad}" x2="${w - pad}" y2="${h - pad}" stroke="rgba(255,255,255,0.2)" />`;
  svg += `<line x1="${pad}" y1="${pad / 2}" x2="${pad}" y2="${h - pad}" stroke="rgba(255,255,255,0.2)" />`;
  svg += `<path d="${path}" fill="none" stroke="${trendColor}" stroke-width="2.5" />`;
  svg += `<text x="${pad}" y="${pad / 2 - 6}" fill="#ddd" font-size="12">Max: $${maxV.toLocaleString()}</text>`;
  svg += `<text x="${w - pad}" y="${h - pad + 20}" fill="#ddd" font-size="11" text-anchor="end">Latest: $${last.toLocaleString()}</text>`;
  svg += `<text x="${pad}" y="${h - pad + 20}" fill="#ddd" font-size="11">Oldest: $${first.toLocaleString()}</text>`;
  svg += `</svg>`;
  return svg;
}

function renderEconomyChart(data) {
  openPanel('Economy Health (Total Cash + Bank)', false);
  const points = data.points || [];

  if (points.length < 2) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>Not enough snapshots yet - check back later.</span></div>';
    return;
  }

  const totals = points.map(p => p.total_cash + p.total_bank);
  document.getElementById('panelBody').innerHTML = buildLineChartSVG(totals) +
    `<div class="rMeta" style="padding-top:8px;">${points.length} snapshots &middot; latest player count: ${points[points.length - 1].player_count}</div>`;
}

function renderFactionChart(data) {
  openPanel(`${data.accountName || 'Faction'} Treasury History`, false);
  const points = data.points || [];

  if (points.length < 2) {
    document.getElementById('panelBody').innerHTML = '<div class="infoRow"><span>Not enough snapshots yet - check back later.</span></div>';
    return;
  }

  const totals = points.map(p => p.balance);
  document.getElementById('panelBody').innerHTML = buildLineChartSVG(totals) +
    `<div class="rMeta" style="padding-top:8px;">${points.length} snapshots</div>`;
}
