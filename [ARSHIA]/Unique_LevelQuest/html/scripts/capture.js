const captureRankStyles = {
  Bronze: { color: '#cd8b52', bg: 'rgba(205, 139, 82, 0.18)', border: 'rgba(205, 139, 82, 0.45)' },
  Silver: { color: '#d7dbe3', bg: 'rgba(215, 219, 227, 0.18)', border: 'rgba(215, 219, 227, 0.45)' },
  Gold: { color: '#ffd76a', bg: 'rgba(255, 215, 106, 0.18)', border: 'rgba(255, 215, 106, 0.45)' },
  Legend: { color: '#ff6bd6', bg: 'rgba(255, 107, 214, 0.18)', border: 'rgba(255, 107, 214, 0.45)' },
};

function fmtCaptureHours(h) {
  const hours = Math.max(0, Math.round(Number(h) || 0));
  if (hours < 24) return `${hours}h`;
  const days = Math.floor(hours / 24);
  const rem = hours % 24;
  return `${days}d ${rem}h`;
}

document.addEventListener('DOMContentLoaded', () => {
  const unavailableEl = document.getElementById('capture_unavailable');
  const bodyEl = document.getElementById('capture_body');
  const headerEl = document.querySelector('.capture-header');
  const summaryEl = document.querySelector('.capture-summary');
  const columnsEl = document.querySelector('.capture-columns');

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'loadCapture') return;

    if (!data.dashboard) {
      unavailableEl.classList.remove('hidden');
      bodyEl.classList.add('hidden');
      return;
    }

    unavailableEl.classList.add('hidden');
    bodyEl.classList.remove('hidden');

    const d = data.dashboard;
    const rank = d.myStats?.rank || 'Bronze';
    const rs = captureRankStyles[rank] || captureRankStyles.Bronze;

    headerEl.innerHTML = `
      <div class="captureRankBadge" style="color:${rs.color}; background:${rs.bg}; border-color:${rs.border}">
        <i class="fa-solid fa-crown"></i>
        <span>${rank}</span>
      </div>
      <div class="captureScoreBlock">
        <span class="captureScoreValue">${d.myStats?.score ?? 0}</span>
        <span class="captureScoreLabel">score</span>
      </div>
      <div class="captureSeasonBlock">
        <span class="captureSeasonTitle">Season ${d.season?.number ?? 1}</span>
        <span class="captureSeasonSub">${fmtCaptureHours(d.season?.hours_remaining)} remaining</span>
      </div>
      ${d.hallOfFame ? `<div class="captureHofBadge"><i class="fa-solid fa-star"></i> Hall of Fame</div>` : ''}
    `;

    const s = d.myStats || {};
    summaryEl.innerHTML = `
      <div class="captureChip"><i class="fa-solid fa-skull"></i><div class="captureChipText"><span class="captureChipValue">${s.kills ?? 0}</span><span class="captureChipLabel">kills</span></div></div>
      <div class="captureChip"><i class="fa-solid fa-heart-crack"></i><div class="captureChipText"><span class="captureChipValue">${s.deaths ?? 0}</span><span class="captureChipLabel">deaths</span></div></div>
      <div class="captureChip highlight"><i class="fa-solid fa-flag-checkered"></i><div class="captureChipText"><span class="captureChipValue">${s.gang_points ?? 0}</span><span class="captureChipLabel">gang points</span></div></div>
      <div class="captureChip"><i class="fa-solid fa-medal"></i><div class="captureChipText"><span class="captureChipValue">${s.top5 ?? 0}</span><span class="captureChipLabel">top-5 finishes</span></div></div>
    `;

    const medalIcons = ['🥇', '🥈', '🥉'];

    const zonesList = (d.myZones || []).length
      ? (d.myZones || []).map(z => `
          <div class="captureListRow">
            <span class="captureListName">${z.zone_name}</span>
            <span class="captureListValue">${z.points} pts</span>
          </div>
        `).join('')
      : `<div class="captureEmptyRow">No zone activity yet</div>`;

    const killersList = (d.topKillers || []).length
      ? (d.topKillers || []).map((k, i) => `
          <div class="captureListRow${i < 3 ? ' top' + (i + 1) : ''}">
            <span class="captureListRank">${medalIcons[i] || (i + 1)}</span>
            <span class="captureListName">${(k.name || '').replace(/_/g, ' ')}</span>
            <span class="captureListValue">${k.kills} kills</span>
          </div>
        `).join('')
      : `<div class="captureEmptyRow">No kills recorded yet</div>`;

    const gangList = (d.gangStandings || []).length
      ? (d.gangStandings || []).map((g, i) => `
          <div class="captureListRow${i < 3 ? ' top' + (i + 1) : ''}">
            <span class="captureListRank">${medalIcons[i] || (i + 1)}</span>
            <span class="captureListName">${g.gang_name}</span>
            <span class="captureListValue">${g.points} pts</span>
          </div>
        `).join('')
      : `<div class="captureEmptyRow">No gang activity yet</div>`;

    const medalsBlock = d.medals?.enabled ? `
      <div class="captureColumn">
        <div class="captureColumnTitle"><i class="fa-solid fa-medal"></i> SCARCE MEDALS (${d.medals.minted}/${d.medals.supply})</div>
        ${(d.medals.mine || []).length
          ? d.medals.mine.map(m => `
              <div class="captureListRow">
                <span class="captureListName">Season ${m.season_number}</span>
                <span class="captureListValue">#${m.serial_number}</span>
              </div>
            `).join('')
          : `<div class="captureEmptyRow">You don't own one yet</div>`}
      </div>
    ` : '';

    columnsEl.innerHTML = `
      <div class="captureColumn">
        <div class="captureColumnTitle"><i class="fa-solid fa-crosshairs"></i> TOP KILLERS</div>
        ${killersList}
      </div>
      <div class="captureColumn">
        <div class="captureColumnTitle"><i class="fa-solid fa-people-group"></i> GANG STANDINGS</div>
        ${gangList}
      </div>
      <div class="captureColumn">
        <div class="captureColumnTitle"><i class="fa-solid fa-map-pin"></i> MY TOP ZONES</div>
        ${zonesList}
      </div>
      ${medalsBlock}
    `;
  });
});
