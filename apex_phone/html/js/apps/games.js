/* ===================== JOGOS - arcade do telemóvel =====================
   Seis jogos completos (Snake, 2048, Blocos, Minas, Break, Memória) + um hub
   "Arcade" com os recordes, sobre um motor comum: HUD, pausa, recorde local,
   pausa automática ao sair da app e limpeza no fecho.

   Regras de desempenho (CEF), cumpridas em todos:
     · UM requestAnimationFrame por jogo, que MORRE em pause()/onClose - uma app
       em segundo plano não gasta um único frame (é isso que estraga o FPS no jogo).
     · Canvas em tamanho lógico fixo: sem redimensionamentos nem devicePixelRatio.
     · Zero filter / backdrop-filter / color-mix; só transform e opacity animam.
     · NADA de emojis: o CEF do GTA não garante a fonte de cor. As faces da
       Memória e os botões são SVG (Icons.g / sprites locais).
   ======================================================================= */

window.Arcade = (() => {
  const g = UI.g;

  /* ---------- recordes e opções: na gaveta DESTA personagem ----------
     Viviam em localStorage['arcade:<jogo>'], cru: fora do espaço da personagem (duas personagens no
     mesmo PC partilhavam recordes) e fora do alcance do Store.clear(), por isso o "Apagar todo o
     conteúdo" das Definições - que promete apagar a conta e TODOS os dados deste telemóvel -
     deixava-os atrás. Agora são dois mapas no Store ('arcade' = recordes, 'arcadeOpt' = opções), que
     já vivem em apexphone:<citizenid>: e vão-se embora com a conta.
     As chaves antigas mudam-se UMA vez por PC (marca na raiz, como a migração do store.js): a
     primeira personagem que abrir um jogo herda-as e elas SAEM do localStorage - se ficassem, um
     "Apagar todo o conteúdo" ressuscitava os recordes na abertura seguinte.
     Continuam locais: para irem para a base de dados falta a tabela e os RPCs (Fase 7). */
  const REC = 'arcade', OPT = 'arcadeOpt', MOVED = 'arcadeMoved';
  const OPTK = /:(walls|lv|pairs)$/;
  const map = key => { const m = Store.get(key, null); return m && typeof m === 'object' && !Array.isArray(m) ? m : {}; };
  const put = (key, k, v) => { const m = Object.assign({}, map(key)); m[k] = v; Store.set(key, m); };
  let moved = false;
  function ensure() {
    if (moved) return; moved = true;
    try { if (Store.global.get(MOVED, 0)) return; } catch (e) {}
    const rec = {}, opt = {}, velhas = [];
    try { Object.keys(localStorage).forEach(k => {
      if (k.indexOf('arcade:') !== 0) return;
      const rest = k.slice(7), v = localStorage.getItem(k); velhas.push(k);
      if (OPTK.test(rest)) opt[rest] = v; else { const n = parseInt(v, 10); if (n > 0) rec[rest] = n; }
    }); } catch (e) {}
    if (velhas.length) {
      Store.set(REC, Object.assign({}, rec, map(REC)));
      Store.set(OPT, Object.assign({}, opt, map(OPT)));
      try { velhas.forEach(k => localStorage.removeItem(k)); } catch (e) {}
    }
    try { Store.global.set(MOVED, 1); } catch (e) {}
  }
  const best = id => { ensure(); const n = parseInt(map(REC)[id], 10); return n > 0 ? n : 0; };
  const setBest = (id, n) => { ensure(); n = Math.floor(+n) || 0; if (!(n > best(id))) return false; put(REC, id, n); return true; };
  /* alguns jogos ganham com MENOS (jogadas, segundos): guardamos o melhor "ao contrário" */
  const bestLow = id => best(id);
  const setBestLow = (id, n) => { ensure(); n = Math.floor(+n) || 0; const cur = bestLow(id); if (!(n > 0 && (!cur || n < cur))) return false; put(REC, id, n); return true; };
  const clearBest = () => { ensure(); const m = map(REC); Object.keys(m).forEach(k => { if (!OPTK.test(k)) delete m[k]; }); Store.set(REC, m); };
  /* opções de cada jogo (paredes do Snake, dificuldade das Minas, pares da Memória): texto, como antes */
  const opt = (k, def) => { ensure(); const v = map(OPT)[k]; return v === undefined || v === null ? def : v; };
  const setOpt = (k, v) => { ensure(); put(OPT, k, String(v)); return v; };

  const GAMES = [];   /* preenchido por game() - usado pelo hub Arcade */

  /* ciclo de animação pausável */
  function loop(fn) {
    let raf = 0, last = 0, running = false;
    const step = t => { if (!running) return; const dt = Math.min(0.05, ((t - (last || t)) / 1000)); last = t; fn(dt); raf = requestAnimationFrame(step); };
    return {
      start() { if (running) return; running = true; last = 0; raf = requestAnimationFrame(step); },
      stop() { running = false; cancelAnimationFrame(raf); },
      get running() { return running; },
    };
  }

  /* gestos de direção (pointer: serve rato e toque) */
  function dirs(el, onDir) {
    let sx = 0, sy = 0, on = false;
    el.addEventListener('pointerdown', e => { sx = e.clientX; sy = e.clientY; on = true; });
    el.addEventListener('pointerup', e => {
      if (!on) return; on = false;
      const dx = e.clientX - sx, dy = e.clientY - sy;
      if (Math.abs(dx) < 16 && Math.abs(dy) < 16) return;
      onDir(Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 'r' : 'l') : (dy > 0 ? 'd' : 'u'));
    });
    el.addEventListener('pointercancel', () => { on = false; });
  }

  /* botão de controlo com glifo do sistema (nunca texto/emoji) */
  const btn = (cls, glyph, size) => `<div class="gb ${cls}">${g(glyph, size || 22)}</div>`;

  /* sprites simples para a Memória - formas geométricas, sempre renderizáveis */
  const SPR = {
    circle: c => `<circle cx="24" cy="24" r="15" fill="${c}"/>`,
    square: c => `<rect x="10" y="10" width="28" height="28" rx="6" fill="${c}"/>`,
    tri: c => `<path d="M24 8 41 39H7z" fill="${c}"/>`,
    diamond: c => `<path d="M24 7 41 24 24 41 7 24z" fill="${c}"/>`,
    star: c => `<path d="M24 7l5 11 12 1.5-9 8 2.5 12L24 34l-10.5 5.5L16 27.5l-9-8L19 18z" fill="${c}"/>`,
    heart: c => `<path d="M24 40S8 30 8 20a8.5 8.5 0 0 1 16-3 8.5 8.5 0 0 1 16 3c0 10-16 20-16 20z" fill="${c}"/>`,
    ring: c => `<circle cx="24" cy="24" r="13" fill="none" stroke="${c}" stroke-width="7"/>`,
    bolt: c => `<path d="M27 6 12 27h9l-3 15 16-22h-10z" fill="${c}"/>`,
  };
  const sprite = (name, color) => `<svg viewBox="0 0 48 48" class="spr" aria-hidden="true">${(SPR[name] || SPR.circle)(color)}</svg>`;

  /* ---------- casca comum: vista raiz + HUD + pausa + fim de jogo ---------- */
  function shell(win, o) {
    const v = UI.view({ title: o.name, full: true, cls: 'gm gm-' + o.id });
    const wrap = UI.el(`<div class="gm-wrap" style="--gm:${o.color || '#0A84FF'}">
      <div class="gm-hud"><div class="s"><span>${UI.esc(o.scoreLabel || 'Pontos')}</span><b class="sc">0</b></div>
        <div class="mid"></div>
        <div class="s r"><span>${UI.esc(o.bestLabel || 'Recorde')}</span><b class="bs">0</b></div></div>
      <div class="gm-stage"></div>
      <div class="gm-ctl"></div>
      <div class="gm-over"><div class="box"><b class="t">Fim de jogo</b><div class="sub"></div>
        <div class="btn-p again">Jogar outra vez</div><div class="btn-p btn-s out">Sair</div></div></div>
      <div class="gm-paused"><div class="pbox">${g('pause', 40)}<b>Em pausa</b><div class="btn-p resume">Continuar</div><div class="btn-p btn-s restart">Recomeçar</div></div></div></div>`);
    v.content.appendChild(wrap);

    const el = {
      stage: wrap.querySelector('.gm-stage'), ctl: wrap.querySelector('.gm-ctl'),
      score: wrap.querySelector('.sc'), best: wrap.querySelector('.bs'),
      mid: wrap.querySelector('.mid'), over: wrap.querySelector('.gm-over'), paused: wrap.querySelector('.gm-paused'),
    };
    const low = !!o.lowerIsBetter;
    /* a chave do recorde pode MUDAR em jogo (dificuldade das Minas, tamanho da Memória):
       fica numa variável e expõe-se setId(), senão o recorde ia sempre para a chave inicial */
    let recId = o.id;
    const readBest = () => (low ? bestLow(recId) : best(recId));
    const writeBest = n => (low ? setBestLow(recId, n) : setBest(recId, n));
    el.best.textContent = readBest() || '--';

    let paused = false, ended = false, pbtn = null;   /* pbtn: botao de pausa da barra - o glifo segue o estado */
    const api = {
      view: v, el, score: 0, pausable: o.pausable !== false,
      get paused() { return paused; },
      get ended() { return ended; },
      setScore(n) { api.score = n; el.score.textContent = n; },
      setMid(html) { el.mid.innerHTML = html; },
      setId(id) { recId = id; el.best.textContent = readBest() || '--'; },
      /* barra de vidas / nível, sempre em SVG */
      hearts(n, total) { let s = ''; for (let i = 0; i < (total || n); i++) s += `<i class="${i < n ? 'on' : ''}">${g('heartFill', 18)}</i>`; return `<span class="gm-hearts">${s}</span>`; },
      pause(byUser) {
        if (paused || ended) return;
        paused = true; el.paused.classList.add('in');
        if (pbtn) pbtn.innerHTML = g('play');
        o.onPause && o.onPause();
        if (byUser) Sound.play('click');
      },
      resume() {
        if (!paused || ended) return;
        paused = false; el.paused.classList.remove('in');
        if (pbtn) pbtn.innerHTML = g('pause');
        o.onResume && o.onResume();
      },
      gameOver(title, sub, finalScore) {
        if (ended) return;
        ended = true; paused = false; el.paused.classList.remove('in'); if (pbtn) pbtn.innerHTML = g('pause');
        const n = finalScore == null ? api.score : finalScore;
        const isBest = writeBest(n);
        el.best.textContent = readBest() || '--';
        wrap.querySelector('.gm-over .t').textContent = title || 'Fim de jogo';
        wrap.querySelector('.gm-over .sub').innerHTML = (sub || `${api.score} pontos`) + (isBest ? '<br><span class="nb">Novo recorde!</span>' : '');
        el.over.classList.add('in');
        Sound.play(isBest ? 'success' : 'error');
      },
      restart() { ended = false; paused = false; el.over.classList.remove('in'); el.paused.classList.remove('in'); if (pbtn) pbtn.innerHTML = g('pause'); o.onRestart && o.onRestart(); },
    };

    wrap.querySelector('.again').onclick = () => api.restart();
    wrap.querySelector('.out').onclick = () => { el.over.classList.remove('in'); System.closeApp(); };
    wrap.querySelector('.resume').onclick = () => api.resume();
    wrap.querySelector('.restart').onclick = () => api.restart();

    /* botões da barra de navegação: pausa (só nos jogos em tempo real) e recomeçar */
    const right = v.querySelector('.nb-right');
    if (o.pausable !== false) {
      const p = UI.el(`<div class="nb-btn">${g('pause')}</div>`);
      p.onclick = () => (paused ? api.resume() : api.pause(true));
      right.appendChild(p); pbtn = p;
    }
    const r = UI.el(`<div class="nb-btn">${g('update')}</div>`);
    r.onclick = async () => {
      if (api.ended) { api.restart(); return; }
      /* o alerta e modal mas o jogo em tempo real continuava a correr por tras dele (a cobra morria
         enquanto se decidia): pausa-se primeiro; quem cancela sai pelo "Continuar" da camada de pausa */
      if (o.pausable !== false) api.pause();
      if (await UI.confirm('Recomeçar', 'Perdes o jogo atual.', 'Recomeçar', true)) api.restart();
    };
    /* deitar o telemóvel (System.rotate): a janela passa a 956×440 e a tela tem de caber no palco - `zoom` encolhe-a
       com o layout (getBoundingClientRect acompanha, por isso os toques nos jogos continuam certos). Direito: 1. */
    const rot = UI.el(`<div class="nb-btn g-rot">${g('rotate', 20)}</div>`);   /* g-rot: os dobráveis não se deitam e escondem-no (app-games.css) */
    rot.onclick = () => { if (window.System && System.rotate) System.rotate(!System.landscape); };
    right.appendChild(rot);
    const fit = () => { const kid = el.stage.firstElementChild; if (!kid) return;
      if (!win.classList.contains('ls')) { kid.style.zoom = ''; return; }
      /* medidas de LAYOUT (clientWidth/offsetWidth), nunca getBoundingClientRect: o aparelho está a rodar durante .5 s e a
         caixa envolvente a meio da rotação dava um palco falso (a tela ficava minúscula) */
      kid.style.zoom = ''; const sw = el.stage.clientWidth || 1, sh = el.stage.clientHeight || 1, kw = kid.offsetWidth || 1, kh = kid.offsetHeight || 1;
      const f = Math.min(1, (sh - 8) / kh, (sw - 8) / kw); kid.style.zoom = f < 1 ? f.toFixed(3) : ''; };
    /* ⚠️ NADA de `Bridge.on('rotate')` AQUI: cada jogo faz `win.onClose = …` por cima do da casca (não encadeia), por isso a
       subscrição nunca era largada e ficavam 6 vivas depois de abrir os 6 jogos (medido no _perf.html). Há UMA subscrição
       global no fim deste ficheiro que chama o `fit` do jogo em primeiro plano. */
    setTimeout(fit, 60);
    api.fit = fit;
    right.appendChild(r);

    UI.setRoot(win, v);
    win._gs = api;   /* a casca fica acessivel a janela: e por aqui que guardar o telemovel poe o jogo em pausa */
    return api;
  }

  /* regista um jogo: pausa quando a app sai de cena, limpeza no fecho */
  function game(id, opt) {
    GAMES.push({ id, name: opt.name, color: opt.color, lower: !!opt.lowerIsBetter, unit: opt.unit || 'pontos' });
    App.define(id, {
      /* statusBar:'dark' = app de fundo escuro (mesma convenção da Câmara, Onion e
         Dark Chat) - sem isto a hora ficava preta sobre o palco preto */
      name: opt.name, category: 'Jogos', description: opt.desc, statusBar: 'dark', landscape: true,   /* roda: jogar de lado (System.rotate) */
      open(win) { win._g = opt.build(win) || null; },
      pause(win) { try { win._g && win._g.pause && win._g.pause(); } catch (e) {} },
      resume(win) { try { win._g && win._g.resume && win._g.resume(); } catch (e) {} },
    });
  }

  /* Guardar o telemovel NAO passa pelo hideCurrent() do System (so esconde o body e fecha as folhas;
     o pause so chega via Lock.lock, que e opcional): o jogo em primeiro plano continuava a correr as
     escuras - a cobra morria com o telemovel no bolso e o rAF gastava frames fora de vista. Mesmo
     padrao do camview.js: pausa ao guardar; nos jogos em tempo real fica a camada "Em pausa" a espera
     do jogador, os outros retomam ao voltar a pegar. */
  const fg = () => { try { const id = System.currentApp(); const w = id && System.windows[id]; return w && w._g ? w : null; } catch (e) { return null; } };
  if (window.Bridge && Bridge.on) {
    Bridge.on('phone:close', () => { const w = fg(); if (!w) return; try { if (w._gs && w._gs.pausable) w._gs.pause(); else if (w._g.pause) w._g.pause(); } catch (e) {} });
    Bridge.on('phone:open', () => { const w = fg(); if (!w) return; try { if (!(w._gs && w._gs.pausable) && w._g.resume) w._g.resume(); } catch (e) {} });
    /* deitar/endireitar o telemóvel: a tela do jogo em primeiro plano volta a caber no palco (uma só subscrição, para sempre) */
    Bridge.on('rotate', () => { const run = () => { const w = fg(); try { w && w._gs && w._gs.fit && w._gs.fit(); } catch (e) {} }; setTimeout(run, 60); setTimeout(run, 600); });
  }
  return { best, setBest, bestLow, setBestLow, clearBest, opt, setOpt, loop, dirs, shell, game, btn, sprite, list: () => GAMES.slice() };
})();

