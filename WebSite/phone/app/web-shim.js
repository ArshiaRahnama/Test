/* ==========================================================================
   Web phone shim — runs only on the website (phone/app/index.php).
   1) every NUI call ($.post) goes to api.php instead of the game
   2) the Discord app opens straight away (there is no phone home screen here)
   3) on a phone the app fills the screen and the channel list becomes a drawer
   ========================================================================== */
(function () {
  var meta = document.querySelector('meta[name="dx-csrf"]');
  var token = meta ? meta.getAttribute('content') : '';

  function request(ep, data, cb) {
    var body = typeof data === 'string' ? data : JSON.stringify(data || {});
    fetch('api.php?ep=' + encodeURIComponent(ep), {
      method: 'POST',
      credentials: 'same-origin',
      headers: { 'Content-Type': 'application/json', 'X-CSRF': token },
      body: body
    }).then(function (r) { return r.ok ? r.json() : false; })
      .catch(function () { return false; })
      .then(function (res) { if (typeof cb === 'function') cb(res); });
  }
  window.DX_WEB = { request: request };

  function installPost() {
    if (!window.jQuery) return false;
    window.jQuery.post = function (url, data, cb) {
      if (typeof data === 'function') { cb = data; data = {}; }
      request(String(url).split('/').pop(), data, cb);
      var thenable = { done: function () { return thenable; }, fail: function () { return thenable; }, always: function () { return thenable; } };
      return thenable;
    };
    return true;
  }

  function webOnly() {
    // the phone has no close / staff / settings-from-game bits on the website
    window.Discord_Close = function () { /* the app stays open on the website */ };
    window.Discord_ShowLoginScreen = function () {
      var box = document.getElementById('dx-web-login');
      if (!box) {
        box = document.createElement('div');
        box.id = 'dx-web-login';
        box.innerHTML = '<div><i class="fab fa-discord"></i><h2>Set up Discord in the game first</h2>' +
          '<p>Open the Discord app on your in-game phone once and sign in with your mailbox code. After that this page shows the same account.</p></div>';
        document.getElementById('discord-backdrop').appendChild(box);
      }
      box.style.display = 'flex';
    };
    var header = document.querySelector('.discord-chat-header');
    if (header && !document.getElementById('dx-web-menu')) {
      var b = document.createElement('i');
      b.id = 'dx-web-menu'; b.className = 'fas fa-bars';
      b.setAttribute('title', 'Channels');
      header.insertBefore(b, header.firstChild);
    }
  }

  function boot() {
    webOnly();
    request('GetDiscordMyProfile', {}, function (p) {
      if (!p || !p.displayName) {
        document.getElementById('discord-backdrop').insertAdjacentHTML('beforeend', '<div id="dx-web-login" style="display:flex"><div><i class="fab fa-discord"></i><h2>Discord</h2><p>Your account is not linked to a character yet.</p></div></div>');
        return;
      }
      if (window.Discord_Init) Discord_Init(p.displayName);
    });
  }

  $(document).on('click', '#dx-web-menu', function () { $('#discord-backdrop').toggleClass('dx-web-nav-open'); });
  $(document).on('click', '.discord-channel-item', function () { $('#discord-backdrop').removeClass('dx-web-nav-open'); });

  function start() {
    installPost();
    window.addEventListener('load', function () {
      if (!window.Discord_Init) { setTimeout(boot, 300); return; }
      boot();
    });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start); else start();
})();
