/* ============================================================
   OVERLAY - camadas de ecrã inteiro FORA do telemóvel (painel admin, loja), 2026-10-03
   O body leva .hidden quando o telemóvel está guardado: estas camadas precisam de aparecer na mesma. Overlay.open(id)
   põe body.ov-on (o CSS mostra o body e esconde o .stage) e Overlay.close(id) tira-a quando já não há nenhuma aberta.
   O foco da NUI é do Lua (client/overlay.lua): fechar pela NUI avisa com Bridge.call('overlay', { id, open:false });
   fechar pelo Lua chega como push 'overlay:close' { id } e cada camada trata do seu (Overlay.onClose(id, fn)).
   Overlay.rpc(name, data) → OVRPC[name] no servidor (server/overlay.lua); nomes 'admin.*' só para admins.
   ============================================================ */
/* ============================================================
   CORES DA LOJA E DO PAINEL (4 out): o admin escolhe a cor de MARCA e a cor de FUNDO de cada uma (Painel › Aparência,
   server/admin.lua 'theme', GlobalState 'apex_phone:settings'.theme). Daqui sai a paleta inteira (superfícies, linhas,
   contornos dos botões, brilhos) em JS, sem color-mix (transparente no CEF), numa <style id="ovth"> no fim do <head> que
   passa por cima dos tokens de origem do .pad (admin.css) e do .xs-root (shop.css). Vazio = a paleta de origem (grafite APN).
   Fundos têm de ser ESCUROS e a marca não pode ser quase preta: o texto das duas camadas é claro (okBg / okAcc).
   ============================================================ */
window.OvTheme = (() => {
  const HEX = /^#[0-9a-fA-F]{6}$/;
  const BG_MAX = 0.07, ACC_MIN = 0.06;
  const rgbOf = x => { const n = parseInt(String(x).slice(1), 16); return [(n >> 16) & 255, (n >> 8) & 255, n & 255]; };
  const hexOf = a => '#' + a.map(v => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('').toUpperCase();
  const mix = (a, b, t) => a.map((v, i) => v + (b[i] - v) * t);
  const rgba = (a, al) => `rgba(${a.map(Math.round).join(',')},${al})`;
  const lum = a => { const f = v => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }; return 0.2126 * f(a[0]) + 0.7152 * f(a[1]) + 0.0722 * f(a[2]); };
  const W = [255, 255, 255], K = [0, 0, 0];
  const okBg = x => HEX.test(String(x || '')) && lum(rgbOf(x)) <= BG_MAX;
  const okAcc = x => HEX.test(String(x || '')) && lum(rgbOf(x)) >= ACC_MIN;
  const part = p => ({ acc: p && okAcc(p.acc) ? String(p.acc).toUpperCase() : '', bg: p && okBg(p.bg) ? String(p.bg).toUpperCase() : '' });
  /* tokens de uma camada a partir das duas cores (só os que mudam) */
  function tokens(which, p) {
    p = part(p); const out = {};
    if (p.bg) {
      const B = rgbOf(p.bg);
      if (which === 'admin') Object.assign(out, { '--bg': p.bg, '--in': hexOf(mix(B, W, 0.012)), '--s1': hexOf(mix(B, W, 0.025)), '--s2': hexOf(mix(B, W, 0.045)), '--s3': hexOf(mix(B, W, 0.07)), '--go': hexOf(mix(B, W, 0.085)) });
      else Object.assign(out, { '--xs-bg': p.bg, '--xs-s1': hexOf(mix(B, W, 0.025)), '--xs-s2': hexOf(mix(B, W, 0.045)), '--xs-s3': hexOf(mix(B, W, 0.07)), '--xs-go': hexOf(mix(B, W, 0.085)) });
    }
    if (p.acc) {
      const A = rgbOf(p.acc);
      if (which === 'admin') Object.assign(out, { '--acc': p.acc, '--acc2': hexOf(mix(A, W, 0.15)), '--acc-line': rgba(A, 0.42), '--go-line': rgba(A, 0.62) });
      else Object.assign(out, { '--xs-acc': p.acc, '--xs-acc2': rgba(A, 0.78), '--xs-arg': A.join(','), '--xs-go-line': rgba(A, 0.62) });
    }
    return out;
  }
  const decl = o => Object.keys(o).map(k => `${k}:${o[k]}`).join(';');
  function cssOf(th) {
    th = th || {}; let s = '';
    const a = tokens('admin', th.admin), sh = tokens('shop', th.shop);
    if (Object.keys(a).length) s += `body .pad{${decl(a)}}`;
    if (Object.keys(sh).length) s += `body .xs-root{${decl(sh)}}`;
    const pb = part(th.shop).bg;
    if (pb) { const B = rgbOf(pb);   /* o céu da loja (shop.css .xs-bg-sky) tem o grafite escrito à mão: refeito com o fundo escolhido */
      s += `body .xs-root .xs-bg-sky{background:radial-gradient(ellipse 70% 55% at 50% -14%, rgba(255,255,255,.055), rgba(255,255,255,0) 70%),radial-gradient(ellipse 60% 40% at 50% 112%, rgba(255,255,255,.03), rgba(255,255,255,0) 70%),linear-gradient(180deg, ${hexOf(mix(B, W, 0.012))} 0%, ${pb} 55%, ${hexOf(mix(B, K, 0.18))} 100%)}`;
      s += `body .xs-root .xs-cap-own{box-shadow:0 0 0 2px ${pb}}`; }
    return s;
  }
  let saved = null, shown = '';
  function paint(th) {
    const css = cssOf(th); if (css === shown) return; shown = css;
    let el = document.getElementById('ovth');
    if (!el) { el = document.createElement('style'); el.id = 'ovth'; document.head.appendChild(el); }
    if (el !== document.head.lastElementChild) document.head.appendChild(el);   /* sempre depois dos <link> das camadas */
    el.textContent = css;
  }
  return {
    okBg, okAcc, tokens, BG_MAX, ACC_MIN,
    /* o que está guardado no servidor (push das definições do painel) */
    set(th) { saved = th && typeof th === 'object' ? { shop: part(th.shop), admin: part(th.admin) } : null; paint(saved); },
    /* pré-visualização ao vivo (rascunho do painel); restore() volta ao guardado */
    preview(th) { paint(th); },
    restore() { paint(saved); },
    get saved() { return saved; },
  };
})();

