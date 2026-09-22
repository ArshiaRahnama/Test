'use strict';

/* ============================================================
   Society Pay NUI  -  wizard-e pardakht | panel-e Boss (vaariz-ha + gozaresh) | pardakht-haye man
   ============================================================ */
const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'esx_society';
const $ = (s, r = document) => r.querySelector(s);
const post = (name, data = {}) =>
    fetch(`https://${RES}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data),
    }).then(r => r.json()).catch(() => null);

const CFG = { sounds: true, autoRefresh: 0 };
const fmt = n => Number(n || 0).toLocaleString('en-US');
const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const toLatin = s => String(s).replace(/[۰-۹]/g, d => '۰۱۲۳۴۵۶۷۸۹'.indexOf(d)).replace(/[٠-٩]/g, d => '٠١٢٣٤٥٦٧٨٩'.indexOf(d));

function hexA(hex, a) {
    const h = String(hex || '#3b6fe0').replace('#', '');
    const n = parseInt(h.length === 3 ? h.split('').map(c => c + c).join('') : h, 16);
    return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}
const faFmt = (o) => new Intl.DateTimeFormat('fa-IR-u-ca-persian-nu-latn', o);
function faDate(s) {
    if (!s) return '';
    try {
        const [d, t] = s.split(' '); const [y, m, dd] = d.split('-').map(Number); const [hh, mm] = (t || '00:00').split(':').map(Number);
        return faFmt({ year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false }).format(new Date(y, m - 1, dd, hh, mm)).replace(',', ' -');
    } catch (e) { return s; }
}
function faShort(s) {
    try { const [y, m, d] = s.split('-').map(Number); return faFmt({ month: '2-digit', day: '2-digit' }).format(new Date(y, m - 1, d, 12)); } catch (e) { return s.slice(5); }
}
function badge(org, color, cls = '') {
    const mono = esc(String(org.label || org.job || '?').slice(0, 3).toUpperCase());
    const inner = org.logo
        ? `<img src="${esc(org.logo)}" alt="" data-mono="${mono}" onerror="badgeFail(this)">`
        : `<span class="mono">${mono}</span>`;
    return `<div class="badge ${cls}" style="--c:${esc(color)}">${inner}</div>`;
}
window.badgeFail = img => { const s = document.createElement('span'); s.className = 'mono'; s.textContent = img.dataset.mono; img.replaceWith(s); };

function toast(msg, kind = 'ok') {
    const el = document.createElement('div');
    el.className = 'toast ' + kind; el.textContent = msg;
    $('#toasts').appendChild(el);
    setTimeout(() => el.remove(), 3200);
}

// seda-ye kootah (WebAudio) - ba P.Sounds khamoosh mishe
function beep(kind = 'ok') {
    if (!CFG.sounds) return;
    try {
        const ctx = beep.ctx || (beep.ctx = new (window.AudioContext || window.webkitAudioContext)());
        const seq = kind === 'ok' ? [660, 880] : kind === 'new' ? [523, 659, 784] : [440];
        seq.forEach((f, i) => {
            const t0 = ctx.currentTime + i * 0.09, o = ctx.createOscillator(), g = ctx.createGain();
            o.type = 'sine'; o.frequency.value = f;
            g.gain.setValueAtTime(0.0001, t0); g.gain.exponentialRampToValueAtTime(0.11, t0 + 0.02); g.gain.exponentialRampToValueAtTime(0.0001, t0 + 0.2);
            o.connect(g); g.connect(ctx.destination); o.start(t0); o.stop(t0 + 0.22);
        });
    } catch (e) { /* ignore */ }
}

function countUp(el, to) {
    if (!el) return;
    const start = performance.now(), dur = 550, target = Number(to) || 0;
    const step = now => {
        const p = Math.min(1, (now - start) / dur), v = Math.round(target * (1 - Math.pow(1 - p, 3)));
        el.textContent = fmt(v);
        if (p < 1 && el.isConnected) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
}

const root = $('#root'), panel = $('#panel'), hd = $('#hd'), bd = $('#bd'), drawer = $('#drawer');
const scrim = document.createElement('div'); scrim.id = 'scrim'; panel.appendChild(scrim);
let mode = null, timer = null;

function header(title, sub, leading = '', color = '') {
    panel.style.setProperty('--pc', color || '#3b6fe0');
    hd.innerHTML = `<div class="hd-title">${leading}<div><h1>${title}</h1>${sub ? `<small>${sub}</small>` : ''}</div></div><button class="x" id="xbtn" aria-label="بستن">✕</button>`;
    $('#xbtn').onclick = closeUI;
}
function show(m, narrow) { mode = m; panel.className = narrow ? 'narrow' : ''; root.classList.add('show'); }
function closeUI() { hideDrawer(); clearInterval(timer); root.classList.remove('show'); mode = null; post('close'); }

/* ============================================================
   /pay  wizard
   ============================================================ */
const P = { step: 1, data: null, dept: null, org: null, typeKey: null, amount: '', purpose: null, note: '', agree: false, busy: false };

function openPay(data) {
    Object.assign(P, { step: 1, data, dept: null, org: null, typeKey: null, amount: '', purpose: data.purposes[0].key, note: '', agree: false, busy: false });
    show('pay', true); renderPay();
}

function stepper() {
    const labels = ['دپارتمان', 'ارگان', 'جزئیات پرداخت'];
    return `<div class="steps">${labels.map((l, i) => {
        const n = i + 1, cls = P.step === n ? 'on' : (P.step > n ? 'done' : '');
        return `<div class="step ${cls}" data-go="${n}"><b>${P.step > n ? '✓' : n}</b>${l}</div>`;
    }).join('')}</div>`;
}
function bindStepper() {
    bd.querySelectorAll('.step.done').forEach(el => el.onclick = () => { P.step = +el.dataset.go; if (P.step < 3) P.agree = false; renderPay(); });
}
const view = html => `<div class="view">${html}</div>`;

function renderPay() {
    header('پرداخت به ارگان‌ها', 'پرداخت به ارگان‌های DOJ و Law Enforcement');
    if (P.step === 1) return payStep1();
    if (P.step === 2) return payStep2();
    return payStep3();
}

function goOrg(dept, org, purpose) {
    P.dept = dept; P.org = org;
    if (!dept.types.find(t => t.key === P.typeKey)) P.typeKey = dept.types[0].key;
    if (purpose && P.data.purposes.find(p => p.key === purpose)) P.purpose = purpose;
    P.amount = ''; P.agree = false; P.step = 3; renderPay();
}

function payStep1() {
    const last = P.data.last && (() => {
        const d = P.data.departments.find(x => x.id === P.data.last.dept), o = d && d.orgs.find(x => x.job === P.data.last.org);
        return d && o ? { d, o } : null;
    })();
    bd.innerHTML = view(stepper() +
        (last ? `<button class="quick" id="quick" style="--c:${esc(last.d.color)}">${badge(last.o, last.d.color, 'sm')}<div><b>پرداخت سریع به ${esc(last.o.label)}</b><small>آخرین ارگانی که به آن پرداخت کردید · ${esc(last.d.label)}</small></div><span class="go">ادامه ←</span></button>` : '') +
        `<div class="h2">دپارتمان را انتخاب کنید</div><div class="sub">پول Bank به حساب سازمان (Society) همان دپارتمان واریز می‌شود.</div>
    <div class="grid2">${P.data.departments.map(d => `
        <button class="dept" data-d="${esc(d.id)}" data-em="${esc(d.emoji || '')}" style="--c:${esc(d.color)};--c22:${hexA(d.color, .22)};--c45:${hexA(d.color, .45)}">
            <div class="em">${d.emoji || '🏛️'}</div>
            <h3>${esc(d.label)}</h3>
            <div class="names">${d.orgs.map(o => esc(o.label)).join(' · ')}</div>
            <div class="foot"><span>${d.orgs.length} ارگان زیرمجموعه</span><span><i class="dot ${d.online ? '' : 'off'}"></i>${d.online} آنلاین</span></div>
        </button>`).join('')}</div>`);
    bindStepper();
    if (last) $('#quick').onclick = () => goOrg(last.d, last.o, P.data.last.purpose);
    bd.querySelectorAll('.dept').forEach(el => el.onclick = () => { P.dept = P.data.departments.find(d => d.id === el.dataset.d); P.step = 2; renderPay(); });
}

function payStep2() {
    const d = P.dept;
    bd.innerHTML = view(stepper() + `<button class="back" id="back">→ بازگشت</button>
    <div class="h2">ارگان زیرمجموعه ${esc(d.label)}</div><div class="sub">پرداخت برای کدام ارگان انجام شود؟</div>
    <div class="grid3">${d.orgs.map(o => `
        <button class="org" data-o="${esc(o.job)}" style="--c:${esc(d.color)}">
            ${badge(o, d.color)}
            <div><b>${esc(o.label)}</b><small><i class="dot ${o.online ? '' : 'off'}"></i>${o.online} آنلاین</small></div>
        </button>`).join('')}</div>`);
    bindStepper();
    $('#back').onclick = () => { P.step = 1; renderPay(); };
    bd.querySelectorAll('.org').forEach(el => el.onclick = () => goOrg(d, d.orgs.find(o => o.job === el.dataset.o)));
}

const curType = () => P.dept.types.find(t => t.key === P.typeKey);
const curPurpose = () => P.data.purposes.find(p => p.key === P.purpose);
const effMax = t => Math.min(t.max, t.remaining == null ? Infinity : t.remaining);

function payValidate() {
    const t = curType(), pu = curPurpose(), amount = parseInt(P.amount || '0', 10) || 0;
    let error = '';
    if (amount > 0) {
        if (amount < t.min) error = `حداقل مقدار ${fmt(t.min)} است.`;
        else if (amount > t.max) error = `حداکثر مقدار ${fmt(t.max)} است.`;
        else if (t.remaining != null && amount > t.remaining) error = `سقف پرداخت ۲۴ ساعته پر شده است. باقی‌مانده: ${fmt(t.remaining)}`;
        else if (amount > t.balance) error = 'موجودی شما کافی نیست.';
        else if (pu.needsNote && !P.note.trim()) error = 'برای بابت «سایر» باید توضیح بنویسید.';
    }
    return { ok: amount > 0 && !error, amount, error, t, pu };
}

function payStep3() {
    const d = P.dept, o = P.org;
    bd.innerHTML = view(stepper() + `<button class="back" id="back">→ بازگشت</button>
    <div class="cols">
      <div class="card">
        <div class="field"><label>نوع پرداخت</label>
            <div class="seg" id="types">${d.types.map(t => `<button data-t="${t.key}" class="${t.key === P.typeKey ? 'on' : ''}"><b>${esc(t.label)}</b><small>موجودی: ${fmt(t.balance)}</small></button>`).join('')}</div></div>
        <div class="field"><label>مبلغ / تعداد <em>*</em></label>
            <input id="amount" class="inp" inputmode="numeric" placeholder="0" autocomplete="off" value="${esc(P.amount)}">
            <div class="chips" id="quick"></div>
            <div class="hint"><span id="range"></span><span id="pretty"></span></div></div>
        <div class="field"><label>بابت <em>*</em></label>
            <div class="chips" id="purposes">${P.data.purposes.map(p => `<button class="chip ${p.key === P.purpose ? 'on' : ''}" data-p="${p.key}">${esc(p.label)}</button>`).join('')}</div></div>
        <div class="field" style="margin-bottom:0"><label>توضیح <span id="noteReq"></span></label>
            <textarea id="note" class="inp" maxlength="${P.data.noteMax}" placeholder="توضیح کوتاه و واضح بنویسید...">${esc(P.note)}</textarea>
            <div class="hint"><span></span><span id="cnt"></span></div></div>
      </div>
      <div class="card receipt">
        <div class="to">${badge(o, d.color, 'lg')}<div><b>${esc(o.label)}</b><small>${esc(d.label)}</small></div></div>
        <div class="kv"><span>نوع</span><b id="rType"></b></div>
        <div class="kv"><span>بابت</span><b id="rPurpose"></b></div>
        <div class="kv"><span>توضیح</span><b id="rNote"></b></div>
        <div class="kv"><span>موجودی بعد از پرداخت</span><b id="rAfter"></b></div>
        <div class="kv big"><span>مبلغ نهایی</span><b id="rAmount"></b></div>
        <div class="warn">توجه کنید که وجه پرداختی به هیچ عنوان قابل برگشت نیست.</div>
        <label class="agree"><span class="chk"><input type="checkbox" id="agree" ${P.agree ? 'checked' : ''}><span></span></span>مطمئن هستم و پرداخت را تأیید می‌کنم</label>
        <div class="err" id="err"></div>
        <button class="btn primary" id="payBtn">پرداخت</button>
      </div>
    </div>`);
    bindStepper();
    $('#back').onclick = () => { P.step = 2; P.agree = false; renderPay(); };

    $('#types').querySelectorAll('button').forEach(b => b.onclick = () => {
        P.typeKey = b.dataset.t; P.amount = '';
        $('#types').querySelectorAll('button').forEach(x => x.classList.toggle('on', x === b));
        $('#amount').value = ''; buildQuick(); refreshPay();
    });
    $('#purposes').querySelectorAll('button').forEach(b => b.onclick = () => {
        P.purpose = b.dataset.p;
        $('#purposes').querySelectorAll('button').forEach(x => x.classList.toggle('on', x === b));
        refreshPay();
    });
    $('#amount').oninput = e => { P.amount = toLatin(e.target.value).replace(/\D/g, '').slice(0, 12); e.target.value = P.amount; refreshPay(); };
    $('#note').oninput = e => { P.note = e.target.value; refreshPay(); };
    $('#agree').onchange = e => { P.agree = e.target.checked; refreshPay(); };
    $('#payBtn').onclick = submitPay;
    buildQuick(); refreshPay();
}

function buildQuick() {
    const t = curType(), cap = Math.min(t.balance, effMax(t));
    const vals = t.quick.filter(v => v >= t.min && v <= effMax(t));
    const q = $('#quick');
    let html = vals.map(v => `<button class="chip" data-v="${v}">${fmt(v)}</button>`).join('');
    const half = Math.floor(cap / 2);
    if (half >= t.min && half < cap) html += `<button class="chip" data-v="${half}">نصف موجودی</button>`;
    if (cap >= t.min) html += `<button class="chip" data-v="${cap}">همه (${fmt(cap)})</button>`;
    q.innerHTML = html;
    q.querySelectorAll('button').forEach(b => b.onclick = () => { P.amount = String(b.dataset.v); $('#amount').value = P.amount; refreshPay(); });
}

function refreshPay() {
    const v = payValidate(), t = v.t, pu = v.pu;
    $('#range').textContent = `حداقل ${fmt(t.min)} · موجودی ${fmt(t.balance)}` + (t.remaining != null ? ` · سقف باقی‌مانده امروز ${fmt(t.remaining)}` : '');
    $('#pretty').textContent = v.amount ? fmt(v.amount) : '';
    $('#noteReq').innerHTML = pu.needsNote ? '<em style="color:var(--danger);font-style:normal">* اجباری</em>' : '<span style="color:var(--text-faint)">(اختیاری)</span>';
    $('#cnt').textContent = `${P.note.length}/${P.data.noteMax}`;
    $('#rType').textContent = t.label; $('#rPurpose').textContent = pu.label;
    $('#rNote').textContent = P.note.trim() || '—';
    $('#rAmount').textContent = v.amount ? `${fmt(v.amount)} ${t.label}` : '—';
    $('#rAfter').textContent = v.amount && v.amount <= t.balance ? fmt(t.balance - v.amount) : '—';
    $('#err').textContent = v.error;
    $('#payBtn').disabled = !(v.ok && P.agree) || P.busy;
}

async function submitPay() {
    const v = payValidate();
    if (!v.ok || !P.agree || P.busy) return;
    P.busy = true; $('#payBtn').disabled = true; $('#payBtn').textContent = 'در حال پرداخت...';
    const res = await post('pay', { dept: P.dept.id, org: P.org.job, type: P.typeKey, amount: v.amount, purpose: P.purpose, note: P.note.trim() });
    P.busy = false;
    if (mode !== 'pay') return;
    if (res && res.ok) return payDone(res);
    $('#payBtn').textContent = 'پرداخت'; refreshPay(); beep('err');
    $('#err').textContent = (res && res.error) || 'خطایی رخ داد.';
}

function payDone(res) {
    P.data.departments.forEach(d => d.types.forEach(t => { if (t.key === res.typeKey) { t.balance = res.balance; t.remaining = res.remaining; } }));
    P.data.last = { dept: P.dept.id, org: P.org.job, purpose: P.purpose };
    header('پرداخت انجام شد', '', '', P.dept.color); beep('ok');
    bd.innerHTML = view(`<div class="done">
        <div class="tick"><svg viewBox="0 0 24 24"><path d="M5 13l4 4L19 7"/></svg></div>
        <h2>پرداخت با موفقیت انجام شد</h2><p>رسید شما ثبت شد و ارگان مطلع شد.</p>
        <div class="card">
            ${res.receipt ? `<div class="kv"><span>شماره رسید</span><b>#${res.receipt}</b></div>` : ''}
            <div class="kv"><span>ارگان</span><b>${esc(res.orgLabel)} · ${esc(res.deptLabel)}</b></div>
            <div class="kv"><span>بابت</span><b>${esc(res.purposeLabel)}</b></div>
            <div class="kv"><span>موجودی جدید ${esc(res.typeLabel)}</span><b>${fmt(res.balance)}</b></div>
            <div class="kv big"><span>مبلغ</span><b>${fmt(res.amount)} ${esc(res.typeLabel)}</b></div>
        </div>
        <div class="row2"><button class="btn ghost" id="again">پرداخت جدید</button><button class="btn primary" id="fin">بستن</button></div></div>`);
    $('#again').onclick = () => { Object.assign(P, { step: 1, dept: null, org: null, amount: '', note: '', agree: false }); renderPay(); };
    $('#fin').onclick = closeUI;
}

/* ============================================================
   Panel-e Boss Action  (faghat Boss-e ordan-haye DOJ / LAW)
   ============================================================ */
const B = { org: null, view: 'list', stats: null, rows: [], type: 'all', search: '', page: 1, pages: 1, total: 0,
    loading: false, report: null, days: null, prevTotal: null };

function openBoss(res) {
    Object.assign(B, { org: res.org, view: 'list', type: 'all', search: '', page: 1, prevTotal: res.stats.total });
    show('boss', false);
    header(`واریزهای دریافتی · ${esc(B.org.label)}`, esc(B.org.deptLabel), badge(B.org, B.org.color), B.org.color);
    bd.innerHTML = view(`<div class="vtabs" id="vtabs"></div><div class="view" id="bview"></div>`);
    bossTabs(); bossShowList(); bossApply(res);
    clearInterval(timer);
    if (CFG.autoRefresh > 0) timer = setInterval(() => {
        if (mode === 'boss' && B.view === 'list' && !drawer.classList.contains('on') && !B.loading) bossLoad(true);
    }, CFG.autoRefresh);
}

function bossTabs() {
    $('#vtabs').innerHTML = `<button data-v="list" class="${B.view === 'list' ? 'on' : ''}">💳 واریزها</button><button data-v="report" class="${B.view === 'report' ? 'on' : ''}">📊 گزارش</button>${CFG.autoRefresh > 0 ? '<span class="live"><i class="dot"></i>بروزرسانی خودکار</span>' : ''}`;
    $('#vtabs').querySelectorAll('button').forEach(b => b.onclick = () => {
        if (B.view === b.dataset.v) return;
        B.view = b.dataset.v; hideDrawer(); bossTabs();
        if (B.view === 'list') { bossShowList(); bossLoad(); } else bossReportLoad(B.days);
    });
}

function bossShowList() {
    $('#bview').innerHTML = `
    <div class="stats" id="stats"></div>
    <div class="bar">
        <select class="sel" id="ftype"><option value="all">همه انواع</option><option value="bank">Bank</option><option value="coin">Coin</option></select>
        <input class="search" id="search" placeholder="جستجو: نام پرداخت‌کننده، توضیح یا شماره رسید (#123)" value="${esc(B.search)}">
        <button class="btn ghost" id="refresh" style="padding:9px 14px">↻ بروزرسانی</button>
    </div>
    <div class="list-wrap">
        <div class="list-head"><span id="headInfo"></span></div>
        <div class="list" id="list"></div>
        <div class="pager"><button id="prev">‹ قبلی</button><span id="pinfo"></span><button id="next">بعدی ›</button></div>
        <div class="loading" id="loading"><div class="spin"></div></div>
    </div>`;
    $('#ftype').value = B.type;
    $('#ftype').onchange = e => { B.type = e.target.value; B.page = 1; bossLoad(); };
    let t; $('#search').oninput = e => { clearTimeout(t); t = setTimeout(() => { B.search = e.target.value.trim(); B.page = 1; bossLoad(); }, 300); };
    $('#refresh').onclick = () => bossLoad();
    $('#prev').onclick = () => { if (B.page > 1) { B.page--; bossLoad(); } };
    $('#next').onclick = () => { if (B.page < B.pages) { B.page++; bossLoad(); } };
}

async function bossLoad(silent) {
    if (B.loading) return;
    B.loading = true; if (!silent && $('#loading')) $('#loading').classList.add('on');
    const res = await post('bossList', { type: B.type, search: B.search, page: B.page });
    B.loading = false; if (mode !== 'boss' || B.view !== 'list') return;
    if ($('#loading')) $('#loading').classList.remove('on');
    if (!res || !res.ok) return silent ? null : toast((res && res.error) || 'خطایی رخ داد.', 'err');
    if (silent && B.prevTotal != null && res.stats.total > B.prevTotal) { toast(`${res.stats.total - B.prevTotal} واریز جدید`, 'new'); beep('new'); }
    bossApply(res);
}

function bossApply(res) {
    B.rows = res.rows || []; B.stats = res.stats; B.page = res.page; B.pages = res.pages; B.total = res.total; B.prevTotal = res.stats.total;
    const s = B.stats;
    $('#stats').innerHTML = [
        ['کل واریزها', s.total, '#3b6fe0'], ['مجموع Bank', s.totalBank, '#3fae6a'],
        ['مجموع Coin', s.totalCoin, '#f0c470'], ['واریز امروز', s.todayCount, '#c9a35d'],
    ].map(([l, v, c]) => `<div class="stat" style="--sc:${c}"><small>${l}</small><b data-n="${v}">0</b></div>`).join('');
    $('#stats').querySelectorAll('b').forEach(b => countUp(b, +b.dataset.n));
    bossRenderList();
}

function rowHtml(r, boss) {
    const d = faDate(r.created);
    return `<div class="row ${boss ? 'click' : ''}" data-id="${r.id}">
        ${boss ? `<div class="avatar" style="--c:${esc(r.color)}">${esc(String(r.name).trim().charAt(0).toUpperCase() || '?')}</div>` : badge({ label: r.orgLabel, logo: r.logo }, r.color, 'sm')}
        <div class="who"><b>${esc(boss ? r.name : r.orgLabel)}</b><small>#${r.id} · ${esc(d)}</small></div>
        <div class="mid"><span class="tag">${esc(r.purposeLabel)}</span><span class="note" title="${esc(r.note)}">${esc(r.note) || '—'}</span></div>
        <div class="amt ${esc(r.payType)}">${fmt(r.amount)}<em>${esc(r.typeLabel)}</em></div>
        ${boss ? '<span class="chev">‹</span>' : ''}
    </div>`;
}

function bossRenderList() {
    const list = $('#list');
    list.innerHTML = B.rows.length
        ? B.rows.map(r => rowHtml(r, true)).join('')
        : `<div class="empty"><div class="big">📭</div>واریزی برای نمایش وجود ندارد.</div>`;
    list.querySelectorAll('.row').forEach((el, i) => {
        el.style.animationDelay = `${Math.min(i, 12) * 18}ms`;
        el.onclick = () => showDrawer(B.rows.find(r => r.id === +el.dataset.id));
    });
    $('#headInfo').textContent = `${fmt(B.total)} مورد`;
    $('#pinfo').textContent = `صفحه ${B.page} از ${B.pages}`;
    $('#prev').disabled = B.page <= 1; $('#next').disabled = B.page >= B.pages;
}

/* ---------- detail drawer ---------- */
function hideDrawer() { drawer.classList.remove('on'); scrim.classList.remove('on'); }
scrim.onclick = hideDrawer;

function showDrawer(r) {
    if (!r) return;
    drawer.innerHTML = `
    <div class="dr-top"><h3>رسید #${r.id}</h3><button class="x" id="drx">✕</button></div>
    <div class="dr-amt"><div class="amt ${esc(r.payType)}">${fmt(r.amount)}<em>${esc(r.typeLabel)}</em></div><span class="tag">${esc(r.purposeLabel)}</span></div>
    <div class="kv"><span>پرداخت‌کننده</span><b>${esc(r.name)}</b></div>
    <div class="kv"><span>ارگان</span><b>${esc(r.orgLabel)} · ${esc(r.deptLabel)}</b></div>
    <div class="kv"><span>نوع</span><b>${esc(r.typeLabel)}</b></div>
    <div class="kv"><span>تاریخ ثبت</span><b>${esc(faDate(r.created))}</b></div>
    <div class="h2" style="margin-top:14px;font-size:13px">توضیح</div>
    <div class="fullnote">${esc(r.note) || '—'}</div>`;
    scrim.classList.add('on'); drawer.classList.add('on');
    $('#drx').onclick = hideDrawer;
}

/* ---------- report ---------- */
async function bossReportLoad(days) {
    $('#bview').innerHTML = `<div class="kpis">${'<div class="sk" style="height:76px"></div>'.repeat(4)}</div><div class="sk" style="flex:1"></div>`;
    const res = await post('bossReport', { days });
    if (mode !== 'boss' || B.view !== 'report') return;
    if (!res || !res.ok) return toast((res && res.error) || 'خطایی رخ داد.', 'err');
    B.report = res; B.days = res.days; bossReportRender();
}

function barChart(series, key, color, h) {
    const w = 640, padB = 22, padT = 10, max = Math.max(1, ...series.map(s => s[key])), n = series.length, bw = w / n, gap = Math.min(10, bw * .3);
    const grid = [.25, .5, .75, 1].map(f => { const y = padT + (h - padB - padT) * (1 - f); return `<line x1="0" x2="${w}" y1="${y}" y2="${y}" stroke="#232833" stroke-dasharray="3 5"/>`; }).join('');
    const bars = series.map((s, i) => {
        const bh = (h - padB - padT) * (s[key] / max), x = i * bw + gap / 2, y = h - padB - bh;
        const label = (n <= 14 || i % 2 === 0) ? faShort(s.date) : '';
        return `<g><rect class="bar-r" style="animation-delay:${i * 20}ms" x="${x}" y="${y}" width="${bw - gap}" height="${Math.max(bh, s[key] > 0 ? 3 : 0)}" rx="4" fill="${color}"><title>${faShort(s.date)} · ${fmt(s[key])}</title></rect>
        <text x="${x + (bw - gap) / 2}" y="${h - 6}" text-anchor="middle" fill="#5c6577" font-size="10">${label}</text></g>`;
    }).join('');
    return `<svg class="chart" viewBox="0 0 ${w} ${h}">${grid}${bars}</svg>`;
}

function bossReportRender() {
    const r = B.report, t = r.totals, c = B.org.color, maxP = Math.max(1, ...r.purposes.map(p => p.count));
    $('#bview').innerHTML = `
    <div class="kpis">
        ${[['Bank این بازه', t.bank, '#3fae6a'], ['تعداد واریز', t.count, '#3b6fe0'], ['Coin این بازه', t.coin, '#f0c470'], ['Bank امروز', t.today.bank, '#c9a35d']]
            .map(([l, v, col]) => `<div class="stat" style="--sc:${col}"><small>${l}</small><b data-n="${v}">0</b></div>`).join('')}
    </div>
    <div class="rgrid">
        <div class="rcol">
            <div class="card"><h4>روند واریز Bank <span class="range">${r.ranges.map(d => `<button data-d="${d}" class="${d === r.days ? 'on' : ''}">${d} روز</button>`).join('')}</span></h4>${barChart(r.series, 'bank', c, 190)}</div>
            <div class="card"><h4>روند واریز Coin <small>مجموع ${fmt(t.coin)}</small></h4>${barChart(r.series, 'coin', '#d69a3a', 110)}</div>
        </div>
        <div class="rcol">
            <div class="card"><h4>بابت پرداخت‌ها <small>${fmt(t.count)} واریز</small></h4>
                ${r.purposes.length ? r.purposes.map(p => `<div class="hb"><div class="t"><b>${esc(p.label)}</b><span>${p.count} · ${p.bank ? fmt(p.bank) + ' Bank' : ''}${p.bank && p.coin ? ' · ' : ''}${p.coin ? fmt(p.coin) + ' Coin' : ''}</span></div><div class="tr"><div class="fl" style="width:${Math.round(p.count / maxP * 100)}%"></div></div></div>`).join('') : '<div class="empty" style="padding:24px 0">داده‌ای نیست</div>'}</div>
            <div class="card" style="flex:1"><h4>بیشترین پرداخت‌کنندگان</h4>
                ${r.top.length ? r.top.map((p, i) => `<div class="top"><div class="rk r${i + 1}">${i + 1}</div><div class="nm"><b>${esc(p.name)}</b><small>${p.count} پرداخت</small></div><div class="vv">${fmt(p.bank)}${p.coin ? `<small>${fmt(p.coin)} Coin</small>` : ''}</div></div>`).join('') : '<div class="empty" style="padding:24px 0">داده‌ای نیست</div>'}</div>
        </div>
    </div>`;
    $('#bview').querySelectorAll('.kpis b').forEach(b => countUp(b, +b.dataset.n));
    $('#bview').querySelectorAll('.range button').forEach(b => b.onclick = () => bossReportLoad(+b.dataset.d));
}

/* ============================================================
   /paylog  (pardakht-haye man)
   ============================================================ */
const M = { page: 1, pages: 1, total: 0, rows: [] };
function openMine() {
    show('mine', false); M.page = 1;
    header('پرداخت‌های من', 'آخرین پرداخت‌های ثبت‌شده به ارگان‌ها');
    bd.innerHTML = view(`<div class="list-wrap"><div class="list" id="list"></div>
        <div class="pager"><button id="prev">‹ قبلی</button><span id="pinfo"></span><button id="next">بعدی ›</button></div>
        <div class="loading" id="loading"><div class="spin"></div></div></div>`);
    $('#prev').onclick = () => { if (M.page > 1) { M.page--; mineLoad(); } };
    $('#next').onclick = () => { if (M.page < M.pages) { M.page++; mineLoad(); } };
    mineLoad();
}
async function mineLoad() {
    $('#loading').classList.add('on');
    const res = await post('myList', { page: M.page });
    if (mode !== 'mine') return; $('#loading').classList.remove('on');
    if (!res || !res.ok) return toast((res && res.error) || 'خطایی رخ داد.', 'err');
    Object.assign(M, { rows: res.rows, page: res.page, pages: res.pages, total: res.total });
    $('#list').innerHTML = M.rows.length ? M.rows.map(r => rowHtml(r, false)).join('') : `<div class="empty"><div class="big">🧾</div>هنوز پرداختی انجام نداده‌اید.</div>`;
    $('#pinfo').textContent = `صفحه ${M.page} از ${M.pages}`;
    $('#prev').disabled = M.page <= 1; $('#next').disabled = M.page >= M.pages;
}

/* ============================================================
   Bridge
   ============================================================ */
window.addEventListener('message', e => {
    const { action, data, config } = e.data || {};
    if (config) Object.assign(CFG, config);
    if (action === 'openPay') openPay(data);
    else if (action === 'openBoss') openBoss(data);
    else if (action === 'openMine') openMine();
    else if (action === 'close') { hideDrawer(); clearInterval(timer); root.classList.remove('show'); mode = null; }
});
window.addEventListener('keyup', e => {
    if (!mode) return;
    if (e.key === 'Escape') { if (drawer.classList.contains('on')) hideDrawer(); else closeUI(); }
    else if (e.key === 'Enter' && mode === 'pay' && P.step === 3 && e.target.tagName !== 'TEXTAREA') { const b = $('#payBtn'); if (b && !b.disabled) submitPay(); }
});
