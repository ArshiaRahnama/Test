/* ==========================================================
   UNIQUE EVENT - NUI logic
   Sections: helpers / toast+banner+center+progress / menu+dialog / HUDs / hub (/uevent) / message router
   ========================================================== */
'use strict';

const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'Unique_Event';
const $ = (s, r) => (r || document).querySelector(s);
const $$ = (s, r) => Array.from((r || document).querySelectorAll(s));
const post = (name, data) => {
  try {
    return fetch('https://' + RES + '/' + name, {
      method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data || {}),
    }).catch(() => {});
  } catch (e) { return null; }
};
const esc = (v) => String(v === undefined || v === null ? '' : v).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const num = (v, d) => { const n = Number(v); return Number.isFinite(n) ? n : (d || 0); };
const fmt = (v) => num(v).toLocaleString('en-US');
const show = (el, on) => { if (el) el.classList.toggle('hidden', !on); };
const safeImg = (u) => (typeof u === 'string' && /^(https?:\/\/|nui:\/\/|img\/|\.\/|data:image\/)/i.test(u)) ? u : 'img/no_photo.png';
const clamp = (v, a, b) => Math.min(b, Math.max(a, v));

/* ---------- tiny sound effects (no assets needed) ---------- */
let audioCtx = null;
function blip(freq, dur, vol, type) {
  try {
    audioCtx = audioCtx || new (window.AudioContext || window.webkitAudioContext)();
    const o = audioCtx.createOscillator(); const g = audioCtx.createGain();
    o.type = type || 'sine'; o.frequency.value = freq;
    g.gain.value = vol || 0.03; g.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + (dur || 0.08));
    o.connect(g); g.connect(audioCtx.destination); o.start(); o.stop(audioCtx.currentTime + (dur || 0.08));
  } catch (e) { /* audio is optional */ }
}
function playFile(file, volume) {
  if (!file) return;
  try {
    const src = String(file).indexOf('/') >= 0 ? file : 'sounds/' + file;
    const a = new Audio(src); a.volume = clamp(num(volume, 0.4), 0, 1); a.play().catch(() => {});
  } catch (e) { /* ignore */ }
}

/* ==========================================================
   TOASTS / BANNER / CENTER / PROGRESS
   ========================================================== */
const TOAST_ICONS = { success: '✓', error: '✕', warn: '!', info: 'i' };
function toast(d) {
  const box = $('#toasts'); if (!box) return;
  const type = TOAST_ICONS[d.type] ? d.type : 'info';
  const ms = num(d.ms, 4800);
  const el = document.createElement('div');
  el.className = 'toast ' + type;
  el.innerHTML = '<div class="t-ic">' + TOAST_ICONS[type] + '</div><div class="t-body">' +
    (d.title ? '<div class="t-title">' + esc(d.title) + '</div>' : '') + '<div class="t-msg">' + esc(d.msg) + '</div></div>' +
    '<div class="t-time" style="animation-duration:' + ms + 'ms"></div>';
  box.appendChild(el);
  while (box.children.length > 6) box.removeChild(box.firstChild);
  setTimeout(() => { el.classList.add('out'); setTimeout(() => el.remove(), 320); }, ms);
  blip(type === 'error' ? 220 : 660, 0.09, 0.025, 'triangle');
}

let bannerTimer = null;
function banner(d) {
  const el = $('#banner'); if (!el) return;
  const kind = ['success', 'warn', 'error', 'info', 'gold'].includes(d.kind) ? d.kind : 'info';
  const tags = { success: 'SUCCESS', warn: 'WARNING', error: 'ALERT', info: 'EVENT', gold: 'WINNER' };
  el.className = kind;
  $('.banner-tag', el).textContent = tags[kind];
  $('.banner-text', el).textContent = d.text || '';
  const inner = $('.banner-inner', el);
  inner.style.animation = 'none'; void inner.offsetWidth; inner.style.animation = '';
  show(el, true);
  clearTimeout(bannerTimer);
  bannerTimer = setTimeout(() => show(el, false), num(d.secs, 5) * 1000);
  blip(520, 0.14, 0.03, 'square');
}
show($('#banner'), false);

function centerText(d) {
  const el = $('#center'); const s = $('span', el);
  if (!d.text) { show(el, false); s.textContent = ''; return; }
  s.textContent = d.text; show(el, true);
  s.style.animation = 'none'; void s.offsetWidth; s.style.animation = '';
}
show($('#center'), false);

function progress(d) {
  const el = $('#progress'); const fill = $('.pg-fill', el);
  $('.pg-label', el).textContent = d.label || '';
  fill.style.transition = 'none'; fill.style.width = '0%'; void fill.offsetWidth;
  fill.style.transition = 'width ' + num(d.ms, 1000) + 'ms linear'; fill.style.width = '100%';
  el.classList.add('on');
}
function progressStop() { $('#progress').classList.remove('on'); }

/* ==========================================================
   MENU + DIALOG
   ========================================================== */
