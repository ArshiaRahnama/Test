// UNIQUE_AC Hub — service worker.
// Scope is deliberately small: cache the app shell so it opens instantly and
// still shows *something* offline, and enable "Add to Home Screen". This does
// NOT implement Web Push — see README.md for why real-time alerts go through
// Discord instead of hand-rolled browser push crypto.

const CACHE_NAME = 'uniqueac-hub-v1';
const SHELL_FILES = ['./', './index.html', './style.css', './app.js', './manifest.json', './icon.svg'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(SHELL_FILES))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  // Never cache API calls — they must always be fresh.
  if (event.request.url.includes('api-servers.php')) return;

  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request))
  );
});
