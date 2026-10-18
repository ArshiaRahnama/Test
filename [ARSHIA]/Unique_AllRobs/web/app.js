// Gang Robbery menu (NUI). Pure vanilla JS, no external libraries.
// Talks to heist_client.lua through NUI callbacks; all rules live on the server.
(function () {
  'use strict';

  var RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'Unique_AllRobs';
  var $ = function (id) { return document.getElementById(id); };

  var state = { data: null, loadedAt: 0, tab: 'robberies', preview: false };
  var refreshTimer = null, tickTimer = null;

  // ---------- helpers ----------
  var FA = '۰۱۲۳۴۵۶۷۸۹';
  function fa(n) { return String(n).replace(/\d/g, function (d) { return FA[d]; }); }
  function clock(sec) {
    sec = Math.max(0, Math.ceil(sec - 0.0001));   // round UP: a countdown must not show 6:19 the instant it starts at 6:20
    var m = Math.floor(sec / 60), s = sec % 60;
    return fa(m + ':' + (s < 10 ? '0' + s : s));
  }
  function elapsed() { return (Date.now() - state.loadedAt) / 1000; }
  function money(n) { return '$' + fa(Number(n).toLocaleString('en-US')); }

  function el(tag, cls, text) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (text !== undefined && text !== null) e.textContent = text;   // textContent only: gang names can't inject HTML
    return e;
  }

  function post(name, body) {
    return fetch('https://' + RES + '/' + name, {
      method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(body || {})
    }).catch(function () {});
  }

  function toast(text, ok) {
    if (!text) return;
    var t = $('toast');
    t.textContent = text;
    t.className = 'show ' + (ok ? 'ok' : 'err');
    clearTimeout(toast._h);
    toast._h = setTimeout(function () { t.className = ''; }, 3200);
  }

  // ---------- render ----------
  var STATUS = {
    free: 'آزاد', mine: 'رزرو شده برای شما', claimed: 'رزرو شده', inprogress: 'در حال انجام',
    cooldown: 'کول‌داون', locked: 'قفل موقت'
  };

  function planChips(d) {
    var box = $('planChips');
    box.textContent = '';
    ['bronze', 'silver', 'premium'].forEach(function (t) {
      var c = el('div', 'chip ' + t);
      c.appendChild(el('div', 'n', fa((d.plans && d.plans[t]) || 0)));
      c.appendChild(el('div', 'l', 'پلن ' + ((d.planLabels && d.planLabels[t]) || t)));
      box.appendChild(c);
    });
  }

  function claimBanner(d) {
    var b = $('claimBanner');
    b.textContent = '';
    if (!d.claim) { b.className = 'banner hidden'; return; }
    b.className = 'banner';
    var left = el('div');
    var started = d.claim.status === 'started';
    left.appendChild(el('div', 'b-title', started ? 'رابری «' + d.claim.name + '» در حال انجامه' : 'رابری «' + d.claim.name + '» برای گنگ شما رزرو شد'));
    left.appendChild(el('div', 'b-sub', started ? 'موفق باشید!' : 'با پارتی کامل برید و کنار مارکر E بزنید. هر کسی زودتر برسه...'));
    b.appendChild(left);
    if (!started) {
      var t = el('div', 'b-time', clock(d.claim.secondsLeft - elapsed()));
      t.setAttribute('data-left', d.claim.secondsLeft);
      b.appendChild(t);
      var btns = el('div', 'b-btns');
      var gps = el('button', 'btn ghost', 'مسیر روی نقشه'); gps.onclick = function () { post('waypoint'); };
      btns.appendChild(gps);
      if (d.isBoss) {
        var cancel = el('button', 'btn danger', 'لغو'); cancel.onclick = function () { post('cancelClaim'); };
        btns.appendChild(cancel);
      }
      b.appendChild(btns);
    }
  }

  function robCard(r, d, ctx) {
    ctx = ctx || {};
    var card = el('div', 'card' + (r.status === 'mine' ? ' mine' : ''));

    var top = el('div', 'card-top');
    var nameBox = el('div', 'card-name', r.name);
    if (ctx.lottery && r.cost) nameBox.appendChild(el('span', 'cost', fa(r.cost) + ' Point'));
    top.appendChild(nameBox);
    var label = STATUS[r.status] || r.status;
    if (r.status === 'claimed' && r.byLabel) label = 'رزرو: ' + r.byLabel;
    top.appendChild(el('div', 'badge ' + r.status, label));
    card.appendChild(top);

    var meta = el('div', 'meta');
    meta.appendChild(el('span', 'tag', fa(r.cops) + ' پلیس'));
    meta.appendChild(el('span', 'tag', r.team > 0 ? fa(r.team) + ' نفر پارتی' : 'تکی'));
    card.appendChild(meta);

    var need = el('div', 'need');
    need.appendChild(el('span', 'tier-' + r.tier, fa(r.planCount) + ' × پلن ' + (r.tierLabel || r.tier)));
    need.appendChild(el('span', 'have ' + (r.have >= r.planCount ? 'ok' : 'low'), 'موجودی آرموری: ' + fa(r.have)));
    card.appendChild(need);

    if (r.reward && r.reward.min) {
      var rw = el('div', 'reward');
      rw.appendChild(document.createTextNode('جایزه: '));
      rw.appendChild(el('b', null, money(r.reward.min) + ' تا ' + money(r.reward.max)));
      card.appendChild(rw);
    }

    if (ctx.lottery) {
      var lt = el('div', 'meta');
      lt.appendChild(el('span', 'tag', 'پلن‌های من: ' + fa(r.myTickets || 0)));
      lt.appendChild(el('span', 'tag', 'گنگ‌های شرکت‌کننده: ' + fa(r.entrants || 0)));
      if (r.myTickets) lt.appendChild(el('span', 'tag', 'شانس برد: ' + fa(r.myChance || 0) + '٪'));
      card.appendChild(lt);
    }

    if (r.secondsLeft && (r.status === 'cooldown' || r.status === 'claimed' || r.status === 'locked' || r.status === 'mine')) {
      var tm = el('div', 'timer', clock(r.secondsLeft - elapsed()));
      tm.setAttribute('data-left', r.secondsLeft);
      card.appendChild(tm);
    }

    var btn = el('button', 'btn');
    if (r.status === 'free') {
      if (ctx.lottery) {
        btn.textContent = 'افزودن پلن به قرعه‌کشی' + (r.cost ? ' (' + fa(r.cost) + ' Point)' : '');
        if (r.canClaim) {
          btn.onclick = function () { btn.disabled = true; post('ticket', { rob: r.key }); };
        } else {
          btn.disabled = true;
          if (ctx.phase && ctx.phase !== 'open') btn.textContent = 'قرعه‌کشی باز نیست';
          else if (!d.isBoss) btn.textContent = 'فقط بوس';
          else if (r.have < r.planCount) btn.textContent = 'پلن کافی نیست';
          else if (r.cost && (d.points || 0) < r.cost) btn.textContent = 'پوینت کافی نیست';
          else btn.textContent = 'در دسترس نیست';
        }
      } else {
        btn.textContent = 'درخواست رابری';
        if (r.canClaim) {
          btn.onclick = function () { btn.disabled = true; post('claim', { rob: r.key }); };
        } else {
          btn.disabled = true;
          if (!d.isBoss) btn.textContent = 'فقط بوس';
          else if (d.lottery && d.lottery.enabled && !ctx.lottery) btn.textContent = 'از تب قرعه‌کشی';
          else if (d.claim) btn.textContent = 'رابری فعال دارید';
          else if (r.have < r.planCount) btn.textContent = 'پلن کافی نیست';
          else if (r.cost && (d.points || 0) < r.cost) btn.textContent = 'پوینت کافی نیست';
          else btn.textContent = 'در دسترس نیست';
        }
      }
    } else if (r.status === 'mine') {
      btn.textContent = 'مسیر روی نقشه'; btn.className = 'btn ghost'; btn.onclick = function () { post('waypoint'); };
    } else {
      btn.disabled = true;
      btn.textContent = (r.status === 'cooldown' || r.status === 'locked') ? 'کول‌داون' : 'در دسترس نیست';
    }
    card.appendChild(btn);
    return card;
  }

  function renderRobberies(d) {
    var g = $('robGrid');
    g.textContent = '';
    if (!d.robberies || !d.robberies.length) { g.appendChild(el('div', 'empty', 'رابری پلن‌داری تعریف نشده.')); return; }
    d.robberies.forEach(function (r) { g.appendChild(robCard(r, d, { lottery: false })); });
  }

  function renderLottery(d) {
    var tabBtn = $('tabLottery');
    var enabled = !!(d.lottery && d.lottery.enabled && d.lottery.current);
    tabBtn.className = 'tab' + (enabled ? '' : ' hidden') + (state.tab === 'lottery' ? ' active' : '');
    if (!enabled) { if (state.tab === 'lottery') setTab('robberies'); return; }

    var round = state.preview ? d.lottery.next : d.lottery.current;
    $('lotName').textContent = 'Robbery ' + round.name;
    $('btnRound').textContent = state.preview ? '←' : '→';
    $('btnRound').title = state.preview ? 'دوره‌ی فعلی' : 'دوره‌ی بعدی';
    $('lotPoints').textContent = fa(d.points || 0);
    $('lotPlans').textContent = fa(d.totalPlans || 0);

    var box = $('lotStatus'), title = $('lotStatusTitle'), time = $('lotStatusTime');
    var open = round.phase === 'open';
    box.className = 'lot-status' + (open ? ' open' : '');
    if (open) {
      title.textContent = 'قرعه‌کشی باز است - اولین گنگی که درخواست بده برنده‌ست';
    } else {
      title.textContent = state.preview ? 'قرعه‌کشی‌ی دوره‌ی بعد' : 'قرعه‌کشی هنوز شروع نشده';
    }
    time.textContent = 'زمان باقی‌مانده : ' + clock(round.secondsLeft - elapsed());
    time.setAttribute('data-left', round.secondsLeft);
    time.setAttribute('data-prefix', 'زمان باقی‌مانده : ');

    var items = $('lotItems');
    items.textContent = '';
    (round.items || []).forEach(function (r) {
      items.appendChild(robCard(r, d, { lottery: true, phase: state.preview ? 'waiting' : round.phase }));
    });
    $('lotNote').textContent = open ? 'هر پلن اضافه‌شده به قرعه‌کشی پوینت و پلن خرج می‌کنه. وقتی دوره تموم شه یه گنگ به‌صورت تصادفی (بر اساس تعداد پلن‌ها) برنده می‌شه؛ بقیه پلن و پوینتشون برمی‌گرده.' : 'وقتی دوره باز شد، پلن اضافه کنید. هر پلن شانس برد رو بیشتر می‌کنه.';
  }

  function renderStats(d) {
    var s = d.stats || { wins: 0, losses: 0, tokens: 0, pending: [] };
    var total = s.wins + s.losses;
    $('stWins').textContent = fa(s.wins);
    $('stLosses').textContent = fa(s.losses);
    $('stTokens').textContent = fa(s.tokens);
    $('stPoints').textContent = fa(d.points !== undefined ? d.points : (s.points || 0));
    var rate = total > 0 ? Math.round(s.wins * 100 / total) : 0;
    $('stRate').textContent = fa(rate) + '٪';
    $('barWin').style.width = (total > 0 ? rate : 0) + '%';
    $('tokenNote').textContent = 'برد وقتی حساب می‌شه که توکن رابری ظرف ' + fa(d.tokenMinutes || 30) + ' دقیقه برای گنگ استفاده بشه؛ وگرنه باخت ثبت می‌شه.';
    var list = $('pendingList');
    list.textContent = '';
    if (!s.pending || !s.pending.length) { list.appendChild(el('div', 'empty', 'توکن استفاده‌نشده‌ای ندارید.')); return; }
    s.pending.forEach(function (p) {
      var row = el('div', 'pending-row');
      row.appendChild(el('span', null, 'توکن رابری «' + p.rob + '»'));
      var t = el('span', 't', clock(p.secondsLeft - elapsed()));
      t.setAttribute('data-left', p.secondsLeft);
      row.appendChild(t);
      list.appendChild(row);
    });
  }

  function render() {
    var d = state.data;
    if (!d) return;
    $('sideGang').textContent = d.label || d.gang || '';
    $('headTitle').textContent = 'رابری گنگ';
    $('headSub').textContent = d.isBoss ? 'شما بوس هستید و می‌تونید رابری درخواست بدید' : 'فقط بوس می‌تونه رابری درخواست بده';
    $('copsOnline').textContent = fa(d.copsOnline || 0);
    if ($('helpClaim')) $('helpClaim').textContent = fa(d.claimMinutes || 10);
    if ($('helpToken')) $('helpToken').textContent = fa(d.tokenMinutes || 30);
    planChips(d);
    claimBanner(d);
    renderRobberies(d);
    renderLottery(d);
    renderStats(d);
  }

  // live countdowns: update the numbers in place every second (no re-render, no flicker)
  function tick() {
    var nodes = document.querySelectorAll('[data-left]');
    for (var i = 0; i < nodes.length; i++) {
      var left = Number(nodes[i].getAttribute('data-left')) - elapsed();
      nodes[i].textContent = (nodes[i].getAttribute('data-prefix') || '') + clock(left);
    }
  }

  function setTab(name) {
    state.tab = name;
    ['lottery', 'robberies', 'stats', 'help'].forEach(function (t) {
      $('view-' + t).className = 'view' + (t === name ? '' : ' hidden');
    });
    var tabs = document.querySelectorAll('.tab');
    for (var i = 0; i < tabs.length; i++) tabs[i].className = 'tab' + (tabs[i].getAttribute('data-tab') === name ? ' active' : '');
  }

  function setData(d) { state.data = d; state.loadedAt = Date.now(); render(); }

  function open(d) {
    $('app').className = '';
    var mainEl = document.querySelector('main'); if (mainEl) mainEl.scrollTop = 0;
    state.preview = false;
    // with the lottery on, that board is the front page
    setTab(d && d.lottery && d.lottery.enabled ? 'lottery' : 'robberies');
    setData(d);
    clearInterval(refreshTimer); clearInterval(tickTimer);
    refreshTimer = setInterval(function () { post('refresh'); }, 3000);
    tickTimer = setInterval(tick, 1000);
  }

  function close() {
    $('app').className = 'hidden';
    clearInterval(refreshTimer); clearInterval(tickTimer);
  }

  // ---------- wiring ----------
  window.addEventListener('message', function (e) {
    var m = e.data || {};
    // gang war / territory screens (kinds.js) share this page: robbery code stays out of their way
    if (m.action === 'open') {
      if (m.kind && m.kind !== 'robbery') { window.__kindActive = true; return; }
      // always clear the other screens first (a leftover help/territory panel must never show here)
      if (window.__kinds) window.__kinds.leave();
      window.__kindActive = false;
      open(m.data);
    }
    else if (m.action === 'update') { if (!window.__kindActive) setData(m.data); }
    else if (m.action === 'close') close();
    else if (m.action === 'toast') toast(m.text, m.ok);
  });

  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') post('close'); });
  $('btnClose').onclick = function () { post('close'); };
  $('btnRound').onclick = function () { state.preview = !state.preview; render(); };
  var tabs = document.querySelectorAll('.tab');
  for (var i = 0; i < tabs.length; i++) (function (t) { t.onclick = function () { setTab(t.getAttribute('data-tab')); }; })(tabs[i]);

  // expose for the browser preview / tests
  window.__heist = { open: open, setData: setData, close: close, render: render, setTab: setTab };

  // browser preview: open index.html?demo to see it with sample data
  if (typeof location !== 'undefined' && /[?&]demo/.test(location.search)) {
    open({
      hasGang: true, gang: 'kingpin', label: 'Kingpin', isBoss: true, copsOnline: 9, claimMinutes: 7, tokenMinutes: 30,
      plans: { bronze: 4, silver: 1, premium: 6 }, planLabels: { bronze: 'برنز', silver: 'سیلور', premium: 'پریمیوم' },
      stats: { wins: 7, losses: 3, tokens: 7, pending: [{ rob: 'Bank Pelato', secondsLeft: 1500 }] },
      points: 316, totalPlans: 239,
      lottery: { enabled: true,
        current: { name: 'A', phase: 'waiting', secondsLeft: 438, items: [
          { key: 'Jaw_Shahr', name: 'Flat Jewelry', tier: 'silver', tierLabel: 'سیلور', planCount: 2, have: 1, cops: 5, team: 4, cost: 8, status: 'free', canClaim: false },
          { key: 'Palateo_Bank', name: 'Bank markazi', tier: 'premium', tierLabel: 'پریمیوم', planCount: 5, have: 6, cops: 7, team: 5, cost: 8, status: 'free', canClaim: false },
          { key: 'OilRig_1', name: 'AirPort', tier: 'bronze', tierLabel: 'برنز', planCount: 3, have: 4, cops: 4, team: 4, cost: 7, status: 'free', canClaim: false }] },
        next: { name: 'B', phase: 'waiting', secondsLeft: 1638, items: [
          { key: 'Life_Invader', name: 'Life Invader', tier: 'premium', tierLabel: 'پریمیوم', planCount: 5, have: 6, cops: 7, team: 5, cost: 8, status: 'free', canClaim: false }] } },
      claim: { rob: 'Jaw_Shahr', name: 'Jaw Shahr', status: 'claimed', secondsLeft: 380 },
      robberies: [
        { key: 'Palateo_Bank', name: 'Bank Pelato', type: 'Palateo_Bank', tier: 'premium', tierLabel: 'پریمیوم', planCount: 5, have: 6, cops: 7, team: 5, reward: { min: 1700000, max: 2500000 }, status: 'free' },
        { key: 'Life_Invader', name: 'Life Invader (Bime)', type: 'Life_Invader', tier: 'premium', tierLabel: 'پریمیوم', planCount: 5, have: 6, cops: 7, team: 5, reward: { min: 900000, max: 1400000 }, status: 'claimed', byLabel: 'Ballas', secondsLeft: 250 },
        { key: 'Jaw_Shahr', name: 'Jaw Shahr', type: 'Jewerlly', tier: 'silver', tierLabel: 'سیلور', planCount: 2, have: 1, cops: 5, team: 4, status: 'mine', secondsLeft: 380 },
        { key: 'FleeccE_1', name: 'FleeccE Bank 1', type: 'Minibank', tier: 'bronze', tierLabel: 'برنز', planCount: 3, have: 4, cops: 5, team: 4, status: 'cooldown', secondsLeft: 700 }
      ]
    });
  }
})();