/* =====================================================================
   1. SNAKE
   ===================================================================== */
Icons.app.snake = () => Icons.SVG(Icons.G('gSn', '#8AF9A6', '#34D058', '#1CAD3E') + Icons.GL(
  `<rect x="20" y="24" width="14" height="14" rx="4" fill="#fff"/><rect x="34" y="24" width="14" height="14" rx="4" fill="#fff"/>` +
  `<rect x="48" y="24" width="14" height="14" rx="4" fill="#fff"/><rect x="48" y="38" width="14" height="14" rx="4" fill="#fff"/>` +
  `<rect x="48" y="52" width="14" height="14" rx="4" fill="#fff"/><rect x="34" y="52" width="14" height="14" rx="4" fill="#fff"/>` +
  `<circle cx="70" cy="70" r="8" fill="#FF3B30"/>`));

Arcade.game('snake', {
  name: 'Snake', color: '#30D158',
  desc: 'O clássico. Come, cresce e não te mordas. A cada cinco frutas fica mais rápido, e podes jogar com ou sem paredes.',
  build(win) {
    const N = 17, CELL = 24, SIZE = N * CELL;
    const A = Arcade.shell(win, {
      id: 'snake', name: 'Snake', color: '#30D158',
      onRestart: () => start(), onPause: () => L.stop(), onResume: () => L.start(),
    });
    const cv = UI.el(`<canvas class="gm-cv" width="${SIZE}" height="${SIZE}"></canvas>`);
    A.el.stage.appendChild(cv);
    const ctx = cv.getContext('2d');

    A.el.ctl.innerHTML = `<div class="gm-pad">${Arcade.btn('u', 'chevU')}${Arcade.btn('l', 'chevL')}${Arcade.btn('d', 'chevD')}${Arcade.btn('r', 'chevR')}</div>
      <div class="gm-opt"><span class="walls">Paredes: ligadas</span></div>`;

    let snake, dir, nextDir, food, acc, speed, dead, walls = true, grow = 0;
    walls = Arcade.opt('snake:walls', '1') !== '0';
    const wtxt = () => { A.el.ctl.querySelector('.walls').textContent = 'Paredes: ' + (walls ? 'ligadas' : 'desligadas'); };
    A.el.ctl.querySelector('.walls').onclick = () => {
      walls = !walls; Arcade.setOpt('snake:walls', walls ? '1' : '0');
      wtxt(); Sound.play('click');
    };
    wtxt();

    const put = () => {
      let p, n = 0;
      do { p = { x: (Math.random() * N) | 0, y: (Math.random() * N) | 0 }; n++; }
      while (n < 400 && snake.some(s => s.x === p.x && s.y === p.y));
      food = p;
    };
    const start = () => {
      snake = [{ x: 8, y: 10 }, { x: 7, y: 10 }, { x: 6, y: 10 }];
      dir = { x: 1, y: 0 }; nextDir = dir; acc = 0; speed = 7; dead = false; grow = 0;
      A.setScore(0); A.setMid('<span class="gm-hint">Velocidade 1</span>');
      put(); draw(); L.start();
    };
    const turn = d => {
      const m = { u: { x: 0, y: -1 }, d: { x: 0, y: 1 }, l: { x: -1, y: 0 }, r: { x: 1, y: 0 } }[d];
      if (!m || A.paused || dead) return;
      if (m.x === -dir.x && m.y === -dir.y) return;   /* 180° instantâneo = morte garantida */
      nextDir = m;
    };
    Arcade.dirs(cv, turn);
    ['u', 'd', 'l', 'r'].forEach(k => { A.el.ctl.querySelector('.gb.' + k).onclick = () => turn(k); });

    const step = () => {
      dir = nextDir;
      let hx = snake[0].x + dir.x, hy = snake[0].y + dir.y;
      if (!walls) { hx = (hx + N) % N; hy = (hy + N) % N; }
      else if (hx < 0 || hy < 0 || hx >= N || hy >= N) { die('Bateste na parede'); return; }
      if (snake.some(s => s.x === hx && s.y === hy)) { die('Mordeste-te'); return; }
      snake.unshift({ x: hx, y: hy });
      if (hx === food.x && hy === food.y) {
        A.setScore(A.score + 10); grow += 1;
        if (A.score % 50 === 0) { speed = Math.min(18, speed + 1); A.setMid(`<span class="gm-hint">Velocidade ${speed - 6}</span>`); }
        Sound.play('click'); put();
      } else snake.pop();
    };
    const die = why => { dead = true; L.stop(); A.gameOver(why, `${A.score} pontos · ${snake.length} de comprimento`); };

    /* segmentos arredondados e cabeça com olhos: é o que dá o ar "a sério" */
    const rr = (x, y, w, h, r) => { ctx.beginPath(); ctx.moveTo(x + r, y); ctx.arcTo(x + w, y, x + w, y + h, r); ctx.arcTo(x + w, y + h, x, y + h, r); ctx.arcTo(x, y + h, x, y, r); ctx.arcTo(x, y, x + w, y, r); ctx.closePath(); ctx.fill(); };
    const draw = () => {
      ctx.fillStyle = '#0E1A12'; ctx.fillRect(0, 0, SIZE, SIZE);
      ctx.fillStyle = 'rgba(255,255,255,.028)';
      for (let i = 0; i < N; i++) for (let j = (i % 2); j < N; j += 2) ctx.fillRect(i * CELL, j * CELL, CELL, CELL);
      /* fruta */
      ctx.fillStyle = '#FF453A';
      rr(food.x * CELL + 5, food.y * CELL + 5, CELL - 10, CELL - 10, 5);
      ctx.fillStyle = '#3BA55C';
      ctx.fillRect(food.x * CELL + CELL / 2 - 1, food.y * CELL + 3, 2, 4);
      /* corpo */
      for (let i = snake.length - 1; i >= 0; i--) {
        const s = snake[i];
        const t = 1 - i / Math.max(8, snake.length);
        ctx.fillStyle = i === 0 ? '#8CF0A6' : `rgb(${48 + t * 40 | 0},${180 + t * 40 | 0},${88 + t * 30 | 0})`;
        const pad = i === 0 ? 1.5 : 2.5;
        rr(s.x * CELL + pad, s.y * CELL + pad, CELL - pad * 2, CELL - pad * 2, i === 0 ? 8 : 6);
      }
      /* olhos, virados para a direção */
      const h = snake[0];
      const cx = h.x * CELL + CELL / 2, cy = h.y * CELL + CELL / 2;
      const ox = dir.x * 4, oy = dir.y * 4, px = dir.y * 4, py = dir.x * 4;
      ctx.fillStyle = '#0E1A12';
      ctx.beginPath(); ctx.arc(cx + ox + px, cy + oy + py, 2.2, 0, 6.2832); ctx.fill();
      ctx.beginPath(); ctx.arc(cx + ox - px, cy + oy - py, 2.2, 0, 6.2832); ctx.fill();
    };

    /* A tela só se redesenha quando o tabuleiro MUDA. A cobra anda 7 a 18 vezes por segundo, mas o
       ciclo corre a 60 fps: metade a três quartos das repinturas desenhavam exatamente o mesmo
       (145 fillRect do xadrez + a cobra + a fruta, por frame). O `start()` já desenha o primeiro
       quadro, por isso a marca começa limpa. */
    let dirty = false;
    const L = Arcade.loop(dt => {
      if (dead) return;
      acc += dt;
      const iv = 1 / speed;
      while (acc >= iv) { acc -= iv; step(); dirty = true; if (dead) return; }
      if (dirty) { dirty = false; draw(); }
    });
    start();
    win.onClose = () => L.stop();
    /* ao voltar a app a tela pode ter sido descartada pelo CEF: desenha-se o primeiro quadro */
    return { pause: () => L.stop(), resume: () => { if (!dead && !A.paused) { dirty = true; L.start(); } } };
  },
});

