(function () {
  var IMG_SERVER = 'https://cdn.sunrp.ir';
  var DEFAULT_IMG = 'default.svg';
  var inGame = (function () { try { var h = window.location.hostname; return !(h === 'localhost' || h === '127.0.0.1' || window.location.protocol === 'file:'); } catch (e) { return true; } })();
  var RES = (function () { try { var h = window.location.hostname || ''; if (h.indexOf('cfx-nui-') === 0) return h.substring(8); if (window.GetParentResourceName) return GetParentResourceName(); } catch (e) {} return 'sun-tattoo-shop'; })();

  var SVG_OPEN = '<svg class="category-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">';
  function svg(body) { return SVG_OPEN + body + '</svg>'; }
  var CAT_ICONS = {
    ink: svg('<path d="M12 3s6 6.6 6 10.5a6 6 0 0 1-12 0C6 9.6 12 3 12 3z"/>'),
    flame: svg('<path d="M12 3c0 3-2 4-2 7a2 2 0 0 0 4 0c0-1 0-1.6-.5-2.5 2 1 3.5 3 3.5 5.5a5 5 0 0 1-10 0c0-3.5 3-6 5-10z"/>'),
    rose: svg('<path d="M12 5a2.5 2.5 0 0 1 2.5 2.5c0 2-2.5 3.5-2.5 3.5S9.5 9.5 9.5 7.5A2.5 2.5 0 0 1 12 5z"/><path d="M12 11v8"/><path d="M12 16c-2.2 0-3.6-1-4-3 2.2 0 3.6 1 4 3z"/>'),
    skull: svg('<path d="M12 3a7 7 0 0 0-7 7c0 2.4 1.2 3.9 3 5v2a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-2c1.8-1.1 3-2.6 3-5a7 7 0 0 0-7-7z"/><circle cx="9.3" cy="10.3" r="1.2"/><circle cx="14.7" cy="10.3" r="1.2"/><path d="M11 16h2"/>'),
    snake: svg('<path d="M6 18c2.5 1 4.5-.5 4-2.5-.5-2-3.5-1.5-4-3.5S8 8 11 8.5c2 .3 3.5-.3 4.5-1.5"/><circle cx="17" cy="6" r="0.9"/>'),
    star: svg('<path d="M12 3.5l2.5 5.1 5.6.8-4.1 4 1 5.6L12 17.9l-5 2.6 1-5.6-4.1-4 5.6-.8z"/>'),
    heart: svg('<path d="M12 20s-7-4.3-7-9.2A3.8 3.8 0 0 1 12 8a3.8 3.8 0 0 1 7 2.8C19 15.7 12 20 12 20z"/>'),
    anchor: svg('<circle cx="12" cy="5" r="2"/><line x1="12" y1="7" x2="12" y2="20"/><line x1="9" y1="10" x2="15" y2="10"/><path d="M5 13a7 7 0 0 0 14 0"/>'),
    gem: svg('<path d="M5 4h14l3 5-10 11L2 9z"/><path d="M2 9h20"/><path d="M9 4l3 16 3-16"/>'),
    butterfly: svg('<path d="M12 7v10"/><path d="M12 9C9.5 4.5 4 5 4.5 9.5 4 13 8 14.5 12 10"/><path d="M12 9c2.5-4.5 8-4 7.5.5C20 13 16 14.5 12 10"/>'),
    bolt: svg('<path d="M13 3l-7 11h5l-1 7 7-11h-5z"/>'),
    eye: svg('<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="2.5"/>'),
    moon: svg('<path d="M16 4a8 8 0 1 0 4 12A6.5 6.5 0 0 1 16 4z"/><path d="M18.2 4.4l.6 1.5 1.5.6-1.5.6-.6 1.5-.6-1.5-1.5-.6 1.5-.6z"/>'),
    sun: svg('<circle cx="12" cy="12" r="4"/><path d="M12 2v2.5M12 19.5V22M2 12h2.5M19.5 12H22M4.9 4.9l1.8 1.8M17.3 17.3l1.8 1.8M19.1 4.9l-1.8 1.8M6.7 17.3l-1.8 1.8"/>'),
    paw: svg('<path d="M8.5 14.5a3.5 3.5 0 0 1 7 0 2.4 2.4 0 0 1-2.4 2.4h-2.2a2.4 2.4 0 0 1-2.4-2.4z"/><ellipse cx="7.5" cy="10" rx="1.1" ry="1.7"/><ellipse cx="12" cy="8.5" rx="1.1" ry="1.7"/><ellipse cx="16.5" cy="10" rx="1.1" ry="1.7"/>'),
    feather: svg('<path d="M4 20l7-7"/><path d="M11 13a7.5 7.5 0 0 1 7.5-7.5A7.5 7.5 0 0 1 11 13z"/><path d="M9.5 11.5h4.5M11.5 9.5v4.5"/>'),
    wave: svg('<path d="M3 8c2 0 2 2 4 2s2-2 4-2 2 2 4 2 2-2 4-2"/><path d="M3 14c2 0 2 2 4 2s2-2 4-2 2 2 4 2 2-2 4-2"/>'),
    crown: svg('<path d="M4 18h16M5 8l3.5 4L12 5l3.5 7L19 8l-1.5 10H6.5z"/>'),
    gang: svg('<circle cx="9" cy="8" r="3"/><path d="M3.5 20a5.5 5.5 0 0 1 11 0"/><circle cx="17.5" cy="9.5" r="2.1"/><path d="M15 20a4.6 4.6 0 0 1 6.4-4.6"/>'),
    trash: svg('<path d="M3 6h18"/><path d="M8 6V4a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2"/><path d="M6 6l1 14a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-14"/>')
  };
  function catIcon(name) { return CAT_ICONS[name] || CAT_ICONS.ink; }

  var state = { cats: [], active: -1, items: [], sel: null, cols: 3 };
  var el = function (id) { return document.getElementById(id); };
  function fmt(n) { return (n || 0).toLocaleString(); }

  function hexRgb(hex) { hex = ('' + (hex || '')).replace('#', ''); if (hex.length === 3) hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]; var n = parseInt(hex, 16); return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 }; }
  function lighten(hex, a) { var c = hexRgb(hex); return 'rgb(' + Math.round(c.r + (255 - c.r) * a) + ',' + Math.round(c.g + (255 - c.g) * a) + ',' + Math.round(c.b + (255 - c.b) * a) + ')'; }
  function darken(hex, a) { var c = hexRgb(hex); return 'rgb(' + Math.round(c.r * (1 - a)) + ',' + Math.round(c.g * (1 - a)) + ',' + Math.round(c.b * (1 - a)) + ')'; }
  function setTrio(name, hex) {
    if (!hex) return;
    var r = document.documentElement.style;
    r.setProperty('--' + name, hex);
    r.setProperty('--' + name + '-light', lighten(hex, 0.25));
    r.setProperty('--' + name + '-dark', darken(hex, 0.3));
  }
  function applyTheme(primary, secondary) {
    setTrio('gold', primary);
    setTrio('purple', secondary);
  }

  function post(name, data) { if (inGame) { try { fetch('https://' + RES + '/' + name, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data || {}) }); } catch (e) {} } }

  function imgFor(t) { return t.img || (t.txd ? (IMG_SERVER + '/clothes/tattoo/' + t.cat + '_' + t.txd + '.png') : DEFAULT_IMG); }

  function renderCategories() {
    var box = el('categoriesList');
    box.innerHTML = '';
    state.cats.forEach(function (c, i) {
      var d = document.createElement('div');
      d.className = 'category-item' + (i === state.active ? ' active' : '');
      d.innerHTML = catIcon(c.icon);
      d.onclick = function () { selectCategory(i); };
      d.onmouseenter = function () { showTip(c.label, d, 'left'); };
      d.onmouseleave = hideTip;
      box.appendChild(d);
    });
  }

  function selectCategory(i) {
    state.active = i;
    state.sel = null;
    var c = state.cats[i];
    state.items = c ? c.tattoos : [];
    renderCategories();
    el('currentCategory').textContent = c ? c.label : '';
    renderItems(state.items);
    updateAction();
    post('category', { key: c ? c.key : null });
  }

  function renderItems(list) {
    var grid = el('itemsGrid');
    grid.innerHTML = '';
    el('itemsCount').textContent = (list || []).length;
    if (!list || !list.length) { grid.innerHTML = '<div class="empty-state">آیتمی یافت نشد</div>'; return; }
    var cat = state.cats[state.active];
    list.forEach(function (t) {
      var card = document.createElement('div');
      card.className = 'item-card fade-in' + (t.owned ? ' owned' : '') + (state.sel === t.key ? ' selected' : '');
      card.dataset.key = t.key;
      var isDel = (cat && cat.kind === 'delete');
      var badge = isDel ? '' : (t.owned ? '<div class="owned-badge">دارید</div>' : '');
      card.innerHTML =
        badge +
        '<img class="item-image" src="' + imgFor(t) + '" alt="" onerror="this.onerror=null;this.src=\'' + DEFAULT_IMG + '\';this.classList.add(\'fallback-icon\');">' +
        '<div class="item-info"><div class="item-num">#' + t.num + '</div></div>';
      card.onclick = function () { selectItem(t, card); };
      grid.appendChild(card);
    });
  }

  function curCat() { return state.cats[state.active]; }
  function selTattoo() { for (var i = 0; i < state.items.length; i++) if (state.items[i].key === state.sel) return state.items[i]; return null; }

  function selectItem(t, card) {
    state.sel = t.key;
    var prev = el('itemsGrid').querySelector('.item-card.selected'); if (prev) prev.classList.remove('selected');
    if (card) card.classList.add('selected');
    el('selectedName').textContent = t.label;
    el('selectedPrice').textContent = (curCat() && curCat().kind === 'delete') ? '' : ('$' + fmt(t.price));
    updateAction();
    post('preview', { cat: t.cat, num: t.num });
  }

  function updateAction() {
    var btn = el('actionBtn'), c = curCat(), t = selTattoo();
    if (c && c.kind === 'delete') {
      btn.textContent = 'حذف'; btn.classList.add('danger'); btn.disabled = !t;
    } else {
      btn.classList.remove('danger');
      if (t && t.owned) { btn.textContent = 'دارید'; btn.disabled = true; }
      else { btn.textContent = 'خرید'; btn.disabled = !t; }
    }
  }

  function doAction() {
    var c = curCat(), t = selTattoo();
    if (!t) return;
    if (c.kind === 'delete') post('delete', { cat: t.cat, num: t.num });
    else if (!t.owned) post('buy', { cat: t.cat, num: t.num });
  }

  function cam(dir) { post('camera', { dir: dir }); }
  function closeShop() { el('app').classList.add('hidden'); post('close', {}); }

  function toggleSettings() {
    el('settingsPanel').classList.toggle('hidden');
    el('settingsOverlay').classList.toggle('hidden');
  }
  function setCols(n) {
    state.cols = n;
    var grid = el('itemsGrid');
    grid.className = grid.className.replace(/cols-\d/g, '').trim() + ' cols-' + n;
    var btns = document.querySelectorAll('.settings-grid-btn');
    for (var i = 0; i < btns.length; i++) btns[i].classList.toggle('active', btns[i].getAttribute('data-cols') == n);
  }

  var tip = function () { return el('globalTooltip'); };
  function showTip(text, target, side) { var t = tip(); if (!t) return; t.textContent = text; var r = target.getBoundingClientRect(); t.style.display = 'block'; if (side === 'left') { t.style.top = (r.top + r.height / 2) + 'px'; t.style.left = (r.left - 12) + 'px'; t.style.webkitTransform = 'translate(-100%, -50%)'; t.style.transform = 'translate(-100%, -50%)'; } else { t.style.top = (r.bottom + 8) + 'px'; t.style.left = (r.left + r.width / 2) + 'px'; t.style.webkitTransform = 'translate(-50%, 0)'; t.style.transform = 'translate(-50%, 0)'; } }
  function hideTip() { var t = tip(); if (t) t.style.display = 'none'; }

  function openShop(data) {
    state.cats = data.categories || [];
    state.active = -1; state.sel = null; state.items = [];
    if (data.accPrimary || data.acc) applyTheme(data.accPrimary, data.acc);
    renderCategories();
    el('currentCategory').innerHTML = '<span class="select-arrow">→</span> انتخاب کنید';
    el('itemsGrid').innerHTML = '<div class="empty-state">یک دسته‌بندی انتخاب کنید</div>';
    el('itemsCount').textContent = '0';
    el('selectedName').textContent = '-'; el('selectedPrice').textContent = '-';
    updateAction();
    el('app').classList.remove('hidden');
    if (state.cats.length) selectCategory(0);
  }

  function refresh(data) {
    state.cats = data.categories || state.cats;
    var c = state.cats[state.active];
    state.items = c ? c.tattoos : [];
    renderCategories();
    renderItems(state.items);
    updateAction();
  }

  window.addEventListener('message', function (ev) {
    var d = ev.data || {};
    if (d.action === 'open') openShop(d);
    else if (d.action === 'close') el('app').classList.add('hidden');
    else if (d.action === 'setColor') applyTheme(d.accPrimary, d.acc);
    else if (d.action === 'refresh') refresh(d);
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeShop();
    else if (e.key === 'ArrowLeft') cam('rotate-left');
    else if (e.key === 'ArrowRight') cam('rotate-right');
  });

  // hold-to-repeat for rotate / zoom camera buttons
  document.addEventListener('mousedown', function (e) {
    var btn = e.target.closest ? e.target.closest('[data-cam]') : null;
    if (!btn) return;
    e.preventDefault();
    var dir = btn.getAttribute('data-cam');
    cam(dir);
    var iv = null;
    var to = setTimeout(function () { iv = setInterval(function () { cam(dir); }, 90); }, 320);
    function stop() {
      clearTimeout(to); if (iv) clearInterval(iv);
      document.removeEventListener('mouseup', stop);
      btn.removeEventListener('mouseleave', stop);
    }
    document.addEventListener('mouseup', stop);
    btn.addEventListener('mouseleave', stop);
  });

  // expose for inline handlers
  window.closeShop = closeShop;
  window.doAction = doAction;
  window.cam = cam;
  window.toggleSettings = toggleSettings;
  window.setCols = setCols;
  window.showTip = showTip;
  window.hideTip = hideTip;

  if (!inGame) {
    var mk = function (n, p, cat, num, owned) { return { key: cat + '_' + num, label: n, price: p, cat: cat, num: num, owned: !!owned, name: n.replace(/\s+/g, '_') }; };
    openShop({
      accPrimary: '#FFB734',
      acc: '#16d6c1',
      categories: [
        { key: 'c1', label: 'Business', icon: 'flame', kind: 'shop', tattoos: [mk('Dragon Arm', 5000, 'c1', 1), mk('Tribal Sleeve', 4500, 'c1', 2), mk('Snake Coil', 6000, 'c1', 3, true), mk('Rose Vine', 3500, 'c1', 4), mk('Skull Row', 5500, 'c1', 5), mk('Koi Fish', 7000, 'c1', 6)] },
        { key: 'c2', label: 'Hipster', icon: 'rose', kind: 'shop', tattoos: [mk('Eagle Wings', 8000, 'c2', 1), mk('Lion Heart', 7500, 'c2', 2), mk('Compass', 4000, 'c2', 3)] },
        { key: 'c3', label: 'Biker', icon: 'skull', kind: 'shop', tattoos: [mk('Piston', 3200, 'c3', 1), mk('Chain', 2800, 'c3', 2)] },
        { key: 'c4', label: 'Beach', icon: 'wave', kind: 'shop', tattoos: [mk('Palm', 2500, 'c4', 1), mk('Surf', 2700, 'c4', 2)] },
        { key: 'c5', label: 'Heist', icon: 'gem', kind: 'shop', tattoos: [mk('Vault', 9000, 'c5', 1)] },
        { key: 'gang', label: 'Gang', icon: 'gang', kind: 'shop', tattoos: [mk('Crew Mark', 0, 'gang', 1), mk('Set Tag', 0, 'gang', 2)] },
        { key: 'prime', label: 'Prime', icon: 'crown', kind: 'shop', tattoos: [mk('Golden Crown', 25000, 'prime', 1), mk('Diamond Ink', 30000, 'prime', 2)] },
        { key: 'delete', label: 'Hazf', icon: 'trash', kind: 'delete', tattoos: [mk('Snake Coil', 0, 'c1', 3, true)] }
      ]
    });
  }
})();
