/**
 * Unique_GunGame HUD
 * Relays NUI messages sent from client.lua into DOM updates for the
 * countdown, round timer, live scoreboard, and kill-feed toasts.
 */

// Must match the CSS animation timing in style.css (0.18s in + 3.6s hold + 0.4s out)
const KILLFEED_ITEM_LIFETIME_MS = 4000;
const KILLFEED_MAX_ITEMS = 5;
const TIMER_URGENT_THRESHOLD_SECONDS = 30;

const countdownEl = document.getElementById('countdown');
const countdownNumberEl = countdownEl.querySelector('.countdown-number');

const timerEl = document.getElementById('timer');
const timerValueEl = timerEl.querySelector('.timer-value');

const scoreboardEl = document.getElementById('scoreboard');
const scoreboardRowsEl = document.getElementById('scoreboard-rows');

const killfeedEl = document.getElementById('killfeed');

function formatTime(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
}

function renderScoreboard(players) {
    scoreboardRowsEl.innerHTML = '';
    players.forEach((player) => {
        const row = document.createElement('div');
        row.className = `scoreboard-row rank-${player.rank}`;
        row.innerHTML = `
            <span class="rank">${player.rank}</span>
            <span class="name">${player.name}</span>
            <span class="level">Lv${player.level + 1}</span>
            <span class="kills">${player.kills}</span>
        `;
        scoreboardRowsEl.appendChild(row);
    });
}

function addKillFeed(killer, victim) {
    const item = document.createElement('div');
    item.className = 'killfeed-item';
    item.innerHTML = `${killer} <span class="victim">➔ ${victim}</span>`;
    killfeedEl.appendChild(item);

    setTimeout(() => item.remove(), KILLFEED_ITEM_LIFETIME_MS);

    // keep the feed from growing unbounded if kills come in faster than the fade-out
    while (killfeedEl.children.length > KILLFEED_MAX_ITEMS) {
        killfeedEl.removeChild(killfeedEl.firstChild);
    }
}

window.addEventListener('message', (event) => {
    const data = event.data;

    switch (data.action) {
        case 'showCountdown':
            countdownEl.classList.remove('hidden');
            countdownNumberEl.textContent = data.seconds;
            break;

        case 'hideCountdown':
            countdownEl.classList.add('hidden');
            break;

        case 'showTimer':
            timerEl.classList.remove('hidden');
            timerValueEl.textContent = formatTime(data.seconds);
            timerValueEl.classList.toggle('urgent', data.seconds <= TIMER_URGENT_THRESHOLD_SECONDS);
            break;

        case 'hideTimer':
            timerEl.classList.add('hidden');
            break;

        case 'showScoreboard':
            scoreboardEl.classList.remove('hidden');
            break;

        case 'hideScoreboard':
            scoreboardEl.classList.add('hidden');
            break;

        case 'updateScoreboard':
            renderScoreboard(data.players);
            break;

        case 'addKillFeed':
            addKillFeed(data.killer, data.victim);
            break;
    }
});