/* =====================================================================
   2. 2048
   ===================================================================== */
Icons.app.g2048 = () => Icons.SVG(Icons.G('g20', '#F5E6D3', '#E8C9A0', '#C9A57A') + Icons.GL(
  `<rect x="16" y="16" width="30" height="30" rx="7" fill="#EEE4DA"/><rect x="54" y="16" width="30" height="30" rx="7" fill="#EDE0C8"/>` +
  `<rect x="16" y="54" width="30" height="30" rx="7" fill="#F2B179"/><rect x="54" y="54" width="30" height="30" rx="7" fill="#F59563"/>`));

Arcade.game('g2048', {
  name: '2048', color: '#F2B179',
  desc: 'Junta números iguais e chega ao 2048. Tem desfazer, continua depois de ganhares e guarda o teu recorde.',
  build(win) {
    const A = Arcade.shell(win, { id: 'g2048', name: '2048', color: '#F2B179', pausable: false, onRestart: () => start() });
    const board = UI.el('<div class="tw-board"></div>');
    A.el.stage.appendChild(board);
    /* um so botao com glifo + rotulo: a seta solta ao lado de "Desfazer" lia-se como um comando a parte */
    A.el.ctl.innerHTML = `<div class="gm-row wide"><div class="gb lbl undo undo-l">${UI.g('arrowL')}Desfazer</div></div>`;
    A.setMid('<span class="gm-hint">Desliza para juntar</span>');

    let grid, over, won, keepGoing, prev = null;
    const idx = (r, c) => r * 4 + c;
    const empty = () => { const o = []; for (let i = 0; i < 16; i++) if (!grid[i]) o.push(i); return o; };
    const add = () => { const e = empty(); if (!e.length) return -1; const at = e[(Math.random() * e.length) | 0]; grid[at] = Math.random() < 0.9 ? 2 : 4; return at; };

    /* as células do fundo são fixas: criadas UMA vez, só as peças é que mudam */
    const cells = UI.el('<div class="tw-cells"></div>');
    for (let i = 0; i < 16; i++) cells.appendChild(UI.el('<div class="tw-cell"></div>'));
    board.appendChild(cells);
    const tiles = UI.el('<div class="tw-tiles"></div>');
    board.appendChild(tiles);

    const paint = fresh => {
      tiles.innerHTML = '';
      grid.forEach((v, i) => {
        if (!v) return;
        const r = (i / 4) | 0, c = i % 4;
        const t = UI.el(`<div class="tw-tile v${v > 2048 ? 'x' : v}${i === fresh ? ' pop' : ''}">${v}</div>`);
        t.style.transform = `translate(${c * 96}px, ${r * 96}px)`;
        tiles.appendChild(t);
      });
      A.el.ctl.querySelectorAll('.undo, .undo-l').forEach(e => e.classList.toggle('off', !prev));
    };

    const slide = row => {
      const a = row.filter(Boolean);
      let gained = 0;
      for (let i = 0; i < a.length - 1; i++) {
        if (a[i] === a[i + 1]) { a[i] *= 2; gained += a[i]; if (a[i] === 2048) won = true; a.splice(i + 1, 1); }
      }
      while (a.length < 4) a.push(0);
      return { a, gained };
    };
    const canMove = () => {
      if (empty().length) return true;
      for (let r = 0; r < 4; r++) for (let c = 0; c < 4; c++) {
        const v = grid[idx(r, c)];
        if (c < 3 && grid[idx(r, c + 1)] === v) return true;
        if (r < 3 && grid[idx(r + 1, c)] === v) return true;
      }
      return false;
    };

    const move = d => {
      if (over) return;
      const before = grid.slice(), beforeScore = A.score;
      let gained = 0;
      for (let i = 0; i < 4; i++) {
        const line = [];
        for (let j = 0; j < 4; j++) line.push(d === 'l' || d === 'r' ? grid[idx(i, j)] : grid[idx(j, i)]);
        if (d === 'r' || d === 'd') line.reverse();
        const res = slide(line); gained += res.gained;
        let out = res.a;
        if (d === 'r' || d === 'd') out = out.slice().reverse();
        for (let j = 0; j < 4; j++) { if (d === 'l' || d === 'r') grid[idx(i, j)] = out[j]; else grid[idx(j, i)] = out[j]; }
      }
      if (grid.join(',') === before.join(',')) return;
      prev = { grid: before, score: beforeScore };
      if (gained) A.setScore(A.score + gained);
      const fresh = add();
      paint(fresh);
      Sound.play('click');
      if (won && !keepGoing) {
        keepGoing = true;
        UI.confirm('2048!', 'Chegaste ao 2048. Queres continuar a jogar?', 'Continuar').then(ok => { if (!ok) { over = true; A.gameOver('Ganhaste', `${A.score} pontos`); } });
        return;
      }
      if (!canMove()) { over = true; A.gameOver('Sem jogadas', `${A.score} pontos`); }
    };

    const undo = () => {
      if (!prev) return;
      grid = prev.grid.slice(); A.setScore(prev.score); prev = null; over = false;
      A.el.over.classList.remove('in');
      paint(); Sound.play('click');
    };
    A.el.ctl.querySelectorAll('.undo, .undo-l').forEach(e => { e.onclick = undo; });

    const start = () => { grid = new Array(16).fill(0); over = false; won = false; keepGoing = false; prev = null; A.setScore(0); add(); paint(add()); };
    Arcade.dirs(board, move);
    /* teclado (harness e quem joga com teclado no CEF) */
    /* o listener e global ao documento: em segundo plano (outra app a frente, telemovel guardado)
       as setas moviam o tabuleiro escondido, tocavam o som e roubavam o preventDefault a quem
       estivesse a escrever noutra app - g segue os pause/resume que o System ja chama */
    let bg = false;
    const onKey = e => { if (bg) return; const m = { ArrowLeft: 'l', ArrowRight: 'r', ArrowUp: 'u', ArrowDown: 'd' }[e.key]; if (m) { e.preventDefault(); move(m); } };
    document.addEventListener('keydown', onKey);
    win.onClose = () => document.removeEventListener('keydown', onKey);
    start();
    return { pause() { bg = true; }, resume() { bg = false; } };
  },
});

