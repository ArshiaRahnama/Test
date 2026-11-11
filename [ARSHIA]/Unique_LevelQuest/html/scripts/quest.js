function ringColorFor(percentage) {
  if (percentage >= 100) return '#1fd34b'; // complete - green
  if (percentage >= 70) return '#7c3aed';  // orange
  if (percentage >= 30) return '#a78bfa';  // amber
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

const qEsc = (v) => String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

function postNui(endpoint, body) {
  const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
  fetch(`https://${resourceName}/${endpoint}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const questsGrid = document.querySelector('.quests-grid');
  const summaryEl = document.querySelector('.quests-summary');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadQuests' && Array.isArray(data.quests)) {
      const maxActive = data.maxActive ?? 6;
      const canAccept = data.canAccept !== false;
      const choices = Array.isArray(data.choices) && data.choices.length ? data.choices : null;
      const activeCount = data.quests.filter(q => q.accepted && !q.completed).length;
      const completedCount = data.quests.filter(q => q.completed).length;

      if (summaryEl) {
        const full = activeCount >= maxActive;
        summaryEl.innerHTML = `
          <div class="questSlotChip${full ? ' full' : ''}">
            <i class="fa-solid fa-list-check"></i>
            <span>${activeCount}/${maxActive} active slots</span>
          </div>
          <div class="questSlotChip done">
            <i class="fa-solid fa-check-double"></i>
            <span>${completedCount} completed today</span>
          </div>
        `;
      }

      questsGrid.innerHTML = '';

      data.quests.forEach(quest => {
        const required = quest.required ?? 1;
        const current = Math.min(quest.current ?? 0, required);

        const card = document.createElement('div');
        card.className = 'achCard';
        if (quest.completed) card.classList.add('is-completed');
        else if (quest.accepted) card.classList.add('is-active');
        else card.classList.add('is-available');

        // At the slot cap, grey out Accept on every quest that isn't
        // already active — matches the server, which rejects Accept once
        // activeCount >= Config.MaxActiveQuests anyway; this just avoids
        // a pointless click + "slots full" notification round trip.
        const slotsFull = activeCount >= maxActive;

        let actionHtml = '';
        if (quest.completed && quest.pending && choices) {
          if (canAccept) {
            actionHtml = '<div class="claimRow">' + choices.map((c, i) => {
              const xp = Math.round((quest.xp || 0) * (c.xpMul ?? 1));
              const coin = Math.round((quest.coin || 0) * (c.coinMul ?? 1) * 100) / 100;
              return `<button type="button" class="questBtn claimBtn" data-id="${qEsc(quest.id)}" data-opt="${i + 1}"><i class="fa-solid fa-gift"></i> ${qEsc(c.label)}<small>${xp} XP · ${coin} C</small></button>`;
            }).join('') + '</div>';
          } else {
            actionHtml = `<div class="questDoneBadge"><i class="fa-solid fa-gift"></i> Claim at the quest giver</div>`;
          }
        } else if (quest.completed) {
          actionHtml = `<div class="questDoneBadge"><i class="fa-solid fa-circle-check"></i> Completed</div>`;
        } else if (quest.accepted) {
          actionHtml = `<button type="button" class="questBtn cancelBtn" data-id="${qEsc(quest.id)}"><i class="fa-solid fa-xmark"></i> Cancel</button>`;
        } else if (!canAccept) {
          actionHtml = `<div class="questDoneBadge npcHint"><i class="fa-solid fa-location-dot"></i> Accept at the quest giver</div>`;
        } else if (slotsFull) {
          actionHtml = `<button type="button" class="questBtn lockedBtn" disabled title="Finish or cancel your current quest first"><i class="fa-solid fa-lock"></i> Locked</button>`;
        } else {
          actionHtml = `<button type="button" class="questBtn acceptBtn" data-id="${qEsc(quest.id)}"><i class="fa-solid fa-plus"></i> Accept</button>`;
        }

        card.innerHTML = `
          <div class="ring" id="ring-${quest.id}" style="--deg:0deg; --ringColor:#6b6b72;">
            <div class="ringText" id="frac-${quest.id}">${quest.accepted ? '0' : '—'}/${required}</div>
          </div>
          <div class="achTitle">${qEsc(quest.title)}</div>
          <div class="achDesc">${qEsc(quest.description)}</div>
          <div class="achReward">
            ${quest.xp ? `<span class="rewardChip xpChip"><i class="fa-solid fa-bolt"></i>${quest.xp}</span>` : ''}
            ${quest.coin ? `<span class="rewardChip coinChip"><span class="coin"></span>${quest.coin}</span>` : ''}
          </div>
          ${actionHtml}
        `;
        questsGrid.appendChild(card);

        if (quest.accepted) {
          const ring = card.querySelector(`#ring-${quest.id}`);
          const frac = card.querySelector(`#frac-${quest.id}`);
          animateQuestRing(ring, frac, quest.id, current, required);
        }

        const acceptBtn = card.querySelector('.acceptBtn');
        if (acceptBtn) {
          acceptBtn.addEventListener('click', () => {
            acceptBtn.disabled = true;
            acceptBtn.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>`;
            postNui('acceptQuest', { id: quest.id });
          });
        }

        card.querySelectorAll('.claimBtn').forEach(btn => {
          btn.addEventListener('click', () => {
            card.querySelectorAll('.claimBtn').forEach(b => { b.disabled = true; });
            btn.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>`;
            postNui('claimReward', { id: quest.id, option: Number(btn.dataset.opt) });
          });
        });

        const cancelBtn = card.querySelector('.cancelBtn');
        if (cancelBtn) {
          cancelBtn.addEventListener('click', () => {
            cancelBtn.disabled = true;
            cancelBtn.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>`;
            postNui('cancelQuest', { id: quest.id });
          });
        }
      });
    }
  });
});
