function animateXpBar(fillElement, targetPercentage, duration = 800) {
  if (!fillElement) return;
  const startWidth = parseFloat(fillElement.style.width) || 0;
  const startTime = performance.now();

  function updateFrame(now) {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const currentWidth = startWidth + (targetPercentage - startWidth) * progress;
    fillElement.style.width = `${currentWidth}%`;
    if (progress < 1) requestAnimationFrame(updateFrame);
  }
  requestAnimationFrame(updateFrame);
}

// Tracks the last known level so we can tell a genuine level-up (while
// the menu is open, live-refreshed every 30s) apart from just loading
// the current value for the first time.
let lastKnownLevel = undefined;

window.addEventListener('message', (event) => {
  const data = event.data;

  if (data.type === 'updateProfile') {
    const nameElem = document.querySelector('.name_span');
    const jobElem = document.querySelector('.job_span');
    const gangElem = document.querySelector('.gang_span');
    const cashElem = document.querySelector('.cash_span');
    const bankElem = document.querySelector('.bank_span');
    const coinElem = document.querySelector('.coin_span');
    const memberSinceElem = document.querySelector('.memberSince_span');
    const ibanElem = document.querySelector('.iban_span');
    const accountNumElem = document.querySelector('.accountNum_span');
    const levelElem = document.querySelector('.level-number');
    const xpFractionElem = document.querySelector('.xp-fraction');
    const xpFillElem = document.querySelector('.xp-fill');

    if (nameElem) nameElem.textContent = data.name || 'Unknown';
    if (jobElem) jobElem.textContent = data.job || 'Unknown';
    if (gangElem) gangElem.textContent = data.gang || 'Unknown';
    if (cashElem) cashElem.textContent = (data.cash ?? 0).toLocaleString();
    if (bankElem) bankElem.textContent = (data.bank ?? 0).toLocaleString();
    if (coinElem) coinElem.textContent = data.coin ?? 'Unknown';
    if (memberSinceElem) memberSinceElem.textContent = data.memberSince || '-';
    if (ibanElem) ibanElem.textContent = data.iban ? `IBAN ${data.iban}` : 'IBAN —';
    if (accountNumElem) accountNumElem.textContent = data.accountNum ? `ACC #${data.accountNum}` : 'ACC #—';

    updatePaycheckCountdown(data.paycheckSeconds, data.hasJob);

    if (levelElem && data.level !== undefined) {
      levelElem.textContent = data.level;

      const newLevel = Number(data.level);
      if (lastKnownLevel !== undefined && newLevel > lastKnownLevel) {
        const lvBox = document.querySelector('.lvBox');
        if (typeof spawnConfetti === 'function') spawnConfetti(lvBox);
        if (typeof playChime === 'function') playChime();
        if (typeof showPromotionCinematic === 'function') showPromotionCinematic(newLevel);
        if (lvBox) {
          lvBox.classList.add('levelUpFlash');
          setTimeout(() => lvBox.classList.remove('levelUpFlash'), 900);
        }
      }
      lastKnownLevel = newLevel;
    }

    if (xpFractionElem && data.xpCurrent !== undefined && data.xpNeeded !== undefined) {
      xpFractionElem.textContent = `${data.xpCurrent}/${data.xpNeeded}`;
    }

    if (xpFillElem && data.xpPercent !== undefined) {
      const percent = Math.max(0, Math.min(100, parseInt(data.xpPercent)));
      animateXpBar(xpFillElem, percent);
    }

    setImageOrFallback(document.getElementById('avatarImg'), data.avatarUrl);
    setImageOrFallback(document.getElementById('gangIcon'), data.gangLogoUrl);
    setLocalJobIcon(document.getElementById('jobIcon'), data.jobName);

    // Cached for the compare-players feature (compare.js) — no extra
    // server round trip needed for "your own" side of the comparison.
    window.__ownStats = {
      name: data.name,
      level: data.level,
      xp: data.xpCurrent,
      coin: data.coinRaw,
      hours: data.hours,
    };
  }
});

function setImageOrFallback(el, url) {
  if (!el) return;
  if (url) {
    el.style.backgroundImage = `url('${url}')`;
    el.classList.add('hasImage');
  } else {
    el.style.backgroundImage = '';
    el.classList.remove('hasImage');
  }
}

window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.type !== 'myTier') return;

  const avatarWrap = document.querySelector('.avatarWrap');
  if (!avatarWrap) return;

  avatarWrap.classList.remove('tier1', 'tier2', 'tier3');
  if (data.tier) avatarWrap.classList.add(`tier${data.tier}`);
});

let paycheckSecondsLeft = null;
let paycheckTickHandle = null;

function formatPaycheckTime(totalSeconds) {
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${m}:${s.toString().padStart(2, '0')} until paycheck`;
}

function updatePaycheckCountdown(secondsFromServer, hasJob) {
  const el = document.querySelector('.paycheck_span');
  if (!el) return;

  if (paycheckTickHandle) {
    clearInterval(paycheckTickHandle);
    paycheckTickHandle = null;
  }

  if (hasJob === false) {
    // Covers two real cases: no job at all, OR a job whose current
    // grade has 0 salary (essentialmode never fires 'esx:givesalary'
    // for either — see client/menu.lua) so there's genuinely nothing
    // to count down to here.
    el.textContent = 'No paycheck (unpaid job)';
    return;
  }

  if (secondsFromServer === undefined || secondsFromServer === null) {
    // Genuinely not a bug: this waits for the FIRST real
    // 'esx:givesalary' tick (client/bridges.lua), which follows
    // essentialmode's own 15-minute payroll timer — one that started
    // counting whenever essentialmode itself last started, NOT when
    // this player joined or when this resource was last restarted.
    // Restarting Unique_LevelQuest resets this client-side flag, so
    // it will show this again for up to 15 minutes after every
    // restart even for an already-paid job, until that independent
    // timer comes back around.
    el.textContent = 'Syncing (up to 15 min after restart)...';
    return;
  }

  paycheckSecondsLeft = secondsFromServer;
  el.textContent = formatPaycheckTime(paycheckSecondsLeft);

  paycheckTickHandle = setInterval(() => {
    paycheckSecondsLeft = Math.max(0, paycheckSecondsLeft - 1);
    el.textContent = formatPaycheckTime(paycheckSecondsLeft);
    if (paycheckSecondsLeft <= 0) {
      clearInterval(paycheckTickHandle);
      paycheckTickHandle = null;
    }
  }, 1000);
}

// Real per-job images shipped locally (img/job/<jobname>.png). Not every
// job has one, so we test-load it first — if it 404s, the icon fallback
// stays instead of showing a broken image.
function setLocalJobIcon(el, jobName) {
  if (!el) return;
  el.style.backgroundImage = '';
  el.classList.remove('hasImage');
  if (!jobName) return;

  const path = `img/job/${jobName}.png`;
  const test = new Image();
  test.onload = () => {
    el.style.backgroundImage = `url('${path}')`;
    el.classList.add('hasImage');
  };
  test.onerror = () => {
    // no matching image for this job, keep the icon fallback
  };
  test.src = path;
}
