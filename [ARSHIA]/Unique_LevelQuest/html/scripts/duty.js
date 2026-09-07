document.addEventListener('DOMContentLoaded', () => {
  const dutyTabBtn = document.getElementById('dutyTabBtn');
  const summaryEl = document.querySelector('.duty-summary');
  const rosterEl = document.querySelector('.duty-roster');

  function formatDuration(totalSeconds) {
    const s = Math.max(0, Number(totalSeconds) || 0);
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    if (h <= 0) return `${m}m`;
    return `${h}h ${m}m`;
  }

  const medalIcons = ['🥇', '🥈', '🥉'];

  function renderRosterList(rows, valueKey) {
    if (!rows || rows.length === 0) {
      return `<div class="dutyLeadershipHint"><i class="fa-solid fa-users"></i> No recorded duty time for this period.</div>`;
    }
    return `
      <div class="dutyRosterList">
        ${rows.map((r, i) => `
          <div class="dutyRosterRow${i < 3 ? ' top' + (i + 1) : ''}">
            <span class="dutyRosterRank">${medalIcons[i] || (i + 1)}</span>
            <span class="dutyRosterName">${(r.name || '').replace(/_/g, ' ')}</span>
            <span class="dutyRosterValue">${formatDuration(r[valueKey])}</span>
          </div>
        `).join('')}
      </div>
    `;
  }

  // Self-contained calendar dropdown — NOT a native <input type="date">.
  // FiveM's NUI browser (CEF) is inconsistent about rendering the
  // native calendar popup for date inputs across builds, so this
  // draws its own month grid instead, guaranteed to work the same
  // way everywhere. `onPick(isoDateString)` fires when a day is
  // clicked; disables days after today.
  function mountCalendar(popupEl, onPick) {
    const today = new Date();
    let viewYear = today.getFullYear();
    let viewMonth = today.getMonth();
    let selectedIso = null;

    const pad = n => String(n).padStart(2, '0');
    const toIso = (y, m, d) => `${y}-${pad(m + 1)}-${pad(d)}`;
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    function render() {
      const firstWeekday = new Date(viewYear, viewMonth, 1).getDay();
      const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
      const isCurrentOrFutureMonth = viewYear > today.getFullYear() || (viewYear === today.getFullYear() && viewMonth >= today.getMonth());

      let cells = '';
      for (let i = 0; i < firstWeekday; i++) cells += `<span class="calDay empty"></span>`;
      for (let d = 1; d <= daysInMonth; d++) {
        const iso = toIso(viewYear, viewMonth, d);
        const cellDate = new Date(viewYear, viewMonth, d);
        const isFuture = cellDate > today;
        const isSelected = selectedIso === iso;
        cells += `<span class="calDay${isFuture ? ' disabled' : ''}${isSelected ? ' selected' : ''}" data-date="${isFuture ? '' : iso}">${d}</span>`;
      }

      popupEl.innerHTML = `
        <div class="calHeader">
          <button type="button" class="calNav" data-nav="-1"><i class="fa-solid fa-chevron-left"></i></button>
          <span class="calTitle">${monthNames[viewMonth]} ${viewYear}</span>
          <button type="button" class="calNav" data-nav="1" ${isCurrentOrFutureMonth ? 'disabled' : ''}><i class="fa-solid fa-chevron-right"></i></button>
        </div>
        <div class="calWeekdays">${['S', 'M', 'T', 'W', 'T', 'F', 'S'].map(w => `<span>${w}</span>`).join('')}</div>
        <div class="calGrid">${cells}</div>
      `;

      popupEl.querySelectorAll('.calNav').forEach(btn => {
        btn.addEventListener('click', () => {
          if (btn.disabled) return;
          viewMonth += Number(btn.dataset.nav);
          if (viewMonth < 0) { viewMonth = 11; viewYear--; }
          if (viewMonth > 11) { viewMonth = 0; viewYear++; }
          render();
        });
      });

      popupEl.querySelectorAll('.calDay:not(.empty):not(.disabled)').forEach(cell => {
        cell.addEventListener('click', () => {
          selectedIso = cell.dataset.date;
          render();
          onPick(selectedIso);
        });
      });
    }

    render();
  }

  function wireDatePicker(triggerBtn, popupEl, labelEl, onPick) {
    triggerBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      const willOpen = popupEl.classList.contains('hidden');
      document.querySelectorAll('.calPopup').forEach(p => p.classList.add('hidden'));
      if (willOpen) {
        popupEl.classList.remove('hidden');
        if (!popupEl.dataset.built) {
          popupEl.dataset.built = '1';
          mountCalendar(popupEl, (iso) => {
            labelEl.textContent = iso;
            popupEl.classList.add('hidden');
            onPick(iso);
          });
        }
      }
    });
  }

  document.addEventListener('click', () => {
    document.querySelectorAll('.calPopup').forEach(p => p.classList.add('hidden'));
  });

  function requestDate(iso) {
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
    fetch(`https://${resourceName}/checkDutyDate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ date: iso }),
    });
  }

  function renderLeadershipBlock(duty) {
    rosterEl.innerHTML = `
      <div class="dutyRosterHead">
        <div class="dutyRosterTitle" id="dutyRosterTitle">${(duty.orgName || 'ORG').toUpperCase()} — ALL-TIME HOURS</div>
        <div class="dutyDatePicker">
          <button type="button" class="calTrigger" id="dutyDateTrigger">
            <i class="fa-solid fa-calendar-days"></i> <span id="dutyDateLabel">Pick a date</span>
          </button>
          <button type="button" id="dutyResetBtn" class="hidden" title="Back to all-time"><i class="fa-solid fa-rotate-left"></i></button>
          <div class="calPopup hidden" id="dutyCalPopup"></div>
        </div>
      </div>
      <div id="dutyRosterBody">${renderRosterList(duty.roster, 'allSeconds')}</div>
    `;

    const titleEl = document.getElementById('dutyRosterTitle');
    const bodyEl = document.getElementById('dutyRosterBody');
    const resetBtn = document.getElementById('dutyResetBtn');

    wireDatePicker(
      document.getElementById('dutyDateTrigger'),
      document.getElementById('dutyCalPopup'),
      document.getElementById('dutyDateLabel'),
      requestDate
    );

    resetBtn.addEventListener('click', () => {
      titleEl.textContent = `${(duty.orgName || 'ORG').toUpperCase()} — ALL-TIME HOURS`;
      bodyEl.innerHTML = renderRosterList(duty.roster, 'allSeconds');
      document.getElementById('dutyDateLabel').textContent = 'Pick a date';
      resetBtn.classList.add('hidden');
    });
  }

  function renderPersonalBlock(duty) {
    rosterEl.innerHTML = `
      <div class="dutyRosterHead">
        <div class="dutyRosterTitle">
          <i class="fa-solid fa-lock"></i>
          Team totals are visible to ${duty.orgName ? duty.orgName + ' ' : ''}leadership only — check your own day below.
        </div>
      </div>
      <div class="dutyDatePicker personal">
        <button type="button" class="calTrigger" id="dutyDateTrigger">
          <i class="fa-solid fa-calendar-days"></i> <span id="dutyDateLabel">Pick a date</span>
        </button>
        <div class="calPopup hidden" id="dutyCalPopup"></div>
      </div>
      <div id="dutyPersonalResult"></div>
    `;

    const resultEl = document.getElementById('dutyPersonalResult');

    wireDatePicker(
      document.getElementById('dutyDateTrigger'),
      document.getElementById('dutyCalPopup'),
      document.getElementById('dutyDateLabel'),
      (iso) => {
        resultEl.innerHTML = `<div class="dutyLeadershipHint"><i class="fa-solid fa-spinner fa-spin"></i> Loading…</div>`;
        requestDate(iso);
      }
    );
  }

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'dutyDateResult') {
      const result = data.result;
      if (!result || !result.ok) return;

      if (result.mode === 'roster') {
        const titleEl = document.getElementById('dutyRosterTitle');
        const bodyEl = document.getElementById('dutyRosterBody');
        const resetBtn = document.getElementById('dutyResetBtn');
        if (!titleEl || !bodyEl) return;
        titleEl.textContent = `${(result.orgName || 'ORG').toUpperCase()} — ${result.date}`;
        bodyEl.innerHTML = renderRosterList(result.roster, 'seconds');
        if (resetBtn) resetBtn.classList.remove('hidden');
      } else if (result.mode === 'personal') {
        const resultEl = document.getElementById('dutyPersonalResult');
        if (!resultEl) return;
        resultEl.innerHTML = `
          <div class="dutyPersonalResultBox">
            <span class="dutyPersonalResultDate">${result.date}</span>
            <span class="dutyPersonalResultValue">${formatDuration(result.seconds)}</span>
          </div>
        `;
      }
      return;
    }

    if (data.type !== 'loadDuty' || !data.duty) return;
    const duty = data.duty;

    if (!duty.isMember) {
      if (dutyTabBtn.classList.contains('active')) {
        document.querySelector('.tab[data-tab="quests"]')?.click();
      }
      dutyTabBtn.classList.add('hidden');
      return;
    }

    dutyTabBtn.classList.remove('hidden');

    summaryEl.innerHTML = `
      <div class="dutyChip">
        <i class="fa-solid fa-sun"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.todaySeconds)}</span>
          <span class="dutyChipLabel">today</span>
        </div>
      </div>
      <div class="dutyChip">
        <i class="fa-solid fa-calendar-week"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.weekSeconds)}</span>
          <span class="dutyChipLabel">last 7 days</span>
        </div>
      </div>
      <div class="dutyChip highlight">
        <i class="fa-solid fa-infinity"></i>
        <div class="dutyChipText">
          <span class="dutyChipValue">${formatDuration(duty.allSeconds)}</span>
          <span class="dutyChipLabel">all-time</span>
        </div>
      </div>
    `;

    if (duty.isLeadership && Array.isArray(duty.roster)) {
      renderLeadershipBlock(duty);
    } else {
      renderPersonalBlock(duty);
    }
  });
});
