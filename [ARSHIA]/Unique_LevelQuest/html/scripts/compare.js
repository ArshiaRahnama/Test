function requestCompare(playerName) {
  const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
  fetch(`https://${resourceName}/compareRequest`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ playerName }),
  });
}

function fillCompareColumn(prefix, stats) {
  const nameEl = document.getElementById(`compare${prefix}Name`);
  const levelEl = document.getElementById(`compare${prefix}Level`);
  const xpEl = document.getElementById(`compare${prefix}Xp`);
  const coinEl = document.getElementById(`compare${prefix}Coin`);
  const hoursEl = document.getElementById(`compare${prefix}Hours`);
  const avatarEl = document.getElementById(`compare${prefix}Avatar`);

  if (!stats) {
    if (nameEl) nameEl.textContent = 'Not found';
    [levelEl, xpEl, coinEl, hoursEl].forEach(el => { if (el) el.textContent = '-'; });
    if (avatarEl) avatarEl.classList.remove('tier1', 'tier2', 'tier3');
    return;
  }

  if (nameEl) nameEl.textContent = stats.name ?? '-';
  if (levelEl) levelEl.textContent = stats.level ?? '-';
  if (xpEl) xpEl.textContent = stats.xp ?? '-';
  if (coinEl) coinEl.textContent = stats.coin ?? '-';
  if (hoursEl) hoursEl.textContent = stats.hours !== undefined ? `${stats.hours}h` : '-';
  if (avatarEl) {
    avatarEl.classList.remove('tier1', 'tier2', 'tier3');
    if (stats.tier) avatarEl.classList.add(`tier${stats.tier}`);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const overlay = document.getElementById('compareOverlay');
  const closeBtn = document.getElementById('compareCloseBtn');

  if (closeBtn) {
    closeBtn.addEventListener('click', () => overlay.classList.add('hidden'));
  }
  if (overlay) {
    overlay.addEventListener('click', (e) => {
      if (e.target === overlay) overlay.classList.add('hidden');
    });
  }

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'compareResult') return;

    fillCompareColumn('You', window.__ownStats);
    fillCompareColumn('Them', data.stats);

    if (overlay) overlay.classList.remove('hidden');
  });
});