/* =====================================================================
   3. BLOCOS (Tetris)
   ===================================================================== */
Icons.app.blocks = () => Icons.SVG(Icons.G('gBl', '#3E3E44', '#1C1C1E', '#0A0A0B') + Icons.GL(
  `<rect x="18" y="22" width="20" height="20" rx="3" fill="#00C7BE"/><rect x="38" y="22" width="20" height="20" rx="3" fill="#00C7BE"/>` +
  `<rect x="58" y="22" width="20" height="20" rx="3" fill="#00C7BE"/><rect x="38" y="42" width="20" height="20" rx="3" fill="#BF5AF2"/>` +
  `<rect x="18" y="62" width="20" height="20" rx="3" fill="#FF9F0A"/><rect x="38" y="62" width="20" height="20" rx="3" fill="#FF9F0A"/>` +
  `<rect x="58" y="62" width="20" height="20" rx="3" fill="#FFD60A"/>`));

Arcade.game('blocks', {
  name: 'Blocos', color: '#00C7BE',
  desc: 'Encaixa as peças e fecha linhas. Tem peça seguinte, peça reservada, sombra de queda e níveis que aceleram.',
  build(win) {
    const W = 10, H = 18, CELL = 28, PAD = 1;   /* 280×504: tela + gap 12 + painel 92 = 384 dos 440 pt (28 de margem de cada lado) num palco de 695 de altura */
    const A = Arcade.shell(win, {
      id: 'blocks', name: 'Blocos', color: '#00C7BE',
      onRestart: () => start(), onPause: () => L.stop(), onResume: () => L.start(),
    });
    const stage = UI.el(`<div class="bl-stage"><canvas class="gm-cv" width="${W * CELL}" height="${H * CELL}"></canvas>
      <div class="bl-side"><div class="bl-box"><span>Seguinte</span><canvas class="nx" width="72" height="56"></canvas></div>
        <div class="bl-box"><span>Reserva</span><canvas class="hd" width="72" height="56"></canvas></div>
        <div class="bl-box st"><span>Linhas</span><b class="ln">0</b></div></div></div>`);
    A.el.stage.appendChild(stage);
    const cv = stage.querySelector('.gm-cv'), ctx = cv.getContext('2d');
    const nxc = stage.querySelector('.nx').getContext('2d'), hdc = stage.querySelector('.hd').getContext('2d');

    A.el.ctl.innerHTML = `<div class="gm-row">${Arcade.btn('l', 'chevL')}${Arcade.btn('rot', 'rotate', 20)}${Arcade.btn('r', 'chevR')}${Arcade.btn('dn', 'chevD')}${Arcade.btn('hold', 'bookmark', 19)}${Arcade.btn('drop', 'arrowDown')}</div>`;

    const P = [
      { c: '#00C7BE', s: [[1, 1, 1, 1]] },
      { c: '#FFD60A', s: [[1, 1], [1, 1]] },
      { c: '#BF5AF2', s: [[0, 1, 0], [1, 1, 1]] },
      { c: '#30D158', s: [[0, 1, 1], [1, 1, 0]] },
      { c: '#FF453A', s: [[1, 1, 0], [0, 1, 1]] },
      { c: '#0A84FF', s: [[1, 0, 0], [1, 1, 1]] },
      { c: '#FF9F0A', s: [[0, 0, 1], [1, 1, 1]] },
    ];
    let grid, cur, px, py, acc, lines, level, dead, nextP, holdP, holdUsed, bag = [];

    /* saco de 7: sequência justa, como no Tetris a sério (evita 10 peças iguais seguidas) */
    const take = () => {
      if (!bag.length) { bag = P.map((p, i) => i); for (let i = bag.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = bag[i]; bag[i] = bag[j]; bag[j] = t; } }
      return P[bag.pop()];
    };
    const spawn = piece => {
      cur = piece || nextP || take();
      if (!piece) nextP = take();
      px = ((W - cur.s[0].length) / 2) | 0; py = 0; holdUsed = false;
      paintSide();
      if (hit(cur.s, px, py)) { dead = true; L.stop(); A.gameOver('Sem espaço', `${lines} linhas · nível ${level}`); }
    };
    const hit = (s, ox, oy) => {
      for (let y = 0; y < s.length; y++) for (let x = 0; x < s[y].length; x++) {
        if (!s[y][x]) continue;
        const gx = ox + x, gy = oy + y;
        if (gx < 0 || gx >= W || gy >= H) return true;
        if (gy >= 0 && grid[gy][gx]) return true;
      }
      return false;
    };
    const merge = () => {
      cur.s.forEach((row, y) => row.forEach((v, x) => { if (v && py + y >= 0) grid[py + y][px + x] = cur.c; }));
      let cleared = 0;
      for (let y = H - 1; y >= 0; y--) {
        if (grid[y].every(Boolean)) { grid.splice(y, 1); grid.unshift(new Array(W).fill(0)); cleared++; y++; }
      }
      if (cleared) {
        lines += cleared;
        A.setScore(A.score + [0, 40, 100, 300, 1200][cleared] * level);
        level = 1 + ((lines / 10) | 0);
        stage.querySelector('.ln').textContent = lines;
        A.setMid(`<span class="gm-hint">Nível ${level}</span>`);
        Sound.play('success');
        if (cleared === 4) UI.toast('Tetris! +' + (1200 * level));
      }
      spawn();
    };
    const rot = () => {
      const s = cur.s, n = s.length, m = s[0].length;
      const out = [];
      for (let x = 0; x < m; x++) { const row = []; for (let y = n - 1; y >= 0; y--) row.push(s[y][x]); out.push(row); }
      /* `dirty` (declarado com o ciclo, mais abaixo): quem mexe a peça pede o próximo quadro - o
         ciclo já não redesenha 60×/s um tabuleiro que não mudou */
      for (const dx of [0, -1, 1, -2, 2]) if (!hit(out, px + dx, py)) { cur = { c: cur.c, s: out }; px += dx; dirty = true; return; }
    };
    const move = dx => { if (!A.paused && !hit(cur.s, px + dx, py)) { px += dx; dirty = true; } };
    const down = () => { dirty = true; if (!hit(cur.s, px, py + 1)) { py++; return true; } merge(); return false; };
    const hardDrop = () => { if (A.paused) return; let n = 0; while (!hit(cur.s, px, py + 1)) { py++; n++; } A.setScore(A.score + n * 2); merge(); dirty = true; };
    const hold = () => {
      if (A.paused || holdUsed) return;
      const keep = { c: cur.c, s: cur.s };
      if (holdP) { const h = holdP; holdP = keep; spawn(h); } else { holdP = keep; spawn(); }
      holdUsed = true; paintSide(); dirty = true; Sound.play('click');
    };

    const c = k => A.el.ctl.querySelector('.gb.' + k);
    c('l').onclick = () => move(-1);
    c('r').onclick = () => move(1);
    c('rot').onclick = () => { if (!A.paused) { rot(); Sound.play('click'); } };
    c('dn').onclick = () => { if (!A.paused) down(); };
    c('hold').onclick = hold;
    c('drop').onclick = hardDrop;
    Arcade.dirs(cv, d => { if (A.paused) return; if (d === 'l') move(-1); else if (d === 'r') move(1); else if (d === 'd') hardDrop(); else rot(); });

    const mini = (c2, piece) => {
      c2.clearRect(0, 0, 72, 56);
      if (!piece) return;
      const s = piece.s, w = s[0].length, h = s.length, cs = 13;
      const ox = (72 - w * cs) / 2, oy = (56 - h * cs) / 2;
      c2.fillStyle = piece.c;
      s.forEach((row, y) => row.forEach((v, x) => { if (v) c2.fillRect(ox + x * cs + 1, oy + y * cs + 1, cs - 2, cs - 2); }));
    };
    const paintSide = () => { mini(nxc, nextP); mini(hdc, holdP); };

    const draw = () => {
      ctx.fillStyle = '#0B0B0D'; ctx.fillRect(0, 0, W * CELL, H * CELL);
      ctx.strokeStyle = 'rgba(255,255,255,.05)'; ctx.lineWidth = 1;
      for (let x = 1; x < W; x++) { ctx.beginPath(); ctx.moveTo(x * CELL + .5, 0); ctx.lineTo(x * CELL + .5, H * CELL); ctx.stroke(); }
      for (let y = 1; y < H; y++) { ctx.beginPath(); ctx.moveTo(0, y * CELL + .5); ctx.lineTo(W * CELL, y * CELL + .5); ctx.stroke(); }
      for (let y = 0; y < H; y++) for (let x = 0; x < W; x++) {
        if (!grid[y][x]) continue;
        ctx.fillStyle = grid[y][x]; ctx.fillRect(x * CELL + PAD, y * CELL + PAD, CELL - PAD * 2, CELL - PAD * 2);
        ctx.fillStyle = 'rgba(255,255,255,.16)'; ctx.fillRect(x * CELL + PAD, y * CELL + PAD, CELL - PAD * 2, 3);
      }
      let gy = py; while (!hit(cur.s, px, gy + 1)) gy++;
      ctx.fillStyle = 'rgba(255,255,255,.12)';
      cur.s.forEach((row, y) => row.forEach((v, x) => { if (v) ctx.fillRect((px + x) * CELL + PAD, (gy + y) * CELL + PAD, CELL - PAD * 2, CELL - PAD * 2); }));
      cur.s.forEach((row, y) => row.forEach((v, x) => {
        if (!v || py + y < 0) return;
        ctx.fillStyle = cur.c; ctx.fillRect((px + x) * CELL + PAD, (py + y) * CELL + PAD, CELL - PAD * 2, CELL - PAD * 2);
        ctx.fillStyle = 'rgba(255,255,255,.2)'; ctx.fillRect((px + x) * CELL + PAD, (py + y) * CELL + PAD, CELL - PAD * 2, 3);
      }));
    };

    /* mesma marca de sujo do Snake: a peça cai 1,6 a 12 vezes por segundo e o ciclo corre a 60 fps
       - o resto das repinturas (200 fillRect da grelha + a peça + a sombra) era trabalho repetido.
       Quem mexe a peça marca `dirty` (ver `mexeu`, usado nos comandos). */
    let dirty = false;
    const L = Arcade.loop(dt => {
      if (dead) return;
      acc += dt;
      const iv = Math.max(0.08, 0.62 - (level - 1) * 0.055);
      while (acc >= iv) { acc -= iv; down(); dirty = true; if (dead) return; }
      if (dirty) { dirty = false; draw(); }
    });
    const start = () => {
      grid = []; for (let y = 0; y < H; y++) grid.push(new Array(W).fill(0));
      acc = 0; lines = 0; level = 1; dead = false; nextP = null; holdP = null; holdUsed = false; bag = [];
      stage.querySelector('.ln').textContent = '0';
      A.setScore(0); A.setMid('<span class="gm-hint">Nível 1</span>');
      spawn(); paintSide(); draw(); L.start();
    };
    start();
    win.onClose = () => L.stop();
    return { pause: () => L.stop(), resume: () => { if (!dead && !A.paused) { dirty = true; L.start(); } } };
  },
});

