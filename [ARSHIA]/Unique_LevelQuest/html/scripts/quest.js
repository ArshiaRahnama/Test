function ringColorFor(percentage) {
  if (percentage >= 100) return '#1fd34b'; // complete - green
  if (percentage >= 70) return '#ff8c1a';  // orange
  if (percentage >= 30) return '#ffc56d';  // amber
  return '#6b6b72';                        // muted - just started
}

// Cards re-render every time the menu opens, so without this an
// already-completed quest would chime again on every open — this Set
// persists for the life of the NUI page (i.e. across open/close) and
// only allows one chime per quest id.
const chimedQuestIds = new Set();

function animateQuestRing(ringElement, fracElement, questId, current, required, duration = 900) {
  if (!ringElement) return;

  const targetPercentage = required > 0 ? Math.min(100, (current / required) * 100) : 0;
  const startTime = performance.now();

  const updateFrame = (now) => {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const percent = targetPercentage * progress;

    ringElement.style.setProperty('--deg', `${(percent * 3.6).toFixed(2)}deg`);
    ringElement.style.setProperty('--ringColor', ringColorFor(percent));

    if (progress < 1) requestAnimationFrame(updateFrame);
    else if (percent >= 100) {
      ringElement.classList.add('complete');
      if (!chimedQuestIds.has(questId)) {
        chimedQuestIds.add(questId);
        if (typeof playChime === 'function') playChime();
      }
    }
  };

  requestAnimationFrame(updateFrame);
  if (fracElement) fracElement.textContent = `${current}/${required}`;
}

document.addEventListener('DOMContentLoaded', () => {
  const questsGrid = document.querySelector('.quests-grid');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadQuests' && Array.isArray(data.quests)) {
      questsGrid.innerHTML = '';

      data.quests.forEach(quest => {
        const required = quest.required ?? 1;
        const current = Math.min(quest.current ?? 0, required);

        const card = document.createElement('div');
        card.className = 'achCard';
        card.innerHTML = `
          <div class="ring" id="ring-${quest.id}" style="--deg:0deg; --ringColor:#6b6b72;">
            <div class="ringText" id="frac-${quest.id}">0/${required}</div>
          </div>
          <div class="achTitle">${quest.title}</div>
          <div class="achDesc">${quest.description}</div>
          <div class="achReward">
            ${quest.xp ? `<span class="rewardChip xpChip"><i class="fa-solid fa-bolt"></i>${quest.xp}</span>` : ''}
            ${quest.coin ? `<span class="rewardChip coinChip"><span class="coin"></span>${quest.coin}</span>` : ''}
          </div>
        `;
        questsGrid.appendChild(card);

        const ring = card.querySelector(`#ring-${quest.id}`);
        const frac = card.querySelector(`#frac-${quest.id}`);
        animateQuestRing(ring, frac, quest.id, current, required);
      });
    }
  });
});