let menuState = { open: false, count: 0 };
function menuOpen(d) {
  $('#menuTitle').textContent = d.title || 'Menu';
  $('#menuSub').textContent = d.subtitle || '';
  show($('#menuBack'), !!d.back);
  const list = $('#menuItems'); list.innerHTML = '';
  let sel = 0;
  (d.items || []).forEach((it, i) => {
    if (it.header) {
      const h = document.createElement('div'); h.className = 'm-head'; h.textContent = it.label; list.appendChild(h); return;
    }
    sel += 1;
    const row = document.createElement('div');
    row.className = 'm-item' + (it.disabled ? ' disabled' : '');
    row.style.animationDelay = (i * 25) + 'ms';
    const icon = it.icon ? esc(it.icon) : String(sel);
    row.innerHTML = '<div class="mi-ic">' + icon + '</div><div class="mi-t"><div class="mi-l">' + esc(it.label) + '</div>' +
      (it.sub ? '<div class="mi-s">' + esc(it.sub) + '</div>' : '') + '</div>' + (it.tag ? '<div class="mi-tag">' + esc(it.tag) + '</div>' : '');
    row.addEventListener('click', () => { if (!it.disabled) { blip(740, 0.07); post('menu:select', { index: i }); } });
    row.addEventListener('mouseenter', () => blip(420, 0.03, 0.012));
    row.dataset.index = String(i);
    list.appendChild(row);
  });
  menuState.open = true; show($('#menu'), true);
}
function menuClose() { menuState.open = false; show($('#menu'), false); }
$('#menuBack').addEventListener('click', () => post('menu:back', {}));
$('#menuX').addEventListener('click', () => { menuClose(); post('menu:closed', {}); });

function dialogOpen(d) {
  $('#dlgTitle').textContent = d.title || 'Input';
  const inp = $('#dlgInput');
  inp.placeholder = d.placeholder || ''; inp.value = d.value || '';
  inp.dataset.numeric = d.numeric ? '1' : '';
  show($('#dialog'), true);
  setTimeout(() => inp.focus(), 60);
}
function dialogSubmit() {
  const v = $('#dlgInput').value; show($('#dialog'), false); post('dialog:submit', { value: v });
}
function dialogCancel() { show($('#dialog'), false); post('dialog:cancel', {}); }
$('#dlgOk').addEventListener('click', dialogSubmit);
$('#dlgCancel').addEventListener('click', dialogCancel);
$('#dlgInput').addEventListener('keydown', (e) => { if (e.key === 'Enter') dialogSubmit(); });
$('#dlgInput').addEventListener('input', (e) => { if (e.target.dataset.numeric) e.target.value = e.target.value.replace(/[^0-9.\-]/g, ''); });

/* ==========================================================
   SHARED HUD PIECES
   ========================================================== */
function boardRows(target, rows, valueKey, opts) {
  opts = opts || {};
  target.innerHTML = '';
  if (!rows || !rows.length) { target.innerHTML = '<div class="board-empty">No data yet</div>'; return; }
  rows.slice(0, opts.limit || 5).forEach((r, i) => {
    const row = document.createElement('div');
    row.className = 'row' + (r.you ? ' you' : '');
    row.innerHTML = '<span class="rk">' + (i + 1) + '</span>' + (opts.img ? '<img src="' + esc(safeImg(r.img)) + '" alt="">' : '') +
      '<span class="nm">' + esc(r.name) + '</span><span class="vl">' + esc(r[valueKey] !== undefined ? r[valueKey] : '') + '</span>';
    target.appendChild(row);
  });
}

function killLog(id, html, kind) {
  const box = $('#' + id); if (!box) return;
  const el = document.createElement('div'); el.className = 'kl'; el.innerHTML = html;
  if (kind === 'you') el.style.borderRightColor = 'var(--green)';
  box.appendChild(el);
  while (box.children.length > 6) box.removeChild(box.firstChild);
  setTimeout(() => { el.classList.add('out'); setTimeout(() => el.remove(), 420); }, 6500);
}

/* ==========================================================
   CAPTURE HUD
   ========================================================== */
const CAP = {
  show(d) { show($('#capHud'), !!d.show); if (!d.show) { $('#capKillLog').innerHTML = ''; show($('#capProgress'), false); } },
  data(d) {
    if (d.time !== undefined) $('#capTime').textContent = d.time;
    if (d.percent !== undefined) $('#capTimeBar').style.width = clamp(num(d.percent), 0, 100) + '%';
    if (d.killers) boardRows($('#capKillers'), d.killers, 'points', { img: true });
    if (d.gangs) boardRows($('#capGangs'), d.gangs, 'points', { img: true });
    if (d.alltime) boardRows($('#capAll'), d.alltime, 'score', { img: true });
  },
  boards(d) { show($('#capBoards'), !!d.show); },
  zones(d) {
    const box = $('#capZones'); box.innerHTML = '';
    (d.zones || []).forEach((z) => {
      const el = document.createElement('div'); el.className = 'zone-chip ' + (z.state || 'free');
      el.innerHTML = '<span class="dot"></span><span>' + esc(z.name) + '</span><span class="own">' + esc(z.owner || 'FREE') + '</span>';
      box.appendChild(el);
    });
  },
  progress(d) {
    const el = $('#capProgress'); show(el, true);
    el.classList.remove('contested', 'holding');
    if (d.state === 'contested') el.classList.add('contested');
    if (d.state === 'holding') el.classList.add('holding');
    $('#cpZone').textContent = String(d.zone || '').toUpperCase();
    $('#cpText').textContent = d.state === 'contested' ? 'CONTESTED!' : (d.state === 'holding' ? 'HOLDING ZONE' : 'CAPTURING  ' + num(d.sec) + ' / ' + num(d.need));
    $('#cpFill').style.width = clamp(d.state === 'holding' ? 100 : (num(d.sec) / Math.max(1, num(d.need))) * 100, 0, 100) + '%';
  },
  progressHide() { show($('#capProgress'), false); },
  kill(d) {
    killLog('capKillLog', '<b class="k">' + esc(d.killer) + '</b><i>' + esc(d.killerRank || '') + '</i> eliminated <b class="v">' + esc(d.damaged) + '</b><i>' + esc(d.damagedRank || '') + '</i>', d.you ? 'you' : '');
  },
};

/* ==========================================================
   GUNGAME HUD
   ========================================================== */