/* =====================================================================
   4. MINAS (Minesweeper)
   ===================================================================== */
Icons.app.mines = () => Icons.SVG(Icons.G('gMi', '#B4B4BA', '#77777D', '#4B4B50') + Icons.GL(
  `<circle cx="50" cy="54" r="20" fill="#1C1C1E"/><rect x="46" y="22" width="8" height="16" rx="3" fill="#1C1C1E"/>` +
  `<rect x="18" y="50" width="64" height="8" rx="4" fill="#1C1C1E" opacity=".55"/><circle cx="43" cy="47" r="5" fill="#fff" opacity=".7"/>`));

Arcade.game('mines', {
  name: 'Minas', color: '#8E8E93', lowerIsBetter: true, unit: 'segundos',
  desc: 'Descobre o campo sem tocar numa mina. Três dificuldades, modo bandeira e abertura automática à volta dos números.',
  build(win) {
    const LV = { facil: { n: 9, m: 10, label: 'Fácil' }, medio: { n: 12, m: 22, label: 'Médio' }, dificil: { n: 14, m: 38, label: 'Difícil' } };
    let lvKey = 'facil';
    { const s = Arcade.opt('mines:lv', ''); if (s && LV[s]) lvKey = s; }

    const A = Arcade.shell(win, {
      id: 'mines:' + lvKey, name: 'Minas', color: '#8E8E93', pausable: false,
      scoreLabel: 'Tempo', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => start(),
    });
    const board = UI.el('<div class="mn-board"></div>');
    A.el.stage.appendChild(board);
    A.el.ctl.innerHTML = `<div class="gm-row wide">${Arcade.btn('flag', 'flag', 19)}<div class="gb lbl lv">Fácil</div></div>`;

    let N, MINES, cells, opened, flags, dead, won, t0, timer = null, started, flagMode = false;
    const g = UI.g;

    const around = i => {
      const r = (i / N) | 0, c = i % N, out = [];
      for (let dr = -1; dr <= 1; dr++) for (let dc = -1; dc <= 1; dc++) {
        if (!dr && !dc) continue;
        const nr = r + dr, nc = c + dc;
        if (nr >= 0 && nc >= 0 && nr < N && nc < N) out.push(nr * N + nc);
      }
      return out;
    };
    const build = first => {
      const safe = around(first).concat([first]);
      let placed = 0;
      while (placed < MINES) {
        const i = (Math.random() * N * N) | 0;
        if (cells[i].mine || safe.indexOf(i) > -1) continue;
        cells[i].mine = true; placed++;
      }
      cells.forEach((c, i) => { if (!c.mine) c.n = around(i).filter(j => cells[j].mine).length; });
    };
    /* ⚠️ ESCAVAR E PINTAR SÃO COISAS DIFERENTES.
       O `open()` recursivo chamava `paint()` em CADA casa que abria: um clique numa zona vazia de
       um tabuleiro 16×16 reconstruía as 256 células dezenas de vezes seguidas (innerHTML + 256
       elementos + os ouvintes de cada um, por casa aberta). Agora a inundação só mexe nos dados
       (`dig`) e pinta-se UMA vez no fim da ação do jogador (`settle`). */
    const dig = i => {
      const c = cells[i];
      if (c.open || c.flag || dead || won) return;
      c.open = true; opened++;
      if (c.mine) { dead = true; stopT(); cells.forEach(x => { if (x.mine) x.open = true; }); return; }
      if (c.n === 0) around(i).forEach(dig);
    };
    const settle = () => {
      if (dead) { paint(); A.gameOver('Boom', `Abriste ${opened} casas`, 0); return; }
      if (opened === N * N - MINES) {
        won = true; stopT();
        const secs = ((Date.now() - t0) / 1000) | 0;
        A.setScore(secs); paint(); A.gameOver('Campo limpo!', `${secs} segundos · ${LV[lvKey].label}`, secs);
        return;
      }
      paint();
    };
    const open = i => { if (dead || won) return; const c = cells[i]; if (!c || c.open || c.flag) return; dig(i); settle(); };
    /* tocar num número já aberto com as bandeiras todas postas abre a vizinhança */
    const chord = i => {
      const c = cells[i];
      if (!c.open || !c.n || dead || won) return;
      const ns = around(i);
      if (ns.filter(j => cells[j].flag).length !== c.n) return;
      ns.forEach(j => { if (!cells[j].flag) dig(j); });
      settle();
    };
    const flag = i => {
      const c = cells[i];
      if (c.open || dead || won) return;
      c.flag = !c.flag; flags += c.flag ? 1 : -1;
      mid(); Sound.play('click'); paint();
    };
    const mid = () => A.setMid(`<span class="gm-hint">${g('flag', 18)} ${MINES - flags}</span>`);

    /* as casas sao criadas UMA vez por tabuleiro (buildBoard, chamado no start porque N muda com a
       dificuldade) e o paint so toca nas que mudaram. Antes, cada bandeira ou casa aberta reconstruia
       as NxN casas por innerHTML - 196 elementos + 7 ouvintes cada no Dificil, por clique. */
    let els = [];
    const cellCls = c => 'mn-c' + (c.open ? ' op' : '') + (c.flag ? ' fl' : '') + (c.open && c.mine ? ' bomb' : '');
    const cellHtml = c => c.open ? (c.mine ? g('x', 21) : String(c.n || '')) : (c.flag ? g('flag', 19) : '');
    const buildBoard = () => {
      const frag = document.createDocumentFragment(); els = [];
      cells.forEach((c, i) => {
        const d = UI.el('<div class="mn-c"></div>');
        d.onclick = () => {
          if (dead || won) return;
          if (!started) { build(i); started = true; t0 = Date.now(); startT(); }
          if (c.open) { chord(i); return; }
          if (flagMode) flag(i); else open(i);
        };
        /* toque longo: bandeira numa casa fechada, abertura a volta numa casa ja aberta */
        UI.longPress(d, () => { if (cells[i].open) chord(i); else flag(i); });
        els.push(d); frag.appendChild(d);
      });
      board.innerHTML = ''; board.appendChild(frag);
    };
    const paint = () => {
      cells.forEach((c, i) => {
        const d = els[i], cls = cellCls(c), h = cellHtml(c);
        if (d.className !== cls) d.className = cls;
        if (d.dataset.n !== String(c.n)) d.dataset.n = c.n;
        if (d._h !== h) { d._h = h; d.innerHTML = h; }
      });
    };
    const startT = () => { stopT(); timer = setInterval(() => { if (!dead && !won) A.setScore(((Date.now() - t0) / 1000) | 0); }, 1000); win.timers.push(timer); };
    const stopT = () => { clearInterval(timer); timer = null; };

    const start = () => {
      const L = LV[lvKey]; N = L.n; MINES = L.m;
      A.setId('mines:' + lvKey);   /* o recorde é por dificuldade */
      board.style.setProperty('--mn-n', N); board.dataset.lv = lvKey;   /* tamanho do algarismo/glifo por dificuldade (app-games.css) */
      cells = new Array(N * N).fill(0).map(() => ({ mine: false, n: 0, open: false, flag: false }));
      opened = 0; flags = 0; dead = false; won = false; started = false; t0 = Date.now(); stopT();
      A.setScore(0); mid(); buildBoard(); paint();
      A.el.ctl.querySelector('.lv').textContent = L.label;
      A.el.ctl.querySelector('.gb.flag').classList.toggle('on', flagMode);
    };
    A.el.ctl.querySelector('.gb.flag').onclick = () => {
      flagMode = !flagMode;
      A.el.ctl.querySelector('.gb.flag').classList.toggle('on', flagMode);
      Sound.play('click');
    };
    A.el.ctl.querySelector('.lv').onclick = async () => {
      const r = await UI.actionSheet({ title: 'Dificuldade', buttons: Object.keys(LV).map(k => ({ label: `${LV[k].label} · ${LV[k].n}×${LV[k].n}, ${LV[k].m} minas`, value: k })) });
      if (!r) return;
      lvKey = r; Arcade.setOpt('mines:lv', r);
      UI.toast('Recorde guardado por dificuldade');
      start();
    };
    start();
    win.onClose = stopT;
    return { pause: stopT, resume: () => { if (started && !dead && !won) startT(); } };
  },
});