window.Overlay = (() => {
  const open = new Set(), closers = {};
  /* fora do FiveM (browser, _shot.html, _test.html) os pedidos vão a Overlay.mock[name](data) - cada módulo regista os seus */
  const mock = {};
  const sync = () => { document.body.classList.toggle('ov-on', open.size > 0); };
  function rpc(name, data, timeout) {
    if (!window.Bridge || !Bridge.inFiveM) return Promise.resolve().then(() => (mock[name] ? mock[name](data || {}) : { ok: false, error: 'nomock' }));
    if (!Bridge.call) return Promise.resolve({ ok: false, error: 'nobridge' });
    return Bridge.call('ov', { name, data: data || {}, timeout }).then(r => r || { ok: false, error: 'timeout' });
  }
  /* definições do painel admin (client/overlay.lua manda-as no arranque e a cada alteração): apps desligadas para toda a gente */
  /* defaultLang / defaultTheme: idioma e tema das contas novas escolhidos no painel (System.setDefaults) */
  const adminSettings = d => { if (!d) return; if (window.System && System.setAdminDisabled) System.setAdminDisabled(d.disabledApps); OvTheme.set(d.theme); if (window.System && System.setDefaults) System.setDefaults(d); };
  if (window.Bridge && Bridge.on) Bridge.on('admin:settings', adminSettings);
  /* o push do arranque pode chegar antes desta página: pede a lista uma vez depois de carregar */
  if (window.Bridge && Bridge.inFiveM) setTimeout(() => { Bridge.call('admin:settingsGet', {}).then(adminSettings); }, 2500);
  if (window.Bridge && Bridge.on) Bridge.on('overlay:close', d => { const id = d && d.id; if (!id || !open.has(id)) return; open.delete(id); sync(); (closers[id] || []).forEach(fn => { try { fn(false); } catch (e) { console.error(e); } }); });
  return {
    open(id) { open.add(id); sync(); },
    /* fechar pela NUI (botão, ESC): avisa o Lua para largar o foco */
    close(id) { if (!open.has(id)) return; open.delete(id); sync(); if (window.Bridge && Bridge.call) Bridge.call('overlay', { id, open: false }); },
    isOpen(id) { return id ? open.has(id) : open.size > 0; },
    /* fn(fromUI) quando a camada é fechada pelo Lua (o jogador afastou-se, morreu, o admin perdeu a permissão) */
    onClose(id, fn) { (closers[id] = closers[id] || []).push(fn); },
    rpc, mock,
  };
})();
