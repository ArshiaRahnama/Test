document.addEventListener('DOMContentLoaded', () => {
  const lists = {
    players: document.getElementById('lb_players_list'),
    gangs: document.getElementById('lb_gangs_list'),
  };

  // ============================================================= //
  // PER JOB — landing view is a grid with every tracked job's #1
  // ("champion") at once; clicking a card drills into that job's full
  // top 10 + photo podium. One shared week/month toggle drives both.
  // ============================================================= //
  const gridEl     = document.getElementById('jobChampionsGrid');
  const detailEl   = document.getElementById('jobLbDetail');
  const podiumEl   = document.getElementById('jobLb_podium');
  const jobListEl  = document.getElementById('jobLb_list');
  const titleEl    = document.getElementById('jobLb_title');
  const backBtn    = document.getElementById('jobLbBackBtn');
  const periodBtns = document.querySelectorAll('.jobLbPeriodBtn');
  let currentPeriod = 'week';
  let selectedJob   = null; // null = grid view, else the job key currently drilled into
  let jobLabels     = {};   // filled from the 'trackedJobs' message

  // A little personality per job — purely cosmetic, falls back to a
  // generic briefcase for any job not listed here (so a job added to
  // Config.TrackedJobs later never breaks, it just gets the default).
  const JOB_ICONS = {
    police: 'fa-shield-halved', sheriff: 'fa-star', mt: 'fa-city',
    marshal: 'fa-gavel', judge: 'fa-scale-balanced', doa: 'fa-file-signature',
    cid: 'fa-user-secret', cia: 'fa-eye', fbi: 'fa-user-shield',
    taxi: 'fa-taxi', mechanic: 'fa-wrench', ambulance: 'fa-truck-medical',
    weazel: 'fa-car-side',
  };

  function showGrid() {
    selectedJob = null;
    if (gridEl) gridEl.classList.remove('hidden');
    if (detailEl) detailEl.classList.add('hidden');
    requestJobChampions();
  }

  function showDetail(jobKey) {
    selectedJob = jobKey;
    if (gridEl) gridEl.classList.add('hidden');
    if (detailEl) detailEl.classList.remove('hidden');
    requestJobLeaderboard(jobKey);
  }

  function requestJobChampions() {
    if (typeof postNui === 'function') {
      postNui('jobChampionsRequest', { period: currentPeriod });
    }
  }

  function requestJobLeaderboard(jobKey) {
    if (typeof postNui === 'function') {
      postNui('jobLeaderboardRequest', { job: jobKey, period: currentPeriod });
    }
  }

  if (backBtn) backBtn.addEventListener('click', showGrid);

  periodBtns.forEach(btn => {
    btn.addEventListener('click', function () {
      periodBtns.forEach(b => b.classList.remove('active'));
      this.classList.add('active');
      currentPeriod = this.dataset.period;
      if (selectedJob) {
        requestJobLeaderboard(selectedJob);
      } else {
        requestJobChampions();
      }
    });
  });

  window.addEventListener('message', (event) => {
    const data = event.data;

    // Just caches labels + kicks off the very first grid load — the
    // grid itself is rebuilt fresh every time 'loadJobChampions' comes
    // back, never built off this message directly.
    if (data.type === 'trackedJobs' && data.jobs) {
      jobLabels = data.jobs;
      requestJobChampions();
      return;
    }

    if (data.type === 'loadJobChampions') {
      if (!gridEl) return;
      // Stale reply for a period the user has since switched away
      // from, or arriving while a job's detail view is open — drop it.
      if (data.period !== currentPeriod || selectedJob) return;

      gridEl.innerHTML = '';
      Object.keys(data.champions || {}).forEach(jobKey => {
        const champ = data.champions[jobKey];
        const icon = JOB_ICONS[jobKey] || 'fa-briefcase';

        const card = document.createElement('button');
        card.type = 'button';
        card.className = 'champCard';

        const avatarHtml = champ.hasData
          ? (champ.avatarUrl
              ? `<div class="champAvatar hasImage" style="background-image:url('${champ.avatarUrl}')"></div>`
              : `<div class="champAvatar"><i class="fa-solid fa-user"></i></div>`)
          : `<div class="champAvatar champEmpty"><i class="fa-solid fa-question"></i></div>`;

        card.innerHTML = `
          <div class="champJobRow"><i class="fa-solid ${icon}"></i><span>${champ.label}</span></div>
          ${avatarHtml}
          <div class="champName">${champ.hasData ? champ.name : 'کسی هنوز نیست'}</div>
          <div class="champTime">${champ.hasData ? `${champ.hours}h ${champ.minutes}m` : '—'}</div>
        `;
        card.addEventListener('click', () => showDetail(jobKey));
        gridEl.appendChild(card);
      });
      return;
    }

    if (data.type === 'loadJobLeaderboard') {
      if (!podiumEl || !jobListEl) return;
      // Stale response for a job/period the user has since navigated
      // away from (clicked a card, changed period, or hit back before
      // the server replied) — drop it rather than flash the wrong
      // board for a frame.
      if (data.job !== selectedJob || data.period !== currentPeriod) return;

      if (titleEl) {
        titleEl.textContent = `${data.jobLabel || jobLabels[data.job] || ''} — ${currentPeriod === 'month' ? 'این ماه' : 'این هفته'}`;
      }

      const entries = Array.isArray(data.entries) ? data.entries : [];
      const top3 = entries.slice(0, 3);
      const rest = entries.slice(3);

      podiumEl.innerHTML = '';
      if (top3.length === 0) {
        podiumEl.innerHTML = `<div class="jobLbEmpty">هنوز کسی برای این بازه ثبت نشده</div>`;
      }
      // Rendered center/left/right (2nd, 1st, 3rd) via CSS order, so
      // the #1 podium spot is visually tallest/centered like a
      // real podium, while DOM order stays rank-sorted.
      top3.forEach(entry => {
        const spot = document.createElement('div');
        spot.className = `podiumSpot podium${entry.position}`;
        const avatarHtml = entry.avatarUrl
          ? `<div class="podiumAvatar hasImage" style="background-image:url('${entry.avatarUrl}')"></div>`
          : `<div class="podiumAvatar"><i class="fa-solid fa-user"></i></div>`;
        spot.innerHTML = `
          <div class="podiumRank">#${entry.position}</div>
          ${avatarHtml}
          <div class="podiumName">${entry.name}</div>
          <div class="podiumTime">${entry.hours}h ${entry.minutes}m</div>
        `;
        podiumEl.appendChild(spot);
      });

      jobListEl.innerHTML = '';
      rest.forEach(entry => {
        const row = document.createElement('div');
        row.className = 'boardRow';
        row.innerHTML = `
          <span class="boardPos">#${entry.position}</span>
          <span class="boardName">${entry.name}</span>
          <div class="boardStats">
            <span class="boardChip"><i class="fa-solid fa-clock"></i>${entry.hours}h ${entry.minutes}m</span>
          </div>
        `;
        jobListEl.appendChild(row);
      });
      return;
    }

    // ============================================================= //
    // GANG WATCH — top 5 gangs by member community-service this month.
    // Rank icon escalates (warning → fire → skull for #1) and a
    // severity bar shows each gang's count relative to the worst
    // offender, so the scale of the gap is visible at a glance, not
    // just the raw numbers.
    // ============================================================= //
    if (data.type === 'loadGangWatch') {
      const gwList = document.getElementById('lb_gangwatch_list');
      if (!gwList) return;
      gwList.innerHTML = '';
      const entries = Array.isArray(data.entries) ? data.entries : [];
      if (entries.length === 0) {
        gwList.innerHTML = `<div class="jobLbEmpty">این ماه هیچ گنگی کامیونیتی‌سرویس نخورده</div>`;
        return;
      }
      const maxCount = entries[0].count || 1;
      const RANK_ICON = { 1: 'fa-skull', 2: 'fa-fire', 3: 'fa-fire' };

      entries.forEach(entry => {
        const row = document.createElement('div');
        row.className = `gwRow gwRank${entry.position}`;
        const logoHtml = entry.logoUrl
          ? `<div class="gwLogo hasImage" style="background-image:url('${entry.logoUrl}')"></div>`
          : `<div class="gwLogo"><i class="fa-solid fa-people-group"></i></div>`;
        const rankIcon = RANK_ICON[entry.position] || 'fa-triangle-exclamation';
        const pct = Math.max(6, Math.round((entry.count / maxCount) * 100));

        row.innerHTML = `
          <div class="gwRank"><i class="fa-solid ${rankIcon}"></i>#${entry.position}</div>
          ${logoHtml}
          <div class="gwInfo">
            <div class="gwName">${entry.name}</div>
            <div class="gwBarTrack"><div class="gwBarFill" style="width:${pct}%"></div></div>
          </div>
          <div class="gwCount"><i class="fa-solid fa-handcuffs"></i>${entry.count}</div>
        `;
        gwList.appendChild(row);
      });
      return;
    }

    if (data.type !== 'loadLeaderboard' || !Array.isArray(data.entries)) return;

    const list = lists[data.board];
    if (!list) return;

    list.innerHTML = '';
    data.entries.forEach(entry => {
      const row = document.createElement('div');
      row.className = 'boardRow';
      if (entry.position <= 3) row.classList.add(`top${entry.position}`);

      let statsHtml;
      let avatarHtml = '';
      if (data.board === 'gangs') {
        statsHtml = `
          <span class="boardChip"><i class="fa-solid fa-bolt"></i>${entry.xp} XP</span>
          <span class="boardChip"><i class="fa-solid fa-star"></i>Rank ${entry.rank}</span>
        `;
      } else {
        statsHtml = `
          <span class="boardChip"><i class="fa-solid fa-star"></i>Lvl ${entry.rank}</span>
          <span class="boardChip"><i class="fa-solid fa-bolt"></i>${entry.xp} XP</span>
          <span class="boardChip"><i class="fa-solid fa-coins"></i>${entry.coin}</span>
          <span class="boardChip"><i class="fa-solid fa-clock"></i>${entry.hours}h</span>
        `;
        if (entry.tier) {
          avatarHtml = `<div class="rareAvatar tier${entry.tier}"><i class="fa-solid fa-user"></i></div>`;
        }
      }

      row.innerHTML = `
        <span class="boardPos">#${entry.position}</span>
        ${avatarHtml}
        <span class="boardName">${entry.name}</span>
        <div class="boardStats">${statsHtml}</div>
      `;

      if (data.board === 'players') {
        row.classList.add('clickable');
        row.addEventListener('click', () => {
          if (typeof requestCompare === 'function') requestCompare(entry.name);
        });
      }

      list.appendChild(row);
    });
  });
});
