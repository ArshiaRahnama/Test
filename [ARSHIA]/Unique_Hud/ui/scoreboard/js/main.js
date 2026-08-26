// ============================================================
// Unique_Hud / ui / scoreboard / js / main.js
// ============================================================

var jobKeys = ['police', 'mt', 'ambulance', 'mechanic', 'taxi', 'weazel', 'fbi'];

var robMap = {
  shop: 'Shop',
  Bank: 'Palateo_Bank',
  Minibank: 'Minibank',
  jewelery: 'Jewerlly',
};
var robLabels = {
  shop: 'مغازه',
  Bank: 'بانک',
  SheriffBank: 'بانک شریف',
  Cargo: 'کارگو',
  Bimeh: 'بیمه',
  jewelery: 'جواهرفروشی',
  Feleca: 'فلیکا بانک',
  Minibank: 'مینی‌بانک',
  JewelerySheriff: 'جواهرفروشی شریف',
  mythic: 'میتیک',
};

var latestRobData = {};

function updateClock() {
  var now = new Date();
  var h = now.getHours().toString().padStart(2, '0');
  var m = now.getMinutes().toString().padStart(2, '0');
  $('#Clock').text(h + ':' + m);
}
setInterval(updateClock, 1000);
updateClock();

function setJobSwitch(key, count) {
  var input = $('#' + key + '_input');
  var label = $('#' + key + '_switch');
  label.attr('data-on', '+' + count);
  input.prop('checked', count > 0);
}

function renderScoreboard(data) {
  $('#playersnum').text(data.total);

  jobKeys.forEach(function (key) {
    setJobSwitch(key, (data.jobs && data.jobs[key]) || 0);
  });

  var adminCount = (data.admins && data.admins.length) || 0;
  setJobSwitch('admins', adminCount);

  latestRobData = data.robs || {};

  Object.keys(robMap).forEach(function (htmlId) {
    var realType = robMap[htmlId];
    var info = latestRobData[realType];
    var el = document.getElementById(htmlId);
    if (!el) return;

    el.classList.remove(htmlId + '_active', htmlId + '_down');

    if (info) {
      if (info.beingRobbed > 0) {
        el.classList.add(htmlId + '_down');
      } else if (info.active > 0) {
        el.classList.add(htmlId + '_active');
      }
    }
  });
}

var unmappedRobIds = ['SheriffBank', 'Cargo', 'Bimeh', 'Feleca', 'JewelerySheriff', 'mythic'];

function robclick(htmlId) {
  $('#second_container').css('display', 'flex');

  if (unmappedRobIds.indexOf(htmlId) !== -1) {
    $('#Info_Text').text(robLabels[htmlId] + ': این مکان تو سیستم دزدی فعلی سرور تعریف نشده.');
    $('#Timer_Hour').text('--');
    $('#Timer_Minutes').text('--');
    $('#Timer_Seconds').text('--');
    return;
  }

  var realType = robMap[htmlId];
  var info = latestRobData[realType];

  if (!info) {
    $('#Info_Text').text(robLabels[htmlId] + ': اطلاعاتی در دسترس نیست.');
    $('#Timer_Hour').text('--');
    $('#Timer_Minutes').text('--');
    $('#Timer_Seconds').text('--');
    return;
  }

  if (info.beingRobbed > 0) {
    $('#Info_Text').text(robLabels[htmlId] + ': در حال حاضر در حال دزدیه.');
    $('#Timer_Hour').text('--');
    $('#Timer_Minutes').text('--');
    $('#Timer_Seconds').text('--');
  } else if (info.active > 0) {
    $('#Info_Text').text(robLabels[htmlId] + ': الان آزاد و قابل دزدیه.');
    $('#Timer_Hour').text('00');
    $('#Timer_Minutes').text('00');
    $('#Timer_Seconds').text('00');
  } else {
    var secondsLeft = info.secondsUntilAvailable || 0;
    var hh = Math.floor(secondsLeft / 3600);
    var mm = Math.floor((secondsLeft % 3600) / 60);
    var ss = secondsLeft % 60;
    $('#Info_Text').text(robLabels[htmlId] + ': در کول‌داون، تا آزاد شدن:');
    $('#Timer_Hour').text(hh.toString().padStart(2, '0'));
    $('#Timer_Minutes').text(mm.toString().padStart(2, '0'));
    $('#Timer_Seconds').text(ss.toString().padStart(2, '0'));
  }
}

function requestRefresh() {
  window.parent.postMessage({ id: 'scoreboard', event: 'requestRefresh' }, '*');
}

window.addEventListener('message', function (event) {
  var item = event.data;
  if (!item || item.id !== 'scoreboard') return;

  if (item.event === 'toggle') {
    if (item.open) {
      $('#wrap').css('display', 'block');
    } else {
      $('#wrap').css('display', 'none');
      $('#second_container').css('display', 'none');
    }
  } else if (item.event === 'update') {
    if (item.data) renderScoreboard(item.data);
  }
});
