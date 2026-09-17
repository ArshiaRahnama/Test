// ============================================================
// Unique_Hud / ui / scoreboard / js / main.js
// ری‌دیزاین بر اساس عکس نمونه - فقط ظاهر عوض شده، پیام‌رسانی با
// client/scoreboard.lua (id: 'scoreboard', event: 'toggle' / 'update') دست‌نخورده.
// ============================================================

// 👇 این سه خط رو با اطلاعات سرور خودتون عوض کنید
var CONFIG = {
  serverName: 'UNIQUE RP',
  discordUrl: 'https://discord.gg/yourinvite',
  websiteUrl: 'https://yourwebsite.com',
};

// کارت‌ها الان به‌صورت ۳ ارگان + ادمین‌ها گروه‌بندی شدن (دقیقاً مطابق
// server/scoreboard.lua). آیکون‌ها از ../assets/imgs/ میان.
var ICON_BASE = '../assets/imgs/';
var CARDS = [
  { icon: ICON_BASE + 'DOA.png', label: 'Department Of Justice', jobs: ['cid', 'cia', 'marshal', 'fbi', 'judge', 'doa'] },
  { icon: ICON_BASE + 'police.png', label: 'Law Enforcement', jobs: ['police', 'sheriff', 'mt'] },
  { icon: ICON_BASE + 'taxi.png', label: 'Organ Services', jobs: ['taxi', 'mechanic', 'ambulance', 'weazel'] },
  { icon: ICON_BASE + 'hr.png', label: 'Admins', jobs: [], isAdmins: true },
];

document.getElementById('uh-server-name').textContent = CONFIG.serverName;
document.documentElement.setAttribute('data-theme', 'dark'); // پیش‌فرض همیشه دارک

// ---------- لینک دیسکورد/سایت: کپی تو کلیپ‌بورد + نوتیف ----------
function copyLink(e, url, label) {
  e.preventDefault();
  var done = function () { showToast(label + ' کپی شد ✅'); };
  var fail = function () { showToast('کپی نشد، دوباره امتحان کن ❌'); };
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(url).then(done).catch(function () {
      legacyCopy(url) ? done() : fail();
    });
  } else {
    legacyCopy(url) ? done() : fail();
  }
}
function legacyCopy(text) {
  try {
    var ta = document.createElement('textarea');
    ta.value = text;
    ta.style.position = 'fixed';
    ta.style.opacity = '0';
    document.body.appendChild(ta);
    ta.focus();
    ta.select();
    var ok = document.execCommand('copy');
    document.body.removeChild(ta);
    return ok;
  } catch (err) {
    return false;
  }
}

var toastTimer = null;
function showToast(text) {
  var toast = document.getElementById('uh-toast');
  if (!toast) return;
  toast.textContent = text;
  toast.classList.add('uh-toast-show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(function () {
    toast.classList.remove('uh-toast-show');
  }, 2000);
}

var discordBtn = document.getElementById('uh-discord-btn');
var websiteBtn = document.getElementById('uh-website-btn');
if (discordBtn) {
  discordBtn.href = CONFIG.discordUrl;
  discordBtn.addEventListener('click', function (e) { copyLink(e, CONFIG.discordUrl, 'لینک دیسکورد'); });
}
if (websiteBtn) {
  websiteBtn.href = CONFIG.websiteUrl;
  websiteBtn.addEventListener('click', function (e) { copyLink(e, CONFIG.websiteUrl, 'لینک سایت'); });
}

// اسم خوانا برای هر جاب که تو تول‌تیپ نمایش داده می‌شه
var JOB_LABELS = {
  cid: 'CID', cia: 'CIA', marshal: 'Marshal', fbi: 'FBI', judge: 'Judge', doa: 'DOA',
  police: 'Police', sheriff: 'Sheriff', mt: 'MT',
  taxi: 'Taxi', mechanic: 'Mechanic', ambulance: 'Medic', weazel: 'Weazel',
};

