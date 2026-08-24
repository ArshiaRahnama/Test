function updateAdminDutyStatus(isOnDuty) {
  const dutyElem = document.getElementById('adminDuty');
  const adminPanel = document.getElementById('admin');

  if (!dutyElem || !adminPanel) return;

  if (isOnDuty === true) {
    dutyElem.style.display = 'inline-block';
    adminPanel.style.display = 'flex';
    dutyElem.textContent = 'Off Duty';
    dutyElem.classList.remove('on');
    dutyElem.classList.add('off');
  } else if (isOnDuty === false) {
    dutyElem.style.display = 'inline-block';
    adminPanel.style.display = 'none';
    dutyElem.textContent = 'On Duty';
    dutyElem.classList.remove('off');
    dutyElem.classList.add('on');
  } else {
    dutyElem.style.display = 'none';
    adminPanel.style.display = 'none';
  }
}

function createPlayerElement(player) {
  const playerItem = document.createElement('div');
  playerItem.className = 'player-item';

  playerItem.innerHTML = `
    <div class="player-info">
      <div class="player-id">ID: ${player.id}</div>
      <div class="player-name">${player.name}</div>
    </div>
    <div class="player-dropdown">
      <button class="spect-btn">Spectate</button>
      <button class="goto-btn">Goto</button>
      <button class="freeze-btn">Freeze</button>
    </div>
  `;

  const playerInfo = playerItem.querySelector('.player-info');
  const dropdown = playerItem.querySelector('.player-dropdown');

  playerInfo.addEventListener('click', function (e) {
    e.stopPropagation();
    document.querySelectorAll('.player-item').forEach(item => {
      if (item !== playerItem) item.classList.remove('active');
    });
    playerItem.classList.toggle('active');
  });

  document.addEventListener('click', function () {
    playerItem.classList.remove('active');
  });

  dropdown.addEventListener('click', function (e) {
    e.stopPropagation();
  });

  ['spect-btn', 'goto-btn', 'freeze-btn'].forEach(action => {
    const btn = playerItem.querySelector(`.${action}`);
    btn.addEventListener('click', function () {
      playerItem.classList.remove('active');

      const resource = window.GetParentResourceName
        ? window.GetParentResourceName()
        : 'unknown';

      fetch(`https://${resource}/playerAction`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: action.replace('-btn', ''), // 'spect', 'goto', 'freeze'
          id: player.id
        })
      });
    });
  });

  return playerItem;
}

window.addEventListener('message', function (event) {
  const data = event.data;

  if (data.type === 'adminDutyStatus') {
    updateAdminDutyStatus(data.status);
  }

  if (data.type === 'loadPlayers' && Array.isArray(data.players)) {
    const playersGrid = document.querySelector('.players-grid');
    if (!playersGrid) return;

    playersGrid.innerHTML = ''; // clear previous list
    data.players.forEach(player => {
      const playerElem = createPlayerElement(player);
      playersGrid.appendChild(playerElem);
    });
  }
});

document.addEventListener('DOMContentLoaded', function () {
  const dutyElem = document.getElementById('adminDuty');
  if (dutyElem) {
    dutyElem.addEventListener('click', function () {
      const resource = window.GetParentResourceName
        ? window.GetParentResourceName()
        : 'unknown';

      fetch(`https://${resource}/toggleDuty`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ clicked: true })
      });
    });
  }
});
