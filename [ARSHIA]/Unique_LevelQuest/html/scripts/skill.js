function sortSkills(items) {
  if (!items || !Array.isArray(items)) return [];
  return [...items].sort((a, b) => {
    if (a.isCurrent !== b.isCurrent) return a.isCurrent ? -1 : 1;
    return (Number(b.value) || 0) - (Number(a.value) || 0);
  });
}

function tierFor(percent) {
  if (percent >= 100) return 'MASTER';
  if (percent >= 75) return 'VETERAN';
  if (percent >= 50) return 'EXPERIENCED';
  if (percent >= 25) return 'TRAINED';
  return 'ROOKIE';
}

// Same local job images used in the header badge (img/job/<jobname>.png).
// Not every job has one, so this test-loads before applying it.
function setSkillIcon(el, jobName) {
  if (!el || !jobName) return;
  const path = `img/job/${jobName}.png`;
  const test = new Image();
  test.onload = () => {
    el.style.backgroundImage = `url('${path}')`;
    el.classList.add('hasImage');
  };
  test.src = path;
}

// Same dedup approach as quest.js — skill rows re-render every menu
// open, so this stops an already-mastered skill from chiming again.
const chimedMasteredJobs = new Set();

document.addEventListener('DOMContentLoaded', () => {
  const skillList = document.querySelector('.skill-list');
  const skillSummary = document.querySelector('.skill-summary');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadSkills' && Array.isArray(data.skills)) {
      skillList.innerHTML = '';
      const sorted = sortSkills(data.skills);

      const totalHours = sorted.reduce((sum, s) => sum + (Number(s.hours) || 0), 0);
      const masteredCount = sorted.filter(s => (Number(s.value) || 0) >= 1).length;
      if (skillSummary) {
        skillSummary.innerHTML = `
          <span><i class="fa-solid fa-clock"></i> ${totalHours}h total on duty</span>
          <span><i class="fa-solid fa-medal"></i> ${masteredCount}/${sorted.length} mastered</span>
        `;
      }

      sorted.forEach(s => {
        const pct = Math.max(0, Math.min(100, (Number(s.value) || 0) * 100));
        const tier = tierFor(pct);
        const row = document.createElement('div');
        row.className = 'skillRow';
        if (s.isCurrent) row.classList.add('current');
        if (pct >= 100) {
          row.classList.add('mastered');
          if (!chimedMasteredJobs.has(s.jobName)) {
            chimedMasteredJobs.add(s.jobName);
            if (typeof playChime === 'function') playChime();
          }
        }

        row.innerHTML = `
          <div class="skillTop">
            <div class="skillIcon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="skillTitleBlock">
              <span class="skillTitle">${s.title}${s.isCurrent ? '<span class="dutyBadge">ON DUTY</span>' : ''}</span>
              <span class="skillTier">${tier}</span>
            </div>
            <span class="skillPct">${pct.toFixed(1)}%</span>
          </div>
          <div class="skillBar">
            <div class="skillFill" style="width:0%"></div>
          </div>
          <div class="skillHours">${s.hours ?? 0}h / ${s.targetHours ?? 0}h on duty</div>
        `;
        skillList.appendChild(row);

        setSkillIcon(row.querySelector('.skillIcon'), s.jobName);

        const fill = row.querySelector('.skillFill');
        requestAnimationFrame(() => { fill.style.width = `${pct}%`; });
      });
    }
  });
});
