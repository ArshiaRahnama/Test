/* ===========================================================================
   Unique RP — Report System | ui/report/js/script.js
   arshiahub.ir

   نسخه بازنویسی‌شده و غیر-آبفاسکیت.
   نکته امنیتی مهم: نسخه قبلی متنِ خام کاربر رو مستقیم با insertAdjacentHTML
   داخل صفحه میریخت. یعنی هر بازیکنی میتونست با فرستادن <img onerror=...>
   داخل عنوان یا چت ریپورت، کد دلخواه رو توی NUI ادمین اجرا کنه.
   اینجا هر رشته‌ای که از سرور میاد از esc() رد میشه.
   =========================================================================== */

'use strict';

const RES = 'Unique_AdminPanel';   // اگه اسم پوشه ریسورس رو عوض کردی، اینجا هم عوض کن

/* ------------------------------------------------------------ helpers --- */

const $  = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));

function esc(v) {
  if (v === null || v === undefined) return '';
  return String(v)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

async function nui(name, data = {}) {
  try {
    const res = await fetch(`https://${RES}/${name}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data),
    });
    return await res.json();
  } catch (e) {
    return { r: false, msg: 'ارتباط با سرور برقرار نشد.' };
  }
}

function toast(msg, kind) {
  const host = $('#toastHost');
  const el = document.createElement('div');
  el.className = 'toast' + (kind ? ` toast--${kind}` : '');
  el.textContent = msg;
  host.appendChild(el);
  setTimeout(() => el.remove(), 3800);
}

function ago(seconds) {
  seconds = Number(seconds) || 0;
  if (seconds < 60)    return `${seconds} ثانیه`;
  if (seconds < 3600)  return `${Math.floor(seconds / 60)} دقیقه`;
  if (seconds < 86400) return `${Math.floor(seconds / 3600)} ساعت`;
  return `${Math.floor(seconds / 86400)} روز`;
}

function clock(ts) {
  if (!ts) return '';
  const d = new Date(Number(ts) * 1000);
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
}

/* UTF-8 aware length (فارسی) */
const len = (s) => Array.from(String(s || '')).length;

const SKEL = Array.from({length:6}).map(()=>
  '<div class="skel-row"><div class="skel"></div><div class="skel"></div></div>').join('');

/* -------------------------------------------------------------- state --- */

const S = {
  cfg: { categories: [], priorities: {}, limits: {}, server: 'Unique RP', site: 'arshiahub.ir' },
  userView:  'compose',
  adminView: 'queue',
  compose:   { category: null },
  tickets:   [],
  selected:  null,
  active:    null,   // ریپورتی که این ادمین قبول کرده
  mine:      null,   // ریپورت خود بازیکن
  filter:    'all',
  search:    '',
  rating:    { id: null, value: 0 },
  lastMsgCount: { user: 0, admin: 0 },
};

const catOf   = (k) => S.cfg.categories.find(c => c.key === k);
const catName = (k) => (catOf(k) || {}).label || k || '—';
const catIcon = (k) => (catOf(k) || {}).icon  || 'fa-circle-question';
// Lua tables with contiguous integer keys (1..n) come across as JSON ARRAYS,
// not objects - so Priorities[1] on the Lua side arrives at index 0 here.
// Handle both shapes so the labels/colours line up either way.
const priOf = (p) => {
  const P = S.cfg.priorities;
  const fallback = { label: '—', color: '#7c8698' };
  if (!P) return fallback;
  const hit = Array.isArray(P) ? P[Number(p) - 1] : P[p];
  return hit || (Array.isArray(P) ? P[0] : P[1]) || fallback;
};

/* ============================================================== panels === */

function showStage(id) {
  ['#userPanel', '#adminPanel', '#ratePanel'].forEach(sel => {
    const el = $(sel);
    const on = sel === id;
    el.classList.toggle('hidden', !on);
    el.setAttribute('aria-hidden', String(!on));
  });
}

function hideAll() {
  ['#userPanel', '#adminPanel', '#ratePanel'].forEach(sel => {
    $(sel).classList.add('hidden');
    $(sel).setAttribute('aria-hidden', 'true');
  });
}

function applyConfig(cfg) {
  if (!cfg) return;
  S.cfg = Object.assign(S.cfg, cfg);
  // editable macros (DB) replace the static canned list; falls back to it if the call fails
  nui('macros').then(r => { if (r && r.r && Array.isArray(r.data) && r.data.length) S.cfg.canned = r.data; });
  $('#brandNameUser').textContent  = S.cfg.server;
  $('#brandNameAdmin').textContent = S.cfg.server;
  $$('#siteLinkUser span, #siteLinkAdmin span').forEach(el => { el.textContent = S.cfg.site; });
}

/* ========================================================= USER PANEL === */

function renderUser() {
  const body = $('#userBody');
  $$('#userPanel .tab').forEach(t => t.classList.toggle('is-on', t.dataset.view === S.userView));

  if (S.userView === 'compose') return renderCompose(body);
  if (S.userView === 'mine')    return renderMine(body);
  if (S.userView === 'board')   return renderBoard(body);
}

function renderCompose(body) {
  const L = S.cfg.limits || {};
  body.className = 'body scroller';
  body.innerHTML = `
    <form class="compose" id="composeForm" novalidate>
      <p class="compose__lede">
        هرچی دقیق‌تر بنویسی سریع‌تر رسیدگی می‌شه. زمان، مکان و آیدی افراد درگیر رو بنویس.
        تا بسته شدن این ریپورت نمی‌تونی ریپورت جدید بدی.
      </p>

      <div class="field">
        <label class="field__label" for="cTitle">عنوان</label>
        <input class="input" id="cTitle" maxlength="${esc(L.titleMax || 64)}"
               placeholder="مثلاً: بازیکن بدون دلیل به من شلیک کرد" autocomplete="off">
        <div class="counter" id="cTitleCount">0 / ${esc(L.titleMax || 64)}</div>
      </div>

      <div class="field">
        <span class="field__label">موضوع</span>
        <div class="cats" id="cCats">
          ${S.cfg.categories.map(c => `
            <button type="button" class="cat" data-key="${esc(c.key)}">
              <i class="fa-solid ${esc(c.icon)}"></i><span>${esc(c.label)}</span>
            </button>`).join('')}
        </div>
      </div>

      <div class="field">
        <label class="field__label" for="cTarget">آیدیِ بازیکنِ گزارش‌شده <b>(اختیاری)</b></label>
        <input class="input" id="cTarget" type="number" min="1" inputmode="numeric"
               placeholder="اگه این ریپورت درباره‌ی یک بازیکنِ خاصه، آیدیش رو بنویس" autocomplete="off">
      </div>

      <div class="field">
        <label class="field__label" for="cInfo">توضیحات</label>
        <textarea class="textarea" id="cInfo" maxlength="${esc(L.infoMax || 1000)}"
                  placeholder="چه اتفاقی افتاد؟ کِی و کجا؟ آیدی طرف مقابل چند بود؟"></textarea>
        <div class="counter" id="cInfoCount">0 / ${esc(L.infoMax || 1000)}</div>
      </div>

      <button class="btn btn--go" id="cSend" type="submit">
        <i class="fa-solid fa-paper-plane"></i> ارسال ریپورت
      </button>
    </form>`;

  // انتخاب موضوع
  $$('#cCats .cat').forEach(btn => {
    btn.classList.toggle('is-on', btn.dataset.key === S.compose.category);
    btn.addEventListener('click', () => {
      S.compose.category = btn.dataset.key;
      $$('#cCats .cat').forEach(b => b.classList.toggle('is-on', b === btn));
    });
  });

  // شمارنده کاراکتر
  const bind = (inputId, countId, min, max) => {
    const inp = $(`#${inputId}`), out = $(`#${countId}`);
    const upd = () => {
      const n = len(inp.value);
      out.textContent = `${n} / ${max}`;
      const bad = n > 0 && n < min;
      out.classList.toggle('is-bad', bad || n > max);
      inp.classList.toggle('is-bad', n > max);
    };
    inp.addEventListener('input', upd);
    upd();
  };
  bind('cTitle', 'cTitleCount', L.titleMin || 5,  L.titleMax || 64);
  bind('cInfo',  'cInfoCount',  L.infoMin  || 15, L.infoMax  || 1000);

  $('#composeForm').addEventListener('submit', submitReport);
}

async function submitReport(ev) {
  ev.preventDefault();
  const L = S.cfg.limits || {};
  const title = $('#cTitle').value.trim();
  const info  = $('#cInfo').value.trim();
  const targetRaw = $('#cTarget').value.trim();
  const targetId = targetRaw ? Number(targetRaw) : undefined;

  const fail = (el, msg) => {
    el.classList.add('is-bad');
    setTimeout(() => el.classList.remove('is-bad'), 1200);
    toast(msg, 'bad');
  };

  if (len(title) < (L.titleMin || 5))  return fail($('#cTitle'), `عنوان باید حداقل ${L.titleMin || 5} کاراکتر باشه.`);
  if (!S.compose.category)             return toast('یک موضوع انتخاب کن.', 'bad');
  if (len(info) < (L.infoMin || 15))   return fail($('#cInfo'), `توضیحات باید حداقل ${L.infoMin || 15} کاراکتر باشه.`);
  if (targetRaw && (!Number.isInteger(targetId) || targetId < 1)) return fail($('#cTarget'), 'آیدی باید یک عدد صحیح باشه.');

  const btn = $('#cSend');
  btn.disabled = true;
  btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin"></i> در حال ارسال';

  const res = await nui('create', { title, info, category: S.compose.category, targetId });

  btn.disabled = false;
  btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> ارسال ریپورت';

  if (res && res.r) {
    toast(res.msg || 'ریپورت ثبت شد.', 'ok');
    S.compose.category = null;
    S.userView = 'mine';
    renderUser();
  } else {
    toast((res && res.msg) || 'ثبت ریپورت انجام نشد.', 'bad');
  }
}

async function renderMine(body) {
  body.className = 'body';
  body.innerHTML = `<div class="empty"><i class="fa-solid fa-circle-notch fa-spin"></i></div>`;

  const res = await nui('getMine');
  S.mine = res;
  $('#userUnread').hidden = true;

  if (!res || !res.r) {
    const pending = res && res.msg === 'pending';
    body.innerHTML = `
      <div class="empty">
        <i class="fa-solid ${pending ? 'fa-hourglass-half' : 'fa-inbox'}"></i>
        <h3>${pending ? 'ریپورتت در صف بررسیه' : 'ریپورت بازی نداری'}</h3>
        <p>${pending
            ? `ریپورت شماره ${esc(res.id)} ثبت شده و ${esc(ago(res.waited))} منتظره. به‌محض اینکه ادمینی قبولش کنه اینجا باز می‌شه.`
            : 'از تب «ریپورت جدید» می‌تونی یک ریپورت باز کنی.'}</p>
      </div>`;
    return;
  }

  const d = res.data;
  body.innerHTML = `
    <div class="pane" style="flex:1">
      <div class="pane__head">
        <img class="avatar" src="${esc(d.AdminAvatar || './img/self.png')}" alt="">
        <div class="pane__who">
          <div class="pane__name">${esc(d.AdminName)}</div>
          <div class="pane__sub">
            <span>${esc(d.AdminRank)}</span>
            <span>${esc(d.AdminXP)} XP</span>
            <span><i class="dot ${d.AdminOnline ? 'dot--on' : 'dot--off'}"></i>
              ${d.AdminOnline ? 'آنلاین' : 'آفلاین'}</span>
          </div>
        </div>
        <div class="pane__acts">
          <span class="pill">ریپورت ${esc(d.ID)}</span>
          <span class="pill">${esc(catName(d.category))}</span>
        </div>
      </div>
      <div class="thread scroller" id="userThread"></div>
      <div class="composer">
        <input class="input" id="userMsg" placeholder="پیامت رو بنویس…"
               maxlength="${esc((S.cfg.limits || {}).chatMax || 500)}" autocomplete="off">
        <button class="sendbtn" id="userSend"><i class="fa-solid fa-paper-plane"></i></button>
      </div>
    </div>`;

  paintThread('#userThread', d.chat, 'user');
  S.lastMsgCount.user = (d.chat || []).length;

  const doSend = async () => {
    const inp = $('#userMsg');
    const text = inp.value.trim();
    if (!text) return;
    inp.value = '';
    const r = await nui('chat', { id: d.ID, text });
    if (r && r.r) { renderMine(body); }
    else { toast((r && r.msg) || 'پیام ارسال نشد.', 'bad'); inp.value = text; }
  };
  $('#userSend').addEventListener('click', doSend);
  $('#userMsg').addEventListener('keydown', e => { if (e.key === 'Enter') doSend(); });
  $('#userMsg').focus();
}

/* ------------------------------------------------------------- thread --- */

function paintThread(sel, chat, mySide) {
  const box = $(sel);
  if (!box) return;
  const list = Array.isArray(chat) ? chat : [];

  if (!list.length) {
    box.innerHTML = `<div class="empty"><p>هنوز پیامی رد و بدل نشده.</p></div>`;
    return;
  }

  box.innerHTML = list.map(m => {
    if (m.user === 'system') {
      return `<div class="msg msg--sys"><div class="msg__body">${esc(m.text)}</div></div>`;
    }
    const mine = m.user === mySide;
    const who  = m.name ? esc(m.name) : (m.user === 'admin' ? 'ادمین' : 'بازیکن');
    return `
      <div class="msg ${mine ? 'msg--me' : 'msg--them'}">
        <div class="msg__who">${who}${m.at ? ' · ' + esc(clock(m.at)) : ''}</div>
        <div class="msg__body">${esc(m.text)}</div>
      </div>`;
  }).join('');

  box.scrollTop = box.scrollHeight;
}

/* ---------------------------------------------------------- leaderboard --- */

async function renderBoard(body) {
  body.className = 'body scroller';
  body.innerHTML = `<div class="empty"><i class="fa-solid fa-circle-notch fa-spin"></i></div>`;

  const res = await nui('topAdmins');
  if (!res || !res.r || !res.data || !res.data.length) {
    body.innerHTML = `<div class="empty"><i class="fa-solid fa-ranking-star"></i>
      <h3>هنوز آماری ثبت نشده</h3><p>بعد از رسیدگی به چند ریپورت، جدول اینجا پر می‌شه.</p></div>`;
    return;
  }

  body.innerHTML = `
    <div class="board">
      <div class="board__row board__row--head">
        <span>#</span><span>ادمین</span><span>رسیدگی</span><span>میانگین امتیاز</span><span>XP</span>
      </div>
      ${res.data.map((a, i) => `
        <div class="board__row">
          <span class="board__pos ${i === 0 ? 'board__pos--1' : ''}">${i + 1}</span>
          <span class="board__name">
            <i class="dot ${a.online ? 'dot--on' : 'dot--off'}"></i>
            <span>${esc(a.name || '—')}</span>
            <span class="board__rank">${esc(a.rank)}</span>
          </span>
          <span class="board__num">${esc(a.handled)}</span>
          <span class="board__num">${a.avg_rating ? esc(Number(a.avg_rating).toFixed(1)) + ' ★' : '—'}</span>
          <span class="board__num">${esc(a.xp)}</span>
        </div>`).join('')}
    </div>`;
}

/* ======================================================== ADMIN PANEL === */

function renderAdmin() {
  const body = $('#adminBody');
  $$('#adminPanel .tab').forEach(t => t.classList.toggle('is-on', t.dataset.view === S.adminView));

  if (S.adminView === 'queue')   return renderQueue(body, false);
  if (S.adminView === 'archive') return renderQueue(body, true);
  if (S.adminView === 'active')  return renderActive(body);
  if (S.adminView === 'stats')   return renderStats(body);
}

async function renderQueue(body, archived) {
  body.className = 'body';
  body.innerHTML = `<div class="split"><div class="queue">${SKEL}</div><div class="pane"></div></div>`;

  const res = await nui('getAll', { status: archived ? 'archive' : 'live' });
  S.tickets = (res && res.r && res.data) ? res.data : [];

  const waiting = S.tickets.filter(t => t.status === 'pending').length;
  $('#queueCount').textContent = waiting;

  body.innerHTML = `
    <div class="split">
      <div class="queue">
        <div class="queue__tools">
          <input class="search" id="qSearch" placeholder="جستجو در عنوان، بازیکن یا شماره…"
                 value="${esc(S.search)}" autocomplete="off">
          <div class="filters">
            <button class="filt ${S.filter === 'all'     ? 'is-on' : ''}" data-f="all">همه</button>
            <button class="filt ${S.filter === 'pending' ? 'is-on' : ''}" data-f="pending">در انتظار</button>
            <button class="filt ${S.filter === 'accept'  ? 'is-on' : ''}" data-f="accept">در حال بررسی</button>
          </div>
        </div>
        <div class="list scroller" id="qList"></div>
      </div>
      <div class="pane" id="qDetail"></div>
    </div>`;

  $('#qSearch').addEventListener('input', e => { S.search = e.target.value; paintQueue(); });
  $$('.filt').forEach(b => b.addEventListener('click', () => {
    S.filter = b.dataset.f;
    $$('.filt').forEach(x => x.classList.toggle('is-on', x === b));
    paintQueue();
  }));

  paintQueue();
  paintDetail();
}

function visibleTickets() {
  const q = S.search.trim().toLowerCase();
  return S.tickets.filter(t => {
    if (S.filter !== 'all' && t.status !== S.filter) return false;
    if (!q) return true;
    return String(t.ID).includes(q)
        || String(t.title || '').toLowerCase().includes(q)
        || String(t.Name  || '').toLowerCase().includes(q);
  });
}

function paintQueue() {
  const list = $('#qList');
  if (!list) return;
  const rows = visibleTickets();

  if (!rows.length) {
    list.innerHTML = `<div class="empty"><i class="fa-solid fa-inbox"></i>
      <h3>چیزی اینجا نیست</h3><p>با این فیلتر ریپورتی پیدا نشد.</p></div>`;
    return;
  }

  list.innerHTML = rows.map(t => {
    const pr = priOf(t.priority);
    // "heat": older unclaimed tickets warm up, so urgency reads at a glance
    // without adding another badge to the row.
    const mins = (Number(t.age) || 0) / 60;
    const heat = t.status !== 'pending' ? 0 : mins > 20 ? 3 : mins > 10 ? 2 : mins > 4 ? 1 : 0;
    const initial = esc(String(t.Name || '?').trim().charAt(0).toUpperCase() || '?');
    const statusPill =
      t.status === 'pending' ? '<span class="pill pill--wait">در انتظار</span>' :
      t.status === 'accept'  ? '<span class="pill pill--live">در حال بررسی</span>' :
                               '<span class="pill pill--done">بسته</span>';
    return `
      <div class="tk tk__grid ${t.status === 'pending' ? 'tk--wait' : ''} ${S.selected === t.ID ? 'is-sel' : ''}"
           data-id="${esc(t.ID)}" data-heat="${heat}">
        <span class="tk__spine" style="background:${esc(pr.color)};color:${esc(pr.color)}"></span>
        <span class="tk__ava">${initial}</span>
        <div class="tk__main">
          <div class="tk__top">
            <span class="tk__id">#${esc(t.ID)}</span>
            <span class="tk__title">${esc(t.title)}</span>
          </div>
          <div class="tk__meta">
            <span><i class="fa-solid ${esc(catIcon(t.category))}"></i> ${esc(catName(t.category))}</span>
            <span><i class="dot ${t.online ? 'dot--on' : 'dot--off'}"></i> ${esc(t.Name)}</span>
            <span class="tk__age"><i class="fa-regular fa-clock"></i> ${esc(ago(t.age))}</span>
            ${t.msgCount ? `<span><i class="fa-regular fa-comment"></i> ${esc(t.msgCount)}</span>` : ''}
            ${t.hasNote ? `<span title="یادداشتِ شیفت"><i class="fa-solid fa-note-sticky"></i></span>` : ''}
            ${t.targetFlagged ? `<span class="flag-badge" title="هدفِ این ریپورت الان یک فلگِ فعالِ سیستمی داره">
              <i class="fa-solid fa-triangle-exclamation"></i> فلگ‌دار</span>` : ''}
          </div>
        </div>
        <div class="tk__side">${statusPill}</div>
      </div>`;
  }).join('');

  paintPressure();

  $$('.tk', list).forEach(row => row.addEventListener('click', () => {
    S.selected = Number(row.dataset.id);
    paintQueue();
    paintDetail();
  }));
}

// Thin bar under the header showing how much of the queue is unclaimed vs
// being worked. Gives the whole panel a live "how busy are we" read.
function paintPressure() {
  const bar = $('#pressureBar');
  if (!bar) return;
  const total = S.tickets.length || 1;
  const wait  = S.tickets.filter(t => t.status === 'pending').length;
  const live  = S.tickets.filter(t => t.status === 'accept').length;
  bar.innerHTML =
    `<span class="pressure__seg pressure__seg--wait" style="width:${(wait / total) * 100}%"></span>` +
    `<span class="pressure__seg pressure__seg--live" style="width:${(live / total) * 100}%"></span>`;
}

function paintDetail() {
  const pane = $('#qDetail');
  if (!pane) return;

  const t = S.tickets.find(x => x.ID === S.selected);
  if (!t) {
    pane.innerHTML = `<div class="empty"><i class="fa-solid fa-hand-pointer"></i>
      <h3>یک ریپورت انتخاب کن</h3><p>جزئیات و دکمه‌های اقدام اینجا نشون داده می‌شن.</p></div>`;
    return;
  }

  const pr = priOf(t.priority);
  const canDelete = true;   // سرور خودش دسترسی رو چک میکنه؛ اینجا فقط UI

  pane.innerHTML = `
    <div class="pane__head">
      <div class="pane__who">
        <div class="pane__name">#${esc(t.ID)} — ${esc(t.title)}</div>
        <div class="pane__sub">
          <span>${esc(catName(t.category))}</span>
          <span style="color:${esc(pr.color)}">اولویت ${esc(pr.label)}</span>
          <span>${esc(ago(t.age))} پیش</span>
          ${t.targetFlagged ? `<span class="flag-badge"><i class="fa-solid fa-triangle-exclamation"></i> هدف فلگ‌دار</span>` : ''}
        </div>
      </div>
      <div class="pane__acts">
        ${t.status === 'pending'
          ? `<button class="btn btn--jade btn--sm" data-do="accept"><i class="fa-solid fa-check"></i> قبول</button>`
          : ''}
        ${t.status === 'accept'
          ? `<button class="btn btn--ghost btn--sm" data-do="open"><i class="fa-solid fa-comments"></i> باز کردن چت</button>`
          : ''}
        <button class="btn btn--ghost btn--sm" data-do="archive"><i class="fa-solid fa-box-archive"></i> بایگانی</button>
        ${canDelete ? `<button class="btn btn--rust btn--sm" data-do="delete"><i class="fa-solid fa-trash"></i> حذف</button>` : ''}
      </div>
    </div>

    <div class="thread scroller">
      <div class="msg msg--them" style="max-width:100%">
        <div class="msg__who">${esc(t.Name)} ${t.pid ? `· ID ${esc(t.pid)}` : ''}</div>
        <div class="msg__body">${esc(t.sub)}</div>
      </div>
      ${t.AdminName && t.status !== 'pending'
        ? `<div class="msg msg--sys"><div class="msg__body">رسیدگی توسط ${esc(t.AdminName)}</div></div>`
        : ''}
      ${t.admin_note
        ? `<div class="msg msg--sys"><div class="msg__body"><i class="fa-solid fa-note-sticky"></i> یادداشت: ${esc(t.admin_note)}</div></div>`
        : ''}
      ${t.rating > 0
        ? `<div class="msg msg--sys"><div class="msg__body">امتیاز بازیکن: ${esc(t.rating)} از ۵</div></div>`
        : ''}
    </div>`;

  $$('[data-do]', pane).forEach(btn => btn.addEventListener('click', () => detailAction(btn.dataset.do, t)));
}

async function detailAction(what, t) {
  if (what === 'open') { S.adminView = 'active'; return renderAdmin(); }

  if (what === 'delete' && !confirm(`ریپورت #${t.ID} برای همیشه حذف بشه؟`)) return;

  const res = await nui(what, { id: t.ID });
  if (res && res.r) {
    toast(res.msg || 'انجام شد.', 'ok');
    if (what === 'accept') { S.adminView = 'active'; return renderAdmin(); }
    S.selected = null;
    renderAdmin();
  } else {
    toast((res && res.msg) || 'انجام نشد.', 'bad');
  }
}

/* -------------------------------------------------------- active ticket --- */

async function renderActive(body) {
  body.className = 'body';
  body.innerHTML = `<div class="empty"><i class="fa-solid fa-circle-notch fa-spin"></i></div>`;

  const res = await nui('getActive');
  S.active = res;
  $('#adminUnread').hidden = true;

  if (!res || !res.r) {
    body.innerHTML = `<div class="empty"><i class="fa-solid fa-headset"></i>
      <h3>ریپورتی در دست نداری</h3>
      <p>از تب «صف» یک ریپورت رو قبول کن تا اینجا باز بشه.</p></div>`;
    return;
  }

  const d  = res.data;
  const p  = d.perms || {};
  const pr = priOf(d.priority);
  const t  = d.target || null;

  const act = (key, icon, label, on) => on
    ? `<button class="btn btn--ghost btn--sm" data-act="${key}"><i class="fa-solid ${icon}"></i> ${label}</button>`
    : '';

  const riskLevelLabel = { low: 'کم', med: 'متوسط', high: 'بالا' };

  body.innerHTML = `
    <div class="pane" style="flex:1">
      <div class="pane__head">
        <img class="avatar" src="${esc(d.avatar || './img/self.png')}" alt="">
        <div class="pane__who">
          <div class="pane__name">${esc(d.name)}</div>
          <div class="pane__sub">
            <span>#${esc(d.ID)}</span>
            <span>${esc(catName(d.category))}</span>
            <span style="color:${esc(pr.color)}">${esc(pr.label)}</span>
            <span><i class="dot ${d.online ? 'dot--on' : 'dot--off'}"></i>
              ${d.online ? 'ID ' + esc(d.pid) : 'آفلاین'}</span>
          </div>
        </div>
        <div class="pane__acts">
          ${act('teleport', 'fa-location-arrow', 'رفتن پیشش', p.teleport && d.online)}
          ${act('bring',    'fa-hand',           'آوردنش',    p.bring    && d.online)}
          ${act('return',   'fa-rotate-left',    'برگشت',     true)}
          ${act('spect',    'fa-eye',            'اسپکت',     p.spect    && d.online)}
          ${act('revive',   'fa-heart-pulse',    'ریوایو',    p.revive   && d.online)}
          ${act('freeze',   'fa-snowflake',      'فریز',      p.freeze   && d.online)}
          ${act('givecar',  'fa-car',            'ماشین',     p.givecar)}
          ${t ? `<button class="btn btn--ghost btn--sm" id="voiceBtn"><i class="fa-solid fa-microphone-lines"></i> بررسی صدا</button>` : ''}
          ${t && p.ban ? `<button class="btn btn--rust btn--sm" id="banBtn" ${!t.online ? 'disabled title="هدف آنلاین نیست"' : ''}>
            <i class="fa-solid fa-gavel"></i> بستن با بن</button>` : ''}
          <button class="btn btn--jade btn--sm" id="closeActive">
            <i class="fa-solid fa-flag-checkered"></i> بستن ریپورت
          </button>
        </div>
      </div>

      ${t ? `
      <div class="target-intel">
        <div class="target-intel__row">
          <span class="target-intel__name">
            <i class="fa-solid fa-crosshairs"></i> هدف: ${esc(t.name)}
            <i class="dot ${t.online ? 'dot--on' : 'dot--off'}"></i>
          </span>
          ${t.risk ? `<span class="risk-badge risk-badge--${esc(t.risk.level)}">
            ریسک ${esc(t.risk.score)} · ${esc(riskLevelLabel[t.risk.level] || t.risk.level)}</span>` : ''}
          ${t.recentReports > 0 ? `<span class="pill pill--wait">
            <i class="fa-solid fa-clock-rotate-left"></i> ${esc(t.recentReports)} ریپورتِ دیگر (۷ روز اخیر)</span>` : ''}
        </div>
        ${t.risk && t.risk.reasons && t.risk.reasons.length ? `
          <details class="target-intel__reasons">
            <summary>چرا این امتیاز؟</summary>
            <ul>${t.risk.reasons.map(r => `<li>${esc(r)}</li>`).join('')}</ul>
          </details>` : ''}
      </div>
      <div class="inline-panel hidden" id="voicePanel"></div>
      <div class="inline-panel hidden" id="banPanel"></div>
      ` : ''}

      <div class="note-strip">
        <button class="note-strip__toggle" id="noteToggle">
          <i class="fa-solid fa-note-sticky"></i> یادداشتِ شیفت <span class="note-strip__hint">(فقط ادمین‌ها می‌بینن)</span>
          <i class="fa-solid fa-chevron-down note-strip__chev"></i>
        </button>
        <div class="note-strip__body hidden" id="noteBody">
          <textarea class="textarea" id="noteText" rows="2" placeholder="مثلاً: منتظرم کلیپ بفرسته، هنوز جواب نداده…">${esc(d.adminNote || '')}</textarea>
          <button class="btn btn--ghost btn--sm" id="noteSave"><i class="fa-solid fa-check"></i> ذخیره یادداشت</button>
        </div>
      </div>

      <div class="thread scroller" id="adminThread"></div>

      <div class="canned">
        ${(S.cfg.canned || []).map(c => `<button class="canned__chip" data-canned="${esc(c.key)}" title="${(c.close == 1 || c.close === true) ? 'ارسال و بستن ریپورت' : 'ارسال پاسخ'}">${esc(c.label)}${(c.close == 1 || c.close === true) ? ' ✓' : ''}</button>`).join('')}
      </div>

      <div class="composer">
        <input class="input" id="adminMsg" placeholder="پاسخت رو بنویس…"
               maxlength="${esc((S.cfg.limits || {}).chatMax || 500)}" autocomplete="off">
        <button class="sendbtn" id="adminSend"><i class="fa-solid fa-paper-plane"></i></button>
      </div>
    </div>`;

  paintThread('#adminThread', d.chat, 'admin');
  S.lastMsgCount.admin = (d.chat || []).length;

  $$('[data-act]', body).forEach(b => b.addEventListener('click', () => {
    nui('action', { kind: b.dataset.act, id: d.pid });
  }));

  $('#closeActive').addEventListener('click', async () => {
    const r = await nui('close', { id: d.ID });
    if (r && r.r) { toast('ریپورت بسته شد.', 'ok'); S.adminView = 'queue'; renderAdmin(); }
    else toast((r && r.msg) || 'بسته نشد.', 'bad');
  });

  // ------------------------------------------------------- یادداشتِ شیفت ---
  $('#noteToggle')?.addEventListener('click', () => {
    $('#noteBody').classList.toggle('hidden');
    $('#noteToggle').classList.toggle('is-open');
  });
  $('#noteSave')?.addEventListener('click', async () => {
    const note = $('#noteText').value;
    const r = await nui('setNote', { id: d.ID, note });
    toast(r && r.r ? 'یادداشت ذخیره شد.' : (r && r.msg) || 'ذخیره نشد.', r && r.r ? 'ok' : 'bad');
  });

  // ------------------------------------------------------------ بررسیِ صدا ---
  $('#voiceBtn')?.addEventListener('click', async () => {
    const panel = $('#voicePanel');
    const opening = panel.classList.contains('hidden');
    $('#banPanel')?.classList.add('hidden');
    if (!opening) { panel.classList.add('hidden'); return; }

    panel.classList.remove('hidden');
    panel.innerHTML = `<div class="inline-panel__loading"><i class="fa-solid fa-circle-notch fa-spin"></i> در حال بررسی…</div>`;
    const r = await nui('voiceCheck', { pid: t.pid });
    if (!r || !r.r) { panel.innerHTML = `<p class="inline-panel__empty">بررسی انجام نشد.</p>`; return; }
    if (!r.data || !r.data.length) {
      panel.innerHTML = `<p class="inline-panel__empty">کسی تو رنجِ صدا (${esc(r.range)} متر) نبود.</p>`;
      return;
    }
    panel.innerHTML = `
      <div class="inline-panel__title">تو رنجِ صدا (${esc(r.range)} متر):</div>
      ${r.data.map(n => `
        <div class="voice-row">
          <span>${esc(n.name)} <span class="voice-row__id">ID ${esc(n.id)}</span></span>
          <span class="voice-row__dist">${esc(n.distance)} متر</span>
        </div>`).join('')}`;
  });

  // -------------------------------------------------------- بستن با بن ---
  $('#banBtn')?.addEventListener('click', async () => {
    const panel = $('#banPanel');
    const opening = panel.classList.contains('hidden');
    $('#voicePanel')?.classList.add('hidden');
    if (!opening) { panel.classList.add('hidden'); return; }

    panel.classList.remove('hidden');
    panel.innerHTML = `<div class="inline-panel__loading"><i class="fa-solid fa-circle-notch fa-spin"></i> در حال بارگذاری پریست‌ها…</div>`;
    const r = await nui('banPresets');
    const presets = (r && r.data) || [];
    if (!presets.length) { panel.innerHTML = `<p class="inline-panel__empty">پریستِ بنی تعریف نشده.</p>`; return; }

    panel.innerHTML = `
      <div class="inline-panel__title">یک پریست انتخاب کن - ریپورت هم همزمان بسته می‌شه:</div>
      ${presets.map(ps => `
        <button class="ban-preset" data-preset="${esc(ps.id)}">
          <span class="ban-preset__label">${esc(ps.label)}</span>
          <span class="ban-preset__meta">${ps.minutes === 0 ? 'دائم' : ps.minutes + ' دقیقه'}</span>
        </button>`).join('')}`;

    $$('.ban-preset', panel).forEach(b => b.addEventListener('click', async () => {
      if (!confirm(`مطمئنی؟ بازیکن بن می‌شه و ریپورت بسته می‌شه.`)) return;
      b.disabled = true;
      const res2 = await nui('banClose', { id: d.ID, presetId: b.dataset.preset });
      if (res2 && res2.r) {
        toast(res2.msg || 'انجام شد.', 'ok');
        S.adminView = 'queue';
        renderAdmin();
      } else {
        toast((res2 && res2.msg) || 'بن انجام نشد.', 'bad');
        b.disabled = false;
      }
    }));
  });

  // ------------------------------------------------------- پاسخِ آماده ---
  $$('[data-canned]', body).forEach(chip => chip.addEventListener('click', async () => {
    const preset = (S.cfg.canned || []).find(c => c.key === chip.dataset.canned);
    if (!preset) return;
    chip.disabled = true;
    // the server expands {admin} {player} {id} {server} and, for macros marked ✓, closes the report
    const r = await nui('macro', { id: d.ID, key: preset.key });
    chip.disabled = false;
    if (r && r.r && r.closed) { toast('پاسخ ارسال و ریپورت بسته شد.', 'ok'); S.adminView = 'queue'; renderAdmin(); }
    else if (r && r.r) renderActive(body);
    else toast((r && r.msg) || 'ارسال نشد.', 'bad');
  }));

  const doSend = async () => {
    const inp = $('#adminMsg');
    const text = inp.value.trim();
    if (!text) return;
    inp.value = '';
    const r = await nui('chat', { id: d.ID, text });
    if (r && r.r) renderActive(body);
    else { toast((r && r.msg) || 'ارسال نشد.', 'bad'); inp.value = text; }
  };
  $('#adminSend').addEventListener('click', doSend);
  $('#adminMsg').addEventListener('keydown', e => { if (e.key === 'Enter') doSend(); });
  $('#adminMsg').focus();
}

/* ---------------------------------------------------------------- stats --- */

async function renderStats(body) {
  body.className = 'body scroller';
  body.innerHTML = `<div class="empty"><i class="fa-solid fa-circle-notch fa-spin"></i></div>`;

  const [st, top] = await Promise.all([nui('stats'), nui('topAdmins')]);
  const d = (st && st.r && st.data) ? st.data : {};

  const card = (cls, n, l) => `<div class="stat ${cls}"><span class="stat__n">${esc(n)}</span><span class="stat__l">${esc(l)}</span></div>`;

  body.innerHTML = `
    <div class="stats">
      <div class="stats__grid">
        ${card('stat--wait', d.pending || 0, 'در انتظار')}
        ${card('stat--live', d.active  || 0, 'در حال بررسی')}
        ${card('stat--done', d.closed  || 0, 'بسته‌شده')}
        ${card('', d.total || 0, 'کل ریپورت‌ها')}
        ${card('', d.avg_rating ? Number(d.avg_rating).toFixed(1) + ' ★' : '—', 'میانگین رضایت')}
        ${card('', d.avg_response ? ago(Math.round(d.avg_response)) : '—', 'میانگین زمان پاسخ')}
      </div>
      <div id="monthlyBoard"></div>
      <div id="statsBoard"></div>
    </div>`;

  const monthly = (top && top.monthly) || [];
  if (monthly.length) {
    $('#monthlyBoard').innerHTML = `
      <div class="monthly">
        <div class="monthly__title"><i class="fa-solid fa-trophy"></i> برترین‌های این ماه</div>
        <div class="monthly__grid">
          ${monthly.map((m, i) => `
            <div class="monthly__card monthly__card--${i}">
              <div class="monthly__badge">${['🥇', '🥈', '🥉'][i] || ''}</div>
              <div class="monthly__name">${esc(m.name || '—')}</div>
              <div class="monthly__title2">${esc(m.title || '')}</div>
              <div class="monthly__stats">
                <span>${esc(m.handled)} ریپورت</span>
                ${m.avg_rating ? `<span>${esc(Number(m.avg_rating).toFixed(1))} ★</span>` : ''}
              </div>
            </div>`).join('')}
        </div>
      </div>`;
  }

  const boardHost = $('#statsBoard');
  if (top && top.r && top.data && top.data.length) {
    boardHost.innerHTML = `
      <div class="board" style="padding:0">
        <div class="board__row board__row--head">
          <span>#</span><span>ادمین</span><span>رسیدگی</span><span>امتیاز</span><span>میانگین پاسخ</span>
        </div>
        ${top.data.map((a, i) => `
          <div class="board__row">
            <span class="board__pos ${i === 0 ? 'board__pos--1' : ''}">${i + 1}</span>
            <span class="board__name">
              <i class="dot ${a.online ? 'dot--on' : 'dot--off'}"></i>
              <span>${esc(a.name || '—')}</span>
              <span class="board__rank">${esc(a.rank)}</span>
            </span>
            <span class="board__num">${esc(a.handled)}</span>
            <span class="board__num">${a.avg_rating ? esc(Number(a.avg_rating).toFixed(1)) + ' ★' : '—'}</span>
            <span class="board__num">${a.avg_response ? esc(ago(Math.round(a.avg_response))) : '—'}</span>
          </div>`).join('')}
      </div>`;
  }
}

/* ========================================================= RATING CARD === */

function openRating(id, adminName) {
  S.rating = { id, value: 0 };
  $('#rateAdminName').textContent = adminName ? `رسیدگی توسط ${adminName}` : '';
  $('#rateHint').textContent = 'یک امتیاز انتخاب کن';
  $('#rateSend').disabled = true;
  $$('#rateStars .star').forEach(s => s.classList.remove('is-lit'));
  showStage('#ratePanel');
}

const RATE_WORDS = ['', 'اصلاً راضی نبودم', 'می‌شد بهتر باشه', 'قابل قبول بود', 'خوب بود', 'عالی بود'];

$$('#rateStars .star').forEach(star => {
  star.addEventListener('click', () => {
    const v = Number(star.dataset.v);
    S.rating.value = v;
    $$('#rateStars .star').forEach(s => s.classList.toggle('is-lit', Number(s.dataset.v) <= v));
    $('#rateHint').textContent = RATE_WORDS[v];
    $('#rateSend').disabled = false;
  });
});

$('#rateSend').addEventListener('click', async () => {
  if (!S.rating.value) return;
  await nui('rate', { id: S.rating.id, rating: S.rating.value });
  hideAll();
  toast('ممنون بابت امتیازت.', 'ok');
});

$('#rateSkip').addEventListener('click', () => { nui('exit'); hideAll(); });

/* ============================================================== wiring === */

$$('#userPanel .tab').forEach(t => t.addEventListener('click', () => {
  S.userView = t.dataset.view; renderUser();
}));
$$('#adminPanel .tab').forEach(t => t.addEventListener('click', () => {
  S.adminView = t.dataset.view; renderAdmin();
}));

$('#userClose').addEventListener('click',  () => { nui('exit'); hideAll(); });
$('#adminClose').addEventListener('click', () => { nui('exit'); hideAll(); });

$$('#siteLinkUser, #siteLinkAdmin').forEach(b => b.addEventListener('click', () => {
  const text = S.cfg.site;
  navigator.clipboard?.writeText(text).catch(() => {});
  nui('copy', { text });
  toast(`آدرس سایت کپی شد: ${text}`, 'ok');
}));

document.addEventListener('keydown', e => {
  if (e.key !== 'Escape') return;
  const anyOpen = ['#userPanel', '#adminPanel', '#ratePanel']
    .some(s => !$(s).classList.contains('hidden'));
  if (!anyOpen) return;
  nui('exit');
  hideAll();
});

/* --------------------------------------------------- messages from Lua --- */

window.addEventListener('message', ev => {
  const d = ev.data || {};
  if (!d._uniqueReport) return;   // پیام مال پنل‌های دیگه‌ست، رد شو

  switch (d.ureport) {
    case 'showUserPanel':
      applyConfig(d.config);
      showStage('#userPanel');
      renderUser();
      break;

    case 'showAdminPanel':
      applyConfig(d.config);
      showStage('#adminPanel');
      renderAdmin();
      break;

    case 'hideAll':
      hideAll();
      break;

    case 'refreshList':
      if (!$('#adminPanel').classList.contains('hidden') &&
          (S.adminView === 'queue' || S.adminView === 'archive')) {
        renderAdmin();
      }
      break;

    case 'refreshChat':
      if (d.side === 'admin') {
        if (!$('#adminPanel').classList.contains('hidden') && S.adminView === 'active') renderAdmin();
        else $('#adminUnread').hidden = false;
      } else {
        if (!$('#userPanel').classList.contains('hidden') && S.userView === 'mine') renderUser();
        else $('#userUnread').hidden = false;
      }
      break;

    case 'activeClosed':
      if (!$('#adminPanel').classList.contains('hidden') && S.adminView === 'active') {
        S.adminView = 'queue';
        renderAdmin();
      }
      break;

    case 'askRating':
      openRating(d.id, d.adminName);
      break;

    case 'ping':
      // فقط علامت خوانده‌نشده؛ پنل رو به‌زور باز نمی‌کنیم
      if (d.kind === 'new')    $('#adminUnread').hidden = false;
      if (d.kind === 'accept') $('#userUnread').hidden  = false;
      break;
  }
});