const GG = {
  show(d) {
    show($('#ggHud'), !!d.show);
    if (!d.show) { show($('#ggCountdown'), false); show($('#ggTimerBox'), false); show($('#ggMVP'), false); $('#ggKillLog').innerHTML = ''; }
  },
  countdown(d) {
    show($('#ggCountdown'), true);
    const n = $('#ggCdNum'); n.textContent = d.n; n.style.animation = 'none'; void n.offsetWidth; n.style.animation = '';
    blip(d.n <= 3 ? 880 : 520, 0.12, 0.05, 'square');
  },
  countdownHide() { show($('#ggCountdown'), false); },
  timer(d) { show($('#ggTimerBox'), true); $('#ggTimer').textContent = d.text; $('#ggTimerBox').style.color = d.low ? 'var(--red)' : ''; },
  timerHide() { show($('#ggTimerBox'), false); },
  level(d) {
    $('#ggLevelNum').textContent = d.level; $('#ggLevelTotal').textContent = '/ ' + d.total;
    $('#ggWeapon').textContent = d.weapon || '-'; $('#ggLevelBar').style.width = clamp((num(d.level) / Math.max(1, num(d.total))) * 100, 0, 100) + '%';
  },
  board(d) { boardRows($('#ggRows'), d.rows || [], 'level', { limit: d.limit || 6 }); if (d.visible !== undefined) show($('#ggBoard'), !!d.visible); },
  boardToggle(d) { show($('#ggBoard'), !!d.show); },
  kill(d) { killLog('ggKillLog', '<b class="k">' + esc(d.killer) + '</b> eliminated <b class="v">' + esc(d.victim) + '</b>', d.you ? 'you' : ''); },
  mvp(d) {
    const el = $('#ggMVP');
    let rows = '';
    (d.rows || []).slice(0, 5).forEach((r, i) => { rows += '<div class="row"><span class="rk">' + (i + 1) + '</span><span class="nm">' + esc(r.name) + '</span><span class="vl">Lv ' + esc(r.level) + ' · ' + esc(r.kills) + ' kills</span></div>'; });
    el.innerHTML = '<div class="m-tag">MATCH MVP</div>' + (d.card ? '<div class="m-card" style="background-image:url(\'' + esc(d.card) + '\')"></div>' : '') +
      '<div class="m-name">' + esc(d.name) + '</div><div class="m-sub">' + esc(d.kills) + ' KILLS  ·  LEVEL ' + esc(d.level) + '</div>' +
      (d.isYou ? '<div class="m-you">YOU WON!</div>' : '') + (rows ? '<div class="m-list">' + rows + '</div>' : '');
    show(el, true); blip(660, 0.3, 0.05, 'triangle');
  },
  mvpHide() { show($('#ggMVP'), false); },
};

/* ==========================================================
   WARZONE HUD
   ========================================================== */
const WZ = {
  show(d) {
    show($('#wzHud'), !!d.show);
    if (!d.show) { ['wzDowned', 'wzLobby', 'wzSpec', 'wzWinner', 'wzZone'].forEach((id) => show($('#' + id), false)); $('#wzKillLog').innerHTML = ''; $('#wzSquad').innerHTML = ''; }
  },
  part(d) { show($('#wzBottom'), d.bottom !== false); $$('#wzHud .wz-counts, #wzSquad').forEach((e) => show(e, d.top !== false)); },
  counts(d) { $('#wzSquads').textContent = d.squads; $('#wzAlive').textContent = d.alive; $('#wzKills').textContent = d.kills; },
  stats(d) {
    if (d.hp !== undefined) { $('#wzHp').style.width = clamp(num(d.hp), 0, 100) + '%'; $('#wzHpText').textContent = Math.round(num(d.hp)); }
    if (d.armor !== undefined) { $('#wzAr').style.width = clamp(num(d.armor), 0, 100) + '%'; $('#wzArText').textContent = Math.round(num(d.armor)); }
    if (d.vest !== undefined) $('#wzItemVest').textContent = d.vest;
    if (d.heal !== undefined) $('#wzItemHeal').textContent = d.heal;
    if (d.uav !== undefined) $('#wzItemUav').textContent = d.uav;
    if (d.revive !== undefined) $('#wzItemRev').textContent = d.revive;
    if (d.cash !== undefined) $('#wzCash').textContent = '$' + fmt(d.cash);
    if (d.lives !== undefined) $('#wzLives').textContent = d.lives;
  },
  squad(d) {
    const box = $('#wzSquad'); box.innerHTML = '';
    (d.mates || []).forEach((m) => {
      const el = document.createElement('div'); el.className = 'mate' + (m.downed ? ' down' : '');
      el.innerHTML = '<div class="mn"><span>' + esc(m.name) + '</span>' + (m.downed ? '<em>DOWN</em>' : '') + '</div><div class="mb"><i style="width:' + clamp(num(m.hp), 0, 100) + '%"></i></div><div class="mb a"><i style="width:' + clamp(num(m.armor), 0, 100) + '%"></i></div>';
      box.appendChild(el);
    });
  },
  kill(d) { killLog('wzKillLog', d.html ? d.html : '<b class="k">' + esc(d.killer) + '</b> eliminated <b class="v">' + esc(d.victim) + '</b>', d.you ? 'you' : ''); },
  feed(d) { killLog('wzKillLog', esc(d.text), d.kind); },
  downed(d) {
    show($('#wzDowned'), !!d.show);
    if (d.show) { $('#wzdSub').textContent = d.text || 'Waiting for a teammate...'; $('#wzdBar').style.width = clamp(num(d.pct, 100), 0, 100) + '%'; }
  },
  lobby(d) {
    show($('#wzLobby'), !!d.show);
    if (!d.show) return;
    $('#wzlPlayers').textContent = d.players; $('#wzlNeed').textContent = d.needed; $('#wzlMode').textContent = d.mode || '-'; $('#wzlMap').textContent = d.map || '-';
    show($('#wzlCdBox'), d.countdown !== undefined && d.countdown !== null && d.countdown >= 0);
    $('#wzlCd').textContent = d.countdown;
  },
  zone(d) {
    const el = $('#wzZone'); show(el, !!d.show); if (!d.show) return;
    el.classList.toggle('out', !!d.out);
    $('#wzZoneLabel').textContent = d.label || 'SAFE ZONE'; $('#wzZoneDist').textContent = d.text || '';
    $('#wzZoneFill').style.width = clamp(num(d.pct, 100), 0, 100) + '%';
  },
  spec(d) { show($('#wzSpec'), !!d.show); if (d.show) $('#wzSpecName').textContent = d.name || '-'; },
  winner(d) {
    const el = $('#wzWinner');
    el.innerHTML = '<div class="w-tag">' + (d.isYou ? 'CONGRATULATIONS' : 'MATCH OVER') + '</div><div class="w-big">' + (d.isYou ? 'VICTORY' : 'WINNERS') + '</div><div class="w-names">' + esc(d.names || '') + '</div>';
    show(el, true); blip(700, 0.4, 0.05, 'triangle');
  },
  winnerHide() { show($('#wzWinner'), false); },
};

