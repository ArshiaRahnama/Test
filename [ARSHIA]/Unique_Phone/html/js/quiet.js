/* Unique Phone - quiet NUI console.
   The phone logs "[unique_phone] rpc ...", "[unique_phone] perf: ..." and similar to the F8 console. They are hidden unless
   window.UNIQUE_DEBUG = true (type it in the NUI devtools). console.error and real exceptions are NOT touched. */
(function () {
  'use strict';
  ['log', 'info', 'warn', 'debug'].forEach(function (k) {
    var raw = console[k];
    if (typeof raw !== 'function') return;
    console[k] = function () {
      var a = arguments[0];
      if (!window.UNIQUE_DEBUG && typeof a === 'string' && a.indexOf('[unique_phone]') !== -1) return;
      return raw.apply(console, arguments);
    };
  });
})();
