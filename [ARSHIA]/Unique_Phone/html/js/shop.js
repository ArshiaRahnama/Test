/* ============================================================
   SHOP - loja de telemóveis em ecrã inteiro (ex-apex_phoneshop), 2026-10-03
   Showroom holográfico: o aparelho a flutuar no centro (js/shopviewer.js, three.js
   carregado só na primeira abertura), nome em letra grande à esquerda com a compra,
   telemetria das especificações à direita, cores em orbes por baixo do aparelho e a doca
   dos produtos em baixo. Categorias numa "barra de frequências" no topo.
   Abre pelo Lua: OverlayOpen('shop', 'shop:open', { shop, catalog, state, admin, centered })
   (client/shop.lua). Catálogo novo com a loja aberta: push 'shop:catalog' { catalog, shop }.
   Pedidos: Overlay.rpc('shop.buy', { item, account }) e Overlay.rpc('shop.refresh') (o
   client/shop.lua junta a loja aberta e vai ao servidor). Fora do FiveM: Overlay.mock.
   Comprar: manter premido ~0,8 s (o anel enche; largar cancela) ou Enter duas vezes.
   Teclas: ← → produto, ↑ ↓ cor, Enter comprar, ESC fechar (o Overlay avisa o Lua).
   O DOM constrói-se UMA vez (esqueleto) e uma vez por catálogo (doca, categorias); trocar
   de produto, cor ou categoria só muda textos e classes no sítio.
   Textos do config (slogan, destaques, cores, categorias, cargo e saudação do vendedor)
   são nós de texto normais: o tradutor do DOM (i18n.js) trata deles. Nomes de produtos,
   marcas, vendedores, lojas e valores vão em data-noi18n.
   API: window.Shop = { open(payload), close(), update(catalog, shop), state }
   ============================================================ */