/* ==========================================================
   HUB  (/uevent)
   ========================================================== */
const HUB = {
  open: false, page: 'overview', data: null, lb: null, pages: {}, me: null, clockTimer: null,
};

const NAV_ICONS = {
  overview: '<path d="M4 12 12 4l8 8"/><path d="M6 10v9h12v-9"/>',
  capture: '<circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="3"/>',
  gungame: '<path d="M3 12h4l2-3 3 6 2-3h7"/>',
  warzone: '<path d="M12 2 20 6v6c0 5-4 8-8 8s-8-3-8-8V6z"/>',
  admin: '<path d="M12 3 4 6v6c0 5 3.6 8 8 9 4.4-1 8-4 8-9V6z"/><path d="M9 12l2 2 4-4"/>',
};
const EV_ICON_SVG = {
  capture: '<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="currentColor" stroke-width="6"/><circle cx="50" cy="50" r="24" fill="none" stroke="currentColor" stroke-width="6"/><circle cx="50" cy="50" r="8" fill="currentColor"/></svg>',
  gungame: '<svg viewBox="0 0 100 100"><path d="M10 55h20l10-16 14 30 10-14h26" fill="none" stroke="currentColor" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/></svg>',
  warzone: '<svg viewBox="0 0 100 100"><path d="M50 6 90 24v26c0 24-18 38-40 44-22-6-40-20-40-44V24z" fill="none" stroke="currentColor" stroke-width="6" stroke-linejoin="round"/><path d="M38 50l8 8 18-18" fill="none" stroke="currentColor" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/></svg>',
};

function hubOpenUI() {
  HUB.open = true; HUB.page = 'overview';
  show($('#hub'), true);
  startFX();
  clearInterval(HUB.clockTimer);
  HUB.clockTimer = setInterval(() => { $('#clock').textContent = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }); }, 1000);
  $('#clock').textContent = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}
function hubCloseUI() {
  HUB.open = false; show($('#hub'), false); clearInterval(HUB.clockTimer); stopFX();
  post('hub:close', {});
}
$('#hubX').addEventListener('click', hubCloseUI);

function hubSetData(data) {
  HUB.data = data; HUB.me = data.me;
  renderNav();
  renderMeCard();
  renderPage();
}

function renderNav() {
  const nav = $('#nav'); nav.innerHTML = '';
  const items = [
    { id: 'overview', label: 'Overview' },
    { id: 'capture', label: 'Capture', color: 'var(--cap)' },
    { id: 'gungame', label: 'GunGame', color: 'var(--gg)' },
    { id: 'warzone', label: 'WarZone', color: 'var(--wz)' },
  ];
  items.forEach((it) => {
    if (it.id !== 'overview' && HUB.data.events[it.id] && HUB.data.events[it.id].enabled === false) return;
    const b = document.createElement('button');
    b.className = 'nav-btn' + (HUB.page === it.id ? ' active' : '');
    if (it.color) b.style.setProperty('--nc', it.color);
    let badge = '';
    const st = HUB.data.events[it.id];
    if (st && st.state === 'live') badge = '<span class="nb">LIVE</span>';
    else if (st && st.youIn) badge = '<span class="nb">IN</span>';
    b.innerHTML = '<svg viewBox="0 0 24 24">' + (NAV_ICONS[it.id] || '') + '</svg><span>' + it.label + '</span>' + badge;
    b.addEventListener('click', () => { blip(500, 0.05); switchPage(it.id); });
    nav.appendChild(b);
  });
  if (HUB.me && (HUB.me.admin.capture || HUB.me.admin.gungame || HUB.me.admin.warzone)) {
    const sep = document.createElement('div'); sep.className = 'nav-sep'; nav.appendChild(sep);
    const b = document.createElement('button');
    b.className = 'nav-btn' + (HUB.page === 'admin' ? ' active' : ''); b.style.setProperty('--nc', 'var(--violet)');
    b.innerHTML = '<svg viewBox="0 0 24 24">' + NAV_ICONS.admin + '</svg><span>Admin</span>';
    b.addEventListener('click', () => { blip(500, 0.05); switchPage('admin'); });
    nav.appendChild(b);
  }
}

