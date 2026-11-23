/*
  Bridge بین UI سان (که standalone ساخته شده) و صفحه‌ی مرکزی Unique_Event (iframe router).
  - وقتی منوی انتخاب اسپان باز میشه، به صفحه‌ی مرکزی خبر میده تا pointer-events فریم فعال بشه
    (بدون این، کلیک روی منو به UI نمی‌رسه).
  - کلید ESC روی منوی اسپان = دکمه‌ی Cancel (تو UI اصلی ESC هندل نشده بود و NUI focus گیر می‌کرد).
*/
(function () {
  // ایمنی: منوی اسپان همیشه بالاتر از صفحه‌ی مرگ؛ صفحه‌ی مرگ هیچ‌وقت کلیک نخوره
  var st = document.createElement('style');
  st.textContent = '.spawn-overlay{z-index:1000 !important}.death-screen{pointer-events:none !important}';
  document.head.appendChild(st);
  var last = null;
  function post(visible) {
    if (visible === last) return;
    last = visible;
    try { window.parent.postMessage({ __frame: 'capture', __visible: visible }, '*'); } catch (e) {}
  }
  function check() { post(!!document.querySelector('.spawn-overlay')); }
  new MutationObserver(check).observe(document.documentElement, { childList: true, subtree: true });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    var cancel = document.querySelector('.spawn-overlay .cancel, .spawn-overlay .spawn-cancel, .spawn-overlay [class*="cancel"]');
    if (cancel) { e.preventDefault(); cancel.click(); }
  });
  check();
})();


/* ===========================================================================
   Persistent leaderboard (Top Families + Top Players) - Q hide/show like F4
   =========================================================================== */
(function () {
  var css = '' +
  '#capboard{position:fixed;top:58px;left:14px;width:292px;display:flex;flex-direction:column;gap:8px;z-index:40;pointer-events:none;' +
  'font-family:"Rajdhani","Segoe UI",Tahoma,sans-serif;color:#fff;opacity:0;transform:translateX(-24px);transition:opacity .28s ease,transform .28s ease}' +
  '#capboard.show{opacity:1;transform:none}' +
  '#capboard .cb-card{background:linear-gradient(180deg,rgba(15,19,30,.9),rgba(9,12,20,.84));border:1px solid rgba(255,255,255,.07);' +
  'border-radius:10px;overflow:hidden;box-shadow:0 8px 26px rgba(0,0,0,.5)}' +
  '#capboard .cb-head{display:flex;align-items:center;justify-content:space-between;padding:7px 12px;font-weight:700;font-size:13px;letter-spacing:1.6px;text-transform:uppercase}' +
  '#capboard .fam .cb-head{background:linear-gradient(90deg,rgba(29,233,182,.34),rgba(29,233,182,.04));border-left:3px solid #1de9b6;color:#1de9b6}' +
  '#capboard .ply .cb-head{background:linear-gradient(90deg,rgba(255,71,87,.34),rgba(255,71,87,.04));border-left:3px solid #ff4757;color:#ff6b78}' +
  '#capboard .cb-key{font-size:10px;letter-spacing:1px;color:#cfd3dc;border:1px solid rgba(255,255,255,.25);border-radius:4px;padding:0 5px;background:rgba(255,255,255,.07)}' +
  '#capboard .cb-row{display:grid;grid-template-columns:22px 1fr auto;align-items:center;gap:8px;padding:5px 12px;font-size:14px;font-weight:600;border-top:1px solid rgba(255,255,255,.045)}' +
  '#capboard .cb-row:nth-child(even){background:rgba(255,255,255,.025)}' +
  '#capboard .cb-row.me{background:linear-gradient(90deg,rgba(255,196,36,.22),rgba(255,196,36,.04));box-shadow:inset 3px 0 0 #ffc424}' +
  '#capboard .cb-rank{width:20px;height:20px;border-radius:5px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;background:rgba(255,255,255,.1);color:#cfd3dc}' +
  '#capboard .r1{background:#ffc424;color:#3a2a00}#capboard .r2{background:#c9d1d9;color:#222}#capboard .r3{background:#d08a4a;color:#2b1500}' +
  '#capboard .cb-name{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}' +
  '#capboard .cb-val{display:flex;align-items:center;gap:8px;font-variant-numeric:tabular-nums}' +
  '#capboard .cb-flag{font-size:11px;color:#1de9b6;background:rgba(29,233,182,.14);border-radius:4px;padding:0 5px}' +
  '#capboard .cb-pts{color:#ffd24a;font-weight:700}#capboard .cb-k{color:#4ce065}#capboard .cb-d{color:#ff6b78}' +
  '#capboard .cb-empty{padding:8px 12px;font-size:12px;color:#8b93a3;text-align:center}';
  var st = document.createElement('style'); st.textContent = css; document.head.appendChild(st);

  var box = document.createElement('div'); box.id = 'capboard';
  document.body.appendChild(box);
  var hidden = false, data = null;

  function esc(s) { var d = document.createElement('div'); d.textContent = String(s == null ? '' : s); return d.innerHTML; }
  function rank(i) { return '<span class="cb-rank' + (i < 3 ? ' r' + (i + 1) : '') + '">' + (i + 1) + '</span>'; }

  function render() {
    if (!data) { box.classList.remove('show'); return; }
    var fam = (data.families || []).slice(0, 5), ply = (data.players || []).slice(0, 5);
    var h = '<div class="cb-card fam"><div class="cb-head"><span>Top Families</span><span class="cb-key">Q</span></div>';
    if (!fam.length) h += '<div class="cb-empty">Hanoz Gangi Emtiaz Nagerefte</div>';
    fam.forEach(function (f, i) {
      var me = f.name === data.myGang ? ' me' : '';
      h += '<div class="cb-row' + me + '">' + rank(i) + '<span class="cb-name">' + esc(f.name) + '</span>' +
           '<span class="cb-val">' + (f.flags ? '<span class="cb-flag">\u2691 ' + f.flags + '</span>' : '') + '<span class="cb-pts">' + (f.point | 0) + '</span></span></div>';
    });
    h += '</div><div class="cb-card ply"><div class="cb-head"><span>Top Players</span></div>';
    if (!ply.length) h += '<div class="cb-empty">Hanoz Kili Sabt Nashode</div>';
    ply.forEach(function (p, i) {
      var me = data.myName && String(p.name).indexOf(data.myName + ' [') === 0 ? ' me' : '';
      h += '<div class="cb-row' + me + '">' + rank(i) + '<span class="cb-name">' + esc(p.name) + '</span>' +
           '<span class="cb-val"><span class="cb-k">' + (p.kills | 0) + '</span><span>/</span><span class="cb-d">' + (p.deaths | 0) + '</span></span></div>';
    });
    h += '</div>';
    box.innerHTML = h;
    if (!hidden) box.classList.add('show');
  }

  window.addEventListener('message', function (e) {
    var m = e.data; if (!m || !m.action) return;
    if (m.action === 'capBoard') { data = m.data || null; render(); }
    else if (m.action === 'capBoardVisible') {
      hidden = !!(m.data && m.data.hidden);
      if (hidden) box.classList.remove('show'); else if (data) box.classList.add('show');
    } else if (m.action === 'capBoardHide') { hidden = false; data = null; box.classList.remove('show'); }
  });
})();