/* =====================================================================
   5. BREAK (Breakout)
   ===================================================================== */
Icons.app.brick = () => Icons.SVG(Icons.G('gBr', '#6CB8FF', '#2A8BFF', '#0F63EA') + Icons.GL(
  `<rect x="16" y="20" width="20" height="10" rx="3" fill="#FF453A"/><rect x="40" y="20" width="20" height="10" rx="3" fill="#FF9F0A"/>` +
  `<rect x="64" y="20" width="20" height="10" rx="3" fill="#FFD60A"/><rect x="28" y="34" width="20" height="10" rx="3" fill="#30D158"/>` +
  `<rect x="52" y="34" width="20" height="10" rx="3" fill="#BF5AF2"/><circle cx="50" cy="62" r="7" fill="#fff"/>` +
  `<rect x="32" y="76" width="36" height="8" rx="4" fill="#fff"/>`));

Arcade.game('brick', {
  name: 'Break', color: '#0A84FF',
  desc: 'Parte todos os tijolos sem deixar cair a bola. Tem tijolos resistentes, bónus que caem e níveis sem fim.',
  build(win) {
    const W = 390, H = 560;   /* 390x560: 25 pt de margem lateral (como as Minas e o 2048) e o palco de 695 pt bem ocupado */
    const A = Arcade.shell(win, {
      id: 'brick', name: 'Break', color: '#0A84FF',
      onRestart: () => start(), onPause: () => L.stop(), onResume: () => L.start(),
    });
    const cv = UI.el(`<canvas class="gm-cv" width="${W}" height="${H}"></canvas>`);
    A.el.stage.appendChild(cv);
    const ctx = cv.getContext('2d');
    const COLS = ['#FF453A', '#FF9F0A', '#FFD60A', '#30D158', '#BF5AF2'];
    const BONUS = { wide: '#30D158', slow: '#0A84FF', life: '#FF375F', multi: '#5E5CE6' };
    const MAX_BALLS = 5;   /* o bonus roxo parte cada bola em duas; mais do que isto e so confusao no ecra */
    let bricks, balls, pad, lives, dead, level, started, drops, effTime, padDirty = true;   /* padDirty: a espera do lancamento so se redesenha quando a raquete mudou */

    const makeBricks = () => {
      bricks = [];
      const rows = Math.min(6, 3 + ((level / 2) | 0)), cols = 7, bw = (W - 19) / cols, bh = 18;   /* 7 tijolos de 48 + 6 vaos de 5 = 366 = W - 24: 12 pt de margem dos dois lados, sem meios-pixeis */
      for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) {
        const hard = level > 2 && r === 0 && ((c + level) % 3 === 0);
        bricks.push({ x: 12 + c * bw, y: 58 + r * (bh + 6), w: bw - 5, h: bh, c: COLS[r % COLS.length], hp: hard ? 2 : 1 });
      }
    };
    const reset = () => {
      pad = { x: W / 2 - 36, w: 72, h: 10 };
      balls = [{ x: W / 2, y: H - 70, vx: 0, vy: 0, r: 6 }];   /* varias bolas: o bonus multi acrescenta-lhes */
      started = false; drops = []; effTime = 0; padDirty = true;
      hud();
    };
    const hud = () => A.setMid(`<span class="gm-hint">${A.hearts(lives, 3)} · nível ${level}</span>`);
    const launch = () => { if (started || A.paused) return; started = true; const b = balls[0]; if (b) { b.vx = (Math.random() < .5 ? -1 : 1) * 140; b.vy = -250; } };
    const start = () => { level = 1; lives = 3; dead = false; A.setScore(0); makeBricks(); reset(); L.start(); };

    /* CONTROLO - três formas, porque só o arrasto em cima da tela era apertado:
       1) arrastar em QUALQUER ponto do palco (a área toda à volta da tela conta);
       2) botões ◀ ▶ para quem prefere tocar;
       3) setas do teclado.
       A posição é sempre convertida pela largura REAL da tela (aguenta o zoom do ecrã). */
    let drag = false;
    const setPad = x => { pad.x = Math.max(0, Math.min(W - pad.w, x - pad.w / 2)); if (!started && balls[0]) balls[0].x = pad.x + pad.w / 2; padDirty = true; };
    /* a tela NÃO se mexe durante o arrasto: mede-se uma vez por arrasto. Ler
       getBoundingClientRect a cada pointermove forçava um layout do documento por evento, ao lado
       de um rAF que estava a desenhar - era o pior par possível. */
    let padRect = null;
    const movePad = e => {
      if (!padRect || !padRect.width) padRect = cv.getBoundingClientRect();
      if (!padRect.width) { padRect = null; return; }
      setPad((e.clientX - padRect.left) / (padRect.width / W));
    };
    const zone = A.el.stage;
    zone.style.touchAction = 'none';
    zone.addEventListener('pointerdown', e => { padRect = null; drag = true; try { zone.setPointerCapture(e.pointerId); } catch (x) {} movePad(e); launch(); });
    zone.addEventListener('pointermove', e => { if (drag) movePad(e); });
    const upPad = () => { drag = false; };
    zone.addEventListener('pointerup', upPad);
    zone.addEventListener('pointercancel', upPad);

    A.el.ctl.innerHTML = `<div class="gm-row">${Arcade.btn('l', 'chevL')}${Arcade.btn('go', 'play', 20)}${Arcade.btn('r', 'chevR')}</div>`;
    let held = null;
    const nudge = d => { if (A.paused || dead) return; setPad(pad.x + pad.w / 2 + d * 26); };
    ['l', 'r'].forEach(k => {
      const b = A.el.ctl.querySelector('.gb.' + k), d = k === 'l' ? -1 : 1;
      b.addEventListener('pointerdown', () => { clearInterval(held); nudge(d); held = setInterval(() => nudge(d), 60); win.timers.push(held); });
      const stop = () => { clearInterval(held); held = null; };
      b.addEventListener('pointerup', stop); b.addEventListener('pointercancel', stop); b.addEventListener('pointerleave', stop);
    });
    A.el.ctl.querySelector('.gb.go').onclick = () => launch();
    /* o ouvinte é global ao documento e vive até a app ser morta: com o Break em segundo plano as setas
       mexiam a raquete escondida e o preventDefault do Espaço/Enter comia essas teclas a quem escrevia
       noutra app (Mensagens, Notas…). Mesmo travão do 2048: `bg` segue o pause/resume do System. */
    let bg = false;
    const onKey = e => {
      if (bg) return;
      if (e.key === 'ArrowLeft') { e.preventDefault(); nudge(-1); }
      else if (e.key === 'ArrowRight') { e.preventDefault(); nudge(1); }
      else if (e.key === ' ' || e.key === 'Enter') { e.preventDefault(); launch(); }
    };
    document.addEventListener('keydown', onKey);

    const loseLife = () => {
      lives--;
      if (lives <= 0) { dead = true; L.stop(); A.gameOver('Perdeste', `${A.score} pontos · nível ${level}`); return; }
      reset(); Sound.play('error');
    };
    const applyBonus = k => {
      if (k === 'wide') { pad.w = Math.min(140, pad.w + 34); effTime = 12; }
      else if (k === 'slow') balls.forEach(b => { const s = Math.hypot(b.vx, b.vy) || 1; const f = Math.max(150, s * .7) / s; b.vx *= f; b.vy *= f; });
      else if (k === 'life') { lives = Math.min(3, lives + 1); }
      else if (k === 'multi') {
        /* AS BOLAS MULTIPLICAM-SE: cada uma em jogo da origem a outra, com o angulo desviado meio
           radiano para nao seguirem coladas. Guarda-se a velocidade (nunca zero, senao a bola nova
           nascia parada) e o total nao passa de MAX_BALLS. */
        const novas = [];
        for (const b of balls) {
          if (balls.length + novas.length >= MAX_BALLS) break;
          const sp = Math.hypot(b.vx, b.vy) || 250;
          const ang = Math.atan2(b.vx, -b.vy) + (Math.random() < .5 ? -.5 : .5);
          novas.push({ x: b.x, y: b.y, vx: Math.sin(ang) * sp, vy: -Math.cos(ang) * sp, r: b.r });
        }
        balls.push(...novas);
      }
      hud(); Sound.play('success'); UI.toast({ wide: 'Raquete maior', slow: 'Bola lenta', life: 'Vida extra', multi: 'Bolas a dobrar' }[k]);
    };

    /* uma bola: move, bate nas paredes/raquete/tijolos. Devolve 'perdeu' (saiu por baixo),
       'nivel' (derrubou o último tijolo) ou null. Separada porque agora há VÁRIAS bolas. */
    const stepBall = (ball, dt) => {
      ball.x += ball.vx * dt; ball.y += ball.vy * dt;
      if (ball.x < ball.r) { ball.x = ball.r; ball.vx *= -1; }
      if (ball.x > W - ball.r) { ball.x = W - ball.r; ball.vx *= -1; }
      if (ball.y < ball.r) { ball.y = ball.r; ball.vy *= -1; }
      const py = H - 34;
      if (ball.vy > 0 && ball.y + ball.r >= py && ball.y < py + 18 && ball.x > pad.x && ball.x < pad.x + pad.w) {
        ball.y = py - ball.r;
        const rel = (ball.x - (pad.x + pad.w / 2)) / (pad.w / 2);
        const sp = Math.min(440, Math.hypot(ball.vx, ball.vy) * 1.025);
        const ang = rel * 1.05;
        ball.vx = Math.sin(ang) * sp; ball.vy = -Math.cos(ang) * sp;
        Sound.play('click');
      }
      for (const b of bricks) {
        if (!b.hp) continue;
        if (ball.x > b.x - ball.r && ball.x < b.x + b.w + ball.r && ball.y > b.y - ball.r && ball.y < b.y + b.h + ball.r) {
          b.hp--; A.setScore(A.score + (b.hp ? 5 : 10));
          const fromSide = ball.x < b.x || ball.x > b.x + b.w;
          if (fromSide) ball.vx *= -1; else ball.vy *= -1;
          Sound.play('click');
          if (!b.hp && Math.random() < .12) {
            const keys = Object.keys(BONUS);
            drops.push({ x: b.x + b.w / 2, y: b.y + b.h / 2, k: keys[(Math.random() * keys.length) | 0] });
          }
          if (!bricks.some(x => x.hp)) return 'nivel';
          break;
        }
      }
      return ball.y > H + 20 ? 'perdeu' : null;
    };

    /* corpo do ciclo em função própria: o Arcade.loop chama-a por frame e o harness
       pode chamá-la com um dt fixo (no headless o relógio fica a 0 e nada se mexia) */
    const tick = dt => {
      if (dead) return;
      /* a espera do lancamento nada se mexe a nao ser a raquete: sem mudanca, sem repintura */
      if (!started && !padDirty) return;
      padDirty = false;
      if (started) {
        if (effTime > 0) { effTime -= dt; if (effTime <= 0) pad.w = 72; }
        /* uma passagem por BOLA (podem ser várias, com o bónus roxo): devolve 'perdeu' quando a bola
           sai por baixo e 'nivel' quando foi ela a derrubar o último tijolo. */
        let recomecou = false;
        for (let i = balls.length - 1; i >= 0 && !recomecou; i--) {
          const r = stepBall(balls[i], dt);
          if (r === 'nivel') { level++; A.setScore(A.score + 100); makeBricks(); reset(); UI.toast('Nível ' + level); recomecou = true; }
          else if (r === 'perdeu') balls.splice(i, 1);
        }
        /* só se perde uma vida quando cai a ÚLTIMA bola - é isso que faz o bónus valer a pena */
        if (!recomecou && !balls.length) { loseLife(); recomecou = true; }
        if (!recomecou) for (let i = drops.length - 1; i >= 0; i--) {
          const d = drops[i]; d.y += 130 * dt;
          if (d.y > H) { drops.splice(i, 1); continue; }
          if (d.y > H - 40 && d.x > pad.x && d.x < pad.x + pad.w) { applyBonus(d.k); drops.splice(i, 1); }
        }
      } else if (balls[0]) { balls[0].x = pad.x + pad.w / 2; balls[0].y = H - 70; }

      ctx.fillStyle = '#0B1220'; ctx.fillRect(0, 0, W, H);
      bricks.forEach(b => {
        if (!b.hp) return;
        ctx.fillStyle = b.hp > 1 ? '#8E8E93' : b.c;
        ctx.fillRect(b.x, b.y, b.w, b.h);
        ctx.fillStyle = 'rgba(255,255,255,.18)'; ctx.fillRect(b.x, b.y, b.w, 3);
      });
      drops.forEach(d => { ctx.fillStyle = BONUS[d.k]; ctx.beginPath(); ctx.arc(d.x, d.y, 7, 0, 6.2832); ctx.fill(); });
      ctx.fillStyle = '#fff';
      ctx.fillRect(pad.x, H - 34, pad.w, pad.h);
      balls.forEach(b => { ctx.beginPath(); ctx.arc(b.x, b.y, b.r, 0, 6.2832); ctx.fill(); });
      if (!started) { ctx.fillStyle = 'rgba(255,255,255,.5)'; ctx.font = '600 17px Inter, sans-serif'; ctx.textAlign = 'center'; ctx.fillText(window.L && L.t ? L.t('toca para lançar') : 'toca para lançar', W / 2, H - 92); }   /* desenhado na tela: o tradutor do DOM não chega lá */
    };
    const L = Arcade.loop(tick);
    start();
    win.onClose = () => { L.stop(); clearInterval(held); document.removeEventListener('keydown', onKey); };
    return {
      /* a medida da tela é descartada ao voltar: entretanto o ecrã pode ter mudado de escala */
      pause: () => { bg = true; L.stop(); }, resume: () => { bg = false; padRect = null; padDirty = true; if (!dead && !A.paused) L.start(); },
      /* estado interno + passo manual para o harness (_test.html): no headless o relógio
         fica a 0, o rAF dá dt=0 e nada se mexia - com step(dt) o teste é determinístico */
      dbg: () => ({ started, padX: Math.round(pad.x), padW: pad.w, ballX: Math.round(balls[0] ? balls[0].x : 0), ballY: Math.round(balls[0] ? balls[0].y : 0), vy: Math.round(balls[0] ? balls[0].vy : 0), balls: balls.length, lives, bricks: bricks.filter(b => b.hp).length, running: L.running }),
      step: dt => tick(dt || 0.05),
      /* só para o harness: aplicar um bónus e deitar a última bola fora sem esperar pela física */
      bonus: k => applyBonus(k),
      dropBall: () => { if (balls.length) balls[balls.length - 1].y = H + 999; },
    };
  },
});

