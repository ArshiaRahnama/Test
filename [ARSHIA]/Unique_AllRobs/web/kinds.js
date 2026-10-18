// Gang War and Territory screens of the same NUI (theme per system).
// Robbery stays in app.js; this file only runs when a message has kind = gangwar | territory.
(function () {
  'use strict';

  var RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'Unique_AllRobs';
  var $ = function (id) { return document.getElementById(id); };
  var FA = '۰۱۲۳۴۵۶۷۸۹';
  function fa(n) { return String(n).replace(/\d/g, function (d) { return FA[d]; }); }
  function money(n) { return '$' + fa(Number(n || 0).toLocaleString('en-US')); }
  function clock(sec) { sec = Math.max(0, Math.ceil(sec || 0)); var m = Math.floor(sec / 60), s = sec % 60; return fa(m + ':' + (s < 10 ? '0' + s : s)); }
  function el(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text !== undefined && text !== null) e.textContent = text; return e; }
  function post(name, body) { return fetch('https://' + RES + '/' + name, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(body || {}) }).catch(function () {}); }

  // Help is split into topics (one tab per topic), same as the other screens.
  var HELP = {
    gangwar: [
      ['جنگ چیه؟', 'یک گنگ به گنگ دیگه اعلان جنگ می‌ده. هدف: رسیدن به ۲۰ امتیاز یا بردن زمان‌بندی‌شده‌ی مسابقه، و اگه زون در میون باشه، گرفتن آن زون. جنگ فقط بین جنگجوهای رزرو شده‌ی دو گنگ انجام میشه؛ هیچ‌کس دیگه‌ای توی شهر درگیر نمیشه.'],
      ['اعلان و هزینه', 'فقط باس گنگ می‌تونه جنگ اعلان کنه. گنگ شما و گنگ حریف هر کدوم باید حداقل «تعداد آنلاین لازم» رو داشته باشن (عددش توی صفحه نوشته شده). اعلان جنگ از پول تمیز خزانه‌ی گنگ شما کم میشه و گنگ مقابل هم وقتی قبول کنه همون مبلغ رو می‌ده.'],
      ['قبول یا رد', 'باس گنگ حریف ۱۰ دقیقه وقت داره قبول یا رد کنه. رد یا نادیده گرفتن = پول مهاجم برمی‌گرده. بعد از قبول، ۱۵ دقیقه تا شروع فرصت دارن تا جنگجوها رو بچینن.'],
      ['زون یا فقط پول', 'جنگ می‌تونه سر یکی از زون‌های حریف باشه (اگه مهاجم ببره، زون عوض میشه) یا «فقط پول» (زون عوض نمیشه و جایزه فقط پوله).'],
      ['جنگجوها', 'باس از لیست اعضای آنلاین، جنگجوها رو انتخاب می‌کنه. تعداد دو طرف برابر میشه و حداقل ۳ نفر لازمه. کسی که توی آرنای پین‌بال یا Warzone باشه حساب نمیشه.'],
      ['جمع شدن', 'وقتی جنگ شروع میشه، جنگجوها باید ظرف ۳ دقیقه نزدیک مارکر گنگ خودشون (شعاع ۸۰ متر) باشن. اگه هر دو طرف برسن، مسابقه فوراً شروع میشه. اگه یک طرف کمتر از ۳ نفر برسه، اون طرف باخته (no-show).'],
      ['مسابقه', 'جنگ توی یک آرنای پین‌بال جدا (دنیای جدا) برگزار میشه: اولین تیمی که ۳ راند ببره برنده‌ست. بعد از پایان، همه سر جای قبلی‌شون برمی‌گردن.'],
      ['محدودیت‌ها', 'هر گنگ فقط یک جنگ همزمان داره. بین دو گنگ مشخص ۴۸ ساعت فاصله‌ست. هر گنگ حداکثر ۲ جنگ در هفته. کل سرور حداکثر ۲ جنگ همزمان.'],
      ['تسلیم', 'باس وسط جنگ می‌تونه تسلیم بشه: جنگ تموم میشه و طرف مقابل برنده‌ست.'],
      ['جایزه‌ی برد', 'برنده: پول استخر، XP گنگ، پوینت رابری و اگه زون در میون بود، زون + ۲ ساعت محافظت + ۲۴ ساعت درآمد بیشتر. بازنده: XP کمی تسلی.']
    ],
    territory: [
      ['قلمرو چیه؟', 'نقشه به چند زون (منطقه‌ی تصرف‌پذیر) تقسیم شده. هر زون یک مالک داره. گنگ مالک، درآمد ساعتی (پول کثیف) می‌گیره. تصرف با ماندن داخل زون انجام میشه.'],
      ['تصرف', 'با قرار گرفتن در دایره‌ی زون و ماندن، پیشرفت تصرف پر میشه. اگه چند گنگ همزمان باشن، زون «مناقشه‌ای» میشه و پیشرفت متوقف میشه. زمان باقی‌مونده‌ی تصرف روی صفحه و زیر زون دیده میشه.'],
      ['درآمد', 'هر زون بر اساس tier خودش (۱ تا ۳) درآمد ساعتی داره. tier بالاتر = درآمد بیشتر و XP بیشتر. آپگرید درآمد رو بالا می‌بره.'],
      ['آپگرید', 'سه آپگرید: «سیستم هشدار» (۱ سطح، اعلان لحظه‌ای ورود دشمن)، «خط تولید» (۳ سطح، +۲۵٪ درآمد برای هر سطح) و «استحکام» (۳ سطح، +۲۰٪ زمان لازم برای تصرف توسط مهاجم). آپگرید فقط با پول تمیز و فقط توسط باس خریده میشه.'],
      ['محافظت و زمان', 'بعد از جنگ برنده، زون ۲ ساعت محافظت داره (قابل تصرف نیست). زون‌های بدون حضور گنگ کم‌کم نفوذشون رو از دست می‌دن.'],
      ['صدای تصرف', 'وقتی زونی دست‌به‌دست میشه، همه‌ی کسانی که داخل دایره‌ی جزیره هستن پیام می‌گیرن. گنگ گیرنده هم جایزه‌ی آرموری (پلن رابری) می‌گیره که توی آرموری گنگ میره.'],
      ['جاسوسی و خرابکاری', 'جاسوسی: یک گزارش کوتاه از زون حریف (تعداد نفرات و آپگرید). خرابکاری: کاهش موقت درآمد زون حریف بدون جنگ. هر دو ریسک دارن و کول‌داون.'],
      ['اتحاد', 'گنگ‌ها می‌تونن اتحاد بندن. متحدها توی جنگ‌ها کمک می‌کنن و نمی‌تونن همدیگه رو تصرف کنن.'],
      ['جدول امتیاز', 'تعداد زون‌های هر گنگ و عنوان قلمرو (افتخاری) توی جدول امتیاز دیده میشه.']
    ],
    allies: [
      ['گنگ‌های متحد چیه؟', 'دو گنگ می‌تونن با هم اتحاد ببندن. پیشنهاد می‌ده یک گنگ، قبول می‌کنه گنگ دیگه؛ بعد از قبول، اتحاد برقرار میشه. هر کدوم از گنگ‌ها فقط باس (یا کسی که دسترسی باس‌اکشن داره) می‌تونه پیشنهاد بده، قبول کنه یا اتحاد رو بشکنه.'],
      ['درخواست‌ها', 'پیشنهادهای ورودی (از گنگ‌های دیگه) توی تب «درخواست‌ها» دیده میشن و می‌تونی قبول کنی. پیشنهادهای خودت تا وقتی جواب نیان، توی همین تب منتظر می‌مونن.'],
      ['پیشنهاد اتحاد', 'توی تب «پیشنهاد اتحاد» لیست گنگ‌های دیگه هست (با تعداد آنلاین). گنگی که با شما متحد نیست و پیشنهاد هم ندادید دکمه‌ی پیشنهاد داره. گنگ‌هایی که پیشنهاد دادید، «پیشنهاد داده شده» نشون داده میشن.'],
      ['اثر اتحاد در رابری', 'اعضای گنگ‌های متحد با هم توی یک پارتی حساب میشن. مثلاً اگه گنگ ۱ با گنگ ۲ و ۳ متحده، اعضای هر سه گنگ می‌تونن توی یک پارتی باشن و رابری استارت بشه (به شرط رسیدن به تعداد لازم). هیچ عضو گنگ غیرمتحد نباید توی پارتی باشه.'],
      ['اثر اتحاد در قلمرو', 'گنگ‌های متحد نمی‌تونن زون‌های همدیگه رو تصرف کنن. وقتی گنگی به زون متحد حمله میکنه، متحدها کنار هم از زون دفاع می‌کنن و جزو یک طرف حساب میشن.'],
      ['اثر اتحاد در جنگ گنگ‌ها', 'به گنگ متحد نمی‌شه اعلان جنگ داد. اگه اتحاد بشکنه، از اون لحظه دوباره می‌شه اعلان جنگ داد.'],
      ['شکستن اتحاد', 'باس می‌تونه اتحاد رو بشکنه. اثرش فوری است: از همون لحظه هر دو گنگ دوباره دشمن حساب میشن (مثلاً توی رابری و قلمرو). بعد از شکستن، دوباره می‌شه پیشنهاد اتحاد داد.']
    ],
    robbery: [
      ['رابری گنگ چیه؟', 'رابری‌های پلن‌دار (جواهری، بیمه، بانک پلاتو، Oil Rig) از یک قرعه‌کشی بیرون میان. شاپ و مینی‌بانک بدون پلن هستن و مثل قبل از مارکر شروع میشن.'],
      ['قرعه‌کشی', 'قرعه‌کشی دوره‌دار است (A، B، C ...). هر دوره اول ۵ دقیقه «هنوز شروع نشده» و بعد ۱۵ دقیقه باز میشه. توی فاز باز، باس با دکمه‌ی «افزودن پلن به قرعه‌کشی» یک ticket می‌خره: پلن‌های لازم از آرموری و پوینت گنگ کم میشه.'],
      ['برنده', 'وقتی دوره بسته میشه، یک گنگ به‌صورت تصادفی برنده میشه. شانس هر گنگ به ریشه‌ی دوم تعداد ticketهاش بستگی داره و هر گنگ حداکثر ۵ ticket. درصد شانس هر گنگ توی صفحه نشون داده میشه. گنگی که چند بار باخته، دفعه‌ی بعد شانس بیشتری داره.'],
      ['بعد از برد', 'برنده ۱۰ دقیقه وقت داره رابری رو شروع کنه. حتماً باید توی پارتی باشن و همه‌ی اعضای پارتی باید از همان گنگ یا از گنگ‌های متحدش باشن (هیچ غریبه‌ای نباید توی پارتی باشه). شرط اتحاد: اعضای گنگ‌های متحد با هم حساب میشن و می‌تونن با هم توی یک پارتی باشن. حداقل تعداد لازم هم باید توی پارتی باشه، کنار مارکر، و کلید E رو بزنن. اگه شروع نشه، پلن‌ها ۵۰٪ برمی‌گرده.'],
      ['بازنده', 'گنگی که ticket داشته ولی نبرده، پلن و پوینتش کامل برمی‌گرده و علاوه بر آن ۲۵٪ هزینه‌ی ticketهاش به‌عنوان پوینت تسلی می‌گیره (سقف هر دوره و هر روز داره).'],
      ['توکن و نتیجه', 'رابری موفق یک rob_token می‌ده. اگه ظرف ۳۰ دقیقه توسط عضو گنگ استفاده بشه: برد + توکن گنگ + پوینت + XP کارت. اگه استفاده نشه: باخت.'],
      ['قیمت‌ها', 'هزینه‌ی هر ticket با پول واقعی رابری تنظیم شده: جواهری ۸، بیمه ۹، بانک پلاتو ۲۵، Oil Rig ۴۰ پوینت.']
    ]
  };

  var HEAD = {
    allies: ['گنگ‌های متحد (Gang Friends)', 'اتحاد با گنگ‌ها: پیشنهاد، قبول و شکستن اتحاد'],
    gangwar: ['جنگ گنگ‌ها', 'اعلان جنگ، پذیرش، جنگجوها و نتیجه'],
    territory: ['قلمرو (تریتوری)', 'زون‌ها، آپگرید و جدول امتیاز']
  };

  var state = { kind: 'robbery', data: null, tab: null };

  function setThemeAndHead(kind) {
    $('app').setAttribute('data-theme', kind);
    if (HEAD[kind]) { $('headTitle').textContent = HEAD[kind][0]; $('headSub').textContent = HEAD[kind][1]; }
  }

  function tabsFor(kind) {
    if (kind === 'allies') return [['friends', 'متحدها'], ['requests', 'درخواست‌ها'], ['propose', 'پیشنهاد اتحاد'], ['help', 'راهنما']];
    if (kind === 'gangwar') return [['status', 'وضعیت'], ['declare', 'اعلان جنگ'], ['help', 'راهنما']];
    return [['zones', 'زون‌ها'], ['upgrades', 'آپگرید'], ['board', 'جدول امتیاز'], ['help', 'راهنما']];
  }

  function showKind(kind, data) {
    state.kind = kind; state.data = data;
    var mainEl = document.querySelector('main'); if (mainEl) mainEl.scrollTop = 0;
    window.__kindActive = true;
    clearInterval(state.timer);
    state.timer = setInterval(function () { post('refresh'); }, 3000);
    setThemeAndHead(kind);
    $('app').className = '';
    // hide robbery screens, show kind screens
    ['view-lottery', 'view-robberies', 'view-stats', 'view-help'].forEach(function (id) { $(id).className = 'view hidden'; });
    $('robTabs') && ($('robTabs').className = 'hidden');
    $('kindTabs').className = '';
    $('planChips').textContent = '';
    $('claimBanner').className = 'banner hidden';
    var nb = document.querySelectorAll('.navbtn');
    for (var i = 0; i < nb.length; i++) nb[i].className = 'navbtn' + (nb[i].getAttribute('data-go') === kind ? ' hidden' : '');
    var keep = tabsFor(kind);
    var tabsBox = $('kindTabs'); tabsBox.textContent = '';
    keep.forEach(function (t) {
      var b = el('button', 'tab', t[1]); b.setAttribute('data-kind-tab', t[0]);
      b.onclick = function () { setKindTab(t[0]); };
      tabsBox.appendChild(b);
    });
    setKindTab(state.tab && keep.some(function (t) { return t[0] === state.tab; }) ? state.tab : keep[0][0]);
  }

  function setKindTab(name) {
    state.tab = name;
    var btns = document.querySelectorAll('[data-kind-tab]');
    for (var i = 0; i < btns.length; i++) btns[i].className = 'tab' + (btns[i].getAttribute('data-kind-tab') === name ? ' active' : '');
    renderKind();
  }

  function leaveKind() {
    window.__kindActive = false;
    $('view-kind').className = 'view hidden';
    clearInterval(state.timer);
    $('kindTabs').className = 'hidden';
    $('robTabs') && ($('robTabs').className = '');
    var nb = document.querySelectorAll('.navbtn');
    for (var i = 0; i < nb.length; i++) nb[i].className = 'navbtn' + (nb[i].getAttribute('data-go') === 'robbery' ? ' hidden' : '');
    $('view-kind').className = 'view hidden';
    $('app').setAttribute('data-theme', 'robbery');
  }

  function view() { var v = $('view-kind'); v.className = 'view'; v.textContent = ''; return v; }

  function renderKind() {
    var d = state.data || {};
    var v = view();
    if (state.tab === 'help') return renderHelp(v, state.kind);
    if (state.kind === 'allies') return renderAllies(v, d, state.tab);
    if (state.kind === 'gangwar') return renderGangWar(v, d, state.tab);
    return renderTerritory(v, d, state.tab);
  }

  // the whole help on one scrolling page (topics one after another)
  function renderTopics(container, kind) {
    container.textContent = '';
    var body = el('div', 'help-wrap');
    (HELP[kind] || []).forEach(function (t) {
      body.appendChild(el('h4', null, t[0]));
      body.appendChild(el('div', null, t[1]));
    });
    container.appendChild(body);
  }

  function renderHelp(v, kind) { renderTopics(v, kind); }

  // ---------- Gang Friends (alliances) ----------
  function renderAllies(v, d, tab) {
    if (!d.hasGang) { v.appendChild(el('div', 'empty', 'شما توی هیچ گنگی نیستید.')); return; }
    if (d.enabled === false) { v.appendChild(el('div', 'empty', 'سیستم اتحاد غیرفعاله.')); return; }
    function act(name, gang) { post(name, { gang: gang }); }
    if (tab === 'friends') {
      var allies = d.allies || [];
      if (!allies.length) { v.appendChild(el('div', 'empty', 'هنوز با هیچ گنگی متحد نیستید.')); return; }
      var g = el('div', 'grid');
      allies.forEach(function (a) {
        var c = el('div', 'kind-card mine');
        c.appendChild(el('h3', null, a.label));
        c.appendChild(el('div', 'kind-row', 'آنلاین: ' + fa(a.online || 0)));
        if (d.isBoss) {
          var b = el('button', 'btn danger', 'شکستن اتحاد');
          b.onclick = function () { act('alBreak', a.gang); };
          c.appendChild(b);
        }
        g.appendChild(c);
      });
      v.appendChild(g);
      return;
    }
    if (tab === 'requests') {
      var inc = d.incoming || [], out = d.outgoing || [];
      if (!inc.length && !out.length) { v.appendChild(el('div', 'empty', 'درخواست اتحادی در جریان نیست.')); return; }
      inc.forEach(function (r) {
        var c = el('div', 'kind-card');
        c.appendChild(el('h3', null, 'درخواست از ' + r.label));
        if (d.isBoss) {
          var row = el('div', 'kind-row');
          var y = el('button', 'btn', 'قبول'); y.onclick = function () { act('alAccept', r.gang); };
          row.appendChild(y); c.appendChild(row);
        }
        v.appendChild(c);
      });
      out.forEach(function (r) {
        var c = el('div', 'kind-card');
        c.appendChild(el('h3', null, 'منتظر پاسخ از ' + r.label));
        v.appendChild(c);
      });
      return;
    }
    // propose
    if (!d.isBoss) { v.appendChild(el('div', 'empty', 'فقط باس گنگ می‌تونه پیشنهاد اتحاد بده.')); return; }
    var cand = d.candidates || [];
    if (!cand.length) { v.appendChild(el('div', 'empty', 'گنگ دیگه‌ای برای اتحاد نیست.')); return; }
    var gg = el('div', 'grid');
    cand.forEach(function (cnd) {
      var c = el('div', 'kind-card');
      c.appendChild(el('h3', null, cnd.label));
      c.appendChild(el('div', 'kind-row', 'آنلاین: ' + fa(cnd.online || 0)));
      var b = el('button', 'btn', cnd.pending ? 'پیشنهاد داده شده' : 'پیشنهاد اتحاد');
      b.disabled = !!cnd.pending;
      b.onclick = function () { act('alPropose', cnd.gang); };
      c.appendChild(b);
      gg.appendChild(c);
    });
    v.appendChild(gg);
  }

  // ---------- Gang War ----------
  function renderGangWar(v, d, tab) {
    if (!d.hasGang) { v.appendChild(el('div', 'empty', 'شما توی هیچ گنگی نیستید.')); return; }
    if (tab === 'status') {
      if (d.incoming) {
        var inc = el('div', 'kind-card mine');
        inc.appendChild(el('h3', null, 'درخواست جنگ از «' + d.incoming.from + '»'));
        inc.appendChild(el('div', 'kind-row', 'نوع: ' + (d.incoming.hasZone ? 'زون: ' + d.incoming.zone : 'فقط پول (بدون زون)')));
        inc.appendChild(el('div', 'kind-row', 'هزینه‌ی شما: ' + money(d.incoming.fee) + '  |  مهلت: ' + clock(d.incoming.secondsLeft)));
        var row = el('div', 'kind-row');
        var yes = el('button', 'btn', 'قبول'); yes.onclick = function () { post('zwRespond', { id: d.incoming.id, accept: true }); };
        var no = el('button', 'btn danger', 'رد'); no.onclick = function () { post('zwRespond', { id: d.incoming.id, accept: false }); };
        row.appendChild(yes); row.appendChild(no); inc.appendChild(row);
        v.appendChild(inc);
      }
      if (d.war) {
        var w = d.war, c = el('div', 'kind-card mine');
        c.appendChild(el('h3', null, 'جنگ #' + w.id + ' با ' + w.opponent));
        c.appendChild(el('div', 'kind-row', 'نوع: ' + (w.hasZone ? 'زون: ' + w.zone : 'فقط پول')));
        c.appendChild(el('div', 'kind-row', 'وضعیت: ' + ({ pending: 'منتظر پاسخ', accepted: 'جمع‌آوری جنگجوها', gathering: 'جمع شدن نزدیک گنگ', active: 'در جریان' }[w.status] || w.status)));
        c.appendChild(el('div', 'kind-row', 'امتیاز: ' + fa(w.mine) + ' : ' + fa(w.theirs)));
        c.appendChild(el('div', 'kind-row', 'جنگجوهای شما: ' + fa(w.rosterMine || 0) + ' / ' + fa(d.rosterMax || 0)));
        var t = w.secondsLeft || w.secondsToStart || w.secondsToGather || w.secondsToAccept;
        if (t) c.appendChild(el('div', 'kind-row', 'زمان: ' + clock(t)));
        if (d.isBoss && (w.status === 'active' || w.status === 'gathering')) {
          var s = el('button', 'btn danger', 'تسلیم'); s.onclick = function () { post('zwSurrender'); }; c.appendChild(s);
        }
        v.appendChild(c);
        if (d.isBoss && w.status === 'accepted') renderRoster(v, d.members || []);
      } else if (!d.incoming) {
        v.appendChild(el('div', 'empty', 'جنگ فعالی ندارید. از تب «اعلان جنگ» (فقط باس) شروع کنید.'));
      }
      if (d.isBoss) renderAllyToggle(v, d.allyHelp === true);
      return;
    }
    // declare tab
    if (!d.isBoss) { v.appendChild(el('div', 'empty', 'فقط باس گنگ می‌تونه جنگ اعلان کنه.')); return; }
    v.appendChild(el('div', 'section-title', 'هزینه‌ی اعلان: ' + money(d.fee) + '  |  حداقل آنلاین: ' + fa(d.minOnline || 0) + ' نفر (شما: ' + fa(d.myOnline || 0) + ')'));
    if (d.war) { v.appendChild(el('div', 'empty', 'شما الان یک جنگ دارید.')); return; }
    var list = d.targets || [];
    if (!list.length) { v.appendChild(el('div', 'empty', 'گنگی با حداقل آنلاین لازم پیدا نشد.')); return; }
    var grid = el('div', 'grid');
    list.forEach(function (tg) {
      var card = el('div', 'kind-card');
      card.appendChild(el('h3', null, tg.label));
      card.appendChild(el('div', 'kind-row', 'آنلاین: ' + fa(tg.online) + (tg.reason ? '  |  ' + tg.reason : '')));
      if (tg.reason) { grid.appendChild(card); return; }
      var b = el('button', 'btn', 'جنگ بدون زون (فقط پول)');
      b.onclick = function () { post('zwDeclare', { gang: tg.gang, zone: null }); };
      card.appendChild(b);
      (tg.zones || []).forEach(function (z) {
        var zb = el('button', 'btn ghost', 'سر زون ' + z.label + (z.tier ? ' (tier ' + fa(z.tier) + ')' : ''));
        if (z.reason) { zb.disabled = true; zb.textContent = z.label + ' (' + z.reason + ')'; }
        else zb.onclick = function () { post('zwDeclare', { gang: tg.gang, zone: z.key }); };
        card.appendChild(zb);
      });
      grid.appendChild(card);
    });
    v.appendChild(grid);
  }

  // the boss ticks this: allied gangs' members may then fight for this gang
  function renderAllyToggle(v, on) {
    var c = el('div', 'kind-card');
    c.appendChild(el('h3', null, 'کمک گنگ‌های متحد'));
    c.appendChild(el('div', 'kind-row', 'وقتی روشن باشه، اعضای گنگ‌های متحد شما می‌تونن توی روستر جنگ شما باشن.'));
    var b = el('button', on ? 'btn' : 'btn ghost', on ? '☑ روشن (کمک متحدها فعاله)' : '☐ خاموش');
    b.onclick = function () { post('zwAllyHelp', { enabled: !on }); };
    c.appendChild(b);
    v.appendChild(c);
  }

  function renderRoster(v, members) {
    v.appendChild(el('div', 'section-title', 'جنجوها (کلیک = اضافه/حذف)'));
    var grid = el('div', 'grid');
    members.forEach(function (m) {
      var b = el('button', m.inRoster ? 'btn' : 'btn ghost', (m.inRoster ? '[در جنگ] ' : '') + (m.fromAlly ? '[متحد: ' + (m.gang || '') + '] ' : '') + m.name);
      b.onclick = function () { post('zwRoster', { src: m.src, add: !m.inRoster }); };
      grid.appendChild(b);
    });
    v.appendChild(grid);
  }

  // ---------- Territory ----------
  function ownerOf(z) { return z.ownerLabel || z.owner || 'بدون مالک'; }

  function renderTerritory(v, d, tab) {
    var zones = d.zones || {};
    var keys = Object.keys(zones).sort(function (a, b) { return (zones[a].label || '').localeCompare(zones[b].label || ''); });
    if (tab === 'zones') {
      var grid = el('div', 'grid');
      keys.forEach(function (k) {
        var z = zones[k];
        var mine = d.gang && z.owner === d.gang;
        var c = el('div', 'kind-card' + (mine ? ' mine' : ''));
        c.appendChild(el('h3', null, z.label || k));
        c.appendChild(el('div', 'kind-row', 'مالک: ' + ownerOf(z) + (mine ? '  (شما)' : '')));
        c.appendChild(el('div', 'kind-row', 'tier: ' + fa(z.tier || 0) + (z.bossZone ? '  |  Boss Zone' : '')));
        var badges = el('div', 'meta');
        if (z.contested) badges.appendChild(el('span', 'badge live', 'مناقشه‌ای'));
        if (z.vulnerable) badges.appendChild(el('span', 'badge warn', 'آسیب‌پذیر'));
        c.appendChild(badges);
        var up = el('div');
        var U = d.upgradeCfg || {};
        Object.keys(U).forEach(function (ut) {
          if (ut === 'Enabled' || !U[ut] || typeof U[ut] !== 'object') return;
          var lvl = (z.upgrades && z.upgrades[ut]) || 0;
          up.appendChild(el('span', 'lvl-chip', U[ut].label + ' ' + fa(lvl) + '/' + fa(U[ut].maxLevel || 0)));
        });
        c.appendChild(up);
        grid.appendChild(c);
      });
      v.appendChild(grid);
      if (!keys.length) v.appendChild(el('div', 'empty', 'اطلاعات زون‌ها در دسترس نیست.'));
      return;
    }
    if (tab === 'upgrades') {
      if (!d.isBoss) { v.appendChild(el('div', 'empty', 'فقط باس گنگ می‌تونه آپگرید بخره (پول تمیز از خزانه).')); return; }
      var mineKeys = keys.filter(function (k) { return zones[k].owner === d.gang && !zones[k].bossZone; });
      if (!mineKeys.length) { v.appendChild(el('div', 'empty', 'گنگ شما هنوز زونی نداره.')); return; }
      var U2 = d.upgradeCfg || {};
      mineKeys.forEach(function (k) {
        var z = zones[k];
        v.appendChild(el('div', 'section-title', z.label || k));
        var g = el('div', 'grid');
        Object.keys(U2).forEach(function (ut) {
          if (ut === 'Enabled' || !U2[ut] || typeof U2[ut] !== 'object') return;
          var cfg = U2[ut], lvl = (z.upgrades && z.upgrades[ut]) || 0, max = cfg.maxLevel || 0;
          var c = el('div', 'kind-card');
          c.appendChild(el('h3', null, cfg.label));
          c.appendChild(el('div', 'kind-row', 'سطح: ' + fa(lvl) + ' / ' + fa(max)));
          var b = el('button', 'btn', lvl >= max ? 'حداکثر سطح' : 'ارتقا (' + money((cfg.cost || [])[lvl]) + ')');
          b.disabled = lvl >= max;
          b.onclick = function () { post('terBuy', { zone: k, type: ut }); };
          c.appendChild(b);
          g.appendChild(c);
        });
        v.appendChild(g);
      });
      return;
    }
    if (tab === 'board') {
      var rows = d.board || [];
      if (!rows.length) { v.appendChild(el('div', 'empty', 'هنوز زونی تصرف نشده.')); return; }
      rows.forEach(function (r, i) {
        var c = el('div', 'kind-card' + (r.gang === d.gang ? ' mine' : ''));
        c.appendChild(el('h3', null, fa(i + 1) + '. ' + r.label + (r.title ? '  —  ' + r.title : '')));
        c.appendChild(el('div', 'kind-row', 'تعداد زون: ' + fa(r.zones)));
        v.appendChild(c);
      });
    }
  }

  // ---------- messages / wiring ----------
  window.addEventListener('message', function (e) {
    var m = e.data || {};
    if (m.action === 'openKind') { showKind(m.kind, m.data); }
    else if (m.action === 'updateKind') { state.data = m.data; renderKind(); }
    else if (m.action === 'close') { if (window.__kindActive) leaveKind(); }
  });

  var nb = document.querySelectorAll('.navbtn');
  for (var i = 0; i < nb.length; i++) (function (b) { b.onclick = function () { post('nav', { target: b.getAttribute('data-go') }); }; })(nb[i]);

  // robbery help page (same text as the other two systems)
  var rh = $('helpRob');
  if (rh) renderTopics(rh, 'robbery');

  window.__kinds = { showKind: showKind, renderKind: renderKind, leave: leaveKind, HELP: HELP };
})();
