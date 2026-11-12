function escapeHtml(v) {
  return String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

// ---- Vehicle image loading: throttled + viewport-gated ----
// This was the actual source of the lag on opening this tab: every
// vehicle card built its <img> with a docs.fivem.net URL up front, and
// `loading="lazy"` only skips images that are OFF-screen — with a big
// garage, most/all cards are already inside the visible grid the
// instant the tab opens, so it still fired a dozen-plus simultaneous
// external HTTPS requests through the in-game CEF browser at once,
// which is what stutters/hitches the frame. Now:
//   1) an IntersectionObserver only starts loading an image once its
//      card is actually about to scroll into view (not just "offscreen
//      vs not" like the `loading` attribute), and
//   2) at most MAX_CONCURRENT_IMG_LOADS load at the same time; the rest
//      queue and start as earlier ones finish.
// A small session cache also remembers which slugs already resolved
// (image found / not found), so reopening this tab later in the same
// game session never re-fetches or re-stutters on the same vehicles.
const MAX_CONCURRENT_IMG_LOADS = 4;
const imgResultCache = new Map(); // slug -> 'ok' | 'fail'
const imgLoadQueue = [];
let activeImgLoads = 0;

function pumpImgQueue() {
  while (activeImgLoads < MAX_CONCURRENT_IMG_LOADS && imgLoadQueue.length > 0) {
    const job = imgLoadQueue.shift();
    activeImgLoads++;
    job();
  }
}

function showCarIcon(mediaWrap) {
  mediaWrap.classList.add('cardIcon');
  mediaWrap.innerHTML = '<i class="fa-solid fa-car-side"></i>';
}

function loadVehicleImage(mediaWrap, slug) {
  const cached = imgResultCache.get(slug);
  if (cached === 'fail') { showCarIcon(mediaWrap); return; }

  if (cached === 'ok') {
    // Already confirmed to exist this session — just render it, no
    // need to wait for a free queue slot.
    const img = document.createElement('img');
    img.className = 'cardImg';
    img.src = `https://docs.fivem.net/vehicles/${slug}.webp`;
    mediaWrap.appendChild(img);
    return;
  }

  imgLoadQueue.push(() => {
    const img = document.createElement('img');
    img.className = 'cardImg';
    const finish = (result) => {
      imgResultCache.set(slug, result);
      activeImgLoads--;
      pumpImgQueue();
    };
    img.addEventListener('load', () => finish('ok'), { once: true });
    img.addEventListener('error', () => { showCarIcon(mediaWrap); finish('fail'); }, { once: true });
    img.src = `https://docs.fivem.net/vehicles/${slug}.webp`;
    mediaWrap.appendChild(img);
  });
  pumpImgQueue();
}

const pendingImgSlugs = new WeakMap(); // placeholder element -> slug
const imgObserver = new IntersectionObserver((entries, obs) => {
  entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    obs.unobserve(entry.target);
    const slug = pendingImgSlugs.get(entry.target);
    if (slug) loadVehicleImage(entry.target, slug);
  });
}, { rootMargin: '200px' });

document.addEventListener('DOMContentLoaded', () => {
  const vehGrid = document.getElementById('veh_grid');
  const vehEmpty = document.getElementById('veh_empty');
  const houseGrid = document.getElementById('house_grid');
  const houseEmpty = document.getElementById('house_empty');
  const vehCount = document.getElementById('veh_count');
  const houseCount = document.getElementById('house_count');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadVehicles' && Array.isArray(data.vehicles)) {
      // Drop any not-yet-visible observations from the previous render —
      // their placeholder elements are about to be destroyed below.
      imgObserver.disconnect();
      vehGrid.innerHTML = '';
      vehEmpty.classList.toggle('hidden', data.vehicles.length > 0);
      if (vehCount) vehCount.textContent = data.vehicles.length;

      const statusMap = {
        0: { label: 'OUT', cls: 'status-out' },
        1: { label: 'IN GARAGE', cls: 'status-garage' },
        2: { label: 'IMPOUNDED', cls: 'status-impound' },
      };

      data.vehicles.forEach(v => {
        const card = document.createElement('div');
        const status = statusMap[v.stored] ?? statusMap[0];
        card.className = `imgCard ${status.cls}`;

        card.innerHTML = `
          <div class="cap">
            ${escapeHtml(v.name)}<br><small>${escapeHtml(v.plate)}</small>
            <span class="garageStatus ${status.cls}">${status.label}</span>
          </div>
        `;

        // Real preview images from FiveM's public vehicle database —
        // deferred to the throttled/viewport-gated loader above instead
        // of fetching all of them the instant this tab opens (see the
        // big comment near the top of this file for why).
        let mediaEl;
        if (v.slug) {
          mediaEl = document.createElement('div');
          mediaEl.className = 'cardMedia';
          card.prepend(mediaEl);
          pendingImgSlugs.set(mediaEl, v.slug);
          imgObserver.observe(mediaEl);
        } else {
          mediaEl = document.createElement('div');
          mediaEl.className = 'cardMedia cardIcon';
          mediaEl.innerHTML = '<i class="fa-solid fa-car-side"></i>';
          card.prepend(mediaEl);
        }

        vehGrid.appendChild(card);
      });
    }

    if (data.type === 'loadHouses' && Array.isArray(data.houses)) {
      houseGrid.innerHTML = '';
      houseEmpty.classList.toggle('hidden', data.houses.length > 0);
      if (houseCount) houseCount.textContent = data.houses.length;

      data.houses.forEach(h => {
        const card = document.createElement('div');
        card.className = 'imgCard houseCard';

        const hasCoords = h.x !== undefined && h.x !== null && h.y !== undefined && h.y !== null;
        card.innerHTML = `
          <div class="cardMedia cardIcon houseIcon"><i class="fa-solid fa-house"></i></div>
          <div class="cap">
            ${escapeHtml(h.name)}
            ${hasCoords ? `<button class="waypointBtn"><i class="fa-solid fa-location-dot"></i> Show on Map</button>` : ''}
          </div>
        `;

        if (hasCoords) {
          const btn = card.querySelector('.waypointBtn');
          btn.addEventListener('click', () => {
            const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'unknown_resource';
            fetch(`https://${resourceName}/setWaypoint`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ x: h.x, y: h.y, label: h.name }),
            });
          });
        }

        houseGrid.appendChild(card);
      });
    }
  });
});
