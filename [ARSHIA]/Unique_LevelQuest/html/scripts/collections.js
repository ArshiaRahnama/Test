// Real GTA V primary vehicle paint indices -> hex, from the game's own
// standard color list (widely published/documented). Not every one of
// the ~160 indices is included; unmapped ones fall back to a neutral
// gray swatch with the raw index shown instead of a guessed color.
const GTA_COLORS = {
  0: '#0d222f', 1: '#28322e', 2: '#425c72', 3: '#152731', 4: '#182226',
  5: '#8e8f7f', 6: '#8b7e6a', 7: '#503f42', 8: '#0f4056', 9: '#82898a',
  10: '#c0c0c0', 11: '#f0f0f0', 12: '#08316f', 13: '#5f7e8b', 27: '#8a0000',
  28: '#4d0304', 29: '#1a0505', 38: '#f5c101', 39: '#c69700', 49: '#013220',
  64: '#c0c0c0', 66: '#d4d4d4', 70: '#141414', 88: '#ffffff', 111: '#7a1010',
  128: '#8b0000', 147: '#2e2e2e',
};

function colorSwatchStyle(idx) {
  return GTA_COLORS[idx] || '#4a4d55';
}

const WINDOW_TINTS = {
  0: 'None', 1: 'Pure Black', 2: 'Dark Smoke', 3: 'Light Smoke', 4: 'Stock', 5: 'Limo', 6: 'Smoke',
};

function buildModDetails(v) {
  const modLabel = (val) => (val === undefined || val === null || val < 0) ? 'Stock' : `Level ${val + 1}`;
  const tintLabel = WINDOW_TINTS[v.windowTint] ?? 'Unknown';

  return `
    <div class="vehDetails">
      <div class="vehColors">
        <span class="colorSwatch" style="background:${colorSwatchStyle(v.color1)}" title="Primary color #${v.color1 ?? '?'}"></span>
        <span class="colorSwatch" style="background:${colorSwatchStyle(v.color2)}" title="Secondary color #${v.color2 ?? '?'}"></span>
      </div>
      <div class="vehModGrid">
        <span>Engine: ${modLabel(v.modEngine)}</span>
        <span>Brakes: ${modLabel(v.modBrakes)}</span>
        <span>Transmission: ${modLabel(v.modTransmission)}</span>
        <span>Suspension: ${modLabel(v.modSuspension)}</span>
        <span>Armor: ${modLabel(v.modArmor)}</span>
        <span>Turbo: ${v.modTurbo ? 'Yes' : 'No'}</span>
      </div>
      <div class="vehTint">Window Tint: ${tintLabel}</div>
    </div>
  `;
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
        card.className = `imgCard clickable ${status.cls}`;

        const fuelPct = Math.max(0, Math.min(100, Number(v.fuel) || 0));

        card.innerHTML = `
          <div class="cap">
            ${v.name}<br><small>${v.plate}</small>
            <span class="garageStatus ${status.cls}">${status.label}</span>
            <div class="fuelRow">
              <i class="fa-solid fa-gas-pump"></i>
              <div class="fuelBar"><div class="fuelFill" style="width:${fuelPct}%"></div></div>
              <span class="fuelPct">${fuelPct}%</span>
            </div>
          </div>
          <div class="expandHint"><i class="fa-solid fa-chevron-down"></i></div>
          ${buildModDetails(v)}
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

        card.addEventListener('click', () => card.classList.toggle('expanded'));

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
            ${h.name}
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
