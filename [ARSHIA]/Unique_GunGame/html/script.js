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
const countdownBarEl = countdownEl.querySelector('.countdown-bar');

const timerEl = document.getElementById('timer');
const timerValueEl = timerEl.querySelector('.timer-value');

const scoreboardEl = document.getElementById('scoreboard');
const scoreboardRowsEl = document.getElementById('scoreboard-rows');

const killfeedEl = document.getElementById('killfeed');

const mvpScreenEl = document.getElementById('mvp-screen');
const mvpCallingCardEl = document.getElementById('mvp-callingcard');
const mvpNameEl = document.getElementById('mvp-name');
const mvpKillsEl = document.getElementById('mvp-kills');
let mvpHideTimeout = null;

function escapeHtml(text) {
    return String(text)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

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
            <span class="name">${escapeHtml(player.name)}</span>
            <span class="level">Lv${player.level + 1}</span>
            <span class="kills">${player.kills}</span>
        `;
        scoreboardRowsEl.appendChild(row);
    });
}

function addKillFeed(killer, victim) {
    const item = document.createElement('div');
    item.className = 'killfeed-item';
    item.innerHTML = `${escapeHtml(killer)} <span class="victim">➔ ${escapeHtml(victim)}</span>`;
    killfeedEl.appendChild(item);

    setTimeout(() => item.remove(), KILLFEED_ITEM_LIFETIME_MS);

    // keep the feed from growing unbounded if kills come in faster than the fade-out
    while (killfeedEl.children.length > KILLFEED_MAX_ITEMS) {
        killfeedEl.removeChild(killfeedEl.firstChild);
    }
}

function showMVP(name, kills, card) {
    mvpNameEl.textContent = escapeHtml(name);
    mvpKillsEl.textContent = `${kills} KILLS`;

    if (card) {
        mvpCallingCardEl.style.backgroundImage = `url(callingcards/${encodeURIComponent(card)})`;
        mvpCallingCardEl.classList.add('has-image');
    } else {
        mvpCallingCardEl.style.backgroundImage = '';
        mvpCallingCardEl.classList.remove('has-image');
    }

    mvpScreenEl.classList.remove('hidden');
    if (mvpHideTimeout) clearTimeout(mvpHideTimeout);
}

function hideMVP() {
    mvpScreenEl.classList.add('hidden');
    if (mvpHideTimeout) clearTimeout(mvpHideTimeout);
}

function playSound(sound, volume) {
    if (!sound) return;
    try {
        const audio = new Audio(sound);
        audio.volume = (typeof volume === 'number') ? Math.max(0, Math.min(1, volume)) : 0.5;
        audio.play().catch(() => {
            // Autoplay can be blocked before any user interaction with the page;
            // safe to ignore since GunGame audio is just a nice-to-have.
        });
    } catch (err) {
        console.error('Unique_GunGame: failed to play sound', sound, err);
    }
}

window.addEventListener('message', (event) => {
    const data = event.data;

    switch (data.action) {
        case 'showCountdown':
            countdownEl.classList.remove('hidden');
            countdownNumberEl.textContent = data.seconds;
            if (data.total > 0) {
                countdownBarEl.style.width = `${Math.max(0, Math.min(100, (data.seconds / data.total) * 100))}%`;
            }
            break;

        case 'hideCountdown':
            countdownEl.classList.add('hidden');
            countdownBarEl.style.transition = 'none';
            countdownBarEl.style.width = '100%';
            void countdownBarEl.offsetWidth; // force reflow before re-enabling the transition
            countdownBarEl.style.transition = '';
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

        case 'showMVP':
            showMVP(data.name, data.kills, data.card);
            break;

        case 'hideMVP':
            hideMVP();
            break;

        case 'playSound':
            playSound(data.sound, data.volume);
            break;
    }
});
