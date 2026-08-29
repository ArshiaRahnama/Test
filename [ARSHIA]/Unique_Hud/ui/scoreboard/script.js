var sbPanel = document.getElementById('sb-panel');
var sbPlayers = document.getElementById('sb-players');
var sbJobs = document.getElementById('sb-jobs');
var sbGangs = document.getElementById('sb-gangs');
var sbRobs = document.getElementById('sb-robs');
var sbAdmins = document.getElementById('sb-admins');
var sbAdminCount = document.getElementById('sb-admin-count');

var jobLabels = {
  police: 'پلیس',
  fbi: 'اف‌بی‌آی',
  mt: 'مارشال',
  ambulance: 'آمبولانس',
  weazel: 'ویزل',
  mechanic: 'مکانیک',
  taxi: 'تاکسی',
};

var robLabels = {
  Shop: 'مغازه',
  Jewerlly: 'جواهرفروشی',
  Minibank: 'مینی‌بانک',
  Palateo_Bank: 'بانک',
  Life_Invader: 'لایف‌اینویدر',
};

function renderJobs(jobs) {
  sbJobs.innerHTML = '';
  Object.keys(jobLabels).forEach(function (key) {
    var count = jobs[key] || 0;
    var div = document.createElement('div');
    div.className = 'sb-chip';
    div.innerHTML = '<span class="sb-chip-label">' + jobLabels[key] + '</span><span class="sb-chip-value">' + count + '</span>';
    sbJobs.appendChild(div);
  });
}

function renderGangs(gangs) {
  sbGangs.innerHTML = '';
  if (!gangs || gangs.length === 0) {
    sbGangs.innerHTML = '<div class="sb-empty">هیچ عضو گنگی آنلاین نیست</div>';
    return;
  }
  gangs.sort(function (a, b) { return b.count - a.count; });
  gangs.forEach(function (g) {
    var div = document.createElement('div');
    div.className = 'sb-chip';
    div.innerHTML = '<span class="sb-chip-label">' + g.label + '</span><span class="sb-chip-value">' + g.count + '</span>';
    sbGangs.appendChild(div);
  });
}

function renderRobs(robs) {
  sbRobs.innerHTML = '';
  var keys = Object.keys(robLabels);
  var any = false;
  keys.forEach(function (key) {
    var info = robs[key];
    if (!info) return;
    any = true;
    var div = document.createElement('div');
    var beingRobbed = info.beingRobbed > 0;
    div.className = 'sb-chip ' + (beingRobbed ? 'robbing' : 'idle');
    var statusText = beingRobbed ? 'در حال دزدی' : 'آزاد';
    div.innerHTML = '<span class="sb-chip-label">' + robLabels[key] + '</span><span class="sb-chip-value">' + statusText + '</span>';
    sbRobs.appendChild(div);
  });
  if (!any) {
    sbRobs.innerHTML = '<div class="sb-empty">اطلاعاتی در دسترس نیست</div>';
  }
}

function renderAdmins(admins) {
  sbAdmins.innerHTML = '';
  sbAdminCount.textContent = admins.length;
  if (admins.length === 0) {
    sbAdmins.innerHTML = '<div class="sb-empty">ادمینی آنلاین نیست</div>';
    return;
  }
  admins.forEach(function (a) {
    var div = document.createElement('div');
    div.className = 'sb-admin-row';
    div.innerHTML = '<span>' + a.name + '</span><span>سطح ' + a.level + '</span>';
    sbAdmins.appendChild(div);
  });
}

window.addEventListener('message', function (event) {
  var item = event.data;
  if (!item || item.id !== 'scoreboard') return;

  if (item.event === 'toggle') {
    sbPanel.classList.toggle('visible', !!item.open);
  } else if (item.event === 'update') {
    var data = item.data;
    if (!data) return;
    sbPlayers.textContent = data.total + ' / ' + data.maxPlayers;
    renderJobs(data.jobs || {});
    renderGangs(data.gangs || []);
    renderRobs(data.robs || {});
    renderAdmins(data.admins || []);
  }
});