/* =====================================================================
   6. MEMÓRIA
   ===================================================================== */
Icons.app.memory = () => Icons.SVG(Icons.G('gMe', '#D9A6E8', '#BF5AF2', '#8A2BC4') + Icons.GL(
  `<rect x="16" y="20" width="30" height="38" rx="6" fill="#fff"/><rect x="54" y="20" width="30" height="38" rx="6" fill="#fff" opacity=".55"/>` +
  `<rect x="34" y="46" width="32" height="38" rx="6" fill="#fff"/><path d="M44 62l6 6 10-12" stroke="#BF5AF2" stroke-width="5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>`));

Arcade.game('memory', {
  name: 'Memória', color: '#BF5AF2', lowerIsBetter: true, unit: 'jogadas',
  desc: 'Encontra todos os pares no menor número de jogadas. Dois tamanhos de tabuleiro e recorde por tamanho.',
  build(win) {
    const FACES = [
      ['circle', '#FF453A'], ['square', '#FF9F0A'], ['tri', '#FFD60A'], ['diamond', '#30D158'],
      ['star', '#0A84FF'], ['heart', '#FF375F'], ['ring', '#00C7BE'], ['bolt', '#BF5AF2'],
      ['circle', '#BF5AF2'], ['square', '#30D158'], ['tri', '#0A84FF'], ['diamond', '#FF453A'],
    ];
    let pairs = 8;
    { const s = parseInt(Arcade.opt('memory:pairs', ''), 10); if (s === 8 || s === 12) pairs = s; }

    const A = Arcade.shell(win, {
      id: 'memory:' + pairs, name: 'Memória', color: '#BF5AF2', pausable: false,
      scoreLabel: 'Jogadas', bestLabel: 'Melhor', lowerIsBetter: true, onRestart: () => start(),
    });
    const board = UI.el('<div class="me-board"></div>');
    A.el.stage.appendChild(board);
    A.el.ctl.innerHTML = `<div class="gm-row wide"><div class="gb lbl size">8 pares</div></div>`;

    let cards, open, moves, found, lock, t0 = 0, timer = null;
    /* relogio e intervalo sao coisas diferentes: pausar (sair da app) para o intervalo mas NAO apaga
       o t0 - antes, ao voltar, a jogada seguinte fazia `t0 = Date.now()` e o tempo recomecava do zero */
    const tickT = () => A.setMid(`<span class="gm-hint">${((Date.now() - t0) / 1000) | 0}s</span>`);
    const startT = () => { clearInterval(timer); timer = setInterval(tickT, 1000); win.timers.push(timer); };
    const stopT = () => { clearInterval(timer); timer = null; };

    /* as cartas nascem UMA vez por baralho (buildBoard) e o paint so troca classes. Reconstruir o
       tabuleiro a cada toque (innerHTML + 16-24 cartas com SVG) tinha dois custos: o trabalho em si
       e, pior, a animacao de virar NUNCA corria - um elemento novo ja nasce com .up e o transition
       do .me-c .in nao tem de onde partir. Agora a carta vira mesmo (so transform/opacity). */
    let els = [];
    const buildBoard = () => {
      const frag = document.createDocumentFragment(); els = [];
      cards.forEach((c, i) => {
        const d = UI.el(`<div class="me-c"><div class="in"><div class="b"></div><div class="f">${Arcade.sprite(c.face[0], c.face[1])}</div></div></div>`);
        d.onclick = () => flip(i);
        els.push(d); frag.appendChild(d);
      });
      board.innerHTML = ''; board.appendChild(frag);
    };
    const paint = () => {
      cards.forEach((c, i) => { els[i].classList.toggle('up', !!(c.up || c.done)); els[i].classList.toggle('done', !!c.done); });
    };
    const key = c => c.face[0] + c.face[1];
    const flip = i => {
      if (lock) return;
      const c = cards[i];
      if (c.up || c.done) return;
      if (!t0) { t0 = Date.now(); startT(); }
      c.up = true; open.push(i); paint(); Sound.play('click');
      if (open.length < 2) return;
      moves++; A.setScore(moves);
      const [a, b] = open;
      if (key(cards[a]) === key(cards[b])) {
        cards[a].done = cards[b].done = true; open = []; found++;
        Sound.play('success'); paint();
        if (found === pairs) {
          stopT();
          const secs = ((Date.now() - t0) / 1000) | 0;
          A.gameOver('Todos os pares!', `${moves} jogadas · ${secs}s`, moves);
        }
        return;
      }
      lock = true;
      setTimeout(() => { cards[a].up = cards[b].up = false; open = []; lock = false; paint(); }, 620);
    };
    const start = () => {
      stopT(); t0 = 0;
      A.setId('memory:' + pairs);   /* o recorde é por tamanho de tabuleiro */
      const set = FACES.slice(0, pairs);
      const deck = set.concat(set).map(f => ({ face: f, up: false, done: false }));
      for (let i = deck.length - 1; i > 0; i--) { const j = (Math.random() * (i + 1)) | 0; const t = deck[i]; deck[i] = deck[j]; deck[j] = t; }
      cards = deck; open = []; moves = 0; found = 0; lock = false;
      board.classList.toggle('big', pairs > 8);
      A.setScore(0); A.setMid('<span class="gm-hint">0s</span>');
      A.el.ctl.querySelector('.size').textContent = pairs + ' pares';
      buildBoard();
    };
    A.el.ctl.querySelector('.size').onclick = async () => {
      const r = await UI.actionSheet({ title: 'Tamanho', buttons: [{ label: '8 pares · 4×4', value: '8' }, { label: '12 pares · 4×6', value: '12' }] });
      if (!r) return;
      pairs = +r; Arcade.setOpt('memory:pairs', r);
      UI.toast('Recorde guardado por tamanho');
      start();
    };
    start();
    win.onClose = stopT;
    return { pause: stopT, resume: () => { if (t0 && found < pairs) startT(); } };
  },
});