function renderMeCard() {
  const me = HUB.me; if (!me) return;
  const initial = (me.name || '?').trim().charAt(0).toUpperCase();
  $('#meCard').innerHTML = '<div class="me-av">' + esc(initial) + '</div><div class="me-t"><b>' + esc(me.name) + '</b><span>' + esc(me.gang !== 'nogang' ? me.gang : 'No gang') + '</span></div>';
}

function switchPage(id) {
  HUB.page = id;
  renderNav();
  const titles = { overview: ['OVERVIEW', 'Every event at a glance'], capture: ['CAPTURE', 'Gang territory warfare'], gungame: ['GUNGAME', 'First to the last weapon wins'], warzone: ['WARZONE', 'Last squad standing'], admin: ['ADMIN', 'Moderation tools'] };
  $('#topTitle').textContent = titles[id][0]; $('#topSub').textContent = titles[id][1];
  const pillMap = { capture: 'cap', gungame: 'gg', warzone: 'wz' };
  $('#topEvent').textContent = ''; $('#topEvent').className = 'pill';
  if (pillMap[id] && HUB.data.events[id]) {
    const st = HUB.data.events[id];
    $('#topEvent').textContent = (st.state || 'idle').toUpperCase();
    $('#topEvent').className = 'pill ' + (st.state === 'live' ? 'live' : st.state === 'open' ? 'open' : 'off');
  }
  if (id !== 'overview' && id !== 'admin') post('hub:page', { event: id });
  else renderPage();
}

function renderPage() {
  if (HUB.page === 'overview') return renderOverview();
  if (HUB.page === 'admin') return renderAdmin();
  renderEventPage(HUB.page, HUB.pages[HUB.page]);
}

function hubPageData(msg) {
  HUB.pages[msg.event] = msg.page;
  if (HUB.page === msg.event) renderEventPage(msg.event, msg.page);
}

/* ---------- OVERVIEW ---------- */
function renderOverview() {
  const d = HUB.data; const c = $('#content'); c.innerHTML = '';
  const hero = document.createElement('div'); hero.className = 'hero'; hero.style.setProperty('--i', 0);
  const liveCount = ['capture', 'gungame', 'warzone'].filter((k) => d.events[k] && d.events[k].state === 'live').length;
  const totalPlaying = ['capture', 'gungame', 'warzone'].reduce((s, k) => s + num(d.events[k] && (d.events[k].players || d.events[k].playing || d.events[k].matchPlayers || d.events[k].lobby)), 0);
  hero.innerHTML = '<div class="hero-orb"></div><h1>UNIQUE EVENTS</h1><p>' + esc(d.me.brand) + ' — pick a battlefield. Capture territory, climb the GunGame ladder, or drop into WarZone and be the last one standing.</p>' +
    '<div class="hero-stats"><div class="hs"><b>' + liveCount + '</b><span>LIVE NOW</span></div><div class="hs"><b>' + totalPlaying + '</b><span>PLAYERS IN EVENTS</span></div><div class="hs"><b>' + (d.me.inEventLabel || 'None') + '</b><span>YOUR STATUS</span></div></div>';
  c.appendChild(hero);

  const grid = document.createElement('div'); grid.className = 'ev-grid'; grid.style.setProperty('--i', 1);
  const cards = [
    { id: 'capture', name: 'CAPTURE', tag: 'Gang Warfare', desc: 'Fight rival gangs for control of zones across the map. Hold a point to score, dominate the leaderboard.',
      meta: [['ZONES OWNED', (d.events.capture.zonesOwned || 0) + ' / ' + (d.events.capture.zonesTotal || 0)], ['PLAYERS', d.events.capture.players || 0]] },
    { id: 'gungame', name: 'GUNGAME', tag: 'Weapon Ladder', desc: 'Every kill upgrades your weapon. First to win with the final weapon on the ladder takes the match.',
      meta: [['IN QUEUE', (d.events.gungame.queue || 0) + ' / ' + (d.events.gungame.need || 0)], ['ARENAS LIVE', d.events.gungame.arenas || 0]] },
    { id: 'warzone', name: 'WARZONE', tag: 'Battle Royale', desc: 'Parachute in, loot up, and survive a shrinking safe zone with your squad. Lose once, fight back through the Gulag.',
      meta: [['LOBBY', (d.events.warzone.lobby || 0) + ' / ' + (d.events.warzone.needed || 0)], ['IN MATCH', d.events.warzone.matchPlayers || 0]] },
  ];
  cards.forEach((card) => {
    const st = d.events[card.id];
    if (st.enabled === false) return;
    const el = document.createElement('div'); el.className = 'ev-card ' + card.id;
    const pillClass = st.state === 'live' ? 'live' : st.state === 'open' ? 'open' : 'off';
    el.innerHTML = '<div class="ev-art">' + (EV_ICON_SVG[card.id] || '') + '<div class="ev-status"><span class="pill ' + pillClass + '">' + esc((st.state || 'idle').toUpperCase()) + '</span></div>' +
      '<div class="ev-name"><b>' + card.name + '</b><span>' + card.tag + '</span></div></div>' +
      '<div class="ev-body"><div class="ev-desc">' + card.desc + '</div><div class="ev-meta">' +
      card.meta.map((m) => '<div class="meta"><span>' + m[0] + '</span><b>' + esc(m[1]) + '</b></div>').join('') + '</div>' +
      '<div class="ev-actions">' +
      (st.youIn ? '<button class="btn danger block" data-act="leave">LEAVE</button>' : '<button class="btn primary block" data-act="join">' + (card.id === 'capture' ? 'JOIN' : card.id === 'gungame' ? 'QUEUE UP' : 'DROP IN') + '</button>') +
      '<button class="btn ghost" data-act="view">DETAILS</button></div></div>';
    $('[data-act="join"]', el) && $('[data-act="join"]', el).addEventListener('click', (e) => { e.stopPropagation(); hubAction(card.id, 'join'); });
    $('[data-act="leave"]', el) && $('[data-act="leave"]', el).addEventListener('click', (e) => { e.stopPropagation(); hubAction(card.id, 'leave'); });
    $('[data-act="view"]', el).addEventListener('click', () => switchPage(card.id));
    grid.appendChild(el);
  });
  c.appendChild(grid);
}