var grid = document.getElementById('uh-grid');
function buildGrid() {
  grid.innerHTML = '';
  CARDS.forEach(function (card) {
    var div = document.createElement('div');
    div.className = 'uh-card';
    div.id = 'uh-card-' + card.label.toLowerCase().replace(/\s+/g, '-');

    var tooltipHtml = '<div class="uh-tooltip"><div class="uh-tt-title">' + card.label + '</div>';
    if (card.isAdmins) {
      tooltipHtml += '<div class="uh-tt-list"></div>';
    } else {
      tooltipHtml += card.jobs.map(function (jobKey) {
        return '<div class="uh-tt-row"><span>' + (JOB_LABELS[jobKey] || jobKey) + '</span><b data-job="' + jobKey + '">0</b></div>';
      }).join('');
    }
    tooltipHtml += '</div>';

    div.innerHTML =
      '<div class="uh-icon"><img src="' + card.icon + '" alt=""></div>' +
      '<div class="uh-label">' + card.label + '</div>' +
      '<div class="uh-value">0</div>' +
      tooltipHtml;
    div.addEventListener('click', function () {
      div.classList.toggle('uh-active');
    });
    grid.appendChild(div);
  });
}
buildGrid();

function renderScoreboard(data) {
  var playersEl = document.getElementById('uh-players-num');
  if (playersEl) playersEl.textContent = data.total || 0;

  var admins = data.admins || [];

  CARDS.forEach(function (card) {
    var id = 'uh-card-' + card.label.toLowerCase().replace(/\s+/g, '-');
    var el = document.getElementById(id);
    if (!el) return;

    var count;
    if (card.isAdmins) {
      count = admins.length;
      var listEl = el.querySelector('.uh-tt-list');
      if (listEl) {
        if (admins.length === 0) {
          listEl.innerHTML = '<div class="uh-tt-empty">کسی آنلاین نیست</div>';
        } else {
          listEl.innerHTML = admins.map(function (a) {
            return '<div class="uh-tt-row"><span>' + a.name + '</span><b>Lv ' + a.level + '</b></div>';
          }).join('');
        }
      }
    } else {
      count = 0;
      card.jobs.forEach(function (jobKey) {
        var jobCount = (data.jobs && data.jobs[jobKey]) || 0;
        count += jobCount;
        var rowEl = el.querySelector('[data-job="' + jobKey + '"]');
        if (rowEl) rowEl.textContent = jobCount;
      });
    }
    el.querySelector('.uh-value').textContent = count;
  });
}

// ---------- ساعت (زمان سیستم) ----------
function updateClock() {
  var el = document.getElementById('uh-clock');
  if (!el) return;
  var now = new Date();
  var h = now.getHours();
  var m = now.getMinutes();
  var ampm = h >= 12 ? 'PM' : 'AM';
  h = h % 12; if (h === 0) h = 12;
  el.textContent = h + ':' + String(m).padStart(2, '0') + ' ' + ampm;
}
updateClock();
setInterval(updateClock, 30000);

// ---------- تم روشن/تاریک ----------
function toggleTheme() {
  var html = document.documentElement;
  var isDark = html.getAttribute('data-theme') !== 'light';
  html.setAttribute('data-theme', isDark ? 'light' : 'dark');
  document.getElementById('uh-theme-label').textContent = isDark ? 'Light' : 'Dark';
}

// ---------- بستن پنل ----------
function requestClose() {
  window.parent.postMessage({ id: 'scoreboard', event: 'requestClose' }, '*');
}

// ✅ اضافه شد: بستن با ESC مستقیم از داخل همین فریم (قبلاً فقط تو
// index.html اصلی گوش داده می‌شد که چون اسکوربورد داخل iframe جداست،
// رویداد keyup بهش نمی‌رسید. الان مستقل عمل می‌کنه).
document.addEventListener('keyup', function (e) {
  if (e.key === 'Escape' || e.keyCode === 27) {
    var wrap = document.getElementById('uh-sb-wrap');
    if (wrap && wrap.classList.contains('uh-visible')) {
      requestClose();
    }
  }
});

window.addEventListener('message', function (event) {
  var item = event.data;
  if (!item || item.id !== 'scoreboard') return;

  if (item.event === 'toggle') {
    var wrap = document.getElementById('uh-sb-wrap');
    if (!wrap) return;
    if (item.open) {
      wrap.style.display = 'block';
      requestAnimationFrame(function () {
        wrap.classList.add('uh-visible');
      });
    } else {
      wrap.classList.remove('uh-visible');
      setTimeout(function () {
        wrap.style.display = 'none';
      }, 180);
    }
  } else if (item.event === 'update') {
    if (item.data) renderScoreboard(item.data);
  }
});
