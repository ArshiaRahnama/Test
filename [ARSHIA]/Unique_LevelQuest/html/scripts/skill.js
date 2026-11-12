function escapeHtml(v) {
  return String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

function createSkillUpSymbols() {
  const container = document.getElementById('skillUP');
  if (!container) return;
  const count = 10; // same amount as the original effect
  for (let i = 0; i < count; i++) {
    const symbol = document.createElement('span');
    symbol.className = 'skillUpSymbol';
    symbol.textContent = '+';
    symbol.style.left = Math.random() * (window.innerWidth - 30) + 'px';
    symbol.style.top = Math.random() * (window.innerHeight - 40) + 'px';
    container.appendChild(symbol);
    setTimeout(() => symbol.remove(), 2000);
  }
}

let skinOptions = null;
function skinPickerHtml(s) {
  if (!s.finished || !skinOptions) return '';
  const list = s.mk2 ? skinOptions.mk2 : skinOptions.standard;
  const names = Array.isArray(list) ? list : Object.keys(list).sort((a, b) => a - b).map(k => list[k]);
  const opts = names.map((n, i) => `<option value="${i}"${Number(s.skin) === i ? ' selected' : ''}>${escapeHtml(n)}</option>`).join('');
  return `<label class="wsSkin"><span>Skin</span><select data-weapon="${escapeHtml(s.weaponName)}">${opts}</select></label>`;
}

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

    if (data.type === 'skinOptions' && data.options) { skinOptions = data.options; return; }

    if (data.type === 'skillUp') { createSkillUpSymbols(); return; }

    if (data.type === 'loadActivitySkills' && Array.isArray(data.skills)) {
      const wbox = document.querySelector('.weapon-skill-list');
      if (!wbox) return;
      const frag = document.createDocumentFragment(); // one DOM write for ~50 rows
      data.skills.filter(s => s.weapon)
        .sort((a, b) => (b.finished - a.finished) || (b.percent - a.percent) || String(a.label).localeCompare(String(b.label)))
        .forEach(s => {
          const pct = Math.max(0, Math.min(100, Number(s.percent) || 0));
          const row = document.createElement('div');
          row.className = 'skillRow wsRow' + (s.finished ? ' mastered' : '');
          row.innerHTML = `
            <div class="skillTop">
              <span class="skillTitle">${escapeHtml(s.label)}</span>
              <span class="skillPct">${pct.toFixed(2)}%</span>
            </div>
            <div class="skillBar"><div class="skillFill" style="width:${pct}%"></div></div>
            ${skinPickerHtml(s)}`;
          const sel = row.querySelector('select');
          if (sel) sel.addEventListener('change', () => {
            fetch(`https://${GetParentResourceName()}/setWeaponSkin`, {
              method: 'POST', headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ weapon: sel.dataset.weapon, tint: Number(sel.value) }),
            });
          });
          frag.appendChild(row);
        });
      wbox.replaceChildren(frag);
      return;
    }

    if (data.type === 'loadSkills' && Array.isArray(data.skills)) {
      skillList.innerHTML = '';
      const sorted = sortSkills(data.skills);

      const totalHours = sorted.reduce((sum, s) => sum + (Number(s.hours) || 0), 0);
      const masteredCount = sorted.filter(s => (Number(s.value) || 0) >= 1).length;
      if (skillSummary) {
        skillSummary.innerHTML = `
          <div class="summaryChip">
            <i class="fa-solid fa-clock"></i>
            <div class="summaryChipText">
              <span class="summaryChipValue">${totalHours}h</span>
              <span class="summaryChipLabel">total on duty</span>
            </div>
          </div>
          <div class="summaryChip mastered">
            <i class="fa-solid fa-medal"></i>
            <div class="summaryChipText">
              <span class="summaryChipValue">${masteredCount}/${sorted.length}</span>
              <span class="summaryChipLabel">mastered</span>
            </div>
          </div>
        `;
      }

      sorted.forEach(s => {
        const pct = Math.max(0, Math.min(100, (Number(s.value) || 0) * 100));
        const tier = tierFor(pct);
        const tierClass = tier.toLowerCase();
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
          ${pct >= 100 ? '<div class="masteredRibbon"><i class="fa-solid fa-trophy"></i></div>' : ''}
          <div class="skillTop">
            <div class="skillIcon"><i class="fa-solid fa-briefcase"></i></div>
            <div class="skillTitleBlock">
              <span class="skillTitle">${escapeHtml(s.title)}${s.isCurrent ? '<span class="dutyBadge">ON DUTY</span>' : ''}</span>
              <span class="skillTier tier-${tierClass}">${tier}</span>
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
