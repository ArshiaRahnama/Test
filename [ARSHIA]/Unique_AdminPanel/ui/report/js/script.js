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
  if (S.userView === 'ticket')  return renderTicketCompose(body);
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

/* ============================================================= TICKET ===
   Lets a player open a general-purpose ticket without leaving /report - own
   render/submit functions, own state slice (S.ticketCompose), own config
   fetch (ticket:config), own submit endpoint (ticket:create). Nothing here
   reads or writes S.compose / S.cfg / submitReport, so it can never bleed
   into the report flow above. Full ticket management (thread, participants,
   assigned admins, closing) stays in the dedicated /ticket & /atickets panel
   - this tab is intentionally just "start one", to keep this screen simple.
=========================================================================== */

async function renderTicketCompose(body) {
  body.className = 'body scroller';

  if (!S.ticketCfg) {
    body.innerHTML = `<div class="empty"><i class="fa-solid fa-circle-notch fa-spin"></i></div>`;
    const res = await nui('ticket:config');
    if (!res || !res.r) {
      body.innerHTML = `<div class="empty"><i class="fa-solid fa-triangle-exclamation"></i>
        <h3>سیستم تیکت در دسترس نیست</h3><p>یک بار دیگه امتحان کن.</p></div>`;
      return;
    }
    S.ticketCfg = res;
  }
  if (S.userView !== 'ticket') return;   // تب عوض شده تا fetch بالا تموم شه

  const cats = S.ticketCfg.categories || [];
  const prios = S.ticketCfg.priorities || [];
  if (!S.ticketCompose) S.ticketCompose = { category: cats[0] && cats[0].id, priority: 2 };

  body.innerHTML = `
    <form class="compose" id="ticketComposeForm" novalidate>
      <p class="compose__lede">
        این بخش برای موضوعاتِ عمومیه (سوال، مشکلِ مالی، باگ، اعتراض به مجازات...) - نه گزارشِ یک بازیکنِ خاص.
        اگه میخوای یک بازیکن رو گزارش بدی، از تبِ «ریپورت جدید» استفاده کن.
      </p>

      <div class="field">
        <label class="field__label" for="tTitle">عنوان</label>
        <input class="input" id="tTitle" maxlength="120" placeholder="مثلاً: پول خریدم ولی به حسابم نیومد" autocomplete="off">
        <div class="counter" id="tTitleCount">0 / 120</div>
      </div>

      <div class="field">
        <span class="field__label">دسته‌بندی</span>
        <div class="cats" id="tCats">
          ${cats.map(c => `<button type="button" class="cat cat--sky" data-key="${esc(c.id)}"><span>${esc(c.label)}</span></button>`).join('')}
        </div>
      </div>

      <div class="field">
        <span class="field__label">اولویت</span>
        <div class="cats" id="tPrios">
          ${prios.map(p => `<button type="button" class="cat cat--sky" data-key="${esc(p.id)}" style="--pc:${esc(p.color)}"><span>${esc(p.label)}</span></button>`).join('')}
        </div>
      </div>

      <div class="field">
        <label class="field__label" for="tInfo">توضیحات</label>
        <textarea class="textarea" id="tInfo" maxlength="1000" placeholder="کامل توضیح بده تا سریع‌تر بهت رسیدگی بشه..."></textarea>
        <div class="counter" id="tInfoCount">0 / 1000</div>
      </div>

      <button class="btn btn--go btn--sky" id="tSend" type="submit">
        <i class="fa-solid fa-paper-plane"></i> ثبت تیکت
      </button>
    </form>`;

  $$('#tCats .cat').forEach(btn => {
    btn.classList.toggle('is-on', btn.dataset.key === S.ticketCompose.category);
    btn.addEventListener('click', () => {
      S.ticketCompose.category = btn.dataset.key;
      $$('#tCats .cat').forEach(b => b.classList.toggle('is-on', b === btn));
    });
  });
  $$('#tPrios .cat').forEach(btn => {
    btn.classList.toggle('is-on', Number(btn.dataset.key) === S.ticketCompose.priority);
    btn.addEventListener('click', () => {
      S.ticketCompose.priority = Number(btn.dataset.key);
      $$('#tPrios .cat').forEach(b => b.classList.toggle('is-on', b === btn));
    });
  });

  const bind = (inputId, countId, max) => {
    const inp = $(`#${inputId}`), out = $(`#${countId}`);
    const upd = () => { out.textContent = `${len(inp.value)} / ${max}`; };
    inp.addEventListener('input', upd);
    upd();
  };
  bind('tTitle', 'tTitleCount', 120);
  bind('tInfo', 'tInfoCount', 1000);

  $('#ticketComposeForm').addEventListener('submit', submitTicket);
}

