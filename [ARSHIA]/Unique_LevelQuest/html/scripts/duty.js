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
  // native calendar popup across builds, so this draws its own month
  // grid instead. It also forces LTR internally (see .calPopup CSS)
  // regardless of the page's own dir="rtl" (html/index.html is a
  // Persian-language page) — without that override, the browser
  // mirrors the whole grid: weekday headers read "S F T W T M S"
  // instead of "S M T W T F S", day numbers run right-to-left, and
  // the prev/next month arrows swap sides, which is confusing for a
  // calendar specifically (dates read most naturally left-to-right
  // even inside an otherwise-RTL page).
  //
  // Supports RANGE selection: first click sets the start day, the
  // next click sets the end day (or moves the start day earlier if
  // you click before it) — matching how most calendar range pickers
  // behave. `onApply(startIso, endIso)` fires only once both ends are
  // picked and the Apply button is pressed, not on every click.
  function mountCalendar(popupEl, onApply) {
    const today = new Date();
    let viewYear = today.getFullYear();
    let viewMonth = today.getMonth();
    let rangeStart = null;
    let rangeEnd = null;

    const pad = n => String(n).padStart(2, '0');
    const toIso = (y, m, d) => `${y}-${pad(m + 1)}-${pad(d)}`;
    const monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    function dayClass(iso) {
      if (!iso) return '';
      if (iso === rangeStart || iso === rangeEnd) return ' selected';
      if (rangeStart && rangeEnd && iso > rangeStart && iso < rangeEnd) return ' in-range';
      return '';
    }

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
        cells += `<span class="calDay${isFuture ? ' disabled' : dayClass(iso)}" data-date="${isFuture ? '' : iso}">${d}</span>`;
      }

      const rangeLabel = rangeStart && rangeEnd
        ? `${rangeStart} → ${rangeEnd}`
        : rangeStart
          ? `${rangeStart} → …`
          : 'Pick a start and end day';

      popupEl.innerHTML = `
        <div class="calHeader">
          <button type="button" class="calNav" data-nav="-1"><i class="fa-solid fa-chevron-left"></i></button>
          <span class="calTitle">${monthNames[viewMonth]} ${viewYear}</span>
          <button type="button" class="calNav" data-nav="1" ${isCurrentOrFutureMonth ? 'disabled' : ''}><i class="fa-solid fa-chevron-right"></i></button>
        </div>
        <div class="calWeekdays">${['S', 'M', 'T', 'W', 'T', 'F', 'S'].map(w => `<span>${w}</span>`).join('')}</div>
        <div class="calGrid">${cells}</div>
        <div class="calRangeLabel">${rangeLabel}</div>
        <button type="button" class="calApplyBtn" ${(rangeStart && rangeEnd) ? '' : 'disabled'}>Apply</button>
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
          const iso = cell.dataset.date;
          if (!rangeStart || (rangeStart && rangeEnd)) {
            // Starting a fresh range.
            rangeStart = iso;
            rangeEnd = null;
          } else if (iso < rangeStart) {
            // Clicked before the current start — that becomes the new start.
            rangeStart = iso;
          } else {
            rangeEnd = iso;
          }
          render();
        });
      });

      const applyBtn = popupEl.querySelector('.calApplyBtn');
      applyBtn.addEventListener('click', () => {
        if (!rangeStart || !rangeEnd) return;
        onApply(rangeStart, rangeEnd);
      });
    }

    render();
  }

  function wireDatePicker(triggerBtn, popupEl, labelEl, onApply) {
    triggerBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      const willOpen = popupEl.classList.contains('hidden');
      document.querySelectorAll('.calPopup').forEach(p => p.classList.add('hidden'));
      if (willOpen) {
        popupEl.classList.remove('hidden');
        if (!popupEl.dataset.built) {
          popupEl.dataset.built = '1';
          mountCalendar(popupEl, (startIso, endIso) => {
            labelEl.textContent = startIso === endIso ? startIso : `${startIso} → ${endIso}`;
            popupEl.classList.add('hidden');
            onApply(startIso, endIso);
          });
        }
      }
    });
    popupEl.addEventListener('click', (e) => e.stopPropagation());
  }

  document.addEventListener('click', () => {
    document.querySelectorAll('.calPopup').forEach(p => p.classList.add('hidden'));
  });

  function requestRange(startIso, endIso) {
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
    fetch(`https://${resourceName}/checkDutyDate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ startDate: startIso, endDate: endIso }),
    });
  }

  function renderLeadershipBlock(duty) {
    rosterEl.innerHTML = `
      <div class="dutyRosterHead">
        <div class="dutyRosterTitle" id="dutyRosterTitle">${(duty.orgName || 'ORG').toUpperCase()} — TOP 5 (ALL-TIME)</div>
        <div class="dutyDatePicker">
          <button type="button" class="calTrigger" id="dutyDateTrigger">
            <i class="fa-solid fa-calendar-days"></i> <span id="dutyDateLabel">Pick a range</span>
          </button>
          <button type="button" id="dutyResetBtn" class="hidden" title="Back to top 5"><i class="fa-solid fa-rotate-left"></i></button>
          <div class="calPopup hidden" id="dutyCalPopup"></div>
        </div>
      </div>
      <div class="dutySearchRow">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="dutySearchInput" placeholder="Search an officer by name…" maxlength="50" />
      </div>
      <div id="dutyRosterBody">${renderRosterList(duty.roster, 'allSeconds')}</div>
    `;

    const titleEl = document.getElementById('dutyRosterTitle');
    const bodyEl = document.getElementById('dutyRosterBody');
    const resetBtn = document.getElementById('dutyResetBtn');
    const searchInput = document.getElementById('dutySearchInput');

    function showDefaultTop10() {
      titleEl.textContent = `${(duty.orgName || 'ORG').toUpperCase()} — TOP 5 (ALL-TIME)`;
      bodyEl.innerHTML = renderRosterList(duty.roster, 'allSeconds');
    }

    // Debounced search-as-you-type — the full org isn't loaded into
    // the NUI up front (could be dozens of members), so every search
    // is a fresh, small server query instead of filtering a giant
    // preloaded list client-side.
    let searchDebounce = null;
    searchInput.addEventListener('input', () => {
      clearTimeout(searchDebounce);
      const term = searchInput.value.trim();
      resetBtn.classList.add('hidden');
      if (term.length === 0) {
        showDefaultTop10();
        return;
      }
      searchDebounce = setTimeout(() => {
        titleEl.textContent = `SEARCHING "${term}"…`;
        const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
        fetch(`https://${resourceName}/searchDutyRoster`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ search: term }),
        });
      }, 350);
    });

    wireDatePicker(
      document.getElementById('dutyDateTrigger'),
      document.getElementById('dutyCalPopup'),
      document.getElementById('dutyDateLabel'),
      (startIso, endIso) => {
        searchInput.value = '';
        resetBtn.classList.remove('hidden');
        requestRange(startIso, endIso);
      }
    );

    resetBtn.addEventListener('click', () => {
      searchInput.value = '';
      showDefaultTop10();
      document.getElementById('dutyDateLabel').textContent = 'Pick a range';
      resetBtn.classList.add('hidden');
    });
  }

  function renderPersonalBlock(duty) {
    rosterEl.innerHTML = `
      <div class="dutyRosterHead">
        <div class="dutyRosterTitle">
          <i class="fa-solid fa-lock"></i>
          Team totals are visible to ${duty.orgName ? duty.orgName + ' ' : ''}leadership only — check your own range below.
        </div>
      </div>
      <div class="dutyDatePicker personal">
        <button type="button" class="calTrigger" id="dutyDateTrigger">
          <i class="fa-solid fa-calendar-days"></i> <span id="dutyDateLabel">Pick a range</span>
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
      (startIso, endIso) => {
        resultEl.innerHTML = `<div class="dutyLeadershipHint"><i class="fa-solid fa-spinner fa-spin"></i> Loading…</div>`;
        requestRange(startIso, endIso);
      }
    );
  }

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'dutySearchResult') {
      const result = data.result;
      const titleEl = document.getElementById('dutyRosterTitle');
      const bodyEl = document.getElementById('dutyRosterBody');
      const searchInput = document.getElementById('dutySearchInput');
      // Ignore a stale/late response if the search box was already
      // cleared (or the tab moved on) by the time this came back.
      if (!titleEl || !bodyEl || !searchInput || searchInput.value.trim().length === 0) return;
      if (!result || !result.ok) {
        titleEl.textContent = 'SEARCH FAILED';
        return;
      }
      titleEl.textContent = `SEARCH: "${searchInput.value.trim()}"`;
      bodyEl.innerHTML = renderRosterList(result.roster, 'allSeconds');
      return;
    }

    if (data.type === 'dutyDateResult') {
      const result = data.result;
      if (!result || !result.ok) return;

      const rangeLabel = result.startDate === result.endDate ? result.startDate : `${result.startDate} → ${result.endDate}`;

      if (result.mode === 'roster') {
        const titleEl = document.getElementById('dutyRosterTitle');
        const bodyEl = document.getElementById('dutyRosterBody');
        if (!titleEl || !bodyEl) return;
        titleEl.textContent = `${(result.orgName || 'ORG').toUpperCase()} — ${rangeLabel}`;
        bodyEl.innerHTML = renderRosterList(result.roster, 'seconds');
      } else if (result.mode === 'personal') {
        const resultEl = document.getElementById('dutyPersonalResult');
        if (!resultEl) return;
        resultEl.innerHTML = `
          <div class="dutyPersonalResultBox">
            <span class="dutyPersonalResultDate">${rangeLabel}</span>
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
