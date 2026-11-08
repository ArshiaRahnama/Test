/* ============================================================
   INSTASHOT · DIRECT (mensagens privadas) - 2026-09-17
   Antes era um esboço: bolhas de texto, sem avatar, sem nome, sem fotos nem voz, e "Nova mensagem" pedia
   para ESCREVER o nome de utilizador. Agora é um chat a sério, no molde do Zapp mas com a cara do Instagram:
   · lista com avatar, nome real, última mensagem e hora; pesquisa; "Nova mensagem" mostra QUEM EU SIGO;
   · conversa com cabeçalho (avatar + nome + @user), fotos (câmara ou galeria), mensagens de voz e texto;
   · corre sobre o motor de mensagens que já existia (messages.* com app='instashot'): as fotos sobem pelo
     media.* aos bocados (Msgs.sendPhoto) e a voz pelo VoiceMsg - nada de base64 dentro de messages.send.
   window.SocialDM = { list(ctx), thread(ctx, username), label(m) }
   ctx = { app, me, win, rpc, av, onUser } - vem do social.js (é ele que tem a sessão da rede).
   ============================================================ */
window.SocialDM = (() => {
  const g = UI.g, esc = UI.esc;
  const int = v => Math.floor(+v) || 0;
  const payloadOf = m => { const p = m && m.payload; if (!p) return {}; if (typeof p === 'string') { try { return JSON.parse(p) || {}; } catch (e) { return {}; } } return typeof p === 'object' ? p : {}; };
  const midOf = m => int(payloadOf(m).mediaId);
  /* resumo de uma conversa na lista (o Msgs.label é das SMS e não conhece as fotos das DMs) */
  const label = m => { if (!m) return ''; const t = m.type;
    if (t === 'image') return '📷 Fotografia'; if (t === 'audio') return '🎤 Mensagem de voz';
    return String(m.content || '').replace(/\s+/g, ' ').slice(0, 60); };
  /* razão do servidor (server/messages.lua RPC['messages.send'] + dispatcher do server/main.lua) em texto:
     antes o envio ia pelo rpc() normal, que transforma { error } em null, e tudo dava o mesmo
     «Não foi possível enviar» sem dizer porquê (as mesmas frases do ERR do messages.js) */
  const ERR = { ratelimit: 'Demasiados pedidos, espera um instante', toolarge: 'O anexo é demasiado grande', badmedia: 'O anexo já não está disponível',
    media: 'O anexo já não está disponível', badwave: 'A mensagem de voz chegou estragada', target: 'Destinatário inválido', badtype: 'Tipo de mensagem inválido',
    badreply: 'A mensagem a que respondes já não existe', internal: 'Erro no servidor', rpc: 'Sem resposta do servidor', db: 'Sem resposta do servidor',
    off: 'Esta rede está desligada neste servidor.', noidentity: 'Não tens conta nesta rede. Fecha e volta a abrir a app.' };
  const errOf = (r, fb) => { const e = r && typeof r === 'object' ? r.error : (r === false || r == null ? 'rpc' : null); return (e && ERR[e]) || fb; };
  /* um envio recusado com 'noidentity' quer dizer que a conta desta rede já não é desta personagem (troca de
     personagem, conta reposta): esquece o perfil guardado para a app voltar a pedir/criar a conta ao reabrir */
  const failed = (ctx, r, fb) => { if (r && r.error === 'noidentity' && ctx.resetProfile) ctx.resetProfile(); Sound.play('error'); UI.toast(errOf(r, fb), 2600); };

  /* perfis (nome + avatar) com cache curta: a lista e o cabeçalho pedem os mesmos utilizadores */
  const uCache = new Map();
  function user(ctx, username) {
    const k = ctx.app + '|' + username;
    if (uCache.has(k)) return uCache.get(k);
    const p = ctx.rpc('social.user', { app: ctx.app, username }).then(r => r || { username }).catch(() => ({ username }));
    uCache.set(k, p); return p;
  }
  /* avatar de um utilizador da rede: gradiente + iniciais e, se tiver foto, a foto por CSSOM */
  function avatarEl(ctx, username, cls) {
    const el = UI.el(UI.avatar({ name: username, avatar: (username || '').length }, cls || ''));
    user(ctx, username).then(u => {
      if (!u || !el.isConnected) return;
      if (u.name) el.title = u.name;
      const url = u.avatarUrl || u.avatar_url;
      if (typeof u.avatar === 'number') el.setAttribute('style', UI.avatarStyle(u.avatar));
      if (url) { el.style.backgroundImage = UI.img(url); el.style.backgroundSize = 'cover'; el.style.backgroundPosition = 'center'; el.textContent = ''; }
    });
    return el;
  }

  /* ---------- CÂMARA (o mesmo visor da app Câmara, como no Zapp e nas Mensagens) ---------- */
  function camera(win, title) {
    return new Promise(async res => {
      if (!window.CamView || typeof CamView.mount !== 'function') { UI.toast('Câmara indisponível'); res(null); return; }
      if (window.Perm && !(await Perm.request('instashot', 'camera'))) { res(null); return; }
      if (!win.isConnected) { res(null); return; }
      /* ⚠️ a camada leva `igdm-cam` e NÃO a classe do botão da barra: uma classe de botão (40×40) encolhia
         o visor de ecrã inteiro para um círculo no canto (foi o que aconteceu no Zapp). */
      const lay = UI.el(`<div class="msg-cam igdm-cam"><div class="mc-view"></div><div class="mc-still"></div><div class="mc-top"><div class="b x">${g('x', 22)}</div><div class="mc-ttl"></div><div class="b fl off">${g('bolt', 22)}</div></div><div class="mc-bot"><div class="mc-retake">Repetir</div><div class="mc-shut"><div></div></div><div class="mc-send">${g('check')}</div><div class="mc-flip">${g('repeat', 22)}</div></div></div>`);
      lay.querySelector('.mc-ttl').textContent = title || '';
      const view = lay.querySelector('.mc-view'), still = lay.querySelector('.mc-still');
      let cam = null, dead = false, raw = null, busy = false;
      const onKey = e => { if (dead || e.key !== 'Escape') return; e.preventDefault(); e.stopPropagation(); close(null); };
      const offApp = Bridge.on('app:close', id => { if (id === 'instashot') close(null); });
      const offKill = Bridge.on('app:kill', id => { if (id === 'instashot') close(null); });
      function close(v) { if (dead) return; dead = true; document.removeEventListener('keydown', onKey, true); offApp(); offKill(); try { if (cam) cam.destroy(); } catch (e) {} lay.remove(); res(v); }
      document.addEventListener('keydown', onKey, true);
      win.appendChild(lay);
      try { cam = CamView.mount(view, { chrome: 'bare', aspect: (view.clientWidth || 440) / (view.clientHeight || 956), autoActivate: false, aimInside: true }); cam.setActive(true); }
      catch (e) { console.error('[unique_phone] CamView', e); close(null); UI.toast('Não foi possível abrir a câmara'); return; }
      requestAnimationFrame(() => { if (!dead) lay.classList.add('in'); });
      lay.querySelector('.b.x').onclick = () => close(null);
      lay.querySelector('.mc-flip').onclick = () => { if (!raw && cam) cam.flip(); };
      lay.querySelector('.b.fl').onclick = e => { if (!cam) return; cam.setFlash(!cam.flash); e.currentTarget.classList.toggle('off', !cam.flash); };
      lay.querySelector('.mc-shut').onclick = async () => {
        if (busy || dead || raw || !cam) return; busy = true;
        let r = null; try { r = await cam.capture(); } catch (e) { r = null; }
        busy = false; if (dead) return;
        if (!r || !r.raw) { UI.toast((r && r.msg) || 'Não foi possível tirar a fotografia', 3000); return; }
        raw = r.raw; still.style.backgroundImage = UI.img(raw); lay.classList.add('shot'); cam.setActive(false);
      };
      lay.querySelector('.mc-retake').onclick = () => { if (dead || !cam) return; raw = null; still.style.backgroundImage = ''; lay.classList.remove('shot'); cam.setActive(true); };
      lay.querySelector('.mc-send').onclick = () => { if (raw && !dead) close(raw); };
    });
  }

  /* ---------- Nova mensagem: QUEM EU SIGO (e pesquisa em toda a rede) ---------- */
  async function picker(ctx) {
    return new Promise(async res => {
      let done = false; const pick = v => { if (done) return; done = true; res(v); };
      const body = UI.el(`<div class="igdm-pick">${UI.search ? '' : ''}<div class="igdm-pick-list"></div></div>`);
      const holder = body.querySelector('.igdm-pick-list');
      const search = UI.search('Pesquisar', q => paint(q));
      body.insertBefore(search, holder);
      let following = [];
      holder.appendChild(UI.skeleton ? UI.skeleton('list', 5) : UI.el('<div></div>'));
      const rows = list => UI.list([{ header: list.header, items: list.items }]);
      const paint = async q => {
        q = String(q || '').trim().toLowerCase();
        let people = following;
        if (q) {
          const found = (await ctx.rpc('social.search', { app: ctx.app, q })) || [];
          people = (Array.isArray(found) ? found : Object.values(found)).filter(u => u && u.username && u.username !== ctx.me.username);
        }
        holder.innerHTML = '';
        if (!people.length) { holder.appendChild(UI.empty('personCircle', q ? 'Ninguém encontrado' : 'Ainda não segues ninguém', q ? 'Tenta outro nome.' : 'Segue pessoas para lhes enviares mensagens.')); return; }
        holder.appendChild(rows({ header: q ? 'Resultados' : 'A seguir', items: people.map(u => ({
          avatar: { name: u.username, avatar: (u.username || '').length, url: u.avatarUrl || u.avatar_url || null },
          /* pick() ANTES do close(): o close() chama o onClose de forma sincrona (ui.js), que fazia pick(null) primeiro
             e a escolha era ignorada - tocar numa pessoa fechava a folha e nao abria conversa nenhuma */
          label: '@' + u.username, sub: u.name || '', chevron: false, onTap: () => { pick(u.username); sh.close(); },
        })) }));
      };
      const sh = UI.sheet({ title: 'Nova mensagem', right: 'Cancelar', body, cls: 'igdm-pick-sheet', onClose: () => pick(null) });
      const fl = (await ctx.rpc('social.followers', { app: ctx.app, username: ctx.me.username, mode: 'following' })) || [];
      following = (Array.isArray(fl) ? fl : Object.values(fl)).filter(u => u && u.username && u.username !== ctx.me.username);
      paint('');
    });
  }

  /* ---------- LISTA DE CONVERSAS ---------- */
  async function list(ctx) {
    const v = UI.view({ title: 'Mensagens', back: 'Instashot', cls: 'igdm', right: [{ icon: 'compose', onTap: async () => { const u = await picker(ctx); if (u) thread(ctx, u); } }] });
    const holder = UI.el('<div class="igdm-list"></div>');
    v.content.appendChild(holder);
    const paint = async () => {
      const ts = (await ctx.rpc('messages.threads', { app: ctx.app })) || [];
      const rows = (Array.isArray(ts) ? ts : Object.values(ts)).filter(t => t && t.number);
      holder.innerHTML = '';
      if (!rows.length) {
        const em = UI.el('<div class="ig-dm-empty"><b>As tuas mensagens</b><span>Envia fotografias e mensagens privadas a quem segues.</span><div class="go">Enviar mensagem</div></div>');
        em.querySelector('.go').onclick = async () => { const u = await picker(ctx); if (u) thread(ctx, u); };
        holder.appendChild(em); return;
      }
      rows.forEach(t => {
        const row = UI.el(`<div class="igdm-row"><div class="igdm-av"></div><div class="igdm-b"><b></b><span></span></div><div class="igdm-r"></div></div>`);
        row.querySelector('.igdm-av').appendChild(avatarEl(ctx, t.number, 'md'));
        row.querySelector('.igdm-b b').textContent = '@' + t.number;
        user(ctx, t.number).then(u => { if (u && u.name && row.isConnected) row.querySelector('.igdm-b b').textContent = u.name + ' · @' + t.number; });
        const last = t.last || null;
        row.querySelector('.igdm-b span').textContent = label(last) || 'Sem mensagens';
        row.querySelector('.igdm-r').innerHTML = (last && last.created ? `<i>${esc(UI.timeAgo(new Date(last.created)))}</i>` : '') + (t.unread ? '<u></u>' : '');
        row.onclick = () => thread(ctx, t.number);
        holder.appendChild(row);
      });
    };
    await paint();
    if (window.Instants && ctx.app === 'instashot') Instants.attach(ctx.app, ctx.me, ctx.win, v);
    v.dataset.dm = '1'; v.paint = paint;
    const off = Bridge.on('social:dm', () => paint());
    v.opts.onPop = off;
    UI.push(ctx.win, v);
    return v;
  }

  /* ---------- CONVERSA ---------- */
  async function thread(ctx, username) {
    const app = ctx.app, me = ctx.me.username;
    const v = UI.view({ title: '@' + username, back: 'Mensagens', cls: 'igdm-th', solid: true });
    /* cabeçalho: avatar + nome + @user (toque abre o perfil) */
    const head = UI.el('<div class="igdm-head"><div class="igdm-head-av"></div><div class="igdm-head-t"><b></b><span></span></div></div>');
    head.querySelector('.igdm-head-av').appendChild(avatarEl(ctx, username, 'sm'));
    head.querySelector('.igdm-head-t b').textContent = '@' + username;
    user(ctx, username).then(u => { if (u && u.name && head.isConnected) { head.querySelector('.igdm-head-t b').textContent = u.name; head.querySelector('.igdm-head-t span').textContent = '@' + username; } });
    head.onclick = () => { if (ctx.onUser) ctx.onUser(username); };
    v.navbar.querySelector('.nb-title').textContent = ''; v.navbar.querySelector('.nb-title').appendChild(head);

    const th = UI.el('<div class="igdm-thread"></div>');
    const bar = UI.el(`<div class="igdm-comp"><div class="igdm-cam-btn">${g('camera', 22)}</div><div class="igdm-field"><input type="text" maxlength="900" placeholder="Mensagem…"></div><div class="igdm-ph">${g('photo', 22)}</div><div class="igdm-mic">${g('mic', 22)}</div><div class="igdm-send">${g('arrowUp', 20)}</div></div>`);
    v.content.appendChild(th); v.content.style.paddingBottom = '0'; v.appendChild(bar);
    const inp = bar.querySelector('input');
    const seen = new Set();

    const bubble = m => {
      if (!m || seen.has(m.id)) return; seen.add(m.id);
      const mine = m.sender === me;
      const row = UI.el(`<div class="igdm-msg ${mine ? 'me' : 'them'}"></div>`);
      if (m.type === 'image') {
        const box = UI.el('<div class="igdm-img"></div>'); row.appendChild(box);
        const mid = midOf(m), p = payloadOf(m);
        if (mid && window.Msgs && Msgs.media) Msgs.media(mid).then(r => { if (r && r.url && box.isConnected) { box.style.backgroundImage = UI.img(r.url); box._url = r.url; } });
        else if (p.url) { box.style.backgroundImage = UI.img(p.url); box._url = p.url; }
        else if (p.seed != null) box.style.background = photoBg(+p.seed || 1);
        box.onclick = () => { if (box._url && window.Photos) UI.viewer ? UI.viewer(box._url) : UI.alert({ title: 'Fotografia', msg: '' }); };
      } else if (m.type === 'audio') {
        const p = payloadOf(m);
        let pl = null; try { pl = window.VoiceMsg && VoiceMsg.player({ mediaId: midOf(m), duration: p.duration, waveform: Array.isArray(p.waveform) ? p.waveform : [] }); } catch (e) { pl = null; }
        if (pl && pl.nodeType === 1) row.appendChild(pl); else row.appendChild(UI.el('<div class="igdm-b-txt">🎤 Mensagem de voz</div>'));
      } else {
        const b = UI.el('<div class="igdm-b-txt"></div>'); b.textContent = String(m.content || ''); row.appendChild(b);
      }
      th.appendChild(row); v.content.scrollTop = 1e6;
    };

    /* rpcRaw: o motivo da recusa chega até aqui (ver ERR). O texto só sai da caixa quando o servidor aceita:
       antes apagava-se logo e uma recusa perdia a mensagem escrita. `sending` trava o Enter repetido. */
    let sending = false;
    const send = async () => {
      const t = inp.value.trim(); if (!t || sending) return;
      sending = true;
      let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: username, type: 'text', content: t, app }); } catch (e) { r = null; }
      sending = false;
      if (r && !r.error) {
        if (inp.value.trim() === t) inp.value = '';
        bar.classList.toggle('has-text', !!inp.value.trim());
        bubble(r); Sound.play('send');
      } else failed(ctx, r, 'Não foi possível enviar');
    };
    const sendPhoto = async src => {
      if (!src) return;
      if (!window.Msgs || !Msgs.sendPhoto) { UI.toast('Não foi possível enviar a foto'); return; }
      UI.toast('A enviar a foto…');
      const r = await Msgs.sendPhoto(username, src, { app });
      if (r && !r.error) { bubble(r); Sound.play('send'); } else failed(ctx, r, 'A foto não foi enviada');
    };
    bar.querySelector('.igdm-send').onclick = send;
    inp.onkeydown = e => { if (e.key === 'Enter') send(); };
    inp.oninput = () => bar.classList.toggle('has-text', !!inp.value.trim());
    bar.querySelector('.igdm-cam-btn').onclick = async () => { const raw = await camera(ctx.win, '@' + username); if (raw) sendPhoto(raw); };
    bar.querySelector('.igdm-ph').onclick = async () => { if (!window.Photos || !Photos.pick) { UI.toast('A galeria não está disponível'); return; } const p = await Photos.pick('Enviar fotografia'); if (!p) return; const url = await Photos.data(p, true); sendPhoto(url || p.seed); };
    /* voz: o gravador do telemóvel (VoiceMsg) - sobe pelo media.* e a mensagem leva só o id */
    bar.querySelector('.igdm-mic').onclick = () => {
      if (!window.VoiceMsg || !VoiceMsg.supported || !VoiceMsg.supported()) { UI.toast('Sem microfone disponível'); return; }
      bar.classList.add('rec');
      const end = () => { bar.classList.remove('rec'); const old = bar.querySelector('.vmsg-rec'); if (old) old.remove(); };
      try {
        VoiceMsg.recorder(bar, { app, onCancel: end, onSend: async (blob, ms, wave) => {
          end();
          const up = await VoiceMsg.upload(blob, ms, wave);
          if (!up || !up.mediaId) { UI.toast('A mensagem de voz não foi enviada'); return; }
          let r = null; try { r = await Bridge.rpcRaw('messages.send', { to: username, type: 'audio', content: 'Mensagem de voz', app, mediaId: up.mediaId, payload: { mediaId: up.mediaId, duration: Math.round(ms / 1000), waveform: wave } }); } catch (e) { r = null; }
          if (r && !r.error) { bubble(r); Sound.play('send'); } else failed(ctx, r, 'A mensagem de voz não foi enviada');
        } });
      } catch (e) { end(); UI.toast('Não foi possível gravar'); }
    };

    UI.push(ctx.win, v);
    const msgs = (await ctx.rpc('messages.get', { number: username, app })) || [];
    (Array.isArray(msgs) ? msgs : Object.values(msgs)).forEach(bubble);
    ctx.rpc('messages.read', { number: username, app });
    const off = Bridge.on('social:dm', m => { if (m && m.app === app && (m.sender === username || m.receiver === username)) { bubble(m); ctx.rpc('messages.read', { number: username, app }); } });
    v.opts.onPop = off;
    return v;
  }

  return { list, thread, label, picker, camera };
})();
