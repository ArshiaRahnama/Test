(function () {
  var inGame = (function () { try { var h = window.location.hostname; return !(h === 'localhost' || h === '127.0.0.1' || window.location.protocol === 'file:'); } catch (e) { return true; } })();
  var RES = (function () { try { var h = window.location.hostname || ''; if (h.indexOf('cfx-nui-') === 0) return h.substring(8); if (window.GetParentResourceName) return GetParentResourceName(); } catch (e) {} return 'esx_barbershop'; })();

  var ICONS = {
    scissors: '<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><line x1="20" y1="4" x2="8.12" y2="15.88"/><line x1="14.47" y1="14.48" x2="20" y2="20"/><line x1="8.12" y1="8.12" x2="12" y2="12"/>',
    hair: '<path d="M5 13a7 7 0 0 1 14 0"/><path d="M5 13v4a2 2 0 0 0 2 2h0"/><path d="M19 13v4a2 2 0 0 1-2 2h0"/><path d="M7 13c1-5 3-7 5-7s4 2 5 7"/><path d="M9.5 6.5C8 8 7.5 10 7.5 12"/><path d="M14.5 6.5C16 8 16.5 10 16.5 12"/>',
    beard: '<path d="M6 5v5a6 6 0 0 0 12 0V5"/><path d="M6 10c0 5 2.5 9 6 9s6-4 6-9"/><path d="M9 8v1"/><path d="M15 8v1"/><path d="M9.5 13c.8.8 1.6 1.2 2.5 1.2s1.7-.4 2.5-1.2"/>',
    eyebrows: '<path d="M3 9c2-1.6 5-1.6 7 0"/><path d="M14 9c2-1.6 5-1.6 7 0"/><circle cx="6.5" cy="14.5" r="1.5"/><circle cx="17.5" cy="14.5" r="1.5"/>',
    makeup: '<path d="M4 20l5-5"/><path d="M9 15l7-7a2.5 2.5 0 0 0-3.5-3.5l-7 7z"/><path d="M14 6l4 4"/><path d="M17 17l.5 1.5L19 19l-1.5.5L17 21l-.5-1.5L15 19l1.5-.5z"/>',
    lipstick: '<rect x="9" y="11" width="6" height="10" rx="1.5"/><path d="M9 11V6.5a3 3 0 0 1 6 0V11"/><path d="M10.5 6.5l3-2"/>',
    ears: '<path d="M8 9a4 4 0 1 1 8 0c0 3-2 3-2 6a3 3 0 0 1-6 0"/><path d="M11.5 9a1.5 1.5 0 0 1 1.5 1.5c0 1.5-1.5 1.5-1.5 3"/>'
  };
  function svg(name) { return '<svg viewBox="0 0 24 24">' + (ICONS[name] || '') + '</svg>'; }

  function hsl2hex(h, s, l) {
    var c = (1 - Math.abs(2 * l - 1)) * s, x = c * (1 - Math.abs((h / 60) % 2 - 1)), m = l - c / 2, r = 0, g = 0, b = 0;
    if (h < 60) { r = c; g = x; } else if (h < 120) { r = x; g = c; } else if (h < 180) { g = c; b = x; }
    else if (h < 240) { g = x; b = c; } else if (h < 300) { r = x; b = c; } else { r = c; b = x; }
    function h2(v) { var s2 = Math.round((v + m) * 255).toString(16); return s2.length === 1 ? '0' + s2 : s2; }
    return '#' + h2(r) + h2(g) + h2(b);
  }
  var HAIR_PALETTE = (function () {
    var p = ['#0c0a09', '#1a1310', '#2a1c14', '#3a2418', '#4a2e1c', '#5c3a22', '#6e4527', '#80532e', '#946338', '#a87444', '#bd8a56', '#d2a774', '#e3c79b', '#f0ddbf',
             '#3a3a3e', '#54555a', '#74757c', '#9a9ba2', '#c2c3c8', '#e6e7ea', '#f6f6f8'];
    var i = 0;
    while (p.length < 64) { p.push(hsl2hex((i * 24) % 360, 0.68, 0.54)); i++; }
    return p;
  })();

  var state = { sections: [], active: 0, price: 0, palette: null };
  var el = function (id) { return document.getElementById(id); };

  var LBL = {
    'Hair': 'مو', 'Beard': 'ریش', 'Brows': 'ابرو', 'Make-up': 'آرایش', 'Lips': 'لب',
    'Style': 'مدل', 'Texture': 'بافت', 'Color': 'رنگ', 'Highlight': 'هایلایت',
    'Opacity': 'شفافیت', 'Accessory': 'اکسسوری'
  };
  function tr(s) { return (s != null && LBL[s]) ? LBL[s] : s; }

  function hexRgb(hex) { hex = ('' + hex).replace('#', ''); if (hex.length === 3) hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]; var n = parseInt(hex, 16); return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 }; }
  function lighten(hex, a) { var c = hexRgb(hex); return 'rgb(' + Math.round(c.r + (255 - c.r) * a) + ',' + Math.round(c.g + (255 - c.g) * a) + ',' + Math.round(c.b + (255 - c.b) * a) + ')'; }
  function applyAccent(hex) {
    if (!hex) return;
    var c = hexRgb(hex), s = el('barber').style;
    s.setProperty('--acc', hex);
    s.setProperty('--acc2', lighten(hex, 0.22));
    s.setProperty('--soft', 'rgba(' + c.r + ',' + c.g + ',' + c.b + ',0.16)');
    s.setProperty('--line', 'rgba(' + c.r + ',' + c.g + ',' + c.b + ',0.55)');
    s.setProperty('--glow', 'rgba(' + c.r + ',' + c.g + ',' + c.b + ',0.40)');
  }

  function post(name, data) { if (inGame) { try { fetch('https://' + RES + '/' + name, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(data || {}) }); } catch (e) {} } }

  function renderRail() {
    var html = '';
    for (var i = 0; i < state.sections.length; i++) {
      var s = state.sections[i];
      html += '<div class="rail-item' + (i === state.active ? ' active' : '') + '" data-idx="' + i + '">' + svg(s.icon) + '<span class="rail-lbl">' + tr(s.label) + '</span></div>';
    }
    el('rail').innerHTML = html;
  }

  function renderPanel() {
    var s = state.sections[state.active];
    if (!s) return;
    el('panelTitle').textContent = tr(s.label || '');
    el('panelBadge').textContent = s.controls.length + ' تنظیم';
    var html = '';
    for (var i = 0; i < s.controls.length; i++) {
      var c = s.controls[i];
      html += '<div class="ctl" data-name="' + c.name + '">';
      html += '<div class="ctl-top"><span class="ctl-lbl">' + tr(c.label) + '</span><span class="ctl-val">' + ctlValText(c) + '</span></div>';
      if (c.type === 'color') html += colorGrid(c);
      else if (c.type === 'range') html += rangeCtl(c);
      else html += stepper(c);
      html += '</div>';
    }
    el('panelBody').innerHTML = html;
  }

  function ctlValText(c) {
    if (c.type === 'color') {
      var n = (state.palette && state.palette.length) ? state.palette.length : (c.max - (c.min || 0) + 1);
      return (c.value - (c.min || 0) + 1) + ' / ' + n;
    }
    return (c.value - (c.min || 0) + 1) + ' / ' + (c.max - (c.min || 0) + 1);
  }
  function stepper(c) {
    var pct = c.max > c.min ? ((c.value - c.min) / (c.max - c.min)) * 100 : 0;
    return '<div class="stepper" data-name="' + c.name + '">' +
      '<div class="step-arrow" data-dir="-1"><svg viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg></div>' +
      '<div class="step-track"><span class="step-hash">#</span><input class="step-input" type="text" inputmode="numeric" value="' + c.value + '" /><div class="step-bar"><div class="step-fill" style="width:' + pct + '%"></div><div class="step-knob" style="left:' + pct + '%"></div></div></div>' +
      '<div class="step-arrow" data-dir="1"><svg viewBox="0 0 24 24"><path d="M9 6l6 6-6 6"/></svg></div>' +
      '</div>';
  }
  function rangeCtl(c) {
    var pct = c.max > c.min ? ((c.value - c.min) / (c.max - c.min)) * 100 : 0;
    return '<div class="range-wrap" data-name="' + c.name + '">' +
      '<div class="range-track">' +
        '<div class="range-fill" style="width:' + pct + '%"></div>' +
        '<div class="range-knob" style="left:' + pct + '%"><span class="range-bubble">' + c.value + '</span></div>' +
      '</div>' +
    '</div>';
  }
  function colorGrid(c) {
    var html = '<div class="swatches" data-name="' + c.name + '">';
    var pal = state.palette;
    var n = (pal && pal.length) ? pal.length : ((c.max || 63) + 1);
    for (var i = 0; i < n; i++) {
      var col = (pal && pal[i]) ? ('rgb(' + pal[i][0] + ',' + pal[i][1] + ',' + pal[i][2] + ')') : HAIR_PALETTE[i % HAIR_PALETTE.length];
      html += '<div class="sw' + (i === c.value ? ' active' : '') + '" data-v="' + i + '" style="background-color:' + col + '"></div>';
    }
    return html + '</div>';
  }

  function findCtl(name) {
    for (var i = 0; i < state.sections.length; i++) for (var j = 0; j < state.sections[i].controls.length; j++) if (state.sections[i].controls[j].name === name) return state.sections[i].controls[j];
    return null;
  }
  function setValue(name, value) {
    var c = findCtl(name); if (!c) return;
    if (value < c.min) value = c.max; if (value > c.max) value = c.min;
    c.value = value;
    renderPanel();
    post('change', { name: name, value: value });
  }

  // events
  document.addEventListener('click', function (e) {
    var rail = e.target.closest ? e.target.closest('.rail-item') : null;
    if (rail) { state.active = parseInt(rail.getAttribute('data-idx')); renderRail(); renderPanel(); post('section', { index: state.active }); return; }
    var sw = e.target.closest ? e.target.closest('.sw') : null;
    if (sw) {
      var grid = sw.closest('.swatches');
      var cc = findCtl(grid.getAttribute('data-name'));
      if (cc) {
        var cv = parseInt(sw.getAttribute('data-v'));
        cc.value = cv;
        var prevSw = grid.querySelector('.sw.active'); if (prevSw) prevSw.classList.remove('active');
        sw.classList.add('active');
        var sctl = grid.closest('.ctl'); var svalEl = sctl ? sctl.querySelector('.ctl-val') : null; if (svalEl) svalEl.textContent = ctlValText(cc);
        post('change', { name: cc.name, value: cv });
      }
      return;
    }
    var cam = e.target.closest ? e.target.closest('.cam-btn') : null;
    if (cam) { post('camera', { dir: cam.getAttribute('data-cam') }); return; }
  });

  // range drag (smooth: direct DOM update, post only on integer change)
  document.addEventListener('mousedown', function (e) {
    var track = e.target.closest ? e.target.closest('.range-track') : null;
    if (!track) return;
    e.preventDefault();
    var wrap = track.closest('.range-wrap');
    var c = findCtl(wrap.getAttribute('data-name'));
    if (!c) return;
    var fill = wrap.querySelector('.range-fill');
    var knob = wrap.querySelector('.range-knob');
    var bubble = wrap.querySelector('.range-bubble');
    var ctl = track.closest('.ctl');
    var valEl = ctl ? ctl.querySelector('.ctl-val') : null;
    var last = c.value;
    wrap.classList.add('dragging');
    function move(ev) {
      var r = track.getBoundingClientRect();
      var p = Math.max(0, Math.min(1, (ev.clientX - r.left) / r.width));
      var pct = p * 100;
      fill.style.width = pct + '%';
      knob.style.left = pct + '%';
      var v = Math.round(c.min + p * (c.max - c.min));
      if (bubble) bubble.textContent = v;
      if (v !== last) {
        last = v;
        c.value = v;
        if (valEl) valEl.textContent = ctlValText(c);
        post('change', { name: c.name, value: v });
      }
    }
    move(e);
    function up() {
      wrap.classList.remove('dragging');
      document.removeEventListener('mousemove', move);
      document.removeEventListener('mouseup', up);
    }
    document.addEventListener('mousemove', move);
    document.addEventListener('mouseup', up);
  });

  // stepper: direct DOM update (no full re-render), with hold-to-repeat + numeric input
  function applyStep(c, v, stepperEl, skipInput) {
    c.value = v;
    var input = stepperEl.querySelector('.step-input');
    var fillEl = stepperEl.querySelector('.step-fill');
    var knobEl = stepperEl.querySelector('.step-knob');
    var pct = (c.max > c.min ? ((v - c.min) / (c.max - c.min)) * 100 : 0);
    if (input && !skipInput) input.value = v;
    if (fillEl) fillEl.style.width = pct + '%';
    if (knobEl) knobEl.style.left = pct + '%';
    var ctl = stepperEl.closest('.ctl');
    var valEl = ctl ? ctl.querySelector('.ctl-val') : null;
    if (valEl) valEl.textContent = ctlValText(c);
    post('change', { name: c.name, value: v });
  }
  function stepLive(c, delta, stepperEl) {
    var v = c.value + delta;
    if (v < c.min) v = c.max;
    if (v > c.max) v = c.min;
    applyStep(c, v, stepperEl);
  }
  function commitStep(input) {
    var st = input.closest('.stepper'); if (!st) return;
    var c = findCtl(st.getAttribute('data-name')); if (!c) return;
    var v = parseInt(input.value, 10);
    if (isNaN(v)) { input.value = c.value; return; }
    v = Math.max(c.min, Math.min(c.max, v));
    if (v !== c.value) applyStep(c, v, st);
    else input.value = v;
  }
  document.addEventListener('focusin', function (e) { if (e.target.classList && e.target.classList.contains('step-input')) e.target.select(); });
  document.addEventListener('keydown', function (e) { if (e.target.classList && e.target.classList.contains('step-input') && (e.key === 'Enter' || e.which === 13)) e.target.blur(); });
  document.addEventListener('focusout', function (e) { if (e.target.classList && e.target.classList.contains('step-input')) commitStep(e.target); });
  document.addEventListener('input', function (e) {
    var t = e.target;
    if (!t.classList || !t.classList.contains('step-input')) return;
    var st = t.closest('.stepper'); if (!st) return;
    var c = findCtl(st.getAttribute('data-name')); if (!c) return;
    if (t.value === '' || t.value === '-') return;
    var v = parseInt(t.value, 10);
    if (isNaN(v)) return;
    v = Math.max(c.min, Math.min(c.max, v));
    if (v !== c.value) applyStep(c, v, st, true);
  });

  document.addEventListener('mousedown', function (e) {
    var arrow = e.target.closest ? e.target.closest('.step-arrow') : null;
    if (!arrow) return;
    e.preventDefault();
    var st = arrow.closest('.stepper');
    var c = findCtl(st.getAttribute('data-name'));
    if (!c) return;
    var dir = parseInt(arrow.getAttribute('data-dir'));
    arrow.classList.add('held');
    stepLive(c, dir, st);
    var holdInterval = null;
    var holdTimer = setTimeout(function () {
      holdInterval = setInterval(function () { stepLive(c, dir, st); }, 130);
    }, 350);
    function stop() {
      clearTimeout(holdTimer);
      if (holdInterval) clearInterval(holdInterval);
      arrow.classList.remove('held');
      document.removeEventListener('mouseup', stop);
      arrow.removeEventListener('mouseleave', stop);
    }
    document.addEventListener('mouseup', stop);
    arrow.addEventListener('mouseleave', stop);
  });

  // stepper bar drag (slider-like, same feel as opacity)
  document.addEventListener('mousedown', function (e) {
    if (!e.target.closest) return;
    if (e.target.closest('.step-arrow') || e.target.closest('.step-input')) return;
    var track = e.target.closest('.step-track'); if (!track) return;
    var st = track.closest('.stepper'); if (!st) return;
    var c = findCtl(st.getAttribute('data-name')); if (!c) return;
    var bar = st.querySelector('.step-bar'); if (!bar) return;
    e.preventDefault();
    st.classList.add('dragging');
    function move(ev) {
      var r = bar.getBoundingClientRect();
      var p = Math.max(0, Math.min(1, (ev.clientX - r.left) / r.width));
      var v = Math.round(c.min + p * (c.max - c.min));
      if (v !== c.value) applyStep(c, v, st);
    }
    move(e);
    function up() { st.classList.remove('dragging'); document.removeEventListener('mousemove', move); document.removeEventListener('mouseup', up); }
    document.addEventListener('mousemove', move);
    document.addEventListener('mouseup', up);
  });

  el('btnBuy').addEventListener('click', function () { post('buy', {}); });
  el('btnCancel').addEventListener('click', function () { close(); post('cancel', {}); });
  document.addEventListener('keyup', function (e) { if (e.key === 'Escape' || e.which === 27) { close(); post('cancel', {}); } });

  function open(data) {
    state.sections = data.sections || [];
    state.active = 0;
    state.price = data.price || 0;
    state.palette = data.palette || null;
    el('brandMark').innerHTML = svg('scissors');
    if (data.acc) applyAccent(data.acc);
    el('actionPrice').textContent = '$' + (state.price || 0).toLocaleString();
    renderRail();
    renderPanel();
    el('barber').classList.remove('hidden');
  }
  function close() { el('barber').classList.add('hidden'); }

  function updateControl(d) {
    var c = findCtl(d.name); if (!c) return;
    if (d.max !== undefined) c.max = d.max;
    if (d.min !== undefined) c.min = d.min;
    if (d.value !== undefined) c.value = d.value;
    var ctlEl = document.querySelector('.ctl[data-name="' + d.name + '"]');
    if (!ctlEl) return;
    var st = ctlEl.querySelector('.stepper');
    if (st) {
      var pct = (c.max > c.min ? ((c.value - c.min) / (c.max - c.min)) * 100 : 0);
      var inp = st.querySelector('.step-input'); if (inp) inp.value = c.value;
      var fill = st.querySelector('.step-fill'); if (fill) fill.style.width = pct + '%';
      var knob = st.querySelector('.step-knob'); if (knob) knob.style.left = pct + '%';
    }
    var valEl = ctlEl.querySelector('.ctl-val'); if (valEl) valEl.textContent = ctlValText(c);
  }

  window.addEventListener('message', function (ev) {
    var d = ev.data || {};
    if (d.action === 'open') open(d);
    else if (d.action === 'close') close();
    else if (d.action === 'setColor') applyAccent(d.acc);
    else if (d.action === 'updateControl') updateControl(d);
    else if (d.action === 'price') { state.price = d.price; el('actionPrice').textContent = '$' + (d.price || 0).toLocaleString(); }
  });

  // browser preview mock
  if (!inGame) {
    open({
      acc: '#ff4d79', price: 7500,
      sections: [
        { key: 'hair', label: 'Hair', icon: 'hair', controls: [
          { name: 'hair_1', label: 'Style', type: 'stepper', value: 12, min: 0, max: 73 },
          { name: 'hair_2', label: 'Texture', type: 'stepper', value: 1, min: 0, max: 3 },
          { name: 'hair_color_1', label: 'Color', type: 'color', value: 5, min: 0, max: 63 },
          { name: 'hair_color_2', label: 'Highlight', type: 'color', value: 0, min: 0, max: 63 } ] },
        { key: 'beard', label: 'Beard', icon: 'beard', controls: [
          { name: 'beard_1', label: 'Style', type: 'stepper', value: 3, min: 0, max: 28 },
          { name: 'beard_2', label: 'Opacity', type: 'range', value: 8, min: 0, max: 10 },
          { name: 'beard_3', label: 'Color', type: 'color', value: 2, min: 0, max: 63 } ] },
        { key: 'eyebrows', label: 'Brows', icon: 'eyebrows', controls: [
          { name: 'eyebrows_1', label: 'Style', type: 'stepper', value: 4, min: 0, max: 33 },
          { name: 'eyebrows_2', label: 'Opacity', type: 'range', value: 10, min: 0, max: 10 },
          { name: 'eyebrows_3', label: 'Color', type: 'color', value: 1, min: 0, max: 63 } ] },
        { key: 'makeup', label: 'Make-up', icon: 'makeup', controls: [
          { name: 'makeup_1', label: 'Style', type: 'stepper', value: 0, min: 0, max: 74 },
          { name: 'makeup_2', label: 'Opacity', type: 'range', value: 6, min: 0, max: 10 },
          { name: 'makeup_3', label: 'Color', type: 'color', value: 9, min: 0, max: 63 } ] },
        { key: 'lipstick', label: 'Lips', icon: 'lipstick', controls: [
          { name: 'lipstick_1', label: 'Style', type: 'stepper', value: 0, min: 0, max: 9 },
          { name: 'lipstick_2', label: 'Opacity', type: 'range', value: 7, min: 0, max: 10 },
          { name: 'lipstick_3', label: 'Color', type: 'color', value: 30, min: 0, max: 63 } ] }
      ]
    });
  }
})();
