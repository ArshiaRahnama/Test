/*
  Bridge بین UI سان (که standalone ساخته شده) و صفحه‌ی مرکزی Unique_Event (iframe router).
  - وقتی منوی انتخاب اسپان باز میشه، به صفحه‌ی مرکزی خبر میده تا pointer-events فریم فعال بشه
    (بدون این، کلیک روی منو به UI نمی‌رسه).
  - کلید ESC روی منوی اسپان = دکمه‌ی Cancel (تو UI اصلی ESC هندل نشده بود و NUI focus گیر می‌کرد).
*/
(function () {
  var last = null;
  function post(visible) {
    if (visible === last) return;
    last = visible;
    try { window.parent.postMessage({ __frame: 'capture', __visible: visible }, '*'); } catch (e) {}
  }
  function check() { post(!!document.querySelector('.spawn-overlay')); }
  new MutationObserver(check).observe(document.documentElement, { childList: true, subtree: true });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    var cancel = document.querySelector('.spawn-overlay .cancel, .spawn-overlay .spawn-cancel, .spawn-overlay [class*="cancel"]');
    if (cancel) { e.preventDefault(); cancel.click(); }
  });
  check();
})();
