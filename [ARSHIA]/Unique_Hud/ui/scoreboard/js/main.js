// ============================================================
// Unique_Hud / ui / scoreboard / js / main.js
// ============================================================

var organizations = [
  {
    key: 'doj',
    label: 'Department Of Justice',
    jobs: [
      { key: 'cid', label: 'CID' },
      { key: 'cia', label: 'CIA' },
      { key: 'marshal', label: 'Marshal' },
      { key: 'fbi', label: 'FBI' },
      { key: 'judge', label: 'Judge' },
      { key: 'doa', label: 'DOA' },
    ],
  },
  {
    key: 'law',
    label: 'Law Enforcement',
    jobs: [
      { key: 'police', label: 'Police' },
      { key: 'sheriff', label: 'Sheriff' },
      { key: 'mt', label: 'MT' },
    ],
  },
  {
    key: 'organ',
    label: 'Organ Services',
    jobs: [
      { key: 'taxi', label: 'Taxi' },
      { key: 'mechanic', label: 'Mechanic' },
      { key: 'ambulance', label: 'Medic' },
      { key: 'weazel', label: 'Weazel' },
    ],
  },
];

function buildOrgList() {
  var container = document.getElementById('org-list');
  container.innerHTML = '';

  organizations.forEach(function (org) {
    var card = document.createElement('div');
    card.className = 'org-card';
    card.id = 'org-' + org.key;

    var header = document.createElement('div');
    header.className = 'org-header';
    header.innerHTML =
      '<span class="org-title">' + org.label + '</span>' +
      '<span><span class="org-count" id="org-count-' + org.key + '">0</span>' +
      '<span class="org-arrow">▶</span></span>';
    header.addEventListener('click', function () {
      card.classList.toggle('expanded');
    });

    var jobsWrap = document.createElement('div');
    jobsWrap.className = 'org-jobs';

    org.jobs.forEach(function (job) {
      var row = document.createElement('div');
      row.className = 'org-job-row';
      row.id = 'jobrow-' + job.key;
      row.innerHTML = '<span>' + job.label + '</span><span class="count-badge" id="jobcount-' + job.key + '">0</span>';
      jobsWrap.appendChild(row);
    });

    card.appendChild(header);
    card.appendChild(jobsWrap);
    container.appendChild(card);
  });
}

function renderScoreboard(data) {
  $('#playersnum').text(data.total);

  organizations.forEach(function (org) {
    var orgTotal = 0;
    org.jobs.forEach(function (job) {
      var count = (data.jobs && data.jobs[job.key]) || 0;
      orgTotal += count;

      var badge = document.getElementById('jobcount-' + job.key);
      var row = document.getElementById('jobrow-' + job.key);
      if (badge) badge.textContent = count;
      if (row) row.classList.toggle('online', count > 0);
    });
    var orgCountEl = document.getElementById('org-count-' + org.key);
    if (orgCountEl) orgCountEl.textContent = orgTotal + ' آنلاین';
  });
}

window.addEventListener('message', function (event) {
  var item = event.data;
  if (!item || item.id !== 'scoreboard') return;

  if (item.event === 'toggle') {
    if (item.open) {
      $('#wrap').css('display', 'block');
    } else {
      $('#wrap').css('display', 'none');
    }
  } else if (item.event === 'update') {
    if (item.data) renderScoreboard(item.data);
  }
});

buildOrgList();
