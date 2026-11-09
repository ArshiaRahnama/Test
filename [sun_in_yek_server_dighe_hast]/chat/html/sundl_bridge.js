/* =========================================================
 * Sun Dispatch — bridge dar chat resource
 *
 * Vazife (faghat hamin):
 *   1) Inject Play/Stop button + position display + 3-dot button dar rp-header
 *   2) Render popover sang-tari shamel se tab: Queue / Lost / Unaccepted
 *   3) Handle offer popup (vasat-e safhe, az index.html mishanase)
 *   4) Decorate history items ba badge `pickedFrom` (queue / lost / unaccepted)
 *
 * Hich tamasi ba App.js nadareh.
 * ========================================================= */
(function () {
  'use strict';

  // ---------- helpers ----------
  function $(s, root) { return (root || document).querySelector(s); }
  function post(name, payload) {
    fetch('https://chat/' + name, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(payload || {})
    }).catch(function(){});
  }
  function esc(s) {
    if (s == null) return '';
    var d = document.createElement('div');
    d.textContent = String(s);
    return d.innerHTML;
  }
  function timeAgo(ts) {
    if (!ts) return '';
    var d = Math.max(0, Math.floor(Date.now() / 1000) - ts);
    if (d < 60) return d + 's';
    if (d < 3600) return Math.floor(d / 60) + 'm';
    if (d < 86400) return Math.floor(d / 3600) + 'h';
    return Math.floor(d / 86400) + 'd';
  }
  function fmtDuration(sec) {
    var s = Math.max(0, parseInt(sec, 10) || 0);
    if (s < 60) return s + 's';
    if (s < 3600) return Math.floor(s / 60) + 'm';
    if (s < 86400) return Math.floor(s / 3600) + 'h';
    return Math.floor(s / 86400) + 'd';
  }

  var SUND_CAT_COLORS = {
    'REPORT_COMBAT_LOGOUT': '#ef5350',
    'REPORT_KOS': '#e53935',
    'REPORT_NCZ_SAFEZONE': '#ff9800',
    'REPORT_POWER_GAMING': '#ff7043',
    'REPORT_VDM': '#f44336',
    'REPORT_FEAR_RP': '#ab47bc',
    'REPORT_SEARCH': '#42a5f5',
    'REPORT_META_GAMING': '#7e57c2',
    'REPORT_MIX_IC_OOC': '#5c6bc0',
    'REPORT_FAHASHI': '#ec407a',
    'REPORT_BUG_GLITCH': '#66bb6a',
    'HELP': '#26c6da',
    'REPORT_MORE': '#78909c',
    'REPORT_NEW_PLAYER': '#9ccc65'
  };

  function loadSelectedCats() {
    try {
      var raw = localStorage.getItem('sund_join_cats');
      if (!raw) return [];
      var arr = JSON.parse(raw);
      return Array.isArray(arr) ? arr : [];
    } catch (e) { return []; }
  }
  function saveSelectedCats(arr) {
    try { localStorage.setItem('sund_join_cats', JSON.stringify(arr || [])); } catch (e) {}
  }

  // ---------- state ----------
  var State = {
    inQueue: false,
    membership: [],
    manager: false,
    queueCount: 0,
    openQueueCat: null,
    moreOpen: false,
    activeTab: 'queue',           // queue | lost | unaccepted
    categories: [],
    selectedCats: loadSelectedCats(),
    queues: {},
    lost: [],
    unaccepted: [],
    unacceptedManager: false,
    pickedHistory: {},            // reportId -> 'queue' | 'lost'
    refreshTimer: null,
  };

  // ============================================================
  // DOM injection: rp-header bar (Play + position + more)
  // ============================================================
  function injectControls() {
    var panel = document.getElementById('reportPanel');
    if (!panel || panel.querySelector('#sund-controls')) return;
    var list = panel.querySelector('.rp-list');
    if (!list) return;

    var bar = document.createElement('div');
    bar.id = 'sund-controls';
    bar.innerHTML =
      '<button id="sund-play" class="sund-btn sund-play" data-tooltip="/eq Vared saf sho">' +
        '<svg viewBox="0 0 24 24" width="13" height="13"><path fill="currentColor" d="M8 5v14l11-7z"/></svg>' +
      '</button>' +
      '<button id="sund-stop" class="sund-btn sund-stop" style="display:none" data-tooltip="/eq Khorooj az saf">' +
        '<svg viewBox="0 0 24 24" width="13" height="13"><path fill="currentColor" d="M6 6h12v12H6z"/></svg>' +
      '</button>' +
      '<div id="sund-badge" class="sund-badge" style="display:none">' +
        '<span class="sund-badge-ico"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"/></svg></span>' +
        '<span class="sund-badge-count"></span>' +
      '</div>';
    panel.insertBefore(bar, list);

    var rpTabs = panel.querySelector('.rp-tabs');
    if (rpTabs && !rpTabs.querySelector('[data-tab="sund-queue"]')) {
      rpTabs.insertAdjacentHTML('beforeend',
        '<div class="rp-tab sund-extra-tab" data-tab="sund-queue" style="display:none">Saf</div>'
      );
    }

    updateManagerUI();
    renderControls();
    post('sundFetch', { kind: 'categories' });
  }

  // ============================================================
  // Universal in-queue indicator (rast-vasat-e safhe)
  // ============================================================
  function ensureQueueIndicator() {
    var el = document.getElementById('sund-queue-indicator');
    if (el) return el;
    el = document.createElement('div');
    el.id = 'sund-queue-indicator';
    el.innerHTML =
      '<span class="sund-qi-dot"></span>' +
      '<span class="sund-qi-pos">صف</span>';
    document.body.appendChild(el);
    return el;
  }
  function renderQueueIndicator() {
    var el = ensureQueueIndicator();
    if (State.inQueue) {
      var posEl = el.querySelector('.sund-qi-pos');
      if (posEl) posEl.textContent = 'صف: ' + State.queueCount;
      el.classList.add('show');
    } else {
      el.classList.remove('show');
    }
  }

  function waitForPanel() {
    if (document.getElementById('reportPanel')) {
      injectControls();
    } else {
      setTimeout(waitForPanel, 200);
    }
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', waitForPanel);
  } else {
    waitForPanel();
  }

  // ============================================================
  // Play/Stop visibility + membership badge
  // ============================================================
  function renderControls() {
    renderQueueIndicator();
    renderBadge();
    var play = document.getElementById('sund-play');
    var stop = document.getElementById('sund-stop');
    if (!play || !stop) return;
    if (State.inQueue) {
      play.style.display = 'none';
      stop.style.display = '';
    } else {
      play.style.display = '';
      stop.style.display = 'none';
    }
  }

  function catLabelToKey(label) {
    for (var i = 0; i < State.categories.length; i++) {
      if (State.categories[i].label === label) return State.categories[i].key;
    }
    return null;
  }
  function catColor(label) {
    var key = catLabelToKey(label);
    return (key && SUND_CAT_COLORS[key]) || '#65aeff';
  }

  function buildBadgeTip() {
    var activeSet = {};
    for (var i = 0; i < State.membership.length; i++) activeSet[State.membership[i]] = 1;
    var labels = [];
    var seen = {};
    for (var a = 0; a < State.selectedCats.length; a++) {
      var sl = State.selectedCats[a];
      if (!seen[sl]) { seen[sl] = 1; labels.push(sl); }
    }
    for (var b = 0; b < State.membership.length; b++) {
      var ml = State.membership[b];
      if (!seen[ml]) { seen[ml] = 1; labels.push(ml); }
    }
    if (!labels.length) return '<div class="sund-bt-empty">صفی انتخاب نشده</div>';
    var html = '<div class="sund-bt-title">صف‌های من</div>';
    for (var j = 0; j < labels.length; j++) {
      var label = labels[j];
      var on = !!activeSet[label];
      html += '<div class="sund-bt-row' + (on ? ' on' : '') + '">' +
        '<span class="sund-bt-dot" style="background:' + catColor(label) + '"></span>' +
        '<span class="sund-bt-label">' + esc(label) + '</span>' +
        '<span class="sund-bt-state">' + (on ? 'در صف' : '') + '</span>' +
      '</div>';
    }
    return html;
  }

  function renderBadge() {
    var badge = document.getElementById('sund-badge');
    if (!badge) return;
    var active = State.membership.length;
    var ticked = State.selectedCats.length;
    if (active === 0 && ticked === 0) {
      badge.style.display = 'none';
      hideBadgePop();
      return;
    }
    badge.style.display = '';
    badge.classList.toggle('active', active > 0);
    var cnt = badge.querySelector('.sund-badge-count');
    if (cnt) cnt.textContent = State.queueCount > 0 ? String(State.queueCount) : '';
    var pop = document.getElementById('sund-badge-pop');
    if (pop && pop.style.display === 'block') pop.innerHTML = buildBadgeTip();
  }

  function ensureBadgePop() {
    var el = document.getElementById('sund-badge-pop');
    if (el) return el;
    el = document.createElement('div');
    el.id = 'sund-badge-pop';
    document.body.appendChild(el);
    return el;
  }

  function showBadgePop(badge) {
    var pop = ensureBadgePop();
    pop.innerHTML = buildBadgeTip();
    var app = document.getElementById('app');
    if (app) {
      var tr = getComputedStyle(app).getPropertyValue('--theme-rgb').trim();
      if (tr) pop.style.setProperty('--theme-rgb', tr);
    }
    var panel = document.getElementById('reportPanel');
    var scale = 1;
    if (panel) {
      if (panel.classList.contains('rp-size-4')) scale = 1.5;
      else if (panel.classList.contains('rp-size-3')) scale = 1.3;
      else if (panel.classList.contains('rp-size-2')) scale = 1.15;
    }
    pop.style.transformOrigin = 'top center';
    pop.style.transform = 'scale(' + scale + ')';
    pop.style.display = 'block';
    var rect = badge.getBoundingClientRect();
    var pr = pop.getBoundingClientRect();
    var left = rect.left + rect.width / 2 - pr.width / 2;
    var top = rect.bottom + 8;
    if (top + pr.height > window.innerHeight - 4) top = rect.top - pr.height - 8;
    if (top < 4) top = 4;
    if (left < 4) left = 4;
    if (left + pr.width > window.innerWidth - 4) left = window.innerWidth - pr.width - 4;
    pop.style.left = left + 'px';
    pop.style.top = top + 'px';
  }

  function hideBadgePop() {
    var pop = document.getElementById('sund-badge-pop');
    if (pop) pop.style.display = 'none';
  }

  document.addEventListener('mouseenter', function (e) {
    if (!e.target || !e.target.closest) return;
    var b = e.target.closest('#sund-badge');
    if (b) showBadgePop(b);
  }, true);
  document.addEventListener('mouseleave', function (e) {
    if (!e.target || !e.target.closest) return;
    if (e.target.closest('#sund-badge')) hideBadgePop();
  }, true);

  function updateManagerUI() {
    var tab = document.querySelector('#reportPanel [data-tab="sund-queue"]');
    if (tab) tab.style.display = State.manager ? '' : 'none';
    if (!State.manager && window.__sundActiveTab === 'queue') {
      clearSundTab();
      var list = document.querySelector('#reportPanel .rp-list');
      if (list) list.innerHTML = '';
      try { window.dispatchEvent(new Event('sund:rerender-rp')); } catch (_e) {}
    }
  }

  // ============================================================
  // Join queue category panel
  // ============================================================
  function renderJoinPanel() {
    var panel = document.getElementById('sund-join-panel');
    if (!panel) return;
    var grid = panel.querySelector('.sjp-grid');
    var empty = panel.querySelector('.sjp-empty');
    if (!grid) return;
    grid.innerHTML = '';
    if (!State.categories.length) {
      if (empty) empty.style.display = '';
      return;
    }
    if (empty) empty.style.display = 'none';
    var sel = {};
    for (var s = 0; s < State.selectedCats.length; s++) sel[State.selectedCats[s]] = 1;
    for (var i = 0; i < State.categories.length; i++) {
      var c = State.categories[i];
      var on = !!sel[c.label];
      var color = SUND_CAT_COLORS[c.key] || '#65aeff';
      var item = document.createElement('div');
      item.className = 'sjp-item' + (on ? ' on' : '');
      item.setAttribute('data-label', c.label);
      item.innerHTML =
        '<span class="sjp-check"></span>' +
        '<span class="sjp-dot" style="background:' + color + '"></span>' +
        '<span class="sjp-label">' + esc(c.label) + '</span>';
      grid.appendChild(item);
    }
  }

  function openJoinPanel() {
    var panel = document.getElementById('sund-join-panel');
    if (!panel) return;
    State.selectedCats = loadSelectedCats();
    if (!State.categories.length) post('sundFetch', { kind: 'categories' });
    renderJoinPanel();
    panel.style.display = '';
  }

  function closeJoinPanel(notify) {
    var panel = document.getElementById('sund-join-panel');
    if (panel) panel.style.display = 'none';
    State.selectedCats = loadSelectedCats();
    renderBadge();
    if (notify) post('sundSmallMenu', { action: 'closeJoin' });
  }

  function toggleCat(label, item) {
    if (!label) return;
    var idx = State.selectedCats.indexOf(label);
    if (idx >= 0) { State.selectedCats.splice(idx, 1); if (item) item.classList.remove('on'); }
    else { State.selectedCats.push(label); if (item) item.classList.add('on'); }
  }

  function confirmJoin() {
    var labels = State.selectedCats.slice();
    var panel = document.getElementById('sund-join-panel');
    if (!labels.length) {
      if (panel) {
        var c = panel.querySelector('.sjp-container');
        if (c) { c.classList.remove('shake'); void c.offsetWidth; c.classList.add('shake'); }
      }
      return;
    }
    saveSelectedCats(labels);
    if (panel) panel.style.display = 'none';
    post('sundSmallMenu', { action: 'joinConfirm', cats: labels });
  }

  // ============================================================
  // Sund tab rendering (داخل همون .rp-list)
  // ============================================================

  function isSundTabActive() {
    return !!window.__sundActiveTab;
  }

  function fetchActive() {
    var t = window.__sundActiveTab;
    if (!t) return;
    post('sundFetch', { kind: t });
  }

  function setActiveSundTab(name) {
    window.__sundActiveTab = name;
    State.activeTab = name;
    var allTabs = document.querySelectorAll('#reportPanel .rp-tab');
    for (var i = 0; i < allTabs.length; i++) allTabs[i].classList.remove('active');
    var clicked = document.querySelector('#reportPanel [data-tab="sund-' + name + '"]');
    if (clicked) clicked.classList.add('active');
    var sortMenu = document.querySelector('.rp-sort-menu');
    if (sortMenu) sortMenu.classList.remove('visible');

    fetchActive();
    renderInList();

    if (State.refreshTimer) clearInterval(State.refreshTimer);
    State.refreshTimer = setInterval(fetchActive, 10000);
  }

  function clearSundTab() {
    window.__sundActiveTab = null;
    if (State.refreshTimer) { clearInterval(State.refreshTimer); State.refreshTimer = null; }
  }

  function renderInList() {
    var list = document.querySelector('#reportPanel .rp-list');
    if (!list) return;
    if (!isSundTabActive()) return;
    list.innerHTML = '';
    var box = document.createElement('div');
    box.className = 'sund-pop-list-inline';
    list.appendChild(box);

    var t = window.__sundActiveTab;
    if (t === 'queue') {
      var cats = Object.keys(State.queues || {});
      cats.sort();
      if (!cats.length) {
        State.openQueueCat = null;
        box.innerHTML = '<div class="sund-empty">Hich admin-i toye saf nist</div>';
        return;
      }
      if (State.openQueueCat && cats.indexOf(State.openQueueCat) === -1) State.openQueueCat = null;
      for (var ci = 0; ci < cats.length; ci++) {
        var cat = cats[ci];
        var qd = State.queues[cat] || { list: [], size: 0 };
        var isOpen = (State.openQueueCat === cat);
        var blk = document.createElement('div');
        blk.className = 'sund-qcat' + (isOpen ? ' open' : '');
        blk.setAttribute('data-cat', cat);
        var head = document.createElement('div');
        head.className = 'sund-qcat-head';
        head.innerHTML =
          '<span class="sund-dot" style="background:' + catColor(cat) + '"></span>' +
          '<span class="sund-qcat-name">' + esc(cat) + '</span>' +
          '<span class="sund-qcat-size">' + esc(qd.size) + '</span>' +
          '<span class="sund-qcat-arrow"><svg viewBox="0 0 24 24" width="12" height="12"><path fill="currentColor" d="M7 10l5 5 5-5z"/></svg></span>';
        blk.appendChild(head);
        var body = document.createElement('div');
        body.className = 'sund-qcat-body';
        var ql = qd.list || [];
        for (var qi = 0; qi < ql.length; qi++) {
          var q = ql[qi];
          var div = document.createElement('div');
          div.className = 'sund-row sund-q-row';
          div.innerHTML =
            '<span class="sund-pos">#' + esc(q.position) + '</span>' +
            '<span class="sund-name">' + esc(q.name) + '</span>' +
            '<span class="sund-meta">' + esc(fmtDuration(q.waited)) + '</span>';
          body.appendChild(div);
        }
        blk.appendChild(body);
        box.appendChild(blk);
      }
      return;
    }
    if (t === 'lost') {
      if (!State.lost.length) {
        box.innerHTML = '<div class="sund-empty">Hich gomshode-i nist</div>';
        return;
      }
      for (var j = 0; j < State.lost.length; j++) {
        var l = State.lost[j];
        var ownerStr = l.owner ? (esc(l.owner.name) + ' (#' + esc(l.owner.id) + ')') : '—';
        var d2 = document.createElement('div');
        d2.className = 'sund-row sund-lost-row';
        d2.setAttribute('data-id', esc(l.id));
        d2.innerHTML =
          '<span class="sund-cat">' + esc(l.cat || 'Report') + '</span>' +
          '<span class="sund-owner">' + ownerStr + '</span>' +
          '<span class="sund-meta" data-tooltip="Reason: ' + esc(l.reason || '') + '">' + esc(timeAgo(l.at)) + '</span>';
        box.appendChild(d2);
      }
      return;
    }
    if (t === 'unaccepted') {
      if (!State.unaccepted.length) {
        box.innerHTML = '<div class="sund-empty">Hich ticket accept-nashode-i nist</div>';
        return;
      }
      for (var k = 0; k < State.unaccepted.length; k++) {
        var u = State.unaccepted[k];
        var ownerCol = '';
        if (State.unacceptedManager && u.owner) {
          ownerCol = '<span class="sund-owner">' + esc(u.owner.name) + ' (#' + esc(u.owner.id) + ')</span>';
        }
        var who = u.offeredName ? ('→ ' + esc(u.offeredName)) : '— hichkas';
        var d3 = document.createElement('div');
        d3.className = 'sund-row sund-un-row';
        d3.innerHTML =
          '<span class="sund-cat">' + esc(u.cat || 'Report') + '</span>' +
          ownerCol +
          '<span class="sund-who">' + who + '</span>' +
          '<span class="sund-meta">' + esc(timeAgo(u.at)) + '</span>';
        box.appendChild(d3);
      }
      return;
    }
  }

  function renderPopList() { renderInList(); }

  // ============================================================
  // History items decorator (badge pickedFrom)
  //   Q = az safe Queue ghabool shode (popup offer)
  //   L = az section Active/Lost ghabool shode (lost ya unaccepted)
  // ============================================================
  var BADGE_LABELS = { 'queue': 'Q', 'lost': 'L', 'unaccepted': 'L' };
  var BADGE_TIPS   = {
    'queue':      'Az saf (Queue) bardashte shod',
    'lost':       'Az Active/Lost bardashte shod',
    'unaccepted': 'Az Active/Lost bardashte shod'
  };

  function redecorateHistoryNow() {
    var stale = document.querySelectorAll('#reportPanel .rp-history-item .sund-source-badge');
    for (var si = 0; si < stale.length; si++) {
      if (stale[si].parentNode) stale[si].parentNode.removeChild(stale[si]);
    }
    decorateHistory();
  }

  function decorateHistory() {
    var items = document.querySelectorAll('#reportPanel .rp-history-item');
    for (var i = 0; i < items.length; i++) {
      var it = items[i];
      if (it.querySelector('.sund-source-badge')) continue;
      var actEl = it.querySelector('.rp-history-action');
      if (!actEl || actEl.getAttribute('data-tooltip') !== 'Accept') continue;
      var pidEl = it.querySelector('.rp-player-id');
      if (!pidEl) continue;
      var rid = it.getAttribute('data-report-id') || '';
      var rtime = it.getAttribute('data-report-time') || '0';
      if (!rid) {
        var m = pidEl.textContent.match(/(\d+)/);
        if (!m) continue;
        rid = m[1];
      }
      // کلید composite ⇒ "id:time" تا ریپورت‌های مختلف از همون پلیر قاطی نشن
      var compoundKey = rid + ':' + rtime;
      var src = State.pickedHistory[compoundKey];
      var key = src === 'queue' ? 'queue' : 'lost';
      var badge = document.createElement('span');
      badge.className = 'sund-source-badge sund-source-' + key;
      badge.textContent = BADGE_LABELS[key];
      badge.setAttribute('data-tooltip', BADGE_TIPS[key]);
      if (pidEl.nextSibling) {
        pidEl.parentNode.insertBefore(badge, pidEl.nextSibling);
      } else {
        pidEl.parentNode.appendChild(badge);
      }
    }
  }

  // har bar list re-render shod, decorate kon
  var listObserver;
  function startListObserver() {
    if (listObserver) return;
    var list = document.querySelector('#reportPanel .rp-list');
    if (!list) { setTimeout(startListObserver, 300); return; }
    listObserver = new MutationObserver(function() {
      decorateHistory();
    });
    listObserver.observe(list, { childList: true, subtree: false });
  }
  startListObserver();

  // ============================================================
  // Click delegation
  // ============================================================
  document.addEventListener('click', function (e) {
    var defaultTab = e.target.closest('.rp-tab');
    if (defaultTab && !defaultTab.classList.contains('sund-extra-tab')) {
      clearSundTab();
      var listNow = document.querySelector('#reportPanel .rp-list');
      if (listNow) listNow.innerHTML = '';
      try { window.dispatchEvent(new Event('sund:rerender-rp')); } catch(_e){}
    }
  }, true);

  document.addEventListener('click', function (e) {
    var jp = document.getElementById('sund-join-panel');
    if (jp && jp.style.display !== 'none') {
      if (e.target.closest('.sjp-overlay') || e.target.closest('.sjp-close-btn')) { closeJoinPanel(true); return; }
      var sjpItem = e.target.closest('.sjp-item');
      if (sjpItem) { toggleCat(sjpItem.getAttribute('data-label'), sjpItem); return; }
      if (e.target.closest('.sjp-join-btn')) { confirmJoin(); return; }
    }

    if (e.target.closest('#sund-play'))  { post('sundSmallMenu', { action: 'openJoin' }); return; }
    if (e.target.closest('#sund-stop'))  { post('sundSmallMenu', { action: 'leave' }); return; }

    var sundTab = e.target.closest('.sund-extra-tab');
    if (sundTab) {
      e.stopPropagation();
      var key = (sundTab.getAttribute('data-tab') || '').replace('sund-', '');
      if (key) setActiveSundTab(key);
      return;
    }

    var qhead = e.target.closest('.sund-qcat-head');
    if (qhead) {
      var qblk = qhead.closest('.sund-qcat');
      var qcat = qblk ? qblk.getAttribute('data-cat') : null;
      if (qcat) {
        State.openQueueCat = (State.openQueueCat === qcat) ? null : qcat;
        renderInList();
      }
      return;
    }

    var lostRow = e.target.closest('.sund-lost-row');
    if (lostRow) {
      var id = lostRow.getAttribute('data-id');
      if (id) post('sundSmallMenu', { action: 'lostPick', id: id });
      return;
    }
    if (e.target.closest('#sund-offer-accept'))         { offerSend('accept');         return; }
    if (e.target.closest('#sund-offer-accept-spect'))   { offerSend('acceptSpectate'); return; }
  });

  post('sundFetch', { kind: 'pickedHistory' });

  // ============================================================
  // NUI message receiver
  // ============================================================
  window.addEventListener('message', function (e) {
    var d = e.data || {};

    if (d.type === 'SUND_MEMBERSHIP') {
      State.membership = d.cats || [];
      State.manager    = !!d.manager;
      State.inQueue    = State.membership.length > 0;
      if (typeof d.count === 'number') State.queueCount = d.count;
      updateManagerUI();
      renderControls();
      return;
    }

    if (d.type === 'SUND_QUEUE_COUNT') {
      State.queueCount = d.count || 0;
      renderControls();
      return;
    }

    if (d.type === 'SUND_SET_CATEGORIES') {
      State.categories = d.categories || [];
      var jpe = document.getElementById('sund-join-panel');
      if (jpe && jpe.style.display !== 'none') renderJoinPanel();
      renderBadge();
      return;
    }

    if (d.type === 'SUND_OPEN_JOIN_PANEL') { openJoinPanel(); return; }

    if (d.type === 'SUND_DATA') {
      if (d.kind === 'queue' && d.data) {
        State.manager = !!d.data.manager;
        State.queues  = d.data.queues || {};
        updateManagerUI();
        if (window.__sundActiveTab === 'queue') renderInList();
      } else if (d.kind === 'lost' && d.data) {
        State.lost = d.data.list || [];
        if (window.__sundActiveTab === 'lost') renderInList();
      } else if (d.kind === 'unaccepted' && d.data) {
        State.unaccepted = d.data.list || [];
        State.unacceptedManager = !!d.data.manager;
        if (window.__sundActiveTab === 'unaccepted') renderInList();
      } else if (d.kind === 'pickedHistory' && d.data) {
        State.pickedHistory = d.data || {};
        redecorateHistoryNow();
      }
      return;
    }

    if (d.type === 'SUND_PICKED_UPSERT') {
      if (d.key) State.pickedHistory[d.key] = d.bucket;
      redecorateHistoryNow();
      return;
    }
    if (d.type === 'SUND_PICKED_REMOVE') {
      if (d.key) delete State.pickedHistory[d.key];
      return;
    }

    if (d.type === 'SUND_OFFER_SHOW') { offerShow(d); return; }
    if (d.type === 'SUND_OFFER_HIDE') { offerHide(); return; }

    if (d.type === 'OFFER_COMMAND') {
      if (!offerState.id) return;
      if (d.action === 'accept' || d.action === 'acceptSpectate') {
        offerSend(d.action);
      }
      return;
    }

    if (d.type === 'SUND_HIDDEN_SET') {
      window.__sundHiddenIds = {};
      var arr = d.ids || [];
      for (var i = 0; i < arr.length; i++) window.__sundHiddenIds[String(arr[i])] = 1;
      window.__sundMineIds = {};
      var mine = d.mine || [];
      for (var j = 0; j < mine.length; j++) window.__sundMineIds[String(mine[j])] = 1;
      try { window.dispatchEvent(new Event('sund:rerender-rp')); } catch(_e){}
      return;
    }
  });

  // ============================================================
  // Offer popup (vasat-e safhe)
  // ============================================================
  var offerState = { id: null, total: 0, remaining: 0, timer: null };

  function offerEl(id) { return document.getElementById(id); }

  function offerShow(d) {
    offerHide();
    var box = offerEl('sund-offer');
    if (!box) return;
    offerState.id        = d.id;
    offerState.total     = parseInt(d.window, 10) || 30;
    offerState.remaining = offerState.total;

    offerEl('sund-offer-id').textContent    = '#' + (d.id || '—');
    offerEl('sund-offer-owner').textContent = d.owner || '—';
    var oidEl = offerEl('sund-offer-ownerId');
    if (oidEl) oidEl.textContent = (d.ownerId !== undefined && d.ownerId !== null) ? String(d.ownerId) : '—';
    offerEl('sund-offer-cat').textContent   = d.cat   || '—';
    offerEl('sund-offer-msg').textContent   = d.msg   || '—';

    var bar = offerEl('sund-offer-bar');
    if (bar) {
      bar.style.transition = 'none';
      bar.style.width = '100%';
      void bar.offsetWidth;
      bar.style.transition = 'width 1s linear';
    }

    box.classList.add('show');
    tickOfferCountdown();
    offerState.timer = setInterval(tickOfferCountdown, 1000);
  }

  function tickOfferCountdown() {
    offerState.remaining -= 1;
    var pct = Math.max(0, offerState.remaining / offerState.total) * 100;
    var bar = offerEl('sund-offer-bar');
    var cnt = offerEl('sund-offer-countdown');
    if (bar) bar.style.width = pct + '%';
    if (cnt) cnt.textContent = (offerState.remaining > 0)
        ? ('برای اکسپت کردن ' + offerState.remaining + ' ثانیه فرصت دارید')
        : 'زمان تمام شد';
    if (offerState.remaining <= 0) offerHide();
  }

  function offerHide() {
    var box = offerEl('sund-offer');
    if (box) box.classList.remove('show');
    if (offerState.timer) { clearInterval(offerState.timer); offerState.timer = null; }
    offerState.id = null;
  }

  function offerSend(action) {
    if (!offerState.id) return;
    post('sundOffer', { action: action, id: offerState.id });
    offerHide();
  }

  // hotkey-haye E/R/Q hazf shodand. ja-ye anha admin az command-ha estefade mikone:
  //   /arq → accept, /ars → accept+spectate
  // command-ha ghabel-e bind hastan (admin too settings/keybinds key delkhah set kone).
})();
