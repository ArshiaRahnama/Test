/* ===================== REDES SOCIAIS - Instashot · Tweeter · Reels (motor partilhado) ===================== */
(() => {
  const g = UI.g;
  const rpc = Bridge.rpc;
  const profileCache = {};
  /* Config.Social com a rede desligada: o servidor responde { error:'off' } a TODOS os social.* (server/social.lua:1588-1616).
     Com o rpc() normal isso virava null, a app abria o formulário de criar conta, o createProfile
     respondia 'off' outra vez e o jogador lia «Nome em uso · Escolhe outro nome» - mentira dupla. */
  function lightView(app, win, title) {
    /* a Reels declara `statusBar: 'dark'` (o feed dela é preto de ecrã inteiro) e ESTE ecrã é claro:
       sem isto a hora, os ícones da barra de estado e a barra de baixo ficavam brancos sobre branco.
       Repõe-se no fecho da janela, como o Match faz com o mesmo campo. */
    const d = App.get(app);
    if (d && d.statusBar) { const antes = d.statusBar; d.statusBar = undefined; const prevClose = win.onClose; win.onClose = () => { d.statusBar = antes; prevClose && prevClose(); }; if (System.updateSbTheme) System.updateSbTheme(); }
    return UI.view({ title: title || App.name(app) || '', large: true });
  }
  function offView(app, win) {
    const v = lightView(app, win);
    v.content.appendChild(UI.empty('ban', 'Rede desligada', 'Esta rede está desligada neste servidor.'));
    UI.setRoot(win, v);
  }
  /* 1.1.6: o que dizer de um código de erro do servidor (as frases já existem nos dicionários) */
  const ERR_MSG = { db: 'A base de dados ainda está a arrancar. Tenta daqui a pouco.', ratelimit: 'Demasiados pedidos seguidos. Espera um momento.', internal: 'Erro no servidor. Vê a consola do servidor.' };
  const errMsg = code => ERR_MSG[code] || 'Tenta novamente.';
  /* ---------- A FOTOGRAFIA DE UMA PUBLICAÇÃO NUNCA VAI INTEIRA NO social.post (2 nov, "why cant i post in tweeter") ----------
     Os três compositores mandavam o data URL inteiro (100-260 KB) dentro do social.post, num único evento de rede, que o
     FiveM deita fora: o pedido nunca chegava, o cliente esgotava os 10 s e aparecia "Não publicado · Tenta novamente".
     Só os posts de texto saíam. Uma foto escolhida na galeria JÁ está no servidor (subiu aos bocados pelo photos.upload)
     e tem `id`: vai só o `photoId` e é o servidor que copia o url dela para a publicação (server/social.lua, social.post).
     Sem id (foto editada que ainda não está na galeria) guarda-se primeiro com Photos.save, que também vai aos bocados.
     Só o que é pequeno continua inline em `image`: o seed (gradiente) ou um endereço http. Devolve os campos a juntar ao
     social.post, ou { error } com os mesmos códigos do servidor. */
  async function postImage(photo) {
    if (!photo) return {};
    if (photo.video) return { error: 'video' };
    if (photo.id) return { photoId: photo.id };
    const u = typeof photo.url === 'string' ? photo.url : '';
    if (u.slice(0, 5) === 'data:') {
      const s = await Photos.save(u, photo.seed ? { seed: photo.seed } : {});
      if (!s || s.error || !s.id) return { error: s && s.error === 'toolarge' ? 'toolarge' : 'photo' };
      return { photoId: s.id };
    }
    if (u) return { image: u };
    return photo.seed ? { image: photo.seed } : {};
  }
  /* o que dizer de cada recusa do social.post (as três primeiras frases já existiam nos compositores) */
  const POST_ERR = {
    toolarge: 'A fotografia é grande demais.', off: 'Esta rede está desligada neste servidor.', noprofile: 'Não tens conta nesta rede. Fecha e volta a abrir a app.',
    photo: 'Essa fotografia já não está na tua galeria. Escolhe outra.', video: 'Não dá para publicar um vídeo. Escolhe uma fotografia.',
    badimage: 'Essa imagem não pode ser publicada.', noplayer: 'Sessão do jogador não encontrada.',
    timeout: 'O servidor não respondeu. Vê se a publicação apareceu antes de tentares outra vez.',
  };
  const postErr = r => { const c = r && r.error; return POST_ERR[c] || errMsg(c); };
  /* o código vai num elemento à parte: os nós de texto ficam iguais às chaves dos dicionários (o tradutor do DOM compara a frase inteira) */
  const errCode = code => UI.el('<div class="group-footer" style="text-align:center" data-raw>' + UI.esc(String(code || '')) + '</div>');
  /* 1.1.6: um ERRO do servidor (base de dados a arrancar depois de um restart, limite de pedidos, erro interno) já não
     abre o formulário "Criar conta" nem deixa o ecrã vazio: mostra o motivo e um botão para tentar outra vez. Era o
     mesmo defeito do arranque do telemóvel (1.1.5): "sem resposta" era lido como "não há conta" e o jogador tentava
     criar uma conta que já tinha ("Nome em uso", sem nada a vermelho em lado nenhum). */
  function errView(app, win, code, retry) {
    const v = lightView(app, win);
    v.content.appendChild(UI.empty('ban', 'Sem resposta do servidor', errMsg(code)));
    v.content.appendChild(errCode(code));
    const b = UI.el('<div class="btn-p">Tentar outra vez</div>'); b.onclick = () => retry(); v.content.appendChild(b);
    UI.setRoot(win, v);
  }
  async function ensureProfile(app, win, then) {
    let p = profileCache[app];
    if (!p) { const r = await Bridge.rpcRaw('social.profile', { app }); if (r && r.error === 'off') { offView(app, win); return; }
      if (r && r.error) { errView(app, win, r.error, () => ensureProfile(app, win, then)); return; }
      p = r || null; profileCache[app] = p; }
    if (p && p.username) { then(p); return; }
    /* formulário curto: fica CENTRADO na vertical em vez de encostado ao topo com meio ecrã vazio por baixo */
    const v = UI.view({ title: 'Criar conta', large: true, cls: 'soc-signup' });
    const acc = System.account || {}; let avatar = acc.avatar || 1;
    let avatarUrl = null;
    v.content.appendChild(UI.el(`<div class="profile" style="flex-direction:column;justify-content:center"><div class="pvwrap"></div><div class="sub">Toca para pôr uma fotografia</div></div>`));
    const wrap0 = v.content.querySelector('.pvwrap');
    const paint0 = () => {
      wrap0.innerHTML = UI.avatar({ name: acc.username || 'eu', avatar, url: avatarUrl }, 'lg');
      wrap0.firstElementChild.onclick = async () => {
        const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [{ label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' }, { label: 'Usar uma cor', icon: 'personCircle', value: 'col' }] });
        if (k === 'pick') {
          const p = await Photos.pick('Foto de perfil');
          if (!p) return;
          const src = await Photos.data(p);
          const small = src && await Photos.square(src, 112, .68);
          if (small) { avatarUrl = small; paint0(); } else UI.toast('Não consegui usar essa foto');
        } else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paint0(); }
      };
    };
    paint0();
    v.content.appendChild(UI.list([{ items: [{ html: `<input type="text" class="un" placeholder="nome_de_utilizador" maxlength="16" value="${UI.esc(acc.username || '')}" autocapitalize="off">`, cls: 'static' }, { html: `<input type="text" class="bio" placeholder="Bio" maxlength="80">`, cls: 'static' }] }, { footer: 'O nome é público e único nesta rede.' }]));
    const b = UI.el('<div class="btn-p">Criar conta</div>'); b.onclick = async () => { const u = v.content.querySelector('.un').value.trim().toLowerCase(); if (!/^[a-z0-9_.]{3,16}$/.test(u)) { UI.toast('Nome inválido (3-16, letras/números/_/.)'); return; }
      if (window.CC && CC.requireNet && !CC.requireNet('criar a conta')) return;
      /* rpcRaw: o servidor distingue 'off' (rede desligada no Config.Social), 'exists' (já cá tens conta)
         e 'taken' (nome ocupado) - com o rpc() normal os três davam «Nome em uso», e dois deles são falsos */
      const r = await Bridge.rpcRaw('social.createProfile', { app, username: u, bio: v.content.querySelector('.bio').value.trim(), avatar });
      if (!r || r.error) { const why = r && r.error;
        /* 1.1.6: só 'taken'/'invalid' são "Nome em uso"; sem resposta ou erro do servidor diz-se o que é */
        UI.alert(why === 'off' ? { title: 'Rede desligada', msg: 'Esta rede está desligada neste servidor.' }
          : why === 'exists' ? { title: 'Já tens conta', msg: 'Já existe uma conta tua nesta rede. Fecha e volta a abrir a app.' }
          : (why === 'taken' || why === 'invalid') ? { title: 'Nome em uso', msg: 'Escolhe outro nome de utilizador.' }
          : { title: 'Sem resposta do servidor', msg: errMsg(why) });
        return; }
      /* a foto vai num segundo passo: o createProfile não a aceita e não vale a pena
         mudar a assinatura só por isto - se falhar, a conta fica na mesma com a cor */
      if (avatarUrl) { const r2 = await rpc('social.updateProfile', { app, avatarUrl }); if (r2 && !r2.error) Object.assign(r, r2); }
      profileCache[app] = r; Sound.play('success'); then(r); };
    v.content.appendChild(b);
    v.content.appendChild(UI.el(`<div class="group-footer" style="text-align:center;padding-top:14px">Esta conta é só desta rede. O teu número não é mostrado a ninguém.</div>`));
    UI.setRoot(win, v);
  }
  /* o avatar pode ser uma COR (índice) ou uma FOTOGRAFIA tirada com o telemóvel:
     o UI.avatar já sabe mostrar `url`, só faltava passá-lo daqui */
  const av = (u, cls) => UI.avatar({ name: u.username || u.author || '?', avatar: u.avatar, url: u.avatarUrl || u.avatar_url || null }, cls);
  /* reduz uma foto da galeria a um quadrado pequeno: a foto de perfil viaja dentro do
     feed, da pesquisa e das listas, por isso tem de ser leve (≈3-5 KB) */
  async function avatarFromPhotos(title) {
    const p = await Photos.pick(title || 'Foto de perfil');
    if (!p) return null;
    const src = await Photos.data(p);
    if (!src) { UI.toast('Não consegui abrir essa foto'); return null; }
    const small = await Photos.square(src, 112, .68);
    if (!small) { UI.toast('Não consegui reduzir a foto'); return null; }
    return small;
  }
  const timeAgo = ts => UI.timeAgo(ts);
  const VERIFIED = ['lb', 'admin', 'record', 'weazel_news', 'lspd_official'];
  const vb = u => VERIFIED.includes(String(u || '').toLowerCase()) ? '<span class="vbadge">✓</span>' : '';
  const splitLoc = c => { c = c || ''; if (c.startsWith('📍')) { const i = c.indexOf('\n'); return { loc: (i > -1 ? c.slice(2, i) : c.slice(2)).trim(), text: i > -1 ? c.slice(i + 1) : '' }; } return { loc: '', text: c }; };
  async function commentsSheet(app, post, onCount) {
    const body = UI.el('<div></div>'); const list = UI.el('<div></div>'); const comp = UI.el(`<div class="composer" style="border-top:.5px solid var(--sep);background:none"><input type="text" placeholder="Adicionar comentário…" maxlength="200"><div class="send">${g('arrowUp')}</div></div>`); body.append(list, comp);
    const paint = async () => { const cs = fillAvatars((await rpc('social.comments', { app, postId: post.id })) || []); list.innerHTML = ''; if (!cs.length) { const em = UI.empty('chat', 'Sem comentários', 'Sê o primeiro a comentar.'); em.classList.add('compact'); list.appendChild(em); } const liked = Store.get('cmtLikes', []); cs.forEach(c => { const r = UI.el(`<div class="ig-cmt-row">${av(c, 'xs')}<div style="flex:1;font-size:var(--t-subhead)"><b>${UI.esc(c.username)}</b>${vb(c.username)} ${UI.linkify(c.content)}<div class="muted small">${timeAgo(c.created)} · <span class="rep" style="cursor:pointer">Responder</span></div></div><div class="lk ${liked.includes(c.id) ? 'on' : ''}">${g(liked.includes(c.id) ? 'heartFill' : 'heart')}</div></div>`); r.querySelector('.rep').onclick = () => { const i = comp.querySelector('input'); i.value = '@' + c.username + ' '; i.focus(); }; r.querySelector('.lk').onclick = ev => { const on = ev.currentTarget.classList.toggle('on'); ev.currentTarget.innerHTML = g(on ? 'heartFill' : 'heart'); Store.update('cmtLikes', [], l => { const i = l.indexOf(c.id); if (on && i < 0) l.push(c.id); if (!on && i > -1) l.splice(i, 1); }); }; list.appendChild(r); }); onCount && onCount(cs.length); };
    const send = async () => { const t = comp.querySelector('input').value.trim(); if (!t) return; comp.querySelector('input').value = ''; await rpc('social.comment', { app, postId: post.id, content: t }); paint(); };
    comp.querySelector('.send').onclick = send; comp.querySelector('input').onkeydown = e => { if (e.key === 'Enter') send(); };
    UI.sheet({ title: 'Comentários', right: 'Fechar', body }); paint();
  }
  /* gostar escreve no servidor: sem rede o coração ficava virado e o contador subia por nada */
  async function toggleLike(app, post, el, countEl) { if (window.CC && CC.requireNet && !CC.requireNet('gostar')) return; const r = await rpc('social.like', { app, postId: post.id }); post.liked = r && r.liked; post.likes += post.liked ? 1 : -1; if (el) { el.classList.toggle('liked', post.liked); el.innerHTML = g(post.liked ? 'heartFill' : 'heart'); } if (countEl) countEl.textContent = post.likes; if (post.liked) Sound.play('pop'); }
  /* "Copiar ligação" saiu (2026-09-20): não copiava nada, só dizia que sim */
  async function share(app, post) { const v = await UI.actionSheet({ title: 'Partilhar', buttons: [{ label: 'Enviar por mensagem', icon: 'message', value: 'msg' }, ...(app !== 'twix' ? [] : [{ label: 'Repost', icon: 'repeat', value: 'rp' }])] }); if (v === 'msg') { const c = await Contacts.pick('Enviar a'); if (c) { /* a fotografia pode ainda não ter descido (vem aos bocados): vai-se buscá-la antes de enviar */ const im = hasImg(post) ? await media.get(post) : null; if (hasImg(post) && !im) { UI.toast('Não consegui enviar a fotografia'); return; } /* Fase 2: a foto vai aos bocados pelo Msgs.sendPhoto (media.* + mediaId); o data: URL inteiro num só messages.send era cortado pelo FiveM e o pedido ficava sem resposta */ if (im && window.Msgs && typeof Msgs.sendPhoto === 'function') { const r = await Msgs.sendPhoto(c.number, im); UI.toast(r && !r.error ? 'Enviado' : 'Não consegui enviar a fotografia'); return; } const sm = await rpc('messages.send', { to: c.number, type: im ? 'image' : 'text', content: im ? 'Foto' : `@${post.author}: ${post.content}`, payload: im ? { url: typeof im === 'string' ? im : null, seed: typeof im === 'number' ? im : null } : null });
      /* o "Enviado" era incondicional: o messages.send pode recusar (sem conversa, número inválido, rede) */
      UI.toast(sm && !sm.error ? 'Enviado' : 'Não consegui enviar'); } } else if (v === 'rp') { if (window.CC && CC.requireNet && !CC.requireNet('fazer repost')) return;
    /* é o MESMO social.post do botão de repost do Tweeter (:709) e merece o mesmo tratamento: com o rpc()
       normal o "Repost feito" aparecia com o servidor a recusar (rede desligada, sem conta, toolarge) */
    const r = await Bridge.rpcRaw('social.post', { app, content: '', repostOf: post.id });
    if (!r || r.error) { UI.toast(r && r.error === 'off' ? 'Esta rede está desligada' : 'Não foi possível fazer repost'); return; }
    UI.toast('Repost feito'); } }
  const imgCss = im => im ? (typeof im === 'number' ? photoBg(im) : `url("${im}")`) : '';

  /* ---------- FOTOGRAFIAS DAS PUBLICAÇÕES AOS BOCADOS ----------
     As listas do servidor (feed, perfil, hashtag, respostas, guardados) deixaram de trazer o base64:
     uma página de 12 publicações eram 1-3 MB num único evento de rede. Uma fotografia a sério vem só
     com `imageLen` e desce pelo `social.post.media` em bocados de 48 KB, como as stories e as Fotos;
     seeds e endereços curtos continuam a vir na própria publicação (`image`).
     · só se pede quando a peça está perto do ecrã (lazyBg) ou é mostrada sozinha (loadNow);
     · no máximo 2 fotografias a descer ao mesmo tempo: cada bocado é um RPC e 12 em paralelo era
       pedir tempos esgotados;
     · as últimas 24 ficam em cache por id - voltar atrás no scroll ou abrir a publicação não repete. */
  const hasImg = p => !!(p && (p.image || p.imageLen));
  const media = (() => {
    const cache = new Map(), jobs = new Map(), queue = [];
    let running = 0;
    const keep = (id, v) => { cache.delete(id); cache.set(id, v); while (cache.size > 24) cache.delete(cache.keys().next().value); };
    const download = async p => {
      const total = Math.ceil(p.imageLen / (p.chunk || 48000));
      if (!total || total > 64) return null;
      let out = '';
      for (let i = 1; i <= total; i++) {
        const r = await Bridge.rpcRaw('social.post.media', { id: p.id, i });
        if (!r || r.error || typeof r.data !== 'string') return null;
        out += r.data;
        if (!r.data.length) break;
      }
      return out || null;
    };
    const pump = () => {
      while (running < 2 && queue.length) {
        const job = queue.shift();
        /* a peça saiu de perto do ecrã enquanto esperava a vez: não se gasta a rede com ela */
        if (job.want && !job.want()) { jobs.delete(job.id); job.done(null); continue; }
        running++;
        download(job.p).catch(() => null).then(v => { running--; jobs.delete(job.id); if (v) keep(job.id, v); job.done(v); pump(); });
      }
    };
    /* `want` (opcional): ainda interessa quando chegar a vez? Sem ele o pedido é incondicional. */
    const get = (p, want) => {
      if (!p) return Promise.resolve(null);
      if (p.image) return Promise.resolve(p.image);
      if (!p.imageLen) return Promise.resolve(null);
      if (cache.has(p.id)) { const v = cache.get(p.id); keep(p.id, v); return Promise.resolve(v); }
      const j = jobs.get(p.id);
      if (j) { const w0 = j.want; j.want = (w0 && want) ? () => w0() || want() : null; return j.pr; }
      const job = { id: p.id, p, want: want || null };
      job.pr = new Promise(done => { job.done = done; });
      jobs.set(p.id, job); queue.push(job); pump();
      return job.pr;
    };
    return { get };
  })();
  /* fundo de uma peça com fotografia: a inline pinta já; a que vem aos bocados fica marcada em `_post`
     para o lazyBg (ou o loadNow) a ir buscar */
  const postBg = (el, p) => { if (!el || !p) return; if (p.image) { el._bg = imgCss(p.image); el.style.backgroundImage = el._bg; } else if (p.imageLen) el._post = p; };
  const loadNow = el => { const p = el && el._post; if (!p || el._bg) return; media.get(p).then(u => { if (!u) return; el._bg = imgCss(u); el.style.backgroundImage = el._bg; }); };

  /* ---------- FOTOGRAFIAS SÓ QUANDO ESTÃO PERTO DO ECRÃ ----------
     Cada fundo é uma textura decodificada no CEF. Com o scroll infinito o feed juntava DEZENAS ao
     mesmo tempo, todas retidas enquanto a app estivesse aberta. O endereço fica guardado em `_bg` no
     elemento (ou a publicação em `_post`, se a fotografia ainda não desceu) e este observer põe-no
     quando falta menos de um ecrã e tira-o quando se afasta - no máximo ~3 ecrãs de imagens.
     Serve o Instashot e o Tweeter. Morre com a vista. */
  const lazyBg = v => {
    const io = new IntersectionObserver(es => es.forEach(x => {
      const el = x.target; if (!el._bg && !el._post) return;
      el._near = x.isIntersecting;
      if (x.isIntersecting) {
        if (el.style.backgroundImage) return;
        if (el._bg) el.style.backgroundImage = el._bg;
        else media.get(el._post, () => el._near && el.isConnected).then(u => { if (!u) return; el._bg = imgCss(u); if (el._near) el.style.backgroundImage = el._bg; });
      } else el.style.backgroundImage = '';
    }), { root: (v && v.content) || null, rootMargin: '100% 0px' });
    if (v) { const prev = v.opts.onPop; v.opts.onPop = () => { io.disconnect(); prev && prev(); }; }
    return { add: el => { if (el) io.observe(el); }, stop: () => io.disconnect() };
  };
  /* o servidor manda a foto de perfil SÓ no primeiro comentário de cada pessoa (repetida em 200 linhas
     eram MB por abertura); aqui repõe-se nas restantes antes de pintar */
  const fillAvatars = cs => { const m = {}; cs.forEach(c => { if (c.avatarUrl) m[c.username] = c.avatarUrl; }); cs.forEach(c => { if (!c.avatarUrl && m[c.username]) c.avatarUrl = m[c.username]; }); return cs; };

  /* ---------------- INSTASHOT ----------------
     Feed, stories com 24 h, explorar, pesquisa, perfil completo, comentários com
     respostas, listas de gostos/seguidores e criação de publicação e de story.
     Tudo assente no servidor (server/social.lua) - nada fica só neste aparelho. */
  App.define('instashot', {
    name: 'Instashot', category: 'Redes sociais', needs: ['photos', 'camera'],   /* a câmara dos stories É a câmara do telemóvel (CamView): pede a mesma permissão que a app Câmara */
    description: 'Fotografias, stories de 24 horas, reels e mensagens. A rede social de Los Santos.',
    open(win) { ensureProfile('instashot', win, me => {
      const app = 'instashot'; let tabs;
      const esc = UI.esc;

      /* (as fotografias perto do ecrã - lazyBg - e aos bocados - media - vivem no topo do módulo,
         partilhadas com o Tweeter) */

      /* ---------- scroll infinito ----------
         Um sentinela no fim da lista; quando entra no ecrã pede a página seguinte.
         O observer morre com a vista (senão fica a disparar com a app fechada). */
      const infinite = (v, holder, load) => {
        const sent = UI.el('<div class="ig-sent"></div>');
        holder.appendChild(sent);
        let busy = false, done = false;
        const io = new IntersectionObserver(async es => {
          if (!es[0].isIntersecting || busy || done) return;
          busy = true;
          sent.classList.add('on');
          done = await load() === false;
          sent.classList.remove('on');
          if (done) sent.remove();
          busy = false;
        }, { root: v.content, rootMargin: '400px' });
        io.observe(sent);
        const prev = v.opts.onPop;
        v.opts.onPop = () => { io.disconnect(); prev && prev(); };
        return { stop: () => io.disconnect(), sent };
      };

      /* ---------- listas de pessoas (gostos, seguidores, a seguir) ---------- */
      const peopleView = (title, back, fetch) => {
        const v = UI.view({ title, back: back || 'Anterior' });
        const holder = UI.el('<div></div>');
        let all = [];
        const paint = q => {
          holder.innerHTML = '';
          const list = q ? all.filter(u => (u.username + ' ' + (u.name || '')).toLowerCase().includes(q)) : all;
          if (!list.length) { const e = UI.empty('users', 'Ninguém aqui', q ? 'Sem resultados.' : ''); e.classList.add('compact'); holder.appendChild(e); return; }
          holder.appendChild(UI.list([{ items: list.map(u => ({
            avatar: u, label: u.username, sub: u.name || u.bio || '', chevron: false,
            right: u.me ? undefined : followBtn(u),
            onTap: () => userView(u.username),
          })) }]));
        };
        v.content.appendChild(UI.search('Pesquisar', q => paint(q)));
        v.content.appendChild(holder);
        holder.appendChild(UI.spinner());
        fetch().then(r => { all = r || []; paint(''); });
        UI.push(win, v);
        return v;
      };
      const followBtn = u => {
        const b = UI.el(`<div class="pill-btn sm ${u.isFollowing ? 'gray' : 'on'} nostop">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`);
        b.onclick = async ev => {
          ev.stopPropagation();
          const r = await rpc('social.follow', { app, target: u.username });
          u.isFollowing = !!(r && r.following);
          b.className = 'pill-btn sm nostop ' + (u.isFollowing ? 'gray' : 'on');
          b.textContent = u.isFollowing ? 'A seguir' : 'Seguir';
        };
        return b;
      };
      const likersView = post => peopleView('Gostos', 'Anterior', () => rpc('social.likers', { app, postId: post.id }));
      const cmtsTxt = n => !n ? 'Sê o primeiro a comentar…' : n === 1 ? 'Ver 1 comentário' : `Ver os ${n} comentários`;
      const likesTxt = n => n ? `<span class="lc">${n}</span> ${n === 1 ? 'gosto' : 'gostos'}` : 'Sê o primeiro a gostar disto';
      /* ---------- comentários: respostas a um nível, gostos e apagar ---------- */
      async function igComments(post, onCount) {
        const body = UI.el('<div class="ig-cmts-sheet"></div>');
        const list = UI.el('<div class="cl"></div>');
        const comp = UI.el(`<div class="composer ig-cmt-comp"><span class="rt"></span><input type="text" placeholder="Adicionar comentário…" maxlength="200"><div class="send">${g('arrowUp')}</div></div>`);
        body.append(list, comp);
        const inp = comp.querySelector('input'), rt = comp.querySelector('.rt');
        let replyTo = null;
        const setReply = c => {
          replyTo = c;
          rt.textContent = c ? 'a responder a @' + c.username : '';
          rt.classList.toggle('on', !!c);
          if (c) inp.focus();
        };

        const row = (c, isReply) => {
          const e = UI.el(`<div class="ig-cmt-row ${isReply ? 'reply' : ''}">${av(c, 'xs')}<div class="bd"><div class="tx"><b>${esc(c.username)}</b>${vb(c.username)} ${UI.linkify(c.content)}</div>
            <div class="mt"><span class="tm">${timeAgo(c.created)}</span>${c.likes ? `<span class="lc">${c.likes} ${c.likes === 1 ? 'gosto' : 'gostos'}</span>` : ''}<span class="rep">Responder</span>${c.canDelete ? '<span class="del">Apagar</span>' : ''}</div></div>
            <div class="lk ${c.liked ? 'on' : ''}">${g(c.liked ? 'heartFill' : 'heart', 20)}</div>`);
          e.querySelector('.rep').onclick = () => setReply(c);
          e.querySelector('.bd b').onclick = () => { sh.close(); userView(c.username); };
          const del = e.querySelector('.del');
          if (del) del.onclick = async () => {
            if (!await UI.confirm('Apagar comentário', 'Isto apaga também as respostas.', 'Apagar', true)) return;
            await rpc('social.comment.delete', { app, id: c.id });
            paint();
          };
          e.querySelector('.lk').onclick = async ev => {
            const r = await rpc('social.comment.like', { app, id: c.id });
            if (!r) return;
            c.liked = !!r.liked; c.likes = (c.likes || 0) + (c.liked ? 1 : -1);
            ev.currentTarget.classList.toggle('on', c.liked);
            ev.currentTarget.innerHTML = g(c.liked ? 'heartFill' : 'heart', 20);
            const lc = e.querySelector('.lc');
            if (c.likes > 0) { if (lc) lc.textContent = `${c.likes} ${c.likes === 1 ? 'gosto' : 'gostos'}`; else e.querySelector('.tm').insertAdjacentHTML('afterend', `<span class="lc">${c.likes} gosto</span>`); }
            else if (lc) lc.remove();
            if (c.liked) Sound.play('pop');
          };
          return e;
        };

        const paint = async () => {
          const cs = fillAvatars((await rpc('social.comments', { app, postId: post.id })) || []);
          list.innerHTML = '';
          if (!cs.length) { const em = UI.empty('chat', 'Sem comentários', 'Sê o primeiro a comentar.'); em.classList.add('compact'); list.appendChild(em); onCount && onCount(0); return; }
          const tops = cs.filter(c => !c.parent);
          const kids = {};
          cs.filter(c => c.parent).forEach(c => { (kids[c.parent] = kids[c.parent] || []).push(c); });
          tops.forEach(c => {
            list.appendChild(row(c, false));
            (kids[c.id] || []).forEach(k => list.appendChild(row(k, true)));
          });
          onCount && onCount(cs.length);
        };
        const send = async () => {
          const t = inp.value.trim(); if (!t) return;
          inp.value = '';
          await rpc('social.comment', { app, postId: post.id, content: t, parent: replyTo ? replyTo.id : null });
          setReply(null); paint();
        };
        comp.querySelector('.send').onclick = send;
        inp.onkeydown = e => { if (e.key === 'Enter') send(); };
        const sh = UI.sheet({ title: 'Comentários', right: 'Fechar', body });
        paint();
      }

      /* `lazy`: quem chama entrega a `.ig-img` a um lazyBg (feed); sem ele a fotografia é pedida já (publicação aberta sozinha) */
      const postEl = (p, lazy) => { const sl = splitLoc(p.content); const e = UI.el(`<div class="ig-post"><div class="ig-head">${av(p, 'xs')}<div><b>${esc(p.author)}${vb(p.author)}</b>${sl.loc ? `<div class="ig-loc">${esc(sl.loc)}</div>` : ''}</div><div class="more">${g('more')}</div></div><div class="ig-img"></div><div class="ig-actions"><div class="lk ${p.liked ? 'liked' : ''}">${g(p.liked ? 'heartFill' : 'heart')}</div><div class="cm">${g('chat')}</div><div class="sh">${g('send')}</div><div class="bm ${p.saved ? 'liked' : ''}">${g('bookmark')}</div></div><div class="ig-likes">${likesTxt(p.likes)}</div>${sl.text ? `<div class="ig-cap"><b>${esc(p.author)}</b>${UI.linkify(sl.text)}</div>` : ''}<div class="ig-cmts">${cmtsTxt(p.comments)}</div><div class="ig-time">${timeAgo(p.created)}</div></div>`);
        /* a linha dos gostos é repintada por inteiro: com 0 gostos deixa de existir o <span class="lc">, por isso não basta escrever nele */
        const paintLikes = () => {
          const box = e.querySelector('.ig-likes');
          box.innerHTML = likesTxt(p.likes);
          const lc = box.querySelector('.lc');
          if (lc) { lc.style.cursor = 'pointer'; lc.onclick = () => likersView(p); }
        };
        const relike = async t => { await toggleLike(app, p, t, null); paintLikes(); };
        /* a fotografia vai pelo CSSOM, nunca dentro da string de HTML: um data: URL de 200 KB passava pelo parser de HTML (e o que photos.js ja faz).
           O `_bg` fica guardado para o lazyBg do feed a poder tirar e repor conforme a distância ao ecrã. */
        const imgEl = e.querySelector('.ig-img');
        postBg(imgEl, p); if (!lazy) loadNow(imgEl);
        paintLikes();
        e.querySelector('.lk').onclick = ev => relike(ev.currentTarget); let lastTap = 0; e.querySelector('.ig-img').onclick = () => { const n = Date.now(); if (n - lastTap < 350) { const b = UI.el(`<div class="ig-burst">${g('heartFill')}</div>`); e.querySelector('.ig-img').appendChild(b); setTimeout(() => b.remove(), 900); if (!p.liked) relike(e.querySelector('.lk')); } lastTap = n; };
        e.querySelector('.cm').onclick = () => igComments(p, n => { p.comments = n; e.querySelector('.ig-cmts').textContent = cmtsTxt(n); }); e.querySelector('.ig-cmts').onclick = e.querySelector('.cm').onclick; e.querySelector('.sh').onclick = () => share(app, p);
        e.querySelector('.bm').onclick = async ev => { const r = await rpc('social.save', { app, postId: p.id }); if (!r) return; p.saved = !!r.saved; ev.currentTarget.classList.toggle('liked', p.saved); UI.toast(p.saved ? 'Guardado' : 'Removido dos guardados'); };
        e.querySelector('.ig-head b').onclick = () => userView(p.author); e.querySelector('.ig-head .avatar').onclick = () => userView(p.author);
        e.querySelector('.more').onclick = ev => UI.ctxMenu(ev.currentTarget, p.author === me.username ? [{ label: 'Apagar publicação', icon: 'trash', danger: true, onTap: async () => { await rpc('social.deletePost', { app, postId: p.id }); e.remove(); } }] : [{ label: 'Ver perfil', icon: 'personCircle', onTap: () => userView(p.author) }, { label: 'Enviar por mensagem', icon: 'send', onTap: () => share(app, p) }]);   /* "Denunciar" saiu: a denúncia não ia a lado nenhum */
        e.querySelectorAll('.hashtag').forEach(h => h.onclick = () => h.dataset.tag ? tagView(h.dataset.tag.slice(1)) : userView(h.dataset.user.slice(1))); return e; };

      /* feed com scroll infinito: pede 12 de cada vez a partir da última que já tem */
      const feedInto = async (holder, mode, ref, v) => {
        holder.innerHTML = ''; holder.classList.add('feed');
        holder.appendChild(UI.spinner());
        const PAGE = 12;
        let last = null;
        const lz = lazyBg(v);
        /* o elemento em si - `querySelector('.ig-sent')` a cada publicação era uma travessia da
           lista inteira por cada uma das 12 de cada página */
        let sent = null;
        const add = p => { const el = postEl(p, true); if (sent) holder.insertBefore(el, sent); else holder.appendChild(el); lz.add(el.querySelector('.ig-img')); };
        const page = async () => {
          const ps = (await rpc('social.feed', { app, mode, ref, before: last, limit: PAGE })) || [];
          if (ps.length) { last = ps[ps.length - 1].created; ps.forEach(add); }
          return ps.length >= PAGE;
        };
        /* 1.1.6: rpcRaw - um erro do servidor mostra-se (com o código) e toca-se para tentar outra vez; antes passava por "Nada por aqui" */
        const r0 = await Bridge.rpcRaw('social.feed', { app, mode, ref, limit: PAGE });
        holder.innerHTML = '';
        if (r0 && r0.error) { lz.stop(); const em = UI.empty('ban', 'Não foi possível carregar', errMsg(r0.error)); em.appendChild(errCode(r0.error)); em.style.cursor = 'pointer'; em.onclick = () => feedInto(holder, mode, ref, v); holder.appendChild(em); return; }
        const ps = Array.isArray(r0) ? r0 : [];
        if (!ps.length) { lz.stop(); holder.appendChild(UI.empty('camera', 'Nada por aqui', mode === 'home' ? 'Segue pessoas para ver publicações.' : '')); return; }
        ps.forEach(add);
        last = ps[ps.length - 1].created;
        if (v && ps.length >= PAGE) sent = infinite(v, holder, page).sent;
      };

      /* ---------- STORIES ----------
         O sistema vive em js/apps/stories.js (editor com camadas + visualizador).
         Aqui fica só a barra de bolhas e a ligação a esse módulo. */
      let storyGroups = [];
      const storiesRow = async holder => {
        storyGroups = (await rpc('social.stories', { app })) || [];
        const row = UI.el('<div class="stories"></div>');
        const mine = storyGroups.find(x => x.mine);
        /* a minha bolha: tocar no AVATAR abre as minhas stories (se existirem),
           tocar no "+" cria sempre uma nova - como no Instagram */
        const own = UI.el(`<div class="story own"><div class="ring ${mine && !mine.allSeen ? '' : 'seen'}">${av(me)}<div class="plus">${g('plus', 17)}</div></div><span>O teu Story</span></div>`);
        own.querySelector('.plus').onclick = ev => { ev.stopPropagation(); Stories.create(app, me, win); };
        own.onclick = () => { if (mine) openStories(storyGroups.indexOf(mine)); else Stories.create(app, me, win); };
        row.appendChild(own);
        storyGroups.forEach((gr, i) => {
          if (gr.mine) return;
          const s = UI.el(`<div class="story"><div class="ring ${gr.allSeen ? 'seen' : ''}">${av(gr)}</div><span>${esc(gr.author)}</span></div>`);
          s.onclick = () => openStories(i);
          row.appendChild(s);
        });
        holder.innerHTML = '';
        holder.appendChild(row);
      };
      const openStories = startIdx => Stories.open(app, me, win, storyGroups, startIdx, {
        onUser: u => userView(u),
        onTag: t => tagView(t),
        onViewers: vs => peopleView('Visualizações', 'Anterior', async () => vs),
      });
      const createStory = () => Stories.create(app, me, win);
      /* A barra PUBLICAÇÃO · STORY · REEL do ecrã de criação (Stories.create) vive dentro do
         stories.js, que não conhece o `compose()` desta app - avisa por evento e é aqui que
         se decide o que fazer. O off() morre com a janela. */
      const offCompose = Bridge.on('instashot:compose', d => {
        if (!d || d.app !== app) return;
        compose();   /* publicação e reel partilham o mesmo compositor (um reel é uma publicação com #reel) */
      });
      /* "Partilhar → Instashot" nas Fotos (photos.js: Bridge.emit('social:compose', {app, photo}))
         - o Tweeter já ouvia isto e o Instashot tinha deixado de ouvir: abria a app e não acontecia
         nada. Passa a fotografia direta ao compositor (o `preset` do compose). */
      const offShare = Bridge.on('social:compose', d => { if (d && d.app === app) compose(d.photo); });

      /* "Criar": no Instagram é o + do canto SUPERIOR ESQUERDO (antes estava no separador do meio,
         que agora é o avião das mensagens - ver a barra de separadores no fim da app). */
      const criar = async () => {
        const k = await UI.actionSheet({ title: 'Criar', buttons: [{ label: 'Publicação', icon: 'grid', value: 'post' }, { label: 'Story', icon: 'plusCircle', value: 'story' }] });
        if (k === 'post') compose(); else if (k === 'story') createStory();
      };
      const home = () => {
        /* barra de cima igual à do Instagram: + à esquerda, a marca ao centro e SÓ o coração à
           direita. O avião das mensagens desceu para a barra de separadores (ao meio). */
        const v = UI.view({ title: 'Instashot', left: [{ icon: 'plusCircle', cls: 'glass', onTap: criar }], right: [{ icon: 'heart', cls: 'glass', onTap: () => UI.push(win, notifs(true)) }] });
        v.querySelector('.nb-title').innerHTML = `<span class="ig-wordmark">Instashot</span>${vb(me.username)}`;
        const st = UI.el('<div class="ig-stories"></div>'), f = UI.el('<div></div>');
        v.content.append(st, f);
        storiesRow(st); feedInto(f, 'home', null, v);
        return v;
      };

      /* ---------- EXPLORAR: pesquisas recentes, grelha variada e scroll infinito ---------- */
      const RECENT = 'igRecent';
      const explore = () => {
        const v = UI.view({ title: 'Explorar' });
        const res = UI.el('<div></div>');
        let sT = null;
        const s = UI.search('Pesquisar pessoas ou #hashtags', q => { clearTimeout(sT); sT = setTimeout(() => run(q), 180); });
        v.content.append(s, res);
        v.opts.onPop = () => clearTimeout(sT);

        const remember = u => { try { const l = (Store.get(RECENT, []) || []).filter(x => x !== u); l.unshift(u); Store.set(RECENT, l.slice(0, 8)); } catch (e) {} };
        const openUser = u => { remember(u); userView(u); };

        const recents = () => {
          const l = Store.get(RECENT, []) || [];
          if (!l.length) return null;
          const box = UI.el('<div></div>');
          box.appendChild(UI.el(`<div class="ig-recent-h"><b>Recentes</b><span class="clr">Limpar</span></div>`));
          box.querySelector('.clr').onclick = () => { Store.set(RECENT, []); run(''); };
          box.appendChild(UI.list([{ items: l.map(u => ({ avatar: { name: u }, label: u, chevron: false, onTap: () => openUser(u) })) }]));
          return box;
        };

        const run = async q => {
          res.innerHTML = '';
          if (!q) { const r = recents(); if (r) res.appendChild(r); grid(); return; }
          const us = (await rpc('social.search', { app, q })) || [];
          if (us.length) res.appendChild(UI.list([{ header: 'Pessoas', items: us.map(u => ({
            avatar: u, label: u.username, sub: u.name || u.bio || '', chevron: false,
            html: `${esc(u.username)}${vb(u.username)}`,
            onTap: () => openUser(u.username),
          })) }]));
          /* pintar na própria vista (como o Tweeter já faz): com UI.push aqui, escrever "#festa" empilhava SEIS vistas, uma por tecla */
          if (q.startsWith('#')) { const th = UI.el('<div></div>'); res.appendChild(th); feedInto(th, 'hashtag', q.slice(1), v); }
          else if (!us.length) { const e = UI.empty('search', 'Sem resultados', 'Tenta outro nome ou #hashtag.'); e.classList.add('compact'); res.appendChild(e); }
        };

        const grid = async () => {
          const gr = UI.el('<div class="ig-grid varied"></div>');
          res.appendChild(gr);
          const PAGE = 18;
          let last = null, n = 0, sent = null;
          const lz = lazyBg(v);
          const tile = (p, podeGrande) => {
            /* de 9 em 9 uma peça alta, para a grelha não ficar monótona (como no Explorar do Instagram).
               ⚠️ só quando ainda vêm pelo menos mais duas: a peça alta ocupa duas filas e, sem vizinhas
               para o `grid-auto-flow:dense` encaixar ao lado, deixava um buraco branco no fim da grelha. */
            const big = podeGrande && (n % 9) === 4;
            n++;
            const d = UI.el(`<div class="${big ? 'big' : ''}"></div>`);
            postBg(d, p);   /* o lazyBg tira-o quando se afasta (e vai buscar a fotografia quando ela vem aos bocados) */
            d.onclick = () => { const vv = UI.view({ title: 'Publicação', back: 'Explorar' }); vv.content.appendChild(postEl(p)); UI.push(win, vv); };
            return d;
          };
          const add = (p, podeGrande) => { const d = tile(p, podeGrande); if (sent) gr.insertBefore(d, sent); else gr.appendChild(d); lz.add(d); };
          const addAll = l => l.forEach((p, i) => add(p, i + 2 < l.length));
          const page = async () => {
            const ps = (await rpc('social.feed', { app, mode: 'explore', before: last, limit: PAGE })) || [];
            addAll(ps.filter(hasImg));
            if (ps.length) last = ps[ps.length - 1].created;
            return ps.length >= PAGE;
          };
          const ps = (await rpc('social.feed', { app, mode: 'explore', limit: PAGE })) || [];
          const withImg = ps.filter(hasImg);
          if (!withImg.length) { lz.stop(); res.appendChild(UI.empty('camera', 'Ainda sem fotografias', 'Sê o primeiro a publicar.')); return; }
          addAll(withImg);
          if (ps.length) last = ps[ps.length - 1].created;
          if (ps.length >= PAGE) sent = infinite(v, gr, page).sent;
        };
        run('');
        return v;
      };

      /* ---------- criar publicação: pré-visualizar, legenda, local, marcar pessoas ---------- */
      async function compose(preset) {
        const photo = preset || await Photos.pick('Nova publicação');
        if (!photo) return;
        /* carregar o conteúdo antes de mostrar: a galeria é lazy e, sem isto, a publicação
           ia com o `seed` (gradiente) em vez da fotografia real */
        const src = await Photos.data(photo);
        let tagged = [];
        const body = UI.el(`<div><div class="ig-img" style="height:280px;aspect-ratio:auto"></div>
          <div class="group" style="margin-top:12px;padding:12px"><textarea class="ta cap" placeholder="Escreve uma legenda… #hashtags" style="min-height:90px"></textarea></div>
          <div class="group" style="margin-top:12px"><div class="li static">${g('pin', 21)}<input type="text" class="loc" placeholder="Adicionar localização" maxlength="40"></div>
            <div class="li tag"><span>Marcar pessoas</span><span class="li-value tv">Ninguém</span><div class="li-chev">${g('chevR')}</div></div></div></div>`);
        body.querySelector('.ig-img').style.backgroundImage = src ? imgCss(src) : Photos.bg(photo);   /* pelo CSSOM, nunca na string de HTML */
        body.querySelector('.tag').onclick = async () => {
          const q = await UI.prompt('Marcar pessoa', 'Nome de utilizador', 'username');
          if (!q) return;
          const u = q.replace('@', '').trim().toLowerCase();
          if (u && tagged.indexOf(u) < 0) tagged.push(u);
          body.querySelector('.tv').textContent = tagged.length ? tagged.map(x => '@' + x).join(', ') : 'Ninguém';
        };
        UI.sheet({ title: 'Nova publicação', left: 'Cancelar', right: 'Partilhar', body, onDone: () => {
          /* `return false` mantém a folha aberta: a legenda e as marcações não se perdem */
          if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return false;
          const loc = body.querySelector('.loc').value.trim();
          const cap = body.querySelector('.cap').value.trim();
          const tags = tagged.length ? '\n' + tagged.map(x => '@' + x).join(' ') : '';
          const btn = document.querySelector('.sheet-wrap .sh-r');
          if (btn) { btn.textContent = 'A publicar…'; btn.style.opacity = '.5'; }
          /* rpcRaw: o social.post recusa e o telemóvel dizia "Publicado" à mesma. A fotografia vai por REFERÊNCIA
             (postImage → photoId), nunca o `src` inteiro: era isso que fazia o pedido nunca chegar (ver postImage). */
          postImage(photo).then(im => im.error ? im : Bridge.rpcRaw('social.post', Object.assign({ app, content: (loc ? '📍 ' + loc + '\n' : '') + cap + tags }, im)))
            .then(r => { if (!r || r.error) { console.warn('[unique_phone] social.post refused', r && r.error); UI.alert({ title: 'Não publicado', msg: postErr(r) }); if (btn) { btn.textContent = 'Partilhar'; btn.style.opacity = ''; } return; } Sound.play('success'); UI.toast('Publicado'); tabs.go(0); });
        } });
      }
      /* `pushed`: a Atividade deixou de ser um separador (o coração vive no canto superior direito,
         como no Instagram), por isso quando é empilhada precisa do botão de voltar. */
      const notifs = pushed => { const v = UI.view({ title: 'Notificações', large: true, back: pushed ? 'Instashot' : undefined }); rpc('social.notifications', { app }).then(ns => { ns = ns || []; if (!ns.length) { v.content.appendChild(UI.empty('heart', 'Sem atividade', '')); return; } v.content.appendChild(UI.list([{ items: ns.map(n => ({ avatar: n, html: `<b>${UI.esc(n.username)}</b> ${n.type === 'like' ? 'gostou da tua publicação' : n.type === 'comment' ? 'comentou: ' + UI.esc(n.content || '') : 'começou a seguir-te'}`, sub: timeAgo(n.created), chevron: false, onTap: () => userView(n.username) })) }])); }); return v; };
      /* ---------- editar perfil ---------- */
      async function editProfile(u) {
        let avatar = u.avatar || 1;
        let avatarUrl = u.avatarUrl || u.avatar_url || null;
        const body = UI.el(`<div><div class="ig-edit-av"><div class="pvwrap"></div><span>Toca para mudar a fotografia</span></div>
          <div class="group"><div class="li static"><span class="muted" style="width:92px">Nome</span><input type="text" class="nm" maxlength="40" value="${esc(u.name || '')}" placeholder="O teu nome"></div>
            <div class="li static"><span class="muted" style="width:92px">Utilizador</span><input type="text" class="un" maxlength="16" autocapitalize="off" value="${esc(u.username)}"></div>
            <div class="li static"><span class="muted" style="width:92px">Site</span><input type="text" class="ws" maxlength="90" value="${esc(u.website || '')}" placeholder="exemplo.com"></div></div>
          <div class="group" style="margin-top:12px;padding:12px"><textarea class="ta bio" placeholder="Bio" style="min-height:80px">${esc(u.bio || '')}</textarea></div></div>`);
        body.appendChild(UI.list([{ footer: 'Numa conta privada só quem te segue vê as tuas publicações.', items: [{ label: 'Conta privada', toggle: !!u.private, onToggle: v2 => { u.private = v2; } }] }]));
        const wrap = body.querySelector('.pvwrap');
        const paintAv = () => { wrap.innerHTML = UI.avatar({ name: u.username, avatar, url: avatarUrl }, 'lg'); wrap.firstElementChild.onclick = chooseAv; };
        async function chooseAv() {
          const k = await UI.actionSheet({ title: 'Foto de perfil', buttons: [
            { label: 'Escolher das minhas fotos', icon: 'photo', value: 'pick' },
            { label: 'Tirar uma agora', icon: 'camera', value: 'cam' },
            { label: 'Usar uma cor', icon: 'personCircle', value: 'col' },
          ].concat(avatarUrl ? [{ label: 'Remover fotografia', icon: 'trash', danger: true, value: 'del' }] : []) });
          if (k === 'pick') { const s = await avatarFromPhotos('Foto de perfil'); if (s) { avatarUrl = s; paintAv(); } }
          else if (k === 'cam') { UI.toast('Tira a foto e volta aqui'); System.openApp('camera'); }
          else if (k === 'col') { avatar = avatar % 12 + 1; avatarUrl = null; paintAv(); }
          else if (k === 'del') { avatarUrl = null; paintAv(); }
        }
        paintAv();
        UI.sheet({ title: 'Editar perfil', left: 'Cancelar', right: 'Guardar', body, onDone: () => {
          const un = body.querySelector('.un').value.trim().toLowerCase();
          if (!/^[a-z0-9_.]{3,16}$/.test(un)) { UI.toast('Nome de utilizador inválido'); return false; }
          rpc('social.updateProfile', { app, avatar, avatarUrl: avatarUrl || '', name: body.querySelector('.nm').value.trim(), username: un, website: body.querySelector('.ws').value.trim(), bio: body.querySelector('.bio').value.trim(), private: !!u.private })
            .then(r => {
              if (!r || r.error) { UI.alert({ title: 'Não guardado', msg: r && r.error === 'taken' ? 'Esse nome de utilizador já existe.' : r && r.error === 'toolarge' ? 'A fotografia é grande demais.' : 'Nome de utilizador inválido.' }); return; }
              profileCache[app] = r; me.username = r.username; me.avatar = r.avatar; me.avatarUrl = r.avatar_url || null;
              Sound.play('success'); UI.toast('Perfil atualizado'); tabs.go(4);
            });
        } });
      }

      const profileInto = async (v, username, back) => { const u = await rpc('social.user', { app, username }); if (!u) { v.content.appendChild(UI.empty('personCircle', 'Utilizador não encontrado', '')); return; }
        const head = UI.el(`<div class="ig-profile"><div class="top">${av(u, 'lg')}<div class="stats"><div class="st-p"><b>${u.posts}</b><span>publicações</span></div><div class="st-f"><b>${u.followers}</b><span>seguidores</span></div><div class="st-g"><b>${u.following}</b><span>a seguir</span></div></div></div>
          <div class="bio"><b>${esc(u.name || u.username)}</b>${u.private ? `<span class="priv">${g('lock', 17)} Privada</span>` : ''}<br>${UI.linkify(u.bio || '')}${u.website ? `<br><a class="ws">${esc(u.website)}</a>` : ''}</div><div class="btns"></div></div>`);
        const btns = head.querySelector('.btns');
        head.querySelector('.st-f').onclick = () => peopleView('Seguidores', username, () => rpc('social.followers', { app, username, mode: 'followers' }));
        head.querySelector('.st-g').onclick = () => peopleView('A seguir', username, () => rpc('social.followers', { app, username, mode: 'following' }));
        /* o site do perfil abre no Surf (era um "Ligação copiada" que não copiava nada) */
        const ws = head.querySelector('.ws'); if (ws) ws.onclick = () => { if (window.App && App.get('safari') && System.isInstalled('safari')) System.openURL('phone://safari/open?url=' + encodeURIComponent(u.website)); else UI.toast(u.website); };
        if (u.me) {
          const e = UI.el('<div class="pill-btn gray">Editar perfil</div>'); e.onclick = () => editProfile(u);
          /* partilhar = mandar o @ por mensagem a um contacto */
          const s = UI.el('<div class="pill-btn gray">Partilhar perfil</div>'); s.onclick = async () => { const c = await Contacts.pick('Partilhar perfil com'); if (!c) return; const r = await Bridge.rpcRaw('messages.send', { to: c.number, type: 'text', content: `📸 Segue-me no Instashot: @${u.username}` }); if (!r || r.error) { Sound.play('error'); UI.toast('Não consegui enviar'); return; } UI.toast('Enviado a ' + (c.name || c.number)); };
          btns.append(e, s);
        } else {
          const f = UI.el(`<div class="pill-btn ${u.isFollowing ? 'gray' : 'on'}">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`);
          f.onclick = async () => { const r = await rpc('social.follow', { app, target: u.username }); f.className = 'pill-btn ' + (r.following ? 'gray' : 'on'); f.textContent = r.following ? 'A seguir' : 'Seguir'; const c = head.querySelector('.st-f b'); c.textContent = (+c.textContent) + (r.following ? 1 : -1); };
          const m = UI.el('<div class="pill-btn gray">Mensagem</div>'); m.onclick = () => dmThread(u.username);
          btns.append(f, m);
        }
        v.content.appendChild(head);

        /* separadores: publicações · reels · guardados (só no próprio perfil) */
        const TABS = [['grid', 'posts'], ['play', 'reels']].concat(u.me ? [['bookmark', 'saved']] : []);
        const bar = UI.el('<div class="ig-ptabs"></div>');
        const gridBox = UI.el('<div></div>');
        v.content.append(bar, gridBox);
        let cur = 'posts';
        /* uma grelha por perfil pode trazer dezenas de fotografias: o lazyBg só mantém as que estão
           perto do ecrã (um observer por vista, largado no onPop) */
        const lzp = lazyBg(v);
        const gridOf = ps => {
          const gr = UI.el('<div class="ig-grid"></div>');
          ps.filter(hasImg).forEach(p => { const d = UI.el('<div></div>'); postBg(d, p); d.onclick = () => { const vv = UI.view({ title: 'Publicação', back: username }); vv.content.appendChild(postEl(p)); UI.push(win, vv); }; gr.appendChild(d); lzp.add(d); });
          return gr;
        };
        const load = async k => {
          cur = k;
          bar.querySelectorAll('.pt').forEach(b => b.classList.toggle('on', b.dataset.k === k));
          gridBox.innerHTML = '';
          gridBox.appendChild(UI.spinner());
          let ps = [];
          if (k === 'saved') ps = (await rpc('social.saves', { app })) || [];
          else ps = (await rpc('social.feed', { app, mode: 'user', ref: username })) || [];
          if (k === 'reels') ps = ps.filter(p => (p.content || '').toLowerCase().includes('#reel'));
          gridBox.innerHTML = '';
          if (!ps.length) { gridBox.appendChild(UI.empty(k === 'saved' ? 'bookmark' : 'camera', k === 'saved' ? 'Sem guardados' : 'Sem publicações', '')); return; }
          gridBox.appendChild(gridOf(ps));
        };
        TABS.forEach(([icon, k]) => { const b = UI.el(`<div class="pt ${k === 'posts' ? 'on' : ''}" data-k="${k}">${g(icon, 26)}</div>`); b.onclick = () => load(k); bar.appendChild(b); });
        load('posts');
      };
      /* Amigos próximos: a lista existia no servidor desde as stories, mas não havia
         maneira nenhuma de a gerir - o botão verde do editor publicava para ninguém. */
      const closeFriends = async () => {
        const v = UI.view({ title: 'Amigos próximos', back: me.username });
        v.content.appendChild(UI.el('<div class="ig-note">Só estas pessoas veem as stories publicadas para amigos próximos. Ninguém é avisado de que entrou ou saiu da lista.</div>'));
        const sb = UI.el('<div></div>'); v.content.appendChild(sb);
        const box = UI.el('<div></div>'); v.content.appendChild(box);
        UI.push(win, v);
        box.appendChild(UI.spinner());
        const raw = await rpc('social.closefriends', { app });
        /* o Lua devolve {} quando a lista está vazia, e isso chega aqui como objeto */
        const on = new Set(Array.isArray(raw) ? raw : Object.values(raw || {}));
        const fol = (await rpc('social.followers', { app, username: me.username, mode: 'followers' })) || [];
        const people = (Array.isArray(fol) ? fol : []).filter(u => u.username !== me.username);
        let q = '';
        const hdr = () => on.size ? on.size + (on.size === 1 ? ' pessoa' : ' pessoas') : 'Ninguém escolhido';
        const paint = () => {
          box.innerHTML = '';
          const l = people.filter(u => !q || (u.username + ' ' + (u.name || '')).toLowerCase().includes(q));
          if (!l.length) { box.appendChild(UI.empty('star', people.length ? 'Sem resultados' : 'Sem seguidores', people.length ? 'Tenta outro nome.' : 'Quem te seguir aparece aqui.')); return; }
          box.appendChild(UI.list([{ header: hdr(), items: l.map(u => ({
            avatar: { name: u.username, avatar: u.avatar, url: u.avatarUrl || u.avatar_url },
            label: u.username, sub: u.name || '', chevron: false,
            right: `<div class="cf-tick ${on.has(u.username) ? 'on' : ''}">${g('check', 18)}</div>`,
            onTap: async li => {
              const r = await rpc('social.closefriends.toggle', { app, target: u.username });
              if (!r || r.error) { UI.toast('Não consegui alterar'); return; }
              if (r.on) { on.add(u.username); Sound.play('pop'); } else on.delete(u.username);
              /* so muda esta linha e o cabecalho: repintar a lista inteira por innerHTML a cada toque e trabalho a mais no CEF */
              const t = li.querySelector('.cf-tick'); if (t) t.classList.toggle('on', !!r.on);
              const h = box.querySelector('.group-header'); if (h) h.textContent = hdr();
            },
          })) }]));
        };
        sb.appendChild(UI.search('Pesquisar', s => { q = (s || '').toLowerCase(); paint(); }));
        paint();
      };
      const profile = () => { const v = UI.view({ title: me.username, right: [{ icon: 'more', onTap: () => UI.ctxMenu(v.querySelector('.nb-right'), [
          { label: 'Editar perfil', icon: 'pen', onTap: async () => { const u = await rpc('social.user', { app, username: me.username }); if (u) editProfile(u); } },
          { label: 'Amigos próximos', icon: 'star', onTap: () => closeFriends() },
          { label: 'Nova story', icon: 'plusCircle', onTap: () => createStory() },
          { label: 'Guardados', icon: 'bookmark', onTap: () => { const vv = UI.view({ title: 'Guardados', back: me.username }); const box = UI.el('<div></div>'); vv.content.appendChild(box); box.appendChild(UI.spinner()); /* até 100 guardados: as fotografias só perto do ecrã, como nas outras grelhas */ const lzs = lazyBg(vv); rpc('social.saves', { app }).then(ps => { box.innerHTML = ''; ps = ps || []; if (!ps.length) { lzs.stop(); box.appendChild(UI.empty('bookmark', 'Sem guardados', 'Toca no marcador de uma publicação para a guardares.')); return; } const gr = UI.el('<div class="ig-grid"></div>'); ps.forEach(p => { const d = UI.el('<div></div>'); postBg(d, p); lzs.add(d); d.onclick = () => { const v3 = UI.view({ title: 'Publicação', back: 'Guardados' }); v3.content.appendChild(postEl(p)); UI.push(win, v3); }; gr.appendChild(d); }); box.appendChild(gr); }); UI.push(win, vv); } },
        ]) }] }); profileInto(v, me.username); return v; };
      const userView = username => { if (username === me.username) { tabs.go(4); return; } const v = UI.view({ title: username, back: 'Anterior' }); profileInto(v, username); UI.push(win, v); };
      /* com a vista: a hashtag passa a ter scroll infinito e as fotografias entram/saem com o lazyBg */
      const tagView = tag => { const v = UI.view({ title: '#' + tag, back: 'Anterior' }); const f = UI.el('<div></div>'); v.content.appendChild(f); UI.push(win, v); feedInto(f, 'hashtag', tag, v); };
      /* DMs (mensagens diretas via motor de mensagens, app=instashot) */
      /* DMs (mensagens diretas via motor de mensagens, app=instashot).
         A implementação está em js/apps/social-dm.js (chat a sério: avatar, nome, fotos da câmara/galeria,
         mensagens de voz e lista de quem eu sigo em "Nova mensagem"). Aqui fica só a ligação e o contexto.
         ⚠️ O antigo fazia `(await rpc(...) || []).forEach(...)`: quando o servidor respondia um objeto
         ({ error: 'ratelimit' }, por exemplo) o forEach rebentava e a conversa ficava VAZIA sem dizer nada -
         era isto que se via ao abrir uma conversa que a lista mostrava com mensagens. */
      /* resetProfile: o servidor recusou o envio com 'noidentity' (a conta desta rede não é da personagem atual):
         sem esquecer o perfil em cache, reabrir a app mostrava a conta antiga e cada envio voltava a falhar */
      const dmCtx = () => ({ app, me, win, rpc, onUser: u => userView(u), resetProfile: () => { delete profileCache[app]; } });
      const dms = async () => { if (window.SocialDM) return SocialDM.list(dmCtx()); UI.toast('Mensagens indisponíveis'); };
      const dmThread = async username => { if (window.SocialDM) return SocialDM.thread(dmCtx(), username); UI.toast('Mensagens indisponíveis'); };
      /* barra ao estilo do Instagram: encostada as bordas, so icones, sem rotulos (opts.plain) */
      /* ---------- BARRA DE BAIXO, COMO A DO INSTAGRAM ----------
         casa · reels · AVIÃO (mensagens, ao meio) · lupa · o teu avatar.
         O avião estava no canto superior direito e o + ao meio: trocaram de sítio a pedido do
         utilizador (a referência é o Instagram atual). Em cima fica só o coração, à direita. */
      tabs = UI.tabbar(win, [{ icon: 'home', label: 'Início', view: home }, { icon: 'reels', label: 'Reels', view: home }, { icon: 'send', label: 'Mensagens', view: home }, { icon: 'search', label: 'Explorar', view: explore }, { icon: 'personCircle', label: 'Perfil', view: profile }], 0, { plain: true });
      const pt = tabs.el.querySelectorAll('.tab')[4]; if (pt) { const s = pt.querySelector('svg'); if (s) s.outerHTML = av(me, 'xs'); }
      /* Reels e Mensagens NÃO trocam de separador (ficaria o Início por baixo a ser reconstruído):
         o primeiro abre os Reels (camada de ecrã inteiro nesta mesma janela), o segundo empilha as mensagens por cima.
         O `view: home` deles nunca chega a correr, porque o onclick é substituído aqui. */
      const rt = tabs.el.querySelectorAll('.tab')[1];
      if (rt) rt.onclick = () => reelsLayer(win, app, { dm: u => dmThread(u), profile: u => userView(u) });
      const mt = tabs.el.querySelectorAll('.tab')[2];
      /* e nunca DUAS vezes: o separador empurra a vista, não troca de separador, por isso tocar-lhe
         outra vez empilharia outra lista de mensagens por cima da que já lá está */
      if (mt) mt.onclick = () => { const st = win.querySelector('.nav-stack'); const top = st && st.lastElementChild; if (top && top.dataset.dm === '1') return; dms(); };
      /* o ponto vermelho do avião: mensagens por ler (o Instagram mostra um ponto, sem número) */
      const dmDot = async () => { try { const ts = (await rpc('messages.threads', { app })) || []; tabs.badge(2, ts.some(t => t.unread) ? true : 0); } catch (e) {} };
      dmDot();
      const offDm = Bridge.on('message', () => dmDot());
      /* publicar/apagar uma story repinta a barra de bolhas sem reabrir a app */
      const offStories = Bridge.on('stories:changed', d => {
        if (!d || d.app !== app) return;
        const holder = win.querySelector('.ig-stories');
        if (holder) storiesRow(holder);
      });
      const prevClose = win.onClose;
      win.onClose = () => { offStories(); offCompose(); offShare(); offDm(); prevClose && prevClose(); };
    }); }
  });

  /* ---------------- TWIX ---------------- */
  App.define('twix', {
    name: 'Tweeter', category: 'Redes sociais', needs: ['photos'],
    open(win) { ensureProfile('twix', win, me => {
      const app = 'twix'; let tabs;
      /* `lz`: um lazyBg da vista - a fotografia só entra perto do ecrã (e só então desce, se vier aos bocados); sem ele pede-se já */
      const postEl = (p, detail, lz) => { const o = p.original; const e = UI.el(`<div class="tw-post">${o ? `<div class="rp-lbl">${g('repeat')} ${UI.esc(p.author)} fez repost</div>` : ''}${av(o || p, 'sm')}<div class="tw-body"><div class="tw-h"><b>${UI.esc((o || p).author)}${vb((o || p).author)}</b><span class="muted">@${UI.esc((o || p).author)} · ${timeAgo((o || p).created)}</span></div><div class="tw-t">${UI.linkify((o || p).content)}</div>${hasImg(o || p) ? '<div class="tw-img"></div>' : ''}<div class="tw-a"><div class="rp">${g('chat')}<span>${p.comments}</span></div><div class="rt">${g('repeat')}<span>${p.reposts}</span></div><div class="lk ${p.liked ? 'liked' : ''}">${g(p.liked ? 'heartFill' : 'heart')}<span class="lc">${p.likes}</span></div><div class="sh">${g('share')}</div></div></div></div>`); const ti = e.querySelector('.tw-img'); if (ti) { postBg(ti, o || p); if (lz) lz.add(ti); else loadNow(ti); }   /* a fotografia (pode ser base64) nunca vai dentro da string de HTML */
        /* ESPERAR o RPC antes de pintar: toggleLike só escreve p.liked depois do await, por isso o coração ficava um passo atrás
           (tocar num post não gostado repunha o ícone vazio e só o contador subia). currentTarget fica null depois do handler → guardar. */
        e.querySelector('.lk').onclick = async ev => { ev.stopPropagation(); const t = ev.currentTarget; await toggleLike(app, p, null, e.querySelector('.lc')); t.classList.toggle('liked', p.liked); t.firstElementChild.outerHTML = g(p.liked ? 'heartFill' : 'heart'); };
        e.querySelector('.rp').onclick = ev => { ev.stopPropagation(); compose({ replyTo: p }); }; e.querySelector('.rt').onclick = async ev => { ev.stopPropagation(); if (window.CC && CC.requireNet && !CC.requireNet('fazer repost')) return; if (await UI.confirm('Repost', 'Partilhar este post no teu perfil?', 'Repost')) { const r = await Bridge.rpcRaw('social.post', { app, content: '', repostOf: p.id });   /* rpcRaw: sem ele o "Repost feito" aparecia mesmo quando o servidor recusava */
          if (!r || r.error) { UI.toast(r && r.error === 'off' ? 'Esta rede está desligada' : 'Não foi possível fazer repost'); return; } UI.toast('Repost feito'); tabs.go(0); } }; e.querySelector('.sh').onclick = ev => { ev.stopPropagation(); share(app, p); };
        e.querySelector('.tw-h b').onclick = ev => { ev.stopPropagation(); userView((o || p).author); }; e.querySelector('.avatar').onclick = ev => { ev.stopPropagation(); userView((o || p).author); };
        e.querySelectorAll('.hashtag').forEach(h => h.onclick = ev => { ev.stopPropagation(); h.dataset.tag ? tagView(h.dataset.tag.slice(1)) : userView(h.dataset.user.slice(1)); });
        if (!detail) e.onclick = () => postView(p); UI.longPress(e, () => UI.ctxMenu(e, p.author === me.username ? [{ label: 'Apagar post', icon: 'trash', danger: true, onTap: async () => { await rpc('social.deletePost', { app, postId: p.id }); e.remove(); } }] : [{ label: 'Ver perfil', icon: 'personCircle', onTap: () => userView(p.author) }, isMuted((o || p).author) ? { label: 'Reativar @' + (o || p).author, icon: 'bell', onTap: () => setMuted((o || p).author, false) } : { label: 'Silenciar @' + (o || p).author, icon: 'bellOff', onTap: () => { setMuted((o || p).author, true); e.remove(); } }])); return e; };
      /* SILENCIAR a sério (2026-09-20): antes só dizia "Silenciado". A lista fica no telemóvel (Store 'twMuted'): os posts (e reposts)
         dessas contas saem dos feeds Para ti / A seguir / hashtags / pesquisa - no perfil da conta continuam a ver-se. */
      const MUTEK = 'twMuted'; const mutedList = () => (Store.get(MUTEK, []) || []).filter(x => typeof x === 'string');
      const isMuted = u => mutedList().includes(u);
      const setMuted = (u, on) => { const l = mutedList().filter(x => x !== u); if (on) l.push(u); Store.set(MUTEK, l); UI.toast(on ? `@${u} silenciado` : `@${u} reativado`); };
      const mutedSheet = () => { const l = mutedList(); const body = UI.list([{ header: 'Contas silenciadas', items: l.length ? l.map(u => ({ label: '@' + u, chevron: false, value: 'Reativar', onTap: () => { setMuted(u, false); sh.close(); mutedSheet(); } })) : [{ label: 'Não silenciaste ninguém.', cls: 'static' }] }, { footer: 'Mantém o dedo num post para silenciar a conta. Os posts dela deixam de aparecer nos teus feeds.' }]); const sh = UI.sheet({ title: 'Silenciadas', right: 'OK', body }); };
      /* um lazyBg por contentor (o anterior larga-se ao repintar): o feed traz até 60 posts e, com fotografia, eram 60 texturas vivas de uma vez */
      const lzOf = (holder, v) => { if (holder._lz) holder._lz.stop(); return (holder._lz = v ? lazyBg(v) : null); };
      const feedInto = async (holder, mode, ref, v) => { holder.innerHTML = ''; holder.classList.add('feed'); holder.appendChild(UI.spinner());   /* .feed cresce, para o estado vazio e o spinner ficarem centrados em vez de colados ao topo */ const lz = lzOf(holder, v); let ps = (await rpc('social.feed', { app, mode, ref })) || []; if (mode !== 'user') ps = ps.filter(p => !isMuted(p.author) && !(p.original && isMuted(p.original.author))); holder.innerHTML = ''; if (!ps.length) { holder.appendChild(UI.empty('hash', 'Nada por aqui', mode === 'home' ? 'Segue pessoas para veres os posts delas aqui.' : '')); return; } ps.forEach(p => holder.appendChild(postEl(p, false, lz))); };
      /* PearPhone Fold: o botão de escrever passa para a barra direita (em baixo, a seguir aos da vista) e o redondo esconde-se (apps.css) */
      const fab = v => { const f = UI.el(`<div class="fab">${g('pen')}</div>`); f.onclick = () => compose(); if (v) v.rail = auto => ({ primary: (auto.primary || []).concat([[{ icon: 'pen', label: 'Novo post', onTap: () => compose() }]]) }); return f; };
      const home = () => { const v = UI.view({ title: 'Tweeter', large: true, right: [{ icon: 'bellOff', onTap: mutedSheet }] }); const seg = UI.seg(['Para ti', 'A seguir'], 0, i => feedInto(f, i ? 'home' : 'explore', null, v)); const f = UI.el('<div></div>'); v.content.append(seg, f); feedInto(f, 'explore', null, v); v.appendChild(fab(v)); return v; };
      /* debounce de 180 ms (como o Explorar do Instashot) e guarda de sequencia: cada tecla lancava 2 RPC e reconstruia a lista, e uma resposta atrasada pintava por cima da mais recente */
      const search = () => { const v = UI.view({ title: 'Pesquisar', large: true }); const res = UI.el('<div></div>'); let sT = null, seq = 0; const run = async q => { const my = ++seq; res.innerHTML = ''; if (!q) { trends(); return; } if (q.startsWith('#')) { feedInto(res, 'hashtag', q.slice(1), v); return; } const us = (await rpc('social.search', { app, q })) || []; if (my !== seq) return; if (us.length) res.appendChild(UI.list([{ header: 'Pessoas', items: us.map(u => ({ avatar: u, label: u.username, sub: u.bio, chevron: false, onTap: () => userView(u.username) })) }])); const ps = ((await rpc('social.feed', { app, mode: 'explore' })) || []).filter(p => (p.content || '').toLowerCase().includes(q)); if (my !== seq) return; if (ps.length) { const lz = lzOf(res, v); res.appendChild(UI.el('<div class="group-header">Posts</div>')); ps.forEach(p => res.appendChild(postEl(p, false, lz))); } if (!us.length && !ps.length) { const e = UI.empty('search', 'Sem resultados', 'Tenta outro nome ou #hashtag.'); e.classList.add('compact'); res.appendChild(e); } }; v.content.appendChild(UI.search('Pesquisar no Tweeter', q => { clearTimeout(sT); sT = setTimeout(() => run(q), 180); })); v.opts.onPop = () => clearTimeout(sT); v.content.appendChild(res);
        const trends = async () => { const ps = (await rpc('social.feed', { app, mode: 'explore' })) || []; const tags = {}; ps.forEach(p => ((p.content || '').match(/#[\wÀ-ÿ]+/g) || []).forEach(t => tags[t] = (tags[t] || 0) + 1)); const items = Object.entries(tags).sort((a, b) => b[1] - a[1]).slice(0, 10); res.appendChild(UI.list([{ header: 'Tendências para ti', items: items.length ? items.map(([t, n]) => ({ label: t, sub: `${n} post${n > 1 ? 's' : ''}`, chevron: false, onTap: () => tagView(t.slice(1)) })) : [{ label: 'Sem tendências ainda', cls: 'static' }] }])); }; trends(); return v; };
      /* a linha Foto/contador NÃO pode ter a classe `pad`: é a raiz do painel admin (admin.css, fixed + z-index 2200 + opacity 0)
         e virava uma camada invisível por cima da folha - o "Publicar" e o "Cancelar" nunca recebiam o clique (26 out 2026) */
      async function compose(o = {}) { const body = UI.el(`<div><div class="compose-box">${av(me, 'sm')}<textarea class="ta txt" placeholder="${o.replyTo ? 'Escreve a tua resposta' : 'O que se passa?'}" maxlength="280"></textarea></div><div class="tw-cbar" style="display:flex;gap:10px;align-items:center;padding:0 16px"><div class="pill-btn gray img">${g('photo')} Foto</div><span class="muted small cnt">0/280</span><div class="ph" style="margin-left:auto;width:44px;height:44px;border-radius:8px;display:none"></div></div></div>`); let photo = o.photo || null; const ph = body.querySelector('.ph'); if (photo) { ph.style.display = 'block'; ph.style.background = Photos.bg(photo); ph.style.backgroundSize = 'cover'; }
        body.querySelector('.img').onclick = async () => { const p = await Photos.pick(); if (p) { photo = p; ph.style.display = 'block'; ph.style.background = Photos.bg(p); ph.style.backgroundSize = 'cover'; } }; body.querySelector('.txt').oninput = e => body.querySelector('.cnt').textContent = e.target.value.length + '/280';
        UI.sheet({ title: o.replyTo ? 'Responder a @' + o.replyTo.author : 'Novo post', left: 'Cancelar', right: 'Publicar', body, onDone: () => { const t = body.querySelector('.txt').value.trim(); if (!t && !photo) return false; if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return false;
          /* o mesmo que no compositor do Instashot: o social.post pode recusar e o "Publicado" era incondicional. A fotografia vai
             por REFERÊNCIA (postImage → photoId): `photo.url` inteiro num só evento era o que fazia o tweet com foto nunca sair. */
          postImage(photo).then(im => im.error ? im : Bridge.rpcRaw('social.post', Object.assign({ app, content: t, replyTo: o.replyTo ? o.replyTo.id : null }, im))).then(r => { if (!r || r.error) { console.warn('[unique_phone] social.post refused', r && r.error); UI.alert({ title: 'Não publicado', msg: postErr(r) }); return; } Sound.play('success'); UI.toast('Publicado'); tabs.go(tabs.cur); }); } }); setTimeout(() => body.querySelector('.txt').focus(), 400); }
      const postView = async p => { const v = UI.view({ title: 'Post', back: 'Anterior' }); v.content.appendChild(postEl(p, true)); const rs = (await rpc('social.replies', { app, postId: p.id })) || []; v.content.appendChild(UI.el(`<div class="group-header">${rs.length} resposta${rs.length === 1 ? '' : 's'}</div>`)); const lz = rs.length ? lazyBg(v) : null; rs.forEach(r => v.content.appendChild(postEl(r, false, lz))); const b = UI.el('<div class="btn-p btn-s">Responder</div>'); b.onclick = () => compose({ replyTo: p }); v.content.appendChild(b); UI.push(win, v); };
      const profileInto = async (v, username) => { const sp = UI.spinner(); v.content.appendChild(sp);   /* sem isto ficava um ecrã em branco durante o RPC */
        const u = await rpc('social.user', { app, username }); sp.remove();
        if (!u) { v.content.appendChild(UI.empty('personCircle', 'Utilizador não encontrado', 'Este nome não existe nesta rede.')); return; }
        /* UMA raiz só: o UI.el devolve apenas o primeiro filho, por isso a faixa era devolvida e o perfil inteiro (avatar, nome,
           bio, contadores) era deitado fora - o querySelector seguinte dava null, rebentava, e o feed do perfil nunca chegava a carregar.
           Continuam irmãos dentro do invólucro, logo o margin-top negativo do avatar mantém-se. */
        const head = UI.el(`<div class="tw-prof-wrap"><div class="tw-profile-hero" style="--c1:${['#1D9BF0', '#FF375F', '#30D158', '#BF5AF2'][(u.avatar || 1) % 4]}"></div><div class="tw-profile">${av(u)}<div class="nm">${UI.esc(u.username)}</div><div class="hd">@${UI.esc(u.username)}</div><div class="bio">${UI.linkify(u.bio || '')}</div><div class="ff"><span><b>${u.following}</b> a seguir</span><span><b>${u.followers}</b> seguidores</span></div></div></div>`);
        v.content.appendChild(head); const pr = v.content.querySelector('.tw-profile');
        if (u.me) { const e = UI.el('<div class="pill-btn gray">Editar perfil</div>'); e.onclick = async () => { const bio = await UI.prompt('Bio', '', 'Bio', u.bio); if (bio !== null) { await rpc('social.updateProfile', { app, bio }); tabs.go(3); } }; pr.appendChild(e); }
        else { const f = UI.el(`<div class="pill-btn ${u.isFollowing ? 'gray' : 'on'}">${u.isFollowing ? 'A seguir' : 'Seguir'}</div>`); f.onclick = async () => { const r = await rpc('social.follow', { app, target: u.username }); f.className = 'pill-btn ' + (r.following ? 'gray' : 'on'); f.textContent = r.following ? 'A seguir' : 'Seguir'; }; pr.appendChild(f); }
        const f = UI.el('<div></div>'); v.content.appendChild(f); feedInto(f, 'user', username, v); };
      const profile = () => { const v = UI.view({ title: 'Perfil' }); profileInto(v, me.username); v.appendChild(fab(v)); return v; };
      const userView = username => { if (username === me.username) { tabs.go(3); return; } const v = UI.view({ title: username, back: 'Anterior' }); profileInto(v, username); UI.push(win, v); };
      const tagView = tag => { const v = UI.view({ title: '#' + tag, back: 'Anterior' }); const f = UI.el('<div></div>'); v.content.appendChild(f); feedInto(f, 'hashtag', tag, v); UI.push(win, v); };
      const notifs = () => { const v = UI.view({ title: 'Notificações', large: true }); rpc('social.notifications', { app }).then(ns => { ns = ns || []; if (!ns.length) { v.content.appendChild(UI.empty('bell', 'Sem notificações', '')); return; } v.content.appendChild(UI.list([{ items: ns.map(n => ({ avatar: n, html: `<b>${UI.esc(n.username)}</b> ${n.type === 'like' ? 'gostou do teu post' : n.type === 'comment' ? 'respondeu: ' + UI.esc(n.content || '') : 'começou a seguir-te'}`, sub: timeAgo(n.created), chevron: false, onTap: () => userView(n.username) })) }])); }); return v; };
      tabs = UI.tabbar(win, [{ icon: 'home', label: 'Início', view: home }, { icon: 'search', label: 'Pesquisar', view: search }, { icon: 'bell', label: 'Notificações', view: notifs }, { icon: 'personCircle', label: 'Perfil', view: profile }], 0);
      /* o mesmo que no Instashot: o ouvinte morre com a janela, senão fica a agarrá-la */
      const offCompose = Bridge.on('social:compose', d => { if (d && d.app === app) compose({ photo: d.photo }); });
      const prevClose = win.onClose;
      win.onClose = () => { offCompose(); prevClose && prevClose(); };
    }); }
  });

  /* ---------------- REELS (DENTRO do Instashot) ----------------
     A app Reels separada foi retirada (2026-09-18, a pedido do utilizador): duplicava o Instashot. O separador Reels do
     Instashot abre esta camada de ecrã inteiro com as publicações COM FOTO do próprio Instashot, como no Instagram.
     O que se publica aqui leva #reel e aparece também no separador Reels do perfil. `o.dm(username)` abre o Direct. */
  function reelsLayer(win, app, o = {}) {
    if (win.querySelector(':scope > .reels-lay')) return;
    let mode = 'explore';
    const lay = UI.el('<div class="reels-lay"></div>'), root = UI.el('<div class="reels"></div>');
    const top = UI.el('<div class="reels-top"><span class="on" data-m="explore">Para ti</span><span data-m="home">A seguir</span></div>');
    const cam = UI.el(`<div class="reels-cam">${g('camera')}</div>`), back = UI.el(`<div class="reels-back">${g('chevL')}</div>`);
    lay.append(root, top, cam, back); win.appendChild(lay);
    /* fundo preto → barra de estado branca enquanto a camada está aberta (o mesmo mecanismo da Match e dos Mapas) */
    const def = App.get(app) || {}, sbAntes = def.statusBar; def.statusBar = 'dark'; if (System.updateSbTheme) System.updateSbTheme();
    requestAnimationFrame(() => lay.classList.add('in'));
    cam.onclick = async () => { if (window.CC && CC.requireNet && !CC.requireNet('publicar')) return; const p = await Photos.pick('Novo reel'); if (!p) return; let cap = await UI.prompt('Legenda', '', 'Escreve uma legenda… #tags'); if (cap === null) return;
        if (!/#reel\b/i.test(cap)) cap = (cap ? cap + ' ' : '') + '#reel';   /* aparece no separador Reels do perfil */
        /* rpcRaw: o "Reel publicado" era dito mesmo quando o servidor recusava. A fotografia vai por referência (postImage → photoId) */
        const im = await postImage(p);
        const r = im.error ? im : await Bridge.rpcRaw('social.post', Object.assign({ app, content: cap }, im));
        if (!r || r.error) { console.warn('[unique_phone] social.post refused', r && r.error); UI.alert({ title: 'Não publicado', msg: postErr(r) }); return; }
        Sound.play('success'); UI.toast('Reel publicado'); load(); };
      top.querySelectorAll('span').forEach(s => s.onclick = () => { top.querySelectorAll('span').forEach(x => x.classList.toggle('on', x === s)); mode = s.dataset.m; load(); });
      const reel = p => { const saved = Store.get('reelSaved', []).includes(p.id); const e = UI.el(`<div class="reel"><div class="rv"></div><div class="rside"><div class="pf">${av(p)}<div class="plus">+</div></div><div class="lk ${p.liked ? 'liked' : ''}">${g(p.liked ? 'heartFill' : 'heart')}<span class="lc">${p.likes}</span></div><div class="cm">${g('chat')}<span>${p.comments}</span></div><div class="bm ${saved ? 'on' : ''}">${g('bookmark')}<span>${saved ? 'Guardado' : 'Guardar'}</span></div><div class="sh">${g('send')}<span>Enviar</span></div><div class="mo">${g('more')}</div></div><div class="rbot"><b>@${UI.esc(p.author)}${vb(p.author)} <span style="font-weight:400;opacity:.8">· ${timeAgo(p.created)}</span></b><p>${UI.linkify(p.content)}</p><div class="snd">${g('music')} Som original · ${UI.esc(p.author)}</div></div><div class="disc">${av(p, 'xs')}</div></div>`); if (p.image || !p.imageLen) e._bg = imgCss(p.image || 5); else e._post = p;   /* o fundo so e posto quando o reel se aproxima do ecra (ver lz em load); uma fotografia que vem aos bocados so desce entao */
        /* como no Tweeter: esperar o RPC, senão o coração fica invertido (e o duplo toque no vídeo herda o mesmo defeito) */
        e.querySelector('.lk').onclick = async ev => { const t = ev.currentTarget; await toggleLike(app, p, null, e.querySelector('.lc')); t.classList.toggle('liked', p.liked); t.firstElementChild.outerHTML = g(p.liked ? 'heartFill' : 'heart'); }; let lt = 0; e.querySelector('.rv').onclick = () => { const n = Date.now(); if (n - lt < 350) { const b = UI.el(`<div class="ig-burst">${g('heartFill')}</div>`); e.querySelector('.rv').appendChild(b); setTimeout(() => b.remove(), 900); if (!p.liked) e.querySelector('.lk').click(); } lt = n; };
        e.querySelector('.bm').onclick = ev => { const on = ev.currentTarget.classList.toggle('on'); ev.currentTarget.querySelector('span').textContent = on ? 'Guardado' : 'Guardar'; Store.update('reelSaved', [], l => { const i = l.indexOf(p.id); if (on && i < 0) l.push(p.id); if (!on && i > -1) l.splice(i, 1); }); };
        /* "Não tenho interesse" / "Denunciar" (dois toasts sem efeito) deram lugar ao que existe: enviar o reel por mensagem */
        e.querySelector('.mo').onclick = () => UI.actionSheet({ title: '@' + p.author, buttons: [{ label: 'Enviar por mensagem', icon: 'message', value: 'msg' }, { label: 'Ver perfil', icon: 'personCircle', value: 'prof' }] }).then(v => { if (v === 'msg') share(app, p); else if (v === 'prof') { if (o.profile) { exit(); o.profile(p.author); } else UI.toast('@' + p.author); } });
        e.querySelector('.rbot p').onclick = ev => ev.currentTarget.classList.toggle('long');
        e.querySelector('.plus').onclick = async ev => { ev.stopPropagation(); const r = await rpc('social.follow', { app, target: p.author }); ev.currentTarget.style.display = r && r.following ? 'none' : ''; UI.toast(r && r.following ? 'A seguir @' + p.author : 'Deixaste de seguir'); };
        e.querySelector('.cm').onclick = () => commentsSheet(app, p, n => e.querySelector('.cm span').textContent = n); e.querySelector('.sh').onclick = () => share(app, p);
        e.querySelector('.pf').onclick = async () => { const u = await rpc('social.user', { app, username: p.author }); if (!u) return; const r = await UI.actionSheet({ title: '@' + p.author + (u.me ? ' (tu)' : ''), buttons: u.me ? [{ label: 'Apagar reel', icon: 'trash', danger: true, value: 'del' }] : [{ label: u.isFollowing ? 'Deixar de seguir' : 'Seguir', icon: 'personPlus', value: 'f' }, { label: 'Mensagem', icon: 'message', value: 'm' }] }); if (r === 'f') { await rpc('social.follow', { app, target: p.author }); UI.toast(u.isFollowing ? 'Deixaste de seguir' : 'A seguir @' + p.author); } if (r === 'del') { await rpc('social.deletePost', { app, postId: p.id }); e.remove(); } if (r === 'm') { if (o.dm) { exit(); o.dm(p.author); } else UI.toast('Mensagens indisponíveis'); } };
        return e; };
      /* Só o reel VISÍVEL anima. Antes, os 60 reels devolvidos pelo servidor ficavam todos com duas animações infinitas
         (o Ken Burns num fundo de ecrã inteiro e o disco a rodar) = ~120 animações e ~60 texturas de 440×956 permanentes no CEF. */
      let io = null, lz = null;
      const load = async () => { root.innerHTML = ''; if (io) { io.disconnect(); io = null; } if (lz) { lz.disconnect(); lz = null; }
        /* só publicações com fotografia (um post só de texto não faz um reel) */
        const ps = ((await rpc('social.feed', { app, mode })) || []).filter(p => p && (p.image || p.imageLen));
        if (!lay.isConnected) return;
        if (!ps.length) { const em = UI.el('<div class="reel"></div>'); em.appendChild(UI.empty('reels', 'Sem reels', mode === 'home' ? 'Segue pessoas para veres os reels delas aqui.' : 'Publica o primeiro com a câmara, em cima à direita.')); root.appendChild(em); return; }
        io = new IntersectionObserver(es => es.forEach(x => x.target.classList.toggle('play', x.isIntersecting)), { root, threshold: .6 });
        /* o fundo (pode ser uma fotografia em base64) so entra quando o reel esta a menos de um ecra de distancia e sai quando se afasta:
           em vez de N texturas de 440x956 permanentes no CEF ficam no maximo 3 */
        /* `lazy` (vindo do observer): a descida só avança se o reel ainda estiver perto quando chegar a vez */
        const fill = (t, rv, lazy) => { if (t._bg) { rv.style.backgroundImage = t._bg; return; } if (t._post) media.get(t._post, lazy ? () => t._near && t.isConnected : null).then(u => { if (!u) return; t._bg = imgCss(u); if (t._near !== false) rv.style.backgroundImage = t._bg; }); };
        lz = new IntersectionObserver(es => es.forEach(x => { const rv = x.target.querySelector('.rv'); if (!rv) return; x.target._near = x.isIntersecting; if (x.isIntersecting) { if (!rv.style.backgroundImage) fill(x.target, rv, true); } else rv.style.backgroundImage = ''; }), { root, rootMargin: '100% 0px' });
        const add = (p, eager) => { const e = reel(p); if (eager) fill(e, e.querySelector('.rv'), false); root.appendChild(e); io.observe(e); lz.observe(e); };
        ps.slice(0, 3).forEach((p, i) => add(p, !i));                                            /* o primeiro ecrã entra já */
        if (ps.length > 3) setTimeout(() => { if (root.isConnected) ps.slice(3).forEach(add); }, 240);   /* o resto depois da transição */
      };
      /* UM reel por gesto: cada evento da roda somava 956 px à posição já em movimento, por isso um só gesto saltava 2-4 reels.
         As setas passam a ser ouvidas no documento (a janela da app não tem foco) e o listener morre com a camada. */
      let wl = 0; const step = d => { const n = Date.now(); if (n < wl) return; wl = n + 450; root.scrollBy({ top: d * (root.clientHeight || 956), behavior: 'smooth' }); };
      root.addEventListener('wheel', e => { e.preventDefault(); step(e.deltaY > 0 ? 1 : -1); }, { passive: false });
      const kh = e => { if (!root.isConnected || win.classList.contains('bg')) return; if (e.key === 'ArrowDown') step(1); if (e.key === 'ArrowUp') step(-1); if (e.key === 'Escape') exit(); };
      document.addEventListener('keydown', kh);
      /* sair: seta, Esc, ou a app fechar - larga observadores, teclado e devolve a barra de estado da app */
      let gone = false;
      function exit() { if (gone) return; gone = true; if (io) io.disconnect(); if (lz) lz.disconnect(); document.removeEventListener('keydown', kh); def.statusBar = sbAntes; if (System.updateSbTheme) System.updateSbTheme(); lay.classList.remove('in'); setTimeout(() => lay.remove(), 260); if (o.onExit) o.onExit(); }
      back.onclick = exit;
      const prevClose = win.onClose; win.onClose = () => { exit(); prevClose && prevClose(); };
      load();
      return { exit };
  }
})();
