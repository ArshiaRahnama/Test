document.addEventListener('DOMContentLoaded', () => {
  const dutyTabBtn = document.getElementById('dutyTabBtn');
  const summaryEl = document.querySelector('.duty-summary');
  const rosterEl = document.querySelector('.duty-roster');

  function formatDuration(totalSeconds) {
    const s = Math.max(0, Number(totalSeconds) || 0);
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    if (h <= 0) return `${m}m`;
    return `${h}h ${m}m`;
  }

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'loadDuty' || !data.duty) return;
    const duty = data.duty;

    if (!duty.isMember) {
      // Not (or no longer) an org member — the tab has no data to
      // show at all, so it stays out of the tab row entirely instead
      // of existing as a dead/empty option. If it happened to be the
      // active tab already (job left while the menu was open), fall
      // back to Quests rather than leaving an empty panel showing.
      if (dutyTabBtn.classList.contains('active')) {
        document.querySelector('.tab[data-tab="quests"]')?.click();
      }
      dutyTabBtn.classList.add('hidden');
      return;
    }

    dutyTabBtn.classList.remove('hidden');

    summaryEl.innerHTML = `
      <div class="dutyChip">
        <i class="fa-solid fa-sun"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.todaySeconds)}</span>
          <span class="dutyChipLabel">today</span>
        </div>
      </div>
      <div class="dutyChip">
        <i class="fa-solid fa-calendar-week"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.weekSeconds)}</span>
          <span class="dutyChipLabel">last 7 days</span>
        </div>
      </div>
      <div class="dutyChip highlight">
        <i class="fa-solid fa-infinity"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.allSeconds)}</span>
          <span class="dutyChipLabel">all-time</span>
        </div>
      </div>
    `;

    if (!duty.isLeadership || !Array.isArray(duty.roster)) {
      rosterEl.innerHTML = `
        <div class="dutyLeadershipHint">
          <i class="fa-solid fa-lock"></i>
          Team totals are visible to ${duty.orgName ? duty.orgName + ' ' : ''}leadership only.
        </div>
      `;
      return;
    }

    if (duty.roster.length === 0) {
      rosterEl.innerHTML = `<div class="dutyLeadershipHint"><i class="fa-solid fa-users"></i> No recorded duty time yet for this org.</div>`;
      return;
    }

    const medalIcons = ['🥇', '🥈', '🥉'];
    rosterEl.innerHTML = `
      <div class="dutyRosterTitle">${duty.orgName ? duty.orgName.toUpperCase() : 'ORG'} — ALL-TIME HOURS</div>
      <div class="dutyRosterList">
        ${duty.roster.map((r, i) => `
          <div class="dutyRosterRow${i < 3 ? ' top' + (i + 1) : ''}">
            <span class="dutyRosterRank">${medalIcons[i] || (i + 1)}</span>
            <span class="dutyRosterName">${(r.name || '').replace(/_/g, ' ')}</span>
            <span class="dutyRosterValue">${formatDuration(r.allSeconds)}</span>
          </div>
        `).join('')}
      </div>
    `;
  });
});