async function submitTicket(ev) {
  ev.preventDefault();
  const title = $('#tTitle').value.trim();
  const message = $('#tInfo').value.trim();

  const fail = (el, msg) => {
    el.classList.add('is-bad');
    setTimeout(() => el.classList.remove('is-bad'), 1200);
    toast(msg, 'bad');
  };

  if (len(title) < 5)   return fail($('#tTitle'), 'عنوان باید حداقل ۵ کاراکتر باشه.');
  if (len(message) < 10) return fail($('#tInfo'), 'توضیحات باید حداقل ۱۰ کاراکتر باشه.');

  const btn = $('#tSend');
  btn.disabled = true;
  btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin"></i> در حال ارسال';

  const res = await nui('ticket:create', {
    title, message,
    category: S.ticketCompose.category,
    priority: S.ticketCompose.priority,
  });

  btn.disabled = false;
  btn.innerHTML = '<i class="fa-solid fa-paper-plane"></i> ثبت تیکت';

  if (res && res.r) {
    toast(`تیکت #${res.id} ثبت شد - برای پیگیری و چت با ادمین از دستور /ticket استفاده کن.`, 'ok');
    $('#ticketComposeForm').reset();
    S.ticketCompose = { category: (S.ticketCfg.categories[0] || {}).id, priority: 2 };
  } else {
    toast((res && res.msg) || 'ثبت تیکت انجام نشد.', 'bad');
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
  if (S.adminView === 'tickets') return renderTicketAdmin(body);
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
        <button class="btn btn--ghost btn--sm" data-do="ticketize" data-report-id="${esc(t.ID)}"><i class="fa-solid fa-ticket"></i> تبدیل به تیکت</button>
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

  // Ticket System link (ticket:getReportTicketIds, server/ticket_main.lua) -
  // non-blocking: the pane renders immediately, this just swaps the button
  // label in place once it knows whether a ticket already exists.
  nui('ticket:getReportTicketIds', { reportId: t.ID }).then(res => {
    const btn = $('[data-do="ticketize"]', pane);
    if (!btn || !res || !res.r) return;
    if (res.data && res.data.length) {
      const first = res.data[0];
      btn.innerHTML = `<i class="fa-solid fa-ticket"></i> تیکت #${esc(first.id)} (${esc(first.status)})`;
      btn.title = res.data.length > 1 ? `${res.data.length} تیکت از این ریپورت ساخته شده` : 'روی این ریپورت قبلاً تیکتی ساخته شده - کلیک برای ساخت یک تیکت جدید دیگر';
    }
  });
}

async function detailAction(what, t) {
  if (what === 'open') { S.adminView = 'active'; return renderAdmin(); }

  if (what === 'delete' && !confirm(`ریپورت #${t.ID} برای همیشه حذف بشه؟`)) return;

  // Ticket System link - own endpoint/payload shape (ticket:createFromReport
  // takes { reportId }, not { id }), and unlike the actions below it doesn't
  // change the report's own status, so the report stays selected/open and
  // only the pane's ticket badge needs a refresh, not the whole queue.
  if (what === 'ticketize') {
    const res = await nui('ticket:createFromReport', { reportId: t.ID });
    if (res && res.r) {
      toast(`تیکت #${res.id} از این ریپورت ساخته شد.`, 'ok');
      paintDetail();
    } else {
      toast((res && res.msg) || 'ساخت تیکت ناموفق بود.', 'bad');
    }
    return;
  }

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

/* ================================================= TICKET ADMIN TAB ===
   "همه اپشن‌هاش" - full ticket management embedded directly in /areport:
   list + filters, detail w/ status+priority, participants, assigned admins,
   linked-report view, chat thread. Reuses this file's existing .split/
   .queue/.tk/.pane/.thread/.composer classes (same ones renderQueue/
   paintDetail use above) so it looks like one UI, not a bolted-on panel.
   Talks ONLY through the ticket: namespace - never touches S.tickets,
   S.selected, or any report-specific state.
=========================================================================== */

const TS = {
  filter: 'all', mine: false, search: '',
  list: [], selectedId: null, detail: null,
  cfg: null, open: { players: false, admins: false },
  gen: 0,   // bumped by every paintTicketDetail() call; stale async work checks against it and bails
};

function ticketStatusPill(s) {
  if (s === 'open')        return '<span class="pill pill--wait">باز</span>';
  if (s === 'in_progress') return '<span class="pill pill--live">درحال‌بررسی</span>';
  return '<span class="pill pill--done">بسته‌شده</span>';
}
function ticketPriColor(p) {
  const found = ((TS.cfg && TS.cfg.priorities) || []).find(x => x.id === Number(p));
  return (found && found.color) || '#7c8698';
}
function ticketPriLabel(p) {
  const found = ((TS.cfg && TS.cfg.priorities) || []).find(x => x.id === Number(p));
  return (found && found.label) || '—';
}
function ticketCatLabel(c) {
  const found = ((TS.cfg && TS.cfg.categories) || []).find(x => x.id === c);
  return (found && found.label) || c || '—';
}

async function renderTicketAdmin(body) {
  body.className = 'body';
  body.innerHTML = `<div class="split"><div class="queue">${SKEL}</div><div class="pane"></div></div>`;

  if (!TS.cfg) {
    const cfgRes = await nui('ticket:config');
    if (cfgRes && cfgRes.r) TS.cfg = cfgRes;
  }
  if (S.adminView !== 'tickets') return;

  body.innerHTML = `
    <div class="split">
      <div class="queue">
        <div class="queue__tools">
          <input class="search" id="tqSearch" placeholder="جستجو در عنوان یا شماره…" value="${esc(TS.search)}" autocomplete="off">
          <div class="filters">
            <button class="filt ${TS.filter === 'all' && !TS.mine ? 'is-on' : ''}" data-tf="all">همه</button>
            <button class="filt ${TS.filter === 'open' ? 'is-on' : ''}" data-tf="open">باز</button>
            <button class="filt ${TS.filter === 'in_progress' ? 'is-on' : ''}" data-tf="in_progress">درحال‌بررسی</button>
            <button class="filt ${TS.filter === 'closed' ? 'is-on' : ''}" data-tf="closed">بسته‌شده</button>
            <button class="filt ${TS.mine ? 'is-on' : ''}" data-tf="mine">تیکت‌های من</button>
          </div>
        </div>
        <div class="list scroller" id="tqList"></div>
      </div>
      <div class="pane" id="tqDetail"></div>
    </div>`;

  $('#tqSearch').addEventListener('input', e => { TS.search = e.target.value; paintTicketQueue(); });
  syncTicketFilterButtons();
  $$('.filt', $('#tqList').closest('.queue')).forEach(b => b.addEventListener('click', () => {
    if (b.dataset.tf === 'mine') { TS.mine = !TS.mine; }
    else { TS.mine = false; TS.filter = b.dataset.tf; }
    syncTicketFilterButtons();
    loadTicketQueue();
  }));

  await loadTicketQueue();
}

function syncTicketFilterButtons() {
  const bar = $('#tqSearch');
  if (!bar) return;
  $$('.filt', bar.closest('.queue')).forEach(b => {
    const on = b.dataset.tf === 'mine' ? TS.mine : (!TS.mine && b.dataset.tf === TS.filter);
    b.classList.toggle('is-on', on);
  });
}

async function loadTicketQueue() {
  const res = await nui('ticket:getAll', { status: TS.mine ? 'all' : TS.filter, mine: TS.mine });
  TS.list = (res && res.r && res.data) || [];
  paintTicketQueue();
  paintTicketDetail();
}

function visibleTicketRows() {
  const q = TS.search.trim().toLowerCase();
  if (!q) return TS.list;
  return TS.list.filter(t => String(t.id).includes(q) || String(t.title || '').toLowerCase().includes(q));
}

function paintTicketQueue() {
  const list = $('#tqList');
  if (!list) return;
  const rows = visibleTicketRows();

  if (!rows.length) {
    list.innerHTML = `<div class="empty"><i class="fa-solid fa-ticket"></i>
      <h3>تیکتی نیست</h3><p>با این فیلتر چیزی پیدا نشد.</p></div>`;
    return;
  }

  list.innerHTML = rows.map(t => `
    <div class="tk tk__grid ${t.status === 'open' ? 'tk--wait' : ''} ${TS.selectedId === t.id ? 'is-sel' : ''}" data-tid="${esc(t.id)}">
      <span class="tk__spine" style="background:${esc(ticketPriColor(t.priority))};color:${esc(ticketPriColor(t.priority))}"></span>
      <span class="tk__ava">${esc(String(t.creator.name || '?').trim().charAt(0).toUpperCase() || '?')}</span>
      <div class="tk__main">
        <div class="tk__top">
          <span class="tk__id">#${esc(String(t.id).padStart(4, '0'))}</span>
          <span class="tk__title">${esc(t.title)}</span>
        </div>
        <div class="tk__meta">
          <span>${esc(ticketCatLabel(t.category))}</span>
          <span>${esc(t.creator.name || '')}</span>
          ${t.sourceReportId ? `<span><i class="fa-solid fa-link"></i> ریپورت #${esc(t.sourceReportId)}</span>` : ''}
        </div>
      </div>
      <div class="tk__side">${ticketStatusPill(t.status)}</div>
    </div>`).join('');

  $$('.tk', list).forEach(row => row.addEventListener('click', () => {
    TS.selectedId = Number(row.dataset.tid);
    TS.open = { players: false, admins: false };
    paintTicketQueue();
    paintTicketDetail();
  }));
}

async function paintTicketDetail() {
  const pane = $('#tqDetail');
  if (!pane) return;
  const myGen = ++TS.gen;   // this call "owns" myGen; anyone else bumping TS.gen makes us stale

  if (!TS.selectedId) {
    pane.innerHTML = `<div class="empty"><i class="fa-solid fa-ticket"></i>
      <h3>یک تیکت رو انتخاب کن</h3><p>جزئیات، چت و اپشن‌هاش اینجا میاد.</p></div>`;
    return;
  }

  const res = await nui('ticket:getDetail', { id: TS.selectedId });
  if (myGen !== TS.gen) return;   // یک render جدیدتر تو همین فاصله شروع شده - این یکی رو رها کن
  if (!res || !res.r) {
    pane.innerHTML = `<div class="empty"><i class="fa-solid fa-triangle-exclamation"></i><h3>پیدا نشد</h3></div>`;
    return;
  }
  TS.detail = res;
  const t = res.ticket;
  const prios = (TS.cfg && TS.cfg.priorities) || [];
  const stats = (TS.cfg && TS.cfg.statuses) || [];

  pane.innerHTML = `
    <div class="pane__head">
      <span class="tk__ava" style="width:40px;height:40px">${esc(String(t.creator.name || '?').charAt(0).toUpperCase())}</span>
      <div class="pane__who">
        <div class="pane__name">#${esc(String(t.id).padStart(4, '0'))} - ${esc(t.title)}</div>
        <div class="pane__sub">
          <span><span class="tpri-dot" style="background:${esc(ticketPriColor(t.priority))}"></span> ${esc(ticketCatLabel(t.category))}</span>
          <span>${esc(t.creator.name || '-')}</span>
          ${t.sourceReportId ? `<span id="tLinkedReport" class="pill" style="cursor:pointer"><i class="fa-solid fa-link"></i> گزارش #${esc(t.sourceReportId)}</span>` : ''}
        </div>
      </div>
      <div class="pane__acts">
        ${ticketStatusPill(t.status)}
      </div>
    </div>

    <div class="queue__tools">
      <div class="filters" style="flex-wrap:wrap">
        <select class="input" id="tStatusSel" style="width:auto">
          ${stats.map(s => `<option value="${esc(s.id)}" ${s.id === t.status ? 'selected' : ''}>${esc(s.label)}</option>`).join('')}
        </select>
        <select class="input" id="tPrioSel" style="width:auto">
          ${prios.map(p => `<option value="${esc(p.id)}" ${p.id === t.priority ? 'selected' : ''}>${esc(p.label)}</option>`).join('')}
        </select>
        <button class="filt ${TS.open.players ? 'is-on' : ''}" id="tTogglePlayers"><i class="fa-solid fa-users"></i> بازیکن‌ها (${res.participants.length})</button>
        <button class="filt ${TS.open.admins ? 'is-on' : ''}" id="tToggleAdmins"><i class="fa-solid fa-shield"></i> ادمین‌ها (${res.admins.length})</button>
      </div>
    </div>

    ${TS.open.players ? `
    <div class="tpanel" id="tPlayersBox">
      <input class="search tpanel__search" id="tPlayerSearch" placeholder="جستجوی نام یا آیدی بازیکن…" autocomplete="off">
      <div id="tPlayerResults" class="tpanel__results"></div>
      <div class="tpanel__sectitle">بازیکن‌های حاضر در تیکت</div>
      ${res.participants.map(p => `
        <div class="tpanel__row">
          <span>${esc(p.name || p.identifier)}<span class="tpanel__role">(${esc(p.role)})</span></span>
          ${p.role !== 'creator' ? `<button class="tpanel__remove" data-rm-player="${esc(p.identifier)}"><i class="fa-solid fa-xmark"></i></button>` : ''}
        </div>`).join('') || '<p class="tpanel__empty">بازیکنی اضافه نشده.</p>'}
    </div>` : ''}

    ${TS.open.admins ? `
    <div class="tpanel" id="tAdminsBox">
      <div class="tpanel__sectitle">ادمین‌های آنلاین</div>
      <div id="tAdminOnline" class="tpanel__results"></div>
      <div class="tpanel__sectitle">ادمین‌های مسئول این تیکت</div>
      ${res.admins.map(a => `
        <div class="tpanel__row">
          <span><i class="fa-solid fa-shield"></i> ${esc(a.name || a.identifier)}</span>
          <button class="tpanel__remove" data-rm-admin="${esc(a.identifier)}"><i class="fa-solid fa-xmark"></i></button>
        </div>`).join('') || '<p class="tpanel__empty">هنوز ادمینی مسئول نیست.</p>'}
    </div>` : ''}

    <div class="thread scroller" id="tThread"></div>
    <div class="composer">
      <input class="input" id="tMsg" placeholder="پیامت رو بنویس…" maxlength="1000" autocomplete="off">
      <button class="sendbtn" id="tSend"><i class="fa-solid fa-paper-plane"></i></button>
    </div>`;

  paintTicketThread(res.messages || []);

  $('#tStatusSel').addEventListener('change', async e => {
    const val = e.target.value;
    if (val === 'closed' && !confirm(`تیکت #${t.id} برای همیشه بسته بشه؟ فقط از این راه بسته میشه.`)) {
      e.target.value = t.status;
      return;
    }
    await nui('ticket:setStatus', { id: t.id, status: val });
    loadTicketQueue();
  });
  $('#tPrioSel').addEventListener('change', async e => {
    await nui('ticket:setPriority', { id: t.id, priority: Number(e.target.value) });
    loadTicketQueue();
  });

  $('#tTogglePlayers').addEventListener('click', () => { TS.open.players = !TS.open.players; TS.open.admins = false; paintTicketDetail(); });
  $('#tToggleAdmins').addEventListener('click', () => { TS.open.admins = !TS.open.admins; TS.open.players = false; paintTicketDetail(); });

  const reportLink = $('#tLinkedReport');
  if (reportLink) reportLink.addEventListener('click', () => openLinkedReportView(t.sourceReportId));

  if (TS.open.players) {
    let deb = null;
    $('#tPlayerSearch').addEventListener('input', e => {
      clearTimeout(deb);
      const q = e.target.value.trim();
      deb = setTimeout(async () => {
        const resultsBox = $('#tPlayerResults');
        if (!resultsBox) return;
        if (q.length < 2) { resultsBox.innerHTML = ''; return; }
        const r = await nui('ticket:searchPlayer', { query: q });
        if (myGen !== TS.gen) return;   // پنل عوض شده تا جواب جستجو برگرده
        const resultsBox2 = $('#tPlayerResults');
        if (!resultsBox2) return;
        const found = (r && r.data) || [];
        resultsBox2.innerHTML = found.map(p => `
          <div class="tpanel__row">
            <span>${esc(p.name)}${p.online ? ' 🟢' : ''}</span>
            <button class="tpanel__add" data-add-player="${esc(p.identifier)}" data-name="${esc(p.name)}">افزودن</button>
          </div>`).join('') || '<p class="tpanel__empty">نتیجه‌ای نبود.</p>';
        $$('[data-add-player]', resultsBox2).forEach(btn => btn.addEventListener('click', async () => {
          await nui('ticket:addParticipant', { id: t.id, identifier: btn.dataset.addPlayer, name: btn.dataset.name });
          paintTicketDetail();
        }));
      }, 300);
    });
    $$('[data-rm-player]', pane).forEach(btn => btn.addEventListener('click', async () => {
      await nui('ticket:removeParticipant', { id: t.id, identifier: btn.dataset.rmPlayer });
      paintTicketDetail();
    }));
  }

  if (TS.open.admins) {
    const r = await nui('ticket:getOnlineAdmins');
    if (myGen !== TS.gen) return;   // پنل عوض شده تا این await برگرده - دیگه چیزی رو ننویس
    const onlineBox = $('#tAdminOnline');
    if (!onlineBox) return;   // محافظِ اضافه: حتی اگه gen درست بود ولی DOM جابه‌جا شده بود
    const found = (r && r.data) || [];
    onlineBox.innerHTML = found.map(a => `
      <div class="tpanel__row">
        <span>${esc(a.name)}</span>
        <button class="tpanel__add" data-add-admin="${esc(a.identifier)}" data-name="${esc(a.name)}">افزودن به تیکت</button>
      </div>`).join('') || '<p class="tpanel__empty">ادمین آنلاینی نیست.</p>';
    $$('[data-add-admin]', pane).forEach(btn => btn.addEventListener('click', async () => {
      await nui('ticket:assignAdmin', { id: t.id, identifier: btn.dataset.addAdmin, name: btn.dataset.name });
      paintTicketDetail();
    }));
    $$('[data-rm-admin]', pane).forEach(btn => btn.addEventListener('click', async () => {
      await nui('ticket:unassignAdmin', { id: t.id, identifier: btn.dataset.rmAdmin });
      paintTicketDetail();
    }));
  }

  const doSend = async () => {
    const inp = $('#tMsg');
    const text = inp.value.trim();
    if (!text) return;
    inp.value = '';
    const r = await nui('ticket:sendMessage', { id: t.id, text });
    if (r && r.r) paintTicketDetail();
    else { toast((r && r.msg) || 'پیام ارسال نشد.', 'bad'); inp.value = text; }
  };
  $('#tSend').addEventListener('click', doSend);
  $('#tMsg').addEventListener('keydown', e => { if (e.key === 'Enter') doSend(); });
}

