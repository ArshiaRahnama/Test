(function () {
  const grid = document.getElementById('event_grid');
  if (!grid) return;

  const esc = (v) => String(v == null ? '' : v).replace(/[&<>"']/g, (c) =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const num = (v) => Number(v || 0).toLocaleString('en-US');

  // CEF in FiveM is old: no color-mix(), so derive every tint in JS.
  function tints(hex) {
    const h = String(hex || '#ff9d2f').replace('#', '');
    const n = parseInt(h.length === 3 ? h.replace(/./g, '$&$&') : h, 16) || 0xff9d2f;
    const r = (n >> 16) & 255, g = (n >> 8) & 255, b = n & 255;
    const mix = (t) => `rgb(${Math.round(r + (255 - r) * t)},${Math.round(g + (255 - g) * t)},${Math.round(b + (255 - b) * t)})`;
    const a = (x) => `rgba(${r},${g},${b},${x})`;
    return `--c:${hex};--c-light:${mix(.45)};--c-a08:${a(.08)};--c-a15:${a(.15)};--c-a30:${a(.3)};--c-a55:${a(.55)};`;
  }

  function card(ev, idx) {
    const cols = ev.cols || [];
    const sum = ev.summary || {};
    const top = ev.top || [];

    const key0 = cols.length ? cols[0].key : 'kills';
    const maxV = Math.max(1, ...top.map(r => Number(r[key0] || 0)));
    const rows = top.length
      ? top.map((r, i) => `
        <div class="ev-row" style="--w:${Math.round(Number(r[key0] || 0) / maxV * 100)}%">
          <span class="ev-rank r${i + 1}">${i + 1}</span>
          <span class="ev-pname">${esc(r.name)}</span>
          ${cols.map(c => `<span class="ev-val">${num(r[c.key])}</span>`).join('')}
        </div>`).join('')
      : '<div class="ev-empty">هنوز آماری ثبت نشده</div>';

    const queue = (ev.queue != null)
      ? `<span class="ev-live"><i></i> ${num(ev.queue)} در صف</span>` : '';

    return `
    <div class="ev-card" style="${tints(ev.color)} animation-delay:${idx * 90}ms">
      <div class="ev-glow"></div><div class="ev-stripe"></div>
      <div class="ev-head">
        <div class="ev-icon"><i class="fa-solid ${esc(ev.icon)}"></i></div>
        <div class="ev-titles">
          <div class="ev-en">${esc(ev.nameEn)}</div>
          <div class="ev-fa">${esc(ev.name)}</div>
        </div>
        ${queue}
      </div>
      <div class="ev-desc">${esc(ev.desc)}</div>
      <div class="ev-stats">
        <div><b>${num(sum.players)}</b><span>بازیکن</span></div>
        <div><b>${num(sum.kills)}</b><span>کل کیل</span></div>
        <div><b>${num(sum.wins)}</b><span>${ev.id === 'capture' ? 'امتیاز' : 'برد'}</span></div>
      </div>
      <div class="ev-table">
        <div class="ev-row ev-th">
          <span class="ev-rank">#</span><span class="ev-pname">TOP 5</span>
          ${cols.map(c => `<span class="ev-val">${esc(c.label)}</span>`).join('')}
        </div>
        ${rows}
      </div>
      <div class="ev-cmd"><span>اجرا با کامند</span><b>${esc(ev.cmd)}</b></div>
    </div>`;
  }

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || data.type !== 'loadEvents') return;
    const list = data.data && data.data.events;
    if (!list || !list.length) {
      grid.innerHTML = '<div class="ev-empty big">سیستم ایونت فعلاً در دسترس نیست.</div>';
      return;
    }
    grid.innerHTML = list.map(card).join('');
  });
})();