/* ---------- shared page head ---------- */
function pageHead(acc, icon, title, sub, actionsHtml) {
  return '<div class="page-head" style="--acc:' + acc + '"><div class="ph-ic">' + icon + '</div><div><h2>' + title + '</h2><p>' + sub + '</p></div>' +
    (actionsHtml ? '<div class="ph-actions">' + actionsHtml + '</div>' : '') + '</div>';
}
function rankColor(name) {
  const map = { Bronze: '#c98a4b', Silver: '#c9ccd8', Gold: '#ffd45a', Legend: '#ff2d55' };
  return map[name] || '#888';
}
function rankFor(score) {
  const th = [{ n: 'Legend', m: 400 }, { n: 'Gold', m: 150 }, { n: 'Silver', m: 50 }, { n: 'Bronze', m: 0 }];
  for (const t of th) if (score >= t.m) return t.n;
  return 'Bronze';
}

/* ---------- CAPTURE page ---------- */
function renderCapture(page) {
  const c = $('#content'); const st = HUB.data.events.capture; const stats = page && page.stats;
  let html = pageHead('var(--cap)', EV_ICON_SVG.capture, 'CAPTURE', 'Hold zones, score points, dominate the season.',
    (st.youIn ? '<button class="btn danger" data-act="leave">LEAVE CAPTURE</button>' : '<button class="btn primary" data-act="join">JOIN CAPTURE</button>'));

  html += '<div class="grid g3" style="margin-bottom:16px">' +
    '<div class="stat" style="--acc:var(--cap)"><span>ROUND</span><b>' + (st.state === 'live' ? UE_fmtTime(st.timeLeft) : 'IDLE') + '</b><small>' + (st.state === 'live' ? 'time remaining' : 'no round running') + '</small></div>' +
    '<div class="stat" style="--acc:var(--cap)"><span>ZONES OWNED</span><b>' + (st.zonesOwned || 0) + ' / ' + (st.zonesTotal || 0) + '</b><small>across the map</small></div>' +
    '<div class="stat" style="--acc:var(--cap)"><span>PLAYERS IN</span><b>' + (st.players || 0) + '</b><small>right now</small></div></div>';

  if (stats) {
    html += '<div class="grid g3">';
    html += boardCard('TOP KILLERS THIS ROUND', stats.killers, (r) => r.name, (r) => r.points, 'No kills yet this round');
    html += boardCard('GANG POINTS THIS ROUND', stats.gangs, (r) => r.name, (r) => r.points, 'No points scored yet', true);
    html += '<div class="card"><h3>ALL-TIME LEADERBOARD</h3>' + rankedTable(stats.alltime) + '</div>';
    html += '</div><div class="sec-gap"></div><div class="card"><h3>ZONE CONTROL</h3>' + zoneRows(stats.zones, stats.yourGang) + '</div>';
  }
  c.innerHTML = html;
  bindActs(c, 'capture');
}
function boardCard(title, rows, nameFn, valFn, emptyText, withImg) {
  let body = '<div class="empty">' + emptyText + '</div>';
  if (rows && rows.length) {
    body = '<table class="table"><tbody>' + rows.slice(0, 8).map((r, i) => '<tr><td style="width:34px"><span class="tr-rk">' + (i + 1) + '</span></td><td>' +
      (withImg && r.img ? '<div class="who"><img src="' + esc(safeImg(r.img)) + '"><span>' + esc(nameFn(r)) + '</span></div>' : esc(nameFn(r))) +
      '</td><td class="r">' + esc(valFn(r)) + '</td></tr>').join('') + '</tbody></table>';
  }
  return '<div class="card"><h3>' + title + '</h3>' + body + '</div>';
}
function rankedTable(rows) {
  if (!rows || !rows.length) return '<div class="empty">Nobody has scored yet</div>';
  return '<table class="table"><tbody>' + rows.slice(0, 8).map((r, i) => '<tr class="' + (r.you ? 'tr-you' : '') + '"><td style="width:34px"><span class="tr-rk">' + (i + 1) + '</span></td><td>' + esc(r.name) +
    '</td><td><span class="rank-badge" style="--rc:' + rankColor(rankFor(r.score)) + '">' + rankFor(r.score) + '</span></td><td class="r">' + esc(r.score) + ' pts</td></tr>').join('') + '</tbody></table>';
}
function zoneRows(zones, yourGang) {
  if (!zones || !zones.length) return '<div class="empty">No zones configured</div>';
  return zones.map((z) => '<div class="zone-row"><span class="dot" style="width:9px;height:9px;border-radius:50%;background:' + (z.owner ? (z.owner === yourGang ? 'var(--green)' : 'var(--red)') : '#666') + '"></span><span class="zn">' + esc(z.name) + '</span><span class="zc">' + esc(z.owner || 'Unclaimed') + '</span></div>').join('');
}
function UE_fmtTime(sec) { sec = Math.max(0, Math.floor(num(sec))); return String(Math.floor(sec / 60)).padStart(2, '0') + ':' + String(sec % 60).padStart(2, '0'); }

