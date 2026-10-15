// Performance: the menu re-requests data every 30s while open. When the
// payload is byte-identical to the last one of the same type, skip the
// re-render entirely (no DOM rebuild, no image reloads, no scroll/filter
// reset). Must load BEFORE the other scripts so it runs first.
(function () {
  const DEDUPE = new Set(['loadSkills', 'loadDuty', 'loadRecord', 'loadLeaderboard',
    'loadEvents', 'loadGangWatch', 'loadQuests']);
  const last = {};
  window.addEventListener('message', function (e) {
    const d = e.data;
    if (!d || !DEDUPE.has(d.type)) return;
    let s;
    try { s = JSON.stringify(d); } catch (_) { return; }
    if (last[d.type] === s) { e.stopImmediatePropagation(); return; }
    last[d.type] = s;
  }, true);
  // fresh open → always re-render once so stale DOM can never stick around
  window.addEventListener('message', function (e) {
    if (e.data && e.data.type === 'openMenu') { for (const k in last) delete last[k]; }
  }, true);
})();