(function () {
  'use strict';

  const HOLD_MS = 800, CONFIRM_MS = 4000, DONE_MS = 2600, MAX_FEATS = 8, MAX_ORBS = 8, MAX_SPECS = 6;
  const NNBSP = ' ', NBSP = ' ';
  const SPEC_ORDER = ['screen', 'camera', 'chip', 'battery', 'audio'];
  const SPEC_LABEL = { screen: 'Ecrã', camera: 'Câmara', chip: 'Processador', battery: 'Bateria', audio: 'Áudio', network: 'Rede', lines: 'Números' };
  const ACC_LABEL = { bank: 'Banco', cash: 'Dinheiro' };

  /* ícones (traço, 24×24) */
  const P = {
    x: '<path d="M6.5 6.5l11 11M17.5 6.5l-11 11"/>',
    bank: '<path d="M3.5 9.5L12 4.5l8.5 5"/><path d="M5.5 10.5v7M9.8 10.5v7M14.2 10.5v7M18.5 10.5v7"/><path d="M3.5 19.5h17"/>',
    cash: '<rect x="3" y="6.5" width="18" height="11" rx="2.2"/><circle cx="12" cy="12" r="2.5"/><path d="M6.5 9.6v.01M17.5 14.4v.01"/>',
    check: '<path d="M5 12.5l4.3 4.3L19 7.2"/>',
    bag: '<path d="M5.8 8.5h12.4l-.9 11.5H6.7z"/><path d="M9 8.5V7a3 3 0 016 0v1.5"/>',
    foldIn: '<rect x="4" y="5" width="7.5" height="14" rx="1.6"/><path d="M14.5 7.2l5-1.7v13l-5-1.7z"/>',
    foldOut: '<rect x="3" y="5" width="8.2" height="14" rx="1.6"/><rect x="12.8" y="5" width="8.2" height="14" rx="1.6"/>',
    caseOpen: '<path d="M5 11.5h14v4a4.5 4.5 0 01-4.5 4.5h-5A4.5 4.5 0 015 15.5z"/><path d="M5.2 9.2l12.6-4.8"/>',
    caseClose: '<path d="M5 9h14v6.5a4.5 4.5 0 01-4.5 4.5h-5A4.5 4.5 0 015 15.5z"/><path d="M5 12.2h14"/>',
    reset: '<path d="M4.8 12.5a7.3 7.3 0 107.2-8H8.5"/><path d="M10.6 2.2L8 4.5l2.6 2.4"/>',
    info: '<circle cx="12" cy="12" r="8.6"/><path d="M12 11v5.2M12 7.9v.01"/>',
    left: '<path d="M14.5 6l-6 6 6 6"/>',
    right: '<path d="M9.5 6l6 6-6 6"/>',
    grid: '<rect x="4.5" y="4.5" width="6" height="6" rx="1.4"/><rect x="13.5" y="4.5" width="6" height="6" rx="1.4"/><rect x="4.5" y="13.5" width="6" height="6" rx="1.4"/><rect x="13.5" y="13.5" width="6" height="6" rx="1.4"/>',
  };
  const ico = (k, cls) => `<svg class="xs-i${cls ? ' ' + cls : ''}" viewBox="0 0 24 24" aria-hidden="true">${P[k] || P.grid}</svg>`;

  const S = {
    built: false, open: false, closing: false, catalog: null, catKey: '', byId: {}, shop: {}, admin: false,
    state: { wallet: {}, owned: {}, available: {}, framework: true },
    cat: 'all', pid: null, vi: 0, account: null,
    busy: false, holdTimer: 0, confirmUntil: 0, confirmTimer: 0, doneUntil: 0, doneTimer: 0, errTimer: 0,
    noteMsg: null, glOk: null, glWant: false, loadSeq: 0, tintSlot: 0, tint: '', closeTimer: 0, enterTimer: 0, zoom: 1,
  };
  const R = {};          /* referências do DOM */
  let caps = {}, catBtns = {}, orbEls = [], featEls = [], specEls = [], payEls = {}, walletEls = {};

  /* ---------------------------------------------------------------- utilitários */
  const hexOk = c => /^#[0-9a-f]{6}$/i.test(String(c || ''));
  const rgbOf = c => { if (!hexOk(c)) return '200,202,208'; const n = parseInt(c.slice(1), 16); return `${n >> 16 & 255},${n >> 8 & 255},${n & 255}`; };
  const restart = (el, cls) => { el.classList.remove(cls); void el.offsetWidth; el.classList.add(cls); };
  /* abanão do botão de compra: a classe sai sozinha mesmo sem animationend (movimento reduzido) */
  const shake = () => { restart(R.hold, 'err'); clearTimeout(S.errTimer); S.errTimer = setTimeout(() => R.hold.classList.remove('err'), 600); };
  const VW = () => window.ShopViewer;

  function money(n) {
    n = Number(n) || 0;
    const neg = n < 0;
    n = Math.abs(n);
    const int = Math.floor(n);
    let s = String(int).replace(/\B(?=(\d{3})+(?!\d))/g, NNBSP);
    const cents = Math.round((n - int) * 100);
    if (cents > 0) s += ',' + String(cents).padStart(2, '0');
    /* números no formato do idioma do telemóvel ("1,499.50" em inglês); sem cêntimos fica inteiro, como antes */
    if (window.UI && UI.fmtNum) s = cents > 0 ? UI.fmtNum(n, 2, 2) : UI.fmtNum(int, 0, 0);
    const c = (S.catalog && S.catalog.currency) || (window.UI && UI.currency ? UI.currency() : {});
    const sym = c.symbol || (window.UI && UI.cur ? UI.cur() : '$');
    s = c.position === 'before' ? sym + s : s + NBSP + sym;
    return (neg ? '-' : '') + s;
  }

  /* silhueta do aparelho quando nem a imagem existe */
  function glyph(p, v) {
    const c = hexOk(v && v.swatch) ? v.swatch : '#3a3f4f';
    if (p && p.viewer && p.viewer.kind === 'buds') {
      return `<svg class="xs-glyph" viewBox="0 0 100 160"><circle cx="32" cy="58" r="21" fill="${c}" stroke="rgba(255,255,255,.25)"/><rect x="38" y="70" width="11" height="58" rx="5.5" fill="${c}" stroke="rgba(255,255,255,.25)"/><circle cx="68" cy="58" r="21" fill="${c}" stroke="rgba(255,255,255,.25)"/><rect x="51" y="70" width="11" height="58" rx="5.5" fill="${c}" stroke="rgba(255,255,255,.25)"/></svg>`;
    }
    return `<svg class="xs-glyph" viewBox="0 0 60 100"><rect x="4" y="3" width="52" height="94" rx="11" fill="${c}" stroke="rgba(255,255,255,.24)" stroke-width="1.2"/><rect x="10" y="9" width="18" height="18" rx="5.5" fill="rgba(0,0,0,.30)"/><circle cx="16" cy="15" r="3" fill="rgba(0,0,0,.45)"/><circle cx="23" cy="21" r="3" fill="rgba(0,0,0,.45)"/></svg>`;
  }

  /* imagem do produto: nui://Unique_Phone/inventory_images/x.png; se falhar (browser de testes) tenta o caminho
     relativo ../inventory_images/x.png e por fim a silhueta. holder fica com UM filho (img ou svg). */
  function setImage(holder, p, v) {
    const want = (v && v.image) || '';
    if (holder._src === want && holder._item === (v && v.item)) return;
    holder._src = want; holder._item = v && v.item;
    let img = holder.firstElementChild;
    if (!img || img.tagName !== 'IMG') { holder.textContent = ''; img = new Image(); img.alt = ''; img.decoding = 'async'; img.draggable = false; holder.appendChild(img); }
    const tries = [want];
    if (v && v.item) tries.push('../inventory_images/' + v.item + '.png');
    /* fora do FiveM o esquema nui:// nem existe: vai direto ao caminho relativo */
    if (!(window.Bridge && Bridge.inFiveM) && /^nui:\/\//.test(want)) tries[0] = want.replace(/^nui:\/\/[^/]+\//, '../');
    let k = 0;
    img.onerror = () => {
      k++;
      if (k < tries.length && tries[k] && tries[k] !== tries[k - 1]) { img.src = tries[k]; return; }
      img.onerror = null;
      holder.innerHTML = glyph(p, v);
    };
    img.src = tries[0] || tries[1] || '';
  }

  const owned = item => Math.max(0, Number(S.state.owned && S.state.owned[item]) || 0);
  const available = item => !(S.state.available && S.state.available[item] === false);
  const productOwned = p => p.variants.reduce((a, v) => a + owned(v.item), 0);
  const productAvailable = p => p.variants.some(v => available(v.item));
  const inCat = (p, cat) => cat === 'all' || (p.categories || []).indexOf(cat) >= 0;
  const curProduct = () => (S.pid && S.byId[S.pid]) || null;
  const curVariant = () => { const p = curProduct(); return p ? (p.variants[S.vi] || p.variants[0]) : null; };
  const accLabel = a => ACC_LABEL[a] || a;

  /* ---------------------------------------------------------------- esqueleto (uma vez) */
  function build() {
    if (S.built) return;
    S.built = true;
    const root = document.createElement('div');
    root.id = 'xs-root';
    root.className = 'xs-root';   /* 4 out: era 'xs', o mesmo nome do tamanho de avatar .avatar.xs (position:fixed nos avatares pequenos) */
    root.hidden = true;
    root.setAttribute('aria-hidden', 'true');
    root.innerHTML =
      '<div class="xs-bg"><div class="xs-bg-sky"></div><div class="xs-bg-glow a"></div><div class="xs-bg-glow b"></div><div class="xs-bg-stars"></div><div class="xs-bg-floor"></div><div class="xs-bg-horizon"></div><div class="xs-bg-vig"></div></div>' +
      '<div class="xs-stage"><div class="xs-pool"></div><div class="xs-fb-ring"></div><div class="xs-fb"><div class="xs-fb-pic"></div></div><div class="xs-load"><i></i></div></div>' +
      '<div class="xs-ui">' +
        '<header class="xs-top">' +
          /* cabecalho da loja: icone azul da Apex + nome da loja (sem vendedor nem saudacao, pedido do dono 3 out) */
          '<div class="xs-vendor xs-pe"><div class="xs-vd-av"><svg class="xs-i" viewBox="0 0 24 24"><rect x="6.5" y="2.5" width="11" height="19" rx="2.6"/><path d="M10.6 18.2h2.8"/></svg></div><div class="xs-vd-body">' +
            '<div class="xs-vd-head"><span class="xs-vd-name"></span></div>' +
            '<div class="xs-vd-shop" data-noi18n></div></div></div>' +
          '<nav class="xs-freq xs-pe"><div class="xs-freq-ticks"></div><div class="xs-freq-ind"></div></nav>' +
          '<div class="xs-right"><div class="xs-wallet"></div>' +
            `<button class="xs-close xs-pe" type="button" aria-label="Fechar" title="Fechar">${ico('x')}</button></div>` +
        '</header>' +
        '<section class="xs-id">' +
          '<div class="xs-eyebrow xs-mono"><span class="xs-brand" data-noi18n></span><i class="xs-sep"></i><span class="xs-os" data-noi18n></span><span class="xs-badge" hidden></span></div>' +
          '<h1 class="xs-name" data-noi18n></h1>' +
          '<p class="xs-tag"></p>' +
          '<ol class="xs-feats"></ol>' +
        '</section>' +
        '<section class="xs-buy xs-pe">' +
          '<div class="xs-price-row"><div><div class="xs-price-k xs-mono">Preço</div><div class="xs-price" data-noi18n></div></div>' +
            `<div class="xs-own" hidden>${ico('check')}<span>Já tens</span><span class="xs-own-n" data-noi18n></span></div></div>` +
          '<div class="xs-pay"><span class="xs-pay-ind"></span></div>' +
          '<button class="xs-hold" type="button"><span class="xs-hold-fill"></span>' +
            '<span class="xs-ring"><span class="xs-ring-track"></span><span class="xs-ring-h r"><span class="xs-ring-a"></span></span><span class="xs-ring-h l"><span class="xs-ring-b"></span></span>' +
              `<span class="xs-ring-ico">${ico('bag')}</span><span class="xs-ring-ok">${ico('check')}</span></span>` +
            '<span class="xs-hold-txt"><span class="xs-hold-label"></span><span class="xs-hold-sub xs-mono"></span></span>' +
            '<span class="xs-key xs-mono">Enter</span></button>' +
          '<div class="xs-note"></div>' +
        '</section>' +
        '<aside class="xs-spec">' +
          '<div class="xs-sec-k xs-mono"><span>Especificações</span></div><div class="xs-tm"></div>' +
          `<p class="xs-usage" hidden>${ico('info')}<span class="xs-usage-t"></span></p>` +
          '<div class="xs-hint xs-mono"><span><b>Arrastar</b>Rodar</span><span><b>Roda do rato</b>Aproximar</span><span><b>Duplo clique</b>Repor vista</span><span><b>← →  ↑ ↓</b>Produto · cor</span></div>' +
        '</aside>' +
        '<div class="xs-center">' +
          '<div class="xs-ctl xs-pe"><div class="xs-orbs"></div><span class="xs-ctl-sep"></span>' +
            `<button class="xs-tool xs-fold" type="button" hidden>${ico('foldIn')}<span class="xs-fold-l"></span></button>` +
            `<button class="xs-tool ic xs-reset" type="button" title="Repor vista" aria-label="Repor vista">${ico('reset')}</button></div>` +
          '<div class="xs-color"><span class="xs-color-n"></span><span class="xs-soon xs-mono" hidden>Brevemente</span></div>' +
        '</div>' +
        '<div class="xs-dockwrap">' +
          `<button class="xs-nav xs-pe xs-prev" type="button" aria-label="Anterior" title="Anterior">${ico('left')}</button>` +
          '<div class="xs-dock xs-pe"></div>' +
          `<button class="xs-nav xs-pe xs-next" type="button" aria-label="Seguinte" title="Seguinte">${ico('right')}</button>` +
        '</div>' +
      '</div>';
    document.body.appendChild(root);
    const q = s => root.querySelector(s);
    Object.assign(R, {
      root, stage: q('.xs-stage'), ui: q('.xs-ui'), fb: q('.xs-fb-pic'), load: q('.xs-load'), loadBar: q('.xs-load i'),
      glowA: q('.xs-bg-glow.a'), glowB: q('.xs-bg-glow.b'),
      vAv: q('.xs-vd-av'), vName: q('.xs-vd-name'), vShop: q('.xs-vd-shop'),
      freq: q('.xs-freq'), ind: q('.xs-freq-ind'), wallet: q('.xs-wallet'), close: q('.xs-close'),
      id: q('.xs-id'), brand: q('.xs-brand'), sep: q('.xs-sep'), os: q('.xs-os'), badge: q('.xs-badge'), name: q('.xs-name'), tag: q('.xs-tag'),
      buy: q('.xs-buy'), price: q('.xs-price'), own: q('.xs-own'), ownN: q('.xs-own-n'), pay: q('.xs-pay'), payInd: q('.xs-pay-ind'),
      hold: q('.xs-hold'), holdLabel: q('.xs-hold-label'), holdSub: q('.xs-hold-sub'), note: q('.xs-note'),
      spec: q('.xs-spec'), tm: q('.xs-tm'), feats: q('.xs-feats'), usage: q('.xs-usage'), usageT: q('.xs-usage-t'),
      hint: q('.xs-hint'), ctlSep: q('.xs-ctl-sep'), orbs: q('.xs-orbs'), fold: q('.xs-fold'), foldL: q('.xs-fold-l'), reset: q('.xs-reset'), colorN: q('.xs-color-n'), soon: q('.xs-soon'),
      dock: q('.xs-dock'), prev: q('.xs-prev'), next: q('.xs-next'),
    });
    /* listas de tamanho fixo: criam-se agora e depois só se escondem/mostram */
    for (let i = 0; i < MAX_FEATS; i++) {
      const li = document.createElement('li');
      li.className = 'xs-feat';
      li.innerHTML = `<span class="xs-feat-i" data-noi18n>${String(i + 1).padStart(2, '0')}</span><span class="xs-feat-t"></span>`;
      li.hidden = true;
      R.feats.appendChild(li);
      featEls.push({ el: li, t: li.lastChild });
    }
    for (let i = 0; i < MAX_SPECS; i++) {
      const row = document.createElement('div');
      row.className = 'xs-tm-row';
      row.innerHTML = '<span class="xs-tm-lead"></span><span class="xs-tm-k xs-mono"></span><span class="xs-tm-v" data-noi18n></span>';
      row.hidden = true;
      R.tm.appendChild(row);
      specEls.push({ el: row, k: row.children[1], v: row.children[2] });
    }
    for (let i = 0; i < MAX_ORBS; i++) {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'xs-orb';
      b.innerHTML = '<i></i><span class="xs-orb-own" hidden></span>';
      b.hidden = true;
      b.addEventListener('click', e => { e.currentTarget.blur(); pickVariant(i); });
      R.orbs.appendChild(b);
      orbEls.push({ el: b, dot: b.firstChild, own: b.lastChild });
    }
    R.close.addEventListener('click', e => { e.currentTarget.blur(); close(); });
    R.prev.addEventListener('click', e => { e.currentTarget.blur(); step(-1); });
    R.next.addEventListener('click', e => { e.currentTarget.blur(); step(1); });
    R.fold.addEventListener('click', e => { e.currentTarget.blur(); toggleFold(); });
    R.reset.addEventListener('click', e => { e.currentTarget.blur(); const V = VW(); if (S.glOk && V && V.ready) V.reset(); });
    R.dock.addEventListener('wheel', e => { if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) { R.dock.scrollLeft += e.deltaY; e.preventDefault(); } }, { passive: false });
    /* manter premido para comprar */
    R.hold.addEventListener('pointerdown', e => { if (e.button === 0) { e.preventDefault(); holdStart(); } });
    ['pointerup', 'pointerleave', 'pointercancel'].forEach(t => R.hold.addEventListener(t, holdCancel));
    R.hold.addEventListener('click', e => e.preventDefault());
    R.hold.addEventListener('animationend', e => { if (e.animationName === 'xs-shake') R.hold.classList.remove('err'); });
    window.addEventListener('resize', fit);
    window.addEventListener('keydown', onKey, true);
  }

  /* desenho a 1920×1080: zoom pelo lado que aperta mais (16:9 = igual nos dois) */
  function fit() {
    if (!R.ui) return;
    const w = window.innerWidth, h = window.innerHeight;
    const z = Math.max(0.45, Math.min(2.2, Math.min(w / 1920, h / 1080)));
    S.zoom = z;
    R.ui.style.zoom = String(z);
    R.ui.style.width = (w / z) + 'px';
    R.ui.style.height = (h / z) + 'px';
    placeCatInd(false);
    placePayInd();
    const V = VW();
    if (V && V.ready) V.resize();
  }

  /* ---------------------------------------------------------------- catálogo (uma vez por catálogo) */
  function normCatalog(c) {
    c = c && typeof c === 'object' ? c : {};
    const products = (Array.isArray(c.products) ? c.products : []).filter(p => p && p.id && Array.isArray(p.variants) && p.variants.length);
    const cats = Array.isArray(c.categories) && c.categories.length ? c.categories.filter(x => x && x.id) : [{ id: 'all', label: 'Todos' }];
    if (!cats.some(x => x.id === 'all')) cats.unshift({ id: 'all', label: 'Todos' });
    const pay = c.payment && typeof c.payment === 'object' ? c.payment : {};
    const accounts = (Array.isArray(pay.accounts) ? pay.accounts : ['bank', 'cash']).filter(a => a === 'bank' || a === 'cash');
    if (!accounts.length) accounts.push('bank');
    return {
      products, categories: cats, currency: c.currency || (window.UI && UI.currency ? UI.currency() : { symbol: '$', position: 'before' }),
      payment: { accounts, default: accounts.indexOf(pay.default) >= 0 ? pay.default : accounts[0] },
    };
  }

  function buildCatalog(cat) {
    S.catalog = cat;
    S.byId = {};
    cat.products.forEach(p => { S.byId[p.id] = p; });

    /* categorias */
    Object.keys(catBtns).forEach(k => catBtns[k].el.remove());
    catBtns = {};
    cat.categories.forEach(c => {
      const n = cat.products.filter(p => inCat(p, c.id)).length;
      if (c.id !== 'all' && !n) return;
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'xs-cat';
      const l = document.createElement('span');
      l.textContent = c.label || c.id;
      const cn = document.createElement('span');
      cn.className = 'xs-cat-n';
      cn.setAttribute('data-noi18n', '');
      cn.textContent = String(n).padStart(2, '0');
      b.append(l, cn);
      b.addEventListener('click', e => { e.currentTarget.blur(); setCat(c.id); });
      R.freq.insertBefore(b, R.ind);
      catBtns[c.id] = { el: b };
    });
    R.ind.classList.remove('ready');

    /* doca */
    R.dock.textContent = '';
    caps = {};
    cat.products.forEach(p => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'xs-cap';
      b.innerHTML = '<span class="xs-cap-img"></span><span class="xs-cap-txt"><span class="xs-cap-name" data-noi18n></span><span class="xs-cap-sub"><span class="xs-cap-price" data-noi18n></span><span class="xs-cap-soon" hidden>Brevemente</span></span></span><span class="xs-cap-own" hidden></span>';
      b.querySelector('.xs-cap-name').textContent = p.name || p.id;
      const prices = p.variants.map(v => Number(v.price) || Number(p.price) || 0);
      const min = Math.min.apply(null, prices), max = Math.max.apply(null, prices);
      const pr = b.querySelector('.xs-cap-price');
      pr.textContent = money(min);
      if (max > min) {
        const from = document.createElement('span');
        from.textContent = 'Desde';
        from.style.letterSpacing = '.1em';
        b.querySelector('.xs-cap-sub').insertBefore(from, pr);
      }
      const v0 = p.variants.find(v => available(v.item)) || p.variants[0];
      setImage(b.querySelector('.xs-cap-img'), p, v0);
      b.addEventListener('click', e => { e.currentTarget.blur(); selectProduct(p.id); });
      R.dock.appendChild(b);
      caps[p.id] = { el: b, price: pr, soon: b.querySelector('.xs-cap-soon'), own: b.querySelector('.xs-cap-own') };
    });
    if (!cat.products.length) {
      const e = document.createElement('div');
      e.className = 'xs-empty';
      e.textContent = 'Não há produtos à venda nesta loja.';
      R.dock.appendChild(e);
    }

    /* pagamento */
    Array.from(R.pay.querySelectorAll('.xs-pay-opt')).forEach(n => n.remove());
    payEls = {};
    R.pay.classList.toggle('one', cat.payment.accounts.length === 1);
    cat.payment.accounts.forEach(acc => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'xs-pay-opt';
      b.innerHTML = `${ico(acc === 'bank' ? 'bank' : 'cash')}<span></span><i class="xs-pay-dot"></i>`;
      b.children[1].textContent = accLabel(acc);
      b.addEventListener('click', e => { e.currentTarget.blur(); setAccount(acc); });
      R.pay.appendChild(b);
      payEls[acc] = b;
    });

    /* carteira */
    R.wallet.textContent = '';
    walletEls = {};
    cat.payment.accounts.forEach(acc => {
      const k = document.createElement('span');
      k.className = 'xs-w-k xs-mono';
      k.textContent = accLabel(acc);
      const v = document.createElement('span');
      v.className = 'xs-w-v';
      v.setAttribute('data-noi18n', '');
      R.wallet.append(k, v);
      walletEls[acc] = v;
    });
  }

  /* ---------------------------------------------------------------- estado do servidor */
  function normState(st) {
    st = st && typeof st === 'object' ? st : {};
    return {
      wallet: st.wallet && typeof st.wallet === 'object' ? st.wallet : {},
      owned: st.owned && typeof st.owned === 'object' ? st.owned : {},
      available: st.available && typeof st.available === 'object' ? st.available : {},
      framework: st.framework !== false,
    };
  }

  function applyState(st) {
    S.state = normState(st);
    Object.keys(walletEls).forEach(acc => {
      const n = S.state.wallet[acc];
      walletEls[acc].textContent = typeof n === 'number' ? money(n) : '-';
      walletEls[acc].classList.toggle('na', typeof n !== 'number');
    });
    Object.keys(caps).forEach(id => {
      const p = S.byId[id], c = caps[id];
      const av = productAvailable(p);
      c.price.hidden = !av;
      c.soon.hidden = av;
      if (c.price.previousSibling && c.price.previousSibling.nodeType === 1) c.price.previousSibling.hidden = !av;
      c.own.hidden = productOwned(p) <= 0;
    });
    if (curProduct()) { renderOrbs(); renderVariant(false); }
  }

  function refresh() {
    return Overlay.rpc('shop.refresh', {}, 10000).then(r => { if (S.open && r && r.ok && r.state) applyState(r.state); });
  }

  /* ---------------------------------------------------------------- categorias */
  function visibleIds() {
    return S.catalog ? S.catalog.products.filter(p => inCat(p, S.cat)).map(p => p.id) : [];
  }

  function placeCatInd(animate) {
    const b = catBtns[S.cat] && catBtns[S.cat].el;
    if (!b || !R.ind) return;
    const w = Math.max(18, b.offsetWidth - 30);
    R.ind.style.width = w + 'px';
    R.ind.style.transform = `translateX(${b.offsetLeft + (b.offsetWidth - w) / 2}px)`;
    if (animate === false) { R.ind.classList.remove('ready'); requestAnimationFrame(() => requestAnimationFrame(() => R.ind.classList.add('ready'))); }
  }

  function setCat(id, initial) {
    if (!catBtns[id]) id = 'all';
    S.cat = id;
    Object.keys(catBtns).forEach(k => catBtns[k].el.classList.toggle('on', k === id));
    placeCatInd(initial ? false : true);
    const ids = visibleIds();
    S.catalog.products.forEach(p => { caps[p.id].el.hidden = ids.indexOf(p.id) < 0; });
    if (!initial && ids.length && ids.indexOf(S.pid) < 0) selectProduct(ids[0]);
    else if (!initial) scrollCapIntoView();
  }

  function scrollCapIntoView() {
    const c = S.pid && caps[S.pid];
    if (!c || c.el.hidden) return;
    const d = R.dock, el = c.el;
    if (el.offsetLeft < d.scrollLeft) d.scrollLeft = el.offsetLeft - 6;
    else if (el.offsetLeft + el.offsetWidth > d.scrollLeft + d.clientWidth) d.scrollLeft = el.offsetLeft + el.offsetWidth - d.clientWidth + 6;
  }

  function step(dir) {
    const ids = visibleIds();
    if (!ids.length) return;
    const i = ids.indexOf(S.pid);
    selectProduct(ids[(i + dir + ids.length) % ids.length]);
  }

  /* ---------------------------------------------------------------- produto */
  function selectProduct(id, quiet) {
    const p = S.byId[id];
    if (!p) return;
    const changed = S.pid !== id;
    S.pid = id;
    const firstAv = p.variants.findIndex(v => available(v.item));
    S.vi = firstAv >= 0 ? firstAv : 0;
    setConfirm(false);
    S.doneUntil = 0;
    S.noteMsg = null;
    Object.keys(caps).forEach(k => caps[k].el.classList.toggle('on', k === id));
    scrollCapIntoView();

    /* identidade */
    R.brand.textContent = p.brand || '';
    R.os.textContent = p.os || '';
    R.sep.hidden = !(p.brand && p.os);
    R.badge.textContent = p.badge || '';
    R.badge.hidden = !p.badge;
    R.name.textContent = p.name || p.id;
    R.name.classList.toggle('long', String(p.name || '').length > 16);
    R.tag.textContent = p.tagline || '';
    R.tag.hidden = !p.tagline;

    /* telemetria: as chaves conhecidas pela ordem, depois as outras */
    const specs = p.specs && typeof p.specs === 'object' ? p.specs : {};
    const keys = SPEC_ORDER.filter(k => specs[k]).concat(Object.keys(specs).filter(k => SPEC_ORDER.indexOf(k) < 0 && specs[k]));
    specEls.forEach((s, i) => {
      const k = keys[i];
      s.el.hidden = !k;
      if (!k) return;
      s.k.textContent = SPEC_LABEL[k] || k;
      if (SPEC_LABEL[k]) s.k.removeAttribute('data-noi18n'); else s.k.setAttribute('data-noi18n', '');
      s.v.textContent = String(specs[k]);
    });
    R.tm.previousElementSibling.hidden = !keys.length;
    const feats = Array.isArray(p.features) ? p.features : [];
    featEls.forEach((f, i) => { f.el.hidden = !feats[i]; if (feats[i]) f.t.textContent = feats[i]; });
    R.feats.hidden = !feats.length;
    R.usage.hidden = !p.usage;
    R.usageT.textContent = p.usage || '';

    buildOrbs(p);
    renderVariant(true);
    if (changed && !quiet) { restart(R.id, 'xs-swap'); restart(R.spec, 'xs-swap2'); }
  }

  function buildOrbs(p) {
    orbEls.forEach((o, i) => {
      const v = p.variants[i];
      o.el.hidden = !v;
      if (!v) return;
      const c = hexOk(v.swatch) ? v.swatch : '#3a3f4f';
      o.dot.style.setProperty('--sw', c);
      o.dot.style.setProperty('--swr', rgbOf(c));
      o.el.title = v.color || '';
    });
    renderOrbs();
  }

  function renderOrbs() {
    const p = curProduct();
    if (!p) return;
    orbEls.forEach((o, i) => {
      const v = p.variants[i];
      if (!v) return;
      const av = available(v.item);
      o.el.classList.toggle('on', i === S.vi);
      o.el.classList.toggle('soon', !av);
      o.own.hidden = owned(v.item) <= 0;
    });
  }

  function pickVariant(i) {
    const p = curProduct();
    if (!p || !p.variants[i] || i === S.vi) return;
    S.vi = i;
    setConfirm(false);
    S.doneUntil = 0;
    S.noteMsg = null;
    renderOrbs();
    renderVariant(true);
    restart(R.colorN, 'xs-tick');
  }

  function setTint(hex) {
    const rgb = rgbOf(hexOk(hex) ? hex : '#C8CAD0');
    if (rgb === S.tint) return;
    S.tint = rgb;
    /* duas camadas: a nova acende por cima da antiga (só opacity anima) */
    S.tintSlot ^= 1;
    const on = S.tintSlot ? R.glowB : R.glowA, off = S.tintSlot ? R.glowA : R.glowB;
    R.root.style.setProperty(S.tintSlot ? '--xs-rgb2' : '--xs-rgb', rgb);
    on.classList.add('on');
    off.classList.remove('on');
    /* o halo do chão e o anel usam a cor ativa */
    R.stage.style.setProperty('--xs-rgb', rgb);
  }

  function renderVariant(reload) {
    const p = curProduct(), v = curVariant();
    if (!p || !v) return;
    R.colorN.textContent = v.color || '';
    R.soon.hidden = available(v.item);
    R.price.textContent = money(v.price != null ? v.price : p.price);
    const n = owned(v.item);
    R.own.hidden = n <= 0;
    R.ownN.textContent = n > 1 ? '×' + n : '';
    setTint(v.swatch);
    setImage(R.fb, p, v);
    renderPay();
    renderHold();
    if (reload) loadModel();
  }

  /* ---------------------------------------------------------------- pagamento */
  function setAccount(acc) {
    if (!payEls[acc] || S.account === acc) return;
    S.account = acc;
    setConfirm(false);
    S.noteMsg = null;
    renderPay();
    renderHold();
  }

  function placePayInd() {
    const b = S.account && payEls[S.account];
    if (!b || !R.payInd) return;
    R.payInd.style.width = b.offsetWidth + 'px';
    R.payInd.style.transform = `translateX(${b.offsetLeft - 3}px)`;
  }

  function renderPay() {
    const v = curVariant();
    Object.keys(payEls).forEach(acc => {
      const bal = S.state.wallet[acc];
      payEls[acc].classList.toggle('on', acc === S.account);
      payEls[acc].classList.toggle('low', !!v && typeof bal === 'number' && bal < v.price);
    });
    placePayInd();
  }

  /* ---------------------------------------------------------------- comprar */
  function blockReason() {
    const v = curVariant();
    if (!v) return { note: '' };
    if (!S.state.framework) return { note: 'A loja não está ligada a nenhum framework.' };
    if (!available(v.item)) return { note: 'Esta cor ainda não chegou à loja.', soon: true };
    const bal = S.state.wallet[S.account];
    if (typeof bal === 'number' && bal < v.price) return { note: L.tf('Saldo insuficiente: faltam %s.', money(v.price - bal)) };
    return null;
  }

  function setConfirm(on) {
    clearTimeout(S.confirmTimer);
    S.confirmUntil = on ? Date.now() + CONFIRM_MS : 0;
    if (on) S.confirmTimer = setTimeout(() => { S.confirmUntil = 0; renderHold(); }, CONFIRM_MS);
  }

  function setNote(text, kind) {
    R.note.textContent = text || '';
    R.note.className = 'xs-note' + (kind ? ' ' + kind : '');
  }

  function renderHold() {
    const h = R.hold;
    if (!h) return;
    const block = blockReason();
    const confirming = S.confirmUntil > Date.now() && !block;
    const done = S.doneUntil > Date.now();
    h.classList.toggle('off', !!block && !S.busy && !done);
    h.classList.toggle('full', S.busy);
    h.classList.toggle('done', done && !S.busy);
    h.classList.toggle('confirm', confirming && !S.busy);
    let label, sub;
    if (S.busy) { label = 'A processar…'; sub = 'A falar com o banco'; }
    else if (done) { label = 'Adquirido'; sub = 'Já está no teu inventário'; }
    else if (block && block.soon) { label = 'Brevemente'; sub = 'Ainda não disponível'; }
    else if (confirming) { label = 'Prime Enter outra vez para confirmar'; sub = accLabel(S.account); }
    else { label = 'Mantém premido para comprar'; sub = accLabel(S.account); }
    if (R.holdLabel.textContent !== label) R.holdLabel.textContent = label;
    if (R.holdSub.textContent !== sub) R.holdSub.textContent = sub;
    /* nota por baixo: mensagem do servidor (até a próxima ação) > bloqueio > estado */
    if (S.noteMsg) setNote(S.noteMsg.text, S.noteMsg.kind);
    else if (S.busy) setNote('A confirmar o pagamento…', '');
    else if (done) setNote('Já está no teu inventário.', 'ok');
    else if (block) setNote(block.note, block.soon ? 'warn' : 'warn');
    else if (confirming) setNote(L.tf('Pagamento: %s.', L.t(accLabel(S.account))), '');
    else setNote('Vai direto para o teu inventário.', '');
  }

  function holdStart() {
    if (!S.open || S.busy || S.holdTimer) return;
    if (S.doneUntil > Date.now()) return;
    const block = blockReason();
    if (block) { shake(); return; }
    S.noteMsg = null;
    setConfirm(false);
    R.hold.classList.add('on');
    S.holdTimer = setTimeout(() => {
      S.holdTimer = 0;
      R.hold.classList.remove('on');
      doBuy();
    }, HOLD_MS);
  }

  function holdCancel() {
    if (!S.holdTimer) return;
    clearTimeout(S.holdTimer);
    S.holdTimer = 0;
    R.hold.classList.remove('on');
  }

  function enterKey() {
    if (S.busy || S.holdTimer) return;
    if (S.doneUntil > Date.now()) return;
    const block = blockReason();
    if (block) { shake(); return; }
    if (S.confirmUntil <= Date.now()) { S.noteMsg = null; setConfirm(true); renderHold(); return; }
    setConfirm(false);
    doBuy();
  }

  function doBuy() {
    const p = curProduct(), v = curVariant();
    if (!p || !v || S.busy) return;
    S.busy = true;
    S.noteMsg = null;
    renderHold();
    const item = v.item, account = S.account;
    Overlay.rpc('shop.buy', { item, account }, 15000).then(res => {
      S.busy = false;
      if (!S.open) return;
      if (res && res.ok) {
        if (res.state) applyState(res.state);
        clearTimeout(S.doneTimer);
        S.doneUntil = Date.now() + DONE_MS;
        S.doneTimer = setTimeout(() => { S.doneUntil = 0; renderHold(); }, DONE_MS);
        renderOrbs();
        renderVariant(false);
      } else {
        S.noteMsg = { text: (res && res.message) || 'A compra falhou. Tenta outra vez.', kind: 'err' };
        shake();
        if (res && res.state) applyState(res.state); else refresh();
        renderHold();
      }
    });
  }

  /* ---------------------------------------------------------------- visor 3D */
  /* o traço entre as cores e as ferramentas só existe se houver ferramentas */
  function syncCtl() { R.ctlSep.hidden = R.fold.hidden && R.reset.hidden; }

  function progress(f, on) {
    R.load.classList.toggle('on', !!on);
    R.loadBar.style.transform = `translateX(${(Math.max(0, Math.min(1, f)) - 1) * 100}%)`;
  }

  function glOff() {
    R.stage.classList.remove('gl-on');
    R.fold.hidden = true;
    R.reset.hidden = true;
    R.hint.classList.add('gone');
    progress(0, false);
    syncCtl();
  }

  /* primeira abertura: carrega o three.js (sem bloquear: a imagem do produto aparece logo) */
  function startViewer() {
    const V = VW();
    if (!V) { S.glOk = false; glOff(); return; }
    S.glWant = true;
    if (S.glOk === false) { glOff(); return; }
    if (S.glOk === true) { R.reset.hidden = false; R.hint.classList.remove('gone'); syncCtl(); V.resetHint(); V.setActive(true); loadModel(); return; }
    glOff();
    progress(0.04, true);
    V.load().then(ok => {
      if (!ok || !V.mount(R.stage)) { S.glOk = false; progress(0, false); return; }
      S.glOk = true;
      if (!S.open || !S.glWant) { progress(0, false); return; }
      R.reset.hidden = false;
      R.hint.classList.remove('gone');
      syncCtl();
      V.resetHint();
      V.setActive(true);
      loadModel();
    });
  }

  function stopViewer() {
    S.glWant = false;
    S.loadSeq++;
    progress(0, false);
    const V = VW();
    if (V && V.ready) { V.setActive(false); V.unload(); }
    R.stage.classList.remove('gl-on');
  }

  function loadModel() {
    const p = curProduct(), v = curVariant(), V = VW();
    if (!S.glOk || !V || !V.ready || !p || !v || !S.open) return;
    if (!v.model) { R.stage.classList.remove('gl-on'); R.fold.hidden = true; return; }
    const seq = ++S.loadSeq;
    R.fold.hidden = true;
    progress(0.06, true);
    const spec = Object.assign({ key: p.id }, p.viewer || {});
    const url = v.model + (spec.revision ? (v.model.indexOf('?') >= 0 ? '&' : '?') + 'v=' + encodeURIComponent(spec.revision) : '');
    V.show(url, spec, f => { if (seq === S.loadSeq) progress(0.06 + f * 0.9, true); }).then(ok => {
      if (seq !== S.loadSeq) return;
      progress(1, true);
      setTimeout(() => { if (seq === S.loadSeq) progress(1, false); }, 280);
      if (!ok) { R.stage.classList.remove('gl-on'); return; }
      R.stage.classList.add('gl-on');
      const kind = (p.viewer || {}).kind;
      R.fold.hidden = kind === 'buds' ? !V.hasCase() : !((kind === 'fold' || kind === 'flip') && V.hasFold());
      if (kind === 'buds' && V.hasCase()) V.setCaseOpen(true);
      setFoldLabel(kind === 'buds' ? V.isCaseOpen() : V.isFolded());
      syncCtl();
    });
  }

  function setFoldLabel(on) {
    const p = curProduct();
    const isCase = p && (p.viewer || {}).kind === 'buds';
    const label = isCase ? (on ? 'Fechar caixa' : 'Abrir caixa') : (on ? 'Abrir' : 'Dobrar');
    R.foldL.textContent = label;
    R.fold.setAttribute('aria-pressed', String(!!on));
    const k = isCase ? (on ? 'caseClose' : 'caseOpen') : (on ? 'foldOut' : 'foldIn');
    const svg = R.fold.firstElementChild;
    if (svg && svg._k !== k) { svg.innerHTML = P[k]; svg._k = k; }
  }

  function toggleFold() {
    const V = VW(), p = curProduct();
    if (!S.glOk || !V || !V.ready || R.fold.hidden || !p) return;
    if ((p.viewer || {}).kind === 'buds') { if (V.hasCase()) setFoldLabel(V.toggleCase()); }
    else if (V.hasFold()) setFoldLabel(V.toggleFold());
  }

  /* ---------------------------------------------------------------- teclado (só com a loja aberta, e sem deixar
     as teclas chegarem ao telemóvel: o ESC dele chamaria o 'close' do telemóvel) */
  function onKey(e) {
    if (!S.open || S.closing) return;
    e.stopImmediatePropagation();
    const k = e.key;
    if (k === 'Escape') { e.preventDefault(); if (!e.repeat) close(); }
    else if (k === 'ArrowLeft' || k === 'ArrowRight') { e.preventDefault(); if (!S.busy) step(k === 'ArrowLeft' ? -1 : 1); }
    else if (k === 'ArrowUp' || k === 'ArrowDown') {
      e.preventDefault();
      const p = curProduct();
      if (p && p.variants.length > 1 && !S.busy) pickVariant((S.vi + (k === 'ArrowUp' ? -1 : 1) + p.variants.length) % p.variants.length);
    }
    else if (k === 'Enter') { e.preventDefault(); if (!e.repeat) enterKey(); }
    else if (k === ' ' || k === 'Tab') e.preventDefault();
  }

  /* ---------------------------------------------------------------- vendedor */
  function fillVendor() {
    const sh = S.shop || {};
    R.vName.textContent = window.L && L.t ? L.t('Loja de telemóveis') : 'Loja de telemóveis';
    R.vAv.classList.toggle('admin', !!S.admin);
    if (S.admin) { R.vShop.removeAttribute('data-noi18n'); R.vShop.textContent = 'Modo administrador'; return; }
    R.vShop.setAttribute('data-noi18n', '');
    R.vShop.textContent = sh.label || '';
  }
  /* ---------------------------------------------------------------- abrir / fechar */
  function open(msg) {
    msg = msg && typeof msg === 'object' ? msg : {};
    build();
    clearTimeout(S.closeTimer);
    clearTimeout(S.enterTimer);
    const cat = normCatalog(msg.catalog || S.catalog);
    const key = JSON.stringify(cat);
    S.state = normState(msg.state);       /* a doca precisa do estado para a imagem inicial */
    if (key !== S.catKey) { S.catKey = key; buildCatalog(cat); }
    S.shop = msg.shop || {};
    S.admin = !!msg.admin;
    S.busy = false; S.doneUntil = 0; S.noteMsg = null;
    setConfirm(false);
    holdCancel();
    fillVendor();
    const accs = cat.payment.accounts;
    if (!S.account || accs.indexOf(S.account) < 0) S.account = cat.payment.default;
    R.root.hidden = false;
    R.root.removeAttribute('aria-hidden');
    R.root.classList.remove('out');
    S.open = true;
    S.closing = false;
    if (window.Overlay) Overlay.open('shop');
    fit();
    S.cat = 'all';
    setCat('all', true);
    applyState(msg.state);
    const first = cat.products.find(p => productAvailable(p)) || cat.products[0];
    S.pid = null;
    if (first) selectProduct(first.id, true);
    R.dock.scrollLeft = 0;
    restart(R.root, 'in');
    S.enterTimer = setTimeout(() => R.root.classList.remove('in'), 1300);
    startViewer();
  }

  /* com a loja aberta, o painel mudou o catálogo: troca no sítio e mantém o produto se ainda existir */
  function update(catalog, shop) {
    if (!S.open || !catalog) return;
    const cat = normCatalog(catalog);
    const key = JSON.stringify(cat);
    if (shop) { S.shop = shop; fillVendor(); }
    if (key === S.catKey) return;
    const keep = S.pid;
    S.catKey = key;
    buildCatalog(cat);
    if (S.cat && !catBtns[S.cat]) S.cat = 'all';
    setCat(S.cat, true);
    applyState(S.state);
    const id = S.byId[keep] ? keep : (cat.products[0] && cat.products[0].id);
    S.pid = null;
    if (id) selectProduct(id, true);
    placePayInd();
  }

  function teardown() {
    S.open = false;
    S.closing = false;
    holdCancel();
    setConfirm(false);
    clearTimeout(S.doneTimer);
    clearTimeout(S.enterTimer);
    stopViewer();
    if (R.root) {
      R.root.hidden = true;
      R.root.setAttribute('aria-hidden', 'true');
      R.root.classList.remove('in', 'out');
    }
  }

  /* fechar pela interface (botão, ESC): saída curta e depois o Overlay larga o foco no Lua */
  function close() {
    if (!S.open || S.closing) return;
    S.closing = true;
    holdCancel();
    const V = VW();
    if (V && V.ready) V.setActive(false);
    R.root.classList.remove('in');
    R.root.classList.add('out');
    clearTimeout(S.closeTimer);
    S.closeTimer = setTimeout(() => {
      teardown();
      if (window.Overlay) Overlay.close('shop');
    }, 170);
  }

  if (window.Bridge && Bridge.on) {
    Bridge.on('shop:open', d => open(d));
    Bridge.on('shop:catalog', d => { if (d) update(d.catalog, d.shop); });
  }
  /* fechada pelo Lua (afastou-se do vendedor, morreu, loja desligada): sem animação, o body já escondeu */
  if (window.Overlay) Overlay.onClose('shop', () => { clearTimeout(S.closeTimer); teardown(); });

  /* ---------------------------------------------------------------- testes fora do FiveM */
  if (window.Overlay && !(window.Bridge && Bridge.inFiveM)) {
    const M = { wallet: { bank: 898514, cash: 0 }, owned: {}, available: {} };
    const snap = () => ({ wallet: Object.assign({}, M.wallet), owned: Object.assign({}, M.owned), available: Object.assign({}, M.available), framework: true });
    Overlay.mock['shop.state'] = () => ({ ok: true, state: snap() });
    Overlay.mock['shop.refresh'] = Overlay.mock['shop.state'];
    Overlay.mock['shop.buy'] = d => new Promise(res => setTimeout(() => {
      const p = S.catalog && S.catalog.products.find(x => x.variants.some(v => v.item === d.item));
      const v = p && p.variants.find(x => x.item === d.item);
      if (!v) return res({ ok: false, error: 'unknown_item', message: 'Este produto não existe nesta loja.' });
      if (M.available[d.item] === false) return res({ ok: false, error: 'unavailable', message: 'Este produto ainda não está disponível.' });
      const bal = M.wallet[d.account] || 0;
      if (bal < v.price) return res({ ok: false, error: 'no_money', message: d.account === 'bank' ? 'Saldo insuficiente no banco.' : 'Não tens dinheiro suficiente contigo.' });
      M.wallet[d.account] = bal - v.price;
      M.owned[d.item] = (M.owned[d.item] || 0) + 1;
      const label = `${p.name} · ${v.color}`;
      res({ ok: true, item: d.item, label, price: v.price, account: d.account, message: `Compraste ${label} por ${money(v.price)}.`, state: snap() });
    }, 650));
    /* o payload de teste semeia o estado do mock */
    const realOpen = open;
    window.__shopMockSeed = st => { st = normState(st); M.wallet = Object.assign({}, st.wallet); M.owned = Object.assign({}, st.owned); M.available = Object.assign({}, st.available); };
    window.Shop = { open(p) { if (p && p.state) window.__shopMockSeed(p.state); realOpen(p); }, close, update, get state() { return S; } };
  } else {
    window.Shop = { open, close, update, get state() { return S; } };
  }
}());