function paintTicketThread(messages) {
  const box = $('#tThread');
  if (!box) return;
  if (!messages.length) {
    box.innerHTML = `<div class="empty"><p>هنوز پیامی نیست.</p></div>`;
    return;
  }
  box.innerHTML = messages.map(m => {
    if (m.is_system) return `<div class="msg msg--sys"><div class="msg__body">${esc(m.message)}</div></div>`;
    const side = m.is_admin ? 'msg--me' : 'msg--them';
    return `<div class="msg ${side}">
      <div class="msg__who">${esc(m.name || '')}${m.is_admin ? ' <i class="fa-solid fa-shield"></i>' : ''}</div>
      <div class="msg__body">${esc(m.message)}</div>
    </div>`;
  }).join('');
  box.scrollTop = box.scrollHeight;
}

async function openLinkedReportView(reportId) {
  const r = await nui('ticket:getLinkedReport', { reportId });
  if (!r || !r.r) return toast('گزارش پیدا نشد.', 'bad');
  const rp = r.report;

  const wrap = document.createElement('div');
  wrap.style.cssText = 'position:fixed;inset:0;z-index:80;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.55);backdrop-filter:blur(3px);';
  wrap.innerHTML = `
    <div style="width:420px;max-height:70vh;overflow:auto;background:#151a22;border:1px solid #2a323f;border-radius:14px;padding:18px;color:#dfe5ee;font-size:13px;line-height:1.9;box-shadow:0 20px 50px rgba(0,0,0,.5);">
      <div style="font-weight:800;font-size:15px;margin-bottom:10px;display:flex;align-items:center;gap:8px;">
        <i class="fa-solid fa-link"></i> گزارش #${esc(rp.id)}
      </div>
      <div style="color:#7c8698;font-size:11px;">عنوان</div><div>${esc(rp.title || '-')}</div>
      <div style="color:#7c8698;font-size:11px;margin-top:8px;">دسته</div><div>${esc(rp.category || '-')}</div>
      <div style="color:#7c8698;font-size:11px;margin-top:8px;">توضیحات</div><div>${esc(rp.detail || '-')}</div>
      <div style="color:#7c8698;font-size:11px;margin-top:8px;">وضعیت</div><div>${esc(rp.status || '-')}</div>
      ${rp.adminName ? `<div style="color:#7c8698;font-size:11px;margin-top:8px;">ادمین رسیدگی‌کننده</div><div>${esc(rp.adminName)}</div>` : ''}
      <button id="tReportViewClose" style="margin-top:16px;width:100%;padding:8px;border-radius:8px;border:1px solid #3a4553;background:#1d232d;color:#dfe5ee;cursor:pointer;">بستن</button>
    </div>`;
  document.body.appendChild(wrap);
  const close = () => wrap.remove();
  wrap.addEventListener('click', e => { if (e.target === wrap) close(); });
  $('#tReportViewClose', wrap).addEventListener('click', close);
}

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

    // Sent by the F4 admin menu's "🎫 Tickets" button (client/ticket_client
    // .lua's OpenTicketPanel) right after it runs /areport. Setting
    // S.adminView first (not just calling renderAdmin) means this works
    // whether it lands before or after 'showAdminPanel' - the access-check
    // round trip before the panel opens is async, so the arrival order
    // between the two messages isn't guaranteed.
    case 'openTicketsTab':
      S.adminView = 'tickets';
      if (!$('#adminPanel').classList.contains('hidden')) renderAdmin();
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
