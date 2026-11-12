(function () {
  const esc = (v) => String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const res = () => (window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource');

  function renderAchievements(list, points) {
    const sum = document.querySelector('.ach-summary');
    const box = document.querySelector('.ach-list');
    if (!sum || !box) return;
    const done = list.filter(a => a.completed).length;
    sum.innerHTML = `
      <div class="summaryChip"><i class="fa-solid fa-star"></i><div class="summaryChipText">
        <span class="summaryChipValue">${Number(points) || 0}</span><span class="summaryChipLabel">points</span></div></div>
      <div class="summaryChip mastered"><i class="fa-solid fa-award"></i><div class="summaryChipText">
        <span class="summaryChipValue">${done}/${list.length}</span><span class="summaryChipLabel">unlocked</span></div></div>`;
    box.innerHTML = '';
    list.forEach(a => {
      const pct = a.max > 0 ? Math.min(100, (a.progress / a.max) * 100) : 0;
      const row = document.createElement('div');
      row.className = 'achRow' + (a.completed ? ' done' : '') + (a.hidden ? ' secret' : '');
      row.innerHTML = `
        <div class="achIcon"><i class="fa-solid ${a.completed ? 'fa-trophy' : 'fa-lock'}"></i></div>
        <div class="achBody">
          <span class="achTitle">${esc(a.label)}</span>
          <span class="achDesc">${esc(a.description)}</span>
          ${a.max > 1 ? `<div class="skillBar"><div class="skillFill" style="width:${pct}%"></div></div>` : ''}
        </div>
        <span class="achPoint">${a.point ? '+' + esc(a.point) : ''}</span>`;
      box.appendChild(row);
    });
  }

  function closeProfile() {
    const m = document.getElementById('profileModal');
    if (!m || m.hidden) return;
    m.hidden = true;
    fetch(`https://${res()}/profileClosed`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: '{}' });
  }

  function showProfile(p) {
    const m = document.getElementById('profileModal');
    if (!m) return;
    const pct = p.xpNeeded > 0 ? Math.min(100, (p.xp / p.xpNeeded) * 100) : 0;
    const skills = (p.skills || []).slice(0, 6).map(s => `
      <div class="pmSkill"><span>${esc(s.label)}</span><span>${Number(s.percent).toFixed(1)}%</span>
        <div class="skillBar"><div class="skillFill" style="width:${Math.min(100, s.percent)}%"></div></div></div>`).join('');
    m.innerHTML = `
      <div class="pmCard" role="dialog" aria-modal="true">
        <button class="pmClose" aria-label="Close">&times;</button>
        <div class="pmName">${esc(p.name)} <small>#${esc(p.id)}</small></div>
        <div class="pmJob">${esc(p.job)}</div>
        <div class="pmLevel">Level ${esc(p.level)}</div>
        <div class="skillBar"><div class="skillFill" style="width:${pct}%"></div></div>
        <div class="pmStats"><span>${esc(p.points)} pts</span><span>${esc(p.achievements)} achievements</span></div>
        ${skills ? `<div class="pmSkills">${skills}</div>` : ''}
      </div>`;
    m.hidden = false;
    m.querySelector('.pmClose').addEventListener('click', closeProfile);
  }

  window.addEventListener('message', (e) => {
    const d = e.data || {};
    if (d.type === 'loadAchievements' && Array.isArray(d.achievements)) renderAchievements(d.achievements, d.points);
    if (d.type === 'showProfile' && d.profile) showProfile(d.profile);
  });

  document.addEventListener('keydown', (e) => {
    const m = document.getElementById('profileModal');
    if (m && !m.hidden && (e.key === 'Escape' || e.key === 'Backspace')) { e.stopPropagation(); closeProfile(); }
  }, true);
  document.addEventListener('click', (e) => { if (e.target && e.target.id === 'profileModal') closeProfile(); });
})();

(function () {
  const esc = (v) => String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  window.addEventListener('message', (e) => {
    const d = e.data || {};
    if (d.type !== 'loadWeekly' || !Array.isArray(d.quests)) return;
    const box = document.querySelector('.weekly-list');
    const head = document.querySelector('.weekly-title');
    if (!box || !head) return;
    head.classList.toggle('hidden', d.quests.length === 0);
    const days = Math.floor(d.resetIn / 86400), hrs = Math.floor((d.resetIn % 86400) / 3600);
    head.querySelector('.weekly-reset').textContent = `resets in ${days}d ${hrs}h`;
    box.innerHTML = '';
    d.quests.forEach(q => {
      const pct = q.required > 0 ? Math.min(100, (q.progress / q.required) * 100) : 0;
      const row = document.createElement('div');
      row.className = 'achRow weeklyRow' + (q.done ? ' done' : '');
      row.style.opacity = 1;
      row.innerHTML = `
        <div class="achIcon"><i class="fa-solid ${q.done ? 'fa-circle-check' : 'fa-calendar-week'}"></i></div>
        <div class="achBody">
          <span class="achTitle">${esc(q.name)}</span>
          <span class="achDesc">${esc(q.description)} — ${esc(q.progress)}/${esc(q.required)}</span>
          <div class="skillBar"><div class="skillFill" style="width:${pct}%"></div></div>
        </div>
        <span class="achPoint">+${esc(q.XP)} XP<br>+${esc(q.coin)} C</span>`;
      box.appendChild(row);
    });
  });
})();
