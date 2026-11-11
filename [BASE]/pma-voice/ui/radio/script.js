(function () {
  'use strict';
  var RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'pma-voice';
  var $ = function (id) { return document.getElementById(id); };
  var access = {}, min = 1, max = 2500;

  function post(name, data) {
    fetch('https://' + RES + '/' + name, {
      method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data || {})
    }).catch(function () {});
  }

  function renderList(m) {
    var box = $('ur-list');
    box.textContent = '';
    if (m.visible === false) return;
    (m.list || []).forEach(function (p) {
      var d = document.createElement('div');
      d.textContent = (m.showNames && p.name) ? '[' + p.id + '] ' + p.name : '[' + p.id + ']';
      if (p.talking) d.className = 'talking';
      box.appendChild(d);
    });
  }

  function play(name, vol) {
    var a = $(name === 'on' ? 'ur-on' : 'ur-off');
    if (!a) return;
    try { a.currentTime = 0; a.volume = Math.max(0, Math.min(1, Number(vol) || 0.3)); var p = a.play(); if (p && p.catch) p.catch(function () {}); } catch (e) {}
  }

  function closeMenu() { $('ur-menu').hidden = true; post('uniqueRadio:close'); }

  function loadFreq() {
    var f = parseInt($('ur-freq').value, 10);
    if (!(f >= min && f <= max)) { $('ur-hint').textContent = 'Range: ' + min + ' - ' + max; return null; }
    var rule = access[f];
    $('ur-names').value = rule ? Object.keys(rule).join(', ') : '';
    $('ur-hint').textContent = rule ? 'Frequency ' + f + ' is PRIVATE' : 'Frequency ' + f + ' is PUBLIC';
    return f;
  }

  function save(makePublic) {
    var f = parseInt($('ur-freq').value, 10);
    if (!(f >= min && f <= max)) { $('ur-hint').textContent = 'Range: ' + min + ' - ' + max; return; }
    var rule = null;
    if (!makePublic) {
      rule = {};
      $('ur-names').value.split(',').forEach(function (s) {
        s = s.trim();
        if (/^[\w-]{1,32}$/.test(s)) rule[s] = true;
      });
    }
    post('uniqueRadio:setFreq', { freq: f, access: rule });
    if (makePublic) delete access[f]; else access[f] = rule;
    $('ur-hint').textContent = 'Saved.';
  }

  window.addEventListener('message', function (e) {
    var m = e.data;
    if (!m || m.uniqueRadio !== true) return;
    if (m.action === 'list') renderList(m);
    else if (m.action === 'sound') play(m.name, m.volume);
    else if (m.action === 'openMenu') {
      access = (m.access && typeof m.access === 'object') ? m.access : {};
      min = Number(m.min) || 1; max = Number(m.max) || 2500;
      $('ur-menu').hidden = false;
      $('ur-hint').textContent = '';
    }
  });

  $('ur-x').addEventListener('click', closeMenu);
  $('ur-load').addEventListener('click', loadFreq);
  $('ur-save').addEventListener('click', function () { save(false); });
  $('ur-reset').addEventListener('click', function () { save(true); });
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && !$('ur-menu').hidden) closeMenu(); });
})();
