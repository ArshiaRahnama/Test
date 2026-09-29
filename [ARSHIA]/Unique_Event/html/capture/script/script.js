const slots = {
  1: document.getElementById('slot-1'),
  2: document.getElementById('slot-2'),
  3: document.getElementById('slot-3'),
  4: document.getElementById('slot-4'),
};

const timeouts = {
  1: null,
  2: null,
  3: null,
  4: null,
};

let queue = [];

function clearSlot(i) {
  const slot = slots[i];
  clearTimeout(timeouts[i]);
  slot.classList.remove('animate');
  slot.classList.add('fade-out');

  setTimeout(() => {
    slot.innerHTML = '';
    slot.style.display = 'none';
    slot.classList.remove('fade-out');
    timeouts[i] = null;

    if (queue.length > 0) {
      const next = queue.shift();
      setSlot(i, next);
    }
  }, 500);
}

function setSlot(i, contentHTML) {
  const slot = slots[i];
  clearTimeout(timeouts[i]);

  slot.innerHTML = contentHTML;
  slot.style.display = 'block';
  slot.classList.remove('fade-out');
  slot.classList.add('animate');

  timeouts[i] = setTimeout(() => {
    clearSlot(i);
  }, 5000);
}

function addKillLog(contentHTML) {
  for (let i = 1; i <= 4; i++) {
    if (!timeouts[i]) {
      setSlot(i, contentHTML);
      return;
    }
  }

  queue.push(contentHTML);
}

window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.action === 'newKill') {
    let killer = data.killer || 'Unknown';
    let damaged = data.damaged || 'Unknown';
    const weapon = data.weapon || 'pistol';
    const team1 = data.team1 || 'self';
    const team2 = data.team2 || 'self';

    
    killer = killer.length > 7 ? killer.substring(0, 7) + '...' : killer;
    damaged = damaged.length > 7 ? damaged.substring(0, 7) + '...' : damaged;

    const pistolIconDisplay = weapon === 'pistol' ? 'block' : 'none';
    const rifleIconDisplay = weapon === 'rifle' ? 'block' : 'none';

    const player1Class = team1 === 'team' ? 'team' : team1 === 'enemy' ? 'enemy' : 'self';
    const player2Class = team2 === 'team' ? 'team' : team2 === 'enemy' ? 'enemy' : 'self';

    const content = `
      <div class="back"></div>
      <div class="damaged ${player2Class}">
        <span class="damaged_span">${damaged}</span>
      </div>
      <div class="killer ${player1Class}">
        <span class="killer_span">${killer}</span>
      </div>
      <img class="pistol-icon" src="img/Pistol-Icon.png" style="display: ${pistolIconDisplay};" />
      <img class="rifle-icon" src="img/Rifle-Icon.png" style="display: ${rifleIconDisplay};" />
    `;

    addKillLog(content);
  }


  else if (data.action === 'changeShow') {
    if (data.hide){
      document.querySelector('.data-box').style.display = 'none';
    }
    else{
      document.querySelector('.data-box').style.display = 'block';
    }
      
     
         
  }
  else if (data.action === 'listKiller') {
      
      document.querySelector('.playercallback1_span').textContent = data.playercallback1 || 'N/A';
      document.querySelector('.playercallback2_span').textContent = data.playercallback2 || 'N/A';
      document.querySelector('.playercallback3_span').textContent = data.playercallback3 || 'N/A';
      document.querySelector('.playercallback4_span').textContent = data.playercallback4 || 'N/A';
      document.querySelector('.playercallback5_span').textContent = data.playercallback5 || 'N/A';

      document.querySelector('.pointcallback1_span').textContent = data.pointcallback1 || 'N/A';
      document.querySelector('.pointcallback2_span').textContent = data.pointcallback2 || 'N/A';
      document.querySelector('.pointcallback3_span').textContent = data.pointcallback3 || 'N/A';
      document.querySelector('.pointcallback4_span').textContent = data.pointcallback4 || 'N/A';
      document.querySelector('.pointcallback5_span').textContent = data.pointcallback5 || 'N/A';

      document.querySelector('.time_span').textContent = data.time || 'N/A';



      
  }
});

document.addEventListener('keydown', function(event) {
  if (event.keyCode === 81) {
      const dataBox = document.querySelector('.data-box');
      
      if (dataBox.style.display === 'none') {
          dataBox.style.display = 'block';
      } else {
          dataBox.style.display = 'none';
      }
  }
});