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

document.addEventListener('DOMContentLoaded', () => {
  const vehGrid = document.getElementById('veh_grid');
  const vehEmpty = document.getElementById('veh_empty');
  const houseGrid = document.getElementById('house_grid');
  const houseEmpty = document.getElementById('house_empty');

  window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.type === 'loadVehicles' && Array.isArray(data.vehicles)) {
      vehGrid.innerHTML = '';
      vehEmpty.classList.toggle('hidden', data.vehicles.length > 0);

      data.vehicles.forEach(v => {
        const card = document.createElement('div');
        card.className = 'imgCard clickable';

        const statusMap = {
          0: { label: 'OUT', cls: 'status-out' },
          1: { label: 'IN GARAGE', cls: 'status-garage' },
          2: { label: 'IMPOUNDED', cls: 'status-impound' },
        };
        const status = statusMap[v.stored] ?? statusMap[0];
        const fuelPct = Math.max(0, Math.min(100, Number(v.fuel) || 0));

        card.innerHTML = `
          <div class="cap">
            ${v.name}<br><small>${v.plate}</small>
            <span class="garageStatus ${status.cls}">${status.label}</span>
            <div class="fuelBar"><div class="fuelFill" style="width:${fuelPct}%"></div></div>
          </div>
          ${buildModDetails(v)}
        `;

        // Real preview images from FiveM's public vehicle database, using
        // a native <img loading="lazy"> instead of preloading everything
        // up front — the browser only fetches what actually scrolls into
        // view, instead of firing 15-20 requests the instant the menu
        // opens. onerror swaps back to the icon for models that aren't
        // in that database (custom/addon cars).
        let mediaEl;
        if (v.slug) {
          mediaEl = document.createElement('img');
          mediaEl.className = 'cardImg';
          mediaEl.loading = 'lazy';
          mediaEl.src = `https://docs.fivem.net/vehicles/${v.slug}.webp`;
          mediaEl.addEventListener('error', () => {
            const fallback = document.createElement('div');
            fallback.className = 'cardIcon';
            fallback.innerHTML = '<i class="fa-solid fa-car-side"></i>';
            mediaEl.replaceWith(fallback);
          });
        } else {
          mediaEl = document.createElement('div');
          mediaEl.className = 'cardIcon';
          mediaEl.innerHTML = '<i class="fa-solid fa-car-side"></i>';
        }
        card.prepend(mediaEl);

        card.addEventListener('click', () => card.classList.toggle('expanded'));

        vehGrid.appendChild(card);
      });
    }

    if (data.type === 'loadHouses' && Array.isArray(data.houses)) {
      houseGrid.innerHTML = '';
      houseEmpty.classList.toggle('hidden', data.houses.length > 0);

      data.houses.forEach(h => {
        const card = document.createElement('div');
        card.className = 'imgCard';

        const hasCoords = h.x !== undefined && h.x !== null && h.y !== undefined && h.y !== null;
        card.innerHTML = `
          <div class="cardIcon"><i class="fa-solid fa-house"></i></div>
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
