/* ============================================================
   CAMVIEW - a câmara do telemóvel, como MÓDULO partilhado.

   Vivia inteira dentro de App.define('camera') em apps/photos.js. O
   utilizador pediu que o Instashot tirasse fotografias "com o mesmo
   conteúdo e da mesma forma que a app Câmara" - e a única maneira de
   isso ser mesmo verdade é não haver duas câmaras: este módulo É a
   câmara, e a app Câmara e o criador de stories são dois anfitriões
   do mesmo visor.

   O que é igual nos dois (tudo o que importa):
     · o visor: uma <canvas> WebGL com a vista do JOGO (js/gamerender.js);
       a fotografia É o canvas, não um screenshot do ecrã
     · quem enquadra é a câmara scriptada do client/camera.lua (cameraMode:
       frontal/traseira com a selfie ao centro, HUD escondido, arrastar para
       apontar com o botão esquerdo dentro do visor e fora do telemóvel)
     · o obturador com o clarão, o temporizador e o shoot() com todos os
       erros nomeados; a foto sai pelo Photos.save (aos bocados) e avisa a
       galeria - fica nas Fotos como qualquer outra

   Dois "chromes":
     'phone' (por omissão) - a app Câmara inteira (.cam-app: topo com o botão
                             de diagonal, zoom 1×/2×/3×, modos, barra com
                             miniatura/obturador/virar; slider da diagonal
                             dentro do visor; dica de arrastar na 1.ª vez)
     'bare'                - SÓ o visor (.cam-app.cam-bare > .viewfinder);
                             o anfitrião desenha os botões à volta (o
                             Instashot copia o ecrã do Instagram) e chama
                             a API: shoot(), flip(), setFlash(), aim*(),
                             setZoom(z), setRoll(graus)

   Zoom e diagonal são DIGITAIS (gamerender.js setZoom/setRoll: recorte e
   rotação das UVs do visor) - por isso saem na foto tal como se veem, em
   jogo e no browser (aí a cena falsa leva o mesmo recorte por CSS).

   opts:
     chrome        'phone' | 'bare'
     aspect        rácio fixo do visor (largura/altura); sem ele, os modos decidem
     autoActivate  false → não liga o cameraMode do Lua ao montar (o Instashot
                   só liga quando o visor fica à vista) - ver setActive()
     aimInside     false → o visor não apanha o arrasto para apontar; o
                   anfitrião decide quando chamar aimStart/aimMove (o Instashot
                   usa o arrasto para CIMA para voltar à galeria)
     process(raw)  → Promise<raw>: transformar a imagem ANTES de a guardar
                   (efeitos de cor do Instashot)
     onShot(p, raw) depois de a foto sair (Instashot: abre o editor)
     onBack()      o botão ‹ (só chrome 'phone')
     onThumb()     toque na miniatura (só chrome 'phone')

   ⚠️ Lado Lua: `cameraMode` esconde o HUD e liga a câmara scriptada. Quem
   montar isto TEM de chamar destroy() em todos os caminhos de fecho
   (win.onClose, trocar de app, fechar o telemóvel) - senão o jogador fica
   sem HUD e com a câmara presa. A app Câmara resolve com killOnClose; o
   Instashot faz setActive(false)/destroy() à mão (ver stories.js).
   ============================================================ */
