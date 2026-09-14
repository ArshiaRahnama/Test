function formatRecordDate(raw) {
  if (!raw) return '';
  // Handles both a MySQL-style "YYYY-MM-DD HH:MM:SS" string and an
  // ISO string with a "T" separator — normalizes either into one
  // readable "YYYY-MM-DD HH:MM" form without needing a date library.
  return String(raw).replace('T', ' ').slice(0, 16);
}

const typeMeta = {
  jail: { label: 'Jail', icon: 'fa-lock' },
  community_service: { label: 'Community Service', icon: 'fa-broom' },
};

document.addEventListener('DOMContentLoaded', () => {
  const currentEl = document.querySelector('.record-current');
  const historyEl = document.querySelector('.record-history');

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'loadRecord' || !data.record) return;
    const record = data.record;

    // Current status
    const statusCards = [];
    if (record.currentJail) {
      statusCards.push(`
        <div class="recordStatusCard jail">
          <i class="fa-solid fa-lock"></i>
          <div class="recordStatusText">
            <span class="recordStatusTitle">Currently Jailed</span>
            <span class="recordStatusDetail">${record.currentJail.remainingMinutes}m remaining${record.currentJail.reason ? ' — ' + record.currentJail.reason : ''}</span>
          </div>
        </div>
      `);
    }
    if (record.currentCS) {
      statusCards.push(`
        <div class="recordStatusCard cs">
          <i class="fa-solid fa-broom"></i>
          <div class="recordStatusText">
            <span class="recordStatusTitle">Community Service</span>
            <span class="recordStatusDetail">${record.currentCS.remaining} action(s) left${record.currentCS.reason ? ' — ' + record.currentCS.reason : ''}</span>
          </div>
        </div>
      `);
    }
    if (statusCards.length === 0) {
      statusCards.push(`
        <div class="recordStatusCard clean">
          <i class="fa-solid fa-shield-heart"></i>
          <div class="recordStatusText">
            <span class="recordStatusTitle">Clean Standing</span>
            <span class="recordStatusDetail">No active sentence right now</span>
          </div>
        </div>
      `);
    }
    currentEl.innerHTML = statusCards.join('');

    // History
    if (!record.history || record.history.length === 0) {
      historyEl.innerHTML = `
        <div class="emptyState">
          <i class="fa-solid fa-file-circle-check"></i>
          <span>No punishment history on record</span>
        </div>
      `;
      return;
    }

    historyEl.innerHTML = `
      <div class="recordHistoryTitle">HISTORY (LAST ${record.history.length})</div>
      <div class="recordHistoryList">
        ${record.history.map(entry => {
          const meta = typeMeta[entry.type] || { label: entry.type, icon: 'fa-file-lines' };
          const durationLabel = entry.type === 'jail'
            ? `${entry.duration ?? '?'}m`
            : `${entry.duration ?? '?'} action(s)`;
          return `
            <div class="recordHistoryRow ${entry.type}">
              <i class="fa-solid ${meta.icon}"></i>
              <div class="recordHistoryText">
                <span class="recordHistoryReason">${entry.reason || meta.label}</span>
                <span class="recordHistoryMeta">${meta.label} • ${durationLabel} • by ${(entry.issuedByName || 'Unknown').replace(/_/g, ' ')} • ${formatRecordDate(entry.date)}</span>
              </div>
            </div>
          `;
        }).join('')}
      </div>
    `;
  });
});