/* ---------- GUNGAME page ---------- */
function renderGunGame(page) {
  const c = $('#content'); const st = HUB.data.events.gungame; const stats = page && page.stats;
  let action = '<button class="btn primary" data-act="join">JOIN QUEUE</button>';
  if (st.inMatch) action = '<button class="btn ghost" disabled>IN A MATCH</button>';
  else if (st.inQueue) action = '<button class="btn danger" data-act="leave">LEAVE QUEUE</button>';

  let html = pageHead('var(--gg)', EV_ICON_SVG.gungame, 'GUNGAME', 'Climb the weapon ladder. Last upgrade wins.', action);
  html += '<div class="grid g3" style="margin-bottom:16px">' +
    '<div class="stat" style="--acc:var(--gg)"><span>QUEUE</span><b>' + (st.queue || 0) + ' / ' + (st.need || 0) + '</b><small>players waiting</small></div>' +
    '<div class="stat" style="--acc:var(--gg)"><span>LIVE ARENAS</span><b>' + (st.arenas || 0) + '</b><small>matches running</small></div>' +
    '<div class="stat" style="--acc:var(--gg)"><span>PLAYING NOW</span><b>' + (st.playing || 0) + '</b><small>across all arenas</small></div></div>';

  if (page && page.weapons) {
    html += '<div class="card" style="margin-bottom:16px"><h3>WEAPON LADDER</h3><div class="chips">' +
      page.weapons.map((w, i) => '<span class="chip">' + (i + 1) + '. ' + esc(w.replace('WEAPON_', '').replace(/_/g, ' ')) + '</span>').join('') + '</div></div>';
  }
  if (stats) html += '<div class="card"><h3>TOP PLAYERS</h3>' + (function () {
    if (!stats.top || !stats.top.length) return '<div class="empty">No matches played yet</div>';
    return '<table class="table"><thead><tr><th></th><th>Player</th><th class="r">Wins</th><th class="r">Kills</th></tr></thead><tbody>' +
      stats.top.map((r, i) => '<tr class="' + (r.you ? 'tr-you' : '') + '"><td style="width:34px"><span class="tr-rk">' + (i + 1) + '</span></td><td>' + esc(r.name) + '</td><td class="r">' + esc(r.wins) + '</td><td class="r">' + esc(r.kills) + '</td></tr>').join('') + '</tbody></table>';
  })() + '</div>';
  c.innerHTML = html;
  bindActs(c, 'gungame');
}

/* ---------- WARZONE page ---------- */
function renderWarZone(page) {
  const c = $('#content'); const st = HUB.data.events.warzone; const stats = page && page.stats;
  let action = '<button class="btn primary" data-act="join">DROP IN</button>';
  if (st.inMatch) action = '<button class="btn ghost" disabled>IN A MATCH</button>';
  else if (st.inLobby) action = '<button class="btn danger" data-act="leave">LEAVE LOBBY</button>';

  let html = pageHead('var(--wz)', EV_ICON_SVG.warzone, 'WARZONE', 'Squad up, loot up, survive the circle.', action);
  html += '<div class="grid g3" style="margin-bottom:16px">' +
    '<div class="stat" style="--acc:var(--wz)"><span>LOBBY</span><b>' + (st.lobby || 0) + ' / ' + (st.needed || 0) + '</b><small>players waiting</small></div>' +
    '<div class="stat" style="--acc:var(--wz)"><span>IN MATCH</span><b>' + (st.matchPlayers || 0) + '</b><small>currently dropped in</small></div>' +
    '<div class="stat" style="--acc:var(--wz)"><span>STATUS</span><b>' + (st.state || 'idle').toUpperCase() + '</b><small>match state</small></div></div>';

  if (stats) {
    if (stats.invite) {
      html += '<div class="notice">' + esc(stats.invite) + ' invited you to their squad.</div><div class="form"><button class="btn primary" data-act="accept">ACCEPT INVITE</button></div>';
    }
    if (page.squad && page.squad.length) {
      html += '<div class="card" style="margin-bottom:16px"><h3>YOUR SQUAD</h3><div class="chips">' + page.squad.map((n) => '<span class="chip on">' + esc(n) + '</span>').join('') + '</div></div>';
    } else if (st.inLobby) {
      html += '<div class="card" style="margin-bottom:16px"><h3>INVITE TO SQUAD</h3><div class="form"><input id="wzInviteId" type="text" placeholder="Player server ID"><button class="btn primary" id="wzInviteBtn">INVITE</button></div></div>';
    }
    html += '<div class="card"><h3>TOP SQUADS &amp; PLAYERS</h3>' + (function () {
      if (!stats.top || !stats.top.length) return '<div class="empty">No matches played yet</div>';
      return '<table class="table"><thead><tr><th></th><th>Player</th><th class="r">Wins</th><th class="r">Kills</th><th class="r">Deaths</th></tr></thead><tbody>' +
        stats.top.map((r, i) => '<tr class="' + (r.you ? 'tr-you' : '') + '"><td style="width:34px"><span class="tr-rk">' + (i + 1) + '</span></td><td>' + esc(r.name) + '</td><td class="r">' + esc(r.wins) + '</td><td class="r">' + esc(r.kills) + '</td><td class="r">' + esc(r.deaths) + '</td></tr>').join('') + '</tbody></table>';
    })() + '</div>';
  }
  c.innerHTML = html;
  bindActs(c, 'warzone');
  const inviteBtn = $('#wzInviteBtn');
  if (inviteBtn) inviteBtn.addEventListener('click', () => {
    const id = $('#wzInviteId').value.trim();
    if (id) hubAction('warzone', 'invite', { target: id });
  });
  const acceptBtn = c.querySelector('[data-act="accept"]');
  if (acceptBtn) acceptBtn.addEventListener('click', () => hubAction('warzone', 'accept'));
}

