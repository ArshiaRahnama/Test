document.addEventListener('DOMContentLoaded', () => {
  const lists = {
    players: document.getElementById('lb_players_list'),
    gangs: document.getElementById('lb_gangs_list'),
  };

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'loadLeaderboard' || !Array.isArray(data.entries)) return;

    const list = lists[data.board];
    if (!list) return;

    list.innerHTML = '';
    data.entries.forEach(entry => {
      const row = document.createElement('div');
      row.className = 'boardRow';
      if (entry.position <= 3) row.classList.add(`top${entry.position}`);

      let statsHtml;
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
      }

      row.innerHTML = `
        <span class="boardPos">#${entry.position}</span>
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