window.CamView = (() => {
  /* Falhas possíveis, todas com nome: "não foi possível" não diz nada a ninguém. */
  const MSG = {
    closed: 'A Câmara fechou antes do disparo',
    gl: 'O visor não arrancou (WebGL indisponível): fecha e volta a abrir a Câmara',
    magic: 'O visor ainda está à espera da imagem do jogo (fica vermelho): fecha e volta a abrir a Câmara; se continuar, escreve /camtest',
    black: 'A imagem veio preta: o jogo ainda não desenhou nada no visor; espera um instante e tenta outra vez',
    encode: 'Não foi possível codificar a foto do visor',
    shrink: 'Não foi possível reduzir a imagem',
    toolarge: 'A foto ficou demasiado grande',
    badimage: 'A imagem chegou corrompida',
    badchunk: 'Envio da foto inválido',
    rpc: 'O servidor não guardou a foto',
    internal: 'Erro no servidor ao guardar a foto (ver consola do servidor)',
    noplayer: 'Sessão do jogador não encontrada',
    timeout: 'O disparo demorou demasiado',
    empty: 'A imagem veio vazia',
    js: 'Erro de JavaScript ao tirar a foto (ver F8)'
  };

  /* glifo do botão de diagonal (o icons.js não tem um "rodar"): um quadro inclinado com uma seta em
     arco - mesmo formato do Icons.g (24×24, traço 2, currentColor) para casar com os vizinhos */
  const TILT_GLYPH = `<svg class="gl" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24"><rect x="6" y="6" width="12" height="12" rx="2" transform="rotate(-18 12 12)"/><path d="M21.5 9.5a9 9 0 0 0-3.2-4.2M21.5 5.4v4.1h-4.1"/></svg>`;
  const HINT_KEY = 'uniquephone:camHintSeen';
  const MAX_ROLL = (window.GameRender && GameRender.MAX_ROLL) || 45;

  /* ---------- ANDROID (Nova UI 8.5): a cara da câmara da Nova UI ----------
     Só para o chrome 'phone' com o sistema Android: o visor, o disparo, o zoom digital, a diagonal, a
     paisagem e o envio são os MESMOS (as fotos vão para a mesma galeria e passam entre sistemas). Muda o
     que está à volta: ícones brancos pequenos em cima (definições, flash, temporizador, proporção,
     inclinação, rodar), zoom em pílula por cima do obturador (1x, 2, 3, 5; a roda do rato faz zoom
     contínuo), carrossel de modos (Retrato, Foto, Vídeo, Mais com Panorama e Hiperlapso), obturador
     branco, miniatura redonda à esquerda e trocar de câmara à direita. A proporção (3:4, 9:16, 1:1) é
     do próprio visor: o buffer do canvas tem o rácio da foto, por isso sai na foto tal como se vê. */
  const NT = s => (window.L && L.t ? L.t(s) : s);
  const TF2 = (s, ...a) => (window.L && L.tf ? L.tf(s, ...a) : String(s).replace(/%s/g, () => (a.length ? a.shift() : '')));
  const MSG_A = {
    gl: 'O visor não arrancou (WebGL indisponível). Fecha e volta a abrir a Câmara.',
    magic: 'O visor ainda está à espera da imagem do jogo. Fecha e volta a abrir a Câmara; se continuar, escreve /camtest.',
    black: 'A imagem veio preta: o jogo ainda não desenhou nada no visor. Espera um instante e tenta outra vez.',
  };
  const NZOOM = [1, 2, 3, 5];
  const NRATIO = [[3 / 4, '3:4'], [9 / 16, '9:16'], [1, '1:1']];
  const NMODES = [[3, 'Retrato'], [2, 'Foto'], [1, 'Vídeo']];
  const NMORE = [[4, 'Panorama', 'pano'], [0, 'Hiperlapso', 'hyper']];
  const NGL = {
    gear: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1.1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1.1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/>',
    flashOn: '<path d="M13 2.5 5 13.5h6l-1 8 8-11h-6z"/>',
    flashOff: '<path d="M13 2.5 9.6 7.2M7.8 9.7 5 13.5h6l-1 8 4.2-5.8M16.1 13.2 18 10.5h-6l.6-4.6"/><path d="m3.5 3.5 17 17"/>',
    timer: '<circle cx="12" cy="13.5" r="7.5"/><path d="M12 13.5V10M9.5 2.5h5M18.5 6.5l1.5-1.5"/>',
    rotate: '<rect x="8" y="7" width="8" height="12" rx="1.6"/><path d="M4 9.5A8.5 8.5 0 0 1 14 3.6"/><path d="m12.5 1.5 2 2.2-2.4 1.7"/>',
    flip: '<path d="M20 9.5A8.2 8.2 0 0 0 5.6 6.2L4 8"/><path d="M4 3.8V8h4.2"/><path d="M4 14.5a8.2 8.2 0 0 0 14.4 3.3L20 16"/><path d="M20 20.2V16h-4.2"/>',
    pano: '<path d="M3 6.5c6 1.6 12 1.6 18 0v11c-6-1.6-12-1.6-18 0z"/>',
    hyper: '<circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3.5 2"/><path d="M3.5 12h2M18.5 12h2"/>',
  };
  const nic = (n, cls) => `<svg class="acam-gl ${cls || ''}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">${NGL[n] || ''}</svg>`;

  function mount(host, opts = {}) {
    const g = UI.g, bare = opts.chrome === 'bare';
    const nova = !bare && !!(window.System && System.os === 'android');
    let ratio = NRATIO[0][0];
    let front = false, zoom = 1, roll = 0, timer = 0, mode = 2, recording = false, recT0 = 0, recIv = null, busy = false, flash = false, dead = false, active = false, seed = 200 + Math.floor(Math.random() * 500);
    /* o slider da diagonal vive DENTRO do visor, encostado ao fundo (logo por cima da fila de zoom):
       assim abrir/fechar não mexe na altura do visor nem no enquadramento - e, sendo HTML por cima
       do canvas, nunca entra na foto */
    const TILT = `<div class="cam-tilt hidden"><span class="cam-tilt-lbl">−${MAX_ROLL}°</span><input type="range" class="no-kb" min="-${MAX_ROLL}" max="${MAX_ROLL}" step="1" value="0"><span class="cam-tilt-lbl">+${MAX_ROLL}°</span><span class="cam-tilt-val">0°</span></div>`;
    const VF = `<div class="viewfinder"><canvas class="cam-gl"></canvas><div class="scene"></div><div class="grid9"></div><div class="flash"></div><div class="cam-count hidden"></div>${bare ? '' : TILT}</div>`;
    /* Android: a imagem vive num quadro (.acam-frame) com o tamanho exato da foto, posto pelo fitNova() */
    const NVF = `<div class="viewfinder acam-vf"><div class="acam-frame"><canvas class="cam-gl"></canvas><div class="scene"></div><div class="grid9"></div><div class="flash"></div><div class="cam-count hidden"></div>${TILT}</div></div>`;
    const v = bare
      ? UI.el(`<div class="cam-app cam-bare">${VF}</div>`)
      : nova
      ? UI.el(`<div class="cam-app acam"><div class="acam-top"><div class="acam-ic" data-a="set" role="button" aria-label="${UI.esc(NT('Definições'))}">${nic('gear', 'acam-rt')}</div><div class="acam-tc">
          <div class="acam-ic" data-a="flash" role="button" aria-label="${UI.esc(NT('Flash'))}">${nic('flashOff', 'acam-rt')}</div>
          <div class="acam-ic" data-a="timer" role="button" aria-label="${UI.esc(NT('Temporizador'))}"><span class="acam-rt acam-tmw">${nic('timer')}<i class="acam-badge"></i></span></div>
          <div class="acam-ic" data-a="ratio" role="button" aria-label="${UI.esc(NT('Proporção'))}"><b class="acam-ratio acam-rt">3:4</b></div>
          <div class="acam-ic" data-a="tilt" role="button" aria-label="${UI.esc(NT('Inclinação'))}"><span class="acam-rt acam-tlw">${TILT_GLYPH}</span></div>
          <div class="acam-ic" data-a="rot" role="button" aria-label="${UI.esc(NT('Rodar o telemóvel'))}">${nic('rotate', 'acam-rt')}</div></div></div>
        ${NVF}
        <div class="acam-zoom">${NZOOM.map(z => `<span data-z="${z}" role="button"><b class="acam-rt">${z}</b></span>`).join('')}</div>
        <div class="acam-bottom"><div class="acam-modes"><div class="acam-strip">${NMODES.map(([m, n]) => `<span data-m="${m}" role="button">${UI.esc(NT(n))}</span>`).join('')}<span data-m="x" class="acam-extra hidden" role="button"></span><span data-m="more" role="button">${UI.esc(NT('Mais'))}</span></div></div>
          <div class="acam-bar"><div class="acam-thumb acam-rt" role="button" aria-label="${UI.esc(App.name('photos'))}"></div><div class="acam-shutter no-sound" role="button" aria-label="${UI.esc(NT('Tirar foto'))}"><div></div></div><div class="acam-flip" role="button" aria-label="${UI.esc(NT('Trocar de câmara'))}">${nic('flip', 'acam-rt')}</div></div></div>
        <div class="acam-more hidden"><div class="acam-more-in"><b>${UI.esc(NT('Mais modos'))}</b><div class="acam-more-g">${NMORE.map(([m, n, i]) => `<div data-m="${m}" role="button"><span>${nic(i)}</span><i>${UI.esc(NT(n))}</i></div>`).join('')}</div></div></div></div>`)
      : UI.el(`<div class="cam-app"><div class="cam-top"><div class="cam-back">${g('chevL')}</div><div class="flash off">${g('bolt', 24)}</div><div class="tmr off">${g('timer', 24)}</div><div class="grd off">${g('grid', 24)}</div><div class="tilt off">${TILT_GLYPH}</div><div class="rot off" title="Rodar o telemóvel">${g('rotate', 24)}</div></div>
      ${VF}
      <div class="cam-zoom"><span data-z="1" class="on">1×</span><span data-z="2">2×</span><span data-z="3">3×</span></div>
      <div class="cam-modes"><span>TIME-LAPSE</span><span>VÍDEO</span><span class="on">FOTO</span><span>RETRATO</span><span>PANO</span></div>
      <div class="cam-bar"><div class="cam-thumb"></div><div class="shutter"><div></div></div><div class="cam-flip">${g('repeat')}</div></div></div>`);
    const $ = s => v.querySelector(s);
    const scene = $('.scene'), thumb = $(nova ? '.acam-thumb' : '.cam-thumb'), vf = $('.viewfinder'), shutter = $(nova ? '.acam-shutter' : '.shutter'), count = $('.cam-count'), canvas = $('.cam-gl');
    const frame = nova ? $('.acam-frame') : null;
    let novaPaint = () => {}, fitNova = () => {};

    /* ---------- O VISOR ----------
       Fora do jogo o GameRender devolve um objeto inerte (.live = false): o canvas fica escondido
       e o visor mostra a cena falsa, que é o que o harness exercita.
       `quality` limita a altura de render a ~1080 px sem mexer no enquadramento: num ecrã 4K o
       buffer seria 1620×2160 e cada fotografia teria megabytes. */
    const q = Math.min(1, 1080 / Math.max(1, window.innerHeight || 1080));
    /* PANO = paisagem; tudo o resto retrato 3:4 - a não ser que o anfitrião fixe o rácio
       (o Instashot pede o do ecrã inteiro: o que se vê é exatamente o que sai) */
    const ASPECT = m => (opts.aspect > 0 ? opts.aspect : (m === 4 ? 16 / 9 : (nova ? ratio : 3 / 4)));
    /* o `||` é a rede de segurança para um index.html em cache sem o js/gamerender.js: a app abre na
       mesma e diz o que se passa, em vez de rebentar com "GameRender is not defined" */
    const render = (window.GameRender && GameRender.create(canvas, { aspect: ASPECT(mode), quality: q }))
      || { live: false, canvas: null, zoom: 1, roll: 0, resize() {}, resizeByAspect() {}, setXOffset() {}, setYOffset() {}, setZoom() {}, setRoll() {}, setLandscape() {}, renderOnce() {}, pause() {}, resume() {}, isBlack() { return true; }, isPlaceholder() { return false; }, toDataURL() { return null; }, destroy() {} };
    /* A caixa CSS tem de ter o MESMO rácio do buffer, senão o CEF estica a imagem e o visor
       deixa de ser a foto. No chrome 'bare' é o CSS do anfitrião que dimensiona o canvas. */
    const applyAspect = () => { const a = ASPECT(mode); if (nova) fitNova(); else if (!bare) { canvas.style.aspectRatio = a > 1 ? '16 / 9' : '3 / 4'; fitFold(); } render.resizeByAspect(a); };
    /* PearPhone Fold: o visor (a zona de conteúdo, 574 ou 1232 de largura, ~615 de altura) é mais largo do que o 3:4 cabe e a
       regra do CSS (largura toda) dava uma caixa mais alta do que o visor: o max-height cortava-a e o CEF esticava a imagem.
       Encaixa-se a caixa inteira no visor, ao centro, com o rácio do buffer. Nos telemóveis normais não se escreve nada. */
    function fitFold() {
      if (nova || bare || !canvas) return;
      if (!(window.System && System.form === 'fold')) { if (canvas._ff) { canvas._ff = false; ['width', 'height', 'left', 'right', 'maxHeight'].forEach(p => { canvas.style[p] = ''; }); } return; }
      const a = ASPECT(mode), W = vf.clientWidth, H = vf.clientHeight; if (!W || !H) return;
      let w = W, h = W / a; if (h > H) { h = H; w = H * a; }
      canvas._ff = true; canvas.style.maxHeight = 'none'; canvas.style.width = w.toFixed(1) + 'px'; canvas.style.height = h.toFixed(1) + 'px'; canvas.style.left = ((W - w) / 2).toFixed(1) + 'px'; canvas.style.right = 'auto';
    }
    canvas.style.display = render.live ? '' : 'none';
    /* (os botões de zoom ficam visíveis TAMBÉM em jogo: o zoom é digital, feito nas UVs do visor -
        gamerender.js setZoom - e sai na foto; o scroll da CellCam continua a funcionar por cima) */
    applyAspect();

    /* ---------- ZOOM DIGITAL E DIAGONAL ----------
       Os dois vivem no motor do visor (o canvas É a foto, logo saem na foto). No browser não há
       canvas: a cena falsa leva o MESMO recorte por CSS (scale × cover + rotate) para o harness
       poder ver. `cover` é a ampliação que a rotação exige para não mostrar cantos vazios -
       para a cena é a conta sem folga (GameRender.coverScale), a mesma que o motor usa. */
    const coverOf = (w, h, deg) => (window.GameRender && GameRender.coverScale) ? GameRender.coverScale(w, h, deg) : (Math.abs(Math.cos(deg * Math.PI / 180)) + Math.abs(Math.sin(deg * Math.PI / 180)));
    /* No BROWSER o visor mostra uma cena falsa (não há jogo por trás). A animação `drift` do CSS
       ganharia ao transform inline: com zoom/roll fora do neutro desliga-se, senão não se via nada. */
    const paintScene = () => { if (render.live) { scene.style.display = 'none'; return; }
      scene.style.display = ''; scene.style.background = photoBg(seed) + ', radial-gradient(40% 30% at 70% 30%, rgba(255,255,255,.3), transparent)';
      const box = frame || vf;   /* no Android a imagem é o quadro, não o visor inteiro */
      const k = zoom * coverOf(box.clientWidth || 3, box.clientHeight || 4, roll + land);
      scene.style.transform = `rotate(${roll + land}deg) scale(${+k.toFixed(4)})${front ? ' scaleX(-1)' : ''}`;
      scene.style.animation = (zoom !== 1 || roll !== 0 || land !== 0) ? 'none' : '';
      scene.style.filter = mode === 3 ? 'saturate(1.2)' : ''; };
    /* ---------- PAISAGEM (telemóvel deitado, System.rotate) ----------
       O aparelho inteiro roda -90° por CSS; o frame do jogo roda +90° dentro do canvas (gamerender setLandscape) e fica
       direito no ecrã deitado - como no iPhone, os botões ficam onde estão (o obturador passa para a direita).
       A foto é o canvas (retrato em píxeis, com a cena rodada): antes de guardar roda-se para sair uma fotografia AO BAIXO. */
    let land = 0;
    const setLandscape = on => { land = on ? 90 : 0; if (render.setLandscape) render.setLandscape(land); const b = $('.cam-top .rot'); if (b) b.classList.toggle('off', !land); paintScene(); novaPaint(); };
    const shotSrc = () => {
      const c = render.canvas; if (!land || !c) return c;
      try { const o = document.createElement('canvas'); o.width = c.height; o.height = c.width; const x = o.getContext('2d');
        x.translate(o.width / 2, o.height / 2); x.rotate(-Math.PI / 2); x.drawImage(c, -c.width / 2, -c.height / 2); return o; } catch (e) { return c; }
    };
    const offRot = Bridge.on('rotate', d => setLandscape(!!(d && d.on)));
    if (window.System && System.landscape) setLandscape(true);
    const setZoom = z => { z = Math.min((window.GameRender && GameRender.MAX_ZOOM) || 8, Math.max(1, Number(z) || 1)); zoom = z; render.setZoom(z);
      v.querySelectorAll('.cam-zoom span').forEach(x => x.classList.toggle('on', +x.dataset.z === z)); paintScene(); novaPaint(); return zoom; };
    const tiltEl = $('.cam-tilt'), tiltIn = tiltEl && tiltEl.querySelector('input'), tiltVal = tiltEl && tiltEl.querySelector('.cam-tilt-val'), tiltBtn = $('.cam-top .tilt');
    let tiltOpen = false;
    const paintTilt = () => { if (tiltVal) tiltVal.textContent = (roll > 0 ? '+' : '') + roll + '°'; if (tiltIn && +tiltIn.value !== roll) tiltIn.value = roll; if (tiltBtn) tiltBtn.classList.toggle('off', roll === 0 && !tiltOpen); novaPaint(); };
    const setRoll = d => { d = Math.round(Math.min(MAX_ROLL, Math.max(-MAX_ROLL, Number(d) || 0))); roll = d; render.setRoll(d); paintTilt(); paintScene(); return roll; };
    const showTilt = on => { tiltOpen = !!on; if (tiltEl) tiltEl.classList.toggle('hidden', !tiltOpen); paintTilt(); return tiltOpen; };
    if (tiltEl) {
      /* o slider está DENTRO do visor: sem isto, agarrar no cursor começava a apontar a câmara */
      tiltEl.addEventListener('pointerdown', e => e.stopPropagation());
      tiltIn.addEventListener('input', () => setRoll(tiltIn.value));
      /* toque duplo no botão = repor 0° (o primeiro toque alterna o slider como sempre) */
      let lastTap = 0;
      /* no Android o botão é outro (.acam-top [data-a="tilt"]), ligado mais abaixo com a mesma regra */
      if (tiltBtn) tiltBtn.onclick = () => { const now = Date.now(); Sound.play('click'); if (now - lastTap < 350) { lastTap = 0; setRoll(0); return; } lastTap = now; showTilt(!tiltOpen); };
    }
    /* cameraMode só vai para o Lua enquanto o visor está ATIVO: com a câmara escondida atrás da
       galeria do Instashot, ligar a câmara scriptada e esconder o HUD seria roubar o jogo ao jogador */
    const camMode = () => { if (active) Bridge.call('cameraMode', { on: true, front, zoom }); };
    /* ---------- A SELFIE AO CENTRO ----------
       A câmara frontal do jogo deixa o personagem ligeiramente ao lado. O visor desliza dentro do
       frame (Config.Camera.SelfieOffsetX) até ele ficar no meio. Só na frontal: na traseira o
       enquadramento é o do jogo, sem desvio nenhum.
       O sinal é o do gamerender.js: POSITIVO revela a margem ESQUERDA do frame (o enquadramento
       desliza para lá). Ver o comentário no config.lua. */
    const CAMCFG = (window.System && System.camera) || {};
    const OFFX = Number(CAMCFG.SelfieOffsetX) || 0, OFFY = Number(CAMCFG.SelfieOffsetY) || 0;
    const applyShift = () => { render.setXOffset(front ? OFFX : 0); render.setYOffset(front ? OFFY : 0); };
    /* ---------- APONTAR: CLICAR (BOTÃO ESQUERDO) E ARRASTAR ----------
       O olhar do jogo só se liga ENQUANTO o botão esquerdo está em baixo (client/camera.lua →
       cameraDrag): larga-se o botão, a vista fica quieta e o cursor vai clicar no obturador.
       No browser não há jogo por trás: o arrasto vira deslocamentos para o cameraLook (é o que o
       harness exercita). Os deslocamentos acumulam-se e vão uma vez por frame. */
    let look = null, pend = null, raf = 0, dragging = false;
    const flush = () => { raf = 0; const p = pend; pend = null; if (p) Bridge.call('cameraLook', p); };
    const onMove = e => { if (!look) return; const z = look.z || 1; const dx = (e.clientX - look.x) / z, dy = (e.clientY - look.y) / z;
      if (Math.abs(dx) < .5 && Math.abs(dy) < .5) return; look.x = e.clientX; look.y = e.clientY;
      pend = { dx: (pend ? pend.dx : 0) + dx * .22, dy: (pend ? pend.dy : 0) + dy * .16 };
      if (!raf) raf = requestAnimationFrame(flush); };
    const dragStart = e => {
      if (dead || dragging || !active) return;
      if (e.button && e.pointerType === 'mouse') return;          /* só o botão ESQUERDO aponta */
      dragging = true; document.body.classList.add('camshot-aim'); hintHide();   /* já arrasta: a dica cumpriu */
      /* o cursor pode sair de cima do elemento a meio do arrasto (ou ir parar à borda do ecrã):
         com captura, o pointerup chega na mesma e o arrasto não fica preso */
      try { e.currentTarget && e.currentTarget.setPointerCapture(e.pointerId); } catch (x) {}
      if (Bridge.inFiveM) Bridge.call('cameraDrag', { on: true });
      /* Unique RP: the NUI keeps the mouse while the button is down, so the game never receives the movement.
         The deltas measured here are sent to Lua in FiveM as well (cameraLook -> injected as look input, client/camera.lua). */
      look = { x: e.clientX, y: e.clientY, z: UI.zoom() };
    };
    const dragStop = () => {
      if (!dragging) return;
      dragging = false; look = null; document.body.classList.remove('camshot-aim');
      if (Bridge.inFiveM) Bridge.call('cameraDrag', { on: false });
    };
    if (opts.aimInside !== false) { vf.addEventListener('pointerdown', dragStart); vf.addEventListener('pointermove', onMove); }
    /* largar o botão vale em QUALQUER sítio - e perder o foco da janela também conta como largar,
       senão o jogo ficava a rodar a vista sozinho */
    document.addEventListener('pointerup', dragStop);
    document.addEventListener('pointercancel', dragStop);
    window.addEventListener('blur', dragStop);
    const refreshThumb = () => { if (!thumb) return; const last = Photos.cache[0]; if (last) { thumb.style.backgroundImage = Photos.bg(last); Photos.lazy(thumb, last, true); } };
    refreshThumb();
    /* Android: a miniatura redonda mostra sempre a última foto (a lista vem sem os base64, é leve) */
    if (nova && !Photos.cache.length) Photos.load().then(() => { if (!dead) refreshThumb(); }).catch(() => {});
    const setFlash = on => { flash = !!on; const b = $('.cam-top .flash'); if (b) b.classList.toggle('off', !flash); novaPaint(); return flash; };
    const setTimer = n => { timer = n === 3 || n === 10 ? n : 0; const b = $('.tmr'); if (b) b.classList.toggle('off', !timer); novaPaint(); return timer; };
    const toggleGrid = () => { vf.classList.toggle('grid'); const b = $('.grd'); if (b) b.classList.toggle('off'); };
    const setMode = i => { if (recording) return; mode = i; v.querySelectorAll('.cam-modes span').forEach((x, k) => x.classList.toggle('on', k === i)); if (shutter) shutter.classList.toggle('rec', mode === 1 || mode === 0); applyAspect(); paintScene(); novaPaint(); };
    /* ---------- ANDROID: ligar a cara da Nova UI aos mesmos comandos ---------- */
    let novaBack = () => false, novaRO = null;
    if (nova) {
      const zoomEl = $('.acam-zoom'), strip = $('.acam-strip'), extra = $('.acam-extra'), more = $('.acam-more'), bottom = $('.acam-bottom'), topEl = $('.acam-top');
      const zf = z => String(Math.round(z * 10) / 10).replace('.', ',');
      /* o quadro da imagem: 3:4 e 9:16 encostados em cima (os altos ficam por baixo dos controlos, como na
         Nova UI); 1:1 e Panorama ao centro da zona livre. O zoom fica logo acima do fundo da imagem ou dos
         controlos, o que vier primeiro. */
      fitNova = () => {
        const a = ASPECT(mode), W = vf.clientWidth || 440, H = vf.clientHeight || 808, ctrl = bottom.offsetHeight || 150;
        let w = W, h = W / a; if (h > H) { h = H; w = H * a; }
        const free = Math.max(120, H - ctrl), t = (h <= free && a >= 1) ? Math.round((free - h) / 2) : 0;
        frame.style.left = ((W - w) / 2).toFixed(1) + 'px'; frame.style.top = t + 'px'; frame.style.width = w.toFixed(1) + 'px'; frame.style.height = h.toFixed(1) + 'px';
        zoomEl.style.top = Math.round((vf.offsetTop || 0) + Math.min(t + h, free) - 60) + 'px';
      };
      novaPaint = () => {
        const q = s => topEl.querySelector(`[data-a="${s}"]`);
        const fb = q('flash'); if (fb.classList.contains('on') !== flash || !fb.firstChild) { fb.classList.toggle('on', flash); fb.innerHTML = nic(flash ? 'flashOn' : 'flashOff', 'acam-rt'); }
        q('timer').classList.toggle('on', !!timer); q('timer').querySelector('.acam-badge').textContent = timer ? timer + 's' : '';
        const r = mode === 4 ? '16:9' : (NRATIO.find(x => x[0] === ratio) || NRATIO[0])[1], rb = q('ratio').querySelector('.acam-ratio');
        if (rb.textContent !== r) rb.textContent = r; q('ratio').classList.toggle('dis', mode === 4);
        q('tilt').classList.toggle('on', roll !== 0 || tiltOpen);
        q('rot').classList.toggle('on', !!land);
        let ai = 0; NZOOM.forEach((z, i) => { if (zoom >= z - 1e-6) ai = i; });
        zoomEl.querySelectorAll('span').forEach((s, i) => { const on = i === ai, t = on ? zf(zoom) + 'x' : String(NZOOM[i]); s.classList.toggle('on', on); if (s.firstChild.textContent !== t) s.firstChild.textContent = t; });
        const xm = NMORE.find(x => x[0] === mode);
        extra.classList.toggle('hidden', !xm); if (xm) { extra.dataset.m = String(xm[0]); if (extra.textContent !== NT(xm[1])) extra.textContent = NT(xm[1]); }
        strip.querySelectorAll('span').forEach(s => s.classList.toggle('on', s.dataset.m !== 'more' && s.dataset.m !== 'x' && +s.dataset.m === mode && !s.classList.contains('hidden')));
        /* o modo escolhido fica ao centro (o carrossel desliza só com transform) */
        const on = strip.querySelector('span.on'), wrap = strip.parentElement;
        if (on && wrap.clientWidth) strip.style.transform = `translateX(${(wrap.clientWidth / 2 - (on.offsetLeft + on.offsetWidth / 2)).toFixed(1)}px)`;
      };
      const showMore = on => { more.classList.toggle('hidden', !on); };
      let lastTilt = 0;
      const settings = () => {
        const body = UI.list([{ items: [
          { label: NT('Linhas de grelha'), toggle: vf.classList.contains('grid'), onToggle: () => toggleGrid() },
          { label: NT('Régua de inclinação'), sub: TF2('Inclina a fotografia até %s graus', MAX_ROLL), toggle: tiltOpen, onToggle: on => showTilt(on) },
          { label: NT('Temporizador'), value: timer ? timer + ' s' : NT('Desligado'), onTap: async () => { const r = await UI.picker(NT('Temporizador'), [{ value: 0, label: NT('Desligado') }, { value: 3, label: '3 s' }, { value: 10, label: '10 s' }], timer); if (r !== undefined) { setTimer(r); sh.close(); } } },
        ].concat(roll ? [{ label: NT('Repor a inclinação'), onTap: () => { setRoll(0); sh.close(); } }] : []),
          footer: NT('O zoom, a proporção e a inclinação são digitais e ficam na fotografia, tal como se veem no visor. As fotos vão para a Galeria.') }]);
        const sh = UI.sheet({ title: NT('Definições da câmara'), right: NT('OK'), body, cls: 'acam-set' });
      };
      topEl.onclick = e => {
        const b = e.target.closest('[data-a]'); if (!b) return; Sound.play('click');
        const a = b.dataset.a;
        if (a === 'flash') setFlash(!flash);
        else if (a === 'timer') setTimer(timer === 0 ? 3 : timer === 3 ? 10 : 0);   /* o "3s"/"10s" fica escrito ao lado do ícone */
        else if (a === 'ratio') {
          if (mode === 4) { UI.toast(NT('No Panorama a proporção é sempre 16:9')); return; }
          const i = NRATIO.findIndex(x => x[0] === ratio); ratio = NRATIO[(i + 1) % NRATIO.length][0]; applyAspect(); paintScene(); novaPaint();
        }
        else if (a === 'tilt') { const now = Date.now(); if (now - lastTilt < 350) { lastTilt = 0; setRoll(0); return; } lastTilt = now; showTilt(!tiltOpen); }
        else if (a === 'rot') { if (window.System && System.rotate) System.rotate(!System.landscape); }
        else if (a === 'set') settings();
      };
      /* zoom: os botões saltam para 1x/2/3/5 e a roda do rato faz zoom contínuo (até ao máximo do motor) */
      zoomEl.onclick = e => { const s = e.target.closest('[data-z]'); if (!s) return; Sound.play('click'); setZoom(+s.dataset.z); };
      vf.addEventListener('wheel', e => { if (dead || !active) return; e.preventDefault(); setZoom(Math.round(zoom * (e.deltaY < 0 ? 1.12 : 1 / 1.12) * 10) / 10); }, { passive: false });
      strip.onclick = e => {
        const s = e.target.closest('[data-m]'); if (!s) return; Sound.play('click');
        if (s.dataset.m === 'more') { showMore(true); return; }
        const m = +s.dataset.m; if (isNaN(m) || m === mode) return;
        setMode(m);
        /* aviso honesto: o visor do jogo não traz profundidade, por isso o Retrato não desfoca o fundo */
        if (m === 3 && mode === 3) UI.toast(NT('Retrato: o visor do jogo não tem profundidade, por isso o fundo não fica desfocado.'), 3200);
      };
      more.onclick = e => { const t = e.target.closest('[data-m]'); if (t) { Sound.play('click'); setMode(+t.dataset.m); } showMore(false); };
      $('.acam-flip').onclick = () => flip();
      thumb.onclick = () => { if (opts.onThumb) opts.onThumb(); };
      /* Voltar do Android: fecha primeiro o "Mais" e a régua, só depois sai da Câmara */
      novaBack = () => { if (!more.classList.contains('hidden')) { showMore(false); return true; } if (tiltOpen) { showTilt(false); return true; } return false; };
      /* ⚠️ "ResizeObserver loop limit exceeded" (consola do jogo, 2026-10-01): o fitNova mexe no tamanho do proprio visor
         observado e, feito DENTRO da entrega do observador, o Chromium reentregava no mesmo frame. Agora so com tamanho
         novo e no frame seguinte (fora do ciclo do observador). */
      if ('ResizeObserver' in window) { let roSz = '', roRaf = 0;
        novaRO = new ResizeObserver(ents => { const r = ents && ents[0] && ents[0].contentRect; const k = r ? Math.round(r.width) + 'x' + Math.round(r.height) : ''; if (k === roSz) return; roSz = k;
          cancelAnimationFrame(roRaf); roRaf = requestAnimationFrame(() => { if (!dead) { fitNova(); novaPaint(); paintScene(); } }); });
        novaRO.observe(vf); }
    }
    if (!nova && !bare) {
      /* zoom digital: só o motor do visor (nada vai ao Lua - a CellCam não tem zoom por botão) */
      $('.cam-zoom').onclick = e => { const s = e.target.closest('span'); if (!s) return; Sound.play('click'); setZoom(+s.dataset.z); };
      $('.cam-flip').onclick = () => flip();
      $('.cam-top .flash').onclick = () => setFlash(!flash);
      $('.tmr').onclick = () => { setTimer(timer === 0 ? 3 : timer === 3 ? 10 : 0); UI.toast(timer ? `Temporizador: ${timer}s` : 'Temporizador desligado'); };
      $('.grd').onclick = toggleGrid;
      /* deitar o telemóvel (fotografias ao baixo): é o System que roda o aparelho; o visor segue pelo evento 'rotate' */
      $('.cam-top .rot').onclick = () => { Sound.play('click'); if (window.System && System.rotate) System.rotate(!System.landscape); };
      v.querySelectorAll('.cam-modes span').forEach((s, i) => s.onclick = () => setMode(i));
      thumb.onclick = () => { if (opts.onThumb) opts.onThumb(); };
      $('.cam-back').onclick = () => { Sound.play('click'); if (opts.onBack) opts.onBack(); };
    }

    async function shoot(extra) {
      if (busy || dead) return null; busy = true; const f = vf.querySelector('.flash'); f.classList.remove('go'); void f.offsetWidth; f.classList.add('go'); Sound.play('shutter');
      let p = null, code = null, raw = null;
      try {
        if (Bridge.inFiveM) {
          /* A FOTO É O VISOR. Nada de screenshot do ecrã: a grelha, o contador e o clarão do
             obturador são camadas HTML por cima do canvas e NÃO entram na imagem. */
          /* o anfitrião pode ter fechado durante o temporizador (até 10 s de espera): aí não é o
             WebGL que falhou, foi o jogador que saiu - não se mente com "o visor não arrancou" */
          if (dead) code = 'closed';
          else if (!render.live) code = 'gl';
          else {
            /* o ponteiro do rato é desenhado pelo JOGO: sem isto aparecia a meio da fotografia */
            await Bridge.callT('shotBegin', {}, 3000);
            render.renderOnce();                       /* um frame fresco, mesmo se o ciclo estiver em pausa */
            if (render.isPlaceholder && render.isPlaceholder()) code = 'magic';   /* textura ainda por trocar: seria uma foto vermelha */
            else if (render.isBlack()) code = 'black';      /* o jogo ainda não produziu textura: não se guarda um quadrado preto */
            else { raw = Photos.fromCanvas(shotSrc(), .9); if (!raw) code = 'encode'; }
          }
        } else {
          /* BROWSER / harness: não há vista do jogo - mantém-se o caminho antigo (mock + reduzir) */
          const r = await Bridge.callT('takePhoto', { front, zoom, flash, portrait: mode === 3 }, 22000);
          if (r && r.raw) { const small = await Photos.shrink(r.raw);
            if (small === Photos.BLACK) code = 'black'; else if (!small) code = 'shrink'; else raw = small; }
          else if (r && r.photo) p = r.photo;
          else p = await Bridge.rpcRaw('photos.add', Object.assign({ seed }, extra || {}));
        }
        if (raw && !code) {
          /* o anfitrião pode transformar a imagem antes de ela ser guardada (efeitos do Instashot) */
          if (opts.process) { try { raw = (await opts.process(raw)) || raw; } catch (e) { console.error('[unique_phone] process', e); } }
          p = await Photos.save(raw, extra || {});   /* base64 aos bocados: nunca rebenta o evento */
        }
      } catch (e) { code = 'js'; console.error('[unique_phone] shoot', e); }
      finally { if (Bridge.inFiveM) Bridge.call('shotEnd'); }   /* o cursor volta mesmo que o disparo rebente */
      const out = await finish(p, raw, code, extra);
      busy = false;
      return out;
    }
    /* o fim comum da foto e do vídeo: linha na galeria, miniatura, aviso, onShot — ou o erro com nome */
    async function finish(p, raw, code, extra) {
      let out = null;
      const isVid = !!(extra && extra.video);
      if (p && p.id && !p.error) { await Photos.load();
        /* a foto que acabou de sair já está aqui em memória: passa-a para a linha nova da lista,
           senão a galeria voltava a descarregá-la do servidor aos bocados sem necessidade */
        const row = Photos.cache.find(x => x && x.id === p.id);
        if (row && p.url && !row.url) row.url = p.url;
        if (row && p.poster && !row.poster) { row.poster = p.poster; row.hasPoster = true; }   /* a capa do vídeo volta na resposta */
        if (thumb) thumb.style.backgroundImage = Photos.bg(row || p); Bridge.emit('photos');
        UI.toast(nova ? NT(isVid ? 'Vídeo guardado na Galeria' : 'Foto guardada na Galeria') : (isVid ? 'Vídeo guardado' : 'Foto guardada'));
        out = { photo: p, raw: raw || p.url || null };
        if (!dead && opts.onShot) { try { opts.onShot(p, out.raw); } catch (e) { console.error('[unique_phone] onShot', e); } } }
      else {
        code = code || (p && p.error) || 'sem resposta';
        UI.toast((nova && MSG_A[code] && NT(MSG_A[code])) || MSG[code] || (isVid ? TF2('Não foi possível guardar o vídeo (%s)', code) : ('Não foi possível guardar a foto (' + code + ')')), 3400);
        console.error('[unique_phone] ' + (isVid ? 'vídeo' : 'foto') + ' falhou:', code);
      }
      seed = 200 + Math.floor(Math.random() * 500); setTimeout(paintScene, 250);
      return out;
    }
    /* ---------- CAPTURAR SEM GUARDAR ----------
       O `shoot()` acima é o disparo da app Câmara: guarda a fotografia nas Fotos, avisa a galeria
       e mostra "Foto guardada". Há quem precise da imagem e mais nada - os Instants do Instashot
       são fotografias do momento, que desaparecem depois de vistas e NÃO podem ir parar à galeria.
       Este caminho faz só a parte da câmara: esconde o ponteiro do jogo (que é desenhado PELO JOGO
       e apareceria a meio da foto), tira um frame fresco do visor e devolve o base64.
       Devolve { raw } ou { error } com um código do MSG. */
    async function capture() {
      if (busy || dead) return { error: 'closed' };
      busy = true;
      const f = vf.querySelector('.flash'); f.classList.remove('go'); void f.offsetWidth; f.classList.add('go'); Sound.play('shutter');
      let raw = null, code = null;
      try {
        if (Bridge.inFiveM) {
          if (!render.live) code = 'gl';
          else {
            await Bridge.callT('shotBegin', {}, 3000);
            render.renderOnce();
            if (render.isPlaceholder && render.isPlaceholder()) code = 'magic';
            else if (render.isBlack()) code = 'black';
            else { raw = Photos.fromCanvas(shotSrc(), .9); if (!raw) code = 'encode'; }
          }
        } else {
          /* browser/harness: não há vista do jogo - o mesmo caminho de recurso do shoot() */
          const r = await Bridge.callT('takePhoto', { front, zoom, flash }, 22000);
          if (r && r.raw) { const small = await Photos.shrink(r.raw); if (small === Photos.BLACK) code = 'black'; else if (!small) code = 'shrink'; else raw = small; }
          else code = 'empty';
        }
      } catch (e) { code = 'js'; console.error('[unique_phone] capture', e); }
      finally { if (Bridge.inFiveM) Bridge.call('shotEnd'); }
      busy = false;
      if (!raw) return { error: code || 'empty', msg: MSG[code] || null };
      return { raw };
    }
    /* ---------- VÍDEO A SÉRIO (1.1.4) ----------
       Antes, o modo VÍDEO só fingia: contava o tempo e, ao parar, guardava UM frame do visor como fotografia — era
       o que o cliente via na galeria ("o vídeo aparece como uma foto"). Agora grava-se mesmo: o frame do visor (o
       canvas WebGL do GameRender, já com zoom, diagonal e paisagem) é copiado VCFG.fps vezes por segundo para um
       canvas 2D mais pequeno (Config.Camera.VideoHeight), e esse canvas é a fonte de um MediaRecorder
       (captureStream → WebM/VP8). Ao parar, o Blob vira data:video/webm;base64 e sobe pelo MESMO caminho das fotos
       (Photos.save aos bocados, com video = true em todos os pedaços), com uma capa JPEG pequena (poster) tirada dos
       primeiros frames para a grelha da galeria. Pára sozinho em VideoMaxSeconds e ANTES de passar VideoMaxBytes (o
       tamanho é vigiado a cada bocado do MediaRecorder). O cursor do jogo não se esconde durante a gravação (o
       jogador precisa dele para carregar no obturador): só entra no vídeo se passar pelo meio do enquadramento.
       Fora do jogo (harness) o frame é a cena falsa pintada no canvas 2D: o caminho inteiro é exercitado na mesma. */
    const clampN = (v, lo, hi, d) => { v = Number(v); return (isFinite(v) && v > 0) ? Math.min(hi, Math.max(lo, v)) : d; };
    const VCFG = {
      sec: clampN(CAMCFG.VideoMaxSeconds, 3, 60, 15),
      bps: clampN(CAMCFG.VideoBitrate, 150000, 4000000, 500000),
      h: Math.round(clampN(CAMCFG.VideoHeight, 240, 1080, 640)),
      maxChars: clampN(CAMCFG.VideoMaxBytes, 200000, 8000000, 1600000),
      fps: 24, audio: CAMCFG.VideoAudio === true,
    };
    let rec = null;   /* a gravação em curso: { rc, ctx, mr, stream, chunks, bytes, t0, mime, poster, iv, autoT, stopping, done } */
    const canRecord = () => { try { return typeof MediaRecorder === 'function' && typeof HTMLCanvasElement.prototype.captureStream === 'function'; } catch (e) { return false; } };
    const videoMime = () => { try { if (typeof MediaRecorder.isTypeSupported !== 'function') return ''; return ['video/webm;codecs=vp8', 'video/webm;codecs=vp9', 'video/webm', 'video/mp4'].find(t => MediaRecorder.isTypeSupported(t)) || ''; } catch (e) { return ''; } };
    const NO_REC = () => UI.toast(NT('A gravação de vídeo não está disponível neste cliente'), 3400);
    /* tamanho do vídeo: a altura pedida e a largura pelo rácio do visor (em paisagem o frame roda, como no shotSrc) */
    const recSize = () => {
      let a = ASPECT(mode); const c = render.live ? render.canvas : null;
      if (c && c.width && c.height) a = c.width / c.height;
      if (land) a = 1 / a;
      const h = VCFG.h, w = Math.max(2, Math.round(h * a));
      return { w: w + (w % 2), h: h + (h % 2) };   /* dimensões pares: é o que o VP8 prefere */
    };
    /* o frame: o canvas do jogo (rodado em paisagem) ou, fora do jogo, a cena falsa com o seed desta sessão */
    const drawFrame = (ctx, w, h) => {
      const c = render.live ? render.canvas : null;
      if (c && c.width && c.height) {
        if (land) { ctx.save(); ctx.translate(w / 2, h / 2); ctx.rotate(-Math.PI / 2); ctx.drawImage(c, -h / 2, -w / 2, h, w); ctx.restore(); }
        else ctx.drawImage(c, 0, 0, w, h);
        return;
      }
      const g = ctx.createLinearGradient(0, 0, w, h); g.addColorStop(0, `hsl(${(seed * 53) % 360},70%,58%)`); g.addColorStop(1, `hsl(${(seed * 53 + 110) % 360},65%,32%)`);
      ctx.fillStyle = g; ctx.fillRect(0, 0, w, h);
      const t = (Date.now() / 900) % 1; ctx.fillStyle = 'rgba(255,255,255,.35)'; ctx.beginPath(); ctx.arc(w * (0.2 + 0.6 * t), h * 0.35, Math.min(w, h) * 0.08, 0, Math.PI * 2); ctx.fill();
    };
    /* capa JPEG (≤ 15 000 caracteres, o servidor aceita 16 000): 160 px de altura chegam para a célula da grelha */
    const posterOf = rc => { try { const h = 160, w = Math.max(2, Math.round(h * rc.width / rc.height)); const c = document.createElement('canvas'); c.width = w; c.height = h; c.getContext('2d').drawImage(rc, 0, 0, w, h); let out = c.toDataURL('image/jpeg', .62); if (out.length > 15000) out = c.toDataURL('image/jpeg', .45); return out.length <= 15000 ? out : null; } catch (e) { return null; } };
    const recUI = on => { if (shutter) shutter.classList.toggle('recording', on); if (nova) v.classList.toggle('acam-recording', on); const old = vf.querySelector('.rec-time'); if (old) old.remove(); if (on) vf.appendChild(UI.el('<div class="rec-time">0:00</div>')); System.indicator('mic', on); };
    async function startRec() {
      if (rec || busy || dead) return false;
      if (!canRecord()) { NO_REC(); return false; }
      if (Bridge.inFiveM && !render.live) { UI.toast(nova ? NT(MSG_A.gl) : MSG.gl, 3400); return false; }
      const mime = videoMime(); const { w, h } = recSize();
      const rc = document.createElement('canvas'); rc.width = w; rc.height = h; const ctx = rc.getContext('2d');
      let stream = null, mr = null;
      try { stream = rc.captureStream(VCFG.fps); } catch (e) { console.error('[unique_phone] captureStream', e); NO_REC(); return false; }
      const stopTracks = () => { try { stream.getTracks().forEach(t => { try { t.stop(); } catch (e) {} }); } catch (e) {} };
      /* microfone opcional (Config.Camera.VideoAudio): se o CEF o recusar, o vídeo sai sem som e pronto */
      if (VCFG.audio) { try { const a = await navigator.mediaDevices.getUserMedia({ audio: true, video: false }); a.getAudioTracks().forEach(t => stream.addTrack(t)); } catch (e) {} }
      if (dead || rec) { stopTracks(); return false; }
      const r = { rc, ctx, mr: null, stream, chunks: [], bytes: 0, t0: Date.now(), mime: (mime.split(';')[0] || 'video/webm'), poster: null, frames: 0, iv: 0, autoT: 0, stopping: false, done: null };
      drawFrame(ctx, w, h);
      try { mr = new MediaRecorder(stream, Object.assign({ videoBitsPerSecond: VCFG.bps }, mime ? { mimeType: mime } : {})); }
      catch (e) { try { mr = new MediaRecorder(stream); } catch (e2) { stopTracks(); console.error('[unique_phone] MediaRecorder', e2); NO_REC(); return false; } }
      r.mr = mr; rec = r;
      mr.ondataavailable = e => { if (!e.data || !e.data.size) return; r.chunks.push(e.data); r.bytes += e.data.size;
        /* base64 = 4/3 do binário: parar ANTES de passar o teto do servidor, senão o envio era recusado no fim */
        if (rec === r && !r.stopping && r.bytes * 4 / 3 + 64 > VCFG.maxChars) stopRec(true, 'size'); };
      mr.onerror = e => { console.error('[unique_phone] MediaRecorder', (e && e.error) || e); if (rec === r) stopRec(true, 'error'); };
      try { mr.start(500); } catch (e) { rec = null; stopTracks(); console.error('[unique_phone] MediaRecorder.start', e); NO_REC(); return false; }
      r.iv = setInterval(() => { if (rec !== r) return; drawFrame(ctx, w, h); r.frames++; if (!r.poster && r.frames === 3) r.poster = posterOf(rc);
        const rt = vf.querySelector('.rec-time'); if (rt) rt.textContent = UI.fmtDur((Date.now() - r.t0) / 1000); }, Math.round(1000 / VCFG.fps));
      r.autoT = setTimeout(() => { if (rec === r) stopRec(true, 'max'); }, VCFG.sec * 1000);
      recording = true; recT0 = r.t0; recUI(true); Sound.play('pop');
      return true;
    }
    /* pára a gravação; save = guarda na galeria (false = deita fora: a app morreu). Devolve o mesmo que o shoot(). */
    function stopRec(save, why) {
      const r = rec; if (!r) return Promise.resolve(null);
      if (r.stopping) return r.done || Promise.resolve(null);
      r.stopping = true;
      r.done = (async () => {
        clearInterval(r.iv); clearTimeout(r.autoT);
        recording = false; recUI(false);
        if (!r.poster) r.poster = posterOf(r.rc);
        const blob = await new Promise(res => { let fin = false; const end = () => { if (fin) return; fin = true; res(r.chunks.length ? new Blob(r.chunks, { type: r.mr.mimeType || r.mime }) : null); };
          const t = setTimeout(end, 2500);   /* um onstop que nunca chega não pendura o obturador */
          r.mr.onstop = () => { clearTimeout(t); end(); };
          try { if (r.mr.state !== 'inactive') r.mr.stop(); else { clearTimeout(t); end(); } } catch (e) { clearTimeout(t); end(); } });
        try { r.stream.getTracks().forEach(t => { try { t.stop(); } catch (e) {} }); } catch (e) {}
        if (rec === r) rec = null;
        const dur = Math.round((Date.now() - r.t0) / 1000);
        if (!save || dead) return null;
        if (why === 'max') UI.toast(TF2('A gravação parou no limite de %s s', VCFG.sec), 2600);
        if (!blob || dur < 1) { UI.toast(NT('Vídeo demasiado curto'), 2600); return null; }
        const raw = await new Promise(res => { try { const fr = new FileReader(); fr.onload = () => res(typeof fr.result === 'string' ? fr.result : null); fr.onerror = () => res(null); fr.readAsDataURL(blob); } catch (e) { res(null); } });
        /* o cabeçalho sai limpo (sem ";codecs=vp8"): é o que o servidor valida e o que o <video> da galeria espera */
        const url = raw ? raw.replace(/^data:[^,]*,/, 'data:' + r.mime + ';base64,') : null;
        if (!url) { UI.toast(TF2('Não foi possível guardar o vídeo (%s)', 'encode'), 3400); return null; }
        if (url.length > VCFG.maxChars) { UI.toast(NT('O vídeo ficou demasiado grande'), 3400); return null; }
        return saveVideo(url, dur, r.poster);
      })();
      return r.done;
    }
    async function saveVideo(url, dur, poster) {
      if (dead) return null;
      busy = true; UI.toast(NT('A guardar o vídeo…'), 1800);
      let p = null, code = null;
      try { p = await Photos.save(url, Object.assign({ video: true, duration: dur }, poster ? { poster } : {})); }
      catch (e) { code = 'js'; console.error('[unique_phone] video save', e); }
      const out = await finish(p, url, code, { video: true });
      busy = false; return out;
    }
    /* o OBTURADOR: vídeo começa/pára a gravação; foto respeita o temporizador e dispara */
    const trigger = async () => {
      if (dead) return null;
      if (mode === 1 || mode === 0) { if (!rec) { await startRec(); return null; } return stopRec(true, 'user'); }
      if (timer) { count.classList.remove('hidden'); for (let i = timer; i > 0; i--) { count.textContent = i; Sound.play('click'); await new Promise(r => setTimeout(r, 1000)); } count.classList.add('hidden'); }
      return shoot();
    };
    if (shutter) shutter.onclick = trigger;
    /* ---------- QUEM DISPARA É SÓ O BOTÃO REDONDO DO TELEMÓVEL ----------
       ⚠️ NÃO voltar a pôr atalhos de teclado nem `camKey`. O jogo mapeia o FRONTEND_ACCEPT (176)
       também ao botão ESQUERDO do rato e o FRONTEND_CANCEL (177) ao DIREITO: com o disparo
       ligado a essas teclas, cada clique para começar a arrastar tirava uma fotografia. */
    const flip = () => { front = !front; applyShift(); paintScene(); camMode(); Sound.play('click'); return front; };

    /* ---------- NO ECRÃ, NADA ----------
       NADA fora do telemóvel dispara. A camada de arrasto cobre o ecrã inteiro e fica POR BAIXO
       do aparelho (`body.camshot-on .stage`). (A antiga linha de texto "Arrasta para posicionar a
       câmara" saiu daqui: a dica é agora a animação no visor, abaixo.) */
    const stage = UI.el(`<div class="camshot-layer"><div class="camshot-drag"></div></div>`);
    const dragEl = stage.querySelector('.camshot-drag');
    dragEl.addEventListener('pointerdown', dragStart);
    dragEl.addEventListener('pointermove', onMove);

    /* ---------- A DICA DE ARRASTAR: SÓ NA PRIMEIRA VEZ ----------
       Um ponto macio ao centro do visor que desliza para o lado e volta (3 ciclos, só transform e
       opacity: no CEF um keyframe com filter custa um repaint por frame). Mostra-se uma única vez
       na vida do telemóvel (localStorage), na primeira ativação do visor da app Câmara, e some ao
       primeiro pointerdown no visor ou no fim dos 3 ciclos. O localStorage pode não existir (modo
       privado, CEF a arrancar): nunca pode rebentar a câmara por causa de uma dica. */
    const hintSeen = () => { try { return localStorage.getItem(HINT_KEY) === '1'; } catch (e) { return false; } };
    const hintMark = () => { try { localStorage.setItem(HINT_KEY, '1'); } catch (e) {} };
    let hint = null;
    const hintHide = () => { if (!hint) return; const h = hint; hint = null; h.classList.add('gone'); setTimeout(() => h.remove(), 260); };
    const hintShow = () => {
      if (bare || hint || dead || hintSeen()) return;
      hintMark();
      hint = UI.el('<div class="cam-hint"><div class="cam-hint-dot"></div></div>');
      /* animationend sobe do ponto (a animação está nele): fim dos 3 ciclos = dica cumprida */
      hint.addEventListener('animationend', hintHide);
      vf.appendChild(hint);
    };
    vf.addEventListener('pointerdown', hintHide);

    /* ---------- ATIVAR / DESATIVAR ----------
       Ativo = visor a correr, camada de arrasto no body, cameraMode ligado no Lua e indicador
       da câmara aceso. A app Câmara ativa ao montar; o Instashot só quando o visor fica à vista. */
    const setActive = on => {
      on = !!on; if (dead || on === active) return; active = on;
      if (on) {
        if (!stage.isConnected) document.body.appendChild(stage);
        stage.style.display = '';
        document.body.classList.add('camshot-on');
        render.resume(); applyShift(); paintScene(); camMode(); System.indicator('cam', true);
        hintShow();                                   /* a dica só faz sentido com o visor a correr */
      } else {
        dragStop(); stage.remove(); document.body.classList.remove('camshot-on', 'camshot-aim');
        if (rec) stopRec(true, 'hide');   /* o visor vai desaparecer: o que já está gravado fica na galeria */
        /* sem guarda de inFiveM: fora do jogo a chamada é inofensiva e o harness (_camctl) espia-a */
        render.pause(); Bridge.call('cameraMode', { on: false }); System.indicator('cam', false);
      }
    };
    const offFront = Bridge.on('camera:front', () => { front = true; applyShift(); paintScene(); camMode(); });
    /* fechar o telemóvel com a câmara aberta: desliga o visor e a câmara do Lua e volta a ligá-los
       quando ele reabrir - mas só se estava ativa (senão reabrir ligava uma câmara escondida) */
    let wasActive = false;
    const offClose = Bridge.on('phone:close', () => { if (dead) return; wasActive = active; if (rec) stopRec(true, 'close');   /* fechar o telemóvel a gravar: guarda o que há */
      if (active) { dragStop(); stage.style.display = 'none'; render.pause(); Bridge.call('cameraMode', { on: false }); } });
    const offOpen = Bridge.on('phone:open', () => { if (dead || !wasActive || !active) return; stage.style.display = ''; render.resume(); applyShift(); camMode(); });

    host.appendChild(v);
    if (nova) { fitNova(); render.resizeByAspect(ASPECT(mode)); paintScene(); novaPaint(); requestAnimationFrame(() => { if (!dead) { fitNova(); novaPaint(); paintScene(); } }); }
    /* PearOS: o encaixe do dobrável volta a medir-se quando o visor muda de tamanho (abrir/fechar o aparelho com a Câmara aberta);
       só com tamanho novo e no frame seguinte, fora da entrega do observador (a mesma regra do da Nova UI) */
    else if (!bare) { fitFold(); requestAnimationFrame(() => { if (!dead) fitFold(); });
      if ('ResizeObserver' in window) { let fSz = '', fRaf = 0;
        novaRO = new ResizeObserver(ents => { const r = ents && ents[0] && ents[0].contentRect; const k = r ? Math.round(r.width) + 'x' + Math.round(r.height) : ''; if (k === fSz) return; fSz = k;
          cancelAnimationFrame(fRaf); fRaf = requestAnimationFrame(() => { if (!dead) fitFold(); }); });
        novaRO.observe(vf); } }
    if (opts.autoActivate !== false) setActive(true);
    else render.pause();                            /* o visor só corre quando o anfitrião o mostrar */
    /* dizer LOGO que o visor não arrancou, em vez de deixar o jogador carregar no obturador para nada */
    if (Bridge.inFiveM && !render.live) setTimeout(() => { if (!dead) UI.toast(nova ? NT(MSG_A.gl) : MSG.gl, 4000); }, 700);

    const destroy = () => {
      if (dead) return;
      dead = true;
      offFront(); offClose(); offOpen(); offRot();
      /* o arrasto vive no DOCUMENTO e a camada no BODY: fora da janela do anfitrião ninguém os
         limpa por nós - e um cameraDrag por desligar deixava o jogo a rodar a vista com o rato */
      dragStop();
      document.removeEventListener('pointerup', dragStop);
      document.removeEventListener('pointercancel', dragStop);
      window.removeEventListener('blur', dragStop);
      stage.remove(); document.body.classList.remove('camshot-on', 'camshot-aim');
      if (novaRO) { try { novaRO.disconnect(); } catch (e) {} novaRO = null; }
      if (raf) { cancelAnimationFrame(raf); raf = 0; }   /* o flush do arrastar não pode sobreviver ao anfitrião */
      pend = null; look = null;
      if (rec) { const r = rec; r.stopping = true; clearInterval(r.iv); clearTimeout(r.autoT); try { if (r.mr.state !== 'inactive') r.mr.stop(); } catch (e) {} try { r.stream.getTracks().forEach(t => t.stop()); } catch (e) {} rec = null; }   /* a app morreu a gravar: deita fora */
      render.destroy(); Bridge.call('cameraMode', { on: false });
      System.indicator('cam', false); System.indicator('mic', false); clearInterval(recIv);
      v.remove();
    };

    return {
      el: v, render, destroy, setActive, shoot: trigger, capture, flip, setFlash, setTimer, toggleGrid, setMode, refreshThumb, setZoom, setRoll, showTilt,
      aimStart: dragStart, aimMove: onMove, aimStop: dragStop,
      back: () => novaBack(), get nova() { return nova; }, get ratio() { return ratio; }, get mode() { return mode; },
      get active() { return active; }, get dead() { return dead; }, get busy() { return busy; }, get front() { return front; }, get flash() { return flash; }, get zoom() { return zoom; }, get roll() { return roll; }, get tiltOpen() { return tiltOpen; },
      get recording() { return !!rec; }, get canRecord() { return canRecord(); }
    };
  }

  return { mount, MSG };
})();