function renderEventPage(id, page) {
  if (id === 'capture') return renderCapture(page);
  if (id === 'gungame') return renderGunGame(page);
  if (id === 'warzone') return renderWarZone(page);
}

/* ---------- ADMIN page ---------- */
function renderAdmin() {
  const c = $('#content'); const me = HUB.me;
  let html = pageHead('var(--violet)', '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3 4 6v6c0 5 3.6 8 8 9 4.4-1 8-4 8-9V6z"/><path d="M9 12l2 2 4-4"/></svg>', 'ADMIN TOOLS', 'Moderation controls for the events you manage.');
  html += '<div class="grid g3">';
  if (me.admin.capture) {
    html += '<div class="card"><h3>CAPTURE</h3><div class="form"><input id="capMinutes" type="text" placeholder="Minutes (default 60)"></div>' +
      '<div class="tag-row"><button class="btn primary sm" data-a="capture:start">START ROUND</button><button class="btn danger sm" data-a="capture:end">END ROUND</button><button class="btn ghost sm" data-a="capture:resetzones">RESET ZONES</button></div></div>';
  }
  if (me.admin.gungame) {
    html += '<div class="card"><h3>GUNGAME</h3><p style="color:var(--muted);font:600 13px var(--font);margin-bottom:8px">Arenas start automatically once enough players queue.</p></div>';
  }
  if (me.admin.warzone) {
    html += '<div class="card"><h3>WARZONE</h3><div class="tag-row"><button class="btn primary sm" data-a="warzone:start">FORCE START MATCH</button><button class="btn danger sm" data-a="warzone:end">END MATCH</button></div></div>';
  }
  html += '</div>';
  c.innerHTML = html;
  $$('[data-a]', c).forEach((btn) => {
    btn.addEventListener('click', () => {
      const [ev, act] = btn.dataset.a.split(':');
      const payload = {};
      if (act === 'start' && ev === 'capture') payload.minutes = Number($('#capMinutes').value) || undefined;
      hubAction(ev, act, payload);
    });
  });
}

function bindActs(root, ev) {
  const j = root.querySelector('[data-act="join"]'); if (j) j.addEventListener('click', () => hubAction(ev, 'join'));
  const l = root.querySelector('[data-act="leave"]'); if (l) l.addEventListener('click', () => hubAction(ev, 'leave'));
}
function hubAction(ev, act, payload) {
  blip(640, 0.08);
  post('hub:action', { event: ev, action: act, payload: payload || {} });
  setTimeout(() => post('hub:refresh', {}), 350);
}

/* ---------- background canvas fx ---------- */
let fxRAF = null;
function startFX() {
  const cv = $('#fx'); if (!cv) return;
  const ctx = cv.getContext('2d');
  function size() { cv.width = cv.clientWidth; cv.height = cv.clientHeight; }
  size();
  const particles = Array.from({ length: 40 }, () => ({ x: Math.random() * cv.width, y: Math.random() * cv.height, r: Math.random() * 1.6 + 0.4, s: Math.random() * 0.25 + 0.05 }));
  function tick() {
    if (!HUB.open) return;
    ctx.clearRect(0, 0, cv.width, cv.height);
    ctx.fillStyle = 'rgba(255,45,85,.35)';
    particles.forEach((p) => {
      p.y -= p.s; if (p.y < 0) { p.y = cv.height; p.x = Math.random() * cv.width; }
      ctx.beginPath(); ctx.arc(p.x, p.y, p.r, 0, 7); ctx.fill();
    });
    fxRAF = requestAnimationFrame(tick);
  }
  window.addEventListener('resize', size);
  tick();
}
function stopFX() { if (fxRAF) cancelAnimationFrame(fxRAF); fxRAF = null; }

/* ==========================================================
   MESSAGE ROUTER
   ========================================================== */
const ROUTES = {
  toast, banner, center: centerText, progress, progressStop, sound: (d) => playFile(d.file, d.volume),
  menu: menuOpen, menuClose, dialog: dialogOpen,
  capShow: CAP.show, capData: CAP.data, capBoards: CAP.boards, capZones: CAP.zones, capProgress: CAP.progress, capProgressHide: CAP.progressHide, capKill: CAP.kill,
  ggShow: GG.show, ggCountdown: GG.countdown, ggCountdownHide: GG.countdownHide, ggTimer: GG.timer, ggTimerHide: GG.timerHide, ggLevel: GG.level, ggBoard: GG.board, ggBoardToggle: GG.boardToggle, ggKill: GG.kill, ggMvp: GG.mvp, ggMvpHide: GG.mvpHide,
  wzShow: WZ.show, wzCounts: WZ.counts, wzStats: WZ.stats, wzSquad: WZ.squad, wzKill: WZ.kill, wzDowned: WZ.downed, wzLobby: WZ.lobby, wzZone: WZ.zone, wzSpec: WZ.spec, wzWinner: WZ.winner, wzWinnerHide: WZ.winnerHide,
  hubOpen: hubOpenUI, hubClose: hubCloseUI, hubData: hubSetData, hubPage: hubPageData,
  closeAll: () => { show($('#menu'), false); show($('#dialog'), false); hubCloseUI(); },
};

window.addEventListener('message', (event) => {
  const msg = event.data || {};
  const fn = ROUTES[msg.action];
  if (fn) fn(msg.data || {});
});

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    if (!$('#dialog').classList.contains('hidden')) return dialogCancel();
    if (!$('#menu').classList.contains('hidden')) { menuClose(); post('menu:closed', {}); return; }
    if (HUB.open) return hubCloseUI();
  }
});
