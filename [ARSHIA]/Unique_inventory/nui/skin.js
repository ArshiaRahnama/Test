/* UNIQUE Inventory — UI layer (v2.1)
   Rarity, icon fallback, player badge + ped headshot, Clothing / Settings
   pages, Delete flow and keyboard shortcuts. Wrapped so a failure here can
   never break the inventory itself. */
(function () {
  'use strict'
  var $ = window.jQuery
  if (!$) return

  /* ------------------------------------------------------------ helpers */
  var DEF = { opacity: 62, dim: 18, scale: 95, volume: 100, weights: true, rarity: true, confirmDelete: true,
    badge: true, allowGive: true, instant: true, sounds: true, streamer: false, background: true, blur: false, info: true, names: true }
  var S = {}
  function loadSettings() {
    var saved = {}
    try { saved = JSON.parse(localStorage.getItem('uq_settings2') || '{}') } catch (e) {}
    S = $.extend({}, DEF, saved)
    S.scale = Math.max(70, Math.min(95, Number(S.scale) || 95))
  }
  function sendPrefs() { post('setPrefs', { allowGive: !!S.allowGive, blur: !!S.blur }) }
  function saveSettings() { try { localStorage.setItem('uq_settings2', JSON.stringify(S)) } catch (e) {} }
  function applySettings() {
    var r = document.documentElement.style
    r.setProperty('--panel-a', (S.opacity / 100).toFixed(2))
    r.setProperty('--dim-a', (S.background ? S.dim / 100 : 0).toFixed(2))
    r.setProperty('--uscale', (S.scale / 100).toFixed(2))
    $('#menu-principal').toggleClass('no-weight', !S.weights).toggleClass('no-rarity', !S.rarity)
      .toggleClass('no-bg', !S.background).toggleClass('no-badge', !S.badge)
      .toggleClass('no-info', !S.info).toggleClass('no-names', !S.names)
    window.UQ_VOLUME = S.sounds ? S.volume / 100 : 0
  }
  function post(name, data, cb) {
    try { $.post('http://Unique_inventory/' + name, JSON.stringify(data || {}), cb) } catch (e) {}
  }
  function esc(t) { return $('<div>').text(t == null ? '' : String(t)).html() }
  var ICONS = {
    gun: '<svg viewBox="0 0 24 24"><path d="M3 9h13l2 2h3v3h-6l-1 3H9l1-3H6a3 3 0 0 1-3-3z"/></svg>',
    key: '<svg viewBox="0 0 24 24"><circle cx="8" cy="12" r="4"/><path d="M12 12h9M18 12v3M21 12v2"/></svg>',
    cash: '<svg viewBox="0 0 24 24"><rect x="3" y="6" width="18" height="12" rx="2"/><circle cx="12" cy="12" r="2.5"/></svg>',
    food: '<svg viewBox="0 0 24 24"><path d="M12 7c-3-2-7 0-7 5 0 4 3 8 5 8 1 0 1-.6 2-.6s1 .6 2 .6c2 0 5-4 5-8 0-5-4-7-7-5zM12 7c0-2 1-3 3-4"/></svg>',
    cube: '<svg viewBox="0 0 24 24"><path d="M12 3l8 4.5v9L12 21l-8-4.5v-9zM12 12l8-4.5M12 12v9M12 12L4 7.5"/></svg>'
  }

  /* ------------------------------------------------------------ rarity + icons */
  function rarityOf(el) {
    var type = el.getAttribute('data-item-type') || ''
    var key = (el.getAttribute('data-item-key') || '').toLowerCase()
    var f = ((el.querySelector('.typeFilter') || {}).textContent || '').trim()
    if (/weapon_(rpg|minigun|railgun|widowmaker|emplauncher|grenadelauncher|hominglauncher|heavysniper|sniperrifle|marksmanrifle|combatmg|mg|compactlauncher|firework)/.test(key)) return 'legendary'
    if (type === 'item_weapon' || key.indexOf('weapon_') === 0) return /pistol|knife|nightstick|bat|flashlight|hammer|crowbar|stungun|flaregun/.test(key) ? 'rare' : 'epic'
    if (/black_money|gold|diamond|bitcoin|goldbar|ruby/.test(key)) return 'legendary'
    if (/armor|armour|ammo|kevlar/.test(key) || f === 'arma') return 'rare'
    if (f === 'food' || f === 'soda') return 'uncommon'
    return 'common'
  }
  var imgState = {}, keep = {}
  function glyphFor(el) {
    var key = (el.getAttribute('data-item-key') || '').toLowerCase()
    var type = el.getAttribute('data-item-type') || ''
    var f = ((el.querySelector('.typeFilter') || {}).textContent || '').trim()
    if (type === 'item_weapon' || key.indexOf('weapon_') === 0) return ICONS.gun
    if (/key/.test(key)) return ICONS.key
    if (/cash|money|bank|coin/.test(key) || type === 'item_money' || type === 'item_account') return ICONS.cash
    if (f === 'food' || f === 'soda') return ICONS.food
    return ICONS.cube
  }
  function showGlyph(el) {
    if (el.querySelector('.uq-glyph')) return
    el.classList.add('no-icon')
    var g = document.createElement('i')
    g.className = 'uq-glyph'
    g.innerHTML = glyphFor(el)
    el.insertBefore(g, el.firstChild)
  }
  var missing = {}, missTimer = null
  function reportMissing(url) {
    var n = decodeURIComponent(url.split('/').pop().replace(/\.png.*$/i, ''))
    if (missing[n]) return
    missing[n] = 1
    clearTimeout(missTimer)
    missTimer = setTimeout(function () { post('iconMissing', { names: Object.keys(missing) }) }, 1500)
  }
  // other spellings of the same file: weapon_pistol / WEAPON_PISTOL / Weapon_Pistol, with or without WEAPON_
  function variants(url) {
    var i = url.lastIndexOf('/'), dir = url.slice(0, i + 1), f = url.slice(i + 1).replace(/\.png.*$/i, '')
    var out = [f.toLowerCase(), f.toUpperCase(), f.replace(/^weapon_/i, '').toLowerCase(), 'weapon_' + f.replace(/^weapon_/i, '').toLowerCase(),
      f.replace(/^weapon_/i, '').toUpperCase(), 'WEAPON_' + f.replace(/^weapon_/i, '').toUpperCase()]
    var seen = {}; seen[f] = 1
    return out.filter(function (v) { if (seen[v]) return false; seen[v] = 1; return true }).map(function (v) { return dir + v + '.png' })
  }
  function setBg(el, u) { el.style.backgroundImage = "url('" + u + "')" }
  function checkIcon(el) {
    var bg = el.style.backgroundImage || ''
    var m = bg.match(/url\(["']?(.*?)["']?\)/)
    if (!m) return showGlyph(el)
    var url = m[1]
    var st = imgState[url]
    if (st === true) return
    if (typeof st === 'string') return setBg(el, st)
    if (st === false) return showGlyph(el)
    if (st && st.push) return st.push(el)
    imgState[url] = [el]
    var cands = variants(url), n = 0
    function finish(ok, u) {
      var l = imgState[url]
      imgState[url] = ok ? (u === url ? true : u) : false
      if (!ok) {
        reportMissing(url)
        // a failure may be a transient load race: forget it after 8s so a valid image is not hidden for good
        setTimeout(function () { if (imgState[url] === false) delete imgState[url] }, 8000)
      }
      if (!l || !l.length) return
      for (var i = 0; i < l.length; i++) {
        if (!document.body.contains(l[i])) continue
        if (ok) {
          if (u !== url) setBg(l[i], u)
          var g = l[i].querySelector('.uq-glyph'); if (g) { g.remove(); l[i].classList.remove('no-icon') }
        } else showGlyph(l[i])
      }
    }
    function load(u) {
      var im = new Image()
      keep[u] = im
      im.onload = function () { finish(true, u) }
      im.onerror = function () { if (n < cands.length) load(cands[n++]); else finish(false) }
      im.src = u
    }
    load(url)
  }
  function decorate() {
    var list = document.querySelectorAll('.item-player')
    for (var i = 0; i < list.length; i++) {
      var el = list[i]
      var sg = (el.getAttribute('data-item-key') || '') + '|' + (el.getAttribute('data-item-type') || '') + '|' + (el.style.backgroundImage || '')
      if (el.getAttribute('data-sg') === sg) {
        // the app may wipe children when it refreshes a node in place: re-draw the glyph if it is needed
        if (!el.querySelector('.uq-glyph')) {
          var bgm = (el.style.backgroundImage || '').match(/url\(["']?(.*?)["']?\)/)
          if (!bgm || imgState[bgm[1]] === false) showGlyph(el)
          else if (typeof imgState[bgm[1]] === 'string') setBg(el, imgState[bgm[1]])
        }
        continue
      }
      el.setAttribute('data-sg', sg)
      // the app re-uses nodes in place: drop anything we drew for the previous item
      var g = el.querySelector('.uq-glyph'); if (g) g.remove()
      el.classList.remove('no-icon')
      el.setAttribute('data-r', rarityOf(el))
      try { checkIcon(el) } catch (e) {}
    }
  }

  /* ------------------------------------------------------------ personal slot layout */
  var LAY = {}, layKey = ''
  function layStore() { return 'uq_layout_' + (layKey || 'default') }
  function layLoad() { try { LAY = JSON.parse(localStorage.getItem(layStore()) || '{}') } catch (e) { LAY = {} } }
  function laySave() { try { localStorage.setItem(layStore(), JSON.stringify(LAY)) } catch (e) {} }
  function baseKey(el) { return (el.getAttribute('data-item-key') || '') + (el.getAttribute('data-item-serial') ? '#' + el.getAttribute('data-item-serial') : '') + '@' + (el.getAttribute('data-item-name') || '') }
  function itemKey(el) { return el.__k || baseKey(el) }
  // identical items (25 vehicle keys, 4 EMP launchers) get an occurrence index so each keeps its own slot
  function assignKeys(items) {
    var seen = {}
    items.slice().sort(function (a, b) { return Number(a.getAttribute('data-item-antigo')) - Number(b.getAttribute('data-item-antigo')) })
      .forEach(function (e) { var b = baseKey(e); seen[b] = (seen[b] || 0) + 1; e.__k = seen[b] > 1 ? b + '~' + seen[b] : b })
  }
  function slotOf(el) { var s = el.parentNode && el.parentNode.getAttribute && el.parentNode.getAttribute('data-slotNovo'); return s == null ? -1 : Number(s) }
  function slotEl(n) { return document.querySelector('#box-menu-item .slot[data-slotNovo="' + n + '"]') }
  function put(el, n) {
    var tgt = slotEl(n); if (!tgt) return
    var from = el.parentNode
    tgt.appendChild(el)
    tgt.setAttribute('data-temItem', 'true')
    if (from && from !== tgt && !from.querySelector('.item-player')) from.setAttribute('data-temItem', 'false')
  }
  function applyLayout() {
    var box = document.getElementById('box-menu-item'); if (!box) return
    var items = [].slice.call(box.querySelectorAll('.item-player.inventory'))
    items.forEach(function (e) { if (!e.__k) e.__k = null })
    assignKeys(items)
    if (!items.length || items.every(function (e) { return e.getAttribute('data-lay') === itemKey(e) })) return
    var total = box.querySelectorAll('.slot').length
    var want = {}, taken = {}, free = []
    items.forEach(function (e) {
      var k = itemKey(e), s = LAY[k]
      if (s != null && s < total && !taken[s]) { want[k] = s; taken[s] = true }
    })
    items.forEach(function (e) {
      var k = itemKey(e)
      if (want[k] == null) {
        var cur = slotOf(e)
        if (cur >= 0 && !taken[cur]) { want[k] = cur; taken[cur] = true }
        else free.push(e)
      }
    })
    free.forEach(function (e) {
      for (var n = 0; n < total; n++) if (!taken[n]) { want[itemKey(e)] = n; taken[n] = true; break }
    })
    items.forEach(function (e) { e.parentNode && e.parentNode.removeChild(e) })
    items.forEach(function (e) { put(e, want[itemKey(e)]); e.setAttribute('data-lay', itemKey(e)) })
    // remember every position so new / equipped / removed items never shuffle the rest
    var changed = false
    items.forEach(function (e) { var k = itemKey(e), n = slotOf(e); if (LAY[k] !== n) { LAY[k] = n; changed = true } })
    if (changed) laySave()
  }
  function recordMove(d) {
    var el = document.querySelector('#box-menu-item .item-player.inventory[data-item-antigo="' + d.oldSlot + '"]')
    if (!el) return
    var from = slotOf(el), to = Number(d.newSlot)
    var other = slotEl(to) && slotEl(to).querySelector('.item-player')
    var k = itemKey(el)
    LAY[k] = to
    if (other && other !== el) { LAY[itemKey(other)] = from; put(other, from) }
    put(el, to)
    laySave()
  }
  // observe app.js's own "moverItem" call so the move is remembered per character
  var _post = $.post
  $.post = function (url) {
    try {
      if (typeof url === 'string' && /\/(droparItem|deletarItem)$/.test(url) && arguments[1]) {
        var q = typeof arguments[1] === 'string' ? JSON.parse(arguments[1]) : arguments[1]
        var el = q.slot != null && document.querySelector('.item-player.inventory[data-item-antigo="' + q.slot + '"]')
        var ty = (q.type) || (el && el.getAttribute('data-item-type')) || ''
        if (ty === 'item_keyhouse' && /droparItem/.test(url)) {
          toast('House keys cannot be dropped')
          return $.Deferred().resolve().promise()
        }
      }
      if (typeof url === 'string' && /\/moverItem$/.test(url) && arguments[1]) {
        var d = typeof arguments[1] === 'string' ? JSON.parse(arguments[1]) : arguments[1]
        setTimeout(function () { recordMove(d) }, 30)
      }
    } catch (e) {}
    return _post.apply(this, arguments)
  }

  /* ------------------------------------------------------------ player data + headshot */
  var P = { name: '', id: '', phone: '', job: '', gang: '', hs: null }
  function readIdentity() {
    var rows = document.querySelectorAll('.identidade-js .itens-identity')
    if (!rows.length) return
    var vals = []
    for (var i = 0; i < rows.length; i++) {
      var v = rows[i].querySelector('.segundo')
      vals.push({ cls: rows[i].className, t: v ? v.textContent.trim() : '' })
    }
    if (vals[0]) P.name = vals[0].t
    if (vals[1]) P.id = vals[1].t
    if (vals[2]) P.phone = vals[2].t
    for (var j = 0; j < vals.length; j++) {
      if (vals[j].cls.indexOf('job-row') > -1) P.job = vals[j].t
      if (vals[j].cls.indexOf('gang-row') > -1) P.gang = vals[j].t
    }
  }
  function initials() {
    var p = (P.name || '?').split(/\s+/)
    return ((p[0] || '?')[0] + (p[1] ? p[1][0] : '')).toUpperCase()
  }
  function avatarHtml() {
    if (P.hs) return '<img alt="" src="' + P.hs + '" onerror="this.parentNode.classList.add(\'noimg\');this.remove()">'
    return ''
  }
  function fetchHeadshot(tries) {
    post('getHeadshot', {}, function (r) {
      if (r && r.txd) {
        P.hs = 'https://nui-img/' + r.txd + '/' + r.txd
        paintPeople()
      } else if (tries > 0) setTimeout(function () { fetchHeadshot(tries - 1) }, 400)
    })
  }

  function hide(t, keep) { return S.streamer ? (keep ? t.replace(/./g, function (c, i) { return i < keep ? c : '•' }) : '••••') : t }
  function peopleCard(big) {
    return '<div class="uq-hs' + (P.hs ? '' : ' noimg') + '" data-ini="' + esc(initials()) + '">' + avatarHtml() + '</div>' +
      '<div class="uq-who"><b>' + esc(hide(P.name || 'Citizen', 1)) + '</b><span>ID ' + esc(hide(String(P.id || '-'))) + (P.phone ? ' · ' + esc(hide(P.phone)) : '') + '</span></div>' +
      '<div class="uq-chip"><i>Job</i><b>' + esc(hide(P.job || 'Unemployed')) + '</b></div>' +
      '<div class="uq-chip"><i>Gang</i><b>' + esc(hide(P.gang || 'None')) + '</b></div>'
  }
  function paintPeople() {
    $('#uq-badge').html(peopleCard(false))
    $('#uq-clothing-card').html(peopleCard(true))
  }

  /* ------------------------------------------------------------ selection + actions */
  var current = null, hovered = null
  function target() {
    if (hovered && document.body.contains(hovered[0])) return hovered
    if (current && document.body.contains(current[0])) return current
    return null
  }
  var toastT
  function toast(msg) {
    var t = $('#uq-toast').text(msg).addClass('on')
    clearTimeout(toastT)
    toastT = setTimeout(function () { t.removeClass('on') }, 1600)
  }
  function runAction(cls) {
    var $it = target()
    if (!$it || !$it.hasClass('inventory')) return toast('Select an item first')
    var $a = $('.action.' + cls)
    try { $a.droppable('option', 'drop').call($a[0], {}, { draggable: $it }) } catch (e) {}
  }
  function amountFor($it) {
    var total = Number($it.attr('data-item-amount')) || 1
    if ($it.attr('data-item-type') === 'item_weapon') return 1
    var n
    if (window.tudo === true) n = total
    else if (window.metade === true) n = Math.floor(total / 2) || 1
    else n = parseInt(($('#quantidade').val() || '').trim(), 10) || 1
    return Math.max(1, Math.min(total, n))
  }
  function confirmDialog(text, ok) {
    var d = $('#uq-confirm')
    d.find('p').text(text)
    d.addClass('on')
    d.find('.yes').off('click').on('click', function () { d.removeClass('on'); ok() })
    d.find('.no').off('click').on('click', function () { d.removeClass('on') })
  }
  window.uqDelete = function ($it) {
    if (!$it || !$it.length) return
    var n = amountFor($it)
    var label = $it.attr('data-item-name') || $it.attr('data-item-key')
    var go = function () {
      post('deletarItem', {
        item: $it.attr('data-item-key'), amount: n, type: $it.attr('data-item-type'),
        slot: $it.attr('data-item-antigo'), serial: $it.attr('data-item-serial') || '', label: $it.attr('data-item-name') || ''
      })
      current = null
    }
    if (S.confirmDelete) confirmDialog('Delete ' + n + 'x ' + label + '? This cannot be undone.', go)
    else go()
  }

  /* ------------------------------------------------------------ views */
  // [key, label, icon, hasActiveIcon]
  var CL = [
    ['hat', 'Hat', 'helmet', 1], ['glasses', 'Glasses', 'glasses', 1], ['mask', 'Mask', 'mask', 1], ['ears', 'Ears', 'ears', 1],
    ['chain', 'Chain', 'chain', 1], ['watch', 'Watch', 'watches', 1], ['bracelet', 'Bracelet', 'bracelets', 1],
    ['torso', 'Jacket', 'torso', 1], ['tshirt', 'Shirt', 'tshirt', 1], ['arms', 'Arms', 'arms', 1],
    ['pants', 'Pants', 'pants', 1], ['shoes', 'Shoes', 'shoes', 1], ['vest', 'Vest', 'bproof', 1], ['bag', 'Bag', 'bag', 1]
  ]
  var cloth = {}
  function clBtn(c) {
    var on = !!cloth[c[0]]
    var img = 'clothes/' + c[2] + (on && c[3] ? '_active' : '') + '.png'
    return '<button class="uq-ic' + (on ? ' on' : '') + '" data-slot="' + c[0] + '" title="' + c[1] + '"><img alt="" src="' + img + '"><span>' + c[1] + '</span></button>'
  }
  var GROUPS = [
    ['Head', ['hat', 'glasses', 'mask', 'ears']],
    ['Upper body', ['chain', 'torso', 'tshirt', 'arms', 'vest', 'bag']],
    ['Wrists & legs', ['watch', 'bracelet', 'pants', 'shoes']]
  ]
  function clBy(k) { for (var i = 0; i < CL.length; i++) if (CL[i][0] === k) return CL[i] }
  function paintClothing() {
    var worn = 0
    CL.forEach(function (c) { if (cloth[c[0]]) worn++ })
    var pct = Math.round(worn / CL.length * 100)
    var h = '<div class="uq-cl-sum"><div><b>' + worn + '</b><i>/ ' + CL.length + ' worn</i></div>' +
      '<div class="bar"><u style="width:' + pct + '%"></u></div></div>'
    GROUPS.forEach(function (g) {
      h += '<div class="uq-cl-g"><em>' + g[0] + '</em><div class="row" style="--n:' + g[1].length + '">' + g[1].map(function (k) { return clBtn(clBy(k)) }).join('') + '</div></div>'
    })
    h += '<button class="uq-cl-reset"><img alt="" src="clothes/reset.png"><span>Reset outfit</span></button>'
    $('#uq-cl-grid').html(h)
  }
  function refreshClothing() {
    post('getClothingState', {}, function (r) {
      if (r) { cloth = r; paintClothing() }
    })
  }
  var view = 'inventory'
  function setView(v) {
    view = v
    $('#menu-principal').attr('data-view', v)
    if (v !== 'inventory') $('.descricao-menu').hide()
    $('.uq-tab').removeClass('on').filter('[data-view="' + v + '"]').addClass('on')
    $('#view-clothing').toggle(v === 'clothing')
    $('#view-settings').toggle(v === 'settings')
    if (v === 'clothing') refreshClothing()
  }

  var ROWS = [
    ['opacity', 'Panel opacity', 25, 90, '%'],
    ['dim', 'Background dim', 0, 60, '%'],
    ['scale', 'UI scale', 70, 95, '%'],
    ['volume', 'Sound volume', 0, 100, '%']
  ]
  var SW = [
    ['badge', 'Show self badge'], ['allowGive', 'Other players can give'], ['instant', 'Instant use (double click)'],
    ['sounds', 'Sounds'], ['streamer', 'Streamer mode'], ['background', 'Background'],
    ['blur', 'Blur'], ['info', 'Show info (amount / weight)'], ['names', 'Item names'],
    ['weights', 'Show item weights'], ['rarity', 'Rarity colors'], ['confirmDelete', 'Confirm before delete']
  ]
  function buildSettings() {
    var h = '<div class="uq-card-h"><b>Settings</b><span>Saved on this device</span></div><div class="uq-grid">'
    ROWS.forEach(function (r) {
      h += '<div class="uq-set"><label>' + r[1] + '</label><input type="range" data-k="' + r[0] + '" min="' + r[2] + '" max="' + r[3] +
        '" value="' + S[r[0]] + '"><output>' + S[r[0]] + r[4] + '</output></div>'
    })
    SW.forEach(function (r) {
      h += '<div class="uq-set tg' + (S[r[0]] ? ' on' : '') + '" data-k="' + r[0] + '"><label>' + r[1] + '</label><i class="sw"></i></div>'
    })
    h += '</div><div class="uq-btns"><button class="uq-reset">Reset</button><button class="uq-back">Back to inventory</button></div>'
    $('#view-settings .uq-panel').html(h)
  }

  /* ------------------------------------------------------------ boot */
  function build() {
    var stage = document.querySelector('.background-color')
    var top = document.querySelector('.inventory-title-menu')
    if (!stage || !top) return false

    $(top).append(
      '<div class="uq-tabs">' +
      '<button class="uq-tab on" data-view="inventory">Inventory</button>' +
      '<button class="uq-tab" data-view="clothing">Clothing</button>' +
      '<button class="uq-tab" data-view="settings">Settings</button></div>')

    $(stage).append(
      '<div id="uq-badge"></div>' +
      '<div id="view-clothing" class="uq-view" style="display:none">' +
        '<div class="uq-panel uq-cl-panel"><div class="uq-card-h"><b>Clothing</b><span>Tap to take off / put on</span></div><div id="uq-cl-grid"></div></div>' +
      '</div>' +
      '<div id="view-settings" class="uq-view" style="display:none"><div class="uq-panel mid"></div></div>' +
      '<div id="uq-confirm"><div class="box"><p></p><div><button class="no">Cancel</button><button class="yes">Delete</button></div></div></div>' +
      '<div id="uq-toast"></div>')

    buildSettings()
    paintPeople()

    $(document)
      .on('click', '.uq-tab', function () { setView($(this).attr('data-view')) })
      .on('click', '.uq-back', function () { setView('inventory') })
      .on('click', '.uq-cl-reset', function () {
        post('resetClothing', {}, function (r) { if (r && r.ok) { delete r.ok; cloth = r; paintClothing() } else refreshClothing() })
      })
      .on('click', '.uq-reset', function () { S = $.extend({}, DEF); saveSettings(); applySettings(); buildSettings(); sendPrefs(); paintPeople() })
      .on('input', '.uq-set input[type=range]', function () {
        var k = this.getAttribute('data-k'); S[k] = Number(this.value)
        $(this).next('output').text(this.value + '%'); applySettings(); saveSettings()
      })
      .on('click', '.uq-set.tg', function () {
        var k = this.getAttribute('data-k'); S[k] = !S[k]
        $(this).toggleClass('on', S[k]); applySettings(); saveSettings()
        if (k === 'allowGive' || k === 'blur') sendPrefs()
        if (k === 'streamer') paintPeople()
      })
      .on('click', '.uq-ic', function () {
        var slot = this.getAttribute('data-slot')
        post('toggleClothing', { slot: slot }, function (r) {
          if (r && r.ok) { delete r.ok; cloth = r; paintClothing() } else refreshClothing()
        })
      })
      .on('mouseover', '.item-player', function () {
        hovered = $(this)
        if (view !== 'inventory' || $(this).attr('data-item-type') !== 'item_weapon') $('.descricao-menu').hide()
      })
      .on('mouseout', '.item-player', function () { hovered = null })
      .on('click', '.item-player', function () {
        current = $(this)
        $('.item-player.uq-sel').removeClass('uq-sel')
        current.addClass('uq-sel')
      })
      .on('dblclick', '.item-player.inventory', function () { if (!S.instant) return; current = $(this); runAction('usar') })
      .on('click', '.action', function (e) {
        var c = this.className
        var which = c.indexOf('usar') > -1 ? 'usar' : c.indexOf('enviar') > -1 ? 'enviar' : c.indexOf('dropar') > -1 ? 'dropar' : c.indexOf('deletar') > -1 ? 'deletar' : null
        if (which) runAction(which)
      })
      .on('keydown', function (e) {
        if (view !== 'inventory') return
        if (!$('#menu-principal').is(':visible')) return
        var t = e.target && e.target.tagName
        if (t === 'INPUT' || t === 'TEXTAREA') return
        if ($('#uq-confirm').hasClass('on')) return
        if (e.key === 'e' || e.key === 'E') runAction('usar')
        else if (e.key === 'g' || e.key === 'G') runAction('dropar')
        else if (e.key === 'Delete') runAction('deletar')
      })

    return true
  }

  var wasOpen = false, dirty = true, mo = null, chestEl = null, busy = false
  function watch(main) {
    if (mo) return
    mo = new MutationObserver(function () {
      dirty = true
      // runs before the next paint, so a refreshed list never shows its un-laid-out / icon-less state
      if (busy) return
      busy = true
      try { applyLayout(); decorate() } catch (e) {}
      mo.takeRecords(); busy = false
    })
    mo.observe(main, { childList: true, subtree: true, attributes: true,
      attributeFilter: ['data-item-key', 'data-item-serial', 'data-item-type', 'data-slotNovo'] })
  }
  function tick() {
    var main = document.getElementById('menu-principal')
    if (!main) return
    watch(main)
    var open = main.style.display !== 'none' && getComputedStyle(main).display !== 'none'
    if (open && !wasOpen) {
      current = null; hovered = null
      setView('inventory')
      fetchHeadshot(8)
      sendPrefs()
      dirty = true
    }
    wasOpen = open
    if (!open) return
    chestEl = chestEl || document.querySelector('.person-menu-chest')
    var chest = !!chestEl && getComputedStyle(chestEl).display !== 'none'
    if (chest !== main.classList.contains('chest-mode')) main.classList.toggle('chest-mode', chest)
    if (!dirty) return
    dirty = false
    readIdentity()
    var key = [P.name, P.id, P.job, P.gang].join('|')
    if (key !== tick.last) { tick.last = key; paintPeople() }
    if (P.id && layKey !== String(P.id)) { layKey = String(P.id); layLoad() }
    applyLayout()
    decorate()
    if (current && !document.body.contains(current[0])) { current = null; $('.item-player.uq-sel').removeClass('uq-sel') }
  }

  function boot() {
    try {
      loadSettings(); applySettings()
      if (!build()) return
      setInterval(function () { try { tick() } catch (e) {} }, 300)
    } catch (e) {}
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot)
  else boot()
})()