/* =====================================================================
   HUB - Arcade: todos os jogos e os recordes num sítio só
   ===================================================================== */
Icons.app.arcade = () => Icons.SVG(Icons.G('gAr', '#FF9F6C', '#FF375F', '#C41E4A') + Icons.GL(
  `<rect x="16" y="34" width="68" height="40" rx="12" fill="#fff"/><circle cx="34" cy="54" r="4.5" fill="#FF375F"/>` +
  `<rect x="28" y="49.5" width="12" height="9" rx="4.5" fill="none" stroke="#FF375F" stroke-width="0"/>` +
  `<path d="M30 54h8M34 50v8" stroke="#FF375F" stroke-width="4" stroke-linecap="round"/>` +
  `<circle cx="64" cy="50" r="5" fill="#FF375F"/><circle cx="72" cy="60" r="5" fill="#FF375F"/>`));

App.define('arcade', {
  /* `hub: true` - esta app é a ESTANTE, não um jogo. Quem conta jogos pela categoria (o cartão do
     separador Arcade na AppShop dizia "7 jogos" com 6 jogos + este hub) tem aqui como o excluir. */
  name: 'Arcade', category: 'Jogos', statusBar: 'dark', hub: true,
  description: 'Todos os jogos do telemóvel num sítio só, com os teus recordes e o último que jogaste.',
  open(win) {
    const g = UI.g;
    const v = UI.view({ title: 'Arcade', large: true, cls: 'gm gm-hub' });
    const list = UI.el('<div class="hub"></div>');
    v.content.appendChild(list);

    /* O melhor recorde de um jogo. Minas e Memória gravam por dificuldade/tamanho
       ('mines:<nivel>', 'memory:<pares>') e a chave simples NUNCA é escrita neles - o contador do topo
       lia essa chave simples, por isso quem só jogasse esses dois via linhas com recorde e um
       "0 com recorde" em cima. Agora as linhas e o contador usam esta mesma função. */
    const recOf = x => {
      if (x.id === 'mines') return ['facil', 'medio', 'dificil'].reduce((r, k) => { const b = Arcade.bestLow('mines:' + k); return b && (!r || b < r) ? b : r; }, 0);
      if (x.id === 'memory') return [8, 12].reduce((r, k) => { const b = Arcade.bestLow('memory:' + k); return b && (!r || b < r) ? b : r; }, 0);
      return x.lower ? Arcade.bestLow(x.id) : Arcade.best(x.id);
    };
    const paint = () => {
      list.innerHTML = '';
      const games = Arcade.list();   /* só os jogos: este hub não está no Arcade.list() */
      const played = games.filter(x => recOf(x) > 0).length;
      list.appendChild(UI.el(`<div class="hub-top"><b>${games.length} jogos</b><span>${played} com recorde</span></div>`));
      games.forEach(x => {
        const rec = recOf(x);
        const row = UI.el(`<div class="hub-row"><div class="ic">${Icons.tile(x.id)}</div>
          <div class="bd"><b>${UI.esc(x.name)}</b><span>${rec ? `Recorde: ${rec} ${UI.esc(x.unit)}` : 'Ainda sem recorde'}</span></div>
          <div class="go">${g('play', 24)}</div></div>`);
        row.onclick = () => System.openApp(x.id);
        list.appendChild(row);
      });
      const clear = UI.el('<div class="btn-p btn-s danger-t">Apagar recordes</div>');
      clear.onclick = async () => {
        if (!await UI.confirm('Apagar recordes', 'Perdes todos os recordes desta personagem neste telemóvel.', 'Apagar', true)) return;
        Arcade.clearBest();
        paint(); UI.toast('Recordes apagados');
      };
      list.appendChild(clear);
      /* honestidade: não há tabela de pontuações no servidor (é a Fase 7) - ninguém compara recordes
         com ninguém e mudar de PC ou limpar a cache perde-os */
      list.appendChild(UI.el('<div class="group-footer">Os recordes ficam neste telemóvel, nesta personagem. Ainda não há tabela no servidor: não são comparados com os de mais ninguém.</div>'));
    };
    paint();
    UI.setRoot(win, v);
    win._paint = paint;
  },
  resume(win) { try { win._paint && win._paint(); } catch (e) {} },
});
